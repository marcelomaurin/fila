unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Menus, lNetComponents, lNet, DataPortIP;

type

  { Tfrmmain }

  Tfrmmain = class(TForm)
    btStart: TButton;
    ckGuiche: TCheckBox;
    edGuiche: TEdit;
    edIPFILA: TEdit;
    edIPPainel: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LTCPComponent1: TLTCPComponent;
    btChamar: TMenuItem;
    btRechamar: TMenuItem;
    btSetup: TMenuItem;
    LTCPComponent2: TLTCPComponent;
    MenuItem1: TMenuItem;
    btFila2: TMenuItem;
    MenuItem3: TMenuItem;
    btSair: TMenuItem;
    btFila3: TMenuItem;
    PopupMenu1: TPopupMenu;
    TrayIcon1: TTrayIcon;

    procedure btChamarClick(Sender: TObject);
    procedure btFila2Click(Sender: TObject);
    procedure btFila3Click(Sender: TObject);
    procedure btRechamarClick(Sender: TObject);
    procedure btSairClick(Sender: TObject);
    procedure btSetupClick(Sender: TObject);
    procedure btStartClick(Sender: TObject);
    procedure DataPortTCP1DataAppear(Sender: TObject);
    procedure LTCPComponent1Accept(aSocket: TLSocket);
    procedure LTCPComponent1Connect(aSocket: TLSocket);
    procedure LTCPComponent1Disconnect(aSocket: TLSocket);
    procedure LTCPComponent1Receive(aSocket: TLSocket);
    procedure LTCPComponent2Accept(aSocket: TLSocket);
    procedure LTCPComponent2Disconnect(aSocket: TLSocket);
    procedure LTCPComponent2Receive(aSocket: TLSocket);
    procedure MenuItem1Click(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
    procedure Chamar(nro : integer);
    procedure Painel(nro : string; guiche: integer);
  private
    conn : boolean;
    lastcall : string;
  public

  end;

var
  frmmain: Tfrmmain;

implementation

{$R *.lfm}

{ Tfrmmain }

procedure Tfrmmain.btStartClick(Sender: TObject);
begin
  TrayIcon1.Visible:=true;

  //LTCPComponent1.Connect(edIPFILA.text,8095);
  //LTCPComponent2.Connect(edIPPainel.Text,8096);
  hide;
end;

procedure Tfrmmain.DataPortTCP1DataAppear(Sender: TObject);
begin

end;

procedure Tfrmmain.LTCPComponent1Accept(aSocket: TLSocket);
begin
  conn := true;
end;

procedure Tfrmmain.LTCPComponent1Connect(aSocket: TLSocket);
begin
  //conn := true;
end;

procedure Tfrmmain.LTCPComponent1Disconnect(aSocket: TLSocket);
begin
  aSocket.Disconnect(true);
  conn := false;
end;

procedure Tfrmmain.LTCPComponent1Receive(aSocket: TLSocket);
var
  info : string;
  strNro : string;
  strNro2 : string;
  nro : integer;
  posicao : integer;
  posfim : integer;
begin
  aSocket.GetMessage(info);
  posicao := pos('Fila:',info);
  if (posicao>=0) then
  begin
    posfim := pos(#13,info);
    strNro := copy(info , posicao+7,posfim-(posicao+6));
    if (strNro <> '0'+#13) then
    begin
      lastcall:= strnro;
      strNro2 := copy(strNro,2,length(strnro)-2);
      nro := strtoint(strnro2);
      if ckGuiche.Checked then
      begin
           Painel(strNro, strtoint(edGuiche.TextHint));
      end;
      ShowMessage('Senha:'+strNro);
    end
    else
    begin
      ShowMessage('Fila Vazia');
    end;
  end
  else
  begin

  end;

 // MessageDlg('Retornou',info,[],[],null);
 aSocket.Disconnect(true); //Nao recebeu nada
end;

procedure Tfrmmain.LTCPComponent2Accept(aSocket: TLSocket);
begin
    conn := true;
end;

procedure Tfrmmain.LTCPComponent2Disconnect(aSocket: TLSocket);
begin
  aSocket.Disconnect(true);
  conn := false;
end;

procedure Tfrmmain.LTCPComponent2Receive(aSocket: TLSocket);
  var
  info : string;
  strNro : string;
  nro : integer;
  posicao : integer;
  posfim : integer;
begin
  aSocket.GetMessage(info);
  posicao := pos('OK'+#13,info);
  if (posicao>=0) then
  begin

  end;
 // MessageDlg('Retornou',info,[],[],null);
 aSocket.Disconnect(true); //Nao recebeu nada
end;

procedure Tfrmmain.Chamar(nro : integer);
var
  param : string;
begin
   conn := false;
   if not (LTCPComponent1.Connected) then
   begin
     LTCPComponent1.Connect(edIPFILA.text,8095);
     repeat
       //tentando conectar
       sleep(300);
       //frmlog.log('Tentando conectar');
       application.ProcessMessages;
     until  not conn ;
     //LTCPComponent1.CallAction;
     sleep(1000);
     param := 'Fila:'+inttoStr(nro)+#13+'>'+edGuiche.text+';';
     LTCPComponent1.SendMessage(param,nil);

   end;
end;

procedure Tfrmmain.Painel(nro : string; guiche: integer);
var
  param : string;
begin
   conn := false;
   if not (LTCPComponent2.Connected) then
   begin
     LTCPComponent2.Connect(edIPPainel.text,8096);
     repeat
       //tentando conectar
       //sleep(300);
       //frmlog.log('Tentando conectar');
       application.ProcessMessages;
     until  not conn ;
     //LTCPComponent1.CallAction;
     //delay(1000);
     param := 'Fila:'+nro;
     LTCPComponent2.SendMessage(param,nil);
   end;
end;

procedure Tfrmmain.MenuItem1Click(Sender: TObject);
begin
  chamar(1);
end;

procedure Tfrmmain.TrayIcon1Click(Sender: TObject);
begin

end;

procedure Tfrmmain.btSairClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure Tfrmmain.btChamarClick(Sender: TObject);
begin

end;

procedure Tfrmmain.btFila2Click(Sender: TObject);
begin
  Chamar(2);
end;

procedure Tfrmmain.btFila3Click(Sender: TObject);
begin
  Chamar(3);
end;

procedure Tfrmmain.btRechamarClick(Sender: TObject);
begin
  if ckGuiche.Checked then
  begin
       painel(lastcall,strtoint(edGuiche.text));
  end;
  ShowMessage(lastcall);
end;

procedure Tfrmmain.btSetupClick(Sender: TObject);
begin
  show;
end;

end.

