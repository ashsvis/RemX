object GetAutorizationForm: TGetAutorizationForm
  Left = 526
  Top = 172
  BorderStyle = bsDialog
  Caption = #1040#1082#1090#1080#1074#1072#1094#1080#1103' RemX'
  ClientHeight = 159
  ClientWidth = 318
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
    Top = 120
    Width = 305
    Height = 9
    Shape = bsTopLine
  end
  object leUser: TLabeledEdit
    Left = 128
    Top = 16
    Width = 177
    Height = 22
    EditLabel.Width = 105
    EditLabel.Height = 14
    EditLabel.Caption = #1048#1084#1103' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
    LabelPosition = lpLeft
    LabelSpacing = 8
    TabOrder = 0
    OnExit = leUserExit
  end
  object leComputer: TLabeledEdit
    Left = 128
    Top = 48
    Width = 177
    Height = 24
    EditLabel.Width = 94
    EditLabel.Height = 14
    EditLabel.Caption = #1050#1086#1076' '#1082#1086#1084#1087#1100#1102#1090#1077#1088#1072
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    LabelPosition = lpLeft
    LabelSpacing = 8
    ParentFont = False
    TabOrder = 1
  end
  object leAutorization: TLabeledEdit
    Left = 128
    Top = 80
    Width = 177
    Height = 24
    EditLabel.Width = 83
    EditLabel.Height = 14
    EditLabel.Caption = #1050#1086#1076' '#1072#1082#1090#1080#1074#1072#1094#1080#1080
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    LabelPosition = lpLeft
    LabelSpacing = 8
    ParentFont = False
    TabOrder = 2
  end
  object Button1: TButton
    Left = 80
    Top = 128
    Width = 83
    Height = 25
    Caption = #1042#1074#1086#1076
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object Button2: TButton
    Left = 176
    Top = 128
    Width = 83
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 4
  end
end
