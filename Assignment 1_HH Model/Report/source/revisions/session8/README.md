# Session 8 revision of the report

The student edited the generated report by hand, so it is no longer rebuilt
from `../../report_part*.md`. `build_frag.py` applies the session-8 changes
(`fragments_text.md` plus updated code listings) to the edited file:
replaced paragraphs keep the student's paragraph style, every other
paragraph is copied unchanged. Run it next to an unzipped copy of the
report (`user.docx`, folder `u/`), with pandoc 3.x and lxml installed.
