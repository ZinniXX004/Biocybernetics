"""Post-processing of the A3 report in Word format.

box_code(body)       puts every code listing (paragraph style SourceCode) of
                     Sections 2.2 onwards into a table of one column and one
                     row, so each listing has a frame of its own.
fill_references(body, entries)
                     replaces the paragraph "REFS" of the References chapter
                     by one IEEE entry per paragraph (style Reference).
set_sec21_code(body, marker, lines)
                     replaces the code lines that follow an answer label of
                     Section 2.1 (the label paragraph itself is kept).

Used by build_report.py and, for a report already edited in Word, by
fix_report.py, which changes nothing else in the document.
"""

import copy
import re

W = "http://schemas.openxmlformats.org/wordprocessingml/2006/main"
TEXT_WIDTH = 9026  # A4 with 2.54 cm margins, in twentieths of a point


def q(tag):
    pre, name = tag.split(":")
    return "{%s}%s" % (W, name)


def text_of(el):
    return "".join(t.text or "" for t in el.iter(q("w:t")))


def style_of(p):
    ppr = p.find(q("w:pPr"))
    st = ppr.find(q("w:pStyle")) if ppr is not None else None
    return st.get(q("w:val")) if st is not None else ""


def sub(parent, tag, **attrs):
    el = parent.makeelement(q(tag), {})
    for k, v in attrs.items():
        el.set(q("w:" + k), str(v))
    parent.append(el)
    return el


def _code_table(body, para):
    tbl = body.makeelement(q("w:tbl"), {})
    tpr = sub(tbl, "w:tblPr")
    sub(tpr, "w:tblW", w=TEXT_WIDTH, type="dxa")
    sub(tpr, "w:jc", val="center")
    borders = sub(tpr, "w:tblBorders")
    for side in ("top", "left", "bottom", "right"):
        sub(borders, "w:" + side, val="single", sz=6, space=0, color="8C8C8C")
    sub(tpr, "w:tblLayout", type="fixed")
    mar = sub(tpr, "w:tblCellMar")
    sub(mar, "w:top", w=57, type="dxa")
    sub(mar, "w:left", w=85, type="dxa")
    sub(mar, "w:bottom", w=57, type="dxa")
    sub(mar, "w:right", w=85, type="dxa")
    sub(
        tpr,
        "w:tblLook",
        val="0000",
        firstRow=0,
        lastRow=0,
        firstColumn=0,
        lastColumn=0,
        noHBand=1,
        noVBand=1,
    )
    grid = sub(tbl, "w:tblGrid")
    sub(grid, "w:gridCol", w=TEXT_WIDTH)
    tr = sub(tbl, "w:tr")
    tc = sub(tr, "w:tc")
    tcpr = sub(tc, "w:tcPr")
    sub(tcpr, "w:tcW", w=TEXT_WIDTH, type="dxa")
    sub(tcpr, "w:shd", val="clear", color="auto", fill="F4F4F4")
    # inside the frame the paragraph needs no indent of its own
    ppr = para.find(q("w:pPr"))
    if ppr is None:
        ppr = para.makeelement(q("w:pPr"), {})
        para.insert(0, ppr)
    ind = ppr.find(q("w:ind"))
    if ind is None:
        ind = ppr.makeelement(q("w:ind"), {})
        st = ppr.find(q("w:pStyle"))
        (st.addnext(ind) if st is not None else ppr.insert(0, ind))
    ind.set(q("w:left"), "0")
    ind.set(q("w:right"), "0")
    tc.append(para)
    return tbl


def _spacer(body):
    """Empty 2 pt paragraph between two frames, so Word keeps them apart."""
    p = body.makeelement(q("w:p"), {})
    ppr = sub(p, "w:pPr")
    sub(ppr, "w:spacing", before=0, after=0, line=80, lineRule="exact")
    rpr = sub(ppr, "w:rPr")
    sub(rpr, "w:sz", val=4)
    return p


def box_code(body, start_heading="2.2 Answer and Code Explanation"):
    children = list(body)
    start = next(
        i
        for i, c in enumerate(children)
        if c.tag == q("w:p") and text_of(c).startswith(start_heading)
    )
    n = 0
    for i in range(start, len(children)):
        el = children[i]
        if el.tag != q("w:p") or style_of(el) != "SourceCode":
            continue
        pos = list(body).index(el)
        body.remove(el)
        body.insert(pos, _code_table(body, el))
        nxt = el.getparent().getparent().getparent().getnext()
        if nxt is not None and nxt.tag == q("w:p") and style_of(nxt) == "SourceCode":
            nxt.addprevious(_spacer(body))
        n += 1
    return n


def _runs(p, text):
    """Text with _italic_ parts as runs of paragraph p."""
    for k, part in enumerate(re.split(r"_(.+?)_", text)):
        if not part:
            continue
        r = sub(p, "w:r")
        if k % 2 == 1:
            rpr = sub(r, "w:rPr")
            sub(rpr, "w:i")
        segs = part.split("\t")
        for j, seg in enumerate(segs):
            if j:
                sub(r, "w:tab")
            t = sub(r, "w:t")
            t.text = seg
            t.set("{http://www.w3.org/XML/1998/namespace}space", "preserve")


def fill_references(body, entries):
    holder = next(
        (c for c in body if c.tag == q("w:p") and text_of(c).strip() == "REFS"), None
    )
    if holder is None:
        raise SystemExit("paragraph REFS not found")
    for k, entry in enumerate(entries):
        p = copy.deepcopy(holder)
        for r in p.findall(q("w:r")):
            p.remove(r)
        _runs(p, f"[{k + 1}]\t{entry}")
        holder.addprevious(p)
    body.remove(holder)
    return len(entries)


def _is_code_line(p):
    fonts = [
        f.get(q("w:ascii")) for r in p.findall(q("w:r")) for f in r.iter(q("w:rFonts"))
    ]
    return bool(fonts) and all(f == "Consolas" for f in fonts)


def set_sec21_code(body, marker, lines):
    """The code paragraphs after a label are the paragraphs up to the next
    paragraph whose runs are not Consolas."""
    children = list(body)
    label = next(
        c for c in children if c.tag == q("w:p") and text_of(c).startswith(marker)
    )
    old = []
    el = label.getnext()
    while el is not None and el.tag == q("w:p") and _is_code_line(el):
        old.append(el)
        el = el.getnext()
    if not old:
        raise SystemExit("no code lines after " + marker)
    template = old[0]
    last_spacing = old[-1].find(q("w:pPr")).find(q("w:spacing"))
    after = last_spacing.get(q("w:after")) if last_spacing is not None else "0"
    for o in old:
        body.remove(o)
    pos = label
    for k, line in enumerate(lines):
        p = copy.deepcopy(template)
        for r in p.findall(q("w:r")):
            p.remove(r)
        sp = p.find(q("w:pPr")).find(q("w:spacing"))
        if sp is not None:
            sp.set(q("w:after"), after if k == len(lines) - 1 else "0")
        rtemp = template.find(q("w:r"))
        r = copy.deepcopy(rtemp)
        for t in r.findall(q("w:t")):
            r.remove(t)
        t = sub(r, "w:t")
        t.text = line if line else " "
        t.set("{http://www.w3.org/XML/1998/namespace}space", "preserve")
        p.append(r)
        pos.addnext(p)
        pos = p
    return len(old), len(lines)
