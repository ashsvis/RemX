object ShowOverviewForm: TShowOverviewForm
  Left = 194
  Top = 115
  Align = alClient
  BorderStyle = bsNone
  Caption = 'ShowOverviewForm'
  ClientHeight = 446
  ClientWidth = 688
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  PopupMenu = SchemePopupMenu
  Position = poDefault
  ShowHint = True
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnMouseWheel = FormMouseWheel
  PixelsPerInch = 96
  TextHeight = 13
  object Box: TScrollBox
    Left = 0
    Top = 0
    Width = 688
    Height = 446
    Align = alClient
    BorderStyle = bsNone
    TabOrder = 0
  end
  object DinPopupMenu: TPopupMenu
    OnPopup = DinPopupMenuPopup
    Left = 48
    Top = 40
    object miPasport: TMenuItem
      Caption = #1055#1072#1089#1087#1086#1088#1090
      OnClick = miPasportClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object miQuit: TMenuItem
      Caption = #1050#1074#1080#1090#1080#1088#1086#1074#1072#1090#1100
      OnClick = miQuitClick
    end
    object miTrend: TMenuItem
      Caption = #1058#1088#1077#1085#1076
      OnClick = miTrendClick
    end
    object miSeparator: TMenuItem
      Caption = '-'
    end
    object miInputValue: TMenuItem
      Caption = #1042#1074#1077#1089#1090#1080' '#1079#1085#1072#1095#1077#1085#1080#1077'...'
      OnClick = miInputValueClick
    end
    object miInputSP: TMenuItem
      Caption = #1042#1074#1077#1089#1090#1080' '#1079#1072#1076#1072#1085#1080#1077'...'
      OnClick = miInputSPClick
    end
    object miInputOP: TMenuItem
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1074#1099#1093#1086#1076'...'
      OnClick = miInputOPClick
    end
    object miInputMode: TMenuItem
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1088#1077#1078#1080#1084'...'
      OnClick = miInputModeClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object miBase: TMenuItem
      Caption = #1042' '#1073#1072#1079#1091' '#1076#1072#1085#1085#1099#1093'...'
      OnClick = miBaseClick
    end
  end
  object SchemePopupMenu: TPopupMenu
    Left = 48
    Top = 80
    object N3: TMenuItem
      Caption = #1055#1077#1095#1072#1090#1100' '#1084#1085#1077#1084#1086#1089#1093#1077#1084#1099
      object miDirectPrint: TMenuItem
        Caption = #1055#1088#1103#1084#1072#1103
        ShortCut = 49232
        OnClick = miDirectPrintClick
      end
      object miInversePrint: TMenuItem
        Caption = #1048#1085#1074#1077#1088#1089#1085#1072#1103
        ShortCut = 49225
        OnClick = miInversePrintClick
      end
    end
  end
  object frScreenReport: TfrReport
    InitialZoom = pzPageWidth
    ModifyPrepared = False
    PreviewButtons = [pbZoom, pbLoad, pbSave, pbPrint, pbFind, pbHelp, pbExit]
    ShowProgress = False
    Left = 48
    Top = 128
    ReportForm = {18000000}
  end
end
