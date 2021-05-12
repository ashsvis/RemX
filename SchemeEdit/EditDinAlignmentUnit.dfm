object EditDinAlignmentForm: TEditDinAlignmentForm
  Left = 216
  Top = 216
  BorderStyle = bsDialog
  Caption = #1042#1099#1088#1072#1074#1085#1080#1074#1072#1085#1080#1077
  ClientHeight = 208
  ClientWidth = 409
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
  object rgHorizontal: TRadioGroup
    Left = 8
    Top = 8
    Width = 193
    Height = 161
    Caption = ' '#1055#1086' '#1075#1086#1088#1080#1079#1086#1085#1090#1072#1083#1080' '
    ItemIndex = 0
    Items.Strings = (
      #1053#1077' '#1080#1079#1084#1077#1085#1103#1090#1100
      #1055#1086' '#1083#1077#1074#1099#1084' '#1089#1090#1086#1088#1086#1085#1072#1084
      #1055#1086' '#1094#1077#1085#1090#1088#1072#1084' '#1101#1083#1077#1084#1077#1085#1090#1086#1074
      #1055#1086' '#1087#1088#1072#1074#1099#1084' '#1089#1090#1086#1088#1086#1085#1072#1084
      #1055#1086' '#1088#1072#1074#1077#1085#1089#1090#1074#1091' '#1087#1088#1086#1084#1077#1078#1091#1090#1082#1086#1074
      #1055#1086' '#1094#1077#1085#1090#1088#1091' '#1086#1082#1085#1072)
    TabOrder = 0
  end
  object rgVertical: TRadioGroup
    Left = 208
    Top = 8
    Width = 193
    Height = 161
    Caption = ' '#1055#1086' '#1074#1077#1088#1090#1080#1082#1072#1083#1080' '
    ItemIndex = 0
    Items.Strings = (
      #1053#1077' '#1080#1079#1084#1077#1085#1103#1090#1100
      #1055#1086' '#1074#1077#1088#1093#1085#1080#1084' '#1089#1090#1086#1088#1086#1085#1072#1084
      #1055#1086' '#1094#1077#1085#1090#1088#1072#1084' '#1101#1083#1077#1084#1077#1085#1090#1086#1074
      #1055#1086' '#1085#1080#1078#1085#1080#1084' '#1089#1090#1086#1088#1086#1085#1072#1084
      #1055#1086' '#1088#1072#1074#1077#1085#1089#1090#1074#1091' '#1087#1088#1086#1084#1077#1078#1091#1090#1082#1086#1074
      #1055#1086' '#1094#1077#1085#1090#1088#1091' '#1086#1082#1085#1072)
    TabOrder = 1
  end
  object ButtonOk: TButton
    Left = 168
    Top = 176
    Width = 105
    Height = 25
    Caption = #1042#1074#1086#1076
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object ButtonCancel: TButton
    Left = 288
    Top = 176
    Width = 105
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
end
