unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ComCtrls, Vcl.Shell.ShellCtrls, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    lRouge: TLabel;
    lVert: TLabel;
    lBleu: TLabel;
    CheckBox1: TCheckBox;
    Label1: TLabel;
    Bevel3: TBevel;
    Label2: TLabel;
    Label3: TLabel;
    Shape1: TShape;
    Bevel2: TBevel;
    Bevel4: TBevel;
    Image1: TImage;
    Curseur1D: TImage;
    Curseur1B: TImage;
    Curseur1G: TImage;
    Curseur1H: TImage;
    Viseur: TImage;
    Image2: TImage;
    Curseur2D: TImage;
    Curseur2G: TImage;
    Label4: TLabel;
    Label5: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
    Image:TBitMap;
    Bande:TBitMap;
  public
    { Public declarations }
    Procedure MAJBande(Couleur:TColor);
    Procedure MAJPanneau;
  end;
var
  Form1: TForm1;

implementation

{$R *.dfm}
procedure TForm1.FormCreate(Sender: TObject);
Const
  Points:Array[0..6]Of Array[1..3]Of Integer=
      (($00,$00,$FF),($00,$FF,$FF),($00,$FF,$00),($FF,$FF,$00),
       ($FF,$00,$00),($FF,$00,$FF),($00,$00,$FF));
Var P : Pointer;
begin
  Image := TBitMap.Create;
  Image.Width       := 64*6;
  Image.Height      := 256+1;
  Image.PixelFormat := pf32Bit;
  P                 := Image.ScanLine[0];
  Asm
    PUSH EBX
    PUSH EDI
    PUSH ESI
    MOV  EDI,P
    XOR  ESI,ESI
@LD:  PUSH EDI
      PUSH ESI
@L2:    XOR  ECX,ECX
@L1:      
          MOV  EBX,DWord ptr Points[ESI+12]
          SUB  EBX,DWord ptr Points[ESI]
          IMUL EBX,ECX
          SHR  EBX,6
          ADD  EBX,DWord ptr Points[ESI]
          PUSH EDI
          XOR  EDX,EDX
@LA:        
            MOV  EAX,128
            SUB  EAX,EBX
            IMUL EAX,EDX
            SHR  EAX,8
            ADD  EAX,EBX
            MOV  BYTE PTR [EDI],AL
            SUB  EDI,64*6*4
            INC  EDX
            CMP  EDX,256
            JBE  @LA
          POP  EDI
          ADD  EDI,4
          INC  ECX
          CMP  ECX,64
          JB   @L1
        ADD  ESI,12
        CMP  ESI,72
        JB   @L2
      POP  ESI
      POP  EDI
      INC  EDI
      ADD  ESI,4
      CMP  ESI,12
      JB   @LD
    POP  ESI
    POP  EDI
    POP  EBX
  End;
  Image1.Picture.Assign(Image);
  Bande := TBitMap.Create;
  Bande.Width       := 16;
  Bande.Height      := 256+1;
  Bande.PixelFormat := pf32Bit;
  Image1MouseMove(Nil,[ssLeft],128,128);
  Image2MouseMove(Nil,[ssLeft],0  ,128);
  CheckBox1Click(Nil);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Image.Free;
  Bande.Free;
end;

procedure TForm1.MAJBande(Couleur: TColor);
Var
  P : Pointer;
begin
  P := Bande.ScanLine[0];
  Asm
    PUSH EBX
    PUSH EDI
    PUSH ESI
    MOV  EDI,P
    MOV  EDX,3
@L2:  PUSH EDI
      XOR  ECX,ECX
@L1:    XOR  EAX,EAX
        MOV  AL,Byte Ptr Couleur+2
        SUB  EAX,255
        IMUL EAX,ECX
        SHR  EAX,7
        ADD  EAX,255
        XOR  EBX,EBX
        MOV  BL,Byte Ptr Couleur+2
        NEG  EBX
        IMUL EBX,ECX
        SHR  EBX,7
        ADD  BL,Byte Ptr Couleur+2
        MOV  ESI,16
@LL:    DEC  ESI
        MOV  BYTE PTR [EDI+ESI*4],AL
        MOV  BYTE PTR [EDI+ESI*4-128*16*4],BL
        JNZ  @LL
        SUB  EDI,16*4
        INC  ECX
        CMP  ECX,128
        JBE  @L1
      POP  EDI
      INC  EDI
      SHL  COULEUR,8
      DEC  EDX
      JNZ  @L2
    POP  ESI
    POP  EDI
    POP  EBX
  End;
  Image2.Picture.Assign(Bande);
  MAJPanneau;
end;

procedure TForm1.MAJPanneau;
Var Couleur:TColor;
begin
  Couleur      := Image2.Canvas.Pixels[0,Curseur2D.Top - Image2.Top + Curseur2D.Height Div 2];
  Shape1.Brush.Color := Couleur;
  lRouge.Caption := IntToStr((Couleur And $0000FF)      );
  lVert .Caption := IntToStr((Couleur And $00FF00)Shr 8 );
  lBleu .Caption := IntToStr((Couleur And $FF0000)Shr 16);
end;

procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  If   (ssLeft In Shift) Then
  Begin
    If X<0 Then X:=0;
    If X>=Image1.Width Then X:=Image1.Width-1;
    If Y<0 Then Y:=0;
    If Y>=Image1.Height Then Y:=Image1.Height-1;
    MAJBande(Image1.Canvas.Pixels[x,y]);
    Curseur1D.Top  := Image1.Top  - Curseur1D.Height Div 2 +Y;
    Curseur1G.Top  := Curseur1D.Top + 1;
    Curseur1H.Left := Image1.Left - Curseur1H.Width  Div 2 +X;
    Curseur1B.Left := Curseur1H.Left;
    Viseur.Top     := Curseur1D.Top  - 6;
    Viseur.Left    := Curseur1H.Left - 7;
  End;
end;

procedure TForm1.Image2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  If (ssLeft In Shift)Then
  Begin
    If Y<0 Then Y:=0;
    If Y>=Image2.Height Then Y:=Image2.Height-1;
    Curseur2D.Top := Image2.Top - Curseur2D.Height Div 2 + Y;
    Curseur2G.Top := Curseur2D.Top + 1;
    MAJPanneau;
  End;
end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Image1MouseMove(Sender,Shift,x,y);
end;

procedure TForm1.Image2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Image2MouseMove(Sender,Shift,x,y);
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  DoubleBuffered := CheckBox1.Checked;
end;
end.

