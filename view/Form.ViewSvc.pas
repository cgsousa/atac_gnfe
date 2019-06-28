{***
* UI do Serviço para gerenciar a NF-e
* Atac Sistemas
* Todos os direitos reservados
* Autor: Carlos Gonzaga
* Data: 26.03.2018
*}
unit Form.ViewSvc;
{*
******************************************************************************
|* PROPÓSITO: Registro de Alterações
******************************************************************************

Símbolo : Significado

[+]     : Novo recurso
[*]     : Recurso modificado/melhorado
[-]     : Correção de Bug (assim esperamos)

23.05.2019
[*] Controle de LOG agora aqui

30.01.2019
[*] Removido o timer <tm_Alert>. O contrele da alerta agora esta na Thread.NFE,
    com o método CallOnCertif()

09.01.2019
[+] Novo timer <tm_Alert> que ativa o alerta conforme data de vencimento do
    certificado

04.12.2018
[+] Novo butão <chk_Conting> para ativar/desativar o parametro [conting_offline]

26.03.2018
[+] Versão inicial

*}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  FormBase ,
  JvComponentBase, JvTrayIcon, ExtCtrls, JvAppInst,
  AdvGlowButton, AdvOfficeButtons,
  ulog, Thread.NFE ;

type
  Tfrm_ViewSvc = class(TBaseForm)
    btn_Start: TAdvGlowButton;
    btn_Stop: TAdvGlowButton;
    btn_Close: TAdvGlowButton;
    TrayIcon1: TJvTrayIcon;
    tm_MLog: TTimer;
    AppInstances1: TJvAppInstances;
    pnl_Status: TPanel;
    chk_Conting: TAdvOfficeCheckBox;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure btn_StartClick(Sender: TObject);
    procedure btn_StopClick(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure tm_MLogTimer(Sender: TObject);
    procedure chk_ContingClick(Sender: TObject);
  private
    { Private declarations }
    m_Log: TCLog;
    m_MySvc: TMySvcThread;
    procedure doStart();
    procedure doStop();

    procedure UpdateStatus(const AStr: string);
    procedure OnINI(Sender: TObject);
    procedure OnEND(Sender: TObject);
    procedure OnAlert(const aCNPJ: string; const aDays: Word);
    procedure OnContingOffLine(const aFlag: Boolean) ;
    procedure OnUpdateStr(const aStr: string);

    procedure setConting(const aValue: Boolean) ;
  protected
    procedure Loaded; override;
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

uses DateUtils,
  uTaskDlg, uadodb, uACBrNFE, unotfis00,
  JvBaseDlg, JvDesktopAlert ;


{ Tfrm_Princ01 }

procedure Tfrm_ViewSvc.btn_CloseClick(Sender: TObject);
begin
    TrayIcon1.HideApplication ;

end;

procedure Tfrm_ViewSvc.btn_StartClick(Sender: TObject);
begin
    //
    if Assigned(m_MySvc) then
    begin
        doStop ;
    end ;
    //
    // start manual
    doStart ;
    //
    // ativa temporizador, p/ chk recursos aberto
    tm_MLog.Enabled :=true ;
end;

procedure Tfrm_ViewSvc.btn_StopClick(Sender: TObject);
begin
    if Assigned(m_MySvc) then
    begin
        if not m_MySvc.Terminated then
        begin
            //
            // stop manual
            UpdateStatus('Parando Serviço, Aguarde...');
            DoStop ;
        end;
        //
        // conf. tempo para 4s
        tm_MLog.Enabled :=False;
        tm_MLog.Interval:=4000 ; //(6 *SecsPerHour) *MSecsPerSec ;
    end ;
end;

procedure Tfrm_ViewSvc.chk_ContingClick(Sender: TObject);
var
  msg: string ;
  rep: IBaseACBrNFE;
  confirm: Boolean;
begin
    if ConnectionADO = nil then
        ConnectionADO :=NewADOConnFromIniFile(
            ExtractFilePath(ParamStr(0)) +'Configuracoes.ini'
            ) ;
    try
        ConnectionADO.Connected :=True ;
        try
        //
        // carga filial
        Empresa :=TCEmpresa.Instance ;
        Empresa.DoLoad(1);

        //
        // carga conteiner do ACBr
        rep :=TCBaseACBrNFE.New(False);

        if chk_Conting.Checked then
        begin
            msg:='';
            msg:='ATENÇÃO !!!'#13#10;
            msg:=msg +'Ativando a contigência Offline, as notas geradas ficam indisponível para consulta no site da SEFAZ!'#13#10;
            msg:=msg +'Portanto, as mesmas devem ser transmitidas seguinte a legislação!';
            confirm :=CMsgDlg.Warning(msg, True) ;
            if confirm then
            begin
                msg :='Deseja mesmo ativar a contingência offline?';
                confirm :=CMsgDlg.Confirm(msg);
            end;
            chk_Conting.Checked :=confirm;
        end
        else begin
            msg :='Deseja desativar a contingência offline?';
            confirm :=CMsgDlg.Confirm(msg) ;
            chk_Conting.Checked :=not confirm ;
        end;

        //
        //
        if confirm then
        begin
            rep.param.setContingOffLine(chk_Conting.Checked) ;
            setConting(chk_Conting.Checked);
        end;
        finally
          ConnectionADO.Connected :=False ;
        end;
    except
        on E:Exception do
        begin
            CMsgDlg.Error('Erro: %s',[E.Message]);
        end;
    end;
end;

procedure Tfrm_ViewSvc.doStart;
var
  F: TNotFis00Filter;
begin


    //
    // inicia LOG
    m_Log :=TCLog.Create('', True) ;
    m_Log.AddSec('%s.doStart',[Self.ClassName]);

    F.Create(0, 0);
    F.filTyp :=ftService ;
    F.codmod :=00;
    F.nserie :=00;

    m_MySvc :=TMySvcThread.Create(F) ;
    m_MySvc.OnBeforeExecute :=OnINI;
    m_MySvc.OnTerminate :=OnEND;
    m_MySvc.OnCertif :=OnAlert;
    m_MySvc.OnBooProc :=OnContingOffLine;
    m_MySvc.OnStrProc :=OnUpdateStr;
    m_MySvc.Start  ;
end;

procedure Tfrm_ViewSvc.doStop;
begin
    m_MySvc.Terminate;
    m_MySvc.WaitFor;
    FreeAndNil(m_MySvc);
end;

procedure Tfrm_ViewSvc.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    if Assigned(m_MySvc) then
    begin
        btn_StopClick(nil);
        CanClose :=True ;
    end;
end;

procedure Tfrm_ViewSvc.FormCreate(Sender: TObject);
begin
    Self.WindowState :=wsMinimized ;
    Self.Constraints.MaxHeight :=Self.Height ;
    Self.Constraints.MaxWidth :=Self.Width ;
    Self.Constraints.MinHeight :=Self.Height ;
    Self.Constraints.MinWidth :=Self.Width ;

    TCExeInfo.getInstance.GetVersionInfoOfApp(Application.ExeName);
    Self.Caption :=Format('%s(Ver.:%d.%d.%d%d)',[ Self.Caption,
                                                  TCExeInfo.getInstance.MajorVersion ,
                                                  TCExeInfo.getInstance.MinorVersion ,
                                                  TCExeInfo.getInstance.ReleaseNumber,
                                                  TCExeInfo.getInstance.BuildNumber
                                                 ]);
end;

procedure Tfrm_ViewSvc.Loaded;
begin
    inherited;
    AppInstances1.Active :=True;
    TrayIcon1.Active :=True;
    tm_MLog.Enabled :=True;
end;

procedure Tfrm_ViewSvc.OnAlert(const aCNPJ: string; const aDays: Word);
var
  msg: string;
  DA: TJvDesktopAlert ;
begin
    //
    //
//    if(m_IntervalAlert >= MSecsPerDay div HoursPerDay) then
//    begin
//        m_IntervalAlert :=0 ;
//    end
//    else begin
//        Inc(m_IntervalAlert) ;
//        Exit;
//    end;

    //
    // format msg padrão
    msg :=Format('Faltam %d (dias) para vercer o Certificado vinculado ao CNPJ:%s!',[aDays,aCNPJ]);

    //
    // certificado já venceu
    if aDays <= 0 then
        msg :=Format('O Certificado vinculado ao CNPJ:%s, já venceu! Providênciar outro do tipo A1 (preferencial).',[aCNPJ])
    //
    // certificado vence hj
    else if aDays = 1 then
        msg :=Format('Hoje vence o Certificado vinculado ao CNPJ:%s! E não será mais possível emissão de novas NFE.',[aCNPJ]);

    //
    //
    DA :=TJvDesktopAlert.Create(Self);
    DA.AutoFree :=True;
    DA.Font.Size:=12;
    DA.Colors.CaptionFrom :=clActiveCaption;
    DA.Colors.CaptionTo :=clInactiveCaption;
    DA.Colors.WindowFrom :=clInfoBk ;
    if aDays > 3 then
    begin
        DA.Colors.WindowTo :=clYellow ;
    end
    else begin
        DA.Colors.WindowTo :=clRed ;
    end;
//    DA.Images :=ImageList1;
    DA.Image :=Image1.Picture;
//    DA.OnMessageClick := DoMessageClick;
//    DA.OnShow := DoAlertShow;
//    DA.OnClose := DoAlertClose;
    DA.Options := []; //FOptions;
    DA.Location.AlwaysResetPosition := false;
    DA.Location.Position :=dapBottomRight; // TJvDesktopAlertPosition(cbLocation.ItemIndex);
    DA.Location.Width :=380 ;
    DA.Location.Height:=240;
    if DA.Location.Position = dapCustom then
    begin
      DA.Location.Left := Random(Screen.Width - 200);
      DA.Location.Top :=  Random(Screen.Height - 100);
    end;
    DA.AlertStyle :=asFade; // TJvAlertStyle(cmbStyle.ItemIndex);
    DA.StyleHandler.StartInterval :=25;
    DA.StyleHandler.StartSteps :=10;
    DA.StyleHandler.DisplayDuration  :=4000;
    DA.StyleHandler.EndInterval :=50;
    DA.StyleHandler.EndSteps :=10;
    {if chkClickable.Checked then
      Include(FOptions,daoCanClick);
    if chkMovable.Checked then
      Include(FOptions, daoCanMove);
    if chkClose.Checked then
      Include(FOptions, daoCanClose);
    DA.Options := FOptions;
    if chkShowDropDown.Checked then
      DA.DropDownMenu := PopupMenu1;
    for j := 0 to udButtons.Position-1 do
    begin
      with DA.Buttons.Add do
      begin
        ImageIndex := Random(ImageList1.Count);
        Tag := j;
        OnClick := DoButtonClick;
      end;
    end;}
    DA.HeaderText :='** Serviço de alerta da Atac Sistemas, informa **';
    DA.MessageText :=msg;
    DA.Execute;
end;

procedure Tfrm_ViewSvc.OnContingOffLine(const aFlag: Boolean);
begin
    Self.setConting(aFlag);

end;

procedure Tfrm_ViewSvc.OnEND(Sender: TObject);
begin
    btn_Start.Enabled :=True ;
    btn_Stop.Enabled  :=False;
    pnl_Status.Caption :='Serviço Parado!';
    pnl_Status.Font.Color :=clRed ;
    chk_Conting.Enabled :=True;
    m_Log.AddSec('%s.OnEND',[Self.ClassName]);
    m_Log.Free ;
end;

procedure Tfrm_ViewSvc.OnINI(Sender: TObject);
begin
    //
    //
    btn_Start.Enabled :=False;
    btn_Stop.Enabled  :=True ;
    pnl_Status.Caption :='Serviço em Operação';
    pnl_Status.Font.Color :=clGreen ;
    chk_Conting.Enabled :=False;
end;

procedure Tfrm_ViewSvc.OnUpdateStr(const aStr: string);
begin
    m_Log.AddSec(aStr) ;

end;

procedure Tfrm_ViewSvc.setConting(const aValue: Boolean);
begin
    if aValue then
    begin
        chk_Conting.Checked :=True ;
        chk_Conting.Caption :='Contingência Offline ativada!';
        chk_Conting.Font.Color :=clRed ;
    end
    else begin
        chk_Conting.Checked :=False ;
        chk_Conting.Caption :='Contingência Offline desativada!';
        chk_Conting.Font.Color :=clWindowText ;
    end;
end;

procedure Tfrm_ViewSvc.tm_MLogTimer(Sender: TObject);
var
  H, M, S, MS: Word ;
begin
    //tm_MLog.Enabled :=False ;
    DecodeTime(Now, H, M, S, MS);
    if Assigned(m_MySvc) then
    begin
        //
        // se execute a mais de 24h
        if HoursBetween(Now, m_Log.dhCreate) >= 12 then
        begin
            //
            // stop auto, para fechar recursos
            doStop() ;
        end;
    end
    //
    //
    else begin
        //
        // start auto, apos 24h (00:00 da manhã)
        doStart();
    end;
end;

procedure Tfrm_ViewSvc.UpdateStatus(const AStr: string);
//#FF0000-vermelho
//#008000-verde 3
begin

    pnl_Status.Caption :=AStr ;
    //if  then

    {
    htm_Status.HTMLText.Clear;
    htm_Status.HTMLText.Add(
    Format( '<P align="center"><FONT face="Verdana" color="#%s" size="12">%s</FONT></P>',
        [ACor,AStr])
    );
    }

    {
    TThread.Queue(nil,
                  procedure
                  begin
                      htm_Status.HTMLText.Clear;
                      htm_Status.HTMLText.Add(
                      Format( '<P align="center"><FONT face="Verdana" color="#%s" size="12">%s</FONT></P>',
                          [ACor,AStr])
                      );
                  end
    );
    }
end;

end.
