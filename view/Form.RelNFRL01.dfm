inherited frm_RelNFRL01: Tfrm_RelNFRL01
  Caption = 'frm_RelNFRL01'
  ClientWidth = 307
  ExplicitLeft = 8
  ExplicitWidth = 313
  PixelsPerInch = 96
  TextHeight = 13
  inherited rl_BaseReport: TRLReport
    Width = 302
    Height = 1512
    Margins.LeftMargin = 1.000000000000000000
    Margins.TopMargin = 2.000000000000000000
    Margins.RightMargin = 1.000000000000000000
    Margins.BottomMargin = 20.000000000000000000
    Font.Height = -9
    PageSetup.PaperSize = fpCustom
    PageSetup.PaperWidth = 80.000000000000000000
    PageSetup.PaperHeight = 400.000000000000000000
    ExplicitWidth = 302
    ExplicitHeight = 1512
    inherited band_Cab: TRLBand
      Left = 4
      Top = 8
      Width = 294
      Height = 100
      ExplicitLeft = 4
      ExplicitTop = 8
      ExplicitWidth = 294
      ExplicitHeight = 100
      inherited lbl_Company: TRLLabel
        Width = 294
        Align = faTop
        Alignment = taCenter
        Anchors = []
        AutoSize = True
        ExplicitWidth = 294
      end
      inherited lbl_Date: TRLSystemInfo [1]
        Left = 0
        Top = 76
        Width = 77
        Align = faLeftTop
        Anchors = []
        AutoSize = True
        ExplicitLeft = 0
        ExplicitTop = 76
        ExplicitWidth = 77
      end
      inherited lbl_Now: TRLSystemInfo [2]
        Left = 215
        Top = 76
        Width = 79
        Align = faRightTop
        Anchors = []
        AutoSize = True
        ExplicitLeft = 215
        ExplicitTop = 76
        ExplicitWidth = 79
      end
      inherited lbl_Pag: TRLSystemInfo [3]
        Left = 314
        Top = 31
        Anchors = []
        ExplicitLeft = 314
        ExplicitTop = 31
      end
      inherited lbl_SystemName: TRLLabel [4]
        Width = 294
        Align = faTop
        Anchors = []
        AutoSize = True
        ExplicitWidth = 294
      end
      inherited lbl_LastPag: TRLSystemInfo [5]
        Left = 408
        Top = 31
        Anchors = []
        ExplicitLeft = 408
        ExplicitTop = 31
      end
      inherited txt_Endere: TRLMemo [6]
        Top = 22
        Width = 294
        Height = 36
        Align = faTop
        Alignment = taCenter
        Anchors = []
        AutoSize = True
        ExplicitTop = 22
        ExplicitWidth = 294
        ExplicitHeight = 36
      end
    end
    inherited band_Column: TRLBand
      Left = 4
      Top = 108
      Width = 294
      ExplicitLeft = 4
      ExplicitTop = 108
      ExplicitWidth = 294
      inherited lbl_Title: TRLLabel
        Width = 294
        ExplicitWidth = 294
      end
      inherited lbl_SubTitle1: TRLLabel
        Width = 294
        ExplicitWidth = 294
      end
      inherited lbl_SubTitle2: TRLLabel
        Width = 294
        ExplicitWidth = 294
      end
    end
    inherited band_Footer: TRLBand
      Left = 4
      Top = 198
      Width = 294
      ExplicitLeft = 4
      ExplicitTop = 198
      ExplicitWidth = 294
      inherited lbl_UnitName: TRLLabel
        Left = 219
        ExplicitLeft = 219
      end
    end
  end
  inherited RLXLSFilter1: TRLXLSFilter
    Left = 248
    Top = 520
  end
  inherited RLPDFFilter1: TRLPDFFilter
    Left = 192
    Top = 520
  end
  inherited RLRichFilter1: TRLRichFilter
    Left = 304
    Top = 520
  end
end
