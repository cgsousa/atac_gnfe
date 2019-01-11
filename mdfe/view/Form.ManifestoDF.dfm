object frm_ManifestoDF: Tfrm_ManifestoDF
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = '.:Manifesto de Documentos Fiscais Eletr'#244'nicos:.'
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
  DesignSize = (
    794
    572)
  PixelsPerInch = 96
  TextHeight = 14
  object pageList1: TJvPageList
    Left = 5
    Top = 135
    Width = 781
    Height = 395
    ActivePage = pag_MunDescarga
    PropagateEnable = False
    OnChanging = pageList1Changing
    object pag_MunCarga: TJvStandardPage
      Left = 0
      Top = 0
      Width = 781
      Height = 395
      Caption = 'pag_MunCarga'
      object pnl_MunCarga: TAdvPanel
        Left = 0
        Top = 0
        Width = 781
        Height = 395
        Align = alClient
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
        BorderColor = clNone
        Caption.Color = 15658734
        Caption.ColorTo = clNone
        Caption.Font.Charset = DEFAULT_CHARSET
        Caption.Font.Color = clBlack
        Caption.Font.Height = -11
        Caption.Font.Name = 'Tahoma'
        Caption.Font.Style = []
        Caption.GradientDirection = gdVertical
        Caption.Indent = 4
        Caption.ShadeLight = 255
        Caption.Text = '<P align="center">Informa'#231#245'es dos Munic'#237'pios de Carregamento</P>'
        Caption.Visible = True
        CollapsColor = clNone
        CollapsDelay = 0
        ShadowColor = clBlack
        ShadowOffset = 0
        StatusBar.BorderColor = clNone
        StatusBar.BorderStyle = bsSingle
        StatusBar.Font.Charset = DEFAULT_CHARSET
        StatusBar.Font.Color = clBlack
        StatusBar.Font.Height = -11
        StatusBar.Font.Name = 'Tahoma'
        StatusBar.Font.Style = []
        StatusBar.Color = 15658734
        StatusBar.GradientDirection = gdVertical
        Styler = PanelStyler1
        FullHeight = 200
        object vst_GridMunCarga: TVirtualStringTree
          Left = 0
          Top = 23
          Width = 475
          Height = 354
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
          RootNodeCount = 50
          TabOrder = 0
          TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScroll, toAutoTristateTracking]
          TreeOptions.MiscOptions = [toAcceptOLEDrop, toInitOnSave, toToggleOnDblClick, toWheelPanning]
          TreeOptions.PaintOptions = [toHotTrack, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowTreeLines, toShowVertGridLines, toUseBlendedImages]
          TreeOptions.SelectionOptions = [toDisableDrawSelection, toExtendedFocus, toFullRowSelect, toMiddleClickSelect, toRightClickSelect, toCenterScrollIntoView]
          OnGetText = vst_GridMunCargaGetText
          Columns = <
            item
              Color = clWindow
              Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
              Position = 0
              Width = 150
              WideText = 'C'#243'digo do Munic'#237'pio'
            end
            item
              Color = clWindow
              Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment]
              Position = 1
              Width = 300
              WideText = 'Nome do Munic'#237'pio'
            end>
        end
        object btn_MunCargaAdd: TJvImgBtn
          Left = 649
          Top = 22
          Width = 100
          Height = 30
          Caption = 'Incluir'
          TabOrder = 1
          OnClick = btn_MunCargaAddClick
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'Tahoma'
          HotTrackFont.Style = []
        end
        object btn_MunCargaDel: TJvImgBtn
          Left = 649
          Top = 58
          Width = 100
          Height = 30
          Caption = 'Remover'
          TabOrder = 2
          OnClick = btn_MunCargaDelClick
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'Tahoma'
          HotTrackFont.Style = []
        end
      end
    end
    object pag_Modal: TJvStandardPage
      Left = 0
      Top = 0
      Width = 781
      Height = 395
      Caption = 'pag_Modal'
      object pnl_Modal: TAdvPanel
        Left = 0
        Top = 0
        Width = 781
        Height = 395
        Align = alClient
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
        BorderColor = clNone
        Caption.Color = 15658734
        Caption.ColorTo = clNone
        Caption.Font.Charset = DEFAULT_CHARSET
        Caption.Font.Color = clBlack
        Caption.Font.Height = -11
        Caption.Font.Name = 'Tahoma'
        Caption.Font.Style = []
        Caption.GradientDirection = gdVertical
        Caption.Indent = 4
        Caption.ShadeLight = 255
        Caption.Text = '<P align="center">Informa'#231#245'es do modal Rodovi'#225'rio</P>'
        Caption.Visible = True
        CollapsColor = clNone
        CollapsDelay = 0
        ShadowColor = clBlack
        ShadowOffset = 0
        StatusBar.BorderColor = clNone
        StatusBar.BorderStyle = bsSingle
        StatusBar.Font.Charset = DEFAULT_CHARSET
        StatusBar.Font.Color = clBlack
        StatusBar.Font.Height = -11
        StatusBar.Font.Name = 'Tahoma'
        StatusBar.Font.Style = []
        StatusBar.Color = 15658734
        StatusBar.GradientDirection = gdVertical
        Styler = PanelStyler1
        FullHeight = 200
        object edt_RNTRC: TAdvEdit
          Left = 656
          Top = 22
          Width = 121
          Height = 19
          EmptyTextStyle = []
          LabelCaption = 'Registro Nacional de Transportadores Rodovi'#225'rios de Carga:'
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
          Text = 'edt_RNTRC'
          Visible = True
          Version = '3.3.2.0'
        end
        object gbx_Veiculo: TAdvGroupBox
          Left = 0
          Top = 46
          Width = 781
          Height = 349
          Align = alBottom
          Caption = ' Dados do Ve'#237'culo com Tra'#231#227'o '
          TabOrder = 1
          DesignSize = (
            781
            349)
          object html_Veiculo: THTMLabel
            Left = 165
            Top = 52
            Width = 485
            Height = 35
            BorderWidth = 1
            BorderStyle = bsSingle
            Color = clInfoBk
            HTMLText.Strings = (
              
                '<P align="left">TMS <b>STATUS</b> label</P> <P align="right">TMS' +
                ' <b>TOTAL</b> label</P>')
            ParentColor = False
            Transparent = False
            Version = '1.9.0.2'
          end
          object edt_VeiCod: TAdvEditBtn
            Left = 165
            Top = 21
            Width = 121
            Height = 19
            EditType = etNumeric
            EmptyText = 'Selecione um ve'#237'culo'
            EmptyTextStyle = []
            Flat = False
            LabelCaption = 'Ve'#237'culo:'
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
            ParentCtl3D = False
            ReadOnly = False
            TabOrder = 0
            Text = '0'
            Visible = True
            Version = '1.3.5.0'
            ButtonStyle = bsButton
            ButtonWidth = 25
            Etched = False
            ButtonCaption = '...'
            OnClickBtn = edt_VeiCodClickBtn
          end
          object btn_CadVei: TJvImgBtn
            Left = 656
            Top = 16
            Width = 100
            Height = 30
            Anchors = [akTop, akRight]
            Caption = 'Cadastro'
            TabOrder = 1
            OnClick = btn_CadVeiClick
            HotTrackFont.Charset = DEFAULT_CHARSET
            HotTrackFont.Color = clWindowText
            HotTrackFont.Height = -11
            HotTrackFont.Name = 'Tahoma'
            HotTrackFont.Style = []
          end
          object gbx_Condutor: TAdvGroupBox
            Left = 165
            Top = 93
            Width = 605
            Height = 250
            Caption = ' Informa'#231#245'es do(s) Condutor(s) do ve'#237'culo '
            TabOrder = 2
            object vst_GridCondutor: TVirtualStringTree
              Left = 10
              Top = 19
              Width = 475
              Height = 222
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
                  Width = 150
                  WideText = 'CPF do Condutor'
                end
                item
                  Color = clWindow
                  Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment]
                  Position = 1
                  Width = 300
                  WideText = 'Nome do Condutor'
                end>
            end
            object btn_CondtrAdd: TJvImgBtn
              Left = 491
              Top = 19
              Width = 100
              Height = 30
              Caption = 'Incluir'
              TabOrder = 1
              OnClick = btn_CondtrAddClick
              HotTrackFont.Charset = DEFAULT_CHARSET
              HotTrackFont.Color = clWindowText
              HotTrackFont.Height = -11
              HotTrackFont.Name = 'Tahoma'
              HotTrackFont.Style = []
            end
            object btn_CondtrDel: TJvImgBtn
              Left = 491
              Top = 55
              Width = 100
              Height = 30
              Caption = 'Remover'
              TabOrder = 2
              HotTrackFont.Charset = DEFAULT_CHARSET
              HotTrackFont.Color = clWindowText
              HotTrackFont.Height = -11
              HotTrackFont.Name = 'Tahoma'
              HotTrackFont.Style = []
            end
            object btn_CadCondtr: TJvImgBtn
              Left = 491
              Top = 211
              Width = 100
              Height = 30
              Caption = 'Cadastro'
              TabOrder = 3
              OnClick = btn_CadCondtrClick
              HotTrackFont.Charset = DEFAULT_CHARSET
              HotTrackFont.Color = clWindowText
              HotTrackFont.Height = -11
              HotTrackFont.Name = 'Tahoma'
              HotTrackFont.Style = []
            end
          end
        end
      end
    end
    object pag_MunDescarga: TJvStandardPage
      Left = 0
      Top = 0
      Width = 781
      Height = 395
      Caption = 'pag_MunDescarga'
      object pnl_MunDescarga: TAdvPanel
        Left = 0
        Top = 0
        Width = 781
        Height = 395
        Align = alClient
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
        BorderColor = clNone
        Caption.Color = 15658734
        Caption.ColorTo = clNone
        Caption.Font.Charset = DEFAULT_CHARSET
        Caption.Font.Color = clBlack
        Caption.Font.Height = -11
        Caption.Font.Name = 'Tahoma'
        Caption.Font.Style = []
        Caption.GradientDirection = gdVertical
        Caption.Indent = 4
        Caption.ShadeLight = 255
        Caption.Text = '<P align="center">Munic'#237'pios de descarregamento</P> '
        Caption.Visible = True
        CollapsColor = clNone
        CollapsDelay = 0
        ShadowColor = clBlack
        ShadowOffset = 0
        StatusBar.BorderColor = clNone
        StatusBar.BorderStyle = bsSingle
        StatusBar.Font.Charset = DEFAULT_CHARSET
        StatusBar.Font.Color = clBlack
        StatusBar.Font.Height = -11
        StatusBar.Font.Name = 'Tahoma'
        StatusBar.Font.Style = []
        StatusBar.Text = 'Para adicionar uma ou mais NFE, primeiro selecione um munic'#237'pio!'
        StatusBar.Color = 15658734
        StatusBar.GradientDirection = gdVertical
        StatusBar.Visible = True
        Styler = PanelStyler1
        DesignSize = (
          781
          395)
        FullHeight = 200
        object vst_GridMunDescarga: TVirtualStringTree
          Left = 5
          Top = 25
          Width = 646
          Height = 335
          Alignment = taCenter
          Anchors = [akLeft, akTop, akRight, akBottom]
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
          OnGetText = vst_GridMunDescargaGetText
          Columns = <
            item
              Color = clWindow
              Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
              Position = 0
              Width = 315
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
        object btn_MunDesgardaAdd: TJvImgBtn
          Left = 657
          Top = 25
          Width = 100
          Height = 30
          Anchors = [akTop, akRight]
          Caption = 'Add Munic'#237'pio'
          TabOrder = 1
          OnClick = btn_MunDesgardaAddClick
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'Tahoma'
          HotTrackFont.Style = []
        end
        object btn_MunDesgardaDel: TJvImgBtn
          Left = 657
          Top = 61
          Width = 100
          Height = 30
          Anchors = [akTop, akRight]
          Caption = 'Remover'
          TabOrder = 2
          OnClick = btn_MunDesgardaDelClick
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'Tahoma'
          HotTrackFont.Style = []
        end
        object btn_NFeAdd: TJvImgBtn
          Left = 657
          Top = 294
          Width = 100
          Height = 30
          Anchors = [akTop, akRight]
          Caption = 'Add NFe'
          TabOrder = 3
          OnClick = btn_NFeAddClick
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'Tahoma'
          HotTrackFont.Style = []
        end
        object btn_NFeDel: TJvImgBtn
          Left = 657
          Top = 330
          Width = 100
          Height = 30
          Anchors = [akTop, akRight]
          Caption = 'Remover'
          TabOrder = 4
          HotTrackFont.Charset = DEFAULT_CHARSET
          HotTrackFont.Color = clWindowText
          HotTrackFont.Height = -11
          HotTrackFont.Name = 'Tahoma'
          HotTrackFont.Style = []
        end
      end
    end
  end
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
    Font.Height = -11
    Font.Name = 'Trebuchet MS'
    Font.Style = []
    ParentFont = False
    DesignSize = (
      794
      40)
    object btn_Close: TJvFooterBtn
      Left = 696
      Top = 5
      Width = 90
      Height = 30
      Anchors = [akRight, akBottom]
      Caption = 'Fechar'
      TabOrder = 0
      OnClick = btn_CloseClick
      ButtonIndex = 0
      SpaceInterval = 6
    end
    object btn_Config: TJvFooterBtn
      Left = 8
      Top = 5
      Width = 90
      Height = 30
      Anchors = [akLeft, akBottom]
      Caption = 'Configura'#231#245'es'
      TabOrder = 1
      OnClick = btn_ConfigClick
      Alignment = taLeftJustify
      ButtonIndex = 1
      SpaceInterval = 6
    end
    object btn_New: TJvFooterBtn
      Left = 102
      Top = 5
      Width = 90
      Height = 30
      Anchors = [akLeft, akBottom]
      Caption = 'Novo'
      TabOrder = 2
      OnClick = btn_NewClick
      Alignment = taLeftJustify
      ButtonIndex = 2
      SpaceInterval = 6
    end
    object btn_Edit: TJvFooterBtn
      Left = 198
      Top = 5
      Width = 90
      Height = 30
      Anchors = [akLeft, akBottom]
      Caption = 'Editar'
      TabOrder = 3
      OnClick = btn_EditClick
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
      TabOrder = 7
      OnClick = btn_SaveClick
      Alignment = taLeftJustify
      ButtonIndex = 4
      SpaceInterval = 6
    end
    object btn_Cancel: TJvFooterBtn
      Left = 390
      Top = 5
      Width = 90
      Height = 30
      Anchors = [akLeft, akBottom]
      Caption = 'Desfazer'
      TabOrder = 4
      OnClick = btn_CancelClick
      Alignment = taLeftJustify
      ButtonIndex = 5
      SpaceInterval = 6
    end
    object btn_Delete: TJvFooterBtn
      Left = 486
      Top = 5
      Width = 90
      Height = 30
      Anchors = [akLeft, akBottom]
      Caption = 'Excluir'
      TabOrder = 5
      Alignment = taLeftJustify
      ButtonIndex = 6
      SpaceInterval = 6
    end
    object btn_Send: TJvFooterBtn
      Left = 582
      Top = 5
      Width = 90
      Height = 30
      Anchors = [akLeft, akBottom]
      Caption = 'Enviar'
      TabOrder = 6
      OnClick = btn_SendClick
      Alignment = taLeftJustify
      ButtonIndex = 7
      SpaceInterval = 6
    end
  end
  object gbx_Ident: TAdvGroupBox
    Left = 5
    Top = 3
    Width = 781
    Height = 95
    Caption = ' Identifica'#231#227'o  '
    TabOrder = 0
    object edt_mdfCod: TAdvEditBtn
      Left = 165
      Top = 16
      Width = 121
      Height = 20
      EditType = etValidChars
      EmptyText = 'Digite um c'#243'digo aqui'
      EmptyTextStyle = []
      Flat = False
      LabelCaption = 'C'#243'digo:'
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
      ValidChars = '0123456789'
      Visible = True
      Version = '1.3.5.0'
      ButtonStyle = bsButton
      ButtonWidth = 25
      Etched = False
      ButtonCaption = '...'
      OnClickBtn = edt_mdfCodClickBtn
    end
    object cbx_mdfTpAmb: TAdvComboBox
      Left = 416
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
      LabelCaption = 'Tipo de ambiente:'
      LabelMargin = 3
      LabelTransparent = True
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
      TabOrder = 1
    end
    object cbx_mdfTpEmit: TAdvComboBox
      Left = 416
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
      LabelCaption = 'Tipo do emitente:'
      LabelMargin = 3
      LabelTransparent = True
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
      TabOrder = 2
    end
    object cbx_mdfTpTrasp: TAdvComboBox
      Left = 416
      Top = 64
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
      LabelMargin = 3
      LabelTransparent = True
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
      TabOrder = 3
    end
    object edt_mdfNumDoc: TAdvEdit
      Left = 165
      Top = 40
      Width = 121
      Height = 20
      EditType = etNumeric
      EmptyTextStyle = []
      LabelCaption = 'N'#250'mero do manifesto:'
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
      TabOrder = 4
      Text = '0'
      Visible = True
      Version = '3.3.2.0'
    end
    object edt_mdDtEmis: TAdvEdit
      Left = 165
      Top = 64
      Width = 121
      Height = 20
      EmptyTextStyle = []
      LabelCaption = 'Data/Hora emiss'#227'o:'
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
      TabOrder = 5
      Visible = True
      Version = '3.3.2.0'
    end
    object cbx_mdfTpEmis: TAdvComboBox
      Left = 649
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
      LabelCaption = 'Forma de emiss'#227'o:'
      LabelMargin = 3
      LabelTransparent = True
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
      TabOrder = 6
    end
    object edt_mdfUFCarga: TAdvEdit
      Left = 649
      Top = 40
      Width = 121
      Height = 20
      EmptyTextStyle = []
      LabelCaption = 'UF de carga:'
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
      TabOrder = 7
      Visible = True
      Version = '3.3.2.0'
    end
    object edt_mdfUFDescarga: TAdvEdit
      Left = 649
      Top = 64
      Width = 121
      Height = 20
      EmptyTextStyle = []
      LabelCaption = 'UF de descarga:'
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
      TabOrder = 8
      Visible = True
      Version = '3.3.2.0'
    end
  end
  object btn_MunCarga: TAdvGlowButton
    Left = 5
    Top = 104
    Width = 220
    Height = 30
    Anchors = [akTop, akRight]
    Caption = 'Munic'#237'pios de Carregamento'
    NotesFont.Charset = DEFAULT_CHARSET
    NotesFont.Color = clWindowText
    NotesFont.Height = -11
    NotesFont.Name = 'Tahoma'
    NotesFont.Style = []
    Rounded = False
    TabOrder = 2
    OnClick = btn_MunCargaClick
    Appearance.ColorChecked = 16111818
    Appearance.ColorCheckedTo = 16367008
    Appearance.ColorDisabled = 15921906
    Appearance.ColorDisabledTo = 15921906
    Appearance.ColorDown = 16111818
    Appearance.ColorDownTo = 16367008
    Appearance.ColorHot = 16117985
    Appearance.ColorHotTo = 16372402
    Appearance.ColorMirrorHot = 16107693
    Appearance.ColorMirrorHotTo = 16775412
    Appearance.ColorMirrorDown = 16102556
    Appearance.ColorMirrorDownTo = 16768988
    Appearance.ColorMirrorChecked = 16102556
    Appearance.ColorMirrorCheckedTo = 16768988
    Appearance.ColorMirrorDisabled = 11974326
    Appearance.ColorMirrorDisabledTo = 15921906
  end
  object btn_Modal: TAdvGlowButton
    Left = 229
    Top = 104
    Width = 220
    Height = 30
    Anchors = [akTop, akRight]
    Caption = 'Modal Rodovi'#225'rio'
    NotesFont.Charset = DEFAULT_CHARSET
    NotesFont.Color = clWindowText
    NotesFont.Height = -11
    NotesFont.Name = 'Tahoma'
    NotesFont.Style = []
    Rounded = False
    TabOrder = 3
    OnClick = btn_MunCargaClick
    Appearance.ColorChecked = 16111818
    Appearance.ColorCheckedTo = 16367008
    Appearance.ColorDisabled = 15921906
    Appearance.ColorDisabledTo = 15921906
    Appearance.ColorDown = 16111818
    Appearance.ColorDownTo = 16367008
    Appearance.ColorHot = 16117985
    Appearance.ColorHotTo = 16372402
    Appearance.ColorMirrorHot = 16107693
    Appearance.ColorMirrorHotTo = 16775412
    Appearance.ColorMirrorDown = 16102556
    Appearance.ColorMirrorDownTo = 16768988
    Appearance.ColorMirrorChecked = 16102556
    Appearance.ColorMirrorCheckedTo = 16768988
    Appearance.ColorMirrorDisabled = 11974326
    Appearance.ColorMirrorDisabledTo = 15921906
  end
  object btn_Docs: TAdvGlowButton
    Left = 455
    Top = 104
    Width = 250
    Height = 30
    Anchors = [akTop, akRight]
    Caption = 'Documentos fiscais vinculados ao manifesto'
    NotesFont.Charset = DEFAULT_CHARSET
    NotesFont.Color = clWindowText
    NotesFont.Height = -11
    NotesFont.Name = 'Tahoma'
    NotesFont.Style = []
    Rounded = False
    TabOrder = 4
    OnClick = btn_MunCargaClick
    Appearance.ColorChecked = 16111818
    Appearance.ColorCheckedTo = 16367008
    Appearance.ColorDisabled = 15921906
    Appearance.ColorDisabledTo = 15921906
    Appearance.ColorDown = 16111818
    Appearance.ColorDownTo = 16367008
    Appearance.ColorHot = 16117985
    Appearance.ColorHotTo = 16372402
    Appearance.ColorMirrorHot = 16107693
    Appearance.ColorMirrorHotTo = 16775412
    Appearance.ColorMirrorDown = 16102556
    Appearance.ColorMirrorDownTo = 16768988
    Appearance.ColorMirrorChecked = 16102556
    Appearance.ColorMirrorCheckedTo = 16768988
    Appearance.ColorMirrorDisabled = 11974326
    Appearance.ColorMirrorDisabledTo = 15921906
  end
  object PanelStyler1: TAdvPanelStyler
    Tag = 0
    Settings.AnchorHint = False
    Settings.BevelInner = bvNone
    Settings.BevelOuter = bvNone
    Settings.BevelWidth = 1
    Settings.BorderColor = clNone
    Settings.BorderShadow = False
    Settings.BorderStyle = bsNone
    Settings.BorderWidth = 0
    Settings.CanMove = False
    Settings.CanSize = False
    Settings.Caption.Color = 15658734
    Settings.Caption.ColorTo = clNone
    Settings.Caption.Font.Charset = DEFAULT_CHARSET
    Settings.Caption.Font.Color = clBlack
    Settings.Caption.Font.Height = -11
    Settings.Caption.Font.Name = 'Tahoma'
    Settings.Caption.Font.Style = []
    Settings.Caption.GradientDirection = gdVertical
    Settings.Caption.Indent = 4
    Settings.Caption.ShadeLight = 255
    Settings.Caption.Visible = True
    Settings.Collaps = False
    Settings.CollapsColor = clNone
    Settings.CollapsDelay = 0
    Settings.CollapsSteps = 0
    Settings.Color = clWhite
    Settings.ColorTo = clNone
    Settings.ColorMirror = clNone
    Settings.ColorMirrorTo = clNone
    Settings.Cursor = crDefault
    Settings.Font.Charset = DEFAULT_CHARSET
    Settings.Font.Color = clBlack
    Settings.Font.Height = -11
    Settings.Font.Name = 'Tahoma'
    Settings.Font.Style = []
    Settings.FixedTop = False
    Settings.FixedLeft = False
    Settings.FixedHeight = False
    Settings.FixedWidth = False
    Settings.Height = 120
    Settings.Hover = False
    Settings.HoverColor = clNone
    Settings.HoverFontColor = clNone
    Settings.Indent = 0
    Settings.ShadowColor = clBlack
    Settings.ShadowOffset = 0
    Settings.ShowHint = False
    Settings.ShowMoveCursor = False
    Settings.StatusBar.BorderColor = clNone
    Settings.StatusBar.BorderStyle = bsSingle
    Settings.StatusBar.Font.Charset = DEFAULT_CHARSET
    Settings.StatusBar.Font.Color = clBlack
    Settings.StatusBar.Font.Height = -11
    Settings.StatusBar.Font.Name = 'Tahoma'
    Settings.StatusBar.Font.Style = []
    Settings.StatusBar.Color = 15658734
    Settings.StatusBar.GradientDirection = gdVertical
    Settings.TextVAlign = tvaTop
    Settings.TopIndent = 0
    Settings.URLColor = clBlue
    Settings.Width = 0
    Style = psOffice2013White
    Left = 744
    Top = 96
  end
end
