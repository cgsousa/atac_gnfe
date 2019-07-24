unit uVeiculoCtr;

interface

uses Classes,
  uIntf, uVeiculo
  ;

type

  IVeiculoCtr = Interface(IController)
    ['{F67F82CA-8A93-43DD-B0DB-2CF63B556131}']
    function getModel: IVeiculo;
    procedure setModel(Value: IVeiculo);
    function getView: IView;
    procedure setView(Value: IView);
    property Model: IVeiculo read getModel write setModel;
    property View: IView read getView write setView;

    procedure ExecView;

    function cmdFind(const codseq: Int16 =0): Boolean ;
    procedure Insert ;
    procedure Edit ;
    function Merge(): TModelUpdateKind;

  end;

  TCVeiculoCtr = class(TInterfacedObject, IVeiculoCtr, IVeiculoList)
  private
    m_ModelList: TCVeiculoList ;
    m_Model: IVeiculo;
    m_View: IView;
    function getModel: IVeiculo;
    procedure setModel(Value: IVeiculo);
    function getView: IView;
    procedure setView(Value: IView);
  protected
  public
    property Model: IVeiculo read getModel write setModel;
    property View: IView read getView write setView;
    property ModelList: TCVeiculoList read m_ModelList implements IVeiculoList;

    constructor Create() ;
    procedure Inicialize;
    procedure ExecView;

    function cmdFind(const codseq: Int16 =0): Boolean ;
    procedure Insert;
    procedure Edit ;
    function Merge(): TModelUpdateKind;
  end;


implementation

uses SysUtils, Windows, Forms, Dialogs, DB, Graphics,
  Form.Busca, Form.Veiculo
  ;

{ TCVeiculoCtr }

function TCVeiculoCtr.cmdFind(const codseq: Int16): Boolean;
var
  Q: TDataSet;
var
  B: TCBusca ;
  C: TCBuscaCollumn ;
begin
    //
    // busca pelo codigo
    if codseq > 0 then
        Result :=Model.cmdFind(codseq)
    //
    // busca todos
    else begin
        Q :=TCVeiculo.CLoad(0) ;
        try
            //
            // prepara a view da busca para mostrar os registros
            B :=TCBusca.NewBusca ;
            try
                B.DataSet :=TDataSet(Q) ;

                C :=B.Columns.Add;
                C.Title :='Id';
                C.Field     :=B.DataSet.Fields[C.Index];
                C.Width     :=30;
                C.Color     :=clBtnFace;
                C.Alignment :=taCenter;
                C.Font.Style:=[fsbold];

                C :=B.Columns.Add;
                C.Title     :='Placa';
                C.Field     :=B.DataSet.Fields[C.Index];
                C.Width     :=50;
                C.Color     :=clWindow;
                C.Alignment :=taLeftJustify;

                B.ResultField :=B.DataSource.DataSet.Fields[0].FieldName;

                if B.Execute then
                begin
                    Result :=Model.cmdFind(B.ResultValueInt) ;
                end;

            finally
                B.Free ;
            end;

        finally
            Q.Free ;
        end;
    end;
end;

constructor TCVeiculoCtr.Create() ;
begin
    m_ModelList :=TCVeiculoList.Create(Self) ;
    {//
    // Instancia o model
    m_Model :=TCVeiculo.Create;
    //EmpresaDAO := TEmpresaDAO.Create;

    //
    // Camada de Visualização (Form)
    m_View :=Tfrm_Veiculo.Create(Self);

    m_Model.OnModelChanged :=(m_View as Tfrm_Veiculo).ModelChanged ;
    m_View.Inicialize ;}
end;

procedure TCVeiculoCtr.Edit;
begin
    Model.Edit
    ;
end;

procedure TCVeiculoCtr.ExecView;
begin
    m_View.Execute
    ;
end;

function TCVeiculoCtr.getModel: IVeiculo;
begin
    Result :=m_Model
    ;
end;

function TCVeiculoCtr.getView: IView;
begin
    Result :=m_View
    ;
end;

procedure TCVeiculoCtr.Inicialize;
begin
    Model.Inicialize
    ;
end;

procedure TCVeiculoCtr.Insert;
begin
    Model.Insert
    ;
end;

function TCVeiculoCtr.Merge(): TModelUpdateKind;
begin
    Result :=Model.Merge()
    ;
end;


procedure TCVeiculoCtr.setModel(Value: IVeiculo);
begin
    m_Model :=Value ;

end;

procedure TCVeiculoCtr.setView(Value: IView);
begin
    m_View :=Value ;

end;

end.
