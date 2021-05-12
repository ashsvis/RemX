object DinNodeEditorForm: TDinNodeEditorForm
  Left = 353
  Top = 231
  BorderStyle = bsDialog
  Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1101#1083#1077#1084#1077#1085#1090#1072' "'#1059#1089#1090#1088#1086#1081#1089#1090#1074#1086'"'
  ClientHeight = 161
  ClientWidth = 321
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
    Width = 145
    Height = 145
    Caption = #1057#1074#1086#1081#1089#1090#1074#1072
    TabOrder = 0
    object Bevel2: TBevel
      Left = 8
      Top = 17
      Width = 129
      Height = 69
    end
    object Label3: TLabel
      Left = 8
      Top = 97
      Width = 78
      Height = 14
      Caption = #1048#1084#1103' '#1087#1086#1079#1080#1094#1080#1080':'
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
    object edPtName: TEdit
      Left = 8
      Top = 114
      Width = 121
      Height = 22
      Cursor = crHandPoint
      ReadOnly = True
      TabOrder = 2
      OnClick = edPtNameClick
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
  end
  object GroupBox: TGroupBox
    Left = 162
    Top = 8
    Width = 151
    Height = 105
    Caption = ' '#1054#1073#1088#1072#1079#1077#1094
    TabOrder = 1
    object ScrollBox: TScrollBox
      Left = 8
      Top = 16
      Width = 137
      Height = 81
      Color = clGray
      ParentColor = False
      TabOrder = 0
    end
  end
  object CloseButton: TButton
    Left = 161
    Top = 124
    Width = 70
    Height = 25
    Caption = #1042#1074#1086#1076
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object CancelButton: TButton
    Left = 243
    Top = 124
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
    Left = 272
    Top = 64
  end
end
