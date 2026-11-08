unit Unit1;

{
  Unit1.pas - Main form of the spherical pendulum simulator
  (Biocybernetics Assignment 2, Lagrangian and Hamiltonian mechanics).

  Author : Jeremia Christ Immanuel Manalu (5023231017)

  I integrate the equations of motion of Problem 2(b) twice from the same
  initial state: the Lagrange system (position and velocity) and the
  Hamilton system (position and momentum). The four charts show the polar
  angle of both methods, the velocities, the momenta and the path of the
  bob seen from above. Every visual element is designed in Unit1.dfm; this
  unit only reads the parameters and fills the series.

  Keys: F5 runs the simulation, F1 opens the equation sheet (Unit2).
}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.Math, System.UITypes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.ValEdit,
  VCLTee.TeEngine, VCLTee.TeeProcs, VCLTee.Chart, VCLTee.Series,
  PendulumModel;

type
  TForm1 = class(TForm)
    pnlLeft: TPanel;
    lblParams: TLabel;
    cbPreset: TComboBox;
    vleParams: TValueListEditor;
    pnlButtons: TPanel;
    btnRun: TButton;
    btnEquations: TButton;
    btnClear: TButton;
    lblResults: TLabel;
    memResult: TMemo;
    gpCharts: TGridPanel;
    chtPosition: TChart;
    serThetaL: TFastLineSeries;
    serThetaH: TFastLineSeries;
    chtVelocity: TChart;
    serThetaDot: TFastLineSeries;
    serPhiDot: TFastLineSeries;
    chtMomentum: TChart;
    serPTheta: TFastLineSeries;
    serPPhi: TFastLineSeries;
    chtTopView: TChart;
    serPath: TLineSeries;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cbPresetChange(Sender: TObject);
    procedure btnRunClick(Sender: TObject);
    procedure btnEquationsClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
  private
    function ReadValue(const AKey: string): Double;
    procedure SetValue(const AKey: string; AValue: Double);
    procedure ReadInputs(out AParams: TPendulumParams; out ASettings: TSimSettings);
    procedure ClearCharts;
    procedure PlotResult(const AResult: TSimResult);
    procedure ReportResult(const AParams: TPendulumParams; const ASettings: TSimSettings;
      const AResult: TSimResult);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  Unit2;

const
  C_KEY_MASS = 'Mass m (kg)';
  C_KEY_LENGTH = 'Link length l (m)';
  C_KEY_GRAVITY = 'Gravity g (m/s2)';
  C_KEY_ALPHA0 = 'Start angle alpha0 (deg)';
  C_KEY_THETADOT0 = 'Polar rate thetadot0 (rad/s)';
  C_KEY_PHIDOT0 = 'Azimuthal rate phidot0 (rad/s)';
  C_KEY_DT = 'Time step dt (s)';
  C_KEY_TEND = 'Simulation time (s)';
  C_MAX_STEPS = 2000000;

  { presets of cbPreset (same order as its Items) }
  C_PRESET_GENERAL = 0;
  C_PRESET_PLANAR_SMALL = 1;
  C_PRESET_PLANAR_LARGE = 2;
  C_PRESET_CONICAL = 3;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FormatSettings.DecimalSeparator := '.';
  btnRunClick(nil);
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F5 then
  begin
    btnRunClick(nil);
    Key := 0;
  end
  else if Key = VK_F1 then
  begin
    btnEquationsClick(nil);
    Key := 0;
  end;
end;

{ Accepts both '.' and ',' as decimal separator. }
function TForm1.ReadValue(const AKey: string): Double;
var
  LText: string;
  LFormat: TFormatSettings;
begin
  LFormat := TFormatSettings.Invariant;
  LText := Trim(StringReplace(vleParams.Values[AKey], ',', '.', [rfReplaceAll]));
  if not TryStrToFloat(LText, Result, LFormat) then
    raise EConvertError.CreateFmt('"%s" is not a number (%s).', [LText, AKey]);
end;

procedure TForm1.SetValue(const AKey: string; AValue: Double);
begin
  vleParams.Values[AKey] := FloatToStrF(AValue, ffGeneral, 8, 0, TFormatSettings.Invariant);
end;

procedure TForm1.ReadInputs(out AParams: TPendulumParams; out ASettings: TSimSettings);
begin
  AParams.Mass := ReadValue(C_KEY_MASS);
  AParams.Length := ReadValue(C_KEY_LENGTH);
  AParams.Gravity := ReadValue(C_KEY_GRAVITY);
  ASettings.Alpha0Deg := ReadValue(C_KEY_ALPHA0);
  ASettings.ThetaDot0 := ReadValue(C_KEY_THETADOT0);
  ASettings.PhiDot0 := ReadValue(C_KEY_PHIDOT0);
  ASettings.Dt := ReadValue(C_KEY_DT);
  ASettings.TEnd := ReadValue(C_KEY_TEND);
  if (AParams.Mass <= 0) or (AParams.Length <= 0) or (AParams.Gravity <= 0) then
    raise EConvertError.Create('m, l and g must be positive.');
  if (ASettings.Alpha0Deg <= 0) or (ASettings.Alpha0Deg >= 180) then
    raise EConvertError.Create('alpha0 must lie between 0 and 180 deg: on the vertical axis ' +
      '(sin(theta) = 0) the azimuth phi is not defined.');
  if (ASettings.Dt <= 0) or (ASettings.TEnd <= 0) then
    raise EConvertError.Create('dt and the simulation time must be positive.');
  if ASettings.TEnd / ASettings.Dt > C_MAX_STEPS then
    raise EConvertError.CreateFmt('Too many steps (more than %d): increase dt.', [C_MAX_STEPS]);
end;

procedure TForm1.cbPresetChange(Sender: TObject);
var
  LParams: TPendulumParams;
begin
  case cbPreset.ItemIndex of
    C_PRESET_GENERAL:
      begin
        SetValue(C_KEY_ALPHA0, 60);
        SetValue(C_KEY_THETADOT0, 0);
        SetValue(C_KEY_PHIDOT0, 1);
      end;
    C_PRESET_PLANAR_SMALL:
      begin
        SetValue(C_KEY_ALPHA0, 10);
        SetValue(C_KEY_THETADOT0, 0);
        SetValue(C_KEY_PHIDOT0, 0);
      end;
    C_PRESET_PLANAR_LARGE:
      begin
        SetValue(C_KEY_ALPHA0, 90);
        SetValue(C_KEY_THETADOT0, 0);
        SetValue(C_KEY_PHIDOT0, 0);
      end;
    C_PRESET_CONICAL:
      begin
        LParams := DefaultParams;
        try
          LParams.Length := ReadValue(C_KEY_LENGTH);
          LParams.Gravity := ReadValue(C_KEY_GRAVITY);
        except
          on EConvertError do
            LParams := DefaultParams;
        end;
        SetValue(C_KEY_ALPHA0, 30);
        SetValue(C_KEY_THETADOT0, 0);
        SetValue(C_KEY_PHIDOT0, ConicalRate(LParams, 30));
      end;
  end;
  btnRunClick(nil);
end;

procedure TForm1.btnRunClick(Sender: TObject);
var
  LParams: TPendulumParams;
  LSettings: TSimSettings;
  LResult: TSimResult;
begin
  try
    ReadInputs(LParams, LSettings);
  except
    on E: EConvertError do
    begin
      MessageDlg(E.Message, mtWarning, [mbOK], 0);
      Exit;
    end;
  end;
  Screen.Cursor := crHourGlass;
  try
    Simulate(LParams, LSettings, LResult);
    PlotResult(LResult);
    ReportResult(LParams, LSettings, LResult);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TForm1.btnEquationsClick(Sender: TObject);
begin
  FormEquations.Show;
  FormEquations.BringToFront;
end;

procedure TForm1.btnClearClick(Sender: TObject);
begin
  ClearCharts;
  memResult.Clear;
end;

procedure TForm1.ClearCharts;
begin
  serThetaL.Clear;
  serThetaH.Clear;
  serThetaDot.Clear;
  serPhiDot.Clear;
  serPTheta.Clear;
  serPPhi.Clear;
  serPath.Clear;
end;

procedure TForm1.PlotResult(const AResult: TSimResult);
var
  LI: Integer;
begin
  ClearCharts;
  for LI := 0 to AResult.Count - 1 do
  begin
    serThetaL.AddXY(AResult.T[LI], RadToDeg(AResult.ThetaL[LI]));
    serThetaH.AddXY(AResult.T[LI], RadToDeg(AResult.ThetaH[LI]));
    serThetaDot.AddXY(AResult.T[LI], AResult.ThetaDot[LI]);
    serPhiDot.AddXY(AResult.T[LI], AResult.PhiDot[LI]);
    serPTheta.AddXY(AResult.T[LI], AResult.PTheta[LI]);
    serPPhi.AddXY(AResult.T[LI], AResult.PPhi[LI]);
    serPath.AddXY(AResult.X[LI], AResult.Y[LI]);
  end;
end;

procedure TForm1.ReportResult(const AParams: TPendulumParams; const ASettings: TSimSettings;
  const AResult: TSimResult);
var
  LPeriod: Double;
begin
  memResult.Lines.BeginUpdate;
  try
    memResult.Clear;
    memResult.Lines.Add('Start: theta0 = ' + FormatFloat('0.00', 180 - ASettings.Alpha0Deg) +
      ' deg (alpha0 = ' + FormatFloat('0.00', ASettings.Alpha0Deg) + ' deg)');
    memResult.Lines.Add('Energy H = T + V      : ' + FormatFloat('0.0000', AResult.EnergyL[0]) + ' J');
    memResult.Lines.Add('p_phi (constant)      : ' + FormatFloat('0.0000', AResult.PPhi[0]) + ' kg m2/s');
    memResult.Lines.Add('alpha range           : ' + FormatFloat('0.000', AResult.AlphaMinDeg) +
      ' to ' + FormatFloat('0.000', AResult.AlphaMaxDeg) + ' deg');
    LPeriod := ThetaPeriod(AResult);
    if LPeriod > 0 then
      memResult.Lines.Add('Period of theta       : ' + FormatFloat('0.00000', LPeriod) + ' s');
    if ASettings.PhiDot0 = 0 then
      memResult.Lines.Add('Exact planar period   : ' +
        FormatFloat('0.00000', ExactPlanarPeriod(AParams, ASettings.Alpha0Deg)) + ' s')
    else if ASettings.Alpha0Deg < 90 then
      memResult.Lines.Add('Conical rate Omega    : ' +
        FormatFloat('0.0000', ConicalRate(AParams, ASettings.Alpha0Deg)) + ' rad/s');
    memResult.Lines.Add('');
    memResult.Lines.Add('Lagrange vs Hamilton (whole run)');
    memResult.Lines.Add('max |theta_L - theta_H| : ' + FormatFloat('0.0E+00', AResult.MaxThetaDiff) + ' rad');
    memResult.Lines.Add('energy error Lagrange   : ' + FormatFloat('0.0E+00', AResult.MaxEnergyErrL) + ' m g l');
    memResult.Lines.Add('energy error Hamilton   : ' + FormatFloat('0.0E+00', AResult.MaxEnergyErrH) + ' m g l');
    memResult.Lines.Add('p_phi drift (Lagrange)  : ' + FormatFloat('0.0E+00', AResult.MaxPPhiErr) + ' kg m2/s');
  finally
    memResult.Lines.EndUpdate;
  end;
end;

end.
