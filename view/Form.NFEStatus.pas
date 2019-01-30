unit Form.NFEStatus;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,
  //TMS
  HTMLabel,
  //JVCL
  JvExStdCtrls, JvButton, JvCtrls, JvFooter, JvExExtCtrls, JvExtComponent,
  //lib
  pcnConversaoNFe, pcnEnvEventoNFe
  ;

type
  Tfrm_NFEStatus = class(TForm)
    html_Status: THTMLabel;
    pnl_Footer: TJvFooter;
    btn_Close: TJvFooterBtn;
    procedure btn_CloseClick(Sender: TObject);
  private
    { Private declarations }
    m_H1: string ;
    m_Msg: string;
    m_CertCNPJ, m_CertVenc: string ;
    procedure setMsg(const Avalue: string) ;
    procedure OnLOG(Sender: TObject; const StrLog: string);
  public
    { Public declarations }
    property H1: string read m_H1 write m_H1;
    property Msg: string read m_Msg write setMsg;
  public
    class procedure DoShow(const AMsg: string); overload ;
    class procedure DoShow(const aStatus: TStatusACBrNFe;
      const aCNPJ: string =''; const aVenc: string =''); overload ;
    class function NewStatus(const Atitle: string): Tfrm_NFEStatus;
  end;

var
  frm_Status: Tfrm_NFEStatus;


implementation

{$R *.dfm}


{ Tfrm_NFEStatus }


procedure Tfrm_NFEStatus.btn_CloseClick(Sender: TObject);
begin
    Self.Close ;

end;

class procedure Tfrm_NFEStatus.DoShow(const AMsg: string);
begin
    if frm_Status = nil then
    begin
        Application.CreateForm(Tfrm_NFEStatus, frm_Status);
        frm_Status.pnl_Footer.Visible :=False ;
//        frm_Status :=Tfrm_NFEStatus.Create(Application);
    end;
    frm_Status.html_Status.HTMLText.Clear;
    frm_Status.html_Status.HTMLText.Add(
      Format('<P align="center"> <FONT face="Verdana" color="#008000" size="12" ><B>%s</B></FONT></P>',[AMsg]
      )) ;
    frm_Status.Show ;
    frm_Status.BringToFront ;
    //frm_Status.Refresh;
end;

class procedure Tfrm_NFEStatus.DoShow(const aStatus: TStatusACBrNFe;
  const aCNPJ, aVenc: string);
var
  msg: string;
begin
    if frm_Status = nil then
    begin
        Application.CreateForm(Tfrm_NFEStatus, frm_Status);
        frm_Status.pnl_Footer.Visible :=False ;
        frm_Status.m_CertCNPJ :=aCNPJ ;
        frm_Status.m_CertVenc :=aVenc ;
    end;

    case aStatus of
      stNFeStatusServico: msg :='Verificando Status do servico...';
      stNFeRecepcao: msg :='Enviando dados da NFe...';
      stNfeRetRecepcao: msg :='Recebendo dados da NFe...';
      stNfeConsulta: msg :='Consultando NFe...';
      stNfeCancelamento: msg :='Enviando cancelamento de NFe...';
      stNfeInutilizacao: msg :='Enviando pedido de Inutilização...';
      stNFeRecibo: msg :='Consultando Recibo de Lote...';
      stNFeCadastro: msg :='Consultando Cadastro...';
      stNFeEmail: msg :='Enviando Email...';
      stNFeCCe: msg :='Enviando Carta de Correção...';
      stNFeEvento: msg :='Enviando Evento...';
    end;

    frm_Status.html_Status.HTMLText.Clear;

    frm_Status.html_Status.HTMLText.Add(
      '<p align="left"> <font face="Arial" size="10" >*** Informações do certificado ***</font></p>'
      ) ;

    frm_Status.html_Status.HTMLText.Add(
      Format('<p align="left"> <font face="Trebuchet MS" size="10" >CNPJ......:<b>%s</b></font></p>',[aCNPJ]
      )) ;
    frm_Status.html_Status.HTMLText.Add(
      Format('<p align="left"> <font face="Trebuchet MS" size="10" >Vencimento:<b>%s</b></font></p>',[aVenc]
      )) ;

    frm_Status.html_Status.HTMLText.Add(
      Format('<p/p>',[aVenc]
      )) ;

    frm_Status.html_Status.HTMLText.Add(
      Format('<p align="center"> <font face="Verdana" color="#008000" size="12" ><b>%s</b></font></p>',[msg]
      )) ;

    frm_Status.Show ;
    frm_Status.BringToFront ;
end;

class function Tfrm_NFEStatus.NewStatus(const Atitle: string): Tfrm_NFEStatus;
begin
    if frm_Status = nil then
    begin
        Application.CreateForm(Tfrm_NFEStatus, frm_Status);
        frm_Status.Caption :=Atitle ;
        frm_Status.html_Status.VAlignment :=tvaTop ;
    end;
    frm_Status.setMsg('');
    frm_Status.Show ;
    frm_Status.BringToFront ;
    Result :=frm_Status ;
end;

procedure Tfrm_NFEStatus.OnLOG(Sender: TObject; const StrLog: string);
begin
    Self.setMsg(StrLog);

end;

procedure Tfrm_NFEStatus.setMsg(const Avalue: string);
begin
    html_Status.HTMLText.Clear;
    if Self.H1 <> '' then
    begin
        html_Status.HTMLText.Add(
                              Format('<P align="left"><B>%s</B></P>',[Self.H1])
                                    );
        html_Status.HTMLText.Add('<P></P>');
        html_Status.HTMLText.Add('<P></P>');
    end;
    html_Status.HTMLText.Add(
      Format('<P align="center"><B>%s</B></P>',[Avalue]
      )) ;
   // html_Status.Refresh ;
end;

end.
