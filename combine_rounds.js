// Combines several rounds of HOTLOOP output into one result per language, so a slow moment
// (background app, CPU clocking down) in one round does not change the score.
// Usage: node combine_rounds.js <rounds-file> <results-file>
//   Per group: the best (lowest) time over all rounds; a group passes only if it passed in every round.
//   Score: geometric mean of 1000 * reference_ms / best_ms, the same formula the programs use.
// Appends HOTLOOP lines plus "# consistency" lines to <results-file> and prints a summary.
const fs = require('node:fs');
const [roundsPath, resultPath] = process.argv.slice(2);
const refs = JSON.parse(fs.readFileSync('generator/cfg.json', 'utf8')).groups;
const order = [], langs = new Map();
for (const line of fs.readFileSync(roundsPath, 'utf8').split(/\r?\n/)) {
  const p = line.trim().split('|');
  if (p[0] !== 'HOTLOOP' || p.length < 5) continue;
  const [, lang, group, val, ok, checksum] = p;
  if (!langs.has(lang)) { langs.set(lang, {groups: new Map(), roundScores: []}); order.push(lang); }
  const L = langs.get(lang);
  if (group === 'score') { const s = Number(val); if (Number.isFinite(s)) L.roundScores.push(s); continue; }
  if (!(group in refs)) continue;
  const ms = Number(val), g = L.groups.get(group);
  if (!g) L.groups.set(group, {ms, ok: ok === '1', checksum});
  else { if (ms < g.ms) g.ms = ms; g.ok = g.ok && ok === '1'; if (g.checksum !== checksum) g.ok = false; }
}
const geo = xs => Math.exp(xs.reduce((a, x) => a + Math.log(x), 0) / xs.length);
let out = '';
for (const lang of order) {
  const L = langs.get(lang), pts = [];
  let fails = 0;
  for (const group of Object.keys(refs)) {
    const g = L.groups.get(group);
    if (!g) continue;
    out += `HOTLOOP|${lang}|${group}|${g.ms.toFixed(3)}|${g.ok ? 1 : 0}|${g.checksum}\n`;
    if (!g.ok) fails++;
    pts.push(g.ok ? 1000 * refs[group][1] / g.ms : 0.001);
  }
  if (!pts.length) continue;
  const score = geo(pts);
  out += `HOTLOOP|${lang}|score|${score.toFixed(1)}|${fails}\n`;
  const rs = L.roundScores, n = rs.length;
  if (n > 1) {
    const sorted = [...rs].sort((a, b) => a - b), median = sorted[Math.floor(n / 2)];
    const spread = 100 * (sorted[n - 1] - sorted[0]) / median;
    out += `# consistency ${lang}: rounds ${rs.map(x => x.toFixed(1)).join(' ')}, spread ${spread.toFixed(1)}%\n`;
    console.log(`${lang.padEnd(11)} rounds ${rs.map(x => x.toFixed(1)).join(' / ')}  ->  score ${score.toFixed(1)} (best time per group)`);
    if (spread > 15) console.log(`  warning: ${lang} rounds differ by ${spread.toFixed(0)}%. Close heavy background apps (builds, IDEs, browsers), plug in the charger, and run again for a steadier score.`);
  }
}
fs.appendFileSync(resultPath, out);
