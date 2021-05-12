object FindDialogForm: TFindDialogForm
  Left = 458
  Top = 373
  BorderStyle = bsDialog
  Caption = #1053#1072#1081#1090#1080' '#1096#1080#1092#1088' '#1087#1086#1079#1080#1094#1080#1080
  ClientHeight = 92
  ClientWidth = 426
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object leFindExample: TLabeledEdit
    Left = 40
    Top = 8
    Width = 265
    Height = 22
    EditLabel.Width = 25
    EditLabel.Height = 14
    EditLabel.Caption = #1063#1090#1086':'
    LabelPosition = lpLeft
    TabOrder = 0
    OnChange = leFindExampleChange
  end
  object FindNextButton: TButton
    Left = 320
    Top = 8
    Width = 97
    Height = 25
    Caption = #1053#1072#1081#1090#1080' '#1076#1072#1083#1077#1077
    Default = True
    TabOrder = 2
    OnClick = FindNextButtonClick
  end
  object CancelButton: TButton
    Left = 320
    Top = 40
    Width = 97
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
  object cbWordOnly: TCheckBox
    Left = 8
    Top = 40
    Width = 161
    Height = 17
    Caption = #1058#1086#1083#1100#1082#1086' '#1089#1083#1086#1074#1086' '#1094#1077#1083#1080#1082#1086#1084
    TabOrder = 1
    OnClick = cbWordOnlyClick
  end
end
