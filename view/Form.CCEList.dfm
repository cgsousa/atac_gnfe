object frm_CCEList: Tfrm_CCEList
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = '.:Lista de Carta de Corre'#231#245'es:.'
  ClientHeight = 484
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
  DesignSize = (
    1018
    484)
  PixelsPerInch = 96
  TextHeight = 14
  object pnl_Footer: TJvFooter
    Left = 0
    Top = 444
    Width = 1018
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
    DesignSize = (
      1018
      40)
    object btn_New: TJvFooterBtn
      Left = 8
      Top = 5
      Width = 100
      Height = 30
      Anchors = [akLeft, akBottom]
      Caption = 'Nova CCE'
      TabOrder = 0
      OnClick = btn_NewClick
      Alignment = taLeftJustify
      ButtonIndex = 0
      SpaceInterval = 6
    end
    object btn_Print: TJvFooterBtn
      Left = 112
      Top = 5
      Width = 100
      Height = 30
      Anchors = [akLeft, akBottom]
      Caption = 'Imprimir'
      TabOrder = 2
      OnClick = btn_PrintClick
      Alignment = taLeftJustify
      ButtonIndex = 1
      SpaceInterval = 6
    end
    object btn_Close: TJvFooterBtn
      Left = 910
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
  end
  object vst_Grid1: TVirtualStringTree
    Left = 5
    Top = 5
    Width = 1005
    Height = 433
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
    OnGetText = vst_Grid1GetText
    Columns = <
      item
        Color = 15000804
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coFixed, coAllowFocus]
        Position = 0
        Width = 325
        WideText = 'Chave'
      end
      item
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
        Position = 1
        Width = 121
        WideText = 'Data e hora'
      end
      item
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
        Position = 2
        Width = 250
        WideText = 'Corre'#231#227'o'
      end
      item
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
        Position = 3
        Width = 200
        WideText = 'Status'
      end
      item
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
        Position = 4
        Width = 200
        WideText = 'Destinat'#225'rio'
      end
      item
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
        Position = 5
        Width = 121
        WideText = 'D/H Recebimento'
      end
      item
        Position = 6
        Width = 121
        WideText = 'Protocolo'
      end>
  end
end
