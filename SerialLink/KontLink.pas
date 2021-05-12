unit KontLink;

interface

uses
  Windows, SysUtils, Classes, ComPort, ExtCtrls;

type
  TLinkType = (ltKontrast,ltModbus,ltMetakon,ltElemer);
  TReadDataEvent = procedure (Sender: TObject; const Packet: string;
                              const ErrCode: Cardinal) of object;

  TKontLink = class;                            
 {читающий поток}
  TByteCount = 0..127;
  TNodeCount = 1..31;
  TAlgCount = 1..999;
  TInOut = 1..127;
  TBuff = array [TByteCount] of byte;

  TKontLink = class(TComPort)
  private
    FTimeout: TTimer;
    FByteCount: integer;
    FBuff: string;
    FBusy: boolean;
    ReciAddr,SendAddr,Contr,Func: byte;
    DataLen: word;
    FOnReadData: TReadDataEvent;
    FOnTimeout: TNotifyEvent;
    FLinkType: TLinkType;
    FCSumReturn: boolean;
    procedure PortReadKontPacket(const Packet: Pointer; const Size: Integer;
                                 const ErrCode: Cardinal);
    procedure PortReadModbusPacket(const Packet: Pointer; const Size: Integer;
                                   const ErrCode: Cardinal);
    procedure PortReadMetakonPacket(const Packet: Pointer; const Size: Integer;
                                   const ErrCode: Cardinal);
    procedure PortReadElemerPacket(const Packet: Pointer; const Size: Integer;
                                   const ErrCode: Cardinal);
    procedure PortReadTimeout(Sender: TObject);
    function GetTimeoutInterval: Cardinal;
    procedure SetTimeoutInterval(const Value: Cardinal);
    procedure IncBuffer(B: byte);
    procedure ResetBuffer;
    procedure SetLinkType(const Value: TLinkType);
 //----------------------------------------------------
  protected
    procedure SetReadActive(const Value: Boolean); override;
    function  GetReadActive: Boolean; override;
    function  GetConnected: Boolean; override;
    procedure SetConnected(const Value: Boolean); override;
  public
    Channel: integer;
    class function CCS(S: string): Char;
    class function CRC(S: string): string;
    class function MRC(Data: string): Char;
    class function ERC(Data: string): string;
    constructor Create; override;
    destructor Destroy; override;
    procedure RequestData(Request: string);
    property Busy: boolean read FBusy;
//-------------------------------------------
    {Активность чтения порта}
    property ReadActive: Boolean  read GetReadActive write SetReadActive;
    {Передает строку. В случае успеха возвращает True}
    function WriteString(const S : String) : Boolean; override;
    property Connected: Boolean read GetConnected write SetConnected;
    procedure Open; override;
    procedure Close; override;
    function Connect: Boolean; override;
    function Transport(const Source: ShortString;
                       var Target: ShortString; var TransError: Word): Boolean;
  published
    property OnReadData: TReadDataEvent read FOnReadData write FOnReadData;
    property OnTimeout: TNotifyEvent read FOnTimeout write FOnTimeout;
    property TimeoutInterval: Cardinal read GetTimeoutInterval
                                       write SetTimeoutInterval;
    property LinkType: TLinkType read FLinkType write SetLinkType;
    property CSumReturn: boolean read FCSumReturn write FCSumReturn;
  end;

implementation

uses Forms;

{ TKontLink }

class function TKontLink.CCS(S: string): Char;
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
  Result:=Chr($100-(Sum and $00FF));
end;

class function TKontLink.CRC(S: string): string;
var i,j: integer; Flag: Boolean; Res: word;
begin
// Контрольная сумма Modbus устройств
  Res:=$FFFF;
  for i:=1 to Length(S) do
  begin
    Res:=Res xor Ord(S[i]);
    for j:=1 to 8 do
    begin
      Flag:=(Res and $0001) > 0;
      Res:=Res shr 1;
      if Flag then Res:=Res xor $A001;
    end;
  end;
  Result:=Chr(Lo(Res))+Chr(Hi(Res));
end;

class function TKontLink.MRC(Data: string): Char;
var i,j: integer; DAT,AUX,R: byte;
begin
// Контрольная сумма Метаконов
  R:=$FF;
  for i:=1 to Length(Data) do
  begin
    DAT:=Ord(Data[i]);
    for j:=0 to 7 do
    begin
      AUX:=(DAT xor R) and 1;
      if AUX=1 then R:=R xor $18;
      R:=R shr 1;
      R:=R or (AUX shl 7);
      DAT:=DAT shr 1;
    end;
  end;
  Result:=Chr(R);
end;

class function TKontLink.ERC(Data: string): string;
var i,l: integer; KS: Word;
begin
// Контрольная сумма Элемеров.. TM5103..
  KS:=$FFFF;
  for i:=2 to Length(Data) do
  begin
    KS:=KS xor Ord(Data[i]);
    for l:=1 to 8 do
      if (KS div 2)*2 <> KS then
        KS:=(KS div 2) xor 40961
      else
        KS:=KS div 2;
    Result:=IntToStr(KS);
  end;
end;

constructor TKontLink.Create; 
begin
  inherited;
  FTimeout:=TTimer.Create(nil);
  FTimeout.Enabled:=False;
  FTimeout.OnTimer:=PortReadTimeout;
  FCSumReturn:=False;
  FByteCount:=0;
  OnReadPacket:=PortReadKontPacket;
end;

destructor TKontLink.Destroy;
begin
  ReadActive:=False;
  Close;
  FTimeout.Enabled:=False;
  FTimeout.Free;
  inherited;
end;

function TKontLink.GetTimeoutInterval: Cardinal;
begin
  Result:=FTimeout.Interval;
end;

procedure TKontLink.IncBuffer(B: byte);
begin
  FBuff:=FBuff+Chr(B);
  Inc(FByteCount);
end;

procedure TKontLink.ResetBuffer;
begin
  FBuff:='';
  FByteCount:=0;
  FBusy:=False;
  PurgeComm(FHandle,PURGE_RXCLEAR);
end;

procedure TKontLink.PortReadModbusPacket(const Packet: Pointer;
  const Size: Integer; const ErrCode: Cardinal);
var B: byte; P: PByte; i: integer; Expt: boolean;
begin
  P:=Packet;
  for i:=0 to Size-1 do
  begin
    B:=P^;
    case FByteCount of
      0: begin
           ReciAddr:=B;
           IncBuffer(B);
         end;
      1: begin
           Func:=B;
           IncBuffer(B);
         end;
      2: begin
           DataLen:=B;
           IncBuffer(B);
         end;
    else
      begin
        Inc(FByteCount);
        FBuff:=FBuff+Chr(B);
        Expt:=((Func and $80) > 0);
        if Expt and (FByteCount = 5) or
           not Expt and (FByteCount = (DataLen+5)) then
        begin
          if CRC(Copy(FBuff,1,Length(FBuff)-2)) =
                 Copy(FBuff,Length(FBuff)-1,2) then
          begin
            try
              FTimeout.Enabled:=False;
              if not FCSumReturn then
                FBuff:=Copy(FBuff,1,Length(FBuff)-2);
              if Assigned(FOnReadData) then FOnReadData(Self,FBuff,ErrCode);
            finally
              ResetBuffer;
            end;
            Break;
          end
          else
          begin
            ResetBuffer;
            Break;
          end;
        end;
      end;
    end;
    Inc(P);
  end;
end;

procedure TKontLink.PortReadKontPacket(const Packet: Pointer;
  const Size: Integer; const ErrCode: Cardinal);
var B: byte; P: PByte; i: integer;
begin
  P:=Packet;
  for i:=0 to Size-1 do
  begin
    B:=P^;
    case FByteCount of
      0: begin
           ReciAddr:=B;
           IncBuffer(B);
         end;
      1: begin
           SendAddr:=B;
           IncBuffer(B);
         end;
      2: begin
           DataLen:=B;
           IncBuffer(B);
         end;
      3: begin
           DataLen:=DataLen+(B shl 8);
           if (DataLen < 2) or (DataLen > 122) then
             ResetBuffer
           else
             IncBuffer(B);
         end;
      4: begin
           Contr:=B;
           if (Contr and $80)= 0 then
             ResetBuffer
           else
             IncBuffer(B);
         end;
    else
      begin
        Inc(FByteCount);
        if FByteCount = (DataLen+6) then
        begin
          if CCS(FBuff) = Chr(B) then
          begin
            try
              FTimeout.Enabled:=False;
              if FCSumReturn then
                FBuff:=FBuff+Chr(B);
              if Assigned(FOnReadData) then FOnReadData(Self,FBuff,ErrCode);
            finally
              ResetBuffer;
            end;
            Break;
          end
          else
          begin
            ResetBuffer;
            Break;
          end;
        end
        else
          FBuff:=FBuff+Chr(B);
      end;
    end;
    Inc(P);
  end;
end;

procedure TKontLink.PortReadMetakonPacket(const Packet: Pointer;
  const Size: Integer; const ErrCode: Cardinal);
var B: byte; P: PByte; i: integer;
begin
//  Windows.Beep(500,10);
  P:=Packet;
  for i:=0 to Size-1 do
  begin
    B:=P^;
    case FByteCount of
      0: IncBuffer(B); // DEV - поле сетевого адреса прибора
      1: IncBuffer(B); // CHA - поле адреса канала прибора, нумеруются с нуля
      2: IncBuffer(B); // REG - поле адреса регистра
      3: begin         // CMD - поле команды: 00h-чтение (RD), 01h-запись (WR)
           Func:=B;
           IncBuffer(B);
         end;
      4: begin
           if Func = $00 then
           begin
             IncBuffer(B); // TYP - поле типа данных
             case (B and $0f) of
              0..2: DataLen:=1;
               3,4: DataLen:=2;
              5..7: DataLen:=4;
                 8: DataLen:=8;
             else
               DataLen:=1; // ASCIIZ: 1..32, включая завершающий ноль
             end;
           end
           else
           begin // MRC - поле контрольной суммы
             Inc(FByteCount);
             if (FByteCount = 5) and (MRC(FBuff) = Chr(B)) then
             begin
               try
                 FTimeout.Enabled:=False;
                 if FCSumReturn then
                   FBuff:=FBuff+Chr(B);
                 if Assigned(FOnReadData) then FOnReadData(Self,FBuff,ErrCode);
               finally
                 ResetBuffer;
               end;
               Break;
             end
             else
             begin
               ResetBuffer;
               Break;
             end;
           end;
         end;
    else
      begin
        Inc(FByteCount);
        if FByteCount = (DataLen+6) then
        begin
          if MRC(FBuff) = Chr(B) then
          begin
            try
              FTimeout.Enabled:=False;
              if FCSumReturn then
                FBuff:=FBuff+Chr(B);
              if Assigned(FOnReadData) then FOnReadData(Self,FBuff,ErrCode);
            finally
              ResetBuffer;
            end;
            Break;
          end
          else
          begin
            ResetBuffer;
            Break;
          end;
        end
        else
          FBuff:=FBuff+Chr(B);
      end;
    end;
    Inc(P);
  end;
end;

procedure TKontLink.PortReadElemerPacket(const Packet: Pointer;
  const Size: Integer; const ErrCode: Cardinal);
var B: byte; P: PByte; i: integer; KS: string;
begin
  P:=Packet;
  for i:=0 to Size-1 do
  begin
    B:=P^;
    if Chr(B) in ['0'..'9',':','!',';','-','.','$',#13] then
    begin
      if B = $0D then
      begin
        KS:=FBuff;
        while Pos(';',KS) > 0 do Delete(KS,1,Pos(';',KS));
        FBuff:=Copy(FBuff,1,Pos(KS,FBuff)-1);
        if ERC(FBuff) = KS then
        begin
          try
            FTimeout.Enabled:=False;
            if FCSumReturn then
              FBuff:=FBuff+KS+#13;
            if Assigned(FOnReadData) then FOnReadData(Self,FBuff,ErrCode);
          finally
            ResetBuffer;
          end;
          Break;
        end
        else
        begin
          ResetBuffer;
          Break;
        end;
      end
      else
        IncBuffer(B);
    end;
    Inc(P);
  end;
end;

procedure TKontLink.PortReadTimeout(Sender: TObject);
begin
  FTimeout.Enabled:=False;
  FBuff:='';
  FByteCount:=0;
  Sleep(2);
  FBusy:=False;
  if Assigned(FOnTimeout) then FOnTimeout(Self);
end;

procedure TKontLink.RequestData(Request: string);
begin
  case LinkType of
  ltKontrast:
      begin
        WriteString(Request+CCS(Request));
      end;
    ltModbus:
      begin
        WriteString(Request+CRC(Request));
      end;
  ltMetakon:
      begin
        WriteString(Request+MRC(Request));
      end;
  ltElemer:
      begin
        WriteString(Request+ERC(Request)+#13);
      end;
  end;
  FBusy:=True;
  FTimeout.Enabled:=True;
end;

procedure TKontLink.SetTimeoutInterval(const Value: Cardinal);
begin
  FTimeout.Interval:=Value;
end;

procedure TKontLink.SetLinkType(const Value: TLinkType);
begin
  FLinkType:=Value;
  case FLinkType of
    ltKontrast: OnReadPacket:=PortReadKontPacket;
      ltModbus: OnReadPacket:=PortReadModbusPacket;
     ltMetakon: OnReadPacket:=PortReadMetakonPacket;
     ltElemer: OnReadPacket:=PortReadElemerPacket;
  end;
end;

function TKontLink.WriteString(const S: String): Boolean;
begin
  Result := inherited WriteString(S);
end;

function TKontLink.GetReadActive: Boolean;
begin
  Result := inherited GetReadActive;
end;

procedure TKontLink.SetReadActive(const Value: Boolean);
begin
  inherited SetReadActive(Value);
end;

procedure TKontLink.Close;
begin
  inherited Close;
end;

procedure TKontLink.Open;
begin
  inherited Open;
  FBusy:=False;
end;

function TKontLink.GetConnected: Boolean;
begin
  Result := inherited GetConnected;
end;

procedure TKontLink.SetConnected(const Value: Boolean);
begin
  inherited SetConnected(Value);
end;

function TKontLink.Connect: Boolean;
begin
  Result := inherited Connect;
end;

function TKontLink.Transport(const Source: ShortString;
                             var Target: ShortString;
                             var TransError: Word): Boolean;
var WriteBuff, ReadBuff: ShortString;
    N: Cardinal;
    TargetLen, CS, B: Byte;
    ReadOverlapped: Overlapped;
    WriteOverlapped: Overlapped;
begin
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
  Result := False;
  CS := Ord(CCS(Source));
  PurgeComm(FHandle, PURGE_RXCLEAR);
  WriteBuff:=Source + Chr(CS);
  EscapeCommFunction(FHandle, SETRTS);
  SetCommMask(FHandle, EV_TXEMPTY);
  WriteFile(FHandle, WriteBuff[1], Length(WriteBuff), N, @WriteOverlapped);
  GetOverlappedResult(FHandle, WriteOverlapped, n, True);
  WaitCommEvent(FHandle, N, nil);
  EscapeCommFunction(FHandle, CLRRTS);
  Sleep(1);
  TransError := 0;
  ReadBuff := '';
  TargetLen := 5;
  repeat
    ReadFile(FHandle, B, 1, N, @ReadOverlapped);
    GetOverlappedResult(FHandle, ReadOverlapped, N, True);
    if N > 0 then ReadBuff := ReadBuff + Chr(B);
    Dec(TargetLen);
  until (N = 0) or (TargetLen = 0);
  if Length(ReadBuff) = 5 then
  begin
    TargetLen := (Ord(ReadBuff[3]) + 256*Ord(ReadBuff[4])) + 1;
    repeat
      ReadFile(FHandle, B, 1, N, @ReadOverlapped);
      GetOverlappedResult(FHandle, ReadOverlapped, N, True);
      if N > 0 then ReadBuff := ReadBuff + Chr(B);
      Dec(TargetLen);
    until (N = 0) or (TargetLen = 0);
    if Length(ReadBuff) = (Ord(ReadBuff[3]) + 256*Ord(ReadBuff[4])) + 6 then
    begin
      Target := Copy(ReadBuff, 1, Length(ReadBuff) - 1);
      CS := Ord(CCS(Target));
      if CS = Ord(ReadBuff[Length(ReadBuff)]) then
      begin
        if ((Ord(Target[5]) and $c0) = $c0) and (Length(Target) = 9) then
          TransError := Ord(Target[8]) + 256*Ord(Target[9]);
        Result := True;
      end;
    end;
  end;
end;

end.
