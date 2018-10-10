object frm_Princ00: Tfrm_Princ00
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Atac Sistemas - Gerenciador da NFe'
  ClientHeight = 572
  ClientWidth = 1018
  Color = clWindow
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  DesignSize = (
    1018
    572)
  PixelsPerInch = 96
  TextHeight = 14
  object html_Status: THTMLabel
    Left = 5
    Top = 494
    Width = 1005
    Height = 35
    ColorTo = 11769496
    BorderWidth = 1
    BorderStyle = bsSingle
    Color = 15524577
    HTMLText.Strings = (
      
        '<P align="left">TMS <b>STATUS</b> label</P> <P align="right">TMS' +
        ' <b>TOTAL</b> label</P>')
    ParentColor = False
    Transparent = False
    Version = '1.9.0.2'
  end
  object vst_Grid1: TVirtualStringTree
    Left = 5
    Top = 5
    Width = 1005
    Height = 485
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight]
    BevelInner = bvNone
    BevelKind = bkTile
    BorderStyle = bsNone
    Colors.DropTargetColor = 7063465
    Colors.DropTargetBorderColor = 4958089
    Colors.FocusedSelectionColor = clActiveCaption
    Colors.FocusedSelectionBorderColor = clActiveCaption
    Colors.GridLineColor = clBtnShadow
    Colors.UnfocusedSelectionBorderColor = clBtnShadow
    DefaultNodeHeight = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Trebuchet MS'
    Font.Style = []
    Header.AutoSizeIndex = 0
    Header.Background = clBtnHighlight
    Header.Height = 21
    Header.Options = [hoColumnResize, hoDrag, hoShowImages, hoShowSortGlyphs, hoVisible]
    Header.ParentFont = True
    Header.Style = hsPlates
    ParentFont = False
    RootNodeCount = 30
    TabOrder = 1
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScroll, toAutoTristateTracking]
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning]
    TreeOptions.PaintOptions = [toHotTrack, toShowDropmark, toShowHorzGridLines, toShowVertGridLines, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toDisableDrawSelection, toExtendedFocus, toMiddleClickSelect, toRightClickSelect, toCenterScrollIntoView]
    OnChange = vst_Grid1Change
    OnChecked = vst_Grid1Checked
    OnHeaderClick = vst_Grid1HeaderClick
    Columns = <
      item
        Color = 15000804
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coFixed, coAllowFocus]
        Position = 0
        Width = 315
        WideText = 'Chave'
      end
      item
        Alignment = taCenter
        Position = 1
        Width = 75
        WideText = 'Cod.Venda'
      end
      item
        Alignment = taCenter
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
        Position = 2
        WideText = 'Mod'
      end
      item
        Alignment = taCenter
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
        Position = 3
        Width = 45
        WideText = 'S'#233'rie'
      end
      item
        Alignment = taCenter
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
        Position = 4
        Width = 75
        WideText = 'Num.NF'
      end
      item
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
        Position = 5
        Width = 200
        WideText = 'Situa'#231#227'o'
      end
      item
        Alignment = taCenter
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
        Position = 6
        Width = 121
        WideText = 'Dt. Emiss'#227'o'
      end
      item
        Alignment = taCenter
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
        Position = 7
        Width = 40
        WideText = 'Tipo'
      end
      item
        Alignment = taCenter
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
        Position = 8
        Width = 90
        WideText = 'Tip. Emiss'#227'o'
      end
      item
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
        Position = 9
        Width = 80
        WideText = 'Finalidade'
      end
      item
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
        Position = 10
        Width = 200
        WideText = 'Id. do Destinat'#225'rio'
      end
      item
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
        Position = 11
        Width = 150
        WideText = 'Local Destinat'#225'rio'
      end
      item
        Alignment = taRightJustify
        CaptionAlignment = taCenter
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment]
        Position = 12
        Width = 90
        WideText = 'vBC'
      end
      item
        Alignment = taRightJustify
        CaptionAlignment = taCenter
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment]
        Position = 13
        Width = 90
        WideText = 'vICMS'
      end
      item
        Alignment = taRightJustify
        CaptionAlignment = taCenter
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment]
        Position = 14
        Width = 90
        WideText = 'vProdutos'
      end
      item
        Alignment = taRightJustify
        CaptionAlignment = taCenter
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment]
        Position = 15
        Width = 75
        WideText = 'vFrete'
      end
      item
        Alignment = taRightJustify
        CaptionAlignment = taCenter
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment]
        Position = 16
        Width = 75
        WideText = 'vSeguro'
      end
      item
        Alignment = taRightJustify
        CaptionAlignment = taCenter
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment]
        Position = 17
        Width = 75
        WideText = 'vDesconto'
      end
      item
        Alignment = taRightJustify
        CaptionAlignment = taCenter
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment]
        Position = 18
        Width = 75
        WideText = 'vIPI'
      end
      item
        Alignment = taRightJustify
        CaptionAlignment = taCenter
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment]
        Position = 19
        Width = 75
        WideText = 'vPIS'
      end
      item
        Alignment = taRightJustify
        CaptionAlignment = taCenter
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment]
        Position = 20
        Width = 75
        WideText = 'vCOFINS'
      end
      item
        Alignment = taRightJustify
        CaptionAlignment = taCenter
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment]
        Position = 21
        Width = 100
        WideText = 'vNF'
      end>
  end
  object pnl_Footer: TJvFooter
    Left = 0
    Top = 532
    Width = 1018
    Height = 40
    Align = alBottom
    BevelStyle = bsRaised
    BevelVisible = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Trebuchet MS'
    Font.Style = []
    ParentFont = False
    DesignSize = (
      1018
      40)
    object btn_Config: TJvFooterBtn
      Left = 8
      Top = 5
      Width = 100
      Height = 30
      Hint = 'Configura a forma de emiss'#227'o'
      Anchors = [akLeft, akBottom]
      Caption = 'Configura'#231#245'es'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = btn_ConfigClick
      Alignment = taLeftJustify
      ButtonIndex = 0
      SpaceInterval = 6
    end
    object btn_ConsSvc: TJvFooterBtn
      Left = 112
      Top = 5
      Width = 75
      Height = 30
      Hint = 'Consulta o status do servi'#231'o'
      Anchors = [akLeft, akBottom]
      Caption = 'Consultar'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = btn_ConsSvcClick
      Alignment = taLeftJustify
      ButtonIndex = 1
      SpaceInterval = 6
    end
    object btn_Filter: TJvFooterBtn
      Left = 193
      Top = 5
      Width = 75
      Height = 30
      Hint = 'Mostra/Esconde o Filtro'
      Anchors = [akLeft, akBottom]
      Caption = 'Filtro'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = btn_FilterClick
      Alignment = taLeftJustify
      ButtonIndex = 2
      SpaceInterval = 6
    end
    object btn_Close: TJvFooterBtn
      Left = 935
      Top = 5
      Width = 75
      Height = 30
      Anchors = [akRight, akBottom]
      Caption = 'Fechar'
      TabOrder = 0
      OnClick = btn_CloseClick
      ButtonIndex = 3
      SpaceInterval = 6
    end
    object btn_Items: TJvFooterBtn
      Left = 274
      Top = 5
      Width = 75
      Height = 30
      Hint = 'Itens da Nota Fiscal'
      Anchors = [akLeft, akBottom]
      Caption = 'Itens'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = btn_ItemsClick
      Alignment = taLeftJustify
      ButtonIndex = 4
      SpaceInterval = 6
    end
    object btn_Send: TJvFooterBtn
      Left = 355
      Top = 5
      Width = 75
      Height = 30
      Hint = 'Autoriza Nota Fiscal'
      Anchors = [akLeft, akBottom]
      Caption = 'Enviar'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnClick = btn_SendClick
      Alignment = taLeftJustify
      ButtonIndex = 5
      SpaceInterval = 6
    end
    object btn_Cons: TJvFooterBtn
      Left = 436
      Top = 5
      Width = 75
      Height = 30
      Hint = 'Consulta protocolo ou resultado do processamento do lote'
      Anchors = [akLeft, akBottom]
      Caption = 'Protocolo'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      OnClick = btn_ConsClick
      Alignment = taLeftJustify
      ButtonIndex = 6
      SpaceInterval = 6
    end
    object btn_Cancel: TJvFooterBtn
      Left = 517
      Top = 5
      Width = 75
      Height = 30
      Hint = 'Evento da NFE - Cancelamento / Carta de Corre'#231#227'o'
      Anchors = [akLeft, akBottom]
      Caption = 'Cancelar NFE CC-e'
      DropDownMenu = AdvPopupMenu1
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      Alignment = taLeftJustify
      ButtonIndex = 7
      SpaceInterval = 6
    end
    object btn_Danfe: TJvFooterBtn
      Left = 598
      Top = 5
      Width = 75
      Height = 30
      Hint = 'Imprime DANFE'
      Anchors = [akLeft, akBottom]
      Caption = 'DANFE'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 10
      OnClick = btn_DanfeClick
      Alignment = taLeftJustify
      ButtonIndex = 8
      SpaceInterval = 6
    end
    object btn_Inut: TJvFooterBtn
      Left = 679
      Top = 5
      Width = 75
      Height = 30
      Hint = 'Inutiliza sequ'#234'ncia de n'#250'meros'
      Anchors = [akLeft, akBottom]
      Caption = 'Inutilizar'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 8
      OnClick = btn_InutClick
      Alignment = taLeftJustify
      ButtonIndex = 9
      SpaceInterval = 6
    end
    object btn_export: TJvFooterBtn
      Left = 760
      Top = 5
      Width = 75
      Height = 30
      Hint = 'Exporta NFE para um local'
      Anchors = [akLeft, akBottom]
      Caption = 'Exportar'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 9
      OnClick = btn_exportClick
      Alignment = taLeftJustify
      ButtonIndex = 10
      SpaceInterval = 6
    end
    object btn_RelNF: TJvFooterBtn
      Left = 841
      Top = 5
      Width = 75
      Height = 30
      Anchors = [akLeft, akBottom]
      Caption = 'Relat'#243'rios'
      TabOrder = 11
      OnClick = btn_RelNFClick
      Alignment = taLeftJustify
      ButtonIndex = 11
      SpaceInterval = 6
    end
  end
  object pnl_Filter: TAdvPanel
    Left = 5
    Top = 5
    Width = 295
    Height = 485
    BevelOuter = bvNone
    BevelWidth = 0
    BorderStyle = bsSingle
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Trebuchet MS'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    UseDockManager = True
    Version = '2.3.0.0'
    BorderColor = clGray
    BorderShadow = True
    Caption.Color = clWhite
    Caption.ColorTo = clNone
    Caption.Font.Charset = DEFAULT_CHARSET
    Caption.Font.Color = clWindowText
    Caption.Font.Height = -12
    Caption.Font.Name = 'Tahoma'
    Caption.Font.Style = []
    Caption.Indent = 4
    Caption.ShadeLight = 255
    Caption.ShadeType = stRMetal
    Caption.Text = 
      '<P align="center"><FONT  size="8"  face="Trebuchet MS">.:Filtro:' +
      '.</FONT></P>'
    Caption.Visible = True
    CollapsColor = clBtnFace
    CollapsDelay = 0
    ColorTo = 15000804
    Padding.Left = 5
    Padding.Right = 5
    Padding.Bottom = 3
    ShadowColor = clBlack
    ShadowOffset = 0
    StatusBar.BorderColor = clWhite
    StatusBar.BorderStyle = bsSingle
    StatusBar.Font.Charset = DEFAULT_CHARSET
    StatusBar.Font.Color = clBlack
    StatusBar.Font.Height = -11
    StatusBar.Font.Name = 'Tahoma'
    StatusBar.Font.Style = []
    StatusBar.Color = 14606046
    StatusBar.ColorTo = 11119017
    StatusBar.GradientDirection = gdVertical
    DesignSize = (
      293
      483)
    FullHeight = 485
    object chk_EnvLote: TAdvOfficeCheckBox
      Left = 5
      Top = 424
      Width = 283
      Height = 20
      Anchors = [akLeft, akBottom]
      TabOrder = 7
      OnClick = chk_EnvLoteClick
      Alignment = taLeftJustify
      Caption = 'Modo envio de lote com varias NFE'
      ReturnIsTab = False
      Themed = True
      Version = '1.3.7.0'
    end
    object gbx_DtEmis: TAdvGroupBox
      Left = 5
      Top = 68
      Width = 283
      Height = 50
      RoundEdges = True
      Align = alTop
      Caption = ' Data de emiss'#227'o '
      TabOrder = 1
      object Label1: TLabel
        Left = 13
        Top = 20
        Width = 155
        Height = 14
        Caption = 'De:                            At'#233':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object edt_DatIni: TJvDateEdit
        Left = 35
        Top = 20
        Width = 100
        Height = 22
        ShowNullDate = False
        TabOrder = 0
        DisabledColor = clSilver
      end
      object edt_DatFin: TJvDateEdit
        Left = 174
        Top = 22
        Width = 100
        Height = 22
        ShowNullDate = False
        TabOrder = 1
        DisabledColor = clSilver
      end
    end
    object rgx_Status: TAdvOfficeRadioGroup
      Left = 5
      Top = 118
      Width = 283
      Height = 125
      RoundEdges = True
      Version = '1.3.7.0'
      Align = alTop
      Caption = ' Situa'#231#227'o '
      ParentBackground = False
      TabOrder = 2
      OnClick = rgx_StatusClick
      Columns = 2
      ItemIndex = 6
      Items.Strings = (
        'Pronto para envio;'
        'Conting'#234'ncia;'
        'Processadas;'
        'Canceladas;'
        'Erros;'
        'Reservado;'
        'Todos.')
      ButtonVertAlign = tlCenter
      Ellipsis = False
    end
    object btn_Exec: TJvImgBtn
      Left = 179
      Top = 447
      Width = 100
      Height = 30
      Anchors = [akRight, akBottom]
      Caption = 'Buscar'
      TabOrder = 8
      OnClick = btn_ExecClick
    end
    object gbx_CodPed: TAdvGroupBox
      Left = 5
      Top = 18
      Width = 283
      Height = 50
      RoundEdges = True
      Align = alTop
      Caption = ' N'#250'mero do Pedido (Venda) '
      TabOrder = 0
      object edt_PedIni: TAdvEdit
        Left = 35
        Top = 22
        Width = 100
        Height = 22
        EditAlign = eaCenter
        EditType = etNumeric
        EmptyTextStyle = []
        LabelCaption = 'De:'
        LabelMargin = 3
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
        TabOrder = 0
        Text = '0'
        Visible = True
        Version = '3.3.2.0'
      end
      object edt_PedFin: TAdvEdit
        Left = 174
        Top = 22
        Width = 100
        Height = 22
        EditAlign = eaCenter
        EditType = etNumeric
        EmptyTextStyle = []
        LabelCaption = 'At'#233':'
        LabelMargin = 3
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
        TabOrder = 1
        Text = '0'
        Visible = True
        Version = '3.3.2.0'
      end
    end
    object chk_ChvNFe: TAdvOfficeCheckBox
      Left = 5
      Top = 323
      Width = 283
      Height = 20
      Align = alTop
      Checked = True
      TabOrder = 4
      TabStop = True
      OnClick = chk_ChvNFeClick
      Alignment = taLeftJustify
      Caption = 'Mostrar chave da NFe'
      ReturnIsTab = False
      State = cbChecked
      Themed = True
      Version = '1.3.7.0'
    end
    object cbx_Ordem: TAdvComboBox
      Left = 5
      Top = 385
      Width = 133
      Height = 24
      Color = clWindow
      Version = '1.5.1.0'
      Visible = True
      Style = csDropDownList
      EmptyTextStyle = []
      DropWidth = 0
      Enabled = True
      ItemIndex = 1
      Items.Strings = (
        'Num.NF'
        'Data Emiss'#227'o'
        'Valor.NF')
      LabelCaption = 'Ordena'#231#227'o:'
      LabelPosition = lpTopLeft
      LabelMargin = 2
      LabelTransparent = True
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clNavy
      LabelFont.Height = -11
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
      TabOrder = 5
      Text = 'Data Emiss'#227'o'
    end
    object chk_Desc: TAdvOfficeCheckBox
      Left = 144
      Top = 385
      Width = 100
      Height = 20
      Checked = True
      Enabled = False
      TabOrder = 6
      TabStop = True
      Alignment = taLeftJustify
      Caption = 'Decrescente'
      ReturnIsTab = False
      State = cbChecked
      Themed = True
      Version = '1.3.7.0'
    end
    object gbx_ModSer: TAdvGroupBox
      Left = 5
      Top = 243
      Width = 283
      Height = 80
      Align = alTop
      Caption = ' Modelo/S'#233'rie '
      TabOrder = 3
      object cbx_Modelo: TAdvComboBox
        Left = 174
        Top = 20
        Width = 100
        Height = 24
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
        Left = 174
        Top = 50
        Width = 100
        Height = 22
        EditAlign = eaCenter
        EditType = etNumeric
        EmptyTextStyle = []
        LabelCaption = 'N'#250'mero de S'#233'rie:'
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
        TabOrder = 1
        Text = '0'
        Visible = True
        Version = '3.3.2.0'
      end
    end
  end
  object AppInstances1: TJvAppInstances
    Active = False
    Left = 288
    Top = 496
  end
  object ActionList1: TActionList
    Left = 472
    Top = 496
    object act_CancNFE: TAction
      Category = 'EVENTO'
      Caption = 'Cancelar NFE'
      GroupIndex = 1
      OnExecute = act_CancNFEExecute
    end
    object act_CCE: TAction
      Category = 'EVENTO'
      Caption = 'Carta de Corre'#231#227'o (CCE)'
      GroupIndex = 1
      OnExecute = act_CCEExecute
    end
  end
  object AdvPopupMenu1: TAdvPopupMenu
    MenuStyler = AdvMenuStyler1
    Version = '2.5.4.3'
    Left = 528
    Top = 496
    object mnu_CancNFE: TMenuItem
      Action = act_CancNFE
    end
    object mnu_CCE: TMenuItem
      Action = act_CCE
    end
  end
  object AdvMenuStyler1: TAdvMenuStyler
    AntiAlias = aaNone
    Background.Position = bpCenter
    SelectedItem.Font.Charset = DEFAULT_CHARSET
    SelectedItem.Font.Color = clWindowText
    SelectedItem.Font.Height = -12
    SelectedItem.Font.Name = 'Segoe UI'
    SelectedItem.Font.Style = []
    SelectedItem.NotesFont.Charset = DEFAULT_CHARSET
    SelectedItem.NotesFont.Color = clWindowText
    SelectedItem.NotesFont.Height = -9
    SelectedItem.NotesFont.Name = 'Segoe UI'
    SelectedItem.NotesFont.Style = []
    RootItem.Font.Charset = DEFAULT_CHARSET
    RootItem.Font.Color = clMenuText
    RootItem.Font.Height = -12
    RootItem.Font.Name = 'Segoe UI'
    RootItem.Font.Style = []
    Glyphs.SubMenu.Data = {
      5A000000424D5A000000000000003E0000002800000004000000070000000100
      0100000000001C0000000000000000000000020000000200000000000000FFFF
      FF0070000000300000001000000000000000100000003000000070000000}
    Glyphs.Check.Data = {
      7E000000424D7E000000000000003E0000002800000010000000100000000100
      010000000000400000000000000000000000020000000200000000000000FFFF
      FF00FFFF0000FFFF0000FFFF0000FFFF0000FDFF0000F8FF0000F07F0000F23F
      0000F71F0000FF8F0000FFCF0000FFEF0000FFFF0000FFFF0000FFFF0000FFFF
      0000}
    Glyphs.Radio.Data = {
      7E000000424D7E000000000000003E0000002800000010000000100000000100
      010000000000400000000000000000000000020000000200000000000000FFFF
      FF00FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FC3F0000F81F0000F81F
      0000F81F0000F81F0000FC3F0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000}
    SideBar.Font.Charset = DEFAULT_CHARSET
    SideBar.Font.Color = clWhite
    SideBar.Font.Height = -19
    SideBar.Font.Name = 'Tahoma'
    SideBar.Font.Style = [fsBold, fsItalic]
    SideBar.Image.Position = bpCenter
    SideBar.Background.Position = bpCenter
    SideBar.SplitterColorTo = clBlack
    Separator.GradientType = gtBoth
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMenuText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    NotesFont.Charset = DEFAULT_CHARSET
    NotesFont.Color = clGray
    NotesFont.Height = -9
    NotesFont.Name = 'Segoe UI'
    NotesFont.Style = []
    ButtonAppearance.CaptionFont.Charset = DEFAULT_CHARSET
    ButtonAppearance.CaptionFont.Color = clWindowText
    ButtonAppearance.CaptionFont.Height = -11
    ButtonAppearance.CaptionFont.Name = 'Segoe UI'
    ButtonAppearance.CaptionFont.Style = []
    Left = 576
    Top = 496
  end
end
