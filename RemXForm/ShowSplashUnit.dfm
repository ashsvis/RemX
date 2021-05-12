object ShowSplashForm: TShowSplashForm
  Left = 291
  Top = 233
  AutoSize = True
  BorderIcons = [biSystemMenu]
  BorderStyle = bsNone
  Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
  ClientHeight = 315
  ClientWidth = 425
  Color = clBackground
  DefaultMonitor = dmDesktop
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object SplashImage: TImage
    Left = 0
    Top = 0
    Width = 425
    Height = 315
  end
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 425
    Height = 315
    Style = bsRaised
  end
  object Label1: TLabel
    Left = 250
    Top = 3
    Width = 168
    Height = 14
    Alignment = taRightJustify
    Caption = #169' ASh Home, 1999 - 2016 '
    Color = clYellow
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = [fsBold, fsItalic]
    ParentColor = False
    ParentFont = False
    ShowAccelChar = False
    Transparent = True
    Layout = tlCenter
  end
  object Version: TLabel
    Left = 336
    Top = 160
    Width = 81
    Height = 19
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Version'
    Color = clYellow
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsItalic]
    ParentColor = False
    ParentFont = False
    ShowAccelChar = False
    Transparent = True
    Layout = tlCenter
  end
  object Label2: TLabel
    Left = 4
    Top = 279
    Width = 149
    Height = 32
    Alignment = taCenter
    AutoSize = False
    Caption = #1054#1092#1080#1094#1080#1072#1083#1100#1085#1099#1081' '#1089#1072#1081#1090': remx-scada.narod.ru'
    Color = clBtnFace
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBtnText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    ShowAccelChar = False
    Transparent = False
    Layout = tlCenter
    WordWrap = True
  end
  object CloseButton: TButton
    Left = 343
    Top = 283
    Width = 75
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    Default = True
    ModalResult = 1
    TabOrder = 0
    Visible = False
    OnClick = CloseButtonClick
  end
  object HideTimer: TTimer
    Enabled = False
    OnTimer = HideTimerTimer
    Left = 24
    Top = 40
  end
end
