{***
* View que mostra os detalhes (items) da NFE
* Atac Sistemas
* Todos os direitos reservados
* Autor: Carlos Gonzaga
* Data: 19.07.2018
*}
unit Form.Items;

{*
******************************************************************************
|* PROPÓSITO: Registro de Alterações
******************************************************************************

Símbolo : Significado

[+]     : Novo recurso
[*]     : Recurso modificado/melhorado
[-]     : Correção de Bug (assim esperamos)


*}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ExtCtrls,
  //
  VirtualTrees, uVSTree,
  //
  FormBase,
  unotfis00, JvExStdCtrls, JvButton, JvCtrls, JvFooter, JvExExtCtrls,
  JvExtComponent ;

type
  Tfrm_Items = class(TBaseForm)
    vst_Grid1: TVirtualStringTree;
    pnl_Footer: TJvFooter;
    btn_Close: TJvFooterBtn;
    lbl_vNF: TLabel;
    procedure btn_CloseClick(Sender: TObject);
  private
    { Private declarations }
    m_notfis: TCNotFis00 ;
    procedure Load ;

    procedure OnFormatText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);

  public
    { Public declarations }
    class procedure pc_Show(aNF: TCNotFis00) ;
  end;


implementation

{$R *.dfm}

uses pcnConversao;


{ Tfrm_Items }

procedure Tfrm_Items.btn_CloseClick(Sender: TObject);
begin
    Self.Close
    ;
end;

procedure Tfrm_Items.Load;
var
  C: TVirtualTreeColumn ;
begin
    Self.Caption :=Format('Nota Fiscal:%.8d, Modelo:%d, Série:%.3d',[
      m_notfis.m_numdoc, m_notfis.m_codmod, m_notfis.m_nserie]);
    Self.Caption :=Self.Caption +FormatDateTime('", Emissão:"dd/mm/yyyy',m_notfis.m_dtemis);
    //
    // situação
    {case m_notfis.m_codstt of
      100: Self.Caption :=Self.Caption +Format('Autorizado uso / %s',[N.m_numprot]);

      101,
      135,
      151,
      155: lbl_Status.Caption :='NF-e CANCELADA';

      110,
      205,
      301,
      302: lbl_Status.Caption :=Format('NF-e DENEGADA / %s',[N.m_numprot]);
      else
          lbl_Status.Caption :=N.m_motivo;
    end;}
    C :=vst_Grid1.Header.Columns[5] ;
    if m_notfis.m_emit.CRT =crtRegimeNormal then
    begin
        C.Text :='CST' ;
    end
    else begin
        C.Text :='CSOSN';
    end;
    vst_Grid1.RootNodeCount :=m_notfis.Items.Count ;
    lbl_vNF.Caption :=Format('Valor da NF: %12.2m',[m_notfis.m_icmstot.vNF]);
end;

procedure Tfrm_Items.OnFormatText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  I: TCNotFis01 ;
begin
    CellText :='';
    I :=m_notfis.Items[Node.Index] ;
    case Column of
        00: CellText :=Format('%.3d',[I.ItemIndex+1]) ;
        01: CellText :=I.m_codpro ;
        02: CellText :=I.m_codean ;
        03: CellText :=UpperCase(I.m_descri) ;
        04: CellText :=I.m_codncm ;
        05: if m_notfis.m_emit.CRT =crtRegimeNormal then
            begin
                CellText :=IntToStr(I.m_cst);
            end
            else begin
                CellText :=IntToStr(I.m_csosn);
            end;
        06: CellText :=Format('%5d',[I.m_cfop]) ;
        07: CellText :=I.m_undcom ;
        08: CellText :=Format('%5.3n',[I.m_qtdcom]) ;
        09: CellText :=Format('%9.2n',[I.m_vlrcom]) ;
        10: CellText :=Format('%9.2n',[I.m_vlrpro]) ;
        11: CellText :=Format('%9.2n',[I.m_vbc]) ;
        12: CellText :=Format('%5.2n',[I.m_picms]) ;
        13: CellText :=Format('%9.2n',[I.m_vicms]) ;
        14: CellText :=Format('%9.2n',[I.m_ipi.vIPI]) ;
        15: CellText :=Format('%5.2n',[I.m_ipi.pIPI]) ;
    end;
end;

class procedure Tfrm_Items.pc_Show(aNF: TCNotFis00);
var
  F: Tfrm_Items ;
begin
    F :=Tfrm_Items.Create(Application);
    try
        F.m_notfis :=aNF ;
        F.vst_Grid1.Clear;
        F.vst_Grid1.OnBeforeCellPaint :=F.vst_Grid1.DoCellPaint;
        F.vst_Grid1.OnGetText :=F.OnFormatText;
        F.Load ;
        F.ShowModal ;
    finally
        FreeAndNil(F) ;
    end;
end;

end.
