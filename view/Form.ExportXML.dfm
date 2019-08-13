object frm_ExportXML: Tfrm_ExportXML
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  BorderWidth = 3
  Caption = '.:Exporta XML da NF-e:.'
  ClientHeight = 446
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
  object pnl_Footer: TJvFooter
    Left = 0
    Top = 406
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
    ExplicitTop = 229
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
    TabOrder = 1
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
  object txt_LOG: TJvRichEdit
    Left = 0
    Top = 20
    Width = 628
    Height = 386
    Align = alClient
    BorderWidth = 3
    Color = clGradientInactiveCaption
    Flat = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Trebuchet MS'
    Font.Style = []
    Lines.Strings = (
      'Caixa N'#250'mero 01:'
      '  Data/Hora inicio: 00/00/0000 00:00'
      '  Data/Hora fim: 00/00/0000 00:00')
    ParentFlat = False
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 2
    ExplicitTop = 19
  end
end
