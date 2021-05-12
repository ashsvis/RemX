object ShowTrendsForm: TShowTrendsForm
  Left = 198
  Top = 142
  Align = alClient
  BorderStyle = bsNone
  Caption = 'ShowTrendsForm'
  ClientHeight = 466
  ClientWidth = 1028
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object TrendView: TChart
    Left = 0
    Top = 28
    Width = 1028
    Height = 386
    AnimatedZoomSteps = 10
    BackWall.Brush.Color = clWhite
    BackWall.Color = clWhite
    Foot.AdjustFrame = False
    Foot.Alignment = taRightJustify
    Foot.Font.Charset = RUSSIAN_CHARSET
    Foot.Font.Color = clBlack
    Foot.Font.Height = -12
    Foot.Font.Name = 'Tahoma'
    Foot.Font.Style = []
    LeftWall.Brush.Color = clWhite
    LeftWall.Size = 10
    MarginBottom = 1
    MarginLeft = 1
    MarginRight = 1
    MarginTop = 1
    PrintProportional = False
    Title.AdjustFrame = False
    Title.Alignment = taLeftJustify
    Title.Font.Charset = RUSSIAN_CHARSET
    Title.Font.Color = clBlack
    Title.Font.Height = -11
    Title.Font.Name = 'Arial'
    Title.Font.Style = [fsItalic]
    Title.Text.Strings = (
      'RemX '#1072#1074#1090#1086#1084#1072#1090#1080#1079#1080#1088#1086#1074#1072#1085#1085#1072#1103' '#1089#1080#1089#1090#1077#1084#1072' '#1082#1086#1085#1090#1088#1086#1083#1103' '#1080' '#1091#1087#1088#1072#1074#1083#1077#1085#1080#1103)
    Title.Visible = False
    OnScroll = TrendViewScroll
    OnUndoZoom = TrendViewUndoZoom
    OnZoom = TrendViewZoom
    BackColor = clWhite
    BottomAxis.Automatic = False
    BottomAxis.AutomaticMaximum = False
    BottomAxis.AutomaticMinimum = False
    BottomAxis.Axis.SmallDots = True
    BottomAxis.DateTimeFormat = 'hh:mm:ss'
    BottomAxis.Grid.Color = clSilver
    BottomAxis.Grid.Visible = False
    BottomAxis.LabelsFont.Charset = RUSSIAN_CHARSET
    BottomAxis.LabelsFont.Color = clBlack
    BottomAxis.LabelsFont.Height = -12
    BottomAxis.LabelsFont.Name = 'Tahoma'
    BottomAxis.LabelsFont.Style = []
    BottomAxis.LabelsMultiLine = True
    BottomAxis.LabelsSeparation = 30
    BottomAxis.MinorTickCount = 2
    BottomAxis.MinorTicks.Color = clBlack
    BottomAxis.TickOnLabelsOnly = False
    BottomAxis.Ticks.Color = clBlack
    BottomAxis.Title.Font.Charset = RUSSIAN_CHARSET
    BottomAxis.Title.Font.Color = clBlack
    BottomAxis.Title.Font.Height = -12
    BottomAxis.Title.Font.Name = 'Tahoma'
    BottomAxis.Title.Font.Style = []
    LeftAxis.Automatic = False
    LeftAxis.AutomaticMaximum = False
    LeftAxis.AutomaticMinimum = False
    LeftAxis.AxisValuesFormat = '#,##0.### %'
    LeftAxis.Maximum = 100.000000000000000000
    LeftAxis.MinorTickCount = 4
    LeftAxis.Visible = False
    Legend.Alignment = laBottom
    Legend.ColorWidth = 40
    Legend.Font.Charset = RUSSIAN_CHARSET
    Legend.Font.Color = clBlack
    Legend.Font.Height = -11
    Legend.Font.Name = 'Arial'
    Legend.Font.Style = []
    Legend.LegendStyle = lsSeries
    Legend.ShadowSize = 1
    Legend.TextStyle = ltsRightValue
    Legend.TopPos = 0
    Legend.Visible = False
    RightAxis.Automatic = False
    RightAxis.AutomaticMaximum = False
    RightAxis.AutomaticMinimum = False
    RightAxis.Axis.SmallDots = True
    RightAxis.Grid.Visible = False
    RightAxis.LabelsFont.Charset = RUSSIAN_CHARSET
    RightAxis.LabelsFont.Color = clBlack
    RightAxis.LabelsFont.Height = -12
    RightAxis.LabelsFont.Name = 'Tahoma'
    RightAxis.LabelsFont.Style = []
    RightAxis.LabelsSeparation = 30
    RightAxis.MinorTickCount = 4
    RightAxis.MinorTicks.Color = clBlack
    RightAxis.TickOnLabelsOnly = False
    RightAxis.Ticks.Color = clBlack
    RightAxis.Title.Angle = 90
    RightAxis.Title.Caption = '%'
    RightAxis.Title.Font.Charset = RUSSIAN_CHARSET
    RightAxis.Title.Font.Color = clBlack
    RightAxis.Title.Font.Height = -12
    RightAxis.Title.Font.Name = 'Tahoma'
    RightAxis.Title.Font.Style = []
    TopAxis.Grid.Visible = False
    TopAxis.Visible = False
    View3D = False
    View3DWalls = False
    OnAfterDraw = TrendViewAfterDraw
    Align = alClient
    BevelOuter = bvNone
    BorderStyle = bsSingle
    ParentColor = True
    TabOrder = 0
    OnMouseMove = TrendViewMouseMove
    OnMouseUp = TrendViewMouseUp
    DesignSize = (
      1024
      382)
    object WaitLabel: TLabel
      Left = 0
      Top = 360
      Width = 1024
      Height = 22
      Align = alBottom
      Alignment = taCenter
      AutoSize = False
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1075#1088#1072#1092#1080#1082#1086#1074'...'
      Transparent = True
      Visible = False
    end
    object DateTimeArea: TPaintBox
      Left = 928
      Top = 341
      Width = 105
      Height = 41
      Cursor = crHandPoint
      Anchors = [akRight, akBottom]
      OnClick = DateTimeAreaClick
    end
  end
  object ControlPanel: TPanel
    Left = 0
    Top = 414
    Width = 1028
    Height = 52
    Align = alBottom
    BevelOuter = bvNone
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 1
    TabStop = True
    object Panel1: TPanel
      Left = 0
      Top = 2
      Width = 257
      Height = 25
      BevelOuter = bvNone
      TabOrder = 0
      object Shape1: TShape
        Tag = 1
        Left = 67
        Top = 3
        Width = 12
        Height = 18
        Brush.Color = clGreen
        Pen.Color = clGreen
        Shape = stRoundRect
      end
      object Bevel1: TBevel
        Left = 252
        Top = -1
        Width = 9
        Height = 26
        Shape = bsLeftLine
      end
      object SpeedButton1: TButton
        Tag = 1
        Left = 200
        Top = 0
        Width = 25
        Height = 24
        Hint = #1055#1086' '#1096#1082#1072#1083#1077
        Caption = '%'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        TabStop = False
        OnClick = SpeedButton1Click
      end
      object CheckBox1: TCheckBox
        Tag = 1
        Left = 35
        Top = 4
        Width = 28
        Height = 17
        Hint = #1042#1088#1077#1084#1077#1085#1085#1086' '#1089#1087#1088#1103#1090#1072#1090#1100' '#1075#1088#1072#1092#1080#1082
        TabStop = False
        Caption = '1'
        Color = clBtnFace
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = CheckBox1Click
      end
      object Edit1: TButton
        Tag = 1
        Left = 80
        Top = 0
        Width = 121
        Height = 24
        Cursor = crHandPoint
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        PopupMenu = pmEntityButtonClick
        TabOrder = 1
        OnClick = Edit1Click
      end
    end
    object Panel3: TPanel
      Left = 256
      Top = 2
      Width = 257
      Height = 25
      BevelOuter = bvNone
      TabOrder = 2
      object Shape3: TShape
        Tag = 3
        Left = 67
        Top = 3
        Width = 12
        Height = 18
        Brush.Color = clBlue
        Pen.Color = clGreen
        Shape = stRoundRect
      end
      object Bevel3: TBevel
        Left = 252
        Top = -1
        Width = 9
        Height = 26
        Shape = bsLeftLine
      end
      object SpeedButton3: TButton
        Tag = 3
        Left = 200
        Top = 0
        Width = 25
        Height = 24
        Hint = #1055#1086' '#1096#1082#1072#1083#1077
        Caption = '%'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        TabStop = False
        OnClick = SpeedButton1Click
      end
      object CheckBox3: TCheckBox
        Tag = 3
        Left = 35
        Top = 4
        Width = 28
        Height = 17
        Hint = #1042#1088#1077#1084#1077#1085#1085#1086' '#1089#1087#1088#1103#1090#1072#1090#1100' '#1075#1088#1072#1092#1080#1082
        TabStop = False
        Caption = '3'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = CheckBox1Click
      end
      object Edit3: TButton
        Tag = 3
        Left = 80
        Top = 0
        Width = 121
        Height = 24
        Cursor = crHandPoint
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        PopupMenu = pmEntityButtonClick
        TabOrder = 1
        OnClick = Edit1Click
      end
    end
    object Panel5: TPanel
      Left = 512
      Top = 2
      Width = 257
      Height = 25
      BevelOuter = bvNone
      TabOrder = 4
      object Shape5: TShape
        Tag = 5
        Left = 67
        Top = 3
        Width = 12
        Height = 18
        Brush.Color = clOlive
        Pen.Color = clGreen
        Shape = stRoundRect
      end
      object Bevel5: TBevel
        Left = 252
        Top = -1
        Width = 9
        Height = 26
        Shape = bsLeftLine
      end
      object SpeedButton5: TButton
        Tag = 5
        Left = 200
        Top = 0
        Width = 25
        Height = 24
        Hint = #1055#1086' '#1096#1082#1072#1083#1077
        Caption = '%'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clOlive
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        TabStop = False
        OnClick = SpeedButton1Click
      end
      object CheckBox5: TCheckBox
        Tag = 5
        Left = 35
        Top = 4
        Width = 28
        Height = 17
        Hint = #1042#1088#1077#1084#1077#1085#1085#1086' '#1089#1087#1088#1103#1090#1072#1090#1100' '#1075#1088#1072#1092#1080#1082
        TabStop = False
        Caption = '5'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = CheckBox1Click
      end
      object Edit5: TButton
        Tag = 5
        Left = 80
        Top = 0
        Width = 121
        Height = 24
        Cursor = crHandPoint
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        PopupMenu = pmEntityButtonClick
        TabOrder = 1
        OnClick = Edit1Click
      end
    end
    object Panel7: TPanel
      Left = 768
      Top = 2
      Width = 257
      Height = 25
      BevelOuter = bvNone
      TabOrder = 6
      object Shape7: TShape
        Tag = 7
        Left = 67
        Top = 3
        Width = 12
        Height = 18
        Brush.Color = clTeal
        Pen.Color = clGreen
        Shape = stRoundRect
      end
      object SpeedButton7: TButton
        Tag = 7
        Left = 200
        Top = 0
        Width = 25
        Height = 24
        Hint = #1055#1086' '#1096#1082#1072#1083#1077
        Caption = '%'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        TabStop = False
        OnClick = SpeedButton1Click
      end
      object CheckBox7: TCheckBox
        Tag = 7
        Left = 35
        Top = 4
        Width = 28
        Height = 17
        Hint = #1042#1088#1077#1084#1077#1085#1085#1086' '#1089#1087#1088#1103#1090#1072#1090#1100' '#1075#1088#1072#1092#1080#1082
        TabStop = False
        Caption = '7'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = CheckBox1Click
      end
      object Edit7: TButton
        Tag = 7
        Left = 80
        Top = 0
        Width = 121
        Height = 24
        Cursor = crHandPoint
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        PopupMenu = pmEntityButtonClick
        TabOrder = 1
        OnClick = Edit1Click
      end
    end
    object Panel2: TPanel
      Left = 0
      Top = 26
      Width = 257
      Height = 25
      BevelOuter = bvNone
      TabOrder = 1
      object Shape2: TShape
        Tag = 2
        Left = 67
        Top = 3
        Width = 12
        Height = 18
        Brush.Color = clRed
        Pen.Color = clGreen
        Shape = stRoundRect
      end
      object Bevel2: TBevel
        Left = 252
        Top = -1
        Width = 9
        Height = 26
        Shape = bsLeftLine
      end
      object SpeedButton2: TButton
        Tag = 2
        Left = 200
        Top = 0
        Width = 25
        Height = 24
        Hint = #1055#1086' '#1096#1082#1072#1083#1077
        Caption = '%'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        TabStop = False
        OnClick = SpeedButton1Click
      end
      object CheckBox2: TCheckBox
        Tag = 2
        Left = 35
        Top = 4
        Width = 28
        Height = 17
        Hint = #1042#1088#1077#1084#1077#1085#1085#1086' '#1089#1087#1088#1103#1090#1072#1090#1100' '#1075#1088#1072#1092#1080#1082
        TabStop = False
        Caption = '2'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = CheckBox1Click
      end
      object Edit2: TButton
        Tag = 2
        Left = 80
        Top = 0
        Width = 121
        Height = 24
        Cursor = crHandPoint
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        PopupMenu = pmEntityButtonClick
        TabOrder = 1
        OnClick = Edit1Click
      end
    end
    object Panel4: TPanel
      Left = 256
      Top = 26
      Width = 257
      Height = 25
      BevelOuter = bvNone
      TabOrder = 3
      object Shape4: TShape
        Tag = 4
        Left = 67
        Top = 3
        Width = 12
        Height = 18
        Brush.Color = clMaroon
        Pen.Color = clGreen
        Shape = stRoundRect
      end
      object Bevel4: TBevel
        Left = 252
        Top = 0
        Width = 9
        Height = 26
        Shape = bsLeftLine
      end
      object SpeedButton4: TButton
        Tag = 4
        Left = 200
        Top = 0
        Width = 25
        Height = 24
        Hint = #1055#1086' '#1096#1082#1072#1083#1077
        Caption = '%'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        TabStop = False
        OnClick = SpeedButton1Click
      end
      object CheckBox4: TCheckBox
        Tag = 4
        Left = 35
        Top = 4
        Width = 28
        Height = 17
        Hint = #1042#1088#1077#1084#1077#1085#1085#1086' '#1089#1087#1088#1103#1090#1072#1090#1100' '#1075#1088#1072#1092#1080#1082
        TabStop = False
        Caption = '4'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = CheckBox1Click
      end
      object Edit4: TButton
        Tag = 4
        Left = 80
        Top = 0
        Width = 121
        Height = 24
        Cursor = crHandPoint
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        PopupMenu = pmEntityButtonClick
        TabOrder = 1
        OnClick = Edit1Click
      end
    end
    object Panel6: TPanel
      Left = 512
      Top = 26
      Width = 257
      Height = 25
      BevelOuter = bvNone
      TabOrder = 5
      object Shape6: TShape
        Tag = 6
        Left = 67
        Top = 3
        Width = 12
        Height = 18
        Brush.Color = clFuchsia
        Pen.Color = clGreen
        Shape = stRoundRect
      end
      object Bevel6: TBevel
        Left = 252
        Top = -1
        Width = 9
        Height = 26
        Shape = bsLeftLine
      end
      object SpeedButton6: TButton
        Tag = 6
        Left = 200
        Top = 0
        Width = 25
        Height = 24
        Hint = #1055#1086' '#1096#1082#1072#1083#1077
        Caption = '%'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clFuchsia
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        TabStop = False
        OnClick = SpeedButton1Click
      end
      object CheckBox6: TCheckBox
        Tag = 6
        Left = 35
        Top = 4
        Width = 28
        Height = 17
        Hint = #1042#1088#1077#1084#1077#1085#1085#1086' '#1089#1087#1088#1103#1090#1072#1090#1100' '#1075#1088#1072#1092#1080#1082
        TabStop = False
        Caption = '6'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = CheckBox1Click
      end
      object Edit6: TButton
        Tag = 6
        Left = 80
        Top = 0
        Width = 121
        Height = 24
        Cursor = crHandPoint
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        PopupMenu = pmEntityButtonClick
        TabOrder = 1
        OnClick = Edit1Click
      end
    end
    object Panel8: TPanel
      Left = 768
      Top = 26
      Width = 257
      Height = 25
      BevelOuter = bvNone
      TabOrder = 7
      object Shape8: TShape
        Tag = 8
        Left = 67
        Top = 3
        Width = 12
        Height = 18
        Brush.Color = clBlack
        Pen.Color = clGreen
        Shape = stRoundRect
      end
      object SpeedButton8: TButton
        Tag = 8
        Left = 200
        Top = 0
        Width = 25
        Height = 24
        Hint = #1055#1086' '#1096#1082#1072#1083#1077
        Caption = '%'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        TabStop = False
        OnClick = SpeedButton1Click
      end
      object CheckBox8: TCheckBox
        Tag = 8
        Left = 35
        Top = 4
        Width = 28
        Height = 17
        Hint = #1042#1088#1077#1084#1077#1085#1085#1086' '#1089#1087#1088#1103#1090#1072#1090#1100' '#1075#1088#1072#1092#1080#1082
        TabStop = False
        Caption = '8'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = CheckBox1Click
      end
      object Edit8: TButton
        Tag = 8
        Left = 80
        Top = 0
        Width = 121
        Height = 24
        Cursor = crHandPoint
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        PopupMenu = pmEntityButtonClick
        TabOrder = 1
        OnClick = Edit1Click
      end
    end
  end
  object TrendControlBar: TControlBar
    Left = 0
    Top = 0
    Width = 1028
    Height = 28
    Align = alTop
    AutoSize = True
    BevelEdges = [beTop]
    TabOrder = 2
    object ToolBar: TToolBar
      Left = 11
      Top = 2
      Width = 873
      Height = 22
      Align = alNone
      AutoSize = True
      ButtonWidth = 83
      Caption = 'ToolBar'
      Color = clBtnFace
      EdgeBorders = []
      Flat = True
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      Images = ImageList
      List = True
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      ShowCaptions = True
      ShowHint = True
      TabOrder = 0
      Transparent = False
      Wrapable = False
      object tbPrinting: TToolButton
        Left = 0
        Top = 0
        Hint = #1055#1077#1095#1072#1090#1100' '#1075#1088#1072#1092#1080#1082#1072
        AutoSize = True
        Caption = #1055#1077#1095#1072#1090#1100'...'
        ImageIndex = 3
        OnClick = tbPrintingClick
      end
      object tbPreview: TToolButton
        Left = 83
        Top = 0
        AutoSize = True
        Caption = #1055#1088#1086#1089#1084#1086#1090#1088
        ImageIndex = 7
        OnClick = tbPrintingClick
      end
      object ToolButton2: TToolButton
        Left = 170
        Top = 0
        Width = 8
        Caption = 'ToolButton2'
        ImageIndex = 5
        Style = tbsSeparator
      end
      object tbZoomIn: TToolButton
        Left = 178
        Top = 0
        Hint = #1059#1074#1077#1083#1080#1095#1080#1090#1100' '#1084#1072#1089#1096#1090#1072#1073
        AutoSize = True
        Caption = #1041#1083#1080#1078#1077
        ImageIndex = 0
        OnClick = tbZoomInClick
      end
      object tbZoomOut: TToolButton
        Left = 247
        Top = 0
        Hint = #1059#1084#1077#1085#1100#1096#1080#1090#1100' '#1084#1072#1089#1096#1090#1072#1073
        AutoSize = True
        Caption = #1044#1072#1083#1100#1096#1077
        ImageIndex = 1
        OnClick = tbZoomOutClick
      end
      object tbZoomReset: TToolButton
        Left = 320
        Top = 0
        Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1084#1072#1089#1096#1090#1072#1073#1080#1088#1086#1074#1072#1085#1080#1077
        AutoSize = True
        Caption = #1042#1077#1088#1085#1091#1090#1100
        ImageIndex = 2
        OnClick = tbZoomResetClick
      end
      object ToolButton1: TToolButton
        Left = 397
        Top = 0
        Width = 8
        Caption = 'ToolButton1'
        ImageIndex = 4
        Style = tbsSeparator
      end
      object tbLessTime: TToolButton
        Left = 405
        Top = 0
        Hint = #1050' '#1087#1088#1077#1076#1099#1076#1091#1097#1077#1084#1091' '#1087#1077#1088#1080#1086#1076#1091
        AutoSize = True
        ImageIndex = 5
        OnClick = tbLessTimeClick
      end
      object tbTimeSelect: TToolButton
        Left = 440
        Top = 0
        Hint = #1047#1072#1076#1072#1090#1100' '#1087#1077#1088#1080#1086#1076' '#1087#1088#1086#1089#1084#1086#1090#1088#1072
        AutoSize = True
        Caption = #1042#1088#1077#1084#1103
        DropdownMenu = TimePopupMenu
        ImageIndex = 4
      end
      object tbMoreTime: TToolButton
        Left = 507
        Top = 0
        Hint = #1050' '#1089#1083#1077#1076#1091#1102#1097#1077#1084#1091' '#1087#1077#1088#1080#1086#1076#1091
        AutoSize = True
        ImageIndex = 6
        OnClick = tbMoreTimeClick
      end
      object ScrollingPanel: TPanel
        Left = 542
        Top = 0
        Width = 110
        Height = 22
        BevelOuter = bvNone
        TabOrder = 0
        object cbScrolling: TCheckBox
          Left = 8
          Top = 3
          Width = 95
          Height = 17
          Caption = #1054#1090#1089#1083#1077#1078#1080#1074#1072#1090#1100
          TabOrder = 0
          OnClick = cbScrollingClick
        end
      end
      object tbGrid: TToolButton
        Left = 652
        Top = 0
        Hint = #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1089#1077#1090#1082#1091' '#1075#1088#1072#1092#1080#1082#1072
        AutoSize = True
        Caption = #1057#1077#1090#1082#1072
        ImageIndex = 8
        Style = tbsCheck
        OnClick = tbGridClick
      end
    end
  end
  object ImageList: TImageList
    Left = 88
    Top = 344
    Bitmap = {
      494C010109000E00040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000636B6B00636B6B00636B
      6B00636B6B00636B6B00636B6B00636B6B00636B6B00636B6B00636B6B00636B
      6B00636B6B00636B6B00636B6B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008C8C8C00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF008C8C8C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008C8C8C00FFFFFF00FFB5
      6B00FFB56B00FFB56B00FFB56B00FFB56B00FFB56B00FFB56B00FFB56B00FFB5
      6B00FFB56B00FFFFFF008C8C8C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008C8C8C00FFFFFF00FFB5
      6B00FFFFFF00FFFFFF00FFB56B00FFFFFF00FFFFFF00FFB56B00FFFFFF00FFFF
      FF00FFB56B00FFFFFF008C8C8C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009C9C9400FFFFFF00FFB5
      6B00FFFFFF00FFFFFF00FFB56B00FFFFFF00FFFFFF00FFB56B00FFFFFF00FFFF
      FF00FFB56B00FFFFFF009C9C9400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009C9C9400FFFFFF00FFB5
      6B00FFB56B00FFB56B00FFB56B00FFB56B00FFB56B00FFB56B00FFB56B00FFB5
      6B00FFB56B00FFFFFF009C9C9400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009C9C9400FFFFFF00F7A5
      5A00FFFFFF00FFFFFF00F7A55A00FFFFFF00FFFFFF00F7A55A00FFFFFF00FFFF
      FF00F7A55A00FFFFFF009C9C9400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A5A5A500F7F7F700F7A5
      5A00FFFFFF00FFFFFF00F7A55A00FFFFFF00FFFFFF00F7A55A00FFFFFF00FFFF
      FF00F7A55A00F7F7F700A5A5A500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A5A5A500F7F7F700EF9C
      2100EF9C2100EF9C2100EF9C2100EF9C2100EF9C2100EF9C2100EF9C2100EF9C
      2100EF9C2100F7F7F700A5A5A500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000ADADAD00EFEFEF00EF9C
      2100FFFFFF00FFFFFF00EF9C2100FFFFFF00FFFFFF00EF9C2100FFFFFF00FFFF
      FF00EF9C2100EFEFEF00ADADAD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000ADADAD00EFEFEF00EF9C
      2100FFFFFF00FFFFFF00EF9C2100FFFFFF00FFFFFF00EF9C2100FFFFFF00FFFF
      FF00EF9C2100EFEFEF00ADADAD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B5B5B500DEDEDE00EF9C
      2100EF9C2100EF9C2100EF9C2100EF9C2100EF9C2100EF9C2100EF9C2100EF9C
      2100EF9C2100DEDEDE00B5B5B500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B5B5B500DEDEDE00DEDE
      DE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDE
      DE00DEDEDE00DEDEDE00B5B5B500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B5B5B500B5B5B500B5B5
      B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5B500B5B5
      B500B5B5B500B5B5B500B5B5B500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008C8C8C00949494009494940094949400949494008C8C8C000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000039AD39001094100000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000001094100039AD390000000000000000000000
      0000000000000000000000000000000000000000000000000000A5636B00A563
      6B00A5636B00A5636B00A5636B00A5636B00A5636B00A5636B00A5636B00A563
      6B00A5636B00A5636B00A5636B00000000000000000000000000000000008C8C
      8C009C9C9C006B6B6B006B6B6B006B6B6B006B6B6B006B6B6B006B6B6B009C94
      94008C8C8C000000000000000000000000000000000000000000000000000000
      0000000000000000000039AD3900218C180000AD000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000AD0000218C180039AD3900000000000000
      00000000000000000000000000000000000000000000000000004A526300FFEF
      C600F7D6B500EFD6AD00EFCE9C00EFCE9400EFC68C00EFBD8400EFBD7B00EFBD
      8400EFBD8400EFC68400A5636B000000000000000000000000009C9C9C00B5B5
      B5006B6B6B00ADADAD00ADA59C00ADADA500A5A5AD00ADA59400A59C94006B6B
      6B00B5ADAD008C8C8C0000000000000000000000000000000000000000000000
      00000000000039AD390018841800219C1800009C000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000009C0000219C18001884180039AD39000000
      00000000000000000000000000000000000000000000636B8400186BC600636B
      8400F7DEBD00EFD6AD00EFCEA500EFCE9C00EFC69400EFC68C00EFBD8400EFBD
      7B00EFBD7B00EFC68400A5636B0000000000000000008C8C8C00B5B5B5006B6B
      6B00ADA59C00D6D6BD00FFEFD600DECED600BDB5D600FFFFE700DEDED6009C94
      8C006B6B6B00B5ADAD008C8C8C00000000000000000000000000000000000000
      000039AD3900088C100008840000088C0000009C000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000009C0000088C000008840000088C100039AD
      390000000000000000000000000000000000000000000000000031A5FF001073
      D6006B6B8400F7DEBD00EFD6B500EFCEA500EFCE9C00EFC69400EFC68C00EFBD
      8400EFBD7B00EFC68400A5636B000000000000000000ADA5AD0084848400BDCE
      BD00DEDEC600FFF7DE00F7D6A500F7C69400F7BD8400F7CE9C00FFFFE700EFF7
      EF009C9484006B6B6B009C9494000000000000000000000000000000000039AD
      3900107B100063AD630021942100008C0000088C080000B5000000B5080018C6
      180042DE420052E752006BDE6B0000AD000000AD00006BDE6B0052E7520042DE
      420018C6180000B5080000B50000088C0800008C00002194210063AD6300107B
      100039AD39000000000000000000000000000000000000000000A5635A0031A5
      FF001073D6005A638400F7DEBD00EFD6AD00EFCEA500EFCE9C00EFC69400EFC6
      8C00EFBD8400EFC68400A5636B00000000008C8C8C0084848400BDCEBD00ADA5
      9C00EFF7EF00FFF7CE00FFFFD600FFF7CE00F7DEAD00F7C69400F7CE9C008484
      7B005A5A5200AD948C006B6B6B00A59C9C00000000000000000039AD3900187B
      180063AD6300218C180000840000008C0800008C000000A5000000B5000000BD
      000008C6000018D6180063E76300009C0800009C080063E7630018D6180008C6
      000000BD000000B5000000A50000008C0000008C080000840000218C180063AD
      6300187B180039AD390000000000000000000000000000000000A5736B00FFF7
      EF0031A5FF00427BAD008C635A00AD7B730094635A00AD7B6B00CEA58400EFC6
      9400EFC68C00EFC68400A5636B0000000000A59CA50084848400ADA59C00EFF7
      EF00EFF7EF00EFF7EF00FFFFDE00FFFFDE00FFFFD600FFEFBD0084847B005A5A
      5200FFF7DE00A59C8C006B6B6B00A59C9C000000000039AD3900187B180063AD
      6300187B2100007B000000840000008C0800009C000000AD000000B5000000BD
      000000C6000000CE000063E76300109408001094080063E7630000CE000000C6
      000000BD000000B5000000AD0000009C0000008C080000840000007B0000187B
      210063AD6300187B180039AD3900000000000000000000000000A5736B00FFFF
      FF00F7EFE700AD8C8C00B58C8400DEBDA500EFD6B500D6B59C00B58C7300CEA5
      8400EFC69400EFC68C00A5636B0000000000A59CA50084848400ADA59C00EFF7
      EF00EFF7EF00EFF7EF00FFFFDE00C6BDAD0084847B0084847B005A5A5200FFDE
      A500DECED6009C94A5006B6B6B00AD9C9C0039AD3900187B210063AD6300298C
      3100007B00000084000000840000008C08000094000000AD000000B5000000BD
      000008C6000000CE000063E76B0000A5000000A5000063E76B0000CE000008C6
      000000BD000000B5000000AD000000940000008C08000084000000840000007B
      0000298C310063AD6300187B210039AD39000000000000000000BD846B00FFFF
      FF00FFF7EF00AD847B00DEC6B500F7E7CE00F7E7C600FFFFF700D6B59C00AD7B
      6B00EFCE9C00EFCE9400A5636B0000000000A59CA50084848400ADA59C00EFF7
      EF00EFF7EF00FFFFDE00FFFFDE00C6BDAD005252520042423900FFDEA500D6AD
      7B00C6BDCE008C8CA5006B6B6B00AD9C9C0039AD39001873290063AD6300398C
      310000730000007B000000840000008C08000094080000AD000000B5000000BD
      000008C6000000CE00006BE76B00089C0000089C00006BE76B0000CE000008C6
      000000BD000000B5000000AD000000940800008C080000840000007B00000073
      0000398C310063AD63001873290039AD39000000000000000000BD846B00FFFF
      FF00FFFFFF0094636300F7EFDE00F7EFDE00F7E7CE00FFFFEF00EFD6B5009463
      5A00EFCEA500F7D6A500A5636B0000000000A59CA50084848400ADA59C00EFF7
      EF00EFF7EF00FFFFFF00FFFFF700FFFFDE00DEDEC600636B5A0084847B00FFDE
      A500FFF7CE00ADA594006B6B6B00A59C9C000000000039AD3900187B210063AD
      630029841800087B080000840000009400000094000000A5000000B5000000BD
      000008C6000000CE000063E76300009C0000009C000063E7630000CE000008C6
      000000BD000000B5000000A50000009400000094000000840000087B08002984
      180063AD6300187B210039AD3900000000000000000000000000D6946B00FFFF
      FF00FFFFFF00B58C8400DEC6C600F7EFE700F7EFDE00FFFFD600DEBDA500AD7B
      7300F7D6AD00EFCEA500A5636B00000000008C8C8C0084848400ADA59C00EFF7
      EF00EFF7EF00EFF7EF00FFFFFF00FFFFF700FFFFEF00EFEFD6005A5A52008484
      7B00DEDEC600B59C9C006B6B6B00A59C9C00000000000000000039AD3900107B
      180063AD6300108C180000840000008C00000894000000AD080000B5000000BD
      000008C6000018D618006BEF630000940800009408006BEF630018D6180008C6
      000000BD000000B5000000AD080008940000008C000000840000108C180063AD
      6300107B180039AD390000000000000000000000000000000000D6946B00FFFF
      FF00FFFFFF00D6BDBD00BD949400DEC6C600F7EFDE00DEC6B500B58C8400B58C
      7B00DECEB500B5AD9400A5636B000000000000000000A59CA50084848400ADA5
      9C00EFF7EF00EFF7EF00EFF7EF00EFF7EF00F7F7F700FFFFFF00EFEFD6005A5A
      5200ADA59C006B6B6B00A59C9C000000000000000000000000000000000039AD
      3900107B100063AD630018942100009400000094000000AD000000B5080018C6
      180042DE42005AE75A007BDE7B0000AD000000AD00007BDE7B005AE75A0042DE
      420018C6180000B5080000AD000000940000009400001894210063AD6300107B
      100039AD39000000000000000000000000000000000000000000DE9C7300FFFF
      FF00FFFFFF00FFFFFF00D6BDBD00B58C840094636300AD847B00CEA59C00A56B
      5A00A56B5A00A56B5A00A5636B0000000000000000008C8C8C00B5ADB5008484
      8400ADA59C00EFF7EF00EFF7EF00EFF7EF00EFF7EF00EFEFE700EFEFE700BDB5
      AD006B6B6B00B5A5A5008C8C8C00000000000000000000000000000000000000
      000039AD3900088C100008840000008C0000009C000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000009C0000008C000008840000088C100039AD
      3900000000000000000000000000000000000000000000000000DE9C7300FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFF700FFFFF700D6BDBD00A56B
      5A00E79C5200E78C3100B56B4A0000000000000000000000000094949400ADAD
      AD0084848400ADA59C008CAD840094AD8C00ADBD9C00C6C6B500C6B5B5006B6B
      6B00B5A5A5009494940000000000000000000000000000000000000000000000
      00000000000039AD3900188C1800189418001094080000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000001094080018941800188C180039AD39000000
      0000000000000000000000000000000000000000000000000000E7AD7B00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00DEC6C600A56B
      5A00FFB55A00BD7B5A0000000000000000000000000000000000000000008C8C
      8C009C9C9C00848484006B6B6B006B6B6B006B6B6B006B6B6B006B6B6B009C9C
      9C008C8C8C000000000000000000000000000000000000000000000000000000
      0000000000000000000039AD390018941800009C000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000009C00001894180039AD3900000000000000
      0000000000000000000000000000000000000000000000000000E7AD7B00F7F7
      EF00F7F7EF00F7F7EF00F7F7EF00F7F7EF00F7F7EF00F7F7EF00D6BDBD00A56B
      5A00BD846B000000000000000000000000000000000000000000000000000000
      0000000000008C8C8C008C8C8C0094949400949494008C8C8C008C8C8C000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000039AD39002194210000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000002194210039AD390000000000000000000000
      0000000000000000000000000000000000000000000000000000E7AD7B00D694
      6B00D6946B00D6946B00D6946B00D6946B00D6946B00D6946B00D6946B00A56B
      5A0000000000000000000000000000000000000000004A637B00BD9494000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004A637B00BD9494000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A5636B00A563
      6B00A5636B00A5636B00A5636B00A5636B00A5636B00A5636B00A5636B00A563
      6B00A5636B00A5636B00A5636B00000000000000000000000000000000000000
      000000000000000000009C9C9C00000000000000000000000000848484008484
      84008C8C8C000000000000000000000000006B9CC600188CE7004A7BA500C694
      9400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006B9CC600188CE7004A7BA500C694
      9400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A5636B00FFEF
      C600C6CE9400D6CE9400EFCE9C00E7CE9400EFC68400EFBD8400EFBD7B00EFBD
      8400EFBD8400EFC68400A5636B00000000000000000000000000000000000000
      00009C9C9C009C9C9C00D6CECE009494940039393900525252009C949400C6C6
      C600D6D6D6008484840000000000000000004AB5FF0052B5FF00218CEF004A7B
      A500C69494000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004AB5FF0052B5FF00218CEF004A7B
      A500C69494000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A5636B00FFEF
      CE009CBD7300299C21006BAD4A0021941000219410005AA53900CEB57300EFBD
      7B00EFBD7B00EFC68400A5636B000000000000000000000000009C9C9C009C9C
      9C00F7F7F700FFFFFF00D6D6D6009C9C9C004242420021182100211821003131
      310063636300848484008C8C8C00000000000000000052B5FF0052B5FF001884
      E7004A7BA500C694940000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000052B5FF0052B5FF001884
      E7004A7BA500C694940000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A5635A00FFEF
      DE00BDCE9C00108C08000084000000840000008400000084000029941800DEBD
      7B00EFBD7B00EFC68400A5636B0000000000948C8C009C9C9C00EFEFEF00FFFF
      FF00EFE7E700C6C6C6009C9C9C008C8C8C009494940084848400636363003939
      390018212100211821007373730000000000000000000000000052B5FF004AB5
      FF00188CE7004A7BA500BD949400000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000052B5FF004AB5
      FF00188CE7004A7BA500BD949400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A5635A00FFF7
      E700BDCE9C00189410000084000018941000ADBD730073AD4A000084000073AD
      4A00EFBD8400EFC68400A5636B00000000009C9C9C00E7E7E700E7E7E700BDBD
      BD00A5A5A500B5ADAD00C6BDBD00A5A5A50094949400948C8C00949494009C94
      94008C8C8C006B6B6B00848484000000000000000000000000000000000052B5
      FF004AB5FF002184DE005A6B730000000000AD7B7300C6A59C00D6B5A500CEA5
      9C000000000000000000000000000000000000000000000000000000000052B5
      FF004AB5FF002184DE005A6B730000000000AD7B7300C6A59C00D6B5A500CEA5
      9C00000000000000000000000000000000000000000000000000A5736B00FFF7
      EF00BDD6A500088C0800008400000084000084B55A00EFCEA500A5B56B006BAD
      4A00EFC68C00EFC68400A5636B000000000094949400ADADAD00A5A5A500ADAD
      AD00C6C6C600D6D6D600EFEFEF00EFEFEF00DEDEDE00C6C6C600ADADAD009C9C
      9C00948C8C00949494008C8C8C00000000000000000000000000000000000000
      000052BDFF00B5D6EF00A5948C00B59C8C00F7E7CE00FFFFD600FFFFD600FFFF
      D600E7DEBD00CEADA50000000000000000000000000000000000000000000000
      000052BDFF00B5D6EF00A5948C00B59C8C00F7E7CE00FFFFD600FFFFD600FFFF
      D600E7DEBD00CEADA50000000000000000000000000000000000A5736B00FFFF
      FF00E7E7D600A5CE94009CC6840094BD73009CBD7300EFD6AD00EFCEA5009CC6
      7B00EFC69400EFC68C00A5636B0000000000948C8C00ADADAD00C6C6C600CECE
      CE00C6C6C600DEDEDE00CECECE00A5ADA500BDBDBD00CECECE00D6D6D600D6D6
      D600C6C6C600B5B5B50094949400000000000000000000000000000000000000
      000000000000CEB5B500D6B5A500FFEFC600FFFFD600FFFFD600FFFFD600FFFF
      DE00FFFFEF00F7F7EF00B58C8C00000000000000000000000000000000000000
      000000000000CEB5B500D6B5A500FFEFC600FFFFD600FFFFD600FFFFD600FFFF
      DE00FFFFEF00F7F7EF00B58C8C00000000000000000000000000BD846B00FFFF
      FF00A5DEA500FFEFE700F7EFD6009CC6840094BD730094BD73009CBD7300EFCE
      A500EFCE9C00F7CE9400A5636B0000000000000000009C9C9C00CECECE00CECE
      CE00DEDEDE00C6C6C600B5B5B500A5D6A500BDC6BD00C6A5A500ADA5A500A5A5
      A500B5B5B500C6BDBD00A5A5A500000000000000000000000000000000000000
      000000000000C6948C00F7DEB500F7D6A500FFF7CE00FFFFD600B55A1800FFFF
      EF00FFFFF700FFFFFF00DED6BD00000000000000000000000000000000000000
      000000000000C6948C00F7DEB500F7D6A500FFF7CE00FFFFD600FFFFDE00FFFF
      EF00FFFFF700FFFFFF00DED6BD00000000000000000000000000BD846B00FFFF
      FF0073C67300ADD6A500FFEFE70084C673000084000000840000088C0800EFD6
      AD00EFCEA500F7D6A500A5636B000000000000000000000000009C9C9C00BDBD
      BD00ADADAD00ADADAD00E7E7E700F7EFEF00EFEFEF00EFE7DE00D6D6D600CECE
      CE00B5B5B5009494940000000000000000000000000000000000000000000000
      000000000000DEBDA500FFE7AD00F7CE9400FFF7CE00E7D6C600B55A1800E7D6
      C600E7D6C600FFFFEF00F7EFD600C69C94000000000000000000000000000000
      000000000000DEBDA500FFE7AD00F7CE9400E7D6C600E7D6C600E7D6C600E7D6
      C600E7D6C600FFFFEF00F7EFD600C69C94000000000000000000D6946B00FFFF
      FF0084CE8400008400007BC67300ADD6A5001894180000840000108C0800F7D6
      B500F7D6AD00EFCEA500A5636B00000000000000000000000000000000009C9C
      9C00D6D6D600CECECE009C9C9C00BDBDBD00D6D6D600D6D6D600D6D6D600C6C6
      C600ADADAD000000000000000000000000000000000000000000000000000000
      000000000000E7C6AD00FFDEAD00EFBD8400B55A1800B55A1800B55A1800B55A
      1800B55A1800FFFFDE00F7F7D600C6AD9C000000000000000000000000000000
      000000000000E7C6AD00FFDEAD00EFBD8400B55A1800B55A1800B55A1800B55A
      1800B55A1800FFFFDE00F7F7D600C6AD9C000000000000000000D6946B00FFFF
      FF00F7F7EF0029A5290000840000008400000084000000840000108C0800FFEF
      CE00DECEB500B5AD9400A5636B00000000000000000000000000000000000000
      0000FFE7E700FFDECE00E7C6BD00E7C6BD00E7CEC600DED6CE00CECECE009494
      9400000000000000000000000000000000000000000000000000000000000000
      000000000000DEBDAD00FFE7B500EFBD8400F7CE9400FFEFC600B55A1800FFEF
      C600FFFFDE00FFFFDE00F7EFD600C6A59C000000000000000000000000000000
      000000000000DEBDAD00FFE7B500EFBD8400F7CE9400FFEFC600FFFFDE00FFFF
      DE00FFFFDE00FFFFDE00F7EFD600C6A59C000000000000000000DE9C7300FFFF
      FF00FFFFFF00DEF7DE0063BD6300219C2100219C210073BD6B00299C2100946B
      5200A56B5A00A56B5A00A5636B00000000000000000000000000000000000000
      0000CE9C9C00FFDECE00FFCEBD00FFC6AD00FFBDA500FFAD9C00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C69C9400FFEFC600FFEFC600F7D6A500F7CE9C00B55A1800FFF7
      CE00FFF7D600FFFFD600E7DEBD00000000000000000000000000000000000000
      000000000000C69C9400FFEFC600FFEFC600F7D6A500F7CE9C00F7E7B500FFF7
      CE00FFF7D600FFFFD600E7DEBD00000000000000000000000000DE9C7300FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00DEF7DE00DEF7DE00FFFFF700ADB594008C6B
      5200E79C5200E78C3100B56B4A00000000000000000000000000000000000000
      0000CE9C9C00FFDECE00FFCEBD00FFC6AD00FFBDA500F7AD9400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000DEC6AD00FFFFFF00FFF7EF00F7CE9400EFBD8400F7CE
      9C00FFE7B500FFF7C600BD9C8C00000000000000000000000000000000000000
      00000000000000000000DEC6AD00FFFFFF00FFF7EF00F7CE9400EFBD8400F7CE
      9C00FFE7B500FFF7C600BD9C8C00000000000000000000000000E7AD7B00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00DEC6C600A56B
      5A00FFB55A00BD7B5A0000000000000000000000000000000000000000000000
      0000CE9C9C00FFDECE00FFCEBD00FFC6AD00FFBDA500F7AD9C00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000D6BDBD00F7EFD600FFEFC600FFE7AD00FFE7
      B500F7DEB500CEAD9C0000000000000000000000000000000000000000000000
      0000000000000000000000000000D6BDBD00F7EFD600FFEFC600FFE7AD00FFE7
      B500F7DEB500CEAD9C0000000000000000000000000000000000E7AD7B00F7F7
      EF00F7F7EF00F7F7EF00F7F7EF00F7F7EF00F7F7EF00F7F7EF00DEC6C600A56B
      5A00BD846B00000000000000000000000000000000000000000000000000CE9C
      9C00FFE7D600FFDECE00FFCEBD00FFC6AD00FFBDA500F7AD9C00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CEAD9400CEAD9C00DEBDA500DEBD
      A500000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CEAD9400CEAD9C00DEBDA500DEBD
      A500000000000000000000000000000000000000000000000000E7AD7B00D694
      6B00D6946B00D6946B00D6946B00D6946B00D6946B00D6946B00D6946B00A56B
      5A0000000000000000000000000000000000000000000000000000000000CE9C
      9C00CE9C9C00CE9C9C00CE9C9C00F7AD9C00F7AD9C0000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF00FFFF0000000000008001000000000000
      8001000000000000800100000000000080010000000000008001000000000000
      8001000000000000800100000000000080010000000000008001000000000000
      8001000000000000800100000000000080010000000000008001000000000000
      8001000000000000FFFF000000000000F81FFE7FFE7FC001E007FC7FFE3FC001
      C003F87FFE1F80018001F07FFE0FC0018001E0000007C0010000C0000003C001
      000080000001C001000000000000C001000000000000C001000080000001C001
      0000C0000003C0018001E0000007C0018001F07FFE0FC001C003F87FFE1FC003
      E007FC7FFE3FC007F81FFE7FFE7FC00F9FFF9FFFC001FDC70FFF0FFFC001F003
      07FF07FFC001C00183FF83FFC0010001C1FFC1FFC0010001E10FE10FC0010001
      F003F003C0010001F801F801C0018001F801F801C001C003F800F800C001E007
      F800F800C001F00FF800F800C001F03FF801F801C001F03FFC01FC01C003F03F
      FE03FE03C007E03FFF0FFF0FC00FE07F00000000000000000000000000000000
      000000000000}
  end
  object TimePopupMenu: TPopupMenu
    AutoHotkeys = maManual
    OnPopup = TimePopupMenuPopup
    Left = 476
    Top = 48
  end
  object frTrendReport: TfrReport
    InitialZoom = pzPageWidth
    ModifyPrepared = False
    PreviewButtons = [pbZoom, pbLoad, pbSave, pbPrint, pbFind, pbHelp, pbExit]
    ShowProgress = False
    Left = 272
    Top = 132
    ReportForm = {18000000}
  end
  object pmEntityButtonClick: TPopupMenu
    OnPopup = pmEntityButtonClickPopup
    Left = 192
    Top = 348
    object miPassport: TMenuItem
      Caption = #1055#1072#1089#1087#1086#1088#1090
      OnClick = miPassportClick
    end
    object miBase: TMenuItem
      Caption = #1042' '#1073#1072#1079#1091' '#1076#1072#1085#1085#1099#1093'...'
      OnClick = miBaseClick
    end
  end
end
