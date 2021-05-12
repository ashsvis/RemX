object GetLinkNameDlg: TGetLinkNameDlg
  Left = 262
  Top = 184
  ActiveControl = ListView1
  BorderStyle = bsDialog
  Caption = #1064#1080#1092#1088' '#1087#1086#1079#1080#1094#1080#1080
  ClientHeight = 277
  ClientWidth = 456
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
  object Label1: TLabel
    Left = 9
    Top = 6
    Width = 35
    Height = 14
    Caption = 'Label1'
  end
  object Edit1: TEdit
    Left = 8
    Top = 26
    Width = 441
    Height = 22
    TabStop = False
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
  end
  object Button1: TButton
    Left = 286
    Top = 244
    Width = 75
    Height = 25
    Caption = #1042#1074#1086#1076
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object Button2: TButton
    Left = 374
    Top = 244
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
  object ListView1: TListView
    Left = 8
    Top = 56
    Width = 441
    Height = 177
    Columns = <
      item
        Caption = #1055#1086#1079#1080#1094#1080#1103
        Width = 120
      end
      item
        Caption = #1044#1077#1089#1082#1088#1080#1087#1090#1086#1088
        Width = 300
      end>
    HideSelection = False
    OwnerData = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 1
    ViewStyle = vsReport
    OnColumnClick = ListView1ColumnClick
    OnData = ListView1Data
    OnDblClick = ListView1DblClick
    OnSelectItem = ListView1SelectItem
  end
  object Button3: TButton
    Left = 6
    Top = 244
    Width = 113
    Height = 25
    Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1074#1103#1079#1100
    TabOrder = 4
    OnClick = Button3Click
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 360
    Top = 88
  end
end
