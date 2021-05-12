object RmxBaseSvrForm: TRmxBaseSvrForm
  Left = 192
  Top = 114
  Width = 271
  Height = 147
  Caption = 'RmxBaseSvrForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object CheckSelf: TTimer
    Interval = 10000
    OnTimer = CheckSelfTimer
    Left = 16
    Top = 8
  end
  object Clock: TTimer
    OnTimer = ClockTimer
    Left = 56
    Top = 8
  end
end
