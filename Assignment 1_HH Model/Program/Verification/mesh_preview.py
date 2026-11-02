"""Python port of TForm1.DrawMesh (Unit1.pas v4) to check the painter's
order and the look of the 3D mesh before compiling in Delphi.

Usage: python3 mock_mesh.py <out.png> <radius_um> <length_cm> <dx_cm> <tend_ms> <yaw> <pitch>
"""

import math
import sys

import numpy as np
from matplotlib import colormaps
from PIL import Image, ImageDraw

out, a_um, L, dx, tend, yaw, pitch, Ls = sys.argv[1], *map(float, sys.argv[2:9])
gNa, gK, gL = 120, 36, 0.3
ENa, EK, EL = -115, 12, -10.613


def er(x):
    o = np.empty_like(x)
    s = np.abs(x) < 1e-4
    o[~s] = x[~s] / np.expm1(x[~s])
    o[s] = 1 - x[s] / 2
    return o


def rates(v):
    return (
        er(0.1 * v + 2.5),
        4 * np.exp(v / 18),
        0.07 * np.exp(v / 20),
        1 / (np.exp(0.1 * v + 3) + 1),
        0.1 * er(0.1 * v + 1),
        0.125 * np.exp(v / 80),
    )


a = a_um * 1e-4
ri = 35.4 / (np.pi * a * a)
D = 1000 / (ri * 2 * np.pi * a)
dt = 0.01
N = int(round(L / dx)) + 1
x = np.arange(N) * dx
am, bm, ah, bh, an, bn = rates(np.zeros(1))
v = np.zeros(N)
m = np.full(N, am / (am + bm))
h = np.full(N, ah / (ah + bh))
n = np.full(N, an / (an + bn))
steps = int(round(tend / dt))
save = max(1, steps // 600)
F, T = [np.full(N, -70.0)], [0.0]
for k in range(steps):
    t = k * dt
    jin = np.where((x < Ls - 1e-9) & (t < 0.5), -150.0, 0.0)
    vg = np.concatenate(([v[1]], v, [v[-2]]))
    lap = (vg[:-2] - 2 * v + vg[2:]) / dx**2
    am, bm, ah, bh, an, bn = rates(v)
    jion = gNa * m**3 * h * (v - ENa) + gK * n**4 * (v - EK) + gL * (v - EL)
    m += dt * (am * (1 - m) - bm * m)
    h += dt * (ah * (1 - h) - bh * h)
    n += dt * (an * (1 - n) - bn * n)
    v = v + dt * (D * lap + (jin - jion))
    if (k + 1) % save == 0:
        F.append(-(v + 70))
        T.append((k + 1) * dt)
F, T = np.array(F), np.array(T)
NS = len(T)

W, H = 930, 300
img = Image.new("RGB", (W, H), "white")
dr = ImageDraw.Draw(img)
VBASE, VSPAN, VLO, VHI = -0.45, 0.9, -80.0, 50.0
cA, sA = math.cos(math.radians(yaw)), math.sin(math.radians(yaw))
cB, sB = math.cos(math.radians(pitch)), math.sin(math.radians(pitch))
scale = min(W * 0.36, H * 0.6)
cx, cy = W // 2, H // 2 + 16
vir = colormaps["viridis"]


def proj(tn, xn, vn):
    x1 = tn * cA + xn * sA
    z1 = -tn * sA + xn * cA
    return (cx + round(scale * x1), cy - round(scale * (vn * cB + z1 * sB)))


def vnorm(vm):
    return VBASE + VSPAN * min(max((vm - VLO) / (VHI - VLO), 0), 1)


def col(vm):
    r, g, b, _ = vir(min(max((vm - VLO) / (VHI - VLO), 0), 1))
    return (int(r * 255), int(g * 255), int(b * 255))


ns = max(1, math.ceil((N - 1) / 45))
fs = max(1, math.ceil((NS - 1) / 90))
nodes = sorted(set(list(range(0, N, ns)) + [N - 1]))
frames = sorted(set(list(range(0, NS, fs)) + [NS - 1]))
G = [
    [proj(2 * T[f] / T[-1] - 1, 2 * x[j] / x[-1] - 1, vnorm(F[f, j])) for f in frames]
    for j in nodes
]
for p0, p1, lab in (
    (proj(-1, -1, VBASE), proj(1, -1, VBASE), "t"),
    (proj(-1, -1, VBASE), proj(-1, 1, VBASE), "x (mm)"),
    (proj(-1, -1, VBASE), proj(-1, -1, VBASE + VSPAN), "Vm"),
):
    dr.line([p0, p1], fill=(85, 85, 85))
    dr.text((p1[0] + 4, p1[1] - 6), lab, fill=(85, 85, 85))
row_up, col_up = cA < 0, sA > 0
for i in range(len(nodes) - 1):
    r = i if row_up else len(nodes) - 2 - i
    for jj in range(len(frames) - 1):
        c = jj if col_up else len(frames) - 2 - jj
        q = [G[r][c], G[r][c + 1], G[r + 1][c + 1], G[r + 1][c]]
        vm = 0.25 * (
            F[frames[c], nodes[r]]
            + F[frames[c + 1], nodes[r]]
            + F[frames[c + 1], nodes[r + 1]]
            + F[frames[c], nodes[r + 1]]
        )
        dr.polygon(q, fill="white", outline=col(vm))
dr.text(
    (16, 6),
    f"3D mesh of Vm(x, t)  yaw {yaw:.0f} pitch {pitch:.0f}  ({len(nodes)} x {len(frames)})",
    fill=(0, 0, 0),
)
img.save(out)
print(out, "N", N, "frames", NS, "mesh", len(nodes), len(frames))
