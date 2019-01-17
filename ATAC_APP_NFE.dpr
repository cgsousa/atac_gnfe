program ATAC_APP_NFE;

uses
  Forms,
  unotfis00 in 'model\unotfis00.pas',
  Form.NFEStatus in 'view\Form.NFEStatus.pas' {frm_NFEStatus},
  FDM.NFE in 'view\FDM.NFE.pas' {dm_nfe: TDataModule},
  Form.Justifica in 'view\Form.Justifica.pas' {frm_Justif},
  Form.Inutiliza in 'view\Form.Inutiliza.pas' {frm_Inutiliza},
  Form.Princ00 in 'view\Form.Princ00.pas' {frm_Princ00},
  Form.Config in 'view\Form.Config.pas' {frm_Config},
  Form.RelNFRL00 in 'view\Form.RelNFRL00.pas' {frm_RelNFRL00},
  Form.Ajuda in 'view\Form.Ajuda.pas' {frm_Ajuda},
  Form.EnvioLote in 'view\Form.EnvioLote.pas' {frm_EnvLote},
  Form.ConfigGSerial in 'view\Form.ConfigGSerial.pas' {frm_ConfigGSerial},
  Form.Items in 'view\Form.Items.pas' {frm_Items},
  ucce in 'model\ucce.pas',
  Form.CCEList in 'view\Form.CCEList.pas' {frm_CCEList},
  Form.CCE in 'view\Form.CCE.pas' {frm_CCE},
  fdm.Styles in 'conteiners\fdm.Styles.pas' {dm_Styles: TDataModule},
  uIntf in 'interfaces\uIntf.pas',
  uCondutor in 'mdfe\uCondutor.pas',
  uManifestoDF in 'mdfe\uManifestoDF.pas',
  uVeiculo in 'mdfe\uVeiculo.pas',
  uCondutorCtr in 'mdfe\controller\uCondutorCtr.pas',
  uManifestoCtr in 'mdfe\controller\uManifestoCtr.pas',
  uVeiculoCtr in 'mdfe\controller\uVeiculoCtr.pas',
  Form.ManifestoList in 'mdfe\view\Form.ManifestoList.pas' {frm_ManifestoList},
  Form.Manifesto in 'mdfe\view\Form.Manifesto.pas' {frm_Manifesto},
  Form.Condutor in 'mdfe\view\Form.Condutor.pas' {frm_Condutor},
  Form.Veiculo in 'mdfe\view\Form.Veiculo.pas' {frm_Veiculo};

{$R *.res}
{$R ATAC_APP_NFE.UAC.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Atac Gerenciador da NFE';
  Application.CreateForm(Tfrm_Princ00, frm_Princ00);
  Application.CreateForm(Tdm_Styles, dm_Styles);
  Application.Run ;
end.
