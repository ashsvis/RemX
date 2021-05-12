object OpenDialogForm: TOpenDialogForm
  Left = 365
  Top = 336
  BorderStyle = bsDialog
  Caption = #1054#1090#1082#1088#1099#1090#1100
  ClientHeight = 234
  ClientWidth = 339
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
    Left = 16
    Top = 8
    Width = 226
    Height = 14
    Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1085#1091#1078#1085#1099#1081' '#1042#1072#1084' '#1092#1072#1081#1083' '#1080#1079' '#1089#1087#1080#1089#1082#1072':'
  end
  object Button1: TButton
    Left = 136
    Top = 199
    Width = 89
    Height = 25
    Caption = #1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 240
    Top = 199
    Width = 89
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object ListBox1: TListBox
    Left = 8
    Top = 32
    Width = 321
    Height = 153
    ItemHeight = 14
    TabOrder = 2
    OnDblClick = ListBox1DblClick
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 272
    Top = 48
  end
end
