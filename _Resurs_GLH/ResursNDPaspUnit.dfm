object ResursNDPaspForm: TResursNDPaspForm
  Left = 193
  Top = 110
  BorderStyle = bsSingle
  Caption = 'ResursNDPaspForm'
  ClientHeight = 733
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
      Left = 581
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
    Height = 696
    Align = alRight
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object Label55: TLabel
      Left = 80
      Top = 24
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
    Height = 696
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 2
    object Label3: TLabel
      Left = 48
      Top = 200
      Width = 321
      Height = 25
      AutoSize = False
      Caption = #1044#1072#1085#1085#1099#1077' '#1091#1089#1090#1088#1086#1081#1089#1090#1074#1072
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clLime
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = [fsUnderline]
      ParentFont = False
      WordWrap = True
    end
    object Label5: TLabel
      Left = 48
      Top = 16
      Width = 369
      Height = 25
      AutoSize = False
      Caption = #1044#1072#1085#1085#1099#1077' '#1082#1086#1085#1092#1080#1075#1091#1088#1072#1094#1080#1080' '#1091#1089#1090#1088#1086#1081#1089#1090#1074#1072
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clLime
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = [fsUnderline]
      ParentFont = False
      WordWrap = True
    end
    object Label2: TLabel
      Left = 32
      Top = 80
      Width = 141
      Height = 23
      Caption = #1042#1088#1077#1084#1103' '#1087#1088#1080#1073#1086#1088#1072':'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clMoneyGreen
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object GLHTime: TLabel
      Left = 216
      Top = 80
      Width = 385
      Height = 25
      AutoSize = False
      Caption = '----'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clAqua
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label12: TLabel
      Left = 32
      Top = 104
      Width = 199
      Height = 23
      Caption = #1058#1077#1082#1091#1097#1080#1081' '#1085#1086#1084#1077#1088' '#1073#1083#1086#1082#1072':'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clMoneyGreen
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object GLHBlockNo: TLabel
      Left = 256
      Top = 104
      Width = 345
      Height = 25
      AutoSize = False
      Caption = '----'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clAqua
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 32
      Top = 128
      Width = 205
      Height = 23
      Caption = #1044#1083#1080#1085#1072' '#1090#1077#1082#1091#1097#1077#1075#1086' '#1073#1083#1086#1082#1072':'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clMoneyGreen
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object GLHBlockLength: TLabel
      Left = 256
      Top = 128
      Width = 345
      Height = 25
      AutoSize = False
      Caption = '----'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clAqua
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 32
      Top = 56
      Width = 167
      Height = 23
      Caption = #1058#1080#1087' '#1073#1083#1086#1082#1072' '#1076#1072#1085#1085#1099#1093':'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clMoneyGreen
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object GLHBlockType: TLabel
      Left = 216
      Top = 56
      Width = 465
      Height = 25
      AutoSize = False
      Caption = '----'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clAqua
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Panel3: TPanel
      Left = 0
      Top = 581
      Width = 474
      Height = 115
      Align = alBottom
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      object Entity: TLabel
        Left = 224
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
        Left = 224
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
      object Label4: TLabel
        Left = 32
        Top = 48
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
        Left = 224
        Top = 48
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
    end
    object StatusPanel: TPanel
      Left = 0
      Top = 509
      Width = 474
      Height = 72
      Align = alBottom
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
      object Label11: TLabel
        Left = 0
        Top = 0
        Width = 73
        Height = 33
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
        Width = 634
        Height = 41
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
    object ShowMoreButton: TButton
      Left = 24
      Top = 248
      Width = 281
      Height = 25
      Caption = #1055#1086#1076#1088#1086#1073#1085#1086'...'
      TabOrder = 2
      Visible = False
      OnClick = ShowMoreButtonClick
    end
    object ConfigChannelsButton: TButton
      Left = 24
      Top = 288
      Width = 281
      Height = 25
      Caption = #1048#1089#1093#1086#1076#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1082#1072#1085#1072#1083#1072#1084'...'
      TabOrder = 3
      Visible = False
      OnClick = ConfigChannelsButtonClick
    end
    object ConfigPointsButton: TButton
      Left = 24
      Top = 328
      Width = 281
      Height = 25
      Caption = #1048#1089#1093#1086#1076#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1090#1086#1095#1082#1072#1084' '#1091#1095#1077#1090#1072'...'
      TabOrder = 4
      Visible = False
      OnClick = ConfigPointsButtonClick
    end
    object ConfigGroupsButton: TButton
      Left = 24
      Top = 368
      Width = 281
      Height = 25
      Caption = #1048#1089#1093#1086#1076#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1075#1088#1091#1087#1087#1072#1084'...'
      TabOrder = 5
      Visible = False
      OnClick = ConfigGroupsButtonClick
    end
  end
end
