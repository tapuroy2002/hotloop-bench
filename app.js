'use strict';
/* hotloop dashboard */

// [display name, id used by run_all.sh, family]
const LANGS = [
  ['C','c','native'],['C++','cpp','native'],['Rust','rust','native'],['Go','go','native'],
  ['Java','java','JVM'],['C#','csharp','.NET'],['Kotlin','kotlin','JVM'],['Swift','swift','native'],
  ['Dart','dart','Dart VM / AOT'],['JavaScript','javascript','V8'],['Python','python','interpreter'],
  ['Ruby','ruby','interpreter'],['PHP','php','interpreter']
];
// reference milliseconds of C -O2 on the calibration machine (generator/cfg.json)
const REFS = {sorting:50,structures:35,graphs:39,dynamic:43,strings:52,compress:16,numeric:34,search:29};
const GROUPS = Object.keys(REFS);
const REF = window.HOTLOOP_REF || {ms:{},machine:'',derived:{}};
const KNOWN_STATUS = ['compile-passed','runtime-available','compile-failed','run-failed','unavailable','pending'];
// What to install when a language's toolchain is missing (official download pages).
const INSTALL = {
  c:['GCC (via MSYS2)','https://www.msys2.org/'], cpp:['G++ (via MSYS2)','https://www.msys2.org/'],
  rust:['Rust','https://rustup.rs/'], go:['Go','https://go.dev/dl/'], java:['a JDK','https://adoptium.net/'],
  csharp:['.NET SDK 8+','https://dotnet.microsoft.com/download'], kotlin:['Kotlin compiler','https://kotlinlang.org/docs/command-line.html'],
  swift:['Swift','https://www.swift.org/install/'], dart:['Dart SDK','https://dart.dev/get-dart'],
  javascript:['Node.js','https://nodejs.org/'], python:['Python','https://www.python.org/downloads/'],
  ruby:['Ruby','https://rubyinstaller.org/'], php:['PHP','https://windows.php.net/download/']
};
// Rough build time in seconds, only used for the "about N minutes" estimate.
const BUILD_SEC = {c:3, cpp:6, rust:25, go:8, java:4, csharp:15, kotlin:40, swift:30, dart:15};
const GROUP_INFO = {
  sorting:'9 sorting algorithms and selection', structures:'Heap, hash table, LRU cache, union-find, trees',
  graphs:'Shortest paths, spanning trees, max flow', dynamic:'Dynamic programming: edit distance, knapsack, TSP',
  strings:'Text search and suffix arrays', compress:'LZW, Huffman and BWT compression',
  numeric:'Number theory, big numbers, matrices', search:'N-queens, sudoku, A* path finding, game of life'
};
const reduceMotion = matchMedia('(prefers-reduced-motion: reduce)').matches;

const $ = s => document.querySelector(s);
const $$ = s => [...document.querySelectorAll(s)];
const esc = v => String(v ?? '').replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
const geo = xs => xs.length ? Math.exp(xs.reduce((a, x) => a + Math.log(x), 0) / xs.length) : null;
const fmt = (v, d = 1) => v == null ? '—' : v.toFixed(d);

// ---------- runner location ----------
const DASHBOARD = 'http://127.0.0.1:4173/';
const openedAsFile = location.protocol === 'file:';
// Served from a website (e.g. GitHub Pages) instead of the local runner: show results only, no running.
const onlineView = !openedAsFile && !['127.0.0.1', 'localhost'].includes(location.hostname);
const REPO = 'https://github.com/tapuroy2002/hotloop-bench';
const NO_RUNNER = openedAsFile
  ? 'This page was opened as a file, so it cannot run benchmarks. Double-click start.bat. It starts the runner and opens the dashboard at ' + DASHBOARD
  : 'Could not reach the local runner. Double-click start.bat (keep its window open), then reload this page.';
if (openedAsFile) {
  // A file:// page cannot talk to the runner. If the runner is already up, open the real dashboard instead.
  fetch(DASHBOARD + 'api/health', {mode:'no-cors', cache:'no-store'}).then(() => location.replace(DASHBOARD)).catch(() => {});
}

// ---------- state ----------
let data = {};          // measured results by display name
let statuses = {};      // build status by id
let sortBy = 'score', metric = 'score', showEst = true, firstPaint = true, pickerSeeded = false;
const open = new Set();

// ---------- parsing ----------
function parseResults(text) {
  const next = {}; let count = 0;
  for (const raw of text.split(/\r?\n/)) {
    const p = raw.trim().split('|');
    if (p[0] !== 'HOTLOOP' || p.length < 5) continue;
    const [, lang, name, val, ok, checksum] = p;
    if (!LANGS.some(([n]) => n === lang)) continue;
    next[lang] ??= {groups:{}, checks:{}, score:null};
    if (name === 'score') { const s = Number(val); if (Number.isFinite(s)) next[lang].score = s; continue; }
    if (!(name in REFS)) continue;
    const ms = Number(val);
    if (!Number.isFinite(ms) || ms <= 0) continue;
    next[lang].groups[name] = ms;
    next[lang].checks[name] = {ok: ok === '1', checksum};
    count++;
  }
  if (!count) throw Error('No benchmark rows found. Paste lines that start with HOTLOOP| from results.txt.');
  data = next;
  return count;
}
function parseStatus(text) {
  for (const row of text.split(/\r?\n/)) {
    const [key, value] = row.trim().split('|');
    if (key && value && LANGS.some(([, id]) => id === key) && KNOWN_STATUS.includes(value)) statuses[key] = value;
  }
}
function showRunDate(text) {
  const m = /^# hotloop run (\S+)/m.exec(text), d = m && new Date(m[1]);
  const cpu = (/^# cpu=(.+)$/m.exec(text) || [])[1];
  $('#run-date').textContent = (d && !isNaN(d)
    ? 'Results from ' + new Intl.DateTimeFormat(undefined, {dateStyle:'medium', timeStyle:'short'}).format(d) : '')
    + (cpu && cpu !== 'unknown' ? ' · ' + cpu.replace(/\s*@.*$/, '').replace(/\(R\)|\(TM\)/g, '') : '');
}

// ---------- model: measured + estimated ----------
// Per group, this machine's speed relative to the reference run, from languages measured here.
function machineFactors() {
  const f = {}, used = new Set();
  for (const g of GROUPS) {
    const ratios = [];
    for (const [name, d] of Object.entries(data)) {
      const refMs = REF.ms[name]?.[g];
      if (refMs && d.groups[g] && d.checks[g]?.ok) { ratios.push(d.groups[g] / refMs); used.add(name); }
    }
    f[g] = geo(ratios) ?? 1;
  }
  return {f, used:[...used]};
}
const groupScore = (g, ms) => 1000 * REFS[g] / ms;

function buildModel() {
  const {f, used} = machineFactors();
  const rows = LANGS.map(([name, id, family]) => {
    const d = data[name], st = statuses[id] || 'pending';
    const row = {name, id, family, status:st, groups:{}, kind:'none', score:null, fails:0};
    if (d && Object.keys(d.groups).length) {
      for (const g of GROUPS) {
        const ms = d.groups[g];
        if (ms == null) continue;
        const ok = d.checks[g]?.ok;
        if (!ok) row.fails++;
        row.groups[g] = {ms, score: ok ? groupScore(g, ms) : 0.001, kind: ok ? 'measured' : 'fail'};
      }
      const gs = Object.values(row.groups).map(x => x.score);
      row.score = d.score ?? geo(gs);
      row.kind = row.fails ? 'fail' : 'measured';
    } else if (REF.ms[name]) {
      for (const g of GROUPS) {
        const refMs = REF.ms[name][g];
        if (!refMs) continue;
        const ms = refMs * f[g];
        row.groups[g] = {ms, score: groupScore(g, ms), kind:'est'};
      }
      row.score = geo(Object.values(row.groups).map(x => x.score));
      row.kind = 'est';
    }
    return row;
  });
  return {rows, used, factor: geo(Object.values(f)), overall: overallScore(rows)};
}
// One number for the whole machine: geometric mean of every reference language's score (measured if run here,
// otherwise estimated). A fixed language set keeps it comparable between machines whichever languages were run.
function overallScore(rows) {
  const set = rows.filter(r => REF.ms[r.name] && r.score > 0);
  if (!set.length) return null;
  const ref = geo(Object.keys(REF.ms).map(n => geo(GROUPS.filter(g => REF.ms[n][g]).map(g => groupScore(g, REF.ms[n][g])))));
  return {score: geo(set.map(r => r.score)), ref, langs: set.length, measured: set.filter(r => r.kind !== 'est').length};
}

// ---------- tiny effects ----------
const GLYPHS = '01<>/\\[]{}#$%&*+=?';
function scrambleTo(el, finalText, ms = 420) {
  if (reduceMotion || !el) { if (el) el.textContent = finalText; return; }
  const start = performance.now(); const len = finalText.length;
  cancelAnimationFrame(el._raf);
  const step = now => {
    const t = Math.min(1, (now - start) / ms), fixed = Math.floor(t * len);
    let s = '';
    for (let i = 0; i < len; i++) s += i < fixed || finalText[i] === ' ' ? finalText[i] : GLYPHS[(Math.random() * GLYPHS.length) | 0];
    el.textContent = s;
    if (t < 1) el._raf = requestAnimationFrame(step);
  };
  el._raf = requestAnimationFrame(step);
}
function toast(msg, bad = false) {
  const t = document.createElement('div');
  t.className = 'toast' + (bad ? ' bad' : '');
  t.innerHTML = `<b aria-hidden="true"></b><span>${esc(msg)}</span>`;
  $('#toasts').append(t);
  setTimeout(() => { t.classList.add('out'); t.addEventListener('animationend', () => t.remove(), {once:true}); setTimeout(() => t.remove(), 400); }, 3600);
}

// ---------- histogram ----------
const PARTS = ['', '▏', '▎', '▍', '▌', '▋', '▊', '▉'];
function barText(frac, cols, kind) {
  frac = Math.max(0, Math.min(1, frac));
  if (kind === 'est') { const n = Math.max(1, Math.round(frac * cols)); return ['▒'.repeat(n), '░'.repeat(cols - n)]; }
  const exact = frac * cols, full = Math.floor(exact), part = PARTS[Math.floor((exact - full) * 8)];
  const filled = '█'.repeat(full) + part || '▏';
  return [filled, '░'.repeat(Math.max(0, cols - full - (part ? 1 : 0)))];
}
let charW = 0;
function columns() {
  const host = $('.h-bar');
  if (!host) return 40;
  if (!charW) {
    const probe = document.createElement('span'); probe.textContent = '█'.repeat(20);
    probe.style.cssText = 'visibility:hidden;position:absolute;white-space:pre';
    host.append(probe); charW = probe.getBoundingClientRect().width / 20; probe.remove();
  }
  return Math.max(8, Math.floor(host.clientWidth / (charW || 9)) - 1);
}

function tagFor(r) {
  if (r.kind === 'measured') return ['Measured', 'ok', 'Measured on this computer'];
  if (r.kind === 'fail') return [`${r.fails} of 8 failed`, 'fail', 'Some tests gave a wrong answer, so they score almost zero'];
  if (r.kind === 'est') {
    if (r.status === 'compile-failed') return ['Est. (build failed)', 'fail', 'It did not build here. The score is an estimate. See Technical output in the Run section.'];
    if (r.status === 'run-failed') return ['Est. (run failed)', 'fail', 'It crashed here. The score is an estimate.'];
    return ['Estimated', 'est', 'Not installed on this computer. Guessed from the reference computer and your speed.'];
  }
  if (r.status === 'compile-failed') return ['Build failed', 'fail', 'It did not build here'];
  return ['No data', '', 'No measurement and no reference data yet'];
}

function renderBoard(model) {
  const q = $('#search').value.trim().toLowerCase();
  let rows = model.rows.filter(r => r.name.toLowerCase().includes(q) || r.id.includes(q));
  if (!showEst) rows = rows.map(r => r.kind === 'est' ? {...r, kind:'none', score:null, groups:{}} : r);
  const order = {measured:0, fail:1, est:2, none:3};
  rows.sort((a, b) => sortBy === 'name' ? a.name.localeCompare(b.name)
    : sortBy === 'status' ? order[a.kind] - order[b.kind] || (b.score ?? -1) - (a.score ?? -1)
    : (b.score ?? -1) - (a.score ?? -1));
  const max = Math.max(1, ...rows.map(r => r.score ?? 0));

  const host = $('#histo');
  if (!rows.length) { host.innerHTML = `<p class="h-empty" style="padding:18px 16px;color:var(--mute);margin:0">No language matches “${esc(q)}”.</p>`; return; }
  host.innerHTML = rows.map((r, i) => {
    const [tag, tcls, tip] = tagFor(r);
    const cls = r.kind === 'measured' ? '' : r.kind === 'fail' ? ' is-fail' : r.kind === 'est' ? ' is-est' : ' is-none';
    const isOpen = open.has(r.name);
    const details = GROUPS.map(g => {
      const x = r.groups[g], gm = Math.max(1, ...rows.map(o => o.groups[g]?.score ?? 0));
      return `<div class="d-group ${x?.kind === 'est' ? 'est' : x?.kind === 'fail' ? 'fail' : ''}">
        <div class="d-group-top"><span title="${esc(GROUP_INFO[g])}">${g}</span><span>${x ? (x.kind === 'fail' ? 'checksum ×' : fmt(x.score) + ' pts') : '—'}</span></div>
        <div class="mini"><i style="width:${x ? Math.min(100, x.score / gm * 100) : 0}%"></i></div>
        <div class="d-group-top"><span>${x ? fmt(x.ms, 2) + ' ms' : 'no result'}</span><span></span></div></div>`;
    }).join('');
    const meta = r.kind === 'est'
      ? `Estimated from the reference run × this machine's speed${model.used.length ? ` (from ${esc(model.used.join(', '))})` : ' (no language measured here yet, so these are reference-machine numbers)'}.${REF.derived?.[r.name] ? ' ' + esc(REF.derived[r.name]) : ''}`
      : r.kind === 'none' ? (REF.ms[r.name] ? 'Estimates are hidden.' : `No reference data for ${esc(r.name)} yet. Install its toolchain and run it to get a score.`)
      : r.kind === 'fail' ? `Measured here, but ${r.fails} of 8 tests gave a wrong answer. Those tests score almost zero.`
      : `Measured on this computer. Point at a test name to see what it does.`;
    return `<div class="h-row${cls}${isOpen ? ' is-open' : ''}" role="listitem" data-lang="${esc(r.name)}">
      <button type="button" class="h-main" aria-expanded="${isOpen}" aria-controls="d-${r.id}">
        <span class="h-rank">${r.score != null && sortBy === 'score' ? String(i + 1).padStart(2, '0') : '··'}</span>
        <span class="h-name">${esc(r.name)}<small>${esc(r.family)}</small></span>
        <span class="h-bar" data-frac="${r.score != null ? r.score / max : 0}" data-kind="${r.kind}"></span>
        <span class="h-score" data-val="${r.score != null ? fmt(r.score) : '—'}">${r.score != null ? fmt(r.score) : '—'}</span>
        <span class="h-tag ${tcls}" title="${esc(tip)}">${tag}</span>
        <span class="h-chev" aria-hidden="true">›</span>
      </button>
      <div class="h-detail" id="d-${r.id}"><div><div class="h-detail-in"><p class="d-meta">${meta}</p>${details}</div></div></div>
    </div>`;
  }).join('');
  drawBars(firstPaint && !reduceMotion);
  if (firstPaint) $$('.h-score').forEach(el => scrambleTo(el, el.dataset.val, 650));
  firstPaint = false;
}
function drawBars(animate) {
  const cols = columns();
  const bars = $$('.h-bar');
  const paint = (el, f) => {
    const [fill, rest] = barText(Number(el.dataset.frac) * f, cols, el.dataset.kind);
    el.innerHTML = el.dataset.kind === 'none' ? `<span class="rest">${'░'.repeat(cols)}</span>`
      : `${fill}<span class="rest">${rest}</span>`;
  };
  if (!animate) { bars.forEach(el => paint(el, 1)); return; }
  const t0 = performance.now();
  const tick = now => {
    let done = true;
    bars.forEach((el, i) => {
      const t = Math.max(0, Math.min(1, (now - t0 - i * 45) / 700));
      if (t < 1) done = false;
      paint(el, 1 - Math.pow(1 - t, 3));
    });
    if (!done) requestAnimationFrame(tick);
  };
  requestAnimationFrame(tick);
}

function renderKpis(model) {
  const measured = model.rows.filter(r => r.kind === 'measured' || r.kind === 'fail');
  const est = model.rows.filter(r => r.kind === 'est');
  const none = model.rows.filter(r => r.kind === 'none' && !REF.ms[r.name]);
  let all = 0, ok = 0;
  for (const d of Object.values(data)) for (const c of Object.values(d.checks)) { all++; if (c.ok) ok++; }
  const top = model.rows.filter(r => r.kind === 'measured').sort((a, b) => b.score - a.score)[0];
  const speed = model.used.length ? 1 / model.factor : null;
  const kpi = (label, val, sub, tip) => `<div class="kpi" title="${esc(tip)}"><dt>${label}</dt><dd><span class="kpi-val">${val}</span><span class="kpi-sub">${sub}</span></dd></div>`;
  const o = model.used.length ? model.overall : null;
  $('#welcome').hidden = model.used.length > 0;
  $('#kpis').innerHTML =
    `<div class="kpi kpi-overall" title="One number for this computer: the average score of ${o ? o.langs : 12} languages. Languages you have not installed use estimates. Higher is faster."><dt>Overall score</dt><dd><span class="kpi-val">${o ? `<span class="accent">${fmt(o.score)}</span>` : '—'}</span><span class="kpi-sub">${o
      ? `${onlineView ? 'Test computer' : 'Your computer'} (${o.measured} of ${o.langs} languages measured). Reference computer: ${fmt(o.ref)}`
      : 'Shown after your first run'}</span></dd></div>` +
    kpi('Fastest language here', top ? `<span class="accent">${esc(top.name)}</span> ${fmt(top.score)}` : '—', top ? 'Average score over the 8 tests' : 'Run a language to measure it', 'The fastest language that was actually measured on this computer') +
    kpi('Computer speed', speed ? `${fmt(speed, 2)}×` : '—', speed ? `compared with the reference computer (1.00×)` : 'Shown after your first run', 'Above 1 means faster than the reference computer, below 1 means slower') +
    kpi('Languages tested', `${measured.length}<span class="dim">/${LANGS.length}</span>`, [showEst && est.length ? `${est.length} estimated` : '', none.length ? `no data: ${none.map(r => esc(r.name)).join(', ')}` : ''].filter(Boolean).join(', ') || 'Every language measured', 'Install more languages to replace estimates with real measurements') +
    kpi('Correct results', all ? `<span class="${ok === all ? 'accent' : 'bad'}">${ok}</span>/${all}` : '—', all ? (ok === all ? 'Every test gave the right answer' : `${all - ok} test${all - ok > 1 ? 's' : ''} gave a wrong answer`) : 'Nothing measured yet', 'Each test checks its answer. A wrong answer scores almost zero.');
}

// ---------- groups ----------
function renderGroups(model) {
  const grid = $('#group-grid');
  grid.innerHTML = GROUPS.map(g => {
    const list = model.rows
      .map(r => ({r, x: r.kind === 'est' && !showEst ? null : r.groups[g]}))
      .sort((a, b) => (b.x?.score ?? -1) - (a.x?.score ?? -1));
    const max = Math.max(1, ...list.map(o => o.x?.score ?? 0));
    const best = list[0]?.x;
    return `<section class="g-panel" aria-label="${g}">
      <div class="g-head"><h3 title="${esc(GROUP_INFO[g])}">${g}</h3><span title="Time of optimized C on the reference computer">ref ${REFS[g]} ms</span></div>
      <p class="g-info">${esc(GROUP_INFO[g])}</p>
      <ol class="g-list">${list.map(({r, x}, i) => {
        const k = !x ? 'none' : x.kind === 'est' ? 'est' : x.kind === 'fail' ? 'fail' : '';
        const v = !x ? '—' : x.kind === 'fail' ? '×' : metric === 'ms' ? fmt(x.ms, x.ms < 100 ? 1 : 0) : fmt(x.score, x.score < 100 ? 1 : 0);
        return `<li class="g-item ${k}${i === 0 && x && best ? ' top' : ''}" data-lang="${esc(r.name)}" tabindex="0">
          <span class="r">${x ? i + 1 : ''}</span><span class="n">${esc(r.name)}</span>
          <span class="b"><i style="width:${x ? Math.max(1, x.score / max * 100) : 0}%"></i></span>
          <span class="v" title="${x ? fmt(x.ms, 2) + ' ms · ' + fmt(x.score) + ' pts' + (x.kind === 'est' ? ' (estimated)' : '') : 'no data'}">${v}</span></li>`;
      }).join('')}</ol></section>`;
  }).join('');
}
function focusLang(name) {
  const grid = $('#group-grid');
  grid.classList.toggle('has-focus', !!name);
  $$('.g-item').forEach(li => li.classList.toggle('is-focus', li.dataset.lang === name));
}

// ---------- language picker ----------
function renderPicker() {
  const host = $('#language-picker');
  const prev = new Set($$('#language-picker input:checked').map(i => i.value));
  // first time build status is known: preselect everything except languages whose toolchain was missing
  const seed = !pickerSeeded && (Object.keys(statuses).length > 0 || !host.children.length);
  if (Object.keys(statuses).length) pickerSeeded = true;
  // Installed languages first, so the ones you can run are easy to find.
  const rank = id => ({'compile-passed':0,'runtime-available':0,'run-failed':1,'compile-failed':1,unavailable:3}[statuses[id]] ?? 2);
  host.innerHTML = [...LANGS].sort((a, b) => rank(a[1]) - rank(b[1])).map(([name, id]) => {
    const st = statuses[id];
    const checked = seed ? st !== 'unavailable' : prev.has(id);
    const [label, cls] = statusText(id, st);
    return `<label class="lang ${cls}"><input type="checkbox" value="${id}" ${checked ? 'checked' : ''}><span class="lang-box"><b>${esc(name)}</b><small>${label}</small></span></label>`;
  }).join('');
  updateEstimate();
}
function statusText(id, st) {
  if (st === 'compile-passed' || st === 'runtime-available') return ['Ready', 'is-ready'];
  if (st === 'unavailable') {
    const [what, url] = INSTALL[id];
    return [`Not installed · <a href="${url}" target="_blank" rel="noopener noreferrer" title="Install ${esc(what)}, then run the benchmark again">Install ↗</a>`, 'is-missing'];
  }
  if (st === 'compile-failed') return ['Build failed last time', 'is-failed'];
  if (st === 'run-failed') return ['Crashed last time', 'is-failed'];
  return ['Not checked yet', ''];
}

// ---------- time estimate ----------
// Mirrors the timing loop in the generated programs: one warm-up plus at least 3 timed runs, 1.5 s budget, max 40 runs.
const chosenLangs = () => $$('#language-picker input:checked').map(x => x.value);
const chosenRounds = () => Number(($('input[name="mode"]:checked') || {}).value) || 3;
function estimateSeconds(ids, rounds) {
  const model = buildModel(), byId = Object.fromEntries(model.rows.map(r => [r.id, r]));
  let sec = 0;
  for (const id of ids) {
    if (statuses[id] === 'unavailable') continue;
    sec += BUILD_SEC[id] || 0;
    let perRound = 1;
    for (const g of GROUPS) {
      const ms = byId[id]?.groups[g]?.ms ?? REFS[g] * 3;
      perRound += Math.min(40 * ms, Math.max(4 * ms, 1500 + ms)) / 1000;
    }
    sec += perRound * rounds;
  }
  return sec;
}
const fmtDur = s => s < 60 ? `${Math.max(5, Math.round(s / 5) * 5)} seconds` : s < 3600 ? `${Math.round(s / 60)} minute${Math.round(s / 60) === 1 ? '' : 's'}` : `${(s / 3600).toFixed(1)} hours`;
const fmtClock = s => `${Math.floor(s / 60)}:${String(Math.floor(s % 60)).padStart(2, '0')}`;
function updateEstimate() {
  const ids = chosenLangs(), el = $('#run-estimate');
  if (!el || running || runnerOffline) return;
  const runnable = ids.filter(id => statuses[id] !== 'unavailable'), missing = ids.length - runnable.length;
  if (!ids.length) { el.textContent = 'Choose at least one language.'; el.className = 'run-estimate bad'; return; }
  if (!runnable.length) { el.textContent = 'None of the chosen languages are installed. Install one first (see the links above).'; el.className = 'run-estimate bad'; return; }
  el.className = 'run-estimate';
  el.textContent = `${runnable.length} language${runnable.length > 1 ? 's' : ''} · about ${fmtDur(estimateSeconds(runnable, chosenRounds()))}`
    + (missing ? ` · ${missing} not installed, will be skipped` : '');
}

// ---------- render all ----------
function render() {
  const model = buildModel();
  renderBoard(model);
  renderKpis(model);
  renderGroups(model);
}
function load(text, quiet) {
  try {
    const n = parseResults(text); showRunDate(text); render();
    const msg = `Loaded ${n} results across ${Object.keys(data).length} languages.`;
    $('#import-message').textContent = msg; $('#import-message').className = 'import-message ok';
    if (!quiet) toast(msg);
    return true;
  } catch (e) {
    $('#import-message').textContent = e.message; $('#import-message').className = 'import-message bad';
    if (!quiet) toast(e.message, true);
    return false;
  }
}
async function refreshFiles(quiet) {
  const btn = $('#refresh'); btn.classList.add('is-loading'); btn.disabled = true;
  try {
    const [r, s] = await Promise.all([fetch('results.txt?' + Date.now()), fetch('build_status.txt?' + Date.now())]);
    if (s.ok) parseStatus(await s.text());
    if (r.ok) { const t = await r.text(); if (t.trim()) load(t, quiet); else render(); } else render();
    renderPicker();
    if (!quiet) toast('Reloaded results.txt and build_status.txt');
  } catch {
    render();
    if (!quiet) toast('Could not read the results files. Use Import results.txt instead.', true);
  } finally { btn.classList.remove('is-loading'); btn.disabled = false; }
}

// ---------- terminal ----------
const term = $('#terminal-output');
function colorize(text) {
  const lines = text.split('\n');
  const tail = lines.length > 2500 ? lines.slice(-2500) : lines;
  return tail.map(l => {
    const e = esc(l);
    if (/^HOTLOOP\|[^|]+\|[^|]+\|[^|]+\|0\|/.test(l) || /FAILED|error|Error|exception/i.test(l)) return `<span class="t-bad">${e}</span>`;
    if (l.startsWith('HOTLOOP|')) return `<span class="t-ok">${e}</span>`;
    if (/^(build|run)\s/.test(l)) return `<span class="t-step">${e}</span>`;
    if (l.startsWith('skip')) return `<span class="t-skip">${e}</span>`;
    if (l.startsWith('$') || l.startsWith('#')) return `<span class="t-dim">${e}</span>`;
    return e;
  }).join('\n');
}
function setTerm(text) {
  const atBottom = term.scrollHeight - term.scrollTop - term.clientHeight < 40;
  term.innerHTML = colorize(text);
  if (atBottom) term.scrollTop = term.scrollHeight;
}
// Progress is read from the runner's output, so it also works for a run started in another tab.
let running = false, runStart = 0, runEstimate = 0, runnerOffline = openedAsFile;
const NAME_OF = Object.fromEntries(LANGS.map(([n, id]) => [id, n]));
function updateProgress(output) {
  const requested = (output.match(/^build \S+ \.\.\./gm) || []).length;
  const skipped = (output.match(/^skip\s/gm) || []).length + (output.match(/^FAILED build/gm) || []).length;
  const rounds = Number((/^rounds (\d+)/m.exec(output) || [])[1]) || 1;
  const total = Math.max(1, requested - skipped) * GROUPS.length * rounds;
  const done = (output.match(/^HOTLOOP\|[^|]+\|(sorting|structures|graphs|dynamic|strings|compress|numeric|search)\|/gm) || []).length;
  const m = [...output.matchAll(/^(build|run)\s+(\S+)(?: \(round (\d+)\/(\d+)\))?/gm)].pop();
  const label = !m ? 'Starting…'
    : m[1] === 'build' ? `Preparing ${NAME_OF[m[2]] || m[2]}…`
    : `Testing ${NAME_OF[m[2]] || m[2]}` + (m[4] > 1 ? ` — round ${m[3]} of ${m[4]}` : '') + '…';
  const frac = Math.min(1, done / total), pct = Math.round(frac * 100);
  const elapsed = (Date.now() - runStart) / 1000;
  const left = frac > 0.15 ? elapsed * (1 - frac) / frac : Math.max(0, runEstimate - elapsed);
  $('#progress-label').textContent = label;
  $('#progress-count').textContent = `${pct}% · ${fmtClock(elapsed)} elapsed` + (frac < 1 && left > 0 ? ` · about ${fmtDur(left)} left` : '');
  $('#progress-fill').style.width = pct + '%';
  $('.progress-bar').setAttribute('aria-valuenow', pct);
  $('#sb-state').textContent = label;
  document.title = `(${pct}%) hotloop`;
}
function setMsg(text, kind) { const m = $('#run-message'); m.textContent = text; m.className = 'run-message ' + (kind || ''); }

const runButton = $('#run-button');
function setRunning(on) {
  running = on;
  runButton.disabled = on; $('.run-label').textContent = on ? 'Running…' : 'Run benchmark';
  $('#console').classList.toggle('is-running', on); $('#stop-run').hidden = !on; $('#progress').hidden = !on;
  $('#run-estimate').hidden = on;
  $$('#language-picker input, input[name="mode"], [data-preset]').forEach(x => x.disabled = on);
  $('#sb-state').classList.toggle('running', on);
  if (!on) { $('#sb-state').textContent = 'idle'; updateEstimate(); }
}
// Poll the runner until it is idle. Returns the last output seen.
async function followRun(intro, until) {
  let seen = '';
  while (true) {
    const next = until ? await Promise.race([until.then(r => ({r})), new Promise(res => setTimeout(() => res({}), 500))]) : (await new Promise(res => setTimeout(res, 700)), {});
    if (next.r) return {seen, response: next.r};
    try {
      const p = await fetch('/api/run/status', {cache:'no-store'});
      if (p.ok) {
        const st = await p.json(), out = String(st.output || '');
        if (out !== seen) { seen = out; setTerm(intro + out); updateProgress(out); }
        if (!until && !st.active) return {seen};
      }
    } catch {}
  }
}
// Friendly summary after a run: new score per language, change since last time, and any warnings.
function showSummary(before, output, ok) {
  const rounds = Number((/^rounds (\d+)/m.exec(output) || [])[1]) || 1;
  const host = $('#run-summary');
  const ran = [...output.matchAll(/^run\s+(\S+)/gm)].map(m => NAME_OF[m[1]]).filter((n, i, a) => n && a.indexOf(n) === i);
  const skipped = [...output.matchAll(/^skip\s+(\S+):/gm)].map(m => NAME_OF[m[1]] || m[1]);
  const warn = {};
  for (const m of output.matchAll(/^\s+warning: (\S+) rounds differ by (\d+)%/gm)) warn[m[1]] = m[2];
  const rows = ran.map(name => {
    const now = data[name]?.score, prev = before[name];
    const fails = Object.values(data[name]?.checks || {}).filter(c => !c.ok).length;
    let delta = '';
    if (now != null && prev != null && prev > 0) {
      const d = (now - prev) / prev * 100;
      delta = Math.abs(d) < 1 ? '<span class="dim">about the same</span>' : `<span class="${d > 0 ? 'up' : 'down'}">${d > 0 ? '▲' : '▼'} ${Math.abs(d).toFixed(0)}%</span> <span class="dim">vs ${fmt(prev)}</span>`;
    } else if (now != null) delta = '<span class="dim">first measurement</span>';
    const note = fails ? `<span class="bad">${fails} test${fails > 1 ? 's' : ''} gave a wrong answer</span>`
      : warn[name] ? `<span class="warn" title="The rounds differed by ${warn[name]}%. Close heavy apps and run again for a steadier number.">rounds varied ${warn[name]}%</span>` : '';
    return `<li><b>${esc(name)}</b><span class="s-score">${now != null ? fmt(now) : '—'}</span><span class="s-delta">${delta}</span><span class="s-note">${note}</span></li>`;
  }).join('');
  const notes = [];
  if (skipped.length) notes.push(`Skipped (not installed): ${skipped.map(esc).join(', ')}. Install them from the links in step 1.`);
  if (rounds === 1 && ran.length) notes.push('This was a Quick check, so the change since last time may just be noise. Use Accurate mode for a number you can compare.');
  if (Object.keys(warn).length) notes.push('Some rounds varied a lot, usually because other apps were busy. Close heavy apps and run again for steadier numbers.');
  if (!ok && !rows) notes.push('Nothing was measured. Open "Technical output" below to see what went wrong.');
  host.innerHTML = (rows ? `<h4>Your results</h4><ul class="s-list">${rows}</ul>` : '') + notes.map(n => `<p class="s-tip">${n}</p>`).join('')
    + (rows ? `<a class="link-btn s-link" href="#board">See the full leaderboard ↑</a>` : '');
  host.hidden = !host.innerHTML;
}
function finishTitle(ok) {
  document.title = (ok ? '✓ Done' : '⚠ Finished') + ' — hotloop';
  const reset = () => { if (!running) document.title = TITLE; };
  if (document.hasFocus()) setTimeout(reset, 4000); else addEventListener('focus', () => setTimeout(reset, 1500), {once:true});
}
const TITLE = document.title;

async function runBenchmark() {
  const chosen = chosenLangs(), rounds = chosenRounds();
  if (!chosen.length) { setMsg('Choose at least one language in step 1.', 'bad'); toast('Choose at least one language.', true); return; }
  if (!chosen.some(id => statuses[id] !== 'unavailable')) { setMsg('None of the chosen languages are installed. Use the "Get …" links in step 1 to install one.', 'bad'); return; }
  if (openedAsFile) { setMsg(NO_RUNNER, 'bad'); toast('Open the dashboard with start.bat to run benchmarks.', true); return; }
  const before = Object.fromEntries(Object.entries(data).map(([n, d]) => [n, d.score]));
  runStart = Date.now(); runEstimate = estimateSeconds(chosen, rounds);
  setRunning(true); $('#run-summary').hidden = true; setMsg('');
  const intro = '$ HOTLOOP_ROUNDS=' + rounds + ' ./run_all.sh ' + chosen.join(' ') + '\n\n';
  setTerm(intro); updateProgress('');
  let seen = '', ok = false;
  try {
    const health = await fetch('/api/health').catch(() => { throw Error(NO_RUNNER); });
    if (!health.ok) throw Error(NO_RUNNER);
    const request = fetch('/api/run', {method:'POST', headers:{'content-type':'application/json'}, body:JSON.stringify({languages:chosen, rounds})})
      .catch(() => { throw Error('Lost the connection to the runner. Check that start.bat is still open, then reload this page.'); });
    const f = await followRun(intro, request); seen = f.seen;
    const response = f.response, result = await response.json();
    if (!response.ok && !result.output) throw Error(result.error || 'The runner refused the request.');
    const output = result.output || '';
    setTerm(intro + (output || 'Run finished with no output.'));
    if (result.status) parseStatus(result.status);
    if (result.results && result.results.includes('HOTLOOP|')) load(result.results, true); else render();
    renderPicker();
    ok = result.ok;
    if (result.ok) { setMsg(`Finished in ${fmtClock((Date.now() - runStart) / 1000)}. The leaderboard is updated.`, 'ok'); toast('Run finished. Leaderboard updated.'); }
    else if (result.code === 130 || result.code === null) { setMsg(result.error || 'Run stopped. Languages that finished kept their new results.', 'bad'); toast('Run stopped', true); }
    else { setMsg(result.error || 'The run finished, but something failed. See the summary below, or open Technical output for details.', 'bad'); toast('Run finished with problems', true); $('#term-details').open = true; }
    showSummary(before, output, result.ok);
  } catch (e) {
    setTerm(intro + seen + '\nerror: ' + e.message + '\n'); setMsg(e.message, 'bad'); toast(e.message, true);
  } finally {
    setRunning(false); finishTitle(ok);
  }
}
// A run is already going (started in another tab, or before this page was reloaded): show its progress.
async function watchExistingRun() {
  await bootLoad; // compare against the results that were there before this run
  const before = Object.fromEntries(Object.entries(data).map(([n, d]) => [n, d.score]));
  runStart = Date.now(); runEstimate = 0;
  setRunning(true); setMsg('A benchmark is already running. Showing its progress.', '');
  const {seen} = await followRun('');
  await refreshFiles(true);
  setRunning(false);
  setMsg('The run finished. The leaderboard is updated.', 'ok');
  showSummary(before, seen, true); finishTitle(true);
}

// ---------- events ----------
runButton.addEventListener('click', e => {
  if (!reduceMotion) {
    const r = runButton.getBoundingClientRect(), s = Math.max(r.width, r.height), dot = document.createElement('span');
    dot.className = 'ripple'; dot.style.cssText = `width:${s}px;height:${s}px;left:${e.clientX - r.left - s / 2}px;top:${e.clientY - r.top - s / 2}px`;
    runButton.append(dot); setTimeout(() => dot.remove(), 600);
  }
  runBenchmark();
});
$('#stop-run').addEventListener('click', async () => {
  if (!confirm('Stop the benchmark? Languages that already finished keep their new results.')) return;
  $('#stop-run').textContent = 'Stopping…'; $('#stop-run').disabled = true;
  try { await fetch('/api/run/cancel', {method:'POST', headers:{'content-type':'application/json'}, body:'{}'}); } catch {}
  setTimeout(() => { $('#stop-run').textContent = 'Stop'; $('#stop-run').disabled = false; }, 1500);
});
$('#clear-terminal').addEventListener('click', () => { term.innerHTML = '<span class="t-dim"># cleared</span>'; });
const flash = el => { el.classList.remove('flash'); void el.offsetWidth; el.classList.add('flash'); };
$('#language-picker').addEventListener('change', e => { const c = e.target.closest('.lang'); if (c) flash(c); updateEstimate(); });
$$('[data-preset]').forEach(b => b.addEventListener('click', () => {
  const p = b.dataset.preset;
  $$('#language-picker input').forEach(i => {
    const st = statuses[i.value];
    const want = p === 'all' || (p === 'ready' && (st === 'compile-passed' || st === 'runtime-available' || st === 'run-failed'));
    if (i.checked !== want) { i.checked = want; flash(i.closest('.lang')); }
  });
  updateEstimate();
}));
// Remember the chosen mode for next time (per browser; works without storage too).
try { const saved = localStorage.getItem('hotloop-mode'); const r = saved && $(`input[name="mode"][value="${saved}"]`); if (r) r.checked = true; } catch {}
$$('input[name="mode"]').forEach(r => r.addEventListener('change', () => { try { localStorage.setItem('hotloop-mode', r.value); } catch {} updateEstimate(); }));
// File "buttons" are labels: let Enter and Space open them from the keyboard.
$$('label.btn[for]').forEach(l => l.addEventListener('keydown', e => { if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); document.getElementById(l.htmlFor).click(); } }));

$('#histo').addEventListener('click', e => {
  const btn = e.target.closest('.h-main'); if (!btn) return;
  const row = btn.closest('.h-row'), name = row.dataset.lang;
  open.has(name) ? open.delete(name) : open.add(name);
  row.classList.toggle('is-open'); btn.setAttribute('aria-expanded', row.classList.contains('is-open'));
  if (row.classList.contains('is-open')) row.querySelectorAll('.mini i').forEach(i => { i.style.animation = 'none'; void i.offsetWidth; i.style.animation = ''; });
});
$('#search').addEventListener('input', render);
$$('[data-sort]').forEach(b => b.addEventListener('click', () => {
  sortBy = b.dataset.sort; $$('[data-sort]').forEach(x => x.setAttribute('aria-checked', x === b)); render();
}));
$$('[data-metric]').forEach(b => b.addEventListener('click', () => {
  metric = b.dataset.metric; $$('[data-metric]').forEach(x => x.setAttribute('aria-checked', x === b)); render();
}));
$('#show-est').addEventListener('change', e => { showEst = e.target.checked; render(); });

const grid = $('#group-grid');
grid.addEventListener('mouseover', e => { const li = e.target.closest('.g-item'); if (li) focusLang(li.dataset.lang); });
grid.addEventListener('mouseleave', () => focusLang(null));
grid.addEventListener('focusin', e => { const li = e.target.closest('.g-item'); if (li) focusLang(li.dataset.lang); });
grid.addEventListener('focusout', e => { if (!grid.contains(e.relatedTarget)) focusLang(null); });

$('#results-file').addEventListener('change', async e => { const f = e.target.files[0]; if (f) load(await f.text()); e.target.value = ''; });
$('#status-file').addEventListener('change', async e => {
  const f = e.target.files[0]; if (!f) return;
  parseStatus(await f.text()); render(); renderPicker(); toast('Build status loaded'); e.target.value = '';
});
$('#load-paste').addEventListener('click', () => load($('#paste').value));
$('#refresh').addEventListener('click', () => refreshFiles(false));
$('#export-data').addEventListener('click', () => {
  const model = buildModel();
  const rows = [['Language','Kind','Overall score',...GROUPS.map(g => g + ' ms'),...GROUPS.map(g => g + ' pts'),'Build status']];
  for (const r of model.rows) rows.push([r.name, r.kind, r.score?.toFixed(1) ?? '', ...GROUPS.map(g => r.groups[g]?.ms?.toFixed(3) ?? ''), ...GROUPS.map(g => r.groups[g]?.score?.toFixed(1) ?? ''), r.status]);
  if (model.used.length && model.overall) rows.push(['Overall (this machine)', `${model.overall.measured} measured / ${model.overall.langs}`, model.overall.score.toFixed(1)]);
  const csv = rows.map(r => r.map(x => '"' + String(x).replaceAll('"', '""') + '"').join(',')).join('\r\n');
  const a = document.createElement('a'), url = URL.createObjectURL(new Blob([csv], {type:'text/csv'}));
  a.href = url; a.download = 'hotloop-report.csv'; a.click(); setTimeout(() => URL.revokeObjectURL(url), 1000);
  toast('Exported hotloop-report.csv');
});

// nav: scramble on hover, active section, number keys
$$('[data-scramble]').forEach(a => {
  const label = a.lastChild;
  a.addEventListener('mouseenter', () => { const t = label.textContent; const span = document.createElement('span'); label.replaceWith(span); scrambleTo(span, t, 260); setTimeout(() => { span.replaceWith(label); }, 300); });
});
const sections = ['board','run','groups','data'].map(id => document.getElementById(id));
const io = new IntersectionObserver(entries => {
  for (const en of entries) if (en.isIntersecting) $$('.tab').forEach(t => t.classList.toggle('is-active', t.getAttribute('href') === '#' + en.target.id));
}, {rootMargin:'-45% 0px -50% 0px'});
sections.forEach(s => io.observe(s));
document.addEventListener('keydown', e => {
  if (e.target.closest('input,textarea,select') || e.metaKey || e.ctrlKey || e.altKey) return;
  if (e.key === '/') { e.preventDefault(); $('#search').focus(); }
  const i = '1234'.indexOf(e.key);
  if (i >= 0) sections[i].scrollIntoView({behavior: reduceMotion ? 'auto' : 'smooth'});
});
let resizeT; addEventListener('resize', () => { clearTimeout(resizeT); resizeT = setTimeout(() => { charW = 0; drawBars(false); }, 120); });

// status bar
const clock = () => { $('#sb-clock').textContent = new Date().toLocaleTimeString([], {hour:'2-digit', minute:'2-digit'}); };
clock(); setInterval(clock, 15000);
if (REF.machine) $('#ref-machine').textContent = REF.machine;

// ---------- boot ----------
let bootLoad = Promise.resolve();
renderPicker();
render();
if (onlineView) {
  // Results only. Running needs the local runner, so explain how to get it instead of showing controls that cannot work.
  runnerOffline = true;
  $('#connection').classList.add('online'); $('#connection-state').textContent = 'online view';
  $('#console').hidden = true; $('#online-note').hidden = false;
  $('#run .section-head p').textContent = 'Measure how fast each language runs on your own computer. It is free and runs locally; nothing is uploaded.';
  $('#lede').innerHTML = 'How fast is each programming language? Every language runs the same 8 kinds of tests. <b>Higher score = faster.</b> 1000 means as fast as optimized C on the reference computer. These results were measured on the test computer named above; <a href="#run">run it on your own computer</a> to compare.';
  $('.legend span').firstChild.nextSibling.textContent = 'Measured on the test computer';
  bootLoad = refreshFiles(true);
} else if (openedAsFile) {
  $('#connection').classList.add('offline'); $('#connection-state').textContent = 'opened as file';
  setMsg(NO_RUNNER, 'bad'); runButton.disabled = true;
  $('#run-estimate').textContent = 'Open the dashboard with start.bat to run benchmarks.'; $('#run-estimate').className = 'run-estimate bad';
} else {
  bootLoad = refreshFiles(true);
  fetch('/api/health').then(r => { if (!r.ok) throw 0; return r.json(); })
    .then(h => { $('#connection').classList.add('online'); $('#connection-state').textContent = 'runner online'; if (h.active) watchExistingRun(); })
    .catch(() => {
      $('#connection').classList.add('offline'); $('#connection-state').textContent = 'runner offline';
      runnerOffline = true; setMsg(NO_RUNNER, 'bad'); runButton.disabled = true; $('#run-estimate').textContent = 'The runner is not running. Start it with start.bat.'; $('#run-estimate').className = 'run-estimate bad';
    });
}
