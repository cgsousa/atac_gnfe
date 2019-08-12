object frm_ExportXML: Tfrm_ExportXML
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  BorderWidth = 3
  Caption = '.:Exporta XML da NF-e:.'
  ClientHeight = 209
  ClientWidth = 628
  Color = clWindow
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object AdvOfficeStatusBar1: TAdvOfficeStatusBar
    Left = 0
    Top = 188
    Width = 628
    Height = 21
    AnchorHint = False
    Panels = <
      item
        Alignment = taCenter
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
        Text = 'Nenhum'
        TimeFormat = 'hh:mm:ss'
        Width = 75
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
        Text = 'Total: R$99,999,999.99'
        TimeFormat = 'hh:mm:ss'
        Width = 140
      end
      item
        AppearanceStyle = psLight
        DateFormat = 'dd/MM/yyyy'
        Progress.BackGround = clNone
        Progress.Indication = piPercentage
        Progress.Min = 0
        Progress.Max = 100
        Progress.Position = 50
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
        Progress.Stacked = True
        Style = psProgress
        TimeFormat = 'hh:mm:ss'
        Width = 250
      end>
    ShowSplitter = True
    SimplePanel = False
    Version = '1.5.2.2'
  end
  object pnl_Footer: TJvFooter
    Left = 0
    Top = 148
    Width = 628
    Height = 40
    Align = alBottom
    BevelStyle = bsRaised
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Trebuchet MS'
    Font.Style = []
    ParentFont = False
    ExplicitTop = 142
    DesignSize = (
      628
      40)
    object btn_Start: TJvFooterBtn
      Left = 416
      Top = 5
      Width = 100
      Height = 30
      Anchors = [akRight, akBottom]
      Caption = 'Executar'
      TabOrder = 1
      OnClick = btn_StartClick
      ButtonIndex = 0
      SpaceInterval = 6
    end
    object btn_Stop: TJvFooterBtn
      Left = 8
      Top = 5
      Width = 100
      Height = 30
      Anchors = [akLeft, akBottom]
      Caption = 'Parar'
      TabOrder = 2
      Visible = False
      Alignment = taLeftJustify
      ButtonIndex = 1
      SpaceInterval = 6
    end
    object btn_ViewLOG: TJvFooterBtn
      Left = 112
      Top = 5
      Width = 100
      Height = 30
      Anchors = [akLeft, akBottom]
      Caption = 'Atividades...'
      TabOrder = 3
      Visible = False
      Alignment = taLeftJustify
      ButtonIndex = 2
      SpaceInterval = 6
    end
    object btn_Close: TJvFooterBtn
      Left = 520
      Top = 5
      Width = 100
      Height = 30
      Anchors = [akRight, akBottom]
      Caption = 'Fechar'
      TabOrder = 0
      OnClick = btn_CloseClick
      ButtonIndex = 3
      SpaceInterval = 6
    end
  end
  object gbx_InfoCX: TAdvGroupBox
    Left = 0
    Top = 20
    Width = 628
    Height = 50
    Align = alTop
    Caption = ' Informa'#231#245'es do Caixa '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object lbl_Info: TGradientLabel
      Left = 2
      Top = 23
      Width = 624
      Height = 25
      Align = alBottom
      Alignment = taCenter
      AutoSize = False
      Caption = 'lbl_Info'
      Color = clGradientActiveCaption
      ParentColor = False
      ColorTo = clGradientInactiveCaption
      EllipsType = etNone
      GradientType = gtFullHorizontal
      GradientDirection = gdLeftToRight
      Indent = 0
      Orientation = goHorizontal
      TransparentText = False
      VAlignment = vaCenter
      Version = '1.2.0.0'
      ExplicitLeft = 3
      ExplicitTop = 19
    end
  end
  object edt_Local: TAdvDirectoryEdit
    Left = 82
    Top = 0
    Width = 546
    Height = 20
    BorderColor = clHighlight
    EmptyTextStyle = []
    Flat = False
    LabelCaption = 'Local principal:'
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
    Align = alTop
    Color = clWindow
    ReadOnly = False
    TabOrder = 3
    Visible = True
    Version = '1.3.5.0'
    ButtonStyle = bsButton
    ButtonWidth = 25
    Etched = False
    Glyph.Data = {
      CE000000424DCE0000000000000076000000280000000C0000000B0000000100
      0400000000005800000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00F00000000FFF
      00000088888880FF00000B088888880F00000BB08888888000000BBB00000000
      00000BBBBBBB0B0F00000BBB00000B0F0000F000BBBBBB0F0000FF0BBBBBBB0F
      0000FF0BBB00000F0000FFF000FFFFFF0000}
    BrowseDialogText = 'Select Directory'
    ExplicitLeft = 164
    ExplicitWidth = 465
  end
  object pnl_ResultProcess: TAdvPanel
    Left = 0
    Top = 70
    Width = 628
    Height = 76
    Align = alTop
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    UseDockManager = True
    Version = '2.3.0.0'
    BorderColor = clGray
    BorderWidth = 1
    Caption.Color = clGradientActiveCaption
    Caption.ColorTo = clGradientInactiveCaption
    Caption.Font.Charset = DEFAULT_CHARSET
    Caption.Font.Color = clHighlightText
    Caption.Font.Height = -11
    Caption.Font.Name = 'Tahoma'
    Caption.Font.Style = []
    Caption.Indent = 2
    Caption.Text = '<P align="center">RESULTADO</P>'
    Caption.Visible = True
    CollapsColor = clBtnFace
    CollapsDelay = 0
    ColorTo = 14938354
    Padding.Left = 5
    Padding.Top = 5
    Padding.Right = 5
    Padding.Bottom = 5
    ShadowColor = clBlack
    ShadowOffset = 0
    StatusBar.BorderColor = clSilver
    StatusBar.BorderStyle = bsSingle
    StatusBar.Font.Charset = DEFAULT_CHARSET
    StatusBar.Font.Color = clBlack
    StatusBar.Font.Height = -11
    StatusBar.Font.Name = 'Tahoma'
    StatusBar.Font.Style = []
    StatusBar.Color = 14938354
    StatusBar.ColorTo = clWhite
    StatusBar.Height = 21
    StatusBar.Visible = True
    Text = 
      '<p>Total: <font color="#004080"><b>35</b></font></p>  <p>Total c' +
      'om erros:<font color="#ff0000"><b>0</b></font></p>'
    FullHeight = 200
  end
end
