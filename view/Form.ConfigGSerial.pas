unit Form.ConfigGSerial;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ExtCtrls, ComCtrls,
  Generics.Collections ,

  //JEDI
  JvExStdCtrls, JvExExtCtrls, JvExtComponent, JvCtrls,
  JvButton, JvFooter, JvToolEdit, JvGroupBox,

  //TMS
  AdvPanel, AdvEdit, JvExMask, AdvGlowButton, AdvOfficeButtons, AdvGroupBox,
  AdvCombo,

  //
  FormBase, unotfis00, JvExControls, JvGradient;


type
  TStyleView = (svNew, svModif) ;
  Tfrm_ConfigGSerial = class(TBaseForm)
    pnl_Footer: TJvFooter;
    btn_OK: TJvFooterBtn;
    btn_Close: TJvFooterBtn;
    edt_CNPJ: TAdvEdit;
    cbx_Modelo: TAdvComboBox;
    edt_NSerie: TAdvEdit;
    edt_Value: TAdvEdit;
    edt_Descri: TAdvEdit;
    JvGradient1: TJvGradient;
    procedure cbx_ModeloSelect(Sender: TObject);
    procedure btn_OKClick(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
  private
    { Private declarations }
    m_Serial: TCGenSerial ;
    m_StyleView: TStyleView;
    procedure setStyleView(const aStyleView: TStyleView);
  public
    { Public declarations }
    class function fn_Execute(const aStyleView: TStyleView;
      aSerial: TCGenSerial =nil): Boolean ;
  end;


implementation

uses MaskUtils, DB ,
  uTaskDlg, uadodb;


{$R *.dfm}

{ Tfrm_Config01 }

procedure Tfrm_ConfigGSerial.btn_CloseClick(Sender: TObject);
begin
    ModalResult :=mrCancel ;

end;

procedure Tfrm_ConfigGSerial.btn_OKClick(Sender: TObject);
var
  K,T: string ;
begin
    //
    // valid
    if edt_NSerie.IntValue < 1 then
    begin
        CMsgDlg.Warning('Número de série inválido!') ;
        edt_NSerie.SetFocus ;
        Exit ;
    end;

    if edt_Value.IntValue < 1 then
    begin
        CMsgDlg.Warning('Valor atual da sequencia inválido!') ;
        edt_Value.SetFocus ;
        Exit ;
    end;

    //
    // Key
    if cbx_Modelo.ItemIndex =0 then
    begin
        K :=Format('nfe.%s.nserie.%.3d',[edt_CNPJ.Text,edt_NSerie.IntValue]) ;
        T :='UUID para NFE por CNPJ/MOD/SERIE' ;
    end
    else begin
        K :=Format('nfce.%s.nserie.%.3d',[edt_CNPJ.Text,edt_NSerie.IntValue]);
        T :='UUID para NFCE por CNPJ/MOD/SERIE';
    end;

    //
    // confirm
    if CMsgDlg.Confirm('Deseja gravar o serial?') then
    begin
        if m_StyleView =svNew then
        begin
            if TCGenSerial.ReadVal(K) then
            begin
                CMsgDlg.Warning('Já existe um serial para esta composição!') ;
            end
            else begin
                TCGenSerial.SetVal( K, T, edt_Value.IntValue, 1, 1, 999999999 ) ;
                m_Serial :=TCGenSerial.Create ;
                if m_Serial.Load(K) then
                begin
                    m_Serial.Value :=edt_Value.IntValue ;
                    m_Serial.m_UpdVal() ;
                end;
                m_Serial.Free;
            end;
        end
        else begin
            if Assigned(m_Serial) then
            begin
                m_Serial.Value :=edt_Value.IntValue ;
                m_Serial.m_UpdVal() ;
            end;
        end;
        ModalResult :=mrOk ;
    end;
end;

procedure Tfrm_ConfigGSerial.cbx_ModeloSelect(Sender: TObject);
begin
    if cbx_Modelo.ItemIndex = 0 then
        edt_Descri.Text :='UUID para NFE por CNPJ/MOD/SERIE'
    else
        edt_Descri.Text :='UUID para NFCE por CNPJ/MOD/SERIE';
end;

class function Tfrm_ConfigGSerial.fn_Execute(const aStyleView: TStyleView;
  aSerial: TCGenSerial): Boolean;
var
  F: Tfrm_ConfigGSerial;
begin
    F :=Tfrm_ConfigGSerial.Create(Application);
    try
        F.m_StyleView :=aStyleView ;
        F.m_Serial    :=aSerial ;
        F.DoClear(F);
        F.DoEnabledControls(F, False);
        F.setStyleView(aStyleView);
        F.pnl_Footer.Enabled :=True ;
        Result :=F.ShowModal =mrOk ;
    finally
        FreeAndNil(F) ;
    end;
end;

procedure Tfrm_ConfigGSerial.setStyleView(const aStyleView: TStyleView);
begin
    case aStyleView of
        svNew:
        begin
            Self.Caption :='Nova numeração' ;
            edt_CNPJ.Text :=Empresa.CNPJ ;
            cbx_Modelo.Enabled :=True ;
            cbx_Modelo.ItemIndex:=0;
            cbx_ModeloSelect(nil);
            edt_NSerie.Enabled :=True ;
            edt_NSerie.IntValue :=1;
            edt_Value.Enabled :=True ;
            edt_Value.IntValue :=1;
            ActiveControl :=edt_NSerie ;
        end;
        //
        // modifica
        svModif:
        begin
            Self.Caption :=Format('%s[Modifica]',[m_Serial.Id]) ;
            edt_CNPJ.Text :=m_Serial.CNPJ ;
            if m_Serial.CodMod = 55 then
                cbx_Modelo.ItemIndex:=0
            else
                cbx_Modelo.ItemIndex:=1;
            cbx_ModeloSelect(nil);
            edt_NSerie.IntValue :=m_Serial.NumSer ;
            edt_Value.Enabled   :=True ;
            edt_Value.IntValue  :=m_Serial.Value ;
            ActiveControl :=edt_Value ;
        end;
    end;
end;


end.
