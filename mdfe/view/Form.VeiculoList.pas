unit Form.VeiculoList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvExStdCtrls, JvButton, JvCtrls, JvFooter, ExtCtrls,
  JvExExtCtrls, JvExtComponent, VirtualTrees;

type
  Tfrm_VeiculoList = class(TForm)
    pnl_Footer: TJvFooter;
    btn_Close: TJvFooterBtn;
    btn_New: TJvFooterBtn;
    btn_OK: TJvFooterBtn;
    vst_Grid1: TVirtualStringTree;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function Execute(): Boolean ;
  end;


implementation

{$R *.dfm}

{ Tfrm_VeiculoList }

class function Tfrm_VeiculoList.Execute: Boolean;
begin

end;

procedure Tfrm_VeiculoList.FormCreate(Sender: TObject);
begin
    //

end;

end.
