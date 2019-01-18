unit fdm.Styles;

interface

uses
  SysUtils, Classes,
  AdvOfficeStatusBar, AdvOfficeStatusBarStylers, AdvToolBarStylers, AdvToolBar,
  AdvMenuStylers, AdvMenus, AdvPanel;

type
  Tdm_Styles = class(TDataModule)
    AdvMenuStyler1: TAdvMenuStyler;
    AdvMenuOfficeStyler1: TAdvMenuOfficeStyler;
    AdvMenuFantasyStyler1: TAdvMenuFantasyStyler;
    AdvToolBarOfficeStyler1: TAdvToolBarOfficeStyler;
    AdvToolBarFantasyStyler1: TAdvToolBarFantasyStyler;
    AdvOfficeStatusBarOfficeStyler1: TAdvOfficeStatusBarOfficeStyler;
    AdvPanelStyler1: TAdvPanelStyler;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dm_Styles: Tdm_Styles;

implementation

{$R *.dfm}

end.
