--use Comercio
go

set ansi_nulls on
go

set quoted_identifier on
go

/***
* Script para uso da NF-e
* ATAC Sistemas
* Todos os Direitos Reservados
* Autor: Carlos Gonzaga
* Data: 02.02.2018
*
* Nota: deve-se executar antes o script adiciona.sql 
*/

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

if not exists (select name from sysindexes
            where name = 'idx_notfis00_dtemis_codstt_01')
create nonclustered index idx_notfis00_dtemis_codstt_01
    on notfis00 (nf0_dtemis, nf0_codstt)
go

if not exists (select name from sysindexes
            where name = 'idx_notfis00_codstt_02')
create nonclustered index idx_notfis00_codstt_02
    on notfis00 (nf0_codstt)
go

if not exists (select name from sysindexes
            where name = 'idx_notfis00_codmod_nserie_codstt_04')
create nonclustered index idx_notfis00_codmod_nserie_codstt_04
    on notfis00 (nf0_codmod, nf0_nserie, nf0_codstt)
go

if not exists (select name from sysindexes
            where name = 'idx_notfis00_codmod_nserie_03')
create nonclustered index idx_notfis00_codmod_nserie_03
    on notfis00 (nf0_dtemis, nf0_codmod, nf0_nserie)
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

--// cProdANP (NT2012.003d)
if not exists(select 1 from syscolumns where id = object_id('notfis01') and name = 'nf1_codanp')
  alter table notfis01 add nf1_codanp int null
go

--//
--// cod. interno do produto
if not exists(select 1 from syscolumns where id = object_id('notfis01') and name = 'nf1_codintpro')
  alter table notfis01 add nf1_codintpro	int
go

--// 15.02.2019
--// aumenta tamanho do campo <nf1_vcredicmssn> 
if (select numeric_precision from information_schema.columns where table_name='notfis01' and column_name ='nf1_vcredicmssn')<13
  alter table notfis01 alter column nf1_vcredicmssn numeric(13,2)
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


if not exists (select name from sysindexes
            where name = 'idx_notfis01_codntf_01')
create nonclustered index idx_notfis01_codntf_01
    on notfis01 (nf1_codntf)
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
--// tabela especifica p/ grupo combustiveis
if not exists (select *from dbo.sysobjects where id = object_id(N'notfis02comb') and objectproperty(id, N'IsTable') = 1)
  create table notfis02comb(nf2_codseq int not null ,
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

--//ICMS aliquotas interestaduais
if not exists (select *from dbo.sysobjects where id = object_id(N'icmsintest') and objectproperty(id, N'IsTable') = 1)
begin
  create table icmsintest(icm_uf char (2) not null , --//UF de origem
    --//UF´s de destino
    icm_ac numeric(5,2) null ,
    icm_al numeric(5,2) null ,
    icm_am numeric(5,2) null ,
    icm_ap numeric(5,2) null ,
    icm_ba numeric(5,2) null ,
    icm_ce numeric(5,2) null ,
    icm_df numeric(5,2) null ,
    icm_es numeric(5,2) null ,
    icm_go numeric(5,2) null ,
    icm_ma numeric(5,2) null ,
    icm_mt numeric(5,2) null ,
    icm_ms numeric(5,2) null ,
    icm_mg numeric(5,2) null ,
    icm_pa numeric(5,2) null ,
    icm_pb numeric(5,2) null ,
    icm_pr numeric(5,2) null ,
    icm_pe numeric(5,2) null ,
    icm_pi numeric(5,2) null ,
    icm_rn numeric(5,2) null ,
    icm_rs numeric(5,2) null ,
    icm_rj numeric(5,2) null ,
    icm_ro numeric(5,2) null ,
    icm_rr numeric(5,2) null ,
    icm_sc numeric(5,2) null ,
    icm_sp numeric(5,2) null ,
    icm_se numeric(5,2) null ,
    icm_to numeric(5,2) null ,
    icm_ex numeric(5,2) null 
    ,constraint pk__icmsintest primary key (icm_uf) 
  )
  --//                           UF\ AC   AL   AM   AP   BA   CE   DF   ES   GO   MA   MT   MS   MG   PA   PB   PR   PE   PI   RN   RS   RJ   RO   RR   SC   SP   SE   TO   EX     
  insert into icmsintest values('AC',17.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,4.0)
  insert into icmsintest values('AL',12.0,18.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,4.0)
  insert into icmsintest values('AM',12.0,12.0,18.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,4.0)
  insert into icmsintest values('AP',12.0,12.0,12.0,18.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,4.0)
  insert into icmsintest values('BA',12.0,12.0,12.0,12.0,18.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,4.0)
  insert into icmsintest values('CE',12.0,12.0,12.0,12.0,12.0,18.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,4.0)
  insert into icmsintest values('DF',12.0,12.0,12.0,12.0,12.0,12.0,18.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,4.0)
  insert into icmsintest values('ES',12.0,12.0,12.0,12.0,12.0,12.0,12.0,17.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,4.0)
  insert into icmsintest values('GO',12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,17.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,4.0)
  insert into icmsintest values('MA',12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,18.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,4.0)
  insert into icmsintest values('MT',12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,17.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,4.0)
  insert into icmsintest values('MS',12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,17.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,4.0)
  insert into icmsintest values('MG', 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0,18.0, 7.0, 7.0,12.0, 7.0, 7.0, 7.0,12.0,12.0, 7.0, 7.0,12.0,12.0, 7.0, 7.0,4.0)
  insert into icmsintest values('PA',12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,17.0,12.0,17.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,4.0)
  insert into icmsintest values('PB',12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,18.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,4.0)
  insert into icmsintest values('PR', 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0,12.0, 7.0, 7.0,18.0, 7.0, 7.0, 7.0,12.0,12.0, 7.0, 7.0,12.0,12.0, 7.0, 7.0,4.0)
  insert into icmsintest values('PE',12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,18.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,4.0)
  insert into icmsintest values('PI',12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,18.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,4.0)
  insert into icmsintest values('RN',12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,18.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,4.0)
  insert into icmsintest values('RS', 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0,12.0, 7.0, 7.0,12.0, 7.0, 7.0, 7.0,18.0,12.0, 7.0, 7.0,12.0,12.0, 7.0, 7.0,4.0)
  insert into icmsintest values('RJ', 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0,12.0, 7.0, 7.0,12.0, 7.0, 7.0, 7.0,12.0,20.0, 7.0, 7.0,12.0,12.0, 7.0, 7.0,4.0)
  insert into icmsintest values('RO',12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0, 7.5,12.0,12.0,12.0,12.0,12.0,4.0)
  insert into icmsintest values('RR',12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,17.0,12.0,12.0,12.0,12.0,4.0)
  insert into icmsintest values('SC', 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0,12.0, 7.0, 7.0,12.0, 7.0, 7.0, 7.0,12.0,12.0, 7.0, 7.0,17.0,12.0, 7.0, 7.0,4.0)
  insert into icmsintest values('SP', 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0, 7.0,12.0, 7.0, 7.0,12.0, 7.0, 7.0, 7.0,12.0,12.0, 7.0, 7.0,12.0,18.0, 7.0, 7.0,4.0)
  insert into icmsintest values('SE',12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,18.0,12.0,4.0)
  insert into icmsintest values('TO',12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,12.0,18.0,4.0)
end
go

--//
--//Tabela de Alíquota do Fundo de Combate à Pobreza (FCP)
if not exists (select *from dbo.sysobjects where id = object_id(N'fcp00') and objectproperty(id, N'IsTable') = 1)
begin
  create table fcp00(cp0_codseq smallint not null identity(1,1),
    cp0_codufe smallint not null , --//cod.UF de origem
    cp0_aliquo numeric(5,2) not null default(0)     --//aliq. padrao 
    )
 
  insert into fcp00(cp0_codufe, cp0_aliquo) values(12, 2.0) --//AC   
  insert into fcp00(cp0_codufe, cp0_aliquo) values(27, 1.0) --//AL   
  insert into fcp00(cp0_codufe, cp0_aliquo) values(13, 1.6) --//AM   
  insert into fcp00(cp0_codufe, cp0_aliquo) values(16, 0.0) --//AP   
  insert into fcp00(cp0_codufe, cp0_aliquo) values(29, 2.0) --//BA   
  insert into fcp00(cp0_codufe, cp0_aliquo) values(23, 2.0) --//CE   
  insert into fcp00(cp0_codufe, cp0_aliquo) values(53, 2.0) --//DF   
  insert into fcp00(cp0_codufe, cp0_aliquo) values(32, 2.0) --//ES   
  insert into fcp00(cp0_codufe, cp0_aliquo) values(52, 2.0) --//GO   
  insert into fcp00(cp0_codufe, cp0_aliquo) values(21, 2.0) --//MA
  insert into fcp00(cp0_codufe, cp0_aliquo) values(51, 2.0) --//MT   
  insert into fcp00(cp0_codufe, cp0_aliquo) values(50, 2.0) --//MS   
  insert into fcp00(cp0_codufe, cp0_aliquo) values(31, 2.0) --//MG   
  insert into fcp00(cp0_codufe, cp0_aliquo) values(15, 0.0) --//PA   
  insert into fcp00(cp0_codufe, cp0_aliquo) values(25, 2.0) --//PB   
  insert into fcp00(cp0_codufe, cp0_aliquo) values(41, 2.0) --//PR   
  insert into fcp00(cp0_codufe, cp0_aliquo) values(26, 2.0) --//PE   
  insert into fcp00(cp0_codufe, cp0_aliquo) values(22, 2.0) --//PI   
  insert into fcp00(cp0_codufe, cp0_aliquo) values(24, 2.0) --//RN   
  insert into fcp00(cp0_codufe, cp0_aliquo) values(43, 2.0) --//RS   
  insert into fcp00(cp0_codufe, cp0_aliquo) values(33, 4.0) --//RJ   
  insert into fcp00(cp0_codufe, cp0_aliquo) values(11, 2.0) --//RO   
  insert into fcp00(cp0_codufe, cp0_aliquo) values(14, 2.0) --//RR   
  insert into fcp00(cp0_codufe, cp0_aliquo) values(42, 0.0) --//SC   
  insert into fcp00(cp0_codufe, cp0_aliquo) values(35, 2.0) --//SP   
  insert into fcp00(cp0_codufe, cp0_aliquo) values(28, 2.0) --//SE   
  insert into fcp00(cp0_codufe, cp0_aliquo) values(17, 2.0) --//TO
end
go

--//
--// caso a UF existir mais de uma aliquota
if not exists (select *from dbo.sysobjects where id = object_id(N'fcp00') and objectproperty(id, N'IsTable') = 1)
begin
  create table fcp01(cp1_codseq smallint not null identity(1,1),
    cp1_codfcp smallint not null ,
    cp1_codncm varchar(8) not null , 
    cp1_aliquo numeric(5,2) not null default(0) --//aliq. padrao
    )
end
go

if not exists (select *from dbo.sysobjects where id = object_id(N'emisnfe') and objectproperty(id, N'IsTable') = 1)
begin
  create table emisnfe(emi_codseq smallint not null identity(1,1) ,
    emi_codemp smallint not null ,
    emi_cnpj char(14) null ,
    emi_insest varchar(12) null ,
    emi_codmun int null ,
    emi_codufe smallint	null ,

    emi_tipamb smallint not null ,
    emi_tipemi smallint not null ,
    emi_tipimp smallint not null ,
    
    emi_ssllib smallint null ,
    emi_cryptlib smallint null ,
    emi_httplib smallint null ,
    emi_xmlsignlib smallint null ,
    
    emi_certif image null ,
    emi_xsenha varchar(20) null,
    emi_serial char(16) null 
    /*
    emi_codstt smallint null ,
    emi_ultcons datetime null ,
    emi_chksvc smallint not null default(1) ,
    emi_active smallint null
    */
  )
end
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


if exists (select *from dbo.sysobjects where id = object_id(N'sp_notfis00_add') and objectproperty(id, N'IsProcedure') = 1)
  drop procedure sp_notfis00_add
go

/*****************************************************************************
|* sp_notfis00_add
|*
|* PROPÓSITO: Registro de Alterações
******************************************************************************

Símbolo : Significado

[+]     : Novo recurso
[*]     : Recurso modificado/melhorado
[-]     : Correção de Bug (assim esperamos)

14.06.2019
[*] Parametro <@indfinal> atualizado de <venda.consumidorfinal>

20.05.2019
[*] Mais dois novos tipos para @modFret: proprio remetente, proprio destinatario

22.12.2018
[*] Movido codigo de leitura das inf comple pra k 

31.07.2018
[*] Movido a parte dos items para a "sp_notfis01_merge"

24.07.2018
[*] grupo opcional para informações do ICMS Efetivo (NT.2016.002_v160):
    notfis01(
      predbcefet numeric(5,2), 
      vbcefet numeric(12,2),
      picmsefet numeric(5,2),
      vicmsefet numeric(12,2)
      )     

19.07.2018
[+] Nova tabela "notfis02comb" para informações especificas de combustiveis

02.07.2018
[*] Para produtos que não possuem código de barras com GTIN,
    deve ser informado o literal “SEM GTIN” NT_2017.001 v120

20.06.2018
[+] Adic. nova var.(@codanp) para ler o campo (produto.codanp) referente:
    02.8 cProdANP (L102) – Valores tabelas para o Código do Combustível da ANP (NT2012.003d)

29.05.2018
[*] Adic. referencia dos campos FCP(Fundo de Combate a Pobreza)

11.05.2018
[-] aplica desconto em % para resolver o bug qdo envolve desconto com valores minimos

*/


create procedure sp_notfis00_add(
/*
* SP para gerar nota fiscal com base no pedido(venda) informado 
* Atac Sistemas 
* Todos os Direitos Reservados
* Autor: Carlos Gonzaga
* Data: 27.11.2017
*/
  @codemp smallint ,
  @codufe smallint ,
  @natope varchar (60),
  @indpag smallint ,
  @codmod smallint ,
  @nserie smallint ,
  @dtemis datetime ,
  @tipntf smallint ,
  @indope smallint ,
  @codmun int ,
  @tipimp smallint ,
  @tipemi smallint ,
  @tipamb smallint ,
  @finnfe smallint ,
  @indfinal smallint,
  @indpres smallint ,
  @verproc varchar(20),
  @chvref char(44) ,
  @modfret smallint ,
  @codped int , 
  @begintran smallint,
  @codseq int out ,
  @pro_nomrdz smallint , 
  @pro_codint smallint 
  )
as
  
  declare @ret_codigo int; set @ret_codigo =0;
  declare @ret_natope int ; set @ret_natope =10101;
  declare @ret_noemit int ; set @ret_noemit =10103;
  declare @ret_nodest int ; set @ret_nodest =10105;
  declare @ret_nomfre int ; set @ret_nomfre =10107;
  declare @ret_nondoc int ; set @ret_nondoc =10109;
  declare @ret_noped int ; set @ret_noped =10110;
  declare @ret_exists int ; set @ret_exists =10111;
  
  --//
  --// check exists (um-pra-um)
  --//
  if exists(select nf0_codseq from notfis00 where nf0_codped =@codped)
  begin
    raiserror(N'NF já emitida para este pedido [%d]!', 16, 1, @codped);
    return @ret_exists;
  end;
  
  --//******************
  --//emissão de nova NF
  --//******************

  declare @trancount int; set @trancount =@@trancount;
  declare @numdoc int;
  declare @fserie varchar(50); set @fserie = '000';
  declare @dhsaient datetime; set @dhsaient =getdate();
   
  --// emitente
  declare @emi_cnpj varchar(14),
          @emi_nome varchar(60),
          @emi_fant varchar(60),
          @emi_logr varchar(60),
          @emi_numero varchar(10),
          @emi_comple varchar(60),
          @emi_bairro varchar(60),
          @emi_codmun int ,
          @emi_mun varchar(60),
          @emi_ufe char(2),
          @emi_cep int ,
          @emi_fone varchar(14),
          @emi_ie varchar(14),
          @emi_iest varchar(14),
          @emi_im varchar(15),
          @emi_cnae varchar(7),
          @emi_crt smallint 
          ;
  
  --// destinatário
  declare @dst_count int ,
          @dst_tippes smallint ,
          @dst_cnpjcpf varchar(14),
          @dst_idestra varchar(20),
          @dst_nome varchar(60),
          @dst_logr varchar(60),
          @dst_numero varchar(10),
          @dst_comple varchar(60),
          @dst_bairro varchar(60),
          @dst_codmun int ,
          @dst_mun varchar(60),
          @dst_ufe char(2),
          @dst_cep int ,
          @dst_fone varchar(14),
          @dst_indie smallint ,
          @dst_ie varchar(14),
          @dst_isuf varchar(9),
          @dst_im varchar(15),
          @dst_email varchar(60) 
          ;

  --//transportes
  declare @tra_cnpjcpf varchar(14),
          @tra_nome varchar(60),
          @tra_ie varchar(14),
          @tra_end varchar(60),
          @tra_mun varchar(60),
          @tra_ufe char(2);
  declare @vei_placa varchar(10),
          @vei_ufe char(2),
          @vei_rntc varchar(10);
  declare @vol_qtd int ,
          @vol_esp varchar(30) ,
          @vol_mrc varchar(30) ,
          @vol_num varchar(30) ,
          @vol_psol numeric(12,3),
          @vol_psob numeric(12,3);
          
  --//pedido/items
  declare 
    @codcli int ,
    @cpf_cnpj varchar(14),
    @incfret smallint ,
    @vlrfret numeric(12,2),
    @codfop smallint ,
    @vlrdesc numeric(12,2),
    @vlroutr numeric(12,2),
    --//info cpl
    @infcpl varchar(2048) ,
    @codmesa int,                                   
    @numcaixa int,                                
    @nota varchar(250), 
    @usrnome varchar(50), 
    @funnome varchar(50), 
    @codcntsnh int
    ;
    
  if @natope is null 
  begin
    raiserror(N'Natureza da operação não informada!', 16, 1);
    return @ret_natope;
  end;

  --//ler emit
  select 
    @emi_cnpj =replace(replace(replace(e.cnpj,'.',''),'/',''),'-',''),
    @emi_nome =e.nomerazao,
    @emi_fant =e.nomefantasia,
    @emi_logr =e.endereco,
    @emi_numero =e.numero,
    --@emi_comple varchar(60),
    @emi_bairro =e.bairro,
    @emi_codmun =e.codigocidade,
    @emi_mun =e.cidade,
    @emi_ufe =e.estado,
    @emi_cep =replace(replace(e.cep,'.',''),'-',''),
    @emi_fone =replace(replace(replace(e.tel,'(',''),')',''),'-',''),
    @emi_ie =replace(replace(e.ie,'.',''),'-',''),
    --@emi_iest varchar(14),
    --@emi_im varchar(15),
    --@emi_cnae varchar(7),
    @emi_crt =case when lower(e.tipoempresa) = 'normal' then 2
                      when lower(e.tipoempresa) = 'simples' then 0
                 else 1 end
    --//
    --// emitente
    ,@tipemi =case when emi_tipemi is null then 0 else emi_tipemi end 
  from loja e
  left join emisnfe on emi_codemp =e.codloja
  where e.codloja =@codemp;

  if @emi_cnpj is null 
  begin
    raiserror(N'CNPJ não cadastrado para o emitente codigo [%d]!', 16, 1, @codemp);
    return @ret_noemit;
  end;
  
  --// 
  --// ler pedido(venda)
  select top 1
    @codcli =v.codcliente,
    @cpf_cnpj =v.cpf_cnpj,
    @codfop =v.cfop , 
    @codmod =case when v.modelonf is null then 55
                  when v.modelonf = 0 then 55
              else 65 end,
    @tipntf =case when v.tiponfe is null then 0 else v.tiponfe end,
    @tipimp =case when v.tipimp is null then 0 else v.tipimp end,
    @finnfe =case when v.finalidadenfe is null then 0 else v.finalidadenfe end,
    @chvref =v.chavenfref ,
    @vlrdesc =isnull(v.desconto,0) +isnull(v.totaldesci,0) ,
    @incfret=v.incvalorfrete,
    @vlrfret=isnull(v.frete,0) ,
    @vlroutr=isnull(v.totala,0) +isnull(v.valortxentrega,0),
    --//transportes
    @modfret =case  when lower(v.modofrete)='emitente' then 0 --mfContaEmitente
                    when lower(v.modofrete)='destinatario' then 1 --mfContaDestinatario
                    when lower(v.modofrete)='conta terceiros' then 2 --mfContaTerceiros
                    when lower(v.modofrete)='proprio remetente' then 3 --mfProprioRemetente
                    when lower(v.modofrete)='proprio destinatario' then 4 --mfProprioDestinatario
                    when lower(v.modofrete)='sem frete' then 5 -- mfSemFrete
              else null --//tratar outros no futuro
              end  ,
    @tra_cnpjcpf =replace(replace(replace(v.transcnpj,'.',''),'/',''),'-',''),
    @tra_nome =v.transnome,
    @tra_ie =replace(replace(v.transie,'.',''),'-',''),
    @tra_end =v.transendereco,
    @tra_mun =v.transmunicipio,
    @tra_ufe =v.transuf,
    @vei_placa  =replace(v.transplaca,'-',''),
    @vei_ufe    =v.transufveiculo,
    @vei_rntc   =v.transantt ,
    @vol_qtd =case  when v.volume = '' then v.tqtstotal
                    when v.volume is null then v.tqtstotal 
              else v.volume end,
    @vol_esp =v.transvolumeespecie ,
    @vol_mrc =v.transvolumemarca ,
    @vol_num =v.volume,
    @vol_psol=case  when charindex(',',v.pesol) > 0 then stuff(v.pesol,charindex(',',v.pesol),1,'.')
                    when v.pesol = '' then null
              else v.pesol end ,
    @vol_psob=case  when charindex(',',v.pesob) > 0 then stuff(v.pesob,charindex(',',v.pesob),1,'.')
                    when v.pesob = '' then null
              else v.pesob end   
    --//info cpl
    ,@codmesa =v.codmesa
    ,@numcaixa =v.numerocaixa 
    ,@nota =v.nota 
    ,@usrnome =u.nome 
    ,@funnome =f.nome 
    ,@codcntsnh =case when s.codcontadorsenha is null then 0 else s.codcontadorsenha end
    ,@indfinal =v.consumidorfinal
  from venda v
  --//info cpl
  left join usuario u on u.codusuario =v.codusuario            
  left join funcionario f on f.codfuncionario =v.codfuncionario
  left join contadorsenha s on s.codvenda =v.codvenda           
  where v.codvenda = @codped

  --// 
  --// caso não encontra, 
  --// busca na histvenda
  if @codcli is null
    select top 1
      @codcli =v.codcliente,
      @cpf_cnpj =v.cpf_cnpj,
      @codfop =v.cfop , 
      @codmod =case when v.modelonf is null then 55
                    when v.modelonf = 0 then 55
                else 65 end,
      @tipntf =case when v.tiponfe is null then 0 else v.tiponfe end,
      @tipimp =case when v.tipimp is null then 0 else v.tipimp end,
      @finnfe =case when v.finalidadenfe is null then 0 else v.finalidadenfe end,
      @chvref =v.chavenfref ,
      @vlrdesc =isnull(v.desconto,0) +isnull(v.totaldesci,0) ,
      @incfret=v.incvalorfrete,
      @vlrfret=isnull(v.frete,0) ,
      @vlroutr=isnull(v.totala,0) +isnull(v.valortxentrega,0),
      --//transportes
      @modfret =case  when lower(v.modofrete)='emitente' then 0 
                      when lower(v.modofrete)='destinatario' then 1
                      when lower(v.modofrete)='conta terceiros' then 2 
                      when lower(v.modofrete)='sem frete' then 5
                else null --//tratar outros no futuro
                end  ,
      @tra_cnpjcpf =replace(replace(replace(v.transcnpj,'.',''),'/',''),'-',''),
      @tra_nome =v.transnome,
      @tra_ie =replace(replace(v.transie,'.',''),'-',''),
      @tra_end =v.transendereco,
      @tra_mun =v.transmunicipio,
      @tra_ufe =v.transuf,
      @vei_placa  =replace(v.transplaca,'-',''),
      @vei_ufe    =v.transufveiculo,
      @vei_rntc   =v.transantt ,
      @vol_qtd =case  when v.volume = '' then v.tqtstotal
                      when v.volume is null then v.tqtstotal 
                else v.volume end,
      @vol_esp =v.transvolumeespecie ,
      @vol_mrc =v.transvolumemarca ,
      @vol_num =v.volume,
      @vol_psol=case  when charindex(',',v.pesol) > 0 then stuff(v.pesol,charindex(',',v.pesol),1,'.')
                      when v.pesol = '' then null
                else v.pesol end ,
      @vol_psob=case  when charindex(',',v.pesob) > 0 then stuff(v.pesob,charindex(',',v.pesob),1,'.')
                      when v.pesob = '' then null
                else v.pesob end 

      --//info cpl
      ,@codmesa =v.codmesa
      ,@numcaixa =v.numerocaixa 
      ,@nota =v.nota 
      ,@usrnome =u.nome 
      ,@funnome =f.nome 
      ,@codcntsnh =case when s.codcontadorsenha is null then 0 else s.codcontadorsenha end
      ,@indfinal =v.consumidorfinal

    from histvenda v
    --//info cpl
    left join usuario u on u.codusuario =v.codusuario            
    left join funcionario f on f.codfuncionario =v.codfuncionario
    left join contadorsenha s on s.codvenda =v.codvenda           
    where v.codvenda = @codped

  --//
  --// nenhum destinatário encontrado !
  if @codcli is null
  begin
    raiserror(N'Nenhum destinatário encontrado para o pedido[%d]!', 16, 1, @codped)
    return @ret_noped
  end;
  
  --//
  --// monta info comple
  set @infcpl ='';
  if @codmod =55 
  begin
    if @nota is not null 
      set @infcpl =@nota
  end
  else begin
    if @codcntsnh > 0 
      set @infcpl ='Senha: '+convert(varchar, @codcntsnh)
    else begin
      if @codmesa is null 
        set @infcpl ='Venda: '+convert(varchar, @codped)
      else if @codmesa >= 800 
        set @infcpl ='Entrega: '+convert(varchar, @codmesa)
      else 
        set @infcpl ='Mesa/Comanda: '+convert(varchar, @codmesa)
    end
    set @infcpl =@infcpl +', CX: '+convert(varchar, @numcaixa)
    set @infcpl =@infcpl +', Operador: '+@funnome
  end;

  --//
  --// inversão de valores vindo do sisgercom
  select @tipntf =case when @tipntf = 0 then 1 else 0 end;

  --//
  --// NFCe não tem frete
  select @modfret =case when @codmod =65 then 5 else @modfret end;
 
  --//
  --// ler destinatário
  select top 1
    @dst_tippes = case when d.tipopessoa = 'F' then 0 else 1 end,
    @dst_cnpjcpf =replace(replace(replace(d.cnpj,'.',''),'/',''),'-',''),
    --@dst_idestra varchar(20),
    @dst_nome =d.nomerazao,
    @dst_logr =d.endereco,
    @dst_numero =d.numero,
    --@dst_comple varchar(60),
    @dst_bairro =d.bairro,
    @dst_codmun =d.codigocidade,
    @dst_mun =d.cidade,
    @dst_ufe =d.estado,
    @dst_cep =replace(replace(d.cep,'.',''),'-',''),
    @dst_fone =replace(replace(replace(d.tel,'(',''),')',''),'-',''),
    @dst_indie =d.indIE ,
    @dst_ie =replace(replace(d.ie,'.',''),'-',''),
    --@dst_isuf varchar(9),
    --@dst_im varchar(15),
    @dst_email =d.email 
    ,@dst_count =1
  from cliente d
  where d.codcliente =@codcli;  
  
  --//valida destinatário
  if @codmod = 55 
  begin
    if @dst_count is null 
    begin
      raiserror(N'NFe sem a identificação do destinatário [%d]!', 16, 1, @codcli)
      return 719
    end;
    if(@dst_cnpjcpf is null)or(@dst_cnpjcpf ='')
    begin
      raiserror(N'CNPJ/CPF não informado no destinatário para o codigo [%d]!', 16, 1, @codcli)
      return @ret_nodest
    end;
  end
  else begin
    select @dst_cnpjcpf=case when @cpf_cnpj is not null then @cpf_cnpj end
  end;  
    
  --//
  --// garante consistencia dos dados
  if @begintran = 1
  begin
    if @trancount > 0 
      begin tran tran_notfis00
    else
      begin tran 
  end;
   
  --//      
  --// gera numeração do doc. fiscal
  --// conforme cnpj/modelo/serie
  set @fserie =stuff(@fserie,4-len(@nserie),len(@nserie),@nserie);  
  if @codmod = 55 
    set @fserie='nfe.'+@emi_cnpj+'.nserie.'+ @fserie
  else
    set @fserie='nfce.'+@emi_cnpj+'.nserie.'+ @fserie
  exec sp_nextval @fserie, @numdoc out, 0;

  --//
  --// se não gerou número do doc. fiscal
  if @numdoc = 0 
  begin
    --//
    --// se requereu transação 
    if @begintran = 1
    begin
      --// se start transação neste processo
      --// desfaz transação 
      if @trancount > 0 
        rollback tran tran_notfis00
      else
        rollback tran 
    end;    
    return @ret_nondoc
  end;
   
  insert into notfis00(nf0_codemp ,
                      nf0_codufe ,
                      nf0_natope ,
                      nf0_indpag ,
                      nf0_codmod ,
                      nf0_nserie ,
                      nf0_numdoc ,
                      nf0_dtemis ,
                      nf0_dhsaient ,
                      nf0_tipntf ,
                      nf0_indope ,
                      nf0_codmun ,
                      nf0_tipimp ,
                      nf0_tipemi ,
                      nf0_tipamb ,
                      nf0_finnfe ,
                      nf0_chvref ,                      
                      nf0_indfinal ,
                      nf0_indpres ,  
                      nf0_verproc ,
                      nf0_emicnpj ,
                      nf0_eminome ,
                      nf0_emifant ,
                      nf0_emilogr ,
                      nf0_eminumero ,
                      nf0_emicomple ,
                      nf0_emibairro ,
                      nf0_emicodmun ,
                      nf0_emimun ,
                      nf0_emiufe ,
                      nf0_emicep ,
                      nf0_emifone ,
                      nf0_emiie ,
                      nf0_emicrt ,
                      nf0_dstcodigo ,
                      nf0_dsttippes ,
                      nf0_dstcnpjcpf ,
                      nf0_dstidestra ,
                      nf0_dstnome ,
                      nf0_dstlogr ,
                      nf0_dstnumero ,
                      nf0_dstcomple ,
                      nf0_dstbairro ,
                      nf0_dstcodmun ,
                      nf0_dstmun ,
                      nf0_dstufe ,
                      nf0_dstcep ,
                      nf0_dstfone ,
                      nf0_dstindie ,
                      nf0_dstie ,
                      nf0_dstemail ,
                      --//dados dos transportes                          
                      nf0_modFret ,
                      nf0_tracnpjcpf,
                      nf0_tranome ,
                      nf0_traie ,
                      nf0_traend ,
                      nf0_tramun ,
                      nf0_traufe ,
                      nf0_veiplaca ,
                      nf0_veiufe ,
                      nf0_veirntc ,
                      nf0_volqtd ,
                      nf0_volesp ,
                      nf0_volmrc ,
                      nf0_volnum ,
                      nf0_volpsol ,
                      nf0_volpsob ,
                      nf0_codped,
                      nf0_infcpl)
  values            ( @codemp ,
                      @codufe ,
                      @natope ,
                      @indpag ,
                      @codmod ,
                      @nserie ,
                      @numdoc ,
                      @dtemis ,
                      @dhsaient,
                      @tipntf ,
                      @indope ,
                      @codmun ,
                      @tipimp ,
                      @tipemi ,
                      @tipamb ,
                      @finnfe ,
                      @chvref ,
                      @indfinal ,
                      @indpres ,
                      @verproc ,
                      @emi_cnpj ,
                      @emi_nome ,
                      @emi_fant ,
                      @emi_logr ,
                      @emi_numero ,
                      @emi_comple ,
                      @emi_bairro ,
                      @emi_codmun ,
                      @emi_mun ,
                      @emi_ufe ,
                      @emi_cep ,
                      @emi_fone ,
                      @emi_ie ,
                      @emi_crt ,
                      @codcli ,
                      @dst_tippes ,
                      @dst_cnpjcpf ,
                      @dst_idestra ,
                      @dst_nome ,
                      @dst_logr ,
                      @dst_numero ,
                      @dst_comple ,
                      @dst_bairro ,
                      @dst_codmun ,
                      @dst_mun ,
                      @dst_ufe ,
                      @dst_cep ,
                      @dst_fone ,
                      @dst_indie ,
                      @dst_ie ,
                      @dst_email ,
                      --//dados dos transportes
                      @modFret ,
                      @tra_cnpjcpf ,
                      @tra_nome ,
                      @tra_ie ,
                      @tra_end ,
                      @tra_mun ,
                      @tra_ufe ,
                      @vei_placa ,
                      @vei_ufe ,
                      @vei_rntc ,
                      @vol_qtd,
                      @vol_esp,
                      @vol_mrc,
                      @vol_num,
                      @vol_psol,
                      @vol_psob,
                      @codped ,
                      @infcpl );
  --// uuid
  set @codseq =ident_current('notfis00');

  --//
  --// adiciona os items
  exec @ret_codigo =sp_notfis01_merge
          @ins_upd =0, --//0-insert, 1-update 
          @cod_seq =@codseq ,
          @pro_nomrdz =@pro_nomrdz,
          @pro_codint =@pro_codint
          ;  

  if @ret_codigo =0
  begin
    if @begintran = 1
    begin
      if @trancount > 0 
        commit tran tran_notfis00
      else
        commit tran ;
    end;    
  end
  else begin
    if @begintran = 1
    begin
      if @trancount > 0 
        rollback tran tran_notfis00
      else
        rollback tran ;
    end;      
  end;
  --//

  return @ret_codigo;
  --//  
go


if exists (select *from dbo.sysobjects where id = object_id(N'sp_notfis00_upd') and objectproperty(id, N'IsProcedure') = 1)
  drop procedure sp_notfis00_upd
go

/*****************************************************************************
|* sp_notfis00_upd
|*
|* PROPÓSITO: Registro de Alterações
******************************************************************************

Símbolo : Significado

[+]     : Novo recurso
[*]     : Recurso modificado/melhorado
[-]     : Correção de Bug (assim esperamos)


14.06.2019
[*] Parametro <@indfinal> atualizado de <venda.consumidorfinal>

22.12.2018
[*] Movido codigo de leitura das inf comple pra k 
[-] os dados dos transportes que não era gravado na alteração

31.07.2018
[*] Movido a parte dos items para a "sp_notfis01_merge"

19.07.2018
[+] Nova tabela "notfis02comb" para informações especificas de combustiveis

02.07.2018
[*] Para produtos que não possuem código de barras com GTIN,
    deve ser informado o literal “SEM GTIN” NT_2017.001 v120

20.06.2018
[+] Adic. nova var.(@codanp) para ler o campo (produto.codanp) referente:
    02.8 cProdANP (L102) – Valores tabelas para o Código do Combustível da ANP (NT2012.003d)

29.05.2018
[*] Adic. referencia dos campos FCP(Fundo de Combate a Pobreza)

22.05.2018
[*] Trava qdo não encontrar o pedido tanto na venda/histvenda

14.05.2018
[-] aplica desconto em % para resolver o bug qdo envolve desconto com valores minimos

28.12.2017
[+] data inicial

*/

create procedure sp_notfis00_upd(
  @codseq int , 
  @dtemis datetime ,
  @begintran smallint,
  @pro_nomrdz smallint ,
  @pro_codint smallint
  )
as  
  declare @ret_codigo int; set @ret_codigo =0;
  declare @ret_noped int ; set @ret_noped =10201;
  declare @ret_nontf int ; set @ret_nontf =10203;
  declare @ret_ntfpro int ; set @ret_ntfpro =10205;
  declare @ret_ntfcnc int ; set @ret_ntfcnc =10206;
  declare @ret_ntfinu int ; set @ret_ntfinu =10207;

  declare @trancount int; set @trancount =@@trancount;
  declare @rowcount smallint; 

  --//config-emissor
  declare @codemp smallint; set @codemp =1; 
  declare @emi_ufe char(2),
          @emi_crt smallint;
  declare @codufe smallint,
          @indfinal smallint,
          @codmod smallint,
          @modfret smallint;

  --//dest
  declare @dst_tippes smallint ,
          @dst_cnpjcpf varchar(14),
          @dst_idestra varchar(20),
          @dst_nome varchar(60),
          @dst_logr varchar(60),
          @dst_numero varchar(10),
          @dst_comple varchar(60),
          @dst_bairro varchar(60),
          @dst_codmun int ,
          @dst_mun varchar(60),
          @dst_ufe char(2),
          @dst_cep int ,
          @dst_fone varchar(14),
          @dst_indie smallint ,
          @dst_ie varchar(14),
          @dst_isuf varchar(9),
          @dst_im varchar(15),
          @dst_email varchar(60) 
          ;

 --//transportes
  declare @tra_cnpjcpf varchar(14),
          @tra_nome varchar(60),
          @tra_ie varchar(14),
          @tra_end varchar(60),
          @tra_mun varchar(60),
          @tra_ufe char(2);
  declare @vei_placa varchar(10),
          @vei_ufe char(2),
          @vei_rntc varchar(10);
  declare @vol_qtd int ,
          @vol_esp varchar(30) ,
          @vol_mrc varchar(30) ,
          @vol_num varchar(30) ,
          @vol_psol numeric(12,3),
          @vol_psob numeric(12,3);

  --//pedido(venda)
  declare 
    @codped int ,
    @codcli int ,
    @numdoc int ,
    @codstt smallint ,
    @cpf_cnpj varchar(14),
    @incfret smallint ,
    @vlrfret numeric(12,2),
    @codfop smallint ,
    @vlrdesc numeric(12,2),
    @vlroutr numeric(12,2),
    --//info cpl
    @infcpl varchar(2048) ,
    @codmesa int,                                   
    @numcaixa int,                                
    @nota varchar(250), 
    @usrnome varchar(50), 
    @funnome varchar(50), 
    @codcntsnh int
    ;
      
  --//
  --ler nota fiscal
  select top 1
    @codemp =nf0_codemp ,
    @codped =nf0_codped ,
    @numdoc =nf0_numdoc ,
    @codstt =nf0_codstt ,
    @codufe =nf0_codufe ,
    --@indfinal=nf0_indfinal, 
    @codmod =nf0_codmod,
    @rowcount =1
  from notfis00
  where nf0_codseq =@codseq;
  
  --//
  --// nenhuma pedido relacionado a esta nota fiscal  !
  if @codped is null 
  begin
    raiserror(N'Nenhum pedido relacionado para esta NF[codseq:%d]!', 16, 1, @codseq)
    return @ret_nontf
  end;

  --//
  --// check nota fiscal 
  --// processada 
  if @codstt in(100, 110, 150, 301, 302, 303)
  begin
    raiserror(N'Nota Fiscal[%d] já processada!', 16, 1, @numdoc)
    return @ret_ntfpro    
  end;

  --//
  --// check nota fiscal 
  --// cancelada
  if @codstt in(101, 135, 151, 155)
  begin
    raiserror(N'Nota Fiscal[%d] cancelada!', 16, 1, @numdoc)
    return @ret_ntfcnc    
  end;

  --//
  --// check nota fiscal 
  --// inutilizada
  if @codstt in(102)
  begin
    raiserror(N'Nota Fiscal[%d] inutilizada!', 16, 1, @numdoc)
    return @ret_ntfinu    
  end;
  
  --//
  --//ler pedido(venda)
  select top 1
    @codcli =v.codcliente,
    @cpf_cnpj =v.cpf_cnpj,
    @codfop =v.cfop , 
    @vlrdesc =isnull(v.desconto,0) +isnull(v.totaldesci,0) ,
    @incfret=v.incvalorfrete,
    @vlrfret=case when v.frete is null then 0 else v.frete end ,
    @vlroutr=isnull(v.totala,0) +isnull(v.valortxentrega,0) ,
    --//transportes
    @modfret =case  when lower(v.modofrete)='emitente' then 0 
                    when lower(v.modofrete)='destinatario' then 1
                    when lower(v.modofrete)='conta terceiros' then 2 
                    when lower(v.modofrete)='sem frete' then 5
              else null --//tratar outros no futuro
              end  ,
    @tra_cnpjcpf =replace(replace(replace(v.transcnpj,'.',''),'/',''),'-',''),
    @tra_nome =v.transnome,
    @tra_ie =replace(replace(v.transie,'.',''),'-',''),
    @tra_end =v.transendereco,
    @tra_mun =v.transmunicipio,
    @tra_ufe =v.transuf,
    @vei_placa  =replace(v.transplaca,'-',''),
    @vei_ufe    =v.transufveiculo,
    @vei_rntc   =v.transantt ,
    @vol_qtd =case  when v.volume = '' then v.tqtstotal
                    when v.volume is null then v.tqtstotal 
              else v.volume end,
    @vol_esp =v.transvolumeespecie ,
    @vol_mrc =v.transvolumemarca ,
    @vol_num =v.volume,
    @vol_psol=case  when charindex(',',v.pesol) > 0 then stuff(v.pesol,charindex(',',v.pesol),1,'.')
                    when v.pesol = '' then null
              else v.pesol end ,
    @vol_psob=case  when charindex(',',v.pesob) > 0 then stuff(v.pesob,charindex(',',v.pesob),1,'.')
                    when v.pesob = '' then null
              else v.pesob end   

    --//info cpl
    ,@codmesa =v.codmesa
    ,@numcaixa =v.numerocaixa 
    ,@nota =v.nota 
    ,@usrnome =u.nome 
    ,@funnome =f.nome 
    ,@codcntsnh =case when s.codcontadorsenha is null then 0 else s.codcontadorsenha end
    ,@indfinal =v.consumidorfinal

  from venda v
  --//info cpl
  left join usuario u on u.codusuario =v.codusuario            
  left join funcionario f on f.codfuncionario =v.codfuncionario
  left join contadorsenha s on s.codvenda =v.codvenda           
  where v.codvenda = @codped;
  
  --//
  --// caso não encontra, busca da histvenda 
  if @codcli is null 
  begin
    select top 1
      @codcli =v.codcliente,
      @cpf_cnpj =v.cpf_cnpj,
      @codfop =v.cfop , 
      @vlrdesc =isnull(v.desconto,0) +isnull(v.totaldesci,0) ,
      @incfret=v.incvalorfrete,
      @vlrfret=case when v.frete is null then 0 else v.frete end ,
      @vlroutr=isnull(v.totala,0) +isnull(v.valortxentrega,0) ,
      --//transportes
      @modfret =case  when lower(v.modofrete)='emitente' then 0 
                      when lower(v.modofrete)='destinatario' then 1
                      when lower(v.modofrete)='conta terceiros' then 2 
                      when lower(v.modofrete)='sem frete' then 5
                else null --//tratar outros no futuro
                end  ,
      @tra_cnpjcpf =replace(replace(replace(v.transcnpj,'.',''),'/',''),'-',''),
      @tra_nome =v.transnome,
      @tra_ie =replace(replace(v.transie,'.',''),'-',''),
      @tra_end =v.transendereco,
      @tra_mun =v.transmunicipio,
      @tra_ufe =v.transuf,
      @vei_placa  =replace(v.transplaca,'-',''),
      @vei_ufe    =v.transufveiculo,
      @vei_rntc   =v.transantt ,
      @vol_qtd =case  when v.volume = '' then v.tqtstotal
                      when v.volume is null then v.tqtstotal 
                else v.volume end,
      @vol_esp =v.transvolumeespecie ,
      @vol_mrc =v.transvolumemarca ,
      @vol_num =v.volume,
      @vol_psol=case  when charindex(',',v.pesol) > 0 then stuff(v.pesol,charindex(',',v.pesol),1,'.')
                      when v.pesol = '' then null
                else v.pesol end ,
      @vol_psob=case  when charindex(',',v.pesob) > 0 then stuff(v.pesob,charindex(',',v.pesob),1,'.')
                      when v.pesob = '' then null
                else v.pesob end   

      --//info cpl
      ,@codmesa =v.codmesa
      ,@numcaixa =v.numerocaixa 
      ,@nota =v.nota 
      ,@usrnome =u.nome 
      ,@funnome =f.nome 
      ,@codcntsnh =case when s.codcontadorsenha is null then 0 else s.codcontadorsenha end
      ,@indfinal =v.consumidorfinal

    from histvenda v
    --//info cpl
    left join usuario u on u.codusuario =v.codusuario            
    left join funcionario f on f.codfuncionario =v.codfuncionario
    left join contadorsenha s on s.codvenda =v.codvenda           
    where v.codvenda = @codped
  end;
  
  --//
  --// Nenhum destinatário !
  if @codcli is null
  begin
    raiserror(N'Nenhum destinatário encontrado para o pedido[%d]!', 16, 1, @codped)
    --//
    --// 
    return @ret_noped
  end;

  --//
  --// monta info comple
  set @infcpl ='';
  if @codmod =55 
  begin
    if @nota is not null 
      set @infcpl =@nota
  end
  else begin
    if @codcntsnh > 0 
      set @infcpl ='Senha: '+convert(varchar, @codcntsnh)
    else begin
      if @codmesa is null 
        set @infcpl ='Venda: '+convert(varchar, @codped)
      else if @codmesa >= 800 
        set @infcpl ='Entrega: '+convert(varchar, @codmesa)
      else 
        set @infcpl ='Mesa/Comanda: '+convert(varchar, @codmesa)
    end
    set @infcpl =@infcpl +', CX: '+convert(varchar, @numcaixa)
    set @infcpl =@infcpl +', Operador: '+@funnome
  end;
  
  --//ler emit
  select 
    @emi_ufe =e.estado,
    @emi_crt =case when lower(e.tipoempresa) = 'normal' then 2
                      when lower(e.tipoempresa) = 'simples' then 0
                 else 1 end
  from loja e
  where e.codloja =@codemp ;
  
  --//ler destinatário
  select top 1
    @dst_tippes = case when d.tipopessoa = 'F' then 0 else 1 end,
    @dst_cnpjcpf =replace(replace(replace(d.cnpj,'.',''),'/',''),'-',''),
    --@dst_idestra varchar(20),
    @dst_nome =d.nomerazao,
    @dst_logr =d.endereco,
    @dst_numero =d.numero,
    --@dst_comple varchar(60),
    @dst_bairro =d.bairro,
    @dst_codmun =d.codigocidade,
    @dst_mun =d.cidade,
    @dst_ufe =d.estado,
    @dst_cep =replace(replace(d.cep,'.',''),'-',''),
    @dst_fone =replace(replace(replace(d.tel,'(',''),')',''),'-',''),
    @dst_indie =d.indIE ,
    @dst_ie =replace(replace(d.ie,'.',''),'-',''),
    --@dst_isuf varchar(9),
    --@dst_im varchar(15),
    @dst_email =d.email 
    --,@dst_count =1
  from cliente d
  where d.codcliente =@codcli;  


  --//
  --// NFCe não tem frete
  select @modfret =case when @codmod =65 then 5 else @modfret end;

  --//garante consistencia
  if @begintran = 1
  begin
    if @trancount > 0 
      begin tran tran_notfis00
    else
      begin tran ;
  end;
  
  --//altera capa da nota
  update notfis00 set 
    nf0_dtemis  =case when nf0_codmod = 65 then @dtemis else nf0_dtemis end ,
    nf0_dhsaient=case when nf0_codmod = 65 then @dtemis else nf0_dhsaient end ,
    nf0_dsttippes =@dst_tippes ,
    nf0_dstcnpjcpf =case when nf0_codmod = 65 then
                              case when @cpf_cnpj is not null then @cpf_cnpj else @dst_cnpjcpf end
                    else @dst_cnpjcpf end,
    nf0_dstidestra =@dst_idestra ,
    nf0_dstnome =@dst_nome ,
    nf0_dstlogr =@dst_logr ,
    nf0_dstnumero =@dst_numero ,
    nf0_dstcomple =@dst_comple ,
    nf0_dstbairro =@dst_bairro ,
    nf0_dstcodmun =@dst_codmun ,
    nf0_dstmun =@dst_mun ,
    nf0_dstufe =@dst_ufe ,
    nf0_dstcep =@dst_cep ,
    nf0_dstfone =@dst_fone ,
    nf0_dstindie =@dst_indie ,
    nf0_dstie =@dst_ie ,
    nf0_dstemail =@dst_email ,

    --//dados dos transportes                          
    nf0_modFret =@modFret ,
    nf0_tracnpjcpf =@tra_cnpjcpf ,
    nf0_tranome =@tra_nome ,
    nf0_traie =@tra_ie ,
    nf0_traend =@tra_end ,
    nf0_tramun =@tra_mun ,
    nf0_traufe =@tra_ufe ,
    nf0_veiplaca =@vei_placa ,
    nf0_veiufe =@vei_ufe ,
    nf0_veirntc =@vei_rntc ,
    nf0_volqtd =@vol_qtd,
    nf0_volesp =@vol_esp,
    nf0_volmrc =@vol_mrc,
    nf0_volnum =@vol_num,
    nf0_volpsol =@vol_psol,
    nf0_volpsob =@vol_psob,
    
    nf0_infcpl =@infcpl ,
    nf0_indfinal =@indfinal 
  where nf0_codseq =@codseq
  ;  

  --//
  --// check exist items
  if exists(select 1 from notfis01 where nf1_codntf =@codseq)
  begin
    --//
    --// ATUALIZA items
    --print 'ATUALIZA items'
    exec @ret_codigo =sp_notfis01_merge
            @ins_upd =1, --//0-insert, 1-update 
            @cod_seq =@codseq ,
            @pro_nomrdz =@pro_nomrdz,
            @pro_codint =@pro_codint
            ;
  end
  else begin
    --//
    --// INSERE items
    --print 'INSERE items'
    exec @ret_codigo =sp_notfis01_merge
            @ins_upd =0, --//0-insert, 1-update 
            @cod_seq =@codseq ,
            @pro_nomrdz =@pro_nomrdz,
            @pro_codint =@pro_codint
            ;
  end;

  if @ret_codigo =0
  begin
    if @begintran = 1
    begin
      if @trancount > 0 
        commit tran tran_notfis00
      else
        commit tran ;
    end;    
  end
  else begin
    if @begintran = 1
    begin
      if @trancount > 0 
        rollback tran tran_notfis00
      else
        rollback tran ;
    end;      
  end;

  --//
  return @ret_codigo;
  --//
    
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

if not exists (select *from dbo.sysobjects where id = object_id(N'cadanp') and objectproperty(id, N'IsTable') = 1)
begin
  create table cadanp (anp_codigo int not null ,
    anp_descri varchar(50) null 
  )
  insert into cadanp values(210203001,'GLP')
end


if not exists (select name from sysindexes
            where name = 'idx_notfis00_codmod_nserie_03')
create nonclustered index idx_notfis00_codmod_nserie_03
    on notfis00 (nf0_dtemis, nf0_codmod, nf0_nserie)
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


