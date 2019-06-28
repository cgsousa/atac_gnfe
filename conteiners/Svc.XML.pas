unit Svc.XML;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs,
  ulog, Thread.XML;

type
  Tsvc_XML = class(TService)
    procedure ServiceBeforeInstall(Sender: TService);
    procedure ServiceAfterInstall(Sender: TService);
    procedure ServiceShutdown(Sender: TService);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
  private
    { Private declarations }
    m_Log: TCLog ;
    m_MySvc: TCSvcXML ;
    procedure ServiceStopShutdown;
    procedure OnAddLog(const aStr: string);
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  svc_XML: Tsvc_XML;

implementation

{$R *.DFM}

uses Registry;

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  svc_XML.Controller(CtrlCode);
end;

function Tsvc_XML.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure Tsvc_XML.OnAddLog(const aStr: string);
begin
    m_Log.AddSec(aStr);

end;

procedure Tsvc_XML.ServiceAfterInstall(Sender: TService);
var
  reg: TRegistry;
begin
    reg :=TRegistry.Create(KEY_READ or KEY_WRITE);
    try
        reg.RootKey :=HKEY_LOCAL_MACHINE;
        if reg.OpenKey('\SYSTEM\CurrentControlSet\Services\' + Self.Name, False) then
        begin
            reg.WriteString('Description', 'Atac Sistemas Serviço exporta XML da NFe/NFCe');
            reg.CloseKey;
        end;
    finally
        FreeAndNil(reg);
    end;
end;

procedure Tsvc_XML.ServiceBeforeInstall(Sender: TService);
begin
    Self.DisplayName :='Atac Serviço XML da NFe';

end;

procedure Tsvc_XML.ServiceShutdown(Sender: TService);
begin
    ServiceStopShutdown ;

end;

procedure Tsvc_XML.ServiceStart(Sender: TService; var Started: Boolean);
begin
    //
    // cria log
    m_Log :=TCLog.Create('', True) ;

    // Create an instance of the secondary thread where your service code is placed
    m_MySvc :=TCSvcXML.Create(True) ;
    m_MySvc.OnStrProc :=OnAddLog;
    m_MySvc.Start  ;
end;

procedure Tsvc_XML.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
    ServiceStopShutdown ;

end;

procedure Tsvc_XML.ServiceStopShutdown;
begin
    // Deallocate resources here
    if Assigned(m_MySvc) then
    begin
        //m_MySvcThread.Log.AddSec('%s.ServiceStopShutdown',[Self.ClassName]);
        // The TService must WaitFor the thread to finish (and free it)
        // otherwise the thread is simply killed when the TService ends.
        m_MySvc.Terminate;
        m_MySvc.WaitFor;
        FreeAndNil(m_MySvc);
    end;
    //
    // fecha log
    m_Log.Destroy ;
end;

end.
