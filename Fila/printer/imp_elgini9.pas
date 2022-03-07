unit imp_ELGINI9;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, imp_generico;

type

 { TIMP_ELGINI9 }

 TIMP_ELGINI9 = class(TInterfacedObject,TIMP_GENERICO)
     FCOLUNA : integer;
     FSERIAL : String;

 private
     function getserial : string;
     procedure setserial(value : string);


 public
     constructor create();
     destructor destroy();

     function NewLine(): string;
     function InitPrint(): string;
     function LineText(Info : string): string;
     function beep(): string;
     function Negrito(): string;
     function Normal(): string;
     function Sublinhado(): string;
     function DoubleTexto(): string;
     function Guilhotina(): string;
     function AcionaGaveta(): string;
     function Barra2D(Info : string): string;
     function Barra1D(Info : string): string;
     function loadImagem(X,Y : integer;Info : String): string;
     function imprimeImagem(X,Y : integer): string;
     function Centralizado(): string;
     function PaginaM616(): string;
     function CorPg618(): string;
     function HabilitaArmazenaDados(): string;
     function Armazenadados( Info : string): string;
     function ImprimeQRCODEArmazenado(): string;
 published
     property Serial : String read getserial  write setserial;
end;

var
  IMPELGINI9: TIMP_ELGINI9;

implementation

{ TIMP_ELGINI9 }

function TIMP_ELGINI9.getserial: string;
begin

end;

procedure TIMP_ELGINI9.setserial(value: string);
begin

end;

constructor TIMP_ELGINI9.create();
begin
    FCOLUNA := 80;

end;

destructor TIMP_ELGINI9.destroy();
begin

end;

function TIMP_ELGINI9.NewLine(): string;
begin
   result := string(LF);
end;

function TIMP_ELGINI9.InitPrint(): string;
begin
  result := string(#$1B) + string(#$40);
end;

function TIMP_ELGINI9.LineText(Info: string): string;
begin
  result := Info+ String(FF)+ NewLine();
end;

function TIMP_ELGINI9.beep(): string;
begin
  result := String(ESC)+ String(#40)+String(#65)+String(#5)+String(#0)+ String(#97)+String(#100)+String(#1)+String(#100)+String(#100);
end;

function TIMP_ELGINI9.Negrito(): string;
begin
  result := String(ESC)+ String(#69)+String(#255);
end;

function TIMP_ELGINI9.Normal(): string;
begin
  result := String(ESC)+ String(#69)+String(#0) +
          String(ESC)+ String(#45)+ String(#0)+
          String(#$1D)+String(#$21)+string(#0);
end;

function TIMP_ELGINI9.Sublinhado(): string;
begin
  result := String(ESC)+ String(#45)+ String(#50);
end;

function TIMP_ELGINI9.DoubleTexto(): string;
begin
  result := String(#$1D)+String(#$21)+string(#17);
end;

function TIMP_ELGINI9.Guilhotina(): string;
begin
  result := String(#29)+ String(#86)+ string(#66)+ string(#3);
end;

function TIMP_ELGINI9.AcionaGaveta(): string;
begin
  result := String(#16)+ String(#20)+ string(#1)+ string(#0)+string(#8);
end;

function TIMP_ELGINI9.Barra2D(Info: string): string;
var
  testeqr : string;
  tamanho : integer;
  lsb, msb : char;
  bmsb : shortint;
begin
  (*
  testeqr := 'mjBNoBoQVihMwTzUA+IBlgU12si36ipyVC2L+W5PhCvvqx1xVF/moy4wIzGTfWYpqsMa0641ZBFJFWnWIo78YBBE4m2GwGen84VTPz9iwvs4QkAQdijCiX6TA3wWSjIdiYhqyDroH0IBGnIOWug8ModehDreQFyDdnvAUVItszFVKW12/1JFhu9nxneAAKlJYecY46W3LcOOQSvt1yOcJzM74l+BsmlcYZZVi4I1mEazoj7YzG3Rx64444444';
  tamanho := length(testeqr)+3;
  if (tamanho>=256) then
  begin
   tamI = tamanho-256;
   tamF = tamanho/256;
  end
   else
  begin
   tamI = tamanho;
   tamF = 0;
  end;

  result := String(#$1D)+ String(#$28)+String(#$6B)+String(#$03)+
            String(#$00)+String(#$31)+String(#$43)+
            String(#$06)+ (*QRSIZE*)
            String(#$1D)+String(#$28)+String(#$6B)+
            String(lsb)+String(msb)+
            String(#$31)+String(#$50)+String(#$30)+
            info+
            String(#$1D)+String(#$28)+String(#$6B)+String(#$03)+String(#$00)+
            String(#$31)+String(#$51)+String(#$30);
  *)
  result := '';
end;

function TIMP_ELGINI9.Barra1D(Info: string): string;
begin
  result := (*String(#29)+String(#72)+String(#2)+ (*Legenda*)
            String(#29)+String(#76)+String(#10)+String(#0)+String(#10)+String(#0)+
            String(#29)+String(#104)+String(#162)+*)
            String(#29)+String(#107)+String(char(#4))+Info + String(#0)
  ;
end;

function TIMP_ELGINI9.loadImagem(X,Y : integer; Info: String): string;
var
  ret : string;
begin
  ret := string(#29)+String(#40)+String(#76)+String(char(X))+String(char(Y))+String(#48)+
            String(#67)+String(#48)+String(#100)+String(#100)+String(#1)+
            String(#100)+String(#100)+String(#10)+String(#10)+String(#10) +
            info + String(#1);


  result := ret;
end;

function TIMP_ELGINI9.imprimeImagem(X,Y : integer): string;
begin
     result := string(#29)+ String(#40)+String(#76)+String(char(X))+String(char(Y))+
            String(#48)+String(#69)+String(#100)+String(#100)+String(char(x))+String(char(y));
end;

function TIMP_ELGINI9.Centralizado(): string;
begin
     result :=  string(#27) + string(#97)+ string(#49);
end;

function TIMP_ELGINI9.PaginaM616(): string;
begin
  result := string(#29)+ string(#40)+ string(#107) + string(#3) + string(#0) + string(#49) + string(#67)+
         String(#4);
end;

function TIMP_ELGINI9.CorPg618(): string;
begin
   result := string(#29) + string(#40) + string(#107) + String(#3) + string(#0) +
          string(#49) + string(#69) + string(#48);
end;

function TIMP_ELGINI9.HabilitaArmazenaDados(): string;
begin
  result := string(#29) + string(#40) + string(#107);
end;

function TIMP_ELGINI9.Armazenadados(Info: string): string;
var
  tamanho : integer;
  tamI: integer;
  tamF: integer;
begin
  tamanho := length(Info)+3;
  if (tamanho>=256) then
  begin
    tamI := integer(tamanho-256);
    tamF := integer(tamanho div 256);
  end
  else
  begin
    tamI := tamanho;
    tamF := 0;
  end;
  result :=  string(chr(tamI)) + string(char(tamF)) + string(#49) + string(#80) +
     string(#48)+info;
end;

function TIMP_ELGINI9.ImprimeQRCODEArmazenado(): string;
begin
  result :=  string(#29) + string(#40) + string(#107) + String(#3) +
    string(#0) + string(#49) + string(#81) + string(#48);
end;


end.

