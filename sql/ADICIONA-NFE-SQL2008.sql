use comercio1
go

if not exists(select 1from syscolumns where id = object_id('notfis00') and name = 'nf0_xmltyp')
  alter table notfis00 add nf0_xmltyp xml null
go

if exists (select *from dbo.sysobjects where id = object_id(N'sp_notfis00_busca') and objectproperty(id, N'IsProcedure') = 1)
  drop procedure sp_notfis00_busca
go

/*****************************************************************************
|* sp_notfis00_busca
|* 
|* PROP�SITO: Registro de Altera��es
******************************************************************************

S�mbolo : Significado

[+]     : Novo recurso
[*]     : Recurso modificado/melhorado
[-]     : Corre��o de Bug (assim esperamos)

19.07.2019
[*] Add cod.103 (Lote em processamento) no fintro do App/Svc, para o mesmo
    consulta o resultado do processamento para as NF preza na SEFAZ.

24.06.2019
[+] data inicial

*/


create procedure sp_notfis00_busca(
/*
* SP para ler as notas fiscais com base nos parametros
* Atac Sistemas 
* Todos os Direitos Reservados
* Autor: Carlos Gonzaga
* Data: 24.06.2019
*/  
  @codseq int,
  @codped int,
  @filtyp smallint, --//0-ATAC_APP_NFE,1-ATAC_SVC_NFE,2-SisGerCom
  @datini smalldatetime,
  @datfin smalldatetime,
  @status smallint , --//(0=DoneSend,1=Conting,2=Autoriza,3=Denega,4=Cancel,5=Inut,9=Error);
  @codmod smallint,
  @numser smallint,
  @topnum smallint,
  @err_msg varchar(250) out 
  )
as
  --//
  --// retorno
  declare @ret_sucess int; set @ret_sucess =0 ;
  declare @ret_codigo int; set @ret_codigo =@ret_sucess;
  declare @ret_noftyp int; set @ret_noftyp =10301 ;

  --//
  --// set default
  select @codseq =case when @codseq is null then 0 else @codseq end ;
  select @codped =case when @codped is null then 0 else @codped end ;
  select @filtyp =case when @filtyp is null then 0 else @filtyp end ;

  --//
  --// chk filtyp
  if(@codseq =0)and(@codped =0)
  begin
    if not (@filtyp in(0,1,2))
    begin
      raiserror(N'Tipo de filtro[%d] inv�lido!', 16, 1, @filtyp);
      return @ret_noftyp;      
    end
    --// 
    --// obriga (cchk params do servi�o    
  end;

  --@datini smalldatetime,
  --@datfin smalldatetime,
  --@status smallint , --//(0=DoneSend,1=Conting,2=Autoriza,3=Denega,4=Cancel,5=Inut,9=Error);

  declare @tab_notfis table (nf0_codseq int not null,
    nf0_codemp smallint not null ,
    nf0_codufe smallint not null ,
    nf0_natope varchar (60) not null,
    nf0_indpag smallint not null,
    nf0_codmod smallint not null,
    nf0_nserie smallint not null,
    nf0_numdoc int not null ,
    nf0_dtemis datetime not null ,
    nf0_dhsaient datetime null ,
    nf0_tipntf smallint not null default(1),
    nf0_indope smallint not null default(0),
    nf0_codmun int not null ,
    nf0_tipimp smallint not null,
    nf0_tipemi smallint not null,
    nf0_tipamb smallint not null,
    nf0_finnfe smallint not null,
    nf0_chvref char(44)  ,
    nf0_indfinal smallint,
    nf0_indpres smallint ,    
    nf0_procemi smallint not null default(0),
    nf0_verproc varchar(20),
    nf0_dhcont datetime null ,
    nf0_justif varchar(256),
    --// destino        
    nf0_dstcodigo int null,
    nf0_dsttippes smallint null,
    nf0_dstcnpjcpf varchar(14),
    nf0_dstidestra varchar(20),
    nf0_dstnome varchar(60),
    nf0_dstlogr varchar(60),
    nf0_dstnumero varchar(10),
    nf0_dstcomple varchar(60),
    nf0_dstbairro varchar(60),
    nf0_dstcodmun int ,
    nf0_dstmun varchar(60),
    nf0_dstufe char(2),
    nf0_dstcep int ,
    nf0_dstfone varchar(14),
    nf0_dstindie smallint ,
    nf0_dstie varchar(14),
    nf0_dstisuf varchar(9),
    nf0_dstemail varchar(60) ,
    
    --//
    --//transportes
    --//
    nf0_modFret smallint ,  
    nf0_tracnpjcpf varchar(14),
    nf0_tranome varchar(60),
    nf0_traie varchar(14),
    nf0_traend varchar(60),
    nf0_tramun varchar(60),
    nf0_traufe char(2),
    --//veiculo
    nf0_veiplaca varchar(10),
    nf0_veiufe char(2),
    nf0_veirntc varchar(10),
    --volume
    nf0_volqtd int ,
    nf0_volesp varchar(30) ,
    nf0_volmrc varchar(30) ,
    nf0_volnum varchar(30) ,
    nf0_volpsol numeric(12,3),
    nf0_volpsob numeric(12,3),

    --//status
    nf0_codstt smallint not null default 0 ,
    nf0_motivo varchar(250) ,
    
    --//envio
    nf0_chvnfe char(44) ,
    nf0_indsinc smallint not null default 0 ,
    
    --//retorno
    nf0_verapp varchar(20) ,
    nf0_dhreceb datetime ,
    nf0_numreci char(15)  , 
    nf0_numprot char(15) ,
    nf0_digval char(28)  ,
    --//
    nf0_infcpl varchar (2048) ,
    nf0_codped int ,
    nf0_consumo	smallint
    --//
    --// NF vinculada ao lote
    ,nf0_codlot int
    );

  --//
  --// params sp_executesql 3072
  declare @exec_sql nvarchar(2560); set @exec_sql =N'select ';
  declare @exec_prm nvarchar(512) ; --set @exec_prm =N'';

  --//
  --// inicializa EXEC
  if(@topnum > 0)
  begin
      set @exec_sql ='select top '+cast(@topnum as varchar);
  end

  --//
  --// completa EXEC
  set @exec_sql =@exec_sql +N'
  --//ide
  nf0_codseq ,
  nf0_codemp ,
  nf0_codufe , 
  nf0_natope ,
  nf0_indpag ,
  nf0_codmod ,
  nf0_nserie ,
  nf0_numdoc ,
  nf0_dtemis ,
  nf0_dhsaient,
  nf0_tipntf ,
  nf0_indope ,
  nf0_codmun ,
  nf0_tipimp ,
  nf0_tipemi ,
  nf0_tipamb ,
  nf0_finnfe ,
  nf0_chvref ,
  nf0_indfinal,
  nf0_indpres ,
  nf0_procemi ,
  nf0_verproc ,
  nf0_dhcont  ,
  nf0_justif  , 
  --//dest
  nf0_dstcodigo ,
  nf0_dsttippes ,
  nf0_dstcnpjcpf,
  nf0_dstidestra,
  nf0_dstnome ,
  nf0_dstlogr ,
  nf0_dstnumero,
  nf0_dstcomple,
  nf0_dstbairro,
  nf0_dstcodmun,
  nf0_dstmun ,
  nf0_dstufe ,
  nf0_dstcep ,
  nf0_dstfone,
  nf0_dstindie,
  nf0_dstie,  
  nf0_dstisuf ,
  nf0_dstemail, 
  --//transportes
  nf0_modfret  ,
  nf0_tracnpjcpf,
  nf0_tranome , 
  nf0_traie ,  
  nf0_traend , 
  nf0_tramun , 
  nf0_traufe , 
  nf0_veiplaca ,
  nf0_veiufe , 
  nf0_veirntc ,
  nf0_volqtd  ,
  nf0_volesp , 
  nf0_volmrc , 
  nf0_volnum , 
  nf0_volpsol ,
  nf0_volpsob ,  
  --//status
  nf0_codstt , 
  nf0_motivo , 
  nf0_chvnfe , 
  nf0_indsinc ,
  --//retorno
  nf0_verapp , 
  nf0_dhreceb ,
  nf0_numreci ,
  nf0_numprot ,
  nf0_digval  , 
  nf0_infcpl  ,
  nf0_codped  ,
  nf0_consumo 
  ,nf0_codlot
from notfis00 with(readpast) 
';  
  --//
  --// trata exception
  begin try
    --//
    --// carrega pelo ID
    if @codseq > 0
    begin    
      set @exec_sql =@exec_sql  +N'where nf0_codseq =@codseq '
      set @exec_prm =N'@codseq int'
      insert into @tab_notfis
      exec sp_executesql @exec_sql, @exec_prm, 
                          @codseq =@codseq      
    end
    --//
    --// carrega pelo CODPED
    else if @codped > 0
    begin    
      set @exec_sql =@exec_sql  +N'where nf0_codped =@codped '
      set @exec_prm =N'@codped int'
      insert into @tab_notfis
      exec sp_executesql @exec_sql, @exec_prm, 
                          @codped =@codped      
    end
    --//
    --// 
    else begin 
      --// load normal
      if @filtyp =0 
      begin
        --//
        --// set modelo e data para o indice(1)
        if @codmod > 0 
        begin          
          set @exec_sql =@exec_sql  +N'where nf0_codmod =@codmod 
          '          
          set @exec_prm =N'@codmod smallint, @datini smalldatetime, @datfin smalldatetime'
        end
        else begin
          set @exec_sql =@exec_sql  +N'where ((nf0_codmod =55)or(nf0_codmod =65))
          '
          set @exec_prm =N'@datini smalldatetime, @datfin smalldatetime'
        end

        --//
        --// set num.ser
        if @numser > 0
        begin
          set @exec_sql =@exec_sql  +N'and nf0_nserie =@numser 
          and nf0_dtemis between @datini and @datfin
          '          
          set @exec_prm =@exec_prm  +N', @numser smallint'
        end
        else           
          --//
          --// set data
          set @exec_sql =@exec_sql  +N'and nf0_dtemis between @datini and @datfin
          '        

        --//
        --// chk status
        select @exec_sql =case 
          when @status = 0 then @exec_sql +N'and nf0_codstt in(0,1) '
          when @status = 1 then @exec_sql +N'and nf0_codstt =9 '
          when @status = 2 then @exec_sql +N'and nf0_codstt in(100,150) '
          when @status = 3 then @exec_sql +N'and nf0_codstt in(110,301,302,303) '
          when @status = 4 then @exec_sql +N'and nf0_codstt in(101,135,151,155,218) '
          when @status = 5 then @exec_sql +N'and nf0_codstt in(102,206,563) '
          when @status = 9 then @exec_sql +N'and nf0_codstt not in(0,1,9,100,101,102,110,135,150,151,155,206,301,302,303) '
          else @exec_sql 
          end

        --//
        --// set ordem
        set @exec_sql =@exec_sql  +N'
        order by nf0_codseq desc'        

        --//
        --// 
        if @codmod > 0 
        begin
          --//
          --// exec filtro: nf0_codmod/nf0_nserie/nf0_dtemis/[nf0_codstt]
          if @numser > 0 
          begin          
            insert into @tab_notfis
            exec sp_executesql  @exec_sql, @exec_prm, 
                                @codmod =@codmod ,
                                @numser =@numser ,
                                @datini =@datini ,
                                @datfin =@datfin                               
                                
          end
          --//
          --// exec filtro: nf0_codmod/nf0_dtemis/[nf0_codstt]
          else begin
            insert into @tab_notfis
            exec sp_executesql  @exec_sql, @exec_prm, 
                                @codmod =@codmod ,
                                @datini =@datini ,
                                @datfin =@datfin 
          end
        end
        --//
        --//
        else begin
          --//
          --// exec filtro: nf0_nserie/nf0_dtemis/[nf0_codstt]
          if @numser > 0 
          begin          
            insert into @tab_notfis
            exec sp_executesql  @exec_sql, @exec_prm, 
                                @numser =@numser ,
                                @datini =@datini ,
                                @datfin =@datfin                               
                                
          end
          --//
          --// exec filtro: nf0_dtemis/[nf0_codstt]
          else begin
            insert into @tab_notfis
            exec sp_executesql  @exec_sql, @exec_prm, 
                                @datini =@datini ,
                                @datfin =@datfin 
          end
        end
      end

      --//
      --// load servi�o
      else if @filtyp =1
      begin
        --//
        --// chk modelo(condi��o)
        if @codmod > 0 
          set @exec_sql =@exec_sql  +N'where nf0_codmod =@codmod
          '
        else
          set @exec_sql =@exec_sql  +N'where nf0_codmod in(55,65)
          '
        set @exec_sql =@exec_sql  +N'and nf0_nserie =@numser
        '
        --//
        --//
        set @exec_sql =@exec_sql  +N'and ( (nf0_codstt =0)   --//status inicial       
or    (nf0_codstt =1)   --//pronto para envio    
or    (nf0_codstt =9)   --//contingencia         
or    (nf0_codstt =44)  --//pendente de retorno  
or    (nf0_codstt =77)  --//erro de schema       
or    (nf0_codstt =88)  --//erro nas regras de negocio
or    (nf0_codstt =103) --//lote em processamento
--//Rejei��o 204: Duplicidade de NF-e            
or    (nf0_codstt =204)                          
--//Rejei��o 217: NFe n�o consta na base de dados
or    (nf0_codstt =217)                          
--//Rejei��o 539: Duplicidade de NF-e, com diferen�a na Chave de Acesso
or    (nf0_codstt =539)                          
--//Rejei��o 613: Chave de Acesso difere da existente em BD (WS_CONSULTA)
or    (nf0_codstt =613)                          
--//Rejei��o 704: NFC-E com data-hora de emiss�o atrasada
or    (nf0_codstt =704)                          
or    (nf0_codstt =999))  --//erro geral sefaz   
--//
--// garante NF�s n�o alocadas pelo fech do CX
and   nf0_codlot is null
--//
--// coloca as notas com situa��o(0) na frente
order by nf0_codstt '
        --//
        --// exec filtro: mod/ser
        if @codmod > 0 
        begin
          set @exec_prm =N'@codmod smallint, @numser smallint'
          insert into @tab_notfis
          exec sp_executesql  @exec_sql, @exec_prm, 
                              @codmod =@codmod ,
                              @numser =@numser
        end
        --//
        --// exec filtro: ser
        else begin
          set @exec_prm =N'@numser smallint'
          insert into @tab_notfis
          exec sp_executesql  @exec_sql, @exec_prm, 
                              @numser =@numser
        end
      end 

      --//
      --// load fecha cx
      else if @filtyp =2
      begin
        --//
        --// set modelo para o indice(03)
          set @exec_sql =@exec_sql  +N'where ((nf0_codmod =55)or(nf0_codmod =65))
          '

        --//
        --// se informou periodo 
        if(@datini is not null)and(@datfin is not null)
        begin
          --//
          --// set serie e periodo
          set @exec_sql =@exec_sql  +N'and nf0_nserie =@numser 
          and nf0_dtemis between @datini and @datfin
          '

          --//
          --// inclui NFs uso autorizado/canceladas
          set @exec_sql =@exec_sql  +N'
          --//notas autorizado uso/canceladas
          and nf0_codstt in(100,150,101,151,135,155,218)
          order by nf0_codseq'
          
          --//
          --// exec filtro:
          set @exec_prm =N'@numser smallint, @datini smalldatetime, @datfin smalldatetime'
          insert into @tab_notfis
          exec sp_executesql  @exec_sql, @exec_prm, 
                              @numser =@numser ,
                              @datini =@datini ,
                              @datfin =@datfin                                 
          

        end
        else begin
          --//
          --// inc. serie & status
          set @exec_sql =@exec_sql  +N'and nf0_nserie =@numser 
          --//notas nao processadas 
          and nf0_codstt not in(0,100,110,150,301,302,303)
          --//notas nao canceladas
          and nf0_codstt not in(101,151,135,155,218)
          --//notas nao inutilizadas
          and nf0_codstt not in(102,206,563) 
          order by nf0_codseq'

          --//
          --// exec filtro:
          set @exec_prm =N'@numser smallint'
          insert into @tab_notfis
          exec sp_executesql  @exec_sql, @exec_prm, 
                              @numser =@numser
        end
      end 
    end

    --//
    --// result set
    select 
      nf.*,       
      tt.vBC,
      tt.vICMS,
      tt.vFCP,
      tt.vBCST,
      tt.vST,
      tt.vFCPST,
      tt.vProd,
      tt.vDesc,
      tt.vFret,
      tt.vSeg,
      tt.vOutr,
      tt.vIPI,
      tt.vIPIDevol,
      tt.vPIS,
      tt.vCOFINS,
      tt.vII,
      tt.vServ,
      tt.vTrib,
      --// calc. total da NF
      ((tt.vProd -tt.vDesc)+
      tt.vST +tt.vFCPST +
      tt.vFret +tt.vSeg +tt.vOutr +
      tt.vII +tt.vIPI +tt.vIPIDevol +
      tt.vServ) as vNF
    from @tab_notfis nf,
    ( select  nf0_codseq as codseq,          
              sum(isnull(nf1_vbc,0)) as vBC,
              sum(isnull(nf1_vicms,0)) as vICMS,
              sum(isnull(nf1_vfcp,0)) as vFCP,
              sum(isnull(nf1_vbcst,0)) as vBCST,
              sum(isnull(nf1_vicmsst,0)) as vST,
              sum(isnull(nf1_vfcpst,0)) as vFCPST,
              sum(isnull(nf1_vlrpro,0)) as vProd,
              sum(isnull(nf1_vlrdesc,0)) as vDesc,
              sum(isnull(nf1_vlrfret,0)) as vFret,
              sum(isnull(nf1_vlrsegr,0)) as vSeg,
              sum(isnull(nf1_vlroutr,0)) as vOutr,
              sum(isnull(nf1_vipi,0)) as vIPI,
              sum(isnull(nf1_vipidevol,0)) as vIPIDevol,
              sum(isnull(nf1_vpis,0)) as vPIS,
              sum(isnull(nf1_vcofins,0)) as vCOFINS
              ,0.0 as vII
              ,0.0 as vServ
              ,0.0 as vTrib
      from @tab_notfis 
      inner join notfis01 on nf0_codseq =nf1_codntf 
      group by nf0_codseq
    )tt
    where nf.nf0_codseq =tt.codseq
    --//
    --//print @exec_sql
  end try
  begin catch
    set @ret_codigo =error_number()
    set @err_msg =error_message()
  end catch
  --//
  --// retorno
  return @ret_codigo ;
go
