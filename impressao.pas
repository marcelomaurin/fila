unit Impressao;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  RLReport, RLBarcode;

type

  { TfrmImpressao }

  TfrmImpressao = class(TForm)
    Label1: TLabel;
    RLBNRO: TRLBarcode;
    RLLabel1: TRLLabel;
    RLLabel2: TRLLabel;
    RLDATETIME: TRLLabel;
    RLLabel6: TRLLabel;
    RLLabel7: TRLLabel;
    RLLabel8: TRLLabel;
    RLNRO: TRLLabel;
    RLEmpresa: TRLLabel;
    RLLocalizacao: TRLLabel;
    RLLabel5: TRLLabel;
    RLTipo: TRLLabel;
    RLReport1: TRLReport;
    procedure RLBNROAfterPrint(Sender: TObject);
    procedure RLImage1AfterPrint(Sender: TObject);
    procedure RLNROAfterPrint(Sender: TObject);
    procedure RLTipoAfterPrint(Sender: TObject);
  private

  public

  end;

var
  frmImpressao: TfrmImpressao;

implementation

{$R *.lfm}

{ TfrmImpressao }

procedure TfrmImpressao.RLImage1AfterPrint(Sender: TObject);
begin

end;

procedure TfrmImpressao.RLBNROAfterPrint(Sender: TObject);
begin

end;

procedure TfrmImpressao.RLNROAfterPrint(Sender: TObject);
begin

end;

procedure TfrmImpressao.RLTipoAfterPrint(Sender: TObject);
begin

end;

end.

