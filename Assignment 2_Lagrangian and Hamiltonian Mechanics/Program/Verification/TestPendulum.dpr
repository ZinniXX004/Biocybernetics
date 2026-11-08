program TestPendulum;

{
  Console test of PendulumModel.pas (Biocybernetics Assignment 2).
  Compiled with Free Pascal in CI; the output is compared with the golden
  file TestPendulum_output.txt, and the exit code is the number of failed
  acceptance checks.

  Cases (m = 1 kg, l = 1 m, g = 9.81 m/s2, RK4 step 1 ms)
    C1  planar pendulum, alpha0 = 10 deg    period = exact elliptic period
    C2  planar pendulum, alpha0 = 90 deg    period = exact elliptic period
    C3  conical pendulum, alpha0 = 30 deg   alpha stays constant
    C4  general motion, alpha0 = 60 deg, phidot0 = 1 rad/s
                                            Lagrange = Hamilton, H and p_phi
                                            constant, turning points
    C5  link length 0.5 m and 2 m           period proportional to sqrt(l)
}

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}
{$APPTYPE CONSOLE}

uses
  SysUtils, Math, PendulumModel;

var
  GFailures: Integer = 0;

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

{ Smallest turning angle alpha (deg) of the general motion: root of
  m g l u^3 - E u^2 - m g l u + E - p_phi^2 / (2 m l^2) = 0, u = cos(theta),
  found by bisection between the hanging position and the start angle. }
function TurningAngleDeg(const AParams: TPendulumParams; AAlpha0Deg, APhiDot0: Double): Double;
var
  LInertia, LMgl, LE, LPPhi, LLo, LHi, LMid: Double;
  LI: Integer;

  function F(AU: Double): Double;
  begin
    Result := ((LMgl * AU - LE) * AU - LMgl) * AU + LE - Sqr(LPPhi) / (2.0 * LInertia);
  end;

begin
  LInertia := AParams.Mass * Sqr(AParams.Length);
  LMgl := AParams.Mass * AParams.Gravity * AParams.Length;
  LPPhi := LInertia * Sqr(Sin(DegToRad(AAlpha0Deg))) * APhiDot0;
  LE := 0.5 * LInertia * Sqr(Sin(DegToRad(AAlpha0Deg))) * Sqr(APhiDot0) -
    LMgl * Cos(DegToRad(AAlpha0Deg));
  { u = cos(theta) = -cos(alpha); search alpha in (0.01 deg, alpha0 - 0.01 deg) }
  LLo := -Cos(DegToRad(0.01));
  LHi := -Cos(DegToRad(AAlpha0Deg - 0.01));
  for LI := 1 to 200 do
  begin
    LMid := 0.5 * (LLo + LHi);
    if F(LLo) * F(LMid) <= 0.0 then
      LHi := LMid
    else
      LLo := LMid;
  end;
  Result := RadToDeg(ArcCos(-0.5 * (LLo + LHi)));
end;

procedure RunPlanar(const ATag: string; AAlpha0, ALength: Double; out APeriod, AExact: Double);
var
  LP: TPendulumParams;
  LS: TSimSettings;
  LR: TSimResult;
begin
  LP := DefaultParams;
  LP.Length := ALength;
  LS := DefaultSettings;
  LS.Alpha0Deg := AAlpha0;
  LS.PhiDot0 := 0.0;
  Simulate(LP, LS, LR);
  APeriod := ThetaPeriod(LR);
  AExact := ExactPlanarPeriod(LP, AAlpha0);
  Writeln(ATag, ' alpha0=', AAlpha0:0:1, ' l=', ALength:0:2, ' period=', APeriod:0:6,
    ' exact=', AExact:0:6, ' small-angle=', 2 * Pi * Sqrt(ALength / LP.Gravity):0:6,
    ' Ediff=', LR.MaxEnergyErrL:0:12);
end;

{ Writes the time series of one run as CSV (used for the report figures). }
procedure WriteCsv(const AFileName: string; const AResult: TSimResult);
var
  LFile: TextFile;
  LI: Integer;
begin
  AssignFile(LFile, AFileName);
  Rewrite(LFile);
  try
    Writeln(LFile, 't,theta,thetadot,phi,phidot,theta_H,p_theta,phi_H,p_phi,E_L,E_H,x,y,z');
    for LI := 0 to AResult.Count - 1 do
      Writeln(LFile, AResult.T[LI]:0:4, ',', AResult.ThetaL[LI]:0:10, ',', AResult.ThetaDot[LI]:0:10, ',',
        AResult.PhiL[LI]:0:10, ',', AResult.PhiDot[LI]:0:10, ',', AResult.ThetaH[LI]:0:10, ',',
        AResult.PTheta[LI]:0:10, ',', AResult.PhiH[LI]:0:10, ',', AResult.PPhi[LI]:0:10, ',',
        AResult.EnergyL[LI]:0:12, ',', AResult.EnergyH[LI]:0:12, ',', AResult.X[LI]:0:8, ',',
        AResult.Y[LI]:0:8, ',', AResult.Z[LI]:0:8);
  finally
    CloseFile(LFile);
  end;
end;

{ "TestPendulum --csv DIR" writes the four presets of the program to DIR. }
procedure ExportPresets(const ADir: string);
var
  LP: TPendulumParams;
  LS: TSimSettings;
  LR: TSimResult;
begin
  LP := DefaultParams;
  LS := DefaultSettings;
  Simulate(LP, LS, LR);
  WriteCsv(IncludeTrailingPathDelimiter(ADir) + 'general.csv', LR);
  LS.Alpha0Deg := 10.0;
  LS.PhiDot0 := 0.0;
  Simulate(LP, LS, LR);
  WriteCsv(IncludeTrailingPathDelimiter(ADir) + 'planar10.csv', LR);
  LS.Alpha0Deg := 90.0;
  Simulate(LP, LS, LR);
  WriteCsv(IncludeTrailingPathDelimiter(ADir) + 'planar90.csv', LR);
  LS.Alpha0Deg := 30.0;
  LS.PhiDot0 := ConicalRate(LP, 30.0);
  Simulate(LP, LS, LR);
  WriteCsv(IncludeTrailingPathDelimiter(ADir) + 'conical30.csv', LR);
end;

var
  GP: TPendulumParams;
  GS: TSimSettings;
  GR: TSimResult;
  GPeriod, GExact, GPeriodHalf, GPeriodDouble, GTurn, GOmega: Double;

begin
  FormatSettings.DecimalSeparator := '.';
  if (ParamCount = 2) and (ParamStr(1) = '--csv') then
  begin
    ExportPresets(ParamStr(2));
    Writeln('CSV written to ', ParamStr(2));
    Exit;
  end;

  RunPlanar('C1', 10.0, 1.0, GPeriod, GExact);
  Check('C1 period relative error', Abs(GPeriod - GExact) / GExact < 1e-4, Abs(GPeriod - GExact) / GExact);
  RunPlanar('C2', 90.0, 1.0, GPeriod, GExact);
  Check('C2 period relative error', Abs(GPeriod - GExact) / GExact < 1e-4, Abs(GPeriod - GExact) / GExact);

  GP := DefaultParams;
  GS := DefaultSettings;
  GS.Alpha0Deg := 30.0;
  GOmega := ConicalRate(GP, 30.0);
  GS.PhiDot0 := GOmega;
  GS.TEnd := 10.0;
  Simulate(GP, GS, GR);
  Writeln('C3 Omega=', GOmega:0:6, ' alpha range=', GR.AlphaMinDeg:0:9, '..', GR.AlphaMaxDeg:0:9,
    ' phi(end)=', GR.PhiL[GR.Count - 1]:0:4);
  Check('C3 alpha deviation (deg)', GR.AlphaMaxDeg - GR.AlphaMinDeg < 1e-6, GR.AlphaMaxDeg - GR.AlphaMinDeg);

  GS := DefaultSettings;
  Simulate(GP, GS, GR);
  GTurn := TurningAngleDeg(GP, GS.Alpha0Deg, GS.PhiDot0);
  Writeln('C4 alpha range=', GR.AlphaMinDeg:0:5, '..', GR.AlphaMaxDeg:0:5, ' cubic=', GTurn:0:5,
    ' p_phi=', GR.PPhi[0]:0:4, ' E0=', GR.EnergyL[0]:0:4, ' theta period=', ThetaPeriod(GR):0:4);
  Writeln('C4 max|thetaL-thetaH|=', GR.MaxThetaDiff:0:12, ' Eerr L=', GR.MaxEnergyErrL:0:12,
    ' Eerr H=', GR.MaxEnergyErrH:0:12, ' p_phi err=', GR.MaxPPhiErr:0:12);
  Check('C4 Lagrange vs Hamilton (rad)', GR.MaxThetaDiff < 1e-8, GR.MaxThetaDiff);
  Check('C4 energy error Lagrange', GR.MaxEnergyErrL < 1e-8, GR.MaxEnergyErrL);
  Check('C4 energy error Hamilton', GR.MaxEnergyErrH < 1e-8, GR.MaxEnergyErrH);
  Check('C4 p_phi error', GR.MaxPPhiErr < 1e-8, GR.MaxPPhiErr);
  Check('C4 turning angle vs cubic (deg)', Abs(GR.AlphaMinDeg - GTurn) < 1e-3, Abs(GR.AlphaMinDeg - GTurn));

  RunPlanar('C5', 10.0, 0.5, GPeriodHalf, GExact);
  RunPlanar('C5', 10.0, 2.0, GPeriodDouble, GExact);
  Check('C5 period ratio l=2 / l=0.5 (expected 2)', Abs(GPeriodDouble / GPeriodHalf - 2.0) < 1e-4,
    GPeriodDouble / GPeriodHalf);

  Writeln(GFailures, ' failure(s)');
  ExitCode := GFailures;
end.
