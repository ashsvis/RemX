object ShowLogsForm: TShowLogsForm
  Left = 276
  Top = 277
  Align = alClient
  BorderStyle = bsNone
  Caption = 'ShowLogsForm'
  ClientHeight = 419
  ClientWidth = 792
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object tcLogs: TTabControl
    Left = 0
    Top = 26
    Width = 792
    Height = 393
    Align = alClient
    TabOrder = 0
    Tabs.Strings = (
      #1040#1088#1093#1080#1074' '#1072#1074#1072#1088#1080#1081#1085#1099#1093' '#1089#1086#1086#1073#1097#1077#1085#1080#1081
      #1040#1088#1093#1080#1074' '#1087#1077#1088#1077#1082#1083#1102#1095#1077#1085#1080#1081
      #1040#1088#1093#1080#1074' '#1076#1077#1081#1089#1090#1074#1080#1081' '#1086#1087#1077#1088#1072#1090#1086#1088#1072
      #1040#1088#1093#1080#1074' '#1089#1080#1089#1090#1077#1084#1085#1099#1093' '#1089#1086#1086#1073#1097#1077#1085#1080#1081)
    TabIndex = 0
    OnChange = tcLogsChange
    OnChanging = tcLogsChanging
    object DrawGrid: TDrawGrid
      Left = 4
      Top = 25
      Width = 784
      Height = 364
      Align = alClient
      ColCount = 1
      DefaultRowHeight = 19
      FixedCols = 0
      RowCount = 2
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
      ParentFont = False
      TabOrder = 0
      OnDrawCell = DrawGridDrawCell
      OnMouseDown = DrawGridMouseDown
      OnMouseMove = DrawGridMouseMove
    end
  end
  object ToolBar: TToolBar
    Left = 0
    Top = 0
    Width = 792
    Height = 26
    AutoSize = True
    ButtonWidth = 109
    Caption = 'ToolBar'
    EdgeBorders = [ebTop, ebBottom]
    Flat = True
    Images = LogsImageList
    List = True
    ParentShowHint = False
    ShowCaptions = True
    ShowHint = True
    TabOrder = 1
    Wrapable = False
    object ToolButton7: TToolButton
      Left = 0
      Top = 0
      Action = actPrint
      AutoSize = True
    end
    object ToolButton12: TToolButton
      Left = 83
      Top = 0
      Action = actPreview
      AutoSize = True
    end
    object ToolButton8: TToolButton
      Left = 170
      Top = 0
      Width = 8
      Caption = 'ToolButton3'
      ImageIndex = 2
      Style = tbsSeparator
    end
    object tbLessTime: TToolButton
      Left = 178
      Top = 0
      Hint = #1050' '#1087#1088#1077#1076#1099#1076#1091#1097#1077#1084#1091' '#1087#1077#1088#1080#1086#1076#1091
      AutoSize = True
      ImageIndex = 7
      OnClick = tbLessTimeClick
    end
    object tbTimeSelect: TToolButton
      Left = 213
      Top = 0
      Hint = #1047#1072#1076#1072#1090#1100' '#1087#1077#1088#1080#1086#1076' '#1087#1088#1086#1089#1084#1086#1090#1088#1072
      AutoSize = True
      Caption = '20 '#1084#1080#1085#1091#1090
      DropdownMenu = TimePopupMenu
      ImageIndex = 9
    end
    object tbMoreTime: TToolButton
      Left = 296
      Top = 0
      Hint = #1050' '#1089#1083#1077#1076#1091#1102#1097#1077#1084#1091' '#1087#1077#1088#1080#1086#1076#1091
      AutoSize = True
      ImageIndex = 8
      OnClick = tbMoreTimeClick
    end
    object ScrollingPanel: TPanel
      Left = 331
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
    object tbFresh: TToolButton
      Left = 441
      Top = 0
      AutoSize = True
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      ImageIndex = 10
      OnClick = tbFreshClick
    end
    object btn1: TToolButton
      Left = 527
      Top = 0
      Width = 8
      Caption = 'btn1'
      ImageIndex = 11
      Style = tbsSeparator
    end
    object btnExportCSV: TToolButton
      Left = 535
      Top = 0
      Caption = #1069#1082#1089#1087#1086#1088#1090' '#1074' CSV'
      ImageIndex = 3
      OnClick = btnExportCSVClick
    end
  end
  object LogsActionList: TActionList
    Images = LogsImageList
    Left = 168
    Top = 74
    object actPrint: TAction
      Caption = '&'#1055#1077#1095#1072#1090#1100'...'
      Hint = #1055#1077#1095#1072#1090#1100' '#1078#1091#1088#1085#1072#1083#1072
      ImageIndex = 1
      ShortCut = 16464
      OnExecute = actPrintExecute
      OnUpdate = actPrintUpdate
    end
    object actPreview: TAction
      Caption = #1055'&'#1088#1086#1089#1084#1086#1090#1088
      Hint = #1055#1088#1077#1076#1074#1072#1088#1080#1090#1077#1083#1100#1085#1099#1081' '#1087#1088#1086#1089#1084#1086#1090#1088
      ImageIndex = 2
      ShortCut = 49232
      OnExecute = actPreviewExecute
      OnUpdate = actPreviewUpdate
    end
  end
  object FindDialog: TFindDialog
    OnClose = FindDialogClose
    Options = [frDown, frHideWholeWord]
    Left = 248
    Top = 74
  end
  object LogsImageList: TImageList
    Left = 290
    Top = 74
    Bitmap = {
      494C01010B000E00140010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000001094100039AD390000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008C8C8C00949494009494940094949400949494008C8C8C000000
      0000000000000000000000000000000000000000000000000000A5636B00A563
      6B00A5636B00A5636B00A5636B00A5636B00A5636B00A5636B00A5636B00A563
      6B00A5636B00A5636B00A5636B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000AD0000218C180039AD3900000000000000
      0000000000000000000000000000000000000000000000000000000000008C8C
      8C009C9C9C006B6B6B006B6B6B006B6B6B006B6B6B006B6B6B006B6B6B009C94
      94008C8C8C000000000000000000000000000000000000000000A5636B00FFEF
      C600C6CE9400D6CE9400EFCE9C00E7CE9400EFC68400EFBD8400EFBD7B00EFBD
      8400EFBD8400EFC68400A5636B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000009C0000219C18001884180039AD39000000
      00000000000000000000000000000000000000000000000000009C9C9C00B5B5
      B5006B6B6B00ADADAD00ADA59C00ADADA500A5A5AD00ADA59400A59C94006B6B
      6B00B5ADAD008C8C8C0000000000000000000000000000000000A5636B00FFEF
      CE009CBD7300299C21006BAD4A0021941000219410005AA53900CEB57300EFBD
      7B00EFBD7B00EFC68400A5636B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000009C0000088C000008840000088C100039AD
      390000000000000000000000000000000000000000008C8C8C00B5B5B5006B6B
      6B00ADA59C00D6D6BD00FFEFD600DECED600BDB5D600FFFFE700DEDED6009C94
      8C006B6B6B00B5ADAD008C8C8C00000000000000000000000000A5635A00FFEF
      DE00BDCE9C00108C08000084000000840000008400000084000029941800DEBD
      7B00EFBD7B00EFC68400A5636B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000AD00006BDE6B0052E7520042DE
      420018C6180000B5080000B50000088C0800008C00002194210063AD6300107B
      100039AD390000000000000000000000000000000000ADA5AD0084848400BDCE
      BD00DEDEC600FFF7DE00F7D6A500F7C69400F7BD8400F7CE9C00FFFFE700EFF7
      EF009C9484006B6B6B009C949400000000000000000000000000A5635A00FFF7
      E700BDCE9C00189410000084000018941000ADBD730073AD4A000084000073AD
      4A00EFBD8400EFC68400A5636B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000009C080063E7630018D6180008C6
      000000BD000000B5000000A50000008C0000008C080000840000218C180063AD
      6300187B180039AD390000000000000000008C8C8C0084848400BDCEBD00ADA5
      9C00EFF7EF00FFF7CE00FFFFD600FFF7CE00F7DEAD00F7C69400F7CE9C008484
      7B005A5A5200AD948C006B6B6B00A59C9C000000000000000000A5736B00FFF7
      EF00BDD6A500088C0800008400000084000084B55A00EFCEA500A5B56B006BAD
      4A00EFC68C00EFC68400A5636B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001094080063E7630000CE000000C6
      000000BD000000B5000000AD0000009C0000008C080000840000007B0000187B
      210063AD6300187B180039AD390000000000A59CA50084848400ADA59C00EFF7
      EF00EFF7EF00EFF7EF00FFFFDE00FFFFDE00FFFFD600FFEFBD0084847B005A5A
      5200FFF7DE00A59C8C006B6B6B00A59C9C000000000000000000A5736B00FFFF
      FF00E7E7D600A5CE94009CC6840094BD73009CBD7300EFD6AD00EFCEA5009CC6
      7B00EFC69400EFC68C00A5636B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000A5000063E76B0000CE000008C6
      000000BD000000B5000000AD000000940000008C08000084000000840000007B
      0000298C310063AD6300187B210039AD3900A59CA50084848400ADA59C00EFF7
      EF00EFF7EF00EFF7EF00FFFFDE00C6BDAD0084847B0084847B005A5A5200FFDE
      A500DECED6009C94A5006B6B6B00AD9C9C000000000000000000BD846B00FFFF
      FF00A5DEA500FFEFE700F7EFD6009CC6840094BD730094BD73009CBD7300EFCE
      A500EFCE9C00F7CE9400A5636B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000089C00006BE76B0000CE000008C6
      000000BD000000B5000000AD000000940800008C080000840000007B00000073
      0000398C310063AD63001873290039AD3900A59CA50084848400ADA59C00EFF7
      EF00EFF7EF00FFFFDE00FFFFDE00C6BDAD005252520042423900FFDEA500D6AD
      7B00C6BDCE008C8CA5006B6B6B00AD9C9C000000000000000000BD846B00FFFF
      FF0073C67300ADD6A500FFEFE70084C673000084000000840000088C0800EFD6
      AD00EFCEA500F7D6A500A5636B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000009C000063E7630000CE000008C6
      000000BD000000B5000000A50000009400000094000000840000087B08002984
      180063AD6300187B210039AD390000000000A59CA50084848400ADA59C00EFF7
      EF00EFF7EF00FFFFFF00FFFFF700FFFFDE00DEDEC600636B5A0084847B00FFDE
      A500FFF7CE00ADA594006B6B6B00A59C9C000000000000000000D6946B00FFFF
      FF0084CE8400008400007BC67300ADD6A5001894180000840000108C0800F7D6
      B500F7D6AD00EFCEA500A5636B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000009408006BEF630018D6180008C6
      000000BD000000B5000000AD080008940000008C000000840000108C180063AD
      6300107B180039AD390000000000000000008C8C8C0084848400ADA59C00EFF7
      EF00EFF7EF00EFF7EF00FFFFFF00FFFFF700FFFFEF00EFEFD6005A5A52008484
      7B00DEDEC600B59C9C006B6B6B00A59C9C000000000000000000D6946B00FFFF
      FF00F7F7EF0029A5290000840000008400000084000000840000108C0800FFEF
      CE00DECEB500B5AD9400A5636B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000AD00007BDE7B005AE75A0042DE
      420018C6180000B5080000AD000000940000009400001894210063AD6300107B
      100039AD390000000000000000000000000000000000A59CA50084848400ADA5
      9C00EFF7EF00EFF7EF00EFF7EF00EFF7EF00F7F7F700FFFFFF00EFEFD6005A5A
      5200ADA59C006B6B6B00A59C9C00000000000000000000000000DE9C7300FFFF
      FF00FFFFFF00DEF7DE0063BD6300219C2100219C210073BD6B00299C2100946B
      5200A56B5A00A56B5A00A5636B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000009C0000008C000008840000088C100039AD
      390000000000000000000000000000000000000000008C8C8C00B5ADB5008484
      8400ADA59C00EFF7EF00EFF7EF00EFF7EF00EFF7EF00EFEFE700EFEFE700BDB5
      AD006B6B6B00B5A5A5008C8C8C00000000000000000000000000DE9C7300FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00DEF7DE00DEF7DE00FFFFF700ADB594008C6B
      5200E79C5200E78C3100B56B4A00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000001094080018941800188C180039AD39000000
      000000000000000000000000000000000000000000000000000094949400ADAD
      AD0084848400ADA59C008CAD840094AD8C00ADBD9C00C6C6B500C6B5B5006B6B
      6B00B5A5A5009494940000000000000000000000000000000000E7AD7B00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00DEC6C600A56B
      5A00FFB55A00BD7B5A0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000009C00001894180039AD3900000000000000
      0000000000000000000000000000000000000000000000000000000000008C8C
      8C009C9C9C00848484006B6B6B006B6B6B006B6B6B006B6B6B006B6B6B009C9C
      9C008C8C8C000000000000000000000000000000000000000000E7AD7B00F7F7
      EF00F7F7EF00F7F7EF00F7F7EF00F7F7EF00F7F7EF00F7F7EF00DEC6C600A56B
      5A00BD846B000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000002194210039AD390000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008C8C8C008C8C8C0094949400949494008C8C8C008C8C8C000000
      0000000000000000000000000000000000000000000000000000E7AD7B00D694
      6B00D6946B00D6946B00D6946B00D6946B00D6946B00D6946B00D6946B00A56B
      5A00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000AD5A5A00AD52
      5200A54A4A00AD949400C6CEC600CECEC600CECEC600C6CEC600C6CEC600B59C
      9C009C4242009C424200A5525200000000000000000000000000000000000000
      000000000000000000000000000000000000A5636B00A5636B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001073100010731000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000039AD39001094100000000000000000000000
      00000000000000000000000000000000000000000000BD7B7300CE636300CE6B
      6B00B55A5A009C848400BDA5A500E7CECE00FFF7F700FFFFF700F7F7F700CEB5
      B500942929009C313100C65A5A00AD5A5A000000000000000000000000000000
      0000000000000000000000000000A5636B0084848400A5636B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000001084100039BD630010731000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000039AD3900218C180000AD000000000000000000000000
      00000000000000000000000000000000000000000000BD7B7300CE636300CE63
      6300B55A5A009C7B7B009C424200B5737300E7DEDE00FFF7F700FFFFFF00D6B5
      B500943131009C313100BD5A5A00AD5A5A000000000000000000000000000000
      00000000000000000000A5636B00CECED60084848400A5636B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000001084100052E77B0039BD630010731000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000039AD390018841800219C1800009C000000000000000000000000
      00000000000000000000000000000000000000000000BD7B7300CE636300CE63
      6300B55A5A00AD8484009C3939009C393900CEBDBD00EFEFEF00FFFFFF00E7C6
      C6009429290094313100BD5A5A00AD5A5A000000000000000000000000000000
      00000000000000000000A5636B00EFEFEF0084848400A5636B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000001084100084F7A50039BD630010731000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000039AD3900088C100008840000088C0000009C000000000000000000000000
      00000000000000000000000000000000000000000000BD7B7300CE636300CE63
      6300B55A5A00B58C8C009C4A4A0094313100A59C9C00D6D6D600FFFFFF00E7C6
      C6009429290094313100BD5A5A00AD5A5A000000000000000000000000000000
      00000000000000000000A5636B00EFEFEF0084848400A5636B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000001084100084F7A50039BD630010731000000000000000
      00000000000000000000000000000000000000000000000000000000000039AD
      3900107B100063AD630021942100008C0000088C080000B5000000B5080018C6
      180042DE420052E752006BDE6B0000AD000000000000BD7B7300CE636300CE63
      6300BD5A5A00C6948C00C6949400B5848400AD8C8C00BDA5A500E7C6C600DEAD
      AD00A5393900A5393900C65A5A00AD5A5A000000000000000000000000000000
      00000000000000000000A5736B00EFEFEF0084848400A5636B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000001084100084F7A50039BD630010731000000000000000
      000000000000000000000000000000000000000000000000000039AD3900187B
      180063AD6300218C180000840000008C0800008C000000A5000000B5000000BD
      000008C6000018D6180063E76300009C080000000000BD7B7300CE636300CE63
      6300CE636300CE636300CE636300CE636300CE636300C65A5A00C65A5A00CE63
      6300CE636300CE636300CE6B6B00AD525A000000000000000000000000000000
      00000000000000000000BD846B00EFEFEF0084848400A5636B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000001084100084F7A50039BD630010731000000000000000
      0000000000000000000000000000000000000000000039AD3900187B180063AD
      6300187B2100007B000000840000008C0800009C000000AD000000B5000000BD
      000000C6000000CE000063E763001094080000000000BD7B7300B5525200B55A
      5A00C6848400D6A5A500D6ADAD00D6ADA500D6ADAD00D6A5A500D6A5A500D6AD
      A500D6ADAD00D69C9C00CE636300AD5252000000000000000000000000000000
      00000000000000000000D6946B00EFEFEF0084848400A5636B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000001084100084F7A50039BD630010731000000000000000
      00000000000000000000000000000000000039AD3900187B210063AD6300298C
      3100007B00000084000000840000008C08000094000000AD000000B5000000BD
      000008C6000000CE000063E76B0000A5000000000000BD7B7300AD524A00E7CE
      CE00F7F7F700F7F7EF00F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7
      F700F7F7F700DEBDBD00C65A5A00AD525A000000000000000000000000000000
      000000000000BD7B5A00EFEFEF00CECED6008484840042424200A5636B000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000001084100084F7A50052E77B0039BD6300104A1000107310000000
      00000000000000000000000000000000000039AD39001873290063AD6300398C
      310000730000007B000000840000008C08000094080000AD000000B5000000BD
      000008C6000000CE00006BE76B00089C000000000000BD7B7300B5524A00EFD6
      D600FFF7F700F7EFEF00F7EFEF00F7EFEF00F7EFEF00F7EFEF00F7EFEF00F7EF
      EF00F7F7F700DEBDBD00C65A5A00AD525A000000000000000000000000000000
      0000BD7B5A00EFEFEF00CECED600BDBDBD008C8C8C005A5A5A0042424200A563
      6B00000000000000000000000000000000000000000000000000000000000000
      00001084100084F7A50052E77B0052E77B0039AD520010631000104A10001073
      1000000000000000000000000000000000000000000039AD3900187B210063AD
      630029841800087B080000840000009400000094000000A5000000B5000000BD
      000008C6000000CE000063E76300009C000000000000BD7B7300B5524A00EFD6
      D600EFEFEF00D6D6D600D6D6D600D6D6D600D6D6D600D6D6D600D6D6D600D6D6
      D600EFEFEF00DEBDBD00C65A5A00AD525A00000000000000000000000000BD7B
      5A00EFEFEF00EFEFEF00C6C6C600ADADAD008C8C8C00737373005A5A5A004242
      4200A5636B000000000000000000000000000000000000000000000000001084
      100084F7A5006BEF8C0063EF840052E77B0039BD5A001094100010631000104A
      100010731000000000000000000000000000000000000000000039AD3900107B
      180063AD6300108C180000840000008C00000894000000AD080000B5000000BD
      000008C6000018D618006BEF63000094080000000000BD7B7300B5524A00EFD6
      D600EFEFEF00DED6D600DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DED6
      D600EFEFEF00DEBDBD00C65A5A00AD525A000000000000000000BD7B5A00EFEF
      EF00EFEFEF00CECED600BDBDBD009C9C9C008484840084848400737373005A5A
      5A0042424200A5636B00000000000000000000000000000000001084100084F7
      A5006BEF940063EF8C0052E77B004AD6730039BD630039BD6300109410001063
      1000104A100010731000000000000000000000000000000000000000000039AD
      3900107B100063AD630018942100009400000094000000AD000000B5080018C6
      180042DE42005AE75A007BDE7B0000AD000000000000BD7B7300B5524A00EFD6
      D600F7F7EF00E7DEDE00E7DEDE00E7DEDE00E7DEDE00E7DEDE00E7DEDE00E7DE
      DE00EFEFEF00DEBDBD00C65A5A00AD525A0000000000BD7B5A00EFEFEF00EFEF
      EF00CECED600C6C6C600C6C6C600848484008484840084848400848484007373
      73005A5A5A0042424200A5636B0000000000000000001084100084F7A5006BEF
      940052DE73004AD6630042CE5A0031BD520039BD630039BD630039BD63001094
      100010631000104A100010731000000000000000000000000000000000000000
      000039AD3900088C100008840000008C0000009C000000000000000000000000
      00000000000000000000000000000000000000000000BD7B7300B5524A00EFD6
      D600EFEFEF00D6D6D600D6D6D600D6D6D600D6D6D600D6D6D600D6D6D600D6D6
      D600EFEFEF00DEBDBD00C65A5A00AD525A00D6946B00D6946B00D6946B00D694
      6B00D6946B00D6946B00D6946B00D6946B00D6946B00D6946B00D6946B00D694
      6B00D6946B00D6946B00D6946B00D6946B001084100010841000108410001084
      1000108410001084100010841000108410001084100010841000108410001084
      1000108410001084100010841000108410000000000000000000000000000000
      00000000000039AD3900188C1800189418001094080000000000000000000000
      00000000000000000000000000000000000000000000BD7B7300B5524A00E7D6
      CE00FFF7F700F7EFEF00F7EFEF00F7EFEF00F7EFEF00F7EFEF00F7EFEF00F7EF
      EF00FFF7F700DEBDBD00C65A5A00AD525A000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000039AD390018941800009C000000000000000000000000
      0000000000000000000000000000000000000000000000000000AD524A00CEB5
      B500D6D6D600CECECE00CECECE00CECECE00CECECE00CECECE00CECECE00CECE
      CE00D6D6D600CEADAD00A54A4A00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000039AD39002194210000000000000000000000
      000000000000000000000000000000000000000000004A637B00BD9494000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000009C9C9C00000000000000000000000000848484008484
      84008C8C8C000000000000000000000000000000000000000000A5636B00A563
      6B00A5636B00A5636B00A5636B00A5636B00A5636B00A5636B00A5636B00A563
      6B00A5636B00A5636B00A5636B00000000000000000000000000000000008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006B9CC600188CE7004A7BA500C694
      9400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00009C9C9C009C9C9C00D6CECE009494940039393900525252009C949400C6C6
      C600D6D6D60084848400000000000000000000000000000000004A526300FFEF
      C600F7D6B500EFD6AD00EFCE9C00EFCE9400EFC68C00EFBD8400EFBD7B00EFBD
      8400EFBD8400EFC68400A5636B00000000000000000000000000000000008484
      8400C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600000000004AB5FF0052B5FF00218CEF004A7B
      A500C69494000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000009C9C9C009C9C
      9C00F7F7F700FFFFFF00D6D6D6009C9C9C004242420021182100211821003131
      310063636300848484008C8C8C000000000000000000636B8400186BC600636B
      8400F7DEBD00EFD6AD00EFCEA500EFCE9C00EFC69400EFC68C00EFBD8400EFBD
      7B00EFBD7B00EFC68400A5636B00000000000000000000000000000000008484
      8400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C600000000000000000052B5FF0052B5FF001884
      E7004A7BA500C694940000000000000000000000000000000000000000000000
      000000000000000000000000000000000000948C8C009C9C9C00EFEFEF00FFFF
      FF00EFE7E700C6C6C6009C9C9C008C8C8C009494940084848400636363003939
      390018212100211821007373730000000000000000000000000031A5FF001073
      D6006B6B8400F7DEBD00EFD6B500EFCEA500EFCE9C00EFC69400EFC68C00EFBD
      8400EFBD7B00EFC68400A5636B00000000000000000000000000000000008484
      8400FFFFFF00C6C6C600C6C6C600C6C6C600C6C6C600FFFFFF00C6C6C600C6C6
      C600C6C6C600FFFFFF00C6C6C60000000000000000000000000052B5FF004AB5
      FF00188CE7004A7BA500BD949400000000000000000000000000000000000000
      0000000000000000000000000000000000009C9C9C00E7E7E700E7E7E700BDBD
      BD00A5A5A500B5ADAD00C6BDBD00A5A5A50094949400948C8C00949494009C94
      94008C8C8C006B6B6B0084848400000000000000000000000000A5635A0031A5
      FF001073D6005A638400F7DEBD00EFD6AD00EFCEA500EFCE9C00EFC69400EFC6
      8C00EFBD8400EFC68400A5636B00000000000000000000000000000000008484
      8400FFFFFF00FFFFFF00FFFFFF0000840000848484000084000084848400FFFF
      FF00C6C6C600FFFFFF00C6C6C6000000000000000000000000000000000052B5
      FF004AB5FF002184DE005A6B730000000000AD7B7300C6A59C00D6B5A500CEA5
      9C000000000000000000000000000000000094949400ADADAD00A5A5A500ADAD
      AD00C6C6C600D6D6D600EFEFEF00EFEFEF00DEDEDE00C6C6C600ADADAD009C9C
      9C00948C8C00949494008C8C8C00000000000000000000000000A5736B00FFF7
      EF0031A5FF00427BAD008C635A00AD7B730094635A00AD7B6B00CEA58400EFC6
      9400EFC68C00EFC68400A5636B00000000000084000084848400008400008484
      8400008400008484840000840000FFFFFF00008400008484840000840000FFFF
      FF00C6C6C600FFFFFF00C6C6C600000000000000000000000000000000000000
      000052BDFF00B5D6EF00A5948C00B59C8C00F7E7CE00FFFFD600FFFFD600FFFF
      D600E7DEBD00CEADA5000000000000000000948C8C00ADADAD00C6C6C600CECE
      CE00C6C6C600DEDEDE00CECECE00A5ADA500BDBDBD00CECECE00D6D6D600D6D6
      D600C6C6C600B5B5B50094949400000000000000000000000000A5736B00FFFF
      FF00F7EFE700AD8C8C00B58C8400DEBDA500EFD6B500D6B59C00B58C7300CEA5
      8400EFC69400EFC68C00A5636B00000000008484840000840000848484000084
      00008484840000840000FFFFFF00008400008484840000840000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C600000000000000000000000000000000000000
      000000000000CEB5B500D6B5A500FFEFC600FFFFD600FFFFD600FFFFD600FFFF
      DE00FFFFEF00F7F7EF00B58C8C0000000000000000009C9C9C00CECECE00CECE
      CE00DEDEDE00C6C6C600B5B5B500A5D6A500BDC6BD00C6A5A500ADA5A500A5A5
      A500B5B5B500C6BDBD00A5A5A500000000000000000000000000BD846B00FFFF
      FF00FFF7EF00AD847B00DEC6B500F7E7CE00F7E7C600FFFFF700D6B59C00AD7B
      6B00EFCE9C00EFCE9400A5636B00000000000084000084848400008400008484
      840000840000FFFFFF0000840000848484000084000084848400C6C6C600C6C6
      C600C6C6C600FFFFFF00C6C6C600000000000000000000000000000000000000
      000000000000C6948C00F7DEB500F7D6A500FFF7CE00FFFFD600FFFFDE00FFFF
      EF00FFFFF700FFFFFF00DED6BD000000000000000000000000009C9C9C00BDBD
      BD00ADADAD00ADADAD00E7E7E700F7EFEF00EFEFEF00EFE7DE00D6D6D600CECE
      CE00B5B5B5009494940000000000000000000000000000000000BD846B00FFFF
      FF00FFFFFF0094636300F7EFDE00F7EFDE00F7E7CE00FFFFEF00EFD6B5009463
      5A00EFCEA500F7D6A500A5636B00000000000000000000840000848484000084
      0000FFFFFF000084000084848400008400008484840000840000FFFFFF00FFFF
      FF00C6C6C600FFFFFF00C6C6C600000000000000000000000000000000000000
      000000000000DEBDA500FFE7AD00F7CE9400FFF7CE00FFFFDE00FFFFE700FFFF
      F700FFFFF700FFFFEF00F7EFD600C69C94000000000000000000000000009C9C
      9C00D6D6D600CECECE009C9C9C00BDBDBD00D6D6D600D6D6D600D6D6D600C6C6
      C600ADADAD000000000000000000000000000000000000000000D6946B00FFFF
      FF00FFFFFF00B58C8400DEC6C600F7EFE700F7EFDE00FFFFD600DEBDA500AD7B
      7300F7D6AD00EFCEA500A5636B0000000000000000000000000000840000FFFF
      FF0000840000848484000084000084848400C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600FFFFFF00C6C6C600000000000000000000000000000000000000
      000000000000E7C6AD00FFDEAD00EFBD8400F7E7B500FFFFD600FFFFDE00FFFF
      E700FFFFE700FFFFDE00F7F7D600C6AD9C000000000000000000000000000000
      0000FFE7E700FFDECE00E7C6BD00E7C6BD00E7CEC600DED6CE00CECECE009494
      9400000000000000000000000000000000000000000000000000D6946B00FFFF
      FF00FFFFFF00D6BDBD00BD949400DEC6C600F7EFDE00DEC6B500B58C8400B58C
      7B00DECEB500B5AD9400A5636B00000000000000000000840000FFFFFF000084
      00008484840000840000848484000084000084848400C6C6C600FFFFFF00FFFF
      FF00C6C6C600FFFFFF00C6C6C600000000000000000000000000000000000000
      000000000000DEBDAD00FFE7B500EFBD8400F7CE9400FFEFC600FFFFDE00FFFF
      DE00FFFFDE00FFFFDE00F7EFD600C6A59C000000000000000000000000000000
      0000CE9C9C00FFDECE00FFCEBD00FFC6AD00FFBDA500FFAD9C00000000000000
      0000000000000000000000000000000000000000000000000000DE9C7300FFFF
      FF00FFFFFF00FFFFFF00D6BDBD00B58C840094636300AD847B00CEA59C00A56B
      5A00A56B5A00A56B5A00A5636B000000000000840000FFFFFF00008400008484
      8400008400008484840000840000848484000084000084848400C6C6C600C6C6
      C600C6C6C600FFFFFF00C6C6C600000000000000000000000000000000000000
      000000000000C69C9400FFEFC600FFEFC600F7D6A500F7CE9C00F7E7B500FFF7
      CE00FFF7D600FFFFD600E7DEBD00000000000000000000000000000000000000
      0000CE9C9C00FFDECE00FFCEBD00FFC6AD00FFBDA500F7AD9400000000000000
      0000000000000000000000000000000000000000000000000000DE9C7300FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFF700FFFFF700D6BDBD00A56B
      5A00E79C5200E78C3100B56B4A00000000008484840000840000848484000084
      000084848400FFFFFF0084848400008400008484840000840000FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000DEC6AD00FFFFFF00FFF7EF00F7CE9400EFBD8400F7CE
      9C00FFE7B500FFF7C600BD9C8C00000000000000000000000000000000000000
      0000CE9C9C00FFDECE00FFCEBD00FFC6AD00FFBDA500F7AD9C00000000000000
      0000000000000000000000000000000000000000000000000000E7AD7B00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00DEC6C600A56B
      5A00FFB55A00BD7B5A0000000000000000000084000084848400008400008484
      8400FFFFFF00FFFFFF00FFFFFF00848484000084000084848400FFFFFF00FFFF
      FF0084848400FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000D6BDBD00F7EFD600FFEFC600FFE7AD00FFE7
      B500F7DEB500CEAD9C000000000000000000000000000000000000000000CE9C
      9C00FFE7D600FFDECE00FFCEBD00FFC6AD00FFBDA500F7AD9C00000000000000
      0000000000000000000000000000000000000000000000000000E7AD7B00F7F7
      EF00F7F7EF00F7F7EF00F7F7EF00F7F7EF00F7F7EF00F7F7EF00D6BDBD00A56B
      5A00BD846B000000000000000000000000000000000000000000000000008484
      8400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00848484000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CEAD9400CEAD9C00DEBDA500DEBD
      A50000000000000000000000000000000000000000000000000000000000CE9C
      9C00CE9C9C00CE9C9C00CE9C9C00F7AD9C00F7AD9C0000000000000000000000
      0000000000000000000000000000000000000000000000000000E7AD7B00D694
      6B00D6946B00D6946B00D6946B00D6946B00D6946B00D6946B00D6946B00A56B
      5A00000000000000000000000000000000000000000000000000000000008484
      8400848484008484840084848400848484008484840084848400848484008484
      840084848400000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF00FE7FF81FC0010000FE3FE007C0010000
      FE1FC003C0010000FE0F8001C001000000078001C001000000030000C0010000
      00010000C001000000000000C001000000000000C001000000010000C0010000
      00030000C001000000078001C0010000FE0F8001C0010000FE1FC003C0030000
      FE3FE007C0070000FE7FF81FC00F0000C001FF3FFF3FFE7F8000FE3FFE3FFC7F
      8000FC3FFC3FF87F8000FC3FFC3FF07F8000FC3FFC3FE0008000FC3FFC3FC000
      8000FC3FFC3F80008000FC3FFC3F00008000F81FF81F00008000F00FF00F8000
      8000E007E007C0008000C003C003E000800080018001F07F800000000000F87F
      8000FFFFFFFFFC7FC001FFFFFFFFFE7F9FFFFDC7C001E0000FFFF003C001E000
      07FFC0018001E00083FF0001C001E000C1FF0001C001E000E10F0001C0010000
      F0030001C0010000F8018001C0010000F801C003C0018000F800E007C001C000
      F800F00FC0018000F800F03FC0010000F801F03FC0010000FC01F03FC0030001
      FE03E03FC007E003FF0FE07FC00FE00700000000000000000000000000000000
      000000000000}
  end
  object TimePopupMenu: TPopupMenu
    AutoHotkeys = maManual
    OnPopup = TimePopupMenuPopup
    Left = 388
    Top = 76
  end
  object frLogReport: TfrReport
    Dataset = frUserLogDataset
    InitialZoom = pzPageWidth
    ModifyPrepared = False
    PreviewButtons = [pbZoom, pbLoad, pbSave, pbPrint, pbFind, pbHelp, pbExit]
    ShowProgress = False
    OnBeginPage = frLogReportBeginPage
    OnGetValue = frLogReportGetValue
    Left = 432
    Top = 74
    ReportForm = {18000000}
  end
  object frUserLogDataset: TfrUserDataset
    RangeEnd = reCount
    Left = 472
    Top = 74
  end
  object ApplicationEvents: TApplicationEvents
    OnIdle = ApplicationEventsIdle
    Left = 208
    Top = 74
  end
end
