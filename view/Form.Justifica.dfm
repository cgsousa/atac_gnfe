object frm_Justif: Tfrm_Justif
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Justificativa'
  ClientHeight = 377
  ClientWidth = 544
  Color = clWindow
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 14
  object html_Prompt: THTMLabel
    Left = 8
    Top = 8
    Width = 528
    Height = 72
    ColorTo = clSilver
    AutoSizing = True
    BorderWidth = 1
    BorderStyle = bsSingle
    BorderColor = clBtnFace
    HTMLText.Strings = (
      
        '<FONT face="Verdana" color="#FF0000" size="12"><b>ATEN'#199#195'O!</b></' +
        'FONT><p></p><p></p><FONT face="Verdana" color="#FF0000" size="10' +
        '">Verifique junto ao admin/supervisor a correta inutiliza'#231#227'o de ' +
        'sequencia!</FONT><p></p><FONT face="Verdana" color="#FF0000" siz' +
        'e="10">Uma vez inutilizados, os n'#250'meros n'#227'o podem ser mais usado' +
        's!</FONT><P></P>')
    Transparent = True
    Version = '1.9.0.2'
  end
  object pnl_Inut: TPanel
    Left = 8
    Top = 101
    Width = 528
    Height = 186
    BevelOuter = bvNone
    TabOrder = 0
    object vst_Grid1: TVirtualStringTree
      Left = 0
      Top = 0
      Width = 528
      Height = 110
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
      Header.AutoSizeIndex = 0
      Header.Background = clBtnHighlight
      Header.Height = 21
      Header.Options = [hoColumnResize, hoDrag, hoShowImages, hoShowSortGlyphs, hoVisible]
      Header.ParentFont = True
      Header.Style = hsPlates
      ParentFont = False
      RootNodeCount = 3
      TabOrder = 0
      TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScroll, toAutoTristateTracking]
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toInitOnSave, toToggleOnDblClick, toWheelPanning]
      TreeOptions.PaintOptions = [toHotTrack, toShowDropmark, toShowHorzGridLines, toShowVertGridLines, toUseBlendedImages]
      TreeOptions.SelectionOptions = [toDisableDrawSelection, toExtendedFocus, toFullRowSelect, toMiddleClickSelect, toMultiSelect, toRightClickSelect, toCenterScrollIntoView]
      OnChange = vst_Grid1Change
      OnGetText = vst_Grid1GetText
      Columns = <
        item
          Color = 15000804
          Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
          Position = 0
          WideText = 'Ano'
        end
        item
          Color = clWindow
          Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coFixed, coAllowFocus]
          Position = 1
          Width = 150
          WideText = 'CNPJ'
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
          Width = 125
          WideText = #218'ltimo Num. Fiscal'
        end>
    end
    object AdvGroupBox1: TAdvGroupBox
      Left = 0
      Top = 116
      Width = 528
      Height = 70
      Align = alBottom
      Caption = ' Seq'#234'ncia a ser inutilizada '
      TabOrder = 1
      object edt_NumIni: TAdvEdit
        Left = 309
        Top = 14
        Width = 100
        Height = 20
        AutoThousandSeparator = False
        EditAlign = eaRight
        EditType = etNumeric
        EmptyTextStyle = []
        FocusBorder = True
        FocusBorderColor = clHotLight
        FocusColor = clGradientActiveCaption
        LabelCaption = 'N'#250'mero Inicial:'
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
        AutoSize = False
        Color = clGradientInactiveCaption
        TabOrder = 0
        Text = '0'
        Visible = True
        Version = '3.3.2.0'
      end
      object edt_NumFin: TAdvEdit
        Left = 309
        Top = 40
        Width = 100
        Height = 20
        AutoThousandSeparator = False
        EditAlign = eaRight
        EditType = etNumeric
        EmptyTextStyle = []
        FocusBorder = True
        FocusBorderColor = clHotLight
        FocusColor = clGradientActiveCaption
        LabelCaption = 'N'#250'mero Final:'
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
        AutoSize = False
        Color = clGradientInactiveCaption
        TabOrder = 1
        Text = '0'
        Visible = True
        Version = '3.3.2.0'
      end
    end
  end
  object pnl_Footer: TJvFooter
    Left = 0
    Top = 337
    Width = 544
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
      544
      40)
    object btn_OK: TJvFooterBtn
      Left = 332
      Top = 5
      Width = 100
      Height = 30
      Anchors = [akRight, akBottom]
      Caption = 'Confirmar'
      TabOrder = 0
      OnClick = btn_OKClick
      ButtonIndex = 0
      SpaceInterval = 6
      ExplicitLeft = 238
    end
    object btn_Close: TJvFooterBtn
      Left = 436
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
  object edt_Text: TAdvEdit
    AlignWithMargins = True
    Left = 3
    Top = 314
    Width = 538
    Height = 20
    AutoThousandSeparator = False
    EmptyText = 'M'#237'nimo 15 caracters'
    EmptyTextStyle = []
    FocusBorder = True
    FocusBorderColor = clHotLight
    FocusColor = clGradientActiveCaption
    LabelCaption = 'Informe uma justificativa:'
    LabelPosition = lpTopLeft
    LabelMargin = 3
    LabelTransparent = True
    LabelFont.Charset = DEFAULT_CHARSET
    LabelFont.Color = clGreen
    LabelFont.Height = -12
    LabelFont.Name = 'Tahoma'
    LabelFont.Style = []
    Lookup.Font.Charset = DEFAULT_CHARSET
    Lookup.Font.Color = clWindowText
    Lookup.Font.Height = -11
    Lookup.Font.Name = 'Arial'
    Lookup.Font.Style = []
    Lookup.Separator = ';'
    Align = alBottom
    AutoSize = False
    CharCase = ecUpperCase
    Color = clGradientInactiveCaption
    DoubleBuffered = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    Visible = True
    Version = '3.3.2.0'
  end
end
