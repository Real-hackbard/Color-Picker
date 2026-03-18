object Form1: TForm1
  Left = 1726
  Top = 157
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Zoom Picker'
  ClientHeight = 430
  ClientWidth = 496
  Color = clBtnFace
  Constraints.MinHeight = 152
  Constraints.MinWidth = 483
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  TextHeight = 13
  object LabelZoom: TLabel
    Left = 10
    Top = 11
    Width = 33
    Height = 13
    Caption = 'Zoom :'
  end
  object LabelApercu: TLabel
    Left = 344
    Top = 35
    Width = 30
    Height = 13
    Caption = 'Color :'
  end
  object LabelR: TLabel
    Left = 352
    Top = 145
    Width = 26
    Height = 13
    Caption = 'Red :'
    FocusControl = EditR
  end
  object LabelG: TLabel
    Left = 344
    Top = 175
    Width = 35
    Height = 13
    Caption = 'Green :'
    FocusControl = EditG
  end
  object LabelB: TLabel
    Left = 352
    Top = 205
    Width = 27
    Height = 13
    Caption = 'Blue :'
    FocusControl = EditB
  end
  object LabelC: TLabel
    Left = 360
    Top = 251
    Width = 13
    Height = 13
    Caption = 'C :'
    FocusControl = EditC
  end
  object LabelDelphi: TLabel
    Left = 344
    Top = 281
    Width = 36
    Height = 13
    Caption = 'Delphi :'
    FocusControl = EditDelphi
  end
  object LabelHTML: TLabel
    Left = 344
    Top = 311
    Width = 36
    Height = 13
    Caption = 'HTML :'
    FocusControl = EditHTML
  end
  object Bevel1: TBevel
    Left = 384
    Top = 32
    Width = 81
    Height = 81
  end
  object Bevel2: TBevel
    Left = 320
    Top = 124
    Width = 169
    Height = 2
  end
  object Shape1: TShape
    Left = 392
    Top = 40
    Width = 65
    Height = 65
  end
  object Label1: TLabel
    Left = 16
    Top = 376
    Width = 109
    Height = 13
    Caption = 'Press F1 to stop Picker'
  end
  object EditR: TEdit
    Left = 386
    Top = 141
    Width = 100
    Height = 21
    TabStop = False
    ParentColor = True
    ReadOnly = True
    TabOrder = 0
    Text = '0'
  end
  object EditG: TEdit
    Left = 386
    Top = 171
    Width = 100
    Height = 21
    TabStop = False
    ParentColor = True
    ReadOnly = True
    TabOrder = 1
    Text = '0'
  end
  object EditB: TEdit
    Left = 386
    Top = 201
    Width = 100
    Height = 21
    TabStop = False
    ParentColor = True
    ReadOnly = True
    TabOrder = 2
    Text = '0'
  end
  object EditC: TEdit
    Left = 385
    Top = 247
    Width = 100
    Height = 21
    TabStop = False
    ParentColor = True
    ReadOnly = True
    TabOrder = 3
    Text = '0x00000000'
  end
  object EditDelphi: TEdit
    Left = 385
    Top = 277
    Width = 100
    Height = 21
    TabStop = False
    ParentColor = True
    ReadOnly = True
    TabOrder = 4
    Text = '$00000000'
  end
  object EditHTML: TEdit
    Left = 385
    Top = 307
    Width = 100
    Height = 21
    TabStop = False
    ParentColor = True
    ReadOnly = True
    TabOrder = 5
    Text = '#000000'
  end
  object Panel1: TPanel
    Left = 8
    Top = 32
    Width = 297
    Height = 297
    TabOrder = 6
    object ImageZoom: TImage
      Left = 6
      Top = 7
      Width = 283
      Height = 283
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 411
    Width = 496
    Height = 19
    Panels = <
      item
        Text = 'X :'
        Width = 25
      end
      item
        Width = 50
      end
      item
        Text = 'Y :'
        Width = 25
      end
      item
        Width = 50
      end
      item
        Text = 'Status :'
        Width = 50
      end
      item
        Width = 50
      end>
    ExplicitTop = 395
    ExplicitWidth = 491
  end
  object CheckBox1: TCheckBox
    Left = 16
    Top = 344
    Width = 65
    Height = 17
    TabStop = False
    Caption = 'Stay Top'
    TabOrder = 8
    OnClick = CheckBox1Click
  end
  object Button1: TButton
    Left = 384
    Top = 368
    Width = 99
    Height = 25
    Caption = #180'Start Picker'
    Enabled = False
    TabOrder = 9
    TabStop = False
    OnClick = Button1Click
  end
  object Timer1: TTimer
    Interval = 10
    OnTimer = Timer1Timer
    Left = 42
    Top = 56
  end
  object Timer2: TTimer
    Interval = 1
    OnTimer = Timer2Timer
    Left = 96
    Top = 56
  end
end
