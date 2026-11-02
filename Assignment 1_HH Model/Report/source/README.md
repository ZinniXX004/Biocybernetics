# Report sources (Assignment 1)

The Word report in the parent folder is generated from these files.

| File | Purpose |
|---|---|
| `report_part1.md` ... `report_part5.md` | Chapter I to References (pandoc Markdown with LaTeX math) |
| `codeblocks.py` | inserts complete Delphi routines from `../../Program/*.pas` (`@@CODE unit name@@`) |
| `build_report.py` | pandoc conversion, merge with the cover and Section 2.1 of the template, styles |
| `schemafix.py` | reorders OOXML elements emitted out of schema order |
| `figs.py` | crops/plots the figures in `fig/` (screenshot paths must be adapted) |
| `fig/` | figures, numbered by chapter (`fig1_1.png` = Figure 1.1) |

Rebuild: copy `../drafts/Template_original_before_A1_report.docx` to
`original.docx` in this folder, unzip it into `unpacked/`, then run
`python build_report.py` (needs pandoc 3.x and lxml). Equations highlighted in
yellow use the paragraph style "Highlighted Equation".
