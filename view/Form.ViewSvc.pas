{***
* UI do Serviço para gerenciar a NF-e
* Atac Sistemas
* Todos os direitos reservados
* Autor: Carlos Gonzaga
* Data: 26.03.2018
*}
unit Form.ViewSvc;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  AdvGlowButton,
  JvComponentBase, JvTrayIcon, ExtCtrls, JvAppInst,
  FormBase ,
  Thread.NFE ;

type
  //TUpdateStatus = (usStarting,)
  Tfrm_ViewSvc = class(TBaseForm)
    btn_Start: TAdvGlowButton;
    btn_Stop: TAdvGlowButton;
    btn_Close: TAdvGlowButton;
    TrayIcon1: TJvTrayIcon;
    Timer1: TTimer;
    AppInstances1: TJvAppInstances;
    pnl_Status: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure btn_StartClick(Sender: TObject);
    procedure btn_StopClick(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    m_MySvc: TMySvcThread;
    procedure m_Start();
    procedure m_Stop();

    //SvcStop: Boolean ;
    procedure UpdateStatus(const AStr: string);
    procedure OnINI(Sender: TObject);
    procedure OnEND(Sender: TObject);
    procedure OnLOG(Sender: TObject; const StrLog: string);
  protected
    procedure Loaded; override;

  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

uses DateUtils,
  uTaskDlg, ulog ;


{ Tfrm_Princ01 }

procedure Tfrm_ViewSvc.btn_CloseClick(Sender: TObject);
begin
    TrayIcon1.HideApplication ;

end;

procedure Tfrm_ViewSvc.btn_StartClick(Sender: TObject);
begin
    //
    if not Assigned(m_MySvc) then
    begin
        {m_MySvc :=TMySvcThread.Create ;
        m_MySvc.Resume  ;
        btn_Start.Enabled :=False;
        btn_Stop.Enabled  :=True ;
        UpdateStatus('Serviço em Operação', '008000');}

        //
        // start manual
        m_Start() ;

        //
        // ativa temporizador, p/ chk recursos aberto
        Timer1.Enabled :=true ;
    end
    else
        CMsgDlg.Warning('A Thread já esta criada!') ;
end;

procedure Tfrm_ViewSvc.btn_StopClick(Sender: TObject);
begin
    if Assigned(m_MySvc) then
    begin
        {UpdateStatus('Parando Serviço, Aguarde...', 'FF0000');
        try
            m_MySvc.Terminate;
            m_MySvc.WaitFor;
            FreeAndNil(m_MySvc);
        finally
            btn_Start.Enabled :=True ;
            btn_Stop.Enabled  :=False;
            UpdateStatus('Serviço Parado!', 'FF0000');
        end;}

        //
        // stop manual
        m_Stop() ;

        //
        // conf. tempo para 4s
        Timer1.Enabled :=False;
        Timer1.Interval:=4000 ; //(6 *SecsPerHour) *MSecsPerSec ;
    end
    else
        CMsgDlg.Warning('A Thread não criada!') ;
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
    Timer1.Enabled :=True;
end;

procedure Tfrm_ViewSvc.m_Start;
begin
    m_MySvc :=TMySvcThread.Create ;
    m_MySvc.OnIniProc :=OnINI;
    m_MySvc.OnEndProc :=OnEND;
    //m_MySvc.Resume  ;
    m_MySvc.Start  ;
end;

procedure Tfrm_ViewSvc.m_Stop;
begin
    m_MySvc.Terminate;
    m_MySvc.WaitFor;
    FreeAndNil(m_MySvc);
end;

procedure Tfrm_ViewSvc.OnEND(Sender: TObject);
begin
    btn_Start.Enabled :=True ;
    btn_Stop.Enabled  :=False;
    pnl_Status.Caption :='Serviço Parado!';
    pnl_Status.Font.Color :=clRed ;
end;

procedure Tfrm_ViewSvc.OnINI(Sender: TObject);
begin
    btn_Start.Enabled :=False;
    btn_Stop.Enabled  :=True ;
    pnl_Status.Caption :='Serviço em Operação';
    pnl_Status.Font.Color :=clGreen ;
end;

procedure Tfrm_ViewSvc.OnLOG(Sender: TObject; const StrLog: string);
begin

end;

procedure Tfrm_ViewSvc.Timer1Timer(Sender: TObject);
var
  H, M, S, MS: Word ;
begin
    // Timer1.Enabled :=False ;
    DecodeTime(Now, H, M, S, MS);
    if Assigned(m_MySvc) then
    begin
        //
        // se execute a mais de 24h
        if HoursBetween(Now, m_MySvc.Log.dhCreate) >= 12 then
        begin
            //
            // stop auto, para fechar recursos
            m_Stop() ;
        end;
    end
    //
    //
    else begin
        //
        // start auto, apos 24h (00:00 da manhã)
        m_Start();
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
