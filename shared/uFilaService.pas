unit uFilaService;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

const
  FILA_MIN_ID = 1;
  FILA_MAX_ID = 5;

type
  EFilaService = class(Exception);

  TFilaService = class
  private
    FQueues: array[FILA_MIN_ID..FILA_MAX_ID] of TStringList;
    procedure ValidateQueueId(AQueueId: Integer);
    function QueueFileName(const ADirectory: string; AQueueId: Integer): string;
  public
    constructor Create;
    destructor Destroy; override;

    procedure AddTicket(AQueueId: Integer; const ATicket: string);
    function TryCallNext(AQueueId: Integer; out ATicket: string): Boolean;
    function PeekTicket(AQueueId: Integer; out ATicket: string): Boolean;
    function Count(AQueueId: Integer): Integer;
    procedure Clear(AQueueId: Integer);
    procedure ClearAll;

    procedure AssignQueue(AQueueId: Integer; ADestination: TStrings);
    procedure LoadFromDirectory(const ADirectory: string);
    procedure SaveToDirectory(const ADirectory: string);
  end;

implementation

constructor TFilaService.Create;
var
  I: Integer;
begin
  inherited Create;
  for I := FILA_MIN_ID to FILA_MAX_ID do
    FQueues[I] := TStringList.Create;
end;

destructor TFilaService.Destroy;
var
  I: Integer;
begin
  for I := FILA_MIN_ID to FILA_MAX_ID do
    FreeAndNil(FQueues[I]);
  inherited Destroy;
end;

procedure TFilaService.ValidateQueueId(AQueueId: Integer);
begin
  if (AQueueId < FILA_MIN_ID) or (AQueueId > FILA_MAX_ID) then
    raise EFilaService.CreateFmt('Fila inválida: %d', [AQueueId]);
end;

function TFilaService.QueueFileName(const ADirectory: string;
  AQueueId: Integer): string;
begin
  ValidateQueueId(AQueueId);
  Result := IncludeTrailingPathDelimiter(ADirectory) +
    Format('list%.2d.txt', [AQueueId]);
end;

procedure TFilaService.AddTicket(AQueueId: Integer; const ATicket: string);
var
  Ticket: string;
begin
  ValidateQueueId(AQueueId);
  Ticket := Trim(ATicket);
  if Ticket = '' then
    raise EFilaService.Create('Senha vazia não pode ser adicionada.');
  FQueues[AQueueId].Add(Ticket);
end;

function TFilaService.TryCallNext(AQueueId: Integer; out ATicket: string): Boolean;
begin
  ValidateQueueId(AQueueId);
  Result := FQueues[AQueueId].Count > 0;
  if not Result then
  begin
    ATicket := '';
    Exit;
  end;

  ATicket := FQueues[AQueueId][0];
  FQueues[AQueueId].Delete(0);
end;

function TFilaService.PeekTicket(AQueueId: Integer; out ATicket: string): Boolean;
begin
  ValidateQueueId(AQueueId);
  Result := FQueues[AQueueId].Count > 0;
  if Result then
    ATicket := FQueues[AQueueId][0]
  else
    ATicket := '';
end;

function TFilaService.Count(AQueueId: Integer): Integer;
begin
  ValidateQueueId(AQueueId);
  Result := FQueues[AQueueId].Count;
end;

procedure TFilaService.Clear(AQueueId: Integer);
begin
  ValidateQueueId(AQueueId);
  FQueues[AQueueId].Clear;
end;

procedure TFilaService.ClearAll;
var
  I: Integer;
begin
  for I := FILA_MIN_ID to FILA_MAX_ID do
    FQueues[I].Clear;
end;

procedure TFilaService.AssignQueue(AQueueId: Integer; ADestination: TStrings);
begin
  ValidateQueueId(AQueueId);
  if not Assigned(ADestination) then
    raise EFilaService.Create('Destino da fila não foi informado.');
  ADestination.Assign(FQueues[AQueueId]);
end;

procedure TFilaService.LoadFromDirectory(const ADirectory: string);
var
  I: Integer;
  FileName: string;
begin
  for I := FILA_MIN_ID to FILA_MAX_ID do
  begin
    FQueues[I].Clear;
    FileName := QueueFileName(ADirectory, I);
    if FileExists(FileName) then
      FQueues[I].LoadFromFile(FileName);
  end;
end;

procedure TFilaService.SaveToDirectory(const ADirectory: string);
var
  I: Integer;
  Dir: string;
begin
  Dir := ExcludeTrailingPathDelimiter(ADirectory);
  if Dir = '' then
    raise EFilaService.Create('Diretório de persistência não informado.');

  if not DirectoryExists(Dir) then
    if not ForceDirectories(Dir) then
      raise EFilaService.Create('Não foi possível criar o diretório: ' + Dir);

  for I := FILA_MIN_ID to FILA_MAX_ID do
    FQueues[I].SaveToFile(QueueFileName(Dir, I));
end;

end.
