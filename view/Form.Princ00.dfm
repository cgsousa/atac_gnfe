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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object vst_Grid1: TVirtualStringTree
    Left = 295
    Top = 0
    Width = 428
    Height = 511
    Align = alClient
    Alignment = taCenter
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
    OnHeaderClick = vst_Grid1HeaderClick
    Columns = <
      item
        Color = 15000804
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coFixed, coAllowFocus]
        Position = 0
        Width = 320
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
    Top = 511
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
      Width = 90
      Height = 30
      Hint = 'Configura a forma de emiss'#227'o'
      Anchors = [akLeft, akBottom]
      Caption = 'Configura'#231#245'es'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = btn_ConfigClick
      Alignment = taLeftJustify
      HintColor = clInfoBk
      ButtonIndex = 0
      SpaceInterval = 6
    end
    object btn_ConsSvc: TJvFooterBtn
      Left = 102
      Top = 5
      Width = 80
      Height = 30
      Hint = 'Consulta o status do servi'#231'o'
      Anchors = [akLeft, akBottom]
      Caption = 'Consultar'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = btn_ConsSvcClick
      Alignment = taLeftJustify
      HintColor = clInfoBk
      ButtonIndex = 1
      SpaceInterval = 6
    end
    object btn_Filter: TJvFooterBtn
      Left = 188
      Top = 5
      Width = 80
      Height = 30
      Hint = 'Mostra/Esconde o Filtro'
      Anchors = [akLeft, akBottom]
      Caption = 'Filtro'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = btn_FilterClick
      Alignment = taLeftJustify
      HintColor = clInfoBk
      ButtonIndex = 2
      SpaceInterval = 6
    end
    object btn_Close: TJvFooterBtn
      Left = 930
      Top = 5
      Width = 80
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
      Width = 80
      Height = 30
      Hint = 'Itens da Nota Fiscal'
      Anchors = [akLeft, akBottom]
      Caption = 'Itens'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = btn_ItemsClick
      Alignment = taLeftJustify
      HintColor = clInfoBk
      ButtonIndex = 4
      SpaceInterval = 6
    end
    object btn_Send: TJvFooterBtn
      Left = 360
      Top = 5
      Width = 80
      Height = 30
      Hint = 'Autoriza uso da NFe'
      Anchors = [akLeft, akBottom]
      Caption = 'Autorizar Uso'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnClick = btn_SendClick
      Alignment = taLeftJustify
      HintColor = clInfoBk
      ButtonIndex = 5
      SpaceInterval = 6
    end
    object btn_SendAsync: TJvFooterBtn
      Left = 446
      Top = 5
      Width = 80
      Height = 30
      Hint = 'Envio de lote /Desvincula NFE do lote'
      Anchors = [akLeft, akBottom]
      Caption = 'Lote'
      DropDownMenu = pm_Lote
      ParentShowHint = False
      ShowHint = True
      TabOrder = 9
      Alignment = taLeftJustify
      HintColor = clInfoBk
      ButtonIndex = 6
      SpaceInterval = 6
    end
    object btn_Cons: TJvFooterBtn
      Left = 532
      Top = 5
      Width = 80
      Height = 30
      Hint = 'Consulta info protocolo de autoriza'#231#227'o de uso'
      Anchors = [akLeft, akBottom]
      Caption = 'Protocolo'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      OnClick = btn_ConsClick
      Alignment = taLeftJustify
      HintColor = clInfoBk
      ButtonIndex = 7
      SpaceInterval = 6
    end
    object btn_Evento: TJvFooterBtn
      Left = 618
      Top = 5
      Width = 80
      Height = 30
      Hint = 'Cancelamento / Carta de Corre'#231#227'o'
      Anchors = [akLeft, akBottom]
      Caption = 'Evento'
      DropDownMenu = pm_Evento
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      Alignment = taLeftJustify
      HintColor = clInfoBk
      ButtonIndex = 8
      SpaceInterval = 6
    end
    object btn_RelNF: TJvFooterBtn
      Left = 704
      Top = 5
      Width = 80
      Height = 30
      Hint = 'Listagem de Notas Fiscais detalhada/resumida'
      Anchors = [akLeft, akBottom]
      Caption = 'Relat'#243'rios'
      DropDownMenu = pm_Rel
      ParentShowHint = False
      ShowHint = True
      TabOrder = 10
      Alignment = taLeftJustify
      HintColor = clInfoBk
      ButtonIndex = 9
      SpaceInterval = 6
    end
    object btn_Inut: TJvFooterBtn
      Left = 790
      Top = 5
      Width = 80
      Height = 30
      Hint = 'Inutiliza sequ'#234'ncia de n'#250'meros'
      Anchors = [akLeft, akBottom]
      Caption = 'Inutilizar'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 8
      OnClick = btn_InutClick
      Alignment = taLeftJustify
      HintColor = clInfoBk
      ButtonIndex = 10
      SpaceInterval = 6
    end
  end
  object pnl_Filter: TAdvPanel
    Left = 0
    Top = 0
    Width = 295
    Height = 511
    Align = alLeft
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
    StatusBar.Visible = True
    DesignSize = (
      293
      509)
    FullHeight = 485
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
      Columns = 2
      ItemIndex = 2
      Items.Strings = (
        'Pronto para envio;'
        'Conting'#234'ncia;'
        'Uso Autorizado;'
        'Uso Denegado;'
        'Cancelada;'
        'Inutilizada;'
        'Erros;'
        'Todos.')
      ButtonVertAlign = tlCenter
      Ellipsis = False
    end
    object btn_Exec: TJvImgBtn
      Left = 188
      Top = 450
      Width = 100
      Height = 30
      Anchors = [akRight, akBottom]
      Caption = 'Buscar'
      TabOrder = 7
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
        EmptyText = 'S'#233'rie[1..889]'
        EmptyTextStyle = []
        MaxValue = 889
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
        MaxLength = 3
        TabOrder = 1
        Text = '0'
        Visible = True
        Version = '3.3.2.0'
      end
    end
  end
  object AdvOfficeStatusBar1: TAdvOfficeStatusBar
    Left = 0
    Top = 551
    Width = 1018
    Height = 21
    AnchorHint = False
    Panels = <
      item
        AppearanceStyle = psLight
        DateFormat = 'dd/MM/yyyy'
        Progress.BackGround = clNone
        Progress.Indication = piPercentage
        Progress.Min = 0
        Progress.Max = 100
        Progress.Position = 0
        Progress.Level0Color = clLime
        Progress.Level0ColorTo = 14811105
        Progress.Level1Color = clYellow
        Progress.Level1ColorTo = 13303807
        Progress.Level2Color = 5483007
        Progress.Level2ColorTo = 11064319
        Progress.Level3Color = clRed
        Progress.Level3ColorTo = 13290239
        Progress.Level1Perc = 70
        Progress.Level2Perc = 90
        Progress.BorderColor = clBlack
        Progress.ShowBorder = False
        Progress.Stacked = False
        Text = 
          '<p><font color="#FFFFFF" bgcolor="#FF0000"><b> Homologa'#231#227'o </b><' +
          '/font</p>'
        TimeFormat = 'hh:mm:ss'
        Width = 90
      end
      item
        Alignment = taCenter
        AppearanceStyle = psLight
        DateFormat = 'dd/MM/yyyy'
        Progress.BackGround = clNone
        Progress.Indication = piPercentage
        Progress.Min = 0
        Progress.Max = 100
        Progress.Position = 0
        Progress.Level0Color = clLime
        Progress.Level0ColorTo = 14811105
        Progress.Level1Color = clYellow
        Progress.Level1ColorTo = 13303807
        Progress.Level2Color = 5483007
        Progress.Level2ColorTo = 11064319
        Progress.Level3Color = clRed
        Progress.Level3ColorTo = 13290239
        Progress.Level1Perc = 70
        Progress.Level2Perc = 90
        Progress.BorderColor = clBlack
        Progress.ShowBorder = False
        Progress.Stacked = False
        Text = 'Nenhum'
        TimeFormat = 'hh:mm:ss'
        Width = 75
      end
      item
        AppearanceStyle = psLight
        DateFormat = 'dd/MM/yyyy'
        Progress.BackGround = clNone
        Progress.Indication = piPercentage
        Progress.Min = 0
        Progress.Max = 100
        Progress.Position = 0
        Progress.Level0Color = clLime
        Progress.Level0ColorTo = 14811105
        Progress.Level1Color = clYellow
        Progress.Level1ColorTo = 13303807
        Progress.Level2Color = 5483007
        Progress.Level2ColorTo = 11064319
        Progress.Level3Color = clRed
        Progress.Level3ColorTo = 13290239
        Progress.Level1Perc = 70
        Progress.Level2Perc = 90
        Progress.BorderColor = clBlack
        Progress.ShowBorder = False
        Progress.Stacked = False
        Text = 'Total: R$99,999,999.99'
        TimeFormat = 'hh:mm:ss'
        Width = 140
      end
      item
        AppearanceStyle = psLight
        DateFormat = 'dd/MM/yyyy'
        Progress.BackGround = clNone
        Progress.Indication = piPercentage
        Progress.Min = 0
        Progress.Max = 100
        Progress.Position = 50
        Progress.Level0Color = clLime
        Progress.Level0ColorTo = 14811105
        Progress.Level1Color = clYellow
        Progress.Level1ColorTo = 13303807
        Progress.Level2Color = 5483007
        Progress.Level2ColorTo = 11064319
        Progress.Level3Color = clRed
        Progress.Level3ColorTo = 13290239
        Progress.Level1Perc = 70
        Progress.Level2Perc = 90
        Progress.BorderColor = clBlack
        Progress.ShowBorder = False
        Progress.Stacked = True
        Style = psProgress
        TimeFormat = 'hh:mm:ss'
        Width = 250
      end
      item
        AppearanceStyle = psLight
        DateFormat = 'dd/MM/yyyy'
        Progress.BackGround = clNone
        Progress.Indication = piPercentage
        Progress.Min = 0
        Progress.Max = 100
        Progress.Position = 0
        Progress.Level0Color = clLime
        Progress.Level0ColorTo = 14811105
        Progress.Level1Color = clYellow
        Progress.Level1ColorTo = 13303807
        Progress.Level2Color = 5483007
        Progress.Level2ColorTo = 11064319
        Progress.Level3Color = clRed
        Progress.Level3ColorTo = 13290239
        Progress.Level1Perc = 70
        Progress.Level2Perc = 90
        Progress.BorderColor = clBlack
        Progress.ShowBorder = False
        Progress.Stacked = False
        Text = '<p>TESTE <font color="#FF8C00">%s</font</p>'
        TimeFormat = 'hh:mm:ss'
        Width = 50
      end>
    ShowSplitter = True
    SimplePanel = False
    Styler = AdvOfficeStatusBarOfficeStyler1
    Version = '1.5.2.2'
  end
  object pnl_Help: TAdvPanel
    Left = 723
    Top = 0
    Width = 295
    Height = 511
    Align = alRight
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
    TabOrder = 5
    UseDockManager = True
    Version = '2.3.0.0'
    BorderColor = clGray
    BorderShadow = True
    Caption.Color = clWhite
    Caption.ColorTo = clNone
    Caption.CloseColor = clActiveCaption
    Caption.CloseButton = True
    Caption.Font.Charset = DEFAULT_CHARSET
    Caption.Font.Color = clWindowText
    Caption.Font.Height = -12
    Caption.Font.Name = 'Tahoma'
    Caption.Font.Style = []
    Caption.Indent = 4
    Caption.ShadeLight = 255
    Caption.ShadeType = stRMetal
    Caption.Text = 
      '<P align="center"><FONT  size="8"  face="Trebuchet MS">.:Ajuda:.' +
      '</FONT></P>'
    Caption.Visible = True
    CollapsColor = clBtnFace
    CollapsDelay = 0
    ColorTo = clInfoBk
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
    Text = 
      '<p><ind x="10"><font color="#0000ff">Ctrl+S</font> Envia XML/DAN' +
      'FE para o e-mail do destinat'#225'rio</p> <p><ind x="10"><font   colo' +
      'r="#0000ff">Ctrl+E</font> Exporta o XML da NFe, indepedente de s' +
      'itua'#231#227'o</p> <p><ind x="10"><font color="#0000ff">Ctrl+K</font> F' +
      'or'#231'a   gera'#231#227'o XML/Chave com base na forma de emiss'#227'o (CUIDADO !' +
      '!!)</p> <p><ind x="10"><font color="#0000ff">Alt+X</font> Cria u' +
      'm serial   (sequ'#234'ncia) da NFe/NFCe no GenSerial</p> '
    TextVAlign = tvaCenter
    OnCaptionClick = pnl_HelpCaptionClick
    FullHeight = 485
  end
  object AppInstances1: TJvAppInstances
    Active = False
    Left = 320
    Top = 472
  end
  object ActionList1: TActionList
    Left = 384
    Top = 472
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
    object act_ListDetalh: TAction
      Category = 'REL'
      Caption = 'Listagem Detalhe'
      GroupIndex = 1
      ShortCut = 16452
      OnExecute = act_ListDetalhExecute
    end
    object act_ListResumo: TAction
      Tag = 1
      Category = 'REL'
      Caption = 'Listagem Resumo'
      GroupIndex = 1
      ShortCut = 16466
      OnExecute = act_ListDetalhExecute
    end
    object act_DANFE: TAction
      Category = 'REL'
      Caption = 'DANFe/DANFCe'
      Hint = 'Documento auxiliar da NFE'
      ShortCut = 16464
      OnExecute = act_DANFEExecute
    end
    object act_Export: TAction
      Category = 'REL'
      Caption = 'Exportar XML'
      Hint = 'Exporta XML da NFe/NFCe'
      OnExecute = act_ExportExecute
    end
    object act_SendLot: TAction
      Category = 'LOTE'
      Caption = 'Enviar'
      Hint = 'Envio de lote'
      OnExecute = act_SendLotExecute
    end
    object act_Desvincula: TAction
      Category = 'LOTE'
      Caption = 'Desvincular NFE'
      Hint = 'Desvincula NFE do lote'
      OnExecute = act_DesvinculaExecute
    end
  end
  object pm_Evento: TAdvPopupMenu
    MenuStyler = AdvMenuStyler1
    Version = '2.5.4.3'
    Left = 528
    Top = 472
    object mnu_CancNFE: TMenuItem
      Action = act_CancNFE
      Caption = 'Cancelar'
      Hint = 'Cancela NFe/NFCe'
      ShortCut = 16430
    end
    object mnu_CCE: TMenuItem
      Action = act_CCE
      Hint = 'Carta de Core'#231#227'o'
      ShortCut = 16497
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
    Left = 624
    Top = 472
  end
  object pm_Rel: TAdvPopupMenu
    MenuStyler = AdvMenuStyler1
    Version = '2.5.4.3'
    Left = 576
    Top = 472
    object DANFeDANFCe1: TMenuItem
      Action = act_DANFE
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object ListagemDetalhe1: TMenuItem
      Action = act_ListDetalh
    end
    object ListagemResumo1: TMenuItem
      Action = act_ListResumo
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object actExport1: TMenuItem
      Action = act_Export
    end
  end
  object AdvOfficeStatusBarOfficeStyler1: TAdvOfficeStatusBarOfficeStyler
    Style = psTerminal
    BorderColor = clGray
    PanelAppearanceLight.BorderColor = clGray
    PanelAppearanceLight.BorderColorHot = clSilver
    PanelAppearanceLight.BorderColorDown = clGray
    PanelAppearanceLight.Color = clBtnFace
    PanelAppearanceLight.ColorTo = clBtnFace
    PanelAppearanceLight.ColorHot = clGray
    PanelAppearanceLight.ColorHotTo = clGray
    PanelAppearanceLight.ColorDown = clHighlight
    PanelAppearanceLight.ColorDownTo = clHighlight
    PanelAppearanceLight.ColorMirror = clBtnFace
    PanelAppearanceLight.ColorMirrorTo = clBtnFace
    PanelAppearanceLight.ColorMirrorHot = clGray
    PanelAppearanceLight.ColorMirrorHotTo = clGray
    PanelAppearanceLight.ColorMirrorDown = clHighlight
    PanelAppearanceLight.ColorMirrorDownTo = clHighlight
    PanelAppearanceLight.TextColor = clBlack
    PanelAppearanceLight.TextColorHot = clBlack
    PanelAppearanceLight.TextColorDown = clBlack
    PanelAppearanceLight.TextStyle = []
    PanelAppearanceDark.BorderColor = clGray
    PanelAppearanceDark.BorderColorHot = clSilver
    PanelAppearanceDark.BorderColorDown = clGray
    PanelAppearanceDark.Color = clSilver
    PanelAppearanceDark.ColorTo = clSilver
    PanelAppearanceDark.ColorHot = clGray
    PanelAppearanceDark.ColorHotTo = clGray
    PanelAppearanceDark.ColorDown = clHighlight
    PanelAppearanceDark.ColorDownTo = clHighlight
    PanelAppearanceDark.ColorMirror = clSilver
    PanelAppearanceDark.ColorMirrorTo = clSilver
    PanelAppearanceDark.ColorMirrorHot = clGray
    PanelAppearanceDark.ColorMirrorHotTo = clGray
    PanelAppearanceDark.ColorMirrorDown = clHighlight
    PanelAppearanceDark.ColorMirrorDownTo = clHighlight
    PanelAppearanceDark.TextColor = clBlack
    PanelAppearanceDark.TextColorHot = clBlack
    PanelAppearanceDark.TextColorDown = clBlack
    PanelAppearanceDark.TextStyle = []
    Left = 832
    Top = 376
  end
  object pm_Lote: TAdvPopupMenu
    MenuStyler = AdvMenuStyler1
    Version = '2.5.4.3'
    Left = 488
    Top = 472
    object Enviar1: TMenuItem
      Action = act_SendLot
    end
    object Desvincular1: TMenuItem
      Action = act_Desvincula
    end
  end
end
