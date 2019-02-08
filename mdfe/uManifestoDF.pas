{***
* Classes/Tipos para tratar o manifesto de doc. fiscais
* Atac Sistemas
* Todos os direitos reservados
* Autor: Carlos Gonzaga
* Data: 07.11.2018
*}

unit uManifestoDF;

interface

uses
  Classes, SysUtils, DB,
  Generics.Collections ,
  uIntf, uVeiculo, uCondutor;

type
  EMunCargaIsEmpty = class(Exception);
  EVeiculoIsEmpty = class(Exception);
  ECondutorIsEmpty = class(Exception);
  EMunDescargaIsEmpty = class(Exception);
  EDocIsEmpty = class(Exception);


  //
  // filtro
  TManifestoFilter = record
    codseq: Int32 ;
    datini,datfin: TDateTime ;
    status: (mfsDoneSend, mfsConting, mfsProcess, mfsCancel, mfsError, mfsNone);
    constructor Create(const codseq: Int32);
  end;

  //
  // listas
  TCMun = class;
  TCMunList = class;

  TCManifestoDF = class;

  //
  // Informações dos Documentos fiscais vinculados ao manifesto
  IManifestodf02nfe = Interface(IInterface)
    function getChvNFE: string;
    procedure setChvNFE(Value: string);
    property chvNFE: string read getChvNFE write setChvNFE;
    function getCodBar: string ;
    procedure setCodBar(Value: string) ;
    property codBarras: string read getCodBar write setCodBar;
    //m_indree: Boolean;
    function getVlrNtf: Currency;
    procedure setVlrNtf(Value: Currency);
    property vlrNtf: Currency read getVlrNtf write setVlrNtf;
    function getVolPsoB: Double;
    procedure setVolPsoB(Value: Double);
    property volPsoB: Double read getVolPsoB write setVolPsoB;
    //
    function getState: TModelState;
    property State: TModelState read getState ;
  end;
  TCManifestodf02nfe = class;

  IManifestodf02nfeList = Interface(IInterface)
    function addNew(aNFE: IManifestodf02nfe): IManifestodf02nfe ;
    function indexOf(const aChv: string): IManifestodf02nfe ;
    procedure clearItems ;
    function getDataList: TList<IManifestodf02nfe>;
  end;
  TCManifestodf02nfeList = class ;

  TManifestodf01munTyp = (mtCarga, mtDescarga) ;
  IManifestodf01mun = interface //(IModel)
    function getCodMun: Int32;
    procedure setCodMun(Value: Int32) ;
    property codigoMun: Int32 read getCodMun write setCodMun;

    function getNomMun: string ;
    procedure setNomMun(Value: string) ;
    property nomeMun: string read getNomMun write setNomMun;

    function getUFeMun: string ;
    procedure setUFeMun(Value: string) ;
    property UFeMun: string read getUFeMun write setUFeMun;

    function getTipMun: TManifestodf01munTyp;
    procedure setTipMun(Value: TManifestodf01munTyp) ;
    property tipoMun: TManifestodf01munTyp read getTipMun write setTipMun;
  end;
  TCManifestodf01mun = class;

  IManifestodf01munList = interface //(IDataList)
    function addNew(aMun: TCManifestodf01mun): TCManifestodf01mun ;
    procedure clearItems ;
    function getDataList: TObjectList<TCManifestodf01mun> ;
  end;
  TCManifestodf01munList = class;


  IManifestodf01MunDescarga =Interface(IInterface)
    function getMun: Imanifestodf01mun ;
    property mun: Imanifestodf01mun read getMun;
    function getNFEList: IManifestodf02nfeList ;
    property nfeList: IManifestodf02nfeList read getNFEList;
  end;
  TCManifestodf01MunDescarga = class ;

  {IManifestodf01MunDescargaList = interface
    function addNew: IManifestodf02nfe ;
    function indexOf(const aChv: string): IManifestodf02nfe ;
    procedure clearItems ;
  end;
  TCManifestodf01MunDescargaList =class ;}


  //
  // modal rodoviário
  IManifestodf04Rodo = interface
    function getVeiculo: IVeiculo ;
    property veiculo: IVeiculo read getVeiculo ;
    function getCondutorList: IDataList<ICondutor>;
    property condutores: IDataList<ICondutor> read getCondutorList ;
  end;
  TCManifestodf04Rodo = class;

  TMunFilter = record
    codmun: Int32;
    nommun: string;
    ufemun: string;
    constructor Create(const aCodMun: Int32; aUfeMun: string) ;
  end;

  TCMun = class
  private
    m_parent: TCMunList;
    m_index: Int32 ;
  public
    m_codmun: Int32 ;
    m_nommun: string;
    m_ufemun: string;
    m_checked: Boolean ;
  end;

  TCMunList = class(TList<TCMun>)
  private
    function AddNew(): TCMun ;
  public
    function load(const aFilter: TMunFilter): Boolean ;
    class procedure loadUF(aStr: TStrings) ;
  end;

  IManifestoDF = interface(IModel)
    ['{EB902EEE-587A-4876-93D6-7E1DE2850FF0}']

    function GetOnModelChanged: TModelChangedEvent;
    procedure SetOnModelChanged(Value: TModelChangedEvent);
    property OnModelChanged: TModelChangedEvent read GetOnModelChanged
      write SetOnModelChanged;
    function getStateChange: TModelState ;
    procedure setStateChange(Value: TModelState) ;
    property State: TModelState read getStateChange write setStateChange;

    function getCodSeq: Int32 ;
    property id: Int32 read getCodSeq ;

    function getCodUFe: Int16 ;
    procedure setCodUF(Value: Int16) ;
    property codUfe: Int16 read getCodUFe write setCodUF;

    function getTpAmb: Int16 ;
    procedure setTpAmb(Value: Int16) ;
    property tpAmbiente: Int16 read getTpAmb write setTpAmb;

    function getTpEmit: Int16 ;
    procedure setTpEmit(Value: Int16) ;
    property tpEmitente: Int16 read getTpEmit write setTpEmit;

    function getTpTransp: Int16 ;
    procedure setTpTransp(Value: Int16) ;
    property tpTransportador: Int16 read getTpTransp write setTpTransp;

    function getCodMod: Int16 ;
    property codMod: Int16 read getCodMod;

    function getNumSer: Int16;
    property numSer: Int16 read getNumSer;

    function getNumDoc: Int32 ;
    procedure setNumDoc(Value: Int32) ;
    property numeroDoc: Int32 read getNumDoc write setNumDoc;

    function getModal: Int16 ;
    property modalidade: Int16 read getModal ;

    function getDHEmis: TDateTime;
    procedure setDHEmis(Value: TDateTime) ;
    property dhEmissao: TDateTime read getDHEmis write setDHEmis;

    function getTpEmis: Int16 ;
    procedure setTpEmis(Value: Int16) ;
    property tpEmissao: Int16 read getTpEmis write setTpEmis;

//    m_procemi: Int16;
    function getVerProc: string ;
    property verProc: string read getVerProc ;

    function getUFeIni: string ;
    procedure setUFeIni(Value: string) ;
    property ufeIni: string read getUFeIni write setUFeIni;

    function getUFeFim: string ;
    procedure setUFeFim(Value: string) ;
    property ufeFim: string read getUFeFim write setUFeFim;

//    m_dhviagem: Tdatetime;
//    m_indcnlvrd: Boolean ;

    function getRNTRC: string ;
    procedure setRNTRC(Value: string) ;
    property rntrc: string read getRNTRC write setRNTRC;

    function getMunicipios: TCManifestodf01munList;
    property municipios: TCManifestodf01munList read getMunicipios ;

    function getModalRodo: TCManifestodf04Rodo ;
    property modalRodo: TCManifestodf04Rodo read getModalRodo ;

    function getMunDescarga: TCManifestodf01MunDescarga; //IManifestodf01munList ;
    property munDescarga: TCManifestodf01MunDescarga read getMunDescarga ;

    function getStatus: Int16 ;
    property Status: Int16 read getStatus ;

    function getMotivo: string ;
    property motivo: string read getMotivo;

    function getChMDFE: string ;
    property chMDFE: string read getChMDFE;

    //
    // info de protocolo
    function getVerApp: string ;
    property verApp: string read getVerApp ;
    function getDHRecebto: TDatetime ;
    property dhRecebto: TDatetime read getDHRecebto ;
    function getNumProt: string ;
    property numProt: string read getNumProt ;
    function getDigVal: string ;
    property digVal: string read getDigVal ;

    procedure setXML(const aCodStt: Int16; const aMotivo, aChv, aXML: string) ;
    procedure setRet(const aCodStt: Int16; const aMotivo,
      ret_verapp, ret_numreci, ret_numprot, ret_digval: string;
      const ret_dhreceb: Tdatetime) ;

    procedure loadFromDataset(ds: TDataSet);
    function cmdFind(const afilter: TManifestoFilter): Boolean ;
    procedure cmdInsert ;
    procedure cmdUpdate ;
    procedure cmdDelete ;

    procedure Insert ;
    procedure Edit ;

    function Merge(): TModelUpdateKind;
  end;


  TCManifestoDF = class(TInterfacedObject, IManifestoDF)
  private
    m_OnModelChanged: TModelChangedEvent;
    m_StateChange: TModelState ;
    procedure cmdInsert ;
    procedure cmdUpdate ;
    procedure cmdDelete ;
    function GetOnModelChanged: TModelChangedEvent;
    procedure SetOnModelChanged(Value: TModelChangedEvent);
    function getStateChange: TModelState ;
    procedure setStateChange(Value: TModelState) ;

  private
    m_codseq: Int32;
    m_codemp: Int16;
    m_codufe: Int16;
    m_tipamb: Int16;
    m_tpemit: Int16;
    m_tptransp: Int16;
    m_codmod: Int16;
    m_nserie: Int16;
    m_numdoc: Int32;
    m_modal: Int16;
    m_dhemis: Tdatetime;
    m_tpemis: Int16;
    m_procemi: Int16;
    m_verproc: string ;
    m_ufeini: string;
    m_ufefim: string;
    m_dhviagem: Tdatetime;
    m_indcnlvrd: Boolean ;

    m_rntrc: string;
    m_codvei: Int16;

    m_Municipios: TCManifestodf01munList ;
    m_ModalRodo: TCManifestodf04Rodo ;
    m_MunDescarga: TCManifestodf01MunDescarga;

    m_codstt: Int16;
    m_motivo: string;

    m_chmdfe: string ;
    m_xml: string ;

    // retorno
    m_verapp: string ;
    m_dhrecebto: Tdatetime;
    m_numreci: string ;
    m_numprot: string ;
    m_digval: string ;

    function getCodSeq: Int32 ;

    function getCodUFe: Int16 ;
    procedure setCodUF(Value: Int16) ;

    function getTpAmb: Int16 ;
    procedure setTpAmb(Value: Int16) ;

    function getTpEmit: Int16 ;
    procedure setTpEmit(Value: Int16) ;

    function getTpTransp: Int16 ;
    procedure setTpTransp(Value: Int16) ;

    function getCodMod: Int16 ;
    function getNumSer: Int16;

    function getNumDoc: Int32 ;
    procedure setNumDoc(Value: Int32) ;

    function getModal: Int16 ;
    property modalidade: Int16 read getModal ;

    function getDHEmis: TDateTime;
    procedure setDHEmis(Value: TDateTime) ;

    function getTpEmis: Int16 ;
    procedure setTpEmis(Value: Int16) ;

    function getVerProc: string ;

    function getUFeIni: string ;
    procedure setUFeIni(Value: string) ;

    function getUFeFim: string ;
    procedure setUFeFim(Value: string) ;

    function getRNTRC: string ;
    procedure setRNTRC(Value: string) ;

    function getMunicipios: TCManifestodf01munList;
//    function getMunCarga: IManifestodf01munList;
    function getModalRodo: TCManifestodf04Rodo ;
    function getMunDescarga: TCManifestodf01MunDescarga;

    function getStatus: Int16 ;
    function getMotivo: string ;

    function getChMDFE: string ;

    //
    // info protocolo
    function getVerApp: string ;
    function getDHRecebto: TDatetime ;
    function getNumProt: string ;
    function getDigVal: string ;

    procedure loadMunDocs;
    procedure loadCondutores;

  public
    property State: TModelState read getStateChange write setStateChange;
    property OnModelChanged: TModelChangedEvent read GetOnModelChanged
      write SetOnModelChanged;
    procedure Inicialize;

    procedure loadFromDataset(ds: TDataSet);
    function cmdFind(const afilter: TManifestoFilter): Boolean ;
    function isValid: Boolean ;
    procedure Insert;
    procedure Edit ;
    function Load: Boolean ;
    function Merge(): TModelUpdateKind;

  public
    constructor Create ;
    destructor Destroy; override ;
    property id: Int32 read getCodSeq ;
    property codUfe: Int16 read getCodUFe write setCodUF;
    property tpAmbiente: Int16 read getTpAmb write setTpAmb;
    property tpEmitente: Int16 read getTpEmit write setTpEmit;
    property tpTransportador: Int16 read getTpTransp write setTpTransp;
    property codMod: Int16 read getCodMod;
    property numSer: Int16 read getNumSer;
    property numeroDoc: Int32 read getNumDoc write setNumDoc;
    property dhEmissao: TDateTime read getDHEmis write setDHEmis;
    property tpEmissao: Int16 read getTpEmis write setTpEmis;
    property verProc: string read getVerProc ;
    property ufeIni: string read getUFeIni write setUFeIni;
    property ufeFim: string read getUFeFim write setUFeFim;
    property rntrc: string read getRNTRC write setRNTRC;
//    property munCarga: Imanifestodf01munList read getMunCarga ;
    property municipios: TCManifestodf01munList read getMunicipios ;
    property modalRodo: TCManifestodf04Rodo read getModalRodo ;
    property munDescarga: TCManifestodf01MunDescarga read getMunDescarga ;
    property Status: Int16 read getStatus ;
    property motivo: string read getMotivo;
    property chMDFE: string read getChMDFE;

    property verApp: string read getVerApp ;
    property dhRecebto: TDatetime read getDHRecebto ;
    property numProt: string read getNumProt ;
    property digVal: string read getDigVal ;

    procedure setXML(const aCodStt: Int16; const aMotivo, aChv, aXML: string);
    procedure setRet(const aCodStt: Int16; const aMotivo,
      ret_verapp, ret_numreci, ret_numprot, ret_digval: string;
      const ret_dhreceb: Tdatetime) ;
  public
    class function CLoad(const aFilter: TManifestoFilter): TDataSet;
  public
    const CSTT_DUPL = 577;
  end;

  TCmanifestodf01mun = class(TInterfacedObject, Imanifestodf01mun, IManifestodf02nfeList)
//  TCmanifestodf01mun = class(TAggregatedObject, Imanifestodf01mun)
  private
    m_codseq: Int32;
    m_codmdf: Int32;
    m_codmun: Int32;
    m_xmunic: string;
    m_ufemun: string;
    m_tipmun: TManifestodf01munTyp;
    m_NFEList: TCManifestodf02nfeList ;
    function getCodMun: Int32;
    procedure setCodMun(Value: Int32) ;
    function getNomMun: string ;
    procedure setNomMun(Value: string) ;
    function getUFeMun: string ;
    procedure setUFeMun(Value: string) ;
    function getTipMun: TManifestodf01munTyp;
    procedure setTipMun(Value: TManifestodf01munTyp) ;
  public
    constructor Create(aTipMun: TManifestodf01munTyp) ;
    property codigoMun: Int32 read getCodMun write setCodMun;
    property nomeMun: string read getNomMun write setNomMun;
    property UFeMun: string read getUFeMun write setUFeMun;
    property tipoMun: TManifestodf01munTyp read getTipMun write setTipMun;
    property nfeList: TCManifestodf02nfeList read m_NFEList implements IManifestodf02nfeList;
  public
    class function New(const codseq, codmun: Int32; const xmunic, ufemun: string;
      const tipmun: TManifestodf01munTyp): TCmanifestodf01mun ;
  end;

  TCmanifestodf01munList = class(TInterfacedObject, Imanifestodf01munList)
  //TCmanifestodf01munList = class(TAggregatedObject, Imanifestodf01munList)
  private
    m_DataList: TObjectList<TCManifestodf01mun> ;
  public
    constructor Create ;
    function addNew(aMun: TCManifestodf01mun): TCManifestodf01mun ;
    function indexOf(const codseq: Int32): TCManifestodf01mun; overload;
    function indexOf(const codmun: Int32;
      const tipmun: TManifestodf01munTyp): TCManifestodf01mun; overload;
    procedure clearItems ;
    function getDataList: TObjectList<TCManifestodf01mun> ;
  end;


  TCManifestodf02nfe = class(TInterfacedObject, IManifestodf02nfe)
  private
    m_chvnfe: string;
    m_codbar: string;
    m_indree: Boolean;
//    m_codntf: Int32;
    m_vlrntf: Currency;
    m_volpsob: Double;
    m_State: TModelState ;

    function getChvNFE: string;
    procedure setChvNFE(Value: string);

    function getCodBar: string ;
    procedure setCodBar(Value: string) ;

//    function getCodNtf: Int32;
//    procedure setCodNtf(Value: Int32);

    function getVlrNtf: Currency;
    procedure setVlrNtf(Value: Currency);

    function getVolPsoB: Double;
    procedure setVolPsoB(Value: Double);

    function getState: TModelState;
  public
    property chvNFE: string read getChvNFE write setChvNFE;
    property codBarras: string read getCodBar write setCodBar;
    property vlrNtf: Currency read getVlrNtf write setVlrNtf;
    property volPsoB: Double read getVolPsoB write setVolPsoB;
    property State: TModelState read getState ;
    class function New(const chvnfe, codbar: string; const indree: Boolean;
      const vlrntf: Currency; const volpsob: Double): IManifestodf02nfe ;
  end;

  TCManifestodf02nfeList =class(TAggregatedObject, IManifestodf02nfeList)
  private
    m_DataList: TList<IManifestodf02nfe> ;
  public
    constructor Create(aController: IInterface);
    destructor Destroy; override ;
    function addNew(aNFE: IManifestodf02nfe): IManifestodf02nfe ;
    function indexOf(const aChv: string): IManifestodf02nfe ; overload ;
    function indexOf(const aIndex: Int32): IManifestodf02nfe; overload ;
    function getDataList: TList<IManifestodf02nfe>;
    procedure clearItems ;
  end;

//  IManifestodf01MunDescarga =interface
//    function getMun: Imanifestodf01mun ;
//    property mun: Imanifestodf01mun ;
//    function getNFEList: IManifestodf02nfeList ;
//    property nfeList: IManifestodf02nfeList read getNFEList;
//  end;
  TCManifestodf01MunDescarga = class(TInterfacedObject, Imanifestodf01mun, IManifestodf02nfeList)
  private
    m_Mun: TCManifestodf01mun ;
    m_NFEList: TCManifestodf02nfeList ;
  public
    property municipio: TCManifestodf01mun read m_Mun implements Imanifestodf01mun;
    property nfeList: TCManifestodf02nfeList read m_NFEList implements IManifestodf02nfeList;
    constructor Create;
    destructor Destroy; override ;
  end;

  TCManifestodf04Rodo =class(TInterfacedObject, IVeiculo, ICondutorList)
  private
    m_Veiculo: TCVeiculo ;
    m_CondutorList: TCCondutorList ;
  public
    m_versao: string ;
    m_rntrc: string ;
    property veiculo: TCVeiculo read m_Veiculo implements IVeiculo;
    property condutores: TCCondutorList read m_CondutorList implements ICondutorList;
    constructor Create;
    destructor Destroy; override ;
  end;

  //
  // lista de manifestos
  IManifestoDFList = interface (IDataList<IManifestoDF>)
  end;
  TCManifestoDFList = class(TAggregatedObject, IManifestoDFList)
  private
    m_DataList: TList<IManifestoDF> ;
    function getItems: TList<IManifestoDF>;
  protected
  public
    constructor Create(aController: IInterface);
    function addNew(aItem: IManifestoDF): IManifestoDF ;
    procedure clearItems ;
    property Items: TList<IManifestoDF> read getItems ;
    function Load(const aFilter: TManifestoFilter): Boolean;
  end;



implementation

uses StrUtils, ADODB, Variants,
  uadodb ;


{ TCMunList }

function TCMunList.AddNew(): TCMun;
begin
    Result :=TCMun.Create ;
    Result.m_parent :=Self;
    Result.m_index :=Self.Count;
    Add(Result);
end;

function TCMunList.load(const aFilter: TMunFilter): Boolean;
var
  Q: TADOQuery ;
  M: TCMun ;
var
  fmun_codigo,fmun_nommun,fmun_uf: TField ;
begin
    //
    // reset
    Self.Clear;

    //
    //
    Q :=TADOQuery.NewADOQuery();
    try
        Q.AddCmd('declare @codmun int; set @codmun =%d;         ',[aFilter.codmun]) ;
        Q.AddCmd('declare @ufemun char(2); set @ufemun =%s;     ',[Q.FStr(aFilter.ufemun)]);
        Q.AddCmd('declare @nommun varchar(30); set @nommun =?;  ');
        Q.AddCmd('select                                        ');
        Q.AddCmd('  codcidadeibge as mun_codigo ,               ');
        Q.AddCmd('  cidade as mun_nommun        ,               ');
        Q.AddCmd('  uf as mun_uf                                ');
        Q.AddCmd('from cidadeibge                               ');
        if aFilter.codmun > 0 then
          Q.AddCmd('where codcidadeibge =@codmun                ')
        else begin
          Q.AddCmd('where uf=@ufemun                            ');
          Q.AddCmd('and   cidade like @nommun                   ');
        end;
        Q.AddCmd('order by cidade                               ');

        Q.AddParamWithValue('@nommun', ftString, aFilter.nommun+'%');

        Q.Open ;
        Result :=not Q.IsEmpty ;

        fmun_codigo :=Q.Field('mun_codigo') ;
        fmun_nommun :=Q.Field('mun_nommun') ;
        fmun_uf :=Q.Field('mun_uf') ;

        while not Q.Eof do
        begin
            M :=Self.AddNew() ;
            M.m_codmun :=fmun_codigo.AsInteger;
            M.m_nommun :=fmun_nommun.AsString ;
            M.m_ufemun :=fmun_uf.AsString ;
            M.m_checked :=False ;
            Q.Next ;
        end;

    finally
        FreeAndNil(Q) ;
    end;
end;


class procedure TCMunList.loadUF(aStr: TStrings);
var
  Q: TADOQuery ;
begin
    //
    // reset
    aStr.Clear ;

    //
    //
    Q :=TADOQuery.NewADOQuery();
    try
        Q.AddCmd('select uf as mun_ufemun');
        Q.AddCmd('from cidadeibge        ');
        Q.AddCmd('group by uf            ');
        Q.AddCmd('order by uf            ');
        Q.Open ;
        while not Q.Eof do
        begin
            aStr.Add(Q.Field('mun_ufemun').AsString) ;
            Q.Next ;
        end;
    finally
       Q.Free ;
    end;
end;


{ TCManifestoDF }

class function TCManifestoDF.CLoad(const aFilter: TManifestoFilter): TDataSet;
var
  Q: TADOQuery ;
begin
    Result :=nil;

    //
    Q :=TADOQuery.NewADOQuery() ;
    Q.AddCmd('declare @codseq int; set @codseq =%d;         ',[aFilter.codseq]);
    Q.AddCmd('declare @datini smalldatetime; set @datini =?;');
    Q.AddCmd('declare @datfin smalldatetime; set @datfin =?;');
    Q.AddCmd('select                                        ');
    Q.AddCmd('  convert(int, md0_codseq) as md0_codseq,     ');
    Q.AddCmd('  md0_codemp,                                 ');
    Q.AddCmd('  md0_versao,                                 ');
    Q.AddCmd('  md0_codufe,                                 ');
    Q.AddCmd('  md0_tipamb,                                 ');
    Q.AddCmd('  md0_tpemit,                                 ');
    Q.AddCmd('  md0_tptransp,                               ');
    Q.AddCmd('  md0_codmod,                                 ');
    Q.AddCmd('  md0_nserie,                                 ');
    Q.AddCmd('  md0_numdoc,                                 ');
    Q.AddCmd('  md0_modal,                                  ');
    Q.AddCmd('  md0_dhemis,                                 ');
    Q.AddCmd('  md0_tpemis,                                 ');
    Q.AddCmd('  md0_procemi,                                ');
    Q.AddCmd('  md0_verproc,                                ');
    Q.AddCmd('  md0_ufeini,                                 ');
    Q.AddCmd('  md0_ufefim,                                 ');
    Q.AddCmd('  md0_dhviagem,                               ');
    Q.AddCmd('  md0_indcnlvrd,                              ');
    Q.AddCmd('  md0_rntrc ,                                 ');
    Q.AddCmd('  md0_codvei,                                 ');
    Q.AddCmd('  md0_codstt,                                 ');
    Q.AddCmd('  md0_motivo,                                 ');
    Q.AddCmd('  md0_chmdfe                                  ');
    Q.AddCmd('from manifestodf00                            ');
    if aFilter.codseq > 0 then
        Q.AddCmd('where md0_codseq = @codseq                ')
    else
        Q.AddCmd('where md0_dhemis between @datini and @datfin');
    Q.AddCmd('order by md0_codseq desc                      ');

    if not Q.Prepared then
    begin
        Q.Prepared :=True;
    end;

    if afilter.datini > 0 then
    begin
        Q.AddParamDatetime('@datini', afilter.datini);
        Q.AddParamDatetime('@datfin', afilter.datfin, True);
    end
    else begin
        Q.AddParamDatetime('@datini', date);
        Q.AddParamDatetime('@datfin', date);
    end;

    //Q.SaveToFile(Format('%s.Load.sql-txt',[Self.ClassName]));
    Q.Open ;
    //
    Result :=TDataSet(Q);
end;

procedure TCManifestoDF.cmdDelete;
begin

end;

function TCManifestoDF.cmdFind(const afilter: TManifestoFilter): Boolean;
var
  Q: TDataSet ;
begin
    //
    //
    Q :=TCManifestoDF.CLoad(afilter) ;

    try
        Result :=not Q.IsEmpty ;
        if not Result then
            raise EBuscaIsEmpty.Create('Nenhum manifesto encontrado!');

        if Result then
        begin
            Self.loadFromDataset(Q);
            //
            // carrega municipio carga/descarga
            Self.loadMunDocs ;

            //
            // carrega condutores
            Self.loadCondutores ;

            Self.State :=msBrowse ;
        end
        else
            Self.Inicialize
            ;
    finally
        Q.Free ;
    end;
end;

procedure TCManifestoDF.cmdInsert;
var
  sp: TADOStoredProc;
  C,C2: TADOCommand ;
var
  M: TCManifestodf01mun ;
  N: IManifestodf02nfe ;
  P: ICondutor ;
var
  codseq: Int32 ;
  //codseqList: TList<Int32> ;
begin
    //
    //
    Self.m_codemp :=Empresa.codfil;
    Self.m_codvei :=m_ModalRodo.veiculo.id ;
    Self.m_verproc :='ATAC MDFe 0.01';
    if Self.m_rntrc = EmptyStr then
        Self.m_rntrc :=' ';
    //
    // obtem UF de carga/descarga
    for M in m_Municipios.getDataList do
    begin
        if M.tipoMun =mtCarga then
            Self.m_ufeini :=M.m_ufemun
        else
            Self.m_ufefim :=M.m_ufemun;
    end;

    //
    // command para registrar as notas vinculadas ao manifesto
    C2:=TADOCommand.NewADOCommand();
    C2.AddCmd('declare @codmdf int            ;set @codmdf =?;    ');
    C2.AddCmd('declare @codmun int            ;set @codmun =?;    ');
    C2.AddCmd('declare @chvnfe char(44)       ;set @chvnfe =?;    ');
    C2.AddCmd('declare @codbar varchar(14)    ;                   ');
    C2.AddCmd('declare @indree smallint       ;                   ');
    C2.AddCmd('declare @vlrntf numeric (15,2) ;set @vlrntf =?;    ');
    C2.AddCmd('declare @volpsob numeric (12,3);set @volpsob=?;    ');
    C2.AddCmd('insert into manifestodf02nfe( md2_codmun ,         ');
    C2.AddCmd('                              md2_chvnfe ,         ');
    C2.AddCmd('                              md2_codbar ,         ');
    C2.AddCmd('                              md2_indree ,         ');
    C2.AddCmd('                              md2_vlrntf ,         ');
    C2.AddCmd('                              md2_volpsob)         ');
    C2.AddCmd('values                      ( @md2_codmun ,        ');
    C2.AddCmd('                              @md2_chvnfe ,        ');
    C2.AddCmd('                              @md2_codbar ,        ');
    C2.AddCmd('                              @md2_indree ,        ');
    C2.AddCmd('                              @md2_vlrntf ,        ');
    C2.AddCmd('                              @md2_volpsob);       ');
    C2.AddCmd('--//                                               ');
    C2.AddCmd('--// registra na notfis00                          ');
    C2.AddCmd('update notfis00 set nf0_codmdf =@codmdf            ');
    C2.AddCmd('where nf0_chvnfe =@chvnfe                          ');

    C2.AddParamWithValue('@codmdf', ftInteger, Self.m_codseq) ;
    C2.AddParamWithValue('@codmun', ftInteger, 0) ;
    C2.AddParamWithValue('@chvnfe', ftString, DupeString('*', 44)) ;
    C2.AddParamWithValue('@vlrntf', ftCurrency, 0) ;
    C2.AddParamWithValue('@volpsob', ftFloat, 0.000);

    //
    // command geral
    C :=TADOCommand.NewADOCommand();
    try
        //
        // emite um MDF-e
        // respectivo para o modalidade rodoviário
        sp :=TADOStoredProc.NewADOStoredProc('sp_manifestodf00_add');
        try
            sp.AddParamWithValue('@codemp', ftSmallint, Self.m_codemp);
            sp.AddParamWithValue('@codufe', ftSmallint, Self.m_codufe);
            sp.AddParamWithValue('@tipamb', ftSmallint, Self.m_tipamb);
            sp.AddParamWithValue('@tpemit', ftSmallint, Self.m_tpemit);
            sp.AddParamWithValue('@tptransp', ftSmallint, Self.m_tptransp);
            sp.AddParamWithValue('@modal', ftSmallint, Self.m_modal);
            sp.AddParamWithValue('@tpemis', ftSmallint, Self.m_tpemis);
            sp.AddParamWithValue('@verproc', ftString, Self.m_verproc);
            sp.AddParamWithValue('@ufeini', ftString, Self.m_ufeini);
            sp.AddParamWithValue('@ufefim', ftString, Self.m_ufefim);
            sp.AddParamWithValue('@rntrc', ftString, Self.m_rntrc);
            sp.AddParamWithValue('@codvei', ftSmallint, Self.m_codvei);
            sp.AddParamOut('@codseq', ftInteger);
            try
                //
                // begin trans
                if not C.Connection.InTransaction then
                begin
                    C.Connection.BeginTrans ;
                end;

                sp.ExecProc ;
                //
                // obtem o cod.seq para posterior process..
                Self.m_codseq :=sp.Param('@codseq').Value ;
            except
                if C.Connection.InTransaction then
                begin
                    C.Connection.RollbackTrans;
                end;
                raise;
            end;
        finally
            sp.Free ;
        end;

        //
        // cmd dos municipios
        C.AddCmd('declare @md1_codmdf int         ;set @md1_codmdf =?;');
        C.AddCmd('declare @md1_codmun int         ;set @md1_codmun =?;');
        C.AddCmd('declare @md1_xmunic varchar(20) ;set @md1_xmunic =?;');
        C.AddCmd('declare @md1_tipmun smallint    ;set @md1_tipmun =?;');
        C.AddCmd('insert into manifestodf01mun( md1_codmdf ,          ');
        C.AddCmd('                              md1_codmun ,          ');
        C.AddCmd('                              md1_xmunic ,          ');
        C.AddCmd('                              md1_tipmun )          ');
        C.AddCmd('values                      ( @md1_codmdf ,         ');
        C.AddCmd('                              @md1_codmun ,         ');
        C.AddCmd('                              @md1_xmunic ,         ');
        C.AddCmd('                              @md1_tipmun );        ');
        //
        // params
        C.AddParamWithValue('@md1_codmdf', ftInteger, Self.m_codseq) ;
        C.AddParamWithValue('@md1_codmun', ftInteger, 0) ;
        C.AddParamWithValue('@md1_xmunic', ftString, DupeString(' ', 20)) ;
        C.AddParamWithValue('@md1_tipmun', ftSmallint, 0) ;

        //
        // registra os municipios carregamento/descarregamento
        for M in m_Municipios.getDataList do
        begin
            C.Param('@md1_codmun').Value :=M.codigoMun ;
            C.Param('@md1_xmunic').Value :=M.nomeMun ;
            C.Param('@md1_tipmun').Value :=Ord(M.tipoMun);
            try
                C.Execute ;
                //
                // registra as nfe´s vinculadas ao manifesto
                // se, e somente se, o mun. for de descarregamento
                if M.tipoMun =mtDescarga then
                begin
                    //
                    // guarda cada manifestodf01mun.md1_codseq
                    codseq :=TADOQuery.ident_current('manifestodf01mun');
                    //
                    //
                    for N in M.nfeList.getDataList do
                    begin
                        C2.Param('@codmun').Value :=codseq ;
                        C2.Param('@chvnfe').Value :=N.chvNFE;
                        C2.Param('@vlrntf').Value :=N.vlrNtf;
                        C2.Param('@volpsob').Value :=N.volPsoB;
//                        C2.Param('@md2_codntf').Value :=N.codNtf ;
                        try
                            C2.Execute ;
                        except
                            if C.Connection.InTransaction then
                            begin
                                C.Connection.RollbackTrans;
                            end;
                            raise;
                        end;
                    end;
                end;

            except
                if C.Connection.InTransaction then
                begin
                    C.Connection.RollbackTrans;
                end;
                raise;
            end;
        end;

        //
        // condutores de veiculos
        C.CommandText :='';
        C.Parameters.Clear;
        C.AddCmd('declare @md3_codmdf int         ;set @md3_codmdf =?;');
        C.AddCmd('declare @md3_codvei smallint    ;set @md3_codvei =?;');
        C.AddCmd('declare @md3_codcdt smallint    ;set @md3_codcdt =?;');
        C.AddCmd('insert into manifestodf03cond(md3_codmdf ,          ');
        C.AddCmd('                              md3_codvei ,          ');
        C.AddCmd('                              md3_codcdt )          ');
        C.AddCmd('values                       (@md3_codmdf,          ');
        C.AddCmd('                              @md3_codvei,          ');
        C.AddCmd('                              @md3_codcdt);         ');
        //
        // params
        C.AddParamWithValue('@md3_codmdf', ftInteger, self.m_codseq) ;
        C.AddParamWithValue('@md3_codvei', ftSmallint, Self.m_codvei);
        C.AddParamWithValue('@md3_codcdt', ftSmallint, 0) ;

        for P in m_ModalRodo.condutores.Items do
        begin
            C.Param('@md3_codcdt').Value :=P.id ;
            try
                C.Execute ;
            except
                if C.Connection.InTransaction then
                begin
                    C.Connection.RollbackTrans;
                end;
                raise;
            end;
        end;

    finally
        //
        // commit trans
        if C.Connection.InTransaction then
        begin
            C.Connection.CommitTrans;
        end;
        C.Free ;
    end;
end;

procedure TCManifestoDF.cmdUpdate;
var
  sp: TADOStoredProc;
  C,C2: TADOCommand ;
var
  M: TCManifestodf01mun ;
  N: IManifestodf02nfe ;
  P: ICondutor ;
var
  codseq: Int32 ;
begin
    //
    // command geral
    C :=TADOCommand.NewADOCommand();
    try
        //
        // atualiza manifesto
        // respectivo para o modalidade rodoviário
        sp :=TADOStoredProc.NewADOStoredProc('sp_manifestodf00_add');
        try
            sp.AddParamWithValue('@codemp', ftSmallint, Self.m_codemp);
            sp.AddParamWithValue('@codufe', ftSmallint, Self.m_codufe);
            sp.AddParamWithValue('@tipamb', ftSmallint, Self.m_tipamb);
            sp.AddParamWithValue('@tpemit', ftSmallint, Self.m_tpemit);
            sp.AddParamWithValue('@tptransp', ftSmallint, Self.m_tptransp);
            sp.AddParamWithValue('@modal', ftSmallint, Self.m_modal);
            sp.AddParamWithValue('@tpemis', ftSmallint, Self.m_tpemis);
            sp.AddParamWithValue('@verproc', ftString, Self.m_verproc);
            sp.AddParamWithValue('@ufeini', ftString, Self.m_ufeini);
            sp.AddParamWithValue('@ufefim', ftString, Self.m_ufefim);
            sp.AddParamWithValue('@rntrc', ftString, Self.m_rntrc);
            sp.AddParamWithValue('@codvei', ftSmallint, Self.m_codvei);
            sp.AddParamWithValue('@codseq', ftInteger, Self.m_codseq);
            try
                //
                // begin trans
                if not C.Connection.InTransaction then
                begin
                    C.Connection.BeginTrans ;
                end;
                sp.ExecProc ;
            except
                if C.Connection.InTransaction then
                begin
                    C.Connection.RollbackTrans;
                end;
                raise;
            end;
        finally
            sp.Free ;
        end;

        //
        //...


    finally
        //
        // commit trans
        if C.Connection.InTransaction then
        begin
            C.Connection.CommitTrans;
        end;
        C.Free ;
    end;
end;

constructor TCManifestoDF.Create;
begin
    m_Municipios :=TCmanifestodf01munList.Create ;
    m_ModalRodo :=TCManifestodf04Rodo.Create ;
    m_MunDescarga :=TCManifestodf01MunDescarga.Create;
end;

destructor TCManifestoDF.Destroy;
begin
    //m_MunCarga.Destroy ;
    //m_ModalRodo.Destroy ;
    //m_MunDescarga.Destroy ;
    inherited;
end;


procedure TCManifestoDF.Edit;
begin
    State :=msEdit ;
    //
    // atualiza a view
end;

function TCManifestoDF.getChMDFE: string;
begin
    Result :=m_chmdfe;

end;

function TCManifestoDF.getCodMod: Int16;
begin
    Result :=m_codmod;

end;

function TCManifestoDF.getCodSeq: Int32;
begin
    Result :=m_codseq
    ;
end;

function TCManifestoDF.getCodUFe: Int16;
begin
    Result :=m_codufe
    ;
end;

function TCManifestoDF.getDHEmis: TDateTime;
begin
    Result :=m_dhemis
    ;
end;

function TCManifestoDF.getDHRecebto: TDatetime;
begin
    Result :=m_dhrecebto;

end;

function TCManifestoDF.getDigVal: string;
begin
    Result :=m_digval;

end;

function TCManifestoDF.getModal: Int16;
begin
    Result :=m_modal
    ;
end;

function TCManifestoDF.getModalRodo: TCManifestodf04Rodo;
begin
    Result :=m_ModalRodo
    ;
end;

function TCManifestoDF.getMotivo: string;
begin
    Result :=m_motivo
    ;
end;

function TCManifestoDF.getMunDescarga: TCManifestodf01MunDescarga;
begin
//    if m_MunDescarga =nil then
        //m_MunDescarga :=TCManifestodf01munList.Create ;
    Result :=m_MunDescarga ;
end;

function TCManifestoDF.getMunicipios: TCManifestodf01munList;
begin
    Result :=m_Municipios;

end;

function TCManifestoDF.getNumDoc: Int32;
begin
    Result :=m_numdoc
    ;
end;

function TCManifestoDF.getNumProt: string;
begin
    Result :=m_numprot ;

end;

function TCManifestoDF.getNumSer: Int16;
begin
    Result :=m_nserie;

end;

function TCManifestoDF.GetOnModelChanged: TModelChangedEvent;
begin
    Result :=m_OnModelChanged
    ;
end;

function TCManifestoDF.getRNTRC: string;
begin
    Result :=m_rntrc;

end;

function TCManifestoDF.getStateChange: TModelState;
begin
    Result :=m_StateChange
    ;
end;

function TCManifestoDF.getStatus: Int16;
begin
    Result :=m_codstt
    ;
end;

function TCManifestoDF.getTpAmb: Int16;
begin
    Result :=m_tipamb
    ;
end;

function TCManifestoDF.getTpEmis: Int16;
begin
    Result :=m_tpemis
    ;
end;

function TCManifestoDF.getTpEmit: Int16;
begin
    Result :=m_tpemit
    ;
end;

function TCManifestoDF.getTpTransp: Int16;
begin
    Result :=m_tptransp
    ;
end;

function TCManifestoDF.getUFeFim: string;
begin
    Result :=m_ufefim
    ;
end;

function TCManifestoDF.getUFeIni: string;
begin
    Result :=m_ufeini
    ;
end;

function TCManifestoDF.getVerApp: string;
begin
    Result :=m_verapp;

end;

function TCManifestoDF.getVerProc: string;
begin
    Result :=m_verproc;

end;

procedure TCManifestoDF.Inicialize;
begin
    m_StateChange :=msInactive ;
    m_codseq :=0;
    m_codemp :=1;
    m_codufe :=0;
    m_tipamb :=1;
    m_tpemit :=1;
    m_tptransp :=-1;
    m_codmod :=58;
    m_nserie :=1;
    m_numdoc :=0;
    m_modal :=0;
    m_dhemis :=0;
    m_tpemis :=0;
    m_procemi:=1;
    m_verproc:='';
    m_ufeini :='';
    m_ufefim :='';
    m_dhviagem :=0;
    m_indcnlvrd:=False;
    m_rntrc:='';
    m_codvei:=0;
    m_codstt :=0;
    m_motivo :='';
    m_xml :='';
    m_Municipios.clearItems ;
    m_ModalRodo.veiculo.Inicialize ;
    m_MunDescarga.nfeList.clearItems ;
end;

procedure TCManifestoDF.Insert;
begin
    Inicialize ;
    State :=msInsert ;
end;

function TCManifestoDF.isValid: Boolean;
begin
    Result :=False ;
    if m_Municipios.getDataList.Count = 0 then
        raise EMunCargaIsEmpty.Create('Nenhum município de carregamento/descarregamento vinculado ao manifesto!')
    else if m_ModalRodo.veiculo.id = 0 then
        raise EVeiculoIsEmpty.Create('Nenhum veículo vinculado ao manifesto!')
    else if m_ModalRodo.condutores.Items.Count = 0 then
        raise ECondutorIsEmpty.Create('Nenhum condutor vinculado ao veículo!');
//      raise EDocIsEmpty.Create('Nenhum documento fiscal (NFE) foi vinculado ao manifesto!');
    Result :=True ;
end;

function TCManifestoDF.Load: Boolean;
var
  F: TManifestoFilter;
begin
    F.codseq :=Self.m_codseq ;
    F.datini :=0;
    F.datfin :=0;
    F.status :=mfsNone;
    Result :=Self.cmdFind(F) ;
end;

procedure TCManifestoDF.loadCondutores;
var
  Q: TADOQuery ;
var
  C: ICondutor ;
  F: TCondutorFilter ;
begin
    //
    // carrega modal rodoviário
    if m_ModalRodo.veiculo.cmdFind(Self.m_codvei) then
    begin
        //
        // carrega os condutores
        Q :=TADOQuery.NewADOQuery() ;
        try
            Q.AddCmd('declare @codmdf int     ;set @codmdf =%d; ',[Self.m_codseq]);
            Q.AddCmd('declare @codvei smallint;set @codvei =%d; ',[Self.m_codvei]);
            Q.AddCmd('select md3_codcdt from manifestodf03cond  ');
            Q.AddCmd('where md3_codmdf =@codmdf                 ');
            Q.AddCmd('and   md3_codvei =@codvei                 ');
            Q.Open ;
            while not Q.Eof do
            begin
                F.codseq :=Q.Field('md3_codcdt').AsInteger ;
                C :=TCCondutor.New(F.codseq) ;
                C.cmdFind(F) ;
                m_ModalRodo.condutores.addNew(C) ;
                Q.Next ;
            end;
        finally
            Q.Free ;
        end;
    end;
end;

procedure TCManifestoDF.loadFromDataset(ds: TDataSet);
begin
    m_codseq :=ds.FieldByName('md0_codseq').AsInteger ;
    m_codemp :=ds.FieldByName('md0_codemp').AsInteger ;
    m_codufe :=ds.FieldByName('md0_codufe').AsInteger ;
    m_tipamb :=ds.FieldByName('md0_tipamb').AsInteger ;
    m_tpemit :=ds.FieldByName('md0_tpemit').AsInteger ;
    if ds.FieldByName('md0_tptransp').IsNull then
        m_tptransp :=-1
    else
        m_tptransp :=ds.FieldByName('md0_tptransp').AsInteger;
    m_codmod :=ds.FieldByName('md0_codmod').AsInteger ;
    m_nserie :=ds.FieldByName('md0_nserie').AsInteger ;
    m_numdoc :=ds.FieldByName('md0_numdoc').AsInteger ;
    m_modal :=ds.FieldByName('md0_modal').AsInteger ;
    m_dhemis :=ds.FieldByName('md0_dhemis').AsDateTime ;
    m_tpemis :=ds.FieldByName('md0_tpemis').AsInteger ;
    m_verproc  :=ds.FieldByName('md0_verproc').AsString ;
    m_ufeini :=ds.FieldByName('md0_ufeini').AsString ;
    m_ufefim :=ds.FieldByName('md0_ufefim').AsString ;
    m_dhviagem :=ds.FieldByName('md0_dhviagem').AsDateTime ;
    if ds.FieldByName('md0_indcnlvrd').IsNull then
        m_indcnlvrd :=False
    else
        m_indcnlvrd :=Boolean(ds.FieldByName('md0_indcnlvrd').AsInteger);
    m_rntrc  :=ds.FieldByName('md0_rntrc').AsString ;
    m_codvei :=ds.FieldByName('md0_codvei').AsInteger;
    m_codstt :=ds.FieldByName('md0_codstt').AsInteger;
    m_motivo :=ds.FieldByName('md0_motivo').AsString ;
    m_chmdfe :=ds.FieldByName('md0_chmdfe').AsString ;
    //
    //
    Self.loadMunDocs ;
    Self.loadCondutores;
end;

procedure TCManifestoDF.loadMunDocs;
var
  Q: TADOQuery ;
  M: TCManifestodf01mun;
  N: IManifestodf02nfe ;
var
  md1_codseq: TField ;
begin
    //
    // reset
    m_Municipios.clearItems ;
    m_MunDescarga.nfeList.clearItems;

    //
    // load municipios
    // carga/descarga
    Q :=TADOQuery.NewADOQuery ;
    try
        Q.AddCmd('declare @codmdf int; set @codmdf =%d;',[self.m_codseq]) ;
        Q.AddCmd('select  md1_codseq ,                 ');
        Q.AddCmd('        md1_codmdf ,                 ');
        Q.AddCmd('        md1_codmun ,                 ');
        Q.AddCmd('        md1_xmunic ,                 ');
        Q.AddCmd('        md1_tipmun ,                 ');
        Q.AddCmd('        md2_chvnfe ,                 ');
        Q.AddCmd('        md2_codbar ,                 ');
        Q.AddCmd('        md2_indree ,                 ');
//        Q.AddCmd('        md2_codntf ,                 ');
        Q.AddCmd('        md2_vlrntf ,                 ');
        Q.AddCmd('        md2_volpsob                  ');
        Q.AddCmd('from manifestodf01mun                ');
        Q.AddCmd('left join manifestodf02nfe on md2_codmun =md1_codseq');
        Q.AddCmd('where md1_codmdf =@codmdf            ');
        Q.AddCmd('order by md1_tipmun                  ');
        Q.Open ;
        md1_codseq :=Q.Field('md1_codseq') ;
        while not Q.Eof do
        begin
            //
            // mun carga
            if TManifestodf01munTyp(Q.Field('md1_tipmun').AsInteger) =mtCarga then
            begin
                m_Municipios.addNew(
                    TCManifestodf01mun.New( md1_codseq.AsInteger ,
                                            Q.Field('md1_codmun').AsInteger,
                                            Q.Field('md1_xmunic').AsString ,
                                            '',
                                            mtCarga )
                                  );
            end
            //
            // mun descarga
            else begin
                M :=m_Municipios.indexOf(md1_codseq.AsInteger) ;
                if M = nil then
                begin
                    M :=TCManifestodf01mun.New( md1_codseq.AsInteger ,
                                            Q.Field('md1_codmun').AsInteger,
                                            Q.Field('md1_xmunic').AsString ,
                                            '',
                                            mtDescarga );
                    m_Municipios.addNew(M) ;
                end;
                //
                // docs vinculados
                M.nfeList.addNew(
                    TCManifestodf02nfe.New(
                        Q.Field('md2_chvnfe').AsString,
                        Q.Field('md2_codbar').AsString,
                        Boolean(Q.Field('md2_indree').AsInteger),
//                        Q.Field('md2_codntf').AsInteger ,
                        Q.Field('md2_vlrntf').AsCurrency,
                        Q.Field('md2_volpsob').AsFloat )
                );
            end;
            Q.Next ;
        end;

    finally
        Q.Free ;
    end;
end;

function TCManifestoDF.Merge: TModelUpdateKind;
begin
    Result :=mukUnModify;
    if isValid then
    begin
        if Self.m_codseq > 0 then
        begin
            Self.cmdUpdate ;
            //
            // sinaliza update com sucesso
            Result :=mukModify;
        end
        else begin
            Self.cmdInsert;
            //
            // sinaliza insert com sucesso
            Result :=mukInsert;
        end;
        //
        // muda o estado para leitura
        State :=msBrowse ;
    end;
end;

procedure TCManifestoDF.setCodUF(Value: Int16);
begin
    m_codufe :=Value;

end;

procedure TCManifestoDF.setDHEmis(Value: TDateTime);
begin
    m_dhemis :=Value
    ;
end;

procedure TCManifestoDF.setNumDoc(Value: Int32);
begin
    m_numdoc :=Value
    ;
end;

procedure TCManifestoDF.SetOnModelChanged(Value: TModelChangedEvent);
begin
    m_OnModelChanged :=Value
    ;
end;

procedure TCManifestoDF.setRet(const aCodStt: Int16; const aMotivo,
  ret_verapp, ret_numreci, ret_numprot, ret_digval: string;
  const ret_dhreceb: Tdatetime);
var
  C: TADOCommand ;
begin
    //
    //
    m_codstt :=aCodStt ;
    m_motivo :=Copy(aMotivo, 1, 250) ;
    m_verapp :=ret_verapp ;
    m_numreci:=ret_numreci;
    m_numprot:=ret_numprot;
    m_digval :=ret_digval ;
    m_dhrecebto:=ret_dhreceb;

    //
    //
    C :=TADOCommand.NewADOCommand() ;
    try
        C.AddCmd('declare @codseq int       ;set @codseq  =%d ;',[Self.m_codseq]);
        C.AddCmd('declare @dhreceb datetime ;set @dhreceb =?  ;');
        C.AddCmd('update manifestodf00 set                     ');
        C.AddCmd('  md0_codstt  =%d,                           ',[Self.m_codstt]);
        C.AddCmd('  md0_motivo  =%s,                           ',[C.FStr(Self.m_motivo)]);
        C.AddCmd('  md0_verapp  =%s,                           ',[C.FStr(Self.m_verapp)]);
        C.AddCmd('  md0_numreci =%s,                           ',[C.FStr(Self.m_numreci)]);
        C.AddCmd('  md0_numprot =%s,                           ',[C.FStr(Self.m_numprot)]);
        C.AddCmd('  md0_digval  =%s,                           ',[C.FStr(Self.m_digval)]);
        C.AddCmd('  md0_dhreceb =@dhreceb                      ',[C.FStr(Self.m_numprot)]);
        C.AddCmd('where md0_codseq =@codseq                    ');
        //
        //
        C.AddParamWithValue('@dhreceb', ftDateTime, m_dhrecebto);
        C.Execute ;
    finally
        C.Free ;
    end;
end;

procedure TCManifestoDF.setRNTRC(Value: string);
begin
    m_rntrc :=Value;

end;

procedure TCManifestoDF.setStateChange(Value: TModelState);
begin
    m_StateChange :=Value ;
     //
    // atualiza a view
    if Assigned(OnModelChanged)then
    begin
        OnModelChanged
    end;
end;

procedure TCManifestoDF.setTpAmb(Value: Int16);
begin
    m_tipamb :=Value
    ;
end;

procedure TCManifestoDF.setTpEmis(Value: Int16);
begin
    m_tpemis :=Value
    ;
end;

procedure TCManifestoDF.setTpEmit(Value: Int16);
begin
    m_tpemit :=Value
    ;
end;

procedure TCManifestoDF.setTpTransp(Value: Int16);
begin
    m_tptransp :=Value
    ;
end;

procedure TCManifestoDF.setUFeFim(Value: string);
begin
    m_ufefim :=Value
    ;
end;

procedure TCManifestoDF.setUFeIni(Value: string);
begin
    m_ufeini :=Value
    ;
end;

procedure TCManifestoDF.setXML(const aCodStt: Int16;
  const aMotivo, aChv, aXML: string);
var
  C: TADOCommand ;
  P: TParameter ;
  S: TStreamWriter;
begin
    //
    //
    m_codstt:=aCodStt;
    m_motivo:=aMotivo;
    m_chmdfe:=aChv;
    m_xml   :=aXML;

    C :=TADOCommand.NewADOCommand() ;
    try
        C.AddCmd('update manifestodf00 set   ');
        if Self.m_xml <> '' then
        begin
            Self.m_motivo :=Copy(Self.m_motivo, 1, 250) ;
            C.AddCmd('  md0_codstt  =%d,    ',[Self.m_codstt]);
            C.AddCmd('  md0_motivo  =%s,    ',[C.FStr(Self.m_motivo)]);
            C.AddCmd('  md0_chmdfe  =%s,    ',[C.FStr(Self.m_chmdfe)]);
            C.AddCmd('  md0_xml     =?      ');

            S :=TStreamWriter.Create(TMemoryStream.Create);
            S.Write(Self.m_xml);
        end
        else begin
            C.AddCmd('  md0_codstt  =0,     ');
            C.AddCmd('  md0_motivo  =null,  ');
            C.AddCmd('  md0_chvnfe  =null,  ');
            C.AddCmd('  md0_xml     =null   ');
        end;

        C.AddCmd('where md0_codseq =%d  ',[Self.m_codseq]);

        if Assigned(S) then
        begin
            P :=C.AddParamWithValue('@md0_xml', ftMemo, Null) ;
            P.LoadFromStream(S.BaseStream, ftMemo);
        end;

        C.Execute ;

    finally
        C.Free ;
        if Assigned(S) then
        begin
            S.BaseStream.Free ;
            S.Free;
        end;
    end;
end;

{ TMunFilter }

constructor TMunFilter.Create(const aCodMun: Int32; aUfeMun: string);
begin
    codmun :=aCodMun ;
    ufemun :=aUfeMun ;
    nommun :='';
end;


{ TCmanifestodf01mun }

constructor TCmanifestodf01mun.Create(aTipMun: TManifestodf01munTyp);
begin
    inherited Create;
    m_tipmun :=aTipMun ;
    if m_tipmun =mtDescarga then
    begin
        m_NFEList :=TCManifestodf02nfeList.Create(Self) ;
    end;
end;

function TCmanifestodf01mun.getCodMun: Int32;
begin
    Result :=m_codmun
    ;
end;

function TCmanifestodf01mun.getNomMun: string;
begin
    Result :=m_xmunic
    ;
end;

function TCmanifestodf01mun.getTipMun: TManifestodf01munTyp;
begin
    Result :=m_tipmun
    ;
end;

function TCmanifestodf01mun.getUFeMun: string;
begin
    Result :=m_ufemun;

end;

class function TCmanifestodf01mun.New(const codseq, codmun: Int32; const xmunic,
  ufemun: string; const tipmun: TManifestodf01munTyp): TCmanifestodf01mun;
begin
    Result :=TCmanifestodf01mun.Create(tipmun) ;
    Result.m_codseq :=codseq ;
    Result.m_codmun :=codmun ;
    Result.m_xmunic :=xmunic ;
    Result.m_ufemun :=ufemun ;
end;

procedure TCmanifestodf01mun.setCodMun(Value: Int32);
begin
    m_codmun :=Value
    ;
end;

procedure TCmanifestodf01mun.setNomMun(Value: string);
begin
    m_xmunic :=Value
    ;
end;


procedure TCmanifestodf01mun.setTipMun(Value: TManifestodf01munTyp);
begin
    m_tipmun :=Value
    ;
end;

procedure TCmanifestodf01mun.setUFeMun(Value: string);
begin
    m_ufemun :=Value;

end;

{ TCmanifestodf01munList }

function TCmanifestodf01munList.addNew(
  aMun: TCManifestodf01mun): TCManifestodf01mun ;
begin
    if aMun = nil then
        Result :=TCmanifestodf01mun.New(0,0,'','',mtCarga)
    else
        Result :=aMun;
    m_DataList.Add(Result);
end;

procedure TCmanifestodf01munList.clearItems;
begin
    m_DataList.Clear;

end;

constructor TCmanifestodf01munList.Create;
begin
    m_DataList :=TObjectList<TCManifestodf01mun>.Create(True) ;

end;

function TCmanifestodf01munList.getDataList: TObjectList<TCManifestodf01mun> ;
begin
    Result :=m_DataList
    ;
end;

function TCmanifestodf01munList.indexOf(
  const codseq: Int32): TCManifestodf01mun;
var
  found: Boolean ;
begin
    found :=False ;
    for Result in m_DataList do
    begin
        if Result.m_codseq =codseq then
        begin
            found :=True ;
            Break;
        end;
    end;
    if not found then
    begin
        Result :=nil ;
    end;
end;

function TCmanifestodf01munList.indexOf(const codmun: Int32;
  const tipmun: TManifestodf01munTyp): TCManifestodf01mun;
var
  found: Boolean ;
begin
    found :=False ;
    for Result in m_DataList do
    begin
        if(Result.m_codmun =codmun)and(Result.m_tipmun =tipmun) then
        begin
            found :=True ;
            Break;
        end;
    end;
    if not found then
    begin
        Result :=nil ;
    end;
end;

{ TCManifestodf04Rodo }

constructor TCManifestodf04Rodo.Create;
begin
    inherited Create;
    m_Veiculo :=TCVeiculo.Create ;
    m_CondutorList :=TCCondutorList.Create(Self);
end;

destructor TCManifestodf04Rodo.Destroy;
begin

  inherited;
end;

{ TCManifestodf02nfe }

function TCManifestodf02nfe.getChvNFE: string;
begin
    Result :=m_chvnfe;

end;

function TCManifestodf02nfe.getCodBar: string;
begin
    Result :=m_codbar;

end;

function TCManifestodf02nfe.getState: TModelState;
begin
    Result :=m_State ;

end;

function TCManifestodf02nfe.getVlrNtf: Currency;
begin
    Result :=m_vlrntf;

end;

function TCManifestodf02nfe.getVolPsoB: Double;
begin
    Result :=m_volpsob;

end;

class function TCManifestodf02nfe.New(const chvnfe, codbar: string;
  const indree: Boolean;
  const vlrntf: Currency; const volpsob: Double): IManifestodf02nfe;
begin
    Result :=TCManifestodf02nfe.Create ;
    Result.chvNFE :=chvnfe ;
    Result.codBarras :=codbar;
    Result.vlrNtf :=vlrntf ;
    Result.volPsoB :=volpsob ;
end;

procedure TCManifestodf02nfe.setChvNFE(Value: string);
begin
    m_chvnfe :=Value;

end;

procedure TCManifestodf02nfe.setCodBar(Value: string);
begin
    m_codbar :=Value ;
end;

procedure TCManifestodf02nfe.setVlrNtf(Value: Currency);
begin
    m_vlrntf :=Value;

end;

procedure TCManifestodf02nfe.setVolPsoB(Value: Double);
begin
    m_volpsob :=Value;

end;

{ TCManifestodf02nfeList }

function TCManifestodf02nfeList.addNew(
  aNFE: IManifestodf02nfe): IManifestodf02nfe;
begin
    if aNFE = nil then
        Result :=TCManifestodf02nfe.New('','',False,0,0)
    else
        Result :=aNFE;
    m_DataList.Add(Result) ;
end;

procedure TCManifestodf02nfeList.clearItems;
begin
    if Assigned(m_DataList) then
        m_DataList.Clear;

end;

constructor TCManifestodf02nfeList.Create(aController: IInterface);
begin
    inherited Create(aController);
    m_DataList :=TList<IManifestodf02nfe>.Create ;
end;

destructor TCManifestodf02nfeList.Destroy;
begin

    inherited;
end;

function TCManifestodf02nfeList.getDataList: TList<IManifestodf02nfe>;
begin
    Result :=m_DataList;

end;

function TCManifestodf02nfeList.indexOf(const aIndex: Int32): IManifestodf02nfe;
begin
    if(aIndex > -1) and  (aIndex < m_DataList.Count -1) then
        Result :=m_DataList.Items[aIndex]
    else
        Result :=nil ;
end;

function TCManifestodf02nfeList.indexOf(const aChv: string): IManifestodf02nfe;
begin

end;

{ TCManifestodf01MunDescarga }

constructor TCManifestodf01MunDescarga.Create;
begin
    inherited Create;
    m_Mun :=TCManifestodf01mun.Create(mtDescarga) ;
    m_NFEList :=TCManifestodf02nfeList.Create(Self) ;
end;

destructor TCManifestodf01MunDescarga.Destroy;
begin

    inherited;
end;

{ TCManifestoDFList }

function TCManifestoDFList.addNew(aItem: IManifestoDF): IManifestoDF ;
begin
    if aItem = nil then
        Result :=TCManifestoDF.Create ;
    m_DataList.Add(Result);
end;

procedure TCManifestoDFList.clearItems;
begin
    m_DataList.Clear ;

end;

constructor TCManifestoDFList.Create(aController: IInterface);
begin
    inherited Create(aController);
    m_DataList :=TList<IManifestoDF>.Create ;

end;

function TCManifestoDFList.getItems: TList<IManifestoDF>;
begin
    Result :=m_DataList ;
end;

function TCManifestoDFList.Load(const aFilter: TManifestoFilter): Boolean;
var
  ds: TDataSet ;
  I: IManifestoDF;
begin
    ds :=TCManifestoDF.CLoad(aFilter) ;
    try
        Self.clearItems ;
        Result :=not ds.IsEmpty;
        while not ds.Eof do
        begin
            I :=Self.addNew(nil) ;
            I.loadFromDataset(ds);
            ds.Next ;
        end;
    finally
        TADOQuery(ds).Free ;
    end;
end;

{ TManifestoFilter }

constructor TManifestoFilter.Create(const codseq: Int32);
begin
    Self.codseq :=codseq ;
    Self.datini :=0;
    Self.datfin :=0;
    Self.status :=mfsNone;
end;

end.
