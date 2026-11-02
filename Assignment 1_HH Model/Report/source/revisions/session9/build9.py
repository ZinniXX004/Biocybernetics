"""Session 9: refresh two code listings in the student's edited report.

Only the listings of TForm1.PlotCable and TForm1.ReportCable are replaced
(the memo table and the recording sites no longer repeat a node on a coarse
grid). Every other paragraph, image and setting is copied unchanged.
"""

import copy
import os
import shutil
import subprocess
import sys
import zipfile

from lxml import etree

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
import codeblocks  # noqa: E402
import schemafix  # noqa: E402

W = "http://schemas.openxmlformats.org/wordprocessingml/2006/main"
ROUTINES = ("TForm1.PlotCable", "TForm1.ReportCable")


def q(tag):
    return "{%s}%s" % (W, tag)


def text_of(el):
    return "".join(el.itertext())


md = ""
for routine in ROUTINES:
    md += f"@@FRAG {routine}@@\n\n" + codeblocks.md("Unit1", routine) + "\n\n"
for bad in ("–", "—"):
    assert bad not in md, "en/em dash in listing"
open("frag9.md", "w", encoding="utf-8").write(md + "@@FRAG END@@\n")
subprocess.run(
    [
        "pandoc",
        "frag9.md",
        "-o",
        "frag9.docx",
        "--reference-doc=user.docx",
        "--highlight-style=tango",
    ],
    check=True,
)
shutil.rmtree("f9", ignore_errors=True)
with zipfile.ZipFile("frag9.docx") as z:
    z.extractall("f9")
parser = etree.XMLParser(huge_tree=True)
fbody = etree.parse("f9/word/document.xml", parser).getroot().find(q("body"))
frags, cur = {}, None
for el in fbody:
    if el.tag == q("sectPr"):
        continue
    t = text_of(el).strip() if el.tag == q("p") else ""
    if t.startswith("@@FRAG ") and t.endswith("@@"):
        cur = t[7:-2]
        frags[cur] = []
    elif cur:
        frags[cur].append(el)

doc = etree.parse("u/word/document.xml", parser)
paras = list(doc.getroot().iter(q("p")))
for routine in ROUTINES:
    head = "procedure " + routine + "("
    hits = [p for p in paras if text_of(p).startswith(head)]
    if len(hits) != 1:
        sys.exit(f"{routine}: {len(hits)} listings found")
    old = hits[0]
    new = [copy.deepcopy(e) for e in frags[routine]]
    if len(new) != 1 or ("ReportCable" in routine and "LPrev" not in text_of(new[0])):
        sys.exit(f"{routine}: unexpected fragment")
    parent = old.getparent()
    pos = parent.index(old)
    parent.remove(old)
    parent.insert(pos, new[0])
    print("replaced", routine)

schemafix.schema_fix(doc.getroot())
schemafix.drop_empty_separators(doc.getroot())
doc.write(
    "u/word/document.xml", xml_declaration=True, encoding="UTF-8", standalone=True
)
OUT = "report_rev9.docx"
if os.path.exists(OUT):
    os.remove(OUT)
with (
    zipfile.ZipFile("user.docx") as zin,
    zipfile.ZipFile(OUT, "w", zipfile.ZIP_DEFLATED) as zout,
):
    for item in zin.infolist():
        data = (
            open(os.path.join("u", item.filename), "rb").read()
            if item.filename == "word/document.xml"
            else zin.read(item.filename)
        )
        zout.writestr(item, data)
print("written", OUT)
