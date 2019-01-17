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

  uIntf, uManifestoCtr, unotfis00, uCondutor
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
    gbx_Condutor: TAdvGroupBox;
    vst_GridCondutor: TVirtualStringTree;
    edt_CdtCod: TAdvEditBtn;
    pnl_Footer: TJvFooter;
    btn_Filter: TJvFooterBtn;
    btn_Close: TJvFooterBtn;
    btn_Vincula: TJvFooterBtn;
    btn_Remove: TJvFooterBtn;
    btn_Save: TJvFooterBtn;
    procedure FormDestroy(Sender: TObject);
    procedure btn_FindClick(Sender: TObject);
    procedure edt_VeiCodClickBtn(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure pag_Control00Change(Sender: TObject);
    procedure vst_GridMunChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vst_GridMunGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure btn_FilterClick(Sender: TObject);
    procedure edt_CdtCodClickBtn(Sender: TObject);
    procedure btn_VinculaClick(Sender: TObject);
    procedure vst_GridCondutorGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: string);
    procedure btn_SaveClick(Sender: TObject);
  private
    { Private declarations }
    m_Ctrl: IManifestoCtr;
    m_StatusBar: TCStatusBarWidget;
    m_lote: TCNotFis00Lote;
    m_Condutor: ICondutor;
    procedure loadGridMun ;
    procedure loadVeiculo ;
    procedure loadCondutor;
  private
    procedure VincNFE ;
    procedure VincVei ;
    procedure VincCdt ;
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
  uManifestoDF, uVeiculoCtr, uVeiculo, uCondutorCtr,
  Form.Veiculo, Form.Condutor
  ;

const
  C_MUNICIPIOS: array[TManifestodf01munTyp] of string = (
      'Município de Carregamento',
      'Município de Descarregamento'
      );

{ Tfrm_Manifesto }

procedure Tfrm_Manifesto.btn_FilterClick(Sender: TObject);
begin
  pnl_Filter.Visible :=not pnl_Filter.Visible ;

end;

procedure Tfrm_Manifesto.btn_FindClick(Sender: TObject);
    //
    //
    procedure LoadGrid;
    var
      N: TCNotFis00 ;
      P: PVirtualNode ;
    begin
        vst_GridNFE.Clear ;
        for N in m_lote.Items do
        begin
            N.Checked :=True ;
            P :=vst_GridNFE.AddChild(nil) ;
            P.CheckType :=ctCheckBox ;
            P.CheckState :=csCheckedNormal ;
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
    m_Ctrl.Model.tpEmitente  :=cbx_mdfTpEmit.ItemIndex;
    m_Ctrl.Model.tpTransportador  :=cbx_mdfTpTrasp.ItemIndex;
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
            ActiveControl :=edt_CdtCod;
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
begin
    if pag_Control00.ActivePageIndex = 0 then
        VincNFE
    else
        VincCdt ;
end;

constructor Tfrm_Manifesto.Create(aCtrl: IManifestoCtr);
begin
    inherited Create(Application);
    m_Ctrl :=aCtrl;
    m_StatusBar :=TCStatusBarWidget.Create(AdvOfficeStatusBar1, False);
    m_lote :=TCNotFis00Lote.Create ;
    m_Condutor :=TCCondutor.Create ;

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

procedure Tfrm_Manifesto.edt_CdtCodClickBtn(Sender: TObject);
var
  V: IView ;
  C: TCCondutorCtr;
  F: TCondutorFilter;
var
  cod,e: Integer ;
begin

    //
    try
        Val(edt_CdtCod.Text, F.codseq, e) ;
        if F.codseq = 0 then
        begin
            F.xnome :=edt_CdtCod.Text;
        end;

        if not m_Condutor.cmdFind(F) then
        begin
            C :=TCCondutorCtr.Create();
            V :=Tfrm_Condutor.Create(C);
            C.Model :=m_Condutor;
            C.Model.OnModelChanged :=(V as Tfrm_Condutor).ModelChanged ;
            C.Model.Insert ;
            V.Execute ;
        end;

        if m_Condutor.id > 0 then
        begin
            edt_CdtCod.Text :=Format('%d|%s',[m_Condutor.id,m_Condutor.Nome]);
            edt_CdtCod.formatReadOnly(True);
        end;
    except
        on E: EBuscaIsEmpty do
        begin
            CMsgDlg.Error(E.Message);
            edt_CdtCod.SetFocus ;
        end;
    end;
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

    if m_Ctrl.Model.State = msInsert then
        pag_Control00.ActivePageIndex :=0
    else
        pag_Control00.ActivePageIndex :=1;

    pag_Control01.ActivePageIndex :=0;

    //
    // reset/trava controles
    ResetWContrls(gbx_Ident);

    vst_GridNFE.Clear ;
    vst_GridMun.Clear ;
    vst_GridCondutor.Clear ;

    {*
     * ler estado do model
     *}

    if m_Ctrl.Model.id > 0 then
    begin
        Self.Caption :=Format('Manifesto Id: %d',[m_Ctrl.Model.id]) ;
        //
        // load grid
        loadGridMun ;

        //
        // load modal/rodoviario
        loadVeiculo ;

        //
        // load condutores
        loadCondutor ;

    end ;
{
    edt_mdfNumDoc.IntValue :=m_Ctrl.Model.numeroDoc ;
    if m_Ctrl.Model.dhEmissao > 0 then
    begin
        edt_mdDtEmis.Text    :=DateTimeToStr(m_Ctrl.Model.dhEmissao) ;
    end;
    cbx_mdfTpAmb.ItemIndex :=m_Ctrl.Model.tpAmbiente ;
    cbx_mdfTpEmit.ItemIndex :=m_Ctrl.Model.tpEmitente;
    cbx_mdfTpTrasp.ItemIndex :=m_Ctrl.Model.tpTransportador ;
    cbx_mdfTpEmis.ItemIndex :=m_Ctrl.Model.tpEmissao ;
    edt_mdfUFCarga.Text  :=m_Ctrl.Model.ufeIni;
    edt_mdfUFDescarga.Text  :=m_Ctrl.Model.ufeFim;

    case m_Ctrl.Model.State of
        msInactive: ResetWContrls(gbx_Ident, True);
    end;
    FormatCod;

    btn_Config.Enabled :=m_Ctrl.Model.State = msInactive;
    btn_New.Enabled :=m_Ctrl.Model.State = msInactive;
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
        else if ActiveControl =edt_CdtCod then
        begin
            if edt_CdtCod.ReadOnly then
                inherited
            else
                edt_CdtCodClickBtn(edt_VeiCod);
        end
        else
            inherited;
        VK_BACK:
        begin
            if ActiveControl = edt_VeiCod then
            begin
                edt_VeiCod.formatReadOnly(False) ;
                m_Ctrl.Model.modalRodo.veiculo.Inicialize ;
            end
            else if ActiveControl =edt_CdtCod then
            begin
                edt_CdtCod.formatReadOnly(False);
                m_Condutor.Inicialize ;
            end;
        end;
    else
        inherited;
    end;
end;

procedure Tfrm_Manifesto.loadCondutor;
var
  C: TCCondutorCtr;
  I: ICondutor ;
begin
    C :=TCCondutorCtr.Create ;
    C.ModelList.Load ;
    edt_CdtCod.Lookup.DisplayList.Clear;
    edt_CdtCod.Lookup.ValueList.Clear  ;
    for I in C.ModelList.Items do
    begin
        edt_CdtCod.Lookup.DisplayList.Add(I.Nome);
        edt_CdtCod.Lookup.ValueList.Add(IntToStr(I.id));
    end;
    edt_CdtCod.Lookup.DisplayCount :=8 ;
    edt_CdtCod.Lookup.NumChars :=1;
    edt_CdtCod.Lookup.History :=True;
    edt_CdtCod.Lookup.Multi :=False;
    edt_CdtCod.Lookup.Enabled :=true ;
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

    edt_VeiCod.Text :=IntToStr(m_Ctrl.Model.modalRodo.veiculo.id);
    edt_VeiCodClickBtn(edt_VeiCod) ;
end;

procedure Tfrm_Manifesto.ModelChanged;
begin
    Self.Inicialize ;

end;

procedure Tfrm_Manifesto.pag_Control00Change(Sender: TObject);
begin
    btn_Filter.Enabled :=pag_Control00.ActivePageIndex =0 ;

end;

procedure Tfrm_Manifesto.VincCdt;
begin
    if CMsgDlg.Confirm('Deseja vincular o condutor ao veículo?')then
    begin
        if m_Ctrl.Model.modalRodo.condutores.indexOf(m_Condutor.id) <> nil then
        begin
            raise Exception.CreateFmt('o condutor [%d-%s], já incluído!',[m_Condutor.id,m_Condutor.Nome]);
        end;
        m_Ctrl.Model.modalRodo.condutores.addNew(m_Condutor) ;
        vst_GridCondutor.AddChild(nil) ;
        edt_CdtCod.formatReadOnly(False);
        m_Condutor.Inicialize ;
        ActiveControl :=edt_CdtCod;
    end;
end;

procedure Tfrm_Manifesto.VincNFE;
var
  L: TCNotFis00Lote ;
  N: TCNotFis00 ;
  M: TCManifestodf01mun;
  I: IManifestodf02nfe ;
begin
    if CMsgDlg.Confirm('Deseja vincular as notas ao manifesto?')then
    begin

        //
        // loop para add os municipios
        for N in L.Items do
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
                                                N.m_codseq,
                                                N.m_icmstot.vNF,
                                                N.m_transp.Vol.Items[0].pesoB
                                                )
                    ) ;
                end;
            end;
        end;
    end;
end;

procedure Tfrm_Manifesto.VincVei;
begin

end;

procedure Tfrm_Manifesto.vst_GridCondutorGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  C: ICondutor ;
begin
    if Assigned(Node) then
    begin
        C :=m_Ctrl.Model.modalRodo.condutores.Items[Node.Index] ;
        case Column of
            0: CellText :=C.CPFCNPJ;
            1: CellText :=C.Nome;
        end;
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
