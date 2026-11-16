"""Applies three changes to a report that was already edited in Word, and
nothing else: (1) the main-program lines of Section 2.1 quote the current
Unit1.pas, (2) every code listing from Section 2.2 on sits in a one-cell
table, (3) the References chapter lists the IEEE entries in the order of
first citation.

Usage (in this folder):
    python fix_report.py "<report>.docx" "<output>.docx"
"""

import re
import sys
import zipfile

from lxml import etree

import build_report as br
import docx_fix as dx


def citation_order():
    md = "".join(
        open(p, encoding="utf-8").read()
        for p in ("report_part1.md", "report_part2.md", "report_part3.md")
    )
    order = []
    for key in re.findall(r"\[@(\w+)\]", md):
        if key not in order:
            order.append(key)
    return order


def main(src, dst):
    zin = zipfile.ZipFile(src)
    root = etree.fromstring(
        zin.read("word/document.xml"), etree.XMLParser(huge_tree=True)
    )
    body = root.find(dx.q("w:body"))
    for marker, lines in br.sec21_snippets():
        if marker.startswith("// main Program"):
            old, new = dx.set_sec21_code(body, marker, lines)
            print(f"2.1 {marker}: {old} lines replaced by {new}")
    print("code tables", dx.box_code(body))
    print(
        "references", dx.fill_references(body, [br.REFS[k] for k in citation_order()])
    )
    data = etree.tostring(root, xml_declaration=True, encoding="UTF-8", standalone=True)
    with zipfile.ZipFile(dst, "w", zipfile.ZIP_DEFLATED) as zout:
        for item in zin.infolist():
            zout.writestr(
                item, data if item.filename == "word/document.xml" else zin.read(item)
            )


if __name__ == "__main__":
    if len(sys.argv) != 3:
        sys.exit(__doc__)
    main(sys.argv[1], sys.argv[2])
