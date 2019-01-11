object frm_Veiculo: Tfrm_Veiculo
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = '.:Cadastro de veiculo com tra'#231#227'o:.'
  ClientHeight = 271
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
    271)
  PixelsPerInch = 96
  TextHeight = 14
  object JvGradient1: TJvGradient
    Left = 0
    Top = 0
    Width = 634
    Height = 231
    StartColor = clBtnFace
    EndColor = clSilver
    ExplicitTop = -1
  end
  object pnl_Footer: TJvFooter
    Left = 0
    Top = 231
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
      Alignment = taLeftJustify
      ButtonIndex = 5
      SpaceInterval = 6
    end
  end
  object gbx_Veiculo: TAdvGroupBox
    Left = 5
    Top = 30
    Width = 621
    Height = 195
    BorderColor = clBlue
    RoundEdges = True
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 1
    object edt_Placa: TAdvMaskEdit
      Left = 152
      Top = 40
      Width = 121
      Height = 20
      AutoSize = False
      Color = clWindow
      Enabled = True
      EditMask = '>LLLL\-9999;0; '
      MaxLength = 9
      TabOrder = 0
      Visible = True
      AutoFocus = False
      Flat = False
      FlatLineColor = clBlack
      FlatParentColor = True
      ShowModified = False
      FocusColor = clWindow
      FocusBorder = False
      FocusFontColor = clBlack
      LabelCaption = 'Placa:'
      LabelAlwaysEnabled = False
      LabelPosition = lpTopLeft
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
    object edt_RENAVAM: TAdvEdit
      Left = 288
      Top = 40
      Width = 121
      Height = 20
      EmptyTextStyle = []
      LabelCaption = 'RENAVAM:'
      LabelPosition = lpTopLeft
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
      Text = 'edt_RENAVAM'
      Visible = True
      Version = '3.3.2.0'
    end
    object edt_Tara: TAdvEdit
      Left = 152
      Top = 94
      Width = 121
      Height = 20
      EditType = etNumeric
      EmptyTextStyle = []
      LabelCaption = 'Tara em (Kg):'
      LabelPosition = lpTopLeft
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
      Text = '0'
      Visible = True
      Version = '3.3.2.0'
    end
    object edt_CapKg: TAdvEdit
      Left = 288
      Top = 94
      Width = 121
      Height = 20
      EditType = etNumeric
      EmptyTextStyle = []
      LabelCaption = 'Capacidade em (Kg):'
      LabelPosition = lpTopLeft
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
      TabOrder = 3
      Text = '0'
      Visible = True
      Version = '3.3.2.0'
    end
    object edt_CapM3: TAdvEdit
      Left = 424
      Top = 94
      Width = 121
      Height = 20
      EditType = etNumeric
      EmptyTextStyle = []
      LabelCaption = 'Capacidade em (M3):'
      LabelPosition = lpTopLeft
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
      Text = '0'
      Visible = True
      Version = '3.3.2.0'
    end
    object cbx_TipRod: TAdvComboBox
      Left = 152
      Top = 154
      Width = 121
      Height = 22
      Color = clWindow
      Version = '1.5.1.0'
      Visible = True
      Style = csDropDownList
      EmptyTextStyle = []
      DropWidth = 0
      Enabled = True
      ItemIndex = -1
      LabelCaption = 'Tipo de rodado:'
      LabelPosition = lpTopLeft
      LabelMargin = 3
      LabelTransparent = True
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
      TabOrder = 5
    end
    object cbx_TipCar: TAdvComboBox
      Left = 288
      Top = 154
      Width = 121
      Height = 22
      Color = clWindow
      Version = '1.5.1.0'
      Visible = True
      Style = csDropDownList
      EmptyTextStyle = []
      DropWidth = 0
      Enabled = True
      ItemIndex = -1
      LabelCaption = 'Tipo de carroceria:'
      LabelPosition = lpTopLeft
      LabelMargin = 3
      LabelTransparent = True
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
      TabOrder = 6
    end
    object cbx_UF: TAdvComboBox
      Left = 424
      Top = 154
      Width = 121
      Height = 22
      Color = clWindow
      Version = '1.5.1.0'
      Visible = True
      Style = csDropDownList
      EmptyTextStyle = []
      DropWidth = 0
      Enabled = True
      ItemIndex = -1
      LabelCaption = 'UF de licen'#231'a:'
      LabelPosition = lpTopLeft
      LabelMargin = 3
      LabelTransparent = True
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
      TabOrder = 7
    end
  end
  object edt_Codigo: TAdvEditBtn
    Left = 157
    Top = 4
    Width = 121
    Height = 20
    EditType = etNumeric
    EmptyText = 'Selecione um ve'#237'culo'
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
    Text = '0'
    Visible = True
    Version = '1.3.5.0'
    ButtonStyle = bsButton
    ButtonWidth = 25
    Etched = False
    ButtonCaption = '...'
    OnClickBtn = edt_CodigoClickBtn
  end
  object lbl_State: TStaticText
    Left = 294
    Top = 4
    Width = 256
    Height = 20
    Alignment = taCenter
    AutoSize = False
    BorderStyle = sbsSunken
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
