object EditDinSizeForm: TEditDinSizeForm
  Left = 216
  Top = 216
  BorderStyle = bsDialog
  Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1088#1072#1079#1084#1077#1088#1072
  ClientHeight = 161
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
  object rgWidth: TRadioGroup
    Left = 8
    Top = 8
    Width = 193
    Height = 113
    Caption = ' '#1064#1080#1088#1080#1085#1072' '
    ItemIndex = 0
    Items.Strings = (
      #1053#1077' '#1080#1079#1084#1077#1085#1103#1090#1100
      #1057#1078#1072#1090#1100' '#1076#1086' '#1085#1072#1080#1084#1077#1085#1100#1096#1077#1075#1086
      #1056#1072#1089#1090#1103#1085#1091#1090#1100' '#1076#1086' '#1085#1072#1080#1073#1086#1083#1100#1096#1077#1075#1086
      #1064#1080#1088#1080#1085#1072':')
    TabOrder = 0
    OnClick = rgWidthClick
  end
  object rgHeight: TRadioGroup
    Left = 208
    Top = 8
    Width = 193
    Height = 113
    Caption = ' '#1042#1099#1089#1086#1090#1072' '
    ItemIndex = 0
    Items.Strings = (
      #1053#1077' '#1080#1079#1084#1077#1085#1103#1090#1100
      #1057#1078#1072#1090#1100' '#1076#1086' '#1085#1072#1080#1084#1077#1085#1100#1096#1077#1075#1086
      #1056#1072#1089#1090#1103#1085#1091#1090#1100' '#1076#1086' '#1085#1072#1080#1073#1086#1083#1100#1096#1077#1075#1086
      #1042#1099#1089#1086#1090#1072':')
    TabOrder = 1
    OnClick = rgHeightClick
  end
  object ButtonOk: TButton
    Left = 168
    Top = 128
    Width = 105
    Height = 25
    Caption = #1042#1074#1086#1076
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object ButtonCancel: TButton
    Left = 288
    Top = 128
    Width = 105
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
  object edWidth: TEdit
    Left = 90
    Top = 94
    Width = 55
    Height = 21
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnEnter = edWidthEnter
  end
  object edHeight: TEdit
    Left = 290
    Top = 94
    Width = 55
    Height = 21
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnEnter = edHeightEnter
  end
end
