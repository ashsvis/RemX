object EditReportForm: TEditReportForm
  Left = 210
  Top = 150
  Align = alClient
  BorderStyle = bsNone
  Caption = 'EditReportForm'
  ClientHeight = 453
  ClientWidth = 688
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnHide = FormHide
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object ReportControlBar: TControlBar
    Left = 0
    Top = 0
    Width = 688
    Height = 26
    Align = alTop
    AutoDock = False
    AutoDrag = False
    AutoSize = True
    BevelEdges = [beTop]
    ParentShowHint = False
    RowSize = 24
    ShowHint = True
    TabOrder = 0
    object ReportToolMenu: TToolBar
      Left = 11
      Top = 2
      Width = 315
      Height = 20
      Align = alNone
      AutoSize = True
      ButtonHeight = 20
      ButtonWidth = 105
      Caption = 'ReportToolMenu'
      EdgeBorders = []
      EdgeInner = esNone
      EdgeOuter = esNone
      Flat = True
      List = True
      ShowCaptions = True
      TabOrder = 0
      Wrapable = False
      object tbReports: TToolButton
        Left = 0
        Top = 0
        AutoSize = True
        Caption = #1054#1090#1095#1077#1090
      end
      object tbEditMenu: TToolButton
        Left = 46
        Top = 0
        AutoSize = True
        Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077
      end
      object tbToolMenu: TToolButton
        Left = 150
        Top = 0
        AutoSize = True
        Caption = #1048#1085#1089#1090#1088#1091#1084#1077#1085#1090#1099
      end
    end
  end
  object ReportPanel: TPanel
    Left = 0
    Top = 26
    Width = 688
    Height = 427
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 80
    Top = 48
  end
  object frReportPreview: TfrReport
    InitialZoom = pzPageWidth
    ModifyPrepared = False
    PreviewButtons = [pbZoom, pbPrint, pbExit]
    ShowProgress = False
    Left = 40
    Top = 88
    ReportForm = {18000000}
  end
end
