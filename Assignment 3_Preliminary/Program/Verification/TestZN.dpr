program TestZN;

{
  Console test of ZNModel.pas (Biocybernetics Assignment 3).
  Compiled with Free Pascal in CI; the output is compared with the golden
  file TestZN_output.txt, and the exit code is the number of failed
  acceptance checks. With "--csv <folder>" the responses used for the
  report figures are also written as CSV files.

  Cases (unit step, setpoint 1, RK4 step 1 ms, 30 s unless stated)
    C1  plant 1 open loop vs the exact step response (RK4 accuracy)
    C2  plant 1, theta = 0: tangent R, L, T vs the analytic values
    C3  plant 2, theta = 0: largest slope at t = 0, L = 0, Method 1 invalid
    C4  theta = 0: no phase crossover; simulated Ku scales with 1/dt
    C5  theta = 0.1 s: Method 1 (L shifted by theta) and Method 2
        (analytic Ku, Pu vs the simulated P loop)
    C6  theta = 0.1 s: ZN gain tables and closed-loop stability of
        P, PI, PID for both plants and both methods
    C7  dead-time sweep 0.05 s, 0.1 s, 0.2 s (report Table 2.x)
    C8  earlier-program approach: L from the 0.25 crossing and the plant
        2 model without the 2x' term (values only, no acceptance check)
    C9  impulse response (pulse of area 1): plant 1 vs the exact g(t),
        plant 2 starts at g(0+) = 2
}

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}
{$APPTYPE CONSOLE}

uses
  SysUtils, Math, ZNModel;

var
  GFailures: Integer = 0;
  GCsvDir: string = '';

procedure Check(const AName: string; ACondition: Boolean; AValue: Double);
begin
  if ACondition then
    Writeln('[PASS] ', AName, ' = ', FloatToStrF(AValue, ffGeneral, 8, 0))
  else
  begin
    Writeln('[FAIL] ', AName, ' = ', FloatToStrF(AValue, ffGeneral, 8, 0));
    Inc(GFailures);
  end;
end;

function F4(AValue: Double): string;
begin
  Result := FormatFloat('0.0000', AValue);
end;

function PlantName(APlant: TPlantKind): string;
begin
  if APlant = pkPlant1 then
    Result := 'plant 1'
  else
    Result := 'plant 2';
end;

procedure WriteCsv(const AName: string; const AResp: TResponse);
var
  LF: TextFile;
  LI: Integer;
begin
  if GCsvDir = '' then
    Exit;
  AssignFile(LF, IncludeTrailingPathDelimiter(GCsvDir) + AName + '.csv');
  Rewrite(LF);
  Writeln(LF, 't_s,y,ydot,u');
  for LI := 0 to AResp.Count - 1 do
    Writeln(LF, FormatFloat('0.000000', AResp.T[LI]), ',', FormatFloat('0.000000000', AResp.Y[LI]),
      ',', FormatFloat('0.000000000', AResp.YDot[LI]), ',', FormatFloat('0.000000000', AResp.U[LI]));
  CloseFile(LF);
end;

{ Exact unit-step response of plant 1 (zeta = 0.25, wn = 1). }
function ExactStep1(AT: Double): Double;
var
  LZeta, LWd: Double;
begin
  LZeta := 0.25;
  LWd := Sqrt(1.0 - Sqr(LZeta));
  Result := 1.0 - Exp(-LZeta * AT) * (Cos(LWd * AT) + LZeta / LWd * Sin(LWd * AT));
end;

procedure CaseC1;
var
  LZ, LZDot, LErr: Double;
  LStep: Integer;
begin
  LZ := 0.0;
  LZDot := 0.0;
  LErr := 0.0;
  for LStep := 1 to 10000 do
  begin
    RK4Step(Plant1Accel, LZ, LZDot, 1.0, 0.001);
    LErr := Max(LErr, Abs(LZ - ExactStep1(LStep * 0.001)));
  end;
  Writeln('C1 plant 1 step, 10 s: max |y_RK4 - y_exact| = ', FloatToStrF(LErr, ffExponent, 3, 2));
  Check('C1 RK4 error', LErr < 1.0e-9, LErr);
end;

procedure CaseC2;
var
  LS: TSimSettings;
  LM: TMethod1Result;
  LZeta, LWd, LTs, LYs, LR, LL: Double;
begin
  LS := DefaultSettings;
  LS.DeadTime := 0.0;
  ZNMethod1(pkPlant1, LS, LM);
  { analytic: wd t* = arccos(zeta), R = exp(-zeta t*), L = t* - y*/R }
  LZeta := 0.25;
  LWd := Sqrt(1.0 - Sqr(LZeta));
  LTs := ArcCos(LZeta) / LWd;
  LR := Exp(-LZeta * LTs);
  LYs := ExactStep1(LTs);
  LL := LTs - LYs / LR;
  Writeln('C2 plant 1, theta = 0: t* = ', F4(LM.TInfl), ' (exact ', F4(LTs), '), y* = ', F4(LM.YInfl),
    ', R = ', F4(LM.R), ' (exact ', F4(LR), '), L = ', F4(LM.L), ' (exact ', F4(LL), '), T = ',
    F4(LM.T), ', K = ', F4(LM.K), ', overshoot = ', FormatFloat('0.00', LM.Overshoot), ' %');
  Check('C2 |R - R_exact|', Abs(LM.R - LR) < 1.0e-5, Abs(LM.R - LR));
  Check('C2 |L - L_exact| (s)', Abs(LM.L - LL) < 2.0e-3, Abs(LM.L - LL));
  Check('C2 Method 1 valid', LM.Valid, Ord(LM.Valid));
  WriteCsv('open_p1_theta0', LM.Response);
end;

procedure CaseC3;
var
  LS: TSimSettings;
  LM: TMethod1Result;
begin
  LS := DefaultSettings;
  LS.DeadTime := 0.0;
  ZNMethod1(pkPlant2, LS, LM);
  Writeln('C3 plant 2, theta = 0: largest slope R = ', F4(LM.R), ' at t = ', F4(LM.TInfl),
    ' s, y there = ', F4(LM.YInfl), ', overshoot = ', FormatFloat('0.00', LM.Overshoot), ' %');
  Check('C3 slope at t = 0 (expected 2)', Abs(LM.R - 2.0) < 1.0e-9, LM.R);
  Check('C3 Method 1 rejected (L = 0)', not LM.Valid, Ord(LM.Valid));
  WriteCsv('open_p2_theta0', LM.Response);
end;

procedure CaseC4;
var
  LS: TSimSettings;
  LR1, LR2: TMethod2Result;
  LPlant: TPlantKind;
  LKu, LPu, LWu: Double;
begin
  for LPlant := pkPlant1 to pkPlant2 do
  begin
    Check('C4 ' + PlantName(LPlant) + ' no phase crossover at theta = 0',
      not CriticalGainAnalytic(LPlant, 0.0, LKu, LPu, LWu), LKu);
    LS := DefaultSettings;
    LS.DeadTime := 0.0;
    LS.Dt := 0.001;
    ZNMethod2(LPlant, LS, LR1);
    LS.Dt := 0.01;
    ZNMethod2(LPlant, LS, LR2);
    Writeln('C4 ', PlantName(LPlant), ': simulated Ku = ', FormatFloat('0.00', LR1.KuSim), ' (dt = 1 ms), ',
      FormatFloat('0.00', LR2.KuSim), ' (dt = 10 ms); Ku dt = ', F4(LR1.KuSim * 0.001), ', ',
      F4(LR2.KuSim * 0.01), '; Pu = ', FormatFloat('0.0000', LR1.PuSim), ' s, ',
      FormatFloat('0.0000', LR2.PuSim), ' s');
    Check('C4 ' + PlantName(LPlant) + ' Ku ratio dt 1 ms / 10 ms (about 10)',
      LR1.SimFound and LR2.SimFound and (Abs(LR1.KuSim / LR2.KuSim - 10.0) < 0.5), LR1.KuSim / LR2.KuSim);
    Check('C4 ' + PlantName(LPlant) + ' Method 2 rejected', not LR1.Valid, Ord(LR1.Valid));
  end;
end;

procedure CaseC5(out AM1: array of TMethod1Result; out AM2: array of TMethod2Result);
var
  LS: TSimSettings;
  LPlant: TPlantKind;
  LI: Integer;
begin
  LS := DefaultSettings;
  for LPlant := pkPlant1 to pkPlant2 do
  begin
    LI := Ord(LPlant);
    ZNMethod1(LPlant, LS, AM1[LI]);
    ZNMethod2(LPlant, LS, AM2[LI]);
    Writeln('C5 ', PlantName(LPlant), ', theta = 0.1 s: R = ', F4(AM1[LI].R), ', L = ', F4(AM1[LI].L),
      ' s, T = ', F4(AM1[LI].T), ' s, K = ', F4(AM1[LI].K));
    Writeln('C5 ', PlantName(LPlant), ', theta = 0.1 s: Ku = ', F4(AM2[LI].Ku), ', Pu = ', F4(AM2[LI].Pu),
      ' s, wu = ', F4(AM2[LI].Wu), ' rad/s; simulated Ku = ', F4(AM2[LI].KuSim), ', Pu = ',
      F4(AM2[LI].PuSim), ' s');
    Check('C5 ' + PlantName(LPlant) + ' Method 1 valid', AM1[LI].Valid, Ord(AM1[LI].Valid));
    Check('C5 ' + PlantName(LPlant) + ' Method 2 valid', AM2[LI].Valid, Ord(AM2[LI].Valid));
    Check('C5 ' + PlantName(LPlant) + ' |Ku_sim/Ku - 1|', Abs(AM2[LI].KuSim / AM2[LI].Ku - 1.0) < 0.02,
      Abs(AM2[LI].KuSim / AM2[LI].Ku - 1.0));
    Check('C5 ' + PlantName(LPlant) + ' |Pu_sim/Pu - 1|', Abs(AM2[LI].PuSim / AM2[LI].Pu - 1.0) < 0.02,
      Abs(AM2[LI].PuSim / AM2[LI].Pu - 1.0));
  end;
  Check('C5 plant 1 L shifted by theta (0.4561 + 0.1)', Abs(AM1[0].L - 0.5561) < 2.0e-3, AM1[0].L);
  Check('C5 plant 2 L = theta', Abs(AM1[1].L - 0.1) < 1.0e-6, AM1[1].L);
  WriteCsv('open_p1_theta01', AM1[0].Response);
  WriteCsv('open_p2_theta01', AM1[1].Response);
  WriteCsv('ploop_p1_ku', AM2[0].Response);
  WriteCsv('ploop_p2_ku', AM2[1].Response);
end;

procedure CaseC6(const AM1: array of TMethod1Result; const AM2: array of TMethod2Result);
const
  { expected stability (ISS-054): plant 1 PI unstable for both methods }
  C_EXPECT: array[0..1, TControllerKind] of Boolean = ((True, False, True), (True, True, True));
var
  LS: TSimSettings;
  LPlant: TPlantKind;
  LMethod: TZNMethod;
  LCtrl: TControllerKind;
  LTable: TGainTable;
  LRes: TClosedLoopResult;
  LTag: string;
begin
  LS := DefaultSettings;
  for LPlant := pkPlant1 to pkPlant2 do
    for LMethod := zmMethod1 to zmMethod2 do
    begin
      if LMethod = zmMethod1 then
        LTable := GainsMethod1(AM1[Ord(LPlant)].R, AM1[Ord(LPlant)].L)
      else
        LTable := GainsMethod2(AM2[Ord(LPlant)].Ku, AM2[Ord(LPlant)].Pu);
      for LCtrl := ckP to ckPID do
      begin
        SimulateClosedLoop(LPlant, LTable[LCtrl], LS, LRes);
        LTag := 'C6 ' + PlantName(LPlant) + ' M' + IntToStr(Ord(LMethod) + 1) + ' ' +
          C_CONTROLLER_NAMES[LCtrl];
        Write(LTag, ': Kp = ', F4(LTable[LCtrl].Kp), ', Ki = ', F4(LTable[LCtrl].Ki), ', Kd = ',
          F4(LTable[LCtrl].Kd));
        if LRes.Metrics.Stable then
          Writeln(', OS = ', FormatFloat('0.0', LRes.Metrics.Overshoot), ' %, tr = ',
            FormatFloat('0.000', LRes.Metrics.RiseTime), ' s, ts = ',
            FormatFloat('0.00', LRes.Metrics.SettlingTime), ' s, ess = ',
            FormatFloat('0.0000', LRes.Metrics.SteadyError), ', IAE = ', F4(LRes.Metrics.IAE),
            ', ISE = ', F4(LRes.Metrics.ISE))
        else if LRes.Metrics.Diverged then
          Writeln(', unstable (|y| > 1000 at t = ', FormatFloat('0.00',
            LRes.Response.T[LRes.Response.Count - 1]), ' s)')
        else
          Writeln(', unstable (growing oscillation)');
        Check(LTag + ' stability as expected', LRes.Metrics.Stable = C_EXPECT[Ord(LPlant), LCtrl],
          Ord(LRes.Metrics.Stable));
        WriteCsv('cl_p' + IntToStr(Ord(LPlant) + 1) + '_m' + IntToStr(Ord(LMethod) + 1) + '_' +
          LowerCase(C_CONTROLLER_NAMES[LCtrl]), LRes.Response);
      end;
    end;
end;

procedure CaseC7;
const
  C_THETAS: array[0..2] of Double = (0.05, 0.1, 0.2);
var
  LS: TSimSettings;
  LPlant: TPlantKind;
  LI: Integer;
  LM1: TMethod1Result;
  LKu, LPu, LWu: Double;
  LG1, LG2: TGainTable;
  LR1, LR2: TClosedLoopResult;
begin
  for LPlant := pkPlant1 to pkPlant2 do
    for LI := 0 to High(C_THETAS) do
    begin
      LS := DefaultSettings;
      LS.DeadTime := C_THETAS[LI];
      ZNMethod1(LPlant, LS, LM1);
      CriticalGainAnalytic(LPlant, LS.DeadTime, LKu, LPu, LWu);
      LG1 := GainsMethod1(LM1.R, LM1.L);
      LG2 := GainsMethod2(LKu, LPu);
      SimulateClosedLoop(LPlant, LG1[ckPID], LS, LR1);
      SimulateClosedLoop(LPlant, LG2[ckPID], LS, LR2);
      Writeln('C7 ', PlantName(LPlant), ' theta = ', FormatFloat('0.00', LS.DeadTime), ' s: L = ', F4(LM1.L),
        ', R = ', F4(LM1.R), ', Ku = ', F4(LKu), ', Pu = ', F4(LPu), '; PID M1 OS = ',
        FormatFloat('0.0', LR1.Metrics.Overshoot), ' %, ts = ', FormatFloat('0.00', LR1.Metrics.SettlingTime),
        ' s; PID M2 OS = ', FormatFloat('0.0', LR2.Metrics.Overshoot), ' %, ts = ',
        FormatFloat('0.00', LR2.Metrics.SettlingTime), ' s');
    end;
  Check('C7 sweep completed', True, 3);
end;

procedure CaseC8;
var
  LZ, LZDot, LYPrev, LT25, LT1, LYMax: Double;
  LStep: Integer;
  LS: TSimSettings;
  LM: TMethod1Result;
begin
  { threshold rule of earlier programs on the plant-1 response, theta = 0 }
  LS := DefaultSettings;
  LS.DeadTime := 0.0;
  LT25 := -1.0;
  LT1 := -1.0;
  LZ := 0.0;
  LZDot := 0.0;
  for LStep := 1 to 30000 do
  begin
    LYPrev := LZ;
    RK4Step(Plant1Accel, LZ, LZDot, 1.0, 0.001);
    if (LT25 < 0.0) and (LYPrev <= 0.25) and (LZ > 0.25) then
      LT25 := LStep * 0.001;
    if (LT1 < 0.0) and (LYPrev < 1.0) and (LZ >= 1.0) then
      LT1 := LStep * 0.001;
  end;
  Writeln('C8 plant 1 threshold rule: L = t(y=0.25) = ', F4(LT25), ' s, T = t(y=1) - L = ',
    F4(LT1 - LT25), ' s, R = 1/T = ', F4(1.0 / (LT1 - LT25)));
  { plant 2 without the 2x' term: 1/(s^2 + 1.5 s + 1), output z }
  LZ := 0.0;
  LZDot := 0.0;
  LYMax := 0.0;
  for LStep := 1 to 30000 do
  begin
    RK4Step(Plant2Accel, LZ, LZDot, 1.0, 0.001);
    LYMax := Max(LYMax, LZ);
  end;
  ZNMethod1(pkPlant2, LS, LM);
  Writeln('C8 plant 2 without 2x'': overshoot = ', FormatFloat('0.00', (LYMax - LZ) / LZ * 100.0),
    ' %; with 2x'': overshoot = ', FormatFloat('0.00', LM.Overshoot), ' %');
end;

procedure CaseC9;
var
  LS: TSimSettings;
  LResp: TResponse;
  LPeak, LTPeak, LErr, LG, LWd: Double;
  LI: Integer;
begin
  LS := DefaultSettings;
  LS.DeadTime := 0.0;
  LS.TEnd := 20.0;
  SimulateImpulse(pkPlant1, LS, LResp, LPeak, LTPeak);
  LWd := Sqrt(1.0 - Sqr(0.25));
  LErr := 0.0;
  for LI := 1 to LResp.Count - 1 do
  begin
    LG := Exp(-0.25 * LResp.T[LI]) * Sin(LWd * LResp.T[LI]) / LWd;
    LErr := Max(LErr, Abs(LResp.Y[LI] - LG));
  end;
  Writeln('C9 plant 1 impulse: peak = ', F4(LPeak), ' at t = ', F4(LTPeak), ' s, max |y - g| = ',
    FloatToStrF(LErr, ffExponent, 3, 2));
  Check('C9 plant 1 impulse vs exact (pulse of one step)', LErr < 1.0e-3, LErr);
  WriteCsv('impulse_p1', LResp);
  SimulateImpulse(pkPlant2, LS, LResp, LPeak, LTPeak);
  Writeln('C9 plant 2 impulse: peak = ', F4(LPeak), ' at t = ', F4(LTPeak), ' s');
  Check('C9 plant 2 impulse starts near g(0+) = 2', Abs(LPeak - 2.0) < 0.01, LPeak);
  WriteCsv('impulse_p2', LResp);
end;

var
  GM1: array[0..1] of TMethod1Result;
  GM2: array[0..1] of TMethod2Result;
begin
  FormatSettings.DecimalSeparator := '.';
  if (ParamCount >= 2) and (ParamStr(1) = '--csv') then
  begin
    GCsvDir := ParamStr(2);
    ForceDirectories(GCsvDir);
  end;
  CaseC1;
  CaseC2;
  CaseC3;
  CaseC4;
  CaseC5(GM1, GM2);
  CaseC6(GM1, GM2);
  CaseC7;
  CaseC8;
  CaseC9;
  Writeln(GFailures, ' failure(s)');
  Halt(GFailures);
end.
