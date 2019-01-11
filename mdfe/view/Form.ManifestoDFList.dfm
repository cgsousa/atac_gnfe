object frm_ManifestoDFList: Tfrm_ManifestoDFList
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Lista de Manifesto de Documentos Fiscais Eletr'#244'nicos'
  ClientHeight = 572
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
  DesignSize = (
    1018
    572)
  PixelsPerInch = 96
  TextHeight = 14
  object pnl_Footer: TJvFooter
    Left = 0
    Top = 532
    Width = 1018
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
      1018
      40)
    object btn_New: TJvFooterBtn
      Left = 8
      Top = 5
      Width = 100
      Height = 30
      Action = act_New
      Anchors = [akLeft, akBottom]
      TabOrder = 0
      Alignment = taLeftJustify
      ButtonIndex = 0
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
      ButtonIndex = 1
      SpaceInterval = 6
      ExplicitLeft = 686
    end
    object btn_CadCdt: TJvFooterBtn
      Left = 112
      Top = 5
      Width = 100
      Height = 30
      Action = act_CadCdt
      Anchors = [akLeft, akBottom]
      TabOrder = 3
      Alignment = taLeftJustify
      ButtonIndex = 2
      SpaceInterval = 6
    end
    object btn_CadVei: TJvFooterBtn
      Left = 218
      Top = 5
      Width = 100
      Height = 30
      Action = act_CadVei
      Anchors = [akLeft, akBottom]
      TabOrder = 2
      Alignment = taLeftJustify
      ButtonIndex = 3
      SpaceInterval = 6
    end
  end
  object vst_Grid1: TVirtualStringTree
    Left = 5
    Top = 5
    Width = 1389
    Height = 485
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
    Columns = <
      item
        Color = 15000804
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coFixed, coAllowFocus]
        Position = 0
        Width = 75
        WideText = 'Id'
      end
      item
        Alignment = taCenter
        Position = 1
        Width = 75
        WideText = 'Tip.Emit'
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
        WideText = 'Num.Doc'
      end
      item
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
        Position = 5
        Width = 200
        WideText = 'Situa'#231#227'o'
      end
      item
        Alignment = taCenter
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
        Position = 6
        Width = 121
        WideText = 'Dt. Emiss'#227'o'
      end
      item
        Alignment = taCenter
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
        Position = 7
        Width = 90
        WideText = 'Tp. Emiss'#227'o'
      end
      item
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
        Position = 8
        Width = 55
        WideText = 'UF Ini'
      end
      item
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
        Position = 9
        Width = 55
        WideText = 'UF Fim'
      end
      item
        Alignment = taRightJustify
        CaptionAlignment = taCenter
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment]
        Position = 10
        Width = 90
        WideText = 'Qtd NFe'
      end
      item
        Alignment = taRightJustify
        CaptionAlignment = taCenter
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment]
        Position = 11
        Width = 90
        WideText = 'Valor Carga'
      end
      item
        Alignment = taRightJustify
        CaptionAlignment = taCenter
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment]
        Position = 12
        Width = 90
        WideText = 'Unid Medida'
      end
      item
        Alignment = taRightJustify
        CaptionAlignment = taCenter
        Color = clWindow
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment]
        Position = 13
        Width = 90
        WideText = 'Peso Bruto'
      end>
  end
  object ActionList1: TActionList
    Left = 456
    Top = 8
    object act_New: TAction
      Caption = 'Novo'
      Hint = 'Cria novo MDF-e'
      OnExecute = act_NewExecute
    end
    object act_CadVei: TAction
      Caption = 'Veiculos'
      Hint = 'Cadastra veiculo'
      OnExecute = act_CadVeiExecute
    end
    object act_CadCdt: TAction
      Caption = 'Contudores'
      Hint = 'Cadastra propri'#233'tario/contudor de ve'#237'culos'
      OnExecute = act_CadCdtExecute
    end
  end
  object ACBrMDFe1: TACBrMDFe
    Configuracoes.Geral.SSLLib = libNone
    Configuracoes.Geral.SSLCryptLib = cryNone
    Configuracoes.Geral.SSLHttpLib = httpNone
    Configuracoes.Geral.SSLXmlSignLib = xsNone
    Configuracoes.Geral.FormatoAlerta = 'TAG:%TAGNIVEL% ID:%ID%/%TAG%(%DESCRICAO%) - %MSG%.'
    Configuracoes.Arquivos.OrdenacaoPath = <>
    Configuracoes.WebServices.UF = 'SP'
    Configuracoes.WebServices.AguardarConsultaRet = 0
    Configuracoes.WebServices.QuebradeLinha = '|'
    Left = 384
    Top = 192
  end
end
