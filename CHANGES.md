# Changes in this version

## Steady scores
- Each group now gets one untimed warm-up run, then at least 3 timed runs (time budget 1.5 s instead of 0.4 s). This
  changes the generator for all 13 languages; regenerated sources differ only in those 2 timing lines.
- `run_all.sh` runs every language 3 rounds (`HOTLOOP_ROUNDS`), alternating languages; `combine_rounds.js` keeps the best
  time per group and recomputes the score. Before, three JavaScript runs on the same laptop scored 164 to 212; after,
  213 to 217. A `# consistency` line per language records the round scores, and a warning is printed above 15% spread.
- Dashboard: the progress bar counts all rounds and shows which round is running.
- New **Overall score** card: one number for the machine (geometric mean of the 12 reference languages).
- C# without a .NET SDK (runtime only) is reported as unavailable, not as a build failure.
- Favicon added; the "data" tab no longer disappears on phones.

## Benchmark
- **C# now builds.** Two generator bugs: `base` (a C# keyword) was missing from the reserved-word list, and C# rejects
  an outer variable that reuses a name an earlier nested block already used (CS0136). The front end now renames these.
  All languages regenerated; the only source change is variable renames. Checksums verified for C, C++, Rust, Go, Java,
  C#, JavaScript, Python, Ruby, PHP.
- Reserved-word list extended for C#, Swift, Kotlin and Dart keywords.

- **Kotlin now builds.** A bare `{ }` block is a lambda in Kotlin, not a scope, so the generated code never compiled
  (and after `LongArray(n)` it even became a trailing-lambda argument). Blocks are now emitted as `run { }`.

## Dashboard redesign
- v4 polish after a design review: IBM Plex Sans + Plex Mono with tabular numbers; no scanlines or text glow;
  summary strip (fastest measured, this machine's speed, coverage, checksums); leaderboard with column headers and
  source badges; estimates dimmed so measured results stand out; all text at 4.5:1 contrast or better; larger touch
  targets on mobile.
- New phosphor-terminal look: the leaderboard is an ASCII histogram that draws itself on load; click a row for its 8
  groups. tmux-style status bar, live progress bar during runs, coloured console output, toasts, scramble effects.
- "Every language, group by group": 8 panels each rank all 13 languages; hover a language to follow it across panels.
  Switch between points and milliseconds.
- Estimated scores for languages without a toolchain, from the shipped reference run (`reference.js`), shown in amber
  and clearly labelled. "Show estimates" turns them off.
- Keyboard: 1-4 jump to sections, / focuses the filter. Works down to 360 px wide; respects reduced motion.

## run_all.sh
- Compile errors and runtime crashes were hidden (`2>/dev/null`, `>/dev/null`, `grep` filter). Now all output is shown;
  compiler output goes to `build/logs/` and the last 25 lines are printed on failure.
- Crashes / checksum failures are recorded as `run-failed` in `build_status.txt`.
- Exit code is 1 if anything failed (it was always 0, so the dashboard said "Run completed" even on failure).
- results.txt / build_status.txt are written to temp files and moved at the end, so a cancelled run keeps old results.
- Records run time, OS, CPU and compiler versions as `#` lines in results.txt.
- Running a subset keeps earlier results and build status of the languages not in this run.

## server.js
- Any website you visited could start a benchmark (no Origin check, text/plain POST accepted, `Origin: null` allowed).
  Now: Host header must be 127.0.0.1/localhost (blocks DNS rebinding), POST needs same Origin and application/json.
- Only index.html, app.js, styles.css, results.txt and build_status.txt are served (scripts, generator, binaries and pid
  file were public).
- The NUL-byte check was testing for a literal backslash-zero; fixed.
- Stop / timeout now kill the whole process tree (before, only bash died and the benchmark kept running).
- New `POST /api/run/cancel` endpoint.

## Dashboard
- Removed hard-coded sample Java/Dart scores that were shown as real results on startup.
- Removed the file:// fetch override (relied on the insecure `Origin: null`).
- Build-status import validated again; new "Run failed" status.
- The date in the header comes from the results file, not today's date.
- STOP button in the console while a run is active.
- Opening `index.html` directly (file://) now redirects to the running dashboard, or tells you to use start.bat.
- start.bat replaces a dashboard left running from another (older) Hotloop folder, which would otherwise serve and
  run the old code. Server output goes to `build/logs/server.log`.

## Project
- Removed the nested duplicate `hotloop-bench/hotloop-bench/` folder, build output and stale pid file. Added .gitignore.
