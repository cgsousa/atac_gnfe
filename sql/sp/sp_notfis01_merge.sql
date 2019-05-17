use comercio
go

if exists (select *from dbo.sysobjects where id = object_id(N'fn_getfcp') and objectproperty(id, N'IsScalarFunction') = 1)
  drop function fn_getfcp
go

create function fn_getfcp  
/*
* FN para ler a aliquota em fcp00 conforme uf 
* Atac Sistemas 
* Todos os Direitos Reservados
* Autor: Carlos Gonzaga
* Data: 02.08.2018
*/
(
  @ufe char(2)
) returns numeric(5,2)
as
begin
  declare @codufe smallint ;
  declare @result numeric(5,2);
  --//
  select @codufe =case 
      --// regiao NORTE
                when @ufe ='RO' then 11
                when @ufe ='AC' then 12
                when @ufe ='AM' then 13
                when @ufe ='RR' then 14
                when @ufe ='PA' then 15
                when @ufe ='AP' then 16
                when @ufe ='TO' then 17
      --// Região Nordeste
                when @ufe ='MA' then 21
                when @ufe ='PI' then 22
                when @ufe ='CE' then 23
                when @ufe ='RN' then 24 
                when @ufe ='PB' then 25
                when @ufe ='PE' then 26
                when @ufe ='AL' then 27
                when @ufe ='SE' then 28
                when @ufe ='BA' then 29
      --// Região Sudeste
                when @ufe ='MG' then 31
                when @ufe ='ES' then 32
                when @ufe ='RJ' then 33
                when @ufe ='SP' then 35
      --// Região Sul
                when @ufe ='PR' then 41
                when @ufe ='SC' then 42
                when @ufe ='RS' then 43
      --// Região Centro-Oeste
                when @ufe ='MS' then 50
                when @ufe ='MT' then 51
                when @ufe ='GO' then 52
                when @ufe ='DF' then 53
              end;   
  --//                  
  select
    @result =cp0_aliquo
  from fcp00
  where cp0_codufe =@codufe;
  --//
  return @result;
end
go

if exists (select *from dbo.sysobjects where id = object_id(N'fn_getaliqicms') and objectproperty(id, N'IsScalarFunction') = 1)
  drop function fn_getaliqicms
go

create function fn_getaliqicms  
/*
* FN para ler a aliquota do ICMS interestadual conforme uf origem/destino
* Atac Sistemas 
* Todos os Direitos Reservados
* Autor: Carlos Gonzaga
* Data: 27.09.2018
*/
(
  @ufe_orig char(2) ,
  @ufe_dest char(2)
) returns numeric(5,2)
as
begin
  declare @result numeric(5,2);
  --//
  select @result =case 
    --// regiao NORTE
              when @ufe_dest ='RO' then icm_ro
              when @ufe_dest ='AC' then icm_ac
              when @ufe_dest ='AM' then icm_am
              when @ufe_dest ='RR' then icm_rr
              when @ufe_dest ='PA' then icm_pa
              when @ufe_dest ='AP' then icm_ap
              when @ufe_dest ='TO' then icm_to
    --// Região Nordeste
              when @ufe_dest ='MA' then icm_ma
              when @ufe_dest ='PI' then icm_pi
              when @ufe_dest ='CE' then icm_ce
              when @ufe_dest ='RN' then icm_rn
              when @ufe_dest ='PB' then icm_pb
              when @ufe_dest ='PE' then icm_pe
              when @ufe_dest ='AL' then icm_al
              when @ufe_dest ='SE' then icm_se
              when @ufe_dest ='BA' then icm_ba
    --// Região Sudeste
              when @ufe_dest ='MG' then icm_mg
              when @ufe_dest ='ES' then icm_es
              when @ufe_dest ='RJ' then icm_rj
              when @ufe_dest ='SP' then icm_sp
    --// Região Sul
              when @ufe_dest ='PR' then icm_pr
              when @ufe_dest ='SC' then icm_sc
              when @ufe_dest ='RS' then icm_rs
    --// Região Centro-Oeste
              when @ufe_dest ='MS' then icm_ms
              when @ufe_dest ='MT' then icm_mt
              when @ufe_dest ='GO' then icm_go
              when @ufe_dest ='DF' then icm_df
            end
  from icmsintest
  where icm_uf =@ufe_orig
  --//
  return @result;
end
go


if exists (select *from dbo.sysobjects where id = object_id(N'sp_notfis01_merge') and objectproperty(id, N'IsProcedure') = 1)
  drop procedure sp_notfis01_merge
go

/*****************************************************************************
|* sp_notfis01_merge
|*
|* PROPÓSITO: Registro de Alterações
******************************************************************************

Símbolo : Significado

[+]     : Novo recurso
[*]     : Recurso modificado/melhorado
[-]     : Correção de Bug (assim esperamos)

12.03.2019
[*] Implementa finalidades complementar/ajuste (zerando valores dos produtos)

04.01.2019
[-] Percentual provisório de partilha do ICMS Interestadual (apartir de jan/2019 sera 100%)

01.10.2018
[*] O rateio do desconto nos itens so é calc. para o campo (venda.desconto) e não 
    mais para a soma (venda.desconto +venda.totaldesci) 

26.09.2018
[*] Calc. da ST com base na MVA informada no cad.produto

29.08.2018
[+] Novo parametro (@pro_codint) que fixa o cod. do produto:
    0-codigo de barras;
    1-codigo interno do produto.
*/

create procedure sp_notfis01_merge(
/*
* SP para manipular os items da nota fiscal (notfis00)
* Atac Sistemas 
* Todos os Direitos Reservados
* Autor: Carlos Gonzaga
* Data: 30.07.2018
*/
  @ins_upd smallint, --//0-insert, 1-update  
  @cod_seq int ,
  @pro_nomrdz smallint ,
  @pro_codint smallint 
  )
as
  
  declare @ret_codigo int; set @ret_codigo =0; 
  declare @ret_noped int ; set @ret_noped =10110;
  declare @ret_noitms int ; set @ret_noitms =10201;

  --//
  --// dados da capa NF
  declare 
    @nf0_codped int ,
    @nf0_codufe smallint ,
    @nf0_codmod smallint ,
    @nf0_finnfe smallint ,
    @nf0_indfinal smallint,
    @nf0_emicrt smallint,
    @nf0_emiufe char(2) ,
    @nf0_dstufe char(2) ,
    @nf0_dstindie smallint,
    @nf0_dtemis datetime
    ;
    
  --//
  --// pedido(venda)
  declare 
    @cod_fop smallint ,
    @tot_desc numeric(12,2),
    @inc_fret smallint ,
    @tot_fret numeric(12,2),
    @tot_outr numeric(12,2)
    ;

  --//
  --// /items(detvenda)
  declare
    @codint int,
    @codpro int,
    @codbar varchar(14),
    @despro varchar(120),
    @rdzpro varchar(120),
    @codncm varchar(8),
    @codest varchar(8),
    @cfop smallint,
    @undcom varchar(6),
    @qtdcom numeric(12,4),
    @vlrcom numeric(15,6),
    @cst smallint,
    @csosn smallint,
    @origem smallint,
    @modbc smallint,
    @predbc numeric(5,2), 
    @vbc numeric(15,2),
    @picms numeric(5,2),
    @vicms numeric(12,2),
    @modbcst smallint,
    @pmvast numeric(5,2), 
    @predbcst numeric(5,2), 
    @cenqipi varchar(5) ,
    @cstipi smallint,
    @vbcipi numeric(12,2),
    @pipi numeric(5,2),
    @vipi numeric(12,2),
    @cstpis smallint, 
    @vbcpis numeric(12,2),
    @ppis numeric(5,2),
    @vpis numeric(12,2),
    @cstcofins smallint,
    @vbccofins numeric(12,2),
    @pcofins numeric(5,2),
    @vcofins numeric(12,2),
    @infadpro varchar(250),
    @vlrdesc numeric(12,2)
    ;

  declare --// item - combustivel (ANP)
    @codanp int ,
    @descanp varchar(50) ,
    @pglp numeric(5,2) ,
    @pgnn numeric(5,2) ,
    @pgni numeric(5,2) ,
    @vpart numeric(12,2) 
    ;

  declare
    @itm_index smallint ,
    @tot_items smallint,
    @sum_qtd numeric(10,3),
    @fat_desc numeric(12,6),
    @sum_desc numeric(12,2),
    @per_desc numeric(5,2),
    @tot_vlrpro numeric(15,2),
    @itm_maxvlr numeric(12,2),
    @itm_maxcod int ,
    @pdesc_int smallint,
    @pdesc_fra numeric(5,2)
    ;

  declare
    @nf1_codpro varchar(15) ,
    @nf1_cfop smallint ,
    @nf1_vlrpro numeric(12,2),
    @nf1_vlrdesc numeric(12,2),
    @nf1_vlrfret numeric(12,2),
    @nf1_vlroutr numeric(12,2),
    @nf1_indtot smallint,
    @nf1_codean varchar(14)
    ;
  declare --//ICMS normal & ST
    @nf1_cst smallint ,
    @nf1_csosn smallint ,  
    @nf1_orig smallint ,
    @nf1_modbc smallint ,
    @nf1_predbc numeric(5,2),
    @nf1_vbc numeric(15,2),
    @nf1_picms numeric(5,2),
    @nf1_vicms numeric(15,2),
    @nf1_modbcst smallint ,
    @nf1_pmvast numeric(5,2),
    @nf1_predbcst numeric(5,2),
    @nf1_vbcst numeric(15,2),
    @nf1_picmsst numeric(5,2),
    @nf1_vicmsst numeric(15,2),
    @nf1_vbcstret numeric(15,2),
    @nf1_vicmsstret numeric(15,2),
    @nf1_pcredsn numeric(5,2),
    @nf1_vcredicmssn numeric(13,2)
    ;

  --//
  --// Fundo de Combate à Pobreza (FCP)
  declare
    @fcp_aliint numeric(5,2),
    @fcp_alidest numeric(5,2),
    @nf1_vbcfcp numeric(15,2),
    @nf1_pfcp numeric(5,2),
    @nf1_vfcp numeric(15,2),
    @nf1_vbcfcpst numeric(15,2),
    @nf1_pfcpst numeric(5,2),
    @nf1_vfcpst numeric(15,2),
    @nf1_pst numeric(5,2),
    @nf1_vbcfcpstret numeric(12,2),
    @nf1_pfcpstret numeric(5,2),
    @nf1_vfcpstret numeric(12,2)
    ;

  --//
  --//ICMS Efetivo
  declare
    @nf1_predbcefet numeric(5,2) ,
    @nf1_vbcefet numeric(12,2),
    @nf1_picmsefet numeric(5,2),
    @nf1_vicmsefet numeric(12,2)
    ;    
  
  --//
  --// Grupo de Repasse do ICMS ST
  declare
    @nf1_vbcstdest numeric(15,2),
    @nf1_vicmsstdest numeric(15,2)
    ; 

  --//
  --// Grupo a ser informado nas vendas interestaduais para
  --// consumidor final, não contribuinte do ICMS.
  declare
    @vdifal numeric(12,2),
    @vdifal_orig numeric(12,2),
    @vdifal_dest numeric(12,2);
  declare
    @nf1_vbcufdest numeric(12,2) ,
    @nf1_vbcfcpufdest numeric(12,2) ,
    @nf1_pfcpufdest numeric(5,2) ,
    @nf1_picmsufdest numeric(5,2) ,
    @nf1_picmsinter numeric(5,2)  ,
    @nf1_picmsinterpart numeric(5,2) ,
    @nf1_vfcpufdest numeric(12,2) ,
    @nf1_vicmsufdest numeric(12,2) ,
    @nf1_vicmsufremet numeric(12,2) 
    ; 
    
  --//
  --// Grupo imposto devolvido
  declare
    @nf1_pdevol numeric(5,2) ,
    @nf1_vipidevol numeric(15,2) 
    ; 


  --//  
  --//IBPT
  declare
    @nf1_ibptaliqnac numeric(5,2),
    @nf1_ibptaliqimp numeric(5,2),
    @nf1_ibptaliqest numeric(5,2),
    @nf1_ibptaliqmun numeric(5,2)
    ;

  declare @mva_ajust numeric(5,2) ;
  --//
  --// SQL dinamico para obter a aliquota interestadual
  declare @sql_icms nvarchar(250),
          @prm_def nvarchar(100),
          --@icm_intest numeric(5,2),
          @alq_inter numeric(5,2),
          @alq_orig numeric(5,2),
          @alq_dest numeric(5,2)
          ;
 
  --//
  --// ler dados da capa NF
  select 
    @nf0_codped =nf0_codped,
    @nf0_codufe =nf0_codufe,
    @nf0_codmod =nf0_codmod,
    @nf0_finnfe =nf0_finnfe,
    @nf0_indfinal =nf0_indfinal,
    @nf0_emicrt =nf0_emicrt,
    @nf0_emiufe =nf0_emiufe,
    @nf0_dstufe =nf0_dstufe,
    @nf0_dstindie=nf0_dstindie ,
    @nf0_dtemis =nf0_dtemis
  from notfis00
  where nf0_codseq =@cod_seq;

  --//
  --// nenhum pedido encontrado !
  if @nf0_codped is null 
  begin
    raiserror(N'sp_notfis01_merge|Nenhum pedido encontrado para [cod_seq:%d]!', 16, 1, @cod_seq)
    return @ret_noped
  end;
  
  --//
  --// ler totais da capa pedido(venda)
  select 
    @cod_fop  =v.cfop , 
    @tot_desc =isnull(v.desconto,0), -- +isnull(v.totaldesci,0) ,
    @inc_fret =v.incvalorfrete,
    @tot_fret =isnull(v.frete,0) ,
    @tot_outr =isnull(v.totala,0) +isnull(v.valortxentrega,0)
  from venda v 
  where v.codvenda =@nf0_codped

  select 
    @sum_qtd  =sum(qts),
    @tot_items =count(coddetvenda),
    @tot_vlrpro =sum(qts *preco)
  from detalhevenda dv 
  where dv.codvenda =@nf0_codped

  --//
  --//caso não encontra, busca na histdetalhevenda
  if @tot_items = 0
  begin
    select 
      @cod_fop  =v.cfop , 
      @tot_desc =isnull(v.desconto,0), -- +isnull(v.totaldesci,0) ,
      @inc_fret =v.incvalorfrete,
      @tot_fret =isnull(v.frete,0) ,
      @tot_outr =isnull(v.totala,0) +isnull(v.valortxentrega,0)
    from histvenda v 
    where v.codvenda =@nf0_codped
    --//
    select 
      @sum_qtd  =sum(qts),
      @tot_items =count(coddetvenda),
      @tot_vlrpro =sum(qts *preco)
    from histdetalhevenda dv 
    where dv.codvenda =@nf0_codped
  end;

  --//
  --// nenhum item encontrado !
  if @tot_items = 0 
  begin
    raiserror(N'sp_notfis01_merge|Nenhum item encontrado para [cod_ped:%d]!', 16, 1, @nf0_codped)
    return @ret_noitms
  end;
  
  --//items(det.venda)
  declare crs_pedido01 cursor local forward_only for
    select 
      i.coddetvenda as codint ,
      i.codproduto as codpro,
      p.codbarra as codbar,
      p.nome as despro ,
      p.nomereduzido as rdzpro ,
      p.ncm as codncm,
      p.cest as codest ,
      p.cfop as cfop ,
      p.unidade as undcom ,
      i.qts as qtdcom ,
      i.preco as vlrcom ,
      i.descontototal ,
      p.csosn as csosn  ,
      p.situacaotrib as cst, 
      cast(p.origem as smallint) as origem ,
      i.modalidadebcicms as modbc ,
      case  when charindex(',',i.rbc) > 0 then 
              stuff(i.rbc,charindex(',',i.rbc),1,'.')
            when i.rbc = '' then null
            else i.rbc
      end as predbc ,
      i.baseicms as vbc ,
      case  when charindex(',',i.aliquotaicms) > 0 then 
              stuff(i.aliquotaicms,charindex(',',i.aliquotaicms),1,'.')
            when i.aliquotaicms = '' then null
            else i.aliquotaicms
      end as picms ,
      i.valoricms as vicms ,
      i.modalidadebcicmsst as modbcst ,
      case  when charindex(',',i.mva) > 0 then 
              stuff(i.mva,charindex(',',i.mva),1,'.')
            when i.mva = '' then null
            else i.mva
      end as pmvast , 
      case  when charindex(',',i.rbcst) > 0 then 
              stuff(i.rbcst ,charindex(',',i.rbcst),1,'.')
            when i.rbcst = '' then null
            else i.rbcst
      end as predbcst ,
      '999' as cenqipi ,
      99 as cstipi ,
      i.baseipi as vbcipi ,
      case  when charindex(',',i.aliquotaipi) > 0 then 
              stuff(i.aliquotaipi,charindex(',',i.aliquotaipi),1,'.')
            when i.aliquotaipi = '' then null
            else i.aliquotaipi
      end as pipi ,
      i.valoripi as vipi ,
      p.piscst as cstpis , 
      i.basepis as vbcpis ,
      case  when charindex(',',i.aliquotapis) > 0 then 
              stuff(i.aliquotapis,charindex(',',i.aliquotapis),1,'.')
            when i.aliquotapis = '' then null
            else i.aliquotapis
      end as ppis ,
      i.valorpis as vpis ,
      p.confinscst as cstcofins ,
      i.basecofins as vbccofins ,
      case  when charindex(',',i.aliquotacofins) > 0 then 
              stuff(i.aliquotacofins,charindex(',',i.aliquotacofins),1,'.')
            when i.aliquotacofins = '' then null
            else i.aliquotacofins
      end as pcofins ,
      i.valorcofins as vcofins
       
      --//anp
      ,p.codanp
      ,p.anp_pglp 
      ,p.anp_pgnn
      ,p.anp_pgni
      ,p.anp_vpart  

      --// inf. ad do produto
      ,i.numerodeserie 
       
    from detalhevenda i 
    inner join produto p on p.codproduto = i.codproduto
    where i.codvenda = @nf0_codped

  --//histdetalhevenda
  union all
    select 
      i.coddetvenda as codint ,
      i.codproduto as codpro,
      p.codbarra as codbar,
      p.nome as despro ,
      p.nomereduzido as rdzpro ,
      p.ncm as codncm,
      p.cest as codest ,
      p.cfop as cfop ,
      p.unidade as undcom ,
      i.qts as qtdcom ,
      i.preco as vlrcom ,
      i.descontototal ,
      p.csosn as csosn  ,
      p.situacaotrib as cst, 
      cast(p.origem as smallint) as origem ,
      i.modalidadebcicms as modbc ,
      case  when charindex(',',i.rbc) > 0 then 
              stuff(i.rbc,charindex(',',i.rbc),1,'.')
            when i.rbc = '' then null
            else i.rbc
      end as predbc ,
      i.baseicms as vbc ,
      case  when charindex(',',i.aliquotaicms) > 0 then 
              stuff(i.aliquotaicms,charindex(',',i.aliquotaicms),1,'.')
            when i.aliquotaicms = '' then null
            else i.aliquotaicms
      end as picms ,
      i.valoricms as vicms ,
      i.modalidadebcicmsst as modbcst ,
      case  when charindex(',',i.mva) > 0 then 
              stuff(i.mva,charindex(',',i.mva),1,'.')
            when i.mva = '' then null
            else i.mva
      end as pmvast , 
      case  when charindex(',',i.rbcst) > 0 then 
              stuff(i.rbcst ,charindex(',',i.rbcst),1,'.')
            when i.rbcst = '' then null
            else i.rbcst
      end as predbcst ,
      '999' as cenqipi ,
      99 as cstipi ,
      i.baseipi as vbcipi ,
      case  when charindex(',',i.aliquotaipi) > 0 then 
              stuff(i.aliquotaipi,charindex(',',i.aliquotaipi),1,'.')
            when i.aliquotaipi = '' then null
            else i.aliquotaipi
      end as pipi ,
      i.valoripi as vipi ,
      p.piscst as cstpis , 
      i.basepis as vbcpis ,
      case  when charindex(',',i.aliquotapis) > 0 then 
              stuff(i.aliquotapis,charindex(',',i.aliquotapis),1,'.')
            when i.aliquotapis = '' then null
            else i.aliquotapis
      end as ppis ,
      i.valorpis as vpis ,
      p.confinscst as cstcofins ,
      i.basecofins as vbccofins ,
      case  when charindex(',',i.aliquotacofins) > 0 then 
              stuff(i.aliquotacofins,charindex(',',i.aliquotacofins),1,'.')
            when i.aliquotacofins = '' then null
            else i.aliquotacofins
      end as pcofins ,
      i.valorcofins as vcofins 

      --//anp
      ,p.codanp
      ,p.anp_pglp 
      ,p.anp_pgnn
      ,p.anp_pgni
      ,p.anp_vpart  

      --// inf. ad do produto
      ,i.numerodeserie 

    from histdetalhevenda i 
    inner join produto p on p.codproduto = i.codproduto
    where i.codvenda =@nf0_codped ;

  
  --//
  --// % efetivo do desconto
  set @per_desc =(@tot_desc /@tot_vlrpro) *100;
  set @pdesc_int =convert(smallint, @per_desc )
  set @pdesc_fra =@per_desc -@pdesc_int ;

  set @sum_desc =0;
  set @nf1_vlrfret =@tot_fret;
  set @nf1_vlroutr =@tot_outr;
  set @nf1_indtot =0; --//soma valor do item no total da NF

  set @itm_index =1;
  set @itm_maxvlr =0;
  set @itm_maxcod =0;

  --//
 --//ler items(det.venda)
  open crs_pedido01
  fetch next from crs_pedido01
  into @codint, --// Id da linha 
    @codpro, @codbar, @despro, @rdzpro, @codncm, @codest, @cfop, @undcom, @qtdcom, @vlrcom, @vlrdesc ,  --//produto
    @csosn, @cst, @origem, @modbc, @predbc, @vbc, @picms, @vicms, @modbcst, @pmvast, @predbcst, --//icms (normal/simples)   
    @cenqipi, @cstipi, @vbcipi, @pipi, @vipi, --//ipi
    @cstpis, @vbcpis, @ppis, @vpis, --//pis
    @cstcofins, @vbccofins, @pcofins, @vcofins, --//cofins
    @codanp, @pglp, @pgnn, @pgni, @vpart ,--//produto(item combustivel)  
    @infadpro
    ;

  --//
  --// qdo a finalidade não for devolução
  if @nf0_finnfe <> 3
  begin
    --//
    --// ler alíquota interestadual 
    select @alq_inter =dbo.fn_getaliqicms(@nf0_emiufe, @nf0_dstufe)    
  end
  --//
  --// devolução
  else begin
    --//
    --// ler alíquota interestadual 
    --select @alq_inter =dbo.fn_getaliqicms(@nf0_dstufe, @nf0_emiufe)
    set @alq_inter =@picms

    --//
    --// ler alíquota interna de origem
    --select @alq_orig =dbo.fn_getaliqicms(@nf0_dstufe, @nf0_dstufe)
 
    --//
    --// ler alíquota de destino
    --select @alq_dest =dbo.fn_getaliqicms(@nf0_emiufe, @nf0_emiufe)
  end;
  --//
  --// ler alíquota interna de origem
  select @alq_orig =dbo.fn_getaliqicms(@nf0_emiufe, @nf0_emiufe)
 
  --//
  --// ler alíquota de destino
  select @alq_dest =dbo.fn_getaliqicms(@nf0_dstufe, @nf0_dstufe)

  --//
  --// ler fcp
  select @fcp_aliint  =dbo.fn_getfcp(@nf0_emiufe);
  select @fcp_alidest =dbo.fn_getfcp(@nf0_dstufe);

   
  --//
  --// check cursor
  --print '@@fetch_status: '+ cast(@@fetch_status as varchar)
  set @ret_codigo =@@fetch_status ;

  while @@fetch_status = 0
  begin
    --//
    --// codigo do produto (interno)
    if @pro_codint > 0 
    begin
      set @nf1_codpro =@codpro   
    end

    --//
    --// codigo do produto (cod.barras)
    else begin
      set @nf1_codpro =@codbar
    end;

    --//
    --// chek GTIN 
    if(len(@codbar) in(8,12,13,14))and(charindex('789',@codbar)=1)
        set @nf1_codean =@codbar
    else
        set @nf1_codean ='SEM GTIN' ;

    --//nome reduzido
    if @pro_nomrdz = 1 
    begin
      set @despro =@rdzpro
    end;    

    --//CFOP
    if @nf0_dstufe = 'EX'
      set @nf1_cfop =@cod_fop
    else begin
      if @cod_fop = 5102
      begin
        if @nf0_emiufe = @nf0_dstufe
          set @nf1_cfop =@cfop
        else
          set @nf1_cfop =@cod_fop
      end
      else
        set @nf1_cfop =@cod_fop
    end;

    --//
    --// val. tot produto (valor da operação)
    set @nf1_vlrpro =@qtdcom *@vlrcom ;

    --//    
    --// desconto na nota     
    if @tot_desc > 0 
    begin
      --//    
      --// calc. desconto, conforme rateio     
      set @nf1_vlrdesc =(@nf1_vlrpro *@pdesc_int)/100
      set @sum_desc =@sum_desc +@nf1_vlrdesc
      --//
      --// verifica item de maior valor para somar a sobra(residuo)
      if @nf1_vlrpro > @itm_maxvlr
      begin
        set @itm_maxcod =@codint 
        set @itm_maxvlr =@nf1_vlrpro
      end
    end
    --//    
    --// desconto nos items     
    else begin
      set @nf1_vlrdesc =@vlrdesc --*@qtdcom  
      set @sum_desc =@sum_desc +@nf1_vlrdesc      
    end;

    set @codanp =isnull(@codanp, 0);
    
    --//
    --// Ler Aliquotas do IBPT
    select 
      @nf1_ibptaliqnac =aliqnac,
      @nf1_ibptaliqimp =aliqimp,
      @nf1_ibptaliqest =aliqest,
      @nf1_ibptaliqmun =aliqmun
    from olhonoimposto
    where codigo =@codncm

    --//reset ICMS 
    set @nf1_modbc=null ;
    set @nf1_vbc  =null ;
    --set @nf1_picms=null ;
    --//
    --// devolução
    if @nf0_finnfe = 3
    begin
      set @alq_inter =@picms    
    end
    set @nf1_vicms=null ;
    set @nf1_modbcst =null;
    set @nf1_pmvast=null  ;
    set @nf1_predbcst=null;
    set @nf1_vbcst =null  ;
    set @nf1_picmsst=null ;
    set @nf1_vicmsst=null ;
    set @nf1_vbcstret =null ;
    set @nf1_vicmsstret=null;
    set @nf1_pcredsn =null;
    set @nf1_vcredicmssn =null;

    --// fcp
    set @nf1_vbcfcp =null;
    set @nf1_pfcp =null;
    set @nf1_vfcp =null;
    set @nf1_vbcfcpst =null;
    set @nf1_pfcpst =null;
    set @nf1_vfcpst =null;
    set @nf1_pst =null;
    set @nf1_vbcfcpstret =null;
    set @nf1_pfcpstret =null;
    set @nf1_vfcpstret =null
    ;
  
    --//ICMS Efetivo
    set @nf1_predbcefet =null;
    set @nf1_vbcefet =null;
    set @nf1_picmsefet =null;
    set @nf1_vicmsefet =null;    

    --//
    --// Grupo de Repasse do ICMS ST
    set @nf1_vbcstdest =null;
    set @nf1_vicmsstdest =null;

    --//
    --// Grupo a ser informado nas vendas interestaduais para
    --// consumidor final, não contribuinte do ICMS.
    set @nf1_vbcufdest =null;
    set @nf1_vbcfcpufdest =null;
    set @nf1_pfcpufdest =null;
    set @nf1_picmsufdest =null;
    set @nf1_picmsinter =null;
    set @nf1_picmsinterpart =null;
    set @nf1_vfcpufdest =null;
    set @nf1_vicmsufdest =null;
    set @nf1_vicmsufremet =null;

    --//
    --// Grupo imposto devolvido
    set @nf1_pdevol =null;
    set @nf1_vipidevol =null;
            
    --//
    --// não permite grupo IPI na NFC-e
    if @nf0_codmod = 65
    begin
      set @pipi =0
      set @vipi =0
    end;

    --//
    --// seta regime de tributação
    --// normal e/ou super simples
    if @nf0_emicrt = 2
    begin
      set @nf1_cst  =@cst
      set @nf1_csosn=null

      --//*************
      --//calc. do ICMS
      --//*************
      
      --//00-Tributada Integralmente
      if @nf1_cst = 00 
      begin
        set @nf1_modbc=@modbc
        --// O valor do IPI fará parte da BC 
        --// sempre que o produto for vendido diretamente para o consumidor final.     
        if @nf0_indfinal = 1
          set @nf1_vbc  =@nf1_vlrpro +@vipi 
        else
          set @nf1_vbc  =@nf1_vlrpro        
        
        set @nf1_picms=@alq_inter
        set @nf1_vicms=(@nf1_vbc *@nf1_picms)/100
        --//
        --// fcp
        set @nf1_pfcp =@fcp_aliint
        set @nf1_vfcp =(@nf1_vbc *@nf1_pfcp)/100
      end
      --//10-Tributada e com cobrança do ICMS por ST
      else if @nf1_cst = 10
      begin
        --//ICMS normal 
        set @nf1_modbc=@modbc
        --// O valor do IPI fará parte da BC 
        --// sempre que o produto for vendido diretamente para o consumidor final.     
        if @nf0_indfinal = 1
          set @nf1_vbc  =@nf1_vlrpro +@vipi 
        else
          set @nf1_vbc  =@nf1_vlrpro        
        set @nf1_picms=@alq_inter
        set @nf1_vicms=(@nf1_vbc *@nf1_picms)/100
        
        --//
        --// FCP normal
        set @nf1_pfcp =0
        set @nf1_vbcfcp =0
        set @nf1_vfcp =0 
                
        --//
        --// ICMS ST
        /*
        select @mva_ajust = case
                              --// preço tabelado
                              when @modbcst=0 then @pmvast  
                              --// Margem Valor Agregado
                              when @modbcst=4 then (( (1 +@pmvast/100) * ((1 -@alq_inter/100) / (1 -@alq_orig/100)) )-1 )*100 
                            else
                              0
                            end               
        --// calc. do MVA ajustada [(1+ MVA ST original) x (1 - ALQ inter) ÷ (1- ALQ intra)] -1
        */
        set @nf1_modbcst =@modbcst 
        set @nf1_pmvast =@pmvast
        set @nf1_predbcst=@predbcst
        set @nf1_vbcst  =(@nf1_vbc +@vipi)*(1 +@nf1_pmvast/100)
        set @nf1_picmsst=@alq_dest
        set @nf1_vicmsst=(@nf1_vbcst *@alq_dest)/100 -@nf1_vicms
        --//
        --// FCP ST
        set @nf1_vbcfcp =0 --@nf1_vbc
        set @nf1_pfcp =0 --@fcp_aliint
        set @nf1_vfcp =0 --(@nf1_vbcfcp *@nf1_pfcp)/100
        set @nf1_vbcfcpst =0 --@nf1_vbcfcp
        set @nf1_pfcpst =0--@alq_dest
        set @nf1_vfcpst =0--(@nf1_vbcfcpst *@nf1_pfcpst)/100        
      end
      --//20-Com redução de Base de Calculo
      else if @nf1_cst = 20
      begin
        set @nf1_modbc  =@modbc
        set @nf1_predbc =@predbc

        --// O valor do IPI fará parte da BC 
        --// sempre que o produto for vendido diretamente para o consumidor final.     
        if @nf0_indfinal = 1
          set @nf1_vbc  =@nf1_vlrpro +@vipi 
        else
          set @nf1_vbc  =@nf1_vlrpro        

        set @nf1_vbc    =@nf1_vbc -(@nf1_vbc *@nf1_predbc)/100
        set @nf1_picms  =@alq_inter   
        set @nf1_vicms  =(@nf1_vbc *@nf1_picms)/100
        --//
        --// FCP
        set @nf1_vbcfcp =@nf1_vbc
        set @nf1_pfcp =@fcp_aliint
        set @nf1_vfcp =(@nf1_vbcfcp *@nf1_pfcp)/100
      end
      --//30-Isenta ou não tributada e com cobrança do ICMS por substituição tributária
      else if @nf1_cst = 30
      begin
        set @nf1_picms=null
        set @nf1_modbcst =@modbcst 
        set @nf1_pmvast=@pmvast
        set @nf1_predbcst=@predbcst
        set @nf1_vbcst =0
        set @nf1_picmsst=@alq_inter
        set @nf1_vicmsst=0 
        --//
        --// FCP
        set @nf1_vbcfcpst =@nf1_vbcst
        set @nf1_pfcpst =@fcp_aliint
        set @nf1_vfcp =(@nf1_vbcfcpst *@nf1_pfcpst)/100
      end
      --//40-Isenta, 41-Não tributada, 50-Suspensão  
      else if @nf1_cst = 40
      begin
        set @nf1_picms=null
        set @nf1_modbc=null
        set @nf1_modbcst=null
      end
      --// 60-ICMS cobrado anteriormente por substituição tributária 
      else if @nf1_cst = 60
      begin
        set @nf1_picms=null
        --//
        --// Grupo de informação do ICMSST      
        if @codanp > 0
        begin
          set @nf1_vbcstret =@nf1_vlrpro
          set @nf1_vicmsstret=(@nf1_vbcstret *@alq_inter)/100
          set @nf1_vbcstdest =@nf1_vlrpro
          set @nf1_vicmsstdest=(@nf1_vbcstdest *(@alq_orig -@alq_inter))/100           
        end 
        else begin
          set @nf1_vbcstret =0
          set @nf1_vicmsstret=0
          if @nf0_indfinal = 1 
          begin
            set @nf1_predbcefet =@predbc;
            set @nf1_vbcefet =@nf1_vlrpro; 
            set @nf1_picmsefet =@alq_inter;
            set @nf1_vicmsefet =@nf1_vbcefet -(@nf1_vbcefet *@nf1_picmsefet)/100;
          end
        end
      end
      --//90-Outros
      else 
      begin
        set @nf1_cst = 90
        --//ICMS normal
        set @nf1_modbc  =@modbc
        set @nf1_predbc =isnull(@predbc,0)
        --// O valor do IPI fará parte da BC 
        --// sempre que o produto for vendido diretamente para o consumidor final.     
        if @nf0_indfinal = 1
          set @nf1_vbc  =@nf1_vlrpro +@vipi 
        else
          set @nf1_vbc  =@nf1_vlrpro
                      
        set @nf1_vbc    =@nf1_vbc -(@nf1_vbc *@nf1_predbc)/100
        set @nf1_picms  =@picms   
        set @nf1_vicms  =(@nf1_vbc *@nf1_picms)/100

        --//
        --// FCP
        set @nf1_vbcfcp =@nf1_vbc
        set @nf1_pfcp =@fcp_aliint
        set @nf1_vfcp =(@nf1_vbcfcp *@nf1_pfcp)/100
      end
    end
    
    --//
    --// Optante pelo Simples
    else 
    begin
      set @nf1_cst =null
      set @nf1_csosn =@csosn

      --//00-Tributada Integralmente
      --//20-Com redução de Base de Calculo
      if @nf1_csosn = 101 
      begin
        --//FALTA DEFINIR ICMS DO SN
        set @nf1_pcredsn =@alq_inter 
        set @nf1_vcredicmssn =(@nf1_vlrpro *@nf1_pcredsn)/100
        --print 'nf1_vlrpro: '+cast(@nf1_vlrpro as varchar)
        --print 'nf1_vcredicmssn: '+cast(@nf1_vcredicmssn as varchar)
      end
      --//40-Isenta, 41-Não tributada, 50-Suspensão, 51-Diferimento
      else if(@nf1_csosn = 102)or(@nf1_csosn = 103)or(@nf1_csosn = 300)or(@nf1_csosn = 400)
      begin 
        set @nf1_picms=null
        set @nf1_modbc=null
        set @nf1_modbcst=null
        set @nf1_pmvast=null
        set @nf1_predbcst=null        
      end
      --//
      else if @nf1_csosn = 201
      begin 
        set @nf1_picms=null
        set @nf1_modbcst =@modbcst
        set @nf1_pmvast=@pmvast 
        set @nf1_predbcst=@predbcst
        set @nf1_vbcst =0
        set @nf1_picmsst=0
        set @nf1_vicmsst=0 
        --//fcp
        set @nf1_vbcfcpst =0
        set @nf1_pfcpst =0
        set @nf1_vfcpst =0
        --//alíquota/icms aplicável de cálculo do crédito (Simples Nacional). (v2.0)
        set @nf1_pcredsn =0
        set @nf1_vcredicmssn =0
      end
      --//
      else if(@nf1_csosn = 202)or(@nf1_csosn = 203)
      begin 
        set @nf1_picms=null
        set @nf1_modbcst =@modbcst
        set @nf1_pmvast=@pmvast 
        set @nf1_predbcst=@predbcst
        set @nf1_vbcst =0
        set @nf1_picmsst=0
        set @nf1_vicmsst=0 
        --//fcp
        set @nf1_vbcfcpst =0
        set @nf1_pfcpst =0
        set @nf1_vfcpst =0
      end
      --//500-ICMS cobrado anteriormente por substituição tributária 
      else if @nf1_csosn = 500
      begin 
        set @nf1_picms=null
        --//
        --// Grupo de informação do ICMSST      
        if @codanp > 0
        begin
          set @nf1_vbcstret =@nf1_vlrpro
          set @nf1_vicmsstret=(@nf1_vbcstret *@alq_inter)/100
          set @nf1_vbcstdest =@nf1_vlrpro
          set @nf1_vicmsstdest=(@nf1_vbcstdest *(@alq_orig -@alq_inter))/100           
        end 
        else begin
          set @nf1_vbcstret =0
          set @nf1_vicmsstret=0
          if @nf0_indfinal = 1 
          begin
            set @nf1_predbcefet =@predbc;
            set @nf1_vbcefet =@nf1_vlrpro; 
            set @nf1_picmsefet =@alq_inter;
            set @nf1_vicmsefet =@nf1_vbcefet -(@nf1_vbcefet *@nf1_picmsefet)/100;
          end
        end
      end
      --//900-outros
      else begin
        set @nf1_csosn = 900
        --//ICMS normal
        set @nf1_modbc  =@modbc
        set @nf1_predbc =isnull(@predbc,0)
        --// O valor do IPI fará parte da BC 
        --// sempre que o produto for vendido diretamente para o consumidor final.     
        if @nf0_indfinal = 1
          set @nf1_vbc  =@nf1_vlrpro +@vipi 
        else
          set @nf1_vbc  =@nf1_vlrpro        
        set @nf1_vbc    =@nf1_vbc -(@nf1_vbc *@nf1_predbc)/100
        set @nf1_picms  =@picms   
        set @nf1_vicms  =(@nf1_vbc *@nf1_picms)/100
      end 
    end;

    --//
    --//     
    if(@nf0_codmod =55            )and
      (@nf0_emiufe <> @nf0_dstufe )and
      (@nf0_indfinal =1           )and
      (@nf0_dstindie =2           )
    begin

      --//
      --// zera o FCP normal
      set @nf1_vbcfcp =0;
      set @nf1_pfcp =0;
      set @nf1_vfcp =0;

      --// calcula a BC
      set @nf1_vbcufdest    =(@nf1_vlrpro -@nf1_vlrdesc) +@vipi;
      set @nf1_vbcfcpufdest =@nf1_vbcufdest;

      --// aliquota ao FCP na UF de destino
      set @nf1_pfcpufdest     =@fcp_alidest;
      --// Alíquota interna da UF de destino
      set @nf1_picmsufdest    =@alq_dest;
      --// Alíquota interestadual das UF envolvidas
      set @nf1_picmsinter     =@alq_inter;
      --// Percentual provisório de partilha do ICMS Interestadual (...)
      if year(@nf0_dtemis)>=2019
        set @nf1_picmsinterpart =100
      else
        set @nf1_picmsinterpart =80.00;

      --//
      --// Valor do ICMS relativo ao FCP da UF de destino
      set @nf1_vfcpufdest   =(@nf1_vbcfcpufdest *@nf1_pfcpufdest)/100;

      --//
      --// calculo do DIFAL
      set @vdifal =@nf1_vbcufdest *((@alq_dest -@alq_inter)/100);
      set @vdifal_orig =@vdifal *(0.20) ;
      set @vdifal_dest =@vdifal *(@nf1_picmsinterpart /100) ;

      --//
      --// Valor do ICMS Interestadual para a UF de destino
      set @nf1_vicmsufdest  =@vdifal_dest;
      --//
      --//  Valor do ICMS Interestadual para a UF do remetente (Origem)
      set @nf1_vicmsufremet =@vdifal_orig;       
    end ;
    
    --//
    --// qdo a finalidade for devolução
    --// zera imposto
    if @nf0_finnfe = 3
    begin
      set @nf1_pdevol =100;
      set @nf1_vipidevol =@vipi;
      set @vipi =0 
    end
    --//
    --// zera valores dos produtos qdo finalidade: 
    --// complementar/ajustes
    else if @nf0_finnfe in(1,2)
    begin      
      set @qtdcom =0
      set @vlrcom =0
      set @nf1_vlrpro=0
    end;

    select @infadpro =case when @infadpro is not null then 'NS: '+@infadpro else @infadpro end;


    --//
    --// insere items    
    if @ins_upd = 0 
    begin
      insert into notfis01 (nf1_codntf, nf1_codint, --//cod.interno
                            --//Produto
                            nf1_codpro, nf1_descri, nf1_codncm, nf1_codest, nf1_extipi, nf1_cfop, nf1_codintpro,
                            nf1_codean, nf1_undcom, nf1_qtdcom, nf1_vlrcom, nf1_vlrpro ,
                            nf1_eantrib, nf1_undtrib, nf1_qtdtrib, nf1_vlrtrib,
                            nf1_vlrfret, nf1_vlrsegr, nf1_vlrdesc, nf1_vlroutr, nf1_indtot, 
                            nf1_infadprod  ,
                            
                            --//ICMS 
                            nf1_cst ,
                            nf1_csosn ,  
                            nf1_orig ,
                            nf1_modbc ,
                            nf1_predbc ,
                            nf1_vbc ,
                            nf1_picms ,
                            nf1_vicms ,
                            nf1_modbcst ,
                            nf1_pmvast ,
                            nf1_predbcst ,
                            nf1_vbcst ,
                            nf1_picmsst ,
                            nf1_vicmsst ,
                            nf1_vbcstret ,
                            nf1_vicmsstret ,
                            nf1_pcredsn ,
                            nf1_vcredicmssn ,
                            
                            --//IPI
                            nf1_clenqipi ,
                            nf1_cnpjprodipi ,
                            nf1_cseloipi ,
                            nf1_qseloipi ,
                            nf1_cenqipi ,
                            nf1_cstipi ,
                            nf1_vbcipi ,
                            nf1_qunidipi ,
                            nf1_vunidipi ,
                            nf1_pipi ,
                            nf1_vipi ,
                            
                            --//PIS
                            nf1_cstpis ,
                            nf1_vbcpis ,
                            nf1_ppis ,
                            nf1_vpis ,
                            nf1_qbcprodpis , 
                            nf1_valiqprodpis , 
                            
                            --//COFINS
                            nf1_cstcofins ,
                            nf1_vbccofins ,
                            nf1_pcofins ,
                            nf1_vcofins ,
                            nf1_vbcprodcofins ,
                            nf1_valiqprodcofins ,
                            nf1_qbcprodcofins ,
                            
                            --//IBPT
                            nf1_ibptaliqnac,
                            nf1_ibptaliqimp,
                            nf1_ibptaliqest,
                            nf1_ibptaliqmun,

                            --//
                            --// FCP
                            nf1_vbcfcp ,
                            nf1_pfcp ,
                            nf1_vfcp ,
                            --nf1_vbcfcpst ,
                            --nf1_pfcpst ,
                            --nf1_vfcpst ,

                            --//cProdANP
                            nf1_codanp ,
                            --//
                            --// 
                            nf1_predbcefet ,
                            nf1_vbcefet ,
                            nf1_picmsefet ,
                            nf1_vicmsefet ,
                            nf1_vbcstdest ,
                            nf1_vicmsstdest ,
                            
                            --//
                            --//
                            nf1_vbcufdest ,
                            nf1_vbcfcpufdest ,
                            nf1_pfcpufdest  ,
                            nf1_picmsufdest  ,
                            nf1_picmsinter ,
                            nf1_picmsinterpart  ,
                            nf1_vfcpufdest  ,
                            nf1_vicmsufdest ,
                            nf1_vicmsufremet, 

                            --//
                            --// Grupo imposto devolvido
                            nf1_pdevol ,
                            nf1_vipidevol 
                            )
      values               (@cod_seq, @codint ,
                            @nf1_codpro, @despro, @codncm, @codest, null /*nf1_extipi*/, @nf1_cfop, @codpro ,
                            @nf1_codean , @undcom, @qtdcom, @vlrcom, @nf1_vlrpro,
                            @nf1_codean /*nf1_eantrib*/, @undcom /*nf1_undtrib*/, @qtdcom /*nf1_qtdtrib*/, @vlrcom /*nf1_vlrtrib*/,
                            @nf1_vlrfret, 0 /*nf1_vlrsegr*/, @nf1_vlrdesc, @nf1_vlroutr, @nf1_indtot,
                            @infadpro ,

                            --//ICMS 
                            @nf1_cst ,
                            @nf1_csosn ,  
                            @origem ,
                            @nf1_modbc ,
                            @nf1_predbc ,
                            @nf1_vbc ,
                            @nf1_picms ,
                            @nf1_vicms ,
                            @nf1_modbcst ,
                            @nf1_pmvast , 
                            @nf1_predbcst ,
                            @nf1_vbcst ,
                            @nf1_picmsst ,
                            @nf1_vicmsst ,
                            @nf1_vbcstret ,
                            @nf1_vicmsstret ,
                            @nf1_pcredsn ,
                            @nf1_vcredicmssn, 
                            
                            --//IPI
                            null, --nf1_clenqipi ,
                            null, --nf1_cnpjprodipi ,
                            null, --nf1_cseloipi ,
                            null, --nf1_qseloipi ,
                            null, --nf1_cenqipi ,
                            @cstipi ,
                            @vbcipi ,
                            null, --nf1_qunidipi ,
                            null, --nf1_vunidipi ,
                            @pipi ,
                            @vipi ,
                            
                            --//PIS
                            @cstpis ,
                            @vbcpis ,
                            @ppis ,
                            @vpis ,
                            null, --nf1_qbcprodpis , 
                            null, --nf1_valiqprodpis , 
                            
                            --//COFINS
                            @cstcofins ,
                            @vbccofins ,
                            @pcofins ,
                            @vcofins ,
                            null, --nf1_vbcprodcofins ,
                            null, --nf1_valiqprodcofins,
                            null, --nf1_qbcprodcofins ,

                            @nf1_ibptaliqnac,
                            @nf1_ibptaliqimp,
                            @nf1_ibptaliqest,
                            @nf1_ibptaliqmun, 
                            --//
                            --// FCP
                            @nf1_vbcfcp ,
                            @nf1_pfcp ,
                            @nf1_vfcp ,
                            --@nf1_vbcfcpst ,
                            --@nf1_pfcpst ,
                            --@nf1_vfcpst ,
                            --//cProdANP (grupo combustiveis)
                            @codanp ,
                            --//
                            --// 
                            @nf1_predbcefet ,
                            @nf1_vbcefet ,
                            @nf1_picmsefet ,
                            @nf1_vicmsefet ,
                            @nf1_vbcstdest ,
                            @nf1_vicmsstdest,

                            @nf1_vbcufdest ,
                            @nf1_vbcfcpufdest ,
                            @nf1_pfcpufdest  ,
                            @nf1_picmsufdest  ,
                            @nf1_picmsinter ,
                            @nf1_picmsinterpart  ,
                            @nf1_vfcpufdest  ,
                            @nf1_vicmsufdest ,
                            @nf1_vicmsufremet,
                            --//
                            --// Grupo imposto devolvido
                            @nf1_pdevol ,
                            @nf1_vipidevol                               
                            ) ;                           

    end

    --//
    --// atualiza items     
    else begin
      update notfis01 set 
        --//Produto
        nf1_codncm =@codncm, 
        nf1_codest =@codest, 
        nf1_cfop   =@nf1_cfop,
        nf1_codean =@nf1_codean, 
        nf1_undcom =@undcom, 
        nf1_qtdcom =@qtdcom, 
        nf1_vlrcom =@vlrcom, 
        nf1_vlrpro =@qtdcom *@vlrcom,
        nf1_eantrib=@nf1_codean, 
        nf1_undtrib=@undcom, 
        nf1_qtdtrib=@qtdcom, 
        nf1_vlrtrib=@vlrcom,
        nf1_vlrdesc=@nf1_vlrdesc,
        nf1_vlrfret=@nf1_vlrfret, 
        --nf1_vlrsegr=@nf1_vlrsegr, 
        nf1_vlroutr=@nf1_vlroutr, 
        --nf1_indtot=@nf1_indtot, 
        nf1_infadprod =@infadpro,

        --//ICMS 
        nf1_cst   =@nf1_cst ,
        nf1_csosn =@nf1_csosn ,  
        nf1_orig =@origem ,
        nf1_modbc =@nf1_modbc ,
        nf1_predbc =@nf1_predbc ,
        nf1_vbc =@nf1_vbc ,
        nf1_picms =@nf1_picms ,
        nf1_vicms =@nf1_vicms ,
        nf1_modbcst =@nf1_modbcst ,
        nf1_pmvast =@nf1_pmvast ,
        nf1_predbcst =@nf1_predbcst ,
        nf1_vbcst =@nf1_vbcst ,
        nf1_picmsst =@nf1_picmsst ,
        nf1_vicmsst =@nf1_vicmsst ,
        nf1_vbcstret =@nf1_vbcstret ,
        nf1_vicmsstret =@nf1_vicmsstret ,
        nf1_pcredsn =@nf1_pcredsn ,
        nf1_vcredicmssn =@nf1_vcredicmssn, 

        --//IPI
        nf1_cstipi =@cstipi ,
        nf1_vbcipi =@vbcipi ,
        nf1_pipi =@pipi ,
        nf1_vipi =@vipi ,
        
        --//PIS
        nf1_cstpis =@cstpis ,
        nf1_vbcpis =@vbcpis ,
        nf1_ppis =@ppis ,
        nf1_vpis =@vpis ,
        
        --//COFINS
        nf1_cstcofins =@cstcofins ,
        nf1_vbccofins =@vbccofins ,
        nf1_pcofins =@pcofins ,
        nf1_vcofins =@vcofins ,
        
        --//IBPT
        nf1_ibptaliqnac =@nf1_ibptaliqnac,
        nf1_ibptaliqimp =@nf1_ibptaliqimp,
        nf1_ibptaliqest =@nf1_ibptaliqest,
        nf1_ibptaliqmun =@nf1_ibptaliqmun,

        --//
        --// FCP
        nf1_vbcfcp =@nf1_vbcfcp,
        nf1_pfcp =@nf1_pfcp,
        nf1_vfcp =@nf1_vfcp,
        nf1_vbcfcpst =@nf1_vbcfcpst,
        nf1_pfcpst =@nf1_pfcpst,
        nf1_vfcpst =@nf1_vfcpst ,

        --//
        --// item / combustivel (cProdANP)
        nf1_codanp =@codanp

        --//
        --// 
        ,nf1_predbcefet =@nf1_predbcefet 
        ,nf1_vbcefet =@nf1_vbcefet 
        ,nf1_picmsefet =@nf1_picmsefet 
        ,nf1_vicmsefet =@nf1_vicmsefet 
        ,nf1_vbcstdest =@nf1_vbcstdest 
        ,nf1_vicmsstdest =@nf1_vicmsstdest

        ,nf1_vbcufdest    =@nf1_vbcufdest 
        ,nf1_vbcfcpufdest =@nf1_vbcfcpufdest
        ,nf1_pfcpufdest  =@nf1_pfcpufdest
        ,nf1_picmsufdest =@nf1_picmsufdest
        ,nf1_picmsinter =@nf1_picmsinter
        ,nf1_picmsinterpart =@nf1_picmsinterpart  
        ,nf1_vfcpufdest =@nf1_vfcpufdest  
        ,nf1_vicmsufdest =@nf1_vicmsufdest
        ,nf1_vicmsufremet =@nf1_vicmsufremet
        
        --//
        --// Grupo imposto devolvido
        ,nf1_pdevol =@nf1_pdevol 
        ,nf1_vipidevol =@nf1_vipidevol 
        
      where nf1_codntf =@cod_seq
      and   nf1_codint =@codint;   
            
    end;

    --//
    --// item / combustivel
    if @codanp > 0 
    begin
      --//
      --// busca descricao ANP
      select @descanp =anp_descri
      from cadanp 
      where anp_codigo =@codanp
      
      --//
      --// update info especificas de combustiveis
      update notfis02comb set 
        nf2_codanp =@codanp,
        nf2_descri =@descanp,
        nf2_pglp =@pglp,
        nf2_pgnn =@pgnn,
        nf2_pgni =@pgni,
        nf2_vpart =@vlrcom,
        nf2_ufcons=@nf0_dstufe
      where nf2_codseq =@codint

      --//
      --// insert, caso não encontra
      if @@rowcount = 0 
        insert into notfis02comb(nf2_codseq ,
          nf2_codntf ,
          nf2_codanp ,
          nf2_descri ,
          nf2_pglp ,
          nf2_pgnn ,
          nf2_pgni ,
          nf2_vpart ,
          nf2_ufcons 
        )
        values (@codint ,
          @cod_seq ,
          @codanp ,
          @descanp,
          @pglp ,
          @pgnn ,
          @pgni ,
          @vlrcom ,
          @nf0_dstufe 
        )
    end;

    --//
    --// ler proximo item
    fetch next from crs_pedido01
    into @codint, 
      @codpro, @codbar, @despro, @rdzpro, @codncm, @codest, @cfop, @undcom, @qtdcom, @vlrcom, @vlrdesc,  --//produto
      @csosn, @cst, @origem, @modbc, @predbc, @vbc, @picms, @vicms, @modbcst, @pmvast, @predbcst, --//icms (normal/simples)   
      @cenqipi, @cstipi, @vbcipi, @pipi, @vipi, --//ipi
      @cstpis, @vbcpis, @ppis, @vpis, --//pis
      @cstcofins, @vbccofins, @pcofins, @vcofins, --//cofins
      @codanp, @pglp, @pgnn, @pgni, @vpart ,--//produto(grupo combustivel)  
      @infadpro
      ;

    --//
    set @itm_index =@itm_index +1;
    set @nf1_vlrfret =0
    set @nf1_vlroutr =0
  end;
  close crs_pedido01;
  deallocate crs_pedido01;
  
  --//
  --// se existir residuo
  if(@tot_desc > 0)and(@tot_desc -@sum_desc) > 0
  begin
    --// 
    --// joga a sobra do desconto no item de maior valor 
    update notfis01 set nf1_vlrdesc=nf1_vlrdesc +(@tot_desc -@sum_desc)
    where nf1_codntf =@cod_seq 
    and   nf1_codint =@itm_maxcod
  end;

  --//
  return @ret_codigo;
  --//  
go

