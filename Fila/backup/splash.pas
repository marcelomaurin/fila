unit splash;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TfrmSplash }

  TfrmSplash = class(TForm)
    cbnotsplash: TCheckBox;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    lbVersao: TLabel;
  private

  public

  end;

var
  frmSplash: TfrmSplash;

implementation

{$R *.lfm}

end.

