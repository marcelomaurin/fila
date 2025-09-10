unit Setup;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Menus, ComCtrls, lNetComponents, lNet, DataPortIP, setmain, Types;



type

  { Tfrmmain }

  { TfrmSetup }

  TfrmSetup = class(TForm)
    btCancelar: TButton;
    btSalvar: TButton;
    ckRotulo01: TCheckBox;
    ckPainel: TCheckBox;
    ckRotulo02: TCheckBox;
    ckRotulo03: TCheckBox;
    ckRotulo04: TCheckBox;
    ckRotulo05: TCheckBox;
    cbProtocolo: TComboBox;
    DataPortTCP1: TDataPortTCP;
    edGuiche: TEdit;
    edIPFILA: TEdit;
    edIPPainel1: TEdit;
    edIPPainel2: TEdit;
    edIPPainel3: TEdit;
    edRotulo01: TEdit;
    edRotulo02: TEdit;
    edRotulo03: TEdit;
    edRotulo04: TEdit;
    edRotulo05: TEdit;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
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
    PageControl1: TPageControl;
    Panel1: TPanel;
    PopupMenu1: TPopupMenu;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;

    procedure btCancelarClick(Sender: TObject);
    procedure btChamarClick(Sender: TObject);
    procedure btFila2Click(Sender: TObject);
    procedure btFila3Click(Sender: TObject);

    procedure btSairClick(Sender: TObject);
    procedure btSalvarClick(Sender: TObject);
    procedure btSetupClick(Sender: TObject);
    procedure btStartClick(Sender: TObject);
    procedure DataPortTCP1DataAppear(Sender: TObject);
    procedure edIPFILAChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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
    procedure TabSheet4ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure TrayIcon1Click(Sender: TObject);
    procedure Chamar(nro : integer);
    procedure Painel1(nro : string; guiche: integer);
    procedure Painel2(nro : string; guiche: integer);
    procedure Painel3(nro : string; guiche: integer);
  private
    conn : boolean;
    lastcall : string;
  public
     procedure default();
     procedure CarregaParametros();
     procedure SalvaParametros();
  end;

var
  frmsetup: Tfrmsetup;

implementation

{$R *.lfm}

{ TfrmSetup }

procedure TfrmSetup.btChamarClick(Sender: TObject);
begin

end;

procedure TfrmSetup.btCancelarClick(Sender: TObject);
begin
  Close;
end;


procedure TfrmSetup.btStartClick(Sender: TObject);
begin

end;

procedure TfrmSetup.DataPortTCP1DataAppear(Sender: TObject);
begin

end;

procedure TfrmSetup.edIPFILAChange(Sender: TObject);
begin

end;

procedure TfrmSetup.FormCreate(Sender: TObject);
begin
     CarregaParametros();
end;

procedure TfrmSetup.MenuItem3Click(Sender: TObject);
begin

end;

procedure TfrmSetup.MenuItem6Click(Sender: TObject);
begin

end;

procedure TfrmSetup.TabSheet4ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

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
      if ckPainel.Checked then
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

procedure TfrmSetup.Painel1(nro : string; guiche: integer);
var
  param : string;
begin
   conn := false;
   if not (LTCPComponent2.Connected) then
   begin
     LTCPComponent2.Connect(edIPPainel1.text,8096);
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

procedure TfrmSetup.Painel2(nro: string; guiche: integer);
var
  param : string;
begin
   conn := false;
   if not (LTCPComponent2.Connected) then
   begin
     LTCPComponent2.Connect(edIPPainel2.text,8096);
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

procedure TfrmSetup.Painel3(nro: string; guiche: integer);
var
  param : string;
begin
   conn := false;
   if not (LTCPComponent2.Connected) then
   begin
     LTCPComponent2.Connect(edIPPainel3.text,8096);
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

procedure TfrmSetup.default();
begin
  edGuiche.Text:= '1';
  edIPFILA.text := '127.0.0.1';
  edIPPainel1.text := '127.0.0.1';
  edIPPainel2.text := '';
  edIPPainel3.text := '';
  edRotulo01.text := 'Tipo01';
  edRotulo02.text := 'Tipo02';
  edRotulo03.text := 'Tipo03';
  edRotulo04.text := 'Tipo04';
  edRotulo05.text := 'Tipo05';
  ckRotulo01.Checked:= true;
  ckRotulo02.Checked:= true;
  ckRotulo03.Checked:= true;
  ckRotulo04.Checked:= true;
  ckRotulo05.Checked:= true;
  ckPainel.Checked:= true;

end;

procedure TfrmSetup.CarregaParametros();
begin
  edGuiche.text := FSETMAIN.NROGUICHE;
  edIPFILA.text := FSETMAIN.IPFILA;
  edIPPainel1.text := FSETMAIN.IPPAINEL1;
  edIPPainel2.text := FSETMAIN.IPPAINEL2;
  edIPPainel3.text := FSETMAIN.IPPAINEL3;
  ckPainel.Checked := FSetMain.PAINEL;
  edRotulo01.text := FSetMain.Rotulo01;
  edRotulo02.text := FSetMain.Rotulo02;
  edRotulo03.text := FSetMain.Rotulo03;
  edRotulo04.text := FSetMain.Rotulo04;
  edRotulo05.text := FSetMain.Rotulo05;
  ckRotulo01.Checked:= FSetMain.Habilitado01;
  ckRotulo02.Checked:= FSetMain.Habilitado02;
  ckRotulo03.Checked:= FSetMain.Habilitado03;
  ckRotulo04.Checked:= FSetMain.Habilitado04;
  ckRotulo05.Checked:= FSetMain.Habilitado05;
  cbProtocolo.ItemIndex:= FSetMain.PROTOCOLO;
end;

procedure TfrmSetup.SalvaParametros();
begin
  FSETMAIN.NROGUICHE := edGuiche.text;
  FSETMAIN.IPFILA:= edIPFILA.text;
  FSETMAIN.IPPAINEL1 := edIPPainel1.text;
  FSETMAIN.IPPAINEL2 := edIPPainel2.text;
  FSETMAIN.IPPAINEL3 := edIPPainel3.text;
  FSetMain.PAINEL:= ckPainel.Checked;
  FSetMain.Rotulo01:= edRotulo01.text;
  FSetMain.Rotulo02:= edRotulo02.text;
  FSetMain.Rotulo03:= edRotulo03.text;
  FSetMain.Rotulo04:= edRotulo04.text;
  FSetMain.Rotulo05:= edRotulo05.text;
  FSetMain.Habilitado01:= ckRotulo01.Checked;
  FSetMain.Habilitado02:= ckRotulo02.Checked;
  FSetMain.Habilitado03:= ckRotulo03.Checked;
  FSetMain.Habilitado04:= ckRotulo04.Checked;
  FSetMain.Habilitado05:= ckRotulo05.Checked;
  FSetMain.PROTOCOLO:= cbProtocolo.ItemIndex;
  FSetMain.SalvaContexto(false);
end;

procedure TfrmSetup.MenuItem1Click(Sender: TObject);
begin

end;

procedure TfrmSetup.MenuItem2Click(Sender: TObject);
begin

end;



procedure TfrmSetup.btSairClick(Sender: TObject);
begin
  close;
end;

procedure TfrmSetup.btSalvarClick(Sender: TObject);
begin
  SalvaParametros();
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


