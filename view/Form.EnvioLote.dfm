object frm_EnvLote: Tfrm_EnvLote
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = '.:Envio de Lote:.'
  ClientHeight = 572
  ClientWidth = 794
  Color = clWindow
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object pnl_Footer: TJvFooter
    Left = 0
    Top = 532
    Width = 794
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
      794
      40)
    object btn_Close: TJvFooterBtn
      Left = 686
      Top = 5
      Width = 100
      Height = 30
      Anchors = [akRight, akBottom]
      Caption = 'Fechar'
      TabOrder = 0
      OnClick = btn_CloseClick
      ButtonIndex = 0
      SpaceInterval = 6
    end
    object btn_Start: TJvFooterBtn
      Left = 8
      Top = 5
      Width = 100
      Height = 30
      Anchors = [akLeft, akBottom]
      Caption = 'Iniciar'
      Enabled = False
      TabOrder = 1
      OnClick = btn_StartClick
      Alignment = taLeftJustify
      ButtonIndex = 1
      SpaceInterval = 6
    end
    object btn_Stop: TJvFooterBtn
      Left = 112
      Top = 5
      Width = 100
      Height = 30
      Anchors = [akLeft, akBottom]
      Caption = 'Parar'
      Enabled = False
      TabOrder = 2
      OnClick = btn_StopClick
      Alignment = taLeftJustify
      ButtonIndex = 2
      SpaceInterval = 6
    end
  end
  object gbx_Opt: TAdvGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 788
    Height = 50
    Align = alTop
    Caption = ' Op'#231#245'es do CAIXA '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Trebuchet MS'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object cbx_Modelo: TAdvComboBox
      Left = 166
      Top = 18
      Width = 100
      Height = 26
      Color = clWindow
      Version = '1.5.1.0'
      Visible = True
      Style = csDropDownList
      EmptyTextStyle = []
      DropWidth = 0
      Enabled = True
      ItemIndex = 2
      Items.Strings = (
        'NF-e(55)'
        'NFC-e(65)'
        'TODOS')
      LabelCaption = 'Modelo:'
      LabelMargin = 2
      LabelTransparent = True
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clNavy
      LabelFont.Height = -11
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
      TabOrder = 0
      Text = 'TODOS'
    end
    object edt_NSerie: TAdvEdit
      Left = 342
      Top = 18
      Width = 100
      Height = 24
      EditAlign = eaCenter
      EditType = etNumeric
      EmptyText = 'S'#233'rie[1..889]'
      EmptyTextStyle = []
      MaxValue = 889
      LabelCaption = 'N'#250'mero:'
      LabelMargin = 3
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
      MaxLength = 3
      TabOrder = 1
      Text = '0'
      Visible = True
      Version = '3.3.2.0'
    end
  end
  object txt_RichLOG: TRichEdit
    AlignWithMargins = True
    Left = 3
    Top = 59
    Width = 788
    Height = 470
    Align = alClient
    BorderWidth = 1
    Color = clInfoBk
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Trebuchet MS'
    Font.Style = []
    HideScrollBars = False
    Lines.Strings = (
      'txt_RichLOG')
    ParentFont = False
    PlainText = True
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 2
  end
end
