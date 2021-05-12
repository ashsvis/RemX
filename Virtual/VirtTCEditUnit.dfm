object VirtTCEditForm: TVirtTCEditForm
  Left = 193
  Top = 115
  Width = 694
  Height = 464
  Align = alClient
  Caption = 'VirtTCEditForm'
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 14
  object ListView1: TListView
    Left = 0
    Top = 0
    Width = 678
    Height = 428
    Align = alClient
    Columns = <
      item
        Caption = #1057#1074#1086#1081#1089#1090#1074#1086
        Width = 200
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
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 32
    Top = 40
  end
  object ImageList1: TImageList
    Left = 80
    Top = 40
  end
end
