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
  Dialogs, StdCtrls, Mask, ExtCtrls,

  //JEDI
  JvExStdCtrls, JvExExtCtrls, JvExtComponent, JvCtrls, JvButton, JvFooter,
  //TMS
  AdvPanel, HTMLabel ,
  //
  VirtualTrees, uVSTree,
  //
  FormBase,
  unotfis00,
  uclass, ulog ;

type
  TCSendLote = class(TCThreadProcess)
  private
    m_Grid: TVirtualStringTree ;
    m_Lote: TCNotFis00Lote ;
    m_OnStatus: TGetStrProc;
    m_Status: string ;
    procedure DoStatus;
    procedure DoLoadGrid;
  protected
    procedure RunProc; override;
    procedure VisualStatus(const aStr: string);
  public
    constructor Create(aGrid: TVirtualStringTree; aLote: TCNotFis00Lote);
    property OnStatus: TGetStrProc read m_OnStatus write m_OnStatus;
  end;




type
  Tfrm_EnvLote = class(TBaseForm)
    pnl_Footer: TJvFooter;
    btn_OK: TJvFooterBtn;
    btn_Close: TJvFooterBtn;
    vst_Grid1: TVirtualStringTree;
    html_Status: THTMLabel;
    HTMLabel1: THTMLabel;
    btn_Start: TJvFooterBtn;
    btn_Stop: TJvFooterBtn;
    procedure FormShow(Sender: TObject);
    procedure vst_Grid1Checked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vst_Grid1GetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure btn_OKClick(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure btn_StartClick(Sender: TObject);
    procedure btn_StopClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    m_oLote: TCNotFis00Lote ;
    procedure m_LoadGrid() ;
    procedure m_UpdateStatus(const aStr: string);
  private
    { Thread }
    m_Send: TCSendLote;
    procedure OnINI(Sender: TObject);
    procedure OnEND(Sender: TObject);
    procedure OnUpdateStatus(const aStr: string);
  public
    { Public declarations }
    class function fn_Show({aLote: TCNotFis00Lote}): Boolean ;
  end;


implementation

{$R *.dfm}

uses StrUtils, DateUtils, DB,
  uTaskDlg, uparam ,
  ACBrUtil, pcnNFe, pcnConversao,
  FDM.NFE ;


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
    if not Assigned(m_Send) then
    begin
        //
        // start manual
        m_Send :=TCSendLote.Create(vst_Grid1, m_oLote) ;
        m_Send.OnBeforeExecute :=OnINI;
        m_Send.OnTerminate :=OnEND;
        m_Send.OnStatus :=OnUpdateStatus;
        m_Send.Start  ;
    end
    else
        CMsgDlg.Warning('A Tarefa já esta criada!') ;
end;

procedure Tfrm_EnvLote.btn_StopClick(Sender: TObject);
begin
    if Assigned(m_Send) then
    begin
        if CMsgDlg.Warning('A Tarefa esta em execução! Deseja termina-la?', True) then
        begin
            //
            // stop manual
            m_Send.Terminate;
            m_Send.WaitFor;
            FreeAndNil(m_Send);
        end;
    end
    else
        CMsgDlg.Warning('A Tarefa não foi criada!') ;
end;

class function Tfrm_EnvLote.fn_Show({aLote: TCNotFis00Lote}): Boolean;
var
  F: Tfrm_EnvLote ;
begin
    F :=Tfrm_EnvLote.Create(Application) ;
    try
        //F.m_oLote :=aLote ;
        F.vst_Grid1.Clear ;
        Result :=F.ShowModal =mrOk ;
    finally
        FreeAndNil(F);
    end;
end;

procedure Tfrm_EnvLote.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    if Assigned(m_Send)and(not m_Send.Terminated) then
    begin
        CMsgDlg.Warning('A Tarefa esta em execução!');
        CanClose :=False ;
    end;
end;

procedure Tfrm_EnvLote.FormCreate(Sender: TObject);
begin
    m_oLote :=TCNotFis00Lote.Create ;

end;

procedure Tfrm_EnvLote.FormShow(Sender: TObject);
begin
    m_LoadGrid() ;
    ActiveControl :=vst_Grid1 ;
    HTMLabel1.HTMLText.Clear ;
    HTMLabel1.HTMLText.Add(
      Format('<P><b>ATENÇÃO!</b> Verifique na listagem abaixo, as <b>%d</b> NFE´s que serão enviadas de uma so vez</P>',[vst_Grid1.RootNodeCount])
    );
    //
    //
    m_UpdateStatus('Aguardando confirmação!');
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
    html_Status.HTMLText.Clear;
    html_Status.HTMLText.Add(Format('<P align="left"><B>%s</B></P>',[aStr]));
    html_Status.Refresh ;
end;

procedure Tfrm_EnvLote.OnEND(Sender: TObject);
begin
    btn_Start.Enabled :=True;
    btn_Stop.Enabled  :=False;
    setStatus('Thread terminada');
end;

procedure Tfrm_EnvLote.OnINI(Sender: TObject);
begin
    btn_Start.Enabled :=False;
    btn_Stop.Enabled  :=True ;
    btn_OK.Enabled :=False;
    setStatus('Thread iniciada');
end;

procedure Tfrm_EnvLote.OnUpdateStatus(const aStr: string);
begin
    setStatus(aStr);

end;

procedure Tfrm_EnvLote.vst_Grid1Checked(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  N: TCNotFis00 ;
begin
    N :=m_oLote.Items[Node.Index] ;
    N.Checked :=Node.CheckState =csCheckedNormal;
end;


procedure Tfrm_EnvLote.vst_Grid1GetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  N: TCNotFis00 ;
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

{ TCSendLote }

constructor TCSendLote.Create(aGrid: TVirtualStringTree; aLote: TCNotFis00Lote);
begin
    m_Grid :=aGrid ;
    m_Lote :=aLote ;
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

        P :=m_Grid.AddChild(nil) ;
        N.Checked :=True ;
        P.CheckType :=ctCheckBox ;
        P.CheckState:=csCheckedNormal ;
    end;
    m_Grid.IndexItem :=0;
    //m_Grid.Refresh ;
end;

procedure TCSendLote.DoStatus;
begin
    if Assigned(m_OnStatus) then
    begin
        OnStatus(m_Status);
    end;
end;

procedure TCSendLote.RunProc;
var
  rep: Tdm_nfe ;
  N: TCNotFis00;
  nfe: TNFe;
var
  S: string ;
  codlot,dupl,I: Integer;
begin

    if not Assigned(m_Lote) then
    begin
        DoTerminate ;
        Exit ;
    end;

    rep :=Tdm_nfe.getInstance ;
    rep.setStatusChange(false); //desabilita status de processamento

    VisualStatus('Carregando notas'#13#10'Aguarde...');
    if m_Lote.LoadCX(rep.NSerie, S) then
    begin
        Synchronize(DoLoadGrid);
    end
    else begin
        VisualStatus('Nenhuma nota encontrada!');
    end;

    for N in m_Lote.Items do
    begin
        if N.m_codstt <>TCNotFis00.CSTT_EMIS_CONTINGE then
        begin
            VisualStatus(Format('Atualizando NF:%d',[N.m_numdoc]));
            if not N.UpdateNFe(now, Ord(rep.ProdDescrRdz), Ord(rep.ProdCodInt), S) then
            begin
                VisualStatus(S);
                N.Checked :=False;
                Continue ;
            end ;
        end;
        VisualStatus('');

        if rep.AddNotaFiscal(N) = nil then
        begin
            N.Checked :=False ;
            Continue ;
        end ;

        if codLot = 0 then
        begin
            codlot :=N.m_codseq;
        end ;
        if Terminated then Exit;
    end;

    if rep.m_NFE.NotasFiscais.Count <= 0 then
    begin
        Exit;
    end;

    if rep.m_NFE.NotasFiscais.Count > 50 then
    begin
        VisualStatus('Excedeu o limite máximo de 50 NFE´s!');
        Exit;
    end;

    dupl :=0;

    VisualStatus('Enviando lote'#13#10'Aguarde...');

    //
    // envio
    //
    if rep.OnlySend(codLot) then
    begin
        //
        // lote processado
        //
        if rep.Retorno.NFeRetorno.cStat =TCNotFis00.CSTT_PROCESS then
        begin
            //
            // lopp para reset cada nfe
            //
            for I :=0 to rep.m_NFE.NotasFiscais.Count -1 do
            begin
                nfe :=rep.m_NFE.NotasFiscais.Items[I].NFe ;
                N :=m_Lote.IndexOf(OnlyNumber(NFe.infNFe.ID) ) ;
                if N <> nil then
                begin
                    //
                    // reset checagem para posterior
                    // processamento(protocolo)
                    N.Checked :=False ;

                    //
                    // atualiza status
                    VisualStatus(Format('Atualizando NFE:%s',[N.m_chvnfe]));
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
                        Inc(dupl) ;
                    end;

                end;
                if Terminated then Exit;
            end;
        end ;
        VisualStatus(Format('%d|%s',[rep.Retorno.NFeRetorno.cStat,rep.Retorno.NFeRetorno.xMotivo]));

        //
        // check NF com duplicidade
        // para consulta de protocolo
        if dupl > 0 then
        begin
            VisualStatus(Format('%d nota(s) com duplicidade!',[dupl]));

            for N in m_Lote.Items do
            begin
                if N.Checked then
                begin
                    VisualStatus(Format('Consultando protocolo (NFE:%s)',[N.m_chvnfe]));
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
                                VisualStatus(Format('Desfazendo contingência (NFE:%s)',[N.m_chvnfe]));
                                N.setContinge('', True);
                                N.Load() ;
                                if rep.AddNotaFiscal(N, True) <> nil then
                                begin
                                    N.setXML() ;
                                    //
                                    //
                                    VisualStatus(Format('Consultando protocolo (NFE:%s)',[N.m_chvnfe]));
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
        VisualStatus(rep.ErrMsg) ;
end;

procedure TCSendLote.VisualStatus(const aStr: string);
begin
    m_Status :=aStr ;
    Synchronize(DoStatus);
end;

end.
