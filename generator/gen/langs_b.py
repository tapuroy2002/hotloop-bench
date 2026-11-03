"""Emitters: Kotlin, Swift, Dart, JavaScript, PHP, Python, Ruby."""
from front import isarr
from emit_base import Base, HoistMixin
from langs_a import gl


class Kotlin(Base):
    lang = "Kotlin"
    ext = "kt"
    semi = ""

    def open_scope(self):
        # A bare { } in Kotlin is a lambda literal, not a block (and after a call it becomes a trailing-lambda
        # argument). run { } is inline, so it is a real scope with no runtime cost.
        self.w("run {")
        self.ind += 1

    def T(self, t):
        return {"int": "Long", "float": "Double", "int[]": "LongArray", "float[]": "DoubleArray", "void": ""}[t]

    def lit_int(self, v):
        return "(%dL)" % v if v < 0 else "%dL" % v

    def glob(self, v):
        init = self.lit_int(v.init.a[0]) if v.t == "int" else self.lit_flt(v.init.a[0])
        return "var %s: %s = %s" % (v.m, self.T(v.t), init)

    def sig(self, f):
        ps = ", ".join("%s: %s" % (p.m, self.T(p.t)) for p in f.params)
        r = self.T(f.ret)
        return "fun %s(%s)%s" % (f.m, ps, ": " + r if r else "")

    def idx(self, a, i):
        return "%s[(%s).toInt()]" % (a, i)

    def len_(self, a):
        return "%s.size.toLong()" % a

    def newarr(self, t, n):
        return ("LongArray((%s).toInt())" if t == "int" else "DoubleArray((%s).toInt())") % n

    def to_float(self, x):
        return "(%s).toDouble()" % x

    def to_int(self, x):
        return "(%s).toLong()" % x

    def sqrt(self, x):
        return "Math.sqrt(%s)" % x

    def bin(self, op, l, r, e):
        m = {"&": "and", "|": "or", "^": "xor"}
        if op in m:
            return "(%s %s %s)" % (l, m[op], r)
        if op in ("<<", ">>"):
            return "(%s %s (%s).toInt())" % (l, "shl" if op == "<<" else "shr", r)
        return Base.bin(self, op, l, r, e)

    def decl(self, t, v, init):
        return "var %s: %s = %s" % (self.ref(v), self.T(t), init)

    def main(self):
        self.w("""fun runGroup(name: String, f: () -> Long, expected: Long, refMs: Double, fails: IntArray): Double {
    var best = 1e18
    var total = 0.0
    var runs = 0
    var ok = 1
    var chk = 0L
    while (runs < 4 || (total < 1500.0 && runs < 40)) {
        val t0 = System.nanoTime()
        chk = f()
        val dt = (System.nanoTime() - t0) / 1e6
        if (runs > 0 && dt < best) best = dt
        total += dt
        runs++
        if (chk != expected) ok = 0
    }
    if (hl_get_bad() != 0L) ok = 0
    println("HOTLOOP|Kotlin|" + name + "|" + String.format(java.util.Locale.ROOT, "%.3f", best) + "|" + ok + "|" + chk)
    if (ok == 0) fails[0]++
    return if (ok == 1) 1000.0 * refMs / best else 0.001
}

fun main() {
    val fails = IntArray(1)
    var n = 0
    var logsum = 0.0
    var p: Double""")
        self.ind = 1
        for l in gl(self, 'p = runGroup("NAME", ::FN, EXPL, REF, fails); logsum += Math.log(p); n++'):
            self.w(l)
        self.w('println("HOTLOOP|Kotlin|score|" + String.format(java.util.Locale.ROOT, "%.1f", Math.exp(logsum / n)) + "|" + fails[0])')
        self.w("if (fails[0] > 0) kotlin.system.exitProcess(1)")
        self.ind = 0
        self.w("}")


class Swift(HoistMixin, Base):
    lang = "Swift"
    ext = "swift"
    semi = ""

    def T(self, t):
        return {"int": "Int", "float": "Double", "int[]": "[Int]", "float[]": "[Double]", "void": ""}[t]

    def header(self):
        self.w("import Foundation")
        self.w()

    def glob(self, v):
        init = self.lit_int(v.init.a[0]) if v.t == "int" else self.lit_flt(v.init.a[0])
        return "var %s: %s = %s" % (v.m, self.T(v.t), init)

    def sig(self, f):
        ps = ", ".join("_ %s: %s%s" % (p.m, "inout " if isarr(p.t) else "", self.T(p.t)) for p in f.params)
        r = self.T(f.ret)
        return "func %s(%s)%s" % (f.m, ps, " -> " + r if r else "")

    def cond(self, c):
        return c

    def len_(self, a):
        return "%s.count" % a

    def newarr(self, t, n):
        return ("[Int](repeating: 0, count: %s)" if t == "int" else "[Double](repeating: 0.0, count: %s)") % n

    def to_float(self, x):
        return "Double(%s)" % x

    def to_int(self, x):
        return "Int(%s)" % x

    def sqrt(self, x):
        return "sqrt(%s)" % x

    def decl(self, t, v, init):
        return "var %s: %s = %s" % (self.ref(v), self.T(t), init)

    def arg(self, a, p):
        if isarr(p.t):
            return "&" + a.a[0].m
        return self.ex(a)

    def main(self):
        self.w("""func nowMs() -> Double { return Double(DispatchTime.now().uptimeNanoseconds) / 1e6 }

func runGroup(_ name: String, _ f: () -> Int, _ expected: Int, _ refMs: Double, _ fails: inout Int) -> Double {
    var best = 1e18
    var total = 0.0
    var runs = 0
    var ok = 1
    var chk = 0
    while runs < 4 || (total < 1500.0 && runs < 40) {
        let t0 = nowMs()
        chk = f()
        let dt = nowMs() - t0
        if runs > 0 && dt < best { best = dt }
        total += dt
        runs += 1
        if chk != expected { ok = 0 }
    }
    if hl_get_bad() != 0 { ok = 0 }
    print("HOTLOOP|Swift|" + name + "|" + String(format: "%.3f", best) + "|" + String(ok) + "|" + String(chk))
    if ok == 0 { fails += 1 }
    return ok == 1 ? 1000.0 * refMs / best : 0.001
}

var fails = 0
var n = 0
var logsum = 0.0
var p = 0.0""")
        for l in gl(self, 'p = runGroup("NAME", FN, EXP, REF, &fails); logsum += log(p); n += 1'):
            self.w(l)
        self.w('print("HOTLOOP|Swift|score|" + String(format: "%.1f", exp(logsum / Double(n))) + "|" + String(fails))')
        self.w("if fails > 0 { exit(1) }")


class Dart(Base):
    lang = "Dart"
    ext = "dart"

    def T(self, t):
        return {"int": "int", "float": "double", "int[]": "List<int>", "float[]": "List<double>", "void": "void"}[t]

    def header(self):
        self.w("import 'dart:io';")
        self.w("import 'dart:math' as math;")
        self.w()

    def glob(self, v):
        init = self.lit_int(v.init.a[0]) if v.t == "int" else self.lit_flt(v.init.a[0])
        return "%s %s = %s;" % (self.T(v.t), v.m, init)

    def sig(self, f):
        ps = ", ".join("%s %s" % (self.T(p.t), p.m) for p in f.params)
        return "%s %s(%s)" % (self.T(f.ret), f.m, ps)

    def div(self, l, r, t):
        return "(%s ~/ %s)" % (l, r) if t == "int" else "(%s / %s)" % (l, r)

    def len_(self, a):
        return "%s.length" % a

    def newarr(self, t, n):
        return ("List<int>.filled(%s, 0)" if t == "int" else "List<double>.filled(%s, 0.0)") % n

    def to_float(self, x):
        return "(%s).toDouble()" % x

    def to_int(self, x):
        return "(%s).toInt()" % x

    def sqrt(self, x):
        return "math.sqrt(%s)" % x

    def decl(self, t, v, init):
        return "%s %s = %s" % (self.T(t), self.ref(v), init)

    def main(self):
        self.w("""double runGroup(String name, int Function() f, int expected, double refMs, List<int> fails) {
  double best = 1e18, total = 0.0;
  int runs = 0, ok = 1;
  int chk = 0;
  final sw = Stopwatch()..start();
  while (runs < 4 || (total < 1500.0 && runs < 40)) {
    int t0 = sw.elapsedMicroseconds;
    chk = f();
    double dt = (sw.elapsedMicroseconds - t0) / 1000.0;
    if (runs > 0 && dt < best) best = dt;
    total += dt;
    runs++;
    if (chk != expected) ok = 0;
  }
  if (hl_get_bad() != 0) ok = 0;
  print('HOTLOOP|Dart|$name|${best.toStringAsFixed(3)}|$ok|$chk');
  if (ok == 0) fails[0]++;
  return ok == 1 ? 1000.0 * refMs / best : 0.001;
}

void main() {
  List<int> fails = [0];
  int n = 0;
  double logsum = 0.0, p;""")
        self.ind = 1
        for l in gl(self, 'p = runGroup("NAME", FN, EXP, REF, fails); logsum += math.log(p); n++;'):
            self.w(l)
        self.w("print('HOTLOOP|Dart|score|${math.exp(logsum / n).toStringAsFixed(1)}|${fails[0]}');")
        self.w("if (fails[0] > 0) exit(1);")
        self.ind = 0
        self.w("}")


class JS(Base):
    lang = "JavaScript"
    ext = "js"

    def header(self):
        self.w("'use strict';")
        self.w()

    def glob(self, v):
        init = self.lit_int(v.init.a[0]) if v.t == "int" else self.lit_flt(v.init.a[0])
        return "let %s = %s;" % (v.m, init)

    def sig(self, f):
        return "function %s(%s)" % (f.m, ", ".join(p.m for p in f.params))

    def div(self, l, r, t):
        return "Math.floor(%s / %s)" % (l, r) if t == "int" else "(%s / %s)" % (l, r)

    def len_(self, a):
        return "%s.length" % a

    def newarr(self, t, n):
        return ("new Array(%s).fill(0)" if t == "int" else "new Float64Array(%s)") % n

    def to_float(self, x):
        return x

    def to_int(self, x):
        return "Math.trunc(%s)" % x

    def sqrt(self, x):
        return "Math.sqrt(%s)" % x

    def decl(self, t, v, init):
        return "let %s = %s" % (self.ref(v), init)

    def main(self):
        self.w("""function runGroup(name, f, expected, refMs, st) {
    let best = 1e18, total = 0.0, runs = 0, ok = 1, chk = 0;
    while (runs < 4 || (total < 1500.0 && runs < 40)) {
        const t0 = performance.now();
        chk = f();
        const dt = performance.now() - t0;
        if (runs > 0 && dt < best) best = dt;
        total += dt;
        runs++;
        if (chk !== expected) ok = 0;
    }
    if (hl_get_bad() !== 0) ok = 0;
    console.log('HOTLOOP|JavaScript|' + name + '|' + best.toFixed(3) + '|' + ok + '|' + chk);
    if (ok === 0) st.fails++;
    return ok === 1 ? 1000.0 * refMs / best : 0.001;
}

const st = { fails: 0 };
let logsum = 0.0, n = 0, p;""")
        for l in gl(self, 'p = runGroup("NAME", FN, EXP, REF, st); logsum += Math.log(p); n++;'):
            self.w(l)
        self.w("console.log('HOTLOOP|JavaScript|score|' + Math.exp(logsum / n).toFixed(1) + '|' + st.fails);")
        self.w("if (st.fails > 0) process.exit(1);")


class PHP(Base):
    lang = "PHP"
    ext = "php"

    def header(self):
        self.w("<?php")
        self.w("declare(strict_types=0);")
        self.w()

    def glob(self, v):
        init = self.lit_int(v.init.a[0]) if v.t == "int" else self.lit_flt(v.init.a[0])
        return "$%s = %s;" % (v.m, init)

    def ref(self, v):
        return "$" + v.m

    def T(self, t):
        return {"int": "int", "float": "float", "int[]": "array", "float[]": "array", "void": "void"}[t]

    def sig(self, f):
        ps = ", ".join("%s%s $%s" % (self.T(p.t), " &" if isarr(p.t) else "", p.m) for p in f.params)
        return "function %s(%s): %s" % (f.m, ps, self.T(f.ret))

    def fbody(self, f):
        names = []
        for v in f.gused + f.gset:
            if v.m not in names:
                names.append(v.m)
        if names:
            self.w("global " + ", ".join("$" + n for n in names) + ";")
        self.block(f.body)

    def div(self, l, r, t):
        return "intdiv(%s, %s)" % (l, r) if t == "int" else "(%s / %s)" % (l, r)

    def len_(self, a):
        return "count(%s)" % a

    def newarr(self, t, n):
        return ("array_fill(0, %s, 0)" if t == "int" else "array_fill(0, %s, 0.0)") % n

    def to_float(self, x):
        return "((float)(%s))" % x

    def to_int(self, x):
        return "((int)(%s))" % x

    def sqrt(self, x):
        return "sqrt(%s)" % x

    def decl(self, t, v, init):
        return "%s = %s" % (self.ref(v), init)

    def main(self):
        self.w("""function run_group(string $name, string $f, int $expected, float $ref_ms, array &$st): float {
    $best = 1e18; $total = 0.0; $runs = 0; $ok = 1; $chk = 0;
    while ($runs < 4 || ($total < 1500.0 && $runs < 40)) {
        $t0 = hrtime(true);
        $chk = $f();
        $dt = (hrtime(true) - $t0) / 1e6;
        if ($runs > 0 && $dt < $best) { $best = $dt; }
        $total += $dt;
        $runs++;
        if ($chk !== $expected) { $ok = 0; }
    }
    if (hl_get_bad() !== 0) { $ok = 0; }
    echo 'HOTLOOP|PHP|' . $name . '|' . sprintf('%.3f', $best) . '|' . $ok . '|' . $chk . "\\n";
    if ($ok === 0) { $st[0]++; }
    return $ok === 1 ? 1000.0 * $ref_ms / $best : 0.001;
}

$st = [0];
$logsum = 0.0; $n = 0;""")
        for l in gl(self, "$p = run_group('NAME', 'FN', EXP, REF, $st); $logsum += log($p); $n++;"):
            self.w(l)
        self.w("echo 'HOTLOOP|PHP|score|' . sprintf('%.1f', exp($logsum / $n)) . '|' . $st[0] . \"\\n\";")
        self.w("exit($st[0] > 0 ? 1 : 0);")


class PyLike(Base):
    """Languages that use indentation or `end` instead of braces."""
    semi = ""

    def cond(self, c):
        return c

    def open_scope(self):
        pass

    def close_scope(self):
        pass


class Python(PyLike):
    lang = "Python"
    ext = "py"

    def header(self):
        self.w("import math")
        self.w("import sys")
        self.w("import time")
        self.w()
        self.w("sys.setrecursionlimit(20000)")
        self.w()

    def glob(self, v):
        init = self.lit_int(v.init.a[0]) if v.t == "int" else self.lit_flt(v.init.a[0])
        return "%s = %s" % (v.m, init)

    def sig(self, f):
        return "def %s(%s)" % (f.m, ", ".join(p.m for p in f.params))

    def not_(self, c):
        return "(not %s)" % c

    def logic(self, op, l, r):
        return "(%s %s %s)" % (l, "and" if op == "&&" else "or", r)

    def div(self, l, r, t):
        return "(%s // %s)" % (l, r) if t == "int" else "(%s / %s)" % (l, r)

    def len_(self, a):
        return "len(%s)" % a

    def newarr(self, t, n):
        return ("([0] * (%s))" if t == "int" else "([0.0] * (%s))") % n

    def to_float(self, x):
        return "float(%s)" % x

    def to_int(self, x):
        return "int(%s)" % x

    def sqrt(self, x):
        return "math.sqrt(%s)" % x

    def decl(self, t, v, init):
        return "%s = %s" % (self.ref(v), init)

    def func(self, f):
        self.w(self.sig(f) + ":")
        self.ind += 1
        if f.gset:
            self.w("global " + ", ".join(v.m for v in f.gset))
        self.block(f.body)
        self.ind -= 1
        self.w()
        self.w()

    def inner(self, stmts):
        self.ind += 1
        n = len(self.o)
        self.block(stmts)
        if len(self.o) == n:
            self.w("pass")
        self.ind -= 1

    def st_if(self, st):
        self.w("if %s:" % self.ex(st.c))
        cur = st
        while True:
            self.inner(cur.then)
            els = cur.els
            if els is None:
                break
            if len(els) == 1 and els[0].k == "if" and getattr(els[0], "elif_", False):
                cur = els[0]
                self.w("elif %s:" % self.ex(cur.c))
                continue
            self.w("else:")
            self.inner(els)
            break

    def st_while(self, st):
        self.w("while %s:" % self.ex(st.c))
        self.loops.append(None)
        self.inner(st.body)
        self.loops.pop()

    def st_for(self, st):
        step = "" if st.step.k == "int" and st.step.a[0] == 1 else ", " + self.ex(st.step)
        self.w("for %s in range(%s, %s%s):" % (self.ref(st.v), self.ex(st.lo), self.ex(st.hi), step))
        self.loops.append(None)
        self.inner(st.body)
        self.loops.pop()

    def main(self):
        self.w("""def run_group(name, f, expected, ref_ms, st):
    best = 1e18
    total = 0.0
    runs = 0
    ok = 1
    chk = 0
    while runs < 4 or (total < 1500.0 and runs < 40):
        t0 = time.perf_counter()
        chk = f()
        dt = (time.perf_counter() - t0) * 1000.0
        if runs > 0 and dt < best:
            best = dt
        total += dt
        runs += 1
        if chk != expected:
            ok = 0
    if hl_get_bad() != 0:
        ok = 0
    print("HOTLOOP|Python|%s|%.3f|%d|%d" % (name, best, ok, chk))
    if ok == 0:
        st[0] += 1
    return 1000.0 * ref_ms / best if ok == 1 else 0.001


def main():
    st = [0]
    logsum = 0.0
    n = 0""")
        self.ind = 1
        for l in gl(self, 'p = run_group("NAME", FN, EXP, REF, st); logsum += math.log(p); n += 1'):
            self.w(l)
        self.w('print("HOTLOOP|Python|score|%.1f|%d" % (math.exp(logsum / n), st[0]))')
        self.w("sys.exit(1 if st[0] > 0 else 0)")
        self.ind = 0
        self.w()
        self.w()
        self.w('if __name__ == "__main__":')
        self.w("    main()")


class Ruby(PyLike):
    lang = "Ruby"
    ext = "rb"
    kw_continue = "next"

    def header(self):
        self.w("# frozen_string_literal: false")
        self.w()

    def glob(self, v):
        init = self.lit_int(v.init.a[0]) if v.t == "int" else self.lit_flt(v.init.a[0])
        return "$%s = %s" % (v.m, init)

    def ref(self, v):
        return "$" + v.m if v.kind == "global" else v.m

    def sig(self, f):
        return "def %s(%s)" % (f.m, ", ".join(p.m for p in f.params))

    def len_(self, a):
        return "%s.length" % a

    def newarr(self, t, n):
        return ("Array.new(%s, 0)" if t == "int" else "Array.new(%s, 0.0)") % n

    def to_float(self, x):
        return "(%s).to_f" % x

    def to_int(self, x):
        return "(%s).to_i" % x

    def sqrt(self, x):
        return "Math.sqrt(%s)" % x

    def decl(self, t, v, init):
        return "%s = %s" % (self.ref(v), init)

    def func(self, f):
        self.w(self.sig(f))
        self.ind += 1
        self.block(f.body)
        self.ind -= 1
        self.w("end")
        self.w()

    def st_if(self, st):
        self.w("if %s" % self.ex(st.c))
        cur = st
        while True:
            self.inner(cur.then)
            els = cur.els
            if els is None:
                break
            if len(els) == 1 and els[0].k == "if" and getattr(els[0], "elif_", False):
                cur = els[0]
                self.w("elsif %s" % self.ex(cur.c))
                continue
            self.w("else")
            self.inner(els)
            break
        self.w("end")

    def st_while(self, st):
        self.w("while %s" % self.ex(st.c))
        self.loops.append(None)
        self.inner(st.body)
        self.loops.pop()
        self.w("end")

    def st_for(self, st):
        hi = self.tmp("hi")
        self.w("%s = %s" % (self.ref(hi), self.ex(st.hi)))
        if st.step.k == "int":
            step = self.ex(st.step)
        else:
            sv = self.tmp("st")
            self.w("%s = %s" % (self.ref(sv), self.ex(st.step)))
            step = self.ref(sv)
        self.w("%s = %s" % (self.ref(st.v), self.ex(st.lo)))
        self.w("while %s < %s" % (self.ref(st.v), self.ref(hi)))
        incr = "%s = (%s + %s)" % (self.ref(st.v), self.ref(st.v), step)
        self.loops.append(incr)
        self.inner(st.body)
        self.ind += 1
        self.w(incr)
        self.ind -= 1
        self.loops.pop()
        self.w("end")

    def main(self):
        self.w("""def run_group(name, f, expected, ref_ms, st)
  best = 1e18
  total = 0.0
  runs = 0
  ok = 1
  chk = 0
  while runs < 4 || (total < 1500.0 && runs < 40)
    t0 = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    chk = f.call
    dt = (Process.clock_gettime(Process::CLOCK_MONOTONIC) - t0) * 1000.0
    best = dt if runs > 0 && dt < best
    total += dt
    runs += 1
    ok = 0 if chk != expected
  end
  ok = 0 if hl_get_bad() != 0
  puts "HOTLOOP|Ruby|#{name}|#{format('%.3f', best)}|#{ok}|#{chk}"
  st[0] += 1 if ok == 0
  ok == 1 ? 1000.0 * ref_ms / best : 0.001
end

st = [0]
logsum = 0.0
n = 0""")
        for l in gl(self, 'p = run_group("NAME", method(:FN), EXP, REF, st); logsum += Math.log(p); n += 1'):
            self.w(l)
        self.w('puts "HOTLOOP|Ruby|score|#{format(\'%.1f\', Math.exp(logsum / n))}|#{st[0]}"')
        self.w("exit(st[0] > 0 ? 1 : 0)")
