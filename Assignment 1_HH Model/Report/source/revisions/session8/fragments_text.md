@@FRAG P54@@

For a cylindrical axon of radius $a$ and axoplasm resistivity $R_i$, the per-length quantities are $r_i=R_i/(\pi a^2)$, $c_m=2\pi a\,C_m$ and $i_{ion}=2\pi a\,J_{ion}$, so that $i_{ion}/c_m=J_{ion}/C_m$ [5]. In the passive cable $J_{ion}=g_m v$ and a steady input decays along the axon with the length constant $\lambda=\left[2\pi a\,g_m\left(r_o+r_i\right)\right]^{-1/2}$, such a cable cannot regenerate a signal. In the active cable $J_{ion}=J_{Na}+J_K+J_L$, so the depolarization that diffuses from an excited region into its neighbour opens the sodium conductance there and regenerates the full action potential. This is why an action potential travels at constant amplitude and constant velocity, and Hodgkin and Huxley showed that the velocity scales with $\sqrt{a}$ and computed 18.8 m/s for their squid axon at 18.5 °C, against 21.2 m/s measured [1]. The lecture slide writes the coefficient of the second derivative as $\left[(r_o+r_i)C_m\right]^{-1}$, where $C_m$ is the membrane capacitance per unit length (given there as $1.6\times10^{-9}$ mF/mm), which is the same $D=\left[(r_o+r_i)c_m\right]^{-1}$ as in Equation (1.16).

@@FRAG P59AFTER@@

The lecturer's propagation code also contains a Crank-Nicolson variant, which averages the central difference over the old and the new time level. This trapezoidal rule is unconditionally stable and second-order accurate in time for the diffusion term, but it requires a tridiagonal system to be solved at every time step [6]. The program offers both schemes, and the Crank-Nicolson form is derived as an extension of Problem 2 in Section 2.2.3.

@@FRAG P79@@

The main window has six tabs: (1) APG with RK4, (2) gating phase plots, (3) refractory period, (4) C-F converter (Jin versus inter-pulse interval), (5) APP with the cable equation and (6) model parameters and equations. Every tab has a Clear button that removes its charts and results while keeping the parameters. Figure 2.1 shows the first tab and Figure 2.2 one of the derivation windows that are opened from the main form. All routines listed below are complete and are presented in the order of the problems in Section 2.1 and, within each problem, in the order in which they appear in the source files.

@@FRAG P177AFTER@@

**Relation to the lecture slide.** The explicit update (2.16) with the passive membrane current is exactly the final expression of the lecture slide "Partial Differential Equation Solution", written there with $v_m(x\pm h,t)$ for $v_{j\pm1}^n$ and $v_m(x,t+k)$ for $v_j^{n+1}$: $v_m(x,t+k)=v_m(x,t)+\frac{k}{h^2}\left[v_m(x+h,t)-2v_m(x,t)+v_m(x-h,t)\right]\left[(r_o+r_i)C_m\right]^{-1}-k\,g_m v_m C_m^{-1}$, with $C_m$ and $g_m$ per unit length. The slide omits the brackets around the second difference, so that the factor $\left[(r_o+r_i)C_m\right]^{-1}$ seems to multiply only $v_m(x-h,t)$, but the derivation shows that it multiplies the whole difference, and the slide repeats the last line twice. Equation (2.17) is therefore the result asked for in Problem 2, and Equation (2.16) is its generalization to the active membrane.

**Step 8, Crank-Nicolson extension.** The lecturer's code and the senior's program also use a Crank-Nicolson form. Replacing the central difference in Equation (2.15) by the average of the levels $n$ and $n+1$, while the membrane and stimulus terms stay at level $n$, gives

::: {custom-style="Highlighted Equation"}
$$-\frac{r}{2}v_{j-1}^{n+1}+\left(1+r\right)v_j^{n+1}-\frac{r}{2}v_{j+1}^{n+1}=v_j^n+\frac{r}{2}\left(v_{j+1}^n-2v_j^n+v_{j-1}^n\right)+\frac{k}{C_m}\left(J_{in,j}^n-J_{ion,j}^n\right) \qquad\qquad (2.21a)$$
:::

which couples the three unknowns of each row and is solved for all nodes at once with the Thomas algorithm for tridiagonal systems (the sealed ends again double the off-diagonal coefficient of the first and last row). The same von Neumann analysis gives

::: {custom-style="Highlighted Equation"}
$$\xi=\frac{1-2r\sin^2\left(\beta h/2\right)}{1+2r\sin^2\left(\beta h/2\right)},\qquad \left|\xi\right|\le1\ \text{for every}\ r>0 \qquad\qquad (2.21b)$$
:::

so the Crank-Nicolson scheme has no stability limit on $k$. (The transcribed lecturer code writes this average inside the explicit loop, using values of level $n+1$ that are not yet computed, the program solves the tridiagonal system instead.) When the axon is driven by the APG waveform, node 0 is not computed but set to $v_0^n=v_{APG}(t^n)$, which replaces the sealed-end condition at $x=0$ in both schemes.

@@FRAG P179@@

`DefaultCableParams` sets the squid giant axon of Hodgkin and Huxley [1] ($a=238$ µm, $R_i=35.4$ Ω·cm, $r_o\approx0$ for a large external bath), a 6 cm axon with $h=1$ mm, $k=0.01$ ms, a 12 ms run and one stimulus pulse of $-150$ µA/cm² for 0.5 ms applied to the first 2 mm, with the explicit scheme. `SimulateCable` is the implementation of Section 2.2.3. It validates the geometry and the excitation, computes $r_i$, $c_m$, $D$ (with the factor 1000 that converts cm²/µs into cm²/ms), the diffusion number $r$ and the passive length constant, and stops before integrating if Equation (2.21) is violated by the explicit scheme. It then sets every node to the resting state and marches in time: for every node it forms the central difference of Equation (2.12), using the sealed-end form of Equation (2.19) at $j=0$ and $j=N-1$, it evaluates $J_{ion}$ either from the HH currents with the node's own gates, which are advanced by Equation (2.18), or as $g_m v$ in the passive mode, and it writes the new voltage of Equation (2.16) into a second array, so that the whole new level is computed from level $n$ only, as the explicit scheme requires. With the Crank-Nicolson option the same loop fills the right-hand side of Equation (2.21a) and `SolveTridiagonal` computes the new level. The excitation is either a train of current pulses (`PulseOn`) or the APG waveform imposed on node 0. After each step it records the peak $V_m$ and the first upward 0 mV crossing of every node, interpolated linearly between the two time levels that bracket it, and stores a frame for plotting. Finally, the conduction velocity is computed from the crossing times at 25 % and 75 % of the axon length:

@@FRAG P185@@

On the form, `FillAPPEditor` fills the parameter table with lengths in millimetres, and the two preset buttons select either the squid axon (`btnPresetSquidClick`: active cable, one current pulse) or the lecturer's setting (`btnPresetLecturerClick`, values from `LecturerCableParams`), which is also the default when the program starts. The lecturer's simulation uses a passive 2 mm cable with $dx=0.4$ mm and $dt=10$ µs that is driven at $x=0$ by the action potentials of the APG model, so the preset sets the passive mode, the APG waveform as excitation, a 60 ms run and recording sites at 0, 0.4, ..., 2.0 mm. A radius of 5 µm gives a passive length constant of about 1 mm and an attenuation over 2 mm of the size seen in the lecturer's result. A squid axon conducting at about 12 m/s with an action potential lasting about 2 ms produces a wave about 2.4 cm long, so a 2 mm squid axon would be shorter than the action potential itself, which is why the squid preset uses a 6 cm axon. `btnRunAPPClick` reads the parameters, converts millimetres to centimetres, builds the APG waveform with the tab-1 protocol (`BuildAPGStimulus` and `SimulateAPG` with the cable time step) when it is selected as excitation, calls `SimulateCable`, reports a violated stability condition together with $k_{max}$, and then calls `PlotCable` (Vm(t) at evenly spaced recording sites and Vm(x) at evenly spaced instants), `ReportCable` (excitation, scheme, cable constants, $r$, $\lambda$, $\theta$ and a table of peak voltages and crossing times) and `UpdateAPPFrame`, which moves the time cursor, the bold Vm(x) profile and the overlay of the space-time view when the time slider or the Play button changes the frame. The space-time view offers a heat map, a 3D waterfall and a 3D mesh of $V_m(x,t)$. `OpenSheet` and `ShowEquationSheet` open the derivation windows described in Section 2.2.1.

@@FRAG P362@@

Table 2.5 summarizes the parameter variations. Halving the spatial step to 0.5 mm (with a smaller time step to keep $r\le0.5$) changes the velocity by less than 2 %, which agrees with the second-order spatial accuracy of the scheme. Raising the temperature to 18.5 °C increases the velocity to 18.2 m/s, against 18.8 m/s calculated and 21.2 m/s measured by Hodgkin and Huxley [1], the agreement with their calculation is within about 3 %. In the passive mode no action potential appears: the depolarization decays from $-35.2$ mV at the stimulated end to $-68.1$ mV at 15 mm, in line with the computed length constant of 7.0 mm, which demonstrates that propagation requires the regenerative sodium current. A thin active fibre of 1 µm radius on a 2 mm axon propagates at about 0.78 m/s, consistent with $\theta\propto\sqrt{a}$. A step larger than $k_{max}$ is rejected by the program with the message predicted by Equation (2.21). Figure 2.8 shows the space-time behaviour in the 3D views, where the propagating action potential appears as a straight ridge in the $(x,t)$ plane whose slope is the inverse of the velocity, and Figure 2.9 shows the derivation window of the cable equation opened from the same tab.

@@FRAG CELL374@@

Thin active fibre, $a=1$ µm, 2 mm, $h=0.1$ mm

@@FRAG P381@@

Compared with the reference programs, the results differ in two respects that are intended. The senior's propagation program updates the voltage with a pure diffusion term and an arbitrarily chosen coefficient applied to a stored APG trace, without any membrane current, so its signal can only spread and decay, the active cable of this work regenerates the action potential at every node and therefore propagates without decrement, which is what Problem 3 asks the model to exhibit. The lecturer's program, in contrast, solves the passive cable equation driven by the APG output, which the lecturer-scale preset reproduces (Figure 2.10), while the squid-axon preset was added because its velocity can be checked against the 1952 paper.

@@FRAG P381AFTER@@

Figure 2.10 shows the lecturer-scale preset. The APG model, driven by $J_{in}=-10$ µA/cm² from 1 ms, fires at 2.91, 17.84, 32.49 and 47.12 ms, and these four action potentials are imposed at $x=0$. Along the passive cable each of them appears as a separate wave that becomes smaller and broader with distance: the peaks at 0, 0.4, 0.8, 1.2, 1.6 and 2.0 mm are 35.3, $-9.5$, $-32.7$, $-45.0$, $-50.4$ and $-51.9$ mV, with a passive length constant of 1.02 mm. The repeated ridges in the 3D views are therefore successive action potentials in time on one axon, not several axons, which is the same picture as in the lecturer's and the senior's plots. The Crank-Nicolson scheme gives the same peaks within 0.1 mV at this grid ($r=0.044$). Its advantage appears at larger diffusion numbers: for the squid axon with $h=0.5$ mm and $k=0.01$ ms ($r=1.345$) the explicit scheme is refused, whereas the Crank-Nicolson scheme runs and gives 12.12 m/s, within 1 % of the explicit result with a four times smaller step (12.25 m/s). With the active membrane and the same APG drive on a 0.1 mm grid ($r=0.71$, Crank-Nicolson), every wave is regenerated and travels at 1.95 m/s. A train of three current pulses 15 ms apart likewise produces three propagating action potentials at 12.04 m/s on the squid axon.

::: {custom-style="Figure"}
**[Insert screenshot: tab 5 with the "Lecturer scale (2 mm)" preset, passive cable, excitation "APG waveform (tab 1)", 3D mesh view]**
:::

::: {custom-style="Caption Text"}
**Figure 2.10.** Tab 5, lecturer-scale preset: passive 2 mm cable driven at $x=0$ by the APG waveform of tab 1 ($J_{in}=-10$ µA/cm²), Vm(t) at 0 to 2.0 mm and the space-time view of the four attenuated waves.
:::

@@FRAG P385@@

Several limitations must be kept in mind. The explicit FTCS scheme is only first-order accurate in time and is stable only for $r\le1/2$, so fine spatial grids require small time steps, the Crank-Nicolson option removes this restriction for the diffusion term, while the membrane term remains explicit. The sealed-end boundary raises the peak at the far end, and spikes are defined by a 0 mV crossing, so graded responses below 0 mV are not counted. Three discrepancies in the lecture material were identified and handled explicitly: the time step printed as "10 sec" (10 µs), the term $0.1(v+2.5)$ printed in $\alpha_m$ instead of $0.1(v+25)$, and the node index of the leakage term in the transcribed propagation code. In addition, the final line of the slide lacks the brackets around the second difference. In each case the program follows the derivation and the original paper, and offers the lecturer's integration method for direct comparison.

@@FRAG P388@@

The integration of the cable equation was derived with a central difference in space and a forward difference in time, giving the explicit update $v_j^{n+1}=v_j^n+r(v_{j+1}^n-2v_j^n+v_{j-1}^n)+k(J_{in}-J_{ion})/C_m$ with $r=k/[(r_o+r_i)c_mh^2]$ and the stability condition $r\le1/2$, which for the passive membrane is the final expression of the lecture slide, and a Crank-Nicolson variant removes the stability limit. Implemented with an HH membrane at every node, the scheme shows a regenerating action potential that travels at constant amplitude and at 12.0 m/s for the squid axon at 6.3 °C (18.2 m/s at 18.5 °C, close to the 18.8 m/s calculated by Hodgkin and Huxley), whereas the passive cable driven by the APG waveform, as in the lecturer's program, carries each action potential as a wave that decays within about 1 mm. Propagation is therefore exhibited by the combination of axial current flow and the regenerative sodium current.
