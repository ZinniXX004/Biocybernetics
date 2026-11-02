### 2.2.3 Problem 2: Derivation of the APP Integration with Central and Forward Differences

**Step 1, the partial differential equation.** Consider the segment between $x$ and $x+\Delta x$ of the transmission line in Figure 1.3. The axial current $i(x,t)$ flows through the internal and external resistances $r_i\Delta x$ and $r_o\Delta x$ in series, so Ohm's law gives the voltage drop along the segment, and dividing by $\Delta x$ and letting $\Delta x\to0$ gives the axial voltage gradient:

$$v(x+\Delta x,t)-v(x,t)=-\,i(x,t)\left(r_o+r_i\right)\Delta x\ \ \Rightarrow\ \ \frac{\partial v}{\partial x}=-\left(r_o+r_i\right)i \qquad\qquad (2.5)$$

At the node, the axial current that leaves the segment is smaller than the current that enters it by the membrane current $i_m\Delta x$ that crosses the membrane, which consists of a capacitive and an ionic part (Kirchhoff's current law):

$$i(x+\Delta x,t)-i(x,t)=-\,i_m\Delta x\ \ \Rightarrow\ \ \frac{\partial i}{\partial x}=-\left(c_m\frac{\partial v}{\partial t}+i_{ion}\right) \qquad\qquad (2.6)$$

Differentiating Eq. (2.5) with respect to $x$ (with $r_o$ and $r_i$ uniform along the axon) and substituting Eq. (2.6) eliminates the axial current:

::: {custom-style="Highlighted Equation"}
$$\frac{\partial^2 v}{\partial x^2}=-\left(r_o+r_i\right)\frac{\partial i}{\partial x}=\left(r_o+r_i\right)\left(c_m\frac{\partial v}{\partial t}+i_{ion}\right) \qquad\qquad (2.7)$$
:::

Solving for the time derivative, adding the stimulus and using $i_{ion}/c_m=J_{ion}/C_m$ (both per-length quantities contain the factor $2\pi a$) gives the explicit form that is integrated by the program:

::: {custom-style="Highlighted Equation"}
$$\frac{\partial v}{\partial t}=\frac{1}{\left(r_o+r_i\right)c_m}\frac{\partial^2 v}{\partial x^2}+\frac{J_{in}-J_{ion}}{C_m}=D\frac{\partial^2 v}{\partial x^2}+\frac{J_{in}-J_{ion}}{C_m} \qquad\qquad (2.8)$$
:::

with $J_{ion}=J_{Na}+J_K+J_L$ for the active cable and $J_{ion}=g_m v$ for the passive (lecturer's RC) cable.

**Step 2, central difference for the spatial derivative.** On the grid $x_j=jh$, $t^n=nk$, write the Taylor series of $v$ about $x_j$ at a fixed time level $n$ for a step $+h$ and a step $-h$:

$$v_{j+1}^n=v_j^n+h\,v_x+\frac{h^2}{2}v_{xx}+\frac{h^3}{6}v_{xxx}+\frac{h^4}{24}v_{xxxx}+O(h^5) \qquad\qquad (2.9)$$

$$v_{j-1}^n=v_j^n-h\,v_x+\frac{h^2}{2}v_{xx}-\frac{h^3}{6}v_{xxx}+\frac{h^4}{24}v_{xxxx}+O(h^5) \qquad\qquad (2.10)$$

Adding the two series cancels all odd derivatives:

$$v_{j+1}^n+v_{j-1}^n=2v_j^n+h^2v_{xx}+\frac{h^4}{12}v_{xxxx}+O(h^6) \qquad\qquad (2.11)$$

and solving for $v_{xx}$ gives the central difference with a truncation error of second order in $h$:

::: {custom-style="Highlighted Equation"}
$$\left.\frac{\partial^2 v}{\partial x^2}\right|_j^n=\frac{v_{j+1}^n-2v_j^n+v_{j-1}^n}{h^2}-\frac{h^2}{12}v_{xxxx}\approx\frac{v_{j+1}^n-2v_j^n+v_{j-1}^n}{h^2} \qquad\qquad (2.12)$$
:::

**Step 3, forward difference for the time derivative.** The Taylor series in time at node $j$ is

$$v_j^{n+1}=v_j^n+k\,v_t+\frac{k^2}{2}v_{tt}+O(k^3) \qquad\qquad (2.13)$$

so the forward difference is accurate to first order in $k$:

::: {custom-style="Highlighted Equation"}
$$\left.\frac{\partial v}{\partial t}\right|_j^n=\frac{v_j^{n+1}-v_j^n}{k}-\frac{k}{2}v_{tt}\approx\frac{v_j^{n+1}-v_j^n}{k} \qquad\qquad (2.14)$$
:::

**Step 4, substitution and the explicit update.** Substituting Eq. (2.12) and (2.14) into Eq. (2.8) at the point $(x_j,t^n)$ and evaluating the membrane current at the known level $n$ gives

$$\frac{v_j^{n+1}-v_j^n}{k}=D\,\frac{v_{j+1}^n-2v_j^n+v_{j-1}^n}{h^2}+\frac{J_{in,j}^n-J_{ion,j}^n}{C_m} \qquad\qquad (2.15)$$

and, multiplying by $k$, the explicit update used by the program:

::: {custom-style="Highlighted Equation"}
$$v_j^{n+1}=v_j^n+r\left(v_{j+1}^n-2v_j^n+v_{j-1}^n\right)+\frac{k}{C_m}\left(J_{in,j}^n-J_{ion,j}^n\right),\qquad r=\frac{Dk}{h^2}=\frac{k}{\left(r_o+r_i\right)c_m h^2} \qquad\qquad (2.16)$$
:::

For the passive cable of the lecture, $J_{ion,j}^n=g_m v_j^n$ and Eq. (2.16) becomes

$$v_j^{n+1}=v_j^n+\frac{k}{h^2\left(r_o+r_i\right)c_m}\left(v_{j+1}^n-2v_j^n+v_{j-1}^n\right)-\frac{k\,g_m}{C_m}v_j^n \qquad\qquad (2.17)$$

in which the leakage term uses the voltage of the same node $j$. (The transcribed lecturer code uses `vm[0,i]`, the voltage of the first node, in this term; this is most likely a transcription error and was not reproduced.) The local truncation error of the scheme is the sum of the two neglected terms, $\tau_j^n=-\tfrac{k}{2}v_{tt}-D\tfrac{h^2}{12}v_{xxxx}=O(k+h^2)$.

**Step 5, gates of the active cable.** In the active cable every node carries its own gates, which are advanced with the same forward difference applied to Eq. (1.5), using the voltage of level $n$:

::: {custom-style="Highlighted Equation"}
$$x_j^{n+1}=x_j^n+k\left[\alpha_x\!\left(v_j^n\right)\left(1-x_j^n\right)-\beta_x\!\left(v_j^n\right)x_j^n\right],\qquad x\in\{m,h,n\} \qquad\qquad (2.18)$$
:::

**Step 6, boundary conditions.** The ends of the axon are sealed, which means that no axial current leaves the axon there. By Eq. (2.5) this is $\partial v/\partial x=0$. With a central difference across the boundary this condition introduces ghost nodes $v_{-1}^n=v_1^n$ and $v_N^n=v_{N-2}^n$, and substituting them into Eq. (2.16) gives the end-node updates

::: {custom-style="Highlighted Equation"}
$$v_0^{n+1}=v_0^n+2r\left(v_1^n-v_0^n\right)+\frac{k}{C_m}\left(J_{in}-J_{ion}\right)_0^n,\qquad v_{N-1}^{n+1}=v_{N-1}^n+2r\left(v_{N-2}^n-v_{N-1}^n\right)+\frac{k}{C_m}\left(J_{in}-J_{ion}\right)_{N-1}^n \qquad\qquad (2.19)$$
:::

**Step 7, stability.** Inserting a single Fourier mode $v_j^n=\xi^n e^{\mathrm{i}\beta jh}$ into the diffusion part of Eq. (2.16) gives the amplification factor

$$\xi=1+r\left(e^{\mathrm{i}\beta h}-2+e^{-\mathrm{i}\beta h}\right)=1+r\left(2\cos\beta h-2\right)=1-4r\sin^2\frac{\beta h}{2} \qquad\qquad (2.20)$$

Since $0\le\sin^2(\beta h/2)\le1$, $\xi$ lies between $1-4r$ and 1, and the requirement $|\xi|\le1$ for every wave number reduces to $1-4r\ge-1$:

::: {custom-style="Highlighted Equation"}
$$r=\frac{Dk}{h^2}\le\frac{1}{2}\qquad\Longleftrightarrow\qquad k\le k_{max}=\frac{h^2}{2D} \qquad\qquad (2.21)$$
:::

For the squid axon of Problem 3 ($a=238$ µm, $R_i=35.4$ Ω·cm, $r_o=0$), $r_i=R_i/(\pi a^2)=19{,}893$ Ω/cm and $c_m=2\pi aC_m=0.1495$ µF/cm. Because 1 Ω·µF = 1 µs, $D=1/(r_ic_m)=3.362\times10^{-4}$ cm²/µs $=0.3362$ cm²/ms, and with $h=1$ mm and $k=0.01$ ms the diffusion number is $r=0.336<0.5$; the largest stable step at this $h$ is $k_{max}=0.0149$ ms. These numbers are reproduced exactly in the result memo of the program (Figure 2.7). The derivation of this section is also available in the program as sheet 5 ("Central/forward difference (Problem 2)"), opened from tab 5 or tab 6.

### 2.2.4 Problem 3: Program for Action Potential Propagation

`DefaultCableParams` sets the squid giant axon of Hodgkin and Huxley [1] ($a=238$ µm, $R_i=35.4$ Ω·cm, $r_o\approx0$ for a large external bath), a 6 cm axon with $h=1$ mm, $k=0.01$ ms, a 12 ms run and a stimulus of $-150$ µA/cm² for 0.5 ms applied to the first 2 mm. `SimulateCable` is the implementation of Section 2.2.3. It validates the geometry, computes $r_i$, $c_m$, $D$ (with the factor 1000 that converts cm²/µs into cm²/ms), the diffusion number $r$ and the passive length constant, and stops before integrating if Eq. (2.21) is violated. It then sets every node to the resting state and marches in time: for every node it forms the central difference of Eq. (2.12), using the sealed-end form of Eq. (2.19) at $j=0$ and $j=N-1$; it evaluates $J_{ion}$ either from the HH currents with the node's own gates, which are advanced by Eq. (2.18), or as $g_m v$ in the passive mode; and it writes the new voltage of Eq. (2.16) into a second array, so that the whole new level is computed from level $n$ only, as the explicit scheme requires. After each step it records the peak $V_m$ and the first upward 0 mV crossing of every node, interpolated linearly between the two time levels that bracket it, and stores a frame for plotting. Finally, the conduction velocity is computed from the crossing times at 25 % and 75 % of the axon length:

::: {custom-style="Highlighted Equation"}
$$\theta=\frac{x_{75\%}-x_{25\%}}{t_c\!\left(x_{75\%}\right)-t_c\!\left(x_{25\%}\right)}\cdot10\ \text{m/s}\qquad\left(1\ \text{cm/ms}=10\ \text{m/s}\right) \qquad\qquad (2.22)$$
:::

Measuring between the 25 % and 75 % points keeps both the stimulated region and the sealed end, where the action potential is distorted, out of the velocity estimate.

@@CODE HHModel DefaultCableParams@@

@@CODE HHModel SimulateCable@@

The model exhibits propagation because of the coupling term $D\,\partial^2v/\partial x^2$ together with the regenerative membrane current. When node $j$ fires, its depolarization makes the central difference at node $j+1$ negative (in the lecturer's sign), so Eq. (2.16) drives $v_{j+1}$ toward depolarization. As soon as the neighbour reaches threshold, its own sodium current takes over and produces a full action potential, which in turn depolarizes node $j+2$. The wave therefore travels with constant amplitude, set by the membrane, and at a constant velocity, set by how fast the axial current can charge the next segment, that is by $D$ and the membrane kinetics. In the passive mode the same coupling only spreads and attenuates the stimulated depolarization with the length constant $\lambda$, and no action potential appears away from the stimulation site. Comparing both modes in the same program is the direct demonstration asked for in Problem 3.

On the form, `FillAPPEditor` fills the parameter table with lengths in millimetres, and the two preset buttons select either the squid axon (`btnPresetSquidClick`) or a lecturer-scale fibre (`btnPresetLecturerClick`). The lecturer's and the senior's programs show a 2 mm axon. A squid axon conducting at about 12 m/s with an action potential lasting about 2 ms produces a wave about 2.4 cm long, so a 2 mm squid axon would be shorter than the action potential itself. The lecturer-scale preset therefore uses the same equations with a thin fibre ($a=1$ µm, 2 mm, $h=0.1$ mm, recording sites every 0.4 mm), whereas the squid preset is kept as the default because its velocity can be compared with the 1952 measurements. `btnRunAPPClick` reads the parameters, converts millimetres to centimetres, calls `SimulateCable`, reports a violated stability condition together with $k_{max}$, and then calls `PlotCable` (Vm(t) at evenly spaced recording sites and Vm(x) at evenly spaced instants), `ReportCable` (cable constants, $r$, $\lambda$, $\theta$ and a table of peak voltages and crossing times) and `UpdateAPPFrame`, which moves the time cursor, the bold Vm(x) profile and the overlay of the space-time view when the time slider or the Play button changes the frame. The space-time view offers a heat map, a 3D waterfall and a 3D mesh of $V_m(x,t)$. `OpenSheet` and `ShowEquationSheet` open the derivation windows described in Section 2.2.1.

@@CODE Unit1 TForm1.FillAPPEditor@@

@@CODE Unit1 TForm1.btnPresetSquidClick@@

@@CODE Unit1 TForm1.btnPresetLecturerClick@@

@@CODE Unit1 TForm1.btnRunAPPClick@@

@@CODE Unit1 TForm1.PlotCable@@

@@CODE Unit1 TForm1.ReportCable@@

@@CODE Unit1 TForm1.UpdateAPPFrame@@

@@CODE Unit1 TForm1.OpenSheet@@

@@CODE EquationViewer ShowEquationSheet@@
