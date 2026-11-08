"""Reorder child elements that pandoc (and the build script) emit out of the
order required by the OOXML schema, so the document validates."""

from lxml import etree

W = "http://schemas.openxmlformats.org/wordprocessingml/2006/main"
M = "http://schemas.openxmlformats.org/officeDocument/2006/math"
P_ORDER = [
    "pStyle",
    "keepNext",
    "keepLines",
    "pageBreakBefore",
    "framePr",
    "widowControl",
    "numPr",
    "suppressLineNumbers",
    "pBdr",
    "shd",
    "tabs",
    "suppressAutoHyphens",
    "kinsoku",
    "wordWrap",
    "overflowPunct",
    "topLinePunct",
    "autoSpaceDE",
    "autoSpaceDN",
    "bidi",
    "adjustRightInd",
    "snapToGrid",
    "spacing",
    "ind",
    "contextualSpacing",
    "mirrorIndents",
    "suppressOverlap",
    "jc",
    "textDirection",
    "textAlignment",
    "textboxTightWrap",
    "outlineLvl",
    "divId",
    "cnfStyle",
    "rPr",
    "sectPr",
    "pPrChange",
]
TBL_ORDER = [
    "tblStyle",
    "tblpPr",
    "tblOverlap",
    "bidiVisual",
    "tblStyleRowBandSize",
    "tblStyleColBandSize",
    "tblW",
    "jc",
    "tblCellSpacing",
    "tblInd",
    "tblBorders",
    "shd",
    "tblLayout",
    "tblCellMar",
    "tblLook",
    "tblCaption",
    "tblDescription",
]
D_ORDER = ["begChr", "sepChr", "endChr", "grow", "shp", "ctrlPr"]
MR_ORDER = ["lit", "nor", "scr", "sty", "brk", "aln"]


def reorder(parent, order, ns):
    kids = list(parent)

    def key(e):
        qn = etree.QName(e)
        return (
            order.index(qn.localname)
            if qn.namespace == ns and qn.localname in order
            else len(order)
        )

    ordered = sorted(kids, key=key)  # stable: unknown elements keep their order
    if ordered != kids:
        for k in kids:
            parent.remove(k)
        for k in ordered:
            parent.append(k)


def schema_fix(root):
    for e in root.iter("{%s}pPr" % W):
        reorder(e, P_ORDER, W)
    for e in root.iter("{%s}tblPr" % W):
        reorder(e, TBL_ORDER, W)
    for e in root.iter("{%s}dPr" % M):
        reorder(e, D_ORDER, M)
    for e in root.iter("{%s}rPr" % M):
        # m:nor and m:sty are alternatives in CT_RPR
        if e.find("{%s}nor" % M) is not None:
            for sty in e.findall("{%s}sty" % M):
                e.remove(sty)
        reorder(e, MR_ORDER, M)


def drop_empty_separators(root):
    """m:sepChr with an empty value is redundant for a delimiter with a single
    argument; LibreOffice mis-renders it (brackets drawn as bars)."""
    for dpr in root.iter("{%s}dPr" % M):
        d = dpr.getparent()
        if len(d.findall("{%s}e" % M)) <= 1:
            for sep in dpr.findall("{%s}sepChr" % M):
                if sep.get("{%s}val" % M, "") == "":
                    dpr.remove(sep)
