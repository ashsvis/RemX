object DinLineEditorForm: TDinLineEditorForm
  Left = 256
  Top = 106
  BorderStyle = bsDialog
  Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1101#1083#1077#1084#1077#1085#1090#1072' "'#1044#1080#1085#1072#1084#1080#1095#1077#1089#1082#1072#1103' '#1083#1080#1085#1080#1103'"'
  ClientHeight = 576
  ClientWidth = 499
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
    Width = 289
    Height = 561
    Caption = #1057#1074#1086#1081#1089#1090#1074#1072
    TabOrder = 0
    object Bevel2: TBevel
      Left = 8
      Top = 17
      Width = 273
      Height = 69
    end
    object Label2: TLabel
      Left = 152
      Top = 24
      Width = 48
      Height = 23
      AutoSize = False
      Caption = #1064#1080#1088#1080#1085#1072':'
      Layout = tlCenter
    end
    object Label4: TLabel
      Left = 152
      Top = 56
      Width = 44
      Height = 23
      AutoSize = False
      Caption = #1042#1099#1089#1086#1090#1072':'
      Layout = tlCenter
    end
    object Label5: TLabel
      Left = 24
      Top = 24
      Width = 48
      Height = 23
      AutoSize = False
      Caption = #1057#1083#1077#1074#1072':'
      Layout = tlCenter
    end
    object Label6: TLabel
      Left = 24
      Top = 56
      Width = 44
      Height = 23
      AutoSize = False
      Caption = #1057#1074#1077#1088#1093#1091':'
      Layout = tlCenter
    end
    object Label11: TLabel
      Left = 144
      Top = 96
      Width = 78
      Height = 14
      Caption = #1048#1084#1103' '#1087#1086#1079#1080#1094#1080#1080':'
    end
    object Label9: TLabel
      Left = 8
      Top = 96
      Width = 65
      Height = 14
      Caption = #1058#1080#1087' '#1083#1080#1085#1080#1080':'
    end
    object seWidth: TSpinEdit
      Left = 208
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
      Left = 208
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
      Left = 80
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
      Left = 80
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
      Left = 144
      Top = 112
      Width = 129
      Height = 22
      Cursor = crHandPoint
      ReadOnly = True
      TabOrder = 5
      OnClick = edPtNameClick
    end
    object LineKind: TComboBox
      Left = 8
      Top = 112
      Width = 121
      Height = 58
      Style = csOwnerDrawFixed
      DropDownCount = 4
      ItemHeight = 52
      ItemIndex = 0
      TabOrder = 4
      Text = '0'
      OnDrawItem = LineKindDrawItem
      OnSelect = LineKindSelect
      Items.Strings = (
        '0'
        '1'
        '2'
        '3'
        '4'
        '5'
        '6'
        '7'
        '8'
        '9')
    end
    object cbBaseColor: TCheckBox
      Left = 144
      Top = 144
      Width = 129
      Height = 17
      Caption = #1062#1074#1077#1090' '#1080#1079' '#1041#1044' '#1090#1086#1095#1082#1080
      TabOrder = 6
      OnClick = cbBaseColorClick
    end
    object GroupBox3: TGroupBox
      Left = 8
      Top = 176
      Width = 273
      Height = 121
      Caption = ' '#1041#1077#1079' '#1087#1072#1088#1072#1084#1077#1090#1088#1072' '
      TabOrder = 7
      object Label13: TLabel
        Left = 8
        Top = 21
        Width = 49
        Height = 23
        Alignment = taRightJustify
        AutoSize = False
        Caption = #1058#1086#1097#1080#1085#1072':'
        Layout = tlCenter
      end
      object Label10: TLabel
        Left = 8
        Top = 53
        Width = 49
        Height = 23
        Alignment = taRightJustify
        AutoSize = False
        Caption = #1057#1090#1080#1083#1100':'
        Layout = tlCenter
      end
      object Label12: TLabel
        Left = 8
        Top = 85
        Width = 49
        Height = 23
        Alignment = taRightJustify
        AutoSize = False
        Caption = #1062#1074#1077#1090':'
        Layout = tlCenter
      end
      object LineWidth: TSpinEdit
        Left = 64
        Top = 21
        Width = 55
        Height = 23
        Ctl3D = True
        EditorEnabled = False
        MaxLength = 3
        MaxValue = 100
        MinValue = 1
        ParentCtl3D = False
        TabOrder = 0
        Value = 1
        OnChange = LineWidthChange
      end
      object LineStyle: TComboBox
        Left = 64
        Top = 53
        Width = 193
        Height = 22
        Style = csOwnerDrawFixed
        ItemHeight = 16
        ItemIndex = 0
        TabOrder = 1
        Text = '0'
        OnDrawItem = LineStyleDrawItem
        OnSelect = LineStyleSelect
        Items.Strings = (
          '0'
          '1'
          '2'
          '3'
          '4')
      end
      object btLineColor: TBitBtn
        Left = 64
        Top = 86
        Width = 193
        Height = 25
        Caption = #1042#1099#1073#1088#1072#1090#1100'...'
        TabOrder = 2
        OnClick = btLineColorClick
        Margin = 4
      end
    end
    object GroupBox4: TGroupBox
      Left = 8
      Top = 304
      Width = 273
      Height = 121
      Caption = ' '#1055#1088#1080' "0" '
      TabOrder = 8
      object Label1: TLabel
        Left = 8
        Top = 21
        Width = 97
        Height = 23
        Alignment = taRightJustify
        AutoSize = False
        Caption = #1058#1086#1097#1080#1085#1072' '#1087#1088#1080' "0":'
        Layout = tlCenter
      end
      object Label3: TLabel
        Left = 8
        Top = 53
        Width = 97
        Height = 23
        Alignment = taRightJustify
        AutoSize = False
        Caption = #1057#1090#1080#1083#1100' '#1087#1088#1080' "0":'
        Layout = tlCenter
      end
      object Label7: TLabel
        Left = 8
        Top = 85
        Width = 97
        Height = 23
        Alignment = taRightJustify
        AutoSize = False
        Caption = #1062#1074#1077#1090' '#1087#1088#1080' "0":'
        Layout = tlCenter
      end
      object LineWidth0: TSpinEdit
        Left = 112
        Top = 21
        Width = 55
        Height = 23
        Ctl3D = True
        EditorEnabled = False
        MaxLength = 3
        MaxValue = 100
        MinValue = 1
        ParentCtl3D = False
        TabOrder = 0
        Value = 1
        OnChange = LineWidth0Change
      end
      object LineStyle0: TComboBox
        Left = 112
        Top = 53
        Width = 145
        Height = 22
        Style = csOwnerDrawFixed
        ItemHeight = 16
        ItemIndex = 0
        TabOrder = 1
        Text = '0'
        OnDrawItem = LineStyleDrawItem
        OnSelect = LineStyle0Select
        Items.Strings = (
          '0'
          '1'
          '2'
          '3'
          '4'
          '5')
      end
      object btLineColor0: TBitBtn
        Left = 112
        Top = 86
        Width = 145
        Height = 25
        Caption = #1042#1099#1073#1088#1072#1090#1100'...'
        TabOrder = 2
        OnClick = btLineColorClick
        Margin = 4
      end
    end
    object GroupBox5: TGroupBox
      Left = 8
      Top = 432
      Width = 273
      Height = 121
      Caption = ' '#1055#1088#1080' "1" '
      TabOrder = 9
      object Label8: TLabel
        Left = 8
        Top = 21
        Width = 97
        Height = 23
        Alignment = taRightJustify
        AutoSize = False
        Caption = #1058#1086#1097#1080#1085#1072' '#1087#1088#1080' "1":'
        Layout = tlCenter
      end
      object Label14: TLabel
        Left = 8
        Top = 53
        Width = 97
        Height = 23
        Alignment = taRightJustify
        AutoSize = False
        Caption = #1057#1090#1080#1083#1100' '#1087#1088#1080' "1":'
        Layout = tlCenter
      end
      object Label15: TLabel
        Left = 8
        Top = 85
        Width = 97
        Height = 23
        Alignment = taRightJustify
        AutoSize = False
        Caption = #1062#1074#1077#1090' '#1087#1088#1080' "1":'
        Layout = tlCenter
      end
      object LineWidth1: TSpinEdit
        Left = 112
        Top = 21
        Width = 55
        Height = 23
        Ctl3D = True
        EditorEnabled = False
        MaxLength = 3
        MaxValue = 100
        MinValue = 1
        ParentCtl3D = False
        TabOrder = 0
        Value = 1
        OnChange = LineWidth1Change
      end
      object LineStyle1: TComboBox
        Left = 112
        Top = 53
        Width = 145
        Height = 22
        Style = csOwnerDrawFixed
        ItemHeight = 16
        ItemIndex = 0
        TabOrder = 1
        Text = '0'
        OnDrawItem = LineStyleDrawItem
        OnSelect = LineStyle1Select
        Items.Strings = (
          '0'
          '1'
          '2'
          '3'
          '4'
          '5')
      end
      object btLineColor1: TBitBtn
        Left = 112
        Top = 86
        Width = 145
        Height = 25
        Caption = #1042#1099#1073#1088#1072#1090#1100'...'
        TabOrder = 2
        OnClick = btLineColorClick
        Margin = 4
      end
    end
  end
  object CloseButton: TButton
    Left = 305
    Top = 538
    Width = 87
    Height = 25
    Caption = #1042#1074#1086#1076
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object CancelButton: TButton
    Left = 401
    Top = 538
    Width = 87
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
  object GroupBox: TGroupBox
    Left = 302
    Top = 8
    Width = 190
    Height = 169
    Caption = ' '#1054#1073#1088#1072#1079#1077#1094' '#1089#1090#1072#1090#1080#1095#1077#1089#1082#1080#1081' '
    TabOrder = 3
    object ScrollBox: TScrollBox
      Left = 8
      Top = 16
      Width = 173
      Height = 145
      Color = clGray
      ParentColor = False
      TabOrder = 0
    end
  end
  object GroupBox1: TGroupBox
    Left = 302
    Top = 184
    Width = 190
    Height = 169
    Caption = ' '#1054#1073#1088#1072#1079#1077#1094' '#1087#1088#1080' "0" '
    TabOrder = 4
    object ScrollBox0: TScrollBox
      Left = 8
      Top = 16
      Width = 173
      Height = 145
      Color = clGray
      ParentColor = False
      TabOrder = 0
    end
  end
  object GroupBox2: TGroupBox
    Left = 302
    Top = 360
    Width = 190
    Height = 169
    Caption = ' '#1054#1073#1088#1072#1079#1077#1094' '#1087#1088#1080' "1" '
    TabOrder = 5
    object ScrollBox1: TScrollBox
      Left = 8
      Top = 16
      Width = 173
      Height = 145
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
  object Fresh: TTimer
    Enabled = False
    Interval = 500
    OnTimer = FreshTimer
    Left = 336
    Top = 40
  end
  object ImageList1: TImageList
    Left = 160
    Top = 200
  end
  object pmColorSelect: TPopupMenu
    Images = ImageList1
    OnPopup = pmColorSelectPopup
    Left = 200
    Top = 200
  end
  object ColorDialog1: TColorDialog
    Left = 240
    Top = 200
  end
end
