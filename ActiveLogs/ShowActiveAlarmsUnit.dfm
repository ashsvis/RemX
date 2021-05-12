object ShowActiveAlarmsForm: TShowActiveAlarmsForm
  Left = 497
  Top = 215
  ActiveControl = DrawGrid
  Align = alClient
  BorderStyle = bsNone
  Caption = 'ShowActiveAlarmsForm'
  ClientHeight = 434
  ClientWidth = 784
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 16
  object DrawGrid: TDrawGrid
    Left = 0
    Top = 0
    Width = 784
    Height = 406
    Align = alClient
    BorderStyle = bsNone
    Color = clBlack
    ColCount = 7
    Ctl3D = True
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 2
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clMoneyGreen
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    GridLineWidth = 0
    Options = [goFixedVertLine, goFixedHorzLine, goRowSelect]
    ParentCtl3D = False
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
    OnDblClick = DrawGridDblClick
    OnDrawCell = DrawGridDrawCell
    OnKeyDown = DrawGridKeyDown
    OnMouseDown = DrawGridMouseDown
    OnSelectCell = DrawGridSelectCell
  end
  object ControlBar: TControlBar
    Left = 0
    Top = 406
    Width = 784
    Height = 28
    Align = alBottom
    AutoDock = False
    AutoDrag = False
    BevelEdges = []
    Color = clBtnFace
    ParentBackground = False
    ParentColor = False
    RowSize = 20
    RowSnap = False
    TabOrder = 1
    object StatusPanel: TPanel
      Left = 11
      Top = 2
      Width = 766
      Height = 36
      BevelOuter = bvNone
      TabOrder = 0
      DesignSize = (
        766
        36)
      object btnTrends: TButton
        Left = 472
        Top = 0
        Width = 77
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #1043#1088#1072#1092#1080#1082#1080
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = btnTrendsClick
      end
      object btnOverview: TButton
        Left = 552
        Top = 0
        Width = 85
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #1054#1073#1097#1080#1081' '#1074#1080#1076
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = btnOverviewClick
      end
      object btnAskAll: TButton
        Left = 640
        Top = 0
        Width = 121
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #1050#1074#1080#1090#1080#1088#1086#1074#1072#1090#1100' '#1074#1089#1105
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = btnAskAllClick
      end
    end
  end
end
