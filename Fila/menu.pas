unit menu;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, RLReport, LazSerial, Impressao, imp_ELGINI9, cupom,funcoes;

type CTipoIMP = (TI_DRIVER, TI_SERIAL,  TI_BLUETOOTH);
type CModeloIMP = (MI_ELGINI9);

type CFormat = (FLeft, FCenter, FRigth); (*Formatacao do Texto*)
type CTypeText = (TT_NORMAL, TT_DOUBLE ); (*Tipo do Texto*)

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

    posFila1: integer;
    posFila2: integer;
    posFila3: integer;
    lbFILA1: string;
    lbFILA2: string;
    lbFILA3: string;
    empresa : string;
    localizacao : string;
    comport : string;
    tipoimp : CTipoIMP;
    modeloimp: CModeloIMP;
    procedure Imprime(Tipo : integer);
    function PegaNro(Tipo: integer): integer;
    function PegaNomeFila(Tipo : integer): string;
    function PegaLocalizacao(): string;
    function PegaEmpresa():string;
    procedure ImprimeDriver(tipo: integer; nro : integer; senha : string);
    procedure ImprimeSerial(Tipo: integer; nro : integer; senha : string);
    procedure DefaultSerial();
    procedure TextoSerial(info : string);
    procedure TextoSerial(info : string; Formatacao : CFormat);
    procedure TextoSerial(info : string; Formatacao : CFormat; typetext : CTypeText);
    procedure LineSerial();
    function FormatacaoString(info: string;tam: integer; Formatacao:CFormat; margin: integer): TStringList;
    procedure EjetarCUPOM();
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
    LazSerial1.close;
    DefaultSerial();
    LazSerial1.Device:= comport;
    LazSerial1.Open;
    TextoSerial(pegaEmpresa(),FCENTER,TT_DOUBLE);
    //LineSerial();
    TextoSerial('TIPO:'+PegaNomeFila(Tipo),FLEFT,TT_NORMAL);
    TextoSerial('Data:'+DateTimeToStr(now),FLEFT,TT_NORMAL);
    //LineSerial();
    TextoSerial('Senha:'+ senha,FLeft, TT_DOUBLE);
    //LineSerial();
    TextoSerial(PegaLocalizacao(),Fcenter);
    EjetarCUPOM();
    LazSerial1.close;
  Except
     on e: EInOutError do
       ShowMessage(E.ClassName + '/'+ E.Message);
  end;
end;

procedure TfrmMenu.EjetarCUPOM();
begin
  TextoSerial(' -------- ',FCenter);
  //LineSerial();
  LineSerial();
  LineSerial();
  LineSerial();
  LineSerial();
  LineSerial();
  LineSerial();
  LineSerial();
end;

procedure TfrmMenu.DefaultSerial();
begin
  LazSerial1.BaudRate:= br__9600;
  LazSerial1.DataBits:=db8bits;
  LazSerial1.FlowControl := fcNone;
  LazSerial1.StopBits:= sbOne;

end;

procedure TfrmMenu.TextoSerial(info : string);
var
  impElginI9 : TIMP_ELGINI9;
  tmp : string;
begin
  if modeloimp = MI_ELGINI9 then
  begin
       impElginI9 := TIMP_ELGINI9.create();
       tmp := impElginI9.LineText(info);
       impElginI9.destroy();
  end;
  LazSerial1.WriteData(tmp);
end;

procedure TfrmMenu.TextoSerial(info: string; Formatacao: CFormat);
var
  info2 : Tstringlist;
  tam : integer;
  a : integer;
begin
  if modeloimp = MI_ELGINI9 then
  begin
       impElginI9 := TIMP_ELGINI9.create();
       tam := impElginI9.Coluna;
       impElginI9.destroy();
  end;

  info2 := FormatacaoString(info, tam, Formatacao,4);
  for a := 0 to info2.Count-1 do
    TextoSerial(info2.Strings[a]);
end;

procedure TfrmMenu.TextoSerial(info: string; Formatacao: CFormat;
  typetext: CTypeText);
var
  info2 : Tstringlist;
  tam : integer;
  a : integer;
  typetextantes : string;
  typetextdepois : string;
begin

  if modeloimp = MI_ELGINI9 then
  begin
       impElginI9 := TIMP_ELGINI9.create();
       tam := impElginI9.Coluna;
       typetextdepois:= IMPELGINI9.Normal();
       if (typetext = TT_NORMAL) then
       begin
            typetextantes:= IMPELGINI9.Normal();
       end;

       if (typetext = TT_DOUBLE) then
       begin
            typetextantes:= IMPELGINI9.DoubleTexto();
            tam := (tam div 2);
       end;
       impElginI9.destroy();
  end;

  info2 := FormatacaoString(info, tam, Formatacao,iif(typetext=TT_DOUBLE,2,4));
  TextoSerial(typetextantes);
  for a := 0 to info2.Count-1 do
    TextoSerial(info2.Strings[a]);
  TextoSerial(typetextdepois);
end;

procedure TfrmMenu.LineSerial();
var
  impElginI9 : TIMP_ELGINI9;
  tmp : string;

begin
  if modeloimp = MI_ELGINI9 then
  begin
       impElginI9 := TIMP_ELGINI9.create();
       tmp := impElginI9.NewLine();
       impElginI9.free();
  end;
  LazSerial1.WriteData(tmp);
  frmcupom.mecupom.Lines.Append('');
  sleep(200);
end;

function TfrmMenu.FormatacaoString(info: string; tam: integer;
  Formatacao: CFormat; margin: integer): TStringList;
var
  tam2 : integer;
  listagem : TStringList;
  margem : integer;
  aux : string;
  spaces : string;
  margemesquerda : integer;
begin
  listagem := TStringList.create();
  margem := margin;
  (*Quebrando em linhas*)
  repeat
           aux := copy(info,0,(tam-margem));
           if (Formatacao = FLeft) then
           begin
                spaces := space(margem div 2);
           end;
           if (Formatacao = FCENTER) then
           begin
                margemesquerda := margem div 2;
                spaces := space(margemesquerda)+space((Length(aux) div 2)-margemesquerda);
           end;

           aux :=spaces + aux;
           //showmessage(aux);
           listagem.Append(aux );
           frmcupom.mecupom.Lines.Append(aux);
           info := copy(info,(tam-margem)+1,Length(info));



  until (Length(info)<(tam-margem)) ;

  (*Formatando linhas*)
  result := listagem;
end;



procedure TfrmMenu.Imprime(Tipo : integer);
var
  nro : integer;
  Senha : String;
begin
  nro := PegaNro(TIPO);
  Senha := chr(ord('A')-1+Tipo)+inttostr(nro);

  if(TIPOIMP = TI_DRIVER) then (*Tipo driver*)
  begin
    ImprimeDriver(Tipo, nro, senha);
  end;
  if(TIPOIMP = TI_SERIAL) then  (*Tipo Serial*)
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
  DefaultSerial();

end;

procedure TfrmMenu.FormDestroy(Sender: TObject);
begin
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

