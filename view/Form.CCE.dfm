object frm_CCE: Tfrm_CCE
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = '.:Nova Carta de Corre'#231#227'o Eletronica - CCE:.'
  ClientHeight = 337
  ClientWidth = 634
  Color = clWindow
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object html_Prompt: THTMLabel
    Left = 5
    Top = 5
    Width = 621
    Height = 152
    ColorTo = clSilver
    AutoSizing = True
    BorderWidth = 1
    BorderStyle = bsSingle
    BorderColor = clBtnFace
    HTMLText.Strings = (
      
        '<FONT face="Verdana" color="#FF0000" size="12"><b>ATEN'#199#195'O!</b></' +
        'FONT><p></p><p></p><FONT face="Verdana" color="#FF0000" size="10' +
        '">A Carta de Correcao e disciplinada pelo paragrafo 1o-A do art.' +
        ' 7o do Convenio S/N, de 15 de dezembro de 1970 e pode ser utiliz' +
        'ada para regularizacao de erro ocorrido na emissao de documento ' +
        'fiscal, desde que o erro nao esteja relacionado com: </FONT><p><' +
        '/p><FONT face="Verdana" color="#FF0000" size="10"> I - as variav' +
        'eis que determinam o valor do imposto tais como: base de calculo' +
        ', aliquota, diferenca de preco, quantidade, valor da operacao ou' +
        ' da prestacao;</FONT><p></p><FONT face="Verdana" color="#FF0000"' +
        ' size="10"> II - a correcao de dados cadastrais que implique mud' +
        'anca do remetente ou do destinatario;</FONT><P></P><FONT face="V' +
        'erdana" color="#FF0000" size="10"> III - a data de emissao ou de' +
        ' saida.</FONT><P></P>')
    Transparent = True
    Version = '1.9.0.2'
  end
  object Label1: TLabel
    Left = 5
    Top = 168
    Width = 311
    Height = 14
    Caption = 'Informe a corre'#231#227'o abaixo com no m'#237'nimo 15 caracteres:'
  end
  object pnl_Footer: TJvFooter
    Left = 0
    Top = 297
    Width = 634
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
    DesignSize = (
      634
      40)
    object btn_OK: TJvFooterBtn
      Left = 422
      Top = 5
      Width = 100
      Height = 30
      Anchors = [akRight, akBottom]
      Caption = 'Confirmar'
      TabOrder = 0
      OnClick = btn_OKClick
      ButtonIndex = 0
      SpaceInterval = 6
    end
    object btn_Close: TJvFooterBtn
      Left = 526
      Top = 5
      Width = 100
      Height = 30
      Anchors = [akRight, akBottom]
      Caption = 'Cancelar'
      TabOrder = 1
      OnClick = btn_CloseClick
      ButtonIndex = 1
      SpaceInterval = 6
    end
  end
  object txt_Correcao: TJvMemo
    Left = 5
    Top = 188
    Width = 621
    Height = 89
    DotNetHighlighting = True
    Flat = True
    Lines.Strings = (
      'txt_Correcao')
    TabOrder = 1
  end
end
