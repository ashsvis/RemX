object ModbusDOPaspForm: TModbusDOPaspForm
  Left = 292
  Top = 221
  BorderStyle = bsSingle
  Caption = 'ModbusDOPaspForm'
  ClientHeight = 648
  ClientWidth = 792
  Color = clBlack
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clSilver
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 792
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
      ShowHint = False
    end
    object PTDesc: TLabel
      Left = 168
      Top = 8
      Width = 408
      Height = 23
      Caption = 'WWWWWWWWWWWWWWWWWWWWWWWW'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clAqua
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
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
  object PVPanel: TPanel
    Left = 0
    Top = 37
    Width = 201
    Height = 611
    Align = alLeft
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object PTName: TLabel
      Left = 32
      Top = 336
      Width = 137
      Height = 25
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
      ShowHint = False
    end
    object LabelPV: TLabel
      Left = 24
      Top = 416
      Width = 21
      Height = 23
      Caption = 'PV'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clMoneyGreen
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
    end
    object PV: TLabel
      Left = 56
      Top = 416
      Width = 113
      Height = 25
      Alignment = taCenter
      AutoSize = False
      Caption = 'PV'
      Color = clBlack
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clAqua
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
      OnMouseDown = AlarmOnMouseDown
      OnMouseEnter = AlarmOnMouseEnter
      OnMouseLeave = AlarmOnMouseLeave
    end
    object ShapeON: TShape
      Left = 64
      Top = 48
      Width = 57
      Height = 57
      Brush.Color = clBlack
      Pen.Color = clMoneyGreen
    end
    object LabelON: TLabel
      Left = 8
      Top = 120
      Width = 177
      Height = 25
      Alignment = taCenter
      AutoSize = False
      Caption = #1042#1050#1051
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clGreen
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object ShapeOFF: TShape
      Left = 64
      Top = 192
      Width = 57
      Height = 57
      Brush.Color = clBlack
      Pen.Color = clMoneyGreen
    end
    object LabelOFF: TLabel
      Left = 8
      Top = 264
      Width = 177
      Height = 25
      Alignment = taCenter
      AutoSize = False
      Caption = #1042#1067#1050#1051
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clMaroon
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
  end
  object ConfigPanel: TPanel
    Left = 474
    Top = 37
    Width = 318
    Height = 611
    Align = alRight
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 2
    object Label55: TLabel
      Left = 80
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
      Left = 48
      Top = 56
      Width = 120
      Height = 25
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
      ShowHint = False
    end
    object LabelAlEnbSt: TLabel
      Left = 40
      Top = 80
      Width = 129
      Height = 25
      Alignment = taRightJustify
      AutoSize = False
      Caption = #1057#1080#1075#1085#1072#1083#1080#1079#1072#1094#1080#1103
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clMoneyGreen
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      WordWrap = True
    end
    object PTActive: TLabel
      Left = 184
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
    object AlEnbSt: TLabel
      Left = 184
      Top = 80
      Width = 65
      Height = 23
      Hint = 'LOGGED'
      Caption = 'AlEnbSt'
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
      Left = 48
      Top = 224
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
    object Label60: TLabel
      Left = 8
      Top = 176
      Width = 161
      Height = 25
      Alignment = taRightJustify
      AutoSize = False
      Caption = #1048#1089#1093#1086#1076#1085#1099#1077' '#1076#1072#1085#1085#1099#1077
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clMoneyGreen
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object PVRAW: TLabel
      Left = 184
      Top = 176
      Width = 129
      Height = 25
      AutoSize = False
      Caption = 'PVRAW'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clAqua
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label63: TLabel
      Left = 16
      Top = 128
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
      Left = 184
      Top = 128
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
    object LabelFormatPV: TLabel
      Left = 0
      Top = 264
      Width = 169
      Height = 25
      Alignment = taRightJustify
      AutoSize = False
      Caption = #1048#1085#1074#1077#1088#1089#1080#1103' '#1076#1072#1085#1085#1099#1093
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clMoneyGreen
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      WordWrap = True
    end
    object Invert: TLabel
      Left = 184
      Top = 264
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
    object LabelPTAsked: TLabel
      Left = 48
      Top = 104
      Width = 121
      Height = 25
      Alignment = taRightJustify
      AutoSize = False
      Caption = #1050#1074#1080#1090#1080#1088#1091#1077#1084#1072#1103
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clMoneyGreen
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      WordWrap = True
    end
    object PTAsked: TLabel
      Left = 184
      Top = 104
      Width = 70
      Height = 23
      Hint = 'ASKED'
      Caption = 'PTAsked'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clAqua
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
    end
    object LabelSourcePV: TLabel
      Left = 32
      Top = 288
      Width = 137
      Height = 25
      Alignment = taRightJustify
      AutoSize = False
      Caption = #1048#1089#1090#1086#1095#1085#1080#1082' PV'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clMoneyGreen
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
    end
    object PVSource: TLabel
      Left = 184
      Top = 288
      Width = 79
      Height = 23
      Caption = 'PVSource'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clAqua
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      OnDblClick = PVSourceDblClick
    end
    object Label9: TLabel
      Left = 48
      Top = 152
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
      Left = 184
      Top = 152
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
  end
  object Panel6: TPanel
    Left = 201
    Top = 37
    Width = 273
    Height = 611
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 3
    object AlarmsPanel: TPanel
      Left = 0
      Top = 0
      Width = 273
      Height = 217
      Align = alTop
      BevelOuter = bvNone
      Color = clBlack
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clSilver
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object Label78: TLabel
        Left = 0
        Top = 16
        Width = 441
        Height = 25
        Alignment = taCenter
        AutoSize = False
        Caption = #1040#1074#1072#1088#1080#1081#1085#1099#1081' '#1078#1091#1088#1085#1072#1083
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clLime
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = [fsUnderline]
        ParentFont = False
        WordWrap = True
      end
      object Label79: TLabel
        Left = 0
        Top = 56
        Width = 295
        Height = 23
        Caption = #1057#1080#1075#1085#1072#1083' '#1087#1088#1080' '#1087#1077#1088#1077#1093#1086#1076#1077' '#1080#1079' "0" '#1074' "1"'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMoneyGreen
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
      end
      object Label80: TLabel
        Left = 0
        Top = 80
        Width = 295
        Height = 23
        Caption = #1057#1080#1075#1085#1072#1083' '#1087#1088#1080' '#1087#1077#1088#1077#1093#1086#1076#1077' '#1080#1079' "1" '#1074' "0"'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMoneyGreen
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
      end
      object AlarmOff: TLabel
        Left = 304
        Top = 80
        Width = 89
        Height = 25
        AutoSize = False
        Caption = 'AlarmOff'
        Color = clBlack
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clAqua
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
        OnMouseDown = AlarmOnMouseDown
        OnMouseEnter = AlarmOnMouseEnter
        OnMouseLeave = AlarmOnMouseLeave
      end
      object AlarmOn: TLabel
        Left = 304
        Top = 56
        Width = 89
        Height = 25
        AutoSize = False
        Caption = 'AlarmOn'
        Color = clBlack
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clAqua
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
        OnMouseDown = AlarmOnMouseDown
        OnMouseEnter = AlarmOnMouseEnter
        OnMouseLeave = AlarmOnMouseLeave
      end
      object Label2: TLabel
        Left = 0
        Top = 128
        Width = 441
        Height = 25
        Alignment = taCenter
        AutoSize = False
        Caption = #1046#1091#1088#1085#1072#1083' '#1087#1077#1088#1077#1082#1083#1102#1095#1077#1085#1080#1081
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clLime
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = [fsUnderline]
        ParentFont = False
        WordWrap = True
      end
      object Label3: TLabel
        Left = 0
        Top = 160
        Width = 331
        Height = 23
        Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1077' '#1087#1088#1080' '#1087#1077#1088#1077#1093#1086#1076#1077' '#1080#1079' "0" '#1074' "1"'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMoneyGreen
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
      end
      object SwitchOn: TLabel
        Left = 344
        Top = 160
        Width = 49
        Height = 25
        AutoSize = False
        Caption = 'SwitchOn'
        Color = clBlack
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clAqua
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
        OnMouseEnter = AlarmOnMouseEnter
        OnMouseLeave = AlarmOnMouseLeave
      end
      object Label5: TLabel
        Left = 0
        Top = 184
        Width = 331
        Height = 23
        Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1077' '#1087#1088#1080' '#1087#1077#1088#1077#1093#1086#1076#1077' '#1080#1079' "1" '#1074' "0"'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMoneyGreen
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
      end
      object SwitchOff: TLabel
        Left = 344
        Top = 184
        Width = 49
        Height = 25
        AutoSize = False
        Caption = 'SwitchOff'
        Color = clBlack
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clAqua
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
        OnMouseEnter = AlarmOnMouseEnter
        OnMouseLeave = AlarmOnMouseLeave
      end
    end
    object Panel3: TPanel
      Left = 0
      Top = 440
      Width = 273
      Height = 171
      Align = alBottom
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
      object Entity: TLabel
        Left = 168
        Top = 24
        Width = 47
        Height = 23
        Caption = 'Entity'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clAqua
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label61: TLabel
        Left = 0
        Top = 24
        Width = 154
        Height = 23
        Caption = #1064#1080#1092#1088' '#1087#1072#1088#1072#1084#1077#1090#1088#1072
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMoneyGreen
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
      end
      object Label1: TLabel
        Left = 0
        Top = 48
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
        Left = 168
        Top = 48
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
      object Label4: TLabel
        Left = 0
        Top = 72
        Width = 108
        Height = 23
        Caption = #1050#1072#1085#1072#1083' '#1089#1074#1103#1079#1080
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMoneyGreen
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Channel: TLabel
        Left = 168
        Top = 72
        Width = 68
        Height = 23
        Caption = 'Channel'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clAqua
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label6: TLabel
        Left = 0
        Top = 96
        Width = 105
        Height = 23
        Caption = #1050#1086#1085#1090#1088#1086#1083#1083#1077#1088
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMoneyGreen
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Node: TLabel
        Left = 168
        Top = 96
        Width = 44
        Height = 23
        Caption = 'Node'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clAqua
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label8: TLabel
        Left = 0
        Top = 120
        Width = 123
        Height = 23
        Caption = #1040#1076#1088#1077#1089' '#1076#1072#1085#1085#1099#1093
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMoneyGreen
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Address: TLabel
        Left = 168
        Top = 120
        Width = 66
        Height = 23
        Caption = 'Address'
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
      Top = 264
      Width = 273
      Height = 176
      Align = alBottom
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 2
      DesignSize = (
        273
        176)
      object Label11: TLabel
        Left = 0
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
        Left = 0
        Top = 24
        Width = 209
        Height = 153
        Anchors = [akLeft, akTop, akRight, akBottom]
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
