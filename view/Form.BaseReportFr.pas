unit Form.BaseReportFr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  RLReport, RLRichFilter, RLPDFFilter, RLFilters, RLXLSFilter;

type
  Tfrm_BaseReportFr = class(TForm)
    rl_BaseReport: TRLReport;
    band_Cab: TRLBand;
    lbl_Company: TRLLabel;
    txt_Endere: TRLMemo;
    lbl_Date: TRLSystemInfo;
    lbl_Now: TRLSystemInfo;
    lbl_Pag: TRLSystemInfo;
    lbl_SystemName: TRLLabel;
    lbl_LastPag: TRLSystemInfo;
    band_Column: TRLBand;
    lbl_Title: TRLLabel;
    lbl_SubTitle1: TRLLabel;
    lbl_SubTitle2: TRLLabel;
    band_Footer: TRLBand;
    lbl_CompanyName: TRLLabel;
    lbl_UnitName: TRLLabel;
    RLXLSFilter1: TRLXLSFilter;
    RLPDFFilter1: TRLPDFFilter;
    RLRichFilter1: TRLRichFilter;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_BaseReportFr: Tfrm_BaseReportFr;

implementation

{$R *.dfm}

end.
