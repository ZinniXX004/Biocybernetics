## 2.2 Answer and Code Explanation

The program (Delphi 13, VCL) has a numerical unit `ZNModel.pas` without user-interface code, the main form `Unit1.pas` with one tab for Problems 1 and 2 and one tab for each ZN method, and the equation window `Unit2.pas`. The numerical unit is also compiled with Free Pascal and checked by an automatic test, so the numbers in this report come from the same code as the program. The listings below follow the order of the problems and keep the line numbers of the file.

### 2.2.1 Problem 1: Functions of the Plant Models

The transfer functions follow from the Laplace transform of Equation 1.1 and Equation 1.2 with zero initial conditions, where a derivative becomes a multiplication by $s$.

$$s^2Y+0.5sY+Y=X\ \Rightarrow\ \left(s^2+0.5s+1\right)Y=X\ \Rightarrow\ G_1(s)=\frac{Y}{X}=\frac{1}{s^2+0.5s+1} \qquad\qquad (2.1)$$

$$s^2Y+1.5sY+Y=2sX+X\ \Rightarrow\ \left(s^2+1.5s+1\right)Y=(2s+1)X\ \Rightarrow\ G_2(s)=\frac{2s+1}{s^2+1.5s+1} \qquad\qquad (2.2)$$

For plant 2 the transfer function is split into two steps. The input first drives an internal variable $Z$ through the denominator only, and the output is then the numerator applied to $Z$. Each step is written back in the time domain.

$$Z(s)=\frac{X(s)}{s^2+1.5s+1}\ \Leftrightarrow\ \ddot z=-1.5\dot z-z+x,\qquad Y(s)=(2s+1)Z(s)\ \Leftrightarrow\ y=z+2\dot z \qquad\qquad (2.3)$$

The two results are Equation 1.7 and Equation 1.8. To check that they describe the same plant as Equation 1.2, the derivatives of $y$ are formed and put into the left side of Equation 1.2. The terms in $z$ collect into Equation 1.7 and into its derivative, which equal $x$ and $\dot x$.

$$\ddot y+1.5\dot y+y=\left(\ddot z+1.5\dot z+z\right)+2\left(\dot{\ddot z}+1.5\ddot z+\dot z\right)=x+2\dot x \qquad\qquad (2.4)$$

This is exactly Equation 1.2, so the realisation is exact and never needs the derivative of the input. `Plant1Accel` and `Plant2Accel` return the accelerations of Equation 1.1 and Equation 1.7. `PlantOutput` forms $y$ with Equation 1.8, and `PlantOutputRate` forms $\dot y$ from the state, which is needed for the tangent of Method 1.

@@CODE ZNModel.pas Plant1Accel@@

@@CODE ZNModel.pas Plant2Accel@@

@@CODE ZNModel.pas PlantOutput@@

@@CODE ZNModel.pas PlantOutputRate@@

### 2.2.2 Problem 2: Fourth-Order Runge-Kutta Function

`RK4Step` is Equation 1.15 and Equation 1.16 with the plant passed as a function argument, so the same routine integrates plant 1 ($y$) and plant 2 ($z$). Each $k$ is half a step times an acceleration. The velocity is advanced with the weights 1, 2, 2, 1 and the position with the mean velocity of the step. The input $x$ is held constant during the step, as a digital controller does between two samples. The program example of the lecture also passes $x+\Delta t/2$ and $x+\Delta t$ to the input argument [@ce1]. That shift belongs to the general form $f(x,y,\dot y)$, where $x$ is the time, and is not used here because $x$ is the plant input.

@@CODE ZNModel.pas RK4Step@@

The accuracy was checked with the exact step response of plant 1, Equation 2.5, which follows from the inverse Laplace transform of $G_1(s)/s$ [@ogata]. Over 10 s with $\Delta t=1$ ms the largest difference between `RK4Step` and Equation 2.5 is $1.1\times10^{-14}$, so the numerical error is far below any effect discussed in this report.


$$y(t)=1-e^{-\zeta t}\left(\cos\omega_dt+\frac{\zeta}{\omega_d}\sin\omega_dt\right),\qquad \zeta=0.25,\ \ \omega_d=\sqrt{1-\zeta^2}=0.9682\ \text{rad/s} \qquad\qquad (2.5)$$

The impulse response of the first tab uses the same step. The lecture test applies $x=1$ during one step, which is a pulse of area $\Delta t$ [@ce1]. `SimulateImpulse` applies $x_0/\Delta t$ during one step instead, a pulse of area $x_0$, so that the output approaches the impulse response $g(t)$ of the transfer function, which for plant 1 is the time derivative of Equation 2.5. The difference from the exact $g(t)$ is below $5\times10^{-4}$ with $\Delta t=1$ ms.

@@CODE ZNModel.pas SimulateImpulse@@

### 2.2.3 Problem 3: Method 1 (Tangent, L and T)

For plant 1 the tangent can be found exactly. The slope of the step response is the impulse response, Equation 2.6. The slope is largest where its own derivative is zero, Equation 2.7, and the angle $\arccos\zeta$ gives $\sin(\omega_dt_m)=\omega_d$ and $\cos(\omega_dt_m)=\zeta$, which makes the next steps short.

$$\dot y(t)=\frac{1}{\omega_d}e^{-\zeta t}\sin\omega_dt \qquad\qquad (2.6)$$

$$\begin{array}{l}\ddot y(t)=\frac{e^{-\zeta t}}{\omega_d}\left(\omega_d\cos\omega_dt-\zeta\sin\omega_dt\right)=0\ \Rightarrow\ \tan\omega_dt_m=\frac{\omega_d}{\zeta}\\\omega_dt_m=\arccos\zeta\ \Rightarrow\ t_m=\frac{\arccos0.25}{0.9682}=\frac{1.3181}{0.9682}=1.3613\ \text{s}\end{array}\qquad\qquad (2.7)$$

$$R=\dot y(t_m)=\frac{1}{\omega_d}e^{-\zeta t_m}\,\omega_d=e^{-0.25\times1.3613}=0.7115\ \text{s}^{-1} \qquad\qquad (2.8)$$

$$y_m=y(t_m)=1-e^{-\zeta t_m}\left(\zeta+\frac{\zeta}{\omega_d}\,\omega_d\right)=1-2\zeta R=1-0.5\times0.7115=0.6442 \qquad\qquad (2.9)$$

$$L=t_m-\frac{y_m}{R}=1.3613-\frac{0.6442}{0.7115}=0.4559\ \text{s},\qquad T=\frac{K}{R}=\frac{1}{0.7115}=1.4054\ \text{s} \qquad\qquad (2.10)$$

For plant 2 the realisation of Equation 2.3 gives the slope at the start directly. Before the step $z=\dot z=0$, and right after it Equation 1.7 gives $\ddot z(0)=1$ and its derivative gives $\dot{\ddot z}(0)=-1.5$. Equation 1.8 then gives Equation 2.11.

$$\dot y(0)=\dot z+2\ddot z=0+2\times1=2,\qquad \ddot y(0)=\ddot z+2\dot{\ddot z}=1+2\times(-1.5)=-2<0 \qquad\qquad (2.11)$$

The output of plant 2 starts with its largest slope and bends down at once, so it has no inflection point and no S shape. The tangent goes through the origin, so $t_m=0$, $y_m=0$ and $L=0$, and every gain of Table 1.1 contains $1/L$. Method 1 therefore cannot be applied to plant 2 as given. A dead time only shifts the whole response to the right, Equation 2.12. The slope $R$ stays the same and the tangent moves by $\theta$, so $L$ grows by $\theta$. For $\theta=0.1$ s this gives $L=0.5559$ s for plant 1 and $L=0.1$ s for plant 2, and Method 1 becomes usable for both plants.

$$y_\theta(t)=y(t-\theta)\ \Rightarrow\ t_{m,\theta}=t_m+\theta,\quad R_\theta=R,\quad L_\theta=L+\theta \qquad\qquad (2.12)$$

`SimulateOpenLoop` applies the step through the dead-time buffer and integrates the plant. At every step it reads the slope from the state with `PlantOutputRate`, using the input that will act during the next step, and keeps the largest one. This avoids a finite difference, which would be inaccurate at the jump of plant 2. `ZNMethod1` then applies Equation 1.13 and rejects $L<\Delta t/2$ with an explanation, and `GainsMethod1` is Table 1.1.

@@CODE ZNModel.pas SimulateOpenLoop@@

@@CODE ZNModel.pas ZNMethod1@@

@@CODE ZNModel.pas GainsMethod1@@

### 2.2.4 Problem 3: Method 2 (Critical Gain Ku and Period Pu)

With $u=K_pe$ the closed loop of each plant follows from $1+K_pG(s)=0$, Equation 2.13. A second-order polynomial has both roots in the left half plane exactly when all its coefficients are positive [@ogata]. Both polynomials have positive coefficients for every $K_p>-1$, so the loop stays stable however large $K_p$ becomes. In other words $K_u$ does not exist. For plant 1 a larger $K_p$ only makes the oscillation faster ($\omega=\sqrt{1+K_p}$) while its damping falls, and for plant 2 the damping even grows, because $K_p$ also enters the middle coefficient through the zero.

$$s^2+0.5s+(1+K_p)=0,\qquad s^2+(1.5+2K_p)s+(1+K_p)=0 \qquad\qquad (2.13)$$

The same result follows from the phase. $G_1$ reaches a phase lag of 180° only at infinite frequency and $G_2$ never more than 90°, so Equation 1.14 has no solution. The dead time adds the lag $\omega\theta$, which grows without limit, so a crossing always exists for $\theta>0$. For $\theta=0.1$ s Equation 1.14 becomes Equation 2.14 and Equation 2.15, which are solved numerically in the program (scan and bisection).

$$\begin{array}{l}-\arctan\frac{0.5\omega_u}{1-\omega_u^2}-0.1\,\omega_u=-\pi\ \Rightarrow\ \omega_u=2.4293\ \text{rad/s}\\K_u=\sqrt{\left(1-\omega_u^2\right)^2+\left(0.5\omega_u\right)^2}=5.0495,\qquad P_u=\frac{2\pi}{\omega_u}=2.5865\ \text{s}\end{array}\qquad\qquad (2.14)$$

$$\begin{array}{l}\arctan2\omega_u-\arctan\frac{1.5\omega_u}{1-\omega_u^2}-0.1\,\omega_u=-\pi\ \Rightarrow\ \omega_u=16.3216\ \text{rad/s}\\K_u=\frac{\left|1-\omega_u^2+j1.5\omega_u\right|}{\left|1+j2\omega_u\right|}=8.1609,\qquad P_u=\frac{2\pi}{\omega_u}=0.3850\ \text{s}\end{array}\qquad\qquad (2.15)$$

The program also repeats the experiment of the slides by simulation. `PLoopGrows` runs the P loop and compares the swing of the output in the last quarter of the run with the quarter before. `ZNMethod2` searches the smallest growing gain by bisection on a logarithmic scale and measures the period from the oscillation at that gain. Without dead time this search still finds a "critical gain", but it is close to $1/\Delta t$ (Section 2.3.4). It comes from the step-by-step update of the controller and not from the plant, so it is reported but not used. `GainsMethod2` is Table 1.2.

@@CODE ZNModel.pas CriticalGainAnalytic@@

@@CODE ZNModel.pas PLoopGrows@@

@@CODE ZNModel.pas ZNMethod2@@

@@CODE ZNModel.pas GainsMethod2@@

### 2.2.5 Closed-Loop Simulation and Main Program

`SimulateClosedLoop` runs the loop of Figure 1.1 with the PID law of Equation 1.11 and computes the measures of Equation 1.17 from every step. It stops when $|y|$ exceeds 1000 times the setpoint and marks a loop as unstable when its oscillation keeps growing, so an unstable controller never crashes the program. The previous error starts at the first error, so the derivative term does not produce a spike of size $K_d/\Delta t$ at $t=0$.

@@CODE ZNModel.pas SimulateClosedLoop@@

In the main form each ZN tab follows the experiment of the slides. The Plant 1 and Plant 2 buttons identify the plant, fill R and L (Method 1) or $K_u$ and $P_u$ (Method 2), compute the gains of the selected controller and run the closed loop. All these values stay editable, so a new R, L, $K_u$, $P_u$, $K_p$, $K_i$ or $K_d$ can be typed and the closed loop rerun. `ZN1Identify` and `ZN1Gains` are the Method 1 part, `btnZN1Plant1Click` joins the steps, and `RunClosed`, shared by both tabs, checks the gains and simulates the loop. The lines that only fill charts and edit fields are omitted from the listings.

@@CODE Unit1.pas TForm1.ZN1Identify | ClearChart(chtZN1Curve); >> if not FZN1M.Valid then >> plot the step response and the tangent, show R and L || edtZN1Kp.Text := ''; >> Exit; >> clear the gains and the closed-loop outputs and warn with the reason@@

@@CODE Unit1.pas TForm1.ZN1Gains@@

@@CODE Unit1.pas TForm1.btnZN1Plant1Click@@

@@CODE Unit1.pas TForm1.RunClosed | ClearChart(AChtY); >> END >> plot y and u, show the measures of Equation 1.17, mark the loop as stable or UNSTABLE and warn@@

The form itself is built so that a wrong input or an unexpected event cannot stop the program. Every chart holds only the series it always shows, and its legend is fixed in the form. The first version drew the impulse and the step response in one chart and hid the empty series of the legend after each run, which raised an access violation while the legend showed check boxes, so the first tab now has a Runge Kutta Output chart for the impulse response and a separate chart for the step response. Unexpected errors reach `AppException`, which appends them to a log file next to the program and shows the same error at most once every 2 s, so an error raised while a chart is painted cannot open one dialog after another. Over a chart the mouse wheel zooms at the cursor, a drag box zooms into a region, the right button pans and a double click restores the full view, and every new run starts with the full view. The colour of each panel header shows its role, blue for buttons, green for values that can be edited, red to orange for the message log, teal for computed values, slate for help and indigo for the closed-loop performance.

@@CODE Unit1.pas TForm1.AppException@@

### 2.2.6 Choice of the Simulation Parameters

The parameters of the program are chosen so that the results show the plants and not the computer. The dead time $\theta=0.1$ s is the only addition to the problem sheet. It is needed because without it Method 2 has no critical gain and Method 1 has $L=0$ for plant 2 (Sections 2.2.3 and 2.2.4). The value represents the delay between a stimulation command and the resulting muscle force, which is 30 ms to 100 ms for the electromechanical delay alone [@emd], and the lecture reports such a delay in FES knee control [@ce2]. A delay of 0.1 s is short compared with the time scale of both plants (1 s), so the plants keep their own character, and $\theta=0$ can still be selected to see the plants exactly as given.

The step $\Delta t=1$ ms is the value of the lecture program [@ce1]. It is more than a thousand times shorter than the period of plant 1 and gives an integration error of $10^{-14}$, so making it smaller changes nothing visible. The run lasts 30 s, which covers about five periods of plant 1 and is long enough for the slowest stable loop to settle. The search for $K_u$ always uses at least 40 s, because its growth test compares two windows of a quarter run each and each window must contain more than one period of the slowest oscillation (about 6.5 s). A step and a setpoint of height 1 keep all gains in the units of the tables. The settling band of ±2 % is the usual choice in control textbooks [@ogata]. A loop counts as unstable when its swing grows by more than 0.1 % between the two windows, and an unstable curve is drawn only until it leaves three times the setpoint, so that it does not hide the other curves.
