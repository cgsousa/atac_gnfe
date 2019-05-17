object frm_RelNFRL02: Tfrm_RelNFRL02
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'frm_RelNFRL02'
  ClientHeight = 572
  ClientWidth = 312
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
    Left = 2
    Top = 0
    Width = 302
    Height = 1512
    Margins.LeftMargin = 1.000000000000000000
    Margins.TopMargin = 2.000000000000000000
    Margins.RightMargin = 1.000000000000000000
    Margins.BottomMargin = 20.000000000000000000
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -9
    Font.Name = 'Arial'
    Font.Style = []
    PageSetup.PaperSize = fpCustom
    PageSetup.PaperWidth = 80.000000000000000000
    PageSetup.PaperHeight = 400.000000000000000000
    BeforePrint = RL_NFBeforePrint
    OnDataRecord = RL_NFDataRecord
    object band_Cab: TRLSubDetail
      Left = 4
      Top = 8
      Width = 294
      Height = 195
      Borders.Sides = sdCustom
      Borders.DrawLeft = False
      Borders.DrawTop = False
      Borders.DrawRight = False
      Borders.DrawBottom = False
      Borders.Width = 2
      OnDataRecord = band_CabDataRecord
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
      object bnd_InfoCliche: TRLBand
        Left = 0
        Top = 0
        Width = 294
        Height = 109
        AutoSize = True
        object pnl_Cliche: TRLPanel
          Left = 0
          Top = 0
          Width = 294
          Height = 109
          Align = faClientTop
          AutoExpand = True
          AutoSize = True
          Borders.Sides = sdCustom
          Borders.DrawLeft = False
          Borders.DrawTop = False
          Borders.DrawRight = False
          Borders.DrawBottom = True
          object lbl_Company: TRLLabel
            Left = 0
            Top = 0
            Width = 294
            Height = 18
            Align = faTop
            Alignment = taCenter
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Trebuchet MS'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object txt_Endere: TRLMemo
            Tag = 703
            Left = 0
            Top = 18
            Width = 294
            Height = 36
            Align = faTop
            Alignment = taCenter
            Behavior = [beSiteExpander]
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Trebuchet MS'
            Font.Style = [fsBold]
            Lines.Strings = (
              'Linha #1'
              'Linha #2')
            ParentFont = False
          end
          object lbl_SystemName: TRLLabel
            Left = 0
            Top = 54
            Width = 294
            Height = 18
            Align = faTop
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = 'Trebuchet MS'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lbl_Date: TRLSystemInfo
            Left = 0
            Top = 72
            Width = 114
            Height = 18
            Align = faLeftTop
            AutoSize = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Trebuchet MS'
            Font.Style = []
            ParentFont = False
            Text = 'Data: '
          end
          object lbl_Now: TRLSystemInfo
            Left = 180
            Top = 72
            Width = 114
            Height = 18
            Align = faRightTop
            Alignment = taRightJustify
            AutoSize = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Trebuchet MS'
            Font.Style = []
            Info = itHour
            ParentFont = False
            Text = 'Hora: '
          end
        end
      end
      object band_Column: TRLBand
        Left = 0
        Top = 109
        Width = 294
        Height = 57
        AutoSize = True
        Borders.Sides = sdCustom
        Borders.DrawLeft = False
        Borders.DrawTop = False
        Borders.DrawRight = False
        Borders.DrawBottom = True
        Color = clWhite
        ParentColor = False
        Transparent = False
        object lbl_Title: TRLLabel
          Left = 0
          Top = 0
          Width = 294
          Height = 12
          Align = faTop
          Alignment = taCenter
          Layout = tlCenter
        end
        object lbl_Columns: TRLLabel
          Left = 0
          Top = 40
          Width = 294
          Height = 16
          Align = faTop
          AutoSize = False
          Caption = '  #|N'#250'mero NF|Modelo|S'#233'rie|R$ Valor total'
          Transparent = False
        end
        object lbl_SubTitle1: TRLLabel
          Left = 0
          Top = 12
          Width = 294
          Height = 12
          Align = faTop
          Layout = tlCenter
        end
        object lbl_SubTitle2: TRLLabel
          Left = 0
          Top = 24
          Width = 294
          Height = 16
          Align = faTop
          Alignment = taRightJustify
          Borders.Sides = sdCustom
          Borders.DrawLeft = True
          Borders.DrawTop = True
          Borders.DrawRight = True
          Borders.DrawBottom = True
          Color = 15461344
          Layout = tlCenter
          ParentColor = False
          Transparent = False
        end
      end
    end
    object band_Footer: TRLBand
      Left = 4
      Top = 225
      Width = 294
      Height = 15
      BandType = btSummary
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
        Align = faLeftTop
        Caption = 'Atac Sistemas / atacsistemas.com'
      end
      object RLLabel2: TRLLabel
        Left = 219
        Top = 1
        Width = 75
        Height = 13
        Align = faRightTop
        Alignment = taRightJustify
        Caption = 'Form.RelNFRL02.pas'
      end
    end
    object band_SubItems: TRLSubDetail
      Left = 4
      Top = 203
      Width = 294
      Height = 22
      AllowedBands = [btDetail]
      OnDataRecord = band_SubItemsDataRecord
      object band_Detail: TRLBand
        Left = 0
        Top = 0
        Width = 294
        Height = 12
        AutoSize = True
        Borders.Sides = sdCustom
        Borders.DrawLeft = False
        Borders.DrawTop = False
        Borders.DrawRight = False
        Borders.DrawBottom = False
        Borders.Style = bsClear
        BeforePrint = band_DetailBeforePrint
        object lbl_LinItem: TRLLabel
          Left = 0
          Top = 0
          Width = 294
          Height = 12
          Align = faTop
          Caption = '123456789012345678901234567890123456789012345678901234'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Courier New'
          Font.Style = []
          ParentFont = False
        end
      end
    end
  end
  object RLRichFilter1: TRLRichFilter
    DisplayName = 'Formato RichText'
    Left = 176
    Top = 280
  end
  object RLPDFFilter1: TRLPDFFilter
    DocumentInfo.Creator = 
      'FortesReport Community Edition v4.0 \251 Copyright '#169' 1999-2015 F' +
      'ortes Inform'#225'tica'
    DisplayName = 'Documento PDF'
    Left = 32
    Top = 280
  end
  object RLXLSFilter1: TRLXLSFilter
    DisplayName = 'Planilha Excel 97-2013'
    Left = 104
    Top = 280
  end
end
