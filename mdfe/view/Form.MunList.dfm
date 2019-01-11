object frm_MunList: Tfrm_MunList
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = '.:Busca Munic'#237'pio:.'
  ClientHeight = 456
  ClientWidth = 444
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
  DesignSize = (
    444
    456)
  PixelsPerInch = 96
  TextHeight = 14
  object pnl_Footer: TJvFooter
    Left = 0
    Top = 416
    Width = 444
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
      444
      40)
    object btn_Close: TJvFooterBtn
      Left = 336
      Top = 5
      Width = 100
      Height = 30
      Anchors = [akRight, akBottom]
      Caption = 'Cancelar'
      TabOrder = 0
      OnClick = btn_CloseClick
      ButtonIndex = 0
      SpaceInterval = 6
      ExplicitLeft = 526
    end
    object btn_Filter: TJvFooterBtn
      Left = 8
      Top = 5
      Width = 100
      Height = 30
      Anchors = [akLeft, akBottom]
      Caption = 'Filtro'
      TabOrder = 1
      OnClick = btn_FilterClick
      Alignment = taLeftJustify
      ButtonIndex = 1
      SpaceInterval = 6
    end
    object btn_OK: TJvFooterBtn
      Left = 112
      Top = 5
      Width = 100
      Height = 30
      Anchors = [akLeft, akBottom]
      Caption = 'OK'
      TabOrder = 2
      OnClick = btn_OKClick
      Alignment = taLeftJustify
      ButtonIndex = 2
      SpaceInterval = 6
    end
  end
  object vst_Grid1: TVirtualStringTree
    Left = 8
    Top = 8
    Width = 428
    Height = 402
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
    Header.AutoSizeIndex = -1
    Header.Background = clBtnHighlight
    Header.Height = 21
    Header.Options = [hoColumnResize, hoDrag, hoShowImages, hoShowSortGlyphs, hoVisible]
    Header.ParentFont = True
    Header.Style = hsPlates
    ParentFont = False
    RootNodeCount = 20
    TabOrder = 1
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScroll, toAutoTristateTracking]
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toInitOnSave, toToggleOnDblClick, toWheelPanning]
    TreeOptions.PaintOptions = [toHotTrack, toShowDropmark, toShowHorzGridLines, toShowVertGridLines, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toDisableDrawSelection, toExtendedFocus, toFullRowSelect, toMiddleClickSelect, toRightClickSelect, toCenterScrollIntoView]
    OnChecked = vst_Grid1Checked
    OnGetText = vst_Grid1GetText
    Columns = <
      item
        Alignment = taCenter
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
        Position = 0
        Width = 140
        WideText = 'C'#243'digo do Munic'#237'pio'
      end
      item
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
        Position = 1
        Width = 250
        WideText = 'Nome do Munic'#237'pio'
      end>
  end
  object pnl_Filter: TAdvPanel
    Left = 8
    Top = 208
    Width = 257
    Height = 202
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
      255
      200)
    FullHeight = 485
    object btn_Find: TJvImgBtn
      Left = 138
      Top = 154
      Width = 100
      Height = 30
      Anchors = [akRight, akBottom]
      Caption = 'Buscar'
      TabOrder = 2
      OnClick = btn_FindClick
    end
    object gbx_CodMun: TAdvGroupBox
      Left = 5
      Top = 18
      Width = 245
      Height = 50
      RoundEdges = True
      Align = alTop
      Caption = 'Busca por Cod.IBGE'
      TabOrder = 0
      object edt_CodMun: TAdvEdit
        Left = 112
        Top = 20
        Width = 121
        Height = 22
        EditAlign = eaCenter
        EditType = etNumeric
        EmptyTextStyle = []
        LabelCaption = 'Informe o C'#243'digo:'
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
    object gbx_NomMun: TAdvGroupBox
      Left = 5
      Top = 68
      Width = 245
      Height = 80
      Align = alTop
      Caption = ' Busca por Nome'
      TabOrder = 1
      object cbx_UF: TAdvComboBox
        Left = 112
        Top = 20
        Width = 121
        Height = 24
        Color = clWindow
        Version = '1.5.1.0'
        Visible = True
        Style = csDropDownList
        EmptyTextStyle = []
        DropWidth = 0
        Enabled = True
        ItemIndex = -1
        LabelCaption = 'Selecione uma UF:'
        LabelMargin = 2
        LabelTransparent = True
        LabelFont.Charset = DEFAULT_CHARSET
        LabelFont.Color = clNavy
        LabelFont.Height = -11
        LabelFont.Name = 'Tahoma'
        LabelFont.Style = []
        TabOrder = 0
      end
      object edt_NomMun: TAdvEdit
        Left = 112
        Top = 50
        Width = 121
        Height = 22
        EmptyTextStyle = []
        LabelCaption = 'Nome do munic'#237'pio:'
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
        CharCase = ecUpperCase
        Color = clWindow
        TabOrder = 1
        Visible = True
        Version = '3.3.2.0'
      end
    end
  end
end
