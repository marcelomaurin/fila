unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Menus, ComCtrls, PopupNotifier, Buttons, lNetComponents, lNet,
  setmain, setup, splash, registro, log, hint, uFilaProtocol;

const Versao = '1.28';

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
    FPendingLifecycle: string;
    FPendingLifecycleAction: string;
    FPendingLifecycleTicket: string;
    FCurrentLifecycleState: string;
    FLifecyclePanel: TPanel;
    btIniciarAtendimento: TButton;
    btFinalizarAtendimento: TButton;
    btAusenteAtendimento: TButton;
    btCancelarAtendimento: TButton;

    lista : TStringList;
    Mudou : boolean;
    FPendenteChamada : Integer;
    procedure CarregaContexto();
    procedure EnviaPainel(AComponente: TLTCPComponent; const AIP, ASenha: string; AGuiche: Integer);
    function GetGuicheNro: Integer;
    function CurrentTicket: string;
    procedure CreateLifecycleControls;
    procedure UpdateLifecycleControls;
    procedure SendLifecycle(const AAction, ADetails: string);
    procedure LifecycleStartClick(Sender: TObject);
    procedure LifecycleFinishClick(Sender: TObject);
    procedure LifecycleAbsentClick(Sender: TObject);
    procedure LifecycleCancelClick(Sender: TObject);
    procedure GravaLog(const AMsg: string);
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
  if (FsetMain.width >= 400) and (FsetMain.height >= 400) then
  begin
    self.width := FsetMain.width;
    self.Height := FSetMain.height;
  end
  else
  begin
    self.Width := 590;
    self.Height := 580;
  end;

  if (FsetMain.left >= 0) and (FsetMain.left + self.Width <= Screen.Width) and
     (FsetMain.top >= 0) and (FsetMain.top + self.Height <= Screen.Height) then
  begin
    self.Left := FsetMain.left;
    self.Top := FsetMain.top;
  end
  else
  begin
    self.Position := poScreenCenter;
  end;
end;

procedure Tfrmmain.Rechamar();
var
  LGuiche: Integer;
begin
  if FsetMain.PAINEL then
  begin
       if(lastcall<>'') then
       begin
         LGuiche := GetGuicheNro;
         painel1(lastcall, LGuiche);
         painel2(lastcall, LGuiche);
         painel3(lastcall, LGuiche);
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
  tnFila.ImageIndex:= 5;
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
  self.Caption := 'Guiche - ' + versao;
  lbVersao.Caption := versao;
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
  lista := TStringList.create;

  CadastraRaiz();

  FPendingLifecycle := '';
  FPendingLifecycleAction := '';
  FPendingLifecycleTicket := '';
  FCurrentLifecycleState := '';
  CreateLifecycleControls;
  UpdateLifecycleControls;
end;

procedure Tfrmmain.FormDestroy(Sender: TObject);
begin
  frmRegistrar.free();
  frmHint.Free;
end;

procedure Tfrmmain.FormShow(Sender: TObject);
begin
  if Assigned(frmSplash) then
    frmSplash.hide;
  TrayIcon1.Visible:=true;
end;

procedure Tfrmmain.LTCPComponent1Accept(aSocket: TLSocket);
begin
  conn := true;
end;

procedure Tfrmmain.LTCPComponent1Connect(aSocket: TLSocket);
var
  param : string;
begin
  GravaLog('Conectou Fila: ' + aSocket.LocalAddress);

  if FPendingLifecycle <> '' then
  begin
    LTCPComponent1.SendMessage(FPendingLifecycle, nil);
    FPendingLifecycle := '';
  end
  else if FPendenteChamada > 0 then
  begin
    param := EncodeCallRequest(FPendenteChamada, FSetMain.NROGUICHE);
    LTCPComponent1.SendMessage(param, nil);
    FPendenteChamada := 0;
  end;
end;

procedure Tfrmmain.LTCPComponent1Disconnect(aSocket: TLSocket);
begin
  aSocket.Disconnect(true);
  GravaLog('Desconectou Fila: ' + aSocket.LocalAddress);
  conn := false;
end;

procedure Tfrmmain.LTCPComponent1Error(const msg: string; aSocket: TLSocket);
begin
  GravaLog('Erro Fila: ' + msg);

  if FPendingLifecycleAction <> '' then
  begin
    FPendingLifecycle := '';
    FPendingLifecycleAction := '';
    FPendingLifecycleTicket := '';
    UpdateLifecycleControls;
    ShowMessage('Não foi possível concluir a operação de atendimento: ' + msg);
  end;
end;

procedure Tfrmmain.LTCPComponent1Receive(aSocket: TLSocket);
var
  info: string;
  strNro: string;
  QueueId: Integer;
  tvitem: TTreeNode;
  LGuiche: Integer;
  LifeOk: Boolean;
  LifeAction, LifeTicket: string;
begin
  aSocket.GetMessage(info);

  if TryParseLifecycleResponse(info, LifeOk, LifeAction, LifeTicket) then
  begin
    if LifeOk then
    begin
      GravaLog('Atendimento ' + LifeAction + ' confirmado para ' + LifeTicket);
      frmHint.MessageHint('Senha ' + LifeTicket + ': ' + LifeAction);

      if LifeAction = 'INICIAR' then
        FCurrentLifecycleState := 'EM_ATENDIMENTO'
      else if (LifeAction = 'FINALIZAR') or (LifeAction = 'AUSENTE') or
              (LifeAction = 'CANCELAR') then
      begin
        if SameText(lastcall, LifeTicket) then
          lastcall := '';
        FCurrentLifecycleState := '';
      end;
    end
    else
    begin
      GravaLog('Atendimento ' + LifeAction + ' recusado para ' + LifeTicket);
      ShowMessage('Operação não permitida para a senha ' + LifeTicket + '.');
    end;

    FPendingLifecycleAction := '';
    FPendingLifecycleTicket := '';
    UpdateLifecycleControls;
  end
  else if TryParseTicketResponse(info, QueueId, strNro) then
  begin
    if strNro <> '0' then
    begin
      lastcall := strNro;
      FCurrentLifecycleState := 'CHAMADA';

      if frmsetup.ckPainel.Checked then
      begin
        LGuiche := GetGuicheNro;
        Painel1(strNro, LGuiche);
        Painel2(strNro, LGuiche);
        Painel3(strNro, LGuiche);
      end;

      frmHint.MessageHint('Senha:' + strNro);
      if Assigned(frmLog) then
        frmLog.meLog.Append(strNro + ' - ' + TimeToStr(Now));

      tvitem := tvFila.Items.AddChild(tnFila, strNro);
      tvitem.ImageIndex := 9;
      tvFila.Selected := tvitem;
      tnsel := tvitem;
      UpdateLifecycleControls;
    end
    else
      ShowMessage('Fila Vazia');
  end
  else
    GravaLog('Resposta invalida recebida do Fila: ' + info);

  btrechamar3.Enabled := True;
  Cursor := crDefault;
  aSocket.Disconnect(True);
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
  UpdateLifecycleControls;
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
   PageControl1.ActivePage  :=  tsFila;
   FPendenteChamada := nro;
   
   if LTCPComponent1.Connected then
   begin
     param := EncodeCallRequest(nro, FSetMain.NROGUICHE);
     LTCPComponent1.SendMessage(param, nil);
     FPendenteChamada := 0; // Limpa a pendência
     tvFila.AutoExpand:= true;
   end
   else
   begin
     Cursor:= crHourGlass;
     btrechamar3.Enabled:= false;
     LTCPComponent1.Connect(FSetMain.IPFILA, FILA_PORT_GUICHE);
   end;
end;

procedure Tfrmmain.EnviaPainel(AComponente: TLTCPComponent; const AIP, ASenha: string; AGuiche: Integer);
var
  param : string;
begin
  if (AIP <> '') and (AComponente <> nil) then
  begin
    if not AComponente.Connected then
    begin
      AComponente.Connect(AIP, FILA_PORT_PAINEL);
      sleep(100); // Intervalo curto seguro para buffer assíncrono
      Application.ProcessMessages;
    end;

    param := EncodePanelCall(ASenha, AGuiche, FSetMain.PROTOCOLO);

    AComponente.SendMessage(param, nil);
    GravaLog('Guiche:' + inttostr(AGuiche) + ' enviou ao painel (' + AIP + '): ' + ASenha);
  end;
end;

procedure Tfrmmain.Painel1(nro: string; guiche: integer);
begin
  EnviaPainel(LTCPComponent2, FsetMain.IPPAINEL1, nro, guiche);
end;

procedure Tfrmmain.Painel2(nro: string; guiche: integer);
begin
  EnviaPainel(LTCPComponent3, FsetMain.IPPAINEL2, nro, guiche);
end;

procedure Tfrmmain.Painel3(nro: string; guiche: integer);
begin
  EnviaPainel(LTCPComponent4, FsetMain.IPPAINEL3, nro, guiche);
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
var
  LGuiche: Integer;
begin
 
   if (tnsel <> nil)then
   begin
        if( tnsel.Text<>'') then
        begin
          LGuiche := GetGuicheNro;
          painel1( tnsel.Text, LGuiche);
          painel2( tnsel.Text, LGuiche);
          painel3( tnsel.Text, LGuiche);
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
var
  LGuiche: Integer;
begin
  if FsetMain.PAINEL then
  begin
       LGuiche := GetGuicheNro;
       painel1(lastcall, LGuiche);
       painel2(lastcall, LGuiche);
       painel3(lastcall, LGuiche);
       AtualizaBotoes();
  end;
  ShowMessage(lastcall);
end;



procedure Tfrmmain.btStart1Click(Sender: TObject);
begin

end;

function Tfrmmain.CurrentTicket: string;
begin
  // Ações de atendimento atuam apenas sobre a senha ativa do guichê.
  // A árvore permanece somente como histórico/rechamada.
  Result := Trim(lastcall);
end;

procedure Tfrmmain.CreateLifecycleControls;
begin
  FLifecyclePanel := TPanel.Create(Self);
  FLifecyclePanel.Parent := Self;
  FLifecyclePanel.Align := alBottom;
  FLifecyclePanel.Height := 52;
  FLifecyclePanel.BevelOuter := bvNone;

  btIniciarAtendimento := TButton.Create(Self);
  btIniciarAtendimento.Parent := FLifecyclePanel;
  btIniciarAtendimento.Caption := 'Iniciar atendimento';
  btIniciarAtendimento.Left := 8;
  btIniciarAtendimento.Top := 8;
  btIniciarAtendimento.Width := 145;
  btIniciarAtendimento.Height := 34;
  btIniciarAtendimento.OnClick := @LifecycleStartClick;

  btFinalizarAtendimento := TButton.Create(Self);
  btFinalizarAtendimento.Parent := FLifecyclePanel;
  btFinalizarAtendimento.Caption := 'Finalizar';
  btFinalizarAtendimento.Left := 161;
  btFinalizarAtendimento.Top := 8;
  btFinalizarAtendimento.Width := 110;
  btFinalizarAtendimento.Height := 34;
  btFinalizarAtendimento.OnClick := @LifecycleFinishClick;

  btAusenteAtendimento := TButton.Create(Self);
  btAusenteAtendimento.Parent := FLifecyclePanel;
  btAusenteAtendimento.Caption := 'Ausente';
  btAusenteAtendimento.Left := 279;
  btAusenteAtendimento.Top := 8;
  btAusenteAtendimento.Width := 100;
  btAusenteAtendimento.Height := 34;
  btAusenteAtendimento.OnClick := @LifecycleAbsentClick;

  btCancelarAtendimento := TButton.Create(Self);
  btCancelarAtendimento.Parent := FLifecyclePanel;
  btCancelarAtendimento.Caption := 'Cancelar';
  btCancelarAtendimento.Left := 387;
  btCancelarAtendimento.Top := 8;
  btCancelarAtendimento.Width := 100;
  btCancelarAtendimento.Height := 34;
  btCancelarAtendimento.OnClick := @LifecycleCancelClick;
end;

procedure Tfrmmain.UpdateLifecycleControls;
var
  HasTicket, Busy: Boolean;
begin
  HasTicket := CurrentTicket <> '';
  Busy := FPendingLifecycleAction <> '';

  if Assigned(btIniciarAtendimento) then
    btIniciarAtendimento.Enabled := HasTicket and
      SameText(FCurrentLifecycleState, 'CHAMADA') and not Busy;

  if Assigned(btFinalizarAtendimento) then
    btFinalizarAtendimento.Enabled := HasTicket and
      SameText(FCurrentLifecycleState, 'EM_ATENDIMENTO') and not Busy;

  if Assigned(btAusenteAtendimento) then
    btAusenteAtendimento.Enabled := HasTicket and
      ((SameText(FCurrentLifecycleState, 'CHAMADA')) or
       (SameText(FCurrentLifecycleState, 'EM_ATENDIMENTO'))) and not Busy;

  if Assigned(btCancelarAtendimento) then
    btCancelarAtendimento.Enabled := HasTicket and
      ((SameText(FCurrentLifecycleState, 'CHAMADA')) or
       (SameText(FCurrentLifecycleState, 'EM_ATENDIMENTO'))) and not Busy;
end;

procedure Tfrmmain.SendLifecycle(const AAction, ADetails: string);
var
  Ticket, Command: string;
begin
  Ticket := CurrentTicket;
  if Ticket = '' then
  begin
    ShowMessage('Selecione uma senha ou chame uma senha antes desta operação.');
    Exit;
  end;

  if FPendingLifecycleAction <> '' then
  begin
    ShowMessage('Existe uma operação de atendimento aguardando resposta.');
    Exit;
  end;

  FPendingLifecycleAction := UpperCase(Trim(AAction));
  FPendingLifecycleTicket := Ticket;
  Command := EncodeLifecycleCommand(FPendingLifecycleAction, Ticket,
    FSetMain.NROGUICHE, ADetails);
  UpdateLifecycleControls;

  if LTCPComponent1.Connected then
    LTCPComponent1.SendMessage(Command, nil)
  else
  begin
    FPendingLifecycle := Command;
    LTCPComponent1.Connect(FSetMain.IPFILA, FILA_PORT_GUICHE);
  end;
end;

procedure Tfrmmain.LifecycleStartClick(Sender: TObject);
begin
  SendLifecycle('INICIAR', '');
end;

procedure Tfrmmain.LifecycleFinishClick(Sender: TObject);
begin
  SendLifecycle('FINALIZAR', '');
end;

procedure Tfrmmain.LifecycleAbsentClick(Sender: TObject);
begin
  if CurrentTicket = '' then
  begin
    ShowMessage('Nenhuma senha selecionada.');
    Exit;
  end;

  if MessageDlg('Confirmar ausência da senha ' + CurrentTicket + '?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    SendLifecycle('AUSENTE', '');
end;

procedure Tfrmmain.LifecycleCancelClick(Sender: TObject);
var
  Reason: string;
begin
  if CurrentTicket = '' then
  begin
    ShowMessage('Nenhuma senha selecionada.');
    Exit;
  end;

  Reason := '';
  if InputQuery('Cancelar atendimento',
    'Informe o motivo do cancelamento da senha ' + CurrentTicket + ':', Reason) then
    SendLifecycle('CANCELAR', Trim(Reason));
end;

function Tfrmmain.GetGuicheNro: Integer;
var
  LNro: Integer;
begin
  if TryStrToInt(FSetMain.NROGUICHE, LNro) then
    Result := LNro
  else
    Result := 1; // Valor padrão seguro
end;

procedure Tfrmmain.GravaLog(const AMsg: string);
var
  LogFile: string;
  F: TextFile;
  LogDir: string;
begin
  // Adiciona no Memo visual limitando a 100 linhas para poupar memória RAM
  if frmLog <> nil then
  begin
    if frmLog.meLog.Lines.Count > 100 then
      frmLog.meLog.Lines.Delete(0);
    frmLog.meLog.Append(AMsg);
  end;

  // Grava em arquivo físico rotativo em disco
  LogDir := ExtractFilePath(Application.ExeName) + 'logs';
  if not DirectoryExists(LogDir) then
    CreateDir(LogDir);

  LogFile := LogDir + PathDelim + 'guiche_' + FormatDateTime('yyyy-mm-dd', Now) + '.log';
  AssignFile(F, LogFile);
  try
    if FileExists(LogFile) then
      Append(F)
    else
      Rewrite(F);
    Writeln(F, FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + ' - ' + AMsg);
  finally
    CloseFile(F);
  end;
end;

end.

