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

  { TSetmain }

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
        FEmpresa : string;
        FLocalizacao : string;
        FTipo1: string;
        FTipo2: string;
        FTipo3: string;
        FContagem1: integer;
        FContagem2: integer;
        FContagem3: integer;
        FPainel : string;
        FSplash : boolean;
        FTipoImp : integer;
        FModeloImp : integer;


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
        procedure SetEmpresa(value: string);
        procedure SetLocalizacao(value: string);
        procedure SetTipo1(value: string);
        procedure SetTipo2(value: string);
        procedure SetTipo3(value: string);
        procedure SetContagem1(value: integer);
        procedure SetContagem2(value: integer);
        procedure SetContagem3(value: integer);
        procedure SetPainel(value: string);
        procedure SetSplash(value:boolean);
        procedure SetTipoImp(value: integer);
        procedure SetModeloImp(value: integer);

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
        property Empresa : string read FEmpresa write SetEmpresa;
        property Localizacao : string read FLocalizacao write SetLocalizacao;
        property Tipo1 : string read FTipo1 write SetTipo1;
        property Tipo2 : string read FTipo2 write SetTipo2;
        property Tipo3 : string read FTipo3 write SetTipo3;
        property Contagem1 : integer read FContagem1 write SetContagem1;
        property Contagem2 : integer read FContagem2 write SetContagem2;
        property Contagem3 : integer read FContagem3 write SetContagem3;
        property Painel : string read FPainel write SetPainel;
        property Splash : boolean read FSplash write SetSplash;
        property TipoImp : integer read FTipoImp write SetTipoImp;
        property ModeloImp : integer read FModeloImp write SetModeloImp;
  end;

  var
    FSETMAIN : TSetmain;

implementation

procedure TSetMain.SetPOSX(value: integer);
begin
    Fposx := value;
end;

procedure TSetMain.SetPOSY(value: integer);
begin
    FposY := value;
end;


procedure TSetMain.SetDevice(const Value: Boolean);
begin
  ckdevice := Value;
end;

procedure TSetMain.SetHide(value: boolean);
begin
    FHide := value;
end;

procedure TSetMain.SetEXEC(value: boolean);
begin
    FEXEC := value;
end;

procedure TSetMain.SetCOM(value: string);
begin
  FCOM := value;
end;

procedure TSetMain.SetBAUD(value: integer);
begin
  FBAUD := value;
end;

procedure TSetMain.SetDTBIT(value: integer);
begin
  FDTBIT := value;
end;

procedure TSetMain.SetPARI(value: integer);
begin
  FPARI := value;
end;

procedure TSetMain.SetSTBIT(value: integer);
begin
  FSTBIT := value;
end;

procedure TSetMain.SetEmpresa(value: string);
begin
  FEmpresa:= value;
end;

procedure TSetMain.SetLocalizacao(value: string);
begin
 FLocalizacao:= value;
end;

procedure TSetMain.SetTipo1(value: string);
begin
 FTipo1:= value;
end;

procedure TSetMain.SetTipo2(value: string);
begin
 FTipo2 := value;
end;

procedure TSetMain.SetTipo3(value: string);
begin
 FTipo3:= value;
end;

procedure TSetMain.SetContagem1(value: integer);
begin
 FContagem1 := value;
end;

procedure TSetMain.SetContagem2(value: integer);
begin
 FContagem2 := value;
end;

procedure TSetMain.SetContagem3(value: integer);
begin
 FContagem3 := value;
end;

procedure TSetMain.SetPainel(value: string);
begin
 FPainel := value;
end;

procedure TSetMain.SetSplash(value: boolean);
begin
  FSplash := value;
end;

procedure TSetMain.SetTipoImp(value: integer);
begin
  FTipoImp := value;
end;

procedure TSetMain.SetModeloImp(value: integer);
begin
  FModeloImp:= value;
end;



//Valores default do codigo
procedure TSetMain.Default();
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
    FEmpresa := 'maurinsoft';
    FLocalizacao := 'nothing';
    FTipo1 := 'Normal';
    FTIpo2 := 'Idoso';
    FTipo3 := 'Especial';
    FContagem1 := 0;
    FContagem2 := 0;
    FContagem3 := 0;
    FPainel := '192.168.0.108';
    FTipoImp := 0;
    FModeloImp := 0;
end;

procedure TSetMain.CarregaContexto();
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
    if  BuscaChave(arquivo,'EMPRESA:',posicao) then
    begin
      FEMPRESA := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'LOCALIZACAO:',posicao) then
    begin
      FLOCALIZACAO := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'TIPO1:',posicao) then
    begin
      FTIPO1 := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'TIPO2:',posicao) then
    begin
      FTIPO2 := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'TIPO3:',posicao) then
    begin
      FTIPO3 := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'CONTAGEM1:',posicao) then
    begin
      FCONTAGEM1 := strtoint(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'CONTAGEM2:',posicao) then
    begin
      FCONTAGEM2 := strtoint(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'CONTAGEM3:',posicao) then
    begin
      FCONTAGEM3 := strtoint(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'PAINEL:',posicao) then
    begin
      FPAINEL := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'SPLASH:',posicao) then
    begin
      FSPLASH := strtobool(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'TIPOIMP:',posicao) then
    begin
      FTIPOIMP := strtoint(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'MODELOIMP:',posicao) then
    begin
      FMODELOIMP := strtoint(RetiraInfo(arquivo.Strings[posicao]));
    end;
end;

//Metodo construtor
constructor TSetMain.create();
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


procedure TSetMain.SalvaContexto();
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
  arquivo.Append('EMPRESA:'+ FEmpresa);
  arquivo.Append('LOCALIZACAO:'+ FLocalizacao);
  arquivo.Append('TIPO1:'+ FTIPO1);
  arquivo.Append('TIPO2:'+ FTIPO2);
  arquivo.Append('TIPO3:'+ FTIPO3);
  arquivo.Append('CONTAGEM1:'+ inttostr(FCONTAGEM1));
  arquivo.Append('CONTAGEM2:'+ inttostr(FCONTAGEM2));
  arquivo.Append('CONTAGEM3:'+ inttostr(FCONTAGEM3));
  arquivo.Append('PAINEL:'+ FPAINEL);
  arquivo.Append('SPLASH:'+ booltostr(FSPLASH));
  arquivo.Append('TIPOIMP:'+ inttostr(FTIPOIMP));
  arquivo.Append('MODELOIMP:'+ inttostr(FMODELOIMP));
  arquivo.SaveToFile(fpath+filename);
end;

destructor TSetMain.destroy();
begin
  SalvaContexto();
  arquivo.free;
end;

end.

