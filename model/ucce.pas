{***
* Classes/Tipos para tratar o evento da carta de correção da nfe
* Atac Sistemas
* Todos os direitos reservados
* Autor: Carlos Gonzaga
* Data: 22.08.2018
*}
unit ucce;

interface

uses
  Classes, SysUtils, DB, ADODB,
  Generics.Collections ,
  pcnConversao;

type
  TCEventoCCEList = class;
  TCEventoCCE = class(TPersistent)
  private
    m_parent: TCEventoCCEList ;
    m_index: Integer ;
  public
    m_codseq: Int32 ;
    m_versao: SmallInt;
    m_codorg: smallint;
    m_tipamb: TpcnTipoAmbiente;
    m_cnpj: string ;
    m_chvnfe: string ;
    m_dhevento: Tdatetime;
    m_tpevento: Int32 ;
    m_numseq: smallint;
    m_xcorrecao: string ;
    m_verapp: string ;
    m_codorgaut: smallint;
    m_codstt: smallint;
    m_motivo: string ;
    m_iddest: string ;
    m_emaildest: string ;
    m_dhreceb: Tdatetime;
    m_numprot: string ;
    function ExecuteInsert(): Boolean ;
    function getNextNumSeq: smallint;
  end;

  TCEventoCCEList =class(TList<TCEventoCCE>)
  private
  public
    function AddNew(): TCEventoCCE ;
    procedure Load(const chvnfe: string) ;
  end;



implementation

uses
  ACBrNFeNotasFiscais,
  pcnNFe, pcnConversaoNFe,
  //
  uadodb ;


{ TCEventoCCEList }

function TCEventoCCEList.AddNew: TCEventoCCE;
begin
    Result :=TCEventoCCE.Create ;
    Result.m_parent :=Self ;
    Result.m_index :=Self.Count ;
    Add(Result) ;
end;

procedure TCEventoCCEList.Load(const chvnfe: string) ;
var
  Q: TADOQuery ;
  C: TCEventoCCE ;
begin
    //
    //
    Self.Clear ;
    //
    Q :=TADOQuery.NewADOQuery();
    try
      Q.AddCmd('declare @chvnfe char(44); set @chvnfe =%s ;     ',[Q.FStr(chvnfe)]);
      Q.AddCmd('select *from eventocce where cce_chvnfe =@chvnfe');
      Q.AddCmd('order by cce_codseq desc') ;
      Q.Open ;
      while not Q.Eof do
      begin
          C :=Self.AddNew ;
          C.m_codseq  :=Q.Field('cce_codseq').AsInteger ;
          //
          // envio
          C.m_versao  :=Q.Field('cce_versao').AsInteger ;
          C.m_codorg  :=Q.Field('cce_codorg').AsInteger ;
          C.m_tipamb  :=TpcnTipoAmbiente(Q.Field('cce_tipamb').AsInteger) ;
          C.m_cnpj    :=Q.Field('cce_cnpj').AsString ;
          C.m_chvnfe  :=Q.Field('cce_chvnfe').AsString ;
          C.m_dhevento  :=Q.Field('cce_dhevento').AsDateTime ;
          C.m_tpevento  :=Q.Field('cce_tpevento').AsInteger ;
          C.m_numseq    :=Q.Field('cce_numseq').AsInteger ;
          C.m_xcorrecao :=Q.Field('cce_xcorrecao').AsString ;
          //
          // retorno
          C.m_verapp :=Q.Field('cce_verapp').AsString ;
          C.m_codorgaut :=Q.Field('cce_codorgaut').AsInteger ;
          C.m_codstt :=Q.Field('cce_codstt').AsInteger ;
          C.m_motivo :=Q.Field('cce_motivo').AsString ;
          C.m_iddest :=Q.Field('cce_iddest').AsString ;
          C.m_emaildest :=Q.Field('cce_emaildest').AsString ;
          C.m_dhreceb   :=Q.Field('cce_dhreceb').AsDateTime ;
          C.m_numprot   :=Q.Field('cce_numprot').AsString ;
          //
          // proximo
          Q.Next ;
      end;
    finally
      Q.Free ;
    end;
end;

{ TCEventoCCE }

function TCEventoCCE.ExecuteInsert: Boolean;
var
  C: TADOCommand ;
begin
    C :=TADOCommand.NewADOCommand() ;
    try
        C.AddCmd('declare @cce_versao smallint     ; set @cce_versao =null;');//,[m_versao]);
        C.AddCmd('declare @cce_codorg smallint     ; set @cce_codorg =%d;',[m_codorg]);
        C.AddCmd('declare @cce_tipamb smallint     ; set @cce_tipamb =%d;',[Ord(m_tipamb)]);
        C.AddCmd('declare @cce_cnpj varchar(14)    ; set @cce_cnpj   =%s;',[C.FStr(m_cnpj)]);
        C.AddCmd('declare @cce_chvnfe varchar(44)  ; set @cce_chvnfe =%s;',[C.FStr(m_chvnfe)]);
        C.AddCmd('declare @cce_corige varchar(1000); set @cce_corige =%s;',[C.FStr(m_xcorrecao)]);
        C.AddCmd('declare @cce_verapp varchar(20)  ; set @cce_verapp =%s;',[C.FStr(m_verapp)]);
        C.AddCmd('declare @cce_codorgaut smallint  ; set @cce_codorgaut =%d;',[m_codorgaut]);
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
        C.AddCmd('                      cce_verapp  ,');
        C.AddCmd('                      cce_codorgaut,');
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
        C.AddCmd('                      @cce_verapp  ,');
        C.AddCmd('                      @cce_codorgaut,');
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
            Result :=True ;
        except
            Result :=False ;
        end;

    finally
        C.Free ;
    end;
end;

function TCEventoCCE.getNextNumSeq: smallint;
var
  Q: TADOQuery ;
begin
    Q :=TADOQuery.NewADOQuery() ;
    try
        Q.AddCmd('declare @chvnfe char(44); set @chvnfe =%s ;         ',[Q.FStr(self.m_chvnfe)]);
        Q.AddCmd('select                                              ');
        Q.AddCmd('  cce_chvnfe,cce_tpevento,max(cce_numseq) as num_seq');
        Q.AddCmd('from eventocce                                      ');
        Q.AddCmd('where cce_chvnfe =@chvnfe                           ');
        Q.AddCmd('group by cce_chvnfe,cce_tpevento                    ');
        Q.Open ;
        if Q.IsEmpty then
            Result :=1
        else
            Result :=Q.Field('num_seq').AsInteger +1;
    finally
        Q.Free ;
    end;
end;

end.
