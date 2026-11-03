"""Front end for the Hotloop neutral language (.hl): lexer, parser, type checker."""
import re


class DSLError(Exception):
    pass


RESERVED = set("""
abstract and as assert async await begin bool boolean break byte case catch char class const continue
def default defer del delegate do double elif else elsif end enum except export extends extern fallthrough
false final finally float fn for foreach from func function global go goto if impl implements import in
inline int interface internal is lambda len let long loop map match mod module move mut namespace native
new next nil none not null object of operator or out override package params pass print private protected
pub public raise range readonly redo ref register rem repeat require rescue restrict retry return sealed
select self short signed sizeof static string struct super switch sync then this throw throws trait true
try type typedef typeof union unless unsigned until use using val var virtual void volatile when where
while with yield main init time exp log pow sqrt abs min max div index rand free exit round signal y0 y1
j0 j1 jn yn gamma cap copy append make fmt os math sys it set get lock array list dict unset isset empty
echo die eval include fun in is as
base checked unchecked decimal explicit implicit fixed sbyte uint ulong ushort stackalloc unsafe event
operator implicit dynamic sealed partial record required
guard extension protocol inout subscript deinit associatedtype fileprivate rethrows some any Any Self
rethrow covariant factory late library part mixin external show hide on
typealias inner data companion tailrec vararg lateinit reified crossinline noinline infix
""".split())

TOKEN_RE = re.compile(
    r"\s*(?:(?P<cm>//[^\n]*)|(?P<flt>\d+\.\d+)|(?P<int>\d+)|(?P<id>[A-Za-z_][A-Za-z0-9_]*)"
    r"|(?P<op>\.\.|<<|>>|<=|>=|==|!=|&&|\|\||\+=|-=|\*=|[-+*/%<>=!&|^(){}\[\];,]))")


class Tok:
    def __init__(self, kind, text, line):
        self.kind, self.text, self.line = kind, text, line


def lex(src):
    pos, line, toks = 0, 1, []
    while True:
        m = TOKEN_RE.match(src, pos)
        if not m:
            if src[pos:].strip():
                raise DSLError("line %d: bad character %r" % (line, src[pos:].strip()[:10]))
            break
        line += src.count("\n", pos, m.start(m.lastgroup))
        kind = m.lastgroup
        if kind != "cm":
            toks.append(Tok(kind, m.group(kind), line))
        pos = m.end()
    toks.append(Tok("eof", "", line))
    return toks


class E:
    def __init__(self, k, *a, line=0):
        self.k, self.a, self.line = k, list(a), line
        self.t = None
        self.over = None
        self.top = False
        self.fn = None


class S:
    def __init__(self, k, line=0, **kw):
        self.k, self.line = k, line
        self.__dict__.update(kw)


class V:
    def __init__(self, name, t, kind):
        self.name, self.t, self.kind = name, t, kind
        self.used = False
        self.ro = False
        if kind == "global":
            self.m = "g_" + name
        else:
            self.m = name + "_" if name in RESERVED else name


class F:
    def __init__(self, name, params, ret, body, line):
        self.name, self.params, self.ret, self.body, self.line = name, params, ret, body, line
        self.m = "hl_" + name
        self.locals = []
        self.gused = []
        self.gset = []
        self.hasarr = any(p.t.endswith("[]") for p in params)
        self.calls = set()
        self.pcalls = set()
        self.gstate = False
        self.pstate = False
        self.state = False


class Prog:
    def __init__(self):
        self.consts = {}
        self.globals = []
        self.funcs = {}


def isarr(t):
    return t.endswith("[]")


BUILTINS = {"len", "new_int", "new_float", "to_float", "to_int", "sqrt"}
BINPREC = [["||"], ["&&"], ["|"], ["^"], ["&"], ["==", "!="], ["<", "<=", ">", ">="], ["<<", ">>"], ["+", "-"], ["*", "/", "%"]]


class Parser:
    def __init__(self, toks):
        self.t, self.i = toks, 0
        self.prog = Prog()

    def pk(self, o=0):
        return self.t[min(self.i + o, len(self.t) - 1)]

    def nx(self):
        t = self.pk()
        self.i += 1
        return t

    def ex(self, text):
        t = self.nx()
        if t.text != text:
            raise DSLError("line %d: expected %r but found %r" % (t.line, text, t.text))
        return t

    def ident(self):
        t = self.nx()
        if t.kind != "id":
            raise DSLError("line %d: expected a name but found %r" % (t.line, t.text))
        return t.text

    def ptype(self):
        t = self.nx()
        if t.text not in ("int", "float", "void"):
            raise DSLError("line %d: expected a type but found %r" % (t.line, t.text))
        ty = t.text
        if self.pk().text == "[":
            self.nx()
            self.ex("]")
            ty += "[]"
        return ty

    def program(self):
        p = self.prog
        while self.pk().kind != "eof":
            t = self.pk()
            if t.text == "const":
                self.nx()
                ty = self.ptype()
                name = self.ident()
                self.ex("=")
                lit = self.punary()
                if lit.k not in ("int", "flt"):
                    raise DSLError("line %d: const needs a literal" % t.line)
                self.ex(";")
                p.consts[name] = lit
            elif t.text == "global":
                self.nx()
                ty = self.ptype()
                name = self.ident()
                self.ex("=")
                lit = self.punary()
                self.ex(";")
                v = V(name, ty, "global")
                v.init = lit
                p.globals.append(v)
            elif t.text == "fn":
                self.nx()
                ret = self.ptype()
                name = self.ident()
                self.ex("(")
                params = []
                while self.pk().text != ")":
                    pt = self.ptype()
                    pn = self.ident()
                    params.append(V(pn, pt, "param"))
                    if self.pk().text == ",":
                        self.nx()
                self.ex(")")
                body = self.block()
                if name in p.funcs:
                    raise DSLError("line %d: function %s defined twice" % (t.line, name))
                p.funcs[name] = F(name, params, ret, body, t.line)
            else:
                raise DSLError("line %d: unexpected %r" % (t.line, t.text))
        return p

    def block(self):
        self.ex("{")
        out = []
        while self.pk().text != "}":
            out.append(self.stmt())
        self.ex("}")
        return out

    def stmt(self):
        t = self.pk()
        tx = t.text
        if tx in ("int", "float"):
            ty = self.ptype()
            name = self.ident()
            self.ex("=")
            e = self.expr()
            self.ex(";")
            return S("decl", t.line, t=ty, name=name, e=e)
        if tx == "if":
            return self.if_stmt()
        if tx == "while":
            self.nx()
            self.ex("(")
            c = self.expr()
            self.ex(")")
            return S("while", t.line, c=c, body=self.block())
        if tx == "for":
            self.nx()
            name = self.ident()
            self.ex("in")
            lo = self.expr()
            self.ex("..")
            hi = self.expr()
            step = E("int", 1, line=t.line)
            if self.pk().text == "step":
                self.nx()
                step = self.expr()
            return S("for", t.line, name=name, lo=lo, hi=hi, step=step, body=self.block())
        if tx == "return":
            self.nx()
            e = None
            if self.pk().text != ";":
                e = self.expr()
            self.ex(";")
            return S("ret", t.line, e=e)
        if tx in ("break", "continue"):
            self.nx()
            self.ex(";")
            return S("brk" if tx == "break" else "cont", t.line)
        if t.kind == "id":
            name = self.nx().text
            nxt = self.pk().text
            if nxt == "(":
                self.i -= 1
                e = self.expr()
                self.ex(";")
                return S("expr", t.line, e=e)
            if nxt == "[":
                self.nx()
                idx = self.expr()
                self.ex("]")
                op = self.nx().text
                rhs = self.expr()
                self.ex(";")
                if op in ("+=", "-=", "*="):
                    cur = E("idx", E("var", name, line=t.line), idx, line=t.line)
                    rhs = E("bin", op[0], cur, rhs, line=t.line)
                elif op != "=":
                    raise DSLError("line %d: bad assignment" % t.line)
                return S("aset", t.line, name=name, i=idx, e=rhs)
            op = self.nx().text
            rhs = self.expr()
            self.ex(";")
            if op in ("+=", "-=", "*="):
                rhs = E("bin", op[0], E("var", name, line=t.line), rhs, line=t.line)
            elif op != "=":
                raise DSLError("line %d: bad assignment" % t.line)
            return S("assign", t.line, name=name, e=rhs)
        raise DSLError("line %d: unexpected %r" % (t.line, tx))

    def if_stmt(self):
        t = self.nx()
        self.ex("(")
        c = self.expr()
        self.ex(")")
        then = self.block()
        els = None
        if self.pk().text == "else":
            self.nx()
            if self.pk().text == "if":
                inner = self.if_stmt()
                inner.elif_ = True
                els = [inner]
            else:
                els = self.block()
        return S("if", t.line, c=c, then=then, els=els)

    def expr(self):
        return self.pbin(0)

    def pbin(self, lvl):
        if lvl == len(BINPREC):
            return self.punary()
        left = self.pbin(lvl + 1)
        while self.pk().kind == "op" and self.pk().text in BINPREC[lvl]:
            tk = self.nx()
            right = self.pbin(lvl + 1)
            left = E("bin", tk.text, left, right, line=tk.line)
        return left

    def punary(self):
        t = self.pk()
        if t.text == "!":
            self.nx()
            return E("not", self.punary(), line=t.line)
        if t.text == "-":
            self.nx()
            n = self.nx()
            if n.kind == "int":
                return E("int", -int(n.text), line=t.line)
            if n.kind == "flt":
                return E("flt", -float(n.text), line=t.line)
            if n.kind == "id" and n.text in self.prog.consts:
                c = self.prog.consts[n.text]
                return E(c.k, -c.a[0], line=t.line)
            raise DSLError("line %d: unary minus works only on literals; write 0 - x" % t.line)
        return self.ppost()

    def ppost(self):
        e = self.pprim()
        while self.pk().text == "[":
            if e.k != "var":
                raise DSLError("line %d: only array variables can be indexed" % e.line)
            self.nx()
            i = self.expr()
            self.ex("]")
            e = E("idx", e, i, line=e.line)
        return e

    def pprim(self):
        t = self.nx()
        if t.kind == "int":
            return E("int", int(t.text), line=t.line)
        if t.kind == "flt":
            return E("flt", float(t.text), line=t.line)
        if t.text == "(":
            e = self.expr()
            self.ex(")")
            return e
        if t.kind == "id":
            if self.pk().text == "(":
                self.nx()
                args = []
                while self.pk().text != ")":
                    args.append(self.expr())
                    if self.pk().text == ",":
                        self.nx()
                self.ex(")")
                return E("call", t.text, args, line=t.line)
            if t.text in self.prog.consts:
                c = self.prog.consts[t.text]
                return E(c.k, c.a[0], line=t.line)
            return E("var", t.text, line=t.line)
        raise DSLError("line %d: unexpected %r in expression" % (t.line, t.text))


class Checker:
    def __init__(self, prog):
        self.p = prog
        self.gl = {v.name: v for v in prog.globals}

    def run(self):
        for f in self.p.funcs.values():
            self.fn(f)
        changed = True
        while changed:
            changed = False
            for f in self.p.funcs.values():
                if not f.gstate and any(self.p.funcs[c].gstate for c in f.calls):
                    f.gstate = True
                    changed = True
                if not f.pstate and any(self.p.funcs[c].pstate for c in f.pcalls):
                    f.pstate = True
                    changed = True
        for f in self.p.funcs.values():
            f.state = f.gstate or f.pstate
        for f in self.p.funcs.values():
            self.order(f.body, f)

    def count_state(self, e):
        if e is None:
            return 0
        n = 0
        if e.k == "call":
            if e.fn is not None and e.fn.state:
                n += 1
            for a in e.a[1]:
                n += self.count_state(a)
        elif e.k == "bin":
            n += self.count_state(e.a[1]) + self.count_state(e.a[2])
        elif e.k == "not":
            n += self.count_state(e.a[0])
        elif e.k == "idx":
            n += self.count_state(e.a[1])
        return n

    def order(self, stmts, f):
        for st in stmts:
            exprs = []
            if st.k in ("decl", "assign", "ret", "expr"):
                exprs = [st.e]
            elif st.k == "aset":
                exprs = [st.i, st.e]
            elif st.k in ("if", "while"):
                exprs = [st.c]
            elif st.k == "for":
                exprs = [st.lo, st.hi, st.step]
            if sum(self.count_state(x) for x in exprs) > 1:
                self.err(st.line, "more than one state-changing call in one statement (evaluation order differs between languages)")
            for blk in (getattr(st, "then", None), getattr(st, "els", None), getattr(st, "body", None)):
                if blk:
                    self.order(blk, f)

    def err(self, line, msg):
        raise DSLError("line %d: %s" % (line, msg))

    def fn(self, f):
        self.f = f
        self.scopes = [{}]
        self.desc = [set()]  # names declared in already-closed nested scopes (C# forbids reusing them later)
        self.loops = 0
        for p in f.params:
            self.declare(p, f.line)
        self.block(f.body)
        if f.ret != "void" and (not f.body or f.body[-1].k != "ret"):
            self.err(f.line, "function %s must end with return" % f.name)
        for v in f.locals:
            if not v.used:
                self.err(f.line, "variable %s in %s is never read" % (v.name, f.name))

    def declare(self, v, line):
        if v.name.startswith("zz"):
            self.err(line, "names starting with zz are reserved")
        if not v.name[0].islower():
            self.err(line, "names must start with a lowercase letter: " + v.name)
        for sc in self.scopes:
            if v.name in sc:
                self.err(line, "%s shadows another variable" % v.name)
        if v.name in self.desc[-1]:
            # An earlier nested block already used this name. C# (CS0136) rejects that, so give
            # this outer variable a distinct emitted name; behaviour is identical in every language.
            v.m = v.m + "_o%d" % line
        self.scopes[-1][v.name] = v
        if v.kind == "local":
            self.f.locals.append(v)

    def lookup(self, name, line):
        for sc in reversed(self.scopes):
            if name in sc:
                return sc[name]
        if name in self.gl:
            return self.gl[name]
        self.err(line, "unknown variable " + name)

    def note_g(self, v, setting):
        self.f.gstate = True
        lst = self.f.gset if setting else self.f.gused
        if v not in lst:
            lst.append(v)

    def term(self, st):
        if st.k in ("ret", "brk", "cont"):
            return True
        if st.k == "if" and st.els is not None:
            return self.bterm(st.then) and self.bterm(st.els)
        return False

    def bterm(self, b):
        return bool(b) and self.term(b[-1])

    def push(self):
        self.scopes.append({})
        self.desc.append(set())

    def pop(self):
        names = set(self.scopes.pop()) | self.desc.pop()
        self.desc[-1] |= names

    def block(self, stmts):
        self.push()
        prev = None
        for st in stmts:
            if prev is not None and self.term(prev):
                self.err(st.line, "unreachable statement")
            self.stmt(st)
            prev = st
        self.pop()

    def stmt(self, st):
        k = st.k
        if k == "decl":
            self.ce(st.e, True)
            if st.e.t != st.t:
                self.err(st.line, "%s declared as %s but initialised with %s" % (st.name, st.t, st.e.t))
            if isarr(st.t) and st.e.k != "call":
                self.err(st.line, "array variables must be initialised by a call")
            st.v = V(st.name, st.t, "local")
            self.declare(st.v, st.line)
        elif k == "assign":
            v = self.lookup(st.name, st.line)
            if v.ro or v.kind == "param" or isarr(v.t):
                self.err(st.line, "cannot assign to %s" % st.name)
            self.ce(st.e, True)
            if st.e.t != v.t:
                self.err(st.line, "assigning %s to %s %s" % (st.e.t, v.t, st.name))
            st.v = v
            if v.kind == "global":
                self.note_g(v, True)
        elif k == "aset":
            v = self.lookup(st.name, st.line)
            if not isarr(v.t):
                self.err(st.line, st.name + " is not an array")
            v.used = True
            if v.kind == "param":
                self.f.pstate = True
            self.ce(st.i)
            if st.i.t != "int":
                self.err(st.line, "array index must be int")
            self.ce(st.e)
            if st.e.t != v.t[:-2]:
                self.err(st.line, "storing %s into %s" % (st.e.t, v.t))
            st.v = v
        elif k == "if":
            self.ce(st.c)
            if st.c.t != "bool":
                self.err(st.line, "if needs a comparison")
            self.block(st.then)
            if st.els is not None:
                self.block(st.els)
        elif k == "while":
            self.ce(st.c)
            if st.c.t != "bool":
                self.err(st.line, "while needs a comparison")
            self.loops += 1
            self.block(st.body)
            self.loops -= 1
        elif k == "for":
            for x in (st.lo, st.hi, st.step):
                self.ce(x)
                if x.t != "int":
                    self.err(st.line, "for bounds must be int")
            st.v = V(st.name, "int", "local")
            st.v.ro = True
            st.v.used = True
            self.push()
            self.declare(st.v, st.line)
            self.loops += 1
            self.block(st.body)
            self.loops -= 1
            self.pop()
        elif k == "ret":
            if st.e is None:
                if self.f.ret != "void":
                    self.err(st.line, "missing return value")
            else:
                self.ce(st.e, True)
                if st.e.t != self.f.ret:
                    self.err(st.line, "returning %s from %s function" % (st.e.t, self.f.ret))
        elif k in ("brk", "cont"):
            if self.loops == 0:
                self.err(st.line, "break/continue outside a loop")
        elif k == "expr":
            if st.e.k != "call":
                self.err(st.line, "only calls can be statements")
            self.ce(st.e, True)

    def ce(self, e, top=False):
        k = e.k
        if k == "int":
            e.t = "int"
        elif k == "flt":
            e.t = "float"
        elif k == "var":
            if not isinstance(e.a[0], V):
                e.a[0] = self.lookup(e.a[0], e.line)
            v = e.a[0]
            v.used = True
            e.t = v.t
            if v.kind == "global":
                self.note_g(v, False)
        elif k == "idx":
            self.ce(e.a[0])
            if not isarr(e.a[0].t):
                self.err(e.line, "indexing a non-array")
            self.ce(e.a[1])
            if e.a[1].t != "int":
                self.err(e.line, "array index must be int")
            e.t = e.a[0].t[:-2]
        elif k == "not":
            self.ce(e.a[0])
            if e.a[0].t != "bool":
                self.err(e.line, "! needs a comparison")
            e.t = "bool"
        elif k == "bin":
            op, l, r = e.a
            self.ce(l)
            self.ce(r)
            lt, rt = l.t, r.t
            if op in ("+", "-", "*", "/"):
                if lt != rt or lt not in ("int", "float"):
                    self.err(e.line, "operator %s on %s and %s" % (op, lt, rt))
                e.t = lt
            elif op in ("%", "&", "|", "^", "<<", ">>"):
                if lt != "int" or rt != "int":
                    self.err(e.line, "operator %s needs ints" % op)
                e.t = "int"
            elif op in ("==", "!=", "<", "<=", ">", ">="):
                if lt != rt or lt not in ("int", "float"):
                    self.err(e.line, "comparing %s with %s" % (lt, rt))
                e.t = "bool"
            else:
                if lt != "bool" or rt != "bool":
                    self.err(e.line, "operator %s needs comparisons" % op)
                e.t = "bool"
        elif k == "call":
            self.call(e, top)
        else:
            self.err(e.line, "bad expression")

    def call(self, e, top):
        name, args = e.a
        for a in args:
            self.ce(a)
        want = None
        if name == "len":
            want, e.t = ["arr"], "int"
        elif name == "new_int":
            want, e.t = ["int"], "int[]"
        elif name == "new_float":
            want, e.t = ["int"], "float[]"
        elif name == "to_float":
            want, e.t = ["int"], "float"
        elif name == "to_int":
            want, e.t = ["float"], "int"
        elif name == "sqrt":
            want, e.t = ["float"], "float"
        if want is not None:
            if len(args) != 1:
                self.err(e.line, "%s takes one argument" % name)
            if want[0] == "arr":
                if not isarr(args[0].t) or args[0].k != "var":
                    self.err(e.line, "len needs an array variable")
            elif args[0].t != want[0]:
                self.err(e.line, "%s needs %s" % (name, want[0]))
            return
        f = self.p.funcs.get(name)
        if f is None:
            self.err(e.line, "unknown function " + name)
        if len(args) != len(f.params):
            self.err(e.line, "%s takes %d arguments" % (name, len(f.params)))
        for a, p in zip(args, f.params):
            if a.t != p.t:
                self.err(e.line, "argument for %s of %s: expected %s got %s" % (p.name, name, p.t, a.t))
            if isarr(p.t) and a.k != "var":
                self.err(e.line, "array arguments must be plain variables")
        names = [a.a[0].name for a, p in zip(args, f.params) if isarr(p.t)]
        if len(names) != len(set(names)):
            self.err(e.line, "the same array is passed twice to %s" % name)
        e.t = f.ret
        e.fn = f
        e.top = top
        self.f.calls.add(name)
        for a, p in zip(args, f.params):
            if isarr(p.t) and a.a[0].kind == "param":
                self.f.pcalls.add(name)


def parse_source(src):
    prog = Parser(lex(src)).program()
    Checker(prog).run()
    return prog
