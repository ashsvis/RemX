object ExtTimeFilterForm: TExtTimeFilterForm
  Left = 253
  Top = 176
  BorderStyle = bsDialog
  Caption = 'ExtTimeFilterForm'
  ClientHeight = 305
  ClientWidth = 482
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 216
    Width = 43
    Height = 14
    Caption = #1055#1077#1088#1080#1086#1076
  end
  object SpeedButton1: TSpeedButton
    Tag = 1
    Left = 8
    Top = 8
    Width = 145
    Height = 28
    Caption = #1095#1072#1089
    OnClick = sbHoursClick
  end
  object SpeedButton2: TSpeedButton
    Tag = 2
    Left = 8
    Top = 40
    Width = 145
    Height = 28
    Caption = '2 '#1095#1072#1089#1072
    OnClick = sbHoursClick
  end
  object SpeedButton3: TSpeedButton
    Tag = 4
    Left = 8
    Top = 72
    Width = 145
    Height = 28
    Caption = '4 '#1095#1072#1089#1072
    OnClick = sbHoursClick
  end
  object SpeedButton4: TSpeedButton
    Tag = 8
    Left = 8
    Top = 104
    Width = 145
    Height = 28
    Caption = '8 '#1095#1072#1089#1086#1074
    OnClick = sbHoursClick
  end
  object SpeedButton5: TSpeedButton
    Tag = 12
    Left = 8
    Top = 136
    Width = 145
    Height = 28
    Caption = '12 '#1095#1072#1089#1086#1074
    OnClick = sbHoursClick
  end
  object SpeedButton6: TSpeedButton
    Tag = 1
    Left = 323
    Top = 8
    Width = 150
    Height = 28
    Caption = #1084#1077#1089#1103#1094
    OnClick = sbMonthsClick
  end
  object SpeedButton7: TSpeedButton
    Tag = 3
    Left = 323
    Top = 40
    Width = 150
    Height = 28
    Caption = '3 '#1084#1077#1089#1103#1094#1072
    OnClick = sbMonthsClick
  end
  object SpeedButton8: TSpeedButton
    Tag = 6
    Left = 323
    Top = 72
    Width = 150
    Height = 28
    Caption = '6 '#1084#1077#1089#1103#1094#1077#1074
    OnClick = sbMonthsClick
  end
  object SpeedButton10: TSpeedButton
    Tag = 1
    Left = 323
    Top = 168
    Width = 150
    Height = 28
    Caption = #1075#1086#1076
    OnClick = sbYearClick
  end
  object SpeedButton9: TSpeedButton
    Tag = 7
    Left = 166
    Top = 8
    Width = 147
    Height = 28
    Caption = '7 '#1076#1085#1077#1081
    OnClick = sbDaysClick
  end
  object SpeedButton11: TSpeedButton
    Tag = 10
    Left = 166
    Top = 40
    Width = 147
    Height = 28
    Caption = '10 '#1076#1085#1077#1081
    OnClick = sbDaysClick
  end
  object SpeedButton12: TSpeedButton
    Tag = 14
    Left = 166
    Top = 72
    Width = 147
    Height = 28
    Caption = '14 '#1076#1085#1077#1081
    OnClick = sbDaysClick
  end
  object SpeedButton13: TSpeedButton
    Tag = 15
    Left = 166
    Top = 104
    Width = 147
    Height = 28
    Caption = '15 '#1076#1085#1077#1081
    OnClick = sbDaysClick
  end
  object SpeedButton14: TSpeedButton
    Tag = 30
    Left = 166
    Top = 168
    Width = 147
    Height = 28
    Caption = '30 '#1076#1085#1077#1081
    OnClick = sbDaysClick
  end
  object SpeedButton15: TSpeedButton
    Tag = 24
    Left = 8
    Top = 168
    Width = 145
    Height = 28
    Caption = '24 '#1095#1072#1089#1072
    OnClick = sbHoursClick
  end
  object Bevel1: TBevel
    Left = 5
    Top = 208
    Width = 468
    Height = 9
    Shape = bsTopLine
  end
  object TimeBaseListBox: TListBox
    Left = 8
    Top = 232
    Width = 177
    Height = 65
    Ctl3D = True
    ItemHeight = 14
    Items.Strings = (
      #1063#1072#1089' ('#1095#1072#1089#1072', '#1095#1072#1089#1086#1074')'
      #1044#1077#1085#1100' ('#1076#1085#1103', '#1076#1085#1077#1081')'
      #1052#1077#1089#1103#1094' ('#1084#1077#1089#1103#1094#1072', '#1084#1077#1089#1103#1094#1077#1074')'
      #1043#1086#1076' ('#1075#1086#1076#1072', '#1083#1077#1090')')
    ParentCtl3D = False
    TabOrder = 0
    OnClick = TimeBaseListBoxClick
  end
  object GroupBox1: TGroupBox
    Left = 200
    Top = 224
    Width = 153
    Height = 49
    Caption = #1047#1085#1072#1095#1077#1085#1080#1077
    TabOrder = 1
    object MaskEdit1: TMaskEdit
      Left = 8
      Top = 16
      Width = 57
      Height = 22
      Ctl3D = True
      MaxLength = 3
      ParentCtl3D = False
      TabOrder = 0
      Text = '1'
    end
    object UpDown1: TUpDown
      Left = 65
      Top = 16
      Width = 16
      Height = 22
      Associate = MaskEdit1
      Min = 1
      Position = 1
      TabOrder = 1
    end
  end
  object OkButton: TButton
    Left = 368
    Top = 232
    Width = 97
    Height = 25
    Caption = #1054#1082
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object CancelButton: TButton
    Left = 368
    Top = 264
    Width = 97
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
  object cbWithCurrent: TCheckBox
    Left = 200
    Top = 276
    Width = 153
    Height = 17
    Caption = #1042#1082#1083#1102#1095#1072#1103' '#1090#1077#1082#1091#1097#1091#1102' '#1076#1072#1090#1091
    Checked = True
    Ctl3D = True
    ParentCtl3D = False
    State = cbChecked
    TabOrder = 4
    OnClick = cbWithCurrentClick
  end
end
