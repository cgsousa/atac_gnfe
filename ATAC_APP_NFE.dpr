program ATAC_APP_NFE;

uses
  Forms,
  unotfis00 in '..\..\..\SisGerCom.D2010\units\unotfis00.pas',
  Form.NFEStatus in '..\..\..\SisGerCom.D2010\view\nfe\Form.NFEStatus.pas' {frm_NFEStatus},
  FDM.NFE in '..\..\..\SisGerCom.D2010\view\nfe\FDM.NFE.pas' {dm_nfe: TDataModule},
  Form.Justifica in '..\..\..\SisGerCom.D2010\view\nfe\Form.Justifica.pas' {frm_Justif},
  Form.Inutiliza in '..\..\..\SisGerCom.D2010\view\nfe\Form.Inutiliza.pas' {frm_Inutiliza},
  Form.Princ00 in '..\..\..\SisGerCom.D2010\view\nfe\Form.Princ00.pas' {frm_Princ00},
  Form.Config in '..\..\..\SisGerCom.D2010\view\nfe\Form.Config.pas' {frm_Config},
  Form.RelNFRL00 in '..\..\..\SisGerCom.D2010\view\nfe\Form.RelNFRL00.pas' {frm_RelNFRL00},
  Form.Ajuda in '..\..\..\SisGerCom.D2010\view\nfe\Form.Ajuda.pas' {frm_Ajuda},
  Form.EnvioLote in '..\..\..\SisGerCom.D2010\view\nfe\Form.EnvioLote.pas' {frm_EnvLote},
  Form.ConfigGSerial in '..\..\..\SisGerCom.D2010\view\nfe\Form.ConfigGSerial.pas' {frm_ConfigGSerial},
  ucad.empresa in '..\..\..\SisGerCom.D2010\units\ucad.empresa.pas',
  Form.Items in '..\..\..\SisGerCom.D2010\view\nfe\Form.Items.pas' {frm_Items},
  ucce in '..\..\..\SisGerCom.D2010\units\ucce.pas',
  Form.CCEList in '..\..\..\SisGerCom.D2010\view\nfe\Form.CCEList.pas' {frm_CCEList},
  Form.CCE in '..\..\..\SisGerCom.D2010\view\nfe\Form.CCE.pas' {frm_CCE},
  Form.ParametroList in '..\..\..\SisGerCom.D2010\view\configuracoes\Form.ParametroList.pas' {frm_ParametroList},
  Form.Parametro in '..\..\..\SisGerCom.D2010\view\configuracoes\Form.Parametro.pas' {frm_Parametro},
  uparam in '..\..\..\SisGerCom.D2010\units\uparam.pas';

{$R *.res}
{$R ATAC_APP_NFE.UAC.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Atac Gerenciador da NFE';
  Application.CreateForm(Tfrm_Princ00, frm_Princ00);
  Application.Run ;
end.
