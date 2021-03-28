unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Menus,  lNetComponents, menu, lNet, log;

const
  Arquivo = 'cliente.cfg';
  PortGuiche = 8095;
  PortPainel = 8096;
type

  { Tfrmmain }

  Tfrmmain = class(TForm)
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
    Label1: TLabel;
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
    MenuItem3: TMenuItem;
    Versao: TLabel;
    lblocalizacao: TLabel;
    lbParams: TListBox;
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


  end;

var
  frmmain: Tfrmmain;

implementation

{$R *.lfm}

{ Tfrmmain }

procedure Tfrmmain.MenuItem1Click(Sender: TObject);
begin
  show;
end;

procedure Tfrmmain.MenuItem2Click(Sender: TObject);
begin
<<<<<<< HEAD
  Application.Terminate;
=======
  close;
>>>>>>> 8771412255176c8e466a3b3f7f8d466ae78c5763
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
begin
  Timer1.Enabled:=false;
  if FileExists(arquivo) then
  begin
      lbParams.Items.LoadFromFile(arquivo);
      edEmpresa.text:= lbParams.Items[0];
      edlocalizacao.text:= lbParams.Items[1];
      edTipo1.text:= lbParams.Items[2];
      edTipo2.text:= lbParams.Items[3];
      edTipo3.text:= lbParams.Items[4];
      edCont1.text:= lbParams.Items[5];
      edCont2.text:= lbParams.Items[6];
      edCont3.text:= lbParams.Items[7];

  end;

end;

procedure Tfrmmain.LTCPComponent1Connect(aSocket: TLSocket);
begin
  aSocket.SendMessage('Connected!');
  frmLog.log('Connected:'+aSocket.PeerAddress);
end;

procedure Tfrmmain.LTCPComponent1Receive(aSocket: TLSocket);
var
  mensagem : string;
  strnro : string;
  posicao : integer;
begin
   //Mensagem recebida padrao Fila:nro+#13
  aSocket.GetMessage(mensagem);
  frmlog.log('Receive:'+aSocket.PeerAddress+',msg:'+mensagem);
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
                  frmlog.log('delete List1:'+item);
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
                  frmlog.log('delete List2:'+item);
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
                  frmlog.log('delete List3:'+item);
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
  frmlog.log('Receive:'+aSocket.PeerAddress+',msg:'+mensagem);
  aSocket.SendMessage('GUICHE>'+guiche+':'+item+';');
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
  frmLog := TfrmLog.create(self);
  frmLog.hide;
end;

procedure Tfrmmain.SalvarContexto();
begin
      lbParams.Items.Clear;
      lbParams.Items.Add(edEmpresa.text);
      lbParams.Items.Add( edlocalizacao.text);
      lbParams.Items.Add(edTipo1.text);
      lbParams.Items.Add(edTipo2.text) ;
      lbParams.Items.Add(edTipo3.text);
      lbParams.Items.Add( edCont1.text);
      lbParams.Items.Add(edCont2.text);
      lbParams.Items.Add( edCont3.text);
      lbParams.Items.SaveToFile(arquivo);

end;

procedure Tfrmmain.ToggleBox1Click(Sender: TObject);
begin
  hide;

  Timer1.Enabled:=true;
  frmmenu.show;
  salvarContexto();
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

end;

procedure Tfrmmain.ToggleBox1Change(Sender: TObject);
begin


end;

end.

