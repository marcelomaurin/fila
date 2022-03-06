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
<<<<<<< HEAD
=======
    RLBNRO: TRLBarcode;
>>>>>>> 8771412255176c8e466a3b3f7f8d466ae78c5763
    RLLabel2: TRLLabel;
    RLDATETIME: TRLLabel;
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

