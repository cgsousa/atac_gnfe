unit uCondutor;

interface

uses
  Classes, SysUtils, DB, ADODB,
  Generics.Collections,
  uIntf, uadodb ;

type
  //
  //
  EBuscaIsEmpty = class(Exception);
  ECPFCNPJIsEmpty = class(Exception);
  ENomeIsEmpty = class(Exception);
  ERNTRCIsEmpty = class(Exception);
  EIEIsEmpty = class(Exception);
  EUFIsEmpty = class(Exception);

  TCondutorFilter = record
    codseq: Int16 ;
    cpfcnpj: string;
    xnome: string ;
  end;

  ICondutor = interface(IModel)
    function GetOnModelChanged: TModelChangedEvent;
    procedure SetOnModelChanged(Value: TModelChangedEvent);
    property OnModelChanged: TModelChangedEvent read GetOnModelChanged
      write SetOnModelChanged;
    function getStateChange: TModelState ;
    procedure setStateChange(Value: TModelState) ;
    property State: TModelState read getStateChange write setStateChange;

    function getCodSeq: Int16 ;
    procedure setCodSeq(Value: Int16) ;
    property id: Int16 read getCodSeq write setCodSeq;

    function getTipPes: Int16 ;
    procedure setTipPes(Value: Int16) ;
    property tpPessoa: Int16 read getTipPes write setTipPes ;

    function getCPFCNPJ: string ;
    procedure setCPFCNPJ(Value: string) ;
    property CPFCNPJ: string read getCPFCNPJ write setCPFCNPJ;

    function getNome: string ;
    procedure setNome(Value: string) ;
    property Nome: string read getNome write setNome;

    function getRNTRC: string ;
    procedure setRNTRC(Value: string) ;
    property RNTRC: string read getRNTRC write setRNTRC;

    function getIE: string ;
    procedure setIE(Value: string) ;
    property IE: string read getIE write setIE;

    function getUF: string ;
    procedure setUF(Value: string) ;
    property UF: string read getUF write setUF;

    function getTpProp: Int16 ;
    procedure setTpProp(Value: Int16) ;
    property tpProp: Int16 read getTpProp write setTpProp ;

    function cmdFind(const aFilter: TCondutorFilter): Boolean ;
    procedure cmdInsert ;
    procedure cmdUpdate ;
    procedure cmdDelete ;

    procedure Insert ;
    procedure Edit ;

    function Merge(): TModelUpdateKind;
  end;

  TCCondutor = class(TInterfacedObject, ICondutor)
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
    m_codseq: Int16 ;
    m_tippes: Int16 ;
    m_cpfcnpj: string;
    m_xnome: string ;
    m_rntrc: string ;
    m_ie: string ;
    m_uf: string ;
    m_tpprop: Int16;
    m_status: Int16;

    function getCodSeq: Int16 ;
    procedure setCodSeq(Value: Int16) ;

    function getTipPes: Int16 ;
    procedure setTipPes(Value: Int16) ;

    function getCPFCNPJ: string ;
    procedure setCPFCNPJ(Value: string) ;

    function getNome: string ;
    procedure setNome(Value: string) ;

    function getRNTRC: string ;
    procedure setRNTRC(Value: string) ;

    function getIE: string ;
    procedure setIE(Value: string) ;

    function getUF: string ;
    procedure setUF(Value: string) ;

    function getTpProp: Int16 ;
    procedure setTpProp(Value: Int16) ;

  public
    property OnModelChanged: TModelChangedEvent read GetOnModelChanged
      write SetOnModelChanged;
    property State: TModelState read getStateChange write setStateChange;
    procedure Inicialize;
    function cmdFind(const aFilter: TCondutorFilter): Boolean ;
    function isValid: Boolean ;
    procedure Insert;
    procedure Edit ;
    function Merge(): TModelUpdateKind;

  public
    property id: Int16 read getCodSeq write setCodSeq;
    property tpPessoa: Int16 read getTipPes write setTipPes ;
    property CPFCNPJ: string read getCPFCNPJ write setCPFCNPJ;
    property Nome: string read getNome write setNome;
    property RNTRC: string read getRNTRC write setRNTRC;
    property IE: string read getIE write setIE;
    property UF: string read getUF write setUF;
    property tpProp: Int16 read getTpProp write setTpProp ;
    constructor Create ;
    class function CLoad(const aFilter: TCondutorFilter): TADOQuery ;
    class function New(const codseq: Int16): ICondutor;
  end;

  //
  // lista de condutores
  ICondutorList = interface (IDataList<ICondutor>)
//    function addNew(aCondutor: ICondutor): ICondutor ;
//    function indexOf(const id: Int32): ICondutor ;
//    procedure clearItems ;
  end;

  TCCondutorList = class(TAggregatedObject, ICondutorList)
  private
    m_DataList: TList<ICondutor> ;
    function getItems: TList<ICondutor> ;
  public
    property Items: TList<ICondutor> read getItems ;
    constructor Create(aController: IInterface);
    destructor Destroy; override ;
    function addNew(aCondutor: ICondutor): ICondutor ;
    function indexOf(const id: Int32): ICondutor;
    procedure clearItems ;
    procedure Load;
  end;





implementation

uses udbconst ;

{ TCCondutor }

class function TCCondutor.CLoad(const aFilter: TCondutorFilter): TADOQuery;
begin
    Result :=TADOQuery.NewADOQuery();
    Result.AddCmd('declare @codseq smallint; set @codseq =%d;',[aFilter.codseq]);
    Result.AddCmd('declare @xxnome varchar(30);              ');
    Result.AddCmd('select *from cadcondutor');
    if aFilter.codseq > 0 then
    begin
        Result.AddCmd('where cdt_codseq =@codseq');
    end;
    Result.AddCmd('order by cdt_xnome                       ');
    Result.Open ;
end;

procedure TCCondutor.cmdDelete;
begin

end;

function TCCondutor.cmdFind(const aFilter: TCondutorFilter): Boolean;
var
  Q: TADOQuery ;
begin
    Result :=False ;
    //
    //
    Q :=TCCondutor.CLoad(aFilter) ;

    try
        if Q.IsEmpty then
        begin
            if aFilter.codseq > 0 then
                raise EBuscaIsEmpty.CreateFmt(SNenhumID,['CONDUTOR',aFilter.codseq])
            else
                raise EBuscaIsEmpty.Create(SNenhumRecord);
        end
        else
            Result :=True ;

        if Result then
        begin
            m_codseq :=Q.Field('cdt_codseq').AsInteger;
            m_cpfcnpj :=Q.Field('cdt_cpfcnpj').AsString;
            m_xnome :=Q.Field('cdt_xnome').AsString;
            m_rntrc :=Q.Field('cdt_rntrc').AsString;
            m_ie :=Q.Field('cdt_ie').AsString;
            m_uf :=Q.Field('cdt_uf').AsString;
            m_status :=Q.Field('cdt_status').AsInteger;
            State :=msBrowse ;
        end
        else
            Self.Inicialize
            ;
    finally
        Q.Free ;
    end;
end;

procedure TCCondutor.cmdInsert;
var
  C: TADOCommand ;
begin
    C :=TADOCommand.NewADOCommand() ;
    try
        C.AddCmd('declare @cdt_tippes smallint    ;set @cdt_tippes  =%d;',[self.m_tippes          ]);
        C.AddCmd('declare @cdt_cpfcnpj varchar(14);set @cdt_cpfcnpj =%s;',[C.FStr(self.m_cpfcnpj) ]);
        C.AddCmd('declare @cdt_xnome  varchar(50) ;set @cdt_xnome   =%s;',[C.FStr(self.m_xnome)   ]);
        C.AddCmd('declare @cdt_tpprop smallint    ;                     ');
        C.AddCmd('declare @cdt_rntrc  varchar(8)  ;                     ');
        C.AddCmd('declare @cdt_ie     varchar(12) ;                     ');
        C.AddCmd('declare @cdt_uf     char(2)     ;                     ');
        if Self.m_tpprop > -1 then
        begin
          C.AddCmd('set @cdt_tpprop =%d;',[self.m_tpprop        ]);
          C.AddCmd('set @cdt_rntrc  =%s;',[C.FStr(self.m_rntrc) ]);
          C.AddCmd('set @cdt_ie     =%s;',[C.FStr(self.m_ie)    ]);
          C.AddCmd('set @cdt_uf     =%s;',[C.FStr(self.m_uf)    ]);
        end;
        C.AddCmd('declare @cdt_status smallint   ;set @cdt_status   =%d;',[self.m_status         ]);
        C.AddCmd('insert into cadcondutor(cdt_tippes  ,                 ');
        C.AddCmd('                        cdt_cpfcnpj,                  ');
        C.AddCmd('                        cdt_xnome,                    ');
        C.AddCmd('                        cdt_tpprop,                   ');
        C.AddCmd('                        cdt_rntrc,                    ');
        C.AddCmd('                        cdt_ie,                       ');
        C.AddCmd('                        cdt_uf,                       ');
        C.AddCmd('                        cdt_status)                   ');
        C.AddCmd('values                 (@cdt_tippes  ,                ');
        C.AddCmd('                        @cdt_cpfcnpj,                 ');
        C.AddCmd('                        @cdt_xnome,                   ');
        C.AddCmd('                        @cdt_tpprop,                  ');
        C.AddCmd('                        @cdt_rntrc,                   ');
        C.AddCmd('                        @cdt_ie,                      ');
        C.AddCmd('                        @cdt_uf,                      ');
        C.AddCmd('                        @cdt_status)                  ');
        try
            //
            // start uma transação, caso não tenha!
            if not C.Connection.InTransaction then
                C.Connection.BeginTrans ;

            //
            // exec o insert
            C.Execute ;

            //
            // obtem o novo id
            Self.m_codseq :=TADOQuery.ident_current('cadcondutor');

            //
            //
            C.Connection.CommitTrans ;

        except
            if C.Connection.InTransaction then
                C.Connection.RollbackTrans ;
            raise;
        end;
    finally
        C.Free ;
    end;
end;

procedure TCCondutor.cmdUpdate;
begin

end;

constructor TCCondutor.Create;
begin
    Inicialize
    ;
end;

procedure TCCondutor.Edit;
begin
    State :=msEdit ;
    //
    // atualiza a view
end;

function TCCondutor.getCodSeq: Int16;
begin
    Result :=m_codseq
    ;
end;

function TCCondutor.getCPFCNPJ: string;
begin
    Result :=m_cpfcnpj
    ;
end;

function TCCondutor.getIE: string;
begin
    Result :=m_ie
    ;
end;

function TCCondutor.getNome: string;
begin
    Result :=m_xnome
    ;
end;

function TCCondutor.GetOnModelChanged: TModelChangedEvent;
begin
    Result :=m_OnModelChanged
    ;
end;

function TCCondutor.getRNTRC: string;
begin
    Result :=m_rntrc
    ;
end;

function TCCondutor.getStateChange: TModelState;
begin
    Result :=m_StateChange
    ;
end;

function TCCondutor.getTipPes: Int16;
begin
    Result :=m_tippes
    ;
end;

function TCCondutor.getTpProp: Int16;
begin
    Result :=m_tpprop
    ;
end;

function TCCondutor.getUF: string;
begin
    Result :=m_uf
    ;
end;

procedure TCCondutor.Inicialize;
begin
    m_StateChange :=msInactive ;
    m_codseq :=0;
    m_tippes :=0;
    m_cpfcnpj :='';
    m_xnome :='';
    m_rntrc :='';
    m_ie :='';
    m_uf :='';
    m_tpprop :=-1;
    m_status :=0;
end;

procedure TCCondutor.Insert;
begin
    Inicialize ;
    State :=msInsert ;
end;

function TCCondutor.isValid: Boolean;
begin
    Result :=False ;
    if m_cpfcnpj = EmptyStr then
        raise ECPFCNPJIsEmpty.Create('O CPF/CNPJ ser informado!')
    else if m_xnome = EmptyStr then
        raise ENomeIsEmpty.Create('O Nome deve ser informado!')
    else begin
        if m_tpprop > -1 then
        begin
            if m_rntrc = EmptyStr then
                raise ERNTRCIsEmpty.Create('O RNTRC ser informado!')
            else if m_ie = EmptyStr then
                raise ENomeIsEmpty.Create('A IE deve ser informada!')
            else if Self.m_uf = EmptyStr then
                raise EUFIsEmpty.Create('A UF deve ser informada!');
        end;
    end;
    Result :=True ;
end;

function TCCondutor.Merge(): TModelUpdateKind;
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

class function TCCondutor.New(const codseq: Int16): ICondutor;
begin
    Result :=TCCondutor.Create ;
    Result.id :=codseq ;

end;

procedure TCCondutor.setCodSeq(Value: Int16);
begin
    m_codseq :=Value;

end;

procedure TCCondutor.setCPFCNPJ(Value: string);
begin
    m_cpfcnpj :=Value
    ;
end;

procedure TCCondutor.setIE(Value: string);
begin
    m_ie :=Value
    ;
end;

procedure TCCondutor.setNome(Value: string);
begin
    m_xnome :=Value
    ;
end;

procedure TCCondutor.SetOnModelChanged(Value: TModelChangedEvent);
begin
    m_OnModelChanged :=Value
    ;
end;

procedure TCCondutor.setRNTRC(Value: string);
begin
    m_rntrc :=Value
    ;
end;

procedure TCCondutor.setStateChange(Value: TModelState);
begin
    m_StateChange :=Value ;
    //
    // atualiza a view
    if Assigned(OnModelChanged)then
    begin
        OnModelChanged
    end;
end;

procedure TCCondutor.setTipPes(Value: Int16);
begin
    m_tippes :=Value
    ;
end;

procedure TCCondutor.setTpProp(Value: Int16);
begin
    m_tpprop :=Value
    ;
end;

procedure TCCondutor.setUF(Value: string);
begin
    m_uf :=Value
    ;
end;

{ TCCondutorList }

function TCCondutorList.addNew(aCondutor: ICondutor): ICondutor ;
begin
    if aCondutor = nil then
        Result :=TCCondutor.Create
    else
        Result :=aCondutor;
    m_DataList.Add(Result) ;
end;

procedure TCCondutorList.clearItems;
begin
    m_DataList.Clear;

end;

constructor TCCondutorList.Create(aController: IInterface);
begin
    inherited Create(aController);
    m_DataList :=TList<ICondutor>.Create ;

end;

destructor TCCondutorList.Destroy;
begin

    inherited Destroy;
end;

function TCCondutorList.getItems: TList<ICondutor>;
begin
    Result :=m_DataList;

end;

function TCCondutorList.indexOf(const id: Int32): ICondutor;
var
  I: ICondutor ;
begin
    Result :=nil;
    for I in Self.Items do
    begin
        if I.id =id then
        begin
            Result :=I ;
            Break ;
        end;
    end;
end;

procedure TCCondutorList.Load;
var
  F: TCondutorFilter ;
  Q: TADOQuery ;
  I: ICondutor;
begin
    F.codseq :=0;
    Q :=TCCondutor.CLoad(F) ;
    try
        while not Q.Eof do
        begin
            I :=Self.addNew(nil) ;
            I.id :=Q.Field('cdt_codseq').AsInteger;
            I.CPFCNPJ :=Q.Field('cdt_cpfcnpj').AsString;
            I.Nome :=Q.Field('cdt_xnome').AsString;
            I.RNTRC:=Q.Field('cdt_rntrc').AsString;
            I.IE :=Q.Field('cdt_ie').AsString;
            I.UF :=Q.Field('cdt_uf').AsString;
            Q.Next ;
        end ;
    finally
        Q.Free ;
    end;
end;

end.
