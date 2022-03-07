unit imp_generico;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

const
     LF = #10;
     FF = #12;
     CR = #13;
     HT = #9;
     CAN = #24;
     ESC = #27;

type
  { TIMP_GENERICO }
  TIMP_GENERICO = interface
    ['{045F6EED-2C11-447D-A7DC-09DB995367C2}']

     function getserial : string;
     procedure setserial(value : string);

     function InitPrint(): string;
     function NewLine(): string;
     function LineText(Info : string): string;
     function Negrito(): string;
     function Normal(): string;
     function Sublinhado(): string;
     function DoubleTexto(): string;
     function beep(): string;
     function Guilhotina(): string;
     function AcionaGaveta(): string;
     function Barra1D(Info : string): string;
     function Barra2D(info : String): string;
     function loadImagem(X,Y : integer; Info : String): string;
     function imprimeImagem(X,Y : integer): string;
     property Serial : String read getserial  write setserial;
end;

implementation



{ TIMP_GENERICO }


end.

