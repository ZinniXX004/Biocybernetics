"""Independent Python reference for the APP (cable) part of HHModel.pas.

Explicit FTCS scheme: central difference in x, forward difference in t,
sealed ends, HH membrane at every node (active) or gm*v (passive).
Prints D, r = D*k/h^2, conduction velocity and peak Vm along the axon.
"""

import numpy as np, sys

gNa, gK, gL = 120, 36, 0.3
ENa, EK, EL = -115, 12, -10.613
Cm = 1.0


def er(x):
    x = np.asarray(x, float)
    out = np.empty_like(x)
    s = np.abs(x) < 1e-4
    out[~s] = x[~s] / np.expm1(x[~s])
    out[s] = 1 - x[s] / 2 + x[s] ** 2 / 12
    return out


def rates(v):
    return (
        er(0.1 * v + 2.5),
        4 * np.exp(v / 18),
        0.07 * np.exp(v / 20),
        1 / (np.exp(0.1 * v + 3) + 1),
        0.1 * er(0.1 * v + 1),
        0.125 * np.exp(v / 80),
    )


def cable(
    a_um=238,
    Ri=35.4,
    ro=0,
    L=6.0,
    dx=0.1,
    dt=0.01,
    T=12,
    J=-100,
    dur=0.5,
    Ls=0.2,
    active=True,
    gm=0.677,
):
    a = a_um * 1e-4
    ri = Ri / (np.pi * a * a)
    cml = Cm * 2 * np.pi * a
    D = 1000 / ((ri + ro) * cml)
    r = D * dt / dx**2
    N = int(round(L / dx)) + 1
    x = np.arange(N) * dx
    am, bm, ah, bh, an, bn = rates(np.zeros(1))
    v = np.zeros(N)
    m = np.full(N, am / (am + bm))
    h = np.full(N, ah / (ah + bh))
    n = np.full(N, an / (an + bn))
    stim = x < Ls - 1e-9 if Ls > 0 else x <= 0
    tc = np.full(N, np.nan)
    pk = np.full(N, -1e9)
    vmprev = -(v + 70)
    for k in range(int(round(T / dt))):
        t = k * dt
        jin = np.where(stim & (t < dur), J, 0.0)
        vg = np.concatenate(([v[1]], v, [v[-2]]))
        lap = (vg[:-2] - 2 * v + vg[2:]) / dx**2
        if active:
            am, bm, ah, bh, an, bn = rates(v)
            jion = gNa * m**3 * h * (v - ENa) + gK * n**4 * (v - EK) + gL * (v - EL)
            m = m + dt * (am * (1 - m) - bm * m)
            h = h + dt * (ah * (1 - h) - bh * h)
            n = n + dt * (an * (1 - n) - bn * n)
        else:
            jion = gm * v
        v = v + dt * (D * lap + (jin - jion) / Cm)
        vm = -(v + 70)
        up = (vmprev < 0) & (vm >= 0) & np.isnan(tc)
        tc[up] = t + dt
        pk = np.maximum(pk, vm)
        vmprev = vm
    i1, i2 = int(0.25 * (N - 1)), int(0.75 * (N - 1))
    vel = (x[i2] - x[i1]) / (tc[i2] - tc[i1]) * 10
    lam = np.sqrt(1 / (gm * 1e-3 * 2 * np.pi * a * (ri + ro)))
    return dict(
        D=D,
        r=r,
        N=N,
        vel=vel,
        lam=lam,
        pk=pk[[0, i1, N // 2, i2, N - 1]].round(1),
        tc=tc[[0, i1, i2, N - 1]].round(3),
    )


if __name__ == "__main__":
    for dx in [0.1, 0.05]:
        dt = 0.01 if dx >= 0.1 else 0.0025
        print("active dx", dx, cable(dx=dx, dt=dt))
    print("passive", cable(active=False))
    # weaker stimuli on the 2 mm stimulated segment stay below threshold
    for J in [-20, -50]:
        print("J", J, cable(J=J)["pk"])
