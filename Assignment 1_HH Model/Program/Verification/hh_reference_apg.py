"""Independent Python reference for the APG part of HHModel.pas.

Coupled RK4 on [v, m, h, n], dt = 0.01 ms, HH (1952) sign convention
(depolarization negative, Vm = -(v + 70) mV). Prints spike counts and
inter-spike intervals for constant Jin levels, the lecturer staircase and a
paired-pulse test. Used to cross-check the Delphi/FPC implementation.
"""

import numpy as np

gNa, gK, gL = 120, 36, 0.3
ENa, EK, EL = -115, 12, -10.613
Cm = 1.0


def rates(v):
    am = 0.1 * (v + 25) / (np.exp(0.1 * v + 2.5) - 1) if abs(v + 25) > 1e-7 else 1.0
    bm = 4 * np.exp(v / 18)
    ah = 0.07 * np.exp(v / 20)
    bh = 1 / (np.exp(0.1 * v + 3) + 1)
    an = 0.01 * (v + 10) / (np.exp(0.1 * v + 1) - 1) if abs(v + 10) > 1e-7 else 0.1
    bn = 0.125 * np.exp(v / 80)
    return am, bm, ah, bh, an, bn


def f(y, jin):
    v, m, h, n = y
    am, bm, ah, bh, an, bn = rates(v)
    jion = gNa * m**3 * h * (v - ENa) + gK * n**4 * (v - EK) + gL * (v - EL)
    return np.array(
        [
            (jin - jion) / Cm,
            am * (1 - m) - bm * m,
            ah * (1 - h) - bh * h,
            an * (1 - n) - bn * n,
        ]
    )


def run(jinf, T, dt=0.01):
    am, bm, ah, bh, an, bn = rates(0.0)
    y = np.array([0, am / (am + bm), ah / (ah + bh), an / (an + bn)])
    N = int(T / dt)
    out = np.zeros((N, 5))
    for i in range(N):
        t = i * dt
        j = jinf(t)
        k1 = f(y, j)
        k2 = f(y + dt / 2 * k1, jinf(t + dt / 2))
        k3 = f(y + dt / 2 * k2, jinf(t + dt / 2))
        k4 = f(y + dt * k3, jinf(t + dt))
        y = y + dt / 6 * (k1 + 2 * k2 + 2 * k3 + k4)
        out[i] = [t + dt, -(y[0] + 70), *y[1:]]
    return out


def spikes(o):
    vm = o[:, 1]
    idx = [
        i
        for i in range(1, len(vm) - 1)
        if vm[i] > 0 and vm[i] >= vm[i - 1] and vm[i] > vm[i + 1]
    ]
    return o[idx, 0]


def step(J):
    """Step current J (uA/cm2) from t = 1 ms, as in TestHH.dpr."""
    return lambda t: J if t >= 1 else 0


def staircase(t):
    """Lecturer staircase -5/-10/-20 uA/cm2."""
    return -5 if t < 25 else (-10 if t < 38 else (-20 if t < 50 else 0))


def pp(J, dur, delay):
    return run(
        lambda t: J if (1 <= t < 1 + dur) or (1 + delay <= t < 1 + delay + dur) else 0,
        delay + 30,
    )


if __name__ == "__main__":
    am, bm, ah, bh, an, bn = rates(0.0)
    m0, h0, n0 = am / (am + bm), ah / (ah + bh), an / (an + bn)
    print(
        "m0,h0,n0",
        m0,
        h0,
        n0,
        "jion(0)",
        gNa * m0**3 * h0 * 115 + gK * n0**4 * (-12) + gL * 10.613,
    )
    for J in [-2, -3, -5, -7, -10, -20, -40, -100]:
        o = run(step(J), 100)
        s = spikes(o)
        isi = np.diff(s)
        print(
            J,
            len(s),
            "ISI last=%.3f" % isi[-1] if len(isi) > 1 else "",
            "peak Vm=%.1f" % o[:, 1].max(),
        )
    o = run(staircase, 61)
    print("lecturer spikes", np.round(spikes(o), 2))
    for d in [2, 4, 6, 8, 10, 12, 15, 20]:
        print("delay", d, "spikes (J2 = J1 = -40 uA/cm2)", len(spikes(pp(-40, 0.5, d))))
