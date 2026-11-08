"""Build the Assignment 2 report (Word) from the Markdown sources.

1. Assemble report_part1.md ... report_part3.md (pandoc Markdown with LaTeX
   math; equations become native Word equations).
2. Convert with pandoc, using the student's current report as the reference
   document (styles).
3. Merge: the student's cover and Section 2.1 (problem statement) are taken
   unchanged from that report; Chapter I, Sections 2.2 to 2.4, Chapter III
   and the references come from pandoc. One correction is applied to
   Section 2.1: the accent of the two dotted thetas in Problem 1 was put on
   a character that already carried a dot (rendered as a double dot), see
   ISS-039.
4. Restyle (Times New Roman, justified body, yellow highlighted equations,
   captions, tables) and zip.

Usage (in this folder):
    python build_report.py "<current report>.docx" "<output>.docx"
Needs pandoc 3.x and lxml. Figures: run figs.py first.
"""

import copy
import os
import re
import shutil
import subprocess
import sys
import zipfile

from lxml import etree

import schemafix

W = "http://schemas.openxmlformats.org/wordprocessingml/2006/main"
R = "http://schemas.openxmlformats.org/officeDocument/2006/relationships"
M = "http://schemas.openxmlformats.org/officeDocument/2006/math"
DOTTED_THETA = "θ̇"


def q(tag):
    p, t = tag.split(":")
    return "{%s}%s" % ({"w": W, "r": R, "m": M}[p], t)


def text_of(el):
    return "".join(el.itertext()).strip()


PROGRAM_DIR = os.path.join("..", "..", "Program")


def code_block(unit, routine):
    """Complete routine of a Pascal unit with the line numbers of the file."""
    lines = open(os.path.join(PROGRAM_DIR, unit), encoding="utf-8").read().splitlines()
    impl = next(i for i, ln in enumerate(lines) if ln.strip().lower() == "implementation")
    start = next(i for i in range(impl, len(lines))
                 if re.match(r"(function|procedure)\s+" + re.escape(routine) + r"\b", lines[i]))
    end = next(i for i in range(start, len(lines)) if lines[i] == "end;")
    body = "\n".join(f"{i + 1:4d}  {lines[i]}" for i in range(start, end + 1))
    return "```pascal\n" + body + "\n```"


def assemble():
    parts = ["report_part1.md", "report_part2.md", "report_part3.md"]
    md = ""
    for i, part in enumerate(parts):
        text = open(part, encoding="utf-8").read()
        if i == 1:
            text = (
                "# CHAPTER II. RESULT AND ANALYSIS\n\n## 2.1 Problems Statement\n\n"
                "@@SEC21@@\n\n" + text
            )
        md += text.rstrip() + "\n\n"
    for bad in ("\u2014", "\u2013"):
        if bad in md:
            sys.exit(f"dash character {bad!r} found {md.count(bad)} times")
    md = re.sub(r"^@@CODE (\S+) (\w+)@@$", lambda m: code_block(m.group(1), m.group(2)), md, flags=re.M)
    if "@@CODE" in md:
        sys.exit("unresolved code token")
    open("full.md", "w", encoding="utf-8").write(md)


def unpack(src, dst):
    if os.path.isdir(dst):
        shutil.rmtree(dst)
    with zipfile.ZipFile(src) as z:
        z.extractall(dst)


def fix_double_dot(elements):
    """Replace the base of an over-dot accent that already holds a dot."""
    fixed = 0
    for el in elements:
        for acc in el.iter(q("m:acc")):
            for t in acc.iter(q("m:t")):
                if t.text == DOTTED_THETA:
                    t.text = "θ"
                    fixed += 1
    return fixed


def put_styles(sroot):
    rpr_tnr = (
        '<w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" '
        'w:eastAsia="Times New Roman" w:cs="Times New Roman"/>'
    )

    def style_xml(sid, name, kind, ppr, rpr, based="Normal"):
        return (
            f'<w:style xmlns:w="{W}" w:type="{kind}" w:customStyle="1" w:styleId="{sid}">'
            f'<w:name w:val="{name}"/><w:basedOn w:val="{based}"/><w:qFormat/>'
            f"<w:pPr>{ppr}</w:pPr><w:rPr>{rpr}</w:rPr></w:style>"
        )

    def put(xml):
        new = etree.fromstring(xml)
        sid = new.get(q("w:styleId"))
        for old in sroot.findall(q("w:style")):
            if old.get(q("w:styleId")) == sid:
                if old.get(q("w:customStyle")) is None:
                    new.attrib.pop(q("w:customStyle"), None)
                sroot.replace(old, new)
                return
        sroot.append(new)

    body_p = (
        '<w:spacing w:before="0" w:after="120" w:line="300" w:lineRule="auto"/>'
        '<w:jc w:val="both"/>'
    )
    body_r = rpr_tnr + '<w:sz w:val="24"/><w:szCs w:val="24"/>'
    for sid, name in (
        ("BodyText", "Body Text"),
        ("FirstParagraph", "First Paragraph"),
        ("Compact", "Compact"),
    ):
        put(style_xml(sid, name, "paragraph", body_p, body_r))
    put(
        style_xml(
            "Heading1",
            "heading 1",
            "paragraph",
            '<w:keepNext/><w:pageBreakBefore/><w:spacing w:before="0" w:after="240"/>'
            '<w:jc w:val="center"/><w:outlineLvl w:val="0"/>',
            rpr_tnr
            + '<w:b/><w:bCs/><w:color w:val="000000"/><w:sz w:val="30"/><w:szCs w:val="30"/>',
        )
    )
    put(
        style_xml(
            "Heading2",
            "heading 2",
            "paragraph",
            '<w:keepNext/><w:spacing w:before="240" w:after="120"/><w:outlineLvl w:val="1"/>',
            rpr_tnr
            + '<w:b/><w:bCs/><w:color w:val="000000"/><w:sz w:val="24"/><w:szCs w:val="24"/>',
        )
    )
    put(
        style_xml(
            "Heading3",
            "heading 3",
            "paragraph",
            '<w:keepNext/><w:spacing w:before="200" w:after="100"/><w:ind w:left="284"/>'
            '<w:outlineLvl w:val="2"/>',
            rpr_tnr
            + '<w:b/><w:bCs/><w:color w:val="000000"/><w:sz w:val="24"/><w:szCs w:val="24"/>',
        )
    )
    put(
        style_xml(
            "Figure",
            "Figure",
            "paragraph",
            '<w:keepNext/><w:spacing w:before="120" w:after="60"/><w:jc w:val="center"/>',
            body_r,
        )
    )
    put(
        style_xml(
            "CaptionText",
            "Caption Text",
            "paragraph",
            '<w:spacing w:before="0" w:after="200"/><w:jc w:val="center"/>',
            rpr_tnr + '<w:i/><w:iCs/><w:sz w:val="22"/><w:szCs w:val="22"/>',
        )
    )
    put(
        style_xml(
            "HighlightedEquation",
            "Highlighted Equation",
            "paragraph",
            '<w:shd w:val="clear" w:color="auto" w:fill="FFF2A8"/>'
            '<w:spacing w:before="60" w:after="120"/><w:ind w:left="567" w:right="567"/>'
            '<w:jc w:val="center"/>',
            body_r,
        )
    )
    put(
        style_xml(
            "Reference",
            "Reference",
            "paragraph",
            '<w:spacing w:before="0" w:after="100"/><w:ind w:left="567" w:hanging="567"/>'
            '<w:jc w:val="both"/>',
            body_r,
        )
    )
    put(
        f'<w:style xmlns:w="{W}" w:type="character" w:customStyle="1" w:styleId="VerbatimChar">'
        '<w:name w:val="Verbatim Char"/><w:rPr><w:rFonts w:ascii="Consolas" w:hAnsi="Consolas" '
        'w:cs="Consolas"/><w:sz w:val="21"/><w:szCs w:val="21"/></w:rPr></w:style>'
    )
    put(
        f'<w:style xmlns:w="{W}" w:type="table" w:styleId="Table"><w:name w:val="Table"/>'
        '<w:basedOn w:val="TableNormal"/><w:pPr><w:spacing w:before="20" w:after="20"/>'
        '<w:jc w:val="left"/></w:pPr><w:rPr>'
        + rpr_tnr
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


def set_column_widths(tbl, text_width):
    """Column widths from the content: longest word and square root of length."""
    rows = tbl.findall(q("w:tr"))
    ncol = max(len(r.findall(q("w:tc"))) for r in rows)
    weights = [1.0] * ncol
    for r in rows:
        for j, tc in enumerate(r.findall(q("w:tc"))):
            txt = text_of(tc)
            longest = max((len(w) for w in txt.split()), default=1)
            weights[j] = max(weights[j], longest + 2.0, 4.0 * len(txt) ** 0.5)
    total = sum(weights)
    widths = [int(text_width * w / total) for w in weights]
    grid = tbl.find(q("w:tblGrid"))
    if grid is not None:
        for gc, w in zip(grid.findall(q("w:gridCol")), widths):
            gc.set(q("w:w"), str(w))
    tblpr = tbl.find(q("w:tblPr"))
    layout = tblpr.find(q("w:tblLayout"))
    if layout is None:
        layout = etree.SubElement(tblpr, q("w:tblLayout"))
    layout.set(q("w:type"), "fixed")
    for r in rows:
        for tc, w in zip(r.findall(q("w:tc")), widths):
            tcpr = tc.find(q("w:tcPr"))
            if tcpr is None:
                tcpr = etree.Element(q("w:tcPr"))
                tc.insert(0, tcpr)
            tcw = tcpr.find(q("w:tcW"))
            if tcw is None:
                tcw = etree.Element(q("w:tcW"))
                tcpr.insert(0, tcw)
            tcw.set(q("w:w"), str(w))
            tcw.set(q("w:type"), "dxa")


def format_tables(gbody, text_width):
    for tbl in gbody.iter(q("w:tbl")):
        sty = tbl.find(q("w:tblPr") + "/" + q("w:tblStyle"))
        if sty is not None and sty.get(q("w:val")) == "Table":
            set_column_widths(tbl, text_width)
        tblpr = tbl.find(q("w:tblPr"))
        width = tblpr.find(q("w:tblW")) if tblpr is not None else None
        if width is not None:
            width.set(q("w:type"), "pct")
            width.set(q("w:w"), "5000")
        rows = tbl.findall(q("w:tr"))
        for ri, tr in enumerate(rows):
            trpr = tr.find(q("w:trPr"))
            if trpr is None:
                trpr = etree.Element(q("w:trPr"))
                tr.insert(1 if tr.find(q("w:tblPrEx")) is not None else 0, trpr)
            if trpr.find(q("w:cantSplit")) is None:
                trpr.insert(0, etree.Element(q("w:cantSplit")))
            for para in tr.iter(q("w:p")):
                ppr = para.find(q("w:pPr"))
                if ppr is None:
                    ppr = etree.Element(q("w:pPr"))
                    para.insert(0, ppr)
                if ppr.find(q("w:jc")) is None:
                    jc = etree.SubElement(ppr, q("w:jc"))
                    jc.set(q("w:val"), "left")
                if ri < len(rows) - 1 and ppr.find(q("w:keepNext")) is None:
                    ppr.append(etree.Element(q("w:keepNext")))
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
    for para in gbody.findall(q("w:p")):
        sty = para.find(".//" + q("w:pStyle"))
        if (
            text_of(para).startswith("Table ")
            and sty is not None
            and sty.get(q("w:val")) == "CaptionText"
        ):
            para.find(q("w:pPr")).append(etree.Element(q("w:keepNext")))


def code_size(gbody):
    """Code listings at 8 pt, whatever size the token styles carry."""
    for para in gbody.iter(q("w:p")):
        sty = para.find(q("w:pPr") + "/" + q("w:pStyle"))
        if sty is None or sty.get(q("w:val")) != "SourceCode":
            continue
        for run in para.iter(q("w:r")):
            rpr = run.find(q("w:rPr"))
            if rpr is None:
                rpr = etree.Element(q("w:rPr"))
                run.insert(0, rpr)
            for tag in ("w:sz", "w:szCs"):
                el = rpr.find(q(tag))
                if el is None:
                    el = etree.SubElement(rpr, q(tag))
                el.set(q("w:val"), "16")


def indent_prose(elements):
    """First-line indent (1 cm) for prose paragraphs, as in my Word version.

    Display equations, captions, code and table cells keep no indent.
    """
    n = 0
    for el in elements:
        if el.tag != q("w:p"):
            continue
        ppr = el.find(q("w:pPr"))
        sty = None if ppr is None else ppr.find(q("w:pStyle"))
        if sty is None or sty.get(q("w:val")) not in ("BodyText", "FirstParagraph"):
            continue
        if el.find(".//" + q("m:oMathPara")) is not None:
            continue
        words = "".join(t.text or "" for t in el.iter(q("w:t"))).strip()
        if not words:
            continue
        ind = ppr.find(q("w:ind"))
        if ind is None:
            ind = etree.Element(q("w:ind"))
            jc = ppr.find(q("w:jc"))
            if jc is not None:
                jc.addprevious(ind)
            else:
                ppr.append(ind)
        ind.set(q("w:firstLine"), "567")
        n += 1
    return n


def main(src_docx, out_docx):
    assemble()
    unpack(src_docx, "unpacked")
    subprocess.run(
        [
            "pandoc",
            "full.md",
            "-f",
            "markdown-implicit_figures",
            "-o",
            "body.docx",
            f"--reference-doc={src_docx}",
        ],
        check=True,
    )
    unpack("body.docx", "b")

    parser = etree.XMLParser(remove_blank_text=False, huge_tree=True)
    orig = etree.parse("unpacked/word/document.xml", parser)
    gen = etree.parse("b/word/document.xml", parser)
    obody = orig.getroot().find(q("w:body"))
    gbody = gen.getroot().find(q("w:body"))
    ochildren = list(obody)
    idx = {}
    for i, c in enumerate(ochildren):
        if c.tag == q("w:p"):
            idx.setdefault(text_of(c), i)
    c1 = idx["CHAPTER I. FUNDAMENTAL THEORY"]
    i21 = idx["2.1 Problems Statement"]
    c22 = next(i for t, i in idx.items() if re.match(r"2\.2 Answer", t))
    cover = ochildren[:c1]
    sec21 = ochildren[i21 + 1 : c22]
    osect = obody.find(q("w:sectPr"))
    while (
        cover
        and cover[-1].tag == q("w:p")
        and not text_of(cover[-1])
        and cover[-1].find(".//" + q("w:drawing")) is None
    ):
        cover.pop()

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
            name = "orig_" + os.path.basename(rel.get("Target"))
            os.makedirs("b/word/media", exist_ok=True)
            shutil.copyfile(
                os.path.join("unpacked/word", rel.get("Target")),
                os.path.join("b/word/media", name),
            )
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
    n_dot = fix_double_dot(sec21_x)

    gchildren = [c for c in gbody if c.tag != q("w:sectPr")]
    n_ind = indent_prose(gchildren)
    print("indented paragraphs", n_ind)
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

    styles = etree.parse("b/word/styles.xml", parser)
    put_styles(styles.getroot())
    pg_w = int(osect.find(q("w:pgSz")).get(q("w:w")))
    mar = osect.find(q("w:pgMar"))
    text_w = pg_w - int(mar.get(q("w:left"))) - int(mar.get(q("w:right")))
    format_tables(gbody, text_w)
    code_size(gbody)

    shutil.copyfile("unpacked/word/numbering.xml", "b/word/numbering.xml")
    shutil.copyfile("unpacked/word/settings.xml", "b/word/settings.xml")
    # every media extension needs a Default content type, otherwise Word
    # reports the package as damaged (the cover logo of the template is EMF)
    ct_path = "b/[Content_Types].xml"
    ct = open(ct_path, encoding="utf-8").read()
    media_types = {"png": "image/png", "jpeg": "image/jpeg", "jpg": "image/jpeg",
                   "gif": "image/gif", "emf": "image/x-emf", "wmf": "image/x-wmf",
                   "svg": "image/svg+xml", "tif": "image/tiff", "tiff": "image/tiff"}
    exts = {os.path.splitext(f)[1][1:].lower() for f in os.listdir("b/word/media")}
    for ext in sorted(exts):
        if f'Extension="{ext}"' not in ct:
            if ext not in media_types:
                sys.exit(f"no content type known for media extension {ext!r}")
            ct = ct.replace("<Default ", f'<Default Extension="{ext}" ContentType="{media_types[ext]}"/><Default ', 1)
    open(ct_path, "w", encoding="utf-8").write(ct)
    core = "b/docProps/core.xml"
    if os.path.exists(core):
        c = open(core, encoding="utf-8").read()
        c = re.sub(
            r"<dc:title>.*?</dc:title>|<dc:title/>",
            "<dc:title>Assignment 2: Lagrangian and Hamiltonian Mechanics</dc:title>",
            c,
        )
        if "<dc:creator>" not in c:
            c = c.replace(
                "</cp:coreProperties>",
                "<dc:creator>Jeremia Christ Immanuel Manalu</dc:creator></cp:coreProperties>",
            )
        open(core, "w", encoding="utf-8").write(c)

    schemafix.schema_fix(gen.getroot())
    schemafix.drop_empty_separators(gen.getroot())
    schemafix.schema_fix(styles.getroot())
    for tree, path in (
        (styles, "b/word/styles.xml"),
        (gen, "b/word/document.xml"),
        (grels, "b/word/_rels/document.xml.rels"),
    ):
        tree.write(path, xml_declaration=True, encoding="UTF-8", standalone=True)

    targets = {
        os.path.normpath(os.path.join("b/word", r.get("Target")))
        for r in etree.parse("b/word/_rels/document.xml.rels").getroot()
        if r.get("TargetMode") != "External"
    }
    for f in os.listdir("b/word/media"):
        full = os.path.normpath(os.path.join("b/word/media", f))
        if full not in targets:
            os.remove(full)

    if os.path.exists(out_docx):
        os.remove(out_docx)
    with zipfile.ZipFile(out_docx, "w", zipfile.ZIP_DEFLATED) as z:
        z.write("b/[Content_Types].xml", "[Content_Types].xml")
        for root, dirs, files in os.walk("b"):
            dirs[:] = [d for d in dirs if not d.startswith(".")]
            for f in files:
                full = os.path.join(root, f)
                arc = os.path.relpath(full, "b")
                if arc != "[Content_Types].xml":
                    z.write(full, arc)
    print(
        "written",
        out_docx,
        "| cover",
        len(cover_x),
        "| sec21",
        len(sec21_x),
        "| double-dot fixes",
        n_dot,
        "| imported rels",
        len(remap),
    )


if __name__ == "__main__":
    if len(sys.argv) != 3:
        sys.exit(__doc__)
    main(sys.argv[1], sys.argv[2])
