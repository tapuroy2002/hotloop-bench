"""Shared emitter machinery for the Hotloop generator."""
from front import V, DSLError, isarr


class Base:
    lang = ""
    ext = ""
    semi = ";"
    indent = "    "

    def __init__(self, prog, cfg):
        self.p = prog
        self.cfg = cfg
        self.o = []
        self.ind = 0
        self.cnt = 0
        self.loops = []
        self.groups = []
        for name, f in prog.funcs.items():
            if name.startswith("group_"):
                short = name[6:]
                exp, ref = cfg.get("groups", {}).get(short, (-1, 1.0))
                self.groups.append((short, f.m, exp, ref))

    # ---------- output helpers ----------
    def w(self, line=""):
        self.o.append(self.indent * self.ind + line if line else "")

    def tmp(self, kind="t", t="int"):
        self.cnt += 1
        return V("zz%s%d" % (kind, self.cnt), t, "local")

    def text(self):
        self.header()
        self.globals_()
        self.protos()
        for f in self.p.funcs.values():
            self.func(f)
        self.main()
        return "\n".join(self.o) + "\n"

    # ---------- default hooks ----------
    def header(self):
        pass

    def protos(self):
        pass

    def globals_(self):
        for v in self.p.globals:
            self.w(self.glob(v))
        self.w()

    def lit_int(self, v):
        return "(%d)" % v if v < 0 else str(v)

    def lit_flt(self, v):
        r = repr(float(v))
        return "(%s)" % r if v < 0 else r

    def ref(self, v):
        return v.m

    def idx(self, a, i):
        return "%s[%s]" % (a, i)

    def cond(self, c):
        return "(%s)" % c

    def not_(self, c):
        return "(!%s)" % c

    def logic(self, op, l, r):
        return "(%s %s %s)" % (l, op, r)

    def div(self, l, r, t):
        return "(%s / %s)" % (l, r)

    def bin(self, op, l, r, e):
        if op == "/":
            return self.div(l, r, e.a[1].t)
        if op in ("&&", "||"):
            return self.logic(op, l, r)
        return "(%s %s %s)" % (l, op, r)

    def pre(self, e):
        pass

    def arg(self, a, p):
        return self.ex(a)

    def user_call(self, e):
        f = e.fn
        return "%s(%s)" % (f.m, ", ".join(self.arg(a, p) for a, p in zip(e.a[1], f.params)))

    # ---------- expressions ----------
    def ex(self, e):
        if e.over is not None:
            return e.over
        k = e.k
        if k == "int":
            return self.lit_int(e.a[0])
        if k == "flt":
            return self.lit_flt(e.a[0])
        if k == "var":
            return self.ref(e.a[0])
        if k == "idx":
            return self.idx(self.ex(e.a[0]), self.ex(e.a[1]))
        if k == "not":
            return self.not_(self.ex(e.a[0]))
        if k == "bin":
            return self.bin(e.a[0], self.ex(e.a[1]), self.ex(e.a[2]), e)
        if k == "call":
            name, args = e.a
            if name == "len":
                return self.len_(self.ex(args[0]))
            if name == "new_int":
                return self.newarr("int", self.ex(args[0]))
            if name == "new_float":
                return self.newarr("float", self.ex(args[0]))
            if name == "to_float":
                return self.to_float(self.ex(args[0]))
            if name == "to_int":
                return self.to_int(self.ex(args[0]))
            if name == "sqrt":
                return self.sqrt(self.ex(args[0]))
            return self.user_call(e)
        raise DSLError("cannot emit " + k)

    # ---------- statements ----------
    def block(self, stmts):
        for st in stmts:
            getattr(self, "st_" + st.k)(st)

    def inner(self, stmts):
        self.ind += 1
        self.block(stmts)
        self.ind -= 1

    def st_decl(self, st):
        self.pre(st.e)
        self.w(self.decl(st.t, st.v, self.ex(st.e)) + self.semi)

    def st_assign(self, st):
        self.pre(st.e)
        self.w(self.assign(st.v, self.ex(st.e)) + self.semi)

    def st_aset(self, st):
        self.pre(st.e)
        self.pre(st.i)
        self.w("%s = %s%s" % (self.idx(self.ref(st.v), self.ex(st.i)), self.ex(st.e), self.semi))

    def st_ret(self, st):
        if st.e is None:
            self.w("return" + self.semi)
        else:
            self.pre(st.e)
            self.w("return %s%s" % (self.ex(st.e), self.semi))

    def st_expr(self, st):
        self.pre(st.e)
        self.w(self.ex(st.e) + self.semi)

    def st_brk(self, st):
        self.w("break" + self.semi)

    def st_cont(self, st):
        if self.loops and self.loops[-1]:
            self.w(self.loops[-1])
        self.w(self.kw_continue + self.semi)

    kw_continue = "continue"
    kw_while = "while"

    def st_if(self, st):
        self.pre(st.c)
        self.w("if %s {" % self.cond(self.ex(st.c)))
        cur = st
        while True:
            self.inner(cur.then)
            els = cur.els
            if els is None:
                break
            if len(els) == 1 and els[0].k == "if" and getattr(els[0], "elif_", False):
                cur = els[0]
                self.pre(cur.c)
                self.w("} else if %s {" % self.cond(self.ex(cur.c)))
                continue
            self.w("} else {")
            self.inner(els)
            break
        self.w("}")

    def st_while(self, st):
        self.pre(st.c)
        self.w("%s %s {" % (self.kw_while, self.cond(self.ex(st.c))))
        self.loops.append(None)
        self.inner(st.body)
        self.loops.pop()
        self.w("}")

    def open_scope(self):
        self.w("{")
        self.ind += 1

    def close_scope(self):
        self.ind -= 1
        self.w("}")

    def st_for(self, st):
        for x in (st.lo, st.hi, st.step):
            self.pre(x)
        hi = self.tmp("hi")
        self.open_scope()
        self.w(self.decl("int", hi, self.ex(st.hi)) + self.semi)
        if st.step.k == "int":
            step = self.ex(st.step)
        else:
            sv = self.tmp("st")
            self.w(self.decl("int", sv, self.ex(st.step)) + self.semi)
            step = self.ref(sv)
        self.w(self.decl("int", st.v, self.ex(st.lo)) + self.semi)
        self.w("%s %s {" % (self.kw_while, self.cond("%s < %s" % (self.ref(st.v), self.ref(hi)))))
        incr = self.assign(st.v, "(%s + %s)" % (self.ref(st.v), step)) + self.semi
        self.loops.append(incr)
        self.inner(st.body)
        self.ind += 1
        self.w(incr)
        self.ind -= 1
        self.loops.pop()
        self.w("}")
        self.close_scope()

    def func(self, f):
        self.w(self.sig(f) + " {")
        self.ind += 1
        self.fbody(f)
        self.ind -= 1
        self.w("}")
        self.w()

    def fbody(self, f):
        self.block(f.body)

    def assign(self, v, rhs):
        return "%s = %s" % (self.ref(v), rhs)


class HoistMixin:
    """Rust and Swift: scalar arguments of calls that take arrays are evaluated first."""

    def simple(self, a):
        return a.k in ("int", "flt", "var") or a.over is not None

    def pre(self, e):
        if e is None:
            return
        if e.k == "call":
            for a in e.a[1]:
                self.pre(a)
            if e.fn is not None and e.fn.hasarr:
                for a, p in zip(e.a[1], e.fn.params):
                    if not isarr(p.t) and not self.simple(a):
                        if not e.top:
                            continue
                        t = self.tmp("a", p.t)
                        self.w(self.decl(p.t, t, self.ex(a)) + self.semi)
                        a.over = self.ref(t)
        elif e.k == "bin":
            self.pre(e.a[1])
            self.pre(e.a[2])
        elif e.k in ("not",):
            self.pre(e.a[0])
        elif e.k == "idx":
            self.pre(e.a[1])
