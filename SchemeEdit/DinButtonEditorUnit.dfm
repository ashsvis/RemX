object DinButtonEditorForm: TDinButtonEditorForm
  Left = 210
  Top = 157
  BorderStyle = bsDialog
  Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1101#1083#1077#1084#1077#1085#1090#1072' "'#1050#1085#1086#1087#1082#1072'"'
  ClientHeight = 238
  ClientWidth = 450
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object PropertyBox: TGroupBox
    Left = 8
    Top = 8
    Width = 277
    Height = 225
    Caption = #1057#1074#1086#1081#1089#1090#1074#1072
    TabOrder = 0
    object Label3: TLabel
      Left = 8
      Top = 92
      Width = 78
      Height = 14
      Caption = #1048#1084#1103' '#1087#1086#1079#1080#1094#1080#1080':'
    end
    object Label2: TLabel
      Left = 144
      Top = 24
      Width = 48
      Height = 23
      AutoSize = False
      Caption = #1064#1080#1088#1080#1085#1072':'
      Layout = tlCenter
    end
    object Label4: TLabel
      Left = 144
      Top = 56
      Width = 44
      Height = 23
      AutoSize = False
      Caption = #1042#1099#1089#1086#1090#1072':'
      Layout = tlCenter
    end
    object Label5: TLabel
      Left = 16
      Top = 24
      Width = 48
      Height = 23
      AutoSize = False
      Caption = #1057#1083#1077#1074#1072':'
      Layout = tlCenter
    end
    object Label6: TLabel
      Left = 16
      Top = 56
      Width = 44
      Height = 23
      AutoSize = False
      Caption = #1057#1074#1077#1088#1093#1091':'
      Layout = tlCenter
    end
    object Bevel2: TBevel
      Left = 8
      Top = 17
      Width = 257
      Height = 69
    end
    object Label1: TLabel
      Left = 8
      Top = 176
      Width = 88
      Height = 14
      Caption = #1058#1077#1082#1089#1090' '#1085#1072#1076#1087#1080#1089#1080':'
    end
    object Bevel1: TBevel
      Left = 152
      Top = 92
      Width = 9
      Height = 91
      Shape = bsLeftLine
    end
    object Label7: TLabel
      Left = 162
      Top = 134
      Width = 44
      Height = 14
      Caption = #1064#1088#1080#1092#1090':'
    end
    object lbl1: TLabel
      Left = 8
      Top = 134
      Width = 44
      Height = 14
      Caption = #1044#1086#1089#1090#1091#1087':'
    end
    object edPtName: TEdit
      Left = 8
      Top = 109
      Width = 137
      Height = 22
      Cursor = crHandPoint
      ReadOnly = True
      TabOrder = 4
      OnClick = edPtNameClick
    end
    object seWidth: TSpinEdit
      Left = 200
      Top = 24
      Width = 55
      Height = 23
      Ctl3D = True
      MaxValue = 1024
      MinValue = 1
      ParentCtl3D = False
      TabOrder = 2
      Value = 1
      OnChange = seWidthChange
    end
    object seHeight: TSpinEdit
      Left = 200
      Top = 56
      Width = 55
      Height = 23
      Ctl3D = True
      MaxValue = 703
      MinValue = 1
      ParentCtl3D = False
      TabOrder = 3
      Value = 1
      OnChange = seHeightChange
    end
    object seLeft: TSpinEdit
      Left = 72
      Top = 24
      Width = 55
      Height = 23
      Ctl3D = True
      MaxValue = 0
      MinValue = 0
      ParentCtl3D = False
      TabOrder = 0
      Value = 1
    end
    object seTop: TSpinEdit
      Left = 72
      Top = 56
      Width = 55
      Height = 23
      Ctl3D = True
      MaxValue = 0
      MinValue = 0
      ParentCtl3D = False
      TabOrder = 1
      Value = 1
    end
    object edText: TEdit
      Left = 8
      Top = 192
      Width = 257
      Height = 22
      TabOrder = 9
      OnChange = edTextChange
      OnKeyDown = edTextKeyDown
    end
    object buFont: TButton
      Left = 161
      Top = 151
      Width = 104
      Height = 25
      Caption = #1064#1088#1080#1092#1090'...'
      TabOrder = 8
      OnClick = buFontClick
    end
    object cbFixed: TCheckBox
      Left = 166
      Top = 94
      Width = 97
      Height = 17
      Caption = #1057' '#1092#1080#1082#1089#1072#1094#1080#1077#1081
      TabOrder = 6
      OnClick = cbFixedClick
    end
    object cbConfirm: TCheckBox
      Left = 166
      Top = 115
      Width = 99
      Height = 17
      Caption = #1057' '#1079#1072#1087#1088#1086#1089#1086#1084
      TabOrder = 7
      OnClick = cbConfirmClick
    end
    object cbEnterLevel: TComboBox
      Left = 8
      Top = 152
      Width = 137
      Height = 22
      Style = csDropDownList
      ItemHeight = 14
      TabOrder = 5
      Items.Strings = (
        #1054#1087#1077#1088#1072#1090#1086#1088#1099
        #1055#1088#1080#1073#1086#1088#1080#1089#1090#1099
        #1048#1085#1078#1077#1085#1077#1088#1099'-'#1090#1077#1093#1085#1086#1083#1086#1075#1080
        #1044#1080#1089#1087#1077#1090#1095#1077#1088#1099
        #1048#1085#1078#1077#1085#1077#1088#1099' '#1040#1057#1059' '#1058#1055
        #1055#1088#1086#1075#1088#1072#1084#1084#1080#1089#1090#1099)
    end
  end
  object GroupBox: TGroupBox
    Left = 292
    Top = 8
    Width = 151
    Height = 185
    Caption = ' '#1054#1073#1088#1072#1079#1077#1094
    TabOrder = 1
    object ScrollBox: TScrollBox
      Left = 8
      Top = 16
      Width = 137
      Height = 161
      Color = clGray
      ParentColor = False
      TabOrder = 0
    end
  end
  object CloseButton: TButton
    Left = 291
    Top = 204
    Width = 70
    Height = 25
    Caption = #1042#1074#1086#1076
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object CancelButton: TButton
    Left = 371
    Top = 204
    Width = 70
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
  object Fresh: TTimer
    Enabled = False
    Interval = 500
    OnTimer = FreshTimer
    Left = 400
    Top = 32
  end
  object FontDialog: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 264
    Top = 72
  end
end
