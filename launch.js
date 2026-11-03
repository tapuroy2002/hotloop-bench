const {spawn}=require('node:child_process');
const fs=require('node:fs');
const path=require('node:path');
const root=path.resolve(__dirname);
const url='http://127.0.0.1:4173';
const sleep=ms=>new Promise(resolve=>setTimeout(resolve,ms));

async function health(){try{const r=await fetch(url+'/api/health',{signal:AbortSignal.timeout(700)});return r.ok?await r.json():null}catch{return null}}
async function openBrowser(){
  if(process.platform==='win32')spawn('cmd.exe',['/c','start','',url],{cwd:root,detached:true,stdio:'ignore',windowsHide:true}).unref();
  else if(process.platform==='darwin')spawn('open',[url],{detached:true,stdio:'ignore'}).unref();
  else spawn('xdg-open',[url],{detached:true,stdio:'ignore'}).unref();
}
const same=(a,b)=>process.platform==='win32'?String(a).toLowerCase()===String(b).toLowerCase():a===b;
(async()=>{
  let h=await health();
  if(h&&!same(h.root,root)){
    // Port 4173 is held by a dashboard from a different (probably older) copy of Hotloop. Replace it.
    console.log('Stopping an older Hotloop dashboard'+(h.root?' from '+h.root:'')+' ...');
    try{process.kill(h.pid)}catch{}
    for(let i=0;i<20&&await health();i++)await sleep(250);
    h=await health();
    if(h)throw Error('Another Hotloop dashboard is still using port 4173. Run stop.bat in its folder, then try again.');
  }
  if(!h){
    const logDir=path.join(root,'build','logs');fs.mkdirSync(logDir,{recursive:true});
    const log=fs.openSync(path.join(logDir,'server.log'),'w');
    const child=spawn(process.execPath,[path.join(root,'server.js')],{cwd:root,detached:true,stdio:['ignore',log,log],windowsHide:true});
    child.unref();
    let started=false;
    for(let i=0;i<40;i++){if(await health()){started=true;break}await sleep(250)}
    if(!started)throw Error('Dashboard server did not start. Details: build\\logs\\server.log (is port 4173 used by another program?)');
  }
  console.log('Dashboard is ready at '+url);
  if(process.env.HOTLOOP_NO_OPEN!=='1')await openBrowser();
})().catch(e=>{console.error(e.message);process.exitCode=1});
