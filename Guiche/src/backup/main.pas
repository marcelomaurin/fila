unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Menus, ComCtrls, PopupNotifier, Buttons, lNetComponents, lNet,
  DataPortIP, setmain, setup, splash, registro, log, hint;

const Versao = '1.27';

type

  { Tfrmmain }

  Tfrmmain = class(TForm)
    btrechamar3: TSpeedButton;
    Image1: TImage;
    ImageList1: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lbVersao: TLabel;
    LTCPComponent1: TLTCPComponent;
    btChamar: TMenuItem;
    btRechamar: TMenuItem;
    LTCPComponent2: TLTCPComponent;
    btFila2: TMenuItem;
    btSair: TMenuItem;
    btFila3: TMenuItem;
    LTCPComponent3: TLTCPComponent;
    LTCPComponent4: TLTCPComponent;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    miLimpar: TMenuItem;
    miRechamar: TMenuItem;
    miLog: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    N2: TMenuItem;
    PageControl1: TPageControl;
    Panel1: TPanel;
    pmItem: TPopupMenu;
    pmraiz: TPopupMenu;
    PopupMenu2: TPopupMenu;
    btTipo1: TSpeedButton;
    btTipo2: TSpeedButton;
    btTipo3: TSpeedButton;
    btTipo4: TSpeedButton;
    btTipo5: TSpeedButton;
    btSetup01: TSpeedButton;
    btLog: TSpeedButton;
    tsFila: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TrayIcon1: TTrayIcon;
    tvFila: TTreeView;
    procedure btChamarClick(Sender: TObject);
    procedure btFila2Click(Sender: TObject);
    procedure btFila3Click(Sender: TObject);
    procedure btLogClick(Sender: TObject);
    procedure btrechamar2Click(Sender: TObject);
    procedure btrechamar3Click(Sender: TObject);
    procedure btRechamarClick(Sender: TObject);
    procedure btSairClick(Sender: TObject);
    procedure btSetup01Click(Sender: TObject);
    procedure btStart1Click(Sender: TObject);
    procedure btStartClick(Sender: TObject);
    procedure btTipo1Click(Sender: TObject);
    procedure btTipo2Click(Sender: TObject);
    procedure btTipo3Click(Sender: TObject);
    procedure btTipo4Click(Sender: TObject);
    procedure btTipo5Click(Sender: TObject);
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
    procedure LTCPComponent1Error(const msg: string; aSocket: TLSocket);
    procedure LTCPComponent1Receive(aSocket: TLSocket);
    procedure LTCPComponent2Accept(aSocket: TLSocket);
    procedure LTCPComponent2Disconnect(aSocket: TLSocket);
    procedure LTCPComponent2Error(const msg: string; aSocket: TLSocket);
    procedure LTCPComponent2Receive(aSocket: TLSocket);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure miLimparClick(Sender: TObject);
    procedure miLogClick(Sender: TObject);
    procedure miRechamarClick(Sender: TObject);



    procedure TrayIcon1Click(Sender: TObject);
    procedure Chamar(nro : integer);
    procedure Painel1(nro : string; guiche: integer);
    procedure Painel2(nro : string; guiche: integer);
    procedure Painel3(nro : string; guiche: integer);
    procedure Config();
    procedure tvFilaChange(Sender: TObject; Node: TTreeNode);

  private
    conn : boolean;
    conn2 : boolean;
    lastcall : string;

    lista : TStringList;
    Mudou : boolean;
    procedure CarregaContexto();
  public
    tnFila : TTreeNode;
    tnsel : TTreeNode;
    procedure Rechamar();
    procedure CadastraRaiz();
    procedure AtualizaBotoes();
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


end;

procedure Tfrmmain.Rechamar();
begin
  if FsetMain.PAINEL then
  begin
       if(lastcall<>'') then
       begin
         painel1(lastcall,strtoint(FSetMain.NROGUICHE));
         painel2(lastcall,strtoint(FSetMain.NROGUICHE));
         painel3(lastcall,strtoint(FSetMain.NROGUICHE));
         frmhint.MessageHint(lastcall);
       end
       else
       begin
         //frmHint.MessageHint('Não há senhas a serem chamadas!');
         ShowMessage('Não há senhas a serem chamadas!');
       end;
  end;
  //ShowMessage(lastcall);

end;

procedure Tfrmmain.CadastraRaiz();
begin
  tnFila := tvFila.Items.AddFirst(nil,'Fila');
  tnFila.ImageIndex:= 6;
end;

procedure Tfrmmain.AtualizaBotoes();
begin
       btTipo1.Caption:= FSetMain.Rotulo01;
       btTipo2.Caption:= FSetMain.Rotulo02;
       btTipo3.Caption:= FSetMain.Rotulo03;
       btTipo4.Caption:= FSetMain.Rotulo04;
       btTipo5.Caption:= FSetMain.Rotulo05;
       btTipo1.Visible:= FSetMain.Habilitado01;
       btTipo2.Visible:= FSetMain.Habilitado02;
       btTipo3.Visible:= FSetMain.Habilitado03;
       btTipo4.Visible:= FSetMain.Habilitado04;
       btTipo5.Visible:= FSetMain.Habilitado05;
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

procedure Tfrmmain.btTipo4Click(Sender: TObject);
begin
   chamar(4);
end;

procedure Tfrmmain.btTipo5Click(Sender: TObject);
begin
   chamar(5);
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
  frmhint := TfrmHint.create(self);
  self.Caption := 'Guiche - '+versao;
  lbVersao.Caption:= versao;
  frmSplash := TfrmSplash.create(self);
  frmSplash.lbVersao.caption := Versao;
  FsetMain := TsetMain.create();
  CarregaContexto();

  frmsetup := Tfrmsetup.Create(self);


  frmLog := TfrmLog.create(self);
  frmSplash.show();
  application.ProcessMessages;
  frmRegistrar := TfrmRegistrar.create(self);
  frmRegistrar.Identifica(); (*Bate na Maurinsoft*)
  AtualizaBotoes();

  sleep(2000);
  lista := TStringList.create;



  CadastraRaiz();



end;

procedure Tfrmmain.FormDestroy(Sender: TObject);
begin
  frmRegistrar.free();
  frmHint.Free;
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
  if (frmLog <> nil) then
  begin
          frmLog.meLog.Append('Conectou painel '+aSocket.LocalAddress+' - '+timetostr(now));
  end;
end;

procedure Tfrmmain.LTCPComponent1Disconnect(aSocket: TLSocket);
begin
  aSocket.Disconnect(true);
  if (frmLog <> nil) then
  begin
          frmLog.meLog.Append('Desconectou painel '+aSocket.LocalAddress+' - '+timetostr(now));
  end;
  conn := false;
end;

procedure Tfrmmain.LTCPComponent1Error(const msg: string; aSocket: TLSocket);
begin
  if (frmLog <> nil) then
  begin
          frmLog.meLog.Append(msg+' - '+timetostr(now));
  end;
end;

procedure Tfrmmain.LTCPComponent1Receive(aSocket: TLSocket);
var
  info : string;
  strNro : string;
  strNro2 : string;
  nro : integer;
  posicao : integer;
  posfim : integer;
  tvitem : TTreeNode;
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
      strNro := StringReplace(strNro, #13, '', [rfReplaceAll]); // remove \r
      strNro2 := StringReplace(strNro, #10, '', [rfReplaceAll]); // remove \n
      //nro := strtoint(strnro2);
      sleep(1000);
      Application.ProcessMessages;
      if frmsetup.ckPainel.Checked then
      begin
           Painel1(strNro2, strtoint(FSetMain.NROGUICHE));
           Painel2(strNro2, strtoint(FSetMain.NROGUICHE));
           Painel3(strNro2, strtoint(FSetMain.NROGUICHE));
      end;
      //ShowMessage('Senha:'+strNro);
      //PopupNotifier1.Text:=strNro;
      //PopupNotifier1.Show;
      frmHint.MessageHint('Senha:'+strNro2);
      if (frmLog <> nil) then
      begin
          frmLog.meLog.Append(strNro2+' - '+timetostr(now));
      end;
      tvitem := tvFila.Items.AddChild(tnFila,strNro2);
      tvitem.ImageIndex:= 5;
      //Chama o painel
      (*
      if(FsetMain.PAINEL) then
      begin
         Painel1( strNro2,strtoint(FsetMain.NROGUICHE));
         Painel2( strNro2,strtoint(FsetMain.NROGUICHE));
         Painel3( strNro2,strtoint(FsetMain.NROGUICHE));
      end;
      *)

    end
    else
    begin
      ShowMessage('Fila Vazia');
    end;
  end
  else
  begin

  end;
 btrechamar3.Enabled:= true;
 Cursor:= crDefault;
 // MessageDlg('Retornou',info,[],[],null);
 aSocket.Disconnect(true); //Nao recebeu nada
end;

procedure Tfrmmain.LTCPComponent2Accept(aSocket: TLSocket);
begin
    conn2 := true;
end;

procedure Tfrmmain.LTCPComponent2Disconnect(aSocket: TLSocket);
begin
  aSocket.Disconnect(true);
  conn2 := false;
end;

procedure Tfrmmain.LTCPComponent2Error(const msg: string; aSocket: TLSocket);
begin
    if (frmLog <> nil) then
    begin
        frmLog.meLog.Append('Erro na conexao painel '+ msg + ' '+ timetostr(now));
    end;
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
  if (frmLog <> nil) then
  begin
      frmLog.meLog.Append('Painel enviou '+ info + ' '+ timetostr(now));
  end;
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
     Rechamar();
end;

procedure Tfrmmain.Config();
begin
  frmsetup.edIPFILA.text := fsetmain.IPFILA;
  frmsetup.edIPPainel1.text := fsetmain.IPPAINEL1;
  frmsetup.edIPPainel2.text := fsetmain.IPPAINEL2;
  frmsetup.edIPPainel3.text := fsetmain.IPPAINEL3;
  frmsetup.edGuiche.text := fsetmain.NROGUICHE;
  frmsetup.ckPainel.Checked:= FsetMain.PAINEL;
  frmsetup.showmodal;
  fsetmain.IPFILA := frmsetup.edIPFILA.text;
  fsetmain.IPPAINEL1 := frmsetup.edIPPainel1.text;
  fsetmain.IPPAINEL2 := frmsetup.edIPPainel2.text;
  fsetmain.IPPAINEL3 := frmsetup.edIPPainel3.text;
  fsetmain.NROGUICHE := frmsetup.edGuiche.text;
  fsetmain.PAINEL:= frmsetup.ckPainel.Checked;
  fsetmain.top := self.top;
  fsetmain.HEIGHT:= self.Height;
  fsetmain.WIDTH:= self.Width;
  FsetMain.LEFT:= self.left;

  FsetMain.SalvaContexto(false);
end;

procedure Tfrmmain.tvFilaChange(Sender: TObject; Node: TTreeNode);
begin
  tnsel := node;
  if(node <> nil) then
  begin
    if(node.Parent = tnFila) then
    begin
      tvfila.PopupMenu := pmItem;
    end
    else
    begin
      tvfila.PopupMenu := pmraiz;
    end;

  end;
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
   PageControl1.ActivePage  :=  tsFila;
   if not (LTCPComponent1.Connected) then
   begin
     Cursor:= crHourGlass;
     LTCPComponent1.Connect(FSetMain.IPFILA,8095);
     repeat
       //tentando conectar
       sleep(300);
       //frmlog.log('Tentando conectar');
       application.ProcessMessages;
     until  not conn ;
     btrechamar3.Enabled:= false;
     //LTCPComponent1.CallAction;
     sleep(1000);
     if (FSetMain.PROTOCOLO = 1) then
     begin
          param := 'Fila:'+inttoStr(nro)+#13+'>'+FSetMain.NROGUICHE+';';
     end
     else
     begin
       param := 'Fila:'+inttoStr(nro)+#13+'>'+FSetMain.NROGUICHE+';';
     end;
     LTCPComponent1.SendMessage(param,nil);
     tvFila.AutoExpand:= true;
   end;
end;

procedure Tfrmmain.Painel1(nro: string; guiche: integer);
var
  param : string;
begin
 if(FsetMain.IPPAINEL1 <> '') then
 begin
   conn2 := false;

   if not (LTCPComponent2.Connected) then
   begin
     LTCPComponent2.Connect(FsetMain.IPPAINEL1,8196);
     repeat
       //tentando conectar
       sleep(300);
       //frmlog.log('Tentando conectar');
       application.ProcessMessages;
     until  not conn2 ;
     //LTCPComponent1.CallAction;
     sleep(1000);
     if (FSetMain.PROTOCOLO = 1) then
     begin
          param := 'FILA:'+nro+'>'+inttostr(guiche)+';';
          if (frmLog <> nil) then
          begin
              frmLog.meLog.Append('Guiche:'+inttostr(guiche)+' chamou:'+nro+' - '+timetostr(now));
          end;

     end
     else
     begin
          param := 'Fila:'+nro+#13+'>'+inttostr(guiche)+';';
     end;

     LTCPComponent2.SendMessage(param,nil);
   end;
 end;
end;

procedure Tfrmmain.Painel2(nro: string; guiche: integer);
var
  param : string;
begin
 if(FsetMain.IPPAINEL2 <> '') then
 begin
   conn2 := false;
   if not (LTCPComponent2.Connected) then
   begin
     LTCPComponent3.Connect(FsetMain.IPPAINEL2,8196);
     repeat
       //tentando conectar
       sleep(300);
       //frmlog.log('Tentando conectar');
       application.ProcessMessages;
     until  not conn2 ;
     //LTCPComponent1.CallAction;
     sleep(1000);
     if (FSetMain.PROTOCOLO = 1) then
     begin
          param := 'FILA:'+nro+'>'+inttostr(guiche)+';';

     end
     else
     begin
          param := 'Fila:'+nro+#13+'>'+inttostr(guiche)+';';
     end;

     LTCPComponent3.SendMessage(param,nil);
   end;
 end;

end;

procedure Tfrmmain.Painel3(nro: string; guiche: integer);
var
  param : string;
begin
   conn2 := false;
 if not (LTCPComponent2.Connected) then
 begin

   if not (LTCPComponent4.Connected) then
   begin
     LTCPComponent4.Connect(FsetMain.IPPAINEL3,8196);
     repeat
       //tentando conectar
       sleep(300);
       //frmlog.log('Tentando conectar');
       application.ProcessMessages;
     until  not conn2 ;
     //LTCPComponent1.CallAction;
     sleep(1000);
     if (FSetMain.PROTOCOLO = 1) then
     begin
          param := 'FILA:'+nro+'>'+inttostr(guiche)+';';

     end
     else
     begin
          param := 'Fila:'+nro+#13+'>'+inttostr(guiche)+';';
     end;

     LTCPComponent4.SendMessage(param,nil);
   end;
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

procedure Tfrmmain.miLimparClick(Sender: TObject);
begin
  tvFila.Items.Clear;
  CadastraRaiz();
end;

procedure Tfrmmain.miLogClick(Sender: TObject);
begin
  frmLog.show;
end;

procedure Tfrmmain.miRechamarClick(Sender: TObject);
begin

  if (tnsel <> nil)then
  begin
       if( tnsel.Text<>'') then
       begin
         painel1( tnsel.Text,strtoint(FSetMain.NROGUICHE));
         painel2( tnsel.Text,strtoint(FSetMain.NROGUICHE));
         painel3( tnsel.Text,strtoint(FSetMain.NROGUICHE));
         frmhint.MessageHint(lastcall);
       end
       else
       begin
         //frmHint.MessageHint('Não há senhas a serem chamadas!');
         ShowMessage('Não há senhas a serem chamadas!');
       end;
  end;
  //ShowMessage(lastcall);

  //Rechamar();
end;

procedure Tfrmmain.btLogClick(Sender: TObject);
begin
    frmLog.show;
end;

procedure Tfrmmain.btSetup01Click(Sender: TObject);
begin
  Config();
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



procedure Tfrmmain.btrechamar2Click(Sender: TObject);
begin

end;

procedure Tfrmmain.btrechamar3Click(Sender: TObject);
begin
   Rechamar();
end;

procedure Tfrmmain.btRechamarClick(Sender: TObject);
begin
  if FsetMain.PAINEL then
  begin
       painel1(lastcall,strtoint(FSetMain.NROGUICHE));
       painel2(lastcall,strtoint(FSetMain.NROGUICHE));
       painel3(lastcall,strtoint(FSetMain.NROGUICHE));
       AtualizaBotoes();
  end;
  ShowMessage(lastcall);
end;



procedure Tfrmmain.btStart1Click(Sender: TObject);
begin

end;

end.

