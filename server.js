'use strict';
const http = require('node:http');
const fs = require('node:fs');
const path = require('node:path');
const { spawn } = require('node:child_process');

const root = path.resolve(__dirname);
const port = Number(process.env.PORT || 4173);
const pidFile = path.join(root, '.hotloop-server.pid');
const allowed = new Set(['c','cpp','rust','go','java','csharp','kotlin','swift','dart','javascript','python','ruby','php']);
const mime = {'.html':'text/html; charset=utf-8','.css':'text/css; charset=utf-8','.js':'text/javascript; charset=utf-8','.json':'application/json; charset=utf-8','.txt':'text/plain; charset=utf-8'};
// Only these files are served; everything else (scripts, generator, binaries, pid file) stays private.
const publicFiles = new Set(['/index.html','/app.js','/reference.js','/styles.css','/results.txt','/build_status.txt']);
const okHosts = new Set([`127.0.0.1:${port}`, `localhost:${port}`]);
const okOrigins = new Set([...okHosts].map(h => 'http://' + h));
let active = false;
let activeOutput = '';
let activeChild = null;

// Kill the runner and everything it started (bash -> compiler/benchmark process).
function killTree(child) {
  if (!child || child.exitCode !== null) return;
  if (process.platform === 'win32') spawn('taskkill', ['/pid', String(child.pid), '/T', '/F'], { windowsHide: true });
  else { try { process.kill(-child.pid, 'SIGTERM'); } catch { try { child.kill('SIGTERM'); } catch {} } }
}

function send(res, code, value, type='application/json; charset=utf-8') {
  if (res.headersSent || res.destroyed) return;
  res.writeHead(code, {
    'content-type': type,
    'cache-control': 'no-store',
    'x-content-type-options': 'nosniff',
    'referrer-policy': 'no-referrer',
    'content-security-policy': "default-src 'self'; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; font-src 'self' https://fonts.gstatic.com; script-src 'self'; connect-src 'self'; img-src 'self' data:"
  });
  res.end(type.startsWith('application/json') ? JSON.stringify(value) : value);
}
function readBody(req) {
  return new Promise((resolve,reject)=>{
    let body='', settled=false;
    req.on('data',chunk=>{
      if(settled)return;
      body+=chunk.toString('utf8');
      if(Buffer.byteLength(body)>4096){settled=true;reject(new Error('Request is too large'));req.pause();}
    });
    req.on('end',()=>{if(settled)return;try{resolve(JSON.parse(body||'{}'))}catch{reject(new Error('Invalid request body'))}});
    req.on('error',e=>{if(!settled)reject(e)});
  });
}
function runnerCommand() {
  if(process.platform!=='win32')return 'bash';
  const options=[process.env.HOTLOOP_BASH,'C:\\Program Files\\Git\\bin\\bash.exe','C:\\Program Files (x86)\\Git\\bin\\bash.exe'].filter(Boolean);
  return options.find(fs.existsSync)||'bash';
}
const server=http.createServer(async(req,res)=>{
  let url;
  try { url=new URL(req.url,'http://127.0.0.1:'+port); }
  catch { return send(res,400,{error:'Invalid URL'}); }
  // Block DNS-rebinding (foreign Host header) and cross-site requests from other web pages.
  if(!okHosts.has(String(req.headers.host||'').toLowerCase()))return send(res,403,{error:'Forbidden host.'});
  if(req.method!=='GET'&&req.method!=='HEAD'){
    if(!okOrigins.has(String(req.headers.origin||'')))return send(res,403,{error:'Cross-origin request is not allowed.'});
    if(!String(req.headers['content-type']||'').startsWith('application/json'))return send(res,415,{error:'Expected application/json.'});
  }
  if(req.method==='GET'&&url.pathname==='/api/health')return send(res,200,{ok:true,active,pid:process.pid,root,version:2});
  if(req.method==='GET'&&url.pathname==='/api/run/status')return send(res,200,{active,output:activeOutput});
  if(req.method==='POST'&&url.pathname==='/api/run/cancel'){
    if(!active||!activeChild)return send(res,409,{error:'No benchmark is running.'});
    killTree(activeChild);return send(res,200,{ok:true});
  }
  if(req.method==='POST'&&url.pathname==='/api/run'){
    if(active)return send(res,409,{error:'A benchmark is already running.'});
    let body;try{body=await readBody(req)}catch(e){return send(res,400,{error:e.message})}
    if(!body||typeof body!=='object'||Array.isArray(body))return send(res,400,{error:'Expected a JSON object.'});
    const langs=Array.isArray(body.languages)?body.languages:[];
    if(langs.some(x=>typeof x!=='string'||!allowed.has(x)))return send(res,400,{error:'Unknown language selection.'});
    const rounds=body.rounds===undefined?3:body.rounds;
    if(!Number.isInteger(rounds)||rounds<1||rounds>5)return send(res,400,{error:'Rounds must be a whole number from 1 to 5.'});
    active=true;
    activeOutput='';
    const bash=runnerCommand();
    let child;
    try { child=spawn(bash,['run_all.sh',...langs],{cwd:root,windowsHide:true,shell:false,detached:process.platform!=='win32',env:{...process.env,HOTLOOP_ROUNDS:String(rounds)}}); activeChild=child; }
    catch(e){active=false;return send(res,500,{error:'Could not start benchmark runner: '+e.message});}
    let output='',responded=false,timedOut=false,closed=false;
    const append=x=>{output+=x.toString();if(output.length>1_000_000)output=output.slice(-1_000_000);activeOutput=output;};
    child.stdout.on('data',append);child.stderr.on('data',append);
    const finish=(code,error)=>{
      if(responded)return;responded=true;clearTimeout(timer);active=false;activeChild=null;activeOutput=output;
      const results=fs.existsSync(path.join(root,'results.txt'))?fs.readFileSync(path.join(root,'results.txt'),'utf8'):'';
      const status=fs.existsSync(path.join(root,'build_status.txt'))?fs.readFileSync(path.join(root,'build_status.txt'),'utf8'):'';
      send(res,error?504:200,{ok:!error&&code===0,code,output,results,status,...(error?{error}:{})});
    };
    const timer=setTimeout(()=>{timedOut=true;killTree(child);setTimeout(()=>{if(!closed)try{process.platform==='win32'?killTree(child):process.kill(-child.pid,'SIGKILL')}catch{}},3000).unref();},30*60*1000);
    child.on('error',e=>finish(null,'Could not start benchmark runner: '+e.message+'. Install Git for Windows or set HOTLOOP_BASH to bash.exe.'));
    child.on('close',code=>{closed=true;finish(code,timedOut?'Benchmark exceeded the 30-minute timeout.':null)});
    return;
  }
  if(req.method!=='GET'&&req.method!=='HEAD')return send(res,405,{error:'Method not allowed'});
  let requested;
  try { requested=decodeURIComponent(url.pathname==='/'?'/index.html':url.pathname); }
  catch { return send(res,400,{error:'Invalid path encoding'}); }
  if(requested.includes('\0'))return send(res,400,{error:'Invalid path'});
  if(!publicFiles.has(requested))return send(res,404,{error:'Not found'});
  const file=path.resolve(root,'.'+requested);
  if(file!==root&&!file.startsWith(root+path.sep))return send(res,403,{error:'Forbidden'});
  fs.stat(file,(err,stat)=>{
    if(err||!stat.isFile())return send(res,404,{error:'Not found'});
    fs.readFile(file,(readErr,content)=>{if(readErr)return send(res,500,{error:'Could not read file'});send(res,200,content,mime[path.extname(file)]||'application/octet-stream')});
  });
});
server.requestTimeout=15000;
server.headersTimeout=10000;
server.listen(port,'127.0.0.1',()=>{fs.writeFileSync(pidFile,String(process.pid));console.log(`Hotloop dashboard: http://127.0.0.1:${port}`)});
server.on('close',()=>{try{if(fs.readFileSync(pidFile,'utf8')===String(process.pid))fs.unlinkSync(pidFile)}catch{}});
const shutdown=()=>{killTree(activeChild);server.close(()=>process.exit(0));setTimeout(()=>process.exit(0),2000).unref();};
process.on('SIGTERM',shutdown);
process.on('SIGINT',shutdown);
