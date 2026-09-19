unit uFilaRepositorySQLite;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, SQLDB, SQLite3Conn;

type
  EFilaRepository = class(Exception);

  TFilaSQLiteRepository = class
  private
    FConnection: TSQLite3Connection;
    FTransaction: TSQLTransaction;
    FDatabaseFile: string;
    function NewQuery: TSQLQuery;
    procedure Commit;
    procedure Execute(const ASQL: string);
  public
    constructor Create(const ADatabaseFile: string);
    destructor Destroy; override;

    procedure Initialize;
    function IsReady: Boolean;

    procedure AddTicket(AQueueId: Integer; const ATicket: string;
      APriority: Integer = 0);
    procedure MarkCalled(AQueueId: Integer; const ATicket, ADeskId: string);
    procedure AddEvent(const AEventType: string; AQueueId: Integer;
      const ATicket, ADeskId, ADetails: string);

    function WaitingCount: Integer;
    procedure LoadWaiting(AQueueId: Integer; ADestination: TStrings);
    procedure ImportWaiting(AQueueId: Integer; ASource: TStrings);
    procedure CancelAllWaiting(const AReason: string);
  end;

implementation

function ISODateTime(const AValue: TDateTime): string;
begin
  Result := FormatDateTime('yyyy"-"mm"-"dd"T"hh":"nn":"ss"."zzz', AValue);
end;

constructor TFilaSQLiteRepository.Create(const ADatabaseFile: string);
begin
  inherited Create;
  FDatabaseFile := ExpandFileName(ADatabaseFile);
  FConnection := TSQLite3Connection.Create(nil);
  FTransaction := TSQLTransaction.Create(nil);
  FConnection.Transaction := FTransaction;
  FTransaction.Database := FConnection;
end;

destructor TFilaSQLiteRepository.Destroy;
begin
  if Assigned(FConnection) and FConnection.Connected then
  begin
    if FTransaction.Active then
      FTransaction.Rollback;
    FConnection.Close;
  end;
  FreeAndNil(FTransaction);
  FreeAndNil(FConnection);
  inherited Destroy;
end;

function TFilaSQLiteRepository.NewQuery: TSQLQuery;
begin
  Result := TSQLQuery.Create(nil);
  Result.Database := FConnection;
  Result.Transaction := FTransaction;
end;

procedure TFilaSQLiteRepository.Commit;
begin
  if FTransaction.Active then
    FTransaction.Commit;
  FTransaction.StartTransaction;
end;

procedure TFilaSQLiteRepository.Execute(const ASQL: string);
var
  Q: TSQLQuery;
begin
  Q := NewQuery;
  try
    Q.SQL.Text := ASQL;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure TFilaSQLiteRepository.Initialize;
var
  Dir: string;
begin
  Dir := ExtractFileDir(FDatabaseFile);
  if (Dir <> '') and (not DirectoryExists(Dir)) then
    if not ForceDirectories(Dir) then
      raise EFilaRepository.Create('Não foi possível criar: ' + Dir);

  FConnection.DatabaseName := FDatabaseFile;
  FConnection.Open;
  FTransaction.StartTransaction;

  // Mantemos o bootstrap compatível com SQLDB/SQLite em todas as plataformas.
  // WAL pode ser habilitado externamente, mas não é requisito funcional.

  Execute(
    'CREATE TABLE IF NOT EXISTS senha (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT,' +
    'codigo TEXT NOT NULL,' +
    'fila_id INTEGER NOT NULL,' +
    'prioridade INTEGER NOT NULL DEFAULT 0,' +
    'status TEXT NOT NULL,' +
    'emitida_em TEXT NOT NULL,' +
    'chamada_em TEXT,' +
    'guiche TEXT,' +
    'origem TEXT NOT NULL DEFAULT ''FILA''' +
    ')');

  Execute(
    'CREATE INDEX IF NOT EXISTS idx_senha_fila_status ' +
    'ON senha(fila_id, status, id)');

  Execute(
    'CREATE TABLE IF NOT EXISTS evento (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT,' +
    'senha_id INTEGER,' +
    'codigo TEXT,' +
    'fila_id INTEGER,' +
    'guiche TEXT,' +
    'tipo TEXT NOT NULL,' +
    'detalhes TEXT,' +
    'criado_em TEXT NOT NULL,' +
    'FOREIGN KEY(senha_id) REFERENCES senha(id)' +
    ')');

  Execute(
    'CREATE INDEX IF NOT EXISTS idx_evento_data ON evento(criado_em)');

  Commit;
end;

function TFilaSQLiteRepository.IsReady: Boolean;
begin
  Result := Assigned(FConnection) and FConnection.Connected;
end;

procedure TFilaSQLiteRepository.AddTicket(AQueueId: Integer;
  const ATicket: string; APriority: Integer);
var
  Q: TSQLQuery;
begin
  if not IsReady then
    Exit;

  Q := NewQuery;
  try
    Q.SQL.Text :=
      'INSERT INTO senha(codigo,fila_id,prioridade,status,emitida_em,origem) ' +
      'VALUES(:codigo,:fila,:prioridade,''AGUARDANDO'',:data,''FILA'')';
    Q.ParamByName('codigo').AsString := Trim(ATicket);
    Q.ParamByName('fila').AsInteger := AQueueId;
    Q.ParamByName('prioridade').AsInteger := APriority;
    Q.ParamByName('data').AsString := ISODateTime(Now);
    Q.ExecSQL;
  finally
    Q.Free;
  end;

  AddEvent('EMITIDA', AQueueId, ATicket, '', '');
  Commit;
end;

procedure TFilaSQLiteRepository.MarkCalled(AQueueId: Integer;
  const ATicket, ADeskId: string);
var
  Q: TSQLQuery;
begin
  if not IsReady then
    Exit;

  Q := NewQuery;
  try
    Q.SQL.Text :=
      'UPDATE senha SET status=''CHAMADA'', chamada_em=:data, guiche=:guiche ' +
      'WHERE id=(SELECT id FROM senha WHERE fila_id=:fila AND codigo=:codigo ' +
      'AND status=''AGUARDANDO'' ORDER BY id LIMIT 1)';
    Q.ParamByName('data').AsString := ISODateTime(Now);
    Q.ParamByName('guiche').AsString := ADeskId;
    Q.ParamByName('fila').AsInteger := AQueueId;
    Q.ParamByName('codigo').AsString := ATicket;
    Q.ExecSQL;
  finally
    Q.Free;
  end;

  AddEvent('CHAMADA', AQueueId, ATicket, ADeskId, '');
  Commit;
end;

procedure TFilaSQLiteRepository.AddEvent(const AEventType: string;
  AQueueId: Integer; const ATicket, ADeskId, ADetails: string);
var
  Q: TSQLQuery;
begin
  if not IsReady then
    Exit;

  Q := NewQuery;
  try
    Q.SQL.Text :=
      'INSERT INTO evento(senha_id,codigo,fila_id,guiche,tipo,detalhes,criado_em) ' +
      'VALUES((SELECT id FROM senha WHERE codigo=:codigo AND fila_id=:fila ' +
      'ORDER BY id DESC LIMIT 1),:codigo,:fila,:guiche,:tipo,:detalhes,:data)';
    Q.ParamByName('codigo').AsString := ATicket;
    Q.ParamByName('fila').AsInteger := AQueueId;
    Q.ParamByName('guiche').AsString := ADeskId;
    Q.ParamByName('tipo').AsString := UpperCase(Trim(AEventType));
    Q.ParamByName('detalhes').AsString := ADetails;
    Q.ParamByName('data').AsString := ISODateTime(Now);
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

function TFilaSQLiteRepository.WaitingCount: Integer;
var
  Q: TSQLQuery;
begin
  Result := 0;
  if not IsReady then
    Exit;

  Q := NewQuery;
  try
    Q.SQL.Text := 'SELECT COUNT(*) qtd FROM senha WHERE status=''AGUARDANDO''';
    Q.Open;
    Result := Q.FieldByName('qtd').AsInteger;
  finally
    Q.Free;
  end;
end;

procedure TFilaSQLiteRepository.LoadWaiting(AQueueId: Integer;
  ADestination: TStrings);
var
  Q: TSQLQuery;
begin
  if not Assigned(ADestination) then
    Exit;
  ADestination.Clear;

  if not IsReady then
    Exit;

  Q := NewQuery;
  try
    Q.SQL.Text :=
      'SELECT codigo FROM senha WHERE fila_id=:fila AND status=''AGUARDANDO'' ' +
      'ORDER BY prioridade DESC, id';
    Q.ParamByName('fila').AsInteger := AQueueId;
    Q.Open;
    while not Q.EOF do
    begin
      ADestination.Add(Q.FieldByName('codigo').AsString);
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

procedure TFilaSQLiteRepository.ImportWaiting(AQueueId: Integer;
  ASource: TStrings);
var
  I: Integer;
begin
  if not IsReady or not Assigned(ASource) then
    Exit;

  for I := 0 to ASource.Count - 1 do
    AddTicket(AQueueId, ASource[I], 0);
end;

procedure TFilaSQLiteRepository.CancelAllWaiting(const AReason: string);
var
  Q: TSQLQuery;
begin
  if not IsReady then
    Exit;

  Q := NewQuery;
  try
    Q.SQL.Text := 'UPDATE senha SET status=''CANCELADA'' WHERE status=''AGUARDANDO''';
    Q.ExecSQL;
  finally
    Q.Free;
  end;

  AddEvent('RESET_FILA', 0, '', '', AReason);
  Commit;
end;

end.
