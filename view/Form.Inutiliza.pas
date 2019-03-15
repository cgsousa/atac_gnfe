unit Form.Inutiliza;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ExtCtrls,
  //JEDI
  JvExStdCtrls, JvExExtCtrls, JvExtComponent, JvCtrls,
  JvButton, JvFooter, JvToolEdit, JvGroupBox,
  //TMS
  AdvPanel, AdvEdit, JvExMask, AdvGlowButton, AdvOfficeButtons, AdvGroupBox,
  //
  VirtualTrees, uVSTree,
  //
  FormBase,
  uclass, ulog, uTaskDlg, unotfis00;

type
  Tfrm_Inutiliza = class(TBaseForm)
    vst_Grid1: TVirtualStringTree;
    pnl_Footer: TJvFooter;
    btn_New: TJvFooterBtn;
    btn_Close: TJvFooterBtn;
    procedure FormCreate(Sender: TObject);
    procedure vst_Grid1GetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure btn_NewClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
  private
    { Private declarations }
    m_InutList: TCInutNumeroList;
    m_Filter: TInutNumeroFilter ;
    m_NF: TCNotFis00 ;
    procedure DoLoad ;
  public
    { Public declarations }
    class function CF_Show(NF: TCNotFis00): Boolean ;
  end;


implementation

{$R *.dfm}

uses StrUtils, DateUtils,
  JvJCLUtils ,
  pcnConversao, pcnConversaoNFe,
  uadodb ,
  Form.Justifica, FDM.NFE, uACBrNFE;


{ Tfrm_Inutiliza }

procedure Tfrm_Inutiliza.btn_CloseClick(Sender: TObject);
begin
    Self.Close ;

end;

procedure Tfrm_Inutiliza.btn_NewClick(Sender: TObject);
var
  just: Tfrm_Justif;
  N: TCInutNumero;
  nfe: Tdm_nfe;
  rep: IBaseACBrNFE;
begin
    //
    just :=NewJustifica(svInut);
    try
        //nfe :=Tdm_nfe.getInstance;
        rep :=TCBaseACBrNFE.New() ;
        //if just.Execute(nfe.NSerie, Self.m_NF) then
        if just.Execute(rep.nSerie, m_NF) then
        begin
            //if nfe.InutNum(Empresa.CNPJ, just.Text, just.InutNum.m_ano,
            if rep.OnlyInutiliza(Empresa.CNPJ, just.Text, just.InutNum.m_ano,
              just.InutNum.m_codmod, just.InutNum.m_nserie,
              just.edt_NumIni.IntValue,
              just.edt_NumFin.IntValue) then
            begin

                N :=m_InutList.AddNew ;
                N.m_codemp   :=Empresa.codfil ;
                {N.m_tipamb   :=nfe.Inutiliza.TpAmb ;
                N.m_codufe   :=nfe.Inutiliza.cUF ;
                N.m_ano      :=nfe.Inutiliza.Ano ;
                N.m_cnpj     :=nfe.Inutiliza.CNPJ ;
                N.m_codmod   :=nfe.Inutiliza.Modelo ;
                N.m_nserie   :=nfe.Inutiliza.Serie ;
                N.m_numini   :=nfe.Inutiliza.NumeroInicial ;
                N.m_numfin   :=nfe.Inutiliza.NumeroFinal ;
                N.m_justif   :=nfe.Inutiliza.Justificativa ;
                N.m_verapp   :=nfe.Inutiliza.verAplic ;
                N.m_dhreceb  :=nfe.Inutiliza.dhRecbto ;
                N.m_numprot  :=nfe.Inutiliza.Protocolo ;}
                N.m_tipamb   :=rep.retInutiliza.TpAmb ;
                N.m_codufe   :=rep.retInutiliza.cUF ;
                N.m_ano      :=rep.retInutiliza.Ano ;
                N.m_cnpj     :=rep.retInutiliza.CNPJ ;
                N.m_codmod   :=rep.retInutiliza.Modelo ;
                N.m_nserie   :=rep.retInutiliza.Serie ;
                N.m_numini   :=rep.retInutiliza.NumeroInicial ;
                N.m_numfin   :=rep.retInutiliza.NumeroFinal ;
                N.m_justif   :=rep.retInutiliza.Justificativa ;
                N.m_verapp   :=rep.retInutiliza.verAplic ;
                N.m_dhreceb  :=rep.retInutiliza.dhRecbto ;
                N.m_numprot  :=rep.retInutiliza.Protocolo ;
                N.m_codstt   :=102 ;
                N.m_motivo   :='Inutilizacao de numero homologado' ;

                N.m_ultnum :=just.InutNum.m_ultnum ;

                { TODO 1 -cNFE : PESISTIR OS DADOS NO BANCO }
                try
                    N.DoInsert(N.m_codstt, N.m_motivo) ;
                    CMsgDlg.Info('%d|%s',[rep.retInutiliza.cStat,rep.retInutiliza.xMotivo]);
                    DoLoad ;
                except
                    raise
                end;

            end
            else
                CMsgDlg.Warning(rep.ErrMsg);
        end;

    finally
        FreeAndNil(just);
    end;

    ActiveControl :=vst_Grid1 ;
end;

class function Tfrm_Inutiliza.CF_Show(NF: TCNotFis00): Boolean ;
var
  F: Tfrm_Inutiliza;
begin
    F :=Tfrm_Inutiliza.Create(Application);
    try
        F.m_NF :=NF ;
        F.vst_Grid1.Clear ;
        Result :=F.ShowModal =mrOk ;
    finally
        FreeAndNil(F);
    end;
end;

procedure Tfrm_Inutiliza.DoLoad;
begin
    m_Filter.codemp :=Empresa.codfil;
    m_Filter.ano :=YearOf(date);
    if m_InutList.Load(m_Filter) then
    begin
        vst_Grid1.Clear ;
        vst_Grid1.RootNodeCount :=m_InutList.Count ;
        vst_Grid1.IndexItem :=0;
        vst_Grid1.Refresh ;
        ActiveControl :=vst_Grid1;
    end
    else
        ActiveControl :=btn_New;
end;

procedure Tfrm_Inutiliza.FormCreate(Sender: TObject);
begin
    m_InutList :=TCInutNumeroList.Create ;

end;

procedure Tfrm_Inutiliza.FormShow(Sender: TObject);
begin
    DoLoad;

end;

procedure Tfrm_Inutiliza.vst_Grid1GetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  N: TCInutNumero ;
begin
    CellText :='';
    if Assigned(Node) then
    begin
        N :=m_InutList.Items[Node.Index] ;
        case Column of
            0: CellText :=N.m_cnpj;
            1: CellText :=IntToStr(N.m_ano);
            2: CellText :=IntToStr(N.m_codmod);
            3: CellText :=Format('%.3d',[N.m_nserie]);
            4: CellText :=Format('%.6d',[N.m_numini]);
            5: CellText :=Format('%.6d',[N.m_numfin]);
            6: CellText :=N.m_justif;
            7: CellText :=N.m_numprot;
            8: CellText :=CFrmtStr.Dat(N.m_dhreceb) ;
        end;
    end;
end;

end.
