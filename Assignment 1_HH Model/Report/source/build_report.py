"""Build the Assignment 1 report.

1. Assemble the Markdown parts and insert the complete Delphi routines.
2. Convert with pandoc (styles taken from the student's original .docx).
3. Merge: original cover + generated chapters, with the original problem
   statement (Section 2.1, provided by the student) inserted unchanged.
4. Restyle (Times New Roman, justified body, yellow highlighted equations,
   code listing style, captions, table borders) and zip the result.
"""

import copy
import os
import re
import shutil
import subprocess
import sys
import zipfile

from lxml import etree

import codeblocks

W = "http://schemas.openxmlformats.org/wordprocessingml/2006/main"
R = "http://schemas.openxmlformats.org/officeDocument/2006/relationships"
PR = "http://schemas.openxmlformats.org/package/2006/relationships"
NS = {"w": W, "r": R}


def q(tag):
    p, t = tag.split(":")
    return "{%s}%s" % ({"w": W, "r": R}[p], t)


# 1. markdown
parts = [
    "report_part1.md",
    "report_part2.md",
    "report_part3.md",
    "report_part4.md",
    "report_part5.md",
]
md = ""
for i, p in enumerate(parts):
    text = open(p, encoding="utf-8").read()
    if i == 1:
        # Chapter II heading + marker where the original Section 2.1 goes
        text = (
            "# CHAPTER II. RESULT AND ANALYSIS\n\n## 2.1 Problems Statement\n\n"
            "@@SEC21@@\n\n" + text
        )
    md += text.rstrip() + "\n\n"


def code_sub(m):
    unit, name = m.group(1), m.group(2)
    return codeblocks.md(unit, name)


md, n_code = re.subn(r"^@@CODE (\w+) ([\w.]+)@@$", code_sub, md, flags=re.M)
open("full.md", "w", encoding="utf-8").write(md)
print("code blocks inserted:", n_code)
if "@@CODE" in md:
    sys.exit("unresolved code token")
for bad in ("\u2014", "\u2013"):
    if bad in md:
        print("WARNING: dash character", repr(bad), "found", md.count(bad), "times")

# 2. pandoc
subprocess.run(
    [
        "pandoc",
        "full.md",
        "-f",
        "markdown-implicit_figures",
        "-o",
        "body.docx",
        "--reference-doc=original.docx",
        "--highlight-style=tango",
    ],
    check=True,
)
if os.path.isdir("b"):
    shutil.rmtree("b")
with zipfile.ZipFile("body.docx") as z:
    z.extractall("b")

# 3. merge
parser = etree.XMLParser(remove_blank_text=False, huge_tree=True)
orig = etree.parse("unpacked/word/document.xml", parser)
gen = etree.parse("b/word/document.xml", parser)
obody = orig.getroot().find(q("w:body"))
gbody = gen.getroot().find(q("w:body"))


def text_of(el):
    return "".join(el.itertext()).strip()


ochildren = list(obody)
idx = {text_of(c): i for i, c in enumerate(ochildren) if c.tag == q("w:p")}
c1 = idx["CHAPTER I. FUNDAMENTAL THEORY"]
i21 = idx["2.1. Problems Statement"]
c22 = idx["2.2. Code Explanation"]
cover = ochildren[:c1]
sec21 = ochildren[i21 + 1 : c22]
osect = obody.find(q("w:sectPr"))

# drop empty trailing cover paragraphs (the chapter heading breaks the page)
while (
    cover
    and cover[-1].tag == q("w:p")
    and not text_of(cover[-1])
    and cover[-1].find(".//" + q("w:drawing")) is None
):
    cover.pop()

# relationships: copy what the cover and Section 2.1 reference
orels = etree.parse("unpacked/word/_rels/document.xml.rels")
grels = etree.parse("b/word/_rels/document.xml.rels")
omap = {r.get("Id"): r for r in orels.getroot()}
used_ids = {r.get("Id") for r in grels.getroot()}
remap = {}


def import_rel(old_id):
    if old_id in remap:
        return remap[old_id]
    rel = omap[old_id]
    new_id = "rIdOrig" + old_id[3:]
    while new_id in used_ids:
        new_id += "x"
    used_ids.add(new_id)
    new = copy.deepcopy(rel)
    new.set("Id", new_id)
    if rel.get("Type").endswith("/image"):
        src = os.path.join("unpacked/word", rel.get("Target"))
        name = "orig_" + os.path.basename(rel.get("Target"))
        os.makedirs("b/word/media", exist_ok=True)
        shutil.copyfile(src, os.path.join("b/word/media", name))
        new.set("Target", "media/" + name)
    grels.getroot().append(new)
    remap[old_id] = new_id
    return new_id


def imported(elements):
    out = []
    for el in elements:
        e = copy.deepcopy(el)
        for node in e.iter():
            for attr in (q("r:embed"), q("r:id"), q("r:link")):
                if node.get(attr) and node.get(attr) in omap:
                    node.set(attr, import_rel(node.get(attr)))
        out.append(e)
    return out


cover_x = imported(cover)
sec21_x = imported(sec21)

gchildren = [c for c in gbody if c.tag != q("w:sectPr")]
for c in list(gbody):
    gbody.remove(c)
for e in cover_x:
    gbody.append(e)
for c in gchildren:
    if c.tag == q("w:p") and text_of(c) == "@@SEC21@@":
        for e in sec21_x:
            gbody.append(e)
    else:
        gbody.append(c)
gbody.append(copy.deepcopy(osect))

# 4. styles
styles = etree.parse("b/word/styles.xml", parser)
sroot = styles.getroot()

RPR_TNR = (
    '<w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" '
    'w:eastAsia="Times New Roman" w:cs="Times New Roman"/>'
)


def style_xml(sid, name, kind, ppr, rpr, based="Normal", extra=""):
    return (
        f'<w:style xmlns:w="{W}" w:type="{kind}" w:customStyle="1" w:styleId="{sid}">'
        f'<w:name w:val="{name}"/><w:basedOn w:val="{based}"/>{extra}<w:qFormat/>'
        f"<w:pPr>{ppr}</w:pPr><w:rPr>{rpr}</w:rPr></w:style>"
    )


def put_style(xml):
    new = etree.fromstring(xml)
    sid = new.get(q("w:styleId"))
    for old in sroot.findall(q("w:style")):
        if old.get(q("w:styleId")) == sid:
            if old.get(q("w:customStyle")) is None:
                new.attrib.pop(q("w:customStyle"), None)
            sroot.replace(old, new)
            return
    sroot.append(new)


BODY_P = (
    '<w:spacing w:before="0" w:after="120" w:line="300" w:lineRule="auto"/>'
    '<w:jc w:val="both"/>'
)
BODY_R = RPR_TNR + '<w:sz w:val="24"/><w:szCs w:val="24"/>'
for sid, name in (
    ("BodyText", "Body Text"),
    ("FirstParagraph", "First Paragraph"),
    ("Compact", "Compact"),
):
    put_style(style_xml(sid, name, "paragraph", BODY_P, BODY_R))
put_style(
    style_xml(
        "Heading1",
        "heading 1",
        "paragraph",
        '<w:keepNext/><w:pageBreakBefore/><w:spacing w:before="0" w:after="240"/>'
        '<w:jc w:val="center"/><w:outlineLvl w:val="0"/>',
        RPR_TNR
        + '<w:b/><w:bCs/><w:color w:val="000000"/><w:sz w:val="30"/><w:szCs w:val="30"/>',
    )
)
put_style(
    style_xml(
        "Heading2",
        "heading 2",
        "paragraph",
        '<w:keepNext/><w:spacing w:before="240" w:after="120"/><w:outlineLvl w:val="1"/>',
        RPR_TNR
        + '<w:b/><w:bCs/><w:color w:val="000000"/><w:sz w:val="24"/><w:szCs w:val="24"/>',
    )
)
put_style(
    style_xml(
        "Heading3",
        "heading 3",
        "paragraph",
        '<w:keepNext/><w:spacing w:before="200" w:after="100"/><w:ind w:left="284"/>'
        '<w:outlineLvl w:val="2"/>',
        RPR_TNR
        + '<w:b/><w:bCs/><w:color w:val="000000"/><w:sz w:val="24"/><w:szCs w:val="24"/>',
    )
)
put_style(
    style_xml(
        "Figure",
        "Figure",
        "paragraph",
        '<w:keepNext/><w:spacing w:before="120" w:after="60"/><w:jc w:val="center"/>',
        BODY_R,
    )
)
put_style(
    style_xml(
        "CaptionText",
        "Caption Text",
        "paragraph",
        '<w:spacing w:before="0" w:after="200"/><w:jc w:val="center"/>',
        RPR_TNR + '<w:i/><w:iCs/><w:sz w:val="22"/><w:szCs w:val="22"/>',
    )
)
put_style(
    style_xml(
        "HighlightedEquation",
        "Highlighted Equation",
        "paragraph",
        '<w:shd w:val="clear" w:color="auto" w:fill="FFF2A8"/>'
        '<w:spacing w:before="60" w:after="120"/><w:ind w:left="567" w:right="567"/>'
        '<w:jc w:val="center"/>',
        BODY_R,
    )
)
put_style(
    style_xml(
        "Reference",
        "Reference",
        "paragraph",
        '<w:spacing w:before="0" w:after="100"/><w:ind w:left="567" w:hanging="567"/>'
        '<w:jc w:val="both"/>',
        BODY_R,
    )
)
put_style(
    style_xml(
        "SourceCode",
        "Source Code",
        "paragraph",
        '<w:wordWrap w:val="off"/><w:shd w:val="clear" w:color="auto" w:fill="F4F4F4"/>'
        '<w:spacing w:before="60" w:after="160" w:line="240" w:lineRule="auto"/>'
        '<w:ind w:left="113" w:right="113"/>',
        '<w:rFonts w:ascii="Consolas" w:hAnsi="Consolas" w:cs="Consolas"/>'
        '<w:sz w:val="16"/><w:szCs w:val="16"/>',
    )
)
put_style(
    f'<w:style xmlns:w="{W}" w:type="character" w:customStyle="1" w:styleId="VerbatimChar">'
    '<w:name w:val="Verbatim Char"/><w:rPr><w:rFonts w:ascii="Consolas" w:hAnsi="Consolas" '
    'w:cs="Consolas"/><w:sz w:val="21"/><w:szCs w:val="21"/></w:rPr></w:style>'
)
put_style(
    f'<w:style xmlns:w="{W}" w:type="table" w:styleId="Table"><w:name w:val="Table"/>'
    '<w:basedOn w:val="TableNormal"/><w:pPr><w:spacing w:before="20" w:after="20"/>'
    '<w:jc w:val="left"/></w:pPr><w:rPr>'
    + RPR_TNR
    + '<w:sz w:val="20"/><w:szCs w:val="20"/></w:rPr><w:tblPr><w:tblBorders>'
    '<w:top w:val="single" w:sz="8" w:space="0" w:color="000000"/>'
    '<w:left w:val="single" w:sz="4" w:space="0" w:color="808080"/>'
    '<w:bottom w:val="single" w:sz="8" w:space="0" w:color="000000"/>'
    '<w:right w:val="single" w:sz="4" w:space="0" w:color="808080"/>'
    '<w:insideH w:val="single" w:sz="4" w:space="0" w:color="808080"/>'
    '<w:insideV w:val="single" w:sz="4" w:space="0" w:color="808080"/>'
    '</w:tblBorders><w:tblCellMar><w:left w:w="80" w:type="dxa"/>'
    '<w:right w:w="80" w:type="dxa"/></w:tblCellMar></w:tblPr>'
    '<w:tblStylePr w:type="firstRow"><w:rPr><w:b/><w:bCs/></w:rPr><w:tcPr>'
    '<w:shd w:val="clear" w:color="auto" w:fill="E7E6E6"/></w:tcPr></w:tblStylePr></w:style>'
)
styles.write(
    "b/word/styles.xml", xml_declaration=True, encoding="UTF-8", standalone=True
)

# table cell paragraphs: pandoc gives them style Compact (justified) -> left
for tbl in gbody.iter(q("w:tbl")):
    tblpr = tbl.find(q("w:tblPr"))
    width = tblpr.find(q("w:tblW"))
    if width is not None:
        width.set(q("w:type"), "pct")
        width.set(q("w:w"), "5000")
    for p in tbl.iter(q("w:p")):
        ppr = p.find(q("w:pPr"))
        if ppr is None:
            ppr = etree.SubElement(p, q("w:pPr"))
            p.insert(0, ppr)
        if ppr.find(q("w:jc")) is None:
            jc = etree.SubElement(ppr, q("w:jc"))
            jc.set(q("w:val"), "left")

# breathing space between a table and the following paragraph
for tbl in gbody.findall(q("w:tbl")):
    nxt = tbl.getnext()
    if nxt is not None and nxt.tag == q("w:p"):
        ppr = nxt.find(q("w:pPr"))
        if ppr is None:
            ppr = etree.Element(q("w:pPr"))
            nxt.insert(0, ppr)
        sp = ppr.find(q("w:spacing"))
        if sp is None:
            sp = etree.SubElement(ppr, q("w:spacing"))
        sp.set(q("w:before"), "200")

# keep small tables on one page: rows cannot split, every paragraph except
# those of the last row keeps with the next; table captions keep with table
for tbl in gbody.findall(q("w:tbl")):
    rows = tbl.findall(q("w:tr"))
    for ri, tr in enumerate(rows):
        trpr = tr.find(q("w:trPr"))
        if trpr is None:
            trpr = etree.Element(q("w:trPr"))
            tr.insert(1 if tr.find(q("w:tblPrEx")) is not None else 0, trpr)
        if trpr.find(q("w:cantSplit")) is None:
            trpr.insert(0, etree.Element(q("w:cantSplit")))
        if ri < len(rows) - 1:
            for para in tr.iter(q("w:p")):
                ppr = para.find(q("w:pPr"))
                if ppr is None:
                    ppr = etree.Element(q("w:pPr"))
                    para.insert(0, ppr)
                if ppr.find(q("w:keepNext")) is None:
                    ppr.append(etree.Element(q("w:keepNext")))
for para in gbody.findall(q("w:p")):
    sty = para.find(".//" + q("w:pStyle"))
    if text_of(para).startswith("Table ") and sty is not None \
            and sty.get(q("w:val")) == "CaptionText":
        para.find(q("w:pPr")).append(etree.Element(q("w:keepNext")))

import schemafix  # noqa: E402

# no lists are used: take the (schema-valid) numbering and settings parts of
# the original document instead of pandoc's
shutil.copyfile("unpacked/word/numbering.xml", "b/word/numbering.xml")
shutil.copyfile("unpacked/word/settings.xml", "b/word/settings.xml")
ct_path = "b/[Content_Types].xml"
ct = open(ct_path, encoding="utf-8").read()
if 'Extension="png"' not in ct:
    ct = ct.replace(
        "<Default ", '<Default Extension="png" ContentType="image/png"/><Default ', 1
    )
    open(ct_path, "w", encoding="utf-8").write(ct)

schemafix.schema_fix(gen.getroot())
schemafix.drop_empty_separators(gen.getroot())
schemafix.schema_fix(sroot)
styles.write(
    "b/word/styles.xml", xml_declaration=True, encoding="UTF-8", standalone=True
)
gen.write(
    "b/word/document.xml", xml_declaration=True, encoding="UTF-8", standalone=True
)
grels.write(
    "b/word/_rels/document.xml.rels",
    xml_declaration=True,
    encoding="UTF-8",
    standalone=True,
)

# remove media files that no relationship references (pandoc copies the
# images of the reference document)
_targets = {os.path.normpath(os.path.join("b/word", r.get("Target")))
            for r in etree.parse("b/word/_rels/document.xml.rels").getroot()
            if r.get("TargetMode") != "External"}
for _f in os.listdir("b/word/media"):
    _full = os.path.normpath(os.path.join("b/word/media", _f))
    if _full not in _targets:
        os.remove(_full)

# 5. zip
OUT = "Assignment1_report.docx"
if os.path.exists(OUT):
    os.remove(OUT)
with zipfile.ZipFile(OUT, "w", zipfile.ZIP_DEFLATED) as z:
    # [Content_Types].xml first
    z.write("b/[Content_Types].xml", "[Content_Types].xml")
    for root, _, files in os.walk("b"):
        for f in files:
            full = os.path.join(root, f)
            arc = os.path.relpath(full, "b")
            if arc != "[Content_Types].xml":
                z.write(full, arc)
print(
    "written",
    OUT,
    "cover elements",
    len(cover_x),
    "sec21 elements",
    len(sec21_x),
    "imported rels",
    remap,
)
