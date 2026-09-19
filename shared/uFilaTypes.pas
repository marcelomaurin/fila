unit uFilaTypes;

{$mode objfpc}{$H+}

interface

uses
  SysUtils;

type
  TSenhaStatus = (
    ssAguardando,
    ssChamada,
    ssEmAtendimento,
    ssFinalizada,
    ssAusente,
    ssCancelada
  );

  TSenhaInfo = record
    Id: Int64;
    Codigo: string;
    FilaId: Integer;
    Prioridade: Integer;
    Status: TSenhaStatus;
    EmitidaEm: TDateTime;
    ChamadaEm: TDateTime;
    InicioAtendimentoEm: TDateTime;
    FimAtendimentoEm: TDateTime;
    GuicheId: Integer;
    Operador: string;
  end;

function SenhaStatusToString(AStatus: TSenhaStatus): string;

implementation

function SenhaStatusToString(AStatus: TSenhaStatus): string;
begin
  case AStatus of
    ssAguardando: Result := 'AGUARDANDO';
    ssChamada: Result := 'CHAMADA';
    ssEmAtendimento: Result := 'EM_ATENDIMENTO';
    ssFinalizada: Result := 'FINALIZADA';
    ssAusente: Result := 'AUSENTE';
    ssCancelada: Result := 'CANCELADA';
  else
    Result := 'DESCONHECIDA';
  end;
end;

end.
