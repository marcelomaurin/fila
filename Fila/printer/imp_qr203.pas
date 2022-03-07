unit imp_qr203;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, imp_generico;

type

  { TIMP_QR203 }

  TIMP_QR203 = class(TInterfacedObject,TImp_generico)
    FCOLUNA : integer;
    FSERIAL : String;

  private
      function getserial : string;
      procedure setserial(value : string);

  public
      constructor create();
      destructor destroy();


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
  published
      property Serial : String read getserial  write setserial;

end;

var
  IMPQR203: TIMP_QR203;

implementation

{ TIMP_QR203 }

function TIMP_QR203.getserial: string;
begin

end;

procedure TIMP_QR203.setserial(value: string);
begin

end;

function TIMP_QR203.InitPrint(): string;
begin

end;

function TIMP_QR203.NewLine(): string;
begin

end;

function TIMP_QR203.LineText(Info: string): string;
begin

end;

function TIMP_QR203.Negrito(): string;
begin

end;

function TIMP_QR203.Normal(): string;
begin

end;

function TIMP_QR203.Sublinhado(): string;
begin

end;

function TIMP_QR203.DoubleTexto(): string;
begin

end;

function TIMP_QR203.beep(): string;
begin

end;

function TIMP_QR203.Guilhotina(): string;
begin

end;

function TIMP_QR203.AcionaGaveta(): string;
begin

end;

function TIMP_QR203.Barra1D(Info: string): string;
begin

end;

function TIMP_QR203.Barra2D(info: String): string;
begin

end;

function TIMP_QR203.loadImagem(X, Y: integer; Info: String): string;
begin

end;

function TIMP_QR203.imprimeImagem(X, Y: integer): string;
begin

end;

constructor TIMP_QR203.create();
begin

end;

destructor TIMP_QR203.destroy();
begin

end;

end.

