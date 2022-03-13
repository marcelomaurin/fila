unit menu;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, RLReport, LazSerial, Impressao, imp_ELGINI9, cupom,funcoes, imp;



type
  { TfrmMenu }

  TfrmMenu = class(TForm)
    Image1: TImage;

    Label1: TLabel;
    BtFila1: TButton;
    btFila2: TButton;
    BtFila3: TButton;
    Label2: TLabel;
    LazSerial1: TLazSerial;
    Lista1 : TStringList;
    Lista2 : TStringList;
    Lista3 : TStringList;
    procedure BtFila1Click(Sender: TObject);
    procedure btFila2Click(Sender: TObject);
    procedure BtFila3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Label2Click(Sender: TObject);


  private

  public
    FIMP : TIMP;
    posFila1: integer;
    posFila2: integer;
    posFila3: integer;
    lbFILA1: string;
    lbFILA2: string;
    lbFILA3: string;
    empresa : string;
    localizacao : string;
    comport : string;

    procedure Imprime(Tipo : integer);
    function PegaNro(Tipo: integer): integer;
    function PegaNomeFila(Tipo : integer): string;
    function PegaLocalizacao(): string;
    function PegaEmpresa():string;
    procedure ImprimeDriver(tipo: integer; nro : integer; senha : string);
    procedure ImprimeSerial(Tipo: integer; nro : integer; senha : string);


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
  result := localizacao;
end;

function TfrmMenu.PegaEmpresa():string;
begin
  result := empresa;

end;

procedure TfrmMenu.ImprimeDriver(tipo: integer; nro : integer; senha : string);
begin
  frmImpressao.RLTipo.Caption:= PegaNomeFila(Tipo);
  Case Tipo of
      1: lista1.Append(senha);
      2: lista2.Append(senha);
      3: lista3.Append(senha);
  end;
  //frmImpressao.RLBNRO.Caption := senha;
  frmImpressao.RLEmpresa.caption := pegaEmpresa();
  frmImpressao.RLNRO.Caption := senha;
  frmImpressao.RLLocalizacao.Caption:= PegaLocalizacao();
  frmImpressao.RLDATETIME.Caption:= datetimetostr(now);
  frmImpressao.RLEmpresa.Caption:= empresa;
  frmImpressao.RLLocalizacao.Caption:= localizacao;
  frmImpressao.RLReport1.PrintDialog := false;
  frmImpressao.RLReport1.Print;
end;

procedure TfrmMenu.ImprimeSerial(Tipo: integer; nro : integer; senha : string);
begin
  try
    Case Tipo of
        1: lista1.Append(senha);
        2: lista2.Append(senha);
        3: lista3.Append(senha);
    end;
    fimp.close;
    //DefaultSerial();
    fimp.Device:= comport;
    fimp.Open;
    fimp.TextoSerial(pegaEmpresa(),FCENTER,TT_DOUBLE);
    //LineSerial();
    fimp.TextoSerial('TIPO:'+PegaNomeFila(Tipo),FLEFT,TT_NORMAL);
    fimp.TextoSerial('Data:'+DateTimeToStr(now),FLEFT,TT_NORMAL);
    //LineSerial();
    fimp.TextoSerial('Senha:'+ senha,FLeft, TT_DOUBLE);
    //LineSerial();
    fimp.TextoSerial(PegaLocalizacao(),Fcenter);
    fimp.EjetarCUPOM();
    fimp.Guilhotina();
    fimp.close;
  Except
     on e: EInOutError do
       ShowMessage(E.ClassName + '/'+ E.Message);
  end;
end;






procedure TfrmMenu.Imprime(Tipo : integer);
var
  nro : integer;
  Senha : String;
begin
  nro := PegaNro(TIPO);
  Senha := chr(ord('A')-1+Tipo)+inttostr(nro);

  if(Fimp.TIPOIMP = TI_DRIVER) then (*Tipo driver*)
  begin
    ImprimeDriver(Tipo, nro, senha);
  end;
  if(Fimp.TIPOIMP = TI_SERIAL) then  (*Tipo Serial*)
  begin
    ImprimeSerial(Tipo, nro , senha);
  end;

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
  frmImpressao := TfrmImpressao.create(self);
  frmcupom := tfrmcupom.create(self);
  Lista1 := TStringList.Create();
  Lista2 := TStringList.Create();
  Lista3 := TStringList.Create();
  FIMP := TImp.create(LazSerial1);


end;

procedure TfrmMenu.FormDestroy(Sender: TObject);
begin
  FIMP.destroy();
  frmImpressao.free;
  frmcupom.free;
  frmImpressao := nil;
  frmcupom := nil;
end;

procedure TfrmMenu.FormShow(Sender: TObject);
begin

end;

procedure TfrmMenu.Label2Click(Sender: TObject);
begin
  frmcupom.show;
end;

end.

