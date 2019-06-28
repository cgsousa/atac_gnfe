{***
* Form/View para mostrar as atividades da Thread exporta XML da NFe/NFCe
* Atac Sistemas
* Todos os direitos reservados
* Autor: Carlos Gonzaga
* Data: 14.06.2019
*}
unit Form.MainViewXML;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,
  FormBase,
  JvExExtCtrls, JvBevel, JvComponentBase, JvTrayIcon, JvAppInst,
  AdvPanel, AdvGlowButton,
  ulog, Thread.XML;

type
  Tfrm_MainView = class(TBaseForm)
    AdvPanel1: TAdvPanel;
    JvBevel1: TJvBevel;
    JvBevel2: TJvBevel;
    JvBevel3: TJvBevel;
    JvBevel6: TJvBevel;
    btn_Start: TAdvGlowButton;
    btn_Stop: TAdvGlowButton;
    btn_Config: TAdvGlowButton;
    btn_Log: TAdvGlowButton;
    btn_Close: TAdvGlowButton;
    AppInstances1: TJvAppInstances;
    TrayIcon1: TJvTrayIcon;
    procedure FormCreate(Sender: TObject);
    procedure btn_StartClick(Sender: TObject);
    procedure btn_StopClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    m_Log: TCLog;
    m_MySvc: TCSvcXML ;
    procedure doStart();
    procedure doStop();

    procedure OnINI(Sender: TObject);
    procedure OnFIN(Sender: TObject);
    procedure OnUpdateStr(const aStr: string);

  protected
    procedure Loaded; override;
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

uses uTaskDlg ;


{ Tfrm_MainView }

procedure Tfrm_MainView.btn_StartClick(Sender: TObject);
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
    //tm_MLog.Enabled :=true ;
end;

procedure Tfrm_MainView.btn_StopClick(Sender: TObject);
begin
    if Assigned(m_MySvc) then
    begin
        if(not m_MySvc.Terminated)and CMsgDlg.Warning('Deseja parar a tarefa?',True)then
        begin
            //
            // stop manual
            DoStop ;
        end;
    end ;
end;

procedure Tfrm_MainView.doStart;
begin
    //
    // inicia LOG
    m_Log :=TCLog.Create('', True) ;
    m_Log.AddSec('%s.doStart',[Self.ClassName]);

    m_MySvc :=TCSvcXML.Create(True) ;
    m_MySvc.OnBeforeExecute :=OnINI;
    m_MySvc.OnTerminate :=OnFIN;
    m_MySvc.OnStrProc :=OnUpdateStr;
    m_MySvc.Start  ;
end;

procedure Tfrm_MainView.doStop;
begin
    m_MySvc.Terminate;
    m_MySvc.WaitFor;
    FreeAndNil(m_MySvc);
end;

procedure Tfrm_MainView.FormCreate(Sender: TObject);
begin
    Caption :=Application.Title ;

end;

procedure Tfrm_MainView.FormShow(Sender: TObject);
begin
    doStart ;

end;

procedure Tfrm_MainView.Loaded;
begin
    inherited;
    AppInstances1.Active :=True;
    TrayIcon1.Active :=True;
    //tm_MLog.Enabled :=True;
end;

procedure Tfrm_MainView.OnFIN(Sender: TObject);
begin
    btn_Start.Enabled :=True;
    btn_Stop.Enabled  :=False;
    AdvPanel1.StatusBar.Text :='Tarefa Finalizada!' ;
end;

procedure Tfrm_MainView.OnINI(Sender: TObject);
begin
    //
    //
    btn_Start.Enabled :=False;
    btn_Stop.Enabled  :=True ;
    AdvPanel1.StatusBar.Text :='Tarefa Inicializada' ;
end;

procedure Tfrm_MainView.OnUpdateStr(const aStr: string);
begin
    //
    //
end;

end.
