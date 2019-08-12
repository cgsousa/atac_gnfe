{***
* View/Thread para exportar XML da NFe/NFCe
*
* Chamada:
* var
*   I: Ifrm_ExportXML ;
* begin
*   ...
*   I :=Tfrm_ExportXML.New ;
*   I.Execute(  num_ser, // numero do caixa
*               dat_ini, // data de abertura
*               dat_fin, // data de fechamento (0=data/hora do dia)
*               Clear,   // flag que indica se remove o XML da base de dados!
*             ) ;
*   ...
* end;
*
*
* Atac Sistemas
* Todos os direitos reservados
* Autor: Carlos Gonzaga
* Data: 03.07.2019
*}
unit Form.ExportXML;

{*
******************************************************************************
|* PROP�SITO: Registro de Altera��es
******************************************************************************

S�mbolo : Significado

[+]     : Novo recurso
[*]     : Recurso modificado/melhorado
[-]     : Corre��o de Bug (assim esperamos)

09.08.2019
[*] Processamento de todos os caixas na Thread <TCRunProc>

*}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,
  FormBase,
  //
  AdvPanel, AdvGlowButton, AdvOfficeStatusBar, uStatusBar, AdvEdit, AdvEdBtn,
  AdvDirectoryEdit, AdvGroupBox,
  //
  JvExStdCtrls, JvButton, JvCtrls, JvFooter, JvExtComponent, JvExExtCtrls,
  //
  uACBrNFE, unotfis00, uclass, RTFLabel, GradientLabel;

type
  TCRunProc = class(TCThreadProcess)
  private
    m_Lote: TCNotFis00Lote;
    m_Rep: IBaseACBrNFE ;
    m_Local: string ;
    m_Clear: Boolean ;
    m_totSucess, m_totError: Integer;
  protected
    procedure Execute; override;
    procedure RunProc; override;
  public
    constructor Create(aLote: TCNotFis00Lote; aRep: IBaseACBrNFE;
      const aLocal: string; const aClear: Boolean);
//    constructor Create(aFilter:
  end;


type
  Ifrm_ExportXML = Interface(IInterface)
    function Execute(const aNumSer: Word;
      const aDHAber, aDHFech: TDateTime;
      const aClear: Boolean =False): Boolean;
  end;

  Tfrm_ExportXML = class(TBaseForm, Ifrm_ExportXML)
    AdvOfficeStatusBar1: TAdvOfficeStatusBar;
    pnl_Footer: TJvFooter;
    btn_Close: TJvFooterBtn;
    btn_Start: TJvFooterBtn;
    btn_Stop: TJvFooterBtn;
    btn_ViewLOG: TJvFooterBtn;
    gbx_InfoCX: TAdvGroupBox;
    edt_Local: TAdvDirectoryEdit;
    pnl_ResultProcess: TAdvPanel;
    lbl_Info: TGradientLabel;
    procedure btn_StartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btn_CloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    m_NumSer: Word ;
    m_DHAber, m_DHFech: TDateTime ;
    m_ClearXML: Boolean ;
    m_Lote: TCNotFis00Lote;
    m_Rep: IBaseACBrNFE;
  private
    { Thread }
    m_Run:  TCRunProc;
    procedure DoStart ;
    procedure DoStop ;
    procedure OnINI(Sender: TObject);
    procedure OnFIN(Sender: TObject);
    procedure OnUpdate(const aStr: string) ;
  private
    { StatusBar }
    m_StatusBar: TCStatusBarWidget;
    m_panelNF: TAdvOfficeStatusPanel ;
    m_panelVTotal: TAdvOfficeStatusPanel ;
    m_panelProgress: TAdvOfficeStatusPanel ;
    procedure setStatusBar(const aPos: Int64 =0) ;
  public
    { Public declarations }
    class function New(): Ifrm_ExportXML;
    //
    // instance
    function Execute(const aNumSer: Word;
      const aDHAber, aDHFech: TDateTime;
      const aClear: Boolean =False): Boolean;
  end;


implementation

{$R *.dfm}

uses DB, DateUtils ,
  uadodb, uTaskDlg, ustr ,
  ACBrUtil, ACBrNFeNotasFiscais;


{ TCRunProc }

constructor TCRunProc.Create(aLote: TCNotFis00Lote; aRep: IBaseACBrNFE;
  const aLocal: string; const aClear: Boolean);
begin
    m_Lote :=aLote;
    m_Rep :=aRep ;
    m_Local :=aLocal;
    m_Clear :=aClear;
    inherited Create(True, False);
end;

procedure TCRunProc.Execute;
var
  F: TNotFis00Filter;
  C: TArrayCaixa ;
  I: Integer ;
begin
    //
    // inicio
    // sincroniza o method(Form.OnINI) da view como inicio de tarefa
    CallOnBeforeExecute;

    //
    // set root path
    if Pos('proc', m_Local) = 0 then
    begin
        m_Local :=PathWithDelim(m_Local) +'proc';
    end;

    //
    // chk se tem caixa para processar
    if m_Lote.Filter.nserie > 0 then
        RunProc
    //
    // processa todos no periodo
    else begin
        //
        // ler filtro p/ modificar
        F :=m_Lote.Filter ;
        C :=TCNotFis00Lote.CLoadCaixas ;
        for I :=Low(C) to High(C) do
        begin
            F.nserie :=C[I] ;
            CallOnStrProc(
              Format('Processando Caixa: %.3d   ',[F.nserie])+
              FormatDateTime('"Data/Hora Inicio: "DD/MM/YYYY hh:nn', F.codini)+
              FormatDateTime('"   Data/Hora Fim: "DD/MM/YYYY hh:nn', F.datfin)+
              ',    Aguarde...'
            );
            if m_Lote.Load(F) then
            begin
                RunProc ;
            end;
            //
            // chk se abortou pelo usu�rio
            if Self.Terminated then Break ;
        end;
    end;

    //
    // termina Thread
    Self.Terminate ;
end;

procedure TCRunProc.RunProc;
var
  NF: TCNotFis00;
  N: NotaFiscal ;
var
  P: Integer;
  dir,F: string ;
begin
    //
    // inicializa totalizadores
    m_totSucess:=0;
    m_totError :=0;

    for NF in m_Lote.Items do
    begin
        //
        // calc. o pos e sincroniza com a view
        P :=CalcPerc(NF.ItemIndex+1, m_Lote.Items.Count) ;
        CallOnIntProc(P);
        //
        // chk notas processadas e/ou canceladas
        if NF.CStatProcess or NF.CstatCancel then
        begin
            if NF.m_chvnfe <> '' then
            begin
//                CallOnStrProc('Carregando NFe[%s]',[NF.m_chvnfe]);
                if NF.LoadXML() then
                begin
                    N :=m_Rep.AddNotaFiscal(nil, True) ;
                    if N.LerXML(NF.m_xml) then
                    begin
                        N.NFe.procNFe.tpAmb   :=NF.m_tipamb ;
                        N.NFe.procNFe.verAplic:=NF.m_verapp ;
                        N.NFe.procNFe.chNFe   :=NF.m_chvnfe ;
                        N.NFe.procNFe.dhRecbto:=NF.m_dhreceb;
                        N.NFe.procNFe.nProt   :=NF.m_numprot;
                        N.NFe.procNFe.digVal  :=NF.m_digval ;
                        N.NFe.procNFe.cStat   :=NF.m_codstt ;
                        N.NFe.procNFe.xMotivo :=NF.m_motivo ;
//                        CallOnStrProc('Exportando NFe:%s'#13#10'Aguarde...',[NF.m_chvnfe]);
                        N.GerarXML ;

                        //
                        // format filename
                        F :=Format('%s-procNFe.XML',[NF.m_chvnfe]);
                        //
                        // format local com dados do emit
                        if Pos(NF.m_emit.CNPJCPF, m_Local) =0 then
                        begin
                            dir :=m_Rep.FormatPath(m_Local,'',
                                                  NF.m_emit.CNPJCPF,
                                                  NF.m_dtemis);
                        end;

                        //
                        // salva
                        if N.GravarXML(F, dir) then
                        begin
                            //
                            // remove XML do BD para liberar espa�os!
                            if m_Clear then
                            begin
                                NF.m_tag :=1;
                                NF.m_xml :='' ;
                                NF.setXML ;
                            end;
                        end
                        else
                            Inc(m_totError) ;
                    end;
                    Inc(m_totSucess) ;
                end
                else begin
//                    CallOnStrProc('XML n�o encontrado!: NFe[%s]',[NF.m_chvnfe]);
                    Inc(m_totError) ;
                end;
            end
            else begin
//                CallOnStrProc('NFe[Mod:%d,S�rie:%.3d,N�mero:%d]'#13#10'Error',[
//                                NF.m_codmod,NF.m_nserie,NF.m_numdoc]);
                Inc(m_totError) ;
            end;
        end;
        //
        // chk se abortou pelo usu�rio
        if Self.Terminated then Break ;
    end;
end;

{ Tfrm_ExportXML }

procedure Tfrm_ExportXML.btn_CloseClick(Sender: TObject);
begin
    Self.Close ;

end;

procedure Tfrm_ExportXML.btn_StartClick(Sender: TObject);
var
  F: TNotFis00Filter ;
  U: UtilStr ;
  Y,M,D,H,N,S,MS: Word ;
begin
    //
    //
    //cria dir
    if not DirectoryExists(edt_Local.Text) then
        ForceDirectories(edt_Local.Text);

    if not edt_Local.IsValidDirectory then
    begin
        CMsgDlg.Info('Pasta n�o � v�lida!') ;
        edt_Local.SetFocus;
        Exit;
    end;

    //
    // inicializa filtro
    F.Create(0, 0);
    F.filTyp :=ftFech;

    //
    // truc dat.ini at� o min.
    DecodeDateTime(m_DHAber, Y, M, D, H, N, S, MS);
    F.datini :=EncodeDateTime(Y, M, D, H, N, 0, 0);

    //
    // truc dat.fin at� o min.
    //DecodeDateTime(m_DHFech, Y, M, D, H, N, S, MS);
    //F.datfin :=EncodeDateTime(Y, M, D, H, N, 0, 0);
    F.datfin :=m_DHFech ;

    F.status :=sttNone ;
    F.codmod :=00;
    F.nserie :=m_NumSer;
    F.save :=FindCmdLineSwitch('sql', ['-', '\', '/'], true) ;

    //
    // todos os caixas
    if(F.nserie =0)then
    begin
        m_Lote.Filter :=F;
        //
        // inicia tarefa
        DoStart ;
    end
    else begin
          //
         // load notas fiscais do caixa
         if m_Lote.Load(F) then
         begin
              //
              // inicia tarefa
              DoStart ;
         end
         else
            if not m_ClearXML then
                CMsgDlg.Warning(
                Format(
                'Nenhuma NF encontrada para o CX[No:%.2d, DH.Aber:%s DH.Fech:%s]',
                [m_NumSer,U.fDtTm(m_DHAber),U.fDtTm(m_DHFech)])) ;
    end;
end;

procedure Tfrm_ExportXML.DoStart;
begin
    //
    // stop tarefa caso ativada!
    if Assigned(m_Run) then
    begin
        DoStop;
    end ;
    //
    // cria uma nova tarefa
    m_Run :=TCRunProc.Create(m_Lote, m_Rep, edt_Local.Text, m_ClearXML);
    m_Run.OnBeforeExecute :=OnINI;
    m_Run.OnTerminate :=OnFIN;
    m_Run.OnIntProc :=setStatusBar;
    m_Run.OnStrProc :=OnUpdate;
    //
    // come�a a tarefa
    m_Run.Start  ;
end;

procedure Tfrm_ExportXML.DoStop;
begin
    m_Run.Terminate;
    m_Run.WaitFor;
    FreeAndNil(m_Run);
end;

function Tfrm_ExportXML.Execute(const aNumSer: Word; const aDHAber,
  aDHFech: TDateTime; const aClear: Boolean): Boolean;
begin
    m_NumSer :=aNumSer ;
    m_DHAber :=aDHAber ;
    if YearOf(aDHFech) < 2006 then
        m_DHFech :=TADOQuery.getDateTime
    else
        m_DHFech :=aDHFech;
    m_ClearXML :=aClear ;
    Result :=ShowModal =mrOk ;
end;

procedure Tfrm_ExportXML.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    if Assigned(m_Run) then
    begin
        if m_Run.Terminated then
            DoStop
        else begin
            CMsgDlg.Warning('A Tarefa esta em execu��o!');
            CanClose :=False ;
        end;
    end;
end;

procedure Tfrm_ExportXML.FormCreate(Sender: TObject);
begin
    m_Lote:=TCNotFis00Lote.Create;
    m_Rep :=TCBaseACBrNFE.New(False);
    //
    //
    edt_Local.Text :=PathWithDelim(m_Rep.param.arq_SaveXML_RootPath.Value) +'proc';

    //
    // status bar
    m_StatusBar :=TCStatusBarWidget.Create(AdvOfficeStatusBar1, False);
    m_panelNF:=m_StatusBar.AddPanel(psHTML, '', 80, taCenter) ;
    m_panelVTotal:=m_StatusBar.AddPanel(psHTML, '', 140, taRightJustify) ;
    m_panelProgress:=m_StatusBar.AddPanel(psProgress, '', 250) ;

end;

procedure Tfrm_ExportXML.FormDestroy(Sender: TObject);
begin
    m_Lote.Free ;
    m_StatusBar.Free;

end;

procedure Tfrm_ExportXML.FormShow(Sender: TObject);
begin
    //
    // trava o edt local
    if m_ClearXML then
    begin
        edt_Local.Enabled :=False ;
    end;

    lbl_Info.Caption :=Format('N�mero: %.3d   ',[Self.m_NumSer])+
      FormatDateTime('"Data/Hora Inicio: "DD/MM/YYYY hh:nn', Self.m_DHAber) +'   '+
      FormatDateTime('"Data/Hora Fim: "DD/MM/YYYY hh:nn', Self.m_DHFech) ;
    pnl_ResultProcess.Text :='';
    setStatusBar();
    //
    //
    if m_ClearXML then
    begin
        btn_Start.Click ;
    end ;
end;

class function Tfrm_ExportXML.New(): Ifrm_ExportXML;
begin
    Result :=Tfrm_ExportXML.Create(Application) ;

end;

procedure Tfrm_ExportXML.OnFIN(Sender: TObject);
var
  run: TCRunProc ;
begin
    run :=TCRunProc(Sender) ;
    //btn_Start.Enabled :=True ;
    btn_Stop.Enabled :=False ;
    btn_Close.Enabled :=True ;
    edt_Local.Enabled :=True ;

    //
    // format result
    pnl_ResultProcess.Text :=Format(
        '<p>Total: <font color="#004080"><b>%d</b></font></p>  '+
        '<p>Total com erros:<font color="#ff0000"><b>%d</b></font></p>',
        [run.m_totSucess,run.m_totError]);

    pnl_ResultProcess.StatusBar.Text :=Format('Destino: <b>%s</b>',[run.m_Local]);

    if not m_ClearXML then
        CMsgDlg.Info('Tarefa terminada');
end;

procedure Tfrm_ExportXML.OnINI(Sender: TObject);
begin
    btn_Start.Enabled :=False ;
    btn_Stop.Enabled :=True ;
    btn_Close.Enabled :=False ;
    edt_Local.Enabled :=False ;
    setStatusBar();
end;

procedure Tfrm_ExportXML.OnUpdate(const aStr: string);
begin
    lbl_Info.Caption :=aStr ;

end;

procedure Tfrm_ExportXML.setStatusBar(const aPos: Int64);
begin
    if aPos > 0 then
    begin
        m_panelProgress.Progress.Position :=aPos ;
    end
    else begin
        if m_Lote.Items.Count > 0 then
        begin
            m_panelNF.Text :=Format('NFs<b>%d</b>',[m_Lote.Items.Count]);
            m_panelVTotal.Text :=Format('Total:<b>%10.2m</b>',[m_Lote.vTotalNF]);
        end
        else begin
            m_panelNF.Text :='Nenhum';
            m_panelVTotal.Text :='';
            m_panelProgress.Progress.Position :=0;
        end;
    end;
end;

end.
