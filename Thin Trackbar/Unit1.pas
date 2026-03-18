unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ComCtrls, Vcl.Shell.ShellCtrls, ThinTrackBar, Registry, Vcl.ExtCtrls,
  Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    MagPnl: TPanel;
    TrackR: TThinTrackBar;
    TrackG: TThinTrackBar;
    TrackB: TThinTrackBar;
    EditR: TEdit;
    UpDownR: TUpDown;
    EditG: TEdit;
    UpDownG: TUpDown;
    EditB: TEdit;
    UpDownB: TUpDown;
    PFSBtn: TButton;
    PickTmr: TTimer;
    OptBtn: TButton;
    MagBox: TPaintBox;
    DecOutLbl: TLabel;
    PanelR: TPanel;
    RedBox: TPaintBox;
    PanelG: TPanel;
    GreenBox: TPaintBox;
    PanelB: TPanel;
    BlueBox: TPaintBox;
    ColourBvl: TPanel;
    ColourPnl: TPaintBox;
    SolidColPnl: TPaintBox;
    HexOutEdit: TEdit;
    HexOutLbl: TLabel;
    DecOutEdit: TEdit;
    ColourPnlSplitter: TBevel;
    StatusBar1: TStatusBar;
    procedure TrackChange(Sender: TObject);
    procedure PFSBtnClick(Sender: TObject);
    procedure PickTmrTimer(Sender: TObject);
    procedure OptBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MagBoxPaint(Sender: TObject);
    procedure SolidColPnlDblClick(Sender: TObject);
    procedure ColEditChange(Sender: TObject);
    procedure OutBoxPaint(Sender: TObject);
    procedure ColourPnlPaint(Sender: TObject);
    procedure SolidColPnlPaint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    SampleMethod, NewMethod: byte;
    MemPix: TBitmap;
    BoxBuf: TBitmap;
    ScreenDC: HDC;
    procedure WMLButtonDown(var Msg: TMessage); message WM_LBUTTONDOWN;
    procedure WMRButtonDown(var Msg: TMessage); message WM_RBUTTONDOWN;
    procedure AppDeactivate(Sender: TObject);
    procedure DrawGrad(BoxNum: integer);
  end;

var
  Form1: TForm1;

implementation

uses Unit2;

{$R *.DFM}

procedure TForm1.WMLButtonDown(var Msg: TMessage);
begin
  inherited;
  if not PFSBtn.Enabled then begin
    ReleaseCapture;
    PFSBtn.Enabled := true;
    Caption := 'RGB Color Picker 1.0';
    PostMessage(Form1.Handle, WM_ACTIVATE, word(true), 0);
  end;
end;

procedure TForm1.WMRButtonDown(var Msg: TMessage);
begin
  inherited;
  WMLButtonDown(Msg);
end;

procedure TForm1.DrawGrad(BoxNum: integer);
var
  R, G, B: byte;
begin
  case BoxNum of
    1:
      begin
        G := TrackG.Position;
        B := TrackB.Position;

        with BoxBuf.Canvas do
        begin
          for R := 0 to 127 do
            Pixels[R, 0] := B shl 16 or G shl 8 or R shl 1;
          StretchBlt(RedBox.Canvas.Handle,
            0, 0, 128, RedBox.Height,
            Handle,
            0, 0,
            128, 1,
            SRCCOPY);
        end; // with BoxBuf.Canvas
      end; // case 1

    2:
      begin
        R := TrackR.Position;
        B := TrackB.Position;

        with BoxBuf.Canvas do
        begin
          for G := 0 to 127 do
            Pixels[G, 0] := B shl 16 or G shl 9 or R;
          StretchBlt(GreenBox.Canvas.Handle,
            0, 0, 128, RedBox.Height,
            Handle,
            0, 0,
            128, 1,
            SRCCOPY);
        end; // with BoxBuf.Canvas
      end; // case 2

    3:
      begin
        R := TrackR.Position;
        G := TrackG.Position;

        with BoxBuf.Canvas do
        begin
          for B := 0 to 127 do
            Pixels[B, 0] := B shl 17 or G shl 8 or R;
          StretchBlt(BlueBox.Canvas.Handle,
            0, 0, 128, RedBox.Height,
            Handle,
            0, 0,
            128, 1,
            SRCCOPY);
        end; // with BoxBuf.Canvas
      end; // case 3
  end; // case BoxNum of...
end;

procedure TForm1.TrackChange(Sender: TObject);
var
  TempCol: cardinal;
  TheSender: TThinTrackBar;
  i: integer;
begin
  with ColourPnl.Canvas do
  begin
    Brush.Color := RGB(TrackR.Position, TrackG.Position, TrackB.Position);
    FillRect(rect(0, 0, ColourPnl.Width, ColourPnl.Height));
  end;

  with SolidColPnl.Canvas do
  begin
    Brush.Color := GetNearestColor(ScreenDC, ColourPnl.Canvas.Brush.Color);
    FillRect(rect(0, 0, SolidColPnl.Width, SolidColPnl.Height));
  end;

  TheSender := TThinTrackBar(Sender);

  for i := 1 to 3 do
    if TheSender.Tag <> i then DrawGrad(i);

  case TheSender.Tag of
    1: UpDownR.Position := TrackR.Position;
    2: UpDownG.Position := TrackG.Position;
    3: UpDownB.Position := TrackB.Position;
  end; // case Tag of

  // Swap blue and red bytes for normal HTML output
  TempCol := RGB(TrackB.Position, TrackG.Position, TrackR.Position);
  HexOutEdit.Text := '#' + inttohex(TempCol, 6);

  TempCol := RGB(TrackR.Position, TrackG.Position, TrackB.Position);
  DecOutEdit.Text := inttostr(TempCol);
end;

procedure TForm1.PFSBtnClick(Sender: TObject);
var
  MethodStr: string;
begin
  SetCapture(Form1.Handle);
  PFSBtn.Enabled := false;
  case NewMethod of
    0: MethodStr := 'Single Pixel...';
    1: MethodStr := '3x3 Average...';
    2: MethodStr := '5x5 Average...';
    else MethodStr := '...';
  end;
  //StatusBar1.SimpleText := 'Pick From Single : ' + MethodStr;
end;

procedure TForm1.PickTmrTimer(Sender: TObject);
var
  CursorPos: TPoint;
  PixelCol: TColor;
  AverageR, AverageG, AverageB: Cardinal;
  x, y: shortint;
begin
  GetCursorPos(CursorPos);
  StatusBar1.SimpleText := 'Cursor Position X/Y : ' +Format('%d,' + ' %d', [CursorPos.x, CursorPos.y]);

  PixelCol := 0;
  case SampleMethod of
    0: begin
         PixelCol := GetPixel(ScreenDC, CursorPos.x, CursorPos.y);
         MagPnl.Color := PixelCol;
         MemPix.Canvas.Pixels[0, 0] := PixelCol;
       end;
    1:
      begin
        AverageR := 0;
        AverageG := 0;
        Averageb := 0;
        for y := -1 to 1 do
          for x := -1 to 1 do begin
            PixelCol := GetPixel(ScreenDC, CursorPos.x + x, CursorPos.y + y);
            AverageR := AverageR + GetRValue(PixelCol);
            AverageG := AverageG + GetGValue(PixelCol);
            AverageB := AverageB + GetBValue(PixelCol);
          end;
        AverageR := AverageR div 9;
        AverageG := AverageG div 9;
        AverageB := AverageB div 9;

        PixelCol := RGB(Lo(AverageR), Lo(AverageG), Lo(AverageB));

        BitBlt(MemPix.Canvas.Handle,
          0, 0,
          3, 3,
          ScreenDC,
          CursorPos.x - 1, CursorPos.y - 1,
          SRCCOPY);
        StretchBlt(MagBox.Canvas.Handle,
          0, 0,
          48, 48,
          MemPix.Canvas.Handle,
          0, 0,
          3, 3,
          SRCCOPY);
      end;
    2:
      begin
        AverageR := 0;
        AverageG := 0;
        Averageb := 0;
        for y := -2 to 2 do
          for x := -2 to 2 do begin
            PixelCol := GetPixel(ScreenDC, CursorPos.x + x, CursorPos.y + y);
            AverageR := AverageR + GetRValue(PixelCol);
            AverageG := AverageG + GetGValue(PixelCol);
            AverageB := AverageB + GetBValue(PixelCol);
          end;
        AverageR := AverageR div 25;
        AverageG := AverageG div 25;
        AverageB := AverageB div 25;

        PixelCol := RGB(Lo(AverageR), Lo(AverageG), Lo(AverageB));

        BitBlt(MemPix.Canvas.Handle,
          0, 0,
          5, 5,
          ScreenDC,
          CursorPos.x - 2, CursorPos.y - 2,
          SRCCOPY);
        StretchBlt(MagBox.Canvas.Handle,
          0, 0,
          48, 48,
          MemPix.Canvas.Handle,
          0, 0,
          5, 5,
          SRCCOPY);
      end;
  end;

  if not PFSBtn.Enabled then
  begin
    TrackR.Position := GetRValue(PixelCol);
    TrackG.Position := GetGValue(PixelCol);
    TrackB.Position := GetBValue(PixelCol);
  end;
end;

procedure TForm1.OptBtnClick(Sender: TObject);
var
  RegData: TRegistry;
begin
  OptForm.ShowModal;
  if OptForm.ModalResult = mrOk then
  begin
    NewMethod := OptForm.MethodGrp.ItemIndex;
    RegData := TRegistry.Create;
    with RegData do begin
      OpenKey('Software\RGB Colour Picker', false);
      WriteInteger('Method', NewMethod);
      CloseKey;
    end;

    case NewMethod of
      0: MemPix.Width := 1;
      1: MemPix.Width := 3;
      2: MemPix.Width := 5;
    end;
    MemPix.Height := MemPix.Width;

    SampleMethod := NewMethod;
  end; // if ModalResult = mrOk
end;

procedure TForm1.AppDeactivate(Sender: TObject);
begin
  if not PFSBtn.Enabled then SetCapture(Form1.Handle);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  RegData: TRegistry;
begin
  Application.OnDeactivate := AppDeactivate;

  ScreenDC := GetDC(0);

  MemPix := TBitmap.Create;
  RegData := Tregistry.Create;
  with RegData do begin
    OpenKey('Software\RGB Colour Picker', true);
    try
      NewMethod := ReadInteger('Method');
    except
      on ERegistryException do begin
        WriteInteger('Method', 0);
        NewMethod := 0;
      end;
    end;
    CloseKey;
  end;

  case NewMethod of
    0: MemPix.Width := 1;
    1: MemPix.Width := 3;
    2: MemPix.Width := 5;
  end;
  MemPix.Height := MemPix.Width;
  MemPix.Canvas.Pixels[0, 0] := clBlack;

  SampleMethod := NewMethod;

  BoxBuf := TBitmap.Create;
  BoxBuf.Width := 128;
  BoxBuf.Height := 1;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ReleaseDC(0, ScreenDC);
  MemPix.Free;
  BoxBuf.Free;
end;

procedure TForm1.MagBoxPaint(Sender: TObject);
begin
  case SampleMethod of
    0: StretchBlt(MagBox.Canvas.Handle,
         0, 0,
         48, 48,
         MemPix.Canvas.Handle,
         0, 0,
         1, 1,
         SRCCOPY);
    1: StretchBlt(MagBox.Canvas.Handle,
         0, 0,
         48, 48,
         MemPix.Canvas.Handle,
         0, 0,
         3, 3,
         SRCCOPY);
    2: StretchBlt(MagBox.Canvas.Handle,
         0, 0,
         48, 48,
         MemPix.Canvas.Handle,
         0, 0,
         5, 5,
         SRCCOPY);
  end;
end;

procedure TForm1.SolidColPnlDblClick(Sender: TObject);
var
  SolidCol: TColor;
begin
  SolidCol := GetNearestColor(GetDC(0), ColourPnl.Canvas.Brush.Color);
  TrackR.Position := GetRValue(SolidCol);
  TrackG.Position := GetGValue(SolidCol);
  TrackB.Position := GetBvalue(SolidCol);
end;

procedure TForm1.ColEditChange(Sender: TObject);
begin
  case (Sender as TEdit).Tag of
    0: TrackR.Position := UpDownR.Position;
    1: TrackG.Position := UpDownG.Position;
    2: TrackB.Position := UpDownB.Position;
  end;
end;

procedure TForm1.OutBoxPaint(Sender: TObject);
begin
  DrawGrad(TPaintbox(Sender).Tag);
end;

procedure TForm1.ColourPnlPaint(Sender: TObject);
begin
  with ColourPnl.Canvas do
  begin
    Brush.Color := RGB(TrackR.Position, TrackG.Position, TrackB.Position);
    FillRect(rect(0, 0, ColourPnl.Width, ColourPnl.Height));
  end;
end;

procedure TForm1.SolidColPnlPaint(Sender: TObject);
begin
  with SolidColPnl.Canvas do
  begin
    Brush.Color := GetNearestColor(ScreenDC, ColourPnl.Canvas.Brush.Color);
    FillRect(rect(0, 0, SolidColPnl.Width, SolidColPnl.Height));
  end;
end;

end.
