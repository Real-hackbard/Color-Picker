unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  ComCtrls, Vcl.Shell.ShellCtrls, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TTrackBar = class(ComCtrls.TTrackBar)
  private
    FOldWnd: HWnd;
    procedure WMSetFocus(var Msg: TWMSetFocus);
      message WM_SETFOCUS;
    procedure WMPaint(var Msg: TWMPaint);
      message WM_PAINT;
  end;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Panel2: TPanel;
    Panel1: TPanel;
    Edit1: TEdit;
    Panel3: TPanel;
    TrackBar1: TTrackBar;
    Image2: TImage;
    Label1: TLabel;
    procedure TrackBar1Change(Sender: TObject);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
{$R-}

procedure TTrackBar.WMSetFocus(var Msg: TWMSetFocus);
begin
  inherited; FOldWnd := Msg.FocusedWnd;
end;

procedure TTrackBar.WMPaint(var Msg: TWMPaint);
var
  DC: hDC; R: TRect;
begin
  inherited;
  if (GetFocus = self.Handle) and (FOldWnd <> self.Handle) then
    begin
      DC := GetWindowDC(self.Handle);
        if DC <> 0 then
          try
            R := Rect(0,0,self.Width,self.Height);
            DrawFocusRect(DC,R); FOldWnd := self.Handle;
          finally
            ReleaseDC(self.Handle,DC);
          end;
    end;
end;

function RGBCol(R,G,B:Byte):TColor;
Begin
  Result:=R+256*G+65536*B;
End;

function MixColor(Tc1,Tc2:TColor; Percent_0_240:Byte):TColor;
var
  R,G,B,R1,G1,B1,R2,G2,B2:byte;
  Tcr,Tcd: byte;
begin
  R1:=(Tc1 mod $000100);
  G1:=(Tc1 mod $010000) div $000100 ;
  B1:=(Tc1 div $010000);
  R2:=(Tc2 mod $000100);
  G2:=(Tc2 mod $010000) div $000100 ;
  B2:=(Tc2 div $010000);

   Tcd:=(percent_0_240*(R1-R2)) div 240;
    R:=R1-Tcd;

   Tcd:=(percent_0_240*(G1-G2)) div 240;
    G:=G1-Tcd;

   Tcd:=(percent_0_240*(B1-B2)) div 240;
    B:=B1-Tcd;

  Result:=RGBCol(R,G,B);
end;

function HsbToColor(Hue,Saturation,Brithness: Byte): TColor;
var
  Releasedc:TColor;
  R,G,B:Byte;
Begin
  Releasedc:=clWhite;
  If Hue<=40 then Releasedc:=RGBCol(255,round(Hue*(255/40)), 0);
  If (Hue>40)and(Hue<=80) Then Releasedc:=RGBCol(255-round((Hue-40)*(255/40)),255,0);
  If (Hue>80)and(Hue<=120) then Releasedc:=RGBCol(0,255,round((Hue-80)*(255/40)));
  If (Hue>120)and(Hue<=160) Then Releasedc:=RGBCol(0,255-round((Hue-120)*(255/40)),255);
  If (Hue>160)and(Hue<=200) then Releasedc:=RGBCol(round((Hue-160)*(255/40)),0,255);
  If (Hue>200) then Releasedc:=RGBCol(255,0,255-round((Hue-200)*(255/40)));

  If Brithness>120 then Releasedc:=MixColor(Releasedc,clwhite,(Brithness-120)*2)
  else Releasedc:=MixColor(ClBlack,Releasedc,Brithness*2);

  R:=(Releasedc mod $000100);
  G:=(Releasedc mod $010000) div $000100 ;
  B:=(Releasedc div $010000);

  Releasedc:=Mixcolor(RGBCol(((R+G+B)div 3),
                     ((R+G+B)div 3),
                     ((R+G+B)div 3)),
                     Releasedc,Saturation);

  Result:=Releasedc;
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
var
  i,j:integer;
begin
  Screen.Cursor := crHourGlass;
  For i:=0 to 240 do
    For j:=0 to 240 do
      Image1.Canvas.Pixels[i,j] := HsbToColor(TrackBar1.Position,i,240-j);

  Screen.Cursor := crDefault;
end;

procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Panel1.Color:=Image1.Canvas.Pixels[X,Y];
  Panel1.Caption:=ColorToString(Image1.Canvas.Pixels[X,Y]);
end;

procedure TForm1.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Panel1.Color:=Image1.Canvas.Pixels[X,Y];
  Panel1.Caption:=ColorToString(Image1.Canvas.Pixels[X,Y]);
  Edit1.Text:=ColorToString(Image1.Canvas.Pixels[X,Y]);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i,j:integer;
begin
  For I:=0 to 240 do
  For J:=0 to Image2.Width do
    Image2.Canvas.Pixels[j,i]:= HSBToColor(i,240,120);
    TrackBar1Change(Sender);
end;

end.
 