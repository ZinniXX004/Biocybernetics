# Issue Log

Problems found while studying the references, implementing, and maintaining
the Biocybernetics assignments. Status values: **Open**, **Resolved**,
**Mitigated** (worked around, root cause outside this repository), **Needs
confirmation** (requires the lecturer or my own check).

| ID      | Area                 | Summary                                                                                     | Status             |
| ------- | -------------------- | ------------------------------------------------------------------------------------------- | ------------------ |
| ISS-001 | A1 / lecturer slides | "Integration step: 10 sec" printed in `HH Simulation.pdf`                                   | Resolved           |
| ISS-002 | A1 / lecturer slides | `alpha_m` numerator printed as `0.1(v+2.5)` in `HH model.pdf`                               | Resolved           |
| ISS-003 | A1 / lecturer slides | PDE coefficient: slide is correct (`[(ro+ri)Cm]^-1`, Cm per length); earlier note withdrawn | Corrected          |
| ISS-004 | A1 / lecturer code   | Propagation code uses `vm[0,i]` in the `gm` term                                            | Needs confirmation |
| ISS-005 | A1 / senior code     | `+1e-9` added to rate denominators                                                          | Resolved           |
| ISS-006 | A1 / senior code     | APP implemented as pure diffusion of the APG output                                         | Resolved           |
| ISS-007 | A1 / numerics        | Lecturer RK4 is not a coupled RK4                                                           | Resolved           |
| ISS-008 | Repository           | No `.gitignore`; copyrighted material untracked in the repo root                            | Resolved           |
| ISS-009 | Environment          | Writes to `C:\Users\Sem 7\Biocybernetics` denied by Windows                                 | Resolved           |
| ISS-010 | A1 / build           | First Delphi 13 CE build: compiled and ran (TeeChart available)                             | Resolved           |
| ISS-011 | A1 / report          | Haghiri et al. (2021) DOI and pages verified from the PDF                                   | Resolved           |
| ISS-012 | A1 / numerics        | Explicit FTCS cable scheme is conditionally stable                                          | Mitigated          |
| ISS-013 | A1 / numerics        | Sealed-end boundary raises the spike peak at the last node                                  | Mitigated          |
| ISS-014 | A1 / UI              | JL and Jin invisible on the shared current axis (about 30x smaller)                         | Resolved           |
| ISS-015 | A1 / UI              | TeeChart-specific calls of UI v2 compiled in the real build                                 | Resolved           |
| ISS-016 | A1 / code style      | `delphi-standards` prefixes applied to `Unit1.pas` only, not yet to `HHModel.pas`           | Open               |
| ISS-017 | A1 / papers          | Internal inconsistencies found in both assigned papers (to be cited carefully)              | Mitigated          |
| ISS-018 | Repository           | Assigned IEEE papers stored in the assignment folder must not be pushed                     | Resolved           |
| ISS-019 | A1 / UI              | Plain mouse wheel over a chart raised EInvalidCast                                          | Resolved (retest)  |
| ISS-020 | A1 / UI              | Access violation and permanently black chart when the refractory slider reached 2.0 ms      | Mitigated (retest) |
| ISS-021 | A1 / scope           | Gate-vs-Vm plots of the senior program (m, h, n vs Vm) missing                              | Resolved           |
| ISS-022 | A1 / limitations     | Documented limitations of the simulator (numerics, detection, UI)                           | Documented         |
| ISS-028 | A1 / UI              | Stale legend entries after a new run (tab 5)                                                | Fixed (retest)     |
| ISS-029 | A1 / scope           | One wave only; lecturer's passive cable driven by the APG output                            | Resolved           |
| ISS-030 | A1 / numerics        | Crank-Nicolson option for the cable PDE                                                     | Resolved           |
| ISS-031 | A1 / scope           | ABE and C-F converter of the lecturer's simulator; lecturer constants                       | Documented         |
| ISS-032 | A1 / UI              | Tab 5 memo repeated nodes on the 6-node lecturer grid                                       | Resolved           |
| ISS-033 | A1 / CI              | Python references ran in CI without any assertion                                           | Resolved           |
| ISS-034 | CI                   | Node 20 removed from GitHub-hosted runners; checkout@v4 / setup-python@v5 outdated          | Resolved           |
| ISS-035 | A1 / UI              | Charts, series and parameter rows were created at run time, invisible in the Form Designer  | Resolved           |
| ISS-036 | A2 / lecturer slides | Lagrange's life dates printed as 1756-1813 (born 1736)                                      | Documented         |
| ISS-037 | A2 / lecturer slides | "H is conserved" and H = T + V stated without their conditions                              | Documented         |
| ISS-038 | A2 / assignment      | Spherical coordinates written "r, phi, z"; theta from +z puts the hanging bob at pi         | Mitigated          |
| ISS-039 | A2 / report          | Section 2.1: dotted theta of Problem 1 carried a second dot                                 | Resolved           |
| ISS-040 | A2 / senior report   | Senior A2 report: m thetadot fits a distance, not an angle; no variational proof            | Documented         |
| ISS-041 | FP / senior code     | Shoulder-joint motion equation: precedence, pole singularity patched, degrees               | Documented         |
| ISS-042 | FP / senior reports  | Rotational kinetic energy counted twice; I_o = 7ml^2/12 in one revision                     | Documented         |
| ISS-043 | FP / senior code     | PID output accumulated every step; Ki adapted with a fixed rate                             | Documented         |
| ISS-044 | A3 / lecturer slides | Discrete PID Model I: K_i z instead of K_i z^2 (integral delayed by one sample)             | Needs confirmation |
| ISS-045 | A2 / numerics        | RK4 is not symplectic; 0 \* cot(theta) at the pole for planar motion                        | Mitigated          |
| ISS-046 | A2 / report build    | Cover logo (EMF) had no content type in my first build                                      | Resolved           |
| ISS-047 | A2 / report          | My first draft: I = ml^2 in Problem 1, rdot kept before r = l, 27 pages, Python checks      | Resolved           |
| ISS-048 | A2 / report          | My second draft shortened the derivations too much                                          | Resolved           |
| ISS-049 | A3 / lecturer slides | ZN Method 1 assumes an aperiodic S-shaped curve; plant 1 overshoots 44.4 %                  | Resolved           |
| ISS-050 | A3 / senior code     | Plant 2: `xdot` held at 0 by all seniors (zero of `2s+1` removed); L = 0 for the true plant | Resolved           |
| ISS-051 | A3 / theory          | No finite Ku for either plant under P control; simulated Ku is a dt artefact                | Mitigated          |
| ISS-052 | A3 / lecturer code   | RK program passes `x2+0.5*dt` into the input argument of `difeq`                            | Resolved           |
| ISS-053 | A3 / senior code     | L and T taken from 0.25 or 0.1-0.2 thresholds instead of the inflection tangent             | Resolved           |
| ISS-054 | A3 / theory          | ZN PI gains destabilise plant 1 (lightly damped); P and PID stay stable                     | Documented         |
| ISS-055 | Repository           | Names of seniors, a classmate and the lecturer removed from tracked Markdown                | Mitigated          |
| ISS-056 | A3 / code            | Derivative term: previous error starts at the first error (no kick at t = 0)                | Resolved           |
| ISS-057 | A3 / report build    | Superscripts t^*, 0^+ and a triple dot not shown by LibreOffice; long equations cut         | Resolved           |
| ISS-058 | A3 / build           | Delphi 13: W1036 `LY` might not have been initialized (x2), H2269 MouseWheelHandler visibility | Resolved           |
| ISS-059 | A3 / UI              | First UI showed all results at once; inputs of the earlier programs (Ku, Pu, Kp, Ki, Kd, R, L) not editable | Resolved           |
| ISS-060 | A3 / numerics        | Impulse test of the lecture is a pulse of area dt; my impulse uses area x0                  | Documented         |
| ISS-061 | A3 / form file       | Opening Unit1.dfm: rgZN1Ctrl.Font.Color, List index out of bounds (2) (ItemIndex before Font) | Resolved           |
| ISS-062 | Repository / CI      | A3 workflow watched the A2 workflow file in its path filter                                  | Resolved           |
| ISS-063 | FP / own earlier work | Wrist FP of Biomodelling: PID output never enters the motion equation                       | Documented         |
| ISS-064 | FP / handout tables  | Fischer column incomplete for the arm; uniform rod puts the COM 20% further out than Dempster | Documented         |
| ISS-065 | FP / handout figure  | Reference read off the lecturer screenshot; its RMSE 0.819 deg is above the 0.75 deg criterion | Needs confirmation |
| ISS-066 | FP / adaptation      | Exact dV/dp needs the plant sensitivity; gradient approximation lets Kp only grow           | Open               |
| ISS-067 | FP / senior programs | Shared target template, kinematic shortcut in one revision, RMSE of 2 to 3 deg in another   | Documented         |
| ISS-068 | FP / passive targets | No study gives relaxed shoulder C and k at the hanging-arm posture per anatomical axis      | Documented (support only) |
| ISS-069 | A3 / UI              | Access violation (read of address 0x40) on the first Impulse Response click; tab 1 chart froze | Resolved           |
| ISS-070 | A3 / UI              | Charts could not be zoomed with the wheel; no way back to the full view after a zoom        | Resolved           |
| ISS-071 | A3 / UI              | Equation window could not be scrolled with the wheel or touchpad, or dragged                | Resolved           |
| ISS-072 | A3 / build           | Delphi 13 hints H2077 (`LY` never used) and H2443 (inline `Point`, `System.Types` missing)  | Resolved           |
| ISS-073 | FP / numerics        | Damping ratio measured from the release amplitude was biased by the sin(theta) nonlinearity | Resolved           |
| ISS-074 | FP / design          | Gain choice of Problem 3 and the meaning of the settling time for a sine reference          | Documented         |
| ISS-075 | Repository           | Two parallel sessions append to ISSUES.md and CHANGELOG.md                                  | Mitigated          |
| ISS-076 | A3 / report build    | References chapter printed the word REFS instead of the list (placeholder name mismatch)    | Resolved           |
| ISS-077 | FP / build           | First Delphi 13 build: E2018 at the `Split` call on `TEdit.Text` and a torque-limit key with "=" | Resolved (retest)  |
| ISS-078 | FP / UI              | UI v2: design-time card titles, button colours and fades, chart hover, busy guard, input checks | Resolved (retest)  |
| ISS-079 | A4 / lecturer slides | Bd of the bilinear formula carries the factor T/(1 - T/2); the standard form has T only      | Documented         |
| ISS-080 | A4 / lecturer program | `MPC.exe` of the MPC Simulator folder (and the copy in `MPC.zip`) was 0 bytes; working copy released later | Resolved           |
| ISS-081 | A4 / numerics        | Lecturer SVD (`svdcmp`) leaves the singular values unsorted; own one-sided Jacobi SVD written | Resolved           |
| ISS-082 | A4 / problem sheet   | Missing brackets in Det(lambda I - Am - Kob Cm) and a garbled open-loop error equation      | Documented         |
| ISS-083 | A4 / lecturer data   | Plant of Problem 3 is the Ho-Kalman model of Problem 2; generator of `svdku123456.dat` found (RKN, input offset) | Resolved           |
| ISS-084 | A4 / numerics        | Close eigenvalues (1.002, 1, 0.998) lost 10 digits through the characteristic polynomial    | Resolved           |
| ISS-085 | A4 / build           | First form load: "Error reading serP2Sigma.XValues.Order: Invalid property value"          | Resolved           |
| ISS-086 | A4 / UI              | EIntOverflow on Problem 1, system 1, when the mouse moved over the charts                    | Resolved           |
| ISS-087 | A4 / UI              | "Reset model" button of Problem 1 only partly visible at 125 % display scaling              | Resolved           |
| ISS-088 | A4 / UI              | Eigenvalue markers of the Problem 1 pole chart invisible, axis labels 0.999 and 1.001 printed twice | Resolved           |
| ISS-089 | A4 / UI              | Pole chart drawn the unit circle as a line, and two clicks on a legend box reset it to the whole circle | Resolved (retest)  |
| ISS-090 | A4 / method          | Impulse response 1000 times larger than the earlier student program (pulse u(0) = 1/T against u(0) = 1) | Documented         |
| ISS-091 | A4 / lecturer program | Working `MPC.exe` analysed: same formulas, three defects (state reset, stage time as input, output one sample early) | Documented         |

---

### ISS-001 - Integration step printed as "10 sec"

- **Source:** `Materials/HH Simulation.pdf`, slides "HH-Sim 1", ABE, APG, C-F.
- **Analysis:** The lecturer's source code (`hh source code1.docx`) and the
  slide "APP Simulation Result" (`dt = 10 sec`, `dx = 0.4 mm`) use time in ms.
  A 10 s step would make an HH simulation meaningless. The micro sign was lost
  in the PDF export: the step is **10 us = 0.01 ms**.
- **Resolution:** default `dt = 0.01 ms` in every tab.

### ISS-002 - `alpha_m` typo on the slide

- **Source:** `Materials/HH model.pdf` shows `0.1(v + 2.5)/(exp(0.1v + 2.5) - 1)`.
- **Analysis:** The lecturer's code, the senior reports and Hodgkin & Huxley
  (1952) all use `0.1(v + 25)`. With `v + 2.5` the singularity of numerator
  and denominator would no longer coincide.
- **Resolution:** `alpha_m = 0.1(v+25)/(exp(0.1v+2.5)-1)` implemented.

### ISS-003 - PDE coefficient on the slide

- **Source:** `HH Simulation.pdf`, slide "Partial Differential Equation Solution".
- **Derivation:** `d2v/dx2 = (ro+ri)(Cm dv/dt + gm v)` gives
  `dv/dt = d2v/dx2 / ((ro+ri) Cm) - gm v / Cm`. The coefficient is
  `[(ro+ri) Cm]^-1`, not `(ro+ri) Cm^-1`. The lecturer's code divides by
  `cm*(ro+ri)`, which agrees with the derivation.
- **Resolution:** `D = 1/((ro+ri) cm)` used; derivation to be shown in the
  report (Problem 2).
- **Correction (session 8):** the slide image shows the brackets,
  `[(ro+ri) Cm]^-1`; they were lost in the text extraction of the PDF that
  this issue was based on. With `Cm` the capacitance per unit length (the
  slide gives 1.6e-9 mF/mm) the slide is correct and identical to `D`.
  The only defect of that slide is the missing bracket around the second
  difference in the last line (the factor multiplies the whole difference).
  Sheet 4 and the report were corrected.

### ISS-004 - `vm[0,i]` in the lecturer's propagation code

- **Source:** lecturer material `Propagation model computation.docx` (not redistributed):
  `... -(k*gm*vm[0,i]/cm);`
- **Analysis:** The membrane term of node `j` should use `vm[j,i]`. Using node
  0 makes every node leak according to the first node's voltage. This is
  probably a transcription error.
- **Action:** `HHModel.pas` uses the local node voltage. Confirm with the
  lecturer before stating it as an error in the report.

### ISS-005 - `+1e-9` in the rate denominators (senior and peer code)

- **Analysis:** At `v = -25` (`alpha_m`) and `v = -10` (`alpha_n`), numerator
  and denominator both vanish. Adding `1e-9` gives `0/1e-9 = 0`, while the
  correct limits are 1.0 and 0.1 (L'Hopital). Away from these points the hack
  biases the result slightly.
- **Resolution:** `ExpRatio(x) = x/(exp(x)-1)`, with a 2nd-order Taylor series
  for `|x| < 1e-4`. Verified: `alpha_m(-25) = 1.000000`, `alpha_n(-10) = 0.100000`.

### ISS-006 - Senior APP was a pure diffusion of the APG output

- **Analysis:** `vm[j,i+1] = vm[j,i] + D (vm[j-1,i] - 2 vm[j,i] + vm[j+1,i])`,
  with `D = 0.05` chosen arbitrarily and no membrane current. The signal can
  only spread and decay; it cannot regenerate. This contradicts Problem 3
  ("how the model can exhibit the propagation").
- **Resolution:** cable equation with an HH membrane at every node (active),
  plus a passive `gm` mode for comparison.

### ISS-007 - Lecturer RK4 is not a coupled RK4

- **Analysis:** The week-9 code freezes `alpha/beta` at `v(t)`, advances
  `n, m, h` with separate scalar RK4 steps, then advances `v` with the new
  gates held constant. Formally this is a splitting scheme, not a 4th-order
  method for the coupled system.
- **Resolution:** both are implemented (selectable in the GUI). At
  `dt = 0.01 ms` the two differ by at most 0.01 ms in spike times and ISI in all tested cases
  (e.g. Jin = -7: 17.14 vs 17.15 ms), so results are comparable with the
  lecturer's program.

### ISS-008 - Repository hygiene

- **Analysis:** `git status` showed every folder untracked, with no commits and
  no `.gitignore`, including a z-lib copy of Enoka's textbook, the lecturer's
  slides and the senior's reports. Pushing these to a public GitHub repository
  would breach copyright and academic integrity norms.
- **Resolution:** root `.gitignore` versions only own work.

### ISS-009 - Write access denied on the local folder

- **Update 2026-11-01 (session 3):** I allow-listed
  `C:\Program Files\WindowsApps\Claude_4.4212.0.0_x64__pzs8sxrjxfjjc\Claude.exe`
  in Controlled Folder Access. Writes are still denied, both through the
  bridge file commit and through the shell. Either the write is performed by
  a different process than `Claude.exe`, or the cause is the NTFS
  permissions of `C:\Users\Sem 7`. Next diagnostic step: Defender event
  1123 (it names the blocked process) and `icacls`. Allow-listing a
  versioned `WindowsApps` path must also be repeated after every Claude
  update.
- **Root cause (2026-11-01, session 4):** NTFS permissions, not Controlled
  Folder Access. Defender logged no event 1123 for the folder, and `icacls`
  showed only inherited `BUILTIN\Users:(RX)`, i.e. read/execute without
  write. The folder sits directly under `C:\Users` (outside the user
  profile), so it inherits the restrictive `C:\Users` ACL.
- **Resolution:** I added explicit `(OI)(CI)(F)` entries for
  `Everyone` and `BUILTIN\Users` on the folder. Writes now succeed, and all
  session 1-3 files were written into the repository tree.
- **Follow-up (optional hardening):** `Everyone:(F)` is broader than needed.
  Replace it with Modify rights for my account only, then re-test
  write access.

- **Symptom:** `device_commit_files` returned "Windows denied access ... If
  Controlled Folder Access is on, add this app ..."; shell writes return
  `Permission denied`. The folder can still be read.
- **My action:** Windows Security -> Virus & threat protection ->
  Ransomware protection -> Controlled folder access -> "Allow an app through
  Controlled folder access" -> add the Claude desktop app. Alternatively,
  check that the folder is not read-only.

### ISS-010 - First Delphi 13 build pending

- `HHModel.pas` is compiled and tested with FPC 3.2.2 (Delphi mode).
  `Unit1.pas` compiles against VCL/TeeChart stubs only, so property names such
  as `TChart.Legend.LegendStyle` and `TLineSeries.TreatNulls` still need the
  real compiler.
- Embarcadero states that TeeChart Standard ships with RAD Studio 13. Whether
  the Community Edition includes it is unconfirmed: check the Tool Palette for
  the "TeeChart Std" category.

### ISS-011 - Paper metadata for Problem 4

- Amini et al. (2005): verified (IEEE TNSRE 13(2):120-124,
  doi:10.1109/TNSRE.2005.847379).
- Haghiri et al. (2021): title and authors verified. Volume 68, issue 1 (IEEE
  TCAS-I) is taken from the senior report; pages and DOI still need to be
  checked against the PDF.

### ISS-012 - Stability of the explicit cable scheme

- FTCS for `dv/dt = D d2v/dx2 + f` is stable only for `r = D k / h^2 <= 0.5`.
  With squid parameters (`D = 0.336 cm2/ms`): `h = 0.1 cm, k = 0.01 ms` gives
  `r = 0.336` (stable); `h = 0.05 cm, k = 0.01 ms` gives `r = 1.345`
  (unstable).
- **Mitigation:** the solver refuses to run when `r > 0.5` and reports the
  maximum admissible `k = h^2/(2D)`.

### ISS-013 - Boundary artefact at the sealed end

- With zero-flux ghost nodes, the AP peak at the last node is about 37 mV,
  against about 33 mV in the axon interior, because the axial current cannot
  leave the terminal. This is physically consistent with a sealed terminal.
- **Mitigation:** conduction velocity is measured between 25 % and 75 % of the
  axon length, away from both boundaries.

### ISS-014 - Small currents hidden on the shared current axis

- **Found in:** a static preview of the UI v2 styling (`preview_tab1_APG.png`).
  With JNa/JK spanning about +/-800 uA/cm2, JL (about +/-25) and Jin (-10)
  sit flat on the zero line.
- **Resolution:** JL is drawn on a green right axis; the Jin trace was removed
  from the currents chart because it is already shown in the Vm chart.

### ISS-015 - TeeChart calls to confirm on the first real build

- UI v2 relies on `Legend.CheckBoxes`, `Legend.Frame.Visible`,
  `Zoom.Pen.Color`, `Gradient.Visible`, `TChart.Draw(Canvas, Rect)` (PNG
  export), `OnZoom/OnScroll/OnUndoZoom`, `Axis.CalcPosPoint`,
  `Axis.SetMinMax`, `ChartRect` and `TLineSeries.TreatNulls`. These are
  standard TeeChart members, but they were compiled only against stubs. If
  one is missing in the installed TeeChart version, the compiler error names
  it: report it verbatim and the line is replaced.

### ISS-016 - Coding-standard prefixes

- The `delphi-standards` skill requires `A` (parameters), `L` (locals) and
  `C_` (constants) prefixes, and forbids `Break`/`Continue` and `Exit`
  outside guard clauses. `Unit1.pas` v2 follows these rules; `HHModel.pas`
  keeps the session-1 naming (verified numerics). Renaming it is cosmetic and
  should be done in one pass together with a `TestHH` regression run.

### ISS-017 - Inconsistencies inside the assigned papers

- Amini et al. (2005): the Methods section specifies a 150 nA stimulus, the
  caption of Fig. 4 says 100 nA. `DeltaP = P0 - P1` is said to be positive for
  a phase delay, but a delay gives P1 > P0 (negative); the Results text uses
  "phase delay (negative DeltaPhi)".
- Haghiri et al. (2021): the error evaluation is reported for "dt = 10 ms"
  (implausible for HH kinetics, probably a lost prefix as in ISS-001). The
  Nobel Prize is dated 1961 instead of 1963. The single spike at I = 2 uA/cm2
  (Fig. 3(a)) is reproduced by this project's simulator only when the gates
  start at zero: zero gates give a spike at 4.1 ms for Jin = -2 and at 5.4 ms
  even with Jin = 0, while a membrane at rest does not fire. It is therefore
  most likely an initial-condition artefact (inference). The paper also does
  not state how the standard HH equations produce the IB and LTS patterns.
- **Mitigation:** these points are stated as critical notes in the Problem 4
  draft instead of being repeated as facts.

### ISS-018 - Assigned papers inside the repository tree

- Both PDFs are stored in `Assignment 1_HH Model/`. Their footer reads
  "Personal use is permitted, but republication/redistribution requires IEEE
  permission".
- **Resolution:** `/Assignment 1_HH Model/*.pdf` and `**/References/` added
  to `.gitignore`. Recommended layout: move papers into
  `Assignment N/References/`.

### ISS-019 - EInvalidCast on a plain mouse wheel over a chart

- **Report (2026-11-01, first real run):** turning the wheel without Ctrl over a
  chart raised `EInvalidCast: Invalid class typecast` (debugger first-chance
  notification).
- **Analysis:** UI v2 handled only Ctrl + wheel in `FormMouseWheel`, so a
  plain wheel was left to TeeChart's own wheel scrolling. That scrolling
  fires `OnScroll`, and the chart event handlers cast the sender with
  `Sender as TChart`. The most likely cause is that TeeChart passes a sender
  that is not the chart for wheel-initiated scrolls _(inference: the call
  stack was not captured)_.
- **Fix (UI v3):** `TForm1.MouseWheelHandler` overrides the form-level
  wheel routing that VCL uses for every child control. A wheel over a chart
  is consumed there and zooms at the cursor (Shift + wheel: time axis only),
  so TeeChart never receives it. Every chart handler now checks
  `Sender is TChart` instead of using `as`. The interaction help text was
  updated. **Retest required.**

### ISS-020 - Access violation in the refractory example at 2.0 ms

- **Report:** moving the refractory track bar to 2.0 ms raised
  `access violation ... read of address 0x00000040`. Afterwards the example
  chart stayed black, even after a new sweep.
- **Analysis:** the numerical part was re-run headless for intervals of
  1-8 ms: all traces are finite (Vm between -81.2 and 37.1 mV), and the
  threshold is NaN (absolute refractory) for intervals up to 4 ms. What
  differs at 2.0 ms is the UI path. The example chart dropped from three
  series (8 ms) to two (no threshold trace), and the series were freed and
  re-created while legend check boxes were shown. A nil read at offset 0x40
  during painting, which leaves a permanently black chart, fits the legend
  still referencing a freed series _(inference: no call stack yet)_.
- **Mitigation (UI v3):** the example chart owns three permanent series.
  Only their points are replaced, and the third series is deactivated (and
  its legend title explains why) inside the absolute refractory period.
  `ClearChart` switches legend check boxes off while a chart's series list
  is rebuilt and `FinishChart` switches them on again. `Application.OnException`
  writes any remaining exception to `HHSimulator_error.log` (next to the exe)
  and shows a dialog at most once per 2 s for the same error.
- **If it recurs:** press _Break_ in the debugger notification and copy the
  Call Stack window, or send the log file.

### ISS-021 - Missing gate-vs-Vm plots

- The senior program plots m, h and n against Vm. UI v2 offered this only as
  a check box on the gating chart.
- **Resolution:** new tab "2. Gating Phase Plots" with m, h and n against Vm
  over their steady-state curves x_inf(Vm), plus tau_m, tau_h and tau_n
  against Vm (log scale). The loops are thereby explained as the lag of each
  gate behind x_inf. The check box was removed.

### ISS-022 - Known limitations (documented, not defects)

1. Explicit FTCS cable scheme: stable only for r = D k / h^2 <= 0.5 (ISS-012).
   The run is refused otherwise; the Crank-Nicolson option has no such limit
   (ISS-030).
2. An action potential is defined as an upward crossing of Vm = 0 mV.
   Graded responses that stay below 0 mV (for example during the relative
   refractory period) are not counted as APs.
3. Refractory thresholds come from bisection (16 steps) on |J2| in
   [0, |J2|max]. The resolution is |J2|max/65536 (about 0.008 uA/cm2 for
   500), and the absolute refractory period is operational: no AP up to
   |J2|max, for the chosen pulse width.
4. Steady ISI uses spikes after the discard time. Near the onset of
   repetitive firing (long ISI) fewer than two spikes may remain, giving
   "n/a". The onset of depolarization block is the first level with "n/a"
   after repetitive firing has started.
5. The cable model assumes a uniform axon with sealed ends (or the APG
   waveform imposed at x = 0). The lecturer's slide gives Cm per unit length
   but not ri, ro and gm, so the lecturer preset uses a = 5 um and
   Ri = 35.4 ohm.cm, which reproduce the attenuation of the lecturer's plot
   (ISS-029). Temperature scales the gate rates only, not the conductances.
6. APG stores every sample. The number of steps is limited to 5e6, and
   plotting is decimated to about 8000 points per series.
7. "Lecturer sequential RK4" is a splitting scheme (ISS-007), offered for
   comparison only.
8. Computation runs on the UI thread. During sweeps the window only updates
   the status bar, and re-entrant clicks are ignored (`FBusy`).
9. Flat buttons are TPanel controls: they show hover and pressed colours but
   cannot take keyboard focus. F5 (run the active tab), F1 (theory sheet of
   the active tab), Esc (stop the animation or close a sheet) and Alt+F4
   cover the keyboard.
10. The error log is written next to the executable (`Win32\Debug`), so that
    folder must be writable.

### ISS-023 - Axon length 0-6 cm here, 0-2 mm in the lecturer and senior programs

- **Observation (user, session 6):** the APP x axis runs from 0 to 6 cm,
  while the lecturer's and the senior's programs show 0 to 2 mm.
- **Analysis:** deliberate, and not a change of the equations. The cable PDE
  (sheet 4) and the FTCS scheme (sheet 5) are the lecturer's; only the fibre
  geometry differs. The program uses the squid giant axon of HH 1952
  (a = 238 um, Ri = 35.4 ohm.cm) because that case can be validated: 12.0 m/s
  at 6.3 deg C and 18.2 m/s at 18.5 deg C against 18.8 m/s calculated and
  21.2 m/s measured by HH 1952. With about 12 m/s and an AP lasting about
  2 ms, the AP is about 2.4 cm long, so a 2 mm squid axon would be shorter
  than the AP itself and no travelling wave could be seen. Hence 6 cm.
- The lecturer's constants (Cm per unit length 1.6e-9 mF/mm, dx = 0.4 mm)
  imply a much thinner fibre (inference from the slide values, needs
  confirmation by the lecturer). The senior program labels x in mm but uses
  a lumped diffusion coefficient without fibre geometry.
- **Resolution (UI v4):** lengths are entered and shown in mm, and a preset
  "Lecturer scale (2 mm)" was added: a = 1 um, 2 mm axon, h = 0.1 mm
  (r = 0.14), recording sites every 0.4 mm, conduction velocity about
  0.78 m/s (Python reference). The squid preset stays the default because it
  is the validated one. The report states both.

### ISS-024 - Sheet windows: points to confirm on the first Delphi build

1. The sheet PNG (130 dpi, 998 px wide) is shown unscaled by `TImage`. On a
   display scaled to 150 % it looks smaller than the form text; Copy and
   Save use the full resolution. A zoom option can be added if needed.
2. Sheet windows are owned by the main form (`PopupParent`), stay above it
   and cascade along the right edge of the work area.
3. `TLabel.EllipsisPosition`, `PopupMode`/`PopupParent` and
   `Screen.MonitorFromWindow` were checked against stubs only.
4. After editing a sheet (.tex), run `build_sheets.py` and rebuild the
   project; the PNG files are linked into the executable at build time.

### ISS-025 - 3D mesh: resolution and drawing order

- The mesh is sub-sampled to at most 46 x-lines and 91 t-lines (last node
  and frame always included) to keep GDI drawing fast; detail between lines
  is visible in the heat map, which keeps full resolution.
- Hidden lines are removed by drawing white-filled cells from far to near
  (rows by x, columns by t, order chosen from the sign of cos(yaw) and
  sin(yaw)). This is valid for the orthographic projection used, with pitch
  limited to 0..80 deg; checked visually with `mesh_preview.py`.

### ISS-026 - Flicker of the 3D space-time views during animation

- **Observation (user, session 7):** the 3D waterfall and 3D mesh flicker
  when Play runs or the time slider moves; it is hard to tell the moving
  profile from the static surface.
- **Cause:** every frame called `pbSpaceTime.Invalidate`. A `TPaintBox` has
  no window of its own, so Windows first erases its area on the parent panel
  (white) and the view is then drawn again element by element directly on
  the screen (for the mesh about 2,700 polygons). The visible white frame
  plus the progressive redraw is the flicker. The whole surface was also
  recomputed 25 times per second although only the profile changes.
- **Fix (UI v4.1):** off-screen buffer (`FSpaceBuffer`) copied with one
  `Draw`; cached surface layer (`FSpaceCache`) rebuilt only when the view,
  yaw, pitch, size or run changes; the per-frame overlay draws only the
  black profile and the caption; `RefreshSpaceTime` paints directly during
  animation instead of invalidating. The projection is auto-fitted so no
  angle clips the surface.
- **Retest:** Play with each view; drag yaw and pitch (the surface is
  rebuilt while dragging, which is expected to be fast but is not cached).

### ISS-027 - Report figures from older program versions

- Figures 2.1, 2.3, 2.5, 2.6 and 2.8(a) were captured with UI v2/v3 (old
  caption "Hodgkin-Huxley Neuron Simulator - Biocybernetics Assignment 1");
  the numerical results are unchanged since then (HHModel.pas not modified).
  Figure 2.8(b) shows the clipped mesh fixed in v4.1.
- **Action:** capture tabs 1, 3, 4 and the 3D waterfall/mesh with v4.1 and
  rebuild with `Report/source/build_report.py`, or paste them in Word.
- Equation numbers are typeset inside the equation with em-quad spaces; Word
  shows the spacing, LibreOffice collapses it (preview only).

### ISS-028 - Stale legend entries after a new APP run

- **Observation (user, session 8):** after switching to the lecturer
  preset, the curves were new but the legends still listed
  "x = 12.00 mm ... 60.00 mm" and "t = 1.72 ... 10.28 ms" of the squid run.
- **Analysis:** every run frees the series and creates new ones. The legend
  entry of the time-slider series, whose title is re-assigned on every
  frame, was always correct, so TeeChart refreshes a legend text when a
  title changes but kept the old texts for the newly created series
  (inference from the observed behaviour; the TeeChart source is not
  available to confirm).
- **Fix (UI v4.2):** `FinishChart` re-assigns every series title and toggles
  the legend visibility after a rebuild, for all charts. **Retest:** squid
  run, then lecturer run, and compare the legends.

### ISS-029 - One wave only in tab 5; lecturer's APP setting

- **Observation (user, session 8):** the lecturer's and the senior's plots
  show several waves; tab 5 showed one, and the lecturer directs the
  passive cable (slide "Partial Differential Equation Solution").
- **Analysis:** the several ridges are successive action potentials in time
  on one axon, not several axons. The lecturer's program loads the APG
  output ("Load Data") and propagates it along a passive 2 mm cable
  (dx = 0.4 mm, dt = 10 us); tab 5 used one current pulse.
- **Resolution:** excitation "APG waveform (tab 1)" imposes the tab-1 APG
  trace on node 0, and "Current pulses" allows a pulse train. The lecturer
  preset (default) uses the passive cable with the APG drive: four action
  potentials (2.91, 17.84, 32.49, 47.12 ms) give four attenuated waves with
  peaks 35.3, -9.5, -32.7, -45.0, -50.4, -51.9 mV at 0 to 2.0 mm
  (lambda = 1.02 mm), identical in HHModel and the Python reference.
- The Vm(x) snapshots are taken at six evenly spaced instants; a snapshot
  between two waves shows an almost flat (recovering) profile, which is
  correct. The time slider shows any instant.

### ISS-030 - Crank-Nicolson scheme

- The lecturer's propagation code contains a Crank-Nicolson line, written
  inside the explicit loop with values of level n+1 that are not yet
  computed (a transcription that only approximates the scheme). The senior
  program also offers it.
- **Resolution:** `csCrankNicolson` in `SimulateCable`: trapezoidal rule for
  the diffusion term, explicit membrane and stimulus terms, tridiagonal
  system solved with the Thomas algorithm, sealed ends via ghost nodes,
  Dirichlet row for the APG drive. Squid axon, h = 0.5 mm, k = 0.01 ms
  (r = 1.345): FTCS refused, Crank-Nicolson 12.12 m/s (FTCS with
  k = 0.0025 ms: 12.25 m/s).

### ISS-031 - ABE and C-F converter of the lecturer's simulator

- The lecturer's HH-Sim 1 has tabs for anode break excitation (ABE) and the
  current-to-frequency (C-F) converter. Neither is asked in Problems 1-4.
- C-F converter: identical to tab 4 (constant Jin, steady frequency); the
  tab was renamed. The lecturer's range -7 to -40 uA/cm2 is inside the
  default sweep (0 to -70 uA/cm2), which also shows onset and block.
- ABE: available in tab 1 with a positive step (hyperpolarizing in HH sign),
  e.g. +5 uA/cm2 from 5 to 25 ms. With the membrane starting at rest, a
  rebound spike occurs for +3 and +5 uA/cm2 but not for +1, +1.5 and +2
  (the slide reports +2 as well; the threshold lies between 2 and 3 and
  depends on the pulse duration and initial state). Not added as a tab.
- Lecturer constants: Cm = 0.001 mF/cm2 = 1 uF/cm2 (used); dt = 10 us
  (used); APP Cm = 1.6e-9 mF/mm per unit length (= 2 pi a Cm, a = 2.5e-2 um
  for Cm = 1 uF/cm2, not physiological; the preset matches the attenuation
  instead, ISS-029); dx = 0.4 mm (used by the lecturer preset).

### ISS-032 - Repeated rows in the tab 5 memo on a coarse grid

- Seen in the Figure 2.10 screenshot (lecturer preset, 6 nodes): the peak
  table listed x = 0.00, 0.00, 0.40, 0.80, 0.80, 0.80, 1.20, ... because
  `ReportCable` prints 11 rows at `Round(i (N - 1) / 10)`, and Delphi's
  banker's rounding maps several rows onto the same node when N < 11.
  `PlotCable` had the same weakness when the recording sites (2-8) exceed
  the node count.
- **Resolution:** `ReportCable` skips a node equal to the previous one;
  `PlotCable` uses `Min(ASites, NNodes)`. Values unchanged, only duplicates
  removed. Figure 2.10 has to be captured again.

### ISS-033 - Python references ran in CI without any assertion

- The workflow executed `hh_reference_apg.py` and `hh_reference_app.py`,
  which only print. A wrong result would still pass; only a crash failed
  the step, so the "independent cross-check" was not enforced.
- **Resolution:** `crosscheck.py` imports the three references and compares
  them with the fresh harness output (`actual.txt`): spike count exact, ISI
  0.02 ms, peak 0.05 mV, staircase times 0.02 ms, squid velocity 1 % (the
  Python reference takes the crossing on the time grid, the harness
  interpolates: 12.097 vs 12.037 m/s), lecturer passive peaks 0.15 mV.
  A mutated golden file (ISI 14.90, peak -9.9) is reported as 2 failures.

### ISS-034 - Node 20 removed from GitHub-hosted runners

- GitHub announced on 2026-09-23 that Node 20 is no longer available on
  hosted runners and the `ACTIONS_ALLOW_USE_UNSECURE_NODE_VERSION` opt-out
  was removed. The workflow used `actions/checkout@v4` and
  `actions/setup-python@v5` (Node 20 releases).
- **Resolution:** bumped to `actions/checkout@v6` and
  `actions/setup-python@v6`; validated with actionlint 1.7.7. The remote
  file tools may not write `.github/workflows/`, so I copy the
  new workflow file into place before the first push.

### ISS-035 - Visual design created at run time

- The lecturer checks the form in the Delphi Form Designer before the
  program is run. Up to UI v4.2 the charts were bare `TChart` objects in
  `Unit1.dfm`: titles, axes, legends, colours and every series were set or
  created in `FormCreate` and the plot routines, the parameter tables were
  filled in code, and the equations of tab 6 were loaded from resources.
- **Resolution (UI v4.3):** `design10.py` rewrote the IDE-saved form: all
  chart properties and 48 series as design-time objects, events bound in
  the form, parameter rows, memo text and equation pictures stored in the
  form. Only TeeChart properties that appear in DFM files saved by recent
  Delphi versions (senior projects) or that the old code already set were
  used. If the IDE reports an unknown property when opening the form,
  choose Ignore, save, and report the property name.
- Remaining run-time parts: data of the series, titles that depend on a
  run (tab 5), colours of a changed number of recording sites, and the
  heat map / 3D views drawn on `pbSpaceTime`.

### ISS-036 - Life dates of Lagrange on the lecture slide

- **Source:** `Materials/Lagrangian and Hamiltonian Mechanics.pdf`, slide 2:
  "Joseph-Louis Lagrange ... 1756-1813".
- **Analysis:** Lagrange was born in Turin on 25 January 1736 and died in
  Paris on 10 April 1813. The dates of Hamilton (1805-1865) are correct.
- **Action:** I do not repeat the dates in my report.

### ISS-037 - "The Hamiltonian is a conserved quantity" without conditions

- **Source:** same slides, table "Differences" (row 5) and slide "Hamiltonian
  formulation" (`H = m v^2 - (T - V) = T + V`).
- **Analysis:** `H = sum p q' - L` equals `T + V` only if the constraints do
  not change with time, and H is conserved only if L has no explicit time
  dependence. Both conditions hold for the pendulum of Problem 2.
- **Action:** I state the conditions in one sentence in Section 1.3.

### ISS-038 - Coordinate names and angle convention of the assignment sheet

- **Source:** `lagrangian-Hamiltonian Assignment#2.pdf`, Problem 2(a):
  "spherical polar coordinates r, phi, z".
- **Analysis:** the spherical coordinates of the figure are `(r, theta, phi)`;
  `z` belongs to the cylindrical set `(rho, phi, z)`. In the figure theta is
  measured from the upward z axis, so the bob hangs at theta = pi and the
  gravity term of the theta equation is positive.
- **Mitigation:** I keep the figure's convention, state where the bob hangs
  and give the familiar form in `alpha = pi - theta` (Section 2.2.3).

### ISS-039 - Double dot in the problem statement (Section 2.1)

- **Analysis:** the Word accent "dot" of Problem 1(a) and 1(b) was applied to
  a theta that already carried a dot, so it read like a second derivative.
- **Resolution:** the build script replaced the two base characters by a
  plain theta; the rest of Section 2.1 is unchanged.

### ISS-040 - Senior report of the same assignment (2025), reference only

- **Source:** A2 report of Senior D (2025, not redistributed).
- **Analysis:** the report writes `L = 1/2 m thetadot^2 - V` and
  `p = m thetadot`. This is correct if theta is a distance (the lecture uses
  x the same way), but for an angle `m thetadot^2` has the unit kg/s^2 and
  the moment of inertia is needed. Problem 1 does not say which, so I write
  `T = 1/2 M thetadot^2` with M = m for a distance and M = I for an angle.
  Further points: Hamilton's principle is not used (the proof asked in
  Problem 1 is missing), r is treated as a coordinate although `rdot^2` is
  missing in T, and H contains `p_r/(2m)` (not squared).
- **What I reused:** nothing directly; the final theta and phi equations of
  that report agree with mine.

### ISS-041 - Senior Final Project motion equation (shoulder joint)

- **Source:** FP program of Senior A (shoulder joint, `Unit1.pas`,
  `motioneq`, lines 128-132); the same procedure is in the FP programs of
  Senior B and Senior C (not redistributed).
- **Analysis:**
  1. By operator precedence only the gravity term is divided by the
     inertia; damping, stiffness, active torque and the centrifugal term
     are not.
  2. Passive torques enter with a positive sign and are only restoring
     because negative values are typed into the edit fields.
  3. The rest posture lies on the pole of the spherical coordinates
     (theta = 0), where phi is undefined; the constant 0.3726 added to the
     denominator hides the singularity but changes the dynamics.
  4. Constants 3.52 kg and 0.313 m are hard-coded and differ from the report.
  5. `phi := 30` (degrees) is used inside trigonometric functions (radians).
  6. The Runge-Kutta-Nystroem update is correct and reusable (the report
     writes the last divisor as 4 instead of 3).
- **Consequence for my FP:** one planar pendulum per anatomical plane in the
  angle from the hanging position, passive and active torques as generalized
  forces with their physical sign, parameters from BW and BH.

### ISS-042 - Kinetic energy in the senior FP reports

- **Analysis:** `Ek = 1/2 m v^2 + 1/2 I thetadot^2` with `I = I_O` counts the
  rotation twice; for a rigid segment either `1/2 m v_G^2 + 1/2 I_G omega^2`
  or `1/2 I_O omega^2`. One revision (Senior C) uses
  `I_O = 7 m l^2/12`; for a uniform rod about its end `I_O = m l^2/3`.
- **Action:** for my FP.

### ISS-043 - PID and parameter adaptation in the senior FP programs

- **Analysis:** `pid := pidbef + (Kp e + Ki h sum(e) + Kd (-thetadot))` adds
  the full positional PID output to the previous output at every step (an
  extra integrator). In the adaptation `p := p - eta dV/dp`, Ki uses a fixed
  0.01 instead of the learning rate. The lecture slide of the adaptive PID
  (Control Eng. 2, p. 63) contains the learning rate eta; the FP handout
  writes `p = p - dV/dp` without it.
- **Action:** for Assignment 3 and my FP.

### ISS-044 - Discrete PID "Model I" on the controller slide

- **Source:** `Materials/control eng in biomedical application 1_
Controller.pdf`, p. 42 (Model I), also p. 43 (Model II).
- **Analysis:** with `U/E = Kp + Kd (z-1)/z + Ki z/(z-1)` (p. 41) the common
  denominator `z(z-1)` gives the numerator `Kp z(z-1) + Kd (z-1)^2 + Ki z^2`;
  the slide writes `Ki z`. With the slide's own integrator the difference
  equation is `u[n] = u[n-1] + (Kp+Kd+Ki) e[n] - (Kp+2Kd) e[n-1] + Kd e[n-2]`;
  the slide's version delays the integral term by one sample. I checked the
  expansion by hand. The Ziegler-Nichols tables of `PID ZN METHOD.pdf` are
  consistent (`Ki = Kp/Ti`, `Kd = Kp Td`).
- **Action:** I will confirm this with the lecturer before Assignment 3.

### ISS-045 - Numerical details of the A2 program

- RK4 is not symplectic, so H drifts slowly; my program reports the drift
  (4e-10 m g l over 20 s at a 1 ms step).
- For planar motion (`phidot = 0`, `p_phi = 0`) the terms with `cot(theta)`
  and `1/sin^3(theta)` are 0 times a value that is infinite when the bob
  passes the vertical axis. `PendulumModel.pas` sets these terms to zero
  when phidot (or p_phi) is exactly zero. Start angles on the axis
  (alpha0 = 0 or 180 deg) are refused by the form.

### ISS-046 - Missing content type for the EMF logo (report build)

- **Analysis:** the cover image of my template is an EMF file, and the first
  A2 build registered only PNG in `[Content_Types].xml`; Word reports such a
  package as damaged. Found before delivery (python-docx refused the file).
- **Resolution:** `build_report.py` registers a content type for every media
  extension in the package.

### ISS-047 - Corrections to my first A2 report draft

- **Problem 1:** the draft used `I = m l^2` ("bob on a link") from Problem 2,
  although Problem 1 has no length. I now write the general inertia M of
  the coordinate (M = m for a distance, as in the lecture; M = I for an
  angle), so `p = M thetadot` and `pdot = F` give F = m a or torque =
  I alpha.
- **Problem 2(a):** the draft derived the velocity with a free r and set
  r = l afterwards, which left `rdot` terms in the derivation. I now set
  r = l and rdot = 0 from the start.
- **Problem 2(b):** I added Section 2.2.5, which explains that the equations
  of motion give accelerations (Lagrange) or rates (Hamilton) and that the
  position follows from integrating them (numerically with RK4).
- **Length:** 27 pages reduced to 14 (shorter theory, four figures, one
  results table).
- **Verification:** the Python scripts (SymPy and an RK4 simulation) were
  replaced by the Delphi program in `Program/` and an FPC test of its
  numerical unit in CI.

### ISS-048 - Derivations of my second A2 draft too short

- **Problem:** while shortening the report I also shortened the derivations,
  so most blocks went straight to the highlighted result without the steps
  in between.
- **Fix:** I restored the full step-by-step derivations of my first draft
  (each step from a known quantity and a named rule: Taylor expansion,
  integration by parts, fundamental lemma, chain and product rule,
  Legendre transform), keeping the corrections of ISS-047. The equation
  numbers of the results are unchanged, so the code comments still match.
- **Format:** prose paragraphs keep my first-line indent (1 cm) and use full
  sentences instead of most colons and semicolons. Multi-line derivations
  are written as one full equation per row, because a row that starts with
  "=" is shown as a missing operand in LibreOffice.
- **Result:** 16 pages instead of 14.

### ISS-049 - ZN Method 1 applied to an oscillatory plant

- **Source:** `Materials/PID ZN METHOD.pdf`, p. 2 (reaction curve of
  `G(s) = K e^(-L s)/(T s + 1)`, slope `R = K/T`) and p. 3 (P: `Kp = 1/RL`,
  PI: `Kp = 0.9/RL`, `Ki = 0.27/RL^2`, PID: `Kp = 1.2/RL`, `Ki = 0.6/RL^2`,
  `Kd = 0.6/R`). The table equals the classical `Kp = 1.2 T/(K L)`,
  `Ti = 2L`, `Td = 0.5L` with `Ki = Kp/Ti`, `Kd = Kp Td`; R is the maximum
  slope per unit step amplitude.
- **Analysis:** plant 1 is `G1(s) = 1/(s^2 + 0.5 s + 1)` with `wn = 1 rad/s`
  and `zeta = 0.25`, so the step response overshoots by
  `exp(-pi zeta/sqrt(1-zeta^2)) = 44.4 %`. The reaction-curve model assumes
  an aperiodic (S-shaped) response. The tangent construction is still
  defined: the inflection point lies at `wd t* = arccos(zeta)`, giving
  `t* = 1.3614 s`, `y* = 0.6442`, `R = wn exp(-zeta wn t*) = 0.7116 1/s`,
  `L = t* - y*/R = 0.4561 s`, `T = 1/R = 1.4053 s` (`L/T = 0.32`). My
  RK4 check (dt = 1 ms) gives R = 0.7115, L = 0.4559 s.
- **Action:** I will use the exact tangent construction and state in the
  report that the FOPDT fit of plant 1 is poor (the oscillation is not
  captured), so the resulting gains are a starting point.

### ISS-050 - The `2 x'` term of plant 2

- **Source:** problem sheet, Equation (2): `y'' = -1.5 y' - y + 2 x' + x`.
- **Senior code:** the PID programs of five seniors (A to E) and the report
  of a classmate all pass `xdot = 0`
  for the whole run. That simulates `1/(s^2 + 1.5 s + 1)`, not the given
  plant `G2(s) = (2s + 1)/(s^2 + 1.5 s + 1)`.
- **Analysis:** numerical differentiation of a step input gives a single
  spike of height `1/dt`, which is not a usable derivative. I will use the
  controllable canonical realisation `z'' = -1.5 z' - z + x`,
  `y = z + 2 z'`, which needs no derivative of the input and keeps the
  "second-order differential equation" form of the problem. With the zero
  the step response has `y'(0+) = 2` and `y''(0+) = -2`, so the slope is
  largest at `t = 0+`. There is no inflection point and the tangent passes
  through the origin, so `L = 0` and the Method 1 formulas divide by zero.
  RK4 check: R = 1.999 at t = 0, overshoot 35.9 %.
- **Action:** decision on how to make Method 1 defined for plant 2 is
  linked to ISS-051.

### ISS-051 - Critical gain Ku for second-order plants

- **Source:** `Materials/PID ZN METHOD.pdf`, p. 4 (increase Ku until the
  closed loop is marginally stable, measure Pu) and p. 5 (P: `0.5 Ku`,
  PI: `0.45 Ku`, `0.54 Ku/Pu`, PID: `0.6 Ku`, `1.2 Ku/Pu`, `0.075 Ku Pu`).
- **Analysis:** with `u = Kp e` the characteristic equations are
  `s^2 + 0.5 s + (1 + Kp) = 0` (plant 1) and
  `s^2 + (1.5 + 2 Kp) s + (1 + Kp) = 0` (plant 2). Both have positive
  coefficients for every `Kp > -1`, so the loop never becomes marginally
  stable. Plant 2 even becomes more damped as Kp grows. In a sampled
  simulation the loop does go unstable, but only because of the zero-order
  hold of the step dt. The simulated critical gain is Ku = 1000 for
  dt = 1 ms and Ku = 100 for dt = 10 ms for both plants (`Ku dt = 1.000`),
  confirmed by the eigenvalues of the one-step map of the sampled loop.
  Pu is 0.199 s / 0.625 s for plant 1 and exactly two steps for plant 2.
  These are numerical artefacts, not plant properties. (My first quick
  estimate, `0.33/dt` and `0.5/dt`, came from a growth test whose windows
  were shorter than one period of plant 1; the program uses a run of at
  least 40 s for this test.)
- **Senior code:** Seniors A, B and D read Ku from an edit box (default 1)
  and take Pu from the peaks of a damped response. Senior C (revision)
  reads Ku from a scroll bar.
- **Decision (2026-11-14):** I add an adjustable transport delay (dead time)
  theta at the plant input, default 0.1 s, as a stated modelling assumption
  (for example the electromechanical delay between stimulus and muscle
  force in FES). The program also runs theta = 0 and reports there that
  Ku does not exist. A sampled controller period was rejected because it
  leaves L = 0 for plant 2. With a delay of 0.1 s the analytic values are Ku = 5.050,
  Pu = 2.587 s (plant 1) and Ku = 8.161, Pu = 0.385 s (plant 2).

### ISS-052 - Input argument shifted by dt/2 in the lecturer RK program

- **Source:** `Materials/control eng in biomedical application 1_
  Controller.pdf`, p. 20 (Runge-Kutta-Nystrom form for `y'' = f(x, y, y')`,
  where x is the independent variable) and p. 44 (program example
  `difeq(y2+0.5*dt*(y2dot+0.5*k1), y2dot+k1, x2+0.5*dt)`).
- **Analysis:** in `difeq` the third argument is the plant input, not time,
  so `x2 + 0.5*dt` changes the input by `dt/2` inside the stages (a bias of
  0.05 % of a unit step at dt = 1 ms). Two senior programs (A and B) copied this.
- **Action:** I keep the Nystrom stage structure of p. 20 and p. 44 but hold
  the input constant over one step (zero-order hold).

### ISS-053 - How the seniors measured L and T

- **Senior code:** Seniors A and B and a classmate take L as the time when y
  first exceeds 0.25 and T as the time from there until y reaches 1.
  Senior C (first version) takes L inside the band 0.1 < y < 0.2 and T at
  63.2 % of the final value. None of them draws the tangent at the
  inflection point of p. 2.
- **Action:** I will find the inflection point from the maximum of `y'`
  (taken from the RK4 state, not from a finite difference) and draw the
  tangent on the chart.

### ISS-054 - ZN PI controller on plant 1

- **Check:** closed-loop RK4 runs (dt = 1 ms, positional PID of the
  controller slides, p. 45) with theta = 0.1 s. Plant 1, Method 1:
  R = 0.7115, L = 0.5559 s; Method 2: Ku = 5.050, Pu = 2.587 s.
- **Result:** P (Kp about 2.5) is stable with a steady-state error of
  `1/(1+Kp) = 0.286`. PID is stable (overshoot 63 % for Method 1, 51 % for
  Method 2, no steady-state error). PI is unstable for both methods: the
  oscillation grows without bound. Without delay the Method 1 PI loop
  `s^3 + 0.5 s^2 + (1 + Kp) s + Ki` has roots `-0.008 +/- 1.94j`, so it is
  only just stable. Plant 2 is stable with every ZN controller.
- **Analysis:** the ZN tables target an aperiodic process and a quarter
  decay ratio. Plant 1 has a resonance (zeta = 0.25). PI adds about 90
  degrees of phase lag at low frequency and no damping, so the resonant
  pair moves into the right half plane. The derivative term of PID adds
  the damping that is missing.
- **Action:** the program detects divergence (output bound and a growing
  oscillation envelope), stops the run and marks the controller as
  unstable instead of crashing. The report discusses it as a limitation of
  ZN tuning.

### ISS-055 - Personal names in tracked Markdown

- **Problem:** `ISSUES.md` named senior students and the lecturer (folder
  paths and program authors), and three READMEs named the lecturer.
- **Fix:** seniors are now Senior A to E, a classmate is "a classmate",
  the lecturer is "the course lecturer" (READMEs, issue entries, the A1
  README reference [2]).
- **Remaining:** earlier commits on GitHub still contain the names, and the
  report sources of A1 and A2 (`Report/source/*.md`, `.docx`, `.pdf`) cite
  the lecture notes with the lecturer's name, as IEEE requires for the
  submitted reports. Rewriting the Git history is my decision, not done.

### ISS-056 - Derivative kick of the PID law at t = 0

- **Source:** controller slides, p. 45 (`eold := e; e := r - y;
  de := (e - eold)/dt`). If `e` starts at 0, the first step gives
  `de = r/dt` and the controller output jumps to `Kd r/dt` (843 for the
  plant 1 PID of Method 1 at dt = 1 ms) for one sample.
- **Decision:** I keep the derivative on the error, as in the slides, but
  start `e_old` at the first error, so the derivative term begins at zero.
  The setpoint is treated as present before the controller starts. This
  keeps the controller-output chart readable and does not change the
  stability of any loop.

### ISS-057 - Equation rendering in my first A3 report build

- **Problem:** in the LibreOffice preview the inline symbols `t^*`, `y^*`,
  `0^+` and `\dddot z` were shown as a wrong glyph or dropped, and
  Equation (1.15) was cut at the right margin.
- **Fix:** I write `t_m`, `y_m` (time and value of the largest slope),
  `(0)` with the words "right after the step", and `\dot{\ddot z}`; long
  equations are split into rows, one full equation per row (as for A2,
  ISS-048). The equation window of the program uses the same notation.

### ISS-058 - Warnings of the first Delphi 13 build of A3

- **Found in:** my first build in Delphi 13 CE (Win32): `ZNModel.pas(323)` and
  `ZNModel.pas(672)` W1036 "Variable 'LY' might not have been initialized",
  `Unit1.pas(99)` H2269 "Overriding virtual method
  'TForm1.MouseWheelHandler' has lower visibility (protected) than base
  class 'TForm' (public)".
- **Cause:** in `SimulateOpenLoop` and `SimulateClosedLoop` the last output
  `LY` is read after the loop. The loop always runs at least once, but the
  compiler cannot prove it. `MouseWheelHandler` is public in `TForm`.
- **Fix:** `LY := 0.0` before each loop (also in `SimulatePLoop`), and
  `MouseWheelHandler` moved to the public section. Free Pascal reported
  neither case, so the Delphi build log is the reference for warnings.

### ISS-059 - Layout of the first A3 program

- **Problem:** the first version ran both methods at once and showed four
  charts with many series, and only the simulation settings could be
  edited. The earlier programs of this course, which the lecturer has seen
  at the demos, use one action per button (impulse response, step
  response, Method 1, Method 2), one chart per result, and edit fields for
  Ku, Pu, Kp, Ki, Kd and the results R, L, MP, %MP.
- **Fix (UI v2):** three tabs (Plant Model and RK4 for Problems 1 and 2, ZN
  Method 1, ZN Method 2), the names of the earlier programs with a short
  explanation in brackets, separate charts with few series (legend lists
  only series with points), editable R, L, Ku, Pu, Kp, Ki, Kd, a Test Ku
  button, CLEAR and EXIT, a message log, warnings and input checks.
  Buttons and card headers are TPanels designed in the form and painted by
  an interposer class (gradient, hover, pressed), so no custom component
  has to be installed in Delphi CE.

### ISS-060 - Impulse input

- **Source:** controller slides, p. 44: `x := 1` during the first step, then
  `x := 0`, a pulse of area dt (0.001 at dt = 1 ms), so the response is
  1000 times smaller than the impulse response g(t).
- **Decision:** `SimulateImpulse` applies `x0/dt` during one step (area x0).
  With dt = 1 ms the result differs from the exact g(t) of plant 1 by less
  than 5e-4 (test case C9). The peak of g(t) for plant 1 is 0.7115 at
  1.362 s, the slope R and the time t_m of the Method 1 tangent.

### ISS-061 - Form of UI v2 could not be opened

- **Found in:** opening Project1 in Delphi 13 after UI v2: "Error reading
  rgZN1Ctrl.Font.Color: List index out of bounds (2). TList is empty."
- **Cause:** my form generator wrote `ItemIndex = 2` before the `Font`
  properties of both radio groups. While the form is read, the radio
  buttons do not exist yet (they are made from `Items.Strings`). The font
  change that followed tried to update the selected button with index 2
  in an empty list. Delphi itself writes the font before `ItemIndex` and
  `Items.Strings`, which avoids this.
- **Fix:** both radio groups now use the Delphi order (geometry, `Color`,
  `Font`, `ItemIndex`, `Items.Strings`, `Parent*`, `TabOrder`, event); the
  redundant `Columns = 1` was removed. The generator writes the same order,
  so a regenerated form is identical.
- **Lesson:** a property that refers to a list item (`ItemIndex`) must
  follow every property that can repaint the control, and a form
  generator must copy the property order of a form saved by Delphi, not
  only its property names.
- **Note:** an earlier repair of the same error removed the `Font` lines of
  both radio groups instead. I replaced that copy with the Delphi-order
  version, which keeps the intended font. "Ignore" in the error dialog is
  not safe, because the IDE may drop components when it saves the form.

### ISS-062 - A3 workflow watched the A2 workflow file

The path filter of `.github/workflows/a3-model-regression.yml` listed
`a2-model-regression.yml` (copied from the A2 workflow). A change to the A3
workflow alone would not have started the A3 job. I found this while
reading the workflows for the Final Project and pointed both filters to
`a3-model-regression.yml`. The A1 and A2 workflows were already correct.

### ISS-063 - Wrist FP of Biomodelling, control loop outside the dynamics

My Biomodelling Final Project (wrist joint, Semester 5) integrates a free
pendulum as the target angle and then moves the "realized" angle with
`reald := reald + Kp e + Ti sum(e dt) + Td de/dt`. This is a kinematic filter.
No joint torque enters the motion equation, so the program does not show
torque control at all. Further points in the same program are listed here
so that none of them returns in the shoulder model.

1. The chart named "Torque" plots de/dt.
2. The fields named Ti and Td are used directly as the gains Ki and Kd.
3. The RMSE squares the mean of the two axis errors, so errors of opposite
   sign cancel. Each axis needs its own RMSE.
4. The stiffness term is not divided by the inertia while gravity is
   (mixed units in one acceleration).
5. Mass `0.006 BW + 0.054` (a regression for the hand), BW = 60 kg,
   BH = 160 cm and l = 0.517 m are hard-coded and not consistent.
6. The physics runs inside a 10 ms `TTimer`, so simulated time depends on
   the user interface.

For the shoulder model I reuse only the OpenGL set-up, the arm drawing, the
camera controls and the Runge-Kutta-Nystroem step (identical to the lecture
slide). The numerical core is new and has no UI dependency.

### ISS-064 - Anthropometric tables of the FP handout

The Fischer column of the segment weight table has no values for the lower
arm and the hand, so it cannot give the mass of the whole arm. The length
table has one source only (upper arm 17.20, lower arm 15.70, hand 5.75 per
cent of BH). For BW = 74 kg and BH = 171 cm the Dempster values give
m = 5.0 % of BW = 3.70 kg and l = 0.6609 m. The handout asks for a uniform
rod, so the centre of mass sits at l/2 = 0.330 m. The composite centre of
mass from the Dempster COM table is 0.276 m from the shoulder, so the
uniform rod overestimates the gravity moment by about 20 per cent. I keep
the handout assumption in the model and discuss the difference in the
report. The choice of table scales m, the inertia, the torques and the
gains by the same factor (up to 24 per cent between Clauser and
Braune-Fischer). It does not change the passive kinematics when C and k
scale with it.

### ISS-065 - Reference trajectory and RMSE of the lecturer screenshot

The handout shows the lecturer program with a flexion target close to
30 sin(2 pi 0.25 t) deg and an abduction target close to 10 cos(2 pi 0.25 t)
deg, both over about 3.5 s. These values are my reading of the figure, not
numbers given in the text. The RMSE shown there (0.819 deg) is above the
0.75 deg criterion of Problem 4, most likely because the start transient is
included. My program will report the RMSE over the whole run and after the
settling time, and will state which one is compared with the criterion.
I will confirm the intended reference with the lecturer.

### ISS-066 - Gradient of the adaptation rule

The handout writes `p = p - dV/dp` with `V = 1/2 sum(e^2)`. The exact
gradient is `dV/dp = -sum(e dy/dp)`, and dy/dp needs the sensitivity of the
arm to the torque, which the controller does not know. I use the usual
gradient approximation (MIT rule) with a positive plant sensitivity, which
gives `dV/dKp = -e e`, `dV/dKi = -e int(e)` and `dV/dKd = -e de/dt`. With
this form Kp can only grow, because `-eta (-e^2)` is never negative. The
rule therefore needs a small learning rate eta (written on the lecture
slide, missing in the handout), upper bounds on the gains and a stop rule.
The values will be documented with the results.

### ISS-067 - Senior Final Project programs, further points

All four senior shoulder programs use the same target `30 cos(2 pi 0.1 t)`
(15 deg for the combined movement), which suggests one shared template. One
revised program replaces the joint angle by the PID output
(`rotangle := pidteta`), the same kinematic shortcut as ISS-063. Another
program has the correct structure (passive torque with its physical sign,
gravity divided by the inertia), but C = 3 and k = 1 were chosen by trial
and its report gives an RMSE of about 2 deg (sagittal) and 3 deg (frontal),
which misses the criterion. In the adaptation of the programs that adapt,
`dV/dKd` uses the joint velocity instead of the error derivative. These
programs remain a reference only and are not redistributed.

### ISS-068 - Literature targets for the passive identification

The passive test releases the arm from 30 deg without active torque. The
iteration changes C and k until the natural frequency and the damping ratio
of the simulated response match target values. I did not find a study that
reports relaxed shoulder stiffness and damping with the arm hanging, for
flexion and abduction separately. The closest sources are these.

1. Chang, Hunt, Atkins and Lee (ICRA 2021) report stiffness, damping and
   inertia for four directions (pitch and yaw, both signs) under low
   activation, at about 45 deg abduction with the elbow flexed. Their
   values give damping ratios between about 0.5 and 0.9.
2. Hwang and co-workers report relaxed stiffness in horizontal flexion and
   extension, 17.4 Nm/rad at 45 deg flexion and lower values at higher
   flexion. The venue of this paper is not yet confirmed.
3. Zhang and co-workers (J Orthop Res 2000) found a nearly constant damping
   ratio of the shoulder about the abduction axis over contraction levels.
   The numbers are in the full text, which I have not read yet.

Session 1 prototype targets are k = 17.4 Nm/rad with a damping ratio of
0.69 (sagittal) and k = 22.5 Nm/rad with a damping ratio of 0.70 (frontal).
The iteration reaches them in three steps (C = 5.47 Nms/rad, k = 17.27
Nm/rad sagittal, C = 6.01 Nms/rad, k = 22.37 Nm/rad frontal). The
mapping of pitch and yaw to my two planes, the posture transfer and
whether the measured stiffness already contains gravity are open. C is
larger than the measured damping because my straight arm has about three
times the inertia of the flexed-elbow arm in that study, and the damping
ratio is the matched quantity.

### ISS-069 - Access violation in the Plant Model and RK4 tab

- **Report (first run of UI v2):** pressing Plant 1 or Plant 2 under
  Impulse Response raised "access violation at 0x00cb8d07: read of
  address 0x00000040". Afterwards the chart of the tab reacted only after
  several clicks, could not be zoomed or panned, and its legend check boxes
  did nothing.
- **Analysis:** the tab had one chart for both responses. After every run
  `UpdateLegend` hid the series without points (`ShowInLegend := False`)
  while the legend showed check boxes; the impulse run hid three of the
  five series. The ZN tabs, where every series always receives points so
  the legend never changes, did not fail. The same address and symptoms
  (a nil read at offset 0x40 while painting, a chart that stays broken)
  appeared in Assignment 1 when series behind a check-box legend changed
  (ISS-020). The cause is therefore the legend keeping items of series it
  no longer shows _(inference: no call stack was captured; the TeeChart
  source is not available)_. Every further paint raised the error again,
  and every error opened a dialog, which explains the unresponsive chart.
- **Fix (UI v3):** the tab has two charts, Runge Kutta Output (impulse
  response and its peak) above and the step response with the tangent
  below, so each chart only holds series it always shows. The legends are
  fixed in the form and never changed at run time (`UpdateLegend`
  removed in every tab). `Application.OnException` appends each unexpected
  error to `ZNTuning_error.log` next to the exe and shows the same error at
  most once every 2 s.
- **If it recurs:** press _Break_ in the debugger notification, copy the
  Call Stack window, and send it with `ZNTuning_error.log`.
- **Retest (2026-11-16):** Impulse Response and Step Response for both
  plants, legend check boxes and zoom work without an error.

### ISS-070 - Chart navigation

- **Report:** the charts could not be zoomed with the mouse wheel.
- **Analysis:** UI v2 swallowed the wheel over a chart to avoid the
  EInvalidCast of TeeChart's wheel scrolling (ISS-019) but did not zoom.
  The drag zoom of TeeChart was available, but nothing in the window said
  so, and a new run kept the old zoom.
- **Fix (UI v3):** the wheel zooms at the cursor (Shift + wheel: time axis
  only), a drag to the lower right zooms into a box, a right drag pans and
  a double click restores the full view. Every new run starts with the full
  view. The help card of tab 1 and the first log lines explain the mouse
  actions.

### ISS-071 - Equation window could not be scrolled

- **Report:** the equation window opened, but the sheet could not be moved
  with the mouse or the touchpad.
- **Analysis:** a `TScrollBox` does not scroll with the wheel by itself,
  and the image had no drag handling, so only the scroll bars worked.
- **Fix (UI v3):** `TFormEquations.MouseWheelHandler` scrolls with the
  wheel or a two-finger swipe (Shift: sideways), a left drag moves the
  sheet, Ctrl + wheel or a pinch zooms between 50 % and 250 %, and a double
  click returns to 100 %. A line at the bottom of the window lists these
  actions and shows the zoom.

### ISS-072 - Delphi hints after the UI v2 build

- **H2077** `ZNModel.pas`: the start value of `LY` in `SimulatePLoop`, added
  for ISS-058, is overwritten in the first pass of the loop and never read
  after it. Removed; the other two start values are still needed.
- **H2443** `Unit1.pas`: the inline function `Point` lives in
  `System.Types`, which was not in the uses list. Added to `Unit1.pas` and
  `Unit2.pas`. Results of `TestZN` are unchanged (0 failures, identical
  output).

### ISS-068 (update, session 2) - Literature targets after reading the sources

I read the open full text of Chang and co-workers (ICRA 2021,
doi 10.1109/ICRA48506.2021.9561776) and of Hwang and co-workers (IEEE Trans.
Biomed. Eng. 71(10), 2833 to 2841, 2024), and the parts of Zhang and
co-workers (J Orthop Res 18(1), 94 to 100, 2000) that are quoted openly.

1. Zhang and co-workers measured about the glenohumeral abduction axis in
   the scapular plane, starting at 45 deg abduction, and give a relaxed
   stiffness of about 30 Nm/rad that rises to about 180 Nm/rad with
   contraction, while the damping ratio stays almost constant. This is the
   frontal target (k_lit = 30 Nm/rad).
2. Hwang and co-workers report relaxed stiffness in the horizontal
   flexion-extension direction for 15 postures at 45, 67.5 and 90 deg
   flexion. The mean of the 45 deg level, 17.4 Nm/rad, is the closest value
   to a hanging arm and is my sagittal target. The direction is not the
   sagittal axis of my model, so this value is a proxy.
3. Chang and co-workers do not map pitch and yaw to anatomical axes. Their
   arm was not supported against gravity (about 45 deg abduction, elbow at
   90 deg, EMG below 5 % MVC). From their stiffness, damping and inertia the
   damping ratio of the four directions is 0.70, 0.97, 0.86 and 0.52, mean
   0.76. I use 0.76 in both planes.

No source measured a relaxed hanging arm, and none states whether the
gravity stiffness is inside the reported value. The report states that these
studies support the order of magnitude of C and k only and do not validate
the numbers of my model. With the targets above the iteration gives
C = 6.0487 Nms/rad and k = 17.4001 Nm/rad (sagittal) and C = 7.2298 Nms/rad
and k = 30.0001 Nm/rad (frontal) in three runs each. C is larger than the
measured damping because my straight arm has three to five times the inertia
of the flexed-elbow arms of those studies, and the damping ratio is the
matched quantity.

### ISS-073 - Damping ratio from the release amplitude

The first version of `MeasureFreeResponse` used the release amplitude x0
(30 deg) and the first excursion x1 for the logarithmic decrement. The first
swing from 30 deg is not yet in the linear range of sin(theta), so the
measured damping ratio was about 0.2 % too high and the identified C and k
missed the linear targets by up to 0.3 %. The Python cross-check found it,
because it computes wn and zeta of the identified C and k with the linear
formulas. The measurement now uses the two extrema after the release, x1
and x2, and the period between the first and the third crossing of the rest
angle. After the change the iteration returns k = k_lit within 1e-5 and
zeta within 1e-6. Test case C4 checks the measurement on an exact damped
oscillation.

### ISS-074 - Gain choice of Problem 3 and the settling time

Higher gains always lower the RMSE, so "low RMSE" alone does not pick a gain
set. The grid search (Kp 2 to 40, Ki 0 to 40, Kd 0.1 to 1, 140 sets per
plane) keeps the sets with RMSE below 0.75 deg whose error settles inside the
0.75 deg band, and chooses the one with the smallest peak torque. Result
(Dempster arm, 0.25 Hz, 8 s) Kp = 10, Ki = 40, Kd = 0.1 (sagittal, RMSE 0.40
deg, ts 0.089 s) and Kp = 10, Ki = 20, Kd = 0.25 (frontal, RMSE 0.70 deg, ts
0.148 s). The frontal peak of 100.2 N m at t = 0 is Kp times the initial
error of 10 deg (cosine reference), the transient that the settling time
measures. For a sine reference the settling time is the last time |e| leaves
the band. With the same gains the sagittal error at 0.5 Hz and 1 Hz never
stays inside the band (no settling time, RMSE 0.72 and 1.32 deg), which is
the case for the adaptation of Problem 4. The report explains both points.

### ISS-075 - Parallel sessions on ISSUES.md and CHANGELOG.md

The Final Project and Assignment 3 were worked on in two sessions at the same
time. ISS-069 to ISS-072 (A3) were written after ISS-062 to ISS-068 (FP), and
my first FP code referred to an FP issue as ISS-069. I changed that reference
to ISS-073. Rule from now on: every session reads the newest ISSUES.md and
CHANGELOG.md right before it adds an entry, takes the next free number at that
moment, and never rewrites entries of the other session.

### ISS-076 - References chapter not filled

- **Found by:** my own review of the report (session 5): the chapter
  REFERENCES contained only the word REFS, although the text cites [1] to
  [8].
- **Cause:** `build_report.py` replaces the placeholder `@@REFS@@`, but
  `report_part3.md` contained `REFS` without the markers, so nothing was
  replaced and no error was raised. The reports of sessions 1 to 4 had the
  same gap.
- **Fix:** the report I had edited in Word was completed by `fix_report.py`,
  which inserts the eight IEEE entries in the order of first citation
  (checked against the numbers in the text) and changes nothing else. The
  source now uses `@@REFS@@`, and `build_report.py` stops with an error
  when the placeholder is missing.

### ISS-077 - First Delphi 13 build of the FP program

- **Found in:** the first build of `Final Project/Program`. Message
  `Unit1.pas(1598): E2018 Record, object or class type required`, then
  `F2063 Could not compile used unit 'Unit1.pas'`.
- **Cause:** `edtFreqList.Text.Split(...)` in `btnSweepClick`. `TEdit.Text`
  is a `TCaption`, which is declared as a distinct string type, and the
  string helper with `Split` is attached to `string` only. The Free Pascal
  test never compiles `Unit1.pas`, so CI could not see this.
- **Fix:** the text is copied to a local `string` first, then split.
- **Second finding in the same screenshot:** the settings key
  "Torque limit (N m, 0 = off)" contains "=", which `TValueListEditor` uses
  between key and value, so the designer showed the row cut in two. The key
  is now "Torque limit (N m, 0 is off)" in the form and in the code.
- **Lesson:** a form unit that only Delphi compiles needs a build in the IDE
  before it is handed over. I now search the UI units for string helper
  calls on `Text` and `Caption` before every delivery.

### ISS-078 - UI v2 of the FP program

- **Request:** livelier design (hover and press effects, varied gradients,
  own colours for groups of buttons, EXIT red, CLEAR green), working chart
  interaction, and error handling for inputs and accidental clicks.
- **Changes:** every card has a title strip that is a real panel of the
  form (visible in the Form Designer with its colour), painted at run time
  as a horizontal gradient with a light top line and a dark base line. The
  page header has a three-stop gradient and an amber base line. Buttons use
  nine colour groups, fade towards white within about 0.1 s while the mouse
  is over them, look raised (light upper edge, shadow below) and pressed
  (darker inverted gradient, inner shadow, caption moved by one pixel),
  and turn grey while disabled. The tabs highlight on hover. The table
  choice and the adaptation mode are radio groups, so their items and the
  default are visible in the designer.
- **Charts:** a `TChart` interposer marks the point of the visible series
  nearest to the cursor. A dotted cross-hair and a value box with the
  series name and both axis values are drawn in `ChartAfterDraw`. Left drag
  zooms, right drag pans, the wheel zooms at the cursor, a double click
  shows the full view, and the legend check boxes hide or show a line. The
  legends themselves are never changed at run time (A3 ISS-069).
- **Busy guard:** every computation runs between `BeginWork` and `EndWork`.
  All action buttons except EXIT and CLEAR are disabled meanwhile, and the
  clicks made during the work are delivered while they are still disabled,
  so they are dropped instead of starting a second run.
- **New input checks:** fewer than 50 steps per reference cycle (refused),
  a run shorter than one cycle, a settling band not smaller than the
  amplitude, a torque limit below the static torque needed for the largest
  target angle, C and k identified for another arm mass (warning once per
  plane), a non-integer iteration count, release angles above 90 deg, a
  target damping ratio close to 1, all learning rates 0, and grids of more
  than 100000 steps per run. Editing any input after a run marks the shown
  results as out of date.
- **Status:** written without a Delphi build in my environment; to be
  retested in the IDE.

### ISS-079 - Bd of the lecture bilinear formula

- **Found in:** problem sheet of Assignment 4 and the MPC slides (p. 11):
  Bd = (I - T/2 A)^-1 B T/(1 - T/2), Cd = C, Dd = D.
- **Check:** this formula reproduces every printed entry of Ad and Bd on
  the sheet (relative difference 2e-15). The standard bilinear form
  Bd = (I - T/2 A)^-1 B T misses the sheet by exactly T/2 = 5e-4.
- **Origin:** in the slide derivation the input term (z + 1)(T/2) B U is
  replaced by T/(1 - T/2) B U. That is (z + 1)/2 with z = (1 + T/2)/(1 - T/2),
  the image of s = 1 rad/s. The factor adds a time (T in s) to a pure number,
  so it is not dimensionally consistent, and it scales the input gain by
  1/(1 - T/2): 1.0005 at T = 1 ms, 1.0526 at T = 0.1 s.
- **Decision:** the program uses the lecture formula by default (the sheet
  asks for it) and offers the standard form and the exact zero-order hold
  for comparison. The report explains the difference. Problem 2 data made
  with the lecture formula reach a steady value of 1.0526 instead of 1.

### ISS-080 - Lecturer program MPC.exe is empty

- **Found in:** `Materials/MPC Simulator`: `MPC.exe` has 0 bytes, and
  `MPC.zip` holds the same 0-byte file. The download from MyITS Classroom
  is also 0 bytes. The lecturer said in class that a working copy will be
  sent.
- **Mitigation:** section 2.3 compares my program with the output files of
  the lecturer (`svdku1.dat`, `svdku123456.dat`) instead. To be repeated
  when the working program arrives.
- **Update (2026-11-28):** a working `MPC.exe` (794,624 bytes, MD5
  603f37e44d18a168d8142876f5b72ad7) and new output files (`state space
  model.dat`, `MPC Design.dat`, `MPC observer Design.dat`) are in the
  folder. Section 2.3.4 and Table 2.4 of the report now compare with the
  program itself (ISS-091). Resolved.

### ISS-081 - SVD of the lecture material

- **Found in:** `Singular Value Decomposition.txt` (the `svdcmp` routine of
  Numerical Recipes, Pascal version by J-P Moreau). The singular values come
  out unsorted (`svdku1.dat`: 0.71, 7.89, 6.57), so the order of a
  realisation cannot be read from the first entries.
- **Decision:** I wrote my own one-sided Jacobi SVD in `MPCModel.pas`
  (sorted, descending, first entry of each column of U negative or zero as
  in the lecturer's output). The Numerical Recipes code is not copied, as
  its licence does not allow publishing it in this repository.
- **Check:** `TestMPC` case C5 reproduces `svdku1.dat` to 6 decimals (up to
  the sign of a column) with |U S V^T - A| = 3e-15.

### ISS-082 - Typing errors on the problem sheet of Assignment 4

- `Det(lambda I - Am - Kob Cm)` needs brackets: the matrix of the error
  system is A - Kob C, so the polynomial is det(lambda I - (A - Kob C)).
- The open-loop error equation is printed as
  `x~(k+1) = Am (xm(k) - x^m(k)) - Am x~m(k)`; it should read
  `x~(k+1) = Am (xm(k) - x^m(k)) = Am x~m(k)`.
- I use the corrected forms in the program and the report and mention the
  correction once.

### ISS-083 - Plant of Problem 3 and the lecturer's Hankel data

- **Finding:** with step data of Problem 2 made by the lecture bilinear
  formula (T = 0.1 s), a 4 x 4 Hankel matrix of Markov parameters and the
  balanced split of the SVD, the Ho-Kalman model is
  A = [1.2009 -0.2486; 0.2486 0.7407], B = [-0.1152; 0.0903],
  C = [-0.1152 -0.0903], which is the plant of Problem 3 to three decimals.
  Zero-order-hold data give B1 = -0.1125 and do not match.
- `svdku123456.dat` is the SVD of this 4 x 4 Hankel matrix (printed with two
  decimals). Its U agrees with mine to 1.8e-4 only; RK4, Euler and rounded
  data did not close the gap, so the lecturer's data generator is not known.
- **Update (2026-11-28):** the working `MPC.exe` shows the generator. It
  integrates the plant with the Runge-Kutta-Nystrom method at 0.1 s for 150
  samples, and it passes the stage time to the argument that the right-hand
  side uses as the input, so the four stages see u = 1, 1.05, 1.05 and 1.1
  and the data settle at 1.05. Replaying this integrator reproduces
  `state space model.dat` within 4.9e-8, and the U of the 4 x 4 Hankel
  matrix of these data matches `svdku123456.dat` to 1.9e-6. The Ho-Kalman
  model of these data rounds to the same plant of Problem 3. Resolved.
- **Use:** Problem 3 is checked against Problem 2 in `TestMPC` (C6), and the
  report presents the three problems as one chain.

### ISS-084 - Close eigenvalues from the characteristic polynomial

- **Found by:** `TestMPC` case C3. The eigenvalues of Ad of system 1 are
  1.002002, 1 and 0.998002. Roots of the characteristic polynomial came out
  as 1.00000000011, an error of 1e-10, because roots 0.002 apart are badly
  conditioned in the coefficients.
- **Fix:** for n > 2, `Eigenvalues` shifts by the mean diagonal entry and
  scales by the norm, (A - cI)/s, so the roots are of order one and well
  apart. The error is now 1e-16. The 2 x 2 case uses the closed form.

### ISS-085 - Invalid property value when Delphi 13 opened the A4 form

- **Found in:** the first opening of `Project1` in Delphi 13. Message
  `Error reading serP2Sigma.XValues.Order: Invalid property value`.
- **Cause:** I write `Unit1.dfm` with a small generator script. Its helper for
  line series took the marker size as the eighth argument, after the list
  order, and five calls passed the size as the seventh. The form therefore
  held `XValues.Order = 5` (serP2Sigma) and `XValues.Order = 3` (serP3ErrObs,
  serP3ErrOpen, serP3Xo1, serP3Xo2), while the property only accepts
  `loNone`, `loAscending` or `loDescending`. My earlier check compared object
  names and event handlers only, not property values.
- **Fix:** the list order is now a keyword-only argument of the helper, and
  the form was written again. New check before every delivery: every
  property of the generated form is compared with the properties that
  Delphi itself wrote into the forms of Assignments 1 to 3 and the Final
  Project, by class, name and kind of value (number, identifier, string,
  set). The A4 form now has no mismatch.
- **Also changed:** the singular value chart plots log10 sigma on a linear
  axis instead of a logarithmic TeeChart axis, which has no valid range while
  its series are empty (after CLEAR). `MatExp` uses `IntPower` instead of
  `Power` (no overload choice between integer and real exponent), and
  `LMinv` in `Discretise` is initialised before the `try` block (Delphi hint
  W1036 as in ISS-058).
- **Status:** to be retested in the IDE. Ignoring the message must be
  avoided, because Delphi would then drop the series from the form.
- **Retest (2026-11-23):** the form opened without the message, all three
  tabs ran, and Delphi saved the form again in its own property order
  (`Explicit*` sizes, default values dropped). Resolved.

### ISS-086 - Integer overflow in the chart hover of the A4 program

- **Found in:** Problem 1, system 1, after Discretise. Moving the mouse over
  the charts raised `EIntOverflow` (Integer overflow). The program went on
  after the message, so the error was not fatal.
- **Cause:** the hover helper of the `TChart` interposer searches the point
  nearest to the mouse and computed `Sqr(ASer.CalcXPos(AIdx) - X)`. Both
  operands are `Integer`, so `Sqr` returned an `Integer`. A series point far
  outside the visible axis range (for example a point of the unit circle
  while the pole chart is scaled or zoomed close to the poles of system 1)
  lies tens of thousands of pixels away. A distance above 46341 pixels gives
  a square above 2^31 - 1, and overflow checking (on in the Debug build)
  raised the exception.
- **Fix:** the pixel offsets are now computed as `Double` (`1.0 *
  CalcXPos - X`), points more than 40 pixels away in x or y are skipped
  before the square, and the initial best distance is `Sqr(1.0 *
  CMaxDist)`. The cross-hair routine needed no change, because it only
  draws a point that the hover search accepted.
- **Status:** retested on 2026-11-25, no overflow with hover and wheel zoom.
  Resolved.

### ISS-087 - Reset button of Problem 1 cut off on the laptop screen

- **Found in:** Problem 1 at 125 % display scaling. The button below
  Discretise and Step and impulse was only partly visible.
- **Cause:** the side panel holds four cards aligned to the top. Their
  heights (172, 196, 150, 108 pixels plus margins) needed 650 pixels, while
  the laptop leaves about 620 logical pixels for the panel when the window
  is maximised with the taskbar shown. The third button sat in a second row.
- **Fix:** the three buttons share one row (Discretise, Step and impulse,
  Reset model) and the cards were tightened (162, 190, 164, 76 pixels), so
  the panel needs 616 pixels. The change was made on top of the form that
  Delphi saved, so the IDE edits (subtitle caption, property order) are
  kept. The caption "Reset model" is shorter; its hint still says that it
  loads the selected system.
- **Status:** retested on 2026-11-25, all three buttons fully visible.
  Resolved.

### ISS-088 - Invisible eigenvalue markers on the pole chart of Problem 1

- **Found in:** the chart export `mpc_tsp1.png` that I saved during the
  retest of ISS-085 (system 2). The pole chart showed only the unit circle,
  and the legend entry Eigenvalues of Ad had no symbol. The axis labels read
  0.999, 0.999, 1, 1.001, 1.001.
- **Cause:** the eigenvalue series used the marker style `psDiagCross` with
  `Pointer.Pen.Visible = False`. A cross has no filled area and is drawn
  with the pen only, so nothing was drawn, in the chart and in the legend.
  The axis is only about 0.005 wide around z = 1 and the default label
  format keeps three decimals.
- **Fix:** filled circles (`psCircle`, size 4) in the series colour, and
  `AxisValuesFormat = '0.0000'` for both axes of the pole chart, set in
  `PlotPoles` after the axis range.
- **Consequence for the report:** the screenshots of Figures 2.1 and 2.2 were
  taken before the fix and show the pole chart without markers. They have to
  be taken again.
- **Status:** retested on 2026-11-25, dots and four-decimal labels shown,
  screenshots retaken. Resolved.

### ISS-089 - Pole chart of Problem 1: straight unit circle and lost view

- **Found in:** my retest on 2026-11-25. After Discretise the unit circle of
  the pole chart is drawn as an almost vertical line. After clicking the
  legend check box of the unit circle twice, the chart showed the whole
  circle, and the poles of both systems sat in one dot at z = 1.
- **Cause:** the vertical line is intended. `PlotPoles` sets the axes to the
  poles, which lie within 0.003 of z = 1 at T = 0.001 s, so the axes are
  only about 0.005 wide and the circle near z = 1 is a nearly straight
  line. The jump to the whole circle was not intended. Two quick clicks on
  a legend check box arrive at the chart as a double click, and the double
  click handler reset both axes to automatic. At that scale all poles are
  less than one pixel apart, so they merge into one dot at (1, 0). The
  values were correct in both views.
- **Fix:** `ChartDblClick` ignores double clicks on the legend
  (`Legend.Clicked`). On the pole chart a double click now switches between
  the whole unit circle and the view around the poles, which `PlotPoles`
  stores in `FPoleView`. CLEAR forgets that view. `PlotPoles` writes a log
  line that explains the scaled view. The charts of Problems 2 and 3 use
  automatic axes and had only the legend double click, which now changes
  nothing.
- **Status:** to be retested in the IDE (Problem 1, both systems, legend
  boxes, double click twice, CLEAR).

### ISS-090 - Pulse convention of the impulse response of Problem 1

- **Found in:** comparison with an earlier student program, whose impulse
  response of system 2 has an amplitude of about 0.001 against 1 in mine.
- **Cause:** two conventions, both valid. The lecture defines the unit pulse
  as u(0) = 1, whose response is the sequence of Markov parameters g(k),
  the same quantity that Problem 2 identifies. The continuous impulse
  response g(t) = C exp(At) B belongs to a Dirac impulse of area 1, whose
  one-sample counterpart has the height 1/T. Both responses come from the
  same linear simulation and differ by the factor T only.
- **Decision:** the program keeps both. The check box "Impulse as a pulse of
  area 1: u(0) = 1/T" is ticked by default, because the sheet asks for an
  impulse response and only this scale can be compared with cos 2t.
  Unticked, the program gives the Markov parameters of the lecture
  convention (chart title "unit pulse u(0) = 1 (Markov parameters)").
  With the lecture output equation (Cd = C, Dd = 0) both start with y(0) = 0,
  one sample later than g(0) = CB = 1. The report explains both in Sections
  2.2.1 and 2.3.1.
- **Status:** documented.

### ISS-091 - Working lecturer program compared with mine

- **Found in:** `Materials/MPC Simulator/MPC.exe`, the working version
  released after the first submission. It is a Delphi 7 program without
  source, so I read its forms from the executable resources, its strings and
  the machine code of the button handlers, and I replayed the numerical parts
  in Python. The analysis notes stay outside the repository.
- **Same as mine:** the lecture formula Ad = (I - T/2 A)^-1 (I + T/2 A),
  Bd = (I - T/2 A)^-1 B T / (1 - T/2), Cd = C (Ad and Bd of system 1 equal the
  sheet), a 4 x 4 Hankel matrix of Markov parameters with the balanced SVD
  split, and the observer error matrix A - Kob C. For its default poles 0.851
  and 0.872 it prints Kob = [-1.094; -1.025], and my closed form gives
  -1.093695 and -1.024723.
- **Choices that differ:** system 2 is discretised with T = 0.1 s (mine 0.001
  s, editable), 150 samples per run, the impulse is the unit pulse u(0) = 1
  (ISS-090), the Problem 2 data come from the integrator of ISS-083, and the
  observer runs inside the predictive controller (nc = 4, np = 20).
- **Defects in the reference:** (1) the simulation loops of the
  Discretization button reset only the first two states, so for the
  third-order system 1 the third state of the step run carries into the
  impulse run and the impulse curve rises to 0.0728 at 0.15 s instead of
  0.00196 (my replay of that loop gives 0.07275, as in its chart); a repeated
  click also starts the step run from the old state. (2) The stage time of
  the Runge-Kutta-Nystrom routine enters as the plant input (ISS-083).
  (3) The output is computed after the state update, so the value at t = kT
  is C x(k+1), one sample early. Misspelled captions ("Fisrt", "Continous",
  "Obserber", "Estimattion") are cosmetic.
- **Consequence:** no change to my program. Section 2.3.4, Table 2.4 and a
  paragraph in Section 2.4 of the report describe the comparison.
- **Status:** documented.
