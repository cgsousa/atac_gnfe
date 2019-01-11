unit Form.ManifestoDFList;

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
  AdvCombo, HTMLabel, AdvToolBar ,
  //
  VirtualTrees, uVSTree,
  //
  uManifestoDF, ACBrBase, ACBrDFe, ACBrMDFe
  ;

type
  Tfrm_ManifestoDFList = class(TBaseForm)
    pnl_Footer: TJvFooter;
    btn_New: TJvFooterBtn;
    btn_Close: TJvFooterBtn;
    vst_Grid1: TVirtualStringTree;
    ActionList1: TActionList;
    btn_CadVei: TJvFooterBtn;
    act_New: TAction;
    act_CadVei: TAction;
    act_CadCdt: TAction;
    btn_CadCdt: TJvFooterBtn;
    ACBrMDFe1: TACBrMDFe;
    procedure act_NewExecute(Sender: TObject);
    procedure act_CadVeiExecute(Sender: TObject);
    procedure act_CadCdtExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    m_mdfList: TCManifestoDFList ;
  public
    { Public declarations }
    class procedure lp_Show();
  end;



implementation

{$R *.dfm}

uses uTaskDlg,
  Form.ManifestoDF;


{ Tfrm_ManifestoDFList }

procedure Tfrm_ManifestoDFList.act_CadCdtExecute(Sender: TObject);
begin
    //
end;

procedure Tfrm_ManifestoDFList.act_CadVeiExecute(Sender: TObject);
begin
    //
end;

procedure Tfrm_ManifestoDFList.act_NewExecute(Sender: TObject);
var
  M: TCManifestoDF ;
begin
    if CMsgDlg.Confirm('Deseja emitir um novo MDF-e?')then
    begin
        M :=m_mdfList.addNew(0) ;
        if Tfrm_ManifestoDF.Execute(M) then
        begin

        end;
    end;
end;

procedure Tfrm_ManifestoDFList.FormCreate(Sender: TObject);
begin
    m_mdfList :=TCManifestoDFList.Create ;

end;

class procedure Tfrm_ManifestoDFList.lp_Show;
var
  F: Tfrm_ManifestoDFList ;
begin
    F :=Tfrm_ManifestoDFList.Create(Application) ;
    try
        F.vst_Grid1.Clear ;
        F.ShowModal ;
    finally
        FreeAndNil(F) ;
    end;
end;

end.
