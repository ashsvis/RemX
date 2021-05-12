object VirtSIEditForm: TVirtSIEditForm
  Left = 192
  Top = 114
  Width = 696
  Height = 473
  Align = alClient
  Caption = 'VirtSIEditForm'
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
    Width = 688
    Height = 439
    Align = alClient
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
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 40
    Top = 40
  end
end
