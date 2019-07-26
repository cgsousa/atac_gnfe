object frm_ManifestoList: Tfrm_ManifestoList
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Lista de Manifestos'
  ClientHeight = 572
  ClientWidth = 1018
  Color = clWindow
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object AdvOfficeStatusBar1: TAdvOfficeStatusBar
    Left = 0
    Top = 553
    Width = 1018
    Height = 19
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
        TimeFormat = 'hh:mm:ss'
        Width = 80
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
        TimeFormat = 'hh:mm:ss'
        Width = 100
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
        TimeFormat = 'hh:mm:ss'
        Width = 130
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
        TimeFormat = 'hh:mm:ss'
        Width = 50
      end>
    ShowSplitter = True
    SimplePanel = False
    Styler = dm_Styles.AdvOfficeStatusBarOfficeStyler1
    Version = '1.5.2.2'
  end
  object vst_Grid1: TVirtualStringTree
    Left = 200
    Top = 0
    Width = 818
    Height = 513
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
    OnGetText = vst_Grid1GetText
    ExplicitTop = -1
    Columns = <
      item
        Alignment = taRightJustify
        CaptionAlignment = taCenter
        Color = 15000804
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coFixed, coAllowFocus, coUseCaptionAlignment]
        Position = 0
        Width = 75
        WideText = 'Id'
      end
      item
        Position = 1
        Width = 325
        WideText = 'Chave de acesso'
      end
      item
        Alignment = taCenter
        Position = 2
        Width = 70
        WideText = 'Tip.Emit'
      end
      item
        Alignment = taCenter
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
        Position = 3
        Width = 75
        WideText = 'Num.Doc'
      end
      item
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
        Position = 4
        Width = 200
        WideText = 'Situa'#231#227'o'
      end
      item
        Alignment = taCenter
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
        Position = 5
        Width = 121
        WideText = 'Dt. Emiss'#227'o'
      end
      item
        Alignment = taCenter
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
        Position = 6
        Width = 90
        WideText = 'Tp. Emiss'#227'o'
      end
      item
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
        Position = 7
        Width = 55
        WideText = 'UF Ini'
      end
      item
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
        Position = 8
        Width = 55
        WideText = 'UF Fim'
      end
      item
        Alignment = taRightJustify
        CaptionAlignment = taCenter
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment]
        Position = 9
        Width = 90
        WideText = 'Qtd NFe'
      end
      item
        Alignment = taRightJustify
        CaptionAlignment = taCenter
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment]
        Position = 10
        Width = 90
        WideText = 'Valor Carga'
      end
      item
        Alignment = taRightJustify
        CaptionAlignment = taCenter
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment]
        Position = 11
        Width = 90
        WideText = 'Unid Medida'
      end
      item
        Alignment = taRightJustify
        CaptionAlignment = taCenter
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment]
        Position = 12
        Width = 90
        WideText = 'Peso Bruto'
      end>
  end
  object pnl_Filter: TAdvPanel
    Left = 0
    Top = 0
    Width = 200
    Height = 513
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
    DesignSize = (
      198
      511)
    FullHeight = 485
    object gbx_DtEmis: TAdvGroupBox
      Left = 5
      Top = 68
      Width = 188
      Height = 77
      RoundEdges = True
      Align = alTop
      Caption = ' Data de emiss'#227'o '
      TabOrder = 1
      object edt_DatIni: TJvDateEdit
        Left = 75
        Top = 20
        Width = 100
        Height = 22
        ShowNullDate = False
        TabOrder = 0
        DisabledColor = clSilver
      end
      object edt_DatFin: TJvDateEdit
        Left = 75
        Top = 44
        Width = 100
        Height = 22
        ShowNullDate = False
        TabOrder = 1
        DisabledColor = clSilver
      end
    end
    object rgx_Status: TAdvOfficeRadioGroup
      Left = 5
      Top = 145
      Width = 188
      Height = 171
      RoundEdges = True
      Version = '1.3.7.0'
      Align = alTop
      Caption = ' Situa'#231#227'o '
      ParentBackground = False
      TabOrder = 2
      ItemIndex = 5
      Items.Strings = (
        'Pronto para envio;'
        'Conting'#234'ncia;'
        'Processadas;'
        'Canceladas;'
        'Erros;'
        'Todos.')
      ButtonVertAlign = tlCenter
      Ellipsis = False
    end
    object btn_Find: TJvImgBtn
      Left = 103
      Top = 476
      Width = 90
      Height = 30
      Anchors = [akRight, akBottom]
      Caption = 'Buscar'
      TabOrder = 4
      OnClick = btn_FindClick
    end
    object gbx_Ident: TAdvGroupBox
      Left = 5
      Top = 18
      Width = 188
      Height = 50
      RoundEdges = True
      Align = alTop
      Caption = ' N'#250'mero do manifesto '
      TabOrder = 0
      object edt_CodSeq: TAdvEdit
        Left = 75
        Top = 22
        Width = 100
        Height = 22
        EditAlign = eaCenter
        EditType = etNumeric
        EmptyTextStyle = []
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
        TabOrder = 0
        Text = '0'
        Visible = True
        Version = '3.3.2.0'
      end
    end
    object chk_ChvNFe: TAdvOfficeCheckBox
      Left = 5
      Top = 316
      Width = 188
      Height = 20
      Align = alTop
      Checked = True
      TabOrder = 3
      TabStop = True
      Alignment = taLeftJustify
      Caption = 'Mostrar chave da NFe'
      ReturnIsTab = False
      State = cbChecked
      Themed = True
      Version = '1.3.7.0'
    end
  end
  object pnl_Footer: TJvFooter
    Left = 0
    Top = 513
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
    object btn_Filter: TJvFooterBtn
      Left = 112
      Top = 5
      Width = 90
      Height = 30
      Hint = 'Mostra/Esconde o Filtro'
      Anchors = [akLeft, akBottom]
      Caption = 'Filtro'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = btn_FilterClick
      Alignment = taLeftJustify
      ButtonIndex = 1
      SpaceInterval = 6
    end
    object btn_Cons: TJvFooterBtn
      Left = 208
      Top = 5
      Width = 90
      Height = 30
      Hint = 'Consulta status do servi'#231'o'
      Anchors = [akLeft, akBottom]
      Caption = 'Consultar'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      OnClick = btn_ConsClick
      Alignment = taLeftJustify
      ButtonIndex = 2
      SpaceInterval = 6
    end
    object btn_Close: TJvFooterBtn
      Left = 910
      Top = 5
      Width = 100
      Height = 30
      Anchors = [akRight, akBottom]
      Caption = 'Fechar'
      TabOrder = 0
      OnClick = btn_CloseClick
      ButtonIndex = 3
      SpaceInterval = 6
    end
    object btn_New: TJvFooterBtn
      Left = 304
      Top = 5
      Width = 90
      Height = 30
      Anchors = [akLeft, akBottom]
      Caption = 'Novo'
      ParentShowHint = False
      ShowHint = False
      TabOrder = 5
      OnClick = btn_NewClick
      Alignment = taLeftJustify
      ButtonIndex = 4
      SpaceInterval = 6
    end
    object btn_Edit: TJvFooterBtn
      Left = 400
      Top = 5
      Width = 90
      Height = 30
      Anchors = [akLeft, akBottom]
      Caption = 'Alterar'
      ParentShowHint = False
      ShowHint = False
      TabOrder = 4
      OnClick = btn_EditClick
      Alignment = taLeftJustify
      ButtonIndex = 5
      SpaceInterval = 6
    end
    object btn_Detalh: TJvFooterBtn
      Left = 496
      Top = 5
      Width = 90
      Height = 30
      Anchors = [akLeft, akBottom]
      Caption = 'Notas Fiscais'
      TabOrder = 8
      OnClick = btn_DetalhClick
      Alignment = taLeftJustify
      ButtonIndex = 6
      SpaceInterval = 6
    end
    object btn_Send: TJvFooterBtn
      Left = 592
      Top = 5
      Width = 90
      Height = 30
      Hint = 'Autoriza Nota Fiscal'
      Anchors = [akLeft, akBottom]
      Caption = 'Enviar'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = btn_SendClick
      Alignment = taLeftJustify
      ButtonIndex = 7
      SpaceInterval = 6
    end
    object btn_Canc: TJvFooterBtn
      Left = 688
      Top = 5
      Width = 90
      Height = 30
      Anchors = [akLeft, akBottom]
      Caption = 'Cancelar'
      TabOrder = 7
      Alignment = taLeftJustify
      ButtonIndex = 8
      SpaceInterval = 6
    end
  end
  object ActionList1: TActionList
    Left = 408
    Top = 328
    object act_ConsStt: TAction
      Caption = 'Consultar Servi'#231'o'
      Hint = 'Consultar status do servi'#231'o'
    end
    object act_ConsProt: TAction
      Caption = 'Consular Protocolo'
      Hint = 'Consular Protocolo'
      OnExecute = act_ConsProtExecute
    end
  end
end
