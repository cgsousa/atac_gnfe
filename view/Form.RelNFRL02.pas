unit Form.RelNFRL02;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  RLReport, RLXLSFilter, RLPDFFilter, RLHTMLFilter, RLFilters,
  RLRichFilter, RLDraftFilter,
  unotfis00;

type
  Tfrm_RelNFRL02 = class(TForm)
    RL_NF: TRLReport;
    RLRichFilter1: TRLRichFilter;
    band_Cab: TRLSubDetail;
    band_Footer: TRLBand;
    RLLabel1: TRLLabel;
    RLLabel2: TRLLabel;
    lbl_LastPag: TRLSystemInfo;
    band_SubItems: TRLSubDetail;
    band_Detail: TRLBand;
    lbl_LinItem: TRLLabel;
    RLPDFFilter1: TRLPDFFilter;
    RLXLSFilter1: TRLXLSFilter;
    bnd_InfoCliche: TRLBand;
    pnl_Cliche: TRLPanel;
    lbl_Company: TRLLabel;
    txt_Endere: TRLMemo;
    lbl_SystemName: TRLLabel;
    lbl_Date: TRLSystemInfo;
    lbl_Now: TRLSystemInfo;
    band_Column: TRLBand;
    lbl_Title: TRLLabel;
    lbl_Columns: TRLLabel;
    lbl_SubTitle1: TRLLabel;
    lbl_SubTitle2: TRLLabel;
    procedure RL_NFBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure RL_NFDataRecord(Sender: TObject; RecNo, CopyNo: Integer;
      var Eof: Boolean; var RecordAction: TRLRecordAction);
    procedure band_SubItemsDataRecord(Sender: TObject; RecNo, CopyNo: Integer;
      var Eof: Boolean; var RecordAction: TRLRecordAction);
    procedure band_DetailBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure band_CabDataRecord(Sender: TObject; RecNo, CopyNo: Integer;
      var Eof: Boolean; var RecordAction: TRLRecordAction);
  private
    { Private declarations }
    m_IndexItem: Integer;
    procedure InitDados ;
  protected
    m_Lote: TCNotFis00Lote;
  public
    { Public declarations }
    class procedure Execute (alote: TCNotFis00Lote);
  end;


implementation

{$R *.dfm}

uses DateUtils, MaskUtils,
  uadodb,
  FDM.NFE ;



{ Tfrm_RelNFRL00 }

class procedure Tfrm_RelNFRL02.Execute(alote: TCNotFis00Lote);
var
  R: Tfrm_RelNFRL02;
begin
    R :=Tfrm_RelNFRL02.Create(Application);
    try
        R.m_Lote :=alote ;
        R.RL_NF.PreviewModal ;
    finally
        FreeAndNil(R);
    end;
end;

procedure Tfrm_RelNFRL02.InitDados;
var
  S: string ;
begin

    //
    // Company, endereco
    //
    lbl_Company.Caption :=Trim(Empresa.xFant) ;
    if lbl_Company.Caption = '' then
    begin
        lbl_Company.Caption :=Trim(Empresa.RzSoci) ;
    end;
    txt_Endere.Lines.Clear ;
    txt_Endere.Lines.Add(Empresa.xEnder) ;

    //
    // ERP-Atac Automação Comercial
    //
    lbl_SystemName.Caption :='Atac Automação Comercial';

    //
    // titulo & sub-titulo
    //
    lbl_Title.Caption :='** Resumo de Notas Fiscais Emitidas **';

    S :='';
    //
    // Num.ped
    if m_Lote.Filter.pedini > 0 then
    begin
        S :=Format('Filtro: Num.Venda: %d A %d',[m_Lote.Filter.pedini,m_Lote.Filter.pedfin]);
    end
    else begin
        {//
        // Num.NF
        if m_Lote.Filter.ntfini > 0 then
        begin
            S :=Format('Filtro: Num.NF: %d A %d',[m_Lote.Filter.ntfini,m_Lote.Filter.ntffin]);
        end }
        //
        // periodo
        S :=FormatDateTime('"Filtro: "dd/mm/yyyy',m_Lote.Filter.datini, LocalFormatSettings);
        S :=S +FormatDateTime('" A "dd/mm/yyyy',m_Lote.Filter.datfin, LocalFormatSettings);
        case m_Lote.Filter.status of
            sttDoneSend: S :=S +', [Pronto para envio]';
            sttConting: S :=S +', [Contingência]';
            sttProcess: S :=S +', [Processadas]';
            sttCancel: S :=S +', [Canceladas]';
            sttError: S :=S +', [Erros]';
        else
            S :=S +', [Situação: Todas]';
        end;

        //
        // Modelo
        if m_Lote.Filter.codmod > 0 then
        begin
            S :=S +Format(', [Modelo: %d]',[m_Lote.Filter.codmod]);
        end;
    end;
    lbl_SubTitle1.Caption :=S;
    lbl_SubTitle2.Caption :=Format('TOTAL =>  %d nota(s), %15.2m',[
                                                    m_Lote.Items.Count,
                                                    m_Lote.vTotalNF ]);
    //lbl_SubTitle2.Alignment :=taRightJustify;
end;

procedure Tfrm_RelNFRL02.RL_NFBeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin

  //ConfigureVariavies(tiRetrato);

  with RL_NF.Margins do
  begin
      TopMargin     :=2;
      BottomMargin  :=20;
      LeftMargin    :=1;
      RightMargin   :=1;
  end;

  InitDados ;
  RL_NF.Title :='Resumo de Notas Fiscais Emitidas';
  RL_NF.PreviewOptions.Caption :=RL_NF.Title ;

end;

procedure Tfrm_RelNFRL02.RL_NFDataRecord(Sender: TObject; RecNo,
  CopyNo: Integer; var Eof: Boolean; var RecordAction: TRLRecordAction);
begin
    Eof := (RecNo > 1);
    RecordAction :=raUseIt;
end;

procedure Tfrm_RelNFRL02.band_CabDataRecord(Sender: TObject; RecNo,
  CopyNo: Integer; var Eof: Boolean; var RecordAction: TRLRecordAction);
begin
    Eof := (RecNo > 1);
    RecordAction := raUseIt;
end;

procedure Tfrm_RelNFRL02.band_DetailBeforePrint(Sender: TObject;
  var PrintIt: Boolean);
var
    N: TCNotFis00 ;
    vlr: string ;
begin
    N :=m_Lote.Items[m_IndexItem] ;

    //vlr :=Format('%12.2n',[N.m_icmstot.vNF]);
    lbl_LinItem.Caption :=Format('%.2d   %.6d    %d %.3d %12.2n',
                            [m_IndexItem+1,N.m_numdoc,N.m_codmod,N.m_nserie,N.m_icmstot.vNF])
end;

procedure Tfrm_RelNFRL02.band_SubItemsDataRecord(Sender: TObject; RecNo,
  CopyNo: Integer; var Eof: Boolean; var RecordAction: TRLRecordAction);
begin
    m_IndexItem :=RecNo -1 ;
    Eof := (RecNo > m_Lote.Items.Count) ;
    RecordAction := raUseIt ;
end;

end.
