object UserDetailForm: TUserDetailForm
  Left = 189
  Top = 121
  BorderStyle = bsToolWindow
  Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1091#1095#1077#1090#1085#1086#1081' '#1079#1072#1087#1080#1089#1080
  ClientHeight = 242
  ClientWidth = 268
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 81
    Height = 23
    Alignment = taRightJustify
    AutoSize = False
    Caption = #1060#1072#1084#1080#1083#1080#1103
    Layout = tlCenter
  end
  object Label2: TLabel
    Left = 16
    Top = 40
    Width = 78
    Height = 23
    Alignment = taRightJustify
    AutoSize = False
    Caption = #1048#1084#1103
    Layout = tlCenter
  end
  object Label3: TLabel
    Left = 16
    Top = 72
    Width = 79
    Height = 23
    Alignment = taRightJustify
    AutoSize = False
    Caption = #1054#1090#1095#1077#1089#1090#1074#1086
    Layout = tlCenter
  end
  object Label4: TLabel
    Left = 16
    Top = 136
    Width = 78
    Height = 23
    Alignment = taRightJustify
    AutoSize = False
    Caption = #1055#1072#1088#1086#1083#1100
    Layout = tlCenter
  end
  object Label5: TLabel
    Left = 0
    Top = 166
    Width = 97
    Height = 27
    Alignment = taRightJustify
    AutoSize = False
    Caption = #1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' '#1087#1072#1088#1086#1083#1103
    WordWrap = True
  end
  object Label6: TLabel
    Left = 16
    Top = 104
    Width = 77
    Height = 23
    Alignment = taRightJustify
    AutoSize = False
    Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103
    Layout = tlCenter
  end
  object Bevel1: TBevel
    Left = 8
    Top = 200
    Width = 249
    Height = 9
    Shape = bsTopLine
  end
  object UserFamily: TEdit
    Left = 104
    Top = 8
    Width = 153
    Height = 22
    Ctl3D = True
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    MaxLength = 30
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 0
    Text = '012345678901234567890123456789'
    OnChange = UserFamilyChange
  end
  object UserName: TEdit
    Left = 104
    Top = 40
    Width = 153
    Height = 22
    Ctl3D = True
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    MaxLength = 20
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 1
    Text = '01234567890123456789'
    OnChange = UserFamilyChange
  end
  object UserSecondName: TEdit
    Left = 104
    Top = 72
    Width = 153
    Height = 22
    Ctl3D = True
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    MaxLength = 20
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 2
    Text = '01234567890123456789'
    OnChange = UserFamilyChange
  end
  object UserPassword: TEdit
    Left = 104
    Top = 136
    Width = 153
    Height = 22
    Ctl3D = True
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    MaxLength = 16
    ParentCtl3D = False
    ParentFont = False
    PasswordChar = '*'
    TabOrder = 4
    Text = '0123456789012345'
    OnChange = UserFamilyChange
  end
  object UserConfirm: TEdit
    Left = 104
    Top = 168
    Width = 153
    Height = 22
    Ctl3D = True
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    MaxLength = 16
    ParentCtl3D = False
    ParentFont = False
    PasswordChar = '*'
    TabOrder = 5
    Text = '0123456789012345'
    OnChange = UserFamilyChange
  end
  object OkButton: TBitBtn
    Left = 72
    Top = 208
    Width = 81
    Height = 25
    Caption = #1042#1074#1086#1076
    Default = True
    Enabled = False
    ModalResult = 1
    TabOrder = 6
    NumGlyphs = 2
  end
  object CancelButton: TBitBtn
    Left = 168
    Top = 208
    Width = 81
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 7
    NumGlyphs = 2
  end
  object UserCategory: TComboBox
    Left = 104
    Top = 104
    Width = 153
    Height = 22
    Style = csDropDownList
    Ctl3D = True
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ItemHeight = 14
    ItemIndex = 0
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 3
    Text = #1044#1080#1089#1087#1077#1090#1095#1077#1088
    OnChange = UserFamilyChange
    Items.Strings = (
      #1044#1080#1089#1087#1077#1090#1095#1077#1088
      #1054#1087#1077#1088#1072#1090#1086#1088
      #1055#1088#1080#1073#1086#1088#1080#1089#1090
      #1048#1085#1078#1077#1085#1077#1088'-'#1090#1077#1093#1085#1086#1083#1086#1075
      #1048#1085#1078#1077#1085#1077#1088' '#1040#1057#1059' '#1058#1055
      #1055#1088#1086#1075#1088#1072#1084#1084#1080#1089#1090)
  end
end
