"""Apply the session-8 revisions to the student's edited report.

Only the paragraphs named below are replaced or inserted; everything else
(including the student's manual edits and screenshots) is kept byte for
byte. Replacement paragraphs keep the paragraph properties (style) of the
paragraph they replace.
"""

import copy
import os
import re
import shutil
import subprocess
import sys
import zipfile

from lxml import etree

sys.path.insert(0, "../report")
import codeblocks  # noqa: E402
import schemafix  # noqa: E402

W = "http://schemas.openxmlformats.org/wordprocessingml/2006/main"


def q(tag):
    return "{%s}%s" % (W, tag)


def text_of(el):
    return "".join(el.itertext())


# fragments: prose from fragments_text.md, code from the current sources
CODE = [
    ("CODE_DefaultCableParams", "HHModel", "DefaultCableParams"),
    ("CODE_SimulateCable", "HHModel", "SimulateCable"),
    ("CODE_BuildAPGStimulus", "Unit1", "TForm1.BuildAPGStimulus"),
    ("CODE_btnRunAPGClick", "Unit1", "TForm1.btnRunAPGClick"),
    ("CODE_LecturerCableParams", "Unit1", "TForm1.LecturerCableParams"),
    ("CODE_ApplyAPPPreset", "Unit1", "TForm1.ApplyAPPPreset"),
    ("CODE_FillAPPEditor", "Unit1", "TForm1.FillAPPEditor"),
    ("CODE_btnPresetSquidClick", "Unit1", "TForm1.btnPresetSquidClick"),
    ("CODE_btnPresetLecturerClick", "Unit1", "TForm1.btnPresetLecturerClick"),
    ("CODE_btnRunAPPClick", "Unit1", "TForm1.btnRunAPPClick"),
    ("CODE_ReportCable", "Unit1", "TForm1.ReportCable"),
]
md = open("fragments_text.md", encoding="utf-8").read().rstrip() + "\n\n"
for name, unit, routine in CODE:
    md += f"@@FRAG {name}@@\n\n" + codeblocks.md(unit, routine) + "\n\n"
md += "@@FRAG END@@\n"
for bad in ("\u2013", "\u2014"):
    assert bad not in md, "en/em dash in fragments"
open("fragments_full.md", "w", encoding="utf-8").write(md)
subprocess.run(
    [
        "pandoc",
        "fragments_full.md",
        "-f",
        "markdown-implicit_figures",
        "-o",
        "frag.docx",
        "--reference-doc=user.docx",
        "--highlight-style=tango",
    ],
    check=True,
)
shutil.rmtree("f", ignore_errors=True)
with zipfile.ZipFile("frag.docx") as z:
    z.extractall("f")
parser = etree.XMLParser(huge_tree=True)
fbody = etree.parse("f/word/document.xml", parser).getroot().find(q("body"))
frags, cur = {}, None
for el in fbody:
    if el.tag == q("sectPr"):
        continue
    m = re.match(r"^@@FRAG (\w+)@@$", text_of(el).strip()) if el.tag == q("p") else None
    if m:
        cur = m.group(1)
        frags[cur] = []
    elif cur:
        frags[cur].append(el)

# target document
doc = etree.parse("u/word/document.xml", parser)
body = doc.getroot().find(q("body"))
paras = [p for p in body.iter(q("p"))]


def para_at(index, must_start):
    p = paras[index]
    t = text_of(p)
    if not t.startswith(must_start):
        sys.exit(f"paragraph {index} does not start with {must_start!r}: {t[:60]!r}")
    return p


def code_para(first_line):
    hits = [p for p in paras if text_of(p).startswith(first_line)]
    if len(hits) != 1:
        sys.exit(f"code listing {first_line!r}: {len(hits)} matches")
    return hits[0]


def adopt_ppr(new_p, old_p):
    """Give new_p the paragraph properties of old_p (student's style)."""
    old_ppr = old_p.find(q("pPr"))
    new_ppr = new_p.find(q("pPr"))
    if new_ppr is not None:
        new_p.remove(new_ppr)
    if old_ppr is not None:
        new_p.insert(0, copy.deepcopy(old_ppr))


def styled_copy(elements, model):
    """Copy fragment elements; plain body paragraphs take the model's style."""
    out = []
    for el in elements:
        e = copy.deepcopy(el)
        sty = e.find(q("pPr") + "/" + q("pStyle"))
        if e.tag == q("p") and (
            sty is None
            or sty.get(q("val")) in ("FirstParagraph", "BodyText", "Compact")
        ):
            adopt_ppr(e, model)
        out.append(e)
    return out


def replace_para(old, frag):
    new = styled_copy(frags[frag], old)
    parent = old.getparent()
    pos = parent.index(old)
    parent.remove(old)
    for k, e in enumerate(new):
        parent.insert(pos + k, e)


def insert_after(anchor, frag, model=None):
    new = styled_copy(frags[frag], model if model is not None else anchor)
    parent = anchor.getparent()
    pos = parent.index(anchor)
    for k, e in enumerate(new):
        parent.insert(pos + 1 + k, e)


def insert_before(anchor, frag):
    new = [copy.deepcopy(e) for e in frags[frag]]
    parent = anchor.getparent()
    pos = parent.index(anchor)
    for k, e in enumerate(new):
        parent.insert(pos + k, e)


def replace_code(old, frag):
    new = [copy.deepcopy(e) for e in frags[frag]]
    parent = old.getparent()
    pos = parent.index(old)
    parent.remove(old)
    for k, e in enumerate(new):
        parent.insert(pos + k, e)


# resolve every target before modifying the tree
T = {
    "P54": para_at(54, "For a cylindrical axon of radius"),
    "P59": para_at(59, "The central difference has a truncation"),
    "P79": para_at(79, "The main window has six tabs"),
    "P177": para_at(177, "For the squid axon of Problem 3"),
    "P179": para_at(179, "DefaultCableParams sets the squid"),
    "P185": para_at(185, "On the form, FillAPPEditor"),
    "P362": para_at(362, "Table 2.5 summarizes the parameter"),
    "CELL374": para_at(374, "Lecturer scale, a"),
    "P381": para_at(381, "Compared with the reference programs"),
    "P385": para_at(385, "Several limitations must be kept"),
    "P388": para_at(388, "The integration of the cable equation"),
    "C_DefaultCableParams": code_para("function DefaultCableParams: TCableParams;"),
    "C_SimulateCable": code_para("procedure SimulateCable(const HP: THHParams;"),
    "C_btnRunAPGClick": code_para("procedure TForm1.btnRunAPGClick(Sender: TObject);"),
    "C_FillAPPEditor": code_para("procedure TForm1.FillAPPEditor("),
    "C_btnPresetSquidClick": code_para("procedure TForm1.btnPresetSquidClick("),
    "C_btnPresetLecturerClick": code_para("procedure TForm1.btnPresetLecturerClick("),
    "C_btnRunAPPClick": code_para("procedure TForm1.btnRunAPPClick("),
    "C_ReportCable": code_para("procedure TForm1.ReportCable("),
}

replace_para(T["P54"], "P54")
insert_after(T["P59"], "P59AFTER")
replace_para(T["P79"], "P79")
insert_after(T["P177"], "P177AFTER")
replace_para(T["P179"], "P179")
replace_para(T["P185"], "P185")
replace_para(T["P362"], "P362")
replace_para(T["CELL374"], "CELL374")
insert_after(T["P381"], "P381AFTER")  # uses the style of P381 for prose
replace_para(T["P381"], "P381")
replace_para(T["P385"], "P385")
replace_para(T["P388"], "P388")
insert_before(T["C_btnRunAPGClick"], "CODE_BuildAPGStimulus")
replace_code(T["C_btnRunAPGClick"], "CODE_btnRunAPGClick")
insert_before(T["C_FillAPPEditor"], "CODE_LecturerCableParams")
insert_before(T["C_FillAPPEditor"], "CODE_ApplyAPPPreset")
for name in (
    "DefaultCableParams",
    "SimulateCable",
    "FillAPPEditor",
    "btnPresetSquidClick",
    "btnPresetLecturerClick",
    "btnRunAPPClick",
    "ReportCable",
):
    replace_code(T["C_" + name], "CODE_" + name)

schemafix.schema_fix(doc.getroot())
schemafix.drop_empty_separators(doc.getroot())
doc.write(
    "u/word/document.xml", xml_declaration=True, encoding="UTF-8", standalone=True
)

OUT = "report_rev.docx"
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
