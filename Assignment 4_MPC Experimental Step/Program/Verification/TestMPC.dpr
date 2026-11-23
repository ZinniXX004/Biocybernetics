program TestMPC;

{
  Console test of MPCModel.pas (Biocybernetics Assignment 4).
  Compiled with Free Pascal in CI; the output is compared with the golden
  file TestMPC_output.txt, and the exit code is the number of failed
  acceptance checks. With "--csv <folder>" the responses used for the
  report figures are also written as CSV files, and the process data of
  Problem 2 as a .dat file.

  Cases
    C1  Problem 1 system 1, lecture formula: Ad and Bd against the sheet
    C2  system 1, standard bilinear Bd and the factor 1 / (1 - T/2)
    C3  system 1 eigenvalues of Ad against (1 + sT/2) / (1 - sT/2)
    C4  system 2 (s = +/-2j): |z| = 1, step and impulse responses
    C5  SVD of the lecturer's train1.dat against svdku1.dat
    C6  Problem 2: step data, Hankel 4 x 4, Ho-Kalman model against the
        plant of Problem 3 and the lecturer's svdku123456.dat
    C7  Problem 2 with zero-order-hold data and a larger Hankel matrix
    C8  Problem 3: observer gain, error poles, observability, simulation
    C9  observer example of the lecture slides and an earlier student
        formula (values only, no acceptance check)
}

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}
{$APPTYPE CONSOLE}

uses
  SysUtils, Math, MPCModel;

var
  GFailures: Integer = 0;
  GCsvDir: string = '';

procedure Check(const AName: string; ACondition: Boolean; AValue: Double);
begin
  if ACondition then
    Writeln('[PASS] ', AName, ' = ', FmtG(AValue, 8))
  else
  begin
    Writeln('[FAIL] ', AName, ' = ', FmtG(AValue, 8));
    Inc(GFailures);
  end;
end;

procedure Show(const ATitle: string; const AM: TMatrix; ADigits: Integer = 15);
begin
  Writeln(ATitle);
  Writeln(MatToText(AM, ADigits, 24));
end;

function EigText(const AZ: TComplexArray; ADigits: Integer = 10): string;
var
  LI: Integer;
begin
  Result := '';
  for LI := 0 to High(AZ) do
  begin
    if LI > 0 then
      Result := Result + ', ';
    Result := Result + ComplexToText(AZ[LI], ADigits);
  end;
end;

procedure WriteCsv(const AName, AHeader: string; const ACols: array of TVector);
var
  LF: TextFile;
  LI, LJ, LN: Integer;
  LLine: string;
begin
  if GCsvDir = '' then
    Exit;
  LN := MaxInt;
  for LJ := 0 to High(ACols) do
    LN := Min(LN, Length(ACols[LJ]));
  AssignFile(LF, IncludeTrailingPathDelimiter(GCsvDir) + AName + '.csv');
  Rewrite(LF);
  Writeln(LF, AHeader);
  for LI := 0 to LN - 1 do
  begin
    LLine := '';
    for LJ := 0 to High(ACols) do
    begin
      if LJ > 0 then
        LLine := LLine + ',';
      LLine := LLine + FmtG(ACols[LJ][LI], 15);
    end;
    Writeln(LF, LLine);
  end;
  CloseFile(LF);
end;

procedure WriteText(const AName, AText: string);
var
  LF: TextFile;
begin
  if GCsvDir = '' then
    Exit;
  AssignFile(LF, IncludeTrailingPathDelimiter(GCsvDir) + AName);
  Rewrite(LF);
  Write(LF, AText);
  CloseFile(LF);
end;

function Column(const AM: TMatrix; ACol: Integer): TVector;
var
  LI: Integer;
begin
  Result := nil;
  SetLength(Result, MatRows(AM));
  for LI := 0 to MatRows(AM) - 1 do
    Result[LI] := AM[LI][ACol];
end;

procedure CaseC1;
var
  LD: TStateModel;
  LAd, LBd: TMatrix;
  LI, LJ, LSame, LTotal: Integer;
  LSheetAd: array[0..8] of string;
  LSheetBd: array[0..2] of string;
begin
  LSheetAd[0] := '1.0000015000015';
  LSheetAd[1] := '0.001000001000001';
  LSheetAd[2] := '5.000005000005E-7';
  LSheetAd[3] := '0.003000003000003';
  LSheetAd[4] := '1.000002000002';
  LSheetAd[5] := '0.001000001000001';
  LSheetAd[6] := '1.5000015000015E-6';
  LSheetAd[7] := '0.001000001000001';
  LSheetAd[8] := '1.0000005000005';
  LSheetBd[0] := '0.00100100200150225';
  LSheetBd[1] := '0.00100350275437819';
  LSheetBd[2] := '0.00300200250175238';
  SheetReferenceP1(LAd, LBd);
  LD := Discretise(ModelP1System1, 1.0e-3, dmLecture);
  Writeln('C1 Problem 1 system 1, lecture bilinear, T = 0.001 s');
  Show('Ad:', LD.A);
  Show('Bd:', LD.B);
  Show('Cd:', LD.C);
  LSame := 0;
  LTotal := 0;
  for LI := 0 to 2 do
    for LJ := 0 to 2 do
    begin
      Inc(LTotal);
      if FmtG(LD.A[LI][LJ], 15) = LSheetAd[3 * LI + LJ] then
        Inc(LSame);
    end;
  for LI := 0 to 2 do
  begin
    Inc(LTotal);
    if FmtG(LD.B[LI][0], 15) = LSheetBd[LI] then
      Inc(LSame);
  end;
  Writeln('C1 entries printed exactly as on the sheet: ', LSame, ' of ', LTotal);
  Check('C1 max relative difference Ad vs sheet', MatMaxRelDiff(LD.A, LAd) < 1.0e-13,
    MatMaxRelDiff(LD.A, LAd));
  Check('C1 max relative difference Bd vs sheet', MatMaxRelDiff(LD.B, LBd) < 1.0e-13,
    MatMaxRelDiff(LD.B, LBd));
  Check('C1 sheet digits reproduced', LSame = LTotal, LSame);
end;

procedure CaseC2;
var
  LL, LS: TStateModel;
  LAd, LBd, LAlt: TMatrix;
  LRel, LT: Double;
begin
  LT := 1.0e-3;
  SheetReferenceP1(LAd, LBd);
  LL := Discretise(ModelP1System1, LT, dmLecture);
  LS := Discretise(ModelP1System1, LT, dmTustin);
  Writeln('C2 system 1, standard bilinear Bd = (I - T/2 A)^-1 B T');
  Show('Bd (standard):', LS.B);
  LRel := MatMaxRelDiff(LS.B, LBd);
  Writeln('C2 relative difference to the sheet = ', FmtG(LRel, 10), ' (T/2 = ', FmtG(0.5 * LT, 10), ')');
  Check('C2 standard form misses the sheet by T/2', Abs(LRel / (0.5 * LT) - 1.0) < 1.0e-3, LRel);
  Check('C2 Bd(lecture) / Bd(standard) = 1 / (1 - T/2)',
    Abs(LL.B[0][0] / LS.B[0][0] - 1.0 / (1.0 - 0.5 * LT)) < 1.0e-12, LL.B[0][0] / LS.B[0][0]);
  LAlt := MatScale(MatMul(MatAdd(MatIdentity(3), LS.A), ModelP1System1.B), 0.5 * LT);
  Check('C2 identity (I - T/2 A)^-1 B T = T/2 (I + Ad) B', MatMaxAbsDiff(LAlt, LS.B) < 1.0e-17,
    MatMaxAbsDiff(LAlt, LS.B));
  Check('C2 same Ad for both bilinear forms', MatMaxAbsDiff(LL.A, LS.A) = 0.0, MatMaxAbsDiff(LL.A, LS.A));
  Writeln('C2 gain factor 1 / (1 - T/2): T = 0.001 s gives ', FmtF(1.0 / (1.0 - 0.0005), '0.0000000'),
    ', T = 0.1 s gives ', FmtF(1.0 / (1.0 - 0.05), '0.0000000'));
end;

procedure CaseC3;
var
  LD: TStateModel;
  LZ, LS: TComplexArray;
  LI: Integer;
  LT, LErr, LExpect: Double;
begin
  LT := 1.0e-3;
  LD := Discretise(ModelP1System1, LT, dmLecture);
  LS := Eigenvalues(ModelP1System1.A);
  LZ := Eigenvalues(LD.A);
  Writeln('C3 eigenvalues of A: ', EigText(LS));
  Writeln('C3 eigenvalues of Ad: ', EigText(LZ, 12));
  LErr := 0.0;
  for LI := 0 to 2 do
  begin
    LExpect := (1.0 + 0.5 * LT * LS[LI].Re) / (1.0 - 0.5 * LT * LS[LI].Re);
    LErr := Max(LErr, Abs(LZ[LI].Re - LExpect) + Abs(LZ[LI].Im));
  end;
  Check('C3 z = (1 + sT/2) / (1 - sT/2) for s = 2, 0, -2', LErr < 1.0e-12, LErr);
  Check('C3 largest |z| above 1 (step response diverges)', CAbs(LZ[0]) > 1.0, CAbs(LZ[0]));
end;

procedure CaseC4;
var
  LD: TStateModel;
  LZ: TComplexArray;
  LStep, LImp, LExS, LExI, LTus: TResponse;
  LT, LErrS, LErrI, LErrScaled, LAng: Double;
  LK, LN: Integer;
begin
  LT := 1.0e-3;
  LN := 10000;
  LD := Discretise(ModelP1System2, LT, dmLecture);
  Writeln('C4 Problem 1 system 2, lecture bilinear, T = 0.001 s');
  Show('Ad:', LD.A);
  Show('Bd:', LD.B);
  LZ := Eigenvalues(LD.A);
  LAng := ArcTan2(LZ[0].Im, LZ[0].Re);
  Writeln('C4 eigenvalues of Ad: ', EigText(LZ, 15));
  Writeln('C4 |z| - 1 = ', FmtG(CAbs(LZ[0]) - 1.0, 4), ', angle per sample = ', FmtG(Abs(LAng), 12),
    ' rad (omega T = ', FmtG(2.0 * LT, 12), ', 2 atan(omega T / 2) = ', FmtG(2.0 * ArcTan(LT), 12), ')');
  Check('C4 poles stay on the unit circle', Abs(CAbs(LZ[0]) - 1.0) < 1.0e-14, Abs(CAbs(LZ[0]) - 1.0));
  Check('C4 frequency warping, angle = 2 atan(omega T / 2) (relative)',
    Abs(Abs(LAng) / (2.0 * ArcTan(LT)) - 1.0) < 1.0e-10, Abs(Abs(LAng) / (2.0 * ArcTan(LT)) - 1.0));
  LStep := Simulate(LD, LN, LT, ikStep, 1.0);
  LImp := Simulate(LD, LN, LT, ikPulse, 1.0 / LT);
  LExS := ExactSampled(ModelP1System2, LN, LT, ikStep, 1.0);
  LExI := ExactSampled(ModelP1System2, LN, LT, ikPulse, 1.0);
  LTus := Simulate(Discretise(ModelP1System2, LT, dmTustin), LN, LT, ikStep, 1.0);
  LErrS := 0.0;
  LErrI := 0.0;
  LErrScaled := 0.0;
  for LK := 0 to LN do
  begin
    LErrS := Max(LErrS, Abs(LExS.Y[LK] - 0.5 * Sin(2.0 * LK * LT)));
    LErrI := Max(LErrI, Abs(LExI.Y[LK] - Cos(2.0 * LK * LT)));
    LErrScaled := Max(LErrScaled, Abs(LStep.Y[LK] * (1.0 - 0.5 * LT) - LTus.Y[LK]));
  end;
  Check('C4 exact step response = 0.5 sin 2t', LErrS < 1.0e-12, LErrS);
  Check('C4 exact impulse response = cos 2t', LErrI < 1.0e-12, LErrI);
  Check('C4 lecture step = standard step / (1 - T/2)', LErrScaled < 1.0e-13, LErrScaled);
  LErrS := 0.0;
  LErrI := 0.0;
  for LK := 0 to LN do
  begin
    LErrS := Max(LErrS, Abs(LStep.Y[LK] - LExS.Y[LK]));
    if LK >= 1 then
      LErrI := Max(LErrI, Abs(LImp.Y[LK] - LExI.Y[LK]));
  end;
  Writeln('C4 lecture model over 10 s: max |step - 0.5 sin 2t| = ', FmtG(LErrS, 4),
    ', max |pulse/T - cos 2t| (k >= 1) = ', FmtG(LErrI, 4));
  Writeln('C4 step: max ', FmtF(MaxValue(LStep.Y), '0.000000'), ', min ', FmtF(MinValue(LStep.Y), '0.000000'),
    '; pulse/T at k = 1: ', FmtF(LImp.Y[1], '0.000000'));
  Check('C4 lecture step response follows 0.5 sin 2t', LErrS < 1.0e-3, LErrS);
  Check('C4 lecture pulse response follows cos 2t', LErrI < 1.0e-2, LErrI);
  LStep := Simulate(Discretise(ModelP1System1, LT, dmLecture), 3000, LT, ikStep, 1.0);
  Writeln('C4 system 1 step response at t = 1, 2, 3 s: ', FmtF(LStep.Y[1000], '0.0000'), ', ',
    FmtF(LStep.Y[2000], '0.0000'), ', ', FmtF(LStep.Y[3000], '0.0000'));
  Check('C4 system 1 step response grows', LStep.Y[3000] > 10.0 * LStep.Y[1000], LStep.Y[3000]);
  if GCsvDir <> '' then
  begin
    LStep := Simulate(LD, LN, LT, ikStep, 1.0);
    WriteCsv('p1_sys2', 't_s,step_lecture,pulse_lecture_over_T,step_exact,impulse_exact',
      [LStep.T, LStep.Y, LImp.Y, LExS.Y, LExI.Y]);
    LD := Discretise(ModelP1System1, LT, dmLecture);
    LStep := Simulate(LD, 3000, LT, ikStep, 1.0);
    LImp := Simulate(LD, 3000, LT, ikPulse, 1.0 / LT);
    LExS := ExactSampled(ModelP1System1, 3000, LT, ikStep, 1.0);
    LExI := ExactSampled(ModelP1System1, 3000, LT, ikPulse, 1.0);
    WriteCsv('p1_sys1', 't_s,step_lecture,pulse_lecture_over_T,step_exact,impulse_exact',
      [LStep.T, LStep.Y, LImp.Y, LExS.Y, LExI.Y]);
  end;
end;

procedure CaseC5;
var
  LA, LRec, LRef: TMatrix;
  LSvd: TSVD;
  LI, LJ: Integer;
  LErr, LOrth: Double;
  LSigma: TMatrix;
begin
  { train1.dat of the lecturer: the 3 x 3 example of svdcmp }
  LA := MatFromArray(3, 3, [-6, 3, 4, 4, 5, 1, 1, 1, 1]);
  LSvd := SVDJacobi(LA);
  Writeln('C5 SVD of train1.dat (one-sided Jacobi, ', LSvd.Sweeps, ' sweeps)');
  Writeln('C5 sigma = ', FmtF(LSvd.S[0], '0.000000'), ', ', FmtF(LSvd.S[1], '0.000000'), ', ',
    FmtF(LSvd.S[2], '0.000000'), ' (svdku1.dat: 7.89, 6.57, 0.71 in the order 0.71, 7.89, 6.57)');
  Show('U:', LSvd.U, 6);
  Show('V:', LSvd.V, 6);
  LSigma := MatCreate(3, 3);
  for LI := 0 to 2 do
    LSigma[LI][LI] := LSvd.S[LI];
  LRec := MatMul(MatMul(LSvd.U, LSigma), MatTranspose(LSvd.V));
  LErr := MatMaxAbsDiff(LRec, LA);
  LOrth := Max(MatMaxAbsDiff(MatMul(MatTranspose(LSvd.U), LSvd.U), MatIdentity(3)),
    MatMaxAbsDiff(MatMul(MatTranspose(LSvd.V), LSvd.V), MatIdentity(3)));
  Check('C5 max |U S V^T - A|', LErr < 1.0e-13, LErr);
  Check('C5 max |U^T U - I|, |V^T V - I|', LOrth < 1.0e-14, LOrth);
  { svdku1.dat columns, reordered to descending sigma (7.89, 6.57, 0.71) }
  LRef := MatFromArray(3, 3, [0.967505, 0.250314, 0.035735, -0.251500, 0.938082, 0.238223,
    -0.026108, 0.239470, -0.970553]);
  LErr := 0.0;
  for LI := 0 to 2 do
    for LJ := 0 to 2 do
      LErr := Max(LErr, Abs(Abs(LSvd.U[LI][LJ]) - Abs(LRef[LI][LJ])));
  Check('C5 |U| against svdku1.dat (6 decimals)', LErr < 1.0e-6, LErr);
  LRef := MatFromArray(3, 3, [-0.866414, 0.378747, -0.325389, 0.205150, 0.864123, 0.459569,
    0.455236, 0.331424, -0.826389]);
  LErr := 0.0;
  for LI := 0 to 2 do
    for LJ := 0 to 2 do
      LErr := Max(LErr, Abs(Abs(LSvd.V[LI][LJ]) - Abs(LRef[LI][LJ])));
  Check('C5 |V| against svdku1.dat (6 decimals)', LErr < 1.0e-6, LErr);
  { a wide matrix goes through the transpose }
  LA := MatFromArray(2, 3, [1, 2, 3, 4, 5, 6]);
  LSvd := SVDJacobi(LA);
  LSigma := MatCreate(2, 2);
  LSigma[0][0] := LSvd.S[0];
  LSigma[1][1] := LSvd.S[1];
  LErr := MatMaxAbsDiff(MatMul(MatMul(LSvd.U, LSigma), MatTranspose(LSvd.V)), LA);
  Check('C5 wide 2 x 3 matrix reconstructed', LErr < 1.0e-13, LErr);
end;

procedure CaseC6;
var
  LS: TVector;
  LHK: THoKalman;
  LP3, LD: TStateModel;
  LZ: TComplexArray;
  LRef: TMatrix;
  LErr, LDc: Double;
  LI, LJ: Integer;
  LKv: TVector;
begin
  Writeln('C6 Problem 2: x'''' = -0.5 x'' - x + u, lecture bilinear, T = 0.1 s, 40 samples');
  LS := StepData(ModelP2Plant, 0.1, dmLecture, 40);
  Writeln('C6 S(0..8) = ', FmtF(LS[0], '0.000000'), ' ', FmtF(LS[1], '0.000000'), ' ', FmtF(LS[2], '0.000000'),
    ' ', FmtF(LS[3], '0.000000'), ' ', FmtF(LS[4], '0.000000'), ' ', FmtF(LS[5], '0.000000'), ' ',
    FmtF(LS[6], '0.000000'), ' ', FmtF(LS[7], '0.000000'), ' ', FmtF(LS[8], '0.000000'));
  LD := Discretise(ModelP2Plant, 0.1, dmLecture);
  LDc := MatMul(MatMul(LD.C, MatInverse(MatSub(MatIdentity(2), LD.A))), LD.B)[0][0];
  Check('C6 DC gain of the lecture data = 1 / (1 - T/2)', Abs(LDc - 1.0 / 0.95) < 1.0e-12, LDc);
  LHK := HoKalman(LS, 4, 4, 0, 1.0e-8);
  Show('H (4 x 4):', LHK.H, 8);
  Writeln('C6 sigma = ', FmtG(LHK.SVD.S[0], 10), ', ', FmtG(LHK.SVD.S[1], 10), ', ', FmtG(LHK.SVD.S[2], 3), ', ',
    FmtG(LHK.SVD.S[3], 3));
  Show('U (4 x 4):', LHK.SVD.U, 6);
  Check('C6 automatic order', LHK.Ok and (LHK.Order = 2), LHK.Order);
  Show('A:', LHK.Model.A, 10);
  Show('B:', LHK.Model.B, 10);
  Show('C:', LHK.Model.C, 10);
  Show('D:', LHK.Model.D, 10);
  LP3 := ModelP3Plant;
  LErr := Max(MatMaxAbsDiff(LHK.Model.A, LP3.A), Max(MatMaxAbsDiff(LHK.Model.B, LP3.B),
    MatMaxAbsDiff(LHK.Model.C, LP3.C)));
  Check('C6 A, B, C against the plant of Problem 3 (3 decimals)', LErr < 1.0e-3, LErr);
  Check('C6 identified step response reproduces the data', LHK.MaxStepError < 1.0e-12, LHK.MaxStepError);
  LZ := Eigenvalues(LD.A);
  Writeln('C6 eigenvalues identified: ', EigText(LHK.Eig, 12));
  Writeln('C6 eigenvalues of Ad (analytic): ', EigText(LZ, 12));
  LErr := Max(Abs(LHK.Eig[0].Re - LZ[0].Re), Abs(Abs(LHK.Eig[0].Im) - Abs(LZ[0].Im)));
  Check('C6 eigenvalues identified = eigenvalues of Ad', LErr < 1.0e-12, LErr);
  { first two columns of U in svdku123456.dat }
  LRef := MatFromArray(4, 2, [-0.310003, -0.784979, -0.432845, -0.332428, -0.545477, 0.101293,
    -0.647300, 0.512873]);
  LErr := 0.0;
  for LI := 0 to 3 do
    for LJ := 0 to 1 do
      LErr := Max(LErr, Abs(LHK.SVD.U[LI][LJ] - LRef[LI][LJ]));
  Check('C6 U(:, 1:2) against svdku123456.dat', LErr < 1.0e-3, LErr);
  if GCsvDir <> '' then
  begin
    SetLength(LKv, Length(LS));
    for LI := 0 to High(LS) do
      LKv[LI] := LI;
    WriteCsv('p2_lecture', 'k,step,markov,model_step', [LKv, LS, LHK.G, LHK.ModelStep]);
    WriteText('p2_hokalman_lecture.dat', HoKalmanText(LHK,
      '# Problem 2, Ho-Kalman realisation, lecture bilinear data, T = 0.1 s'));
  end;
end;

procedure CaseC7;
var
  LS: TVector;
  LHK, LHK8: THoKalman;
  LD: TStateModel;
  LZ, LZl: TComplexArray;
  LErr: Double;
begin
  LS := StepData(ModelP2Plant, 0.1, dmZOH, 40);
  LHK := HoKalman(LS, 4, 4, 0, 1.0e-8);
  LD := Discretise(ModelP2Plant, 0.1, dmZOH);
  LZ := Eigenvalues(LD.A);
  Writeln('C7 zero-order-hold data, Hankel 4 x 4: sigma = ', FmtG(LHK.SVD.S[0], 10), ', ',
    FmtG(LHK.SVD.S[1], 10));
  Show('A:', LHK.Model.A, 10);
  Show('B:', LHK.Model.B, 10);
  Show('C:', LHK.Model.C, 10);
  Writeln('C7 eigenvalues identified: ', EigText(LHK.Eig, 12), '; e^(sT): ', EigText(LZ, 12));
  LErr := Max(Abs(LHK.Eig[0].Re - LZ[0].Re), Abs(Abs(LHK.Eig[0].Im) - Abs(LZ[0].Im)));
  Check('C7 eigenvalues identified = e^(sT)', LErr < 1.0e-12, LErr);
  Check('C7 DC gain of the zero-order-hold data', Abs(MatMul(MatMul(LD.C,
    MatInverse(MatSub(MatIdentity(2), LD.A))), LD.B)[0][0] - 1.0) < 1.0e-12, 1.0);
  LS := StepData(ModelP2Plant, 0.1, dmLecture, 40);
  LHK8 := HoKalman(LS, 8, 8, 0, 1.0e-8);
  Writeln('C7 lecture data, Hankel 8 x 8: order ', LHK8.Order, ', sigma = ', FmtG(LHK8.SVD.S[0], 10), ', ',
    FmtG(LHK8.SVD.S[1], 10), ', ', FmtG(LHK8.SVD.S[2], 3));
  Show('A:', LHK8.Model.A, 10);
  Check('C7 8 x 8 Hankel: order still 2', LHK8.Ok and (LHK8.Order = 2), LHK8.Order);
  LZl := Eigenvalues(Discretise(ModelP2Plant, 0.1, dmLecture).A);
  LErr := Max(Abs(LHK8.Eig[0].Re - LZl[0].Re), Abs(Abs(LHK8.Eig[0].Im) - Abs(LZl[0].Im)));
  Check('C7 8 x 8 Hankel: eigenvalues of Ad unchanged', LErr < 1.0e-12, LErr);
  LHK8 := HoKalman(LS, 4, 4, 3, 1.0e-8);
  Writeln('C7 forced order 3: ', LHK8.Reason);
  Check('C7 order 3 rejected (sigma_3 is rounding noise)', not LHK8.Ok, LHK8.Order);
  LHK8 := HoKalman(LS, 30, 30, 0, 1.0e-8);
  Check('C7 too few samples for 30 x 30 rejected', not LHK8.Ok, Length(LS));
  if GCsvDir <> '' then
    WriteText('p2_hokalman_zoh.dat', HoKalmanText(LHK,
      '# Problem 2, Ho-Kalman realisation, zero-order-hold data, T = 0.1 s'));
end;

procedure CaseC8;
var
  LP: TStateModel;
  LG: TObserverGain;
  LRun: TObserverRun;
  LX0, LXh0: TVector;
begin
  LP := ModelP3Plant;
  LG := ObserverGain2(LP.A, LP.C, 0.8, 0.7);
  Writeln('C8 Problem 3: alpha = ', FmtG(LG.Alpha, 12), ', beta = ', FmtG(LG.Beta, 12), ', det O = ',
    FmtG(LG.DetObs, 12), ', det M = ', FmtG(LG.DetM, 12));
  Writeln('C8 Kob = [', FmtG(LG.K[0], 12), '; ', FmtG(LG.K[1], 12), ']');
  Writeln('C8 eigenvalues of A: ', EigText(LG.EigPlant, 10), ' (|z| = ', FmtF(CAbs(LG.EigPlant[0]), '0.000000'), ')');
  Writeln('C8 eigenvalues of A - Kob C: ', EigText(LG.EigError, 15));
  Check('C8 observer gain found', LG.Ok, Ord(LG.Ok));
  Check('C8 Kob1 = -2.49264453', Abs(LG.K[0] + 2.49264453) < 1.0e-8, LG.K[0]);
  Check('C8 Kob2 = -1.71495421', Abs(LG.K[1] + 1.71495421) < 1.0e-8, LG.K[1]);
  Check('C8 error poles at 0.8 and 0.7', (Abs(LG.EigError[0].Re - 0.8) < 1.0e-12) and
    (Abs(LG.EigError[1].Re - 0.7) < 1.0e-12) and (LG.EigError[0].Im = 0.0), LG.EigError[0].Re);
  Check('C8 det M = -det O', Abs(LG.DetM + LG.DetObs) < 1.0e-15, LG.DetM + LG.DetObs);
  SetLength(LX0, 2);
  SetLength(LXh0, 2);
  LX0[0] := 1.0;
  LX0[1] := 0.0;
  LXh0[0] := 0.0;
  LXh0[1] := 0.0;
  LRun := SimulateObserver(LP, LG.K, LX0, LXh0, 1.0, 40);
  Writeln('C8 |error| at k = 0, 10, 20, 30: observer ', FmtF(LRun.ErrObs[0], '0.000000'), ' ',
    FmtF(LRun.ErrObs[10], '0.000000'), ' ', FmtF(LRun.ErrObs[20], '0.000000'), ' ',
    FmtF(LRun.ErrObs[30], '0.000000'), '; open loop ', FmtF(LRun.ErrOpen[0], '0.000000'), ' ',
    FmtF(LRun.ErrOpen[10], '0.000000'), ' ', FmtF(LRun.ErrOpen[20], '0.000000'), ' ',
    FmtF(LRun.ErrOpen[30], '0.000000'));
  Check('C8 observer error below 1 % after 30 samples', LRun.ErrObs[30] < 0.01 * LRun.ErrObs[0],
    LRun.ErrObs[30]);
  Check('C8 open-loop error still above 30 % after 30 samples', LRun.ErrOpen[30] > 0.3 * LRun.ErrOpen[0],
    LRun.ErrOpen[30]);
  LG := ObserverGain2(MatFromArray(2, 2, [0.5, 0, 0, 0.6]), MatFromArray(1, 2, [1, 0]), 0.8, 0.7);
  Writeln('C8 unobservable plant: ', LG.Reason);
  Check('C8 unobservable plant rejected', not LG.Ok, LG.DetObs);
  if GCsvDir <> '' then
    WriteCsv('p3_observer', 'k,x1,x2,xo1,xo2,xm1,xm2,err_obs,err_open',
      [LRun.T, Column(LRun.X, 0), Column(LRun.X, 1), Column(LRun.XObs, 0), Column(LRun.XObs, 1),
      Column(LRun.XOpen, 0), Column(LRun.XOpen, 1), LRun.ErrObs, LRun.ErrOpen]);
end;

procedure CaseC9;
var
  LP: TStateModel;
  LG: TObserverGain;
  LA11, LA12, LA21, LA22, LC1, LC2, LTr, LDet, LK1, LK2: Double;
  LZ: TComplexArray;
begin
  LP := ModelPendulumSlides;
  LG := ObserverGain2(LP.A, LP.C, 0.1, 0.2);
  Writeln('C9 lecture slides pendulum, poles 0.1 and 0.2: Kob = [', FmtG(LG.K[0], 10), '; ', FmtG(LG.K[1], 10),
    '], eigenvalues of A - Kob C: ', EigText(LG.EigError, 10));
  { earlier student program: K1 from the trace equation with a wrong coefficient }
  LP := ModelP3Plant;
  LA11 := LP.A[0][0];
  LA12 := LP.A[0][1];
  LA21 := LP.A[1][0];
  LA22 := LP.A[1][1];
  LC1 := LP.C[0][0];
  LC2 := LP.C[0][1];
  LTr := LA11 + LA22;
  LDet := LA11 * LA22 - LA12 * LA21;
  LK1 := (LTr - 1.5) / (LC1 * LA21 - LC2 * LA11 + LC2 * LTr);
  LK2 := (LDet - 0.56 - LK1 * (LC1 * LA21 - LC2 * LA11)) / (LC1 * LA22 - LC2 * LA12);
  LZ := Eigenvalues(MatSub(LP.A, MatMul(MatFromArray(2, 1, [LK1, LK2]), LP.C)));
  Writeln('C9 earlier student formula: K = [', FmtG(LK1, 8), '; ', FmtG(LK2, 8), '], eigenvalues of A - K C: ',
    EigText(LZ, 6));
end;

begin
  if (ParamCount >= 2) and (ParamStr(1) = '--csv') then
    GCsvDir := ParamStr(2);
  try
    CaseC1;
    CaseC2;
    CaseC3;
    CaseC4;
    CaseC5;
    CaseC6;
    CaseC7;
    CaseC8;
    CaseC9;
  except
    on E: Exception do
    begin
      Writeln('[FAIL] unexpected ', E.ClassName, ': ', E.Message);
      Inc(GFailures);
    end;
  end;
  Writeln(GFailures, ' failure(s)');
  Halt(GFailures);
end.
