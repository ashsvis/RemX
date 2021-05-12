object TimeFilterForm: TTimeFilterForm
  Left = 272
  Top = 144
  BorderStyle = bsDialog
  Caption = #1059#1089#1090#1072#1085#1086#1074#1082#1072' '#1075#1088#1072#1085#1080#1094' '#1087#1077#1088#1080#1086#1076#1072' '#1074#1099#1073#1086#1088#1082#1080
  ClientHeight = 312
  ClientWidth = 546
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 17
    Height = 23
    AutoSize = False
    Caption = 'C'
    Layout = tlCenter
  end
  object SpeedButton1: TSpeedButton
    Left = 296
    Top = 16
    Width = 65
    Height = 25
    Caption = #1042#1095#1077#1088#1072
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 368
    Top = 16
    Width = 97
    Height = 25
    Caption = #1057#1077#1075#1086#1076#1085#1103
    OnClick = SpeedButton2Click
  end
  object SpeedButton3: TSpeedButton
    Left = 472
    Top = 16
    Width = 65
    Height = 25
    Caption = #1047#1072#1074#1090#1088#1072
    OnClick = SpeedButton3Click
  end
  object sbSetAsEndDate: TSpeedButton
    Left = 32
    Top = 48
    Width = 241
    Height = 25
    Caption = #1053#1072#1095#1072#1083#1100#1085#1072#1103' '#1076#1072#1090#1072' '#1088#1072#1074#1085#1072' '#1082#1086#1085#1077#1095#1085#1086#1081' '#1076#1072#1090#1077
    OnClick = sbSetAsEndDateClick
  end
  object sbFirstDateLess: TSpeedButton
    Left = 296
    Top = 48
    Width = 241
    Height = 25
    Caption = #1053#1072#1095#1072#1083#1100#1085#1072#1103' '#1076#1072#1090#1072' '#1084#1077#1085#1100#1096#1077' '#1082#1086#1085#1077#1095#1085#1086#1081' '#1085#1072'...'
    OnClick = sbFirstDateLessClick
  end
  object Label2: TLabel
    Left = 8
    Top = 120
    Width = 17
    Height = 23
    AutoSize = False
    Caption = #1055#1086
    Layout = tlCenter
  end
  object SpeedButton6: TSpeedButton
    Left = 296
    Top = 120
    Width = 65
    Height = 25
    Caption = #1042#1095#1077#1088#1072
    OnClick = SpeedButton6Click
  end
  object SpeedButton7: TSpeedButton
    Left = 368
    Top = 120
    Width = 97
    Height = 25
    Caption = #1057#1077#1075#1086#1076#1085#1103
    OnClick = SpeedButton7Click
  end
  object SpeedButton8: TSpeedButton
    Left = 472
    Top = 120
    Width = 65
    Height = 25
    Caption = #1047#1072#1074#1090#1088#1072
    OnClick = SpeedButton8Click
  end
  object sbSetAsBeginDate: TSpeedButton
    Left = 32
    Top = 152
    Width = 241
    Height = 25
    Caption = #1050#1086#1085#1077#1095#1085#1072#1103' '#1076#1072#1090#1072' '#1088#1072#1074#1085#1072' '#1085#1072#1095#1072#1083#1100#1085#1086#1081' '#1076#1072#1090#1077
    OnClick = sbSetAsBeginDateClick
  end
  object sbEndDateMore: TSpeedButton
    Left = 296
    Top = 152
    Width = 241
    Height = 25
    Caption = #1050#1086#1085#1077#1095#1085#1072#1103' '#1076#1072#1090#1072' '#1073#1086#1083#1100#1096#1077' '#1085#1072#1095#1072#1083#1100#1085#1086#1081' '#1085#1072'...'
    OnClick = sbEndDateMoreClick
  end
  object Bevel1: TBevel
    Left = 8
    Top = 99
    Width = 529
    Height = 11
    Shape = bsBottomLine
  end
  object dtBeginDate: TDateTimePicker
    Left = 32
    Top = 16
    Width = 121
    Height = 22
    Date = 37793.371500821760000000
    Format = 'dd.MM.yy'
    Time = 37793.371500821760000000
    TabOrder = 0
  end
  object dtBeginTime: TDateTimePicker
    Left = 160
    Top = 16
    Width = 113
    Height = 22
    Date = 37793.371500821760000000
    Format = 'HH:mm:ss'
    Time = 37793.371500821760000000
    Kind = dtkTime
    TabOrder = 1
  end
  object dtEndDate: TDateTimePicker
    Left = 32
    Top = 120
    Width = 121
    Height = 22
    Date = 37793.371500821760000000
    Format = 'dd.MM.yy'
    Time = 37793.371500821760000000
    TabOrder = 2
  end
  object dtEndTime: TDateTimePicker
    Left = 160
    Top = 120
    Width = 113
    Height = 22
    Date = 37793.371500821760000000
    Format = 'HH:mm:ss'
    Time = 37793.371500821760000000
    Kind = dtkTime
    TabOrder = 3
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 216
    Width = 441
    Height = 89
    Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1075#1088#1072#1085#1080#1094#1099' '#1087#1077#1088#1080#1086#1076#1072' '#1074#1099#1073#1086#1088#1082#1080
    TabOrder = 4
    object sbFromBeginMonth: TSpeedButton
      Left = 8
      Top = 24
      Width = 209
      Height = 25
      Caption = #1057' '#1085#1072#1095#1072#1083#1072' '#1084#1077#1089#1103#1094#1072' '#1087#1086' '#1090#1077#1082#1091#1097#1091#1102' '#1076#1072#1090#1091
      OnClick = sbFromBeginMonthClick
    end
    object sbFromBeginDay: TSpeedButton
      Left = 224
      Top = 24
      Width = 209
      Height = 25
      Caption = #1057' '#1085#1072#1095#1072#1083#1072' '#1089#1091#1090#1086#1082' '#1087#1086' '#1090#1077#1082#1091#1097#1077#1077' '#1074#1088#1077#1084#1103
      OnClick = sbFromBeginDayClick
    end
    object sbLastDay: TSpeedButton
      Left = 8
      Top = 56
      Width = 209
      Height = 25
      Caption = #1058#1086#1083#1100#1082#1086' '#1079#1072' '#1087#1088#1077#1076#1099#1076#1091#1097#1080#1077' '#1089#1091#1090#1082#1080
      OnClick = sbLastDayClick
    end
    object sbLastEtc: TSpeedButton
      Left = 224
      Top = 56
      Width = 209
      Height = 25
      Caption = #1047#1072' '#1087#1086#1089#1083#1077#1076#1085#1080#1077'...'
      OnClick = sbLastEtcClick
    end
  end
  object OkButton: TButton
    Left = 456
    Top = 240
    Width = 81
    Height = 25
    Caption = #1054#1082
    Default = True
    ModalResult = 1
    TabOrder = 6
  end
  object CancelButton: TButton
    Left = 456
    Top = 272
    Width = 81
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 7
  end
  object stBeginDateDayName: TStaticText
    Left = 32
    Top = 80
    Width = 241
    Height = 19
    AutoSize = False
    BorderStyle = sbsSunken
    Caption = #1087#1086#1085#1077#1076#1077#1083#1100#1085#1080#1082
    TabOrder = 8
  end
  object stEndDateDayName: TStaticText
    Left = 32
    Top = 184
    Width = 241
    Height = 19
    AutoSize = False
    BorderStyle = sbsSunken
    Caption = #1087#1086#1085#1077#1076#1077#1083#1100#1085#1080#1082
    TabOrder = 9
  end
  object DeleteFilterButton: TButton
    Left = 456
    Top = 208
    Width = 81
    Height = 25
    Hint = #1059#1076#1072#1083#1080#1090#1100' '#1092#1080#1083#1100#1090#1088
    Caption = #1042#1099#1082#1083#1102#1095#1080#1090#1100
    ModalResult = 3
    TabOrder = 5
  end
  object ApplicationEvents: TApplicationEvents
    OnIdle = ApplicationEventsIdle
    Left = 376
    Top = 80
  end
end
