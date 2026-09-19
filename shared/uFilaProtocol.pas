unit uFilaProtocol;

{$mode objfpc}{$H+}

interface

uses
  SysUtils;

const
  FILA_PORT_GUICHE = 8095;
  FILA_PORT_AUX = 8096;
  FILA_PORT_PAINEL = 8196;

function EncodeCallRequest(AQueueId: Integer; const ADeskId: string): string;
function EncodeTicketResponse(AQueueId: Integer; const ATicket: string): string;
function EncodePanelCall(const ATicket: string; ADeskId, AProtocol: Integer): string;
function EncodeGroup(AGroupId: Integer; const ADescription: string): string;

function TryParseCallRequest(const AData: string; out AQueueId: Integer;
  out ADeskId: string): Boolean;
function TryParseTicketResponse(const AData: string; out AQueueId: Integer;
  out ATicket: string): Boolean;
function TryParsePanelCall(const AData: string; out ATicket, ADeskId: string): Boolean;

implementation

function StripLineBreaks(const S: string): string;
begin
  Result := StringReplace(S, #13, '', [rfReplaceAll]);
  Result := StringReplace(Result, #10, '', [rfReplaceAll]);
end;

function EncodeCallRequest(AQueueId: Integer; const ADeskId: string): string;
begin
  Result := 'Fila:' + IntToStr(AQueueId) + #13 + '>' + Trim(ADeskId) + ';';
end;

function EncodeTicketResponse(AQueueId: Integer; const ATicket: string): string;
begin
  Result := 'Fila:' + IntToStr(AQueueId) + ';' + Trim(ATicket) + #13;
end;

function EncodePanelCall(const ATicket: string; ADeskId, AProtocol: Integer): string;
begin
  if AProtocol = 1 then
    Result := 'FILA:' + Trim(ATicket) + '>' + IntToStr(ADeskId) + ';'
  else
    Result := 'Fila:' + Trim(ATicket) + #13 + '>' + IntToStr(ADeskId) + ';';
end;

function EncodeGroup(AGroupId: Integer; const ADescription: string): string;
begin
  Result := 'GRUPO>' + IntToStr(AGroupId) + ':' + ADescription + ';';
end;

function TryParseCallRequest(const AData: string; out AQueueId: Integer;
  out ADeskId: string): Boolean;
var
  S, QueueText: string;
  PColon, PBreak, PGreater, PSemi: SizeInt;
begin
  Result := False;
  AQueueId := 0;
  ADeskId := '';

  S := Trim(AData);
  if Pos('Fila:', S) <> 1 then
    Exit;

  PColon := Pos(':', S);
  PBreak := Pos(#13, S);
  PGreater := Pos('>', S);
  PSemi := Pos(';', S);

  if (PColon <= 0) or (PGreater <= PColon) or (PSemi <= PGreater) then
    Exit;

  if (PBreak > PColon) and (PBreak < PGreater) then
    QueueText := Copy(S, PColon + 1, PBreak - PColon - 1)
  else
    QueueText := Copy(S, PColon + 1, PGreater - PColon - 1);

  if not TryStrToInt(Trim(QueueText), AQueueId) then
    Exit;

  ADeskId := Trim(Copy(S, PGreater + 1, PSemi - PGreater - 1));
  Result := (AQueueId >= 1) and (AQueueId <= 5) and (ADeskId <> '');
end;

function TryParseTicketResponse(const AData: string; out AQueueId: Integer;
  out ATicket: string): Boolean;
var
  S, QueueText: string;
  PColon, PSemi, PEnd: SizeInt;
begin
  Result := False;
  AQueueId := 0;
  ATicket := '';

  S := AData;
  if Pos('Fila:', S) <> 1 then
    Exit;

  PColon := Pos(':', S);
  PSemi := Pos(';', S);
  if (PColon <= 0) or (PSemi <= PColon) then
    Exit;

  QueueText := Copy(S, PColon + 1, PSemi - PColon - 1);
  if not TryStrToInt(Trim(QueueText), AQueueId) then
    Exit;

  PEnd := Pos(#13, S);
  if PEnd <= PSemi then
    PEnd := Length(S) + 1;

  ATicket := Trim(StripLineBreaks(Copy(S, PSemi + 1, PEnd - PSemi - 1)));
  Result := (AQueueId >= 1) and (AQueueId <= 5) and (ATicket <> '');
end;

function TryParsePanelCall(const AData: string; out ATicket, ADeskId: string): Boolean;
var
  S: string;
  PColon, PGreater, PSemi: SizeInt;
begin
  Result := False;
  ATicket := '';
  ADeskId := '';

  S := AData;
  if (Pos('FILA:', UpperCase(S)) <> 1) then
    Exit;

  PColon := Pos(':', S);
  PGreater := Pos('>', S);
  PSemi := Pos(';', S);
  if (PColon <= 0) or (PGreater <= PColon) or (PSemi <= PGreater) then
    Exit;

  ATicket := Trim(StripLineBreaks(Copy(S, PColon + 1, PGreater - PColon - 1)));
  ADeskId := Trim(StripLineBreaks(Copy(S, PGreater + 1, PSemi - PGreater - 1)));

  Result := (ATicket <> '') and (ADeskId <> '');
end;

end.
