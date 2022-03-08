unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Menus, DataPortIP, lNetComponents, menu, lNet, log, splash, registro,
  setmain;

const

  PortGuiche = 8095;
  PortPainel = 8096;
  intversao = 2;
  intrevisao = 00;
type

  { Tfrmmain }

  Tfrmmain = class(TForm)
    cbIniciar: TCheckBox;
    cbTipoImp: TComboBox;
    edCont2: TEdit;
    edCont3: TEdit;
    edPainel: TEdit;
    edEmpresa: TEdit;
    edTipo1: TEdit;
    edlocalizacao: TEdit;
    edTipo2: TEdit;
    edTipo3: TEdit;
    edCont1: TEdit;
    Empresa: TLabel;
    Image1: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    LTCPComponent1: TLTCPComponent;
    LTCPComponent2: TLTCPComponent;
    Memo1: TMemo;
    MenuItem3: TMenuItem;
    Versao: TLabel;
    lblocalizacao: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    PopupMenu1: TPopupMenu;
    Timer1: TTimer;
    ToggleBox1: TToggleBox;
    TrayIcon1: TTrayIcon;

    procedure edCont2Change(Sender: TObject);
    procedure edCont3Change(Sender: TObject);
    procedure edTipo1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LTCPComponent1Connect(aSocket: TLSocket);
    procedure LTCPComponent1Receive(aSocket: TLSocket);
    procedure LTCPComponent2Receive(aSocket: TLSocket);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ToggleBox1Change(Sender: TObject);
    procedure SalvarContexto();
    procedure ToggleBox1Click(Sender: TObject);
  private
    guiche : string;
    nro : integer;
    item : string;
  public
    procedure Executar();

  end;

var
  frmmain: Tfrmmain;

implementation

{$R *.lfm}

{ Tfrmmain }

procedure Tfrmmain.MenuItem1Click(Sender: TObject);
begin
  frmmenu.show;
end;

procedure Tfrmmain.MenuItem2Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure Tfrmmain.MenuItem3Click(Sender: TObject);
begin
  frmLog.Show;
end;

procedure Tfrmmain.Timer1Timer(Sender: TObject);
begin
 edCont1.Text:= inttostr(frmMenu.posFila1);
 edCont2.Text:= inttostr(frmMenu.posFila2);
 edCont3.Text:= inttostr(frmMenu.posFila3);
 SalvarContexto();
end;

procedure Tfrmmain.FormShow(Sender: TObject);
var
  local : string;
begin
  Timer1.Enabled:=false;
  self.top := fsetmain.posy;
  self.Left:= fsetmain.posx;
  edEmpresa.text:= FSETMAIN.empresa;
  edlocalizacao.text:= fsetmain.localizacao;
  edTipo1.text:= fsetmain.Tipo1;
  edTipo2.text:= fsetmain.tipo2;
  edTipo3.text:= fsetmain.tipo3;
  edCont1.text:= inttostr(fsetmain.Contagem1);
  edCont2.text:= inttostr(fsetmain.Contagem2);
  edCont3.text:= inttostr(fsetmain.Contagem3);
  cbIniciar.Checked:= fsetmain.EXEC;
  cbTipoImp.ItemIndex:= fsetmain.TipoImp;
  frmSplash.hide;
  if (cbIniciar.Checked) then
  begin
    Executar();
  end;
end;

procedure Tfrmmain.LTCPComponent1Connect(aSocket: TLSocket);
begin
  aSocket.SendMessage('Connected!');
  frmLog.Log('Connected:'+aSocket.PeerAddress);
end;

procedure Tfrmmain.LTCPComponent1Receive(aSocket: TLSocket);
var
  mensagem : string;
  strnro : string;
  posicao : integer;
begin
   //Mensagem recebida padrao Fila:nro+#13
  aSocket.GetMessage(mensagem);
  frmlog.Log('Receive:'+aSocket.PeerAddress+',msg:'+mensagem);
  if (mensagem <> '') then
  begin
      if (POS(mensagem, 'Fila:')>=0) then
      begin
        posicao := pos(':',mensagem);
        strnro := copy(mensagem,posicao+1,pos(#13,mensagem)-(posicao+1));
        nro := strtoint(strnro);
        guiche := copy(mensagem,pos('>',mensagem)+1,pos(';',mensagem)-pos('>',mensagem)-1);
        case nro of
            1: begin
              if (frmmenu.Lista1.Count>0) then
              begin
                  item := frmmenu.Lista1.Strings[0];
                  frmmenu.Lista1.Delete(0);
                  frmlog.Log('delete List1:'+item);
              end
              else
              begin
                item := '0';
              end;
            end;
            2: begin
              if (frmmenu.Lista2.Count>0) then
              begin
                  item := frmmenu.Lista2.Strings[0];
                  frmmenu.Lista2.Delete(0);
                  frmlog.Log('delete List2:'+item);
              end
               else
              begin
                  item := '0';
              end;
            end;
            3: begin
              if (frmmenu.Lista3.Count>0) then
              begin
                  item := frmmenu.Lista3.Strings[0];
                  frmmenu.Lista3.Delete(0);
                  frmlog.Log('delete List3:'+item);
              end
               else
              begin
                  item := '0';
              end;
            end;
        end;
        aSocket.SendMessage('Fila:'+inttostr(nro)+';'+Item+#13);  //Vou implementar aqui
        aSocket.Disconnect(true);
      end;
  end;


  aSocket.Disconnect(true);
  LTCPComponent1.CallAction();

end;

procedure Tfrmmain.LTCPComponent2Receive(aSocket: TLSocket);
var
  mensagem : string;
begin
  aSocket.GetMessage(mensagem);
  frmlog.Log('Receive:'+aSocket.PeerAddress+',msg:'+mensagem);
  aSocket.SendMessage('GUICHE>'+guiche+':'+item+';');
  sleep(200);
  aSocket.SendMessage('GRUPO>'+'1'+':'+edTipo1.text+';');
  sleep(200);
  aSocket.SendMessage('GRUPO>'+'2'+':'+edTipo2.text+';');
  sleep(200);
  aSocket.SendMessage('GRUPO>'+'3'+':'+edTipo3.text+';');
  aSocket.Disconnect(true);
  LTCPComponent2.CallAction();
end;

procedure Tfrmmain.edCont2Change(Sender: TObject);
begin

end;

procedure Tfrmmain.edCont3Change(Sender: TObject);
begin

end;

procedure Tfrmmain.edTipo1Change(Sender: TObject);
begin

end;

procedure Tfrmmain.FormCreate(Sender: TObject);
begin
  frmSplash := TfrmSplash.create(self);
  frmSplash.lbVersao.Caption := inttostr(intVersao) + '.' + inttostr(intRevisao);

  Fsetmain := TSetmain.create();
  self.left := Fsetmain.posx;
  self.top := fsetmain.posy;
  if  Fsetmain.splash then
  begin
    frmSplash.show();
  end;
  frmLog := Tfrmlog.create(self);
  frmRegistrar := TfrmRegistrar.Create(self);
  frmRegistrar.Identifica();
  Versao.Caption:= inttostr(intVersao) + '.' + inttostr(intRevisao);
  if  FSETMAIN.splash then
  begin
    Application.ProcessMessages;
    sleep(1000);
    Application.ProcessMessages;
    sleep(1000);
    Application.ProcessMessages;
    sleep(1000);
    Application.ProcessMessages;
    sleep(1000);
  end;
  Application.ProcessMessages;
  if  Fsetmain.splash then
  begin
   frmSplash.hide();
  end;
  if  Fsetmain.splash then
  begin
    Fsetmain.splash :=  not frmSplash.cbnotsplash.Checked;
  end;
  //frmLog.hide;


end;

procedure Tfrmmain.FormDestroy(Sender: TObject);
begin
  frmRegistrar.free();
  frmRegistrar := nil;
  SalvarContexto();
  Fsetmain.free();
end;

procedure Tfrmmain.SalvarContexto();
begin
      FSETMAIN.empresa := edEmpresa.text;
      FSETMAIN.Localizacao :=  edlocalizacao.text;
      FSETMAIN.Tipo1 :=  edTipo1.text;
      FSETMAIN.Tipo2 := edTipo2.text;
      FSETMAIN.Tipo3 := edTipo3.text;
      FSETMAIN.Contagem1 :=  strtoint(edCont1.text);
      FSETMAIN.Contagem2 := strtoint(edCont2.text);
      FSETMAIN.Contagem3 := strtoint( edCont3.text);
      FSETMAIN.posx := self.left;
      FSetMain.posy := self.top;
      FSetmain.painel:= edPainel.text;
      Fsetmain.tipoimp := cbTipoImp.ItemIndex;
      Fsetmain.EXEC:= cbIniciar.Checked;

      FSETMAIN.SalvaContexto();
end;

procedure Tfrmmain.ToggleBox1Click(Sender: TObject);
begin
     executar();
end;

procedure Tfrmmain.Executar();
begin
  hide;
  if(frmMenu = nil) then
  begin
    frmMenu := TfrmMenu.create(self);
    salvarContexto();
    Timer1.Enabled:=true;

    frmMenu.posFila1:= strtoint(edCont1.Text);
    frmMenu.posFila2:= strtoint(edCont2.Text);
    frmMenu.posFila3:= strtoint(edCont3.Text);
    frmMenu.empresa := edEmpresa.Text;
    frmMenu.localizacao:= edlocalizacao.text;
    frmMenu.BtFila1.Caption:= edTipo1.text;
    frmMenu.BtFila2.Caption:= edTipo2.text;
    frmMenu.BtFila3.Caption:= edTipo3.text;
    frmMenu.lbFILA1 := edTipo1.text;
    frmMenu.lbFILA2 := edTipo2.text;
    frmMenu.lbFILA3 := edTipo3.text;

    TrayIcon1.BalloonTitle:='FILA';
    TrayIcon1.Animate:=false;
    TrayIcon1.BalloonHint:= 'Programa Fila';
    TrayIcon1.Visible:=true;
    LTCPComponent1.Listen(PortGuiche);
    LTCPComponent2.Listen(PortPainel);
    frmmenu.show;
  end
  else
  begin
    Timer1.Enabled:=true;
    frmMenu.show();
  end;

end;

procedure Tfrmmain.ToggleBox1Change(Sender: TObject);
begin


end;

end.

