unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  {$IFDEF WINDOWS}
  Windows, //TlHelp32,
  {$ENDIF}
  ExtCtrls, Menus, ComCtrls, EditBtn, Spin, DataPortIP, UniqueInstance,
  rxfolderlister, rxclock, RxTimeEdit, lNetComponents, menu, lNet, log, splash,
  registro, setmain, IMP, toolsfalar, DateUtils, hint, Process;

const
  PortGuiche = 8095;
  PortPainel = 8096;
  intversao = 4;
  intrevisao = 07;

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
    cbTipoProtocolo: TComboBox;
    cbTipoPapel: TComboBox;
    cbReset: TCheckBox;
    ckFlgAnalise: TCheckBox;
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
    edPathAnalise: TFileNameEdit;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
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
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    lbPlataforma: TLabel;
    lbversao: TLabel;
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
    Memo2: TMemo;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    PageControl1: TPageControl;
    edtime: TRxTimeEdit;
    Separator2: TMenuItem;
    Separator1: TMenuItem;
    seFonteSize: TSpinEdit;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    tsProgramacao: TTabSheet;
    tsSobre: TTabSheet;
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
    UniqueInstance1: TUniqueInstance;
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
    procedure UniqueInstance1OtherInstance(Sender: TObject;
      ParamCount: Integer; const Parameters: array of String);
  private
    guiche : string;
    nro : integer;
    item : string;
    procedure SobreProjeto();
  public
    procedure Executar();
    procedure Configurar();
    procedure carregalistagem();
    procedure salvalistagem();
    procedure resetnumeracao();
    procedure resetlistas();
    procedure RegistraEvento(NROGuiche: string; NroFILA : string; Tipo : integer);
  end;

var
  frmmain: Tfrmmain;

implementation

{$R *.lfm}

{ Tfrmmain }

{$IFDEF WINDOWS}
function GetCurrentPID: DWORD;
begin
  Result := GetCurrentProcessId;
end;

function GetExeNameLower: string;
begin
  Result := LowerCase(ExtractFileName(ParamStr(0)));
end;


{$ENDIF}

procedure Tfrmmain.salvalistagem();
var
  diretorio: string;
  arq: string;
begin
  //diretorio := GetTempDir;
  diretorio :=   GetAppConfigDir(false);
  if(DirectoryExists(diretorio))   then
  begin
    frmhint.MessageHint('Pasta '+ diretorio+ ' não encontrada');
    //CreateDir(GetTempDir);
    CreateDir(GetAppConfigDir(false));
    frmhint.MessageHint('Pasta '+ diretorio+ ' foi criada');
  end;
  if (diretorio <> '') and (diretorio[Length(diretorio)] in ['\', '/']) then
    Delete(diretorio, Length(diretorio), 1);

  arq := diretorio + PathDelim + 'list01.txt';
  frmmain.lista1.Items.SaveToFile(arq);

  arq := diretorio + PathDelim + 'list02.txt';
  frmmain.lista2.Items.SaveToFile(arq);

  arq := diretorio + PathDelim + 'list03.txt';
  frmmain.lista3.Items.SaveToFile(arq);

  arq := diretorio + PathDelim + 'list04.txt';
  frmmain.lista4.Items.SaveToFile(arq);

  arq := diretorio + PathDelim + 'list05.txt';
  frmmain.lista5.Items.SaveToFile(arq);
end;

procedure Tfrmmain.resetnumeracao();
begin
  edCont1.Text:= '0';
  if(frmMenu <> nil) then
  begin
    frmMenu.posFila1 := 0;
    frmMenu.posFila2 := 0;
    frmMenu.posFila3 := 0;
    frmMenu.posFila4 := 0;
    frmMenu.posFila5 := 0;
  end;
  edCont2.Text:= '0';
  edCont3.Text:= '0';
  edCont4.Text:= '0';
  edCont5.Text:= '0';
end;

procedure Tfrmmain.resetlistas();
begin
  Lista1.Items.clear;
  Lista2.Items.clear;
  Lista3.Items.clear;
  Lista4.Items.clear;
  Lista5.Items.clear;
end;

//Registra Evento associado
procedure Tfrmmain.RegistraEvento(NROGuiche: string; NroFila: string; Tipo: integer);
var
  ExecPath: string;
  P: TProcess;
begin
  ExecPath := Trim(FSETMAIN.PathAnalise);

  // validações básicas
  if ExecPath = '' then
  begin
    if Assigned(frmHint) then
      frmHint.MessageHint('PathAnalise não configurado. Defina o caminho do executável nas configurações.');
    Exit;
  end;

  if not FileExists(ExecPath) then
  begin
    if Assigned(frmHint) then
      frmHint.MessageHint('Executável não encontrado em: ' + ExecPath);
    if Assigned(frmLog) then
      frmLog.Log('RegistraEvento: arquivo não encontrado -> ' + ExecPath);
    Exit;
  end;

  P := TProcess.Create(nil);
  try
    P.Executable := ExecPath;

    // Passa parâmetros de forma segura (sem precisar concatenar/aspas)
    P.Parameters.Add(NROGuiche);
    P.Parameters.Add(NroFila);
    P.Parameters.Add(IntToStr(Tipo));

    // Não bloquear a UI; apenas dispara o processo
    {$IFDEF WINDOWS}
    P.Options := [poNoConsole];
    {$ELSE}
    P.Options := [];
    {$ENDIF}

    if Assigned(frmLog) then
      frmLog.Log(Format('RegistraEvento: executando "%s" [%s, %s, %d]',
        [ExecPath, NROGuiche, NroFila, Tipo]));

    P.Execute;

    // Se preferir aguardar terminar e checar ExitStatus, descomente:
    // P.Options := P.Options + [poWaitOnExit];
    // P.Execute;
    // if (P.ExitStatus <> 0) and Assigned(frmHint) then
    //   frmHint.MessageHint('O analisador retornou código: ' + IntToStr(P.ExitStatus));

  except
    on E: Exception do
    begin
      if Assigned(frmHint) then
        frmHint.MessageHint('Falha ao executar o analisador: ' + E.Message);
      if Assigned(frmLog) then
        frmLog.Log('RegistraEvento ERRO: ' + E.ClassName + ' - ' + E.Message);
    end;
  end;
  P.Free;
end;


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
  //Configurar();
  frmmenu.hide;
  frmmenu.Free;
  frmmenu := nil;
  FSETMAIN.EXEC:= false;
  FSETMAIN.SalvaContexto();
  cbIniciar.Checked := false;
  show;
end;

procedure Tfrmmain.Timer1Timer(Sender: TObject);
var
  HoraAlvo, AgoraTime, JanelaFimTime: TDateTime;
  S: string;
  Dispara: Boolean;
begin
  edCont1.Text := IntToStr(frmMenu.posFila1);
  edCont2.Text := IntToStr(frmMenu.posFila2);
  edCont3.Text := IntToStr(frmMenu.posFila3);
  edCont4.Text := IntToStr(frmMenu.posFila4);
  edCont5.Text := IntToStr(frmMenu.posFila5);

  if not FSETMAIN.Reset then Exit;

  S := Trim(FSETMAIN.Hora);
  if (S = '') or (not TryStrToTime(S, HoraAlvo)) then Exit;

  HoraAlvo      := Frac(HoraAlvo);
  AgoraTime     := Frac(Now);
  JanelaFimTime := Frac(IncMinute(Now, 5));

  if JanelaFimTime >= AgoraTime then
    Dispara := (CompareTime(HoraAlvo, AgoraTime)     >= 0) and
               (CompareTime(HoraAlvo, JanelaFimTime) <= 0)
  else
    Dispara := (CompareTime(HoraAlvo, AgoraTime)     >= 0) or
               (CompareTime(HoraAlvo, JanelaFimTime) <= 0);

  if Dispara then
  begin
    resetnumeracao();
    resetlistas();
    SalvarContexto();
  end;
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

  cbTipoProtocolo.ItemIndex:=integer(FSETMAIN.TipoProtocolo);
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

  seFonteSize.Value :=  FSETMAIN.FonteSize;
  cbReset.Checked:= FSETMAIN.Reset;
  edtime.Text:=FSETMAIN.Hora;

  ckFlgAnalise.Checked:= FSETMAIN.flgAnalise;
  edPathAnalise.text := FSETMAIN.PathAnalise;

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
  if(FSETMAIN.TipoProtocolo=TP_APK) then
  begin
    item := frmmain.Lista1.items.Strings[0];
    aSocket.SendMessage('Fila:'+inttostr(1)+';'+Item+#13);
    item := frmmain.Lista2.items.Strings[0];
    aSocket.SendMessage('Fila:'+inttostr(2)+';'+Item+#13);
    item := frmmain.Lista3.items.Strings[0];
    aSocket.SendMessage('Fila:'+inttostr(3)+';'+Item+#13);
  end
  else
  begin
  end;

  aSocket.Disconnect(true);
  LTCPComponent2.CallAction();
end;

procedure Tfrmmain.LTCPComponent1Receive(aSocket: TLSocket);
var
  mensagem : string;
  strnro : string;
  posicao : integer;
begin
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
            RegistraEvento(guiche, item, 2);    //Registra Chamada do ticket
            frmmain.Lista1.items.Delete(0);
            frmlog.Log('delete List1:'+item);
          end
          else item := '0';
        end;
        2: begin
          if (frmmain.Lista2.Count>0) then
          begin
            item := frmmain.Lista2.items.Strings[0];
            RegistraEvento(guiche, item, 2);    //Registra Chamada do ticket
            frmmain.Lista2.items.Delete(0);
            frmlog.Log('delete List2:'+item);
          end
          else item := '0';
        end;
        3: begin
          if (frmmain.Lista3.Count>0) then
          begin
            item := frmmain.Lista3.items.Strings[0];
            RegistraEvento(guiche, item, 2);    //Registra Chamada do ticket
            frmmain.Lista3.items.Delete(0);
            frmlog.Log('delete List3:'+item);
          end
          else item := '0';
        end;
        4: begin
          if (frmmain.Lista4.Count>0) then
          begin
            item := frmmain.Lista4.items.Strings[0];
            RegistraEvento(guiche, item, 2);    //Registra Chamada do ticket
            frmmain.Lista4.items.Delete(0);
            frmlog.Log('delete List4:'+item);
          end
          else item := '0';
        end;
        5: begin
          if (frmmain.Lista5.Count>0) then
          begin
            item := frmmain.Lista5.items.Strings[0];
            RegistraEvento(guiche, item, 2);    //Registra Chamada do ticket
            frmmain.Lista5.items.Delete(0);
            frmlog.Log('delete List5:'+item);
          end
          else item := '0';
        end;
      end;

      aSocket.SendMessage('Fila:'+inttostr(nro)+';'+Item+#13);
      aSocket.Disconnect(true);
    end;
  end;

  aSocket.Disconnect(true);
  LTCPComponent1.CallAction();
end;

procedure Tfrmmain.edCont2Change(Sender: TObject);
begin
end;

procedure Tfrmmain.edCont1Change(Sender: TObject);
begin
end;

procedure Tfrmmain.btResetClick(Sender: TObject);
begin
  resetnumeracao();
end;

procedure Tfrmmain.btSalvarClick(Sender: TObject);
begin
  SalvarContexto();
  salvalistagem();
end;

procedure Tfrmmain.cbIniciarChange(Sender: TObject);
begin
end;

procedure Tfrmmain.btLimparClick(Sender: TObject);
begin
  resetlistas();
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
      FSETMAIN.Imagem:= fileimagem.Text
    else
      ShowMessage('Caminho inválido da imagem.');
  end;
end;

procedure Tfrmmain.FormCreate(Sender: TObject);
begin
  UniqueInstance1.Enabled := True;
  //UniqueInstance1.Identifier := 'Fila'; // garante unicidade entre apps

  frmSplash := TfrmSplash.create(self);
  frmSplash.lbVersao.Caption := inttostr(intVersao) + '.' + inttostr(intRevisao);
  PageControl1.ActivePage := tbIniciar;
  frmToolsfalar := TfrmToolsfalar.create(self);

  frmhint := TfrmHint.create(self);

  Fsetmain := TSetmain.create();
  self.left := Fsetmain.posx;
  self.top := fsetmain.posy;
  carregalistagem();
  if  Fsetmain.splash then
    frmSplash.show();

  frmLog := Tfrmlog.create(self);
  frmRegistrar := TfrmRegistrar.Create(self);
  frmRegistrar.Identifica();
  Versao.Caption:= inttostr(intVersao) + '.' + inttostr(intRevisao);

  if  FSETMAIN.splash then
  begin
    Application.ProcessMessages; sleep(1000);
    Application.ProcessMessages; sleep(1000);
    Application.ProcessMessages; sleep(1000);
    Application.ProcessMessages; sleep(1000);
  end;

  Application.ProcessMessages;
  if  Fsetmain.splash then
    frmSplash.hide();

  if  Fsetmain.splash then
    Fsetmain.splash :=  not frmSplash.cbnotsplash.Checked;

  SobreProjeto();
end;

procedure Tfrmmain.FormDestroy(Sender: TObject);
begin
  SalvarContexto();
  frmRegistrar.free();
  frmRegistrar := nil;

  Fsetmain.free();
  frmHint.free;
  frmHint := nil;
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
  FSETMAIN.TipoProtocolo:= TTIPOPROTOCOLO(cbTipoProtocolo.ItemIndex);
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

  FSETMAIN.FonteSize:= seFonteSize.Value;
  FSETMAIN.Reset:= cbReset.Checked;
  FSETMAIN.Hora:= edtime.Text;

  FSETMAIN.flgAnalise := ckFlgAnalise.Checked;
  FSETMAIN.PathAnalise := edPathAnalise.text;

  FSETMAIN.SalvaContexto();
end;

procedure Tfrmmain.ToggleBox1Click(Sender: TObject);
begin
  executar();
end;

procedure Tfrmmain.UniqueInstance1OtherInstance(Sender: TObject;
  ParamCount: Integer; const Parameters: array of String);
var
  SelfPID, OtherPID: DWORD;
begin
  if(frmMenu=nil) then
  begin
    ShowMessage('Aplicação já esta rodando');
    Application.Terminate;
  end;
end;



procedure Tfrmmain.SobreProjeto();
var
  plataforma : string;
begin
  {$IFDEF WINDOWS}
    plataforma := 'Windows ';
  {$ENDIF}
  {$IFDEF LINUX}
    plataforma := 'Linux ';
  {$ENDIF}

  {$IFDEF CPU32}
    plataforma := plataforma + 'x86';
  {$ENDIF}
  {$IFDEF CPU64}
    plataforma := plataforma + 'x64';
  {$ENDIF}

  lbversao.Caption := IntToStr(intversao) + '.' + IntToStr(intrevisao);
  lbplataforma.Caption := plataforma;
end;

procedure Tfrmmain.Executar();
begin
  hide;
  if(frmMenu = nil) then
  begin
    UniqueInstance1.Enabled:= false;
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

    frmMenu.BtFila1.Font.Size :=  FSETMAIN.FonteSize;
    frmMenu.BtFila2.Font.Size :=  FSETMAIN.FonteSize;
    frmMenu.BtFila3.Font.Size :=  FSETMAIN.FonteSize;
    frmMenu.BtFila4.Font.Size :=  FSETMAIN.FonteSize;
    frmMenu.BtFila5.Font.Size :=  FSETMAIN.FonteSize;

    frmMenu.pnLeft.Visible := not FSETMAIN.PainelEsquerdo;

    if FSETMAIN.PainelMaximizar then
      frmMenu.WindowState:= wsMaximized
    else
      frmMenu.WindowState:= wsNormal;

    frmMenu.lbRotulo.Caption:= FSETMAIN.RotuloTopo;

    frmToolsfalar.edIP.text := edsrvfalar.text;
    if(ckFala.Checked) then
      frmToolsfalar.Conectar();

    frmMenu.FIMP.modeloimp := TModeloImpressora(cbModeImp.itemindex);

    if (fileimagem.text<>'') then
      frmMenu.Image1.Picture.LoadFromFile(fileimagem.text);

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
  //diretorio := GetTempDir;
  diretorio := GetAppConfigDir(false);
  if (diretorio <> '') and (diretorio[Length(diretorio)] in ['\', '/']) then
    Delete(diretorio, Length(diretorio), 1);

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

