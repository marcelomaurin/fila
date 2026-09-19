program test_core;

{$mode objfpc}{$H+}

uses
  Classes, SysUtils, uFilaProtocol, uFilaService, uFilaTypes;

procedure Check(ACondition: Boolean; const AMessage: string);
begin
  if not ACondition then
    raise Exception.Create('FALHA: ' + AMessage);
end;

procedure TestProtocol;
var
  QueueId: Integer;
  DeskId, Ticket: string;
begin
  Check(EncodeCallRequest(2, '3') = 'Fila:2' + #13 + '>3;',
    'EncodeCallRequest');

  Check(TryParseCallRequest('Fila:2' + #13 + '>3;', QueueId, DeskId),
    'TryParseCallRequest deve aceitar mensagem valida');
  Check(QueueId = 2, 'Fila da requisicao');
  Check(DeskId = '3', 'Guiche da requisicao');

  Check(not TryParseCallRequest('INVALIDO', QueueId, DeskId),
    'TryParseCallRequest deve rejeitar mensagem invalida');
  Check(not TryParseCallRequest('Fila:9' + #13 + '>3;', QueueId, DeskId),
    'TryParseCallRequest deve rejeitar fila fora do intervalo');

  Check(EncodeTicketResponse(2, 'B15') = 'Fila:2;B15' + #13,
    'EncodeTicketResponse');
  Check(TryParseTicketResponse('Fila:2;B15' + #13, QueueId, Ticket),
    'TryParseTicketResponse');
  Check((QueueId = 2) and (Ticket = 'B15'), 'Conteudo da resposta');

  Check(EncodePanelCall('A10', 4, 1) = 'FILA:A10>4;',
    'EncodePanelCall protocolo 1');
  Check(TryParsePanelCall('FILA:A10>4;', Ticket, DeskId),
    'TryParsePanelCall protocolo 1');
  Check((Ticket = 'A10') and (DeskId = '4'), 'Conteudo painel v1');

  Check(TryParsePanelCall('Fila:A10' + #13 + '>4;', Ticket, DeskId),
    'TryParsePanelCall protocolo legado alternativo');
  Check((Ticket = 'A10') and (DeskId = '4'), 'Conteudo painel alternativo');
end;

procedure TestQueueService;
var
  Service: TFilaService;
  Ticket: string;
  View: TStringList;
  TempDir: string;
begin
  Service := TFilaService.Create;
  View := TStringList.Create;
  TempDir := IncludeTrailingPathDelimiter(GetTempDir(False)) +
    'fila-core-test-' + IntToStr(GetProcessID);
  try
    Service.AddTicket(1, 'A1');
    Service.AddTicket(1, 'A2');
    Service.AddTicket(2, 'B1');

    Check(Service.Count(1) = 2, 'Contagem fila 1');
    Check(Service.Count(2) = 1, 'Contagem fila 2');

    Check(Service.PeekTicket(1, Ticket) and (Ticket = 'A1'),
      'Peek deve preservar primeiro item');
    Check(Service.Count(1) = 2, 'Peek nao remove item');

    Check(Service.TryCallNext(1, Ticket) and (Ticket = 'A1'),
      'FIFO primeiro item');
    Check(Service.TryCallNext(1, Ticket) and (Ticket = 'A2'),
      'FIFO segundo item');
    Check(not Service.TryCallNext(1, Ticket), 'Fila vazia');

    Service.AddTicket(3, 'C7');
    Service.AssignQueue(3, View);
    Check((View.Count = 1) and (View[0] = 'C7'),
      'AssignQueue para camada visual');

    Service.SaveToDirectory(TempDir);
    Service.ClearAll;
    Check(Service.Count(2) = 0, 'ClearAll');

    Service.LoadFromDirectory(TempDir);
    Check(Service.PeekTicket(2, Ticket) and (Ticket = 'B1'),
      'Persistencia fila 2');
    Check(Service.PeekTicket(3, Ticket) and (Ticket = 'C7'),
      'Persistencia fila 3');

    Check(SenhaStatusToString(ssAguardando) = 'AGUARDANDO',
      'Conversao de status');
  finally
    View.Free;
    Service.Free;
    if DirectoryExists(TempDir) then
    begin
      DeleteFile(IncludeTrailingPathDelimiter(TempDir) + 'list01.txt');
      DeleteFile(IncludeTrailingPathDelimiter(TempDir) + 'list02.txt');
      DeleteFile(IncludeTrailingPathDelimiter(TempDir) + 'list03.txt');
      DeleteFile(IncludeTrailingPathDelimiter(TempDir) + 'list04.txt');
      DeleteFile(IncludeTrailingPathDelimiter(TempDir) + 'list05.txt');
      RemoveDir(TempDir);
    end;
  end;
end;

begin
  try
    TestProtocol;
    TestQueueService;
    WriteLn('OK - testes do nucleo passaram.');
  except
    on E: Exception do
    begin
      WriteLn(E.Message);
      Halt(1);
    end;
  end;
end.
