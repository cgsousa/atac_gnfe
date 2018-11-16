unit Svc.NFE;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs,
  Thread.NFE;

type
  TSvc_NFE = class(TService)
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServiceBeforeInstall(Sender: TService);
    procedure ServiceAfterInstall(Sender: TService);
    procedure ServiceShutdown(Sender: TService);
  private
    { Private declarations }
    m_MySvcThread: TMySvcThread ;
    procedure ServiceStopShutdown;
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  Svc_NFE: TSvc_NFE;

implementation

{$R *.DFM}

uses Registry;

//var
//  LAppForm: Tfrm_Princ00;

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
    Svc_NFE.Controller(CtrlCode);
end;

function TSvc_NFE.GetServiceController: TServiceController;
begin
    Result := ServiceController;
end;

procedure TSvc_NFE.ServiceAfterInstall(Sender: TService);
var
  reg: TRegistry;
begin
    reg :=TRegistry.Create(KEY_READ or KEY_WRITE);
    try
        reg.RootKey :=HKEY_LOCAL_MACHINE;
        if reg.OpenKey('\SYSTEM\CurrentControlSet\Services\' + Self.Name, False) then
        begin
            reg.WriteString('Description', 'Atac Sistemas Serviço de gerenciamento da NF-e');
            reg.CloseKey;
        end;
    finally
        FreeAndNil(reg);
    end;
end;

procedure TSvc_NFE.ServiceBeforeInstall(Sender: TService);
begin
    Self.DisplayName :='Atac Sistemas Serviço da NF-e';

end;

procedure TSvc_NFE.ServiceShutdown(Sender: TService);
begin
    ServiceStopShutdown ;

end;

procedure TSvc_NFE.ServiceStart(Sender: TService; var Started: Boolean);
// Allocate resources here that you need when the service is running
begin
    // Create an instance of the secondary thread where your service code is placed
    m_MySvcThread :=TMySvcThread.Create ;
    m_MySvcThread.Log.AddSec('%s.ServiceStart',[Self.ClassName]);
    m_MySvcThread.SecBetweenRuns :=100;
    m_MySvcThread.Resume  ;
end;

procedure TSvc_NFE.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
    ServiceStopShutdown ;

end;

procedure TSvc_NFE.ServiceStopShutdown;
begin
    // Deallocate resources here
    if Assigned(m_MySvcThread) then
    begin
        m_MySvcThread.Log.AddSec('%s.ServiceStopShutdown',[Self.ClassName]);
        // The TService must WaitFor the thread to finish (and free it)
        // otherwise the thread is simply killed when the TService ends.
        m_MySvcThread.Terminate;
        m_MySvcThread.WaitFor;
        FreeAndNil(m_MySvcThread);
    end;
end;

end.
