unit BlockFetchUnit;

interface

type
  TComNum = 1..99;

function KR_Transport(const nCom: TComNum; const Source: ShortString;
                      var Target: ShortString): Boolean;
procedure OpenPort(const nCom: TComNum; const BaudRate: Cardinal;
                   const Parity, ByteSize, StopBits: Byte;
                   const TimeOut: Cardinal);
procedure ClosePort(const nCom: TComNum);

implementation

uses Windows, SysUtils;

type
  TComPort = record
    hCom: Cardinal;
    nCom: Byte;
    nBaudRate, nTimeOut: Cardinal;
    nParity, nByteSize, nStopBits: Byte;
    rDCB: DCB;
    CommTimeouts: TCommTimeouts;
    ReadOverlapped: Overlapped;
    WriteOverlapped: Overlapped;
    TuningValid: boolean;
    TransError: word;
  end;

var
  ComPorts: array[TComNum] of TComPort;

procedure TuningPort(const nCom: TComNum);
begin
  with ComPorts[nCom] do
  begin
    TuningValid:=False;
    if hCom <> INVALID_HANDLE_VALUE then
    begin
      if GetCommState(hCom, rDCB) then
      begin
        rDCB.BaudRate := nBaudRate;
        rDCB.ByteSize := nByteSize;
        rDCB.StopBits := nStopBits;
        rDCB.Parity := nParity;
        if SetCommState(hCom, rDCB) then TuningValid:=True;
      end;
    end;
//  if TuningValid then SaveState;
  end;
end;

procedure TuningTimeOut(const nCom: TComNum);
begin
  with ComPorts[nCom] do
  begin
    if hCom <> INVALID_HANDLE_VALUE then
    begin
      GetCommTimeouts(hCom, CommTimeouts);
      CommTimeouts.WriteTotalTimeoutMultiplier := 1;
      CommTimeouts.ReadTotalTimeoutMultiplier := nTimeOut;
      SetCommTimeouts(hCom, CommTimeouts);
//    SaveState;
    end;
  end;
end;

procedure OpenPort(const nCom: TComNum; const BaudRate: Cardinal;
                   const Parity, ByteSize, StopBits: Byte;
                   const TimeOut: Cardinal);
begin
  with ComPorts[nCom] do
  begin
    nBaudRate := BaudRate; // 57600
    nParity := Parity; // 0 - Not
    nByteSize := ByteSize; // 8
    nStopBits := StopBits; // 0 - 1 stops
    nTimeOut := TimeOut; // 1000 - 1 sec
    hCom := INVALID_HANDLE_VALUE;
    TuningValid := False;
    if nCom > 0 then
      hCom := CreateFile(PChar(Format('COM%d',[nCom])),
                         GENERIC_READ or GENERIC_WRITE, 0, nil,
                         OPEN_EXISTING, FILE_FLAG_OVERLAPPED, 0)
    else
      hCom := INVALID_HANDLE_VALUE;
    if hCom <> INVALID_HANDLE_VALUE then
    begin
      SetupComm(hCom, 512, 512);
// Настроить таймаут
      TuningTimeOut(nCom);
      with ReadOverlapped do
      begin
        Offset := 0;
        OffsetHigh := 0;
        hEvent := CreateEvent(nil, False, False, nil);
      end;
      with WriteOverlapped do
      begin
        Offset := 0;
        OffsetHigh := 0;
        hEvent := CreateEvent(nil, False, False, nil);
      end;
      TuningPort(nCom);
    end
    else
      nCom:=0;
  end;
end;

procedure ClosePort(const nCom: TComNum);
begin
  with ComPorts[nCom] do
  begin
    if hCom <> INVALID_HANDLE_VALUE then
      CloseHandle(hCom);
  end;
end;

function CCS(S: ShortString): byte;
var i: Word; Sum: Integer;
begin
// Контрольная сумма Контрастов
// Инициализация
  Sum:=0; i:=1;
// Все символы строки складываются в Sum,
  while i<=Length(S) do
  begin
    Sum:=Sum+Ord(S[i]);
    Inc(i);
  end;
// Посчет циклических переносов
  while Sum >= 256 do Sum:=Sum mod 256 + Sum div 256;
// Возврат Суммы как символа
  Result:=$100-(Sum and $00FF);
end;

function KR_Transport(const nCom: TComNum; const Source: ShortString;
                      var Target: ShortString): Boolean;
var WriteBuff, ReadBuff: ShortString;
    N: Cardinal;
    TargetLen, CS, B: Byte;
begin
  CS := CCS(Source);
  PurgeComm(ComPorts[nCom].hCom, PURGE_RXCLEAR);
  WriteBuff:=Source + Chr(CS);
  EscapeCommFunction(ComPorts[nCom].hCom, SETRTS);
  SetCommMask(ComPorts[nCom].hCom, EV_TXEMPTY);
  WriteFile(ComPorts[nCom].hCom, WriteBuff[1], Length(WriteBuff), N,
            @ComPorts[nCom].WriteOverlapped);
  GetOverlappedResult(ComPorts[nCom].hCom, ComPorts[nCom].WriteOverlapped, n, True);
  WaitCommEvent(ComPorts[nCom].hCom, N, nil);
  EscapeCommFunction(ComPorts[nCom].hCom, CLRRTS);
  Sleep(5);
  ComPorts[nCom].TransError := 0;
  ReadBuff := '';
  TargetLen := 5;
  Result := False;
// Чтение заголовка телеграммы
  repeat
    ReadFile(ComPorts[nCom].hCom, B, 1, N, @ComPorts[nCom].ReadOverlapped);
    GetOverlappedResult(ComPorts[nCom].hCom, ComPorts[nCom].ReadOverlapped, N, True);
    if N > 0 then ReadBuff := ReadBuff + Chr(B);
    Dec(TargetLen);
  until (N = 0) or (TargetLen = 0);
// Чтение тела телеграммы
  if Length(ReadBuff) = 5 then
  begin
    TargetLen := (Ord(ReadBuff[3]) + 256*Ord(ReadBuff[4])) + 1;
    repeat
      ReadFile(ComPorts[nCom].hCom, B, 1, N, @ComPorts[nCom].ReadOverlapped);
      GetOverlappedResult(ComPorts[nCom].hCom, ComPorts[nCom].ReadOverlapped, N, True);
      if N > 0 then ReadBuff := ReadBuff + Chr(B);
      Dec(TargetLen);
    until (N = 0) or (TargetLen = 0);
    if Length(ReadBuff) = (Ord(ReadBuff[3]) + 256*Ord(ReadBuff[4])) + 6 then
    begin
      Target := Copy(ReadBuff, 1, Length(ReadBuff) - 1);
      CS := CCS(Target);
      if CS = Ord(ReadBuff[Length(ReadBuff)]) then
      begin
        if ((Ord(Target[5]) and $c0) = $c0) and (Length(Target) = 9) then
          ComPorts[nCom].TransError := Ord(Target[8]) + 256*Ord(Target[9]);
        Result := True;
      end;
    end;
  end;
end;

end.
