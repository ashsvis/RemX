object AddExtModuleForm: TAddExtModuleForm
  Left = 245
  Top = 257
  BorderStyle = bsDialog
  Caption = #1042#1085#1077#1096#1085#1077#1077' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1077
  ClientHeight = 145
  ClientWidth = 410
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
    Width = 129
    Height = 21
    AutoSize = False
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1087#1091#1085#1082#1090#1072' '#1084#1077#1085#1102
    Layout = tlCenter
  end
  object Label2: TLabel
    Left = 8
    Top = 32
    Width = 129
    Height = 21
    AutoSize = False
    Caption = #1055#1091#1090#1100' '#1082' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1102
    Layout = tlCenter
  end
  object Label3: TLabel
    Left = 8
    Top = 56
    Width = 129
    Height = 21
    AutoSize = False
    Caption = #1056#1072#1073#1086#1095#1072#1103' '#1087#1072#1087#1082#1072
    Layout = tlCenter
  end
  object Label4: TLabel
    Left = 8
    Top = 80
    Width = 129
    Height = 21
    AutoSize = False
    Caption = #1059#1088#1086#1074#1077#1085#1100' '#1076#1086#1089#1090#1091#1087#1072
    Layout = tlCenter
  end
  object sbPathSelect: TSpeedButton
    Left = 352
    Top = 80
    Width = 17
    Height = 17
    Cursor = crHandPoint
    Caption = '...'
    Visible = False
    OnClick = sbPathSelectClick
  end
  object edMenuName: TEdit
    Left = 152
    Top = 8
    Width = 249
    Height = 22
    TabOrder = 0
  end
  object edProgramPath: TEdit
    Left = 152
    Top = 32
    Width = 249
    Height = 22
    TabOrder = 1
    OnEnter = edProgramPathEnter
    OnExit = edProgramPathExit
  end
  object edWorkPath: TEdit
    Left = 152
    Top = 56
    Width = 249
    Height = 22
    TabOrder = 2
    OnEnter = edWorkPathEnter
    OnExit = edProgramPathExit
  end
  object cbLevel: TComboBox
    Left = 152
    Top = 80
    Width = 161
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    ItemIndex = 0
    TabOrder = 3
    Text = #1042#1089#1077#1084
    Items.Strings = (
      #1042#1089#1077#1084
      #1054#1087#1077#1088#1072#1090#1086#1088#1099
      #1055#1088#1080#1073#1086#1088#1080#1089#1090#1099
      #1048#1085#1078#1077#1085#1077#1088#1099'-'#1090#1077#1093#1085#1086#1083#1086#1075#1080
      #1044#1080#1089#1087#1077#1090#1095#1077#1088#1099
      #1048#1085#1078#1077#1085#1077#1088#1099' '#1040#1057#1059' '#1058#1055
      #1055#1088#1086#1075#1088#1072#1084#1084#1080#1089#1090#1099)
  end
  object btOk: TButton
    Left = 208
    Top = 112
    Width = 89
    Height = 25
    Caption = #1042#1074#1086#1076
    Default = True
    ModalResult = 1
    TabOrder = 4
  end
  object btCancel: TButton
    Left = 312
    Top = 112
    Width = 89
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 5
  end
end
