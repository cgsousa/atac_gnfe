object frm_Manifesto: Tfrm_Manifesto
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Lan'#231'amentos de MDF-e'
  ClientHeight = 612
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
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object AdvOfficeStatusBar1: TAdvOfficeStatusBar
    Left = 0
    Top = 593
    Width = 794
    Height = 19
    AnchorHint = False
    Panels = <
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
        Text = '<b>Consulta</b>'
        TimeFormat = 'hh:mm:ss'
        Width = 75
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
        Text = '<b>F2</b> Filtro'
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
        Text = '<b>999</b> Notas fiscais encontradas'
        TimeFormat = 'hh:mm:ss'
        Width = 200
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
        Progress.Stacked = False
        Style = psProgress
        TimeFormat = 'hh:mm:ss'
        Width = 250
      end>
    ShowSplitter = True
    SimplePanel = False
    Styler = dm_Styles.AdvOfficeStatusBarOfficeStyler1
    Version = '1.5.2.2'
  end
  object pag_Control00: TAdvPageControl
    Left = 0
    Top = 0
    Width = 794
    Height = 553
    ActivePage = tab_Manifesto
    ActiveFont.Charset = DEFAULT_CHARSET
    ActiveFont.Color = clWindowText
    ActiveFont.Height = -11
    ActiveFont.Name = 'Tahoma'
    ActiveFont.Style = []
    Align = alClient
    DefaultTabColor = clInactiveCaption
    ActiveColor = clGradientActiveCaption
    ActiveColorTo = clGradientInactiveCaption
    TabBackGroundColor = clBtnFace
    TabMargin.RightMargin = 0
    TabOverlap = 0
    TabStyle = tsDotNet
    Version = '2.0.0.4'
    PersistPagesState.Location = plRegistry
    PersistPagesState.Enabled = False
    TabOrder = 1
    TabWidth = 250
    OnChange = pag_Control00Change
    object tab_Browse: TAdvTabSheet
      Caption = 'Busca de NFE para vincular ao Manifesto'
      Color = clWindow
      ColorTo = clNone
      TabColor = clInactiveCaption
      TabColorTo = clNone
      object vst_Grid1: TVirtualStringTree
        Left = 241
        Top = 0
        Width = 545
        Height = 524
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
        TabOrder = 0
        TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScroll, toAutoTristateTracking]
        TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toInitOnSave, toToggleOnDblClick, toWheelPanning]
        TreeOptions.PaintOptions = [toHotTrack, toShowDropmark, toShowHorzGridLines, toShowVertGridLines, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toDisableDrawSelection, toExtendedFocus, toFullRowSelect, toMiddleClickSelect, toRightClickSelect, toCenterScrollIntoView]
        OnChecked = vst_Grid1Checked
        OnGetText = vst_Grid1GetText
        OnPaintText = vst_Grid1PaintText
        OnHeaderClick = vst_Grid1HeaderClick
        Columns = <
          item
            CheckBox = True
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
            Position = 5
            Width = 121
            WideText = 'Dt. Emiss'#227'o'
          end
          item
            Alignment = taRightJustify
            CaptionAlignment = taCenter
            Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment]
            Position = 6
            Width = 90
            WideText = 'Total da NF'
          end
          item
            Alignment = taRightJustify
            CaptionAlignment = taCenter
            Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment]
            Position = 7
            Width = 90
            WideText = 'Peso Bruto'
          end>
      end
      object pnl_Filter: TAdvPanel
        Left = 0
        Top = 0
        Width = 241
        Height = 524
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
        TabOrder = 1
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
          239
          522)
        FullHeight = 485
        object gbx_DtEmis: TAdvGroupBox
          Left = 5
          Top = 123
          Width = 229
          Height = 110
          RoundEdges = True
          Align = alTop
          Caption = ' Data de emiss'#227'o '
          TabOrder = 1
          object Label1: TLabel
            Left = 81
            Top = 18
            Width = 32
            Height = 16
            AutoSize = False
            Caption = 'De: '
          end
          object Label2: TLabel
            Left = 81
            Top = 62
            Width = 32
            Height = 16
            AutoSize = False
            Caption = 'At'#233': '
          end
          object edt_DatIni: TJvDateEdit
            Left = 81
            Top = 34
            Width = 100
            Height = 22
            ShowNullDate = False
            TabOrder = 0
            DisabledColor = clSilver
          end
          object edt_DatFin: TJvDateEdit
            Left = 81
            Top = 78
            Width = 100
            Height = 22
            ShowNullDate = False
            TabOrder = 1
            DisabledColor = clSilver
          end
        end
        object btn_Find: TJvImgBtn
          Left = 132
          Top = 479
          Width = 100
          Height = 30
          Anchors = [akRight, akBottom]
          Caption = 'Buscar'
          TabOrder = 2
          OnClick = btn_FindClick
        end
        object gbx_CodPed: TAdvGroupBox
          Left = 5
          Top = 18
          Width = 229
          Height = 105
          RoundEdges = True
          Align = alTop
          Caption = ' N'#250'mero do Pedido (Venda) '
          TabOrder = 0
          object edt_PedIni: TAdvEdit
            Left = 81
            Top = 31
            Width = 121
            Height = 22
            EditAlign = eaCenter
            EditType = etNumeric
            EmptyTextStyle = []
            LabelCaption = 'De:'
            LabelPosition = lpTopLeft
            LabelMargin = 1
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
          object edt_PedFin: TAdvEdit
            Left = 81
            Top = 71
            Width = 121
            Height = 22
            EditAlign = eaCenter
            EditType = etNumeric
            EmptyTextStyle = []
            LabelCaption = 'At'#233':'
            LabelPosition = lpTopLeft
            LabelMargin = 1
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
    end
    object tab_Manifesto: TAdvTabSheet
      Caption = 'Manifesto'
      Color = clWindow
      ColorTo = clNone
      TabColor = clInactiveCaption
      TabColorTo = clNone
      object gbx_Ident: TAdvGroupBox
        Left = 0
        Top = 0
        Width = 786
        Height = 70
        Align = alTop
        Caption = ' Identifica'#231#227'o  '
        TabOrder = 0
        object cbx_mdfTpEmit: TAdvComboBox
          Left = 139
          Top = 17
          Width = 350
          Height = 22
          Color = clWindow
          Version = '1.5.1.0'
          Visible = True
          Style = csDropDownList
          EmptyTextStyle = []
          DropWidth = 0
          Enabled = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = []
          ItemIndex = -1
          LabelCaption = 'Tipo do emitente:'
          LabelMargin = 2
          LabelTransparent = True
          LabelFont.Charset = DEFAULT_CHARSET
          LabelFont.Color = clNavy
          LabelFont.Height = -11
          LabelFont.Name = 'Tahoma'
          LabelFont.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object cbx_mdfTpTrasp: TAdvComboBox
          Left = 139
          Top = 42
          Width = 121
          Height = 22
          Color = clWindow
          Version = '1.5.1.0'
          Visible = True
          Style = csDropDownList
          EmptyTextStyle = []
          DropWidth = 0
          Enabled = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = []
          ItemIndex = -1
          LabelCaption = 'Tipo do trasportador:'
          LabelMargin = 2
          LabelTransparent = True
          LabelFont.Charset = DEFAULT_CHARSET
          LabelFont.Color = clNavy
          LabelFont.Height = -11
          LabelFont.Name = 'Tahoma'
          LabelFont.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object edt_mdfNumDoc: TAdvEdit
          Left = 645
          Top = 15
          Width = 130
          Height = 20
          TabStop = False
          EditAlign = eaCenter
          EditType = etNumeric
          EmptyTextStyle = []
          LabelCaption = 'N'#250'mero do manifesto:'
          LabelMargin = 2
          LabelFont.Charset = DEFAULT_CHARSET
          LabelFont.Color = clNavy
          LabelFont.Height = -11
          LabelFont.Name = 'Tahoma'
          LabelFont.Style = []
          Lookup.Font.Charset = DEFAULT_CHARSET
          Lookup.Font.Color = clWindowText
          Lookup.Font.Height = -11
          Lookup.Font.Name = 'Arial'
          Lookup.Font.Style = []
          Lookup.Separator = ';'
          Color = clGradientInactiveCaption
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
          Text = '0'
          Visible = True
          Version = '3.3.2.0'
        end
        object edt_mdfDtEmis: TAdvEdit
          Left = 645
          Top = 41
          Width = 130
          Height = 20
          TabStop = False
          EditAlign = eaCenter
          EmptyTextStyle = []
          LabelCaption = 'Data/Hora emiss'#227'o:'
          LabelMargin = 2
          LabelFont.Charset = DEFAULT_CHARSET
          LabelFont.Color = clNavy
          LabelFont.Height = -11
          LabelFont.Name = 'Tahoma'
          LabelFont.Style = []
          Lookup.Font.Charset = DEFAULT_CHARSET
          Lookup.Font.Color = clWindowText
          Lookup.Font.Height = -11
          Lookup.Font.Name = 'Arial'
          Lookup.Font.Style = []
          Lookup.Separator = ';'
          Color = clGradientInactiveCaption
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
          Text = '00/00/0000 00:00'
          Visible = True
          Version = '3.3.2.0'
        end
        object cbx_CodUnd: TAdvComboBox
          Left = 389
          Top = 42
          Width = 100
          Height = 22
          Color = clWindow
          Version = '1.5.1.0'
          Visible = True
          Style = csDropDownList
          EmptyTextStyle = []
          DropWidth = 0
          Enabled = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = []
          ItemIndex = -1
          LabelCaption = 'Unidade de Medida:'
          LabelMargin = 2
          LabelTransparent = True
          LabelFont.Charset = DEFAULT_CHARSET
          LabelFont.Color = clNavy
          LabelFont.Height = -11
          LabelFont.Name = 'Tahoma'
          LabelFont.Style = []
          ParentFont = False
          TabOrder = 2
        end
      end
      object pag_Control01: TAdvPageControl
        Left = 0
        Top = 70
        Width = 786
        Height = 454
        ActivePage = tab_Mun
        ActiveFont.Charset = DEFAULT_CHARSET
        ActiveFont.Color = clWindowText
        ActiveFont.Height = -11
        ActiveFont.Name = 'Tahoma'
        ActiveFont.Style = []
        Align = alClient
        DefaultTabColor = clInactiveCaption
        ActiveColor = clGradientActiveCaption
        ActiveColorTo = clGradientInactiveCaption
        TabBackGroundColor = clBtnFace
        TabMargin.RightMargin = 0
        TabOverlap = 0
        TabStyle = tsDotNet
        Version = '2.0.0.4'
        PersistPagesState.Location = plRegistry
        PersistPagesState.Enabled = False
        TabOrder = 1
        TabWidth = 275
        object tab_Mun: TAdvTabSheet
          Caption = 'Munic'#237'pios de Carregamento/Descarregamento'
          Color = clWindow
          ColorTo = clNone
          Highlighted = True
          TabColor = clInactiveCaption
          TabColorTo = clNone
          object vst_GridMun: TVirtualStringTree
            Left = 0
            Top = 0
            Width = 646
            Height = 425
            Align = alLeft
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
            Header.AutoSizeIndex = -1
            Header.Background = clBtnShadow
            Header.Height = 21
            Header.Options = [hoColumnResize, hoDrag, hoShowImages, hoShowSortGlyphs, hoVisible]
            Header.ParentFont = True
            Header.Style = hsPlates
            ParentFont = False
            RootNodeCount = 25
            TabOrder = 0
            TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScroll, toAutoTristateTracking]
            TreeOptions.MiscOptions = [toAcceptOLEDrop, toInitOnSave, toToggleOnDblClick, toWheelPanning]
            TreeOptions.PaintOptions = [toHotTrack, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowTreeLines, toShowVertGridLines, toUseBlendedImages]
            TreeOptions.SelectionOptions = [toDisableDrawSelection, toExtendedFocus, toFullRowSelect, toMiddleClickSelect, toRightClickSelect, toCenterScrollIntoView]
            OnBeforeItemErase = vst_GridMunBeforeItemErase
            OnChange = vst_GridMunChange
            OnGetText = vst_GridMunGetText
            OnPaintText = vst_GridMunPaintText
            Columns = <
              item
                Color = clWindow
                Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
                Position = 0
                Width = 380
                WideText = 'Munic'#237'pio /Notas Fiscais'
              end
              item
                Alignment = taRightJustify
                CaptionAlignment = taCenter
                Color = clWindow
                Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment]
                Position = 1
                Width = 75
                WideText = 'Qtd NFE'
              end
              item
                Alignment = taRightJustify
                CaptionAlignment = taCenter
                Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment]
                Position = 2
                Width = 90
                WideText = 'Val. Total'
              end
              item
                Alignment = taRightJustify
                CaptionAlignment = taCenter
                Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment]
                Position = 3
                Width = 75
                WideText = 'Peso Bruto'
              end>
          end
          object btn_Desvinc: TJvImgBtn
            Left = 652
            Top = 0
            Width = 90
            Height = 30
            Hint = 'Desvincula NFE do manifesto'
            Caption = 'Desvincular'
            ParentShowHint = False
            ShowHint = False
            TabOrder = 1
            OnClick = btn_DesvincClick
          end
        end
        object tab_Rodo: TAdvTabSheet
          Caption = 'Ve'#237'culo /Condutores'
          Color = clWindow
          ColorTo = clNone
          Highlighted = True
          TabColor = clInactiveCaption
          TabColorTo = clNone
          object GradientLabel1: TGradientLabel
            Left = 0
            Top = 0
            Width = 778
            Height = 17
            Align = alTop
            AutoSize = False
            Caption = 'Selecione na grade, um Ve'#237'culo com tra'#231#227'o '
            ColorTo = 15590880
            EllipsType = etNone
            GradientType = gtFullHorizontal
            GradientDirection = gdLeftToRight
            Indent = 0
            Orientation = goHorizontal
            TransparentText = False
            VAlignment = vaTop
            Version = '1.2.0.0'
            ExplicitTop = -7
          end
          object pnl_Condutor: TAdvPanel
            Left = 0
            Top = 195
            Width = 778
            Height = 230
            Align = alBottom
            BevelOuter = bvNone
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            UseDockManager = True
            Version = '2.3.0.0'
            BorderColor = 13815240
            Caption.Color = clWhite
            Caption.ColorTo = 15590880
            Caption.Font.Charset = DEFAULT_CHARSET
            Caption.Font.Color = 5978398
            Caption.Font.Height = -11
            Caption.Font.Name = 'Tahoma'
            Caption.Font.Style = []
            Caption.GradientDirection = gdVertical
            Caption.Indent = 4
            Caption.ShadeLight = 255
            Caption.Text = ' Informa'#231#245'es do(s) Condutor(s) do ve'#237'culo '
            Caption.Visible = True
            CollapsColor = clNone
            CollapsDelay = 0
            ColorTo = 15590880
            ShadowColor = clBlack
            ShadowOffset = 0
            StatusBar.BorderColor = 16249840
            StatusBar.BorderStyle = bsSingle
            StatusBar.Font.Charset = DEFAULT_CHARSET
            StatusBar.Font.Color = 5978398
            StatusBar.Font.Height = -11
            StatusBar.Font.Name = 'Tahoma'
            StatusBar.Font.Style = []
            StatusBar.Color = clWhite
            StatusBar.ColorTo = 15590880
            StatusBar.GradientDirection = gdVertical
            StatusBar.Visible = True
            Styler = dm_Styles.AdvPanelStyler1
            FullHeight = 200
            object vst_GridCdtVinc: TVirtualStringTree
              Left = 433
              Top = 18
              Width = 345
              Height = 194
              Align = alRight
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
              Header.AutoSizeIndex = -1
              Header.Background = clBtnHighlight
              Header.Height = 21
              Header.Options = [hoColumnResize, hoDrag, hoShowImages, hoShowSortGlyphs, hoVisible]
              Header.ParentFont = True
              Header.Style = hsPlates
              ParentFont = False
              RootNodeCount = 10
              TabOrder = 0
              TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScroll, toAutoTristateTracking]
              TreeOptions.MiscOptions = [toAcceptOLEDrop, toInitOnSave, toToggleOnDblClick, toWheelPanning]
              TreeOptions.PaintOptions = [toHotTrack, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowTreeLines, toShowVertGridLines, toUseBlendedImages]
              TreeOptions.SelectionOptions = [toDisableDrawSelection, toExtendedFocus, toFullRowSelect, toMiddleClickSelect, toRightClickSelect, toCenterScrollIntoView]
              OnGetText = vst_GridCdtVincGetText
              Columns = <
                item
                  Color = clWindow
                  Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
                  Position = 0
                  Width = 315
                  WideText = 'Condutores vinculados'
                end>
            end
            object vst_GridCdtCad: TVirtualStringTree
              Left = 0
              Top = 18
              Width = 345
              Height = 194
              Align = alLeft
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
              Header.AutoSizeIndex = -1
              Header.Background = clBtnHighlight
              Header.Height = 21
              Header.Options = [hoColumnResize, hoDrag, hoShowImages, hoShowSortGlyphs, hoVisible]
              Header.ParentFont = True
              Header.Style = hsPlates
              ParentFont = False
              RootNodeCount = 10
              TabOrder = 1
              TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScroll, toAutoTristateTracking]
              TreeOptions.MiscOptions = [toAcceptOLEDrop, toInitOnSave, toToggleOnDblClick, toWheelPanning]
              TreeOptions.PaintOptions = [toHotTrack, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowTreeLines, toShowVertGridLines, toUseBlendedImages]
              TreeOptions.SelectionOptions = [toDisableDrawSelection, toExtendedFocus, toFullRowSelect, toMiddleClickSelect, toRightClickSelect, toCenterScrollIntoView]
              OnGetText = vst_GridCdtCadGetText
              Columns = <
                item
                  Color = clWindow
                  Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
                  Position = 0
                  Width = 315
                  WideText = 'Cadastro de condutores'
                end>
            end
            object btn_CdtCad: TJvImgBtn
              Left = 352
              Top = 178
              Width = 75
              Height = 30
              Caption = 'Cadastro'
              TabOrder = 2
              OnClick = btn_CdtCadClick
              HotTrackFont.Charset = DEFAULT_CHARSET
              HotTrackFont.Color = clWindowText
              HotTrackFont.Height = -11
              HotTrackFont.Name = 'Tahoma'
              HotTrackFont.Style = []
            end
            object btn_CdtAdd: TJvImgBtn
              Left = 352
              Top = 24
              Width = 75
              Height = 30
              Caption = '>>'
              TabOrder = 3
              OnClick = btn_CdtAddClick
              HotTrackFont.Charset = DEFAULT_CHARSET
              HotTrackFont.Color = clWindowText
              HotTrackFont.Height = -11
              HotTrackFont.Name = 'Tahoma'
              HotTrackFont.Style = []
            end
            object btn_CdtRmv: TJvImgBtn
              Left = 352
              Top = 60
              Width = 75
              Height = 30
              Caption = '<<'
              TabOrder = 4
              OnClick = btn_CdtRmvClick
              HotTrackFont.Charset = DEFAULT_CHARSET
              HotTrackFont.Color = clWindowText
              HotTrackFont.Height = -11
              HotTrackFont.Name = 'Tahoma'
              HotTrackFont.Style = []
            end
          end
          object vst_GridCadVei: TVirtualStringTree
            Left = 0
            Top = 17
            Width = 778
            Height = 136
            Align = alTop
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
            Header.AutoSizeIndex = -1
            Header.Background = clBtnHighlight
            Header.Height = 21
            Header.Options = [hoColumnResize, hoDrag, hoShowImages, hoShowSortGlyphs, hoVisible]
            Header.ParentFont = True
            Header.Style = hsPlates
            ParentFont = False
            RootNodeCount = 10
            TabOrder = 1
            TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScroll, toAutoTristateTracking]
            TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toInitOnSave, toToggleOnDblClick, toWheelPanning]
            TreeOptions.PaintOptions = [toHotTrack, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowTreeLines, toShowVertGridLines, toUseBlendedImages]
            TreeOptions.SelectionOptions = [toDisableDrawSelection, toExtendedFocus, toFullRowSelect, toMiddleClickSelect, toRightClickSelect, toCenterScrollIntoView]
            OnGetText = vst_GridCadVeiGetText
            Columns = <
              item
                Alignment = taCenter
                Position = 0
                Width = 75
                WideText = 'Id'
              end
              item
                Position = 1
                Width = 90
                WideText = 'Placa'
              end
              item
                Position = 2
                Width = 90
                WideText = 'Tara em KG'
              end
              item
                Position = 3
                Width = 90
                WideText = 'Cap. em KG'
              end
              item
                Position = 4
                Width = 90
                WideText = 'Cap. em M3'
              end
              item
                Position = 5
                Width = 90
                WideText = 'Tipo Rodado'
              end
              item
                Position = 6
                Width = 110
                WideText = 'Tipo Carroceria'
              end
              item
                Alignment = taCenter
                Position = 7
                WideText = 'UF'
              end>
          end
          object btn_CadVei: TJvImgBtn
            Left = 688
            Top = 159
            Width = 90
            Height = 30
            Caption = 'Cadastro'
            TabOrder = 2
            OnClick = btn_CadVeiClick
          end
        end
      end
    end
  end
  object pnl_Footer: TJvFooter
    Left = 0
    Top = 553
    Width = 794
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
      794
      40)
    object btn_Filter: TJvFooterBtn
      Left = 8
      Top = 5
      Width = 90
      Height = 30
      Hint = 'Mostra/Esconde o Filtro'
      Anchors = [akLeft, akBottom]
      Caption = 'Filtro'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = btn_FilterClick
      Alignment = taLeftJustify
      ButtonIndex = 0
      SpaceInterval = 6
    end
    object btn_Close: TJvFooterBtn
      Left = 696
      Top = 5
      Width = 90
      Height = 30
      Anchors = [akRight, akBottom]
      Caption = 'Fechar'
      TabOrder = 0
      OnClick = btn_CloseClick
      ButtonIndex = 1
      SpaceInterval = 6
    end
    object btn_Vincula: TJvFooterBtn
      Left = 102
      Top = 5
      Width = 90
      Height = 30
      Anchors = [akLeft, akBottom]
      Caption = 'Vincular'
      ParentShowHint = False
      ShowHint = False
      TabOrder = 2
      OnClick = btn_VinculaClick
      Alignment = taLeftJustify
      ButtonIndex = 2
      SpaceInterval = 6
    end
    object btn_Save: TJvFooterBtn
      Left = 198
      Top = 5
      Width = 90
      Height = 30
      Anchors = [akLeft, akBottom]
      Caption = 'Gravar'
      TabOrder = 3
      OnClick = btn_SaveClick
      Alignment = taLeftJustify
      ButtonIndex = 3
      SpaceInterval = 6
    end
  end
end
