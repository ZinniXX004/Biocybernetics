"""In-place edits of the A4 report (session 3).

Keeps the cover, Section 2.1 and every manual edit (screenshots, extra
figure). Changes: listings from the current code, the new hover listing,
spacing 0 pt before/after with line spacing 1.15, blank paragraphs as
spacing, captions without the dot after the number, a caption for the extra
System 2 screenshot with the figures renumbered, blue table headers.

Usage (folders of unzipped .docx files):
    python format_in_place.py <current report dir> <build_report.py output dir> <output dir>
The output dir starts as a copy of the current report dir; zip it again with
the member order of the original file.
"""

import copy
import re
import sys

from lxml import etree

W = "http://schemas.openxmlformats.org/wordprocessingml/2006/main"
M = "http://schemas.openxmlformats.org/officeDocument/2006/math"


def q(t):
    p, n = t.split(":")
    return "{%s}%s" % ({"w": W, "m": M}[p], n)


def tx(e):
    return "".join(x.text or "" for x in e.iter(q("w:t")))


def style(p):
    s = p.find(q("w:pPr") + "/" + q("w:pStyle"))
    return "" if s is None else s.get(q("w:val"))


def is_listing(e):
    return e.tag == q("w:tbl") and re.match(
        r"\s*\d+\s+(function|procedure) ", tx(e.find(q("w:tr")))
    )


def listing_key(e):
    return re.match(
        r"\s*\d+\s+((?:function|procedure) [\w.]+)", tx(e.find(q("w:tr")))
    ).group(1)


def is_empty_p(e):
    return (
        e.tag == q("w:p")
        and not tx(e).strip()
        and e.find(".//" + q("w:drawing")) is None
        and e.find(".//" + q("m:oMath")) is None
    )


def has_img(e):
    return e.tag == q("w:p") and e.find(".//" + q("w:drawing")) is not None


SRC, BUILT, OUT = sys.argv[1], sys.argv[2], sys.argv[3]
parser = etree.XMLParser(remove_blank_text=False, huge_tree=True)
doc = etree.parse(SRC + "/word/document.xml", parser)
body = doc.getroot().find(q("w:body"))
bdoc = etree.parse(BUILT + "/word/document.xml", parser)
bbody = list(bdoc.getroot().find(q("w:body")))

els = list(body)
i_c1 = next(i for i, e in enumerate(els) if tx(e) == "CHAPTER I. FUNDAMENTAL THEORY")
i_21 = next(i for i, e in enumerate(els) if tx(e).startswith("2.1 Problems Statement"))
i_22 = next(i for i, e in enumerate(els) if tx(e).startswith("2.2 Answer and Code"))
mine = set(els[i_c1:i_21]) | set(e for e in els[i_22:] if e.tag != q("w:sectPr"))
print("own elements", len(mine))

# 1. Listings: replace by the build from the current code.
built = {listing_key(e): e for e in bbody if is_listing(e)}
n = 0
for e in list(body):
    if is_listing(e):
        new = copy.deepcopy(built[listing_key(e)])
        e.addprevious(new)
        body.remove(e)
        mine.discard(e)
        mine.add(new)
        n += 1
print("listings replaced", n)

# 2. New hover paragraph and listing after the btnP1SimulateClick listing.
bi = next(
    i for i, e in enumerate(bbody) if tx(e).startswith("All charts share one hover")
)
new_p, new_t = copy.deepcopy(bbody[bi]), copy.deepcopy(bbody[bi + 1])
assert is_listing(new_t) and listing_key(new_t) == "procedure TChart.MouseMove"
anchor = next(
    e
    for e in body
    if is_listing(e) and listing_key(e) == "procedure TForm1.btnP1SimulateClick"
)
anchor.addnext(new_p)
new_p.addnext(new_t)
mine |= {new_p, new_t}


# 3. Captions: no dot after the number, renumber figures after Figure 2.1.
def renum(m):
    return f"{m.group(1)}2.{int(m.group(2)) + 1}"


for e in body:
    if e not in mine or e.tag != q("w:p"):
        continue
    for t in e.iter(q("w:t")):
        s = t.text or ""
        s2 = re.sub(r"(Figures? )2\.([2-6])(?![\d])", renum, s)
        if s2 != s:
            s2 = re.sub(r"( and )2\.([2-6])(?=[a-d])", renum, s2)
        t.text = s2
caps = 0
for e in body:
    if e in mine and e.tag == q("w:p") and style(e) == "CaptionText":
        t = next(iter(e.iter(q("w:t"))), None)
        if t is not None and re.match(r"(Figure|Table) \d+\.\d+\. ", t.text or ""):
            t.text = re.sub(r"^((?:Figure|Table) \d+\.\d+)\. ", r"\1 ", t.text)
            caps += 1
print("captions without dot", caps)

# 4. Caption for the extra System 2 screenshot and a text reference.
cap21 = next(
    e
    for e in body
    if e.tag == q("w:p") and tx(e).startswith("Figure 2.1 Problem 1 tab, system 1")
)
img2 = cap21.getnext()
assert has_img(img2) and not tx(img2).strip(), "extra screenshot not below Figure 2.1"
img1 = cap21.getprevious()
assert has_img(img1)
ppr = img2.find(q("w:pPr"))
ppr.getparent().replace(ppr, copy.deepcopy(img1.find(q("w:pPr"))))
cap22 = copy.deepcopy(cap21)
t0 = next(iter(cap22.iter(q("w:t"))))
assert t0.text.startswith("Figure 2.1 Problem 1 tab, system 1,")
t0.text = t0.text.replace(
    "Figure 2.1 Problem 1 tab, system 1,", "Figure 2.2 Problem 1 tab, system 2,"
)
img2.addnext(cap22)
mine |= {cap22}
hit = 0
for e in body:
    for t in e.iter(q("w:t")):
        if "For system 2 the program gives" in (t.text or ""):
            t.text = t.text.replace(
                "For system 2 the program gives",
                "For system 2 (Figure 2.2) the program gives",
            )
            hit += 1
assert hit == 1


# 5. Spacers between listings become ordinary blank paragraphs; direct
#    before/after spacing of my paragraphs is removed.
def blank():
    p = etree.Element(q("w:p"))
    ppr = etree.SubElement(p, q("w:pPr"))
    etree.SubElement(ppr, q("w:pStyle")).set(q("w:val"), "BodyText6")
    return p


for e in list(body):
    if e not in mine or e.tag != q("w:p"):
        continue
    sp = e.find(q("w:pPr") + "/" + q("w:spacing"))
    if is_empty_p(e) and sp is not None and sp.get(q("w:lineRule")) == "exact":
        nb = blank()
        e.addprevious(nb)
        body.remove(e)
        mine.discard(e)
        mine.add(nb)
    elif sp is not None:
        sp.getparent().remove(sp)


# 6. Blank paragraphs as spacing.
def kind(e):
    if e.tag == q("w:tbl"):
        return "listing" if is_listing(e) else "table"
    if e.tag != q("w:p"):
        return "other"
    st = style(e)
    if st.startswith("Heading"):
        return st
    if is_empty_p(e):
        return "empty"
    if st == "CaptionText":
        return "figcap" if tx(e).startswith("Figure") else "tabcap"
    if has_img(e):
        return "img"
    return "text"


added = 0
els = list(body)
for i, e in enumerate(els):
    if e not in mine:
        continue
    k = kind(e)
    prev = els[i - 1] if i else None
    nxt = els[i + 1] if i + 1 < len(els) else None
    kp = kind(prev) if prev is not None else "other"
    kn = kind(nxt) if nxt is not None else "other"
    before = after = False
    if k in ("Heading2", "Heading3") and not kp.startswith("Heading") and kp != "empty":
        before = True
    if k == "Heading1" and kn != "empty":
        after = True
    if k in ("img", "tabcap", "listing") and kp in ("text",):
        before = True
    if k in ("figcap", "table", "listing") and kn in ("text", "img", "tabcap"):
        after = True
    if k == "figcap" and kn == "listing":
        after = True
    if before:
        e.addprevious(blank())
        added += 1
    if after:
        e.addnext(blank())
        added += 1
print("blank paragraphs added", added)

doc.write(
    OUT + "/word/document.xml", xml_declaration=True, encoding="UTF-8", standalone=True
)

# 7. Styles: 0 pt before/after, line spacing 1.15 for my styles; blue header.
sdoc = etree.parse(SRC + "/word/styles.xml", parser)
sroot = sdoc.getroot()
targets = {
    "FirstParagraph",
    "BodyText",
    "BodyText1",
    "BodyText2",
    "BodyText3",
    "BodyText4",
    "BodyText5",
    "BodyText6",
    "Compact",
    "CaptionText",
    "HighlightedEquation",
    "Reference",
    "Heading1",
    "Heading2",
    "Heading3",
    "Figure",
}
done = set()
for s in sroot.iter(q("w:style")):
    sid = s.get(q("w:styleId"))
    if sid in targets:
        ppr = s.find(q("w:pPr"))
        if ppr is None:
            ppr = etree.SubElement(s, q("w:pPr"))
        sp = ppr.find(q("w:spacing"))
        if sp is None:
            sp = etree.Element(q("w:spacing"))
            order = [
                "w:keepNext",
                "w:keepLines",
                "w:pageBreakBefore",
                "w:widowControl",
                "w:numPr",
                "w:pBdr",
                "w:shd",
                "w:tabs",
                "w:wordWrap",
            ]
            last = None
            for c in ppr:
                if c.tag in [q(o) for o in order]:
                    last = c
            if last is None:
                ppr.insert(0, sp)
            else:
                last.addnext(sp)
        for a in list(sp.attrib):
            del sp.attrib[a]
        sp.set(q("w:before"), "0")
        sp.set(q("w:after"), "0")
        sp.set(q("w:line"), "276")
        sp.set(q("w:lineRule"), "auto")
        done.add(sid)
    if sid == "Table":
        pp = s.find(q("w:pPr") + "/" + q("w:spacing"))
        if pp is not None:
            pp.set(q("w:before"), "0")
            pp.set(q("w:after"), "0")
        shd = s.find(".//" + q("w:tblStylePr") + "/" + q("w:tcPr") + "/" + q("w:shd"))
        shd.set(q("w:fill"), "BDD7EE")
        done.add("Table header")
print("styles", sorted(done))
sdoc.write(
    OUT + "/word/styles.xml", xml_declaration=True, encoding="UTF-8", standalone=True
)
