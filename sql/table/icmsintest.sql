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
  go

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
    );
  go

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


