unit Form.Config;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ExtCtrls, ComCtrls,
  Generics.Collections ,

  //JEDI
  JvExStdCtrls, JvExExtCtrls, JvExtComponent, JvCtrls,
  JvButton, JvFooter, JvToolEdit, JvGroupBox,

  //TMS
  AdvPanel, AdvEdit, JvExMask, AdvGlowButton, AdvOfficeButtons, AdvGroupBox,
  AdvCombo, AdvPageControl,

  //
  VirtualTrees, uVSTree,

  //
  pcnConversao,

  //
  FormBase, unotfis00, Form.ConfigGSerial;


type
  TCEmisNFE = class
  private
    procedure Insert ;
  public
    m_codseq: Int16;
    m_codemp: Int16;
    m_codufe: Int16;
    m_codmun: Int32;

    m_tipamb: TpcnTipoAmbiente;
    m_tipemi: TpcnTipoEmissao;
    m_tipimp: TpcnTipoImpressao;

    m_procemi: TpcnProcessoEmissao;
    m_verproc: string;

    m_certif: TMemoryStream;
    m_xsenha: string;
    m_serial: string;

    m_codstt: Int16;
    m_ultcons: Tdatetime;
    m_chksvc: Boolean ;
    procedure Load(const codseq: Int16 =0);
  end;


type
  Tfrm_Config = class(TBaseForm)
    pnl_Footer: TJvFooter;
    btn_OK: TJvFooterBtn;
    btn_Close: TJvFooterBtn;
    pag_Control1: TAdvPageControl;
    tab_Numeracao: TAdvTabSheet;
    vst_Grid1: TVirtualStringTree;
    btn_New: TJvImgBtn;
    btn_Upd: TJvImgBtn;
    tab_Geral: TAdvTabSheet;
    rgx_FormaEmis: TAdvOfficeRadioGroup;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure vst_Grid1GetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure btn_CloseClick(Sender: TObject);
    procedure btn_NewClick(Sender: TObject);
    procedure btn_UpdClick(Sender: TObject);
    procedure btn_OKClick(Sender: TObject);
  private
    { Private declarations }
    m_Config: TCEmisNFE;
    m_Seriais: TCGenSerialList;
    procedure LoadGrid ;
    //procedure LoadConfig ;
  public
    { Public declarations }
    class procedure cp_Execute();
  end;


implementation

{$R *.dfm}

uses MaskUtils,
  uTaskDlg, uadodb, ucad.empresa ,
  FDM.NFE;

{ TCEmisNFE }

procedure TCEmisNFE.Insert;
var
  C: TADOCommand ;
begin
    C :=TADOCommand.NewADOCommand() ;
    try
        C.AddCmd('insert into emisnfe ( emi_codemp, ');
        C.AddCmd('                      emi_tipamb, ');
        C.AddCmd('                      emi_tipemi, ');
        C.AddCmd('                      emi_tipimp, ');
        C.AddCmd('                      emi_procemi,');
        C.AddCmd('                      emi_verproc)');
        C.AddCmd('values              ( %d,--emi_codemp',[Self.m_codemp]);
        C.AddCmd('                      %d,--emi_tipamb',[Ord(Self.m_tipamb)]);
        C.AddCmd('                      %d,--emi_tipemi',[Ord(Self.m_tipemi)]);
        C.AddCmd('                      %d,--emi_tipimp',[Ord(Self.m_tipimp)]);
        C.AddCmd('                      %d,--emi_procemi',[Ord(Self.m_procemi)]);
        C.AddCmd('                      %s,--emi_verproc)',[C.FStr(Self.m_verproc)]);
        C.Execute ;
    finally
        C.Free ;
    end;
end;

procedure TCEmisNFE.Load(const codseq: Int16);
var
  Q: TADOQuery ;
begin
    Q :=TADOQuery.NewADOQuery() ;
    try
        Q.AddCmd('select *from emisnfe where emi_codemp =%d',[Empresa.codfil]);
        Q.Open ;
        if Q.IsEmpty then
        begin
            Self.m_codemp :=Empresa.codfil ;
            Self.m_tipamb :=Tdm_nfe.getInstance.m_NFE.Configuracoes.WebServices.Ambiente ;
            Self.m_tipemi :=Tdm_nfe.getInstance.m_NFE.Configuracoes.Geral.FormaEmissao ;
            Self.m_tipimp :=Tdm_nfe.getInstance.m_NFE.DANFE.TipoDANFE ;
            Self.m_procemi :=peAplicativoContribuinte ;
            Self.m_verproc :='ATAC SVC 2.5 (2018)' ;
            Self.Insert ;
        end
        else begin
            Self.m_tipamb :=TpcnTipoAmbiente(Q.Field('emi_tipamb').AsInteger) ;
            Self.m_tipemi :=TpcnTipoEmissao(Q.Field('emi_tipemi').AsInteger)  ;
            Self.m_tipimp :=TpcnTipoImpressao(Q.Field('emi_tipimp').AsInteger);
            Self.m_codstt :=Q.Field('emi_codstt').AsInteger;
            Self.m_ultcons:=Q.Field('emi_ultcons').AsDateTime;
            Self.m_chksvc :=Q.Field('emi_chksvc').AsInteger > 0;
        end;
    finally
        Q.Free ;
    end;
end;


{ Tfrm_Config }

procedure Tfrm_Config.btn_CloseClick(Sender: TObject);
begin
    Self.Close ;

end;

procedure Tfrm_Config.btn_NewClick(Sender: TObject);
begin
    if Tfrm_ConfigGSerial.fn_Execute(svNew) then
    begin
        LoadGrid ;
    end;
end;

procedure Tfrm_Config.btn_OKClick(Sender: TObject);
begin
    TCEmpresa.getInstance.EmisNFE.m_tipemi :=TpcnTipoEmissao(
                                                      rgx_FormaEmis.ItemIndex );
    try
        TCEmpresa.getInstance.EmisNFE.Merge ;
        CMsgDlg.Info('Dados gravados com sucesso.');
        ModalResult :=mrOk ;
    except
        CMsgDlg.Error('Gravação dos dados falhou!');
    end;
end;

procedure Tfrm_Config.btn_UpdClick(Sender: TObject);
var
  S: TCGenSerial;
begin
    if vst_Grid1.IndexItem > -1 then
    begin
        S :=m_Seriais.Items[vst_Grid1.IndexItem] ;
        if Tfrm_ConfigGSerial.fn_Execute(svModif, S) then
        begin
            LoadGrid ;
        end;
    end
    else
        CMsgDlg.Warning('Selecione uma série!') ;
end;

class procedure Tfrm_Config.cp_Execute;
var
  F: Tfrm_Config;
begin
    F :=Tfrm_Config.Create(Application) ;
    try
        F.vst_Grid1.Clear ;
        F.ShowModal ;
    finally
        FreeAndNil(F);
    end;
end;

procedure Tfrm_Config.FormCreate(Sender: TObject);
begin
    m_Config :=TCEmisNFE.Create ;
    m_Seriais:=TCGenSerialList.Create ;
end;

procedure Tfrm_Config.FormShow(Sender: TObject);
begin
    TCEmpresa.getInstance.DoLoad(1);
    rgx_FormaEmis.ItemIndex :=Ord(TCEmpresa.getInstance.EmisNFE.m_tipemi );

    LoadGrid() ;

    pag_Control1.ActivePageIndex :=0;
    //ActiveControl :=vst_Grid1 ;
end;

procedure Tfrm_Config.LoadGrid;
begin
    m_Seriais.Load();
    vst_Grid1.Clear ;
    vst_Grid1.RootNodeCount :=m_Seriais.Count ;
    if vst_Grid1.RootNodeCount > 0 then
    begin
        vst_Grid1.IndexItem :=0 ;
    end;
    vst_Grid1.Refresh ;
end;

procedure Tfrm_Config.vst_Grid1GetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  S: TCGenSerial ;
begin
    CellText :='';
    if Assigned(Node) then
    begin
        //00.000.000/0000-00
        S :=m_Seriais.Items[Node.Index] ;
        case Column of
            0:CellText :=FormatMaskText('00\.000\.000\/0000\-00;0; ', S.CNPJ);
            1:CellText :=IntToStr(S.CodMod);
            2:CellText :=Format('%.3d',[S.NumSer]);
            3:if S.Value > 0 then
              begin
                  CellText :=Format('%.6d',[S.Value]);
              end
              else begin
                  CellText :='Ainda não utilizado!';
              end;
            4: CellText :=S.Texto;
        end;
    end;
end;


end.
