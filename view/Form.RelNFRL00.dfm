object frm_RelNFRL00: Tfrm_RelNFRL00
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'frm_RelNFRL00'
  ClientHeight = 572
  ClientWidth = 794
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 14
  object RL_NF: TRLReport
    Left = 0
    Top = 0
    Width = 794
    Height = 1123
    Margins.LeftMargin = 8.000000000000000000
    Margins.TopMargin = 8.000000000000000000
    Margins.RightMargin = 8.000000000000000000
    Margins.BottomMargin = 8.000000000000000000
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    BeforePrint = RL_NFBeforePrint
    OnDataRecord = RL_NFDataRecord
    object band_Cab: TRLBand
      Left = 30
      Top = 30
      Width = 734
      Height = 80
      BandType = btHeader
      Borders.Sides = sdCustom
      Borders.DrawLeft = False
      Borders.DrawTop = False
      Borders.DrawRight = False
      Borders.DrawBottom = True
      Borders.Width = 2
      object lbl_Company: TRLLabel
        Left = 0
        Top = 1
        Width = 600
        Height = 22
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Trebuchet MS'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object txt_Endere: TRLMemo
        Tag = 703
        Left = 0
        Top = 24
        Width = 600
        Height = 33
        AutoSize = False
        Behavior = [beSiteExpander]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Trebuchet MS'
        Font.Style = [fsBold]
        Lines.Strings = (
          'Linha #1'
          'Linha #2')
        ParentFont = False
      end
      object lbl_Date: TRLSystemInfo
        Left = 620
        Top = 24
        Width = 114
        Height = 18
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Trebuchet MS'
        Font.Style = []
        ParentFont = False
        Text = 'Data: '
      end
      object lbl_Now: TRLSystemInfo
        Left = 620
        Top = 39
        Width = 114
        Height = 18
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Trebuchet MS'
        Font.Style = []
        Info = itHour
        ParentFont = False
        Text = 'Hora: '
      end
      object lbl_Pag: TRLSystemInfo
        Left = 620
        Top = 58
        Width = 88
        Height = 18
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Trebuchet MS'
        Font.Style = []
        Info = itPageNumber
        ParentFont = False
        Text = 'Pagina: '
      end
      object lbl_SystemName: TRLLabel
        Left = 0
        Top = 58
        Width = 600
        Height = 18
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Trebuchet MS'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbl_LastPag: TRLSystemInfo
        Left = 709
        Top = 58
        Width = 25
        Height = 18
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Trebuchet MS'
        Font.Style = []
        Info = itLastPageNumber
        ParentFont = False
        Text = '/'
      end
    end
    object band_Column: TRLBand
      Left = 30
      Top = 110
      Width = 734
      Height = 90
      BandType = btColumnHeader
      Borders.Sides = sdCustom
      Borders.DrawLeft = False
      Borders.DrawTop = False
      Borders.DrawRight = False
      Borders.DrawBottom = True
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Trebuchet MS'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
      object RLLabel3: TRLLabel
        Left = 67
        Top = 52
        Width = 38
        Height = 16
        Alignment = taCenter
        Caption = 'Modelo'
        Transparent = False
      end
      object RLLabel4: TRLLabel
        Left = 107
        Top = 52
        Width = 40
        Height = 16
        Alignment = taCenter
        Caption = 'N.S'#233'rie'
        Transparent = False
      end
      object lbl_Title: TRLLabel
        Left = 0
        Top = 0
        Width = 734
        Height = 18
        Align = faTop
        Alignment = taCenter
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Trebuchet MS'
        Font.Style = [fsBold]
        Layout = tlCenter
        ParentFont = False
      end
      object RLLabel5: TRLLabel
        Left = 0
        Top = 52
        Width = 57
        Height = 16
        Caption = 'N'#250'mero NF'
        Transparent = False
      end
      object RLLabel6: TRLLabel
        Left = 157
        Top = 52
        Width = 89
        Height = 16
        AutoSize = False
        Caption = 'Data emiss'#227'o'
        Transparent = False
      end
      object RLLabel7: TRLLabel
        Left = 266
        Top = 50
        Width = 150
        Height = 16
        AutoSize = False
        Caption = 'CPF/CNPJ'
        Transparent = False
      end
      object RLLabel10: TRLLabel
        Left = 422
        Top = 52
        Width = 65
        Height = 16
        Alignment = taCenter
        AutoSize = False
        Caption = 'Val. BC'
        Transparent = False
      end
      object RLLabel11: TRLLabel
        Left = 488
        Top = 52
        Width = 55
        Height = 16
        Alignment = taCenter
        AutoSize = False
        Caption = 'Val. ICMS'
        Transparent = False
      end
      object RLLabel12: TRLLabel
        Left = 544
        Top = 52
        Width = 56
        Height = 16
        Alignment = taCenter
        AutoSize = False
        Caption = 'Val. IPI'
        Transparent = False
      end
      object RLLabel13: TRLLabel
        Left = 601
        Top = 52
        Width = 66
        Height = 16
        Alignment = taCenter
        AutoSize = False
        Caption = 'Val.Produtos'
        Transparent = False
      end
      object RLLabel14: TRLLabel
        Left = 668
        Top = 52
        Width = 66
        Height = 16
        Alignment = taCenter
        AutoSize = False
        Caption = 'Val. NF'
        Transparent = False
      end
      object lbl_ChvCap: TRLLabel
        Left = 0
        Top = 72
        Width = 57
        Height = 16
        AutoSize = False
        Caption = 'Chave'
        Transparent = False
      end
      object RLLabel8: TRLLabel
        Left = 269
        Top = 72
        Width = 150
        Height = 16
        AutoSize = False
        Caption = 'Credor'
        Transparent = False
      end
      object RLLabel15: TRLLabel
        Left = 422
        Top = 72
        Width = 312
        Height = 16
        AutoSize = False
        Caption = 'Situa'#231#227'o / Protocolo'
        Transparent = False
      end
      object lbl_SubTitle1: TRLLabel
        Left = 0
        Top = 18
        Width = 734
        Height = 16
        Align = faTop
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Trebuchet MS'
        Font.Style = []
        Layout = tlCenter
        ParentFont = False
      end
      object lbl_SubTitle2: TRLLabel
        Left = 0
        Top = 34
        Width = 734
        Height = 18
        Align = faTop
        Alignment = taRightJustify
        Borders.Sides = sdCustom
        Borders.DrawLeft = True
        Borders.DrawTop = True
        Borders.DrawRight = True
        Borders.DrawBottom = True
        Color = 15461344
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Trebuchet MS'
        Font.Style = []
        Layout = tlCenter
        ParentColor = False
        ParentFont = False
        Transparent = False
      end
    end
    object band_Footer: TRLBand
      Left = 30
      Top = 250
      Width = 734
      Height = 15
      BandType = btFooter
      Borders.Sides = sdCustom
      Borders.DrawLeft = False
      Borders.DrawTop = True
      Borders.DrawRight = False
      Borders.DrawBottom = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -8
      Font.Name = 'Trebuchet MS'
      Font.Style = [fsItalic]
      ParentFont = False
      object RLLabel1: TRLLabel
        Left = 0
        Top = 1
        Width = 120
        Height = 13
        Caption = 'Atac Sistemas / atacsistemas.com'
      end
      object RLLabel2: TRLLabel
        Left = 659
        Top = 1
        Width = 75
        Height = 13
        Alignment = taRightJustify
        Caption = 'Form.RelNFRL00.pas'
      end
    end
    object band_SubItems: TRLSubDetail
      Left = 30
      Top = 200
      Width = 734
      Height = 50
      OnDataRecord = band_SubItemsDataRecord
      object band_Detail: TRLBand
        Left = 0
        Top = 0
        Width = 734
        Height = 45
        Borders.Sides = sdCustom
        Borders.DrawLeft = False
        Borders.DrawTop = False
        Borders.DrawRight = False
        Borders.DrawBottom = False
        Borders.Style = bsClear
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Trebuchet MS'
        Font.Style = []
        ParentFont = False
        BeforePrint = band_DetailBeforePrint
        object lbl_NumNF: TRLLabel
          Left = 0
          Top = 1
          Width = 39
          Height = 16
          AutoSize = False
          Caption = '000000'
        end
        object lbl_CodMod: TRLLabel
          Left = 78
          Top = 1
          Width = 16
          Height = 16
          Alignment = taCenter
          AutoSize = False
          Caption = '00'
        end
        object lbl_NSerie: TRLLabel
          Left = 116
          Top = 1
          Width = 22
          Height = 16
          Alignment = taCenter
          AutoSize = False
          Caption = '000'
        end
        object lbl_DtEmis: TRLLabel
          Left = 157
          Top = 1
          Width = 94
          Height = 16
          AutoSize = False
          Caption = '00/00/0000 00:00'
        end
        object lbl_ValBC: TRLLabel
          Left = 422
          Top = 1
          Width = 59
          Height = 16
          Alignment = taRightJustify
          AutoSize = False
          Caption = '000,000.00'
        end
        object lbl_ValICMS: TRLLabel
          Left = 490
          Top = 1
          Width = 53
          Height = 16
          Alignment = taRightJustify
          AutoSize = False
          Caption = '00,000.00'
        end
        object lbl_ValIPI: TRLLabel
          Left = 547
          Top = 1
          Width = 53
          Height = 16
          Alignment = taRightJustify
          AutoSize = False
          Caption = '00,000.00'
        end
        object lbl_ValProd: TRLLabel
          Left = 608
          Top = 1
          Width = 59
          Height = 16
          Alignment = taRightJustify
          AutoSize = False
          Caption = '000,000.00'
        end
        object lbl_ValNF: TRLLabel
          Left = 675
          Top = 1
          Width = 59
          Height = 16
          Alignment = taRightJustify
          AutoSize = False
          Caption = '000,000.00'
        end
        object lbl_Chave: TRLLabel
          Left = 0
          Top = 21
          Width = 267
          Height = 16
          AutoSize = False
          Caption = '00000000000000000000000000000000000000000000'
        end
        object lbl_Status: TRLLabel
          Left = 422
          Top = 21
          Width = 312
          Height = 16
          AutoSize = False
          Caption = 'Situa'#231#227'o'
          Transparent = False
        end
        object RLDraw1: TRLDraw
          Left = 0
          Top = 40
          Width = 734
          Height = 5
          Align = faClientBottom
          DrawKind = dkLine
          Pen.Style = psDashDotDot
        end
        object lbl_CpfCnpj: TRLLabel
          Left = 269
          Top = 1
          Width = 150
          Height = 16
          AutoSize = False
          Caption = '00.000.000/0000-00'
        end
        object lbl_Nome: TRLLabel
          Left = 269
          Top = 21
          Width = 150
          Height = 16
          AutoSize = False
          Caption = 'XXXXXXXXXXXXXXXXXXXXX'
        end
      end
    end
  end
  object RLRichFilter1: TRLRichFilter
    DisplayName = 'Formato RichText'
    Left = 544
    Top = 8
  end
  object RLPDFFilter1: TRLPDFFilter
    DocumentInfo.Creator = 
      'FortesReport Community Edition v4.0 \251 Copyright '#169' 1999-2015 F' +
      'ortes Inform'#225'tica'
    DisplayName = 'Documento PDF'
    Left = 400
    Top = 16
  end
  object RLXLSFilter1: TRLXLSFilter
    DisplayName = 'Planilha Excel 97-2013'
    Left = 344
    Top = 24
  end
end
