unit MPCModel;

{
  MPCModel.pas - Numerical core of the MPC experimental steps program
  (Biocybernetics Assignment 4).

  Author : Jeremia Christ Immanuel Manalu (5023231017)

  The unit contains no user-interface code, so it is compiled and tested
  with Free Pascal in CI (Verification/TestMPC.dpr).

  Problem 1  bilinear discretisation of a continuous state-space model
             with the lecture formula (report Equations 1.4 to 1.6), the
             standard bilinear form (Equation 1.7) and the exact zero-order
             hold (Equation 1.8); discrete step and impulse responses
  Problem 2  Ho-Kalman realisation from step data: Markov parameters,
             Hankel matrices, one-sided Jacobi SVD, A, B, C, D
             (Equations 1.10 to 1.16)
  Problem 3  observer gain of a 2 x 2 plant by pole placement in closed
             form (Equations 2.5 to 2.8) and the observer error simulation

  All models are single input, single output: B is n x 1, C is 1 x n and
  D is 1 x 1. Matrices are zero-based dynamic arrays, M[row][column].
}

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  SysUtils;

type
  TVector = array of Double;
  TMatrix = array of array of Double;

  EMPCError = class(Exception);

  TComplex = record
    Re, Im: Double;
  end;

  TComplexArray = array of TComplex;

  TDiscreteMethod = (dmLecture, dmTustin, dmZOH);
  TInputKind = (ikStep, ikPulse);

  TStateModel = record
    A, B, C, D: TMatrix;
  end;

  { Samples k = 0 .. Count - 1 at t = k T; X[k] is the state x(k). }
  TResponse = record
    T, U, Y: TVector;
    X: TMatrix;
  end;

  TSVD = record
    U: TMatrix;       { m x min(m, n), orthonormal columns }
    S: TVector;       { singular values, descending }
    V: TMatrix;       { n x min(m, n), orthonormal columns }
    Sweeps: Integer;  { Jacobi sweeps until no rotation was needed }
  end;

  THoKalman = record
    Ok: Boolean;
    Reason: string;
    Rows, Cols: Integer;     { Hankel size k x l }
    Order: Integer;          { model order n }
    Data: TVector;           { step data S0 .. SN }
    G: TVector;              { Markov parameters g0 .. gN }
    H, HUp: TMatrix;         { Hankel matrix and the one shifted by one sample }
    SVD: TSVD;
    Obs: TMatrix;            { observability matrix O_k, k x n }
    Ctr: TMatrix;            { controllability matrix C_l, n x l }
    Model: TStateModel;
    ModelStep: TVector;      { step response of the identified model }
    MaxStepError: Double;    { max |ModelStep - data| }
    Eig: TComplexArray;      { eigenvalues of the identified A }
  end;

  TObserverGain = record
    Ok: Boolean;
    Reason: string;
    Alpha, Beta: Double;     { right-hand side of the two coefficient equations }
    DetObs: Double;          { det of the observability matrix [C; CA] }
    DetM: Double;            { det of the coefficient matrix, equals -DetObs }
    K: TVector;              { observer gain Kob = [K1; K2] }
    EigPlant: TComplexArray; { eigenvalues of A }
    EigError: TComplexArray; { eigenvalues of A - Kob C }
  end;

  TObserverRun = record
    T, U, Y: TVector;
    X, XObs, XOpen: TMatrix;   { true state, observer estimate, open-loop model }
    ErrObs, ErrOpen: TVector;  { Euclidean norm of the estimation error }
  end;

const
  C_METHOD_NAMES: array[TDiscreteMethod] of string =
    ('lecture bilinear', 'standard bilinear', 'zero-order hold');

{ Matrix helpers }
function MatCreate(ARows, ACols: Integer): TMatrix;
function MatIdentity(AN: Integer): TMatrix;
function MatFromArray(ARows, ACols: Integer; const AValues: array of Double): TMatrix;
function MatRows(const AM: TMatrix): Integer;
function MatCols(const AM: TMatrix): Integer;
function MatCopy(const AM: TMatrix): TMatrix;
function MatAdd(const AA, AB: TMatrix): TMatrix;
function MatSub(const AA, AB: TMatrix): TMatrix;
function MatScale(const AM: TMatrix; AFactor: Double): TMatrix;
function MatMul(const AA, AB: TMatrix): TMatrix;
function MatTranspose(const AM: TMatrix): TMatrix;
function MatInverse(const AM: TMatrix): TMatrix;
function MatDet(const AM: TMatrix): Double;
function MatNormInf(const AM: TMatrix): Double;
function MatMaxAbsDiff(const AA, AB: TMatrix): Double;
function MatMaxRelDiff(const AA, ARef: TMatrix): Double;
function MatExp(const AM: TMatrix): TMatrix;
function MatColumn(const AM: TMatrix; ACol: Integer): TMatrix;
function MatRow(const AM: TMatrix; ARow: Integer): TMatrix;

{ Number formatting: FloatToStr style with 15 significant digits, '.' as
  decimal separator and a short exponent (5.000005000005E-7), as on the
  problem sheet. }
function FmtG(AValue: Double; ADigits: Integer = 15): string;
function FmtF(AValue: Double; const AFormat: string): string;
function MatToText(const AM: TMatrix; ADigits: Integer = 15; AWidth: Integer = 24): string;
function ComplexToText(const AZ: TComplex; ADigits: Integer = 10): string;

{ Eigenvalues }
function CharPoly(const AM: TMatrix): TVector;
function Eigenvalues(const AM: TMatrix): TComplexArray;
function CAbs(const AZ: TComplex): Double;

{ Problem 1 }
function ModelP1System1: TStateModel;
function ModelP1System2: TStateModel;
function ModelP2Plant: TStateModel;
function ModelP3Plant: TStateModel;
function ModelPendulumSlides: TStateModel;
procedure SheetReferenceP1(out AAd, ABd: TMatrix);
function ModelCopy(const AM: TStateModel): TStateModel;
function ModelOrder(const AM: TStateModel): Integer;
procedure CheckModel(const AM: TStateModel);
function Discretise(const AM: TStateModel; AT: Double; AMethod: TDiscreteMethod): TStateModel;
function Simulate(const AM: TStateModel; ASteps: Integer; AT: Double; AInput: TInputKind;
  AAmp: Double): TResponse;
function ExactSampled(const AM: TStateModel; ASteps: Integer; AT: Double; AInput: TInputKind;
  AAmp: Double): TResponse;

{ Problem 2 }
function StepData(const AM: TStateModel; AT: Double; AMethod: TDiscreteMethod;
  ASamples: Integer): TVector;
function MarkovFromStep(const AData: TVector): TVector;
function Hankel(const AG: TVector; ARows, ACols, AShift: Integer): TMatrix;
function SVDJacobi(const AM: TMatrix): TSVD;
function HoKalman(const AData: TVector; ARows, ACols, AOrder: Integer; ATol: Double): THoKalman;
function HoKalmanText(const AR: THoKalman; const AHeader: string): string;

{ Problem 3 }
function ObserverGain2(const AA, AC: TMatrix; AP1, AP2: Double): TObserverGain;
function SimulateObserver(const AM: TStateModel; const AK: TVector; const AX0, AXHat0: TVector;
  AAmp: Double; ASteps: Integer): TObserverRun;

implementation

uses
  Classes, Math;

const
  C_EPS = 2.220446049250313e-16;
  C_JACOBI_SWEEPS = 60;
  C_POLY_ITER = 2000;

function Fs: TFormatSettings;
begin
{$IFDEF FPC}
  Result := DefaultFormatSettings;
{$ELSE}
  Result := TFormatSettings.Invariant;
{$ENDIF}
  Result.DecimalSeparator := '.';
  Result.ThousandSeparator := ',';
end;

{ Matrix helpers }

function MatCreate(ARows, ACols: Integer): TMatrix;
var
  LI, LJ: Integer;
begin
  Result := nil;
  SetLength(Result, ARows, ACols);
  for LI := 0 to ARows - 1 do
    for LJ := 0 to ACols - 1 do
      Result[LI][LJ] := 0.0;
end;

function MatIdentity(AN: Integer): TMatrix;
var
  LI: Integer;
begin
  Result := MatCreate(AN, AN);
  for LI := 0 to AN - 1 do
    Result[LI][LI] := 1.0;
end;

function MatFromArray(ARows, ACols: Integer; const AValues: array of Double): TMatrix;
var
  LI, LJ: Integer;
begin
  if Length(AValues) <> ARows * ACols then
    raise EMPCError.Create('MatFromArray: wrong number of values.');
  Result := MatCreate(ARows, ACols);
  for LI := 0 to ARows - 1 do
    for LJ := 0 to ACols - 1 do
      Result[LI][LJ] := AValues[LI * ACols + LJ];
end;

function MatRows(const AM: TMatrix): Integer;
begin
  Result := Length(AM);
end;

function MatCols(const AM: TMatrix): Integer;
begin
  if Length(AM) = 0 then
    Result := 0
  else
    Result := Length(AM[0]);
end;

function MatCopy(const AM: TMatrix): TMatrix;
var
  LI, LJ: Integer;
begin
  Result := MatCreate(MatRows(AM), MatCols(AM));
  for LI := 0 to MatRows(AM) - 1 do
    for LJ := 0 to MatCols(AM) - 1 do
      Result[LI][LJ] := AM[LI][LJ];
end;

procedure CheckSameSize(const AA, AB: TMatrix; const AWhere: string);
begin
  if (MatRows(AA) <> MatRows(AB)) or (MatCols(AA) <> MatCols(AB)) then
    raise EMPCError.Create(AWhere + ': matrix sizes do not match.');
end;

function MatAdd(const AA, AB: TMatrix): TMatrix;
var
  LI, LJ: Integer;
begin
  CheckSameSize(AA, AB, 'MatAdd');
  Result := MatCreate(MatRows(AA), MatCols(AA));
  for LI := 0 to MatRows(AA) - 1 do
    for LJ := 0 to MatCols(AA) - 1 do
      Result[LI][LJ] := AA[LI][LJ] + AB[LI][LJ];
end;

function MatSub(const AA, AB: TMatrix): TMatrix;
var
  LI, LJ: Integer;
begin
  CheckSameSize(AA, AB, 'MatSub');
  Result := MatCreate(MatRows(AA), MatCols(AA));
  for LI := 0 to MatRows(AA) - 1 do
    for LJ := 0 to MatCols(AA) - 1 do
      Result[LI][LJ] := AA[LI][LJ] - AB[LI][LJ];
end;

function MatScale(const AM: TMatrix; AFactor: Double): TMatrix;
var
  LI, LJ: Integer;
begin
  Result := MatCreate(MatRows(AM), MatCols(AM));
  for LI := 0 to MatRows(AM) - 1 do
    for LJ := 0 to MatCols(AM) - 1 do
      Result[LI][LJ] := AFactor * AM[LI][LJ];
end;

function MatMul(const AA, AB: TMatrix): TMatrix;
var
  LI, LJ, LK: Integer;
  LSum: Double;
begin
  if MatCols(AA) <> MatRows(AB) then
    raise EMPCError.Create('MatMul: inner dimensions do not match.');
  Result := MatCreate(MatRows(AA), MatCols(AB));
  for LI := 0 to MatRows(AA) - 1 do
    for LJ := 0 to MatCols(AB) - 1 do
    begin
      LSum := 0.0;
      for LK := 0 to MatCols(AA) - 1 do
        LSum := LSum + AA[LI][LK] * AB[LK][LJ];
      Result[LI][LJ] := LSum;
    end;
end;

function MatTranspose(const AM: TMatrix): TMatrix;
var
  LI, LJ: Integer;
begin
  Result := MatCreate(MatCols(AM), MatRows(AM));
  for LI := 0 to MatRows(AM) - 1 do
    for LJ := 0 to MatCols(AM) - 1 do
      Result[LJ][LI] := AM[LI][LJ];
end;

{ Gauss-Jordan elimination with partial pivoting. A pivot below 1e-14
  times the largest entry counts as singular. }
function MatInverse(const AM: TMatrix): TMatrix;
var
  LN, LI, LJ, LK, LPiv: Integer;
  LW: TMatrix;
  LMax, LTmp, LF, LScale: Double;
begin
  LN := MatRows(AM);
  if (LN = 0) or (MatCols(AM) <> LN) then
    raise EMPCError.Create('MatInverse: the matrix is not square.');
  LW := MatCopy(AM);
  Result := MatIdentity(LN);
  LScale := Max(MatNormInf(AM), 1.0e-300);
  for LK := 0 to LN - 1 do
  begin
    LPiv := LK;
    LMax := Abs(LW[LK][LK]);
    for LI := LK + 1 to LN - 1 do
      if Abs(LW[LI][LK]) > LMax then
      begin
        LMax := Abs(LW[LI][LK]);
        LPiv := LI;
      end;
    if LMax <= 1.0e-14 * LScale then
      raise EMPCError.Create('The matrix is singular and has no inverse.');
    if LPiv <> LK then
      for LJ := 0 to LN - 1 do
      begin
        LTmp := LW[LK][LJ];
        LW[LK][LJ] := LW[LPiv][LJ];
        LW[LPiv][LJ] := LTmp;
        LTmp := Result[LK][LJ];
        Result[LK][LJ] := Result[LPiv][LJ];
        Result[LPiv][LJ] := LTmp;
      end;
    LF := LW[LK][LK];
    for LJ := 0 to LN - 1 do
    begin
      LW[LK][LJ] := LW[LK][LJ] / LF;
      Result[LK][LJ] := Result[LK][LJ] / LF;
    end;
    for LI := 0 to LN - 1 do
      if (LI <> LK) and (LW[LI][LK] <> 0.0) then
      begin
        LF := LW[LI][LK];
        for LJ := 0 to LN - 1 do
        begin
          LW[LI][LJ] := LW[LI][LJ] - LF * LW[LK][LJ];
          Result[LI][LJ] := Result[LI][LJ] - LF * Result[LK][LJ];
        end;
      end;
  end;
end;

{ Determinant by Gaussian elimination with partial pivoting. }
function MatDet(const AM: TMatrix): Double;
var
  LN, LI, LJ, LK, LPiv: Integer;
  LW: TMatrix;
  LTmp, LF: Double;
begin
  LN := MatRows(AM);
  if MatCols(AM) <> LN then
    raise EMPCError.Create('MatDet: the matrix is not square.');
  LW := MatCopy(AM);
  Result := 1.0;
  for LK := 0 to LN - 1 do
  begin
    LPiv := LK;
    for LI := LK + 1 to LN - 1 do
      if Abs(LW[LI][LK]) > Abs(LW[LPiv][LK]) then
        LPiv := LI;
    if LW[LPiv][LK] = 0.0 then
    begin
      Result := 0.0;
      Exit;
    end;
    if LPiv <> LK then
    begin
      for LJ := 0 to LN - 1 do
      begin
        LTmp := LW[LK][LJ];
        LW[LK][LJ] := LW[LPiv][LJ];
        LW[LPiv][LJ] := LTmp;
      end;
      Result := -Result;
    end;
    Result := Result * LW[LK][LK];
    for LI := LK + 1 to LN - 1 do
    begin
      LF := LW[LI][LK] / LW[LK][LK];
      for LJ := LK to LN - 1 do
        LW[LI][LJ] := LW[LI][LJ] - LF * LW[LK][LJ];
    end;
  end;
end;

function MatNormInf(const AM: TMatrix): Double;
var
  LI, LJ: Integer;
  LSum: Double;
begin
  Result := 0.0;
  for LI := 0 to MatRows(AM) - 1 do
  begin
    LSum := 0.0;
    for LJ := 0 to MatCols(AM) - 1 do
      LSum := LSum + Abs(AM[LI][LJ]);
    Result := Max(Result, LSum);
  end;
end;

function MatMaxAbsDiff(const AA, AB: TMatrix): Double;
var
  LI, LJ: Integer;
begin
  CheckSameSize(AA, AB, 'MatMaxAbsDiff');
  Result := 0.0;
  for LI := 0 to MatRows(AA) - 1 do
    for LJ := 0 to MatCols(AA) - 1 do
      Result := Max(Result, Abs(AA[LI][LJ] - AB[LI][LJ]));
end;

{ Largest |a - ref| / |ref| over the nonzero entries of ARef; a zero
  reference entry counts with the absolute difference. }
function MatMaxRelDiff(const AA, ARef: TMatrix): Double;
var
  LI, LJ: Integer;
  LD: Double;
begin
  CheckSameSize(AA, ARef, 'MatMaxRelDiff');
  Result := 0.0;
  for LI := 0 to MatRows(AA) - 1 do
    for LJ := 0 to MatCols(AA) - 1 do
    begin
      LD := Abs(AA[LI][LJ] - ARef[LI][LJ]);
      if ARef[LI][LJ] <> 0.0 then
        LD := LD / Abs(ARef[LI][LJ]);
      Result := Max(Result, LD);
    end;
end;

{ e^M by scaling and squaring: M / 2^s has a norm below 0.5, a Taylor
  series of 20 terms gives full double precision, then s squarings. }
function MatExp(const AM: TMatrix): TMatrix;
var
  LN, LS, LK: Integer;
  LNorm: Double;
  LA, LTerm: TMatrix;
begin
  LN := MatRows(AM);
  LNorm := MatNormInf(AM);
  LS := 0;
  while LNorm > 0.5 do
  begin
    LNorm := 0.5 * LNorm;
    Inc(LS);
  end;
  LA := MatScale(AM, IntPower(2.0, -LS));
  Result := MatIdentity(LN);
  LTerm := MatIdentity(LN);
  for LK := 1 to 20 do
  begin
    LTerm := MatScale(MatMul(LTerm, LA), 1.0 / LK);
    Result := MatAdd(Result, LTerm);
  end;
  for LK := 1 to LS do
    Result := MatMul(Result, Result);
end;

function MatColumn(const AM: TMatrix; ACol: Integer): TMatrix;
var
  LI: Integer;
begin
  Result := MatCreate(MatRows(AM), 1);
  for LI := 0 to MatRows(AM) - 1 do
    Result[LI][0] := AM[LI][ACol];
end;

function MatRow(const AM: TMatrix; ARow: Integer): TMatrix;
var
  LJ: Integer;
begin
  Result := MatCreate(1, MatCols(AM));
  for LJ := 0 to MatCols(AM) - 1 do
    Result[0][LJ] := AM[ARow][LJ];
end;

{ Formatting }

function FmtG(AValue: Double; ADigits: Integer): string;
var
  LP, LExp: Integer;
  LMant: string;
begin
  if IsNan(AValue) then
    Exit('NaN');
  if IsInfinite(AValue) then
  begin
    if AValue > 0 then
      Exit('Inf');
    Exit('-Inf');
  end;
  Result := FloatToStrF(AValue, ffGeneral, ADigits, 0, Fs);
  LP := Pos('E', Result);
  if LP > 0 then
  begin
    LMant := Copy(Result, 1, LP - 1);
    LExp := StrToInt(Copy(Result, LP + 1, MaxInt));
    Result := LMant + 'E' + IntToStr(LExp);
  end;
end;

function FmtF(AValue: Double; const AFormat: string): string;
begin
  Result := FormatFloat(AFormat, AValue, Fs);
end;

function MatToText(const AM: TMatrix; ADigits, AWidth: Integer): string;
var
  LI, LJ: Integer;
  LCell: string;
begin
  Result := '';
  for LI := 0 to MatRows(AM) - 1 do
  begin
    for LJ := 0 to MatCols(AM) - 1 do
    begin
      LCell := FmtG(AM[LI][LJ], ADigits);
      if LJ < MatCols(AM) - 1 then
        while Length(LCell) < AWidth do
          LCell := LCell + ' ';
      Result := Result + LCell;
    end;
    if LI < MatRows(AM) - 1 then
      Result := Result + sLineBreak;
  end;
end;

function ComplexToText(const AZ: TComplex; ADigits: Integer): string;
begin
  if AZ.Im = 0.0 then
    Result := FmtG(AZ.Re, ADigits)
  else if AZ.Im > 0 then
    Result := FmtG(AZ.Re, ADigits) + ' + ' + FmtG(AZ.Im, ADigits) + 'j'
  else
    Result := FmtG(AZ.Re, ADigits) + ' - ' + FmtG(-AZ.Im, ADigits) + 'j';
end;

{ Complex arithmetic for the polynomial root finder }

function Cx(ARe, AIm: Double): TComplex;
begin
  Result.Re := ARe;
  Result.Im := AIm;
end;

function CAdd(const AA, AB: TComplex): TComplex;
begin
  Result := Cx(AA.Re + AB.Re, AA.Im + AB.Im);
end;

function CSub(const AA, AB: TComplex): TComplex;
begin
  Result := Cx(AA.Re - AB.Re, AA.Im - AB.Im);
end;

function CMul(const AA, AB: TComplex): TComplex;
begin
  Result := Cx(AA.Re * AB.Re - AA.Im * AB.Im, AA.Re * AB.Im + AA.Im * AB.Re);
end;

function CDiv(const AA, AB: TComplex): TComplex;
var
  LD: Double;
begin
  LD := Sqr(AB.Re) + Sqr(AB.Im);
  Result := Cx((AA.Re * AB.Re + AA.Im * AB.Im) / LD, (AA.Im * AB.Re - AA.Re * AB.Im) / LD);
end;

function CAbs(const AZ: TComplex): Double;
begin
  Result := Hypot(AZ.Re, AZ.Im);
end;

{ Eigenvalues }

{ Coefficients c0 .. cn of det(lambda I - M) = sum c_i lambda^i (cn = 1),
  by the Faddeev-LeVerrier recursion. }
function CharPoly(const AM: TMatrix): TVector;
var
  LN, LK, LI: Integer;
  LMk, LAM: TMatrix;
  LTr: Double;
begin
  Result := nil;
  LN := MatRows(AM);
  SetLength(Result, LN + 1);
  Result[LN] := 1.0;
  LMk := MatCreate(LN, LN);
  for LK := 1 to LN do
  begin
    LMk := MatMul(AM, LMk);
    for LI := 0 to LN - 1 do
      LMk[LI][LI] := LMk[LI][LI] + Result[LN - LK + 1];
    LAM := MatMul(AM, LMk);
    LTr := 0.0;
    for LI := 0 to LN - 1 do
      LTr := LTr + LAM[LI][LI];
    Result[LN - LK] := -LTr / LK;
  end;
end;

function PolyEval(const AC: TVector; const AZ: TComplex): TComplex;
var
  LI: Integer;
begin
  Result := Cx(AC[High(AC)], 0.0);
  for LI := High(AC) - 1 downto 0 do
    Result := CAdd(CMul(Result, AZ), Cx(AC[LI], 0.0));
end;

function PolyDerivEval(const AC: TVector; const AZ: TComplex): TComplex;
var
  LI: Integer;
begin
  Result := Cx(High(AC) * AC[High(AC)], 0.0);
  for LI := High(AC) - 1 downto 1 do
    Result := CAdd(CMul(Result, AZ), Cx(LI * AC[LI], 0.0));
end;

{ Roots of a monic real polynomial by Durand-Kerner iteration, polished
  with Newton steps. Used for n > 2 only. }
function PolyRoots(const AC: TVector): TComplexArray;
var
  LN, LI, LJ, LIter: Integer;
  LDen, LNew, LSeed: TComplex;
  LChange: Double;
begin
  Result := nil;
  LN := High(AC);
  SetLength(Result, LN);
  LSeed := Cx(0.4, 0.9);
  for LI := 0 to LN - 1 do
  begin
    if LI = 0 then
      Result[LI] := LSeed
    else
      Result[LI] := CMul(Result[LI - 1], LSeed);
  end;
  for LIter := 1 to C_POLY_ITER do
  begin
    LChange := 0.0;
    for LI := 0 to LN - 1 do
    begin
      LDen := Cx(1.0, 0.0);
      for LJ := 0 to LN - 1 do
        if LJ <> LI then
          LDen := CMul(LDen, CSub(Result[LI], Result[LJ]));
      if CAbs(LDen) = 0.0 then
        Continue;
      LNew := CSub(Result[LI], CDiv(PolyEval(AC, Result[LI]), LDen));
      LChange := Max(LChange, CAbs(CSub(LNew, Result[LI])));
      Result[LI] := LNew;
    end;
    if LChange < 1.0e-15 then
      Break;
  end;
  for LI := 0 to LN - 1 do
    for LIter := 1 to 3 do
    begin
      LDen := PolyDerivEval(AC, Result[LI]);
      if CAbs(LDen) > 0.0 then
        Result[LI] := CSub(Result[LI], CDiv(PolyEval(AC, Result[LI]), LDen));
    end;
  for LI := 0 to LN - 1 do
    if Abs(Result[LI].Im) < 1.0e-12 * (1.0 + CAbs(Result[LI])) then
      Result[LI].Im := 0.0;
end;

procedure SortComplex(var AZ: TComplexArray);
var
  LI, LJ: Integer;
  LT: TComplex;
begin
  for LI := 1 to High(AZ) do
  begin
    LT := AZ[LI];
    LJ := LI - 1;
    while (LJ >= 0) and ((AZ[LJ].Re < LT.Re) or ((AZ[LJ].Re = LT.Re) and (AZ[LJ].Im < LT.Im))) do
    begin
      AZ[LJ + 1] := AZ[LJ];
      Dec(LJ);
    end;
    AZ[LJ + 1] := LT;
  end;
end;

{ Closed form for n = 1 and n = 2 (the 2 x 2 case keeps |z| = sqrt(det)
  exact for a complex pair), Faddeev-LeVerrier and Durand-Kerner for n > 2.
  Sorted by real part, then imaginary part, descending. }
function Eigenvalues(const AM: TMatrix): TComplexArray;
var
  LN, LI: Integer;
  LHalfTr, LDet, LDisc, LQ: Double;
  LShift: TMatrix;
begin
  Result := nil;
  LN := MatRows(AM);
  if (LN = 0) or (MatCols(AM) <> LN) then
    raise EMPCError.Create('Eigenvalues: the matrix is not square.');
  SetLength(Result, LN);
  if LN = 1 then
    Result[0] := Cx(AM[0][0], 0.0)
  else if LN = 2 then
  begin
    LHalfTr := 0.5 * (AM[0][0] + AM[1][1]);
    LDet := AM[0][0] * AM[1][1] - AM[0][1] * AM[1][0];
    LDisc := Sqr(LHalfTr) - LDet;
    if LDisc >= 0.0 then
    begin
      { the larger root first, the smaller from the product (no cancellation) }
      if LHalfTr >= 0 then
        LQ := LHalfTr + Sqrt(LDisc)
      else
        LQ := LHalfTr - Sqrt(LDisc);
      if LQ = 0.0 then
      begin
        Result[0] := Cx(0.0, 0.0);
        Result[1] := Cx(0.0, 0.0);
      end
      else
      begin
        Result[0] := Cx(LQ, 0.0);
        Result[1] := Cx(LDet / LQ, 0.0);
      end;
    end
    else
    begin
      Result[0] := Cx(LHalfTr, Sqrt(-LDisc));
      Result[1] := Cx(LHalfTr, -Sqrt(-LDisc));
    end;
  end
  else
  begin
    { roots of the shifted and scaled matrix (A - cI) / s are of order one
      and well separated, so close eigenvalues such as 1.002, 1, 0.998
      keep full precision (ISS-084) }
    LHalfTr := 0.0;
    for LI := 0 to LN - 1 do
      LHalfTr := LHalfTr + AM[LI][LI];
    LHalfTr := LHalfTr / LN;
    LShift := MatCopy(AM);
    for LI := 0 to LN - 1 do
      LShift[LI][LI] := LShift[LI][LI] - LHalfTr;
    LQ := MatNormInf(LShift);
    if LQ = 0.0 then
      for LI := 0 to LN - 1 do
        Result[LI] := Cx(LHalfTr, 0.0)
    else
    begin
      Result := PolyRoots(CharPoly(MatScale(LShift, 1.0 / LQ)));
      for LI := 0 to LN - 1 do
        Result[LI] := Cx(LHalfTr + LQ * Result[LI].Re, LQ * Result[LI].Im);
    end;
  end;
  SortComplex(Result);
end;

{ Models of the problem sheet and the lecture slides }

function ModelP1System1: TStateModel;
begin
  Result.A := MatFromArray(3, 3, [0, 1, 0, 3, 0, 1, 0, 1, 0]);
  Result.B := MatFromArray(3, 1, [1, 1, 3]);
  Result.C := MatFromArray(1, 3, [0, 1, 0]);
  Result.D := MatFromArray(1, 1, [0]);
end;

function ModelP1System2: TStateModel;
begin
  Result.A := MatFromArray(2, 2, [0, 1, -4, 0]);
  Result.B := MatFromArray(2, 1, [0, 1]);
  Result.C := MatFromArray(1, 2, [0, 1]);
  Result.D := MatFromArray(1, 1, [0]);
end;

{ x'' = -0.5 x' - x + u with x1 = x, x2 = x', y = x (report Equation 2.4). }
function ModelP2Plant: TStateModel;
begin
  Result.A := MatFromArray(2, 2, [0, 1, -1, -0.5]);
  Result.B := MatFromArray(2, 1, [0, 1]);
  Result.C := MatFromArray(1, 2, [1, 0]);
  Result.D := MatFromArray(1, 1, [0]);
end;

function ModelP3Plant: TStateModel;
begin
  Result.A := MatFromArray(2, 2, [1.201, -0.249, 0.249, 0.74]);
  Result.B := MatFromArray(2, 1, [-0.115, 0.09]);
  Result.C := MatFromArray(1, 2, [-0.115, -0.09]);
  Result.D := MatFromArray(1, 1, [0]);
end;

{ Discrete pendulum of the observer example on the MPC slides (p. 26):
  omega = 2 rad/s, dt = 0.1 s, desired observer poles 0.1 and 0.2. }
function ModelPendulumSlides: TStateModel;
begin
  Result.A := MatFromArray(2, 2, [0.9801, 0.0993, -0.3973, 0.9801]);
  Result.B := MatFromArray(2, 1, [0.0050, 0.09930]);
  Result.C := MatFromArray(1, 2, [0, 1]);
  Result.D := MatFromArray(1, 1, [0]);
end;

{ Ad and Bd of system 1 as printed on the problem sheet (T = 1E-03 s). }
procedure SheetReferenceP1(out AAd, ABd: TMatrix);
begin
  AAd := MatFromArray(3, 3, [1.0000015000015, 0.001000001000001, 5.000005000005E-7,
    0.003000003000003, 1.000002000002, 0.001000001000001,
    1.5000015000015E-6, 0.001000001000001, 1.0000005000005]);
  ABd := MatFromArray(3, 1, [0.00100100200150225, 0.00100350275437819, 0.00300200250175238]);
end;

function ModelCopy(const AM: TStateModel): TStateModel;
begin
  Result.A := MatCopy(AM.A);
  Result.B := MatCopy(AM.B);
  Result.C := MatCopy(AM.C);
  Result.D := MatCopy(AM.D);
end;

function ModelOrder(const AM: TStateModel): Integer;
begin
  Result := MatRows(AM.A);
end;

procedure CheckModel(const AM: TStateModel);
var
  LN: Integer;
begin
  LN := MatRows(AM.A);
  if (LN = 0) or (MatCols(AM.A) <> LN) then
    raise EMPCError.Create('A must be a square matrix.');
  if (MatRows(AM.B) <> LN) or (MatCols(AM.B) <> 1) then
    raise EMPCError.Create('B must have ' + IntToStr(LN) + ' rows and one column.');
  if (MatRows(AM.C) <> 1) or (MatCols(AM.C) <> LN) then
    raise EMPCError.Create('C must have one row and ' + IntToStr(LN) + ' columns.');
  if (MatRows(AM.D) <> 1) or (MatCols(AM.D) <> 1) then
    raise EMPCError.Create('D must be 1 x 1.');
end;

{ Problem 1: discretisation with sampling time AT.
  dmLecture  Ad = (I - T/2 A)^-1 (I + T/2 A), Bd = (I - T/2 A)^-1 B T / (1 - T/2),
             Cd = C, Dd = D (report Equations 1.4 to 1.6, lecture slides p. 11)
  dmTustin   the same Ad, Bd = (I - T/2 A)^-1 B T (Equation 1.7)
  dmZOH      Ad = e^(AT), Bd = integral of e^(As) B over one sample, both
             from the exponential of the augmented matrix [A B; 0 0] T
             (Equation 1.8) }
function Discretise(const AM: TStateModel; AT: Double; AMethod: TDiscreteMethod): TStateModel;
var
  LN, LI, LJ: Integer;
  LI_, LMinv, LAug, LE: TMatrix;
begin
  CheckModel(AM);
  if not (AT > 0) then
    raise EMPCError.Create('The sampling time T must be positive.');
  LN := ModelOrder(AM);
  Result.C := MatCopy(AM.C);
  Result.D := MatCopy(AM.D);
  if AMethod = dmZOH then
  begin
    LAug := MatCreate(LN + 1, LN + 1);
    for LI := 0 to LN - 1 do
    begin
      for LJ := 0 to LN - 1 do
        LAug[LI][LJ] := AM.A[LI][LJ] * AT;
      LAug[LI][LN] := AM.B[LI][0] * AT;
    end;
    LE := MatExp(LAug);
    Result.A := MatCreate(LN, LN);
    Result.B := MatCreate(LN, 1);
    for LI := 0 to LN - 1 do
    begin
      for LJ := 0 to LN - 1 do
        Result.A[LI][LJ] := LE[LI][LJ];
      Result.B[LI][0] := LE[LI][LN];
    end;
    Exit;
  end;
  if (AMethod = dmLecture) and (Abs(1.0 - 0.5 * AT) < 1.0e-12) then
    raise EMPCError.Create('The lecture formula divides by 1 - T/2, so T = 2 s is not allowed.');
  LI_ := MatIdentity(LN);
  LMinv := nil;
  try
    LMinv := MatInverse(MatSub(LI_, MatScale(AM.A, 0.5 * AT)));
  except
    on EMPCError do
      raise EMPCError.Create('I - T/2 A is singular: s = 2/T is an eigenvalue of A. Change T.');
  end;
  Result.A := MatMul(LMinv, MatAdd(LI_, MatScale(AM.A, 0.5 * AT)));
  if AMethod = dmLecture then
    Result.B := MatScale(MatMul(LMinv, AM.B), AT / (1.0 - 0.5 * AT))
  else
    Result.B := MatScale(MatMul(LMinv, AM.B), AT);
end;

{ x(k+1) = Ad x(k) + Bd u(k), y(k) = Cd x(k) + Dd u(k) from x(0) = 0
  (report Equation 1.9). Step: u(k) = AAmp for k >= 0. Pulse: u(0) = AAmp,
  u(k) = 0 afterwards. }
function Simulate(const AM: TStateModel; ASteps: Integer; AT: Double; AInput: TInputKind;
  AAmp: Double): TResponse;
var
  LN, LK, LI, LJ: Integer;
  LX, LXn: TVector;
  LU, LSum: Double;
begin
  Result := Default(TResponse);
  CheckModel(AM);
  if ASteps < 1 then
    raise EMPCError.Create('At least one sample is needed.');
  LN := ModelOrder(AM);
  SetLength(Result.T, ASteps + 1);
  SetLength(Result.U, ASteps + 1);
  SetLength(Result.Y, ASteps + 1);
  Result.X := MatCreate(ASteps + 1, LN);
  SetLength(LX, LN);
  SetLength(LXn, LN);
  for LI := 0 to LN - 1 do
    LX[LI] := 0.0;
  for LK := 0 to ASteps do
  begin
    if (AInput = ikStep) or (LK = 0) then
      LU := AAmp
    else
      LU := 0.0;
    LSum := AM.D[0][0] * LU;
    for LI := 0 to LN - 1 do
    begin
      LSum := LSum + AM.C[0][LI] * LX[LI];
      Result.X[LK][LI] := LX[LI];
    end;
    Result.T[LK] := LK * AT;
    Result.U[LK] := LU;
    Result.Y[LK] := LSum;
    for LI := 0 to LN - 1 do
    begin
      LSum := AM.B[LI][0] * LU;
      for LJ := 0 to LN - 1 do
        LSum := LSum + AM.A[LI][LJ] * LX[LJ];
      LXn[LI] := LSum;
    end;
    for LI := 0 to LN - 1 do
      LX[LI] := LXn[LI];
  end;
end;

{ Continuous response sampled at t = k T without discretisation error:
  step  the zero-order-hold model is exact for a constant input;
  pulse the Dirac impulse of area AAmp gives x(0+) = B AAmp and then
        x((k+1)T) = e^(AT) x(kT), y = C x. }
function ExactSampled(const AM: TStateModel; ASteps: Integer; AT: Double; AInput: TInputKind;
  AAmp: Double): TResponse;
var
  LZ: TStateModel;
  LN, LK, LI, LJ: Integer;
  LX, LXn: TVector;
  LSum: Double;
begin
  LZ := Discretise(AM, AT, dmZOH);
  if AInput = ikStep then
  begin
    Result := Simulate(LZ, ASteps, AT, ikStep, AAmp);
    Exit;
  end;
  LN := ModelOrder(AM);
  SetLength(Result.T, ASteps + 1);
  SetLength(Result.U, ASteps + 1);
  SetLength(Result.Y, ASteps + 1);
  Result.X := MatCreate(ASteps + 1, LN);
  SetLength(LX, LN);
  SetLength(LXn, LN);
  for LI := 0 to LN - 1 do
    LX[LI] := AM.B[LI][0] * AAmp;
  for LK := 0 to ASteps do
  begin
    LSum := 0.0;
    for LI := 0 to LN - 1 do
    begin
      LSum := LSum + AM.C[0][LI] * LX[LI];
      Result.X[LK][LI] := LX[LI];
    end;
    Result.T[LK] := LK * AT;
    Result.U[LK] := 0.0;
    Result.Y[LK] := LSum;
    for LI := 0 to LN - 1 do
    begin
      LSum := 0.0;
      for LJ := 0 to LN - 1 do
        LSum := LSum + LZ.A[LI][LJ] * LX[LJ];
      LXn[LI] := LSum;
    end;
    for LI := 0 to LN - 1 do
      LX[LI] := LXn[LI];
  end;
end;

{ Problem 2 }

{ Unit-step data S0 .. S(ASamples - 1) of the continuous model, sampled
  through the chosen discretisation. }
function StepData(const AM: TStateModel; AT: Double; AMethod: TDiscreteMethod;
  ASamples: Integer): TVector;
var
  LR: TResponse;
begin
  if ASamples < 2 then
    raise EMPCError.Create('At least two step samples are needed.');
  LR := Simulate(Discretise(AM, AT, AMethod), ASamples - 1, AT, ikStep, 1.0);
  Result := LR.Y;
end;

{ g0 = S0, gk = Sk - S(k-1) (report Equation 1.10, lecture slides p. 12). }
function MarkovFromStep(const AData: TVector): TVector;
var
  LK: Integer;
begin
  Result := nil;
  SetLength(Result, Length(AData));
  if Length(AData) = 0 then
    Exit;
  Result[0] := AData[0];
  for LK := 1 to High(AData) do
    Result[LK] := AData[LK] - AData[LK - 1];
end;

{ H[i][j] = g(1 + i + j + AShift); AShift = 0 gives H_(k,l) with g1 in the
  corner, AShift = 1 the shifted matrix H_up (report Equation 1.11). }
function Hankel(const AG: TVector; ARows, ACols, AShift: Integer): TMatrix;
var
  LI, LJ: Integer;
begin
  if (ARows < 1) or (ACols < 1) then
    raise EMPCError.Create('The Hankel matrix needs at least one row and one column.');
  if ARows + ACols + AShift > Length(AG) then
    raise EMPCError.Create('Not enough Markov parameters for a ' + IntToStr(ARows) + ' x ' +
      IntToStr(ACols) + ' Hankel matrix: ' + IntToStr(ARows + ACols + AShift) + ' samples needed.');
  Result := MatCreate(ARows, ACols);
  for LI := 0 to ARows - 1 do
    for LJ := 0 to ACols - 1 do
      Result[LI][LJ] := AG[1 + LI + LJ + AShift];
end;

{ Columns a_p, a_q of W are rotated until all pairs are orthogonal
  (one-sided Jacobi, report Equation 1.16):
    zeta = (beta - alpha) / (2 gamma), t = sign(zeta) / (|zeta| + sqrt(1 + zeta^2)),
    c = 1 / sqrt(1 + t^2), s = c t,
  with alpha = |a_p|^2, beta = |a_q|^2, gamma = a_p . a_q. The same
  rotations applied to the identity give V; sigma_j = |w_j| and
  u_j = w_j / sigma_j. A matrix with fewer rows than columns is handled
  through its transpose. Columns of U for zero singular values are
  completed by Gram-Schmidt. Sign convention: the first entry of every
  column of U is negative or zero, as in the lecturer's svdku output. }
function SVDJacobi(const AM: TMatrix): TSVD;
var
  LM, LN, LP, LQ, LI, LJ, LK, LBest, LSweep: Integer;
  LW, LV: TMatrix;
  LAlpha, LBeta, LGamma, LZeta, LT, LC, LS, LTmp, LNorm, LSMax, LDot: Double;
  LRotated: Boolean;
  LTr: TSVD;
begin
  LM := MatRows(AM);
  LN := MatCols(AM);
  if (LM = 0) or (LN = 0) then
    raise EMPCError.Create('SVD of an empty matrix.');
  if LM < LN then
  begin
    LTr := SVDJacobi(MatTranspose(AM));
    Result.U := LTr.V;
    Result.S := LTr.S;
    Result.V := LTr.U;
    Result.Sweeps := LTr.Sweeps;
    for LJ := 0 to High(Result.S) do
      if Result.U[0][LJ] > 0 then
      begin
        for LI := 0 to LM - 1 do
          Result.U[LI][LJ] := -Result.U[LI][LJ];
        for LI := 0 to LN - 1 do
          Result.V[LI][LJ] := -Result.V[LI][LJ];
      end;
    Exit;
  end;
  LW := MatCopy(AM);
  LV := MatIdentity(LN);
  LSweep := 0;
  repeat
    LRotated := False;
    Inc(LSweep);
    for LP := 0 to LN - 2 do
      for LQ := LP + 1 to LN - 1 do
      begin
        LAlpha := 0.0;
        LBeta := 0.0;
        LGamma := 0.0;
        for LI := 0 to LM - 1 do
        begin
          LAlpha := LAlpha + Sqr(LW[LI][LP]);
          LBeta := LBeta + Sqr(LW[LI][LQ]);
          LGamma := LGamma + LW[LI][LP] * LW[LI][LQ];
        end;
        if (LGamma = 0.0) or (Abs(LGamma) <= C_EPS * Sqrt(LAlpha * LBeta)) then
          Continue;
        LRotated := True;
        LZeta := (LBeta - LAlpha) / (2.0 * LGamma);
        if LZeta >= 0 then
          LT := 1.0 / (LZeta + Sqrt(1.0 + Sqr(LZeta)))
        else
          LT := -1.0 / (-LZeta + Sqrt(1.0 + Sqr(LZeta)));
        LC := 1.0 / Sqrt(1.0 + Sqr(LT));
        LS := LC * LT;
        for LI := 0 to LM - 1 do
        begin
          LTmp := LW[LI][LP];
          LW[LI][LP] := LC * LTmp - LS * LW[LI][LQ];
          LW[LI][LQ] := LS * LTmp + LC * LW[LI][LQ];
        end;
        for LI := 0 to LN - 1 do
        begin
          LTmp := LV[LI][LP];
          LV[LI][LP] := LC * LTmp - LS * LV[LI][LQ];
          LV[LI][LQ] := LS * LTmp + LC * LV[LI][LQ];
        end;
      end;
  until (not LRotated) or (LSweep >= C_JACOBI_SWEEPS);
  Result.Sweeps := LSweep;
  SetLength(Result.S, LN);
  for LJ := 0 to LN - 1 do
  begin
    LNorm := 0.0;
    for LI := 0 to LM - 1 do
      LNorm := LNorm + Sqr(LW[LI][LJ]);
    Result.S[LJ] := Sqrt(LNorm);
  end;
  { selection sort, descending; the columns of W and V move with sigma }
  for LJ := 0 to LN - 2 do
  begin
    LBest := LJ;
    for LK := LJ + 1 to LN - 1 do
      if Result.S[LK] > Result.S[LBest] then
        LBest := LK;
    if LBest <> LJ then
    begin
      LTmp := Result.S[LJ];
      Result.S[LJ] := Result.S[LBest];
      Result.S[LBest] := LTmp;
      for LI := 0 to LM - 1 do
      begin
        LTmp := LW[LI][LJ];
        LW[LI][LJ] := LW[LI][LBest];
        LW[LI][LBest] := LTmp;
      end;
      for LI := 0 to LN - 1 do
      begin
        LTmp := LV[LI][LJ];
        LV[LI][LJ] := LV[LI][LBest];
        LV[LI][LBest] := LTmp;
      end;
    end;
  end;
  LSMax := Result.S[0];
  Result.U := MatCreate(LM, LN);
  for LJ := 0 to LN - 1 do
  begin
    if Result.S[LJ] > LM * C_EPS * LSMax then
      for LI := 0 to LM - 1 do
        Result.U[LI][LJ] := LW[LI][LJ] / Result.S[LJ]
    else
    begin
      { zero singular value: an orthonormal completion from unit vectors }
      for LK := 0 to LM - 1 do
      begin
        for LI := 0 to LM - 1 do
          if LI = LK then
            Result.U[LI][LJ] := 1.0
          else
            Result.U[LI][LJ] := 0.0;
        for LP := 1 to 2 do
          for LQ := 0 to LJ - 1 do
          begin
            LDot := 0.0;
            for LI := 0 to LM - 1 do
              LDot := LDot + Result.U[LI][LQ] * Result.U[LI][LJ];
            for LI := 0 to LM - 1 do
              Result.U[LI][LJ] := Result.U[LI][LJ] - LDot * Result.U[LI][LQ];
          end;
        LNorm := 0.0;
        for LI := 0 to LM - 1 do
          LNorm := LNorm + Sqr(Result.U[LI][LJ]);
        LNorm := Sqrt(LNorm);
        if LNorm > 1.0e-6 then
        begin
          for LI := 0 to LM - 1 do
            Result.U[LI][LJ] := Result.U[LI][LJ] / LNorm;
          Break;
        end;
      end;
    end;
    if Result.U[0][LJ] > 0 then
    begin
      for LI := 0 to LM - 1 do
        Result.U[LI][LJ] := -Result.U[LI][LJ];
      for LI := 0 to LN - 1 do
        LV[LI][LJ] := -LV[LI][LJ];
    end;
  end;
  Result.V := LV;
end;

{ Ho-Kalman realisation (report Equations 1.11 to 1.15, realisation
  slides p. 1 and 2):
    H = U S V^T, O = U1 S1^(1/2), C_l = S1^(1/2) V1^T,
    A = O^+ H_up C_l^+ = S1^(-1/2) U1^T H_up V1 S1^(-1/2),
    B = first column of C_l, C = first row of O, D = g0.
  AOrder = 0 selects the order automatically: every sigma_i > ATol sigma_1. }
function HoKalman(const AData: TVector; ARows, ACols, AOrder: Integer; ATol: Double): THoKalman;
var
  LN, LI, LJ, LK: Integer;
  LU1, LV1, LSh, LSih: TMatrix;
  LResp: TResponse;
begin
  Result.Ok := False;
  Result.Reason := '';
  Result.Rows := ARows;
  Result.Cols := ACols;
  Result.Order := 0;
  Result.MaxStepError := 0.0;
  if Length(AData) < ARows + ACols + 1 then
  begin
    Result.Reason := 'Not enough step samples: a ' + IntToStr(ARows) + ' x ' + IntToStr(ACols) +
      ' Hankel matrix and its shifted copy need ' + IntToStr(ARows + ACols + 1) + ' samples.';
    Exit;
  end;
  Result.Data := Copy(AData);
  Result.G := MarkovFromStep(AData);
  Result.H := Hankel(Result.G, ARows, ACols, 0);
  Result.HUp := Hankel(Result.G, ARows, ACols, 1);
  Result.SVD := SVDJacobi(Result.H);
  if Result.SVD.S[0] <= 0.0 then
  begin
    Result.Reason := 'All Markov parameters are zero: the data hold no dynamics.';
    Exit;
  end;
  if AOrder <= 0 then
  begin
    LN := 0;
    for LI := 0 to High(Result.SVD.S) do
      if Result.SVD.S[LI] > ATol * Result.SVD.S[0] then
        Inc(LN);
  end
  else
    LN := AOrder;
  if LN > Length(Result.SVD.S) then
  begin
    Result.Reason := 'The order ' + IntToStr(LN) + ' is larger than the Hankel matrix allows (' +
      IntToStr(Length(Result.SVD.S)) + ').';
    Exit;
  end;
  if Result.SVD.S[LN - 1] <= LN * C_EPS * Result.SVD.S[0] then
  begin
    Result.Reason := 'sigma_' + IntToStr(LN) + ' is zero within rounding, so an order of ' +
      IntToStr(LN) + ' cannot be realised. Lower the order.';
    Exit;
  end;
  Result.Order := LN;
  LU1 := MatCreate(ARows, LN);
  LV1 := MatCreate(ACols, LN);
  LSh := MatCreate(LN, LN);
  LSih := MatCreate(LN, LN);
  for LJ := 0 to LN - 1 do
  begin
    for LI := 0 to ARows - 1 do
      LU1[LI][LJ] := Result.SVD.U[LI][LJ];
    for LI := 0 to ACols - 1 do
      LV1[LI][LJ] := Result.SVD.V[LI][LJ];
    LSh[LJ][LJ] := Sqrt(Result.SVD.S[LJ]);
    LSih[LJ][LJ] := 1.0 / Sqrt(Result.SVD.S[LJ]);
  end;
  Result.Obs := MatMul(LU1, LSh);
  Result.Ctr := MatMul(LSh, MatTranspose(LV1));
  Result.Model.A := MatMul(MatMul(MatMul(LSih, MatTranspose(LU1)), Result.HUp), MatMul(LV1, LSih));
  Result.Model.B := MatColumn(Result.Ctr, 0);
  Result.Model.C := MatRow(Result.Obs, 0);
  Result.Model.D := MatFromArray(1, 1, [Result.G[0]]);
  Result.Eig := Eigenvalues(Result.Model.A);
  LResp := Simulate(Result.Model, High(AData), 1.0, ikStep, 1.0);
  Result.ModelStep := LResp.Y;
  for LK := 0 to High(AData) do
    Result.MaxStepError := Max(Result.MaxStepError, Abs(LResp.Y[LK] - AData[LK]));
  Result.Ok := True;
end;

{ Every intermediate result of HoKalman as plain text (the .dat file of
  Problem 2). }
function HoKalmanText(const AR: THoKalman; const AHeader: string): string;
var
  LSb: TStringList;
  LK: Integer;

  procedure AddMatrix(const ATitle: string; const AM: TMatrix);
  begin
    LSb.Add(ATitle);
    LSb.Add(MatToText(AM, 15, 26));
    LSb.Add('');
  end;

begin
  LSb := TStringList.Create;
  try
    LSb.Add(AHeader);
    LSb.Add('');
    LSb.Add('# k   step S(k)   Markov g(k)   model step');
    for LK := 0 to High(AR.G) do
      if LK <= High(AR.ModelStep) then
        LSb.Add(IntToStr(LK) + '   ' + FmtG(AR.Data[LK], 15) + '   ' + FmtG(AR.G[LK], 15) + '   ' +
          FmtG(AR.ModelStep[LK], 15))
      else
        LSb.Add(IntToStr(LK) + '   ' + FmtG(AR.Data[LK], 15) + '   ' + FmtG(AR.G[LK], 15));
    LSb.Add('');
    AddMatrix('# Hankel matrix H (' + IntToStr(AR.Rows) + ' x ' + IntToStr(AR.Cols) + ')', AR.H);
    AddMatrix('# Shifted Hankel matrix H_up', AR.HUp);
    AddMatrix('# U', AR.SVD.U);
    LSb.Add('# Singular values sigma');
    for LK := 0 to High(AR.SVD.S) do
      LSb.Add(FmtG(AR.SVD.S[LK], 15));
    LSb.Add('');
    AddMatrix('# V', AR.SVD.V);
    if AR.Ok then
    begin
      LSb.Add('# Order n = ' + IntToStr(AR.Order) + ', Jacobi sweeps = ' + IntToStr(AR.SVD.Sweeps));
      LSb.Add('');
      AddMatrix('# Observability matrix O = U1 S1^(1/2)', AR.Obs);
      AddMatrix('# Controllability matrix C = S1^(1/2) V1^T', AR.Ctr);
      AddMatrix('# A', AR.Model.A);
      AddMatrix('# B', AR.Model.B);
      AddMatrix('# C', AR.Model.C);
      AddMatrix('# D', AR.Model.D);
      LSb.Add('# Eigenvalues of A');
      for LK := 0 to High(AR.Eig) do
        LSb.Add(ComplexToText(AR.Eig[LK], 15) + '   |z| = ' + FmtG(CAbs(AR.Eig[LK]), 15));
      LSb.Add('');
      LSb.Add('# max |model step - data| = ' + FmtG(AR.MaxStepError, 6));
    end
    else
      LSb.Add('# Realisation failed: ' + AR.Reason);
    Result := LSb.Text;
  finally
    LSb.Free;
  end;
end;

{ Problem 3: observer gain of a 2 x 2 plant (report Equations 2.5 to 2.8).
  det(lambda I - (A - K C)) = lambda^2 - (p1 + p2) lambda + p1 p2 gives two
  equations that are linear in K1 and K2 (the K1 K2 terms cancel):
    C1 K1 + C2 K2 = A11 + A22 - (p1 + p2) = alpha
    (C1 A22 - C2 A21) K1 + (A11 C2 - A12 C1) K2 = det A - p1 p2 = beta
  The determinant of this system equals -det [C; CA], so a solution exists
  exactly when the plant is observable. Cramer's rule gives K1 and K2. }
function ObserverGain2(const AA, AC: TMatrix; AP1, AP2: Double): TObserverGain;
var
  LA11, LA12, LA21, LA22, LC1, LC2, LM21, LM22, LScale: Double;
  LKC: TMatrix;
begin
  Result.Ok := False;
  Result.Reason := '';
  SetLength(Result.K, 2);
  Result.K[0] := 0.0;
  Result.K[1] := 0.0;
  if (MatRows(AA) <> 2) or (MatCols(AA) <> 2) or (MatRows(AC) <> 1) or (MatCols(AC) <> 2) then
  begin
    Result.Reason := 'The closed form needs a 2 x 2 matrix A and a 1 x 2 matrix C.';
    Exit;
  end;
  LA11 := AA[0][0];
  LA12 := AA[0][1];
  LA21 := AA[1][0];
  LA22 := AA[1][1];
  LC1 := AC[0][0];
  LC2 := AC[0][1];
  Result.EigPlant := Eigenvalues(AA);
  Result.Alpha := LA11 + LA22 - (AP1 + AP2);
  Result.Beta := (LA11 * LA22 - LA12 * LA21) - AP1 * AP2;
  LM21 := LC1 * LA22 - LC2 * LA21;
  LM22 := LA11 * LC2 - LA12 * LC1;
  Result.DetObs := LC1 * (LC1 * LA12 + LC2 * LA22) - LC2 * (LC1 * LA11 + LC2 * LA21);
  Result.DetM := LC1 * LM22 - LC2 * LM21;
  LScale := Max(1.0, MatNormInf(AA)) * Max(1.0e-300, Sqr(Abs(LC1) + Abs(LC2)));
  if Abs(Result.DetObs) <= 1.0e-12 * LScale then
  begin
    Result.Reason := 'The plant is not observable (det [C; CA] = ' + FmtG(Result.DetObs, 6) +
      '), so the observer poles cannot be placed.';
    Exit;
  end;
  Result.K[0] := (Result.Alpha * LM22 - LC2 * Result.Beta) / Result.DetM;
  Result.K[1] := (LC1 * Result.Beta - LM21 * Result.Alpha) / Result.DetM;
  LKC := MatMul(MatFromArray(2, 1, [Result.K[0], Result.K[1]]), AC);
  Result.EigError := Eigenvalues(MatSub(AA, LKC));
  Result.Ok := True;
end;

{ Plant, observer and open-loop model driven by the same input u(k) = AAmp
  (report Equations 1.17 and 1.18):
    x(k+1)    = A x(k) + B u(k),  y(k) = C x(k)
    xo(k+1)   = A xo(k) + B u(k) + K (y(k) - C xo(k))
    xm(k+1)   = A xm(k) + B u(k)
  The open-loop model starts from the same guess as the observer. }
function SimulateObserver(const AM: TStateModel; const AK: TVector; const AX0, AXHat0: TVector;
  AAmp: Double; ASteps: Integer): TObserverRun;
var
  LN, LK, LI, LJ: Integer;
  LX, LXo, LXm, LXn, LXon, LXmn: TVector;
  LY, LYo, LE1, LE2: Double;
begin
  Result := Default(TObserverRun);
  CheckModel(AM);
  LN := ModelOrder(AM);
  if (Length(AK) <> LN) or (Length(AX0) <> LN) or (Length(AXHat0) <> LN) then
    raise EMPCError.Create('Observer gain and initial states must have ' + IntToStr(LN) + ' entries.');
  if ASteps < 1 then
    raise EMPCError.Create('At least one sample is needed.');
  SetLength(Result.T, ASteps + 1);
  SetLength(Result.U, ASteps + 1);
  SetLength(Result.Y, ASteps + 1);
  SetLength(Result.ErrObs, ASteps + 1);
  SetLength(Result.ErrOpen, ASteps + 1);
  Result.X := MatCreate(ASteps + 1, LN);
  Result.XObs := MatCreate(ASteps + 1, LN);
  Result.XOpen := MatCreate(ASteps + 1, LN);
  LX := Copy(AX0);
  LXo := Copy(AXHat0);
  LXm := Copy(AXHat0);
  SetLength(LXn, LN);
  SetLength(LXon, LN);
  SetLength(LXmn, LN);
  for LK := 0 to ASteps do
  begin
    LY := 0.0;
    LYo := 0.0;
    LE1 := 0.0;
    LE2 := 0.0;
    for LI := 0 to LN - 1 do
    begin
      LY := LY + AM.C[0][LI] * LX[LI];
      LYo := LYo + AM.C[0][LI] * LXo[LI];
      Result.X[LK][LI] := LX[LI];
      Result.XObs[LK][LI] := LXo[LI];
      Result.XOpen[LK][LI] := LXm[LI];
      LE1 := LE1 + Sqr(LX[LI] - LXo[LI]);
      LE2 := LE2 + Sqr(LX[LI] - LXm[LI]);
    end;
    Result.T[LK] := LK;
    Result.U[LK] := AAmp;
    Result.Y[LK] := LY;
    Result.ErrObs[LK] := Sqrt(LE1);
    Result.ErrOpen[LK] := Sqrt(LE2);
    for LI := 0 to LN - 1 do
    begin
      LXn[LI] := AM.B[LI][0] * AAmp;
      LXon[LI] := AM.B[LI][0] * AAmp + AK[LI] * (LY - LYo);
      LXmn[LI] := AM.B[LI][0] * AAmp;
      for LJ := 0 to LN - 1 do
      begin
        LXn[LI] := LXn[LI] + AM.A[LI][LJ] * LX[LJ];
        LXon[LI] := LXon[LI] + AM.A[LI][LJ] * LXo[LJ];
        LXmn[LI] := LXmn[LI] + AM.A[LI][LJ] * LXm[LJ];
      end;
    end;
    for LI := 0 to LN - 1 do
    begin
      LX[LI] := LXn[LI];
      LXo[LI] := LXon[LI];
      LXm[LI] := LXmn[LI];
    end;
  end;
end;

end.
