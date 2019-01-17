unit uManifestoCtr;

interface

uses Classes, Generics.Collections,
  uIntf, uManifestoDF
  ;

type

//  TSelectCondutor = record
//    codseq: Int16;
//    cpfcnpj: string;
//    xnome: string ;
//  end;


  IManifestoCtr = Interface(IController)
    ['{F67F82CA-8A93-43DD-B0DB-2CF63B556131}']
    function getModel: IManifestoDF;
    procedure setModel(Value: IManifestoDF);
    function getView: IView;
    procedure setView(Value: IView);
    property Model: IManifestoDF read getModel write setModel;
    property View: IView read getView write setView;

    procedure ExecView;

    function cmdFind(const afilter: TManifestoFilter): Boolean ;
    procedure Insert ;
    procedure Edit ;
    function Merge(): TModelUpdateKind;
  end;

  TCManifestoCtr = class(TInterfacedObject, IManifestoCtr, IManifestoDFList)
  private
    m_ModelList: TCManifestoDFList ;
    m_Model: IManifestoDF;
    m_View: IView;
    function getModel: IManifestoDF;
    procedure setModel(Value: IManifestoDF);
    function getView: IView;
    procedure setView(Value: IView);
  protected
  public
    property Model: IManifestoDF read getModel write setModel;
    property View: IView read getView write setView;
    property ModelList: TCManifestoDFList read m_ModelList implements IManifestoDFList;

    constructor Create() ;
    procedure Inicialize;
    procedure ExecView;

    function cmdFind(const aFilter: TManifestoFilter): Boolean ;
    procedure Insert;
    procedure Edit ;
    function Merge(): TModelUpdateKind;
  end;


implementation

uses SysUtils, Windows, Forms, Dialogs, DB, Graphics,
  uadodb,
  Form.Busca //, Form.ManifestoDF
  ;


{ TCManifestoCtr }

function TCManifestoCtr.cmdFind(const aFilter: TManifestoFilter): Boolean;
var
  Q: TDataset;
  M: IManifestoDF ;
var
  B: TCBusca ;
  C: TCBuscaCollumn ;
var
  F: TManifestoFilter;

begin
    //
    // busca pelo codigo
    if aFilter.codseq > 0 then
        Result :=Model.cmdFind(aFilter)
    //
    // busca todos
    else begin
        Q :=TCManifestoDF.CLoad(aFilter) ;
        try
            Result :=not Q.IsEmpty ;
            if Result then
            begin
                if Assigned(m_ModelList) then
                    m_ModelList.clearItems
                else
                    m_ModelList :=TCManifestoDFList.Create ;

                while not Q.Eof do
                begin
                    M :=TCManifestoDF.Create ;
                    M.loadFromDataset(Q);
                    m_ModelList.getItems.Add(M) ;
                    Q.Next ;
                end;
            end;


            {
            //
            // prepara a view da busca para mostrar os registros
            B :=TCBusca.NewBusca ;
            try
                B.DataSet :=Q ;

                C :=B.Columns.Add;
                C.Title :='Id';
                C.Field     :=B.DataSet.Fields[C.Index];
                C.Width     :=75;
                C.Color     :=clBtnFace;
                C.Alignment :=taCenter;
                C.Font.Style:=[fsbold];

                C :=B.Columns.Add;
                C.Title     :='Tp.Transp';
                C.Field     :=B.DataSet.FieldByName('md0_tptransp');
                C.Width     :=75;
                C.Color     :=clWindow;
                C.Alignment :=taCenter;

                C :=B.Columns.Add;
                C.Title     :='Num.Doc';
                C.Field     :=B.DataSet.FieldByName('md0_numdoc');
                C.Width     :=75;
                C.Color     :=clWindow;
                C.Alignment :=taRightJustify;

                C :=B.Columns.Add;
                C.Title     :='Data/Hora Emissão';
                C.Field     :=B.DataSet.FieldByName('md0_dhemis');
                C.Width     :=121;
                C.Color     :=clWindow;
                C.Alignment :=taLeftJustify;

                C :=B.Columns.Add;
                C.Title     :='Tp.Emis';
                C.Field     :=B.DataSet.FieldByName('md0_tpemis');
                C.Width     :=50;
                C.Color     :=clWindow;
                C.Alignment :=taCenter;

                C :=B.Columns.Add;
                C.Title     :='UF Ini';
                C.Field     :=B.DataSet.FieldByName('md0_ufeini');
                C.Width     :=50;
                C.Color     :=clWindow;
                C.Alignment :=taCenter;

                C :=B.Columns.Add;
                C.Title     :='UF Fim';
                C.Field     :=B.DataSet.FieldByName('md0_ufefim');
                C.Width     :=50;
                C.Color     :=clWindow;
                C.Alignment :=taCenter;

                B.ResultField :=B.DataSource.DataSet.Fields[0].FieldName;

                if B.Execute then
                begin
                    F.codseq :=B.ResultValueInt ;
                    F.datini :=0;
                    F.datfin :=0;
                    Result :=Model.cmdFind(F) ;
                end;

            finally
                B.Free ;
            end;
            }

        finally
            Q.Free ;
        end;
    end;
end;

constructor TCManifestoCtr.Create;
begin
    m_ModelList :=TCManifestoDFList.Create(Self) ;
    {//
    // Instancia o model
    m_Model :=TCManifestoDF.Create;

    //
    // Camada de Visualização (Form)
    m_View :=Tfrm_ManifestoDF.Create(Self);

    m_Model.OnModelChanged :=(m_View as Tfrm_ManifestoDF).ModelChanged ;
    m_View.Inicialize ;}
end;

procedure TCManifestoCtr.Edit;
begin

end;

procedure TCManifestoCtr.ExecView;
begin
    m_View.Execute
    ;
end;

function TCManifestoCtr.getModel: IManifestoDF;
begin
    Result :=m_Model
    ;
end;

function TCManifestoCtr.getView: IView;
begin
    Result :=m_View
    ;
end;

procedure TCManifestoCtr.Inicialize;
begin
    m_Model.Inicialize
    ;
end;

procedure TCManifestoCtr.Insert;
begin
    m_Model.Insert
    ;
end;

function TCManifestoCtr.Merge(): TModelUpdateKind;
begin
    Result :=m_Model.Merge ;

end;

procedure TCManifestoCtr.setModel(Value: IManifestoDF);
begin
    m_Model :=Value ;

end;

procedure TCManifestoCtr.setView(Value: IView);
begin
    m_View :=Value;

end;

end.
