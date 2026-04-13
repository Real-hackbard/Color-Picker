object Form1: TForm1
  Left = 529
  Top = 184
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'HSBtoColor'
  ClientHeight = 297
  ClientWidth = 303
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 243
    Height = 241
    Align = alClient
    OnMouseMove = Image1MouseMove
    OnMouseUp = Image1MouseUp
    ExplicitLeft = 64
    ExplicitTop = 40
    ExplicitWidth = 281
  end
  object Panel2: TPanel
    Left = 0
    Top = 241
    Width = 303
    Height = 56
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitTop = 445
    ExplicitWidth = 504
    object Label1: TLabel
      Left = 164
      Top = 19
      Width = 30
      Height = 13
      Caption = 'Color :'
    end
    object Panel1: TPanel
      Left = 8
      Top = 16
      Width = 145
      Height = 21
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
    end
    object Edit1: TEdit
      Left = 200
      Top = 16
      Width = 89
      Height = 21
      TabOrder = 1
      Text = '$'
    end
  end
  object Panel3: TPanel
    Left = 243
    Top = 0
    Width = 60
    Height = 241
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitLeft = 440
    ExplicitHeight = 444
    object Image2: TImage
      Left = 10
      Top = 16
      Width = 9
      Height = 217
    end
    object TrackBar1: TTrackBar
      Left = 24
      Top = 8
      Width = 27
      Height = 225
      DoubleBuffered = False
      Max = 240
      Orientation = trVertical
      ParentDoubleBuffered = False
      TabOrder = 0
      TabStop = False
      TickMarks = tmTopLeft
      TickStyle = tsNone
      OnChange = TrackBar1Change
    end
  end
end
