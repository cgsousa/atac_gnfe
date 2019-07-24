unit uCondutorCtr;

interface

uses Classes,
  uIntf, uCondutor
  ;

type

  ICondutorCtr = Interface(IController)
    ['{F67F82CA-8A93-43DD-B0DB-2CF63B556131}']
    function getModel: ICondutor;
    procedure setModel(Value: ICondutor);
    function getView: IView;
    procedure setView(Value: IView);
    property Model: ICondutor read getModel write setModel;
    property View: IView read getView write setView;

    procedure ExecView;

    function cmdFind(const aFilter: TCondutorFilter): Boolean ;
    procedure Insert ;
    procedure Edit ;
    function Merge(): TModelUpdateKind;

  end;

  TCCondutorCtr = class(TInterfacedObject, ICondutorCtr, ICondutorList)
  private
    m_CondutorList: TCCondutorList ;
    m_Model: ICondutor;
    m_View: IView;
    function getModel: ICondutor;
    procedure setModel(Value: ICondutor);
    function getView: IView;
    procedure setView(Value: IView);
  protected
  public
    property Model: ICondutor read getModel write setModel;
    property View: IView read getView write setView;
    property ModelList: TCCondutorList read m_CondutorList implements ICondutorList;

    constructor Create() ;
    procedure Inicialize;
    procedure ExecView;

    function cmdFind(const aFilter: TCondutorFilter): Boolean ;
    procedure Insert;
    procedure Edit ;
    function Merge(): TModelUpdateKind;
  end;


implementation

uses SysUtils, Windows, Forms, Dialogs, DB, Graphics,
  uadodb,
  Form.Busca, Form.Condutor
  ;

{ TCCondutorCtr }

function TCCondutorCtr.cmdFind(const aFilter: TCondutorFilter): Boolean;
var
  Q: TADOQuery;
var
  B: TCBusca ;
  C: TCBuscaCollumn ;
var
  F: TCondutorFilter;
begin
    //
    // busca pelo codigo
    if aFilter.codseq > 0 then
        Result :=Model.cmdFind(aFilter)
    //
    // busca todos
    else begin
        Q :=TCCondutor.CLoad(aFilter) ;
        try
            //
            // prepara a view da busca para mostrar os registros
            B :=TCBusca.NewBusca ;
            try
                B.DataSet :=TDataSet(Q) ;

                C :=B.Columns.Add;
                C.Title :='Id';
                C.Field     :=B.DataSet.Fields[C.Index];
                C.Width     :=75;
                C.Color     :=clBtnFace;
                C.Alignment :=taCenter;
                C.Font.Style:=[fsbold];

                C :=B.Columns.Add;
                C.Title     :='Nome';
                C.Field     :=B.DataSet.FieldByName('cdt_xnome');
                C.Width     :=250;
                C.Color     :=clWindow;
                C.Alignment :=taLeftJustify;

                C :=B.Columns.Add;
                C.Title     :='CPF/CNPJ';
                C.Field     :=B.DataSet.FieldByName('cdt_cpfcnpj');
                C.Width     :=125;
                C.Color     :=clWindow;
                C.Alignment :=taLeftJustify;

                B.ResultField :=B.DataSource.DataSet.Fields[0].FieldName;

                if B.Execute then
                begin
                    F.codseq :=B.ResultValueInt ;
                    Result :=Model.cmdFind(F) ;
                end;

            finally
                B.Free ;
            end;

        finally
            Q.Free ;
        end;
    end;
end;

constructor TCCondutorCtr.Create() ;
begin
    m_CondutorList :=TCCondutorList.Create(Self) ;
    {
    //
    // Instancia o model
    m_Model :=TCCondutor.Create;
    //EmpresaDAO := TEmpresaDAO.Create;

    //
    // Camada de Visualização (Form)
    m_View :=Tfrm_Condutor.Create(Self);

    m_Model.OnModelChanged :=(m_View as Tfrm_Condutor).ModelChanged ;
    m_View.Inicialize ;
    }
end;

procedure TCCondutorCtr.Edit;
begin
    Model.Edit
    ;
end;

procedure TCCondutorCtr.ExecView;
begin
    m_View.Execute
    ;
end;

function TCCondutorCtr.getModel: ICondutor;
begin
    Result :=m_Model
    ;
end;

function TCCondutorCtr.getView: IView;
begin
    Result :=m_View
    ;
end;

procedure TCCondutorCtr.Inicialize;
begin
    Model.Inicialize
    ;
end;

procedure TCCondutorCtr.Insert;
begin
    Model.Insert
    ;
end;

function TCCondutorCtr.Merge(): TModelUpdateKind;
begin
    Result :=Model.Merge
    ;
end;


procedure TCCondutorCtr.setModel(Value: ICondutor);
begin
    m_Model :=Value ;

end;

procedure TCCondutorCtr.setView(Value: IView);
begin
    m_View :=Value ;

end;

end.
