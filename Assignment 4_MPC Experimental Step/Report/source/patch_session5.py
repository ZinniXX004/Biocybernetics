"""Session 5 patch of the A4 report: Section 2.3.4 rewritten for the
working lecturer program, Table 2.4 replaced, one paragraph added to
Section 2.4 and one sentence added to the conclusion. Everything else in the
report stays as the student left it.

Usage (folders of unzipped .docx files):
    python patch_session5.py <current report dir> <build_report.py output dir> <output dir>
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


SRC, BUILT, OUT = sys.argv[1:4]
parser = etree.XMLParser(huge_tree=True)
doc = etree.parse(SRC + "/word/document.xml", parser)
body = doc.getroot().find(q("body"))
built = list(
    etree.parse(BUILT + "/word/document.xml", parser).getroot().find(q("body"))
)


def one(seq, start, tag="p"):
    hits = [e for e in seq if e.tag == q(tag) and tx(e).startswith(start)]
    assert len(hits) == 1, (start, len(hits))
    return hits[0]


def with_ppr(new, ref):
    new = copy.deepcopy(new)
    old = new.find(q("pPr"))
    if old is not None:
        new.remove(old)
    new.insert(0, copy.deepcopy(ref.find(q("pPr"))))
    return new


def blank():
    p = etree.Element(q("p"))
    ppr = etree.SubElement(p, q("pPr"))
    etree.SubElement(ppr, q("pStyle")).set(q("val"), "BodyText6")
    return p


els = list(body)
# heading
h_old = one(els, "2.3.4 Comparison with the Lecturer")
h_new = one(built, "2.3.4 Comparison with the Lecturer")
for t_old, t_new in zip([h_old], [h_new]):
    texts = list(t_old.iter(q("t")))
    texts[0].text = tx(t_new)
    for t in texts[1:]:
        t.text = ""

# paragraphs of 2.3.4
p_old = one(els, "The simulator MPC.exe of the lecture material")
first_ppr_ref = p_old
body_ppr_ref = one(els, "The bilinear transformation preserved the stability")
starts = [
    "The first copy of the lecturer",
    "The button State Space Model integrates",
    "The button Observer uses",
]
anchor = p_old
for k, s in enumerate(starts):
    new = with_ppr(one(built, s), first_ppr_ref if k == 0 else body_ppr_ref)
    anchor.addnext(new)
    anchor = new
body.remove(p_old)

# caption and table
cap_old = one(list(body), "Table 2.4 Comparison with the lecturer")
cap_new = one(built, "Table 2.4")
texts = list(cap_old.iter(q("t")))
texts[0].text = re.sub(r"^Table 2\.4\.? ", "Table 2.4 ", tx(cap_new))
for t in texts[1:]:
    t.text = ""
tbl_old = cap_old.getnext()
while tbl_old.tag != q("tbl"):
    tbl_old = tbl_old.getnext()
tbl_new = cap_new.getnext()
while tbl_new.tag != q("tbl"):
    tbl_new = tbl_new.getnext()
tbl_old.addprevious(copy.deepcopy(tbl_new))
body.remove(tbl_old)

# new paragraph at the end of 2.4
after = one(list(body), "The Ho-Kalman method recovered the order")
if not any(
    tx(e).startswith("The comparison with the lecturer")
    for e in body
):
    after.addnext(
        with_ppr(
            one(built, "The comparison with the lecturer"),
            body_ppr_ref,
        )
    )

# conclusion paragraph of Problem 2
c_old = one(list(body), "For Problem 2 the step data")
c_new = with_ppr(one(built, "For Problem 2 the step data"), c_old)
c_old.addprevious(c_new)
body.remove(c_old)

doc.write(
    OUT + "/word/document.xml", xml_declaration=True, encoding="UTF-8", standalone=True
)
print("done")
