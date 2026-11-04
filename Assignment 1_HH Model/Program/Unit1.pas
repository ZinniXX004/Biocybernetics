unit Unit1;

{
  Unit1.pas - Main form of the Hodgkin-Huxley neuron simulator (UI v4.3).

  Course : Biocybernetics (EB234701), Class Q - Assignment 1
  Author : Jeremia Christ Immanuel Manalu (5023231017)

  Tabs
    1. APG (RK4)            : action potential generation, Problem 1
    2. Gating Phase Plots   : m, h, n against Vm, steady states, time constants
    3. Refractory Period    : paired-pulse threshold sweep, Problem 1
    4. C-F Converter        : input level programs the inter-pulse interval
    5. APP (Cable)          : action potential propagation, Problem 3; the
                              axon is excited by current pulses or by the
                              APG waveform of tab 1 imposed at x = 0
    6. Model and Equations  : HH constants shared by all tabs and the six
                              mathematical sheets (Problem 2 = sheet 5)

  Mathematical sheets
    Every equation and derivation is a LaTeX-rendered PNG shown in its own
    window (EquationViewer.pas). Tab 6 lists all six sheets; the Theory
    buttons of tabs 1-5 and F1 open the sheet that belongs to the tab.

  Design rules applied in this unit
    - Colour: Okabe-Ito palette for categorical series (colour-blind safe),
      viridis for ordered series (recording position, time, |Jin|).
      Sodium-related traces use warm colours, potassium-related traces use
      blue, leakage uses green, the stimulus uses grey.
    - Line width adapts to the number of series in a chart (2 px for up to
      four series, 1 px otherwise); emphasised series keep 3 px.
    - Every chart is designed in Unit1.dfm (visible in the Form Designer):
      2D, bold title, axis titles with units, light grid, legend at the
      bottom with check boxes (click to hide/show a series) and its series
      with their colours. The code only fills the series with data; the
      parameter editors, the model summary and the rendered equations of
      tab 6 are also part of the form.
    - Interaction: drag right-down = zoom box, drag left-up or double-click =
      reset, right-drag = pan, mouse wheel = zoom at the cursor (Shift +
      wheel = time axis only), toolbar buttons act on the chart under the
      mouse, F5 runs the active tab, every tab has a Clear button. Time
      axes of the four APG charts are
      synchronised. The status bar shows the cursor coordinates.
    - Buttons are flat TPanel controls with role colours (primary blue,
      secondary grey, success green, danger red) and hover/pressed shades.
    - Unhandled exceptions are written to HHSimulator_error.log next to the
      executable (Application.OnException) and reported once per 2 s.
    - Lengths of the cable (tab 5) are entered and shown in mm; HHModel
      works in cm (conversion factor C_MM_PER_CM).
    - All numerical work is delegated to HHModel.pas.
}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.Types, System.Math, System.UITypes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Grids, Vcl.ValEdit, Vcl.Clipbrd, Vcl.Imaging.pngimage,
  VCLTee.TeEngine, VCLTee.TeeProcs, VCLTee.Chart, VCLTee.Series, HHModel,
  EquationViewer;

const
  { recording sites (and Vm(x) snapshots) designed on the form in tab 5 }
  C_MAX_SITES = 8;

type
  { Visual role of a flat (TPanel-based) button }
  TButtonKind = (bkPrimary, bkSecondary, bkDanger, bkSuccess, bkInfo);

  { Layers of a 3D space-time view: the surface is cached, the overlay
    (time-slider profile and caption) is redrawn on every frame }
  TSpaceLayer = (slSurface, slOverlay);

  TForm1 = class(TForm)
    pnlChartTools: TPanel;
    btnZoomIn: TPanel;
    btnZoomOut: TPanel;
    btnZoomReset: TPanel;
    btnSavePNG: TPanel;
    btnCopyChart: TPanel;
    btnExit: TPanel;
    lblActiveChart: TLabel;
    lblChartHelp: TLabel;
    StatusBar1: TStatusBar;
    PageControl1: TPageControl;
    tsAPG: TTabSheet;
    tsPhase: TTabSheet;
    tsRefractory: TTabSheet;
    tsISI: TTabSheet;
    tsAPP: TTabSheet;
    tsModel: TTabSheet;
    pnlAPGLeft: TPanel;
    rgProtocol: TRadioGroup;
    rgMethod: TRadioGroup;
    vleAPG: TValueListEditor;
    pnlAPGButtons: TPanel;
    btnRunAPG: TPanel;
    btnExportAPG: TPanel;
    btnClearAPG: TPanel;
    btnTheoryAPG: TPanel;
    memAPG: TMemo;
    splAPG: TSplitter;
    gpAPG: TGridPanel;
    chtVm: TChart;
    serVm: TFastLineSeries;
    serJin: TFastLineSeries;
    chtCurrents: TChart;
    serJNa: TFastLineSeries;
    serJK: TFastLineSeries;
    serJL: TFastLineSeries;
    chtGates: TChart;
    serM: TFastLineSeries;
    serH: TFastLineSeries;
    serN: TFastLineSeries;
    chtConductance: TChart;
    serGNa: TFastLineSeries;
    serGK: TFastLineSeries;
    pnlPhaseTop: TPanel;
    btnTheoryPhase: TPanel;
    btnClearPhase: TPanel;
    lblPhaseInfo: TLabel;
    gpPhase: TGridPanel;
    chtPhaseM: TChart;
    serTrajM: TPointSeries;
    serInfM: TFastLineSeries;
    chtPhaseH: TChart;
    serTrajH: TPointSeries;
    serInfH: TFastLineSeries;
    chtPhaseN: TChart;
    serTrajN: TPointSeries;
    serInfN: TFastLineSeries;
    chtTau: TChart;
    serTauM: TFastLineSeries;
    serTauH: TFastLineSeries;
    serTauN: TFastLineSeries;
    pnlRefLeft: TPanel;
    vleRef: TValueListEditor;
    pnlRefButtons: TPanel;
    btnRunRef: TPanel;
    btnExportRef: TPanel;
    btnClearRef: TPanel;
    btnTheoryRef: TPanel;
    pnlRefExample: TPanel;
    lblRefInterval: TLabel;
    tbRefInterval: TTrackBar;
    memRef: TMemo;
    splRef: TSplitter;
    gpRef: TGridPanel;
    chtRefThreshold: TChart;
    serRefThr: TLineSeries;
    serRefBase: TLineSeries;
    serRefPeak: TLineSeries;
    chtRefExample: TChart;
    serRefEx1: TFastLineSeries;
    serRefEx2: TFastLineSeries;
    serRefEx3: TFastLineSeries;
    pnlISILeft: TPanel;
    vleISI: TValueListEditor;
    pnlISIButtons: TPanel;
    btnRunISI: TPanel;
    btnExportISI: TPanel;
    btnClearISI: TPanel;
    btnTheoryISI: TPanel;
    memISI: TMemo;
    splISI: TSplitter;
    gpISI: TGridPanel;
    chtISI: TChart;
    serISI: TLineSeries;
    serFreq: TLineSeries;
    chtISITraces: TChart;
    serTraceA: TFastLineSeries;
    serTraceB: TFastLineSeries;
    serTraceC: TFastLineSeries;
    pnlAPPLeft: TPanel;
    rgCableMode: TRadioGroup;
    rgAPPDrive: TRadioGroup;
    rgAPPScheme: TRadioGroup;
    pnlAPPPresets: TPanel;
    btnPresetSquid: TPanel;
    btnPresetLecturer: TPanel;
    vleAPP: TValueListEditor;
    pnlAPPButtons: TPanel;
    btnRunAPP: TPanel;
    btnExportAPP: TPanel;
    btnClearAPP: TPanel;
    pnlAPPSheets: TPanel;
    btnSheetCable: TPanel;
    btnSheetFD: TPanel;
    memAPP: TMemo;
    splAPP: TSplitter;
    pnlAPPRight: TPanel;
    pnlAPPTimeBar: TPanel;
    btnPlay: TPanel;
    tbAPPTime: TTrackBar;
    lblAPPTime: TLabel;
    gpAPP: TGridPanel;
    chtAPPTime: TChart;
    serSite1: TFastLineSeries;
    serSite2: TFastLineSeries;
    serSite3: TFastLineSeries;
    serSite4: TFastLineSeries;
    serSite5: TFastLineSeries;
    serSite6: TFastLineSeries;
    serSite7: TFastLineSeries;
    serSite8: TFastLineSeries;
    serTimeCursor: TLineSeries;
    chtAPPSpace: TChart;
    serSnap1: TFastLineSeries;
    serSnap2: TFastLineSeries;
    serSnap3: TFastLineSeries;
    serSnap4: TFastLineSeries;
    serSnap5: TFastLineSeries;
    serSnap6: TFastLineSeries;
    serSnap7: TFastLineSeries;
    serSnap8: TFastLineSeries;
    serLiveProfile: TFastLineSeries;
    pnlAPPView: TPanel;
    pnlAPPViewTools: TPanel;
    rgAPPView: TRadioGroup;
    lblYaw: TLabel;
    tbYaw: TTrackBar;
    lblPitch: TLabel;
    tbPitch: TTrackBar;
    pbSpaceTime: TPaintBox;
    pnlModelLeft: TPanel;
    vleModel: TValueListEditor;
    pnlModelButtons: TPanel;
    btnResetModel: TPanel;
    pnlSheets: TPanel;
    lblSheets: TLabel;
    btnSheet1: TPanel;
    btnSheet2: TPanel;
    btnSheet3: TPanel;
    btnSheet4: TPanel;
    btnSheet5: TPanel;
    btnSheet6: TPanel;
    lblSheetsNote: TLabel;
    memModelInfo: TMemo;
    sbEquations: TScrollBox;
    imgEquations: TImage;
    imgNomenclature: TImage;
    SaveDialog1: TSaveDialog;
    SaveDialogPNG: TSaveDialog;
    tmrPlay: TTimer;
    tmrRefDebounce: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnExitClick(Sender: TObject);
    procedure btnZoomInClick(Sender: TObject);
    procedure btnZoomOutClick(Sender: TObject);
    procedure btnZoomResetClick(Sender: TObject);
    procedure btnSavePNGClick(Sender: TObject);
    procedure btnCopyChartClick(Sender: TObject);
    procedure rgProtocolClick(Sender: TObject);
    procedure btnRunAPGClick(Sender: TObject);
    procedure btnExportAPGClick(Sender: TObject);
    procedure btnRunRefClick(Sender: TObject);
    procedure btnExportRefClick(Sender: TObject);
    procedure tbRefIntervalChange(Sender: TObject);
    procedure tmrRefDebounceTimer(Sender: TObject);
    procedure btnRunISIClick(Sender: TObject);
    procedure btnExportISIClick(Sender: TObject);
    procedure btnRunAPPClick(Sender: TObject);
    procedure btnExportAPPClick(Sender: TObject);
    procedure btnPlayClick(Sender: TObject);
    procedure tbAPPTimeChange(Sender: TObject);
    procedure tmrPlayTimer(Sender: TObject);
    procedure rgAPPViewClick(Sender: TObject);
    procedure tbViewChange(Sender: TObject);
    procedure pbSpaceTimePaint(Sender: TObject);
    procedure btnResetModelClick(Sender: TObject);
    procedure btnSheetClick(Sender: TObject);
    procedure btnPresetSquidClick(Sender: TObject);
    procedure btnPresetLecturerClick(Sender: TObject);
    procedure btnClearAPGClick(Sender: TObject);
    procedure btnClearPhaseClick(Sender: TObject);
    procedure btnClearRefClick(Sender: TObject);
    procedure btnClearISIClick(Sender: TObject);
    procedure btnClearAPPClick(Sender: TObject);
    { chart events, assigned to every chart in Unit1.dfm }
    procedure ChartMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure ChartDblClick(Sender: TObject);
    procedure ChartZoomed(Sender: TObject);
    procedure ChartUnzoomed(Sender: TObject);
  private
    FFmt: TFormatSettings;
    FAPG: TAPGResult;
    FAPGValid: Boolean;
    FAPGStore: TStringList;
    FCable: TCableResult;
    FCableValid: Boolean;
    FAPPFrame: Integer;
    FHeatMap: TBitmap;
    FSpaceBuffer: TBitmap;      // off-screen image of the whole view
    FSpaceCache: TBitmap;       // cached 3D surface (waterfall or mesh)
    FSpaceCacheKey: string;     // view|yaw|pitch|width|height|run of the cache
    FCableRunId: Integer;       // incremented by every APP run
    FHeatRect: TRect;
    FRefInterval, FRefThreshold, FRefPeak: TDoubleArray;
    FRefBaseline: Double;
    FISIJin, FISIValue: TDoubleArray;
    FISICount: array of Integer;
    FBusy: Boolean;
    FSyncing: Boolean;
    FCharts: array of TChart;
    FActiveTarget: TControl;
    { design-time series of Unit1.dfm grouped for loops }
    FRefExSeries: array[0..2] of TFastLineSeries;
    FTraceSeries: array[0..2] of TFastLineSeries;
    FSiteSeries: array[0..C_MAX_SITES - 1] of TFastLineSeries;
    FSnapSeries: array[0..C_MAX_SITES - 1] of TFastLineSeries;
    FLogFile: string;
    FLastErrorText: string;
    FLastErrorTick: Cardinal;
    { flat buttons, error log }
    procedure StyleFlatButton(AButton: TPanel; AKind: TButtonKind);
    procedure StyleAllButtons;
    procedure FlatButtonEnter(Sender: TObject);
    procedure FlatButtonLeave(Sender: TObject);
    procedure FlatButtonDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FlatButtonUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AppException(Sender: TObject; E: Exception);
    procedure AppendLog(const ALevel, AMsg: string);
    procedure PlotPhase(const AParams: THHParams);
    function SheetForControl(Sender: TObject): Integer;
    function SheetForActiveTab: Integer;
    procedure OpenSheet(AIndex: Integer);
    procedure FillAPPEditor(const ACable: TCableParams; ASites: Integer);
    procedure ApplyAPPPreset(const ACable: TCableParams; AMode, ADrive,
      AScheme: Integer);
    function LecturerCableParams: TCableParams;
    procedure BuildAPGStimulus(out AStim: TStimulus);
    { parameter editors }
    procedure InitModelEditor;
    procedure InitAPGStore;
    procedure RebuildAPGEditor;
    procedure InitAPPEditor;
    procedure SetupEditor(AEditor: TValueListEditor);
    procedure AddParam(AEditor: TValueListEditor; const AKey: string;
      const AValue: Double);
    function ParamValue(AEditor: TValueListEditor; const AKey: string): Double;
    function ParamInt(AEditor: TValueListEditor; const AKey: string): Integer;
    function ReadModelParams: THHParams;
    function SelectedMethod: TIntegrator;
    function FloatText(const AValue: Double; const ADigits: Integer = 3): string;
    { charts (titles, axes, legends and series are designed in Unit1.dfm) }
    procedure RegisterChart(AChart: TChart; AGroup: Integer);
    procedure FinishChart(AChart: TChart);
    procedure ClearChart(AChart: TChart);
    { chart interaction }
    procedure SpaceTimeMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure SetActiveTarget(AControl: TControl);
    procedure ZoomAxis(AAxis: TChartAxis; const AFactor, ACenter: Double);
    procedure ZoomChart(AChart: TChart; const AFactor: Double;
      AUseCursor: Boolean; const APoint: TPoint; AXOnly: Boolean = False);
    procedure ResetChart(AChart: TChart);
    procedure SyncGroup(ASource: TChart; AReset: Boolean);
    function RenderActiveTarget: TBitmap;
    { results }
    procedure PlotAPG;
    procedure ReportAPG(const AStim: TStimulus; const ADt, ATEnd: Double);
    procedure RunRefExample;
    function RefExampleInterval: Double;
    procedure PlotCable(ASites: Integer);
    procedure ReportCable(const AParams: TCableParams);
    procedure UpdateAPPFrame;
    procedure StopPlay;
    procedure BuildHeatMap;
    procedure DrawSpaceTime(ACanvas: TCanvas; AWidth, AHeight: Integer);
    procedure DrawHeatMap(ACanvas: TCanvas; AWidth, AHeight: Integer);
    procedure DrawWaterfall(ACanvas: TCanvas; AWidth, AHeight: Integer;
      ALayer: TSpaceLayer);
    procedure DrawMesh(ACanvas: TCanvas; AWidth, AHeight: Integer;
      ALayer: TSpaceLayer);
    procedure PaintSpaceTimeBuffered;
    procedure RefreshSpaceTime;
    procedure SaveLines(ALines: TStrings; const ADefaultName: string);
    procedure ShowError(const AMsg: string);
    procedure SetStatus(const AMsg: string);
    procedure SetReadout(const AMsg: string);
  public
    { every mouse-wheel message of the form passes through here first }
    procedure MouseWheelHandler(var Message: TMessage); override;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

type
  { access to protected mouse events of TControl (OnMouseEnter, ...) }
  TControlAccess = class(TControl);

const
  { flat button palette: normal / hover / pressed, text }
  { order: primary (blue), secondary (grey), danger (red), success (green),
    info (teal, opens a mathematical sheet) }
  C_BTN_FACE: array[TButtonKind] of TColor = (
    TColor($00B27200), TColor($00E8E8E8), TColor($002828C6), TColor($00327D2E),
    TColor($006B7900));
  C_BTN_HOVER: array[TButtonKind] of TColor = (
    TColor($008C5A00), TColor($00D6D6D6), TColor($001F1FA3), TColor($00245E22),
    TColor($005C6900));
  C_BTN_DOWN: array[TButtonKind] of TColor = (
    TColor($00734A00), TColor($00C4C4C4), TColor($00181880), TColor($001B4A1A),
    TColor($00404D00));
  C_BTN_TEXT: array[TButtonKind] of TColor = (
    clWhite, TColor($00333333), clWhite, clWhite, clWhite);
  C_ERROR_REPEAT_MS = 2000;   // identical errors are shown once per 2 s
  C_LOG_NAME = 'HHSimulator_error.log';

const
  { Okabe-Ito palette (TColor is $00BBGGRR); the same values are the series
    colours stored in Unit1.dfm }
  C_BLACK = TColor($00000000);
  C_BLUE = TColor($00B27200);        // #0072B2
  C_VERMILLION = TColor($00005ED5);  // #D55E00
  C_ORANGE = TColor($00009FE6);      // #E69F00
  C_GREEN = TColor($00739E00);       // #009E73
  C_SKY = TColor($00E9B456);         // #56B4E9
  C_PURPLE = TColor($00A779CC);      // #CC79A7
  C_STIM = TColor($00606060);        // stimulus (dark grey)
  C_TEXT = TColor($00333333);
  C_LABEL = TColor($00555555);
  C_GRID = TColor($00E6E6E6);

  { line widths }
  C_WIDTH_FEW = 2;      // up to C_FEW_SERIES series in a chart
  C_WIDTH_MANY = 1;
  C_WIDTH_EMPH = 3;     // emphasised series (Tag = C_TAG_EMPH)
  C_FEW_SERIES = 4;
  C_TAG_EMPH = 1;

  { chart groups whose time axes are synchronised }
  C_GROUP_NONE = 0;
  C_GROUP_APG = 1;

  { zoom }
  C_ZOOM_IN = 0.8;
  C_ZOOM_OUT = 1.25;

  { model parameter keys }
  K_GNA = 'gNa0 (mS/cm2)';
  K_GK = 'gK0 (mS/cm2)';
  K_GL = 'gL0 (mS/cm2)';
  K_VNA = 'VNa (mV, HH sign)';
  K_VK = 'VK (mV, HH sign)';
  K_VL = 'VL (mV, HH sign)';
  K_CM = 'Cm (uF/cm2)';
  K_TEMP = 'Temperature (deg C)';
  { APG keys }
  K_JBASE = 'Jin baseline (uA/cm2)';
  K_JLEVEL = 'Jin step level (uA/cm2)';
  K_TON = 't_on (ms)';
  K_TOFF = 't_off (ms)';
  K_JP1 = 'Pulse 1 level (uA/cm2)';
  K_JP2 = 'Pulse 2 level (uA/cm2)';
  K_PW = 'Pulse width (ms)';
  K_PINT = 'Pulse interval (ms)';
  K_DT = 'Integration step dt (ms)';
  K_TEND = 'Simulation time (ms)';
  { refractory keys }
  K_RJ1 = 'Conditioning pulse J1 (uA/cm2)';
  K_RPW = 'Pulse width (ms)';
  K_RI0 = 'Interval start (ms)';
  K_RI1 = 'Interval end (ms)';
  K_RIS = 'Interval step (ms)';
  K_RJMAX = 'Max |J2| searched (uA/cm2)';
  { inter-pulse interval keys }
  K_IJ0 = 'Jin start (uA/cm2)';
  K_IJ1 = 'Jin end (uA/cm2)';
  K_IJS = 'Jin step magnitude (uA/cm2)';
  K_ITR = 'Run time per level (ms)';
  K_IDIS = 'Discard transient (ms)';
  K_ITA = 'Trace A Jin (uA/cm2)';
  K_ITB = 'Trace B Jin (uA/cm2)';
  K_ITC = 'Trace C Jin (uA/cm2)';
  { cable keys }
  K_CA = 'Axon radius a (um)';
  K_CRI = 'Axoplasm resistivity Ri (ohm.cm)';
  K_CRO = 'External resistance ro (ohm/cm)';
  K_CLEN = 'Axon length (mm)';
  K_CDX = 'Spatial step h (mm)';
  K_CDT = 'Time step k (ms)';
  K_CTEND = 'Simulation time (ms)';
  K_CJ = 'Stimulus Jin (uA/cm2)';
  K_CDUR = 'Stimulus duration (ms)';
  K_CSL = 'Stimulated length (mm)';
  K_CGM = 'Passive gm (mS/cm2)';
  K_CSITES = 'Recording sites (2-8)';
  K_CNP = 'Number of current pulses';
  K_CPI = 'Pulse interval (ms)';
  C_MM_PER_CM = 10.0;           // cable lengths: UI in mm, HHModel in cm
  C_SITES_DEFAULT = 6;
  { indices of the APP radio groups }
  C_MODE_ACTIVE = 0;
  C_MODE_PASSIVE = 1;
  C_DRIVE_PULSES = 0;
  C_DRIVE_APG = 1;
  C_SCHEME_FTCS = 0;
  C_SCHEME_CN = 1;

  { mathematical sheets (EquationViewer) }
  C_SHEET_MEMBRANE = 1;
  C_SHEET_GATING = 2;
  C_SHEET_RK4 = 3;
  C_SHEET_CABLE = 4;
  C_SHEET_FD = 5;
  C_SHEET_ANALYSIS = 6;

  { viridis anchors (R, G, B) }
  C_VIRIDIS: array[0..9, 0..2] of Byte = (
    (68, 1, 84), (72, 40, 120), (62, 74, 137), (49, 104, 142),
    (38, 130, 142), (31, 158, 137), (53, 183, 121), (109, 205, 89),
    (180, 222, 44), (253, 231, 37));
  C_VIRIDIS_LINE_MAX = 0.85;   // keep lines away from low-contrast yellow
  C_VM_LO = -80.0;             // colour-map range of Vm (mV)
  C_VM_HI = 50.0;

  { 3D space-time views }
  C_3D_VBASE = -0.45;          // normalised Vm drawn between -0.45 and +0.45
  C_3D_VSPAN = 0.9;
  C_3D_MARGIN_LEFT = 16;       // fitted drawing area inside the paint box
  C_3D_MARGIN_TOP = 30;        // title line
  C_3D_MARGIN_RIGHT = 110;     // axis labels right of the axis end points
  C_3D_MARGIN_BOTTOM = 28;     // caption line

{ Colour helpers }

function ViridisColor(const AF: Double): TColor;
var
  LPos, LFrac: Double;
  LIdx: Integer;
  LR, LG, LB: Integer;
begin
  LPos := EnsureRange(AF, 0.0, 1.0) * 9.0;
  LIdx := Min(8, Trunc(LPos));
  LFrac := LPos - LIdx;
  LR := Round(C_VIRIDIS[LIdx, 0] + LFrac * (C_VIRIDIS[LIdx + 1, 0] - C_VIRIDIS[LIdx, 0]));
  LG := Round(C_VIRIDIS[LIdx, 1] + LFrac * (C_VIRIDIS[LIdx + 1, 1] - C_VIRIDIS[LIdx, 1]));
  LB := Round(C_VIRIDIS[LIdx, 2] + LFrac * (C_VIRIDIS[LIdx + 1, 2] - C_VIRIDIS[LIdx, 2]));
  Result := TColor(LR or (LG shl 8) or (LB shl 16));
end;

function OrderedLineColor(AIndex, ACount: Integer): TColor;
begin
  // Ordered series (position, time, |Jin|): viridis without the yellow end
  if ACount <= 1 then
    Result := ViridisColor(0.0)
  else
    Result := ViridisColor(C_VIRIDIS_LINE_MAX * AIndex / (ACount - 1));
end;

function VmColor(const AVm: Double): TColor;
begin
  Result := ViridisColor((AVm - C_VM_LO) / (C_VM_HI - C_VM_LO));
end;

{ Form life cycle }

procedure TForm1.FormCreate(Sender: TObject);
begin
  FFmt := TFormatSettings.Create('en-US');
  FFmt.DecimalSeparator := '.';
  FFmt.ThousandSeparator := ',';
  FHeatMap := TBitmap.Create;
  FHeatMap.PixelFormat := pf24bit;
  FSpaceBuffer := TBitmap.Create;
  FSpaceBuffer.PixelFormat := pf24bit;
  FSpaceCache := TBitmap.Create;
  FSpaceCache.PixelFormat := pf24bit;
  FSpaceCacheKey := '';
  FCableRunId := 0;
  FAPGStore := TStringList.Create;
  FAPGValid := False;
  FCableValid := False;
  FRefBaseline := NaN;
  FBusy := False;
  FSyncing := False;
  FAPPFrame := 0;
  FActiveTarget := nil;
  FLastErrorText := '';
  FLastErrorTick := 0;
  FLogFile := ExtractFilePath(Application.ExeName) + C_LOG_NAME;
  Application.OnException := AppException;
  StyleAllButtons;

  InitModelEditor;
  InitAPGStore;
  RebuildAPGEditor;
  InitAPPEditor;
  // vleRef and vleISI keep the default rows designed in Unit1.dfm

  // Titles, axes, legends, colours and series of every chart are designed
  // in Unit1.dfm; here the charts only join the zoom/export logic.
  RegisterChart(chtVm, C_GROUP_APG);
  RegisterChart(chtCurrents, C_GROUP_APG);
  RegisterChart(chtGates, C_GROUP_APG);
  RegisterChart(chtConductance, C_GROUP_APG);
  RegisterChart(chtPhaseM, C_GROUP_NONE);
  RegisterChart(chtPhaseH, C_GROUP_NONE);
  RegisterChart(chtPhaseN, C_GROUP_NONE);
  RegisterChart(chtTau, C_GROUP_NONE);
  RegisterChart(chtRefThreshold, C_GROUP_NONE);
  RegisterChart(chtRefExample, C_GROUP_NONE);
  RegisterChart(chtISI, C_GROUP_NONE);
  RegisterChart(chtISITraces, C_GROUP_NONE);
  RegisterChart(chtAPPTime, C_GROUP_NONE);
  RegisterChart(chtAPPSpace, C_GROUP_NONE);
  // gaps (no AP at an interval or Jin level) are not bridged by a line
  serRefThr.TreatNulls := tnDontPaint;
  serRefPeak.TreatNulls := tnDontPaint;
  serISI.TreatNulls := tnDontPaint;
  serFreq.TreatNulls := tnDontPaint;
  // series used in loops; the example chart keeps three permanent series,
  // freeing and re-creating series while legend check boxes are shown
  // caused an access violation (ISS-020)
  FRefExSeries[0] := serRefEx1;
  FRefExSeries[1] := serRefEx2;
  FRefExSeries[2] := serRefEx3;
  FTraceSeries[0] := serTraceA;
  FTraceSeries[1] := serTraceB;
  FTraceSeries[2] := serTraceC;
  FSiteSeries[0] := serSite1;
  FSiteSeries[1] := serSite2;
  FSiteSeries[2] := serSite3;
  FSiteSeries[3] := serSite4;
  FSiteSeries[4] := serSite5;
  FSiteSeries[5] := serSite6;
  FSiteSeries[6] := serSite7;
  FSiteSeries[7] := serSite8;
  FSnapSeries[0] := serSnap1;
  FSnapSeries[1] := serSnap2;
  FSnapSeries[2] := serSnap3;
  FSnapSeries[3] := serSnap4;
  FSnapSeries[4] := serSnap5;
  FSnapSeries[5] := serSnap6;
  FSnapSeries[6] := serSnap7;
  FSnapSeries[7] := serSnap8;

  pbSpaceTime.OnMouseMove := SpaceTimeMouseMove;
  rgAPPViewClick(nil);
  tbViewChange(nil);
  tbRefIntervalChange(nil);
  // tab 6: the rendered equations (imgEquations, imgNomenclature) and the
  // plain-text summary (memModelInfo, hidden) are designed in Unit1.dfm

  PageControl1.ActivePage := tsAPG;
  SetStatus('Ready. Units: ms, mV, uA/cm2, mS/cm2, uF/cm2.');
  SetReadout('');
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Application.OnException := nil;
  CloseAllEquationSheets;
  tmrPlay.Enabled := False;
  tmrRefDebounce.Enabled := False;
  FHeatMap.Free;
  FSpaceBuffer.Free;
  FSpaceCache.Free;
  FAPGStore.Free;
end;

procedure TForm1.btnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // F5 runs the simulation of the active tab, F1 opens its theory sheet,
  // Esc stops the APP animation
  if Key = VK_F1 then
  begin
    OpenSheet(SheetForActiveTab);
    Key := 0;
  end
  else if Key = VK_F5 then
  begin
    if PageControl1.ActivePage = tsAPG then
      btnRunAPGClick(nil)
    else if PageControl1.ActivePage = tsPhase then
      btnRunAPGClick(nil)
    else if PageControl1.ActivePage = tsRefractory then
      btnRunRefClick(nil)
    else if PageControl1.ActivePage = tsISI then
      btnRunISIClick(nil)
    else if PageControl1.ActivePage = tsAPP then
      btnRunAPPClick(nil);
    Key := 0;
  end
  else if Key = VK_ESCAPE then
    StopPlay;
end;

{ Flat buttons (TPanel) and error log }

procedure TForm1.StyleFlatButton(AButton: TPanel; AKind: TButtonKind);
begin
  AButton.ParentBackground := False;
  AButton.BevelOuter := bvNone;
  AButton.Tag := Ord(AKind);
  AButton.Color := C_BTN_FACE[AKind];
  AButton.Font.Name := 'Segoe UI';
  AButton.Font.Size := 9;
  AButton.Font.Color := C_BTN_TEXT[AKind];
  if AKind = bkSecondary then
    AButton.Font.Style := []
  else
    AButton.Font.Style := [fsBold];
  AButton.Cursor := crHandPoint;
  TControlAccess(AButton).OnMouseEnter := FlatButtonEnter;
  TControlAccess(AButton).OnMouseLeave := FlatButtonLeave;
  TControlAccess(AButton).OnMouseDown := FlatButtonDown;
  TControlAccess(AButton).OnMouseUp := FlatButtonUp;
end;

procedure TForm1.StyleAllButtons;
begin
  StyleFlatButton(btnZoomIn, bkSecondary);
  StyleFlatButton(btnZoomOut, bkSecondary);
  StyleFlatButton(btnZoomReset, bkSecondary);
  StyleFlatButton(btnSavePNG, bkSecondary);
  StyleFlatButton(btnCopyChart, bkSecondary);
  StyleFlatButton(btnExit, bkDanger);
  StyleFlatButton(btnRunAPG, bkPrimary);
  StyleFlatButton(btnExportAPG, bkSecondary);
  StyleFlatButton(btnRunRef, bkPrimary);
  StyleFlatButton(btnExportRef, bkSecondary);
  StyleFlatButton(btnRunISI, bkPrimary);
  StyleFlatButton(btnExportISI, bkSecondary);
  StyleFlatButton(btnRunAPP, bkPrimary);
  StyleFlatButton(btnExportAPP, bkSecondary);
  StyleFlatButton(btnPlay, bkSuccess);
  StyleFlatButton(btnResetModel, bkSecondary);
  StyleFlatButton(btnPresetSquid, bkSecondary);
  StyleFlatButton(btnClearAPG, bkSecondary);
  StyleFlatButton(btnClearPhase, bkSecondary);
  StyleFlatButton(btnClearRef, bkSecondary);
  StyleFlatButton(btnClearISI, bkSecondary);
  StyleFlatButton(btnClearAPP, bkSecondary);
  StyleFlatButton(btnPresetLecturer, bkSecondary);
  StyleFlatButton(btnTheoryAPG, bkInfo);
  StyleFlatButton(btnTheoryPhase, bkInfo);
  StyleFlatButton(btnTheoryRef, bkInfo);
  StyleFlatButton(btnTheoryISI, bkInfo);
  StyleFlatButton(btnSheetCable, bkInfo);
  StyleFlatButton(btnSheetFD, bkInfo);
  StyleFlatButton(btnSheet1, bkInfo);
  StyleFlatButton(btnSheet2, bkInfo);
  StyleFlatButton(btnSheet3, bkInfo);
  StyleFlatButton(btnSheet4, bkInfo);
  StyleFlatButton(btnSheet5, bkInfo);
  StyleFlatButton(btnSheet6, bkInfo);
end;

procedure TForm1.FlatButtonEnter(Sender: TObject);
begin
  if Sender is TPanel then
    TPanel(Sender).Color := C_BTN_HOVER[TButtonKind(TPanel(Sender).Tag)];
end;

procedure TForm1.FlatButtonLeave(Sender: TObject);
begin
  if Sender is TPanel then
    TPanel(Sender).Color := C_BTN_FACE[TButtonKind(TPanel(Sender).Tag)];
end;

procedure TForm1.FlatButtonDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (Sender is TPanel) and (Button = mbLeft) then
    TPanel(Sender).Color := C_BTN_DOWN[TButtonKind(TPanel(Sender).Tag)];
end;

procedure TForm1.FlatButtonUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Sender is TPanel then
    TPanel(Sender).Color := C_BTN_HOVER[TButtonKind(TPanel(Sender).Tag)];
end;

procedure TForm1.AppendLog(const ALevel, AMsg: string);
var
  LLog: TStreamWriter;
begin
  // best effort: logging must never raise a second exception
  try
    LLog := TStreamWriter.Create(FLogFile, True, TEncoding.UTF8);
    try
      LLog.WriteLine(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + ' [' +
        ALevel + '] tab="' + PageControl1.ActivePage.Caption + '" ' + AMsg);
    finally
      LLog.Free;
    end;
  except
    on E: Exception do
      SetStatus('Log file not writable: ' + E.Message);
  end;
end;

procedure TForm1.AppException(Sender: TObject; E: Exception);
var
  LText: string;
  LNow: Cardinal;
begin
  LText := E.ClassName + ': ' + E.Message;
  AppendLog('ERROR', LText);
  SetStatus('Error (logged): ' + LText);
  // a failing repaint would otherwise open one dialog per paint message
  LNow := GetTickCount;
  if (LText <> FLastErrorText) or (LNow - FLastErrorTick > C_ERROR_REPEAT_MS) then
  begin
    FLastErrorText := LText;
    FLastErrorTick := LNow;
    MessageDlg('An unexpected error occurred and was written to' + sLineBreak +
      FLogFile + sLineBreak + sLineBreak + LText, mtError, [mbOK], 0);
  end;
end;

{ Parameter editors (TValueListEditor, Key = Value) }

procedure TForm1.SetupEditor(AEditor: TValueListEditor);
begin
  // column titles and widths are designed in Unit1.dfm
  AEditor.Strings.Clear;
end;

procedure TForm1.AddParam(AEditor: TValueListEditor; const AKey: string;
  const AValue: Double);
begin
  AEditor.Strings.Add(AKey + '=' + FloatToStr(AValue, FFmt));
end;

function TForm1.ParamValue(AEditor: TValueListEditor;
  const AKey: string): Double;
var
  LText: string;
begin
  // Accept both '.' and ',' as decimal separator (Indonesian locale)
  LText := Trim(StringReplace(AEditor.Values[AKey], ',', '.', [rfReplaceAll]));
  if not TryStrToFloat(LText, Result, FFmt) then
    raise EConvertError.CreateFmt('Invalid number "%s" for parameter "%s".',
      [AEditor.Values[AKey], AKey]);
end;

function TForm1.ParamInt(AEditor: TValueListEditor;
  const AKey: string): Integer;
begin
  Result := Round(ParamValue(AEditor, AKey));
end;

procedure TForm1.InitModelEditor;
var
  LParams: THHParams;
begin
  LParams := DefaultHHParams;
  SetupEditor(vleModel);
  AddParam(vleModel, K_GNA, LParams.GNa0);
  AddParam(vleModel, K_GK, LParams.GK0);
  AddParam(vleModel, K_GL, LParams.GL0);
  AddParam(vleModel, K_VNA, LParams.VNa);
  AddParam(vleModel, K_VK, LParams.VK);
  AddParam(vleModel, K_VL, LParams.VL);
  AddParam(vleModel, K_CM, LParams.Cm);
  AddParam(vleModel, K_TEMP, LParams.TempC);
end;

procedure TForm1.InitAPGStore;
begin
  // Values of every APG parameter; only the rows relevant to the selected
  // protocol are shown in vleAPG (see RebuildAPGEditor).
  FAPGStore.Clear;
  FAPGStore.Values[K_JBASE] := '0';
  FAPGStore.Values[K_JLEVEL] := '-10';
  FAPGStore.Values[K_TON] := '1';
  FAPGStore.Values[K_TOFF] := '61';
  FAPGStore.Values[K_JP1] := '-40';
  FAPGStore.Values[K_JP2] := '-40';
  FAPGStore.Values[K_PW] := '0.5';
  FAPGStore.Values[K_PINT] := '15';
  FAPGStore.Values[K_DT] := '0.01';
  FAPGStore.Values[K_TEND] := '70';
  SetupEditor(vleAPG);
end;

procedure TForm1.RebuildAPGEditor;
var
  LKeys: TArray<string>;
  LIdx: Integer;
begin
  // keep what the user typed in the rows that are currently visible
  for LIdx := 0 to vleAPG.Strings.Count - 1 do
    FAPGStore.Values[vleAPG.Strings.Names[LIdx]] :=
      vleAPG.Strings.ValueFromIndex[LIdx];
  case rgProtocol.ItemIndex of
    1:
      LKeys := [K_DT, K_TEND];
    2:
      LKeys := [K_JBASE, K_JP1, K_JP2, K_TON, K_PW, K_PINT, K_DT, K_TEND];
  else
    LKeys := [K_JBASE, K_JLEVEL, K_TON, K_TOFF, K_DT, K_TEND];
  end;
  vleAPG.Strings.BeginUpdate;
  try
    vleAPG.Strings.Clear;
    for LIdx := 0 to High(LKeys) do
      vleAPG.Strings.Add(LKeys[LIdx] + '=' + FAPGStore.Values[LKeys[LIdx]]);
  finally
    vleAPG.Strings.EndUpdate;
  end;
end;

procedure TForm1.InitAPPEditor;
begin
  // Default = the lecturer's setting: a passive 2 mm cable sampled every
  // 0.4 mm and driven at x = 0 by the APG waveform of tab 1. The squid
  // axon (active cable, HH 1952 velocity) is one click away.
  ApplyAPPPreset(LecturerCableParams, C_MODE_PASSIVE, C_DRIVE_APG,
    C_SCHEME_FTCS);
end;

function TForm1.LecturerCableParams: TCableParams;
begin
  // 2 mm cable with dx = 0.4 mm and dt = 10 us as in the lecturer's APP
  // simulation. A radius of 5 um gives a passive length constant of about
  // 1 mm, so the attenuation over 2 mm is of the size shown in the
  // lecturer's result; the HH membrane is unchanged (ISS-023, ISS-029).
  Result := DefaultCableParams;
  Result.RadiusUm := 5.0;
  Result.LengthCm := 0.2;          // 2 mm
  Result.DxCm := 0.04;             // h = 0.4 mm
  Result.Dt := 0.01;               // k = 10 us
  Result.TEnd := 60.0;
  Result.StimLengthCm := 0.04;     // used by the pulse drive only
  Result.PulseCount := 4;
  Result.PulseInterval := 15.0;
end;

procedure TForm1.ApplyAPPPreset(const ACable: TCableParams; AMode, ADrive,
  AScheme: Integer);
begin
  StopPlay;
  FillAPPEditor(ACable, C_SITES_DEFAULT);
  rgCableMode.ItemIndex := AMode;
  rgAPPDrive.ItemIndex := ADrive;
  rgAPPScheme.ItemIndex := AScheme;
end;

procedure TForm1.FillAPPEditor(const ACable: TCableParams; ASites: Integer);
begin
  // lengths are shown in mm; RoundTo removes binary noise of cm * 10
  SetupEditor(vleAPP);
  AddParam(vleAPP, K_CA, ACable.RadiusUm);
  AddParam(vleAPP, K_CRI, ACable.RiOhmCm);
  AddParam(vleAPP, K_CRO, ACable.RoOhmPerCm);
  AddParam(vleAPP, K_CLEN, RoundTo(ACable.LengthCm * C_MM_PER_CM, -6));
  AddParam(vleAPP, K_CDX, RoundTo(ACable.DxCm * C_MM_PER_CM, -6));
  AddParam(vleAPP, K_CDT, ACable.Dt);
  AddParam(vleAPP, K_CTEND, ACable.TEnd);
  AddParam(vleAPP, K_CJ, ACable.StimAmp);
  AddParam(vleAPP, K_CDUR, ACable.StimDur);
  AddParam(vleAPP, K_CSL, RoundTo(ACable.StimLengthCm * C_MM_PER_CM, -6));
  // gm of the passive cable = chord conductance of the resting HH membrane
  AddParam(vleAPP, K_CGM, RoundTo(RestingConductance(DefaultHHParams), -4));
  AddParam(vleAPP, K_CSITES, ASites);
  AddParam(vleAPP, K_CNP, ACable.PulseCount);
  AddParam(vleAPP, K_CPI, ACable.PulseInterval);
end;

procedure TForm1.btnPresetSquidClick(Sender: TObject);
begin
  ApplyAPPPreset(DefaultCableParams, C_MODE_ACTIVE, C_DRIVE_PULSES,
    C_SCHEME_FTCS);
  SetStatus('Preset: squid giant axon, active cable, one current pulse ' +
    '(a = 238 um, 60 mm axon, h = 1 mm). Press Run APP simulation.');
end;

procedure TForm1.btnPresetLecturerClick(Sender: TObject);
begin
  ApplyAPPPreset(LecturerCableParams, C_MODE_PASSIVE, C_DRIVE_APG,
    C_SCHEME_FTCS);
  SetStatus('Preset: lecturer scale, passive cable driven by the APG ' +
    'waveform of tab 1 (2 mm, dx = 0.4 mm, dt = 10 us, 60 ms). Press Run ' +
    'APP simulation.');
end;

function TForm1.ReadModelParams: THHParams;
begin
  Result.GNa0 := ParamValue(vleModel, K_GNA);
  Result.GK0 := ParamValue(vleModel, K_GK);
  Result.GL0 := ParamValue(vleModel, K_GL);
  Result.VNa := ParamValue(vleModel, K_VNA);
  Result.VK := ParamValue(vleModel, K_VK);
  Result.VL := ParamValue(vleModel, K_VL);
  Result.Cm := ParamValue(vleModel, K_CM);
  Result.TempC := ParamValue(vleModel, K_TEMP);
  if Result.Cm <= 0.0 then
    raise EConvertError.Create('Cm must be positive.');
  if (Result.GNa0 < 0.0) or (Result.GK0 < 0.0) or (Result.GL0 < 0.0) then
    raise EConvertError.Create('Conductances must not be negative.');
end;

function TForm1.SelectedMethod: TIntegrator;
begin
  if rgMethod.ItemIndex = 1 then
    Result := imLecturerRK4
  else
    Result := imCoupledRK4;
end;

function TForm1.FloatText(const AValue: Double; const ADigits: Integer): string;
begin
  if IsNan(AValue) then
    Result := 'n/a'
  else
    Result := FloatToStrF(AValue, ffFixed, 15, ADigits, FFmt);
end;

{ Chart styling (series are created at run time; the .dfm only holds charts) }

procedure TForm1.RegisterChart(AChart: TChart; AGroup: Integer);
var
  LCount: Integer;
begin
  // Look and series of the chart come from Unit1.dfm (2D, title, axis
  // titles, legend check boxes, Okabe-Ito colours, OnZoom/OnMouseMove...).
  // Registration adds it to the zoom, export and synchronisation logic.
  LCount := Length(FCharts);
  SetLength(FCharts, LCount + 1);
  FCharts[LCount] := AChart;
  AChart.Tag := AGroup;
  AChart.Zoom.Pen.Color := C_BLUE;
end;

procedure TForm1.FinishChart(AChart: TChart);
var
  LIdx, LShown, LWidth: Integer;
  LSeries: TChartSeries;
  LTitle: string;
begin
  // adaptive line width: thicker for few series, thinner for many
  LShown := 0;
  for LIdx := 0 to AChart.SeriesCount - 1 do
    if AChart.Series[LIdx].ShowInLegend then
      Inc(LShown);
  for LIdx := 0 to AChart.SeriesCount - 1 do
  begin
    LSeries := AChart.Series[LIdx];
    if LSeries.Tag = C_TAG_EMPH then
      LWidth := C_WIDTH_EMPH
    else if LShown <= C_FEW_SERIES then
      LWidth := C_WIDTH_FEW
    else
      LWidth := C_WIDTH_MANY;
    if LSeries is TFastLineSeries then
      TFastLineSeries(LSeries).LinePen.Width := LWidth
    else if LSeries is TLineSeries then
      TLineSeries(LSeries).LinePen.Width := LWidth;
  end;
  // Re-assign every title. TeeChart refreshes the legend text of a series
  // when its title changes (the time-slider entry always updated), while
  // series created by a new run could keep the legend text of the run
  // before (ISS-028).
  for LIdx := 0 to AChart.SeriesCount - 1 do
  begin
    LTitle := AChart.Series[LIdx].Title;
    AChart.Series[LIdx].Title := LTitle + ' ';
    AChart.Series[LIdx].Title := LTitle;
  end;
  AChart.Legend.Visible := False;
  AChart.Legend.Visible := LShown > 1;
  ResetChart(AChart);
  AChart.Invalidate;
end;

procedure TForm1.ClearChart(AChart: TChart);
var
  LIdx: Integer;
begin
  // the series are designed on the form and kept for the life of the
  // program; clearing removes their points only (see also ISS-020)
  for LIdx := 0 to AChart.SeriesCount - 1 do
    AChart.Series[LIdx].Clear;
end;

{ Chart interaction: active target, read-out, zoom, synchronisation, export }

procedure TForm1.SetActiveTarget(AControl: TControl);
begin
  if FActiveTarget = AControl then
    Exit;
  FActiveTarget := AControl;
  if AControl is TChart then
    lblActiveChart.Caption := 'Active chart: ' +
      Trim(TChart(AControl).Title.Text.Text)
  else if AControl = pbSpaceTime then
    lblActiveChart.Caption := 'Active chart: space-time view'
  else
    lblActiveChart.Caption := 'Active chart: none';
end;

procedure TForm1.ChartMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  LChart: TChart;
begin
  // TeeChart may pass a sender that is not the chart itself: never use 'as'
  if not (Sender is TChart) then
    Exit;
  LChart := TChart(Sender);
  SetActiveTarget(LChart);
  if (LChart.SeriesCount > 0) and PtInRect(LChart.ChartRect, Point(X, Y)) then
    SetReadout(Format('%s = %s   |   %s = %s',
      [LChart.BottomAxis.Title.Caption,
       FloatText(LChart.BottomAxis.CalcPosPoint(X), 3),
       LChart.LeftAxis.Title.Caption,
       FloatText(LChart.LeftAxis.CalcPosPoint(Y), 3)]))
  else
    SetReadout('');
end;

procedure TForm1.ChartDblClick(Sender: TObject);
begin
  if Sender is TChart then
    ResetChart(TChart(Sender));
end;

procedure TForm1.ChartZoomed(Sender: TObject);
begin
  if Sender is TChart then
    SyncGroup(TChart(Sender), False);
end;

procedure TForm1.ChartUnzoomed(Sender: TObject);
begin
  if Sender is TChart then
    SyncGroup(TChart(Sender), True);
end;

procedure TForm1.SyncGroup(ASource: TChart; AReset: Boolean);
var
  LIdx: Integer;
  LTarget: TChart;
begin
  // charts of the same group (same Tag > 0) share the time axis
  if FSyncing or (ASource.Tag = C_GROUP_NONE) then
    Exit;
  FSyncing := True;
  try
    for LIdx := 0 to High(FCharts) do
    begin
      LTarget := FCharts[LIdx];
      if (LTarget <> ASource) and (LTarget.Tag = ASource.Tag) and
         (LTarget.SeriesCount > 0) then
      begin
        if AReset then
          LTarget.BottomAxis.Automatic := True
        else
          LTarget.BottomAxis.SetMinMax(ASource.BottomAxis.Minimum,
            ASource.BottomAxis.Maximum);
      end;
    end;
  finally
    FSyncing := False;
  end;
end;

procedure TForm1.ZoomAxis(AAxis: TChartAxis; const AFactor, ACenter: Double);
var
  LMin, LMax: Double;
begin
  LMin := AAxis.Minimum;
  LMax := AAxis.Maximum;
  if LMax <= LMin then
    Exit;
  AAxis.SetMinMax(ACenter + (LMin - ACenter) * AFactor,
    ACenter + (LMax - ACenter) * AFactor);
end;

procedure TForm1.ZoomChart(AChart: TChart; const AFactor: Double;
  AUseCursor: Boolean; const APoint: TPoint; AXOnly: Boolean);
var
  LInside: Boolean;
  LCx, LCy, LCr: Double;
begin
  if AChart.SeriesCount = 0 then
    Exit;
  LInside := AUseCursor and PtInRect(AChart.ChartRect, APoint);
  if LInside then
  begin
    LCx := AChart.BottomAxis.CalcPosPoint(APoint.X);
    LCy := AChart.LeftAxis.CalcPosPoint(APoint.Y);
    LCr := AChart.RightAxis.CalcPosPoint(APoint.Y);
  end
  else
  begin
    LCx := 0.5 * (AChart.BottomAxis.Minimum + AChart.BottomAxis.Maximum);
    LCy := 0.5 * (AChart.LeftAxis.Minimum + AChart.LeftAxis.Maximum);
    LCr := 0.5 * (AChart.RightAxis.Minimum + AChart.RightAxis.Maximum);
  end;
  ZoomAxis(AChart.BottomAxis, AFactor, LCx);
  if not AXOnly then
  begin
    // a logarithmic axis is zoomed by TeeChart itself (drag box) only
    if not AChart.LeftAxis.Logarithmic then
      ZoomAxis(AChart.LeftAxis, AFactor, LCy);
    ZoomAxis(AChart.RightAxis, AFactor, LCr);
  end;
  SyncGroup(AChart, False);
end;

procedure TForm1.ResetChart(AChart: TChart);
begin
  AChart.BottomAxis.Automatic := True;
  AChart.LeftAxis.Automatic := True;
  AChart.RightAxis.Automatic := True;
  AChart.TopAxis.Automatic := True;
  SyncGroup(AChart, True);
end;

procedure TForm1.MouseWheelHandler(var Message: TMessage);
var
  LWin: TWinControl;
  LDelta: SmallInt;
  LKeys: Word;
  LFactor: Double;
begin
  // VCL routes every WM_MOUSEWHEEL of a child control through the form's
  // MouseWheelHandler first. A wheel over a chart is consumed here (zoom at
  // the cursor) so that TeeChart's own wheel scrolling, which raised
  // EInvalidCast through OnScroll (ISS-019), never runs. Any other control
  // (memo, grid, scroll box) keeps the default VCL behaviour.
  LWin := FindVCLWindow(Mouse.CursorPos);
  if LWin is TChart then
  begin
    LDelta := SmallInt(HiWord(Message.WParam));
    LKeys := LoWord(Message.WParam);
    if LDelta > 0 then
      LFactor := C_ZOOM_IN
    else
      LFactor := C_ZOOM_OUT;
    ZoomChart(TChart(LWin), LFactor, True,
      LWin.ScreenToClient(Mouse.CursorPos), (LKeys and MK_SHIFT) <> 0);
    Message.Result := 1;
  end
  else
    inherited MouseWheelHandler(Message);
end;

procedure TForm1.btnZoomInClick(Sender: TObject);
begin
  if FActiveTarget is TChart then
    ZoomChart(TChart(FActiveTarget), C_ZOOM_IN, False, Point(0, 0))
  else
    SetStatus('Move the mouse over a chart to select it, then zoom.');
end;

procedure TForm1.btnZoomOutClick(Sender: TObject);
begin
  if FActiveTarget is TChart then
    ZoomChart(TChart(FActiveTarget), C_ZOOM_OUT, False, Point(0, 0))
  else
    SetStatus('Move the mouse over a chart to select it, then zoom.');
end;

procedure TForm1.btnZoomResetClick(Sender: TObject);
begin
  if FActiveTarget is TChart then
    ResetChart(TChart(FActiveTarget))
  else
    SetStatus('Move the mouse over a chart to select it, then reset.');
end;

function TForm1.RenderActiveTarget: TBitmap;
begin
  // caller owns the returned bitmap
  Result := nil;
  if FActiveTarget is TChart then
  begin
    Result := TBitmap.Create;
    Result.PixelFormat := pf24bit;
    Result.SetSize(FActiveTarget.Width, FActiveTarget.Height);
    TChart(FActiveTarget).Draw(Result.Canvas,
      Rect(0, 0, FActiveTarget.Width, FActiveTarget.Height));
  end
  else if FActiveTarget = pbSpaceTime then
  begin
    Result := TBitmap.Create;
    Result.PixelFormat := pf24bit;
    Result.SetSize(pbSpaceTime.Width, pbSpaceTime.Height);
    DrawSpaceTime(Result.Canvas, pbSpaceTime.Width, pbSpaceTime.Height);
  end;
end;

procedure TForm1.btnSavePNGClick(Sender: TObject);
var
  LBmp: TBitmap;
  LPng: TPngImage;
begin
  LBmp := RenderActiveTarget;
  if LBmp = nil then
  begin
    SetStatus('Move the mouse over a chart to select it, then save.');
    Exit;
  end;
  try
    SaveDialogPNG.FileName := 'chart.png';
    if SaveDialogPNG.Execute then
    begin
      LPng := TPngImage.Create;
      try
        LPng.Assign(LBmp);
        LPng.SaveToFile(SaveDialogPNG.FileName);
      finally
        LPng.Free;
      end;
      SetStatus('Saved ' + SaveDialogPNG.FileName);
    end;
  finally
    LBmp.Free;
  end;
end;

procedure TForm1.btnCopyChartClick(Sender: TObject);
var
  LBmp: TBitmap;
begin
  LBmp := RenderActiveTarget;
  if LBmp = nil then
  begin
    SetStatus('Move the mouse over a chart to select it, then copy.');
    Exit;
  end;
  try
    Clipboard.Assign(LBmp);
    SetStatus('Chart copied to the clipboard.');
  finally
    LBmp.Free;
  end;
end;

procedure TForm1.SetStatus(const AMsg: string);
begin
  StatusBar1.Panels[0].Text := AMsg;
end;

procedure TForm1.SetReadout(const AMsg: string);
begin
  StatusBar1.Panels[1].Text := AMsg;
end;

procedure TForm1.ShowError(const AMsg: string);
begin
  // handled errors (invalid input, unstable scheme, ...) are logged as WARN
  AppendLog('WARN', AMsg);
  SetStatus('Error: ' + AMsg);
  MessageDlg(AMsg, mtError, [mbOK], 0);
end;

procedure TForm1.SaveLines(ALines: TStrings; const ADefaultName: string);
begin
  SaveDialog1.FileName := ADefaultName;
  if SaveDialog1.Execute then
  begin
    ALines.SaveToFile(SaveDialog1.FileName, TEncoding.UTF8);
    SetStatus('Saved ' + SaveDialog1.FileName);
  end;
end;

{ Tab 1 and 2: action potential generation (RK4) and gating phase plots }

procedure TForm1.rgProtocolClick(Sender: TObject);
begin
  if (csLoading in ComponentState) or (FAPGStore = nil) then
    Exit;
  RebuildAPGEditor;
end;

procedure TForm1.BuildAPGStimulus(out AStim: TStimulus);
begin
  // stimulus of tab 1; also used as the source of the APG waveform that
  // drives the cable at x = 0 in tab 5
  AStim := DefaultStimulus;
  case rgProtocol.ItemIndex of
    1:
      AStim.Kind := skLecturerStaircase;
    2:
      begin
        AStim.Kind := skPairedPulse;
        AStim.JBase := ParamValue(vleAPG, K_JBASE);
        AStim.TOn := ParamValue(vleAPG, K_TON);
        AStim.JLevel := ParamValue(vleAPG, K_JP1);
        AStim.JLevel2 := ParamValue(vleAPG, K_JP2);
        AStim.PulseWidth := ParamValue(vleAPG, K_PW);
        AStim.Interval := ParamValue(vleAPG, K_PINT);
        if AStim.PulseWidth <= 0.0 then
          raise EConvertError.Create('Pulse width must be positive.');
        if AStim.Interval < AStim.PulseWidth then
          raise EConvertError.Create(
            'Pulse interval must not be shorter than the pulse width.');
      end;
  else
    AStim.Kind := skStep;
    AStim.JBase := ParamValue(vleAPG, K_JBASE);
    AStim.JLevel := ParamValue(vleAPG, K_JLEVEL);
    AStim.TOn := ParamValue(vleAPG, K_TON);
    AStim.TOff := ParamValue(vleAPG, K_TOFF);
    if AStim.TOff <= AStim.TOn then
      raise EConvertError.Create('t_off must be larger than t_on.');
  end;
end;

procedure TForm1.btnRunAPGClick(Sender: TObject);
var
  LParams: THHParams;
  LStim: TStimulus;
  LDt, LTEnd: Double;
begin
  try
    LParams := ReadModelParams;
    BuildAPGStimulus(LStim);
    LDt := ParamValue(vleAPG, K_DT);
    LTEnd := ParamValue(vleAPG, K_TEND);

    Screen.Cursor := crHourGlass;
    try
      SimulateAPG(LParams, LStim, LDt, LTEnd, SelectedMethod, FAPG);
    finally
      Screen.Cursor := crDefault;
    end;
    FAPGValid := True;
    PlotAPG;
    PlotPhase(LParams);
    ReportAPG(LStim, LDt, LTEnd);
    SetStatus(Format('APG finished: %d samples, %d action potentials.',
      [FAPG.Count, Length(FAPG.SpikeTimes)]));
  except
    on E: Exception do
      ShowError(E.Message);
  end;
end;

procedure TForm1.PlotAPG;
var
  LIdx, LStride: Integer;
begin
  // series of the four APG charts are designed in Unit1.dfm; JL (about
  // +/-25 uA/cm2) is on the right axis because it would be invisible next
  // to JNa and JK (about +/-800 uA/cm2), Jin is on the right axis of chtVm
  ClearChart(chtVm);
  ClearChart(chtCurrents);
  ClearChart(chtGates);
  ClearChart(chtConductance);
  // at most about 8000 points per series keeps TeeChart responsive
  LStride := Max(1, FAPG.Count div 8000);
  LIdx := 0;
  while LIdx < FAPG.Count do
  begin
    serVm.AddXY(FAPG.T[LIdx], FAPG.Vm[LIdx]);
    serJin.AddXY(FAPG.T[LIdx], FAPG.Jin[LIdx]);
    serJNa.AddXY(FAPG.T[LIdx], FAPG.JNa[LIdx]);
    serJK.AddXY(FAPG.T[LIdx], FAPG.JK[LIdx]);
    serJL.AddXY(FAPG.T[LIdx], FAPG.JL[LIdx]);
    serM.AddXY(FAPG.T[LIdx], FAPG.M[LIdx]);
    serH.AddXY(FAPG.T[LIdx], FAPG.H[LIdx]);
    serN.AddXY(FAPG.T[LIdx], FAPG.N[LIdx]);
    serGNa.AddXY(FAPG.T[LIdx], FAPG.GNa[LIdx]);
    serGK.AddXY(FAPG.T[LIdx], FAPG.GK[LIdx]);
    Inc(LIdx, LStride);
  end;
  FinishChart(chtVm);
  FinishChart(chtCurrents);
  FinishChart(chtGates);
  FinishChart(chtConductance);
end;

procedure TForm1.PlotPhase(const AParams: THHParams);
const
  C_VM_FROM = -100.0;   // range of the steady-state curves (mV)
  C_VM_TO = 50.0;
  C_VM_STEP = 0.5;
var
  LIdx, LStride, LCount: Integer;
  LPhi, LVm, LV: Double;
  LRates: THHRates;
begin
  // Phase plots in the style of the senior reference (gate vs Vm), with the
  // steady-state curve x_inf(Vm) for comparison: the loop is the delay of
  // each gate behind x_inf, whose size is set by tau_x(Vm). Trajectories are
  // dots taken at a constant time stride, so the dot spacing shows how fast
  // the state moves (dense = slow recovery, sparse = AP upstroke).
  ClearChart(chtPhaseM);
  ClearChart(chtPhaseH);
  ClearChart(chtPhaseN);
  ClearChart(chtTau);

  LStride := Max(1, FAPG.Count div 4000);
  LIdx := 0;
  while LIdx < FAPG.Count do
  begin
    serTrajM.AddXY(FAPG.Vm[LIdx], FAPG.M[LIdx]);
    serTrajH.AddXY(FAPG.Vm[LIdx], FAPG.H[LIdx]);
    serTrajN.AddXY(FAPG.Vm[LIdx], FAPG.N[LIdx]);
    Inc(LIdx, LStride);
  end;

  LPhi := TemperatureFactor(AParams);
  LCount := Round((C_VM_TO - C_VM_FROM) / C_VM_STEP);
  for LIdx := 0 to LCount do
  begin
    LVm := C_VM_FROM + LIdx * C_VM_STEP;
    LV := V_REST_ABS - LVm;            // HH displacement: v = -(Vm + 70)
    LRates := ComputeRates(LV, LPhi);
    serInfM.AddXY(LVm, LRates.Am / (LRates.Am + LRates.Bm));
    serInfH.AddXY(LVm, LRates.Ah / (LRates.Ah + LRates.Bh));
    serInfN.AddXY(LVm, LRates.An / (LRates.An + LRates.Bn));
    serTauM.AddXY(LVm, 1.0 / (LRates.Am + LRates.Bm));
    serTauH.AddXY(LVm, 1.0 / (LRates.Ah + LRates.Bh));
    serTauN.AddXY(LVm, 1.0 / (LRates.An + LRates.Bn));
  end;
  FinishChart(chtPhaseM);
  FinishChart(chtPhaseH);
  FinishChart(chtPhaseN);
  FinishChart(chtTau);
end;

procedure TForm1.ReportAPG(const AStim: TStimulus; const ADt, ATEnd: Double);
var
  LLines: TStrings;
  LIdx, LCount: Integer;
  LSpan: Double;
begin
  LLines := memAPG.Lines;
  LLines.BeginUpdate;
  try
    LLines.Clear;
    case AStim.Kind of
      skStep:
        LLines.Add(Format('Protocol : step %s uA/cm2, %s-%s ms (baseline %s)',
          [FloatText(AStim.JLevel, 2), FloatText(AStim.TOn, 2),
           FloatText(AStim.TOff, 2), FloatText(AStim.JBase, 2)]));
      skLecturerStaircase:
        LLines.Add('Protocol : lecturer staircase -5/-10/-20/0 uA/cm2 ' +
          '(0-25/25-38/38-50/>50 ms)');
      skPairedPulse:
        LLines.Add(Format('Protocol : paired pulse J1=%s, J2=%s uA/cm2, ' +
          'width %s ms, interval %s ms',
          [FloatText(AStim.JLevel, 2), FloatText(AStim.JLevel2, 2),
           FloatText(AStim.PulseWidth, 2), FloatText(AStim.Interval, 2)]));
    end;
    if SelectedMethod = imCoupledRK4 then
      LLines.Add('Method   : coupled RK4 on [v, m, h, n]')
    else
      LLines.Add('Method   : lecturer sequential RK4');
    LLines.Add(Format('dt = %s ms, T = %s ms, rest Vm = %s mV',
      [FloatText(ADt, 4), FloatText(ATEnd, 1), FloatText(FAPG.Vm[0], 2)]));
    LCount := Length(FAPG.SpikeTimes);
    LLines.Add(Format('Action potentials (Vm crosses 0 mV): %d', [LCount]));
    if LCount > 0 then
    begin
      LLines.Add(' #   t_cross(ms)  t_peak(ms)  Vpeak(mV)  ISI(ms)');
      for LIdx := 0 to LCount - 1 do
        if LIdx = 0 then
          LLines.Add(Format('%2d   %9s   %9s   %8s      -',
            [LIdx + 1, FloatText(FAPG.SpikeCross[LIdx], 2),
             FloatText(FAPG.SpikeTimes[LIdx], 2),
             FloatText(FAPG.SpikePeaks[LIdx], 2)]))
        else
          LLines.Add(Format('%2d   %9s   %9s   %8s  %7s',
            [LIdx + 1, FloatText(FAPG.SpikeCross[LIdx], 2),
             FloatText(FAPG.SpikeTimes[LIdx], 2),
             FloatText(FAPG.SpikePeaks[LIdx], 2),
             FloatText(FAPG.SpikeTimes[LIdx] - FAPG.SpikeTimes[LIdx - 1], 2)]));
      if LCount > 1 then
      begin
        LSpan := FAPG.SpikeTimes[LCount - 1] - FAPG.SpikeTimes[0];
        LLines.Add(Format('Mean ISI = %s ms  ->  mean frequency = %s Hz',
          [FloatText(LSpan / (LCount - 1), 3),
           FloatText(1000.0 * (LCount - 1) / LSpan, 2)]));
      end;
    end;
    if AStim.Kind = skPairedPulse then
    begin
      if LCount >= 2 then
        LLines.Add('Second pulse produced an action potential (outside the ' +
          'refractory period).')
      else
        LLines.Add('Second pulse did NOT produce an action potential: the ' +
          'membrane is refractory at this interval/amplitude.');
    end;
  finally
    LLines.EndUpdate;
  end;
end;

procedure TForm1.btnExportAPGClick(Sender: TObject);
var
  LList: TStringList;
  LIdx: Integer;
begin
  if not FAPGValid then
  begin
    ShowError('Run the APG simulation first.');
    Exit;
  end;
  LList := TStringList.Create;
  try
    LList.Add('t_ms,Jin_uA_cm2,Vm_mV,v_HH_mV,JNa,JK,JL,m,h,n,gNa_mS_cm2,gK_mS_cm2');
    for LIdx := 0 to FAPG.Count - 1 do
      LList.Add(Format('%.4f,%.4f,%.5f,%.5f,%.5f,%.5f,%.5f,%.6f,%.6f,%.6f,%.5f,%.5f',
        [FAPG.T[LIdx], FAPG.Jin[LIdx], FAPG.Vm[LIdx], FAPG.V[LIdx],
         FAPG.JNa[LIdx], FAPG.JK[LIdx], FAPG.JL[LIdx], FAPG.M[LIdx],
         FAPG.H[LIdx], FAPG.N[LIdx], FAPG.GNa[LIdx], FAPG.GK[LIdx]], FFmt));
    SaveLines(LList, 'APG_result.csv');
  finally
    LList.Free;
  end;
end;

{ Tab 3: refractory period (paired-pulse threshold sweep) }

function TForm1.RefExampleInterval: Double;
begin
  // track bar positions are half-milliseconds
  Result := 0.5 * tbRefInterval.Position;
end;

procedure TForm1.tbRefIntervalChange(Sender: TObject);
begin
  // OnChange may fire while the form is still being streamed from the .dfm
  if csLoading in ComponentState then
    Exit;
  lblRefInterval.Caption := Format('Example interval (track bar): %s ms',
    [FloatText(RefExampleInterval, 1)]);
  // restart the debounce timer: the example runs when the slider stops
  tmrRefDebounce.Enabled := False;
  tmrRefDebounce.Enabled := Sender <> nil;
end;

procedure TForm1.tmrRefDebounceTimer(Sender: TObject);
begin
  tmrRefDebounce.Enabled := False;
  RunRefExample;
end;

procedure TForm1.btnRunRefClick(Sender: TObject);
var
  LParams: THHParams;
  LJ1, LWidth, LI0, LI1, LStep, LJMax, LDt, LPeak, LSign: Double;
  LCount, LIdx, LAbsIdx, LRelIdx: Integer;
  LLines: TStrings;
begin
  if FBusy then
    Exit;
  FBusy := True;
  try
    LParams := ReadModelParams;
    LJ1 := ParamValue(vleRef, K_RJ1);
    LWidth := ParamValue(vleRef, K_RPW);
    LI0 := ParamValue(vleRef, K_RI0);
    LI1 := ParamValue(vleRef, K_RI1);
    LStep := ParamValue(vleRef, K_RIS);
    LJMax := Abs(ParamValue(vleRef, K_RJMAX));
    LDt := ParamValue(vleRef, K_DT);
    if (LWidth <= 0.0) or (LStep <= 0.0) or (LI1 < LI0) or (LI0 < LWidth) then
      raise EConvertError.Create('Require width > 0, step > 0, ' +
        'interval start >= width and interval end >= interval start.');
    if LJ1 < 0.0 then
      LSign := -1.0
    else
      LSign := 1.0;
    LCount := Floor((LI1 - LI0) / LStep + 1.0E-9) + 1;
    SetLength(FRefInterval, LCount);
    SetLength(FRefThreshold, LCount);
    SetLength(FRefPeak, LCount);

    Screen.Cursor := crHourGlass;
    try
      FRefBaseline := SinglePulseThreshold(LParams, LSign, LWidth, LJMax, LDt,
        SelectedMethod);
      for LIdx := 0 to LCount - 1 do
      begin
        FRefInterval[LIdx] := LI0 + LIdx * LStep;
        FRefThreshold[LIdx] := SecondPulseThreshold(LParams, LJ1, LWidth,
          FRefInterval[LIdx], LJMax, LDt, SelectedMethod);
        if SecondSpikeOccurs(LParams, LJ1, LJ1, LWidth, FRefInterval[LIdx],
          LDt, SelectedMethod, LPeak) then
          FRefPeak[LIdx] := LPeak
        else
          FRefPeak[LIdx] := NaN;
        SetStatus(Format('Refractory sweep %d / %d', [LIdx + 1, LCount]));
        Application.ProcessMessages;
      end;
    finally
      Screen.Cursor := crDefault;
    end;

    ClearChart(chtRefThreshold);
    for LIdx := 0 to LCount - 1 do
    begin
      if IsNan(FRefThreshold[LIdx]) then
        serRefThr.AddNullXY(FRefInterval[LIdx], 0)
      else
        serRefThr.AddXY(FRefInterval[LIdx], FRefThreshold[LIdx]);
      if IsNan(FRefPeak[LIdx]) then
        serRefPeak.AddNullXY(FRefInterval[LIdx], 0)
      else
        serRefPeak.AddXY(FRefInterval[LIdx], FRefPeak[LIdx]);
    end;
    if not IsNan(FRefBaseline) then
    begin
      serRefBase.AddXY(FRefInterval[0], FRefBaseline);
      serRefBase.AddXY(FRefInterval[LCount - 1], FRefBaseline);
    end;
    FinishChart(chtRefThreshold);

    // absolute refractory: no response up to JMax;
    // relative refractory ends when threshold <= 105 % of the rested value
    LAbsIdx := -1;
    for LIdx := 0 to LCount - 1 do
      if IsNan(FRefThreshold[LIdx]) then
        LAbsIdx := LIdx;
    LRelIdx := -1;
    LIdx := LAbsIdx + 1;
    while (LRelIdx < 0) and (LIdx < LCount) do
    begin
      if (not IsNan(FRefThreshold[LIdx])) and (not IsNan(FRefBaseline)) and
         (FRefThreshold[LIdx] <= 1.05 * FRefBaseline) then
        LRelIdx := LIdx;
      Inc(LIdx);
    end;

    LLines := memRef.Lines;
    LLines.BeginUpdate;
    try
      LLines.Clear;
      LLines.Add(Format('Conditioning pulse J1 = %s uA/cm2, width = %s ms',
        [FloatText(LJ1, 2), FloatText(LWidth, 3)]));
      LLines.Add(Format('Rested single-pulse threshold = %s uA/cm2',
        [FloatText(FRefBaseline, 3)]));
      if LAbsIdx >= 0 then
        LLines.Add(Format('Absolute refractory: no AP up to |J2| = %s for ' +
          'intervals <= %s ms', [FloatText(LJMax, 0),
          FloatText(FRefInterval[LAbsIdx], 2)]))
      else
        LLines.Add('No absolute refractory interval inside the sweep range.');
      if LRelIdx >= 0 then
        LLines.Add(Format('Relative refractory ends at about %s ms ' +
          '(threshold <= 1.05 x rested)', [FloatText(FRefInterval[LRelIdx], 2)]))
      else
        LLines.Add('Threshold did not recover to 1.05 x rested in the range.');
      LLines.Add('');
      LLines.Add(' interval(ms)  |J2|thr(uA/cm2)  thr/rested  peak2(J2=J1)');
      for LIdx := 0 to LCount - 1 do
        if IsNan(FRefThreshold[LIdx]) or IsNan(FRefBaseline) then
          LLines.Add(Format('%10s   %12s   %9s   %8s',
            [FloatText(FRefInterval[LIdx], 2), FloatText(FRefThreshold[LIdx], 3),
             'n/a', FloatText(FRefPeak[LIdx], 2)]))
        else
          LLines.Add(Format('%10s   %12s   %9s   %8s',
            [FloatText(FRefInterval[LIdx], 2), FloatText(FRefThreshold[LIdx], 3),
             FloatText(FRefThreshold[LIdx] / FRefBaseline, 3),
             FloatText(FRefPeak[LIdx], 2)]));
    finally
      LLines.EndUpdate;
    end;
    SetStatus('Refractory sweep finished. Move the track bar to inspect ' +
      'single intervals.');
  except
    on E: Exception do
      ShowError(E.Message);
  end;
  FBusy := False;
  RunRefExample;
end;

procedure TForm1.RunRefExample;
var
  LParams: THHParams;
  LStim: TStimulus;
  LResult: TAPGResult;
  LJ1, LWidth, LInterval, LJMax, LDt, LThr, LSign, LTEnd: Double;

  procedure PlotTrace(ASlot: Integer; const ATitle: string);
  var
    LSeries: TFastLineSeries;
    LIdx: Integer;
  begin
    // the three series are permanent; only their points and titles change
    LSeries := FRefExSeries[ASlot];
    LSeries.BeginUpdate;
    try
      LSeries.Clear;
      for LIdx := 0 to LResult.Count - 1 do
        LSeries.AddXY(LResult.T[LIdx], LResult.Vm[LIdx]);
    finally
      LSeries.EndUpdate;
    end;
    LSeries.Title := ATitle;
    LSeries.Active := True;
  end;

begin
  if FBusy then
    Exit;
  FBusy := True;
  try
    LParams := ReadModelParams;
    LJ1 := ParamValue(vleRef, K_RJ1);
    LWidth := ParamValue(vleRef, K_RPW);
    LInterval := RefExampleInterval;
    LJMax := Abs(ParamValue(vleRef, K_RJMAX));
    LDt := ParamValue(vleRef, K_DT);
    if (LWidth <= 0.0) or (LInterval < LWidth) then
      raise EConvertError.Create('Require width > 0 and interval >= width.');
    if LJ1 < 0.0 then
      LSign := -1.0
    else
      LSign := 1.0;
    LTEnd := 1.0 + LInterval + 20.0;

    LStim := DefaultStimulus;
    LStim.Kind := skPairedPulse;
    LStim.TOn := 1.0;
    LStim.JLevel := LJ1;
    LStim.PulseWidth := LWidth;
    LStim.Interval := LInterval;

    Screen.Cursor := crHourGlass;
    try
      LStim.JLevel2 := 0.0;
      SimulateAPG(LParams, LStim, LDt, LTEnd, SelectedMethod, LResult);
      PlotTrace(0, 'Conditioning pulse only');

      LStim.JLevel2 := LJ1;
      SimulateAPG(LParams, LStim, LDt, LTEnd, SelectedMethod, LResult);
      PlotTrace(1, Format('Test pulse J2 = J1 = %s', [FloatText(LJ1, 1)]));

      LThr := SecondPulseThreshold(LParams, LJ1, LWidth, LInterval, LJMax, LDt,
        SelectedMethod);
      if not IsNan(LThr) then
      begin
        LStim.JLevel2 := LSign * 1.05 * LThr;
        SimulateAPG(LParams, LStim, LDt, LTEnd, SelectedMethod, LResult);
        PlotTrace(2, Format('Test pulse J2 = 1.05 x threshold = %s',
          [FloatText(LStim.JLevel2, 1)]));
        SetStatus(Format('Interval %s ms: test-pulse threshold = %s uA/cm2',
          [FloatText(LInterval, 2), FloatText(LThr, 3)]));
      end
      else
      begin
        // absolute refractory: keep the legend entry, hide the series
        FRefExSeries[2].Clear;
        FRefExSeries[2].Title := Format('No AP up to |J2| = %s ' +
          '(absolute refractory)', [FloatText(LJMax, 0)]);
        FRefExSeries[2].Active := False;
        SetStatus(Format('Interval %s ms lies in the absolute refractory ' +
          'period (no AP up to |J2| = %s).', [FloatText(LInterval, 2),
          FloatText(LJMax, 0)]));
      end;
    finally
      Screen.Cursor := crDefault;
    end;
    FinishChart(chtRefExample);
  except
    on E: Exception do
      ShowError(E.Message);
  end;
  FBusy := False;
end;

procedure TForm1.btnExportRefClick(Sender: TObject);
var
  LList: TStringList;
  LIdx: Integer;
begin
  if Length(FRefInterval) = 0 then
  begin
    ShowError('Run the refractory sweep first.');
    Exit;
  end;
  LList := TStringList.Create;
  try
    LList.Add('interval_ms,threshold_abs_J2_uA_cm2,rested_threshold,peak2_mV');
    for LIdx := 0 to High(FRefInterval) do
      LList.Add(FloatText(FRefInterval[LIdx], 3) + ',' +
        FloatText(FRefThreshold[LIdx], 4) + ',' + FloatText(FRefBaseline, 4) +
        ',' + FloatText(FRefPeak[LIdx], 3));
    SaveLines(LList, 'Refractory_sweep.csv');
  finally
    LList.Free;
  end;
end;

{ Tab 4: C-F converter, Jin level versus inter-pulse interval }

procedure TForm1.btnRunISIClick(Sender: TObject);
var
  LParams: THHParams;
  LJ0, LJ1, LJStep, LTRun, LTDis, LDt, LJ, LISI: Double;
  LCount, LIdx, LSpikes, LRheo, LRep, LBlock, LK: Integer;
  LStim: TStimulus;
  LResult: TAPGResult;
  LLines: TStrings;
  LTraceJ: array[0..2] of Double;
  LSeries: TFastLineSeries;
begin
  if FBusy then
    Exit;
  FBusy := True;
  try
    LParams := ReadModelParams;
    LJ0 := ParamValue(vleISI, K_IJ0);
    LJ1 := ParamValue(vleISI, K_IJ1);
    LJStep := Abs(ParamValue(vleISI, K_IJS));
    LTRun := ParamValue(vleISI, K_ITR);
    LTDis := ParamValue(vleISI, K_IDIS);
    LDt := ParamValue(vleISI, K_DT);
    if (LJStep <= 0.0) or (LTRun <= LTDis) or (LTDis < 0.0) then
      raise EConvertError.Create('Require step > 0 and 0 <= discard < run time.');
    LCount := Floor(Abs(LJ1 - LJ0) / LJStep + 1.0E-9) + 1;
    if LCount > 2000 then
      raise EConvertError.Create('Too many Jin levels (> 2000).');
    SetLength(FISIJin, LCount);
    SetLength(FISIValue, LCount);
    SetLength(FISICount, LCount);

    Screen.Cursor := crHourGlass;
    try
      for LIdx := 0 to LCount - 1 do
      begin
        LJ := LJ0 + Sign(LJ1 - LJ0) * LIdx * LJStep;
        FISIJin[LIdx] := LJ;
        SteadyFiring(LParams, LJ, LDt, LTRun, LTDis, SelectedMethod, LSpikes,
          LISI);
        FISICount[LIdx] := LSpikes;
        FISIValue[LIdx] := LISI;
        if (LIdx mod 5) = 0 then
        begin
          SetStatus(Format('Jin sweep %d / %d', [LIdx + 1, LCount]));
          Application.ProcessMessages;
        end;
      end;
    finally
      Screen.Cursor := crDefault;
    end;

    ClearChart(chtISI);
    for LIdx := 0 to LCount - 1 do
      if IsNan(FISIValue[LIdx]) then
      begin
        serISI.AddNullXY(Abs(FISIJin[LIdx]), 0);
        serFreq.AddNullXY(Abs(FISIJin[LIdx]), 0);
      end
      else
      begin
        serISI.AddXY(Abs(FISIJin[LIdx]), FISIValue[LIdx]);
        serFreq.AddXY(Abs(FISIJin[LIdx]), 1000.0 / FISIValue[LIdx]);
      end;
    FinishChart(chtISI);

    // example spike trains, coloured by |Jin| (ordered palette)
    LTraceJ[0] := ParamValue(vleISI, K_ITA);
    LTraceJ[1] := ParamValue(vleISI, K_ITB);
    LTraceJ[2] := ParamValue(vleISI, K_ITC);
    ClearChart(chtISITraces);
    for LK := 0 to 2 do
    begin
      LStim := DefaultStimulus;
      LStim.Kind := skStep;
      LStim.JLevel := LTraceJ[LK];
      LStim.TOn := 0.0;
      LStim.TOff := LTRun + 1.0;
      SimulateAPG(LParams, LStim, LDt, Min(LTRun, 100.0), SelectedMethod,
        LResult);
      LSeries := FTraceSeries[LK];
      LSeries.Title := Format('Jin = %s uA/cm2', [FloatText(LTraceJ[LK], 1)]);
      LIdx := 0;
      while LIdx < LResult.Count do
      begin
        LSeries.AddXY(LResult.T[LIdx], LResult.Vm[LIdx]);
        Inc(LIdx, Max(1, LResult.Count div 6000));
      end;
    end;
    FinishChart(chtISITraces);

    // summary: first AP, onset of repetitive firing, depolarization block
    LRheo := -1;
    LRep := -1;
    LBlock := -1;
    for LIdx := 0 to LCount - 1 do
    begin
      if (LRheo < 0) and (FISICount[LIdx] >= 1) then
        LRheo := LIdx;
      if (LRep < 0) and (not IsNan(FISIValue[LIdx])) then
        LRep := LIdx;
      if (LRep >= 0) and (LBlock < 0) and (LIdx > LRep) and
         IsNan(FISIValue[LIdx]) then
        LBlock := LIdx;
    end;
    LLines := memISI.Lines;
    LLines.BeginUpdate;
    try
      LLines.Clear;
      LLines.Add(Format('Constant Jin applied from t = 0; ISI averaged after %s ms.',
        [FloatText(LTDis, 1)]));
      if LRheo >= 0 then
        LLines.Add(Format('First Jin with at least one AP     : %s uA/cm2',
          [FloatText(FISIJin[LRheo], 2)]));
      if LRep >= 0 then
        LLines.Add(Format('Onset of repetitive (tonic) firing : %s uA/cm2',
          [FloatText(FISIJin[LRep], 2)]));
      if LBlock >= 0 then
        LLines.Add(Format('Repetitive firing lost (block) at  : %s uA/cm2',
          [FloatText(FISIJin[LBlock], 2)]));
      LLines.Add('');
      LLines.Add('  Jin(uA/cm2)  spikes   ISI(ms)   f(Hz)');
      for LIdx := 0 to LCount - 1 do
        if IsNan(FISIValue[LIdx]) then
          LLines.Add(Format('%11s  %6d   %7s   %6s',
            [FloatText(FISIJin[LIdx], 2), FISICount[LIdx], 'n/a', 'n/a']))
        else
          LLines.Add(Format('%11s  %6d   %7s   %6s',
            [FloatText(FISIJin[LIdx], 2), FISICount[LIdx],
             FloatText(FISIValue[LIdx], 3),
             FloatText(1000.0 / FISIValue[LIdx], 2)]));
    finally
      LLines.EndUpdate;
    end;
    SetStatus('Jin sweep finished.');
  except
    on E: Exception do
      ShowError(E.Message);
  end;
  FBusy := False;
end;

procedure TForm1.btnExportISIClick(Sender: TObject);
var
  LList: TStringList;
  LIdx: Integer;
begin
  if Length(FISIJin) = 0 then
  begin
    ShowError('Run the Jin sweep first.');
    Exit;
  end;
  LList := TStringList.Create;
  try
    LList.Add('Jin_uA_cm2,spike_count,mean_ISI_ms,frequency_Hz');
    for LIdx := 0 to High(FISIJin) do
      if IsNan(FISIValue[LIdx]) then
        LList.Add(FloatText(FISIJin[LIdx], 3) + ',' +
          IntToStr(FISICount[LIdx]) + ',n/a,n/a')
      else
        LList.Add(FloatText(FISIJin[LIdx], 3) + ',' +
          IntToStr(FISICount[LIdx]) + ',' + FloatText(FISIValue[LIdx], 4) +
          ',' + FloatText(1000.0 / FISIValue[LIdx], 4));
    SaveLines(LList, 'Jin_vs_ISI.csv');
  finally
    LList.Free;
  end;
end;

{ Tab 5: action potential propagation (cable equation, FTCS or Crank-Nicolson) }

procedure TForm1.btnRunAPPClick(Sender: TObject);
var
  LParams: THHParams;
  LCable: TCableParams;
  LSites: Integer;
  LStim: TStimulus;
  LDrive: TAPGResult;
begin
  StopPlay;
  try
    LParams := ReadModelParams;
    LCable := DefaultCableParams;
    LCable.RadiusUm := ParamValue(vleAPP, K_CA);
    LCable.RiOhmCm := ParamValue(vleAPP, K_CRI);
    LCable.RoOhmPerCm := ParamValue(vleAPP, K_CRO);
    LCable.LengthCm := ParamValue(vleAPP, K_CLEN) / C_MM_PER_CM;
    LCable.DxCm := ParamValue(vleAPP, K_CDX) / C_MM_PER_CM;
    LCable.Dt := ParamValue(vleAPP, K_CDT);
    LCable.TEnd := ParamValue(vleAPP, K_CTEND);
    LCable.StimAmp := ParamValue(vleAPP, K_CJ);
    LCable.StimDur := ParamValue(vleAPP, K_CDUR);
    LCable.StimLengthCm := ParamValue(vleAPP, K_CSL) / C_MM_PER_CM;
    LCable.GmPassive := ParamValue(vleAPP, K_CGM);
    LSites := EnsureRange(ParamInt(vleAPP, K_CSITES), 2, C_MAX_SITES);
    LCable.PulseCount := ParamInt(vleAPP, K_CNP);
    LCable.PulseInterval := ParamValue(vleAPP, K_CPI);
    if rgCableMode.ItemIndex = C_MODE_PASSIVE then
      LCable.Mode := cmPassive
    else
      LCable.Mode := cmActiveHH;
    if rgAPPScheme.ItemIndex = C_SCHEME_CN then
      LCable.Scheme := csCrankNicolson
    else
      LCable.Scheme := csExplicitFTCS;
    if rgAPPDrive.ItemIndex = C_DRIVE_APG then
    begin
      // APG waveform of the tab-1 protocol, computed with the cable time
      // step so that sample n belongs to t = n k
      LCable.Drive := cdVoltageTrace;
      BuildAPGStimulus(LStim);
      SimulateAPG(LParams, LStim, LCable.Dt, LCable.TEnd, SelectedMethod, LDrive);
      LCable.DriveV := Copy(LDrive.V);
    end
    else
      LCable.Drive := cdCurrentPulses;
    // keep roughly 600 stored frames for plotting and animation
    LCable.SaveEvery := Max(1, Round(LCable.TEnd / LCable.Dt) div 600);

    Screen.Cursor := crHourGlass;
    try
      SimulateCable(LParams, LCable, FCable);
    finally
      Screen.Cursor := crDefault;
    end;
    Inc(FCableRunId);   // invalidates the cached 3D surface

    if not FCable.Stable then
    begin
      FCableValid := False;
      RefreshSpaceTime;
      ShowError(Format('Explicit scheme unstable: r = k/((ro+ri) cm h^2) = %s ' +
        '> 0.5. Use k <= %s ms or a larger h (mm).', [FloatText(FCable.R, 3),
        FloatText(0.5 * Sqr(LCable.DxCm) / FCable.D, 5)]));
      Exit;
    end;
    FCableValid := True;
    FAPPFrame := 0;
    PlotCable(LSites);
    BuildHeatMap;
    ReportCable(LCable);
    tbAPPTime.Max := Max(1, FCable.NSaved - 1);
    tbAPPTime.Position := 0;
    UpdateAPPFrame;
    SetStatus(Format('APP finished: %d nodes, %d frames. Press Play or move ' +
      'the time slider.', [FCable.NNodes, FCable.NSaved]));
  except
    on E: Exception do
      ShowError(E.Message);
  end;
end;

procedure TForm1.PlotCable(ASites: Integer);
var
  LSeries: TFastLineSeries;
  LIdx, LK, LNode, LFrame: Integer;
begin
  ClearChart(chtAPPTime);
  ClearChart(chtAPPSpace);
  // a coarse grid cannot have more distinct recording sites than nodes;
  // the form holds C_MAX_SITES site and snapshot series, unused ones hide
  ASites := Min(ASites, FCable.NNodes);
  for LIdx := 0 to C_MAX_SITES - 1 do
  begin
    FSiteSeries[LIdx].Active := LIdx < ASites;
    FSiteSeries[LIdx].ShowInLegend := LIdx < ASites;
    FSnapSeries[LIdx].Active := LIdx < ASites;
    FSnapSeries[LIdx].ShowInLegend := LIdx < ASites;
  end;
  // Vm(t) at evenly spaced recording sites, coloured by position
  for LIdx := 0 to ASites - 1 do
  begin
    LNode := Round(LIdx * (FCable.NNodes - 1) / (ASites - 1));
    LSeries := FSiteSeries[LIdx];
    LSeries.Title := Format('x = %s mm',
      [FloatText(FCable.X[LNode] * C_MM_PER_CM, 2)]);
    LSeries.SeriesColor := OrderedLineColor(LIdx, ASites);
    for LK := 0 to FCable.NSaved - 1 do
      LSeries.AddXY(FCable.T[LK], FCable.Vm[LK][LNode]);
  end;
  // serTimeCursor (vertical line, not in the legend) is set in UpdateAPPFrame
  FinishChart(chtAPPTime);

  // Vm(x) at evenly spaced instants (thin, coloured by time) + live profile
  for LIdx := 1 to ASites do
  begin
    LFrame := Round(LIdx * (FCable.NSaved - 1) / (ASites + 1));
    LSeries := FSnapSeries[LIdx - 1];
    LSeries.Title := Format('t = %s ms', [FloatText(FCable.T[LFrame], 2)]);
    LSeries.SeriesColor := OrderedLineColor(LIdx - 1, ASites);
    for LK := 0 to FCable.NNodes - 1 do
      LSeries.AddXY(FCable.X[LK] * C_MM_PER_CM, FCable.Vm[LFrame][LK]);
  end;
  FinishChart(chtAPPSpace);
end;

procedure TForm1.ReportCable(const AParams: TCableParams);
var
  LLines: TStrings;
  LIdx, LNode, LPrev: Integer;
begin
  LLines := memAPP.Lines;
  LLines.BeginUpdate;
  try
    LLines.Clear;
    if AParams.Mode = cmActiveHH then
      LLines.Add('Mode: ACTIVE cable (HH membrane at every node)')
    else
      LLines.Add(Format('Mode: PASSIVE RC cable (gm = %s mS/cm2)',
        [FloatText(AParams.GmPassive, 4)]));
    if AParams.Drive = cdVoltageTrace then
      LLines.Add('Excitation: APG waveform of tab 1 imposed at x = 0')
    else
      LLines.Add(Format('Excitation: %d current pulse(s) of %s uA/cm2, %s ms ' +
        'every %s ms', [AParams.PulseCount, FloatText(AParams.StimAmp, 1),
        FloatText(AParams.StimDur, 2), FloatText(AParams.PulseInterval, 2)]));
    if AParams.Scheme = csCrankNicolson then
      LLines.Add('Scheme: Crank-Nicolson (diffusion), explicit membrane term')
    else
      LLines.Add('Scheme: explicit FTCS (central in x, forward in t)');
    LLines.Add(Format('ri = %s ohm/cm, cm = %s uF/cm',
      [FloatText(FCable.RiPerLen, 1), FloatText(FCable.CmPerLen, 5)]));
    LLines.Add(Format('D = 1/((ro+ri) cm) = %s cm2/ms', [FloatText(FCable.D, 5)]));
    if AParams.Scheme = csCrankNicolson then
      LLines.Add(Format('r = D k / h^2 = %s (no stability limit)',
        [FloatText(FCable.R, 4)]))
    else
      LLines.Add(Format('r = D k / h^2 = %s (stable, limit 0.5)',
        [FloatText(FCable.R, 4)]));
    LLines.Add(Format('Passive length constant lambda = %s mm',
      [FloatText(FCable.LambdaCm * C_MM_PER_CM, 4)]));
    LLines.Add(Format('Conduction velocity (25%%-75%% of length) = %s m/s',
      [FloatText(FCable.VelocityMs, 3)]));
    LLines.Add('');
    LLines.Add('   x(mm)   peak Vm(mV)   t(Vm=0 mV)(ms)');
    { Up to 11 evenly spaced nodes; a short cable (for example the 6 nodes
      of the lecturer preset) has fewer, so a node already listed is skipped }
    LPrev := -1;
    for LIdx := 0 to 10 do
    begin
      LNode := Round(LIdx * (FCable.NNodes - 1) / 10);
      if LNode = LPrev then
        Continue;
      LPrev := LNode;
      LLines.Add(Format('%7s   %10s   %12s',
        [FloatText(FCable.X[LNode] * C_MM_PER_CM, 2),
        FloatText(FCable.PeakVm[LNode], 2), FloatText(FCable.TCross[LNode], 3)]));
    end;
  finally
    LLines.EndUpdate;
  end;
end;

procedure TForm1.UpdateAPPFrame;
var
  LIdx: Integer;
  LTime: Double;
begin
  if not FCableValid then
    Exit;
  FAPPFrame := EnsureRange(tbAPPTime.Position, 0, FCable.NSaved - 1);
  LTime := FCable.T[FAPPFrame];
  lblAPPTime.Caption := Format('t = %s ms', [FloatText(LTime, 2)]);
  serLiveProfile.BeginUpdate;
  try
    serLiveProfile.Clear;
    for LIdx := 0 to FCable.NNodes - 1 do
      serLiveProfile.AddXY(FCable.X[LIdx] * C_MM_PER_CM,
        FCable.Vm[FAPPFrame][LIdx]);
    serLiveProfile.Title := Format('time slider: t = %s ms',
      [FloatText(LTime, 2)]);
  finally
    serLiveProfile.EndUpdate;
  end;
  serTimeCursor.Clear;
  serTimeCursor.AddXY(LTime, C_VM_LO - 10.0);
  serTimeCursor.AddXY(LTime, C_VM_HI + 10.0);
  RefreshSpaceTime;
end;

procedure TForm1.tbAPPTimeChange(Sender: TObject);
begin
  if csLoading in ComponentState then
    Exit;
  UpdateAPPFrame;
end;

procedure TForm1.StopPlay;
begin
  tmrPlay.Enabled := False;
  btnPlay.Caption := 'Play';
  StyleFlatButton(btnPlay, bkSuccess);
end;

procedure TForm1.btnPlayClick(Sender: TObject);
begin
  if not FCableValid then
  begin
    SetStatus('Run the APP simulation first.');
    Exit;
  end;
  if tmrPlay.Enabled then
    StopPlay
  else
  begin
    if tbAPPTime.Position >= tbAPPTime.Max then
      tbAPPTime.Position := 0;
    btnPlay.Caption := 'Pause';
    StyleFlatButton(btnPlay, bkSecondary);
    tmrPlay.Enabled := True;
  end;
end;

procedure TForm1.tmrPlayTimer(Sender: TObject);
begin
  // about 200 animation steps for the whole simulated time
  if tbAPPTime.Position >= tbAPPTime.Max then
    StopPlay
  else
    tbAPPTime.Position := Min(tbAPPTime.Max,
      tbAPPTime.Position + Max(1, FCable.NSaved div 200));
end;

procedure TForm1.rgAPPViewClick(Sender: TObject);
var
  L3D: Boolean;
begin
  if csLoading in ComponentState then
    Exit;
  L3D := rgAPPView.ItemIndex >= 1;   // 3D waterfall or 3D mesh
  lblYaw.Enabled := L3D;
  tbYaw.Enabled := L3D;
  lblPitch.Enabled := L3D;
  tbPitch.Enabled := L3D;
  RefreshSpaceTime;
end;

procedure TForm1.tbViewChange(Sender: TObject);
begin
  if csLoading in ComponentState then
    Exit;
  lblYaw.Caption := Format('Yaw %d', [tbYaw.Position]);
  lblPitch.Caption := Format('Pitch %d', [tbPitch.Position]);
  RefreshSpaceTime;
end;

procedure TForm1.BuildHeatMap;
var
  LK, LJ: Integer;
begin
  // width = saved time frames, height = nodes (x = 0 at the bottom row)
  FHeatMap.SetSize(FCable.NSaved, FCable.NNodes);
  for LK := 0 to FCable.NSaved - 1 do
    for LJ := 0 to FCable.NNodes - 1 do
      FHeatMap.Canvas.Pixels[LK, FCable.NNodes - 1 - LJ] :=
        VmColor(FCable.Vm[LK][LJ]);
end;

procedure FitProjection(const ACosA, ASinA, ACosB, ASinB: Double;
  const AArea: TRect; out AScale: Double; out ACx, ACy: Integer);
var
  LMinX, LMaxX, LMinY, LMaxY, LT, LX, LV, LSx, LSy, LZ: Double;
  LI, LJ, LK: Integer;
begin
  // Scale and centre that fit the projected bounding box of the normalised
  // data cube t, x in [-1, 1], Vm in [C_3D_VBASE, C_3D_VBASE + C_3D_VSPAN]
  // into AArea for the current yaw and pitch (no clipping at any angle).
  LMinX := MaxDouble;
  LMaxX := -MaxDouble;
  LMinY := MaxDouble;
  LMaxY := -MaxDouble;
  for LI := 0 to 1 do
    for LJ := 0 to 1 do
      for LK := 0 to 1 do
      begin
        LT := 2 * LI - 1;
        LX := 2 * LJ - 1;
        LV := C_3D_VBASE + LK * C_3D_VSPAN;
        LSx := LT * ACosA + LX * ASinA;
        LZ := -LT * ASinA + LX * ACosA;
        LSy := LV * ACosB + LZ * ASinB;
        LMinX := Min(LMinX, LSx);
        LMaxX := Max(LMaxX, LSx);
        LMinY := Min(LMinY, LSy);
        LMaxY := Max(LMaxY, LSy);
      end;
  AScale := Min((AArea.Right - AArea.Left) / Max(1.0E-6, LMaxX - LMinX),
    (AArea.Bottom - AArea.Top) / Max(1.0E-6, LMaxY - LMinY));
  AScale := Max(1.0, AScale);
  ACx := (AArea.Left + AArea.Right) div 2 - Round(AScale * 0.5 * (LMinX + LMaxX));
  ACy := (AArea.Top + AArea.Bottom) div 2 + Round(AScale * 0.5 * (LMinY + LMaxY));
end;

procedure TForm1.pbSpaceTimePaint(Sender: TObject);
begin
  // WM_PAINT (window exposed or resized): compose off-screen, copy once
  PaintSpaceTimeBuffered;
end;

procedure TForm1.PaintSpaceTimeBuffered;
var
  LW, LH: Integer;
begin
  LW := pbSpaceTime.Width;
  LH := pbSpaceTime.Height;
  if (LW <= 0) or (LH <= 0) then
    Exit;
  FSpaceBuffer.SetSize(LW, LH);
  DrawSpaceTime(FSpaceBuffer.Canvas, LW, LH);
  pbSpaceTime.Canvas.Draw(0, 0, FSpaceBuffer);
end;

procedure TForm1.RefreshSpaceTime;
begin
  // Animation, time slider, yaw/pitch: draw straight onto the paint box
  // from the off-screen buffer instead of Invalidate. Invalidate makes the
  // parent panel erase the area to white before the view is drawn again,
  // which was the flicker of the 3D views (ISS-026).
  if (PageControl1.ActivePage = tsAPP) and pbSpaceTime.Visible then
    PaintSpaceTimeBuffered
  else
    pbSpaceTime.Invalidate;
end;

procedure TForm1.DrawSpaceTime(ACanvas: TCanvas; AWidth, AHeight: Integer);

  procedure PrepareCanvas(ATarget: TCanvas);
  begin
    ATarget.Brush.Style := bsSolid;
    ATarget.Brush.Color := clWhite;
    ATarget.Pen.Style := psSolid;
    ATarget.Pen.Width := 1;
    ATarget.Font.Name := 'Segoe UI';
    ATarget.Font.Size := 9;
    ATarget.Font.Color := C_TEXT;
    ATarget.Font.Style := [];
  end;

var
  LKey: string;
begin
  PrepareCanvas(ACanvas);
  if (not FCableValid) or (rgAPPView.ItemIndex < 1) then
  begin
    ACanvas.FillRect(Rect(0, 0, AWidth, AHeight));
    if not FCableValid then
    begin
      ACanvas.Font.Style := [fsBold];
      ACanvas.TextOut(16, 8, 'Space-time view of Vm(x, t)');
      ACanvas.Font.Style := [];
      ACanvas.TextOut(16, 32, 'Run the APP simulation to draw the view.');
    end
    else
      DrawHeatMap(ACanvas, AWidth, AHeight);   // a single StretchDraw
    Exit;
  end;

  // 3D views: the surface depends only on the run, the view angles and the
  // size, not on the time slider. It is rendered once into FSpaceCache and
  // re-used; every frame only copies the cache and draws the moving profile.
  LKey := Format('%d|%d|%d|%d|%d|%d', [rgAPPView.ItemIndex, tbYaw.Position,
    tbPitch.Position, AWidth, AHeight, FCableRunId]);
  if LKey <> FSpaceCacheKey then
  begin
    FSpaceCache.SetSize(AWidth, AHeight);
    PrepareCanvas(FSpaceCache.Canvas);
    FSpaceCache.Canvas.FillRect(Rect(0, 0, AWidth, AHeight));
    if rgAPPView.ItemIndex = 1 then
      DrawWaterfall(FSpaceCache.Canvas, AWidth, AHeight, slSurface)
    else
      DrawMesh(FSpaceCache.Canvas, AWidth, AHeight, slSurface);
    FSpaceCacheKey := LKey;
  end;
  ACanvas.Draw(0, 0, FSpaceCache);
  PrepareCanvas(ACanvas);
  if rgAPPView.ItemIndex = 1 then
    DrawWaterfall(ACanvas, AWidth, AHeight, slOverlay)
  else
    DrawMesh(ACanvas, AWidth, AHeight, slOverlay);
end;

procedure TForm1.DrawHeatMap(ACanvas: TCanvas; AWidth, AHeight: Integer);
const
  C_ML = 64;   // margins (pixels)
  C_MR = 80;
  C_MT = 28;
  C_MB = 36;
var
  LPlot: TRect;
  LIdx, LY, LX: Integer;
  LText: string;
begin
  ACanvas.Font.Style := [fsBold];
  ACanvas.TextOut(C_ML, 6, 'Space-time map of Vm (colour = mV, viridis)');
  ACanvas.Font.Style := [];
  LPlot := Rect(C_ML, C_MT, AWidth - C_MR, AHeight - C_MB);
  FHeatRect := LPlot;
  if (LPlot.Right <= LPlot.Left + 10) or (LPlot.Bottom <= LPlot.Top + 10) then
    Exit;
  ACanvas.StretchDraw(LPlot, FHeatMap);
  ACanvas.Brush.Style := bsClear;
  ACanvas.Pen.Color := C_TEXT;
  ACanvas.Pen.Width := 1;
  ACanvas.Rectangle(LPlot);
  // time cursor from the slider
  LX := LPlot.Left + Round(FAPPFrame / Max(1, FCable.NSaved - 1) *
    (LPlot.Right - LPlot.Left));
  ACanvas.Pen.Color := clWhite;
  ACanvas.Pen.Width := 2;
  ACanvas.MoveTo(LX, LPlot.Top);
  ACanvas.LineTo(LX, LPlot.Bottom);
  ACanvas.Pen.Width := 1;
  // axis annotations
  ACanvas.TextOut(LPlot.Left, LPlot.Bottom + 4, '0');
  LText := FloatText(FCable.T[FCable.NSaved - 1], 1) + ' ms';
  ACanvas.TextOut(LPlot.Right - ACanvas.TextWidth(LText), LPlot.Bottom + 4, LText);
  LText := 't (ms)';
  ACanvas.TextOut((LPlot.Left + LPlot.Right - ACanvas.TextWidth(LText)) div 2,
    LPlot.Bottom + 4, LText);
  LText := FloatText(FCable.X[FCable.NNodes - 1] * C_MM_PER_CM, 1) + ' mm';
  ACanvas.TextOut(LPlot.Left - ACanvas.TextWidth(LText) - 4, LPlot.Top, LText);
  LText := '0 mm';
  ACanvas.TextOut(LPlot.Left - ACanvas.TextWidth(LText) - 4,
    LPlot.Bottom - ACanvas.TextHeight(LText), LText);
  LText := 'x (mm)';
  ACanvas.TextOut(LPlot.Left - ACanvas.TextWidth(LText) - 4,
    (LPlot.Top + LPlot.Bottom - ACanvas.TextHeight(LText)) div 2, LText);
  // colour bar
  for LY := LPlot.Top to LPlot.Bottom do
  begin
    ACanvas.Pen.Color := VmColor(C_VM_HI - (C_VM_HI - C_VM_LO) *
      (LY - LPlot.Top) / Max(1, LPlot.Bottom - LPlot.Top));
    ACanvas.MoveTo(LPlot.Right + 12, LY);
    ACanvas.LineTo(LPlot.Right + 26, LY);
  end;
  for LIdx := 0 to 2 do
  begin
    case LIdx of
      0:
        LText := FloatText(C_VM_HI, 0) + ' mV';
      1:
        LText := FloatText(0.5 * (C_VM_HI + C_VM_LO), 0) + ' mV';
    else
      LText := FloatText(C_VM_LO, 0) + ' mV';
    end;
    LY := LPlot.Top + LIdx * (LPlot.Bottom - LPlot.Top) div 2 -
      ACanvas.TextHeight(LText) div 2;
    ACanvas.TextOut(LPlot.Right + 30, LY, LText);
  end;
end;

procedure TForm1.DrawWaterfall(ACanvas: TCanvas; AWidth, AHeight: Integer;
  ALayer: TSpaceLayer);
const
  C_MAX_LINES = 40;
  C_MAX_POINTS = 300;
var
  LCosA, LSinA, LCosB, LSinB, LScale, LTMax, LXMax: Double;
  LCx, LCy, LNodeStep, LFrameStep, LJ, LK, LN, LLine, LLines: Integer;
  LCurve, LPoly: array of TPoint;
  LText: string;

  function TNorm(AFrame: Integer): Double;
  begin
    Result := 2.0 * FCable.T[AFrame] / LTMax - 1.0;
  end;

  function XNorm(ANode: Integer): Double;
  begin
    Result := 2.0 * FCable.X[ANode] / LXMax - 1.0;
  end;

  function VNorm(const AVm: Double): Double;
  begin
    Result := C_3D_VBASE + C_3D_VSPAN * EnsureRange((AVm - C_VM_LO) /
      (C_VM_HI - C_VM_LO), 0.0, 1.0);
  end;

  function Project(const AT, AX, AV: Double): TPoint;
  var
    LX1, LZ1: Double;
  begin
    // yaw about the vertical (Vm) axis, then pitch about the screen x axis
    LX1 := AT * LCosA + AX * LSinA;
    LZ1 := -AT * LSinA + AX * LCosA;
    Result.X := LCx + Round(LScale * LX1);
    Result.Y := LCy - Round(LScale * (AV * LCosB + LZ1 * LSinB));
  end;

  procedure AxisLine(const AP0, AP1: TPoint; const ALabel: string);
  begin
    ACanvas.MoveTo(AP0.X, AP0.Y);
    ACanvas.LineTo(AP1.X, AP1.Y);
    ACanvas.TextOut(AP1.X + 4, AP1.Y - ACanvas.TextHeight(ALabel) div 2, ALabel);
  end;

begin
  LCosA := Cos(DegToRad(tbYaw.Position));
  LSinA := Sin(DegToRad(tbYaw.Position));
  LCosB := Cos(DegToRad(tbPitch.Position));
  LSinB := Sin(DegToRad(tbPitch.Position));
  FitProjection(LCosA, LSinA, LCosB, LSinB, Rect(C_3D_MARGIN_LEFT,
    C_3D_MARGIN_TOP, AWidth - C_3D_MARGIN_RIGHT, AHeight - C_3D_MARGIN_BOTTOM),
    LScale, LCx, LCy);
  LTMax := Max(1.0E-9, FCable.T[FCable.NSaved - 1]);
  LXMax := Max(1.0E-9, FCable.X[FCable.NNodes - 1]);

  if ALayer = slOverlay then
  begin
    // moving part: spatial profile at the slider time (bold black)
    SetLength(LCurve, FCable.NNodes);
    for LJ := 0 to FCable.NNodes - 1 do
      LCurve[LJ] := Project(TNorm(FAPPFrame), XNorm(LJ),
        VNorm(FCable.Vm[FAPPFrame][LJ]));
    ACanvas.Pen.Color := C_BLACK;
    ACanvas.Pen.Width := 2;
    ACanvas.Polyline(LCurve);
    ACanvas.Pen.Width := 1;
    ACanvas.Brush.Style := bsClear;
    LText := Format('Black line: Vm(x) at t = %s ms (time slider)',
      [FloatText(FCable.T[FAPPFrame], 2)]);
    ACanvas.TextOut(16, AHeight - ACanvas.TextHeight(LText) - 6, LText);
    Exit;
  end;

  // static part (cached): title, axes and the node curves
  ACanvas.Font.Style := [fsBold];
  ACanvas.TextOut(16, 6, Format('3D waterfall of Vm(x, t)   (yaw %d deg, ' +
    'pitch %d deg)', [tbYaw.Position, tbPitch.Position]));
  ACanvas.Font.Style := [];
  LNodeStep := Max(1, Ceil(FCable.NNodes / C_MAX_LINES));
  LFrameStep := Max(1, Ceil(FCable.NSaved / C_MAX_POINTS));

  // axes (drawn first so that the curves occlude them)
  ACanvas.Pen.Color := C_LABEL;
  ACanvas.Pen.Width := 1;
  ACanvas.Brush.Style := bsClear;
  AxisLine(Project(-1, -1, C_3D_VBASE), Project(1, -1, C_3D_VBASE),
    't = ' + FloatText(LTMax, 1) + ' ms');
  AxisLine(Project(-1, -1, C_3D_VBASE), Project(-1, 1, C_3D_VBASE),
    'x = ' + FloatText(LXMax * C_MM_PER_CM, 1) + ' mm');
  AxisLine(Project(-1, -1, C_3D_VBASE), Project(-1, -1, C_3D_VBASE + C_3D_VSPAN),
    'Vm = ' + FloatText(C_VM_HI, 0) + ' mV');

  // painter's algorithm: the farthest node line is drawn first. Depth of a
  // node line grows with x * cos(yaw) (pitch is restricted to 0..80 deg).
  LLines := (FCable.NNodes - 1) div LNodeStep + 1;
  for LLine := 0 to LLines - 1 do
  begin
    if LCosA >= 0.0 then
      LJ := (LLines - 1 - LLine) * LNodeStep
    else
      LJ := LLine * LNodeStep;
    LN := 0;
    SetLength(LCurve, FCable.NSaved div LFrameStep + 2);
    LK := 0;
    while LK < FCable.NSaved do
    begin
      LCurve[LN] := Project(TNorm(LK), XNorm(LJ), VNorm(FCable.Vm[LK][LJ]));
      Inc(LN);
      Inc(LK, LFrameStep);
    end;
    SetLength(LCurve, LN);
    // filled silhouette (hides the curves behind) + coloured outline
    SetLength(LPoly, LN + 2);
    for LK := 0 to LN - 1 do
      LPoly[LK] := LCurve[LK];
    LPoly[LN] := Project(TNorm(Min(FCable.NSaved - 1, (LN - 1) * LFrameStep)),
      XNorm(LJ), C_3D_VBASE);
    LPoly[LN + 1] := Project(TNorm(0), XNorm(LJ), C_3D_VBASE);
    ACanvas.Pen.Style := psClear;
    ACanvas.Brush.Style := bsSolid;
    ACanvas.Brush.Color := clWhite;
    ACanvas.Polygon(LPoly);
    ACanvas.Pen.Style := psSolid;
    ACanvas.Pen.Width := 1;
    ACanvas.Pen.Color := OrderedLineColor(LJ, FCable.NNodes);
    ACanvas.Polyline(LCurve);
  end;
  ACanvas.Brush.Style := bsClear;
end;

procedure TForm1.DrawMesh(ACanvas: TCanvas; AWidth, AHeight: Integer;
  ALayer: TSpaceLayer);
const
  C_MAX_NODES = 45;     // mesh lines along t (one per selected x)
  C_MAX_FRAMES = 90;    // mesh lines along x (one per selected t)
var
  LCosA, LSinA, LCosB, LSinB, LScale, LTMax, LXMax, LVmMean: Double;
  LCx, LCy, LNodeStep, LFrameStep, LNx, LNt, LI, LJ, LRow, LCol: Integer;
  LNodes, LFrames: array of Integer;
  LGrid: array of array of TPoint;
  LQuad: array[0..3] of TPoint;
  LCurve: array of TPoint;
  LRowUp, LColUp: Boolean;
  LText: string;

  function Project(const AT, AX, AV: Double): TPoint;
  var
    LX1, LZ1: Double;
  begin
    // same projection as the waterfall: yaw about Vm, then pitch
    LX1 := AT * LCosA + AX * LSinA;
    LZ1 := -AT * LSinA + AX * LCosA;
    Result.X := LCx + Round(LScale * LX1);
    Result.Y := LCy - Round(LScale * (AV * LCosB + LZ1 * LSinB));
  end;

  function VNorm(const AVm: Double): Double;
  begin
    Result := C_3D_VBASE + C_3D_VSPAN * EnsureRange((AVm - C_VM_LO) /
      (C_VM_HI - C_VM_LO), 0.0, 1.0);
  end;

  procedure AxisLine(const AP0, AP1: TPoint; const ALabel: string);
  begin
    ACanvas.MoveTo(AP0.X, AP0.Y);
    ACanvas.LineTo(AP1.X, AP1.Y);
    ACanvas.TextOut(AP1.X + 4, AP1.Y - ACanvas.TextHeight(ALabel) div 2, ALabel);
  end;

  procedure DrawCell(ARow, ACol: Integer);
  begin
    // one mesh cell between nodes ARow..ARow+1 and frames ACol..ACol+1:
    // white fill hides the cells behind it (hidden-line removal), the edge
    // colour encodes the mean Vm of the cell (viridis, as the heat map)
    LQuad[0] := LGrid[ARow][ACol];
    LQuad[1] := LGrid[ARow][ACol + 1];
    LQuad[2] := LGrid[ARow + 1][ACol + 1];
    LQuad[3] := LGrid[ARow + 1][ACol];
    LVmMean := 0.25 * (FCable.Vm[LFrames[ACol]][LNodes[ARow]] +
      FCable.Vm[LFrames[ACol + 1]][LNodes[ARow]] +
      FCable.Vm[LFrames[ACol + 1]][LNodes[ARow + 1]] +
      FCable.Vm[LFrames[ACol]][LNodes[ARow + 1]]);
    ACanvas.Brush.Color := clWhite;
    ACanvas.Pen.Color := VmColor(LVmMean);
    ACanvas.Polygon(LQuad);
  end;

begin
  // Wireframe surface Vm(x, t): every selected x is connected along t and
  // every selected t is connected along x (a net, as in the lecturer's and
  // the senior's 3D plots).
  LCosA := Cos(DegToRad(tbYaw.Position));
  LSinA := Sin(DegToRad(tbYaw.Position));
  LCosB := Cos(DegToRad(tbPitch.Position));
  LSinB := Sin(DegToRad(tbPitch.Position));
  FitProjection(LCosA, LSinA, LCosB, LSinB, Rect(C_3D_MARGIN_LEFT,
    C_3D_MARGIN_TOP, AWidth - C_3D_MARGIN_RIGHT, AHeight - C_3D_MARGIN_BOTTOM),
    LScale, LCx, LCy);
  LTMax := Max(1.0E-9, FCable.T[FCable.NSaved - 1]);
  LXMax := Max(1.0E-9, FCable.X[FCable.NNodes - 1]);

  // sub-sample the grid; the last node and frame are always included
  LNodeStep := Max(1, Ceil((FCable.NNodes - 1) / C_MAX_NODES));
  LFrameStep := Max(1, Ceil((FCable.NSaved - 1) / C_MAX_FRAMES));
  LNx := (FCable.NNodes - 1) div LNodeStep + 1;
  if (LNx - 1) * LNodeStep < FCable.NNodes - 1 then
    Inc(LNx);
  LNt := (FCable.NSaved - 1) div LFrameStep + 1;
  if (LNt - 1) * LFrameStep < FCable.NSaved - 1 then
    Inc(LNt);
  if (LNx < 2) or (LNt < 2) then
    Exit;

  if ALayer = slOverlay then
  begin
    // moving part: spatial profile at the slider time (bold black)
    SetLength(LCurve, FCable.NNodes);
    for LI := 0 to FCable.NNodes - 1 do
      LCurve[LI] := Project(2.0 * FCable.T[FAPPFrame] / LTMax - 1.0,
        2.0 * FCable.X[LI] / LXMax - 1.0, VNorm(FCable.Vm[FAPPFrame][LI]));
    ACanvas.Pen.Color := C_BLACK;
    ACanvas.Pen.Width := 2;
    ACanvas.Polyline(LCurve);
    ACanvas.Pen.Width := 1;
    ACanvas.Brush.Style := bsClear;
    LText := Format('Mesh: %d x-lines, %d t-lines, edge colour = Vm (viridis). ' +
      'Black line: Vm(x) at t = %s ms (time slider)',
      [LNx, LNt, FloatText(FCable.T[FAPPFrame], 2)]);
    ACanvas.TextOut(16, AHeight - ACanvas.TextHeight(LText) - 6, LText);
    Exit;
  end;

  // static part (cached): title, axes and the mesh
  ACanvas.Font.Style := [fsBold];
  ACanvas.TextOut(16, 6, Format('3D mesh of Vm(x, t)   (yaw %d deg, pitch %d deg)',
    [tbYaw.Position, tbPitch.Position]));
  ACanvas.Font.Style := [];
  SetLength(LNodes, LNx);
  for LI := 0 to LNx - 1 do
    LNodes[LI] := Min(LI * LNodeStep, FCable.NNodes - 1);
  SetLength(LFrames, LNt);
  for LI := 0 to LNt - 1 do
    LFrames[LI] := Min(LI * LFrameStep, FCable.NSaved - 1);

  // projected grid points
  SetLength(LGrid, LNx, LNt);
  for LI := 0 to LNx - 1 do
    for LJ := 0 to LNt - 1 do
      LGrid[LI][LJ] := Project(2.0 * FCable.T[LFrames[LJ]] / LTMax - 1.0,
        2.0 * FCable.X[LNodes[LI]] / LXMax - 1.0,
        VNorm(FCable.Vm[LFrames[LJ]][LNodes[LI]]));

  // axes first, so that the surface occludes them
  ACanvas.Pen.Color := C_LABEL;
  ACanvas.Pen.Width := 1;
  ACanvas.Pen.Style := psSolid;
  ACanvas.Brush.Style := bsClear;
  AxisLine(Project(-1, -1, C_3D_VBASE), Project(1, -1, C_3D_VBASE),
    't = ' + FloatText(LTMax, 1) + ' ms');
  AxisLine(Project(-1, -1, C_3D_VBASE), Project(-1, 1, C_3D_VBASE),
    'x = ' + FloatText(LXMax * C_MM_PER_CM, 1) + ' mm');
  AxisLine(Project(-1, -1, C_3D_VBASE), Project(-1, -1, C_3D_VBASE + C_3D_VSPAN),
    'Vm = ' + FloatText(C_VM_HI, 0) + ' mV');

  // Painter's algorithm for a height field: the depth of a point is
  // z = -t sin(yaw) + x cos(yaw) (independent of Vm), larger z is farther.
  // Rows (x) and columns (t) are therefore visited from far to near.
  LRowUp := LCosA < 0.0;     // x increases towards the viewer
  LColUp := LSinA > 0.0;     // t increases towards the viewer
  ACanvas.Brush.Style := bsSolid;
  ACanvas.Pen.Width := 1;
  for LI := 0 to LNx - 2 do
  begin
    if LRowUp then
      LRow := LI
    else
      LRow := LNx - 2 - LI;
    for LJ := 0 to LNt - 2 do
    begin
      if LColUp then
        LCol := LJ
      else
        LCol := LNt - 2 - LJ;
      DrawCell(LRow, LCol);
    end;
  end;
  ACanvas.Brush.Style := bsClear;
end;

procedure TForm1.SpaceTimeMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  LFrame, LNode: Integer;
begin
  SetActiveTarget(pbSpaceTime);
  if (not FCableValid) or (rgAPPView.ItemIndex <> 0) or
     (not PtInRect(FHeatRect, Point(X, Y))) then
  begin
    SetReadout('');
    Exit;
  end;
  LFrame := EnsureRange(Round((X - FHeatRect.Left) /
    Max(1, FHeatRect.Right - FHeatRect.Left) * (FCable.NSaved - 1)),
    0, FCable.NSaved - 1);
  LNode := EnsureRange(Round((FHeatRect.Bottom - Y) /
    Max(1, FHeatRect.Bottom - FHeatRect.Top) * (FCable.NNodes - 1)),
    0, FCable.NNodes - 1);
  SetReadout(Format('t = %s ms   |   x = %s mm   |   Vm = %s mV',
    [FloatText(FCable.T[LFrame], 2), FloatText(FCable.X[LNode] * C_MM_PER_CM, 2),
     FloatText(FCable.Vm[LFrame][LNode], 2)]));
end;

procedure TForm1.btnExportAPPClick(Sender: TObject);
var
  LList: TStringList;
  LK, LJ: Integer;
  LLine: string;
begin
  if not FCableValid then
  begin
    ShowError('Run the APP simulation first.');
    Exit;
  end;
  LList := TStringList.Create;
  try
    LLine := 't_ms';
    for LJ := 0 to FCable.NNodes - 1 do
      LLine := LLine + ',Vm_x' + FloatText(FCable.X[LJ] * C_MM_PER_CM, 3) + 'mm';
    LList.Add(LLine);
    for LK := 0 to FCable.NSaved - 1 do
    begin
      LLine := FloatText(FCable.T[LK], 4);
      for LJ := 0 to FCable.NNodes - 1 do
        LLine := LLine + ',' + FloatText(FCable.Vm[LK][LJ], 4);
      LList.Add(LLine);
    end;
    SaveLines(LList, 'APP_result.csv');
  finally
    LList.Free;
  end;
end;

{ Tab 6: model parameters }

procedure TForm1.btnResetModelClick(Sender: TObject);
begin
  InitModelEditor;
  SetStatus('Model parameters reset to Hodgkin-Huxley (1952) values.');
end;

{ Clear buttons: remove the results of one tab and return it to its
  initial state (parameters are kept) }

procedure TForm1.btnClearAPGClick(Sender: TObject);
begin
  FAPGValid := False;
  ClearChart(chtVm);
  ClearChart(chtCurrents);
  ClearChart(chtGates);
  ClearChart(chtConductance);
  memAPG.Clear;
  SetReadout('');
  SetStatus('Tab 1 cleared.');
end;

procedure TForm1.btnClearPhaseClick(Sender: TObject);
begin
  ClearChart(chtPhaseM);
  ClearChart(chtPhaseH);
  ClearChart(chtPhaseN);
  ClearChart(chtTau);
  SetReadout('');
  SetStatus('Tab 2 cleared. Run tab 1 or press F5 to draw the phase plots again.');
end;

procedure TForm1.btnClearRefClick(Sender: TObject);
begin
  tmrRefDebounce.Enabled := False;
  SetLength(FRefInterval, 0);
  SetLength(FRefThreshold, 0);
  SetLength(FRefPeak, 0);
  FRefBaseline := NaN;
  ClearChart(chtRefThreshold);
  ClearChart(chtRefExample);
  memRef.Clear;
  SetReadout('');
  SetStatus('Tab 3 cleared.');
end;

procedure TForm1.btnClearISIClick(Sender: TObject);
begin
  SetLength(FISIJin, 0);
  SetLength(FISIValue, 0);
  SetLength(FISICount, 0);
  ClearChart(chtISI);
  ClearChart(chtISITraces);
  memISI.Clear;
  SetReadout('');
  SetStatus('Tab 4 cleared.');
end;

procedure TForm1.btnClearAPPClick(Sender: TObject);
begin
  StopPlay;
  FCableValid := False;
  FAPPFrame := 0;
  Inc(FCableRunId);           // drops the cached 3D surface
  FSpaceCacheKey := '';
  ClearChart(chtAPPTime);
  ClearChart(chtAPPSpace);
  tbAPPTime.Position := 0;
  lblAPPTime.Caption := 't = 0.00 ms';
  memAPP.Clear;
  RefreshSpaceTime;
  SetReadout('');
  SetStatus('Tab 5 cleared.');
end;

{ Mathematical sheets (separate windows, EquationViewer.pas) }

function TForm1.SheetForControl(Sender: TObject): Integer;
begin
  // Tag of a flat button holds its colour role, so the sheet is found from
  // the button itself
  if (Sender = btnSheet1) then
    Result := C_SHEET_MEMBRANE
  else if (Sender = btnSheet2) or (Sender = btnTheoryPhase) then
    Result := C_SHEET_GATING
  else if (Sender = btnSheet3) or (Sender = btnTheoryAPG) then
    Result := C_SHEET_RK4
  else if (Sender = btnSheet4) or (Sender = btnSheetCable) then
    Result := C_SHEET_CABLE
  else if (Sender = btnSheet5) or (Sender = btnSheetFD) then
    Result := C_SHEET_FD
  else if (Sender = btnSheet6) or (Sender = btnTheoryRef) or
          (Sender = btnTheoryISI) then
    Result := C_SHEET_ANALYSIS
  else
    Result := 0;
end;

function TForm1.SheetForActiveTab: Integer;
begin
  if PageControl1.ActivePage = tsPhase then
    Result := C_SHEET_GATING
  else if (PageControl1.ActivePage = tsRefractory) or
          (PageControl1.ActivePage = tsISI) then
    Result := C_SHEET_ANALYSIS
  else if PageControl1.ActivePage = tsAPP then
    Result := C_SHEET_FD
  else if PageControl1.ActivePage = tsModel then
    Result := C_SHEET_MEMBRANE
  else
    Result := C_SHEET_RK4;
end;

procedure TForm1.OpenSheet(AIndex: Integer);
begin
  if (AIndex < SHEET_FIRST) or (AIndex > SHEET_LAST) then
    Exit;
  try
    ShowEquationSheet(Self, AIndex);
    SetStatus(Format('Sheet %d opened: %s', [AIndex, SheetTitle(AIndex)]));
  except
    on E: Exception do
    begin
      AppendLog('ERROR', 'Sheet ' + IntToStr(AIndex) + ': ' + E.Message);
      ShowError('The sheet could not be opened: ' + E.Message);
    end;
  end;
end;

procedure TForm1.btnSheetClick(Sender: TObject);
begin
  OpenSheet(SheetForControl(Sender));
end;

end.
