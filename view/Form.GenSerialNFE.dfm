object frm_GenSerialNFE: Tfrm_GenSerialNFE
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = '.:Cria um Serial (sequ'#234'ncia) da NFe/NFCe no GenSerial:.'
  ClientHeight = 176
  ClientWidth = 457
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
  object pnl_Footer: TJvFooter
    Left = 0
    Top = 136
    Width = 457
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
    ExplicitLeft = -8
    DesignSize = (
      457
      40)
    object btn_OK: TJvFooterBtn
      Left = 245
      Top = 5
      Width = 100
      Height = 30
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      TabOrder = 0
      OnClick = btn_OKClick
      ButtonIndex = 0
      SpaceInterval = 6
    end
    object btn_Close: TJvFooterBtn
      Left = 349
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
  object cbx_CNPJ: TAdvComboBox
    Left = 176
    Top = 8
    Width = 273
    Height = 22
    Color = clWindow
    Version = '1.5.1.0'
    Visible = True
    BorderColor = clNavy
    Style = csDropDownList
    EmptyTextStyle = []
    FocusBorder = True
    FocusBorderColor = clMenuHighlight
    FocusColor = clInfoBk
    DropWidth = 0
    Enabled = True
    ItemIndex = -1
    LabelCaption = 'Selecione uma empresa:'
    LabelTransparent = True
    LabelFont.Charset = DEFAULT_CHARSET
    LabelFont.Color = clWindowText
    LabelFont.Height = -11
    LabelFont.Name = 'Tahoma'
    LabelFont.Style = []
    TabOrder = 1
  end
  object cbx_Modelo: TAdvComboBox
    Left = 328
    Top = 44
    Width = 121
    Height = 22
    Color = clWindow
    Version = '1.5.1.0'
    Visible = True
    BorderColor = clNavy
    Style = csDropDownList
    EmptyTextStyle = []
    FocusBorder = True
    FocusBorderColor = clMenuHighlight
    FocusColor = clInfoBk
    DropWidth = 0
    Enabled = True
    ItemIndex = 0
    Items.Strings = (
      'NF-e'
      'NFC-e')
    LabelCaption = 'Selecione um modelo:'
    LabelTransparent = True
    LabelFont.Charset = DEFAULT_CHARSET
    LabelFont.Color = clWindowText
    LabelFont.Height = -11
    LabelFont.Name = 'Tahoma'
    LabelFont.Style = []
    TabOrder = 2
    Text = 'NF-e'
  end
  object edt_NSerie: TAdvEdit
    Left = 328
    Top = 72
    Width = 121
    Height = 20
    AutoThousandSeparator = False
    BorderColor = clNavy
    EditAlign = eaCenter
    EditType = etNumeric
    EmptyTextStyle = []
    FocusBorder = True
    FocusBorderColor = clMenuHighlight
    FocusColor = clInfoBk
    LabelCaption = 'N'#250'mero de S'#233'rie(Caixa):'
    LabelTransparent = True
    LabelFont.Charset = DEFAULT_CHARSET
    LabelFont.Color = clWindowText
    LabelFont.Height = -11
    LabelFont.Name = 'Tahoma'
    LabelFont.Style = []
    Lookup.Font.Charset = DEFAULT_CHARSET
    Lookup.Font.Color = clWindowText
    Lookup.Font.Height = -11
    Lookup.Font.Name = 'Arial'
    Lookup.Font.Style = []
    Lookup.Separator = ';'
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 3
    Text = '0'
    Visible = True
    Version = '3.3.2.0'
  end
  object edt_Value: TAdvEdit
    Left = 328
    Top = 98
    Width = 121
    Height = 20
    AutoThousandSeparator = False
    BorderColor = clNavy
    EditAlign = eaCenter
    EditType = etNumeric
    EmptyTextStyle = []
    FocusBorder = True
    FocusBorderColor = clMenuHighlight
    FocusColor = clInfoBk
    LabelCaption = 'N'#250'mero inicial:'
    LabelTransparent = True
    LabelFont.Charset = DEFAULT_CHARSET
    LabelFont.Color = clWindowText
    LabelFont.Height = -11
    LabelFont.Name = 'Tahoma'
    LabelFont.Style = []
    Lookup.Font.Charset = DEFAULT_CHARSET
    Lookup.Font.Color = clWindowText
    Lookup.Font.Height = -11
    Lookup.Font.Name = 'Arial'
    Lookup.Font.Style = []
    Lookup.Separator = ';'
    Color = clWindow
    TabOrder = 4
    Text = '0'
    Visible = True
    Version = '3.3.2.0'
  end
end
