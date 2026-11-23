unit Unit2;

{
  Unit2.pas - Equation sheet of the MPC experimental steps program
  (Biocybernetics Assignment 4).

  Author : Jeremia Christ Immanuel Manalu (5023231017)

  The sheet is a LaTeX-rendered PNG stored in Unit2.dfm (imgSheet), so it is
  visible in the Form Designer. It shows the bilinear discretisation, the
  discrete responses, the Ho-Kalman realisation with the one-sided Jacobi
  SVD and the observer gain; the equations used by the program are
  highlighted in yellow. Source: Resources/tex/sheet_equations.tex.

  Navigation (A3 ISS-071): the mouse wheel or a two-finger swipe on a
  touchpad scrolls (Shift + wheel: sideways), a left drag moves the sheet,
  Ctrl + wheel or a pinch on a touchpad zooms between 50 % and 250 %, and a
  double click returns to 100 %. A TScrollBox does not scroll with the wheel
  by itself, so the wheel is handled in MouseWheelHandler.
}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, System.Types,
  System.Math, System.UITypes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage;

type
  TFormEquations = class(TForm)
    sbxSheet: TScrollBox;
    imgSheet: TImage;
    pnlBottom: TPanel;
    lblHelp: TLabel;
    lblZoom: TLabel;
    btnClose: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure imgSheetMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
    procedure imgSheetMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure imgSheetMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
    procedure imgSheetDblClick(Sender: TObject);
  private
    FDragging: Boolean;
    FDragStart: TPoint;     { cursor position (screen) when the drag began }
    FScrollStart: TPoint;   { scroll bar positions when the drag began }
    FZoom: Double;
    FBaseWidth: Integer;    { size of the sheet at 100 % }
    FBaseHeight: Integer;
    procedure SetZoom(AZoom: Double);
  public
    procedure MouseWheelHandler(var Message: TMessage); override;
  end;

var
  FormEquations: TFormEquations;

implementation

{$R *.dfm}

const
  C_ZOOM_MIN = 0.5;
  C_ZOOM_MAX = 2.5;
  C_ZOOM_STEP = 1.1;

procedure TFormEquations.FormCreate(Sender: TObject);
begin
  FZoom := 1.0;
  FBaseWidth := imgSheet.Width;
  FBaseHeight := imgSheet.Height;
end;

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

{ Every wheel message of the window arrives here (VCL routes the wheel of
  any child control through the form). }
procedure TFormEquations.MouseWheelHandler(var Message: TMessage);
var
  LDelta: SmallInt;
  LKeys: Word;
begin
  LDelta := SmallInt(HiWord(Message.WParam));
  LKeys := LoWord(Message.WParam);
  if (LKeys and MK_CONTROL) <> 0 then
  begin
    if LDelta > 0 then
      SetZoom(FZoom * C_ZOOM_STEP)
    else if LDelta < 0 then
      SetZoom(FZoom / C_ZOOM_STEP);
  end
  else if (LKeys and MK_SHIFT) <> 0 then
    sbxSheet.HorzScrollBar.Position := sbxSheet.HorzScrollBar.Position - LDelta
  else
    sbxSheet.VertScrollBar.Position := sbxSheet.VertScrollBar.Position - LDelta;
  Message.Result := 1;
end;

{ Zoom around the centre of the visible part of the sheet. }
procedure TFormEquations.SetZoom(AZoom: Double);
var
  LCx, LCy: Double;
begin
  AZoom := EnsureRange(AZoom, C_ZOOM_MIN, C_ZOOM_MAX);
  if SameValue(AZoom, FZoom, 1.0e-6) then
    Exit;
  LCx := (sbxSheet.HorzScrollBar.Position + 0.5 * sbxSheet.ClientWidth) / Max(1, imgSheet.Width);
  LCy := (sbxSheet.VertScrollBar.Position + 0.5 * sbxSheet.ClientHeight) / Max(1, imgSheet.Height);
  FZoom := AZoom;
  imgSheet.AutoSize := False;
  imgSheet.Stretch := True;
  imgSheet.Width := Round(FBaseWidth * FZoom);
  imgSheet.Height := Round(FBaseHeight * FZoom);
  sbxSheet.HorzScrollBar.Position := Round(LCx * imgSheet.Width - 0.5 * sbxSheet.ClientWidth);
  sbxSheet.VertScrollBar.Position := Round(LCy * imgSheet.Height - 0.5 * sbxSheet.ClientHeight);
  lblZoom.Caption := 'Zoom ' + IntToStr(Round(100 * FZoom)) + ' %';
end;

{ Drag with the left button: the sheet follows the cursor. Screen
  coordinates are used because the image itself moves while scrolling. }
procedure TFormEquations.imgSheetMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button <> mbLeft then
    Exit;
  FDragging := True;
  FDragStart := Mouse.CursorPos;
  FScrollStart := Point(sbxSheet.HorzScrollBar.Position, sbxSheet.VertScrollBar.Position);
  imgSheet.Cursor := crSizeAll;
end;

procedure TFormEquations.imgSheetMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  LPos: TPoint;
begin
  if not FDragging then
    Exit;
  LPos := Mouse.CursorPos;
  sbxSheet.HorzScrollBar.Position := FScrollStart.X - (LPos.X - FDragStart.X);
  sbxSheet.VertScrollBar.Position := FScrollStart.Y - (LPos.Y - FDragStart.Y);
end;

procedure TFormEquations.imgSheetMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FDragging := False;
  imgSheet.Cursor := crHandPoint;
end;

procedure TFormEquations.imgSheetDblClick(Sender: TObject);
begin
  SetZoom(1.0);
end;

end.
