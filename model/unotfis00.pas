{***
* Classes/Tipos para tratar a Nota Fiscal (NF-e/NFC-e)
* Atac Sistemas
* Todos os direitos reservados
* Autor: Carlos Gonzaga
* Data: 22.11.2017
*}
unit unotfis00;

interface

{*
******************************************************************************
|* PROPÓSITO: Registro de Alterações
******************************************************************************

Símbolo : Significado

[+]     : Novo recurso
[*]     : Recurso modificado/melhorado
[-]     : Correção de Bug (assim esperamos)

27.06.2019
[*] Executa Load (+performa) conforme combatibilidade (sql):
    > 8: TCNotFis00Lote.CLoadSPNotFis00Busca(m_Filter)
    <=8: TCNotFis00Lote.CLoad(m_Filter)

26.06.2019
[*] Mais 2(dois) enum(sstAutoriza,sttDenega) no filtro status

05.06.2019
[*] Tratamento do campo <nf0_xmltyp> para gravar o xml em formato apropriado
[*] Vincula NFe ao lote <nf0_codlot> para não ser processada como serviço

21.02.2019
[*] Atualização do pacote ACBr

22.12.2018
[*] descontinuado o TCNotFis00.LoadInfCpl para melhor performance

12.12.2018
[+] Novo parametro "send_maxnfelot" para definir qtas NF vai no lote

02.08.2018
[*] Fixa grupo fatura em dados de cobrança (NT.2016.002_v160)

02.08.2018
[*] Grupo a ser informado nas vendas interestaduais para consumidor final,
    não contribuinte do ICMS. (NT.2016.002_v150)

24.07.2018
[*] Grupo opcional para informações do ICMS Efetivo (NT.2016.002_v160)

20.07.2018
[+] Nova tabela "notfis02comb" para informações especificas de combustiveis

18.07.2018
[*] Extenção do filtro (modelo e serie);
    Removido o campo nf0_xml do load para melhor desempenho

16.07.2018
[-] Valor pago foi corrigido com base no troco

05.06.2018
[*] Novo membro notfis00(m_consumo) para controlar o consumo indevido
    (NT2018.001_v100)

20.06.2018
[*] Adic. novos campo membro notfis01(m_codanp, m_descamp) referente:
    02.8 cProdANP (L102) – Valores tabelas para o Código do Combustível da ANP (NT2012.003d)

04.06.2018
[+] Inclusão das mudanças do leiaute 4.0

29.05.2018
[*] Removeu o numero do pedido (venda) das informações complementares qdo Mod=55
[*] Adic. campo no filtro(TFilter.nserie), para carregar somente as notas do
    terminal, ou seja, agora a NFE vai ser autorizada pelo CX/terminal que a
    gerou (MTO CUIDADO QDO MUDAR O NUM.CX NO INI !!!)

*}

uses
  Classes, SysUtils, DB, ADODB,
  Generics.Collections ,

//  ACBrNFe, ACBrPosPrinter, ACBrNFeDANFeESCPOS,
  ACBrNFeNotasFiscais,
  pcnNFe, pcnConversao, pcnConversaoNFe,
  //
  uadodb
  ;


type
  TCGenSerial = class
  private
    m_ident: string ;
    m_value: Cardinal;
    m_inival: Cardinal;
    m_incval: Int32 ;
    m_minval: Int32 ;
    m_maxval: Cardinal;
    m_descri: string ;
    m_catego: string ;
    //
    m_cnpj: string ;
    m_codmod: Word ;
    m_nserie: Word ;
    procedure m_SetVal() ;
  public
    property Id: string read m_ident;
    property CNPJ: string read m_cnpj ;
    property CodMod: Word read m_codmod ;
    property NumSer: Word read m_nserie ;
    property Value: Cardinal read m_value write m_value;
    property Texto: string read m_descri ;
    procedure m_UpdVal() ;
    function Load(const id_serial: string): Boolean ;
  public
    class procedure SetVal(const aident, adescr: string;
      const ainival: Int32 = 1;
      const aincval: Int32 = 1;
      const aminval: Int32 = 1;
      const amaxval: Cardinal = 0);
    class function NextVal(const aIdent: string;
      const read_only: Boolean = False): Cardinal;
    class function ReadVal(const aident: string): Boolean ;
  end;

  TCGenSerialList =class(TList<TCGenSerial>)
  private
    function AddNew(): TCGenSerial ;
  public
    procedure Load() ;
  end;



type
  // INFormation
  // WARing
  // ERRor
  NotFis00CodStatus = object
    //
    // pronto para envio
    const DONE_SEND = 1;
    //
    // contigencia off-line
    const CONTING_OFFLINE = 9;
    //
    // pendente de retorno
    const RET_PENDENTE = 44;
    //
    // consumo indevido
    const ERR_CONSUMO_INDEVIDO =33 ;
    //
    // chk assinatura (cert)
    const ERR_ASSINA =55;
    const ERR_CHECK_ASSINA =66;
    //
    // XML erros
    const ERR_SCHEMA = 77;
    const ERR_REGRAS = 88;

    //
    // Uso autorizado
    const AUTORIZADO_USO = 100;
    const AUTORIZADO_USO_FORA = 150;

    //
    // envio/retorno lote
    const LOT_EM_PROCESS = 103;
    const LOT_PROCESS = 104;

    //
    // NFe/NFCe
    const NFE_NAO_CONSTA_BD = 217; //NFe não consta na base
    const NFE_JA_CANCEL = 218; //NFe JÁ CANCELADA

    // duplicidade
    const DUPL = 204;
    //
    //Rejeição 539: Duplicidade de NF-e, com diferença na Chave de Acesso
    const DUPL_DIF_CHV =539;
    //
    //Rejeição 613: Chave de Acesso difere da existente em BD (WS_CONSULTA)
    const CHV_DIF_BD =613;
    //
    // Rejeição 704: NFC-E com data-hora de emissão atrasada
    const NFCE_DH_EMIS_RETRO = 704;

    //
    // Uso Denegado
    const USO_DENEGADO = 110;
    //
    // Uso Denegado: Irregularidade fiscal do emitente
    const USO_DENEGADO_EMIT = 301;
    //
    // Uso Denegado: Irregularidade fiscal do destinatário
    const USO_DENEGADO_DEST = 302;

    //
    // Rejeição 206: NF-e já está inutilizada na Base de Dados da SEFAZ
    const NFE_JA_INUT = 206;

    //
    // erro geral SEFAZ
    const ERR_GERAL =999;
  end;

  ENotFis00 = class(Exception)
  end;

  TNotFis00TipPes =(tpFis, tpJur, tpRud);
  TNotFis00Status = (sttDoneSend, sttConting, sttAutoriza, sttDenega, sttCancel, sttInut, sttError=9, sttNone);
  TNotFis00StatusSet = set of TNotFis00Status;

  TNotFis00InfoDest =(idEmail, idNone);

  TNotFis00FilterTyp =(ftNormal, ftService, ftFech);
  //PNotFis00Filter = ^TNotFis00Filter;
  TNotFis00Filter = record
  public
    filTyp: TNotFis00FilterTyp ;
    codini,codfin: Int32;
    pedini,pedfin: Int32;
    datini,datfin: TDateTime;
    //status: (sttDoneSend, sttConting, sttProcess, sttCancel, sttError, sttService, sttNone);
    status: TNotFis00Status;
    codmod,nserie,limlot: Word;
    sttSet: TNotFis00StatusSet;
    save: Boolean;
    codlot: Int32;
    constructor Create(const codseq, codped: Integer);
    //procedure setDatIni(const aValue: TDateTime);
  end;

  TCNotFis00Lote = class;
  TCNotFis00 = class;
  TCNotFis01 = class;
  TCNotFis02comb = class;

  //
  // capa nota fiscal
  TCNotFis00 = class //(TPersistent)
  private
    m_Parent: TCNotFis00Lote;
    m_ItemIndex: Int32;
    m_oItems: TList<TCNotFis01>;
    m_oriindpag: TpcnIndicadorPagamento;
    m_oritipemi: TpcnTipoEmissao;
    m_checked: Boolean ;
    m_Troco: Currency;
    m_vtribnac: Currency;
    m_vtribimp: Currency;
    m_vtribest: Currency;
    m_vtribmun: Currency;
    m_vlrpag: Currency;
    m_oricodstt: Word ;
    procedure doInsert() ;
    procedure LoadInfCpl();
    procedure OnClearItems(Sender: TObject; const Item: TCNotFis01;
      Action: TCollectionNotification) ;
  public
    const MOD_NFE =55;
    const MOD_NFCE =65;

    const CSTT_DONE_SEND = 1;
    const CSTT_EMIS_CONTINGE = 9;
    const CSTT_RET_PENDENTE = 44;
    const CSTT_ERRO_REGRAS = 88;
    const CSTT_AUTORIZADO_USO = 100;
    const CSTT_EM_PROCESS = 103;
    const CSTT_PROCESS = 104;
    const CSTT_NFE_NAO_CONSTA = 217; //NFe não consta na base
    const CSTT_NFE_JA_CANCEL = 218; //NFe JÁ CANCELADA
    const CSTT_DUPL = 204;
    //
    //Rejeição 539: Duplicidade de NF-e, com diferença na Chave de Acesso
    const CSTT_DUPL_DIF_CHV =539;
    //
    //Rejeição 613: Chave de Acesso difere da existente em BD (WS_CONSULTA)
    const CSTT_CHV_DIF_BD =613;

    //
    // qtd.max de consumo
    const QTD_MAX_CONSUMO =3; //10 ;

    //
    // qtd max de nfe por lote (assincrono)
    QTD_MAX_NFE_IN_LOTE =50 ;

  public
    m_codseq: Int32 ;
    m_codemp: Int32 ;
    m_codufe: Int16;
    m_natope: string;
    m_indpag: TpcnIndicadorPagamento;
    m_codmod: Word;
    m_nserie: Int16;
    m_numdoc: Int32;
    m_dtemis: Tdatetime;
    m_dhsaient: Tdatetime;
    m_tipntf: TpcnTipoNFe;
    m_indope: TpcnDestinoOperacao;
    m_codmun: Int32 ;
    m_tipimp: TpcnTipoImpressao;
    m_tipemi: TpcnTipoEmissao;
    m_tipamb: TpcnTipoAmbiente;
    m_finnfe: TpcnFinalidadeNFe;
    m_indfinal: TpcnConsumidorFinal;
    m_indpres: TpcnPresencaComprador;
    m_procemi: TpcnProcessoEmissao;
    m_verproc: string;
    m_dhcont: Tdatetime;
    m_justif: string ;
    m_chvref: string ;
    m_emit: TEmit ;
    m_codcli: Integer;
    m_tippes: TNotFis00TipPes ;
    m_dest: TDest ;

    m_icmstot: TICMSTot ;
    m_transp: TTransp;
    m_cobr: TCobr;
    m_pag: TpagCollection;
    m_infCpl: String;

    m_codped: Int32;

    //sistema
    m_datsys: TDateTime;

    //status
    m_codstt: Word ;
    m_motivo: string;

    //envio
    m_chvnfe: string ;
    m_xml: string ;
    m_indsinc: smallint;

    //retorno
    m_verapp: string ;
    m_dhreceb: Tdatetime ;
    m_numreci: string ;
    m_numprot: string;
    m_digval: string;

    // consumo indevido
    m_consumo: Int16 ;

    //
    // lote
    m_codlot: Int32 ;

    //
    // flag
    m_tag: Int16 ;

    function UpdateNFe(const dtemis: Tdatetime;
      const pro_nomrdz, pro_codint: SmallInt;
      out err_msg: string): Boolean ;

  public
//    property Parent: TCNotFisLot read m_oParent;
    property Items: TList<TCNotFis01> read m_oItems ;
    property ItemIndex: Integer read m_ItemIndex ;
    property Checked: Boolean read m_Checked write m_Checked;
    property vTroco: Currency read m_Troco ;

    property vTribNac: Currency read m_vtribnac;
    property vTribImp: Currency read m_vtribimp;
    property vTribEst: Currency read m_vtribest;
    property vTribMun: Currency read m_vtribmun;

    constructor Create ;
    destructor Destroy; override ;

    function AddItem(): TCNotFis01;
    function IndexOf(const codint: Int32): TCNotFis01;

    function Load(const codseq: Integer =0): Boolean ;
    function LoadFromPed(const codped: Integer): Boolean ;
    procedure LoadItems();
    procedure LoadFromQ(Q: TDataSet);
    procedure LoadDest() ;
    procedure LoadFormaPgto();
    function LoadXML(): Boolean ;

    procedure FillDataSet(aDS: TDataSet) ;

    procedure setStatus() ;
    procedure setXML() ;

    procedure setContinge(const xJustif: string; const aCancel: Boolean =false) ;
    procedure setFormaEmissao(const aTipEmis: TpcnTipoEmissao;
      const aJustif: string) ;

    procedure setConsumoWS() ;
    procedure setCodLote(const aCodLot: Integer) ;

    function CStatProcess(): Boolean;
    function CStatCancel(): Boolean;
    function CStatError(): Boolean;
    function CStatAutorizado(): Boolean ;
    function CStatDenegado(): Boolean ;

  public

    class function NewNFCe(const nserie: smallint;
      const tipemi: TpcnTipoEmissao;
      const tipamb: TpcnTipoAmbiente;
      const indpag: TpcnIndicadorPagamento ;
      const indpres: TpcnPresencaComprador;
      const dtemis: Tdatetime ;
      const codped: Integer;
      const pro_nomrdz, pro_codint: SmallInt): TCNotFis00;

    class function NewNFe(const natope: string ;
      const codufe, codmun: Integer;
      const indpag: TpcnIndicadorPagamento ;
      const codmod, nserie: smallint;
      const tipntf: TpcnTipoNFe ;
      const indope: TpcnDestinoOperacao;
      const tipimp: TpcnTipoImpressao;
      const tipemi: TpcnTipoEmissao;
      const tipamb: TpcnTipoAmbiente;
      const finnfe: TpcnFinalidadeNFe;
      const indfinal: TpcnConsumidorFinal;
      const indpres: TpcnPresencaComprador;
      const dtemis: Tdatetime ;
      const chvref: string;
      const modfret: TpcnModalidadeFrete;
      const codped: Integer;
      const pro_nomrdz, pro_codint: SmallInt): TCNotFis00;
  end;

  //
  // item de nota fiscal
  TCNotFis01 = class //(TPersistent)
  private
    m_oParent: TCNotFis00;
    m_ItemIndex: Int32;
    m_codint: Int32;
    procedure doInsert() ;
  public
    { info do produto/item }
    m_codseq: Int32;
    m_codntf: Int32;
    m_codpro: string;
    m_codean: string;
    m_descri: string;
    m_codncm: string;
    m_codest: string;
    m_extipi: string;
    m_cfop: Word;
    m_undcom: string;
    m_qtdcom: Double;
    m_vlrcom: Double;
    m_vlrpro: Currency;
    m_eantrib: string;
    m_undtrib: string;
    m_qtdtrib: Double;
    m_vlrtrib: Double;
    m_vlrfret: Currency;
    m_vlrsegr: Currency;
    m_vlrdesc: Currency;
    m_vlroutr: Currency;
    m_indtot: TpcnIndicadorTotal;
    m_infadprod: string ;
    //
    // cProdANP
    m_codanp: Int32 ;
    m_descanp: string;
  public
    { info imposto }
    m_cst: SmallInt;
    m_csosn: SmallInt;
    m_orig: TpcnOrigemMercadoria;
    m_modbc: SmallInt;
    m_predbc: Single;
    m_vbc: Currency;
    m_picms: Single;
    m_vicms: Currency;
    m_modbcst: SmallInt;
    m_pmvast: Single;
    m_predbcst: Single;
    m_vbcst: Currency;
    m_picmsst: Single;
    m_vicmsst: Currency;
    m_vbcstret: Currency;
    m_vicmsstret: Currency;

    m_vbcstdest: Currency;
    m_vicmsstdest: Currency;

    m_pcredsn: Single;
    m_vcredicmssn: Single;

    //
    // aliq. FCP
    m_vbcfcp: Currency;
    m_pfcp: Single;
    m_vfcp: Currency;
    m_vbcfcpst: Currency;
    m_pfcpst: Single;
    m_vfcpst: Currency;


    //
    // Grupo opcional para informações do ICMS Efetivo
    m_predbcefet: Single;
    m_vbcefet   : Currency;
    m_picmsefet : Single;
    m_vicmsefet : Currency;

    m_ipi: TIPI ;
    m_pis: TPIS ;
    m_cofins: TCOFINS;

    //
    // Grupo a ser informado nas vendas interestaduais para
    // consumidor final, não contribuinte do ICMS.
    m_vbcufdest: Currency;
    m_vbcfcpufdest: Currency;
    m_pfcpufdest: Single;
    m_picmsufdest: Single;
    m_picmsinter: Single;
    m_picmsinterpart: Single;
    m_vfcpufdest: Currency;
    m_vicmsufdest: Currency;
    m_vicmsufremet: Currency;

    //
    // aliq. IBPT
    m_ibptaliqnac: Currency;
    m_ibptaliqimp: Currency;
    m_ibptaliqest: Currency;
    m_ibptaliqmun: Currency;

    //
    // grupo combustiveis
    m_comb: TCNotFis02comb ;

    //
    // Grupo imposto devolvido
    m_pdevol: single ;
    m_vipidevol: Currency;

  public
    property ItemIndex: Integer read m_ItemIndex;
    constructor Create;
    destructor Destroy; override;
  end;

  //
  // item / combustivel
  TCNotFis02comb = class //(TPersistent)
  private
    m_oParent: TCNotFis01;
  public
    m_codntf: Int32;
    m_codanp: Int32;
    m_descri: string;
    m_pglp: Currency;
    m_pgnn: Currency;
    m_pgni: Currency;
    m_vpart: Currency;
    m_ufcons: string;
  end;

  //
  // lote de notas fiscais
  TCNotFis00Lote = class
  private
    m_oItems: TList<TCNotFis00>;
    m_CodSeq: Int32;
    m_vTotalNF: Currency ;
    m_Filter: TNotFis00Filter;
    procedure setFilter(const aValue: TNotFis00Filter);
    procedure OnClear(Sender: TObject; const Item: TCNotFis00;
      Action: TCollectionNotification) ;
  public
    property Items: TList<TCNotFis00> read m_oItems ;
    property CodSeq: Int32 read m_CodSeq;
    property vTotalNF: Currency read m_vTotalNF write m_vTotalNF;
    property Filter: TNotFis00Filter read m_Filter write setFilter;
    constructor Create;
    destructor Destroy; override ;
    function AddNotFis00(const codseq: Int32): TCNotFis00;
    function IndexOf(const codseq: Int32): TCNotFis00; overload;
    function IndexOf(const chvnfe: string): TCNotFis00; overload;
    function Load(const afilter: TNotFis00Filter): Boolean ;
    function LoadCX(const codcxa: smallint; out lstcod: string): Boolean;
    procedure Desvincula(const aNumSer: SmallInt) ;
  public
    class function CLoad(const afilter: TNotFis00Filter): TDataSet ; //TADOQuery ;
    class function CLoadXML(const afilter: TNotFis00Filter): TADOQuery ;
    class function CLoadSPNotFis00Busca(const afilter: TNotFis00Filter): TDataSet ;
  end;

  TInutNumeroFilter = record
    codemp,ano: Word ;
  end;
  TCInutNumeroList = class;
  TCInutNumero = class
  private
    m_Parent: TCInutNumeroList ;
    m_Index: Int32;
  public
    m_codseq: Int32;
    m_codemp:	smallint;
    m_tipamb: TpcnTipoAmbiente;
    m_codufe: Word ;
    m_ano: Word;
    m_cnpj:	string;
    m_codmod:	Word ;
    m_nserie: Word ;
    m_numini: Int32;
    m_numfin: Int32;
    m_justif:	string;
    m_codstt: Word ;
    m_motivo: string;
    m_verapp: string;
    m_dhreceb: Tdatetime;
    m_numprot: string;
    m_ultnum: Int32;
    procedure DoInsert(const codstt: Word; const motivo: string) ;
  end;

  TCInutNumeroList = class (TList<TCInutNumero>)
  private
  public
    function AddNew(): TCInutNumero;
    function Load(const AFilter: TInutNumeroFilter): Boolean ;
    function LoadOfSerie(const numser: Word): Boolean ;
  end;


//function GTIN_DV(const aCodigo : String ): String ;
//function GTIN_Valida(const aCodigo : String ): Boolean ;

implementation

uses StrUtils, Variants, Math,
//  ACBrUtil,
  uparam, ucademp;

{function GTIN_DV(const aCodigo: String ): String ;
var
  comp, DV, C: Integer ;
begin
    Result :='';
    if Length(aCodigo) <= 8 then
        Result :=PadLeft(Trim(aCodigo), 8, '0')
    else if Length(aCodigo) <= 12 then
        Result :=PadLeft(Trim(aCodigo), 12, '0')
    else if Length(aCodigo) <= 13 then
        Result :=PadLeft(Trim(aCodigo), 13, '0')
    else if Length(aCodigo) <= 14 then
        Result :=PadLeft(Trim(aCodigo), 14, '0');

    comp :=Length(Result) ;

    DV :=0;
    for C :=comp downto 1 do
    begin
        if not (Result[C] in['0'..'9']) then
        begin
            Result :='';
            Break ;
        end;
        DV :=DV + (StrToInt(Result[C]) *IfThen(Odd(C), 1, 3));
    end;

    if Result = '' then
    begin
        Exit('');
    end;

    DV := (Ceil(DV /10) *10) -DV ;

    Result :=IntToStr(DV);
end;

function GTIN_Valida(const aCodigo : String ): Boolean ;
begin
    Result :=false ;
    case Length(aCodigo) of
         8: Result :=aCodigo[ 8] =GTIN_DV(aCodigo) ;
        12: Result :=aCodigo[12] =GTIN_DV(aCodigo) ;
        13: Result :=aCodigo[13] =GTIN_DV(aCodigo) ;
        14: Result :=aCodigo[14] =GTIN_DV(aCodigo) ;
    end;
end;}


{ TCGenSerial }

function TCGenSerial.Load(const id_serial: string): Boolean;
var
  Q: TADOQuery ;
begin
    //
    Q :=TADOQuery.NewADOQuery();
    try
      Q.AddCmd('declare @ser_id varchar(50); set @ser_id =%s; ',[Q.FStr(id_serial)]) ;
      Q.AddCmd('select *from genserial                        ');
      Q.AddCmd('where ser_ident =@ser_id                      ');
      Q.Open ;
      Result :=not Q.IsEmpty ;
      if Result then
      begin
          Self.m_ident :=Q.Field('ser_ident').AsString ;
          Self.m_value :=Q.Field('ser_valor').AsInteger;
          Self.m_inival :=Q.Field('ser_inival').AsInteger;
          Self.m_incval :=Q.Field('ser_incval').AsInteger;
          Self.m_minval :=Q.Field('ser_minval').AsInteger;
          Self.m_maxval :=Q.Field('ser_maxval').AsInteger;
          Self.m_descri :=Q.Field('ser_descri').AsString ;
      end;
    finally
      Q.Free ;
    end;
end;

procedure TCGenSerial.m_SetVal;
var
  sp: TADOStoredProc ;
begin
    sp :=TADOStoredProc.NewADOStoredProc('dbo.sp_setval');
    try
        sp.AddParamWithValue('@ser_ident', ftString, Self.m_ident);
        sp.AddParamWithValue('@ser_inival', ftInteger, Self.m_inival);
        sp.AddParamWithValue('@ser_incval', ftInteger, Self.m_incval);
        sp.AddParamWithValue('@ser_minval', ftInteger, Self.m_minval);
        sp.AddParamWithValue('@ser_maxval', ftInteger, Self.m_maxval);
        if Length(Self.m_descri) > 0 then
            sp.AddParamWithValue('@ser_descri', ftString, Self.m_descri)
        else
            sp.AddParamWithValue('@ser_descri', ftString, ' ');
        sp.ExecProc ;
    finally
        sp.Free ;
    end;
end;

procedure TCGenSerial.m_UpdVal;
var
  C: TADOCommand ;
begin
    C :=TADOCommand.NewADOCommand();
    try
        C.AddCmd('declare @ident varchar(50); set @ident =%s;',[C.FStr(Self.m_ident)]) ;
        C.AddCmd('declare @value int        ; set @value =%d;',[Self.m_value        ]) ;
        C.AddCmd('update genserial set ser_valor =@value     ');
        C.AddCmd('where ser_ident =@ident                    ');
        C.Execute ;
    finally
        C.Free ;
    end;
end;

class function TCGenSerial.NextVal(const aIdent: string;
  const read_only: Boolean): Cardinal;
var
  sp: TADOStoredProc ;
begin
    sp :=TADOStoredProc.NewADOStoredProc('dbo.sp_nextval');
    try
        //
        sp.AddParamWithValue('@ser_ident', ftString, aIdent);
        sp.AddParamOut('@ser_outval', ftInteger);
        sp.AddParamWithValue('@read_only', ftSmallint, Ord(read_only));

        try
            sp.ExecProc ;
            Result :=sp.Param('@ser_outval').Value ;
        except
            Result :=0;
        end;

    finally
        sp.Free ;
    end;
end;

class function TCGenSerial.ReadVal(const aident: string): Boolean;
var
  Q: TADOQuery ;
begin
    Q :=TADOQuery.NewADOQuery();
    try
        Q.AddCmd('select *from genserial where ser_ident =%s',[Q.FStr(aident)]) ;
        Q.Open ;
        Result :=not Q.IsEmpty ;
    finally
        Q.Free ;
    end;
end;

class procedure TCGenSerial.SetVal(const aident, adescr: string;
  const ainival, aincval, aminval: Int32;
  const amaxval: Cardinal);
var
  S: TCGenSerial ;
  p1,p2: Integer ;
begin
    S :=TCGenSerial.Create ;
    try
        S.m_ident :=aident ;
        S.m_inival:=ainival;
        S.m_incval:=aincval;
        S.m_minval:=aminval;
        S.m_maxval:=amaxval;
        S.m_descri:=adescr ;
        S.m_SetVal();
    finally
        S.Free ;
    end;
end;

{ TCGenSerialList }

function TCGenSerialList.AddNew: TCGenSerial;
begin
    Result :=TCGenSerial.Create ;
    Add(Result) ;
end;

procedure TCGenSerialList.Load;
var
  Q: TADOQuery ;
  S: TCGenSerial ;
var
  ident,modelo,serie: string ;
  //
  function ExtVal(): string ;
  var P: Word ;
  begin
      P :=Pos('.', ident);
      if P > 0 then
      begin
        Result :=Copy(ident, 1, P-1);
        ident  :=Copy(ident, P+1, length(ident)) ;
      end
      else begin
        Result :=ident ;
        ident :='';
      end;
  end;
  //
begin
    //
    // clear
    Self.Clear ;

    //
    // load
    Q :=TADOQuery.NewADOQuery();
    try
      Q.AddCmd('select *from genserial');
      Q.Open ;
      while not Q.Eof do
      begin
          S :=Self.AddNew ;
          S.m_ident :=Q.Field('ser_ident').AsString ;
          S.m_value :=Q.Field('ser_valor').AsInteger;
          S.m_inival :=Q.Field('ser_inival').AsInteger;
          S.m_incval :=Q.Field('ser_incval').AsInteger;
          S.m_minval :=Q.Field('ser_minval').AsInteger;
          S.m_maxval :=Q.Field('ser_maxval').AsInteger;
          S.m_descri :=Q.Field('ser_descri').AsString ;

          //
          // extrai
          ident :=S.m_ident ;
          modelo:=ExtVal ;
          if modelo = 'nfe' then S.m_codmod :=55
          else                   S.m_codmod :=65;
          S.m_cnpj  :=ExtVal ;
          serie :=ExtVal ;
          serie :=ExtVal ;
          S.m_nserie:=StrToIntDef(serie, 0) ;

          //
          Q.Next ;
      end;

    finally
      Q.Free ;
    end;
end;



{ TNotFis00Filter }

constructor TNotFis00Filter.Create(const codseq, codped: Integer);
begin
    Self.filTyp :=ftNormal ;
    Self.codini :=codseq;
    Self.codfin :=codseq;
    Self.pedini :=codped;
    Self.pedfin :=codped;
    Self.datini :=0;
    Self.datfin :=0;
    Self.status :=sttNone ;
    Self.codmod :=0;
    Self.nserie :=0;
    Self.limlot :=0;
    Self.codlot :=0;
    Self.save :=False ;
end;

{ TCNotFis00 }

function TCNotFis00.AddItem: TCNotFis01;
begin
    Result :=TCNotFis01.Create ;
    Result.m_oParent :=Self ;
    Result.m_ItemIndex :=Items.Count ;
    Items.Add(Result);
end;


constructor TCNotFis00.Create;
begin
    inherited Create;
    self.m_Parent :=nil;
    self.m_ItemIndex :=0;
    self.m_oItems :=TList<TCNotFis01>.Create;
    self.m_oItems.OnNotify :=OnClearItems ;

    self.m_indpag :=ipVista ;
    self.m_codmod :=55;
    self.m_nserie :=0;
    self.m_tipntf :=tnSaida ;
    self.m_indope :=doInterna ;
    self.m_tipimp :=tiRetrato;
    self.m_finnfe :=fnNormal;
    self.m_procemi :=peAplicativoContribuinte;

    self.m_emit :=TEmit.Create;//(nil);
    self.m_dest :=TDest.Create;//(nil);

    self.m_icmstot :=TICMSTot.Create ;
    self.m_transp :=TTransp.Create;//(nil);
    self.m_cobr :=TCobr.Create;//(nil);
    self.m_pag  :=TpagCollection.Create;//(nil);
    //
    // tag ctrl
    self.m_tag :=0;
end;

function TCNotFis00.CStatAutorizado: Boolean;
begin
    case Self.m_codstt of
        100, 150: Result := True;
      else
          Result :=False;
    end;
end;

function TCNotFis00.CstatCancel(): Boolean;
begin
    case Self.m_codstt of
        101, 135, 151, 155: Result := True;
      else
          Result := False;
    end;
end;

function TCNotFis00.CStatDenegado: Boolean;
begin
    case Self.m_codstt of
          110, 301, 302, 303: Result := True;
      else
          Result :=False;
    end;
end;

function TCNotFis00.CStatError: Boolean;
var
  cs: NotFis00CodStatus ;
begin
    Result :=(not CStatProcess)and //não esta processada
             (not CStatCancel )and //não esta cancelada
             (not(Self.m_codstt = 0))and //não status inicial
             (not(Self.m_codstt =cs.DONE_SEND))and
             (not(Self.m_codstt =cs.CONTING_OFFLINE))and
             (not(Self.m_codstt =cs.RET_PENDENTE))and
             (not(Self.m_codstt =cs.ERR_ASSINA))and
             (not(Self.m_codstt =cs.ERR_CHECK_ASSINA))and
             (not(Self.m_codstt =cs.ERR_SCHEMA))and
             (not(Self.m_codstt =cs.ERR_REGRAS))and
             (not(Self.m_codstt =cs.LOT_EM_PROCESS))and
             (not(Self.m_codstt =cs.NFE_NAO_CONSTA_BD))and
             (not(Self.m_codstt =cs.NFE_JA_CANCEL))and
             (not(Self.m_codstt =cs.DUPL))and
             (not(Self.m_codstt =cs.DUPL_DIF_CHV))and
             (not(Self.m_codstt =cs.CHV_DIF_BD))and
             (not(Self.m_codstt =cs.NFCE_DH_EMIS_RETRO))and
             (not(Self.m_codstt =cs.ERR_GERAL)) ;
end;

function TCNotFis00.CStatProcess(): Boolean;
begin
    case Self.m_codstt of
        100, 110, 150, 301, 302, 303: Result := True;
      else
          Result :=False;
    end;
end;

destructor TCNotFis00.Destroy;
begin
    m_oItems.Destroy ;
    m_emit.Free ;
    m_dest.Free ;
    m_transp.Free ;
    m_cobr.Free ;
    m_pag.Free ;
    inherited;
end;

procedure TCNotFis00.doInsert;
var
  sp: TADOStoredProc;
  C: TADOCommand;
  I: TCNotFis01;
begin

    sp :=TADOStoredProc.NewADOStoredProc('dbo.NotFis00_Add');
    try
        sp.AddParamWithValue('@codemp', ftSmallint, Self.m_codemp);
        sp.AddParamWithValue('@codufe', ftSmallint, Self.m_codufe);
        sp.AddParamWithValue('@natope', ftString, Self.m_natope);
        sp.AddParamWithValue('@indpag', ftSmallint, ord(Self.m_indpag));
        sp.AddParamWithValue('@codmod', ftInteger, Self.m_codmod);
        sp.AddParamWithValue('@nserie', ftSmallint, Self.m_nserie);
        sp.AddParamWithValue('@dtemis', ftDateTime, Self.m_dtemis);
        sp.AddParamWithValue('@tipntf', ftSmallint, ord(Self.m_tipntf));
        sp.AddParamWithValue('@indope', ftSmallint, ord(Self.m_indope));
        sp.AddParamWithValue('@codmun', ftInteger, Self.m_codmun);
        sp.AddParamWithValue('@tipimp', ftSmallint, ord(Self.m_tipimp));
        sp.AddParamWithValue('@tipemi', ftSmallint, ord(Self.m_tipemi));
        sp.AddParamWithValue('@finnfe', ftSmallint, ord(Self.m_finnfe));
        sp.AddParamWithValue('@indfinal', ftSmallint, ord(Self.m_indfinal));
        sp.AddParamWithValue('@indpres', ftSmallint, ord(Self.m_indpres));
        sp.AddParamWithValue('@verproc', ftString, Self.m_verproc);
        sp.AddParamWithValue('@chvref', ftString, Self.m_chvref);
        sp.AddParamWithValue('@modfret', ftSmallint, ord(Self.m_transp.modFrete));
        sp.AddParamWithValue('@codped', ftInteger, Self.m_codcli);
        sp.AddParamWithValue('@begintran', ftSmallint, 1);
        sp.AddParamOut('@codseq', ftInteger);

        try
            ConnectionADO.BeginTrans ;

            sp.ExecProc ;
            Self.m_codseq :=sp.Param('@codseq').Value ;

            for I in Self.Items do
            begin
                I.doInsert ;
            end;

            ConnectionADO.CommitTrans ;

        except
            if ConnectionADO.InTransaction then
            begin
                ConnectionADO.RollbackTrans;
            end;
            raise;
        end;

    finally
        sp.Free ;
    end;

      {
      C.AddCmd('begin tran ');
      C.AddCmd('  insert into notfis00(nf0_codufe,  ');
      C.AddCmd('                      nf0_natope ,  ');
      C.AddCmd('                      nf0_indpag ,  ');
      C.AddCmd('                      nf0_codmod ,  ');
      C.AddCmd('                      nf0_nserie ,  ');
      C.AddCmd('                      nf0_numdoc ,  ');
      C.AddCmd('                      nf0_dtemis ,  ');
      C.AddCmd('                      nf0_dhsaient, ');
      C.AddCmd('                      nf0_tipntf ,  ');
      C.AddCmd('                      nf0_codmun ,  ');
      C.AddCmd('                      nf0_tipimp ,  ');
      C.AddCmd('                      nf0_tipemi ,  ');
      C.AddCmd('                      nf0_tipamb ,  ');
      C.AddCmd('                      nf0_finnfe ,  ');
      C.AddCmd('                      nf0_indfinal, ');
      C.AddCmd('                      nf0_indpres , ');
      C.AddCmd('                      nf0_procemi , ');
      C.AddCmd('                      nf0_verproc , ');
      //emit
      C.AddCmd('                      nf0_emicnpj ,   ');
      C.AddCmd('                      nf0_eminome ,   ');
      C.AddCmd('                      nf0_emifant ,   ');
      C.AddCmd('                      nf0_emilogr ,   ');
      C.AddCmd('                      nf0_eminumero , ');
      C.AddCmd('                      nf0_emicomple , ');
      C.AddCmd('                      nf0_emibairro , ');
      C.AddCmd('                      nf0_emicodmun , ');
      C.AddCmd('                      nf0_emimun ,    ');
      C.AddCmd('                      nf0_emiufe ,    ');
      C.AddCmd('                      nf0_emicep ,    ');
      C.AddCmd('                      nf0_emifone ,   ');
      C.AddCmd('                      nf0_emiie ,     ');
//        C.AddCmd('                      nf0_emiim ,     ');
//        C.AddCmd('                      nf0_emicnae ,   ');
      C.AddCmd('                      nf0_emiiest,    ');

      C.AddCmd('                      nf0_emicrt ,    ');
      //dest
      C.AddCmd('                      nf0_dstcnpjcpf, ');
      C.AddCmd('                      nf0_dstideestr, ');
      C.AddCmd('                      nf0_dstnome ,   ');
      C.AddCmd('                      nf0_dstlogr ,   ');
      C.AddCmd('                      nf0_dstnumero , ');
      C.AddCmd('                      nf0_dstcomple , ');
      C.AddCmd('                      nf0_dstbairro , ');
      C.AddCmd('                      nf0_dstcodmun , ');
      C.AddCmd('                      nf0_dstmun ,    ');
      C.AddCmd('                      nf0_dstufe ,    ');
      C.AddCmd('                      nf0_dstcep ,    ');
      C.AddCmd('                      nf0_dstfone ,   ');
      C.AddCmd('                      nfe_dstindie,   ');
      C.AddCmd('                      nf0_dstie ,     ');
      C.AddCmd('                      nf0_dstisuf ,   ');
//        C.AddCmd('                      nf0_dstim ,     ');
      C.AddCmd('                      nf0_dstemail )  ');

      //
      //adiciona valores, conforme lista de campos acima!
      //

      //ide
      C.AddCmd('  values             (%d,--nf0_codufe  ',[Self.m_codufe]);
      C.AddCmd('                      %s,--nf0_natope  ',[C.FStr(Self.m_natope)]);
      C.AddCmd('                      %d,--nf0_indpag  ',[Ord(Self.m_indpag)]);
      C.AddCmd('                      %s,--nf0_codmod  ',[C.FStr(Self.m_codmod)]);
      C.AddCmd('                      %d,--nf0_nserie  ',[Self.m_nserie]);
      C.AddCmd('                      %d,--nf0_numdoc  ',[Self.m_numdoc]);
      C.AddCmd('                      %s,--nf0_dtemis  ',[C.FStr(CFrmtStr.Dat(Self.m_dtemis))]);
      C.AddCmd('                      %s,--nf0_dhsaient',[C.FStr(CFrmtStr.Dat(Self.m_dhsaient))]);
      C.AddCmd('                      %d,--nf0_tipntf  ',[Ord(Self.m_tipntf)]);
      C.AddCmd('                      %d,--nf0_codmun  ',[Self.m_codmun]);
      C.AddCmd('                      %d,--nf0_tipimp  ',[Ord(Self.m_tipimp)]);
      C.AddCmd('                      %d,--nf0_tipemi  ',[Ord(Self.m_tipemi)]);
      C.AddCmd('                      %d,--nf0_tipamb  ',[Ord(Self.m_tipamb)]);
      C.AddCmd('                      %d,--nf0_finnfe  ',[Ord(Self.m_finnfe)]);
      C.AddCmd('                      %d,--nf0_indfinal',[Ord(Self.m_indfinal)]);
      C.AddCmd('                      %d,--nf0_indpres ',[Ord(Self.m_indpres)]);
      C.AddCmd('                      %d,--nf0_procemi ',[Ord(Self.m_procemi)]);
      C.AddCmd('                      %s,--nf0_verproc ',[C.FStr(Self.m_verproc)]);
      //emit
      C.AddCmd('                      %s,--nf0_emicnpj    ',[C.FStr(m_emit.CNPJCPF)]);
      C.AddCmd('                      %s,--nf0_eminome    ',[C.FStr(m_emit.xNome)]);
      C.AddCmd('                      %s,--nf0_emifant    ',[C.FStr(m_emit.xFant)]);
      C.AddCmd('                      %s,--nf0_emilogr    ',[C.FStr(m_emit.EnderEmit.xLgr)]);
      C.AddCmd('                      %s,--nf0_eminumero  ',[C.FStr(m_emit.EnderEmit.nro)]);
      C.AddCmd('                      %s,--nf0_emicomple  ',[C.FStr(m_emit.EnderEmit.xCpl)]);
      C.AddCmd('                      %s,--nf0_emibairro  ',[C.FStr(m_emit.EnderEmit.xBairro)]);
      C.AddCmd('                      %d,--nf0_emicodmun  ',[m_emit.EnderEmit.cMun]);
      C.AddCmd('                      %s,--nf0_emimun     ',[C.FStr(m_emit.EnderEmit.xMun)]);
      C.AddCmd('                      %s,--nf0_emiufe     ',[C.FStr(m_emit.EnderEmit.UF)]);
      C.AddCmd('                      %d,--nf0_emicep     ',[m_emit.EnderEmit.CEP]);
      C.AddCmd('                      %s,--nf0_emifone    ',[C.FStr(m_emit.EnderEmit.fone)]);
      C.AddCmd('                      %s,--nf0_emiie      ',[C.FStr(m_emit.IE)]);
      C.AddCmd('                      %s,--nf0_emiiest    ',[C.FStr(m_emit.IEST)]);
//        C.AddCmd('                      %s,--nf0_emiim      ',[C.FStr(m_emit.IM)]);
//        C.AddCmd('                      %s,--nf0_emicnae    ',[C.FStr(m_emit.CNAE)]);
      C.AddCmd('                      %d,--nf0_emicrt     ',[Ord(m_emit.CRT)]);
      //dest
      C.AddCmd('                      %s,--nf0_dstcnpjcpf',[C.FStr(m_dest.CNPJCPF)]);
      C.AddCmd('                      %s,--nf0_dstideestr',[C.FStr(m_dest.idEstrangeiro)]);
      C.AddCmd('                      %s,--nf0_dstnome  ',[C.FStr(m_dest.xNome)]);
      C.AddCmd('                      %s,--nf0_dstlogr  ',[C.FStr(m_dest.EnderDest.xLgr)]);
      C.AddCmd('                      %s,--nf0_dstnumero',[C.FStr(m_dest.EnderDest.nro)]);
      C.AddCmd('                      %s,--nf0_dstcomple',[C.FStr(m_dest.EnderDest.xCpl)]);
      C.AddCmd('                      %s,--nf0_dstbairro',[C.FStr(m_dest.EnderDest.xBairro)]);
      C.AddCmd('                      %d,--nf0_dstcodmun',[m_dest.EnderDest.cMun]);
      C.AddCmd('                      %s,--nf0_dstmun   ',[C.FStr(m_dest.EnderDest.xMun)]);
      C.AddCmd('                      %s,--nf0_dstufe   ',[C.FStr(m_dest.EnderDest.UF)]);
      C.AddCmd('                      %d,--nf0_dstcep   ',[m_dest.EnderDest.CEP]);
      C.AddCmd('                      %s,--nf0_dstfone  ',[C.FStr(m_dest.EnderDest.fone)]);
      C.AddCmd('                      %d,--nfe_dstindie ',[Ord(m_dest.indIEDest)]);
      C.AddCmd('                      %s,--nf0_dstie    ',[C.FStr(m_dest.IE)]);
      C.AddCmd('                      %s,--nf0_dstisuf  ',[C.FStr(m_dest.ISUF)]);
//        C.AddCmd('                      %s,--nf0_dstim',[C.FStr(m_dest.IM)]);
      C.AddCmd('                      %s,--nf0_dstemail )',[C.FStr(m_dest.Email)]);

      //items
      for I in Self.Items do
      begin

      end;
      C.AddCmd('commit tran ');
      }
end;

procedure TCNotFis00.FillDataSet(aDS: TDataSet);
var
  V: TVolCollectionItem;
begin
    //
    m_transp.Vol.Clear;
    m_cobr.Dup.Clear;
    m_pag.Clear;

    //ide
    Self.m_codseq :=aDS.FieldByName('nf0_codseq').AsInteger ;
    Self.m_codemp :=aDS.FieldByName('nf0_codemp').AsInteger ;
    Self.m_codufe :=aDS.FieldByName('nf0_codufe').AsInteger ;
    Self.m_natope :=aDS.FieldByName('nf0_natope').AsString ;
    Self.m_indpag :=TpcnIndicadorPagamento(aDS.FieldByName('nf0_indpag').AsInteger) ;
    Self.m_codmod :=aDS.FieldByName('nf0_codmod').AsInteger ;
    Self.m_nserie :=aDS.FieldByName('nf0_nserie').AsInteger ;
    Self.m_numdoc :=aDS.FieldByName('nf0_numdoc').AsInteger ;
    Self.m_dtemis :=aDS.FieldByName('nf0_dtemis').AsDateTime ;
    Self.m_dhsaient:=aDS.FieldByName('nf0_dhsaient').AsDateTime ;
    Self.m_tipntf :=TpcnTipoNFe(aDS.FieldByName('nf0_tipntf').AsInteger) ;
    Self.m_indope :=TpcnDestinoOperacao(aDS.FieldByName('nf0_indope').AsInteger) ;
    Self.m_codmun :=aDS.FieldByName('nf0_codmun').AsInteger ;
    Self.m_tipimp :=TpcnTipoImpressao(aDS.FieldByName('nf0_tipimp').AsInteger) ;
    Self.m_tipemi :=TpcnTipoEmissao(aDS.FieldByName('nf0_tipemi').AsInteger) ;
    Self.m_tipamb :=TpcnTipoAmbiente(aDS.FieldByName('nf0_tipamb').AsInteger) ;
    Self.m_finnfe :=TpcnFinalidadeNFe(aDS.FieldByName('nf0_finnfe').AsInteger) ;
    Self.m_indfinal:=TpcnConsumidorFinal(aDS.FieldByName('nf0_indfinal').AsInteger) ;
    Self.m_indpres :=TpcnPresencaComprador(aDS.FieldByName('nf0_indpres').AsInteger) ;
    Self.m_procemi :=TpcnProcessoEmissao(aDS.FieldByName('nf0_procemi').AsInteger) ;
    Self.m_verproc :=aDS.FieldByName('nf0_verproc').AsString ;
    Self.m_dhcont  :=aDS.FieldByName('nf0_dhcont').AsDateTime ;
    Self.m_justif  :=aDS.FieldByName('nf0_justif').AsString ;

    Self.m_chvref :=Trim(aDS.FieldByName('nf0_chvref').AsString);

    //emit
    Self.m_emit.CNPJCPF :=CadEmp.CNPJ;
    Self.m_emit.xNome   :=CadEmp.xNome;
    Self.m_emit.xFant   :=CadEmp.xFant;
    Self.m_emit.EnderEmit.xLgr    :=CadEmp.ender.xLogr;
    Self.m_emit.EnderEmit.nro     :=CadEmp.ender.numero;
    Self.m_emit.EnderEmit.xCpl    :=CadEmp.ender.xCompl;
    Self.m_emit.EnderEmit.xBairro :=CadEmp.ender.xBairro;
    Self.m_emit.EnderEmit.cMun    :=CadEmp.ender.cMun;
    Self.m_emit.EnderEmit.xMun    :=CadEmp.ender.xMun;
    Self.m_emit.EnderEmit.UF      :=CadEmp.ender.UF;
    Self.m_emit.EnderEmit.CEP     :=CadEmp.ender.CEP;
    Self.m_emit.EnderEmit.fone    :=CadEmp.fone;
    Self.m_emit.EnderEmit.cPais   :=CadEmp.ender.cPais;
    Self.m_emit.EnderEmit.xPais   :=CadEmp.ender.xPais;
    Self.m_emit.IE   :=CadEmp.IE;
    Self.m_emit.IEST :=CadEmp.IEST ;
    Self.m_emit.CRT  :=TpcnCRT(Ord(CadEmp.CRT));

    //dest
    if aDS.FieldByName('nf0_dsttippes').IsNull then
      Self.m_tippes :=tpFis
    else
        Self.m_tippes :=TNotFis00TipPes(aDS.FieldByName('nf0_dsttippes').AsInteger) ;
    Self.m_dest.CNPJCPF :=aDS.FieldByName('nf0_dstcnpjcpf').AsString ;
    Self.m_dest.idEstrangeiro :=aDS.FieldByName('nf0_dstidestra').AsString ;
    Self.m_dest.xNome :=aDS.FieldByName('nf0_dstnome').AsString ;
    Self.m_dest.EnderDest.xLgr :=aDS.FieldByName('nf0_dstlogr').AsString ;
    Self.m_dest.EnderDest.nro :=aDS.FieldByName('nf0_dstnumero').AsString ;
    Self.m_dest.EnderDest.xCpl :=aDS.FieldByName('nf0_dstcomple').AsString ;
    Self.m_dest.EnderDest.xBairro :=aDS.FieldByName('nf0_dstbairro').AsString ;
    Self.m_dest.EnderDest.cMun :=aDS.FieldByName('nf0_dstcodmun').AsInteger ;
    Self.m_dest.EnderDest.xMun :=aDS.FieldByName('nf0_dstmun').AsString ;
    Self.m_dest.EnderDest.UF :=aDS.FieldByName('nf0_dstufe').AsString ;
    Self.m_dest.EnderDest.CEP :=aDS.FieldByName('nf0_dstcep').AsInteger ;
    Self.m_dest.EnderDest.fone :=aDS.FieldByName('nf0_dstfone').AsString ;
    Self.m_dest.indIEDest   :=TpcnindIEDest(aDS.FieldByName('nf0_dstindie').AsInteger) ;
    Self.m_dest.IE   :=aDS.FieldByName('nf0_dstie').AsString ;
    Self.m_dest.ISUF :=aDS.FieldByName('nf0_dstisuf').AsString ;
    Self.m_dest.Email:=aDS.FieldByName('nf0_dstemail').AsString ;

    //
    // transportes
    //
    Self.m_transp.modFrete :=TpcnModalidadeFrete(aDS.FieldByName('nf0_modfret').AsInteger) ;
    Self.m_transp.Transporta.CNPJCPF :=aDS.FieldByName('nf0_tracnpjcpf').AsString;
    Self.m_transp.Transporta.xNome   :=aDS.FieldByName('nf0_tranome').AsString;
    Self.m_transp.Transporta.IE      :=aDS.FieldByName('nf0_traie').AsString;
    Self.m_transp.Transporta.xEnder  :=aDS.FieldByName('nf0_traend').AsString;
    Self.m_transp.Transporta.xMun    :=aDS.FieldByName('nf0_tramun').AsString;
    Self.m_transp.Transporta.UF      :=aDS.FieldByName('nf0_traufe').AsString;
    Self.m_transp.veicTransp.placa :=aDS.FieldByName('nf0_veiplaca').AsString;
    Self.m_transp.veicTransp.UF    :=aDS.FieldByName('nf0_veiufe').AsString;
    Self.m_transp.veicTransp.RNTC  :=aDS.FieldByName('nf0_veirntc').AsString;

    //
    // volumes
    //V :=Self.m_transp.Vol.Add ; deprecated
    V :=Self.m_transp.Vol.New ;
    V.qVol  :=aDS.FieldByName('nf0_volqtd').AsInteger;
    V.esp   :=aDS.FieldByName('nf0_volesp').AsString;
    V.marca :=aDS.FieldByName('nf0_volmrc').AsString;
    V.nVol  :=aDS.FieldByName('nf0_volnum').AsString;
    V.pesoL :=aDS.FieldByName('nf0_volpsol').AsFloat;
    V.pesoB :=aDS.FieldByName('nf0_volpsob').AsFloat;

    Self.m_codped :=aDS.FieldByName('nf0_codped').AsInteger ;

    Self.m_codstt:=aDS.FieldByName('nf0_codstt').AsInteger;
    Self.m_motivo:=aDS.FieldByName('nf0_motivo').AsString ;

    Self.m_chvnfe:=aDS.FieldByName('nf0_chvnfe').AsString ;
    //Self.m_xml   :=aDS.FieldByName('nf0_xml').AsString ;
    Self.m_indsinc:=aDS.FieldByName('nf0_indsinc').AsInteger;

    Self.m_verapp:=aDS.FieldByName('nf0_verapp').AsString ;
    Self.m_dhreceb:=aDS.FieldByName('nf0_dhreceb').AsDateTime;
    Self.m_numreci:=aDS.FieldByName('nf0_numreci').AsString ;
    Self.m_numprot:=aDS.FieldByName('nf0_numprot').AsString ;
    Self.m_digval:=aDS.FieldByName('nf0_digval').AsString ;

    // consumo indevido
    Self.m_consumo :=aDS.FieldByName('nf0_consumo').AsInteger;

    // info cmple
    Self.m_infCpl:=aDS.FieldByName('nf0_infcpl').AsString ;

    // NF vinculada
    Self.m_codlot :=aDS.FieldByName('nf0_codlot').AsInteger;

    Self.m_oriindpag :=Self.m_indpag;
    Self.m_oritipemi :=Self.m_tipemi;
    Self.m_oricodstt :=Self.m_codstt;


    //
    // totais
    m_icmstot.vBC :=aDS.FieldByName('vBC').AsCurrency ;
    m_icmstot.vICMS :=aDS.FieldByName('vICMS').AsCurrency ;
    m_icmstot.vFCP :=aDS.FieldByName('vFCP').AsCurrency ;
    m_icmstot.vBCST :=aDS.FieldByName('vBCST').AsCurrency ;
    m_icmstot.vST :=aDS.FieldByName('vST').AsCurrency ;
    m_icmstot.vFCPST :=aDS.FieldByName('vFCPST').AsCurrency ;
    m_icmstot.vProd :=aDS.FieldByName('vProd').AsCurrency ;
    m_icmstot.vFrete :=aDS.FieldByName('vFret').AsCurrency ;
    m_icmstot.vSeg :=aDS.FieldByName('vSeg').AsCurrency ;
    m_icmstot.vDesc :=aDS.FieldByName('vDesc').AsCurrency ;
    m_icmstot.vII :=aDS.FieldByName('vII').AsCurrency ;
    m_icmstot.vIPI :=aDS.FieldByName('vIPI').AsCurrency ;
    m_icmstot.vIPIDevol :=aDS.FieldByName('vIPIDevol').AsCurrency ;
    m_icmstot.vPIS :=aDS.FieldByName('vPIS').AsCurrency ;
    m_icmstot.vCOFINS :=aDS.FieldByName('vCOFINS').AsCurrency ;
    m_icmstot.vOutro :=aDS.FieldByName('vOutr').AsCurrency ;
    m_icmstot.vTotTrib :=aDS.FieldByName('vTrib').AsCurrency ;
    m_icmstot.vNF :=aDS.FieldByName('vNF').AsCurrency ;

end;

function TCNotFis00.IndexOf(const codint: Int32): TCNotFis01;
var
  found: Boolean ;
begin
    found :=false ;
    for Result in Items do
    begin
        if Result.m_codint =codint then
        begin
            found :=true ;
            Break ;
        end;
    end;
    if not found then
    begin
        Result :=nil ;
    end;
end;

function TCNotFis00.Load(const codseq: Integer): Boolean;
var
  F: TNotFis00Filter ;
  Q: TDataSet ;// TADOQuery ;
  cmplvl: Integer;
begin
//
    //
    Result :=False ;
    //
    if codseq > 0 then
        F.Create(codseq, 0)
    else
        F.Create(Self.m_codseq, 0);

    //
    // combatibilidade
    cmplvl :=TADOQuery.getCompLevel ;
    if cmplvl > 8 then
        Q :=TCNotFis00Lote.CLoadSPNotFis00Busca(F)
    else
        Q :=TCNotFis00Lote.CLoad(F) ;

    try
        Result :=not Q.IsEmpty ;
        if Result then
        begin
            if cmplvl > 8 then
                Self.FillDataSet(Q)
            else
                Self.LoadFromQ(Q);
            Self.LoadItems() ;
            Self.LoadFormaPgto();
        end;
    finally
        Q.Free ;
    end;
end;

procedure TCNotFis00.LoadDest();
var
  Q: TADOQuery ;
begin
    Q :=TADOQuery.NewADOQuery() ;
    try
        Q.AddCmd('select                ');
        Q.AddCmd('  d.email as dst_email');
        Q.AddCmd('from cliente d        ');
        Q.AddCmd('where d.Codcliente =%d',[Self.m_codcli]);
        Q.Open ;
        if not Q.IsEmpty then
        begin
            Self.m_dest.Email :=Q.Field('dst_email').AsString ;
        end;
    finally
        Q.Free ;
    end;
end;

procedure TCNotFis00.LoadFormaPgto();
var
  Q: TADOQuery ;
var
  saveSQL: Boolean;
  F: string ;
  //
  //
  procedure DoLoadFormaPgtos(const aTabVenda, aTabFormPagVenda: string);
  begin
      Q.AddCmd('declare @codped int; set @codped =%d        ',[Self.m_codped]);
      Q.AddCmd('select                                      ');
      Q.AddCmd('  v.troco as vtroco  ,                      ');
      Q.AddCmd('  fp.indice as tippag,                      ');
      Q.AddCmd('  fp.codformapagamento as codfpg,           ');
      Q.AddCmd('  fp.nome as descri,                        ');
      Q.AddCmd('  fpv.valor as vlrpag,                      ');
      Q.AddCmd('  fpv.datareceber as dtvenc                 ');
      Q.AddCmd('from %s v with(readpast)                    ',[aTabVenda]);
      Q.AddCmd('inner join %s fpv with(readpast) on fpv.codvenda =v.codvenda',[aTabFormPagVenda]);
      Q.AddCmd('inner join formapagamento fp with(readpast) on fpv.codformapagamento=fp.codformapagamento');
      Q.AddCmd('where v.codvenda =@codped                   ');
      //
      // save SQL
      if saveSQL then
      begin
          case m_Parent.m_Filter.filTyp of
              ftNormal: F:=Format('App-%s.LoadFormaPgto.%s.SQL',[Self.ClassName,aTabFormPagVenda]);
              ftService:F:=Format('Svc-%s.LoadFormaPgto.%s.SQL',[Self.ClassName,aTabFormPagVenda]);
              ftFech:   F:=Format('Fcx-%s.LoadFormaPgto.%s.SQL',[Self.ClassName,aTabFormPagVenda]);
          end;
          Q.SaveToFile(F);
      end;
      Q.Open ;
  end;
  //
var
  D: TDupCollectionItem ;
  P: TpagCollectionItem ;
var
  vfat: Currency ;
begin
    //
    Self.m_cobr.Dup.Clear;
    Self.m_pag.Clear;

    m_vlrpag :=0;
    vfat :=0;

    saveSQL :=Assigned(m_Parent)and(m_Parent.m_Filter.save) ;

    //
    Q :=TADOQuery.NewADOQuery() ;
    //

    //
    // nfe ambos os leiautes (3.10/4.0)
    // dup/faturas
    if Self.m_codmod =TCNotFis00.MOD_NFE then
    begin
        //
        // busca primeiro no contas a receber!
        Q.AddCmd('select                            ');
        Q.AddCmd('  codcontareceber as numdup,      ');
        Q.AddCmd('  valor as valdup,                ');
        Q.AddCmd('  datavenc as dtvenc,             ');
        Q.AddCmd('  prestacaoreferente as numpar    ');
        Q.AddCmd('from contareceber r with(readpast)');
        Q.AddCmd('where codvenda =%d                ',[Self.m_codped]);
        Q.AddCmd('order by datavenc                 ');

        if saveSQL then
        begin
            case m_Parent.m_Filter.filTyp of
                ftNormal: F:=Format('App-%s.LoadFormaPgto.contareceber.SQL',[Self.ClassName]);
                ftService:F:=Format('Svc-%s.LoadFormaPgto.contareceber.SQL',[Self.ClassName]);
                ftFech:   F:=Format('Fcx-%s.LoadFormaPgto.contareceber.SQL',[Self.ClassName]);
            end;
            Q.SaveToFile(F);
        end;

        Q.Open ;

        Self.m_indpag :=ipPrazo;
        vfat :=0 ;
        while not Q.Eof do
        begin
            D :=Self.m_cobr.Dup.New ;
            D.nDup :=Format('%.3d',[Q.Field('numpar').AsInteger]) ;
            D.dVenc:=Q.Field('dtvenc').AsDateTime;
            D.vDup :=Q.Field('valdup').AsCurrency ;
            vfat :=vfat +D.vDup ;
            Q.Next ;
        end;

        //
        // caso não encontra,
        // busca em forma de pagamento
        {if Q.IsEmpty then
        begin
            Q.AddCmd('declare @codped int; set @codped =%d        ',[Self.m_codped]);
            Q.AddCmd('select                                      ');
            Q.AddCmd('  fp.indice as tippag,                      ');
            Q.AddCmd('  fpv.codformapagvenda as numdup,           ');
            Q.AddCmd('  fpv.valor as valdup,                      ');
            Q.AddCmd('  fpv.datareceber as dtvenc                 ');
            Q.AddCmd('from formapagamentovenda fpv with(readpast) ');
            Q.AddCmd('inner join formapagamento fp with(readpast) on fpv.codformapagamento=fp.codformapagamento');
            Q.AddCmd('where codvenda =@codped                     ');
            //
            // link com a hist
            Q.AddCmd('union all                                       ');
            Q.AddCmd('select                                          ');
            Q.AddCmd('  fp.indice as tippag,                          ');
            Q.AddCmd('  fpv.codformapagvenda as numdup,               ');
            Q.AddCmd('  fpv.valor as valdup,                          ');
            Q.AddCmd('  fpv.datareceber as dtvenc                     ');
            Q.AddCmd('from histformapagamentovenda fpv with(readpast) ');
            Q.AddCmd('inner join formapagamento fp with(readpast) on fpv.codformapagamento=fp.codformapagamento');
            Q.AddCmd('where codvenda =@codped                         ');
            if saveSQL then
            begin
                case m_Parent.m_Filter.filTyp of
                    ftNormal: F:=Format('App-%s.LoadFormaPgto.formapagamentovenda.SQL',[Self.ClassName]);
                    ftService:F:=Format('Svc-%s.LoadFormaPgto.formapagamentovenda.SQL',[Self.ClassName]);
                    ftFech:   F:=Format('Fcx-%s.LoadFormaPgto.formapagamentovenda.SQL',[Self.ClassName]);
                end;
                Q.SaveToFile(F);
            end;
            Q.Open ;
            if(not Q.Field('tippag').IsNull)and(Q.Field('tippag').AsInteger=1)then
                Self.m_indpag :=ipVista
            else
               Self.m_indpag :=ipOutras;
        end
        else begin
            Self.m_indpag :=ipPrazo;
            vfat :=0 ;
            while not Q.Eof do
            begin
                //D :=Self.m_cobr.Dup.Add ;
                D :=Self.m_cobr.Dup.New ;
                D.nDup :=Format('%.3d',[Q.Field('numpar').AsInteger]) ;
                D.dVenc:=Q.Field('dtvenc').AsDateTime;
                D.vDup :=Q.Field('valdup').AsCurrency ;
                vfat :=vfat +D.vDup ;
                Q.Next ;
            end;
        end;}
    end;

    //
    // grupo fatura
    if Self.m_cobr.Dup.Count > 0 then
    begin
        m_cobr.Fat.nFat :=IntToStr(m_codped) ;
        m_cobr.Fat.vOrig:=vfat;
        m_cobr.Fat.vDesc:=0;
        m_cobr.Fat.vLiq:=vfat;
    end;

    //
    // pagamentos

    //
    // load venda/formapagamentovenda
    DoLoadFormaPgtos('venda','formapagamentovenda');
    //
    // não encontrou
    if Q.IsEmpty then
    begin
        //
        // load histvenda/histformapagamentovenda
        DoLoadFormaPgtos('histvenda','histformapagamentovenda');
    end ;
    {Q.AddCmd('declare @codped int; set @codped =%d  ',[Self.m_codped]);
    Q.AddCmd('select                                ');
    Q.AddCmd('  fp.indice as tippag,                ');
    Q.AddCmd('  fp.codformapagamento as codfpg,     ');
    Q.AddCmd('  fp.nome as descri,                  ');
    Q.AddCmd('  fpv.valor as vlrpag,                ');
    Q.AddCmd('  v.troco as vtroco                   ');
    Q.AddCmd('from venda v with(readpast)           ');
    Q.AddCmd('inner join formapagamentovenda fpv with(readpast) on fpv.codvenda =v.codvenda            ');
    Q.AddCmd('inner join formapagamento fp with(readpast) on fpv.codformapagamento=fp.codformapagamento');
    Q.AddCmd('where v.codvenda=@codped              ');
    //hist
    Q.AddCmd('union all                            ');
    Q.AddCmd('select                               ');
    Q.AddCmd('  fp.indice as tippag,               ');
    Q.AddCmd('  fp.codformapagamento as codfpg,    ');
    Q.AddCmd('  fp.nome as descri,                 ');
    Q.AddCmd('  fpv.valor as vlrpag,               ');
    Q.AddCmd('  v.troco as vtroco                  ');
    Q.AddCmd('from histvenda v with(readpast)      ');
    Q.AddCmd('inner join histformapagamentovenda fpv with(readpast) on fpv.codvenda =v.codvenda        ');
    Q.AddCmd('inner join formapagamento fp with(readpast) on fpv.codformapagamento=fp.codformapagamento');
    Q.AddCmd('where v.codvenda=@codped             ');
    if saveSQL then
    begin
        case m_Parent.m_Filter.filTyp of
            ftNormal: F:=Format('App-%s.LoadFormaPgto.formapagamentovenda-2.SQL',[Self.ClassName]);
            ftService:F:=Format('Svc-%s.LoadFormaPgto.formapagamentovenda-2.SQL',[Self.ClassName]);
            ftFech:   F:=Format('Fcx-%s.LoadFormaPgto.formapagamentovenda-2.SQL',[Self.ClassName]);
        end;
        Q.SaveToFile(F);
    end;
    Q.Open ;}

    while not Q.Eof do
    begin
        P :=Self.m_pag.New ;
        if Q.Field('tippag').AsString = '' then
            P.tPag :=fpDinheiro
        else
          case Q.Field('tippag').AsInteger of
              01:
              begin
                  P.tPag := fpDinheiro;
                  Self.m_pag.vTroco :=Q.Field('vtroco').AsCurrency;
              end;
              02: P.tPag :=fpCheque;
              03: P.tPag :=fpCartaoCredito;
              04: P.tPag :=fpCartaoDebito;
              05: P.tPag :=fpCreditoLoja;
              10: P.tPag :=fpValeAlimentacao;
              11: P.tPag :=fpValeRefeicao;
              12: P.tPag :=fpValePresente;
              13: P.tPag :=fpValeCombustivel;
              15: P.tPag :=fpBoletoBancario;
              90: P.tPag :=fpSemPagamento;
          else
              P.tPag :=fpOutro;
          end;
        P.vPag :=Q.Field('vlrpag').AsCurrency;
        m_vlrpag :=m_vlrpag +P.vPag ;
        Q.Next ;
    end;

    if Self.m_pag.Count > 1 then
        Self.m_indpag :=ipOutras
    else
        Self.m_indpag :=ipVista ;

    Q.Free ;
end;

function TCNotFis00.LoadFromPed(const codped: Integer): Boolean;
var
  F: TNotFis00Filter ;
  Q: TDataSet; // TADOQuery ;
begin
    //
    Result :=False ;
    //
    F.Create(0, codped);

    Q :=TCNotFis00Lote.CLoad(F) ;
    try
        Result :=not Q.IsEmpty ;
        if Result then
        begin
            Self.LoadFromQ(Q);
            //Self.LoadItems;
        end;
    finally
        Q.Free ;
    end;
end;

procedure TCNotFis00.LoadFromQ(Q: TDataSet);
var
  V: TVolCollectionItem;
begin
    //
    m_transp.Vol.Clear;
    m_cobr.Dup.Clear;
    m_pag.Clear;

    //ide
    Self.m_codseq :=Q.FieldByName('nf0_codseq').AsInteger ;
    Self.m_codemp :=Q.FieldByName('nf0_codemp').AsInteger ;
    Self.m_codufe :=Q.FieldByName('nf0_codufe').AsInteger ;
    Self.m_natope :=Q.FieldByName('nf0_natope').AsString ;
    Self.m_indpag :=TpcnIndicadorPagamento(Q.FieldByName('nf0_indpag').AsInteger) ;
    Self.m_codmod :=Q.FieldByName('nf0_codmod').AsInteger ;
    Self.m_nserie :=Q.FieldByName('nf0_nserie').AsInteger ;
    Self.m_numdoc :=Q.FieldByName('nf0_numdoc').AsInteger ;
    Self.m_dtemis :=Q.FieldByName('nf0_dtemis').AsDateTime ;
    Self.m_dhsaient:=Q.FieldByName('nf0_dhsaient').AsDateTime ;
    Self.m_tipntf :=TpcnTipoNFe(Q.FieldByName('nf0_tipntf').AsInteger) ;
    Self.m_indope :=TpcnDestinoOperacao(Q.FieldByName('nf0_indope').AsInteger) ;
    Self.m_codmun :=Q.FieldByName('nf0_codmun').AsInteger ;
    Self.m_tipimp :=TpcnTipoImpressao(Q.FieldByName('nf0_tipimp').AsInteger) ;
    Self.m_tipemi :=TpcnTipoEmissao(Q.FieldByName('nf0_tipemi').AsInteger) ;
    Self.m_tipamb :=TpcnTipoAmbiente(Q.FieldByName('nf0_tipamb').AsInteger) ;
    Self.m_finnfe :=TpcnFinalidadeNFe(Q.FieldByName('nf0_finnfe').AsInteger) ;
    Self.m_indfinal:=TpcnConsumidorFinal(Q.FieldByName('nf0_indfinal').AsInteger) ;
    Self.m_indpres :=TpcnPresencaComprador(Q.FieldByName('nf0_indpres').AsInteger) ;
    Self.m_procemi :=TpcnProcessoEmissao(Q.FieldByName('nf0_procemi').AsInteger) ;
    Self.m_verproc :=Q.FieldByName('nf0_verproc').AsString ;
    Self.m_dhcont  :=Q.FieldByName('nf0_dhcont').AsDateTime ;
    Self.m_justif  :=Q.FieldByName('nf0_justif').AsString ;

    Self.m_chvref :=Trim(Q.FieldByName('nf0_chvref').AsString);

    //emit
    Self.m_emit.CNPJCPF :=Q.FieldByName('nf0_emicnpj').AsString ;
    Self.m_emit.xNome :=Q.FieldByName('nf0_eminome').AsString ;
    Self.m_emit.xFant :=Q.FieldByName('nf0_emifant').AsString ;
    Self.m_emit.EnderEmit.xLgr:=Q.FieldByName('nf0_emilogr').AsString ;
    Self.m_emit.EnderEmit.nro :=Q.FieldByName('nf0_eminumero').AsString;
    Self.m_emit.EnderEmit.xCpl :=Q.FieldByName('nf0_emicomple').AsString ;
    Self.m_emit.EnderEmit.xBairro :=Q.FieldByName('nf0_emibairro').AsString ;
    Self.m_emit.EnderEmit.cMun :=Q.FieldByName('nf0_emicodmun').AsInteger ;
    Self.m_emit.EnderEmit.xMun :=Q.FieldByName('nf0_emimun').AsString ;
    Self.m_emit.EnderEmit.UF :=Q.FieldByName('nf0_emiufe').AsString ;
    Self.m_emit.EnderEmit.CEP    :=Q.FieldByName('nf0_emicep').AsInteger ;
    Self.m_emit.EnderEmit.fone   :=Q.FieldByName('nf0_emifone').AsString ;
    Self.m_emit.IE   :=Q.FieldByName('nf0_emiie').AsString ;
    Self.m_emit.IEST :=Q.FieldByName('nf0_emiiest').AsString;
    Self.m_emit.CRT  :=TpcnCRT(Q.FieldByName('nf0_emicrt').AsInteger) ;

    //dest
    if Q.FieldByName('nf0_dsttippes').IsNull then
      Self.m_tippes :=tpFis
    else
        Self.m_tippes :=TNotFis00TipPes(Q.FieldByName('nf0_dsttippes').AsInteger) ;
    Self.m_dest.CNPJCPF :=Q.FieldByName('nf0_dstcnpjcpf').AsString ;
    Self.m_dest.idEstrangeiro :=Q.FieldByName('nf0_dstidestra').AsString ;
    Self.m_dest.xNome :=Q.FieldByName('nf0_dstnome').AsString ;
    Self.m_dest.EnderDest.xLgr :=Q.FieldByName('nf0_dstlogr').AsString ;
    Self.m_dest.EnderDest.nro :=Q.FieldByName('nf0_dstnumero').AsString ;
    Self.m_dest.EnderDest.xCpl :=Q.FieldByName('nf0_dstcomple').AsString ;
    Self.m_dest.EnderDest.xBairro :=Q.FieldByName('nf0_dstbairro').AsString ;
    Self.m_dest.EnderDest.cMun :=Q.FieldByName('nf0_dstcodmun').AsInteger ;
    Self.m_dest.EnderDest.xMun :=Q.FieldByName('nf0_dstmun').AsString ;
    Self.m_dest.EnderDest.UF :=Q.FieldByName('nf0_dstufe').AsString ;
    Self.m_dest.EnderDest.CEP :=Q.FieldByName('nf0_dstcep').AsInteger ;
    Self.m_dest.EnderDest.fone :=Q.FieldByName('nf0_dstfone').AsString ;
    Self.m_dest.indIEDest   :=TpcnindIEDest(Q.FieldByName('nf0_dstindie').AsInteger) ;
    Self.m_dest.IE   :=Q.FieldByName('nf0_dstie').AsString ;
    Self.m_dest.ISUF :=Q.FieldByName('nf0_dstisuf').AsString ;
    Self.m_dest.Email:=Q.FieldByName('nf0_dstemail').AsString ;

    //
    // transportes
    //
    Self.m_transp.modFrete :=TpcnModalidadeFrete(Q.FieldByName('nf0_modfret').AsInteger) ;
    Self.m_transp.Transporta.CNPJCPF :=Q.FieldByName('nf0_tracnpjcpf').AsString;
    Self.m_transp.Transporta.xNome   :=Q.FieldByName('nf0_tranome').AsString;
    Self.m_transp.Transporta.IE      :=Q.FieldByName('nf0_traie').AsString;
    Self.m_transp.Transporta.xEnder  :=Q.FieldByName('nf0_traend').AsString;
    Self.m_transp.Transporta.xMun    :=Q.FieldByName('nf0_tramun').AsString;
    Self.m_transp.Transporta.UF      :=Q.FieldByName('nf0_traufe').AsString;
    Self.m_transp.veicTransp.placa :=Q.FieldByName('nf0_veiplaca').AsString;
    Self.m_transp.veicTransp.UF    :=Q.FieldByName('nf0_veiufe').AsString;
    Self.m_transp.veicTransp.RNTC  :=Q.FieldByName('nf0_veirntc').AsString;

    //
    // volumes
    //V :=Self.m_transp.Vol.Add ; deprecated
    V :=Self.m_transp.Vol.New ;
    V.qVol  :=Q.FieldByName('nf0_volqtd').AsInteger;
    V.esp   :=Q.FieldByName('nf0_volesp').AsString;
    V.marca :=Q.FieldByName('nf0_volmrc').AsString;
    V.nVol  :=Q.FieldByName('nf0_volnum').AsString;
    V.pesoL :=Q.FieldByName('nf0_volpsol').AsFloat;
    V.pesoB :=Q.FieldByName('nf0_volpsob').AsFloat;

    Self.m_codped :=Q.FieldByName('nf0_codped').AsInteger ;

    Self.m_codstt:=Q.FieldByName('nf0_codstt').AsInteger;
    Self.m_motivo:=Q.FieldByName('nf0_motivo').AsString ;

    Self.m_chvnfe:=Q.FieldByName('nf0_chvnfe').AsString ;
    //Self.m_xml   :=Q.FieldByName('nf0_xml').AsString ;
    Self.m_indsinc:=Q.FieldByName('nf0_indsinc').AsInteger;

    Self.m_verapp:=Q.FieldByName('nf0_verapp').AsString ;
    Self.m_dhreceb:=Q.FieldByName('nf0_dhreceb').AsDateTime;
    Self.m_numreci:=Q.FieldByName('nf0_numreci').AsString ;
    Self.m_numprot:=Q.FieldByName('nf0_numprot').AsString ;
    Self.m_digval:=Q.FieldByName('nf0_digval').AsString ;

    // consumo indevido
    Self.m_consumo :=Q.FieldByName('nf0_consumo').AsInteger;

    // info cmple
    Self.m_infCpl:=Q.FieldByName('nf0_infcpl').AsString ;

    Self.m_codlot :=Q.FieldByName('nf0_codlot').AsInteger;

    Self.m_oriindpag :=Self.m_indpag;
    Self.m_oritipemi :=Self.m_tipemi;
    Self.m_oricodstt :=Self.m_codstt;
end;

procedure TCNotFis00.LoadInfCpl;
var
  Q: TADOQuery ;
begin

    { DESCONTINUADO !!! MOVIDO PARA AS SP´s NOTFIS00_ADD/UPD
    Q :=TADOQuery.NewADOQuery() ;
    try
        Q.AddCmd('declare @codped int; set @codped =%d  ;                       ',[Self.m_codped]);
        Q.AddCmd('select                                                        ');
        Q.AddCmd('  v.CodMesa as ped_nummsa ,                                   ');
        Q.AddCmd('  v.NumeroCaixa as ped_numcxa,                                ');
        Q.AddCmd('  v.nota as ped_observ,                                       ');
        Q.AddCmd('  u.Nome as usr_nome,                                         ');
        Q.AddCmd('  f.nome as fun_nome,                                         ');
        Q.AddCmd('  case when s.codcontadorsenha is null then 0                 ');
        Q.AddCmd('  else s.codcontadorsenha end as sen_codigo                   ');
        Q.AddCmd('from venda v                                                  ');
        Q.AddCmd('inner join usuario u on u.codusuario =v.CodUsuario            ');
        Q.AddCmd('inner join funcionario f on f.Codfuncionario =v.Codfuncionario');
        Q.AddCmd('left join contadorsenha s on s.codvenda =v.codvenda           ');
        Q.AddCmd('where v.Codvenda =@codped                                     ');
        //
        // link com a histvenda
        Q.AddCmd('union all                                                     ');
        //
        Q.AddCmd('select                                                        ');
        Q.AddCmd('  v.CodMesa as ped_nummsa ,                                   ');
        Q.AddCmd('  v.NumeroCaixa as ped_numcxa,                                ');
        Q.AddCmd('  v.nota as ped_observ,                                       ');
        Q.AddCmd('  u.Nome as usr_nome,                                         ');
        Q.AddCmd('  f.nome as fun_nome,                                         ');
        Q.AddCmd('  case when s.codcontadorsenha is null then 0                 ');
        Q.AddCmd('  else s.codcontadorsenha end as sen_codigo                   ');
        Q.AddCmd('from histvenda v                                              ');
        Q.AddCmd('inner join usuario u on u.codusuario =v.CodUsuario            ');
        Q.AddCmd('inner join funcionario f on f.Codfuncionario =v.Codfuncionario');
        Q.AddCmd('left join contadorsenha s on s.codvenda =v.codvenda           ');
        Q.AddCmd('where v.Codvenda =@codped                                     ');

        Q.Open ;

        if not Q.IsEmpty then
        begin
            if Self.m_codmod = 55 then
            begin
                //
                //Self.m_infCpl :=Format('Venda: %d',[Self.m_codped]) ;
                if(not Q.Field('ped_observ').IsNull)and(Q.Field('ped_observ').AsString <> '') then
                begin
                    Self.m_infCpl :=Q.Field('ped_observ').AsString;
                end;
            end
            else begin
                if Q.Field('sen_codigo').AsInteger > 0 then
                    Self.m_infCpl :=Format('Senha: %d, CX: %s, Operador: %s',[
                                                    Q.Field('sen_codigo').AsInteger,
                                                    Q.Field('ped_numcxa').AsString,
                                                    Q.Field('fun_nome').AsString
                                                              ])
                else begin
                    if Q.Field('ped_nummsa').IsNull then
                        Self.m_infCpl :=Format('Venda: %d, CX: %s, Operador: %s',[
                                                      Self.m_codped,
                                                      Q.Field('ped_numcxa').AsString,
                                                      Q.Field('fun_nome').AsString
                                                              ])
                    else begin
                        if Q.Field('ped_nummsa').AsInteger >= 800 then
                        Self.m_infCpl :=Format('Entrega: %d, CX: %s, Operador: %s',[
                                                      Q.Field('ped_nummsa').AsInteger,
                                                      Q.Field('ped_numcxa').AsString,
                                                      Q.Field('fun_nome').AsString
                                                              ])
                        else
                        Self.m_infCpl :=Format('Mesa/Comanda: %s, CX: %s, Operador: %s',[
                                                      Q.Field('ped_nummsa').AsString,
                                                      Q.Field('ped_numcxa').AsString,
                                                      Q.Field('fun_nome').AsString
                                                              ]);
                    end;
                end;
            end;
        end
        else
            Self.m_infCpl :='';

//        if Self.m_indpag =ipVista then
//        begin
//            Self.m_infCpl :=Self.m_infCpl +';'+ Format('Valor recebido: %12.2m',[
//                Self.m_pag.Items[0].vPag +Self.vTroco
//            ]);
//        end;

    finally
        Q.Free ;
    end;
    }
end;

procedure TCNotFis00.LoadItems;
var
  Q: TADOQuery ;
  I: TCNotFis01;
var
  pag: TpagCollectionItem;
  nf2_codseq: TField ;
var
  dif: Currency;
  codanp: Int32 ;
begin
    //
    m_oItems.Clear ;
    //

    m_vtribnac :=0;
    m_vtribimp :=0;
    m_vtribest :=0;
    m_vtribmun :=0;

    //zera totais
    Self.m_icmstot.vBC :=0;
    Self.m_icmstot.vICMS :=0;
    Self.m_icmstot.vBCST :=0;
    Self.m_icmstot.vST :=0;
    Self.m_icmstot.vProd :=0;
    Self.m_icmstot.vFrete :=0;
    Self.m_icmstot.vSeg :=0;
    Self.m_icmstot.vDesc :=0;
    Self.m_icmstot.vII :=0;
    Self.m_icmstot.vIPI :=0;
    Self.m_icmstot.vIPIDevol :=0;
    Self.m_icmstot.vPIS :=0;
    Self.m_icmstot.vCOFINS :=0;
    Self.m_icmstot.vOutro :=0;
    Self.m_icmstot.vNF :=0;
    Self.m_icmstot.vTotTrib :=0;

    //
    // fcp
    Self.m_icmstot.vFCP :=0;
    Self.m_icmstot.vFCPST :=0;

    Q :=TADOQuery.NewADOQuery() ;
    try
        Q.AddCmd('declare @codntf int; set @codntf =%d   ;',[Self.m_codseq]);

        Q.AddCmd('select                                ');

        //produto
        Q.AddCmd('  nf1_codseq ,                        ');
        Q.AddCmd('  nf1_codntf ,                        ');
        Q.AddCmd('  nf1_codint ,                        ');
        Q.AddCmd('  nf1_codpro ,                        ');
        Q.AddCmd('  nf1_codean ,                        ');
        Q.AddCmd('  nf1_descri ,                        ');
        Q.AddCmd('  nf1_codncm ,                        ');
        Q.AddCmd('  nf1_codest ,                        ');
        Q.AddCmd('  nf1_extipi ,                        ');
        Q.AddCmd('  nf1_cfop ,                          ');
        Q.AddCmd('  nf1_undcom ,                        ');
        Q.AddCmd('  nf1_qtdcom ,                        ');
        Q.AddCmd('  nf1_vlrcom ,                        ');
        Q.AddCmd('  nf1_vlrpro ,                        ');
        Q.AddCmd('  nf1_eantrib ,                       ');
        Q.AddCmd('  nf1_undtrib ,                       ');
        Q.AddCmd('  nf1_qtdtrib ,                       ');
        Q.AddCmd('  nf1_vlrtrib ,                       ');
        Q.AddCmd('  nf1_vlrfret ,                       ');
        Q.AddCmd('  nf1_vlrsegr ,                       ');
        Q.AddCmd('  nf1_vlrdesc ,                       ');
        Q.AddCmd('  nf1_vlroutr ,                       ');
        Q.AddCmd('  nf1_indtot ,                        ');
        Q.AddCmd('  nf1_infadprod,                      ');
        Q.AddCmd('  nf1_codanp,                         ');

        //imposto.icms
        Q.AddCmd('  nf1_orig ,                          ');
        Q.AddCmd('  nf1_cst ,                           ');
        Q.AddCmd('  nf1_csosn ,                         ');
        Q.AddCmd('  nf1_modbc ,                         ');
        Q.AddCmd('  nf1_predbc ,                        ');
        Q.AddCmd('  nf1_vbc ,                           ');
        Q.AddCmd('  nf1_picms ,                         ');
        Q.AddCmd('  nf1_vicms ,                         ');
        Q.AddCmd('  nf1_modbcst ,                       ');
        Q.AddCmd('  nf1_pmvast ,                        ');
        Q.AddCmd('  nf1_predbcst ,                      ');
        Q.AddCmd('  nf1_vbcst ,                         ');
        Q.AddCmd('  nf1_picmsst ,                       ');
        Q.AddCmd('  nf1_vicmsst ,                       ');
        Q.AddCmd('  nf1_vbcstret ,                      ');
        Q.AddCmd('  nf1_vicmsstret ,                    ');
        Q.AddCmd('  nf1_vbcstdest ,                     ');
        Q.AddCmd('  nf1_vicmsstdest ,                   ');
        Q.AddCmd('  nf1_pcredsn ,                       ');
        Q.AddCmd('  nf1_vcredicmssn ,                   ');

        //imposto.ipi
        Q.AddCmd('  nf1_clenqipi ,                      ');
        Q.AddCmd('  nf1_cnpjprodipi ,                   ');
        Q.AddCmd('  nf1_cseloipi ,                      ');
        Q.AddCmd('  nf1_qseloipi ,                      ');
        Q.AddCmd('  nf1_cenqipi ,                       ');
        Q.AddCmd('  nf1_cstipi ,                        ');
        Q.AddCmd('  nf1_vbcipi ,                        ');
        Q.AddCmd('  nf1_qunidipi ,                      ');
        Q.AddCmd('  nf1_vunidipi ,                      ');
        Q.AddCmd('  nf1_pipi ,                          ');
        Q.AddCmd('  nf1_vipi ,                          ');

        //imposto.pis
        Q.AddCmd('  nf1_cstpis ,                        ');
        Q.AddCmd('  nf1_vbcpis ,                        ');
        Q.AddCmd('  nf1_ppis ,                          ');
        Q.AddCmd('  nf1_vpis ,                          ');
        Q.AddCmd('  nf1_qbcprodpis ,                    ');
        Q.AddCmd('  nf1_valiqprodpis ,                  ');

        //imposto.cofins
        Q.AddCmd('  nf1_cstcofins ,                     ');
        Q.AddCmd('  nf1_vbccofins ,                     ');
        Q.AddCmd('  nf1_pcofins ,                       ');
        Q.AddCmd('  nf1_vcofins ,                       ');
        Q.AddCmd('  nf1_vbcprodcofins ,                 ');
        Q.AddCmd('  nf1_valiqprodcofins,                ');
        Q.AddCmd('  nf1_qbcprodcofins  ,                ');

        //aliq. IBPT
        Q.AddCmd('  nf1_ibptaliqnac ,                   ');
        Q.AddCmd('  nf1_ibptaliqimp ,                   ');
        Q.AddCmd('  nf1_ibptaliqest ,                   ');
        Q.AddCmd('  nf1_ibptaliqmun                     ');

        //
        // aliq. do Fundo de Combate à Pobreza (FCP)
        Q.AddCmd('  ,nf1_vbcfcp                         ');
        Q.AddCmd('  ,nf1_pfcp                           ');
        Q.AddCmd('  ,nf1_vfcp                           ');
        Q.AddCmd('  ,nf1_vbcfcpst                       ');
        Q.AddCmd('  ,nf1_pfcpst                         ');
        Q.AddCmd('  ,nf1_vfcpst                         ');

        //
        // Grupo opcional para informações do ICMS Efetivo
        Q.AddCmd('  ,nf1_predbcefet                     ');
        Q.AddCmd('  ,nf1_vbcefet                        ');
        Q.AddCmd('  ,nf1_picmsefet                      ');
        Q.AddCmd('  ,nf1_vicmsefet                      ');

        //
        // Grupo a ser informado nas vendas interestaduais para
        // consumidor final, não contribuinte do ICMS.
        Q.AddCmd('  ,nf1_vbcufdest                      ');
        Q.AddCmd('  ,nf1_vbcfcpufdest                   ');
        Q.AddCmd('  ,nf1_pfcpufdest                     ');
        Q.AddCmd('  ,nf1_picmsufdest                    ');
        Q.AddCmd('  ,nf1_picmsinter                     ');
        Q.AddCmd('  ,nf1_picmsinterpart                 ');
        Q.AddCmd('  ,nf1_vfcpufdest                     ');
        Q.AddCmd('  ,nf1_vicmsufdest                    ');
        Q.AddCmd('  ,nf1_vicmsufremet                   ');

        //
        // Grupo imposto devolvido
        Q.AddCmd('  ,nf1_pdevol                         ');
        Q.AddCmd('  ,nf1_vipidevol                      ');

        //
        // base item
        Q.AddCmd('from notfis01 with(readpast)          ');
        Q.AddCmd('where nf1_codntf =@codntf             ');

        if not Q.Prepared then
        begin
            Q.Prepared :=True;
        end;

        //Q.SaveToFile(Format('%s.LoadItems',[self.ClassName]));
        Q.Open ;
        //
        codanp :=0;

        while not Q.Eof do
        begin
            //items
            I :=Self.AddItem() ;

            //ident
            I.m_codseq :=Q.Field('nf1_codseq').AsInteger ;
            I.m_codntf :=Q.Field('nf1_codntf').AsInteger ;
            I.m_codint :=Q.Field('nf1_codint').AsInteger ;

            //produto
            I.m_codpro :=Q.Field('nf1_codpro').AsString ;
            I.m_codean :=Q.Field('nf1_codean').AsString ;
            I.m_descri :=Q.Field('nf1_descri').AsString ;
            I.m_codncm :=Q.Field('nf1_codncm').AsString ;
            I.m_codest :=Q.Field('nf1_codest').AsString ;
            I.m_extipi :=Q.Field('nf1_extipi').AsString ;
            I.m_cfop   :=Q.Field('nf1_cfop').AsInteger ;
            I.m_undcom :=Q.Field('nf1_undcom').AsString;
            I.m_qtdcom :=Q.Field('nf1_qtdcom').AsFloat ;
            I.m_vlrcom :=Q.Field('nf1_vlrcom').AsFloat ;
            I.m_vlrpro :=Q.Field('nf1_vlrpro').AsCurrency ;
            I.m_eantrib :=Q.Field('nf1_eantrib').AsString ;
            I.m_undtrib :=Q.Field('nf1_undtrib').AsString;
            I.m_qtdtrib :=Q.Field('nf1_qtdtrib').AsFloat ;
            I.m_vlrtrib :=Q.Field('nf1_vlrtrib').AsFloat ;
            I.m_vlrfret :=Q.Field('nf1_vlrfret').AsCurrency ;
            I.m_vlrsegr :=Q.Field('nf1_vlrsegr').AsCurrency ;
            I.m_vlrdesc :=Q.Field('nf1_vlrdesc').AsCurrency ;
            I.m_vlroutr :=Q.Field('nf1_vlroutr').AsCurrency ;
            I.m_indtot :=TpcnIndicadorTotal(Q.Field('nf1_indtot').AsInteger) ;
            I.m_infadprod :=Q.Field('nf1_infadprod').AsString;

            I.m_codanp :=Q.Field('nf1_codanp').AsInteger ;
            if codanp = 0 then
            begin
                codanp :=I.m_codanp ;
            end;

            //
            // imposto.icms
            if Q.Field('nf1_cst').IsNull then
            begin
                I.m_cst   :=-1;
                I.m_csosn :=Q.Field('nf1_csosn').AsInteger ;
            end
            else begin
                I.m_cst   :=Q.Field('nf1_cst').AsInteger ;
                I.m_csosn :=-1;
            end;
            I.m_orig :=TpcnOrigemMercadoria(Q.Field('nf1_orig').AsInteger) ;
            I.m_modbc   :=Q.Field('nf1_modbc').AsInteger;
            I.m_predbc  :=Q.Field('nf1_predbc').AsSingle;
            I.m_vbc     :=Q.Field('nf1_vbc').AsCurrency;
            I.m_picms   :=Q.Field('nf1_picms').AsSingle;
            I.m_vicms   :=Q.Field('nf1_vicms').AsCurrency;
            I.m_modbcst :=Q.Field('nf1_modbcst').AsInteger;
            I.m_predbcst:=Q.Field('nf1_predbcst').AsSingle;
            I.m_vbcst   :=Q.Field('nf1_vbcst').AsCurrency;
            I.m_picmsst :=Q.Field('nf1_picmsst').AsSingle;
            I.m_vicmsst :=Q.Field('nf1_vicmsst').AsCurrency;
            I.m_vbcstret  :=Q.Field('nf1_vbcstret').AsCurrency;
            I.m_vicmsstret:=Q.Field('nf1_vicmsstret').AsCurrency;
            I.m_vbcstdest  :=Q.Field('nf1_vbcstdest').AsCurrency;
            I.m_vicmsstdest:=Q.Field('nf1_vicmsstdest').AsCurrency;
            I.m_pcredsn   :=Q.Field('nf1_pcredsn').AsSingle;
            I.m_vcredicmssn :=Q.Field('nf1_vcredicmssn').AsCurrency;

            //
            // fcp
            I.m_vbcfcp  :=Q.Field('nf1_vbcfcp').AsCurrency;
            I.m_pfcp    :=Q.Field('nf1_pfcp').AsSingle;
            I.m_vfcp    :=Q.Field('nf1_vfcp').AsCurrency;
            I.m_vbcfcpst:=Q.Field('nf1_vbcfcpst').AsCurrency;
            I.m_pfcpst  :=Q.Field('nf1_pfcpst').AsSingle;
            I.m_vfcpst  :=Q.Field('nf1_vfcpst').AsCurrency;

            //
            // Grupo opcional para informações do ICMS Efetivo (NT.2016.002_v160)
            I.m_predbcefet:=Q.Field('nf1_predbcefet').AsSingle;
            I.m_vbcefet   :=Q.Field('nf1_vbcefet').AsCurrency;
            I.m_picmsefet :=Q.Field('nf1_picmsefet').AsSingle;
            I.m_vicmsefet :=Q.Field('nf1_vicmsefet').AsCurrency;

            //imposto.ipi
            I.m_ipi.clEnq :=Q.Field('nf1_clenqipi').AsString ;
            I.m_ipi.CNPJProd :=Q.Field('nf1_cnpjprodipi').AsString ;
            I.m_ipi.cSelo :=Q.Field('nf1_cseloipi').AsString ;
            I.m_ipi.qSelo :=Q.Field('nf1_qseloipi').AsInteger ;
            I.m_ipi.cEnq  :=Q.Field('nf1_cenqipi').AsString ;
            I.m_ipi.CST   :=TpcnCstIpi(Q.Field('nf1_cstipi').AsInteger) ;
            I.m_ipi.vBC   :=Q.Field('nf1_vbcipi').AsCurrency;
            I.m_ipi.qUnid :=Q.Field('nf1_qunidipi').AsSingle;
            I.m_ipi.vUnid :=Q.Field('nf1_vunidipi').AsCurrency;
            I.m_ipi.pIPI  :=Q.Field('nf1_pipi').AsSingle;
            I.m_ipi.vIPI  :=Q.Field('nf1_vipi').AsCurrency;

            //imposto.pis
            I.m_pis.CST :=TpcnCstPis(Q.Field('nf1_cstpis').AsInteger);
            I.m_pis.vBC :=Q.Field('nf1_vbcpis').AsCurrency;
            I.m_pis.pPIS:=Q.Field('nf1_ppis').AsSingle;
            I.m_pis.vPIS:=Q.Field('nf1_vpis').AsCurrency;
            I.m_pis.qBCProd   :=Q.Field('nf1_qbcprodpis').AsCurrency;
            I.m_pis.vAliqProd :=Q.Field('nf1_valiqprodpis').AsCurrency;

            //imposto.cofins
            I.m_cofins.CST     :=TpcnCstCofins(Q.Field('nf1_cstcofins').AsInteger);
            I.m_cofins.vBC     :=Q.Field('nf1_vbccofins').AsCurrency;
            I.m_cofins.pCOFINS :=Q.Field('nf1_pcofins').AsSingle;
            I.m_cofins.vCOFINS :=Q.Field('nf1_vcofins').AsCurrency;
            I.m_cofins.vBCProd   :=Q.Field('nf1_vbcprodcofins').AsCurrency;
            I.m_cofins.vAliqProd :=Q.Field('nf1_valiqprodcofins').AsCurrency;
            I.m_cofins.qBCProd   :=Q.Field('nf1_qbcprodcofins').AsCurrency;

            //aliq.tributos
            I.m_ibptaliqnac :=Q.Field('nf1_ibptaliqnac').AsCurrency;
            I.m_ibptaliqimp :=Q.Field('nf1_ibptaliqimp').AsCurrency;
            I.m_ibptaliqest :=Q.Field('nf1_ibptaliqest').AsCurrency;
            I.m_ibptaliqmun :=Q.Field('nf1_ibptaliqmun').AsCurrency;

            //
            // Grupo a ser informado nas vendas interestaduais para
            // consumidor final, não contribuinte do ICMS.
            I.m_vbcufdest   :=Q.Field('nf1_vbcufdest').AsCurrency;
            I.m_vbcfcpufdest:=Q.Field('nf1_vbcfcpufdest').AsCurrency;
            I.m_pfcpufdest  :=Q.Field('nf1_pfcpufdest').AsSingle;
            I.m_picmsufdest :=Q.Field('nf1_picmsufdest').AsSingle;
            I.m_picmsinter  :=Q.Field('nf1_picmsinter').AsSingle;
            I.m_picmsinterpart:=Q.Field('nf1_picmsinterpart').AsSingle;
            I.m_vfcpufdest  :=Q.Field('nf1_vfcpufdest').AsCurrency;
            I.m_vicmsufdest :=Q.Field('nf1_vicmsufdest').AsCurrency;
            I.m_vicmsufremet:=Q.Field('nf1_vicmsufremet').AsCurrency;

            //
            // Grupo imposto devolvido
            I.m_pdevol :=Q.Field('nf1_pdevol').AsSingle;
            I.m_vipidevol :=Q.Field('nf1_vipidevol').AsCurrency;


            //calc. totais
            if I.m_indtot = itSomaTotalNFe then
            begin
                //tot.tributos
                Self.m_vtribnac :=Self.m_vtribnac +(I.m_vlrpro *I.m_ibptaliqnac)/100;
                Self.m_vtribimp :=Self.m_vtribimp +(I.m_vlrpro *I.m_ibptaliqimp)/100;
                Self.m_vtribest :=Self.m_vtribest +(I.m_vlrpro *I.m_ibptaliqest)/100;
                Self.m_vtribmun :=Self.m_vtribmun +(I.m_vlrpro *I.m_ibptaliqmun)/100;

                Self.m_icmstot.vProd  :=Self.m_icmstot.vProd +I.m_vlrpro ;
                Self.m_icmstot.vDesc  :=Self.m_icmstot.vDesc +I.m_vlrdesc;
                Self.m_icmstot.vST    :=Self.m_icmstot.vST +I.m_vicmsst ;
                Self.m_icmstot.vFrete :=Self.m_icmstot.vFrete +I.m_vlrfret;
                Self.m_icmstot.vSeg   :=Self.m_icmstot.vSeg +I.m_vlrsegr ;
                Self.m_icmstot.vOutro :=Self.m_icmstot.vOutro +I.m_vlroutr ;
                //Self.m_icmstot.vII :=Self.m_icmstot.vII +I.m_vlrpro ;
                Self.m_icmstot.vIPI   :=Self.m_icmstot.vIPI +I.m_ipi.vIPI ;
                Self.m_icmstot.vIPIDevol :=Self.m_icmstot.vIPIDevol +I.m_vipidevol ;
                Self.m_icmstot.vBC    :=Self.m_icmstot.vBC +I.m_vbc ;
                Self.m_icmstot.vICMS  :=Self.m_icmstot.vICMS +I.m_vicms ;
                Self.m_icmstot.vPIS   :=Self.m_icmstot.vPIS +I.m_pis.vPIS;
                Self.m_icmstot.vCOFINS:=Self.m_icmstot.vCOFINS +I.m_cofins.vCOFINS ;

                //
                // FCP
                Self.m_icmstot.vFCP    :=Self.m_icmstot.vFCP    +I.m_vfcp ;
                Self.m_icmstot.vFCPST  :=Self.m_icmstot.vFCPST  +I.m_vfcpst ;


                //
                // UFdest
                //Self.m_icmstot.vFCPUFDest    :=Self.m_icmstot.vFCPUFDest    +iiii ;
            end;
            Q.Next ;
        end;

        //calc.total da NF
        m_icmstot.vNF :=(m_icmstot.vProd -m_icmstot.vDesc) +
                        m_icmstot.vST +
                        m_icmstot.vFrete +
                        m_icmstot.vSeg +
                        m_icmstot.vII +
                        m_icmstot.vIPI +
                        m_icmstot.vIPIDevol +
                        m_icmstot.vOutro+
                        m_icmstot.vFCPST ;

    finally
        Q.Free ;
    end;

    {if Self.m_codmod = 65 then
    begin
        //pag :=Self.m_pag.Items[0] ;
        //pag.tPag =fpDinheiro
        if(Self.m_icmstot.vDesc >0)then //and(Self.m_pag.Count = 1)then
        begin
//            dif :=(Self.m_icmstot.vProd +Self.m_icmstot.vFrete +Self.m_icmstot.vOutro);
//            dif :=dif -Self.m_icmstot.vDesc ;
            dif :=m_icmstot.vNF -m_vlrpag;
            I.m_vlrdesc :=I.m_vlrdesc +dif;
            m_icmstot.vDesc  :=m_icmstot.vDesc +I.m_vlrdesc;
        end;
    end ;}

    //
    // item / Combustível
    if codanp > 0 then
    begin
        Q :=TADOQuery.NewADOQuery();
        try
          Q.AddCmd('select nf2_codseq                    ');
          Q.AddCmd('  ,nf2_codanp                        ');
          Q.AddCmd('  ,nf2_descri                        ');
          Q.AddCmd('  ,nf2_pglp                          ');
          Q.AddCmd('  ,nf2_pgnn                          ');
          Q.AddCmd('  ,nf2_pgni                          ');
          Q.AddCmd('  ,nf2_vpart                         ');
          Q.AddCmd('  ,nf2_ufcons                        ');
          Q.AddCmd('from notfis02comb                    ');
          Q.AddCmd('where nf2_codntf =%d                 ',[Self.m_codseq]);
          Q.Open ;

          nf2_codseq :=Q.Field('nf2_codseq') ;
          while not Q.Eof do
          begin
              I :=Self.IndexOf(nf2_codseq.AsInteger) ;
              if I <> nil then
              begin
                  I.m_comb.m_codanp :=I.m_codanp;
                  I.m_comb.m_descri :=Q.Field('nf2_descri').AsString;
                  I.m_comb.m_pglp   :=Q.Field('nf2_pglp').AsCurrency;
                  I.m_comb.m_pgnn   :=Q.Field('nf2_pgnn').AsCurrency;
                  I.m_comb.m_pgni   :=Q.Field('nf2_pgni').AsCurrency;
                  I.m_comb.m_vpart  :=Q.Field('nf2_vpart').AsCurrency;
                  I.m_comb.m_ufcons :=Q.Field('nf2_ufcons').AsString;
              end;
              Q.Next ;
          end;
        finally
            Q.Free ;
        end;
    end;

end;

function TCNotFis00.LoadXML(): Boolean ;
var
  Q: TADOQuery;
  fnf0_xml: TField;
  //
  // compatibilidade
  cmplvl: SmallInt;
begin
    //
    //
    Q :=TADOQuery.NewADOQuery() ;
    try
        Q.AddCmd('select nf0_xml from notfis00 where nf0_codseq =%d;',[Self.m_codseq]) ;
        Q.Open ;
        fnf0_xml :=Q.Field('nf0_xml') ;
        if fnf0_xml.IsNull then
        begin
            cmplvl :=TADOQuery.getCompLevel ;
            if cmplvl > 8 then
            begin
                Q.AddCmd('select nf0_xmltyp as nf0_xml from notfis00 where nf0_codseq =%d;',[Self.m_codseq]);
                Q.Open ;
                fnf0_xml :=Q.Field('nf0_xml') ;
            end
        end;

        if not fnf0_xml.IsNull then
        begin
            Self.m_xml :=fnf0_xml.AsString ;
        end;

        Result :=Trim(Self.m_xml) <> '';

    finally
        Q.Free ;
    end;
end;

class function TCNotFis00.NewNFCe(const nserie: smallint;
  const tipemi: TpcnTipoEmissao;
  const tipamb: TpcnTipoAmbiente;
  const indpag: TpcnIndicadorPagamento ;
  const indpres: TpcnPresencaComprador;
  const dtemis: Tdatetime ;
  const codped: Integer;
  const pro_nomrdz, pro_codint: SmallInt): TCNotFis00;
begin

    //
    Result :=TCNotFis00.NewNFe('VENDA' ,
                                UFtoCUF(Empresa.UF),
                                Empresa.CodMun ,
                                indpag ,
                                65 ,
                                nserie,
                                tnSaida,
                                doInterna,
                                tiNFCe ,
                                tipemi ,
                                tipamb ,
                                fnNormal,
                                cfConsumidorFinal,
                                indpres ,
                                dtemis ,
                                '' ,
                                mfSemFrete ,
                                codped,
                                pro_nomrdz, pro_codint);
end;

class function TCNotFis00.NewNFe(const natope: string;
  const codufe, codmun: Integer;
  const indpag: TpcnIndicadorPagamento;
  const codmod, nserie: smallint;
  const tipntf: TpcnTipoNFe;
  const indope: TpcnDestinoOperacao;
  const tipimp: TpcnTipoImpressao;
  const tipemi: TpcnTipoEmissao;
  const tipamb: TpcnTipoAmbiente;
  const finnfe: TpcnFinalidadeNFe;
  const indfinal: TpcnConsumidorFinal;
  const indpres: TpcnPresencaComprador;
  const dtemis: Tdatetime;
  const chvref: string;
  const modfret: TpcnModalidadeFrete;
  const codped: Integer;
  const pro_nomrdz, pro_codint: SmallInt): TCNotFis00;
var
  sp: TADOStoredProc;
  S: string;
begin

    //
    // cria instancia
    Result :=TCNotFis00.Create ;

    // check existente
    // com base pedido(venda)
    if not Result.LoadFromPed(codped) then
    begin

        //
        // registra o CX
        if codmod = 55 then
            TCGenSerial.SetVal(Format('[NFE]nfe.%s.nserie.%.3d',[Empresa.CNPJ,nserie]),
                                      'UUID para NFE por CNPJ/MOD/SERIE' ,
                                      1, 1, 1, 999999999 )
        else
            TCGenSerial.SetVal(Format('[NFE]nfce.%s.nserie.%.3d',[Empresa.CNPJ,nserie]),
                                          'UUID para NFCE por CNPJ/MOD/SERIE' ,
                                          1, 1, 1, 999999999
                                          );

        //
        // nova emissão de documento fiscal
        // NFe/NFCe
        sp :=TADOStoredProc.NewADOStoredProc('sp_notfis00_add');
        try
            sp.AddParamWithValue('@codemp', ftSmallint, Empresa.codfil);
            sp.AddParamWithValue('@codufe', ftSmallint, codufe);
            sp.AddParamWithValue('@natope', ftString, natope);
            sp.AddParamWithValue('@indpag', ftSmallint, ord(indpag));
            sp.AddParamWithValue('@codmod', ftInteger, codmod);
            sp.AddParamWithValue('@nserie', ftSmallint, nserie);
            sp.AddParamWithValue('@dtemis', ftDateTime, dtemis);
            sp.AddParamWithValue('@tipntf', ftSmallint, ord(tipntf));
            sp.AddParamWithValue('@indope', ftSmallint, ord(indope));
            sp.AddParamWithValue('@codmun', ftInteger, codmun);
            sp.AddParamWithValue('@tipimp', ftSmallint, ord(tipimp));
            sp.AddParamWithValue('@tipemi', ftSmallint, ord(tipemi));
            sp.AddParamWithValue('@tipamb', ftSmallint, ord(tipamb));
            sp.AddParamWithValue('@finnfe', ftSmallint, ord(finnfe));
            sp.AddParamWithValue('@indfinal', ftSmallint, ord(indfinal));
            sp.AddParamWithValue('@indpres', ftSmallint, ord(indpres));
            sp.AddParamWithValue('@verproc', ftString, 'ATAC PDV 2.5 (2018)');
            sp.AddParamWithValue('@chvref', ftString, chvref);
            sp.AddParamWithValue('@modfret', ftSmallint, ord(modFret));
            sp.AddParamWithValue('@codped', ftInteger, codped);
            sp.AddParamWithValue('@begintran', ftSmallint, 0);
            sp.AddParamOut('@codseq', ftInteger);
            sp.AddParamWithValue('@pro_nomrdz', ftSmallint, pro_nomrdz);
            sp.AddParamWithValue('@pro_codint', ftSmallint, pro_codint);

            try
                sp.Connection.BeginTrans ;
                sp.ExecProc ;
                sp.Connection.CommitTrans;

                Result.m_codseq :=sp.Param('@codseq').Value ;
                if not Result.Load() then
                begin
                    Result.Free ;
                    raise EDatabaseError.Create('Nota fiscal não emitida!');
                end;

            except
                if sp.Connection.InTransaction then
                begin
                    sp.Connection.RollbackTrans;
                end;
                raise;
            end;

        finally
            sp.Free ;
        end;

    end

    //
    // atualiza & carrega novamente
    else begin
        Result.UpdateNFe(dtemis, pro_nomrdz, pro_codint, S);
        Result.Load() ;
    end;
end;

procedure TCNotFis00.OnClearItems(Sender: TObject; const Item: TCNotFis01;
  Action: TCollectionNotification);
begin
    if Action = cnRemoved then
    begin
        Item.Free ;
    end;
end;

procedure TCNotFis00.setCodLote(const aCodLot: Integer);
var
  C: TADOCommand ;
  cs: NotFis00CodStatus;
begin
    //
    // se status for consumo indevido!
    if Self.m_codstt =cs.ERR_CONSUMO_INDEVIDO then
    begin
        //
        // reset para posterior processamento
        Self.m_codstt :=cs.ERR_REGRAS ;
        Self.m_consumo:=1;
    end;

    C :=TADOCommand.NewADOCommand() ;
    try
      C.AddCmd('update notfis00 set   ');
      C.AddCmd('   nf0_codlot  =%d    ',[acodlot]);
      C.AddCmd('  ,nf0_codstt  =%d    ',[Self.m_codstt]);
      C.AddCmd('  ,nf0_consumo =%d    ',[Self.m_consumo]);
      C.AddCmd('where nf0_codseq =%d  ',[Self.m_codseq]);
      C.Execute ;
    finally
      C.Free ;
    end;
end;

procedure TCNotFis00.setConsumoWS;
var
  C: TADOCommand ;
  cs: NotFis00CodStatus;
begin
    Self.m_codstt :=cs.ERR_REGRAS ;
    Self.m_consumo:=1;

    C :=TADOCommand.NewADOCommand();
    try
      C.AddCmd('update notfis00 set   ');
      C.AddCmd('  nf0_codstt  =%d ,   ',[Self.m_codstt]);
      C.AddCmd('  nf0_consumo =%d     ',[Self.m_consumo]);
      C.AddCmd('where nf0_codseq =%d  ',[Self.m_codseq]);
      C.Execute ;
    finally
      C.Free ;
    end;
end;

procedure TCNotFis00.setContinge(const xJustif: string;
  const aCancel: Boolean) ;
var
  C: TADOCommand ;
begin
    //
    // guarda o status da forma emissão
    m_oritipemi :=m_tipemi ;

    //NFe
    if Self.m_codmod = 55 then
    begin
        Self.m_tipemi :=teContingencia;
        Self.m_motivo :='NF-e emitida em contingência!';
    end
    //NFCe
    else begin
        Self.m_tipemi :=teOffLine;
        Self.m_motivo :='NFC-e emitida em contingência!';
    end;
    Self.m_justif :=xJustif ;
    Self.m_codstt :=9;

    //
    // desfaz contingencia!
    //
    if aCancel then
    begin
        Self.m_tipemi :=teNormal;// m_oritipemi;
        Self.m_justif :='';
        Self.m_codstt :=0 ;
        Self.m_motivo :='';
    end;

    C :=TADOCommand.NewADOCommand() ;
    try
        C.AddCmd('update notfis00 set       ');
        C.AddCmd('  nf0_tipemi  =%d ,       ',[Ord(Self.m_tipemi)]);

        if Self.m_justif <> '' then
        begin
        C.AddCmd('  nf0_justif  =%s ,       ',[C.FStr(Self.m_justif)]);
        C.AddCmd('  nf0_dhcont  =getdate(), ');
        end
        else begin
        C.AddCmd('  nf0_justif  =null,      ');
        C.AddCmd('  nf0_dhcont  =null,      ');
        end;

        C.AddCmd('  nf0_codstt  =%d ,       ',[Self.m_codstt]);
        C.AddCmd('  nf0_motivo  =%s         ',[C.FStr(Self.m_motivo)]);
        C.AddCmd('where nf0_codseq =%d      ',[Self.m_codseq]);
        //C.SaveToFile();
        C.Execute ;
    finally
        C.Free ;
    end;

end;

procedure TCNotFis00.setFormaEmissao(const aTipEmis: TpcnTipoEmissao;
  const aJustif: string);
var
  C: TADOCommand ;
begin
    //
    // emissão normal
    if aTipEmis = teNormal then
    begin
        Self.m_tipemi :=teNormal;
        Self.m_justif :='';
        Self.m_codstt :=0 ;
        Self.m_motivo :='';
    end
    //
    // contigencia
    else begin
        if aTipEmis in[teContingencia, teSVCAN, teSVCRS] then
        begin
            Self.m_tipemi :=aTipEmis;
            Self.m_codstt :=9;
            if Self.m_codmod = 55 then
            begin
                Self.m_motivo :='NF-e emitida em contingência!';
            end
            else begin
                Self.m_motivo :='NFC-e emitida em contingência!';
            end;

            Self.m_justif :=aJustif ;

            if(aTipEmis =teContingencia)and(Self.m_codmod = 65)then
            begin
                Self.m_tipemi :=teOffLine;
            end;
        end;
    end;
    //
    //
    C :=TADOCommand.NewADOCommand() ;
    try
        C.AddCmd('update notfis00 set       ');
        C.AddCmd('  nf0_tipemi  =%d ,       ',[Ord(Self.m_tipemi)]);

        if Self.m_justif <> '' then
        begin
        C.AddCmd('  nf0_justif  =%s ,       ',[C.FStr(Self.m_justif)]);
        C.AddCmd('  nf0_dhcont  =getdate(), ');
        end
        else begin
        C.AddCmd('  nf0_justif  =null,      ');
        C.AddCmd('  nf0_dhcont  =null,      ');
        end;

        C.AddCmd('  nf0_codstt  =%d ,       ',[Self.m_codstt]);
        C.AddCmd('  nf0_motivo  =%s         ',[C.FStr(Self.m_motivo)]);
        C.AddCmd('where nf0_codseq =%d      ',[Self.m_codseq]);
        //C.SaveToFile();
        C.Execute ;
    finally
        C.Free ;
    end;

end;

procedure TCNotFis00.setStatus();
var
  C: TADOCommand ;
  cs: NotFis00CodStatus;
begin

    //
    // trata status
    // chk erro nas regras de negocio
    if CStatError then
    begin
        m_motivo:=Format('%d|%s',[Self.m_codstt,Self.m_motivo]);
        //
        // padroniza qr erro para o 88
        m_codstt:=cs.ERR_REGRAS ;

        //
        // se pesistir msm codigo
        // poder ser q hj consumo indevido
        if m_codstt =m_oricodstt then
        begin
            //
            // chk consumo indevido
            if m_consumo < TCNotFis00.QTD_MAX_CONSUMO -1 then
            begin
                m_consumo :=m_consumo +1 ;
            end
            //
            // consumo indevido ativo
            else begin
                //
                // set status
                m_codstt:=cs.ERR_CONSUMO_INDEVIDO ;
                m_motivo:=Format('CONSUMO INDEVIDO|QTD_MAX_CONSUMO=%d(%s)',[
                  TCNotFis00.QTD_MAX_CONSUMO,m_motivo]);
                m_consumo :=0;
            end;
        end
        else
            m_consumo :=0;
    end;

    //
    // limita tam.motivo em 250
    m_motivo:=Copy(m_motivo,1,250) ;

    C :=TADOCommand.NewADOCommand() ;
    try
      C.AddCmd('update notfis00 set   ');
      C.AddCmd('  nf0_codstt  =%d ,   ',[Self.m_codstt]);
      C.AddCmd('  nf0_motivo  =%s     ',[C.FStr(Self.m_motivo)]);

      if Self.m_numreci <> '' then
      begin
          C.AddCmd('  ,nf0_numreci  =%s    ',[C.FStr(Self.m_numreci)]);
      end;

      if Self.m_numprot <> '' then
      begin
          C.AddCmd('  ,nf0_indsinc =%d     ',[Self.m_indsinc]);
          C.AddCmd('  ,nf0_verapp   =%s    ',[C.FStr(Self.m_verapp)]);
          C.AddCmd('  ,nf0_dhreceb  =?     ');
          C.AddCmd('  ,nf0_numprot  =%s    ',[C.FStr(Self.m_numprot)]);
          C.AddCmd('  ,nf0_digval   =%s    ',[C.FStr(Self.m_digval)]);
      end;

      //trata forma pagto no codigo
      if Self.m_indpag <> Self.m_oriindpag then
      begin
          C.AddCmd('  ,nf0_indpag =%d     ',[ord(Self.m_indpag)]);
      end;

      C.AddCmd('  ,nf0_consumo =%d    ',[Self.m_consumo]);

      C.AddCmd('where nf0_codseq =%d  ',[Self.m_codseq]);

      C.AddParamWithValue('@nf0_dhreceb', ftDateTime, Self.m_dhreceb) ;

      C.Execute ;
    finally
      C.Free ;
    end;
end;

procedure TCNotFis00.setXML() ;
var
  C: TADOCommand ;
  P: TParameter ;
  S: TStringStream; // TStreamWriter;
var
  cmplvl: SmallInt ;
begin
    //
    // ler compatibilidade
    cmplvl :=TADOQuery.getCompLevel ;

    C :=TADOCommand.NewADOCommand() ;
    try
        C.AddCmd('update notfis00 set   ');
        if Self.m_xml <> '' then
        begin
            //
            // remove tag´s XML
            {xpos :=PosEx('?>',Self.m_xml) ;
            if xpos > 0 then
                Self.m_xml :=Copy(Self.m_xml,P+2,Length(Self.m_xml));}

            Self.m_motivo :=Copy(Self.m_motivo, 1, 250) ;
            C.AddCmd('  nf0_codstt  =%d,    ',[Self.m_codstt]);
            C.AddCmd('  nf0_motivo  =%s,    ',[C.FStr(Self.m_motivo)]);
            C.AddCmd('  nf0_chvnfe  =%s,    ',[C.FStr(Self.m_chvnfe)]);
            if cmplvl > 8 then
            begin
                C.AddCmd('  nf0_xmltyp  =?,     ');
                C.AddCmd('  nf0_xml     =null   ');
            end
            else
                C.AddCmd('  nf0_xml     =?      ');

            //S :=TStreamWriter.Create(TMemoryStream.Create);
            //S.Write(Self.m_xml);
            S :=TStringStream.Create(Self.m_xml);
        end
        else begin
            //
            // se não fech CX
            if Self.m_tag =0 then
            begin
                C.AddCmd('  nf0_codstt  =0,     ');
                C.AddCmd('  nf0_motivo  =null,  ');
                C.AddCmd('  nf0_chvnfe  =null,  ');
            end;
            //
            // chk cmp
            if cmplvl > 8 then
            begin
                C.AddCmd('  nf0_xml     =null,  ');
                C.AddCmd('  nf0_xmltyp  =null   ');
            end
            else
                C.AddCmd('  nf0_xml     =null   ');
        end;
        C.AddCmd('where nf0_codseq =%d  ',[Self.m_codseq]);

        if Assigned(S) then
        begin
            //P :=C.AddParamWithValue('@nf0_xml', ftMemo, Null) ;
            //P.LoadFromStream(S.BaseStream, ftMemo);
            P :=C.AddParamWithValue('@nf0_xml', ftString, Null) ;
            P.LoadFromStream(S, ftString);
        end;

        C.Execute ;

    finally
        C.Free ;
        if Assigned(S) then
        begin
            //S.BaseStream.Free ;
            S.Free;
        end;
    end;
end;

function TCNotFis00.UpdateNFe(const dtemis: Tdatetime;
  const pro_nomrdz, pro_codint: SmallInt;
  out err_msg: string): Boolean ;
var
  sp: TADOStoredProc;
begin

    Result :=False;
    //
    sp :=TADOStoredProc.NewADOStoredProc('sp_notfis00_upd');
    try
        sp.AddParamWithValue('@codseq', ftInteger, Self.m_codseq);
        sp.AddParamWithValue('@dtemis', ftDateTime, dtemis);
        sp.AddParamWithValue('@begintran', ftSmallint, 0);
        sp.AddParamWithValue('@pro_nomrdz', ftSmallint, pro_nomrdz);
        sp.AddParamWithValue('@pro_codint', ftSmallint, pro_codint);

        try
            sp.Connection.BeginTrans ;
            sp.ExecProc ;
            sp.Connection.CommitTrans;
            Result :=Self.Load() ;

        except
            on E:Exception do
            begin
                err_msg :=E.Message ;
                if sp.Connection.InTransaction then
                begin
                    sp.Connection.RollbackTrans;
                end;
            end;
        end;

    finally
        sp.Free ;
    end;
end;

{ TCNotFis01 }

constructor TCNotFis01.Create;
begin
    inherited Create;
//    m_icms :=TICMS.Create;
    m_ipi :=TIPI.Create ;
    m_pis :=TPIS.Create ;
    m_cofins :=TCOFINS.Create;
    m_comb :=TCNotFis02comb.Create ;
end;

destructor TCNotFis01.Destroy;
begin
//    m_icms.Destroy;
    m_ipi.Destroy;
    m_pis.Destroy;
    m_cofins.Destroy;
    m_comb.Destroy ;
    inherited;
end;

procedure TCNotFis01.doInsert;
var
  C: TADOCommand;
begin
    C :=TADOCommand.NewADOCommand();
    try
        C.AddCmd('insert into notfis01(nf1_codntf ,   ');
        //item.produto
        C.AddCmd('                    nf1_codpro ,    ');
        C.AddCmd('                    nf1_codean ,    ');
        C.AddCmd('                    nf1_descri ,    ');
        C.AddCmd('                    nf1_codncm ,    ');
//        C.AddCmd('                    nf1_extipi ,    ');
        C.AddCmd('                    nf1_cfop ,      ');
        C.AddCmd('                    nf1_undcom ,    ');
        C.AddCmd('                    nf1_qtdcom ,    ');
        C.AddCmd('                    nf1_vlrcom ,    ');
        C.AddCmd('                    nf1_vlrpro ,    ');
//        C.AddCmd('                    nf1_eantrib,    ');
//        C.AddCmd('                    nf1_undtrib ,   ');
//        C.AddCmd('                    nf1_qtdtrib ,   ');
//        C.AddCmd('                    nf1_vlrtrib ,   ');
        C.AddCmd('                    nf1_vlrfret ,   ');
        C.AddCmd('                    nf1_vlrsegr ,   ');
        C.AddCmd('                    nf1_vlrdesc ,   ');
        C.AddCmd('                    nf1_vlroutr ,   ');
        C.AddCmd('                    nf1_indtot ,    ');
        C.AddCmd('                    nf1_infadprod,  ');

        //item.imposto.icms
        if Self.m_cst >= 0 then
        begin
            C.AddCmd('                    nf1_cst ,   ');
            if Self.m_modbc > -1 then
              C.AddCmd('                    nf1_modbc  ,');
            C.AddCmd('                    nf1_predbc ,');
            if Self.m_modbcst > -1 then
              C.AddCmd('                    nf1_modbcst ,');
            C.AddCmd('                    nf1_pmvast  ,');
            C.AddCmd('                    nf1_predbcst,');
            C.AddCmd('                    nf1_vbcst   ,');
            C.AddCmd('                    nf1_picmsst ,');
            C.AddCmd('                    nf1_vicmsst ,');
            if TpcnCSTIcms(Self.m_cst) = cst60 then
            begin
              C.AddCmd('                    nf1_vbcstret,  ');
              C.AddCmd('                    nf1_vicmsstret,');
            end;
            //item.imposto.ipi
            if Self.m_ipi.vIPI > 0 then
            begin
              C.AddCmd('                    nf1_clenqipi ,  ');
              C.AddCmd('                    nf1_cnpjprodipi,');
              C.AddCmd('                    nf1_cseloipi ,  ');
              C.AddCmd('                    nf1_qseloipi ,  ');
              C.AddCmd('                    nf1_cenqipi ,   ');
              C.AddCmd('                    nf1_cstipi ,    ');
              C.AddCmd('                    nf1_vbcipi ,    ');
              C.AddCmd('                    nf1_qunidipi ,  ');
              C.AddCmd('                    nf1_vunidipi ,  ');
              C.AddCmd('                    nf1_pipi ,      ');
              C.AddCmd('                    nf1_vipi ,      ');
            end;
        end
        else begin
            C.AddCmd('                nf1_csosn ,     ');
            C.AddCmd('                nf1_pcredsn ,   ');
            C.AddCmd('                nf1_vcredicmssn,');
        end;
        C.AddCmd('                    nf1_orig  ,         ');
        C.AddCmd('                    nf1_vbc   ,         ');
        C.AddCmd('                    nf1_picms ,         ');
        C.AddCmd('                    nf1_vicms ,         ');

        //item.imposto.pis
        C.AddCmd('                    nf1_cstpis ,        ');
        C.AddCmd('                    nf1_vbcpis ,        ');
        C.AddCmd('                    nf1_ppis ,          ');
        C.AddCmd('                    nf1_vpis ,          ');
        C.AddCmd('                    nf1_qbcpropis ,     ');
        C.AddCmd('                    nf1_valiqpropis,    ');

        //item.imposto.cofins
        C.AddCmd('                    nf1_cstcofins ,     ');
        C.AddCmd('                    nf1_vbccofins ,     ');
        C.AddCmd('                    nf1_pcofins ,       ');
        C.AddCmd('                    nf1_vcofins ,       ');
        C.AddCmd('                    nf1_vbcprodcofins,  ');
        C.AddCmd('                    nf1_valiqprocofins, ');
        C.AddCmd('                    nf1_qbcprocofins  ) ');

        //
        //adiciona valores, conforme lista de campos acima!
        //
        C.AddCmd('values             (%d,--nf1_codntf     ',[Self.m_oParent.m_codseq]);
        C.AddCmd('                    %d,--nf1_codpro     ',[Self.m_codpro]);
        C.AddCmd('                    %s,--nf1_codean     ',[C.FStr(Self.m_codean)]);
        C.AddCmd('                    %s,--nf1_descri     ',[C.FStr(Self.m_descri)]);
        C.AddCmd('                    %s,--nf1_codncm     ',[C.FStr(Self.m_codncm)]);
//        C.AddCmd('                    nf1_extipi ,    ');
        C.AddCmd('                    %d,--nf1_cfop       ',[Self.m_cfop]);
        C.AddCmd('                    %s,--nf1_undcom     ',[C.FStr(Self.m_undcom)]);
        C.AddCmd('                    %12.3f,--nf1_qtdcom ',[Self.m_qtdcom]);
        C.AddCmd('                    %15.6f,--nf1_vlrcom ',[Self.m_vlrcom]);
        C.AddCmd('                    %15.2f,--nf1_vlrpro ',[Self.m_vlrpro]);
//        C.AddCmd('                    nf1_eantrib,    ');
//        C.AddCmd('                    nf1_undtrib ,   ');
//        C.AddCmd('                    nf1_qtdtrib ,   ');
//        C.AddCmd('                    nf1_vlrtrib ,   ');
        C.AddCmd('                    %12.2f,--nf1_vlrfret',[Self.m_vlrfret]);
        C.AddCmd('                    %12.2f,--nf1_vlrsegr',[Self.m_vlrsegr]);
        C.AddCmd('                    %12.2f,--nf1_vlrdesc',[Self.m_vlrdesc]);
        C.AddCmd('                    %12.2f,--nf1_vlroutr',[Self.m_vlroutr]);
        C.AddCmd('                    %d,--nf1_indtot     ',[Ord(Self.m_indtot)]);
        C.AddCmd('                    %s,--nf1_infadprod  ',[C.FStr(Self.m_infadprod)]);

        //item.imposto.icms
        if Self.m_cst >= 0 then
        begin
            C.AddCmd('                    %d,--nf1_cst',[Self.m_cst]);
            if Self.m_modbc > -1 then
                C.AddCmd('                    %d,--nf1_modbc',[Self.m_modbc]);
            C.AddCmd('                    %5.2f,--nf1_predbc',[Self.m_predbc]);
            if Self.m_modbcst > -1 then
                C.AddCmd('                    %d,--nf1_modbcst',[Self.m_modbcst]);
            C.AddCmd('                    %5.2f,--nf1_pmvast',[Self.m_pmvast]);
            C.AddCmd('                    %5.2f,--nf1_predbcst',[Self.m_predbcst]);
            C.AddCmd('                    %12.2f,--nf1_vbcst',[Self.m_vbcst]);
            C.AddCmd('                    %5.2f,--nf1_picmsst',[Self.m_picmsst]);
            C.AddCmd('                    %12.2f,--nf1_vicmsst',[Self.m_vicmsst]);
            if TpcnCSTIcms(Self.m_cst) = cst60 then
            begin
                C.AddCmd('                    %12.2f,--nf1_vbcstret',[Self.m_vbcstret]);
                C.AddCmd('                    %12.2f,--nf1_vicmsstret',[Self.m_vicmsstret]);
            end;
            //item.imposto.ipi
            if Self.m_ipi.vIPI > 0 then
            begin
              C.AddCmd('                    %s,--nf1_clenqipi    ',[C.FStr(Self.m_ipi.clEnq)]);
              C.AddCmd('                    %s,--nf1_cnpjprodipi ',[C.FStr(Self.m_ipi.CNPJProd)]);
              C.AddCmd('                    %s,--nf1_cseloipi    ',[C.FStr(Self.m_ipi.cSelo)]);
              C.AddCmd('                    %d,--nf1_qseloipi    ',[Self.m_ipi.qSelo]);
              C.AddCmd('                    %s,--nf1_cenqipi     ',[C.FStr(Self.m_ipi.cEnq)]);
              C.AddCmd('                    %d,--nf1_cstipi      ',[Ord(Self.m_ipi.CST)]);
              C.AddCmd('                    %12.2f,--nf1_vbcipi  ',[Self.m_ipi.vBC]);
              C.AddCmd('                    %12.3f,--nf1_qunidipi',[Self.m_ipi.qUnid]);
              C.AddCmd('                    %12.2f,--nf1_vunidipi',[Self.m_ipi.vUnid]);
              C.AddCmd('                    %5.2f,--nf1_pipi     ',[Self.m_ipi.pIPI]);
              C.AddCmd('                    %12.2f,--nf1_vipi    ',[Self.m_ipi.vIPI]);
            end;
        end
        else begin
            C.AddCmd('                    %d,--nf1_csosn    ',[Self.m_csosn]);
            C.AddCmd('                    %5.2f,--nf1_pcredsn ',[Self.m_pcredsn]);
            C.AddCmd('                    %10.2f,--nf1_vcredicmssn',[Self.m_vcredicmssn]);
        end;
        C.AddCmd('                    %d,--nf1_orig       ',[Ord(Self.m_orig)]);
        C.AddCmd('                    %15.2f,--nf1_vbc    ',[Self.m_vbc]);
        C.AddCmd('                    %5.2f,--nf1_picms   ',[Self.m_picms]);
        C.AddCmd('                    %12.2f,--nf1_vicms  ',[Self.m_vicms]);

        //item.imposto.pis
        C.AddCmd('                    %d,--nf1_cstpis             ',[Ord(Self.m_pis.CST)]);
        C.AddCmd('                    %12.2f,--nf1_vbcpis         ',[Self.m_pis.vBC]);
        C.AddCmd('                    %5.2f,--nf1_ppis            ',[Self.m_pis.pPIS]);
        C.AddCmd('                    %12.2f,--nf1_vpis           ',[Self.m_pis.vPIS]);
        C.AddCmd('                    %12.3f,--nf1_qbcprodpis     ',[Self.m_pis.qBCProd]);
        C.AddCmd('                    %12.3f,--nf1_valiqprodpis   ',[Self.m_pis.vAliqProd]);

        //item.imposto.cofins
        C.AddCmd('                    %d,--nf1_cstcofins            ',[Ord(Self.m_cofins.CST)]);
        C.AddCmd('                    %12.2f,--nf1_vbccofins        ',[Self.m_cofins.vBC]);
        C.AddCmd('                    %5.2f,--nf1_pcofins           ',[Self.m_cofins.pCOFINS]);
        C.AddCmd('                    %12.2f,--nf1_vcofins          ',[Self.m_cofins.vCOFINS]);
        C.AddCmd('                    %12.2f,--nf1_vbcprodcofins,   ',[Self.m_cofins.vBCProd]);
        C.AddCmd('                    %12.3f,--nf1_valiqprodcofins  ',[Self.m_cofins.vAliqProd]);
        C.AddCmd('                    %12.3f --nf1_qbcprodcofins  ) ',[Self.m_cofins.qBCProd]);

        if not C.Prepared then
        begin
            C.Prepared :=True ;
        end;

        //C.SaveToFile('insert_notfis01.sql');
        C.Execute ;

    finally
        C.Free ;
    end;
end;



{ TCInutNumeroList }

function TCInutNumeroList.AddNew: TCInutNumero;
begin
    Result :=TCInutNumero.Create ;
    Result.m_Parent :=Self ;
    Result.m_Index :=Self.Count ;
    Add(Result) ;
end;

function TCInutNumeroList.Load(const AFilter: TInutNumeroFilter): Boolean;
var
  Q: TADOQuery ;
  N: TCInutNumero;
begin
    //
    Self.Clear ;
    //
    Q :=TADOQuery.NewADOQuery() ;
    try
        Q.AddCmd('declare @codemp smallint; set @codemp =%d ',[AFilter.codemp ]);
        Q.AddCmd('declare @ano smallint   ; set @ano =%d    ',[AFilter.ano    ]);
        Q.AddCmd('select *from inutnumero                   ');
        Q.AddCmd('where num_codemp =@codemp                 ');
        if AFilter.ano > 0 then
        begin
            Q.AddCmd('and num_ano =@ano');
        end;
        Q.Open ;

        Result :=not Q.IsEmpty ;

        while not Q.Eof do
        begin
            N :=Self.AddNew ;
            N.m_codseq :=Q.Field('num_codseq').AsInteger ;
            N.m_codemp :=Q.Field('num_codemp').AsInteger ;
            N.m_tipamb :=TpcnTipoAmbiente(Q.Field('num_tipamb').AsInteger) ;
            N.m_codufe :=Q.Field('num_codufe').AsInteger ;
            N.m_ano :=Q.Field('num_ano').AsInteger ;
            N.m_cnpj :=Q.Field('num_cnpj').AsString ;
            N.m_codmod :=Q.Field('num_codmod').AsInteger ;
            N.m_nserie :=Q.Field('num_nserie').AsInteger ;
            N.m_numini :=Q.Field('num_numini').AsInteger ;
            N.m_numfin :=Q.Field('num_numfin').AsInteger ;
            N.m_justif :=Q.Field('num_justif').AsString ;
            N.m_numprot :=Q.Field('num_numprot').AsString ;
            N.m_dhreceb :=Q.Field('num_dhreceb').AsDateTime ;
            Q.Next ;
        end;
    finally
        Q.Free ;
    end;
end;

function TCInutNumeroList.LoadOfSerie(const numser: Word): Boolean;
var
  Q: TADOQuery ;
  N: TCInutNumero;
  ser_Id: string ;
begin
    Q :=TADOQuery.NewADOQuery() ;
    try
        Q.AddCmd('declare @nserie smallint; set @nserie =%d ',[numser]);
        Q.AddCmd('select                                    ');
        Q.AddCmd('  datepart(YY, getdate()) as nf0_ano,     ');
        Q.AddCmd('  nf0_emicnpj,nf0_codmod,nf0_nserie,      ');
        Q.AddCmd('  max(nf0_numdoc) as nf0_numdoc           ');
        Q.AddCmd('from notfis00                             ');
        if numser > 0 then
        Q.AddCmd('where nf0_nserie =@nserie                 ');
        Q.AddCmd('group by nf0_emicnpj,nf0_codmod,nf0_nserie');
        Q.Open ;
        Result :=not Q.IsEmpty ;
        //ult.documento(NF) emitido
        while not Q.Eof do
        begin
            N :=Self.AddNew ;
            N.m_cnpj  :=Q.Field('nf0_emicnpj').AsString ;
            N.m_codmod:=Q.Field('nf0_codmod').AsInteger ;
            N.m_nserie:=Q.Field('nf0_nserie').AsInteger ;
            N.m_numfin:=Q.Field('nf0_numdoc').AsInteger ;
            N.m_ano   :=Q.Field('nf0_ano').AsInteger ;
            N.m_ultnum:=N.m_numfin ;
            Q.Next ;
        end;

        {//ul.numero gerado(gen.serial)
        for N in Self do
        begin
            if N.m_codmod = 55 then
                ser_Id :=Format('nfe.%s.nserie.%.3d',[N.m_cnpj,N.m_nserie])
            else
                ser_Id :=Format('nfce.%s.nserie.%.3d',[N.m_cnpj,N.m_nserie]);
            //ler serial
            Q.AddCmd('select ser_valor from genserial');
            Q.AddCmd('where ser_ident =%s            ',[Q.FStr(ser_Id)]);
            Q.Open ;
            if Q.IsEmpty then
                N.m_ultnum:=0
            else begin
                //inc. do serial
                N.m_ultnum:=Q.Field('ser_valor').AsInteger ;
            end;
        end;}

    finally
        Q.Free ;
    end;
end;

{ TCInutNumero }

procedure TCInutNumero.DoInsert(const codstt: Word; const motivo: string);
var
  C: TADOCommand ;
  ser_Id: string ;
begin
    //
    C :=TADOCommand.NewADOCommand() ;
    try
        C.AddCmd('--//garante consistencia dos dados         ');
        C.AddCmd('begin tran                                 ');

        C.AddCmd('  --//registra nova inutilização, caso não ');
        C.AddCmd('  if not exists(select *from inutnumero where num_numprot =%s)',[C.FStr(Self.m_numprot)]);
        C.AddCmd('    insert into inutnumero( num_codemp,      ');
        C.AddCmd('                            num_tipamb,      ');
        C.AddCmd('                            num_codufe,      ');
        C.AddCmd('                            num_ano,         ');
        C.AddCmd('                            num_cnpj,        ');
        C.AddCmd('                            num_codmod,      ');
        C.AddCmd('                            num_nserie,      ');
        C.AddCmd('                            num_numini,      ');
        C.AddCmd('                            num_numfin,      ');
        C.AddCmd('                            num_justif,      ');
        C.AddCmd('                            num_codstt,      ');
        C.AddCmd('                            num_motivo,      ');
        C.AddCmd('                            num_verapp,      ');
        C.AddCmd('                            num_numprot,     ');
        C.AddCmd('                            num_dhreceb)     ');
        C.AddCmd('    values               (%d, --num_codemp   ',[Self.m_codemp]);
        C.AddCmd('                          %d, --num_tipamb   ',[Ord(Self.m_tipamb)]);
        C.AddCmd('                          %d, --num_codufe   ',[Self.m_codufe]);
        C.AddCmd('                          %d, --num_ano      ',[Self.m_ano   ]);
        C.AddCmd('                          %s, --num_cnpj     ',[C.FStr(Self.m_cnpj)]);
        C.AddCmd('                          %d, --num_codmod   ',[Self.m_codmod]);
        C.AddCmd('                          %d, --num_nserie   ',[Self.m_nserie]);
        C.AddCmd('                          %d, --num_numini   ',[Self.m_numini]);
        C.AddCmd('                          %d, --num_numfin   ',[Self.m_numfin]);
        C.AddCmd('                          %s, --num_justif   ',[C.FStr(Self.m_justif)]);
        C.AddCmd('                          %d, --num_codstt   ',[Self.m_codstt]);
        C.AddCmd('                          %s, --num_motivo   ',[C.FStr(Self.m_motivo)]);
        C.AddCmd('                          %s, --num_verapp   ',[C.FStr(Self.m_verapp)]);
        C.AddCmd('                          %s, --num_numprot  ',[C.FStr(Self.m_numprot)]);
        C.AddCmd('                          ?); --num_dhreceb  ');

        { TODO 1 -cNFE : SETAR O GEN. SERIAL SOMENTE PRA NOTA MAIOR }
        if Self.m_numfin > Self.m_ultnum then
        begin
          //
          // monta chave do gen.serial
          if Self.m_codmod = 55 then
              ser_Id :=Format('nfe.%s.nserie.%.3d',[Self.m_cnpj,Self.m_nserie])
          else
              ser_Id :=Format('nfce.%s.nserie.%.3d',[Self.m_cnpj,Self.m_nserie]);

          //
          // atualiza conforme ult.num > genserial
          C.AddCmd('  --//atualiza a gen.serial     ');
          C.AddCmd('  update genserial set          ');
          C.AddCmd('  ser_valor =%d                 ',[Self.m_numfin]);
          C.AddCmd('  where ser_ident =%s;          ',[C.FStr(ser_Id)]);
        end;

        C.AddCmd('  --//atualiza status da NF                ');
        C.AddCmd('  update notfis00 set                      ');
        C.AddCmd('  nf0_codstt  =%d ,                        ',[codstt]);
        C.AddCmd('  nf0_motivo  =%s                          ',[C.FStr(Copy(motivo,1,250))]);
        C.AddCmd('  where nf0_emicnpj =%s                    ',[C.FStr(Self.m_cnpj)]);
        C.AddCmd('  and   nf0_codmod  =%d                    ',[Self.m_codmod]);
        C.AddCmd('  and   nf0_nserie  =%d                    ',[Self.m_nserie]);
        C.AddCmd('  and   nf0_numdoc between %d and %d ;     ',[Self.m_numini,Self.m_numfin]);

        C.AddCmd('commit tran  ;                             ');

        C.AddParamWithValue('@dhreceb', ftDateTime, Self.m_dhreceb) ;

        //C.SaveToFile();

        C.Execute ;
    finally
        C.Free ;
    end;

end;


{ TCNotFis00Lote }

function TCNotFis00Lote.AddNotFis00(const codseq: Int32): TCNotFis00;
begin
    Result :=TCNotFis00.Create;
    Result.m_Parent :=Self ;
    Result.m_ItemIndex :=m_oItems.Count ;
    Result.m_codseq   :=codseq ;
    Items.Add(Result) ;
    if Self.m_CodSeq = 0 then
    begin
       Self.m_CodSeq :=Result.m_codseq ;
    end;
end;

class function TCNotFis00Lote.CLoad(const afilter: TNotFis00Filter): TDataSet;
var
  Q: TADOQuery ;
  dh_now: TDateTime;
begin
    //
    Result :=nil;
    //
    Q :=TADOQuery.NewADOQuery() ;
    //

    Q.AddCmd('declare @seqini int; set @seqini =%d          ',[afilter.codini]);
    Q.AddCmd('declare @seqfin int; set @seqfin =%d          ',[afilter.codfin]);
    Q.AddCmd('declare @pedini int; set @pedini =%d          ',[afilter.pedini]);
    Q.AddCmd('declare @pedfin int; set @pedfin =%d          ',[afilter.pedfin]);
    Q.AddCmd('declare @datini smalldatetime; set @datini =? ');
    Q.AddCmd('declare @datfin smalldatetime; set @datfin =? ');
    Q.AddCmd('declare @codmod smallint; set @codmod =%d     ',[afilter.codmod]);
    Q.AddCmd('declare @numser smallint; set @numser =%d     ',[afilter.nserie]);

    if afilter.limlot > 0 then
    Q.AddCmd('select top %d                                 ',[afilter.limlot])
    else
    Q.AddCmd('select                                        ');

    //ident
    Q.AddCmd('  nf0_codseq ,                               ');
    Q.AddCmd('  nf0_codemp ,                               ');
    Q.AddCmd('  nf0_codufe ,                               ');
    Q.AddCmd('  nf0_natope ,                               ');
    Q.AddCmd('  nf0_indpag ,                               ');
    Q.AddCmd('  nf0_codmod ,                               ');
    Q.AddCmd('  nf0_nserie ,                               ');
    Q.AddCmd('  nf0_numdoc ,                               ');
    Q.AddCmd('  nf0_dtemis ,                               ');
    Q.AddCmd('  nf0_dhsaient,                              ');
    Q.AddCmd('  nf0_tipntf ,                               ');
    Q.AddCmd('  nf0_indope ,                               ');
    Q.AddCmd('  nf0_codmun ,                               ');
    Q.AddCmd('  nf0_tipimp ,                               ');
    Q.AddCmd('  nf0_tipemi ,                               ');
    Q.AddCmd('  nf0_tipamb ,                               ');
    Q.AddCmd('  nf0_finnfe ,                               ');
    Q.AddCmd('  nf0_chvref ,                               ');
    Q.AddCmd('  nf0_indfinal,                              ');
    Q.AddCmd('  nf0_indpres ,                              ');
    Q.AddCmd('  nf0_procemi ,                              ');
    Q.AddCmd('  nf0_verproc ,                              ');
    Q.AddCmd('  nf0_dhcont  ,                              ');
    Q.AddCmd('  nf0_justif ,                               ');
    //emitente
    Q.AddCmd('  nf0_emicnpj ,                              ');
    Q.AddCmd('  nf0_eminome ,                              ');
    Q.AddCmd('  nf0_emifant ,                              ');
    Q.AddCmd('  nf0_emilogr ,                              ');
    Q.AddCmd('  nf0_eminumero,                             ');
    Q.AddCmd('  nf0_emicomple,                             ');
    Q.AddCmd('  nf0_emibairro,                             ');
    Q.AddCmd('  nf0_emicodmun,                             ');
    Q.AddCmd('  nf0_emimun,                                ');
    Q.AddCmd('  nf0_emiufe ,                               ');
    Q.AddCmd('  nf0_emicep ,                               ');
    Q.AddCmd('  nf0_emifone ,                              ');
    Q.AddCmd('  nf0_emiie ,                                ');
    Q.AddCmd('  nf0_emiiest ,                              ');
    Q.AddCmd('  nf0_emicrt ,                               ');
    //destinatario
    Q.AddCmd('  nf0_dsttippes ,                            ');
    Q.AddCmd('  nf0_dstcnpjcpf ,                           ');
    Q.AddCmd('  nf0_dstidestra ,                           ');
    Q.AddCmd('  nf0_dstnome ,                              ');
    Q.AddCmd('  nf0_dstlogr ,                              ');
    Q.AddCmd('  nf0_dstnumero ,                            ');
    Q.AddCmd('  nf0_dstcomple ,                            ');
    Q.AddCmd('  nf0_dstbairro ,                            ');
    Q.AddCmd('  nf0_dstcodmun ,                            ');
    Q.AddCmd('  nf0_dstmun    ,                            ');
    Q.AddCmd('  nf0_dstufe ,                               ');
    Q.AddCmd('  nf0_dstcep ,                               ');
    Q.AddCmd('  nf0_dstfone ,                              ');
    Q.AddCmd('  nf0_dstindie,                              ');
    Q.AddCmd('  nf0_dstie,                                 ');
    Q.AddCmd('  nf0_dstisuf  ,                             ');
    Q.AddCmd('  nf0_dstemail ,                             ');

    //
    //transportes
    //
    Q.AddCmd('  nf0_modfret  ,                            ');
    //transportadora
    Q.AddCmd('  nf0_tracnpjcpf ,                          ');
    Q.AddCmd('  nf0_tranome ,                             ');
    Q.AddCmd('  nf0_traie ,                               ');
    Q.AddCmd('  nf0_traend ,                              ');
    Q.AddCmd('  nf0_tramun ,                              ');
    Q.AddCmd('  nf0_traufe ,                              ');
    //veiculo
    Q.AddCmd('  nf0_veiplaca ,                            ');
    Q.AddCmd('  nf0_veiufe ,                              ');
    Q.AddCmd('  nf0_veirntc ,                             ');
    //volumes
    Q.AddCmd('  nf0_volqtd  ,                             ');
    Q.AddCmd('  nf0_volesp ,                              ');
    Q.AddCmd('  nf0_volmrc ,                              ');
    Q.AddCmd('  nf0_volnum ,                              ');
    Q.AddCmd('  nf0_volpsol ,                             ');
    Q.AddCmd('  nf0_volpsob ,                             ');

    Q.AddCmd('  nf0_codped  ,                             ');

    //status
    Q.AddCmd('  nf0_codstt ,                               ');
    Q.AddCmd('  nf0_motivo ,                               ');
    Q.AddCmd('  nf0_chvnfe ,                               ');
    Q.AddCmd('  nf0_indsinc ,                              ');

    //retorno
    Q.AddCmd('  nf0_verapp ,                               ');
    Q.AddCmd('  nf0_dhreceb ,                              ');
    Q.AddCmd('  nf0_numreci ,                              ');
    Q.AddCmd('  nf0_numprot ,                              ');
    Q.AddCmd('  nf0_digval                                 ');

    //
    // consumo indevido
    Q.AddCmd('  ,nf0_consumo                               ');
    //
    //
    Q.AddCmd('  ,nf0_infcpl                                ');
    //
    //
    Q.AddCmd('  ,nf0_codlot                                ');

    Q.AddCmd('from notfis00 with(readpast)                 ');

    //
    // busca por
    // nf0_codseq
    if afilter.codini > 0 then
    begin
        Q.AddCmd('where nf0_codseq between @seqini and @seqfin ');
    end

    //
    // busca por
    // nf0_codped
    else if afilter.pedini > 0 then
    begin
        Q.AddCmd('where nf0_codped between @pedini and @pedfin ');
    end

    //
    // busca por
    // periodo / situacao
    else begin

        //
        // prepara para o idx(1,3)
        //

        //
        // nf0_codmod
        if aFilter.codmod > 0 then
        begin
            Q.AddCmd('where nf0_codmod =@codmod                          ');
        end
        else begin
            Q.AddCmd('where ((nf0_codmod =55)or(nf0_codmod =65))         ');
        end;

        //
        // nf0_nserie
        if aFilter.nserie > 0 then
        begin
            Q.AddCmd('and nf0_nserie =@numser                            ');
        end;

        //
        // filtro normal
        if afilter.filTyp = ftNormal then
        begin

            //
            // nf0_dtemis
            Q.AddCmd('and nf0_dtemis between @datini and @datfin             ');

            //
            // nf0_codstt
            case aFilter.status of
                sttDoneSend:Q.AddCmd('and nf0_codstt in(0,1)                    ');
                sttConting: Q.AddCmd('and nf0_codstt =9                         ');
                sttAutoriza:Q.AddCmd('and nf0_codstt in(100,150)                ');
                sttDenega:  Q.AddCmd('and nf0_codstt in(301,302,303)            ');
                sttCancel:  Q.AddCmd('and nf0_codstt in(101,135,151,155,218)    ');
                sttInut:    Q.AddCmd('and nf0_codstt in(102,206,563)            ');
                sttError:   Q.AddCmd('and nf0_codstt not in(0,1,9,100,101,102,110,135,150,151,155,301,302,303)');
            end;

            //
            // ult. NF entrar, primeira a sai
            Q.AddCmd('order by nf0_codseq desc                               ');
        end

        //
        // filtro service
        else if afilter.filTyp = ftService then
        begin
            //
            // prepare serie/status
            Q.AddCmd('and   nf0_nserie =@numser                        ');
            Q.AddCmd('and ( (nf0_codstt =0)   --//status inicial       ');
            Q.AddCmd('or    (nf0_codstt =1)   --//pronto para envio    ');
            Q.AddCmd('or    (nf0_codstt =9)   --//contingencia         ');
            Q.AddCmd('or    (nf0_codstt =44)  --//pendente de retorno  ');
            Q.AddCmd('or    (nf0_codstt =77)  --//erro de schema       ');
            Q.AddCmd('or    (nf0_codstt =88)  --//erro nas regras de negocio');
            Q.AddCmd('or    (nf0_codstt =103) --//lote em processamento');
            Q.AddCmd('--//Rejeição 204: Duplicidade de NF-e            ');
            Q.AddCmd('or    (nf0_codstt =204)                          ');
            Q.AddCmd('--//Rejeição 217: NFe não consta na base de dados');
            Q.AddCmd('or    (nf0_codstt =217)                          ');
            Q.AddCmd('--//Rejeição 539: Duplicidade de NF-e, com diferença na Chave de Acesso');
            Q.AddCmd('or    (nf0_codstt =539)                          ');
            Q.AddCmd('--//Rejeição 613: Chave de Acesso difere da existente em BD (WS_CONSULTA)');
            Q.AddCmd('or    (nf0_codstt =613)                          ');
            Q.AddCmd('--//Rejeição 704: NFC-E com data-hora de emissão atrasada');
            Q.AddCmd('or    (nf0_codstt =704)                          ');
            Q.AddCmd('or    (nf0_codstt =999))  --//erro geral sefaz   ');

            //
            // NF´s não vinculadas ao lote
            Q.AddCmd('and   nf0_codlot is null                         ');

            //
            // prioriza novas emissões (nf0_codstt=0)
            Q.AddCmd('order by nf0_codstt                              ');
        end
        //
        // filtro fech CX
        else begin
            //
            // nf0_dtemis
            if(afilter.datini >0)and(afilter.datfin >0) then
            begin
                Q.AddCmd('and nf0_dtemis between @datini and @datfin        ');
                Q.AddCmd('--//notas uso autorizado/canceladas               ');
                Q.AddCmd('and nf0_codstt in(100,150,101,151,135,155,218)    ');
            end
            else begin
                //
                // nf0_codstt
                Q.AddCmd('--//notas nao processadas                         ');
                Q.AddCmd('and nf0_codstt not in(0,100,103,110,150,301,302,303)');
                Q.AddCmd('--//notas nao canceladas                          ');
                Q.AddCmd('and nf0_codstt not in(101,151,135,155,218)        ');
                Q.AddCmd('--//notas nao inutilizadas                        ');
                Q.AddCmd('and nf0_codstt not in(102,206,563)                ');
            end;
            Q.AddCmd('order by nf0_codseq                               ');
        end;
    end;

    if not Q.Prepared then
    begin
        Q.Prepared :=True;
    end;

    //
    // inicializa param datetime
    Q.AddParamWithValue('@datini', ftDateTime, Null);
    Q.AddParamWithValue('@datfin', ftDateTime, Null);

    //
    // valida periodo
    if afilter.datini > 0 then
    begin
        Q.Param('@datini').Value :=afilter.datini ;
        Q.Param('@datfin').Value :=afilter.datini ;
    end;
    if afilter.datfin > 0 then
    begin
        Q.Param('@datfin').Value :=afilter.datfin ;
        if Q.Param('@datini').Value = Null then
        begin
            Q.Param('@datini').Value :=afilter.datfin;
        end;
    end;

    if afilter.save then
    begin
        case afilter.filTyp of
            ftNormal: Q.SaveToFile(Format('App-%s.Load.SQL',[Self.ClassName]));
            ftService: Q.SaveToFile(Format('Svc-%s.Load.SQL',[Self.ClassName]));
            ftFech: Q.SaveToFile(Format('Fcx-%s.Load.SQL',[Self.ClassName]));
        end;

    end;
    Q.Open ;
    //
    // cast
    Result :=TDataSet(Q);

end;

class function TCNotFis00Lote.CLoadSPNotFis00Busca(
  const afilter: TNotFis00Filter): TDataSet ;
var
  F: TNotFis00Filter ;
  sp: TADOStoredProc ;
begin
    //
    Result :=nil ;
    F :=afilter ;
    //
    // set param datetime
    if(F.datini =0)or(F.datfin =0)then
    begin
        F.datini :=Date;
        F.datfin :=F.datini;
    end;
    //
    //
    // set params
    sp :=TADOStoredProc.NewADOStoredProc('sp_notfis00_busca');
    sp.AddParamWithValue('@codseq', ftInteger, F.codini);
    sp.AddParamWithValue('@codped', ftInteger, F.pedini);
    sp.AddParamWithValue('@filtyp', ftSmallint, Ord(F.filTyp));
    sp.AddParamWithValue('@datini', ftDateTime, Null);
    sp.AddParamWithValue('@datfin', ftDateTime, Null);
    sp.AddParamWithValue('@status', ftSmallint, Ord(F.status));
    sp.AddParamWithValue('@codmod', ftSmallint, F.codmod);
    sp.AddParamWithValue('@numser', ftSmallint, F.nserie);
    sp.AddParamWithValue('@topnum', ftSmallint, F.limlot);
    sp.AddParamOut('@err_msg', ftString);
    //sp.AddParamRet('@err_cod');

    try
        //
        // valida periodo
        if afilter.datini > 0 then
        begin
            sp.Param('@datini').Value :=afilter.datini ;
            sp.Param('@datfin').Value :=afilter.datini ;
        end;
        if afilter.datfin > 0 then
        begin
            sp.Param('@datfin').Value :=afilter.datfin ;
            if sp.Param('@datini').Value = Null then
            begin
                sp.Param('@datini').Value :=afilter.datfin;
            end;
        end;
        //
        //
        sp.Open ;
        Result :=TDataSet (sp) ; //.Recordset) ;
    except
        on E:EDatabaseError do
        begin
            sp.Free ;
            raise ;
        end;
    end;

end;

class function TCNotFis00Lote.CLoadXML(
  const afilter: TNotFis00Filter): TADOQuery;
begin
    Result :=TADOQuery.NewADOQuery() ;

end;

constructor TCNotFis00Lote.Create;
begin
    m_oItems :=TList<TCNotFis00>.Create ;
    m_oItems.OnNotify :=OnClear ;
end;

destructor TCNotFis00Lote.Destroy;
begin
    m_oItems.Destroy ;
    inherited;
end;

procedure TCNotFis00Lote.Desvincula(const aNumSer: SmallInt);
var
  C: TADOQuery ;
begin
    C :=TADOQuery.NewADOQuery() ;
    try
        C.AddCmd('declare @nserie smallint;set @nserie =%d;     ',[aNumSer]) ;
        C.AddCmd('update notfis00 set nf0_codlot =null          ');
        C.AddCmd('where ((nf0_codmod=55)or(nf0_codmod=65))      ');
        C.AddCmd('and nf0_nserie =@nserie                       ');
        C.AddCmd('--//notas nao processadas                     ');
        C.AddCmd('and nf0_codstt not in(100,110,150,301,302,303)');
        C.AddCmd('--//notas nao canceladas                      ');
        C.AddCmd('and nf0_codstt not in(101,151,135,155,218)    ');
        C.AddCmd('--//notas nao inutilizadas                    ');
        C.AddCmd('and nf0_codstt not in(102,563)                ');
        C.AddCmd('--//notas vinculadas ao lote                  ');
        C.AddCmd('and nf0_codlot is not null                    ');
        C.ExecSQL ;
    finally
        C.Free ;
    end;
end;

function TCNotFis00Lote.IndexOf(const chvnfe: string): TCNotFis00;
var
  found: Boolean ;
begin
    found :=false ;
    for Result in Self.Items do
    begin
        if Result.m_chvnfe =chvnfe then
        begin
            found :=True ;
            Break;
        end;
    end;
    if not found then
    begin
        Result :=nil;
    end;
end;

function TCNotFis00Lote.IndexOf(const codseq: Int32): TCNotFis00;
var
  found: Boolean ;
begin
    found :=false ;
    for Result in Self.Items do
    begin
        if Result.m_codseq =codseq then
        begin
            found :=True ;
            Break;
        end;
    end;
    if not found then
    begin
        Result :=nil;
    end;
end;

function TCNotFis00Lote.Load(const AFilter: TNotFis00Filter): Boolean;
var
  Q: TDataSet; // TADOQuery ;
  N: TCNotFis00;
  cmplvl: Integer;
var
  fcodseq: TField ;
begin
    //
    m_oItems.Clear ;
    //
    //
    m_Filter :=afilter;

    //
    // combatibilidade
    cmplvl :=TADOQuery.getCompLevel ;
    if cmplvl > 8 then
        Q :=TCNotFis00Lote.CLoadSPNotFis00Busca(m_Filter)
    else
        Q :=TCNotFis00Lote.CLoad(m_Filter) ;
    try
        m_vTotalNF :=0;
        fcodseq :=Q.FieldByName('nf0_codseq') ;
        Result  :=not Q.IsEmpty ;
        while not Q.Eof do
        begin
            //
            // ler NF
            N :=Self.AddNotFis00(fcodseq.AsInteger) ;

            if cmplvl >8 then
                N.FillDataSet(Q)
            else
                N.LoadFromQ(Q);
            N.LoadItems;

            //
            // totaliza NF
            m_vTotalNF :=m_vTotalNF +N.m_icmstot.vNF;
            //
            // proximo
            Q.Next ;
        end;

    finally
        Q.Free ;
    end;
end;

function TCNotFis00Lote.LoadCX(const codcxa: smallint; out lstcod: string): Boolean;
var
  Q: TADOQuery ;
  N: TCNotFis00;
var
  fcodseq: TField ;
var
  P: TCParametro ;
  top: Word ;

begin
    //
    m_oItems.Clear ;
    //
    lstcod :='';
    //

    //
    // ler parametro top(n) notas em lote
    P :=TCParametro.NewParametro('send_maxnfelot', ftSmallint);
    if not P.Load() then
        top :=25
    else
        top :=P.ReadInt() ;

    Q :=TADOQuery.NewADOQuery() ;
    try
        Q.AddCmd('declare @codcxa smallint; set @codcxa =%d             ',[codcxa]);

        Q.AddCmd('select top %d                                         ',[top]);
        Q.AddCmd('  nf.* from notfis00 nf                               ');

        Q.AddCmd('--//notas nao processadas                             ');
        Q.AddCmd('where nf0_codstt not in(100, 110, 150, 301, 302, 303) ');
        Q.AddCmd('--//notas nao canceladas                              ');
        Q.AddCmd('and nf0_codstt not in(101, 151, 135, 155, 218)        ');
        Q.AddCmd('--//notas nao inutilizadas                            ');
        Q.AddCmd('and nf0_codstt not in(102, 563)                       ');
        Q.AddCmd('and nf0_nserie =@codcxa                               ');
        Q.Open ;

        fcodseq :=Q.Field('nf0_codseq') ;

        Result  :=not Q.IsEmpty ;

        while not Q.Eof do
        begin
            N :=Self.IndexOf(fcodseq.AsInteger) ;
            if N = nil then
            begin
                N :=Self.AddNotFis00(fcodseq.AsInteger) ;
                N.LoadFromQ(Q);
            end ;

            lstcod :=lstcod +Format('"%d",',[N.m_codped]);

            Q.Next ;
        end;
        SetLength(lstcod, length(lstcod)-1);

    finally
        Q.Free ;
    end;

end;


procedure TCNotFis00Lote.OnClear(Sender: TObject; const Item: TCNotFis00;
  Action: TCollectionNotification);
begin
    if Action = cnRemoved then
    begin
        Item.Free ;
    end;
end;


procedure TCNotFis00Lote.setFilter(const aValue: TNotFis00Filter);
begin
    m_Filter :=aValue ;
    m_oItems.Clear ;

end;


end.
