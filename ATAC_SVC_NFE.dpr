program ATAC_SVC_NFE;

uses
  SvcMgr,
  WinSvc,
  SysUtils,
  Windows,
  Forms,
  ActiveX,
  unotfis00 in 'model\unotfis00.pas',
  ucce in 'model\ucce.pas',
  Thread.NFE in 'model\Thread.NFE.pas',
  Svc.NFE in 'view\Svc.NFE.pas' {Svc_NFE: TService},
  Form.ViewSvc in 'view\Form.ViewSvc.pas' {frm_ViewSvc},
  FDM.NFE in 'view\FDM.NFE.pas' {dm_nfe: TDataModule},
  Form.NFEStatus in 'view\Form.NFEStatus.pas' {frm_NFEStatus},
  uACBrNFe in 'model\uACBrNFe.pas';

{$R *.RES}
{$R ATAC_SVC_NFE.UAC.RES}

const
  SERVICE_NAME = 'ATAC_SVC_NFE';


function IsServiceInstalled(const srv_name: string): Boolean;
const
  //
  // assume that the total number of
  // services is less than 4096.
  // increase if necessary
  cnMaxServices = 4096;

type
  TSvcA = array[0..cnMaxServices]
          of TEnumServiceStatus;
  PSvcA = ^TSvcA;

var
  //
  // temp. use
  j: Integer;

  //
  // service control
  // manager handle
  schm: SC_Handle;

  //
  // bytes needed for the
  // next buffer, if any
  nBytesNeeded,

  //
  // number of services
  nServices,

  //
  // pointer to the
  // next unread service entry
  nResumeHandle: DWord;

  //
  // service status array
  ssa : PSvcA;

begin
    Result :=False ;

    // connect to the service
    // control manager
    schm :=OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS);
    if schm > 0 then
    begin
        nResumeHandle :=0;

        New(ssa);

        EnumServicesStatus(
          schm,
          SERVICE_WIN32,
          SERVICE_STATE_ALL,
          ssa^[0],
          SizeOf(ssa^),
          nBytesNeeded,
          nServices,
          nResumeHandle );


        //
        // assume that our initial array
        // was large enough to hold all
        // entries. add code to enumerate
        // if necessary.
        //

        for j := 0 to nServices-1 do
        begin
            if StrPas(
              ssa^[j].lpServiceName ) =srv_name then
            begin
                Result :=True;
                Break ;
            end;
        end;

        Dispose(ssa);

        // close service control
        // manager handle
        CloseServiceHandle(schm);

    end;
end;



var
  MySvc: TMySvcThread;
  LAppForm: Tfrm_ViewSvc;

//procedure DoMain ;
//begin
//
//end;


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
      /uninstall -> desinstala o serviço
  }

  //
  // executa
  // como serviço

//  if IsServiceInstalled(SERVICE_NAME) and
  if(not(FindCmdLineSwitch('app', ['-', '\', '/'], true))) then
  begin
      if not SvcMgr.Application.DelayInitialize or SvcMgr.Application.Installing then
        SvcMgr.Application.Initialize;
      SvcMgr.Application.CreateForm(TSvc_NFE, Svc_NFE);
  SvcMgr.Application.Run;
  end

  //
  // executa
  // como app
  else begin
      Forms.Application.Initialize;
      Forms.Application.MainFormOnTaskbar :=False;
      Forms.Application.Title := 'Atac Serviço NFE';
      Forms.Application.CreateForm(Tfrm_ViewSvc, LAppForm);
      {MySvc :=TMySvcThread.Create ;
      try
          MySvc.Resume  ;
          repeat
              //
              //
              //
          until MySvc.getTerminated;

      finally
          MySvc.Terminate;
          MySvc.WaitFor;
          FreeAndNil(MySvc);
      end;
      }
      Forms.Application.Run ;
  end;

end.
