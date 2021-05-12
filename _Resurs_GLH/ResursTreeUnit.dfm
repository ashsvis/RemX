object ResursTreeForm: TResursTreeForm
  Left = 193
  Top = 115
  BorderStyle = bsDialog
  Caption = #1055#1088#1077#1086#1073#1088#1072#1079#1086#1074#1072#1090#1077#1083#1100' "'#1056#1077#1089#1091#1088#1089'-GLH"'
  ClientHeight = 463
  ClientWidth = 777
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Splitter1: TSplitter
    Left = 273
    Top = 20
    Height = 443
    Beveled = True
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 777
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
  object TV: TTreeView
    Left = 0
    Top = 20
    Width = 273
    Height = 443
    Align = alLeft
    Color = clBlack
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clMoneyGreen
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    Indent = 19
    ParentFont = False
    ReadOnly = True
    TabOrder = 1
    OnChange = TVChange
    OnExpanded = TVExpanded
    Items.Data = {
      03000000220000000000000000000000FFFFFFFFFFFFFFFF0000000001000000
      09CFE0F0E0ECE5F2F0FB190000000000000000000000FFFFFFFFFFFFFFFF0000
      000000000000001F0000000000000000000000FFFFFFFFFFFFFFFF0000000001
      00000006C4E0EDEDFBE5190000000000000000000000FFFFFFFFFFFFFFFF0000
      00000000000000210000000000000000000000FFFFFFFFFFFFFFFF0000000001
      00000008CFF0EEF2EEEAEEEB190000000000000000000000FFFFFFFFFFFFFFFF
      000000000000000000}
  end
  object LV: TListView
    Left = 276
    Top = 20
    Width = 501
    Height = 443
    Align = alClient
    Columns = <>
    ReadOnly = True
    TabOrder = 2
    ViewStyle = vsReport
  end
end
