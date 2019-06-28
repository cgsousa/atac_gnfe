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
  uclass, unotfis00;


type
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

uses Windows, ActiveX,
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

end.
