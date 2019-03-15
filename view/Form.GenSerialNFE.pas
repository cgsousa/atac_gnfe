unit Form.GenSerialNFE;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvExStdCtrls, JvButton, JvCtrls, JvFooter, ExtCtrls,
  JvExExtCtrls, JvExtComponent, AdvEdit, AdvCombo,
  FormBase;

type
  Tfrm_GenSerialNFE = class(TBaseForm)
    pnl_Footer: TJvFooter;
    btn_Close: TJvFooterBtn;
    btn_OK: TJvFooterBtn;
    cbx_CNPJ: TAdvComboBox;
    cbx_Modelo: TAdvComboBox;
    edt_NSerie: TAdvEdit;
    edt_Value: TAdvEdit;
    procedure FormShow(Sender: TObject);
    procedure btn_OKClick(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function Execute: Boolean ;
  end;


implementation

{$R *.dfm}

uses IniFiles,
  ACBrUtil ,
  uTaskDlg, uadodb;


procedure Tfrm_GenSerialNFE.btn_CloseClick(Sender: TObject);
begin
    Self.Close ;

end;

procedure Tfrm_GenSerialNFE.btn_OKClick(Sender: TObject);
var
  K,T: string ;
  serial: IGenSerial ;
begin
    if edt_NSerie.IntValue < 1 then
    begin
        CMsgDlg.Warning('Número de série inválido!') ;
        edt_NSerie.SetFocus ;
        Exit ;
    end;
    if edt_Value.IntValue < 1 then
    begin
        CMsgDlg.Warning('Número inicial inválido!') ;
        edt_Value.SetFocus ;
        Exit ;
    end;
    //
    // NFe
    if cbx_Modelo.ItemIndex =0 then
    begin
        K :=Format('nfe.%s.nserie.%.3d',[empresa.CNPJ,edt_NSerie.IntValue]) ;
        T :='Contador de doc. fiscal(NFe) por serie no cnpj' ;
    end
    //
    // NFCe
    else begin
        K :=Format('nfce.%s.nserie.%.3d',[empresa.CNPJ,edt_NSerie.IntValue]);
        T :='Contador de doc. fiscal(NFCe) por serie no cnpj';
    end;

    //
    // confirm
    if CMsgDlg.Confirm(Format('Deseja criar o novo serial[%s]?',[K])) then
    begin
        serial :=TCGenSerial.New(K, T, 'NFE', edt_Value.IntValue, 1, 1, 999999999);
        if serial.readValue then
        begin
            CMsgDlg.Warning('Já existe este serial! Para alterar o mesmo, acesse as configurações.') ;
        end
        else begin
            serial.setValue ;
            ModalResult :=mrOk;
        end;
    end;
end;

class function Tfrm_GenSerialNFE.Execute: Boolean;
var
  F: Tfrm_GenSerialNFE ;
begin
    F :=Tfrm_GenSerialNFE.Create(Application) ;
    try
        Result :=F.ShowModal =mrOk ;
    finally
        F.Free ;
    end;
end;

procedure Tfrm_GenSerialNFE.FormShow(Sender: TObject);
var
  F: TMemIniFile ;
begin
    cbx_CNPJ.Clear ;
    cbx_CNPJ.AddItem(Format('%s|%s',[Empresa.CNPJ,Empresa.RzSoci]),Empresa);
    cbx_CNPJ.ItemIndex :=0;
    cbx_Modelo.ItemIndex:=0;
    //
    F :=TMemIniFile.Create(ApplicationPath +'Configuracoes.ini') ;
    try
      edt_NSerie.IntValue :=F.ReadInteger('Impressora Caixa', 'Numero Caixa', 0);
    finally
      F.Free ;
    end;
    ActiveControl :=edt_Value ;
end;

end.
