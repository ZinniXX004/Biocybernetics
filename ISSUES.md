# Issue Log

Problems found while studying the references, implementing, and maintaining
the Biocybernetics assignments. Status values: **Open**, **Resolved**,
**Mitigated** (worked around, root cause outside this repository), **Needs
confirmation** (requires the lecturer or the student).

| ID      | Area                 | Summary                                                                                   | Status             |
| ------- | -------------------- | ----------------------------------------------------------------------------------------- | ------------------ |
| ISS-001 | A1 / lecturer slides | "Integration step: 10 sec" printed in `HH Simulation.pdf`                                 | Resolved           |
| ISS-002 | A1 / lecturer slides | `alpha_m` numerator printed as `0.1(v+2.5)` in `HH model.pdf`                             | Resolved           |
| ISS-003 | A1 / lecturer slides | PDE coefficient: slide is correct (`[(ro+ri)Cm]^-1`, Cm per length); earlier note withdrawn | Corrected          |
| ISS-004 | A1 / lecturer code   | Propagation code uses `vm[0,i]` in the `gm` term                                          | Needs confirmation |
| ISS-005 | A1 / senior code     | `+1e-9` added to rate denominators                                                        | Resolved           |
| ISS-006 | A1 / senior code     | APP implemented as pure diffusion of the APG output                                       | Resolved           |
| ISS-007 | A1 / numerics        | Lecturer RK4 is not a coupled RK4                                                         | Resolved           |
| ISS-008 | Repository           | No `.gitignore`; copyrighted material untracked in the repo root                          | Resolved           |
| ISS-009 | Environment          | Writes to `C:\Users\Sem 7\Biocybernetics` denied by Windows                               | Resolved           |
| ISS-010 | A1 / build           | First Delphi 13 CE build: compiled and ran (TeeChart available)                           | Resolved           |
| ISS-011 | A1 / report          | Haghiri et al. (2021) DOI and pages verified from the PDF                                 | Resolved           |
| ISS-012 | A1 / numerics        | Explicit FTCS cable scheme is conditionally stable                                        | Mitigated          |
| ISS-013 | A1 / numerics        | Sealed-end boundary raises the spike peak at the last node                                | Mitigated          |
| ISS-014 | A1 / UI              | JL and Jin invisible on the shared current axis (about 30x smaller)                       | Resolved           |
| ISS-015 | A1 / UI              | TeeChart-specific calls of UI v2 compiled in the real build                                | Resolved           |
| ISS-016 | A1 / code style      | `delphi-standards` prefixes applied to `Unit1.pas` only, not yet to `HHModel.pas`         | Open               |
| ISS-017 | A1 / papers          | Internal inconsistencies found in both assigned papers (to be cited carefully)            | Mitigated          |
| ISS-018 | Repository           | Assigned IEEE papers stored in the assignment folder must not be pushed                   | Resolved           |
| ISS-019 | A1 / UI              | Plain mouse wheel over a chart raised EInvalidCast                                         | Resolved (retest)  |
| ISS-020 | A1 / UI              | Access violation and permanently black chart when the refractory slider reached 2.0 ms     | Mitigated (retest) |
| ISS-021 | A1 / scope           | Gate-vs-Vm plots of the senior program (m, h, n vs Vm) missing                             | Resolved           |
| ISS-022 | A1 / limitations     | Documented limitations of the simulator (numerics, detection, UI)                         | Documented         |
| ISS-028 | A1 / UI              | Stale legend entries after a new run (tab 5)                                               | Fixed (retest)     |
| ISS-029 | A1 / scope           | One wave only; lecturer's passive cable driven by the APG output                           | Resolved           |
| ISS-030 | A1 / numerics        | Crank-Nicolson option for the cable PDE                                                    | Resolved           |
| ISS-031 | A1 / scope           | ABE and C-F converter of the lecturer's simulator; lecturer constants                     | Documented         |
| ISS-032 | A1 / UI              | Tab 5 memo repeated nodes on the 6-node lecturer grid                                      | Resolved           |
| ISS-033 | A1 / CI              | Python references ran in CI without any assertion                                          | Resolved           |
| ISS-034 | CI                   | Node 20 removed from GitHub-hosted runners; checkout@v4 / setup-python@v5 outdated          | Resolved           |
| ISS-035 | A1 / UI              | Charts, series and parameter rows were created at run time, invisible in the Form Designer | Resolved           |

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

- **Source:** `Biocyber/Materi Pak Arifin/Propagation model computation.docx`:
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
- **Update 2026-11-01 (session 3):** the student allow-listed
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
- **Resolution:** the student added explicit `(OI)(CI)(F)` entries for
  `Everyone` and `BUILTIN\Users` on the folder. Writes now succeed, and all
  session 1-3 files were written into the repository tree.
- **Follow-up (optional hardening):** `Everyone:(F)` is broader than needed.
  Replace it with Modify rights for the student's account only, then re-test
  write access.

- **Symptom:** `device_commit_files` returned "Windows denied access ... If
  Controlled Folder Access is on, add this app ..."; shell writes return
  `Permission denied`. The folder can still be read.
- **Action for the student:** Windows Security -> Virus & threat protection ->
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
  that is not the chart for wheel-initiated scrolls *(inference: the call
  stack was not captured)*.
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
  still referencing a freed series *(inference: no call stack yet)*.
- **Mitigation (UI v3):** the example chart owns three permanent series.
  Only their points are replaced, and the third series is deactivated (and
  its legend title explains why) inside the absolute refractory period.
  `ClearChart` switches legend check boxes off while a chart's series list
  is rebuilt and `FinishChart` switches them on again. `Application.OnException`
  writes any remaining exception to `HHSimulator_error.log` (next to the exe)
  and shows a dialog at most once per 2 s for the same error.
- **If it recurs:** press *Break* in the debugger notification and copy the
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
  file tools may not write `.github/workflows/`, so the student copies the
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
