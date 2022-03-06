{hint: Pascal files location: ...\\jni }
unit config;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls;
  
type

  { Tfrmconfig }

  Tfrmconfig = class(jForm)
    jbtclose: jButton;
    jedIP: jEditText;
    jTextView1: jTextView;
    procedure jbtcloseClick(Sender: TObject);
  private
    {private declarations}
  public
    {public declarations}
  end;

var
  frmconfig: Tfrmconfig;

implementation
  
{$R *.lfm}
  

{ Tfrmconfig }

procedure Tfrmconfig.jbtcloseClick(Sender: TObject);
begin
  close;
end;

end.
