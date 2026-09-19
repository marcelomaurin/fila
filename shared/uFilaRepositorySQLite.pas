unit uFilaRepositorySQLite;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StrUtils, DB, SQLDB, SQLite3Conn, uFilaTypes;

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
    function ColumnExists(const ATable, AColumn: string): Boolean;
    procedure EnsureColumn(const ATable, AColumn, ADefinition: string);
    function ChangeStatus(const ATicket, ADeskId, AFromStatus, AToStatus,
      ADateColumn, AEventType, ADetails: string): Boolean;
  public
    constructor Create(const ADatabaseFile: string);
    destructor Destroy; override;

    procedure Initialize;
    function IsReady: Boolean;

    procedure AddTicket(AQueueId: Integer; const ATicket: string;
      APriority: Integer = 0);
    procedure MarkCalled(AQueueId: Integer; const ATicket, ADeskId: string);
    function StartService(const ATicket, ADeskId: string): Boolean;
    function FinishService(const ATicket, ADeskId: string): Boolean;
    function MarkAbsent(const ATicket, ADeskId: string): Boolean;
    function CancelTicket(const ATicket, ADeskId, AReason: string): Boolean;
    procedure AddEvent(const AEventType: string; AQueueId: Integer;
      const ATicket, ADeskId, ADetails: string);

    function WaitingCount: Integer;
    function GetMetrics: TFilaMetrics;
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

function TFilaSQLiteRepository.ColumnExists(const ATable, AColumn: string): Boolean;
var
  Q: TSQLQuery;
begin
  Result := False;
  Q := NewQuery;
  try
    Q.SQL.Text := 'PRAGMA table_info(' + ATable + ')';
    Q.Open;
    while not Q.EOF do
    begin
      if SameText(Q.FieldByName('name').AsString, AColumn) then
        Exit(True);
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

procedure TFilaSQLiteRepository.EnsureColumn(const ATable, AColumn,
  ADefinition: string);
begin
  if not ColumnExists(ATable, AColumn) then
    Execute('ALTER TABLE ' + ATable + ' ADD COLUMN ' + AColumn + ' ' + ADefinition);
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

  Execute(
    'CREATE TABLE IF NOT EXISTS senha (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT,' +
    'codigo TEXT NOT NULL,' +
    'fila_id INTEGER NOT NULL,' +
    'prioridade INTEGER NOT NULL DEFAULT 0,' +
    'status TEXT NOT NULL,' +
    'emitida_em TEXT NOT NULL,' +
    'chamada_em TEXT,' +
    'inicio_atendimento_em TEXT,' +
    'fim_atendimento_em TEXT,' +
    'guiche TEXT,' +
    'operador TEXT,' +
    'motivo_fim TEXT,' +
    'origem TEXT NOT NULL DEFAULT ''FILA''' +
    ')');

  EnsureColumn('senha', 'inicio_atendimento_em', 'TEXT');
  EnsureColumn('senha', 'fim_atendimento_em', 'TEXT');
  EnsureColumn('senha', 'operador', 'TEXT');
  EnsureColumn('senha', 'motivo_fim', 'TEXT');

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

  Execute('CREATE INDEX IF NOT EXISTS idx_evento_data ON evento(criado_em)');
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
  if not IsReady then Exit;

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
  if not IsReady then Exit;

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

function TFilaSQLiteRepository.ChangeStatus(const ATicket, ADeskId,
  AFromStatus, AToStatus, ADateColumn, AEventType, ADetails: string): Boolean;
var
  Q: TSQLQuery;
begin
  Result := False;
  if not IsReady then Exit;

  Q := NewQuery;
  try
    Q.SQL.Text :=
      'SELECT id,fila_id FROM senha WHERE codigo=:codigo ' +
      'AND status IN (' + AFromStatus + ') ORDER BY id DESC LIMIT 1';
    Q.ParamByName('codigo').AsString := ATicket;
    Q.Open;
    if Q.EOF then Exit;

    Q.Close;
    Q.SQL.Text :=
      'UPDATE senha SET status=:status, guiche=CASE WHEN :guiche='''' THEN guiche ELSE :guiche END' +
      IfThen(ADateColumn <> '', ', ' + ADateColumn + '=:data', '') +
      IfThen(AToStatus = 'CANCELADA', ', motivo_fim=:motivo', '') +
      ' WHERE id=(SELECT id FROM senha WHERE codigo=:codigo ' +
      'AND status IN (' + AFromStatus + ') ORDER BY id DESC LIMIT 1)';
    Q.ParamByName('status').AsString := AToStatus;
    Q.ParamByName('guiche').AsString := ADeskId;
    if ADateColumn <> '' then
      Q.ParamByName('data').AsString := ISODateTime(Now);
    if AToStatus = 'CANCELADA' then
      Q.ParamByName('motivo').AsString := ADetails;
    Q.ParamByName('codigo').AsString := ATicket;
    Q.ExecSQL;
    Result := Q.RowsAffected > 0;
  finally
    Q.Free;
  end;

  if Result then
  begin
    AddEvent(AEventType, 0, ATicket, ADeskId, ADetails);
    Commit;
  end;
end;

function TFilaSQLiteRepository.StartService(const ATicket,
  ADeskId: string): Boolean;
begin
  Result := ChangeStatus(ATicket, ADeskId, '''CHAMADA''',
    'EM_ATENDIMENTO', 'inicio_atendimento_em', 'INICIO_ATENDIMENTO', '');
end;

function TFilaSQLiteRepository.FinishService(const ATicket,
  ADeskId: string): Boolean;
begin
  Result := ChangeStatus(ATicket, ADeskId, '''EM_ATENDIMENTO''',
    'FINALIZADA', 'fim_atendimento_em', 'FINALIZADA', '');
end;

function TFilaSQLiteRepository.MarkAbsent(const ATicket,
  ADeskId: string): Boolean;
begin
  Result := ChangeStatus(ATicket, ADeskId, '''CHAMADA'',''EM_ATENDIMENTO''',
    'AUSENTE', 'fim_atendimento_em', 'AUSENTE', '');
end;

function TFilaSQLiteRepository.CancelTicket(const ATicket,
  ADeskId, AReason: string): Boolean;
begin
  Result := ChangeStatus(ATicket, ADeskId,
    '''AGUARDANDO'',''CHAMADA'',''EM_ATENDIMENTO''',
    'CANCELADA', 'fim_atendimento_em', 'CANCELADA', AReason);
end;

procedure TFilaSQLiteRepository.AddEvent(const AEventType: string;
  AQueueId: Integer; const ATicket, ADeskId, ADetails: string);
var
  Q: TSQLQuery;
begin
  if not IsReady then Exit;

  Q := NewQuery;
  try
    Q.SQL.Text :=
      'INSERT INTO evento(senha_id,codigo,fila_id,guiche,tipo,detalhes,criado_em) ' +
      'SELECT id,codigo,fila_id,:guiche,:tipo,:detalhes,:data ' +
      'FROM senha WHERE codigo=:codigo ' +
      'AND (:fila=0 OR fila_id=:fila) ORDER BY id DESC LIMIT 1';
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
  if not IsReady then Exit;
  Q := NewQuery;
  try
    Q.SQL.Text := 'SELECT COUNT(*) qtd FROM senha WHERE status=''AGUARDANDO''';
    Q.Open;
    Result := Q.FieldByName('qtd').AsInteger;
  finally
    Q.Free;
  end;
end;

function TFilaSQLiteRepository.GetMetrics: TFilaMetrics;
var
  Q: TSQLQuery;
begin
  FillChar(Result, SizeOf(Result), 0);
  if not IsReady then Exit;

  Q := NewQuery;
  try
    Q.SQL.Text :=
      'SELECT ' +
      'SUM(CASE WHEN status=''AGUARDANDO'' THEN 1 ELSE 0 END) aguardando,' +
      'SUM(CASE WHEN status=''CHAMADA'' THEN 1 ELSE 0 END) chamadas,' +
      'SUM(CASE WHEN status=''EM_ATENDIMENTO'' THEN 1 ELSE 0 END) em_atendimento,' +
      'SUM(CASE WHEN status=''FINALIZADA'' AND substr(fim_atendimento_em,1,10)=date(''now'',''localtime'') THEN 1 ELSE 0 END) finalizadas_hoje,' +
      'SUM(CASE WHEN status=''AUSENTE'' AND substr(fim_atendimento_em,1,10)=date(''now'',''localtime'') THEN 1 ELSE 0 END) ausentes_hoje,' +
      'SUM(CASE WHEN status=''CANCELADA'' AND substr(fim_atendimento_em,1,10)=date(''now'',''localtime'') THEN 1 ELSE 0 END) canceladas_hoje,' +
      'AVG(CASE WHEN chamada_em IS NOT NULL THEN (julianday(chamada_em)-julianday(emitida_em))*86400 END) espera_media,' +
      'AVG(CASE WHEN fim_atendimento_em IS NOT NULL AND inicio_atendimento_em IS NOT NULL THEN ' +
      '(julianday(fim_atendimento_em)-julianday(inicio_atendimento_em))*86400 END) atendimento_medio ' +
      'FROM senha';
    Q.Open;
    Result.Aguardando := Q.FieldByName('aguardando').AsInteger;
    Result.Chamadas := Q.FieldByName('chamadas').AsInteger;
    Result.EmAtendimento := Q.FieldByName('em_atendimento').AsInteger;
    Result.FinalizadasHoje := Q.FieldByName('finalizadas_hoje').AsInteger;
    Result.AusentesHoje := Q.FieldByName('ausentes_hoje').AsInteger;
    Result.CanceladasHoje := Q.FieldByName('canceladas_hoje').AsInteger;
    Result.TempoMedioEsperaSeg := Q.FieldByName('espera_media').AsFloat;
    Result.TempoMedioAtendimentoSeg := Q.FieldByName('atendimento_medio').AsFloat;
  finally
    Q.Free;
  end;
end;

procedure TFilaSQLiteRepository.LoadWaiting(AQueueId: Integer;
  ADestination: TStrings);
var
  Q: TSQLQuery;
begin
  if not Assigned(ADestination) then Exit;
  ADestination.Clear;
  if not IsReady then Exit;

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
  if not IsReady or not Assigned(ASource) then Exit;
  for I := 0 to ASource.Count - 1 do
    AddTicket(AQueueId, ASource[I], 0);
end;

procedure TFilaSQLiteRepository.CancelAllWaiting(const AReason: string);
var
  Q: TSQLQuery;
begin
  if not IsReady then Exit;

  Q := NewQuery;
  try
    Q.SQL.Text :=
      'UPDATE senha SET status=''CANCELADA'', fim_atendimento_em=:data, motivo_fim=:motivo ' +
      'WHERE status=''AGUARDANDO''';
    Q.ParamByName('data').AsString := ISODateTime(Now);
    Q.ParamByName('motivo').AsString := AReason;
    Q.ExecSQL;
  finally
    Q.Free;
  end;

  AddEvent('RESET_FILA', 0, '', '', AReason);
  Commit;
end;

end.
