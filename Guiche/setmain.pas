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

  arquivo.SaveToFile(fullname);
end;

destructor TSetMain.destroy();
begin
  SalvaContexto(true);
  arquivo.free;
  arquivo := nil;
end;

end.


