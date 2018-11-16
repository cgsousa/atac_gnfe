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
  uclass, ulog;

type
  TMySvcThread = class(TCThreadProcess)
  private
    { Private declarations }
    m_Log: TCLog;
  protected
    procedure Execute; override;
    procedure RunProc; override;
  public
    property Log: TCLog read m_Log;
    constructor Create;
    destructor Destroy; override;
    function getTerminated: Boolean ;
  end;


implementation

uses ActiveX, WinInet ,
  pcnConversao, ACBr_WinHttp ,
  uadodb, unotfis00, FDM.NFE;


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

function TMySvcThread.getTerminated: Boolean;
begin
    Result :=Self.Terminated ;

end;

procedure TMySvcThread.RunProc;
var
  nfe: Tdm_nfe;
//  N: NotaFiscal ;
  F: TNotFis00Filter;
  L: TCNotFis00Lote;
  NF: TCNotFis00;
var
  chk_status: Boolean ;
  err_db: string;
  //
  procedure ProcessConting() ;
  begin
      //
      // set contingencia
      NF.setContinge('Falha na comunicação!');
      NF.Load();
      if nfe.AddNotaFiscal(NF, True) <> nil then
      begin
          NF.setXML() ;
          m_Log.AddPar('NFE gerada em contingência') ;
      end
      else begin
          //
          // desfaz contingencia
          NF.setContinge('', True);
          m_Log.AddPar('Erro ao gerar a NFE em contingência!');
      end;
  end;
  //
begin
    //
//    m_Log.AddSec('%s.RunProc',[Self.ClassName]);
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
    except
        on E:Exception do
        begin
            m_Log.AddSec('Erro de banco: %s',[E.Message]);
            Exit ;
        end;
    end;

    nfe :=Tdm_nfe.getInstance ;
    nfe.setStatusChange(false); //desabilita status de processamento

    //
    // preenche filtro
    F.Create(0, 0);
    F.status :=sttService ;
    F.nserie :=nfe.NSerie ;

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
              m_Log.AddSec('Encontrou %d NFs´s do caixa:%.2d',[L.Items.Count,F.nserie]) ;
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

              m_Log.AddSec('Processando NF: %d [Mod:%d Ser:%.3d], Status: %d',[
                  NF.m_numdoc,NF.m_codmod,NF.m_nserie,NF.m_codstt]);

              //
              // se emissao em contingencia/offline
              if NF.m_tipemi = teContingencia then
              begin
                  //
                  // process contingencia
                  ProcessConting() ;
              end

              //
              // emissão normal, svan, etc
              else begin

                  //
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
                      if not NF.UpdateNFe(now, Ord(nfe.ProdDescrRdz), Ord(nfe.ProdCodInt), err_db) then
                      begin
                          m_Log.AddPar('Erro: '+err_db);
                          Continue ;
                      end;

                      //
                      // gera NFE
                      m_Log.AddPar('Gerando NFE ...') ;
                      if nfe.AddNotaFiscal(NF, True) = nil then
                      begin
                          m_Log.AddPar('NFE não gerada: ' +nfe.ErrMsg);
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
                  end;

                  //
                  // pronto p/ envio
                  if NF.m_codstt =TCNotFis00.CSTT_DONE_SEND then
                  begin
                      m_Log.AddPar('Enviando lote ...');
                      if nfe.OnlySend(NF) then
                      begin
                          NF.setStatus();
                          m_Log.AddPar(NF.m_motivo);
                      end
                      else begin
                          m_Log.AddPar(Format('Envio falhou: %d-%s',[nfe.ErrCod,nfe.ErrMsg]));
                          //
                          // chk erro
                          //
                          case nfe.ErrCod of
                              // http ou interno
                              // Pendente de retorno
                              408,HTTP_STATUS_SERVICE_UNAVAIL,ERROR_WINHTTP_TIMEOUT:
                              begin
                                  NF.m_codstt :=TCNotFis00.CSTT_RET_PENDENTE;
                                  NF.m_motivo :=Format('[%d]Pendente de retorno!',[nfe.ErrCod]);
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
                              ERROR_INTERNET_CONNECTION_RESET:
                              begin
                                  //
                                  // process contingencia
                                  ProcessConting() ;
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
                                  NF.m_motivo :=Format('[%d]%s', [nfe.ErrCod,nfe.ErrMsg]) ;
                                  NF.setStatus ;
                              end;

                          //
                          // erro interno
                          else
                              //
                              // se ocorrer, implementação futura !!!
                              NF.m_codstt :=nfe.ErrCod ;
                              NF.m_motivo :='Erro interno!' ;
                              NF.setStatus ;
                              //NF.m_codstt :=nfe.ErrCod ;
                              //NF.m_motivo :=Format('Erro interno|%s',[nfe.ErrMsg]) ;
                              //NF.setStatus ;
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
                      if nfe.OnlyCons(NF) then
                      begin
                          //
                          // Caso a NF não constar na base [217]
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
                              if nfe.AddNotaFiscal(NF, True) <> nil then
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
      ConnectionADO.Close ;
    end;
end;


end.
