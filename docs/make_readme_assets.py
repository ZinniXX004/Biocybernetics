"""Build the README images of the repository from the program's own output.

Inputs (paths relative to the repository root):
  Assignment 1_HH Model/Data/*.csv         CSV exports of the Delphi program
  Assignment 1_HH Model/Report/<report>.docx  screenshots pasted in the report

Outputs:
  docs/assets/banner-light.png, banner-dark.png         root README header
  Assignment 1_HH Model/docs/img/results-light.png, results-dark.png
  Assignment 1_HH Model/docs/img/ui-*.png               screenshots (status bar cropped)

Usage: python docs/make_readme_assets.py   (from the repository root,
needs numpy, matplotlib, pillow, lxml)
"""

import csv
import io
import os
import sys
import zipfile

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402
import numpy as np  # noqa: E402
from lxml import etree  # noqa: E402
from PIL import Image  # noqa: E402

A1 = "Assignment 1_HH Model"
DATA = os.path.join(A1, "Data")
REPORT = os.path.join(
    A1, "Report", "5023231017_Jeremia Christ Immanuel Manalu_Assignment 1_HH Model.docx"
)
OUT_ROOT = os.path.join("docs", "assets")
OUT_A1 = os.path.join(A1, "docs", "img")

# Okabe-Ito colours, as in the program
BLACK, GREY, VERMILLION, BLUE, GREEN, ORANGE = (
    "#000000",
    "#7F7F7F",
    "#D55E00",
    "#0072B2",
    "#009E73",
    "#E69F00",
)
THEMES = {
    "light": dict(
        bg="#FFFFFF", fg="#1F2328", muted="#59636E", grid="#D1D9E0", vm="#1F2328"
    ),
    "dark": dict(
        bg="#0D1117", fg="#F0F6FC", muted="#9198A1", grid="#3D444D", vm="#F0F6FC"
    ),
}


def read_csv(name):
    """Return the columns of a program CSV as float arrays ('n/a' -> nan)."""
    with open(os.path.join(DATA, name), encoding="utf-8-sig", newline="") as handle:
        rows = list(csv.reader(handle))
    header, body = rows[0], rows[1:]
    cols = {}
    for k, key in enumerate(header):
        values = []
        for row in body:
            try:
                values.append(float(row[k]))
            except ValueError:
                values.append(np.nan)
        cols[key] = np.array(values)
    return cols


def style_axes(ax, th):
    ax.set_facecolor(th["bg"])
    for side in ("top", "right"):
        ax.spines[side].set_visible(False)
    for side in ("left", "bottom"):
        ax.spines[side].set_color(th["muted"])
    ax.tick_params(colors=th["muted"], labelsize=10)
    ax.xaxis.label.set_color(th["fg"])
    ax.yaxis.label.set_color(th["fg"])
    ax.title.set_color(th["fg"])
    ax.grid(True, color=th["grid"], linewidth=0.6, alpha=0.8)


def banner(apg, theme):
    th = THEMES[theme]
    fig = plt.figure(figsize=(16, 4.2), dpi=100, facecolor=th["bg"])
    ax = fig.add_axes([0, 0, 1, 1])
    ax.set_facecolor(th["bg"])
    ax.axis("off")
    t, vm = apg["t_ms"], apg["Vm_mV"]
    sel = t <= 70
    # trace across the lower part of the banner
    x = 0.36 + 0.62 * t[sel] / 70.0
    y = 0.14 + 0.62 * (vm[sel] + 85) / 125.0
    ax.plot(x, y, color=VERMILLION, linewidth=2.2, solid_capstyle="round")
    ax.plot(
        [0.36, 0.98],
        [0.14 + 0.62 * 15 / 125.0] * 2,
        color=th["grid"],
        linewidth=1,
        zorder=0,
    )
    ax.text(
        0.04,
        0.62,
        "Biocybernetics",
        fontsize=46,
        fontweight="bold",
        color=th["fg"],
        va="center",
    )
    ax.text(
        0.04,
        0.43,
        "EB234701  |  Class Q  |  Biomedical Engineering ITS",
        fontsize=15,
        color=th["muted"],
        va="center",
    )
    ax.text(
        0.04,
        0.31,
        "Delphi 13 simulators and reports",
        fontsize=15,
        color=th["muted"],
        va="center",
    )
    ax.text(
        0.04,
        0.12,
        "Jeremia Christ Immanuel Manalu  (5023231017)",
        fontsize=13,
        color=th["fg"],
        va="center",
    )
    ax.text(
        0.98,
        0.06,
        "Vm(t) exported by the Assignment 1 simulator, step Jin = -10 uA/cm2",
        fontsize=10,
        color=th["muted"],
        ha="right",
    )
    ax.set_xlim(0, 1)
    ax.set_ylim(0, 1)
    path = os.path.join(OUT_ROOT, f"banner-{theme}.png")
    fig.savefig(path, facecolor=th["bg"])
    plt.close(fig)
    return path


def results(apg, cf, ref, app, theme):
    th = THEMES[theme]
    fig, axes = plt.subplots(2, 2, figsize=(16, 9), dpi=100, facecolor=th["bg"])
    fig.subplots_adjust(
        left=0.06, right=0.98, top=0.93, bottom=0.08, hspace=0.42, wspace=0.18
    )

    ax = axes[0, 0]
    style_axes(ax, th)
    ax.plot(apg["t_ms"], apg["Vm_mV"], color=th["vm"], linewidth=1.6, label="Vm")
    ax2 = ax.twinx()
    ax2.plot(apg["t_ms"], apg["Jin_uA_cm2"], color=GREY, linewidth=1.4, label="Jin")
    ax2.set_ylim(-40, 2)
    ax2.tick_params(colors=GREY, labelsize=10)
    for side in ("top", "left", "bottom"):
        ax2.spines[side].set_visible(False)
    ax2.spines["right"].set_color(GREY)
    ax2.set_ylabel("Jin (uA/cm2)", color=GREY)
    ax.set_title(
        "(a) Action potential generation, coupled RK4",
        fontsize=13,
        loc="left",
        color=th["fg"],
    )
    ax.set_xlabel("t (ms)")
    ax.set_ylabel("Vm (mV)")

    ax = axes[0, 1]
    style_axes(ax, th)
    jin = -cf["Jin_uA_cm2"]
    ax.plot(jin, cf["frequency_Hz"], "o-", color=BLUE, markersize=3.5, linewidth=1.6)
    ax.set_title(
        "(b) C-F converter: steady firing frequency vs |Jin|",
        fontsize=13,
        loc="left",
        color=th["fg"],
    )
    ax.set_xlabel("|Jin| (uA/cm2)")
    ax.set_ylabel("frequency (Hz)")

    ax = axes[1, 0]
    style_axes(ax, th)
    ax.plot(
        ref["interval_ms"],
        ref["threshold_abs_J2_uA_cm2"],
        "o-",
        color=VERMILLION,
        markersize=3.5,
        linewidth=1.6,
        label="test-pulse threshold",
    )
    rested = np.nanmean(ref["rested_threshold"])
    ax.axhline(
        rested,
        color=th["muted"],
        linestyle="--",
        linewidth=1.2,
        label=f"rested threshold {rested:.2f}",
    )
    ax.set_yscale("log")
    ax.set_title(
        "(c) Refractory period: threshold of a second pulse",
        fontsize=13,
        loc="left",
        color=th["fg"],
    )
    ax.set_xlabel("interval between pulse onsets (ms)")
    ax.set_ylabel("|J2| (uA/cm2), log scale")
    leg = ax.legend(frameon=False, fontsize=10)
    for text in leg.get_texts():
        text.set_color(th["fg"])

    ax = axes[1, 1]
    style_axes(ax, th)
    keys = [k for k in app if k.startswith("Vm_x")]
    # the darkest viridis shades vanish on the dark background
    low = 0.0 if theme == "light" else 0.25
    colours = plt.cm.viridis(np.linspace(low, 0.95, len(keys)))
    for key, colour in zip(keys, colours):
        label = "x = " + key[4:].replace("mm", " mm")
        ax.plot(app["t_ms"], app[key], color=colour, linewidth=1.6, label=label)
    ax.set_title(
        "(d) Passive 2 mm cable driven by the APG waveform",
        fontsize=13,
        loc="left",
        color=th["fg"],
    )
    ax.set_xlabel("t (ms)")
    ax.set_ylabel("Vm (mV)")
    leg = ax.legend(frameon=False, fontsize=9, ncol=3, loc="upper right")
    for text in leg.get_texts():
        text.set_color(th["fg"])

    fig.suptitle(
        "Program output (CSV exports of the Delphi simulator)",
        color=th["muted"],
        fontsize=12,
        x=0.98,
        ha="right",
    )
    path = os.path.join(OUT_A1, f"results-{theme}.png")
    fig.savefig(path, facecolor=th["bg"])
    plt.close(fig)
    return path


# screenshots: (figure caption prefix in the report, output name, crop status bar)
SHOTS = [
    ("Figure 2.1.", "ui-tab1-apg.png", True),
    ("Figure 2.2.", "ui-sheet-window.png", False),
    ("Figure 2.4.", "ui-tab2-phase.png", False),
    ("Figure 2.5.", "ui-tab3-refractory.png", True),
    ("Figure 2.6.", "ui-tab4-cf.png", True),
    ("Figure 2.7.", "ui-tab5-squid.png", False),
    ("Figure 2.8.", ("ui-3d-waterfall.png", "ui-3d-mesh.png"), False),
    ("Figure 2.10.", "ui-tab5-lecturer.png", True),
]
STATUS_BAR_PX = 26


def screenshots(report):
    """Copy the screenshots that precede the given captions in the report."""
    w = "http://schemas.openxmlformats.org/wordprocessingml/2006/main"
    r = "http://schemas.openxmlformats.org/officeDocument/2006/relationships"
    with zipfile.ZipFile(report) as z:
        rels = etree.fromstring(z.read("word/_rels/document.xml.rels"))
        targets = {rel.get("Id"): rel.get("Target") for rel in rels}
        root = etree.fromstring(
            z.read("word/document.xml"), etree.XMLParser(huge_tree=True)
        )
        pending, written = [], []
        for para in root.iter("{%s}p" % w):
            for el in para.iter():
                rid = el.get("{%s}embed" % r)
                if rid:
                    pending.append(z.read("word/" + targets[rid]))
            text = "".join(para.itertext()).strip()
            for prefix, names, crop in SHOTS:
                if text.startswith(prefix) and pending:
                    names = names if isinstance(names, tuple) else (names,)
                    for name, data in zip(names, pending[-len(names) :]):
                        image = Image.open(io.BytesIO(data)).convert("RGB")
                        if crop:
                            image = image.crop(
                                (0, 0, image.width, image.height - STATUS_BAR_PX)
                            )
                        if image.width > 1600:
                            image = image.resize(
                                (1600, round(image.height * 1600 / image.width)),
                                Image.LANCZOS,
                            )
                        path = os.path.join(OUT_A1, name)
                        image.quantize(
                            colors=256, method=Image.MEDIANCUT, dither=Image.NONE
                        ).save(path, optimize=True)
                        written.append(path)
            if text.startswith("Figure "):
                pending = []
    return written


def main():
    os.makedirs(OUT_ROOT, exist_ok=True)
    os.makedirs(OUT_A1, exist_ok=True)
    apg = read_csv("APG_result.csv")
    cf = read_csv("Jin_vs_ISI.csv")
    ref = read_csv("Refractory_sweep.csv")
    app = read_csv("APP_result.csv")
    made = []
    for theme in THEMES:
        made.append(banner(apg, theme))
        made.append(results(apg, cf, ref, app, theme))
    report = sys.argv[1] if len(sys.argv) > 1 else REPORT
    made += screenshots(report)
    for path in made:
        print(f"{os.path.getsize(path) / 1024:7.0f} kB  {path}")


if __name__ == "__main__":
    main()
