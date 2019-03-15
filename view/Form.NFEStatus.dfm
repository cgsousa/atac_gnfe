object frm_NFEStatus: Tfrm_NFEStatus
  Left = 0
  Top = 0
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsSingle
  BorderWidth = 3
  Caption = 'Status da NFe'
  ClientHeight = 166
  ClientWidth = 508
  Color = clWindow
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 14
  object html_Status: THTMLabel
    Left = 0
    Top = 0
    Width = 508
    Height = 126
    Align = alClient
    ColorTo = 9568255
    BorderWidth = 1
    BorderStyle = bsSingle
    BorderColor = clGray
    Color = clInfoBk
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    HTMLText.Strings = (
      
        '<P align="center"><FONT color="#008000" face="Verdana"  size="12' +
        '" ><B>Format texto</B></FONT></P>')
    ParentColor = False
    ParentFont = False
    ShadowColor = clBlack
    ShadowOffset = 0
    Transparent = False
    VAlignment = tvaCenter
    Version = '1.9.0.2'
    ExplicitTop = -1
  end
  object pnl_Footer: TJvFooter
    Left = 0
    Top = 126
    Width = 508
    Height = 40
    Align = alBottom
    BevelStyle = bsRaised
    BevelVisible = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Trebuchet MS'
    Font.Style = []
    ParentFont = False
    ExplicitTop = 76
    DesignSize = (
      508
      40)
    object btn_Close: TJvFooterBtn
      Left = 201
      Top = 5
      Width = 100
      Height = 30
      Anchors = [akBottom]
      Caption = 'OK'
      TabOrder = 0
      OnClick = btn_CloseClick
      Alignment = taCenter
      ButtonIndex = 0
      SpaceInterval = 6
    end
  end
end
