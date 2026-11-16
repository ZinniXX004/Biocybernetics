"""Figures of the Assignment 3 report and README.

Figures 1.1 (closed loop with dead time) and 1.2 (reaction curve of ZN
Method 1) are drawn here. Figures 2.10 to 2.13 are plotted from the CSV files
written by the Delphi numerical core (ZNModel.pas) through its test:

    cd ../../Program/Verification
    fpc -Fu.. TestZN.dpr && ./TestZN --csv ../../Report/source/data

Colours follow the program (Okabe-Ito): output blue, tangent vermillion,
P orange, PI sky blue, PID bluish green, setpoint black dashed.
"""

from pathlib import Path

import csv
import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402
import numpy as np  # noqa: E402
from matplotlib.patches import FancyArrowPatch, FancyBboxPatch  # noqa: E402

HERE = Path(__file__).resolve().parent
DATA = HERE / "data"
FIG = HERE / "fig"
IMG = HERE.parent.parent / "docs" / "img"

LIGHT = {
    "surface": "#ffffff",
    "ink": "#0b0b0b",
    "ink2": "#52514e",
    "grid": "#e4e3df",
    "y": "#0072B2",
    "tan": "#D55E00",
    "pt": "#CC79A7",
    "lt": "#E69F00",
    "k": "#009E73",
    "P": "#E69F00",
    "PI": "#56B4E9",
    "PID": "#009E73",
    "ref": "#000000",
    "ku": "#56B4E9",
}
DARK = dict(
    LIGHT,
    surface="#1a1a19",
    ink="#f0efec",
    ink2="#c3c2b7",
    grid="#383835",
    y="#56B4E9",
    ref="#c3c2b7",
)
LIMIT = 3.0  # unstable curves are drawn until |y| > 3 r, as in the program


def style(t):
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
            "figure.facecolor": t["surface"],
            "axes.facecolor": t["surface"],
            "savefig.facecolor": t["surface"],
            "text.color": t["ink"],
            "axes.labelcolor": t["ink"],
            "axes.edgecolor": t["ink2"],
            "xtick.color": t["ink2"],
            "ytick.color": t["ink2"],
            "axes.grid": True,
            "grid.color": t["grid"],
            "grid.linewidth": 0.6,
            "axes.spines.top": False,
            "axes.spines.right": False,
            "legend.frameon": False,
        }
    )


def load(tag):
    rows = list(csv.DictReader(open(DATA / f"{tag}.csv", encoding="utf-8")))
    return {k: np.array([float(r[k]) for r in rows]) for k in rows[0]}


def tangent(d, x0=1.0):
    """Point of largest slope and the tangent quantities, as in ZNMethod1."""
    i = int(np.argmax(d["ydot"]))
    r = d["ydot"][i] / x0
    k = d["y"][-1] / x0
    lval = d["t_s"][i] - d["y"][i] / (r * x0)
    return d["t_s"][i], d["y"][i], r, max(lval, 0.0), k


def clip(d):
    n = len(d["y"])
    bad = np.where(np.abs(d["y"]) > LIMIT)[0]
    return n if bad.size == 0 else bad[0]


def grows(y):
    """Growth test of ZNModel: peak-to-peak of the last quarter vs the one before."""
    n = len(y)
    a = np.ptp(y[n // 2:(3 * n) // 4])
    b = np.ptp(y[(3 * n) // 4:])
    return b > a * 1.001 + 1e-6


def save(fig, name, where=FIG):
    where.mkdir(parents=True, exist_ok=True)
    fig.savefig(where / name, dpi=300, bbox_inches="tight")
    plt.close(fig)


def fig1_1(t):
    """Closed loop of the program: PID, dead time, plant."""
    style(t)
    fig, ax = plt.subplots(figsize=(7.2, 1.9))
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 2.4)
    ax.axis("off")
    boxes = [
        (2.3, "PID\n$K_p,\\ K_i,\\ K_d$"),
        (4.8, "dead time\n$e^{-\\theta s}$"),
        (7.3, "plant\n$G_1(s)$ or $G_2(s)$"),
    ]
    for x, txt in boxes:
        ax.add_patch(
            FancyBboxPatch(
                (x - 0.85, 1.05),
                1.7,
                0.9,
                boxstyle="round,pad=0.02",
                fc=t["surface"],
                ec=t["ink"],
                lw=1.1,
            )
        )
        ax.text(x, 1.5, txt, ha="center", va="center", fontsize=9.5)
    ax.add_patch(plt.Circle((0.95, 1.5), 0.17, fc=t["surface"], ec=t["ink"], lw=1.1))
    ax.text(0.95, 1.5, "$\\Sigma$", ha="center", va="center", fontsize=9)

    def arrow(p, q):
        ax.add_patch(
            FancyArrowPatch(
                p, q, arrowstyle="-|>", mutation_scale=11, lw=1.1, color=t["ink"]
            )
        )

    arrow((0.05, 1.5), (0.78, 1.5))
    arrow((1.12, 1.5), (1.45, 1.5))
    arrow((3.15, 1.5), (3.95, 1.5))
    arrow((5.65, 1.5), (6.45, 1.5))
    arrow((8.15, 1.5), (9.9, 1.5))
    ax.plot([9.3, 9.3, 0.95], [1.5, 0.45, 0.45], color=t["ink"], lw=1.1)
    arrow((0.95, 0.45), (0.95, 1.33))
    ax.text(0.1, 1.62, "$r$", fontsize=10)
    ax.text(1.17, 1.62, "$e$", fontsize=10)
    ax.text(0.68, 1.12, "$-$", fontsize=10)
    ax.text(3.35, 1.62, "$u(t)$", fontsize=10)
    ax.text(5.85, 1.62, "$x(t)$", fontsize=10)
    ax.text(9.45, 1.62, "$y(t)$", fontsize=10)
    save(fig, "fig1_1.png")


def fig1_2(t):
    """Reaction curve of an S-shaped process with the ZN tangent."""
    style(t)
    tt = np.linspace(0, 12, 1200)
    y = 1 - np.exp(-tt) * (1 + tt + tt**2 / 2)  # 1/(s+1)^3
    dy = np.gradient(y, tt)
    i = int(np.argmax(dy))
    r = dy[i]
    lval = tt[i] - y[i] / r
    tval = 1 / r
    fig, ax = plt.subplots(figsize=(6.0, 3.1))
    ax.plot(tt, y, color=t["y"], lw=2.2, label="step response $y(t)$")
    ax.plot(
        [lval, lval + tval],
        [0, 1],
        color=t["tan"],
        lw=1.6,
        label="tangent with slope $R$",
    )
    ax.plot(tt[i], y[i], "o", color=t["pt"], ms=6, label="point of largest slope")
    ax.axhline(1, color=t["k"], ls="--", lw=1)
    ax.annotate(
        "",
        xy=(0, -0.08),
        xytext=(lval, -0.08),
        arrowprops=dict(arrowstyle="<->", color=t["ink"]),
    )
    ax.text(lval / 2, -0.16, "$L$", ha="center")
    ax.annotate(
        "",
        xy=(lval, -0.08),
        xytext=(lval + tval, -0.08),
        arrowprops=dict(arrowstyle="<->", color=t["ink"]),
    )
    ax.text(lval + tval / 2, -0.16, "$T$", ha="center")
    ax.text(11.8, 1.03, "$K$", ha="right", va="bottom", color=t["k"])
    ax.set_ylim(-0.22, 1.15)
    ax.set_xlim(0, 12)
    ax.set_xlabel("$t$ (s)")
    ax.set_ylabel("$y$ for a unit step")
    ax.legend(loc="lower right")
    save(fig, "fig1_2.png")


def open_panel(ax, t, tag, title, x0=1.0):
    d = load(tag)
    ts, ys, r, lval, k = tangent(d, x0)
    ax.plot(d["t_s"], d["y"], color=t["y"], lw=2, label="output $y$")
    ax.plot(d["t_s"], d["u"], color=t["ref"], lw=0.9, ls="--", label="input $x$")
    tend = lval + k / r
    ax.plot([lval, tend], [0, k], color=t["tan"], lw=1.4, label="tangent")
    ax.plot(ts, ys, "o", color=t["pt"], ms=5, label="largest slope")
    ax.plot([lval, tend], [0, 0], "D", color=t["lt"], ms=4.5, label="$L$, $L+T$")
    ax.set_xlim(0, 12)
    ax.set_title(title)
    ax.set_xlabel("$t$ (s)")
    ax.text(
        0.98,
        0.05,
        f"R = {r:.4f}\nL = {lval:.4f} s\nT = {k / r:.4f} s",
        transform=ax.transAxes,
        ha="right",
        va="bottom",
        fontsize=8.5,
        bbox=dict(boxstyle="round,pad=0.25", fc=t["surface"], ec=t["grid"]),
    )


def fig_open_loop(t):
    style(t)
    fig, axs = plt.subplots(2, 2, figsize=(7.2, 5.6), sharey=True)
    open_panel(axs[0, 0], t, "open_p1_theta0", "(a) plant 1, $\\theta=0$")
    open_panel(axs[0, 1], t, "open_p2_theta0", "(b) plant 2, $\\theta=0$ ($L=0$)")
    open_panel(axs[1, 0], t, "open_p1_theta01", "(c) plant 1, $\\theta=0.1$ s")
    open_panel(axs[1, 1], t, "open_p2_theta01", "(d) plant 2, $\\theta=0.1$ s")
    for a in axs[:, 0]:
        a.set_ylabel("$x$, $y$")
    axs[0, 1].legend(loc="center right", bbox_to_anchor=(1.0, 0.62), fontsize=7.5)
    fig.tight_layout()
    save(fig, "fig2_10.png")


def fig_p_loop(t):
    style(t)
    fig, axs = plt.subplots(1, 2, figsize=(7.2, 2.8))
    for ax, tag, title, xmax in (
        (axs[0], "ploop_p1_ku", "(a) plant 1, $K_p=K_u$", 20),
        (axs[1], "ploop_p2_ku", "(b) plant 2, $K_p=K_u$", 6),
    ):
        d = load(tag)
        m = d["t_s"] <= xmax
        ax.plot(d["t_s"][m], d["y"][m], color=t["ku"], lw=1.4, label="$y(t)$")
        ax.axhline(1, color=t["ref"], ls="--", lw=0.9, label="setpoint $r$")
        y = d["y"]
        pk = [
            i
            for i in range(len(y) // 2, len(y) - 1)
            if y[i] > y[i - 1] and y[i] >= y[i + 1] and d["t_s"][i] <= xmax
        ]
        ax.plot(
            d["t_s"][pk],
            y[pk],
            "o",
            color=t["tan"],
            ms=3.5,
            label="peaks ($P_u$ apart)",
        )
        ax.set_xlim(0, xmax)
        ax.set_title(title)
        ax.set_xlabel("$t$ (s)")
    axs[0].set_ylabel("$y$")
    axs[0].legend(loc="lower right", fontsize=7.5)
    fig.tight_layout()
    save(fig, "fig2_11.png")


def closed_fig(t, plant, name, xmax):
    style(t)
    fig, axs = plt.subplots(2, 2, figsize=(7.2, 5.4), sharex="col")
    for col, m in enumerate((1, 2)):
        ay, au = axs[0, col], axs[1, col]
        ay.axhline(1, color=t["ref"], ls="--", lw=0.9, label="setpoint")
        for c in ("P", "PI", "PID"):
            d = load(f"cl_p{plant}_m{m}_{c.lower()}")
            n = clip(d)
            lab = c + (" (unstable)" if n < len(d["y"]) or grows(d["y"]) else "")
            ay.plot(
                d["t_s"][:n],
                d["y"][:n],
                color=t[c],
                lw=2.0 if c == "PID" else 1.4,
                label=lab,
            )
            au.plot(d["t_s"][:n], d["u"][:n], color=t[c], lw=2.0 if c == "PID" else 1.4)
        ay.set_title(f"({'ab'[col]}) Method {m}, output $y$")
        au.set_title(f"({'cd'[col]}) Method {m}, controller output $u$")
        au.set_xlabel("$t$ (s)")
        ay.set_xlim(0, xmax)
        ay.legend(loc="lower right", fontsize=7.5)
    axs[0, 0].set_ylabel("$y$")
    axs[1, 0].set_ylabel("$u$")
    fig.tight_layout()
    save(fig, name)


def readme(t, suffix):
    """Overview for the README: plant 1 reaction curve and PID closed loop."""
    style(t)
    fig, axs = plt.subplots(1, 2, figsize=(7.6, 2.9))
    open_panel(axs[0], t, "open_p1_theta01", "Method 1: tangent at the largest slope")
    axs[0].set_ylabel("$x$, $y$")
    axs[0].set_ylim(-0.08, 1.95)
    axs[0].legend(loc="upper right", fontsize=7, ncol=2)
    ax = axs[1]
    ax.axhline(1, color=t["ref"], ls="--", lw=0.9, label="setpoint")
    for m, c in ((1, t["PID"]), (2, t["P"])):
        d = load(f"cl_p1_m{m}_pid")
        ax.plot(d["t_s"], d["y"], color=c, lw=1.6, label=f"PID, Method {m}")
    ax.set_xlim(0, 25)
    ax.set_title("Plant 1, closed loop ($\\theta=0.1$ s)")
    ax.set_xlabel("$t$ (s)")
    ax.legend(loc="lower right", fontsize=7.5)
    fig.tight_layout()
    save(fig, f"zn-overview-{suffix}.png", IMG)


if __name__ == "__main__":
    fig1_1(LIGHT)
    fig1_2(LIGHT)
    fig_open_loop(LIGHT)
    fig_p_loop(LIGHT)
    closed_fig(LIGHT, 1, "fig2_12.png", 30)
    closed_fig(LIGHT, 2, "fig2_13.png", 6)
    readme(LIGHT, "light")
    readme(DARK, "dark")
    print("figures written")
