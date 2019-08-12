{***
* Classes/Tipos para tratar os eventos da nfe
* Atac Sistemas
* Todos os direitos reservados
* Autor: Carlos Gonzaga
* Data: 22.09.2019
*}
unit ueventonfe;

interface

uses
  Classes, SysUtils, DB, ADODB,
  Generics.Collections ;


type
  TCEventoNFe = class ;
  IEventoNFe =Interface(IInterface)
    function getID: Integer ;
    property iD: Integer read getID ;

    function getCodNF: Integer ;
    property codNF: Integer read getCodNF ;

    function getCodOrg: SmallInt ;
    procedure setCodOrg(const aValue: SmallInt);
    property codOrg: smallint read getCodOrg write setCodOrg ;

    function getAmbPro: Boolean ;
    procedure setAmbPro(const aValue: Boolean);
    property Producao: Boolean read getAmbPro write setAmbPro ;

    function getCNPJ: string ;
    procedure setCNPJ(const aValue: string);
    property CNPJ: string read getCNPJ write setCNPJ ;

    function getChvNFe: string ;
    procedure setChvNFe(const aValue: string);
    property chvNFe: string read getChvNFe write setChvNFe ;

    function getDHEvento: Tdatetime;
    procedure setDHEvento(const aValue: Tdatetime);
    property dhEvento: Tdatetime read getDHEvento write setDHEvento ;

    function getTpEvento: Integer;
    procedure setTpEvento(const aValue: Integer);
    property tpEvento: Integer read getTpEvento write setTpEvento ;

    function getNumSeq: SmallInt ;
    procedure setNumSeq(const aValue: SmallInt);
    property numSeq: smallint read getNumSeq write setNumSeq ;

    function getTextCCe: string ;  // texto livre da CC-e
    procedure setTextCCe(const aValue: string);
    property textCCe: string read getTextCCe write setTextCCe ;

    function getCodStt: SmallInt ;
    procedure setCodStt(const aValue: SmallInt);
    property codStatus: smallint read getCodStt write setCodStt ;

    function getMotivo: string ;
    procedure setMotivo(const aValue: string);
    property motivo: string read getMotivo write setMotivo ;

    function getIdDest: string ;
    procedure setIdDest(const aValue: string);
    property idDest: string read getIdDest write setIdDest ;

    function getMailDest: string ;
    procedure setMailDest(const aValue: string);
    property emailDest: string read getMailDest write setMailDest ;

    function getDHReceb: Tdatetime;
    procedure setDHReceb(const aValue: Tdatetime);
    property dhReceb: Tdatetime read getDHReceb write setDHReceb ;

    function getNumProt: string ;
    procedure setNumProt(const aValue: string);
    property Protocolo: string read getNumProt write setNumProt ;

    procedure doInsert ;
    procedure doUpdate ;

  end;

  //TEventoNFe = (teCancel,teCCe);
  TCEventoNFe = class(TInterfacedObject, IEventoNFe)
  private
    m_iD: Integer;
    m_CodNF: Integer;
    m_codOrg: smallint;
    m_AmbPro: Boolean ;
    m_CNPJ: string;
    m_ChvNFe: string ;
    m_dhEvento: Tdatetime;
    m_tpEvento: Integer;
    m_NumSeq: smallint;
    m_TextCCe: string;
    m_CodStt: smallint ;
    m_Motivo: string ;
    m_idDest: string ;
    m_emailDest: string ;
    m_dhReceb: Tdatetime;
    m_NumProt: string ;

    function getID: Integer ;

    function getCodNF: Integer ;

    function getCodOrg: SmallInt ;
    procedure setCodOrg(const aValue: SmallInt);

    function getAmbPro: Boolean ;
    procedure setAmbPro(const aValue: Boolean);

    function getCNPJ: string ;
    procedure setCNPJ(const aValue: string);

    function getChvNFe: string ;
    procedure setChvNFe(const aValue: string);

    function getDHEvento: Tdatetime;
    procedure setDHEvento(const aValue: Tdatetime);

    function getTpEvento: Integer;
    procedure setTpEvento(const aValue: Integer);

    function getNumSeq: SmallInt ;
    procedure setNumSeq(const aValue: SmallInt);

    function getTextCCe: string ;  // texto livre da CC-e
    procedure setTextCCe(const aValue: string);

    function getCodStt: SmallInt ;
    procedure setCodStt(const aValue: SmallInt);

    function getMotivo: string ;
    procedure setMotivo(const aValue: string);

    function getIdDest: string ;
    procedure setIdDest(const aValue: string);

    function getMailDest: string ;
    procedure setMailDest(const aValue: string);

    function getDHReceb: Tdatetime;
    procedure setDHReceb(const aValue: Tdatetime);

    function getNumProt: string ;
    procedure setNumProt(const aValue: string);

    procedure doInsert ;
    procedure doUpdate ;

  public
    property iD: Integer read getID ;
    property codNF: Integer read getCodNF ;
    property codOrg: smallint read getCodOrg write setCodOrg ;
    property Producao: Boolean read getAmbPro write setAmbPro ;
    property CNPJ: string read getCNPJ write setCNPJ ;
    property chvNFe: string read getChvNFe write setChvNFe ;
    property dhEvento: Tdatetime read getDHEvento write setDHEvento ;
    property tpEvento: Integer read getTpEvento write setTpEvento ;
    property numSeq: smallint read getNumSeq write setNumSeq ;
    property textCCe: string read getTextCCe write setTextCCe ;
    property status: smallint read getCodStt write setCodStt ;
    property motivo: string read getMotivo write setMotivo ;
    property idDest: string read getIdDest write setIdDest ;
    property emailDest: string read getMailDest write setMailDest ;
    property dhReceb: Tdatetime read getDHReceb write setDHReceb ;
    property Protocolo: string read getNumProt write setNumProt ;
  public
    class function New(): IEventoNFe ;
  end;


implementation

uses uadodb ;

{ TCEventoNFe }

procedure TCEventoNFe.doInsert;
var
  C: TADOCommand ;
begin
    C :=TADOCommand.NewADOCommand() ;
    try
        C.AddCmd('declare @codntf int     ; set @codntf =%d;',[self.m_CodNF]);
        C.AddCmd('declare @codorg smallint     ; set @codorg =%d;',[m_codorg]);
        if m_AmbPro then
        C.AddCmd('declare @cce_tipamb smallint     ; set @cce_tipamb =0;')
        else
        C.AddCmd('declare @cce_tipamb smallint     ; set @cce_tipamb =1;');
        C.AddCmd('declare @cce_cnpj varchar(14)    ; set @cce_cnpj   =%s;',[C.FStr(m_cnpj)]);
        C.AddCmd('declare @cce_chvnfe varchar(44)  ; set @cce_chvnfe =%s;',[C.FStr(m_chvnfe)]);
        C.AddCmd('declare @cce_corige varchar(1000); set @cce_corige =%s;',[C.FStr(m_TextCCe)]);
        //C.AddCmd('declare @cce_verapp varchar(20)  ; set @cce_verapp =%s;',[C.FStr(m_verapp)]);
        //C.AddCmd('declare @cce_codorgaut smallint  ; set @cce_codorgaut =%d;',[m_codorgaut]);
        C.AddCmd('declare @cce_codstt smallint     ; set @cce_codstt =%d;',[m_codstt]);
        C.AddCmd('declare @cce_motivo varchar(250) ; set @cce_motivo =%s;',[C.FStr(m_motivo)]);

        C.AddCmd('declare @cce_iddest varchar(14)  ;                     ');
        if m_iddest <> '' then
        begin
            C.AddCmd('  set @cce_iddest   =%s;',[C.FStr(m_iddest)]);
        end;

        C.AddCmd('declare @cce_emaildest varchar(50);                   ');
        if m_emaildest <> '' then
        begin
            C.AddCmd('  set @cce_emaildest  =%s;',[C.FStr(m_emaildest)]);
        end;

        C.AddCmd('declare @cce_dhreceb datetime; set @cce_dhreceb =?;   ');
        C.AddCmd('declare @cce_numprot char(15);                        ');
        if m_numprot <> '' then
        begin
            C.AddCmd('  set @cce_numprot  =%s;',[C.FStr(m_numprot)]);
        end;

        C.AddCmd('insert into eventocce(cce_versao  ,');
        C.AddCmd('                      cce_codorg  ,');
        C.AddCmd('                      cce_tipamb  ,');
        C.AddCmd('                      cce_cnpj    ,');
        C.AddCmd('                      cce_chvnfe  ,');
        C.AddCmd('                      cce_xcorrecao,');
//        C.AddCmd('                      cce_verapp  ,');
//        C.AddCmd('                      cce_codorgaut,');
        C.AddCmd('                      cce_codstt  ,');
        C.AddCmd('                      cce_motivo  ,');
        C.AddCmd('                      cce_iddest  ,');
        C.AddCmd('                      cce_emaildest,');
        C.AddCmd('                      cce_dhreceb  ,');
        C.AddCmd('                      cce_numprot)  ');
        C.AddCmd('values               (@cce_versao  ,');
        C.AddCmd('                      @cce_codorg  ,');
        C.AddCmd('                      @cce_tipamb   ,');
        C.AddCmd('                      @cce_cnpj    ,');
        C.AddCmd('                      @cce_chvnfe  ,');
        C.AddCmd('                      @cce_corige  ,');
//        C.AddCmd('                      @cce_verapp  ,');
//        C.AddCmd('                      @cce_codorgaut,');
        C.AddCmd('                      @cce_codstt  ,');
        C.AddCmd('                      @cce_motivo  ,');
        C.AddCmd('                      @cce_iddest  ,');
        C.AddCmd('                      @cce_emaildest,');
        C.AddCmd('                      @cce_dhreceb  ,');
        C.AddCmd('                      @cce_numprot)  ');

        //
        // adic. param data/time
        C.AddParamWithValue('@cce_dhreceb', ftDateTime, m_dhreceb) ;

        try
//            C.SaveToFile();
            C.Execute ;
        except
            //Result :=False ;
        end;

    finally
        C.Free ;
    end;
end;

procedure TCEventoNFe.doUpdate;
begin

end;

function TCEventoNFe.getAmbPro: Boolean;
begin
    Result :=m_AmbPro ;
end;

function TCEventoNFe.getChvNFe: string;
begin
    Result :=m_ChvNFe ;
end;

function TCEventoNFe.getCNPJ: string;
begin
    Result :=m_CNPJ ;
end;

function TCEventoNFe.getCodNF: Integer;
begin
    Result :=m_CodNF ;
end;

function TCEventoNFe.getCodOrg: SmallInt;
begin
    Result :=m_codOrg ;
end;

function TCEventoNFe.getCodStt: SmallInt;
begin
    Result :=m_CodStt ;
end;

function TCEventoNFe.getDHEvento: Tdatetime;
begin
    Result :=m_dhEvento ;
end;

function TCEventoNFe.getDHReceb: Tdatetime;
begin
    Result :=m_dhReceb ;
end;

function TCEventoNFe.getID: Integer;
begin
    Result :=m_iD ;
end;

function TCEventoNFe.getIdDest: string;
begin
    Result :=m_idDest ;
end;

function TCEventoNFe.getMailDest: string;
begin
    Result :=m_emailDest ;
end;

function TCEventoNFe.getMotivo: string;
begin
    Result :=m_Motivo;
end;

function TCEventoNFe.getNumProt: string;
begin
    Result :=m_NumProt ;
end;

function TCEventoNFe.getNumSeq: SmallInt;
begin
    Result :=m_NumSeq ;
end;

function TCEventoNFe.getTextCCe: string;
begin
    Result :=m_TextCCe ;
end;

function TCEventoNFe.getTpEvento: Integer;
begin
    Result :=m_tpEvento ;
end;

class function TCEventoNFe.New(): IEventoNFe;
begin
    Result :=TCEventoNFe.Create ;

end;

procedure TCEventoNFe.setAmbPro(const aValue: Boolean);
begin
    m_AmbPro :=aValue ;
end;

procedure TCEventoNFe.setChvNFe(const aValue: string);
begin
    m_ChvNFe :=aValue ;
end;

procedure TCEventoNFe.setCNPJ(const aValue: string);
begin
    m_CNPJ :=aValue ;
end;

procedure TCEventoNFe.setCodOrg(const aValue: SmallInt);
begin
    m_codOrg :=aValue ;
end;

procedure TCEventoNFe.setCodStt(const aValue: SmallInt);
begin
    m_CodStt :=aValue ;
end;

procedure TCEventoNFe.setDHEvento(const aValue: Tdatetime);
begin
    m_dhEvento :=aValue ;
end;

procedure TCEventoNFe.setDHReceb(const aValue: Tdatetime);
begin
    m_dhReceb :=aValue ;
end;

procedure TCEventoNFe.setIdDest(const aValue: string);
begin
    m_idDest :=aValue ;
end;

procedure TCEventoNFe.setMailDest(const aValue: string);
begin
    m_emailDest :=aValue ;
end;

procedure TCEventoNFe.setMotivo(const aValue: string);
begin
    m_Motivo :=aValue ;
end;

procedure TCEventoNFe.setNumProt(const aValue: string);
begin
    m_NumProt :=aValue ;
end;

procedure TCEventoNFe.setNumSeq(const aValue: SmallInt);
begin
    m_NumSeq :=aValue ;
end;

procedure TCEventoNFe.setTextCCe(const aValue: string);
begin
    m_TextCCe :=aValue ;
end;

procedure TCEventoNFe.setTpEvento(const aValue: Integer);
begin
    m_tpEvento :=aValue ;
end;

end.
