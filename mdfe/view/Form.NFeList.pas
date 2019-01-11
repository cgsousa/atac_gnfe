unit Form.NFeList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ExtCtrls,
  FormBase,
  //JEDI
  JvExStdCtrls, JvExExtCtrls, JvExtComponent, JvCtrls,
  JvFooter, JvToolEdit, JvGroupBox, JvButton, JvAppInst,
  //TMS
  AdvPanel, AdvEdit, JvExMask, AdvGlowButton, AdvOfficeButtons, AdvGroupBox,
  AdvCombo, HTMLabel, AdvToolBar ,
  //
  VirtualTrees, uVSTree,
  //
  unotfis00;


type
  Tfrm_NFEList = class(TBaseForm)
    pnl_Footer: TJvFooter;
    btn_Close: TJvFooterBtn;
    vst_Grid1: TVirtualStringTree;
    pnl_Filter: TAdvPanel;
    gbx_DtEmis: TAdvGroupBox;
    Label1: TLabel;
    edt_DatIni: TJvDateEdit;
    edt_DatFin: TJvDateEdit;
    btn_Find: TJvImgBtn;
    gbx_CodPed: TAdvGroupBox;
    edt_PedIni: TAdvEdit;
    edt_PedFin: TAdvEdit;
    gbx_ModSer: TAdvGroupBox;
    cbx_Modelo: TAdvComboBox;
    edt_NSerie: TAdvEdit;
    AdvGroupBox1: TAdvGroupBox;
    edt_Chave: TMaskEdit;
    btn_Filter: TJvFooterBtn;
    btn_OK: TJvFooterBtn;
    procedure btn_FilterClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn_FindClick(Sender: TObject);
    procedure vst_Grid1GetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure btn_OKClick(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
  private
    { Private declarations }
    m_lote: TCNotFis00Lote ;
    procedure LoadGrid() ;
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  public
    { Public declarations }
    class function Execute(aLote: TCNotFis00Lote): Boolean ;
  end;


implementation

{$R *.dfm}

uses StrUtils,
  uTaskDlg,
  ACBrUtil, ACBrDFeUtil ;


{ Tfrm_NFEList }

procedure Tfrm_NFEList.btn_CloseClick(Sender: TObject);
begin
    Self.Close ;

end;

procedure Tfrm_NFEList.btn_FilterClick(Sender: TObject);
begin
    pnl_Filter.Visible :=not pnl_Filter.Visible ;
end;

procedure Tfrm_NFEList.btn_FindClick(Sender: TObject);
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

            case cbx_Modelo.ItemIndex of
                0: F.codmod :=55 ;
                1: F.codmod :=65 ;
            else
                F.codmod :=0;
                F.nserie :=0;
            end;

            if F.codmod > 0 then
            begin
                F.nserie :=edt_NSerie.IntValue ;
            end;

        end;

    end;

    F.status :=sttProcess ;

    vst_Grid1.Clear ;
    setStatus('Carregando'#13#10'Aguarde...', crSQLWait);
    try
      m_lote.Load(F) ;
    finally
      setStatus('');
    end;

    if m_lote.Items.Count > 0 then
    begin
        LoadGrid() ;
        btn_Filter.Click ;
        ActiveControl :=vst_Grid1 ;
        btn_Ok.Enabled :=True ;
    end
    else begin
        btn_Ok.Enabled :=False ;
        CMsgDlg.Info('Nenhuma nota encontrada neste filtro!') ;
        edt_DatIni.SetFocus ;
    end;

end;

procedure Tfrm_NFEList.btn_OKClick(Sender: TObject);
begin
    ModalResult :=mrOk ;

end;

class function Tfrm_NFEList.Execute(aLote: TCNotFis00Lote): Boolean;
var
  F: Tfrm_NFEList ;
begin
    F :=Tfrm_NFEList.Create(Application) ;
    try
        F.vst_Grid1.Clear;
        F.m_lote :=aLote ;
        Result :=F.ShowModal =mrOk ;
    finally
        FreeAndNil(F) ;
    end;
end;

procedure Tfrm_NFEList.FormCreate(Sender: TObject);
begin
    edt_Chave.DoFormatEditMask(femCustom, 'Chave incorreta!',
    '0000\ 0000\ 0000\ 0000\ 0000\ 0000\ 0000\ 0000\ 0000\ 0000\ 0000;0; ');
    edt_PedIni.Clear;
    edt_PedFin.Clear;
    edt_DatIni.Date :=Date;
    edt_DatFin.Date :=edt_DatIni.Date;
    btn_OK.Enabled :=False ;
end;

procedure Tfrm_NFEList.KeyDown(var Key: Word; Shift: TShiftState);
begin
    if Key = VK_RETURN then
    begin
        if btn_Ok.Enabled then btn_Ok.Click ;
    end;
    inherited;
end;

procedure Tfrm_NFEList.LoadGrid;
var
  N: TCNotFis00 ;
  P: PVirtualNode ;
begin
    vst_Grid1.Clear ;
    for N in m_lote.Items do
    begin
        N.Checked :=True ;
        P :=vst_Grid1.AddChild(nil) ;
        P.CheckType :=ctCheckBox ;
        P.CheckState :=csCheckedNormal ;
    end;
    vst_Grid1.IndexItem :=0 ;
    vst_Grid1.Refresh ;
end;

procedure Tfrm_NFEList.vst_Grid1GetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  N: TCNotFis00 ;
begin
    CellText :='';
    N :=m_Lote.Items[Node.Index] ;
    case Column of
        0: CellText :=FormatarChaveAcesso(N.m_chvnfe);
        1: CellText :=Format('%.8d',[N.m_codped]) ;
        2: CellText :=IfThen(N.m_codmod=55,'NFe','NFCe') ;
        3: CellText :=Format('%.3d',[N.m_nserie]) ;
        4: CellText :=Format('%.8d',[N.m_numdoc]) ;
        5: CellText :=FormatDateTime('dd/MM/yyyy HH:NN', N.m_dtemis) ;
    end;
end;

end.
