object Form1: TForm1
  Left = 192
  Top = 114
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Color Ribbon'
  ClientHeight = 135
  ClientWidth = 381
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'Verdana'
  Font.Style = []
  Position = poScreenCenter
  OnActivate = Init
  OnClose = Exit
  TextHeight = 16
  object pbStripe: TPaintBox
    Left = 0
    Top = 0
    Width = 381
    Height = 103
    Align = alClient
    Color = clBtnFace
    ParentColor = False
    OnMouseMove = GetRGB
    OnPaint = Strip
    ExplicitWidth = 377
    ExplicitHeight = 102
  end
  object panDown: TPanel
    Left = 0
    Top = 103
    Width = 381
    Height = 32
    Align = alBottom
    TabOrder = 0
    ExplicitTop = 102
    ExplicitWidth = 377
  end
end
