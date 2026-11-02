"""Extract complete (un-truncated) Delphi routines from the sources.

A top-level routine starts at a line beginning with 'procedure', 'function'
or 'constructor' inside the implementation section and ends at the first
following line that is exactly 'end;' at column 0 (nested routines and
blocks are indented, so they never end the match).
"""

import os
import re

SRC = {
    "HHModel": os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "Program", "HHModel.pas"),
    "Unit1": os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "Program", "Unit1.pas"),
    "EquationViewer": os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "Program", "EquationViewer.pas"),
}
_cache = {}


def lines_of(unit):
    if unit not in _cache:
        text = open(SRC[unit], encoding="utf-8").read().replace("\r\n", "\n")
        _cache[unit] = text.split("\n")
    return _cache[unit]


def routine(unit, name):
    """Return the full text of routine `name` (e.g. 'TForm1.btnRunAPPClick')."""
    lines = lines_of(unit)
    impl = next(i for i, l in enumerate(lines) if l.strip() == "implementation")
    pat = re.compile(
        r"^(procedure|function|constructor|destructor)\s+" + re.escape(name) + r"\b"
    )
    for i in range(impl, len(lines)):
        if pat.match(lines[i]):
            # include an immediately preceding comment block, if any
            start = i
            for j in range(i, impl, -1):
                if lines[j - 1].strip() == "":
                    break
            for j in range(i + 1, len(lines)):
                if lines[j] == "end;":
                    return "\n".join(lines[start : j + 1])
    raise KeyError(f"{unit}.{name} not found")


def block(unit, start_pat, end_pat):
    """Lines from the first match of start_pat up to (excluding) end_pat."""
    lines = lines_of(unit)
    s = next(i for i, l in enumerate(lines) if re.match(start_pat, l))
    e = next(i for i in range(s + 1, len(lines)) if re.match(end_pat, lines[i]))
    return "\n".join(lines[s:e]).rstrip()


def md(unit, name):
    code = routine(unit, name)
    return f"```pascal\n{code}\n```"


if __name__ == "__main__":
    for u, n in (
        ("HHModel", "ComputeRates"),
        ("HHModel", "SimulateCable"),
        ("Unit1", "TForm1.btnRunAPPClick"),
        ("EquationViewer", "ShowEquationSheet"),
    ):
        t = routine(u, n)
        print(u, n, len(t.splitlines()), "lines; last:", t.splitlines()[-1])
