unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Menus, ComCtrls, EditBtn, DataPortIP, rxfolderlister,
  lNetComponents, menu, lNet, log, splash, registro, setmain, IMP,
  toolsfalar;

const

  PortGuiche = 8095;
  PortPainel = 8096;
  intversao = 3;
  intrevisao = 10;
type

  { Tfrmmain }

  Tfrmmain = class(TForm)
    btReset: TButton;
    btLimpar: TButton;
    btSalvar: TButton;
    cbhab02: TCheckBox;
    cbhab03: TCheckBox;
    cbhab04: TCheckBox;
    cbhab05: TCheckBox;
    cbIniciar: TCheckBox;
    cbModeImp: TComboBox;
    cbTipoImp: TComboBox;
    cbhab01: TCheckBox;
    cbTipoPapel: TComboBox;
    ckPainelMaximizar: TCheckBox;
    ckPainelEsquerdo: TCheckBox;
    ckFala: TCheckBox;
    edAbrev02: TEdit;
    edAbrev03: TEdit;
    edAbrev04: TEdit;
    edAbrev05: TEdit;
    edCont1: TEdit;
    edCont2: TEdit;
    edCont3: TEdit;
    edCont4: TEdit;
    edCont5: TEdit;
    edEmpresa: TEdit;
    edRotuloTopo: TEdit;
    edlocalizacao: TEdit;
    edPainel: TEdit;
    edsrvfalar: TEdit;
    edPorta: TEdit;
    edTipo1: TEdit;
    edTipo2: TEdit;
    edTipo3: TEdit;
    edTipo4: TEdit;
    edTipo5: TEdit;
    edAbrev01: TEdit;
    Empresa: TLabel;
    fileimagem: TFileNameEdit;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    lblist01: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lblist2: TLabel;
    lblist3: TLabel;
    lblist4: TLabel;
    lblist5: TLabel;
    lblocalizacao: TLabel;
    lblocalizacao1: TLabel;
    Lista1: TListBox;
    Lista2: TListBox;
    Lista3: TListBox;
    Lista4: TListBox;
    Lista5: TListBox;
    LTCPComponent1: TLTCPComponent;
    LTCPComponent2: TLTCPComponent;
    Memo1: TMemo;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    PageControl1: TPageControl;
    Separator2: TMenuItem;
    Separator1: TMenuItem;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    tsMenuTickets: TTabSheet;
    tsAcessibilidade: TTabSheet;
    tbIniciar: TTabSheet;
    TabSheet5: TTabSheet;
    ToggleBox1: TToggleBox;
    TrayIcon1: TTrayIcon;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    PopupMenu1: TPopupMenu;
    Timer1: TTimer;
    Versao: TLabel;

    procedure btLimparClick(Sender: TObject);
    procedure btResetClick(Sender: TObject);
    procedure btSalvarClick(Sender: TObject);
    procedure cbIniciarChange(Sender: TObject);
    procedure edCont1Change(Sender: TObject);
    procedure edCont2Change(Sender: TObject);
    procedure edCont3Change(Sender: TObject);
    procedure edTipo1Change(Sender: TObject);
    procedure fileimagemChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Label10Click(Sender: TObject);
    procedure LTCPComponent1Connect(aSocket: TLSocket);
    procedure LTCPComponent1Receive(aSocket: TLSocket);
    procedure LTCPComponent2Receive(aSocket: TLSocket);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
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
    procedure Configurar();
    procedure carregalistagem();

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

procedure Tfrmmain.MenuItem4Click(Sender: TObject);
begin
     Configurar();
end;

procedure Tfrmmain.Timer1Timer(Sender: TObject);
begin
 edCont1.Text:= inttostr(frmMenu.posFila1);
 edCont2.Text:= inttostr(frmMenu.posFila2);
 edCont3.Text:= inttostr(frmMenu.posFila3);
 edCont4.Text:= inttostr(frmMenu.posFila4);
 edCont5.Text:= inttostr(frmMenu.posFila5);
 //SalvarContexto();
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
  edTipo4.text:= fsetmain.tipo4;
  edTipo5.text:= fsetmain.tipo5;
  edCont1.text:= inttostr(fsetmain.Contagem1);
  edCont2.text:= inttostr(fsetmain.Contagem2);
  edCont3.text:= inttostr(fsetmain.Contagem3);
  edCont4.text:= inttostr(fsetmain.Contagem4);
  edCont5.text:= inttostr(fsetmain.Contagem5);
  cbhab01.Checked:= FSETMAIN.habilita01;
  cbhab02.Checked:= FSETMAIN.habilita02;
  cbhab03.Checked:= FSETMAIN.habilita03;
  cbhab04.Checked:= FSETMAIN.habilita04;
  cbhab05.Checked:= FSETMAIN.habilita05;
  edPorta.text:= fsetmain.COMPORT;
  cbIniciar.Checked:= fsetmain.EXEC;
  cbTipoImp.ItemIndex:= integer(fsetmain.TipoIMP);
  cbModeImp.ItemIndex:= integer(fsetmain.ModeloImp);
  fileimagem.text := FSETMAIN.Imagem;

  edAbrev01.text :=  FSETMAIN.Abrev01;
  edAbrev02.text :=  FSETMAIN.Abrev02;
  edAbrev03.text :=  FSETMAIN.Abrev03;
  edAbrev04.text :=  FSETMAIN.Abrev04;
  edAbrev05.text :=  FSETMAIN.Abrev05;

  edsrvfalar.text := FSETMAIN.IPFALAR;
  ckFala.Checked:= FSETMAIN.Falar;
  cbTipoPapel.ItemIndex:= integer(FSETMAIN.TipoPapel);
  if(FSETMAIN.Imagem<>'') then
  begin
    Image2.Picture.LoadFromFile(FSETMAIN.Imagem);
  end;
  ckPainelMaximizar.Checked := FSETMAIN.PainelMaximizar;
  ckPainelEsquerdo.Checked := FSETMAIN.PainelEsquerdo;
  edRotuloTopo.text := FSETMAIN.RotuloTopo;

  frmSplash.hide;
  if (cbIniciar.Checked) then
  begin
    Executar();
  end;
end;

procedure Tfrmmain.Label10Click(Sender: TObject);
begin

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
              if (frmmain.Lista1.Count>0) then
              begin
                  item := frmmain.Lista1.Items.Strings[0];
                  frmmain.Lista1.items.Delete(0);
                  frmlog.Log('delete List1:'+item);
              end
              else
              begin
                item := '0';
              end;
            end;
            2: begin
              if (frmmain.Lista2.Count>0) then
              begin
                  item := frmmain.Lista2.items.Strings[0];
                  frmmain.Lista2.items.Delete(0);
                  frmlog.Log('delete List2:'+item);
              end
               else
              begin
                  item := '0';
              end;
            end;
            3: begin
              if (frmmain.Lista3.Count>0) then
              begin
                  item := frmmain.Lista3.items.Strings[0];
                  frmmain.Lista3.items.Delete(0);
                  frmlog.Log('delete List3:'+item);

              end
               else
              begin
                  item := '0';
              end;
            end;
            4: begin
              if (frmmain.Lista4.Count>0) then
              begin
                  item := frmmain.Lista4.items.Strings[0];
                  frmmain.Lista4.items.Delete(0);
                  frmlog.Log('delete List4:'+item);

              end
               else
              begin
                  item := '0';
              end;
            end;
            5: begin
              if (frmmain.Lista5.Count>0) then
              begin
                  item := frmmain.Lista5.items.Strings[0];
                  frmmain.Lista5.items.Delete(0);
                  frmlog.Log('delete List5:'+item);

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
  sleep(200);
  aSocket.SendMessage('GRUPO>'+'4'+':'+edTipo4.text+';');
  sleep(200);
  aSocket.SendMessage('GRUPO>'+'5'+':'+edTipo5.text+';');


  aSocket.Disconnect(true);
  LTCPComponent2.CallAction();
end;

procedure Tfrmmain.edCont2Change(Sender: TObject);
begin

end;

procedure Tfrmmain.edCont1Change(Sender: TObject);
begin

end;

procedure Tfrmmain.btResetClick(Sender: TObject);
begin
   edCont1.Text:= '0';
   edCont2.Text:= '0';
   edCont3.Text:= '0';
   edCont4.Text:= '0';
   edCont5.Text:= '0';
end;

procedure Tfrmmain.btSalvarClick(Sender: TObject);
begin
  SalvarContexto();
end;

procedure Tfrmmain.cbIniciarChange(Sender: TObject);
begin

end;

procedure Tfrmmain.btLimparClick(Sender: TObject);
begin
  Lista1.Items.clear;
  Lista2.Items.clear;
  Lista3.Items.clear;
  Lista4.Items.clear;
  Lista5.Items.clear;
end;

procedure Tfrmmain.edCont3Change(Sender: TObject);
begin

end;

procedure Tfrmmain.edTipo1Change(Sender: TObject);
begin

end;

procedure Tfrmmain.fileimagemChange(Sender: TObject);
begin
  if(fileimagem.text <>'') then
  begin
    if(FileExists(fileimagem.Text)) then
    begin
       FSETMAIN.Imagem:= fileimagem.Text;
    end
    else
    begin
         ShowMessage('Caminho inválido da imagem.');
    end;
  end;
end;

procedure Tfrmmain.FormCreate(Sender: TObject);
begin
  frmSplash := TfrmSplash.create(self);
  frmSplash.lbVersao.Caption := inttostr(intVersao) + '.' + inttostr(intRevisao);
  PageControl1.ActivePage := tbIniciar;
  frmToolsfalar := TfrmToolsfalar.create(self);

  Fsetmain := TSetmain.create();
  self.left := Fsetmain.posx;
  self.top := fsetmain.posy;
  carregalistagem();
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
  frmToolsfalar.free;
end;

procedure Tfrmmain.SalvarContexto();
begin
      FSETMAIN.empresa := edEmpresa.text;
      FSETMAIN.Localizacao :=  edlocalizacao.text;
      FSETMAIN.Tipo1 :=  edTipo1.text;
      FSETMAIN.Tipo2 := edTipo2.text;
      FSETMAIN.Tipo3 := edTipo3.text;
      FSETMAIN.Tipo4 := edTipo4.text;
      FSETMAIN.Tipo5 := edTipo5.text;
      FSETMAIN.Contagem1 :=  strtoint(edCont1.text);
      FSETMAIN.Contagem2 := strtoint(edCont2.text);
      FSETMAIN.Contagem3 := strtoint(edCont3.text);
      FSETMAIN.Contagem4 := strtoint(edCont4.text);
      FSETMAIN.Contagem5 := strtoint(edCont5.text);
      FSETMAIN.habilita01:= cbhab01.Checked;
      FSETMAIN.habilita02:= cbhab02.Checked;
      FSETMAIN.habilita03:= cbhab03.Checked;
      FSETMAIN.habilita04:= cbhab04.Checked;
      FSETMAIN.habilita05:= cbhab05.Checked;
      FSETMAIN.posx := self.left;
      FSetMain.posy := self.top;
      FSetmain.painel:= edPainel.text;
      Fsetmain.tipoimp := TTipoIMP(cbTipoImp.ItemIndex);
      Fsetmain.modeloimp := TModeloImpressora(cbModeImp.ItemIndex);
      FSetmain.COMPORT := edPorta.text;
      Fsetmain.EXEC:= cbIniciar.Checked;
      FSETMAIN.Imagem:= fileimagem.Text;
      FSETMAIN.TipoPapel:=  TPadraoPapel(cbTipoPapel.ItemIndex);

      FSETMAIN.Abrev01:= edAbrev01.text;
      FSETMAIN.Abrev02:= edAbrev02.text;
      FSETMAIN.Abrev03:= edAbrev03.text;
      FSETMAIN.Abrev04:= edAbrev04.text;
      FSETMAIN.Abrev05:= edAbrev05.text;


      FSETMAIN.Falar:= ckFala.Checked;
      FSETMAIN.IPFALAR := edsrvfalar.text;

      FSETMAIN.PainelMaximizar:=  ckPainelMaximizar.Checked;
      FSETMAIN.PainelEsquerdo:=  ckPainelEsquerdo.Checked;
      FSETMAIN.RotuloTopo:= edRotuloTopo.text;


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
    frmMenu.posFila4:= strtoint(edCont4.Text);
    frmMenu.posFila5:= strtoint(edCont5.Text);
    frmMenu.empresa := edEmpresa.Text;
    frmMenu.localizacao:= edlocalizacao.text;
    frmMenu.BtFila1.Caption:= edTipo1.text;
    frmMenu.BtFila2.Caption:= edTipo2.text;
    frmMenu.BtFila3.Caption:= edTipo3.text;
    frmMenu.BtFila4.Caption:= edTipo4.text;
    frmMenu.BtFila5.Caption:= edTipo5.text;
    frmMenu.BtFila1.Visible:= cbhab01.Checked;
    frmMenu.BtFila2.Visible:= cbhab02.Checked;
    frmMenu.BtFila3.Visible:= cbhab03.Checked;
    frmMenu.BtFila4.Visible:= cbhab04.Checked;
    frmMenu.BtFila5.Visible:= cbhab05.Checked;
    frmMenu.lbFILA1 := edTipo1.text;
    frmMenu.lbFILA2 := edTipo2.text;
    frmMenu.lbFILA3 := edTipo3.text;
    frmMenu.lbFILA4 := edTipo4.text;
    frmMenu.lbFILA5 := edTipo5.text;
    frmMenu.comport := edPorta.text;

    frmMenu.pnLeft.Visible := not FSETMAIN.PainelEsquerdo;
    //
    if FSETMAIN.PainelMaximizar then
    begin
      frmMenu.WindowState:= wsMaximized;
    end
     else
    begin
      frmMenu.WindowState:= wsNormal;
    end;
    frmMenu.lbRotulo.Caption:= FSETMAIN.RotuloTopo;



    frmToolsfalar.edIP.text := edsrvfalar.text;
    if(ckFala.Checked) then
    begin
        frmToolsfalar.Conectar();
    end;
    //frmMenu.FIMP.Tipoimp :=   TTipoImpressora(cbTipoImp.ItemIndex);
    frmMenu.FIMP.modeloimp := TModeloImpressora(cbModeImp.itemindex);
    //Verifica se existe caminho
    if (fileimagem.text<>'') then
    begin
         frmMenu.Image1.Picture.LoadFromFile(fileimagem.text);
    end;



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

procedure Tfrmmain.Configurar();
begin
  show;
  Application.ProcessMessages;
  if(frmMenu <> nil) then
  begin
    fsetmain.EXEC := false;
    FSETMAIN.SalvaContexto();
    Application.Terminate;

  end;
end;

procedure Tfrmmain.carregalistagem();
var
  diretorio: string;
  arq: string;
begin
  // Obtém o diretório temporário de forma automática
  diretorio := GetTempDir;

  // Remove a barra ou contrabarra no final, se houver
  if (diretorio <> '') and (diretorio[Length(diretorio)] in ['\', '/']) then
    Delete(diretorio, Length(diretorio), 1);

  // Lista de arquivos
  arq := diretorio + PathDelim + 'list01.txt';
  if FileExists(arq) then
    frmmain.lista1.Items.LoadFromFile(arq);

  arq := diretorio + PathDelim + 'list02.txt';
  if FileExists(arq) then
    frmmain.lista2.Items.LoadFromFile(arq);

  arq := diretorio + PathDelim + 'list03.txt';
  if FileExists(arq) then
    frmmain.lista3.Items.LoadFromFile(arq);

  arq := diretorio + PathDelim + 'list04.txt';
  if FileExists(arq) then
    frmmain.lista4.Items.LoadFromFile(arq);

  arq := diretorio + PathDelim + 'list05.txt';
  if FileExists(arq) then
    frmmain.lista5.Items.LoadFromFile(arq);
end;

procedure Tfrmmain.ToggleBox1Change(Sender: TObject);
begin


end;

end.

