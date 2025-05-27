unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  MMSystem, ComCtrls, LedNumber, uplaysound, AnalogWatch, IPEdit, FileUtil,
  lNetComponents, IdSocksServer, IdCompressionIntercept, IdBlockCipherIntercept,
  IdServerInterceptLogEvent, IdSSLOpenSSL, setmain, IdThread, IdCustomTCPServer,
  IdContext, IdTCPServer, IdCmdTCPServer, IdSimpleServer, IdIOHandlerStack,
  IdIOHandlerStream, IdServerIOHandlerStack, IdIntercept, IdComponent, lNet,
  toolsfalar, fphttpclient, RegExpr;

Const
  PortPainel = '8196';

type

  { Tfrmmain }

  Tfrmmain = class(TForm)
    AnalogWatch1: TAnalogWatch;
    btSalvar: TButton;
    edIPFalarServidor: TIPEdit;
    edURL: TEdit;
    edPorta: TEdit;
    edFalarPorta: TEdit;
    Image1: TImage;
    edIPServidor: TIPEdit;
    Label1: TLabel;
    Label18: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lbGrupo2: TLabel;
    lbGrupo3: TLabel;
    lbGrupo4: TLabel;
    lbguicheatual: TLabel;
    lbIGrupo2: TLabel;
    lbIGrupo3: TLabel;
    lbIGrupo4: TLabel;
    Label17: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lbGrupo1: TLabel;
    lbSenhaAtual: TLabel;
    LTCPComponent1: TLTCPComponent;
    Memo1: TMemo;
    tmImagens: TTimer;
    tmEspera: TTimer;
    tsSenha: TTabSheet;
    tbLog: TTabSheet;
    lbmsg: TLabel;
    lbIGrupo1: TLabel;
    ledData: TLEDNumber;
    ledhora: TLEDNumber;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    tsAnuncios: TTabSheet;
    TabSheet2: TTabSheet;
    tbConfig: TTabSheet;
    Timer1: TTimer;
    procedure btSalvarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LTCPComponent1Accept(aSocket: TLSocket);
    procedure LTCPComponent1Connect(aSocket: TLSocket);
    procedure LTCPComponent1Disconnect(aSocket: TLSocket);
    procedure LTCPComponent1Error(const msg: string; aSocket: TLSocket);
    procedure LTCPComponent1Receive(aSocket: TLSocket);

    procedure Timer1Timer(Sender: TObject);
    procedure tmEsperaTimer(Sender: TObject);
    procedure tmImagensTimer(Sender: TObject);
  private

    procedure SalvarContexto();
  public
    CurrentImageIndex: Integer;
    ImageList: TStringList;
    procedure Start_srv;
    procedure ProcessaMSG(MSG: string);
    procedure TrataMSG(comando: string; info: string);
    procedure arquivoSenhaAtual(info : string);
    procedure Beepando();
    procedure ChamaPainel(guiche : string; codigo : string);
    procedure PularSenhas();
    procedure Pisca();
    procedure BaixarImagens(URL, PastaDestino: string);
    procedure LimparPasta(PastaDestino: string);
    procedure ContaTelas;
    procedure LoadImagesFromAppData;
    procedure ShowNextImage;

  end;

var
  frmmain: Tfrmmain;

implementation

{$R *.lfm}

{ Tfrmmain }

procedure Tfrmmain.Timer1Timer(Sender: TObject);
begin
   ledData.Caption:= datetostr(now);
   ledhora.Caption:= timetostr(now);
end;

procedure Tfrmmain.tmEsperaTimer(Sender: TObject);
begin
   PageControl1.ActivePage := tsAnuncios;
   PageControl1.Refresh;
   tmEspera.Enabled:= false;
end;

procedure Tfrmmain.tmImagensTimer(Sender: TObject);
begin
  ShowNextImage();
end;

procedure Tfrmmain.SalvarContexto();
begin
  FSetMain.IPPAINEL := edIPServidor.Text;
  FSetMain.PORTPAINEL:= edPorta.text;
  FSetMain.IPFALAR:= edIPFalarServidor.text;
  FSetMain.PORTFALAR:= edFalarPorta.text;
  FSetMain.URL:= edURL.text;
  FSetMain.SalvaContexto(true);
end;

procedure Tfrmmain.Start_srv;
begin
  LTCPComponent1.Port := strtoint(PortPainel);
  LTCPComponent1.Listen(strtoint(PortPainel));
  Memo1.Lines.Add('Servidor TCP iniciado na porta '+PortPainel);
end;

procedure Tfrmmain.ProcessaMSG(MSG: string);
var
  posicao : integer;
  comando: string;
  info : string;
begin
     posicao := msg.IndexOf(':');
     if (posicao > 0) then
     begin
          comando := Copy(msg,0,posicao);
          info := copy(msg,posicao+1,Length(msg));
          TrataMSG(comando,info);
     end
     else
     begin
       lbMSG.caption:='Mensagem inválida';
     end;

end;

procedure Tfrmmain.TrataMSG(comando: string; info: string);
var
  guiche: string;
  Codigo : string;
  posicaomaior : integer;
  posicaodoispontos: integer;
  posicaopontovirgula: integer;
begin
 if ('GUICHE' = comando) then
 begin
      posicaomaior := info.IndexOf('>');
      posicaodoispontos:= info.IndexOf(':');
      posicaopontovirgula:=info.IndexOf(';');
      if (posicaodoispontos  <> 0) and (posicaopontovirgula <> 0) then
      begin
           guiche := copy(info,posicaomaior+2,posicaodoispontos-(posicaomaior+1));
           codigo := copy(info,posicaodoispontos+2,posicaopontovirgula-(posicaodoispontos+1));
           //lbMSG.Text:= 'codigo:'+codigo;
           //if (codigo <> lbSenhaAtual.caption) then
           begin
                arquivoSenhaAtual(lbSenhaAtual.caption);
                lbSenhaAtual.caption := guiche;
                lbSenhaAtual.caption := codigo;
                PageControl1.ActivePage := tsSenha;

           end;
      end
      else
      begin
        lbMSG.caption:= 'Erro';
      end;


 end;
 if ('FILA' = comando) then
 begin
      info := StringReplace(info, #$0D, '', [rfReplaceAll]);
      posicaomaior := info.IndexOf('>');
      posicaodoispontos:= info.IndexOf(':');
      posicaopontovirgula:=info.IndexOf(';');
      if ((posicaodoispontos  <> -1) and (posicaopontovirgula <> -1)) then
      begin

           guiche := copy(info,posicaomaior+2,posicaopontovirgula-(posicaomaior+1));
           codigo := copy(info,posicaodoispontos+2,posicaomaior-(posicaodoispontos+1));
           //lbMSG.Text:= 'codigo:'+codigo;
           //if (codigo <> lbSenhaAtual.caption) then
           begin
                //frmToolsfalar.Conectar();
                ChamaPainel(guiche, codigo);

                Pisca();


                frmToolsfalar.Falar('Senha. '+codigo+ ', dirija-se ao guichê '+guiche);
                Application.ProcessMessages;
                sleep(4000);
                frmToolsfalar.Conectar();
           end;
      end
      else
      begin
        lbMSG.caption:= 'Erro';
      end;


 end;
 if ('GRUPO' = comando) then
 begin
      posicaomaior := info.IndexOf('>');
      posicaodoispontos:= info.IndexOf(':');
      posicaopontovirgula:=info.IndexOf(';');
      if (posicaodoispontos  <> 0) and (posicaopontovirgula <> 0) then
      begin
           guiche := copy(info,posicaomaior+2,posicaodoispontos-(posicaomaior+1));
           codigo := copy(info,posicaodoispontos+2,posicaopontovirgula-(posicaodoispontos+1));
           if guiche = '1' then
           begin
                lbGrupo1.caption:= codigo;
           end;
           if guiche = '2' then
           begin
                lbGrupo2.caption:= codigo;
           end;
           if guiche = '3' then
           begin
                lbGrupo3.caption:= codigo;
           end;
      end;
 end;
 //Ativa espera
 tmEspera.Enabled:= true;
end;

procedure Tfrmmain.arquivoSenhaAtual(info: string);
begin
  if info.Chars[0] = 'A' then
  begin
    lbIGrupo1.caption := info;
  end;
  if info.Chars[0] = 'B' then
  begin
    lbIGrupo2.caption := info;
  end;
  if info.Chars[0] = 'C' then
  begin
    lbIGrupo3.caption := info;
  end;


end;

procedure Tfrmmain.Beepando();
begin
   //sndPlaySound('C:\Windows\Media\Windows Ding.wav', SND_FILENAME or SND_ASYNC);
  Beep;
end;

procedure Tfrmmain.ChamaPainel(guiche: string; codigo: string);
begin
  lbSenhaAtual.Caption:= codigo;
  lbguicheatual.Caption:= guiche;
  PularSenhas();
end;

procedure Tfrmmain.PularSenhas();
begin
    lbIGrupo4.Caption:= lbIGrupo3.Caption;
    lbGrupo4.Caption := lbGrupo3.Caption;
    lbIGrupo3.Caption:= lbIGrupo2.Caption;
    lbGrupo3.Caption := lbGrupo2.Caption;
    lbIGrupo2.Caption:= lbIGrupo1.Caption;
    lbGrupo2.Caption := lbGrupo1.Caption;
    lbIGrupo1.Caption:= lbguicheatual.Caption;
    lbGrupo1.Caption := lbSenhaAtual.Caption;


end;

procedure Tfrmmain.Pisca();
var
      i: Integer;
 begin
      for i := 1 to 4 do
      begin
        lbSenhaAtual.Font.Color := clRed;
        lbSenhaAtual.Refresh;
        Beepando;
        Application.ProcessMessages;
        Sleep(1000);

        lbSenhaAtual.Font.Color := clBlack;
        lbSenhaAtual.Refresh;
        Application.ProcessMessages;
        Sleep(1000);
      end;

      // Deixa no estado final desejado
      lbSenhaAtual.Font.Color := clBlack;
      lbSenhaAtual.Refresh;
      Application.ProcessMessages;


end;

procedure Tfrmmain.BaixarImagens(URL, PastaDestino: string);
var
  HTTP: TFPHTTPClient;
  HTMLContent: TStringList;
  Regex: TRegExpr;
  FileName, FullURL, NomeArquivo: string;
  i: Integer;
begin
  HTTP := TFPHTTPClient.Create(nil);
  HTMLContent := TStringList.Create;
  Regex := TRegExpr.Create;

  try
    // Limpa a pasta destino antes de baixar as imagens
    LimparPasta(PastaDestino);

    // Baixa o HTML da URL fornecida
    HTMLContent.Text := HTTP.Get(URL);

    // Configura a expressão regular para encontrar arquivos de imagem
    Regex.Expression := '<a href=[\"\'']([^\"\'']+\.(?:jpg|jpeg|png|gif|bmp|webp|svg|mp4))';

    // Procura arquivos no HTML
    i := 0;
    if Regex.Exec(HTMLContent.Text) then
    begin
      //WriteLn('Iniciando download das imagens:');
      repeat
        FileName := Regex.Match[1];

        // Cria a URL completa do arquivo
        if Pos('http', FileName) = 1 then
          FullURL := FileName
        else
          FullURL := URL + '/' + FileName;

        // Define o nome do arquivo local
        NomeArquivo := Format('%s/image_%d%s', [PastaDestino, i, ExtractFileExt(FileName)]);

        // Baixa o arquivo
        HTTP.Get(FullURL, NomeArquivo);
        //WriteLn('Imagem baixada: ', NomeArquivo);
        Inc(i);

      until not Regex.ExecNext;
    end;
    //else
      //WriteLn('Nenhum arquivo de imagem encontrado na URL fornecida.');

  finally
    HTTP.Free;
    HTMLContent.Free;
    Regex.Free;
  end;
end;

procedure Tfrmmain.LimparPasta(PastaDestino: string);
var
  SR: TSearchRec;
begin
  if FindFirst(PastaDestino + '\*.*', faAnyFile, SR) = 0 then
  begin
    repeat
      if (SR.Name <> '.') and (SR.Name <> '..') then
        DeleteFile(PastaDestino + '\' + SR.Name);
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
end;

procedure Tfrmmain.ContaTelas;
var
  i: Integer;
begin
  // Total de telas conectadas
  //ShowMessage('Total de telas conectadas: ' + IntToStr(Screen.MonitorCount));

  // Listar os detalhes de cada tela
  for i := 0 to Screen.MonitorCount - 1 do
  begin
    (*
    frmscreen01 := Tfrmscreen01.create(self);
    frmscreen01.Left:= Screen.Monitors[i].Left;
    frmscreen01.top:= Screen.Monitors[i].top;
    frmscreen01.Width:= Screen.Monitors[i].Width;
    frmscreen01.Height:= Screen.Monitors[i].Height;
    frmscreen01.show;
    if Assigned(ImageList) and (ImageList.Count > 0) then
       frmscreen01.ShowNextImage; // Mostra a primeira imagem encontrada
    *)
    if Assigned(ImageList) and (ImageList.Count > 0) then
       ShowNextImage; // Mostra a primeira imagem encontrada

  end;
end;

procedure Tfrmmain.LoadImagesFromAppData;
var
  AppDataPath: String;
begin
  // Obtém o caminho da pasta AppData do usuário
  AppDataPath := IncludeTrailingPathDelimiter(GetEnvironmentVariable('APPDATA')) + 'protetor\';

  // Verifica se a pasta existe
  if DirectoryExists(AppDataPath) then
  begin
    ImageList := TStringList.Create;

    // Procura por arquivos JPG na pasta e subpastas
    FindAllFiles(ImageList, AppDataPath, '*.jpg', True);

    // Certifique-se de que há imagens encontradas
    if ImageList.Count > 0 then
    begin
      CurrentImageIndex := 0;
    end
    else
    begin
      ShowMessage('Nenhuma imagem JPG encontrada na pasta: ' + AppDataPath);
      FreeAndNil(ImageList); // Libera a memória se nenhuma imagem for encontrada
    end;
  end
  else
    ShowMessage('Pasta de dados do Windows não encontrada: ' + AppDataPath);
end;

procedure Tfrmmain.ShowNextImage;
begin
  if Assigned(frmmain.ImageList) and (frmmain.ImageList.Count > 0) then
  begin
    try
      // Carrega a imagem atual
      Image1.Picture.LoadFromFile(frmmain.ImageList[frmmain.CurrentImageIndex]);

      // Atualiza o índice para a próxima imagem
      Inc(CurrentImageIndex);
      if CurrentImageIndex >= ImageList.Count then
        CurrentImageIndex := 0; // Reinicia o índice quando chegar ao final da lista
    except
      on E: Exception do
        ShowMessage('Erro ao carregar imagem: ' + E.Message);
    end;
  end;
end;


procedure Tfrmmain.FormCreate(Sender: TObject);
begin
  FSetMain := TSetMain.create();
  FSetMain.CarregaContexto();
  //Carrega parametros
  edIPServidor.Text := FSetMain.IPPAINEL;
  edPorta.text := FSetMain.PORTPAINEL;
  edIPFalarServidor.text := FSetMain.IPFALAR;
  edFalarPorta.text := FSetMain.PORTFALAR;
  edURL.text := FSetMain.url;

  //Carrega o srv Falar
  frmToolsfalar := TfrmToolsfalar.create(self);
  frmToolsfalar.edIP.text :=  FSetMain.IPFALAR;
  frmToolsfalar.edPort.text := FSetMain.PORTFALAR;
  frmToolsfalar.Show;
  Application.ProcessMessages;
  Sleep(2000);
  Application.ProcessMessages;
  frmToolsfalar.Conectar();
  Application.ProcessMessages;
  Sleep(2000);
  Application.ProcessMessages;
  //frmToolsfalar.Hide;

  BaixarImagens(fsetmain.URL,IncludeTrailingPathDelimiter(GetEnvironmentVariable('APPDATA')) + 'protetor');
  // Carrega imagens da pasta AppData
  LoadImagesFromAppData;
  ContaTelas();
  tmImagens.Enabled:= true;
  PageControl1.ActivePage := tsAnuncios;

  //Start_srv;
end;

procedure Tfrmmain.btSalvarClick(Sender: TObject);
begin
  SalvarContexto();

end;

procedure Tfrmmain.FormDestroy(Sender: TObject);
begin
   //IdTCPServer1.Active := False;
end;

procedure Tfrmmain.FormShow(Sender: TObject);
begin
  Start_srv;
end;








procedure Tfrmmain.LTCPComponent1Accept(aSocket: TLSocket);
begin
   Memo1.Lines.Add('Aceitou a conexao do servidor ');

end;

procedure Tfrmmain.LTCPComponent1Connect(aSocket: TLSocket);
begin
  Memo1.Lines.Add('Conectou no servidor ');
end;

procedure Tfrmmain.LTCPComponent1Disconnect(aSocket: TLSocket);
begin
  Memo1.Lines.Add('Disconectou do servidor ');
end;

procedure Tfrmmain.LTCPComponent1Error(const msg: string; aSocket: TLSocket);
begin
    Memo1.Lines.Add('Erro  '+ msg);
end;

procedure Tfrmmain.LTCPComponent1Receive(aSocket: TLSocket);
var
  DadosRecebidos: string;
begin
    PageControl1.ActivePage := tsSenha;
    PageControl1.Refresh;
    tmEspera.Enabled:= false;   //Desativa timer


    //DadosRecebidos := AContext.Connection.IOHandler.ReadLn;
    aSocket.GetMessage(DadosRecebidos);
    if(DadosRecebidos<>'') then
    begin

    Memo1.Lines.Add('Recebido de ' + ': ' + DadosRecebidos);


    // resposta ao cliente
    //AContext.Connection.IOHandler.WriteLn('Servidor recebeu: ' + DadosRecebidos);
    if DadosRecebidos <> '' then
        ProcessaMSG(DadosRecebidos);

    end
    else
    begin
      Memo1.Lines.Add('Recebido em branco '  );
    end;
    aSocket.Disconnect(true);


end;




end.

