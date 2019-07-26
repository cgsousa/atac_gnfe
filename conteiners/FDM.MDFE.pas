unit FDM.MDFE;

interface

uses
  SysUtils, Classes,
  ACBrDFeReport, ACBrMDFeDAMDFeClass, ACBrMDFeDAMDFeRLClass,
  ACBrBase, ACBrDFe, ACBrMDFe, ACBrMail;

type
  Tdm_mdfe = class(TDataModule)
    m_MDFe: TACBrMDFe;
    m_DAMDFeRL: TACBrMDFeDAMDFeRL;
    m_Mail: TACBrMail;
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(aRemoveDataModule: Boolean); reintroduce;
  end;

var
  dm_mdfe: Tdm_mdfe;

implementation

{$R *.dfm}


{ Tdm_mdfe }

constructor Tdm_mdfe.Create(aRemoveDataModule: Boolean);
begin
    inherited Create(nil);
    if aRemoveDataModule then
    begin
        RemoveDataModule(Self);
    end;
end;

end.
