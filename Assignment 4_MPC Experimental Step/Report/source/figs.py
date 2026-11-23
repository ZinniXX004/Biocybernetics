"""Figures of the Assignment 4 report and README.

Figures 1.1 (bilinear map of the s plane) and 1.2 (observer structure) are
drawn here. Figures 2.2, 2.4 and 2.6 are plotted from the files written by
the Delphi numerical core (MPCModel.pas) through its test:

    cd ../../Program/Verification
    fpc -Fu.. TestMPC.dpr && ./TestMPC --csv ../../Report/source/data

Figures 2.1, 2.3 and 2.5 are placeholders for screenshots of the program.
Colours follow the program (Okabe-Ito).
"""

from pathlib import Path
import csv
import re
import sys

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402
import numpy as np  # noqa: E402
from matplotlib.patches import FancyArrowPatch, FancyBboxPatch  # noqa: E402

HERE = Path(__file__).resolve().parent
DATA = Path(sys.argv[1]) if len(sys.argv) > 1 else HERE / "data"
FIG = HERE / "fig"
IMG = HERE.parent.parent / "docs" / "img"

BLUE, VERM, ORANGE, SKY, GREEN, PURPLE, BLACK, GREY = (
    "#0072B2",
    "#D55E00",
    "#E69F00",
    "#56B4E9",
    "#009E73",
    "#CC79A7",
    "#000000",
    "#8c8c8c",
)


def style():
    plt.rcParams.update(
        {
            "font.family": "serif",
            "font.serif": ["Times New Roman", "DejaVu Serif"],
            "mathtext.fontset": "stix",
            "font.size": 10,
            "axes.titlesize": 10.5,
            "axes.labelsize": 10,
            "legend.fontsize": 8.5,
            "xtick.labelsize": 9,
            "ytick.labelsize": 9,
            "lines.linewidth": 1.6,
            "axes.grid": True,
            "grid.color": "#e4e3df",
            "grid.linewidth": 0.6,
            "axes.spines.top": False,
            "axes.spines.right": False,
            "legend.frameon": False,
            "axes.edgecolor": "#52514e",
        }
    )


def load(tag):
    rows = list(csv.DictReader(open(DATA / f"{tag}.csv", encoding="utf-8")))
    return {k: np.array([float(r[k]) for r in rows]) for k in rows[0]}


def sigmas():
    text = open(DATA / "p2_hokalman_lecture.dat", encoding="utf-8").read()
    block = text.split("# Singular values sigma")[1].split("\n\n")[0]
    return np.array([float(v) for v in block.split()])


def save(fig, name, where=FIG):
    where.mkdir(parents=True, exist_ok=True)
    fig.savefig(where / name, dpi=300, bbox_inches="tight")
    plt.close(fig)


def fig1_1():
    """The bilinear map z = (1 + sT/2) / (1 - sT/2) of the poles of Problem 1."""
    style()
    t = 0.25  # exaggerated so the images can be told apart (the sheet uses 0.001 s)
    fig, (a, b) = plt.subplots(1, 2, figsize=(7.2, 3.1))
    a.axvspan(-3.5, 0, color="#e8f3ec")
    a.axhline(0, color=GREY, lw=0.8)
    a.axvline(0, color=GREY, lw=0.8)
    a.plot(
        [2, 0, -2],
        [0, 0, 0],
        "x",
        color=VERM,
        ms=9,
        mew=2,
        label="system 1: $s=2,\\,0,\\,-2$",
    )
    a.plot(
        [0, 0],
        [2, -2],
        "o",
        mfc="none",
        color=BLUE,
        ms=8,
        mew=2,
        label="system 2: $s=\\pm2j$",
    )
    a.set_xlim(-3.5, 3.5)
    a.set_ylim(-3, 3)
    a.set_xlabel("Re $s$ (1/s)")
    a.set_ylabel("Im $s$ (1/s)")
    a.set_title("$s$ plane (stable: Re $s<0$)")
    a.legend(loc="upper left")
    phi = np.linspace(0, 2 * np.pi, 400)
    b.fill(np.cos(phi), np.sin(phi), color="#e8f3ec")
    b.plot(np.cos(phi), np.sin(phi), color=GREY, lw=1)
    z = lambda s: (1 + s * t / 2) / (1 - s * t / 2)  # noqa: E731
    zs = [z(2.0), z(0.0), z(-2.0)]
    b.plot(
        [v.real for v in np.array(zs, dtype=complex)],
        [0, 0, 0],
        "x",
        color=VERM,
        ms=9,
        mew=2,
    )
    z2 = [z(2j), z(-2j)]
    b.plot(
        [v.real for v in z2],
        [v.imag for v in z2],
        "o",
        mfc="none",
        color=BLUE,
        ms=8,
        mew=2,
    )
    b.set_aspect("equal")
    b.set_xlim(-1.3, 2.0)
    b.set_ylim(-1.3, 1.3)
    b.set_xlabel("Re $z$ (-)")
    b.set_ylabel("Im $z$ (-)")
    b.set_title("$z$ plane (stable: $|z|<1$), $T=0.25$ s")
    b.annotate("$|z|=1$", (np.cos(2.2), np.sin(2.2)), xytext=(-1.25, 1.05), fontsize=9)
    fig.tight_layout()
    save(fig, "fig1_1.png")


def box(ax, x, y, w, h, text, fc="#ffffff", ec=BLACK):
    ax.add_patch(
        FancyBboxPatch(
            (x - w / 2, y - h / 2),
            w,
            h,
            boxstyle="round,pad=0.02,rounding_size=0.08",
            fc=fc,
            ec=ec,
            lw=1.2,
        )
    )
    ax.text(x, y, text, ha="center", va="center", fontsize=9.5)


def arrow(ax, p, q, text=None, off=(0, 0.12), color=BLACK):
    ax.add_patch(
        FancyArrowPatch(p, q, arrowstyle="-|>", mutation_scale=11, lw=1.1, color=color)
    )
    if text:
        ax.text(
            (p[0] + q[0]) / 2 + off[0],
            (p[1] + q[1]) / 2 + off[1],
            text,
            ha="center",
            fontsize=9,
        )


def fig1_2():
    """Plant and observer (report Equations 1.17 and 1.18)."""
    style()
    fig, ax = plt.subplots(figsize=(7.2, 2.9))
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 4)
    ax.axis("off")
    box(ax, 4.6, 3.3, 2.6, 0.6, "Plant: $x(k+1)=Ax+Bu$")
    box(ax, 7.6, 3.3, 1.0, 0.6, "$C$")
    box(ax, 4.6, 1.7, 3.0, 0.6, "Model: $A\\hat x(k)+Bu(k)$", fc="#eef5fb", ec=BLUE)
    box(ax, 7.6, 1.7, 1.0, 0.6, "$C$", fc="#eef5fb", ec=BLUE)
    box(ax, 4.6, 0.55, 1.2, 0.55, "$K_{ob}$", fc="#fff2a8", ec=ORANGE)
    ax.add_patch(plt.Circle((8.9, 2.5), 0.16, fill=False, lw=1.1))
    ax.text(8.9, 2.5, "$-$", ha="center", va="center", fontsize=10)
    arrow(ax, (0.6, 3.3), (3.3, 3.3), "$u(k)$")
    arrow(ax, (1.5, 3.3), (1.5, 1.7))
    arrow(ax, (1.5, 1.7), (3.1, 1.7))
    arrow(ax, (5.9, 3.3), (7.1, 3.3), "$x(k)$")
    arrow(ax, (8.1, 3.3), (8.9, 3.3))
    ax.plot([8.9, 8.9], [3.3, 2.66], color=BLACK, lw=1.1)
    ax.text(9.15, 3.35, "$y(k)$", fontsize=9)
    arrow(ax, (6.1, 1.7), (7.1, 1.7), "$\\hat x(k)$")
    arrow(ax, (8.1, 1.7), (8.74, 2.42), "$C\\hat x$", off=(-0.35, 0.05))
    ax.plot([8.9, 8.9, 5.2], [2.34, 0.55, 0.55], color=BLACK, lw=1.1)
    ax.text(7.2, 0.68, "$y-C\\hat x$", fontsize=9)
    arrow(ax, (4.0, 0.55), (3.6, 1.4), color=ORANGE)
    ax.text(
        1.0, 0.45, "correction\n$K_{ob}(y-C\\hat x)$", fontsize=8.5, color="#7a4a00"
    )
    ax.text(
        4.6,
        2.2,
        "$\\hat x(k+1)$ = model + correction",
        ha="center",
        fontsize=8.5,
        color=BLUE,
    )
    save(fig, "fig1_2.png")


def fig2_2():
    """Problem 1 responses: system 1 grows, system 2 oscillates without damping."""
    style()
    s1 = load("p1_sys1")
    s2 = load("p1_sys2")
    fig, ax = plt.subplots(2, 2, figsize=(7.2, 5.0))
    a = ax[0, 0]
    a.plot(
        s1["t_s"],
        s1["step_lecture"],
        color=BLUE,
        lw=2.4,
        label="discrete, lecture formula",
    )
    a.plot(s1["t_s"], s1["step_exact"], color=ORANGE, lw=1.0, label="exact continuous")
    a.set_title("(a) System 1, step response")
    a.set_xlabel("$t=kT$ (s)")
    a.set_ylabel("$y$ (-)")
    a.legend(loc="upper left")
    a = ax[0, 1]
    a.plot(
        s2["t_s"],
        s2["step_lecture"],
        color=BLUE,
        lw=2.4,
        label="discrete, lecture formula",
    )
    a.plot(s2["t_s"], s2["step_exact"], color=ORANGE, lw=1.0, label="$0.5\\sin 2t$")
    a.set_title("(b) System 2, step response")
    a.set_xlabel("$t=kT$ (s)")
    a.set_ylabel("$y$ (-)")
    a.set_ylim(-0.95, 0.65)
    a.legend(loc="lower center", ncol=2, fontsize=8)
    a = ax[1, 0]
    a.plot(
        s2["t_s"][1:],
        s2["pulse_lecture_over_T"][1:],
        color=BLUE,
        lw=2.4,
        label="pulse $u(0)=1/T$",
    )
    a.plot(s2["t_s"], s2["impulse_exact"], color=ORANGE, lw=1.0, label="$\\cos 2t$")
    a.set_title("(c) System 2, impulse response")
    a.set_xlabel("$t=kT$ (s)")
    a.set_ylabel("$y$ (-)")
    a.set_ylim(-1.75, 1.25)
    a.legend(loc="lower center", ncol=2, fontsize=8)
    a = ax[1, 1]
    a.plot(
        s2["t_s"],
        1e4 * (s2["step_lecture"] - s2["step_exact"]),
        color=VERM,
        lw=1.2,
        label="$y_{lecture}-0.5\\sin 2t$",
    )
    a.plot(
        s2["t_s"],
        1e4 * (5e-4 * s2["step_exact"] / (1 - 5e-4)),
        color=BLACK,
        lw=0.8,
        ls="--",
        label="$\\frac{T/2}{1-T/2}\\,0.5\\sin 2t$",
    )
    a.set_title("(d) System 2, step error ($\\times10^{-4}$)")
    a.set_xlabel("$t=kT$ (s)")
    a.set_ylabel("error $\\times10^{4}$ (-)")
    a.set_ylim(-4.6, 3.2)
    a.legend(loc="lower center", ncol=2, fontsize=8)
    fig.tight_layout()
    save(fig, "fig2_2.png")


def fig2_4():
    """Problem 2: step data, Markov parameters, singular values."""
    style()
    d = load("p2_lecture")
    s = sigmas()
    fig, ax = plt.subplots(1, 3, figsize=(7.2, 2.6))
    a = ax[0]
    a.plot(0.1 * d["k"], d["step"], "o", color=BLUE, ms=3.5, label="data $S(k)$")
    a.plot(0.1 * d["k"], d["model_step"], color=VERM, lw=1.2, label="model")
    a.set_title("(a) Step data, 40 samples")
    a.set_xlabel("$t=kT$ (s)")
    a.set_ylabel("$S$ (-)")
    a.legend(loc="upper left")
    a = ax[1]
    a.plot(d["k"], d["markov"], "s", color=GREEN, ms=3.2, label="$g(k)$ data")
    g_model = np.diff(np.concatenate([[0.0], d["model_step"]]))
    a.plot(d["k"], g_model, color=PURPLE, lw=1.2, label="$CA^{k-1}B$")
    a.set_title("(b) Markov parameters")
    a.set_xlabel("$k$ (-)")
    a.set_ylabel("$g$ (-)")
    a.legend(loc="lower left")
    a = ax[2]
    a.semilogy(np.arange(1, len(s) + 1), np.maximum(s, 1e-20), "o-", color=BLUE, ms=5)
    a.axhline(1e-8 * s[0], color=VERM, lw=1, ls="--", label="$10^{-8}\\sigma_1$")
    for i, v in enumerate(s[:2]):
        a.annotate(f"{v:.4f}", (i + 1, v), xytext=(i + 1.15, v * 2.5), fontsize=8.5)
    a.set_xticks(range(1, len(s) + 1))
    a.set_title("(c) Singular values of $H_{4,4}$")
    a.set_xlabel("$i$ (-)")
    a.set_ylabel("$\\sigma_i$ (-)")
    a.legend(loc="lower left")
    fig.tight_layout()
    save(fig, "fig2_4.png")


def fig2_6():
    """Problem 3: observer error against the open-loop model."""
    style()
    d = load("p3_observer")
    fig, ax = plt.subplots(1, 3, figsize=(7.2, 2.6))
    a = ax[0]
    a.semilogy(
        d["k"],
        d["err_obs"],
        "o-",
        color=BLUE,
        ms=3,
        lw=1.2,
        label="observer (0.8, 0.7)",
    )
    a.semilogy(
        d["k"], d["err_open"], "s-", color=VERM, ms=3, lw=1.2, label="open-loop model"
    )
    a.set_title("(a) $\\|x-\\hat x\\|$")
    a.set_xlabel("$k$ (-)")
    a.set_ylabel("error (-)")
    a.legend(loc="lower left", fontsize=8)
    for i, key in ((1, "1"), (2, "2")):
        a = ax[i]
        a.plot(d["k"], d["x" + key], color=BLACK, lw=1.8, label="plant")
        a.plot(d["k"], d["xo" + key], "o", color=BLUE, ms=3, label="observer")
        a.plot(d["k"], d["xm" + key], color=ORANGE, lw=1.4, label="open-loop model")
        a.set_title(f"({'bc'[i - 1]}) state $x_{key}(k)$")
        a.set_xlabel("$k$ (-)")
        a.set_ylabel(f"$x_{key}$ (-)")
        a.legend(loc="upper right", fontsize=8)
    fig.tight_layout()
    save(fig, "fig2_6.png")


def placeholder(name, text):
    style()
    fig, ax = plt.subplots(figsize=(7.2, 3.4))
    ax.axis("off")
    ax.add_patch(
        FancyBboxPatch(
            (0.02, 0.04),
            0.96,
            0.92,
            boxstyle="round,pad=0.01",
            fc="#f2f2f2",
            ec=GREY,
            lw=1.5,
            ls="--",
            transform=ax.transAxes,
        )
    )
    ax.text(
        0.5,
        0.5,
        "SCREENSHOT PLACEHOLDER\n\n" + text,
        ha="center",
        va="center",
        fontsize=11,
        transform=ax.transAxes,
        color="#404040",
    )
    save(fig, name)


if __name__ == "__main__":
    fig1_1()
    fig1_2()
    fig2_2()
    fig2_4()
    fig2_6()
    placeholder(
        "fig2_1.png",
        "Tab Problem 1, system 1, lecture formula, T = 0.001 s,\n"
        "after Discretise and Step and impulse (matrices next to the sheet values)",
    )
    placeholder(
        "fig2_3.png",
        "Tab Problem 2, lecture bilinear data, Hankel 4 x 4,\n"
        "after Ho-Kalman (SVD): step data, Markov parameters, singular values, A, B, C, D",
    )
    placeholder(
        "fig2_5.png",
        "Tab Problem 3, plant of the sheet, poles 0.8 and 0.7,\n"
        "after Compute Kob and Simulate observer",
    )
    print("figures written to", FIG)


def overview(dark=False):
    """README picture: one panel per problem, light and dark theme."""
    style()
    ink, sub, bg = ("#f0efec", "#c3c2b7", "#1a1a19") if dark else ("#0b0b0b", "#52514e", "#ffffff")
    plt.rcParams.update({"text.color": ink, "axes.labelcolor": ink, "xtick.color": sub, "ytick.color": sub,
                         "axes.edgecolor": sub, "figure.facecolor": bg, "axes.facecolor": bg,
                         "savefig.facecolor": bg, "grid.color": "#383835" if dark else "#e4e3df"})
    blue = SKY if dark else BLUE
    s2 = load("p1_sys2")
    d = load("p3_observer")
    s = sigmas()
    fig, ax = plt.subplots(1, 3, figsize=(10, 2.9))
    a = ax[0]
    a.plot(s2["t_s"], s2["step_lecture"], color=blue, lw=2.4, label="lecture bilinear")
    a.plot(s2["t_s"], s2["step_exact"], color=ORANGE, lw=1.0, label="0.5 sin 2t")
    a.set_title("Problem 1: system 2, |z| = 1")
    a.set_xlabel("t (s)")
    a.set_ylim(-0.9, 0.7)
    a.legend(loc="lower center", ncol=2, fontsize=8)
    a = ax[1]
    a.semilogy(range(1, len(s) + 1), np.maximum(s, 1e-20), "o-", color=blue, ms=6)
    a.axhline(1e-8 * s[0], color=VERM, ls="--", lw=1, label="order threshold")
    a.set_title("Problem 2: singular values of H(4,4)")
    a.set_xlabel("i")
    a.set_xticks(range(1, len(s) + 1))
    a.legend(loc="lower left", fontsize=8)
    a = ax[2]
    a.semilogy(d["k"], d["err_obs"], "o-", color=blue, ms=3, lw=1.2, label="observer (0.8, 0.7)")
    a.semilogy(d["k"], d["err_open"], "s-", color=VERM, ms=3, lw=1.2, label="open-loop model")
    a.set_title("Problem 3: estimation error")
    a.set_xlabel("k")
    a.legend(loc="lower left", fontsize=8)
    fig.tight_layout()
    save(fig, "mpc-overview-dark.png" if dark else "mpc-overview-light.png", IMG)
    plt.rcdefaults()


if __name__ == "__main__" and len(sys.argv) > 2 and sys.argv[2] == "--readme":
    overview(False)
    overview(True)
