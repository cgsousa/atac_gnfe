/*
A partir da implantação da NT004/2011 e NT005/2011, entraram em vigor novas regras de validação para cálculo do valor total da Nota Fiscal Eletrônica (vNF), sendo elas:
 
Validação do valor unitário de comercialização do item do produto: Caso o valor do produto (vProd) for diferente do resultado da multiplicação entre o valor unitário de comercialização (vUnCom) e a quantidade comercial (qCom), será apresentada a seguinte rejeição: 629 – Valor do Produto difere do produto Valor Unitário de Comercialização e Quantidade Comercial;
 
Validação do valor unitário de tributação do item do produto: Caso o valor do produto (vProd) for diferente do resultado da multiplicação entre o valor unitário de tributação (vUnTrib) e a quantidade tributável (qTrib), será apresentada a seguinte rejeição: 630 – Valor do Produto difere do produto Valor Unitário de Tributação e Quantidade Tributável;
 
Validação do valor total da NF: O valor da Nota Fiscal Eletrônica deve ser resultante do somatório dos seguintes campos:
(+) vProd (Somatório do valor de todos os produtos da NF-e);
(-) vDesc (Somatório do desconto de todos os produtos da NF-e);
(+) vST (Somatório do valor do ICMS com Substituição Tributária de todos os produtos da NF-e);
(+) vFrete (Somatório do valor do Frete de todos os produtos da NF-e);
(+) vSeg (Somatório do valor do seguro de todos os produtos da NF-e);
(+) vOutro (Somatório do valor de outras despesas de todos os produtos da NF-e);
(+) vII (Somatório do valor do Imposto de Importação de todos os produtos da NF-e);
(+) vIPI (Somatório do valor do IPI de todos os produtos da NF-e);
(+) vServ (Somatório do valor do serviço de todos os itens da NF-e).
 
Então, todos os campos totalizadores da NF-e devem ser somados e descontados do valor do desconto (vDesc). Essa operação resultará no valor final da NF-e (vNF).
 
Caso o somatório destes campos não resultar no valor da NF-e, será exibida a seguinte rejeição: 610 – Total da NF difere do somatório dos valores que compõe o valor total da NF.

--//check existencia de foreign key
if not exists(select 1 from sysobjects where id = object_id('nome_foreignkey') and xtype = 'F')
  alter table [tabela]
    add constraint [nome_foreignkey] foreign key (campo_chave) references tabela(campo_chave)
go

*/

use comercio
go


-- //descotinuada
if exists (select *from dbo.sysobjects where id = object_id(N'emisnfe') and objectproperty(id, N'IsTable') = 1)
  drop table emisnfe 
go


if not exists (select *from dbo.sysobjects where id = object_id(N'notfis00') and objectproperty(id, N'IsTable') = 1)
  create table notfis00(nf0_codseq int not null identity(1,1),
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
    nf0_indfinal smallint,
    nf0_indpres smallint ,
    nf0_procemi smallint not null default(0),
    nf0_verproc varchar(20),
    nf0_dhcont datetime null ,
    nf0_justif varchar(256),
    nf0_chvref char(44) ,
    
    nf0_emicnpj varchar(14),
    nf0_eminome varchar(60),
    nf0_emifant varchar(60),
    nf0_emilogr varchar(60),
    nf0_eminumero varchar(10),
    nf0_emicomple varchar(60),
    nf0_emibairro varchar(60),
    nf0_emicodmun int ,
    nf0_emimun varchar(60),
    nf0_emiufe char(2),
    nf0_emicep int ,
    nf0_emifone varchar(14),
    nf0_emiie varchar(14),
    nf0_emiiest varchar(14),
    nf0_emiim varchar(15),
    nf0_emicnae varchar(7),
    nf0_emicrt smallint not null,
    
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
    nf0_dstim varchar(15),
    nf0_dstemail varchar(60) ,
    
    --//
    --//transportes
    --//
    nf0_modFret smallint ,  
    --//transportadora
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

    --//sistema
    nf0_datsys datetime not null default getdate() ,

    --//status
    nf0_codstt smallint not null default 0 ,
    nf0_motivo varchar(250) ,
    
    --//envio
    nf0_chvnfe char(44) ,
    nf0_xml text null,
    nf0_indsinc smallint not null default 0 ,
    
    --//retorno
    nf0_verapp varchar(20) ,
    nf0_dhreceb datetime ,
    nf0_numreci char(15)  , 
    nf0_numprot char(15) ,
    nf0_digval char(28)   
    
    ,constraint pk__notfis00 primary key (nf0_codseq) 
  )
go

if not exists(select 1 from syscolumns where id = object_id('notfis00') and name = 'nf0_volqtd')
  alter table notfis00 add  
    nf0_volqtd int ,
    nf0_volesp varchar(30) ,
    nf0_volmrc varchar(30) ,
    nf0_volnum varchar(30) ,
    nf0_volpsol numeric(12,3),
    nf0_volpsob numeric(12,3)
go  

if not exists(select 1 from syscolumns where id = object_id('notfis00') and name = 'nf0_codped')
  alter table notfis00 add nf0_codped int 
go  

if exists (select name from sysindexes where name = 'idx_notfis00_dtemis_codstt_01')
--//apaga para criar um novo!
  drop index idx_notfis00_dtemis_codstt_01 on notfis00
go

if not exists (select name from sysindexes where name = 'idx_notfis00_01')
  create nonclustered index idx_notfis00_01
    on notfis00 (nf0_codmod,nf0_dtemis)
go

if not exists (select name from sysindexes
            where name = 'idx_notfis00_codstt_02')
create nonclustered index idx_notfis00_codstt_02
    on notfis00 (nf0_codstt)
go

if exists (select name from sysindexes where name = 'idx_notfis00_codmod_nserie_03')
--//apaga para criar um novo! com a ordem invertida
  drop index idx_notfis00_codmod_nserie_03 on notfis00
go

if not exists (select name from sysindexes
            where name = 'idx_notfis00_03')
create nonclustered index idx_notfis00_03
    on notfis00 (nf0_codmod, nf0_nserie, nf0_dtemis)
go


if not exists (select name from sysindexes
            where name = 'idx_notfis00_codmod_nserie_codstt_04')
create nonclustered index idx_notfis00_codmod_nserie_codstt_04
    on notfis00 (nf0_codmod, nf0_nserie, nf0_codstt)
go

if not exists(select 1 from syscolumns where id = object_id('notfis00') and name = 'nf0_consumo')
  alter table notfis00 add nf0_consumo smallint null
go  

if not exists(select 1 from syscolumns where id = object_id('notfis00') and name = 'nf0_infcpl')
  alter table notfis00 add nf0_infcpl varchar(2048) null
go  

--//
--// 
if not exists(select 1from syscolumns where id = object_id('notfis00') and name = 'nf0_codlot')
  alter table notfis00 add nf0_codlot int null
go

--//
--// chk compatibilidade
declare @versql sysname; set @versql =convert(sysname, serverproperty('ProductVersion'));
declare @posdot smallint; set @posdot =charindex('.',@versql);
declare @cmplvl smallint; set @cmplvl =substring(@versql,1,@posdot-1);
if(@cmplvl >= 9)and --sql 2005
  (not exists(select 1from syscolumns where id = object_id('notfis00') and name = 'nf0_xmltyp'))
begin
    exec ('alter table notfis00 add nf0_xmltyp xml null')
end



if not exists (select *from dbo.sysobjects where id = object_id(N'notfis01') and objectproperty(id, N'IsTable') = 1)
  create table notfis01(nf1_codseq int not null identity(1,1),
    nf1_codntf int not null,
    --//Produto
    nf1_codpro varchar(15) ,
    nf1_codean varchar(14) ,
    nf1_descri varchar(120),
    nf1_codncm varchar(8) ,
    nf1_codest varchar(8) ,
    nf1_extipi varchar(3) ,
    nf1_cfop smallint ,
    nf1_undcom varchar(6),
    nf1_qtdcom numeric(12,4),
    nf1_vlrcom numeric(15,6),
    nf1_vlrpro numeric(15,2),
    nf1_eantrib varchar(14),
    nf1_undtrib varchar(6),
    nf1_qtdtrib numeric(12,4),
    nf1_vlrtrib numeric(15,6),
    nf1_vlrfret numeric(12,2),
    nf1_vlrsegr numeric(12,2),
    nf1_vlrdesc numeric(12,2),
    nf1_vlroutr numeric(12,2),
    nf1_indtot smallint ,
    nf1_infadprod varchar(250),
    --//ICMS 
    nf1_cst smallint ,
    nf1_csosn smallint ,  
    nf1_orig smallint not null default(0),
    nf1_modbc smallint ,
    nf1_predbc numeric(15,2),
    nf1_vbc numeric(15,2),
    nf1_picms numeric(5,2),
    nf1_vicms numeric(15,2),
    nf1_modbcst smallint ,
    nf1_pmvast numeric(5,2),
    nf1_predbcst numeric(5,2),
    nf1_vbcst numeric(15,2),
    nf1_picmsst numeric(5,2),
    nf1_vicmsst numeric(15,2),
    nf1_vbcstret numeric(15,2),
    nf1_vicmsstret numeric(15,2),
    nf1_pcredsn numeric(5,2),
    nf1_vcredicmssn numeric(5,2),
    --//IPI
    nf1_clenqipi varchar(5) ,
    nf1_cnpjprodipi varchar(14),
    nf1_cseloipi varchar(20),
    nf1_qseloipi int,
    nf1_cenqipi char(3),
    nf1_cstipi smallint,
    nf1_vbcipi numeric(13,2),
    nf1_qunidipi numeric(12,4),
    nf1_vunidipi numeric(12,2),
    nf1_pipi numeric(5,2),
    nf1_vipi numeric(12,2),
    --//PIS
    nf1_cstpis smallint ,
    nf1_vbcpis numeric(12,2),
    nf1_ppis numeric(5,2),
    nf1_vpis numeric(12,2),
    nf1_qbcprodpis numeric(12,4), 
    nf1_valiqprodpis numeric(12,4), 
    --//COFINS
    nf1_cstcofins smallint ,
    nf1_vbccofins numeric(12,2),
    nf1_pcofins numeric(5,2),
    nf1_vcofins numeric(12,2),
    nf1_vbcprodcofins numeric(12,2),
    nf1_valiqprodcofins numeric(12,4),
    nf1_qbcprodcofins numeric(12,4),  
  --//IBPT (federais,importados,estadual,municipal)
    nf1_ibptaliqnac numeric(5,2) null ,
    nf1_ibptaliqimp numeric(5,2) null ,
    nf1_ibptaliqest numeric(5,2) null ,
    nf1_ibptaliqmun numeric(5,2) null , 
    constraint fk__nf1_codntf foreign key (nf1_codntf) references notfis00(nf0_codseq) ,
    constraint pk__notfis01 primary key (nf1_codseq)
  )
go

if not exists (select name from sysindexes
            where name = 'idx_notfis01_codntf_01')
create nonclustered index idx_notfis01_codntf_01
    on notfis01 (nf1_codntf)
go

--//
--// id. do item 
if not exists(select 1 from syscolumns where id = object_id('notfis01') and name = 'nf1_codint')
  alter table notfis01 add nf1_codint int null
go

--//
--// ICMS relativo ao Fundo de Combate à Pobreza (FCP)
if not exists(select 1 from syscolumns where id = object_id('notfis01') and name = 'nf1_pfcp')
  alter table notfis01 add
    nf1_vbcfcp numeric(12,2),
    nf1_pfcp numeric(5,2),
    nf1_vfcp numeric(12,2),
    nf1_vbcfcpst numeric(12,2),
    nf1_pfcpst numeric(5,2),
    nf1_vfcpst numeric(12,2);    
go

--//
--// Alíquota suportada pelo Consumidor Final (FCP) 
if not exists(select 1 from syscolumns where id = object_id('notfis01') and name = 'nf1_pst')
  alter table notfis01 add
    nf1_pst numeric(5,2),
    nf1_vbcfcpstret numeric(12,2),
    nf1_pfcpstret numeric(5,2),
    nf1_vfcpstret numeric(12,2);    
go

--//
--// Grupo opcional para informações do ICMS Efetivo
if not exists(select 1 from syscolumns where id = object_id('notfis01') and name = 'nf1_predbcefet')
  alter table notfis01 add
    --//normal
    nf1_predbcefet numeric(5,2) ,
    nf1_vbcefet numeric(12,2),
    nf1_picmsefet numeric(5,2),
    nf1_vicmsefet numeric(12,2);    
go

--//
--// Grupo de Repasse do ICMS ST
if not exists(select 1 from syscolumns where id = object_id('notfis01') and name = 'nf1_vbcstdest')
  alter table notfis01 add
    nf1_vbcstdest numeric(15,2),
    nf1_vicmsstdest numeric(15,2)
go

--// item / combustivel (cProdANP NT2012.003d)
if not exists(select 1 from syscolumns where id = object_id('notfis01') and name = 'nf1_codanp')
  alter table notfis01 add nf1_codanp int null
go

--//
--// Grupo a ser informado nas vendas interestaduais para
--// consumidor final, não contribuinte do ICMS.
if not exists(select 1 from syscolumns where id = object_id('notfis01') and name = 'nf1_vbcufdest')
  alter table notfis01 add 
    nf1_vbcufdest numeric(12,2) null ,
    nf1_vbcfcpufdest numeric(12,2) null ,
    nf1_pfcpufdest numeric(5,2) null ,
    nf1_picmsufdest numeric(5,2) null ,
    nf1_picmsinter numeric(5,2) null ,
    nf1_picmsinterpart numeric(5,2) null ,
    nf1_vfcpufdest numeric(12,2) null ,
    nf1_vicmsufdest numeric(12,2) null ,
    nf1_vicmsufremet numeric(12,2) null 
go

--//
--// Operações de devoluções com incidência de IPI  deverão ser informadas no campo Valor do IPI devolvido, 
--// nota técnica da NF-e 2016.002 v1.60 
if not exists(select 1 from syscolumns where id = object_id('notfis01') and name = 'nf1_pdevol')
alter table notfis01 add
  nf1_pdevol numeric(5,2) null ,
  nf1_vipidevol numeric(15,2) null 
go

--//
--// cod. interno do produto
if not exists(select 1 from syscolumns where id = object_id('notfis01') and name = 'nf1_codintpro')
  alter table notfis01 add nf1_codintpro	int
go

--//
--// aumenta tamanho do campo <nf1_vcredicmssn> 
if (select numeric_precision from information_schema.columns where table_name='notfis01' and column_name ='nf1_vcredicmssn')<13
  alter table notfis01 alter column nf1_vcredicmssn numeric(13,2)
go

--//
--// tabela especifica p/ grupo combustiveis
if not exists (select *from dbo.sysobjects where id = object_id(N'notfis02comb') and objectproperty(id, N'IsTable') = 1)
  create table notfis02comb(nf2_codseq int not null,
    nf2_codntf int not null,
    nf2_codanp int not null,
    nf2_descri varchar(50) null ,
    nf2_pglp numeric(5,2) null ,
    nf2_pgnn numeric(5,2) null,
    nf2_pgni numeric(5,2) null,
    nf2_vpart numeric(12,2) null,
    nf2_codif varchar(21) null ,
    nf2_ufcons char(2) null ,
    nf2_qbcprod numeric(12,4) null,
    nf2_valiprod numeric(12,4) null,
    nf2_vcide numeric(12,2) null,
    constraint fk__nf2_codntf foreign key (nf2_codntf) references notfis00(nf0_codseq) ,
    constraint pk__notfis02comb primary key (nf2_codseq)
  )
go

if not exists (select *from dbo.sysobjects where id = object_id(N'inutnumero') and objectproperty(id, N'IsTable') = 1)
  create table inutnumero(num_codseq int not null identity(1,1),
    num_codemp smallint not null ,
    num_tipamb smallint null ,
    num_codufe smallint null ,
    num_ano smallint null ,
    num_cnpj varchar(14) null,
    num_codmod smallint null,
    num_nserie smallint null,
    num_numini int ,
    num_numfin int ,
    num_justif varchar(250) null,
    num_codstt smallint null,
    num_motivo varchar(250) null,
    num_verapp varchar(20) null,
    num_dhreceb datetime null ,
    num_numprot varchar(15) null 
  )
go

if not exists (select *from dbo.sysobjects where id = object_id(N'eventocce') and objectproperty(id, N'IsTable') = 1) 
create table eventocce (cce_codseq int not null identity(1,1) ,
  --//envio
  cce_versao smallint null ,
  cce_codorg smallint not null ,
  cce_tipamb smallint not null ,
  cce_cnpj varchar(14) not null,
  cce_chvnfe char(44) not null ,
  cce_dhevento datetime not null constraint df__eventocce_cce_dhevento default getdate() ,
  cce_tpevento int not null constraint df__eventocce_cce_tpevento default (1101110) ,
  cce_numseq smallint not null constraint df__eventocce_cce_numseq default (1) ,
  cce_xcorrecao varchar(125) not null ,
  --//retorno
  cce_verapp varchar(20) null ,
  cce_codorgaut smallint null ,
  cce_codstt smallint null ,
  cce_motivo varchar(250) null ,
  cce_iddest varchar(14) null,
  cce_emaildest varchar(50) null, 
  cce_dhreceb datetime null ,
  cce_numprot char(15) null
)
go

--//
--// 24.06.2019
--// aumenta tamanho do campo <cce_xcorrecao> para 1000
--// maximo permitido pelo doc
if (select character_maximum_length from information_schema.columns where table_name='eventocce' and column_name ='cce_xcorrecao')<1000
  alter table eventocce alter column cce_xcorrecao varchar(1000) null
go
