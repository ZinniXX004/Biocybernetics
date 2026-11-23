program Project1;

{ MPC Experimental Steps - Biocybernetics Assignment 4
  Jeremia Christ Immanuel Manalu (5023231017) }

uses
  Vcl.Forms,
  MPCModel in 'MPCModel.pas',
  Unit1 in 'Unit1.pas' {Form1},
  Unit2 in 'Unit2.pas' {FormEquations};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'MPC Experimental Steps';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFormEquations, FormEquations);
  Application.Run;
end.
