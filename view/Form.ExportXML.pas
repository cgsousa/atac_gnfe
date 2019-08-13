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
|* PROPÓSITO: Registro de Alterações
******************************************************************************

Símbolo : Significado

[+]     : Novo recurso
[*]     : Recurso modificado/melhorado
[-]     : Correção de Bug (assim esperamos)

09.08.2019
[*] Processamento de todos os caixas na Thread <TCRunProc>

*}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,
  FormBase,
  //
  AdvEdit, AdvEdBtn, AdvDirectoryEdit,
  //
  JvExStdCtrls, JvButton, JvCtrls, JvFooter, JvExtComponent, JvExExtCtrls,
  JvRichEdit,
  //
  uACBrNFE, unotfis00, uclass;

type
  TCRunProc = class(TCThreadProcess)
  private
    m_Lote: TCNotFis00Lote;
    m_Rep: IBaseACBrNFE ;
    m_Local: string ;
    m_Clear: Boolean ;
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
    pnl_Footer: TJvFooter;
    btn_Close: TJvFooterBtn;
    btn_Start: TJvFooterBtn;
    btn_Stop: TJvFooterBtn;
    btn_ViewLOG: TJvFooterBtn;
    edt_Local: TAdvDirectoryEdit;
    txt_LOG: TJvRichEdit;
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
    procedure OnLOG(const aStr: string) ;

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
    // ler filtro p/ modificar
    F :=m_Lote.Filter ;

    //
    // se informou unico caixa
    if F.nserie > 0 then
        RunProc
    //
    // processa todos no periodo
    else begin
        C :=TCNotFis00Lote.CLoadCaixas ;
        for I :=Low(C) to High(C) do
        begin
            F.nserie :=C[I] ;

            CallOnStrProc(Format('Caixa Número: %.3d   ',[F.nserie]));
            CallOnStrProc(#9+FormatDateTime('"Data/Hora Inicio: "DD/MM/YYYY hh:nn', F.datini));
            CallOnStrProc(#9+FormatDateTime('"Data/Hora Fim: "DD/MM/YYYY hh:nn', F.datfin));

            if m_Lote.Load(F) then
            begin
                RunProc ;
            end;
            //
            // chk se abortou pelo usuário
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
  tot_suc, tot_err: Integer;
  dir,F: string ;
begin

    //
    // inicializa totalizadores
    tot_suc:=0;
    tot_err:=0;

    for NF in m_Lote.Items do
    begin
        //
        // chk notas processadas e/ou canceladas
        if NF.CStatProcess or NF.CstatCancel then
        begin
            if NF.m_chvnfe <> '' then
            begin
                //
                // carga XML
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
                            CallOnStrProc(Format(#9'Gravando em %s',[dir]));
                            CallOnStrProc(#9'Aguarde...');
                        end;

                        //
                        // salva
                        if N.GravarXML(F, dir) then
                        begin
                            //
                            // remove XML do BD para liberar espaços!
                            if m_Clear then
                            begin
                                NF.m_tag :=1;
                                NF.m_xml :='' ;
                                NF.setXML ;
                            end;
                            Inc(tot_suc) ;
                        end
                        else begin
                            CallOnStrProc(#9'Erro|Ao gravar XML');
                            Inc(tot_err) ;
                        end;
                    end;
                end
                else begin
                    CallOnStrProc(Format(#9'Erro|XML não encontrado![Pedido de Venda:%d]',[NF.m_codped]));
                    Inc(tot_err) ;
                end;
            end
            else begin
                CallOnStrProc(Format(#9'Erro|Chave não encontrada![Pedido de Venda:%d]',[NF.m_codped]));
                Inc(tot_err) ;
            end;
        end;

        //
        // chk se abortou pelo usuário
        if Self.Terminated then Break ;
    end;
    //
    // format totalizadores
    CallOnStrProc(Format(#9'Total: %d',[tot_suc]));
    CallOnStrProc(Format(#9'Total com erros: %d',[tot_err]));
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
        CMsgDlg.Info('Pasta não é válida!') ;
        edt_Local.SetFocus;
        Exit;
    end;

    //
    // inicializa filtro
    F.Create(0, 0);
    F.filTyp :=ftFech;

    //
    // truc dat.ini até o min.
    DecodeDateTime(m_DHAber, Y, M, D, H, N, S, MS);
    F.datini :=EncodeDateTime(Y, M, D, H, N, 0, 0);

    //
    // truc dat.fin até o min.
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
        txt_LOG.Clear;

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
              OnLOG(Format(#9'Total de Notas Fiscais: %d',[m_Lote.Items.Count]));
              //
              // inicia tarefa
              DoStart ;
         end
         else
            OnLOG(#9'Erro: Nenhuma NF encontrada!') ;
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
    m_Run.OnStrProc :=OnLOG;
    //
    // começa a tarefa
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
            CMsgDlg.Warning('A Tarefa esta em execução!');
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
end;

procedure Tfrm_ExportXML.FormDestroy(Sender: TObject);
begin
    m_Lote.Free ;

end;

procedure Tfrm_ExportXML.FormShow(Sender: TObject);
begin
    //
    // reg. no LOG
    txt_LOG.Clear ;
    if Self.m_NumSer > 0 then
    begin
        OnLOG(Format('Caixa Número: %.3d',[Self.m_NumSer]));
        OnLOG(#9+FormatDateTime('"Data/Hora Inicio: "DD/MM/YYYY hh:nn', Self.m_DHAber));
        OnLOG(#9+FormatDateTime('"Data/Hora Fim: "DD/MM/YYYY hh:nn', Self.m_DHFech)) ;
    end;
    //
    //
    if m_ClearXML then
    begin
        edt_Local.Enabled :=False ;
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

    if m_ClearXML then
        ModalResult :=mrOk
    else
        CMsgDlg.Info('Tarefa terminada');
end;

procedure Tfrm_ExportXML.OnINI(Sender: TObject);
begin
    btn_Start.Enabled :=False ;
    btn_Stop.Enabled :=True ;
    btn_Close.Enabled :=False ;
    edt_Local.Enabled :=False ;
end;

procedure Tfrm_ExportXML.OnLOG(const aStr: string);
begin
    if Pos('Erro', aStr) > 0 then
    begin
        txt_Log.AddFormatText(aStr, [fsItalic], '', clRed) ;
        txt_Log.AddFormatText(#13#10) ;
    end
    else
        txt_Log.Lines.Add(aStr);
    txt_Log.SelLength := 0;
    txt_Log.SelStart:=txt_Log.GetTextLen;
    txt_Log.Perform( EM_SCROLLCARET, 0, 0 );
    ActiveControl :=txt_LOG ;
end;

procedure Tfrm_ExportXML.OnUpdate(const aStr: string);
begin
    //lbl_Info.Caption :=aStr ;

end;

end.
