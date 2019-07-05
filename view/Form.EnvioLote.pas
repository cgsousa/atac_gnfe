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
  FormBase,
  //JEDI
  JvExStdCtrls, JvExExtCtrls, JvExtComponent, JvFooter, JvButton,
  JvRichEdit,
  //TMS
  JvCtrls, AdvPanel, AdvEdit, AdvCombo, AdvGroupBox,
  //
  unotfis00, Thread.NFE;



type
  Tfrm_EnvLote = class(TBaseForm)
    pnl_Footer: TJvFooter;
    btn_Close: TJvFooterBtn;
    btn_Start: TJvFooterBtn;
    btn_Stop: TJvFooterBtn;
    gbx_Opt: TAdvGroupBox;
    cbx_Modelo: TAdvComboBox;
    edt_NSerie: TAdvEdit;
    txt_RichLOG: TRichEdit;
    procedure FormShow(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure btn_StartClick(Sender: TObject);
    procedure btn_StopClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    m_Filter: TNotFis00Filter;
//    m_oLote: TCNotFis00Lote ;
  private
    { Thread }
//    m_Log: TCLog;
    m_Send:  TMySvcThread;//  TCSendLote;
    procedure DoStart ;
    procedure DoStop ;
    procedure OnINI(Sender: TObject);
    procedure OnEND(Sender: TObject);
    procedure OnUpdateStatus(const aStr: string);
  public
    { Public declarations }
    procedure DoResetForm; override ;
    //class function fn_Show(aLote: TCNotFis00Lote): Boolean ;
    //class function fn_Show(const aFilter: TNotFis00Filter): Boolean ;
    class function fn_Show(): Boolean ;
  end;


implementation

{$R *.dfm}

uses StrUtils, DateUtils, DB,
  uTaskDlg, uparam,
  ACBrUtil, pcnNFe, pcnConversao, uACBrNFE ;


{ Tfrm_EnvLote }

procedure Tfrm_EnvLote.btn_CloseClick(Sender: TObject);
begin
    Self.Close ;

end;

procedure Tfrm_EnvLote.btn_StartClick(Sender: TObject);
begin
    if edt_NSerie.IntValue < 1 then
    begin
        CMsgDlg.Info('O Número do caixa deve ser informado!') ;
        edt_NSerie.SetFocus;
        exit;
    end;
    //
    //
    case cbx_Modelo.ItemIndex of
        00: m_Filter.codmod :=55 ;
        01: m_Filter.codmod :=65 ;
    else
        m_Filter.codmod :=00;
    end;
    m_Filter.nserie :=edt_NSerie.IntValue ;
    m_Filter.save :=FindCmdLineSwitch('sql', ['-', '\', '/'], true) ;

    //
    // stop tarefa caso ativada!
    if Assigned(m_Send) then
    begin
        DoStop;
    end ;
    //
    // start a tarefa
    DoStart ;

    ActiveControl :=txt_RichLOG;

    {if m_Filter.codmod =0 then
    begin
        m_Filter.codmod :=55 ;
    end;

    repeat
        if Assigned(m_Send) then
        begin
            DoStop;
        end ;
        //
        // start a tarefa
        DoStart ;

        ActiveControl :=txt_RichLOG;

        while Assigned(m_Send) do ;

        m_Filter.codmod :=m_Filter.codmod +10 ;

    until (m_Filter.codmod > 65) ;}
end;

procedure Tfrm_EnvLote.btn_StopClick(Sender: TObject);
begin
    if Assigned(m_Send) then
    begin
        if(not m_Send.Terminated)and CMsgDlg.Warning('A Tarefa esta em execução! Deseja terminar a mesma?',True) then
        begin
            //
            // stop manual
            DoStop ;
        end;
    end ;
end;

procedure Tfrm_EnvLote.DoResetForm;
var
  rep: IBaseACBrNFE ;
begin
    //
    // repositorio da NFE
    rep :=TCBaseACBrNFE.New(False) ;

    //
    //

    //
    // inicializa filtro fech CX
    m_Filter.Create(0, 0);
    m_Filter.filTyp :=ftFech ;
    m_Filter.codmod :=rep.CodMod;
    m_Filter.nserie :=rep.nSerie;
    m_Filter.limlot :=rep.param.send_lotqtdnfe.Value;

    {case m_Filter.codmod of
        65: cbx_Modelo.ItemIndex :=1;
        55: cbx_Modelo.ItemIndex :=0;
    else
        cbx_Modelo.ItemIndex :=2;
    end;}
    gbx_Opt.Caption :=Format(' Opções do CAIXA (Qde parametrizada de NFE no lote: %d)',[m_Filter.limlot]) ;
    cbx_Modelo.ItemIndex:=2;
    edt_NSerie.IntValue :=m_Filter.nserie ;


    txt_RichLOG.Clear ;
end;

procedure Tfrm_EnvLote.DoStart;
begin

    //
    // start manual
    //m_Send :=TCSendLote.Create(vst_Grid1, m_oLote, m_Filter) ;
    m_Send :=TMySvcThread.Create(m_Filter) ;
    m_Send.OnBeforeExecute :=OnINI;
    m_Send.OnTerminate :=OnEND;
    m_Send.OnStrProc :=OnUpdateStatus;
    m_Send.Start ;
end;

procedure Tfrm_EnvLote.DoStop;
begin
    m_Send.Terminate;
    m_Send.WaitFor;
    FreeAndNil(m_Send);
end;

class function Tfrm_EnvLote.fn_Show(): Boolean ;
var
  F: Tfrm_EnvLote ;
begin
    F :=Tfrm_EnvLote.Create(Application) ;
    try
        //F.m_Filter :=aFilter ;
        //F.m_oLote :=TCNotFis00Lote.Create ;
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
    //
    // start a thread
    btn_Start.Click ;

end;

procedure Tfrm_EnvLote.OnEND(Sender: TObject);
begin
    btn_Start.Enabled :=True;
    btn_Stop.Enabled  :=False;
    gbx_Opt.Enabled :=True;
    OnUpdateStatus('Tarefa terminada.');
end;

procedure Tfrm_EnvLote.OnINI(Sender: TObject);
var
  L: TCNotFis00Lote;
  N: TCNotFis00 ;
  cs: NotFis00CodStatus ;
  codlot: Integer ;
begin
    //
    // set UI controles
    btn_Start.Enabled :=False;
    btn_Stop.Enabled  :=True ;
    gbx_Opt.Enabled :=False;
    txt_RichLOG.Clear ;
    OnUpdateStatus('Tarefa iniciada');

    //
    // inicializa lote
    codlot :=0;
    L :=TCNotFis00Lote.Create ;
    try
        if L.Load(m_Filter) then
        begin
            for N in L.Items do
            begin
                //
                // set lote
                if N.ItemIndex =0 then
                begin
                    codlot :=N.m_codseq;
                    OnUpdateStatus(Format('Inicializando lote[%d]',[codlot]));
                end;
                //
                // reset consumo indevido
                if N.m_codstt =cs.ERR_CONSUMO_INDEVIDO then
                begin
                    //N.setConsumoWS ;
                    OnUpdateStatus(Format(#9'Reset consumo indevido: NFE[%s]',[N.m_chvnfe]));
                end;
                //
                // aloca as NF´s para o respectivo lote
                N.setCodLote(codlot);
                OnUpdateStatus(Format(#9'Vincula NFE[%s] ao lote[%d]',[N.m_chvnfe,codlot]));
            end;
            //
            //
            if codlot > 0 then
            begin
                m_Filter.codlot :=codlot ;
            end;
        end;
    finally
        L.Free ;
    end;
end;

procedure Tfrm_EnvLote.OnUpdateStatus(const aStr: string);
var
  clr: TColor;
  txt: string;
begin
    //setStatus(aStr);

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

//    if Pos('Erro', txt) > 0 then
//        txt_Log.AddFormatText('', [], 'Trebuchet MS', clRed)
//    else
//        txt_Log.AddFormatText('', [], 'Trebuchet MS', clWindowText);
//    txt_Log.Lines.Add(txt);
//    txt_Log.Perform(EM_SCROLLCARET, 0, 0); //::garantir a exibição é correto

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


end.
