"""Session 10 entries for CHANGELOG.md and ISSUES.md (run in the repository root)."""

CL_ENTRY = """### 2026-11-05 - Assignment 1 (session 10): design-time form, compact report listings, demo handout

#### Changed

- UI v4.3: the whole visual design of the main window moved into
  `Unit1.dfm`, so the lecturer can inspect it in the Form Designer before
  compiling (ISS-035): 14 charts in 2D with titles, axis titles, grid,
  legends with check boxes and 48 design-time series (`TFastLineSeries`,
  `TLineSeries`, `TPointSeries`) in the Okabe-Ito / viridis colours; chart
  events (`OnZoom`, `OnMouseMove`, ...) bound in the form; default rows of
  the five parameter tables; the model summary memo; the rendered
  equations of tab 6 (`imgEquations`, `imgNomenclature`, PNG stored in the
  form). The student's own layout changes in the form were kept.
- `Unit1.pas`: `SetupChart`, `StyleAxis`, `SetRightAxisColor`, `AddLine`,
  `AddMarkedLine`, `AddPoints`, `InitRefEditor`, `InitISIEditor` and
  `LoadEquationImages` removed; `RegisterChart` only joins a chart to the
  zoom/export logic; plotting fills the design-time series, `ClearChart`
  clears points instead of freeing series (no series is created or freed
  at run time any more, see ISS-020). Numerical results are unchanged
  (`HHModel.pas` untouched, CI golden output unchanged).
- `Equations.rc`: `EQUATIONS_PNG` and `NOMENCLATURE_PNG` removed (now in
  the form).
- Report: every code line carries its line number in the source file;
  code at 8 pt (token styles were 10.5 pt); routines of the form shortened
  with `{ lines a-b omitted: ... }` comments, numerical routines complete;
  Section 2.2.1 describes the design-time form with a `Unit1.dfm` excerpt
  (`Report/source/revisions/session10/`). 65 to 51 pages in LibreOffice.
- READMEs: live CI badge of `ZinniXX004/Biocybernetics`, UI v4.3.

#### Added

- Demo handout (Claude Docs, bilingual) and the Final Project prompt
  template (claude.ai project docs, not versioned here).

"""

ISS_ROW = (
    "| ISS-035 | A1 / UI              | Charts, series and parameter rows were created at run time, "
    "invisible in the Form Designer | Resolved           |"
)
ISS_TEXT = """
### ISS-035 - Visual design created at run time
- The lecturer checks the form in the Delphi Form Designer before the
  program is run. Up to UI v4.2 the charts were bare `TChart` objects in
  `Unit1.dfm`: titles, axes, legends, colours and every series were set or
  created in `FormCreate` and the plot routines, the parameter tables were
  filled in code, and the equations of tab 6 were loaded from resources.
- **Resolution (UI v4.3):** `design10.py` rewrote the IDE-saved form: all
  chart properties and 48 series as design-time objects, events bound in
  the form, parameter rows, memo text and equation pictures stored in the
  form. Only TeeChart properties that appear in DFM files saved by recent
  Delphi versions (senior projects) or that the old code already set were
  used. If the IDE reports an unknown property when opening the form,
  choose Ignore, save, and report the property name.
- Remaining run-time parts: data of the series, titles that depend on a
  run (tab 5), colours of a changed number of recording sites, and the
  heat map / 3D views drawn on `pbSpaceTime`.
"""

text = open("CHANGELOG.md", encoding="utf-8").read()
marker = "## [Unreleased]\n\n"
assert marker in text and "session 10" not in text
open("CHANGELOG.md", "w", encoding="utf-8", newline="\n").write(
    text.replace(marker, marker + CL_ENTRY, 1)
)

iss = open("ISSUES.md", encoding="utf-8").read()
assert "ISS-035" not in iss
last = [ln for ln in iss.split("\n") if ln.startswith("| ISS-034 |")][0]
iss = iss.replace(last, last + "\n" + ISS_ROW, 1).rstrip("\n") + "\n" + ISS_TEXT
open("ISSUES.md", "w", encoding="utf-8", newline="\n").write(iss)
print("docs ok")
