object frm_Condutor: Tfrm_Condutor
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = '.:Cadastro de condutores de veiculo com tra'#231#227'o:.'
  ClientHeight = 292
  ClientWidth = 634
  Color = clWindow
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  DesignSize = (
    634
    292)
  PixelsPerInch = 96
  TextHeight = 14
  object JvGradient1: TJvGradient
    Left = 0
    Top = 0
    Width = 634
    Height = 252
    StartColor = clBtnFace
    EndColor = clSilver
    ExplicitTop = -1
  end
  object pnl_Footer: TJvFooter
    Left = 0
    Top = 252
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
    object btn_Close: TJvFooterBtn
      Left = 536
      Top = 5
      Width = 90
      Height = 30
      Anchors = [akRight, akBottom]
      Caption = 'Fechar'
      TabOrder = 0
      TabStop = False
      OnClick = btn_CloseClick
      ButtonIndex = 0
      SpaceInterval = 6
    end
    object btn_New: TJvFooterBtn
      Left = 8
      Top = 5
      Width = 90
      Height = 30
      Hint = 'Inicializa cadastro de um novo ve'#237'culo'
      Anchors = [akLeft, akBottom]
      Caption = 'Novo'
      TabOrder = 1
      OnClick = btn_NewClick
      Alignment = taLeftJustify
      ButtonIndex = 1
      SpaceInterval = 6
    end
    object btn_Edit: TJvFooterBtn
      Left = 102
      Top = 5
      Width = 90
      Height = 30
      Anchors = [akLeft, akBottom]
      Caption = 'Editar'
      TabOrder = 5
      OnClick = btn_EditClick
      Alignment = taLeftJustify
      ButtonIndex = 2
      SpaceInterval = 6
    end
    object btn_Save: TJvFooterBtn
      Left = 198
      Top = 5
      Width = 90
      Height = 30
      Hint = 'Grava dados do veiculo'
      Anchors = [akLeft, akBottom]
      Caption = 'Salvar'
      TabOrder = 2
      OnClick = btn_SaveClick
      Alignment = taLeftJustify
      ButtonIndex = 3
      SpaceInterval = 6
    end
    object btn_Cancel: TJvFooterBtn
      Left = 294
      Top = 5
      Width = 90
      Height = 30
      Anchors = [akLeft, akBottom]
      Caption = 'Cancelar'
      TabOrder = 3
      OnClick = btn_CancelClick
      Alignment = taLeftJustify
      ButtonIndex = 4
      SpaceInterval = 6
    end
    object btn_Delete: TJvFooterBtn
      Left = 390
      Top = 5
      Width = 90
      Height = 30
      Anchors = [akLeft, akBottom]
      Caption = 'Excluir'
      TabOrder = 4
      OnClick = btn_DeleteClick
      Alignment = taLeftJustify
      ButtonIndex = 5
      SpaceInterval = 6
    end
  end
  object gbx_Veiculo: TAdvGroupBox
    Left = 5
    Top = 30
    Width = 621
    Height = 216
    BorderColor = clBlue
    RoundEdges = True
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 1
    object lbl_ResetCombo: TLabel
      Left = 402
      Top = 91
      Width = 145
      Height = 13
      Caption = 'Tecla [back] reset Combo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clInfoBk
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
      Visible = False
    end
    object edt_CNPJ: TAdvMaskEdit
      Left = 247
      Top = 39
      Width = 130
      Height = 20
      AutoSize = False
      Color = clWindow
      Enabled = True
      TabOrder = 1
      Text = '00.000.000/0000-00'
      Visible = True
      AutoFocus = False
      Flat = False
      FlatLineColor = clBlack
      FlatParentColor = True
      ShowModified = False
      FocusColor = clWindow
      FocusBorder = False
      FocusFontColor = clBlack
      LabelCaption = 'CPF:'
      LabelAlwaysEnabled = False
      LabelPosition = lpLeftTop
      LabelMargin = 3
      LabelTransparent = True
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
      ModifiedColor = clRed
      SelectFirstChar = False
      Version = '3.3.2.0'
    end
    object edt_Nome: TAdvEdit
      Left = 247
      Top = 61
      Width = 300
      Height = 20
      EmptyTextStyle = []
      LabelCaption = 'Nome:'
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
      TabOrder = 2
      Text = 'edt_Nome'
      Visible = True
      Version = '3.3.2.0'
    end
    object edt_RNTRC: TAdvEdit
      Left = 287
      Top = 123
      Width = 125
      Height = 20
      EmptyTextStyle = []
      LabelCaption = 'R.N.T.R.C.:'
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
      TabOrder = 4
      ValidChars = '0123456789'
      Visible = True
      Version = '3.3.2.0'
    end
    object cbx_TipPes: TAdvComboBox
      Left = 224
      Top = 10
      Width = 125
      Height = 22
      Color = clWindow
      Version = '1.5.1.0'
      Visible = True
      Style = csDropDownList
      EmptyTextStyle = []
      DropWidth = 0
      Enabled = True
      ItemIndex = 0
      Items.Strings = (
        'F'#237'sica'
        'Juridica')
      LabelCaption = 'Tipo de Pessoa:'
      LabelMargin = 3
      LabelTransparent = True
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
      TabOrder = 0
      Text = 'F'#237'sica'
      OnChange = cbx_TipPesChange
    end
    object cbx_TipProp: TAdvComboBox
      Left = 247
      Top = 91
      Width = 130
      Height = 22
      Color = clWindow
      Version = '1.5.1.0'
      Visible = True
      Style = csDropDownList
      EmptyTextStyle = []
      DropWidth = 0
      Enabled = True
      ItemIndex = -1
      Items.Strings = (
        '0-TAC Agregado'
        '1-TAC Independente'
        '2-Outros')
      LabelCaption = 'O condutor '#233' propriet'#225'rio de ve'#237'culo:'
      LabelMargin = 3
      LabelTransparent = True
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
      TabOrder = 3
      OnChange = cbx_TipPropChange
    end
    object edt_IE: TAdvEdit
      Left = 287
      Top = 145
      Width = 125
      Height = 20
      EmptyTextStyle = []
      LabelCaption = 'I.E.:'
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
      TabOrder = 5
      ValidChars = '0123456789'
      Visible = True
      Version = '3.3.2.0'
    end
    object cbx_UF: TAdvComboBox
      Left = 287
      Top = 167
      Width = 125
      Height = 22
      Color = clWindow
      Version = '1.5.1.0'
      Visible = True
      Style = csDropDownList
      EmptyTextStyle = []
      DropWidth = 0
      Enabled = True
      ItemIndex = -1
      LabelCaption = 'U.F.:'
      LabelMargin = 3
      LabelTransparent = True
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
      TabOrder = 6
    end
  end
  object edt_Codigo: TAdvEditBtn
    Left = 157
    Top = 4
    Width = 121
    Height = 20
    EmptyText = 'Digite aqui um c'#243'digo/nome'
    EmptyTextStyle = []
    Flat = False
    LabelCaption = 'C'#243'digo:'
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
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    ReadOnly = False
    TabOrder = 2
    Visible = True
    Version = '1.3.5.0'
    ButtonStyle = bsButton
    ButtonWidth = 25
    Etched = False
    ButtonCaption = '...'
    OnClickBtn = edt_CodigoClickBtn
  end
  object lbl_State: TStaticText
    Left = 370
    Top = 4
    Width = 256
    Height = 20
    Alignment = taCenter
    Anchors = [akTop, akRight]
    AutoSize = False
    BorderStyle = sbsSingle
    Caption = 'lbl_State'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
  end
end
