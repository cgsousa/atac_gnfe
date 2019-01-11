unit Form.MunList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ExtCtrls, ActnList, Menus ,
  FormBase ,
  //JEDI
  JvExStdCtrls, JvExExtCtrls, JvExtComponent, JvCtrls,
  JvFooter, JvToolEdit, JvGroupBox, JvButton, JvAppInst,
  //TMS
  AdvPanel, AdvEdit, JvExMask, AdvGlowButton, AdvOfficeButtons, AdvGroupBox,
  AdvCombo, HTMLabel ,
  //
  VirtualTrees, uVSTree,
  //
  uManifestoDF
  ;

type
  Tfrm_MunList = class(TBaseForm)
    pnl_Footer: TJvFooter;
    btn_Close: TJvFooterBtn;
    vst_Grid1: TVirtualStringTree;
    btn_Filter: TJvFooterBtn;
    pnl_Filter: TAdvPanel;
    btn_Find: TJvImgBtn;
    gbx_CodMun: TAdvGroupBox;
    edt_CodMun: TAdvEdit;
    gbx_NomMun: TAdvGroupBox;
    cbx_UF: TAdvComboBox;
    edt_NomMun: TAdvEdit;
    btn_OK: TJvFooterBtn;
    procedure btn_FilterClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn_OKClick(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure btn_FindClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure vst_Grid1GetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vst_Grid1Checked(Sender: TBaseVirtualTree; Node: PVirtualNode);
  private
    { Private declarations }
    m_MunList: TCMunList ;
    procedure loadGrid ;
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;

  public
    { Public declarations }
    class function Execute(const aUF: string): TCMun ;
  end;


implementation

{$R *.dfm}

uses uTaskDlg;

{ Tfrm_MunList }

procedure Tfrm_MunList.btn_CloseClick(Sender: TObject);
begin
    ModalResult :=mrCancel ;

end;

procedure Tfrm_MunList.btn_FindClick(Sender: TObject);
var
  F: TMunFilter ;
begin
    F.codmun :=edt_CodMun.IntValue ;
    F.ufemun :=cbx_UF.Text ;
    F.nommun :=edt_NomMun.Text ;
    vst_Grid1.Clear ;
    if  m_MunList.load(F) then
    begin
        loadGrid ;
        ActiveControl :=vst_Grid1;
        btn_Filter.Click ;
    end  ;
end;

procedure Tfrm_MunList.btn_FilterClick(Sender: TObject);
begin
    pnl_Filter.Visible :=not pnl_Filter.Visible ;

end;

procedure Tfrm_MunList.btn_OKClick(Sender: TObject);
begin
    if vst_Grid1.GetFirstChecked()<>nil then
        ModalResult :=mrOk
    else begin
        CMsgDlg.Warning('Selecione um município!') ;
        ActiveControl :=vst_Grid1 ;
    end;
end;

class function Tfrm_MunList.Execute(const aUF: string): TCMun;
var
  F: Tfrm_MunList ;
begin
    Result :=nil ;
    //
    //
    F :=Tfrm_MunList.Create(Application) ;
    try
        F.vst_Grid1.Clear ;
        F.cbx_UF.ItemIndex :=F.cbx_UF.Items.IndexOf(aUF);
        if F.ShowModal =mrOk then
        begin
            Result :=F.m_MunList.Items[F.vst_Grid1.IndexItem] ;
        end;
    finally
        FreeAndNil(F) ;
    end;
end;

procedure Tfrm_MunList.FormCreate(Sender: TObject);
begin
    m_MunList :=TCMunList.Create ;
    m_MunList.loadUF(cbx_UF.Items);
    btn_OK.Enabled :=False ;
end;

procedure Tfrm_MunList.FormShow(Sender: TObject);
begin
    btn_Find.Click ;

end;

procedure Tfrm_MunList.KeyDown(var Key: Word; Shift: TShiftState);
begin
    if Key =VK_RETURN then
        btn_OK.Click
    else
        inherited;
end;

procedure Tfrm_MunList.loadGrid;
var
  P: PVirtualNode ;
  M: TCMun ;
begin
    vst_Grid1.Clear ;
    for M in m_MunList do
    begin
        P :=vst_Grid1.AddChild(nil) ;
        P.CheckType :=ctRadioButton ;
        P.CheckState :=csUncheckedNormal;
    end;
    vst_Grid1.IndexItem :=0;
    vst_Grid1.Refresh;
end;

procedure Tfrm_MunList.vst_Grid1Checked(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
    btn_OK.Enabled :=true ;

end;

procedure Tfrm_MunList.vst_Grid1GetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  M: TCMun ;
begin
    if Assigned(Node) then
    begin
        M :=m_MunList.Items[Node.Index] ;
        case Column of
            00: CellText :=IntToStr(M.m_codmun) ;
            01: CellText :=M.m_nommun ;
        end;
    end;
end;

end.
