object frm_NFEList: Tfrm_NFEList
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = '.:Buca NFe:.'
  ClientHeight = 576
  ClientWidth = 794
  Color = clWindow
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    794
    576)
  PixelsPerInch = 96
  TextHeight = 14
  object pnl_Footer: TJvFooter
    Left = 0
    Top = 536
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
      Width = 100
      Height = 30
      Anchors = [akLeft, akBottom]
      Caption = 'Filtro'
      TabOrder = 1
      OnClick = btn_FilterClick
      Alignment = taLeftJustify
      ButtonIndex = 0
      SpaceInterval = 6
    end
    object btn_OK: TJvFooterBtn
      Left = 582
      Top = 5
      Width = 100
      Height = 30
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      TabOrder = 2
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
      Caption = 'Cancelar'
      TabOrder = 0
      OnClick = btn_CloseClick
      ButtonIndex = 2
      SpaceInterval = 6
    end
  end
  object vst_Grid1: TVirtualStringTree
    Left = 5
    Top = 5
    Width = 781
    Height = 525
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
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toInitOnSave, toToggleOnDblClick, toWheelPanning]
    TreeOptions.PaintOptions = [toHotTrack, toShowDropmark, toShowHorzGridLines, toShowVertGridLines, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toDisableDrawSelection, toExtendedFocus, toFullRowSelect, toMiddleClickSelect, toRightClickSelect, toCenterScrollIntoView]
    OnGetText = vst_Grid1GetText
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
      end>
  end
  object pnl_Filter: TAdvPanel
    Left = 5
    Top = 232
    Width = 337
    Height = 298
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
      335
      296)
    FullHeight = 485
    object gbx_DtEmis: TAdvGroupBox
      Left = 5
      Top = 118
      Width = 325
      Height = 50
      RoundEdges = True
      Align = alTop
      Caption = ' Data de emiss'#227'o '
      TabOrder = 2
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
        Top = 20
        Width = 100
        Height = 22
        ShowNullDate = False
        TabOrder = 0
        DisabledColor = clSilver
      end
      object edt_DatFin: TJvDateEdit
        Left = 174
        Top = 20
        Width = 100
        Height = 22
        ShowNullDate = False
        TabOrder = 1
        DisabledColor = clSilver
      end
    end
    object btn_Find: TJvImgBtn
      Left = 230
      Top = 254
      Width = 100
      Height = 30
      Anchors = [akRight, akBottom]
      Caption = 'Buscar'
      TabOrder = 4
      OnClick = btn_FindClick
    end
    object gbx_CodPed: TAdvGroupBox
      Left = 5
      Top = 68
      Width = 325
      Height = 50
      RoundEdges = True
      Align = alTop
      Caption = ' N'#250'mero do Pedido (Venda) '
      TabOrder = 1
      object edt_PedIni: TAdvEdit
        Left = 35
        Top = 20
        Width = 100
        Height = 22
        EditAlign = eaCenter
        EditType = etNumeric
        EmptyTextStyle = []
        LabelCaption = 'De:'
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
      object edt_PedFin: TAdvEdit
        Left = 174
        Top = 20
        Width = 100
        Height = 22
        EditAlign = eaCenter
        EditType = etNumeric
        EmptyTextStyle = []
        LabelCaption = 'At'#233':'
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
        TabOrder = 1
        Text = '0'
        Visible = True
        Version = '3.3.2.0'
      end
    end
    object gbx_ModSer: TAdvGroupBox
      Left = 5
      Top = 168
      Width = 325
      Height = 80
      Align = alTop
      Caption = ' Modelo/S'#233'rie '
      TabOrder = 3
      object cbx_Modelo: TAdvComboBox
        Left = 174
        Top = 20
        Width = 100
        Height = 24
        Color = clWindow
        Version = '1.5.1.0'
        Visible = True
        Style = csDropDownList
        EmptyTextStyle = []
        DropWidth = 0
        Enabled = True
        ItemIndex = 2
        Items.Strings = (
          'NF-e(55)'
          'NFC-e(65)'
          'TODOS')
        LabelCaption = 'Modelo:'
        LabelMargin = 2
        LabelTransparent = True
        LabelFont.Charset = DEFAULT_CHARSET
        LabelFont.Color = clNavy
        LabelFont.Height = -11
        LabelFont.Name = 'Tahoma'
        LabelFont.Style = []
        TabOrder = 0
        Text = 'TODOS'
      end
      object edt_NSerie: TAdvEdit
        Left = 174
        Top = 50
        Width = 100
        Height = 22
        EditAlign = eaCenter
        EditType = etNumeric
        EmptyTextStyle = []
        LabelCaption = 'N'#250'mero de S'#233'rie:'
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
        TabOrder = 1
        Text = '0'
        Visible = True
        Version = '3.3.2.0'
      end
    end
    object AdvGroupBox1: TAdvGroupBox
      Left = 5
      Top = 18
      Width = 325
      Height = 50
      RoundEdges = True
      Align = alTop
      Caption = ' Chave da NFe '
      TabOrder = 0
      object edt_Chave: TMaskEdit
        Left = 10
        Top = 20
        Width = 304
        Height = 22
        AutoSize = False
        TabOrder = 0
      end
    end
  end
end
