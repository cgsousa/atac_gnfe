use comercio
go

if exists (select *from dbo.sysobjects where id = object_id(N'sp_manifestodf00_add') and objectproperty(id, N'IsProcedure') = 1)
  drop procedure sp_manifestodf00_add
go

/*****************************************************************************
|* sp_manifestodf00_add
|*
|* PROPÓSITO: Registro de Alterações
******************************************************************************

Símbolo : Significado

[+]     : Novo recurso
[*]     : Recurso modificado/melhorado
[-]     : Correção de Bug (assim esperamos)

11.12.2018
[+] versão inicial

*/

create procedure sp_manifestodf00_add(
/*
* SP para gerar um MDF-e conforme parametros
* Atac Sistemas 
* Todos os Direitos Reservados
* Autor: Carlos Gonzaga
* Data: 11.12.2018
*/
  @codemp smallint ,
  @codufe smallint ,
  @tipamb smallint ,
  @tpemit smallint ,
  @tptransp smallint,
  @modal smallint ,
  @tpemis smallint,
  @verproc varchar(20),
  @ufeini char(2) ,
  @ufefim char(2) ,
  @rntrc varchar(8) ,
  @codvei smallint ,
  @codseq int out 
)
as
  declare @ret_codigo int; set @ret_codigo =0;
  declare @ret_noemit int ; set @ret_noemit =10103;
  declare @ret_nondoc int ; set @ret_nondoc =10109;
  declare @ret_exists int ; set @ret_exists =10111;
  
  declare @md0_codmod smallint; set @md0_codmod =58;
  declare @md0_nserie smallint; set @md0_nserie =1;
  declare @ser_ident varchar(50); set @ser_ident = '000';
  declare @md0_numdoc int;
  declare @md0_dhemis datetime; set @md0_dhemis =getdate();
  declare @md0_procemi smallint; set @md0_procemi =0 ;

  --//
  --// info do emitente
  declare @emi_cnpj varchar(14);
  select 
    @emi_cnpj =replace(replace(replace(e.cnpj,'.',''),'/',''),'-','')
  from loja e
  where e.codloja =@codemp;

  if @emi_cnpj is null 
  begin
    raiserror(N'CNPJ não cadastrado para o emitente codigo [%d]!', 16, 1, @codemp);
    return @ret_noemit;
  end;

  --//
  --// altera manifesto
  if exists(select 1 from manifestodf00 with(readpast) where md0_codseq =@codseq)
    update manifestodf00 set 
      md0_tipamb =@tipamb ,
      md0_tpemit =@tpemit ,
      md0_tptransp =@tptransp,
      md0_dhemis =@md0_dhemis,
      md0_tpemis =@tpemis,
      md0_dhviagem =@md0_dhemis,
      --//
      --// especifico p/ rodoviario
      md0_rntrc  =@rntrc  ,
      md0_codvei =@codvei
    where md0_codseq =@codseq

  --//
  --// emite novo manifesto
  else begin
    --//      
    --// gera numeração do doc. fiscal
    --// conforme cnpj/modelo/serie
    set @ser_ident =stuff(@ser_ident,4-len(@md0_nserie),len(@md0_nserie),@md0_nserie);  
    set @ser_ident ='mdfe.'+@emi_cnpj+'.nserie.'+ @ser_ident
    --if not exists (select *from genserial where ser_ident =@ser_ident)
    set @ser_ident ='[MDFE]'+@ser_ident ;
    exec sp_setval @ser_ident 
    exec sp_nextval @ser_ident, @md0_numdoc out, 0;

    --//
    --// se não gerou número do doc. fiscal
    if @md0_numdoc = 0 
    begin
      raiserror(N'Não foi possível gerar uma numeração para [%s]!', 16, 1, @ser_ident);
      return @ret_nondoc
    end;

    --//
    --// emite um novo manifesto
    insert into manifestodf00(md0_codemp,
                              --md0_versao varchar(20) null ,
                              md0_codufe ,
                              md0_tipamb ,
                              md0_tpemit ,
                              md0_tptransp ,
                              md0_codmod ,
                              md0_nserie ,
                              md0_numdoc ,
                              md0_modal ,
                              md0_dhemis ,
                              md0_tpemis ,
                              md0_procemi ,
                              md0_verproc ,
                              md0_ufeini ,
                              md0_ufefim ,
                              md0_dhviagem ,
                              md0_indcnlvrd ,
                              --//
                              --// especifico p/ rodoviario
                              md0_rntrc ,
                              md0_codvei)
    values                  ( @codemp ,
                              @codufe ,
                              @tipamb ,
                              @tpemit ,
                              @tptransp ,
                              @md0_codmod ,
                              @md0_nserie ,
                              @md0_numdoc ,
                              @modal ,
                              @md0_dhemis ,
                              @tpemis ,
                              @md0_procemi,
                              @verproc,
                              @ufeini ,
                              @ufefim ,
                              @md0_dhemis ,
                              null  ,
                              @rntrc  ,
                              @codvei );
    set @codseq =ident_current('manifestodf00');
  end
  --//
  return @ret_codigo;
  --//  
go




