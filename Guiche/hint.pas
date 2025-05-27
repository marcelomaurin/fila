unit hint;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  PopupNotifier,  Math;

type

  { TfrmHint }

  TfrmHint = class(TForm)

    PopupNotifier1: TPopupNotifier;
    Timer1: TTimer;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    x , y : integer;
    function getTimer : cardinal;
    procedure setTimer(AValue: cardinal);
    procedure FindBestPosition;
  public
    procedure MessageHint(info: string);

    property Time: cardinal read getTimer write setTimer;

  end;


var
  frmHint: TfrmHint;

implementation

{$R *.lfm}
uses main;

{ Função que percorre os componentes da aplicação e encontra a posição mais alta }
procedure TfrmHint.FindBestPosition;
var
  i: integer;
  lowestY: integer;
begin
  // Gera uma altura aleatória entre 100 e Screen.Height - altura do PopupNotifier
  // y := RandomRange(100, Screen.Height - PopupNotifier1.vNotifierForm.Height - 10);
  y := Screen.Height - Self.Height - 10;

   // Verifica se o PopupNotifier está bem posicionado na tela
   if y < 0 then
     y := 0;
end;

procedure TfrmHint.Timer1Timer(Sender: TObject);
begin
  hide();


  //free;
  //frmHint := nil;

end;

procedure TfrmHint.FormCreate(Sender: TObject);
begin
     PopupNotifier1.Title:='Atenção!';
     Application.ComponentCount;

     //y := Screen.Height;
     // Encontra a melhor posição para a notificação
     FindBestPosition;

     x := screen.Width;
     Timer1.Enabled:=false;
end;

procedure TfrmHint.FormShow(Sender: TObject);
begin


end;

function TfrmHint.getTimer: cardinal;
begin
  result := Timer1.interval;
end;

procedure TfrmHint.setTimer(AValue: cardinal);
begin
    Timer1.Interval:=avalue;
end;

procedure TfrmHint.MessageHint(info: string);

begin
     PopupNotifier1.Text:=info;
     PopupNotifier1.ShowAtPos(x,y);
     PopupNotifier1.Show;
     //sleep(2000);
     timer1.Interval:= 10000;
     Timer1.Enabled:=true;

end;


end.

