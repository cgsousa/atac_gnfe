program ATAC_APP_NFE;

uses
  Forms,
  unotfis00 in 'model\unotfis00.pas',
  Form.NFEStatus in 'view\Form.NFEStatus.pas' {frm_NFEStatus},
  FDM.NFE in 'view\FDM.NFE.pas' {dm_nfe: TDataModule},
  Form.Justifica in 'view\Form.Justifica.pas' {frm_Justif},
  Form.Inutiliza in 'view\Form.Inutiliza.pas' {frm_Inutiliza},
  Form.Princ00 in 'view\Form.Princ00.pas' {frm_Princ00},
  Form.RelNFRL00 in 'view\Form.RelNFRL00.pas' {frm_RelNFRL00},
  Form.Ajuda in 'view\Form.Ajuda.pas' {frm_Ajuda},
  Form.EnvioLote in 'view\Form.EnvioLote.pas' {frm_EnvLote},
  Form.Items in 'view\Form.Items.pas' {frm_Items},
  ucce in 'model\ucce.pas',
  Form.CCEList in 'view\Form.CCEList.pas' {frm_CCEList},
  Form.CCE in 'view\Form.CCE.pas' {frm_CCE},
  uACBrNFe in 'model\uACBrNFe.pas',
  Form.GenSerialNFE in 'view\Form.GenSerialNFE.pas' {frm_GenSerialNFE},
  Form.RelNFRL02 in 'view\Form.RelNFRL02.pas' {frm_RelNFRL02},
  Thread.NFE in 'model\Thread.NFE.pas',
  Form.ExportXML in 'view\Form.ExportXML.pas' {frm_ExportXML},
  ueventonfe in 'model\ueventonfe.pas';

{$R *.res}
{$R ATAC_APP_NFE.UAC.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Atac Gerenciador da NFE';
  Application.CreateForm(Tfrm_Princ00, frm_Princ00);
  Application.Run ;
end.
