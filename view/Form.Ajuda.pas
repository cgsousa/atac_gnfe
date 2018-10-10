unit Form.Ajuda;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  JvExStdCtrls, JvExExtCtrls, JvExtComponent, JvCtrls, JvFooter, JvButton,
  HTMLabel,
  FormBase;

type
  Tfrm_Ajuda = class(TBaseForm)
    htm_Ajuda: THTMLabel;
  private
    { Private declarations }
    procedure AddHelp(const aLink, aText: string);
  public
    { Public declarations }
    class procedure CP_Show;
  end;


implementation

{$R *.dfm}

{ Tfrm_Ajuda }

procedure Tfrm_Ajuda.AddHelp(const aLink, aText: string);
const
  IDENT =50;
begin
    htm_Ajuda.HTMLText.Add(
        Format('<P><IND x="%d"><FONT color="#0000FF">%s</FONT>%s</P>', [IDENT, aLink, aText])
        ) ;
end;

class procedure Tfrm_Ajuda.CP_Show;
var
  F: Tfrm_Ajuda;
begin
    F :=Tfrm_Ajuda.Create(Application);
    try
        F.htm_Ajuda.HTMLText.Clear ;
        F.AddHelp('Ctrl+C',' Copia chave para área de transferencia');
        F.AddHelp('Ctrl+K',' Força geração XML/Chave com base na forme de emissão (CUIDADO !!!)');
        F.AddHelp('Ctrl+S',' Envia XML/DANFE para e-mail do destinatário');

        F.AddHelp('Confirmar senha',' *****************************');
        F.AddHelp('Ctrl+E',' Exporta o XML da NFe, indepedente de situação');
        F.AddHelp('Ctrl+P',' Abilita consulta de protocuto');

        F.ShowModal ;
    finally
        FreeAndNil(F) ;
    end;
end;

end.
