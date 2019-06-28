object svc_XML: Tsvc_XML
  OldCreateOrder = False
  DisplayName = 'svc_XML'
  Interactive = True
  BeforeInstall = ServiceBeforeInstall
  AfterInstall = ServiceAfterInstall
  OnShutdown = ServiceShutdown
  OnStart = ServiceStart
  OnStop = ServiceStop
  Height = 150
  Width = 215
end
