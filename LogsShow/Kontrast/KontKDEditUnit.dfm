object KontKDEditForm: TKontKDEditForm
  Left = 194
  Top = 116
  Width = 692
  Height = 485
  Align = alClient
  Caption = 'KontKDEditForm'
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 14
  object Splitter1: TSplitter
    Left = 0
    Top = 201
    Width = 676
    Height = 3
    Cursor = crVSplit
    Align = alTop
    Color = clBtnFace
    ParentColor = False
  end
  object ListView1: TListView
    Left = 0
    Top = 0
    Width = 676
    Height = 201
    Align = alTop
    Columns = <
      item
        Caption = #1057#1074#1086#1081#1089#1090#1074#1086
        Width = 250
      end
      item
        AutoSize = True
        Caption = #1047#1085#1072#1095#1077#1085#1080#1077
      end>
    ColumnClick = False
    ReadOnly = True
    RowSelect = True
    PopupMenu = PopupMenu1
    TabOrder = 0
    ViewStyle = vsReport
    OnDblClick = ListView1DblClick
  end
  object ListView2: TListView
    Left = 0
    Top = 204
    Width = 676
    Height = 245
    Align = alClient
    Columns = <
      item
        Caption = #1058#1086#1095#1082#1080' '#1075#1088#1091#1087#1087#1099
        Width = 250
      end
      item
        AutoSize = True
        Caption = #1044#1077#1089#1082#1088#1080#1087#1090#1086#1088#1099
      end>
    ColumnClick = False
    HideSelection = False
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    PopupMenu = PopupMenu2
    TabOrder = 1
    ViewStyle = vsReport
    OnDblClick = ListView2DblClick
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 32
    Top = 32
  end
  object PopupMenu2: TPopupMenu
    OnPopup = PopupMenu2Popup
    Left = 32
    Top = 192
  end
end
