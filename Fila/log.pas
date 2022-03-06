unit log;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TfrmLog }

  TfrmLog = class(TForm)
    Memo1: TMemo;
  private

  public
    Procedure Log(info : string);

  end;

var
  frmLog: TfrmLog;

implementation

{$R *.lfm}

procedure TFrmLog.Log(info:string);
begin
  Memo1.Append(info);
end;

end.

