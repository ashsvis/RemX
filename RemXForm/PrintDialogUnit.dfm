object PrintDialogForm: TPrintDialogForm
  Left = 445
  Top = 346
  BorderStyle = bsDialog
  Caption = #1055#1077#1095#1072#1090#1100
  ClientHeight = 281
  ClientWidth = 423
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object GroupBox1: TGroupBox
    Left = 16
    Top = 8
    Width = 393
    Height = 145
    Caption = ' '#1055#1088#1080#1085#1090#1077#1088' '
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 24
      Width = 27
      Height = 14
      Caption = #1048#1084#1103':'
    end
    object Label2: TLabel
      Left = 16
      Top = 48
      Width = 65
      Height = 14
      Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077':'
    end
    object Label3: TLabel
      Left = 16
      Top = 72
      Width = 26
      Height = 14
      Caption = #1058#1080#1087':'
    end
    object Label4: TLabel
      Left = 16
      Top = 96
      Width = 39
      Height = 14
      Caption = #1052#1077#1089#1090#1086':'
    end
    object Label5: TLabel
      Left = 16
      Top = 120
      Width = 73
      Height = 14
      Caption = #1050#1086#1084#1077#1085#1090#1072#1088#1080#1081':'
    end
    object lbPrinterState: TLabel
      Left = 104
      Top = 48
      Width = 273
      Height = 14
      AutoSize = False
      Caption = 'lbPrinterState'
    end
    object lbPrinterType: TLabel
      Left = 104
      Top = 72
      Width = 273
      Height = 14
      AutoSize = False
      Caption = 'lbPrinterType'
    end
    object lbPrinterPlace: TLabel
      Left = 104
      Top = 96
      Width = 273
      Height = 14
      AutoSize = False
      Caption = 'lbPrinterPlace'
    end
    object lbPrinterComment: TLabel
      Left = 104
      Top = 120
      Width = 273
      Height = 14
      AutoSize = False
      Caption = 'lbPrinterComment'
    end
    object cbPrinters: TComboBox
      Left = 104
      Top = 19
      Width = 217
      Height = 22
      Style = csDropDownList
      ItemHeight = 14
      TabOrder = 0
      OnChange = cbPrintersChange
    end
  end
  object rgPrintRange: TRadioGroup
    Left = 16
    Top = 160
    Width = 217
    Height = 81
    Caption = ' '#1044#1080#1072#1087#1072#1079#1086#1085' '#1087#1077#1095#1072#1090#1080' '
    ItemIndex = 0
    Items.Strings = (
      #1042#1089#1077
      #1057#1090#1088#1072#1085#1080#1094#1099'   '#1089':           '#1087#1086':')
    TabOrder = 1
    OnClick = rgPrintRangeClick
  end
  object GroupBox2: TGroupBox
    Left = 240
    Top = 160
    Width = 169
    Height = 81
    Caption = ' '#1050#1086#1087#1080#1080' '
    TabOrder = 2
    object Label9: TLabel
      Left = 16
      Top = 24
      Width = 73
      Height = 14
      Caption = #1063#1080#1089#1083#1086' '#1082#1086#1087#1080#1081
    end
    object edCopyNum: TEdit
      Left = 99
      Top = 20
      Width = 38
      Height = 22
      ReadOnly = True
      TabOrder = 0
      Text = '1'
      OnChange = edCopyNumChange
    end
    object udCopyNum: TUpDown
      Left = 137
      Top = 20
      Width = 17
      Height = 22
      Associate = edCopyNum
      Min = 1
      Max = 999
      Position = 1
      TabOrder = 1
      Thousands = False
    end
    object cbCollate: TCheckBox
      Left = 16
      Top = 54
      Width = 145
      Height = 17
      Caption = #1056#1072#1079#1086#1073#1088#1072#1090#1100' '#1087#1086' '#1082#1086#1087#1080#1103#1084
      Checked = True
      Enabled = False
      State = cbChecked
      TabOrder = 2
      OnClick = cbCollateClick
    end
  end
  object Button1: TButton
    Left = 208
    Top = 248
    Width = 89
    Height = 25
    Caption = #1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object Button2: TButton
    Left = 312
    Top = 248
    Width = 89
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 4
  end
  object edStartPage: TEdit
    Left = 123
    Top = 211
    Width = 33
    Height = 22
    Color = clBtnFace
    Enabled = False
    TabOrder = 5
    Text = '1'
    OnChange = edStartPageChange
  end
  object edEndPage: TEdit
    Left = 187
    Top = 211
    Width = 33
    Height = 22
    Color = clBtnFace
    Enabled = False
    TabOrder = 6
    Text = '1'
    OnChange = edEndPageChange
  end
end
