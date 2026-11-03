const fs=require('node:fs');
const resultPath=process.argv[2]||'results.txt';
const refs=JSON.parse(fs.readFileSync('generator/cfg.json','utf8')).groups;
const lines=fs.readFileSync(resultPath,'utf8').trimEnd().split(/\r?\n/);
const weakest=new Map();
for(const line of lines){
  const p=line.split('|');
  if(p.length!==6||p[0]!=='HOTLOOP'||!(p[2] in refs))continue;
  const [,lang,group,ms,ok]=p;
  const value=ok==='1'?1000*refs[group][1]/Number(ms):.001;
  if(Number.isFinite(value)&&(!weakest.has(lang)||value<weakest.get(lang).score))weakest.set(lang,{score:value,group});
}
for(const [lang,w]of [...weakest].sort(([a],[b])=>a.localeCompare(b)))fs.appendFileSync(resultPath,`HOTLOOP|${lang}|worst|${w.score.toFixed(1)}|${w.group}\n`);
