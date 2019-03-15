object frm_Config: Tfrm_Config
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = '.:Configura Emiss'#227'o da NFE/NFCE:.'
  ClientHeight = 448
  ClientWidth = 634
  Color = clWindow
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object pnl_Footer: TJvFooter
    Left = 0
    Top = 408
    Width = 634
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
      634
      40)
    object btn_OK: TJvFooterBtn
      Left = 422
      Top = 5
      Width = 100
      Height = 30
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      TabOrder = 0
      OnClick = btn_OKClick
      ButtonIndex = 0
      SpaceInterval = 6
    end
    object btn_Close: TJvFooterBtn
      Left = 526
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
  end
  object pag_Control1: TAdvPageControl
    Left = 0
    Top = 0
    Width = 634
    Height = 400
    ActivePage = tab_Numeracao
    ActiveFont.Charset = DEFAULT_CHARSET
    ActiveFont.Color = clWindowText
    ActiveFont.Height = -11
    ActiveFont.Name = 'Tahoma'
    ActiveFont.Style = []
    Align = alTop
    TabBackGroundColor = clBtnFace
    TabMargin.RightMargin = 0
    TabOverlap = 0
    Version = '2.0.0.4'
    PersistPagesState.Location = plRegistry
    PersistPagesState.Enabled = False
    TabOrder = 1
    object tab_Geral: TAdvTabSheet
      BorderWidth = 3
      Caption = 'Geral'
      Color = clWindow
      ColorTo = clNone
      TabColor = clBtnFace
      TabColorTo = clNone
      object rgx_FormaEmis: TAdvOfficeRadioGroup
        Left = 0
        Top = 0
        Width = 620
        Height = 125
        RoundEdges = True
        Version = '1.3.7.0'
        Align = alTop
        Caption = ' Forma de Emiss'#227'o '
        ParentBackground = False
        TabOrder = 0
        Columns = 3
        ItemIndex = 0
        Items.Strings = (
          'Normal'
          'Conting'#234'ncia'
          'SCAN'
          'DPEC'
          'FSDA'
          'SVCAN'
          'SVCRS'
          'SVCSP')
        ButtonVertAlign = tlCenter
        Ellipsis = False
      end
    end
    object tab_Numeracao: TAdvTabSheet
      BorderWidth = 3
      Caption = 'Numera'#231#227'o'
      Color = clWindow
      ColorTo = clNone
      TabColor = clBtnFace
      TabColorTo = clSilver
      DesignSize = (
        620
        365)
      object vst_Grid1: TVirtualStringTree
        Left = 0
        Top = 0
        Width = 620
        Height = 338
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
        Header.MainColumn = 1
        Header.Options = [hoColumnResize, hoDrag, hoShowImages, hoShowSortGlyphs, hoVisible]
        Header.ParentFont = True
        Header.Style = hsPlates
        ParentFont = False
        RootNodeCount = 5
        TabOrder = 0
        TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScroll, toAutoTristateTracking]
        TreeOptions.MiscOptions = [toAcceptOLEDrop, toInitOnSave, toToggleOnDblClick, toWheelPanning]
        TreeOptions.PaintOptions = [toHotTrack, toShowDropmark, toShowHorzGridLines, toShowVertGridLines, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toDisableDrawSelection, toExtendedFocus, toFullRowSelect, toMiddleClickSelect, toMultiSelect, toRightClickSelect, toCenterScrollIntoView]
        OnGetText = vst_Grid1GetText
        ExplicitLeft = -3
        ExplicitTop = -3
        Columns = <
          item
            Color = clWindow
            Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coFixed, coAllowFocus]
            Position = 0
            Width = 145
            WideText = 'CNPJ'
          end
          item
            Alignment = taCenter
            Color = clWindow
            Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
            Position = 1
            WideText = 'Mod'
          end
          item
            Alignment = taCenter
            Color = clWindow
            Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
            Position = 2
            WideText = 'S'#233'rie'
          end
          item
            Alignment = taCenter
            Color = clWindow
            Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
            Position = 3
            Width = 121
            WideText = #218'ltimo Numero'
          end
          item
            Position = 4
            Width = 225
            WideText = 'Descri'#231#227'o'
          end>
      end
      object btn_New: TJvImgBtn
        Left = 0
        Top = 341
        Width = 75
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'Novo'
        TabOrder = 1
        OnClick = btn_NewClick
      end
      object btn_Upd: TJvImgBtn
        Left = 81
        Top = 341
        Width = 75
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'Alterar'
        TabOrder = 2
        OnClick = btn_UpdClick
      end
    end
  end
end
