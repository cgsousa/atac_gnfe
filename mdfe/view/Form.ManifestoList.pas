unit Form.ManifestoList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Mask,

  AdvToolBar, AdvOfficeStatusBar, AdvOfficeButtons, AdvEdit,
  AdvGroupBox, AdvPanel, AdvGlowButton,

  JvExStdCtrls, JvButton, JvCtrls, JvExMask, JvToolEdit,

  FormBase, uStatusBar, VirtualTrees, uVSTree,
  JvFooter, JvExExtCtrls, JvExtComponent, Menus, AdvMenus,
  ActnList,

  uACBrMDFe, uIntf, uManifestoCtr
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
    ActionList1: TActionList;
    act_ConsStt: TAction;
    act_ConsProt: TAction;
    procedure FormShow(Sender: TObject);
    procedure btn_FindClick(Sender: TObject);
    procedure vst_Grid1GetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure btn_NewClick(Sender: TObject);
    procedure btn_EditClick(Sender: TObject);
    procedure btn_FilterClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn_SendClick(Sender: TObject);
    procedure btn_DetalhClick(Sender: TObject);
    procedure btn_ConfigClick(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure vst_Grid1Change(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure act_ConsProtExecute(Sender: TObject);
    procedure btn_ConsClick(Sender: TObject);
  private
    { Private declarations }
    m_Ctrl: TCManifestoCtr;
    m_Param: TRegMDFe;
  protected
    { StatusBar }
    m_StatusBar: TCStatusBarWidget;
    m_panelAmb: TAdvOfficeStatusPanel ;
    m_panelItems: TAdvOfficeStatusPanel ;
    m_panelVTotal: TAdvOfficeStatusPanel ;
    m_panelProgress: TAdvOfficeStatusPanel ;
    m_panelText: TAdvOfficeStatusPanel ;
    procedure setStatusBar(const aPos: Int64 =0) ;
  public
    { Public declarations }
    procedure Inicialize;
    procedure ModelChanged;
    procedure Execute;
  end;

var
  frm_ManifestoList: Tfrm_ManifestoList ;


implementation

uses StrUtils, DateUtils,
  pcnConversao, pmdfeConversaoMDFe, ACBrUtil, ACBrMDFeManifestos,
  uadodb, uTaskDlg, udbconst, ucademp,
  uManifestoDF,
  fdm.Styles, Form.Manifesto, Form.ParametroList;



{$R *.dfm}

{ Tfrm_ManifestoList }

procedure Tfrm_ManifestoList.act_ConsProtExecute(Sender: TObject);
var
  M: IManifestoDF;
//  rep: Tdm_nfe ;
//  ret: Boolean ;
begin
    if CMsgDlg.Confirm('Deseja consultar o Protocolo de autorização?') then
    begin
{        M :=m_Ctrl.ModelList.Items[vst_Grid1.IndexItem] ;

        setStatus('Processando...',crHourGlass);
        try
          rep :=Tdm_nfe.getInstance ;
          ret :=rep.OnlyConsMDFe(M) ;
          setStatus(rep.ErrMsg);

          if ret then
          begin
              CMsgDlg.Info(M.motivo) ;
//              setStatus('Carregando a grade de dados');
//              LoadGrid ;
          end
          else begin
              CMsgDlg.Warning(Format('%d-%s',[Tdm_nfe.getInstance.ErrCod,Tdm_nfe.getInstance.ErrMsg])) ;
          end;

        finally
          setStatus('');
        end;
}
    end;
    ActiveControl :=vst_Grid1;
end;

procedure Tfrm_ManifestoList.btn_CloseClick(Sender: TObject);
begin
    Self.Close ;

end;

procedure Tfrm_ManifestoList.btn_ConfigClick(Sender: TObject);
var
  pwd: string ;
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
    //
    Tfrm_ParametroList.lp_Show('MDFE') ;
    m_Param.Load ;
end;

procedure Tfrm_ManifestoList.btn_ConsClick(Sender: TObject);
var
  rep: IBaseACBrMDFe ;
begin
    if CMsgDlg.Confirm('Deseja consultar o status do serviço?') then
    begin
        setStatus('Cominucando, aguarde...');
        try
          rep :=TCBaseACBrMDFe.New(True, m_Param) ;
          if rep.OnlyStatusSvc then
          begin
              CMsgDlg.Info(rep.mdfe.WebServices.StatusServico.Msg) ;
          end
          else begin
              CMsgDlg.Warning(rep.ErrMsg) ;
          end;
        finally
          setStatus('');
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
        btn_Filter.Click ;
        btn_Detalh.Enabled :=True ;
        ActiveControl :=vst_Grid1;
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
  rep: IBaseACBrMDFe;
  M: Manifesto ;
//  F: TManifestoFilter;
begin
    if CMsgDlg.Confirm('Deseja autorizar o uso do manifesto?')then
    begin
        rep :=TCBaseACBrMDFe.New(True, m_Param) ;
        setStatus('Processando o MDF-e'#13#10'Aguarde...', crHourGlass);
        try
            //
            // ler manifesto selecionado
            m_Ctrl.Model :=m_Ctrl.ModelList.Items[vst_Grid1.IndexItem] ;
            if(m_Ctrl.Model <> nil)then //and(m_Ctrl.Model.Merge =mukModify) then
            begin
//                F.Create(m_Ctrl.Model.id);
//                m_Ctrl.Model.cmdFind(F)  ;
//                ret :=rep.OnlySendMDFE(m_Ctrl.Model) ;
//                setStatus('');
                if rep.OnlySend(m_Ctrl.Model) then
                begin
                    M :=rep.mdfe.Manifestos.Items[0] ;
                    m_Ctrl.Model.setRet(
                        M.MDFe.procMDFe.cStat ,
                        M.MDFe.procMDFe.xMotivo,
                        M.MDFe.procMDFe.verAplic,
                        rep.mdfe.WebServices.Retorno.Recibo,
                        M.MDFe.procMDFe.nProt,
                        M.MDFe.procMDFe.digVal ,
                        M.MDFe.procMDFe.dhRecbto);
                    CMsgDlg.Info('%d-%s',[m_Ctrl.Model.Status,m_Ctrl.Model.motivo])
                end
                else
                    CMsgDlg.Warning(rep.ErrMsg);
            end;
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
    m_panelAmb:=m_StatusBar.AddPanel(psHTML, '', 90, taCenter) ;
    m_panelItems:=m_StatusBar.AddPanel(psHTML, '', 80, taCenter) ;
    m_panelVTotal:=m_StatusBar.AddPanel(psHTML, '', 140, taRightJustify) ;
    m_panelProgress:=m_StatusBar.AddPanel(psProgress, '', 250) ;
    m_panelText:=m_StatusBar.AddPanel(psHTML) ;

    //
    // conn
    ConnectionADO :=NewADOConnFromIniFile('Configuracoes.ini') ;

    if AdoConnect('') then
    begin
        CadEmp:=TCCadEmp.New(1) ;
//        m_Rep :=TCBaseACBrMDFe.New();
        m_Param.Load ;
        AdoDisconnect ;
    end;
end;

procedure Tfrm_ManifestoList.FormShow(Sender: TObject);
begin
    Caption :=Application.Title ;

    edt_DatIni.Date :=StartOfTheMonth(Date);
    edt_DatFin.Date :=Date;

    ActiveControl :=edt_DatFin;

    Self.Inicialize ;
end;

procedure Tfrm_ManifestoList.Inicialize;
begin
    btn_Edit.Enabled  :=False;
    btn_Detalh.Enabled:=False;
    btn_Send.Enabled:=False;
    btn_Canc.Enabled:=False;
    vst_Grid1.Clear ;
    setStatusBar();
end;

procedure Tfrm_ManifestoList.ModelChanged;
begin
    Self.Inicialize ;

end;

procedure Tfrm_ManifestoList.setStatusBar(const aPos: Int64) ;
var
  M: IManifestoDF ;
var
  s_frmt, s_text: string;
  process, cancel: Boolean ;
begin
    if aPos > 0 then
    begin
        m_panelProgress.Progress.Position :=aPos ;
    end
    else begin
        //
        // ind. tipo ambiente
        if m_Param.amb_pro.Value then
        begin
            s_frmt :='<p><font color="#FFFFFF" bgcolor="#00BF00"><b>%s</b></font</p>';
            s_text :=PadCenter('Produção', 13) ;
        end
        else begin
            s_frmt :='<p><font color="#FFFFFF" bgcolor="#FF0000"><b>%s</b></font</p>';
            s_text :=PadCenter('Homologação', 13) ;
        end;
        m_panelAmb.Text :=Format(s_frmt,[s_text]);

        if m_Ctrl.ModelList.Items.Count > 0 then
        begin
            M :=m_Ctrl.ModelList.Items[vst_Grid1.IndexItem];
            m_panelItems.Text :=Format('s:<b>%d</b>',[m_Ctrl.ModelList.Items.Count]);
            //m_panelVTotal.Text :=Format('Total:<b>%10.2m</b>',[m_Lote.vTotalNF]);

            //
            // ckk doc processado
            process :=M.Status in[100, 110, 150];
            process :=process or
                      (M.Status =301)or
                      (M.Status =302)or
                      (M.Status =303);
            //
            // ckk doc cancelado
            cancel  :=M.Status in[101, 151, 155];


            if process then
            begin
                m_panelText.Text :=Format('<p>Situação: <font color="#006400">%s</font</p>',[M.motivo]);
            end
            else if cancel then
            begin
                m_panelText.Text :=Format('<p>Situação: <font color="#FF8C00">%s</font</p>',[M.motivo]);
            end
            else begin
              m_panelText.Text :=Format('<p>Situação: <font color="#8B0000">%s</font</p>',[M.motivo]);
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

procedure Tfrm_ManifestoList.vst_Grid1Change(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  M: IManifestoDF ;
  process, cancel: Boolean ;
begin
    if Assigned(Node) then
    begin
        //
        // extract manifesto
        M :=m_Ctrl.ModelList.Items[Node.Index] ;

        //
        // ckk doc processado
        process :=M.Status in[100, 110, 150];
        process :=process or
                  (M.Status =301)or
                  (M.Status =302)or
                  (M.Status =303);
        //
        // ckk doc cancelado
        cancel  :=M.Status in[101, 151, 155];

        //
        // send
        btn_Send.Enabled := ((not process)and(not cancel) )or
                            (M.Status in[0,1,9,77,88]   );

        if (not M.Status in[0,1,9,77,88]   ) then
        begin
            btn_Send.Enabled :=True;
        end;

        btn_Edit.Enabled :=(not process)and(not cancel);
    end;
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
          04: if M.Status = 0 then
              begin
                  CellText :='Não gerado XML';
              end
              else begin
                  CellText :=Format('%d|%s',[M.Status,M.motivo]) ;
              end;
          05: CellText :=FormatDateTime('dd/MM/yyyy HH:NN', M.dhEmissao);
          06: CellText :=TpEmisToStr(TpcnTipoEmissao(m.tpEmissao)) ;
          07: CellText :=M.ufeIni ;
          08: CellText :=M.ufeFim ;
          //09: CellText :=IntToStr(M.id) ;
        end;
    end;
end;

end.
