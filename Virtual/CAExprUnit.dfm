object FormCAExpr: TFormCAExpr
  Left = 455
  Top = 318
  BorderStyle = bsDialog
  Caption = #1042#1074#1077#1076#1080#1090#1077' '#1092#1086#1088#1084#1091#1083#1091
  ClientHeight = 98
  ClientWidth = 325
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object lblFunc: TLabel
    Left = 5
    Top = 10
    Width = 48
    Height = 16
    Caption = 'E%d = '
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
  end
  object lbl1: TLabel
    Left = 96
    Top = 10
    Width = 8
    Height = 16
    Caption = '('
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
  end
  object lbl2: TLabel
    Left = 145
    Top = 10
    Width = 8
    Height = 16
    Caption = ')'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
  end
  object lbl3: TLabel
    Left = 243
    Top = 10
    Width = 8
    Height = 16
    Caption = '('
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
  end
  object lbl4: TLabel
    Left = 292
    Top = 10
    Width = 8
    Height = 16
    Caption = ')'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
  end
  object lblResult: TLabel
    Left = 16
    Top = 39
    Width = 273
    Height = 14
    Alignment = taCenter
    AutoSize = False
    Caption = 'lblResult'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
  end
  object cbbFirstPrefix: TComboBox
    Left = 49
    Top = 7
    Width = 49
    Height = 24
    Style = csDropDownList
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 16
    ItemIndex = 0
    ParentFont = False
    TabOrder = 0
    Text = 'SQR'
    OnChange = cbbFirstPrefixChange
    Items.Strings = (
      'SQR')
  end
  object cbbSecondPrefix: TComboBox
    Left = 195
    Top = 7
    Width = 49
    Height = 24
    Style = csDropDownList
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 16
    ItemIndex = 0
    ParentFont = False
    TabOrder = 3
    OnChange = cbbSecondPrefixChange
    Items.Strings = (
      ''
      'SQR('
      'Exp('
      'Ln(')
  end
  object cbbFirstVar: TComboBox
    Left = 105
    Top = 7
    Width = 40
    Height = 24
    Style = csDropDownList
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 16
    ItemIndex = 0
    ParentFont = False
    TabOrder = 1
    Text = 'V1'
    OnChange = cbbFirstVarChange
    Items.Strings = (
      'V1')
  end
  object cbbSecondVar: TComboBox
    Left = 251
    Top = 7
    Width = 40
    Height = 24
    Style = csDropDownList
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 16
    ItemIndex = 0
    ParentFont = False
    TabOrder = 4
    OnChange = cbbSecondVarChange
    Items.Strings = (
      ''
      'VAR'
      'CONST'
      'EXPR')
  end
  object cbbOperation: TComboBox
    Left = 152
    Top = 7
    Width = 41
    Height = 24
    Style = csDropDownList
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 16
    ItemIndex = 1
    ParentFont = False
    TabOrder = 2
    Text = ' + '
    OnChange = cbbOperationChange
    Items.Strings = (
      ''
      ' + '
      '-'
      '*'
      '/')
  end
  object btnOk: TButton
    Left = 64
    Top = 64
    Width = 75
    Height = 25
    Caption = #1042#1074#1086#1076
    Default = True
    Enabled = False
    ModalResult = 1
    TabOrder = 5
  end
  object btnCancel: TButton
    Left = 168
    Top = 64
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 6
  end
end
