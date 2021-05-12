object ResursGroupsForm: TResursGroupsForm
  Left = 192
  Top = 114
  BorderStyle = bsDialog
  Caption = #1048#1089#1093#1086#1076#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1075#1088#1091#1087#1087#1072#1084
  ClientHeight = 361
  ClientWidth = 379
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
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 379
    Height = 20
    AutoSize = True
    ButtonHeight = 20
    ButtonWidth = 67
    Caption = 'ToolBar1'
    EdgeBorders = []
    Flat = True
    List = True
    ShowCaptions = True
    TabOrder = 0
    object tbClose: TToolButton
      Left = 0
      Top = 0
      AutoSize = True
      Caption = #1047#1072#1082#1088#1099#1090#1100
      ImageIndex = 1
      OnClick = tbCloseClick
    end
    object ToolButton1: TToolButton
      Left = 61
      Top = 0
      Width = 8
      Caption = 'ToolButton1'
      ImageIndex = 1
      Style = tbsSeparator
    end
    object tbFresh: TToolButton
      Left = 69
      Top = 0
      AutoSize = True
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      ImageIndex = 0
      OnClick = tbFreshClick
    end
  end
  object DG: TDrawGrid
    Left = 0
    Top = 20
    Width = 379
    Height = 341
    Align = alClient
    DefaultColWidth = 80
    DefaultRowHeight = 20
    RowCount = 16
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
    TabOrder = 1
    OnDrawCell = DGDrawCell
  end
end
