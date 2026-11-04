# Session 10 revision

- `design10.py` moved the visual design of the main window into
  `Program/Unit1.dfm` (charts, 48 series, events, parameter rows, memo,
  equation pictures), starting from the form as saved by the Delphi IDE.
  Usage: `python design10.py <in.dfm> <out.dfm> <hh_equations.png> <hh_nomenclature.png>`.
- `build10.py` revised the student's edited report: numbered code lines,
  8 pt code, shortened form routines, Section 2.2.1 on the design-time form.
  Run next to an unzipped copy of the report (`user.docx`, folder `u/`),
  with pandoc 3.x and lxml; the source paths at the top of the script point
  to the program folder.
- `docs10.py` added the session-10 entries of CHANGELOG.md and ISSUES.md.
