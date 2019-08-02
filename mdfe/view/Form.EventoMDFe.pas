unit Form.EventoMDFe;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Mask,

  AdvToolBar, AdvOfficeStatusBar, AdvOfficeButtons, AdvEdit,
  AdvGroupBox, AdvPanel, AdvGlowButton,

  JvExStdCtrls, JvButton, JvCtrls, JvExMask, JvToolEdit,

  FormBase, uStatusBar, VirtualTrees, uVSTree,
  JvFooter, JvExExtCtrls, JvExtComponent, Menus, AdvMenus,
  ActnList,

  uIntf, uACBrMDFe, uManifestoDF
  ;


type
  //Tfrm_EventoMDFe = class;
//  Ifrm_EventoMDFe = Interface(IInterface)
//    procedure Execute() ;
//  end;

  Tfrm_EventoMDFe = class(TBaseForm, IView)
    AdvGroupBox1: TAdvGroupBox;
    AdvOfficeStatusBar1: TAdvOfficeStatusBar;
    pnl_Footer: TJvFooter;
    btn_Cancela: TJvFooterBtn;
    btn_Close: TJvFooterBtn;
    btn_Inclui: TJvFooterBtn;
    btn_Encerra: TJvFooterBtn;
    vst_Grid1: TVirtualStringTree;
    edt_ID: TAdvEdit;
    edt_Emis: TAdvEdit;
    edt_ModSer: TAdvEdit;
    edt_Numero: TAdvEdit;
    edt_Chave: TAdvEdit;
    edt_Sit: TAdvEdit;
    procedure btn_CancelaClick(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure vst_Grid1GetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure btn_EncerraClick(Sender: TObject);
  private
    { Private declarations }
    m_EventoList: IEventoMDFList;
    m_MDF: IManifestoDF ;
    m_Rep: IBaseACBrMDFe;
    procedure Inicialize;
  public
    { Public declarations }
    constructor Create(const aMDF: IManifestoDF; aRep: IBaseACBrMDFe);
    procedure Execute() ;
  public
    class function New(const aMDF: IManifestoDF;
      aRep: IBaseACBrMDFe): IView;
  end;

//var
//  frm_EventoMDFe: Tfrm_EventoMDFe;

implementation

{$R *.dfm}

uses StrUtils, DateUtils,
  pcnConversao, pmdfeConversaoMDFe, pmdfeEnvEventoMDFe, pmdfeRetEnvEventoMDFe,
  ACBrUtil, ACBrMDFeManifestos,
  uTaskDlg, uadodb, udbconst, ucademp, ustr,
  fdm.Styles;

{ Tfrm_EventoMDFe }

procedure Tfrm_EventoMDFe.btn_CancelaClick(Sender: TObject);
var
  S: string ;
  E: TInfEventoCollectionItem;
  C: IEventoMDF ;
begin
    if not InputQueryDlg('Cancelamento do Manifesto','Informe a justificativa:', S) then
    begin
        Exit;
    end;
    S :=Trim(S) ;
    if S <> '' then
    begin
        setStatus('Cancelando Manifesto'#13#10'Aguarde...', crHourGlass);
        try
            if m_Rep.OnlyCanc(m_MDF, S) then
            begin
                //E :=m_Rep.mdfe.WebServices.EnvEvento.EventoRetorno ;
                E :=m_Rep.mdfe.EventoMDFe.Evento.Items[0] ;
                C :=TCEventoMDF.New(m_MDF.id,
                                    E.InfEvento.cOrgao,
                                    Ord(E.InfEvento.tpAmb),
                                    E.InfEvento.chMDFe,
                                    E.InfEvento.dhEvento,
                                    110111,
                                    E.InfEvento.nSeqEvento) ;
                C.xJust :=S ;
                C.setStatus(E.RetInfEvento.cStat, E.RetInfEvento.xMotivo);
                C.setProtocolo( E.RetInfEvento.nProt,
                                E.RetInfEvento.verAplic,
                                '',
                                E.RetInfEvento.dhRegEvento);
                C.cmdInsert ;
                CMsgDlg.Info('%d|%s',[E.RetInfEvento.cStat, E.RetInfEvento.xMotivo]) ;
                Self.Inicialize ;
            end
            else
                CMsgDlg.Warning(Format('%d|%s',[m_Rep.ErrCod, m_Rep.ErrMsg])) ;
        finally
            setStatus('');
        end;
    end
    else
        CMsgDlg.Warning('Justificativa inválida!') ;
    ActiveControl :=vst_Grid1 ;
end;

procedure Tfrm_EventoMDFe.btn_CloseClick(Sender: TObject);
begin
    Self.Close ;

end;

procedure Tfrm_EventoMDFe.btn_EncerraClick(Sender: TObject);
var
  E: TInfEventoCollectionItem;
  C: IEventoMDF ;
begin
    if CMsgDlg.Confirm('Deseja encerrar o Manifesto')  then
    begin
        setStatus('Encerrando Manifesto'#13#10'Aguarde...', crHourGlass);
        try
            if m_Rep.OnlyEncerra(m_MDF) then
            begin
                //
                // ler retorno
                E :=m_Rep.mdfe.EventoMDFe.Evento.Items[0] ;

                //
                // cria novo evento
                C :=TCEventoMDF.New(m_MDF.id,
                                    E.InfEvento.cOrgao,
                                    Ord(E.InfEvento.tpAmb),
                                    E.InfEvento.chMDFe,
                                    E.InfEvento.dhEvento,
                                    110112,
                                    E.InfEvento.nSeqEvento) ;

                C.setEncerra(E.InfEvento.detEvento.dtEnc, E.InfEvento.detEvento.cMun);
                C.setStatus(E.RetInfEvento.cStat, E.RetInfEvento.xMotivo);
                C.setProtocolo( E.RetInfEvento.nProt,
                                E.RetInfEvento.verAplic,
                                '',
                                E.RetInfEvento.dhRegEvento);
                C.cmdInsert ;
                CMsgDlg.Info('%d|%s',[E.RetInfEvento.cStat, E.RetInfEvento.xMotivo]) ;
                Self.Inicialize ;
            end
            else
                CMsgDlg.Warning(Format('%d|%s',[m_Rep.ErrCod, m_Rep.ErrMsg])) ;
        finally
            setStatus('');
        end;

    end;
    ActiveControl :=vst_Grid1 ;
end;

constructor Tfrm_EventoMDFe.Create(const aMDF: IManifestoDF;
  aRep: IBaseACBrMDFe);
begin
    inherited Create(Application);
    m_MDF :=aMDF ;
    m_Rep :=aRep ;
    m_EventoList :=TCEventoMDFList.Create ;
    Self.Inicialize ;
end;

procedure Tfrm_EventoMDFe.Execute;
var
  U: UtilStr ;
begin
    //
    // format
    edt_ID.Text :=U.fInt(m_MDF.id);
    edt_Emis.Text :=U.fDtTm(m_MDF.dhEmissao);
    edt_ModSer.Text :=U.fInt(m_MDF.codMod) +'/'+ U.Zeros(m_MDF.numSer,3) ;
    edt_Numero.Text :=U.fInt(m_MDF.numeroDoc);
    edt_Chave.Text :=m_MDF.chMDFe;
    edt_Sit.DoFormat('%d-%s',[m_MDF.Status,m_MDF.motivo]);
    //
    // mostra
    Self.ShowModal ;
end;

procedure Tfrm_EventoMDFe.Inicialize;
begin
    m_EventoList.Load(m_MDF.id);
    vst_Grid1.Clear ;
    vst_Grid1.RootNodeCount :=m_EventoList.Items.Count ;

end;

class function Tfrm_EventoMDFe.New(const aMDF: IManifestoDF;
  aRep: IBaseACBrMDFe): IView;
begin
    Result :=Tfrm_EventoMDFe.Create(aMDF, aRep);

end;

procedure Tfrm_EventoMDFe.vst_Grid1GetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  E: IEventoMDF ;
  U: UtilStr ;
begin
    if Assigned(Node) then
    begin
        E :=m_EventoList.Items[Node.Index] ;
        case Column of
          00: CellText :=IntToStr(E.id) ;
          01: CellText :=IntToStr(E.codOrg) ;
          02: CellText :=U.fDtTm(E.dhEvento);
          03: CellText :=IntToStr(E.tpEvento) ;
          04: CellText :=IntToStr(E.numSeq) ;
          05: CellText :=Format('%d|%s',[E.Status,E.motivo]) ;
          06: CellText :=E.numProt ;
          07: CellText :=U.fDtTm(E.dhRecebto);
          08: CellText :=E.xJust ;
        end;
    end;
end;

end.
