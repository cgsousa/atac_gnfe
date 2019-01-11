unit Form.ManifestoDF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Mask,
  FormBase,
  VirtualTrees, uVSTree,
  JvExStdCtrls, JvButton, JvCtrls, JvFooter, ExtCtrls,
  JvExExtCtrls, JvExtComponent,
  AdvPageControl, AdvPanel, AdvGroupBox, AdvGlowButton, AdvEdit, AdvEdBtn, AdvCombo,
  HTMLabel,

  JvPageList, JvExControls,
  //
  uIntf, uManifestoCtr
  ;


type
  TAdvEditBtn =class(AdvEdBtn.TAdvEditBtn)
  public
    procedure formatReadOnly(const aReadOnly: Boolean;
      const aLabelCaption: string ='') ;
  end;

type
  Tfrm_ManifestoDF = class(TBaseForm, IView)
    pnl_Footer: TJvFooter;
    btn_Close: TJvFooterBtn;
    btn_Config: TJvFooterBtn;
    btn_New: TJvFooterBtn;
    btn_Edit: TJvFooterBtn;
    btn_Cancel: TJvFooterBtn;
    btn_Delete: TJvFooterBtn;
    btn_Send: TJvFooterBtn;
    btn_Save: TJvFooterBtn;
    gbx_Ident: TAdvGroupBox;
    edt_mdfCod: TAdvEditBtn;
    cbx_mdfTpAmb: TAdvComboBox;
    cbx_mdfTpEmit: TAdvComboBox;
    cbx_mdfTpTrasp: TAdvComboBox;
    edt_mdfNumDoc: TAdvEdit;
    edt_mdDtEmis: TAdvEdit;
    cbx_mdfTpEmis: TAdvComboBox;
    edt_mdfUFCarga: TAdvEdit;
    edt_mdfUFDescarga: TAdvEdit;
    btn_MunCarga: TAdvGlowButton;
    btn_Modal: TAdvGlowButton;
    btn_Docs: TAdvGlowButton;
    pageList1: TJvPageList;
    pag_MunCarga: TJvStandardPage;
    pag_Modal: TJvStandardPage;
    pag_MunDescarga: TJvStandardPage;
    pnl_MunCarga: TAdvPanel;
    pnl_Modal: TAdvPanel;
    pnl_MunDescarga: TAdvPanel;
    vst_GridMunCarga: TVirtualStringTree;
    btn_MunCargaAdd: TJvImgBtn;
    btn_MunCargaDel: TJvImgBtn;
    edt_RNTRC: TAdvEdit;
    gbx_Veiculo: TAdvGroupBox;
    edt_VeiCod: TAdvEditBtn;
    btn_CadVei: TJvImgBtn;
    vst_GridMunDescarga: TVirtualStringTree;
    btn_MunDesgardaAdd: TJvImgBtn;
    btn_MunDesgardaDel: TJvImgBtn;
    btn_NFeAdd: TJvImgBtn;
    btn_NFeDel: TJvImgBtn;
    PanelStyler1: TAdvPanelStyler;
    gbx_Condutor: TAdvGroupBox;
    vst_GridCondutor: TVirtualStringTree;
    btn_CondtrAdd: TJvImgBtn;
    btn_CondtrDel: TJvImgBtn;
    btn_CadCondtr: TJvImgBtn;
    html_Veiculo: THTMLabel;
    procedure btn_MunDesgardaAddClick(Sender: TObject);
    procedure btn_MunDesgardaDelClick(Sender: TObject);
    procedure vst_GridMunDescargaGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: string);
    procedure btn_NFeAddClick(Sender: TObject);
    procedure edt_VeiCodClickBtn(Sender: TObject);
    procedure btn_CadVeiClick(Sender: TObject);
    procedure btn_NewClick(Sender: TObject);
    procedure btn_MunCargaClick(Sender: TObject);
    procedure edt_MunCargaCodClickBtn(Sender: TObject);
    procedure btn_MunCargaAddClick(Sender: TObject);
    procedure edt_mdfCodClickBtn(Sender: TObject);
    procedure btn_EditClick(Sender: TObject);
    procedure vst_GridMunCargaGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: string);
    procedure btn_MunCargaDelClick(Sender: TObject);
    procedure pageList1Changing(Sender: TObject; PageIndex: Integer;
      var AllowChange: Boolean);
    procedure btn_CancelClick(Sender: TObject);
    procedure btn_CondtrAddClick(Sender: TObject);
    procedure vst_GridCondutorGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: string);
    procedure btn_CadCondtrClick(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure btn_SaveClick(Sender: TObject);
    procedure btn_SendClick(Sender: TObject);
    procedure btn_ConfigClick(Sender: TObject);
  private
    { Private declarations }
    m_Ctrl: IManifestoCtr;
    procedure formatCod;
    procedure loadGrid ;
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
  uadodb, uTaskDlg, unotfis00, FDM.NFE,
  uManifestoDF, uVeiculoCtr, uVeiculo, uCondutorCtr, uCondutor,
  udbconst ,
  Form.MunList, Form.NFeList, Form.ParametroList
  ;

{ TAdvEditBtn }

procedure TAdvEditBtn.formatReadOnly(const aReadOnly: Boolean;
  const aLabelCaption: string) ;
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

{ Tfrm_ManifestoDF }

procedure Tfrm_ManifestoDF.btn_CadCondtrClick(Sender: TObject);
var
  C: ICondutorCtr ;
begin
    C :=TCCondutorCtr.Create() ;
    C.Inicialize;
    C.ExecView ;

end;

procedure Tfrm_ManifestoDF.btn_CadVeiClick(Sender: TObject);
var
  C: IVeiculoCtr ;
begin
    C :=TCVeiculoCtr.Create() ;
    C.Inicialize;
    C.ExecView ;

end;

procedure Tfrm_ManifestoDF.btn_CancelClick(Sender: TObject);
begin
    m_Ctrl.Inicialize ;
    ModelChanged ;
end;

procedure Tfrm_ManifestoDF.btn_CloseClick(Sender: TObject);
begin
    ModalResult :=mrCancel;

end;

procedure Tfrm_ManifestoDF.btn_CondtrAddClick(Sender: TObject);
var
  C: ICondutorCtr ;
  F: TCondutorFilter;
begin
    C :=TCCondutorCtr.Create() ;
    F.codseq :=0;
    if C.cmdFind(F) then
    begin
        if m_Ctrl.Model.modalRodo.condutores.indexOf(C.Model.id) <> nil then
        begin
            raise Exception.CreateFmt('o condutor [%d-%s], já incluído!',[C.Model.id,C.Model.Nome]);
        end;
        m_Ctrl.Model.modalRodo.condutores.addNew(C.Model) ;
        vst_GridCondutor.AddChild(nil) ;
    end;
end;

procedure Tfrm_ManifestoDF.btn_ConfigClick(Sender: TObject);
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

procedure Tfrm_ManifestoDF.btn_EditClick(Sender: TObject);
begin
    m_Ctrl.Edit
    ;
end;

procedure Tfrm_ManifestoDF.btn_MunCargaAddClick(Sender: TObject);
var
  mun: TCMun ;
  munCarga: IManifestodf01mun;
var
  count: Int32 ;
begin
    mun :=Tfrm_MunList.Execute(Empresa.UF) ;
    if mun <> nil then
    begin
        munCarga :=m_Ctrl.Model.munCarga.indexOf(mun.m_codmun);
        if munCarga <> nil then
        begin
            CMsgDlg.Warning('Município já incluido!') ;
            count :=0;
        end
        else begin
            m_Ctrl.Model.ufeIni :=mun.m_ufemun ;

            m_Ctrl.Model.munCarga.addNew(
                                          TCManifestodf01mun.New( mun.m_codmun,
                                                                  mun.m_nommun,
                                                                  mun.m_ufemun,
                                                                  mtCarga )
                                        );
            vst_GridMunCarga.AddChild(nil) ;
            count :=vst_GridMunCarga.RootNodeCount -1 ;
            btn_MunCargaDel.Enabled :=True;
        end;
        vst_GridMunCarga.IndexItem :=count;
        vst_GridMunCarga.Refresh ;
    end;
    ActiveControl :=vst_GridMunCarga ;
end;

procedure Tfrm_ManifestoDF.btn_MunCargaClick(Sender: TObject);
begin
    if sender =btn_MunCarga then
        pageList1.ActivePage :=pag_MunCarga
    else if sender =btn_Modal then
        pageList1.ActivePage :=pag_Modal
    else if sender =btn_Docs then
        pageList1.ActivePage :=pag_MunDescarga;
end;

procedure Tfrm_ManifestoDF.btn_MunCargaDelClick(Sender: TObject);
var
  M: IManifestodf01mun;
begin
    //
    // ler mun. sel
    M :=m_Ctrl.Model.munCarga.getDataList.Items[vst_GridMunCarga.IndexItem] ;
    if CMsgDlg.Confirm(Format('Deseja remover o Município[%s]?',[M.nomeMun]))then
    begin
        m_Ctrl.Model.munCarga.getDataList.Remove(M) ;
        //vst_GridMunCarga.Clear ;
        vst_GridMunCarga.RootNodeCount :=m_Ctrl.Model.munCarga.getDataList.Count;
        vst_GridMunCarga.Refresh ;
    end;

    ActiveControl :=vst_GridMunCarga ;
end;

procedure Tfrm_ManifestoDF.btn_MunDesgardaAddClick(Sender: TObject);
var
  mun: TCMun ;
  //munDescarga: IManifestodf01mun;
var
  count: Int32 ;
begin
    count :=0;
    mun :=Tfrm_MunList.Execute(Empresa.UF) ;
    if mun <> nil then
    begin
        {munDescarga :=m_Ctrl.Model.munDescarga.indexOf(mun.m_codmun);
        if munDescarga <> nil then
        begin
            CMsgDlg.Warning('Município já incluído!') ;
        end
        else begin
            munDescarga :=m_Ctrl.Model.munDescarga.addNew;
            munDescarga.codigoMun:=mun.m_codmun ;
            munDescarga.nomeMun  :=mun.m_nommun ;
            munDescarga.tipoMun  :=mtDescarga;
            vst_GridMunDescarga.AddChild(nil) ;
            count :=vst_GridMunDescarga.RootNodeCount -1 ;
        end;}

        m_Ctrl.Model.ufeFim :=mun.m_ufemun ;

        m_Ctrl.Model.munDescarga.municipio.codigoMun:=mun.m_codmun ;
        m_Ctrl.Model.munDescarga.municipio.nomeMun  :=mun.m_nommun ;
        m_Ctrl.Model.munDescarga.municipio.UFeMun   :=mun.m_ufemun ;
        m_Ctrl.Model.munDescarga.municipio.tipoMun  :=mtDescarga;

        if vst_GridMunDescarga.RootNodeCount < 1 then
            vst_GridMunDescarga.AddChild(nil);

        vst_GridMunDescarga.IndexItem :=count;
        vst_GridMunDescarga.Refresh ;
    end;
    ActiveControl :=vst_GridMunDescarga ;
end;

procedure Tfrm_ManifestoDF.btn_MunDesgardaDelClick(Sender: TObject);
begin
    //
end;

procedure Tfrm_ManifestoDF.btn_NewClick(Sender: TObject);
begin
    m_Ctrl.Insert
    ;
end;

procedure Tfrm_ManifestoDF.btn_NFeAddClick(Sender: TObject);
var
  P: PVirtualNode ;
  M: TCManifestodf01mun ;
  L: TCNotFis00Lote ;
  N: TCNotFis00 ;
begin
    L :=TCNotFis00Lote.Create ;
    try
        if Tfrm_NFEList.Execute(L) then
        begin
            //
            // obtem Mun. descarga
            P :=vst_GridMunDescarga.GetFirstSelected() ;
            if P <> nil then
            begin
                M :=m_Ctrl.Model.munDescarga.municipio ;
                for N in L.Items do
                begin
                    if N.Checked then
                    begin
                        m_Ctrl.Model.munDescarga.nfeList.addNew(
                            TCManifestodf02nfe.New( N.m_chvnfe, '', False,
                                                    N.m_codseq,
                                                    N.m_icmstot.vNF,
                                                    0)
                        ) ;
                        vst_GridMunDescarga.AddChild(P) ;
                    end;
                end;
                Include(P.States, vsExpanded) ;
                vst_GridMunDescarga.Refresh ;
            end;
        end;
    finally
        L.Free ;
    end;
end;

procedure Tfrm_ManifestoDF.btn_SaveClick(Sender: TObject);
begin

    //
    // set model
    m_Ctrl.Model.codUfe :=21;
    m_Ctrl.Model.tpAmbiente  :=cbx_mdfTpAmb.ItemIndex;
    m_Ctrl.Model.tpEmitente  :=cbx_mdfTpEmit.ItemIndex;
    m_Ctrl.Model.tpTransportador  :=cbx_mdfTpTrasp.ItemIndex;
    m_Ctrl.Model.tpEmissao  :=cbx_mdfTpEmis.ItemIndex;
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
    except
        on E: EMunCargaIsEmpty do
        begin
            CMsgDlg.Error(E.Message);
            pageList1.ActivePage :=pag_MunCarga ;
            ActiveControl :=btn_MunCargaAdd;
        end;

        on E: EVeiculoIsEmpty do
        begin
            CMsgDlg.Error(E.Message);
            pageList1.ActivePage :=pag_Modal ;
            ActiveControl :=edt_VeiCod;
        end;

        on E: ECondutorIsEmpty do
        begin
            CMsgDlg.Error(E.Message);
            pageList1.ActivePage :=pag_Modal ;
            ActiveControl :=btn_CondtrAdd;
        end;

        on E: EMunDescargaIsEmpty do
        begin
            CMsgDlg.Error(E.Message);
            pageList1.ActivePage :=pag_MunDescarga ;
            ActiveControl :=btn_MunDesgardaAdd;
        end;

        on E: EDocIsEmpty do
        begin
            CMsgDlg.Error(E.Message);
            pageList1.ActivePage :=pag_MunDescarga ;
            ActiveControl :=btn_NFeAdd;
        end;

        on E: Exception do
        begin
            CMsgDlg.Error(E.Message);
            pageList1.ActivePage :=pag_MunCarga ;
            //ActiveControl :=btn_MunCargaAdd;
        end;

    end;

end;

procedure Tfrm_ManifestoDF.btn_SendClick(Sender: TObject);
var
  rep: Tdm_nfe;
  ret: Boolean;
begin
    if CMsgDlg.Confirm('Deseja enviar este MDFe?')then
    begin
        rep :=Tdm_nfe.getInstance ;
        setStatus('Processando MDF-e'#13#10'Aguarde...', crHourGlass);
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
    ActiveControl :=edt_mdfCod ;
end;

constructor Tfrm_ManifestoDF.Create(aCtrl: IManifestoCtr);
begin
    inherited Create(Application);
    m_Ctrl :=aCtrl;

    cbx_mdfTpAmb.AddText('"1 - Produção","2 - Homologação"');

    cbx_mdfTpEmit.AddItem('1 - Prestador de serviço de transporte', nil);
    cbx_mdfTpEmit.AddItem('2 - Transportador de Carga Própria', nil);
    cbx_mdfTpEmit.AddItem('3 - Prestador de serviço de transporte que emitirá CT-e Globalizado', nil);

    cbx_mdfTpTrasp.AddText('"1 - ETC","2 - TAC","3 - CTC"');

    cbx_mdfTpEmis.AddText('"1 - Normal","2 - Contingência"');
end;

procedure Tfrm_ManifestoDF.edt_mdfCodClickBtn(Sender: TObject);
var
  F: TManifestoFilter;
begin
//    if edt_mdfCod.IsEmpty() then
//    begin
//        CMsgDlg.Warning('Digite um codigo ou selecione um filtro para localizar um manifesto!');
//        edt_mdfCod.SetFocus ;
//    end
//    else
      if edt_mdfCod.IsEmpty() then
      begin
          F.codseq :=0 ;
          F.datini :=StartOfTheMonth(Date) ;
          F.datfin :=Now ;
      end
      else begin
          F.codseq :=StrToIntDef(edt_mdfCod.Text, 0) ;
          F.datini :=0;
          F.datfin :=0;
      end;

      try
          m_Ctrl.cmdFind(F);
      except
          on E: EBuscaIsEmpty do
          begin
              CMsgDlg.Error(E.Message);
              edt_mdfCod.SetFocus ;
          end;
      end;
end;

procedure Tfrm_ManifestoDF.edt_MunCargaCodClickBtn(Sender: TObject);
begin
    //
    //
end;

procedure Tfrm_ManifestoDF.edt_VeiCodClickBtn(Sender: TObject);
//
  procedure fillHTML(V: TCVeiculo) ;
  var text: TStringList;
  begin
      text :=html_Veiculo.HTMLText ;
      text.Add(Format('<p>Placa: <b>%s</b>, Tara em (Kg): <b>%d</b></p>',[V.placa,V.tara])) ;
      text.Add(Format('<p>Tipo rodado: <b>%s</b>, Tipo carroceria: <b>%s</b>, UF licença: <b>%s</b></p>',[
        tpRodadoToStr(V.tipRodado),
        tpCarroceriaToStr(V.tipCarroceria),
        V.ufLicenca  ])) ;
  end;
//
var
  C: IVeiculoCtr;
  V: IVeiculo ;
begin
    try
        html_Veiculo.HTMLText.Clear ;
        if edt_VeiCod.IntValue > 0 then
        begin
            m_Ctrl.Model.modalRodo.veiculo.cmdFind(edt_VeiCod.IntValue);
            fillHTML(m_Ctrl.Model.modalRodo.veiculo);
            edt_VeiCod.formatReadOnly(True);
        end
        else begin
            C :=TCVeiculoCtr.Create() ;
            if C.cmdFind(edt_VeiCod.IntValue) then
            begin
                m_Ctrl.Model.modalRodo.veiculo.cmdFind(C.Model.id);
                fillHTML(m_Ctrl.Model.modalRodo.veiculo);
                edt_VeiCod.IntValue :=m_Ctrl.Model.modalRodo.veiculo.id;
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

procedure Tfrm_ManifestoDF.Execute;
begin
    Self.ShowModal
    ;
end;

procedure Tfrm_ManifestoDF.FormatCod;
begin
    case m_Ctrl.Model.State of
      msInactive:
      begin
          edt_mdfCod.Enabled :=True;
          edt_mdfCod.ReadOnly:=False;
          edt_mdfCod.Color :=clWindow ;
          edt_mdfCod.LabelCaption :='Código';
          //lbl_State.Caption :='Nenhum';
          ActiveControl :=edt_mdfCod ;
      end;
      msBrowse:
      begin
          edt_mdfCod.Enabled :=True;
          edt_mdfCod.ReadOnly:=True;
          edt_mdfCod.Color :=clMoneyGreen ;
          edt_mdfCod.LabelCaption :='Tecla [back] cancela consulta:';
          //lbl_State.Caption :='Consulta';
          ActiveControl :=edt_mdfCod ;
      end;
      msEdit:
      begin
          edt_mdfCod.Enabled :=False;
          edt_mdfCod.ReadOnly:=False;
          edt_mdfCod.LabelCaption :='Código';
          //lbl_State.Caption :='Edição';
          //ActiveControl :=edt_Placa;
      end;
      msInsert:
      begin
          edt_mdfCod.Enabled :=False;
          edt_mdfCod.ReadOnly:=False;
          edt_mdfCod.LabelCaption :='Código';
          //lbl_State.Caption :='Novo';
          //ActiveControl :=edt_Placa;
      end;
    end;
end;

procedure Tfrm_ManifestoDF.Inicialize;
begin
    //
    // muda o stado da view conforme o estado do model

    //
    // reset/trava controles
    ResetWContrls(gbx_Ident);

    btn_MunCarga.Enabled:=m_Ctrl.Model.State <> msInactive;
    btn_Modal.Enabled   :=m_Ctrl.Model.State <> msInactive;
    btn_Docs.Enabled    :=m_Ctrl.Model.State <> msInactive;

    PanelStyler1.Style  :=psTMS ;
    pageList1.ActivePage:=pag_MunCarga;
    pageList1.Enabled   :=m_Ctrl.Model.State <> msInactive;

    vst_GridMunCarga.Clear ;
    vst_GridCondutor.Clear ;
    vst_GridMunDescarga.Clear;

    {*
     * ler estado do model
     *}

    if m_Ctrl.Model.id > 0 then
    begin
        edt_mdfCod.Text :=IntToStr(m_Ctrl.Model.id) ;
        //
        // set style
        PanelStyler1.Style:=psOffice2013White ;
        //
        // carga grid
        loadGrid ;
        btn_MunCargaDel.Enabled :=vst_GridMunCarga.RootNodeCount > 0;

        //
        // carga modal
       edt_VeiCod.IntValue :=m_Ctrl.Model.modalRodo.veiculo.id ;
       edt_VeiCodClickBtn(edt_VeiCod) ;
    end
    else begin
        edt_mdfCod.Clear ;
        edt_VeiCod.formatReadOnly(False);
        html_Veiculo.HTMLText.Clear ;
        html_Veiculo.HTMLText.Add('<p>Digite um código e/ou selecione um <b>Veículo</b></p>') ;
    end;

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

end;

procedure Tfrm_ManifestoDF.KeyDown(var Key: Word; Shift: TShiftState);
begin
    case Key of
        VK_RETURN:
        if ActiveControl =edt_mdfCod then
            edt_mdfCodClickBtn(edt_mdfCod)
        else if ActiveControl =edt_VeiCod then
        begin
            if edt_VeiCod.ReadOnly then
                inherited
            else
                edt_VeiCodClickBtn(edt_VeiCod);
        end
        else
            inherited;

        VK_BACK:
        begin
            if ActiveControl = edt_mdfCod then
            begin
                edt_mdfCod.ReadOnly:=False;
                m_Ctrl.Inicialize;
                ModelChanged ;
            end
            else if ActiveControl = edt_VeiCod then
            begin
                edt_VeiCod.formatReadOnly(False);
                html_Veiculo.HTMLText.Clear ;
            end;
        end;
    else
        inherited;
    end;
end;

procedure Tfrm_ManifestoDF.loadGrid;
var
  P: PVirtualNode ;
  N: IManifestodf02nfe;
begin
    vst_GridMunCarga.RootNodeCount :=m_Ctrl.Model.munCarga.getDataList.Count ;
    vst_GridCondutor.RootNodeCount :=m_Ctrl.Model.modalRodo.condutores.getDataList.Count ;
    P :=vst_GridMunDescarga.AddChild(nil);
    for N in m_Ctrl.Model.munDescarga.nfeList.getDataList do
    begin
        vst_GridMunDescarga.AddChild(P) ;
    end;
    Include(P.States, vsExpanded) ;
end;

procedure Tfrm_ManifestoDF.ModelChanged;
begin
    //
    // inicializa a view com o state do model
    Inicialize ;
end;

procedure Tfrm_ManifestoDF.pageList1Changing(Sender: TObject;
  PageIndex: Integer; var AllowChange: Boolean);
begin
    if PageIndex <> 0 then
    begin
        if vst_GridMunCarga.RootNodeCount = 0 then
        begin
            AllowChange :=False ;
            CMsgDlg.Warning('Necessário incluir pelo um município de carga!');
        end;
    end;
end;

procedure Tfrm_ManifestoDF.vst_GridCondutorGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  C: ICondutor ;
begin
    if Assigned(Node) then
    begin
        C :=m_Ctrl.Model.modalRodo.condutores.getDataList.Items[Node.Index] ;
        case Column of
            0: CellText :=C.CPFCNPJ;
            1: CellText :=C.Nome;
        end;
    end;
end;

procedure Tfrm_ManifestoDF.vst_GridMunCargaGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  M: IManifestodf01mun ;
begin
    if Assigned(Node) then
    begin
        M :=m_Ctrl.Model.munCarga.getDataList.Items[Node.Index] ;
        case Column of
            0: CellText :=IntToStr(M.codigoMun);
            1: CellText :=M.nomeMun;
        end;
    end;
end;

procedure Tfrm_ManifestoDF.vst_GridMunDescargaGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  M: TCManifestodf01mun ;
  N: IManifestodf02nfe ;
begin
    if Assigned(Node) then
    begin
        case Sender.GetNodeLevel(Node) of

            0: // mun. descarga
            begin
                M :=m_Ctrl.Model.munDescarga.municipio ;
                case Column of
                    0: CellText :=Format('%d-%s',[M.codigoMun,M.nomeMun]) ;
                    1: CellText :='';
                    2: CellText :='';
                    3: CellText :='';
                end;
            end;

            1: // docs (NFE)
            begin
                //M :=m_Ctrl.Model.munDescarga.municipio ;
                N :=m_Ctrl.Model.munDescarga.nfeList.indexOf(Node.Index) ;
                if Assigned(N) then
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


end.
