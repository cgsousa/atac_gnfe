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
        Width = 132
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
    ExplicitTop = -1
    object tab_Browse: TAdvTabSheet
      Caption = 'Busca de NFE para vincular ao Manifesto'
      Color = clWindow
      ColorTo = clNone
      TabColor = clInactiveCaption
      TabColorTo = clNone
      object vst_GridNFE: TVirtualStringTree
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
          Height = 105
          RoundEdges = True
          Align = alTop
          Caption = ' Data de emiss'#227'o '
          TabOrder = 1
          object edt_DatIni: TJvDateEdit
            Left = 81
            Top = 32
            Width = 100
            Height = 22
            ShowNullDate = False
            TabOrder = 0
            DisabledColor = clSilver
          end
          object edt_DatFin: TJvDateEdit
            Left = 81
            Top = 68
            Width = 100
            Height = 22
            ShowNullDate = False
            TabOrder = 1
            DisabledColor = clSilver
          end
        end
        object btn_Find: TJvImgBtn
          Left = 128
          Top = 477
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
        Height = 75
        Align = alTop
        Caption = ' Identifica'#231#227'o  '
        TabOrder = 0
        object cbx_mdfTpEmit: TAdvComboBox
          Left = 192
          Top = 16
          Width = 121
          Height = 22
          Color = clWindow
          Version = '1.5.1.0'
          Visible = True
          Style = csDropDownList
          EmptyTextStyle = []
          DropWidth = 0
          Enabled = True
          ItemIndex = -1
          LabelCaption = 'Tipo do emitente:'
          LabelTransparent = True
          LabelFont.Charset = DEFAULT_CHARSET
          LabelFont.Color = clWindowText
          LabelFont.Height = -11
          LabelFont.Name = 'Tahoma'
          LabelFont.Style = []
          TabOrder = 0
        end
        object cbx_mdfTpTrasp: TAdvComboBox
          Left = 192
          Top = 40
          Width = 121
          Height = 22
          Color = clWindow
          Version = '1.5.1.0'
          Visible = True
          Style = csDropDownList
          EmptyTextStyle = []
          DropWidth = 0
          Enabled = True
          ItemIndex = -1
          LabelCaption = 'Tipo do trasportador:'
          LabelTransparent = True
          LabelFont.Charset = DEFAULT_CHARSET
          LabelFont.Color = clWindowText
          LabelFont.Height = -11
          LabelFont.Name = 'Tahoma'
          LabelFont.Style = []
          TabOrder = 1
        end
        object edt_mdfNumDoc: TAdvEdit
          Left = 477
          Top = 16
          Width = 121
          Height = 20
          EditType = etNumeric
          EmptyTextStyle = []
          LabelCaption = 'N'#250'mero do manifesto:'
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
          TabOrder = 2
          Text = '0'
          Visible = True
          Version = '3.3.2.0'
        end
        object edt_mdDtEmis: TAdvEdit
          Left = 477
          Top = 40
          Width = 121
          Height = 20
          EmptyTextStyle = []
          LabelCaption = 'Data/Hora emiss'#227'o:'
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
          TabOrder = 3
          Visible = True
          Version = '3.3.2.0'
        end
      end
      object pag_Control01: TAdvPageControl
        Left = 0
        Top = 75
        Width = 786
        Height = 449
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
          TabColor = clInactiveCaption
          TabColorTo = clNone
          object vst_GridMun: TVirtualStringTree
            Left = 0
            Top = 0
            Width = 646
            Height = 420
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
            RootNodeCount = 25
            TabOrder = 0
            TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScroll, toAutoTristateTracking]
            TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toInitOnSave, toToggleOnDblClick, toWheelPanning]
            TreeOptions.PaintOptions = [toHotTrack, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowTreeLines, toShowVertGridLines, toUseBlendedImages]
            TreeOptions.SelectionOptions = [toDisableDrawSelection, toExtendedFocus, toFullRowSelect, toMiddleClickSelect, toRightClickSelect, toCenterScrollIntoView]
            OnChange = vst_GridMunChange
            OnGetText = vst_GridMunGetText
            ExplicitTop = 2
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
        end
        object tab_Rodo: TAdvTabSheet
          Caption = 'Ve'#237'culo /Condutores'
          Color = clWindow
          ColorTo = clNone
          TabColor = clInactiveCaption
          TabColorTo = clNone
          object edt_VeiCod: TAdvEditBtn
            Left = 121
            Top = 0
            Width = 200
            Height = 20
            EmptyText = 'Digite um c'#243'digo/placa aqui'
            EmptyTextStyle = []
            Flat = False
            LabelCaption = 'Selecione um ve'#237'culo:'
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
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentCtl3D = False
            ParentFont = False
            ReadOnly = False
            TabOrder = 0
            Visible = True
            Version = '1.3.5.0'
            ButtonStyle = bsButton
            ButtonWidth = 25
            Etched = False
            ButtonCaption = 'F2'
            OnClickBtn = edt_VeiCodClickBtn
          end
          object gbx_Condutor: TAdvGroupBox
            Left = 0
            Top = 148
            Width = 778
            Height = 272
            BorderStyle = bsNone
            CheckBox.Checked = True
            CheckBox.State = cbChecked
            RoundEdges = True
            Align = alBottom
            Caption = ' Informa'#231#245'es do(s) Condutor(s) do ve'#237'culo '
            TabOrder = 1
            object vst_GridCondutor: TVirtualStringTree
              Left = 3
              Top = 25
              Width = 449
              Height = 244
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
              OnGetText = vst_GridCondutorGetText
              Columns = <
                item
                  Color = clWindow
                  Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
                  Position = 0
                  Width = 121
                  WideText = 'CPF do Condutor'
                end
                item
                  Color = clWindow
                  Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment]
                  Position = 1
                  Width = 250
                  WideText = 'Nome do Condutor'
                end>
              WideDefaultText = '000.000.000-00'
            end
            object edt_CdtCod: TAdvEditBtn
              Left = 575
              Top = 25
              Width = 200
              Height = 20
              EmptyText = 'Digite um c'#243'digo/nome aqui'
              EmptyTextStyle = []
              Flat = False
              LabelCaption = 'Selecione um condutor:'
              LabelFont.Charset = DEFAULT_CHARSET
              LabelFont.Color = clWindowText
              LabelFont.Height = -11
              LabelFont.Name = 'Tahoma'
              LabelFont.Style = []
              Lookup.DisplayCount = 8
              Lookup.Font.Charset = DEFAULT_CHARSET
              Lookup.Font.Color = clWindowText
              Lookup.Font.Height = -11
              Lookup.Font.Name = 'Arial'
              Lookup.Font.Style = []
              Lookup.History = True
              Lookup.Separator = ';'
              Lookup.SearchValue = True
              Lookup.ShowValue = True
              Color = clWindow
              Ctl3D = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentCtl3D = False
              ParentFont = False
              ReadOnly = False
              TabOrder = 1
              Visible = True
              Version = '1.3.5.0'
              ButtonStyle = bsButton
              ButtonWidth = 25
              Etched = False
              ButtonCaption = 'F2'
              OnClickBtn = edt_CdtCodClickBtn
            end
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
    ExplicitTop = 551
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
      TabOrder = 3
      OnClick = btn_VinculaClick
      Alignment = taLeftJustify
      ButtonIndex = 2
      SpaceInterval = 6
    end
    object btn_Remove: TJvFooterBtn
      Left = 198
      Top = 5
      Width = 90
      Height = 30
      Anchors = [akLeft, akBottom]
      Caption = 'Remover'
      ParentShowHint = False
      ShowHint = False
      TabOrder = 2
      Alignment = taLeftJustify
      ButtonIndex = 3
      SpaceInterval = 6
    end
    object btn_Save: TJvFooterBtn
      Left = 294
      Top = 5
      Width = 90
      Height = 30
      Anchors = [akLeft, akBottom]
      Caption = 'Gravar'
      TabOrder = 4
      OnClick = btn_SaveClick
      Alignment = taLeftJustify
      ButtonIndex = 4
      SpaceInterval = 6
    end
  end
end
