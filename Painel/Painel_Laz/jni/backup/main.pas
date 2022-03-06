{hint: Pascal files location: ...\teste7\jni }
unit main;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, analogclock, digitalclock,
  videoview, tcpsocketclient, udpsocket, mediaplayer, config;

Const
  PortPainel = 8096;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jBtClose: jButton;
    jDigitalClock1: jDigitalClock;
    jedIP: jEditText;
    jMediaPlayer1: jMediaPlayer;
    jPanel1: jPanel;
    jTCPSocketClient1: jTCPSocketClient;
    jTextView1: jTextView;
    jTextView2: jTextView;
    jTimer1: jTimer;
    lbMSG: jTextView;
    lbGrupo1: jTextView;
    lbGrupo3: jTextView;
    lbIGrupo1: jTextView;
    lbIGrupo2: jTextView;
    lbIGrupo3: jTextView;
    lbultimas: jTextView;
    lbGrupo2: jTextView;
    lbSenhaAtual: jTextView;
    txtSenhaAtual: jTextView;
    procedure AndroidModule1Create(Sender: TObject);
    procedure AndroidModule1Show(Sender: TObject);
    procedure jBtCloseClick(Sender: TObject);
    procedure jDigitalClock1Click(Sender: TObject);
    procedure jTCPSocketClient1Connected(Sender: TObject);
    procedure jTCPSocketClient1Disconnected(Sender: TObject);
    procedure jTCPSocketClient1MessagesReceived(Sender: TObject;
      messageReceived: string);
    procedure jTextView1Click(Sender: TObject);
    procedure jTimer1Timer(Sender: TObject);
    procedure arquivoSenhaAtual(info : string);
  private
    FIP : string;
    FPort : integer;
    FTimeout : integer;
    {private declarations}
    procedure ProcessaMSG(MSG: string);
    procedure TrataMSG(comando: string; info: string);
    procedure Beepando();
  public
    {public declarations}
  end;

var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}
  

{ TAndroidModule1 }

procedure TAndroidModule1.jTimer1Timer(Sender: TObject);
begin
    //lbMSG.Text:= DateTimeToStr(now);
    if not  jTCPSocketClient1.IsConnected() then
    begin
      if jTCPSocketClient1.ConnectAsyncTimeOut(FIP,FPort,FTimeout) then
      begin
          //lbMSG.Text:='Conectou!!!';
      end;
    end
    else
    begin
        jTCPSocketClient1.SendMessage('NOW:'+#13);
    end;
end;

procedure TAndroidModule1.AndroidModule1Show(Sender: TObject);
begin
  jTimer1.Enabled:=true;
end;

procedure TAndroidModule1.jBtCloseClick(Sender: TObject);
begin
  fip := jedip.text;
  jPanel1.Visible:=false;
end;

procedure TAndroidModule1.AndroidModule1Create(Sender: TObject);
begin
    FIP := '192.168.0.114';
    FPort:= PortPainel;
    FTimeout := 300;


end;

procedure TAndroidModule1.jDigitalClock1Click(Sender: TObject);
begin

end;



procedure TAndroidModule1.jTCPSocketClient1Connected(Sender: TObject);
begin
  lbMSG.Text:= 'conectado!';
end;

procedure TAndroidModule1.jTCPSocketClient1Disconnected(Sender: TObject);
begin
    //lbMSG.Text:= 'disconectado!';
end;

procedure TAndroidModule1.jTCPSocketClient1MessagesReceived(Sender: TObject;
  messageReceived: string);
begin
    //lbMSG.Text:= messageReceived;
    ProcessaMSG(messageReceived);
end;

procedure TAndroidModule1.jTextView1Click(Sender: TObject);
begin
  jPanel1.Visible:=true;
  jedip.Text:=FIP;
  lbMSG.Text:='chamou config';
end;

procedure TAndroidModule1.arquivoSenhaAtual(info : string);
begin
  if info.Chars[0] = 'A' then
  begin
    lbIGrupo1.Text := info;
  end;
  if info.Chars[0] = 'B' then
  begin
    lbIGrupo2.text := info;
  end;
  if info.Chars[0] = 'C' then
  begin
    lbIGrupo3.text := info;
  end;


end;

procedure TAndroidModule1.Beepando();
begin
  beep;
  //jMediaPlayer1.LoadFromFile('http://static.sfdict.com/dictstatic/dictionary/audio/luna/E03/','E0397400.mp3');
  jMediaPlayer1.SetDataSource('pipershut2.mp3');
  jMediaPlayer1.Start();
end;

procedure TAndroidModule1.TrataMSG(comando: string; info: string);
var
  guiche: string;
  Codigo : string;
  posicaomaior : integer;
  posicaodoispontos: integer;
  posicaopontovirgula: integer;
begin
 if ('GUICHE' = comando) then
 begin
      posicaomaior := info.IndexOf('>');
      posicaodoispontos:= info.IndexOf(':');
      posicaopontovirgula:=info.IndexOf(';');
      if (posicaodoispontos  <> 0) and (posicaopontovirgula <> 0) then
      begin
           guiche := copy(info,posicaomaior+2,posicaodoispontos-(posicaomaior+1));
           codigo := copy(info,posicaodoispontos+2,posicaopontovirgula-(posicaodoispontos+1));
           //lbMSG.Text:= 'codigo:'+codigo;
           if (codigo <> txtSenhaAtual.text) then
           begin
                arquivoSenhaAtual(txtSenhaAtual.text);
                lbSenhaAtual.text := 'Guiche:'+guiche;
                txtSenhaAtual.text := codigo;
                Beepando;
           end;
      end
      else
      begin
        lbMSG.Text:= 'Erro';
      end;


 end;
 if ('GRUPO' = comando) then
 begin
      posicaomaior := info.IndexOf('>');
      posicaodoispontos:= info.IndexOf(':');
      posicaopontovirgula:=info.IndexOf(';');
      if (posicaodoispontos  <> 0) and (posicaopontovirgula <> 0) then
      begin
           guiche := copy(info,posicaomaior+2,posicaodoispontos-(posicaomaior+1));
           codigo := copy(info,posicaodoispontos+2,posicaopontovirgula-(posicaodoispontos+1));
           if guiche = '1' then
           begin
                lbGrupo1.Text:= codigo;
           end;
           if guiche = '2' then
           begin
                lbGrupo2.Text:= codigo;
           end;
           if guiche = '3' then
           begin
                lbGrupo3.Text:= codigo;
           end;
      end;
 end;
end;

procedure TAndroidModule1.ProcessaMSG(MSG: string);
var
  posicao : integer;
  comando: string;
  info : string;
begin
     posicao := msg.IndexOf('>');
     if (posicao > 0) then
     begin
          comando := Copy(msg,0,posicao);
          info := copy(msg,posicao+1,Length(msg));
          TrataMSG(comando,info);
     end
     else
     begin
       lbMSG.Text:='Mensagem inválida';
     end;

end;

end.
