program ATAC_SVC_XML;

uses
  SvcMgr,
  SysUtils,
  Forms,
  uclass,
  Svc.XML in 'conteiners\Svc.XML.pas' {svc_XML: TService},
  Form.MainViewXML in 'view\Form.MainViewXML.pas' {frm_MainView},
  Thread.XML in 'model\Thread.XML.pas',
  unotfis00 in 'model\unotfis00.pas';

{$R *.RES}


var
  U: SvcUtil ;
  LAppForm: Tfrm_MainView;

begin
  // Windows 2003 Server requires StartServiceCtrlDispatcher to be
  // called before CoRegisterClassObject, which can be called indirectly
  // by Application.Initialize. TServiceApplication.DelayInitialize allows
  // Application.Initialize to be called from TService.Main (after
  // StartServiceCtrlDispatcher has been called).
  //
  // Delayed initialization of the Application object may affect
  // events which then occur prior to initialization, such as
  // TService.OnCreate. It is only recommended if the ServiceApplication
  // registers a class object with OLE and is intended for use with
  // Windows 2003 Server.
  //
  // Application.DelayInitialize := True;
  //

  { parametros
      /app  -> executa como aplicativo
      /install -> instala como serviço
      /uninstall -> desinstala o serviço }

  //
  // executa como serviço
  //
  if U.IsServiceInstalled(SERVICE_NAME) and
    (not(FindCmdLineSwitch('app', ['-', '\', '/'], true))) then
  begin
    if not SvcMgr.Application.DelayInitialize or SvcMgr.Application.Installing then
      SvcMgr.Application.Initialize;
  SvcMgr.Application.CreateForm(Tsvc_XML, svc_XML);
  SvcMgr.Application.Run;
  end
  //
  // executa como App
  //
  else begin
    Forms.Application.Initialize;
    Forms.Application.MainFormOnTaskbar :=False;
    Forms.Application.Title := 'Atac Serviço Exporta(XML)';
    Forms.Application.CreateForm(Tfrm_MainView, LAppForm);
    Forms.Application.Run ;
  end;
end.
