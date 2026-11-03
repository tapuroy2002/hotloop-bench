const fs=require('node:fs');
const path=require('node:path');
const pidPath=path.join(__dirname,'.hotloop-server.pid');
(async()=>{
  let pid;try{pid=Number(fs.readFileSync(pidPath,'utf8'))}catch{console.log('Hotloop dashboard is not running.');return}
  let health;try{health=await(await fetch('http://127.0.0.1:4173/api/health')).json()}catch{}
  if(!health||health.pid!==pid){try{fs.unlinkSync(pidPath)}catch{};console.log('No Hotloop server is running on port 4173.');return}
  try{
    process.kill(pid,'SIGTERM');
    for(let i=0;i<20;i++){
      await new Promise(resolve=>setTimeout(resolve,100));
      try{await fetch('http://127.0.0.1:4173/api/health',{signal:AbortSignal.timeout(200)})}catch{break}
    }
    try{fs.unlinkSync(pidPath)}catch{}
    console.log('Hotloop dashboard stopped.');
  }catch(e){console.error('Could not stop dashboard: '+e.message);process.exitCode=1}
})()
