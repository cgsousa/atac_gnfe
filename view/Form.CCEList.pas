{***
* View/Form para tratar (incluir/imprimir) a carta de Correção
* Atac Sistemas
* Todos os direitos reservados
* Autor: Carlos Gonzaga
* Data: 22.08.2018
*}
unit Form.CCEList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ExtCtrls,
  //JEDI
  JvExStdCtrls, JvExExtCtrls, JvExtComponent, JvCtrls,
  JvButton, JvFooter, JvToolEdit, JvGroupBox,
  //TMS
  AdvPanel, AdvEdit, JvExMask,
  //
  VirtualTrees, uVSTree,
  //
  FormBase,
  unotfis00, ucce;

type
  Tfrm_CCEList = class(TBaseForm)
    pnl_Footer: TJvFooter;
    btn_New: TJvFooterBtn;
    btn_Close: TJvFooterBtn;
    vst_Grid1: TVirtualStringTree;
    btn_Print: TJvFooterBtn;
    procedure btn_CloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_NewClick(Sender: TObject);
    procedure vst_Grid1GetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure FormShow(Sender: TObject);
    procedure btn_PrintClick(Sender: TObject);
  private
    { Private declarations }
    m_nf: TCNotFis00 ;
    m_cceList: TCEventoCCEList;
    procedure LoadGrid() ;
  public
    { Public declarations }
    class procedure lp_Show(aNF: TCNotFis00);
  end;


implementation

{$R *.dfm}

uses uTaskDlg, uadodb ,
  Form.CCE, uACBrNFE,
  pcnConversao, pcnConversaoNFe, pcnEnvEventoNFe  ;


{ Tfrm_CCEList }

procedure Tfrm_CCEList.btn_CloseClick(Sender: TObject);
begin
    Self.Close
    ;
end;

procedure Tfrm_CCEList.btn_NewClick(Sender: TObject);
var
  V: IViewCCE ;
  C: TCEventoCCE;
  rep: IBaseACBrNFE; // Tdm_nfe;
  xCorrexao: string ;
  seq: Integer ;
begin
    if CMsgDlg.Confirm('Deseja criar uma nova Carta de Correção?') then
    begin
        V :=Tfrm_CCE.New ;
        if V.Execute(xCorrexao) then
        begin
            rep :=TCBaseACBrNFE.New() ;
            //
            // reg. novo
            C :=m_cceList.AddNew ;
            C.m_chvnfe :=m_nf.m_chvnfe;
            seq :=C.getNextNumSeq;
            //Seq :=Seq+1;
            if rep.OnlyCCE(m_nf, xCorrexao, seq) then
            begin
                if rep.retInfEvento.cStat in[135,136] then
                begin
                    C.m_versao :=100;
                    C.m_codorg :=m_nf.m_codufe ;
                    C.m_tipamb :=rep.retInfEvento.tpAmb ;
                    C.m_cnpj  :=m_nf.m_emit.CNPJCPF ;
                    C.m_codorg:=m_nf.m_codufe ;
                    C.m_dhevento :=TADOQuery.getDateTime ;
                    C.m_xcorrecao :=xCorrexao ;
                    //
                    // ret
                    C.m_verapp :=rep.retInfEvento.verAplic ;
                    C.m_codorgaut :=rep.retInfEvento.cOrgao ;
                    C.m_codstt :=rep.retInfEvento.cStat ;
                    C.m_motivo :=rep.retInfEvento.xMotivo ;
                    C.m_iddest :=rep.retInfEvento.CNPJDest ;
                    C.m_emaildest :=rep.retInfEvento.emailDest;
                    C.m_dhreceb :=rep.retInfEvento.dhRegEvento;
                    C.m_numprot:=rep.retInfEvento.nProt;
                    if C.ExecuteInsert  then
                        CMsgDlg.Info('Carta de correção homologada com sucesso.')
                    else
                        CMsgDlg.Warning('Carta de correção homologada. Mas não foi possível gravar os dados de retorno!') ;
                end
                else
                    CMsgDlg.Warning(Format('%d-%s',[rep.retInfEvento.cStat,
                                                    rep.retInfEvento.xMotivo]));
            end
            else
                CMsgDlg.Warning(rep.ErrMsg) ;
            LoadGrid() ;
        end;
    end;
end;

procedure Tfrm_CCEList.btn_PrintClick(Sender: TObject);
var
  C: TCEventoCCE ;
  rep: IBaseACBrNFE; //
//  E: TInfEventoCollectionItem;
begin
    if CMsgDlg.Confirm('Deseja imprimir a Carta de Correção?') then
    begin
        C :=m_cceList.Items[vst_Grid1.IndexItem] ;

        rep :=TCBaseACBrNFE.New() ;
        if not rep.PrintCCE(m_nf, C) then
        begin
            CMsgDlg.Warning(rep.ErrMsg)
        end;

        {rep.AddNotaFiscal(m_nf, True) ;

        rep.m_NFE.EventoNFe.Evento.Clear;

        rep.m_NFE.EventoNFe.Versao :='1.00';
        E :=rep.m_NFE.EventoNFe.Evento.Add ;
        E.infEvento.cOrgao    :=C.m_codorg;
        E.infEvento.tpAmb     :=rep.m_NFE.Configuracoes.WebServices.Ambiente;
        E.infEvento.CNPJ      :=C.m_cnpj;
        E.infEvento.chNFe     :=C.m_chvnfe;
        E.infEvento.dhEvento  :=C.m_dhevento;
        E.infEvento.tpEvento  :=teCCe;
        E.infEvento.nSeqEvento:=C.m_numseq;
        E.infEvento.versaoEvento :='1.00';
        E.infEvento.detEvento.xCorrecao :=C.m_xcorrecao;
        E.infEvento.detEvento.xCondUso :='';

        E.RetInfEvento.cStat  :=C.m_codstt ;
        E.RetInfEvento.xMotivo:=C.m_motivo ;
        E.RetInfEvento.dhRegEvento :=C.m_dhreceb ;
        E.RetInfEvento.nProt :=C.m_numprot ;

        if rep.m_NFE.EventoNFe.GerarXML then
        begin
            rep.m_NFE.ImprimirEvento
        end
        else begin
            CMsgDlg.Warning(rep.m_NFE.EventoNFe.Gerador.ListaDeAlertas.CommaText);

        end;
        }
    end;
end;

procedure Tfrm_CCEList.FormCreate(Sender: TObject);
begin
    m_cceList :=TCEventoCCEList.Create ;

end;

procedure Tfrm_CCEList.FormDestroy(Sender: TObject);
begin
    m_cceList.Destroy ;

end;

procedure Tfrm_CCEList.FormShow(Sender: TObject);
begin
    LoadGrid() ;

end;

procedure Tfrm_CCEList.LoadGrid;
begin
    vst_Grid1.Clear ;
    m_cceList.Load(m_nf.m_chvnfe) ;
    if m_cceList.Count > 0 then
    begin
        vst_Grid1.RootNodeCount :=m_cceList.Count ;
        vst_Grid1.IndexItem :=0 ;
    end;
end;

class procedure Tfrm_CCEList.lp_Show(aNF: TCNotFis00);
var
  F: Tfrm_CCEList ;
begin
    F :=Tfrm_CCEList.Create(Application) ;
    try
        F.vst_Grid1.Clear ;
        F.m_nf :=aNF ;
        F.ShowModal ;
    finally
        FreeAndNil(F);
    end;
end;

procedure Tfrm_CCEList.vst_Grid1GetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  C: TCEventoCCE ;
begin
    if Assigned(Node) then
    begin
        C :=m_cceList.Items[Node.Index] ;
        case Column of
          0: CellText :=C.m_chvnfe ;
          1: CellText :=FormatDateTime('dd/mm/yy hh:nn', C.m_dhevento) ;
          2: CellText :=C.m_xcorrecao ;
          3: CellText :=Format('%d-%s',[C.m_codstt,C.m_motivo]) ;
          4: CellText :=Format('%s/%s',[C.m_iddest,C.m_emaildest]) ;
          5: CellText :=FormatDateTime('dd/mm/yy hh:nn', C.m_dhreceb) ;
          6: CellText :=C.m_numprot ;
        end;
    end;
end;

end.
