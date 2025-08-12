//Objetivo construir os parametros de setup da classe principal
//Criado por Marcelo Maurin Martins
//Data:07/02/2021

unit setmain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, funcoes;

const filename = 'guiche.cfg';


type
  { TfrmMenu }

  { TSetMain }

  TSetMain = class(TObject)
    constructor create();
    destructor destroy();
  private
        arquivo :Tstringlist;
        FTOP : integer;
        FLEFT : integer;
        FWIDTH : integer;
        FHEIGHT : integer;
        FPainel: boolean;
        FNROGUICHE : string;
        FIPFILA : String;
        FIPPAINEL : String;
        FLastFiles : String;
        FRotulo01 : string;
        FRotulo02 : string;
        FRotulo03 : string;
        FRotulo04 : string;
        FRotulo05 : string;
        FHabilitado01: boolean;
        FHabilitado02: boolean;
        FHabilitado03: boolean;
        FHabilitado04: boolean;
        FHabilitado05: boolean;

        //filename : String;
        procedure SetTOP(value : integer);
        procedure SetLEFT(value : integer);
        procedure SetWIDTH(value : integer);
        procedure SetHEIGHT(value : integer);
        procedure SetPainel(value : boolean);

        procedure SetIPPAINEL(value : string);
        procedure SetIPFILA(value : string);
        procedure SetNROGUICHE(value : string);
        procedure Default();
  public
        procedure SalvaContexto(flag : boolean);
        Procedure CarregaContexto();
        procedure IdentificaArquivo(Carrega : boolean);
        property TOP : integer read FTOP write SetTOP;
        property LEFT : integer read FLEFT write SetLEFT;
        property WIDTH : integer read FWIDTH write SetWIDTH;
        property HEIGHT : integer read FHEIGHT write SetHEIGHT;
        property NROGUICHE: string read FNROGUICHE write SetNROGUICHE;
        property IPFILA: string read FIPFILA write SetIPFILA;
        property IPPAINEL: string read FIPPAINEL write SetIPPAINEL;
        property PAINEL: boolean read FPAINEL write SetPAINEL;
        property Rotulo01 : string read FRotulo01 write FRotulo01;
        property Rotulo02 : string read FRotulo02 write FRotulo02;
        property Rotulo03 : string read FRotulo03 write FRotulo03;
        property Rotulo04 : string read FRotulo04 write FRotulo04;
        property Rotulo05 : string read FRotulo05 write FRotulo05;
        property Habilitado01 : boolean read FHabilitado01 write FHabilitado01;
        property Habilitado02 : boolean read FHabilitado02 write FHabilitado02;
        property Habilitado03 : boolean read FHabilitado03 write FHabilitado03;
        property Habilitado04 : boolean read FHabilitado04 write FHabilitado04;
        property Habilitado05 : boolean read FHabilitado05 write FHabilitado05;
  end;

  var
    FSetMain : TSetMain;


implementation




//Valores default do codigo
procedure TSetMain.Default();
begin
   FTOP :=  96;
   FWIDTH:= 282;
   FHEIGHT:= 782;
   FLEFT:= 1617;
   FNROGUICHE:='1';
   FIPFILA:='127.0.0.1';
   FIPPAINEL:='127.0.0.1';
   FPainel := true;
   FRotulo01 := 'Tipo01';
   FRotulo02 := 'Tipo02';
   FRotulo03 := 'Tipo03';
   FRotulo04 := 'Tipo04';
   FRotulo05 := 'Tipo05';
   FHabilitado01 := true;
   FHabilitado02 := true;
   FHabilitado03 := true;
   FHabilitado04 := true;
   FHabilitado05 := true;
end;

procedure TSetMain.SetLEFT(value: integer);
begin
    FLEFT := value;
end;

procedure TSetMain.SetTOP(value: integer);
begin
    FTOP := value;
end;

procedure TSetMain.SetHEIGHT(value: integer);
begin
    FHEIGHT := value;
end;

procedure TSetMain.SetPainel(value: boolean);
begin
  FPainel := value;
end;

procedure TSetMain.SetWIDTH(value: integer);
begin
    FWIDTH := value;
end;


procedure TSetMain.SetNROGUICHE(value: string);
begin
  FNROGUICHE:= value;
end;


procedure TSetMain.SetIPFILA(value: string);
begin
  FIPFILA:= value;
end;


procedure TSetMain.SetIPPAINEL(value: string);
begin
  FIPPAINEL:= value;
end;

procedure TSetMain.CarregaContexto();
var
  posicao: integer;
begin
    if  BuscaChave(arquivo,'TOP:',posicao) then
    begin
      FTOP := strtoint(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'LEFT:',posicao) then
    begin
      FLEFT := strtoint(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'WIDTH:',posicao) then
    begin
      FWIDTH := strtoint(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'HEIGHT:',posicao) then
    begin
      FHEIGHT := strtoint(RetiraInfo(arquivo.Strings[posicao]));
    end;

    if  BuscaChave(arquivo,'NROGUICHE:',posicao) then
    begin
      FNROGUICHE := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'IPPAINEL:',posicao) then
    begin
      FIPPAINEL := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'IPFILA:',posicao) then
    begin
      FIPFILA := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'CKPAINEL:',posicao) then
    begin
      FPAINEL := iif(RetiraInfo(arquivo.Strings[posicao])='TRUE',TRUE,FALSE);
    end;
    if  BuscaChave(arquivo,'ROTULO01:',posicao) then
    begin
      FRotulo01 := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'ROTULO02:',posicao) then
    begin
      FRotulo02 := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'ROTULO03:',posicao) then
    begin
      FRotulo03 := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'ROTULO04:',posicao) then
    begin
      FRotulo04 := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'ROTULO05:',posicao) then
    begin
      FRotulo05 := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'HABILITADO01:',posicao) then
    begin
      FHABILITADO01 := StrToBool(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'HABILITADO02:',posicao) then
    begin
      FHABILITADO02 := StrToBool(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'HABILITADO03:',posicao) then
    begin
      FHABILITADO03 := StrToBool(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'HABILITADO04:',posicao) then
    begin
      FHABILITADO04 := StrToBool(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'HABILITADO05:',posicao) then
    begin
      FHABILITADO05 := StrToBool(RetiraInfo(arquivo.Strings[posicao]));
    end;
end;


procedure TSetMain.IdentificaArquivo(Carrega: boolean);
var
  fullname : string;
begin
  fullname := SysUtils.GetEnvironmentVariable('APPDATA')+'\' + filename;
  if (FileExists(fullname)) then
  begin
    arquivo.LoadFromFile(fullname);
    CarregaContexto();
  end
  else
  begin
    default();
    SalvaContexto(false);
  end;

end;

//Metodo construtor
constructor TSetMain.create();
begin
    arquivo := TStringList.create();
    IdentificaArquivo(true);

end;


procedure TSetMain.SalvaContexto(flag: boolean);
var
  fullname : string;
begin
  fullname := SysUtils.GetEnvironmentVariable('APPDATA')+'\' + filename;
  if (flag) then
  begin
    IdentificaArquivo(false);
  end;
  arquivo.Clear;
  arquivo.Append('LEFT:'+inttostr(FLEFT));
  arquivo.Append('TOP:'+inttostr(FTOP));
  arquivo.Append('WIDTH:'+inttostr(FWIDTH));
  arquivo.Append('HEIGHT:'+inttostr(FHEIGHT));
  arquivo.Append('NROGUICHE:'+FNROGUICHE);
  arquivo.Append('IPFILA:'+FIPFILA);
  arquivo.Append('IPPAINEL:'+FIPPAINEL);
  arquivo.Append('CKPAINEL:'+iif(FPAINEL=true,'TRUE','FALSE'));
  arquivo.Append('ROTULO01:'+FROTULO01);
  arquivo.Append('ROTULO02:'+FROTULO02);
  arquivo.Append('ROTULO03:'+FROTULO03);
  arquivo.Append('ROTULO04:'+FROTULO04);
  arquivo.Append('ROTULO05:'+FROTULO05);
  arquivo.Append('HABILITADO01:'+iif(FHABILITADO01=true,'TRUE','FALSE'));
  arquivo.Append('HABILITADO02:'+iif(FHABILITADO02=true,'TRUE','FALSE'));
  arquivo.Append('HABILITADO03:'+iif(FHABILITADO03=true,'TRUE','FALSE'));
  arquivo.Append('HABILITADO04:'+iif(FHABILITADO04=true,'TRUE','FALSE'));
  arquivo.Append('HABILITADO05:'+iif(FHABILITADO05=true,'TRUE','FALSE'));
  arquivo.SaveToFile(fullname);
end;

destructor TSetMain.destroy();
begin
  SalvaContexto(true);
  arquivo.free;
  arquivo := nil;
end;

end.


