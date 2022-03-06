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
  private
    {private declarations}
  public
    {public declarations}
  end;

var
  frmconfig: Tfrmconfig;

implementation
  
{$R *.lfm}
  

end.
