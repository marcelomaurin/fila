unit impressao2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  RLReport, RLBarcode;

type

  { Tfrmimpressao2 }

  Tfrmimpressao2 = class(TForm)
    RLDATETIME: TRLLabel;
    RLEmpresa: TRLLabel;
    RLPicote: TRLLabel;
    RLImage1: TRLImage;
    RLLabel2: TRLLabel;
    RLLabel5: TRLLabel;
    RLLocalizacao: TRLLabel;
    RLNRO: TRLLabel;
    RLReport1: TRLReport;
    RLTipo: TRLLabel;
  private

  public

  end;

var
  frmimpressao2: Tfrmimpressao2;

implementation

{$R *.lfm}

end.

