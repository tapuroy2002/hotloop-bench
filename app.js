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
const reduceMotion = matchMedia('(prefers-reduced-motion: reduce)').matches;

const $ = s => document.querySelector(s);
const $$ = s => [...document.querySelectorAll(s)];
const esc = v => String(v ?? '').replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
const geo = xs => xs.length ? Math.exp(xs.reduce((a, x) => a + Math.log(x), 0) / xs.length) : null;
const fmt = (v, d = 1) => v == null ? '—' : v.toFixed(d);

// ---------- runner location ----------
const DASHBOARD = 'http://127.0.0.1:4173/';
const openedAsFile = location.protocol === 'file:';
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
  $('#run-date').textContent = d && !isNaN(d)
    ? 'Results from ' + new Intl.DateTimeFormat(undefined, {dateStyle:'medium', timeStyle:'short'}).format(d) : '';
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
  if (r.kind === 'measured') return ['Measured', 'ok'];
  if (r.kind === 'fail') return [`${r.fails} of 8 failed`, 'fail'];
  if (r.kind === 'est') {
    if (r.status === 'compile-failed') return ['Est. (build failed)', 'fail'];
    if (r.status === 'run-failed') return ['Est. (run failed)', 'fail'];
    return ['Estimated', 'est'];
  }
  if (r.status === 'compile-failed') return ['Build failed', 'fail'];
  return ['No data', ''];
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
    const [tag, tcls] = tagFor(r);
    const cls = r.kind === 'measured' ? '' : r.kind === 'fail' ? ' is-fail' : r.kind === 'est' ? ' is-est' : ' is-none';
    const isOpen = open.has(r.name);
    const details = GROUPS.map(g => {
      const x = r.groups[g], gm = Math.max(1, ...rows.map(o => o.groups[g]?.score ?? 0));
      return `<div class="d-group ${x?.kind === 'est' ? 'est' : x?.kind === 'fail' ? 'fail' : ''}">
        <div class="d-group-top"><span>${g}</span><span>${x ? (x.kind === 'fail' ? 'checksum ×' : fmt(x.score) + ' pts') : '—'}</span></div>
        <div class="mini"><i style="width:${x ? Math.min(100, x.score / gm * 100) : 0}%"></i></div>
        <div class="d-group-top"><span>${x ? fmt(x.ms, 2) + ' ms' : 'no result'}</span><span></span></div></div>`;
    }).join('');
    const meta = r.kind === 'est'
      ? `Estimated from the reference run × this machine's speed${model.used.length ? ` (from ${esc(model.used.join(', '))})` : ' (no language measured here yet, so these are reference-machine numbers)'}.${REF.derived?.[r.name] ? ' ' + esc(REF.derived[r.name]) : ''}`
      : r.kind === 'none' ? (REF.ms[r.name] ? 'Estimates are hidden.' : `No reference data for ${esc(r.name)} yet. Install its toolchain and run it to get a score.`)
      : `Measured here. Build status: <b>${esc(r.status)}</b>.`;
    return `<div class="h-row${cls}${isOpen ? ' is-open' : ''}" role="listitem" data-lang="${esc(r.name)}">
      <button type="button" class="h-main" aria-expanded="${isOpen}" aria-controls="d-${r.id}">
        <span class="h-rank">${r.score != null && sortBy === 'score' ? String(i + 1).padStart(2, '0') : '··'}</span>
        <span class="h-name">${esc(r.name)}<small>${esc(r.family)}</small></span>
        <span class="h-bar" data-frac="${r.score != null ? r.score / max : 0}" data-kind="${r.kind}"></span>
        <span class="h-score" data-val="${r.score != null ? fmt(r.score) : '—'}">${r.score != null ? fmt(r.score) : '—'}</span>
        <span class="h-tag ${tcls}">${tag}</span>
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
  const kpi = (label, val, sub) => `<div class="kpi"><dt>${label}</dt><dd><span class="kpi-val">${val}</span><span class="kpi-sub">${sub}</span></dd></div>`;
  const o = model.used.length ? model.overall : null;
  $('#kpis').innerHTML =
    `<div class="kpi kpi-overall"><dt>Overall score</dt><dd><span class="kpi-val">${o ? `<span class="accent">${fmt(o.score)}</span>` : '—'}</span><span class="kpi-sub">${o
      ? `this machine, ${o.langs} languages (${o.measured} measured) · reference machine ${fmt(o.ref)}`
      : 'Known after the first run'}</span></dd></div>` +
    kpi('Fastest measured', top ? `<span class="accent">${esc(top.name)}</span> ${fmt(top.score)}` : '—', top ? 'points, geometric mean of 8 groups' : 'Run a language to measure it') +
    kpi('This machine', speed ? `${fmt(speed, 2)}×` : '—', speed ? `reference speed, from ${model.used.length} language${model.used.length > 1 ? 's' : ''}` : 'Known after the first run') +
    kpi('Measured here', `${measured.length}<span class="dim">/${LANGS.length}</span>`, [showEst && est.length ? `${est.length} estimated` : '', none.length ? `no data: ${none.map(r => esc(r.name)).join(', ')}` : ''].filter(Boolean).join(', ') || 'Every language measured') +
    kpi('Checksums', all ? `<span class="${ok === all ? 'accent' : 'bad'}">${ok}</span>/${all}` : '—', all ? (ok === all ? 'All groups match the reference' : `${all - ok} group${all - ok > 1 ? 's' : ''} returned a wrong result`) : 'Nothing measured yet');
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
      <div class="g-head"><h3>${g}</h3><span title="C -O2 time on the calibration machine">ref ${REFS[g]} ms</span></div>
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
  host.innerHTML = LANGS.map(([name, id]) => {
    const st = statuses[id];
    const checked = seed ? st !== 'unavailable' : prev.has(id);
    const na = st === 'unavailable' ? '<span class="na" title="Toolchain not found last run">n/a</span>' : '';
    return `<label class="chip"><input type="checkbox" value="${id}" ${checked ? 'checked' : ''}><span>${id}${na}</span></label>`;
  }).join('');
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
function updateProgress(output, chosenCount) {
  const skipped = (output.match(/^skip\s/gm) || []).length + (output.match(/^FAILED build/gm) || []).length;
  const rounds = Number((/^rounds (\d+)/m.exec(output) || [])[1]) || 1;
  const runs = Math.max(1, chosenCount - skipped) * GROUPS.length * rounds;
  const done = (output.match(/^HOTLOOP\|[^|]+\|(sorting|structures|graphs|dynamic|strings|compress|numeric|search)\|/gm) || []).length;
  const steps = output.match(/^(build|run)\s+\S+( \(round \d+\/\d+\))?/gm);
  const last = steps ? steps[steps.length - 1].replace(/\s+/, ' ') : 'starting';
  $('#progress-label').textContent = last + (last.startsWith('run') ? ' …' : '');
  $('#progress-count').textContent = `${done}/${runs} groups`;
  $('#progress-fill').style.width = Math.min(100, done / runs * 100) + '%';
  $('#sb-state').textContent = last;
}
function setMsg(text, kind) { const m = $('#run-message'); m.textContent = text; m.className = 'run-message ' + (kind || ''); }

const runButton = $('#run-button');
async function runBenchmark() {
  const chosen = $$('#language-picker input:checked').map(x => x.value);
  if (!chosen.length) { setMsg('Select at least one language.', 'bad'); toast('Select at least one language.', true); return; }
  if (openedAsFile) { setMsg(NO_RUNNER, 'bad'); toast('Open the dashboard with start.bat to run benchmarks.', true); return; }
  runButton.disabled = true; $('.run-label').textContent = 'Running…';
  $('#console').classList.add('is-running'); $('#stop-run').hidden = false; $('#progress').hidden = false;
  $('#sb-state').classList.add('running'); $('#sb-state').textContent = 'starting';
  const intro = '$ ./run_all.sh ' + chosen.join(' ') + '\n\n';
  setTerm(intro); setMsg('');
  let seen = '';
  try {
    const health = await fetch('/api/health').catch(() => { throw Error(NO_RUNNER); });
    if (!health.ok) throw Error(NO_RUNNER);
    const request = fetch('/api/run', {method:'POST', headers:{'content-type':'application/json'}, body:JSON.stringify({languages:chosen})})
      .catch(() => { throw Error('Lost the connection to the local runner. Check that start.bat is still open, then reload.'); });
    let response;
    while (!response) {
      const next = await Promise.race([request.then(r => ({r})), new Promise(res => setTimeout(() => res({}), 400))]);
      if (next.r) { response = next.r; break; }
      try {
        const p = await fetch('/api/run/status', {cache:'no-store'});
        if (p.ok) { const st = await p.json(), out = String(st.output || ''); if (out !== seen) { seen = out; setTerm(intro + out); updateProgress(out, chosen.length); } }
      } catch {}
    }
    const result = await response.json();
    if (!response.ok && !result.output) throw Error(result.error || 'The runner refused the request.');
    setTerm(intro + (result.output || 'Run finished with no output.'));
    updateProgress(result.output || '', chosen.length);
    if (result.status) parseStatus(result.status);
    if (result.results && result.results.includes('HOTLOOP|')) load(result.results, true); else render();
    renderPicker();
    const now = new Date().toLocaleTimeString();
    if (result.ok) { setMsg(`Run finished at ${now}. Leaderboard updated.`, 'ok'); toast('Run finished. Leaderboard updated.'); }
    else if (result.code === 130 || result.code === null) { setMsg(result.error || 'Run stopped. Results from finished languages were kept.', 'bad'); toast('Run stopped', true); }
    else { setMsg(result.error || `Run finished with failures (exit code ${result.code}). Red lines in the output show what failed.`, 'bad'); toast('Run finished with failures', true); }
  } catch (e) {
    setTerm(intro + seen + '\nerror: ' + e.message + '\n'); setMsg(e.message, 'bad'); toast(e.message, true);
  } finally {
    runButton.disabled = false; $('.run-label').textContent = 'Run benchmark';
    $('#console').classList.remove('is-running'); $('#stop-run').hidden = true;
    $('#sb-state').classList.remove('running'); $('#sb-state').textContent = 'idle';
  }
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
  $('#stop-run').textContent = 'stopping…';
  try { await fetch('/api/run/cancel', {method:'POST', headers:{'content-type':'application/json'}, body:'{}'}); } catch {}
  setTimeout(() => { $('#stop-run').textContent = 'stop'; }, 1500);
});
$('#clear-terminal').addEventListener('click', () => { term.innerHTML = '<span class="t-dim"># cleared</span>'; });
$('#language-picker').addEventListener('change', e => {
  const chip = e.target.closest('.chip'); if (!chip) return;
  chip.classList.remove('flash'); void chip.offsetWidth; chip.classList.add('flash');
});
$$('[data-preset]').forEach(b => b.addEventListener('click', () => {
  const p = b.dataset.preset;
  $$('#language-picker input').forEach(i => {
    const st = statuses[i.value];
    const want = p === 'all' || (p === 'ready' && (st === 'compile-passed' || st === 'runtime-available' || st === 'run-failed'));
    if (i.checked !== want) { i.checked = want; const c = i.closest('.chip'); c.classList.remove('flash'); void c.offsetWidth; c.classList.add('flash'); }
  });
}));

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
renderPicker();
render();
if (openedAsFile) {
  $('#connection').classList.add('offline'); $('#connection-state').textContent = 'opened as file';
  setMsg(NO_RUNNER, 'bad');
} else {
  refreshFiles(true);
  fetch('/api/health').then(r => { if (!r.ok) throw 0; return r.json(); })
    .then(h => { $('#connection').classList.add('online'); $('#connection-state').textContent = 'runner online'; if (h.active) setMsg('A benchmark is already running in another tab.', ''); })
    .catch(() => { $('#connection').classList.add('offline'); $('#connection-state').textContent = 'runner offline'; });
}
