{***
* View envio de lote assincrono (maximo de 50 NFE)
* Atac Sistemas
* Todos os direitos reservados
* Autor: Carlos Gonzaga
* Data: 25.05.2018
*}
unit Form.EnvioLote;

{*
******************************************************************************
|* PROPÓSITO: Registro de Alterações
******************************************************************************

Símbolo : Significado

[+]     : Novo recurso
[*]     : Recurso modificado/melhorado
[-]     : Correção de Bug (assim esperamos)

27.12.2018
[*] O processo de Envio/Consulta agora dentro de uma thread, para envio
    automatico do lote

01.08.2018
[*] Consulta protocolo caso o status seja 204 (duplicidade),
    apos envio de lote com varias nota!

*}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ExtCtrls, ComCtrls,

  //JEDI
  JvExStdCtrls, JvExExtCtrls, JvExtComponent, JvCtrls, JvButton, JvFooter,
  JvRichEdit ,
  //TMS
  AdvPanel, AdvPageControl,
  //
  VirtualTrees, uVSTree,
  //
  FormBase,
  unotfis00,
  uclass, ulog, GradientLabel;

type
  TCSendLote = class(TCThreadProcess)
  private
    m_Grid: TVirtualStringTree ;
    m_Filter: TNotFis00Filter ;
    m_Lote: TCNotFis00Lote ;
    procedure DoLoadGrid;
  protected
    procedure RunProc; override;
  public
    constructor Create(aGrid: TVirtualStringTree; aLote: TCNotFis00Lote;
      const aFilter: TNotFis00Filter);
  end;




type
  Tfrm_EnvLote = class(TBaseForm)
    pnl_Footer: TJvFooter;
    btn_OK: TJvFooterBtn;
    btn_Close: TJvFooterBtn;
    btn_Start: TJvFooterBtn;
    btn_Stop: TJvFooterBtn;
    pag_Control1: TAdvPageControl;
    tab_Grid1: TAdvTabSheet;
    tab_LOG: TAdvTabSheet;
    vst_Grid1: TVirtualStringTree;
    txt_Log: TJvRichEdit;
    lbl_MaxLot: TGradientLabel;
    txt_RichLOG: TRichEdit;
    procedure FormShow(Sender: TObject);
    procedure vst_Grid1GetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure btn_OKClick(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure btn_StartClick(Sender: TObject);
    procedure btn_StopClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure vst_Grid1Change(Sender: TBaseVirtualTree; Node: PVirtualNode);
  private
    { Private declarations }
    m_Filter: TNotFis00Filter;
    m_oLote: TCNotFis00Lote ;
    procedure m_LoadGrid() ;
    procedure m_UpdateStatus(const aStr: string);
  private
    { Thread }
    m_Send: TCSendLote;
    procedure DoStop ;
    procedure OnINI(Sender: TObject);
    procedure OnEND(Sender: TObject);
    procedure OnUpdateStatus(const aStr: string);
  public
    { Public declarations }
    procedure DoResetForm; override ;
    //class function fn_Show(aLote: TCNotFis00Lote): Boolean ;
    class function fn_Show(const aFilter: TNotFis00Filter): Boolean ;
  end;


implementation

{$R *.dfm}

uses StrUtils, DateUtils, DB,
  uTaskDlg, uparam ,
  ACBrUtil, pcnNFe, pcnConversao,
  FDM.NFE, uACBrNFE ;


{ Tfrm_EnvLote }

procedure Tfrm_EnvLote.btn_CloseClick(Sender: TObject);
begin
    Self.Close ;

end;

procedure Tfrm_EnvLote.btn_OKClick(Sender: TObject);
var
  rep: Tdm_nfe ;
  N: TCNotFis00 ;
  nfe: TNFe;
  codLot,I,dup: Integer;
  S: string;
var
  limit: Integer;
  P: TCParametro ;
begin
    //
    // limpa repositorio
    rep :=Tdm_nfe.getInstance;
    rep.m_NFE.NotasFiscais.Clear ;

    //
    // inicializa num do lote
    codlot :=0;
    limit :=0;

    //
    // ler parametro top(n) notas em lote
    P :=TCParametro.NewParametro('send_maxnfelot', ftSmallint);
    if not P.Load() then
        top :=25
    else
        top :=P.ReadInt() ;

    Screen.Cursor :=crHourGlass;
    try
    //
    // chk status de cada NF
    for N in m_oLote.Items do
    begin
        if N.Checked then
        begin
            if N.m_codstt <>TCNotFis00.CSTT_EMIS_CONTINGE then
            begin
                m_UpdateStatus(Format('Atualizando NF:%d',[N.m_numdoc]));
                if not N.UpdateNFe(now, Ord(rep.ProdDescrRdz), Ord(rep.ProdCodInt), S) then
                begin
                    m_UpdateStatus(S);
                    N.Checked :=False;
                    Continue ;
                end ;
            end;

            if rep.AddNotaFiscal(N) = nil then
            begin
                N.Checked :=False ;
                Continue ;
            end ;

            if codLot = 0 then
            begin
                codlot :=N.m_codseq;
            end ;
            limit :=limit +1;
            if limit > P.ReadInt() then
            begin
              Break;
            end;
        end;
    end;
    finally
        Screen.Cursor :=crDefault;
    end;

    if rep.m_NFE.NotasFiscais.Count <= 0 then
    begin
        CMsgDlg.Warning('Nenhuma NFE adicionada ao Lote!');
        Exit;
    end;

    if rep.m_NFE.NotasFiscais.Count > 50 then
    begin
        CMsgDlg.Warning('Excedeu o limite máximo de 50 NF´s!');
        Exit;
    end;

    dup :=0;

    m_UpdateStatus('Enviando lote, aguarde...');
    if rep.OnlySend(codLot) then
    begin
        //
        // lote processado
        //
        if rep.Retorno.NFeRetorno.cStat =TCNotFis00.CSTT_PROCESS then
        begin
            for I :=0 to rep.m_NFE.NotasFiscais.Count -1 do
            begin
                nfe :=rep.m_NFE.NotasFiscais.Items[I].NFe ;
                N :=m_oLote.IndexOf(OnlyNumber(NFe.infNFe.ID) ) ;
                if N <> nil then
                begin
                    //
                    // reset checagem para posterior
                    // processamento(protocolo)
                    N.Checked :=False ;

                    //
                    // atualiza status
                    m_UpdateStatus(Format('Atualizando NFE:%s',[N.m_chvnfe]));
                    N.m_codstt :=nfe.procNFe.cStat ;
                    N.m_motivo :=nfe.procNFe.xMotivo;
                    N.m_verapp :=nfe.procNFe.verAplic;
                    N.m_dhreceb:=nfe.procNFe.dhRecbto;
                    N.m_numreci:=rep.Retorno.NFeRetorno.nRec ;
                    N.m_numprot:=nfe.procNFe.nProt ;
                    N.m_digval :=nfe.procNFe.digVal;
                    N.setStatus ;

                    //
                    // se duplicidade
                    if(N.m_codstt =TCNotFis00.CSTT_DUPL)or
                      (N.m_codstt =TCNotFis00.CSTT_DUPL_DIF_CHV)then
                    begin
                        N.Checked :=True ;
                        Inc(dup) ;
                    end;

                end;
            end;
        end ;
        CMsgDlg.Info('%d|%s',[rep.Retorno.NFeRetorno.cStat,rep.Retorno.NFeRetorno.xMotivo]);

        //
        // check NF com duplicidade
        // para consulta de protocolo
        if dup > 0 then
        begin
            m_UpdateStatus(Format('%d nota(s) com duplicidade!',[dup]));

            Screen.Cursor :=crHourGlass;
            try
            for N in m_oLote.Items do
            begin
                if N.Checked then
                begin
                    m_UpdateStatus(Format('Consultando protocolo (NFE:%s)',[N.m_chvnfe]));
                    //
                    // Rejeição 204: duplicidade de chave
                    if rep.OnlyCons(N) then
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
                                m_UpdateStatus(Format('Desfazendo contingência (NFE:%s)',[N.m_chvnfe]));
                                N.setContinge('', True);
                                N.Load() ;
                                if rep.AddNotaFiscal(N, True) <> nil then
                                begin
                                    N.setXML() ;
                                    //
                                    //
                                    m_UpdateStatus(Format('Consultando protocolo (NFE:%s)',[N.m_chvnfe]));
                                    if rep.OnlyCons(N) then
                                    begin
                                        N.setStatus();
                                    end ;
                                end ;
                            end;
                        end;
                    end;
                end;
            end;
            finally
                Screen.Cursor :=crDefault;
            end;
        end;

        ModalResult :=mrOk ;
    end
    else
        CMsgDlg.Warning(Tdm_nfe.getInstance.ErrMsg)
        ;
end;

procedure Tfrm_EnvLote.btn_StartClick(Sender: TObject);
begin
    if Assigned(m_Send) then
    begin
        //CMsgDlg.Warning('A Tarefa já esta criada!')
        DoStop;
    end ;
    //
    // start manual
    m_Send :=TCSendLote.Create(vst_Grid1, m_oLote, m_Filter) ;
    m_Send.OnBeforeExecute :=OnINI;
    m_Send.OnTerminate :=OnEND;
    m_Send.OnStrProc :=OnUpdateStatus;
    m_Send.Start  ;
end;

procedure Tfrm_EnvLote.btn_StopClick(Sender: TObject);
begin
    if Assigned(m_Send) then
    begin
        if(not m_Send.Terminated)and CMsgDlg.Warning('A Tarefa esta em execução! Deseja termina-la?',True) then
        begin
            //
            // stop manual
            DoStop ;
        end;
    end ;
end;

procedure Tfrm_EnvLote.DoResetForm;
var
  P: TCParametro ;
begin
    vst_Grid1.Clear ;
    txt_Log.Clear ;
    txt_RichLOG.Clear ;

    //
    // inicializa limite
    P :=TCParametro.NewParametro('send_maxnfelot', ftSmallint);
    if not P.Load() then
    begin
        m_Filter.limlot :=25 ;
    end
    else begin
        m_Filter.limlot :=P.ReadInt() ;
    end;
    m_Filter.filTyp :=ftFech ;
    m_Filter.codmod :=55 ;
    m_Filter.sttSet :=[sttConting] ;
end;

procedure Tfrm_EnvLote.DoStop;
begin
    m_Send.Terminate;
    m_Send.WaitFor;
    FreeAndNil(m_Send);
end;

class function Tfrm_EnvLote.fn_Show(const aFilter: TNotFis00Filter): Boolean ;
var
  F: Tfrm_EnvLote ;
begin
    F :=Tfrm_EnvLote.Create(Application) ;
    try
        F.m_Filter :=aFilter ;
        F.m_oLote :=TCNotFis00Lote.Create ;
        F.DoResetForm;
        Result :=F.ShowModal =mrOk ;
    finally
        FreeAndNil(F);
    end;
end;

procedure Tfrm_EnvLote.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    if Assigned(m_Send) then
    begin
        if m_Send.Terminated then
            DoStop
        else begin
            CMsgDlg.Warning('A Tarefa esta em execução!');
            CanClose :=False ;
        end;
    end;
end;

procedure Tfrm_EnvLote.FormShow(Sender: TObject);
begin
    {m_LoadGrid() ;
    ActiveControl :=vst_Grid1;
    HTMLabel1.HTMLText.Clear ;
    HTMLabel1.HTMLText.Add(
      Format('<P><b>ATENÇÃO!</b> Verifique na listagem abaixo, as <b>%d</b> NFE´s que serão enviadas de uma so vez</P>',[vst_Grid1.RootNodeCount])
    );
    //
    //
    m_UpdateStatus('Aguardando confirmação!');
    }
    pag_Control1.ActivePageIndex :=0;
    //
    // start a thread
    btn_Start.Click ;

end;

procedure Tfrm_EnvLote.m_LoadGrid;
var
  N: TCNotFis00 ;
  P: PVirtualNode;
begin
    for N in m_oLote.Items do
    begin
        //
        // remove NF processada / cancelada
        if N.CStatProcess or N.CstatCancel then
        begin
            Continue ;
        end;

        P :=vst_Grid1.AddChild(nil) ;
        N.Checked :=True ;
        P.CheckType :=ctCheckBox ;
        P.CheckState:=csCheckedNormal ;
    end;

    vst_Grid1.IndexItem :=0;
    vst_Grid1.Refresh ;
end;

procedure Tfrm_EnvLote.m_UpdateStatus(const aStr: string);
var
  N: TCNotFis00 ;
  P: string;
begin
//    html_Status.HTMLText.Clear;
//    html_Status.HTMLText.Add(Format('<P align="left"><B>%s</B></P>',[aStr]));
//    html_Status.Refresh ;
end;

procedure Tfrm_EnvLote.OnEND(Sender: TObject);
begin
    btn_Start.Enabled :=True;
    btn_Stop.Enabled  :=False;
    //setStatus('Thread terminada');
    OnUpdateStatus('Tarefa terminada.');
end;

procedure Tfrm_EnvLote.OnINI(Sender: TObject);
begin
    btn_Start.Enabled :=False;
    btn_Stop.Enabled  :=True ;
    btn_OK.Enabled :=False;
    pag_Control1.ActivePageIndex :=1;
    txt_Log.Clear ;
    //setStatus('Thread iniciada');
    OnUpdateStatus('Tarefa iniciada');
end;

procedure Tfrm_EnvLote.OnUpdateStatus(const aStr: string);
var
  clr: TColor ;
  txt: string;
begin
    //setStatus(aStr);
    vst_Grid1.Refresh ;

{
    if Pos('Erro', StrLog) > 0 then
    begin
        mmo_Log.AddFormatText(StrLog, [fsBold,fsItalic], 'Arial', clRed) ;
        mmo_Log.AddFormatText(#13#10, []) ;
    end
    else
        mmo_Log.Lines.Add(StrLog);
//    mmo_Log.ScrollBy();
    mmo_Log.SelLength := 0;
    mmo_Log.SelStart:=mmo_Log.GetTextLen; //mmo_Log.Perform(EM_LINEINDEX, mmo_Log.Lines.Count -1, 0);
    mmo_Log.Perform( EM_SCROLLCARET, 0, 0 ); //::garantir a exibição é correto
}
    if Pos('ini', aStr) > 0 then
        txt :=FormatDateTime('HH:NN:SS|"Tarefa iniciada"', Now)
    else begin
        if Pos('term', aStr) > 0 then
            txt :=FormatDateTime('HH:NN:SS|"Tarefa terminada"', Now)
        else
            txt :=#9 +aStr ;
    end;

    if Pos('Erro', txt) > 0 then
        txt_Log.AddFormatText('', [], 'Trebuchet MS', clRed)
    else
        txt_Log.AddFormatText('', [], 'Trebuchet MS', clWindowText);
    txt_Log.Lines.Add(txt);
    txt_Log.Perform(EM_SCROLLCARET, 0, 0); //::garantir a exibição é correto

    {if txt_RichLOG.Lines.Count =0 then
    begin
        txt_RichLOG.SelAttributes.Name :='Trebuchet MS';
        txt_RichLOG.SelAttributes.Size :=9;
    end;
    txt_RichLOG.SelAttributes.Color :=clr;}
    txt_RichLOG.Lines.Add(txt) ;
    txt_RichLOG.SelLength := 0;
    txt_RichLOG.SelStart:=txt_RichLOG.GetTextLen;
    txt_RichLOG.Perform(EM_SCROLLCARET, 0, 0);
end;

procedure Tfrm_EnvLote.vst_Grid1Change(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
    if Assigned(Node) then
        lbl_MaxLot.Caption :=Format('NFE: %d/%d, parâmetro NFE/lote: %d, maximo NFE/lote: %d',[
              Node.Index +1, m_oLote.Items.Count, m_Filter.limlot, TCNotFis00.QTD_MAX_NFE_IN_LOTE])
    else
        lbl_MaxLot.Caption :='Nenhum';
end;

procedure Tfrm_EnvLote.vst_Grid1GetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  N: TCNotFis00 ;
begin
  if Assigned(Node) then
  begin
    CellText :='';
    N :=m_oLote.Items[Node.Index] ;
    case Column of
        0: CellText :=N.m_chvnfe;
        1: CellText :=Format('%.6d',[N.m_codped]) ;
        2: CellText :=IfThen(N.m_codmod=55,'NFe','NFCe') ;
        3: CellText :=Format('%.3d',[N.m_nserie]) ;
        4: CellText :=Format('%.8d',[N.m_numdoc]) ;
        5: CellText :=Format('%d|%s',[N.m_codstt,N.m_motivo]);
    end;
  end;
end;

{ TCSendLote }

constructor TCSendLote.Create(aGrid: TVirtualStringTree; aLote: TCNotFis00Lote;
  const aFilter: TNotFis00Filter);
begin
    m_Grid :=aGrid ;
    m_Lote :=aLote;
    m_Filter :=aFilter ;
    inherited Create(True, False);
end;

procedure TCSendLote.DoLoadGrid;
var
  N: TCNotFis00 ;
  P: PVirtualNode;
begin
    m_Grid.Clear ;
    for N in m_Lote.Items do
    begin
        //
        // remove NF processada / cancelada
        if N.CStatProcess or N.CstatCancel then
        begin
            Continue ;
        end;
        N.Checked :=True ;
        //
        //
        P :=m_Grid.AddChild(nil) ;
        P.CheckType :=ctCheckBox ;
        P.CheckState:=csCheckedNormal ;
    end;
    m_Grid.IndexItem :=0;
    //m_Grid.Refresh ;
end;

procedure TCSendLote.RunProc;
var
  //rep: Tdm_nfe ;
  rep: IBaseACBrNFE ;
  N: TCNotFis00;
  nfe: TNFe;
var
  S: string ;
  codlot,dupl,I: Integer;
begin
//    if not Assigned(m_Lote) then
//    begin
//        Self.Terminate ;
//        Exit ;
//    end;

    //rep :=Tdm_nfe.getInstance ;
    //rep.setStatusChange(false); //desabilita status de processamento
    //rep.m_NFE.NotasFiscais.Clear; //reset
    rep :=TCBaseACBrNFE.New(False) ;

    //
    // RESET MOD
    if m_Filter.codmod < 65 then
        m_Filter.codmod :=55
    else
        m_Filter.codmod :=65;

    CallOnStrProc('Carregando notas fiscais (Mod:%d)',[m_Filter.codmod]);
    if m_Lote.Load(m_Filter) then
    begin
        Synchronize(DoLoadGrid);
    end
    else begin
        CallOnStrProc('Nenhuma NF encontrada!');
        if m_Filter.codmod = 65 then
        begin
            Self.Terminate ;
        end;
        m_Filter.codmod :=65;
        Exit;
    end;
    CallOnStrProc('%d nota(s) fiscai(s) encontrada(s)!',[m_Lote.Items.Count]);

    //
    // inicializa num do lote
    codlot :=0;

    for N in m_Lote.Items do
    begin
        //
        // força proxima NF
        //

        //
        // se processada ou cancelada
        if N.CStatProcess or N.CstatCancel then
        begin
            Continue ;
        end;

        //
        // process...
        CallOnStrProc('Adicionando NFE: %d [Mod:%d Ser:%.3d], Status: %d',[
            N.m_numdoc,N.m_codmod,N.m_nserie,N.m_codstt]);

        //
        // se consumo indevido atingiu o limite
        if N.m_consumo >=TCNotFis00.QTD_MAX_CONSUMO then
        begin
            CallOnStrProc('NFE não pode ser adcionada! [QTD_MAX_CONSUMO >= %d]',[N.m_consumo]);
            Continue ;
        end;

        if N.m_codstt <>TCNotFis00.CSTT_EMIS_CONTINGE then
        begin
            CallOnStrProc('Atualizando...');
            if not N.UpdateNFe(now, Ord(rep.param.xml_prodescri_rdz.Value), Ord(rep.param.xml_procodigo_int.Value), S) then
            begin
                CallOnStrProc(S);
                N.Checked :=False;
                Continue ;
            end ;
        end;

        CallOnStrProc('Gerando...');
        if rep.AddNotaFiscal(N, true, true) = nil then
        begin
            N.Checked :=False ;
            CallOnStrProc('NFE não gerada: %s',[rep.ErrMsg]);
            //
            // caso não for gerada!
            // força para a proxima nota
            Continue ;
        end ;

        if codLot = 0 then
        begin
            codlot :=N.m_codseq;
        end ;
        if Terminated then Exit;
    end;

    if (codlot = 0)or(rep.nfe.NotasFiscais.Count =0) then
    begin
        CallOnStrProc('Nenhuma NFE adicionada ao Lote!');
        Self.Terminate ;
        Exit;
    end;

    if rep.nfe.NotasFiscais.Count > 50 then
    begin
        CallOnStrProc('Excedeu o limite máximo de 50 NFE´s!');
        Self.Terminate ;
        Exit;
    end;

    dupl :=0;

    CallOnStrProc('Enviando lote:%d ...',[codlot]);

    //
    // envio
    //
    if rep.OnlySend(codLot) then
    begin
        //
        // lote processado
        //
        if rep.nfe.WebServices.Retorno.NFeRetorno.cStat =TCNotFis00.CSTT_PROCESS then
        begin
            //
            // lopp para reset cada nfe
            //
            for I :=0 to rep.nfe.NotasFiscais.Count -1 do
            begin
                nfe :=rep.nfe.NotasFiscais.Items[I].NFe ;
                N :=m_Lote.IndexOf(OnlyNumber(NFe.infNFe.ID) ) ;
                if N <> nil then
                begin
                    //
                    // reset checagem para posterior
                    // processamento(protocolo)
                    N.Checked :=False ;

                    //
                    // atualiza status
                    CallOnStrProc('Atualizando NFE:%s',[N.m_chvnfe]);
                    N.m_codstt :=nfe.procNFe.cStat ;
                    N.m_motivo :=nfe.procNFe.xMotivo;
                    N.m_verapp :=nfe.procNFe.verAplic;
                    N.m_dhreceb:=nfe.procNFe.dhRecbto;
                    N.m_numreci:=rep.nfe.WebServices.Retorno.NFeRetorno.nRec ;
                    N.m_numprot:=nfe.procNFe.nProt ;
                    N.m_digval :=nfe.procNFe.digVal;
                    CallOnStrProc('%d|%s',[N.m_codstt,N.m_motivo]);
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
        CallOnStrProc('%d|%s',[rep.nfe.WebServices.Retorno.NFeRetorno.cStat,rep.nfe.WebServices.Retorno.NFeRetorno.xMotivo]);

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
                    CallOnStrProc('Consultando protocolo (NFE:%s)',[N.m_chvnfe]);
                    //
                    // Rejeição 204: duplicidade de chave
                    if rep.OnlyCons(N) then
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
                                CallOnStrProc('Desfazendo contingência (NFE:%s)',[N.m_chvnfe]);
                                N.setContinge('', True);
                                N.Load() ;
                                if rep.AddNotaFiscal(N, True, True) <> nil then
                                begin
                                    N.setXML() ;
                                    //
                                    //
                                    CallOnStrProc('Consultando protocolo (NFE:%s)',[N.m_chvnfe]);
                                    if rep.OnlyCons(N) then
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
        CallOnStrProc(rep.ErrMsg) ;
end;


end.
