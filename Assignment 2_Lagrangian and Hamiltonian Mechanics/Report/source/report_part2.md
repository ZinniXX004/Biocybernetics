## 2.2 Answer and Code Explanation

Each derivation is written as equations only, step by step from the known quantities, and a short explanation follows each block. The final results are highlighted in yellow.

### 2.2.1 Problem 1 (Hamilton's Principle and the Lagrange Equation)

The coordinate is written as $q=\theta$. The actual path $q(t)$ between the fixed instants $t_1$ and $t_2$ is compared with neighbouring paths that start and end at the same points, where $\epsilon$ is a small number and $\eta(t)$ is any smooth function.

$$\tilde q(t)=q(t)+\epsilon\,\eta(t),\qquad \dot{\tilde q}(t)=\dot q(t)+\epsilon\,\dot\eta(t),\qquad \eta(t_1)=\eta(t_2)=0 \qquad\qquad (2.1)$$

$$
\begin{array}{l}
S(\epsilon)=\int_{t_1}^{t_2}L\left(q+\epsilon\eta,\ \dot q+\epsilon\dot\eta,\ t\right)dt\\
L\left(q+\epsilon\eta,\ \dot q+\epsilon\dot\eta,\ t\right)=L(q,\dot q,t)+\epsilon\left(\frac{\partial L}{\partial q}\,\eta+\frac{\partial L}{\partial\dot q}\,\dot\eta\right)+O(\epsilon^2)
\end{array}
$$

$$\delta S=\epsilon\left.\frac{dS}{d\epsilon}\right|_{\epsilon=0}=\epsilon\int_{t_1}^{t_2}\left(\frac{\partial L}{\partial q}\,\eta+\frac{\partial L}{\partial\dot q}\,\dot\eta\right)dt \qquad\qquad (2.2)$$

$$u=\frac{\partial L}{\partial\dot q},\quad dv=\dot\eta\,dt\quad\Rightarrow\quad du=\frac{d}{dt}\!\left(\frac{\partial L}{\partial\dot q}\right)dt,\quad v=\eta$$

$$\int_{t_1}^{t_2}\frac{\partial L}{\partial\dot q}\,\dot\eta\,dt=\left[\frac{\partial L}{\partial\dot q}\,\eta\right]_{t_1}^{t_2}-\int_{t_1}^{t_2}\frac{d}{dt}\!\left(\frac{\partial L}{\partial\dot q}\right)\eta\,dt=-\int_{t_1}^{t_2}\frac{d}{dt}\!\left(\frac{\partial L}{\partial\dot q}\right)\eta\,dt \qquad\qquad (2.3)$$

$$\delta S=\epsilon\int_{t_1}^{t_2}E(t)\,\eta(t)\,dt,\qquad E(t)\equiv\frac{\partial L}{\partial q}-\frac{d}{dt}\frac{\partial L}{\partial\dot q}$$

$$
\begin{array}{l}
(\Rightarrow)\ \ \delta S=0\ \ \forall\eta.\ \ \text{Assume }E(t^*)>0\ \Rightarrow\ E(t)>0\ \ \text{for }|t-t^*|<h\\
\eta(t)=\begin{cases}\left(h^2-(t-t^*)^2\right)^2, & |t-t^*|<h\\ 0, & \text{otherwise}\end{cases}\qquad \eta\ge0,\quad \eta(t_1)=\eta(t_2)=0\\
\delta S=\epsilon\int_{t^*-h}^{t^*+h}E(t)\,\eta(t)\,dt>0\quad(\text{contradiction, the same for }E(t^*)<0)\ \ \Rightarrow\ \ E(t)=0\ \ \forall t\\
(\Leftarrow)\ \ E(t)=0\ \ \forall t\ \Rightarrow\ \delta S=\epsilon\int_{t_1}^{t_2}0\cdot\eta\,dt=0\ \ \forall\eta
\end{array}
$$

::: {custom-style="Highlighted Equation"}
$$\delta S=0\quad\Longleftrightarrow\quad \frac{d}{dt}\frac{\partial L}{\partial\dot\theta}-\frac{\partial L}{\partial\theta}=0\qquad\blacksquare \qquad\qquad (2.4)$$
:::

The variation of the path changes the Lagrangian only to first order in $\epsilon$, which gives Equation (2.2). Integration by parts moves the time derivative from $\eta$ to $\partial L/\partial\dot q$, and the boundary term vanishes because every varied path keeps the end points. If the bracket $E(t)$ were positive (or negative) anywhere, the bump function $\eta$ above would make $\delta S$ nonzero, so Hamilton's principle forces $E(t)=0$ at every instant. Conversely, if the Lagrange equation holds, $\delta S$ is zero for every variation. Both statements are therefore equivalent.

**(a)** The problem does not state what $\theta$ is, so the kinetic energy is written with a general inertia $M$ of the coordinate. For a distance, as $x$ in the lecture, $M=m$. For an angle of rotation about a fixed axis, each mass $m_i$ at distance $d_i$ from the axis moves with speed $d_i\dot\theta$, and $M$ becomes the moment of inertia $I$. The potential energy depends only on the position.

$$\theta=x\ \Rightarrow\ T=\tfrac12 m\dot x^2,\qquad \theta=\text{angle}\ \Rightarrow\ T=\sum_i\tfrac12 m_i\left(d_i\dot\theta\right)^2=\tfrac12\Big(\sum_i m_id_i^2\Big)\dot\theta^2=\tfrac12 I\dot\theta^2$$

$$T=\tfrac12 M\dot\theta^2,\qquad V=V(\theta),\qquad L(\theta,\dot\theta)=\tfrac12 M\dot\theta^2-V(\theta)$$

$$\frac{\partial L}{\partial\dot\theta}=\frac{\partial}{\partial\dot\theta}\left(\tfrac12 M\dot\theta^2\right)-\frac{\partial V(\theta)}{\partial\dot\theta}=\tfrac12 M\cdot2\dot\theta-0=M\dot\theta$$

$$\theta=x:\ \ p=m\dot x\ \ (\text{linear momentum}),\qquad \theta=\text{angle}:\ \ p=\sum_i d_i\left(m_id_i\dot\theta\right)=I\dot\theta\ \ (\text{angular momentum})$$

::: {custom-style="Highlighted Equation"}
$$\frac{\partial L}{\partial\dot\theta}=M\dot\theta=p\qquad\blacksquare \qquad\qquad (2.5)$$
:::

The derivative of $L$ with respect to the velocity removes the potential energy, because $V$ does not contain $\dot\theta$, and leaves the inertia times the velocity. This is the linear momentum $m\dot x$ for a distance and the angular momentum $I\dot\theta$ for an angle. The senior report writes $m\dot\theta$, which is the first case only. For an angle, $\tfrac12m\dot\theta^2$ has the unit kg/s² and is not an energy, so the moment of inertia is required.

**(b)** Equation (2.5) is substituted into the Lagrange equation (2.4). The generalized force follows from the virtual work of the forces $\mathbf F_i=-\nabla_iV$ on the masses.

$$\frac{d}{dt}\frac{\partial L}{\partial\dot\theta}=\frac{d}{dt}\left(M\dot\theta\right)=M\ddot\theta=\dot p\qquad(M\ \text{constant})$$

$$\frac{\partial L}{\partial\theta}=\frac{\partial}{\partial\theta}\left(\tfrac12 M\dot\theta^2\right)-\frac{\partial V}{\partial\theta}=0-\frac{\partial V}{\partial\theta},\qquad F=\sum_i\mathbf F_i\cdot\frac{\partial\mathbf r_i}{\partial\theta}=-\sum_i\nabla_iV\cdot\frac{\partial\mathbf r_i}{\partial\theta}=-\frac{\partial V}{\partial\theta}$$

$$\frac{d}{dt}\frac{\partial L}{\partial\dot\theta}=\frac{\partial L}{\partial\theta}\quad\Rightarrow\quad \dot p=-\frac{\partial V}{\partial\theta}$$

::: {custom-style="Highlighted Equation"}
$$\dot p=F\qquad\Longleftrightarrow\qquad M\ddot\theta=F=-\frac{\partial V}{\partial\theta}\qquad\blacksquare \qquad\qquad (2.6)$$
:::

$$
\begin{array}{l}
\theta=x:\ \  \dot p=m\ddot x=F=ma,\qquad\text{e.g. spring } V=\tfrac12kx^2\ \Rightarrow\ m\ddot x=-kx\\
\theta=\text{angle}:\ \  \dot p=I\ddot\theta=\tau,\qquad\text{e.g. } V=-mgd\cos\theta\ \Rightarrow\ md^2\ddot\theta=-mgd\sin\theta
\end{array}\qquad\qquad (2.7)
$$

The rate of change of the momentum equals the force obtained from the potential. For a distance this is Newton's law $F=ma$, and for an angle it is the rotational form, in which the torque equals the moment of inertia times the angular acceleration. If an external force acts, the term $\tau$ of Equation (1.3) is added to $F$.

### 2.2.2 Problem 2(a) (Kinetic and Potential Energy)

Spherical coordinates of Figure 1.2 are used. The link is rigid, so $r=l$ and $\dot r=0$ from the start, and only $\theta$ and $\varphi$ depend on time.

$$x=l\sin\theta\cos\varphi,\qquad y=l\sin\theta\sin\varphi,\qquad z=l\cos\theta \qquad\qquad (2.8)$$

$$
\begin{array}{l}
\dot x=l\left(\dot\theta\cos\theta\cos\varphi-\dot\varphi\sin\theta\sin\varphi\right)\\
\dot y=l\left(\dot\theta\cos\theta\sin\varphi+\dot\varphi\sin\theta\cos\varphi\right)\\
\dot z=-l\dot\theta\sin\theta
\end{array}
$$

$$
\begin{array}{l}
\dot x^2=l^2\left(\dot\theta^2\cos^2\theta\cos^2\varphi-2\dot\theta\dot\varphi\sin\theta\cos\theta\sin\varphi\cos\varphi+\dot\varphi^2\sin^2\theta\sin^2\varphi\right)\\
\dot y^2=l^2\left(\dot\theta^2\cos^2\theta\sin^2\varphi+2\dot\theta\dot\varphi\sin\theta\cos\theta\sin\varphi\cos\varphi+\dot\varphi^2\sin^2\theta\cos^2\varphi\right)\\
\dot x^2+\dot y^2=l^2\left[\dot\theta^2\cos^2\theta\left(\cos^2\varphi+\sin^2\varphi\right)+\dot\varphi^2\sin^2\theta\left(\sin^2\varphi+\cos^2\varphi\right)\right]=l^2\left(\dot\theta^2\cos^2\theta+\dot\varphi^2\sin^2\theta\right)\\
\dot z^2=l^2\dot\theta^2\sin^2\theta
\end{array}
$$

$$v^2=\dot x^2+\dot y^2+\dot z^2=l^2\left[\dot\theta^2\left(\cos^2\theta+\sin^2\theta\right)+\dot\varphi^2\sin^2\theta\right]=l^2\left(\dot\theta^2+\sin^2\theta\,\dot\varphi^2\right)$$

::: {custom-style="Highlighted Equation"}
$$T=\tfrac12 mv^2=\tfrac12 ml^2\left(\dot\theta^2+\sin^2\theta\,\dot\varphi^2\right) \qquad\qquad (2.9)$$
:::

$$V=mgz\quad(\text{gravity along }-z,\ V=0\ \text{at the pivot})$$

::: {custom-style="Highlighted Equation"}
$$V=mgl\cos\theta \qquad\qquad (2.10)$$
:::

$$
\begin{array}{l}
\rho=l\sin\theta,\quad z=l\cos\theta,\quad \dot\rho=l\dot\theta\cos\theta,\quad \dot z=-l\dot\theta\sin\theta\\
T=\tfrac12 m\left(\dot\rho^2+\rho^2\dot\varphi^2+\dot z^2\right)=\tfrac12 m\left(l^2\dot\theta^2\cos^2\theta+l^2\sin^2\theta\,\dot\varphi^2+l^2\dot\theta^2\sin^2\theta\right)\\
T=\tfrac12 ml^2\left(\dot\theta^2+\sin^2\theta\,\dot\varphi^2\right)
\end{array}
$$

The cross terms of $\dot x^2$ and $\dot y^2$ have opposite signs and cancel, and the identity $\cos^2+\sin^2=1$ removes $\varphi$ from the speed. The speed therefore has two parts, $l\dot\theta$ along the meridian and $l\sin\theta\,\dot\varphi$ around the vertical axis. The potential energy is measured from the pivot and is lowest ($-mgl$) when the bob hangs at $\theta=\pi$. The cylindrical coordinates give the same kinetic energy, which confirms Equation (2.9).

### 2.2.3 Problem 2(b) (Lagrangian Method, Position and Velocity)

$$L=T-V=\tfrac12 ml^2\left(\dot\theta^2+\sin^2\theta\,\dot\varphi^2\right)-mgl\cos\theta \qquad\qquad (2.11)$$

$$
\begin{array}{l}
\frac{\partial L}{\partial\dot\theta}=ml^2\dot\theta,\qquad \frac{d}{dt}\frac{\partial L}{\partial\dot\theta}=ml^2\ddot\theta\\
\frac{\partial L}{\partial\theta}=\tfrac12 ml^2\dot\varphi^2\,\frac{d\left(\sin^2\theta\right)}{d\theta}-mgl\,\frac{d\left(\cos\theta\right)}{d\theta}=\tfrac12 ml^2\dot\varphi^2\left(2\sin\theta\cos\theta\right)+mgl\sin\theta\\
\frac{d}{dt}\frac{\partial L}{\partial\dot\theta}-\frac{\partial L}{\partial\theta}=ml^2\ddot\theta-ml^2\sin\theta\cos\theta\,\dot\varphi^2-mgl\sin\theta=0\qquad\left(\div\,ml^2\right)
\end{array}
$$

::: {custom-style="Highlighted Equation"}
$$\ddot\theta=\sin\theta\cos\theta\,\dot\varphi^2+\frac{g}{l}\sin\theta \qquad\qquad (2.12)$$
:::

$$
\begin{array}{l}
\frac{\partial L}{\partial\dot\varphi}=ml^2\sin^2\theta\,\dot\varphi,\qquad \frac{\partial L}{\partial\varphi}=0\\
\frac{d}{dt}\frac{\partial L}{\partial\dot\varphi}=ml^2\left(\frac{d\left(\sin^2\theta\right)}{dt}\,\dot\varphi+\sin^2\theta\,\ddot\varphi\right)=ml^2\left(2\sin\theta\cos\theta\,\dot\theta\dot\varphi+\sin^2\theta\,\ddot\varphi\right)\\
\frac{d}{dt}\frac{\partial L}{\partial\dot\varphi}-\frac{\partial L}{\partial\varphi}=ml^2\left(\sin^2\theta\,\ddot\varphi+2\sin\theta\cos\theta\,\dot\theta\dot\varphi\right)=0\qquad\left(\div\,ml^2\sin^2\theta,\ \sin\theta\neq0\right)
\end{array}
$$

::: {custom-style="Highlighted Equation"}
$$\ddot\varphi=-2\,\frac{\cos\theta}{\sin\theta}\,\dot\theta\dot\varphi \qquad\qquad (2.13)$$
:::

::: {custom-style="Highlighted Equation"}
$$\mathbf y=\begin{bmatrix}\theta\\ \dot\theta\\ \varphi\\ \dot\varphi\end{bmatrix},\qquad \frac{d\mathbf y}{dt}=\begin{bmatrix}\dot\theta\\ \sin\theta\cos\theta\,\dot\varphi^2+\dfrac{g}{l}\sin\theta\\ \dot\varphi\\ -2\cot\theta\,\dot\theta\dot\varphi\end{bmatrix} \qquad\qquad (2.14)$$
:::

$$\alpha=\pi-\theta\ \Rightarrow\ \sin\theta=\sin\alpha,\ \ \cos\theta=-\cos\alpha,\ \ \ddot\theta=-\ddot\alpha\ \Rightarrow\ \ddot\alpha=\sin\alpha\cos\alpha\,\dot\varphi^2-\frac{g}{l}\sin\alpha$$

The Lagrange method gives one second-order equation for each coordinate. The term $\sin\theta\cos\theta\,\dot\varphi^2$ is the centrifugal effect of the rotation around the vertical axis, and the term in Equation (2.13) couples the two angles. The gravity term is positive because $\theta$ is measured from the top, and with $\alpha=\pi-\theta$ it becomes the usual restoring term. Written as Equation (2.14), the state contains the position ($\theta,\varphi$) and the velocity ($\dot\theta,\dot\varphi$), which is what the problem asks for. No equation is needed for $r$, because $r=l$ at all times, and the Lagrange equation of $r$ would only give the tension of the link.

### 2.2.4 Problem 2(b) (Hamiltonian Method, Position and Momentum)

::: {custom-style="Highlighted Equation"}
$$p_\theta=\frac{\partial L}{\partial\dot\theta}=ml^2\dot\theta,\qquad p_\varphi=\frac{\partial L}{\partial\dot\varphi}=ml^2\sin^2\theta\,\dot\varphi \qquad\qquad (2.15)$$
:::

$$\dot\theta=\frac{p_\theta}{ml^2},\qquad \dot\varphi=\frac{p_\varphi}{ml^2\sin^2\theta}$$

$$
\begin{array}{l}
H=p_\theta\dot\theta+p_\varphi\dot\varphi-L\\
p_\theta\dot\theta+p_\varphi\dot\varphi=ml^2\dot\theta^2+ml^2\sin^2\theta\,\dot\varphi^2=2T\quad\Rightarrow\quad H=2T-(T-V)=T+V\\
\tfrac12 ml^2\dot\theta^2=\tfrac12 ml^2\left(\frac{p_\theta}{ml^2}\right)^2=\frac{p_\theta^2}{2ml^2},\qquad \tfrac12 ml^2\sin^2\theta\,\dot\varphi^2=\tfrac12 ml^2\sin^2\theta\,\frac{p_\varphi^2}{m^2l^4\sin^4\theta}=\frac{p_\varphi^2}{2ml^2\sin^2\theta}
\end{array}
$$

::: {custom-style="Highlighted Equation"}
$$H=\frac{p_\theta^2}{2ml^2}+\frac{p_\varphi^2}{2ml^2\sin^2\theta}+mgl\cos\theta \qquad\qquad (2.16)$$
:::

$$\frac{\partial H}{\partial\theta}=\frac{p_\varphi^2}{2ml^2}\,\frac{d\left(\sin^{-2}\theta\right)}{d\theta}+mgl\,\frac{d\left(\cos\theta\right)}{d\theta}=\frac{p_\varphi^2}{2ml^2}\left(-\frac{2\cos\theta}{\sin^3\theta}\right)-mgl\sin\theta,\qquad \frac{\partial H}{\partial\varphi}=0$$

::: {custom-style="Highlighted Equation"}
$$\dot\theta=\frac{\partial H}{\partial p_\theta}=\frac{p_\theta}{ml^2}\qquad (2.17)\qquad\qquad \dot\varphi=\frac{\partial H}{\partial p_\varphi}=\frac{p_\varphi}{ml^2\sin^2\theta}\qquad (2.18)$$
:::

::: {custom-style="Highlighted Equation"}
$$\dot p_\theta=-\frac{\partial H}{\partial\theta}=\frac{p_\varphi^2\cos\theta}{ml^2\sin^3\theta}+mgl\sin\theta\qquad (2.19)\qquad\qquad \dot p_\varphi=-\frac{\partial H}{\partial\varphi}=0\qquad (2.20)$$
:::

$$\mathbf z=\begin{bmatrix}\theta & p_\theta & \varphi & p_\varphi\end{bmatrix}^T,\qquad \frac{d\mathbf z}{dt}=\begin{bmatrix}\dot\theta & \dot p_\theta & \dot\varphi & \dot p_\varphi\end{bmatrix}^T\ \text{from Equations }(2.17)\text{ to }(2.20) \qquad\qquad (2.21)$$

$$
\begin{array}{l}
\ddot\theta=\frac{\dot p_\theta}{ml^2}=\frac{p_\varphi^2\cos\theta}{m^2l^4\sin^3\theta}+\frac{g}{l}\sin\theta=\frac{\left(ml^2\sin^2\theta\,\dot\varphi\right)^2\cos\theta}{m^2l^4\sin^3\theta}+\frac{g}{l}\sin\theta=\sin\theta\cos\theta\,\dot\varphi^2+\frac{g}{l}\sin\theta\ \equiv\ (2.12)\\
\dot p_\varphi=\frac{d}{dt}\left(ml^2\sin^2\theta\,\dot\varphi\right)=ml^2\left(\sin^2\theta\,\ddot\varphi+2\sin\theta\cos\theta\,\dot\theta\dot\varphi\right)=0\ \equiv\ (2.13)
\end{array}\qquad (2.22)
$$

$$\frac{dH}{dt}=\sum_{q=\theta,\varphi}\left(\frac{\partial H}{\partial q}\dot q+\frac{\partial H}{\partial p_q}\dot p_q\right)+\frac{\partial H}{\partial t}=\sum_{q=\theta,\varphi}\left(\frac{\partial H}{\partial q}\frac{\partial H}{\partial p_q}-\frac{\partial H}{\partial p_q}\frac{\partial H}{\partial q}\right)+0=0$$

The momenta are the derivatives of $L$ with respect to the velocities, and solving them for the velocities lets $T$ be written in the momenta. The Legendre transform then gives $H=T+V$, the total energy. Hamilton's method gives four first-order equations, and their state, Equation (2.21), contains the position ($\theta,\varphi$) and the momentum ($p_\theta,p_\varphi$). Equation (2.20) shows directly that $p_\varphi$, the angular momentum about the vertical axis, is constant, because $\varphi$ does not appear in $H$. Differentiating Equation (2.17) and Equation (2.15) returns the two Lagrange equations, Equation (2.22), so both methods describe the same motion. The last line shows that $H$ stays constant, because $H$ does not contain $t$.

### 2.2.5 From the Equations of Motion to the Position

$$
\begin{array}{l}
\text{Lagrange}\quad \dot\theta(t)=\dot\theta_0+\int_0^t\ddot\theta\,dt,\qquad \theta(t)=\theta_0+\int_0^t\dot\theta\,dt\qquad(\text{the same for }\varphi)\\
\text{Hamilton}\quad p_\theta(t)=p_{\theta0}+\int_0^t\dot p_\theta\,dt,\qquad \theta(t)=\theta_0+\int_0^t\frac{p_\theta}{ml^2}\,dt
\end{array}\qquad\qquad (2.23)
$$

$$
\begin{array}{l}
\text{Planar, small }\alpha\quad \dot\varphi=0,\ \sin\alpha\approx\alpha\ \Rightarrow\ \ddot\alpha=-\frac{g}{l}\alpha\ \Rightarrow\ \alpha(t)=\alpha_0\cos\!\left(\sqrt{g/l}\;t\right)\quad(\dot\alpha_0=0)\\
\text{Conical}\quad \alpha=\alpha_0,\ \ddot\alpha=0,\ \dot\varphi=\Omega\ \Rightarrow\ 0=\sin\alpha_0\cos\alpha_0\,\Omega^2-\frac{g}{l}\sin\alpha_0\ \Rightarrow\ \Omega^2=\frac{g}{l\cos\alpha_0},\ \ \varphi(t)=\Omega t
\end{array}\qquad (2.24)
$$

The position is obtained by integrating the rates in time. The second-order Lagrange equations are integrated twice, first to the velocity and then to the position, while the first-order Hamilton system is integrated once for each of its four variables. Only special cases have a formula, Equation (2.24). In general the integration is done numerically with RK4, Equation (1.8), which is what the program does. The position of the bob in space then follows from Equation (2.8).

### 2.2.6 Program Code

The program (Delphi 13, VCL) has a numerical unit `PendulumModel.pas` without user-interface code, the main form `Unit1.pas` with four charts and the equation window `Unit2.pas`. The listings below are the three routines that implement Equation (2.14), Equation (2.17) to (2.20) and Equation (1.8). For planar motion ($\dot\varphi=0$) the $\varphi$ term is set to zero directly, because $\cot\theta$ is infinite when the bob passes the vertical axis.

@@CODE PendulumModel.pas LagrangeRHS@@

@@CODE PendulumModel.pas HamiltonRHS@@

@@CODE PendulumModel.pas RK4Step@@

`Simulate` (not listed) starts both systems from the same state, with $p_\theta$ and $p_\varphi$ computed from Equation (2.15). It calls `RK4Step` for each system at every step, stores the results for the charts and records the largest difference between the two methods and the largest change of $H$ and $p_\varphi$.
