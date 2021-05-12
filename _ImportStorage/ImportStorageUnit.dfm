object ImportStorageForm: TImportStorageForm
  Left = 341
  Top = 314
  BorderStyle = bsDialog
  Caption = #1048#1084#1087#1086#1088#1090' '#1076#1072#1085#1085#1099#1093' '#1080#1079' '#1074#1077#1088#1089#1080#1080' RemX 3.x'
  ClientHeight = 194
  ClientWidth = 458
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel1: TBevel
    Left = 8
    Top = 144
    Width = 441
    Height = 9
    Shape = bsTopLine
  end
  object LabelInfo: TLabel
    Left = 24
    Top = 16
    Width = 409
    Height = 113
    Alignment = taCenter
    AutoSize = False
    Layout = tlCenter
    WordWrap = True
  end
  object Button1: TButton
    Left = 264
    Top = 160
    Width = 97
    Height = 25
    Caption = #1055#1088#1086#1076#1086#1083#1078#1080#1090#1100
    Default = True
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 368
    Top = 160
    Width = 81
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1080#1090#1100
    ModalResult = 2
    TabOrder = 1
    OnClick = Button2Click
  end
  object Animate1: TAnimate
    Left = 104
    Top = 72
    Width = 272
    Height = 60
    CommonAVI = aviCopyFiles
    StopFrame = 31
    Timers = True
    Visible = False
  end
end
