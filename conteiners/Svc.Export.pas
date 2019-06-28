unit Svc.Export;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs;

type
  Tsvc_XML = class(TService)
  private
    { Private declarations }
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  svc_XML: Tsvc_XML;

implementation

{$R *.DFM}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  svc_XML.Controller(CtrlCode);
end;

function Tsvc_XML.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

end.
