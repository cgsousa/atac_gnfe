use comercio1
go

if exists (select *from dbo.sysobjects where id = object_id(N'sp_notfis00_busca') and objectproperty(id, N'IsProcedure') = 1)
  drop procedure sp_notfis00_busca
go

/*****************************************************************************
|* sp_notfis00_busca
|* 
|* PROPÓSITO: Registro de Alterações
******************************************************************************

Símbolo : Significado

[+]     : Novo recurso
[*]     : Recurso modificado/melhorado
[-]     : Correção de Bug (assim esperamos)

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
  @filtyp smallint, --//0-ATAC_APP_NFE,1-ATAC_SVC_NFE,2-SisGerCom
  @codseq int,
  @codped int,
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
    nf0_consumo	smallint);
  --//
  --// tabela totais da NF
  declare @tab_total table (codntf int not null 
    ,vBC numeric(12,2)  
    ,vICMS numeric(12,2)
    ,vFCP numeric(12,2)  
    ,vBCST numeric(12,2)    
    ,vST numeric(12,2)  --//(Somatório do valor do ICMS com Substituição Tributária de todos os produtos);
    ,vFCPST numeric(12,2)     
    ,vProd numeric(12,2)  --//(Somatório do valor de todos os produtos);
    ,vDesc numeric(12,2) --//(Somatório do desconto de todos os produtos);
    ,vFrete numeric(12,2)  --//(Somatório do valor do Frete de todos os produtos);
    ,vSeg numeric(12,2)  --//(Somatório do valor do seguro de todos os produtos);
    ,vOutro numeric(12,2)  --//(Somatório do valor de outras despesas de todos os produtos);
    ,vII numeric(12,2)  --//(Somatório do valor do Imposto de Importação de todos os produtos);
    ,vIPI numeric(12,2)  --//(Somatório do valor do IPI de todos os produtos);
    ,vIPIDevol numeric(12,2)    
    ,vPIS numeric(12,2)  
    ,vCOFINS numeric(12,2)      
    ,vServ numeric(12,2)  --//(Somatório do valor do serviço de todos os itens da NF-e);  
    ,vTrib numeric(12,2)    
    );  

  --//
  --// params sp_executesql
  declare @exec_sql nvarchar(1536); 
  declare @exec_prm nvarchar(226) ; set @exec_sql ='select ';

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
from notfis00 with(readpast) ';  
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
        --// def condição/params 
        set @exec_sql =@exec_sql  +N'where nf0_dtemis between @datini and @datfin '
        set @exec_prm =N'@datini smalldatetime, @datfin smalldatetime'
        
        --//
        --// chk status
        select @exec_sql =case 
          when @status = 0 then @exec_sql +N'and nf0_codstt in(0,1) '
          when @status = 1 then @exec_sql +N'and nf0_codstt =9 '
          when @status = 2 then @exec_sql +N'and nf0_codstt in(100,150) '
          when @status = 3 then @exec_sql +N'and nf0_codstt in(110,301,302,303) '
          when @status = 4 then @exec_sql +N'and nf0_codstt in(101,135,151,155,218) '
          when @status = 5 then @exec_sql +N'and nf0_codstt in(102, 563) '
          when @status = 9 then @exec_sql +N'and nf0_codstt not in(0,1,9,100,101,102,110,135,150,151,155,301,302,303) '
          end
        --//
        --// chk mod/ser 
        if @numser > 0 
        begin
          --//
          --// def condição, params e ordem desc
          set @exec_sql =@exec_sql  +N'and nf0_codmod =@codmod and nf0_nserie =@numser '          
          set @exec_prm =@exec_prm  +N', @codmod smallint, @numser smallint'
          set @exec_sql =@exec_sql  +N'order by nf0_codseq desc'        
          --//
          --// exec filtro: nf0_dtemis/[nf0_codstt]/nf0_codmod/nf0_nserie
          insert into @tab_notfis
          exec sp_executesql  @exec_sql, @exec_prm, 
                              @datini =@datini ,
                              @datfin =@datfin ,
                              @codmod =@codmod ,
                              @numser =@numser
        end
        --//
        --// exec filtro: nf0_dtemis/[nf0_codstt]
        else begin          
          set @exec_sql =@exec_sql  +N'order by nf0_codseq desc'        
          insert into @tab_notfis
          exec sp_executesql  @exec_sql, @exec_prm, 
                              @datini =@datini ,
                              @datfin =@datfin 
        end
      end
      --// load serviço
      else if @filtyp =1
      begin
        set @exec_sql =@exec_sql  +N'where nf0_dtemis between @datini and @datfin '
      end 
      --// load fecha cx
      else if @filtyp =2
      begin
        set @exec_sql =@exec_sql  +N'where nf0_dtemis between @datini and @datfin '
      end 
    end
    --//
    --// calc. totais
    insert into @tab_total(codntf,
                          vBC ,    
                          vICMS ,
                          vFCP,
                          vBCST ,    
                          vST ,
                          vFCPST,
                          vProd,
                          vDesc,
                          vFrete,
                          vSeg,
                          vOutro, 
                          vII ,
                          vIPI,
                          vIPIDevol,
                          vPIS ,
                          vCOFINS ,
                          vServ,
                          vTrib)
      select  nf0_codseq,          
              sum(isnull(nf1_vbc,0)),
              sum(isnull(nf1_vicms,0)),
              sum(isnull(nf1_vfcp,0)),
              sum(isnull(nf1_vbcst,0)),
              sum(isnull(nf1_vicmsst,0)),
              sum(isnull(nf1_vfcpst,0)),
              sum(isnull(nf1_vlrpro,0)),
              sum(isnull(nf1_vlrdesc,0)),
              sum(isnull(nf1_vlrfret,0)),
              sum(isnull(nf1_vlrsegr,0)),
              sum(isnull(nf1_vlroutr,0)),
              0.0 ,
              sum(isnull(nf1_vipi,0)),
              sum(isnull(nf1_vipidevol,0)),
              sum(isnull(nf1_vpis,0)),
              sum(isnull(nf1_vcofins,0)),
              0.0,
              0.0
      from @tab_notfis 
      left join notfis01 on nf0_codseq =nf1_codntf 
      group by nf0_codseq
    --//
    --// retorna lista
    select 
      nf.*, 
      tt.*,
      --// calc. total da NF
      ((tt.vProd -tt.vDesc)+
      tt.vST +tt.vFCPST +
      tt.vFrete +tt.vSeg +tt.vOutro +
      tt.vII +tt.vIPI +tt.vIPIDevol +
      tt.vServ) as vNF
    from @tab_notfis nf
    join @tab_total tt on nf0_codseq =codntf
  end try
  begin catch
    set @ret_codigo =error_number()
    set @err_msg =error_message()
  end catch
  --//
  --// retorno
  --// print @exec_sql
  return @ret_codigo ;
go
