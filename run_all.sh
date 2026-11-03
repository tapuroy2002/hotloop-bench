#!/bin/bash
# Hotloop: builds and runs every language that is installed, then writes results.txt.
# Usage: ./run_all.sh            (all languages found)
#        ./run_all.sh c rust go  (only these)
# Exit code: 0 = everything requested ran with matching checksums, 1 = something failed, 2 = bad arguments.
set -o pipefail
cd "$(dirname "$0")"
B=build; mkdir -p "$B" "$B/logs"
ARGS=("$@"); [ ${#ARGS[@]} -eq 0 ] && ARGS=(c cpp rust go java csharp kotlin swift dart javascript python ruby php)
for l in "${ARGS[@]}"; do case $l in c|cpp|rust|go|java|csharp|kotlin|swift|dart|javascript|python|ruby|php) ;; *) echo "error: unknown language: $l" >&2; exit 2 ;; esac; done

# Write to temp files and move them into place at the end, so a crashed or cancelled run
# never leaves you with an empty results.txt.
RES_TMP=results.txt.tmp; ST_TMP=build_status.txt.tmp
: > "$RES_TMP"; : > "$ST_TMP"
FAILS=0
finish() { mv -f "$RES_TMP" results.txt; mv -f "$ST_TMP" build_status.txt; }
ROUNDS_TMP="$B/rounds.txt"; : > "$ROUNDS_TMP"
trap 'echo "interrupted"; [ -s "$ROUNDS_TMP" ] && node combine_rounds.js "$ROUNDS_TMP" "$RES_TMP"; finish; exit 130' INT TERM

have() { command -v "$1" >/dev/null 2>&1; }
find_first() {  # first command from the list that actually runs (skips Windows Store stubs)
  local candidate
  while IFS= read -r candidate; do
    [ -n "$candidate" ] || continue
    if "$candidate" --version >/dev/null 2>&1; then printf '%s\n' "$candidate"; return 0; fi
  done < <(type -ap "$@" 2>/dev/null | awk '!seen[$0]++')
  return 1
}
PYTHON_CMD=$(find_first python3.exe python.exe python3 python || true)
DART_CMD=$(find_first dart.exe dart || true)

{
  echo "# hotloop run $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "# os=$(uname -srm 2>/dev/null)"
  cpu=$(grep -m1 'model name' /proc/cpuinfo 2>/dev/null | cut -d: -f2- | sed 's/^ //')
  [ -z "$cpu" ] && cpu=$(sysctl -n machdep.cpu.brand_string 2>/dev/null)
  echo "# cpu=${cpu:-unknown}"
} >> "$RES_TMP"

# Keep earlier results and status for languages that are not part of this run,
# so running a few languages does not erase the rest of the leaderboard.
name_of() { case $1 in c) echo C;; cpp) echo C++;; rust) echo Rust;; go) echo Go;; java) echo Java;; csharp) echo C#;; kotlin) echo Kotlin;;
  swift) echo Swift;; dart) echo Dart;; javascript) echo JavaScript;; python) echo Python;; ruby) echo Ruby;; php) echo PHP;; esac; }
requested() { for x in "${ARGS[@]}"; do [ "$x" = "$1" ] && return 0; done; return 1; }
for id in c cpp rust go java csharp kotlin swift dart javascript python ruby php; do
  requested "$id" && continue
  [ -f results.txt ] && grep -F "HOTLOOP|$(name_of "$id")|" results.txt | grep -v '|worst|' >> "$RES_TMP"
  [ -f build_status.txt ] && grep "^$id|" build_status.txt >> "$ST_TMP"
done

skip()   { echo "skip  $1: $2 not found"; echo "$1|unavailable|$2" >> "$ST_TMP"; }
declare -a RUN
built()  { RUN+=("$1"); echo "$1|compile-passed" >> "$ST_TMP"; }
failed() {
  FAILS=$((FAILS+1)); echo "$1|compile-failed" >> "$ST_TMP"
  echo "FAILED build $1 — last lines of $B/logs/$1-build.log:"; tail -n 25 "$B/logs/$1-build.log" | sed 's/^/    /'
}
add()    { RUN+=("$1"); echo "$1|runtime-available" >> "$ST_TMP"; }
ver()    { echo "# version $1: $("${@:2}" 2>&1 | grep -v "^Picked up" | head -n1)" >> "$RES_TMP"; }
# build <lang> <command...> : compiler output goes to a log file, shown only when the build fails
build()  { local l=$1; shift; if "$@" > "$B/logs/$l-build.log" 2>&1; then built "$l"; else failed "$l"; fi; }

# ---- build phase ----
for l in "${ARGS[@]}"; do
  echo "build $l ..."
  case $l in
    c)    if have gcc; then ver c gcc --version; build c gcc -O2 -ffp-contract=off -o "$B/c" src/c/main.c -lm; else skip c gcc; fi ;;
    cpp)  if have g++; then ver cpp g++ --version; build cpp g++ -O2 -std=c++17 -ffp-contract=off -o "$B/cpp" src/cpp/main.cpp; else skip cpp g++; fi ;;
    rust) if have rustc; then ver rust rustc --version; build rust rustc -O --edition 2021 -o "$B/rust" src/rust/main.rs; else skip rust rustc; fi ;;
    go)   if have go; then ver go go version; build go bash -c 'cd src/go && go build -o "../../$0/go" main.go' "$B"; else skip go go; fi ;;
    java) if have javac; then ver java java -version; mkdir -p "$B/java"; build java javac -d "$B/java" src/java/Main.java; else skip java javac; fi ;;
    csharp) if have dotnet && [ -n "$(dotnet --list-sdks 2>/dev/null)" ]; then ver csharp dotnet --version; build csharp dotnet build src/csharp/bench.csproj -c Release -o "$B/csharp" --nologo; else skip csharp "dotnet SDK"; fi ;;
    kotlin) if have kotlinc; then ver kotlin kotlinc -version; build kotlin kotlinc src/kotlin/main.kt -include-runtime -d "$B/kotlin.jar"; else skip kotlin kotlinc; fi ;;
    swift) if have swiftc; then ver swift swiftc --version; build swift swiftc -O src/swift/main.swift -o "$B/swift"; else skip swift swiftc; fi ;;
    dart) if [ -n "$DART_CMD" ]; then ver dart "$DART_CMD" --version; build dart "$DART_CMD" compile exe src/dart/main.dart -o "$B/dart"; else skip dart dart; fi ;;
    javascript) if have node; then ver javascript node --version; add javascript; else skip javascript node; fi ;;
    python) if [ -n "$PYTHON_CMD" ]; then ver python "$PYTHON_CMD" --version; add python; else skip python python3; fi ;;
    ruby)   if have ruby; then ver ruby ruby --version; add ruby; else skip ruby ruby; fi ;;
    php)    if have php; then ver php php --version; add php; else skip php php; fi ;;
  esac
done

# ---- run phase (one at a time, so timings stay clean) ----
# Every language runs ROUNDS times, alternating languages, and each group keeps its best time over all rounds
# (combine_rounds.js). A slow moment in one round, from a background app or the CPU clocking down, no longer
# changes the score. Set HOTLOOP_ROUNDS=1 for a quick, less steady run.
ROUNDS=${HOTLOOP_ROUNDS:-3}
case $ROUNDS in ''|*[!0-9]*|0) echo "error: HOTLOOP_ROUNDS must be a positive number" >&2; exit 2 ;; esac
echo "rounds $ROUNDS (each group keeps its best time over all rounds)"
declare -A DEAD
for ((round=1; round<=ROUNDS; round++)); do
for l in "${RUN[@]}"; do
  [ -n "${DEAD[$l]}" ] && continue
  echo "run   $l (round $round/$ROUNDS) ..."
  case $l in
    c|cpp|rust|go|swift|dart) ./"$B/$l" ;;
    java) java -cp "$B/java" Main ;;
    csharp) ./"$B/csharp/bench" ;;
    kotlin) java -jar "$B/kotlin.jar" ;;
    javascript) node src/javascript/main.js ;;
    python) PYTHONUNBUFFERED=1 "$PYTHON_CMD" src/python/main.py ;;
    ruby) ruby src/ruby/main.rb ;;
    php) php src/php/main.php ;;
  esac 2>&1 | awk -v out="$ROUNDS_TMP" '{ print; if ($0 ~ /^HOTLOOP\|/) print >> out; fflush(); }'
  rc=$?
  if [ $rc -ne 0 ]; then
    FAILS=$((FAILS+1)); DEAD[$l]=1; echo "$l|run-failed|exit $rc" >> "$ST_TMP"
    echo "FAILED run $l (exit code $rc) — see the output above"
  fi
done
done
echo
node combine_rounds.js "$ROUNDS_TMP" "$RES_TMP"
node score_summary.js "$RES_TMP"
finish
echo
if [ $FAILS -gt 0 ]; then echo "Done with $FAILS failure(s). See build_status.txt and $B/logs/."; exit 1; fi
echo "Done. Open the Hotloop dashboard to inspect the refreshed results."
