unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ComCtrls, Vcl.Shell.ShellCtrls, Vcl.ExtCtrls, Vcl.StdCtrls,
  System.Math;

type
  TForm1 = class(TForm)
    LabelZoom: TLabel;
    LabelApercu: TLabel;
    LabelR: TLabel;
    EditR: TEdit;
    LabelG: TLabel;
    EditG: TEdit;
    LabelB: TLabel;
    EditB: TEdit;
    LabelC: TLabel;
    EditC: TEdit;
    LabelDelphi: TLabel;
    EditDelphi: TEdit;
    LabelHTML: TLabel;
    EditHTML: TEdit;
    Timer1: TTimer;
    Panel1: TPanel;
    ImageZoom: TImage;
    Bevel1: TBevel;
    StatusBar1: TStatusBar;
    Bevel2: TBevel;
    CheckBox1: TCheckBox;
    Shape1: TShape;
    Label1: TLabel;
    Button1: TButton;
    Timer2: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Timer2Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Timer1Timer(Sender: TObject);
function GetZoomRect: TRect;
var
  x: Integer;
  y: Integer;
  w: Integer;
  h: Integer;
begin
  x := Max(Mouse.CursorPos.x - 10, 10);
  y := Max(Mouse.CursorPos.y - 10, 10);
  w := x + 20;
  h := y + 20;
  if (w > Screen.Width)
  then begin
    x := Screen.Width;
    w := Screen.Width;
  end;
  if (h > Screen.Height)
  then begin
    y := Screen.Height;
    h := Screen.Height;
  end;
  Result := Rect(x, y, w, h);
  StatusBar1.Panels[1].Text := IntToStr(x);
  StatusBar1.Panels[3].Text := IntToStr(y);
end;
var
  DC: HDC;
  Canvas: TCanvas;
  Couleur: TColor;
  Rouge: Byte;
  Vert: Byte;
  Bleu: Byte;
begin
  Timer1.Enabled := False;
  DC := GetDC(HWND_DESKTOP);
  Canvas := TCanvas.Create;
  Canvas.Handle := DC;
  ImageZoom.Canvas.CopyRect(ImageZoom.Canvas.ClipRect, Canvas, GetZoomRect);
  FreeAndNil(Canvas);
  ImageZoom.Canvas.Pen.Mode := pmNot;
  ImageZoom.Canvas.Rectangle(50, 50, 50, 50);
  Couleur := GetPixel(DC, Mouse.CursorPos.x, Mouse.CursorPos.y);
  ReleaseDC(HWND_DESKTOP, DC);
  Shape1.Brush.Color := Couleur;
  Rouge := Couleur and $000000FF;
  Vert := Couleur and $0000FF00 shr 8;
  Bleu := Couleur and $00FF0000 shr 16;
  EditR.Text := IntToStr(Rouge);
  EditG.Text := IntToStr(Vert);
  EditB.Text := IntToStr(Bleu);
  EditC.Text := Format('0x00%.2x%.2x%.2x', [Bleu, Vert, Rouge]);
  EditDelphi.Text := Format('$00%.2x%.2x%.2x', [Bleu, Vert, Rouge]);
  EditHTML.Text := Format('#%.2x%.2x%.2x', [Rouge, Vert, Bleu]);
  Timer1.Enabled := True;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (GetAsyncKeystate(VK_F1))<>0 then
  Timer1.Enabled := false;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
var
  i: byte;
  t: String;
begin
  for i := 0 to 254 do
        if boolean(GetasyncKeyState(i)) then
          begin
            if i = 112 then begin
            Timer1.Enabled := false;
            end;
            Button1.Enabled := true;
            Label1.Caption := 'Press F1 to start Picker';
            Button1.Caption := 'Start Pick Up';
            StatusBar1.Panels[5].Text := 'Picker is not Active..';
        end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Timer1.Enabled := true;
  Label1.Caption := 'Press F1 to stop Picker';
  Button1.Enabled := false;
  StatusBar1.Panels[5].Text := 'Picker is Active..';
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked = true then begin
  Form1.FormStyle := fsStayOnTop;
  end else begin
  Form1.FormStyle := fsNormal;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;
  StatusBar1.Panels[5].Text := 'Picker is Active..';
end;

end.
