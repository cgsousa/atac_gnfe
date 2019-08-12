{***
* Thread para o serviço de exporta XML da NFe/NFCe
* Atac Sistemas
* Todos os direitos reservados
* Autor: Carlos Gonzaga
* Data: 14.06.2019
*}
unit Thread.XML;

{*
******************************************************************************
|* PROPÓSITO: Registro de Alterações
******************************************************************************

Símbolo : Significado

[+]     : Novo recurso
[*]     : Recurso modificado/melhorado
[-]     : Correção de Bug (assim esperamos)

*}

interface

uses SysUtils ,
  uclass, uini, unotfis00;


type
  TAppConfig = Object
  private
    m_Cfg: IMemIniFile;
    procedure DoSave ;
  public
    m_DHmin: TDateTime ;
    m_DHmax: TDateTime ;
    m_Numero: Word ;
    m_IncDias: Word ;
    constructor Create() ;
  end;


  TCSvcXML = class(TCThreadProcess)
  private
    { Private declarations }
    m_Filter: TNotFis00Filter ;
    m_Lote: TCNotFis00Lote;
  protected
    procedure Execute; override;
    procedure RunProc; override;
  public
    constructor Create(const aFilter: TNotFis00Filter);
    destructor Destroy; override;
  end;


implementation

uses Windows, ActiveX, DateUtils,
  uadodb ;


{ TCSvcXML }

constructor TCSvcXML.Create(const aFilter: TNotFis00Filter);
begin
    inherited Create(True, False);
    m_Filter :=aFilter  ;
    m_Lote :=TCNotFis00Lote.Create ;
end;

destructor TCSvcXML.Destroy;
begin
    m_Lote.Destroy ;
    inherited;
end;

procedure TCSvcXML.Execute;
begin
    CallOnStrProc('%s.Execute',[Self.ClassName]);
    if ConnectionADO = nil then
    begin
        CoInitialize(nil);
        try
            ConnectionADO :=NewADOConnFromIniFile(
                                ExtractFilePath(ParamStr(0)) +'Configuracoes.ini'
                                ) ;
            inherited Execute;
        finally
            CoUninitialize;
        end;
    end
    else
        inherited Execute;
end;

procedure TCSvcXML.RunProc;
begin
    try
        ConnectionADO.Connected :=True ;
        try
            if m_Lote.Load(m_Filter) then
            begin

            end;
        finally
            ConnectionADO.Close ;
        end;
    except

    end;
end;


{ TAppConfig }

constructor TAppConfig.Create;
begin
    m_Cfg :=TCMemIniFile.New('') ;
    if not FileExists(m_Cfg.FileName)then
    begin
        m_DHmin :=StartOfTheYear(Date)  ;
        m_DHmax :=StartOfAMonth(Date) -90;
        if m_DHmin > m_DHmax then
        begin
            m_DHmin :=m_DHmax;
        end;
        m_Numero :=0;
        m_IncDias:=5;
        DoSave ;
    end
    else begin
        m_DHmin :=m_Cfg.ValDat('dt_ini')  ;
        m_DHmax :=m_Cfg.ValDat('dt_fin')  ;
        m_Numero :=m_Cfg.ValInt('num_caixa');
        m_IncDias:=m_Cfg.ValInt('inc_dias');
    end;
end;

procedure TAppConfig.DoSave;
begin
    m_Cfg.Section :='GERAL' ;
    m_Cfg.WDat('dt_min', m_DHmin );
    m_Cfg.WDat('dt_max', m_DHmax );
    m_Cfg.WInt('num_caixa', m_Numero);
    m_Cfg.WInt('inc_dias', m_IncDias);
    m_Cfg.Update ;
end;

end.
