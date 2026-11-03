# Hotloop language benchmark

One algorithm program, about 4,000 lines per language, in 13 languages:
C, C++, Rust, Go, Java, C#, Kotlin, Swift, Dart, JavaScript, Python, Ruby, PHP.

It has 8 groups: sorting (9 sorts + selection), data structures (heap, Fenwick, segment tree, hash table, LRU, union-find...),
graphs (BFS, Dijkstra, Bellman-Ford, Floyd, MST, SCC, Dinic, Edmonds-Karp, LCA), dynamic programming (LCS, edit distance,
knapsack, TSP...), strings (KMP, Z, suffix array, Aho-Corasick...), compression (LZW, Huffman, BWT), numeric (NTT, sieve,
big factorial, Gauss, matrix power), and search (N-queens, sudoku, A*, life).

Every source file is generated from one neutral program in `generator/hl/`, so all languages do the same work and must
produce the same checksums. A group with a wrong checksum scores almost zero.

## Run
    ./run_all.sh              # every installed language
    ./run_all.sh c rust go    # only some

Each language runs 3 rounds, alternating between languages, and each group keeps its best time over the rounds, so a
slow moment from a background app or the CPU clocking down does not change the score (on a busy laptop single rounds
differed by up to 60%, the combined score by about 2%). Inside a round each group gets one untimed warm-up run, then at
least 3 timed runs within 1.5 s. `HOTLOOP_ROUNDS=1 ./run_all.sh` gives a quicker, less steady run. If rounds differ by more
than 15%, the run prints a warning: close heavy apps (builds, IDEs) and keep the charger plugged in.

It writes `results.txt`, including a `worst` row for each language: the lowest scoring
algorithm group among the eight groups. The normal `score` row remains the geometric
mean across all groups. `build_status.txt` records which requested languages built and
which were skipped because their compiler was unavailable.

## Web dashboard
**Always open it with `start.bat`** (macOS/Linux: `node launch.js`), not by double-clicking `index.html`.
start.bat starts the local runner and opens `http://127.0.0.1:4173` in your browser. If you open `index.html`
directly, it jumps to the dashboard when the runner is already running; otherwise it tells you to use start.bat.
If a dashboard from an older Hotloop folder is still running, start.bat stops it and starts this one.
Server errors are written to `build/logs/server.log`. `stop.bat` stops the dashboard.

On Windows, double-click `start.bat`. It starts the local dashboard at
`http://127.0.0.1:4173`. Node.js and Git for Windows (Bash) are needed to launch runs
from the dashboard. Use **Run benchmark** to run all installed languages or choose a
subset; the console shows output and refreshes the results and build status. You can
also import `results.txt`, import `build_status.txt`, search and sort the leaderboard,
inspect per-group scores, or export a CSV report. The server only listens on localhost.
Score 1000 = same speed as C -O2 on the machine the scores were calibrated on. Compare only within one paste.
**Overall score** (first summary card, and the last CSV row) is one number for the whole machine: the geometric mean
of the 12 reference languages' scores, measured where you ran them and estimated otherwise. It always uses the same
12 languages, so you can compare it between machines. The card also shows the reference machine's overall score.

## Estimated scores
`reference.js` holds a reference run of 12 languages (all except Swift). Languages you can't build show an amber
**estimated** score: the reference time scaled by your machine's speed, worked out per group from the languages you
did run. Estimates are guides; install the toolchain and run it for a real number. Running a few languages keeps the
earlier results of the others.

## Status
Built and run with matching checksums (all 8 groups): C, C++, Rust, Go, Java, C#, Kotlin, JavaScript, Python, Ruby, PHP.
Dart has compiled and passed on Windows. Swift comes from the same generator but has not been compiled yet;
if one fails, the compiler error is now printed and saved in `build/logs/<lang>-build.log`.
C# needs the .NET SDK 8 or newer (`src/csharp/bench.csproj` targets net8.0).

`run_all.sh` exits with 1 if any build or run failed, and records `compile-failed` / `run-failed` in `build_status.txt`.
`results.txt` starts with `#` lines recording the run time, OS, CPU and compiler versions.

## Regenerate
    cd generator && python3 gen/gen.py ../src
