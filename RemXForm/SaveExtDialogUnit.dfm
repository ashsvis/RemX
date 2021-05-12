object SaveExtDialogForm: TSaveExtDialogForm
  Left = 369
  Top = 315
  BorderStyle = bsDialog
  Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1082#1072#1082'...'
  ClientHeight = 319
  ClientWidth = 546
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
  object Label1: TLabel
    Left = 15
    Top = 258
    Width = 67
    Height = 14
    Caption = #1048#1084#1103' '#1092#1072#1081#1083#1072':'
  end
  object Label2: TLabel
    Left = 15
    Top = 290
    Width = 73
    Height = 14
    Caption = #1058#1080#1087' '#1092#1072#1081#1083#1086#1074':'
  end
  object Button1: TButton
    Left = 440
    Top = 256
    Width = 89
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 440
    Top = 288
    Width = 89
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object FileListBox1: TFileListBox
    Left = 200
    Top = 16
    Width = 329
    Height = 225
    ItemHeight = 16
    ShowGlyphs = True
    TabOrder = 2
    OnChange = FileListBox1Change
  end
  object DirectoryListBox1: TDirectoryListBox
    Left = 16
    Top = 40
    Width = 177
    Height = 201
    FileList = FileListBox1
    ItemHeight = 16
    TabOrder = 3
  end
  object DriveComboBox1: TDriveComboBox
    Left = 16
    Top = 16
    Width = 177
    Height = 20
    DirList = DirectoryListBox1
    TabOrder = 4
    TextCase = tcUpperCase
  end
  object FilterComboBox1: TFilterComboBox
    Left = 112
    Top = 288
    Width = 313
    Height = 22
    FileList = FileListBox1
    Filter = #1042#1089#1077' '#1092#1072#1081#1083#1099' (*.*)|*.*|JPEG (*.jpg)|*.jpg'
    TabOrder = 5
  end
  object Edit1: TEdit
    Left = 112
    Top = 256
    Width = 313
    Height = 22
    TabOrder = 6
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 456
    Top = 32
  end
end
