object TuneConnForm: TTuneConnForm
  Left = 304
  Top = 287
  BorderStyle = bsDialog
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1087#1086#1076#1082#1083#1102#1095#1077#1085#1080#1103
  ClientHeight = 185
  ClientWidth = 370
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 14
  object btnConnect: TButton
    Left = 16
    Top = 152
    Width = 115
    Height = 25
    Caption = #1055#1086#1076#1082#1083#1102#1095#1080#1090#1100#1089#1103
    ModalResult = 4
    TabOrder = 5
  end
  object btnOk: TButton
    Left = 176
    Top = 152
    Width = 75
    Height = 25
    Caption = #1054#1082
    Default = True
    ModalResult = 1
    TabOrder = 6
  end
  object BtnCancel: TButton
    Left = 280
    Top = 152
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 7
  end
  object rgTypeConn: TRadioGroup
    Left = 8
    Top = 8
    Width = 129
    Height = 89
    Caption = ' '#1058#1080#1087' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1103' '
    ItemIndex = 0
    Items.Strings = (
      'DCOM'
      'Borland Socket'
      'Web (Http)')
    TabOrder = 0
    OnClick = rgTypeConnClick
  end
  object leAddress: TLabeledEdit
    Left = 152
    Top = 24
    Width = 145
    Height = 22
    EditLabel.Width = 106
    EditLabel.Height = 14
    EditLabel.Caption = 'IP - '#1072#1076#1088#1077#1089' '#1089#1077#1088#1074#1077#1088#1072
    TabOrder = 1
  end
  object leURL: TLabeledEdit
    Left = 152
    Top = 72
    Width = 209
    Height = 22
    EditLabel.Width = 116
    EditLabel.Height = 14
    EditLabel.Caption = 'URL - '#1072#1076#1088#1077#1089' '#1089#1077#1088#1074#1077#1088#1072
    TabOrder = 3
  end
  object lePort: TLabeledEdit
    Left = 304
    Top = 24
    Width = 41
    Height = 22
    EditLabel.Width = 28
    EditLabel.Height = 14
    EditLabel.Caption = #1055#1086#1088#1090
    TabOrder = 2
  end
  object lePath: TLabeledEdit
    Left = 8
    Top = 120
    Width = 353
    Height = 22
    EditLabel.Width = 199
    EditLabel.Height = 14
    EditLabel.Caption = #1055#1091#1090#1100' '#1082' '#1082#1086#1088#1085#1077#1074#1086#1081' '#1087#1072#1087#1082#1077' '#1085#1072' '#1089#1077#1088#1074#1077#1088#1077
    TabOrder = 4
  end
end
