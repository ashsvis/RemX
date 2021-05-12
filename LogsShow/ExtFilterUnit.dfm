object ExtFilterForm: TExtFilterForm
  Left = 281
  Top = 243
  BorderStyle = bsDialog
  Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100#1089#1082#1080#1081' '#1072#1074#1090#1086#1092#1080#1083#1100#1090#1088
  ClientHeight = 255
  ClientWidth = 544
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnMouseDown = Label2MouseDown
  PixelsPerInch = 96
  TextHeight = 14
  object OkButton: TButton
    Left = 360
    Top = 224
    Width = 75
    Height = 25
    Caption = #1054#1082
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelButton: TButton
    Left = 448
    Top = 224
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 529
    Height = 209
    Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1090#1077' '#1089#1090#1088#1086#1082#1080', '#1079#1085#1072#1095#1077#1085#1080#1103' '#1082#1086#1090#1086#1088#1099#1093':  '
    TabOrder = 2
    object ColumnNameLabel: TLabel
      Left = 16
      Top = 24
      Width = 99
      Height = 14
      Caption = 'ColumnNameLabel'
      OnMouseDown = Label2MouseDown
    end
    object sbSelect1: TSpeedButton
      Left = 496
      Top = 48
      Width = 17
      Height = 22
      Caption = '...'
      OnClick = sbSelect1Click
    end
    object sbSelect2: TSpeedButton
      Left = 496
      Top = 104
      Width = 17
      Height = 22
      Caption = '...'
      OnClick = sbSelect2Click
    end
    object Label2: TLabel
      Left = 16
      Top = 152
      Width = 361
      Height = 41
      AutoSize = False
      Caption = 
        #1050#1086#1084#1073#1080#1085#1080#1088#1091#1103' '#1091#1089#1083#1086#1074#1080#1103' '#1080#1079' '#1089#1087#1080#1089#1082#1086#1074' '#1089#1083#1077#1074#1072' '#1080' '#1090#1077#1082#1089#1090#1086#1074#1099#1093' '#1079#1085#1072#1095#1077#1085#1080#1081' '#1089#1087#1088#1072#1074#1072',' +
        ' '#1074#1099#1073#1077#1088#1080#1090#1077' '#1087#1088#1080#1077#1084#1083#1077#1084#1086#1077' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1074#1072#1088#1080#1072#1085#1090#1086#1074'.'
      WordWrap = True
      OnMouseDown = Label2MouseDown
    end
    object LogikComboBox1: TComboBox
      Left = 16
      Top = 48
      Width = 177
      Height = 22
      Style = csDropDownList
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ItemHeight = 14
      ItemIndex = 1
      ParentFont = False
      TabOrder = 0
      Text = #1088#1072#1074#1085#1086
      Items.Strings = (
        ' '
        #1088#1072#1074#1085#1086
        #1085#1077' '#1088#1072#1074#1085#1086
        #1073#1086#1083#1100#1096#1077
        #1073#1086#1083#1100#1096#1077' '#1080#1083#1080' '#1088#1072#1074#1085#1086
        #1084#1077#1085#1100#1096#1077
        #1084#1077#1085#1100#1096#1077' '#1080#1083#1080' '#1088#1072#1074#1085#1086
        #1085#1072#1095#1080#1085#1072#1077#1090#1089#1103' '#1089
        #1085#1077' '#1085#1072#1095#1080#1085#1072#1077#1090#1089#1103' '#1089
        #1079#1072#1082#1072#1085#1095#1080#1074#1072#1077#1090#1089#1103' '#1085#1072
        #1085#1077' '#1079#1072#1082#1072#1085#1095#1080#1074#1072#1077#1090#1089#1103
        #1089#1086#1076#1077#1088#1078#1080#1090
        #1085#1077' '#1089#1086#1076#1077#1088#1078#1080#1090)
    end
    object LogikEdit1: TEdit
      Left = 200
      Top = 48
      Width = 297
      Height = 22
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnKeyDown = LogikEdit1KeyDown
    end
    object rbAND: TRadioButton
      Left = 64
      Top = 80
      Width = 41
      Height = 17
      Caption = '&'#1048
      Checked = True
      Ctl3D = False
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 2
      TabStop = True
    end
    object rbOR: TRadioButton
      Left = 120
      Top = 80
      Width = 49
      Height = 17
      Caption = #1048'&'#1051#1048
      Ctl3D = False
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 3
    end
    object LogikComboBox2: TComboBox
      Left = 16
      Top = 104
      Width = 177
      Height = 22
      Style = csDropDownList
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ItemHeight = 14
      ItemIndex = 0
      ParentFont = False
      TabOrder = 4
      Text = ' '
      Items.Strings = (
        ' '
        #1088#1072#1074#1085#1086
        #1085#1077' '#1088#1072#1074#1085#1086
        #1073#1086#1083#1100#1096#1077
        #1073#1086#1083#1100#1096#1077' '#1080#1083#1080' '#1088#1072#1074#1085#1086
        #1084#1077#1085#1100#1096#1077
        #1084#1077#1085#1100#1096#1077' '#1080#1083#1080' '#1088#1072#1074#1085#1086
        #1085#1072#1095#1080#1085#1072#1077#1090#1089#1103' '#1089
        #1085#1077' '#1085#1072#1095#1080#1085#1072#1077#1090#1089#1103' '#1089
        #1079#1072#1082#1072#1085#1095#1080#1074#1072#1077#1090#1089#1103' '#1085#1072
        #1085#1077' '#1079#1072#1082#1072#1085#1095#1080#1074#1072#1077#1090#1089#1103
        #1089#1086#1076#1077#1088#1078#1080#1090
        #1085#1077' '#1089#1086#1076#1077#1088#1078#1080#1090)
    end
    object LogikEdit2: TEdit
      Left = 200
      Top = 104
      Width = 297
      Height = 22
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      OnKeyDown = LogikEdit2KeyDown
    end
  end
end
