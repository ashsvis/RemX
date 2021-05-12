object DinJumperEditorForm: TDinJumperEditorForm
  Left = 291
  Top = 426
  ActiveControl = edText
  BorderStyle = bsDialog
  Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1101#1083#1077#1084#1077#1085#1090#1072' "'#1055#1077#1088#1077#1093#1086#1076' '#1085#1072' '#1089#1093#1077#1084#1091'..."'
  ClientHeight = 265
  ClientWidth = 566
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object GroupBox: TGroupBox
    Left = 368
    Top = 8
    Width = 190
    Height = 209
    Caption = ' '#1054#1073#1088#1072#1079#1077#1094
    TabOrder = 1
    object ScrollBox: TScrollBox
      Left = 8
      Top = 16
      Width = 173
      Height = 185
      Color = clGray
      ParentColor = False
      TabOrder = 0
    end
  end
  object CloseButton: TButton
    Left = 373
    Top = 228
    Width = 87
    Height = 25
    Caption = #1042#1074#1086#1076
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object PropertyBox: TGroupBox
    Left = 8
    Top = 8
    Width = 353
    Height = 249
    Caption = #1057#1074#1086#1081#1089#1090#1074#1072
    TabOrder = 0
    object Bevel3: TBevel
      Left = 8
      Top = 93
      Width = 337
      Height = 147
    end
    object Bevel1: TBevel
      Left = 8
      Top = 17
      Width = 81
      Height = 69
    end
    object Label3: TLabel
      Left = 16
      Top = 144
      Width = 88
      Height = 14
      Caption = #1058#1077#1082#1089#1090' '#1085#1072#1076#1087#1080#1089#1080':'
    end
    object Label1: TLabel
      Left = 16
      Top = 192
      Width = 144
      Height = 14
      Caption = #1055#1077#1088#1077#1093#1086#1076' '#1085#1072' '#1084#1085#1077#1084#1086#1089#1093#1077#1084#1091':'
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
    object Label8: TLabel
      Left = 200
      Top = 192
      Width = 44
      Height = 14
      Caption = #1044#1086#1089#1090#1091#1087':'
    end
    object Label9: TLabel
      Left = 208
      Top = 96
      Width = 44
      Height = 14
      Caption = #1064#1088#1080#1092#1090':'
    end
    object cbFramed: TCheckBox
      Left = 16
      Top = 24
      Width = 57
      Height = 17
      Caption = #1056#1072#1084#1082#1072
      TabOrder = 0
      OnClick = cbFramedClick
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
      Top = 160
      Width = 321
      Height = 22
      TabOrder = 7
      OnChange = edTextChange
      OnKeyDown = edTextKeyDown
    end
    object edScheme: TEdit
      Left = 16
      Top = 208
      Width = 177
      Height = 22
      Cursor = crHandPoint
      ReadOnly = True
      TabOrder = 8
      OnMouseDown = edSchemeMouseDown
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
      Left = 208
      Top = 112
      Width = 129
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
    object cbEnterLevel: TComboBox
      Left = 200
      Top = 208
      Width = 137
      Height = 22
      Style = csDropDownList
      ItemHeight = 14
      ItemIndex = 0
      TabOrder = 9
      Text = #1042#1089#1077#1084
      OnChange = cbEnterLevelChange
      Items.Strings = (
        #1042#1089#1077#1084
        #1054#1087#1077#1088#1072#1090#1086#1088#1099
        #1055#1088#1080#1073#1086#1088#1080#1089#1090#1099
        #1048#1085#1078#1077#1085#1077#1088#1099'-'#1090#1077#1093#1085#1086#1083#1086#1075#1080
        #1044#1080#1089#1087#1077#1090#1095#1077#1088#1099
        #1048#1085#1078#1077#1085#1077#1088#1099' '#1040#1057#1059' '#1058#1055
        #1055#1088#1086#1075#1088#1072#1084#1084#1080#1089#1090#1099)
    end
    object btColorBox: TBitBtn
      Left = 13
      Top = 112
      Width = 180
      Height = 25
      Caption = #1042#1099#1073#1088#1072#1090#1100'...'
      TabOrder = 10
      OnClick = btColorBoxClick
      Margin = 4
    end
  end
  object CancelButton: TButton
    Left = 469
    Top = 228
    Width = 87
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
  object FontDialog: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 344
    Top = 88
  end
  object pmColorSelect: TPopupMenu
    Images = ImageList1
    OnPopup = pmColorSelectPopup
    Left = 144
    Top = 112
  end
  object ImageList1: TImageList
    Left = 112
    Top = 112
  end
  object ColorDialog1: TColorDialog
    Left = 176
    Top = 112
  end
  object ApplicationEvents: TApplicationEvents
    OnIdle = ApplicationEventsIdle
    Left = 96
    Top = 32
  end
end
