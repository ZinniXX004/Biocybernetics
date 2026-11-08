unit Unit2;

{
  Unit2.pas - Equation sheet of the spherical pendulum simulator
  (Biocybernetics Assignment 2).

  Author : Jeremia Christ Immanuel Manalu (5023231017)

  The sheet is a LaTeX-rendered PNG stored in Unit2.dfm (imgSheet), so it is
  visible in the Form Designer. It shows the derivation of the equations of
  motion; the equations used by the program are highlighted in yellow.
}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage;

type
  TFormEquations = class(TForm)
    sbxSheet: TScrollBox;
    imgSheet: TImage;
    pnlBottom: TPanel;
    btnClose: TButton;
    procedure btnCloseClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  end;

var
  FormEquations: TFormEquations;

implementation

{$R *.dfm}

procedure TFormEquations.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormEquations.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Close;
    Key := 0;
  end;
end;

end.
