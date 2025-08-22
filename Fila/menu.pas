unit menu;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, RLReport, LazSerial, Impressao, Impressao2, imp_ELGINI9,
  cupom,funcoes, imp, setmain, toolsfalar;



type
  { TfrmMenu }

  TfrmMenu = class(TForm)
    BtFila1: TButton;
    btFila2: TButton;
    BtFila3: TButton;
    BtFila4: TButton;
    BtFila5: TButton;
    Image1: TImage;

    lbRotulo: TLabel;
    Label2: TLabel;
    LazSerial1: TLazSerial;
    pnLeft: TPanel;
    Panel2: TPanel;
    pntop: TPanel;
    //Lista1 : TStringList;
    //Lista2 : TStringList;
    //Lista3 : TStringList;
    procedure BtFila1Click(Sender: TObject);
    procedure btFila2Click(Sender: TObject);
    procedure BtFila3Click(Sender: TObject);
    procedure BtFila4Click(Sender: TObject);
    procedure BtFila5Click(Sender: TObject);
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
    posFila4: integer;
    posFila5: integer;
    lbFILA1: string;
    lbFILA2: string;
    lbFILA3: string;
    lbFILA4: string;
    lbFILA5: string;
    empresa : string;
    localizacao : string;
    comport : string;


    procedure salvalistagem();

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

uses main;

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
  if tipo = 4 then
  begin
    inc(posFila4);
    result := posFila4;
  end;
  if tipo = 5 then
  begin
    inc(posFila5);
    result := posFila5;
  end;

  FSETMAIN.Contagem1:=posFila1;
  FSETMAIN.Contagem2:=posFila2;
  FSETMAIN.Contagem3:=posFila3;
  FSETMAIN.Contagem4:=posFila4;
  FSETMAIN.Contagem5:=posFila5;
  frmmain.SalvarContexto();
  application.ProcessMessages;


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
  if (TIPO = 4) then
  begin
     result := lbFILA4;
  end;
  if (TIPO = 5) then
  begin
     result := lbFILA5;
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

  if(fsetmain.TipoPapel = TP_58MM) then
  begin
    frmImpressao := Tfrmimpressao.create(self);
    frmImpressao.RLTipo.Caption:= PegaNomeFila(Tipo);

  end
  else
  begin
    frmImpressao2 := Tfrmimpressao2.create(self);
    frmImpressao2.RLTipo.Caption:= PegaNomeFila(Tipo);
  end;
  Case Tipo of
      1: frmmain.lista1.items.Append(senha);
      2: frmmain.lista2.items.Append(senha);
      3: frmmain.lista3.items.Append(senha);
      4: frmmain.lista4.items.Append(senha);
      5: frmmain.lista5.items.Append(senha);
  end;
  salvalistagem();
  if(fsetmain.TipoPapel = TP_58MM) then
  begin
    //frmImpressao.RLBNRO.Caption := senha;
    frmImpressao.RLEmpresa.caption := pegaEmpresa();
    frmImpressao.RLNRO.Caption := senha;
    frmImpressao.RLLocalizacao.Caption:= PegaLocalizacao();
    frmImpressao.RLDATETIME.Caption:= datetimetostr(now);
    frmImpressao.RLEmpresa.Caption:= empresa;
    frmImpressao.RLLocalizacao.Caption:= localizacao;
    frmImpressao.RLReport1.PrintDialog := false;
    frmImpressao.RLReport1.Print;
    frmimpressao.free;
    //frmImpressao.RLBNRO.Caption := senha;
    if(FSETMAIN.ModeloImp <> TI_ELGINI9) then
    begin
         frmimpressao.RLReport1.PageSetup.PaperHeight:= 260;
    end
    else
    begin
         frmimpressao.RLReport1.PageSetup.PaperHeight:= 260;
    end;
  end
  else
  begin
    //frmImpressao.RLBNRO.Caption := senha;
    if(FSETMAIN.ModeloImp <> TI_ELGINI9) then
    begin
         frmimpressao2.RLReport1.PageSetup.PaperHeight:= 100;
         frmimpressao2.RLReport1.Height:= 100;
         frmimpressao2.RLPicote.top := 350;
    end
    else
    begin
         frmimpressao2.RLReport1.PageSetup.PaperHeight:= 100;
         frmimpressao2.RLReport1.Height:= 90;
         frmimpressao2.RLPicote.top := 160;
    end;
    frmImpressao2.RLEmpresa.caption := pegaEmpresa();
    frmImpressao2.RLNRO.Caption := senha;
    frmImpressao2.RLLocalizacao.Caption:= PegaLocalizacao();
    frmImpressao2.RLDATETIME.Caption:= datetimetostr(now);
    frmImpressao2.RLEmpresa.Caption:= empresa;
    frmImpressao2.RLLocalizacao.Caption:= localizacao;
    //frmimpressao2.RLImage1.Picture.LoadFromFile(FSETMAIN.Imagem);
    frmImpressao2.RLReport1.PrintDialog := false;
    frmImpressao2.RLReport1.Print;
    frmimpressao2.free;
  end;
  if ( FSETMAIN.Falar) then
  begin
    frmToolsfalar.Falar('Sua senha é '+senha+ ' do tipo '+ PegaNomeFila(Tipo));
    Sleep(2000);
    frmToolsfalar.Conectar();
  end;
end;

procedure TfrmMenu.ImprimeSerial(Tipo: integer; nro : integer; senha : string);
begin
  try
    Case Tipo of
        1: frmmain.lista1.items.Append(senha);
        2: frmmain.lista2.items.Append(senha);
        3: frmmain.lista3.items.Append(senha);
        4: frmmain.lista4.items.Append(senha);
        5: frmmain.lista5.items.Append(senha);
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
  //Senha := chr(ord('A')-1+Tipo)+inttostr(nro);
  case Tipo of
  1 :  Senha := FSETMAIN.Abrev01+inttostr(nro);
  2 :  Senha := FSETMAIN.Abrev02+inttostr(nro);
  3 :  Senha := FSETMAIN.Abrev03+inttostr(nro);
  4 :  Senha := FSETMAIN.Abrev04+inttostr(nro);
  5 :  Senha := FSETMAIN.Abrev05+inttostr(nro);
  end;

  if(Fimp.TIPOIMP = TI_DRIVER) then (*Tipo driver*)
  begin
    ImprimeDriver(Tipo, nro, senha);
  end;
  if(Fimp.TIPOIMP = TI_SERIAL) then  (*Tipo Serial*)
  begin
    ImprimeSerial(Tipo, nro , senha);
  end;
  frmmain.salvarContexto();

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

procedure TfrmMenu.BtFila4Click(Sender: TObject);
begin
  Imprime(4);
end;

procedure TfrmMenu.BtFila5Click(Sender: TObject);
begin
  Imprime(5);
end;

procedure TfrmMenu.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin

end;

procedure TfrmMenu.FormCreate(Sender: TObject);
begin
  frmImpressao := TfrmImpressao.create(self);
  frmcupom := tfrmcupom.create(self);

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



procedure TfrmMenu.salvalistagem();
var
  diretorio: string;
  arq: string;
begin
  // Obtém o diretório temporário de forma automática
  diretorio := GetTempDir;

  // Remove a barra ou contrabarra no final, se houver
  if (diretorio <> '') and (diretorio[Length(diretorio)] in ['\', '/']) then
    Delete(diretorio, Length(diretorio), 1);

  // Salva os arquivos
  arq := diretorio + PathDelim + 'list01.txt';
  frmmain.lista1.Items.SaveToFile(arq);

  arq := diretorio + PathDelim + 'list02.txt';
  frmmain.lista2.Items.SaveToFile(arq);

  arq := diretorio + PathDelim + 'list03.txt';
  frmmain.lista3.Items.SaveToFile(arq);

  arq := diretorio + PathDelim + 'list04.txt';
  frmmain.lista4.Items.SaveToFile(arq);

  arq := diretorio + PathDelim + 'list05.txt';
  frmmain.lista5.Items.SaveToFile(arq);
end;

end.

