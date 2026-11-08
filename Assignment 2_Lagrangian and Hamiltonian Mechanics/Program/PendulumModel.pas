unit PendulumModel;

{
  PendulumModel.pas - Numerical core of the spherical pendulum simulator
  (Biocybernetics Assignment 2, Lagrangian and Hamiltonian mechanics).

  Author : Jeremia Christ Immanuel Manalu (5023231017)

  The unit contains no user-interface code, so it is compiled and tested
  with Free Pascal in CI (Verification/TestPendulum.dpr).

  Coordinates as in the assignment figure: theta is the polar angle from
  the upward z axis, phi the azimuth from the x axis, r = l is fixed by the
  rigid link. The bob hangs at theta = pi; alpha = pi - theta is the angle
  from the downward vertical.

  Lagrange state  Y = [theta, thetadot, phi, phidot]   (report Eq. (2.14))
  Hamilton state  Z = [theta, p_theta,  phi, p_phi]    (report Eq. (2.21))
  Both systems are integrated with the classical RK4 method from the same
  initial state, so their results can be compared directly.
}

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

type
  TPendulumParams = record
    Mass: Double;     { m (kg) }
    Length: Double;   { l (m), r = l }
    Gravity: Double;  { g (m/s2) }
  end;

  TState4 = array[0..3] of Double;

  TStateFunction = function(const AParams: TPendulumParams;
    const AState: TState4): TState4;

  TSimSettings = record
    Alpha0Deg: Double;  { initial angle from the downward vertical (deg) }
    ThetaDot0: Double;  { initial polar rate (rad/s) }
    PhiDot0: Double;    { initial azimuthal rate (rad/s) }
    Dt: Double;         { RK4 step (s) }
    TEnd: Double;       { simulated time (s) }
  end;

  TSimResult = record
    Count: Integer;     { number of stored samples }
    T, ThetaL, PhiL, ThetaDot, PhiDot: array of Double;   { Lagrange }
    ThetaH, PhiH, PTheta, PPhi: array of Double;          { Hamilton }
    EnergyL, EnergyH: array of Double;                    { H = T + V (J) }
    X, Y, Z: array of Double;                             { bob position (m) }
    MaxThetaDiff: Double;     { max |theta_L - theta_H| (rad) }
    MaxEnergyErrL: Double;    { max |E - E0| / (m g l), Lagrange }
    MaxEnergyErrH: Double;    { max |E - E0| / (m g l), Hamilton }
    MaxPPhiErr: Double;       { max |p_phi - p_phi0| from the Lagrange state }
    AlphaMinDeg, AlphaMaxDeg: Double;   { range of alpha (deg) }
  end;

function DefaultParams: TPendulumParams;
function DefaultSettings: TSimSettings;
function LagrangeRHS(const AParams: TPendulumParams; const AState: TState4): TState4;
function HamiltonRHS(const AParams: TPendulumParams; const AState: TState4): TState4;
function RK4Step(AFunc: TStateFunction; const AParams: TPendulumParams;
  const AState: TState4; AStep: Double): TState4;
function EnergyOfLagrangeState(const AParams: TPendulumParams; const AState: TState4): Double;
function EnergyOfHamiltonState(const AParams: TPendulumParams; const AState: TState4): Double;
function ConicalRate(const AParams: TPendulumParams; AAlpha0Deg: Double): Double;
function ExactPlanarPeriod(const AParams: TPendulumParams; AAlpha0Deg: Double): Double;
function ThetaPeriod(const AResult: TSimResult): Double;
procedure Simulate(const AParams: TPendulumParams; const ASettings: TSimSettings;
  out AResult: TSimResult);

implementation

uses
  Math;

const
  C_MAX_SAMPLES = 4000;  { stored points per series (plotting) }

function DefaultParams: TPendulumParams;
begin
  Result.Mass := 1.0;
  Result.Length := 1.0;
  Result.Gravity := 9.81;
end;

function DefaultSettings: TSimSettings;
begin
  Result.Alpha0Deg := 60.0;
  Result.ThetaDot0 := 0.0;
  Result.PhiDot0 := 1.0;
  Result.Dt := 0.001;
  Result.TEnd := 20.0;
end;

{ Lagrange equations (2.12) and (2.13) as the first-order system (2.14).
  For planar motion (phidot = 0) the phi term is zero and is not evaluated,
  because cot(theta) is infinite when the bob passes the vertical axis. }
function LagrangeRHS(const AParams: TPendulumParams; const AState: TState4): TState4;
var
  LSin, LCos: Double;
begin
  LSin := Sin(AState[0]);
  LCos := Cos(AState[0]);
  Result[0] := AState[1];
  Result[1] := LSin * LCos * Sqr(AState[3]) +
    AParams.Gravity / AParams.Length * LSin;
  Result[2] := AState[3];
  if AState[3] = 0.0 then
    Result[3] := 0.0
  else
    Result[3] := -2.0 * LCos / LSin * AState[1] * AState[3];
end;

{ Hamilton's equations (2.17) to (2.20); p_phi = 0 is handled as above. }
function HamiltonRHS(const AParams: TPendulumParams; const AState: TState4): TState4;
var
  LSin, LCos, LInertia: Double;
begin
  LSin := Sin(AState[0]);
  LCos := Cos(AState[0]);
  LInertia := AParams.Mass * Sqr(AParams.Length);
  Result[0] := AState[1] / LInertia;
  Result[1] := AParams.Mass * AParams.Gravity * AParams.Length * LSin;
  if AState[3] = 0.0 then
    Result[2] := 0.0
  else
  begin
    Result[2] := AState[3] / (LInertia * Sqr(LSin));
    Result[1] := Result[1] + Sqr(AState[3]) * LCos / (LInertia * LSin * Sqr(LSin));
  end;
  Result[3] := 0.0;
end;

{ Classical fourth-order Runge-Kutta step, report Eq. (1.8). }
function RK4Step(AFunc: TStateFunction; const AParams: TPendulumParams;
  const AState: TState4; AStep: Double): TState4;
var
  LK1, LK2, LK3, LK4, LTmp: TState4;
  LI: Integer;
begin
  LK1 := AFunc(AParams, AState);
  for LI := 0 to 3 do
    LTmp[LI] := AState[LI] + 0.5 * AStep * LK1[LI];
  LK2 := AFunc(AParams, LTmp);
  for LI := 0 to 3 do
    LTmp[LI] := AState[LI] + 0.5 * AStep * LK2[LI];
  LK3 := AFunc(AParams, LTmp);
  for LI := 0 to 3 do
    LTmp[LI] := AState[LI] + AStep * LK3[LI];
  LK4 := AFunc(AParams, LTmp);
  for LI := 0 to 3 do
    Result[LI] := AState[LI] + AStep / 6.0 *
      (LK1[LI] + 2.0 * LK2[LI] + 2.0 * LK3[LI] + LK4[LI]);
end;

{ H = T + V with T of Eq. (2.9) and V of Eq. (2.10). }
function EnergyOfLagrangeState(const AParams: TPendulumParams; const AState: TState4): Double;
begin
  Result := 0.5 * AParams.Mass * Sqr(AParams.Length) *
    (Sqr(AState[1]) + Sqr(Sin(AState[0])) * Sqr(AState[3])) +
    AParams.Mass * AParams.Gravity * AParams.Length * Cos(AState[0]);
end;

{ Hamiltonian, Eq. (2.16). }
function EnergyOfHamiltonState(const AParams: TPendulumParams; const AState: TState4): Double;
var
  LInertia: Double;
begin
  LInertia := AParams.Mass * Sqr(AParams.Length);
  Result := Sqr(AState[1]) / (2.0 * LInertia) +
    AParams.Mass * AParams.Gravity * AParams.Length * Cos(AState[0]);
  if AState[3] <> 0.0 then
    Result := Result + Sqr(AState[3]) / (2.0 * LInertia * Sqr(Sin(AState[0])));
end;

{ Azimuthal rate of the conical pendulum, Omega^2 = g / (l cos alpha0). }
function ConicalRate(const AParams: TPendulumParams; AAlpha0Deg: Double): Double;
begin
  Result := Sqrt(AParams.Gravity / (AParams.Length * Cos(DegToRad(AAlpha0Deg))));
end;

{ Exact period of the planar pendulum, T = 4 sqrt(l/g) K(sin(alpha0/2)),
  with K(k) = pi / (2 AGM(1, sqrt(1 - k^2))). }
function ExactPlanarPeriod(const AParams: TPendulumParams; AAlpha0Deg: Double): Double;
var
  LK, LA, LB, LNext: Double;
begin
  LK := Sin(DegToRad(AAlpha0Deg) / 2.0);
  LA := 1.0;
  LB := Sqrt(1.0 - Sqr(LK));
  while Abs(LA - LB) > 1e-15 * LA do
  begin
    LNext := 0.5 * (LA + LB);
    LB := Sqrt(LA * LB);
    LA := LNext;
  end;
  Result := 4.0 * Sqrt(AParams.Length / AParams.Gravity) * Pi / (2.0 * LA);
end;

{ Mean period of theta from its upward crossings of the middle of its range
  (linear interpolation between samples); 0 if fewer than two crossings. }
function ThetaPeriod(const AResult: TSimResult): Double;
var
  LMid, LPrev, LCur, LCross, LFirst, LLast: Double;
  LI, LCount: Integer;
begin
  Result := 0.0;
  if AResult.Count < 3 then
    Exit;
  LMid := Pi - DegToRad(0.5 * (AResult.AlphaMinDeg + AResult.AlphaMaxDeg));
  LCount := 0;
  LFirst := 0.0;
  LLast := 0.0;
  for LI := 1 to AResult.Count - 1 do
  begin
    LPrev := AResult.ThetaL[LI - 1] - LMid;
    LCur := AResult.ThetaL[LI] - LMid;
    if (LPrev < 0.0) and (LCur >= 0.0) then
    begin
      LCross := AResult.T[LI - 1] + (AResult.T[LI] - AResult.T[LI - 1]) * (-LPrev) / (LCur - LPrev);
      if LCount = 0 then
        LFirst := LCross;
      LLast := LCross;
      Inc(LCount);
    end;
  end;
  if LCount >= 2 then
    Result := (LLast - LFirst) / (LCount - 1);
end;

{ Integrates the Lagrange and the Hamilton system from the same state and
  stores at most C_MAX_SAMPLES samples; the accuracy measures use every step. }
procedure Simulate(const AParams: TPendulumParams; const ASettings: TSimSettings;
  out AResult: TSimResult);
var
  LY, LZ: TState4;
  LSteps, LStride, LStep, LK: Integer;
  LInertia, LE0, LScale, LPPhi0, LAlpha: Double;

  procedure Store(AIndex: Integer; ATime: Double);
  begin
    AResult.T[AIndex] := ATime;
    AResult.ThetaL[AIndex] := LY[0];
    AResult.ThetaDot[AIndex] := LY[1];
    AResult.PhiL[AIndex] := LY[2];
    AResult.PhiDot[AIndex] := LY[3];
    AResult.ThetaH[AIndex] := LZ[0];
    AResult.PTheta[AIndex] := LZ[1];
    AResult.PhiH[AIndex] := LZ[2];
    AResult.PPhi[AIndex] := LZ[3];
    AResult.EnergyL[AIndex] := EnergyOfLagrangeState(AParams, LY);
    AResult.EnergyH[AIndex] := EnergyOfHamiltonState(AParams, LZ);
    AResult.X[AIndex] := AParams.Length * Sin(LY[0]) * Cos(LY[2]);
    AResult.Y[AIndex] := AParams.Length * Sin(LY[0]) * Sin(LY[2]);
    AResult.Z[AIndex] := AParams.Length * Cos(LY[0]);
  end;

  procedure Measure;
  begin
    AResult.MaxThetaDiff := Max(AResult.MaxThetaDiff, Abs(LY[0] - LZ[0]));
    AResult.MaxEnergyErrL := Max(AResult.MaxEnergyErrL,
      Abs(EnergyOfLagrangeState(AParams, LY) - LE0) / LScale);
    AResult.MaxEnergyErrH := Max(AResult.MaxEnergyErrH,
      Abs(EnergyOfHamiltonState(AParams, LZ) - LE0) / LScale);
    AResult.MaxPPhiErr := Max(AResult.MaxPPhiErr,
      Abs(LInertia * Sqr(Sin(LY[0])) * LY[3] - LPPhi0));
    LAlpha := RadToDeg(Pi - LY[0]);
    AResult.AlphaMinDeg := Min(AResult.AlphaMinDeg, LAlpha);
    AResult.AlphaMaxDeg := Max(AResult.AlphaMaxDeg, LAlpha);
  end;

begin
  LInertia := AParams.Mass * Sqr(AParams.Length);
  LY[0] := Pi - DegToRad(ASettings.Alpha0Deg);
  LY[1] := ASettings.ThetaDot0;
  LY[2] := 0.0;
  LY[3] := ASettings.PhiDot0;
  LZ[0] := LY[0];
  LZ[1] := LInertia * LY[1];        { p_theta = m l^2 thetadot, Eq. (2.15) }
  LZ[2] := 0.0;
  LZ[3] := LInertia * Sqr(Sin(LY[0])) * LY[3];   { p_phi = m l^2 sin^2 theta phidot }
  LE0 := EnergyOfLagrangeState(AParams, LY);
  LScale := AParams.Mass * AParams.Gravity * AParams.Length;
  LPPhi0 := LZ[3];

  LSteps := Round(ASettings.TEnd / ASettings.Dt);
  LStride := Max(1, (LSteps + C_MAX_SAMPLES - 1) div C_MAX_SAMPLES);
  AResult.Count := LSteps div LStride + 2;   { + start and final state }
  SetLength(AResult.T, AResult.Count);
  SetLength(AResult.ThetaL, AResult.Count);
  SetLength(AResult.ThetaDot, AResult.Count);
  SetLength(AResult.PhiL, AResult.Count);
  SetLength(AResult.PhiDot, AResult.Count);
  SetLength(AResult.ThetaH, AResult.Count);
  SetLength(AResult.PTheta, AResult.Count);
  SetLength(AResult.PhiH, AResult.Count);
  SetLength(AResult.PPhi, AResult.Count);
  SetLength(AResult.EnergyL, AResult.Count);
  SetLength(AResult.EnergyH, AResult.Count);
  SetLength(AResult.X, AResult.Count);
  SetLength(AResult.Y, AResult.Count);
  SetLength(AResult.Z, AResult.Count);
  AResult.MaxThetaDiff := 0.0;
  AResult.MaxEnergyErrL := 0.0;
  AResult.MaxEnergyErrH := 0.0;
  AResult.MaxPPhiErr := 0.0;
  AResult.AlphaMinDeg := ASettings.Alpha0Deg;
  AResult.AlphaMaxDeg := ASettings.Alpha0Deg;

  Store(0, 0.0);
  LK := 1;
  for LStep := 1 to LSteps do
  begin
    LY := RK4Step(LagrangeRHS, AParams, LY, ASettings.Dt);
    LZ := RK4Step(HamiltonRHS, AParams, LZ, ASettings.Dt);
    Measure;
    if ((LStep mod LStride = 0) or (LStep = LSteps)) and (LK < AResult.Count) then
    begin
      Store(LK, LStep * ASettings.Dt);
      Inc(LK);
    end;
  end;
  AResult.Count := LK;
end;

end.
