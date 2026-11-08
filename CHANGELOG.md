# Changelog

All notable changes to the Biocybernetics (EB234701, Class Q) repository are
recorded here. Format: one dated entry per working session, grouped by
assignment. Issue identifiers (`ISS-xxx`) refer to [ISSUES.md](ISSUES.md).

## [Unreleased]

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
