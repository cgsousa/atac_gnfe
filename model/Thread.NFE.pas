{***
* Serviço/Thread para autorizar de forma automatica a (NF-e/NFC-e)
* Atac Sistemas
* Todos os direitos reservados
* Autor: Carlos Gonzaga
* Data: 21.03.2018
*}
unit Thread.NFE;

{*
******************************************************************************
|* PROPÓSITO: Registro de Alterações
******************************************************************************

Símbolo : Significado

[+]     : Novo recurso
[*]     : Recurso modificado/melhorado
[-]     : Correção de Bug (assim esperamos)

04.12.2018
[+] Novo parametro [conting_offline] para tratar a contingencia offline

11.07.2018
[*] A geração em contingencia/offline, agora é manual
    conforme flag notfis00(m_tipemi)

05.06.2018
[*] Checa membro notfis00(m_consumo) para controlar o consumo indevido
    (NT2018.001_v100)

24.05.2018
[*] Tratamento de erro melhorado, agora inclui erros interno(winnet)/http:

    // Pendente de retorno
    408,503,ERROR_WINHTTP_TIMEOUT

    // sem net e/ou outro erro de não comunicar
    ERROR_WINHTTP_NAME_NOT_RESOLVED,
    ERROR_WINHTTP_CANNOT_CONNECT,
    ERROR_WINHTTP_CONNECTION_ERROR,
    ERROR_INTERNET_CONNECTION_RESET

    // erro ref. a certificado
    ERROR_WINHTTP_SECURE_INVALID_CA,
    ERROR_WINHTTP_SECURE_CERT_REV_FAILED,
    ERROR_WINHTTP_SECURE_CHANNEL_ERROR,
    ERROR_WINHTTP_SECURE_FAILURE,
    ERROR_WINHTTP_CLIENT_CERT_NO_PRIVATE_KEY,
    ERROR_WINHTTP_CLIENT_CERT_NO_ACCESS_PRIVATE_KEY

*}


interface

uses SysUtils ,
  uclass, ulog, unotfis00, FDM.NFE;

type
  TMySvcThread = class(TCThreadProcess)
  private
    { Private declarations }
    m_Log: TCLog;
    m_Rep: Tdm_nfe;
    procedure runContingOffLine(NF: TCNotFis00) ;
//    procedure runNormal;
  protected
    procedure Execute; override;
    procedure RunProc; override;
  public
    property Log: TCLog read m_Log;
    constructor Create;
    destructor Destroy; override;
    //function getTerminated: Boolean ;
  end;


implementation

uses Windows, ActiveX, WinInet, DateUtils ,
  pcnConversao, ACBr_WinHttp ,
  uadodb;


{ TMySvcThread }

constructor TMySvcThread.Create;
//Create the thread Suspended so that properties can be set before resuming the thread.
begin
    inherited Create(True, False);
    m_Log :=TCLog.Create('', True) ;
    m_Log.AddSec('%s.Create',[Self.ClassName]);
    //
end;

destructor TMySvcThread.Destroy;
begin
    m_Log.Destroy ;
    inherited;
end;

procedure TMySvcThread.Execute;
begin
    m_Log.AddSec('%s.Execute',[Self.ClassName]);
    if ConnectionADO = nil then
    begin
        CoInitialize(nil);
        try
            ConnectionADO :=NewADOConnFromIniFile(
                                ExtractFilePath(ParamStr(0)) +'Configuracoes.ini'
                                ) ;
            inherited Execute;
        finally
            CoUninitialize;
        end;
    end
    else
        inherited Execute;
end;

procedure TMySvcThread.runContingOffLine(NF: TCNotFis00) ;
begin
{
                      //
                      // so atualiza a NF, se, e somente se,
                      // o mes/ano forem os mesmos de emissão
                      if(YearOf(dt_serv)  =YearOf(NF.m_dtemis))and
                        (MonthOf(dt_serv) =MonthOf(NF.m_dtemis))then
                      begin
                          //
                          // caso não consiga atualiza a NF
                          // reporta o erro e vai para a proxima NF
                          if not NF.UpdateNFe(now, Ord(m_Rep.ProdDescrRdz), Ord(m_Rep.ProdCodInt), err_db) then
                          begin
                              m_Log.AddPar('Erro: '+err_db);
                              Continue ;
                          end;
                      end;
}


    //
    // set contingencia
    NF.setContinge('Falha na comunicação!');
    NF.Load();
    if m_Rep.AddNotaFiscal(NF, True) <> nil then
    begin
        NF.setXML() ;
        if NF.m_codmod = 55 then
        begin
            m_Log.AddPar('NFE gerada com sucesso') ;
        end
        //NFCe
        else begin
            m_Log.AddPar('NFCe gerada com sucesso') ;
        end;
        m_Log.AddPar(Format('chave: %s',[NF.m_chvnfe])) ;
    end
    else begin
        //
        // desfaz contingencia
        NF.setContinge('', True);
        m_Log.AddPar('Erro ao gerar a NFE em contingência!');
    end;
end;

procedure TMySvcThread.RunProc;
var
//  nfe: Tdm_nfe;
//  N: NotaFiscal ;
  F: TNotFis00Filter;
  L: TCNotFis00Lote;
  NF: TCNotFis00;
var
  chk_status: Boolean ;
  err_db: string;
  dt_serv: TDateTime;
begin
    //
    // m_Log.AddSec('%s.RunProc',[Self.ClassName]);
    //
    try
        ConnectionADO.Connected :=True ;
        //m_Log.AddSec(TADOQuery.getVersion);
        if Empresa = nil then
        begin
            Empresa :=TCEmpresa.Instance ;
            Empresa.DoLoad(1);
            m_Log.AddSec('Emitente: %s-%s',[Empresa.CNPJ,Empresa.RzSoci]);
        end;
        //
        // ler data/hora do servidor
        dt_serv :=TADOQuery.getDateTime ;
    except
        on E:Exception do
        begin
            m_Log.AddSec('Erro de banco: %s',[E.Message]);
            Exit ;
        end;
    end;

    m_Rep :=Tdm_nfe.getInstance ;
    m_Rep.setStatusChange(false); //desabilita status de processamento

    //
    // preenche filtro
    F.Create(0, 0);
    F.filTyp :=ftService ;
    //F.status :=sttService ;
    //F.codmod :=m_Rep.CodMod ;
    F.nserie :=m_Rep.NSerie ;

    //
    // cria o lote
    L :=TCNotFis00Lote.Create ;
    try
      //
      // carrega conforme filtro
      if L.Load(F) then
      begin
          //
          // X notas encontradas
          if L.Items.Count > 1 then
          begin
              m_Log.AddSec('Carregou %d NF(s) da serie:%.3d',[L.Items.Count,F.nserie]) ;
          end;

          //
          // loop para processamento
          for NF in L.Items do
          begin

              //
              // força proxima NF
              //

              //
              // se processada ou cancelada
              if NF.CStatProcess or NF.CstatCancel then
              begin
                  Continue ;
              end;

              //
              // se consumo indevido atingiu o limite
              if NF.m_consumo >=TCNotFis00.QTD_MAX_CONSUMO then
              begin
                  m_Log.AddSec('NF:%d não pode ser processada! [QTD_MAX_CONSUMO >= %d]',[
                  NF.m_numdoc,NF.m_consumo]);
                  Continue ;
              end;

              //
              // se ja foi gerada em Contingencia/OffLine
              if(NF.m_codstt =TCNotFis00.CSTT_EMIS_CONTINGE)and
                (NF.m_dhcont > 0)and(NF.m_chvnfe <>'') then
              begin
                  Continue ;
              end;

              //
              // check se flag Contingencia/OffLine esta ativa
              if m_Rep.Parametro.conting_offline.Value then
              begin
                  //
                  // NF não processada, pronta para envio
                  // e ou com erros geral
                  if NF.m_codstt = 0 then
                  begin
                      m_Log.AddSec('Processando NF: %d [Mod:%d Ser:%.3d], Status: %d em contingência offline',[
                      NF.m_numdoc,NF.m_codmod,NF.m_nserie,NF.m_codstt]);
                      //
                      // emissão em contingência offline
                      runContingOffLine(NF) ;
                  end;
              end

              //
              // emissão normal, svan, etc
              else begin

                  m_Log.AddSec('Processando NF: %d [Mod:%d Ser:%.3d], Status: %d',[
                  NF.m_numdoc,NF.m_codmod,NF.m_nserie,NF.m_codstt]);

                  //
                  // NF criada com a sp_notfis00_add (nf0_codss=0) e/ou
                  // Rejeição 704: NFC-E com data-hora de emissão atrasada
                  if(NF.m_codstt =0)or(NF.m_codstt =704) then
                  begin
                      m_Log.AddPar('Atualizando NF ...') ;
                      //
                      // caso não consiga atualiza a NF
                      // reporta o erro e vai para a proxima NF
                      if not NF.UpdateNFe(now, Ord(m_Rep.ProdDescrRdz), Ord(m_Rep.ProdCodInt), err_db) then
                      begin
                          m_Log.AddPar('Erro: '+err_db);
                          Continue ;
                      end;

                      //
                      // gera NFE
                      m_Log.AddPar('Gerando NFE ...') ;
                      if m_Rep.AddNotaFiscal(NF, True) = nil then
                      begin
                          m_Log.AddPar('NFE não gerada: ' +m_Rep.ErrMsg);
                          //
                          // caso não for gerada!
                          // força para a proxima nota
                          Continue ;
                      end;

                      //
                      // grava xml/chave/status
                      NF.setXML();
                      //
                      m_Log.AddPar(Format('%s, chave: %s',[NF.m_motivo,NF.m_chvnfe]));
                  end;

                  {//
                  // NF criada (sp_notfis00_add) ou com erros
                  if(not (NF.m_codstt in[TCNotFis00.CSTT_DONE_SEND,
                                        TCNotFis00.CSTT_EMIS_CONTINGE,
                                        TCNotFis00.CSTT_RET_PENDENTE,
                                        TCNotFis00.CSTT_DUPL]))or
                    (not (NF.m_codstt =TCNotFis00.CSTT_DUPL_DIF_CHV))or
                    (not (NF.m_codstt =TCNotFis00.CSTT_CHV_DIF_BD  ))then
                  begin
                      m_Log.AddPar('Atualizando NF ...') ;
                      //
                      // caso não consiga atualiza a NF
                      // reporta o erro e vai para a proxima NF
                      if not NF.UpdateNFe(now, Ord(m_Rep.ProdDescrRdz), Ord(m_Rep.ProdCodInt), err_db) then
                      begin
                          m_Log.AddPar('Erro: '+err_db);
                          Continue ;
                      end;

                      //
                      // gera NFE
                      m_Log.AddPar('Gerando NFE ...') ;
                      if m_Rep.AddNotaFiscal(NF, True) = nil then
                      begin
                          m_Log.AddPar('NFE não gerada: ' +m_Rep.ErrMsg);
                          //
                          // força para a proxima nota,
                          // caso não for gerada!
                          Continue ;
                      end;

                      //
                      // grava xml e status qdo não for contingencia
                      NF.setXML();
                      //
                      m_Log.AddPar('NFE gerada, chave: '+NF.m_chvnfe);
                  end;}

                  //
                  // pronto p/ envio (nf0_codss=1) e/ou
                  // Rejeição 217: NFe não consta na base de dados
                  if NF.m_codstt in[TCNotFis00.CSTT_DONE_SEND,TCNotFis00.CSTT_NFE_NAO_CONSTA] then
                  begin
                      m_Log.AddPar('Enviando lote ...');
                      if m_Rep.OnlySend(NF) then
                      begin
                          NF.setStatus();
                          m_Log.AddPar(NF.m_motivo);
                      end
                      else begin
                          m_Log.AddPar(Format('Envio falhou: %d-%s',[m_Rep.ErrCod,m_Rep.ErrMsg]));
                          //
                          // chk erro
                          //
                          case m_Rep.ErrCod of
                              // http ou interno
                              // Pendente de retorno
                              408,HTTP_STATUS_SERVICE_UNAVAIL,10060,10091,ERROR_WINHTTP_TIMEOUT:
                              begin
                                  NF.m_codstt :=TCNotFis00.CSTT_RET_PENDENTE;
                                  NF.m_motivo :=Format('[%d]Pendente de retorno!',[m_Rep.ErrCod]);
                                  NF.setStatus ;
                                  m_Log.AddPar(NF.m_motivo);
                              end;

                              //
                              // processa a contingencia, se, e somente se,
                              // o erro interno não for ref. a certificado
                              HTTP_STATUS_SERVER_ERROR,
                              HTTP_STATUS_BAD_GATEWAY,
                              HTTP_STATUS_GATEWAY_TIMEOUT,
                              HTTP_STATUS_VERSION_NOT_SUP,
                              ERROR_WINHTTP_NAME_NOT_RESOLVED,
                              ERROR_WINHTTP_CANNOT_CONNECT,
                              ERROR_WINHTTP_CONNECTION_ERROR,
                              ERROR_INTERNET_CONNECTION_RESET,
                              ERROR_SERVICE_DOES_NOT_EXIST:
                              begin
                                  //
                                  // process contingencia
                                  runContingOffLine(NF) ;
                              end;

                              //
                              // erro de certificado
                              //
                              ERROR_WINHTTP_SECURE_INVALID_CA,
                              ERROR_WINHTTP_SECURE_CERT_REV_FAILED,
                              ERROR_WINHTTP_SECURE_CHANNEL_ERROR,
                              ERROR_WINHTTP_SECURE_FAILURE,
                              ERROR_WINHTTP_CLIENT_CERT_NO_PRIVATE_KEY,
                              ERROR_WINHTTP_CLIENT_CERT_NO_ACCESS_PRIVATE_KEY:
                              begin
                                  NF.m_codstt :=55 ;
                                  NF.m_motivo :=Format('[%d]%s', [m_Rep.ErrCod,m_Rep.ErrMsg]) ;
                                  NF.setStatus ;
                              end;

                          //
                          // erro interno
                          else
                              //
                              // se ocorrer, implementação futura !!!
                              NF.m_codstt :=m_Rep.ErrCod ;
                              NF.m_motivo :=Format('Erro interno[%d|%s]',[m_Rep.ErrCod,m_Rep.ErrMsg]) ;
                              NF.setStatus ;
                          end;
                      end;
                  end;

                  //
                  // consulta protocolo
                  //
                  if(NF.m_codstt =TCNotFis00.CSTT_DUPL        )or
                    (NF.m_codstt =TCNotFis00.CSTT_DUPL_DIF_CHV)or
                    (NF.m_codstt =TCNotFis00.CSTT_CHV_DIF_BD  )or
                    (NF.m_codstt =TCNotFis00.CSTT_RET_PENDENTE)then
                  begin

                      m_Log.AddPar('Consulta protocolo ...');
                      if m_Rep.OnlyCons(NF) then
                      begin
                          //
                          // Caso a NF não constar na base [217],
                          // sera processada no proximo lote !
                          NF.setStatus();
                          m_Log.AddPar(NF.m_motivo);

                          //
                          // se NF ja existe com dif. de chave
                          // reset. contingencia
                          if(NF.m_codstt =TCNotFis00.CSTT_CHV_DIF_BD)and
                          ((NF.m_tipemi =teContingencia)or(NF.m_tipemi =teOffLine))then
                          begin
                              m_Log.AddPar('Desfaz contingência...');
                              NF.setContinge('', True);
                              if m_Rep.AddNotaFiscal(NF, True) <> nil then
                              begin
                                  NF.setXML() ;
                              end ;
                          end;
                      end
                      else begin
                          m_Log.AddPar('Erro ao consultar protocolo!');
                      end;

                  end;

              end;

          end;
      end;

    finally
      L.Free ;
      Tdm_nfe.doFreeAndNil;
      m_Rep :=nil;
      ConnectionADO.Close ;
    end;
end;


end.
