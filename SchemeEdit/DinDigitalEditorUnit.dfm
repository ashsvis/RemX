object DinDigitalEditorForm: TDinDigitalEditorForm
  Left = 217
  Top = 223
  BorderStyle = bsDialog
  Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1101#1083#1077#1084#1077#1085#1090#1072' "'#1044#1080#1089#1082#1088#1077#1090#1085#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077'"'
  ClientHeight = 248
  ClientWidth = 486
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
  object GroupBox: TGroupBox
    Left = 288
    Top = 8
    Width = 190
    Height = 193
    Caption = ' '#1054#1073#1088#1072#1079#1077#1094
    TabOrder = 0
    object ScrollBox: TScrollBox
      Left = 8
      Top = 16
      Width = 173
      Height = 169
      Color = clGray
      ParentColor = False
      TabOrder = 0
    end
  end
  object CloseButton: TButton
    Left = 293
    Top = 212
    Width = 87
    Height = 25
    Caption = #1042#1074#1086#1076
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object PropertyBox: TGroupBox
    Left = 8
    Top = 8
    Width = 273
    Height = 233
    Caption = #1057#1074#1086#1081#1089#1090#1074#1072
    TabOrder = 2
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
    object Label3: TLabel
      Left = 144
      Top = 96
      Width = 78
      Height = 14
      Caption = #1048#1084#1103' '#1087#1086#1079#1080#1094#1080#1080':'
    end
    object Bevel2: TBevel
      Left = 8
      Top = 17
      Width = 257
      Height = 69
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
    object rgViewKind: TRadioGroup
      Left = 8
      Top = 96
      Width = 129
      Height = 129
      Caption = ' '#1042#1080#1076' '
      ItemIndex = 0
      Items.Strings = (
        #1050#1074#1072#1076#1088#1072#1090
        #1050#1088#1091#1075
        #1055#1088#1103#1084#1086#1091#1075#1086#1083#1100#1085#1080#1082
        #1069#1083#1083#1080#1087#1089)
      TabOrder = 4
      OnClick = rgViewKindClick
    end
    object rgBorderKind: TRadioGroup
      Left = 144
      Top = 144
      Width = 121
      Height = 81
      Caption = ' '#1056#1072#1084#1082#1072' '
      ItemIndex = 0
      Items.Strings = (
        #1054#1090#1089#1091#1090#1089#1090#1074#1091#1077#1090
        #1055#1088#1086#1089#1090#1072#1103
        #1054#1073#1098#1077#1084#1085#1072#1103)
      TabOrder = 6
      OnClick = rgBorderKindClick
    end
    object edPtName: TEdit
      Left = 144
      Top = 112
      Width = 121
      Height = 22
      Cursor = crHandPoint
      ReadOnly = True
      TabOrder = 5
      OnClick = edPtNameClick
    end
  end
  object CancelButton: TButton
    Left = 389
    Top = 212
    Width = 87
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
    Left = 424
    Top = 32
  end
end
