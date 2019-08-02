unit Form.Manifesto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Mask, Menus,

  FormBase, uStatusBar, VirtualTrees, uVSTree,

  JvExStdCtrls, JvButton, JvCtrls, JvFooter, JvExExtCtrls, JvExtComponent,

  AdvOfficeStatusBar, AdvOfficeStatusBarStylers, AdvPanel, AdvPageControl,
  AdvCombo, AdvEdit, JvExMask, JvToolEdit, AdvGroupBox,
  AdvToolBar, AdvGlowButton, AdvMenus, AdvToolBarStylers, AdvEdBtn,
  GradientLabel,

  uIntf, uManifestoCtr, unotfis00, uVeiculoCtr, uCondutorCtr
  ;

type
  TAdvEditBtn =class(AdvEdBtn.TAdvEditBtn)
  public
    procedure formatReadOnly(const aReadOnly: Boolean;
      const aLabelCaption: string ='') ;
  end;




type
  Tfrm_Manifesto = class(TBaseForm, IView)
    AdvOfficeStatusBar1: TAdvOfficeStatusBar;
    pag_Control00: TAdvPageControl;
    tab_Browse: TAdvTabSheet;
    vst_Grid1: TVirtualStringTree;
    pnl_Filter: TAdvPanel;
    gbx_DtEmis: TAdvGroupBox;
    edt_DatIni: TJvDateEdit;
    edt_DatFin: TJvDateEdit;
    btn_Find: TJvImgBtn;
    gbx_CodPed: TAdvGroupBox;
    edt_PedIni: TAdvEdit;
    edt_PedFin: TAdvEdit;
    tab_Manifesto: TAdvTabSheet;
    gbx_Ident: TAdvGroupBox;
    cbx_mdfTpEmit: TAdvComboBox;
    cbx_mdfTpTrasp: TAdvComboBox;
    edt_mdfNumDoc: TAdvEdit;
    edt_mdfDtEmis: TAdvEdit;
    pag_Control01: TAdvPageControl;
    tab_Mun: TAdvTabSheet;
    tab_Rodo: TAdvTabSheet;
    vst_GridMun: TVirtualStringTree;
    pnl_Footer: TJvFooter;
    btn_Filter: TJvFooterBtn;
    btn_Close: TJvFooterBtn;
    btn_Vincula: TJvFooterBtn;
    btn_Save: TJvFooterBtn;
    pnl_Condutor: TAdvPanel;
    vst_GridCdtVinc: TVirtualStringTree;
    vst_GridCdtCad: TVirtualStringTree;
    btn_CdtCad: TJvImgBtn;
    btn_CdtAdd: TJvImgBtn;
    btn_CdtRmv: TJvImgBtn;
    Label1: TLabel;
    Label2: TLabel;
    cbx_CodUnd: TAdvComboBox;
    GradientLabel1: TGradientLabel;
    vst_GridCadVei: TVirtualStringTree;
    btn_CadVei: TJvImgBtn;
    btn_Desvinc: TJvImgBtn;
    procedure FormDestroy(Sender: TObject);
    procedure btn_FindClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure vst_GridMunChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vst_GridMunGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure btn_FilterClick(Sender: TObject);
    procedure btn_VinculaClick(Sender: TObject);
    procedure vst_GridCdtVincGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: string);
    procedure btn_SaveClick(Sender: TObject);
    procedure btn_CdtCadClick(Sender: TObject);
    procedure vst_GridCdtCadGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: string);
    procedure btn_CdtAddClick(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure btn_CdtRmvClick(Sender: TObject);
    procedure vst_Grid1GetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vst_Grid1HeaderClick(Sender: TVTHeader;
      HitInfo: TVTHeaderHitInfo);
    procedure vst_Grid1PaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
    procedure vst_Grid1Checked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vst_GridCadVeiGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: string);
    procedure btn_CadVeiClick(Sender: TObject);
    procedure pag_Control00Change(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btn_DesvincClick(Sender: TObject);
    procedure vst_GridMunBeforeItemErase(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect;
      var ItemColor: TColor; var EraseAction: TItemEraseAction);
    procedure vst_GridMunPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
  private
    { Private declarations }
    m_Ctrl: IManifestoCtr;
    m_Lote: TCNotFis00Lote;
    m_VeiculoCtr: TCVeiculoCtr;
    m_CondutorCtr: TCCondutorCtr;
    procedure loadGridMun ;
    procedure loadVeiculo ;
    procedure loadCondutores;
  private
    { Status Bar }
    m_StatusBar: TCStatusBarWidget;
    m_panelState: TAdvOfficeStatusPanel ;
    m_panelFilter: TAdvOfficeStatusPanel ;
    m_panelItems: TAdvOfficeStatusPanel ;
    m_panelProgress: TAdvOfficeStatusPanel ;
    procedure setStatusBar(const aPos: Int64 =0) ;

  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;

  public
    { Public declarations }
    constructor Create(aCtrl: IManifestoCtr); reintroduce ;
    procedure Inicialize;
    procedure ModelChanged;
    procedure Execute;
  end;


implementation

{$R *.dfm}

uses StrUtils, DateUtils, MaskUtils, TypInfo,
  uTaskDlg, uadodb, udbconst, ustr ,
  FDM.MDFE, fdm.Styles ,
  uManifestoDF, uVeiculo, uCondutor,
  Form.Veiculo, Form.Condutor ,
  pcnConversao
  ;

const
  C_MUNICIPIOS: array[TManifestodf01munTyp] of string = (
      'Município de Carregamento',
      'Município de Descarregamento'
      );

//  TpcteTipoRodado = (trNaoAplicavel, trTruck, trToco, trCavaloMecanico, trVAN, trUtilitario, trOutros);
function getTpRod(const aTyp: TpcteTipoRodado): string ;
begin
    Result :=GetEnumName(TypeInfo(TpcteTipoRodado), Integer(aTyp)) ;

end;

//  TpcteTipoCarroceria = (tcNaoAplicavel, tcAberta, tcFechada, tcGraneleira, tcPortaContainer, tcSider);
function getTpCar(const aTyp: TpcteTipoCarroceria): string ;
begin
    Result :=GetEnumName(TypeInfo(TpcteTipoCarroceria), Integer(aTyp)) ;

end;


{ Tfrm_Manifesto }

procedure Tfrm_Manifesto.btn_CadVeiClick(Sender: TObject);
var
  M: IVeiculo;
  V: IView ;
begin
    V :=Tfrm_Veiculo.Create(m_VeiculoCtr);
    m_VeiculoCtr.Model :=m_Ctrl.Model.modalRodo.veiculo ;
    m_VeiculoCtr.Model.OnModelChanged :=(V as Tfrm_Veiculo).ModelChanged ;
    m_VeiculoCtr.Model.Insert ;
    V.Execute ;
    loadVeiculo ;
    ActiveControl :=vst_GridCadVei ;
end;

procedure Tfrm_Manifesto.btn_CdtAddClick(Sender: TObject);
var
  C: ICondutor ;
begin
    if CMsgDlg.Confirm('Deseja vincular o condutor ao veículo?')then
    begin
        C :=m_CondutorCtr.ModelList.Items[vst_GridCdtCad.IndexItem] ;
        if m_Ctrl.Model.modalRodo.condutores.indexOf(C.id) <> nil then
        begin
            raise Exception.CreateFmt('o condutor [%d|%s], já vinculado!',[C.id,C.Nome]);
        end;
        m_Ctrl.Model.modalRodo.condutores.addNew(C) ;
        vst_GridCdtVinc.AddChild(nil) ;
    end;
end;

procedure Tfrm_Manifesto.btn_CdtCadClick(Sender: TObject);
var
  M: ICondutor ;
  V: IView ;
begin
    M :=TCCondutor.Create ;
    V :=Tfrm_Condutor.Create(m_CondutorCtr);
    m_CondutorCtr.Model :=M;
    m_CondutorCtr.Model.OnModelChanged :=(V as Tfrm_Condutor).ModelChanged ;
    m_CondutorCtr.Model.Insert ;
    V.Execute ;
    loadCondutores ;
end;

procedure Tfrm_Manifesto.btn_CdtRmvClick(Sender: TObject);
var
  C: ICondutor ;
begin
{    if CMsgDlg.Confirm('Deseja remover o vinculo do condutor?')then
    begin
        C :=m_CondutorCtr.ModelList.Items[vst_GridCdtCad.IndexItem] ;
        if m_Ctrl.Model.modalRodo.condutores.indexOf(C.id) <> nil then
        begin
            raise Exception.CreateFmt('o condutor [%d|%s], já vinculado!',[C.id,C.Nome]);
        end;
        m_Ctrl.Model.modalRodo.condutores.addNew(C) ;
        vst_GridCdtVinc.AddChild(nil) ;
    end;}
end;

procedure Tfrm_Manifesto.btn_CloseClick(Sender: TObject);
begin
    Self.Close;

end;

procedure Tfrm_Manifesto.btn_DesvincClick(Sender: TObject);
var
  P: PVirtualNode ;
  M: TCManifestodf01mun;
  N: IManifestodf02nfe ;
begin
    if CMsgDlg.Confirm('Deseja desvincular a nota fiscal selecionada do manifesto?')then
    begin
        P :=vst_GridMun.GetFirstSelected();
        P.States :=P.States +[vsDeleting] ;

        M :=m_Ctrl.Model.municipios.getDataList[P.Parent.Parent.Index] ;
        N :=M.nfeList.getDataList[P.Index] ;
        N.State :=msDelete ;

    end;
end;

procedure Tfrm_Manifesto.btn_FilterClick(Sender: TObject);
begin
    if pag_Control00.ActivePageIndex <> 0 then
    begin
        pag_Control00.ActivePageIndex :=0 ;
        pnl_Filter.Visible :=True ;
        ActiveControl :=edt_PedIni;
    end
    else
        pnl_Filter.Visible :=not pnl_Filter.Visible ;
end;

procedure Tfrm_Manifesto.btn_FindClick(Sender: TObject);
    //
    //
    procedure LoadGrid;
    var
      N: TCNotFis00 ;
      P: PVirtualNode ;
      M: TCManifestodf01mun;
      I: IManifestodf02nfe ;
    begin
        vst_Grid1.Clear ;
        for N in m_lote.Items do
        begin
            N.Checked :=True ;

            P :=vst_Grid1.AddChild(nil) ;
            //
            // chk mun. descarga
            M :=m_Ctrl.Model.municipios.indexOf(N.m_dest.EnderDest.cMun,mtDescarga) ;
            if M <> nil then
            begin
                //
                // chk se NFE já vinculada!
                for I in M.nfeList.getDataList do
                begin
                    if AnsiCompareStr(N.m_chvnfe,I.chvNFE)=0 then
                    begin
                        N.Checked :=False ;
                        Break ;
                    end;
                end;
            end;
            if N.Checked then
            begin
                P.CheckType :=ctCheckBox ;
                P.CheckState :=csCheckedNormal ;
            end
            else
                Include(P.States, vsDisabled);
        end;
        vst_Grid1.IndexItem :=0 ;
        vst_Grid1.Refresh ;
    end;
    //
    //
var
  F: TNotFis00Filter;
begin
    //
    // reset filtro
    F.Create(0, 0) ;


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
            F.pedini :=edt_PedIni.IntValue ;
            F.pedfin :=edt_PedFin.IntValue ;
        end;
    end

    else begin
        if edt_DatIni.Date > edt_DatFin.Date then
        begin
            CMsgDlg.Info('Data inicial maior que data final!') ;
            edt_DatIni.SetFocus;
            exit;
        end
        else begin
            F.datini :=edt_DatIni.Date ;
            F.datfin :=edt_DatFin.Date ;
        end;
    end;


    F.codmod :=55 ;
    F.nserie :=0;
    F.status :=sttAutoriza ;

    vst_Grid1.Clear ;
    setStatus('Carregando NFE'#13#10'Aguarde...', crSQLWait);
    try
      m_lote.Load(F) ;
    finally
      setStatus('');
    end;

    if m_lote.Items.Count > 0 then
    begin
        btn_Vincula.Enabled :=True ;
        btn_Filter.Click ;
        LoadGrid() ;
        ActiveControl :=vst_Grid1 ;
        setStatusBar();
    end
    else begin
        btn_Vincula.Enabled :=False ;
        CMsgDlg.Info('Nenhuma NFE encontrada neste filtro!') ;
        edt_DatIni.SetFocus ;
    end;
end;

procedure Tfrm_Manifesto.btn_SaveClick(Sender: TObject);
var
  P: PVirtualNode;
  V: IVeiculo ;
begin

    pag_Control00.ActivePageIndex :=1 ;
    //
    // set model
    m_Ctrl.Model.codUfe :=21;
    //m_Ctrl.Model.tpAmbiente  :=cbx_mdfTpAmb.ItemIndex;
    m_Ctrl.Model.tpEmitente :=cbx_mdfTpEmit.ItemIndex;
    m_Ctrl.Model.tpTransportador :=cbx_mdfTpTrasp.ItemIndex;
    //m_Ctrl.Model.tpEmissao  :=cbx_mdfTpEmis.ItemIndex;
    //m_Ctrl.Model.modalidade  :=0
    //m_Ctrl.Model.dataHoraEmissao :=0
    //m_Ctrl.Model.ufeIni  :=edt_mdfUFCarga.Text ;
    //m_Ctrl.Model.ufeFim  :=edt_mdfUFDescarga.Text ;
    m_Ctrl.Model.codund :=cbx_CodUnd.ItemIndex;
    //
    // sel vei

    if vst_GridCadVei.IndexItem > -1 then
    begin
        P :=vst_GridCadVei.GetFirstChecked();
        V :=m_VeiculoCtr.ModelList.Items[P.Index];
        m_Ctrl.Model.modalRodo.veiculo.cmdFind(V.id) ;
    end;

    try
        //
        // valid input

        if m_Ctrl.Merge =mukInsert then
        begin
            CMsgDlg.Info(SInsertSucess,['MANIFESTO'])
        end
        else begin
            CMsgDlg.Info(SUpdateSucess,['MANIFESTO']);
        end;
        ModalResult :=mrOk ;
    except
        on E: ECodUnidIsEmpty do
        begin
            CMsgDlg.Error(E.Message);
            ActiveControl :=cbx_CodUnd;
        end;

        on E: EMunCargaIsEmpty do
        begin
            CMsgDlg.Error(E.Message);
            pag_Control01.ActivePageIndex :=0 ;
        end;

        on E: ECondutorIsEmpty do
        begin
            CMsgDlg.Error(E.Message);
            pag_Control01.ActivePageIndex :=1 ;
            ActiveControl :=btn_CdtAdd;
        end;

        on E: EDocIsEmpty do
        begin
            CMsgDlg.Error(E.Message);
            pag_Control01.ActivePageIndex :=0 ;
            //ActiveControl :=btn_NFeAdd;
        end;

        on E: Exception do
        begin
            CMsgDlg.Error(E.Message);
            //ActiveControl :=btn_MunCargaAdd;
        end;

    end;
end;

procedure Tfrm_Manifesto.btn_VinculaClick(Sender: TObject);
var
  N: TCNotFis00 ;
  M: TCManifestodf01mun;
  I: IManifestodf02nfe ;
begin
    if CMsgDlg.Confirm('Deseja vincular as notas fiscais selecionadas ao manifesto?')then
    begin
        //
        // loop para add os municipios
        for N in m_Lote.Items do
        begin
            //
            // valida vinculo
            if N.Checked then
            begin
                //
                // mun. carga
                M :=m_Ctrl.Model.municipios.indexOf(N.m_emit.EnderEmit.cMun,mtCarga) ;
                if M = nil then
                begin
                    M :=TCManifestodf01mun.New( 0,
                                                N.m_emit.EnderEmit.cMun,
                                                N.m_emit.EnderEmit.xMun,
                                                N.m_emit.EnderEmit.UF,
                                                mtCarga );
                    m_Ctrl.Model.municipios.addNew(M) ;
                end;

                //
                // mun. descarga
                M :=m_Ctrl.Model.municipios.indexOf(N.m_dest.EnderDest.cMun,mtDescarga) ;
                if M = nil then
                begin
                    M :=TCManifestodf01mun.New( 0,
                                                N.m_dest.EnderDest.cMun,
                                                N.m_dest.EnderDest.xMun,
                                                N.m_dest.EnderDest.UF,
                                                mtDescarga );
                    m_Ctrl.Model.municipios.addNew(M) ;
                end;

                //
                // add nfe somente para mum. descarga
                if M.tipoMun =mtDescarga then
                begin
                    I :=M.nfeList.indexOf(N.m_chvnfe) ;
                    if I = nil then
                        M.nfeList.addNew(
                          TCManifestodf02nfe.New( N.m_chvnfe, '', False,
                                                  N.m_icmstot.vNF,
                                                  N.m_transp.Vol.Items[0].pesoB,
                                                  N.m_codseq
                                                )
                        ) ;
                end;
            end;
        end;
        //
        // carga grid
        loadGridMun ;
        pag_Control00.ActivePageIndex :=1;
        pag_Control01.ActivePageIndex :=0;
        ActiveControl :=vst_GridMun ;
        vst_Grid1.Clear ;
    end;
end;

constructor Tfrm_Manifesto.Create(aCtrl: IManifestoCtr);
begin
    inherited Create(Application);
    m_Ctrl :=aCtrl;
    m_lote :=TCNotFis00Lote.Create ;
    m_VeiculoCtr :=TCVeiculoCtr.Create;
    m_CondutorCtr :=TCCondutorCtr.Create ;

    //
    // add Panels
    m_StatusBar :=TCStatusBarWidget.Create(AdvOfficeStatusBar1, False);
    m_panelState:=m_StatusBar.AddPanel(psHTML, '', 75, taCenter) ;
    m_panelFilter:=m_StatusBar.AddPanel(psHTML, '<b>F2</b> Filtro', 75, taCenter) ;
    m_panelItems:=m_StatusBar.AddPanel(psHTML, '', 200) ;
    m_panelProgress:=m_StatusBar.AddPanel(psProgress, '', 250) ;

    edt_PedIni.Clear;
    edt_PedFin.Clear;
    edt_DatIni.Date :=Date;
    edt_DatFin.Date :=edt_DatIni.Date;
    //
    //

    cbx_mdfTpEmit.AddItem('1 - Prestador de serviço de transporte', nil);
    cbx_mdfTpEmit.AddItem('2 - Transportador de Carga Própria', nil);
    cbx_mdfTpEmit.AddItem('3 - Prestador de serviço de transporte que emitirá CT-e Globalizado', nil);

    cbx_mdfTpTrasp.AddText('"1 - ETC","2 - TAC","3 - CTC"');
    //
    // unid med
    cbx_CodUnd.AddText('"00-uM3","01-uKG","02-uTON","03-uUNIDADE","04-uLITROS","05-uMMBTU"');

end;

procedure Tfrm_Manifesto.Execute;
begin
    Self.ShowModal ;

end;

procedure Tfrm_Manifesto.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    if m_Ctrl.Model.State <> msBrowse then
    begin
        CanClose :=CMsgDlg.Confirm('As mudanças ainda não foram salvas!'#13#10'Deseja sair?') ;
    end;
end;

procedure Tfrm_Manifesto.FormDestroy(Sender: TObject);
begin
    m_lote.Destroy ;

end;

procedure Tfrm_Manifesto.FormShow(Sender: TObject);
begin
    //
    // inicializa controls
    vst_Grid1.Clear ;

    //
    // inicializa View conforme model
    Self.Inicialize ;

    //
    // trava controls
    pag_Control01.ActivePageIndex :=0;
    btn_Vincula.Enabled :=False ;
    //
    //
    setStatusBar();
end;

procedure Tfrm_Manifesto.Inicialize;
var
  U: UtilStr ;
begin
    //
    // inicializa a view conforme o model
    //

    cbx_mdfTpEmit.ItemIndex :=m_Ctrl.Model.tpEmitente ;
    cbx_mdfTpTrasp.ItemIndex:=m_Ctrl.Model.tpTransportador;
    cbx_CodUnd.ItemIndex :=m_Ctrl.Model.codund ;
    if m_Ctrl.Model.State = msInsert then
    begin
        edt_mdfNumDoc.Text :='';
        edt_mdfDtEmis.Text :='';
    end
    else begin
        edt_mdfNumDoc.Text :=FormatMaskText('000\.000\.000;0; ',U.Zeros(m_Ctrl.Model.numeroDoc,9)) ;
        edt_mdfDtEmis.Text :=U.fDtTm(m_Ctrl.Model.dhEmissao,'DD/MM/YYYY hh:nn') ;
    end;

    //
    // load mun/docs
    loadGridMun ;

    //
    // load modal/rodoviario
    loadVeiculo ;

    //
    // load condutores
    loadCondutores ;


    //
    // muda o stado da view conforme o estado do model
    //

    //
    // habilita para insert/edit
    if m_Ctrl.Model.State <> msBrowse then
    begin
        edt_DatIni.Date :=StartOfTheMonth(Date);
        edt_DatFin.Date :=Date;
        if m_Ctrl.Model.State = msInsert then
        begin
            pag_Control00.ActivePageIndex :=0 ;
            ActiveControl :=edt_DatIni;
        end
        else begin
            pag_Control00.ActivePageIndex :=1;
        end;
    end
    //
    // somente leitura
    else begin
        tab_Browse.TabVisible :=False ;
        gbx_Ident.Enabled :=False ;
        btn_Filter.Visible :=False ;
        btn_Vincula.Enabled :=False;
        btn_Desvinc.Visible :=False;
        btn_Save.Enabled :=False;
        btn_CadVei.Visible :=False;
        pnl_Condutor.Enabled :=False;
    end;
end;

procedure Tfrm_Manifesto.KeyDown(var Key: Word; Shift: TShiftState);
begin
    case Key of
//        VK_F1: pnl_Help.Visible :=not pnl_Help.Visible ;
        VK_F2: if btn_Filter.Visible then btn_Filter.Click ;
        VK_ESCAPE: btn_Close.Click ;
    else
        inherited;
    end;
end;

procedure Tfrm_Manifesto.loadCondutores;
begin
    //
    // cadastro
    vst_GridCdtCad.Clear ;
    m_CondutorCtr.ModelList.Load ;
    vst_GridCdtCad.RootNodeCount :=m_CondutorCtr.ModelList.Items.Count ;
    vst_GridCdtCad.IndexItem :=0;
    btn_CdtAdd.Enabled :=vst_GridCdtCad.RootNodeCount > 0;

    //
    // condutores vinculados
    vst_GridCdtVinc.Clear ;
    vst_GridCdtVinc.RootNodeCount :=m_Ctrl.Model.modalRodo.condutores.Items.Count ;
    vst_GridCdtVinc.IndexItem :=0;
    btn_CdtRmv.Enabled :=vst_GridCdtVinc.RootNodeCount > 0;
end;

procedure Tfrm_Manifesto.loadGridMun;
var
  p0,p1: PVirtualNode ;
  M: TCManifestodf01mun;
  N: IManifestodf02nfe ;
begin
    vst_GridMun.Clear ;
    //
    // grupo mun. carga
    p0 :=vst_GridMun.AddChild(nil) ;
    p0.States :=p0.States +[vsExpanded] ;
    for M in m_Ctrl.Model.municipios.getDataList do
    begin
        //
        // mun. carga
        if M.tipoMun =mtCarga then
        begin
            vst_GridMun.AddChild(p0) ;
        end;
    end;

    //
    // grupo mun. descarga
    p0 :=vst_GridMun.AddChild(nil) ;
    p0.States :=p0.States +[vsExpanded] ;
    for M in m_Ctrl.Model.municipios.getDataList do
    begin
        //
        // mun. descarga
        if M.tipoMun =mtDescarga then
        begin
            p1 :=vst_GridMun.AddChild(p0) ;
            p1.States :=p1.States +[vsExpanded] ;

            //
            // add as nfe
            for N in M.nfeList.getDataList do
            begin
                vst_GridMun.AddChild(p1) ;
            end;
        end;
    end;

    vst_GridMun.IndexItem :=0;
    //vst_GridMun.Refresh ;
end;

procedure Tfrm_Manifesto.loadVeiculo;
var
  V: IVeiculo ;
var
  P: PVirtualNode ;
begin
    //
    // carga cad.veiculo
    m_VeiculoCtr.ModelList.Load ;

    vst_GridCadVei.Clear ;
    for V in m_VeiculoCtr.ModelList.Items do
    begin
        P :=vst_GridCadVei.AddChild(nil) ;
        P.CheckType :=ctRadioButton ;
        if P.Index =0 then
            P.CheckState :=csCheckedNormal;
    end;

    if m_Ctrl.Model.modalRodo.veiculo.id > 0 then
    begin
        V :=m_VeiculoCtr.ModelList.indexOf(m_Ctrl.Model.modalRodo.veiculo.id) ;
        vst_GridCadVei.IndexItem :=m_VeiculoCtr.ModelList.Items.IndexOf(V);
    end
    else
        vst_GridCadVei.IndexItem :=0 ;
end;

procedure Tfrm_Manifesto.ModelChanged;
begin
    Self.Inicialize ;

end;

procedure Tfrm_Manifesto.pag_Control00Change(Sender: TObject);
begin
    setStatusBar()
    ;
end;

procedure Tfrm_Manifesto.setStatusBar(const aPos: Int64);
var
  M: TCManifestodf01mun;
begin
    if aPos > 0 then
        m_panelProgress.Progress.Position :=aPos
    else begin
        case m_Ctrl.Model.State of
            msInactive: m_panelState.Text :='<b>Inativo</b>';
            msEdit: m_panelState.Text :='<b>Edição</b>';
            msInsert: m_panelState.Text :='<b>NOVO</b>';
            msBrowse: m_panelState.Text :='<b>Consulta</b>';
        end;

        if pag_Control00.ActivePage =tab_Browse then
        begin
            if m_Lote.Items.Count > 0 then
                m_panelItems.Text :=Format(' <b>%d</b> Notas Fiscais encontradas',[m_Lote.Items.Count])
            else
                m_panelItems.Text :=' Nenhum';
        end
        else begin
            M :=m_Ctrl.Model.municipios.getFirstMun(mtDescarga);
            if M <> nil then
                m_panelItems.Text :=Format(' <b>%d</b> Notas Fiscais vinculadas',[M.qNFe])
            else
                m_panelItems.Text :=' Nenhuma NFE vinculada';
        end;
    end;
end;

procedure Tfrm_Manifesto.vst_GridCadVeiGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  V: IVeiculo ;
begin
    if Assigned(Node) then
    begin
        V :=m_VeiculoCtr.ModelList.Items[Node.Index] ;
        case Column of
            00: CellText :=IntToStr(V.id) ;
            01: if V.placa <> '' then
                begin
                    CellText :=FormatMaskText('LLLL\-9999;0; ',V.placa);
                end
                else begin
                    CellText :='';
                end;
            02: CellText :=IntToStr(V.tara) ;
            03: CellText :=IntToStr(V.capacidadeKg) ;
            04: CellText :=IntToStr(V.capacidadeM3) ;
            05: CellText :=getTpRod(TpcteTipoRodado(V.tipRodado)) ;
            06: CellText :=getTpCar(TpcteTipoCarroceria(V.tipCarroceria)) ;
            07: CellText :=V.ufLicenca;
        end;
    end;
end;

procedure Tfrm_Manifesto.vst_GridCdtCadGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  C: ICondutor ;
begin
    if Assigned(Node) then
    begin
        C :=m_CondutorCtr.ModelList.Items[Node.Index] ;
        CellText :=Format('%s!%s',[C.CPFCNPJ,C.Nome]);
    end;
end;

procedure Tfrm_Manifesto.vst_GridCdtVincGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  C: ICondutor ;
begin
    if Assigned(Node) then
    begin
        C :=m_Ctrl.Model.modalRodo.condutores.Items[Node.Index] ;
        CellText :=Format('%s!%s',[C.CPFCNPJ,C.Nome]);
    end;
end;

procedure Tfrm_Manifesto.vst_GridMunBeforeItemErase(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect;
  var ItemColor: TColor; var EraseAction: TItemEraseAction);
begin
    if vsDeleting in Node.States then
        ItemColor := clBtnFace
    else
        ItemColor :=vst_GridMun.Color;
    EraseAction := eaColor;
end;

procedure Tfrm_Manifesto.vst_GridMunChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  M: TCManifestodf01mun;
  N: IManifestodf02nfe ;
begin
    case Sender.GetNodeLevel(Node) of
        2: // docs (NFE) vinculados
        begin
            M :=m_Ctrl.Model.municipios.getDataList[Node.Parent.Parent.Index] ;
            N :=M.nfeList.getDataList[Node.Index] ;
            btn_Desvinc.Enabled :=N.State <> msDelete ;
        end;
    else
        btn_Desvinc.Enabled :=False;
    end;
end;

procedure Tfrm_Manifesto.vst_GridMunGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  M: TCManifestodf01mun ;
  N: IManifestodf02nfe ;
  S:UtilStr ;
begin
    if Assigned(Node) then
    begin
        case Sender.GetNodeLevel(Node) of

            0: // grupo municipios
            if Column = 0 then
            begin
                CellText :=C_MUNICIPIOS[TManifestodf01munTyp(Node.Index)]
            end
            else begin
                CellText :=''
            end;

            1: // municipios carga/descarga
            begin
                M :=m_Ctrl.Model.municipios.getDataList[Node.Parent.Index] ;
                case Column of
                    0: CellText :=Format('%d-%s (%d)',[M.codigoMun,M.nomeMun,Ord(M.tipoMun)]) ;
                    1: CellText :='';
                    2: CellText :='';
                    3: CellText :='';
                end;
            end;

            2: // docs (NFE) vinculados
            begin
                M :=m_Ctrl.Model.municipios.getDataList[Node.Parent.Parent.Index] ;
                N :=M.nfeList.getDataList[Node.Index] ;
                case Column of
                    0: CellText :=N.chvNFE ;
                    1: CellText :='1';
                    2: CellText :=S.fCur(N.vlrNtf);
                    3: CellText :=S.fFlt(N.volPsoB);
                end;
            end;
        end;
    end;
end;

procedure Tfrm_Manifesto.vst_GridMunPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
    if TextType = ttNormal then
    begin
        if Assigned(Node) and ((Node <> Sender.FocusedNode))then
        begin
            if vsDeleting in Node.States then
                TargetCanvas.Font.Color :=clBtnShadow
            else
                TargetCanvas.Font.Color :=clWindowText ;
        end;
    end;
end;

procedure Tfrm_Manifesto.vst_Grid1Checked(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  N: TCNotFis00 ;
begin
    if Assigned(Node) then
    begin
        N :=m_Lote.Items[Node.Index] ;
        N.Checked := Node.CheckState =csCheckedNormal ;
    end;
end;

procedure Tfrm_Manifesto.vst_Grid1GetText(Sender: TBaseVirtualTree;
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
        05: CellText :=FormatDateTime('dd/MM/yyyy HH:NN', N.m_dtemis) ;
        06: CellText :=CFrmtStr.Cur(N.m_icmstot.vNF) ;
        07: CellText :=CFrmtStr.Flt(N.m_transp.Vol.Items[0].pesoB, 3) ;
    end;
end;

procedure Tfrm_Manifesto.vst_Grid1HeaderClick(Sender: TVTHeader;
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

procedure Tfrm_Manifesto.vst_Grid1PaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  C: TCanvas;
  N: TCNotFis00 ;
  cs: NotFis00CodStatus ;
begin
    C :=TargetCanvas ;
    if TextType = ttNormal then
    begin
        N :=m_Lote.Items[Node.Index] ;
        if(Node = Sender.FocusedNode)and(Column = Sender.FocusedColumn) then
        begin
            C.Font.Color :=clWhite ;
        end
        else begin
            //TpcnTipoEmissao = (teNormal, teContingencia, teSCAN, teDPEC, teFSDA, teSVCAN, teSVCRS, teSVCSP, teOffLine);
            if N.m_tipemi <> teNormal then
                TargetCanvas.Font.Color :=clMaroon
            else
                TargetCanvas.Font.Color :=clGreen ;
        end;
    end;
end;

{ TAdvEditBtn }

procedure TAdvEditBtn.formatReadOnly(const aReadOnly: Boolean;
  const aLabelCaption: string);
begin
    Self.ReadOnly :=aReadOnly;
    if Self.ReadOnly then
    begin
        Self.Color :=clMoneyGreen ;
        if aLabelCaption <> '' then
            Self.LabelCaption :=aLabelCaption
        else
            Self.LabelCaption :='Tecla [back] cancela consulta:';
    end
    else begin
        Self.Color :=clWindow ;
        if aLabelCaption <> '' then
            Self.LabelCaption :=aLabelCaption
        else
            Self.LabelCaption :='Código';
        Self.Clear ;
    end;
end;

end.
