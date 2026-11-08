program Project1;

{ Spherical Pendulum Simulator (Lagrange and Hamilton) - Biocybernetics Assignment 2
  Jeremia Christ Immanuel Manalu (5023231017) }

uses
  Vcl.Forms,
  PendulumModel in 'PendulumModel.pas',
  Unit1 in 'Unit1.pas' {Form1},
  Unit2 in 'Unit2.pas' {FormEquations};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Spherical Pendulum Simulator';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFormEquations, FormEquations);
  Application.Run;
end.
