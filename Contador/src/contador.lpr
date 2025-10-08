program contador;

{$mode objfpc}{$H+}

uses
  Classes, SysUtils, Windows, ZConnection, ZDataset;

function GetCPUName: string;
begin
  {$IFDEF CPUX86_64}
  Result := 'x86_64';
  {$ELSE}
    {$IFDEF CPUI386}
    Result := 'x86';
    {$ELSE}
    Result := 'CPU desconhecida';
    {$ENDIF}
  {$ENDIF}
end;

function GetBitsStr: string;
begin
  Result := IntToStr(SizeOf(Pointer) * 8);
end;

procedure ShowBanner;
begin
  WriteLn('Contador - projeto FILA, gerenciador de atendimentos');
  WriteLn('Criado por Marcelo Maurin Martins');
  WriteLn('Projeto Open Source');
  WriteLn('Duvidas ou sugestoes: marcelomaurinmartins@gmail.com');
  WriteLn(Format('Plataforma: Windows %s (%s bits)', [GetCPUName, GetBitsStr]));
  WriteLn;
end;

function GetConfigFileName: string;
begin
  Result := ExpandFileName(ExtractFilePath(ParamStr(0)) + 'config.cfg');
end;

procedure CreateDefaultConfig(const FileName: string);
var
  SL: TStringList;
  Dir: String;
begin
  Dir := ExtractFilePath(FileName);
  if not DirectoryExists(Dir) then
    if not ForceDirectories(Dir) then
      raise Exception.Create('Nao foi possivel criar o diretorio de configuracao: ' + Dir);

  SL := TStringList.Create;
  try
    SL.Add('[database]');
    SL.Add('protocol=sqlite-3');
    SL.Add('dbpath=.\');
    SL.Add('database=contador.db');
    SL.Add('driverpath=.\sqlite3.dll'); // dll ao lado do exe por padrão
    SL.SaveToFile(FileName);
    WriteLn('Arquivo de configuracao criado: ', FileName);
  finally
    SL.Free;
  end;
end;

procedure LoadConfig(const FileName: string; out Protocol, DatabasePath, DriverPath: string);
var
  SL: TStringList;
  i, p: Integer;
  Line, Key, Value, DbName, DbPath: string;
begin
  // Defaults (Windows)
  Protocol   := 'sqlite-3';
  DbPath     := '.\';
  DbName     := 'contador.db';
  DriverPath := '.\sqlite3.dll';

  SL := TStringList.Create;
  try
    SL.LoadFromFile(FileName);
    for i := 0 to SL.Count - 1 do
    begin
      Line := Trim(SL[i]);
      if (Line = '') or (Line[1] in ['[', '#', ';']) then Continue;
      p := Pos('=', Line);
      if p <= 0 then Continue;
      Key   := Trim(Copy(Line, 1, p - 1));
      Value := Trim(Copy(Line, p + 1, MaxInt));

      if SameText(Key, 'protocol') then Protocol := Value
      else if SameText(Key, 'dbpath') then DbPath := Value
      else if SameText(Key, 'database') then DbName := Value
      else if SameText(Key, 'driverpath') then DriverPath := Value;
    end;
  finally
    SL.Free;
  end;

  // Normaliza dbpath com separador no final
  if (DbPath <> '') and not (DbPath[Length(DbPath)] in ['/', '\']) then
    DbPath := DbPath + DirectorySeparator;

  DatabasePath := ExpandFileName(DbPath + DbName);
  DriverPath   := ExpandFileName(DriverPath);
end;

procedure ShowHelp;
begin
  WriteLn('Uso: ', ExtractFileName(ParamStr(0)), ' <guiche:int> <senha:string> <tipo:int>');
  WriteLn('Ajuda: ', ExtractFileName(ParamStr(0)), ' /h');
  WriteLn;
  WriteLn('Descricao:');
  WriteLn('  Insere um registro na tabela "registro" (SQLite) com guiche, senha e tipo.');
  WriteLn;
  WriteLn('Parametros (ordem obrigatoria):');
  WriteLn('  1) guiche  -> inteiro do guiche de atendimento.');
  WriteLn('  2) senha   -> texto alfanumerico da senha chamada.');
  WriteLn('  3) tipo    -> inteiro (coluna "tipo" da tabela).');
  WriteLn;
  WriteLn('Exemplos:');
  WriteLn('  ', ExtractFileName(ParamStr(0)), ' 3 A015 2');
  WriteLn('  ', ExtractFileName(ParamStr(0)), ' /h');
  WriteLn;
  WriteLn('Configuracao (config.cfg ao lado do executavel):');
  WriteLn('  [database]');
  WriteLn('  protocol=sqlite-3');
  WriteLn('  dbpath=.\                ; pasta do banco (ex.: C:\db\)');
  WriteLn('  database=contador.db     ; nome do arquivo do banco');
  WriteLn('  driverpath=.\sqlite3.dll ; caminho para sqlite3.dll (ou absoluto)');
  WriteLn('                            ; 64-bit exe -> DLL 64-bit (C:\Windows\System32\sqlite3.dll)');
  WriteLn('                            ; 32-bit exe -> DLL 32-bit (C:\Windows\SysWOW64\sqlite3.dll)');
  WriteLn;
end;

function IsHelpFlag(const S: string): boolean;
var
  L: string;
begin
  L := LowerCase(S);
  Result := (L = '/h') or (L = '/?') or (L = '-h') or (L = '--h') or (L = '--help');
end;

// Adiciona a pasta ao PATH do processo usando SysUtils (ler) + Windows (setar)
function AddDirToProcessPATH(const Dir: string): boolean;
var
  CurrentPath, NewPath, DirNorm, CurrentPathLower: string;
begin
  Result := True;
  DirNorm := IncludeTrailingPathDelimiter(Dir);

  // *** USE A VERSAO DO SYSUTILS (1 parametro) ***
  CurrentPath := SysUtils.GetEnvironmentVariable('PATH');

  // evita duplicar
  CurrentPathLower := LowerCase(StringReplace(CurrentPath, '/', '\', [rfReplaceAll]));
  if Pos(';' + LowerCase(DirNorm) + ';', ';' + CurrentPathLower + ';') = 0 then
  begin
    if CurrentPath <> '' then
      NewPath := DirNorm + ';' + CurrentPath
    else
      NewPath := DirNorm;

    // *** USE A VERSAO DO WINDOWS PARA SETAR (2 parametros) ***
    Result := Windows.SetEnvironmentVariable(PChar('PATH'), PChar(NewPath));
  end;
end;

function EnsureSqliteDllLoaded(const DllFullPath: string): boolean;
var
  H: HMODULE;
  Dir: string;
begin
  Result := False;

  if not FileExists(DllFullPath) then
  begin
    WriteLn('ERRO: sqlite3.dll nao encontrada em: ', DllFullPath);
    Exit(False);
  end;

  Dir := IncludeTrailingPathDelimiter(ExtractFilePath(DllFullPath));
  if not AddDirToProcessPATH(Dir) then
    WriteLn('Aviso: nao foi possivel ajustar PATH do processo para: ', Dir);

  // 1) tenta com caminho completo
  H := LoadLibrary(PChar(DllFullPath));
  if H = 0 then
  begin
    // 2) tenta pelo nome, agora que a pasta esta no PATH
    H := LoadLibrary('sqlite3.dll');
    if H = 0 then
    begin
      WriteLn('ERRO: LoadLibrary falhou. Codigo: ', GetLastError);
      Exit(False);
    end;
  end;

  Result := True;
end;

var
  Conn: TZConnection;
  Query: TZQuery;
  Guiche, Tipo: Integer;
  Senha: String;
  Protocol, DatabaseFile, ConfigFile, DriverPath: string;
begin
  ShowBanner;

  // config ao lado do exe
  ConfigFile := GetConfigFileName;
  if not FileExists(ConfigFile) then
    CreateDefaultConfig(ConfigFile);

  // ajuda e params
  if ParamCount = 0 then begin ShowHelp; Halt(0); end;
  if (ParamCount >= 1) and IsHelpFlag(ParamStr(1)) then begin ShowHelp; Halt(0); end;
  if ParamCount < 3 then
  begin
    WriteLn('Parametros insuficientes.');
    ShowHelp; Halt(1);
  end;

  Guiche := StrToIntDef(ParamStr(1), -1);
  Senha  := ParamStr(2);
  Tipo   := StrToIntDef(ParamStr(3), Low(Integer));

  if Guiche < 0 then begin WriteLn('Guiche invalido. Deve ser inteiro >= 0.'); Halt(1); end;
  if Trim(Senha) = '' then begin WriteLn('Senha vazia nao eh permitida.'); Halt(1); end;
  if (ParamStr(3) = '') or (Tipo = Low(Integer)) then
  begin
    WriteLn('Tipo invalido. Deve ser inteiro.'); Halt(1);
  end;

  LoadConfig(ConfigFile, Protocol, DatabaseFile, DriverPath);

  if not FileExists(DatabaseFile) then
    WriteLn('Aviso: banco nao encontrado, Zeos criara um novo em: ', DatabaseFile);

  if not EnsureSqliteDllLoaded(DriverPath) then
  begin
    WriteLn('Dica: 64-bit exe -> C:\Windows\System32\sqlite3.dll | 32-bit exe -> C:\Windows\SysWOW64\sqlite3.dll');
    Halt(2);
  end;

  // conecta e insere
  Conn := TZConnection.Create(nil);
  Query := TZQuery.Create(nil);
  try
    Conn.Protocol        := Protocol;                       // 'sqlite-3'
    Conn.Database        := DatabaseFile;                   // caminho completo do .db
    Conn.LibraryLocation := DriverPath;                     // arquivo DLL (Zeos aceita caminho completo)
    Conn.LoginPrompt     := False;

    Conn.Connected := True;

    Query.Connection := Conn;
    Query.SQL.Text :=
      'INSERT INTO registro (guiche, senha, tipo) VALUES (:guiche, :senha, :tipo)';
    Query.ParamByName('guiche').AsInteger := Guiche;
    Query.ParamByName('senha').AsString   := Senha;
    Query.ParamByName('tipo').AsInteger   := Tipo;
    Query.ExecSQL;

    WriteLn('Registro inserido com sucesso!');
    WriteLn('Banco : ', DatabaseFile);
    WriteLn(Format('Valores: guiche=%d, senha="%s", tipo=%d', [Guiche, Senha, Tipo]));
  except
    on E: Exception do
    begin
      WriteLn('Erro: ', E.Message);
      WriteLn('Verifique se a tabela "registro" possui a coluna "tipo" (INTEGER).');
      Halt(2);
    end;
  end;

  Query.Free;
  Conn.Free;
end.

