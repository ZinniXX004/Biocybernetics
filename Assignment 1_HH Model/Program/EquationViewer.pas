unit EquationViewer;

{
  EquationViewer.pas - Separate windows for the mathematical sheets.

  Course : Biocybernetics (EB234701), Class Q - Assignment 1
  Author : Jeremia Christ Immanuel Manalu (5023231017)

  Every mathematical principle used by the simulator (equivalent circuit,
  gating kinetics, RK4, cable equation, central/forward difference scheme
  and the analysis definitions) is rendered with LaTeX into a PNG sheet
  (Resources\sheetN_*.png, sources in Resources\tex) and linked into the
  executable as RCDATA (Equations.rc). The main form opens a sheet with
  ShowEquationSheet; this unit builds the window at run time, so no extra
  .dfm file is needed.

  Window rules
    - Caption: 'Jeremia Christ Immanuel Manalu - 5023231017 - <sheet title>'.
    - Not maximised: the client area is sized to the image and limited to
      90 % of the work area of the monitor that shows the main form; the
      image scrolls (scroll bars or mouse wheel) when it is larger.
    - Non-modal and owned by the main form (it stays above the main form,
      the main form stays usable). Opening a sheet that is already open
      brings that window to the front instead of creating a second one.
    - Esc or the red Close button closes the window.
    - Yellow boxes on a sheet mark the equations implemented in the program.
}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  System.Types, System.Math, System.UITypes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Dialogs, Vcl.Clipbrd,
  Vcl.Imaging.pngimage;

const
  SHEET_FIRST = 1;
  SHEET_LAST = 6;

{ Full title of sheet AIndex (1..6), used in the window caption }
function SheetTitle(AIndex: Integer): string;
{ Opens (or brings to the front) the window that shows sheet AIndex }
procedure ShowEquationSheet(AOwnerForm: TForm; AIndex: Integer);
{ Closes and frees every open sheet window (called by the main form) }
procedure CloseAllEquationSheets;

implementation

const
  C_AUTHOR_PREFIX = 'Jeremia Christ Immanuel Manalu - 5023231017 - ';

  C_SHEET_RES: array[SHEET_FIRST..SHEET_LAST] of string = (
    'SHEET1_PNG', 'SHEET2_PNG', 'SHEET3_PNG',
    'SHEET4_PNG', 'SHEET5_PNG', 'SHEET6_PNG');

  C_SHEET_TITLE: array[SHEET_FIRST..SHEET_LAST] of string = (
    'Hodgkin-Huxley Equivalent Circuit and Membrane Equations',
    'Gating Kinetics and Rate Constants',
    'Fourth-Order Runge-Kutta Integration of the HH Equations (APG)',
    'Cable Equation Derivation for Action Potential Propagation',
    'Central and Forward Difference Integration of the Cable PDE (Problem 2)',
    'Analysis Definitions: Spike, Inter-Pulse Interval, Refractory ' +
      'Threshold and Conduction Velocity');

  C_SHEET_FILE: array[SHEET_FIRST..SHEET_LAST] of string = (
    'Sheet1_Membrane.png', 'Sheet2_Gating.png', 'Sheet3_RK4.png',
    'Sheet4_Cable.png', 'Sheet5_FiniteDifference.png', 'Sheet6_Analysis.png');

  { flat button colours, identical to the palette of Unit1 (TColor = BGR) }
  C_FACE_SECONDARY = TColor($00E8E8E8);
  C_HOVER_SECONDARY = TColor($00D6D6D6);
  C_FACE_DANGER = TColor($002828C6);
  C_HOVER_DANGER = TColor($001F1FA3);
  C_TEXT = TColor($00333333);
  C_NOTE_BACK = TColor($00C8F5FF);     // pale yellow, same hue as the boxes

  C_BAR_HEIGHT = 40;
  C_IMAGE_MARGIN = 8;
  C_WORKAREA_FRACTION = 0.9;
  C_CASCADE_STEP = 28;
  C_WHEEL_LINES = 3;
  C_LINE_PIXELS = 20;

type
  TSheetForm = class(TForm)
  private
    FIndex: Integer;
    FPng: TPngImage;
    FBar: TPanel;
    FNote: TLabel;
    FBtnCopy: TPanel;
    FBtnSave: TPanel;
    FBtnClose: TPanel;
    FScroll: TScrollBox;
    FImage: TImage;
    function MakeButton(const ACaption, AHint: string; AWidth: Integer;
      ADanger: Boolean; AOnClick: TNotifyEvent): TPanel;
    procedure ButtonEnter(Sender: TObject);
    procedure ButtonLeave(Sender: TObject);
    procedure CopyClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure CloseClick(Sender: TObject);
    procedure SheetKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SheetClose(Sender: TObject; var Action: TCloseAction);
    procedure LoadSheet;
    procedure FitToContent(AOwnerForm: TForm; ACascade: Integer);
  public
    constructor CreateSheet(AOwnerForm: TForm; AIndex, ACascade: Integer);
    destructor Destroy; override;
    { every wheel message of this window: scroll the sheet }
    procedure MouseWheelHandler(var Message: TMessage); override;
  end;

var
  GSheets: array[SHEET_FIRST..SHEET_LAST] of TSheetForm;

function SheetTitle(AIndex: Integer): string;
begin
  if (AIndex < SHEET_FIRST) or (AIndex > SHEET_LAST) then
    raise EArgumentOutOfRangeException.CreateFmt('Sheet %d does not exist.',
      [AIndex]);
  Result := C_SHEET_TITLE[AIndex];
end;

function OpenSheetCount: Integer;
var
  LIdx: Integer;
begin
  Result := 0;
  for LIdx := SHEET_FIRST to SHEET_LAST do
    if GSheets[LIdx] <> nil then
      Inc(Result);
end;

procedure ShowEquationSheet(AOwnerForm: TForm; AIndex: Integer);
var
  LForm: TSheetForm;
begin
  if (AIndex < SHEET_FIRST) or (AIndex > SHEET_LAST) then
    raise EArgumentOutOfRangeException.CreateFmt('Sheet %d does not exist.',
      [AIndex]);
  if GSheets[AIndex] <> nil then
  begin
    // already open: restore it if minimised and bring it to the front
    if GSheets[AIndex].WindowState = wsMinimized then
      GSheets[AIndex].WindowState := wsNormal;
    GSheets[AIndex].Show;
    GSheets[AIndex].BringToFront;
    Exit;
  end;
  LForm := TSheetForm.CreateSheet(AOwnerForm, AIndex, OpenSheetCount);
  GSheets[AIndex] := LForm;
  LForm.Show;
end;

procedure CloseAllEquationSheets;
var
  LIdx: Integer;
begin
  for LIdx := SHEET_FIRST to SHEET_LAST do
    if GSheets[LIdx] <> nil then
      GSheets[LIdx].Free;   // the destructor clears GSheets[LIdx]
end;

{ TSheetForm }

constructor TSheetForm.CreateSheet(AOwnerForm: TForm; AIndex, ACascade: Integer);
begin
  // CreateNew: a form without a .dfm resource
  inherited CreateNew(Application);
  FIndex := AIndex;
  FPng := TPngImage.Create;
  Caption := C_AUTHOR_PREFIX + C_SHEET_TITLE[AIndex];
  BorderStyle := bsSizeable;
  BorderIcons := [biSystemMenu, biMinimize, biMaximize];
  Position := poDesigned;
  Color := clWhite;
  Font.Name := 'Segoe UI';
  Font.Size := 9;
  KeyPreview := True;
  ShowHint := True;
  // owned by the main form: stays above it, no extra task-bar button
  PopupMode := pmExplicit;
  PopupParent := AOwnerForm;
  OnKeyDown := SheetKeyDown;
  OnClose := SheetClose;

  // top bar: note (left) and Copy / Save / Close buttons (right)
  FBar := TPanel.Create(Self);
  FBar.Parent := Self;
  FBar.Align := alTop;
  FBar.Height := C_BAR_HEIGHT;
  FBar.BevelOuter := bvNone;
  FBar.ParentBackground := False;
  FBar.Color := C_NOTE_BACK;
  FBtnClose := MakeButton('Close', 'Close this sheet (Esc)', 80, True, CloseClick);
  FBtnSave := MakeButton('Save PNG...', 'Save this sheet as a PNG image', 100,
    False, SaveClick);
  FBtnCopy := MakeButton('Copy image', 'Copy this sheet to the clipboard', 100,
    False, CopyClick);
  FNote := TLabel.Create(Self);
  FNote.Parent := FBar;
  FNote.Align := alClient;
  FNote.AlignWithMargins := True;
  FNote.Margins.Left := 10;
  FNote.Layout := tlCenter;
  FNote.AutoSize := False;
  FNote.EllipsisPosition := epEndEllipsis;
  FNote.Font.Color := C_TEXT;
  FNote.Caption := Format('Sheet %d of %d.  Yellow boxes = equations ' +
    'implemented in the program.  Wheel: scroll, Esc: close.',
    [AIndex, SHEET_LAST]);

  // scrollable image
  FScroll := TScrollBox.Create(Self);
  FScroll.Parent := Self;
  FScroll.Align := alClient;
  FScroll.BorderStyle := bsNone;
  FScroll.Color := clWhite;
  FScroll.ParentColor := False;
  FScroll.VertScrollBar.Tracking := True;
  FScroll.HorzScrollBar.Tracking := True;
  FImage := TImage.Create(Self);
  FImage.Parent := FScroll;
  FImage.Left := C_IMAGE_MARGIN;
  FImage.Top := C_IMAGE_MARGIN;
  FImage.AutoSize := True;

  LoadSheet;
  FitToContent(AOwnerForm, ACascade);
end;

destructor TSheetForm.Destroy;
begin
  if (FIndex >= SHEET_FIRST) and (FIndex <= SHEET_LAST) and
     (GSheets[FIndex] = Self) then
    GSheets[FIndex] := nil;
  FPng.Free;
  inherited Destroy;
end;

function TSheetForm.MakeButton(const ACaption, AHint: string; AWidth: Integer;
  ADanger: Boolean; AOnClick: TNotifyEvent): TPanel;
begin
  // flat TPanel button, same look as the buttons of the main form; created
  // right to left because every button is aligned alRight
  Result := TPanel.Create(Self);
  Result.Parent := FBar;
  Result.Align := alRight;
  Result.AlignWithMargins := True;
  Result.Margins.Left := 4;
  Result.Margins.Top := 6;
  Result.Margins.Right := 4;
  Result.Margins.Bottom := 6;
  Result.Width := AWidth;
  Result.BevelOuter := bvNone;
  Result.ParentBackground := False;
  Result.Caption := ACaption;
  Result.Hint := AHint;
  Result.Cursor := crHandPoint;
  Result.Font.Name := 'Segoe UI';
  Result.Font.Size := 9;
  if ADanger then
  begin
    Result.Tag := 1;
    Result.Color := C_FACE_DANGER;
    Result.Font.Color := clWhite;
    Result.Font.Style := [fsBold];
  end
  else
  begin
    Result.Tag := 0;
    Result.Color := C_FACE_SECONDARY;
    Result.Font.Color := C_TEXT;
    Result.Font.Style := [];
  end;
  Result.OnClick := AOnClick;
  Result.OnMouseEnter := ButtonEnter;
  Result.OnMouseLeave := ButtonLeave;
end;

procedure TSheetForm.ButtonEnter(Sender: TObject);
begin
  if not (Sender is TPanel) then
    Exit;
  if TPanel(Sender).Tag = 1 then
    TPanel(Sender).Color := C_HOVER_DANGER
  else
    TPanel(Sender).Color := C_HOVER_SECONDARY;
end;

procedure TSheetForm.ButtonLeave(Sender: TObject);
begin
  if not (Sender is TPanel) then
    Exit;
  if TPanel(Sender).Tag = 1 then
    TPanel(Sender).Color := C_FACE_DANGER
  else
    TPanel(Sender).Color := C_FACE_SECONDARY;
end;

procedure TSheetForm.LoadSheet;
var
  LStream: TResourceStream;
  LName: string;
begin
  LName := C_SHEET_RES[FIndex];
  if FindResource(HInstance, PChar(LName), RT_RCDATA) = 0 then
  begin
    FNote.Caption := Format('Resource %s is not linked. Rebuild the project ' +
      '(Equations.rc must contain the sheet PNG files).', [LName]);
    FImage.Visible := False;
    Exit;
  end;
  LStream := TResourceStream.Create(HInstance, LName, RT_RCDATA);
  try
    FPng.LoadFromStream(LStream);
  finally
    LStream.Free;
  end;
  FImage.Picture.Assign(FPng);
end;

procedure TSheetForm.FitToContent(AOwnerForm: TForm; ACascade: Integer);
var
  LWork: TRect;
  LMaxW, LMaxH, LFrameW, LFrameH, LWantW, LWantH: Integer;
begin
  if AOwnerForm <> nil then
    LWork := Screen.MonitorFromWindow(AOwnerForm.Handle).WorkareaRect
  else
    LWork := Screen.WorkAreaRect;
  // client area wanted: image + margins + vertical scroll bar + top bar
  LWantW := FImage.Width + 2 * C_IMAGE_MARGIN + GetSystemMetrics(SM_CXVSCROLL);
  LWantH := FImage.Height + 2 * C_IMAGE_MARGIN + C_BAR_HEIGHT;
  if not FImage.Visible then
  begin
    LWantW := 640;
    LWantH := C_BAR_HEIGHT + 80;
  end;
  ClientWidth := LWantW;
  ClientHeight := LWantH;
  // never larger than 90 % of the work area (frame included)
  LFrameW := Width - ClientWidth;
  LFrameH := Height - ClientHeight;
  LMaxW := Round(LWork.Width * C_WORKAREA_FRACTION);
  LMaxH := Round(LWork.Height * C_WORKAREA_FRACTION);
  Width := Min(LWantW + LFrameW, LMaxW);
  Height := Min(LWantH + LFrameH, LMaxH);
  // right-hand side of the work area, cascaded for every further sheet
  Left := Max(LWork.Left, LWork.Right - Width - 16 - ACascade * C_CASCADE_STEP);
  Top := Min(LWork.Top + 16 + ACascade * C_CASCADE_STEP,
    Max(LWork.Top, LWork.Bottom - Height));
end;

procedure TSheetForm.CopyClick(Sender: TObject);
var
  LBitmap: TBitmap;
begin
  if not FImage.Visible then
    Exit;
  LBitmap := TBitmap.Create;
  try
    LBitmap.Assign(FPng);
    Clipboard.Assign(LBitmap);
  finally
    LBitmap.Free;
  end;
end;

procedure TSheetForm.SaveClick(Sender: TObject);
var
  LDialog: TSaveDialog;
begin
  if not FImage.Visible then
    Exit;
  LDialog := TSaveDialog.Create(Self);
  try
    LDialog.DefaultExt := 'png';
    LDialog.Filter := 'PNG images (*.png)|*.png';
    LDialog.Options := [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing];
    LDialog.FileName := C_SHEET_FILE[FIndex];
    if LDialog.Execute then
      FPng.SaveToFile(LDialog.FileName);
  finally
    LDialog.Free;
  end;
end;

procedure TSheetForm.CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TSheetForm.SheetKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    Close;
  end;
end;

procedure TSheetForm.MouseWheelHandler(var Message: TMessage);
var
  LDelta, LStep: Integer;
begin
  // TScrollBox does not scroll with the wheel by itself, and the focused
  // control may be any child, so the form handles every wheel message.
  // One notch (WHEEL_DELTA = 120) scrolls C_WHEEL_LINES text lines;
  // Shift + wheel scrolls horizontally.
  LDelta := SmallInt(HiWord(Message.WParam));
  LStep := Round(LDelta / WHEEL_DELTA * C_WHEEL_LINES * C_LINE_PIXELS);
  if (LoWord(Message.WParam) and MK_SHIFT) <> 0 then
    FScroll.HorzScrollBar.Position := FScroll.HorzScrollBar.Position - LStep
  else
    FScroll.VertScrollBar.Position := FScroll.VertScrollBar.Position - LStep;
  Message.Result := 1;
end;

procedure TSheetForm.SheetClose(Sender: TObject; var Action: TCloseAction);
begin
  // free the window; the destructor removes it from GSheets
  Action := caFree;
end;

end.
