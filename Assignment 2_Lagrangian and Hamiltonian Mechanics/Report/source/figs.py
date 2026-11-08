"""Figures of the Assignment 2 report.

Figure 1.1 (Hamilton's principle) and Figure 1.2 (coordinates) are drawn
here; Figures 2.1 and 2.2 are plotted from the CSV files written by the
Delphi numerical core:

    cd ../../Program/Verification
    fpc -Fu.. TestPendulum.dpr && ./TestPendulum --csv ../../Report/source/data

Colours: blue = Lagrange, orange (dashed) = Hamilton, as in the program.
"""

import csv
import math
import sys
from pathlib import Path

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402
import numpy as np  # noqa: E402

HERE = Path(__file__).resolve().parent
DATA = HERE / "data"
FIG = HERE / "fig"
IMG = HERE.parent.parent / "docs" / "img"

LIGHT = {
    "surface": "#fcfcfb",
    "ink": "#0b0b0b",
    "ink2": "#52514e",
    "grid": "#e4e3df",
    "s": ["#2a78d6", "#eb6834", "#1baf7a", "#eda100"],
}
DARK = {
    "surface": "#1a1a19",
    "ink": "#f0efec",
    "ink2": "#c3c2b7",
    "grid": "#383835",
    "s": ["#3987e5", "#d95926", "#199e70", "#c98500"],
}
G, M, LEN = 9.81, 1.0, 1.0  # same values as the program presets


def style(theme):
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
            "figure.facecolor": theme["surface"],
            "axes.facecolor": theme["surface"],
            "savefig.facecolor": theme["surface"],
            "text.color": theme["ink"],
            "axes.labelcolor": theme["ink"],
            "axes.edgecolor": theme["ink2"],
            "xtick.color": theme["ink2"],
            "ytick.color": theme["ink2"],
            "axes.grid": True,
            "grid.color": theme["grid"],
            "grid.linewidth": 0.6,
            "axes.spines.top": False,
            "axes.spines.right": False,
            "legend.frameon": False,
        }
    )


def load(tag):
    rows = list(csv.DictReader(open(DATA / f"{tag}.csv", encoding="utf-8")))
    return {k: np.array([float(r[k]) for r in rows]) for k in rows[0]}


def alpha_deg(theta):
    return np.degrees(np.pi - theta)


def headroom(ax, frac=0.35):
    """Free space above the curves for a legend at the top."""
    lo, hi = ax.get_ylim()
    ax.set_ylim(lo, hi + frac * (hi - lo))


def save(fig, name, where=FIG):
    where.mkdir(parents=True, exist_ok=True)
    fig.savefig(where / name, dpi=300, bbox_inches="tight")
    plt.close(fig)
    trim(where / name)


def trim(path, pad=24):
    """Crop the uniform surface margin that 3D axes leave around a figure."""
    from PIL import Image

    img = Image.open(path).convert("RGB")
    arr = np.asarray(img).astype(int)
    bg = arr[0, 0]
    mask = np.abs(arr - bg).sum(axis=2) > 30
    rows, cols = np.where(mask.any(axis=1))[0], np.where(mask.any(axis=0))[0]
    if rows.size == 0:
        return
    box = (
        max(cols[0] - pad, 0),
        max(rows[0] - pad, 0),
        min(cols[-1] + pad, arr.shape[1]),
        min(rows[-1] + pad, arr.shape[0]),
    )
    img.crop(box).save(path)


def fig1_1(th):
    """Hamilton's principle: actual and varied paths; action S(eps)."""
    w = 2.0
    t1, t2 = 0.0, 1.2
    t = np.linspace(t1, t2, 400)
    q = np.sin(w * t)
    eta = np.sin(np.pi * (t - t1) / (t2 - t1))
    fig, (a, b) = plt.subplots(
        1, 2, figsize=(7.2, 2.8), gridspec_kw={"width_ratios": [1.35, 1]}
    )
    a.plot(t, q, color=th["s"][0], label="actual path $q(t)$")
    for k, e in enumerate((0.25, -0.2)):
        a.plot(
            t,
            q + e * eta,
            "--",
            color=th["s"][1 + k],
            lw=1.2,
            label=rf"varied path $q+\epsilon\eta$, $\epsilon={e:+.2f}$",
        )
    a.plot([t1, t2], [q[0], q[-1]], "o", color=th["ink"], ms=5)
    a.annotate(
        r"$(t_1,q_1)$",
        (t1, q[0]),
        xytext=(4, -12),
        textcoords="offset points",
        fontsize=9,
    )
    a.annotate(
        r"$(t_2,q_2)$",
        (t2, q[-1]),
        xytext=(-12, -18),
        textcoords="offset points",
        fontsize=9,
    )
    i = 200
    a.annotate(
        "",
        xy=(t[i], q[i] + 0.25 * eta[i]),
        xytext=(t[i], q[i]),
        arrowprops={"arrowstyle": "->", "color": th["ink2"], "lw": 1},
    )
    a.text(t[i] + 0.02, q[i] + 0.1, r"$\delta q=\epsilon\eta(t)$", fontsize=9)
    a.set_xlabel("$t$ (s)")
    a.set_ylabel("$q$")
    a.set_title("(a) paths with fixed end points")
    a.legend(loc="lower center", fontsize=7.5)
    eps = np.linspace(-0.6, 0.6, 121)
    dt = t[1] - t[0]
    s_vals = []
    for e in eps:
        qq = q + e * eta
        qd = np.gradient(qq, dt)
        lag = 0.5 * qd**2 - 0.5 * w**2 * qq**2
        s_vals.append(np.trapezoid(lag, t))
    s_vals = np.array(s_vals)
    b.plot(eps, s_vals, color=th["s"][0])
    b.plot([0], [s_vals[60]], "o", color=th["s"][1], ms=6)
    b.annotate(
        r"$\delta S=0$ at $\epsilon=0$",
        (0, s_vals[60]),
        xytext=(8, 14),
        textcoords="offset points",
        fontsize=9,
    )
    b.set_xlabel(r"$\epsilon$")
    b.set_ylabel(r"$S(\epsilon)=\int L\,dt$")
    b.set_title("(b) action of the varied paths")
    fig.tight_layout()
    save(fig, "fig1_1.png")


def fig1_2(th):
    """Coordinates of the spherical pendulum (theta from +z as in the assignment)."""
    from mpl_toolkits.mplot3d import Axes3D  # noqa: F401

    fig = plt.figure(figsize=(5.0, 4.4))
    ax = fig.add_subplot(111, projection="3d")
    ax.set_facecolor(th["surface"])
    th0, ph0 = np.radians(140), np.radians(35)
    bob = np.array([np.sin(th0) * np.cos(ph0), np.sin(th0) * np.sin(ph0), np.cos(th0)])
    for vec, lab in (
        ((1.15, 0, 0), "$x$"),
        ((0, 1.15, 0), "$y$"),
        ((0, 0, 0.6), "$z$"),
    ):
        ax.quiver(0, 0, 0, *vec, color=th["ink"], arrow_length_ratio=0.08, lw=1)
        ax.text(*(1.07 * np.array(vec)), lab, fontsize=11)
    ax.plot([0, 0], [0, 0], [0, -1.1], ":", color=th["ink2"], lw=1)
    u = np.linspace(0, 2 * np.pi, 60)
    v = np.linspace(np.pi / 2, np.pi, 20)
    xs = np.outer(np.cos(u), np.sin(v))
    ys = np.outer(np.sin(u), np.sin(v))
    zs = np.outer(np.ones_like(u), np.cos(v))
    ax.plot_wireframe(xs, ys, zs, color=th["grid"], lw=0.4, rstride=3, cstride=3)
    ax.plot([0, bob[0]], [0, bob[1]], [0, bob[2]], color=th["s"][0], lw=2.4)
    ax.scatter(*bob, s=90, color=th["s"][1], depthshade=False, zorder=5)
    ax.plot(
        [bob[0], bob[0]], [bob[1], bob[1]], [0, bob[2]], "--", color=th["ink2"], lw=1
    )
    ax.plot([0, bob[0]], [0, bob[1]], [0, 0], "--", color=th["s"][2], lw=1.4)
    ax.text(
        bob[0] + 0.12,
        bob[1] + 0.05,
        0.1,
        r"$\rho=l\sin\theta$",
        color=th["s"][2],
        fontsize=10,
    )
    ax.text(bob[0] + 0.05, bob[1], bob[2] * 0.62, r"$z=l\cos\theta$", fontsize=10)
    ax.text(*(bob * 0.55 + [0.02, 0.0, 0.05]), "$l$", color=th["s"][0], fontsize=12)
    ax.text(*(bob + [0.06, 0.02, -0.1]), "$m$", fontsize=12)
    a_th = np.linspace(0, th0, 40)
    ax.plot(
        0.25 * np.sin(a_th) * np.cos(ph0),
        0.25 * np.sin(a_th) * np.sin(ph0),
        0.25 * np.cos(a_th),
        color=th["s"][3],
        lw=1.4,
    )
    ax.text(0.12, 0.12, 0.25, r"$\theta$", color=th["ink"], fontsize=12)
    a_al = np.linspace(th0, np.pi, 20)
    ax.plot(
        0.45 * np.sin(a_al) * np.cos(ph0),
        0.45 * np.sin(a_al) * np.sin(ph0),
        0.45 * np.cos(a_al),
        color=th["s"][1],
        lw=1.4,
    )
    ax.text(0.05, 0.12, -0.55, r"$\alpha=\pi-\theta$", fontsize=10)
    a_ph = np.linspace(0, ph0, 30)
    ax.plot(
        0.35 * np.cos(a_ph), 0.35 * np.sin(a_ph), 0 * a_ph, color=th["s"][3], lw=1.4
    )
    ax.text(0.42, 0.05, 0.03, r"$\varphi$", fontsize=12)
    ax.quiver(*bob, 0, 0, -0.35, color=th["ink2"], arrow_length_ratio=0.25, lw=1)
    ax.text(bob[0] + 0.04, bob[1], bob[2] - 0.38, r"$m\mathbf{g}$", fontsize=10)
    ax.set_xlim(-0.8, 0.8)
    ax.set_ylim(-0.8, 0.8)
    ax.set_zlim(-1.1, 0.6)
    ax.set_box_aspect((1, 1, 1.05))
    ax.view_init(elev=18, azim=-58)
    ax.set_axis_off()
    save(fig, "fig1_2.png")


def fig2_1(th):
    """Planar swing, 10 deg and 90 deg: theta of both methods (program chart 1)."""
    fig, axs = plt.subplots(1, 2, figsize=(7.2, 2.7))
    for ax, tag, a0, lab in ((axs[0], "planar10", 10, "a"), (axs[1], "planar90", 90, "b")):
        d = load(tag)
        ax.plot(d["t"], np.degrees(d["theta"]), color=th["s"][0], lw=2.2, label="Lagrange")
        ax.plot(d["t"], np.degrees(d["theta_H"]), "--", color=th["s"][1], lw=1.3, label="Hamilton")
        ax.set_xlim(0, 8)
        ax.set_xlabel("$t$ (s)")
        ax.set_ylabel(r"$\theta$ (deg)")
        ax.set_title(fr"({lab}) $\alpha_0={a0}^\circ$")
        headroom(ax)
        ax.legend(loc="upper center", ncol=2)
    fig.tight_layout()
    save(fig, "fig2_1.png")


def fig2_2(th, where=FIG, name="fig2_2.png"):
    """General motion: the four charts of the program window."""
    d = load("general")
    t = d["t"]
    fig, axs = plt.subplots(2, 2, figsize=(7.4, 5.4))
    a, b, c, e = axs[0, 0], axs[0, 1], axs[1, 0], axs[1, 1]
    a.plot(t, np.degrees(d["theta"]), color=th["s"][0], lw=2.2, label="Lagrange")
    a.plot(t, np.degrees(d["theta_H"]), "--", color=th["s"][1], lw=1.2, label="Hamilton")
    a.set_title(r"(a) position $\theta(t)$")
    a.set_ylabel(r"$\theta$ (deg)")
    headroom(a)
    a.legend(loc="upper center", ncol=2)
    b.plot(t, d["thetadot"], color=th["s"][0], label=r"$\dot\theta$")
    b.plot(t, d["phidot"], color=th["s"][1], label=r"$\dot\varphi$")
    b.set_title("(b) velocity (Lagrange)")
    b.set_ylabel("rad/s")
    headroom(b)
    b.legend(loc="upper center", ncol=2)
    c.plot(t, d["p_theta"], color=th["s"][0], label=r"$p_\theta$")
    c.plot(t, d["p_phi"], color=th["s"][1], label=r"$p_\varphi$ (constant)")
    c.set_title("(c) momentum (Hamilton)")
    c.set_ylabel(r"kg m$^2$/s")
    headroom(c)
    c.legend(loc="upper center", ncol=2)
    for ax in (a, b, c):
        ax.set_xlim(0, 10)
        ax.set_xlabel("$t$ (s)")
    e.plot(d["x"], d["y"], color=th["s"][2], lw=1.0)
    e.set_aspect("equal")
    e.set_title("(d) path seen from above")
    e.set_xlabel("$x$ (m)")
    e.set_ylabel("$y$ (m)")
    fig.tight_layout()
    save(fig, name, where)


def readme_images():
    for name, th in (("light", LIGHT), ("dark", DARK)):
        style(th)
        fig2_2(th, IMG, f"results-{name}.png")
        style(th)
        fig1_2(th)
        (FIG / "fig1_2.png").replace(IMG / f"coordinates-{name}.png")


def main():
    readme_images()
    style(LIGHT)
    fig1_1(LIGHT)
    fig1_2(LIGHT)
    fig2_1(LIGHT)
    fig2_2(LIGHT)
    print("figures written to", FIG, "and", IMG)


if __name__ == "__main__":
    main()
