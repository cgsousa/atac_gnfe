unit uIntf;

interface

uses
  Generics.Collections, Generics.Defaults;

type
  TModelChangedEvent = procedure of object;

  TModelState =(msInactive, msBrowse, msEdit, msInsert, msFilter);
  TUpdateKind = (ukModify, ukInsert, ukDelete);
  TModelUpdateKind = (mukUnModify, mukModify, mukInsert, mukDelete);

  IModel = Interface(IInterface)
    procedure Inicialize;
    function GetOnModelChanged: TModelChangedEvent;
    procedure SetOnModelChanged(Value: TModelChangedEvent);
    property OnModelChanged: TModelChangedEvent read GetOnModelChanged
      write SetOnModelChanged;
    function getStateChange: TModelState ;
    procedure setStateChange(Value: TModelState) ;
    property State: TModelState read getStateChange write setStateChange;
  end;

  IView = Interface(IInterface)
    procedure Inicialize;
//    procedure ModelChanged;
    procedure Execute;
  end;

  IController = Interface(IInterface)
    procedure Inicialize;
  end;

  IDataList<T> = Interface(IInterface)
    function addNew(aItem: T): T ;
    procedure clearItems ;
    function getItems: TList<T>;
    property Items: TList<T> read getItems ;
  end;

  {TCustomDataList<T> = class(TSingletonImplementation, IDataList<T>)
  protected
    function Check(const Instance: T): Boolean; virtual; abstract;
  end;}


implementation

end.
