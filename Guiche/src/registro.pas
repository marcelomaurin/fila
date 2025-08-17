unit registro;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  lNetComponents, lNet, log, IdHTTP, IdSSLOpenSSL, IdSSLOpenSSLHeaders;

type

  { TfrmRegistrar }

  TfrmRegistrar = class(TForm)
    Button1: TButton;
    edNome: TEdit;
    edEmail: TEdit;
    IdHTTP1: TIdHTTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
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
  frmlog.RegistraLog('Recebeu retorno do socket:'+copy(retorno,1,10));
end;

procedure TfrmRegistrar.Memo1Change(Sender: TObject);
begin

end;

procedure TfrmRegistrar.registrar();
begin

end;

procedure TfrmRegistrar.Identifica();
begin
  (*
  if(LTCPComponent1.Connected) then
  begin
       LTCPComponent1.Disconnect(true);
       sleep(1000);
  end;
  *)

  {$IFDEF MSWINDOWS}
  IdOpenSSLSetLibSSL(ExtractFilePath(ParamStr(0)) + 'libssl-1_0-x64.dll');  // Ajuste o nome se for ssleay32.dll
  IdOpenSSLSetLibCrypto(ExtractFilePath(ParamStr(0)) + 'libcrypto-1_0-x64.dll');  // Ajuste o nome se for libeay32.dll
  {$ENDIF}
  {$IFDEF LINUX}
  //IdOpenSSLSetLibSSL('/usr/lib/x86_64-linux-gnu/libssl.so.3');  // Ajuste o nome se for ssleay32.dll
  //IdOpenSSLSetLibCrypto('/usr/lib/x86_64-linux-gnu/libcrypto.so');  // Ajuste o nome se for libeay32.dll
  {$ENDIF}

  // No Linux, não defina caminhos; use os defaults do sistema após a instalação acima.

  //SSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  //SSLHandler.SSLOptions;
  try
    //IdHTTP1.IOHandler := SSLHandler;
    IdSSLIOHandlerSocketOpenSSL1.SSLOptions.VerifyDirs:='/usr/lib/i386-linux-gnu/';
    IdHTTP1.Get('https://maurinsoft.com.br/ws/register/iconnected.php');
  finally
    //SSLHandler.Free;
  end;
end;

end.

