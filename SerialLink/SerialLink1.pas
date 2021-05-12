unit SerialLink;

interface

uses
  Windows, Messages, SysUtils, Classes;

type
  TByteCount = 0..255;
  TBuff = array [TByteCount] of byte;

  TAShSerial = class;
  TListenThread = class(TThread)
  private
    FAShSerial: TAShSerial;
    FLinkType: integer;
    Buff: TBuff;
    Count: integer;
    DataLen: word;
    procedure UpdateData;
    function MagistrLinkFinished(Buffer: TBuff;
      var ACount: integer; var ADataLen: word): boolean;
    function ModbusRTULinkFinished(Buffer: TBuff;
      var ACount: integer; var ADataLen: word): boolean;
  protected
    procedure Execute; override;
  public
    constructor Create(AShSerial: TAShSerial; ALinkType: integer); reintroduce;
  end;

  TRxMessageEvent = procedure (Sender: TObject;
                       Buff: Pointer; Size: Integer) of object;

  TParity = (paNone,paOdd,paEven,paMark,paSpace);
  TByteSize = 5..8;
  TStopBits = 0..1;
  TAShSerial = class(TComponent)
  private
    FStoreStatus: string;
    FPort: Byte;
    FBaudRate: Cardinal;
    FParity: TParity;
    FByteSize: TByteSize;
    FStopBits: TStopBits;
    FActive: Boolean;
    rDCB: DCB;
    CommTimeouts: TCommTimeouts;
    FTimeOut: Word;
    FOnClose: TNotifyEvent;
    FOnOpen: TNotifyEvent;
    FOnMessage: TRxMessageEvent;
    FBuzy: boolean;
    procedure SetPort(const Value: Byte);
    procedure ReadStrData(Reader: TReader);
    procedure WriteStrData(Writer: TWriter);
    procedure StoreStatus;
    procedure SetBaudRate(const Value: Cardinal);
    procedure SetParity(const Value: TParity);
    procedure SetByteSize(const Value: TByteSize);
    procedure SetStopBits(const Value: TStopBits);
    procedure SetActive(const Value: Boolean);
    procedure TuningPort;
    procedure SetTimeOut(const Value: Word);
    procedure TuningTimeOut;
    procedure TerminateListen;
  protected
    nWriteTimeout: Cardinal;
    ReadOverlapped: Overlapped;
    WriteOverlapped: Overlapped;
    FBuffer: TBuff;
    FBytesCount: Integer;
    ListenThread: TListenThread;
    procedure OpenPort; virtual;
    procedure ClosePort; virtual;
    procedure DefineProperties(Filer: TFiler); override;
  public
    Handle: THandle;
    Index: integer;
    LinkType: integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure Open;
    procedure Close;
    function GetStoreStatus: string;
    procedure SetStoreStatus(Value: string);
    procedure SendMessage(Text: string);
    property Busy: boolean read FBuzy write FBuzy;
  published
    property Port: Byte read FPort write SetPort
                stored False default 1;
    property BaudRate: Cardinal read FBaudRate write SetBaudRate
                stored False default 19200;
    property Parity: TParity read FParity write SetParity
                stored False default paNone;
    property ByteSize: TByteSize read FByteSize write SetByteSize
                stored False default 8;
    property StopBits: TStopBits read FStopBits write SetStopBits
                stored False default 0;
    property TimeOut: Word read FTimeOut write SetTimeOut
                stored False default 300;
    property Active : Boolean read FActive write SetActive
                stored False default False;
    property OnOpen: TNotifyEvent read FOnOpen write FOnOpen;
    property OnClose: TNotifyEvent read FOnClose write FOnClose;
    property OnMessage: TRxMessageEvent read FOnMessage write FOnMessage;
  end;

//procedure Register;

implementation

const CParity: array[TParity] of Char = ('N','O','E','M','S');
      CActive: array[Boolean] of Char = ('N','Y');

//procedure Register;
//begin
//  RegisterComponents('RemX', [TAShSerial]);
//end;

{ TRxSerial }

constructor TAShSerial.Create(AOwner: TComponent);
begin
  inherited;
  nWriteTimeout := 1;
  Handle := INVALID_HANDLE_VALUE;
  FPort := 1;
  FBaudRate := 19200;
  FParity := paNone;
  FByteSize := 8;
  FStopBits := 0;
  FTimeOut := 300;
  FActive := False;
  StoreStatus;
end;

procedure TAShSerial.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('PortStatus',ReadStrData,WriteStrData,FStoreStatus <> '');
end;

destructor TAShSerial.Destroy;
begin
  ClosePort;
  inherited;
end;

procedure TAShSerial.Loaded;
begin
  inherited;
  SetStoreStatus(FStoreStatus);
end;

procedure TAShSerial.ReadStrData(Reader: TReader);
begin
  FStoreStatus := Reader.ReadString;
end;

procedure TAShSerial.SetActive(const Value: Boolean);
begin
  if FActive <> Value then
  begin
    FActive := Value;
    StoreStatus;
    if FActive then
      OpenPort
    else
      ClosePort;
  end;
end;

procedure TAShSerial.SetBaudRate(const Value: Cardinal);
begin
  case Value of
    CBR_1200,CBR_2400,CBR_4800,CBR_9600,CBR_14400,
    CBR_19200,CBR_38400,CBR_57600,CBR_115200:
    begin
      FBaudRate := Value;
      StoreStatus;
      TuningPort;
    end
    else
      raise Exception.CreateFmt('COM%d: Ошибка настройки скорости порта!',
                                [FPort]);
  end;
end;

procedure TAShSerial.SetByteSize(const Value: TByteSize);
begin
  if (Value in [6..8]) and (FStopBits in [0,1]) or
     (Value = 5) and (FStopBits = 0) then
  begin
    FByteSize := Value;
    StoreStatus;
    TuningPort;
  end
  else
    raise Exception.CreateFmt('COM%d: Ошибка настройки размера байта!',
                              [FPort]);
end;

procedure TAShSerial.SetParity(const Value: TParity);
begin
  FParity := Value;
  StoreStatus;
  TuningPort;
end;

procedure TAShSerial.SetPort(const Value: Byte);
begin
  if Value in [1..255] then
  begin
    FPort := Value;
    StoreStatus;
    Active := False;
  end
  else
    raise Exception.Create('Ошибка настройки номера порта!');
end;

procedure TAShSerial.SetStopBits(const Value: TStopBits);
begin
  if (FByteSize in [6..8]) and (Value in [0,1]) or
     (FByteSize = 5) and (Value = 0) then
  begin
    FStopBits := Value;
    StoreStatus;
    TuningPort;
  end
  else
    raise Exception.CreateFmt('COM%d: Ошибка настройки стоповых бит!',[FPort]);
end;

procedure TAShSerial.StoreStatus;
begin
  FStoreStatus := Format('COM%d:%d,%s,%d,%d,%s,%d',
    [FPort,FBaudRate,CParity[FParity],FByteSize,Ord(FStopBits),
     CActive[FActive],FTimeOut]);
end;

procedure TAShSerial.WriteStrData(Writer: TWriter);
begin
  Writer.WriteString(FStoreStatus);
end;

procedure TAShSerial.OpenPort;
begin
  if csDesigning in ComponentState then Exit;
  if Handle <> INVALID_HANDLE_VALUE then Exit;
  if FPort > 0 then
    Handle:=CreateFile(PChar(Format('\\.\COM%d',[FPort])),
                     GENERIC_READ or GENERIC_WRITE,0,nil,
                     OPEN_EXISTING,FILE_FLAG_OVERLAPPED,0)
  else
    Handle:=INVALID_HANDLE_VALUE;
  if Handle <> INVALID_HANDLE_VALUE then
  begin
    SetupComm(Handle,SizeOf(FBuffer),SizeOf(FBuffer));
// Настроить таймаут
    TuningTimeOut;
    with ReadOverlapped do
    begin
      Offset:=0;
      OffsetHigh:=0;
      hEvent:=CreateEvent(nil,False,False,nil);
    end;
    with WriteOverlapped do
    begin
      Offset:=0;
      OffsetHigh:=0;
      hEvent:=CreateEvent(nil,False,False,nil);
    end;
    TuningPort;
    if Assigned(FOnOpen) then FOnOpen(Self);
  end
  else
  begin
    FActive := False;
    raise Exception.CreateFmt('Порт COM%d недоступен!',[FPort]);
  end;
  ListenThread:=TListenThread.Create(Self,LinkType);
end;

procedure TAShSerial.ClosePort;
begin
  if csDesigning in ComponentState then Exit;
  TerminateListen;
  if Handle <> INVALID_HANDLE_VALUE then
  begin
    with ReadOverlapped do CloseHandle(hEvent);
    with WriteOverlapped do CloseHandle(hEvent);
    CloseHandle(Handle);
    Handle := INVALID_HANDLE_VALUE;
    if Assigned(FOnClose) then FOnClose(Self);
  end;
end;

procedure TAShSerial.TuningPort;
begin
  if Handle <> INVALID_HANDLE_VALUE then
  begin
    if GetCommState(Handle,rDCB) then
    begin
      rDCB.BaudRate:=FBaudRate;
      rDCB.ByteSize:=FByteSize;
      rDCB.StopBits:=Ord(FStopBits);
      rDCB.Parity:=Ord(FParity);
      if not SetCommState(Handle,rDCB) then
        raise Exception.CreateFmt('COM%d: Ошибка настройки порта!',[FPort]);
      nWriteTimeOut:=1+rDCB.ByteSize;
      if rDCB.Parity > 0 then nWriteTimeOut:=nWriteTimeOut+1;
      if rDCB.StopBits > 0 then
        nWriteTimeOut:=nWriteTimeOut+2
      else
        nWriteTimeOut:=nWriteTimeOut+1;
      nWriteTimeOut:=(1000 div (rDCB.BaudRate div nWriteTimeOut))+1;
    end;
  end;
end;

procedure TAShSerial.TuningTimeOut;
begin
  if Handle <> INVALID_HANDLE_VALUE then
  begin
    GetCommTimeouts(Handle,CommTimeouts);
    CommTimeouts.WriteTotalTimeoutMultiplier:=FTimeOut;
    CommTimeouts.ReadTotalTimeoutMultiplier:=FTimeOut;
    SetCommTimeouts(Handle,CommTimeouts);
  end;
end;

procedure TAShSerial.SetTimeOut(const Value: Word);
begin
  if Value > 0 then
  begin
    FTimeOut := Value;
    StoreStatus;
  end
  else
    raise Exception.CreateFmt('COM%d: Ошибка настройки таймаута!',[FPort]);
end;

procedure TAShSerial.Close;
begin
  Active := False;
end;

procedure TAShSerial.Open;
begin
  FBuzy:=False;
  Active := True;
end;

function TAShSerial.GetStoreStatus: string;
begin
  Result := FStoreStatus;
end;

procedure TAShSerial.SetStoreStatus(Value: string);
var S: string;
begin
  FStoreStatus := Value;
  S:=FStoreStatus;
  FPort:=StrToInt(Copy(S,4,Pos(':',S)-4));
  Delete(S,1,Pos(':',S));
  FBaudRate:=StrToInt(Copy(S,1,Pos(',',S)-1));
  Delete(S,1,Pos(',',S));
  case S[1] of
   'N': FParity := paNone;
   'O': FParity := paOdd;
   'E': FParity := paEven;
   'M': FParity := paMark;
   'S': FParity := paSpace;
  end;
  Delete(S,1,Pos(',',S));
  FByteSize:=StrToInt(Copy(S,1,Pos(',',S)-1));
  Delete(S,1,Pos(',',S));
  FStopBits:=TStopBits(StrToInt(Copy(S,1,Pos(',',S)-1)));
  Delete(S,1,Pos(',',S));
  case S[1] of
   'N': FActive := False;
   'Y': FActive := True;
  end;
  Delete(S,1,Pos(',',S));
  FTimeOut:=StrToInt(S);
  if FActive then
    OpenPort
  else
    ClosePort;
end;

procedure TAShSerial.SendMessage(Text: string);
var Buffer: TBuff; Len: Integer; N,LastError: Cardinal;
begin
  if (Text <> '') and (Handle <> INVALID_HANDLE_VALUE) then
  begin
    FBuzy:=True;
    ZeroMemory(@Buffer[0],SizeOf(Buffer));
    Len:=Length(Text); if Len > SizeOf(Buffer) then Len := SizeOf(Buffer);
    MoveMemory(@Buffer[0],@Text[1],Len);
// Отправка телеграммы
    PurgeComm(Handle,PURGE_RXCLEAR or PURGE_TXCLEAR);
    EscapeCommFunction(Handle,SETDTR);
    SetCommMask(Handle,EV_TXEMPTY);
    if not WriteFile(Handle,Buffer,Len,N,@WriteOverlapped) then
    begin
      LastError:=GetLastError;
      if LastError = ERROR_IO_PENDING then
      begin
        if GetOverLappedResult(Handle,WriteOverlapped,N,True) then
          ResetEvent(WriteOverlapped.hEvent);
      end;
    end;
    if not GetOverlappedResult(Handle,WriteOverlapped,N,True) then
    begin
      LastError:=GetLastError;
      if LastError = ERROR_IO_PENDING then
      begin
        if GetOverLappedResult(Handle,WriteOverlapped,N,True) then
          ResetEvent(WriteOverlapped.hEvent);
      end;
    end;
    EscapeCommFunction(Handle,CLRDTR);
    Sleep(2);
  end;
end;

procedure TAShSerial.TerminateListen;
begin
  if ListenThread <> nil then
  begin
    if not ListenThread.Terminated then
    begin
      ListenThread.Terminate;
      repeat Sleep(1); until ListenThread.Terminated;
      ListenThread.Free;
      ListenThread := nil;
    end;
  end;
end;

{ TListenThread }

constructor TListenThread.Create(AShSerial: TAShSerial; ALinkType: integer);
begin
  FAShSerial := AShSerial;
  FLinkType := ALinkType;
  inherited Create(True);
  Resume;
end;

function TListenThread.MagistrLinkFinished(Buffer: TBuff;
                            var ACount: integer; var ADataLen: word): boolean;
  function CCS(ABuff: TBuff; LastByte: TByteCount): Byte;
  var i: TByteCount; Sum: Integer;
  begin
    Sum:=0;
    for i:=0 to LastByte do Sum:=Sum+ABuff[i];
    while Sum >= 256 do Sum:=Sum mod 256 + Sum div 256;
    Result:=$100-(Sum and $00FF);
  end;
begin
  Result:=False;
  if ACount = 3 then
  begin
    ADataLen:=Buffer[2]+256*Buffer[3];
    if (ADataLen < 2) or (ADataLen > 122) then
    begin
      ACount:=0;
      Result:=True;
      Exit;
    end;
  end;
  if ACount = ADataLen+5 then
  begin
    if Buffer[ACount] <> CCS(Buffer,ACount-1) then ACount:=0;
    Result:=True;
  end;
end;

function TListenThread.ModbusRTULinkFinished(Buffer: TBuff;
                            var ACount: integer; var ADataLen: word): boolean;
var CCW: word;
  function RTUCRC(ABuff: TBuff; LastByte: TByteCount): Word;
  var i,j: integer; Flag: Boolean;
  begin
    Result:=$FFFF;
    for i:=0 to LastByte do
    begin
      Result:=Result xor Ord(ABuff[i]);
      for j:=1 to 8 do
      begin
        Flag:=(Result and $0001) > 0;
        Result:=Result shr 1;
        if Flag then Result:=Result xor $A001;
      end;
    end;
  end;
begin
  Result:=False;
  if ACount = 2 then
  begin
    if (Buffer[1] and $80) > 0 then
      ADataLen:=5
    else
      case Buffer[1] of
   1..4,17,65: ADataLen:=3+Buffer[2]+2;
     5,6,8,16: ADataLen:=8;
            7: ADataLen:=5;
      else
        begin
          ACount:=0;
          Result:=True;
          Exit;
        end;
      end;
  end;
  if ACount = ADataLen-1 then
  begin
    CCW:=RTUCRC(Buffer,ACount-2);
    if Buffer[ACount-1]+256*Buffer[ACount] <> CCW then ACount:=0;
    ACount:=ACount-1;
    Result:=True;
  end;
end;

procedure TListenThread.Execute;
var N,EC: Cardinal; TS: Integer; ErrorFound: boolean;
begin
  ErrorFound:=True;
  EC:=GetTickCount;
  repeat
    with FAShSerial do
    begin
      Count:=0;
      DataLen:=0;
      PurgeComm(Handle,PURGE_RXCLEAR);
      ZeroMemory(@Buff[0],SizeOf(Buff));
      repeat
        if Handle = INVALID_HANDLE_VALUE then
        begin
          FBytesCount:=0;
          Count:=0;
          Break;
        end;
        if not ReadFile(Handle,Buff[Count],1,N,@ReadOverlapped) and
           (GetLastError = ERROR_IO_PENDING) then
        begin
          TS:=1000;
          repeat
            if GetOverLappedResult(Handle,ReadOverlapped,N,False) then
            begin
              ResetEvent(ReadOverlapped.hEvent);
              Break;
            end;
            Sleep(1);
            Dec(TS);
          until Terminated or (TS < 0);
          if Terminated or (TS < 0) then
          begin
            Count:=0;
            Break;
          end;
        end;
        if N = 1 then
        begin
          if Count > High(Buff) then Break;
          case FLinkType of
            0: if MagistrLinkFinished(Buff,Count,DataLen) then Break;
            1: if ModbusRTULinkFinished(Buff,Count,DataLen) then Break;
          else
            begin
              Count:=0;
              Break;
            end;
          end;
          Inc(Count);
        end;
        if N = 0 then
        begin
          if GetTickCount - EC > 15 then
          begin
            ErrorFound:=False;
            Break;
          end;
        end;
      until Terminated;
      if not Terminated then
      begin
        if Count > 0 then
        begin
          EC:=GetTickCount;
          ErrorFound:=False;
          Synchronize(UpdateData);
          Sleep(10);
        end
        else
        if (N = 0) and not ErrorFound then
        begin
          ErrorFound:=True;
          Synchronize(UpdateData);
          Sleep(10);
        end;
      end;
    end; {with}
  until Terminated;
end;

procedure TListenThread.UpdateData;
begin
  with FAShSerial do
  try
    FBuzy:=False;
    MoveMemory(@FBuffer[0],@Buff[0],Count);
    FBytesCount:=Count;
    if Assigned(FOnMessage) then FOnMessage(FAShSerial,@FBuffer,FBytesCount);
  except
    Windows.Beep(500,30);
  end;
end;


end.





