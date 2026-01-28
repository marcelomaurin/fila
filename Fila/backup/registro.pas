unit registro;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  lNetComponents, lNet, log, IdHTTP, IdSSLOpenSSL, IdSSLOpenSSLHeaders,
  IdURI;

type

  { TfrmRegistrar }

  TfrmRegistrar = class(TForm)
    Button1: TButton;
    edNome: TEdit;
    edEmail: TEdit;
    IdHTTP1: TIdHTTP;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LTCPComponent1: TLTCPComponent;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LTCPComponent1Accept(aSocket: TLSocket);
    procedure LTCPComponent1Connect(aSocket: TLSocket);
    procedure LTCPComponent1Receive(aSocket: TLSocket);
    procedure Memo1Change(Sender: TObject);
  private
    procedure registrar();
  public
    registrou : boolean;
    INFO : String;
    procedure Identifica();
  end;

var
  frmRegistrar: TfrmRegistrar;

implementation

{$R *.lfm}

{ TfrmRegistrar }

procedure TfrmRegistrar.Button1Click(Sender: TObject);
begin
  if (edNome.text <> '') and (edEmail.text <> '') then
  begin
       if (pos('@', edEmail.text)<> 0)  then
       begin
         Registrar();
         close;
       end
       else
       begin
         ShowMessage('Email não é valido!');
       end;
  end
  else
  begin
    Showmessage('Preencha os dados do registro!');
  end;
end;

procedure TfrmRegistrar.FormCreate(Sender: TObject);
begin
  INFO := '';
end;

procedure TfrmRegistrar.FormShow(Sender: TObject);
begin

end;

procedure TfrmRegistrar.LTCPComponent1Accept(aSocket: TLSocket);
begin

end;

procedure TfrmRegistrar.LTCPComponent1Connect(aSocket: TLSocket);
var
  resultado : string;
  begin
  if (INFO <> '') then
  begin
    aSocket.SendMessage(INFO);
  end;
end;

procedure TfrmRegistrar.LTCPComponent1Receive(aSocket: TLSocket);
var
  retorno : string;
begin
  aSocket.GetMessage(retorno);

  //ShowMessage(retorno);
  //frmlog.RegistraLog('Recebeu retorno do socket:'+copy(retorno,1,10));
end;

procedure TfrmRegistrar.Memo1Change(Sender: TObject);
begin

end;

procedure TfrmRegistrar.registrar();
begin

end;



procedure TfrmRegistrar.Identifica;
var
  Resp: string;
begin
  // Segurança básica: timeouts para não travar a aplicação
  IdHTTP1.ConnectTimeout := 5000; // 5s
  IdHTTP1.ReadTimeout    := 10000; // 10s

  // Evita cache e identifica o client
  IdHTTP1.Request.UserAgent := 'Maurinsoft/1.0';
  IdHTTP1.Request.CacheControl := 'no-cache';
  IdHTTP1.Request.Pragma := 'no-cache';

  try
    Resp := IdHTTP1.Get('http://maurinsoft.com.br/ws/register/iconnected.php');

    // Se quiser, pode usar a resposta (ex.: mostrar status, gravar log, etc.)
    // ShowMessage(Resp);

  except
    on E: EIdHTTPProtocolException do
    begin
      // Erros HTTP (404, 500, etc.)
      // E.ErrorCode tem o código, E.Message tem detalhe
      // Exemplo:
      // ShowMessage('HTTP ' + IntToStr(E.ErrorCode) + ': ' + E.Message);
      raise;
    end;
    on E: Exception do
    begin
      // Erros gerais (rede, timeout, DNS, etc.)
      // ShowMessage('Falha ao identificar: ' + E.Message);
      raise;
    end;
  end;
end;


end.

