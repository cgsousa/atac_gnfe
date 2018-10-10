unit Form.NFEStatus;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,
  //TMS
  HTMLabel,
  //JVCL
  JvExStdCtrls, JvButton, JvCtrls, JvFooter, JvExExtCtrls, JvExtComponent
  //lib
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
    procedure setMsg(const Avalue: string) ;
    procedure OnLOG(Sender: TObject; const StrLog: string);
  public
    { Public declarations }
    property H1: string read m_H1 write m_H1;
    property Msg: string read m_Msg write setMsg;
  public
    class procedure DoShow(const AMsg: string);
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
