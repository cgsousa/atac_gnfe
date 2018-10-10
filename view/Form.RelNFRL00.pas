unit Form.RelNFRL00;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  RLReport, RLXLSFilter, RLPDFFilter, RLHTMLFilter, RLFilters,
  RLRichFilter, RLDraftFilter,
  unotfis00;

type
  Tfrm_RelNFRL00 = class(TForm)
    RL_NF: TRLReport;
    RLRichFilter1: TRLRichFilter;
    band_Cab: TRLBand;
    lbl_Company: TRLLabel;
    txt_Endere: TRLMemo;
    lbl_Date: TRLSystemInfo;
    lbl_Now: TRLSystemInfo;
    lbl_Pag: TRLSystemInfo;
    lbl_SystemName: TRLLabel;
    band_Column: TRLBand;
    band_Footer: TRLBand;
    RLLabel1: TRLLabel;
    RLLabel2: TRLLabel;
    RLLabel3: TRLLabel;
    RLLabel4: TRLLabel;
    lbl_LastPag: TRLSystemInfo;
    band_SubItems: TRLSubDetail;
    band_Detail: TRLBand;
    lbl_NumNF: TRLLabel;
    lbl_CodMod: TRLLabel;
    lbl_NSerie: TRLLabel;
    lbl_DtEmis: TRLLabel;
    lbl_ValBC: TRLLabel;
    lbl_ValICMS: TRLLabel;
    lbl_ValIPI: TRLLabel;
    lbl_ValProd: TRLLabel;
    lbl_ValNF: TRLLabel;
    lbl_Chave: TRLLabel;
    RLPDFFilter1: TRLPDFFilter;
    RLXLSFilter1: TRLXLSFilter;
    lbl_Title: TRLLabel;
    RLLabel5: TRLLabel;
    RLLabel6: TRLLabel;
    RLLabel7: TRLLabel;
    RLLabel10: TRLLabel;
    RLLabel11: TRLLabel;
    RLLabel12: TRLLabel;
    RLLabel13: TRLLabel;
    RLLabel14: TRLLabel;
    lbl_ChvCap: TRLLabel;
    RLLabel8: TRLLabel;
    RLLabel15: TRLLabel;
    lbl_Status: TRLLabel;
    RLDraw1: TRLDraw;
    lbl_CpfCnpj: TRLLabel;
    lbl_Nome: TRLLabel;
    lbl_SubTitle1: TRLLabel;
    lbl_SubTitle2: TRLLabel;
    procedure RL_NFBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure RL_NFDataRecord(Sender: TObject; RecNo, CopyNo: Integer;
      var Eof: Boolean; var RecordAction: TRLRecordAction);
    procedure band_SubItemsDataRecord(Sender: TObject; RecNo, CopyNo: Integer;
      var Eof: Boolean; var RecordAction: TRLRecordAction);
    procedure band_DetailBeforePrint(Sender: TObject; var PrintIt: Boolean);
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

class procedure Tfrm_RelNFRL00.Execute(alote: TCNotFis00Lote);
var
  R: Tfrm_RelNFRL00;
begin
    R :=Tfrm_RelNFRL00.Create(Application);
    try
        R.m_Lote :=alote ;
        R.RL_NF.PreviewModal ;
    finally
        FreeAndNil(R);
    end;
end;

procedure Tfrm_RelNFRL00.InitDados;
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

procedure Tfrm_RelNFRL00.RL_NFBeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin

  //ConfigureVariavies(tiRetrato);

  with RL_NF.Margins do
  begin
      TopMargin     :=8;
      BottomMargin  :=8;
      LeftMargin    :=8;
      RightMargin   :=8;
  end;

  InitDados ;
  RL_NF.Title :='Resumo de Notas Fiscais Emitidas';
  RL_NF.PreviewOptions.Caption :=RL_NF.Title ;

end;

procedure Tfrm_RelNFRL00.RL_NFDataRecord(Sender: TObject; RecNo,
  CopyNo: Integer; var Eof: Boolean; var RecordAction: TRLRecordAction);
begin
    Eof := (RecNo > 1);
    RecordAction :=raUseIt;
end;

procedure Tfrm_RelNFRL00.band_DetailBeforePrint(Sender: TObject;
  var PrintIt: Boolean);
var
    N: TCNotFis00 ;
begin
    N :=m_Lote.Items[m_IndexItem] ;
    lbl_NumNF.Caption :=Format('%.6d',[N.m_numdoc]) ;
    lbl_CodMod.Caption :=Format('%d',[N.m_codmod]) ;
    lbl_NSerie.Caption :=Format('%.3d',[N.m_nserie]) ;
    if N.m_codmod = 55 then
        lbl_DtEmis.Caption :=FormatDateTime('dd/mm/yyyy',N.m_dtemis)
    else
        lbl_DtEmis.Caption :=FormatDateTime('dd/mm/yyyy hh:nn',N.m_dtemis) ;

    //
    // cpf/cnpj
    // credor/nome
    lbl_CpfCnpj.Caption :='';
    if N.m_dest.CNPJCPF <> '' then
    begin
        if Tdm_nfe.getInstance.IsCPF(N.m_dest.CNPJCPF) then
            lbl_CpfCnpj.Caption :=FormatMaskText('000\.000\.000\-00;0; ', N.m_dest.CNPJCPF)
        else
            lbl_CpfCnpj.Caption :=FormatMaskText('00\.000\.000\/0000\-00;0; ', N.m_dest.CNPJCPF);
    end;
    lbl_Nome.Caption :=N.m_dest.xNome;

    //
    // valores
    //
    lbl_ValBC.Caption :=CFrmtStr.Cur(N.m_icmstot.vBC);
    lbl_ValICMS.Caption :=CFrmtStr.Cur(N.m_icmstot.vICMS);
    lbl_ValIPI.Caption :=CFrmtStr.Cur(N.m_icmstot.vIPI);
    lbl_ValProd.Caption :=CFrmtStr.Cur(N.m_icmstot.vProd);
    lbl_ValNF.Caption :=CFrmtStr.Cur(N.m_icmstot.vNF);

    //
    // linha #2
    // chave
    lbl_Chave.Caption :=N.m_chvnfe;

    //
    // situação
    //
    case N.m_codstt of
      100: lbl_Status.Caption :=Format('Autorizado uso / %s',[N.m_numprot]);

      101,
      135,
      151,
      155: lbl_Status.Caption :='NF-e CANCELADA';

      110,
      205,
      301,
      302: lbl_Status.Caption :=Format('NF-e DENEGADA / %s',[N.m_numprot]);
      else
          lbl_Status.Caption :=N.m_motivo;
    end;
end;

procedure Tfrm_RelNFRL00.band_SubItemsDataRecord(Sender: TObject; RecNo,
  CopyNo: Integer; var Eof: Boolean; var RecordAction: TRLRecordAction);
begin
    m_IndexItem :=RecNo -1 ;
    Eof := (RecNo > m_Lote.Items.Count) ;
    RecordAction := raUseIt ;
end;

end.
