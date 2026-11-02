"""Passive (and active) cable driven at x = 0 by the APG waveform of a step
Jin = -10 uA/cm2 (Dirichlet boundary), explicit FTCS or Crank-Nicolson.
Prints the peak Vm at the six lecturer recording sites 0, 0.4, ..., 2.0 mm."""

import sys

import numpy as np

GNA, GK, GL, VNA, VK, VL = 120.0, 36.0, 0.3, -115.0, 12.0, -10.613


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


def gates0():
    am, bm, ah, bh, an, bn = rates(np.zeros(1))
    return am / (am + bm), ah / (ah + bh), an / (an + bn)


def apg_trace(J, ton, toff, tend, dt):
    def f(y, j):
        v, m, h, n = y
        am, bm, ah, bh, an, bn = [float(np.ravel(q)[0]) for q in rates(np.array([v]))]
        jion = GNA * m**3 * h * (v - VNA) + GK * n**4 * (v - VK) + GL * (v - VL)
        return np.array(
            [
                j - jion,
                am * (1 - m) - bm * m,
                ah * (1 - h) - bh * h,
                an * (1 - n) - bn * n,
            ]
        )

    m0, h0, n0 = [float(q[0]) for q in gates0()]
    y = np.array([0.0, m0, h0, n0])
    out = [0.0]
    jf = lambda t: J if ton <= t < toff else 0.0
    for k in range(int(round(tend / dt))):
        t = k * dt
        k1 = f(y, jf(t))
        k2 = f(y + dt / 2 * k1, jf(t + dt / 2))
        k3 = f(y + dt / 2 * k2, jf(t + dt / 2))
        k4 = f(y + dt * k3, jf(t + dt))
        y = y + dt / 6 * (k1 + 2 * k2 + 2 * k3 + k4)
        out.append(y[0])
    return np.array(out)


def thomas(a, b, c, d):
    n = len(d)
    cp, dp = np.zeros(n), np.zeros(n)
    cp[0], dp[0] = c[0] / b[0], d[0] / b[0]
    for i in range(1, n):
        den = b[i] - a[i] * cp[i - 1]
        cp[i] = c[i] / den if i < n - 1 else 0.0
        dp[i] = (d[i] - a[i] * dp[i - 1]) / den
    x = np.zeros(n)
    x[-1] = dp[-1]
    for i in range(n - 2, -1, -1):
        x[i] = dp[i] - cp[i] * x[i + 1]
    return x


def cable(a_um, L, dx, dt, drive, active, scheme, gm=0.6773):
    a = a_um * 1e-4
    ri = 35.4 / (np.pi * a * a)
    cml = 2 * np.pi * a
    D = 1000 / (ri * cml)
    r = D * dt / dx**2
    N = int(round(L / dx)) + 1
    v = np.zeros(N)
    m0, h0, n0 = gates0()
    m, h, n = np.full(N, m0), np.full(N, h0), np.full(N, n0)
    pk = np.full(N, -70.0)
    for k in range(len(drive) - 1):
        v[0] = drive[k]
        vg = np.concatenate(([v[1]], v, [v[-2]]))
        lap = vg[:-2] - 2 * v + vg[2:]
        if active:
            am, bm, ah, bh, an, bn = rates(v)
            jion = GNA * m**3 * h * (v - VNA) + GK * n**4 * (v - VK) + GL * (v - VL)
            m = m + dt * (am * (1 - m) - bm * m)
            h = h + dt * (ah * (1 - h) - bh * h)
            n = n + dt * (an * (1 - n) - bn * n)
        else:
            jion = gm * v
        if scheme == "ftcs":
            v = v + r * lap - dt * jion
        else:
            rhs = v + 0.5 * r * lap - dt * jion
            A = np.full(N, -0.5 * r)
            B = np.full(N, 1 + r)
            C = np.full(N, -0.5 * r)
            C[0] = -r
            A[-1] = -r
            # Dirichlet node 0
            B[0], C[0], rhs[0] = 1.0, 0.0, drive[k + 1]
            v = thomas(A, B, C, rhs)
        v[0] = drive[k + 1]
        pk = np.maximum(pk, -(v + 70))
    sites = [int(round(i * (N - 1) / 5)) for i in range(6)]
    return r, pk[sites].round(1)


if __name__ == "__main__":
    dt = 0.01
    drv = apg_trace(-10.0, 1.0, 61.0, 60.0, dt)
    for a in (1.0, 2.0, 5.0):
        for dx in (0.04, 0.01):
            for active in (False, True):
                for sch in ("ftcs", "cn"):
                    if active and dx == 0.04:
                        continue
                    r, pk = cable(a, 0.2, dx, dt, drv, active, sch)
                    print(
                        f"a={a} dx={dx * 10}mm {'active' if active else 'passive'} {sch} r={r:.4f} peaks={pk}"
                    )
        sys.stdout.flush()
