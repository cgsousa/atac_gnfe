object frm_EnvLote: Tfrm_EnvLote
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = '.:Envio autom'#225'tico de lote NFE:.'
  ClientHeight = 577
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
  object HTMLabel1: THTMLabel
    Left = 0
    Top = 0
    Width = 794
    Height = 22
    Align = alTop
    ColorTo = 9240575
    BorderWidth = 1
    BorderStyle = bsSingle
    Color = clInfoBk
    HTMLText.Strings = (
      
        '<P align="left"><b>ATEN'#199#195'O!</b> Verifique na listagem abaixo as ' +
        'NFE que ser'#227'o enviadas em um '#250'nico lote (M'#225'ximo de 50 notas)</P>')
    ParentColor = False
    Transparent = False
    Version = '1.9.0.2'
  end
  object pnl_Footer: TJvFooter
    Left = 0
    Top = 537
    Width = 794
    Height = 40
    Align = alBottom
    BevelStyle = bsRaised
    BevelVisible = True
    ExplicitTop = 532
    DesignSize = (
      794
      40)
    object html_Status: THTMLabel
      Left = 218
      Top = 5
      Width = 345
      Height = 25
      ColorTo = 11769496
      BorderWidth = 1
      BorderStyle = bsSingle
      Color = 15524577
      HTMLText.Strings = (
        
          '<P align="left">TMS <b>STATUS</b> label</P> <P align="right">TMS' +
          ' <b>TOTAL</b> label</P>')
      ParentColor = False
      Transparent = False
      Visible = False
      Version = '1.9.0.2'
    end
    object btn_OK: TJvFooterBtn
      Left = 582
      Top = 5
      Width = 100
      Height = 30
      Anchors = [akRight, akBottom]
      Caption = 'Confirmar'
      TabOrder = 0
      OnClick = btn_OKClick
      ButtonIndex = 1
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
      ButtonIndex = 2
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
      ButtonIndex = 3
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
      ButtonIndex = 4
      SpaceInterval = 6
    end
  end
  object pag_Control1: TAdvPageControl
    Left = 0
    Top = 22
    Width = 794
    Height = 515
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
      ExplicitLeft = -83
      ExplicitTop = -15
      ExplicitWidth = 281
      ExplicitHeight = 164
      object vst_Grid1: TVirtualStringTree
        Left = 0
        Top = 0
        Width = 786
        Height = 486
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
        ExplicitTop = -2
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
    object LOG: TAdvTabSheet
      Caption = 'LOG'
      Color = clWindow
      ColorTo = clNone
      TabColor = clBtnFace
      TabColorTo = clNone
      ExplicitLeft = 8
      ExplicitTop = 23
      object txt_Log: TJvRichEdit
        Left = 0
        Top = 0
        Width = 786
        Height = 486
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
      end
    end
  end
end
