# Session 9 revision of the report

`build9.py` replaces only the listings of `TForm1.PlotCable` and
`TForm1.ReportCable` in the student's edited report, after the fix of
ISS-032 (repeated nodes in the tab 5 memo on the 6-node lecturer grid).
Every other paragraph, image and setting is copied unchanged. Run it next
to an unzipped copy of the report (`user.docx`, folder `u/`), with pandoc
3.x and lxml installed; it writes `report_rev9.docx`.
