unit menu;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  RLReport, Impressao;

type

  { TfrmMenu }

  TfrmMenu = class(TForm)

    Label1: TLabel;
    BtFila1: TButton;
    btFila2: TButton;
    BtFila3: TButton;
    Lista1 : TStringList;
    Lista2 : TStringList;
    Lista3 : TStringList;
    procedure BtFila1Click(Sender: TObject);
    procedure btFila2Click(Sender: TObject);
    procedure BtFila3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);

  private

  public

    posFila1: integer;
    posFila2: integer;
    posFila3: integer;
    lbFILA1: string;
    lbFILA2: string;
    lbFILA3: string;
    empresa : string;
    localizacao : string;
    procedure Imprime(Tipo : integer);
    function PegaNro(Tipo: integer): integer;
    function PegaNomeFila(Tipo : integer): string;
    function PegaLocalizacao(): string;
    function PegaEmpresa():string;

  end;

var
  frmMenu: TfrmMenu;

implementation

{$R *.lfm}

{ TfrmMenu }

function TfrmMenu.PegaNro(Tipo: integer): integer;
begin
  if tipo = 1 then
  begin
    inc(posFila1);
    result := posFila1;
  end;
  if tipo = 2 then
  begin
    inc(posFila2);
    result := posFila2;
  end;
  if tipo = 3 then
  begin
    inc(posFila3);
    result := posFila3;
  end;

end;

function TfrmMenu.PegaNomeFila(Tipo : integer): string;
begin
  if (TIPO = 1) then
  begin
     result := lbFILA1;
  end;
  if (TIPO = 2) then
  begin
     result := lbFILA2;
  end;
  if (TIPO = 3) then
  begin
     result := lbFILA3;
  end;
end;

function TfrmMenu.PegaLocalizacao(): string;
begin
  result := 'sem localizacao ';
end;

function TfrmMenu.PegaEmpresa():string;
begin
  result := 'Nao implementado';

end;

procedure TfrmMenu.Imprime(Tipo : integer);
var
  nro : integer;
  Senha : String;
begin
  frmImpressao.RLTipo.Caption:= PegaNomeFila(Tipo);
  nro := PegaNro(TIPO);
  Senha := chr(ord('A')-1+Tipo)+inttostr(nro);
  Case Tipo of
  1: lista1.Append(senha);
  2: lista2.Append(senha);
  3: lista3.Append(senha);
  end;
  frmImpressao.RLBNRO.Caption := senha;
  frmImpressao.RLEmpresa.caption := pegaEmpresa();
  frmImpressao.RLNRO.Caption := senha;
  frmImpressao.RLLocalizacao.Caption:= PegaLocalizacao();
  frmImpressao.RLDATETIME.Caption:= datetimetostr(now);
  frmImpressao.RLEmpresa.Caption:= empresa;
  frmImpressao.RLLocalizacao.Caption:= localizacao;
  frmImpressao.RLReport1.PrintDialog := false;
  frmImpressao.RLReport1.Print;
end;

procedure TfrmMenu.BtFila1Click(Sender: TObject);
begin
  Imprime(1);

end;

procedure TfrmMenu.btFila2Click(Sender: TObject);
begin
   Imprime(2);
end;

procedure TfrmMenu.BtFila3Click(Sender: TObject);
begin
    Imprime(3);
end;

procedure TfrmMenu.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin

end;

procedure TfrmMenu.FormCreate(Sender: TObject);
begin
  Lista1 := TStringList.Create();
  Lista2 := TStringList.Create();
  Lista3 := TStringList.Create();

end;

procedure TfrmMenu.FormShow(Sender: TObject);
begin

end;

end.

