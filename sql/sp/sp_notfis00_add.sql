use comercio
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
