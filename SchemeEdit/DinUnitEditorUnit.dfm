object DinUnitEditorForm: TDinUnitEditorForm
  Left = 415
  Top = 206
  BorderStyle = bsDialog
  Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1101#1083#1077#1084#1077#1085#1090#1072' "'#1043#1088#1072#1092#1080#1095#1077#1089#1082#1080#1081' '#1102#1085#1080#1090'"'
  ClientHeight = 322
  ClientWidth = 513
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
    Top = 7
    Width = 277
    Height = 306
    Caption = #1057#1074#1086#1081#1089#1090#1074#1072
    TabOrder = 0
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
    object cbSolid: TCheckBox
      Left = 8
      Top = 136
      Width = 57
      Height = 17
      Caption = #1060#1086#1085
      TabOrder = 4
      OnClick = cbSolidClick
    end
    object cbBorder: TCheckBox
      Left = 8
      Top = 168
      Width = 57
      Height = 17
      Caption = #1056#1072#1084#1082#1072
      TabOrder = 5
      OnClick = cbBorderClick
    end
    object gbTerminator: TGroupBox
      Left = 8
      Top = 192
      Width = 257
      Height = 105
      Caption = ' '#1043#1088#1072#1076#1080#1077#1085#1090#1085#1072#1103' '#1079#1072#1083#1080#1074#1082#1072' '
      TabOrder = 6
      object Label7: TLabel
        Left = 96
        Top = 18
        Width = 90
        Height = 14
        Caption = #1054#1089#1085#1086#1074#1085#1086#1081' '#1094#1074#1077#1090':'
      end
      object Label1: TLabel
        Left = 96
        Top = 59
        Width = 68
        Height = 14
        Caption = #1062#1074#1077#1090' '#1073#1083#1080#1082#1072':'
      end
      object Label3: TLabel
        Left = 8
        Top = 19
        Width = 31
        Height = 14
        Caption = #1041#1083#1080#1082':'
      end
      object tbTerminator: TTrackBar
        Left = 8
        Top = 32
        Width = 33
        Height = 68
        Max = 99
        Min = 1
        Orientation = trVertical
        Frequency = 9
        Position = 70
        TabOrder = 0
        OnChange = tbTerminatorChange
      end
      object stTerminator: TStaticText
        Left = 48
        Top = 56
        Width = 34
        Height = 18
        Alignment = taCenter
        Caption = '70 %'
        TabOrder = 1
      end
      object btDarkColor: TBitBtn
        Left = 96
        Top = 33
        Width = 153
        Height = 25
        Caption = #1042#1099#1073#1088#1072#1090#1100'...'
        TabOrder = 2
        OnClick = btColorClick
        Margin = 4
      end
      object btLightColor: TBitBtn
        Left = 96
        Top = 74
        Width = 153
        Height = 25
        Caption = #1042#1099#1073#1088#1072#1090#1100'...'
        TabOrder = 3
        OnClick = btColorClick
        Margin = 4
      end
    end
    object cbUnitKind: TComboBox
      Left = 8
      Top = 98
      Width = 145
      Height = 22
      Style = csDropDownList
      ItemHeight = 14
      ItemIndex = 0
      TabOrder = 7
      Text = #1062#1080#1083#1080#1085#1076#1088
      OnSelect = cbUnitKindSelect
      Items.Strings = (
        #1062#1080#1083#1080#1085#1076#1088
        #1050#1086#1085#1091#1089
        #1059#1089#1077#1095#1077#1085#1085#1099#1081' '#1082#1086#1085#1091#1089' 1'
        #1059#1089#1077#1095#1077#1085#1085#1099#1081' '#1082#1086#1085#1091#1089' 2'
        #1055#1086#1083#1091#1089#1092#1077#1088#1072)
    end
    object btRotate: TButton
      Left = 168
      Top = 97
      Width = 89
      Height = 25
      Caption = #1055#1086#1074#1077#1088#1085#1091#1090#1100
      TabOrder = 8
      OnClick = btRotateClick
    end
    object btColor: TBitBtn
      Left = 69
      Top = 131
      Width = 196
      Height = 25
      Caption = #1042#1099#1073#1088#1072#1090#1100'...'
      TabOrder = 9
      OnClick = btColorClick
      Margin = 4
    end
    object btBorderColor: TBitBtn
      Left = 69
      Top = 163
      Width = 196
      Height = 25
      Caption = #1042#1099#1073#1088#1072#1090#1100'...'
      TabOrder = 10
      OnClick = btColorClick
      Margin = 4
    end
  end
  object GroupBox: TGroupBox
    Left = 292
    Top = 8
    Width = 208
    Height = 265
    Caption = ' '#1054#1073#1088#1072#1079#1077#1094
    TabOrder = 1
    object ScrollBox: TScrollBox
      Left = 8
      Top = 16
      Width = 193
      Height = 241
      Color = clGray
      ParentColor = False
      TabOrder = 0
    end
  end
  object CloseButton: TButton
    Left = 307
    Top = 284
    Width = 86
    Height = 25
    Caption = #1042#1074#1086#1076
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object CancelButton: TButton
    Left = 403
    Top = 284
    Width = 86
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 144
    Top = 7
  end
  object ImageList1: TImageList
    Left = 320
    Top = 48
  end
  object pmColorSelect: TPopupMenu
    Images = ImageList1
    OnPopup = pmColorSelectPopup
    Left = 320
    Top = 88
  end
  object ColorDialog1: TColorDialog
    Left = 320
    Top = 128
  end
end
