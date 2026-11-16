unit Unit1;

{
  Unit1.pas - Main form of the Ziegler-Nichols PID tuning program
  (Biocybernetics Assignment 3, Preliminary Assignment).

  Author : Jeremia Christ Immanuel Manalu (5023231017)

  One tab per part of the assignment:
    Plant Model and RK4   Problems 1 and 2: impulse and step response of
                          each plant (RK4), tangent, R, L, T, K, MP, %MP
    ZN Method 1           Problem 3: R and L, Kp, Ki, Kd of Table 1.1,
                          closed loop with P, PI or PID (PID Output ZN1)
    ZN Method 2           Problem 3: Ku and Pu, Kp, Ki, Kd of Table 1.2,
                          closed loop (PID Output ZN2)
  R, L, Ku, Pu, Kp, Ki and Kd can be edited and the closed loop rerun.

  Every control and chart is designed in Unit1.dfm. Buttons and cards are
  TPanels; the interposer class below only paints them (gradient, hover
  and pressed state) according to their Tag, so they stay visible in the
  Form Designer. The code reads the inputs and fills the series.

  Keys and mouse: F1 opens the equation sheet (Unit2). Over a chart the
  wheel zooms at the cursor (Shift + wheel: time axis only), a drag to the
  lower right zooms into a box, a right drag pans and a double click
  restores the full view.
}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.Types, System.Math, System.UITypes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.ValEdit,
  Vcl.ComCtrls, Vcl.GraphUtil, Vcl.Imaging.pngimage, VCLTee.TeEngine,
  VCLTee.TeeProcs, VCLTee.Chart, VCLTee.Series, ZNModel;

type
  { Interposer: the TPanels of Unit1.dfm become this class at run time.
    Tag 0 = normal panel, 1 to 6 = button colours, 11 = page header,
    10 and 12 to 16 = card with a gradient title strip whose colour shows
    the role of the card: 10 actions (blue), 12 editable inputs (green),
    13 messages and warnings (red to orange), 14 computed results (teal),
    15 help (slate), 16 closed-loop performance (indigo). }
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

  TForm1 = class(TForm)
    pnlHeader: TPanel;
    lblTitle: TLabel;
    lblSubtitle: TLabel;
    btnEquations: TPanel;
    btnExportCSV: TPanel;
    btnExportPNG: TPanel;
    btnClear: TPanel;
    btnExit: TPanel;
    pnlSettings: TPanel;
    cardSettings: TPanel;
    vleParams: TValueListEditor;
    lblSettingsNote: TLabel;
    cardLog: TPanel;
    redLog: TRichEdit;
    PageControl1: TPageControl;
    tsPlant: TTabSheet;
    pnlPlantBg: TPanel;
    pnlPlantSide: TPanel;
    cardImpulse: TPanel;
    btnImpulse1: TPanel;
    btnImpulse2: TPanel;
    cardStep: TPanel;
    btnStep1: TPanel;
    btnStep2: TPanel;
    cardModel: TPanel;
    lblR: TLabel;
    edtR: TEdit;
    lblL: TLabel;
    edtL: TEdit;
    lblT: TLabel;
    edtT: TEdit;
    lblK: TLabel;
    edtK: TEdit;
    lblMP: TLabel;
    edtMP: TEdit;
    lblPMP: TLabel;
    edtPMP: TEdit;
    cardPlantNote: TPanel;
    lblPlantNote: TLabel;
    gpPlant: TGridPanel;
    chtImpulse: TChart;
    serImpY: TFastLineSeries;
    serImpPeak: TPointSeries;
    chtStep: TChart;
    serStepY: TFastLineSeries;
    serStepTangent: TLineSeries;
    serStepInfl: TPointSeries;
    serStepLT: TPointSeries;
    serStepPeak: TPointSeries;
    tsZN1: TTabSheet;
    pnlZN1Bg: TPanel;
    pnlZN1Side: TPanel;
    cardZN1Plant: TPanel;
    btnZN1Plant1: TPanel;
    btnZN1Plant2: TPanel;
    cardZN1Ctrl: TPanel;
    rgZN1Ctrl: TRadioGroup;
    cardZN1Param: TPanel;
    lblZN1R: TLabel;
    edtZN1R: TEdit;
    lblZN1L: TLabel;
    edtZN1L: TEdit;
    btnZN1Gains: TPanel;
    cardZN1PID: TPanel;
    lblZN1Kp: TLabel;
    edtZN1Kp: TEdit;
    lblZN1Ki: TLabel;
    edtZN1Ki: TEdit;
    lblZN1Kd: TLabel;
    edtZN1Kd: TEdit;
    btnZN1Run: TPanel;
    cardZN1Perf: TPanel;
    lblZN1Rise: TLabel;
    edtZN1Rise: TEdit;
    lblZN1OS: TLabel;
    edtZN1OS: TEdit;
    lblZN1Max: TLabel;
    edtZN1Max: TEdit;
    lblZN1Ts: TLabel;
    edtZN1Ts: TEdit;
    lblZN1Ess: TLabel;
    edtZN1Ess: TEdit;
    lblZN1IAE: TLabel;
    edtZN1IAE: TEdit;
    lblZN1ISE: TLabel;
    edtZN1ISE: TEdit;
    lblZN1Stab: TLabel;
    gpZN1: TGridPanel;
    chtZN1Curve: TChart;
    serZN1CurveY: TFastLineSeries;
    serZN1Tangent: TLineSeries;
    serZN1LT: TPointSeries;
    chtZN1Y: TChart;
    serZN1Ref: TFastLineSeries;
    serZN1Y: TFastLineSeries;
    chtZN1U: TChart;
    serZN1U: TFastLineSeries;
    tsZN2: TTabSheet;
    pnlZN2Bg: TPanel;
    pnlZN2Side: TPanel;
    cardZN2Plant: TPanel;
    btnZN2Plant1: TPanel;
    btnZN2Plant2: TPanel;
    cardZN2Ctrl: TPanel;
    rgZN2Ctrl: TRadioGroup;
    cardZN2Param: TPanel;
    lblZN2Ku: TLabel;
    edtZN2Ku: TEdit;
    lblZN2Pu: TLabel;
    edtZN2Pu: TEdit;
    btnZN2TestKu: TPanel;
    btnZN2Gains: TPanel;
    cardZN2PID: TPanel;
    lblZN2Kp: TLabel;
    edtZN2Kp: TEdit;
    lblZN2Ki: TLabel;
    edtZN2Ki: TEdit;
    lblZN2Kd: TLabel;
    edtZN2Kd: TEdit;
    btnZN2Run: TPanel;
    cardZN2Perf: TPanel;
    lblZN2Rise: TLabel;
    edtZN2Rise: TEdit;
    lblZN2OS: TLabel;
    edtZN2OS: TEdit;
    lblZN2Max: TLabel;
    edtZN2Max: TEdit;
    lblZN2Ts: TLabel;
    edtZN2Ts: TEdit;
    lblZN2Ess: TLabel;
    edtZN2Ess: TEdit;
    lblZN2IAE: TLabel;
    edtZN2IAE: TEdit;
    lblZN2ISE: TLabel;
    edtZN2ISE: TEdit;
    lblZN2Stab: TLabel;
    gpZN2: TGridPanel;
    chtZN2Ku: TChart;
    serZN2KuY: TFastLineSeries;
    serZN2KuRef: TFastLineSeries;
    serZN2KuPeaks: TPointSeries;
    chtZN2Y: TChart;
    serZN2Ref: TFastLineSeries;
    serZN2Y: TFastLineSeries;
    chtZN2U: TChart;
    serZN2U: TFastLineSeries;
    StatusBar1: TStatusBar;
    SaveDialogCSV: TSaveDialog;
    SaveDialogPNG: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnEquationsClick(Sender: TObject);
    procedure btnExportCSVClick(Sender: TObject);
    procedure btnExportPNGClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure btnImpulse1Click(Sender: TObject);
    procedure btnImpulse2Click(Sender: TObject);
    procedure btnStep1Click(Sender: TObject);
    procedure btnStep2Click(Sender: TObject);
    procedure btnZN1Plant1Click(Sender: TObject);
    procedure btnZN1Plant2Click(Sender: TObject);
    procedure rgZN1CtrlClick(Sender: TObject);
    procedure btnZN1GainsClick(Sender: TObject);
    procedure btnZN1RunClick(Sender: TObject);
    procedure btnZN2Plant1Click(Sender: TObject);
    procedure btnZN2Plant2Click(Sender: TObject);
    procedure rgZN2CtrlClick(Sender: TObject);
    procedure btnZN2TestKuClick(Sender: TObject);
    procedure btnZN2GainsClick(Sender: TObject);
    procedure btnZN2RunClick(Sender: TObject);
    procedure ChartDblClick(Sender: TObject);
  private
    FZN1Plant: Integer;   { -1 = no plant selected yet }
    FZN2Plant: Integer;
    FZN1M: TMethod1Result;
    FZN2M: TMethod2Result;
    FLastError: string;          { last unexpected error and when it was shown }
    FLastErrorTime: TDateTime;
    procedure AppException(Sender: TObject; E: Exception);
    procedure SetStatus(const AText: string);
    procedure Log(const ALevel, AText: string);
    procedure Warn(const AText: string);
    procedure Fail(const AText: string);
    function ReadSettings(out ASettings: TSimSettings): Boolean;
    function ReadNumber(AEdit: TEdit; const AName: string; out AValue: Double): Boolean;
    procedure ShowValue(AEdit: TEdit; AValue: Double; const AFormat: string = '0.0000');
    function ControllerOf(ARadio: TRadioGroup): TControllerKind;
    procedure ClearChart(AChart: TChart);
    procedure FinishChart(AChart: TChart);
    procedure ZoomAxis(AAxis: TChartAxis; const AFactor, ACenter: Double);
    procedure ZoomChart(AChart: TChart; const AFactor: Double; const APoint: TPoint; AXOnly: Boolean);
    procedure ResetChart(AChart: TChart);
    procedure PlotResponse(ASeries: TChartSeries; const AResp: TResponse; ALimit: Double;
      AUseU: Boolean = False);
    procedure PlotPeaks(ASeries: TChartSeries; const AResp: TResponse; ALimit: Double);
    procedure RunImpulse(APlant: TPlantKind);
    procedure RunStep(APlant: TPlantKind);
    function ZN1Identify(APlant: TPlantKind): Boolean;
    function ZN1Gains: Boolean;
    function ZN2Identify(APlant: TPlantKind): Boolean;
    function ZN2Gains: Boolean;
    procedure RunClosed(APlantIndex: Integer; ARadio: TRadioGroup; EKp, EKi, EKd: TEdit;
      ARef, AY, AU: TChartSeries; AChtY, AChtU: TChart; const APerf: array of TEdit;
      AStab: TLabel; const ATag: string);
    procedure ClearPerf(const APerf: array of TEdit; AStab: TLabel);
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
  C_KEY_DT = 'Time step dt (s)';
  C_KEY_TEND = 'Simulation time (s)';
  C_KEY_THETA = 'Dead time theta (s)';
  C_KEY_STEP = 'Step amplitude x0 (-)';
  C_KEY_SETPOINT = 'Setpoint r (-)';
  C_MAX_STEPS = 2000000;
  C_MAX_DT = 0.05;
  C_LARGE_GAIN = 1.0e4;
  { an unstable response is drawn until |y| leaves this multiple of |r| }
  C_PLOT_LIMIT = 3.0;
  C_TAG_CARD = 10;
  C_TAG_HEADER = 11;
  C_TAG_CARD_LAST = 16;
  C_CARD_STRIP = 26;
  C_ZOOM_IN = 0.8;
  C_ZOOM_OUT = 1.25;
  { the same unexpected error is shown at most once in this time (days) }
  C_ERROR_PAUSE = 2.0 / 86400.0;
  C_ERROR_LOG = 'ZNTuning_error.log';
  C_CTRL_NAMES: array[TControllerKind] of string = ('P', 'PI', 'PID');

function Fmt(AValue: Double; const AFormat: string = '0.0000'): string;
begin
  Result := FormatFloat(AFormat, AValue, TFormatSettings.Invariant);
end;

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
    GradientFillCanvas(Canvas, RGB(13, 71, 161), RGB(0, 131, 143), LRect, gdHorizontal);
    Exit;
  end;
  if IsCard then
  begin
    { strip colours by role, see the class comment }
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
      15:
        begin
          LTop := RGB(55, 71, 79);
          LBottom := RGB(120, 144, 156);
        end;
      16:
        begin
          LTop := RGB(49, 27, 146);
          LBottom := RGB(126, 87, 194);
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
  { buttons: top and bottom colour of the vertical gradient }
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

{ TForm1: general }

procedure TForm1.FormCreate(Sender: TObject);
begin
  FormatSettings.DecimalSeparator := '.';
  Application.OnException := AppException;
  FZN1Plant := -1;
  FZN2Plant := -1;
  Log('INFO', 'Ready. Tab 1: impulse and step response (Problems 1, 2). Tabs 2 and 3: ' +
    'Ziegler-Nichols Method 1 and Method 2 (Problem 3).');
  Log('INFO', 'Charts: wheel = zoom at the cursor, Shift + wheel = time axis only, drag to the ' +
    'lower right = zoom box, right drag = pan, double click = full view.');
  SetStatus('Ready. Choose a tab and press Plant 1 or Plant 2.');
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F1 then
  begin
    btnEquationsClick(nil);
    Key := 0;
  end;
end;

{ Unexpected errors end up here instead of closing the program. Each one
  is appended to ZNTuning_error.log next to the exe; the same error is
  shown at most once every 2 s, so an error raised while a control paints
  cannot open one dialog after another (ISS-069). }
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
    { writing the log must never raise a second error from this handler,
      for example in a read-only folder; the dialog below still appears }
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
  TeeChart's own wheel scrolling (EInvalidCast in Assignment 1, ISS-019)
  never runs. Shift + wheel zooms the time axis only. }
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

{ The axis range shrinks (AFactor < 1) or grows around ACenter. }
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

{ Simulation settings of the left panel; accepts '.' and ',' as decimal
  separator. Returns False (after a message) when an input is not usable. }
function TForm1.ReadSettings(out ASettings: TSimSettings): Boolean;

  function Value(const AKey: string; out AValue: Double): Boolean;
  var
    LText: string;
  begin
    LText := Trim(StringReplace(vleParams.Values[AKey], ',', '.', [rfReplaceAll]));
    Result := TryStrToFloat(LText, AValue, TFormatSettings.Invariant);
    if not Result then
      Fail('"' + LText + '" is not a number (' + AKey + ').');
  end;

begin
  Result := False;
  if not (Value(C_KEY_DT, ASettings.Dt) and Value(C_KEY_TEND, ASettings.TEnd) and
    Value(C_KEY_THETA, ASettings.DeadTime) and Value(C_KEY_STEP, ASettings.StepAmp) and
    Value(C_KEY_SETPOINT, ASettings.Setpoint)) then
    Exit;
  if (ASettings.Dt <= 0) or (ASettings.Dt > C_MAX_DT) then
    Fail('dt must lie between 0 and ' + Fmt(C_MAX_DT, '0.00') + ' s (1 ms is the lecture value).')
  else if ASettings.TEnd <= 10 * ASettings.Dt then
    Fail('The simulation time must be longer than 10 time steps.')
  else if ASettings.TEnd / ASettings.Dt > C_MAX_STEPS then
    Fail('Too many steps (more than ' + IntToStr(C_MAX_STEPS) + '): increase dt or shorten the run.')
  else if (ASettings.DeadTime < 0) or (ASettings.DeadTime >= 0.5 * ASettings.TEnd) then
    Fail('The dead time theta must be 0 or positive and shorter than half the simulation time.')
  else if ASettings.StepAmp = 0 then
    Fail('The step amplitude x0 must not be 0.')
  else if ASettings.Setpoint = 0 then
    Fail('The setpoint r must not be 0.')
  else
  begin
    Result := True;
    if ASettings.Dt > 0.01 then
      Log('WARNING', 'dt = ' + Fmt(ASettings.Dt, '0.###') + ' s is coarse; results may differ ' +
        'from the report (1 ms).');
    if ASettings.TEnd < 15 then
      Log('WARNING', 'A run shorter than 15 s may end before plant 1 settles.');
  end;
end;

function TForm1.ReadNumber(AEdit: TEdit; const AName: string; out AValue: Double): Boolean;
var
  LText: string;
begin
  LText := Trim(StringReplace(AEdit.Text, ',', '.', [rfReplaceAll]));
  Result := TryStrToFloat(LText, AValue, TFormatSettings.Invariant) and not IsNan(AValue) and
    not IsInfinite(AValue);
  if not Result then
  begin
    Fail(AName + ': "' + AEdit.Text + '" is not a number.');
    if AEdit.CanFocus then
      AEdit.SetFocus;
  end;
end;

procedure TForm1.ShowValue(AEdit: TEdit; AValue: Double; const AFormat: string);
begin
  AEdit.Text := Fmt(AValue, AFormat);
end;

function TForm1.ControllerOf(ARadio: TRadioGroup): TControllerKind;
begin
  case ARadio.ItemIndex of
    0: Result := ckP;
    1: Result := ckPI;
  else
    Result := ckPID;
  end;
end;

{ The series are designed on the form and kept for the life of the
  program; clearing removes their points only (ISS-020, ISS-028). The
  legend of every chart is fixed in the form: hiding entries at run time
  while the legend shows check boxes raised an access violation (ISS-069),
  so each chart only holds the series it always shows. }
procedure TForm1.ClearChart(AChart: TChart);
var
  LI: Integer;
begin
  for LI := 0 to AChart.SeriesCount - 1 do
    AChart.Series[LI].Clear;
end;

{ After new points: full view (a zoom of the previous run is undone). }
procedure TForm1.FinishChart(AChart: TChart);
begin
  ResetChart(AChart);
end;

procedure TForm1.PlotResponse(ASeries: TChartSeries; const AResp: TResponse; ALimit: Double;
  AUseU: Boolean);
var
  LI: Integer;
begin
  for LI := 0 to AResp.Count - 1 do
  begin
    if Abs(AResp.Y[LI]) > ALimit then
      Break;
    if AUseU then
      ASeries.AddXY(AResp.T[LI], AResp.U[LI])
    else
      ASeries.AddXY(AResp.T[LI], AResp.Y[LI]);
  end;
end;

{ Local maxima in the second half of a response (the period Pu). }
procedure TForm1.PlotPeaks(ASeries: TChartSeries; const AResp: TResponse; ALimit: Double);
var
  LI: Integer;
begin
  for LI := Max(1, AResp.Count div 2) to AResp.Count - 2 do
    if (AResp.Y[LI] > AResp.Y[LI - 1]) and (AResp.Y[LI] >= AResp.Y[LI + 1]) and
      (Abs(AResp.Y[LI]) <= ALimit) then
      ASeries.AddXY(AResp.T[LI], AResp.Y[LI]);
end;

procedure TForm1.ClearPerf(const APerf: array of TEdit; AStab: TLabel);
var
  LI: Integer;
begin
  for LI := 0 to High(APerf) do
    APerf[LI].Text := '';
  AStab.Caption := 'Closed loop: not simulated yet';
  AStab.Font.Color := RGB(38, 50, 56);
end;

{ Tab 1: Problems 1 and 2 }

procedure TForm1.RunImpulse(APlant: TPlantKind);
var
  LS: TSimSettings;
  LResp: TResponse;
  LPeak, LTPeak: Double;
begin
  if not ReadSettings(LS) then
    Exit;
  SimulateImpulse(APlant, LS, LResp, LPeak, LTPeak);
  ClearChart(chtImpulse);
  PlotResponse(serImpY, LResp, MaxDouble);
  serImpPeak.AddXY(LTPeak, LPeak);
  chtImpulse.Title.Text.Text := 'Runge Kutta Output: impulse response g(t), plant ' +
    IntToStr(Ord(APlant) + 1);
  FinishChart(chtImpulse);
  Log('INFO', 'Impulse response of plant ' + IntToStr(Ord(APlant) + 1) + ': peak ' + Fmt(LPeak) +
    ' at t = ' + Fmt(LTPeak, '0.000') + ' s (pulse of area x0 = ' + Fmt(LS.StepAmp, '0.###') + ').');
end;

procedure TForm1.RunStep(APlant: TPlantKind);
var
  LS: TSimSettings;
  LM: TMethod1Result;
  LI, LPeakI: Integer;
begin
  if not ReadSettings(LS) then
    Exit;
  ZNMethod1(APlant, LS, LM);
  ClearChart(chtStep);
  PlotResponse(serStepY, LM.Response, MaxDouble);
  LPeakI := 0;
  for LI := 1 to LM.Response.Count - 1 do
    if LM.Response.Y[LI] > LM.Response.Y[LPeakI] then
      LPeakI := LI;
  if LM.Response.Count > 0 then
    serStepPeak.AddXY(LM.Response.T[LPeakI], LM.Response.Y[LPeakI]);
  serStepInfl.AddXY(LM.TInfl, LM.YInfl);
  if LM.R > 0 then
  begin
    { tangent y = R x0 (t - L) from y = 0 to y = K x0, Equation 1.13 }
    serStepTangent.AddXY(LM.L, 0.0);
    serStepTangent.AddXY(LM.L + LM.T, LM.K * LS.StepAmp);
    serStepLT.AddXY(LM.L, 0.0);
    serStepLT.AddXY(LM.L + LM.T, 0.0);
  end;
  chtStep.Title.Text.Text := 'Step response y(t) with the tangent of Method 1, plant ' +
    IntToStr(Ord(APlant) + 1);
  FinishChart(chtStep);
  ShowValue(edtR, LM.R);
  ShowValue(edtL, LM.L);
  ShowValue(edtT, LM.T);
  ShowValue(edtK, LM.K);
  ShowValue(edtMP, LM.YMax);
  ShowValue(edtPMP, LM.Overshoot, '0.00');
  Log('INFO', 'Step response of plant ' + IntToStr(Ord(APlant) + 1) + ': R = ' + Fmt(LM.R) + ', L = ' +
    Fmt(LM.L) + ' s, T = ' + Fmt(LM.T) + ' s, MP = ' + Fmt(LM.YMax) + ', %MP = ' +
    Fmt(LM.Overshoot, '0.00') + ' %.');
  if not LM.Valid then
    Warn('Plant ' + IntToStr(Ord(APlant) + 1) + ': ' + LM.Reason);
end;

procedure TForm1.btnImpulse1Click(Sender: TObject);
begin
  RunImpulse(pkPlant1);
end;

procedure TForm1.btnImpulse2Click(Sender: TObject);
begin
  RunImpulse(pkPlant2);
end;

procedure TForm1.btnStep1Click(Sender: TObject);
begin
  RunStep(pkPlant1);
end;

procedure TForm1.btnStep2Click(Sender: TObject);
begin
  RunStep(pkPlant2);
end;

{ Closed loop of both ZN tabs: reads Kp, Ki, Kd, simulates with the
  positional PID (Equation 1.11) and shows the measures of Equation 1.17. }
procedure TForm1.RunClosed(APlantIndex: Integer; ARadio: TRadioGroup; EKp, EKi, EKd: TEdit;
  ARef, AY, AU: TChartSeries; AChtY, AChtU: TChart; const APerf: array of TEdit;
  AStab: TLabel; const ATag: string);
var
  LS: TSimSettings;
  LG: TGains;
  LRes: TClosedLoopResult;
  LLimit: Double;
begin
  if APlantIndex < 0 then
  begin
    Warn(ATag + ': press Plant 1 or Plant 2 first, so that the program knows which plant to control.');
    Exit;
  end;
  if not ReadSettings(LS) then
    Exit;
  if not (ReadNumber(EKp, 'Kp', LG.Kp) and ReadNumber(EKi, 'Ki', LG.Ki) and ReadNumber(EKd, 'Kd', LG.Kd)) then
    Exit;
  if (LG.Kp < 0) or (LG.Ki < 0) or (LG.Kd < 0) then
  begin
    Fail('Kp, Ki and Kd must not be negative (negative feedback is already in e = r - y).');
    Exit;
  end;
  if (LG.Kp = 0) and (LG.Ki = 0) and (LG.Kd = 0) then
  begin
    Warn('All gains are 0: the controller does nothing and y stays 0.');
    Exit;
  end;
  if Max(LG.Kp, Max(LG.Ki, LG.Kd)) > C_LARGE_GAIN then
    Log('WARNING', 'Very large gain (above ' + Fmt(C_LARGE_GAIN, '0') + '): the loop is likely ' +
      'to diverge or to show the dt artefact.');
  if (ControllerOf(ARadio) = ckP) and ((LG.Ki <> 0) or (LG.Kd <> 0)) then
    Log('WARNING', 'P control is selected but Ki or Kd is not 0; the typed gains are used.');
  SimulateClosedLoop(TPlantKind(APlantIndex), LG, LS, LRes);
  ClearChart(AChtY);
  ClearChart(AChtU);
  LLimit := C_PLOT_LIMIT * Abs(LS.Setpoint);
  ARef.AddXY(0.0, LS.Setpoint);
  ARef.AddXY(LS.TEnd, LS.Setpoint);
  PlotResponse(AY, LRes.Response, LLimit);
  PlotResponse(AU, LRes.Response, LLimit, True);
  FinishChart(AChtY);
  FinishChart(AChtU);
  ShowValue(APerf[2], LRes.Metrics.YMax);
  ShowValue(APerf[5], LRes.Metrics.IAE);
  ShowValue(APerf[6], LRes.Metrics.ISE);
  if LRes.Metrics.Stable then
  begin
    if LRes.Metrics.RiseTime >= 0 then
      ShowValue(APerf[0], LRes.Metrics.RiseTime, '0.000')
    else
      APerf[0].Text := 'n/a';
    ShowValue(APerf[1], LRes.Metrics.Overshoot, '0.00');
    if LRes.Metrics.SettlingTime >= 0 then
      ShowValue(APerf[3], LRes.Metrics.SettlingTime, '0.00')
    else
      APerf[3].Text := 'not settled';
    ShowValue(APerf[4], LRes.Metrics.SteadyError);
    AStab.Caption := 'Closed loop (' + C_CTRL_NAMES[ControllerOf(ARadio)] + '): STABLE';
    AStab.Font.Color := RGB(0, 121, 107);
    Log('INFO', ATag + ' plant ' + IntToStr(APlantIndex + 1) + ', Kp = ' + Fmt(LG.Kp) + ', Ki = ' +
      Fmt(LG.Ki) + ', Kd = ' + Fmt(LG.Kd) + ': stable, overshoot ' + Fmt(LRes.Metrics.Overshoot, '0.0') +
      ' %, IAE ' + Fmt(LRes.Metrics.IAE) + '.');
    if LRes.Metrics.SettlingTime < 0 then
      Log('WARNING', 'The response has not settled within the run; increase the simulation time.');
  end
  else
  begin
    APerf[0].Text := '-';
    APerf[1].Text := '-';
    APerf[3].Text := '-';
    APerf[4].Text := '-';
    AStab.Caption := 'Closed loop (' + C_CTRL_NAMES[ControllerOf(ARadio)] + '): UNSTABLE';
    AStab.Font.Color := RGB(198, 40, 40);
    Warn(ATag + ' plant ' + IntToStr(APlantIndex + 1) + ': the closed loop is UNSTABLE with Kp = ' +
      Fmt(LG.Kp) + ', Ki = ' + Fmt(LG.Ki) + ', Kd = ' + Fmt(LG.Kd) + '. The oscillation grows, so ' +
      'the chart stops where |y| exceeds 3 times the setpoint. For plant 1 this is expected with ' +
      'the ZN PI gains (report Section 2.4).');
  end;
end;

{ Tab 2: ZN Method 1 }

function TForm1.ZN1Identify(APlant: TPlantKind): Boolean;
var
  LS: TSimSettings;
begin
  Result := False;
  if not ReadSettings(LS) then
    Exit;
  ZNMethod1(APlant, LS, FZN1M);
  ClearChart(chtZN1Curve);
  PlotResponse(serZN1CurveY, FZN1M.Response, MaxDouble);
  if FZN1M.R > 0 then
  begin
    serZN1Tangent.AddXY(FZN1M.L, 0.0);
    serZN1Tangent.AddXY(FZN1M.L + FZN1M.T, FZN1M.K * LS.StepAmp);
    serZN1LT.AddXY(FZN1M.L, 0.0);
    serZN1LT.AddXY(FZN1M.L + FZN1M.T, 0.0);
  end;
  FinishChart(chtZN1Curve);
  ShowValue(edtZN1R, FZN1M.R);
  ShowValue(edtZN1L, FZN1M.L);
  cardZN1Plant.Caption := 'Ziegler-Nichols Method 1: plant ' + IntToStr(Ord(APlant) + 1);
  cardZN1Plant.Invalidate;
  if not FZN1M.Valid then
  begin
    edtZN1Kp.Text := '';
    edtZN1Ki.Text := '';
    edtZN1Kd.Text := '';
    ClearChart(chtZN1Y);
    ClearChart(chtZN1U);
    ClearPerf([edtZN1Rise, edtZN1OS, edtZN1Max, edtZN1Ts, edtZN1Ess, edtZN1IAE, edtZN1ISE], lblZN1Stab);
    Warn('Method 1, plant ' + IntToStr(Ord(APlant) + 1) + ': ' + FZN1M.Reason);
    Exit;
  end;
  if FZN1M.L < 10 * LS.Dt then
    Log('WARNING', 'L is only a few time steps; the gains of Table 1.1 become very large.');
  Log('INFO', 'Method 1, plant ' + IntToStr(Ord(APlant) + 1) + ': R = ' + Fmt(FZN1M.R) + ' 1/s, L = ' +
    Fmt(FZN1M.L) + ' s, T = ' + Fmt(FZN1M.T) + ' s.');
  Result := True;
end;

{ Kp, Ki, Kd of Table 1.1 from the (possibly edited) R and L. }
function TForm1.ZN1Gains: Boolean;
var
  LR, LL: Double;
  LTable: TGainTable;
  LCtrl: TControllerKind;
begin
  Result := False;
  if not (ReadNumber(edtZN1R, 'R', LR) and ReadNumber(edtZN1L, 'L', LL)) then
    Exit;
  if (LR <= 0) or (LL <= 0) then
  begin
    Fail('Method 1 needs R > 0 and L > 0 (every gain of Table 1.1 contains 1/(R L)). ' +
      'For plant 2 set a dead time theta > 0.');
    Exit;
  end;
  LTable := GainsMethod1(LR, LL);
  LCtrl := ControllerOf(rgZN1Ctrl);
  ShowValue(edtZN1Kp, LTable[LCtrl].Kp);
  ShowValue(edtZN1Ki, LTable[LCtrl].Ki);
  ShowValue(edtZN1Kd, LTable[LCtrl].Kd);
  Result := True;
end;

procedure TForm1.btnZN1Plant1Click(Sender: TObject);
begin
  FZN1Plant := 0;
  if ZN1Identify(pkPlant1) and ZN1Gains then
    btnZN1RunClick(nil);
end;

procedure TForm1.btnZN1Plant2Click(Sender: TObject);
begin
  FZN1Plant := 1;
  if ZN1Identify(pkPlant2) and ZN1Gains then
    btnZN1RunClick(nil);
end;

procedure TForm1.rgZN1CtrlClick(Sender: TObject);
begin
  if (FZN1Plant >= 0) and (Trim(edtZN1R.Text) <> '') and ZN1Gains then
    btnZN1RunClick(nil);
end;

procedure TForm1.btnZN1GainsClick(Sender: TObject);
begin
  if FZN1Plant < 0 then
    Warn('Method 1: press Plant 1 or Plant 2 first.')
  else if ZN1Gains then
    btnZN1RunClick(nil);
end;

procedure TForm1.btnZN1RunClick(Sender: TObject);
begin
  RunClosed(FZN1Plant, rgZN1Ctrl, edtZN1Kp, edtZN1Ki, edtZN1Kd, serZN1Ref, serZN1Y, serZN1U, chtZN1Y,
    chtZN1U, [edtZN1Rise, edtZN1OS, edtZN1Max, edtZN1Ts, edtZN1Ess, edtZN1IAE, edtZN1ISE], lblZN1Stab,
    'Method 1');
end;

{ Tab 3: ZN Method 2 }

function TForm1.ZN2Identify(APlant: TPlantKind): Boolean;
var
  LS: TSimSettings;
begin
  Result := False;
  if not ReadSettings(LS) then
    Exit;
  Screen.Cursor := crHourGlass;
  try
    ZNMethod2(APlant, LS, FZN2M);
  finally
    Screen.Cursor := crDefault;
  end;
  ClearChart(chtZN2Ku);
  PlotResponse(serZN2KuY, FZN2M.Response, C_PLOT_LIMIT * Abs(LS.Setpoint));
  serZN2KuRef.AddXY(0.0, LS.Setpoint);
  serZN2KuRef.AddXY(LS.TEnd, LS.Setpoint);
  PlotPeaks(serZN2KuPeaks, FZN2M.Response, C_PLOT_LIMIT * Abs(LS.Setpoint));
  FinishChart(chtZN2Ku);
  cardZN2Plant.Caption := 'Ziegler-Nichols Method 2: plant ' + IntToStr(Ord(APlant) + 1);
  cardZN2Plant.Invalidate;
  if not FZN2M.Valid then
  begin
    edtZN2Ku.Text := '';
    edtZN2Pu.Text := '';
    edtZN2Kp.Text := '';
    edtZN2Ki.Text := '';
    edtZN2Kd.Text := '';
    ClearChart(chtZN2Y);
    ClearChart(chtZN2U);
    ClearPerf([edtZN2Rise, edtZN2OS, edtZN2Max, edtZN2Ts, edtZN2Ess, edtZN2IAE, edtZN2ISE], lblZN2Stab);
    Warn('Method 2, plant ' + IntToStr(Ord(APlant) + 1) + ': ' + FZN2M.Reason + ' You can also type a Ku ' +
      'and press Test Ku to see the P loop.');
    Exit;
  end;
  ShowValue(edtZN2Ku, FZN2M.Ku);
  ShowValue(edtZN2Pu, FZN2M.Pu);
  Log('INFO', 'Method 2, plant ' + IntToStr(Ord(APlant) + 1) + ': Ku = ' + Fmt(FZN2M.Ku) + ', Pu = ' +
    Fmt(FZN2M.Pu) + ' s (phase crossover); simulated Ku = ' + Fmt(FZN2M.KuSim) + ', Pu = ' +
    Fmt(FZN2M.PuSim) + ' s.');
  if FZN2M.Pu < 20 * LS.Dt then
    Log('WARNING', 'Pu is shorter than 20 time steps; reduce dt.');
  if LS.TEnd < 5 * FZN2M.Pu then
    Log('WARNING', 'The run covers fewer than five periods Pu; increase the simulation time.');
  Result := True;
end;

{ Kp, Ki, Kd of Table 1.2 from the (possibly edited) Ku and Pu. }
function TForm1.ZN2Gains: Boolean;
var
  LKu, LPu: Double;
  LTable: TGainTable;
  LCtrl: TControllerKind;
begin
  Result := False;
  if not (ReadNumber(edtZN2Ku, 'Ku', LKu) and ReadNumber(edtZN2Pu, 'Pu', LPu)) then
    Exit;
  if (LKu <= 0) or (LPu <= 0) then
  begin
    Fail('Method 2 needs Ku > 0 and Pu > 0.');
    Exit;
  end;
  LTable := GainsMethod2(LKu, LPu);
  LCtrl := ControllerOf(rgZN2Ctrl);
  ShowValue(edtZN2Kp, LTable[LCtrl].Kp);
  ShowValue(edtZN2Ki, LTable[LCtrl].Ki);
  ShowValue(edtZN2Kd, LTable[LCtrl].Kd);
  Result := True;
end;

procedure TForm1.btnZN2Plant1Click(Sender: TObject);
begin
  FZN2Plant := 0;
  if ZN2Identify(pkPlant1) and ZN2Gains then
    btnZN2RunClick(nil);
end;

procedure TForm1.btnZN2Plant2Click(Sender: TObject);
begin
  FZN2Plant := 1;
  if ZN2Identify(pkPlant2) and ZN2Gains then
    btnZN2RunClick(nil);
end;

procedure TForm1.rgZN2CtrlClick(Sender: TObject);
begin
  if (FZN2Plant >= 0) and (Trim(edtZN2Ku.Text) <> '') and (Trim(edtZN2Pu.Text) <> '') and ZN2Gains then
    btnZN2RunClick(nil);
end;

{ P loop at the typed Ku, as in the experiment of the slides: the period of
  the oscillation is measured and written to Pu. }
procedure TForm1.btnZN2TestKuClick(Sender: TObject);
var
  LS: TSimSettings;
  LKu, LPu: Double;
  LResp: TResponse;
  LGrows: Boolean;
begin
  if FZN2Plant < 0 then
  begin
    Warn('Method 2: press Plant 1 or Plant 2 first.');
    Exit;
  end;
  if not (ReadSettings(LS) and ReadNumber(edtZN2Ku, 'Ku', LKu)) then
    Exit;
  if LKu <= 0 then
  begin
    Fail('Ku must be positive.');
    Exit;
  end;
  LPu := SimulatePLoop(TPlantKind(FZN2Plant), LS, LKu, LResp);
  LGrows := PLoopGrows(TPlantKind(FZN2Plant), LS, LKu);
  ClearChart(chtZN2Ku);
  PlotResponse(serZN2KuY, LResp, C_PLOT_LIMIT * Abs(LS.Setpoint));
  serZN2KuRef.AddXY(0.0, LS.Setpoint);
  serZN2KuRef.AddXY(LS.TEnd, LS.Setpoint);
  PlotPeaks(serZN2KuPeaks, LResp, C_PLOT_LIMIT * Abs(LS.Setpoint));
  FinishChart(chtZN2Ku);
  if LPu <= 0 then
  begin
    Warn('No oscillation was found at Kp = ' + Fmt(LKu) + ', so Pu cannot be measured. ' +
      'Without dead time a second-order plant never oscillates steadily under P control.');
    Exit;
  end;
  ShowValue(edtZN2Pu, LPu);
  if LGrows then
    Log('WARNING', 'Kp = ' + Fmt(LKu) + ': the oscillation grows, so this Ku is above the critical ' +
      'gain. Pu = ' + Fmt(LPu) + ' s.')
  else
    Log('INFO', 'Kp = ' + Fmt(LKu) + ': the oscillation decays or stays constant, so this Ku is at ' +
      'or below the critical gain. Pu = ' + Fmt(LPu) + ' s.');
  if LPu < 20 * LS.Dt then
    Warn('Pu = ' + Fmt(LPu) + ' s is only a few time steps: this oscillation comes from the step dt ' +
      '(ISS-051), not from the plant.');
end;

procedure TForm1.btnZN2GainsClick(Sender: TObject);
begin
  if FZN2Plant < 0 then
    Warn('Method 2: press Plant 1 or Plant 2 first.')
  else if ZN2Gains then
    btnZN2RunClick(nil);
end;

procedure TForm1.btnZN2RunClick(Sender: TObject);
begin
  RunClosed(FZN2Plant, rgZN2Ctrl, edtZN2Kp, edtZN2Ki, edtZN2Kd, serZN2Ref, serZN2Y, serZN2U, chtZN2Y,
    chtZN2U, [edtZN2Rise, edtZN2OS, edtZN2Max, edtZN2Ts, edtZN2Ess, edtZN2IAE, edtZN2ISE], lblZN2Stab,
    'Method 2');
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
  LEdit: TEdit;
begin
  for LChart in TArray<TChart>.Create(chtImpulse, chtStep, chtZN1Curve, chtZN1Y, chtZN1U, chtZN2Ku, chtZN2Y,
    chtZN2U) do
  begin
    ClearChart(LChart);
    FinishChart(LChart);
  end;
  for LEdit in TArray<TEdit>.Create(edtR, edtL, edtT, edtK, edtMP, edtPMP, edtZN1R, edtZN1L, edtZN1Kp,
    edtZN1Ki, edtZN1Kd, edtZN2Ku, edtZN2Pu, edtZN2Kp, edtZN2Ki, edtZN2Kd) do
    LEdit.Text := '';
  ClearPerf([edtZN1Rise, edtZN1OS, edtZN1Max, edtZN1Ts, edtZN1Ess, edtZN1IAE, edtZN1ISE], lblZN1Stab);
  ClearPerf([edtZN2Rise, edtZN2OS, edtZN2Max, edtZN2Ts, edtZN2Ess, edtZN2IAE, edtZN2ISE], lblZN2Stab);
  FZN1Plant := -1;
  FZN2Plant := -1;
  cardZN1Plant.Caption := 'Ziegler-Nichols Method 1';
  cardZN2Plant.Caption := 'Ziegler-Nichols Method 2';
  cardZN1Plant.Invalidate;
  cardZN2Plant.Invalidate;
  redLog.Clear;
  Log('INFO', 'All outputs cleared.');
end;

function TForm1.ActiveCharts: TArray<TChart>;
begin
  if PageControl1.ActivePage = tsZN1 then
    Result := TArray<TChart>.Create(chtZN1Curve, chtZN1Y, chtZN1U)
  else if PageControl1.ActivePage = tsZN2 then
    Result := TArray<TChart>.Create(chtZN2Ku, chtZN2Y, chtZN2U)
  else
    Result := TArray<TChart>.Create(chtImpulse, chtStep);
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
    Warn('Nothing to export on this tab yet: run a simulation first.');
    Exit;
  end;
  SaveDialogCSV.FileName := 'zn_' + LowerCase(PageControl1.ActivePage.Name) + '.csv';
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
              Fmt(LChart.Series[LI].XValue[LJ], '0.000000') + ',' +
              Fmt(LChart.Series[LI].YValue[LJ], '0.000000000'));
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
  SaveDialogPNG.FileName := 'zn_' + LowerCase(PageControl1.ActivePage.Name) + '.png';
  if not SaveDialogPNG.Execute then
    Exit;
  try
    LBmp := TBitmap.Create;
    try
      LBmp.PixelFormat := pf24bit;
      { one chart: its own size; several charts: the grid that holds them }
      LW := 0;
      LH := 0;
      for LChart in LCharts do
        if Length(LCharts) = 1 then
        begin
          LW := LChart.Width;
          LH := LChart.Height;
        end
        else
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
        if Length(LCharts) = 1 then
          LOrigin := Point(0, 0);
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
