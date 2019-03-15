{***
* View para registrar uma nova CCe
* Atac Sistemas
* Todos os direitos reservados
* Autor: Carlos Gonzaga
* Data: 11.01.2019
*}
unit Form.CCE;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  FormBase,
  JvExStdCtrls, JvButton, JvCtrls, JvFooter, JvExExtCtrls, JvExtComponent,
  JvPageList, JvExControls, JvMemo,
  HTMLabel, AdvGroupBox;

type
  IViewCCE = interface
    ['{0AE8DD71-3183-4757-9A4C-87438E1A8D4D}']
    function Execute(var aCorrecao: string): Boolean;
  end;

  Tfrm_CCE = class(TBaseForm, IViewCCE)
    html_Prompt: THTMLabel;
    pnl_Footer: TJvFooter;
    btn_OK: TJvFooterBtn;
    btn_Close: TJvFooterBtn;
    txt_Correcao: TJvMemo;
    Label1: TLabel;
    procedure btn_CloseClick(Sender: TObject);
    procedure btn_OKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function Execute(var aCorrecao: string): Boolean ;
    class function fn_Show(var aCorrecao: string): Boolean ;
    class function New(): IViewCCE ;
  end;


implementation

{$R *.dfm}

uses uTaskDlg ;

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

function Tfrm_CCE.Execute(var aCorrecao: string): Boolean;
begin
    Result :=Self.ShowModal =mrOk ;
    if Result then
    begin
        aCorrecao :=txt_Correcao.Text ;
    end;
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

procedure Tfrm_CCE.FormShow(Sender: TObject);
begin
    Self.DoClear(Self);
    Self.ActiveControl :=Self.txt_Correcao ;
end;

class function Tfrm_CCE.New(): IViewCCE;
begin
    Result :=Tfrm_CCE.Create(Application) ;

end;

end.
