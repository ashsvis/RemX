object GetPtNameDlg: TGetPtNameDlg
  Left = 262
  Top = 184
  BorderStyle = bsDialog
  Caption = #1064#1080#1092#1088' '#1087#1086#1079#1080#1094#1080#1080
  ClientHeight = 86
  ClientWidth = 347
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
  object Label1: TLabel
    Left = 30
    Top = 6
    Width = 35
    Height = 14
    Caption = 'Label1'
  end
  object Image1: TImage
    Left = 8
    Top = 6
    Width = 16
    Height = 16
  end
  object Bevel1: TBevel
    Left = 6
    Top = 4
    Width = 20
    Height = 20
    Shape = bsFrame
  end
  object Edit1: TEdit
    Left = 8
    Top = 26
    Width = 313
    Height = 24
    CharCase = ecUpperCase
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Text = '0'
  end
  object Button1: TButton
    Left = 176
    Top = 56
    Width = 75
    Height = 25
    Caption = #1042#1074#1086#1076
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 264
    Top = 56
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
  object UpDown1: TUpDown
    Left = 321
    Top = 26
    Width = 17
    Height = 24
    Max = 10000
    TabOrder = 3
    Thousands = False
    Visible = False
  end
end
