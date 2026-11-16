unit ZNModel;

{
  ZNModel.pas - Numerical core of the Ziegler-Nichols PID tuning program
  (Biocybernetics Assignment 3, Preliminary Assignment).

  Author : Jeremia Christ Immanuel Manalu (5023231017)

  The unit contains no user-interface code, so it is compiled and tested
  with Free Pascal in CI (Verification/TestZN.dpr).

  Plants of the problem sheet
    plant 1   y'' = -0.5 y' - y + x               report Equation 1.1
    plant 2   y'' = -1.5 y' - y + 2 x' + x        report Equation 1.2
  Plant 2 is integrated in the controllable canonical form
    z'' = -1.5 z' - z + x,   y = z + 2 z'          report Equations 1.7 and 1.8
  so the derivative of the input is never formed numerically (ISS-050).

  An optional dead time theta delays the plant input, x(t) = u(t - theta)
  (report Equation 1.9, ISS-051). Integration uses the Runge-Kutta-Nystroem
  form of the controller slides with the input held constant over one step
  (report Equations 1.15 and 1.16, ISS-052).
}

{$IFDEF FPC}{$MODE DELPHI}{$MODESWITCH ADVANCEDRECORDS}{$ENDIF}

interface

type
  TPlantKind = (pkPlant1, pkPlant2);
  TControllerKind = (ckP, ckPI, ckPID);
  TZNMethod = (zmMethod1, zmMethod2);

  { y'' (plant 1) or z'' (plant 2) as a function of position, rate, input }
  TAccelFunction = function(AY, AYDot, AX: Double): Double;

  TGains = record
    Kp, Ki, Kd: Double;
  end;

  TGainTable = array[TControllerKind] of TGains;

  TSimSettings = record
    Dt: Double;         { integration step (s) }
    TEnd: Double;       { simulated time (s) }
    DeadTime: Double;   { input dead time theta (s), 0 = plant of the sheet }
    StepAmp: Double;    { open-loop step amplitude of x }
    Setpoint: Double;   { closed-loop reference r }
  end;

  TResponse = record
    Count: Integer;                 { stored samples (plotting) }
    T, Y, YDot, U: array of Double;
  end;

  TMethod1Result = record
    Valid: Boolean;
    Reason: string;
    K: Double;          { static gain, y(TEnd) / step }
    R: Double;          { largest slope per unit step (1/s) }
    L: Double;          { apparent dead time (s) }
    T: Double;          { time constant K / R (s) }
    TInfl, YInfl: Double;   { tangent point, inflection point }
    YMax: Double;           { peak value MP of the response }
    Overshoot: Double;      { open-loop overshoot %MP (%) }
    Response: TResponse;
  end;

  TMethod2Result = record
    AnalyticFound: Boolean;   { phase crossover exists }
    Ku, Pu, Wu: Double;       { analytic critical gain, period, frequency }
    SimFound: Boolean;        { bisection found a growing P loop }
    KuSim, PuSim: Double;     { simulated critical gain and period }
    Valid: Boolean;           { values used for the gain table }
    Reason: string;
    Response: TResponse;      { P loop at the critical gain }
  end;

  TMetrics = record
    Stable: Boolean;
    Diverged: Boolean;     { run stopped at the output bound }
    YFinal: Double;
    SteadyError: Double;   { r - y_final }
    YMax: Double;          { largest output (Max Value) }
    Overshoot: Double;     { % of the final value }
    PeakTime: Double;
    RiseTime: Double;      { 10 % to 90 % of the final value }
    SettlingTime: Double;  { 2 % band, -1 if never inside }
    IAE, ISE: Double;
  end;

  TClosedLoopResult = record
    Gains: TGains;
    Metrics: TMetrics;
    Response: TResponse;
  end;

const
  C_CONTROLLER_NAMES: array[TControllerKind] of string = ('P', 'PI', 'PID');

function DefaultSettings: TSimSettings;
function Plant1Accel(AY, AYDot, AX: Double): Double;
function Plant2Accel(AZ, AZDot, AX: Double): Double;
function PlantAccel(APlant: TPlantKind): TAccelFunction;
function PlantOutput(APlant: TPlantKind; AZ, AZDot: Double): Double;
function PlantOutputRate(APlant: TPlantKind; AZ, AZDot, AX: Double): Double;
procedure RK4Step(AFunc: TAccelFunction; var AY, AYDot: Double; AX, ADt: Double);
function TransferPhase(APlant: TPlantKind; AW: Double): Double;
function TransferMagnitude(APlant: TPlantKind; AW: Double): Double;
procedure SimulateOpenLoop(APlant: TPlantKind; const ASettings: TSimSettings;
  out AResult: TMethod1Result);
procedure ZNMethod1(APlant: TPlantKind; const ASettings: TSimSettings;
  out AResult: TMethod1Result);
procedure SimulateImpulse(APlant: TPlantKind; const ASettings: TSimSettings;
  out AResp: TResponse; out APeak, ATPeak: Double);
function SimulatePLoop(APlant: TPlantKind; const ASettings: TSimSettings; AKp: Double;
  out AResp: TResponse): Double;
function CriticalGainAnalytic(APlant: TPlantKind; ADeadTime: Double;
  out AKu, APu, AWu: Double): Boolean;
function PLoopGrows(APlant: TPlantKind; const ASettings: TSimSettings; AKp: Double): Boolean;
procedure ZNMethod2(APlant: TPlantKind; const ASettings: TSimSettings;
  out AResult: TMethod2Result);
function GainsMethod1(AR, AL: Double): TGainTable;
function GainsMethod2(AKu, APu: Double): TGainTable;
procedure SimulateClosedLoop(APlant: TPlantKind; const AGains: TGains;
  const ASettings: TSimSettings; out AResult: TClosedLoopResult);

implementation

uses
  SysUtils, Math;

const
  C_MAX_SAMPLES = 6000;      { stored points per response (plotting) }
  C_DIVERGE_BOUND = 1.0e3;   { |y| above this times max(1, |r|) stops a run }
  C_KU_MIN = 1.0e-3;         { bisection range of the simulated Ku }
  C_KU_MAX = 1.0e5;
  C_KU_ITER = 40;
  C_KU_HORIZON = 40.0;     { minimum run length of the growth test (s) }
  C_GROWTH = 1.0e-3;         { relative growth that counts as unstable }
  C_W_STEP = 1.0e-3;         { frequency scan of the phase crossover (rad/s) }
  C_W_MAX = 1.0e3;

function DefaultSettings: TSimSettings;
begin
  Result.Dt := 0.001;
  Result.TEnd := 30.0;
  Result.DeadTime := 0.1;
  Result.StepAmp := 1.0;
  Result.Setpoint := 1.0;
end;

{ Plant 1, Equation 1.1. }
function Plant1Accel(AY, AYDot, AX: Double): Double;
begin
  Result := -0.5 * AYDot - AY + AX;
end;

{ Plant 2 without the input derivative, Equation 1.7; the output follows from
  Equation 1.8 in PlantOutput. }
function Plant2Accel(AZ, AZDot, AX: Double): Double;
begin
  Result := -1.5 * AZDot - AZ + AX;
end;

function PlantAccel(APlant: TPlantKind): TAccelFunction;
begin
  if APlant = pkPlant1 then
    Result := Plant1Accel
  else
    Result := Plant2Accel;
end;

{ y = z for plant 1, y = z + 2 z' for plant 2 (Equation 1.8). }
function PlantOutput(APlant: TPlantKind; AZ, AZDot: Double): Double;
begin
  if APlant = pkPlant1 then
    Result := AZ
  else
    Result := AZ + 2.0 * AZDot;
end;

{ y' from the state, with the input AX that holds after the sample:
  y' = z' (plant 1), y' = z' + 2 z'' (plant 2). No finite difference. }
function PlantOutputRate(APlant: TPlantKind; AZ, AZDot, AX: Double): Double;
begin
  if APlant = pkPlant1 then
    Result := AZDot
  else
    Result := AZDot + 2.0 * Plant2Accel(AZ, AZDot, AX);
end;

{ Fourth-order Runge-Kutta-Nystroem step for y'' = f(y, y', x), Equations 1.15
  and 1.16, as in the program example of the controller slides. The input
  x is held constant over the step (zero-order hold, ISS-052). }
procedure RK4Step(AFunc: TAccelFunction; var AY, AYDot: Double; AX, ADt: Double);
var
  LK1, LK2, LK3, LK4: Double;
begin
  LK1 := 0.5 * ADt * AFunc(AY, AYDot, AX);
  LK2 := 0.5 * ADt * AFunc(AY + 0.5 * ADt * (AYDot + 0.5 * LK1), AYDot + LK1, AX);
  LK3 := 0.5 * ADt * AFunc(AY + 0.5 * ADt * (AYDot + 0.5 * LK1), AYDot + LK2, AX);
  LK4 := 0.5 * ADt * AFunc(AY + ADt * (AYDot + LK3), AYDot + 2.0 * LK3, AX);
  AY := AY + ADt * (AYDot + (LK1 + LK2 + LK3) / 3.0);
  AYDot := AYDot + (LK1 + 2.0 * LK2 + 2.0 * LK3 + LK4) / 3.0;
end;

{ Phase of G(jw) without the dead time (rad), continuous from 0:
  plant 1 -atan2(0.5 w, 1 - w^2), plant 2 atan(2 w) - atan2(1.5 w, 1 - w^2). }
function TransferPhase(APlant: TPlantKind; AW: Double): Double;
begin
  if APlant = pkPlant1 then
    Result := -ArcTan2(0.5 * AW, 1.0 - Sqr(AW))
  else
    Result := ArcTan(2.0 * AW) - ArcTan2(1.5 * AW, 1.0 - Sqr(AW));
end;

function TransferMagnitude(APlant: TPlantKind; AW: Double): Double;
begin
  if APlant = pkPlant1 then
    Result := 1.0 / Sqrt(Sqr(1.0 - Sqr(AW)) + Sqr(0.5 * AW))
  else
    Result := Sqrt(1.0 + Sqr(2.0 * AW)) / Sqrt(Sqr(1.0 - Sqr(AW)) + Sqr(1.5 * AW));
end;

{ Ring buffer of the dead time: Push returns the input applied theta ago
  (zero before the start). }
type
  TDelayLine = record
    Buf: array of Double;
    Pos: Integer;
    procedure Init(ADeadTime, ADt: Double);
    function Push(AValue: Double): Double;
  end;

procedure TDelayLine.Init(ADeadTime, ADt: Double);
var
  LN, LI: Integer;
begin
  LN := Round(ADeadTime / ADt);
  if LN < 0 then
    LN := 0;
  SetLength(Buf, LN);
  for LI := 0 to LN - 1 do
    Buf[LI] := 0.0;
  Pos := 0;
end;

function TDelayLine.Push(AValue: Double): Double;
begin
  if Length(Buf) = 0 then
    Exit(AValue);
  Result := Buf[Pos];
  Buf[Pos] := AValue;
  Pos := (Pos + 1) mod Length(Buf);
end;

procedure PrepareResponse(var AResp: TResponse; ASteps: Integer; out AStride: Integer);
begin
  AStride := Max(1, (ASteps + C_MAX_SAMPLES - 1) div C_MAX_SAMPLES);
  AResp.Count := ASteps div AStride + 2;
  SetLength(AResp.T, AResp.Count);
  SetLength(AResp.Y, AResp.Count);
  SetLength(AResp.YDot, AResp.Count);
  SetLength(AResp.U, AResp.Count);
end;

procedure StoreSample(var AResp: TResponse; var AK: Integer; AT, AY, AYDot, AU: Double);
begin
  if AK >= AResp.Count then
    Exit;
  AResp.T[AK] := AT;
  AResp.Y[AK] := AY;
  AResp.YDot[AK] := AYDot;
  AResp.U[AK] := AU;
  Inc(AK);
end;

procedure FinishResponse(var AResp: TResponse; ACount: Integer);
begin
  AResp.Count := ACount;
  SetLength(AResp.T, ACount);
  SetLength(AResp.Y, ACount);
  SetLength(AResp.YDot, ACount);
  SetLength(AResp.U, ACount);
end;

{ Open-loop step response with dead time. While integrating, the largest
  slope y' and its point are tracked at full resolution (tangent of the
  reaction curve, Equation 1.13. Fields L, T, Valid are set by ZNMethod1. }
procedure SimulateOpenLoop(APlant: TPlantKind; const ASettings: TSimSettings;
  out AResult: TMethod1Result);
var
  LFunc: TAccelFunction;
  LDelay: TDelayLine;
  LZ, LZDot, LX, LY, LYDot, LYMax, LSlopeMax: Double;
  LSteps, LStride, LStep, LK: Integer;
begin
  LFunc := PlantAccel(APlant);
  LDelay.Init(ASettings.DeadTime, ASettings.Dt);
  LZ := 0.0;
  LZDot := 0.0;
  LY := 0.0;
  LSlopeMax := -MaxDouble;
  LYMax := 0.0;
  AResult.TInfl := 0.0;
  AResult.YInfl := 0.0;
  LSteps := Round(ASettings.TEnd / ASettings.Dt);
  PrepareResponse(AResult.Response, LSteps, LStride);
  LK := 0;
  for LStep := 0 to LSteps do
  begin
    { input on [t_k, t_k+1): step applied at t = 0, seen after theta }
    LX := LDelay.Push(ASettings.StepAmp);
    LY := PlantOutput(APlant, LZ, LZDot);
    LYDot := PlantOutputRate(APlant, LZ, LZDot, LX);
    if LYDot > LSlopeMax then
    begin
      LSlopeMax := LYDot;
      AResult.TInfl := LStep * ASettings.Dt;
      AResult.YInfl := LY;
    end;
    LYMax := Max(LYMax, LY);
    if (LStep mod LStride = 0) or (LStep = LSteps) then
      StoreSample(AResult.Response, LK, LStep * ASettings.Dt, LY, LYDot, LX);
    if LStep < LSteps then
      RK4Step(LFunc, LZ, LZDot, LX, ASettings.Dt);
  end;
  FinishResponse(AResult.Response, LK);
  AResult.K := LY / ASettings.StepAmp;
  AResult.YMax := LYMax;
  AResult.R := LSlopeMax / ASettings.StepAmp;
  if AResult.K <> 0.0 then
    AResult.Overshoot := (LYMax / ASettings.StepAmp - AResult.K) / AResult.K * 100.0
  else
    AResult.Overshoot := 0.0;
  AResult.L := 0.0;
  AResult.T := 0.0;
  AResult.Valid := False;
  AResult.Reason := '';
end;

{ ZN Method 1: tangent at the point of largest slope, L where it crosses
  y = 0 and T = K / R (Equation 1.13). L must be at least one step. }
procedure ZNMethod1(APlant: TPlantKind; const ASettings: TSimSettings;
  out AResult: TMethod1Result);
begin
  SimulateOpenLoop(APlant, ASettings, AResult);
  if AResult.R <= 0.0 then
  begin
    AResult.Reason := 'The step response never rises (R <= 0).';
    Exit;
  end;
  AResult.L := AResult.TInfl - AResult.YInfl / (AResult.R * ASettings.StepAmp);
  AResult.T := AResult.K / AResult.R;
  if AResult.L < 0.5 * ASettings.Dt then
  begin
    AResult.L := 0.0;
    AResult.Reason := 'L = 0: the slope is largest at the start of the response ' +
      '(no inflection point, no dead time). Kp = 1/(R L) is infinite, so Method 1 ' +
      'does not apply. Set a dead time theta > 0.';
    Exit;
  end;
  AResult.Valid := True;
end;

{ Impulse response: a pulse of height x0/dt during one step (area x0),
  applied at t = 0 and seen after theta. The lecture test uses x = 1 for one
  step (area dt); dividing by dt makes the area one, so y approaches the
  impulse response g(t) of the transfer function as dt -> 0. }
procedure SimulateImpulse(APlant: TPlantKind; const ASettings: TSimSettings;
  out AResp: TResponse; out APeak, ATPeak: Double);
var
  LFunc: TAccelFunction;
  LDelay: TDelayLine;
  LZ, LZDot, LX, LY, LYDot, LIn: Double;
  LSteps, LStride, LStep, LK: Integer;
begin
  LFunc := PlantAccel(APlant);
  LDelay.Init(ASettings.DeadTime, ASettings.Dt);
  LZ := 0.0;
  LZDot := 0.0;
  APeak := 0.0;
  ATPeak := 0.0;
  LSteps := Round(ASettings.TEnd / ASettings.Dt);
  PrepareResponse(AResp, LSteps, LStride);
  LK := 0;
  for LStep := 0 to LSteps do
  begin
    if LStep = 0 then
      LIn := ASettings.StepAmp / ASettings.Dt
    else
      LIn := 0.0;
    LX := LDelay.Push(LIn);
    LY := PlantOutput(APlant, LZ, LZDot);
    LYDot := PlantOutputRate(APlant, LZ, LZDot, LX);
    if Abs(LY) > Abs(APeak) then
    begin
      APeak := LY;
      ATPeak := LStep * ASettings.Dt;
    end;
    if (LStep mod LStride = 0) or (LStep = LSteps) then
      StoreSample(AResp, LK, LStep * ASettings.Dt, LY, LYDot, LX);
    if LStep < LSteps then
      RK4Step(LFunc, LZ, LZDot, LX, ASettings.Dt);
  end;
  FinishResponse(AResp, LK);
end;

{ Phase crossover of G(jw) exp(-j w theta), Equation 1.14: first w where the
  phase reaches -pi; Ku = 1/|G(j wu)|, Pu = 2 pi / wu. Without dead time
  the phase of both plants stays above -pi, so no crossover exists. }
function CriticalGainAnalytic(APlant: TPlantKind; ADeadTime: Double;
  out AKu, APu, AWu: Double): Boolean;
var
  LW, LLo, LHi, LMid: Double;
  LI: Integer;

  function F(AW: Double): Double;
  begin
    Result := TransferPhase(APlant, AW) - AW * ADeadTime + Pi;
  end;

begin
  AKu := 0.0;
  APu := 0.0;
  AWu := 0.0;
  Result := False;
  if ADeadTime <= 0.0 then
    Exit;
  LW := C_W_STEP;
  while (LW < C_W_MAX) and (F(LW) > 0.0) do
    LW := LW + C_W_STEP;
  if LW >= C_W_MAX then
    Exit;
  LLo := LW - C_W_STEP;
  LHi := LW;
  for LI := 1 to 60 do
  begin
    LMid := 0.5 * (LLo + LHi);
    if F(LMid) > 0.0 then
      LLo := LMid
    else
      LHi := LMid;
  end;
  AWu := 0.5 * (LLo + LHi);
  AKu := 1.0 / TransferMagnitude(APlant, AWu);
  APu := 2.0 * Pi / AWu;
  Result := True;
end;

{ Closed loop with u = Kp e. Returns True when the oscillation grows: the
  output leaves the bound, or the peak-to-peak value of the last quarter of
  the run exceeds that of the quarter before by more than C_GROWTH. }
function PLoopGrows(APlant: TPlantKind; const ASettings: TSimSettings; AKp: Double): Boolean;
var
  LFunc: TAccelFunction;
  LDelay: TDelayLine;
  LZ, LZDot, LY, LX, LBound: Double;
  LMin3, LMax3, LMin4, LMax4: Double;
  LSteps, LStep: Integer;
begin
  LFunc := PlantAccel(APlant);
  LDelay.Init(ASettings.DeadTime, ASettings.Dt);
  LZ := 0.0;
  LZDot := 0.0;
  LBound := C_DIVERGE_BOUND * Max(1.0, Abs(ASettings.Setpoint));
  LMin3 := MaxDouble;
  LMax3 := -MaxDouble;
  LMin4 := MaxDouble;
  LMax4 := -MaxDouble;
  LSteps := Round(ASettings.TEnd / ASettings.Dt);
  for LStep := 0 to LSteps - 1 do
  begin
    LY := PlantOutput(APlant, LZ, LZDot);
    if (Abs(LY) > LBound) or IsNan(LY) then
      Exit(True);
    if LStep >= LSteps div 2 then
    begin
      if LStep < (3 * LSteps) div 4 then
      begin
        LMin3 := Min(LMin3, LY);
        LMax3 := Max(LMax3, LY);
      end
      else
      begin
        LMin4 := Min(LMin4, LY);
        LMax4 := Max(LMax4, LY);
      end;
    end;
    LX := LDelay.Push(AKp * (ASettings.Setpoint - LY));
    RK4Step(LFunc, LZ, LZDot, LX, ASettings.Dt);
  end;
  Result := (LMax4 - LMin4) > (LMax3 - LMin3) * (1.0 + C_GROWTH) + 1.0e-12;
end;

{ Simulated P loop for plotting; also returns the mean period of the
  oscillation in the second half of the run (upward crossings of the mean,
  linear interpolation), 0 if fewer than two crossings. }
function SimulatePLoop(APlant: TPlantKind; const ASettings: TSimSettings; AKp: Double;
  out AResp: TResponse): Double;
var
  LFunc: TAccelFunction;
  LDelay: TDelayLine;
  LZ, LZDot, LY, LYDot, LX, LU, LBound, LMean, LPrev, LCur, LCross, LFirst, LLast: Double;
  LYs: array of Double;
  LSteps, LStride, LStep, LK, LCount, LHalf, LN: Integer;
begin
  LFunc := PlantAccel(APlant);
  LDelay.Init(ASettings.DeadTime, ASettings.Dt);
  LZ := 0.0;
  LZDot := 0.0;
  LBound := C_DIVERGE_BOUND * Max(1.0, Abs(ASettings.Setpoint));
  LSteps := Round(ASettings.TEnd / ASettings.Dt);
  SetLength(LYs, LSteps + 1);
  PrepareResponse(AResp, LSteps, LStride);
  LK := 0;
  LN := 0;
  for LStep := 0 to LSteps do
  begin
    LY := PlantOutput(APlant, LZ, LZDot);
    LU := AKp * (ASettings.Setpoint - LY);
    LX := LDelay.Push(LU);
    LYDot := PlantOutputRate(APlant, LZ, LZDot, LX);
    LYs[LStep] := LY;
    LN := LStep + 1;
    if (LStep mod LStride = 0) or (LStep = LSteps) then
      StoreSample(AResp, LK, LStep * ASettings.Dt, LY, LYDot, LU);
    if (Abs(LY) > LBound) or IsNan(LY) then
      Break;
    if LStep < LSteps then
      RK4Step(LFunc, LZ, LZDot, LX, ASettings.Dt);
  end;
  FinishResponse(AResp, LK);
  Result := 0.0;
  LHalf := LN div 2;
  if LN - LHalf < 3 then
    Exit;
  LMean := 0.0;
  for LStep := LHalf to LN - 1 do
    LMean := LMean + LYs[LStep];
  LMean := LMean / (LN - LHalf);
  LCount := 0;
  LFirst := 0.0;
  LLast := 0.0;
  for LStep := LHalf + 1 to LN - 1 do
  begin
    LPrev := LYs[LStep - 1] - LMean;
    LCur := LYs[LStep] - LMean;
    if (LPrev < 0.0) and (LCur >= 0.0) then
    begin
      LCross := ((LStep - 1) + (-LPrev) / (LCur - LPrev)) * ASettings.Dt;
      if LCount = 0 then
        LFirst := LCross;
      LLast := LCross;
      Inc(LCount);
    end;
  end;
  if LCount >= 2 then
    Result := (LLast - LFirst) / (LCount - 1);
end;

{ ZN Method 2: analytic critical gain (phase crossover) and the simulated
  one (bisection on PLoopGrows, log scale, run of at least 40 s). Without dead time the simulated
  value only reflects the step dt (ISS-051) and is not used for the table. }
procedure ZNMethod2(APlant: TPlantKind; const ASettings: TSimSettings;
  out AResult: TMethod2Result);
var
  LLo, LHi, LMid: Double;
  LI: Integer;
  LS: TSimSettings;
begin
  { the growth test compares two windows of a quarter run each; they must
    hold more than one period of the slowest oscillation (6.5 s for plant 1) }
  LS := ASettings;
  LS.TEnd := Max(ASettings.TEnd, C_KU_HORIZON);
  AResult.AnalyticFound := CriticalGainAnalytic(APlant, ASettings.DeadTime,
    AResult.Ku, AResult.Pu, AResult.Wu);
  AResult.SimFound := False;
  AResult.KuSim := 0.0;
  AResult.PuSim := 0.0;
  AResult.Valid := False;
  AResult.Reason := '';
  AResult.Response.Count := 0;
  if PLoopGrows(APlant, LS, C_KU_MAX) and not PLoopGrows(APlant, LS, C_KU_MIN) then
  begin
    LLo := C_KU_MIN;
    LHi := C_KU_MAX;
    for LI := 1 to C_KU_ITER do
    begin
      LMid := Sqrt(LLo * LHi);
      if PLoopGrows(APlant, LS, LMid) then
        LHi := LMid
      else
        LLo := LMid;
    end;
    AResult.SimFound := True;
    AResult.KuSim := Sqrt(LLo * LHi);
    AResult.PuSim := SimulatePLoop(APlant, LS, AResult.KuSim, AResult.Response);
  end
  else
    SimulatePLoop(APlant, LS, 10.0, AResult.Response);
  if AResult.AnalyticFound then
    AResult.Valid := True
  else if AResult.SimFound then
    AResult.Reason := 'No phase crossover without dead time: the P loop of this plant is ' +
      'stable for every Kp. The simulated Ku = ' + FormatFloat('0.###', AResult.KuSim) +
      ' only reflects the step dt (about 1/dt), so it is not a plant property. ' +
      'Set a dead time theta > 0.'
  else
    AResult.Reason := 'No critical gain: the P loop stays stable up to Kp = ' +
      FormatFloat('0', C_KU_MAX) + '.';
end;

{ Method 1 table, Table 1.1: P Kp = 1/RL; PI Kp = 0.9/RL, Ki = 0.27/RL^2;
  PID Kp = 1.2/RL, Ki = 0.6/RL^2, Kd = 0.6/R. }
function GainsMethod1(AR, AL: Double): TGainTable;
begin
  Result[ckP].Kp := 1.0 / (AR * AL);
  Result[ckP].Ki := 0.0;
  Result[ckP].Kd := 0.0;
  Result[ckPI].Kp := 0.9 / (AR * AL);
  Result[ckPI].Ki := 0.27 / (AR * Sqr(AL));
  Result[ckPI].Kd := 0.0;
  Result[ckPID].Kp := 1.2 / (AR * AL);
  Result[ckPID].Ki := 0.6 / (AR * Sqr(AL));
  Result[ckPID].Kd := 0.6 / AR;
end;

{ Method 2 table, Table 1.2: P Kp = 0.5 Ku; PI Kp = 0.45 Ku, Ki = 0.54 Ku/Pu;
  PID Kp = 0.6 Ku, Ki = 1.2 Ku/Pu, Kd = 0.075 Ku Pu. }
function GainsMethod2(AKu, APu: Double): TGainTable;
begin
  Result[ckP].Kp := 0.5 * AKu;
  Result[ckP].Ki := 0.0;
  Result[ckP].Kd := 0.0;
  Result[ckPI].Kp := 0.45 * AKu;
  Result[ckPI].Ki := 0.54 * AKu / APu;
  Result[ckPI].Kd := 0.0;
  Result[ckPID].Kp := 0.6 * AKu;
  Result[ckPID].Ki := 1.2 * AKu / APu;
  Result[ckPID].Kd := 0.075 * AKu * APu;
end;

{ Closed loop with the positional PID of the controller slides, Equation 1.11:
  e = r - y, ie = ie + e dt, de = (e - e_old)/dt, u = Kp e + Ki ie + Kd de.
  e_old starts at the first error, so there is no derivative kick at t = 0
  (ISS-056). Metrics of Equation 1.17 use every step. }
procedure SimulateClosedLoop(APlant: TPlantKind; const AGains: TGains;
  const ASettings: TSimSettings; out AResult: TClosedLoopResult);
var
  LFunc: TAccelFunction;
  LDelay: TDelayLine;
  LZ, LZDot, LY, LYDot, LX, LU, LE, LEOld, LIE, LDE, LBound, LYMax, LTPeak: Double;
  LYs: array of Double;
  LSteps, LStride, LStep, LK, LN, LI, LTail: Integer;
  LMin3, LMax3, LMin4, LMax4, LLevel, LYPrev: Double;
  LT10, LT90: Double;
  LM: TMetrics;
begin
  AResult.Gains := AGains;
  LFunc := PlantAccel(APlant);
  LDelay.Init(ASettings.DeadTime, ASettings.Dt);
  LZ := 0.0;
  LZDot := 0.0;
  LY := 0.0;
  LIE := 0.0;
  LEOld := ASettings.Setpoint;
  LBound := C_DIVERGE_BOUND * Max(1.0, Abs(ASettings.Setpoint));
  LYMax := -MaxDouble;
  LTPeak := 0.0;
  LSteps := Round(ASettings.TEnd / ASettings.Dt);
  SetLength(LYs, LSteps + 1);
  PrepareResponse(AResult.Response, LSteps, LStride);
  LK := 0;
  LN := 0;
  AResult.Metrics.Diverged := False;
  AResult.Metrics.IAE := 0.0;
  AResult.Metrics.ISE := 0.0;
  for LStep := 0 to LSteps do
  begin
    LY := PlantOutput(APlant, LZ, LZDot);
    LE := ASettings.Setpoint - LY;
    LIE := LIE + LE * ASettings.Dt;
    LDE := (LE - LEOld) / ASettings.Dt;
    LEOld := LE;
    LU := AGains.Kp * LE + AGains.Ki * LIE + AGains.Kd * LDE;
    LX := LDelay.Push(LU);
    LYDot := PlantOutputRate(APlant, LZ, LZDot, LX);
    LYs[LStep] := LY;
    LN := LStep + 1;
    if LY > LYMax then
    begin
      LYMax := LY;
      LTPeak := LStep * ASettings.Dt;
    end;
    if LStep < LSteps then
    begin
      AResult.Metrics.IAE := AResult.Metrics.IAE + Abs(LE) * ASettings.Dt;
      AResult.Metrics.ISE := AResult.Metrics.ISE + Sqr(LE) * ASettings.Dt;
    end;
    if (LStep mod LStride = 0) or (LStep = LSteps) then
      StoreSample(AResult.Response, LK, LStep * ASettings.Dt, LY, LYDot, LU);
    if (Abs(LY) > LBound) or IsNan(LY) then
    begin
      AResult.Metrics.Diverged := True;
      if LK < AResult.Response.Count then
        StoreSample(AResult.Response, LK, LStep * ASettings.Dt, LY, LYDot, LU);
      Break;
    end;
    if LStep < LSteps then
      RK4Step(LFunc, LZ, LZDot, LX, ASettings.Dt);
  end;
  FinishResponse(AResult.Response, LK);

  LM := AResult.Metrics;
  try
    LM.PeakTime := LTPeak;
    LM.YMax := LYMax;
    LM.RiseTime := -1.0;
    LM.SettlingTime := -1.0;
    if LM.Diverged then
    begin
      LM.Stable := False;
      LM.YFinal := LY;
      LM.SteadyError := ASettings.Setpoint - LY;
      LM.Overshoot := -1.0;
      Exit;
    end;
    { growth test on the last two quarters, as in PLoopGrows }
    LMin3 := MaxDouble;
    LMax3 := -MaxDouble;
    LMin4 := MaxDouble;
    LMax4 := -MaxDouble;
    for LI := LN div 2 to LN - 1 do
      if LI < (3 * LN) div 4 then
      begin
        LMin3 := Min(LMin3, LYs[LI]);
        LMax3 := Max(LMax3, LYs[LI]);
      end
      else
      begin
        LMin4 := Min(LMin4, LYs[LI]);
        LMax4 := Max(LMax4, LYs[LI]);
      end;
    LM.Stable := not ((LMax4 - LMin4) > (LMax3 - LMin3) * (1.0 + C_GROWTH) + 1.0e-6);
    { final value: mean of the last 5 % of the run }
    LTail := Max(1, LN div 20);
    LM.YFinal := 0.0;
    for LI := LN - LTail to LN - 1 do
      LM.YFinal := LM.YFinal + LYs[LI];
    LM.YFinal := LM.YFinal / LTail;
    LM.SteadyError := ASettings.Setpoint - LM.YFinal;
    if Abs(LM.YFinal) > 1.0e-9 then
      LM.Overshoot := Max(0.0, (LYMax - LM.YFinal) / LM.YFinal * 100.0)
    else
      LM.Overshoot := 0.0;
    if not LM.Stable then
      Exit;
    { rise time 10 % to 90 % of y_final, linear interpolation }
    LT10 := -1.0;
    LT90 := -1.0;
    for LI := 1 to LN - 1 do
    begin
      LYPrev := LYs[LI - 1];
      LLevel := 0.1 * LM.YFinal;
      if (LT10 < 0.0) and (LYPrev < LLevel) and (LYs[LI] >= LLevel) then
        LT10 := ((LI - 1) + (LLevel - LYPrev) / (LYs[LI] - LYPrev)) * ASettings.Dt;
      LLevel := 0.9 * LM.YFinal;
      if (LT90 < 0.0) and (LYPrev < LLevel) and (LYs[LI] >= LLevel) then
      begin
        LT90 := ((LI - 1) + (LLevel - LYPrev) / (LYs[LI] - LYPrev)) * ASettings.Dt;
        Break;
      end;
    end;
    if (LT10 >= 0.0) and (LT90 >= 0.0) then
      LM.RiseTime := LT90 - LT10;
    { settling time: last sample outside the 2 % band of y_final }
    LM.SettlingTime := 0.0;
    for LI := LN - 1 downto 0 do
      if Abs(LYs[LI] - LM.YFinal) > 0.02 * Abs(LM.YFinal) then
      begin
        LM.SettlingTime := (LI + 1) * ASettings.Dt;
        Break;
      end;
    if LM.SettlingTime >= (LN - LTail) * ASettings.Dt then
      LM.SettlingTime := -1.0;
  finally
    AResult.Metrics := LM;
  end;
end;

end.
