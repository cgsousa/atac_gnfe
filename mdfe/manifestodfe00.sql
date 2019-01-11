use comercio
go

--//
--// cadastro de condutor 
--//
--drop table cadcondutor  
if not exists (select *from dbo.sysobjects where id = object_id(N'cadcondutor') and objectproperty(id, N'IsTable') = 1)
  create table cadcondutor(cdt_codseq smallint not null identity(1,1) ,
    cdt_tippes smallint null ,
    cdt_cpfcnpj varchar(14) null ,
    cdt_xnome varchar(50) null ,
    cdt_rntrc varchar(8) null ,
    cdt_ie varchar(12) null ,
    cdt_uf char(2) null ,
    cdt_tpprop smallint null ,
    cdt_status smallint null 
    ,constraint pk__cadcondutor primary key (cdt_codseq) 
    )
go



--//
--// cadastro de veiculo 
--//   
--drop table cadveiculo
if not exists (select *from dbo.sysobjects where id = object_id(N'cadveiculo') and objectproperty(id, N'IsTable') = 1)
  create table cadveiculo(vei_codseq smallint not null identity(1,1) ,
    vei_placa varchar(7) not null,
    vei_renavam varchar(11) null,
    vei_tara smallint not null ,
    vei_capkg smallint null ,
    vei_capm3 smallint null ,
    vei_tiprod smallint null, --//tipo rodado
    vei_tipcar smallint null, --//tipo carroceria
    vei_ufelic char(2) null , --//UF em que veículo está licenciado
    vei_cdprop smallint null, --//propietário 
    vei_status smallint null 
    ,constraint pk__cadveiculo primary key (vei_codseq) 
    ,constraint fk__vei_cdprop foreign key (vei_cdprop) references cadcondutor(cdt_codseq) 
    )
go


--//
--// MDF-e Manifesto de documento fiscal eletronico
--//  
--drop table manifestodf00
if not exists (select *from dbo.sysobjects where id = object_id(N'manifestodf00') and objectproperty(id, N'IsTable') = 1)
  create table manifestodf00(md0_codseq int not null identity(1,1) ,
    md0_codemp smallint not null ,
    md0_versao varchar(20) null ,
    md0_codufe smallint not null ,
    md0_tipamb smallint not null ,
    md0_tpemit smallint not null ,
    md0_tptransp smallint null ,
    md0_codmod smallint not null default (58) ,
    md0_nserie smallint not null ,
    md0_numdoc int not null ,
    md0_modal smallint not null ,
    md0_dhemis datetime not null default getdate(),
    md0_tpemis smallint not null ,
    md0_procemi smallint not null,
    md0_verproc varchar(20) null ,
    md0_ufeini char(2) not null ,
    md0_ufefim char(2) not null ,
    md0_dhviagem datetime null ,
    md0_indcnlvrd smallint null ,
    --//
    --// especifico p/ rodoviario
    md0_rntrc varchar(8) null ,
    md0_codvei smallint not null,
    --//
    md0_codstt smallint null ,
    md0_motivo varchar(250) null ,
    md0_chmdfe char(44) null ,
    md0_xml text null ,
    --//
    --//retorno
    md0_verapp varchar(20) ,
    md0_dhreceb datetime ,
    md0_numreci char(15)  , 
    md0_numprot char(15) ,
    md0_digval char(28)   

    ,constraint pk__manifestodfe00 primary key (md0_codseq) 
    ,constraint fk__md0_codvei foreign key (md0_codvei) references cadveiculo(vei_codseq) 

  )
go

--//
--// municipios de carregamento/descarregamento
--drop table manifestodf01mun 
if not exists (select *from dbo.sysobjects where id = object_id(N'manifestodf01mun') and objectproperty(id, N'IsTable') = 1)
  create table manifestodf01mun(md1_codseq int not null identity(1,1) ,
    md1_codmdf int not null ,
    md1_codmun int not null ,
    md1_xmunic varchar(20) null ,
    md1_tipmun smallint null --0=carregamento,1=descarregamento
    ,constraint pk__manifestodf01mun primary key (md1_codseq) 
    ,constraint fk__md1_codmdf foreign key (md1_codmdf) references manifestodf00(md0_codseq) 
  )
go

/*
--//
--// modalidade rodoviario
--drop table mdfe02rodo
if not exists (select *from dbo.sysobjects where id = object_id(N'mdfe02rodo') and objectproperty(id, N'IsTable') = 1)
  create table mdfe02rodo(md2_codmdf int not null ,
    md2_versao varchar(20) null ,
    md2_rntrc varchar(8) null ,
    md2_codvei smallint not null
    ,constraint fk__md2_codmdf foreign key (md2_codmdf) references manifestodfe00(md0_codseq) 
    ,constraint fk__md2_codvei foreign key (md2_codvei) references cadveiculo(vei_codseq) 
    ,constraint pk__mdfe02rodo primary key (md2_codmdf) 
  )
go

--//
--// municipios de descarregamento
--drop table mdf03mundescarga
if not exists (select *from dbo.sysobjects where id = object_id(N'mdf03mundescarga') and objectproperty(id, N'IsTable') = 1)
  create table mdf03mundescarga(md3_codseq int not null identity(1,1) ,
    md3_codmdf int not null ,
    md3_codmun int not null ,
    md3_xmunic varchar(20) null 
    ,constraint fk__md3_codmdf foreign key (md3_codmdf) references manifestodf00(md0_codseq) 
    ,constraint pk__mdf03mundescarga primary key (md3_codseq) 
  )
go
*/

--//
--// Nota Fiscal Eletronica
--drop table manifestodf02nfe 
if not exists (select *from dbo.sysobjects where id = object_id(N'manifestodf02nfe') and objectproperty(id, N'IsTable') = 1)
  create table manifestodf02nfe(md2_codmun int not null ,    
    md2_chvnfe char(44) not null ,
    md2_codbar varchar(14) null  ,
    md2_indree smallint null ,
    md2_codntf int not null ,
    md2_vlrntf numeric (15,2) null ,
    md2_volpsob numeric (12,3) null 
    ,constraint fk__md2_codmun foreign key (md2_codmun) references manifestodf01mun(md1_codseq) 
    ,constraint fk__md2_codntf foreign key (md2_codntf) references notfis00(nf0_codseq) 
  )
go

--//
--// condutores do veiculo
--drop table manifestodf03cond
if not exists (select *from dbo.sysobjects where id = object_id(N'manifestodf03cond') and objectproperty(id, N'IsTable') = 1)
  create table manifestodf03cond(md3_codmdf int not null ,
    md3_codvei smallint not null,
    md3_codcdt smallint not null 
    ,constraint fk__md3_codmdf foreign key (md3_codmdf) references manifestodf00(md0_codseq)
    ,constraint fk__md3_codvei foreign key (md3_codvei) references cadveiculo(vei_codseq)   
    ,constraint fk__md3_codcdt foreign key (md3_codcdt) references cadcondutor(cdt_codseq) 
    ,constraint pk__manifestodf03cond primary key (md3_codmdf, md3_codvei) 
  )
go
