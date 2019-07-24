unit Form.Condutor;

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
  uCondutorCtr
  ;

type
  Tfrm_Condutor = class(TBaseForm, IView)
    pnl_Footer: TJvFooter;
    btn_Close: TJvFooterBtn;
    btn_New: TJvFooterBtn;
    btn_Save: TJvFooterBtn;
    JvGradient1: TJvGradient;
    gbx_Veiculo: TAdvGroupBox;
    edt_Codigo: TAdvEditBtn;
    edt_CNPJ: TAdvMaskEdit;
    edt_Nome: TAdvEdit;
    edt_RNTRC: TAdvEdit;
    cbx_TipPes: TAdvComboBox;
    cbx_TipProp: TAdvComboBox;
    btn_Cancel: TJvFooterBtn;
    btn_Delete: TJvFooterBtn;
    btn_Edit: TJvFooterBtn;
    lbl_State: TStaticText;
    edt_IE: TAdvEdit;
    cbx_UF: TAdvComboBox;
    lbl_ResetCombo: TLabel;
    procedure btn_CloseClick(Sender: TObject);
    procedure btn_NewClick(Sender: TObject);
    procedure btn_SaveClick(Sender: TObject);
    procedure edt_CodigoClickBtn(Sender: TObject);
    procedure btn_EditClick(Sender: TObject);
    procedure btn_CancelClick(Sender: TObject);
    procedure cbx_TipPesChange(Sender: TObject);
    procedure cbx_TipPropChange(Sender: TObject);
    procedure btn_DeleteClick(Sender: TObject);
  private
    { Private declarations }
    //m_Model: IVeiculo ;
    m_Ctrl: ICondutorCtr ;
    procedure FormatCod ;
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  public
    { Public declarations }
    constructor Create(aCtrl: ICondutorCtr); reintroduce ;
    procedure Inicialize;
    procedure ModelChanged;
    procedure Execute;
  end;


implementation

{$R *.dfm}

uses DB,
  uTaskDlg, uCondutor, udbconst
  ;


{ Tfrm_Veiculo }

procedure Tfrm_Condutor.btn_CancelClick(Sender: TObject);
begin
    m_Ctrl.Inicialize ;
    ModelChanged ;
end;

procedure Tfrm_Condutor.btn_CloseClick(Sender: TObject);
begin
    ModalResult :=mrCancel ;

end;

procedure Tfrm_Condutor.btn_DeleteClick(Sender: TObject);
begin
  //
end;

procedure Tfrm_Condutor.btn_EditClick(Sender: TObject);
begin
    m_Ctrl.Edit
    ;

end;

procedure Tfrm_Condutor.btn_NewClick(Sender: TObject);
begin
    m_Ctrl.Insert
    ;

end;

procedure Tfrm_Condutor.btn_SaveClick(Sender: TObject);
begin
    //
    // set model
    m_Ctrl.Model.tpPessoa :=cbx_TipPes.ItemIndex;
    m_Ctrl.Model.CPFCNPJ  :=edt_CNPJ.Text;
    m_Ctrl.Model.Nome   :=edt_Nome.Text;
    m_Ctrl.Model.tpProp :=cbx_TipProp.ItemIndex;
    m_Ctrl.Model.RNTRC  :=edt_RNTRC.Text;
    m_Ctrl.Model.IE :=edt_IE.Text;
    m_Ctrl.Model.UF :=cbx_UF.Text;
    try
        if m_Ctrl.Merge =mukInsert then
        begin
            CMsgDlg.Info(SInsertSucess,['CONDUTOR'])
        end
        else begin
            CMsgDlg.Info(SUpdateSucess,['CONDUTOR']);
        end;
    except
        on E: ECPFCNPJIsEmpty do
        begin
            CMsgDlg.Error(E.Message);
            edt_CNPJ.SetFocus ;
        end;

        on E: ENomeIsEmpty do
        begin
            CMsgDlg.Error(E.Message);
            edt_Nome.SetFocus ;
        end;

        on E: ERNTRCIsEmpty do
        begin
            CMsgDlg.Error(E.Message);
            edt_RNTRC.SetFocus ;
        end;

        on E: EIEIsEmpty do
        begin
            CMsgDlg.Error(E.Message);
            edt_IE.SetFocus ;
        end;

        on E: EUFIsEmpty do
        begin
            CMsgDlg.Error(E.Message);
            cbx_UF.SetFocus ;
        end;
    end;
end;


procedure Tfrm_Condutor.cbx_TipPesChange(Sender: TObject);
begin
    //
    // format pes. fisica
    if cbx_TipPes.ItemIndex =0 then
    begin
        edt_CNPJ.LabelCaption :='C.P.F.:' ;
        edt_CNPJ.EditMask :='000\.000\.000\.-00;0; ';
    end
    //
    // format pes. fisica
    else begin
        edt_CNPJ.LabelCaption :='C.N.P.J.:' ;
        edt_CNPJ.EditMask :='00\.000\.000\/0000\-00;0; ';
    end;
end;

procedure Tfrm_Condutor.cbx_TipPropChange(Sender: TObject);
begin
    //
    // tipo condutor é um proprietário d veiculo
    if cbx_TipProp.ItemIndex > -1 then
    begin
        edt_RNTRC.Enabled :=True ;
        edt_IE.Enabled :=True ;
        cbx_UF.Enabled :=True ;
        lbl_ResetCombo.Visible :=True ;
    end
    //
    // tipo condutor não é um proprietário d veiculo
    else begin
        edt_RNTRC.Clear ;
        edt_RNTRC.Enabled :=False ;
        edt_IE.Clear ;
        edt_IE.Enabled :=False ;
        cbx_UF.ItemIndex :=-1 ;
        cbx_UF.Enabled :=False ;
        lbl_ResetCombo.Visible :=False ;
    end;
end;

constructor Tfrm_Condutor.Create(aCtrl: ICondutorCtr);
begin
    inherited Create(Application);
    m_Ctrl :=aCtrl ;

end;

procedure Tfrm_Condutor.edt_CodigoClickBtn(Sender: TObject);
var
  F: TCondutorFilter ;
  V,C: Int32 ;
begin
    if edt_Codigo.IsEmpty() then
    begin
        CMsgDlg.Warning('Digite um codigo e/ou um nome do condutor!');
        edt_Codigo.SetFocus ;
    end
    else begin
        Val(edt_Codigo.Text, V, C) ;
        try
            //
            // busca por nome
            if C > 0 then
            begin
                F.codseq :=V ;
                F.cpfcnpj:='';
                F.xnome  :='';
            end
            //
            // nusca por ID
            else begin
                F.codseq :=0 ;
                F.cpfcnpj:='';
                F.xnome  :=edt_Codigo.Text;
            end;
            m_Ctrl.cmdFind(F);
        except
            on E: EBuscaIsEmpty do
            begin
                CMsgDlg.Error(E.Message);
                edt_Codigo.SetFocus ;
            end;
        end;
    end;
end;

procedure Tfrm_Condutor.Execute;
begin
    Self.ShowModal
    ;
end;

procedure Tfrm_Condutor.FormatCod;
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

procedure Tfrm_Condutor.Inicialize;
begin
    if m_Ctrl.Model.id > 0 then
        edt_Codigo.IntValue :=m_Ctrl.Model.id
    else
        edt_Codigo.Clear ;

    cbx_TipPes.ItemIndex :=m_Ctrl.Model.tpPessoa ;
    cbx_TipPesChange(cbx_TipPes);

    edt_CNPJ.Text :=m_Ctrl.Model.CPFCNPJ;
    edt_Nome.Text :=m_Ctrl.Model.Nome;

    cbx_TipProp.ItemIndex :=m_Ctrl.Model.tpProp ;
    cbx_TipPropChange(cbx_TipProp);

    edt_RNTRC.Text :=m_Ctrl.Model.RNTRC;
    edt_IE.Text :=m_Ctrl.Model.IE;
    cbx_UF.ItemIndex :=cbx_UF.Items.IndexOf(m_Ctrl.Model.UF);

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

        msEdit:
        begin
            FormatCod ;
            gbx_Veiculo.Enabled:=True ;
            gbx_Veiculo.CheckBox.State :=cbChecked ;
            ActiveControl :=edt_Nome;
        end;

        msInsert:
        begin
            FormatCod ;
            gbx_Veiculo.Enabled:=True ;
            gbx_Veiculo.CheckBox.State :=cbChecked ;
            ActiveControl :=edt_CNPJ;
        end;

    end;

    btn_New.Enabled :=m_Ctrl.Model.State = msInactive;
    btn_Save.Enabled:=m_Ctrl.Model.State in[msInsert, msEdit];
    btn_Cancel.Enabled:=m_Ctrl.Model.State in[msInsert, msEdit];
    btn_Delete.Enabled:=m_Ctrl.Model.State = msBrowse;
    btn_Edit.Enabled  :=m_Ctrl.Model.State = msBrowse;

end;

procedure Tfrm_Condutor.KeyDown(var Key: Word; Shift: TShiftState);
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
        if ActiveControl =edt_Codigo then
        begin
            edt_Codigo.ReadOnly:=False;
            m_Ctrl.Inicialize;
            ModelChanged ;
        end
        else if ActiveControl =cbx_TipProp then
        begin
            cbx_TipProp.ItemIndex :=-1;
        end
    else
        inherited;
    end;
end;

procedure Tfrm_Condutor.ModelChanged;
begin
    //
    // atualiza o state
    Inicialize ;
end;



end.
