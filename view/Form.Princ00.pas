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
  Dialogs, StdCtrls, Mask, ExtCtrls,
  //JEDI
  JvExStdCtrls, JvExExtCtrls, JvExtComponent, JvCtrls,
  JvFooter, JvToolEdit, JvGroupBox, JvButton, JvAppInst,
  //TMS
  AdvPanel, AdvEdit, JvExMask, AdvGlowButton, AdvOfficeButtons, AdvGroupBox,
  AdvCombo, HTMLabel, AdvToolBar ,
  //
  VirtualTrees, uVSTree,
  //
  FormBase,
  uclass, ulog, uTaskDlg, unotfis00, ActnList, AdvMenus, Menus;



type
  TJvImgBtn =class(JvCtrls.TJvImgBtn)
  private
    m_ShortCut: String ;
  protected
  public
    property ShortCut: String read m_ShortCut write m_ShortCut;
  end;

  TJvFooterBtn =class(JvFooter.TJvFooterBtn)
  private
    m_ShortCut: String ;
    m_ShortCutFont: TFont;
    m_Rect: TRect;
  protected
    procedure DrawItem(const DrawItemStruct: TDrawItemStruct); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DrawButtonText(TextBounds: TRect; TextEnabled: Boolean); override;
  end;


type
  TRunProcTyp = (rtExport);
  TCRunProc = class(TCThreadProcess)
  private
    m_RunTyp: TRunProcTyp;
  protected
  public
    constructor Create(aRunTyp: TRunProcTyp);
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
    btn_Cancel: TJvFooterBtn;
    btn_Inut: TJvFooterBtn;
    btn_export: TJvFooterBtn;
    html_Status: THTMLabel;
    btn_Danfe: TJvFooterBtn;
    gbx_CodPed: TAdvGroupBox;
    edt_PedIni: TAdvEdit;
    edt_PedFin: TAdvEdit;
    Label1: TLabel;
    chk_EnvLote: TAdvOfficeCheckBox;
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
    AdvPopupMenu1: TAdvPopupMenu;
    AdvMenuStyler1: TAdvMenuStyler;
    mnu_CancNFE: TMenuItem;
    mnu_CCE: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_FilterClick(Sender: TObject);
    procedure btn_ExecClick(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure btn_SendClick(Sender: TObject);
    procedure vst_Grid1Checked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vst_Grid1Change(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure btn_ConsClick(Sender: TObject);
    procedure btn_InutClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btn_exportClick(Sender: TObject);
    procedure btn_DanfeClick(Sender: TObject);
    procedure btn_ConsSvcClick(Sender: TObject);
    procedure vst_Grid1HeaderClick(Sender: TVTHeader;
      HitInfo: TVTHeaderHitInfo);
    procedure btn_RelNFClick(Sender: TObject);
    procedure rgx_StatusClick(Sender: TObject);
    procedure chk_EnvLoteClick(Sender: TObject);
    procedure chk_ChvNFeClick(Sender: TObject);
    procedure btn_ConfigClick(Sender: TObject);
    procedure btn_ItemsClick(Sender: TObject);
    procedure act_CCEExecute(Sender: TObject);
    procedure act_CancNFEExecute(Sender: TObject);
  private
    { Private declarations }
    m_Service: Boolean ;
    m_Filter: TNotFis00Filter;
    m_Lote: TCNotFis00Lote;
    m_bSelCodSeq: Int32;
    m_proDescri, m_proCodInt: Boolean ;
//    procedure OnButtonDraw(Sender: TObject;
//      const DrawItemStruct: tagDRAWITEMSTRUCT);

    procedure OnFormatText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);

    procedure OnPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);

    function LoadGrid(): Boolean;

    procedure DoUpdateStatus(const AText: string);

    procedure OnGenSerial(Sender: TObject);

  private
    { Thread }
//    CRec       : TCThreadProcRec;
//    CStop      : Boolean;
    m_Run: TCRunProc;
    m_Local: string ;
    m_totSucess, m_totError: Integer ;
    procedure DoStop;
    procedure OnINI(Sender: TObject);
    procedure OnFIN(Sender: TObject);
    procedure OnRunExportXML(Sender: TObject);
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    function ChkPwd(const aInput: string): Boolean; override ;
  public
    { Public declarations }
    m_Log: TCLog ;
    procedure DoExecute ;
  end;

var
  frm_Princ00: Tfrm_Princ00;



implementation

{$R *.dfm}

uses StrUtils, DateUtils, IOUtils , DB, Clipbrd ,
  JvJCLUtils ,
  ACBrUtil, ACBrNFeNotasFiscais, pcnConversao, pcnConversaoNFe, pcnNFe,
  pcnAuxiliar ,
  uadodb ,
  //FDM.NFE,
  uACBrNFE,
  //Form.Config,
  Form.ParametroList, Form.NFEStatus,
  Form.Justifica, Form.Inutiliza,
  Form.RelNFRL00, Form.Ajuda, Form.EnvioLote, Form.Items, Form.CCEList,
  Form.GenSerialNFE ;

const
  Alignments: array [TAlignment] of Word = (DT_LEFT, DT_RIGHT, DT_CENTER);
  COL_CHV_NFE =0;
  COL_COD_PED =1;
  COL_COD_MOD =2;
  COL_NUM_SER =3;
  COL_NUM_DOC =4;

//var
//  rep_nfe: Tdm_nfe ;


{ Tfrm_Princ00 }

procedure Tfrm_Princ00.act_CancNFEExecute(Sender: TObject);
var
  N: TCNotFis00 ;
  just: Tfrm_Justif;
  rep: IBaseACBrNFE;
  ret: Boolean ;
begin
    just :=NewJustifica(svCancel);
    try
        if just.Execute then
        begin
            N :=m_Lote.Items[vst_Grid1.IndexItem] ;
            setStatus('Processando...');
            rep :=TCBaseACBrNFE.New() ;
            if rep.OnlyCanc(N, just.Text) then
            begin
                setStatus(Format('%d|%s'#13#10'Gravando Status...',[N.m_codstt,N.m_motivo]));
                N.setStatus();
                CMsgDlg.Info(N.m_motivo) ;
                LoadGrid ;
            end
            else begin
                CMsgDlg.Warning(Format('%d-%s',[rep.ErrCod,rep.ErrMsg])) ;
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
end;

procedure Tfrm_Princ00.btn_ConsClick(Sender: TObject);
var
  N: TCNotFis00;
  rep: IBaseACBrNFE;
  ret: Boolean ;
begin
    if(vst_Grid1.IndexItem >-1)and CMsgDlg.Confirm('Deseja consultar o Protocolo?')then
    begin
        N :=m_Lote.Items[vst_Grid1.IndexItem] ;

        //DoUpdateStatus('Processando...');

        //
        // se NF ja existe com dif. de chave
        // reset. contingencia
        {if(N.m_codstt =TCNotFis00.CSTT_CHV_DIF_BD)and
        ((N.m_tipemi =teContingencia)or(N.m_tipemi =teOffLine))then
        begin
            setStatus('Resetando contingência...');
            N.setContinge('', True);
            if Tdm_nfe.getInstance.AddNotaFiscal(N, True) <> nil then
            begin
                N.setXML() ;
            end ;
        end;

        ret :=Tdm_nfe.getInstance.OnlyCons(N) ;
        DoUpdateStatus('');
        if ret then
        begin
            CMsgDlg.Info(N.m_motivo) ;
            DoUpdateStatus('Gravando protocolo...');
            N.setStatus();
            LoadGrid ;
        end
        else begin
            CMsgDlg.Warning(Format('%d-%s',[Tdm_nfe.getInstance.ErrCod,Tdm_nfe.getInstance.ErrMsg])) ;
        end;}

        setStatus('Processando...');
        rep :=TCBaseACBrNFE.New() ;
        if rep.OnlyCons(N) then
        begin
            setStatus(Format('%d|%s'#13#10'Gravando Status...',[N.m_codstt,N.m_motivo]));
            N.setStatus();
            CMsgDlg.Info(N.m_motivo) ;
            LoadGrid ;
        end
        else begin
            CMsgDlg.Warning(Format('%d-%s',[rep.ErrCod,rep.ErrMsg])) ;
        end;
        setStatus('');
    end;
    ActiveControl :=vst_Grid1;
end;

procedure Tfrm_Princ00.btn_ConsSvcClick(Sender: TObject);
var
//  nfe: Tdm_nfe;
  S: string;
  rep: IBaseACBrNFE ;
begin
    if CMsgDlg.Confirm('Deseja consultar o status do serviço da NFE?') then
    begin
        {DoUpdateStatus('Aguarde...');
        nfe :=Tdm_nfe.getInstance ;
        nfe.m_NFE.SSL.CarregarCertificadoSeNecessario ;
        S :=FormatDateTime('"Certificado[CNPJ:%s Vencimento:"dd/mm/yyyy"]"', nfe.m_NFE.SSL.CertDataVenc) ;
        S :=Format(S,[nfe.m_NFE.SSL.CertCNPJ]);
        if nfe.OnlyStatusSvc() then
        begin
            CMsgDlg.Info(nfe.StatusServico.Msg) ;
        end
        else begin
            CMsgDlg.Warning(nfe.ErrMsg) ;
        end;
        DoUpdateStatus(S);
        Screen.Cursor :=crDefault;}
        setStatus('Aguarde'#13#10'Consultando...');
        try
            rep :=TCBaseACBrNFE.New() ;
            if rep.OnlyStatusSvc() then
            begin
                if rep.ErrCod =107 then
                    CMsgDlg.Info(rep.ErrMsg)
                else
                    CMsgDlg.Warning(rep.ErrMsg) ;
            end
            else
                CMsgDlg.Error(rep.ErrMsg) ;
        finally
            setStatus('');
        end;
    end;
    ActiveControl :=vst_Grid1;
end;

procedure Tfrm_Princ00.btn_DanfeClick(Sender: TObject);
var
  N: TCNotFis00 ;
  rep: IBaseACBrNFE;
begin
    if CMsgDlg.Confirm('Deseja imprimir o DANFE?') then
    begin
        setStatus('Imprimindo...');
        try
            N :=m_Lote.Items[vst_Grid1.IndexItem] ;
            rep :=TCBaseACBrNFE.New() ;
            //if Tdm_nfe.getInstance.PrintDANFE(N) then
            if rep.PrintDANFE(N) then
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
        m_Filter.datfin :=edt_DatFin.Date ;

        m_Filter.status :=TNotFis00Status(rgx_Status.ItemIndex) ;
        if m_Filter.status =sttNone then
        begin
            if edt_DatIni.Date > edt_DatFin.Date then
            begin
                CMsgDlg.Info('Data inicial maior que data final!') ;
                edt_DatIni.SetFocus;
                exit;
            end;
        end;
        {case rgx_Status.ItemIndex of
            0: m_Filter.status :=sttDoneSend;
            1: m_Filter.status :=sttConting ;
            2: m_Filter.status :=sttProcess ;
            3: m_Filter.status :=sttCancel ;
            4: m_Filter.status :=sttError ;
            5: m_Filter.status :=sttService ;
        else
            if edt_DatIni.Date > edt_DatFin.Date then
            begin
                CMsgDlg.Info('Data inicial maior que data final!') ;
                edt_DatIni.SetFocus;
                exit;
            end;
        end;}

        case cbx_Modelo.ItemIndex of
            0: m_Filter.codmod :=55 ;
            1: m_Filter.codmod :=65 ;
        else
            m_Filter.codmod :=0;
            m_Filter.nserie :=0;
        end;
        m_Filter.nserie :=edt_NSerie.IntValue ;

    end;

    {case gbx_Modelo.ItemIndex of
      0: m_Filter.codmod :=55;
      1: m_Filter.codmod :=65;
    else
        m_Filter.codmod :=0;
    end;}

//    m_Filter.chvnfe :=chk_ChvNFe.Checked ;

    if LoadGrid then
    begin
        btn_FilterClick(nil);
        btn_Items.Enabled :=True;
        btn_RelNF.Enabled :=True ;
        btn_Cons.Enabled :=True  ;
        btn_export.Enabled :=True;
    end
    else begin
        CMsgDlg.Info('Nenhuma nota encontrada neste filtro!') ;
        ActiveControl :=edt_PedIni;
        btn_Items.Enabled :=False;
        btn_Send.Enabled :=False;
        btn_Cons.Enabled :=False;
        btn_RelNF.Enabled :=False;
        btn_export.Enabled :=True;
    end;
end;

procedure Tfrm_Princ00.btn_exportClick(Sender: TObject);
begin
    if CMsgDlg.Confirm('Somente as Notas processadas serão exportadas! Deseja continuar?') then
    begin
        {m_Service :=False;
        CRec.OnIni :=OnINI;
        CRec.OnEnd :=OnEND;
        CRec.CProc :=DoRun;
        CRec.CExec :=TCThreadProc.Create(CRec);}
        m_Run :=TCRunProc.Create(rtExport);
        m_Run.OnBeforeExecute :=OnINI;
        m_Run.OnTerminate :=OnFIN;
        m_Run.OnExecute :=OnRunExportXML;
        m_Run.Start  ;
    end;
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

procedure Tfrm_Princ00.btn_RelNFClick(Sender: TObject);
begin
//    Tfrm_RelNF.CF_Execute(m_Lote);
    Tfrm_RelNFRL00.Execute(m_Lote);
end;

procedure Tfrm_Princ00.btn_SendClick(Sender: TObject);
var
  N: TCNotFis00 ;
  rep: IBaseACBrNFE; //Tdm_nfe ;
  S: string;
  ret: Boolean ;
var
  proDescri, proCodInt: Boolean ;
begin
    N :=nil;

    //
    // envio do lote com varias NF´s (assincrono)
    if chk_EnvLote.Checked then
    begin
        //
        // se confirmou, atualiza grid
        if Tfrm_EnvLote.fn_Show(m_Filter) then
        begin
            LoadGrid ;
        end;
    end

    //
    // envio do lote com uma NF (sincrono)
    else begin
        N :=m_Lote.Items[vst_Grid1.IndexItem] ;
        {rep :=Tdm_nfe.getInstance ;
        DoUpdateStatus('Atualizando Nota Fiscal...');
        if N.UpdateNFe(now, ord(rep.ProdDescrRdz),ord(rep.ProdCodInt), S) then
        begin
            DoUpdateStatus('Processando...');
            ret :=rep.OnlySend(N) ;
            //DoUpdateStatus('');

            if ret then
            begin
                CMsgDlg.Info(N.m_motivo) ;
                DoUpdateStatus('Gravando status...');
                N.setStatus();
                LoadGrid ;
            end
            else
                CMsgDlg.Warning(rep.ErrMsg);
        end
        else
            CMsgDlg.Warning(S);
        DoUpdateStatus('');}
        try
            rep :=TCBaseACBrNFE.New() ;
            setStatus(Format('Atualizando NF(%d)',[N.m_codped]));
            if N.UpdateNFe(now, ord(rep.param.xml_prodescri_rdz.Value),ord(rep.param.xml_procodigo_int.Value), S) then
            begin
                setStatus('Processando NF...');
                if rep.OnlySend(N) then
                begin
                    setStatus(Format('%d|%s'#13#10'Gravando Status...',[N.m_codstt,N.m_motivo]));
                    N.setStatus();
                    CMsgDlg.Info(N.m_motivo) ;
                    LoadGrid ;
                end
                else
                    CMsgDlg.Warning(rep.ErrMsg);
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

procedure Tfrm_Princ00.chk_EnvLoteClick(Sender: TObject);
var
  C: TVirtualTreeColumn;
begin
    //
    // set cab.column main
    //
  {
    C :=vst_Grid1.Header.Columns[0] ;
    C.CheckBox :=chk_EnvLote.Checked ;
    if C.CheckBox then
        C.CheckState :=csCheckedNormal
    else
        C.CheckState :=csUncheckedNormal;
  }
    btn_Send.Enabled :=chk_EnvLote.Checked ;
end;

procedure Tfrm_Princ00.DoExecute;
// procedure a ser executa quando estiver chamando como serviço
// nao executa o SHOW do formulário
begin
    m_Log.AddSec('%s.DoExec',[Self.ClassName]) ;
    m_Service :=True ;
    //m_Filter.status:=sttService;
//    Tdm_nfe.getInstance.setStatusChange(false);
//    DoRun() ;
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
procedure Tfrm_Princ00.DoUpdateStatus(const AText: string);
var
  N: TCNotFis00 ;
  P: string;
begin
    html_Status.HTMLText.Clear;
    if AText <> '' then
    begin
        html_Status.VAlignment :=tvaCenter ;
        html_Status.HTMLText.Add(Format('<P align="center"><B>%s</B></P>',[AText]));
        Screen.Cursor :=crHourGlass;
    end
    else begin
        if vst_Grid1.RootNodeCount > 0 then
        begin
            html_Status.VAlignment :=tvaTop ;
            html_Status.HTMLText.Add(Format('<P align="right"><B>TOTAL => %d nota(s), %15.2m</B></P>',[
            m_Lote.Items.Count, m_Lote.vTotalNF ]));

            N :=m_Lote.Items[vst_Grid1.IndexItem];
            if N.CStatProcess then
            begin
                P :=Format('<P align="left"><FONT color="#006400"><B>%s</B></FONT></P>',[N.m_motivo]);
            end
            else if N.CstatCancel then
            begin
                P :=Format('<P align="left"><FONT color="#FF8C00"><B>%s</B></FONT></P>',[N.m_motivo]);
            end
            else begin
                P :=Format('<P align="left"><FONT color="#8B0000"><B>%s</B></FONT></P>',[N.m_motivo]);
            end;
            html_Status.HTMLText.Add(P);
        end
        else begin
            html_Status.VAlignment :=tvaCenter ;
            html_Status.HTMLText.Add('<P align="center">Nenhuma nota !</P>');
        end;
        Screen.Cursor :=crDefault;
    end;
    html_Status.Refresh ;
end;

procedure Tfrm_Princ00.FormCreate(Sender: TObject);
begin
    m_Service :=False ;
    m_Lote :=TCNotFis00Lote.Create ;
    m_Log :=nil;

    TCExeInfo.getInstance.GetVersionInfoOfApp(Application.ExeName);
    Self.Caption :=Format('%s(Ver.:%d.%d.%d%d)',[ Self.Caption,
                                                  TCExeInfo.getInstance.MajorVersion ,
                                                  TCExeInfo.getInstance.MinorVersion ,
                                                  TCExeInfo.getInstance.ReleaseNumber,
                                                  TCExeInfo.getInstance.BuildNumber
                                                 ]);
    AppInstances1.Active :=True;
end;

procedure Tfrm_Princ00.FormDestroy(Sender: TObject);
begin
    m_Lote.Destroy ;

end;

procedure Tfrm_Princ00.FormResize(Sender: TObject);
begin
    vst_Grid1.Anchors :=vst_Grid1.Anchors +[akBottom];
    pnl_Filter.Anchors:=[akLeft,akTop,akBottom];
    html_Status.Anchors:=[akLeft,akRight,akBottom];

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

    DoEnabledControls(pnl_Footer, False);
    btn_Config.Enabled  :=True;
    btn_Filter.Enabled  :=True;
    btn_ConsSvc.Enabled :=True;
    btn_Inut.Enabled  :=True;
    btn_Close.Enabled :=True;

//    btn_Filter.m_ShortCut :='F2';
//    btn_Items.m_ShortCut :='Alt+I';

    DoUpdateStatus('');
    m_bSelCodSeq :=0;

    ConnectionADO :=NewADOConnFromIniFile('Configuracoes.ini') ;
    ConnectionADO.Connected :=True;

    Empresa :=TCEmpresa.Instance ;
    Empresa.DoLoad(1);

//    rep_nfe :=Tdm_nfe.getInstance;


end;

procedure Tfrm_Princ00.KeyDown(var Key: Word; Shift: TShiftState);
var
  N: TCNotFis00 ;
  rep: IBaseACBrNFE;
  nfe: NotaFiscal;
  chave,conf: string;
begin

    case Key of
        VK_F1: Tfrm_Ajuda.CP_Show ;
        VK_F2: btn_Filter.Click ;
        VK_F5: if btn_Exec.Visible then btn_Exec.Click ;
    end;

    // Alt press
    // cria um serial (sequencia) da NFe/NFCe
    if (ssAlt in Shift)and(Key =Ord('K'))or(Key =Ord('k'))then
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
            nfe :=rep.AddNotaFiscal(N,True,True) ;
            if nfe <> nil then
            begin
                nfe.GerarXML ;
                nfe.GravarXML(Format('%s-procNFe.XML',[N.m_chvnfe]), ApplicationPath);
                CMsgDlg.Info('XML gravado em %s',[ApplicationPath]) ;
            end;
        end;

        //
        // Corrige Chave/XML com bug do sistema
        //
        if(Key =Ord('K'))or(Key =Ord('k')) then
        begin
            rep :=TCBaseACBrNFE.New() ;
            nfe :=rep.AddNotaFiscal(N,True,True) ;
            try
                nfe.Assinar ;
                N.m_chvnfe :=OnlyNumber(nfe.NFe.infNFe.ID)  ;
                N.m_xml    :=nfe.XMLAssinado ;
                N.setXML ;
                CMsgDlg.Info('XML/Chave gerado com sucesso') ;
            except
                on E:Exception  do
                begin
                    CMsgDlg.Warning('Não foi possível gerar o XML/Chave!'#13 +E.Message) ;
                end;
            end;
        end;

        {DESCONTINUADO !!!
        //
        // ativa protocolo
        //
        if(Key =Ord('P'))or(Key =Ord('p')) then
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
            btn_Cons.Enabled :=True ;
        end;}

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
var
  N: TCNotFis00 ;
  P: PVirtualNode;
begin
    vst_Grid1.Clear ;
    DoUpdateStatus('Carregando Notas Fiscais, Aguarde...');
    try

      Result :=m_Lote.Load(m_Filter);
      if Result then
      begin

          for N in m_Lote.Items do
          begin
              P :=vst_Grid1.AddChild(nil) ;
              {if chk_EnvLote.Checked then
              begin
                  N.Checked :=True ;
                  P.CheckType :=ctCheckBox ;
                  P.CheckState:=csCheckedNormal ;
              end; }
          end;

          vst_Grid1.IndexItem :=0;
          vst_Grid1.Refresh ;

          ActiveControl :=vst_Grid1;

          //btn_Send.Enabled :=False;
          //btn_Cons.Enabled :=False;
          //btn_Cancel.Enabled :=False;
          btn_export.Enabled :=True;

      end
      else
          m_bSelCodSeq :=0;

    finally
      DoUpdateStatus('');
    end;
end;

procedure Tfrm_Princ00.OnFIN(Sender: TObject);
begin
    setStatus('');
    btn_export.Enabled :=True ;
    CMsgDlg.Info('%s'#13#10'Total de NF(s) exportadas: %d'#13#10'Total de NF(s) não exportadas: %d',
    [m_Local,m_totSucess,m_totError]);
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
        rtExport:
        begin
            btn_export.Enabled :=False ;
            m_totSucess:=0;
            m_totError :=0;
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

procedure Tfrm_Princ00.OnRunExportXML(Sender: TObject);
var
  NF: TCNotFis00;
  rep: IBaseACBrNFE;
  N: NotaFiscal ;
var
  yy,mm,dd: Word ;
  root,local,F: string ;
begin

    yy :=0;
    mm :=0;

    root :=ExcludeTrailingPathDelimiter( ExtractFilePath(Application.ExeName)) ;
    root :=root +Format('\arquivos\DFe\NFe\%s', [Empresa.CNPJ]) ;

    setStatus(Format('Local: %s',[root]));

    rep :=TCBaseACBrNFE.New(False) ;

    for NF in m_Lote.Items do
    begin
        if NF.CStatProcess or NF.CstatCancel then
        begin
            if yy = 0 then
            begin
                DecodeDate(NF.m_dtemis, yy, mm, dd);
                local :=root +FormatDateTime('"\"yyyy"\"mm"_"mmm', NF.m_dtemis, LocalFormatSettings) ;
                if not DirectoryExists(local) then
                    ForceDirectories(local) ;
                //Sleep(1000);
                m_Local :=local ;
            end;

            if NF.m_chvnfe <> '' then
            begin
                setStatus(Format('Carregando NFe[Mod:%d,Série:%.3d,Número:%d]',[
                                NF.m_codmod,NF.m_nserie,NF.m_numdoc]));
                if NF.LoadXML() then
                begin
                    N :=rep.AddNotaFiscal(NF, True, True) ;
                    if N <> nil then
                    begin
                        N.LerXML(NF.m_xml) ;
                        N.NFe.procNFe.tpAmb   :=NF.m_tipamb ;
                        N.NFe.procNFe.verAplic:=NF.m_verapp ;
                        N.NFe.procNFe.chNFe   :=NF.m_chvnfe ;
                        N.NFe.procNFe.dhRecbto:=NF.m_dhreceb;
                        N.NFe.procNFe.nProt   :=NF.m_numprot;
                        N.NFe.procNFe.digVal  :=NF.m_digval ;
                        N.NFe.procNFe.cStat   :=NF.m_codstt ;
                        N.NFe.procNFe.xMotivo :=NF.m_motivo ;
                        setStatus(Format('Exportando NFe:%s'#13#10'Aguarde...',[NF.m_chvnfe]));
                        N.GerarXML ;
                        F :=Format('%s-procNFe.XML',[NF.m_chvnfe]);
                        N.GravarXML(F, local);
                    end;
                end;
                Inc(m_totSucess) ;
            end
            else begin
                setStatus(Format('NFe[Mod:%d,Série:%.3d,Número:%d]'#13#10'Error',[
                                NF.m_codmod,NF.m_nserie,NF.m_numdoc]));
                Inc(m_totError) ;
            end;
        end;
        //Sleep(1000);
    end;
end;

procedure Tfrm_Princ00.rgx_StatusClick(Sender: TObject);
begin
    if rgx_Status.ItemIndex =4 then
        chk_EnvLote.Checked :=True
    else
        chk_EnvLote.Checked :=False;
end;

procedure Tfrm_Princ00.vst_Grid1Change(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  N: TCNotFis00 ;
  process, cancel: Boolean ;
begin
    if Assigned(Node) then
    begin
        N :=m_Lote.Items[Node.Index] ;
        m_bSelCodSeq :=N.m_codseq ;

        process :=N.m_codstt in[100, 110, 150];
        process :=process or
                  (N.m_codstt =301)or
                  (N.m_codstt =302)or
                  (N.m_codstt =303);
        cancel  :=N.m_codstt in[101, 151, 155];

        btn_Send.Enabled := ((not process)and(not cancel) )or
                            (N.m_codstt in[0,1,9,77,88]   )or
                            chk_EnvLote.Checked ;
        if (not N.m_codstt in[0,1,9,77,88]   ) then
        begin
            btn_Send.Enabled :=True;
        end;


        btn_Cons.Enabled :=(N.m_codstt in[TCNotFis00.CSTT_RET_PENDENTE,
                                        TCNotFis00.CSTT_DUPL, 206, 218 ,
                                        TCNotFis00.CSTT_EM_PROCESS])or
                           (N.m_codstt =TCNotFis00.CSTT_DUPL_DIF_CHV)or
                           (N.m_codstt =TCNotFis00.CSTT_CHV_DIF_BD);
//                            process or
//                            cancel  ;

        btn_Cancel.Enabled :=N.m_codstt =TCNotFis00.CSTT_AUTORIZADO_USO;

        btn_Danfe.Enabled :=N.m_codstt in[TCNotFis00.CSTT_EMIS_CONTINGE,
                                          TCNotFis00.CSTT_AUTORIZADO_USO];

        //
        // actions:
        //act_CancNFE.Enabled :=

        DoUpdateStatus('');
    end
    else begin
        btn_Send.Enabled :=False;
        btn_Cons.Enabled :=False;
        btn_Cancel.Enabled:=False;
        btn_export.Enabled :=False;
    end;
end;

procedure Tfrm_Princ00.vst_Grid1Checked(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  N: TCNotFis00 ;
begin
    N :=m_Lote.Items[Node.Index] ;
    N.Checked :=Node.CheckState =csCheckedNormal;
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

{ TJvFooterBtn }

constructor TJvFooterBtn.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
    m_ShortCutFont :=TFont.Create;
    m_ShortCutFont.Name :='Times New Roman';
    m_ShortCutFont.Size :=6;
    m_ShortCutFont.Style:=[fsBold];
end;

destructor TJvFooterBtn.Destroy;
begin
    m_ShortCutFont.Destroy ;
    inherited;
end;

procedure TJvFooterBtn.DrawButtonText(TextBounds: TRect; TextEnabled: Boolean);
var
  Flags: DWORD;
  RealCaption: string;
  fontName: string;
  fontSize: Word;
  fontStyl: TFontStyles;
begin
    Flags := DrawTextBiDiModeFlags(DT_VCENTER or Alignments[Alignment]);
    if WordWrap then
        Flags := Flags or DT_WORDBREAK;

    RealCaption := GetRealCaption;

    fontName :=Canvas.Font.Name;
    fontSize :=Canvas.Font.Size;
    fontStyl :=Canvas.Font.Style;

    Canvas.Brush.Style := bsClear;
    if TextEnabled then
    begin
        JvJCLUtils.DrawText(Canvas, RealCaption, Length(RealCaption), TextBounds, Flags);
        //atalho
        if m_ShortCut <> '' then
        begin
            Canvas.Font.Name :=m_ShortCutFont.Name;
            Canvas.Font.Size :=m_ShortCutFont.Size;
            Canvas.Font.Style :=m_ShortCutFont.Style;
            Canvas.TextOut(m_Rect.Left, m_Rect.Bottom -Canvas.TextHeight(m_ShortCut), m_ShortCut);
        end;
    end
    else begin
        OffsetRect(TextBounds, 1, 1);
        Canvas.Font.Color := clBtnHighlight;
        JvJCLUtils.DrawText(Canvas, RealCaption, Length(RealCaption), TextBounds, Flags);
        OffsetRect(TextBounds, -1, -1);
        Canvas.Font.Color := clBtnShadow;
        JvJCLUtils.DrawText(Canvas, RealCaption, Length(RealCaption), TextBounds, Flags);
        //atalho
        Canvas.Font.Name :=m_ShortCutFont.Name;
        Canvas.Font.Size :=m_ShortCutFont.Size;
        Canvas.Font.Style :=m_ShortCutFont.Style;
        Canvas.TextOut(m_Rect.Left, m_Rect.Bottom -Canvas.TextHeight(m_ShortCut), m_ShortCut);
    end;
    Canvas.Font.Name :=fontName;
    Canvas.Font.Size :=fontSize;
    Canvas.Font.Style :=fontStyl;
end;

procedure TJvFooterBtn.DrawItem(const DrawItemStruct: TDrawItemStruct);
var
  R, RectContent, RectText, RectImage, RectArrow: TRect;
begin
  DrawButtonFrame(DrawItemStruct, RectContent);

  //R := ClientRect;
  //InflateRect(R, -4, -4);
  R :=RectContent;
  if not DisableDrawDown and (DrawItemStruct.itemState and ODS_SELECTED <> 0) and Enabled then
  begin
    {$IFDEF JVCLThemesEnabled}
    if StyleServices.Enabled then
      OffsetRect(R, 1, 0)
    else
    {$ENDIF JVCLThemesEnabled}
      OffsetRect(R, 1, 1);
  end;

  CalcButtonParts(R, RectText, RectImage);
  if DropArrow and Assigned(DropDownMenu) then
  begin
    RectArrow := Rect(Width - 16, Height div 2, Width - 9, Height div 2 + 7);
    if (DrawItemStruct.itemState and ODS_SELECTED <> 0) then
      OffsetRect(RectArrow, 1, 1);
    DrawDropArrow(Canvas, RectArrow);
    if (DrawItemStruct.itemState and ODS_SELECTED <> 0) then
      OffsetRect(RectContent, 1, -1)
  end;
  m_Rect :=R;
  DrawButtonText(RectText, Enabled);
  DrawButtonImage(RectImage);
  DrawButtonFocusRect(RectContent);
end;


{ TCRunProc }

constructor TCRunProc.Create(aRunTyp: TRunProcTyp);
begin
    m_RunTyp :=aRunTyp;
    inherited Create(True, False);
end;

end.
