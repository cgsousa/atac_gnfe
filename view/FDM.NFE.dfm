object dm_nfe: Tdm_nfe
  OldCreateOrder = False
  Height = 241
  Width = 447
  object m_NFE: TACBrNFe
    MAIL = m_Mail
    OnTransmitError = m_NFETransmitError
    OnStatusChange = m_NFEStatusChange
    OnGerarLog = m_NFEGerarLog
    Configuracoes.Geral.SSLLib = libCapicomDelphiSoap
    Configuracoes.Geral.SSLCryptLib = cryCapicom
    Configuracoes.Geral.SSLHttpLib = httpIndy
    Configuracoes.Geral.SSLXmlSignLib = xsMsXmlCapicom
    Configuracoes.Geral.FormatoAlerta = 'TAG:%TAGNIVEL% ID:%ID%/%TAG%(%DESCRICAO%) - %MSG%.'
    Configuracoes.Geral.ValidarDigest = False
    Configuracoes.Geral.VersaoQRCode = veqr000
    Configuracoes.Arquivos.OrdenacaoPath = <>
    Configuracoes.WebServices.UF = 'MA'
    Configuracoes.WebServices.Ambiente = taProducao
    Configuracoes.WebServices.AguardarConsultaRet = 0
    Configuracoes.WebServices.QuebradeLinha = '|'
    Configuracoes.RespTec.IdCSRT = 0
    DANFE = m_DRL
    Left = 32
    Top = 10
  end
  object m_PP: TACBrPosPrinter
    PaginaDeCodigo = pc860
    EspacoEntreLinhas = 5
    ConfigBarras.MostrarCodigo = False
    ConfigBarras.LarguraLinha = 0
    ConfigBarras.Altura = 0
    ConfigBarras.Margem = 0
    ConfigQRCode.Tipo = 2
    ConfigQRCode.LarguraModulo = 5
    ConfigQRCode.ErrorLevel = 0
    LinhasEntreCupons = 0
    CortaPapel = False
    ControlePorta = True
    Left = 115
    Top = 10
  end
  object m_Mail: TACBrMail
    Host = '127.0.0.1'
    Port = '25'
    SetSSL = False
    SetTLS = False
    Attempts = 3
    DefaultCharset = UTF_8
    IDECharset = CP1252
    Left = 35
    Top = 148
  end
  object m_DEP: TACBrNFeDANFeESCPOS
    PathPDF = '.\pdf\'
    Sistema = 'Imp'
    MargemInferior = 0.800000000000000000
    MargemSuperior = 0.800000000000000000
    MargemEsquerda = 0.600000000000000000
    MargemDireita = 0.510000000000000000
    CasasDecimais.Formato = tdetInteger
    CasasDecimais.qCom = 2
    CasasDecimais.vUnCom = 2
    CasasDecimais.MaskqCom = ',0.00'
    CasasDecimais.MaskvUnCom = ',0.00'
    TipoDANFE = tiNFCe
    ImprimeTributos = trbSeparadamente
    ImprimeDescAcrescItem = False
    PosPrinter = m_PP
    Left = 203
    Top = 10
  end
  object m_DRL: TACBrNFeDANFeRL
    Sistema = 'Projeto ACBr - www.projetoacbr.com.br'
    MargemInferior = 0.700000000000000000
    MargemSuperior = 0.700000000000000000
    MargemEsquerda = 0.700000000000000000
    MargemDireita = 0.700000000000000000
    CasasDecimais.Formato = tdetInteger
    CasasDecimais.qCom = 2
    CasasDecimais.vUnCom = 2
    CasasDecimais.MaskqCom = ',0.00'
    CasasDecimais.MaskvUnCom = ',0.00'
    ACBrNFe = m_NFE
    ImprimeTributos = trbSeparadamente
    Left = 32
    Top = 80
  end
  object m_DF: TACBrNFeDANFCeFortes
    Sistema = 'imp'
    MargemInferior = 0.800000000000000000
    MargemSuperior = 0.800000000000000000
    MargemEsquerda = 1.000000000000000000
    MargemDireita = 4.000000000000000000
    CasasDecimais.Formato = tdetInteger
    CasasDecimais.qCom = 2
    CasasDecimais.vUnCom = 2
    CasasDecimais.MaskqCom = ',0.00'
    CasasDecimais.MaskvUnCom = ',0.00'
    TipoDANFE = tiNFCe
    ImprimeTributos = trbSeparadamente
    ImprimeNomeFantasia = True
    ImprimeQRCodeLateral = True
    TamanhoLogoWidth = 50
    FonteLinhaItem.Charset = DEFAULT_CHARSET
    FonteLinhaItem.Color = clWindowText
    FonteLinhaItem.Height = -9
    FonteLinhaItem.Name = 'Lucida Console'
    FonteLinhaItem.Style = []
    Left = 200
    Top = 72
  end
  object m_Val: TACBrValidador
    IgnorarChar = './-'
    Left = 288
    Top = 8
  end
end
