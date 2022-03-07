//Objetivo construir os parametros de setup da classe principal
//Criado por Marcelo Maurin Martins
//Data:18/08/2019

unit setmain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, funcoes;

const filename = 'main.cfg';


type
  { TfrmMenu }

  { TSetssc }

  TSetMain = class(TObject)
    constructor create();
    destructor destroy();
  private
        arquivo :Tstringlist;
        ckdevice : boolean;
        FPATH : string;
        FPosX : integer;
        FPosY : integer;
        FHide : boolean;
        FEXEC : boolean;
        FCOM  : string;
        FBAUD : integer;
        FDTBIT : integer;
        FPARI : integer;
        FSTBIT : integer;

        procedure Default();
        procedure SetPOSX(value : integer);
        procedure SetPOSY(value : integer);
        procedure SetDevice(const Value : Boolean);
        procedure SetHide(value : boolean);
        procedure SetEXEC(value : boolean);
        procedure SetCOM(value : string);
        procedure SetBAUD(value : integer);
        procedure SetDTBIT(value : integer);
        procedure SetPARI(value : integer);
        procedure SetSTBIT(value : integer);

  public
        procedure SalvaContexto();
        Procedure CarregaContexto();
        property device : boolean read ckdevice write SetDevice;
        property posx : integer read FPosX write SetPOSX;
        property posy : integer read FPosY write SetPOSY;
        property Hide : boolean read FHide write SetHide;
        property EXEC : boolean read FEXEC write SetEXEC;
        property COMPORT : string read FCOM write SetCOM;
        property BAUDRATE :integer read FBAUD write SetBAUD;
        property DATABIT :integer read FDTBIT write SetDTBIT;
        property PARIDADE :integer read FPARI write SetPARI;
        property STOPBIT :integer read FSTBIT write SetSTBIT;
  end;

  var
    FSetssc : TSetssc;

implementation

procedure TSetssc.SetPOSX(value : integer);
begin
    Fposx := value;
end;

procedure TSetssc.SetPOSY(value : integer);
begin
    FposY := value;
end;


procedure TSetssc.SetDevice(const Value : Boolean);
begin
  ckdevice := Value;
end;

procedure TSetssc.SetHide(value : boolean);
begin
    FHide := value;
end;

procedure TSetssc.SetEXEC(value : boolean);
begin
    FEXEC := value;
end;

procedure TSetssc.SetCOM(value: string);
begin
  FCOM := value;
end;

procedure TSetssc.SetBAUD(value: integer);
begin
  FBAUD := value;
end;

procedure TSetssc.SetDTBIT(value: integer);
begin
  FDTBIT := value;
end;

procedure TSetssc.SetPARI(value: integer);
begin
  FPARI := value;
end;

procedure TSetssc.SetSTBIT(value: integer);
begin
  FSTBIT := value;
end;


//Valores default do codigo
procedure TSetssc.Default();
begin
    ckdevice := false;
    FEXEC := false;
    FHide:= false;
    {$IFDEF LINUX}
    FCOM := '/dev/ttyS0';
    {$ENDIF}
    {$IFDEF WINDOWS}
    FCOM :='COM13';
    {$ENDIF}
    FBAUD := 3; (* 2400 *)
    FDTBIT := 0; (* data bit 8 *)
    FPARI := 0;  (* Pari N *)
    FSTBIT := 0; (* STOP bit 1 *)
end;

procedure TSetssc.CarregaContexto();
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
    if  BuscaChave(arquivo,'HIDE:',posicao) then
    begin
      FHide := StrToBool(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'EXEC:',posicao) then
    begin
      FEXEC := strtoBool(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'COMPORT:',posicao) then
    begin
      FCOM := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'BAUDRATE:',posicao) then
    begin
      FBAUD := strtoint(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'DATABIT:',posicao) then
    begin
      FDTBIT := strtoint(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'PARIDADE:',posicao) then
    begin
      FPARI := strtoint(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'STOPBIT:',posicao) then
    begin
      FSTBIT := strtoint(RetiraInfo(arquivo.Strings[posicao]));
    end;
end;

//Metodo construtor
constructor TSetssc.create();
begin
  arquivo := TStringList.create();
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

  if (FileExists(fpath+filename)) then
  begin
    arquivo.LoadFromFile(fpath+filename);
    CarregaContexto();
  end
  else
  begin
    default();
  end;
end;


procedure TSetssc.SalvaContexto();
begin
  arquivo.Clear;
  arquivo.Append('DEVICE:'+iif(ckdevice,'1','0'));
  arquivo.Append('POSX:'+inttostr(FPOSX));
  arquivo.Append('POSY:'+inttostr(FPOSY));
  arquivo.Append('HIDE:'+booltostr(FHide));
  arquivo.Append('EXEC:'+booltostr(FEXEC));
  arquivo.Append('COMPORT:'+FCOM);
  arquivo.Append('BAUDRATE:'+ inttostr(FBAUD));
  arquivo.Append('DATABIT:'+ inttostr(FDTBIT));
  arquivo.Append('PARIDADE:'+ inttostr(FPARI));
  arquivo.Append('STOPBIT:'+ inttostr(FSTBIT));
  arquivo.SaveToFile(fpath+filename);
end;

destructor TSetssc.destroy();
begin
  SalvaContexto();
  arquivo.free;
end;

end.

