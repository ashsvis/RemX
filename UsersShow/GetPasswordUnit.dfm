object GetPasswordForm: TGetPasswordForm
  Left = 423
  Top = 282
  ActiveControl = Edit1
  BorderStyle = bsDialog
  Caption = #1042#1074#1077#1076#1080#1090#1077' '#1087#1072#1088#1086#1083#1100
  ClientHeight = 73
  ClientWidth = 232
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
  object Button1: TButton
    Left = 19
    Top = 40
    Width = 75
    Height = 25
    Caption = #1042#1074#1086#1076
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 139
    Top = 40
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
  object Edit1: TEdit
    Left = 16
    Top = 8
    Width = 201
    Height = 22
    PasswordChar = '*'
    TabOrder = 0
  end
end
