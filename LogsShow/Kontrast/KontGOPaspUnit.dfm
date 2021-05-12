object KontGOPaspForm: TKontGOPaspForm
  Left = 299
  Top = 247
  BorderStyle = bsSingle
  Caption = 'KontGOPaspForm'
  ClientHeight = 531
  ClientWidth = 792
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
  object ConfigPanel: TPanel
    Left = 474
    Top = 37
    Width = 318
    Height = 494
    Align = alRight
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
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
    object Label63: TLabel
      Left = 16
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
      Left = 184
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
      Left = 48
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
      Left = 184
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
  end
  object Panel6: TPanel
    Left = 0
    Top = 37
    Width = 474
    Height = 494
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 2
    object AlarmsPanel: TPanel
      Left = 0
      Top = 0
      Width = 474
      Height = 309
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
      object Label2: TLabel
        Left = 80
        Top = 8
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
      Top = 400
      Width = 474
      Height = 94
      Align = alBottom
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
      object Entity: TLabel
        Left = 200
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
        Left = 32
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
        Left = 32
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
        Left = 200
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
      object Label3: TLabel
        Left = 32
        Top = 48
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
        Left = 200
        Top = 48
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
    end
    object StatusPanel: TPanel
      Left = 0
      Top = 309
      Width = 474
      Height = 91
      Align = alBottom
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 2
      DesignSize = (
        474
        91)
      object Label11: TLabel
        Left = 8
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
        Width = 209
        Height = 65
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
