"""Emitters: C, C++, Java, C#, Go, Rust."""
from front import isarr
from emit_base import Base, HoistMixin


def gl(em, fmt):
    """Expand one line per group. Placeholders: NAME FN EXP REF."""
    out = []
    for name, fn, exp, ref in em.groups:
        out.append(fmt.replace("NAME", name).replace("FN", fn).replace("EXP", str(exp)).replace("REF", repr(float(ref))))
    return out


class C(Base):
    lang = "C"
    ext = "c"

    def T(self, t):
        return {"int": "int64_t", "float": "double", "int[]": "IA", "float[]": "FA", "void": "void"}[t]

    def lit_int(self, v):
        s = str(v) if abs(v) < 2 ** 31 else "%dLL" % v
        return "(%s)" % s if v < 0 else s

    def header(self):
        for l in """#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <math.h>
#include <time.h>

typedef struct { int64_t *d; int64_t n; } IA;
typedef struct { double *d; int64_t n; } FA;

static unsigned char *arena = NULL;
static size_t arena_used = 0;
static const size_t ARENA_CAP = (size_t)768 << 20;

static void *arena_alloc(size_t bytes) {
    bytes = (bytes + 15) & ~(size_t)15;
    if (arena_used + bytes > ARENA_CAP) { fprintf(stderr, "arena exhausted\\n"); exit(2); }
    void *p = arena + arena_used;
    arena_used += bytes;
    memset(p, 0, bytes);
    return p;
}

static IA ia_new(int64_t n) { IA a; a.n = n; a.d = (int64_t *)arena_alloc((size_t)n * 8 + 8); return a; }
static FA fa_new(int64_t n) { FA a; a.n = n; a.d = (double *)arena_alloc((size_t)n * 8 + 8); return a; }
""".split("\n"):
            self.w(l)

    def glob(self, v):
        init = self.lit_int(v.init.a[0]) if v.t == "int" else self.lit_flt(v.init.a[0])
        return "static %s %s = %s;" % (self.T(v.t), v.m, init)

    def sig(self, f):
        ps = ", ".join("%s %s" % (self.T(p.t), p.m) for p in f.params) or "void"
        return "static %s %s(%s)" % (self.T(f.ret), f.m, ps)

    def protos(self):
        for f in self.p.funcs.values():
            self.w(self.sig(f) + ";")
        self.w()

    def idx(self, a, i):
        return "%s.d[%s]" % (a, i)

    def len_(self, a):
        return a + ".n"

    def newarr(self, t, n):
        return ("ia_new(%s)" if t == "int" else "fa_new(%s)") % n

    def to_float(self, x):
        return "((double)(%s))" % x

    def to_int(self, x):
        return "((int64_t)(%s))" % x

    def sqrt(self, x):
        return "sqrt(%s)" % x

    def decl(self, t, v, init):
        return "%s %s = %s" % (self.T(t), self.ref(v), init)

    def main(self):
        self.w("static double now_ms(void) { struct timespec ts; clock_gettime(CLOCK_MONOTONIC, &ts); return ts.tv_sec * 1000.0 + ts.tv_nsec / 1e6; }")
        self.w("""
static double run_group(const char *name, int64_t (*f)(void), int64_t expected, double ref_ms, int *fails) {
    double best = 1e18, total = 0.0;
    int runs = 0, ok = 1;
    int64_t chk = 0;
    while (runs < 4 || (total < 1500.0 && runs < 40)) {
        arena_used = 0;
        double t0 = now_ms();
        chk = f();
        double dt = now_ms() - t0;
        if (runs > 0 && dt < best) best = dt;
        total += dt;
        runs++;
        if (chk != expected) ok = 0;
    }
    if (hl_get_bad() != 0) ok = 0;
    printf("HOTLOOP|%s|%s|%.3f|%d|%lld\\n", "@L@", name, best, ok, (long long)chk);
    if (!ok) (*fails)++;
    return ok ? 1000.0 * ref_ms / best : 0.001;
}

int main(void) {
    arena = (unsigned char *)malloc(ARENA_CAP);
    if (!arena) { fprintf(stderr, "no memory\\n"); return 2; }
    int fails = 0, n = 0;
    double logsum = 0.0, p;""".replace("@L@", self.lang))
        self.ind = 1
        for l in gl(self, 'p = run_group("NAME", FN, EXPLL, REF, &fails); logsum += log(p); n++;'):
            self.w(l)
        self.w('printf("HOTLOOP|%s|score|%.1f|%d\\n", "@L@", exp(logsum / n), fails);'.replace("@L@", self.lang))
        self.w("return fails ? 1 : 0;")
        self.ind = 0
        self.w("}")


class Cpp(C):
    lang = "C++"
    ext = "cpp"

    def T(self, t):
        return {"int": "int64_t", "float": "double", "int[]": "IA", "float[]": "FA", "void": "void"}[t]

    def header(self):
        for l in """#include <cstdio>
#include <cstdint>
#include <cstdlib>
#include <cmath>
#include <vector>
#include <chrono>

typedef std::vector<int64_t> IA;
typedef std::vector<double> FA;
""".split("\n"):
            self.w(l)

    def sig(self, f):
        ps = ", ".join(("%s& %s" if isarr(p.t) else "%s %s") % (self.T(p.t), p.m) for p in f.params)
        return "static %s %s(%s)" % (self.T(f.ret), f.m, ps)

    def idx(self, a, i):
        return "%s[%s]" % (a, i)

    def len_(self, a):
        return "((int64_t)%s.size())" % a

    def newarr(self, t, n):
        return ("IA((size_t)(%s), 0)" if t == "int" else "FA((size_t)(%s), 0.0)") % n

    def sqrt(self, x):
        return "std::sqrt(%s)" % x

    def main(self):
        self.w("""static double now_ms() {
    using namespace std::chrono;
    return duration<double, std::milli>(steady_clock::now().time_since_epoch()).count();
}

static double run_group(const char *name, int64_t (*f)(), int64_t expected, double ref_ms, int *fails) {
    double best = 1e18, total = 0.0;
    int runs = 0, ok = 1;
    int64_t chk = 0;
    while (runs < 4 || (total < 1500.0 && runs < 40)) {
        double t0 = now_ms();
        chk = f();
        double dt = now_ms() - t0;
        if (runs > 0 && dt < best) best = dt;
        total += dt;
        runs++;
        if (chk != expected) ok = 0;
    }
    if (hl_get_bad() != 0) ok = 0;
    std::printf("HOTLOOP|C++|%s|%.3f|%d|%lld\\n", name, best, ok, (long long)chk);
    if (!ok) (*fails)++;
    return ok ? 1000.0 * ref_ms / best : 0.001;
}

int main() {
    int fails = 0, n = 0;
    double logsum = 0.0, p;""")
        self.ind = 1
        for l in gl(self, 'p = run_group("NAME", FN, EXPLL, REF, &fails); logsum += std::log(p); n++;'):
            self.w(l)
        self.w('std::printf("HOTLOOP|C++|score|%.1f|%d\\n", std::exp(logsum / n), fails);')
        self.w("return fails ? 1 : 0;")
        self.ind = 0
        self.w("}")


class Java(Base):
    lang = "Java"
    ext = "java"

    def T(self, t):
        return {"int": "long", "float": "double", "int[]": "long[]", "float[]": "double[]", "void": "void"}[t]

    def lit_int(self, v):
        return "(%dL)" % v if v < 0 else "%dL" % v

    def header(self):
        self.w("import java.util.function.LongSupplier;")
        self.w()
        self.w("public class Main {")
        self.ind = 1

    def glob(self, v):
        init = self.lit_int(v.init.a[0]) if v.t == "int" else self.lit_flt(v.init.a[0])
        return "static %s %s = %s;" % (self.T(v.t), v.m, init)

    def sig(self, f):
        ps = ", ".join("%s %s" % (self.T(p.t), p.m) for p in f.params)
        return "static %s %s(%s)" % (self.T(f.ret), f.m, ps)

    def idx(self, a, i):
        return "%s[(int)(%s)]" % (a, i)

    def len_(self, a):
        return "((long)%s.length)" % a

    def newarr(self, t, n):
        return ("new long[(int)(%s)]" if t == "int" else "new double[(int)(%s)]") % n

    def to_float(self, x):
        return "((double)(%s))" % x

    def to_int(self, x):
        return "((long)(%s))" % x

    def sqrt(self, x):
        return "Math.sqrt(%s)" % x

    def decl(self, t, v, init):
        return "%s %s = %s" % (self.T(t), self.ref(v), init)

    def main(self):
        self.w("""static double runGroup(String name, LongSupplier f, long expected, double refMs, int[] fails) {
    double best = 1e18, total = 0.0;
    int runs = 0, ok = 1;
    long chk = 0;
    while (runs < 4 || (total < 1500.0 && runs < 40)) {
        long t0 = System.nanoTime();
        chk = f.getAsLong();
        double dt = (System.nanoTime() - t0) / 1e6;
        if (runs > 0 && dt < best) best = dt;
        total += dt;
        runs++;
        if (chk != expected) ok = 0;
    }
    if (hl_get_bad() != 0) ok = 0;
    System.out.println("HOTLOOP|Java|" + name + "|" + String.format(java.util.Locale.ROOT, "%.3f", best) + "|" + ok + "|" + chk);
    if (ok == 0) fails[0]++;
    return ok == 1 ? 1000.0 * refMs / best : 0.001;
}

public static void main(String[] args) {
    int[] fails = new int[1];
    int n = 0;
    double logsum = 0.0, p;""")
        self.ind = 1
        for l in gl(self, 'p = runGroup("NAME", Main::FN, EXPL, REF, fails); logsum += Math.log(p); n++;'):
            self.w(l)
        self.w('System.out.println("HOTLOOP|Java|score|" + String.format(java.util.Locale.ROOT, "%.1f", Math.exp(logsum / n)) + "|" + fails[0]);')
        self.w("System.exit(fails[0] > 0 ? 1 : 0);")
        self.ind = 0
        self.w("}")
        self.w("}")


class CSharp(Base):
    lang = "C#"
    ext = "cs"

    def T(self, t):
        return {"int": "long", "float": "double", "int[]": "long[]", "float[]": "double[]", "void": "void"}[t]

    def lit_int(self, v):
        return "(%dL)" % v if v < 0 else "%dL" % v

    def header(self):
        self.w("using System;")
        self.w("using System.Diagnostics;")
        self.w()
        self.w("static class Program {")
        self.ind = 1

    def glob(self, v):
        init = self.lit_int(v.init.a[0]) if v.t == "int" else self.lit_flt(v.init.a[0])
        return "static %s %s = %s;" % (self.T(v.t), v.m, init)

    def sig(self, f):
        ps = ", ".join("%s %s" % (self.T(p.t), p.m) for p in f.params)
        return "static %s %s(%s)" % (self.T(f.ret), f.m, ps)

    def len_(self, a):
        return "%s.LongLength" % a

    def newarr(self, t, n):
        return ("new long[%s]" if t == "int" else "new double[%s]") % n

    def to_float(self, x):
        return "((double)(%s))" % x

    def to_int(self, x):
        return "((long)(%s))" % x

    def sqrt(self, x):
        return "Math.Sqrt(%s)" % x

    def bin(self, op, l, r, e):
        if op in ("<<", ">>"):
            return "(%s %s (int)(%s))" % (l, op, r)
        return Base.bin(self, op, l, r, e)

    def decl(self, t, v, init):
        return "%s %s = %s" % (self.T(t), self.ref(v), init)

    def main(self):
        self.w("""static double RunGroup(string name, Func<long> f, long expected, double refMs, int[] fails) {
    double best = 1e18, total = 0.0;
    int runs = 0, ok = 1;
    long chk = 0;
    while (runs < 4 || (total < 1500.0 && runs < 40)) {
        long t0 = Stopwatch.GetTimestamp();
        chk = f();
        double dt = (Stopwatch.GetTimestamp() - t0) * 1000.0 / Stopwatch.Frequency;
        if (runs > 0 && dt < best) best = dt;
        total += dt;
        runs++;
        if (chk != expected) ok = 0;
    }
    if (hl_get_bad() != 0) ok = 0;
    Console.WriteLine("HOTLOOP|C#|" + name + "|" + best.ToString("F3", System.Globalization.CultureInfo.InvariantCulture) + "|" + ok + "|" + chk);
    if (ok == 0) fails[0]++;
    return ok == 1 ? 1000.0 * refMs / best : 0.001;
}

static int Main() {
    int[] fails = new int[1];
    int n = 0;
    double logsum = 0.0, p;""")
        self.ind = 1
        for l in gl(self, 'p = RunGroup("NAME", FN, EXPL, REF, fails); logsum += Math.Log(p); n++;'):
            self.w(l)
        self.w('Console.WriteLine("HOTLOOP|C#|score|" + Math.Exp(logsum / n).ToString("F1", System.Globalization.CultureInfo.InvariantCulture) + "|" + fails[0]);')
        self.w("return fails[0] > 0 ? 1 : 0;")
        self.ind = 0
        self.w("}")
        self.w("}")


class Go(Base):
    lang = "Go"
    ext = "go"
    semi = ""
    indent = "\t"
    kw_while = "for"

    def T(self, t):
        return {"int": "int64", "float": "float64", "int[]": "[]int64", "float[]": "[]float64", "void": ""}[t]

    def header(self):
        self.w('package main')
        self.w()
        self.w('import (')
        self.w('\t"fmt"')
        self.w('\t"math"')
        self.w('\t"os"')
        self.w('\t"time"')
        self.w(')')
        self.w()

    def glob(self, v):
        init = self.lit_int(v.init.a[0]) if v.t == "int" else self.lit_flt(v.init.a[0])
        return "var %s %s = %s" % (v.m, self.T(v.t), init)

    def sig(self, f):
        ps = ", ".join("%s %s" % (p.m, self.T(p.t)) for p in f.params)
        r = self.T(f.ret)
        return "func %s(%s)%s" % (f.m, ps, " " + r if r else "")

    def cond(self, c):
        return c

    def len_(self, a):
        return "int64(len(%s))" % a

    def newarr(self, t, n):
        return ("make([]int64, %s)" if t == "int" else "make([]float64, %s)") % n

    def to_float(self, x):
        return "float64(%s)" % x

    def to_int(self, x):
        return "int64(%s)" % x

    def sqrt(self, x):
        return "math.Sqrt(%s)" % x

    def decl(self, t, v, init):
        return "var %s %s = %s" % (self.ref(v), self.T(t), init)

    def main(self):
        self.w("""func runGroup(name string, f func() int64, expected int64, refMs float64, fails *int) float64 {
	best := 1e18
	total := 0.0
	runs := 0
	ok := 1
	var chk int64 = 0
	for runs < 4 || (total < 1500.0 && runs < 40) {
		t0 := time.Now()
		chk = f()
		dt := float64(time.Since(t0).Nanoseconds()) / 1e6
		if runs > 0 && dt < best {
			best = dt
		}
		total += dt
		runs++
		if chk != expected {
			ok = 0
		}
	}
	if hl_get_bad() != 0 {
		ok = 0
	}
	fmt.Printf("HOTLOOP|Go|%s|%.3f|%d|%d\\n", name, best, ok, chk)
	if ok == 0 {
		*fails++
	}
	if ok == 1 {
		return 1000.0 * refMs / best
	}
	return 0.001
}

func main() {
	fails := 0
	n := 0
	logsum := 0.0
	p := 0.0""")
        self.ind = 1
        for l in gl(self, 'p = runGroup("NAME", FN, EXP, REF, &fails); logsum += math.Log(p); n++'):
            self.w(l)
        self.w('fmt.Printf("HOTLOOP|Go|score|%.1f|%d\\n", math.Exp(logsum/float64(n)), fails)')
        self.w("if fails > 0 {")
        self.w("\tos.Exit(1)")
        self.w("}")
        self.ind = 0
        self.w("}")


class Rust(Base):
    lang = "Rust"
    ext = "rs"

    def T(self, t):
        return {"int": "i64", "float": "f64", "int[]": "Vec<i64>", "float[]": "Vec<f64>", "void": ""}[t]

    def header(self):
        self.w("#![allow(warnings)]")
        self.w("use std::time::Instant;")
        self.w()

    def glob(self, v):
        init = self.lit_int(v.init.a[0]) if v.t == "int" else self.lit_flt(v.init.a[0])
        return "static mut %s: %s = %s;" % (v.m, self.T(v.t), init)

    def sig(self, f):
        ps = ", ".join("%s: %s" % (p.m, ("&mut " + self.T(p.t)) if isarr(p.t) else self.T(p.t)) for p in f.params)
        r = self.T(f.ret)
        return "fn %s(%s)%s" % (f.m, ps, " -> " + r if r else "")

    def ref(self, v):
        if v.kind == "global":
            return "(unsafe { %s })" % v.m
        return v.m

    def assign(self, v, rhs):
        if v.kind == "global":
            return "unsafe { %s = %s; }" % (v.m, rhs)
        return "%s = %s" % (v.m, rhs)

    def st_assign(self, st):
        self.pre(st.e)
        a = self.assign(st.v, self.ex(st.e))
        self.w(a if a.endswith("}") else a + ";")

    def cond(self, c):
        return c

    def idx(self, a, i):
        return "%s[(%s) as usize]" % (a, i)

    def len_(self, a):
        return "(%s.len() as i64)" % a

    def newarr(self, t, n):
        return ("vec![0i64; (%s) as usize]" if t == "int" else "vec![0.0f64; (%s) as usize]") % n

    def to_float(self, x):
        return "((%s) as f64)" % x

    def to_int(self, x):
        return "((%s) as i64)" % x

    def sqrt(self, x):
        return "(%s).sqrt()" % x

    def decl(self, t, v, init):
        return "let mut %s: %s = %s" % (self.ref(v), self.T(t), init)

    def arg(self, a, p):
        if isarr(p.t):
            v = a.a[0]
            return v.m if v.kind == "param" else "&mut " + v.m
        return self.ex(a)

    def user_call(self, e):
        f = e.fn
        lets, parts = [], []
        for a, p in zip(e.a[1], f.params):
            if f.hasarr and not isarr(p.t) and a.k not in ("int", "flt", "var") and a.over is None:
                t = self.tmp("a", p.t)
                lets.append("let %s: %s = %s;" % (t.m, self.T(p.t), self.ex(a)))
                parts.append(t.m)
            else:
                parts.append(self.arg(a, p))
        call = "%s(%s)" % (f.m, ", ".join(parts))
        if lets:
            return "({ %s %s })" % (" ".join(lets), call)
        return call

    def main(self):
        self.w("""fn run_group(name: &str, f: fn() -> i64, expected: i64, ref_ms: f64, fails: &mut i32) -> f64 {
    let mut best = 1e18f64;
    let mut total = 0.0f64;
    let mut runs = 0;
    let mut ok = 1;
    let mut chk: i64 = 0;
    while runs < 4 || (total < 1500.0 && runs < 40) {
        let t0 = Instant::now();
        chk = f();
        let dt = t0.elapsed().as_secs_f64() * 1000.0;
        if runs > 0 && dt < best { best = dt; }
        total += dt;
        runs += 1;
        if chk != expected { ok = 0; }
    }
    if hl_get_bad() != 0 { ok = 0; }
    println!("HOTLOOP|Rust|{}|{:.3}|{}|{}", name, best, ok, chk);
    if ok == 0 { *fails += 1; }
    if ok == 1 { 1000.0 * ref_ms / best } else { 0.001 }
}

fn main() {
    let mut fails: i32 = 0;
    let mut n = 0;
    let mut logsum = 0.0f64;
    let mut p: f64;""")
        self.ind = 1
        for l in gl(self, 'p = run_group("NAME", FN, EXP, REF, &mut fails); logsum += p.ln(); n += 1;'):
            self.w(l)
        self.w('println!("HOTLOOP|Rust|score|{:.1}|{}", (logsum / n as f64).exp(), fails);')
        self.w("if fails > 0 { std::process::exit(1); }")
        self.ind = 0
        self.w("}")
