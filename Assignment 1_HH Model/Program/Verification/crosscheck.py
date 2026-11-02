"""Cross-check of the Free Pascal harness against the independent Python
references (run in CI after the golden-file comparison).

The golden file only proves that HHModel.pas did not change its output; this
script proves that the output agrees with a second implementation written
from the equations. Each check prints PASS or FAIL; the exit code is the
number of failures.

Usage: python crosscheck.py [TestHH_output.txt]
"""

import re
import sys

import numpy as np

import cable_drive_reference as cdr
import hh_reference_apg as apg
import hh_reference_app as app

GOLDEN = sys.argv[1] if len(sys.argv) > 1 else "TestHH_output.txt"
FAILURES = []


def check(name, ok, detail):
    print(f"{'PASS' if ok else 'FAIL'}  {name}: {detail}")
    if not ok:
        FAILURES.append(name)


def golden_lines():
    with open(GOLDEN, encoding="utf-8") as handle:
        return [line.strip() for line in handle]


def number(pattern, text):
    match = re.search(pattern, text)
    if match is None:
        raise ValueError(f"pattern {pattern!r} not found in {text!r}")
    return float(match.group(1))


lines = golden_lines()
method0 = lines[lines.index("--- method 0") + 1 : lines.index("--- method 1")]

# APG: spike count, last inter-spike interval and first peak (coupled RK4)
for line in method0:
    if not line.startswith("J="):
        continue
    jin = int(number(r"J=(-?\d+)", line))
    count = int(number(r"spikes=(\d+)", line))
    out = apg.run(apg.step(jin), 100)
    times = apg.spikes(out)
    check(
        f"APG J={jin} spike count",
        len(times) == count,
        f"FPC {count}, Python {len(times)}",
    )
    if "lastISI=" in line:
        isi_fpc = number(r"lastISI=([\d.]+)", line)
        isi_py = float(np.diff(times)[-1])
        check(
            f"APG J={jin} last ISI",
            abs(isi_fpc - isi_py) <= 0.02,
            f"FPC {isi_fpc:.3f} ms, Python {isi_py:.3f} ms (tol 0.02)",
        )
    if "peak1=" in line:
        peak_fpc = number(r"peak1=(-?[\d.]+)", line)
        peak_py = float(out[:, 1].max()) if jin != -100 else None
        if peak_py is not None and count > 0:
            check(
                f"APG J={jin} peak",
                abs(peak_fpc - peak_py) <= 0.05,
                f"FPC {peak_fpc:.2f} mV, Python {peak_py:.2f} mV (tol 0.05)",
            )

stair_fpc = [
    float(t)
    for t in lines[[l.startswith("staircase") for l in lines].index(True)]
    .split(":")[1]
    .split()
]
stair_py = [float(t) for t in apg.spikes(apg.run(apg.staircase, 61))]
check(
    "APG lecturer staircase spike times",
    len(stair_fpc) == len(stair_py)
    and max(abs(a - b) for a, b in zip(stair_fpc, stair_py)) <= 0.02,
    f"FPC {stair_fpc}, Python {[round(t, 2) for t in stair_py]}",
)

# APP: conduction velocity of the active squid cable (explicit FTCS). The
# Python reference takes the crossing time on the time grid, the harness
# interpolates, so 1 % is allowed.
active = [l for l in lines if l.startswith("cable active:")][0]
vel_fpc = number(r"vel=([\d.]+)", active)
vel_py = float(app.cable(dx=0.1, dt=0.01)["vel"])
check(
    "APP squid velocity (FTCS, h = 1 mm)",
    abs(vel_py - vel_fpc) / vel_fpc <= 0.01,
    f"FPC {vel_fpc:.3f} m/s, Python {vel_py:.3f} m/s (tol 1 %)",
)

# APP: lecturer passive cable driven by the APG waveform, both schemes
drive = cdr.apg_trace(-10.0, 1.0, 61.0, 60.0, 0.01)
for scheme_id, scheme in ((0, "ftcs"), (1, "cn")):
    line = [
        l
        for l in lines
        if l.startswith(f"lecturer passive APG drive scheme {scheme_id}")
    ][0]
    peaks_fpc = [float(p) for p in line.split("peaks")[1].split()]
    _, peaks_py = cdr.cable(5.0, 0.2, 0.04, 0.01, drive, False, scheme)
    diff = max(abs(a - b) for a, b in zip(peaks_fpc, peaks_py))
    check(
        f"APP lecturer passive APG drive ({scheme})",
        diff <= 0.15,
        f"FPC {peaks_fpc}, Python {[float(p) for p in peaks_py]} (max diff {diff:.2f} mV, tol 0.15)",
    )

print(f"\n{len(FAILURES)} failure(s)")
sys.exit(len(FAILURES))
