unit Form.Veiculo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ExtCtrls, ActnList,
  FormBase, uIntf ,
  JvExStdCtrls, JvButton, JvCtrls, JvFooter,
  JvExExtCtrls, JvExtComponent, JvExControls, JvGradient,
  AdvGroupBox, AdvEdit, AdvEdBtn, AdvCombo,
  //
  //
  uVeiculoCtr
  ;

type
  Tfrm_Veiculo = class(TBaseForm, IView)
    pnl_Footer: TJvFooter;
    btn_Close: TJvFooterBtn;
    btn_New: TJvFooterBtn;
    btn_Save: TJvFooterBtn;
    JvGradient1: TJvGradient;
    gbx_Veiculo: TAdvGroupBox;
    edt_Codigo: TAdvEditBtn;
    edt_Placa: TAdvMaskEdit;
    edt_RENAVAM: TAdvEdit;
    edt_Tara: TAdvEdit;
    edt_CapKg: TAdvEdit;
    edt_CapM3: TAdvEdit;
    cbx_TipRod: TAdvComboBox;
    cbx_TipCar: TAdvComboBox;
    cbx_UF: TAdvComboBox;
    btn_Cancel: TJvFooterBtn;
    btn_Delete: TJvFooterBtn;
    btn_Edit: TJvFooterBtn;
    lbl_State: TStaticText;
    procedure btn_CloseClick(Sender: TObject);
    procedure btn_NewClick(Sender: TObject);
    procedure btn_SaveClick(Sender: TObject);
    procedure edt_CodigoClickBtn(Sender: TObject);
    procedure btn_EditClick(Sender: TObject);
    procedure btn_CancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    //m_Model: IVeiculo ;
    m_Ctrl: IVeiculoCtr ;
    procedure FormatCod ;
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  public
    { Public declarations }
    constructor Create(aCtrl: IVeiculoCtr); reintroduce ;
    procedure Inicialize;
    procedure ModelChanged;
    procedure Execute;
  end;


implementation

{$R *.dfm}

uses DB,
  uTaskDlg,
  uVeiculo, uManifestoDF, udbconst
  ;


{ Tfrm_Veiculo }

procedure Tfrm_Veiculo.btn_CancelClick(Sender: TObject);
begin
    m_Ctrl.Inicialize ;
    ModelChanged ;
end;

procedure Tfrm_Veiculo.btn_CloseClick(Sender: TObject);
begin
    ModalResult :=mrCancel ;

end;

procedure Tfrm_Veiculo.btn_EditClick(Sender: TObject);
begin
    m_Ctrl.Edit
    ;

end;

procedure Tfrm_Veiculo.btn_NewClick(Sender: TObject);
begin
    m_Ctrl.Insert
    ;

end;

procedure Tfrm_Veiculo.btn_SaveClick(Sender: TObject);
begin
    //
    // set model
    m_Ctrl.Model.placa :=edt_Placa.Text;
    m_Ctrl.Model.RENAVAM :=edt_RENAVAM.Text;
    m_Ctrl.Model.tara :=edt_Tara.IntValue;
    m_Ctrl.Model.capacidadeKg :=edt_CapKg.IntValue;
    m_Ctrl.Model.capacidadeM3 :=edt_CapM3.IntValue;
    m_Ctrl.Model.tipRodado     :=cbx_TipRod.ItemIndex;
    m_Ctrl.Model.tipCarroceria :=cbx_TipCar.ItemIndex;
//    m_Model.idProprietario:=0;
//    m_Model.tpProprietario:=0;
    m_Ctrl.Model.ufLicenca :=cbx_UF.Text;
    try
        if m_Ctrl.Merge =mukInsert then
        begin
            CMsgDlg.Info(SInsertSucess,['VEÍCULO'])
        end
        else begin
            CMsgDlg.Info(SUpdateSucess,['VEÍCULO']);
        end;
    except
        on E: EPlacaIsEmpty do
        begin
            CMsgDlg.Error(E.Message);
            edt_Placa.SetFocus ;
        end;

        on E: ETaraIsEmpty do
        begin
            CMsgDlg.Error(E.Message);
            edt_Tara.SetFocus ;
        end;

        on E: ETipRodIsEmpty do
        begin
            CMsgDlg.Error(E.Message);
            cbx_TipRod.SetFocus ;
        end;

        on E: ETipCarIsEmpty do
        begin
            CMsgDlg.Error(E.Message);
            cbx_TipCar.SetFocus ;
        end;

        on E: EUFIsEmpty do
        begin
            CMsgDlg.Error(E.Message);
            cbx_UF.SetFocus ;
        end;
    end;
end;


constructor Tfrm_Veiculo.Create(aCtrl: IVeiculoCtr);
begin
    inherited Create(Application);
    m_Ctrl :=aCtrl ;

    cbx_TipRod.AddText('"01 - Truck;","02 - Toco;","03 - Cavalo Mecânico;","04 - VAN;","05 - Utilitário;","06 - Outros."');
    cbx_TipCar.AddText('"00 - não aplicável;","01 - Aberta;","02 - Fechada/Baú;","03 - Granelera;","04 - Porta Container;","05 - Sider"');
    TCMunList.loadUF(cbx_UF.Items);
end;

procedure Tfrm_Veiculo.edt_CodigoClickBtn(Sender: TObject);
begin
    try
        if m_Ctrl.cmdFind(edt_Codigo.IntValue) then
        begin

        end;
    except
        on E: EBuscaIsEmpty do
        begin
            CMsgDlg.Error(E.Message);
            edt_Codigo.SetFocus ;
        end;
    end;
end;

procedure Tfrm_Veiculo.Execute;
begin
    Self.ShowModal
    ;
end;

procedure Tfrm_Veiculo.FormatCod;
begin
    case m_Ctrl.Model.State of
      msInactive:
      begin
          edt_Codigo.Enabled :=True;
          edt_Codigo.ReadOnly:=False;
          edt_Codigo.Color :=clWindow ;
          edt_Codigo.LabelCaption :='Código';
          lbl_State.Caption :='Nenhum';
      end;
      msBrowse:
      begin
          edt_Codigo.Enabled :=True;
          edt_Codigo.ReadOnly:=True;
          edt_Codigo.Color :=clMoneyGreen ;
          edt_Codigo.LabelCaption :='Tecla [back] cancela consulta:';
          lbl_State.Caption :='Consulta';
      end;
      msEdit:
      begin
          edt_Codigo.Enabled :=False;
          edt_Codigo.ReadOnly:=False;
          edt_Codigo.LabelCaption :='Código';
          lbl_State.Caption :='Edição';
      end;
      msInsert:
      begin
          edt_Codigo.Enabled :=False;
          edt_Codigo.ReadOnly:=False;
          edt_Codigo.LabelCaption :='Código';
          lbl_State.Caption :='Novo';
      end;
    end;
end;

procedure Tfrm_Veiculo.FormShow(Sender: TObject);
begin
    Self.Inicialize ;

end;

procedure Tfrm_Veiculo.Inicialize;
begin
    if m_Ctrl.Model.id > 0 then
        edt_Codigo.IntValue :=m_Ctrl.Model.id
    else
        edt_Codigo.Clear ;
    edt_Placa.Text    :=m_Ctrl.Model.placa ;
    edt_RENAVAM.Text  :=m_Ctrl.Model.RENAVAM;
    edt_Tara.IntValue :=m_Ctrl.Model.tara ;
    edt_CapKg.IntValue :=m_Ctrl.Model.capacidadeKg;
    edt_CapM3.IntValue :=m_Ctrl.Model.capacidadeM3;
    cbx_TipRod.ItemIndex :=m_Ctrl.Model.tipRodado ;
    cbx_TipCar.ItemIndex :=m_Ctrl.Model.tipCarroceria ;
    cbx_UF.ItemIndex :=cbx_UF.Items.IndexOf(m_Ctrl.Model.ufLicenca);

    //
    // muda o stado da view conforme o estado do model
    case m_Ctrl.Model.State of
        msInactive:
        begin
            FormatCod ;
            gbx_Veiculo.Enabled:=False;
            gbx_Veiculo.CheckBox.State :=cbUnchecked ;
            ActiveControl :=edt_Codigo ;
        end;

        msBrowse:
        begin
            FormatCod ;
            gbx_Veiculo.Enabled:=False;
            gbx_Veiculo.CheckBox.State :=cbChecked ;
            ActiveControl :=edt_Codigo ;
        end;

        msEdit,msInsert:
        begin
            FormatCod ;
            gbx_Veiculo.Enabled:=True ;
            gbx_Veiculo.CheckBox.State :=cbChecked ;
            ActiveControl :=edt_Placa;
        end;
    end;

    btn_New.Enabled :=m_Ctrl.Model.State = msInactive;
    btn_Save.Enabled:=m_Ctrl.Model.State in[msInsert, msEdit];
    btn_Cancel.Enabled:=m_Ctrl.Model.State in[msInsert, msEdit];
    btn_Delete.Enabled:=m_Ctrl.Model.State = msBrowse;
    btn_Edit.Enabled  :=m_Ctrl.Model.State = msBrowse;

end;

procedure Tfrm_Veiculo.KeyDown(var Key: Word; Shift: TShiftState);
begin
    case Key of
        VK_RETURN:
        if ActiveControl =edt_Codigo then
        begin
            edt_CodigoClickBtn(edt_Codigo) ;
        end
        else begin
            inherited;
        end;

        VK_BACK:
        begin
            edt_Codigo.ReadOnly:=False;
            m_Ctrl.Inicialize;
            ModelChanged ;
        end;
    else
        inherited;
    end;
end;

procedure Tfrm_Veiculo.ModelChanged;
begin
    //
    // atualiza o state
    Inicialize ;
end;



end.
