object GetRtmRepRecordForm: TGetRtmRepRecordForm
  Left = 274
  Top = 208
  BorderStyle = bsDialog
  Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1091#1095#1077#1090#1085#1086#1081' '#1079#1072#1087#1080#1089#1080
  ClientHeight = 144
  ClientWidth = 440
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
    Left = 8
    Top = 8
    Width = 113
    Height = 22
    AutoSize = False
    Caption = #1048#1084#1103' '#1092#1072#1081#1083' '#1086#1090#1095#1077#1090#1072
    Layout = tlCenter
  end
  object Label2: TLabel
    Left = 8
    Top = 40
    Width = 113
    Height = 22
    AutoSize = False
    Caption = #1042#1088#1077#1084#1103' '#1085#1072#1095#1072#1083#1072
    Layout = tlCenter
  end
  object Label3: TLabel
    Left = 200
    Top = 40
    Width = 97
    Height = 22
    AutoSize = False
    Caption = #1055#1077#1088#1080#1086#1076' '#1087#1077#1095#1072#1090#1080
    Layout = tlCenter
  end
  object Label4: TLabel
    Left = 8
    Top = 72
    Width = 113
    Height = 22
    AutoSize = False
    Caption = #1054#1087#1080#1089#1072#1085#1080#1077' '#1086#1090#1095#1077#1090#1072
    Layout = tlCenter
  end
  object cbFileName: TComboBox
    Left = 120
    Top = 8
    Width = 313
    Height = 22
    ItemHeight = 14
    TabOrder = 0
    OnDropDown = cbFileNameDropDown
  end
  object edStartTime: TEdit
    Left = 120
    Top = 40
    Width = 57
    Height = 22
    TabOrder = 1
    Text = '00:00'
  end
  object edPrintPeriod: TEdit
    Left = 304
    Top = 40
    Width = 57
    Height = 22
    TabOrder = 2
    Text = '00:00'
  end
  object edDescriptor: TEdit
    Left = 120
    Top = 72
    Width = 313
    Height = 22
    TabOrder = 3
  end
  object cbHandRun: TCheckBox
    Left = 120
    Top = 104
    Width = 121
    Height = 17
    Caption = #1047#1072#1087#1091#1089#1082' '#1074#1088#1091#1095#1085#1091#1102
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
  object Button1: TButton
    Left = 248
    Top = 112
    Width = 89
    Height = 25
    Caption = #1042#1074#1086#1076
    Default = True
    ModalResult = 1
    TabOrder = 5
  end
  object Button2: TButton
    Left = 344
    Top = 112
    Width = 89
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 6
  end
end
