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

  uIntf, uManifestoCtr, unotfis00, uCondutorCtr, uCondutor
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
    vst_GridNFE: TVirtualStringTree;
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
    edt_mdDtEmis: TAdvEdit;
    pag_Control01: TAdvPageControl;
    tab_Mun: TAdvTabSheet;
    tab_Rodo: TAdvTabSheet;
    vst_GridMun: TVirtualStringTree;
    edt_VeiCod: TAdvEditBtn;
    pnl_Footer: TJvFooter;
    btn_Filter: TJvFooterBtn;
    btn_Close: TJvFooterBtn;
    btn_Vincula: TJvFooterBtn;
    btn_Remove: TJvFooterBtn;
    btn_Save: TJvFooterBtn;
    pnl_Condutor: TAdvPanel;
    vst_GridCdtVinc: TVirtualStringTree;
    vst_GridCdtCad: TVirtualStringTree;
    btn_CdtCad: TJvImgBtn;
    btn_CdtAdd: TJvImgBtn;
    btn_CdtRmv: TJvImgBtn;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormDestroy(Sender: TObject);
    procedure btn_FindClick(Sender: TObject);
    procedure edt_VeiCodClickBtn(Sender: TObject);
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
    procedure pag_Control00Change(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure btn_CdtRmvClick(Sender: TObject);
    procedure vst_GridNFEGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
  private
    { Private declarations }
    m_Ctrl: IManifestoCtr;
    m_StatusBar: TCStatusBarWidget;
    m_Lote: TCNotFis00Lote;
    m_CondutorCtr: TCCondutorCtr;
    procedure loadGridMun ;
    procedure loadVeiculo ;
    procedure loadCondutores;
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

uses StrUtils, DateUtils,
  uTaskDlg, uadodb, udbconst,
  FDM.NFE, fdm.Styles ,
  uManifestoDF, uVeiculoCtr, uVeiculo,
  Form.Veiculo, Form.Condutor
  ;

const
  C_MUNICIPIOS: array[TManifestodf01munTyp] of string = (
      'Município de Carregamento',
      'Município de Descarregamento'
      );

{ Tfrm_Manifesto }

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
        vst_GridNFE.Clear ;
        for N in m_lote.Items do
        begin
            N.Checked :=True ;

            P :=vst_GridNFE.AddChild(nil) ;
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
        vst_GridNFE.IndexItem :=0 ;
        vst_GridNFE.Refresh ;
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
    F.status :=sttProcess ;

    vst_GridNFE.Clear ;
    setStatus('Carregando NFE'#13#10'Aguarde...', crSQLWait);
    try
      m_lote.Load(F) ;
    finally
      setStatus('');
    end;

    if m_lote.Items.Count > 0 then
    begin
        LoadGrid() ;
        btn_Filter.Click ;
        ActiveControl :=vst_GridNFE ;
        btn_Vincula.Enabled :=True ;
    end
    else begin
        btn_Vincula.Enabled :=False ;
        CMsgDlg.Info('Nenhuma NFE encontrada neste filtro!') ;
        edt_DatIni.SetFocus ;
    end;
end;

procedure Tfrm_Manifesto.btn_SaveClick(Sender: TObject);
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

    try
        if m_Ctrl.Merge =mukInsert then
        begin
            CMsgDlg.Info(SInsertSucess,['MANIFESTO'])
        end
        else begin
            CMsgDlg.Info(SUpdateSucess,['MANIFESTO']);
        end;
        ModalResult :=mrOk ;
    except
        on E: EMunCargaIsEmpty do
        begin
            CMsgDlg.Error(E.Message);
            pag_Control01.ActivePageIndex :=0 ;
        end;

        on E: EVeiculoIsEmpty do
        begin
            CMsgDlg.Error(E.Message);
            pag_Control01.ActivePageIndex :=1 ;
            ActiveControl :=edt_VeiCod;
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
    if CMsgDlg.Confirm('Deseja vincular as notas ao manifesto?')then
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
                    M.nfeList.addNew(
                        TCManifestodf02nfe.New( N.m_chvnfe, '', False,
//                                                N.m_codseq,
                                                N.m_icmstot.vNF,
                                                N.m_transp.Vol.Items[0].pesoB
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
        vst_GridNFE.Clear ;
    end;
end;

constructor Tfrm_Manifesto.Create(aCtrl: IManifestoCtr);
begin
    inherited Create(Application);
    m_Ctrl :=aCtrl;
    m_StatusBar :=TCStatusBarWidget.Create(AdvOfficeStatusBar1, False);
    m_lote :=TCNotFis00Lote.Create ;
    m_CondutorCtr :=TCCondutorCtr.Create ;

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
end;

procedure Tfrm_Manifesto.edt_VeiCodClickBtn(Sender: TObject);
var
  M: IVeiculo ;
  V: IView ;
  C: IVeiculoCtr;
var
  cod,e: Integer ;
begin
    try
        Val(edt_VeiCod.Text, cod, e) ;
        if cod > 0 then
        begin
            m_Ctrl.Model.modalRodo.veiculo.cmdFind(cod);
        end
        else begin
            C :=TCVeiculoCtr.Create();
            V :=Tfrm_Veiculo.Create(C);
            C.Model :=m_Ctrl.Model.modalRodo.veiculo ;
            C.Model.OnModelChanged :=(V as Tfrm_Veiculo).ModelChanged ;
            C.Model.Insert ;
            V.Execute ;
        end;
        if m_Ctrl.Model.modalRodo.veiculo.id > 0 then
        begin
            edt_VeiCod.Text :=Format('Id:%d, Placa: %s, Tara em (Kg): %d',[
                                      m_Ctrl.Model.modalRodo.veiculo.id ,
                                      m_Ctrl.Model.modalRodo.veiculo.placa ,
                                      m_Ctrl.Model.modalRodo.veiculo.tara]) ;
            edt_VeiCod.formatReadOnly(True);
        end;
    except
        on E: EBuscaIsEmpty do
        begin
            CMsgDlg.Error(E.Message);
            edt_VeiCod.SetFocus ;
        end;
    end;
end;

procedure Tfrm_Manifesto.Execute;
begin
    Self.ShowModal ;

end;

procedure Tfrm_Manifesto.FormDestroy(Sender: TObject);
begin
    m_lote.Destroy ;

end;

procedure Tfrm_Manifesto.FormShow(Sender: TObject);
begin
    Self.Inicialize ;

end;

procedure Tfrm_Manifesto.Inicialize;
begin
    //
    // muda o stado da view conforme o estado do model
    //

    //
    // format titulo
    if m_Ctrl.Model.id > 0 then
    begin
        if m_Ctrl.Model.State <> msBrowse then
            Self.Caption :=Format('Edição de Manifesto[Id: %d]',[m_Ctrl.Model.id])
        else
            Self.Caption :=Format('Consulta de Manifesto[Id: %d]',[m_Ctrl.Model.id])
    end
    else
        Self.Caption :='Emissão de Manifesto';

    if m_Ctrl.Model.State <> msBrowse then
    begin
        edt_DatIni.Date :=StartOfTheMonth(Date);
        edt_DatFin.Date :=Date;
        if m_Ctrl.Model.State = msInsert then
        begin
            pag_Control00.ActivePageIndex :=0 ;
            ActiveControl :=edt_DatFin;
        end
        else
            pag_Control00.ActivePageIndex :=1;
    end
    else begin
        tab_Browse.TabVisible :=False ;
    end;

    cbx_mdfTpEmit.Enabled :=m_Ctrl.Model.State <> msBrowse;
    cbx_mdfTpTrasp.Enabled :=m_Ctrl.Model.State <> msBrowse;
    edt_mdfNumDoc.Enabled :=False ;
    edt_mdDtEmis.Enabled :=False ;

    btn_Filter.Visible :=tab_Browse.TabVisible ;
    btn_Vincula.Visible :=tab_Browse.TabVisible;
    btn_Remove.Visible :=tab_Browse.TabVisible ;
    btn_Save.Visible :=tab_Browse.TabVisible ;

    pag_Control01.ActivePageIndex :=0;

    vst_GridNFE.Clear ;

    //
    // load grid
    loadGridMun ;

    //
    // load modal/rodoviario
    loadVeiculo ;

    //
    // load condutores
    loadCondutores ;

    edt_mdfNumDoc.IntValue :=m_Ctrl.Model.numeroDoc ;
    if m_Ctrl.Model.dhEmissao > 0 then
    begin
        edt_mdDtEmis.Text    :=DateTimeToStr(m_Ctrl.Model.dhEmissao, LocalFormatSettings) ;
    end;

    cbx_mdfTpEmit.ItemIndex :=m_Ctrl.Model.tpEmitente;
    cbx_mdfTpTrasp.ItemIndex :=m_Ctrl.Model.tpTransportador ;

//    case m_Ctrl.Model.State of
//        msInactive: ResetWContrls(gbx_Ident, True);
//    end;

    {btn_New.Enabled :=m_Ctrl.Model.State = msInactive;
    btn_Save.Enabled:=m_Ctrl.Model.State in[msInsert, msEdit];
    btn_Cancel.Enabled:=m_Ctrl.Model.State in[msInsert, msEdit];
    btn_Delete.Enabled:=m_Ctrl.Model.State = msBrowse;
    btn_Edit.Enabled  :=m_Ctrl.Model.State = msBrowse;
    btn_Send.Enabled  :=m_Ctrl.Model.State = msBrowse;
    }
end;

procedure Tfrm_Manifesto.KeyDown(var Key: Word; Shift: TShiftState);
begin
    case Key of
        VK_RETURN:
        if ActiveControl =edt_VeiCod then
        begin
            if edt_VeiCod.ReadOnly or edt_VeiCod.IsEmpty() then
                inherited
            else
                edt_VeiCodClickBtn(edt_VeiCod);
        end
        else
            inherited;
        VK_BACK:
        if ActiveControl = edt_VeiCod then
        begin
            edt_VeiCod.formatReadOnly(False) ;
            m_Ctrl.Model.modalRodo.veiculo.Inicialize ;
        end;
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
  C: TCVeiculoCtr;
  I: IVeiculo ;
begin
    C :=TCVeiculoCtr.Create ;
    C.ModelList.Load ;
    edt_VeiCod.Lookup.DisplayList.Clear;
    edt_VeiCod.Lookup.ValueList.Clear  ;
    for I in C.ModelList.Items do
    begin
        edt_VeiCod.Lookup.DisplayList.Add(I.placa);
        edt_VeiCod.Lookup.ValueList.Add(IntToStr(I.id));
    end;
    edt_VeiCod.Lookup.DisplayCount :=8 ;
    edt_VeiCod.Lookup.NumChars :=1;
    edt_VeiCod.Lookup.History :=True;
    edt_VeiCod.Lookup.Multi :=False;
    edt_VeiCod.Lookup.Enabled :=true ;

    if m_Ctrl.Model.modalRodo.veiculo.id > 0 then
    begin
        edt_VeiCod.Text :=IntToStr(m_Ctrl.Model.modalRodo.veiculo.id);
        edt_VeiCodClickBtn(edt_VeiCod) ;
    end;
end;

procedure Tfrm_Manifesto.ModelChanged;
begin
    Self.Inicialize ;

end;

procedure Tfrm_Manifesto.pag_Control00Change(Sender: TObject);
begin
    btn_Vincula.Enabled :=pag_Control00.ActivePageIndex =0;

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

procedure Tfrm_Manifesto.vst_GridMunChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
    case Sender.GetNodeLevel(Node) of
        2: // docs (NFE) vinculados
        btn_Remove.Enabled :=True ;
    else
        btn_Remove.Enabled :=False;
    end;
end;

procedure Tfrm_Manifesto.vst_GridMunGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  M: TCManifestodf01mun ;
  N: IManifestodf02nfe ;
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
                    1: CellText :='';
                    2: CellText :='';
                    3: CellText :='';
                end;
            end;
        end;
    end;
end;

procedure Tfrm_Manifesto.vst_GridNFEGetText(Sender: TBaseVirtualTree;
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
