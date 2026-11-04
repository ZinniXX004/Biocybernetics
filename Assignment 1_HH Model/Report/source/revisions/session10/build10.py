"""Session 10 revision of the student's edited report.

1. Code listings: every line carries its line number in the source file;
   routines of HHModel.pas and EquationViewer.pas stay complete, routines
   of the form (Unit1.pas) that mostly fill tables and memos are shortened,
   each omitted range is replaced by one comment naming the line range.
2. Code font 8 pt (the token styles were 10.5 pt), less space after a
   listing.
3. Section 2.2.1: the sentence on complete listings is replaced, and one
   paragraph plus a short excerpt of Unit1.dfm describe the design-time
   form (charts, series, parameter tables).
Everything else (text, figures, the student's own edits) is copied
unchanged.

Run next to an unzipped copy of the report (user.docx, folder u/) with the
sources in ../ (Unit1.pas, HHModel.pas, EquationViewer.pas, d10/Unit1.dfm).
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
import schemafix  # noqa: E402

W = "http://schemas.openxmlformats.org/wordprocessingml/2006/main"
XML_SPACE = "{http://www.w3.org/XML/1998/namespace}space"
SOURCES = {
    "HHModel": "../HHModel.pas",
    "Unit1": "../Unit1.pas",
    "EquationViewer": "../EquationViewer.pas",
}
DFM = "../d10/Unit1.dfm"


def q(tag):
    return "{%s}%s" % (W, tag)


def text_of(el):
    return "".join(el.itertext())


LINES = {
    u: open(p, encoding="utf-8").read().replace("\r\n", "\n").split("\n")
    for u, p in SOURCES.items()
}

# Omitted ranges of the form routines: (first line, last line, note). A line
# is given by its text (stripped of trailing blanks); a tuple means "the
# first line equal to the second text after the first one".
OMIT = {
    "TForm1.BuildAPGStimulus": [
        (
            "AStim.JBase := ParamValue(vleAPG, K_JBASE);",
            "AStim.Interval := ParamValue(vleAPG, K_PINT);",
            "J base, t_on, J1, J2, width, interval",
        ),
    ],
    "TForm1.PlotAPG": [
        (
            "serJin.AddXY(FAPG.T[LIdx], FAPG.Jin[LIdx]);",
            "serGK.AddXY(FAPG.T[LIdx], FAPG.GK[LIdx]);",
            "the other nine series in the same way",
        ),
        (
            "FinishChart(chtCurrents);",
            "FinishChart(chtConductance);",
            "FinishChart of the other charts",
        ),
    ],
    "TForm1.PlotPhase": [
        (
            "// Phase plots in the style of the senior reference (gate vs Vm), with the",
            "ClearChart(chtTau);",
            "comment, ClearChart of the four charts",
        ),
        (
            "serInfH.AddXY(LVm, LRates.Ah / (LRates.Ah + LRates.Bh));",
            "serTauN.AddXY(LVm, 1.0 / (LRates.An + LRates.Bn));",
            "h_inf, n_inf, tau_m, tau_h, tau_n alike",
        ),
        (
            "FinishChart(chtPhaseM);",
            "FinishChart(chtTau);",
            "FinishChart of the four charts",
        ),
    ],
    "TForm1.ReportAPG": [
        (
            "LLines := memAPG.Lines;",
            "FloatText(FAPG.SpikeTimes[LIdx] - FAPG.SpikeTimes[LIdx - 1], 2)]));",
            "memo header and spike table",
        ),
        (
            "if AStim.Kind = skPairedPulse then",
            ("LLines.EndUpdate;", "end;"),
            "paired-pulse note, EndUpdate",
        ),
    ],
    "TForm1.btnRunRefClick": [
        (
            "LJ1 := ParamValue(vleRef, K_RJ1);",
            "LDt := ParamValue(vleRef, K_DT);",
            "read parameters from vleRef",
        ),
        (
            "ClearChart(chtRefThreshold);",
            "FinishChart(chtRefThreshold);",
            "plot serRefThr, serRefBase, serRefPeak",
        ),
        (
            "LLines := memRef.Lines;",
            ("LLines.EndUpdate;", "end;"),
            "memo: refractory phases and table",
        ),
    ],
    "TForm1.RunRefExample": [
        ("var", "end;", "PlotTrace: Vm(t) into FRefExSeries[ASlot]"),
        (
            "LJ1 := ParamValue(vleRef, K_RJ1);",
            "LDt := ParamValue(vleRef, K_DT);",
            "read parameters from vleRef",
        ),
        (
            "SetStatus(Format('Interval %s ms: test-pulse threshold = %s uA/cm2',",
            "end;",
            "status; absolute refractory hides series 3",
        ),
    ],
    "TForm1.btnRunISIClick": [
        (
            "LJ0 := ParamValue(vleISI, K_IJ0);",
            "LDt := ParamValue(vleISI, K_DT);",
            "read parameters from vleISI",
        ),
        (
            "ClearChart(chtISI);",
            "FinishChart(chtISITraces);",
            "plot ISI, f and three example trains",
        ),
        (
            "LLines := memISI.Lines;",
            ("LLines.EndUpdate;", "end;"),
            "memo: firing onset, block, table",
        ),
    ],
    "TForm1.FillAPPEditor": [
        (
            "AddParam(vleAPP, K_CA, ACable.RadiusUm);",
            "AddParam(vleAPP, K_CSL, RoundTo(ACable.StimLengthCm * C_MM_PER_CM, -6));",
            "rows a, Ri, ro, length, h, k, T, Jin, duration",
        ),
    ],
    "TForm1.btnRunAPPClick": [
        (
            "LCable.RadiusUm := ParamValue(vleAPP, K_CA);",
            "LCable.GmPassive := ParamValue(vleAPP, K_CGM);",
            "read cable parameters (mm to cm)",
        ),
    ],
    "TForm1.PlotCable": [
        (
            "for LIdx := 0 to C_MAX_SITES - 1 do",
            "end;",
            "show only the first ASites series",
        ),
    ],
    "TForm1.ReportCable": [
        (
            "LLines.Clear;",
            "LLines.Add('');",
            "memo: mode, scheme, D, r, lambda, velocity",
        ),
    ],
}


def find_routine(name):
    pat = re.compile(
        r"^(procedure|function|constructor|destructor)\s+" + re.escape(name) + r"\b"
    )
    for unit, lines in LINES.items():
        impl = next(i for i, ln in enumerate(lines) if ln.strip() == "implementation")
        for i in range(impl, len(lines)):
            if pat.match(lines[i]):
                end = next(j for j in range(i + 1, len(lines)) if lines[j] == "end;")
                return unit, i, end
    raise KeyError(name)


def numbered(name):
    """[(line number or None, text)] of a routine, with omissions."""
    unit, start, end = find_routine(name)
    lines = LINES[unit]
    rows = [(k + 1, lines[k].rstrip()) for k in range(start, end + 1)]
    for first, last, note in OMIT.get(name, []):
        i = next(k for k, (n, t) in enumerate(rows) if n and t.strip() == first)
        if isinstance(last, tuple):
            j = next(k for k in range(i, len(rows)) if rows[k][1].strip() == last[0])
            j = next(
                k for k in range(j + 1, len(rows)) if rows[k][1].strip() == last[1]
            )
        else:
            j = next(k for k in range(i, len(rows)) if rows[k][1].strip() == last)
        indent = re.match(r"\s*", rows[i][1]).group(0)
        a, b = rows[i][0], rows[j][0]
        rows[i : j + 1] = [(None, f"{indent}{{ lines {a}-{b} omitted: {note} }}")]
    return rows


def listing_name(first_line):
    m = re.match(
        r"^(?:procedure|function|constructor|destructor)\s+([\w.]+)", first_line
    )
    return m.group(1) if m else None


# 1. load the student's document
parser = etree.XMLParser(huge_tree=True)
doc = etree.parse("u/word/document.xml", parser)
body = doc.getroot().find(q("body"))
paras = list(body.iter(q("p")))


def is_code(p):
    sty = p.find(q("pPr") + "/" + q("pStyle"))
    if sty is not None and sty.get(q("val")) == "SourceCode":
        return True
    return any(
        (
            r.find(q("rPr") + "/" + q("rStyle")) is not None
            and r.find(q("rPr") + "/" + q("rStyle")).get(q("val")).endswith("Tok")
        )
        for r in p.findall(q("r"))[:3]
    )


targets = []
for p in paras:
    if is_code(p):
        first = text_of(p).split("\n")[0]
        # the paragraph text has no newlines (lines are w:br); take the header
        name = listing_name(first)
        if name:
            targets.append((p, name))

# 2. one pandoc run for all listings (+ the DFM excerpt)
md = []
for k, (_, name) in enumerate(targets):
    rows = numbered(name)
    md.append(
        f"@@FRAG {k}@@\n\n```pascal\n" + "\n".join(t for _, t in rows) + "\n```\n"
    )

dfm = open(DFM, encoding="utf-8").read().replace("\r\n", "\n").split("\n")
s = next(i for i, ln in enumerate(dfm) if ln.strip() == "object chtVm: TChart")
e = next(
    i
    for i in range(s, len(dfm))
    if dfm[i] == dfm[s].replace("object chtVm: TChart", "end")
)
keep_keys = (
    "object ",
    "end",
    "Legend.Alignment",
    "Legend.CheckBoxes",
    "Legend.LegendStyle",
    "Title.Text.Strings",
    "'",
    "BottomAxis.Title.Caption",
    "LeftAxis.Title.Caption",
    "RightAxis.Title.Caption",
    "View3D",
    "OnZoom",
    "OnMouseMove",
    "SeriesColor",
    "Title = ",
    "LinePen.Width",
    "VertAxis",
)
excerpt, skipped = [], False
base = len(dfm[s]) - len(dfm[s].lstrip())
for ln in dfm[s : e + 1]:
    t = ln[base:]
    if t.strip().startswith(keep_keys):
        excerpt.append(t)
        skipped = False
    elif not skipped:
        excerpt.append(" " * (len(t) - len(t.lstrip())) + "...")
        skipped = True
DFM_FRAG = len(targets)
md.append(f"@@FRAG {DFM_FRAG}@@\n\n```\n" + "\n".join(excerpt) + "\n```\n")
md.append("@@FRAG END@@\n")
text = "\n".join(md)
for bad in ("–", "—"):
    assert bad not in text
open("frag10.md", "w", encoding="utf-8").write(text)
subprocess.run(
    [
        "pandoc",
        "frag10.md",
        "-o",
        "frag10.docx",
        "--reference-doc=user.docx",
        "--highlight-style=tango",
    ],
    check=True,
)
shutil.rmtree("f10", ignore_errors=True)
with zipfile.ZipFile("frag10.docx") as z:
    z.extractall("f10")
fbody = etree.parse("f10/word/document.xml", parser).getroot().find(q("body"))
frags, cur = {}, None
for el in fbody:
    if el.tag == q("sectPr"):
        continue
    t = text_of(el).strip() if el.tag == q("p") else ""
    m = re.match(r"^@@FRAG (\d+)@@$", t)
    if m:
        cur = int(m.group(1))
        frags[cur] = []
    elif t == "@@FRAG END@@":
        cur = None
    elif cur is not None:
        frags[cur].append(el)


def number_run(label):
    r = etree.Element(q("r"))
    rpr = etree.SubElement(r, q("rPr"))
    etree.SubElement(rpr, q("rStyle")).set(q("val"), "VerbatimChar")
    etree.SubElement(rpr, q("color")).set(q("val"), "8C8C8C")
    etree.SubElement(rpr, q("sz")).set(q("val"), "16")
    etree.SubElement(rpr, q("szCs")).set(q("val"), "16")
    t = etree.SubElement(r, q("t"))
    t.set(XML_SPACE, "preserve")
    t.text = label
    return r


def add_numbers(par, numbers):
    """Insert a grey line-number run at the start of every line of par."""
    width = max(len(str(n)) for n in numbers if n is not None)
    runs = [c for c in par if c.tag == q("r")]
    starts = [runs[0]] if runs else []
    for r in runs:
        if r.find(q("br")) is not None:
            starts.append(("after", r))
    assert len(starts) == len(numbers), (len(starts), len(numbers))
    for anchor, n in zip(starts, numbers):
        label = (str(n).rjust(width) if n is not None else " " * width) + "  "
        if isinstance(anchor, tuple):
            anchor[1].addnext(number_run(label))
        else:
            anchor.addprevious(number_run(label))


def small_plain_runs(par):
    """Runs of a listing without a token style (plain text) get 8 pt."""
    for r in par.findall(q("r")):
        rpr = r.find(q("rPr"))
        sty = rpr.find(q("rStyle")) if rpr is not None else None
        if sty is not None and sty.get(q("val")).endswith("Tok"):
            continue
        if rpr is None:
            rpr = etree.Element(q("rPr"))
            r.insert(0, rpr)
        if rpr.find(q("sz")) is None:
            etree.SubElement(rpr, q("sz")).set(q("val"), "16")
            etree.SubElement(rpr, q("szCs")).set(q("val"), "16")


def replace_listing(old, new_el):
    old_ppr = old.find(q("pPr"))
    new_ppr = new_el.find(q("pPr"))
    if new_ppr is not None:
        new_el.remove(new_ppr)
    if old_ppr is not None:
        new_el.insert(0, copy.deepcopy(old_ppr))
    old.addprevious(new_el)
    old.getparent().remove(old)


for k, (old, name) in enumerate(targets):
    els = [copy.deepcopy(e) for e in frags[k]]
    assert len(els) == 1, name
    numbers = [n for n, _ in numbered(name)]
    add_numbers(els[0], numbers)
    small_plain_runs(els[0])
    replace_listing(old, els[0])

# 3. section 2.2.1: replace the sentence on complete listings, add the form
OLD_SENT = "All routines listed below are complete and are presented in the order"
p80 = next(p for p in body.iter(q("p")) if OLD_SENT in text_of(p))
runs = p80.findall(q("r"))
full = "".join(text_of(r) for r in runs)
cut = full.index(OLD_SENT)
new_tail = (
    "The listings below follow the order of the problems in Section 2.1 and, within each problem, the order of the source files. Every line carries its line number in the source file. The numerical routines of HHModel.pas are complete, while in the routines of the form the lines that only read parameters, fill memos or repeat a statement for further series are replaced by one comment that names the omitted line range."
)
first_rpr = runs[0].find(q("rPr"))
for r in runs:
    p80.remove(r)
r = etree.SubElement(p80, q("r"))
if first_rpr is not None:
    r.append(copy.deepcopy(first_rpr))
t = etree.SubElement(r, q("t"))
t.set(XML_SPACE, "preserve")
t.text = full[:cut] + new_tail

FORM_TEXT = (
    "All visual elements of the main window are defined at design time in the form file Unit1.dfm, so they can be inspected in the Form Designer of Delphi before the program is compiled. The fourteen TeeChart charts are two-dimensional (View3D = False) and carry their titles, axis titles with units, grid, a legend with check boxes at the bottom and their 48 series (TFastLineSeries, TLineSeries and TPointSeries) in the Okabe-Ito and viridis colours of the program; the parameter tables (TValueListEditor) hold their keys and default values, and tab 6 holds the rendered equations. At run time the code only fills the series with the computed points (for example serVm.AddXY in PlotAPG), sets the titles that depend on a run (recording positions and instants in tab 5) and hides unused series; no series is created or freed while the program runs, which also removes the cause of the access violation recorded as ISS-020. The excerpt below shows the membrane-potential chart of tab 1 in Unit1.dfm (font, grid and position properties are omitted)."
)
new_p = copy.deepcopy(p80)
for r in new_p.findall(q("r")):
    new_p.remove(r)
r = etree.SubElement(new_p, q("r"))
if first_rpr is not None:
    r.append(copy.deepcopy(first_rpr))
t = etree.SubElement(r, q("t"))
t.set(XML_SPACE, "preserve")
t.text = FORM_TEXT
p80.addnext(new_p)
dfm_el = copy.deepcopy(frags[DFM_FRAG][0])
code_ppr = targets[0][0]  # removed already; take the pPr of any listing
sample = next(p for p in body.iter(q("p")) if is_code(p))
dppr = dfm_el.find(q("pPr"))
if dppr is not None:
    dfm_el.remove(dppr)
dfm_el.insert(0, copy.deepcopy(sample.find(q("pPr"))))
small_plain_runs(dfm_el)
new_p.addnext(dfm_el)

schemafix.schema_fix(doc.getroot())
schemafix.drop_empty_separators(doc.getroot())
doc.write(
    "u/word/document.xml", xml_declaration=True, encoding="UTF-8", standalone=True
)

# 4. styles: code at 8 pt, 3 pt after a listing
styles = open("u/word/styles.xml", encoding="utf-8").read()


def shrink(match):
    block = match.group(0)
    block = re.sub(r'<w:sz w:val="\d+"/>', '<w:sz w:val="16"/>', block)
    return re.sub(r'<w:szCs w:val="\d+"/>', '<w:szCs w:val="16"/>', block)


styles = re.sub(
    r'<w:style w:type="character"[^>]*w:styleId="(\w+Tok)".*?</w:style>',
    shrink,
    styles,
    flags=re.S,
)
styles = styles.replace(
    '<w:spacing w:before="60" w:line="240" w:lineRule="auto"/><w:ind w:left="113" w:right="113"/>',
    '<w:spacing w:before="60" w:after="60" w:line="240" w:lineRule="auto"/><w:ind w:left="113" w:right="113"/>',
    1,
)
open("u/word/styles.xml", "w", encoding="utf-8").write(styles)

OUT = "report10.docx"
if os.path.exists(OUT):
    os.remove(OUT)
with (
    zipfile.ZipFile("user.docx") as zin,
    zipfile.ZipFile(OUT, "w", zipfile.ZIP_DEFLATED) as zout,
):
    for item in zin.infolist():
        if item.filename in ("word/document.xml", "word/styles.xml"):
            data = open(os.path.join("u", item.filename), "rb").read()
        else:
            data = zin.read(item.filename)
        zout.writestr(item, data)
print("listings", len(targets), "written", OUT)
