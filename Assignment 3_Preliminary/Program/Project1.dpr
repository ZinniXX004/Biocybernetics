program Project1;

{ Ziegler-Nichols PID Parameter Determination - Biocybernetics Assignment 3
  Jeremia Christ Immanuel Manalu (5023231017) }

uses
  Vcl.Forms,
  ZNModel in 'ZNModel.pas',
  Unit1 in 'Unit1.pas' {Form1},
  Unit2 in 'Unit2.pas' {FormEquations};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Ziegler-Nichols PID Tuning';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFormEquations, FormEquations);
  Application.Run;
end.
