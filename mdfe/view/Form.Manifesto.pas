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

  uIntf, uManifestoCtr, unotfis00
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
    AdvDockPanel1: TAdvDockPanel;
    AdvToolBar1: TAdvToolBar;
    pag_Control00: TAdvPageControl;
    tab_Browse: TAdvTabSheet;
    vst_GridNFE: TVirtualStringTree;
    pnl_Filter: TAdvPanel;
    gbx_DtEmis: TAdvGroupBox;
    Label1: TLabel;
    edt_DatIni: TJvDateEdit;
    edt_DatFin: TJvDateEdit;
    btn_Find: TJvImgBtn;
    gbx_CodPed: TAdvGroupBox;
    edt_PedIni: TAdvEdit;
    edt_PedFin: TAdvEdit;
    AdvGroupBox1: TAdvGroupBox;
    edt_Chave: TMaskEdit;
    tab_Manifesto: TAdvTabSheet;
    gbx_Ident: TAdvGroupBox;
    cbx_mdfTpEmit: TAdvComboBox;
    cbx_mdfTpTrasp: TAdvComboBox;
    edt_mdfNumDoc: TAdvEdit;
    edt_mdDtEmis: TAdvEdit;
    edt_mdfUFCarga: TAdvEdit;
    edt_mdfUFDescarga: TAdvEdit;
    pag_Control01: TAdvPageControl;
    tab_Mun: TAdvTabSheet;
    tab_Rodo: TAdvTabSheet;
    vst_GridMun: TVirtualStringTree;
    btn_AddNFE: TJvImgBtn;
    btn_MunRemove: TJvImgBtn;
    btn_MunFindNFE: TJvImgBtn;
    btn_MunRemoveNFE: TJvImgBtn;
    edt_VeiCod: TAdvEditBtn;
    gbx_Condutor: TAdvGroupBox;
    vst_GridCondutor: TVirtualStringTree;
    edt_CdtCod: TAdvEditBtn;
    btn_Filter: TAdvGlowButton;
    procedure btn_AddNFEClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_FindClick(Sender: TObject);
    procedure edt_VeiCodClickBtn(Sender: TObject);
    procedure btn_FilterClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure pag_Control00Change(Sender: TObject);
    procedure vst_GridMunChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vst_GridMunGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
  private
    { Private declarations }
    m_Ctrl: IManifestoCtr;
    m_StatusBar: TCStatusBarWidget;
    m_lote: TCNotFis00Lote ;
    procedure loadGridMun ;
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
  uManifestoDF, uVeiculoCtr, uVeiculo, uCondutorCtr, uCondutor
  ;

const
  C_MUNICIPIOS: array[TManifestodf01munTyp] of string = (
      'Município de Carregamento',
      'Município de Descarregamento'
      );


{ Tfrm_Manifesto }

procedure Tfrm_Manifesto.btn_AddNFEClick(Sender: TObject);
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

procedure Tfrm_Manifesto.btn_FilterClick(Sender: TObject);
begin
    if pag_Control00.ActivePageIndex =0 then
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

    if not edt_Chave.IsEmpty() then
    begin
        F.chvnfe :=edt_Chave.Text ;
    end
    else begin

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
        btn_AddNFE.Enabled :=True ;
    end
    else begin
        btn_AddNFE.Enabled :=False ;
        CMsgDlg.Info('Nenhuma NFE encontrada neste filtro!') ;
        edt_DatIni.SetFocus ;
    end;
end;

constructor Tfrm_Manifesto.Create(aCtrl: IManifestoCtr);
begin
    inherited Create(Application);
    m_Ctrl :=aCtrl;
    m_StatusBar :=TCStatusBarWidget.Create(AdvOfficeStatusBar1);

    edt_Chave.DoFormatEditMask(femCustom, 'Chave incorreta!',
    '0000\ 0000\ 0000\ 0000\ 0000\ 0000\ 0000\ 0000\ 0000\ 0000\ 0000;0; ');
    edt_PedIni.Clear;
    edt_PedFin.Clear;
    edt_DatIni.Date :=Date;
    edt_DatFin.Date :=edt_DatIni.Date;
    //
    //
    m_lote :=TCNotFis00Lote.Create ;

    cbx_mdfTpEmit.AddItem('1 - Prestador de serviço de transporte', nil);
    cbx_mdfTpEmit.AddItem('2 - Transportador de Carga Própria', nil);
    cbx_mdfTpEmit.AddItem('3 - Prestador de serviço de transporte que emitirá CT-e Globalizado', nil);

    cbx_mdfTpTrasp.AddText('"1 - ETC","2 - TAC","3 - CTC"');
end;

procedure Tfrm_Manifesto.edt_VeiCodClickBtn(Sender: TObject);
var
  C: IVeiculoCtr;
  V: IVeiculo ;
var
  cod,e: Integer ;
begin
    try
        Val(edt_VeiCod.Text, cod, e) ;
        if cod > 0 then
        begin
            m_Ctrl.Model.modalRodo.veiculo.cmdFind(cod);
            edt_VeiCod.Text :=Format('Id:%d, Placa: %s, Tara em (Kg): %d',[
                                        m_Ctrl.Model.modalRodo.veiculo.id ,
                                        m_Ctrl.Model.modalRodo.veiculo.placa ,
                                        m_Ctrl.Model.modalRodo.veiculo.tara]) ;
            edt_VeiCod.formatReadOnly(True);
        end
        else begin
            C :=TCVeiculoCtr.Create() ;
            if C.cmdFind(cod) then
            begin
                m_Ctrl.Model.modalRodo.veiculo.cmdFind(C.Model.id);
                edt_VeiCod.Text :=Format('Id:%d, Placa: %s, Tara em (Kg): %d',[
                                          m_Ctrl.Model.modalRodo.veiculo.id ,
                                          m_Ctrl.Model.modalRodo.veiculo.placa ,
                                          m_Ctrl.Model.modalRodo.veiculo.tara]) ;
                edt_VeiCod.formatReadOnly(True);
            end;
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
        // carga grid
        loadGridMun ;

        //
        // carga modal
       edt_VeiCod.Text :=IntToStr( m_Ctrl.Model.modalRodo.veiculo.id );
       edt_VeiCodClickBtn(edt_VeiCod) ;
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

procedure Tfrm_Manifesto.ModelChanged;
begin
    Self.Inicialize ;

end;

procedure Tfrm_Manifesto.pag_Control00Change(Sender: TObject);
begin
    btn_Filter.Enabled :=pag_Control00.ActivePageIndex =0 ;
end;

procedure Tfrm_Manifesto.vst_GridMunChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
    case Sender.GetNodeLevel(Node) of
        0: // grupo municipios
        begin
            btn_MunRemove.Enabled :=False ;
            btn_MunRemoveNFE.Enabled :=False ;
        end;

        1: // municipios carga/descarga
        begin
            btn_MunRemove.Enabled :=True ;
            btn_MunRemoveNFE.Enabled :=False ;
        end;

        2: // docs (NFE) vinculados
        begin
            btn_MunRemove.Enabled :=False ;
            btn_MunRemoveNFE.Enabled :=True ;
        end;
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
    end;
end;

end.
