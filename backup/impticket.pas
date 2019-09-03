unit ImpTicket;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, RLReport, RLBarcode;

type

  { TfrmImpTicket }

  TfrmImpTicket = class(TForm)
    RLBNRO: TRLBarcode;
    RLEmpresa: TRLLabel;
    RLLabel1: TRLLabel;
    RLTipo: TRLLabel;
    RLLabel3: TRLLabel;
    RLDATETIME: TRLLabel;
    RLLocalizacao: TRLLabel;
    RLNRO: TRLLabel;
    RLReport1: TRLReport;
  private

  public

  end;

var
  frmImpTicket: TfrmImpTicket;

implementation

{$R *.lfm}

end.

