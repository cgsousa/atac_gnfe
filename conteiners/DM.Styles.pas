unit DM.Styles;

interface

uses
  SysUtils, Classes, AdvPanel;

type
  Tdm_Syles = class(TDataModule)
    AdvPanelStyler1: TAdvPanelStyler;
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(); reintroduce;
  end;

var
  dm_Syles: Tdm_Syles;

implementation

{$R *.dfm}

{ Tdm_Syles }

constructor Tdm_Syles.Create;
begin

end;

end.
