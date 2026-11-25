"""Session 4 patch of the A4 report: listings from the current code and two
new paragraphs (pulse convention, pole chart view). Everything else in the
report stays as the student left it.

Usage (folders of unzipped .docx files):
    python patch_session4.py <current report dir> <build_report.py output dir> <output dir>
"""

import copy
import re
import sys

from lxml import etree

W = "http://schemas.openxmlformats.org/wordprocessingml/2006/main"


def q(n):
    return "{%s}%s" % (W, n)


def tx(e):
    return "".join(x.text or "" for x in e.iter(q("t")))


def is_listing(e):
    return e.tag == q("tbl") and re.match(
        r"\s*\d+\s+(function|procedure) ", tx(e.find(q("tr")))
    )


def key(e):
    return re.match(
        r"\s*\d+\s+((?:function|procedure) [\w.]+)", tx(e.find(q("tr")))
    ).group(1)


def blank():
    p = etree.Element(q("p"))
    ppr = etree.SubElement(p, q("pPr"))
    etree.SubElement(ppr, q("pStyle")).set(q("val"), "BodyText6")
    return p


SRC, BUILT, OUT = sys.argv[1:4]
parser = etree.XMLParser(huge_tree=True)
doc = etree.parse(SRC + "/word/document.xml", parser)
body = doc.getroot().find(q("body"))
built = list(
    etree.parse(BUILT + "/word/document.xml", parser).getroot().find(q("body"))
)

new = {key(e): e for e in built if is_listing(e)}
n = 0
for e in list(body):
    if is_listing(e):
        e.addprevious(copy.deepcopy(new[key(e)]))
        body.remove(e)
        n += 1
print("listings replaced", n)


def harvest(start):
    hits = [e for e in built if e.tag == q("p") and tx(e).startswith(start)]
    assert len(hits) == 1, start
    p = copy.deepcopy(hits[0])
    sp = p.find(q("pPr") + "/" + q("spacing"))
    if sp is not None:
        sp.getparent().remove(sp)
    return p


def anchor(start):
    hits = [e for e in body if e.tag == q("p") and tx(e).startswith(start)]
    assert len(hits) == 1, start
    return hits[0]


for after, start in (
    (
        "The button Step and impulse of the first tab",
        "The check box decides which of the two pulse",
    ),
    ("System 1 has the eigenvalue", "With the check box unticked the same run"),
):
    if any(tx(e).startswith(start) for e in body):
        print("already present:", start[:40])
        continue
    a = anchor(after)
    p = harvest(start)
    ref = anchor("System 1 has the eigenvalue")
    old = p.find(q("pPr"))
    if old is not None:
        p.remove(old)
    p.insert(0, copy.deepcopy(ref.find(q("pPr"))))
    a.addnext(p)
    print("inserted:", start[:40])

doc.write(
    OUT + "/word/document.xml", xml_declaration=True, encoding="UTF-8", standalone=True
)
