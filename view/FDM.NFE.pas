{***
* Classes/Tipos customizados do ACBR para tratar a Nota Fiscal (NF-e/NFC-e)
* Atac Sistemas
* Todos os direitos reservados
* Autor: Carlos Gonzaga
* Data: 29.01.2018
*}
unit FDM.NFE;

{*
******************************************************************************
|* PROP�SITO: Registro de Altera��es
******************************************************************************

S�mbolo : Significado

[+]     : Novo recurso
[*]     : Recurso modificado/melhorado
[-]     : Corre��o de Bug (assim esperamos)

16.04.2019
[*] Atualiza��es do pacote ACBr

11.03.2019
[*] As chamadas do pacote ACBrNFE, foram removidas para a uACBrNFE
[*] Remo��o da instancia global do dm_nfe para evitar confritos com a thread
[*] Atualiza��es do pacote ACBr

15.02.2019
[+] Novo parametro <msg.devol_me_epp_acontribuinte_nao_sn> para indicar
    nos termos (artigos xx lei xx)
[*] Extende as infCpl para destacar o ICMS de cr�dito, conforme parametro

18.12.2018
[*] Impress�o do DANFE agora atende a config. do ini e n�o o (notfis00.nf0_tipimp)

04.12.2018
[+] Novo parametro [conting_offline] para tratar a contingencia offline;

03.12.2018
[+] Novo codigo de erro: ERROR_SERVICE_DOES_NOT_EXIST

24.08.2018
[+] Novo membro de classe (Tdm_nfe.OnlyCCE)
    para chamada da Carta de Corre��o Eletronica (CC-e)

20.08.2018
[-] Adiciona o troco em valor recebido somente na vers�o >= 4.0

02.08.2018
[*] Grupo a ser informado nas vendas interestaduais para consumidor final,
    n�o contribuinte do ICMS. (NT.2016.002_v150)

24.07.2018
[*] Grupo opcional para informa��es do ICMS Efetivo (NT.2016.002_v160)

20.06.2018
[*] Adic. novos campo membro notfis01(m_codanp, m_descamp) referente:
    02.8 cProdANP (L102) � Valores tabelas para o C�digo do Combust�vel da ANP (NT2012.003d)

11.05.2018
[+] Envio de e-mail (SendMail)

*}


interface


uses
  Windows, SysUtils, Classes, Forms, IniFiles,
  Generics.Collections ,
  //ACBr
  ACBrValidador,
  ACBrNFe, ACBrDANFCeFortesFr, ACBrMail, ACBrPosPrinter,
  ACBrNFeDANFEClass, ACBrNFeDANFeRLClass,
  ACBrBase, ACBrDFe, ACBrNFeDANFeESCPOS,
  ACBrNFeNotasFiscais, ACBrNFeWebServices,
  pcnConversao, pcnNFe, pcnEventoNFe,
  blcksock,
  unotfis00, ucce, ACBrDFeReport, ACBrDFeDANFeReport;

{$I ACBr.inc}


type
  //
  // params da nfe
  TRegNFE = record
  public
    //
    // ide
    natope: TPair<string, string>;
    codfop: TPair<string, Int16>;
    codmod: TPair<string, Int16>;
    tipdoc: TPair<string, Int16>;
    tipimp: TPair<string, Int16>;
    tpemis: TPair<string, Int16>;
    tipamb: TPair<string, Int16>;
    //
    // servidor smtp

    conting_offline: TPair<string, Boolean>;
    send_sincrono: TPair<string, Boolean>;
    send_maxnfelot: TPair<string, Int16>;

    //
    // nos termos
    devol_me_epp_acontribuinte_nao_sn: TPair<string, string>;

    procedure Load() ;
    procedure Save() ;
    procedure setContingOffLine(const aFlag: Boolean);
  end;



type
  Tdm_nfe = class(TDataModule)
    m_NFE: TACBrNFe;
    m_PP: TACBrPosPrinter;
    m_Mail: TACBrMail;
    m_DEP: TACBrNFeDANFeESCPOS;
    m_DRL: TACBrNFeDANFeRL;
    m_DF: TACBrNFeDANFCeFortes;
    m_Val: TACBrValidador;
    procedure m_NFEStatusChange(Sender: TObject);
    procedure m_NFEGerarLog(const ALogLine: string; var Tratado: Boolean);
    procedure m_NFETransmitError(const HttpError, InternalError: Integer;
      const URL, DadosEnviados, SoapAction: string; var Retentar,
      Tratado: Boolean);
  private
    { Private declarations }
    class var _Instance: Tdm_nfe;
  private
    m_Ini: TMemIniFile ;
    m_IsGlobalOffline: Boolean;
    m_EnvSinc: Boolean;
    m_StatusChange: Boolean ;
    m_StatusServico: TNFeStatusServico ;
    m_Envio: TNFeRecepcao;
    m_Retorno: TNFeRetRecepcao ;
    m_Inutiliza: TNFeInutilizacao ;
    m_RetEvento: TRetInfEvento ;
    m_reg: TRegNFE ;
  private
//    m_prmFormaEmissao: TpcnTipoEmissao ;
    m_CodMod, m_NSerie: Word ;
    m_ProdDscRdz, m_ProdCodInt: Boolean ;
    m_ErrCod: Integer;
    m_ErrMsg: string ;
    procedure LoadConfig() ;
  protected
    function CheckConnInternet(): Boolean ;
    function CheckConnectedStateInternet(): Boolean ;
  public
    { Public declarations }
    property Sincrono: Boolean read m_EnvSinc;
    property StatusServico: TNFeStatusServico read m_StatusServico ;
    property Envio: TNFeRecepcao read m_Envio;
    property Retorno: TNFeRetRecepcao read m_Retorno;
    property Inutiliza: TNFeInutilizacao read m_Inutiliza;
    property RetEvento: TRetInfEvento read m_RetEvento;

    property CodMod: Word read m_CodMod;
    property NSerie: Word read m_NSerie;
    property ProdDescrRdz: Boolean read m_ProdDscRdz;
    property ProdCodInt: Boolean read m_ProdCodInt;

    property ErrCod: Integer read m_ErrCod;
    property ErrMsg: string read m_ErrMsg;

    property Parametro: TRegNFE read m_reg;

    function AddNotaFiscal(NF: TCNotFis00;
      const Clear: Boolean = false;
      const InfProt: Boolean = True): NotaFiscal ;

    function PrintDANFE(NF: TCNotFis00): Boolean ;
    function PrintCCE(NF: TCNotFis00; CC: TCEventoCCE): Boolean ;
    function CStatProcess(const codstt: Int32): Boolean;
    function CStatCancel(const codstt: Int32): Boolean;

    procedure setStatusChange(const value: Boolean) ;
  public
    function CheckStatusServico(): Boolean;

    function IsCNPJ(const doc: string): Boolean ;
    function IsCPF(const doc: string): Boolean ;
    function IsGTIN(const doc: string): Boolean ;

    function InutNum(const cnpj, just: String;
      ano, codmod, nserie, numini, numfin: Integer): Boolean;

    function getDaysUseCertif: Smallint ;
    //procedure getInfCertif(out aCNPJ: string; out aVenc: TDatetime) ;

  public
    { somente chamadas dos servi�os, sem checa status }
    function OnlyStatusSvc(): Boolean;
    function OnlySend(NF: TCNotFis00): Boolean; overload ;
    function OnlySend(const aNumLot: Integer): Boolean; overload ;
    function OnlyCons(NF: TCNotFis00): Boolean;
    function OnlyCanc(NF: TCNotFis00; const Just: String): Boolean;
    function OnlyCCE(NF: TCNotFis00; const aCorrecao: String): Boolean;

    function SendMail(NF: TCNotFis00; const dest_email: string =''): Boolean;
  public
    constructor Create(aRemoveDataModule: Boolean); reintroduce;
    class function getInstance: Tdm_nfe; static;
    class procedure doFreeAndNil;
  end;

implementation

{$R *.dfm}

uses StrUtils, DateUtils, TypInfo, WinInet, DB,
  uadodb, uparam ,
  ACBrUtil, ACBrDFeSSL, ACBrDFeException, ACBr_WinHttp ,
  pcnConversaoNFe, pcnEnvEventoNFe ,
  RLPrinters ,
  Form.NFEStatus
  ;

{ Tdm_nfe }

function Tdm_nfe.AddNotaFiscal(NF: TCNotFis00;
  const Clear, InfProt: Boolean): NotaFiscal ;
var
  N: NotaFiscal ;
  det: TDetCollectionItem;
  pro: TProd ;
  imp: TImposto ;
  icm: TICMS;
  ipi: TIPI ;
  pis: TPIS;
  cofins: TCOFINS;
  ufdest: TICMSUFDest ;
  tot: TICMSTot ;
  //
  p0,p1: TpagCollectionItem ;
  I: Integer ;
var
  nf1: TCNotFis01 ;
var
  { totalizadores para o calc. do valor total da NF-e }
  tot_prod, //(+) Soma do valor de todos os produtos da NF-e
  tot_desc, //(-) Soma do desconto de todos os produtos da NF-e
  tot_ST,   //(+) Soma do valor do ICMS com Substitui��o Tribut�ria de todos os produtos da NF-e
  tot_fret, //(+) Soma do valor do Frete de todos os produtos da NF-e
  tot_segr, //(+) Soma do valor do seguro de todos os produtos da NF-e
  tot_outr, //(+) Soma do valor de outras despesas de todos os produtos da NF-e
  tot_II,   //(+) Soma do valor do Imposto de Importa��o de todos os produtos da NF-e
  tot_IPI,  //(+) Soma do valor do IPI de todos os produtos da NF-e
  tot_IPIDevol: Currency;  //(+) Soma do valor do IPI de todos os produtos da NF-e
var
  tot_bc, tot_icm, tot_bcst: Currency;
  tot_pis, tot_cofins: Currency;
  tot_trib: Currency;
var
  tot_FCP,
  tot_FCPST: Currency ;
  tot_FCPUFDest,
  tot_ICMSUFDest,
  tot_ICMSUFRemet: Currency ;
var
  nos_termos: string;
begin
    //
    Result :=nil;
    //
    if Clear then
        Self.m_NFE.NotasFiscais.Clear;

    N :=Self.m_NFE.NotasFiscais.Add ;
    N.NFe.Ide.cNF       :=NF.m_codseq;
    N.NFe.Ide.natOp     :=NF.m_natope;
    N.NFe.Ide.indPag    :=NF.m_indpag;
    N.NFe.Ide.modelo    :=NF.m_codmod;
    N.NFe.Ide.serie     :=NF.m_nserie;
    N.NFe.Ide.nNF       :=NF.m_numdoc;
    N.NFe.Ide.dEmi      :=NF.m_dtemis;
    N.NFe.Ide.tpNF      :=NF.m_tipntf;

    if NF.m_dest.EnderDest.UF = 'EX' then
        N.NFe.Ide.idDest :=doExterior
    else begin
        if NF.m_emit.EnderEmit.UF <> NF.m_dest.EnderDest.UF then
            N.NFe.Ide.idDest :=doInterestadual
        else
            N.NFe.Ide.idDest :=doInterna;
    end;

    N.NFe.Ide.tpEmis    :=NF.m_tipemi;
    N.NFe.Ide.tpAmb     :=NF.m_tipamb;
    N.NFe.Ide.cUF       :=NF.m_codufe;
    N.NFe.Ide.cMunFG    :=NF.m_codmun;
    N.NFe.Ide.finNFe    :=NF.m_finnfe;
    N.NFe.Ide.tpImp     :=NF.m_tipimp;
    N.NFe.Ide.indFinal  :=NF.m_indfinal;
    N.NFe.Ide.indPres   :=NF.m_indpres;
    N.NFe.Ide.dhCont  :=NF.m_dhcont;
    N.NFe.Ide.xJust   :=NF.m_justif;

    //
    N.NFe.Emit.CRT               :=NF.m_emit.CRT;
    N.NFe.Emit.CNPJCPF           :=NF.m_emit.CNPJCPF;
    N.NFe.Emit.IE                :=NF.m_emit.IE;
    N.NFe.Emit.xNome             :=NF.m_emit.xNome;
    N.NFe.Emit.xFant             :=NF.m_emit.xFant;
    N.NFe.Emit.EnderEmit.fone    :=NF.m_emit.EnderEmit.fone;
    N.NFe.Emit.EnderEmit.CEP     :=NF.m_emit.EnderEmit.CEP;
    N.NFe.Emit.EnderEmit.xLgr    :=NF.m_emit.EnderEmit.xLgr;
    N.NFe.Emit.EnderEmit.nro     :=NF.m_emit.EnderEmit.nro;
    N.NFe.Emit.EnderEmit.xCpl    :=NF.m_emit.EnderEmit.xCpl;
    N.NFe.Emit.EnderEmit.xBairro :=NF.m_emit.EnderEmit.xBairro;
    N.NFe.Emit.EnderEmit.cMun    :=NF.m_emit.EnderEmit.cMun;
    N.NFe.Emit.EnderEmit.xMun    :=NF.m_emit.EnderEmit.xMun;
    N.NFe.Emit.EnderEmit.UF      :=NF.m_emit.EnderEmit.UF;
    N.NFe.Emit.enderEmit.cPais   :=1058;
    N.NFe.Emit.enderEmit.xPais   :='BRASIL';
    N.NFe.Emit.IEST              := '';
//    N.NFe.Emit.IM                := '2648800'; // Preencher no caso de existir servi�os na nota
//    N.NFe.Emit.CNAE              := '6201500'; // Verifique na cidade do emissor da NFe se � permitido
                                               // a inclus�o de servi�os na NF
    N.NFe.Dest.CNPJCPF           :=NF.m_dest.CNPJCPF;
    N.NFe.Dest.IE                :=NF.m_dest.IE;
    N.NFe.Dest.ISUF              :=NF.m_dest.ISUF;
    N.NFe.Dest.xNome             :=NF.m_dest.xNome;
    N.NFe.Dest.EnderDest.Fone    :=NF.m_dest.EnderDest.fone;
    N.NFe.Dest.EnderDest.CEP     :=NF.m_dest.EnderDest.CEP;
    N.NFe.Dest.EnderDest.xLgr    :=NF.m_dest.EnderDest.xLgr;
    if NF.m_dest.EnderDest.nro <> '' then
        N.NFe.Dest.EnderDest.nro     :=NF.m_dest.EnderDest.nro
    else
        N.NFe.Dest.EnderDest.nro     :='SN';
    N.NFe.Dest.EnderDest.xCpl    :=NF.m_dest.EnderDest.xCpl;
    N.NFe.Dest.EnderDest.xBairro :=NF.m_dest.EnderDest.xBairro;
    N.NFe.Dest.EnderDest.cMun    :=NF.m_dest.EnderDest.cMun;
    N.NFe.Dest.EnderDest.xMun    :=NF.m_dest.EnderDest.xMun;
    N.NFe.Dest.EnderDest.UF      :=NF.m_dest.EnderDest.UF;
    N.NFe.Dest.EnderDest.cPais   :=N.NFe.Emit.enderEmit.cPais;
    N.NFe.Dest.EnderDest.xPais   :=N.NFe.Emit.enderEmit.xPais;

    case NF.m_codmod of
        55://NF-e
        begin
            N.NFe.Ide.dSaiEnt   :=NF.m_dhsaient;
            N.NFe.Ide.hSaiEnt   :=NF.m_dhsaient;

            if NF.m_chvref <> '' then
            with N.NFe.Ide.NFref.Add do
            begin
                refNFe :=NF.m_chvref ;
            end;

            N.NFe.Dest.indIEDest :=NF.m_dest.indIEDest ;
        end;

        65://NFC-e
        begin
            N.NFe.Ide.idDest :=doInterna;
            N.NFe.Dest.indIEDest  :=inNaoContribuinte;
            N.NFe.Dest.IE         :='';//NFC-e n�o aceita IE
        end;
    end;

    tot_prod:=0;
    tot_desc:=0;
    tot_ST:=0;
    tot_fret:=0;
    tot_segr:=0;
    tot_outr:=0;
    tot_II:=0;
    tot_IPI:=0;
    tot_IPIDevol:=0;

    tot_bc  :=0;
    tot_icm :=0;
    tot_bcst:=0;
    tot_pis :=0;
    tot_cofins :=0;

    tot_trib :=0;

    tot_FCP :=0;
    tot_FCPST :=0;

    tot_FCPUFDest :=0;
    tot_ICMSUFDest:=0;
    tot_ICMSUFRemet :=0;

    nos_termos:='';

    for nf1 in NF.Items do
    begin
        det :=N.NFe.Det.Add ;
        det.infAdProd :=nf1.m_infadprod;

        //produto
        pro :=det.Prod ;
        pro.nItem :=nf1.ItemIndex +1;
        pro.cProd :=nf1.m_codpro ;
        pro.xProd :=nf1.m_descri ;
        //
        // valida GTIN
        if m_NFE.Configuracoes.Geral.VersaoDF >=ve400 then
        begin
            if Self.IsGTIN(nf1.m_codean) then
                pro.cEAN :=nf1.m_codean
            else
                pro.cEAN :='SEM GTIN';
        end
        else begin
            if Pos('SEM GTIN', nf1.m_codean) > 0 then
              pro.cEAN :=''
            else
              pro.cEAN :=nf1.m_codean;
        end;

        pro.NCM :=nf1.m_codncm ;
        pro.CEST :=nf1.m_codest ;
        pro.EXTIPI :=nf1.m_extipi ;
        pro.CFOP :=IntToStr(nf1.m_cfop) ;
        pro.uCom :=ifthen(nf1.m_undcom='','UN', nf1.m_undcom)  ;
        pro.qCom :=nf1.m_qtdcom ;
        pro.vUnCom :=nf1.m_vlrcom ;
        pro.vProd :=nf1.m_vlrpro ;
        pro.cEANTrib :=pro.cEAN; //nf1.m_eantrib ;
        pro.uTrib    :=nf1.m_undtrib ;
        pro.qTrib    :=nf1.m_qtdtrib ;
        pro.vUnTrib  :=nf1.m_vlrtrib ;
        pro.vFrete   :=nf1.m_vlrfret ;
        pro.vSeg     :=nf1.m_vlrsegr ;
        pro.vDesc    :=nf1.m_vlrdesc ;
        pro.vOutro   :=nf1.m_vlroutr ;

        pro.IndTot :=TpcnIndicadorTotal(nf1.m_indtot);

        //
        //det.imposto
        //
        imp :=det.Imposto;
        icm :=imp.ICMS;
        icm.orig :=nf1.m_orig ;

        case NF.m_emit.CRT of

            crtSimplesNacional:
            begin
                case nf1.m_csosn of
                    101:
                    begin
                        icm.CSOSN :=csosn101 ;
                        icm.pCredSN :=nf1.m_pcredsn ;
                        icm.vCredICMSSN :=nf1.m_vcredicmssn ;
                        nos_termos :='PERMITE O APROVEITAMENTO DO CR�DITO DE ICMS NO VALOR DE '+FloatToStrF(icm.vCredICMSSN,ffCurrency,13,2);
                        nos_termos :=nos_termos +'; CORRESPONDENTE � AL�QUOTA DE '+FloatToStrF(icm.pCredSN,ffNumber,5,2) +'%, ';
                        nos_termos :=nos_termos +m_reg.devol_me_epp_acontribuinte_nao_sn.Value
                    end;
                    102: icm.CSOSN :=csosn102 ;
                    103: icm.CSOSN :=csosn103 ;
                    300: icm.CSOSN :=csosn300 ;
                    400: icm.CSOSN :=csosn400 ;
                    201:
                    begin
                        icm.CSOSN :=csosn201 ;
                        case nf1.m_modbcst of
                            1: icm.modBCST :=dbisListaNegativa;
                            2: icm.modBCST :=dbisListaPositiva;
                            3: icm.modBCST :=dbisListaNeutra;
                            4: icm.modBCST :=dbisMargemValorAgregado;
                            5: icm.modBCST :=dbisPauta;
                        else
                            icm.modBCST :=dbisPrecoTabelado;
                        end;
                        icm.pMVAST  :=nf1.m_pmvast;
                        icm.pRedBCST:=nf1.m_predbcst;
                        icm.vBCST   :=nf1.m_vbcst;
                        icm.pICMSST :=nf1.m_picmsst;
                        icm.vICMSST :=nf1.m_vicmsst;
                        icm.pCredSN :=nf1.m_pcredsn ;
                        icm.vCredICMSSN :=nf1.m_vcredicmssn ;
                        //
                        // fcp
                        icm.vBCFCPST:=nf1.m_vbcfcpst ;
                        icm.pFCPST:=nf1.m_pfcpst ;
                        icm.vFCPST:=nf1.m_vfcpst ;
                    end;
                    202,203:
                    begin
                        icm.CSOSN :=csosn202 ;
                        case nf1.m_modbcst of
                            1: icm.modBCST :=dbisListaNegativa;
                            2: icm.modBCST :=dbisListaPositiva;
                            3: icm.modBCST :=dbisListaNeutra;
                            4: icm.modBCST :=dbisMargemValorAgregado;
                            5: icm.modBCST :=dbisPauta;
                        else
                            icm.modBCST :=dbisPrecoTabelado;
                        end;
                        icm.pMVAST  :=nf1.m_pmvast;
                        icm.pRedBCST:=nf1.m_predbcst;
                        icm.vBCST   :=nf1.m_vbcst;
                        icm.pICMSST :=nf1.m_picmsst;
                        icm.vICMSST :=nf1.m_vicmsst;
                        //
                        // fcp
                        icm.vBCFCPST:=nf1.m_vbcfcpst ;
                        icm.pFCPST:=nf1.m_pfcpst ;
                        icm.vFCPST:=nf1.m_vfcpst ;
                    end;
                    500:
                    begin
                        icm.CSOSN :=csosn500 ;
                        icm.vBCSTRet   :=nf1.m_vbcstret;
                        icm.vICMSSTRet :=nf1.m_vicmsstret;
                        icm.pRedBCEfet :=nf1.m_predbcefet;
                        icm.vBCEfet :=nf1.m_vbcefet;
                        icm.pICMSEfet :=nf1.m_picmsefet;
                        icm.vICMSEfet :=nf1.m_vicmsefet;
                    end
                else
                    //900-Outros
                    icm.CSOSN :=csosn900 ;
                    case nf1.m_modbc of
                        1: icm.modBC :=dbiPauta;
                        2: icm.modBC :=dbiPrecoTabelado;
                        3: icm.modBC :=dbiValorOperacao;
                    else
                        icm.modBC  :=dbiMargemValorAgregado;
                    end;

                    icm.vBC   :=nf1.m_vbc;
                    icm.pICMS :=nf1.m_picms;
                    icm.vICMS :=nf1.m_vicms;
                    icm.pRedBC:=nf1.m_predbc;

                    //
                    // fcp
                    icm.vBCFCP:=nf1.m_vbcfcp ;
                    icm.pFCP:=nf1.m_pfcp ;
                    icm.vFCP:=nf1.m_vfcp ;
                end;

            end {crtSimplesNacional};

            crtRegimeNormal, crtSimplesExcessoReceita:
            begin
//                icm.CSOSN :=csosnVazio ;

                case nf1.m_modbc of
                    0: icm.modBC :=dbiMargemValorAgregado;
                    1: icm.modBC :=dbiPauta;
                    2: icm.modBC :=dbiPrecoTabelado;
                    3: icm.modBC :=dbiValorOperacao;
                end;

                case nf1.m_modbcst of
                    1: icm.modBCST :=dbisListaNegativa;
                    2: icm.modBCST :=dbisListaPositiva;
                    3: icm.modBCST :=dbisListaNeutra;
                    4: icm.modBCST :=dbisMargemValorAgregado;
                    5: icm.modBCST :=dbisPauta;
                else
                    icm.modBCST :=dbisPrecoTabelado;
                end;

                case nf1.m_cst of
                    //
                    //
                    00:
                    begin
                        icm.CST :=cst00;
                        icm.vBC   :=nf1.m_vbc;
                        icm.pICMS :=nf1.m_picms;
                        icm.vICMS :=nf1.m_vicms;
                        //
                        // fcp
                        icm.pFCP:=nf1.m_pfcp ;
                        icm.vFCP:=nf1.m_vfcp ;
                    end;
                    10:
                    begin
                        icm.CST :=cst10;
                        //ICMS Normal
                        icm.vBC   :=nf1.m_vbc;
                        icm.pICMS :=nf1.m_picms;
                        icm.vICMS :=nf1.m_vicms;
                        //ICMS ST
                        icm.pMVAST  :=nf1.m_pmvast;
                        icm.pRedBCST:=nf1.m_predbcst;
                        icm.vBCST   :=nf1.m_vbcst;
                        icm.pICMSST :=nf1.m_picmsst;
                        icm.vICMSST :=nf1.m_vicmsst;
                        //
                        // fcp
                        icm.vBCFCP:=nf1.m_vbcfcp ;
                        icm.pFCP  :=nf1.m_pfcp ;
                        icm.vFCP  :=nf1.m_vfcp ;
                        icm.vBCFCPST:=nf1.m_vbcfcpst ;
                        icm.pFCPST  :=nf1.m_pfcpst ;
                        icm.vFCPST  :=nf1.m_vfcpst ;
                    end;
                    20:
                    begin
                        icm.CST :=cst20;
                        icm.pRedBC:=nf1.m_predbc;
                        icm.vBC   :=nf1.m_vbc;
                        icm.pICMS :=nf1.m_picms;
                        icm.vICMS :=nf1.m_vicms;
                        //
                        // fcp
                        icm.vBCFCP:=nf1.m_vbcfcp ;
                        icm.pFCP:=nf1.m_pfcp ;
                        icm.vFCP:=nf1.m_vfcp ;
                    end;
                    30:
                    begin
                        icm.CST :=cst30;
                        icm.pMVAST  :=nf1.m_pmvast;
                        icm.pRedBCST:=nf1.m_predbcst;
                        icm.vBCST   :=nf1.m_vbcst;
                        icm.pICMSST :=nf1.m_picmsst;
                        icm.vICMSST :=nf1.m_vicmsst;
                        //
                        // fcp
                        icm.vBCFCPST:=nf1.m_vbcfcpst ;
                        icm.pFCPST:=nf1.m_pfcpst ;
                        icm.vFCPST:=nf1.m_vfcpst ;
                    end;
                    40: icm.CST :=cst40;
                    51: icm.CST :=cst51;
                    //
                    // cobrado anteriormente por substitui��o tribut�ria
                    60:
                    begin
                        if(nf1.m_comb.m_codanp > 0)and(NF.m_codmod =55)then
                        begin
                            icm.CST :=cstRep60;
                            icm.vBCSTRet  :=nf1.m_vbcstret;
                            icm.vICMSSTRet:=nf1.m_vicmsstret;
                            icm.vBCSTDest  :=nf1.m_vbcstdest ;
                            icm.vICMSSTDest:=nf1.m_vicmsstdest;
                        end
                        else begin
                            icm.CST :=cst60;
                            icm.vBCSTRet  :=0;
                            icm.vICMSSTRet:=0;
                            if NF.m_indfinal = cfConsumidorFinal then
                            begin
                                icm.pRedBCEfet:=nf1.m_predbcefet;
                                icm.vBCEfet   :=nf1.m_vbcefet;
                                icm.pICMSEfet :=nf1.m_picmsefet;
                                icm.vICMSEfet :=nf1.m_vicmsefet;
                            end;
                        end;
                    end;
                    70: icm.CST :=cst70;
                else
                    //outros
                    icm.CST :=cst90 ;
                    icm.pRedBC:=nf1.m_predbc;
                    icm.vBC   :=nf1.m_vbc;
                    icm.pICMS :=nf1.m_picms;
                    icm.vICMS :=nf1.m_vicms;
                    //
                    // fcp
                    icm.vBCFCP:=nf1.m_vbcfcp ;
                    icm.pFCP:=nf1.m_pfcp ;
                    icm.vFCP:=nf1.m_vfcp ;
                end;

            end;

        end;

        //tot. tributos (nac,est,mun)
        //imp.vTotTrib :=(nf1.m_vlrpro *nf1.m_ibptaliqnac)/100;
        //imp.vTotTrib :=imp.vTotTrib +(nf1.m_vlrpro *nf1.m_ibptaliqimp)/100;
        //imp.vTotTrib :=imp.vTotTrib +(nf1.m_vlrpro *nf1.m_ibptaliqest)/100;
        //imp.vTotTrib :=imp.vTotTrib +(nf1.m_vlrpro *nf1.m_ibptaliqmun)/100;

        //det.imposto.pis
        pis :=det.Imposto.PIS;
        pis.CST   :=pis99;
        pis.vBC   :=nf1.m_pis.vBC;
        pis.pPIS  :=nf1.m_pis.pPIS;
        pis.vPIS  :=nf1.m_pis.vPIS;

        //det.imposto.cofins
        cofins :=det.Imposto.COFINS;
        cofins.CST    :=cof99;
        cofins.vBC    :=nf1.m_cofins.vBC;
        cofins.pCOFINS:=nf1.m_cofins.pCOFINS;
        cofins.vCOFINS:=nf1.m_cofins.vCOFINS;

        //
        // Grupo a ser informado nas vendas interestaduais para
        // consumidor final, n�o contribuinte do ICMS.
        ufdest :=imp.ICMSUFDest ;
        ufdest.vBCUFDest    :=nf1.m_vbcufdest;
        ufdest.vBCFCPUFDest :=nf1.m_vbcfcpufdest;
        ufdest.pICMSUFDest  :=nf1.m_picmsufdest;
        ufdest.pFCPUFDest   :=nf1.m_pfcpufdest ;
        ufdest.pICMSInter   :=nf1.m_picmsinter;
        ufdest.pICMSInterPart :=nf1.m_picmsinterpart;
        ufdest.vFCPUFDest :=nf1.m_vfcpufdest ;
        ufdest.vICMSUFDest:=nf1.m_vicmsufdest;
        ufdest.vICMSUFRemet:=nf1.m_vicmsufremet;

        //
        // item / combustivel
        if nf1.m_comb.m_codanp > 0 then
        begin
            pro.comb.cProdANP :=nf1.m_comb.m_codanp ;
            pro.comb.descANP  :=nf1.m_comb.m_descri ;
            pro.comb.pGLP   :=nf1.m_comb.m_pglp ;
            pro.comb.pGNn   :=nf1.m_comb.m_pgnn ;
            pro.comb.pGNi   :=nf1.m_comb.m_pgni ;
            pro.comb.vPart  :=nf1.m_comb.m_vpart ;
            pro.comb.UFcons :=nf1.m_comb.m_ufcons ;
        end;

        //
        // se compoe totalizadores
        if pro.IndTot = itSomaTotalNFe then
        begin
            //calc. totais
            tot_trib :=tot_trib +imp.vTotTrib;
            tot_prod :=tot_prod +nf1.m_vlrpro ;
            tot_desc :=tot_desc +nf1.m_vlrdesc;
            tot_ST  :=tot_ST +nf1.m_vicmsst ;
            tot_fret :=tot_fret +nf1.m_vlrfret ;
            tot_segr :=tot_segr +nf1.m_vlrsegr ;
            tot_outr :=tot_outr +nf1.m_vlroutr ;
            //tot_II :=tot_II +nf1.m_vlrpro ;
            tot_IPI :=tot_IPI +nf1.m_ipi.vIPI ;
            tot_IPIDevol :=tot_IPIDevol +nf1.m_vipidevol ;

            tot_bc :=tot_bc +icm.vBC ;
            tot_icm :=tot_icm +icm.vICMS ;
            tot_bcst :=tot_bcst +icm.vBCST;

            tot_pis :=tot_pis +nf1.m_pis.vPIS;
            tot_cofins :=tot_cofins +nf1.m_cofins.vCOFINS;

            tot_FCP   :=tot_FCP   +nf1.m_vfcp ;
            tot_FCPST :=tot_FCPST +nf1.m_vfcpst;

            tot_FCPUFDest   :=tot_FCPUFDest   +ufdest.vFCPUFDest;
            tot_ICMSUFDest  :=tot_ICMSUFDest  +ufdest.vICMSUFDest;
            tot_ICMSUFRemet :=tot_ICMSUFRemet +ufdest.vICMSUFRemet;

        end;

        //
        // grupo IPI
        if nf1.m_ipi.pIPI > 0 then
        begin
            ipi :=det.Imposto.IPI;
            ipi.CST   :=ipi99; // outras sa�das
            ipi.qUnid :=nf1.m_ipi.qUnid;
            ipi.vUnid :=nf1.m_ipi.vUnid;
            ipi.pIPI  :=nf1.m_ipi.pIPI;
            ipi.vIPI  :=nf1.m_ipi.vIPI;
        end;

        //
        // grupo imposto devol
        if nf1.m_vipidevol > 0 then
        begin
            det.pDevol :=nf1.m_pdevol ;
            det.vIPIDevol :=nf1.m_vipidevol;
        end;

    end;

    //
    // totais
    tot :=N.NFe.Total.ICMSTot ;
    tot.vBC   :=tot_bc ;
    tot.vICMS :=tot_icm;
    tot.vBCST :=tot_bcst;
    tot.vST   :=tot_ST ;

    tot.vProd :=tot_prod ;
    tot.vFrete:=tot_fret ;
    tot.vSeg  :=tot_segr ;
    tot.vDesc :=tot_desc ;
    tot.vII   :=tot_II ;
    tot.vIPI  :=tot_IPI ;
    tot.vIPIDevol :=tot_IPIDevol ;
    tot.vPIS  :=tot_pis ;
    tot.vCOFINS :=tot_cofins ;
    tot.vOutro  :=tot_outr ;
    tot.vNF   :=( tot_prod -tot_desc) +
                  tot_ST +tot_fret +
                  tot_segr +
                  tot_II +
                  tot_IPI +
                  tot_IPIDevol +
                  tot_outr+
                  tot_FCPST ;
    tot.vTotTrib :=tot_trib;

    //
    // partilha do icms e fundo de probreza
    tot.vFCPUFDest   :=tot_FCPUFDest;
    tot.vICMSUFDest  :=tot_ICMSUFDest;
    tot.vICMSUFRemet :=tot_ICMSUFRemet;

    //
    // fcp
    tot.vFCP   :=tot_FCP ;
    tot.vFCPST :=tot_FCPST ;

    //transportes
    N.NFe.Transp.modFrete :=NF.m_transp.modFrete ;

    //
    // nfe ambos os leiautes (3.10/4.0)
    // dup/faturas
    if NF.m_codmod =TCNotFis00.MOD_NFE then
    begin
        N.NFe.Transp.Transporta.Assign(NF.m_transp.Transporta) ;
        //
        // NT 2016_002.v130
//        if N.NFe.Ide.idDest <> doInterestadual then
//        begin
            N.NFe.Transp.veicTransp.Assign(NF.m_transp.veicTransp) ;
            N.NFe.Transp.Vol.Assign(NF.m_transp.Vol) ;
//        end;
        N.NFe.Cobr.Assign(NF.m_cobr);//cobran�a (NF-e)
    end;

    //
    // pagamentos
    // mantem leiaute 3.10,
    if((m_NFE.Configuracoes.Geral.VersaoDF =ve310)and(Self.m_codmod =TCNotFis00.MOD_NFCE))or
      (m_NFE.Configuracoes.Geral.VersaoDF =ve400)then
    begin
        //
        // pagamentos tbm para NFE
        //N.NFe.pag.Assign(NF.m_pag);
        //if N.NFe.pag.Count =0 then pag :=N.NFe.pag.Add
        //else                       pag :=N.NFe.pag.Items[0] ;
        N.NFe.pag.vTroco :=NF.m_pag.vTroco ;
        for I :=0 to NF.m_pag.Count -1 do
        begin
            p0 :=NF.m_pag.Items[I] ;
            p1 :=N.NFe.pag.Add ;
            p1.indPag :=p0.indPag ;
            p1.tPag :=p0.tPag ;
            p1.vPag :=p0.vPag ;
            p1.tpIntegra :=p0.tpIntegra ;
            p1.CNPJ :=p0.CNPJ ;
            p1.tBand :=p0.tBand ;
            p1.cAut :=p0.cAut ;
        end;

        //
        // Para as notas com finalidade de Ajuste ou Devolu��o
        // o campo Forma de Pagamento deve ser preenchido com 90=Sem Pagamento.
        if NF.m_finnfe in[fnComplementar,fnAjuste,fnDevolucao] then
        begin
            p1.tPag :=fpSemPagamento;
            p1.vPag :=0;
        end ;

        //
        // adiciona valor recebido, se, e somente, se
        // a primeira forma de pagto for igual a dinheiro
        if(m_NFE.Configuracoes.Geral.VersaoDF =ve400)and
          (p1.tPag =fpDinheiro) then
        begin
            //
            // valor recebido
            p1.vPag :=p1.vPag +N.NFe.pag.vTroco; //+NF.vTroco ;
            //
            // valor do troco
            //N.NFe.pag.vTroco :=N.NFe.pag.vTroco; //+NF.vTroco ;
        end;
    end;

    //
    // inf.Cpl
    if nos_termos <> '' then
    begin
        N.NFe.InfAdic.infCpl :=NF.m_infCpl +';'+ nos_termos;
        //NF.s
    end
    else begin
        N.NFe.InfAdic.infCpl :=NF.m_infCpl ;
    end;

    //
    // autorizada para DANFE/Distribuicao/Cancelamento
    if NF.m_codstt =TCNotFis00.CSTT_AUTORIZADO_USO then
    begin
        if InfProt then
        begin
            N.NFe.procNFe.tpAmb   :=NF.m_tipamb ;
            N.NFe.procNFe.verAplic:=NF.m_verapp ;
            N.NFe.procNFe.chNFe   :=NF.m_chvnfe ;
            N.NFe.procNFe.dhRecbto:=NF.m_dhreceb;
            N.NFe.procNFe.nProt   :=NF.m_numprot;
            N.NFe.procNFe.cStat   :=NF.m_codstt ;
            N.NFe.procNFe.xMotivo :=NF.m_motivo ;
        end;
        N.GerarXML ;
        Exit(N);
    end;

    //
    //se ja foi emitido em contingencia!
    //
    {if NF.m_codstt =TCNotFis00.CSTT_EMIS_CONTINGE then
    begin
        N.GerarXML ;
        Exit(N);
    end;}

    try
        N.Assinar ;
    except
        on E:EACBrDFeException  do
        begin
            Self.m_ErrCod :=55;
            Self.m_ErrMsg :=E.Message ;
            Exit(nil) ;
        end;
    end;

    if N.VerificarAssinatura then
    begin
        NF.m_chvnfe :=OnlyNumber(N.NFe.infNFe.ID)  ;
        NF.m_xml    :=N.XMLAssinado ;
        Result :=N;

        try
            N.Validar ;
            if N.ValidarRegrasdeNegocios then
            begin
                if NF.m_tipemi = teNormal then
                begin
                    NF.m_codstt :=1;
                    case NF.m_codmod of
                        55: NF.m_motivo :='NF-e pronta para envio';
                        65: NF.m_motivo :='NFC-e pronta para envio';
                    end;
                end
                else begin
                    NF.m_codstt :=9;
                    case NF.m_codmod of
                        55: NF.m_motivo :='NF-e emitida em conting�ncia!';
                        65: NF.m_motivo :='NFC-e emitida em conting�ncia!';
                    end;
                end;
            end
            else begin
                Self.m_ErrCod :=88;
                Self.m_ErrMsg :=N.ErroRegrasdeNegocios;
                NF.m_codstt :=Self.m_ErrCod ;
                NF.m_motivo :=Self.m_ErrMsg ;
            end;
        except
            Self.m_ErrCod :=77;
            //Self.m_ErrMsg :=N.ErroValidacao;
            Self.m_ErrMsg :=N.ErroValidacaoCompleto;
            NF.m_codstt :=Self.m_ErrCod ;
            NF.m_motivo :=Self.m_ErrMsg ;
        end;
    end
    else begin
        Self.m_ErrCod :=66;
        Self.m_ErrMsg :=N.ErroValidacao;
    end;

end;

function Tdm_nfe.CheckConnectedStateInternet: Boolean;
var
  stt: DWORD;
begin
    if not InternetGetConnectedState(@stt, 0) then
    begin
        m_IsGlobalOffline :=False
    end
    else begin
        if(stt and INTERNET_CONNECTION_LAN <> 0) or
          (stt and INTERNET_CONNECTION_MODEM <> 0)or
          (stt and INTERNET_CONNECTION_PROXY <> 0)then
        m_IsGlobalOffline :=True;
    end;
    Result :=m_IsGlobalOffline ;
end;

function Tdm_nfe.CheckConnInternet: Boolean;
var
  w: DWORD;
begin
    Result :=CheckConnectedStateInternet ;
    if not Result then
    begin
        Result :=InternetCheckConnection('www.google.com.br', w, 0) ;
    end;
end;

function Tdm_nfe.CheckStatusServico(): Boolean;
var
  w: DWORD;
begin
    {Result :=CheckConnInternet();
    if Result then
    begin
        if m_StatusServico = nil then
        begin
            m_NFE.WebServices.StatusServico.Executar ;
            Self.m_ErrCod :=m_NFE.WebServices.StatusServico.cStat ;
            Self.m_ErrMsg :=m_NFE.WebServices.StatusServico.xMotivo ;
            Result :=Self.m_ErrCod =107;
            m_StatusServico :=m_NFE.WebServices.StatusServico;
        end;
    end
    else begin
        Self.m_ErrCod :=99;
        Self.m_ErrMsg :='Conex�o com a Internet n�o dispon�vel!';
    end;}

    if m_StatusServico = nil then
    begin
        m_StatusServico :=m_NFE.WebServices.StatusServico;
    end;
    Result :=m_StatusServico.Executar ;
end;

constructor Tdm_nfe.Create(aRemoveDataModule: Boolean);
begin
    inherited Create(nil);
    if aRemoveDataModule then
    begin
        RemoveDataModule(Self);
    end;
end;

function Tdm_nfe.CStatCancel(const codstt: Int32): Boolean;
begin
    Result :=Self.m_NFE.CstatCancelada(codstt);
    Result :=Result or (codstt =135);

end;

function Tdm_nfe.CStatProcess(const codstt: Int32): Boolean;
begin
    Result :=Self.m_NFE.CstatProcessado(codstt);

end;

class procedure Tdm_nfe.doFreeAndNil;
begin
    if _Instance <> nil then
    begin
        FreeAndNil(_Instance);
    end;
end;

function Tdm_nfe.getDaysUseCertif: Smallint;
var
  yy,mm,dd: Word;
begin
    m_NFE.SSL.CarregarCertificadoSeNecessario;
    if Empresa.DateServ > m_NFE.SSL.CertDataVenc then
        Result :=-DaysBetween(Empresa.DateServ, m_NFE.SSL.CertDataVenc)
    else begin
        if(DayOf(Empresa.DateServ) =DayOf(m_NFE.SSL.CertDataVenc))and
          (MonthOf(Empresa.DateServ) =MonthOf(m_NFE.SSL.CertDataVenc))then
            Result :=1
        else
            Result :=DaysBetween(Empresa.DateServ, m_NFE.SSL.CertDataVenc);
    end;
end;

class function Tdm_nfe.getInstance: Tdm_nfe;
begin
    if _Instance = nil then
    begin
        //_Instance :=Tdm_nfe.Create ;
        Application.CreateForm(Tdm_nfe, _Instance);
        _Instance.LoadConfig();
    end;
    Result :=_Instance ;
end;

function Tdm_nfe.InutNum(const cnpj, just: String; ano, codmod, nserie,
  numini, numfin: Integer): Boolean;
begin
    Result :=CheckStatusServico() ;
    if Result then
    begin
        Self.m_NFE.WebServices.Inutiliza(cnpj, just, ano,
                                        codmod, nserie,
                                        numini, numfin) ;
        Result := (Self.m_NFE.WebServices.Inutilizacao.cStat =102)or
                  (Self.m_NFE.WebServices.Inutilizacao.cStat =563);
        if Result then
            m_Inutiliza :=Self.m_NFE.WebServices.Inutilizacao
        else begin
//            m_ErrCod :=Self.m_NFE.WebServices.Inutilizacao.cStat;
            m_ErrMsg :=Self.m_NFE.WebServices.Inutilizacao.xMotivo;
        end;
    end;
end;

function Tdm_nfe.IsCNPJ(const doc: string): Boolean;
begin
    //
    //
    m_Val.TipoDocto :=docCNPJ ;
    m_Val.Documento :=doc ;
    Result :=m_Val.Validar ;

end;

function Tdm_nfe.IsCPF(const doc: string): Boolean;
begin
    //
    //
    m_Val.TipoDocto :=docCPF ;
    m_Val.Documento :=doc ;
    Result :=m_Val.Validar ;

end;

function Tdm_nfe.IsGTIN(const doc: string): Boolean;
begin
    //
    //
    m_Val.TipoDocto :=docGTIN ;
    m_Val.Documento :=doc ;
    Result :=m_Val.Validar ;

end;


procedure Tdm_nfe.LoadConfig;
begin

    //
    //
    m_ErrCod :=0;
    m_ErrMsg :='';
    //
    m_StatusChange :=True ;
    m_StatusServico:=m_NFE.WebServices.StatusServico ;
    //
    m_Ini :=TMemIniFile.Create(ApplicationPath +'Configuracoes.ini') ;

    //certificado
    m_NFE.Configuracoes.Certificados.ArquivoPFX :=m_Ini.ReadString('Certificado','Caminho','') ;
    if FileExists(m_NFE.Configuracoes.Certificados.ArquivoPFX)then
    begin
        m_NFE.Configuracoes.Certificados.Senha :=m_Ini.ReadString('Certificado','Senha','') ;
        m_NFE.Configuracoes.Certificados.NumeroSerie :='';
    end
    else begin
        m_NFE.Configuracoes.Certificados.NumeroSerie :=m_Ini.ReadString('Certificado','NumSerie','') ;
        m_NFE.Configuracoes.Certificados.ArquivoPFX :='';
        m_NFE.Configuracoes.Certificados.Senha :='';
    end;
    m_NFE.Configuracoes.Certificados.VerificarValidade :=False ;

    //config.geral
    m_NFE.Configuracoes.Geral.AtualizarXMLCancelado := m_Ini.ReadBool(   'Geral','AtualizarXML',True) ;
    m_NFE.Configuracoes.Geral.RetirarAcentos   := m_Ini.ReadBool(   'Geral','RetirarAcentos',True) ;
    m_NFE.Configuracoes.Geral.ExibirErroSchema      := m_Ini.ReadBool(   'Geral','ExibirErroSchema',True) ;
    m_NFE.Configuracoes.Geral.FormatoAlerta         := m_Ini.ReadString( 'Geral','FormatoAlerta'  ,'TAG:%TAGNIVEL% ID:%ID%/%TAG%(%DESCRICAO%) - %MSG%.') ;
    m_NFE.Configuracoes.Geral.FormaEmissao          := TpcnTipoEmissao(m_Ini.ReadInteger( 'Geral','FormaEmissao',0)) ;
    m_NFE.Configuracoes.Geral.SSLLib                := TSSLLib(m_Ini.ReadInteger( 'Certificado','SSLLib' ,0)) ;
    m_NFE.Configuracoes.Geral.SSLCryptLib           := TSSLCryptLib(m_Ini.ReadInteger( 'Certificado','CryptLib' , 0)) ;
    m_NFE.Configuracoes.Geral.SSLHttpLib            := TSSLHttpLib(m_Ini.ReadInteger( 'Certificado','HttpLib' , 0)) ;
    {$IfDef DFE_SEM_XMLSEC}
    m_NFE.Configuracoes.Geral.SSLXmlSignLib         := xsLibXml2 ;
    {$Else}
    m_NFE.Configuracoes.Geral.SSLXmlSignLib         := TSSLXmlSignLib(m_Ini.ReadInteger( 'Certificado','XmlSignLib' , 0)) ;
    {$EndIf}
    m_NFE.Configuracoes.Geral.ModeloDF              := TpcnModeloDF(m_Ini.ReadInteger( 'Geral','ModeloDF',0));
    m_NFE.Configuracoes.Geral.VersaoDF              := TpcnVersaoDF(m_Ini.ReadInteger( 'Geral','VersaoDF',0)) ;
    m_NFE.Configuracoes.Geral.VersaoQRCode          := TpcnVersaoQrCode(m_Ini.ReadInteger( 'Geral','VersaoQR',2)) ;
    m_NFE.Configuracoes.Geral.IdCSC      := m_Ini.ReadString('CONFIG', 'CscId', '');
    m_NFE.Configuracoes.Geral.CSC        := m_Ini.ReadString('CONFIG', 'CscNumero', '');

  //  m_NFE.Configuracoes.Geral.IncluirQRCodeXMLNFCe   := true;

    m_NFE.Configuracoes.Geral.Salvar       := m_Ini.ReadBool(   'Geral','Salvar'      ,True) ;

    //config.ws
    m_NFE.Configuracoes.WebServices.UF         := m_Ini.ReadString('WebService', 'UF', 'MA') ;
    m_NFE.Configuracoes.WebServices.Ambiente   := TpcnTipoAmbiente(m_Ini.ReadInteger('WebService', 'Ambiente', 0)) ;
    m_NFE.Configuracoes.WebServices.Visualizar := m_Ini.ReadBool('WebService', 'Visualizar', False) ;
    m_NFE.Configuracoes.WebServices.Salvar     := m_Ini.ReadBool('WebService', 'SalvarSOAP', False) ;

    if m_Ini.ReadInteger('Geral','ModeloDF',0) <> 0 then
    begin
        m_NFE.Configuracoes.WebServices.AjustaAguardaConsultaRet := m_Ini.ReadBool('WebService', 'AjustarAut', False);
        m_CodMod :=65
    end
    else
        m_CodMod :=55;

    m_NSerie :=m_Ini.ReadInteger('Impressora Caixa', 'Numero Caixa', 0);

    m_NFE.Configuracoes.WebServices.AguardarConsultaRet :=m_Ini.ReadInteger('WebService','Aguardar',0);
    if m_NFE.Configuracoes.WebServices.AguardarConsultaRet <1000 then
    begin
        m_NFE.Configuracoes.WebServices.AguardarConsultaRet :=m_NFE.Configuracoes.WebServices.AguardarConsultaRet *1000;
    end;

    m_NFE.Configuracoes.WebServices.Tentativas :=m_Ini.ReadInteger('WebService','Tentativas',5);

    m_NFE.Configuracoes.WebServices.IntervaloTentativas :=m_Ini.ReadInteger('WebService','Intervalo',0) ;
    if m_NFE.Configuracoes.WebServices.IntervaloTentativas < 1000 then
    begin
        m_NFE.Configuracoes.WebServices.IntervaloTentativas :=m_NFE.Configuracoes.WebServices.IntervaloTentativas *1000;
    end;
    m_NFE.Configuracoes.WebServices.TimeOut := m_Ini.ReadInteger('WebService','TimeOut'  ,5000) ;
    m_NFE.Configuracoes.WebServices.ProxyHost := m_Ini.ReadString( 'Proxy','Host'   ,'') ;
    m_NFE.Configuracoes.WebServices.ProxyPort := m_Ini.ReadString( 'Proxy','Porta'  ,'') ;
    m_NFE.Configuracoes.WebServices.ProxyUser := m_Ini.ReadString( 'Proxy','User'   ,'') ;
    m_NFE.Configuracoes.WebServices.ProxyPass := m_Ini.ReadString( 'Proxy','Pass'   ,'') ;

    if TpcnTipoAmbiente(m_Ini.ReadInteger( 'WebService','Ambiente'  ,0)) = taHomologacao then
    begin
        m_NFE.Configuracoes.WebServices.Ambiente := taHomologacao;
    end
    else begin
        m_NFE.Configuracoes.WebServices.Ambiente := taProducao;
    end;

    m_NFE.SSL.SSLType := TSSLType( m_Ini.ReadInteger('WebService','SSLType' , 0)) ;

    //config.arquivos
    m_NFE.Configuracoes.Arquivos.Salvar           := m_Ini.ReadBool(   'Arquivos','Salvar'     ,false);
//    m_NFE.Configuracoes.Arquivos.SalvarApenasNFeProcessadas :=False ;
    m_NFE.Configuracoes.Arquivos.SepararPorMes      := m_Ini.ReadBool(   'Arquivos','PastaMensal',false);
    m_NFE.Configuracoes.Arquivos.AdicionarLiteral := m_Ini.ReadBool(   'Arquivos','AddLiteral' ,false);
    m_NFE.Configuracoes.Arquivos.EmissaoPathNFe   := m_Ini.ReadBool(   'Arquivos','EmissaoPathNFe',false);
    m_NFE.Configuracoes.Arquivos.SalvarEvento := m_Ini.ReadBool(   'Arquivos','SalvarEvento',false);
    m_NFE.Configuracoes.Arquivos.SepararPorCNPJ   := m_Ini.ReadBool(   'Arquivos','SepararPorCNPJ',false);
    m_NFE.Configuracoes.Arquivos.SepararPorModelo := m_Ini.ReadBool(   'Arquivos','SepararPorModelo',false);
    m_NFE.Configuracoes.Arquivos.PathSalvar   := m_Ini.ReadString( 'Geral','PathSalvar'  , ApplicationPath +'Logs') ;
    m_NFE.Configuracoes.Arquivos.PathSchemas  := m_Ini.ReadString( 'Geral','PathSchemas'  , ApplicationPath +'Schemas\'+GetEnumName(TypeInfo(TpcnVersaoDF), integer(m_Ini.ReadInteger( 'Geral','VersaoDF',0)) )) ;
    m_NFE.Configuracoes.Arquivos.PathNFe  := m_Ini.ReadString( 'Arquivos','PathNFe'    ,'') ;
    m_NFE.Configuracoes.Arquivos.PathInu  := m_Ini.ReadString( 'Arquivos','PathInu'    ,'') ;
    m_NFE.Configuracoes.Arquivos.PathEvento := m_Ini.ReadString( 'Arquivos','PathEvento','') ;

//    if Ini.ReadInteger( 'Geral','ModeloDF',0) = 0 then
//    NFe1.Configuracoes.Arquivos.PathSalvar := ExtractFilePath(Application.ExeName)+'\NFe\Notas Enviadas' else
//    NFe1.Configuracoes.Arquivos.PathSalvar := ExtractFilePath(Application.ExeName)+'\NFCe\Notas Enviadas';

    if m_Ini.ReadInteger( 'Geral','ModeloDF',0) <> 0 then
    begin
        if TpcnTipoImpressao(m_Ini.ReadInteger( 'DANFE','Tipo',0)) = tiMsgEletronica then
        begin
            m_NFE.DANFE :=m_DF;
        end
        else begin
            m_NFE.DANFE :=m_DEP;
            m_DEP.ImprimeEmUmaLinha     := m_Ini.ReadBool('CONFIG', 'ImprimirItem1Linha', False);
            m_DEP.ImprimeDescAcrescItem := m_Ini.ReadBool('CONFIG', 'ImprimirDescAcresItem', True);
        end;

        //
        //m_NFE.DANFE.ViaConsumidor :=True;
        //m_NFE.DANFE.ImprimirItens :=True;

        m_PP.Modelo           := TACBrPosPrinterModelo(m_Ini.ReadInteger('CONFIG', 'Modelo', 0));
        m_PP.Device.Porta     := m_Ini.ReadString('CONFIG', 'Porta', 'COM1');
        m_PP.Device.Baud      := StrToInt(m_Ini.ReadString('CONFIG', 'Baud', '9600'));
        m_PP.IgnorarTags      := m_Ini.ReadBool('CONFIG', 'IgnorarTagsFormatacao', False);
        m_PP.LinhasEntreCupons     := m_Ini.ReadInteger('CONFIG', 'Linhas', 5);
    end
    else begin
        m_NFE.DANFE :=m_DRL;
    end;

    m_NFE.DANFE.TipoDANFE  := TpcnTipoImpressao(m_Ini.ReadInteger( 'DANFE','Tipo'       ,0));
    m_NFE.DANFE.Logo       := m_Ini.ReadString( 'DANFE','LogoMarca'   ,'') ;

    m_EnvSinc :=m_Ini.ReadInteger('Certificado', 'TipoEnvio', 0) =0;

    m_ProdDscRdz :=m_Ini.ReadString('NFEProduto','Danfe Nome Reduzido','') = 'S';
    m_ProdCodInt :=m_Ini.ReadString('NFEProduto','Danfe Codigo Interno','') = 'S';


    // *********************
    // ler parametros da NFE
    // *********************
    m_reg.Load();

end;

procedure Tdm_nfe.m_NFEGerarLog(const ALogLine: string; var Tratado: Boolean);
begin
    Tratado :=True ;
    m_ErrMsg:=ALogLine;

end;

procedure Tdm_nfe.m_NFEStatusChange(Sender: TObject);
begin
    if m_StatusChange then
    begin
      case m_NFE.Status of
          stIdle: if frm_Status <> nil then frm_Status.Hide;
//      else
//          Tfrm_NFEStatus.DoShow(m_NFE.Status,
//                                m_NFE.SSL.CertCNPJ,
//                                FormatDateTime('dd/mm/yyyy',m_NFE.SSL.CertDataVenc)
//                                );
//      end;

        stNFeStatusServico: Tfrm_NFEStatus.DoShow('Verificando Status do servico...');

        stNFeRecepcao: Tfrm_NFEStatus.DoShow('Enviando dados da NFe...');

        stNfeRetRecepcao: Tfrm_NFEStatus.DoShow('Recebendo dados da NFe...');

        stNfeConsulta: Tfrm_NFEStatus.DoShow('Consultando NFe...');

        stNfeCancelamento: Tfrm_NFEStatus.DoShow('Enviando cancelamento de NFe...');

        stNfeInutilizacao: Tfrm_NFEStatus.DoShow('Enviando pedido de Inutiliza��o...');

        stNFeRecibo: Tfrm_NFEStatus.DoShow('Consultando Recibo de Lote...');

        stNFeCadastro: Tfrm_NFEStatus.DoShow('Consultando Cadastro...');

        stNFeEmail: Tfrm_NFEStatus.DoShow('Enviando Email...');

        stNFeCCe: Tfrm_NFEStatus.DoShow('Enviando Carta de Corre��o...');

        stNFeEvento: Tfrm_NFEStatus.DoShow('Enviando Evento...');
      end;
      //
      Application.ProcessMessages;
      //
    end;
end;

procedure Tdm_nfe.m_NFETransmitError(const HttpError, InternalError: Integer;
  const URL, DadosEnviados, SoapAction: string; var Retentar, Tratado: Boolean);
begin
    Tratado :=True ;

    //
    // Erro client/server
    //
    if HttpError > 0 then
    begin
        m_ErrCod :=HttpError ;
        case m_ErrCod of
            HTTP_STATUS_SERVER_ERROR: m_ErrMsg := 'Erro interno do servidor (Internal Server Error)';
            HTTP_STATUS_BAD_GATEWAY: m_ErrMsg := 'Bad Gateway';
            HTTP_STATUS_SERVICE_UNAVAIL: m_ErrMsg := 'Servi�o indispon�vel (Service Unavailable)';
            HTTP_STATUS_GATEWAY_TIMEOUT: m_ErrMsg := 'Gateway Time-Out';
            HTTP_STATUS_VERSION_NOT_SUP: m_ErrMsg := 'HTTP Version not supported';
        end;
    end
    //
    // Erro interno
    //
    else begin
        m_ErrCod :=InternalError;
        case m_ErrCod of
          ERROR_WINHTTP_TIMEOUT:
            m_ErrMsg := 'TimeOut de Requisi��o';
          ERROR_WINHTTP_NAME_NOT_RESOLVED:
            m_ErrMsg := 'O nome do servidor n�o pode ser resolvido';
          ERROR_WINHTTP_CANNOT_CONNECT:
            m_ErrMsg := 'Conex�o com o Servidor falhou';
          ERROR_WINHTTP_CONNECTION_ERROR:
            m_ErrMsg := 'A conex�o com o servidor foi redefinida ou encerrada, ou um protocolo SSL incompat�vel foi encontrado';
          ERROR_INTERNET_CONNECTION_RESET:
            m_ErrMsg := 'A conex�o com o servidor foi redefinida';
          ERROR_WINHTTP_SECURE_INVALID_CA:
            m_ErrMsg := 'Certificado raiz n�o � confi�vel pelo provedor de confian�a';
          ERROR_WINHTTP_SECURE_CERT_REV_FAILED:
            m_ErrMsg := 'Revoga��o do Certificado n�o pode ser verificada porque o servidor de revoga��o est� offline';
          ERROR_WINHTTP_SECURE_CHANNEL_ERROR:
            m_ErrMsg := 'Erro relacionado ao Canal Seguro';
          ERROR_WINHTTP_SECURE_FAILURE:
            m_ErrMsg := 'Um ou mais erros foram encontrados no certificado Secure Sockets Layer (SSL) enviado pelo servidor';
          ERROR_WINHTTP_CLIENT_CERT_NO_PRIVATE_KEY:
            m_ErrMsg := 'O contexto para o certificado de cliente SSL n�o tem uma chave privada associada a ele. O certificado de cliente pode ter sido importado para o computador sem a chave privada';
          ERROR_WINHTTP_CLIENT_CERT_NO_ACCESS_PRIVATE_KEY:
            m_ErrMsg := 'Falha ao obter a Chave Privada do Certificado para comunica��o segura';
          //
          // 3.12.2018
          ERROR_SERVICE_DOES_NOT_EXIST:
            m_ErrMsg := 'O servi�o especificado n�o existe como um servi�o instalado';

        end;
    end;
end;

function Tdm_nfe.OnlyCanc(NF: TCNotFis00; const Just: String): Boolean;
var
  N: NotaFiscal ;
  E: TInfEventoCollectionItem;
begin
    //check nota ja cancelada (101, 135, 151, 155)
    if Tdm_nfe.getInstance.CStatCancel(NF.m_codstt) then
    begin
        if NF.m_codmod = 55 then
            m_ErrMsg :='NFe j� cancelada!'
        else
            m_ErrMsg :='NFCe j� cancelada!';
        Exit(False);
    end;

    N :=Self.AddNotaFiscal(NF, True) ;

    m_NFE.EventoNFe.Evento.Clear;

    E :=m_NFE.EventoNFe.Evento.Add ;
    E.infEvento.CNPJ      :=OnlyNumber(NF.m_emit.CNPJCPF);
    E.infEvento.cOrgao    :=NF.m_codufe;
    E.infEvento.dhEvento  :=now;
    E.infEvento.tpEvento  :=teCancelamento;
    E.infEvento.nSeqEvento:=1;
    E.infEvento.chNFe     :=NF.m_chvnfe;
    E.infEvento.detEvento.nProt :=NF.m_numprot;
    E.infEvento.detEvento.xJust :=Just;

    Result :=Self.m_NFE.EnviarEvento(NF.m_codseq) ;
    if Result then
    begin
        m_ErrCod :=E.RetInfEvento.cStat;
        m_ErrMsg :=E.RetInfEvento.xMotivo;
        Result :=m_ErrCod in [135, 136, 155] ;
        if Result then
        begin
            NF.m_codstt :=E.RetInfEvento.cStat ;
            NF.m_motivo :=E.RetInfEvento.xMotivo;
            NF.m_dhreceb:=E.RetInfEvento.dhRegEvento;
            NF.m_verapp :=E.RetInfEvento.verAplic;
            NF.m_numprot:=E.RetInfEvento.nProt;
            NF.m_digval :=''; //E.RetInfEvento.digVal;
        end ;
    end
    else
        m_ErrMsg :=m_NFE.WebServices.EnvEvento.xMotivo;
end;

function Tdm_nfe.OnlyCCE(NF: TCNotFis00; const aCorrecao: String): Boolean;
var
  N: NotaFiscal ;
  E: TInfEventoCollectionItem;
begin
    //check nota ja cancelada (101, 135, 151, 155)
    if CStatCancel(NF.m_codstt) then
    begin
        if NF.m_codmod = 55 then
            m_ErrMsg :='NFe j� cancelada!'
        else
            m_ErrMsg :='NFCe j� cancelada!';
        Exit(False);
    end;

    m_RetEvento :=nil ;

    N :=AddNotaFiscal(NF, True) ;

    m_NFE.EventoNFe.Evento.Clear;
    E :=m_NFE.EventoNFe.Evento.Add ;
    E.infEvento.cOrgao    :=NF.m_codufe;
    E.infEvento.CNPJ      :=OnlyNumber(NF.m_emit.CNPJCPF);
    E.infEvento.chNFe     :=NF.m_chvnfe;
    E.infEvento.dhEvento  :=now;
    E.infEvento.tpEvento  :=teCCe;
    E.infEvento.nSeqEvento:=1;
    E.infEvento.detEvento.xCorrecao :=aCorrecao;
    E.infEvento.detEvento.xCondUso :='';

    Result :=Self.m_NFE.EnviarEvento(NF.m_codseq) ;
    if Result then
    begin
        m_ErrCod :=E.RetInfEvento.cStat;
        m_ErrMsg :=E.RetInfEvento.xMotivo;
        Result :=m_ErrCod in [135, 136] ;
        if Result then
        begin
            m_RetEvento :=E.RetInfEvento ;
        end ;
    end
    else
        m_ErrMsg :=m_NFE.WebServices.EnvEvento.xMotivo;
end;

function Tdm_nfe.OnlyCons(NF: TCNotFis00): Boolean;
begin
    Self.m_NFE.NotasFiscais.Clear;
    Self.m_ErrCod :=0;
    Result :=Self.m_NFE.Consultar(NF.m_chvnfe) ;
    Result :=Result and(Self.m_ErrCod =0);
    if Result then
    begin
        NF.m_codstt :=m_NFE.WebServices.Consulta.cStat ;
        NF.m_motivo :=m_NFE.WebServices.Consulta.XMotivo ;
        NF.m_dhreceb:=m_NFE.WebServices.Consulta.DhRecbto;
        NF.m_verapp :=m_NFE.WebServices.Consulta.verAplic;
        NF.m_numprot:=m_NFE.WebServices.Consulta.Protocolo;
        NF.m_digval :=m_NFE.WebServices.Consulta.protNFe.digVal;
    end ;
end;

function Tdm_nfe.OnlySend(NF: TCNotFis00): Boolean;
var
  N: NotaFiscal ;
begin

    //
    // gera, assina e valida XML
    //
    m_NFE.Configuracoes.Certificados.VerificarValidade :=True ;
    try

    N :=AddNotaFiscal(NF, True) ;
    if N <> nil then
    begin
        //
        // grava xml, chave e status
        //
        NF.setXML();

        //
        // chk status de erros (assinatura,valida�ao e regras de negocio)
        //
        if NF.m_codstt in[66,77,88] then
        begin
            Exit(false);
        end;
    end
    else begin
        Self.m_ErrMsg :='N�o foi poss�vel gerar a NFE!';
        Exit(false);
    end;

    m_ErrCod :=0;
    m_ErrMsg :='';

    Result :=m_NFE.Enviar(NF.m_codseq, False, m_EnvSinc);
    Result :=Result and(Self.m_ErrCod =0);
    if Result then
    begin
        //sincrono
        if m_EnvSinc then
        begin
            Self.m_Envio :=m_NFE.WebServices.Enviar ;
            NF.m_indsinc:=Ord(Self.Envio.Sincrono);
            NF.m_tipamb :=Self.Envio.TpAmb ;
            NF.m_codstt :=Self.Envio.cStat ;
            NF.m_motivo :=Self.Envio.xMotivo ;
            NF.m_verapp :=Self.Envio.verAplic ;
            NF.m_dhreceb:=Self.Envio.dhRecbto ;
        end
        //assincrono
        else begin
            Self.m_Retorno :=m_NFE.WebServices.Retorno ;
            NF.m_tipamb :=Self.Retorno.NFeRetorno.TpAmb ;
            NF.m_codstt :=Self.Retorno.NFeRetorno.cStat ;
            NF.m_motivo :=Self.Retorno.NFeRetorno.xMotivo ;
            NF.m_verapp :=Self.Retorno.NFeRetorno.verAplic;
            NF.m_numreci:=Self.Retorno.Recibo ;
            NF.m_dhreceb:=now ;
        end;

        //lote processado
        if(NF.m_codstt =TCNotFis00.CSTT_AUTORIZADO_USO)or
          (NF.m_codstt =TCNotFis00.CSTT_PROCESS       )then
        begin
            //N :=Self.m_NFE.NotasFiscais.Items[NF.ItemIndex] ;
            N :=Self.m_NFE.NotasFiscais.Items[0] ;
            NF.m_codstt :=N.NFe.procNFe.cStat ;
            NF.m_motivo :=N.NFe.procNFe.xMotivo;
            NF.m_dhreceb:=N.NFe.procNFe.dhRecbto;
            NF.m_verapp :=N.NFe.procNFe.verAplic;
            NF.m_numprot:=N.NFe.procNFe.nProt ;
            NF.m_digval :=N.NFe.procNFe.digVal;
        end;
    end ;
    finally
      m_NFE.Configuracoes.Certificados.VerificarValidade :=False ;
    end;
end;

function Tdm_nfe.OnlySend(const aNumLot: Integer): Boolean;
var
  nf: TCNotFis00 ;
  nfe: TNFe;
var
  I: Integer ;
  chv: string;
begin
    Self.m_ErrCod :=0;
    m_NFE.Configuracoes.Certificados.VerificarValidade :=True ;
    try
    Result :=m_NFE.Enviar(aNumLot, False, False, True);
    Result :=Result and(Self.m_ErrCod =0);
    if Result then
    begin
        Self.m_Retorno :=m_NFE.WebServices.Retorno ;
    end
    else begin
        m_ErrMsg :='Erro ao enviar o lote!' ;
    end;
    finally
      m_NFE.Configuracoes.Certificados.VerificarValidade :=False ;
    end;
end;

function Tdm_nfe.OnlyStatusSvc(): Boolean;
begin
    m_NFE.Configuracoes.Certificados.VerificarValidade :=True;
    try
        Result :=StatusServico.Executar ;
    finally
        m_NFE.Configuracoes.Certificados.VerificarValidade :=False ;
    end;
end;

function Tdm_nfe.PrintCCE(NF: TCNotFis00; CC: TCEventoCCE): Boolean;
var
  ptr: TRLPrinterWrapper;
  E: TInfEventoCollectionItem;
begin

    if(not Assigned(NF))or(not Assigned(CC))then
    begin
        Exit(False);
    end;

    if NF.m_codmod <> 55 then
    begin
        if TpcnTipoImpressao(NF.m_tipimp) = tiMsgEletronica then
        begin
            ptr :=RLPrinter ;

            m_df.Sistema :='.';
            m_df.MostraPreview :=m_Ini.ReadBool('DANFE','Exibir NFCE Tela', False);
            m_df.MostraStatus  :=True ;
            m_DF.Impressora :=m_Ini.ReadString('DANFE', 'Impressora Padrao NFCE', '');
            m_DF.LarguraBobina :=Trunc((m_Ini.ReadFloat('DANFE', 'Largura Bobina NFCE', 302)*100)/2.54);
            m_DF.ImprimeEmUmaLinha :=m_Ini.ReadBool('CONFIG', 'ImprimirItem1Linha', False);
            m_DF.ImprimeDescAcrescItem :=m_Ini.ReadBool('CONFIG', 'ImprimirDescAcresItem', True);
            //m_DF.Impressora :=ptr.PrinterName;

            m_NFE.DANFE :=m_DF;
        end
        else begin
            m_NFE.DANFE :=m_DEP;
            m_DEP.Sistema :='.';
            m_DEP.ImprimeEmUmaLinha     :=m_Ini.ReadBool('CONFIG', 'ImprimirItem1Linha', False);
            m_DEP.ImprimeDescAcrescItem :=m_Ini.ReadBool('CONFIG', 'ImprimirDescAcresItem', True);

            m_PP.Modelo           :=TACBrPosPrinterModelo(m_Ini.ReadInteger('CONFIG', 'Modelo', 0));
            m_PP.Device.Porta     :=m_Ini.ReadString('CONFIG', 'Porta', 'COM1');
            m_PP.Device.Baud      :=StrToInt(m_Ini.ReadString('CONFIG', 'Baud', '9600'));
            m_PP.IgnorarTags      :=m_Ini.ReadBool('CONFIG', 'IgnorarTagsFormatacao', False);
            m_PP.LinhasEntreCupons:=m_Ini.ReadInteger('CONFIG', 'Linhas', 5);
        end;

        //m_NFE.DANFE.vTroco :=NF.Troco ;
        //
//        m_NFE.DANFE.ViaConsumidor :=True;
//        m_NFE.DANFE.ImprimirItens :=True;
    end
    else begin
        m_DRL.Sistema :='.';
        m_NFE.DANFE :=m_DRL;
    end;

    m_NFE.DANFE.TipoDANFE :=TpcnTipoImpressao(NF.m_tipimp);

    Result :=m_NFE.DANFE <> nil ;
    if Result then
    begin
        try
          AddNotaFiscal(NF, True) ;

          m_NFE.EventoNFe.Evento.Clear;
          m_NFE.EventoNFe.Versao :='1.00';

          E :=m_NFE.EventoNFe.Evento.Add ;
          E.infEvento.cOrgao    :=CC.m_codorg;
          E.infEvento.tpAmb     :=m_NFE.Configuracoes.WebServices.Ambiente;
          E.infEvento.CNPJ      :=CC.m_cnpj;
          E.infEvento.chNFe     :=CC.m_chvnfe;
          E.infEvento.dhEvento  :=CC.m_dhevento;
          E.infEvento.tpEvento  :=teCCe;
          E.infEvento.nSeqEvento:=CC.m_numseq;
          E.infEvento.versaoEvento :='1.00';
          E.infEvento.detEvento.xCorrecao :=CC.m_xcorrecao;
          E.infEvento.detEvento.xCondUso :='';

          E.RetInfEvento.cStat  :=CC.m_codstt ;
          E.RetInfEvento.xMotivo:=CC.m_motivo ;
          E.RetInfEvento.dhRegEvento :=CC.m_dhreceb ;
          E.RetInfEvento.nProt :=CC.m_numprot ;

          if m_NFE.EventoNFe.GerarXML then
          begin
              m_NFE.ImprimirEvento
          end
          else begin
              m_ErrMsg :=m_NFE.EventoNFe.Gerador.ListaDeAlertas.CommaText
          end;

          if m_Ini.ReadString('Impressora Caixa', 'Guilhotina', '') = 'S' then
          begin
              m_DEP.PosPrinter.CortarPapel();
          end;
          if m_Ini.ReadString('Impressora Caixa', 'Gaveta', '') = 'S' then
          begin
              m_DEP.PosPrinter.AbrirGaveta;
          end;

        except
        end;

    end;

end;

function Tdm_nfe.PrintDANFE(NF: TCNotFis00): Boolean ;
var
  ptr: TRLPrinterWrapper;
begin

    //
    // check nota ja processada
    // (100, 110, 150, 301, 302, 303)
    {if(not CStatProcess(NF.m_codstt))or
      (not (NF.m_codstt =9)) then
    begin
        Exit(False);
    end;}

    if NF.m_codmod <> 55 then
    begin
        NF.m_tipimp :=TpcnTipoImpressao(m_Ini.ReadInteger('DANFE','Tipo', 0));
        if TpcnTipoImpressao(NF.m_tipimp) = tiMsgEletronica then
        begin
            ptr :=RLPrinter ;

            m_df.Sistema :='.';
            m_df.MostraPreview :=m_Ini.ReadBool('DANFE','Exibir NFCE Tela', False);
            m_df.MostraStatus  :=True ;
            m_DF.Impressora :=m_Ini.ReadString('DANFE', 'Impressora Padrao NFCE', '');
            m_DF.LarguraBobina :=Trunc((m_Ini.ReadFloat('DANFE', 'Largura Bobina NFCE', 302)*100)/2.54);
            m_DF.ImprimeEmUmaLinha :=m_Ini.ReadBool('CONFIG', 'ImprimirItem1Linha', False);
            m_DF.ImprimeDescAcrescItem :=m_Ini.ReadBool('CONFIG', 'ImprimirDescAcresItem', True);

            //m_DF.Impressora :=ptr.PrinterName;

            m_NFE.DANFE :=m_DF;
        end
        else begin
            m_NFE.DANFE :=m_DEP;
            m_DEP.Sistema :='.';
            m_DEP.ImprimeEmUmaLinha     :=m_Ini.ReadBool('CONFIG', 'ImprimirItem1Linha', False);
            m_DEP.ImprimeDescAcrescItem :=m_Ini.ReadBool('CONFIG', 'ImprimirDescAcresItem', True);

            m_PP.Modelo           :=TACBrPosPrinterModelo(m_Ini.ReadInteger('CONFIG', 'Modelo', 0));
            m_PP.Device.Porta     :=m_Ini.ReadString('CONFIG', 'Porta', 'COM1');
            m_PP.Device.Baud      :=StrToInt(m_Ini.ReadString('CONFIG', 'Baud', '9600'));
            m_PP.IgnorarTags      :=m_Ini.ReadBool('CONFIG', 'IgnorarTagsFormatacao', False);
            m_PP.LinhasEntreCupons:=m_Ini.ReadInteger('CONFIG', 'Linhas', 5);
        end;

        //m_NFE.DANFE.vTroco :=NF.Troco ;
        //
//        m_NFE.DANFE.ViaConsumidor :=True;
//        m_NFE.DANFE.ImprimirItens :=True;
    end
    else begin
        m_DRL.Sistema :='.';
        m_NFE.DANFE :=m_DRL;
    end;

    m_NFE.DANFE.TipoDANFE :=TpcnTipoImpressao(NF.m_tipimp);
    //
    // descontinuado !
    //m_NFE.DANFE.vTroco    :=NF.vTroco ;

    Result :=m_NFE.DANFE <> nil ;
    if Result then
    begin
        try
          m_NFE.DANFE.TipoDANFE  := TpcnTipoImpressao(m_Ini.ReadInteger( 'DANFE','Tipo'       ,0));
          m_NFE.DANFE.Logo       := m_Ini.ReadString( 'DANFE','LogoMarca'   ,'') ;
          m_NFE.DANFE.vTribFed :=NF.vTribNac ;
          m_NFE.DANFE.vTribEst :=NF.vTribEst ;
          m_NFE.DANFE.vTribMun :=NF.vTribMun ;

          AddNotaFiscal(NF, True) ;

          m_NFE.NotasFiscais.Imprimir;

          if m_Ini.ReadString('Impressora Caixa', 'Guilhotina', '') = 'S' then
          begin
              m_DEP.PosPrinter.CortarPapel();
          end;
          if m_Ini.ReadString('Impressora Caixa', 'Gaveta', '') = 'S' then
          begin
              m_DEP.PosPrinter.AbrirGaveta;
          end;
        except
        end;
    end;

end;

function Tdm_nfe.SendMail(NF: TCNotFis00; const dest_email: string): Boolean;
var
  N: NotaFiscal ;
  S: TMemoryStream;
  msg: TStrings ;
var
  email,assunt: string ;
  incPdf: Boolean;
begin
    //
    Result :=False ;
    //
    // check e-mail vazio
    email :=Trim(dest_email) ;
    if email = '' then
    begin
        if NF.m_dest.Email = '' then
        begin
            NF.LoadDest();
        end;
        email :=Trim(NF.m_dest.Email);
    end;

    if(email <> '') then
    begin

        //
        // ad. NF & Protocolo
        N :=AddNotaFiscal(NF, True) ;

        //
        // ler config. do proxy
        m_Mail.Host     :=m_Ini.ReadString( 'Email','Host'   ,'');
        m_Mail.Port     :=m_Ini.ReadString( 'Email','Port'   ,'');
        m_Mail.Username :=m_Ini.ReadString( 'Email','User'   ,'');
        m_Mail.Password :=m_Ini.ReadString( 'Email','Pass'   ,'');
        m_Mail.From     :=m_Ini.ReadString( 'Email','User'   ,'');
        m_Mail.SetSSL   :=m_Ini.ReadBool(   'Email','SSL'    ,False); // SSL
        m_Mail.SetTLS   :=m_Ini.ReadBool(   'Email','SSL'    ,False); // Auto TLS
        m_Mail.ReadingConfirmation :=False; //Pede confirma��o de leitura
        m_Mail.UseThread:=False;           //Aguarda Envio do Email(não usa thread)
        m_Mail.FromName :=NF.m_emit.xFant;
        //
        // ler msg
        S :=TMemoryStream.Create ;
        try
            m_Ini.ReadBinaryStream('Email', 'Mensagem', S);
            msg :=TStringList.Create ;
            msg.LoadFromStream(S);
        finally
            S.Free ;
        end;

        assunt :=m_Ini.ReadString('Email', 'Assunto','') ;
        incPdf :=True;

        //
        // nfce com DANFE msg eletronica, n�o atacha pdf
        //if(NF.m_codmod = 65)and(NF.m_tipimp = tiMsgEletronica) then
        //begin
        //    incPdf :=False;
        //end;

        Self.m_ErrCod :=0;
        N.EnviarEmail(email, assunt, msg, incPdf );
        Result :=ErrCod =0;
        if Result then
            m_ErrMsg :=Format('NFE enviada para "%s" com sucesso.',[email])
        else
            m_ErrMsg :=Format('N�o foi poss�vel enviar a NFE "%s", verifique!',[email]);

        msg.Free ;
    end
    else
        m_ErrMsg :='E-mail do destinat�rio n�o informado!';
end;

procedure Tdm_nfe.setStatusChange(const value: Boolean);
begin
    m_StatusChange :=value ;

end;


{ TRegNFE }

procedure TRegNFE.Load;
const
  CST_CATEGO = 'NFE' ;
var
  params: TCParametroList ;
  p: TCParametro ;
var
  acbr_tipdoc: TpcnTipoNFe ;
  acbr_tipimp: TpcnTipoImpressao;
  acbr_tpemis: TpcnTipoEmissao;
  acbr_tipamb: TpcnTipoAmbiente;
  S: TStrings ;
begin

    S :=TStringList.Create ;
    params :=TCParametroList.Create ;
    try
        //
        // carrega todos do nfe
        params.Load('', CST_CATEGO) ;

        {*
         * params ide
         *}

        natope.Key :='natureza_operacao' ;
        p :=params.IndexOf(natope.Key) ;
        if p = nil then
        begin
            p :=params.AddNew(natope.Key) ;
            p.ValTyp:=ftString ;
            P.xValor :='VENDA DENTRO DO ESTADO';
            P.Catego :=CST_CATEGO;
            p.Descricao :='Natureza da operacao padr�o de saida';
            P.Save ;
        end;
        natope.Value :=p.ReadStr() ;

        codfop.Key :='cfop' ;
        p :=params.IndexOf(codfop.Key) ;
        if p = nil then
        begin
            p :=params.AddNew(codfop.Key) ;
            p.ValTyp:=ftSmallint ;
            P.xValor :='5102';
            P.Catego :=CST_CATEGO;
            p.Descricao :='CFOP padr�o de saida';
            P.Save ;
        end;
        codfop.Value :=p.ReadInt() ;

        codmod.Key :='cod_modelo' ;
        p :=params.IndexOf(codmod.Key) ;
        if p = nil then
        begin
            p :=params.AddNew(codmod.Key) ;
            p.ValTyp:=ftSmallint ;
            P.xValor :='55';
            P.Catego :=CST_CATEGO;
            p.Descricao :='C�digo do modelo do Documento Fiscal.(55=NF-e;65=NFC-e)';
            P.Save ;
        end;
        codmod.Value :=p.ReadInt() ;

        tipdoc.Key :='tp_documentofiscal' ;
        p :=params.IndexOf(tipdoc.Key) ;
        if p = nil then
        begin
            S.Clear ;
            p :=params.AddNew(tipdoc.Key) ;
            p.ValTyp:=ftArray ;
            //
            // obtem os tipos enumerados (tipo doc.fiscal do ACBr)
            for acbr_tipdoc :=Low(TpcnTipoNFe) to High(TpcnTipoNFe) do
                S.Add(
                      GetEnumName(TypeInfo(TpcnTipoNFe), Integer(acbr_tipdoc) )
                      ) ;
            //
            // inicializa param
            P.xValor :='1';
            P.Comple :=S.CommaText ;
            P.Catego :=CST_CATEGO;
            p.Descricao :='Tipo do Documento Fiscal (0=entrada;1=sa�da)';
            P.Save ;
        end;
        tipdoc.Value :=p.ReadInt() ;


        tipimp.Key :='danfe.format' ;
        p :=params.IndexOf(tipimp.Key) ;
        if p = nil then
        begin
            S.Clear ;
            p :=params.AddNew(tipimp.Key) ;
            p.ValTyp:=ftArray ;
            //
            // obtem os tipos enumerados (tipo impressao do ACBr)
            for acbr_tipimp :=Low(TpcnTipoImpressao) to High(TpcnTipoImpressao) do
                S.Add(
                      GetEnumName(TypeInfo(TpcnTipoImpressao), Integer(acbr_tipimp) )
                      ) ;
            //
            // inicializa param
            P.xValor :='0';
            P.Comple :=S.CommaText ;
            P.Catego :=CST_CATEGO;
            p.Descricao :='Formato de impress�o do DANFE';
            P.Save ;
        end;
        tipimp.Value :=p.ReadInt() ;

        tpemis.Key :=Format('forma_emissao.%s',[Empresa.CNPJ]) ;
        p :=params.IndexOf(tpemis.Key) ;
        if p = nil then
        begin
            S.Clear ;
            p :=params.AddNew(tpemis.Key) ;
            p.ValTyp:=ftArray ;
            //
            // obtem os tipos enumerados (tipo emiss�o do ACBr)
            for acbr_tpemis :=Low(TpcnTipoEmissao) to High(TpcnTipoEmissao) do
                S.Add(
                      GetEnumName(TypeInfo(TpcnTipoEmissao), Integer(acbr_tpemis) )
                      ) ;
            //
            // inicializa param
            P.xValor :='0';
            P.Comple :=S.CommaText ;
            P.Catego :=CST_CATEGO;
            P.Descricao :='Forma de emiss�o da NFE por CNPJ' ;
            P.Save ;
        end;
        tpemis.Value :=p.ReadInt() ;

        //: ;
        tipamb.Key :=Format('tp_ambiente.%s',[Empresa.CNPJ]) ;
        p :=params.IndexOf(tipamb.Key) ;
        if p = nil then
        begin
            S.Clear ;
            p :=params.AddNew(tipamb.Key) ;
            p.ValTyp:=ftArray ;
            //
            // obtem os tipos enumerados (tipo ambiente do ACBr)
            for acbr_tipamb :=Low(TpcnTipoAmbiente) to High(TpcnTipoAmbiente) do
                S.Add(
                      GetEnumName(TypeInfo(TpcnTipoAmbiente), Integer(acbr_tipamb) )
                      ) ;
            //
            // inicializa param
            P.xValor :='1';
            P.Comple :=S.CommaText ;
            P.Catego :=CST_CATEGO;
            P.Descricao :='Identifica��o do Ambiente(1=Produ��o;2=Homologa��o)' ;
            P.Save ;
        end;
        tipamb.Value :=p.ReadInt() ;


        //
        // contigencia off-line
        //
        conting_offline.Key :=Format('conting_offline.%s',[Empresa.CNPJ]);
        p :=params.IndexOf(conting_offline.Key) ;
        if p = nil then
        begin
            p :=params.AddNew(conting_offline.Key) ;
            p.ValTyp:=ftBoolean ;
            P.xValor :='0';
            P.Catego :='NFE';
            p.Descricao :='Indicador para ativar/dasativar a conting�ncia off-line';
            P.Save ;
        end;
        conting_offline.Value :=p.ReadBoo() ;


        //
        // send sincrono
        //
        send_sincrono.Key :='send_sincrono';
        p :=params.IndexOf(send_sincrono.Key) ;
        if p = nil then
        begin
            p :=params.AddNew(send_sincrono.Key) ;
            p.ValTyp:=ftBoolean ;
            P.xValor :='0';
            P.Catego :='NFE';
            p.Descricao :='Indicador para envio de sincrono';
            P.Save ;
        end;
        send_sincrono.Value :=p.ReadBoo() ;


        //
        // mox nfe lote
        //
        send_maxnfelot.Key :='send_maxnfelot';
        p :=params.IndexOf(send_maxnfelot.Key) ;
        if p = nil then
        begin
            p :=params.AddNew(send_maxnfelot.Key) ;
            p.ValTyp:=ftSmallint ;
            P.xValor :='25';
            P.Catego :='NFE';
            p.Descricao :='Total maximo de NFE no lote';
            P.Save ;
        end;
        send_maxnfelot.Value :=p.ReadInt() ;


        //
        //
        devol_me_epp_acontribuinte_nao_sn.Key :='msg.devol_me_epp_acontribuinte_nao_sn' ;
        p :=params.IndexOf(devol_me_epp_acontribuinte_nao_sn.Key) ;
        if p = nil then
        begin
            p :=params.AddNew(devol_me_epp_acontribuinte_nao_sn.Key) ;
            p.ValTyp:=ftString ;
            P.xValor :='nos termos (RCGSN 140/18, art.59, par. 7� e 9�)';
            P.Catego :=CST_CATEGO;
            p.Descricao :='Devolu��o, ME/EPP a contribuinte n�o optante pelo SN';
            P.Save ;
        end;
        devol_me_epp_acontribuinte_nao_sn.Value :=p.ReadStr() ;


    finally
        params.Free ;
        S.Free ;
    end;

end;

procedure TRegNFE.Save() ;
var
  p: TCParametro ;
begin
    p :=TCParametro.NewParametro(conting_offline.Key, ftUnknown) ;
    if p.Load() then
    begin
        p.xValor :=IntToStr(Ord(conting_offline.Value)) ;
        p.Save ;
    end;
end;

procedure TRegNFE.setContingOffLine(const aFlag: Boolean);
var
  p: TCParametro ;
begin
    p :=TCParametro.NewParametro(conting_offline.Key, ftUnknown) ;
    if p.Load() then
    begin
        p.xValor :=IntToStr(Ord(aFlag)) ;
        p.Save ;
    end;
end;

end.
