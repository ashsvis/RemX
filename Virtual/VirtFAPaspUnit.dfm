object VirtFAPaspForm: TVirtFAPaspForm
  Left = 260
  Top = 161
  BorderStyle = bsSingle
  Caption = 'VirtFAPaspForm'
  ClientHeight = 745
  ClientWidth = 966
  Color = clBlack
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clSilver
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 966
    Height = 37
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object PTNameDesc: TLabel
      Left = 8
      Top = 8
      Width = 137
      Height = 25
      Hint = 'PTNAME'
      Alignment = taCenter
      AutoSize = False
      Caption = 'WWWWWWWW'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clAqua
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object PTDesc: TLabel
      Left = 168
      Top = 8
      Width = 408
      Height = 23
      Hint = 'PTDESC'
      Caption = 'WWWWWWWWWWWWWWWWWWWWWWWW'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clAqua
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object ButtonToDataBase: TButton
      Left = 582
      Top = 5
      Width = 101
      Height = 25
      Cancel = True
      Caption = #1041#1072#1079#1072' '#1076#1072#1085#1085#1099#1093
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = ButtonToDataBaseClick
    end
    object ButtonToMainScreen: TButton
      Left = 694
      Top = 5
      Width = 86
      Height = 25
      Cancel = True
      Caption = #1054#1073#1097#1080#1081' '#1074#1080#1076
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = ButtonToMainScreenClick
    end
  end
  object ConfigPanel: TPanel
    Left = 630
    Top = 37
    Width = 336
    Height = 708
    Align = alRight
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object Label55: TLabel
      Left = 88
      Top = 16
      Width = 123
      Height = 23
      Caption = #1044#1072#1085#1085#1099#1077' '#1090#1086#1095#1082#1080
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clLime
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = [fsUnderline]
      ParentFont = False
    end
    object Label56: TLabel
      Left = 64
      Top = 56
      Width = 120
      Height = 25
      Hint = 'ACTIVED'
      Alignment = taRightJustify
      AutoSize = False
      Caption = #1054#1087#1088#1086#1089' '#1090#1086#1095#1082#1080
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clMoneyGreen
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object PTActive: TLabel
      Left = 200
      Top = 56
      Width = 70
      Height = 23
      Hint = 'ACTIVED'
      Caption = 'PTActive'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clAqua
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
    end
    object Label59: TLabel
      Left = 56
      Top = 200
      Width = 225
      Height = 25
      AutoSize = False
      Caption = #1044#1072#1085#1085#1099#1077' '#1082#1086#1085#1092#1080#1075#1091#1088#1072#1094#1080#1080
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clLime
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = [fsUnderline]
      ParentFont = False
      WordWrap = True
    end
    object Label63: TLabel
      Left = 32
      Top = 80
      Width = 153
      Height = 25
      Alignment = taRightJustify
      AutoSize = False
      Caption = #1057#1082#1086#1088#1086#1089#1090#1100' '#1086#1087#1088#1086#1089#1072
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clMoneyGreen
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object LinkSpeed: TLabel
      Left = 200
      Top = 80
      Width = 86
      Height = 23
      Caption = 'LinkSpeed'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clAqua
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label9: TLabel
      Left = 64
      Top = 104
      Width = 121
      Height = 25
      Alignment = taRightJustify
      AutoSize = False
      Caption = #1060#1072#1082#1090#1080#1095#1077#1089#1082#1080
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clMoneyGreen
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object LastTime: TLabel
      Left = 200
      Top = 104
      Width = 74
      Height = 23
      Caption = 'LastTime'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clAqua
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 0
      Top = 232
      Width = 185
      Height = 25
      Alignment = taRightJustify
      AutoSize = False
      Caption = #1055#1077#1088#1080#1086#1076' '#1085#1072#1082#1086#1087#1083#1077#1085#1080#1103
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clMoneyGreen
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      WordWrap = True
    end
    object PeriodKind: TLabel
      Left = 200
      Top = 232
      Width = 89
      Height = 23
      Caption = 'PeriodKind'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clAqua
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 0
      Top = 256
      Width = 185
      Height = 25
      Alignment = taRightJustify
      AutoSize = False
      Caption = #1041#1072#1079#1072' '#1089#1095#1077#1090#1072
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clMoneyGreen
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      WordWrap = True
    end
    object BaseKind: TLabel
      Left = 200
      Top = 256
      Width = 76
      Height = 23
      Caption = 'BaseKind'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clAqua
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 0
      Top = 280
      Width = 185
      Height = 25
      Alignment = taRightJustify
      AutoSize = False
      Caption = #1058#1080#1087' '#1089#1095#1077#1090#1072
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clMoneyGreen
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      WordWrap = True
    end
    object CalcKind: TLabel
      Left = 200
      Top = 280
      Width = 71
      Height = 23
      Caption = 'CalcKind'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clAqua
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label10: TLabel
      Left = 0
      Top = 352
      Width = 185
      Height = 25
      Alignment = taRightJustify
      AutoSize = False
      Caption = #1044#1083#1103' '#1089#1073#1088#1086#1089#1072
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clMoneyGreen
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      WordWrap = True
    end
    object ResetVal: TLabel
      Left = 218
      Top = 352
      Width = 71
      Height = 23
      Alignment = taRightJustify
      Caption = 'ResetVal'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clAqua
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label14: TLabel
      Left = 0
      Top = 376
      Width = 185
      Height = 25
      Alignment = taRightJustify
      AutoSize = False
      Caption = #1044#1083#1103' '#1086#1090#1089#1077#1095#1082#1080
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clMoneyGreen
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      WordWrap = True
    end
    object CutoffVal: TLabel
      Left = 214
      Top = 376
      Width = 75
      Height = 23
      Alignment = taRightJustify
      Caption = 'CutoffVal'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clAqua
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label12: TLabel
      Left = 8
      Top = 440
      Width = 209
      Height = 25
      Alignment = taRightJustify
      AutoSize = False
      Caption = #1048#1085#1074#1077#1088#1089#1080#1103' '#1091#1087#1088#1072#1074#1083#1077#1085#1080#1103
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clMoneyGreen
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      WordWrap = True
    end
    object Invert: TLabel
      Left = 232
      Top = 440
      Width = 50
      Height = 23
      Caption = 'Invert'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clAqua
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label13: TLabel
      Left = 0
      Top = 400
      Width = 185
      Height = 25
      Alignment = taRightJustify
      AutoSize = False
      Caption = #1056#1072#1089#1095#1077#1090#1085#1086#1077' '#1074#1088#1077#1084#1103', '#1095'.'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clMoneyGreen
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      WordWrap = True
    end
    object ShiftHour: TLabel
      Left = 210
      Top = 400
      Width = 79
      Height = 23
      Alignment = taRightJustify
      Caption = 'ShiftHour'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clAqua
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
  end
  object Panel6: TPanel
    Left = 0
    Top = 37
    Width = 630
    Height = 708
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 2
    object AlarmsPanel: TPanel
      Left = 0
      Top = 0
      Width = 630
      Height = 536
      Align = alClient
      BevelOuter = bvNone
      Color = clBlack
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clMoneyGreen
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object Label78: TLabel
        Left = 32
        Top = 16
        Width = 441
        Height = 25
        Alignment = taCenter
        AutoSize = False
        Caption = #1043#1088#1072#1085#1080#1094#1099' '#1072#1074#1072#1088#1080#1081#1085#1099#1093' '#1080' '#1087#1088#1077#1076#1072#1074#1072#1088#1080#1081#1085#1099#1093' '#1079#1085#1072#1095#1077#1085#1080#1081
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clLime
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = [fsUnderline]
        ParentFont = False
        WordWrap = True
      end
      object Label79: TLabel
        Left = 40
        Top = 96
        Width = 195
        Height = 23
        Hint = 'PVHHTP'
        Caption = #1042#1085#1077#1096#1085#1077#1077' '#1091#1087#1088#1072#1074#1083#1077#1085#1080#1077':'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMoneyGreen
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
      end
      object DigWork: TLabel
        Left = 248
        Top = 96
        Width = 113
        Height = 25
        AutoSize = False
        Caption = 'DigWork'
        Color = clBlack
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clAqua
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
        OnDblClick = DigWorkDblClick
        OnMouseEnter = PVHHTPMouseEnter
        OnMouseLeave = PVHHTPMouseLeave
      end
      object DigWork_Val: TLabel
        Left = 370
        Top = 96
        Width = 103
        Height = 25
        AutoSize = False
        Caption = 'DigWork_Val'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWhite
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label3: TLabel
        Left = 40
        Top = 72
        Width = 165
        Height = 23
        Hint = 'PVHHTP'
        Caption = #1048#1089#1090#1086#1095#1085#1080#1082' '#1088#1072#1089#1093#1086#1076#1072':'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMoneyGreen
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
      end
      object AnaWork: TLabel
        Left = 248
        Top = 72
        Width = 113
        Height = 25
        AutoSize = False
        Caption = 'AnaWork'
        Color = clBlack
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clAqua
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
        OnDblClick = AnaWorkDblClick
        OnMouseEnter = PVHHTPMouseEnter
        OnMouseLeave = PVHHTPMouseLeave
      end
      object AnaWork_Val: TLabel
        Left = 370
        Top = 72
        Width = 103
        Height = 25
        AutoSize = False
        Caption = 'AnaWork_Val'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWhite
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label2: TLabel
        Left = 80
        Top = 136
        Width = 137
        Height = 23
        Caption = #1044#1072#1085#1085#1099#1077' '#1075#1088#1091#1087#1087#1099
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clLime
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = [fsUnderline]
        ParentFont = False
      end
    end
    object Panel3: TPanel
      Left = 0
      Top = 625
      Width = 630
      Height = 83
      Align = alBottom
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
      object Entity: TLabel
        Left = 192
        Top = 0
        Width = 42
        Height = 23
        Caption = '------'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clAqua
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label61: TLabel
        Left = 24
        Top = 0
        Width = 154
        Height = 23
        Hint = 'PTNAME'
        Caption = #1064#1080#1092#1088' '#1087#1072#1088#1072#1084#1077#1090#1088#1072
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMoneyGreen
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
      end
      object Label1: TLabel
        Left = 24
        Top = 24
        Width = 133
        Height = 23
        Caption = #1058#1080#1087' '#1087#1072#1088#1072#1084#1077#1090#1088#1072
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMoneyGreen
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object LabelParameter: TLabel
        Left = 192
        Top = 24
        Width = 158
        Height = 23
        Caption = #1040#1085#1072#1083#1086#1075#1086#1074#1086#1077' '#1095#1080#1089#1083#1086
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clAqua
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
    end
    object StatusPanel: TPanel
      Left = 0
      Top = 536
      Width = 630
      Height = 89
      Align = alBottom
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 2
      object Label11: TLabel
        Left = 16
        Top = 0
        Width = 73
        Height = 25
        Alignment = taRightJustify
        AutoSize = False
        Caption = #1057#1090#1072#1090#1091#1089':'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMoneyGreen
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object StatusListBox: TLabel
        Left = 16
        Top = 24
        Width = 505
        Height = 57
        AutoSize = False
        Color = clBlack
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clRed
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        WordWrap = True
      end
    end
  end
end
