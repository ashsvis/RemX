object VirtVCPaspForm: TVirtVCPaspForm
  Left = 231
  Top = 168
  BorderStyle = bsSingle
  Caption = 'VirtVCPaspForm'
  ClientHeight = 569
  ClientWidth = 997
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
    Width = 997
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
      Left = 584
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
    Height = 532
    Align = alLeft
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object PTName: TLabel
      Left = 32
      Top = 336
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
    object LabelPV: TLabel
      Left = 24
      Top = 416
      Width = 21
      Height = 23
      Hint = 'PV'
      Caption = 'PV'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clMoneyGreen
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
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
      OnMouseDown = StateALMMouseDown
      OnMouseEnter = StateALMMouseEnter
      OnMouseLeave = StateALMMouseLeave
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
      Caption = #1054#1058#1050#1056#1067#1058#1054
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
      Caption = #1047#1040#1050#1056#1067#1058#1054
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clMaroon
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object EnterButton: TButton
      Left = 48
      Top = 472
      Width = 113
      Height = 33
      Cursor = crHandPoint
      Caption = #1050#1086#1084#1072#1085#1076#1072
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clSilver
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = EnterButtonClick
    end
  end
  object ConfigPanel: TPanel
    Left = 679
    Top = 37
    Width = 318
    Height = 532
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
    object LabelAlEnbSt: TLabel
      Left = 40
      Top = 80
      Width = 129
      Height = 25
      Hint = 'LOGGED'
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
      ShowHint = True
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
    object LabelPTAsked: TLabel
      Left = 48
      Top = 104
      Width = 121
      Height = 25
      Hint = 'ASKED'
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
      ShowHint = True
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
    Width = 478
    Height = 532
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 3
    object AlarmsPanel: TPanel
      Left = 0
      Top = 0
      Width = 478
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
        Caption = #1055#1086#1076#1082#1083#1102#1095#1077#1085#1080#1103' '#1080' '#1089#1080#1075#1085#1072#1083#1080#1079#1072#1094#1080#1103
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
        Width = 188
        Height = 23
        Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' "'#1040#1042#1040#1056#1048#1071'":'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMoneyGreen
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
      end
      object StateALM: TLabel
        Left = 216
        Top = 56
        Width = 121
        Height = 25
        AutoSize = False
        Caption = 'StateALM'
        Color = clBlack
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clAqua
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
        OnDblClick = StateALMDblClick
        OnMouseDown = StateALMMouseDown
        OnMouseEnter = StateALMMouseEnter
        OnMouseLeave = StateALMMouseLeave
      end
      object Label2: TLabel
        Left = 0
        Top = 80
        Width = 204
        Height = 23
        Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' "'#1054#1058#1050#1056#1067#1058#1054'":'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMoneyGreen
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
      end
      object StateON: TLabel
        Left = 216
        Top = 80
        Width = 121
        Height = 25
        AutoSize = False
        Caption = 'StateON'
        Color = clBlack
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clAqua
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
        OnDblClick = StateALMDblClick
        OnMouseDown = StateALMMouseDown
        OnMouseEnter = StateALMMouseEnter
        OnMouseLeave = StateALMMouseLeave
      end
      object Label4: TLabel
        Left = 0
        Top = 104
        Width = 201
        Height = 23
        Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' "'#1047#1040#1050#1056#1067#1058#1054'":'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMoneyGreen
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
      end
      object StateOFF: TLabel
        Left = 216
        Top = 104
        Width = 121
        Height = 25
        AutoSize = False
        Caption = 'StateOFF'
        Color = clBlack
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clAqua
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
        OnDblClick = StateALMDblClick
        OnMouseDown = StateALMMouseDown
        OnMouseEnter = StateALMMouseEnter
        OnMouseLeave = StateALMMouseLeave
      end
      object Label3: TLabel
        Left = 0
        Top = 144
        Width = 186
        Height = 23
        Caption = #1050#1086#1084#1072#1085#1076#1072' "'#1054#1058#1050#1056#1067#1058#1068'":'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMoneyGreen
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
      end
      object Label5: TLabel
        Left = 0
        Top = 168
        Width = 183
        Height = 23
        Caption = #1050#1086#1084#1072#1085#1076#1072' "'#1047#1040#1050#1056#1067#1058#1068'":'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clMoneyGreen
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
      end
      object CommON: TLabel
        Left = 216
        Top = 144
        Width = 121
        Height = 25
        AutoSize = False
        Caption = 'CommON'
        Color = clBlack
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clAqua
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
        OnDblClick = StateALMDblClick
        OnMouseDown = StateALMMouseDown
        OnMouseEnter = StateALMMouseEnter
        OnMouseLeave = StateALMMouseLeave
      end
      object CommOFF: TLabel
        Left = 216
        Top = 168
        Width = 121
        Height = 25
        AutoSize = False
        Caption = 'CommOFF'
        Color = clBlack
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clAqua
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
        OnDblClick = StateALMDblClick
        OnMouseDown = StateALMMouseDown
        OnMouseEnter = StateALMMouseEnter
        OnMouseLeave = StateALMMouseLeave
      end
      object ValStateALM: TLabel
        Left = 352
        Top = 56
        Width = 105
        Height = 25
        AutoSize = False
        Caption = 'ValStateALM'
        Color = clBlack
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWhite
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object ValStateON: TLabel
        Left = 352
        Top = 80
        Width = 105
        Height = 25
        AutoSize = False
        Caption = 'ValStateON'
        Color = clBlack
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWhite
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object ValStateOFF: TLabel
        Left = 352
        Top = 104
        Width = 105
        Height = 25
        AutoSize = False
        Caption = 'ValStateOFF'
        Color = clBlack
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWhite
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object ValCommON: TLabel
        Left = 352
        Top = 144
        Width = 105
        Height = 25
        AutoSize = False
        Caption = 'ValCommON'
        Color = clBlack
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWhite
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object ValCommOFF: TLabel
        Left = 352
        Top = 168
        Width = 105
        Height = 25
        AutoSize = False
        Caption = 'ValCommOFF'
        Color = clBlack
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWhite
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
    end
    object Panel3: TPanel
      Left = 0
      Top = 449
      Width = 478
      Height = 83
      Align = alBottom
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
      object Entity: TLabel
        Left = 168
        Top = 0
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
        Left = 0
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
        Left = 168
        Top = 24
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
    end
    object StatusPanel: TPanel
      Left = 0
      Top = 273
      Width = 478
      Height = 176
      Align = alBottom
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 2
      DesignSize = (
        478
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
        Width = 414
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