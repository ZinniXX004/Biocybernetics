# Changelog

All notable changes to the Biocybernetics (EB234701, Class Q) repository are
recorded here. Format: one dated entry per working session, grouped by
assignment. Issue identifiers (`ISS-xxx`) refer to [ISSUES.md](ISSUES.md).

## [Unreleased]

### 2026-11-25 - Assignment 4: MPC experimental steps (session 4, pole chart view, pulse convention)

#### Fixed

- `Unit1.pas`: two quick clicks on a legend check box arrived as a double
  click and reset the pole chart to the whole unit circle, where all poles
  merge into one dot. Double clicks on the legend are now ignored, and on
  the pole chart a double click switches between the whole circle and the
  view around the poles (stored by `PlotPoles`, forgotten by CLEAR). A log
  line explains why the circle looks like a vertical line (ISS-089).

#### Changed

- Report (edited in place, my latest revision kept): new paragraph in
  Section 2.2.1 on the two pulse conventions (u(0) = 1 gives the Markov
  parameters, u(0) = 1/T the impulse response of area 1, factor T between
  them, first sample y(0) = 0 with Cd = C, Dd = 0), new paragraph in Section
  2.3.1 with the unit-pulse numbers and the pole chart view (ISS-089,
  ISS-090), and every code listing taken again from the current code.
  New `Report/source/patch_session4.py` for these edits.
- `ISSUES.md`: ISS-086 to ISS-088 retested and resolved, ISS-089 and ISS-090
  added.
- A4 README: pole chart view, pulse convention finding, issue range.

### 2026-11-23 - Assignment 4: MPC experimental steps (session 3, retest fixes, report format, README)

#### Fixed

- `Unit1.pas`: chart hover squared `Integer` pixel offsets, which raised
  `EIntOverflow` on Problem 1, system 1. Offsets are now `Double` and points
  more than 40 pixels away are skipped before the square (ISS-086).
- `Unit1.dfm`: the Reset model button of Problem 1 was cut off at 125 %
  display scaling. Its three buttons share one row and the side cards are
  smaller (616 instead of 650 pixels). Applied to the form that Delphi saved,
  so the IDE changes (subtitle caption, property order) are kept (ISS-087).
- `Unit1.dfm` and `Unit1.pas`: eigenvalue markers of the pole chart were
  invisible (cross marker with the pen switched off). Filled circles now,
  and four decimals on both axes of the pole chart (ISS-088).

#### Changed

- Report (edited in place, my screenshots and the extra System 2 figure
  kept): paragraph spacing 0 pt before and after with blank lines as
  spacing, line spacing 1.15, no dot after the figure and table numbers,
  blue table headers, caption Figure 2.2 for the System 2 screenshot with the
  later figures renumbered, all code listings taken again from the current
  code, and a new paragraph with the listing of `TChart.MouseMove` (ISS-086).
  Code boxes keep single line spacing. The previous file is in
  `Report/drafts/A4_report_before_session3_format.docx`.
- `Report/source/report_part2.md`: the hover paragraph and listing.
  New `Report/source/format_in_place.py` with the in-place edits.
- `ISSUES.md`: ISS-085 retested and resolved, ISS-086 to ISS-088 added.
- A4 README: section with the equations, log10 singular values, export and
  `Data/` described, issue range updated.
- Root README: Assignment 4 marked done, A4 regression badge, Featured block,
  layout and CI tables.

#### Moved

- My chart exports `mpc_tsp1.csv/.png`, `mpc_tsp2.csv/.png`,
  `mpc_tsp3.csv/.png` and `hokalman_process_data.dat` from `Program/` to the
  new `Data/` folder. `mpc_tsp1.png` was saved before ISS-088 and shows the
  pole chart without markers.

### 2026-11-23 - Assignment 4: MPC experimental steps (session 2, form load fix)

#### Fixed

- `Unit1.dfm`: invalid `XValues.Order` values of five line series written
  by the form generator, reported by Delphi 13 when it opened the form
  (ISS-085).

#### Changed

- Singular value chart of Problem 2: log10 sigma on a linear axis instead of
  a logarithmic axis (ISS-085).
- `MPCModel.pas`: `IntPower` in `MatExp`, `LMinv` initialised in
  `Discretise`. The golden output of `TestMPC` is unchanged.

### 2026-11-23 - Assignment 4: MPC experimental steps (session 1, program, CI, report draft)

#### Added

- `Program/MPCModel.pas`: numerical unit without UI. Matrix helpers
  (Gauss-Jordan inverse, determinant, matrix exponential), bilinear
  discretisation with the lecture formula, the standard form and the
  zero-order hold, discrete step and pulse responses, exact sampled
  continuous responses, eigenvalues (closed form for n = 2, shifted and
  scaled characteristic polynomial for n > 2), Markov parameters, Hankel
  matrices, my own one-sided Jacobi SVD, the Ho-Kalman realisation with
  its .dat text, the closed-form observer gain of a 2 x 2 plant and the
  observer simulation.
- `Program/Unit1.pas` and `Unit1.dfm`: main form with one tab per problem.
  Every chart, series, legend with check boxes, axis title, table with keys
  and defaults, radio group and button is designed in the form. Gradient
  buttons by group (EXIT red, CLEAR green), card title strips by role,
  nearest-point value box on the charts, wheel zoom, CSV, PNG and .dat
  export, input checks and an error log.
- `Program/Unit2.pas` and `Unit2.dfm`: equation window with the LaTeX sheet
  `Resources/tex/sheet_equations.tex` (used equations in yellow).
- `Program/Verification/TestMPC.dpr` and the golden file
  `TestMPC_output.txt` (42 checks, 0 failures with FPC 3.2.2), and the
  workflow `a4-model-regression.yml` (path filter on the A4 files only).
- `Report/source`: Markdown chapters, `figs.py` and the build scripts
  adapted from Assignment 3. The cover and Section 2.1 of my report are
  copied unchanged.
- `README.md` of the assignment and `docs/img/mpc-overview-*.png`.
- ISS-079 to ISS-084.

#### Changed

- `Program/Project1.dpr` and `Project1.dproj`: `MPCModel.pas` and `Unit2.pas`
  added, application title set.
- `Program/Unit1.pas` and `Unit1.dfm` of the empty template were replaced.
- The report Word file was rebuilt from the sources. My version before the
  rebuild is kept in `Report/drafts/Template_original_before_A4_report.docx`.

### 2026-11-17 - Final Project: shoulder joint model (session 3, build fix and UI v2)

#### Fixed

- Delphi 13 build error E2018 in `btnSweepClick` (string helper on a
  `TCaption`) and the settings key with "=" (ISS-077).

#### Changed

- `Unit1.pas` / `Unit1.dfm` UI v2 (ISS-078): card title strips designed in
  the form, colour groups for the buttons (EXIT red, CLEAR green), fade on
  hover and pressed state, three-stop header gradient, hot-tracked tabs,
  radio groups for the table and the adaptation mode.
- Charts: nearest-point cross-hair with a value box, in addition to zoom,
  pan, wheel zoom, double-click reset and legend check boxes.
- Error handling: busy guard for every computation, checks of input
  combinations, warning for C and k of another arm, out-of-date marker after
  an input change.

### 2026-11-16 - Assignment 3: Ziegler-Nichols PID (session 5, report final, release)

#### Added

- `Report/source/docx_fix.py` and `fix_report.py`: changes to a report that
  was already edited in Word, without touching the rest of the document.
  `build_report.py` uses the same code-frame function.

#### Changed

- Report (my version with the screenshots and my own edits, 33 pages):
  every code listing from Section 2.2 on sits in a table of one column and
  one row; the main-program lines of Section 2.1 quote `Unit1.pas` with
  their line numbers (the earlier lines used shortened names).
- `build_report.py`: the line numbers quoted in Section 2.1 are taken from
  `Unit1.pas`, and the build stops when a quote is not found.
- ISS-069 to ISS-071 confirmed by my retest of UI v3.

#### Fixed

- References chapter filled with the eight IEEE entries (ISS-076).

#### Overwritten or kept

- Overwritten: the A3 report, `build_report.py`, `report_part3.md`. My
  Word version before this change is kept outside the repository. My
  edits of the report text and the screenshots are unchanged.

### 2026-11-16 - Assignment 3: Ziegler-Nichols PID (session 4, report for UI v3)

#### Changed

- Report rebuilt from the sources for UI v3 (30 pages). Section 2.2.5: a
  paragraph on the robustness of the form (separate impulse and step
  charts with fixed legends, error log, chart navigation, panel colours)
  and the listing of `TForm1.AppException`; every Unit1 listing carries
  the line numbers of the current file.
- Section 2.3.1 and the screenshot placeholders: Figure 2.2 and Figure 2.3
  now show both charts of the first tab for plant 1 and plant 2 (before:
  step response and impulse response of plant 1 only); Figures 2.4, 2.8
  and 2.9 describe the UI v3 window.
- Figures 2.10 to 2.13 and Tables 2.1 to 2.5 are unchanged: they come from
  `ZNModel.pas`, whose results did not change (`TestZN` output identical).

#### Overwritten or kept

- Overwritten: the A3 report, `report_part2.md`, `report_part3.md`. The
  previous versions are kept outside the repository.

### 2026-11-16 - Final Project: shoulder joint model (session 2, core, tests, form)

#### Added

- `Final Project/Program/ShoulderModel.pas`: numerical core without user
  interface. Arm from BW, BH and five segment tables (Equations 1.1 to 1.4),
  motion equation from the Lagrangian (Equation 1.8), RKN step of the lecture
  (Equation 1.12), passive release test with the measurement of wn and zeta
  and the iteration of C and k (Equations 1.9 to 1.11), positional PID of
  the lecture (Equation 1.14), RMSE and settling time (Equation 1.15), grid
  search of the gains, per-cycle and per-sample adaptation (Equations 1.16
  and 1.17), optional torque limit.
- `Final Project/Program/Verification/TestShoulder.dpr` with eleven cases,
  golden output `TestShoulder_output.txt` (0 failures) and `crosscheck.py`,
  an independent Python version with classic RK4 (15 checks pass).
- `.github/workflows/fp-model-regression.yml`: Free Pascal build, golden
  comparison and Python cross-check.
- `Resources/tex/sheet_equations.tex` and the rendered sheet: arm model,
  Lagrangian derivation, passive test, RKN, PID and adaptation, used
  equations in yellow.
- `Unit1.pas` / `Unit1.dfm` (four tabs, every chart, series, legend and
  default value designed in the form), `Unit2.pas` / `Unit2.dfm` (equation
  sheet) and `ArmView.pas` (OpenGL arm). Gradient buttons with hover and
  pressed states, EXIT and CLEAR, input checks, warnings and a global error
  handler. Not yet compiled in Delphi 13.

#### Changed

- Literature targets of the passive test confirmed as far as the open
  sources allow: frontal k 30 Nm/rad, sagittal k 17.4 Nm/rad, damping ratio
  0.76 in both planes (ISS-068).
- Measurement of the damping ratio from the two extrema after the release
  (ISS-073).

### 2026-11-15 - Assignment 3: Ziegler-Nichols PID (session 3, UI v3)

#### Fixed

- Access violation and a frozen chart after the first Impulse Response run
  (ISS-069): tab 1 now has separate impulse and step charts with fixed
  legends; legends are no longer changed at run time in any tab.
- Unexpected errors are written to `ZNTuning_error.log` and the same error
  is shown at most once every 2 s (ISS-069).
- Wheel zoom at the cursor, double click for the full view, full view after
  every run (ISS-070).
- Equation window: wheel and touchpad scrolling, drag, Ctrl + wheel or
  pinch zoom (ISS-071).
- Delphi hints H2077 and H2443 (ISS-072).

#### Changed

- Panel headers coloured by role: blue for actions, green for editable
  inputs, red to orange for messages and warnings, teal for computed
  results, slate for help, indigo for the closed-loop performance.
- Fonts: Segoe UI Semibold for the title, panel headers and the stability
  line, Consolas for every number field and the log.
- The message log is a `TRichEdit`: warnings in bold orange, errors in bold
  red.
- The header subtitle keeps the text I set in the Form Designer (name and
  student number only).

#### Overwritten or kept

- Overwritten: `Unit1.pas`, `Unit1.dfm`, `Unit2.pas`, `Unit2.dfm`,
  `ZNModel.pas`. The copies saved by the IDE before this change are kept
  outside the repository; the empty `lblSubtitleClick` handler that the IDE
  had added was not carried over.

### 2026-11-15 - Final Project: shoulder joint model (session 1, study)

#### Added

- Study of the FP handout, my Biomodelling wrist FP, the senior shoulder
  programs and the lecture material on PID and adaptive PID. Findings are
  logged as ISS-063 to ISS-067.
- Design decisions for the FP. Dempster segment weights as the default
  (other investigators selectable in the program), a sinusoidal reference
  that follows the lecturer screenshot with editable amplitude and
  frequency (0.25 Hz default, 0.1, 0.5 and 1.0 Hz as further speeds),
  passive C and k found by an automatic iteration towards targets taken
  from shoulder impedance studies, and one program with one tab per
  problem.

#### Fixed

- `.github/workflows/a3-model-regression.yml` watched the A2 workflow file
  in its path filter (ISS-062).

### 2026-11-14 - Assignment 3: Ziegler-Nichols PID (session 2, UI v2)

#### Fixed

- `Unit1.dfm` could not be loaded: `ItemIndex` of the two radio groups was
  written before their font (ISS-061); both now use the property order of
  Delphi, and the form generator writes the same order.
- Delphi 13 build warnings W1036 (`LY`, two places) and hint H2269
  (`MouseWheelHandler`) (ISS-058).

#### Changed

- `Unit1.pas` / `Unit1.dfm` rebuilt as UI v2 (ISS-059): header with
  Equations, Export CSV, Export PNG, CLEAR and EXIT; simulation settings and
  a message log on the left; tabs Plant Model and RK4, ZN Method 1, ZN
  Method 2 with Plant 1 / Plant 2 buttons, P / PI / PID radio buttons,
  editable R, L, Ku, Pu, Kp, Ki, Kd, Test Ku, performance fields and three
  separate charts per ZN tab. Gradient buttons with hover and pressed
  states and gradient card headers, painted by a TPanel interposer.
  Input checks, warnings and a global exception handler.
- `ZNModel.pas`: `SimulateImpulse` added, `SimulatePLoop` public, peak
  value MP and Max Value in the results, equation mentions without
  brackets.
- `Program/Verification/TestZN.dpr`: case C9 (impulse response); golden
  output extended (0 failures).
- Report: code in the answer boxes of Section 2.1, equation mentions
  written as "Equation 2.1", Section 2.2.2 with the impulse response,
  Section 2.2.5 with the Unit1 routines of UI v2 (UI lines omitted),
  Section 2.3.1 rewritten for the tabs, nine screenshot placeholders,
  data figures renumbered to Figures 2.10 to 2.13.
- `Assignment 3_Preliminary/README.md`: program section for the tabs.

#### Overwritten or kept

- Overwritten: `Unit1.pas`, `Unit1.dfm`, `ZNModel.pas`, `TestZN.dpr`,
  `TestZN_output.txt`, the A3 report and its sources.
- Moved out of the repository: `Report/source/fig/fig2_8.png` and
  `fig2_9.png` (old numbering) to the ignored `Claude outputs` folder.

### 2026-11-14 - Assignment 3: Ziegler-Nichols PID (session 1)

#### Analysed

- Problem sheet, the ZN slides (Method 1 reaction curve and table, Method 2
  critical gain and table), the controller slides (RK-Nystrom, PID forms,
  program example) and earlier student PID programs (reference only).
- Plant 1 `1/(s^2+0.5s+1)`: tangent at the inflection point gives
  R = 0.7115, L = 0.4559 s, T = 1.4054 s (analytic and RK4).
- Plant 2 `(2s+1)/(s^2+1.5s+1)`: realised as `z'' = -1.5z' - z + x`,
  `y = z + 2z'`; the largest slope is at t = 0, so L = 0 without delay.
- Neither plant has a finite critical gain under P control; the Ku of a
  sampled simulation is 1/dt for both plants (ISS-051).
- ZN PI gains destabilise plant 1 for both methods; P and PID are stable
  (ISS-054).

#### Decided

- Adjustable input dead time theta, default 0.1 s (ISS-051).
- Input held constant over one RK step (ISS-052); tangent from the RK state
  (ISS-053); derivative term without kick at t = 0 (ISS-056).

#### Added

- `Assignment 3_Preliminary/Program/ZNModel.pas`: numerical unit without UI
  (plant functions, RK4-Nystrom step, dead-time buffer, ZN Method 1 with
  the tangent, Method 2 with the analytic phase crossover and a simulated
  bisection, gain tables, closed-loop PID with overshoot, rise and settling
  time, steady-state error, IAE, ISE and a stability test).
- `Unit1.pas` / `Unit1.dfm`: main form (template `Form1` kept): plant and
  method radio groups, parameter table, buttons, gain table, result memo,
  status bar and four charts with all series, titles, axis titles and
  legends designed in the form (Okabe-Ito colours). CSV and PNG export,
  input checks, no crash on unstable loops, chart wheel guard (ISS-019).
- `Unit2.pas` / `Unit2.dfm`: equation window, LaTeX sheet stored in the
  form as `TPngImage`, implemented equations highlighted
  (`Resources/tex/sheet_equations.tex`, `Resources/sheet_equations.png`).
- `Program/Verification/TestZN.dpr` and golden `TestZN_output.txt`
  (cases C1 to C8, 0 failures with FPC 3.2.2).
- `.github/workflows/a3-model-regression.yml` (checkout@v6, actionlint
  clean).
- Report: Chapter I, Sections 2.2 to 2.4, Chapter III and IEEE references
  written into my template (cover and Section 2.1 unchanged); sources and
  build scripts in `Report/source/` (`report_part1-3.md`, `figs.py`,
  `build_report.py`, `schemafix.py`, CSV data from `TestZN --csv`).
- `Assignment 3_Preliminary/README.md` and `docs/img/zn-overview-*.png`.

#### Changed

- `ISSUES.md`: ISS-049 to ISS-057; personal names replaced by anonymous
  labels (ISS-055).
- `README.md` (root): Featured section with one block per finished
  assignment (A2 and A3 added), A1 status "done", A3 row, badge and CI row,
  lecturer row anonymous.
- `Assignment 1_HH Model/README.md`, `Assignment 2_.../README.md`: lecturer
  row and reference [2] anonymous.
- `.gitignore`: the problem sheet of Assignment 3 (`*.pdf`, `*.docx` in the
  assignment folder) is lecturer material and is not versioned.
- `Assignment 3_Preliminary/Program/Project1.dpr` and `Project1.dproj`:
  `ZNModel.pas` and `Unit2.pas` (form `FormEquations`) registered.

#### Overwritten or kept

- Overwritten: template `Unit1.pas`, `Unit1.dfm` and `Project1.dpr` of
  Assignment 3 (empty form), and the A3 report template (Chapter I to the
  references were left over from Assignment 2). A copy of the template is
  kept in `Report/drafts/Template_original_before_A3_report.docx`.
- Kept: `Project1.res`, `Project1.dproj.local`, the problem sheet. Nothing
  deleted.

### 2026-11-09 - Assignment 2: Lagrangian and Hamiltonian Mechanics (sessions 11-13)

#### Added

- `Assignment 2_.../Program/`: my Delphi 13 program (spherical pendulum,
  Lagrange and Hamilton). `PendulumModel.pas` is the numerical unit without
  UI code (Lagrange and Hamilton right-hand sides, RK4, energy, conical rate,
  exact planar period); `Unit1` is the main form with a preset box, the
  parameter table, a result memo and four charts designed in the form
  (position of both methods, velocity, momentum, path seen from above);
  `Unit2` shows the LaTeX-rendered equation sheet (equations used by the
  program highlighted in yellow), opened with the Equations button or F1.
  `Project1.dpr` and `Project1.dproj` list the three units.
- `Program/Verification/TestPendulum.dpr` and `TestPendulum_output.txt`:
  FPC test of `PendulumModel.pas` (planar periods, conical pendulum,
  Lagrange vs Hamilton, conservation of H and p_phi, turning angle, length
  variation); `--csv DIR` writes the presets used for the report figures.
- `.github/workflows/a2-model-regression.yml`: compiles the test with Free
  Pascal 3.2.2, compares it with the golden output and checks the exit code.
- Report (16 pages): Chapter I (Lagrangian, Hamilton's principle,
  Euler-Lagrange, Hamiltonian, coordinates, RK4), Chapter II (proof of
  Problem 1, energies and both equations of motion of Problem 2, from the
  equations of motion to the position, program code, execution analysis,
  discussion), Chapter III, IEEE references. Sources in `Report/source/`.
- `Assignment 2_.../README.md`, `docs/img/` (light and dark images).
- Issue entries ISS-036 to ISS-048.

#### Changed

- Section 2.1 of my report: the dotted theta of Problem 1 had a second dot
  (ISS-039).
- Report conventions as I edited them in Word: "Equation (n)" and combined
  citations "[2][3]".
- Root `README.md`: Assignment 2 row, badge and CI table.
- `.gitignore`: lecturer's assignment sheet in the A2 folder, Python caches
  and report build intermediates.
- All Markdown files now describe my work in the first person.
- Section 2.2 of my report: the derivations are complete again, step by step
  from the known quantities (variation and fundamental lemma in both
  directions, momentum of a distance and of an angle, virtual work, each
  velocity component and square, each partial derivative, the Legendre
  transform, the equivalence of both methods, dH/dt = 0 and the special
  cases), with the corrected concepts of ISS-047 (ISS-048).
- Report prose: first-line paragraph indent as in my Word version (set by
  `build_report.py`), and most colons and semicolons replaced by full
  sentences.

### 2026-11-05 - Assignment 1 (session 10): design-time form, compact report listings, demo handout

#### Changed

- UI v4.3: the whole visual design of the main window moved into
  `Unit1.dfm`, so the lecturer can inspect it in the Form Designer before
  compiling (ISS-035): 14 charts in 2D with titles, axis titles, grid,
  legends with check boxes and 48 design-time series (`TFastLineSeries`,
  `TLineSeries`, `TPointSeries`) in the Okabe-Ito / viridis colours; chart
  events (`OnZoom`, `OnMouseMove`, ...) bound in the form; default rows of
  the five parameter tables; the model summary memo; the rendered
  equations of tab 6 (`imgEquations`, `imgNomenclature`, PNG stored in the
  form). My own layout changes in the form were kept.
- `Unit1.pas`: `SetupChart`, `StyleAxis`, `SetRightAxisColor`, `AddLine`,
  `AddMarkedLine`, `AddPoints`, `InitRefEditor`, `InitISIEditor` and
  `LoadEquationImages` removed; `RegisterChart` only joins a chart to the
  zoom/export logic; plotting fills the design-time series, `ClearChart`
  clears points instead of freeing series (no series is created or freed
  at run time any more, see ISS-020). Numerical results are unchanged
  (`HHModel.pas` untouched, CI golden output unchanged).
- `Equations.rc`: `EQUATIONS_PNG` and `NOMENCLATURE_PNG` removed (now in
  the form).
- Report: every code line carries its line number in the source file;
  code at 8 pt (token styles were 10.5 pt); routines of the form shortened
  with `{ lines a-b omitted: ... }` comments, numerical routines complete;
  Section 2.2.1 describes the design-time form with a `Unit1.dfm` excerpt
  (`Report/source/revisions/session10/`). 65 to 51 pages in LibreOffice.
- READMEs: live CI badge of `ZinniXX004/Biocybernetics`, UI v4.3.

#### Added

- Demo handout (Claude Docs, bilingual) and the Final Project prompt
  template (claude.ai project docs, not versioned here).

### 2026-11-02 - Assignment 1 (session 9): memo table fix, CI cross-check, README redesign

#### Fixed

- Tab 5 result memo: on the 6-node lecturer grid the peak table repeated
  nodes (x = 0.00 twice, 0.80 three times) because 11 evenly spaced rows
  were rounded onto 6 nodes. `ReportCable` now skips a node already listed;
  `PlotCable` limits the recording sites to the number of nodes (ISS-032).
- Report: listings of `TForm1.PlotCable` and `TForm1.ReportCable` refreshed
  (`Report/source/revisions/session9/build9.py`, all other paragraphs
  unchanged).

#### Added

- `Verification/crosscheck.py`: compares the FPC harness output with the
  independent Python references (spike counts, ISI, peaks, staircase spike
  times, squid velocity, lecturer passive cable for FTCS and Crank-Nicolson)
  within stated tolerances; exit code = number of failures (ISS-033).
- README redesign: root and Assignment 1 READMEs with light/dark header
  images, navigation bar, badges, screenshot gallery, GitHub-rendered
  equations, Mermaid diagrams (architecture, CI, working method) and
  collapsible result tables. Images in `docs/assets/` and
  `Assignment 1_HH Model/docs/img/`, rebuilt by `docs/make_readme_assets.py`
  from the program's CSV exports and the report screenshots.

#### Changed

- CI `a1-model-regression.yml`: `actions/checkout@v6` and
  `actions/setup-python@v6` (Node 20 was removed from GitHub-hosted runners
  in September 2026, ISS-034); cross-check step replaces the print-only
  Python runs; job summary; concurrency group; 15 min timeout; the
  workflow file itself now also triggers pull-request runs.
- `hh_reference_apg.py`, `hh_reference_app.py`: script part moved under a
  `__main__` guard so that `crosscheck.py` can import them; the misleading
  paired-pulse "peaks" column and the non-propagating dx = 2 mm case removed.

### 2026-11-02 - Assignment 1 (session 8): lecturer cable setting, Crank-Nicolson, Clear buttons, UI v4.2

#### Added

- Tab 5 excitation choice: current pulses (`PulseCount`, `PulseInterval`)
  or the APG waveform of tab 1 imposed on node 0 (lecturer's method,
  `cdVoltageTrace`). A train of action potentials now produces several waves
  in Vm(t) and in the space-time views (ISS-029).
- Tab 5 scheme choice: explicit FTCS or Crank-Nicolson (tridiagonal Thomas
  solver, unconditionally stable for the diffusion term) (ISS-030).
- Clear button on tabs 1 to 5 (charts, memo and stored results; parameters
  are kept).
- `Verification/cable_drive_reference.py`: Python reference for the
  APG-driven cable (FTCS and Crank-Nicolson); `TestHH.dpr` checks the new
  cases, golden output extended (old lines unchanged).
- Sheet 5: Crank-Nicolson equation (highlighted) and the APG drive.

#### Changed

- "Lecturer scale (2 mm)" preset and program default: passive cable driven
  by the APG waveform, 2 mm, dx = 0.4 mm, dt = 10 us, 60 ms, a = 5 um,
  six recording sites at 0, 0.4, ..., 2.0 mm. Squid preset: active cable,
  one current pulse.
- Tab 4 renamed "4. C-F Converter (Jin vs ISI)" (lecturer's term).
- Chart legends are refreshed after every rebuild (ISS-028).
- Sheet 4 and the report: the slide coefficient `[(ro+ri)Cm]^-1` is correct
  (Cm per unit length); ISS-003 corrected.
- Decorative `====` / `----` comment separators removed from all sources;
  no en or em dashes in code, sheets or report.
- `.gitignore`: submission archive `/5023231017_*.zip`, `**/__recovery/`,
  `/Claude outputs/`, lecturer handout of the final project.

#### Report

- `Report/..._rev.docx`: revision of my edited report. Only the
  listed paragraphs were changed: slide coefficient (Section 1.4),
  Crank-Nicolson note (1.5), tab list (2.2.1), relation to the slide and
  Crank-Nicolson extension (2.2.3, Equations (2.21a) and (2.21b)), cable
  description and code listings (2.2.2, 2.2.4), lecturer preset results and
  Figure 2.10 placeholder (2.3.5), discussion (2.4) and conclusion.

### 2026-11-02 - Assignment 1 (session 7, continued): Word report

#### Added

- `Report/5023231017_..._Assignment 1_HH Model.docx`: complete report
  (cover and Section 2.1 kept from my file; Chapter I theory with
  Figures 1.1-1.4; Chapter II with full Delphi routines per problem, the
  Problem 2 derivation, execution analysis with Figures 2.1-2.9 and Tables
  2.1-2.5, discussion; Chapter III; IEEE references [1]-[11]). Equations used
  by the program are highlighted in yellow (style "Highlighted Equation").
- `Report/source/`: Markdown sources, figure scripts and the build script
  (pandoc + lxml) that regenerate the report.
- `Report/drafts/Template_original_before_A1_report.docx`: the previous file
  (old template body) kept as a backup.

#### Notes

- Figures 2.1, 2.3, 2.5, 2.6 and 2.8(a) are screenshots of UI v2/v3 (old
  window caption); Figure 2.8(b) shows the 3D mesh before the v4.1 fit.
  Replace with v4.1 screenshots before submission (ISS-027).

### 2026-11-02 - Assignment 1 (session 7): flicker-free 3D views, UI v4.1

#### Fixed

- ISS-026: the 3D waterfall and 3D mesh flickered during Play and while the
  time slider or the yaw/pitch track bars moved. The space-time view is now
  composed in an off-screen bitmap and copied in one operation; the 3D
  surface is cached (key: view, yaw, pitch, size, run) so that every frame
  only copies the cache and draws the moving Vm(x) profile; animation and
  slider updates draw directly instead of calling `Invalidate`.
- The 3D projection is fitted to the drawing area for every yaw and pitch
  (projected bounding box of the data cube), so the surface is no longer cut
  at the bottom (seen at yaw -7, pitch 30).

#### Changed

- The four CSV exports moved from the assignment root to
  `Assignment 1_HH Model/Data/`.

### 2026-11-02 - Assignment 1 (session 6): mathematical sheets, mm units, 3D mesh, UI v4

#### Added

- `Program/EquationViewer.pas`: six LaTeX-rendered mathematical sheets, each
  in its own non-modal window owned by the main form: (1) equivalent circuit
  and membrane equations, (2) gating kinetics, (3) RK4 integration (APG),
  (4) cable equation derivation, (5) central/forward difference scheme
  (Problem 2), (6) analysis definitions. Caption format
  "Jeremia Christ Immanuel Manalu - 5023231017 - <sheet title>"; the window
  is sized to the image and limited to 90 % of the work area; notation table
  per sheet in order of appearance; equations implemented by the program are
  highlighted in yellow; Copy image, Save PNG and red Close buttons; Esc
  closes; mouse wheel scrolls.
- Sheet buttons: tab 6 lists all six sheets; "Theory" buttons in tabs 1-4,
  "Cable equation" and "FD derivation (Problem 2)" in tab 5; F1 opens the
  sheet of the active tab. New teal button role `bkInfo` for sheet buttons.
- Tab 5 presets: "Squid axon (HH 1952)" (default) and "Lecturer scale
  (2 mm)" (a = 1 um, 2 mm axon, h = 0.1 mm, recording sites every 0.4 mm).
- Tab 5 view "3D mesh": wireframe net of Vm(x, t) (every selected x joined
  along t and every selected t joined along x), hidden lines removed with the
  painter's algorithm, edge colour = Vm (viridis). `Verification/mesh_preview.py`
  reproduces the drawing in Python.
- `Program/Resources/sheet1_membrane.png` ... `sheet6_analysis.png`, sources
  and `build_sheets.py` in `Program/Resources/tex/`, linked as SHEET1_PNG ...
  SHEET6_PNG through `Equations.rc`; `EquationViewer.pas` added to
  `Project1.dpr` and `Project1.dproj`.

#### Changed

- Main form caption: "Jeremia Christ Immanuel Manalu - 5023231017 -
  Hodgkin-Huxley Neuron Model Simulator"; application title accordingly.
- Tab 5 lengths (axon length, spatial step h, stimulated length) are entered
  in mm; x axes, legends, read-out, heat map, 3D axes, result memo and CSV
  header use mm (ISS-023). `HHModel.pas` still works in cm (unchanged).
- Tab 2 trajectories are dots (`TPointSeries`) at a constant time stride, so
  the dot spacing shows how fast the state moves.

#### Verification

- FPC 3.2.2 stub compilation of `Unit1.pas` and `EquationViewer.pas`: no
  errors. `checkdfm`: 116 objects, balanced blocks, every handler implemented.
- `HHModel.pas` unchanged (MD5 289cecc2...), regression output identical.
- Mesh drawing order checked with `mesh_preview.py` at yaw +35 and -40 deg.

### 2026-11-01 - Assignment 1 (session 5): first-run fixes, UI v3

#### Fixed

- ISS-019: a plain mouse wheel over a chart raised `EInvalidCast`. The wheel
  is now intercepted in `TForm1.MouseWheelHandler` (wheel = zoom at the
  cursor, Shift + wheel = time axis only), and all chart handlers use
  `is` checks instead of `as` casts.
- ISS-020: access violation and black chart in the refractory example at
  2.0 ms. The example chart now uses three permanent series, legend check
  boxes are suspended while series lists are rebuilt, and a global
  exception logger was added (mitigation, retest pending).

#### Added

- Tab "2. Gating Phase Plots": m, h and n against Vm with steady-state curves
  x_inf(Vm), and tau_x(Vm) on a logarithmic axis (ISS-021).
- Rendered equation and nomenclature sheets (LaTeX -> PNG,
  `Program/Resources/`, sources in `Program/Resources/tex/`). They are linked
  as RCDATA through `Equations.rc` and shown in tab "6. Model and
  Equations", with the plain-text summary as a fallback.
- Flat colour buttons (TPanel): primary blue, secondary grey, success green
  (Play), danger red (new Exit button), each with hover and pressed shades.
- Keyboard: F5 runs the active tab, Esc stops the APP animation
  (`KeyPreview`).
- `Application.OnException` logger: `HHSimulator_error.log` next to the
  executable; handled input errors are logged as WARN.
- ISS-022: list of documented limitations.

#### Changed

- Tabs renumbered: 1 APG, 2 Gating Phase Plots, 3 Refractory Period, 4 Jin
  vs Inter-pulse Interval, 5 APP, 6 Model and Equations.
- The phase-plot check box on tab 1 was removed (replaced by tab 2).
- `Project1.dpr`: `{$R 'Equations.res' 'Equations.rc'}`. `Project1.dproj`:
  `RcCompile` item for `Equations.rc`.
- The toolbar now uses aligned buttons, an elided "Active chart" label, a
  right-aligned help text and the Exit button.
- ISS-010 and ISS-015 resolved: my first Delphi 13 CE build
  compiled and ran.

### 2026-11-01 - Repository (session 4): files written to the local tree

#### Changed

- All Assignment 1 deliverables of sessions 1-3 written into
  `C:\Users\Sem 7\Biocybernetics` after the NTFS permission fix (ISS-009
  resolved). The empty IDE templates `Program/Unit1.pas`, `Unit1.dfm` and
  `Project1.dpr` were overwritten. The written files are byte-identical
  (MD5) to the verified copies.
- `Assignment 1_HH Model/Program/Project1.dproj`: added
  `<DCCReference Include="HHModel.pas"/>` before the `Unit1.pas` reference
  (CRLF preserved; XML well-formedness checked).
- `.gitignore` verified with `git check-ignore`: both IEEE papers,
  `Materials/`, `__history/` and `*.local` are ignored.

### 2026-11-01 - Assignment 1 (session 3): Problem 4 draft, repository setup

#### Added

- `Assignment 1_HH Model/Report/drafts/Problem4_Paper_Review.md`: English
  draft of Problem 4. It reviews Amini et al. (2005) and Haghiri et al.
  (2021) from the full texts, compares both with this project's
  implementation, discusses the impact of the HH work on medical and
  biological technology, and gives IEEE references. Critical notes on the
  papers are recorded in ISS-017.
- Repository root: `README.md` (overview), `.gitattributes` (CRLF for Delphi
  sources, LF for text), `.github/workflows/a1-model-regression.yml`
  (FPC build of `HHModel.pas` + golden-output diff + Python references;
  verified locally with FPC 3.2.2).

#### Changed

- `.gitignore`: excludes the assigned IEEE papers (ISS-018), a
  `**/References/` folder convention, AI-assistant working files (`.claude/`,
  `CLAUDE.md`, `CLAUDE.local.md`, `.mcp.json`) and the CI artefact
  `actual.txt`.
- `ISSUES.md`: ISS-011 resolved (Haghiri et al.: vol. 68, no. 1,
  pp. 275-287, doi:10.1109/TCSI.2020.3026076); ISS-009 updated (still
  blocked after the Controlled Folder Access allow-list); ISS-017 and
  ISS-018 added.

### 2026-11-01 - Assignment 1: Hodgkin-Huxley Neuron Model (session 2, UI v2)

#### Changed

- `Unit1.pas` / `Unit1.dfm` redesigned (UI v2):
  - Colour: Okabe-Ito categorical palette (colour-blind safe) with semantic
    grouping (Na = vermillion/orange, K = blue, leak = green, stimulus = grey,
    Vm = black); viridis for ordered series (recording position, time, |Jin|)
    and for the space-time heat map (replaces the jet map, which is not
    perceptually uniform).
  - Line width adapts to the number of series (2 px for four or fewer, 1 px
    otherwise; 3 px for the emphasised time-slider profile).
  - Every chart: bold title, axis titles with units, light grid, Segoe UI
    fonts, legend at the bottom with check boxes; legend hidden for
    single-series charts; on dual-axis charts the right axis takes the colour
    of its series.
  - Currents chart: JL moved to a right axis (green) because it is about 30x
    smaller than JNa/JK; the duplicated Jin trace was removed (ISS-014).
  - Interaction: global chart toolbar (Zoom in, Zoom out, Reset view, Save
    PNG, Copy image) acting on the chart under the mouse; Ctrl + wheel zooms
    at the cursor; double-click resets; status-bar read-out of cursor
    coordinates; synchronised time axes for the four APG charts.
  - APG: parameter grid shows only the rows used by the selected protocol;
    optional phase plot (m, h, n against Vm).
  - Refractory: example interval selected with a track bar (0.5 ms steps,
    250 ms debounce) instead of a typed value; example re-runs automatically.
  - APP: time slider + Play/Pause animation drives a bold Vm(x) profile, a
    time cursor on Vm(t) and a cursor on the heat map; heat map or 3D
    waterfall view (painter's algorithm, yaw/pitch track bars).
  - Layout: splitters between parameter panels and charts, minimum form size
    1100 x 680, starts maximised, hints on every button.
- `HHModel.pas`: `SecondSpikeOccurs` uses a `while` loop instead of `Exit`
  inside a `for` loop (coding-standard clean-up, results unchanged).

#### Verified

- `TestHH` output identical to session 1 (model regression).
- `Unit1.pas` v2 compiles without errors or warnings against VCL/TeeChart
  stubs; DFM checker: 86 components consistent with the class declaration,
  all event handlers implemented, blocks balanced.

### 2026-11-01 - Assignment 1: Hodgkin-Huxley Neuron Model (session 1)

#### Added

- `Assignment 1_HH Model/Program/HHModel.pas`: UI-independent numerical core.
  - HH membrane in the lecturer's week-9 notation and the original
    Hodgkin-Huxley (1952) sign convention (depolarization negative,
    `Vm = -(v + 70)` mV).
  - Rate functions with the removable singularities of `alpha_m` (v = -25 mV)
    and `alpha_n` (v = -10 mV) handled analytically through
    `ExpRatio(x) = x/(exp(x)-1)` (ISS-005).
  - Two integrators: classical coupled RK4 on `[v, m, h, n]` and the lecturer's
    sequential scalar RK4 (ISS-007).
  - Stimulus protocols: step, lecturer staircase (-5/-10/-20/0 uA/cm2),
    paired pulse.
  - On-line spike detector (0 mV upward crossing, peak tracking).
  - Refractory analysis: single-pulse threshold and test-pulse threshold vs
    interval by bisection (absolute refractory = no AP up to |J2|max).
  - Jin vs inter-pulse interval sweep (steady mean ISI after transient).
  - Cable (APP) solver: explicit FTCS (central difference in x, forward
    difference in t), sealed ends, active HH or passive `gm` membrane,
    stability guard `r = k/((ro+ri) cm h^2) <= 0.5` (ISS-012), conduction
    velocity and passive length constant.
  - Optional temperature scaling `phi = 3^((T-6.3)/10)`.
- `Unit1.pas` / `Unit1.dfm`: five-tab VCL front end (APG, Refractory Period,
  Jin vs Inter-pulse Interval, APP, Model Parameters) using TeeChart; chart
  series created at run time, parameters edited in `TValueListEditor` grids,
  CSV export for every analysis, space-time colour map for propagation.
- `Project1.dpr`: registers `HHModel.pas`.
- `Program/Verification/`: FPC console harness `TestHH.dpr`, its output, and
  independent Python references (`hh_reference_apg.py`, `hh_reference_app.py`).
- Repository `.gitignore` limiting version control to own work (ISS-008).
- `ISSUES.md`, `CHANGELOG.md`, `Assignment 1_HH Model/README.md`.

#### Verified (headless, FPC 3.2.2 + Python/NumPy)

- Coupled RK4 Delphi-equivalent core reproduces the Python reference exactly
  (spike counts, ISI to 0.01 ms).
- `Unit1.pas` compiles without errors or warnings against VCL/TeeChart stubs
  (API names still to be confirmed by the real Delphi 13 build, ISS-010).
- Active cable conduction velocity: 12.0 m/s at 6.3 deg C (h = 0.1 cm),
  12.2 m/s at h = 0.05 cm, 18.2 m/s at 18.5 deg C (HH 1952 calculated
  18.8 m/s, measured 21.2 m/s).

#### Pending

- Write the files into the local `Program` folder (blocked, ISS-009) and add
  `HHModel.pas` to `Project1.dproj`.
- First Delphi 13 build and screenshots (my task) (ISS-010).
- Report (`Report/*.docx`) after real program output is available.
