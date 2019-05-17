object frm_BaseReportFr: Tfrm_BaseReportFr
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'frm_BaseReportFr'
  ClientHeight = 572
  ClientWidth = 794
  Color = clWindow
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object rl_BaseReport: TRLReport
    Left = 0
    Top = 0
    Width = 794
    Height = 1123
    Margins.LeftMargin = 8.000000000000000000
    Margins.TopMargin = 8.000000000000000000
    Margins.RightMargin = 8.000000000000000000
    Margins.BottomMargin = 8.000000000000000000
    AllowedBands = [btHeader, btDetail, btFooter]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
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
        Top = 0
        Width = 600
        Height = 22
        Anchors = [fkLeft, fkTop, fkRight]
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
        Anchors = [fkLeft, fkTop, fkRight]
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
        Anchors = [fkRight, fkBottom]
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
        Anchors = [fkRight, fkBottom]
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
        Anchors = [fkRight, fkBottom]
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
        Anchors = [fkLeft, fkTop, fkRight]
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
        Anchors = [fkRight, fkBottom]
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
      Top = 200
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
      object lbl_CompanyName: TRLLabel
        Left = 0
        Top = 1
        Width = 120
        Height = 14
        Align = faClientLeft
        Caption = 'Atac Sistemas / atacsistemas.com'
      end
      object lbl_UnitName: TRLLabel
        Left = 659
        Top = 1
        Width = 75
        Height = 14
        Align = faClientRight
        Alignment = taRightJustify
        Caption = 'Form.RelNFRL00.pas'
      end
    end
  end
  object RLXLSFilter1: TRLXLSFilter
    DisplayName = 'Planilha Excel 97-2013'
    Left = 224
    Top = 8
  end
  object RLPDFFilter1: TRLPDFFilter
    DocumentInfo.Creator = 
      'FortesReport Community Edition v4.0 \251 Copyright '#169' 1999-2015 F' +
      'ortes Inform'#225'tica'
    DisplayName = 'Documento PDF'
    Left = 168
    Top = 8
  end
  object RLRichFilter1: TRLRichFilter
    DisplayName = 'Formato RichText'
    Left = 280
    Top = 8
  end
end
