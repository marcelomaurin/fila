unit log;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TfrmLog }

  TfrmLog = class(TForm)
    meLog: TMemo;
    Panel1: TPanel;
  private

  public
    procedure RegistraLog(Info: string);

  end;

var
  frmLog: TfrmLog;

implementation

{$R *.lfm}

{ TfrmLog }

procedure TfrmLog.RegistraLog(Info: string);
var
  Arquivo : string;
begin
  meLog.Append(datetimetostr(now) +' - '+Info);
  arquivo := SysUtils.GetEnvironmentVariable('APPDATA')+'\' + 'logevents.log';
  meLog.Lines.SaveToFile(Arquivo);
end;

end.

