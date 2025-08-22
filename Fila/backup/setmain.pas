//Objetivo construir os parametros de setup da classe principal
//Criado por Marcelo Maurin Martins
//Data:18/08/2019

unit setmain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, funcoes;

const filename = 'fila.cfg';


type
  { TfrmMenu }
    TPadraoPapel = (TP_58MM, TP_80MM);
    TTipoIMP = (TI_DRIVER, TI_SERIAL,  TI_BLUETOOTH);
    TFormat = (FLeft, FCenter, FRigth); (*Formatacao do Texto*)
    TTypeText = (TT_NORMAL, TT_DOUBLE ); (*Tipo do Texto*)
    TModeloImpressora = (TI_ELGINI9, TI_ELGINI7, TI_GENERICA58);
    TTIPOPROTOCOLO = (TP_APK, TP_DESKTOP);


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
        FTipo4: string;
        FTipo5: string;
        FContagem1: integer;
        FContagem2: integer;
        FContagem3: integer;
        FContagem4: integer;
        FContagem5: integer;
        FHabilita01 : boolean;
        FHabilita02 : boolean;
        FHabilita03 : boolean;
        FHabilita04 : boolean;
        FHabilita05 : boolean;
        FPainel : string;
        FSplash : boolean;

        FModeloImp : TModeloImpressora;
        FTipoProtocolo : TTIPOPROTOCOLO;
        FTipoIMP : TTipoIMP;
        FImagem : string;

        FAbrev01 : string;
        FAbrev02 : string;
        FAbrev03 : string;
        FAbrev04 : string;
        FAbrev05 : string;

        FFALAR : boolean;
        FIPFALAR : string;

        //Tipo Papel
        FTipoPapel : TPadraoPapel;

        FPainelMaximizar : boolean;
        FPainelEsquerdo : boolean;
        FRotuloTopo : String;
        FFonteSize : integer;


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
        procedure SetTipo4(value: string);
        procedure SetTipo5(value: string);
        procedure SetContagem1(value: integer);
        procedure SetContagem2(value: integer);
        procedure SetContagem3(value: integer);
        procedure SetContagem4(value: integer);
        procedure SetContagem5(value: integer);
        procedure SetPainel(value: string);
        procedure SetSplash(value:boolean);

        procedure SetModeloImp(value: TModeloImpressora);
        procedure SetTipoImp(value: TTipoIMP);

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
        property Tipo4 : string read FTipo4 write SetTipo4;
        property Tipo5 : string read FTipo5 write SetTipo5;
        property habilita01 : boolean read Fhabilita01 write Fhabilita01;
        property habilita02 : boolean read Fhabilita02 write Fhabilita02;
        property habilita03 : boolean read Fhabilita03 write Fhabilita03;
        property habilita04 : boolean read Fhabilita04 write Fhabilita04;
        property habilita05 : boolean read Fhabilita05 write Fhabilita05;
        property Contagem1 : integer read FContagem1 write SetContagem1;
        property Contagem2 : integer read FContagem2 write SetContagem2;
        property Contagem3 : integer read FContagem3 write SetContagem3;
        property Contagem4 : integer read FContagem4 write SetContagem4;
        property Contagem5 : integer read FContagem5 write SetContagem5;
        property Painel : string read FPainel write SetPainel;
        property Splash : boolean read FSplash write SetSplash;

        property ModeloImp : TModeloImpressora read FModeloImp write SetModeloImp;
        property TipoProtocolo : TTipoProtocolo read FTipoProtocolo write FTipoProtocolo;
        property TipoIMP: TTipoIMP read FTipoIMP write FTipoIMP;
        property Imagem : string read FImagem write FImagem;
        property TipoPapel : TPadraoPapel read FTipoPapel write FTipoPapel;
        property Falar : boolean read FFalar write FFalar;
        property IPFALAR : string read FIPFALAR write FIPFALAR;

        property Abrev01: string read FAbrev01 write FAbrev01;
        property Abrev02: string read FAbrev02 write FAbrev02;
        property Abrev03: string read FAbrev03 write FAbrev03;
        property Abrev04: string read FAbrev04 write FAbrev04;
        property Abrev05: string read FAbrev05 write FAbrev05;

        property PainelMaximizar : boolean read FPainelMaximizar write FPainelMaximizar;
        property PainelEsquerdo : boolean read FPainelEsquerdo write FPainelEsquerdo;
        property RotuloTopo : String read FRotuloTopo write FRotuloTopo;
        property FonteSize : integer read FFonteSize write FFonteSize;
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

procedure TSetMain.SetTipo4(value: string);
begin
  FTipo4:= value;
end;

procedure TSetMain.SetTipo5(value: string);
begin
  FTipo5:= value;
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

procedure TSetMain.SetContagem4(value: integer);
begin
  FContagem4 := value;
end;

procedure TSetMain.SetContagem5(value: integer);
begin
  FContagem5 := value;
end;

procedure TSetMain.SetPainel(value: string);
begin
 FPainel := value;
end;

procedure TSetMain.SetSplash(value: boolean);
begin
  FSplash := value;
end;


procedure TSetMain.SetModeloImp(value: TModeloImpressora);
begin
  FModeloImp:= value;
end;

procedure TSetMain.SetTipoImp(value: TTipoIMP);
begin
  FTipoIMP:= value;
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
    FTipo3 := 'Especial1';
    FTipo4 := 'Especia2';
    FTipo5 := 'Especia3';
    FHabilita01 := true;
    FHabilita02 := true;
    FHabilita03 := true;
    FHabilita04 := true;
    FHabilita05 := true;
    FContagem1 := 0;
    FContagem2 := 0;
    FContagem3 := 0;
    FContagem4 := 0;
    FContagem5 := 0;
    FPainel := '192.168.0.108';

    FModeloImp := TI_ELGINI9;
    FTipoIMP:= TI_DRIVER;
    FImagem := '';
    FTipoPapel:= TP_58MM;
    FTipoProtocolo:= TP_DESKTOP;

    FFALAR:= false;
    FIPFALAR:= '127.0.0.1';

    FAbrev01 := 'AB1';
    FAbrev02 := 'AB2';
    FAbrev03 := 'AB3';
    FAbrev04 := 'AB4';
    FAbrev05 := 'AB5';
    FFonteSize := 0;  //Default do sistema

    FRotuloTopo:= 'Click ou Pressione o botão para imprimir seu ticket';
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
    if  BuscaChave(arquivo,'TIPO4:',posicao) then
    begin
      FTIPO4 := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'TIPO5:',posicao) then
    begin
      FTIPO5 := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'HABILITA01:',posicao) then
    begin
      FHabilita01 := strtobool(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'HABILITA02:',posicao) then
    begin
      FHabilita02 := strtobool(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'HABILITA03:',posicao) then
    begin
      FHabilita03 := strtobool(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'HABILITA04:',posicao) then
    begin
      FHabilita04 := strtobool(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'HABILITA05:',posicao) then
    begin
      FHabilita05 := strtobool(RetiraInfo(arquivo.Strings[posicao]));
    end;

    if  BuscaChave(arquivo,'CONTAGEM1:',posicao) then
    begin
      FCONTAGEM1 := strtoint(RetiraInfo(arquivo.Strings[posicao]))+1;
    end;
    if  BuscaChave(arquivo,'CONTAGEM2:',posicao) then
    begin
      FCONTAGEM2 := strtoint(RetiraInfo(arquivo.Strings[posicao]))+1;
    end;
    if  BuscaChave(arquivo,'CONTAGEM3:',posicao) then
    begin
      FCONTAGEM3 := strtoint(RetiraInfo(arquivo.Strings[posicao]))+1;
    end;
    if  BuscaChave(arquivo,'CONTAGEM4:',posicao) then
    begin
      FCONTAGEM4 := strtoint(RetiraInfo(arquivo.Strings[posicao]))+1;
    end;
    if  BuscaChave(arquivo,'CONTAGEM5:',posicao) then
    begin
      FCONTAGEM5 := strtoint(RetiraInfo(arquivo.Strings[posicao]))+1;
    end;
    if  BuscaChave(arquivo,'IMAGEM:',posicao) then
    begin
      FIMAGEM := RetiraInfo(arquivo.Strings[posicao]);
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
      FTIPOIMP := TTipoIMP(strtoint(RetiraInfo(arquivo.Strings[posicao])));
    end;

    if  BuscaChave(arquivo,'MODELOIMP:',posicao) then
    begin
      FMODELOIMP := TModeloImpressora(strtoint(RetiraInfo(arquivo.Strings[posicao])));
    end;
    if  BuscaChave(arquivo,'TIPOPROTOCOLO:',posicao) then
    begin
      FTIPOPROTOCOLO := TTIPOPROTOCOLO(strtoint(RetiraInfo(arquivo.Strings[posicao])));
    end;
    if  BuscaChave(arquivo,'TIPOPAPEL:',posicao) then
    begin
      FTipoPapel := TPadraoPapel(strtoint(RetiraInfo(arquivo.Strings[posicao])));
    end;
    if  BuscaChave(arquivo,'FALAR:',posicao) then
    begin
      FFALAR := strtobool(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'IPFLR:',posicao) then
    begin
      FIPFALAR := RetiraInfo(arquivo.Strings[posicao]);
    end;

    if  BuscaChave(arquivo,'ABREV01:',posicao) then
    begin
      FAbrev01 := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'ABREV02:',posicao) then
    begin
      FAbrev02 := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'ABREV03:',posicao) then
    begin
      FAbrev03 := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'ABREV04:',posicao) then
    begin
      FAbrev04 := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'ABREV05:',posicao) then
    begin
      FAbrev05 := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'PAINELMAXIMIZAR:',posicao) then
    begin
      FPainelMaximizar := StrToBool(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'PAINELESQUERDO:',posicao) then
    begin
      FPainelEsquerdo := StrToBool(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'ROTULOTOPO:',posicao) then
    begin
      FRotuloTopo := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'FONTESIZE:',posicao) then
    begin
      FFONTESIZE := strtoint(RetiraInfo(arquivo.Strings[posicao]));
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
  arquivo.Append('TIPO4:'+ FTIPO4);
  arquivo.Append('TIPO5:'+ FTIPO5);
  arquivo.Append('IMAGEM:'+ FIMAGEM);
  arquivo.Append('HABILITA01:'+ BoolToStr(FHabilita01));
  arquivo.Append('HABILITA02:'+ BoolToStr(FHabilita02));
  arquivo.Append('HABILITA03:'+ BoolToStr(FHabilita03));
  arquivo.Append('HABILITA04:'+ BoolToStr(FHabilita04));
  arquivo.Append('HABILITA05:'+ BoolToStr(FHabilita05));
  arquivo.Append('CONTAGEM1:'+ inttostr(FCONTAGEM1));
  arquivo.Append('CONTAGEM2:'+ inttostr(FCONTAGEM2));
  arquivo.Append('CONTAGEM3:'+ inttostr(FCONTAGEM3));
  arquivo.Append('CONTAGEM4:'+ inttostr(FCONTAGEM4));
  arquivo.Append('CONTAGEM5:'+ inttostr(FCONTAGEM5));
  arquivo.Append('PAINEL:'+ FPAINEL);
  arquivo.Append('SPLASH:'+ booltostr(FSPLASH));
  arquivo.Append('TIPOIMP:'+ inttostr(integer(FTipoIMP)));
  arquivo.Append('TIPOPROTOCOLO:'+ inttostr(integer(FTipoProtocolo)));
  arquivo.Append('MODELOIMP:'+ inttostr(integer(FModeloImp)));
  arquivo.Append('TIPOPAPEL:'+ inttostr(Integer(FTipoPapel)));
  arquivo.Append('FALAR:'+ booltostr(FFALAR));
  arquivo.Append('IPFLR:'+ FIPFALAR);

  arquivo.Append('ABREV01:'+ FAbrev01);
  arquivo.Append('ABREV02:'+ FAbrev02);
  arquivo.Append('ABREV03:'+ FAbrev03);
  arquivo.Append('ABREV04:'+ FAbrev04);
  arquivo.Append('ABREV05:'+ FAbrev05);
  arquivo.Append('PAINELMAXIMIZAR:'+ booltostr(FPainelMaximizar));
  arquivo.Append('PAINELESQUERDO:'+ booltostr(FPainelEsquerdo));
  arquivo.Append('ROTULOTOPO:'+ FRotuloTopo);
  arquivo.Append('FONTESIZE:'+ inttostr(FFonteSize));



  arquivo.SaveToFile(fpath+filename);
end;

destructor TSetMain.destroy();
begin
  SalvaContexto();
  arquivo.free;
end;

end.

