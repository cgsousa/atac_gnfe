object frm_Ajuda: Tfrm_Ajuda
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  BorderWidth = 3
  Caption = 'Ajuda (Atalhos utilizados no gerenciador)'
  ClientHeight = 120
  ClientWidth = 628
  Color = clWindow
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 14
  object htm_Ajuda: THTMLabel
    Left = 0
    Top = 0
    Width = 628
    Height = 120
    Align = alClient
    ColorTo = 12189695
    BorderWidth = 1
    BorderStyle = bsSingle
    Color = clInfoBk
    GradientType = gtFullVertical
    HTMLText.Strings = (
      
        '<P><IND x="50"><FONT color="#0000FF">Ctrl+K</FONT> Corrige Chave' +
        '/XML conforme forma de emiss'#227'o</P> <P><IND x="50"><b>Ctrl+S</b> ' +
        'Envia XML/Danfe por e-mail ao destinat'#225'rio</P>')
    ParentColor = False
    Transparent = False
    VAlignment = tvaCenter
    Version = '1.9.0.2'
    ExplicitHeight = 404
  end
end
