program Fila;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, menu, fortes324forlaz, LazSerialPort, lnetvisual, Impressao, main, log,
  registro, imp_ELGINI9, imp_generico, imp_qr203, splash, cupom
  { you can add units after this };

{$R *.res}

begin
  Application.Scaled:=True;
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(Tfrmmain, frmmain);
  Application.CreateForm(Tfrmcupom, frmcupom);
  Application.Run;
end.

