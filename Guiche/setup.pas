unit Setup;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Menus, lNetComponents, lNet, DataPortIP;

type

  { Tfrmmain }

  { TfrmSetup }

  TfrmSetup = class(TForm)
    btStart: TButton;
    ckGuiche: TCheckBox;
    DataPortTCP1: TDataPortTCP;
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
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    btSair: TMenuItem;
    btFila3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    N1: TMenuItem;
    PopupMenu1: TPopupMenu;
    TrayIcon1: TTrayIcon;

    procedure btChamarClick(Sender: TObject);
    procedure btFila2Click(Sender: TObject);
    procedure btFila3Click(Sender: TObject);

    procedure btSairClick(Sender: TObject);
    procedure btSetupClick(Sender: TObject);
    procedure btStartClick(Sender: TObject);
    procedure DataPortTCP1DataAppear(Sender: TObject);
    procedure edIPFILAChange(Sender: TObject);
    procedure LTCPComponent1Accept(aSocket: TLSocket);
    procedure LTCPComponent1Connect(aSocket: TLSocket);
    procedure LTCPComponent1Disconnect(aSocket: TLSocket);
    procedure LTCPComponent1Receive(aSocket: TLSocket);
    procedure LTCPComponent2Accept(aSocket: TLSocket);
    procedure LTCPComponent2Disconnect(aSocket: TLSocket);
    procedure LTCPComponent2Receive(aSocket: TLSocket);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
    procedure Chamar(nro : integer);
    procedure Painel(nro : string; guiche: integer);
  private
    conn : boolean;
    lastcall : string;
  public

  end;

var
  frmsetup: Tfrmsetup;

implementation

{$R *.lfm}

{ TfrmSetup }

procedure TfrmSetup.btChamarClick(Sender: TObject);
begin

end;


procedure TfrmSetup.btStartClick(Sender: TObject);
begin
  TrayIcon1.Visible:=true;

  //LTCPComponent1.Connect(edIPFILA.text,8095);
  //LTCPComponent2.Connect(edIPPainel.Text,8096);
  hide;
end;

procedure TfrmSetup.DataPortTCP1DataAppear(Sender: TObject);
begin

end;

procedure TfrmSetup.edIPFILAChange(Sender: TObject);
begin

end;
















procedure TfrmSetup.MenuItem3Click(Sender: TObject);
begin

end;

procedure TfrmSetup.MenuItem6Click(Sender: TObject);
begin
    show;
end;



procedure TfrmSetup.TrayIcon1Click(Sender: TObject);
begin

end;




{ Tfrmmain }




procedure TfrmSetup.LTCPComponent1Accept(aSocket: TLSocket);
begin
  conn := true;
end;

procedure TfrmSetup.LTCPComponent1Connect(aSocket: TLSocket);
begin
  conn := true;
end;

procedure TfrmSetup.LTCPComponent1Disconnect(aSocket: TLSocket);
begin
  aSocket.Disconnect(true);
  conn := false;
end;

procedure TfrmSetup.LTCPComponent1Receive(aSocket: TLSocket);
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


procedure TfrmSetup.LTCPComponent2Accept(aSocket: TLSocket);
begin
    conn := true;
end;

procedure TfrmSetup.LTCPComponent2Disconnect(aSocket: TLSocket);
begin
  aSocket.Disconnect(true);
  conn := false;
end;

procedure TfrmSetup.LTCPComponent2Receive(aSocket: TLSocket);
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

procedure TfrmSetup.Chamar(nro : integer);
var
  param : string;
begin
   conn := false;
   if not (LTCPComponent1.Connected) then
   begin
     LTCPComponent1.Connect(edIPFILA.text,8095);
     repeat
       //tentando conectar
       //sleep(300);
       //frmlog.log('Tentando conectar');
       application.ProcessMessages;
     until  not conn ;
     //LTCPComponent1.CallAction;
     //delay(1000);
     param := 'Fila:'+inttoStr(nro)+#13;
     LTCPComponent1.SendMessage(param,nil);
   end;
end;

procedure TfrmSetup.Painel(nro : string; guiche: integer);
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

procedure TfrmSetup.MenuItem1Click(Sender: TObject);
begin
  chamar(1);
end;

procedure TfrmSetup.MenuItem2Click(Sender: TObject);
begin
  if ckGuiche.Checked then
  begin
       painel(lastcall,strtoint(edGuiche.text));
  end;
  ShowMessage(lastcall);
end;



procedure TfrmSetup.btSairClick(Sender: TObject);
begin
  close;
end;



procedure TfrmSetup.btFila2Click(Sender: TObject);
begin
  Chamar(2);
end;

procedure TfrmSetup.btFila3Click(Sender: TObject);
begin
  Chamar(3);
end;



procedure TfrmSetup.btSetupClick(Sender: TObject);
begin

end;

end.


