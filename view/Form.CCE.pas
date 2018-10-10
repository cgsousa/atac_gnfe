unit Form.CCE;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  JvExStdCtrls, JvButton, JvCtrls, JvFooter, JvExExtCtrls, JvExtComponent,
  JvPageList, JvExControls,
  HTMLabel, AdvGroupBox,
  FormBase, unotfis00, JvMemo;

type
  Tfrm_CCE = class(TBaseForm)
    html_Prompt: THTMLabel;
    pnl_Footer: TJvFooter;
    btn_OK: TJvFooterBtn;
    btn_Close: TJvFooterBtn;
    txt_Correcao: TJvMemo;
    Label1: TLabel;
    procedure btn_CloseClick(Sender: TObject);
    procedure btn_OKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function fn_Show(var aCorrecao: string): Boolean ;
  end;


implementation

{$R *.dfm}

uses uTaskDlg;

{ Tfrm_CCE }

procedure Tfrm_CCE.btn_CloseClick(Sender: TObject);
begin
    ModalResult :=mrCancel
    ;
end;

procedure Tfrm_CCE.btn_OKClick(Sender: TObject);
begin
    if txt_Correcao.IsEmpty() then
    begin
        CMsgDlg.Warning('Deve-se informar uma correção de no mínimo 15 bytes!') ;
        txt_Correcao.SetFocus ;
        Exit ;
    end;
    ModalResult :=mrOk ;
end;

class function Tfrm_CCE.fn_Show(var aCorrecao: string): Boolean ;
var
  F: Tfrm_CCE ;
begin
    F :=Tfrm_CCE.Create(Application) ;
    try
        F.DoClear(F);
        F.ActiveControl :=F.txt_Correcao ;
        Result :=F.ShowModal =mrOk ;
        aCorrecao :=F.txt_Correcao.Text ;
    finally
        FreeAndNil(F) ;
    end;
end;

end.
