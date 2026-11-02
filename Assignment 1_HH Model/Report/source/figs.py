"""Figures for the Assignment 1 report (chapter-numbered file names).

Chapter I: crops of the rendered LaTeX sheets and model-derived plots.
Chapter II: crops of the program screenshots supplied by the student.
"""

import os

import matplotlib
import numpy as np
from PIL import Image

matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402

UP = "/root/.claude/uploads/419a7d5c-30f0-5694-9f39-7a05076c32be/"
SH = "/home/claude/a1/sheets/"
os.makedirs("fig", exist_ok=True)


def crop(src, box, dst):
    im = Image.open(src).convert("RGB").crop(box)
    im.save("fig/" + dst)
    return im.size


sizes = {}
# Chapter I
sizes["fig1_1"] = crop(SH + "sheet1_membrane.png", (60, 128, 940, 428), "fig1_1.png")
sizes["fig1_3"] = crop(SH + "sheet4_cable.png", (30, 135, 930, 415), "fig1_3.png")


# Figure 1.2: steady states and time constants (HH 1952 rate constants)
def er(x):
    x = np.asarray(x, float)
    out = np.empty_like(x)
    s = np.abs(x) < 1e-6
    out[~s] = x[~s] / np.expm1(x[~s])
    out[s] = 1 - x[s] / 2
    return out


vm = np.linspace(-100, 50, 601)
v = -(vm + 70)
am, bm = er(0.1 * v + 2.5), 4 * np.exp(v / 18)
ah, bh = 0.07 * np.exp(v / 20), 1 / (np.exp(0.1 * v + 3) + 1)
an, bn = 0.1 * er(0.1 * v + 1), 0.125 * np.exp(v / 80)
plt.rcParams.update(
    {
        "font.family": "serif",
        "font.size": 10,
        "axes.grid": True,
        "grid.color": "#E6E6E6",
    }
)
fig, ax = plt.subplots(1, 2, figsize=(8.6, 3.2))
for a, b, lab, c in (
    (am, bm, "m", "#D55E00"),
    (ah, bh, "h", "#E69F00"),
    (an, bn, "n", "#0072B2"),
):
    ax[0].plot(vm, a / (a + b), color=c, lw=1.8, label=f"${lab}_\\infty$")
    ax[1].semilogy(vm, 1 / (a + b), color=c, lw=1.8, label=f"$\\tau_{lab}$")
ax[0].set(xlabel="$V_m$ (mV)", ylabel="steady state (-)", title="(a) $x_\\infty(V_m)$")
ax[1].set(
    xlabel="$V_m$ (mV)", ylabel="time constant (ms)", title="(b) $\\tau_x(V_m)$, 6.3 °C"
)
for a_ in ax:
    a_.axvline(-70, color="#999999", lw=0.8, ls="--")
    a_.legend(frameon=False)
fig.tight_layout()
fig.savefig("fig/fig1_2.png", dpi=200)
plt.close(fig)

# Figure 1.4: FTCS stencil
fig, ax = plt.subplots(figsize=(6.0, 3.0))
for j in range(5):
    for n in range(3):
        ax.plot(j, n, "o", color="#BBBBBB", ms=7)
for j, n in ((1, 1), (2, 1), (3, 1)):
    ax.plot(j, n, "o", color="#0072B2", ms=12)
ax.plot(2, 2, "s", color="#D55E00", ms=13)
for j, n in ((1, 1), (2, 1), (3, 1)):
    ax.annotate(
        "",
        xy=(2, 1.88),
        xytext=(j, n + 0.1),
        arrowprops=dict(arrowstyle="->", color="#555555", lw=1.2),
    )
labels = {(1, 1): "$v_{j-1}^{n}$", (2, 1): "$v_{j}^{n}$", (3, 1): "$v_{j+1}^{n}$"}
for (j, n), t in labels.items():
    ax.text(j, n - 0.32, t, ha="center", fontsize=12)
ax.text(2.18, 2.08, "$v_{j}^{n+1}$", fontsize=12)
ax.set_xticks(range(5), ["$x_{j-2}$", "$x_{j-1}$", "$x_j$", "$x_{j+1}$", "$x_{j+2}$"])
ax.set_yticks(range(3), ["$t^{n-1}$", "$t^{n}$", "$t^{n+1}$"])
ax.set_xlim(-0.5, 4.5)
ax.set_ylim(-0.6, 2.6)
ax.annotate("", xy=(4.4, -0.45), xytext=(3.4, -0.45), arrowprops=dict(arrowstyle="<->"))
ax.text(3.9, -0.38, "$h$", ha="center")
ax.annotate("", xy=(4.3, 2), xytext=(4.3, 1), arrowprops=dict(arrowstyle="<->"))
ax.text(4.36, 1.45, "$k$")
ax.grid(False)
for s in ax.spines.values():
    s.set_visible(False)
fig.tight_layout()
fig.savefig("fig/fig1_4.png", dpi=200)
plt.close(fig)

# Chapter II (screenshots)
S = {
    "apg_v2": UP + "044236d9-image.png",
    "ref_v2": UP + "3fc198fe-image.png",
    "isi_v2": UP + "7c0410a4-image.png",
    "app_v2": UP + "979b966c-image.png",
    "phase_v4": UP + "5d2479fd-image.png",
    "app_v4": UP + "9c247b8c-image.png",
    "sheet1_v4": UP + "046eb3a5-image.png",
    "sheet4_v4": UP + "c70d274c-image.png",
}
sizes["fig2_1"] = crop(S["apg_v2"], (0, 0, 1917, 1078), "fig2_1.png")
sizes["fig2_2"] = crop(S["sheet1_v4"], (713, 38, 1750, 1002), "fig2_2.png")
sizes["fig2_3"] = crop(S["apg_v2"], (420, 95, 1917, 1060), "fig2_3.png")
sizes["fig2_4"] = crop(S["phase_v4"], (0, 175, 1917, 1035), "fig2_4.png")
sizes["fig2_5"] = crop(S["ref_v2"], (0, 95, 1917, 1060), "fig2_5.png")
sizes["fig2_6"] = crop(S["isi_v2"], (0, 95, 1917, 1060), "fig2_6.png")
sizes["fig2_7"] = crop(S["sheet4_v4"], (860, 15, 1895, 980), "fig2_7.png")
sizes["fig2_8"] = crop(S["app_v4"], (0, 105, 1917, 640), "fig2_8.png")
sizes["fig2_9a"] = crop(S["app_v2"], (420, 640, 1917, 1060), "fig2_9a.png")
sizes["fig2_9b"] = crop(S["app_v4"], (430, 655, 1917, 1052), "fig2_9b.png")
for k, v_ in sizes.items():
    print(k, v_)
