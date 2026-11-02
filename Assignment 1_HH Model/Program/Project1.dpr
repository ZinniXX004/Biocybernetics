program Project1;

{ Hodgkin-Huxley Neuron Model Simulator - Biocybernetics Assignment 1
  Jeremia Christ Immanuel Manalu (5023231017) }

{$R 'Equations.res' 'Equations.rc'}

uses
  Vcl.Forms,
  HHModel in 'HHModel.pas',
  EquationViewer in 'EquationViewer.pas',
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Hodgkin-Huxley Neuron Model Simulator';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
