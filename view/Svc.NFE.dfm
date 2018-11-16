object Svc_NFE: TSvc_NFE
  OldCreateOrder = False
  AllowPause = False
  DisplayName = 'ServiceNFE'
  Interactive = True
  BeforeInstall = ServiceBeforeInstall
  AfterInstall = ServiceAfterInstall
  OnShutdown = ServiceShutdown
  OnStart = ServiceStart
  OnStop = ServiceStop
  Height = 216
  Width = 426
end
