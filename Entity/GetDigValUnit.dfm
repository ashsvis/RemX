object GetDigValDlg: TGetDigValDlg
  Left = 286
  Top = 243
  BorderStyle = bsDialog
  Caption = #1047#1085#1072#1095#1077#1085#1080#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1072
  ClientHeight = 71
  ClientWidth = 289
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 14
  object Button2: TButton
    Left = 200
    Top = 32
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object Prompt: TGroupBox
    Left = 8
    Top = 0
    Width = 273
    Height = 65
    Caption = 'Prompt'
    TabOrder = 0
    object pnOn: TPanel
      Left = 16
      Top = 24
      Width = 115
      Height = 25
      AutoSize = True
      BevelOuter = bvNone
      TabOrder = 0
      object btOn: TButton
        Left = 0
        Top = 0
        Width = 115
        Height = 25
        Caption = #1042#1082#1083#1102#1095#1080#1090#1100
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ModalResult = 1
        ParentFont = False
        TabOrder = 0
        OnClick = btOnClick
      end
    end
    object pnOff: TPanel
      Left = 140
      Top = 24
      Width = 115
      Height = 25
      AutoSize = True
      BevelOuter = bvNone
      TabOrder = 1
      object btOff: TButton
        Left = 0
        Top = 0
        Width = 115
        Height = 25
        Caption = #1042#1099#1082#1083#1102#1095#1080#1090#1100
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ModalResult = 1
        ParentFont = False
        TabOrder = 0
        OnClick = btOffClick
      end
    end
  end
end
