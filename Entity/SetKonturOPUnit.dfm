object SetKonturOPDlg: TSetKonturOPDlg
  Left = 430
  Top = 411
  BorderStyle = bsDialog
  Caption = #1042#1099#1093#1086#1076' '#1088#1077#1075#1091#1083#1103#1090#1086#1088#1072
  ClientHeight = 94
  ClientWidth = 259
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 14
  object sbLess: TSpeedButton
    Left = 8
    Top = 16
    Width = 113
    Height = 33
    Caption = #1047#1072#1082#1088#1099#1074#1072#1090#1100
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    OnMouseDown = sbLessMouseDown
    OnMouseUp = sbLessMouseUp
  end
  object sbMore: TSpeedButton
    Left = 136
    Top = 16
    Width = 113
    Height = 33
    Caption = #1054#1090#1082#1088#1099#1074#1072#1090#1100
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    OnMouseDown = sbMoreMouseDown
    OnMouseUp = sbMoreMouseUp
  end
  object Button1: TButton
    Left = 176
    Top = 64
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1047#1072#1082#1088#1099#1090#1100
    ModalResult = 2
    TabOrder = 0
  end
  object IT: TTimer
    Interval = 9000
    OnTimer = ITTimer
    Left = 16
    Top = 56
  end
end
