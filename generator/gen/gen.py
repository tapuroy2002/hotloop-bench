#!/usr/bin/env python3
"""Hotloop generator: reads hl/*.hl and writes one program per language."""
import json, os, sys, glob

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from front import parse_source, DSLError
from langs_a import C, Cpp, Java, CSharp, Go, Rust
from langs_b import Kotlin, Swift, Dart, JS, PHP, Python, Ruby

LANGS = [
    ("c", "main.c", C), ("cpp", "main.cpp", Cpp), ("rust", "main.rs", Rust), ("go", "main.go", Go),
    ("java", "Main.java", Java), ("csharp", "Program.cs", CSharp), ("kotlin", "main.kt", Kotlin),
    ("swift", "main.swift", Swift), ("dart", "main.dart", Dart), ("python", "main.py", Python),
    ("javascript", "main.js", JS), ("ruby", "main.rb", Ruby), ("php", "main.php", PHP),
]


def load_source(hl_dir):
    parts = []
    for path in sorted(glob.glob(os.path.join(hl_dir, "*.hl"))):
        parts.append(open(path, encoding="utf-8").read())
    return "\n".join(parts)


def main():
    root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    hl_dir = os.path.join(root, "hl")
    out_dir = sys.argv[1] if len(sys.argv) > 1 else os.path.join(root, "out")
    cfg_path = os.path.join(root, "cfg.json")
    cfg = {"groups": {}}
    if os.path.exists(cfg_path):
        raw = json.load(open(cfg_path))
        cfg["groups"] = {k: tuple(v) for k, v in raw["groups"].items()}
    src = load_source(hl_dir)
    for d, fname, cls in LANGS:
        try:
            prog = parse_source(src)
            text = cls(prog, cfg).text()
        except DSLError as e:
            print("%s: %s" % (d, e))
            sys.exit(1)
        os.makedirs(os.path.join(out_dir, d), exist_ok=True)
        with open(os.path.join(out_dir, d, fname), "w", encoding="utf-8") as fh:
            fh.write(text)
        n = sum(1 for l in text.split("\n") if l.strip())
        print("%-11s %-12s %5d lines" % (d, fname, n))


if __name__ == "__main__":
    main()
