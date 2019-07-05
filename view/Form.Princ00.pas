{***
* View para utilizar as chamadas do Serviço da NF-e
* Atac Sistemas
* Todos os direitos reservados
* Autor: Carlos Gonzaga
* Data: 18.10.2017
*}
unit Form.Princ00;

{*
******************************************************************************
|* PROPÓSITO: Registro de Alterações
******************************************************************************

Símbolo : Significado

[+]     : Novo recurso
[*]     : Recurso modificado/melhorado
[-]     : Correção de Bug (assim esperamos)

26.06.2019
[*] Mais 2(Autorizado Uso, Uso Denegado) no filtro situação

27.05.2019
[*] Alinhamento: pnl_Filter[alLeft] e vst_Grid1[alClient]
    Troca do html_Status ==> AdvStatusBar1

24.05.2019
[+] Novo button <btn_SendAsync> para envio de LOTE
    checkbox <chk_EnvLote> descontinuado
[*] O button <btn_Send> somente autoriza uma unica nfe
[*] Agrupamento das Actions DANFE, Rel. Detalhe/Resumo e Exportar XML
    no PopupMenu<pm_Rel> chamado do button <btn_RelNF>

17.05.2019
[+] Novo atalho(Ctrl+D) chamada do rel resumo de NF (Form.RelNFRL02)

24.08.2018
[+] Inclusao da Carta de Correção Eletronica (CC-e)

10.08.2018
[+] Nova tela que mostra os itens da NFE (butão Itens)

24.07.2018
[*] Butão (protocolo) agora esta acessivel em todas as situações

25.05.2018
[*] Separado o envio (sincrono/assicrono) de lote

24.05.2018
[+] Novo atalho(Ctrl+P) para abilitar o consulta protocolo

17.05.2018
[+] Incluido ajuda (F1), atalho do gerenciador

*}


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ExtCtrls, ActnList, Menus,
  FormBase,
  //JEDI
  JvExStdCtrls, JvExExtCtrls, JvExtComponent, JvCtrls,
  JvFooter, JvToolEdit, JvGroupBox, JvButton, JvAppInst, JvExMask, uJVCL,
  //TMS
  AdvPanel, AdvEdit, AdvGlowButton, AdvOfficeButtons, AdvGroupBox, AdvCombo,
  AdvToolBar, AdvMenus, AdvOfficeStatusBar, AdvOfficeStatusBarStylers,
  uStatusBar,
  //
  VirtualTrees, uVSTree,
  //
  uACBrNFE, unotfis00, uclass ;


type
  TRunProcTyp = (rtExport, rtLoad);
  TCRunProc = class(TCThreadProcess)
  private
    m_RunTyp: TRunProcTyp;
    m_Lote: TCNotFis00Lote;
  private
    procedure runLoad ;
  private
    m_totSucess, m_totError: Integer ;
    m_Local: string ;
    procedure runXML;
  protected
    procedure Execute; override;
  public
    property totSucess: Integer read m_totSucess ;
    property totError: Integer read m_totError;
    constructor Create(aRunTyp: TRunProcTyp; aLote: TCNotFis00Lote);
  end;


type
  Tfrm_Princ00 = class(TBaseForm)
    pnl_Footer: TJvFooter;
    btn_Config: TJvFooterBtn;
    btn_Close: TJvFooterBtn;
    btn_ConsSvc: TJvFooterBtn;
    vst_Grid1: TVirtualStringTree;
    pnl_Filter: TAdvPanel;
    btn_Filter: TJvFooterBtn;
    gbx_DtEmis: TAdvGroupBox;
    edt_DatIni: TJvDateEdit;
    edt_DatFin: TJvDateEdit;
    rgx_Status: TAdvOfficeRadioGroup;
    btn_Exec: TJvImgBtn;
    btn_Items: TJvFooterBtn;
    btn_Send: TJvFooterBtn;
    btn_Cons: TJvFooterBtn;
    btn_Evento: TJvFooterBtn;
    btn_Inut: TJvFooterBtn;
    btn_SendAsync: TJvFooterBtn;
    gbx_CodPed: TAdvGroupBox;
    edt_PedIni: TAdvEdit;
    edt_PedFin: TAdvEdit;
    Label1: TLabel;
    chk_ChvNFe: TAdvOfficeCheckBox;
    btn_RelNF: TJvFooterBtn;
    cbx_Ordem: TAdvComboBox;
    chk_Desc: TAdvOfficeCheckBox;
    gbx_ModSer: TAdvGroupBox;
    cbx_Modelo: TAdvComboBox;
    edt_NSerie: TAdvEdit;
    AppInstances1: TJvAppInstances;
    ActionList1: TActionList;
    act_CancNFE: TAction;
    act_CCE: TAction;
    pm_Evento: TAdvPopupMenu;
    AdvMenuStyler1: TAdvMenuStyler;
    mnu_CancNFE: TMenuItem;
    mnu_CCE: TMenuItem;
    pm_Rel: TAdvPopupMenu;
    act_ListDetalh: TAction;
    act_ListResumo: TAction;
    ListagemDetalhe1: TMenuItem;
    ListagemResumo1: TMenuItem;
    N1: TMenuItem;
    act_DANFE: TAction;
    DANFeDANFCe1: TMenuItem;
    N2: TMenuItem;
    act_Export: TAction;
    actExport1: TMenuItem;
    AdvOfficeStatusBar1: TAdvOfficeStatusBar;
    AdvOfficeStatusBarOfficeStyler1: TAdvOfficeStatusBarOfficeStyler;
    pnl_Help: TAdvPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_FilterClick(Sender: TObject);
    procedure btn_ExecClick(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure vst_Grid1Change(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure btn_ConsClick(Sender: TObject);
    procedure btn_InutClick(Sender: TObject);
    procedure btn_ConsSvcClick(Sender: TObject);
    procedure vst_Grid1HeaderClick(Sender: TVTHeader;
      HitInfo: TVTHeaderHitInfo);
    procedure chk_ChvNFeClick(Sender: TObject);
    procedure btn_ConfigClick(Sender: TObject);
    procedure btn_ItemsClick(Sender: TObject);
    procedure act_CCEExecute(Sender: TObject);
    procedure act_CancNFEExecute(Sender: TObject);
    procedure act_ListDetalhExecute(Sender: TObject);
    procedure act_DANFEExecute(Sender: TObject);
    procedure act_ExportExecute(Sender: TObject);
    procedure btn_SendClick(Sender: TObject);
    procedure btn_SendAsyncClick(Sender: TObject);
    procedure pnl_HelpCaptionClick(Sender: TObject);
  private
    { Private declarations }
    m_Service: Boolean ;
    m_Filter: TNotFis00Filter;
    m_Lote: TCNotFis00Lote;
    m_Rep: IBaseACBrNFE;
    m_proDescri, m_proCodInt: Boolean ;
//    procedure OnButtonDraw(Sender: TObject;
//      const DrawItemStruct: tagDRAWITEMSTRUCT);
    procedure OnFormatText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);

    procedure OnPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);

    function LoadGrid(): Boolean;

    procedure OnGenSerial(Sender: TObject);

  private
    { Thread }
    m_Run: TCRunProc;
    m_Local: string ;
    procedure DoStop;
    procedure OnINI(Sender: TObject);
    procedure OnFIN(Sender: TObject);
    procedure OnStatus(const aStr: string);

  private
    { StatusBar }
    m_StatusBar: TCStatusBarWidget;
    m_panelAmb: TAdvOfficeStatusPanel ;
    m_panelItems: TAdvOfficeStatusPanel ;
    m_panelVTotal: TAdvOfficeStatusPanel ;
    m_panelProgress: TAdvOfficeStatusPanel ;
    m_panelText: TAdvOfficeStatusPanel ;
    procedure setStatusBar(const aPos: Int64 =0) ;
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    function ChkPwd(const aInput: string): Boolean; override ;
  public
    { Public declarations }
  end;

var
  frm_Princ00: Tfrm_Princ00;



implementation

{$R *.dfm}

uses StrUtils, DateUtils, IOUtils , DB, Clipbrd ,
  JvJCLUtils ,
  pcnConversao, pcnConversaoNFe, pcnNFe, pcnAuxiliar, ACBrUtil, ACBrNFeNotasFiscais,
  uadodb, ulog, uTaskDlg, ucademp,
  Form.ParametroList, Form.NFEStatus,
  Form.Justifica, Form.Inutiliza,
  Form.Ajuda, Form.EnvioLote, Form.Items, Form.CCEList,
  Form.GenSerialNFE,
  Form.RelNFRL00, Form.RelNFRL02, Form.ExportXML ;

const
  COL_CHV_NFE =0;
  COL_COD_PED =1;
  COL_COD_MOD =2;
  COL_NUM_SER =3;
  COL_NUM_DOC =4;


{ TCRunProc }

constructor TCRunProc.Create(aRunTyp: TRunProcTyp; aLote: TCNotFis00Lote);
begin
    m_RunTyp :=aRunTyp;
    m_Lote :=aLote ;
    inherited Create(True, False);
end;

procedure TCRunProc.Execute;
begin
    //
    // inicio
    // sincroniza o method(Form.OnINI) da view como inicio de tarefa
    CallOnBeforeExecute;

    case m_RunTyp of
      rtLoad: runLoad ;
      rtExport: runXML;
    end;
end;

procedure TCRunProc.runLoad;
var
  Q: TDataSet;
  fnf0_codseq: TField ;
  N: TCNotFis00;
var
  cmplvl, nPos: Integer;
  vSumNF: Currency;
begin
    //
    // combatibilidade
    cmplvl :=TADOQuery.getCompLevel ;
    if cmplvl > 8 then
        Q :=TCNotFis00Lote.CLoadSPNotFis00Busca(m_Lote.Filter)
    else
        Q :=TCNotFis00Lote.CLoad(m_Lote.Filter) ;
    //
    //
    try
        vSumNF :=0;
        fnf0_codseq :=Q.FieldByName('nf0_codseq') ;
        while not Q.Eof do
        begin
            //
            // calc. o pos e sincroniza com a view
            npos :=Trunc((Q.RecNo / Q.RecordCount)*100 ) ;
            if npos = 0 then npos :=1;
            CallOnIntProc(npos);

            //
            // add uma nova NF
            N :=m_Lote.AddNotFis00(fnf0_codseq.AsInteger) ;
            if cmplvl >8 then
                N.FillDataSet(Q)
            else begin
                N.LoadFromQ(Q);
                N.LoadItems;
            end;

            //
            // totaliza NF
            vSumNF :=vSumNF +N.m_icmstot.vNF;

            //
            // proximo
            Q.Next ;
        end;
        //
        // set total
        m_Lote.vTotalNF :=vSumNF
    finally
        Q.Free ;
    end;
end;

procedure TCRunProc.runXML;
var
  rep: IBaseACBrNFE;
  NF: TCNotFis00;
  N: NotaFiscal ;
var
  P: Integer;
  F: string ;
begin
    //
    // inicializa totalizadores
    m_totSucess :=0;
    m_totError :=0;

    //
    // inicializa repositorio
    rep :=TCBaseACBrNFE.New(False) ;
    m_Local :='';

    for NF in m_Lote.Items do
    begin
        //
        // local
        if m_Local ='' then
        begin
            m_Local :=PathWithDelim(rep.param.arq_SaveXML_RootPath.Value) +'proc';
            m_Local :=rep.nfe.Configuracoes.Arquivos.GetPath(m_Local,'',NF.m_emit.CNPJCPF,NF.m_dtemis);
        end;

        //
        // calc. o pos e sincroniza com a view
        P :=Trunc(((NF.ItemIndex+1) /m_Lote.Items.Count)*100) ;
        if P = 0 then P :=1;
        CallOnIntProc(P);
        //
        // chk notas processadas e/ou canceladas
        if NF.CStatProcess or NF.CstatCancel then
        begin
            if NF.m_chvnfe <> '' then
            begin
                CallOnStrProc('Carregando NFe[%s]',[NF.m_chvnfe]);
                if NF.LoadXML() then
                begin
                    N :=rep.AddNotaFiscal(nil, True) ;
                    if N.LerXML(NF.m_xml) then
                    begin
                        N.NFe.procNFe.tpAmb   :=NF.m_tipamb ;
                        N.NFe.procNFe.verAplic:=NF.m_verapp ;
                        N.NFe.procNFe.chNFe   :=NF.m_chvnfe ;
                        N.NFe.procNFe.dhRecbto:=NF.m_dhreceb;
                        N.NFe.procNFe.nProt   :=NF.m_numprot;
                        N.NFe.procNFe.digVal  :=NF.m_digval ;
                        N.NFe.procNFe.cStat   :=NF.m_codstt ;
                        N.NFe.procNFe.xMotivo :=NF.m_motivo ;
                        CallOnStrProc('Exportando NFe:%s'#13#10'Aguarde...',[NF.m_chvnfe]);
                        N.GerarXML ;
                        F :=Format('%s-procNFe.XML',[NF.m_chvnfe]);
                        N.GravarXML(F, m_Local);
                    end;
                    Inc(m_totSucess) ;
                end
                else begin
                    CallOnStrProc('XML não encontrado!: NFe[%s]',[NF.m_chvnfe]);
                    Inc(m_totError) ;
                end;
            end
            else begin
                CallOnStrProc('NFe[Mod:%d,Série:%.3d,Número:%d]'#13#10'Error',[
                                NF.m_codmod,NF.m_nserie,NF.m_numdoc]);
                Inc(m_totError) ;
            end;
        end;
    end;
end;

{ Tfrm_Princ00 }

procedure Tfrm_Princ00.act_CancNFEExecute(Sender: TObject);
var
  N: TCNotFis00 ;
  just: Tfrm_Justif;
//  rep: IBaseACBrNFE;
  ret: Boolean ;
begin
    just :=NewJustifica(svCancel);
    try
        if just.Execute then
        begin
            N :=m_Lote.Items[vst_Grid1.IndexItem] ;
            setStatus('Processando...');
            //rep :=TCBaseACBrNFE.New() ;
            if m_Rep.OnlyCanc(N, just.Text) then
            begin
                setStatus(Format('%d|%s'#13#10'Gravando Status...',[N.m_codstt,N.m_motivo]));
                N.setStatus();
                CMsgDlg.Info(N.m_motivo) ;
                LoadGrid ;
            end
            else begin
                CMsgDlg.Warning(Format('%d-%s',[m_Rep.ErrCod,m_Rep.ErrMsg])) ;
            end;
        end;
    finally
        FreeAndNil(just);
        setStatus('');
    end;
    ActiveControl :=vst_Grid1 ;
end;

procedure Tfrm_Princ00.act_CCEExecute(Sender: TObject);
var
  N: TCNotFis00 ;
begin
    if vst_Grid1.IndexItem >= 0 then
    begin
        N :=m_Lote.Items[vst_Grid1.IndexItem] ;
        Tfrm_CCEList.lp_Show(N) ;
    end;
    ActiveControl :=vst_Grid1;
end;

procedure Tfrm_Princ00.act_DANFEExecute(Sender: TObject);
var
  N: TCNotFis00 ;
//  rep: IBaseACBrNFE;
begin
    if CMsgDlg.Confirm('Deseja imprimir o DANFE?') then
    begin
        setStatus('Imprimindo...');
        try
            N :=m_Lote.Items[vst_Grid1.IndexItem] ;
            //rep :=TCBaseACBrNFE.New() ;
            if m_Rep.PrintDANFE(N) then
            begin
                CMsgDlg.Info('DANFE impresso com sucesso.') ;
            end
            else begin
                CMsgDlg.Error('DANFE não impresso!') ;
            end;
        finally
            setStatus('');
        end;
    end;
    ActiveControl :=vst_Grid1;
end;

procedure Tfrm_Princ00.act_ExportExecute(Sender: TObject);
begin
    if edt_NSerie.IntValue > 0 then
    begin
        Tfrm_ExportXML.Execute(edt_NSerie.IntValue, edt_DatIni.Date) ;
        {m_Run :=TCRunProc.Create(rtExport, m_Lote);
        m_Run.OnBeforeExecute :=OnINI;
        m_Run.OnTerminate :=OnFIN;
        //m_Run.OnExecute :=OnRunExportXML;
        m_Run.OnStrProc :=OnStatus;
        m_Run.Start  ;}
    end
    else begin
        CMsgDlg.Warning('O número de serie deve ser informado!');
    end;
end;

procedure Tfrm_Princ00.act_ListDetalhExecute(Sender: TObject);
begin
    if TAction(Sender).Tag > 0 then
        Tfrm_RelNFRL02.Execute(m_Lote)
    else
        Tfrm_RelNFRL00.Execute(m_Lote);
end;

procedure Tfrm_Princ00.btn_CloseClick(Sender: TObject);
begin
    Self.Close ;

end;

procedure Tfrm_Princ00.btn_ConfigClick(Sender: TObject);
var
  pwd: string ;
begin
    if not InputQueryDlg('Acesso aos Parametros do Sistema','Informe a senha:', pwd) then
    begin
        Exit;
    end;
    if not ChkPwd(pwd) then
    begin
        CMsgDlg.Warning('Senha inválida!') ;
        Exit;
    end;
    //
    // load parms nfe
    Tfrm_ParametroList.lp_Show('NFE') ;
    CadEmp :=TCCadEmp.New(1) ;
    m_Rep :=TCBaseACBrNFE.New();
    setStatusBar();
end;

procedure Tfrm_Princ00.btn_ConsClick(Sender: TObject);
var
  N: TCNotFis00;
//  rep: IBaseACBrNFE;
begin
    if(vst_Grid1.IndexItem >-1)and CMsgDlg.Confirm('Deseja consultar o Protocolo?')then
    begin
        N :=m_Lote.Items[vst_Grid1.IndexItem] ;

        setStatus('Processando...');
        //rep :=TCBaseACBrNFE.New() ;
        if m_Rep.OnlyCons(N) then
        begin
            setStatus(Format('%d|%s'#13#10'Gravando Status...',[N.m_codstt,N.m_motivo]));
            N.setStatus();
            CMsgDlg.Info(N.m_motivo) ;
            LoadGrid ;
        end
        else begin
            CMsgDlg.Warning(Format('%d-%s',[m_Rep.ErrCod,m_Rep.ErrMsg])) ;
        end;
        setStatus('');
    end;
    ActiveControl :=vst_Grid1;
end;

procedure Tfrm_Princ00.btn_ConsSvcClick(Sender: TObject);
var
  S: string;
  //rep: IBaseACBrNFE ;
begin
    if CMsgDlg.Confirm('Deseja consultar o status do serviço da NFE?') then
    begin
        setStatus('Aguarde'#13#10'Consultando...');
        try
            //rep :=TCBaseACBrNFE.New() ;
            if m_Rep.OnlyStatusSvc() then
            begin
                if m_Rep.ErrCod =107 then
                    CMsgDlg.Info(m_Rep.ErrMsg)
                else
                    CMsgDlg.Warning(m_Rep.ErrMsg) ;
            end
            else
                CMsgDlg.Error(m_Rep.ErrMsg) ;
        finally
            setStatus('');
        end;
    end;
    ActiveControl :=vst_Grid1;
end;

procedure Tfrm_Princ00.btn_ExecClick(Sender: TObject);
begin
    //
    m_Filter.Create(0, 0) ;
    //

    if edt_PedIni.IntValue > 0 then
    begin
        if edt_PedFin.IntValue = 0 then
        begin
            edt_PedFin.IntValue :=edt_PedIni.IntValue;
        end;
        if edt_PedIni.IntValue > edt_PedFin.IntValue then
        begin
            CMsgDlg.Info('Número do pedido inicial maior que número final!') ;
            edt_PedIni.SetFocus;
            Exit;
        end
        else begin
            m_Filter.pedini :=edt_PedIni.IntValue ;
            m_Filter.pedfin :=edt_PedFin.IntValue ;
        end;
    end

    else begin
        m_Filter.datini :=edt_DatIni.Date ;
        m_Filter.datfin :=edt_DatFin.Date + 0.96 ;

        if rgx_Status.ItemIndex =rgx_Status.Items.Count -1 then
            m_Filter.status :=sttNone
        else if rgx_Status.ItemIndex =rgx_Status.Items.Count -2 then
            m_Filter.status :=sttError
        else
            m_Filter.status :=TNotFis00Status(rgx_Status.ItemIndex) ;

//        case rgx_Status.ItemIndex of
//            6: m_Filter.status :=sttNone ;
//            5: m_Filter.status :=sttError;
//        else
//            m_Filter.status :=TNotFis00Status(rgx_Status.ItemIndex) ;
//        end;

        if m_Filter.status =sttNone then
        begin
            if edt_DatIni.Date > edt_DatFin.Date then
            begin
                CMsgDlg.Info('Data inicial maior que data final!') ;
                edt_DatIni.SetFocus;
                exit;
            end;
        end;

        if(edt_NSerie.IntValue > 0)and
          ((cbx_Modelo.ItemIndex <0)or(cbx_Modelo.ItemIndex > 1))then
        begin
            CMsgDlg.Info('O Modelo deve ser selecionado quando informar a série!') ;
            cbx_Modelo.SetFocus;
            exit;
        end;

        case cbx_Modelo.ItemIndex of
            0: m_Filter.codmod :=55 ;
            1: m_Filter.codmod :=65 ;
        end;
        m_Filter.nserie :=edt_NSerie.IntValue ;

    end;

    //
    // set filtro
    m_Filter.save :=FindCmdLineSwitch('sql', ['-', '\', '/'], true) ;
    m_Lote.Filter :=m_Filter ;

    //
    // thread aqui
    m_Run :=TCRunProc.Create(rtLoad, m_Lote);
    m_Run.OnBeforeExecute :=OnINI;
//    m_Run.OnExecute :=OnRunLoad;
    m_Run.OnIntProc :=setStatusBar;
    m_Run.OnTerminate :=OnFIN;
    m_Run.Start  ;

    {if LoadGrid then
    begin
        btn_FilterClick(nil);
        btn_Items.Enabled :=True;
        btn_RelNF.Enabled :=True ;
        btn_Cons.Enabled :=True  ;
        act_export.Enabled :=True;
    end
    else begin
        CMsgDlg.Info('Nenhuma nota encontrada neste filtro!') ;
        ActiveControl :=edt_PedIni;
        btn_Items.Enabled :=False;
        btn_Send.Enabled :=False;
        btn_Cons.Enabled :=False;
        btn_RelNF.Enabled :=False;
        act_export.Enabled :=True;
    end;}

end;

procedure Tfrm_Princ00.btn_FilterClick(Sender: TObject);
begin
    pnl_Filter.Visible :=not pnl_Filter.Visible ;
end;

procedure Tfrm_Princ00.btn_InutClick(Sender: TObject);
var
  N: TCNotFis00 ;
begin
    if vst_Grid1.RootNodeCount > 0 then
    begin
        N :=m_Lote.Items[vst_Grid1.IndexItem] ;
    end
    else
        N :=nil ;

    Tfrm_Inutiliza.CF_Show(N) ;

    LoadGrid ;
end;

procedure Tfrm_Princ00.btn_ItemsClick(Sender: TObject);
var
  N: TCNotFis00 ;
begin
    if vst_Grid1.IndexItem > -1 then
    begin
        N :=m_Lote.Items[vst_Grid1.IndexItem] ;
        Tfrm_Items.pc_Show(N);
    end
    else
        CMsgDlg.Warning('Selecione uma NF!')
        ;

    ActiveControl :=vst_Grid1;
end;

procedure Tfrm_Princ00.btn_SendAsyncClick(Sender: TObject);
begin
    //
    // se confirmou, atualiza grid
    if Tfrm_EnvLote.fn_Show() then
    begin
        LoadGrid ;
    end;
end;

procedure Tfrm_Princ00.btn_SendClick(Sender: TObject);
var
  N: TCNotFis00 ;
//  rep: IBaseACBrNFE;
  S: string;
  ret: Boolean ;
begin
    if CMsgDlg.Confirm('Deseja Autorizar o USO da NF?') then
    begin
        N :=m_Lote.Items[vst_Grid1.IndexItem] ;
        try
            //rep :=TCBaseACBrNFE.New() ;
            setStatus(Format('Atualizando NF(%d)',[N.m_codped]));
            if N.UpdateNFe(now, ord(m_Rep.param.xml_prodescri_rdz.Value),ord(m_Rep.param.xml_procodigo_int.Value), S) then
            begin
                setStatus('Processando NF...');
                if m_Rep.OnlySend(N) then
                begin
                    setStatus(Format('%d|%s'#13#10'Gravando Status...',[N.m_codstt,N.m_motivo]));
                    N.setStatus();
                    CMsgDlg.Info(N.m_motivo) ;
                    LoadGrid ;
                end
                else
                    CMsgDlg.Warning(m_Rep.ErrMsg);
            end
            else
                CMsgDlg.Warning(S);
        finally
            setStatus('');
        end;
    end;
    ActiveControl :=vst_Grid1 ;
end;

function Tfrm_Princ00.ChkPwd(const aInput: string): Boolean;
var
  dd,mm,yy, sum: Word ;
begin
    DecodeDate(Date, yy, mm, dd);
    sum :=yy mod 2000;
    sum :=sum +mm +dd;
    Result :=(sum *9) =StrToIntDef(aInput, 0) ;
end;

procedure Tfrm_Princ00.chk_ChvNFeClick(Sender: TObject);
var
  Cols: TVirtualTreeColumns;
begin
    Cols :=vst_Grid1.Header.Columns;
    if chk_ChvNFe.Checked then
    begin
        Cols[0].Options :=Cols[0].Options +[coVisible];
        Cols[1].Options :=Cols[1].Options -[coFixed];
        Cols[1].Color   :=Cols[2].Color ;
    end
    else begin
        Cols[0].Options :=Cols[0].Options -[coVisible];
        Cols[1].Options :=Cols[1].Options +[coFixed];
        Cols[1].Color   :=Cols[0].Color ;
    end;
end;

procedure Tfrm_Princ00.DoStop;
begin
    m_Run.Terminate;
    m_Run.WaitFor;
    FreeAndNil(m_Run);
end;
{
procedure Tfrm_Princ00.DoUpdateProcess(const AText: string);
begin
    if AText <> '' then
    begin
        htm_Process.HTMLText.Clear ;
        //TMS <b>HTML</b> label <P align="center"></P>
        htm_Process.HTMLText.Add(Format('<B>%s</B>',[AText]));
        htm_Process.HTMLText.Add('<P align="center"></P>');
        pnl_Process.BringToFront ;
        pnl_Process.Refresh ;
        Screen.Cursor :=crHourGlass;
    end
    else begin
        Screen.Cursor :=crDefault;
        pnl_Process.SendToBack;
    end;
end;
}

procedure Tfrm_Princ00.FormCreate(Sender: TObject);
begin
    m_Service :=False ;
    m_Lote :=TCNotFis00Lote.Create ;

    TCExeInfo.getInstance.GetVersionInfoOfApp(Application.ExeName);
    Self.Caption :=Format('%s(Ver.:%d.%d.%d%d)',[ Self.Caption,
                                                  TCExeInfo.getInstance.MajorVersion ,
                                                  TCExeInfo.getInstance.MinorVersion ,
                                                  TCExeInfo.getInstance.ReleaseNumber,
                                                  TCExeInfo.getInstance.BuildNumber
                                                 ]);
    AppInstances1.Active :=True;
    //
    //
    m_StatusBar :=TCStatusBarWidget.Create(AdvOfficeStatusBar1, False);
    m_panelAmb:=m_StatusBar.AddPanel(psHTML, '', 90, taCenter) ;
    m_panelItems:=m_StatusBar.AddPanel(psHTML, '', 80, taCenter) ;
    m_panelVTotal:=m_StatusBar.AddPanel(psHTML, '', 140, taRightJustify) ;
    m_panelProgress:=m_StatusBar.AddPanel(psProgress, '', 250) ;
    m_panelText:=m_StatusBar.AddPanel(psHTML) ;

    ConnectionADO :=NewADOConnFromIniFile('Configuracoes.ini') ;
    ConnectionADO.Connected :=True;

    Empresa :=TCEmpresa.Instance ;
    Empresa.DoLoad(1);

    CadEmp:=TCCadEmp.New(1) ;
    m_Rep :=TCBaseACBrNFE.New();

end;

procedure Tfrm_Princ00.FormDestroy(Sender: TObject);
begin
    m_Lote.Destroy ;

end;

procedure Tfrm_Princ00.FormShow(Sender: TObject);
// quando é executa como Aplicativo, usa o show para dar inicio ao funcinamento
begin
    m_Service :=False ;

    vst_Grid1.Clear ;
    vst_Grid1.OnBeforeCellPaint :=vst_Grid1.DoCellPaint;
    vst_Grid1.OnGetText :=OnFormatText;
    vst_Grid1.OnPaintText :=OnPaintText;

    edt_PedIni.Clear;
    edt_PedFin.Clear;
    edt_DatIni.Date :=Date;
    edt_DatFin.Date :=edt_DatIni.Date;

    ActiveControl :=edt_PedIni;

    //DoEnabledControls(pnl_Footer, False);
    btn_Items.Enabled :=False;
    btn_Send.Enabled :=False;
    btn_Cons.Enabled :=False;
    btn_Evento.Enabled :=False;
    act_DANFE.Enabled :=False;
    act_export.Enabled :=False;
    btn_RelNF.Enabled :=False;

//    btn_Filter.m_ShortCut :='F2';
//    btn_Items.m_ShortCut :='Alt+I';

    setStatusBar();

    pnl_Help.Visible :=False ;

end;

procedure Tfrm_Princ00.KeyDown(var Key: Word; Shift: TShiftState);
var
  N: TCNotFis00 ;
  rep: IBaseACBrNFE;
  nfe: NotaFiscal;
  chave,conf,F: string;
begin

    case Key of
        VK_F1: pnl_Help.Visible :=not pnl_Help.Visible ;
        VK_F2: btn_Filter.Click ;
        VK_F5: if btn_Exec.Visible then btn_Exec.Click ;
    end;

    // Alt press
    // cria um serial (sequencia) da NFe/NFCe
    if (ssAlt in Shift)and(Key =Ord('X'))or(Key =Ord('x'))then
    begin
        OnGenSerial(nil);
    end;

    //
    // Ctrl presss
    //
    if (ssCtrl in Shift)then
    begin
        if vst_Grid1.IndexItem < 0 then
        begin
            CMsgDlg.Warning('Selecione uma NF') ;
            Exit ;
        end;

        //
        // seleciona NF do Grid
        N :=m_Lote.Items[vst_Grid1.IndexItem] ;

        //
        // Copia chave
        //
        if(Key =Ord('C'))or(Key =Ord('c')) then
        begin
            Clipboard.AsText :=N.m_chvnfe ;
            CMsgDlg.Info('Chave copiada para área de transferencia') ;
        end;

        //
        // Exporta NF em qr situação!
        //
        if(Key =Ord('E'))or(Key =Ord('e')) then
        begin
            if not InputQueryDlg('Confirmar senha','Informe a senha:',conf) then
            begin
                Exit;
            end;
            if not ChkPwd(conf) then
            begin
                CMsgDlg.Warning('Senha inválida!') ;
                Exit;
            end;

            rep :=TCBaseACBrNFE.New() ;
            if not N.LoadXML then
            begin
                nfe :=rep.AddNotaFiscal(N, True) ;
                if nfe <> nil then
                    N.setXML()
                else begin
                    CMsgDlg.Error('NFE não gerada: %s',[rep.ErrMsg]) ;
                    Exit;
                end;
            end
            else begin
                nfe :=rep.AddNotaFiscal(nil, True) ;
                if not nfe.LerXML(N.m_xml) then
                begin
                    CMsgDlg.Warning('XML inválido!') ;
                    Exit;
                end;
            end;
            //
            // chk NF se process
            if N.CStatProcess or N.CStatCancel then
            begin
                //
                // add info de protocolo
                nfe.NFe.procNFe.tpAmb   :=N.m_tipamb ;
                nfe.NFe.procNFe.verAplic:=N.m_verapp ;
                nfe.NFe.procNFe.chNFe   :=N.m_chvnfe ;
                nfe.NFe.procNFe.dhRecbto:=N.m_dhreceb;
                nfe.NFe.procNFe.nProt   :=N.m_numprot;
                nfe.NFe.procNFe.digVal  :=N.m_digval ;
                nfe.NFe.procNFe.cStat   :=N.m_codstt ;
                nfe.NFe.procNFe.xMotivo :=N.m_motivo ;
                F :=Format('%s-procNFe.XML',[N.m_chvnfe]);
            end
            else
                F :=Format('%s-NFe.XML',[N.m_chvnfe]);
            nfe.GerarXML ;
            nfe.GravarXML(F, ApplicationPath);
            CMsgDlg.Info('XML gravado em %s',[ApplicationPath]) ;
        end;

        //
        // Corrige Chave/XML com bug do sistema
        //
        if(Key =Ord('K'))or(Key =Ord('k')) then
        begin
            rep :=TCBaseACBrNFE.New() ;
            if N.Items.Count = 0 then
            begin
                N.LoadItems ;
                N.LoadFormaPgto ;
            end;

            nfe :=rep.AddNotaFiscal(N, True) ;
            if nfe <> nil then
            begin
                N.setXML() ;
                CMsgDlg.Info('XML/Chave gerado com sucesso') ;
            end
            else begin
                CMsgDlg.Error('NFE não gerada: %s',[rep.ErrMsg]) ;
                Exit;
            end;
        end;

        //
        // envio da NFE por email
        //
        if(Key =Ord('S'))or(Key =Ord('s')) then
        begin
            if N.CStatProcess then
            begin
                rep :=TCBaseACBrNFE.New() ;
                if rep.SendMail(N, '') then
                    CMsgDlg.Info(rep.ErrMsg)
                else
                    CMsgDlg.Warning(rep.ErrMsg) ;
            end;
        end;

    end
    else
        inherited;
end;

function Tfrm_Princ00.LoadGrid: Boolean;
begin
    vst_Grid1.Clear ;
    setStatus('Carregando Notas Fiscais'#13#10'Aguarde...',crSQLWait);
    try
      m_Filter.save :=FindCmdLineSwitch('sql', ['-', '\', '/'], true) ;
      Result :=m_Lote.Load(m_Filter);
      if Result then
      begin
          vst_Grid1.RootNodeCount :=m_Lote.Items.Count ;
          vst_Grid1.IndexItem :=0;
          vst_Grid1.Refresh ;

          ActiveControl :=vst_Grid1;
          act_export.Enabled :=True;
      end;

    finally
      setStatus('');
    end;
end;

procedure Tfrm_Princ00.OnFIN(Sender: TObject);
var
  run: TCRunProc ;
begin
    run :=TCRunProc(Sender) ;
    case run.m_RunTyp of
        rtExport:
        begin
            setStatus('');
            act_export.Enabled :=True ;
            CMsgDlg.Info('%s'#13#10'Total de NF(s) exportadas: %d'#13#10'Total de NF(s) não exportadas: %d',
            [m_Local,run.totSucess,run.totError]);
        end;

        rtLoad:
        begin
            btn_Exec.Enabled :=True ;
            vst_Grid1.Enabled :=True;
            pnl_Footer.Enabled :=True;
            setStatus('');

            //
            // loag Grid
            if m_Lote.Items.Count > 0 then
            begin
                vst_Grid1.RootNodeCount :=m_Lote.Items.Count ;
                vst_Grid1.IndexItem :=0;
                vst_Grid1.Refresh ;

                btn_FilterClick(nil);
                btn_Items.Enabled :=True;
                btn_RelNF.Enabled :=True ;
                btn_Cons.Enabled :=True  ;
                act_export.Enabled :=True;

                ActiveControl :=vst_Grid1;
            end
            else begin
                CMsgDlg.Info('Nenhuma nota encontrada neste filtro!') ;
                btn_Items.Enabled :=False;
                btn_Send.Enabled :=False;
                btn_Cons.Enabled :=False;
                btn_RelNF.Enabled :=False;
                act_export.Enabled :=False;
                ActiveControl :=edt_PedIni;
            end;
        end;
    end;
end;

procedure Tfrm_Princ00.OnFormatText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  N: TCNotFis00 ;
begin
    CellText :='';
    N :=m_Lote.Items[Node.Index] ;
    case Column of
        00: CellText :=N.m_chvnfe;
        01: CellText :=Format('%.8d',[N.m_codped]) ;
        02: CellText :=IfThen(N.m_codmod=55,'NFe','NFCe') ;
        03: CellText :=Format('%.3d',[N.m_nserie]) ;
        04: CellText :=Format('%.8d',[N.m_numdoc]) ;
        05: CellText :=Format('%d-%s',[N.m_codstt,N.m_motivo]);
        06: CellText :=FormatDateTime('dd/MM/yyyy HH:NN', N.m_dtemis) ;
        07: CellText :=IfThen(N.m_tipntf=tnEntrada,'Ent','Sai') ;
        08: CellText :=TpEmisToStr(N.m_tipemi);
        09: CellText :=FinNFeToStr(N.m_finnfe);
        10: CellText :=Format('%d-%s',[N.m_codcli,N.m_dest.xNome]);
        11: CellText :=Format('%s/%s',[N.m_dest.EnderDest.xMun,N.m_dest.EnderDest.UF]);
        12: CellText :=CFrmtStr.Cur(N.m_icmstot.vBC) ;
        13: CellText :=CFrmtStr.Cur(N.m_icmstot.vICMS) ;
        14: CellText :=CFrmtStr.Cur(N.m_icmstot.vProd) ;
        15: CellText :=CFrmtStr.Cur(N.m_icmstot.vFrete);
        16: CellText :=CFrmtStr.Cur(N.m_icmstot.vSeg) ;
        17: CellText :=CFrmtStr.Cur(N.m_icmstot.vDesc);
        18: CellText :=CFrmtStr.Cur(N.m_icmstot.vIPI) ;
        19: CellText :=CFrmtStr.Cur(N.m_icmstot.vPIS) ;
        20: CellText :=CFrmtStr.Cur(N.m_icmstot.vCOFINS) ;
        21: CellText :=CFrmtStr.Cur(N.m_icmstot.vNF) ;
    end;
end;

procedure Tfrm_Princ00.OnGenSerial(Sender: TObject);
begin
    if Tfrm_GenSerialNFE.Execute then
    begin
        CMsgDlg.Info('Serial criado com sucesso.') ;
    end;
end;

procedure Tfrm_Princ00.OnINI(Sender: TObject);
begin
    case TCRunProc(Sender).m_RunTyp of
        rtLoad:
        begin
            btn_Exec.Enabled :=False ;
            vst_Grid1.Clear ;
            vst_Grid1.Enabled :=False ;
            pnl_Footer.Enabled :=False;
            m_Lote.Items.Clear ;
            setStatusBar();
            setStatus('Carregando Notas Fiscais'#13#10'Aguarde...');
        end;
    end;
end;

procedure Tfrm_Princ00.OnPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  C: TCanvas;
  N: TCNotFis00 ;
begin
    C :=TargetCanvas ;
    if TextType = ttNormal then
    begin
        N :=m_Lote.Items[Node.Index] ;
        if(Node = Sender.FocusedNode)and(Column = Sender.FocusedColumn) then
        begin
            C.Font.Color :=clWhite ;
        end
        else
            case N.m_codstt of
                1: TargetCanvas.Font.Color :=clWindowText ;
                9: TargetCanvas.Font.Color :=clMaroon ;
                100, 110, 150: TargetCanvas.Font.Color :=clGreen ;
                301, 302, 303: TargetCanvas.Font.Color :=clPurple;
            else
                TargetCanvas.Font.Color :=clRed ;
            end;
    end;
end;

procedure Tfrm_Princ00.OnStatus(const aStr: string);
begin
    setStatus(aStr);

end;

procedure Tfrm_Princ00.pnl_HelpCaptionClick(Sender: TObject);
begin
    pnl_Help.Visible :=False ;
end;

procedure Tfrm_Princ00.setStatusBar(const aPos: Int64) ;
var
  //rep: IBaseACBrNFE ;
  N: TCNotFis00 ;
var
  s_frmt, s_text: string;
begin
    if aPos > 0 then
    begin
        m_panelProgress.Progress.Position :=aPos ;
    end
    else begin
        //rep :=TCBaseACBrNFE.New() ;
        //
        // ind. tipo ambiente
        if TpcnTipoAmbiente(m_Rep.param.tipamb.Value) =taProducao then
        begin
            s_frmt :='<p><font color="#FFFFFF" bgcolor="#00BF00"><b>%s</b></font</p>';
            s_text :=PadCenter('Produção', 13) ;
        end
        else begin
            s_frmt :='<p><font color="#FFFFFF" bgcolor="#FF0000"><b>%s</b></font</p>';
            s_text :=PadCenter('Homologação', 13) ;
        end;
        m_panelAmb.Text :=Format(s_frmt,[s_text]);

        if m_Lote.Items.Count > 0 then
        begin
            N :=m_Lote.Items[vst_Grid1.IndexItem];
            m_panelItems.Text :=Format('NF''''s:<b>%d</b>',[m_Lote.Items.Count]);
            m_panelVTotal.Text :=Format('Total:<b>%10.2m</b>',[m_Lote.vTotalNF]);

            if N.CStatProcess then
            begin
                m_panelText.Text :=Format('<p>Situação: <font color="#006400">%s</font</p>',[N.m_motivo]);
            end
            else if N.CstatCancel then
            begin
                m_panelText.Text :=Format('<p>Situação: <font color="#FF8C00">%s</font</p>',[N.m_motivo]);
            end
            else begin
              m_panelText.Text :=Format('<p>Situação: <font color="#8B0000">%s</font</p>',[N.m_motivo]);
            end;
        end
        else begin
            m_panelItems.Text :='Nenhum';
            m_panelVTotal.Text :='';
            m_panelText.Text :='';
            m_panelProgress.Progress.Position :=0;
        end;
    end;
end;

procedure Tfrm_Princ00.vst_Grid1Change(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  N: TCNotFis00 ;
  process, cancel: Boolean ;
  cs: NotFis00CodStatus ;
begin
    if Assigned(Node) then
    begin
        N :=m_Lote.Items[Node.Index] ;

        process :=N.m_codstt in[100, 110, 150];
        process :=process or
                  (N.m_codstt =301)or
                  (N.m_codstt =302)or
                  (N.m_codstt =303);
        cancel  :=N.m_codstt in[101, 151, 155];

        btn_Send.Enabled := ((not process)and(not cancel) )or
                            (N.m_codstt in[0, cs.DONE_SEND,
                                              cs.CONTING_OFFLINE,
                                              cs.ERR_SCHEMA,
                                              cs.ERR_REGRAS]
                            );
        if(not N.m_codstt in[0, cs.DONE_SEND,cs.CONTING_OFFLINE,cs.ERR_SCHEMA,
                                cs.ERR_REGRAS]
          )then
        begin
            btn_Send.Enabled :=True;
        end;


        btn_Cons.Enabled :=(N.m_codstt in[cs.RET_PENDENTE,
                                          cs.EM_PROCESS,
                                          cs.DUPL,
                                          cs.NFE_JA_INUT,
                                          cs.NFE_JA_CANCEL])or
                           (N.m_codstt =cs.DUPL_DIF_CHV)or
                           (N.m_codstt =cs.CHV_DIF_BD);

        btn_Evento.Enabled :=N.m_codstt in[ cs.AUTORIZADO_USO,
                                            cs.AUTORIZADO_USO_FORA];

        act_DANFE.Enabled :=N.m_codstt in[cs.CONTING_OFFLINE,
                                          cs.AUTORIZADO_USO,
                                          cs.AUTORIZADO_USO_FORA];
        act_export.Enabled :=act_DANFE.Enabled ;

        //
        // actions:
        //act_CancNFE.Enabled :=

        //
        //DoUpdateStatus('');
        setStatusBar();
    end;
//    else begin
//        btn_Send.Enabled :=False;
//        btn_Cons.Enabled :=False;
//        btn_Evento.Enabled:=False;
//        act_export.Enabled :=False;
//    end;
end;

procedure Tfrm_Princ00.vst_Grid1HeaderClick(Sender: TVTHeader;
  HitInfo: TVTHeaderHitInfo);
var
  C: TVirtualTreeColumn;
  P: PVirtualNode;
  N: TCNotFis00 ;
begin
    //
    // checkbox ativo
    //
    if hhiOnCheckbox in HitInfo.HitPosition then
    begin
        C :=vst_Grid1.Header.Columns[HitInfo.Column] ;
        P :=vst_Grid1.RootNode.FirstChild;
        while Assigned(P) do
        begin
            N :=m_Lote.Items[P.Index] ;
            N.Checked :=(C.CheckState = csCheckedNormal) ;
            if N.Checked then
            begin
                vst_Grid1.CheckState[P] :=csCheckedNormal;
                P :=vst_Grid1.GetNextInitialized(P);
            end
            else begin
                vst_Grid1.CheckState[P] :=csUncheckedNormal;
                P :=vst_Grid1.GetNextNoInit(P);
            end;
        end;
        vst_Grid1.Refresh ;
    end;
end;



end.
