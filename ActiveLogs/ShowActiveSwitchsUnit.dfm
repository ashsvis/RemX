object ShowActiveSwitchsForm: TShowActiveSwitchsForm
  Left = 601
  Top = 137
  ActiveControl = DrawGrid
  Align = alClient
  BorderStyle = bsNone
  Caption = 'ShowActiveSwitchsForm'
  ClientHeight = 440
  ClientWidth = 790
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
    Width = 790
    Height = 412
    Align = alClient
    BorderStyle = bsNone
    Color = clBlack
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
    OnSelectCell = DrawGridSelectCell
  end
  object ControlBar: TControlBar
    Left = 0
    Top = 412
    Width = 790
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
      Width = 774
      Height = 36
      BevelOuter = bvNone
      TabOrder = 0
      DesignSize = (
        774
        36)
      object btnOverview: TButton
        Left = 683
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
        TabOrder = 0
        OnClick = btnOverviewClick
      end
      object btnTrends: TButton
        Left = 604
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
        TabOrder = 1
        OnClick = btnTrendsClick
      end
    end
  end
end
