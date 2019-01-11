object frm_ManifestoList: Tfrm_ManifestoList
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'frm_ManifestoList'
  ClientHeight = 572
  ClientWidth = 794
  Color = clWindow
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object AdvDockPanel1: TAdvDockPanel
    Left = 0
    Top = 0
    Width = 794
    Height = 44
    MinimumSize = 3
    LockHeight = False
    Persistence.Location = plRegistry
    Persistence.Enabled = False
    ToolBarStyler = dm_Styles.AdvToolBarOfficeStyler1
    UseRunTimeHeight = False
    Version = '6.0.2.1'
    object AdvToolBar1: TAdvToolBar
      Left = 3
      Top = 1
      Width = 368
      Height = 29
      AllowFloating = False
      Caption = 'Untitled'
      CaptionFont.Charset = DEFAULT_CHARSET
      CaptionFont.Color = clWindowText
      CaptionFont.Height = -11
      CaptionFont.Name = 'Tahoma'
      CaptionFont.Style = []
      CompactImageIndex = -1
      TextAutoOptionMenu = 'Add or Remove Buttons'
      TextOptionMenu = 'Options'
      ToolBarStyler = dm_Styles.AdvToolBarOfficeStyler1
      ParentOptionPicture = True
      ToolBarIndex = -1
      object AdvToolBarSeparator1: TAdvToolBarSeparator
        Left = 109
        Top = 2
        Width = 10
        Height = 23
        LineColor = clBtnShadow
      end
      object AdvToolBarSeparator2: TAdvToolBarSeparator
        Left = 194
        Top = 2
        Width = 10
        Height = 23
        LineColor = clBtnShadow
      end
      object btn_Config: TAdvGlowButton
        Left = 9
        Top = 2
        Width = 100
        Height = 25
        Caption = 'Configura'#231#245'es'
        FocusType = ftHot
        NotesFont.Charset = DEFAULT_CHARSET
        NotesFont.Color = clWindowText
        NotesFont.Height = -11
        NotesFont.Name = 'Tahoma'
        NotesFont.Style = []
        TabOrder = 0
        Appearance.BorderColor = 14727579
        Appearance.BorderColorHot = 10079963
        Appearance.BorderColorDown = 4548219
        Appearance.BorderColorChecked = clBlack
        Appearance.Color = 15653832
        Appearance.ColorTo = 16178633
        Appearance.ColorChecked = 11918331
        Appearance.ColorCheckedTo = 7915518
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = 15921906
        Appearance.ColorDown = 7778289
        Appearance.ColorDownTo = 4296947
        Appearance.ColorHot = 15465983
        Appearance.ColorHotTo = 11332863
        Appearance.ColorMirror = 15586496
        Appearance.ColorMirrorTo = 16245200
        Appearance.ColorMirrorHot = 5888767
        Appearance.ColorMirrorHotTo = 10807807
        Appearance.ColorMirrorDown = 946929
        Appearance.ColorMirrorDownTo = 5021693
        Appearance.ColorMirrorChecked = 10480637
        Appearance.ColorMirrorCheckedTo = 5682430
        Appearance.ColorMirrorDisabled = 11974326
        Appearance.ColorMirrorDisabledTo = 15921906
        Appearance.GradientHot = ggVertical
        Appearance.GradientMirrorHot = ggVertical
        Appearance.GradientDown = ggVertical
        Appearance.GradientMirrorDown = ggVertical
        Appearance.GradientChecked = ggVertical
      end
      object btn_Filter: TAdvGlowButton
        Left = 119
        Top = 2
        Width = 75
        Height = 25
        Caption = 'Filtro'
        FocusType = ftHot
        NotesFont.Charset = DEFAULT_CHARSET
        NotesFont.Color = clWindowText
        NotesFont.Height = -11
        NotesFont.Name = 'Tahoma'
        NotesFont.Style = []
        TabOrder = 1
        OnClick = btn_FilterClick
        Appearance.BorderColor = 14727579
        Appearance.BorderColorHot = 10079963
        Appearance.BorderColorDown = 4548219
        Appearance.BorderColorChecked = clBlack
        Appearance.Color = 15653832
        Appearance.ColorTo = 16178633
        Appearance.ColorChecked = 11918331
        Appearance.ColorCheckedTo = 7915518
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = 15921906
        Appearance.ColorDown = 7778289
        Appearance.ColorDownTo = 4296947
        Appearance.ColorHot = 15465983
        Appearance.ColorHotTo = 11332863
        Appearance.ColorMirror = 15586496
        Appearance.ColorMirrorTo = 16245200
        Appearance.ColorMirrorHot = 5888767
        Appearance.ColorMirrorHotTo = 10807807
        Appearance.ColorMirrorDown = 946929
        Appearance.ColorMirrorDownTo = 5021693
        Appearance.ColorMirrorChecked = 10480637
        Appearance.ColorMirrorCheckedTo = 5682430
        Appearance.ColorMirrorDisabled = 11974326
        Appearance.ColorMirrorDisabledTo = 15921906
        Appearance.GradientHot = ggVertical
        Appearance.GradientMirrorHot = ggVertical
        Appearance.GradientDown = ggVertical
        Appearance.GradientMirrorDown = ggVertical
        Appearance.GradientChecked = ggVertical
      end
      object btn_New: TAdvGlowButton
        Left = 204
        Top = 2
        Width = 75
        Height = 25
        Caption = 'Novo'
        FocusType = ftHot
        NotesFont.Charset = DEFAULT_CHARSET
        NotesFont.Color = clWindowText
        NotesFont.Height = -11
        NotesFont.Name = 'Tahoma'
        NotesFont.Style = []
        TabOrder = 2
        OnClick = btn_NewClick
        Appearance.BorderColor = 14727579
        Appearance.BorderColorHot = 10079963
        Appearance.BorderColorDown = 4548219
        Appearance.BorderColorChecked = clBlack
        Appearance.Color = 15653832
        Appearance.ColorTo = 16178633
        Appearance.ColorChecked = 11918331
        Appearance.ColorCheckedTo = 7915518
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = 15921906
        Appearance.ColorDown = 7778289
        Appearance.ColorDownTo = 4296947
        Appearance.ColorHot = 15465983
        Appearance.ColorHotTo = 11332863
        Appearance.ColorMirror = 15586496
        Appearance.ColorMirrorTo = 16245200
        Appearance.ColorMirrorHot = 5888767
        Appearance.ColorMirrorHotTo = 10807807
        Appearance.ColorMirrorDown = 946929
        Appearance.ColorMirrorDownTo = 5021693
        Appearance.ColorMirrorChecked = 10480637
        Appearance.ColorMirrorCheckedTo = 5682430
        Appearance.ColorMirrorDisabled = 11974326
        Appearance.ColorMirrorDisabledTo = 15921906
        Appearance.GradientHot = ggVertical
        Appearance.GradientMirrorHot = ggVertical
        Appearance.GradientDown = ggVertical
        Appearance.GradientMirrorDown = ggVertical
        Appearance.GradientChecked = ggVertical
      end
      object btn_Edit: TAdvGlowButton
        Left = 279
        Top = 2
        Width = 75
        Height = 25
        Caption = 'Editar'
        FocusType = ftHot
        NotesFont.Charset = DEFAULT_CHARSET
        NotesFont.Color = clWindowText
        NotesFont.Height = -11
        NotesFont.Name = 'Tahoma'
        NotesFont.Style = []
        TabOrder = 3
        OnClick = btn_EditClick
        Appearance.BorderColor = 14727579
        Appearance.BorderColorHot = 10079963
        Appearance.BorderColorDown = 4548219
        Appearance.BorderColorChecked = clBlack
        Appearance.Color = 15653832
        Appearance.ColorTo = 16178633
        Appearance.ColorChecked = 11918331
        Appearance.ColorCheckedTo = 7915518
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = 15921906
        Appearance.ColorDown = 7778289
        Appearance.ColorDownTo = 4296947
        Appearance.ColorHot = 15465983
        Appearance.ColorHotTo = 11332863
        Appearance.ColorMirror = 15586496
        Appearance.ColorMirrorTo = 16245200
        Appearance.ColorMirrorHot = 5888767
        Appearance.ColorMirrorHotTo = 10807807
        Appearance.ColorMirrorDown = 946929
        Appearance.ColorMirrorDownTo = 5021693
        Appearance.ColorMirrorChecked = 10480637
        Appearance.ColorMirrorCheckedTo = 5682430
        Appearance.ColorMirrorDisabled = 11974326
        Appearance.ColorMirrorDisabledTo = 15921906
        Appearance.GradientHot = ggVertical
        Appearance.GradientMirrorHot = ggVertical
        Appearance.GradientDown = ggVertical
        Appearance.GradientMirrorDown = ggVertical
        Appearance.GradientChecked = ggVertical
      end
    end
  end
  object AdvOfficeStatusBar1: TAdvOfficeStatusBar
    Left = 0
    Top = 553
    Width = 794
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
        Text = 'F2-Busca cadastro'
        TimeFormat = 'hh:mm:ss'
        Width = 121
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
    Left = 0
    Top = 44
    Width = 794
    Height = 509
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
    TabOrder = 2
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScroll, toAutoTristateTracking]
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning]
    TreeOptions.PaintOptions = [toHotTrack, toShowDropmark, toShowHorzGridLines, toShowVertGridLines, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toDisableDrawSelection, toExtendedFocus, toMiddleClickSelect, toRightClickSelect, toCenterScrollIntoView]
    OnChange = vst_Grid1Change
    OnGetText = vst_Grid1GetText
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
        Width = 315
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
    Top = 248
    Width = 295
    Height = 305
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
    TabOrder = 3
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
      303)
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
        Top = 18
        Width = 100
        Height = 22
        ShowNullDate = False
        TabOrder = 0
        DisabledColor = clSilver
      end
      object edt_DatFin: TJvDateEdit
        Left = 174
        Top = 18
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
      Left = 188
      Top = 268
      Width = 100
      Height = 30
      Anchors = [akRight, akBottom]
      Caption = 'Buscar'
      TabOrder = 4
      OnClick = btn_FindClick
    end
    object gbx_Ident: TAdvGroupBox
      Left = 5
      Top = 18
      Width = 283
      Height = 50
      RoundEdges = True
      Align = alTop
      Caption = ' Id do manifesto '
      TabOrder = 0
      object edt_CodSeq: TAdvEdit
        Left = 174
        Top = 18
        Width = 100
        Height = 22
        EditAlign = eaCenter
        EditType = etNumeric
        EmptyTextStyle = []
        LabelCaption = 'Informe um identificador:'
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
      Top = 243
      Width = 283
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
end
