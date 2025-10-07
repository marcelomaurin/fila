unit menu;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, RLReport, LazSerial, Impressao, Impressao2, imp_ELGINI9,
  cupom,funcoes, imp, setmain, toolsfalar, hint;



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
  case Tipo of
    1: begin Inc(posFila1); Result := posFila1; end;
    2: begin Inc(posFila2); Result := posFila2; end;
    3: begin Inc(posFila3); Result := posFila3; end;
    4: begin Inc(posFila4); Result := posFila4; end;
    5: begin Inc(posFila5); Result := posFila5; end;
  else
    raise Exception.CreateFmt('Tipo de fila inválido: %d', [Tipo]);
  end;

  FSETMAIN.Contagem1 := posFila1;
  FSETMAIN.Contagem2 := posFila2;
  FSETMAIN.Contagem3 := posFila3;
  FSETMAIN.Contagem4 := posFila4;
  FSETMAIN.Contagem5 := posFila5;
  frmmain.SalvarContexto;
  Application.ProcessMessages;
end;

function TfrmMenu.PegaNomeFila(Tipo: integer): string;
begin
  case Tipo of
    1: Result := lbFILA1;
    2: Result := lbFILA2;
    3: Result := lbFILA3;
    4: Result := lbFILA4;
    5: Result := lbFILA5;
  else
    Result := 'Desconhecida';
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

procedure TfrmMenu.ImprimeDriver(tipo: integer; nro: integer; senha: string);
var
  LIs58: Boolean;
begin
  LIs58 := (fsetmain.TipoPapel = TP_58MM);

  // Adiciona senha nas listas antes de imprimir
  case Tipo of
    1: frmmain.lista1.Items.Append(senha);
    2: frmmain.lista2.Items.Append(senha);
    3: frmmain.lista3.Items.Append(senha);
    4: frmmain.lista4.Items.Append(senha);
    5: frmmain.lista5.Items.Append(senha);
  end;
  salvalistagem;

  if LIs58 then
  begin
    // NÃO reutilize instância global; crie local e libere no finally
    frmImpressao := TfrmImpressao.Create(Self);
    try
      frmImpressao.RLTipo.Caption := PegaNomeFila(Tipo);
      frmImpressao.RLEmpresa.Caption := PegaEmpresa();
      frmImpressao.RLNRO.Caption := senha;
      frmImpressao.RLLocalizacao.Caption := PegaLocalizacao();
      frmImpressao.RLDATETIME.Caption := DateTimeToStr(Now);

      frmImpressao.RLReport1.PrintDialog := False;
      frmImpressao.RLReport1.Print;

      // Ajustes de papel (se necessário, faça ANTES do Print)
      if (FSETMAIN.ModeloImp <> TI_ELGINI9) then
        frmImpressao.RLReport1.PageSetup.PaperHeight := 260
      else
        frmImpressao.RLReport1.PageSetup.PaperHeight := 260;
    finally
      FreeAndNil(frmImpressao);
    end;
  end
  else
  begin
    frmImpressao2 := TfrmImpressao2.Create(Self);
    try
      // Ajuste de papel ANTES do Print
      if (FSETMAIN.ModeloImp <> TI_ELGINI9) then
      begin
        frmImpressao2.RLReport1.PageSetup.PaperHeight := 100;
        frmImpressao2.RLReport1.Height := 100;
        frmImpressao2.RLPicote.Top := 350;
      end
      else
      begin
        frmImpressao2.RLReport1.PageSetup.PaperHeight := 100;
        frmImpressao2.RLReport1.Height := 90;
        frmImpressao2.RLPicote.Top := 160;
      end;

      frmImpressao2.RLTipo.Caption := PegaNomeFila(Tipo);
      frmImpressao2.RLEmpresa.Caption := PegaEmpresa();
      frmImpressao2.RLNRO.Caption := senha;
      frmImpressao2.RLLocalizacao.Caption := PegaLocalizacao();
      frmImpressao2.RLDATETIME.Caption := DateTimeToStr(Now);

      frmImpressao2.RLReport1.PrintDialog := False;
      frmImpressao2.RLReport1.Print;
    finally
      FreeAndNil(frmImpressao2);
    end;
  end;

  // Fala (garanta que o form existe)
  if FSETMAIN.Falar and Assigned(frmToolsfalar) then
  begin
    frmToolsfalar.Falar('Sua senha é ' + senha + ' do tipo ' + PegaNomeFila(Tipo));
    Sleep(2000);
    frmToolsfalar.Conectar;
  end;
end;


procedure TfrmMenu.ImprimeSerial(Tipo: integer; nro: integer; senha: string);
begin
  try
    case Tipo of
      1: frmmain.lista1.Items.Append(senha);
      2: frmmain.lista2.Items.Append(senha);
      3: frmmain.lista3.Items.Append(senha);
      4: frmmain.lista4.Items.Append(senha);
      5: frmmain.lista5.Items.Append(senha);
    end;

    if Trim(comport) = '' then
      raise Exception.Create('Porta serial não definida.');

    fimp.Close;
    fimp.Device := comport;
    fimp.Open;

    fimp.TextoSerial(PegaEmpresa(), FCENTER, TT_DOUBLE);
    fimp.TextoSerial('TIPO:' + PegaNomeFila(Tipo), FLEFT, TT_NORMAL);
    fimp.TextoSerial('Data:' + DateTimeToStr(Now), FLEFT, TT_NORMAL);
    fimp.TextoSerial('Senha:' + senha, FLeft, TT_DOUBLE);
    fimp.TextoSerial(PegaLocalizacao(), Fcenter);
    fimp.EjetarCUPOM;
    fimp.Guilhotina;
    fimp.Close;
  except
    on E: EInOutError do
      ShowMessage(E.ClassName + ' / ' + E.Message);
    on E: Exception do
      ShowMessage('Erro na impressão serial: ' + E.Message);
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
  frmmain.RegistraEvento('',nro , 1);  //Registra inicio de atendimento
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



procedure TfrmMenu.salvalistagem;
var
  diretorio, arq: string;
begin
  try
    diretorio := GetAppConfigDir(False);

    // Remove separador final
    if (diretorio <> '') and (diretorio[Length(diretorio)] in ['\', '/']) then
      Delete(diretorio, Length(diretorio), 1);

    // Garante toda a árvore
    if not ForceDirectories(diretorio) then
      raise Exception.Create('Não foi possível criar o diretório: ' + diretorio);

    // Valida listas
    if not Assigned(frmmain) then
      raise Exception.Create('Form principal (frmmain) não está disponível.');

    if Assigned(frmmain.lista1) then
    begin
      arq := diretorio + PathDelim + 'list01.txt';
      frmmain.lista1.Items.SaveToFile(arq);
    end;

    if Assigned(frmmain.lista2) then
    begin
      arq := diretorio + PathDelim + 'list02.txt';
      frmmain.lista2.Items.SaveToFile(arq);
    end;

    if Assigned(frmmain.lista3) then
    begin
      arq := diretorio + PathDelim + 'list03.txt';
      frmmain.lista3.Items.SaveToFile(arq);
    end;

    if Assigned(frmmain.lista4) then
    begin
      arq := diretorio + PathDelim + 'list04.txt';
      frmmain.lista4.Items.SaveToFile(arq);
    end;

    if Assigned(frmmain.lista5) then
    begin
      arq := diretorio + PathDelim + 'list05.txt';
      frmmain.lista5.Items.SaveToFile(arq);
    end;

  except
    on E: Exception do
      frmHint.MessageHint('Erro ao salvar listagens: ' + E.Message);
  end;
end;



end.

