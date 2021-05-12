object ShowTuningForm: TShowTuningForm
  Left = 295
  Top = 127
  BorderStyle = bsDialog
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072
  ClientHeight = 429
  ClientWidth = 436
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Label31: TLabel
    Left = 8
    Top = 51
    Width = 115
    Height = 14
    Caption = #1058#1072#1073#1083#1080#1094#1099' ('#1080#1089#1090#1086#1088#1080#1103'):'
  end
  object ButtonsPanel: TPanel
    Left = 0
    Top = 392
    Width = 436
    Height = 37
    Align = alBottom
    BevelInner = bvRaised
    BevelOuter = bvNone
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object btnClose: TButton
      Left = 216
      Top = 6
      Width = 89
      Height = 25
      Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 328
      Top = 6
      Width = 89
      Height = 25
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
  end
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 436
    Height = 392
    ActivePage = tsGeneral
    Align = alClient
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    MultiLine = True
    ParentFont = False
    TabOrder = 1
    object tsGeneral: TTabSheet
      Caption = #1054#1073#1097#1080#1077
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      DesignSize = (
        428
        325)
      object Label1: TLabel
        Left = 8
        Top = 8
        Width = 145
        Height = 21
        AutoSize = False
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1086#1073#1098#1077#1082#1090#1072
        Layout = tlCenter
      end
      object Label2: TLabel
        Left = 8
        Top = 32
        Width = 145
        Height = 21
        AutoSize = False
        Caption = #1053#1086#1084#1077#1088' '#1089#1090#1072#1085#1094#1080#1080
        Layout = tlCenter
      end
      object Label3: TLabel
        Left = 8
        Top = 56
        Width = 145
        Height = 21
        AutoSize = False
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1089#1090#1072#1085#1094#1080#1080
        Layout = tlCenter
      end
      object Label4: TLabel
        Left = 8
        Top = 80
        Width = 145
        Height = 21
        AutoSize = False
        Caption = #1044#1072#1090#1072' '#1080' '#1074#1088#1077#1084#1103' RemX'
        Layout = tlCenter
      end
      object Label6: TLabel
        Left = 8
        Top = 104
        Width = 145
        Height = 21
        AutoSize = False
        Caption = #1050#1086#1088#1085#1077#1074#1072#1103' '#1084#1085#1077#1084#1086#1089#1093#1077#1084#1072
        Layout = tlCenter
      end
      object Label8: TLabel
        Left = 8
        Top = 128
        Width = 137
        Height = 21
        AutoSize = False
        Caption = #1056#1072#1079#1084#1077#1088' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1103' *'
        Layout = tlCenter
      end
      object Label9: TLabel
        Left = 8
        Top = 176
        Width = 113
        Height = 21
        AutoSize = False
        Caption = #1047#1074#1091#1082' '#1089#1090#1072#1085#1094#1080#1080
        Layout = tlCenter
      end
      object Label10: TLabel
        Left = 8
        Top = 200
        Width = 121
        Height = 21
        AutoSize = False
        Caption = #1062#1074#1077#1090' '#1087#1077#1095#1072#1090#1080
        Layout = tlCenter
      end
      object Label11: TLabel
        Left = 8
        Top = 224
        Width = 145
        Height = 21
        AutoSize = False
        Caption = #1054#1073#1086#1083#1086#1095#1082#1072' '#1089#1080#1089#1090#1077#1084#1099' *'
        Layout = tlCenter
      end
      object Label52: TLabel
        Left = 259
        Top = 307
        Width = 160
        Height = 13
        Anchors = [akRight, akBottom]
        Caption = '* - '#1090#1088#1077#1073#1091#1077#1090#1089#1103' '#1087#1077#1088#1077#1079#1072#1087#1091#1089#1082' RemX'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label5: TLabel
        Left = 8
        Top = 152
        Width = 153
        Height = 21
        AutoSize = False
        Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1084#1086#1085#1080#1090#1086#1088#1086#1074' *'
        Layout = tlCenter
      end
      object Label28: TLabel
        Left = 8
        Top = 243
        Width = 145
        Height = 21
        AutoSize = False
        Caption = #1060#1080#1083#1100#1090#1088' '#1076#1080#1089#1082#1088'. '#1086#1096#1080#1073#1086#1082
        Layout = tlCenter
      end
      object lbl3: TLabel
        Left = 8
        Top = 263
        Width = 145
        Height = 21
        AutoSize = False
        Caption = #1047#1072#1087#1088#1077#1090' '#1082#1074#1080#1090#1080#1088#1086#1074#1072#1085#1080#1103
        Layout = tlCenter
      end
      object lbl8: TLabel
        Left = 8
        Top = 283
        Width = 153
        Height = 30
        AutoSize = False
        Caption = #1053#1077' '#1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' NoLink '#1074' '#1072#1074#1072#1088#1080#1081#1085#1086#1084' '#1078#1091#1088#1085#1072#1083#1077
        Layout = tlCenter
        WordWrap = True
      end
      object edObjectName: TEdit
        Left = 168
        Top = 8
        Width = 249
        Height = 22
        TabOrder = 0
      end
      object edStationName: TEdit
        Left = 168
        Top = 56
        Width = 249
        Height = 22
        TabOrder = 2
      end
      object cbStationNumber: TComboBox
        Left = 168
        Top = 32
        Width = 113
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        ItemIndex = 0
        TabOrder = 1
        Text = '1'
        Items.Strings = (
          '1'
          '2'
          '3'
          '4'
          '5'
          '6'
          '7'
          '8')
      end
      object dtpDate: TDateTimePicker
        Left = 168
        Top = 80
        Width = 113
        Height = 22
        Date = 38481.659782986110000000
        Time = 38481.659782986110000000
        TabOrder = 3
        OnChange = dtpDateChange
      end
      object dtpTime: TDateTimePicker
        Left = 288
        Top = 80
        Width = 97
        Height = 22
        Date = 38481.660303275460000000
        Time = 38481.660303275460000000
        Kind = dtkTime
        TabOrder = 4
        OnChange = dtpDateChange
      end
      object cbSchemeSize: TComboBox
        Left = 168
        Top = 128
        Width = 193
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        ItemIndex = 0
        TabOrder = 6
        Text = 'XGA (1024 x 768)'
        Items.Strings = (
          'XGA (1024 x 768)'
          'XGA+ (1152 x 864)'
          'WXGA (1280 x 720)'
          'WXGA (1280 x 768)'
          'WXGA (1280 x 800)'
          'WXGA (1280 x 960)'
          'SXGA (1280 x 1024)'
          'SXGA (1360 x 768)'
          'SXGA+ (1400 x 1050)'
          'WXGA+ (1440 x 900)'
          'XJXGA (1540 x 940)'
          'WXGA++ (1600 x 900)'
          'WSXGA (1600 x 1024)'
          'WSXGA+ (1680 x 1050)'
          'UXGA (1600 x 1200)'
          'Full HD (1920 x 1080)'
          'WUXGA (1920 x 1200)'
          'QXGA (2048 x 1536)'
          'QWXGA (2048 x 1152)'
          'WQXGA (2560 x 1440)'
          'WQXGA (2560 x 1600)'
          'QSXGA (2560 x 2048)')
      end
      object cbAlarmSound: TComboBox
        Left = 168
        Top = 176
        Width = 193
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        ItemIndex = 0
        TabOrder = 8
        Text = #1054#1090#1082#1083#1102#1095#1077#1085
        Items.Strings = (
          #1054#1090#1082#1083#1102#1095#1077#1085
          #1044#1080#1085#1072#1084#1080#1082
          #1047#1074#1091#1082#1086#1074#1072#1103' '#1082#1072#1088#1090#1072)
      end
      object cbPrintColor: TComboBox
        Left = 168
        Top = 200
        Width = 193
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        ItemIndex = 0
        TabOrder = 9
        Text = #1057#1077#1088#1072#1103' '#1096#1082#1072#1083#1072
        Items.Strings = (
          #1057#1077#1088#1072#1103' '#1096#1082#1072#1083#1072
          #1062#1074#1077#1090#1085#1072#1103' '#1096#1082#1072#1083#1072)
      end
      object cbSystemShell: TCheckBox
        Left = 168
        Top = 226
        Width = 89
        Height = 17
        Caption = #1042#1099#1082#1083#1102#1095#1077#1085#1072
        TabOrder = 10
        OnClick = cbSystemShellClick
      end
      object cbRootScheme: TComboBox
        Left = 168
        Top = 104
        Width = 249
        Height = 22
        ItemHeight = 14
        TabOrder = 5
        Text = 'MAIN.SCM'
        OnDropDown = cbRootSchemeDropDown
      end
      object cbMonitors: TComboBox
        Left = 168
        Top = 152
        Width = 113
        Height = 22
        Style = csDropDownList
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ItemHeight = 14
        ItemIndex = 0
        ParentFont = False
        TabOrder = 7
        Text = '1'
        Items.Strings = (
          '1'
          '2'
          '3'
          '4')
      end
      object cbDigErrFilter: TCheckBox
        Left = 168
        Top = 245
        Width = 89
        Height = 17
        Caption = #1042#1099#1082#1083#1102#1095#1077#1085
        TabOrder = 11
        OnClick = cbDigErrFilterClick
      end
      object cbNoAsk: TCheckBox
        Left = 168
        Top = 265
        Width = 89
        Height = 17
        Caption = #1042#1099#1082#1083#1102#1095#1077#1085
        TabOrder = 12
        OnClick = cbNoAskClick
      end
      object cbNoAddNoLinkInAciveLog: TCheckBox
        Left = 168
        Top = 285
        Width = 89
        Height = 17
        Caption = #1042#1099#1082#1083#1102#1095#1077#1085
        TabOrder = 13
        OnClick = cbNoAddNoLinkInAciveLogClick
      end
    end
    object tsSerialLink: TTabSheet
      Caption = #1057#1077#1090#1080' '#1082#1086#1085#1090#1088#1086#1083#1083#1077#1088#1086#1074
      ImageIndex = 1
      object tcLink: TTabControl
        Left = 0
        Top = 0
        Width = 428
        Height = 325
        Align = alClient
        MultiLine = True
        TabOrder = 0
        Tabs.Strings = (
          #1050#1072#1085#1072#1083' 1'
          #1050#1072#1085#1072#1083' 2'
          #1050#1072#1085#1072#1083' 3'
          #1050#1072#1085#1072#1083' 4'
          #1050#1072#1085#1072#1083' 5'
          #1050#1072#1085#1072#1083' 6'
          #1050#1072#1085#1072#1083' 7'
          #1050#1072#1085#1072#1083' 8'
          #1050#1072#1085#1072#1083' 9'
          #1050#1072#1085#1072#1083' 10'
          #1050#1072#1085#1072#1083' 11'
          #1050#1072#1085#1072#1083' 12'
          #1050#1072#1085#1072#1083' 13'
          #1050#1072#1085#1072#1083' 14'
          #1050#1072#1085#1072#1083' 15'
          #1050#1072#1085#1072#1083' 16')
        TabIndex = 0
        OnChange = tcLinkChange
        OnChanging = tcLinkChanging
        object pcTransportProtocol: TPageControl
          Left = 16
          Top = 72
          Width = 393
          Height = 257
          ActivePage = TabSheet1
          MultiLine = True
          TabOrder = 0
          object TabSheet1: TTabSheet
            Caption = #1057#1074#1103#1079#1100' '#1087#1086' COM '#1087#1086#1088#1090#1072#1084
            object Label15: TLabel
              Left = 8
              Top = 0
              Width = 209
              Height = 21
              AutoSize = False
              Caption = #1055#1086#1088#1090' '#1089#1074#1103#1079#1080
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              Layout = tlCenter
            end
            object Label17: TLabel
              Left = 8
              Top = 24
              Width = 209
              Height = 21
              AutoSize = False
              Caption = #1057#1082#1086#1088#1086#1089#1090#1100' '#1086#1073#1084#1077#1085#1072' ('#1073#1080#1090'/'#1089#1077#1082')'
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              Layout = tlCenter
            end
            object Label18: TLabel
              Left = 8
              Top = 48
              Width = 209
              Height = 21
              AutoSize = False
              Caption = #1055#1072#1088#1080#1090#1077#1090
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              Layout = tlCenter
            end
            object Label19: TLabel
              Left = 8
              Top = 72
              Width = 209
              Height = 21
              AutoSize = False
              Caption = #1044#1083#1080#1085#1072' '#1073#1072#1081#1090#1072' '#1076#1072#1085#1085#1099#1093' ('#1073#1080#1090')'
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              Layout = tlCenter
            end
            object Label20: TLabel
              Left = 8
              Top = 96
              Width = 209
              Height = 21
              AutoSize = False
              Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1089#1090#1086#1087#1086#1074#1099#1093' '#1073#1080#1090
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              Layout = tlCenter
            end
            object cbPort: TComboBox
              Left = 224
              Top = 0
              Width = 145
              Height = 22
              Style = csDropDownList
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ItemHeight = 14
              ItemIndex = 0
              ParentFont = False
              TabOrder = 0
              Text = #1086#1090#1082#1083#1102#1095#1077#1085
              Items.Strings = (
                #1086#1090#1082#1083#1102#1095#1077#1085)
            end
            object cbBaudrate: TComboBox
              Left = 224
              Top = 24
              Width = 145
              Height = 22
              Style = csDropDownList
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ItemHeight = 14
              ItemIndex = 8
              ParentFont = False
              TabOrder = 1
              Text = '19200'
              Items.Strings = (
                '110'
                '300'
                '600'
                '1200'
                '2400'
                '4800'
                '9600'
                '14400'
                '19200'
                '38400'
                '56000'
                '57600'
                '115200')
            end
            object cbParity: TComboBox
              Left = 224
              Top = 48
              Width = 145
              Height = 22
              Style = csDropDownList
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ItemHeight = 14
              ItemIndex = 0
              ParentFont = False
              TabOrder = 2
              Text = #1053#1077#1090' '#1082#1086#1085#1090#1088#1086#1083#1103
              Items.Strings = (
                #1053#1077#1090' '#1082#1086#1085#1090#1088#1086#1083#1103
                #1053#1077#1095#1077#1090' (ODD)'
                #1063#1077#1090' (EVEN)'
                #1042#1089#1077#1075#1076#1072' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085
                #1042#1089#1077#1075#1076#1072' '#1089#1073#1088#1086#1096#1077#1085)
            end
            object cbDataSize: TComboBox
              Left = 224
              Top = 72
              Width = 145
              Height = 22
              Style = csDropDownList
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ItemHeight = 14
              ItemIndex = 3
              ParentFont = False
              TabOrder = 3
              Text = '8'
              Items.Strings = (
                '5'
                '6'
                '7'
                '8')
            end
            object cbStops: TComboBox
              Left = 224
              Top = 96
              Width = 145
              Height = 22
              Style = csDropDownList
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ItemHeight = 14
              ItemIndex = 0
              ParentFont = False
              TabOrder = 4
              Text = '1'
              Items.Strings = (
                '1'
                '1.5'
                '2')
            end
          end
          object TabSheet2: TTabSheet
            Caption = #1057#1074#1103#1079#1100' '#1087#1086' Ethernet'
            ImageIndex = 1
            object Label27: TLabel
              Left = 7
              Top = 8
              Width = 209
              Height = 21
              AutoSize = False
              Caption = 'IP '#1072#1076#1088#1077#1089' '#1086#1089#1085#1086#1074#1085#1086#1075#1086' '#1082#1086#1085#1090#1088#1086#1083#1083#1077#1088#1072
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              Layout = tlCenter
            end
            object Label29: TLabel
              Left = 7
              Top = 32
              Width = 209
              Height = 21
              AutoSize = False
              Caption = #1055#1086#1088#1090' '#1086#1089#1085#1086#1074#1085#1086#1075#1086' '#1082#1086#1085#1090#1088#1086#1083#1083#1077#1088#1072
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              Layout = tlCenter
            end
            object edPrimaryAddr: TEdit
              Left = 224
              Top = 8
              Width = 145
              Height = 22
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
            end
            object edPrimaryPort: TEdit
              Left = 224
              Top = 32
              Width = 57
              Height = 22
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
            end
          end
        end
        object Panel1: TPanel
          Left = 22
          Top = 217
          Width = 377
          Height = 104
          BevelOuter = bvNone
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          object Label12: TLabel
            Left = 7
            Top = 0
            Width = 209
            Height = 21
            AutoSize = False
            Caption = #1042#1088#1077#1084#1103' '#1086#1078#1080#1076#1072#1085#1080#1103' '#1086#1090#1074#1077#1090#1072' ('#1084#1089#1077#1082')'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            Layout = tlCenter
          end
          object Label7: TLabel
            Left = 7
            Top = 74
            Width = 185
            Height = 21
            AutoSize = False
            Caption = #1055#1088#1086#1090#1086#1082#1086#1083' '#1086#1073#1084#1077#1085#1072' '#1074' '#1092#1072#1081#1083
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            Layout = tlCenter
          end
          object Label14: TLabel
            Left = 7
            Top = 26
            Width = 169
            Height = 21
            AutoSize = False
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1087#1086#1087#1099#1090#1086#1082' '#1089#1074#1103#1079#1080
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            Layout = tlCenter
          end
          object Label26: TLabel
            Left = 7
            Top = 50
            Width = 169
            Height = 21
            AutoSize = False
            Caption = #1058#1080#1087' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1074#1103#1079#1080
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            Layout = tlCenter
          end
          object cbSaveToLog: TCheckBox
            Left = 222
            Top = 78
            Width = 89
            Height = 17
            Caption = #1042#1099#1082#1083#1102#1095#1077#1085
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            OnClick = cbSaveToLogClick
          end
          object cbRepeatCount: TComboBox
            Left = 222
            Top = 25
            Width = 145
            Height = 22
            Style = csDropDownList
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ItemHeight = 14
            ItemIndex = 0
            ParentFont = False
            TabOrder = 1
            Text = '1'
            Items.Strings = (
              '1'
              '2'
              '3'
              '4'
              '5'
              '6'
              '7'
              '8'
              '9'
              '10')
          end
          object edtTimeOut: TEdit
            Left = 222
            Top = 0
            Width = 128
            Height = 22
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            Text = '800'
          end
          object udTimeout: TUpDown
            Left = 350
            Top = 0
            Width = 16
            Height = 22
            Associate = edtTimeOut
            Min = 300
            Max = 5000
            Position = 800
            TabOrder = 3
            Thousands = False
          end
          object cbLinkType: TComboBox
            Left = 222
            Top = 49
            Width = 145
            Height = 22
            Style = csDropDownList
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            ItemHeight = 14
            ItemIndex = 0
            ParentFont = False
            TabOrder = 4
            Text = #1052#1040#1043#1048#1057#1058#1056
            Items.Strings = (
              #1052#1040#1043#1048#1057#1058#1056
              'ModBus RTU'
              #1052#1045#1058#1040#1050#1054#1053
              'TM5103')
          end
        end
      end
    end
    object tsNetLink: TTabSheet
      Caption = #1057#1077#1090#1100' RemX'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ImageIndex = 4
      ParentFont = False
      object Label16: TLabel
        Left = 32
        Top = 16
        Width = 209
        Height = 21
        AutoSize = False
        Caption = #1056#1086#1083#1100' '#1101#1090#1086#1081' '#1088#1072#1073#1086#1095#1077#1081' '#1089#1090#1072#1085#1094#1080#1080' '#1074' '#1089#1077#1090#1080
        Layout = tlCenter
      end
      object lbSaveToLogForNet: TLabel
        Left = 24
        Top = 136
        Width = 153
        Height = 21
        AutoSize = False
        Caption = #1055#1088#1086#1090#1086#1082#1086#1083' '#1086#1073#1084#1077#1085#1072' '#1074' '#1092#1072#1081#1083
        Enabled = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
      end
      object cbNetRole: TComboBox
        Left = 248
        Top = 16
        Width = 137
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        ItemIndex = 0
        TabOrder = 0
        Text = #1053#1077#1079#1072#1074#1080#1089#1080#1084#1072#1103
        OnChange = cbNetRoleChange
        Items.Strings = (
          #1053#1077#1079#1072#1074#1080#1089#1080#1084#1072#1103
          #1057#1077#1088#1074#1077#1088
          #1050#1083#1080#1077#1085#1090)
      end
      object gbNetClient: TGroupBox
        Left = 16
        Top = 48
        Width = 393
        Height = 81
        Caption = ' '#1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1074#1077#1076#1091#1097#1077#1081' '#1088#1072#1073#1086#1095#1077#1081' '#1089#1090#1072#1085#1094#1080#1080' ('#1089#1077#1088#1074#1077#1088#1072')'
        TabOrder = 1
        object leServerAddress: TLabeledEdit
          Left = 16
          Top = 40
          Width = 113
          Height = 22
          EditLabel.Width = 52
          EditLabel.Height = 14
          EditLabel.Caption = 'IP '#1072#1076#1088#1077#1089':'
          Enabled = False
          TabOrder = 0
          Text = '127.0.0.1'
        end
        object leServerPort: TLabeledEdit
          Left = 152
          Top = 40
          Width = 57
          Height = 22
          EditLabel.Width = 32
          EditLabel.Height = 14
          EditLabel.Caption = #1055#1086#1088#1090':'
          Enabled = False
          TabOrder = 1
          Text = '80'
        end
      end
      object cbSaveToLogForNet: TCheckBox
        Left = 184
        Top = 138
        Width = 89
        Height = 17
        Caption = #1042#1099#1082#1083#1102#1095#1077#1085
        Enabled = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = cbSaveToLogClick
      end
      object grp1: TGroupBox
        Left = 16
        Top = 168
        Width = 393
        Height = 89
        Caption = #1069#1082#1089#1087#1086#1088#1090' '#1084#1080#1085#1091#1090#1085#1099#1093' '#1090#1072#1073#1083#1080#1094
        TabOrder = 3
        object chkExportActive: TCheckBox
          Left = 8
          Top = 16
          Width = 81
          Height = 17
          Caption = #1042#1082#1083#1102#1095#1080#1090#1100
          TabOrder = 0
          OnClick = chkExportActiveClick
        end
        object lbledtConnectionString: TLabeledEdit
          Left = 8
          Top = 56
          Width = 377
          Height = 22
          EditLabel.Width = 125
          EditLabel.Height = 14
          EditLabel.Caption = #1057#1090#1088#1086#1082#1072' '#1087#1086#1076#1082#1083#1102#1095#1077#1085#1080#1103':'
          Enabled = False
          TabOrder = 1
        end
      end
    end
    object tsOtherPrograms: TTabSheet
      Caption = #1055#1086#1076#1082#1083#1102#1095#1072#1077#1084#1099#1077' '#1084#1086#1076#1091#1083#1080
      ImageIndex = 5
      DesignSize = (
        428
        325)
      object tvExternalModules: TTreeView
        Left = 8
        Top = 40
        Width = 412
        Height = 276
        Anchors = [akLeft, akTop, akRight, akBottom]
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        HideSelection = False
        Indent = 19
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
      end
      object btAddExtProc: TButton
        Left = 8
        Top = 6
        Width = 81
        Height = 25
        Caption = #1055#1086#1076#1082#1083#1102#1095#1080#1090#1100
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = btAddExtProcClick
      end
      object btChangeExtProc: TButton
        Left = 93
        Top = 6
        Width = 81
        Height = 25
        Action = actChangeExtProc
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
      object btDeleteExtProc: TButton
        Left = 178
        Top = 6
        Width = 81
        Height = 25
        Action = actDeleteExtProc
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
    end
    object tsSupport: TTabSheet
      Caption = #1055#1086#1076#1076#1077#1088#1078#1082#1072
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ImageIndex = 6
      ParentFont = False
      DesignSize = (
        428
        325)
      object Label51: TLabel
        Left = 8
        Top = 8
        Width = 214
        Height = 14
        Caption = #1055#1086#1076#1076#1077#1088#1078#1080#1074#1072#1077#1084#1099#1077' '#1084#1086#1076#1077#1083#1080' '#1091#1089#1090#1088#1086#1081#1089#1090#1074':'
      end
      object clbSupport: TListBox
        Left = 8
        Top = 32
        Width = 412
        Height = 284
        Anchors = [akLeft, akTop, akRight, akBottom]
        ItemHeight = 14
        Items.Strings = (
          #1050#1086#1085#1090#1088#1086#1083#1083#1077#1088' "'#1056#1077#1084#1080#1082#1086#1085#1090'-130" '
          #1050#1086#1085#1090#1088#1086#1083#1083#1077#1088' "'#1056#1050'-131/300"'
          #1050#1086#1085#1090#1088#1086#1083#1083#1077#1088' "'#1050#1056'-300"'
          #1050#1086#1085#1090#1088#1086#1083#1083#1077#1088' "'#1050#1056'-300'#1048'"'
          #1052#1072#1089#1089#1088#1072#1089#1093#1086#1076#1086#1084#1077#1088' Elite RFT9739 (Modbus)'
          #1050#1086#1085#1090#1088#1086#1083#1083#1077#1088' SLC-500 (Modbus)'
          #1059#1089#1090#1088#1086#1081#1089#1090#1074#1086' '#1079#1072#1097#1080#1090#1099' '#1080' '#1089#1080#1075#1085#1072#1083#1080#1079#1072#1094#1080#1080' "'#1059#1047#1057'-24'#1052'"  (Modbus)'
          #1051#1086#1082#1072#1083#1100#1085#1099#1081' '#1088#1077#1075#1091#1083#1103#1090#1086#1088' "'#1052#1045#1058#1040#1050#1054#1053'-515"'
          #1058#1077#1088#1084#1086#1084#1077#1090#1088' '#1084#1085#1086#1075#1086#1082#1072#1085#1072#1083#1100#1085#1099#1081' "'#1058#1052'-5103"')
        TabOrder = 0
      end
    end
    object tsArchives: TTabSheet
      Caption = #1040#1088#1093#1080#1074#1099
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ImageIndex = 5
      ParentFont = False
      DesignSize = (
        428
        325)
      object GroupBox1: TGroupBox
        Left = 8
        Top = 4
        Width = 412
        Height = 185
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = ' '#1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1091#1076#1072#1083#1103#1090#1100' '#1085#1072#1082#1086#1087#1083#1077#1085#1085#1099#1077' '#1076#1072#1085#1085#1099#1077', '#1095#1077#1088#1077#1079': '
        TabOrder = 0
        object Label13: TLabel
          Left = 16
          Top = 35
          Width = 109
          Height = 14
          Caption = #1043#1088#1072#1092#1080#1082#1080' ('#1090#1088#1077#1085#1076#1099'):'
        end
        object Label21: TLabel
          Left = 16
          Top = 59
          Width = 180
          Height = 14
          Caption = #1052#1080#1085#1091#1090#1085#1099#1077' '#1079#1085#1072#1095#1077#1085#1080#1103' ('#1090#1072#1073#1083#1080#1094#1099'):'
        end
        object Label22: TLabel
          Left = 16
          Top = 83
          Width = 171
          Height = 14
          Caption = #1063#1072#1089#1086#1074#1099#1077' '#1079#1085#1072#1095#1077#1085#1080#1103' ('#1090#1072#1073#1083#1080#1094#1099'):'
        end
        object Label23: TLabel
          Left = 16
          Top = 107
          Width = 186
          Height = 14
          Caption = #1063#1072#1089#1086#1074#1099#1077' '#1091#1089#1088#1077#1076#1085#1077#1085#1080#1103' ('#1090#1072#1073#1083#1080#1094#1099'):'
        end
        object Label24: TLabel
          Left = 16
          Top = 131
          Width = 106
          Height = 14
          Caption = #1040#1088#1093#1080#1074#1099' '#1078#1091#1088#1085#1072#1083#1086#1074':'
        end
        object Label25: TLabel
          Left = 16
          Top = 155
          Width = 88
          Height = 14
          Caption = #1040#1088#1093#1080#1074' '#1086#1090#1095#1077#1090#1086#1074':'
        end
        object cbDelTrends: TComboBox
          Left = 208
          Top = 32
          Width = 97
          Height = 22
          Style = csDropDownList
          ItemHeight = 14
          ItemIndex = 4
          TabOrder = 0
          Text = '1 '#1085#1077#1076#1077#1083#1102
          Items.Strings = (
            #1085#1077' '#1091#1076#1072#1083#1103#1090#1100
            '1 '#1089#1091#1090#1082#1080
            '3 '#1089#1091#1090#1086#1082
            '5 '#1089#1091#1090#1086#1082
            '1 '#1085#1077#1076#1077#1083#1102
            '10 '#1089#1091#1090#1086#1082
            '2 '#1085#1077#1076#1077#1083#1080
            '1 '#1084#1077#1089#1103#1094
            '45 '#1089#1091#1090#1086#1082
            '60 '#1089#1091#1090#1086#1082
            '3 '#1084#1077#1089#1103#1094#1072
            '6 '#1084#1077#1089#1103#1094#1077#1074
            '1 '#1075#1086#1076)
        end
        object cbTrashTrends: TCheckBox
          Left = 320
          Top = 32
          Width = 81
          Height = 17
          Caption = #1074' '#1082#1086#1088#1079#1080#1085#1091
          TabOrder = 1
          Visible = False
        end
        object cbDelSnapMin: TComboBox
          Left = 208
          Top = 56
          Width = 97
          Height = 22
          Style = csDropDownList
          ItemHeight = 14
          ItemIndex = 4
          TabOrder = 2
          Text = '1 '#1085#1077#1076#1077#1083#1102
          Items.Strings = (
            #1085#1077' '#1091#1076#1072#1083#1103#1090#1100
            '1 '#1089#1091#1090#1082#1080
            '3 '#1089#1091#1090#1086#1082
            '5 '#1089#1091#1090#1086#1082
            '1 '#1085#1077#1076#1077#1083#1102
            '10 '#1089#1091#1090#1086#1082
            '2 '#1085#1077#1076#1077#1083#1080
            '1 '#1084#1077#1089#1103#1094
            '45 '#1089#1091#1090#1086#1082
            '60 '#1089#1091#1090#1086#1082
            '3 '#1084#1077#1089#1103#1094#1072
            '6 '#1084#1077#1089#1103#1094#1077#1074
            '1 '#1075#1086#1076)
        end
        object cbTrashSnapMin: TCheckBox
          Left = 320
          Top = 56
          Width = 81
          Height = 17
          Caption = #1074' '#1082#1086#1088#1079#1080#1085#1091
          TabOrder = 3
          Visible = False
        end
        object cbDelSnapHour: TComboBox
          Left = 208
          Top = 80
          Width = 97
          Height = 22
          Style = csDropDownList
          ItemHeight = 14
          ItemIndex = 9
          TabOrder = 4
          Text = '60 '#1089#1091#1090#1086#1082
          Items.Strings = (
            #1085#1077' '#1091#1076#1072#1083#1103#1090#1100
            '1 '#1089#1091#1090#1082#1080
            '3 '#1089#1091#1090#1086#1082
            '5 '#1089#1091#1090#1086#1082
            '1 '#1085#1077#1076#1077#1083#1102
            '10 '#1089#1091#1090#1086#1082
            '2 '#1085#1077#1076#1077#1083#1080
            '1 '#1084#1077#1089#1103#1094
            '45 '#1089#1091#1090#1086#1082
            '60 '#1089#1091#1090#1086#1082
            '3 '#1084#1077#1089#1103#1094#1072
            '6 '#1084#1077#1089#1103#1094#1077#1074
            '1 '#1075#1086#1076)
        end
        object cbTrashSnapHour: TCheckBox
          Left = 320
          Top = 80
          Width = 81
          Height = 17
          Caption = #1074' '#1082#1086#1088#1079#1080#1085#1091
          TabOrder = 5
          Visible = False
        end
        object cbDelAverHour: TComboBox
          Left = 208
          Top = 104
          Width = 97
          Height = 22
          Style = csDropDownList
          ItemHeight = 14
          ItemIndex = 9
          TabOrder = 6
          Text = '60 '#1089#1091#1090#1086#1082
          Items.Strings = (
            #1085#1077' '#1091#1076#1072#1083#1103#1090#1100
            '1 '#1089#1091#1090#1082#1080
            '3 '#1089#1091#1090#1086#1082
            '5 '#1089#1091#1090#1086#1082
            '1 '#1085#1077#1076#1077#1083#1102
            '10 '#1089#1091#1090#1086#1082
            '2 '#1085#1077#1076#1077#1083#1080
            '1 '#1084#1077#1089#1103#1094
            '45 '#1089#1091#1090#1086#1082
            '60 '#1089#1091#1090#1086#1082
            '3 '#1084#1077#1089#1103#1094#1072
            '6 '#1084#1077#1089#1103#1094#1077#1074
            '1 '#1075#1086#1076)
        end
        object cbTrashAverHour: TCheckBox
          Left = 320
          Top = 104
          Width = 81
          Height = 17
          Caption = #1074' '#1082#1086#1088#1079#1080#1085#1091
          TabOrder = 7
          Visible = False
        end
        object cbDelLogs: TComboBox
          Left = 208
          Top = 128
          Width = 97
          Height = 22
          Style = csDropDownList
          ItemHeight = 14
          ItemIndex = 4
          TabOrder = 8
          Text = '1 '#1085#1077#1076#1077#1083#1102
          Items.Strings = (
            #1085#1077' '#1091#1076#1072#1083#1103#1090#1100
            '1 '#1089#1091#1090#1082#1080
            '3 '#1089#1091#1090#1086#1082
            '5 '#1089#1091#1090#1086#1082
            '1 '#1085#1077#1076#1077#1083#1102
            '10 '#1089#1091#1090#1086#1082
            '2 '#1085#1077#1076#1077#1083#1080
            '1 '#1084#1077#1089#1103#1094
            '45 '#1089#1091#1090#1086#1082
            '60 '#1089#1091#1090#1086#1082
            '3 '#1084#1077#1089#1103#1094#1072
            '6 '#1084#1077#1089#1103#1094#1077#1074
            '1 '#1075#1086#1076)
        end
        object cbTrashLogs: TCheckBox
          Left = 320
          Top = 128
          Width = 81
          Height = 17
          Caption = #1074' '#1082#1086#1088#1079#1080#1085#1091
          TabOrder = 9
          Visible = False
        end
        object cbDelReportLogs: TComboBox
          Left = 208
          Top = 152
          Width = 97
          Height = 22
          Style = csDropDownList
          ItemHeight = 14
          ItemIndex = 11
          TabOrder = 10
          Text = '6 '#1084#1077#1089#1103#1094#1077#1074
          Items.Strings = (
            #1085#1077' '#1091#1076#1072#1083#1103#1090#1100
            '1 '#1089#1091#1090#1082#1080
            '3 '#1089#1091#1090#1086#1082
            '5 '#1089#1091#1090#1086#1082
            '1 '#1085#1077#1076#1077#1083#1102
            '10 '#1089#1091#1090#1086#1082
            '2 '#1085#1077#1076#1077#1083#1080
            '1 '#1084#1077#1089#1103#1094
            '45 '#1089#1091#1090#1086#1082
            '60 '#1089#1091#1090#1086#1082
            '3 '#1084#1077#1089#1103#1094#1072
            '6 '#1084#1077#1089#1103#1094#1077#1074
            '1 '#1075#1086#1076)
        end
        object cbTrashReportLogs: TCheckBox
          Left = 320
          Top = 152
          Width = 81
          Height = 17
          Caption = #1074' '#1082#1086#1088#1079#1080#1085#1091
          TabOrder = 11
          Visible = False
        end
      end
      object grpPathes: TGroupBox
        Left = 8
        Top = 192
        Width = 409
        Height = 129
        Caption = #1055#1091#1090#1080' '#1089#1086#1093#1088#1072#1085#1077#1085#1080#1103' '#1076#1072#1085#1085#1099#1093
        TabOrder = 1
        object lbl4: TLabel
          Left = 16
          Top = 27
          Width = 109
          Height = 14
          Caption = #1043#1088#1072#1092#1080#1082#1080' ('#1090#1088#1077#1085#1076#1099'):'
        end
        object lbl7: TLabel
          Left = 8
          Top = 51
          Width = 115
          Height = 14
          Caption = #1058#1072#1073#1083#1080#1094#1099' ('#1080#1089#1090#1086#1088#1080#1103'):'
        end
        object lbl5: TLabel
          Left = 24
          Top = 75
          Width = 98
          Height = 14
          Caption = #1040#1088#1093#1080#1074' '#1078#1091#1088#1085#1072#1083#1086#1074':'
        end
        object lbl6: TLabel
          Left = 24
          Top = 99
          Width = 88
          Height = 14
          Caption = #1040#1088#1093#1080#1074' '#1086#1090#1095#1077#1090#1086#1074':'
        end
        object edtPathTrends: TEdit
          Left = 144
          Top = 24
          Width = 225
          Height = 22
          ReadOnly = True
          TabOrder = 0
          Text = 'edtPathTrends'
        end
        object btnPathTrends: TButton
          Left = 375
          Top = 23
          Width = 27
          Height = 25
          Caption = '...'
          TabOrder = 1
          OnClick = btnPathTrendsClick
        end
        object edtPathTables: TEdit
          Left = 144
          Top = 48
          Width = 225
          Height = 22
          ReadOnly = True
          TabOrder = 2
          Text = 'edtPathTables'
        end
        object btnPathTables: TButton
          Left = 375
          Top = 47
          Width = 27
          Height = 25
          Caption = '...'
          TabOrder = 3
          OnClick = btnPathTablesClick
        end
        object edtPathLogs: TEdit
          Left = 144
          Top = 72
          Width = 225
          Height = 22
          ReadOnly = True
          TabOrder = 4
          Text = 'edtPathTrends'
        end
        object edtPathReports: TEdit
          Left = 144
          Top = 96
          Width = 225
          Height = 22
          ReadOnly = True
          TabOrder = 5
          Text = 'edtPathTables'
        end
        object btnPathLogs: TButton
          Left = 375
          Top = 71
          Width = 27
          Height = 25
          Caption = '...'
          TabOrder = 6
          OnClick = btnPathLogsClick
        end
        object btnPathReports: TButton
          Left = 375
          Top = 95
          Width = 27
          Height = 25
          Caption = '...'
          TabOrder = 7
          OnClick = btnPathReportsClick
        end
      end
    end
    object tsSchemaMenu: TTabSheet
      Caption = #1052#1077#1085#1102' '#1084#1085#1077#1084#1086#1089#1093#1077#1084
      ImageIndex = 6
      object lbl1: TLabel
        Left = 8
        Top = 220
        Width = 73
        Height = 20
        AutoSize = False
        Caption = #1058#1077#1082#1089#1090' '#1084#1077#1085#1102':'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
      end
      object lbl2: TLabel
        Left = 8
        Top = 272
        Width = 65
        Height = 21
        AutoSize = False
        Caption = #1055#1088#1080#1074#1103#1079#1082#1072':'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
      end
      object tvSchemeTree: TTreeView
        Left = 8
        Top = 8
        Width = 409
        Height = 201
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        HideSelection = False
        Indent = 19
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
        OnChange = tvSchemeTreeChange
        OnMouseDown = tvSchemeTreeMouseDown
      end
      object btnNewItem: TButton
        Left = 312
        Top = 236
        Width = 105
        Height = 25
        Caption = #1053#1086#1074#1086#1077' '#1084#1077#1085#1102
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnClick = btnNewItemClick
      end
      object btnNewSubItem: TButton
        Left = 312
        Top = 263
        Width = 105
        Height = 25
        Caption = #1053#1086#1074#1086#1077' '#1087#1086#1076#1084#1077#1085#1102
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        OnClick = btnNewSubItemClick
      end
      object btnDeleteItem: TButton
        Left = 312
        Top = 290
        Width = 105
        Height = 25
        Caption = #1059#1076#1072#1083#1080#1090#1100
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        OnClick = btnDeleteItemClick
      end
      object edtTextMenu: TEdit
        Left = 8
        Top = 239
        Width = 297
        Height = 22
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnChange = edtTextMenuChange
      end
      object cbbSchemeLink: TComboBox
        Left = 8
        Top = 292
        Width = 297
        Height = 22
        Enabled = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 2
        OnDropDown = cbRootSchemeDropDown
        OnSelect = cbbSchemeLinkSelect
      end
    end
  end
  object Timer: TTimer
    OnTimer = TimerTimer
    Left = 396
    Top = 40
  end
  object TreeActionList: TActionList
    Left = 325
    Top = 39
    object actChangeExtProc: TAction
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      OnExecute = actChangeExtProcExecute
      OnUpdate = actChangeExtProcUpdate
    end
    object actDeleteExtProc: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnExecute = actDeleteExtProcExecute
      OnUpdate = actChangeExtProcUpdate
    end
  end
end
