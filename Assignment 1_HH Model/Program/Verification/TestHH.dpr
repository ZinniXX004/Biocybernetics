program TestHH;
{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}
{$APPTYPE CONSOLE}
uses SysUtils, Math, HHModel;
var
  P: THHParams; St: TStimulus; R: TAPGResult; I, NS: Integer; ISI, Th, Th0: Double;
  CP: TCableParams; CR: TCableResult; Js: array[0..7] of Double = (-2,-3,-5,-7,-10,-20,-40,-100);
  Iv: array[0..8] of Double = (2,4,6,8,10,12,15,20,30); Pk: Double; M: TIntegrator; M2: TCableScheme;
begin
  FormatSettings.DecimalSeparator := '.';
  P := DefaultHHParams;
  Writeln('gm_rest=', RestingConductance(P):0:4);
  Writeln('ExpRatio(0)=', ExpRatio(0):0:6, ' ExpRatio(1e-5)=', ExpRatio(1e-5):0:8, ' alpha_m(-25)=', ComputeRates(-25,1).Am:0:6, ' alpha_n(-10)=', ComputeRates(-10,1).An:0:6);
  for M := imCoupledRK4 to imLecturerRK4 do
  begin
    Writeln('--- method ', Ord(M));
    for I := 0 to 7 do
    begin
      St := DefaultStimulus; St.Kind := skStep; St.JLevel := Js[I]; St.TOn := 1; St.TOff := 1000;
      SimulateAPG(P, St, 0.01, 100, M, R);
      Write('J=', Js[I]:0:0, ' spikes=', Length(R.SpikeTimes));
      if Length(R.SpikeTimes) > 1 then Write(' lastISI=', R.SpikeTimes[High(R.SpikeTimes)]-R.SpikeTimes[High(R.SpikeTimes)-1]:0:3);
      if Length(R.SpikePeaks) > 0 then Write(' peak1=', R.SpikePeaks[0]:0:2, ' t1=', R.SpikeTimes[0]:0:2);
      Writeln;
    end;
    St.Kind := skLecturerStaircase; SimulateAPG(P, St, 0.01, 61, M, R);
    Write('staircase spikes:'); for I := 0 to High(R.SpikeTimes) do Write(' ', R.SpikeTimes[I]:0:2); Writeln;
  end;
  Th0 := SinglePulseThreshold(P, -1, 0.5, 500, 0.01, imCoupledRK4);
  Writeln('single pulse threshold (0.5ms) = ', Th0:0:3);
  for I := 0 to 8 do
  begin
    Th := SecondPulseThreshold(P, -40, 0.5, Iv[I], 500, 0.01, imCoupledRK4);
    SecondSpikeOccurs(P, -40, -40, 0.5, Iv[I], 0.01, imCoupledRK4, Pk);
    Writeln('interval ', Iv[I]:0:1, ' thr2=', Th:0:3, ' peak2(J2=-40)=', Pk:0:2);
  end;
  for I := 0 to 7 do begin SteadyFiring(P, Js[I], 0.01, 200, 50, imCoupledRK4, NS, ISI); Writeln('steady J=',Js[I]:0:0,' n=',NS,' ISI=',ISI:0:3); end;
  CP := DefaultCableParams; SimulateCable(P, CP, CR);
  Writeln('cable active: D=',CR.D:0:4,' r=',CR.R:0:4,' N=',CR.NNodes,' frames=',CR.NSaved,' vel=',CR.VelocityMs:0:3,' lambda=',CR.LambdaCm:0:4, ' peak0=',CR.PeakVm[0]:0:1,' peakMid=',CR.PeakVm[CR.NNodes div 2]:0:1, ' tc15=',CR.TCross[15]:0:3,' tc45=',CR.TCross[45]:0:3);
  CP.Mode := cmPassive; SimulateCable(P, CP, CR);
  Writeln('cable passive: vel=',CR.VelocityMs:0:3,' peak0=',CR.PeakVm[0]:0:2,' p5=',CR.PeakVm[5]:0:2,' p10=',CR.PeakVm[10]:0:2,' p15=',CR.PeakVm[15]:0:2);
  CP := DefaultCableParams; CP.DxCm := 0.05; SimulateCable(P, CP, CR); Writeln('dx=0.05 stable=', CR.Stable, ' r=', CR.R:0:3);
  CP.Dt := 0.0025; SimulateCable(P, CP, CR); Writeln('dx=0.05 dt=0.0025 vel=', CR.VelocityMs:0:3);
  CP := DefaultCableParams; P.TempC := 18.5; CP.Dt := 0.005; SimulateCable(P, CP, CR); Writeln('T=18.5 vel=', CR.VelocityMs:0:3);
  { session 8: Crank-Nicolson, current-pulse train, APG waveform at x = 0 }
  P := DefaultHHParams;
  CP := DefaultCableParams; CP.Scheme := csCrankNicolson; SimulateCable(P, CP, CR);
  Writeln('CN squid: stable=', CR.Stable, ' vel=', CR.VelocityMs:0:3, ' peakMid=', CR.PeakVm[CR.NNodes div 2]:0:2);
  CP.DxCm := 0.05; SimulateCable(P, CP, CR);
  Writeln('CN squid dx=0.05 dt=0.01: r=', CR.R:0:3, ' stable=', CR.Stable, ' vel=', CR.VelocityMs:0:3);
  CP := DefaultCableParams; CP.PulseCount := 3; CP.PulseInterval := 15; CP.TEnd := 45; SimulateCable(P, CP, CR);
  Writeln('pulse train x3: frames=', CR.NSaved, ' vel=', CR.VelocityMs:0:3, ' last frame Vm(mid)=', CR.Vm[CR.NSaved - 1][CR.NNodes div 2]:0:2);
  St := DefaultStimulus; St.Kind := skStep; St.JLevel := -10; St.TOn := 1; St.TOff := 61;
  SimulateAPG(P, St, 0.01, 60, imCoupledRK4, R);
  CP := DefaultCableParams; CP.RadiusUm := 5; CP.LengthCm := 0.2; CP.DxCm := 0.04; CP.Dt := 0.01; CP.TEnd := 60;
  CP.Mode := cmPassive; CP.Drive := cdVoltageTrace; CP.DriveV := Copy(R.V);
  for M2 := csExplicitFTCS to csCrankNicolson do
  begin
    CP.Scheme := M2; SimulateCable(P, CP, CR);
    Write('lecturer passive APG drive scheme ', Ord(M2), ': r=', CR.R:0:4, ' lambda(mm)=', 10 * CR.LambdaCm:0:3, ' peaks');
    for I := 0 to CR.NNodes - 1 do Write(' ', CR.PeakVm[I]:0:1);
    Writeln;
  end;
  CP.Mode := cmActiveHH; CP.Scheme := csCrankNicolson; CP.DxCm := 0.01; SimulateCable(P, CP, CR);
  Writeln('lecturer active APG drive CN dx=0.1mm (r>0.5): vel=', CR.VelocityMs:0:3, ' peakEnd=', CR.PeakVm[CR.NNodes - 1]:0:2);
end.
