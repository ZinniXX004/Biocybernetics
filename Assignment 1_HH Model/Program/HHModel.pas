unit HHModel;

{
  HHModel.pas - Numerical core of the Hodgkin-Huxley (HH) neuron simulator.

  Course   : Biocybernetics (EB234701), Class Q - Assignment 1
  Author   : Jeremia Christ Immanuel Manalu (5023231017)
  Compiler : Embarcadero Delphi 13 Florence (also compiles with FPC 3.2
             in Delphi mode, which is used for headless verification).

  This unit contains NO user-interface code. The VCL form (Unit1.pas) only
  collects parameters, calls the routines below and plots the results.

  Sign convention (identical to Hodgkin & Huxley, 1952 and to the lecturer's
  week-9 material):
    v   = displacement of the membrane potential from rest, in mV,
          DEPOLARIZATION IS NEGATIVE.
    VNa = -115 mV, VK = +12 mV, VL = -10.613 mV (relative to rest).
    Jin < 0 depolarizes the membrane (cathodal stimulus),
    Jin > 0 hyperpolarizes it (anodal stimulus).
    The absolute membrane voltage is recovered with  Vm = -(v + 70) mV.

  Units: time in ms, voltage in mV, current density in uA/cm2,
         conductance in mS/cm2, capacitance in uF/cm2.
}

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

interface

uses
{$IFDEF FPC}
  SysUtils, Math;
{$ELSE}
  System.SysUtils, System.Math;
{$ENDIF}

const
  V_REST_ABS = -70.0;   // absolute resting potential used for alignment (mV)
  SPIKE_LEVEL = 0.0;    // Vm level (mV) whose upward crossing defines a spike

type
  TDoubleArray = array of Double;

  { Membrane parameters of the space-clamped HH membrane }
  THHParams = record
    GNa0: Double;   // maximum sodium conductance      (mS/cm2)
    GK0: Double;    // maximum potassium conductance   (mS/cm2)
    GL0: Double;    // leakage conductance             (mS/cm2)
    VNa: Double;    // sodium equilibrium potential    (mV, HH convention)
    VK: Double;     // potassium equilibrium potential (mV, HH convention)
    VL: Double;     // leakage equilibrium potential   (mV, HH convention)
    Cm: Double;     // membrane capacitance            (uF/cm2)
    TempC: Double;  // temperature (deg C); rates scaled by 3^((T-6.3)/10)
  end;

  { State vector Y = [v, m, h, n] }
  THHState = record
    V: Double;
    M: Double;
    H: Double;
    N: Double;
  end;

  THHRates = record
    Am, Bm: Double;   // sodium activation rates   (1/ms)
    Ah, Bh: Double;   // sodium inactivation rates (1/ms)
    An, Bn: Double;   // potassium activation rates(1/ms)
  end;

  TIntegrator = (
    imCoupledRK4,     // classical RK4 applied to the full 4-D state vector
    imLecturerRK4     // lecturer scheme: scalar RK4 per variable, rates frozen
  );

  TStimKind = (
    skStep,               // JLevel between TOn and TOff, JBase elsewhere
    skLecturerStaircase,  // -5 / -10 / -20 / 0 uA/cm2 (week-9 source code)
    skPairedPulse         // two rectangular pulses separated by Interval
  );

  TStimulus = record
    Kind: TStimKind;
    JBase: Double;       // baseline current density (uA/cm2)
    JLevel: Double;      // step level / first pulse amplitude (uA/cm2)
    TOn: Double;         // step onset / first pulse onset (ms)
    TOff: Double;        // step offset (ms)
    PulseWidth: Double;  // pulse width (ms), paired-pulse protocol
    Interval: Double;    // onset-to-onset interval (ms), paired-pulse
    JLevel2: Double;     // second pulse amplitude (uA/cm2)
  end;

  { On-line spike detector: a spike is an upward crossing of SPIKE_LEVEL;
    its peak is the maximum of Vm until the downward crossing. }
  TSpikeDetector = record
    Above: Boolean;
    PeakV: Double;
    PeakT: Double;
    CrossT: Double;
    Count: Integer;
    CrossTimes: TDoubleArray;
    PeakTimes: TDoubleArray;
    PeakValues: TDoubleArray;
    procedure Reset;
    procedure Feed(const T, Vm: Double);
    procedure Finish;
  end;

  TAPGResult = record
    Count: Integer;
    T, Vm, V, Jin: TDoubleArray;
    JNa, JK, JL: TDoubleArray;
    M, H, N: TDoubleArray;
    GNa, GK: TDoubleArray;
    SpikeCross: TDoubleArray;   // upward 0 mV crossing times (ms)
    SpikeTimes: TDoubleArray;   // peak times (ms)
    SpikePeaks: TDoubleArray;   // peak values (mV)
  end;

  TCableMode = (cmActiveHH, cmPassive);

  { Time integration of the diffusion term of the cable equation:
    explicit forward-time central-space (stable for r <= 0.5) or
    Crank-Nicolson (trapezoidal in time, unconditionally stable) }
  TCableScheme = (csExplicitFTCS, csCrankNicolson);

  { Excitation at x = 0: current pulses injected into the first segment, or
    a membrane voltage trace imposed on node 0 (the APG waveform of tab 1,
    as in the lecturer's propagation program) }
  TCableDrive = (cdCurrentPulses, cdVoltageTrace);

  TCableParams = record
    RadiusUm: Double;      // axon radius a (um)
    RiOhmCm: Double;       // specific axoplasm resistivity Ri (ohm.cm)
    RoOhmPerCm: Double;    // external resistance per unit length ro (ohm/cm)
    LengthCm: Double;      // axon length (cm)
    DxCm: Double;          // spatial step h (cm)
    Dt: Double;            // time step k (ms)
    TEnd: Double;          // simulated time (ms)
    StimAmp: Double;       // stimulus current density (uA/cm2)
    StimDur: Double;       // stimulus duration (ms)
    StimLengthCm: Double;  // stimulus applied for x <= StimLengthCm
    Mode: TCableMode;
    GmPassive: Double;     // membrane conductance for passive mode (mS/cm2)
    SaveEvery: Integer;    // store one frame every SaveEvery time steps
    Scheme: TCableScheme;  // FTCS or Crank-Nicolson
    Drive: TCableDrive;    // current pulses or voltage trace at x = 0
    PulseCount: Integer;   // number of current pulses (cdCurrentPulses)
    PulseInterval: Double; // onset-to-onset interval of the pulses (ms)
    DriveV: TDoubleArray;  // v(t) of node 0 at t = 0, k, 2k, ... (cdVoltageTrace)
  end;

  TCableResult = record
    Stable: Boolean;           // FTCS: r <= 0.5; Crank-Nicolson: always
    NNodes: Integer;
    NSaved: Integer;
    X: TDoubleArray;           // node positions (cm)
    T: TDoubleArray;           // saved frame times (ms)
    Vm: array of TDoubleArray; // Vm[frame][node] (mV, absolute)
    PeakVm: TDoubleArray;      // maximum Vm reached at each node (mV)
    TCross: TDoubleArray;      // first upward 0 mV crossing per node (ms)
    RiPerLen: Double;          // ri (ohm/cm)
    CmPerLen: Double;          // cm (uF/cm)
    D: Double;                 // 1/((ri+ro).cm) (cm2/ms)
    R: Double;                 // diffusion number D.k/h^2 (-)
    LambdaCm: Double;          // passive length constant for GmPassive (cm)
    VelocityMs: Double;        // conduction velocity (m/s), NaN if none
  end;

{ Membrane model }
function DefaultHHParams: THHParams;
function TemperatureFactor(const P: THHParams): Double;
function ExpRatio(const X: Double): Double;
function ComputeRates(const V, Phi: Double): THHRates;
function SteadyState(const V, Phi: Double): THHState;
procedure IonicCurrents(const P: THHParams; const S: THHState;
  out JNa, JK, JL: Double);
function RestingConductance(const P: THHParams): Double;
function Derivatives(const P: THHParams; const Phi: Double;
  const S: THHState; const Jin: Double): THHState;
function StepCoupledRK4(const P: THHParams; const Phi: Double;
  const S: THHState; const J0, JHalf, J1, Dt: Double): THHState;
function StepLecturerRK4(const P: THHParams; const Phi: Double;
  const S: THHState; const Jin, Dt: Double): THHState;
function AbsoluteVm(const V: Double): Double; inline;

{ Stimulus }
function DefaultStimulus: TStimulus;
function StimulusAt(const Stim: TStimulus; const T: Double): Double;

{ Action potential generation }
procedure SimulateAPG(const P: THHParams; const Stim: TStimulus;
  const Dt, TEnd: Double; const Method: TIntegrator; out R: TAPGResult);
procedure SimulateSpikesOnly(const P: THHParams; const Stim: TStimulus;
  const Dt, TEnd: Double; const Method: TIntegrator;
  var Det: TSpikeDetector);

{ Refractory period }
function SecondSpikeOccurs(const P: THHParams; const J1, J2, Width,
  Interval, Dt: Double; const Method: TIntegrator;
  out SecondPeak: Double): Boolean;
function SinglePulseThreshold(const P: THHParams; const Sign, Width,
  JMaxAbs, Dt: Double; const Method: TIntegrator): Double;
function SecondPulseThreshold(const P: THHParams; const J1, Width,
  Interval, JMaxAbs, Dt: Double; const Method: TIntegrator): Double;

{ Input level versus inter-pulse interval }
procedure SteadyFiring(const P: THHParams; const J, Dt, TEnd,
  TDiscard: Double; const Method: TIntegrator;
  out NSpikes: Integer; out MeanISI: Double);

{ Action potential propagation }
function DefaultCableParams: TCableParams;
procedure SimulateCable(const HP: THHParams; const CP: TCableParams;
  out R: TCableResult);

implementation

{ Membrane model }

function DefaultHHParams: THHParams;
begin
  Result.GNa0 := 120.0;
  Result.GK0 := 36.0;
  Result.GL0 := 0.3;
  Result.VNa := -115.0;
  Result.VK := 12.0;
  Result.VL := -10.613;
  Result.Cm := 1.0;          // 0.001 mF/cm2 = 1 uF/cm2 (lecturer slide)
  Result.TempC := 6.3;       // phi = 1, rate equations as published
end;

function TemperatureFactor(const P: THHParams): Double;
begin
  // Q10 = 3 relative to the 6.3 deg C reference of Hodgkin & Huxley (1952)
  Result := Power(3.0, (P.TempC - 6.3) / 10.0);
end;

function ExpRatio(const X: Double): Double;
begin
  // X / (exp(X) - 1) with its removable singularity at X = 0 (limit = 1).
  // A second-order Taylor expansion is used close to the singularity.
  if Abs(X) < 1.0E-4 then
    Result := 1.0 - 0.5 * X + X * X / 12.0
  else
    Result := X / (Exp(X) - 1.0);
end;

function ComputeRates(const V, Phi: Double): THHRates;
begin
  // alpha_m = 0.1(v+25)/(exp(0.1v+2.5)-1) = ExpRatio(0.1v+2.5)
  Result.Am := Phi * ExpRatio(0.1 * V + 2.5);
  Result.Bm := Phi * 4.0 * Exp(V / 18.0);
  Result.Ah := Phi * 0.07 * Exp(V / 20.0);
  Result.Bh := Phi * 1.0 / (Exp(0.1 * V + 3.0) + 1.0);
  // alpha_n = 0.01(v+10)/(exp(0.1v+1)-1) = 0.1 * ExpRatio(0.1v+1)
  Result.An := Phi * 0.1 * ExpRatio(0.1 * V + 1.0);
  Result.Bn := Phi * 0.125 * Exp(V / 80.0);
end;

function SteadyState(const V, Phi: Double): THHState;
var
  Rt: THHRates;
begin
  Rt := ComputeRates(V, Phi);
  Result.V := V;
  Result.M := Rt.Am / (Rt.Am + Rt.Bm);
  Result.H := Rt.Ah / (Rt.Ah + Rt.Bh);
  Result.N := Rt.An / (Rt.An + Rt.Bn);
end;

procedure IonicCurrents(const P: THHParams; const S: THHState;
  out JNa, JK, JL: Double);
begin
  JNa := P.GNa0 * S.M * S.M * S.M * S.H * (S.V - P.VNa);
  JK := P.GK0 * S.N * S.N * S.N * S.N * (S.V - P.VK);
  JL := P.GL0 * (S.V - P.VL);
end;

function RestingConductance(const P: THHParams): Double;
var
  S: THHState;
begin
  // Total (chord) membrane conductance of the resting membrane (mS/cm2);
  // used as gm of the equivalent passive cable.
  S := SteadyState(0.0, TemperatureFactor(P));
  Result := P.GNa0 * S.M * S.M * S.M * S.H + P.GK0 * Sqr(Sqr(S.N)) + P.GL0;
end;

function Derivatives(const P: THHParams; const Phi: Double;
  const S: THHState; const Jin: Double): THHState;
var
  Rt: THHRates;
  JNa, JK, JL: Double;
begin
  Rt := ComputeRates(S.V, Phi);
  IonicCurrents(P, S, JNa, JK, JL);
  // Cm dv/dt = Jin - (JNa + JK + JL)
  Result.V := (Jin - (JNa + JK + JL)) / P.Cm;
  // dx/dt = alpha_x (1 - x) - beta_x x = -x(alpha_x + beta_x) + alpha_x
  Result.M := Rt.Am * (1.0 - S.M) - Rt.Bm * S.M;
  Result.H := Rt.Ah * (1.0 - S.H) - Rt.Bh * S.H;
  Result.N := Rt.An * (1.0 - S.N) - Rt.Bn * S.N;
end;

function AddScaled(const A, B: THHState; const C: Double): THHState; inline;
begin
  // A + C * B
  Result.V := A.V + C * B.V;
  Result.M := A.M + C * B.M;
  Result.H := A.H + C * B.H;
  Result.N := A.N + C * B.N;
end;

function StepCoupledRK4(const P: THHParams; const Phi: Double;
  const S: THHState; const J0, JHalf, J1, Dt: Double): THHState;
var
  K1, K2, K3, K4: THHState;
begin
  // Classical 4th-order Runge-Kutta on Y = [v, m, h, n]:
  //   K1 = F(t, Y),            K2 = F(t + dt/2, Y + dt/2 K1)
  //   K3 = F(t + dt/2, Y + dt/2 K2), K4 = F(t + dt, Y + dt K3)
  //   Y(t+dt) = Y + dt/6 (K1 + 2K2 + 2K3 + K4)
  K1 := Derivatives(P, Phi, S, J0);
  K2 := Derivatives(P, Phi, AddScaled(S, K1, 0.5 * Dt), JHalf);
  K3 := Derivatives(P, Phi, AddScaled(S, K2, 0.5 * Dt), JHalf);
  K4 := Derivatives(P, Phi, AddScaled(S, K3, Dt), J1);
  Result.V := S.V + Dt / 6.0 * (K1.V + 2.0 * K2.V + 2.0 * K3.V + K4.V);
  Result.M := S.M + Dt / 6.0 * (K1.M + 2.0 * K2.M + 2.0 * K3.M + K4.M);
  Result.H := S.H + Dt / 6.0 * (K1.H + 2.0 * K2.H + 2.0 * K3.H + K4.H);
  Result.N := S.N + Dt / 6.0 * (K1.N + 2.0 * K2.N + 2.0 * K3.N + K4.N);
end;

function GateRK4(const X, A, B, Dt: Double): Double;
var
  K1, K2, K3, K4: Double;
begin
  // Scalar RK4 of dx/dt = A(1-x) - Bx with A, B frozen during the step
  K1 := Dt * (A * (1.0 - X) - B * X);
  K2 := Dt * (A * (1.0 - (X + 0.5 * K1)) - B * (X + 0.5 * K1));
  K3 := Dt * (A * (1.0 - (X + 0.5 * K2)) - B * (X + 0.5 * K2));
  K4 := Dt * (A * (1.0 - (X + K3)) - B * (X + K3));
  Result := X + (K1 + 2.0 * K2 + 2.0 * K3 + K4) / 6.0;
end;

function StepLecturerRK4(const P: THHParams; const Phi: Double;
  const S: THHState; const Jin, Dt: Double): THHState;
var
  Rt: THHRates;
  Tmp: THHState;
  K1, K2, K3, K4: Double;

  function DV(const V: Double): Double;
  var
    JNa, JK, JL: Double;
  begin
    Tmp.V := V;
    IonicCurrents(P, Tmp, JNa, JK, JL);
    Result := (Jin - (JNa + JK + JL)) / P.Cm;
  end;

begin
  // Reproduces the week-9 source code: alpha/beta are evaluated once at
  // v(t); n, m, h are advanced by independent scalar RK4 steps; then v is
  // advanced by a scalar RK4 step with the NEW gate values held constant.
  Rt := ComputeRates(S.V, Phi);
  Result.N := GateRK4(S.N, Rt.An, Rt.Bn, Dt);
  Result.M := GateRK4(S.M, Rt.Am, Rt.Bm, Dt);
  Result.H := GateRK4(S.H, Rt.Ah, Rt.Bh, Dt);
  Tmp := Result;
  K1 := Dt * DV(S.V);
  K2 := Dt * DV(S.V + 0.5 * K1);
  K3 := Dt * DV(S.V + 0.5 * K2);
  K4 := Dt * DV(S.V + K3);
  Result.V := S.V + (K1 + 2.0 * K2 + 2.0 * K3 + K4) / 6.0;
end;

function AbsoluteVm(const V: Double): Double;
begin
  // Alignment of the HH displacement v to the absolute membrane voltage
  // Vm = -(v + 70) = V_REST_ABS - v
  Result := V_REST_ABS - V;
end;

{ Spike detector }

procedure AppendValue(var A: TDoubleArray; const Value: Double);
var
  L: Integer;
begin
  L := Length(A);
  SetLength(A, L + 1);
  A[L] := Value;
end;

procedure TSpikeDetector.Reset;
begin
  Above := False;
  PeakV := -1.0E30;
  PeakT := 0.0;
  CrossT := 0.0;
  Count := 0;
  SetLength(CrossTimes, 0);
  SetLength(PeakTimes, 0);
  SetLength(PeakValues, 0);
end;

procedure TSpikeDetector.Feed(const T, Vm: Double);
begin
  if not Above then
  begin
    if Vm >= SPIKE_LEVEL then
    begin
      Above := True;
      CrossT := T;
      PeakV := Vm;
      PeakT := T;
    end;
  end
  else
  begin
    if Vm > PeakV then
    begin
      PeakV := Vm;
      PeakT := T;
    end;
    if Vm < SPIKE_LEVEL then
    begin
      Above := False;
      AppendValue(CrossTimes, CrossT);
      AppendValue(PeakTimes, PeakT);
      AppendValue(PeakValues, PeakV);
      Inc(Count);
    end;
  end;
end;

procedure TSpikeDetector.Finish;
begin
  // A spike still above the detection level when the run ends is counted
  if Above then
  begin
    AppendValue(CrossTimes, CrossT);
    AppendValue(PeakTimes, PeakT);
    AppendValue(PeakValues, PeakV);
    Inc(Count);
    Above := False;
  end;
end;

{ Stimulus }

function DefaultStimulus: TStimulus;
begin
  Result.Kind := skStep;
  Result.JBase := 0.0;
  Result.JLevel := -10.0;
  Result.TOn := 1.0;
  Result.TOff := 61.0;
  Result.PulseWidth := 0.5;
  Result.Interval := 15.0;
  Result.JLevel2 := -40.0;
end;

function StimulusAt(const Stim: TStimulus; const T: Double): Double;
begin
  case Stim.Kind of
    skStep:
      if (T >= Stim.TOn) and (T < Stim.TOff) then
        Result := Stim.JLevel
      else
        Result := Stim.JBase;
    skLecturerStaircase:
      // identical to the lecturer's week-9 source code
      if (T >= 0.0) and (T < 25.0) then
        Result := -5.0
      else if (T >= 25.0) and (T < 38.0) then
        Result := -10.0
      else if (T >= 38.0) and (T < 50.0) then
        Result := -20.0
      else
        Result := 0.0;
    skPairedPulse:
      if (T >= Stim.TOn) and (T < Stim.TOn + Stim.PulseWidth) then
        Result := Stim.JLevel
      else if (T >= Stim.TOn + Stim.Interval) and
              (T < Stim.TOn + Stim.Interval + Stim.PulseWidth) then
        Result := Stim.JLevel2
      else
        Result := Stim.JBase;
  else
    Result := 0.0;
  end;
end;

{ Action potential generation (space-clamped membrane) }

function AdvanceState(const P: THHParams; const Phi: Double;
  const Stim: TStimulus; const S: THHState; const T, Dt: Double;
  const Method: TIntegrator): THHState;
begin
  if Method = imCoupledRK4 then
    Result := StepCoupledRK4(P, Phi, S, StimulusAt(Stim, T),
      StimulusAt(Stim, T + 0.5 * Dt), StimulusAt(Stim, T + Dt), Dt)
  else
    Result := StepLecturerRK4(P, Phi, S, StimulusAt(Stim, T), Dt);
end;

procedure CheckStepArguments(const Dt, TEnd: Double);
begin
  if (Dt <= 0.0) or IsNan(Dt) then
    raise EArgumentException.Create('Integration step dt must be positive.');
  if (TEnd <= 0.0) or IsNan(TEnd) then
    raise EArgumentException.Create('Simulation time must be positive.');
  if TEnd / Dt > 5.0E6 then
    raise EArgumentException.Create(
      'Too many integration steps (TEnd/dt > 5e6). Increase dt or reduce TEnd.');
end;

procedure SimulateAPG(const P: THHParams; const Stim: TStimulus;
  const Dt, TEnd: Double; const Method: TIntegrator; out R: TAPGResult);
var
  Phi, T: Double;
  S: THHState;
  I, NSteps: Integer;
  JNa, JK, JL: Double;
  Det: TSpikeDetector;

  procedure Store(const Idx: Integer; const Time, Jin: Double);
  begin
    IonicCurrents(P, S, JNa, JK, JL);
    R.T[Idx] := Time;
    R.V[Idx] := S.V;
    R.Vm[Idx] := AbsoluteVm(S.V);
    R.Jin[Idx] := Jin;
    R.JNa[Idx] := JNa;
    R.JK[Idx] := JK;
    R.JL[Idx] := JL;
    R.M[Idx] := S.M;
    R.H[Idx] := S.H;
    R.N[Idx] := S.N;
    R.GNa[Idx] := P.GNa0 * S.M * S.M * S.M * S.H;
    R.GK[Idx] := P.GK0 * Sqr(Sqr(S.N));
  end;

begin
  CheckStepArguments(Dt, TEnd);
  Phi := TemperatureFactor(P);
  NSteps := Round(TEnd / Dt);
  R.Count := NSteps + 1;
  SetLength(R.T, R.Count);
  SetLength(R.Vm, R.Count);
  SetLength(R.V, R.Count);
  SetLength(R.Jin, R.Count);
  SetLength(R.JNa, R.Count);
  SetLength(R.JK, R.Count);
  SetLength(R.JL, R.Count);
  SetLength(R.M, R.Count);
  SetLength(R.H, R.Count);
  SetLength(R.N, R.Count);
  SetLength(R.GNa, R.Count);
  SetLength(R.GK, R.Count);

  // Initial condition: membrane at rest, gates at their steady state
  S := SteadyState(0.0, Phi);
  Det.Reset;
  Store(0, 0.0, StimulusAt(Stim, 0.0));
  Det.Feed(0.0, R.Vm[0]);
  for I := 1 to NSteps do
  begin
    T := (I - 1) * Dt;
    S := AdvanceState(P, Phi, Stim, S, T, Dt, Method);
    Store(I, I * Dt, StimulusAt(Stim, I * Dt));
    Det.Feed(I * Dt, R.Vm[I]);
  end;
  Det.Finish;
  R.SpikeCross := Copy(Det.CrossTimes);
  R.SpikeTimes := Copy(Det.PeakTimes);
  R.SpikePeaks := Copy(Det.PeakValues);
end;

procedure SimulateSpikesOnly(const P: THHParams; const Stim: TStimulus;
  const Dt, TEnd: Double; const Method: TIntegrator;
  var Det: TSpikeDetector);
var
  Phi: Double;
  S: THHState;
  I, NSteps: Integer;
begin
  CheckStepArguments(Dt, TEnd);
  Phi := TemperatureFactor(P);
  NSteps := Round(TEnd / Dt);
  S := SteadyState(0.0, Phi);
  Det.Reset;
  Det.Feed(0.0, AbsoluteVm(S.V));
  for I := 1 to NSteps do
  begin
    S := AdvanceState(P, Phi, Stim, S, (I - 1) * Dt, Dt, Method);
    Det.Feed(I * Dt, AbsoluteVm(S.V));
  end;
  Det.Finish;
end;

{ Refractory period (paired-pulse protocol) }

const
  PAIRED_T_ON = 1.0;        // onset of the conditioning pulse (ms)
  PAIRED_T_AFTER = 20.0;    // observation time after the test pulse (ms)
  BISECTION_STEPS = 16;

function PairedStimulus(const J1, J2, Width, Interval: Double): TStimulus;
begin
  Result := DefaultStimulus;
  Result.Kind := skPairedPulse;
  Result.JBase := 0.0;
  Result.JLevel := J1;
  Result.JLevel2 := J2;
  Result.TOn := PAIRED_T_ON;
  Result.PulseWidth := Width;
  Result.Interval := Interval;
end;

function SecondSpikeOccurs(const P: THHParams; const J1, J2, Width,
  Interval, Dt: Double; const Method: TIntegrator;
  out SecondPeak: Double): Boolean;
var
  Det: TSpikeDetector;
  TTest: Double;
  I: Integer;
begin
  // The test response is a spike whose upward 0 mV crossing occurs after
  // the onset of the second (test) pulse.
  TTest := PAIRED_T_ON + Interval;
  SimulateSpikesOnly(P, PairedStimulus(J1, J2, Width, Interval), Dt,
    TTest + PAIRED_T_AFTER, Method, Det);
  Result := False;
  SecondPeak := NaN;
  I := 0;
  while (not Result) and (I < Det.Count) do
  begin
    if Det.CrossTimes[I] >= TTest then
    begin
      Result := True;
      SecondPeak := Det.PeakValues[I];
    end;
    Inc(I);
  end;
end;

function SinglePulseThreshold(const P: THHParams; const Sign, Width,
  JMaxAbs, Dt: Double; const Method: TIntegrator): Double;
var
  Lo, Hi, Mid: Double;
  K: Integer;
  Det: TSpikeDetector;
  Stim: TStimulus;

  function Fires(const A: Double): Boolean;
  begin
    Stim := PairedStimulus(Sign * A, 0.0, Width, 1.0E6);
    SimulateSpikesOnly(P, Stim, Dt, PAIRED_T_ON + PAIRED_T_AFTER, Method, Det);
    Result := Det.Count > 0;
  end;

begin
  // Smallest |J| of a single pulse that elicits an action potential
  if not Fires(JMaxAbs) then
    Exit(NaN);
  Lo := 0.0;
  Hi := JMaxAbs;
  for K := 1 to BISECTION_STEPS do
  begin
    Mid := 0.5 * (Lo + Hi);
    if Fires(Mid) then
      Hi := Mid
    else
      Lo := Mid;
  end;
  Result := Hi;
end;

function SecondPulseThreshold(const P: THHParams; const J1, Width,
  Interval, JMaxAbs, Dt: Double; const Method: TIntegrator): Double;
var
  Lo, Hi, Mid, Pk, Sign: Double;
  K: Integer;
begin
  // Minimum |J2| of the test pulse that produces a second action potential.
  // NaN means no response up to JMaxAbs: absolute refractory period.
  if J1 < 0.0 then
    Sign := -1.0
  else
    Sign := 1.0;
  if not SecondSpikeOccurs(P, J1, Sign * JMaxAbs, Width, Interval, Dt,
    Method, Pk) then
    Exit(NaN);
  Lo := 0.0;
  Hi := JMaxAbs;
  for K := 1 to BISECTION_STEPS do
  begin
    Mid := 0.5 * (Lo + Hi);
    if SecondSpikeOccurs(P, J1, Sign * Mid, Width, Interval, Dt, Method, Pk) then
      Hi := Mid
    else
      Lo := Mid;
  end;
  Result := Hi;
end;

{ Input level versus inter-pulse interval }

procedure SteadyFiring(const P: THHParams; const J, Dt, TEnd,
  TDiscard: Double; const Method: TIntegrator;
  out NSpikes: Integer; out MeanISI: Double);
var
  Stim: TStimulus;
  Det: TSpikeDetector;
  I, NUsed: Integer;
  SumISI: Double;
begin
  // Constant current J switched on at t = 0. The mean inter-spike interval is
  // computed from spikes occurring after TDiscard (transient removed).
  Stim := DefaultStimulus;
  Stim.Kind := skStep;
  Stim.JBase := 0.0;
  Stim.JLevel := J;
  Stim.TOn := 0.0;
  Stim.TOff := TEnd + 1.0;
  SimulateSpikesOnly(P, Stim, Dt, TEnd, Method, Det);
  NSpikes := Det.Count;
  SumISI := 0.0;
  NUsed := 0;
  for I := 1 to Det.Count - 1 do
    if Det.PeakTimes[I - 1] >= TDiscard then
    begin
      SumISI := SumISI + (Det.PeakTimes[I] - Det.PeakTimes[I - 1]);
      Inc(NUsed);
    end;
  if NUsed > 0 then
    MeanISI := SumISI / NUsed
  else
    MeanISI := NaN;
end;

{
  Action potential propagation: cable equation, explicit finite differences

    dv/dt = 1/((ro+ri) cm) * d2v/dx2 + (Jin - Jion)/Cm

  central difference in x : d2v/dx2 ~ (v[j+1] - 2v[j] + v[j-1]) / h^2
  forward difference in t : dv/dt   ~ (v[j](t+k) - v[j](t)) / k
  => v[j](t+k) = v[j](t) + k/((ro+ri) cm h^2) (v[j+1]-2v[j]+v[j-1])
                         + k (Jin - Jion)/Cm
  Active mode : Jion = JNa + JK + JL (HH membrane at every node)
  Passive mode: Jion = gm v          (lecturer's RC transmission line)
  Sealed ends : zero axial current, ghost nodes v[-1] = v[1], v[N] = v[N-2]
}

function DefaultCableParams: TCableParams;
begin
  Result.RadiusUm := 238.0;      // squid giant axon (Hodgkin & Huxley, 1952)
  Result.RiOhmCm := 35.4;        // axoplasm resistivity (ohm.cm)
  Result.RoOhmPerCm := 0.0;      // large external bath, ro << ri
  Result.LengthCm := 6.0;
  Result.DxCm := 0.1;
  Result.Dt := 0.01;
  Result.TEnd := 12.0;
  Result.StimAmp := -150.0;
  Result.StimDur := 0.5;
  Result.StimLengthCm := 0.2;
  Result.Mode := cmActiveHH;
  Result.GmPassive := 0.677;
  Result.SaveEvery := 2;
  Result.Scheme := csExplicitFTCS;
  Result.Drive := cdCurrentPulses;
  Result.PulseCount := 1;
  Result.PulseInterval := 15.0;
  SetLength(Result.DriveV, 0);
end;

procedure SimulateCable(const HP: THHParams; const CP: TCableParams;
  out R: TCableResult);
var
  A, Phi, T, Lap, Jin, JNa, JK, JL, Jion, VmNow, InvH2, Src: Double;
  V, VNew, Mg, Hg, Ng, VmPrev: TDoubleArray;
  TriA, TriB, TriC, TriD, TriCp, TriDp: TDoubleArray;
  Stimulated: array of Boolean;
  J, K, NSteps, NFrames, Frame, I1, I2: Integer;
  S: THHState;
  Rt: THHRates;

  function PulseOn(const Time: Double): Boolean;
  var
    P: Integer;
  begin
    // pulse p occupies [p * PulseInterval, p * PulseInterval + StimDur)
    Result := False;
    P := 0;
    while (not Result) and (P < CP.PulseCount) do
    begin
      Result := (Time >= P * CP.PulseInterval) and
        (Time < P * CP.PulseInterval + CP.StimDur);
      Inc(P);
    end;
  end;

  procedure SolveTridiagonal(const N: Integer);
  var
    Ii: Integer;
    Den: Double;
  begin
    // Thomas algorithm for TriA[i] x[i-1] + TriB[i] x[i] + TriC[i] x[i+1]
    // = TriD[i]; the matrix is diagonally dominant (1 + r > r), so no
    // pivoting is needed. The solution is written into VNew.
    TriCp[0] := TriC[0] / TriB[0];
    TriDp[0] := TriD[0] / TriB[0];
    for Ii := 1 to N - 1 do
    begin
      Den := TriB[Ii] - TriA[Ii] * TriCp[Ii - 1];
      if Ii < N - 1 then
        TriCp[Ii] := TriC[Ii] / Den
      else
        TriCp[Ii] := 0.0;
      TriDp[Ii] := (TriD[Ii] - TriA[Ii] * TriDp[Ii - 1]) / Den;
    end;
    VNew[N - 1] := TriDp[N - 1];
    for Ii := N - 2 downto 0 do
      VNew[Ii] := TriDp[Ii] - TriCp[Ii] * VNew[Ii + 1];
  end;

  procedure SaveFrame(const Idx: Integer; const Time: Double);
  var
    Jj: Integer;
  begin
    R.T[Idx] := Time;
    SetLength(R.Vm[Idx], R.NNodes);
    for Jj := 0 to R.NNodes - 1 do
      R.Vm[Idx][Jj] := AbsoluteVm(V[Jj]);
  end;

begin
  if (CP.DxCm <= 0.0) or (CP.LengthCm <= CP.DxCm) then
    raise EArgumentException.Create('Require 0 < dx < axon length.');
  if CP.RadiusUm <= 0.0 then
    raise EArgumentException.Create('Axon radius must be positive.');
  if CP.RiOhmCm + CP.RoOhmPerCm <= 0.0 then
    raise EArgumentException.Create('ri + ro must be positive.');
  CheckStepArguments(CP.Dt, CP.TEnd);
  if (CP.Drive = cdCurrentPulses) and (CP.PulseCount < 1) then
    raise EArgumentException.Create('The number of stimulus pulses must be at least 1.');
  if (CP.Drive = cdCurrentPulses) and (CP.PulseCount > 1) and
     (CP.PulseInterval <= CP.StimDur) then
    raise EArgumentException.Create(
      'The pulse interval must be longer than the pulse duration.');
  if (CP.Drive = cdVoltageTrace) and
     (Length(CP.DriveV) < Round(CP.TEnd / CP.Dt) + 1) then
    raise EArgumentException.Create(
      'The voltage trace at x = 0 is shorter than the simulated time.');

  // cable constants
  A := CP.RadiusUm * 1.0E-4;                        // cm
  R.RiPerLen := CP.RiOhmCm / (Pi * A * A);          // ohm/cm
  R.CmPerLen := HP.Cm * 2.0 * Pi * A;               // uF/cm
  // ohm.uF = us, so 1/((ri+ro) cm) is in cm2/us; x1000 gives cm2/ms
  R.D := 1000.0 / ((R.RiPerLen + CP.RoOhmPerCm) * R.CmPerLen);
  R.R := R.D * CP.Dt / Sqr(CP.DxCm);
  if CP.GmPassive > 0.0 then
    // lambda^2 = rm/(ri+ro), rm = 1/(gm 2 pi a), gm in S/cm2
    R.LambdaCm := Sqrt(1.0 / (CP.GmPassive * 1.0E-3 * 2.0 * Pi * A *
      (R.RiPerLen + CP.RoOhmPerCm)))
  else
    R.LambdaCm := NaN;
  R.VelocityMs := NaN;
  R.NNodes := Round(CP.LengthCm / CP.DxCm) + 1;
  // the explicit scheme needs r <= 1/2 (von Neumann); Crank-Nicolson is
  // unconditionally stable for the diffusion term
  R.Stable := (CP.Scheme = csCrankNicolson) or (R.R <= 0.5);
  R.NSaved := 0;
  SetLength(R.X, R.NNodes);
  for J := 0 to R.NNodes - 1 do
    R.X[J] := J * CP.DxCm;
  if not R.Stable then
    Exit;  // caller reports the violated condition k <= h^2/(2D)

  // initial state: every node at rest
  Phi := TemperatureFactor(HP);
  S := SteadyState(0.0, Phi);
  SetLength(V, R.NNodes);
  SetLength(VNew, R.NNodes);
  SetLength(Mg, R.NNodes);
  SetLength(Hg, R.NNodes);
  SetLength(Ng, R.NNodes);
  SetLength(VmPrev, R.NNodes);
  SetLength(Stimulated, R.NNodes);
  SetLength(R.PeakVm, R.NNodes);
  SetLength(TriA, R.NNodes);
  SetLength(TriB, R.NNodes);
  SetLength(TriC, R.NNodes);
  SetLength(TriD, R.NNodes);
  SetLength(TriCp, R.NNodes);
  SetLength(TriDp, R.NNodes);
  SetLength(R.TCross, R.NNodes);
  for J := 0 to R.NNodes - 1 do
  begin
    V[J] := 0.0;
    Mg[J] := S.M;
    Hg[J] := S.H;
    Ng[J] := S.N;
    VmPrev[J] := AbsoluteVm(0.0);
    R.PeakVm[J] := VmPrev[J];
    R.TCross[J] := NaN;
    Stimulated[J] := R.X[J] <= CP.StimLengthCm + 1.0E-9;
  end;
  if CP.Drive = cdVoltageTrace then
  begin
    V[0] := CP.DriveV[0];
    VmPrev[0] := AbsoluteVm(V[0]);
    R.PeakVm[0] := VmPrev[0];
  end;

  // Crank-Nicolson matrix (constant): (1 + r) on the diagonal, -r/2 beside
  // it; the sealed ends use the ghost nodes v[-1] = v[1], v[N] = v[N-2],
  // which doubles the off-diagonal coefficient of the first and last row
  for J := 0 to R.NNodes - 1 do
  begin
    TriA[J] := -0.5 * R.R;
    TriB[J] := 1.0 + R.R;
    TriC[J] := -0.5 * R.R;
  end;
  TriA[0] := 0.0;
  TriC[0] := -R.R;
  TriA[R.NNodes - 1] := -R.R;
  TriC[R.NNodes - 1] := 0.0;
  if CP.Drive = cdVoltageTrace then
  begin
    // node 0 follows the imposed trace (Dirichlet row)
    TriB[0] := 1.0;
    TriC[0] := 0.0;
  end;

  NSteps := Round(CP.TEnd / CP.Dt);
  if CP.SaveEvery < 1 then
    NFrames := NSteps + 1
  else
    NFrames := NSteps div CP.SaveEvery + 1;
  SetLength(R.T, NFrames);
  SetLength(R.Vm, NFrames);
  SaveFrame(0, 0.0);
  Frame := 1;
  InvH2 := 1.0 / Sqr(CP.DxCm);

  // time marching (forward difference in time)
  for K := 0 to NSteps - 1 do
  begin
    T := K * CP.Dt;
    for J := 0 to R.NNodes - 1 do
    begin
      // central difference with sealed-end ghost nodes
      if J = 0 then
        Lap := (2.0 * V[1] - 2.0 * V[0]) * InvH2
      else if J = R.NNodes - 1 then
        Lap := (2.0 * V[J - 1] - 2.0 * V[J]) * InvH2
      else
        Lap := (V[J + 1] - 2.0 * V[J] + V[J - 1]) * InvH2;

      if (CP.Drive = cdCurrentPulses) and Stimulated[J] and PulseOn(T) then
        Jin := CP.StimAmp
      else
        Jin := 0.0;

      if CP.Mode = cmActiveHH then
      begin
        S.V := V[J];
        S.M := Mg[J];
        S.H := Hg[J];
        S.N := Ng[J];
        IonicCurrents(HP, S, JNa, JK, JL);
        Jion := JNa + JK + JL;
        Rt := ComputeRates(V[J], Phi);
        Mg[J] := Mg[J] + CP.Dt * (Rt.Am * (1.0 - Mg[J]) - Rt.Bm * Mg[J]);
        Hg[J] := Hg[J] + CP.Dt * (Rt.Ah * (1.0 - Hg[J]) - Rt.Bh * Hg[J]);
        Ng[J] := Ng[J] + CP.Dt * (Rt.An * (1.0 - Ng[J]) - Rt.Bn * Ng[J]);
      end
      else
        Jion := CP.GmPassive * V[J];

      // membrane and stimulus terms are always explicit (level n)
      Src := (Jin - Jion) / HP.Cm;
      if CP.Scheme = csCrankNicolson then
        // right-hand side of the trapezoidal rule for the diffusion term
        TriD[J] := V[J] + CP.Dt * (0.5 * R.D * Lap + Src)
      else
        VNew[J] := V[J] + CP.Dt * (R.D * Lap + Src);
    end;

    if CP.Scheme = csCrankNicolson then
    begin
      if CP.Drive = cdVoltageTrace then
        TriD[0] := CP.DriveV[K + 1];
      SolveTridiagonal(R.NNodes);
    end
    else if CP.Drive = cdVoltageTrace then
      VNew[0] := CP.DriveV[K + 1];

    for J := 0 to R.NNodes - 1 do
    begin
      V[J] := VNew[J];
      VmNow := AbsoluteVm(V[J]);
      if VmNow > R.PeakVm[J] then
        R.PeakVm[J] := VmNow;
      if IsNan(R.TCross[J]) and (VmPrev[J] < SPIKE_LEVEL) and
         (VmNow >= SPIKE_LEVEL) then
        // linear interpolation of the crossing instant
        R.TCross[J] := T + CP.Dt * (SPIKE_LEVEL - VmPrev[J]) /
          (VmNow - VmPrev[J]);
      VmPrev[J] := VmNow;
    end;

    if (CP.SaveEvery >= 1) and (((K + 1) mod CP.SaveEvery) = 0) and
       (Frame < NFrames) then
    begin
      SaveFrame(Frame, (K + 1) * CP.Dt);
      Inc(Frame);
    end
    else if (CP.SaveEvery < 1) and (Frame < NFrames) then
    begin
      SaveFrame(Frame, (K + 1) * CP.Dt);
      Inc(Frame);
    end;
  end;
  R.NSaved := Frame;

  // conduction velocity between 25 % and 75 % of the axon length
  I1 := Round(0.25 * (R.NNodes - 1));
  I2 := Round(0.75 * (R.NNodes - 1));
  if (I2 > I1) and (not IsNan(R.TCross[I1])) and (not IsNan(R.TCross[I2])) and
     (R.TCross[I2] > R.TCross[I1]) then
    // 1 cm/ms = 10 m/s
    R.VelocityMs := 10.0 * (R.X[I2] - R.X[I1]) / (R.TCross[I2] - R.TCross[I1]);
end;

end.
