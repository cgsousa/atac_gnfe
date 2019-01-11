unit uVeiculo;

interface

uses
  Classes, SysUtils, DB,
  Generics.Collections,
  uIntf;

type
  //
  //
  EBuscaIsEmpty = class(Exception);
  EPlacaIsEmpty = class(Exception);
  ETaraIsEmpty = class(Exception);
//  ECapKgIsEmpty = class(Exception);
//  ECapM3IsEmpty = class(Exception);
//  ECapKgIsEmpty = class(Exception);
  ETipRodIsEmpty = class(Exception);
  ETipCarIsEmpty = class(Exception);
  EUFIsEmpty = class(Exception);

  //
  //

  IVeiculo = interface(IModel)
    ['{81DA201E-31F4-40F6-B954-5ED6E8D7AEE4}']
    function GetOnModelChanged: TModelChangedEvent;
    procedure SetOnModelChanged(Value: TModelChangedEvent);
    property OnModelChanged: TModelChangedEvent read GetOnModelChanged
      write SetOnModelChanged;
    function getStateChange: TModelState ;
    procedure setStateChange(Value: TModelState) ;
    property State: TModelState read getStateChange write setStateChange;

    function getCodSeq: Int16 ;
    property id: Int16 read getCodSeq ;

    function getPlaca: string ;
    procedure setPlaca(Value: string) ;
    property placa: string read getPlaca write setPlaca;

    function getRenavam: string ;
    procedure setRenavam(Value: string) ;
    property RENAVAM: string read getRenavam write setRenavam;

    function getTara: Int16 ;
    procedure setTara(Value: Int16) ;
    property tara: Int16 read getTara write setTara;

    function getCapKg: Int16 ;
    procedure setCapKg(Value: Int16) ;
    property capacidadeKg: Int16 read getCapKg write setCapKg;

    function getCapM3: Int16 ;
    procedure setCapM3(Value: Int16) ;
    property capacidadeM3: Int16 read getCapM3 write setCapM3;

    function getTipRod: Int16 ;
    procedure setTipRod(Value: Int16) ;
    property tipRodado: Int16 read getTipRod write setTipRod;

    function getTipCar: Int16 ;
    procedure setTipCar(Value: Int16) ;
    property tipCarroceria: Int16 read getTipCar write setTipCar;

    function getUFeLic: string ;
    procedure setUFeLic(Value: string) ;
    property ufLicenca: string read getUFeLic write setUFeLic;

    function getCodProp: Int16 ;
    procedure setCodProp(Value: Int16) ;
    property idProprietario: Int16 read getCodProp write setCodProp;

    function getTipProp: Int16 ;
    procedure setTipProp(Value: Int16) ;
    property tpProprietario: Int16 read getTipProp write setTipProp;

    function getStatus: Int16 ;
    property Status: Int16 read getStatus ;

    function cmdFind(const codseq: Int16 =0): Boolean ;
    procedure cmdInsert ;
    procedure cmdUpdate ;
    procedure cmdDelete ;

    procedure Insert ;
    procedure Edit ;

    function Merge(): TModelUpdateKind;
  end;

  TCVeiculo = class(TInterfacedObject, IVeiculo)
  private
    m_OnModelChanged: TModelChangedEvent;
    m_StateChange: TModelState ;
    //m_infCdt: TList<TCCondutor>;
    procedure cmdInsert ;
    procedure cmdUpdate ;
    procedure cmdDelete ;
    function GetOnModelChanged: TModelChangedEvent;
    procedure SetOnModelChanged(Value: TModelChangedEvent);
    function getStateChange: TModelState ;
    procedure setStateChange(Value: TModelState) ;
  private
    m_codseq: Int16 ;
    m_placa: string ;
    m_renavam: string;
    m_tara: Int16 ;
    m_capkg: Int16 ;
    m_capm3: Int16 ;
    m_tiprod: Int16 ; //tipo rodado
    m_tipcar: Int16 ; //tipo carroceria
    m_ufelic: string; //UF em que veículo está licenciado
    m_cdprop: Int16 ; //propietário
    m_tpprop: Int16 ;
    m_status: Int16 ;

    function getCodSeq: Int16 ;

    function getPlaca: string ;
    procedure setPlaca(Value: string) ;

    function getRenavam: string ;
    procedure setRenavam(Value: string) ;

    function getTara: Int16 ;
    procedure setTara(Value: Int16) ;

    function getCapKg: Int16 ;
    procedure setCapKg(Value: Int16) ;

    function getCapM3: Int16 ;
    procedure setCapM3(Value: Int16) ;

    function getTipRod: Int16 ;
    procedure setTipRod(Value: Int16) ;

    function getTipCar: Int16 ;
    procedure setTipCar(Value: Int16) ;

    function getUFeLic: string ;
    procedure setUFeLic(Value: string) ;

    function getCodProp: Int16 ;
    procedure setCodProp(Value: Int16) ;

    function getTipProp: Int16 ;
    procedure setTipProp(Value: Int16) ;

    function getStatus: Int16 ;

  public
    property State: TModelState read getStateChange write setStateChange;
    property OnModelChanged: TModelChangedEvent read GetOnModelChanged
      write SetOnModelChanged;
    procedure Inicialize;
    function cmdFind(const codseq: Int16 =0): Boolean ;
    function isValid: Boolean ;
    procedure Insert;
    procedure Edit ;
    function Merge(): TModelUpdateKind;

  public
    property id: Int16 read getCodSeq ;
    property placa: string read getPlaca write setPlaca;
    property RENAVAM: string read getRenavam write setRenavam;
    property tara: Int16 read getTara write setTara;
    property capacidadeKg: Int16 read getCapKg write setCapKg;
    property capacidadeM3: Int16 read getCapM3 write setCapM3;
    property tipRodado: Int16 read getTipRod write setTipRod;
    property tipCarroceria: Int16 read getTipCar write setTipCar;
    property ufLicenca: string read getUFeLic write setUFeLic;
    property idProprietario: Int16 read getCodProp write setCodProp;
    property tpProprietario: Int16 read getTipProp write setTipProp;
    property Status: Int16 read getStatus ;
    //property infCondutor: TList<TCCondutor> read m_infCdt write m_infCdt;

    constructor Create ;
    //destructor Destroy; override ;
    procedure loadFromDataset(ds: TDataSet);
    class function CLoad(const codseq: Int32): TDataSet ;
  end;



function tpRodadoToStr(const tprod: smallint): string ;
function tpCarroceriaToStr(const tpcar: smallint): string ;


implementation

uses uadodb ;

function tpRodadoToStr(const tprod: smallint): string ;
begin
    case tprod of
        0: Result :='01 - Truck';
        1: Result :='02 - Toco';
        2: Result :='03 - Cavalo Mecânico';
        3: Result :='04 - VAN';
        4: Result :='05 - Utilitário';
    else
        Result :='06 - Outros';
    end;
end;

function tpCarroceriaToStr(const tpcar: smallint): string ;
begin
    case tpcar of
        1: Result :='01 - Aberta';
        2: Result :='02 - Fechada/Baú';
        3: Result :='03 - Granelera';
        4: Result :='04 - Porta Container';
        5: Result :='05 - Sider';
    else
        Result :='00 - não aplicável';
    end;
end;


{ TCVeiculo }

class function TCVeiculo.CLoad(const codseq: Int32): TDataSet;
var
  Q: TADOQuery ;
begin
    Q :=TADOQuery.NewADOQuery();
    Q.AddCmd('select *from cadveiculo');
    if codseq > 0 then
    begin
        Q.AddCmd('where vei_codseq =%d',[codseq]);
    end;
    Q.AddCmd('order by vei_codseq    ');
    Q.Open ;
    //
    //
    Result :=TDataSet(Q) ;
end;

procedure TCVeiculo.cmdDelete;
begin

end;

function TCVeiculo.cmdFind(const codseq: Int16): Boolean;
var
  Q: TDataSet ;
begin
    //
    //
    if codseq > 0 then
        Q :=TCVeiculo.CLoad(codseq)
    else
        Q :=TCVeiculo.CLoad(0);

    try
        Result :=not Q.IsEmpty ;
        if not Result then
            raise EBuscaIsEmpty.CreateFmt('Nenhum veículo encontrado para codigo[%d]!',[codseq]);

        if Result then
        begin
            Self.loadFromDataset(Q);
            Self.State :=msBrowse ;
        end
        else
            Self.Inicialize
            ;
    finally
        Q.Free ;
    end;
end;

procedure TCVeiculo.cmdInsert;
var
  C: TADOCommand ;
begin
    C :=TADOCommand.NewADOCommand() ;
    try
        C.AddCmd('declare @vei_placa varchar(7)   ;set @vei_placa   =%s;',[C.FStr(self.m_placa  )]);
        C.AddCmd('declare @vei_renavam varchar(11);set @vei_renavam =%s;',[C.FStr(self.m_renavam)]);
        C.AddCmd('declare @vei_tara smallint      ;set @vei_tara    =%d;',[self.m_tara           ]);
        C.AddCmd('declare @vei_capkg smallint     ;set @vei_capkg   =%d;',[self.m_capkg          ]);
        C.AddCmd('declare @vei_capm3 smallint     ;set @vei_capm3   =%d;',[self.m_capm3          ]);
        C.AddCmd('declare @vei_tiprod smallint    ;set @vei_tiprod  =%d;',[self.m_tiprod         ]);
        C.AddCmd('declare @vei_tipcar smallint    ;set @vei_tipcar  =%d;',[self.m_tipcar         ]);
        C.AddCmd('declare @vei_ufelic char(2)     ;set @vei_ufelic  =%s;',[C.FStr(self.m_ufelic )]);
        C.AddCmd('declare @vei_cdprop smallint    ;                     ');
//        C.AddCmd('declare @vei_tpprop smallint    ;                     ');
        C.AddCmd('declare @vei_status smallint    ;set @vei_status  =%d;',[self.m_status         ]);
        C.AddCmd('insert into cadveiculo( vei_placa  ,                  ');
        C.AddCmd('                        vei_renavam,                  ');
        C.AddCmd('                        vei_tara,                     ');
        C.AddCmd('                        vei_capkg,                    ');
        C.AddCmd('                        vei_capm3,                    ');
        C.AddCmd('                        vei_tiprod,                   ');
        C.AddCmd('                        vei_tipcar,                   ');
        C.AddCmd('                        vei_ufelic,                   ');
        C.AddCmd('                        vei_cdprop,                   ');
//        C.AddCmd('                        vei_tpprop,                   ');
        C.AddCmd('                        vei_status)                   ');
        C.AddCmd('values                ( @vei_placa  ,                 ');
        C.AddCmd('                        @vei_renavam,                 ');
        C.AddCmd('                        @vei_tara,                    ');
        C.AddCmd('                        @vei_capkg,                   ');
        C.AddCmd('                        @vei_capm3,                   ');
        C.AddCmd('                        @vei_tiprod,                  ');
        C.AddCmd('                        @vei_tipcar,                  ');
        C.AddCmd('                        @vei_ufelic,                  ');
        C.AddCmd('                        @vei_cdprop,                  ');
//        C.AddCmd('                        @vei_tpprop,                  ');
        C.AddCmd('                        @vei_status)                  ');
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
            Self.m_codseq :=TADOQuery.ident_current('cadveiculo');

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

procedure TCVeiculo.cmdUpdate;
var
  C: TADOCommand ;
begin
    C :=TADOCommand.NewADOCommand() ;
    try
        C.AddCmd('declare @vei_codseq smallint    ;set @vei_codseq  =%d;',[self.m_codseq         ]);
        C.AddCmd('declare @vei_placa varchar(7)   ;set @vei_placa   =%s;',[C.FStr(self.m_placa  )]);
        C.AddCmd('declare @vei_renavam varchar(11);set @vei_renavam =%s;',[C.FStr(self.m_renavam)]);
        C.AddCmd('declare @vei_tara smallint      ;set @vei_tara    =%d;',[self.m_tara           ]);
        C.AddCmd('declare @vei_capkg smallint     ;set @vei_capkg   =%d;',[self.m_capkg          ]);
        C.AddCmd('declare @vei_capm3 smallint     ;set @vei_capm3   =%d;',[self.m_capm3          ]);
        C.AddCmd('declare @vei_tiprod smallint    ;set @vei_tiprod  =%d;',[self.m_tiprod         ]);
        C.AddCmd('declare @vei_tipcar smallint    ;set @vei_tipcar  =%d;',[self.m_tipcar         ]);
        C.AddCmd('declare @vei_ufelic char(2)     ;set @vei_ufelic  =%s;',[C.FStr(self.m_ufelic )]);
        C.AddCmd('declare @vei_cdprop smallint    ;                     ');
//        C.AddCmd('declare @vei_tpprop smallint    ;                     ');
        C.AddCmd('declare @vei_status smallint    ;set @vei_status  =%d;',[self.m_status         ]);
        C.AddCmd('update cadveiculo set                                 ');
        C.AddCmd('    vei_placa   =@vei_placa   ,                       ');
        C.AddCmd('    vei_renavam =@vei_renavam ,                       ');
        C.AddCmd('    vei_tara    =@vei_tara    ,                       ');
        C.AddCmd('    vei_capkg   =@vei_capkg   ,                       ');
        C.AddCmd('    vei_capm3   =@vei_capm3   ,                       ');
        C.AddCmd('    vei_tiprod  =@vei_tiprod  ,                       ');
        C.AddCmd('    vei_tipcar  =@vei_tipcar  ,                       ');
        C.AddCmd('    vei_ufelic  =@vei_ufelic  ,                       ');
        C.AddCmd('    vei_cdprop  =@vei_cdprop  ,                       ');
//        C.AddCmd('    vei_tpprop  =@vei_tpprop  ,                       ');
        C.AddCmd('    vei_status  =@vei_status                          ');
        C.AddCmd('where vei_codseq =@vei_codseq                         ');
        try
            //
            // start uma transação, caso não tenha!
            if not C.Connection.InTransaction then
                C.Connection.BeginTrans ;

            //
            // exec o insert
            //C.SaveToFile();
            C.Execute ;

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

constructor TCVeiculo.Create;
begin
    //m_infCdt :=TList<TCCondutor>.Create ;
    Inicialize ;

end;

procedure TCVeiculo.Edit;
begin
    State :=msEdit ;
    //
    // atualiza a view
end;

function TCVeiculo.getCapKg: Int16;
begin
    Result :=m_capkg
    ;
end;

function TCVeiculo.getCapM3: Int16;
begin
    Result :=m_capm3
    ;
end;

function TCVeiculo.getCodProp: Int16;
begin
    Result :=m_cdprop
    ;
end;

function TCVeiculo.getCodSeq: Int16;
begin
    Result :=m_codseq
    ;
end;

function TCVeiculo.GetOnModelChanged: TModelChangedEvent;
begin
    Result :=m_OnModelChanged
    ;
end;

function TCVeiculo.getPlaca: string;
begin
    Result :=m_placa
    ;
end;

function TCVeiculo.getRenavam: string;
begin
    Result :=m_renavam
    ;
end;

function TCVeiculo.getStateChange: TModelState;
begin
    Result :=m_StateChange
    ;
end;

function TCVeiculo.getStatus: Int16;
begin
    Result :=m_status
    ;
end;

function TCVeiculo.getTara: Int16;
begin
    Result :=m_tara
    ;
end;

function TCVeiculo.getTipCar: Int16;
begin
    Result :=m_tipcar
    ;
end;

function TCVeiculo.getTipProp: Int16;
begin
    Result :=m_tiprod
    ;
end;

function TCVeiculo.getTipRod: Int16;
begin
    Result :=m_tiprod
    ;
end;

function TCVeiculo.getUFeLic: string;
begin
    Result :=m_ufelic
    ;
end;

procedure TCVeiculo.Inicialize;
begin
    m_StateChange :=msInactive ;
    m_codseq :=0;
    m_placa :='';
    m_renavam :='';
    m_tara :=0;
    m_capkg:=0 ;
    m_capm3:=0 ;
    m_tiprod:=-1;
    m_tipcar:=-1;
    m_ufelic:='';
    m_cdprop:=0;
    m_tpprop:=0;
    m_status:=0;
end;

procedure TCVeiculo.Insert;
begin
    Inicialize ;
    State :=msInsert ;
end;

function TCVeiculo.isValid: Boolean;
begin
    Result :=False ;
    if Self.m_placa = EmptyStr then
        raise EPlacaIsEmpty.Create('O numero da placa deve ser informado!')
    else if Self.m_tara = 0 then
        raise ETaraIsEmpty.Create('A unidade tara deve ser informado!')
    else if Self.m_tiprod < 0 then
        raise ETaraIsEmpty.Create('O tipo de rodado deve ser informado!')
    else if Self.m_tipcar < 0 then
        raise ETaraIsEmpty.Create('O tipo de carroceria deve ser informado!')
    else if Self.m_ufelic = EmptyStr then
        raise EUFIsEmpty.Create('A UF de licença do deve ser informado!');
    Result :=True ;
end;

procedure TCVeiculo.loadFromDataset(ds: TDataSet);
begin
    Self.m_codseq  :=ds.FieldByName('vei_codseq').AsInteger ;
    Self.m_placa   :=ds.FieldByName('vei_placa').AsString ;
    Self.m_renavam :=ds.FieldByName('vei_renavam').AsString;
    Self.m_ufelic  :=ds.FieldByName('vei_ufelic').AsString;
    Self.m_tara  :=ds.FieldByName('vei_tara').AsInteger ;
    Self.m_capkg :=ds.FieldByName('vei_capkg').AsInteger ;
    Self.m_capm3 :=ds.FieldByName('vei_capm3').AsInteger ;
    Self.m_tiprod :=ds.FieldByName('vei_tiprod').AsInteger;
    Self.m_tipcar :=ds.FieldByName('vei_tipcar').AsInteger;
    Self.m_cdprop :=ds.FieldByName('vei_cdprop').AsInteger;
end;

function TCVeiculo.Merge(): TModelUpdateKind;
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

procedure TCVeiculo.setCapKg(Value: Int16);
begin
    m_capkg :=Value
    ;
end;

procedure TCVeiculo.setCapM3(Value: Int16);
begin
    m_capm3 :=Value
    ;
end;

procedure TCVeiculo.setCodProp(Value: Int16);
begin
    m_cdprop :=Value
    ;
end;

procedure TCVeiculo.SetOnModelChanged(Value: TModelChangedEvent);
begin
    m_OnModelChanged :=Value
    ;
end;

procedure TCVeiculo.setPlaca(Value: string);
begin
    m_placa :=Value
    ;
end;

procedure TCVeiculo.setRenavam(Value: string);
begin
    m_renavam :=Value
    ;
end;

procedure TCVeiculo.setStateChange(Value: TModelState);
begin
    m_StateChange :=Value ;
    //
    // atualiza a view
    if Assigned(OnModelChanged)then
    begin
        OnModelChanged
    end;
end;

procedure TCVeiculo.setTara(Value: Int16);
begin
    m_tara :=Value
    ;
end;

procedure TCVeiculo.setTipCar(Value: Int16);
begin
    m_tipcar :=Value
    ;
end;

procedure TCVeiculo.setTipProp(Value: Int16);
begin
    m_tpprop :=Value
    ;
end;

procedure TCVeiculo.setTipRod(Value: Int16);
begin
    m_tiprod :=Value
    ;
end;

procedure TCVeiculo.setUFeLic(Value: string);
begin
    m_ufelic :=Value
    ;
end;


end.
