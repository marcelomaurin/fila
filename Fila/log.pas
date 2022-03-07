unit log;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Menus;

type

  { TfrmLog }

  TfrmLog = class(TForm)
    meLog: TMemo;
    MenuItem1: TMenuItem;
    PopupMenu1: TPopupMenu;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
  private

  public
    Procedure Log(info : string);
    Procedure Salvar();
    Procedure Carregar();

  end;

var
  frmLog: TfrmLog;

implementation

{$R *.lfm}

procedure TfrmLog.FormCreate(Sender: TObject);
begin
  Carregar();
end;

procedure TfrmLog.FormDestroy(Sender: TObject);
begin
  Salvar();
end;

procedure TfrmLog.MenuItem1Click(Sender: TObject);
begin
  meLog.clear;
end;

procedure TfrmLog.Log(info: string);
begin
  meLog.Lines.Append(info);
end;

procedure TfrmLog.Salvar();
var
  arquivo :string;
  FPath : String;
begin
  {$IFDEF LINUX}
      //Fpath :='/home/';
      //Fpath := GetUserDir()
      Fpath :=GetAppConfigDir(false);
      if not(FileExists(FPATH)) then
      begin
         createdir(fpath);
      end;
  {$ENDIF}
  {$IFDEF WINDOWS}
      Fpath :=GetAppConfigDir(false);
      if not(FileExists(FPATH)) then
      begin
         createdir(fpath);
      end;
  {$ENDIF}
  arquivo :=  fpath + 'fila.log';
  meLog.Lines.SaveToFile(arquivo);
end;

procedure TfrmLog.Carregar();
var
  Fpath : string;
  arquivo : string;
begin
  {$IFDEF LINUX}
      //Fpath :='/home/';
      //Fpath := GetUserDir()
      Fpath :=GetAppConfigDir(false);
      if not(FileExists(FPATH)) then
      begin
         createdir(fpath);
      end;
  {$ENDIF}
  {$IFDEF WINDOWS}
      Fpath :=GetAppConfigDir(false);
      if not(FileExists(FPATH)) then
      begin
         createdir(fpath);
      end;
  {$ENDIF}
  arquivo := fpath + 'fila.log';
  if (FileExists(arquivo)) then
  begin
    meLog.Lines.LoadFromFile(arquivo);
  end;

end;

end.

