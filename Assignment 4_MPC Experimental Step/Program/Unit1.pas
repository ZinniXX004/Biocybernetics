unit Unit1;

{
  Unit1.pas - Main form of the MPC experimental steps program
  (Biocybernetics Assignment 4).

  Author : Jeremia Christ Immanuel Manalu (5023231017)

  One tab per problem of the sheet:
    Problem 1  bilinear discretisation of system 1 (checked against the
               sheet) and system 2, discrete step and impulse responses,
               eigenvalues of Ad in the z plane
    Problem 2  step data of x'' = -0.5 x' - x + u, Markov parameters,
               Hankel matrix, SVD, Ho-Kalman model A, B, C, D and the
               process data file (.dat)
    Problem 3  observer gain Kob by pole placement for a 2 x 2 plant and
               the error of the observer against the open-loop model

  Every control and chart is designed in Unit1.dfm. Buttons and cards are
  TPanels; the interposer class below only paints them (gradient, hover
  and pressed state) according to their Tag, so they stay visible in the
  Form Designer. The code reads the inputs and fills the series.

  Keys and mouse: F1 opens the equation sheet (Unit2). Over a chart the
  nearest point shows its values, the wheel zooms at the cursor (Shift +
  wheel: x axis only), a drag to the lower right zooms into a box, a right
  drag pans and a double click restores the full view.
}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.Types, System.Math, System.UITypes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.ValEdit,
  Vcl.ComCtrls, Vcl.GraphUtil, Vcl.Imaging.pngimage, VCLTee.TeEngine,
  VCLTee.TeeProcs, VCLTee.Chart, VCLTee.Series, MPCModel;

type
  { Interposer: the TPanels of Unit1.dfm become this class at run time.
    Tag 0 = normal panel, 1 to 9 = button colours, 11 = page header,
    10 and 12 to 16 = card with a gradient title strip whose colour shows
    the role of the card: 10 actions (blue), 12 editable inputs (green),
    13 messages and warnings (red to orange), 14 computed results (teal). }
  TPanel = class(Vcl.ExtCtrls.TPanel)
  private
    FHover: Boolean;
    FDown: Boolean;
    function IsButton: Boolean;
    function IsCard: Boolean;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  end;

  { Interposer: every TChart of Unit1.dfm. While the mouse moves over the
    plot area without a pressed button, the point of the visible series
    nearest to the cursor is marked; TForm1.ChartAfterDraw draws the
    cross-hair and the value box. }
  TChart = class(VCLTee.Chart.TChart)
  private
    FHoverSeries: TChartSeries;
    FHoverIndex: Integer;
    procedure SetHover(ASeries: TChartSeries; AIndex: Integer);
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
  protected
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
  end;

  TForm1 = class(TForm)
    pnlHeader: TPanel;
    lblTitle: TLabel;
    lblSubtitle: TLabel;
    btnEquations: TPanel;
    btnExportCSV: TPanel;
    btnExportPNG: TPanel;
    btnClear: TPanel;
    btnExit: TPanel;
    pnlBottom: TPanel;
    cardLog: TPanel;
    redLog: TRichEdit;
    PageControl1: TPageControl;
    tsP1: TTabSheet;
    pnlP1Bg: TPanel;
    pnlP1Side: TPanel;
    cardP1System: TPanel;
    rgP1System: TRadioGroup;
    rgP1Method: TRadioGroup;
    cardP1Model: TPanel;
    vleP1Model: TValueListEditor;
    cardP1Sim: TPanel;
    vleP1Sim: TValueListEditor;
    chkP1PulseArea: TCheckBox;
    chkP1Exact: TCheckBox;
    cardP1Run: TPanel;
    btnP1Discretise: TPanel;
    btnP1Simulate: TPanel;
    btnP1Reset: TPanel;
    gpP1: TGridPanel;
    cardP1Result: TPanel;
    redP1Result: TRichEdit;
    chtP1Poles: TChart;
    serP1Circle: TLineSeries;
    serP1Poles: TPointSeries;
    chtP1Step: TChart;
    serP1Step: TFastLineSeries;
    serP1StepExact: TFastLineSeries;
    chtP1Imp: TChart;
    serP1Imp: TFastLineSeries;
    serP1ImpExact: TFastLineSeries;
    tsP2: TTabSheet;
    pnlP2Bg: TPanel;
    pnlP2Side: TPanel;
    cardP2Plant: TPanel;
    vleP2Plant: TValueListEditor;
    cardP2Data: TPanel;
    vleP2Data: TValueListEditor;
    rgP2Source: TRadioGroup;
    cardP2Hankel: TPanel;
    vleP2Hankel: TValueListEditor;
    cardP2Run: TPanel;
    btnP2Data: TPanel;
    btnP2Identify: TPanel;
    btnP2Save: TPanel;
    btnP2ToObserver: TPanel;
    gpP2: TGridPanel;
    chtP2Step: TChart;
    serP2Data: TPointSeries;
    serP2Model: TLineSeries;
    chtP2Markov: TChart;
    serP2Markov: TPointSeries;
    serP2MarkovModel: TLineSeries;
    chtP2Sigma: TChart;
    serP2Sigma: TLineSeries;
    serP2Tol: TLineSeries;
    cardP2Result: TPanel;
    redP2Result: TRichEdit;
    tsP3: TTabSheet;
    pnlP3Bg: TPanel;
    pnlP3Side: TPanel;
    cardP3Preset: TPanel;
    rgP3Preset: TRadioGroup;
    cardP3Plant: TPanel;
    vleP3Plant: TValueListEditor;
    cardP3Sim: TPanel;
    vleP3Sim: TValueListEditor;
    cardP3Run: TPanel;
    btnP3Gain: TPanel;
    btnP3Simulate: TPanel;
    gpP3: TGridPanel;
    cardP3Result: TPanel;
    redP3Result: TRichEdit;
    chtP3Err: TChart;
    serP3ErrObs: TLineSeries;
    serP3ErrOpen: TLineSeries;
    chtP3X1: TChart;
    serP3X1: TLineSeries;
    serP3Xo1: TLineSeries;
    serP3Xm1: TLineSeries;
    chtP3X2: TChart;
    serP3X2: TLineSeries;
    serP3Xo2: TLineSeries;
    serP3Xm2: TLineSeries;
    StatusBar1: TStatusBar;
    SaveDialogCSV: TSaveDialog;
    SaveDialogPNG: TSaveDialog;
    SaveDialogDAT: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnEquationsClick(Sender: TObject);
    procedure btnExportCSVClick(Sender: TObject);
    procedure btnExportPNGClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure rgP1SystemClick(Sender: TObject);
    procedure btnP1DiscretiseClick(Sender: TObject);
    procedure btnP1SimulateClick(Sender: TObject);
    procedure btnP1ResetClick(Sender: TObject);
    procedure btnP2DataClick(Sender: TObject);
    procedure btnP2IdentifyClick(Sender: TObject);
    procedure btnP2SaveClick(Sender: TObject);
    procedure btnP2ToObserverClick(Sender: TObject);
    procedure rgP3PresetClick(Sender: TObject);
    procedure btnP3GainClick(Sender: TObject);
    procedure btnP3SimulateClick(Sender: TObject);
    procedure ChartDblClick(Sender: TObject);
    procedure ChartAfterDraw(Sender: TObject);
    procedure lblSubtitleClick(Sender: TObject);
  private
    FP2Result: THoKalman;     { last Ho-Kalman run, Ok = False if none }
    FP2Header: string;
    FLastError: string;       { last unexpected error and when it was shown }
    FLastErrorTime: TDateTime;
    procedure AppException(Sender: TObject; E: Exception);
    procedure SetStatus(const AText: string);
    procedure Log(const ALevel, AText: string);
    procedure Warn(const AText: string);
    procedure Fail(const AText: string);
    function ReadValue(AVle: TValueListEditor; const AKey: string; out AValue: Double): Boolean;
    function ReadCount(AVle: TValueListEditor; const AKey: string; AMin, AMax: Integer;
      out AValue: Integer): Boolean;
    function ReadRow(AVle: TValueListEditor; const AKey: string; ACount: Integer;
      out AValues: TVector): Boolean;
    function ReadModel(AVle: TValueListEditor; out AModel: TStateModel): Boolean;
    procedure ShowModel(AVle: TValueListEditor; const AModel: TStateModel; ADigits: Integer);
    procedure ShowText(ARed: TRichEdit; const AText: string);
    procedure ClearChart(AChart: TChart);
    procedure ResetChart(AChart: TChart);
    procedure ZoomAxis(AAxis: TChartAxis; const AFactor, ACenter: Double);
    procedure ZoomChart(AChart: TChart; const AFactor: Double; const APoint: TPoint; AXOnly: Boolean);
    procedure PlotResponse(ASeries: TChartSeries; const AT, AY: TVector);
    function SelectedMethod(ARadio: TRadioGroup): TDiscreteMethod;
    function ReadP1(out AModel: TStateModel; out AT, ATEnd, AAmp: Double): Boolean;
    function DiscreteReport(const AModel, ADisc: TStateModel; AT: Double; AMethod: TDiscreteMethod): string;
    procedure PlotPoles(const AZ: TComplexArray);
    function ReadP2Plant(out AModel: TStateModel; out AT: Double; out ASamples: Integer): Boolean;
    procedure PlotStepData(const AData: TVector; AT: Double);
    function ReadP3(out AModel: TStateModel; out AP1, AP2: Double): Boolean;
    function ActiveCharts: TArray<TChart>;
  public
    procedure MouseWheelHandler(var Message: TMessage); override;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  Unit2;

const
  C_KEY_T = 'Sampling time T (s)';
  C_KEY_TEND = 'Simulation time (s)';
  C_KEY_AMP = 'Step amplitude (-)';
  C_KEY_B = 'B (column, top to bottom)';
  C_KEY_C = 'C';
  C_KEY_D = 'D';
  C_KEY_A1 = 'a1 (damping term)';
  C_KEY_A0 = 'a0 (stiffness term)';
  C_KEY_B0 = 'b0 (input gain)';
  C_KEY_T2 = 'Sampling interval T (s)';
  C_KEY_N2 = 'Number of step samples';
  C_KEY_K = 'Hankel rows k';
  C_KEY_L = 'Hankel columns l';
  C_KEY_ORDER = 'Model order n (0 for automatic)';
  C_KEY_TOL = 'Order tolerance sigma_i / sigma_1';
  C_KEY_P1 = 'Observer pole p1';
  C_KEY_P2 = 'Observer pole p2';
  C_KEY_X0 = 'Plant start x(0)';
  C_KEY_XH0 = 'Observer start x^(0)';
  C_KEY_U = 'Input u(k) (constant)';
  C_KEY_N3 = 'Number of samples';
  C_MAX_STEPS = 200000;
  C_TAG_CARD = 10;
  C_TAG_HEADER = 11;
  C_TAG_CARD_LAST = 16;
  C_CARD_STRIP = 26;
  C_ZOOM_IN = 0.8;
  C_ZOOM_OUT = 1.25;
  C_SIGMA_FLOOR = 1.0e-20;
  { the same unexpected error is shown at most once in this time (days) }
  C_ERROR_PAUSE = 2.0 / 86400.0;
  C_ERROR_LOG = 'MPCSteps_error.log';

{ Linear mix of two colours, AT = 0 gives A, AT = 1 gives B. }
function MixColor(A, B: TColor; AT: Double): TColor;
var
  LA, LB: Longint;
begin
  LA := ColorToRGB(A);
  LB := ColorToRGB(B);
  Result := RGB(Round(GetRValue(LA) + (GetRValue(LB) - GetRValue(LA)) * AT),
    Round(GetGValue(LA) + (GetGValue(LB) - GetGValue(LA)) * AT),
    Round(GetBValue(LA) + (GetBValue(LB) - GetBValue(LA)) * AT));
end;

{ TPanel interposer }

function TPanel.IsButton: Boolean;
begin
  Result := (Tag >= 1) and (Tag <= 9);
end;

function TPanel.IsCard: Boolean;
begin
  Result := (Tag = C_TAG_CARD) or ((Tag > C_TAG_HEADER) and (Tag <= C_TAG_CARD_LAST));
end;

procedure TPanel.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  if IsButton then
  begin
    FHover := True;
    Invalidate;
  end;
end;

procedure TPanel.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  if IsButton then
  begin
    FHover := False;
    FDown := False;
    Invalidate;
  end;
end;

procedure TPanel.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if IsButton and (Button = mbLeft) then
  begin
    FDown := True;
    Invalidate;
  end;
  inherited;
end;

procedure TPanel.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if IsButton then
  begin
    FDown := False;
    Invalidate;
  end;
  inherited;
end;

procedure TPanel.Paint;
var
  LRect, LStrip: TRect;
  LTop, LBottom: TColor;
begin
  if Tag = 0 then
  begin
    inherited Paint;
    Exit;
  end;
  LRect := ClientRect;
  if Tag = C_TAG_HEADER then
  begin
    GradientFillCanvas(Canvas, RGB(0, 77, 64), RGB(21, 101, 192), LRect, gdHorizontal);
    Exit;
  end;
  if IsCard then
  begin
    case Tag of
      12:
        begin
          LTop := RGB(27, 94, 32);
          LBottom := RGB(102, 187, 106);
        end;
      13:
        begin
          LTop := RGB(183, 28, 28);
          LBottom := RGB(245, 124, 0);
        end;
      14:
        begin
          LTop := RGB(0, 96, 100);
          LBottom := RGB(38, 166, 154);
        end;
    else
      LTop := RGB(13, 71, 161);
      LBottom := RGB(66, 165, 245);
    end;
    Canvas.Brush.Color := Color;
    Canvas.FillRect(LRect);
    LStrip := Rect(0, 0, Width, C_CARD_STRIP);
    GradientFillCanvas(Canvas, LTop, LBottom, LStrip, gdHorizontal);
    Canvas.Brush.Style := bsClear;
    Canvas.Font.Name := 'Segoe UI Semibold';
    Canvas.Font.Height := -13;
    Canvas.Font.Style := [];
    Canvas.Font.Color := clWhite;
    Canvas.TextOut(10, (C_CARD_STRIP - Canvas.TextHeight('Ag')) div 2, Caption);
    Canvas.Pen.Color := MixColor(LTop, clWhite, 0.65);
    Canvas.Rectangle(LRect);
    Exit;
  end;
  { buttons: top and bottom colour of the vertical gradient by group
    1 compute (blue), 2 export (teal), 3 EXIT (red), 4 files (slate),
    5 equations (purple), 6 data (amber), 7 CLEAR (green), 8 observer (indigo) }
  case Tag of
    2:
      begin
        LTop := RGB(38, 166, 154);
        LBottom := RGB(0, 105, 92);
      end;
    3:
      begin
        LTop := RGB(239, 83, 80);
        LBottom := RGB(183, 28, 28);
      end;
    4:
      begin
        LTop := RGB(120, 144, 156);
        LBottom := RGB(69, 90, 100);
      end;
    5:
      begin
        LTop := RGB(171, 71, 188);
        LBottom := RGB(106, 27, 154);
      end;
    6:
      begin
        LTop := RGB(255, 179, 0);
        LBottom := RGB(230, 120, 0);
      end;
    7:
      begin
        LTop := RGB(102, 187, 106);
        LBottom := RGB(27, 94, 32);
      end;
    8:
      begin
        LTop := RGB(121, 134, 203);
        LBottom := RGB(40, 53, 147);
      end;
  else
    LTop := RGB(66, 165, 245);
    LBottom := RGB(13, 71, 161);
  end;
  if not Enabled then
  begin
    LTop := RGB(200, 200, 200);
    LBottom := RGB(160, 160, 160);
  end
  else if FDown then
  begin
    { pressed: darker and the gradient turned upside down }
    LTop := MixColor(LBottom, clBlack, 0.25);
    LBottom := MixColor(LTop, clWhite, 0.15);
  end
  else if FHover then
  begin
    LTop := MixColor(LTop, clWhite, 0.30);
    LBottom := MixColor(LBottom, clWhite, 0.20);
  end;
  GradientFillCanvas(Canvas, LTop, LBottom, LRect, gdVertical);
  Canvas.Brush.Style := bsClear;
  Canvas.Pen.Color := MixColor(LBottom, clBlack, 0.3);
  Canvas.Rectangle(LRect);
  if FHover and not FDown then
  begin
    Canvas.Pen.Color := MixColor(LTop, clWhite, 0.6);
    Canvas.Rectangle(Rect(1, 1, Width - 1, Height - 1));
  end;
  Canvas.Font.Assign(Font);
  if FDown then
    OffsetRect(LRect, 1, 1);
  DrawText(Canvas.Handle, PChar(Caption), -1, LRect, DT_CENTER or DT_VCENTER or DT_SINGLELINE or
    DT_END_ELLIPSIS);
end;

{ TChart interposer }

procedure TChart.SetHover(ASeries: TChartSeries; AIndex: Integer);
begin
  if (ASeries = FHoverSeries) and (AIndex = FHoverIndex) then
    Exit;
  FHoverSeries := ASeries;
  FHoverIndex := AIndex;
  Invalidate;
end;

procedure TChart.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  SetHover(nil, -1);
end;

{ Nearest point of the visible series (screen distance). Series with
  ascending x are searched by bisection, the others (unit circle, poles)
  by a scan. Points farther than 40 pixels are not marked. }
procedure TChart.MouseMove(Shift: TShiftState; X, Y: Integer);
const
  CMaxDist = 40;
var
  LI, LS, LLo, LHi, LMid, LBestIdx: Integer;
  LSer, LBestSer: TChartSeries;
  LXv, LBest: Double;

  { The pixel offsets are squared as Double: Sqr of an Integer stays an
    Integer, and a point far outside a zoomed axis (the unit circle around
    the poles of system 1) is more than 46341 pixels away, so its square
    raised EIntOverflow with overflow checking on (ISS-086). }
  procedure Probe(ASer: TChartSeries; AIdx: Integer);
  var
    LDx, LDy, LDist: Double;
  begin
    if (AIdx < 0) or (AIdx >= ASer.Count) then
      Exit;
    LDx := 1.0 * ASer.CalcXPos(AIdx) - X;
    LDy := 1.0 * ASer.CalcYPos(AIdx) - Y;
    if (Abs(LDx) > CMaxDist) or (Abs(LDy) > CMaxDist) then
      Exit;
    LDist := Sqr(LDx) + Sqr(LDy);
    if LDist < LBest then
    begin
      LBest := LDist;
      LBestSer := ASer;
      LBestIdx := AIdx;
    end;
  end;

begin
  inherited;
  if (ssLeft in Shift) or (ssRight in Shift) or (ssMiddle in Shift) or
    not PtInRect(ChartRect, Point(X, Y)) then
  begin
    SetHover(nil, -1);
    Exit;
  end;
  LBest := Sqr(1.0 * CMaxDist);
  LBestSer := nil;
  LBestIdx := -1;
  for LS := 0 to SeriesCount - 1 do
  begin
    LSer := Series[LS];
    if (not LSer.Active) or (LSer.Count = 0) then
      Continue;
    if LSer.XValues.Order = loAscending then
    begin
      LXv := LSer.GetHorizAxis.CalcPosPoint(X);
      LLo := 0;
      LHi := LSer.Count - 1;
      while LHi - LLo > 1 do
      begin
        LMid := (LLo + LHi) div 2;
        if LSer.XValue[LMid] < LXv then
          LLo := LMid
        else
          LHi := LMid;
      end;
      for LI := LLo - 2 to LHi + 2 do
        Probe(LSer, LI);
    end
    else
      for LI := 0 to LSer.Count - 1 do
        Probe(LSer, LI);
  end;
  if LBestSer <> nil then
    SetHover(LBestSer, LBestIdx)
  else
    SetHover(nil, -1);
end;

{ TForm1: general }

procedure TForm1.FormCreate(Sender: TObject);
begin
  FormatSettings.DecimalSeparator := '.';
  Application.OnException := AppException;
  FP2Result.Ok := False;
  Log('INFO', 'Ready. Problem 1: Discretise, then Step and impulse. Problem 2: Ho-Kalman (SVD). ' +
    'Problem 3: Compute Kob, then Simulate observer.');
  Log('INFO', 'Charts: hover = nearest value, wheel = zoom at the cursor, Shift + wheel = x axis only, ' +
    'drag to the lower right = zoom box, right drag = pan, double click = full view, legend boxes ' +
    'hide or show a line.');
  SetStatus('Ready. F1 shows the equations.');
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F1 then
  begin
    btnEquationsClick(nil);
    Key := 0;
  end;
end;

procedure TForm1.lblSubtitleClick(Sender: TObject);
begin

end;

{ Unexpected errors end up here instead of closing the program; each one
  is appended to MPCSteps_error.log next to the exe and shown at most once
  every 2 s (A3 ISS-069). }
procedure TForm1.AppException(Sender: TObject; E: Exception);
var
  LText: string;
  LWriter: TStreamWriter;
begin
  LText := E.ClassName + ': ' + E.Message;
  try
    LWriter := TStreamWriter.Create(ExtractFilePath(ParamStr(0)) + C_ERROR_LOG, True, TEncoding.UTF8);
    try
      LWriter.WriteLine(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + ' ' + LText);
    finally
      LWriter.Free;
    end;
  except
    { a read-only folder must not raise a second error from this handler }
    on Exception do
      ;
  end;
  if (LText = FLastError) and (Now - FLastErrorTime < C_ERROR_PAUSE) then
    Exit;
  FLastError := LText;
  FLastErrorTime := Now;
  Log('ERROR', LText);
  MessageDlg('Unexpected error: ' + E.Message + sLineBreak + 'The program keeps running. ' +
    'Details are in ' + C_ERROR_LOG + ' next to the program.', mtError, [mbOK], 0);
end;

{ A wheel over a chart is consumed here and zooms at the cursor, so
  TeeChart's own wheel scrolling (EInvalidCast, A1 ISS-019) never runs. }
procedure TForm1.MouseWheelHandler(var Message: TMessage);
var
  LWin: TWinControl;
  LDelta: SmallInt;
begin
  LWin := FindVCLWindow(Mouse.CursorPos);
  if LWin is TChart then
  begin
    LDelta := SmallInt(HiWord(Message.WParam));
    if LDelta > 0 then
      ZoomChart(TChart(LWin), C_ZOOM_IN, LWin.ScreenToClient(Mouse.CursorPos),
        (LoWord(Message.WParam) and MK_SHIFT) <> 0)
    else if LDelta < 0 then
      ZoomChart(TChart(LWin), C_ZOOM_OUT, LWin.ScreenToClient(Mouse.CursorPos),
        (LoWord(Message.WParam) and MK_SHIFT) <> 0);
    Message.Result := 1;
  end
  else
    inherited MouseWheelHandler(Message);
end;

procedure TForm1.ZoomAxis(AAxis: TChartAxis; const AFactor, ACenter: Double);
var
  LMin, LMax: Double;
begin
  LMin := AAxis.Minimum;
  LMax := AAxis.Maximum;
  if LMax <= LMin then
    Exit;
  AAxis.SetMinMax(ACenter + (LMin - ACenter) * AFactor, ACenter + (LMax - ACenter) * AFactor);
end;

procedure TForm1.ZoomChart(AChart: TChart; const AFactor: Double; const APoint: TPoint; AXOnly: Boolean);
var
  LCx, LCy: Double;
begin
  if AChart.SeriesCount = 0 then
    Exit;
  if PtInRect(AChart.ChartRect, APoint) then
  begin
    LCx := AChart.BottomAxis.CalcPosPoint(APoint.X);
    LCy := AChart.LeftAxis.CalcPosPoint(APoint.Y);
  end
  else
  begin
    LCx := 0.5 * (AChart.BottomAxis.Minimum + AChart.BottomAxis.Maximum);
    LCy := 0.5 * (AChart.LeftAxis.Minimum + AChart.LeftAxis.Maximum);
  end;
  ZoomAxis(AChart.BottomAxis, AFactor, LCx);
  if not AXOnly then
    ZoomAxis(AChart.LeftAxis, AFactor, LCy);
end;

procedure TForm1.ResetChart(AChart: TChart);
begin
  AChart.BottomAxis.Automatic := True;
  AChart.LeftAxis.Automatic := True;
  AChart.Invalidate;
end;

procedure TForm1.ChartDblClick(Sender: TObject);
begin
  if Sender is TChart then
    ResetChart(TChart(Sender));
end;

{ Cross-hair and value box of the point marked by the TChart interposer. }
procedure TForm1.ChartAfterDraw(Sender: TObject);
var
  LChart: TChart;
  LSer: TChartSeries;
  LIdx, LX, LY, LW, LH, LBx, LBy, LLine: Integer;
  LT1, LT2: string;
  LR: TRect;
begin
  if not (Sender is TChart) then
    Exit;
  LChart := TChart(Sender);
  LSer := LChart.FHoverSeries;
  LIdx := LChart.FHoverIndex;
  if (LSer = nil) or (LIdx < 0) or (LIdx >= LSer.Count) or not LSer.Active then
    Exit;
  LR := LChart.ChartRect;
  LX := LSer.CalcXPos(LIdx);
  LY := LSer.CalcYPos(LIdx);
  if not PtInRect(LR, Point(LX, LY)) then
    Exit;
  with LChart.Canvas do
  begin
    Pen.Width := 1;
    Pen.Style := psDot;
    Pen.Color := RGB(120, 144, 156);
    MoveTo(LX, LR.Top);
    LineTo(LX, LR.Bottom);
    MoveTo(LR.Left, LY);
    LineTo(LR.Right, LY);
    Pen.Style := psSolid;
    Pen.Width := 2;
    Pen.Color := LSer.SeriesColor;
    Brush.Style := bsSolid;
    Brush.Color := clWhite;
    Ellipse(LX - 5, LY - 5, LX + 5, LY + 5);
    LT1 := LSer.Title;
    LT2 := LSer.GetHorizAxis.Title.Caption + ' = ' + FmtG(LSer.XValue[LIdx], 8) + ',  ' +
      LSer.GetVertAxis.Title.Caption + ' = ' + FmtG(LSer.YValue[LIdx], 8);
    Font.Name := 'Segoe UI';
    Font.Size := 9;
    Font.Style := [fsBold];
    Font.Color := RGB(38, 50, 56);
    LLine := TextHeight('Ag');
    LW := Max(TextWidth(LT1), TextWidth(LT2)) + 16;
    LH := 2 * LLine + 10;
    LBx := LX + 12;
    LBy := LY - LH - 10;
    if LBx + LW > LR.Right then
      LBx := LX - LW - 12;
    if LBy < LR.Top then
      LBy := LY + 12;
    Pen.Width := 1;
    Pen.Color := LSer.SeriesColor;
    Brush.Style := bsSolid;
    Brush.Color := RGB(255, 253, 231);
    Rectangle(LBx, LBy, LBx + LW, LBy + LH);
    TextOut(LBx + 8, LBy + 4, LT1);
    Font.Style := [];
    TextOut(LBx + 8, LBy + 4 + LLine, LT2);
  end;
end;

procedure TForm1.SetStatus(const AText: string);
begin
  StatusBar1.Panels[0].Text := AText;
end;

{ One line of the message log, coloured by its level: INFO grey,
  WARNING orange and bold, ERROR red and bold. }
procedure TForm1.Log(const ALevel, AText: string);
begin
  redLog.SelStart := redLog.GetTextLen;
  redLog.SelLength := 0;
  if ALevel = 'ERROR' then
  begin
    redLog.SelAttributes.Color := RGB(198, 40, 40);
    redLog.SelAttributes.Style := [fsBold];
  end
  else if ALevel = 'WARNING' then
  begin
    redLog.SelAttributes.Color := RGB(230, 81, 0);
    redLog.SelAttributes.Style := [fsBold];
  end
  else
  begin
    redLog.SelAttributes.Color := RGB(55, 71, 79);
    redLog.SelAttributes.Style := [];
  end;
  redLog.SelText := FormatDateTime('hh:nn:ss', Now) + ' ' + ALevel + ': ' + AText + sLineBreak;
  redLog.Perform(EM_SCROLLCARET, 0, 0);
  SetStatus(ALevel + ': ' + AText);
end;

procedure TForm1.Warn(const AText: string);
begin
  Log('WARNING', AText);
  MessageDlg(AText, mtWarning, [mbOK], 0);
end;

procedure TForm1.Fail(const AText: string);
begin
  Log('ERROR', AText);
  MessageDlg(AText, mtError, [mbOK], 0);
end;

{ Input helpers. Numbers accept '.' or ',' as decimal separator. }

function TForm1.ReadValue(AVle: TValueListEditor; const AKey: string; out AValue: Double): Boolean;
var
  LText: string;
begin
  LText := Trim(StringReplace(AVle.Values[AKey], ',', '.', [rfReplaceAll]));
  Result := TryStrToFloat(LText, AValue, TFormatSettings.Invariant) and not IsNan(AValue) and
    not IsInfinite(AValue);
  if not Result then
    Fail('"' + LText + '" is not a number (' + AKey + ').');
end;

function TForm1.ReadCount(AVle: TValueListEditor; const AKey: string; AMin, AMax: Integer;
  out AValue: Integer): Boolean;
var
  LText: string;
begin
  LText := Trim(AVle.Values[AKey]);
  Result := TryStrToInt(LText, AValue) and (AValue >= AMin) and (AValue <= AMax);
  if not Result then
    Fail(AKey + ' must be a whole number from ' + IntToStr(AMin) + ' to ' + IntToStr(AMax) +
      ' (entered: "' + LText + '").');
end;

{ A row of a matrix: ACount numbers separated by spaces, tabs or ';'. }
function TForm1.ReadRow(AVle: TValueListEditor; const AKey: string; ACount: Integer;
  out AValues: TVector): Boolean;
var
  LParts: TStringList;
  LText: string;
  LI: Integer;
begin
  Result := False;
  AValues := nil;
  LText := StringReplace(AVle.Values[AKey], ',', '.', [rfReplaceAll]);
  LText := StringReplace(LText, ';', ' ', [rfReplaceAll]);
  LText := StringReplace(LText, #9, ' ', [rfReplaceAll]);
  LParts := TStringList.Create;
  try
    LParts.Delimiter := ' ';
    LParts.StrictDelimiter := True;
    LParts.DelimitedText := Trim(LText);
    for LI := LParts.Count - 1 downto 0 do
      if Trim(LParts[LI]) = '' then
        LParts.Delete(LI);
    if LParts.Count <> ACount then
    begin
      Fail(AKey + ' needs ' + IntToStr(ACount) + ' numbers separated by spaces, found ' +
        IntToStr(LParts.Count) + '.');
      Exit;
    end;
    SetLength(AValues, ACount);
    for LI := 0 to ACount - 1 do
      if not TryStrToFloat(LParts[LI], AValues[LI], TFormatSettings.Invariant) then
      begin
        Fail(AKey + ': "' + LParts[LI] + '" is not a number.');
        Exit;
      end;
  finally
    LParts.Free;
  end;
  Result := True;
end;

{ A, B, C, D from the rows "A row i", "B (column, top to bottom)", "C" and
  the optional "D" of a value list. The order n is the number of A rows. }
function TForm1.ReadModel(AVle: TValueListEditor; out AModel: TStateModel): Boolean;
var
  LN, LI, LJ: Integer;
  LRow: TVector;
begin
  Result := False;
  LN := 0;
  for LI := 0 to AVle.Strings.Count - 1 do
    if Pos('A row ', AVle.Strings.Names[LI]) = 1 then
      Inc(LN);
  if LN = 0 then
  begin
    Fail('The table has no row "A row 1".');
    Exit;
  end;
  AModel.A := MatCreate(LN, LN);
  for LI := 0 to LN - 1 do
  begin
    if not ReadRow(AVle, 'A row ' + IntToStr(LI + 1), LN, LRow) then
      Exit;
    for LJ := 0 to LN - 1 do
      AModel.A[LI][LJ] := LRow[LJ];
  end;
  if not ReadRow(AVle, C_KEY_B, LN, LRow) then
    Exit;
  AModel.B := MatCreate(LN, 1);
  for LI := 0 to LN - 1 do
    AModel.B[LI][0] := LRow[LI];
  if not ReadRow(AVle, C_KEY_C, LN, LRow) then
    Exit;
  AModel.C := MatCreate(1, LN);
  for LI := 0 to LN - 1 do
    AModel.C[0][LI] := LRow[LI];
  AModel.D := MatCreate(1, 1);
  if AVle.Strings.IndexOfName(C_KEY_D) >= 0 then
  begin
    if not ReadRow(AVle, C_KEY_D, 1, LRow) then
      Exit;
    AModel.D[0][0] := LRow[0];
  end;
  Result := True;
end;

{ Writes A, B, C (and D when the table has it) back into a value list,
  keeping every other row of the table. }
procedure TForm1.ShowModel(AVle: TValueListEditor; const AModel: TStateModel; ADigits: Integer);
var
  LN, LI, LJ: Integer;
  LKeep: TStringList;
  LRow: string;
  LHasD: Boolean;
begin
  LN := ModelOrder(AModel);
  LHasD := AVle.Strings.IndexOfName(C_KEY_D) >= 0;
  LKeep := TStringList.Create;
  try
    for LI := 0 to AVle.Strings.Count - 1 do
      if (Pos('A row ', AVle.Strings.Names[LI]) <> 1) and (AVle.Strings.Names[LI] <> C_KEY_B) and
        (AVle.Strings.Names[LI] <> C_KEY_C) and (AVle.Strings.Names[LI] <> C_KEY_D) then
        LKeep.Add(AVle.Strings[LI]);
    AVle.Strings.BeginUpdate;
    try
      AVle.Strings.Clear;
      for LI := 0 to LN - 1 do
      begin
        LRow := '';
        for LJ := 0 to LN - 1 do
          LRow := Trim(LRow + ' ' + FmtG(AModel.A[LI][LJ], ADigits));
        AVle.Strings.Add('A row ' + IntToStr(LI + 1) + '=' + LRow);
      end;
      LRow := '';
      for LI := 0 to LN - 1 do
        LRow := Trim(LRow + ' ' + FmtG(AModel.B[LI][0], ADigits));
      AVle.Strings.Add(C_KEY_B + '=' + LRow);
      LRow := '';
      for LI := 0 to LN - 1 do
        LRow := Trim(LRow + ' ' + FmtG(AModel.C[0][LI], ADigits));
      AVle.Strings.Add(C_KEY_C + '=' + LRow);
      if LHasD then
        AVle.Strings.Add(C_KEY_D + '=' + FmtG(AModel.D[0][0], ADigits));
      AVle.Strings.AddStrings(LKeep);
    finally
      AVle.Strings.EndUpdate;
    end;
  finally
    LKeep.Free;
  end;
end;

procedure TForm1.ShowText(ARed: TRichEdit; const AText: string);
begin
  ARed.Lines.BeginUpdate;
  try
    ARed.Lines.Text := AText;
  finally
    ARed.Lines.EndUpdate;
  end;
  ARed.SelStart := 0;
  ARed.Perform(EM_SCROLLCARET, 0, 0);
end;

{ The series are designed on the form and kept for the life of the
  program; clearing removes their points only (A1 ISS-020, A3 ISS-069). }
procedure TForm1.ClearChart(AChart: TChart);
var
  LI: Integer;
begin
  AChart.SetHover(nil, -1);
  for LI := 0 to AChart.SeriesCount - 1 do
    AChart.Series[LI].Clear;
  ResetChart(AChart);
end;

procedure TForm1.PlotResponse(ASeries: TChartSeries; const AT, AY: TVector);
var
  LI: Integer;
begin
  ASeries.BeginUpdate;
  try
    for LI := 0 to Min(High(AT), High(AY)) do
      if not (IsNan(AY[LI]) or IsInfinite(AY[LI])) then
        ASeries.AddXY(AT[LI], AY[LI]);
  finally
    ASeries.EndUpdate;
  end;
end;

function TForm1.SelectedMethod(ARadio: TRadioGroup): TDiscreteMethod;
begin
  case ARadio.ItemIndex of
    1: Result := dmTustin;
    2: Result := dmZOH;
  else
    Result := dmLecture;
  end;
end;

{ Problem 1 }

procedure TForm1.rgP1SystemClick(Sender: TObject);
begin
  btnP1ResetClick(nil);
end;

{ Loads the matrices of the chosen system and its default run time. }
procedure TForm1.btnP1ResetClick(Sender: TObject);
begin
  if rgP1System.ItemIndex = 1 then
  begin
    ShowModel(vleP1Model, ModelP1System2, 15);
    vleP1Sim.Values[C_KEY_TEND] := '10';
    Log('INFO', 'System 2 loaded: A = [0 1; -4 0], B = [0; 1], C = [0 1], D = 0.');
  end
  else
  begin
    ShowModel(vleP1Model, ModelP1System1, 15);
    vleP1Sim.Values[C_KEY_TEND] := '3';
    Log('INFO', 'System 1 loaded (the reference of the sheet).');
  end;
  vleP1Sim.Values[C_KEY_T] := '0.001';
end;

function TForm1.ReadP1(out AModel: TStateModel; out AT, ATEnd, AAmp: Double): Boolean;
begin
  Result := False;
  if not (ReadModel(vleP1Model, AModel) and ReadValue(vleP1Sim, C_KEY_T, AT) and
    ReadValue(vleP1Sim, C_KEY_TEND, ATEnd) and ReadValue(vleP1Sim, C_KEY_AMP, AAmp)) then
    Exit;
  if AT <= 0 then
    Fail('The sampling time T must be positive (the sheet uses 0.001 s).')
  else if (SelectedMethod(rgP1Method) = dmLecture) and (AT >= 2) then
    Fail('The lecture formula divides by 1 - T/2, so T must be below 2 s.')
  else if ATEnd < 2 * AT then
    Fail('The simulation time must cover at least two samples.')
  else if ATEnd / AT > C_MAX_STEPS then
    Fail('Too many samples (more than ' + IntToStr(C_MAX_STEPS) + '): increase T or shorten the run.')
  else if AAmp = 0 then
    Fail('The step amplitude must not be 0.')
  else
  begin
    Result := True;
    if AT > 0.1 then
      Log('WARNING', 'T = ' + FmtG(AT, 6) + ' s is coarse compared with the sheet (0.001 s).');
  end;
end;

function TForm1.DiscreteReport(const AModel, ADisc: TStateModel; AT: Double;
  AMethod: TDiscreteMethod): string;
var
  LSb: TStringList;
  LS, LZ: TComplexArray;
  LAdRef, LBdRef: TMatrix;
  LI: Integer;
  LLine: string;
  LIsSheet: Boolean;
begin
  LSb := TStringList.Create;
  try
    LSb.Add('Discretised with sampling interval: ' + FmtG(AT, 10) + ' s (' + C_METHOD_NAMES[AMethod] + ')');
    LSb.Add('');
    LSb.Add('Ad:');
    LSb.Add(MatToText(ADisc.A));
    LSb.Add('');
    LSb.Add('Bd:');
    LSb.Add(MatToText(ADisc.B));
    LSb.Add('');
    LSb.Add('Cd:');
    LSb.Add(MatToText(ADisc.C));
    LSb.Add('');
    LSb.Add('Dd:');
    LSb.Add(MatToText(ADisc.D));
    LSb.Add('');
    SheetReferenceP1(LAdRef, LBdRef);
    LIsSheet := (ModelOrder(AModel) = 3) and (MatMaxAbsDiff(AModel.A, ModelP1System1.A) = 0) and
      (MatMaxAbsDiff(AModel.B, ModelP1System1.B) = 0) and SameValue(AT, 1.0e-3, 1.0e-15);
    if LIsSheet then
    begin
      LSb.Add('Check against the problem sheet (system 1, T = 0.001 s):');
      LSb.Add('  max relative difference Ad = ' + FmtG(MatMaxRelDiff(ADisc.A, LAdRef), 3) +
        ', Bd = ' + FmtG(MatMaxRelDiff(ADisc.B, LBdRef), 3));
      if AMethod <> dmLecture then
        LSb.Add('  the sheet uses the lecture formula, Bd(lecture) / Bd(this) = ' +
          FmtG(LBdRef[0][0] / ADisc.B[0][0], 10));
      LSb.Add('');
    end;
    if AMethod in [dmLecture, dmTustin] then
      LSb.Add('Factor between the lecture and the standard Bd: 1 / (1 - T/2) = ' +
        FmtG(1.0 / (1.0 - 0.5 * AT), 12));
    LS := Eigenvalues(AModel.A);
    LZ := Eigenvalues(ADisc.A);
    LSb.Add('');
    LSb.Add('Eigenvalues of A (s) and of Ad (z), |z|:');
    for LI := 0 to High(LZ) do
    begin
      LLine := '  s = ' + ComplexToText(LS[LI], 8) + '   z = ' + ComplexToText(LZ[LI], 13) + '   |z| = ' +
        FmtG(CAbs(LZ[LI]), 16);
      if CAbs(LZ[LI]) > 1.0 + 1.0e-12 then
        LLine := LLine + '  (outside: grows)'
      else if Abs(CAbs(LZ[LI]) - 1.0) <= 1.0e-12 then
        LLine := LLine + '  (on the unit circle)';
      LSb.Add(LLine);
    end;
    Result := LSb.Text;
  finally
    LSb.Free;
  end;
end;

{ Unit circle and the eigenvalues of Ad. The axes are set around the poles
  because at T = 0.001 s every pole lies within 0.003 of z = 1. }
procedure TForm1.PlotPoles(const AZ: TComplexArray);
var
  LI: Integer;
  LXMin, LXMax, LYMin, LYMax, LPad, LPhi: Double;
begin
  ClearChart(chtP1Poles);
  LXMin := AZ[0].Re;
  LXMax := AZ[0].Re;
  LYMin := AZ[0].Im;
  LYMax := AZ[0].Im;
  for LI := 0 to High(AZ) do
  begin
    serP1Poles.AddXY(AZ[LI].Re, AZ[LI].Im);
    LXMin := Min(LXMin, AZ[LI].Re);
    LXMax := Max(LXMax, AZ[LI].Re);
    LYMin := Min(LYMin, AZ[LI].Im);
    LYMax := Max(LYMax, AZ[LI].Im);
  end;
  for LI := 0 to 3600 do
  begin
    LPhi := 2.0 * Pi * LI / 3600;
    serP1Circle.AddXY(Cos(LPhi), Sin(LPhi));
  end;
  LPad := Max(1.0e-3, 0.5 * Max(LXMax - LXMin, LYMax - LYMin));
  chtP1Poles.BottomAxis.Automatic := False;
  chtP1Poles.LeftAxis.Automatic := False;
  chtP1Poles.BottomAxis.SetMinMax(LXMin - LPad, LXMax + LPad);
  chtP1Poles.LeftAxis.SetMinMax(LYMin - LPad, LYMax + LPad);
  { The default label format rounds to three decimals, which printed 0.999
    twice and 1.001 twice on an axis only 0.005 wide (ISS-088). }
  chtP1Poles.BottomAxis.AxisValuesFormat := '0.0000';
  chtP1Poles.LeftAxis.AxisValuesFormat := '0.0000';
end;

procedure TForm1.btnP1DiscretiseClick(Sender: TObject);
var
  LModel, LDisc: TStateModel;
  LT, LTEnd, LAmp: Double;
  LMethod: TDiscreteMethod;
  LZ: TComplexArray;
begin
  if not ReadP1(LModel, LT, LTEnd, LAmp) then
    Exit;
  LMethod := SelectedMethod(rgP1Method);
  try
    LDisc := Discretise(LModel, LT, LMethod);
    ShowText(redP1Result, DiscreteReport(LModel, LDisc, LT, LMethod));
    LZ := Eigenvalues(LDisc.A);
    PlotPoles(LZ);
    Log('INFO', 'System ' + IntToStr(rgP1System.ItemIndex + 1) + ' discretised (' + C_METHOD_NAMES[LMethod] +
      ', T = ' + FmtG(LT, 6) + ' s). Largest |z| = ' + FmtG(CAbs(LZ[0]), 13) + '.');
    if CAbs(LZ[0]) > 1.0 + 1.0e-12 then
      Log('WARNING', 'A pole lies outside the unit circle: the step and impulse responses grow ' +
        'without bound (s = ' + ComplexToText(Eigenvalues(LModel.A)[0], 6) + ').');
  except
    on E: EMPCError do
      Fail(E.Message);
  end;
end;

procedure TForm1.btnP1SimulateClick(Sender: TObject);
var
  LModel, LDisc: TStateModel;
  LT, LTEnd, LAmp, LPulse: Double;
  LN: Integer;
  LStep, LImp, LExS, LExI: TResponse;
begin
  if not ReadP1(LModel, LT, LTEnd, LAmp) then
    Exit;
  LN := Round(LTEnd / LT);
  try
    LDisc := Discretise(LModel, LT, SelectedMethod(rgP1Method));
    LStep := Simulate(LDisc, LN, LT, ikStep, LAmp);
    { area 1: u(0) = amplitude / T, comparable with the continuous impulse }
    if chkP1PulseArea.Checked then
      LPulse := LAmp / LT
    else
      LPulse := LAmp;
    LImp := Simulate(LDisc, LN, LT, ikPulse, LPulse);
    ClearChart(chtP1Step);
    ClearChart(chtP1Imp);
    PlotResponse(serP1Step, LStep.T, LStep.Y);
    PlotResponse(serP1Imp, LImp.T, LImp.Y);
    if chkP1Exact.Checked then
    begin
      LExS := ExactSampled(LModel, LN, LT, ikStep, LAmp);
      PlotResponse(serP1StepExact, LExS.T, LExS.Y);
      if chkP1PulseArea.Checked then
      begin
        LExI := ExactSampled(LModel, LN, LT, ikPulse, LAmp);
        PlotResponse(serP1ImpExact, LExI.T, LExI.Y);
      end
      else
        Log('INFO', 'The exact impulse response is drawn only for the pulse of area 1 (check box).');
    end;
    if chkP1PulseArea.Checked then
      chtP1Imp.Title.Text.Text := 'Impulse response: pulse u(0) = 1/T (area 1)'
    else
      chtP1Imp.Title.Text.Text := 'Impulse response: unit pulse u(0) = 1 (Markov parameters)';
    btnP1DiscretiseClick(nil);
    Log('INFO', 'Step and impulse responses of system ' + IntToStr(rgP1System.ItemIndex + 1) + ': ' +
      IntToStr(LN + 1) + ' samples, max |step y| = ' + FmtG(Max(MaxValue(LStep.Y), -MinValue(LStep.Y)), 6) + '.');
  except
    on E: EMPCError do
      Fail(E.Message);
  end;
end;

{ Problem 2 }

function TForm1.ReadP2Plant(out AModel: TStateModel; out AT: Double; out ASamples: Integer): Boolean;
var
  LA1, LA0, LB0: Double;
begin
  Result := False;
  if not (ReadValue(vleP2Plant, C_KEY_A1, LA1) and ReadValue(vleP2Plant, C_KEY_A0, LA0) and
    ReadValue(vleP2Plant, C_KEY_B0, LB0) and ReadValue(vleP2Data, C_KEY_T2, AT) and
    ReadCount(vleP2Data, C_KEY_N2, 10, 5000, ASamples)) then
    Exit;
  if LB0 = 0 then
  begin
    Fail('b0 = 0 leaves the plant without input: the step data would be zero.');
    Exit;
  end;
  if AT <= 0 then
  begin
    Fail('The sampling interval T must be positive (the sheet uses 0.1 s).');
    Exit;
  end;
  if (SelectedMethod(rgP2Source) = dmLecture) and (AT >= 2) then
  begin
    Fail('The lecture formula divides by 1 - T/2, so T must be below 2 s.');
    Exit;
  end;
  if (LA1 < 0) or (LA0 <= 0) then
    Log('WARNING', 'a1 < 0 or a0 <= 0: the plant is not stable, the step data grow.');
  { x1 = x, x2 = x', y = x (report Equation 2.4) }
  AModel.A := MatFromArray(2, 2, [0, 1, -LA0, -LA1]);
  AModel.B := MatFromArray(2, 1, [0, LB0]);
  AModel.C := MatFromArray(1, 2, [1, 0]);
  AModel.D := MatFromArray(1, 1, [0]);
  Result := True;
end;

procedure TForm1.PlotStepData(const AData: TVector; AT: Double);
var
  LK: Integer;
  LG: TVector;
begin
  ClearChart(chtP2Step);
  ClearChart(chtP2Markov);
  LG := MarkovFromStep(AData);
  for LK := 0 to High(AData) do
  begin
    serP2Data.AddXY(LK * AT, AData[LK]);
    serP2Markov.AddXY(LK, LG[LK]);
  end;
end;

procedure TForm1.btnP2DataClick(Sender: TObject);
var
  LModel: TStateModel;
  LT: Double;
  LN: Integer;
  LS: TVector;
begin
  if not ReadP2Plant(LModel, LT, LN) then
    Exit;
  try
    LS := StepData(LModel, LT, SelectedMethod(rgP2Source), LN);
    PlotStepData(LS, LT);
    Log('INFO', IntToStr(LN) + ' step samples (' + C_METHOD_NAMES[SelectedMethod(rgP2Source)] + ', T = ' +
      FmtG(LT, 6) + ' s): S(1) = ' + FmtG(LS[1], 8) + ', S(' + IntToStr(LN - 1) + ') = ' + FmtG(LS[LN - 1], 8) + '.');
  except
    on E: EMPCError do
      Fail(E.Message);
  end;
end;

procedure TForm1.btnP2IdentifyClick(Sender: TObject);
var
  LModel, LDisc: TStateModel;
  LT, LTol: Double;
  LN, LK, LL, LOrder, LI: Integer;
  LS: TVector;
  LR: THoKalman;
  LSb: TStringList;
  LZ: TComplexArray;
  LP3: TStateModel;
begin
  if not ReadP2Plant(LModel, LT, LN) then
    Exit;
  if not (ReadCount(vleP2Hankel, C_KEY_K, 1, 50, LK) and ReadCount(vleP2Hankel, C_KEY_L, 1, 50, LL) and
    ReadCount(vleP2Hankel, C_KEY_ORDER, 0, 50, LOrder) and ReadValue(vleP2Hankel, C_KEY_TOL, LTol)) then
    Exit;
  if (LTol <= 0) or (LTol >= 1) then
  begin
    Fail('The order tolerance must lie between 0 and 1 (default 1E-8).');
    Exit;
  end;
  if LK + LL + 1 > LN then
  begin
    Fail('A ' + IntToStr(LK) + ' x ' + IntToStr(LL) + ' Hankel matrix and its shifted copy need ' +
      IntToStr(LK + LL + 1) + ' step samples; only ' + IntToStr(LN) + ' are set.');
    Exit;
  end;
  if LOrder > Min(LK, LL) then
  begin
    Fail('The order n cannot exceed min(k, l) = ' + IntToStr(Min(LK, LL)) + '.');
    Exit;
  end;
  try
    LS := StepData(LModel, LT, SelectedMethod(rgP2Source), LN);
    LR := HoKalman(LS, LK, LL, LOrder, LTol);
    FP2Result := LR;
    FP2Header := '# Problem 2, Ho-Kalman realisation from step data' + sLineBreak +
      '# plant x'''' = -' + vleP2Plant.Values[C_KEY_A1] + ' x'' - ' + vleP2Plant.Values[C_KEY_A0] + ' x + ' +
      vleP2Plant.Values[C_KEY_B0] + ' u, T = ' + FmtG(LT, 6) + ' s, ' + C_METHOD_NAMES[SelectedMethod(rgP2Source)] +
      sLineBreak + '# Hankel ' + IntToStr(LK) + ' x ' + IntToStr(LL) + ', order tolerance ' + FmtG(LTol, 3);
    PlotStepData(LS, LT);
    ClearChart(chtP2Sigma);
    for LI := 0 to High(LR.SVD.S) do
      serP2Sigma.AddXY(LI + 1, Log10(Max(LR.SVD.S[LI], C_SIGMA_FLOOR)));
    { a linear axis of log10 sigma: a logarithmic TeeChart axis has no
      valid range while its series are empty (after CLEAR) }
    serP2Tol.AddXY(1, Log10(Max(LTol * LR.SVD.S[0], C_SIGMA_FLOOR)));
    serP2Tol.AddXY(Length(LR.SVD.S), Log10(Max(LTol * LR.SVD.S[0], C_SIGMA_FLOOR)));
    if not LR.Ok then
    begin
      ShowText(redP2Result, HoKalmanText(LR, FP2Header));
      Fail('Ho-Kalman: ' + LR.Reason);
      Exit;
    end;
    for LI := 0 to High(LR.ModelStep) do
      serP2Model.AddXY(LI * LT, LR.ModelStep[LI]);
    serP2MarkovModel.AddXY(0, LR.Model.D[0][0]);
    for LI := 1 to High(LR.ModelStep) do
      serP2MarkovModel.AddXY(LI, LR.ModelStep[LI] - LR.ModelStep[LI - 1]);
    LSb := TStringList.Create;
    try
      LSb.Text := HoKalmanText(LR, FP2Header);
      LDisc := Discretise(LModel, LT, SelectedMethod(rgP2Source));
      LZ := Eigenvalues(LDisc.A);
      LSb.Add('# Eigenvalues of Ad of the analytic model (same discretisation):');
      for LI := 0 to High(LZ) do
        LSb.Add(ComplexToText(LZ[LI], 15));
      LP3 := ModelP3Plant;
      if (LR.Order = 2) then
        LSb.Add('# Difference to the plant of Problem 3 (max |A|, |B|, |C| entry): ' + FmtG(Max(
          MatMaxAbsDiff(LR.Model.A, LP3.A), Max(MatMaxAbsDiff(LR.Model.B, LP3.B),
          MatMaxAbsDiff(LR.Model.C, LP3.C))), 4));
      ShowText(redP2Result, LSb.Text);
    finally
      LSb.Free;
    end;
    Log('INFO', 'Ho-Kalman: order ' + IntToStr(LR.Order) + ' from sigma = ' + FmtG(LR.SVD.S[0], 6) + ', ' +
      FmtG(LR.SVD.S[Min(1, High(LR.SVD.S))], 6) + ' (' + IntToStr(LR.SVD.Sweeps) + ' Jacobi sweeps); ' +
      'max |model step - data| = ' + FmtG(LR.MaxStepError, 3) + '.');
    if LR.MaxStepError > 1.0e-6 * Max(1.0, MaxValue(LS)) then
      Log('WARNING', 'The model does not reproduce the data within 1E-6: a higher order or a larger ' +
        'Hankel matrix may be needed.');
  except
    on E: EMPCError do
      Fail(E.Message);
  end;
end;

procedure TForm1.btnP2SaveClick(Sender: TObject);
var
  LWriter: TStreamWriter;
begin
  if Length(FP2Result.G) = 0 then
  begin
    Warn('Run Ho-Kalman (SVD) first: there is no process data to save yet.');
    Exit;
  end;
  SaveDialogDAT.FileName := 'hokalman_process_data.dat';
  if not SaveDialogDAT.Execute then
    Exit;
  try
    LWriter := TStreamWriter.Create(SaveDialogDAT.FileName, False, TEncoding.UTF8);
    try
      LWriter.Write(HoKalmanText(FP2Result, FP2Header));
    finally
      LWriter.Free;
    end;
    Log('INFO', 'Saved the Ho-Kalman process data to ' + SaveDialogDAT.FileName);
  except
    on E: Exception do
      Fail('The .dat file could not be written: ' + E.Message);
  end;
end;

procedure TForm1.btnP2ToObserverClick(Sender: TObject);
begin
  if not FP2Result.Ok then
  begin
    Warn('Run Ho-Kalman (SVD) first: there is no identified model yet.');
    Exit;
  end;
  if FP2Result.Order <> 2 then
  begin
    Warn('The observer formula of Problem 3 needs a second-order model; the identified order is ' +
      IntToStr(FP2Result.Order) + '.');
    Exit;
  end;
  rgP3Preset.ItemIndex := 1;
  PageControl1.ActivePage := tsP3;
  Log('INFO', 'The Ho-Kalman model of Problem 2 is now the plant of Problem 3.');
end;

{ Problem 3 }

procedure TForm1.rgP3PresetClick(Sender: TObject);
begin
  case rgP3Preset.ItemIndex of
    1:
      begin
        if (not FP2Result.Ok) or (FP2Result.Order <> 2) then
        begin
          Warn('No second-order Ho-Kalman model yet: run Ho-Kalman (SVD) on the Problem 2 tab first.');
          rgP3Preset.ItemIndex := 0;
          Exit;
        end;
        ShowModel(vleP3Plant, FP2Result.Model, 10);
        vleP3Plant.Values[C_KEY_P1] := '0.8';
        vleP3Plant.Values[C_KEY_P2] := '0.7';
        Log('INFO', 'Plant = Ho-Kalman model of Problem 2 (rounded to 10 digits).');
      end;
    2:
      begin
        ShowModel(vleP3Plant, ModelPendulumSlides, 10);
        vleP3Plant.Values[C_KEY_P1] := '0.1';
        vleP3Plant.Values[C_KEY_P2] := '0.2';
        Log('INFO', 'Plant = pendulum of the lecture slides (p. 26), observer poles 0.1 and 0.2.');
      end;
  else
    ShowModel(vleP3Plant, ModelP3Plant, 10);
    vleP3Plant.Values[C_KEY_P1] := '0.8';
    vleP3Plant.Values[C_KEY_P2] := '0.7';
    Log('INFO', 'Plant = Problem 3 of the sheet, observer poles 0.8 and 0.7.');
  end;
end;

function TForm1.ReadP3(out AModel: TStateModel; out AP1, AP2: Double): Boolean;
begin
  Result := False;
  if not (ReadModel(vleP3Plant, AModel) and ReadValue(vleP3Plant, C_KEY_P1, AP1) and
    ReadValue(vleP3Plant, C_KEY_P2, AP2)) then
    Exit;
  if ModelOrder(AModel) <> 2 then
  begin
    Fail('The closed form of Problem 3a is for a 2 x 2 plant (two rows "A row 1" and "A row 2").');
    Exit;
  end;
  if (Abs(AP1) >= 1) or (Abs(AP2) >= 1) then
    Log('WARNING', 'An observer pole with |p| >= 1 gives an error that does not decay.');
  Result := True;
end;

procedure TForm1.btnP3GainClick(Sender: TObject);
var
  LModel: TStateModel;
  LP1, LP2: Double;
  LG: TObserverGain;
  LSb: TStringList;
  LI: Integer;
begin
  if not ReadP3(LModel, LP1, LP2) then
    Exit;
  LG := ObserverGain2(LModel.A, LModel.C, LP1, LP2);
  LSb := TStringList.Create;
  try
    LSb.Add('det(lambda I - (A - Kob C)) = (lambda - p1)(lambda - p2),  p1 = ' + FmtG(LP1, 10) + ', p2 = ' +
      FmtG(LP2, 10));
    LSb.Add('');
    LSb.Add('Observability  det [C; CA] = ' + FmtG(LG.DetObs, 12));
    LSb.Add('alpha = A11 + A22 - (p1 + p2) = ' + FmtG(LG.Alpha, 12));
    LSb.Add('beta  = det A - p1 p2         = ' + FmtG(LG.Beta, 12));
    LSb.Add('det M = C1 (A11 C2 - A12 C1) - C2 (C1 A22 - C2 A21) = ' + FmtG(LG.DetM, 12));
    LSb.Add('');
    if LG.Ok then
    begin
      LSb.Add('Kob:');
      LSb.Add(FmtG(LG.K[0], 12));
      LSb.Add(FmtG(LG.K[1], 12));
      LSb.Add('');
      LSb.Add('Eigenvalues of A (open-loop model):');
      for LI := 0 to High(LG.EigPlant) do
        LSb.Add('  ' + ComplexToText(LG.EigPlant[LI], 10) + '   |z| = ' + FmtG(CAbs(LG.EigPlant[LI]), 8));
      LSb.Add('Eigenvalues of A - Kob C (observer error):');
      for LI := 0 to High(LG.EigError) do
        LSb.Add('  ' + ComplexToText(LG.EigError[LI], 13));
      Log('INFO', 'Kob = [' + FmtG(LG.K[0], 9) + '; ' + FmtG(LG.K[1], 9) + '], error poles ' +
        ComplexToText(LG.EigError[0], 10) + ' and ' + ComplexToText(LG.EigError[1], 10) + '.');
    end
    else
    begin
      LSb.Add(LG.Reason);
      Fail(LG.Reason);
    end;
    ShowText(redP3Result, LSb.Text);
  finally
    LSb.Free;
  end;
end;

procedure TForm1.btnP3SimulateClick(Sender: TObject);
var
  LModel: TStateModel;
  LP1, LP2, LU: Double;
  LN, LK: Integer;
  LX0, LXh0: TVector;
  LG: TObserverGain;
  LRun: TObserverRun;
begin
  if not (ReadP3(LModel, LP1, LP2) and ReadRow(vleP3Sim, C_KEY_X0, 2, LX0) and
    ReadRow(vleP3Sim, C_KEY_XH0, 2, LXh0) and ReadValue(vleP3Sim, C_KEY_U, LU) and
    ReadCount(vleP3Sim, C_KEY_N3, 2, 2000, LN)) then
    Exit;
  LG := ObserverGain2(LModel.A, LModel.C, LP1, LP2);
  if not LG.Ok then
  begin
    Fail(LG.Reason);
    Exit;
  end;
  if SameValue(LX0[0], LXh0[0]) and SameValue(LX0[1], LXh0[1]) then
    Log('WARNING', 'x(0) = x^(0): the error is zero from the start, so the observer has nothing to correct.');
  try
    LRun := SimulateObserver(LModel, LG.K, LX0, LXh0, LU, LN);
    btnP3GainClick(nil);
    ClearChart(chtP3Err);
    ClearChart(chtP3X1);
    ClearChart(chtP3X2);
    for LK := 0 to LN do
    begin
      serP3ErrObs.AddXY(LK, LRun.ErrObs[LK]);
      serP3ErrOpen.AddXY(LK, LRun.ErrOpen[LK]);
      serP3X1.AddXY(LK, LRun.X[LK][0]);
      serP3Xo1.AddXY(LK, LRun.XObs[LK][0]);
      serP3Xm1.AddXY(LK, LRun.XOpen[LK][0]);
      serP3X2.AddXY(LK, LRun.X[LK][1]);
      serP3Xo2.AddXY(LK, LRun.XObs[LK][1]);
      serP3Xm2.AddXY(LK, LRun.XOpen[LK][1]);
    end;
    Log('INFO', 'Observer run of ' + IntToStr(LN) + ' samples: |error| at k = ' + IntToStr(Min(LN, 30)) +
      ' is ' + FmtG(LRun.ErrObs[Min(LN, 30)], 4) + ' (observer) and ' + FmtG(LRun.ErrOpen[Min(LN, 30)], 4) +
      ' (open-loop model).');
  except
    on E: EMPCError do
      Fail(E.Message);
  end;
end;

{ Header buttons }

procedure TForm1.btnEquationsClick(Sender: TObject);
begin
  FormEquations.Show;
  FormEquations.BringToFront;
end;

procedure TForm1.btnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.btnClearClick(Sender: TObject);
var
  LChart: TChart;
begin
  if MessageDlg('Clear every chart, result and message?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;
  for LChart in TArray<TChart>.Create(chtP1Poles, chtP1Step, chtP1Imp, chtP2Step, chtP2Markov, chtP2Sigma,
    chtP3Err, chtP3X1, chtP3X2) do
    ClearChart(LChart);
  redP1Result.Clear;
  redP2Result.Clear;
  redP3Result.Clear;
  FP2Result := Default(THoKalman);
  FP2Header := '';
  if rgP3Preset.ItemIndex = 1 then
  begin
    rgP3Preset.ItemIndex := 0;
    rgP3PresetClick(nil);
  end;
  redLog.Clear;
  Log('INFO', 'All outputs cleared. The input tables keep their values.');
end;

function TForm1.ActiveCharts: TArray<TChart>;
begin
  if PageControl1.ActivePage = tsP2 then
    Result := TArray<TChart>.Create(chtP2Step, chtP2Markov, chtP2Sigma)
  else if PageControl1.ActivePage = tsP3 then
    Result := TArray<TChart>.Create(chtP3Err, chtP3X1, chtP3X2)
  else
    Result := TArray<TChart>.Create(chtP1Poles, chtP1Step, chtP1Imp);
end;

{ Every series with points of the active tab, one row per point:
  chart, series, x, y. }
procedure TForm1.btnExportCSVClick(Sender: TObject);
var
  LWriter: TStreamWriter;
  LChart: TChart;
  LI, LJ, LRows: Integer;
begin
  LRows := 0;
  for LChart in ActiveCharts do
    for LI := 0 to LChart.SeriesCount - 1 do
      Inc(LRows, LChart.Series[LI].Count);
  if LRows = 0 then
  begin
    Warn('Nothing to export on this tab yet: run a computation first.');
    Exit;
  end;
  SaveDialogCSV.FileName := 'mpc_' + LowerCase(PageControl1.ActivePage.Name) + '.csv';
  if not SaveDialogCSV.Execute then
    Exit;
  try
    LWriter := TStreamWriter.Create(SaveDialogCSV.FileName, False, TEncoding.UTF8);
    try
      LWriter.WriteLine('chart,series,x,y');
      for LChart in ActiveCharts do
        for LI := 0 to LChart.SeriesCount - 1 do
          for LJ := 0 to LChart.Series[LI].Count - 1 do
            LWriter.WriteLine(LChart.Name + ',"' + LChart.Series[LI].Title + '",' +
              FmtG(LChart.Series[LI].XValue[LJ], 15) + ',' + FmtG(LChart.Series[LI].YValue[LJ], 15));
    finally
      LWriter.Free;
    end;
    Log('INFO', 'Saved ' + IntToStr(LRows) + ' points to ' + SaveDialogCSV.FileName);
  except
    on E: Exception do
      Fail('The CSV file could not be written: ' + E.Message);
  end;
end;

{ The charts of the active tab as one PNG, in the layout of the window. }
procedure TForm1.btnExportPNGClick(Sender: TObject);
var
  LBmp: TBitmap;
  LPng: TPngImage;
  LChart: TChart;
  LCharts: TArray<TChart>;
  LOrigin: TPoint;
  LW, LH: Integer;
begin
  LCharts := ActiveCharts;
  SaveDialogPNG.FileName := 'mpc_' + LowerCase(PageControl1.ActivePage.Name) + '.png';
  if not SaveDialogPNG.Execute then
    Exit;
  try
    LBmp := TBitmap.Create;
    try
      LBmp.PixelFormat := pf24bit;
      LW := 0;
      LH := 0;
      for LChart in LCharts do
      begin
        LW := Max(LW, LChart.Left + LChart.Width);
        LH := Max(LH, LChart.Top + LChart.Height);
      end;
      LBmp.SetSize(LW, LH);
      LBmp.Canvas.Brush.Color := clWhite;
      LBmp.Canvas.FillRect(Rect(0, 0, LW, LH));
      for LChart in LCharts do
      begin
        LOrigin := Point(LChart.Left, LChart.Top);
        LChart.Draw(LBmp.Canvas, Rect(LOrigin.X, LOrigin.Y, LOrigin.X + LChart.Width,
          LOrigin.Y + LChart.Height));
      end;
      LPng := TPngImage.Create;
      try
        LPng.Assign(LBmp);
        LPng.SaveToFile(SaveDialogPNG.FileName);
      finally
        LPng.Free;
      end;
    finally
      LBmp.Free;
    end;
    Log('INFO', 'Saved ' + SaveDialogPNG.FileName);
  except
    on E: Exception do
      Fail('The PNG file could not be written: ' + E.Message);
  end;
end;

end.
