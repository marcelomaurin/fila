unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Menus, menu;

const
  Arquivo = 'cliente.cfg';
type

  { Tfrmmain }

  Tfrmmain = class(TForm)
    edCont2: TEdit;
    edCont3: TEdit;
    edEmpresa: TEdit;
    edTipo1: TEdit;
    edlocalizacao: TEdit;
    edTipo2: TEdit;
    edTipo3: TEdit;
    edCont1: TEdit;
    Empresa: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Versao: TLabel;
    lblocalizacao: TLabel;
    lbParams: TListBox;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    PopupMenu1: TPopupMenu;
    Timer1: TTimer;
    ToggleBox1: TToggleBox;
    TrayIcon1: TTrayIcon;
    procedure edCont2Change(Sender: TObject);
    procedure edCont3Change(Sender: TObject);
    procedure edTipo1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ToggleBox1Change(Sender: TObject);
    procedure SalvarContexto();
    procedure ToggleBox1Click(Sender: TObject);
  private

  public


  end;

var
  frmmain: Tfrmmain;

implementation

{$R *.lfm}

{ Tfrmmain }

procedure Tfrmmain.MenuItem1Click(Sender: TObject);
begin
  show;
end;

procedure Tfrmmain.Timer1Timer(Sender: TObject);
begin
 edCont1.Text:= inttostr(frmMenu.posFila1);
 edCont2.Text:= inttostr(frmMenu.posFila2);
 edCont3.Text:= inttostr(frmMenu.posFila3);
 SalvarContexto();
end;

procedure Tfrmmain.FormShow(Sender: TObject);
begin
  Timer1.Enabled:=false;
  if FileExists(arquivo) then
  begin
      lbParams.Items.LoadFromFile(arquivo);
      edEmpresa.text:= lbParams.Items[0];
      edlocalizacao.text:= lbParams.Items[1];
      edTipo1.text:= lbParams.Items[2];
      edTipo2.text:= lbParams.Items[3];
      edTipo3.text:= lbParams.Items[4];
      edCont1.text:= lbParams.Items[5];
      edCont2.text:= lbParams.Items[6];
      edCont3.text:= lbParams.Items[7];

  end;

end;

procedure Tfrmmain.edCont2Change(Sender: TObject);
begin

end;

procedure Tfrmmain.edCont3Change(Sender: TObject);
begin

end;

procedure Tfrmmain.edTipo1Change(Sender: TObject);
begin

end;

procedure Tfrmmain.SalvarContexto();
begin
      lbParams.Items.Clear;
      lbParams.Items.Add(edEmpresa.text);
      lbParams.Items.Add( edlocalizacao.text);
      lbParams.Items.Add(edTipo1.text);
      lbParams.Items.Add(edTipo2.text) ;
      lbParams.Items.Add(edTipo3.text);
      lbParams.Items.Add( edCont1.text);
      lbParams.Items.Add(edCont2.text);
      lbParams.Items.Add( edCont3.text);
      lbParams.Items.SaveToFile(arquivo);

end;

procedure Tfrmmain.ToggleBox1Click(Sender: TObject);
begin
  hide;
  Timer1.Enabled:=true;
  frmmenu.show;
  salvarContexto();
  frmMenu.posFila1:= strtoint(edCont1.Text);
  frmMenu.posFila2:= strtoint(edCont2.Text);
  frmMenu.posFila3:= strtoint(edCont3.Text);
  frmMenu.empresa := edEmpresa.Text;
  frmMenu.localizacao:= edlocalizacao.text;
  frmMenu.BtFila1.Caption:= edTipo1.text;
  frmMenu.BtFila2.Caption:= edTipo2.text;
  frmMenu.BtFila3.Caption:= edTipo3.text;
  frmMenu.lbFILA1 := edTipo1.text;
  frmMenu.lbFILA2 := edTipo2.text;
  frmMenu.lbFILA3 := edTipo3.text;
  TrayIcon1.BalloonTitle:='FILA';
  TrayIcon1.Animate:=false;
  TrayIcon1.BalloonHint:= 'Programa Fila';
  TrayIcon1.Visible:=true;

end;

procedure Tfrmmain.ToggleBox1Change(Sender: TObject);
begin


end;

end.

