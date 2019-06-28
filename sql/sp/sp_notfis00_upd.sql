use comercio
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
