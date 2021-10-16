unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Menus, ComCtrls, PopupNotifier, lNetComponents, lNet, DataPortIP,
  setmain, setup, splash, registro, log;

const Versao = '1.16';

type

  { Tfrmmain }

  Tfrmmain = class(TForm)
    btTipo2: TButton;
    btSetup01: TButton;
    btLog: TButton;
    btTipo1: TButton;
    btTipo3: TButton;
    LTCPComponent1: TLTCPComponent;
    btChamar: TMenuItem;
    btRechamar: TMenuItem;
    LTCPComponent2: TLTCPComponent;
    btFila2: TMenuItem;
    btSair: TMenuItem;
    btFila3: TMenuItem;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    miLog: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    N2: TMenuItem;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    PopupMenu2: TPopupMenu;
    PopupNotifier1: TPopupNotifier;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TrayIcon1: TTrayIcon;
    tvFila: TTreeView;
    procedure btChamarClick(Sender: TObject);
    procedure btFila2Click(Sender: TObject);
    procedure btFila3Click(Sender: TObject);
    procedure btLogClick(Sender: TObject);
    procedure btRechamarClick(Sender: TObject);
    procedure btSairClick(Sender: TObject);
    procedure btSetup01Click(Sender: TObject);
    procedure btStart1Click(Sender: TObject);
    procedure btStartClick(Sender: TObject);
    procedure btTipo1Click(Sender: TObject);
    procedure btTipo2Click(Sender: TObject);
    procedure btTipo3Click(Sender: TObject);
    procedure DataPortTCP1DataAppear(Sender: TObject);
    procedure edGuicheChange(Sender: TObject);
    procedure edIPFILAChange(Sender: TObject);
    procedure edIPPainelChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LTCPComponent1Accept(aSocket: TLSocket);
    procedure LTCPComponent1Connect(aSocket: TLSocket);
    procedure LTCPComponent1Disconnect(aSocket: TLSocket);
    procedure LTCPComponent1Receive(aSocket: TLSocket);
    procedure LTCPComponent2Accept(aSocket: TLSocket);
    procedure LTCPComponent2Disconnect(aSocket: TLSocket);
    procedure LTCPComponent2Receive(aSocket: TLSocket);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure miLogClick(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
    procedure Chamar(nro : integer);
    procedure Painel(nro : string; guiche: integer);
    procedure Config();

  private
    conn : boolean;
    lastcall : string;
    FsetMain :TSetMain;
    lista : TStringList;
    Mudou : boolean;
    procedure CarregaContexto();
  public
    tnFila : TTreeNode;
  end;

var
  frmmain: Tfrmmain;

implementation

{$R *.lfm}


{ Tfrmmain }

procedure Tfrmmain.CarregaContexto();
begin
  FSetMain.CarregaContexto();
  self.Left:= FsetMain.left;
  self.top:= FSetMain.top;
  self.width:= FsetMain.width;
  self.Height:= FSetMain.height;

  frmsetup.edGuiche.text := FSETMAIN.NROGUICHE;
  frmsetup.edIPFILA.text := FSETMAIN.IPFILA;
  frmsetup.edIPPainel.text := FSETMAIN.IPPAINEL;
end;

procedure Tfrmmain.btStartClick(Sender: TObject);
begin

end;

procedure Tfrmmain.btTipo1Click(Sender: TObject);
begin
  chamar(1);
end;

procedure Tfrmmain.btTipo2Click(Sender: TObject);
begin
  chamar(2);
end;

procedure Tfrmmain.btTipo3Click(Sender: TObject);
begin
  chamar(3);
end;

procedure Tfrmmain.DataPortTCP1DataAppear(Sender: TObject);
begin

end;

procedure Tfrmmain.edGuicheChange(Sender: TObject);
begin
  mudou := true;
end;

procedure Tfrmmain.edIPFILAChange(Sender: TObject);
begin
  mudou := true;
end;

procedure Tfrmmain.edIPPainelChange(Sender: TObject);
begin
    mudou := true;
end;

procedure Tfrmmain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
      FsetMain.top:= top;
      fsetmain.left:= left;
      FsetMain.width:= width;
      fsetmain.HEIGHT:= height;

      //Deve salvar antes
      FsetMain.SalvaContexto(false);
end;

procedure Tfrmmain.FormCreate(Sender: TObject);
begin
  self.Caption := 'Guiche - '+versao;
  frmSplash := TfrmSplash.create(self);
  frmSplash.lbVersao.caption := Versao;
  frmLog := TfrmLog.create(self);
  frmSplash.show();
  application.ProcessMessages;
  frmRegistrar := TfrmRegistrar.create(self);
  frmRegistrar.Identifica(); (*Bate na Maurinsoft*)
  frmsetup := Tfrmsetup.Create(self);
  sleep(2000);
  lista := TStringList.create;
  FsetMain := TsetMain.create();
  CarregaContexto();

  tnFila := tvFila.Items.AddFirst(nil,'Fila');


end;

procedure Tfrmmain.FormDestroy(Sender: TObject);
begin
  frmRegistrar.free();
end;

procedure Tfrmmain.FormShow(Sender: TObject);
begin
  sleep(2000);
  frmSplash.hide;
  TrayIcon1.Visible:=true;
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
      if frmsetup.ckPainel.Checked then
      begin
           Painel(strNro, strtoint(frmsetup.edGuiche.TextHint));
      end;
      //ShowMessage('Senha:'+strNro);
      PopupNotifier1.Text:=strNro;
      PopupNotifier1.Show;
      tvFila.Items.AddChild(tnFila,strNro);
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

procedure Tfrmmain.MenuItem10Click(Sender: TObject);
begin
  chamar(2);
end;

procedure Tfrmmain.MenuItem11Click(Sender: TObject);
begin
 chamar(3);
end;

procedure Tfrmmain.MenuItem12Click(Sender: TObject);
begin
  if frmsetup.ckPainel.Checked then
  begin
       painel(lastcall,strtoint(frmsetup.edGuiche.text));
  end;
  ShowMessage(lastcall);
end;

procedure Tfrmmain.Config();
begin
  frmsetup.edIPFILA.text := fsetmain.IPFILA;
  frmsetup.edIPPainel.text := fsetmain.IPPAINEL;
  frmsetup.edGuiche.text := fsetmain.NROGUICHE;
  frmsetup.ckPainel.Checked:= FsetMain.PAINEL;
  frmsetup.showmodal;
  fsetmain.IPFILA := frmsetup.edIPFILA.text;
  fsetmain.IPPAINEL := frmsetup.edIPPainel.text;
  fsetmain.NROGUICHE := frmsetup.edGuiche.text;
  fsetmain.PAINEL:= frmsetup.ckPainel.Checked;
  fsetmain.top := self.top;
  fsetmain.HEIGHT:= self.Height;
  fsetmain.WIDTH:= self.Width;
  FsetMain.LEFT:= self.left;

  FsetMain.SalvaContexto(false);
end;

procedure Tfrmmain.MenuItem13Click(Sender: TObject);
begin
  Config();
end;

procedure Tfrmmain.Chamar(nro : integer);
var
  param : string;
begin
   conn := false;
   if not (LTCPComponent1.Connected) then
   begin
     LTCPComponent1.Connect(frmsetup.edIPFILA.text,8095);
     repeat
       //tentando conectar
       sleep(300);
       //frmlog.log('Tentando conectar');
       application.ProcessMessages;
     until  not conn ;
     //LTCPComponent1.CallAction;
     sleep(1000);
     param := 'Fila:'+inttoStr(nro)+#13+'>'+frmsetup.edGuiche.text+';';
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
     LTCPComponent2.Connect(frmsetup.edIPPainel.text,8096);
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

procedure Tfrmmain.MenuItem9Click(Sender: TObject);
begin
  chamar(1);
end;

procedure Tfrmmain.miLogClick(Sender: TObject);
begin
  frmLog.show;
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

procedure Tfrmmain.btLogClick(Sender: TObject);
begin
  frmLog.show;
end;

procedure Tfrmmain.btRechamarClick(Sender: TObject);
begin
  if frmsetup.ckpainel.Checked then
  begin
       painel(lastcall,strtoint(frmsetup.edGuiche.text));
  end;
  ShowMessage(lastcall);
end;

procedure Tfrmmain.btSetup01Click(Sender: TObject);
begin
  Config();
end;

procedure Tfrmmain.btStart1Click(Sender: TObject);
begin

end;

end.

