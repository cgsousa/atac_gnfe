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

19.07.2019
[*] O metodo TMySvcThread.RunProc chama 2(dois):
      TMySvcThread.doRunService => serviço
      TMySvcThread.doRunFech    => fechamento do caixa
    Para melhor peformance/manutenção

08.07.2019
[*] Inclui NF em contingencia para ser processada no serviço

05.06.2019
[*] Tratamento do campo <nf0_xmltyp> para gravar o xml em formato apropriado
[*] Vincula NFe ao lote <nf0_codlot> para não ser processada no serviço

23.05.2019
[*] Removido controle de LOG, chama externa de CallOnStrProc(...)

30.01.2019
[+] Novos métodos para sincronizar com a view (Form.ViewSvc.*):
    CallOnCertif() para info do cetificado;
    CallOnContingOffLine() para info do parametro <conting_offline>.

09.01.2019
[+] Condição de checagem da data de vencimento do certificado

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
  uclass, uACBrNFE, unotfis00,
  ACBrNFeNotasFiscais;

type
  TGetCertifProc = procedure(const aCNPJ: String; const aDays: Word) of object;
  TMySvcThread = class(TCThreadProcess)
  private
    { Private declarations }
    m_Rep: IBaseACBrNFE ;
    m_Filter: TNotFis00Filter ;
    m_Lote: TCNotFis00Lote;
    m_CodMod: Word;
    m_reg: TRegNFE ;

    function TrataRetAssync(): Integer ;

    procedure TrataRetFair(NF: TCNotFis00) ;
    procedure TrataRetComDupl(NF: TCNotFis00) ;

    procedure ProcContingOff(N: TCNotFis00) ;
    procedure ProcAsync(const aCodLot: Integer) ;

    procedure doRunService ;
    procedure doRunFech ;

  private
    m_OnCertif: TGetCertifProc;
    m_OnBooProc: TGetBooProc;
    m_AlertCount: Word ;
    procedure CallOnCertif(const aCNPJ: string; const aDays: Word);
    procedure CallOnContingOffLine(const aFlag: Boolean);
  protected
    procedure Execute; override;
    procedure RunProc; override;
    procedure RunProc00;
  public
    //property Log: TCLog read m_Log;

    property OnCertif: TGetCertifProc
        read m_OnCertif
        write m_OnCertif;

    property OnBooProc: TGetBooProc
        read m_OnBooProc
        write m_OnBooProc;

    constructor Create(const aFilter: TNotFis00Filter);
    destructor Destroy; override;
  end;


implementation

uses Windows, ActiveX, WinInet, DateUtils, DB,
  pcnConversao, pcnNFe, pcnRetConsReciDFe,
  ACBr_WinHttp, ACBrUtil, ACBrNFeWebServices,
  uadodb, ucademp, uparam;


{ TMySvcThread }

procedure TMySvcThread.CallOnCertif(const aCNPJ: string; const aDays: Word);
begin
    if GetCurrentThreadId = MainThreadID then
    begin
        if Assigned(m_OnCertif) then
            m_OnCertif(aCNPJ, aDays);
    end
    else begin
        Synchronize(
            procedure
            begin
                CallOnCertif(aCNPJ, aDays);
            end);
    end;
end;

procedure TMySvcThread.CallOnContingOffLine(const aFlag: Boolean);
begin
    if GetCurrentThreadId = MainThreadID then
    begin
        if Assigned(m_OnBooProc) then
            m_OnBooProc(aFlag);
    end
    else begin
        Synchronize(
            procedure
            begin
                CallOnContingOffLine(aFlag);
            end);
    end;
end;

constructor TMySvcThread.Create(const aFilter: TNotFis00Filter);
//Create the thread Suspended so that properties can be set before resuming the thread.
begin
    m_Filter :=aFilter  ;
    inherited Create(True, False);
//    m_Log :=TCLog.Create('', True) ;
//    m_Log.AddSec('%s.Create',[Self.ClassName]);
    //
    m_Lote :=TCNotFis00Lote.Create ;
end;

destructor TMySvcThread.Destroy;
begin
//    m_Log.Destroy ;
    m_Lote.Destroy ;
    inherited;
end;

procedure TMySvcThread.doRunFech;
var
  NF: TCNotFis00;
  nfe: NotaFiscal;
var
  S: string;
  codlot,retAssyncDuplCount: Integer;
  send: Boolean;
var
  cs: NotFis00CodStatus;
begin

    //
    // chk filtro
    if m_Filter.codmod < 55 then
    begin
        m_Filter.codmod :=55 ;
        m_CodMod :=m_Filter.codmod ;
    end
    //
    //
    else begin
        if m_CodMod > 0 then
            m_Filter.codmod :=65 ;
    end;
    //CallOnStrProc('Carregando Notas Fiscais (Mod:%d, Ser:%d)',[m_Filter.codmod,m_Filter.nserie]);

    //
    // carrega conforme filtro
    if m_Lote.Load(m_Filter) then
    begin

        //
        // inicializa lote
        codLot :=0;
        retAssyncDuplCount :=0;
        m_Rep.nfe.NotasFiscais.Clear ;

        //
        // loop para processamento
        for NF in m_Lote.Items do
        begin
            if Self.Terminated then Break ;

            //
            // força proxima NF
            //
            nfe :=nil ;

            //
            // NF processada
            if NF.CStatProcess then
            begin
                CallOnStrProc('NF:%d [Mod:%d Ser:%.3d], já processada',
                              [NF.m_numdoc,NF.m_codmod,NF.m_nserie]);
                // proxima NF
                Continue ;
            end;

            //
            // NF cancelada
            if NF.CstatCancel then
            begin
                CallOnStrProc('NF:%d [Mod:%d Ser:%.3d], cancelada!',
                              [NF.m_numdoc,NF.m_codmod,NF.m_nserie]);
                // proxima NF
                Continue ;
            end;

            //
            //
            if NF.m_codstt =cs.CONTING_OFFLINE then
            begin
                //
                // carrega XML
                if NF.LoadXML then
                begin
                    //
                    // add nfe com base no XML
                    nfe :=m_Rep.AddNotaFiscal(nil, False) ;
                    nfe.LerXML(NF.m_xml) ;
                end
                else begin
                    //
                    // força XML
                    nfe :=m_Rep.AddNotaFiscal(NF, False) ;
                    if nfe <> nil then
                    begin
                        //
                        // registra status/xml/chave
                        NF.setXML();
                        CallOnStrProc(#9'%s, chave: %s',[NF.m_motivo,NF.m_chvnfe]);
                    end
                    else begin
                        //
                        // reporta o erro
                        CallOnStrProc(#9'NFE não gerada: ' +m_Rep.ErrMsg);
                        //
                        // força para a proxima nota
                        Continue ;
                    end;
                end;
            end;

            //
            //
            if(NF.m_codstt =cs.ERR_SCHEMA)or
              (NF.m_codstt =cs.ERR_REGRAS)or
              (NF.m_codstt =cs.ERR_GERAL )or
              (NF.m_codstt =cs.NFE_NAO_CONSTA_BD )or
              (NF.m_codstt =cs.NFCE_DH_EMIS_RETRO)then
            begin
                CallOnStrProc(#9'Atualizando...');
                if NF.UpdateNFe(now, Ord(m_Rep.param.xml_prodescri_rdz.Value), Ord(m_Rep.param.xml_procodigo_int.Value), S) then
                    NF.Load()
                else begin
                    CallOnStrProc(S);
                    Continue ;
                end ;

                //
                // gera NFE
                CallOnStrProc(#9'Gerando NFE ...') ;
                nfe :=m_Rep.AddNotaFiscal(NF, False) ;
                if nfe <> nil then
                begin
                    //
                    // registra status/xml/chave
                    NF.setXML();
                    CallOnStrProc(#9'%s, chave: %s',[NF.m_motivo,NF.m_chvnfe]);
                end
                else begin
                    //
                    // reporta o erro
                    CallOnStrProc(#9'NFE não gerada: ' +m_Rep.ErrMsg);
                    //
                    // força para a proxima nota
                    Continue ;
                end;
            end;

            //
            // valida repositorio
            if NF.m_codstt =cs.ERR_SCHEMA then
            begin
                m_Rep.nfe.NotasFiscais.Delete(nfe.Index);
            end;

            //
            // inicializa lote para posterior envio
            if(codLot = 0)and(m_Rep.nfe.NotasFiscais.Count >0) then
            begin
                codlot :=NF.m_codseq;
            end ;

            //
            // consulta protocolo
            //
            if(retAssyncDuplCount > 0)or
              (NF.m_codstt =cs.RET_PENDENTE)or
              (NF.m_codstt =cs.DUPL)or
              (NF.m_codstt =cs.LOT_EM_PROCESS)then
            begin
                //
                //
                TrataRetComDupl(NF);
            end;

        end; // fim do for

        //
        // existe lote pra envio
        if(codlot > 0)then
        begin
            //
            // envio lote
            CallOnStrProc(#9'Enviando lote[%d] Assync',[codlot]);
            send :=m_Rep.OnlySendAssync(codlot);
            if send then
            begin
                retAssyncDuplCount :=TrataRetAssync ;
            end
            //
            // trata retorno com erros
            else begin
                //
                // alert falha
                CallOnStrProc(#9'Envio falhou: %d-%s',[m_Rep.ErrCod,m_Rep.ErrMsg]);
                TrataRetFair(nil);
            end;
        end;
    end

    //
    // mostra msg conforme filtro
    else begin
        //
        // alert
        CallOnStrProc('Nenhuma NF encontrada!');
        //
        // se ja processou todos os modelos do CX
        if((m_CodMod > 0)and(m_Filter.codmod =65))or
          ( m_CodMod =00)then
        begin
            //
            // termina tarefa
            Self.Terminate ;
        end ;
    end;
end;

procedure TMySvcThread.doRunService;
var
  NF: TCNotFis00;
  nfe: NotaFiscal;
var
  S: string;
  retAssyncDuplCount: Integer;
  send: Boolean;
var
  cs: NotFis00CodStatus ;
begin

    //
    // chk filtro
    m_Filter.nserie :=m_Rep.nSerie;
    //m_Filter.save :=True;

    //
    // atualiza a view
    m_reg.loadContingOffLine ;
    CallOnContingOffLine(m_reg.conting_offline.Value);
    //
    //CallOnStrProc('Carregando Notas Fiscais (Ser:%d)',[m_Filter.nserie]);

    //
    // carrega conforme filtro
    if m_Lote.Load(m_Filter) then
    begin
        //
        // loop para processamento
        for NF in m_Lote.Items do
        begin
            if Self.Terminated then Break ;

            //
            // força proxima NF
            //

            //
            // NF processada
            if NF.CStatProcess then
            begin
                CallOnStrProc('NF:%d [Mod:%d Ser:%.3d], já processada',
                              [NF.m_numdoc,NF.m_codmod,NF.m_nserie]);
                // proxima NF
                Continue ;
            end;

            //
            // NF cancelada
            if NF.CstatCancel then
            begin
                CallOnStrProc('NF:%d [Mod:%d Ser:%.3d], cancelada!',
                              [NF.m_numdoc,NF.m_codmod,NF.m_nserie]);
                // proxima NF
                Continue ;
            end;

            //
            // alert para consumo indevido
            if NF.m_codstt =cs.ERR_CONSUMO_INDEVIDO then
            begin
                CallOnStrProc('NF:%d [Mod:%d Ser:%.3d]| %d:%s',[
                  NF.m_numdoc,NF.m_codmod,NF.m_nserie,NF.m_codstt,NF.m_motivo]);
                // proxima NF
                Continue ;
            end;

            //
            // chk se ja foi gerada em Contingencia/Off
            if(NF.m_codstt =TCNotFis00.CSTT_EMIS_CONTINGE)and
              (NF.m_dhcont > 0)and(NF.m_chvnfe <>'') then
            begin
                // se NÃO process NF em contingencia
                m_reg.loadSendConting ;
                if not m_reg.send_conting.Value then
                    Continue ;
            end;

            //
            // NF vinculada ao lote
            if(NF.m_codlot > 0)then
            begin
                CallOnStrProc('NF:%d [Mod:%d Ser:%.3d], Vinculada ao lote[%d]',[
                  NF.m_numdoc,NF.m_codmod,NF.m_nserie,NF.m_codstt,NF.m_codlot]);
                Continue ;
            end;

            //
            // emissão em contingencia Off
            if m_reg.conting_offline.Value then
            begin
                //
                // libera o CX para NF não processada
                if NF.m_codstt = 0 then
                begin
                    //
                    // emissão em contingência offline
                    ProcContingOff(NF);
                end;
            end

            //
            // emissão (normal, svan, svrs)
            else begin
                //
                // NF não processada;
                // NF com erro de schema;
                // NF com erro nas regras de validação;
                // Rejeição 217: NFe não consta na base de dados;
                // Rejeição 704: NFC-E com data-hora de emissão atrasada;
                // Rejeição 999:  erro geral sefaz
                if(NF.m_codstt in[0,cs.ERR_SCHEMA,cs.ERR_REGRAS,cs.NFE_NAO_CONSTA_BD])or
                  (NF.m_codstt =cs.NFCE_DH_EMIS_RETRO)or
                  (NF.m_codstt =cs.ERR_GERAL)then
                begin
                    //
                    //
                    CallOnStrProc('Atualizando NF: %d [Mod:%d Ser:%.3d], Status: %d',[
                    NF.m_numdoc,NF.m_codmod,NF.m_nserie,NF.m_codstt]);

                    //
                    // caso não consiga atualiza a NF
                    // reporta o erro e vai para a proxima NF
                    if not NF.UpdateNFe(now, Ord(m_Rep.param.xml_prodescri_rdz.Value), Ord(m_Rep.param.xml_procodigo_int.Value), S) then
                    begin
                        CallOnStrProc(#9'Erro: '+S);
                        Continue ;
                    end;

                    //
                    // gera NFE
                    CallOnStrProc(#9'Gerando NFE ...') ;
                    nfe :=m_Rep.AddNotaFiscal(NF, True) ;
                    if nfe <> nil then
                    begin
                        //
                        // registra status/xml/chave
                        NF.setXML();
                        //
                        // reporta upd
                        CallOnStrProc(#9'%s, chave: %s',[NF.m_motivo,NF.m_chvnfe]);

                    end
                    else begin
                        //
                        // reporta o erro
                        CallOnStrProc(#9'NFE não gerada: ' +m_Rep.ErrMsg);
                        //
                        // força para a proxima nota
                        Continue ;
                    end;
                end
                else
                    nfe :=nil;

                //
                // pronto p/ envio (nf0_codstt=1)
                // contingencia off (nf0_codstt=9)
                if NF.m_codstt in[cs.DONE_SEND,cs.CONTING_OFFLINE]then
                begin
                    //
                    // chk nfe no repositorio
                    if nfe = nil then
                    begin
                        //
                        // carrega XML
                        if NF.LoadXML then
                        begin
                            //
                            // add nfe com base no XML
                            nfe :=m_Rep.AddNotaFiscal(nil, True) ;
                            nfe.LerXML(NF.m_xml) ;
                        end
                        else begin
                            //
                            // força XML
                            nfe :=m_Rep.AddNotaFiscal(NF, True) ;
                            if nfe <> nil then
                            begin
                                //
                                // registra status/xml/chave
                                NF.setXML();
                                CallOnStrProc(#9'%s, chave: %s',[NF.m_motivo,NF.m_chvnfe]);
                            end
                            else begin
                                //
                                // reporta o erro
                                CallOnStrProc(#9'NFE não gerada: ' +m_Rep.ErrMsg);
                                //
                                // força para a proxima nota
                                Continue ;
                            end;
                        end;
                    end;

                    //
                    // envio sincrono
                    if m_Rep.param.send_lotsync.Value then
                    begin
                        CallOnStrProc('Enviando lote[%d] Sync',[NF.m_codseq]);
                        send :=m_Rep.OnlySendSync(NF) ;
                    end
                    //
                    // envio assincrono
                    else begin
                        CallOnStrProc('Enviando lote[%d] Assync',[NF.m_codseq]);
                        send :=m_Rep.OnlySendAssync(NF.m_codseq);
                    end;

                    //
                    // trata retorno com sucesso
                    if send then
                    begin
                        //
                        // retorno sync
                        if m_Rep.param.send_lotsync.Value then
                        begin
                            // registra retorno
                            NF.setStatus();
                            // reporta motivo
                            CallOnStrProc(#9+NF.m_motivo);
                        end
                        //
                        // retorno assync
                        else begin
                            retAssyncDuplCount :=TrataRetAssync ;
                            if retAssyncDuplCount > 0 then
                              TrataRetComDupl(NF);
                        end;
                    end
                    //
                    // trata retorno sem sucesso
                    else begin
                        //
                        // alert falha
                        CallOnStrProc(#9'Envio falhou: %d-%s',[m_Rep.ErrCod,m_Rep.ErrMsg]);
                        TrataRetFair(NF);
                    end;
                end;

                //
                // consulta protocolo
                //
                if(retAssyncDuplCount > 0)or
                  (NF.m_codstt =cs.RET_PENDENTE)or
                  (NF.m_codstt =cs.DUPL)or
                  (NF.m_codstt =cs.LOT_EM_PROCESS)then
                begin
                    //
                    //
                    TrataRetComDupl(NF);
                end;
            end;

        end;
        //
        //
    end;
end;

procedure TMySvcThread.Execute;
begin
    CallOnStrProc('%s.Execute',[Self.ClassName]);
    m_CodMod :=0 ;
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
    m_AlertCount :=0;
end;


procedure TMySvcThread.ProcAsync(const aCodLot: Integer) ;
var
  dupl,I: Integer;
  nfe: TNFe;
  N: TCNotFis00;
begin
    dupl :=0 ;

    CallOnStrProc('Enviando lote:%d',[aCodLot]);

    //
    // envio
    //
    if m_Rep.OnlySend(aCodLot) then
    begin
        //
        // lote processado
        //
        if m_Rep.nfe.WebServices.Retorno.NFeRetorno.cStat =TCNotFis00.CSTT_PROCESS then
        begin
            //
            // lopp para update cada nfe
            //
            for I :=0 to m_Rep.nfe.NotasFiscais.Count -1 do
            begin
                nfe :=m_Rep.nfe.NotasFiscais.Items[I].NFe ;
                N :=m_Lote.IndexOf(OnlyNumber(NFe.infNFe.ID) ) ;
                if N <> nil then
                begin

                    //
                    // atualiza status
                    CallOnStrProc(#9'Atualizando NFE[%s]',[N.m_chvnfe]);
                    N.m_codstt :=nfe.procNFe.cStat ;
                    N.m_motivo :=nfe.procNFe.xMotivo;
                    N.m_verapp :=nfe.procNFe.verAplic;
                    N.m_dhreceb:=nfe.procNFe.dhRecbto;
                    N.m_numreci:=m_Rep.nfe.WebServices.Retorno.NFeRetorno.nRec ;
                    N.m_numprot:=nfe.procNFe.nProt ;
                    N.m_digval :=nfe.procNFe.digVal;
                    CallOnStrProc(#9'%d|%s',[N.m_codstt,N.m_motivo]);
                    N.setStatus ;

                    //
                    // se duplicidade
                    if(N.m_codstt =TCNotFis00.CSTT_DUPL)or
                      (N.m_codstt =TCNotFis00.CSTT_DUPL_DIF_CHV)then
                    begin
                        N.Checked :=True ;
                        Inc(dupl) ;
                    end;

                end;
                if Terminated then Exit;
            end;
        end ;
        CallOnStrProc(#9'%d|%s',[m_Rep.nfe.WebServices.Retorno.NFeRetorno.cStat,m_Rep.nfe.WebServices.Retorno.NFeRetorno.xMotivo]);

        //
        // check NF com duplicidade
        // para consulta de protocolo
        if dupl > 0 then
        begin
            CallOnStrProc('%d nota(s) com duplicidade!',[dupl]);

            for N in m_Lote.Items do
            begin
                if N.Checked then
                begin
                    CallOnStrProc(#9'Consulta protocolo NFE[:%s]',[N.m_chvnfe]);
                    //
                    // Rejeição 204: duplicidade de chave
                    if m_Rep.OnlyCons(N) then
                    begin
                        //
                        // status 100: autorizado o uso
                        if N.m_codstt =TCNotFis00.CSTT_AUTORIZADO_USO then
                            N.setStatus()
                        else begin
                            //
                            // Rejeição 613:
                            // Chave de Acesso difere da existente em BD (WS_CONSULTA)
                            // reset. contingencia
                            if(N.m_codstt =TCNotFis00.CSTT_CHV_DIF_BD)and
                              ((N.m_tipemi =teContingencia)or(N.m_tipemi =teOffLine))then
                            begin
                                CallOnStrProc(#9'Desfazendo contingência (NFE:%s)',[N.m_chvnfe]);
                                N.setContinge('', True);
                                N.Load() ;
                                if m_Rep.AddNotaFiscal(N, True) <> nil then
                                begin
                                    N.setXML() ;
                                    //
                                    //
                                    CallOnStrProc(#9'Consultando protocolo (NFE:%s)',[N.m_chvnfe]);
                                    if m_Rep.OnlyCons(N) then
                                    begin
                                        N.setStatus();
                                    end ;
                                end ;
                            end;
                        end;
                    end;
                end;
                if Terminated then Exit;
            end;
        end;
    end
    else
        CallOnStrProc(m_Rep.ErrMsg) ;
end;

procedure TMySvcThread.ProcContingOff(N: TCNotFis00) ;
var
  S: string ;
begin
    //
    // format alert conting
    S :=Format(#9'Gerando NF:%d [Mod:%d Ser:%.3d], Status: %d em contingência',
              [N.m_numdoc,N.m_codmod,N.m_nserie,N.m_codstt]);
    if m_reg.conting_offline.Value then
    begin
        S :=S +' offline!';
    end;
    CallOnStrProc(S);

    //
    // set motivo
    N.setContinge('Falha na comunicação!');
    if N.Load() then
    begin
        if m_Rep.AddNotaFiscal(N, True) <> nil then
        begin
            N.setXML() ;
            if N.m_codmod = 55 then S:=#9'NFE[%s] gerada com sucesso'
            else                    S:=#9'NFCe[%s] gerada com sucesso';
            CallOnStrProc(S,[N.m_chvnfe]) ;
        end
        else begin
            //
            // desfaz contingencia
            N.setContinge('', True);
            CallOnStrProc(#9'Erro ao gerar em contingência!');
        end;
    end
    else
        CallOnStrProc(#9'Não foi possível carregar NF!');
end;

procedure TMySvcThread.RunProc;
begin
    //
    // chk conn
    //
    if not ConnectionADO.Connected then
    begin
        ConnectionADO.Connected :=True;
        if Empresa = nil then
        begin
            Empresa :=TCEmpresa.Instance;
            Empresa.DoLoad(1);
            //CallOnStrProc('Emitente: %s-%s',[Empresa.CNPJ,Empresa.RzSoci]);
        end;
        if CadEmp = nil then
        begin
            CadEmp :=TCCadEmp.New(1) ;
            CallOnStrProc('Emitente: %s-%s',[CadEmp.CNPJ,CadEmp.xNome]);
        end;
    end;

    try
      //
      // simula o singleton
      if m_Rep =nil then
      begin
          // (aStatusChange =false) desabilita status de processamento
          m_Rep :=TCBaseACBrNFE.New(False) ;

          //
          // check validade do certificado
          if m_Rep.getDaysUseCertif <= 7 then
          begin
              if(m_AlertCount =0)or(m_Interval >= MSecsPerDay div HoursPerDay) then
              begin
                  //
                  // sincroniza o alert aqui
                  CallOnCertif(m_Rep.nfe.SSL.CertCNPJ, m_Rep.getDaysUseCertif);
                  //
                  // reset o intervalo
                  m_Interval :=0 ;
                  Inc(m_AlertCount);
              end;

              //
              // caso o certificado venceu, termina a thread
              if m_Rep.getDaysUseCertif <= 0 then
              begin
                  CallOnStrProc('Certificado vinculado ao CNPJ:%s já venceu!',[CadEmp.CNPJ]);
                  Self.Terminate ;
                  Exit;
              end;
          end;
      end;
      m_reg :=m_Rep.param ;

      //
      // prepare
      case m_Filter.filTyp of
          ftService: doRunService ;
          ftFech: doRunFech ;
      end;

    finally
      m_Lote.Items.Clear ;
      if m_Filter.filTyp =ftService then
          ConnectionADO.Close ;
    end ;
end;


procedure TMySvcThread.RunProc00;
var
  NF: TCNotFis00;
  nfe: NotaFiscal;
var
  S: string;
  codlot,retAssyncDuplCount: Integer;
  send: Boolean;
var
  cs: NotFis00CodStatus ;
begin
    //
    // m_Log.AddSec('%s.RunProc',[Self.ClassName]);
    //
    if not ConnectionADO.Connected then
    begin
        ConnectionADO.Connected :=True;
        if Empresa = nil then
        begin
            Empresa :=TCEmpresa.Instance;
            Empresa.DoLoad(1);
            //CallOnStrProc('Emitente: %s-%s',[Empresa.CNPJ,Empresa.RzSoci]);
        end;
        if CadEmp = nil then
        begin
            CadEmp :=TCCadEmp.New(1) ;
            CallOnStrProc('Emitente: %s-%s',[CadEmp.CNPJ,CadEmp.xNome]);
        end;
    end;

    try
    //
    // simula o singleton
    if m_Rep =nil then
    begin
        // (aStatusChange =false) desabilita status de processamento
        m_Rep :=TCBaseACBrNFE.New(False) ;
    end;
    m_reg :=m_Rep.param ;

    //
    // check validade do certificado
    if m_Rep.getDaysUseCertif <= 7 then
    begin
        if(m_AlertCount =0)or(m_Interval >= MSecsPerDay div HoursPerDay) then
        begin
            //
            // sincroniza o alert aqui
            CallOnCertif(m_Rep.nfe.SSL.CertCNPJ, m_Rep.getDaysUseCertif);
            //
            // reset o intervalo
            m_Interval :=0 ;
            Inc(m_AlertCount);
        end;

        //
        // caso o certificado venceu, termina a thread
        if m_Rep.getDaysUseCertif <= 0 then
        begin
            CallOnStrProc('Certificado vinculado ao CNPJ:%s já venceu!',[CadEmp.CNPJ]);
            Self.Terminate ;
            Exit;
        end;
    end;

    //
    // chk filtro
    case m_Filter.filTyp of
        ftService:
        begin
            m_Filter.nserie :=m_Rep.nSerie;
            //m_Filter.save :=True;
            //
            // atualiza a view
            m_reg.loadContingOffLine ;
            CallOnContingOffLine(m_reg.conting_offline.Value);
            //
            //CallOnStrProc('Carregando Notas Fiscais (Ser:%d)',[m_Filter.nserie]);
        end;
        //
        //
        ftFech:
        begin
            if m_Filter.codmod < 55 then
            begin
                m_Filter.codmod :=55 ;
                m_CodMod :=m_Filter.codmod ;
            end
            //
            //
            else begin
                if m_CodMod > 0 then
                    m_Filter.codmod :=65 ;
            end;
            //CallOnStrProc('Carregando Notas Fiscais (Mod:%d, Ser:%d)',[m_Filter.codmod,m_Filter.nserie]);
        end;
    end;

    //
    // carrega conforme filtro
    if m_Lote.Load(m_Filter) then
    begin
        //
        // X notas encontradas
        {if m_Lote.Items.Count > 1 then
        begin
            CallOnStrProc('%d nota(s) fiscai(s) encontrada(s)!',[m_Lote.Items.Count]);
        end;}

        //
        // inicializa lote
        codLot :=0;
        retAssyncDuplCount :=0;
        m_Rep.nfe.NotasFiscais.Clear ;

        //
        // loop para processamento
        for NF in m_Lote.Items do
        begin
            if Self.Terminated then Break ;

            //
            // força proxima NF
            //
            nfe :=nil ;

            //
            // NF processada
            if NF.CStatProcess then
            begin
                CallOnStrProc('NF:%d [Mod:%d Ser:%.3d], já processada',
                              [NF.m_numdoc,NF.m_codmod,NF.m_nserie]);
                // proxima NF
                Continue ;
            end;

            //
            // NF cancelada
            if NF.CstatCancel then
            begin
                CallOnStrProc('NF:%d [Mod:%d Ser:%.3d], cancelada!',
                              [NF.m_numdoc,NF.m_codmod,NF.m_nserie]);
                // proxima NF
                Continue ;
            end;

            //
            // alert para consumo indevido
            if NF.m_codstt =cs.ERR_CONSUMO_INDEVIDO then
            begin
                CallOnStrProc('NF:%d [Mod:%d Ser:%.3d]| %d:%s',[
                  NF.m_numdoc,NF.m_codmod,NF.m_nserie,NF.m_codstt,NF.m_motivo]);
                // proxima NF
                Continue ;
            end;

            //
            // somente para serviço
            // autorizador de NFE do CX
            if m_Filter.filTyp =ftService then
            begin
                //
                // chk se ja foi gerada em Contingencia/Off
                if(NF.m_codstt =TCNotFis00.CSTT_EMIS_CONTINGE)and
                  (NF.m_dhcont > 0)and(NF.m_chvnfe <>'') then
                begin
                    // se NÃO process NF em contingencia
                    m_reg.loadSendConting ;
                    if not m_reg.send_conting.Value then
                        Continue ;
                end;

                //
                // emissão em contingencia Off
                if m_reg.conting_offline.Value then
                begin
                    //
                    // libera o CX para NF não processada
                    if NF.m_codstt = 0 then
                    begin
                        //
                        // emissão em contingência offline
                        ProcContingOff(NF);
                    end;
                end

                //
                // emissão on-line (normal, svan, etc)
                else begin
                    //
                    // NF não processada;
                    // NF com erro de schema;
                    // NF com erro nas regras de validação;
                    // Rejeição 217: NFe não consta na base de dados;
                    // Rejeição 704: NFC-E com data-hora de emissão atrasada;
                    // Rejeição 999:  erro geral sefaz
                    if(NF.m_codstt in[0,cs.ERR_SCHEMA,cs.ERR_REGRAS,cs.NFE_NAO_CONSTA_BD])or
                      (NF.m_codstt =cs.NFCE_DH_EMIS_RETRO)or
                      (NF.m_codstt =cs.ERR_GERAL)then
                    begin
                        //
                        //
                        CallOnStrProc('Atualizando NF: %d [Mod:%d Ser:%.3d], Status: %d',[
                        NF.m_numdoc,NF.m_codmod,NF.m_nserie,NF.m_codstt]);

                        //
                        // caso não consiga atualiza a NF
                        // reporta o erro e vai para a proxima NF
                        if not NF.UpdateNFe(now, Ord(m_Rep.param.xml_prodescri_rdz.Value), Ord(m_Rep.param.xml_procodigo_int.Value), S) then
                        begin
                            CallOnStrProc(#9'Erro: '+S);
                            Continue ;
                        end;

                        //
                        // gera NFE
                        CallOnStrProc(#9'Gerando NFE ...') ;
                        nfe :=m_Rep.AddNotaFiscal(NF, True) ;
                        if nfe <> nil then
                        begin
                            //
                            // registra status/xml/chave
                            NF.setXML();
                            //
                            // reporta upd
                            CallOnStrProc(#9'%s, chave: %s',[NF.m_motivo,NF.m_chvnfe]);

                        end
                        else begin
                            //
                            // reporta o erro
                            CallOnStrProc(#9'NFE não gerada: ' +m_Rep.ErrMsg);
                            //
                            // força para a proxima nota
                            Continue ;
                        end;
                    end
                    else
                        nfe :=nil;

                    //
                    // pronto p/ envio (nf0_codstt=1)
                    // contingencia off (nf0_codstt=9)
                    if NF.m_codstt in[cs.DONE_SEND,cs.CONTING_OFFLINE]then
                    begin
                        //
                        // chk nfe no repositorio
                        if nfe = nil then
                        begin
                            //
                            // carrega XML
                            if NF.LoadXML then
                            begin
                                //
                                // add nfe com base no XML
                                nfe :=m_Rep.AddNotaFiscal(nil, True) ;
                                nfe.LerXML(NF.m_xml) ;
                            end
                            else begin
                                //
                                // força XML
                                nfe :=m_Rep.AddNotaFiscal(NF, True) ;
                                if nfe <> nil then
                                begin
                                    //
                                    // registra status/xml/chave
                                    NF.setXML();
                                    CallOnStrProc(#9'%s, chave: %s',[NF.m_motivo,NF.m_chvnfe]);
                                end
                                else begin
                                    //
                                    // reporta o erro
                                    CallOnStrProc(#9'NFE não gerada: ' +m_Rep.ErrMsg);
                                    //
                                    // força para a proxima nota
                                    Continue ;
                                end;
                            end;
                        end;


                        //
                        // envio sincrono
                        if m_Rep.param.send_lotsync.Value then
                        begin
                            CallOnStrProc('Enviando lote[%d] Sync',[NF.m_codseq]);
                            send :=m_Rep.OnlySendSync(NF) ;
                        end
                        //
                        // envio assincrono
                        else begin
                            CallOnStrProc('Enviando lote[%d] Assync',[NF.m_codseq]);
                            send :=m_Rep.OnlySendAssync(NF.m_codseq);
                        end;

                        //
                        // trata retorno com sucesso
                        if send then
                        begin
                            //
                            // retorno sync
                            if m_Rep.param.send_lotsync.Value then
                            begin
                                // registra retorno
                                NF.setStatus();
                                // reporta motivo
                                CallOnStrProc(#9+NF.m_motivo);
                            end
                            //
                            // retorno assync
                            else begin
                                retAssyncDuplCount :=TrataRetAssync ;
                                if retAssyncDuplCount > 0 then
                                  TrataRetComDupl(NF);
                            end;
                        end
                        //
                        // trata retorno sem sucesso
                        else begin
                            //
                            // alert falha
                            CallOnStrProc(#9'Envio falhou: %d-%s',[m_Rep.ErrCod,m_Rep.ErrMsg]);
                            TrataRetFair(NF);
                        end;
                    end;
                end;
            end

            //
            // fechamento do CX
            else begin
                //
                //
                if NF.m_codstt in[cs.DONE_SEND,cs.CONTING_OFFLINE] then
                begin
                    //
                    // carrega XML
                    if NF.LoadXML then
                    begin
                        //
                        // add nfe com base no XML
                        nfe :=m_Rep.AddNotaFiscal(nil, False) ;
                        nfe.LerXML(NF.m_xml) ;
                    end
                    else begin
                        //
                        // força XML
                        nfe :=m_Rep.AddNotaFiscal(NF, False) ;
                        if nfe <> nil then
                        begin
                            //
                            // registra status/xml/chave
                            NF.setXML();
                            CallOnStrProc(#9'%s, chave: %s',[NF.m_motivo,NF.m_chvnfe]);
                        end
                        else begin
                            //
                            // reporta o erro
                            CallOnStrProc(#9'NFE não gerada: ' +m_Rep.ErrMsg);
                            //
                            // força para a proxima nota
                            Continue ;
                        end;
                    end;
                end;

                //
                //
                if(NF.m_codstt =cs.ERR_SCHEMA )or
                  (NF.m_codstt =cs.ERR_REGRAS )or
                  (NF.m_codstt =cs.ERR_GERAL )or
                  (NF.m_codstt =cs.NFE_NAO_CONSTA_BD )or
                  (NF.m_codstt =cs.NFCE_DH_EMIS_RETRO )then
                //if NF.CStatError then
                //if not (NF.m_codstt in[cs.CONTING_OFFLINE,cs.DUPL]) then
                begin
                    CallOnStrProc(#9'Atualizando...');
                    if NF.UpdateNFe(now, Ord(m_Rep.param.xml_prodescri_rdz.Value), Ord(m_Rep.param.xml_procodigo_int.Value), S) then
                        NF.Load()
                    else begin
                        CallOnStrProc(S);
                        Continue ;
                    end ;

                    //
                    // gera NFE
                    CallOnStrProc(#9'Gerando NFE ...') ;
                    nfe :=m_Rep.AddNotaFiscal(NF, False) ;
                    if nfe <> nil then
                    begin
                        //
                        // registra status/xml/chave
                        NF.setXML();
                        CallOnStrProc(#9'%s, chave: %s',[NF.m_motivo,NF.m_chvnfe]);
                        if NF.m_codstt =cs.ERR_SCHEMA then
                            m_Rep.nfe.NotasFiscais.Delete(nfe.Index);
                    end
                    else begin
                        //
                        // reporta o erro
                        CallOnStrProc(#9'NFE não gerada: ' +m_Rep.ErrMsg);
                        //
                        // força para a proxima nota
                        Continue ;
                    end;
                end;

                //
                // inicializa lote para posterior envio
                if(codLot = 0)and(m_Rep.nfe.NotasFiscais.Count >0) then
                begin
                    codlot :=NF.m_codseq;
                end ;
            end;

            //
            // consulta protocolo
            //
            if(retAssyncDuplCount > 0)or
              (NF.m_codstt =cs.RET_PENDENTE)or
              (NF.m_codstt =cs.DUPL)then
            begin
                //
                //
                TrataRetComDupl(NF);
            end;

        end;
        //
        //
        if(m_Filter.filTyp =ftFech)and(codlot > 0) then
        begin
            // ProcAsync(codlot) ;
            CallOnStrProc(#9'Enviando lote[%d] Assync',[codlot]);
            send :=m_Rep.OnlySendAssync(codlot);
            if send then
            begin
                retAssyncDuplCount :=TrataRetAssync ;
            end
            //
            // trata retorno com erros
            else begin
                //
                // alert falha
                CallOnStrProc(#9'Envio falhou: %d-%s',[m_Rep.ErrCod,m_Rep.ErrMsg]);
                TrataRetFair(nil);
            end;
        end;
    end

    //
    // mostra msg conforme filtro
    else begin
        if m_Filter.filTyp = ftFech then
        begin
            CallOnStrProc('Nenhuma NF encontrada!');
            //
            // se ja processou todos os modelos do CX
            if((m_CodMod > 0)and(m_Filter.codmod =65))or
              ( m_CodMod =00)then
            begin
                //
                // termina tarefa
                Self.Terminate ;
            end ;
        end ;
    end;

    finally
        m_Lote.Items.Clear ;
        if m_Filter.filTyp =ftService then
            ConnectionADO.Close ;
    end ;

end;

function TMySvcThread.TrataRetAssync: Integer;
var
  nfe: TNFe;
  ret: TNFeRetRecepcao; // TRetConsReciDFe ;
  NF: TCNotFis00;
  I: Integer;
var
  cs: NotFis00CodStatus;
begin
    Result :=0 ;
    //
    //
    ret :=m_Rep.nfe.WebServices.Retorno;
    CallOnStrProc(#9'%d|%s]',[ret.cStat,ret.xMotivo]);

    //
    // ainda em processamento
    {if ret.cStat =cs.LOT_EM_PROCESS then
    begin
        //
        // ler retorno até liberar o lote!
        CallOnStrProc(#9'Aguardando resultado do processamento');
        repeat

        until(ret.cStat =cs.LOT_PROCESS);
        //while (not Self.Terminated)and
        //
    end;}

    //
    // lopp para
    // read e update cada nfe
    for I :=0 to m_Rep.nfe.NotasFiscais.Count -1 do
    begin
        if Terminated then Exit;
        //
        // ler nfe pelo index
        nfe :=m_Rep.nfe.NotasFiscais.Items[I].NFe ;
        //
        // busca na notfis pela chave
        NF :=m_Lote.IndexOf(OnlyNumber(nfe.infNFe.ID) ) ;
        if NF <> nil then
        begin
            CallOnStrProc(#9'Lendo NFE[%s]',[NF.m_chvnfe]);
            NF.m_tipamb :=ret.TpAmb ;
            NF.m_codstt :=ret.cStat ;
            NF.m_motivo :=ret.xMotivo ;
            NF.m_verapp :=ret.verAplic;
            NF.m_numreci:=ret.Recibo ;
            NF.m_dhreceb:=now ;

            if ret.NFeRetorno.cStat =cs.LOT_EM_PROCESS then
            begin
                NF.m_codstt :=nfe.procNFe.cStat ;
                NF.m_motivo :=nfe.procNFe.xMotivo;
                NF.m_verapp :=nfe.procNFe.verAplic;
                NF.m_dhreceb:=nfe.procNFe.dhRecbto;
                //NF.m_numreci:=m_Rep.nfe.WebServices.Retorno.NFeRetorno.nRec ;
                NF.m_numprot:=nfe.procNFe.nProt ;
                NF.m_digval :=nfe.procNFe.digVal;
            end;

            //
            // atualiza status
            CallOnStrProc(#9'Gravando retorno[%d|%s]',[NF.m_codstt,NF.m_motivo]);
            NF.setStatus ;
            //
            // chk consumo
            if NF.m_codstt =cs.ERR_CONSUMO_INDEVIDO then
            begin
                CallOnStrProc(#9'%d|%s',[NF.m_codstt,NF.m_motivo]);
            end;

            //
            // contabiliza duplicidade
            if(NF.m_codstt =cs.DUPL         )or
              (NF.m_codstt =cs.DUPL_DIF_CHV )or
              (NF.m_codstt =cs.CHV_DIF_BD   )then
            begin
                Inc(Result) ;
                NF.Checked :=True ;
            end;
        end;
    end;

    //
    // TRATA DUPL
    if Result > 0 then
    begin
        for NF in m_Lote.Items do
        begin
            if NF.Checked then
            begin
                TrataRetComDupl(NF);
            end;
        end;
    end;
end;

procedure TMySvcThread.TrataRetComDupl(NF: TCNotFis00) ;
var
  cs: NotFis00CodStatus ;
  nfe: NotaFiscal;
begin
    CallOnStrProc('Consulta protocolo pela chave NFE[:%s]',[NF.m_chvnfe]);
    //
    // corrige se retorno
    // Rejeição 204: duplicidade de chave
    if m_Rep.OnlyCons(NF) then
    begin

        //
        // registra o status
        // 100: autorizado o uso (protocolo)
        // 217: NFE não consta na base (sera processada no proximo lote)
        NF.setStatus();
        //
        // reporta o status
        CallOnStrProc(#9+NF.m_motivo);

        //
        // Rejeição 613: Chave de Acesso difere da existente em BD (WS_CONSULTA)
        // pode ser q a NFE ja tinha sido autorizada emis-normal (RET_PEDENTE)
        if(NF.m_codstt =cs.CHV_DIF_BD)and
          ((NF.m_tipemi =teContingencia)or(NF.m_tipemi =teOffLine))then
        begin
            //
            // Reset. contingencia
            // para voltar XML/Chave emis-normal
            CallOnStrProc(#9'Desfazendo contingência (NFE:%s)',[NF.m_chvnfe]);
            NF.setContinge('', True);
        end;
    end
    else
        CallOnStrProc(#9'Erro ao consultar protocolo! %s',[m_Rep.ErrMsg]);
end;

procedure TMySvcThread.TrataRetFair(NF: TCNotFis00) ;
var
  msg: string ;
  cs: NotFis00CodStatus;
begin
    msg :='';
    case m_Rep.ErrCod of
        // http ou interno
        // Pendente de retorno
        408,HTTP_STATUS_SERVICE_UNAVAIL,10060,10091,ERROR_WINHTTP_TIMEOUT:
        begin
            {msg :=Format('[%d]Pendente de retorno!',[m_Rep.ErrCod]);
            if NF <> nil then
            begin
              NF.m_codstt :=cs.RET_PENDENTE;
              NF.m_motivo :=msg;
              NF.setStatus ;
            end;}
            //
            // set contig-off
            m_reg.setContingOffLine(True);
            if NF <> nil then ProcContingOff(NF) ;
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
            // set contig-off
            m_reg.setContingOffLine(True);
            if NF <> nil then ProcContingOff(NF)
            else
                msg :=m_Rep.ErrMsg ;
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
        if NF <> nil then // somente uma uma NF
        begin
            NF.m_codstt :=cs.ERR_ASSINA;
            NF.m_motivo :=Format('[%d]%s', [m_Rep.ErrCod,m_Rep.ErrMsg]) ;
            NF.setStatus ;
        end
        else begin
            msg :=Format('[%d]%s', [m_Rep.ErrCod,m_Rep.ErrMsg]) ;
        end;

    //
    // erro interno
    else
        //
        // se ocorrer, implementação futura !!!
        if NF <> nil then // somente uma NF
        begin
            NF.m_codstt :=m_Rep.ErrCod ;
            NF.m_motivo :=Format('Erro interno[%d|%s]',[m_Rep.ErrCod,m_Rep.ErrMsg]) ;
            NF.setStatus ;
        end
        else begin
            msg :=Format('Erro interno[%d|%s]',[m_Rep.ErrCod,m_Rep.ErrMsg]) ;
        end;
    end;
    //
    // reporta erro
    CallOnStrProc(#9+msg);
end;

end.
