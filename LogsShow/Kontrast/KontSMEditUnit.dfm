object KontSMEditForm: TKontSMEditForm
  Left = 194
  Top = 116
  Width = 692
  Height = 483
  Align = alClient
  Caption = 'KontSMEditForm'
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
    Width = 676
    Height = 447
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
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 24
    Top = 40
  end
end
