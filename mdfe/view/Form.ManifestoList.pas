unit Form.ManifestoList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Mask,

  AdvToolBar, AdvOfficeStatusBar, AdvOfficeButtons, AdvEdit,
  AdvGroupBox, AdvPanel, AdvGlowButton,

  JvExStdCtrls, JvButton, JvCtrls, JvExMask, JvToolEdit,

  FormBase, uStatusBar, VirtualTrees, uVSTree,
  uIntf, uManifestoCtr
  ;

type
  Tfrm_ManifestoList = class(TBaseForm, IView)
    AdvDockPanel1: TAdvDockPanel;
    AdvToolBar1: TAdvToolBar;
    AdvOfficeStatusBar1: TAdvOfficeStatusBar;
    vst_Grid1: TVirtualStringTree;
    pnl_Filter: TAdvPanel;
    gbx_DtEmis: TAdvGroupBox;
    Label1: TLabel;
    edt_DatIni: TJvDateEdit;
    edt_DatFin: TJvDateEdit;
    rgx_Status: TAdvOfficeRadioGroup;
    btn_Find: TJvImgBtn;
    gbx_Ident: TAdvGroupBox;
    edt_CodSeq: TAdvEdit;
    chk_ChvNFe: TAdvOfficeCheckBox;
    btn_Config: TAdvGlowButton;
    AdvToolBarSeparator1: TAdvToolBarSeparator;
    btn_Filter: TAdvGlowButton;
    AdvToolBarSeparator2: TAdvToolBarSeparator;
    btn_New: TAdvGlowButton;
    btn_Edit: TAdvGlowButton;
    procedure btn_FilterClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_FindClick(Sender: TObject);
    procedure vst_Grid1GetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure btn_NewClick(Sender: TObject);
    procedure vst_Grid1Change(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure btn_EditClick(Sender: TObject);
  private
    { Private declarations }
    m_Ctrl: IManifestoCtr;
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
  Form.Manifesto;



{$R *.dfm}

{ Tfrm_ManifestoList }

procedure Tfrm_ManifestoList.btn_EditClick(Sender: TObject);
var
  M: IManifestoDF;
  V: IView ;
begin
    M :=m_Ctrl.ModelList.Items[vst_Grid1.IndexItem] ;
    if(M <> nil)and(M.id > 0) then
    begin
        V :=Tfrm_Manifesto.Create(m_Ctrl);
        m_Ctrl.Model :=M ;
        m_Ctrl.Model.OnModelChanged :=(V as Tfrm_Manifesto).ModelChanged ;
        //m_Ctrl.Inicialize ;
        V.Execute ;
    end;
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
    if m_Ctrl.cmdFind(F) then
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
  V: IView ;
begin
    V :=Tfrm_Manifesto.Create(m_Ctrl);
    m_Ctrl.Model.OnModelChanged :=(V as Tfrm_Manifesto).ModelChanged ;
    m_Ctrl.Inicialize ;
    V.Execute ;
    //.
end;

procedure Tfrm_ManifestoList.Execute;
begin

end;

procedure Tfrm_ManifestoList.FormShow(Sender: TObject);
begin
    Self.Inicialize ;

end;

procedure Tfrm_ManifestoList.Inicialize;
var
  Model: IManifestoDF;
begin
    Model :=TCManifestoDF.Create;
    m_Ctrl :=TCManifestoCtr.Create ;
    m_Ctrl.Model :=Model ;
    m_Ctrl.View :=Self;
    m_Ctrl.Inicialize ;
    //
    btn_Edit.Enabled :=False ;
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

procedure Tfrm_ManifestoList.vst_Grid1Change(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
    if Assigned(Node) then
    begin
        btn_Edit.Enabled :=True ;
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
