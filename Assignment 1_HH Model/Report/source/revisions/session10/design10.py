"""Session 10: move the visual design of Unit1 from run time into Unit1.dfm.

Input : the device copy of Unit1.dfm (saved by the Delphi 13 IDE, with the
        student's own layout changes), the hh_equations / hh_nomenclature
        PNG files.
Output: Unit1.dfm with
  - every TChart in 2D with its title, axis titles, fonts, grid, legend
    (bottom, check boxes) and design-time series (TFastLineSeries,
    TLineSeries, TPointSeries) in the Okabe-Ito / viridis colours,
  - the chart events (OnMouseMove, OnDblClick, OnZoom, OnScroll,
    OnUndoZoom),
  - the default rows of every TValueListEditor (Parameter / Value),
  - the plain-text model summary in memModelInfo and the rendered
    equation images in imgEquations / imgNomenclature.
Every existing property of the IDE file (positions, sizes, ColWidths,
anchors) is kept unless it is listed here.

Usage: python design10.py <in.dfm> <out.dfm> <hh_equations.png> <hh_nomenclature.png>
"""

import re
import struct
import sys

SRC, DST, PNG_EQ, PNG_NOM = sys.argv[1:5]

# colours (TColor = $00BBGGRR, written in decimal as the IDE does)
BLACK = 0
BLUE = 0x00B27200
VERMILLION = 0x00005ED5
ORANGE = 0x00009FE6
GREEN = 0x00739E00
STIM = 0x00606060
TEXT = 0x00333333
LABEL = 0x00555555
GRID = 0x00E6E6E6

VIRIDIS = [
    (68, 1, 84),
    (72, 40, 120),
    (62, 74, 137),
    (49, 104, 142),
    (38, 130, 142),
    (31, 158, 137),
    (53, 183, 121),
    (109, 205, 89),
    (180, 222, 44),
    (253, 231, 37),
]


def viridis(f):
    """Same interpolation as ViridisColor in Unit1.pas."""
    pos = min(max(f, 0.0), 1.0) * 9.0
    idx = min(8, int(pos))
    frac = pos - idx
    rgb = [
        round(VIRIDIS[idx][k] + frac * (VIRIDIS[idx + 1][k] - VIRIDIS[idx][k]))
        for k in range(3)
    ]
    return rgb[0] | (rgb[1] << 8) | (rgb[2] << 16)


def ordered(i, n):
    """OrderedLineColor of Unit1.pas (viridis without the yellow end)."""
    return viridis(0.0) if n <= 1 else viridis(0.85 * i / (n - 1))


def q(text):
    return "'" + text.replace("'", "''") + "'"


# series: (name, class, title, colour, extra properties)
def fast(name, title, colour, width, right=False, extra=()):
    props = [
        f"SeriesColor = {colour}",
        f"Title = {q(title)}",
        f"LinePen.Color = {colour}",
        f"LinePen.Width = {width}",
    ]
    if right:
        props.append("VertAxis = aRightAxis")
    props += list(extra)
    props += [
        "XValues.Name = 'X'",
        "XValues.Order = loAscending",
        "YValues.Name = 'Y'",
        "YValues.Order = loNone",
    ]
    return name, "TFastLineSeries", props


def line(name, title, colour, width, marked=True, right=False, extra=()):
    props = [
        f"SeriesColor = {colour}",
        f"Title = {q(title)}",
        "Brush.BackColor = clDefault",
        f"LinePen.Width = {width}",
        "Pointer.HorizSize = 3",
        "Pointer.InflateMargins = True",
        "Pointer.Style = psCircle",
        "Pointer.VertSize = 3",
        f"Pointer.Visible = {'True' if marked else 'False'}",
    ]
    if right:
        props.append("VertAxis = aRightAxis")
    props += list(extra)
    props += [
        "XValues.Name = 'X'",
        "XValues.Order = loAscending",
        "YValues.Name = 'Y'",
        "YValues.Order = loNone",
    ]
    return name, "TLineSeries", props


def points(name, title, colour):
    props = [
        f"SeriesColor = {colour}",
        f"Title = {q(title)}",
        "ClickableLine = False",
        "Pointer.HorizSize = 2",
        "Pointer.InflateMargins = True",
        "Pointer.Pen.Visible = False",
        "Pointer.Style = psCircle",
        "Pointer.VertSize = 2",
        "XValues.Name = 'X'",
        "XValues.Order = loAscending",
        "YValues.Name = 'Y'",
        "YValues.Order = loNone",
    ]
    return name, "TPointSeries", props


HIDDEN = ("Active = False", "ShowInLegend = False")
SITES_X = [0.0, 0.4, 0.8, 1.2, 1.6, 2.0]  # lecturer preset, 6 sites
SNAP_T = [8.60, 17.10, 25.70, 34.30, 42.90, 51.40]  # its six snapshot times

site_series = []
snap_series = []
for i in range(8):
    if i < 6:
        site_series.append(
            fast(f"serSite{i + 1}", f"x = {SITES_X[i]:.2f} mm", ordered(i, 6), 1)
        )
        snap_series.append(
            fast(f"serSnap{i + 1}", f"t = {SNAP_T[i]:.2f} ms", ordered(i, 6), 1)
        )
    else:
        site_series.append(
            fast(f"serSite{i + 1}", f"site {i + 1}", ordered(i, 8), 1, extra=HIDDEN)
        )
        snap_series.append(
            fast(f"serSnap{i + 1}", f"snapshot {i + 1}", ordered(i, 8), 1, extra=HIDDEN)
        )

# chart: title, x title, y title, right axis (title, colour) or None,
#        logarithmic left axis, series
CHARTS = {
    "chtVm": (
        "Membrane potential and stimulus",
        "t (ms)",
        "Vm (mV)",
        ("Jin (uA/cm2)", STIM),
        False,
        [
            fast("serVm", "Vm", BLACK, 2),
            fast("serJin", "Jin (right axis)", STIM, 2, right=True),
        ],
    ),
    "chtCurrents": (
        "Ionic current densities (inward positive, HH sign)",
        "t (ms)",
        "JNa, JK (uA/cm2)",
        ("JL (uA/cm2)", GREEN),
        False,
        [
            fast("serJNa", "JNa", VERMILLION, 2),
            fast("serJK", "JK", BLUE, 2),
            fast("serJL", "JL (right axis)", GREEN, 2, right=True),
        ],
    ),
    "chtGates": (
        "Gating variables",
        "t (ms)",
        "m, h, n (-)",
        None,
        False,
        [
            fast("serM", "m (Na activation)", VERMILLION, 2),
            fast("serH", "h (Na inactivation)", ORANGE, 2),
            fast("serN", "n (K activation)", BLUE, 2),
        ],
    ),
    "chtConductance": (
        "Ionic conductances",
        "t (ms)",
        "g (mS/cm2)",
        None,
        False,
        [
            fast("serGNa", "gNa = gNa0 m^3 h", VERMILLION, 2),
            fast("serGK", "gK = gK0 n^4", BLUE, 2),
        ],
    ),
    "chtPhaseM": (
        "Na activation m vs Vm",
        "Vm (mV)",
        "m (-)",
        None,
        False,
        [
            points("serTrajM", "m trajectory (simulation)", VERMILLION),
            fast("serInfM", "m_inf(Vm) steady state", STIM, 2),
        ],
    ),
    "chtPhaseH": (
        "Na inactivation h vs Vm",
        "Vm (mV)",
        "h (-)",
        None,
        False,
        [
            points("serTrajH", "h trajectory (simulation)", ORANGE),
            fast("serInfH", "h_inf(Vm) steady state", STIM, 2),
        ],
    ),
    "chtPhaseN": (
        "K activation n vs Vm",
        "Vm (mV)",
        "n (-)",
        None,
        False,
        [
            points("serTrajN", "n trajectory (simulation)", BLUE),
            fast("serInfN", "n_inf(Vm) steady state", STIM, 2),
        ],
    ),
    "chtTau": (
        "Gate time constants tau_x = 1/(alpha_x + beta_x)",
        "Vm (mV)",
        "tau (ms), log scale",
        None,
        True,
        [
            fast("serTauM", "tau_m", VERMILLION, 2),
            fast("serTauH", "tau_h", ORANGE, 2),
            fast("serTauN", "tau_n", BLUE, 2),
        ],
    ),
    "chtRefThreshold": (
        "Test-pulse threshold after a conditioning AP",
        "Interval between pulse onsets (ms)",
        "|J2| threshold (uA/cm2)",
        ("Peak Vm of 2nd AP (mV)", VERMILLION),
        False,
        [
            line("serRefThr", "Threshold of test pulse |J2|", BLUE, 2),
            line("serRefBase", "Rested single-pulse threshold", STIM, 2, marked=False),
            line(
                "serRefPeak",
                "Peak of 2nd AP for J2 = J1 (right axis)",
                VERMILLION,
                2,
                right=True,
            ),
        ],
    ),
    "chtRefExample": (
        "Paired-pulse response at the selected interval",
        "t (ms)",
        "Vm (mV)",
        None,
        False,
        [
            fast("serRefEx1", "Conditioning pulse only", STIM, 2),
            fast("serRefEx2", "Test pulse J2 = J1", BLUE, 2),
            fast("serRefEx3", "Test pulse J2 = 1.05 x threshold", VERMILLION, 2),
        ],
    ),
    "chtISI": (
        "Inter-pulse interval programmed by the Jin level",
        "|Jin| (uA/cm2)",
        "Inter-pulse interval (ms)",
        ("Firing frequency (Hz)", VERMILLION),
        False,
        [
            line("serISI", "Steady inter-pulse interval", BLUE, 2),
            line("serFreq", "Firing frequency (right axis)", VERMILLION, 2, right=True),
        ],
    ),
    "chtISITraces": (
        "Spike trains for three Jin levels",
        "t (ms)",
        "Vm (mV)",
        None,
        False,
        [
            fast("serTraceA", "Jin = -7.0 uA/cm2", ordered(0, 3), 2),
            fast("serTraceB", "Jin = -20.0 uA/cm2", ordered(1, 3), 2),
            fast("serTraceC", "Jin = -40.0 uA/cm2", ordered(2, 3), 2),
        ],
    ),
    "chtAPPTime": (
        "Vm(t) at recording sites along the axon",
        "t (ms)",
        "Vm (mV)",
        None,
        False,
        site_series
        + [
            line(
                "serTimeCursor",
                "time cursor",
                STIM,
                1,
                marked=False,
                extra=("ShowInLegend = False",),
            )
        ],
    ),
    "chtAPPSpace": (
        "Vm(x) spatial profile",
        "x (mm)",
        "Vm (mV)",
        None,
        False,
        snap_series
        + [fast("serLiveProfile", "time slider", BLACK, 3, extra=("Tag = 1",))],
    ),
}


def axis_props(axis, title, colour=None, grid=True):
    title_colour = TEXT if colour is None else colour
    label_colour = LABEL if colour is None else colour
    props = []
    if grid:
        props += [f"{axis}.Grid.Color = {GRID}", f"{axis}.Grid.Style = psSolid"]
    else:
        props.append(f"{axis}.Grid.Visible = False")
    props += [
        f"{axis}.LabelsFormat.Font.Color = {label_colour}",
        f"{axis}.LabelsFormat.Font.Height = -11",
        f"{axis}.LabelsFormat.Font.Name = 'Segoe UI'",
    ]
    if title is not None:
        props.append(f"{axis}.Title.Caption = {q(title)}")
    props += [
        f"{axis}.Title.Font.Color = {title_colour}",
        f"{axis}.Title.Font.Height = -12",
        f"{axis}.Title.Font.Name = 'Segoe UI'",
    ]
    return props


def chart_props(spec):
    title, xt, yt, right, log, _ = spec
    props = [
        "BackWall.Brush.Style = bsClear",
        "Legend.Alignment = laBottom",
        "Legend.CheckBoxes = True",
        f"Legend.Font.Color = {TEXT}",
        "Legend.Font.Height = -12",
        "Legend.Font.Name = 'Segoe UI'",
        "Legend.Frame.Visible = False",
        "Legend.LegendStyle = lsSeries",
        f"Title.Font.Color = {TEXT}",
        "Title.Font.Height = -13",
        "Title.Font.Name = 'Segoe UI'",
        "Title.Font.Style = [fsBold]",
        "Title.Text.Strings = (",
        f"  {q(title)})",
    ]
    props += axis_props("BottomAxis", xt)
    props += axis_props("LeftAxis", yt)
    if log:
        props.append("LeftAxis.Logarithmic = True")
    if right is None:
        props += axis_props("RightAxis", None)
    else:
        props += axis_props("RightAxis", right[0], right[1], grid=False)
    props += [
        "View3D = False",
        "Color = clWhite",
        "BevelOuter = bvNone",
        "Cursor = crCross",
        "OnDblClick = ChartDblClick",
        "OnMouseMove = ChartMouseMove",
        "OnScroll = ChartZoomed",
        "OnUndoZoom = ChartUnzoomed",
        "OnZoom = ChartZoomed",
    ]
    return props


# default rows of the parameter editors (same values as the code)
EDITORS = {
    "vleModel": [
        "gNa0 (mS/cm2)=120",
        "gK0 (mS/cm2)=36",
        "gL0 (mS/cm2)=0.3",
        "VNa (mV, HH sign)=-115",
        "VK (mV, HH sign)=12",
        "VL (mV, HH sign)=-10.613",
        "Cm (uF/cm2)=1",
        "Temperature (deg C)=6.3",
    ],
    "vleAPG": [
        "Jin baseline (uA/cm2)=0",
        "Jin step level (uA/cm2)=-10",
        "t_on (ms)=1",
        "t_off (ms)=61",
        "Integration step dt (ms)=0.01",
        "Simulation time (ms)=70",
    ],
    "vleRef": [
        "Conditioning pulse J1 (uA/cm2)=-40",
        "Pulse width (ms)=0.5",
        "Interval start (ms)=1",
        "Interval end (ms)=30",
        "Interval step (ms)=0.5",
        "Max |J2| searched (uA/cm2)=500",
        "Integration step dt (ms)=0.01",
    ],
    "vleISI": [
        "Jin start (uA/cm2)=0",
        "Jin end (uA/cm2)=-100",
        "Jin step magnitude (uA/cm2)=1",
        "Run time per level (ms)=200",
        "Discard transient (ms)=50",
        "Integration step dt (ms)=0.01",
        "Trace A Jin (uA/cm2)=-7",
        "Trace B Jin (uA/cm2)=-20",
        "Trace C Jin (uA/cm2)=-40",
    ],
    "vleAPP": [
        "Axon radius a (um)=5",
        "Axoplasm resistivity Ri (ohm.cm)=35.4",
        "External resistance ro (ohm/cm)=0",
        "Axon length (mm)=2",
        "Spatial step h (mm)=0.4",
        "Time step k (ms)=0.01",
        "Simulation time (ms)=60",
        "Stimulus Jin (uA/cm2)=-150",
        "Stimulus duration (ms)=0.5",
        "Stimulated length (mm)=0.4",
        "Passive gm (mS/cm2)=0.6773",
        "Recording sites (2-8)=6",
        "Number of current pulses=4",
        "Pulse interval (ms)=15",
    ],
}
KEY_COL = 200  # width of the Parameter column

MODEL_INFO = [
    "Hodgkin-Huxley membrane (lecturer week-9 notation, HH 1952 sign):",
    "  Cm dv/dt = Jin - (JNa + JK + JL)",
    "  JNa = gNa0 m^3 h (v - VNa),  JK = gK0 n^4 (v - VK),  JL = gL0 (v - VL)",
    "  dx/dt = -x (alpha_x + beta_x) + alpha_x,   x = m, h, n",
    "  alpha_m = 0.1(v+25)/(exp(0.1v+2.5)-1),  beta_m = 4 exp(v/18)",
    "  alpha_h = 0.07 exp(v/20),               beta_h = 1/(exp(0.1v+3)+1)",
    "  alpha_n = 0.01(v+10)/(exp(0.1v+1)-1),   beta_n = 0.125 exp(v/80)",
    "  Output alignment: Vm = -(v + 70) mV",
    "  Depolarization is negative v; Jin < 0 depolarizes the membrane.",
    "  Rates are multiplied by phi = 3^((T - 6.3)/10).",
    "",
    "Cable (APP): dv/dt = d2v/dx2 / ((ro+ri) cm) + (Jin - Jion)/Cm",
    "  ri = Ri/(pi a^2),  cm = Cm 2 pi a",
    "  Explicit scheme stable for r = k/((ro+ri) cm h^2) <= 0.5",
    "  Crank-Nicolson: no stability limit on r",
    "  Lengths are entered in mm (x, h, axon and stimulated length).",
    "",
    'Derivations: buttons "Sheet 1" to "Sheet 6" on the left open the sheets.',
    "",
    "Chart interaction:",
    "  drag right-down = zoom box, drag left-up or double-click = reset,",
    "  right-drag = pan, wheel = zoom at cursor, Shift + wheel = time axis,",
    "  click a legend check box to hide/show a series, F5 = run active tab.",
]


def picture_data(path, indent):
    data = open(path, "rb").read()
    blob = bytes([9]) + b"TPngImage" + data
    hexs = blob.hex().upper()
    rows = [hexs[k : k + 64] for k in range(0, len(hexs), 64)]
    out = [f"{indent}Picture.Data = {{"]
    out += [f"{indent}  {r}" for r in rows]
    out[-1] += "}"
    w, h = struct.unpack(">II", data[16:24])
    return out, w, h


text = open(SRC, encoding="utf-8-sig").read().replace("\r\n", "\n")
lines = text.split("\n")


def find_block(name):
    """Return (start, end) line indices of 'object <name>: ...' .. 'end'."""
    pat = re.compile(r"^(\s*)object " + re.escape(name) + r": (\w+)$")
    for i, ln in enumerate(lines):
        m = pat.match(ln)
        if m:
            indent = m.group(1)
            for j in range(i + 1, len(lines)):
                if lines[j] == indent + "end":
                    return i, j, indent, m.group(2)
    raise KeyError(name)


def own_props(start, end, indent):
    """Indices of the property lines that belong to the object itself."""
    inner = indent + "  "
    idx, k = [], start + 1
    while k < end:
        ln = lines[k]
        if ln.startswith(inner + "object ") or ln.startswith(inner + "inherited "):
            break
        idx.append(k)
        k += 1
    return idx, k  # k = first child object or end


def strip_prop(block, key):
    """Remove 'key = ...' (with a multi-line value) from a list of lines."""
    out, skip = [], False
    for ln in block:
        s = ln.strip()
        if skip:
            if s.endswith(")") or s.endswith("}"):
                skip = False
            continue
        if s.startswith(key + " = "):
            rest = s[len(key) + 3 :]
            if rest in ("(", "{") or (rest.startswith("(") and not rest.endswith(")")):
                skip = True
            continue
        out.append(ln)
    return out


def rebuild(name, new_props, children=(), drop=()):
    start, end, indent, cls = find_block(name)
    prop_idx, first_child = own_props(start, end, indent)
    props = [lines[k] for k in prop_idx]
    for key in list(drop) + [
        p.split(" = ")[0].strip()
        for p in new_props
        if " = " in p and not p.startswith("  ")
    ]:
        props = strip_prop(props, key)
    inner = indent + "  "
    added = [inner + p for p in new_props]
    tail = lines[first_child:end]
    kids = []
    for cname, ccls, cprops in children:
        kids.append(f"{inner}object {cname}: {ccls}")
        kids += [f"{inner}  {p}" for p in cprops]
        kids.append(f"{inner}end")
    block = [lines[start]] + props + added + tail + kids + [lines[end]]
    lines[start : end + 1] = block


for chart, spec in CHARTS.items():
    rebuild(chart, chart_props(spec), spec[5])

for vle, rows in EDITORS.items():
    start, end, indent, _ = find_block(vle)
    prop_idx, _ = own_props(start, end, indent)
    widths = None
    for k in prop_idx:
        if lines[k].strip() == "ColWidths = (":
            widths = (int(lines[k + 1].strip()), int(lines[k + 2].strip(" )")))
    total = sum(widths) if widths else 312
    new = (
        ["Strings.Strings = ("]
        + [f"  {q(r)}" for r in rows[:-1]]
        + [f"  {q(rows[-1])})"]
    )
    new += [
        "TitleCaptions.Strings = (",
        "  'Parameter'",
        "  'Value')",
        "ColWidths = (",
        f"  {KEY_COL}",
        f"  {total - KEY_COL})",
    ]
    rebuild(vle, new)

memo = (
    ["Lines.Strings = ("]
    + [f"  {q(r)}" for r in MODEL_INFO[:-1]]
    + [f"  {q(MODEL_INFO[-1])})", "Visible = False"]
)
rebuild("memModelInfo", memo)

start, end, indent, _ = find_block("imgEquations")
pic_eq, w_eq, h_eq = picture_data(PNG_EQ, "")
rebuild(
    "imgEquations",
    ["Left = 12", "Top = 12", f"Width = {w_eq}", f"Height = {h_eq}", "AutoSize = True"]
    + pic_eq,
)
pic_nom, w_nom, h_nom = picture_data(PNG_NOM, "")
rebuild(
    "imgNomenclature",
    [
        "Left = 12",
        f"Top = {12 + h_eq + 24}",
        f"Width = {w_nom}",
        f"Height = {h_nom}",
        "AutoSize = True",
    ]
    + pic_nom,
)

out = "\r\n".join(lines)
if not out.endswith("\r\n"):
    out += "\r\n"
open(DST, "w", encoding="utf-8", newline="").write(out)
print(
    "charts",
    len(CHARTS),
    "series",
    sum(len(s[5]) for s in CHARTS.values()),
    "editors",
    len(EDITORS),
)
