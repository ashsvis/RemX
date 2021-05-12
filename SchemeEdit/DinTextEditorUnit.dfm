object DinTextEditorForm: TDinTextEditorForm
  Left = 279
  Top = 157
  BorderStyle = bsDialog
  Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1101#1083#1077#1084#1077#1085#1090#1072' "'#1044#1080#1085#1072#1084#1080#1095#1077#1089#1082#1080#1081' '#1090#1077#1082#1089#1090'"'
  ClientHeight = 480
  ClientWidth = 564
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
    Width = 353
    Height = 465
    Caption = #1057#1074#1086#1081#1089#1090#1074#1072
    TabOrder = 0
    object Bevel3: TBevel
      Left = 8
      Top = 93
      Width = 337
      Height = 92
    end
    object Bevel1: TBevel
      Left = 8
      Top = 17
      Width = 81
      Height = 69
    end
    object Label3: TLabel
      Left = 16
      Top = 136
      Width = 88
      Height = 14
      Caption = #1058#1077#1082#1089#1090' '#1085#1072#1076#1087#1080#1089#1080':'
    end
    object Label2: TLabel
      Left = 224
      Top = 24
      Width = 48
      Height = 23
      AutoSize = False
      Caption = #1064#1080#1088#1080#1085#1072':'
      Layout = tlCenter
    end
    object Label4: TLabel
      Left = 224
      Top = 56
      Width = 44
      Height = 23
      AutoSize = False
      Caption = #1042#1099#1089#1086#1090#1072':'
      Layout = tlCenter
    end
    object Label5: TLabel
      Left = 104
      Top = 24
      Width = 48
      Height = 23
      AutoSize = False
      Caption = #1057#1083#1077#1074#1072':'
      Layout = tlCenter
    end
    object Label6: TLabel
      Left = 104
      Top = 56
      Width = 44
      Height = 23
      AutoSize = False
      Caption = #1057#1074#1077#1088#1093#1091':'
      Layout = tlCenter
    end
    object Label7: TLabel
      Left = 16
      Top = 96
      Width = 65
      Height = 14
      Caption = #1062#1074#1077#1090' '#1092#1086#1085#1072':'
    end
    object Bevel2: TBevel
      Left = 96
      Top = 17
      Width = 249
      Height = 69
    end
    object Label11: TLabel
      Left = 208
      Top = 192
      Width = 78
      Height = 14
      Caption = #1048#1084#1103' '#1087#1086#1079#1080#1094#1080#1080':'
    end
    object Bevel4: TBevel
      Left = 200
      Top = 191
      Width = 9
      Height = 42
      Shape = bsLeftLine
    end
    object Label12: TLabel
      Left = 224
      Top = 96
      Width = 44
      Height = 14
      Caption = #1064#1088#1080#1092#1090':'
    end
    object cbPanel: TCheckBox
      Left = 16
      Top = 24
      Width = 65
      Height = 17
      Caption = #1055#1072#1085#1077#1083#1100
      TabOrder = 0
      OnClick = cbPanelClick
    end
    object cbSolid: TCheckBox
      Left = 16
      Top = 56
      Width = 65
      Height = 17
      Caption = #1060#1086#1085
      TabOrder = 1
      OnClick = cbSolidClick
    end
    object edText: TEdit
      Left = 16
      Top = 152
      Width = 321
      Height = 22
      TabOrder = 7
      OnChange = edTextChange
      OnKeyDown = edTextKeyDown
    end
    object seWidth: TSpinEdit
      Left = 280
      Top = 24
      Width = 55
      Height = 23
      Ctl3D = True
      MaxValue = 1024
      MinValue = 1
      ParentCtl3D = False
      TabOrder = 4
      Value = 1
      OnChange = seWidthChange
    end
    object seHeight: TSpinEdit
      Left = 280
      Top = 56
      Width = 55
      Height = 23
      Ctl3D = True
      MaxValue = 703
      MinValue = 1
      ParentCtl3D = False
      TabOrder = 5
      Value = 1
      OnChange = seHeightChange
    end
    object buFont: TButton
      Left = 224
      Top = 112
      Width = 113
      Height = 25
      Caption = #1064#1088#1080#1092#1090'...'
      TabOrder = 6
      OnClick = buFontClick
    end
    object seLeft: TSpinEdit
      Left = 160
      Top = 24
      Width = 55
      Height = 23
      Ctl3D = True
      MaxValue = 0
      MinValue = 0
      ParentCtl3D = False
      TabOrder = 2
      Value = 1
    end
    object seTop: TSpinEdit
      Left = 160
      Top = 56
      Width = 55
      Height = 23
      Ctl3D = True
      MaxValue = 0
      MinValue = 0
      ParentCtl3D = False
      TabOrder = 3
      Value = 1
    end
    object gbState0: TGroupBox
      Left = 8
      Top = 240
      Width = 337
      Height = 105
      Caption = ' '#1055#1088#1080' "0" '
      TabOrder = 10
      object Label1: TLabel
        Left = 8
        Top = 16
        Width = 111
        Height = 14
        Caption = #1062#1074#1077#1090' '#1092#1086#1085#1072' '#1087#1088#1080' "0":'
      end
      object Label8: TLabel
        Left = 8
        Top = 56
        Width = 134
        Height = 14
        Caption = #1058#1077#1082#1089#1090' '#1085#1072#1076#1087#1080#1089#1080' '#1087#1088#1080' "0":'
      end
      object Label13: TLabel
        Left = 216
        Top = 16
        Width = 90
        Height = 14
        Caption = #1064#1088#1080#1092#1090' '#1087#1088#1080' "0":'
      end
      object Button0: TButton
        Left = 216
        Top = 32
        Width = 113
        Height = 25
        Caption = #1064#1088#1080#1092#1090' '#1087#1088#1080' "0"'
        TabOrder = 0
        OnClick = Button0Click
      end
      object Edit0: TEdit
        Left = 8
        Top = 72
        Width = 321
        Height = 22
        TabOrder = 1
        OnChange = Edit0Change
        OnKeyDown = Edit0KeyDown
      end
      object btColorBox0: TBitBtn
        Left = 8
        Top = 32
        Width = 201
        Height = 25
        Caption = #1042#1099#1073#1088#1072#1090#1100'...'
        TabOrder = 2
        OnClick = btColorBoxClick
        Margin = 4
      end
    end
    object gbState1: TGroupBox
      Left = 8
      Top = 352
      Width = 337
      Height = 105
      Caption = ' '#1055#1088#1080' "1" '
      TabOrder = 11
      object Label9: TLabel
        Left = 8
        Top = 16
        Width = 111
        Height = 14
        Caption = #1062#1074#1077#1090' '#1092#1086#1085#1072' '#1087#1088#1080' "1":'
      end
      object Label10: TLabel
        Left = 8
        Top = 56
        Width = 134
        Height = 14
        Caption = #1058#1077#1082#1089#1090' '#1085#1072#1076#1087#1080#1089#1080' '#1087#1088#1080' "1":'
      end
      object Label14: TLabel
        Left = 216
        Top = 16
        Width = 90
        Height = 14
        Caption = #1064#1088#1080#1092#1090' '#1087#1088#1080' "1":'
      end
      object Button1: TButton
        Left = 216
        Top = 32
        Width = 113
        Height = 25
        Caption = #1064#1088#1080#1092#1090' '#1087#1088#1080' "1"'
        TabOrder = 0
        OnClick = Button1Click
      end
      object Edit1: TEdit
        Left = 8
        Top = 72
        Width = 321
        Height = 22
        TabOrder = 1
        OnChange = Edit1Change
        OnKeyDown = Edit1KeyDown
      end
      object btColorBox1: TBitBtn
        Left = 8
        Top = 32
        Width = 201
        Height = 25
        Caption = #1042#1099#1073#1088#1072#1090#1100'...'
        TabOrder = 2
        OnClick = btColorBoxClick
        Margin = 4
      end
    end
    object edPtName: TEdit
      Left = 208
      Top = 208
      Width = 129
      Height = 22
      Cursor = crHandPoint
      ReadOnly = True
      TabOrder = 9
      OnClick = edPtNameClick
    end
    object cbBorder: TCheckBox
      Left = 16
      Top = 190
      Width = 57
      Height = 17
      Caption = #1056#1072#1084#1082#1072
      TabOrder = 8
      OnClick = cbBorderClick
    end
    object btColorBox: TBitBtn
      Left = 16
      Top = 111
      Width = 201
      Height = 25
      Caption = #1042#1099#1073#1088#1072#1090#1100'...'
      TabOrder = 12
      OnClick = btColorBoxClick
      Margin = 4
    end
    object btBorderColorBox: TBitBtn
      Left = 16
      Top = 208
      Width = 177
      Height = 25
      Caption = #1042#1099#1073#1088#1072#1090#1100'...'
      TabOrder = 13
      OnClick = btColorBoxClick
      Margin = 4
    end
  end
  object GroupBox: TGroupBox
    Left = 368
    Top = 8
    Width = 190
    Height = 137
    Caption = ' '#1054#1073#1088#1072#1079#1077#1094' '#1089#1090#1072#1090#1080#1095#1077#1089#1082#1080#1081' '
    TabOrder = 1
    object ScrollBox: TScrollBox
      Left = 8
      Top = 16
      Width = 173
      Height = 113
      Color = clGray
      ParentColor = False
      TabOrder = 0
    end
  end
  object CloseButton: TButton
    Left = 369
    Top = 442
    Width = 87
    Height = 25
    Caption = #1042#1074#1086#1076
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object CancelButton: TButton
    Left = 465
    Top = 442
    Width = 87
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
  object GroupBox1: TGroupBox
    Left = 366
    Top = 152
    Width = 190
    Height = 137
    Caption = ' '#1054#1073#1088#1072#1079#1077#1094' '#1087#1088#1080' "0" '
    TabOrder = 4
    object ScrollBox0: TScrollBox
      Left = 8
      Top = 16
      Width = 173
      Height = 113
      Color = clGray
      ParentColor = False
      TabOrder = 0
    end
  end
  object GroupBox2: TGroupBox
    Left = 366
    Top = 296
    Width = 190
    Height = 137
    Caption = ' '#1054#1073#1088#1072#1079#1077#1094' '#1087#1088#1080' "1" '
    TabOrder = 5
    object ScrollBox1: TScrollBox
      Left = 8
      Top = 16
      Width = 173
      Height = 113
      Color = clGray
      ParentColor = False
      TabOrder = 0
    end
  end
  object ApplicationEvents: TApplicationEvents
    OnIdle = ApplicationEventsIdle
    Left = 88
    Top = 8
  end
  object FontDialog: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 312
    Top = 104
  end
  object Fresh: TTimer
    Enabled = False
    Interval = 500
    OnTimer = FreshTimer
    Left = 384
    Top = 40
  end
  object ImageList1: TImageList
    Left = 440
    Top = 40
  end
  object pmColorSelect: TPopupMenu
    Images = ImageList1
    OnPopup = pmColorSelectPopup
    Left = 440
    Top = 72
  end
  object ColorDialog1: TColorDialog
    Left = 440
    Top = 104
  end
end
