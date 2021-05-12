object GetRegModeValDlg: TGetRegModeValDlg
  Left = 340
  Top = 197
  BorderStyle = bsDialog
  Caption = 'GetRegModeValDlg'
  ClientHeight = 190
  ClientWidth = 328
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
  object Button2: TButton
    Left = 240
    Top = 152
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 5
  end
  object rgSPMode: TRadioGroup
    Left = 8
    Top = 8
    Width = 137
    Height = 97
    Caption = #1056#1077#1078#1080#1084' '#1079#1072#1076#1072#1085#1080#1103
    Items.Strings = (
      #1042#1085#1077#1096#1085#1077#1077
      #1055#1088#1086#1075#1088#1072#1084#1084#1085#1086#1077
      #1056#1091#1095#1085#1086#1077)
    TabOrder = 0
    OnClick = rgSPModeClick
  end
  object rgOPMode: TRadioGroup
    Left = 8
    Top = 112
    Width = 137
    Height = 70
    Caption = #1056#1077#1078#1080#1084' '#1091#1087#1088#1072#1074#1083#1077#1085#1080#1103
    Items.Strings = (
      #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1086#1077
      #1056#1091#1095#1085#1086#1077)
    TabOrder = 1
    OnClick = rgOPModeClick
  end
  object rgRemoteMode: TRadioGroup
    Left = 152
    Top = 8
    Width = 169
    Height = 65
    Caption = #1044#1080#1089#1090#1072#1085#1094#1080#1086#1085#1085#1099#1081' '#1088#1077#1078#1080#1084
    Items.Strings = (
      #1055#1077#1088#1077#1081#1090#1080' '#1085#1072' '#1044#1059
      #1054#1090#1084#1077#1085#1080#1090#1100' '#1044#1059)
    TabOrder = 2
    OnClick = rgRemoteModeClick
  end
  object rgLocaleMode: TRadioGroup
    Left = 152
    Top = 80
    Width = 169
    Height = 65
    Caption = #1051#1086#1082#1072#1083#1100#1085#1099#1081' '#1088#1077#1078#1080#1084
    Items.Strings = (
      #1050#1072#1089#1082#1072#1076#1085#1086#1077' '#1091#1087#1088#1072#1074#1083#1077#1085#1080#1077
      #1051#1086#1082#1072#1083#1100#1085#1086#1077' '#1091#1087#1088#1072#1074#1083#1077#1085#1080#1077)
    TabOrder = 3
    OnClick = rgLocaleModeClick
  end
  object Button1: TButton
    Left = 155
    Top = 152
    Width = 75
    Height = 25
    Caption = #1042#1074#1086#1076
    Default = True
    ModalResult = 1
    TabOrder = 4
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 120
    Top = 8
  end
end
