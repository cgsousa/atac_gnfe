{***
* View para tratar justificativa do cancelamento/inutilização da (NF-e/NFC-e)
* Atac Sistemas
* Todos os direitos reservados
* Autor: Carlos Gonzaga
* Data: 20.02.2018
*}
unit Form.Justifica;

{*
******************************************************************************
|* PROPÓSITO: Registro de Alterações
******************************************************************************

Símbolo : Significado

[+]     : Novo recurso
[*]     : Recurso modificado/melhorado
[-]     : Correção de Bug (assim esperamos)


18.05.2018
[-] Qdo seleciona uma NF no gerenciador para inutilização!

*}


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  JvExStdCtrls, JvButton, JvCtrls, JvFooter, JvExExtCtrls, JvExtComponent,
  JvPageList, JvExControls,
  HTMLabel, AdvEdit, AdvGroupBox,
  VirtualTrees,
  FormBase, uVSTree, unotfis00;

type
  Tfrm_JustifStyleView = (svCancel, svInut) ;
  Tfrm_Justif = class(TBaseForm)
    pnl_Footer: TJvFooter;
    btn_Close: TJvFooterBtn;
    btn_OK: TJvFooterBtn;
    edt_Text: TAdvEdit;
    html_Prompt: THTMLabel;
    pnl_Inut: TPanel;
    vst_Grid1: TVirtualStringTree;
    AdvGroupBox1: TAdvGroupBox;
    edt_NumIni: TAdvEdit;
    edt_NumFin: TAdvEdit;
    procedure btn_CloseClick(Sender: TObject);
    procedure btn_OKClick(Sender: TObject);
    procedure vst_Grid1GetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vst_Grid1Change(Sender: TBaseVirtualTree; Node: PVirtualNode);
  private
    { Private declarations }
//    m_CodMod, m_NSerie: Word ;
//    m_NumIni, m_NumFin: Int32 ;
    m_Text: string;
    m_Numeros: TCInutNumeroList;
    m_InutNum: TCInutNumero ;
    m_NF: TCNotFis00 ;
    m_Index: Integer;
    m_StyleView: Tfrm_JustifStyleView ;
    procedure setStyleView(Value: Tfrm_JustifStyleView);
  public
    { Public declarations }
//    property CodMod: Word read m_CodMod;
//    property NumSer: Word read m_NSerie;
//    property NumIni: Int32 read m_NumIni ;
//    property NumFin: Int32 read m_NumFin ;
    property Text: string read m_Text;
    property InutNum: TCInutNumero read m_InutNum;
    procedure AddPar();
    procedure AddText(const AFormat: string); overload;
    procedure AddText(const AFormat: string; const Args: array of const); overload;
    function Execute(): Boolean; overload;
    function Execute(const nserie: Word; nf: TCNotFis00 =nil): Boolean; overload;
  end;


function NewJustifica(const AStyle: Tfrm_JustifStyleView): Tfrm_Justif;


implementation

{$R *.dfm}

uses MaskUtils, DateUtils, Strutils ,
  uTaskDlg, uadodb;


function NewJustifica(const AStyle: Tfrm_JustifStyleView): Tfrm_Justif;
begin
    Result :=Tfrm_Justif.Create(Application);
    Result.html_Prompt.HTMLText.Clear;
    Result.AddText('<FONT face="Verdana" color="#FF0000" size="12"><b>ATENÇÃO!</b></FONT>');
    Result.AddPar();
    Result.setStyleView(AStyle);
end;


{ Tfrm_Justif }

procedure Tfrm_Justif.AddPar;
begin
    Self.html_Prompt.HTMLText.Add('<P></P>');

end;

procedure Tfrm_Justif.AddText(const AFormat: string);
begin
    Self.html_Prompt.HTMLText.Add(AFormat);

end;


procedure Tfrm_Justif.AddText(const AFormat: string;
  const Args: array of const);
begin
    Self.AddText(Format(AFormat, Args));

end;

procedure Tfrm_Justif.btn_CloseClick(Sender: TObject);
begin
    Self.Close ;

end;

procedure Tfrm_Justif.btn_OKClick(Sender: TObject);
var
  text: string;
  ok: Boolean;
begin
    ok :=True;
    text :=Trim(Self.edt_Text.Text);
    if Length(text) < 15 then
    begin
        CMsgDlg.Info('A justificativa deve ter no min. 15 caracteres!');
        ActiveControl :=edt_Text;
    end
    else begin
        if m_StyleView = svInut then
        begin
            if edt_NumIni.IntValue = 0 then
            begin
                CMsgDlg.Info('O número inicial de ser informado!');
                ActiveControl :=edt_NumIni;
                ok :=False;
            end
            else if edt_NumIni.IntValue > edt_NumFin.IntValue then
            begin
                CMsgDlg.Info('O número inicial é maior que número final!');
                ActiveControl :=edt_NumIni;
                ok :=False;
            end;

            m_InutNum :=m_Numeros.Items[m_Index] ;
            m_InutNum.m_numini :=edt_NumIni.IntValue ;
            m_InutNum.m_numfin :=edt_NumFin.IntValue ;

        end;
        m_Text :=Self.edt_Text.Text ;
        if ok and CMsgDlg.Warning('Tem certeza de que quer continuar!', True) then
        begin
            ModalResult :=mrOk;
        end;
    end;
end;

function Tfrm_Justif.Execute: Boolean;
begin
    Result :=Self.ShowModal =mrOk ;

end;

function Tfrm_Justif.Execute(const nserie: Word; nf: TCNotFis00): Boolean;
var
  N: TCInutNumero ;
  P: PVirtualNode ;
  found: Boolean;
begin
    Result :=m_Numeros.LoadOfSerie(0) ;
    if Result then
    begin

        if nf <> nil then
        Self.AddText('<FONT face="Verdana" color="#008000" size="10">Número do Caixa: %.2d</FONT>',[nserie])
        else
        Self.AddText('<FONT face="Verdana" color="#008000" size="10">Número do Caixa: %.2d, selecione a serie na grade!</FONT>',[nserie]);

        m_NF :=nf ;
        m_Index :=0;
        found :=False;
        for N in m_Numeros do
        begin
            P :=vst_Grid1.AddChild(nil) ;
            if m_NF <> nil then
            begin
                if(N.m_cnpj   =m_NF.m_emit.CNPJCPF)and
                  (N.m_codmod =m_NF.m_codmod)and
                  (N.m_nserie =m_NF.m_nserie)then
                begin
                    P.States :=P.States +[vsSelected] ;
                    m_Index :=P.Index ;
                    found :=True;
                end;
            end;
        end;

        if found then
        begin
            vst_Grid1.IndexItem :=P.Index ;
            vst_Grid1.Enabled :=False;
            edt_NumIni.IntValue :=m_NF.m_numdoc ;
            edt_NumFin.IntValue :=m_NF.m_numdoc ;
            ActiveControl :=edt_NumIni ;
        end
        else begin
            vst_Grid1.IndexItem :=0;
//            ActiveControl :=vst_Grid1 ;
        end;
        Result :=Self.Execute;
    end
    else
        CMsgDlg.Warning(Format('Nenhuma numeração encontrada para CX/serie: %d',[nserie]));
end;

procedure Tfrm_Justif.setStyleView(Value: Tfrm_JustifStyleView);
begin
    case Value of
        svCancel:
        begin
            Self.Caption :='.:Cancelamento:.';
            Self.Height :=225;
            Self.pnl_Inut.Visible :=False ;
            Self.AddText('<FONT face="Verdana" color="#FF0000" size="10">Uma vez cancelada a NFe, vai também comtabilizar a mesma. Portanto tenha certeza do procedimento!</FONT>');
            Self.AddPar ;
            ActiveControl :=edt_Text ;
        end;
        svInut:
        begin
            Self.Caption :='.:Inutilização de numeração:.';
            Self.Height :=405;
            Self.pnl_Inut.Visible :=True ;

            m_Numeros :=TCInutNumeroList.Create ;
            vst_Grid1.Clear ;

            Self.AddText('<FONT face="Verdana" color="#FF0000" size="10">Verifique junto ao admin/supervisor a correta inutilização de sequencia!</FONT>');
            Self.AddText('<FONT face="Verdana" color="#FF0000" size="10">Uma vez inutilizados, os números não podem ser mais usados.</FONT>');
            Self.AddPar ;
            Self.AddPar ;
        end;
    end;
    m_StyleView :=Value ;
end;


procedure Tfrm_Justif.vst_Grid1Change(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
    if Assigned(Node) then
    begin
        m_InutNum :=m_Numeros.Items[Node.Index] ;

        if Self.m_NF <> nil then
        begin
            edt_NumIni.IntValue :=m_NF.m_numdoc ;
        end
        else begin
            edt_NumIni.IntValue :=m_InutNum.m_numfin +1 ;
        end;

        edt_NumFin.IntValue :=edt_NumIni.IntValue;
    end;
end;

procedure Tfrm_Justif.vst_Grid1GetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
begin
    CellText :='';
    if Assigned(Node) then
    begin
        //00.000.000/0000-00
        m_InutNum :=m_Numeros.Items[Node.Index] ;
        case Column of
            0: CellText :=IntToStr(InutNum.m_ano);
            1: CellText :=FormatMaskText('00\.000\.000\/0000\-00;0; ', m_InutNum.m_cnpj);
            2: CellText :=ifthen(m_InutNum.m_codmod=55, 'NFe', 'NFCe');
            3: CellText :=Format('%.3d',[m_InutNum.m_nserie]);
            4: CellText :=Format('%.6d',[m_InutNum.m_numfin]);
        end;
    end;
end;

end.
