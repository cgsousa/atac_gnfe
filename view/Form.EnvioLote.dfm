object frm_EnvLote: Tfrm_EnvLote
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = '.:Envio autom'#225'tico de lote NFE:.'
  ClientHeight = 594
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
    Top = 554
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
    ExplicitTop = 537
    DesignSize = (
      794
      40)
    object btn_OK: TJvFooterBtn
      Left = 582
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
      Left = 686
      Top = 5
      Width = 100
      Height = 30
      Anchors = [akRight, akBottom]
      Caption = 'Fechar'
      TabOrder = 1
      OnClick = btn_CloseClick
      ButtonIndex = 1
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
      TabOrder = 2
      OnClick = btn_StartClick
      Alignment = taLeftJustify
      ButtonIndex = 2
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
      TabOrder = 3
      OnClick = btn_StopClick
      Alignment = taLeftJustify
      ButtonIndex = 3
      SpaceInterval = 6
    end
  end
  object pag_Control1: TAdvPageControl
    Left = 0
    Top = 0
    Width = 794
    Height = 554
    ActivePage = tab_Grid1
    ActiveFont.Charset = DEFAULT_CHARSET
    ActiveFont.Color = clWindowText
    ActiveFont.Height = -11
    ActiveFont.Name = 'Tahoma'
    ActiveFont.Style = []
    Align = alClient
    TabBackGroundColor = clBtnFace
    TabMargin.RightMargin = 0
    TabOverlap = 0
    Version = '2.0.0.4'
    PersistPagesState.Location = plRegistry
    PersistPagesState.Enabled = False
    TabOrder = 1
    object tab_Grid1: TAdvTabSheet
      Caption = 'Notas fiscais'
      Color = clWindow
      ColorTo = clNone
      TabColor = clBtnFace
      TabColorTo = clNone
      ExplicitLeft = 8
      ExplicitTop = 23
      ExplicitHeight = 508
      object lbl_MaxLot: TGradientLabel
        Left = 0
        Top = 508
        Width = 786
        Height = 17
        Align = alBottom
        AutoSize = False
        Caption = 'Nenhum'
        Color = clInfoBk
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Trebuchet MS'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        ColorTo = clWindow
        EllipsType = etNone
        GradientType = gtFullHorizontal
        GradientDirection = gdLeftToRight
        Indent = 0
        Orientation = goHorizontal
        TransparentText = False
        VAlignment = vaCenter
        Version = '1.2.0.0'
        ExplicitTop = 506
      end
      object vst_Grid1: TVirtualStringTree
        Left = 0
        Top = 0
        Width = 786
        Height = 508
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
        OnChange = vst_Grid1Change
        OnGetText = vst_Grid1GetText
        ExplicitTop = -6
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
            Position = 5
            Width = 200
            WideText = 'Situa'#231#227'o'
          end>
      end
    end
    object tab_LOG: TAdvTabSheet
      Caption = 'LOG'
      Color = clWindow
      ColorTo = clNone
      TabColor = clBtnFace
      TabColorTo = clNone
      ExplicitHeight = 508
      object txt_Log: TJvRichEdit
        Left = 0
        Top = 0
        Width = 786
        Height = 525
        Align = alClient
        Flat = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
        WordWrap = False
        ExplicitTop = -2
      end
    end
  end
end
