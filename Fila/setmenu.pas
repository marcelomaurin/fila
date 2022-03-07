//Objetivo construir os parametros de setup da classe principal
//Criado por Marcelo Maurin Martins
//Data:18/08/2019

unit setmenu;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, funcoes;

const filename = 'menu.cfg';


type
  { TfrmMenu }

  { TSetMenu }

  TSetMenu = class(TObject)
    constructor create();
    destructor destroy();
  private
        arquivo :Tstringlist;
        ckdevice : boolean;
        FPosX : integer;
        FPosY : integer;
        FSplash : boolean;
        procedure Default();
        procedure SetPOSX(value : integer);
        procedure SetPOSY(value : integer);
        procedure SetDevice(const Value : Boolean);
        procedure SetSplash(value : boolean);

  public
        procedure SalvaContexto();
        Procedure CarregaContexto();
        property device : boolean read ckdevice write SetDevice;
        property posx : integer read FPosX write SetPOSX;
        property posy : integer read FPosY write SetPOSY;
        property splash : boolean read FSplash write SetSplash;
  end;

var
  Fsetmenu : TSetmenu;

implementation


procedure TSetMenu.SetPOSX(value : integer);
begin
    Fposx := value;
end;

procedure TSetMenu.SetPOSY(value : integer);
begin
    FposY := value;
end;


procedure TSetMenu.SetDevice(const Value : Boolean);
begin
  ckdevice := Value;
end;

procedure TSetMenu.SetSplash(value: boolean);
begin
  FSplash:= value;
end;


//Valores default do codigo
procedure TSetMenu.Default();
begin
    ckdevice := false;
end;

procedure TSetMenu.CarregaContexto();
var
  posicao: integer;
begin
    if  BuscaChave(arquivo,'DEVICE:',posicao) then
    begin
      device := (RetiraInfo(arquivo.Strings[posicao])='1');
    end;
    if  BuscaChave(arquivo,'POSX:',posicao) then
    begin
      FPOSX := strtoint(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'POSY:',posicao) then
    begin
      FPOSY := strtoint(RetiraInfo(arquivo.Strings[posicao]));
    end;




end;

//Metodo construtor
constructor TSetMenu.create();
begin
  arquivo := TStringList.create();
  if (FileExists(filename)) then
  begin
    arquivo.LoadFromFile(filename);
    CarregaContexto();
  end
  else
  begin
    default();
  end;
end;


procedure TSetMenu.SalvaContexto();
begin
  arquivo.Clear;
  arquivo.Append('DEVICE:'+iif(ckdevice,'1','0'));
  arquivo.Append('POSX:'+inttostr(FPOSX));
  arquivo.Append('POSY:'+inttostr(FPOSY));

  arquivo.SaveToFile(filename);
end;

destructor TSetMenu.destroy();
begin
  SalvaContexto();
  arquivo.free;
end;

end.


