unit Form.ManifestoList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Mask,

  AdvToolBar, AdvOfficeStatusBar, AdvOfficeButtons, AdvEdit,
  AdvGroupBox, AdvPanel, AdvGlowButton,

  JvExStdCtrls, JvButton, JvCtrls, JvExMask, JvToolEdit,

  FormBase, uStatusBar, VirtualTrees, uVSTree,
  uIntf, uManifestoCtr, JvFooter, JvExExtCtrls, JvExtComponent
  ;

type
  Tfrm_ManifestoList = class(TBaseForm, IView)
    AdvOfficeStatusBar1: TAdvOfficeStatusBar;
    vst_Grid1: TVirtualStringTree;
    pnl_Filter: TAdvPanel;
    gbx_DtEmis: TAdvGroupBox;
    edt_DatIni: TJvDateEdit;
    edt_DatFin: TJvDateEdit;
    rgx_Status: TAdvOfficeRadioGroup;
    btn_Find: TJvImgBtn;
    gbx_Ident: TAdvGroupBox;
    edt_CodSeq: TAdvEdit;
    chk_ChvNFe: TAdvOfficeCheckBox;
    pnl_Footer: TJvFooter;
    btn_Config: TJvFooterBtn;
    btn_Filter: TJvFooterBtn;
    btn_Close: TJvFooterBtn;
    btn_Send: TJvFooterBtn;
    btn_Edit: TJvFooterBtn;
    btn_New: TJvFooterBtn;
    btn_Cons: TJvFooterBtn;
    btn_Canc: TJvFooterBtn;
    btn_Detalh: TJvFooterBtn;
    procedure FormShow(Sender: TObject);
    procedure btn_FindClick(Sender: TObject);
    procedure vst_Grid1GetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure btn_NewClick(Sender: TObject);
    procedure btn_EditClick(Sender: TObject);
    procedure btn_FilterClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn_SendClick(Sender: TObject);
    procedure btn_ConsClick(Sender: TObject);
    procedure btn_DetalhClick(Sender: TObject);
    procedure btn_ConfigClick(Sender: TObject);
  private
    { Private declarations }
    m_Ctrl: TCManifestoCtr;
    m_StatusBar: TCStatusBarWidget;
    m_StatusProgress: TAdvOfficeStatusPanel ;
    m_StatusItems: TAdvOfficeStatusPanel ;
    m_StatusText: TAdvOfficeStatusPanel ;
    procedure setStatusBar();
  public
    { Public declarations }
    class procedure NewAndShow ;
    procedure Inicialize;
    procedure ModelChanged;
    procedure Execute;
  end;


implementation

uses StrUtils, DateUtils,
  pcnConversao, pmdfeConversaoMDFe ,
  uTaskDlg, udbconst, FDM.NFE, fdm.Styles,
  uManifestoDF,
  Form.Manifesto, Form.ParametroList;



{$R *.dfm}

{ Tfrm_ManifestoList }

procedure Tfrm_ManifestoList.btn_ConfigClick(Sender: TObject);
var
  pwd: string ;
  rep_nfe: Tdm_nfe ;
begin
    if not InputQueryDlg('Acesso aos Parametros do MDF-e','Informe a senha:', pwd) then
    begin
        Exit;
    end;
    if not ChkPwd(pwd) then
    begin
        CMsgDlg.Warning('Senha inválida!') ;
        Exit;
    end;
    //
    //
    rep_nfe :=Tdm_nfe.getInstance ;
    rep_nfe.regMDFe.Load ;
    //
    //
    Tfrm_ParametroList.lp_Show('MDFE') ;
end;

procedure Tfrm_ManifestoList.btn_ConsClick(Sender: TObject);
var
  rep: Tdm_nfe ;
begin
    if CMsgDlg.Confirm('Deseja consultar o status do serviço?') then
    begin
        setStatus('Cominucando, aguarde...',crHourGlass);
        rep :=Tdm_nfe.getInstance ;
        try
          if rep.OnlyStatusSvc(58) then
          begin
              CMsgDlg.Info(rep.m_MDFE.WebServices.StatusServico.Msg) ;
          end
          else begin
              CMsgDlg.Warning(rep.ErrMsg) ;
          end;
        finally
          setStatus('');
          //Tdm_nfe.do
        end;
    end;
    ActiveControl :=vst_Grid1;
end;

procedure Tfrm_ManifestoList.btn_DetalhClick(Sender: TObject);
var
  M: IManifestoDF;
  V: IView ;
begin
    M :=m_Ctrl.ModelList.Items[vst_Grid1.IndexItem] ;
    if(M <> nil)and(M.id > 0) then
    begin
        V :=Tfrm_Manifesto.Create(m_Ctrl);
        m_Ctrl.Model :=M ;
        m_Ctrl.Model.State :=msBrowse ;
        m_Ctrl.Model.OnModelChanged :=(V as Tfrm_Manifesto).ModelChanged ;
        //m_Ctrl.Inicialize ;
        V.Execute ;
    end;
    ActiveControl :=vst_Grid1 ;
end;

procedure Tfrm_ManifestoList.btn_EditClick(Sender: TObject);
var
  M: IManifestoDF;
  V: IView ;
begin
    if CMsgDlg.Confirm('Deseja editar o manifesto?') then
    begin
        M :=m_Ctrl.ModelList.Items[vst_Grid1.IndexItem] ;
        if(M <> nil)and(M.id > 0) then
        begin
            V :=Tfrm_Manifesto.Create(m_Ctrl);
            m_Ctrl.Model :=M ;
            m_Ctrl.Model.Edit;
            m_Ctrl.Model.OnModelChanged :=(V as Tfrm_Manifesto).ModelChanged ;
            //m_Ctrl.Inicialize ;
            V.Execute ;
        end;
    end;
    ActiveControl :=vst_Grid1 ;
end;

procedure Tfrm_ManifestoList.btn_FilterClick(Sender: TObject);
begin
    pnl_Filter.Visible :=not pnl_Filter.Visible ;

end;

procedure Tfrm_ManifestoList.btn_FindClick(Sender: TObject);
var
  F: TManifestoFilter ;
begin
    //
    F.codseq :=0;
    F.datini :=0;
    F.datfin :=0;
    F.status :=mfsNone ;

    //
    //
    if edt_CodSeq.IntValue > 0 then
    begin
        F.codseq :=edt_CodSeq.IntValue ;
    end
    //
    //
    else begin
        F.datini :=edt_DatIni.Date ;
        F.datfin :=edt_DatFin.Date ;

        case rgx_Status.ItemIndex of
            0: F.status :=mfsDoneSend;
            1: F.status :=mfsConting ;
            2: F.status :=mfsProcess ;
            3: F.status :=mfsCancel ;
            4: F.status :=mfsError ;
        else
            if edt_DatIni.Date > edt_DatFin.Date then
            begin
                CMsgDlg.Info('Data inicial maior que data final!') ;
                edt_DatIni.SetFocus;
                exit;
            end;
        end;
    end;

    vst_Grid1.Clear ;
    if m_Ctrl.ModelList.Load(F) then
    begin
        vst_Grid1.RootNodeCount :=m_Ctrl.ModelList.Items.Count;
        vst_Grid1.IndexItem :=0;
        ActiveControl :=vst_Grid1;
        btn_Filter.Click ;
    end
    else begin
        CMsgDlg.Info('Nenhuma manifesto encontrado neste filtro!') ;
        ActiveControl :=edt_DatIni;
    end;
end;

procedure Tfrm_ManifestoList.btn_NewClick(Sender: TObject);
var
  M: IManifestoDF;
  V: IView ;
begin
    if CMsgDlg.Confirm('Deseja emitir um novo manifesto?') then
    begin
        M :=TCManifestoDF.Create ;
        V :=Tfrm_Manifesto.Create(m_Ctrl);
        m_Ctrl.Model:=M;
        m_Ctrl.Model.Insert;
        m_Ctrl.Model.OnModelChanged :=(V as Tfrm_Manifesto).ModelChanged ;
        m_Ctrl.View :=V;
        //m_Ctrl.Inicialize ;
        V.Execute ;
    end;
    ActiveControl :=vst_Grid1 ;
end;

procedure Tfrm_ManifestoList.btn_SendClick(Sender: TObject);
var
  rep: Tdm_nfe;
  ret: Boolean;
begin
    if CMsgDlg.Confirm('Deseja enviar o MDFe?')then
    begin
        rep :=Tdm_nfe.getInstance ;
        setStatus('Processando o MDF-e'#13#10'Aguarde...', crHourGlass);
        try
            ret :=rep.OnlySendMDFE(m_Ctrl.Model) ;
            setStatus('');
            if ret then
                CMsgDlg.Info('%d-%s',[m_Ctrl.Model.Status,m_Ctrl.Model.motivo])
            else
                CMsgDlg.Warning(rep.ErrMsg);
        finally
            setStatus('');
        end;
    end;
    ActiveControl :=vst_Grid1 ;
end;

procedure Tfrm_ManifestoList.Execute;
begin

end;

procedure Tfrm_ManifestoList.FormCreate(Sender: TObject);
begin
    m_Ctrl :=TCManifestoCtr.Create ;
    //
    // statusBar
    m_StatusBar :=TCStatusBarWidget.Create(AdvOfficeStatusBar1, False);
    m_StatusProgress :=m_StatusBar.AddPanel(psProgress, 200) ;
    m_StatusItems:=m_StatusBar.AddPanel(psHTML, 121) ;
    m_StatusText:=m_StatusBar.AddPanel(psHTML) ;
end;

procedure Tfrm_ManifestoList.FormShow(Sender: TObject);
begin
    edt_DatIni.Date :=Date;
    edt_DatFin.Date :=edt_DatIni.Date;

    ActiveControl :=edt_DatIni;

    Self.Inicialize ;
end;

procedure Tfrm_ManifestoList.Inicialize;
var
  Model: IManifestoDF;
begin
    Model :=TCManifestoDF.Create;
    m_Ctrl :=TCManifestoCtr.Create ;
    m_Ctrl.Model:=Model ;
    m_Ctrl.View :=Self;
    m_Ctrl.Inicialize ;
    //
end;

procedure Tfrm_ManifestoList.ModelChanged;
begin
//    Self.Inicialize ;

end;

class procedure Tfrm_ManifestoList.NewAndShow;
var
  V: IView ;
begin
   V :=Tfrm_ManifestoList.Create(Application);
   (V as Tfrm_ManifestoList).vst_Grid1.Clear ;
   (V as Tfrm_ManifestoList).ShowModal ;
end;

procedure Tfrm_ManifestoList.setStatusBar;
begin
    //
end;

procedure Tfrm_ManifestoList.vst_Grid1GetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  M: IManifestoDF ;
begin
    CellText :='';
    if Assigned(Node) then
    begin
        M :=m_Ctrl.ModelList.Items[Node.Index] ;
        case Column of
          00: CellText :=IntToStr(M.id) ;
          01: CellText :=M.chMDFE ;
          02: CellText :=TpEmitenteToStr(TTpEmitenteMDFe(m.tpAmbiente)) ;
          03: CellText :=IntToStr(M.numeroDoc) ;
          04: CellText :=Format('%d|%s',[M.Status,M.motivo]) ;
          05: CellText :=FormatDateTime('dd/MM/yyyy HH:NN', M.dhEmissao);
          06: CellText :=TpEmisToStr(TpcnTipoEmissao(m.tpEmissao)) ;
          07: CellText :=M.ufeIni ;
          08: CellText :=M.ufeFim ;
          //09: CellText :=IntToStr(M.id) ;
        end;
    end;
end;

end.
