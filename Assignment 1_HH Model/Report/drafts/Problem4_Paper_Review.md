# Problem 4 - Hodgkin-Huxley Model in Two Research Works (DRAFT)

> Draft for Chapter II, Section 2.2 (Answer of Problem 4) of the Assignment 1
> report. Written from the full texts of both papers provided by the lecturer.
> Bracketed numbers refer to the reference list at the end of this file and
> must be renumbered when the section is merged into the Word report.
> Statements marked _(inference)_ are the author's interpretation, not claims
> made by the papers.

**Problem 4.** From two scientific papers, write important aspects of the HH
model in these research works, and the impacts of HH works for advances
technology for medical and biology.

---

## 4.1 Paper 1: A model of the pacemaking neuron of the respiratory central pattern generator (Amini _et al._, 2005)

Amini, Bidani, Zwischenberger and Clark [2] address a question that is central
to respiratory neurophysiology: how much of the breathing rhythm is generated
by intrinsic membrane properties of individual neurons and how much by network
connectivity. The respiratory central pattern generator (rCPG) is a population
of medullary neurons that drives the phrenic motor neurons and hence the
diaphragm. Its putative pacemaker, the pre-inspiratory (Pre-I) neuron of the
pre-Botzinger complex (PBC), fires before inspiration and sets the respiratory
rate. The authors build an HH-type model of this PBC neuron as the driving
element of a larger rCPG network model and use it to dissect the ionic
mechanism of bursting and the phase sensitivity of the rhythm.

The first important aspect is that the paper keeps the complete Hodgkin-Huxley
formalism and only enlarges the set of conductances. Every voltage-gated
current is written as a maximal conductance multiplied by powers of gating
variables and by a driving force, for example
I_CaT = g_CaT d_T^2 f_T (v - 37.0), and every gating variable follows
first-order kinetics with voltage-dependent rate constants alpha and beta,
x_inf = alpha/(alpha + beta) and tau_x = c/(alpha + beta) (Table II of [2]).
Several of these rate functions have exactly the form a(v + b)/(exp(c(v + b)) - 1)
that appears in alpha_m and alpha_n of the original HH model [1]. They therefore
inherit the same removable singularity that the present assignment handles
analytically in `ExpRatio` (`HHModel.pas`). Compared with the three currents
of the squid axon (I_Na, I_K, I_L), the PBC neuron contains fast and persistent
sodium currents (I_Na, I_NaP), T-, N- and L-type calcium currents, delayed
rectifier and transient outward potassium currents (I_K, I_A, I_D), a
calcium-activated potassium current (I_KCa), a hyperpolarization-activated
mixed cation current (I_h), pump and exchanger currents (I_NaK, I_NaCa,
I_CaP) and an intracellular calcium balance [2, Fig. 2]. The second aspect is
the explicit temperature correction. Voltage-clamp data for different currents
were recorded at different temperatures, so time constants and maximal
conductances were scaled by Q10^((T1 - T2)/10) to the model temperature of
302 K, using current-specific Q10 values between 1.28 and 5.1 (Table I of [2]).
This is the same mechanism as the factor phi = 3^((T - 6.3)/10) of Hodgkin and
Huxley [1], which the simulator of this assignment exposes as the
"Temperature" parameter. The third aspect is numerical: the stiff system was
coded in C and integrated with the CVODE variable-step solver (dense direct
linear solver), not with a fixed-step Runge-Kutta scheme.

The model reproduces the interburst trajectory, the rising baseline potential
during a burst, the burst duration and period, and the peak intraburst firing
frequency of recorded PBC neurons [2, Fig. 2(a)]. Its main value lies in the
in silico channel-block experiments, which separate the contribution of each
current. Removing I_NaP abolishes bursting and leaves tonic spiking at about
15 Hz, so the persistent sodium current sets the depolarized baseline on which
bursts ride. I_Na generates the spikes and recruits I_CaL and I_CaN; the
resulting rise of intracellular calcium activates I_KCa, which terminates the
burst. Blocking I_KCa leaves the membrane depolarized after the burst, I_K and
I_D only sharpen burst termination, and I_A is needed to repolarize individual
spikes [2, Fig. 3]. Finally, phasic current pulses applied at different phases
of the cycle give a phase response curve. Stimulation during the burst
produces a phase delay that decreases linearly and then reverses into a phase
advance, while stimulation during the repolarizing phase gives a plateau of
constant phase advance [2, Fig. 4]. Two inconsistencies should be noted when
citing the paper. The Methods section specifies a 150 nA stimulus, whereas the
caption of Fig. 4 states 100 nA. The phase change is defined as
DeltaP = P0 - P1 and positive values are said to indicate a phase delay, but a
delay lengthens the perturbed period (P1 > P0) and thus gives a negative
DeltaP, which agrees with the Results text ("phase delay (negative DeltaPhi)").
The authors also note that voltage-clamp data on potassium currents in PBC
neurons were still scarce, so several potassium kinetics were adapted from
neighbouring ventral respiratory group neurons rather than measured directly.

## 4.2 Paper 2: High speed and low digital resources implementation of the HH neuronal model using base-2 functions (Haghiri _et al._, 2021)

Haghiri, Naderi, Ghanbari and Ahmadi [3] treat the HH model as the most
biologically faithful but also the most expensive neuron model for
neuromorphic hardware. Its powers m^3 and n^4, divisions and exponential rate
functions require multipliers, dividers and look-up resources that limit how
many neurons fit on a chip. The paper keeps the four-state structure of the HH
model, (12)-(13) in [3], and replaces every costly nonlinear term with a short
linear combination of base-2 exponentials. These can be evaluated in digital
logic with shifters, adders and subtractors only.

The mathematical core is a projection onto an orthonormal basis.
Gram-Schmidt orthonormalization of {2^(-2v), 2^(-v), 1, 2^v, 2^(2v)} on [0, 1]
gives five basis functions. Any continuous term is then approximated by its
first five generalized Fourier coefficients, rounded to two decimal places
[3, (5)-(11)]. The membrane voltage is first normalized to the unit interval
(V/80), and m^3, n^4, h and the six rate functions are replaced by Z(m), Z(n),
Z(h), F_x(V) and G_x(V) [3, (14)-(15)]. A detail directly relevant to this
assignment is the sign convention. Haghiri _et al._ use the modern form,
V_Na = 115 mV, V_K = -12 mV, V_L = 10.6 mV, alpha_m = (2.5 - 0.1V)/(exp(2.5 - 0.1V) - 1),
with depolarization positive. This is exactly the lecturer's form with
v = -V. The two descriptions are therefore the same model, and the alignment
Vm = -(v + 70) used in Problem 1 equals Vm = V - 70 in their notation.

The paper evaluates the approximation at three levels. Time-domain traces of
the original and base-2 models for stimuli of 2 to 80 uA/cm^2 agree with a
mean correlation of 90.4 %, mean RMSE of 7.4 mV, mean MAE of 5 mV and mean
NRMSE of 9.34 % (Table II of [3]). The largest single mismatch is in n^4
[3, Fig. 2(h)]. Dynamically, the reduced V-m system keeps the same type and
nearly the same location of fixed points (a nodal sink and a saddle) as the
original model, for example (2.07, 0.06) and (14.09, 0.23) against (2.12, 0.06)
and (13.40, 0.21) for n = 0.4 and h = 0.1, which the authors show through
nullclines, Jacobian matrices and phase portraits [3, Figs. 4 and (16)-(21)].
In hardware, the model is discretized with the forward Euler method
(dt = 2^-7) and pipelined in a neuron unit with 30-bit fixed-point words (10
integer and 20 fraction bits). It is implemented on a Virtex-4 XC4VLX15 FPGA
with 4 % of the slice flip-flops, 19 % of the LUTs, no hardware multipliers,
and a maximum clock of 200 MHz, against 64 MHz and 72 % of the DSP blocks for
an earlier Virtex-7 HH implementation [3, Table III]. Oscilloscope traces of
fast-spiking, intrinsically bursting, regular-spiking and low-threshold-spiking
patterns agree with MATLAB references with RMSE between 7.9 and 12.7 mV
[3, Fig. 9 and Table V].

Several points deserve a critical reading. The error evaluation is reported
for "dt = 10 ms", which cannot integrate HH kinetics stably. It is presumably
a lost unit prefix, the same defect as the "10 sec" step on the lecturer's
slide (ISSUES.md, ISS-001). The single action potential shown for I = 2
uA/cm^2 [3, Fig. 3(a)] is most likely an initial-condition artefact: the
reference traces start with m, h and n near zero [3, Fig. 1]. Reproducing
this with the simulator of this assignment, zero initial gates produce one
spike at 4.1 ms for Jin = -2 uA/cm^2 and even at 5.4 ms with no input at all,
whereas a membrane started at rest does not fire at this level _(inference
supported by simulation)_. The paper does not explain how the standard HH
equations, which do not burst intrinsically, were made to produce the IB and
LTS patterns of Fig. 9. Lastly, the introduction dates the Nobel Prize of
Hodgkin and Huxley to 1961, whereas it was awarded in 1963.

## 4.3 Comparison with the model implemented in this assignment

| Aspect          | Lecturer material / this assignment                              | Amini _et al._ [2]                                      | Haghiri _et al._ [3]                         |
| --------------- | ---------------------------------------------------------------- | ------------------------------------------------------- | -------------------------------------------- |
| Purpose         | Teaching APG, refractoriness and propagation                     | Mechanism of respiratory rhythm (PBC pacemaker)         | Low-cost neuromorphic hardware               |
| Currents        | I_Na, I_K, I_L (squid axon)                                      | More than a dozen currents incl. I_NaP, I_Ca(T,N,L), I_KCa, I_h, pumps | I_Na, I_K, I_L (squid axon)                  |
| Sign convention | HH 1952: depolarization negative, Vm = -(v + 70)                 | Physiological, absolute mV                              | Modern: depolarization positive, V = -v      |
| Temperature     | phi = 3^((T - 6.3)/10) (optional)                                | Current-specific Q10, 302 K                             | Not used                                     |
| Integration     | Coupled RK4 (and lecturer RK4), dt = 0.01 ms; FTCS for the cable | CVODE (variable step)                                   | Forward Euler, fixed point, dt = 2^-7        |
| Nonlinear terms | Exact, removable singularities handled analytically              | Exact (HH form)                                         | Base-2 approximations                        |
| Validation      | Python cross-check; HH 1952 conduction velocity                  | Voltage-clamp and current-clamp data                    | RMSE/MAE/NRMSE/Corr, nullclines, FPGA traces |

## 4.4 Impact of the Hodgkin-Huxley work on medical and biological technology

The deepest impact of Hodgkin and Huxley [1] is methodological. They showed
that excitability can be explained quantitatively by a small set of
voltage-dependent conductances, each described by gating variables with
first-order kinetics. They also demonstrated that this description, measured
under voltage clamp, predicts the action potential, its propagation velocity
(18.8 m/s calculated against 21.2 m/s measured) and the refractory period. The
two reviewed papers show how far this template travels. In Amini _et al._ [2]
it becomes a tool of respiratory physiology. More than a dozen conductances fitted to
voltage-clamp data, in exactly the HH formalism, reproduce the bursting of the
respiratory pacemaker. Pharmacological block becomes a computational
experiment that identifies I_NaP and I_KCa as the currents that start and stop
a breath, and the phase response curve indicates when an electrical stimulus
can advance or delay the next breath. Knowing which conductance controls a
rhythm and when the rhythm is sensitive to stimulation is the knowledge needed
for drug targeting and for electrical control of breathing. The clinical
affiliations of the authors (pulmonary and critical care medicine, surgery and
extracorporeal life support) suggest that this was their motivation _(inference)_.
The same conductance-based approach was carried into cardiac electrophysiology
by Noble's modification of the HH equations for Purkinje fibres and pacemaker
potentials [4]. It underlies present-day models of drug action on
cardiac and neural ion channels.

In engineering, Haghiri _et al._ [3] illustrate the second line of impact.
Because the HH model remains the reference for biological fidelity,
neuromorphic engineers try to keep its dynamics while reducing its cost. A
multiplier-free HH neuron that runs at 200 MHz on a small FPGA makes large
networks of biophysically realistic neurons feasible in real time. The
authors position this capability for studying neurological disorders such as
epilepsy, Alzheimer's disease, essential tremor and Parkinson's disease, and
for brain-machine coupling. Their cited applications include neuroprosthetic
systems that restore communication between neuronal populations [5] and
closed-loop neuroprostheses [6]. Real-time HH hardware is a prerequisite for
such bio-hybrid systems, because the artificial neurons must respond to living
tissue within its own millisecond time scale. Together, the two papers show
the HH model acting both as a scientific instrument, explaining biological
rhythms and the effect of blocking specific channels, and as an engineering
specification, the target behaviour that efficient medical hardware must
reproduce. The simulator developed in Problems 1 and 3 sits at the origin of
both lines: it solves the same equations, shows the same refractoriness and
input-dependent firing rate, and reproduces the propagation velocity reported
in 1952.

---

## References (IEEE)

[1] A. L. Hodgkin and A. F. Huxley, "A quantitative description of membrane
current and its application to conduction and excitation in nerve,"
_J. Physiol._, vol. 117, no. 4, pp. 500-544, Aug. 1952,
doi: 10.1113/jphysiol.1952.sp004764.

[2] B. Amini, A. Bidani, J. B. Zwischenberger, and J. W. Clark, Jr., "A model
of the pacemaking neuron of the respiratory central pattern generator,"
_IEEE Trans. Neural Syst. Rehabil. Eng._, vol. 13, no. 2, pp. 120-124,
Jun. 2005, doi: 10.1109/TNSRE.2005.847379.

[3] S. Haghiri, A. Naderi, B. Ghanbari, and A. Ahmadi, "High speed and low
digital resources implementation of Hodgkin-Huxley neuronal model using
base-2 functions," _IEEE Trans. Circuits Syst. I, Reg. Papers_, vol. 68,
no. 1, pp. 275-287, Jan. 2021, doi: 10.1109/TCSI.2020.3026076.

[4] D. Noble, "A modification of the Hodgkin-Huxley equations applicable to
Purkinje fibre action and pace-maker potentials," _J. Physiol._, vol. 160,
no. 2, pp. 317-352, Feb. 1962, doi: 10.1113/jphysiol.1962.sp006849.
_(Bibliographic details from memory: verify before submission.)_

[5] S. Buccelli _et al._, "A neuroprosthetic system to restore neuronal
communication in modular networks," _iScience_, vol. 19, pp. 402-414,
Jul. 2019, doi: 10.1016/j.isci.2019.07.046. _(As cited in [3].)_

[6] T. Levi, P. Bonifazi, P. Massobrio, and M. Chiappalone, "Closed-loop
systems for next-generation neuroprostheses," _Front. Neurosci._, vol. 12,
p. 26, Feb. 2018. _(As cited in [3].)_
