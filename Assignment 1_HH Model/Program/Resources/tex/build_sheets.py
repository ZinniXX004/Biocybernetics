"""Render the mathematical sheets shown by EquationViewer.pas.

Run inside Program/Resources/tex (needs pdflatex with circuitikz and
pdftoppm from poppler). Every sheet*.tex is compiled and written as
../sheetN_name.png at 130 dpi; rebuild the Delphi project afterwards so that
Equations.rc links the new PNG files. Auxiliary files (.aux, .log, .pdf)
stay in this folder and are ignored by Git.
"""

import glob
import subprocess
import sys

DPI = "130"
failed = []
for tex in sorted(glob.glob("sheet*.tex")):
    stem = tex[:-4]
    run = subprocess.run(
        ["pdflatex", "-interaction=nonstopmode", tex], capture_output=True, text=True
    )
    errors = [ln for ln in run.stdout.splitlines() if ln.startswith("!")]
    if run.returncode != 0 or errors:
        failed.append(stem)
        print(stem, "FAILED:", errors[:3])
        continue
    subprocess.run(
        ["pdftoppm", "-r", DPI, "-png", "-singlefile", stem + ".pdf", "../" + stem],
        check=True,
    )
    print(stem, "ok")
sys.exit(1 if failed else 0)
