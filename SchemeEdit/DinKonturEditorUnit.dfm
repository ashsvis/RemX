object DinKonturEditorForm: TDinKonturEditorForm
  Left = 515
  Top = 407
  BorderStyle = bsDialog
  Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1101#1083#1077#1084#1077#1085#1090#1072' "'#1050#1086#1085#1090#1091#1088' '#1088#1077#1075#1091#1083#1080#1088#1086#1074#1072#1085#1080#1103'"'
  ClientHeight = 189
  ClientWidth = 485
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
    Height = 177
    Caption = ' '#1054#1073#1088#1072#1079#1077#1094
    TabOrder = 0
    object ScrollBox: TScrollBox
      Left = 8
      Top = 16
      Width = 173
      Height = 153
      Color = clGray
      ParentColor = False
      TabOrder = 0
    end
  end
  object CloseButton: TButton
    Left = 93
    Top = 156
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
    Height = 145
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
      Left = 7
      Top = 92
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
    object Bevel1: TBevel
      Left = 144
      Top = 90
      Width = 9
      Height = 47
      Shape = bsLeftLine
    end
    object Label1: TLabel
      Left = 151
      Top = 92
      Width = 44
      Height = 14
      Caption = #1064#1088#1080#1092#1090':'
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
    object edPtName: TEdit
      Left = 7
      Top = 108
      Width = 121
      Height = 22
      Cursor = crHandPoint
      ReadOnly = True
      TabOrder = 4
      OnClick = edPtNameClick
    end
    object buFont: TButton
      Left = 152
      Top = 107
      Width = 113
      Height = 27
      Caption = #1064#1088#1080#1092#1090'...'
      TabOrder = 5
      OnClick = buFontClick
    end
  end
  object CancelButton: TButton
    Left = 189
    Top = 156
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
  object FontDialog: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 304
    Top = 128
  end
end
