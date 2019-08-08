{***
* Interfaces/Classes para as chamadas do ACBr especificos do MDFe
* Atac Sistemas
* Todos os direitos reservados
* Autor: Carlos Gonzaga
* Data: 24.07.2019
*}
unit uACBrMDFe;

interface

uses Windows, SysUtils, Classes, Generics.Collections ,
  ACBrDFeReport, ACBrMDFeDAMDFeClass, ACBrMDFeDAMDFeRLClass,
  ACBrBase, ACBrDFe, ACBrMDFe, ACBrMDFeManifestos, ACBrMail,
  ACBrMDFeWebServices, pmdfeProcMDFe, pmdfeEnvEventoMDFe ,
  FDM.MDFE,
  uManifestoDF, uparam,
  Form.ViewLOG;


type

  //
  // params do manifesto
  TRegMDFe = object
  private
  public
    //active_mdfe: TPair<string,Boolean>;
    amb_pro: TPair<string,Boolean>;
    tip_emis: TPair<string,Boolean>;
    tip_emit: TPair<string,smallint>;
    tip_transp: TPair<string,smallint>;
    ver_doc: TPair<string,smallint>;
    cod_und: TPair<string,smallint>;

    send_assync: TPair<string,Boolean>;
    imp_confirm: TPair<string,Boolean>;
    imp_mpreview: TPair<string,Boolean>;
    imp_msetup: TPair<string,Boolean>;

    //
    // local dos arquivos gravados
    arq_SaveXML: TPair<string, Boolean>;
    arq_SaveEvento: TPair<string, Boolean>;
    arq_SepCNPJ: TPair<string, Boolean>;
    arq_SepAno: TPair<string, Boolean>;
    arq_SepMes: TPair<string, Boolean>;
    //arq_SepModelo: TPair<string, Boolean>;
    arq_RootPath: TPair<string, string>;
//    arq_PathSchemas: TPair<string, string>;
//    arq_PathEvento: TPair<string, string>;

    procedure Load();
  end;


  TCBaseACBrMDFe =class ;

  IBaseACBrMDFe = Interface(IInterface)
    procedure LoadConfig() ;
    function getErrCod: Integer;
    property ErrCod: Integer read getErrCod;
    function getErrMsg: string ;
    property ErrMsg: string read getErrMsg;

    //
    function getMDFe: TACBrMDFe;
    property mdfe: TACBrMDFe read getMDFe;

    //
    function AddManifesto(mdf: IManifestoDF): Manifesto;

    function SendMail(mdf: IManifestoDF; const dest_email: string =''): Boolean;
    //
    function OnlyStatusSvc(): Boolean;

    function OnlySend(mdf: IManifestoDF): Boolean;
    function OnlyCons(mdf: IManifestoDF): Boolean;
    function OnlyCanc(mdf: IManifestoDF; const aJust: String): Boolean;
    function OnlyEncerra(mdf: IManifestoDF): Boolean;

    function recepLote(mdf: IManifestoDF): Boolean ;
    function consSitMDFe(mdf: IManifestoDF): Boolean ;

    //
    function PrintDAMDFe(mdf: IManifestoDF): Boolean ;

    //
//    function getRetInfEvento: TRetInfEvento ;
//    property retInfEvento: TRetInfEvento read getRetInfEvento;
    //
//    function getRetInutiliza: TNFeInutilizacao ;
//    property retInutiliza: TNFeInutilizacao read getRetInutiliza ;
    //
//    function getDaysUseCertif: Smallint ;

    //
    //

//    function FormatPath(const aPath, aLiteral: String;
//      const aCNPJ: String = ''; const aData: TDateTime = 0;
//      const aModDescr: String = ''): string ;

//    procedure saveToFile(NF: TCNotFis00) ;

  end;

  TCBaseACBrMDFe =class(TInterfacedObject, IBaseACBrMDFe)
  private
    m_ErrCod: Integer;
    m_ErrMsg: string ;
    function getErrCod: Integer;
    function getErrMsg: string ;
    procedure LoadConfig() ;

  protected
    m_DM: Tdm_mdfe ;
    m_MDFE: TACBrMDFe;
    m_DAMDFeRL: TACBrMDFeDAMDFeRL;
    m_Mail: TACBrMail;
    m_StatusChange: Boolean ;
    m_ViewLOG: IViewLOG ;
    m_Param: TRegMDFe;
    function getMDFe: TACBrMDFe;
    procedure OnGerarLog(const aLogLine: string; var aTratado: Boolean);
    procedure OnStatusChange(Sender: TObject);
    procedure OnTransmitError(const HttpError, InternalError: Integer;
      const URL, DadosEnviados, SoapAction: string;
      var Retentar, Tratado: Boolean);

  public
    constructor Create(const aStatusChange: Boolean; const aParam: TRegMDFe);
    destructor Destroy; override ;

    property ErrCod: Integer read getErrCod;
    property ErrMsg: string read getErrMsg;
    property mdfe: TACBrMDFe read getMDFe;
    //
    function AddManifesto(mdf: IManifestoDF): Manifesto;
    //
    function OnlyStatusSvc(): Boolean;
    function OnlySend(mdf: IManifestoDF): Boolean;
    function OnlyCons(mdf: IManifestoDF): Boolean;
    function OnlyCanc(mdf: IManifestoDF; const aJust: String): Boolean;
    function OnlyEncerra(mdf: IManifestoDF): Boolean;

    function recepLote(mdf: IManifestoDF): Boolean ;
    function consSitMDFe(mdf: IManifestoDF): Boolean;
//    function

    //
    function PrintDAMDFe(mdf: IManifestoDF): Boolean ;
    function SendMail(mdf: IManifestoDF; const dest_email: string =''): Boolean;
  public
    class function New(const aStatusChange: Boolean;
      const aParam: TRegMDFe): IBaseACBrMDFe;
  end;



implementation

uses StrUtils, DateUtils, TypInfo, WinInet, DB,
  unotfis00, uadodb, uini, ucademp,
  ACBrUtil, ACBrDFeSSL, ACBrDFeException, ACBr_WinHttp ,
  pcnConversao, pcnConversaoNFe, pmdfeMDFe, pmdfeConversaoMDFe,
  pmdfeRetConsSitMDFe, pmdfeRetEnvEventoMDFe ,
  blcksock,
  RLPrinters ,
  uCondutor
  ;



{ TCBaseACBrMDFe }

function TCBaseACBrMDFe.AddManifesto(mdf: IManifestoDF): Manifesto;
var
  mdfe: TMDFe;
  I: TinfMunDescargaCollectionItem;
  U: TinfUnidTranspCollectionItem ;
var
  M: TCManifestodf01mun;
  N: IManifestodf02nfe ;
  C: ICondutor ;
var
  tot_vlr: Currency;
  pso_bru: Double;
var
  cs: NotFis00CodStatus ;
begin

    //
    // add
    Result :=m_MDFE.Manifestos.Add ;
    mdfe:=Result.MDFe ;

    //
    // retorna somente um manifesto vazio
    if mdf = nil then
    begin
        Exit(Result);
    end;

    //
    // ide
    mdfe.Ide.cUF :=mdf.codUfe ;
    mdfe.Ide.tpAmb  :=TpcnTipoAmbiente(mdf.tpAmbiente) ;
    mdfe.Ide.tpEmit :=TTpEmitenteMDFe(mdf.tpEmitente) ;
    if mdf.tpTransportador > -1 then
    begin
        mdfe.Ide.tpTransp :=TTransportadorMDFe(mdf.tpTransportador) ;
    end;
    mdfe.Ide.modelo :=IntToStr(mdf.codMod) ;
    mdfe.Ide.serie  :=mdf.numSer ;
    mdfe.Ide.nMDF   :=mdf.numeroDoc ;
    mdfe.Ide.cMDF   :=mdf.id ;
    mdfe.Ide.modal  :=moRodoviario ;
    mdfe.Ide.dhEmi  :=mdf.dhEmissao;
    mdfe.Ide.tpEmis :=TpcnTipoEmissao(mdf.tpEmissao);
    mdfe.Ide.procEmi:=peAplicativoContribuinte ;
    mdfe.Ide.verProc:=mdf.verProc ;
    mdfe.Ide.UFIni  :=mdf.ufeIni ;
    mdfe.Ide.UFFim  :=mdf.ufeFim ;
    //
    // mun. de carga
    for M in mdf.municipios.getDataList do
    begin
        if M.tipoMun =mtCarga then
        with mdfe.Ide.infMunCarrega.Add do
        begin
            cMunCarrega :=M.codigoMun;
            xMunCarrega :=M.nomeMun ;
        end;
    end;

    //
    // emitente
    mdfe.Emit.CNPJCPF           :=CadEmp.CNPJ;
    mdfe.Emit.IE                :=CadEmp.IE;
    mdfe.Emit.xNome             :=CadEmp.xNome;
    mdfe.Emit.xFant             :=CadEmp.xFant;
    mdfe.Emit.EnderEmit.CEP     :=CadEmp.ender.CEP;
    mdfe.Emit.EnderEmit.xLgr    :=CadEmp.ender.xLogr;
    mdfe.Emit.EnderEmit.nro     :=CadEmp.ender.numero;
    mdfe.Emit.EnderEmit.xCpl    :=CadEmp.ender.xCompl;
    mdfe.Emit.EnderEmit.xBairro :=CadEmp.ender.xBairro;
    mdfe.Emit.EnderEmit.cMun    :=CadEmp.ender.cMun;
    mdfe.Emit.EnderEmit.xMun    :=CadEmp.ender.xMun;
    mdfe.Emit.EnderEmit.UF      :=CadEmp.ender.UF;
    mdfe.Emit.EnderEmit.fone    :=CadEmp.fone;
    mdfe.Emit.EnderEmit.email   :=CadEmp.email;

    //
    // modal rodoviário
    // info veiculo
    mdfe.rodo.RNTRC :=mdf.rntrc ;
    mdfe.rodo.veicTracao.cInt :=IntToStr(mdf.modalRodo.veiculo.id);
    mdfe.rodo.veicTracao.placa :=mdf.modalRodo.veiculo.placa;
    mdfe.rodo.veicTracao.RENAVAM :=mdf.modalRodo.veiculo.RENAVAM;
    mdfe.rodo.veicTracao.tara :=mdf.modalRodo.veiculo.tara;
    mdfe.rodo.veicTracao.capKG :=mdf.modalRodo.veiculo.capacidadeKg;
    mdfe.rodo.veicTracao.capM3 :=mdf.modalRodo.veiculo.capacidadeM3;
    mdfe.rodo.veicTracao.tpRod :=TpcteTipoRodado(mdf.modalRodo.veiculo.tipRodado);
    mdfe.rodo.veicTracao.tpCar :=TpcteTipoCarroceria(mdf.modalRodo.veiculo.tipCarroceria);
    mdfe.rodo.veicTracao.UF :=mdf.modalRodo.veiculo.ufLicenca;

    //
    // modal rodoviário
    // info de condutores
    for C in mdf.modalRodo.condutores.Items do
    begin
        with mdfe.rodo.veicTracao.condutor.Add do
        begin
            xNome :=C.Nome;
            CPF   :=C.CPFCNPJ;
        end;
    end;

    //
    // mun. descarga
    tot_vlr :=0;
    pso_bru :=0;
    for M in mdf.municipios.getDataList do
    begin
        if M.tipoMun =mtDescarga then
        begin
            I :=mdfe.infDoc.infMunDescarga.Add ;
            I.cMunDescarga :=M.codigoMun ;
            I.xMunDescarga :=M.nomeMun ;
            //
            // docs (NFE´s) vinculados
            for N in M.nfeList.getDataList do
            begin
                with I.infNFe.Add do
                begin
                    chNFe :=N.chvNFE ;
                    SegCodBarra :=N.codBarras ;
//                    U :=infUnidTransp.New ;
//                    U.qtdRat :=N.volPsoB;
                end;
                tot_vlr :=tot_vlr +N.vlrNtf;
                pso_bru :=pso_bru +N.volPsoB;
            end;
        end;
    end;

    //
    // totais
    if M <> nil then
        mdfe.tot.qNFe :=M.nfeList.getDataList.Count
    else
        mdfe.tot.qNFe :=1;
    mdfe.tot.vCarga :=tot_vlr;
    // UnidMed = (uM3,uKG, uTON, uUNIDADE, uLITROS);
    mdfe.tot.cUnid  :=uTON;
    mdfe.tot.qCarga :=pso_bru;

//    mdfe.infAdic.infCpl     := 'Empresa optante pelo Simples Nacional.; Caminhao VW.';
//    mdfe.infAdic.infAdFisco := '';

    //
    // 2
    mdfe.infMDFeSupl.qrCodMDFe :='';

    try
        Result.Assinar ;
    except
        on E:EACBrDFeException  do
        begin
            Self.m_ErrCod :=cs.ERR_ASSINA ;
            Self.m_ErrMsg :=E.Message ;
            Exit(nil) ;
        end;
    end;

    if Result.VerificarAssinatura then
    begin
        try
            Result.Validar ;
            if Result.ValidarRegrasdeNegocios then
            begin
                if TpcnTipoEmissao(mdf.tpEmissao) = teNormal then
                begin
                    Self.m_ErrCod:=cs.DONE_SEND ;
                    Self.m_ErrMsg:='MDF-e pronta para envio';
                end
                else begin
                    Self.m_ErrCod :=cs.CONTING_OFFLINE;
                    Self.m_ErrMsg :='MDF-e emitido em contingência!';
                end;
            end
            else begin
                Self.m_ErrCod :=cs.ERR_REGRAS;
                Self.m_ErrMsg :=Result.ErroRegrasdeNegocios;
            end;
        except
            Self.m_ErrCod :=cs.ERR_SCHEMA;
            //Self.m_ErrMsg :=N.ErroValidacao;
            Self.m_ErrMsg :=Result.ErroValidacaoCompleto;
        end;
    end
    else begin
        Self.m_ErrCod :=cs.ERR_CHECK_ASSINA;
        Self.m_ErrMsg :=Result.ErroValidacao;
    end;
end;

function TCBaseACBrMDFe.consSitMDFe(mdf: IManifestoDF): Boolean;
var
  ws: TMDFeConsulta ;
  E: TRetEventoMDFeCollectionItem;
  R: TRetInfEventoCollectionItem;
  L: IEventoMDFList;
  C: IEventoMDF ;
var
  I: Integer;
  tpEvento, numSeq: Integer;
  encerr, cancel: Boolean ;
begin
    //
    // limpa rep.
    m_MDFE.Manifestos.Clear;

    m_ErrCod :=0;
    m_ErrMsg :='';

    Result :=m_MDFE.Consultar(mdf.chMDFe) ;
    Result :=Result and(m_ErrCod =0);
    if Result then
    begin
        ws :=m_MDFE.WebServices.Consulta ;
        //
        // inicializa lista de eventos
        L :=TCEventoMDFList.Create ;
        L.Load(mdf.id) ;

        //
        // reg. eventos
        for I :=0 to ws.procEventoMDFe.Count -1 do
        begin
            tpEvento :=0;
            numSeq :=0;

            E :=ws.procEventoMDFe.Items[I] ;
            case E.RetEventoMDFe.InfEvento.tpEvento of
                teCancelamento: tpEvento :=TCEventoMDF.RE_CANCELA ;
                teEncerramento: tpEvento :=TCEventoMDF.RE_ENCERRA ;
                teInclusaoCondutor: tpEvento :=TCEventoMDF.RE_INC_CONDUTOR ;
            end;
            numSeq :=E.RetEventoMDFe.InfEvento.nSeqEvento ;

            //
            // chk exists evento
            C :=L.IndexOf(tpEvento, numSeq) ;
            if C = nil then
            begin
                //
                //
                C :=TCEventoMDF.New(mdf.id,
                                    E.RetEventoMDFe.InfEvento.cOrgao,
                                    Ord(E.RetEventoMDFe.InfEvento.tpAmb),
                                    E.RetEventoMDFe.InfEvento.chMDFe,
                                    E.RetEventoMDFe.InfEvento.dhEvento,
                                    tpEvento, numSeq) ;

                //
                // info para cancelamento
                C.xJust :=E.RetEventoMDFe.InfEvento.detEvento.xJust ;
                //
                // info para encerramento
                C.setEncerra( E.RetEventoMDFe.InfEvento.detEvento.dtEnc ,
                              E.RetEventoMDFe.InfEvento.detEvento.cMun);
                //
                // info para inc. de condutor
                // ...


                //
                // info status/protocolo
                if E.RetEventoMDFe.retEvento.Count > 0 then
                begin
                    R :=E.RetEventoMDFe.retEvento.Items[0] ;
                    C.setStatus(R.RetInfEvento.cStat,
                                R.RetInfEvento.xMotivo);
                    C.setProtocolo( R.RetInfEvento.nProt,
                                    R.RetInfEvento.verAplic,
                                    '',
                                    R.RetInfEvento.dhRegEvento );
                end;

                //
                // grava no banco
                C.cmdInsert ;
            end;
        end;

        //
        // reg. protocolo de autorização
        //P :=m_MDFE.WebServices.Consulta.protMDFe ;
        if ws.protMDFe.cStat <> ws.cStat then
        begin
            mdf.setRet( ws.cStat, ws.xMotivo ,
                        ws.protMDFe.verAplic,
                        '',
                        ws.protMDFe.nProt,
                        ws.protMDFe.digVal ,
                        ws.protMDFe.dhRecbto);
            m_ErrCod :=ws.cStat;
            m_ErrMsg :=ws.xMotivo;
        end
        else begin
            mdf.setRet( ws.protMDFe.cStat, ws.protMDFe.xMotivo ,
                        ws.protMDFe.verAplic,
                        '',
                        ws.protMDFe.nProt,
                        ws.protMDFe.digVal ,
                        ws.protMDFe.dhRecbto);
            m_ErrCod :=ws.protMDFe.cStat;
            m_ErrMsg :=ws.protMDFe.xMotivo;
        end;
    end;
end;

constructor TCBaseACBrMDFe.Create(const aStatusChange: Boolean;
  const aParam: TRegMDFe);
begin
    m_StatusChange :=aStatusChange ;
    m_Param :=aParam ;
    inherited Create;

    m_DM :=Tdm_mdfe.Create(True) ;
    m_MDFE :=m_DM.m_MDFe ;
    m_DAMDFeRL :=m_DM.m_DAMDFeRL ;
    m_Mail:=m_DM.m_Mail;

    m_MDFE.OnGerarLog :=OnGerarLog;
    m_MDFE.OnStatusChange :=OnStatusChange;
    m_MDFE.OnTransmitError:=OnTransmitError;
end;

destructor TCBaseACBrMDFe.Destroy;
begin
    m_DM.Free;
    inherited;
end;

function TCBaseACBrMDFe.getErrCod: Integer;
begin
    Result :=m_ErrCod ;
end;

function TCBaseACBrMDFe.getErrMsg: string;
begin
    Result :=m_ErrMsg ;
end;

function TCBaseACBrMDFe.getMDFe: TACBrMDFe;
begin
    Result :=m_MDFE ;
end;

procedure TCBaseACBrMDFe.LoadConfig;
var
  ini: IMemIniFile ;
begin
    m_ErrCod :=0;
    m_ErrMsg :='';
    //
    // inicia empresa
    if CadEmp = nil then CadEmp :=TCCadEmp.New(1) ;

    //
    //
    ini :=TCMemIniFile.New(ApplicationPath +'Configuracoes.ini') ;


    //
    // certificado
    ini.Section :='Certificado';
    m_MDFE.Configuracoes.Certificados.ArquivoPFX :=ini.ValStr('Caminho') ;
    if FileExists(m_MDFE.Configuracoes.Certificados.ArquivoPFX)then
    begin
        m_MDFE.Configuracoes.Certificados.NumeroSerie :='';
    end
    else begin
        m_MDFE.Configuracoes.Certificados.NumeroSerie :=ini.ValStr('NumSerie') ;
        m_MDFE.Configuracoes.Certificados.ArquivoPFX :='';
    end;
    m_MDFE.Configuracoes.Certificados.Senha :=ini.ValStr('Senha') ;
    m_MDFE.Configuracoes.Certificados.VerificarValidade :=False ;

    m_MDFE.Configuracoes.Geral.SSLLib         :=TSSLLib(ini.ValInt('SSLLib')) ;
    m_MDFE.Configuracoes.Geral.SSLCryptLib    :=TSSLCryptLib(ini.ValInt('CryptLib')) ;
    m_MDFE.Configuracoes.Geral.SSLHttpLib     :=TSSLHttpLib(ini.ValInt('HttpLib')) ;
    {$IfDef DFE_SEM_XMLSEC}
    m_MDFE.Configuracoes.Geral.SSLXmlSignLib  :=xsLibXml2 ;
    {$Else}
    m_MDFE.Configuracoes.Geral.SSLXmlSignLib  :=TSSLXmlSignLib(ini.ValInt('XmlSignLib')) ;
    {$EndIf}


    //
    //config.geral
    ini.Section :='Geral';
    m_MDFE.Configuracoes.Geral.RetirarAcentos   :=ini.ValBoo('RetirarAcentos',True) ;
    m_MDFE.Configuracoes.Geral.ExibirErroSchema :=ini.ValBoo('ExibirErroSchema',True) ;
    m_MDFE.Configuracoes.Geral.FormatoAlerta    :=ini.ValStr('FormatoAlerta','TAG:%TAGNIVEL% ID:%ID%/%TAG%(%DESCRICAO%) - %MSG%.') ;
    m_MDFE.Configuracoes.Geral.FormaEmissao     :=TpcnTipoEmissao(m_Param.tip_emis.Value) ;
    m_MDFE.Configuracoes.Geral.VersaoDF         :=TVersaoMDFe(m_Param.ver_doc.Value) ;
    m_MDFE.Configuracoes.Geral.Salvar           :=ini.ValBoo('Salvar',True) ;
    m_MDFE.Configuracoes.Geral.GerarInfMDFeSupl :=fgtSempre ;

    //
    //config.ws
    ini.Section :='WebService';
    m_MDFE.Configuracoes.WebServices.UF         :=CadEmp.ender.UF ;
    if m_Param.amb_pro.Value then
    begin
        m_MDFE.Configuracoes.WebServices.Ambiente   :=taProducao;
    end
    else begin
        m_MDFE.Configuracoes.WebServices.Ambiente   :=taHomologacao;
    end;
    m_MDFE.Configuracoes.WebServices.Visualizar :=ini.ValBoo('Visualizar') ;
    m_MDFE.Configuracoes.WebServices.Salvar     :=ini.ValBoo('SalvarSOAP') ;
    m_MDFE.Configuracoes.WebServices.AjustaAguardaConsultaRet :=ini.ValBoo('AjustarAut');
    m_MDFE.Configuracoes.WebServices.AguardarConsultaRet :=ini.ValInt('Aguardar');
    if m_MDFE.Configuracoes.WebServices.AguardarConsultaRet <1000 then
    begin
        m_MDFE.Configuracoes.WebServices.AguardarConsultaRet :=m_MDFE.Configuracoes.WebServices.AguardarConsultaRet *1000;
    end;
    m_MDFE.Configuracoes.WebServices.Tentativas :=ini.ValInt('Tentativas',5);

    m_MDFE.Configuracoes.WebServices.IntervaloTentativas :=ini.ValInt('Intervalo') ;
    if m_MDFE.Configuracoes.WebServices.IntervaloTentativas < 1000 then
    begin
        m_MDFE.Configuracoes.WebServices.IntervaloTentativas :=m_MDFE.Configuracoes.WebServices.IntervaloTentativas *1000;
    end;
    m_MDFE.Configuracoes.WebServices.TimeOut :=ini.ValInt('TimeOut',5000) ;
    m_MDFE.SSL.SSLType :=TSSLType(ini.ValInt('SSLType')) ;

    //
    //config.proxy
    ini.Section :='Proxy';
    m_MDFE.Configuracoes.WebServices.ProxyHost :=ini.ValStr('Host') ;
    m_MDFE.Configuracoes.WebServices.ProxyPort :=ini.ValStr('Porta');
    m_MDFE.Configuracoes.WebServices.ProxyUser :=ini.ValStr('User') ;
    m_MDFE.Configuracoes.WebServices.ProxyPass :=ini.ValStr('Pass') ;

    //
    //arquivos
    m_MDFE.Configuracoes.Arquivos.Salvar           :=m_Param.arq_SaveXML.Value;
    m_MDFE.Configuracoes.Arquivos.SepararPorCNPJ   :=m_Param.arq_SepCNPJ.Value;
    m_MDFE.Configuracoes.Arquivos.SepararPorAno    :=m_Param.arq_SepAno.Value;
    m_MDFE.Configuracoes.Arquivos.SepararPorMes    :=m_Param.arq_SepMes.Value;
    //m_MDFE.Configuracoes.Arquivos.SepararPorModelo :=m_reg.arq_SepModelo.Value;
    m_MDFE.Configuracoes.Arquivos.PathSalvar :=PathWithDelim(m_Param.arq_RootPath.Value) +'MDFe\tmp';
    //m_NFE.Configuracoes.Arquivos.AdicionarLiteral := m_Ini.ReadBool(   'Arquivos','AddLiteral' ,false);
    //m_NFE.Configuracoes.Arquivos.EmissaoPathNFe   := m_Ini.ReadBool(   'Arquivos','EmissaoPathNFe',false);
    //m_NFE.Configuracoes.Arquivos.SalvarEvento := m_Ini.ReadBool(   'Arquivos','SalvarEvento',false);
    m_MDFE.Configuracoes.Arquivos.PathSchemas :=PathWithDelim(m_Param.arq_RootPath.Value) +'Schemas\MDFe';
//    m_NFE.Configuracoes.Arquivos.PathNFe  := m_Ini.ReadString( 'Arquivos','PathNFe'    ,'') ;
//    m_NFE.Configuracoes.Arquivos.PathInu  := m_Ini.ReadString( 'Arquivos','PathInu'    ,'') ;
    m_MDFE.Configuracoes.Arquivos.PathEvento :=m_MDFE.Configuracoes.Arquivos.PathSalvar;

    //
    // DAMDFE
    ini.Section :='DANFE';
    m_MDFE.DAMDFE.Sistema := 'Atac Ssistemas - www.atacsistemas.com.br';
    m_MDFE.DAMDFE.Logo    :=ini.ValStr('LogoMarca') ;

end;

class function TCBaseACBrMDFe.New(const aStatusChange: Boolean;
  const aParam: TRegMDFe): IBaseACBrMDFe;
begin
    Result :=TCBaseACBrMDFe.Create(aStatusChange, aParam);
    Result.LoadConfig ;
end;

procedure TCBaseACBrMDFe.OnGerarLog(const aLogLine: string;
  var aTratado: Boolean);
begin
    aTratado :=True ;
    m_ErrMsg:=aLogLine;
end;

function TCBaseACBrMDFe.OnlyCanc(mdf: IManifestoDF;
  const aJust: String): Boolean;
var
  M: Manifesto ;
  E: TInfEventoCollectionItem;
begin

    m_MDFE.EventoMDFe.Evento.Clear;

    E :=m_MDFE.EventoMDFe.Evento.New ;
    E.infEvento.CNPJCPF   :=OnlyNumber(CadEmp.CNPJ);
    E.infEvento.cOrgao    :=mdf.codufe;
    E.infEvento.dhEvento  :=now;
    E.infEvento.tpEvento  :=teCancelamento;
    E.infEvento.nSeqEvento:=1;
    E.infEvento.chMDFe     :=mdf.chMDFe;
    E.infEvento.detEvento.nProt :=mdf.numProt;
    E.infEvento.detEvento.xJust :=aJust;

    Result :=m_MDFE.EnviarEvento(mdf.id) ;
    if Result then
    begin
        m_ErrCod :=E.RetInfEvento.cStat;
        m_ErrMsg :=E.RetInfEvento.xMotivo;
        Result :=m_ErrCod in[101, 135] ;
//        if Result then
//        begin
//            {NF.m_codstt :=E.RetInfEvento.cStat ;
//            NF.m_motivo :=E.RetInfEvento.xMotivo;
//            NF.m_dhreceb:=E.RetInfEvento.dhRegEvento;
//            NF.m_verapp :=E.RetInfEvento.verAplic;
//            NF.m_numprot:=E.RetInfEvento.nProt;
//            NF.m_digval :=''; //E.RetInfEvento.digVal;}
//        end ;
    end
    else
        m_ErrMsg :=m_MDFE.WebServices.EnvEvento.xMotivo;
end;

function TCBaseACBrMDFe.OnlyCons(mdf: IManifestoDF): Boolean;
begin
    m_MDFE.Manifestos.Clear;
    m_ErrCod :=0;
    m_ErrMsg :='';
    Result :=m_MDFE.Consultar(mdf.chMDFe) ;
    Result :=Result and(m_ErrCod =0);
    if Result then
    begin
        {NF.m_codstt :=m_NFE.WebServices.Consulta.cStat ;
        NF.m_motivo :=m_NFE.WebServices.Consulta.XMotivo ;
        NF.m_dhreceb:=m_NFE.WebServices.Consulta.DhRecbto;
        NF.m_verapp :=m_NFE.WebServices.Consulta.verAplic;
        NF.m_numprot:=m_NFE.WebServices.Consulta.Protocolo;
        NF.m_digval :=m_NFE.WebServices.Consulta.protNFe.digVal;
        }
    end;
end;

function TCBaseACBrMDFe.OnlyEncerra(mdf: IManifestoDF): Boolean;
var
//  M: Manifesto ;
  E: TInfEventoCollectionItem;
  M: TCManifestodf01mun;
begin

    //
    // ler mun.
    for M in mdf.municipios.getDataList do
    begin
        if M.tipoMun = mtDescarga then
          Break ;
    end;

    m_MDFE.EventoMDFe.Evento.Clear;

    E :=m_MDFE.EventoMDFe.Evento.New ;
    E.infEvento.CNPJCPF   :=OnlyNumber(CadEmp.CNPJ);
    E.infEvento.cOrgao    :=mdf.codufe;
    E.infEvento.dhEvento  :=TADOQuery.getDateTime;
    E.infEvento.tpEvento  :=teEncerramento;
    E.infEvento.nSeqEvento:=1;
    E.infEvento.chMDFe    :=mdf.chMDFe;
    E.infEvento.detEvento.nProt :=mdf.numProt;
    E.infEvento.detEvento.cUF :=mdf.codufe;
    E.infEvento.detEvento.dtEnc :=E.infEvento.dhEvento ;

    if M <> nil then
    begin
        E.infEvento.detEvento.cMun:=M.codigoMun;
    end
    else begin
        E.infEvento.detEvento.cMun:=CadEmp.ender.cMun;
    end;

    Result :=m_MDFE.EnviarEvento(mdf.id) ;
    if Result then
    begin
        m_ErrCod :=E.RetInfEvento.cStat;
        m_ErrMsg :=E.RetInfEvento.xMotivo;
        Result :=m_ErrCod in[132, 135] ;
//        if Result then
//        begin
//            {NF.m_codstt :=E.RetInfEvento.cStat ;
//            NF.m_motivo :=E.RetInfEvento.xMotivo;
//            NF.m_dhreceb:=E.RetInfEvento.dhRegEvento;
//            NF.m_verapp :=E.RetInfEvento.verAplic;
//            NF.m_numprot:=E.RetInfEvento.nProt;
//            NF.m_digval :=''; //E.RetInfEvento.digVal;}
//        end ;
    end
    else
        m_ErrMsg :=m_MDFE.WebServices.EnvEvento.xMotivo;
end;

function TCBaseACBrMDFe.OnlySend(mdf: IManifestoDF): Boolean;
var
  M: Manifesto ;
var
  cs: NotFis00CodStatus ;
begin

    //
    // adiciona o manifesto ao repositorio
    // assina e validação
    M :=AddManifesto(mdf) ;
    if M <> nil then
    begin
        //
        // grava xml, chave e status
        //
        mdf.setXML(Self.ErrCod, Self.ErrMsg, OnlyNumber(M.MDFe.infMDFe.Id), M.XMLAssinado);

        //
        // chk status de erros (assinatura,validaçao e regras de negocio)
        //
        if Self.ErrCod in[cs.ERR_CHECK_ASSINA,cs.ERR_SCHEMA,cs.ERR_REGRAS] then
        begin
            Exit(False);
        end;
    end
    else begin
        Self.m_ErrMsg :='Não foi possível gerar o MDF-e!';
        Exit(false);
    end;

    m_ErrCod :=0;
    m_ErrMsg :='';

    Result :=m_MDFE.Enviar( mdf.id,
                            m_Param.imp_confirm.Value,
                            m_Param.send_assync.Value);
    Result :=Result and(Self.m_ErrCod =0);
end;

function TCBaseACBrMDFe.OnlyStatusSvc: Boolean;
begin
    m_MDFE.Configuracoes.Certificados.VerificarValidade :=True;
    try
        Result :=m_MDFE.WebServices.StatusServico.Executar;
    finally
        m_MDFE.Configuracoes.Certificados.VerificarValidade :=False ;
    end;
end;

procedure TCBaseACBrMDFe.OnStatusChange(Sender: TObject);
begin
    if m_StatusChange then
    begin
      if m_ViewLOG = nil then
          m_ViewLOG :=Tfrm_ViewLOG.New('STATUS DO MDF-E') ;

      case m_MDFE.Status of

        stMDFeIdle: if m_ViewLOG <> nil then m_ViewLOG.setVisible(False);

        stMDFeStatusServico: m_ViewLOG.setStr('Verificando Status do servico...');

        stMDFeRecepcao: m_ViewLOG.setStr('Enviando dados do MDFe...');

        stMDFeRetRecepcao: m_ViewLOG.setStr('Recebendo dados do MDFe...');

        stMDFeConsulta: m_ViewLOG.setStr('Consultando MDFe...');

        stMDFeRecibo: m_ViewLOG.setStr('Consultando Recibo de Lote...');

        stMDFeEvento: m_ViewLOG.setStr('Enviando Evento...');
      end;
    end;
end;

procedure TCBaseACBrMDFe.OnTransmitError(const HttpError,
  InternalError: Integer; const URL, DadosEnviados, SoapAction: string;
  var Retentar, Tratado: Boolean);
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
            HTTP_STATUS_SERVICE_UNAVAIL: m_ErrMsg := 'Serviço indisponível (Service Unavailable)';
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
            m_ErrMsg := 'TimeOut de Requisição';
          ERROR_WINHTTP_NAME_NOT_RESOLVED:
            m_ErrMsg := 'O nome do servidor não pode ser resolvido';
          ERROR_WINHTTP_CANNOT_CONNECT:
            m_ErrMsg := 'Conexão com o Servidor falhou';
          ERROR_WINHTTP_CONNECTION_ERROR:
            m_ErrMsg := 'A conexão com o servidor foi redefinida ou encerrada, ou um protocolo SSL incompatível foi encontrado';
          ERROR_INTERNET_CONNECTION_RESET:
            m_ErrMsg := 'A conexão com o servidor foi redefinida';
          ERROR_WINHTTP_SECURE_INVALID_CA:
            m_ErrMsg := 'Certificado raiz não é confiável pelo provedor de confiança';
          ERROR_WINHTTP_SECURE_CERT_REV_FAILED:
            m_ErrMsg := 'Revogação do Certificado não pode ser verificada porque o servidor de revogação está offline';
          ERROR_WINHTTP_SECURE_CHANNEL_ERROR:
            m_ErrMsg := 'Erro relacionado ao Canal Seguro';
          ERROR_WINHTTP_SECURE_FAILURE:
            m_ErrMsg := 'Um ou mais erros foram encontrados no certificado Secure Sockets Layer (SSL) enviado pelo servidor';
          ERROR_WINHTTP_CLIENT_CERT_NO_PRIVATE_KEY:
            m_ErrMsg := 'O contexto para o certificado de cliente SSL não tem uma chave privada associada a ele. O certificado de cliente pode ter sido importado para o computador sem a chave privada';
          ERROR_WINHTTP_CLIENT_CERT_NO_ACCESS_PRIVATE_KEY:
            m_ErrMsg := 'Falha ao obter a Chave Privada do Certificado para comunicação segura';
          //
          // 3.12.2018
          ERROR_SERVICE_DOES_NOT_EXIST:
            m_ErrMsg := 'O serviço especificado não existe como um serviço instalado';
        end;
    end;
end;

function TCBaseACBrMDFe.PrintDAMDFe(mdf: IManifestoDF): Boolean;
var
  ptr: TRLPrinterWrapper;
  M: Manifesto ;
begin
    if m_MDFE.DAMDFE <> nil then
    begin
        //
        // load padrão
        if mdf.xml <> '' then
        begin
            M :=AddManifesto(nil) ;
            M.LerXML(mdf.xml) ;
            //
            // ler info protocolo
            if mdf.tpAmbiente = 0 then
                M.MDFe.procMDFe.tpAmb   :=taProducao
            else
                M.MDFe.procMDFe.tpAmb   :=taHomologacao;
            M.MDFe.procMDFe.verAplic:=mdf.verApp ;
            M.MDFe.procMDFe.chMDFe   :=mdf.chMDFe ;
            M.MDFe.procMDFe.dhRecbto:=mdf.dhRecebto;
            M.MDFe.procMDFe.nProt   :=mdf.numProt;
            M.MDFe.procMDFe.digVal  :=mdf.digVal ;
            M.MDFe.procMDFe.cStat   :=mdf.Status ;
            M.MDFe.procMDFe.xMotivo :=mdf.motivo ;
            M.GerarXML ;
        end
        //
        // load XML do local
        else begin

            //
            // set root
            raise ENotFis00.Create('Não carregou o XML!');
            {local :=param.arq_SaveXML_RootPath.Value ;
            if Pos('proc', local) = 0 then
            begin
                local :=PathWithDelim(local) +'proc';
            end;
            local :=FormatPath(local,'',NF.m_emit.CNPJCPF,NF.m_dtemis);

            //
            // format filename
            F :=Format('%s-procNFe.XML',[NF.m_chvnfe]);
            F :=PathWithDelim(local) +F ;

            //
            // chk exists
            Result :=FileExists(F) ;
            if Result then
            begin
                m_NFE.NotasFiscais.Clear ;
                m_NFE.NotasFiscais.LoadFromFile(F, True);
                N :=m_NFE.NotasFiscais.Items[0] ;
            end
            else
                raise ENotFis00.CreateFmt('Arquivo "%s" não encontrado!',[F]);
            }
        end;

        //
        // print
        M.Imprimir ;

    end;
end;

function TCBaseACBrMDFe.recepLote(mdf: IManifestoDF): Boolean;
var
  M: Manifesto ;
  ws_send: TMDFeRecepcao;
  ws_ret: TMDFeRetRecepcao;
var
  cs: NotFis00CodStatus ;
begin

    //
    // adiciona o manifesto ao repositorio
    // assina e validação
    M :=AddManifesto(mdf) ;
    if M <> nil then
    begin
        //
        // grava xml, chave e status
        //
        mdf.setXML(Self.ErrCod, Self.ErrMsg, OnlyNumber(M.MDFe.infMDFe.Id), M.XMLAssinado);

        //
        // chk status de erros (assinatura,validaçao e regras de negocio)
        //
        if Self.ErrCod in[cs.ERR_CHECK_ASSINA,cs.ERR_SCHEMA,cs.ERR_REGRAS] then
        begin
            Exit(False);
        end;
    end
    else begin
        Self.m_ErrMsg :='Não foi possível gerar o MDF-e!';
        Exit(false);
    end;

    m_ErrCod :=0;
    m_ErrMsg :='';

    //
    // envia lote
    Result :=m_MDFE.Enviar( mdf.id,
                            m_Param.imp_confirm.Value,
                            not m_Param.send_assync.Value);
    Result :=Result and(Self.m_ErrCod =0);
    //
    // trata retorno
    if Result then
    begin
        //
        // reg. assync
        if m_Param.send_assync.Value then
        begin
            ws_ret :=m_MDFE.WebServices.Retorno ;
            if ws_ret.cStat =104 then
                mdf.setRet( ws_ret.cStat, ws_ret.xMotivo,
                            ws_ret.verAplic,
                            ws_ret.Recibo ,
                            M.MDFe.procMDFe.nProt,
                            M.MDFe.procMDFe.digVal,
                            M.MDFe.procMDFe.dhRecbto
                )
            else
                mdf.setRet( ws_ret.cStat, ws_ret.xMotivo,
                        ws_ret.verAplic,
                        ws_ret.Recibo ,
                        '',
                        M.MDFe.procMDFe.digVal,
                        M.MDFe.procMDFe.dhRecbto
                );
        end
        //
        // reg. sync
        else begin
            ws_send :=m_MDFE.WebServices.Enviar ;
            if ws_send.cStat =100 then
                mdf.setRet( ws_send.cStat, ws_send.xMotivo,
                            ws_send.verAplic,
                            '' ,
                            M.MDFe.procMDFe.nProt,
                            M.MDFe.procMDFe.digVal,
                            M.MDFe.procMDFe.dhRecbto
                )
            else
                mdf.setRet( ws_send.cStat, ws_send.xMotivo,
                            ws_send.verAplic,
                            '' ,
                            '',
                            '',
                            ws_send.dhRecbto
                );
        end;
    end;
end;

function TCBaseACBrMDFe.SendMail(mdf: IManifestoDF;
  const dest_email: string): Boolean;
begin

end;

{ TRegMDFe }

procedure TRegMDFe.Load;
const
  CST_CATEGO = 'MDFE';
var
  params: TCParametroList ;
  p: TCParametro ;
  S: TStrings ;
var
  vr_doc: TpcnVersaoDF ;
//  tp_emis: TpcnTipoEmissao;
  tp_emit: TTpEmitenteMDFe;
  tp_transp: TTransportadorMDFe;
  un_med: TUnidMed;
begin

    S :=TStringList.Create ;
    //
    // cria lista vazia
    params :=TCParametroList.Create(True) ;
    try
        //
        // carrega totos params MDF-e
        params.Load('',CST_CATEGO) ;

        ver_doc.Key :='mdfe.versao_doc';
        p :=params.IndexOf(ver_doc.Key) ;
        if p = nil then
        begin
            p :=TCParametro.NewParametro(ver_doc.Key, ftArray) ;
            p.xValor:='1';
            p.Catego:=CST_CATEGO;
            P.Descricao:='Versão do documento fiscal ';
            //
            // obtem os tipos enumerados
            S.Clear;
            for vr_doc:= Low(TpcnVersaoDF) to High(TpcnVersaoDF) do
                S.Add(GetEnumName(TypeInfo(TpcnVersaoDF), Integer(vr_doc)));
            P.Comple :=S.CommaText ;
            p.Save ;
        end;
        ver_doc.Value :=p.ReadInt() ;

        amb_pro.Key :=Format('mdfe.amb_producao.%s',[CadEmp.CNPJ]) ;
        p :=params.IndexOf(amb_pro.Key) ;
        if p = nil then
        begin
            p :=TCParametro.NewParametro(amb_pro.Key, ftBoolean) ;
            p.xValor:='0';
            p.Catego:=CST_CATEGO;
            P.Descricao:='Indicador do ambiente de produção';
            p.Save ;
        end;
        amb_pro.Value :=p.ReadBoo() ;

        tip_emis.Key :=Format('mdfe.emis_normal.%s',[CadEmp.CNPJ]);
        p :=params.IndexOf(tip_emis.Key) ;
        if p = nil then
        begin
            p :=TCParametro.NewParametro(tip_emis.Key, ftBoolean) ;
            p.xValor:='0';
            p.Catego:=CST_CATEGO;
            P.Descricao:='Indicador da forma de emissão normal';
            p.Save ;
        end;
        tip_emis.Value :=p.ReadBoo() ;

        tip_emit.Key :=Format('mdfe.tip_emit.%s',[CadEmp.CNPJ]) ;
        p :=params.IndexOf(tip_emit.Key) ;
        if p = nil then
        begin
            p :=TCParametro.NewParametro(tip_emit.Key, ftArray) ;
            p.xValor:='1';
            p.Catego:=CST_CATEGO;
            P.Descricao:='Tipo do emitente por CNPJ';
            //
            // obtem os tipos enumerados
            for tp_emit:= Low(TTpEmitenteMDFe) to High(TTpEmitenteMDFe) do
                S.Add(
                    GetEnumName(TypeInfo(TTpEmitenteMDFe), Integer(tp_emit))
                    ) ;
            P.Comple :=S.CommaText ;
            p.Save ;
            S.Clear;
        end;
        tip_emit.Value :=p.ReadInt() ;

        tip_transp.Key :='mdfe.tip_transp';
        p :=params.IndexOf(tip_transp.Key) ;
        if p = nil then
        begin
            p :=TCParametro.NewParametro(tip_transp.Key, ftArray) ;
            p.xValor:='0';
            p.Catego:=CST_CATEGO;
            P.Descricao:='Tipo do transportador';
            //
            // obtem os tipos enumerados
            for tp_transp:= Low(TTransportadorMDFe) to High(TTransportadorMDFe) do
                S.Add(
                    GetEnumName(TypeInfo(TTransportadorMDFe), Integer(tp_transp))
                    ) ;
            P.Comple :=S.CommaText ;
            p.Save ;
            S.Clear;
        end;
        tip_transp.Value :=p.ReadInt() ;

        cod_und.Key :='mdfe.cod_unidmed';
        p :=params.IndexOf(cod_und.Key) ;
        if p = nil then
        begin
            p :=TCParametro.NewParametro(cod_und.Key, ftArray) ;
            p.xValor:='2';
            p.Catego:=CST_CATEGO;
            P.Descricao:='Cód.unidade de medida do Peso Bruto da Carga/Mercadorias transportadas';
            //
            // obtem os tipos enumerados
            for un_med:= Low(TUnidMed) to High(TUnidMed) do
                S.Add(
                    GetEnumName(TypeInfo(TUnidMed), Integer(un_med))
                    ) ;
            P.Comple :=S.CommaText ;
            p.Save ;
            S.Clear;
        end;
        cod_und.Value :=p.ReadInt() ;

        send_assync.Key :='mdfe.envio_assinc';
        p :=params.IndexOf(send_assync.Key) ;
        if p = nil then
        begin
            p :=TCParametro.NewParametro(send_assync.Key, ftBoolean) ;
            p.xValor:='1';
            p.Catego:=CST_CATEGO;
            P.Descricao:='Indicador envio de lote assincrono';
            p.Save ;
        end;
        send_assync.Value :=p.ReadBoo() ;


//    imp_confirm: TPair<string,Boolean>;
        imp_confirm.Key :='mdfe.imp_confirmado';
        p :=params.IndexOf(imp_confirm.Key) ;
        if p = nil then
        begin
            p :=TCParametro.NewParametro(imp_confirm.Key, ftBoolean) ;
            p.xValor:='1';
            p.Catego:=CST_CATEGO;
            P.Descricao:='Imprimir DAMDFE apos confirmado autorização de USO';
            p.Save ;
        end;
        imp_confirm.Value :=p.ReadBoo() ;

//    imp_mpreview: TPair<string,Boolean>;
        imp_mpreview.Key :='mdfe.imp_mpreview';
        p :=params.IndexOf(imp_mpreview.Key) ;
        if p = nil then
        begin
            p :=TCParametro.NewParametro(imp_mpreview.Key, ftBoolean) ;
            p.xValor:='1';
            p.Catego:=CST_CATEGO;
            P.Descricao:='Mostra previsualização do DAMDFE antes da impressão';
            p.Save ;
        end;
        imp_mpreview.Value :=p.ReadBoo() ;

//    imp_msetup: TPair<string,Boolean>;
        imp_msetup.Key :='mdfe.imp_msetup';
        p :=params.IndexOf(imp_msetup.Key) ;
        if p = nil then
        begin
            p :=TCParametro.NewParametro(imp_msetup.Key, ftBoolean) ;
            p.xValor:='0';
            p.Catego:=CST_CATEGO;
            P.Descricao:='Mostra página de setup, antes da impressão do DAMDFE';
            p.Save ;
        end;
        imp_msetup.Value :=p.ReadBoo() ;

        // ********
        // arquivos
        // ********

        arq_SaveXML.Key :='mdfe.arquivos_SaveXML';
        p :=params.IndexOf(arq_SaveXML.Key) ;
        if p = nil then
        begin
            p :=params.AddNew(arq_SaveXML.Key) ;
            p.ValTyp:=ftBoolean ;
            P.xValor :='1';
            P.Catego :=CST_CATEGO;
            p.Descricao :='Indicador SE salva arquivos XML';
            P.Save ;
        end;
        arq_SaveXML.Value :=p.ReadBoo();

        arq_SepCNPJ.Key :='mdfe.arquivos_SepCNPJ';
        p :=params.IndexOf(arq_SepCNPJ.Key) ;
        if p = nil then
        begin
            p :=params.AddNew(arq_SepCNPJ.Key) ;
            p.ValTyp:=ftBoolean ;
            P.xValor :='1';
            P.Catego :=CST_CATEGO;
            p.Descricao :='Indicador SE separa os arquivos por CNPJ';
            P.Save ;
        end;
        arq_SepCNPJ.Value :=p.ReadBoo();

        arq_SepAno.Key :='mdfe.arquivos_SepAno';
        p :=params.IndexOf(arq_SepAno.Key) ;
        if p = nil then
        begin
            p :=params.AddNew(arq_SepAno.Key) ;
            p.ValTyp:=ftBoolean ;
            P.xValor :='1';
            P.Catego :=CST_CATEGO;
            p.Descricao :='Indicador SE separa os arquivos por ANO';
            P.Save ;
        end;
        arq_SepAno.Value :=p.ReadBoo();

        arq_SepMes.Key :='mdfe.arquivos_SepMes';
        p :=params.IndexOf(arq_SepMes.Key) ;
        if p = nil then
        begin
            p :=params.AddNew(arq_SepMes.Key) ;
            p.ValTyp:=ftBoolean ;
            P.xValor :='1';
            P.Catego :=CST_CATEGO;
            p.Descricao :='Indicador SE separa os arquivos por MES';
            P.Save ;
        end;
        arq_SepMes.Value :=p.ReadBoo();

        // local
        arq_RootPath.Key :='mdfe.arquivos_RootPath';
        p :=params.IndexOf(arq_RootPath.Key) ;
        if p = nil then
        begin
            p :=params.AddNew(arq_RootPath.Key) ;
            p.ValTyp:=ftString ;
            P.xValor :=ApplicationPath + 'arquivos\DFe';
            P.Catego :=CST_CATEGO;
            p.Descricao :='Local inicio dos arquivos DFe';
            P.Save ;
        end;
        arq_RootPath.Value :=p.ReadStr();

        {arq_PathSchemas.Key :='mdfe.arquivos_PathSchemas';
        p :=params.IndexOf(arq_PathSchemas.Key) ;
        if p = nil then
        begin
            p :=params.AddNew(arq_PathSchemas.Key) ;
            p.ValTyp:=ftString ;
            P.xValor :=ApplicationPath + 'arquivos\DFe\Schemas\MDFe';
            P.Catego :=CST_CATEGO;
            p.Descricao :='Local dos arquivos de Schemas';
            P.Save ;
        end;
        arq_PathSchemas.Value :=p.ReadStr();
        }
    finally
        S.Free ;
        params.Free ;
    end;

end;

end.
