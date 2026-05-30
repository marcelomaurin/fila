unit splash;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TfrmSplash }

  TfrmSplash = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    lbVersao: TLabel;
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  frmSplash: TfrmSplash;

implementation

{$R *.lfm}

procedure TfrmSplash.FormCreate(Sender: TObject);
var
  LSplashPath: string;
begin
  LSplashPath := ExtractFilePath(Application.ExeName) + 'imgs' + PathDelim + 'splash.png';
  if FileExists(LSplashPath) then
  begin
    try
      Image1.Picture.LoadFromFile(LSplashPath);
    except
      // Falha silenciosa caso o arquivo esteja corrompido
    end;
  end;
end;

end.

