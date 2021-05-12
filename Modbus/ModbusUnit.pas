unit ModbusUnit;

interface

uses Windows, Classes, Graphics, SysUtils, EntityUnit;

type
  TModbusFormat = (mfUChar,mfChar,mfUInt,mfInt,mfIFloat,
                   mfULong,mfLong,mfEFloat,mfVFloat,mfBCD);
  TAddrPrefix = (apInput,apStatus);

const
  ADataFormat: array[TModbusFormat] of string =
  ('UChar','Char','UInt','Int','IFloat','ULong','Long','EFloat','VFloat','BCD');
  ADigAddrPrefix: array[TAddrPrefix] of string =
             ('Func 2 - Input Status','Func 1 - Coil Status');
  AAnaAddrPrefix: array[TAddrPrefix] of string =
             ('Func 4 - Input Register','Func 3 - Holding Register');

type
  TModbusAnaOut = class(TCustomAnaOut)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Channel: word;
      Node: byte;
      Func: byte;
      Address: word;
      DataFormat: TModbusFormat;
      Actived: boolean;
      Asked: boolean;
      Logged: boolean;
      Trend: boolean;
      CalcScale: boolean;
      FetchTime: Cardinal;
      SourceName: string[10];
      EUDesc: string[10];
      PVFormat: TPVFormat;
      BadDB: TAlarmDeadband;
      HHDB: TAlarmDeadband;
      HiDB: TAlarmDeadband;
      LLDB: TAlarmDeadband;
      LoDB: TAlarmDeadband;
      PVEUHi: Single;
      PVEULo: Single;
      PVHHTP: Single;
      PVHiTP: Single;
      PVLLTP: Single;
      PVLoTP: Single;
    end;
    FDataFormat: TModbusFormat;
    FAddress: Word;
    FAddrPrefix: TAddrPrefix;
    procedure SetAddress(const Value: Word);
    procedure SetDataFormat(const Value: TModbusFormat);
    procedure SetAddrPrefix(const Value: TAddrPrefix);
  protected
  public
    class function EntityType: string; override;
    class function TypeCode: string; override;
    class function TypeColor: TColor; override;
    function PropsCount: integer; override;
    class function PropsName(Index: integer): string; override;
    class function PropsID(Index: integer): string; override;
    function PropsValue(Index: integer): string; override;
    constructor Create; override;
    procedure SaveToStream(Stream: TStream); override;
    procedure SaveToText(List: TStringList); override;
    function LoadFromStream(Stream: TStream): integer; override;
    function Prepare: string; override;
    procedure Fetch(const Data: string); override;
    function AddressEqual(E: TEntity): boolean; override;
    procedure Assign(E: TEntity); override;
    property AddrPrefix: TAddrPrefix read FAddrPrefix write SetAddrPrefix;
    property Address: Word read FAddress write SetAddress;
    property DataFormat: TModbusFormat read FDataFormat write SetDataFormat;
    property PV;
    property EUDesc;
    property PVFormat;
    property BadDB;
    property HHDB;
    property HiDB;
    property LLDB;
    property LoDB;
    property PVEUHi;
    property PVEULo;
    property PVHHTP;
    property PVHiTP;
    property PVLLTP;
    property PVLoTP;
    property Trend;
  end;

  TModbusDigOut = class(TCustomDigOut)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Channel: word;
      Node: byte;
      Func: byte;
      Address: word;
      Actived: boolean;
      Asked: boolean;
      Logged: boolean;
      FetchTime: Cardinal;
      SourceName: string[10];
      Invert: Boolean;
      AlarmDown: Boolean;
      AlarmUp: Boolean;
      SwitchDown: Boolean;
      SwitchUp: Boolean;
      ColorDown: TDigColor;
      ColorUp: TDigColor;
      TextDown: string[10];
      TextUp: string[10];
    end;
    FAddress: Word;
    FAddrPrefix: TAddrPrefix;
    procedure SetAddress(const Value: Word);
    procedure SetAddrPrefix(const Value: TAddrPrefix);
  protected
  public
    class function EntityType: string; override;
    class function TypeCode: string; override;
    class function TypeColor: TColor; override;
    function PropsCount: integer; override;
    class function PropsID(Index: integer): string; override;
    class function PropsName(Index: integer): string; override;
    function PropsValue(Index: integer): string; override;
    constructor Create; override;
    procedure SaveToStream(Stream: TStream); override;
    procedure SaveToText(List: TStringList); override;
    function LoadFromStream(Stream: TStream): integer; override;
    function Prepare: string; override;
    procedure Fetch(const Data: string); override;
    function AddressEqual(E: TEntity): boolean; override;
    procedure Assign(E: TEntity); override;
    property AddrPrefix: TAddrPrefix read FAddrPrefix write SetAddrPrefix;
    property Address: Word read FAddress write SetAddress;
    property PV;
    property Invert;
    property AlarmDown;
    property AlarmUp;
    property SwitchDown;
    property SwitchUp;
    property ColorDown;
    property ColorUp;
    property TextDown;
    property TextUp;
  end;

  TModbusDMGroup = class(TCustomGroup)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Channel: word;
      Node: word;
      Func: byte;
      AddrPrefix: TAddrPrefix;
      Address: word;
      Count: word;
      Actived: boolean;
      FetchTime: Cardinal;
      Childs: array[0..1999] of string[10];
    end;
    FAddrPrefix: TAddrPrefix;
    FDataCount: Word;
    FAddress: Word;
    procedure SetAddress(const Value: Word);
    procedure SetAddrPrefix(const Value: TAddrPrefix);
    procedure SetDataCount(const Value: Word);
  protected
  public
    function GetMaxChildCount: integer; override;
    constructor Create; override;
    class function EntityType: string; override;
    class function TypeCode: string; override;
    class function TypeColor: TColor; override;
    function PropsCount: integer; override;
    class function PropsID(Index: integer): string; override;
    class function PropsName(Index: integer): string; override;
    function PropsValue(Index: integer): string; override;
    procedure SaveToStream(Stream: TStream); override;
    procedure SaveToText(List: TStringList); override;
    function LoadFromStream(Stream: TStream): integer; override;
    function Prepare: string; override;
    procedure Fetch(const Data: string); override;
    function AddressEqual(E: TEntity): boolean; override;
    procedure Assign(E: TEntity); override;
    property AddrPrefix: TAddrPrefix read FAddrPrefix write SetAddrPrefix;
    property Address: Word read FAddress write SetAddress;
    property DataCount: Word read FDataCount write SetDataCount;
  end;

  TModbusAMGroup = class(TCustomGroup)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Channel: word;
      Node: word;
      Func: byte;
      AddrPrefix: TAddrPrefix;
      Address: word;
      DataFormat: TModbusFormat;
      Count: word;
      Actived: boolean;
      FetchTime: Cardinal;
      Childs: array[0..124] of string[10];
    end;
    FAddrPrefix: TAddrPrefix;
    FDataCount: Word;
    FAddress: Word;
    FDataFormat: TModbusFormat;
    procedure SetAddress(const Value: Word);
    procedure SetAddrPrefix(const Value: TAddrPrefix);
    procedure SetDataCount(const Value: Word);
    procedure SetDataFormat(const Value: TModbusFormat);
  protected
  public
    function GetMaxChildCount: integer; override;
    constructor Create; override;
    class function EntityType: string; override;
    class function TypeCode: string; override;
    class function TypeColor: TColor; override;
    function PropsCount: integer; override;
    class function PropsID(Index: integer): string; override;
    class function PropsName(Index: integer): string; override;
    function PropsValue(Index: integer): string; override;
    procedure SaveToStream(Stream: TStream); override;
    procedure SaveToText(List: TStringList); override;
    function LoadFromStream(Stream: TStream): integer; override;
    function Prepare: string; override;
    procedure Fetch(const Data: string); override;
    function AddressEqual(E: TEntity): boolean; override;
    procedure Assign(E: TEntity); override;
    property AddrPrefix: TAddrPrefix read FAddrPrefix write SetAddrPrefix;
    property Address: Word read FAddress write SetAddress;
    property DataFormat: TModbusFormat read FDataFormat write SetDataFormat;
    property DataCount: Word read FDataCount write SetDataCount;
  end;

implementation

uses ModbusAOEditUnit, ModbusAOPaspUnit, ModbusDOEditUnit, ModbusDOPaspUnit,
     StrUtils, ModbusDMEditUnit, ModbusAMEditUnit;

{ TModbusAnaOut }

function TModbusAnaOut.AddressEqual(E: TEntity): boolean;
begin
  with E as TModbusAnaOut do
  begin
    Result:=(Channel = Self.Channel) and
            (Node = Self.Node) and
            (Address = Self.Address);
  end;
end;

procedure TModbusAnaOut.Assign(E: TEntity);
var T: TModbusAnaOut;
begin
  inherited;
  T:=E as TModbusAnaOut;
  FAddress:=T.Address;
  FDataFormat:=T.DataFormat;
  FAddrPrefix:=T.AddrPrefix;
end;

constructor TModbusAnaOut.Create;
begin
  inherited;
  FHeaderWait:=False;
  FDataFormat:=mfInt;
  FAddress:=1;
  FCalcScale:=False;
end;

class function TModbusAnaOut.EntityType: string;
begin
  Result:='Аналоговое значение MODBUS';
end;

procedure TModbusAnaOut.Fetch(const Data: string);
const AFormatDiv: array[TPVFormat] of Single = (1.0,10.0,100.0,1000.0);
      AP: array[TAddrPrefix] of Char = (#$84,#$83);
      APrecign: array[0..7] of Single = (1.0,0.1,0.01,0.001,0.0001,
                                         0.00001,0.000001,0.0000001);
var R,Sign: Single;
    RR: Double;
    I: Longint;
    W: Longword;
    A: array[1..4] of Byte;
  procedure UpdatePV(R1: Double);
  begin
    if FCalcScale then
      PV:=(FPVEUHi-FPVEULo)*(R1/100.0)+FPVEULo
    else
      PV:=R1;
    try
      FRaw:=R1;
    except
      FRaw:=FRaw;
    end;
  end;
begin
  inherited Fetch(Data);
  if (Copy(Data,1,2) = Chr(FNode)+AP[FAddrPrefix]) and (Length(Data) = 3) then
  begin
    case Ord(Data[3]) of
     1: ErrorMess:='Функция в принятом сообщении не поддерживается';
     2: ErrorMess:='Адрес, указанный в поле данных, является недопустимым';
     3: ErrorMess:='Значения в поле данных недопустимы';
     4: ErrorMess:='Устройство не может ответить на запрос или произошла авария';
     5: ErrorMess:='Устройство приняло запрос и начало выполнять '+
                   'долговременную операцию программирования';
     6: ErrorMess:='Сообщение было принято без ошибок, но устройство '+
                   'в данный момент выполняет долговременную операцию '+
                   'программирования. Запрос необходимо ретранслировать позднее.';
     7: ErrorMess:='Функция программирования не может быть выполнена. '+
                   'Произошла аппаратно-зависимая ошибка';
    else
      ErrorMess:='Неизвестная ошибка, код: '+IntToStr(Ord(Data[3]));
    end;
    UpdateRealTime;
  end
  else
  begin
    if not (Length(Data) in [5,7]) then
    begin
      ErrorMess:='Неверная длина ответной телеграммы, получено байт: '+
                 IntToStr(Length(Data));
      UpdateRealTime;
      Exit;
    end;
    case FDataFormat of
  mfUChar:
      if Length(Data) = 5 then
        UpdatePV(Byte(Ord(Data[5])));
  mfChar:
      if Length(Data) = 5 then
        UpdatePV(ShortInt(Ord(Data[5])));
  mfUInt:
      if Length(Data) = 5 then
        UpdatePV(Word((Ord(Data[4]) shl 8)+Ord(Data[5])));
  mfInt:
      if Length(Data) = 5 then
        UpdatePV(SmallInt((Ord(Data[4]) shl 8)+Ord(Data[5])));
  mfIFloat:
      if Length(Data) = 5 then
      begin
        RR:=SmallInt((Ord(Data[4]) shl 8)+Ord(Data[5]));
        try
          FRaw:=RR;
        except
          ErrorMess:='Ошибка присваивания IFloat';
        end;
        if asBadPV in AlarmStatus then Caddy.RemoveAlarm(asBadPV,Self);
        inherited SetPV(RR/AFormatDiv[FPVFormat]);
      end;
  mfULong:
      if Length(Data) = 7 then
      begin
        A[1]:=Ord(Data[7]);
        A[2]:=Ord(Data[6]);
        A[3]:=Ord(Data[5]);
        A[4]:=Ord(Data[4]);
        MoveMemory(@W,@A[1],4);
        UpdatePV(W);
        if asBadPV in AlarmStatus then Caddy.RemoveAlarm(asBadPV,Self);
      end;
  mfLong:
      if Length(Data) = 7 then
      begin
        A[1]:=Ord(Data[7]);
        A[2]:=Ord(Data[6]);
        A[3]:=Ord(Data[5]);
        A[4]:=Ord(Data[4]);
        MoveMemory(@I,@A[1],4);
        UpdatePV(I);
        if asBadPV in AlarmStatus then Caddy.RemoveAlarm(asBadPV,Self);
      end;
  mfEFloat:
      if Length(Data) = 7 then
      begin
        A[1]:=Ord(Data[5]);
        A[2]:=Ord(Data[4]);
        A[3]:=Ord(Data[7]);
        A[4]:=Ord(Data[6]);
        if (A[1] = 0) and (A[2] = 0) and
           (A[3] = 160) and (A[4] = 127) then
        begin
          ErrorMess:='Принятое значение - не число';
          if not (asBadPV in AlarmStatus) then Caddy.AddAlarm(asBadPV,Self);
        end
        else
        begin
          MoveMemory(@R,@A[1],4);
          Raw:=R;
          if asBadPV in AlarmStatus then Caddy.RemoveAlarm(asBadPV,Self);
        end;
      end;
  mfVFloat:
      if Length(Data) = 7 then
      begin
        A[1]:=Ord(Data[7]);
        A[2]:=Ord(Data[6]);
        A[3]:=Ord(Data[5]);
        A[4]:=Ord(Data[4]);
        MoveMemory(@R,@A[1],4);
        Raw:=R;
        if asBadPV in AlarmStatus then Caddy.RemoveAlarm(asBadPV,Self);
      end;
  mfBCD:
      if Length(Data) = 7 then
      begin
        if (Ord(Data[4]) and $80) > 0 then
          Sign:=-1
        else
          Sign:=1;
        R:=0.0;
        R:=R+(Ord(Data[7]) and $0f)+(Ord(Data[7]) shr 4)*10;
        R:=R+((Ord(Data[6]) and $0f)+(Ord(Data[6]) shr 4)*10)*100;
        R:=R+((Ord(Data[5]) and $0f)+(Ord(Data[5]) shr 4)*10)*10000;
        R:=Sign*R*APrecign[Ord(Data[4]) and $07];
        Raw:=R;
        if asBadPV in AlarmStatus then Caddy.RemoveAlarm(asBadPV,Self);
      end;
    end;
    UpdateRealTime;
  end;
end;

function TModbusAnaOut.LoadFromStream(Stream: TStream): integer;
begin
  Result:=SizeOf(Body);
  if (Stream.Size-Stream.Position) < Result then
  begin
    Result:=0;
    Exit;
  end;
  Stream.ReadBuffer(Body,Result);
  FPtName:=Body.PtName;
  FPtDesc:=Body.PtDesc;
  FChannel:=Body.Channel;
  FNode:=Body.Node;
  FAddrPrefix:=TAddrPrefix(Body.Func);
  FAddress:=Body.Address;
  FDataFormat:=Body.DataFormat;
  FActived:=Body.Actived;
  FLogged:=Body.Logged;
  FAsked:=Body.Asked;
  FFetchTime:=Body.FetchTime;
  FSourceName:=Body.SourceName;
  FEUDesc:=Body.EUDesc;
  FPVFormat:=Body.PVFormat;
  FBadDB:=Body.BadDB;
  FHHDB:=Body.HHDB;
  FHiDB:=Body.HiDB;
  FLoDB:=Body.LoDB;
  FLLDB:=Body.LLDB;
  FPVEUHi:=Body.PVEUHi;
  FPVEULo:=Body.PVEULo;
  FPVHHTP:=Body.PVHHTP;
  FPVHiTP:=Body.PVHiTP;
  FPVLoTP:=Body.PVLoTP;
  FPVLLTP:=Body.PVLLTP;
  FTrend:=Body.Trend;
  FIsTrending:=FTrend;
  FCalcScale:=Body.CalcScale;
end;

function TModbusAnaOut.Prepare: string;
const AP: array[TAddrPrefix] of Char = (#$04,#$03);
var S: string;
begin
  if FAddress > 0 then
  begin
    case FDataFormat of
   mfUChar,mfChar,mfUInt,mfInt,mfIFloat:
         S:=Chr(FNode)+AP[FAddrPrefix]+Chr(Hi(FAddress-1))+Chr(Lo(FAddress-1))+#0#1;
   mfULong,mfLong,mfEFloat,mfVFloat,mfBCD:
         S:=Chr(FNode)+AP[FAddrPrefix]+Chr(Hi(FAddress-1))+Chr(Lo(FAddress-1))+#0#2;
    else
      Result:='';     
    end;
    Result:=S;
  end
  else
    Result:='';
end;

function TModbusAnaOut.PropsCount: integer;
begin
  Result:=23;
end;

class function TModbusAnaOut.PropsID(Index: integer): string;
begin
  case Index of
    0: Result:='PtName';
    1: Result:='PtDesc';
    2: Result:='Channel';
    3: Result:='Node';
    4: Result:='AddrPrefix';
    5: Result:='Address';
    6: Result:='DataFormat';
    7: Result:='Active';
    8: Result:='Alarm';
    9: Result:='Confirm';
   10: Result:='Trend';
   11: Result:='FetchTime';
   12: Result:='Source';
   13: Result:='EUDesc';
   14: Result:='FormatPV';
   15: Result:='PVEUHI';
   16: Result:='PVHHTP';
   17: Result:='PVHITP';
   18: Result:='PVLOTP';
   19: Result:='PVLLTP';
   20: Result:='PVEULO';
   21: Result:='BadDB';
   22: Result:='CalcScale';
  else
    Result:='Unknown';
  end
end;

class function TModbusAnaOut.PropsName(Index: integer): string;
begin
  case Index of
    0: Result:='Шифр параметра';
    1: Result:='Десктриптор';
    2: Result:='Канал связи';
    3: Result:='Контроллер';
    4: Result:='Префикс адреса';
    5: Result:='Адрес данных';
    6: Result:='Тип данных';
    7: Result:='Опрос';
    8: Result:='Сигнализация';
    9: Result:='Квитирование';
   10: Result:='Тренд';
   11: Result:='Время опроса';
   12: Result:='Источник данных';
   13: Result:='Размерность';
   14: Result:='Формат PV';
   15: Result:='Верхняя граница шкалы';
   16: Result:='Верхняя предаварийная граница';
   17: Result:='Верхняя предупредительная граница';
   18: Result:='Нижняя предупредительная граница';
   19: Result:='Нижняя предаварийная граница';
   20: Result:='Нижняя граница шкалы';
   21: Result:='Контроль границ шкалы';
   22: Result:='Масштаб по шкале';
  else
    Result:='';
  end
end;

function TModbusAnaOut.PropsValue(Index: integer): string;
var sFormat: string;
begin
  sFormat:='%.'+Format('%d',[Ord(FPVFormat)])+'f';
  DecimalSeparator := '.';
  case Index of
    0: Result:=FPtName;
    1: Result:=FPtDesc;
    2: Result:=Format('%d',[FChannel]);
    3: Result:=Format('%d',[FNode]);
    4: Result:=Format('%s',[Copy(AAnaAddrPrefix[FAddrPrefix],1,7)]);
    5: Result:=Format('%d',[FAddress]);
    6: Result:=ADataFormat[FDataFormat];
    7: Result:=IfThen(FActived,'Да','Нет');
    8: Result:=IfThen(FAsked,'Да','Нет');
    9: Result:=IfThen(FLogged,'Да','Нет');
   10: Result:=IfThen(FTrend,'Да','Нет');
   11: Result:=Format('%d сек',[FFetchTime]);
   12: Result:=IfThen(Assigned(FSourceEntity),FSourceName,'Авто');
   13: Result:=FEUDesc;
   14: Result:=Format('D%d',[Ord(FPVFormat)]);
   15: Result:=Format(sFormat,[FPVEUHi]);
   16: Result:=Format(sFormat,[FPVHHTP])+' '+AAlmDB[FHHDB];
   17: Result:=Format(sFormat,[FPVHITP])+' '+AAlmDB[FHIDB];
   18: Result:=Format(sFormat,[FPVLOTP])+' '+AAlmDB[FLODB];
   19: Result:=Format(sFormat,[FPVLLTP])+' '+AAlmDB[FLLDB];
   20: Result:=Format(sFormat,[FPVEULo]);
   21: Result:=AAlmDB[FBadDB];
   22: Result:=IfThen(FCalcScale,'Да','Нет');
  else
    Result:='';
  end
end;

procedure TModbusAnaOut.SaveToStream(Stream: TStream);
begin
  Body.PtName:=PtName;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Node and $ff;
  Body.Func:=Ord(AddrPrefix);
  Body.Address:=Address;
  Body.DataFormat:=DataFormat;
  Body.Actived:=Actived;
  Body.Logged:=Logged;
  Body.Asked:=Asked;
  Body.FetchTime:=FetchTime;
  Body.SourceName:=SourceName;
  Body.EUDesc:=EUDesc;
  Body.PVFormat:=PVFormat;
  Body.BadDB:=BadDB;
  Body.HHDB:=HHDB;
  Body.HiDB:=HiDB;
  Body.LoDB:=LoDB;
  Body.LLDB:=LLDB;
  Body.PVEUHi:=PVEUHi;
  Body.PVEULo:=PVEULo;
  Body.PVHHTP:=PVHHTP;
  Body.PVHiTP:=PVHiTP;
  Body.PVLoTP:=PVLoTP;
  Body.PVLLTP:=PVLLTP;
  Body.Trend:=Trend;
  Body.CalcScale:=CalcScale;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

procedure TModbusAnaOut.SaveToText(List: TStringList);
begin
  List.Append('[' + PtName + ']');
  List.Append('Plugin=MODBUS');
  List.Append('PtType=AM');
  List.Append('PtKind=1');
  List.Append('PtName=' + PtName);
  List.Append('PtDesc=' + PtDesc);
  List.Append('Channel=' + IntToStr(Channel));
  List.Append('Node=' + IntToStr(Node));
  List.Append('Func=' + AAnaAddrPrefix[AddrPrefix]);
  List.Append('Address=' + IntToStr(Address));
  List.Append('DataFormat=' + ADataFormat[DataFormat]);
  List.Append('Actived=' + IfThen(Actived, 'True', 'False'));
  List.Append('Logged=' + IfThen(Logged, 'True', 'False'));
  List.Append('Asked=' + IfThen(Asked, 'True', 'False'));
  List.Append('FetchTime=' + IntToStr(FetchTime));
  List.Append('SourceName=' + SourceName);
  List.Append('EUDesc=' + EUDesc);
  List.Append('PVFormat=' + Format('D%d',[Ord(PVFormat)]));
  List.Append('BadDB=' + AAlmDB[BadDB]);
  DecimalSeparator := '.';
  List.Append('PVEUHI=' + Format('%.3f',[PVEUHi]));
  List.Append('PVEULO=' + Format('%.3f',[PVEULo]));
  List.Append('PVHHTP=' + Format('%.3f %s',[PVHHTP, AAlmDB[HHDB]]));
  List.Append('PVHITP=' + Format('%.3f %s',[PVHiTP, AAlmDB[HiDB]]));
  List.Append('PVLOTP=' + Format('%.3f %s',[PVLoTP, AAlmDB[LoDB]]));
  List.Append('PVLLTP=' + Format('%.3f %s',[PVLLTP, AAlmDB[LLDB]]));
  List.Append('Trend=' + IfThen(Trend, 'True', 'False'));
  List.Append('CalcScale=' + IfThen(CalcScale, 'True', 'False'));
end;

procedure TModbusAnaOut.SetAddress(const Value: Word);
begin
  if FAddress <> Value then
  begin
    Caddy.AddChange(FPtName,'Адрес данных',IntToStr(FAddress),
                              IntToStr(Value),FPtDesc,Caddy.Autor);
    FAddress := Value;
    Caddy.Changed:=True;
  end;
end;

procedure TModbusAnaOut.SetAddrPrefix(const Value: TAddrPrefix);
begin
  if FAddrPrefix <> Value then
  begin
    Caddy.AddChange(FPtName,'Префикс адреса',AAnaAddrPrefix[FAddrPrefix],
                            AAnaAddrPrefix[Value],FPtDesc,Caddy.Autor);
    FAddrPrefix := Value;
    Caddy.Changed:=True;
  end;
end;

procedure TModbusAnaOut.SetDataFormat(const Value: TModbusFormat);
begin
  if FDataFormat <> Value then
  begin
    Caddy.AddChange(FPtName,'Тип данных',ADataFormat[FDataFormat],
                              ADataFormat[Value],FPtDesc,Caddy.Autor);
    FDataFormat := Value;
    Caddy.Changed:=True;
  end;
end;

class function TModbusAnaOut.TypeCode: string;
begin
  Result:='AM';
end;

class function TModbusAnaOut.TypeColor: TColor;
begin
  Result:=$0099EEFF;
end;

{ TModbusDigOut }

function TModbusDigOut.AddressEqual(E: TEntity): boolean;
begin
  with E as TModbusDigOut do
  begin
    Result:=(Channel = Self.Channel) and
            (Node = Self.Node) and
            (Address = Self.Address);
  end;
end;

procedure TModbusDigOut.Assign(E: TEntity);
var T: TModbusDigOut;
begin
  inherited;
  T:=E as TModbusDigOut;
  FAddress:=T.Address;
  FAddrPrefix:=T.AddrPrefix;
end;

constructor TModbusDigOut.Create;
begin
  inherited;
  FHeaderWait:=False;
  FAddress:=1;
end;

class function TModbusDigOut.EntityType: string;
begin
  Result:='Дискретное значение MODBUS';
end;

procedure TModbusDigOut.Fetch(const Data: string);
const AP: array[TAddrPrefix] of Char = (#$82,#$81);
begin
  inherited;
  if (Copy(Data,1,2) = Chr(FNode)+AP[FAddrPrefix]) and (Length(Data) = 3) then
  begin
    case Ord(Data[3]) of
     1: ErrorMess:='Функция в принятом сообщении не поддерживается';
     2: ErrorMess:='Адрес, указанный в поле данных, является недопустимым';
     3: ErrorMess:='Значения в поле данных недопустимы';
     4: ErrorMess:='Устройство не может ответить на запрос или произошла авария';
     5: ErrorMess:='Устройство приняло запрос и начало выполнять '+
                   'долговременную операцию программирования';
     6: ErrorMess:='Сообщение было принято без ошибок, но устройство '+
                   'в данный момент выполняет долговременную операцию '+
                   'программирования. Запрос необходимо ретранслировать позднее.';
     7: ErrorMess:='Функция программирования не может быть выполнена. '+
                   'Произошла аппаратно-зависимая ошибка';
    else
      ErrorMess:='Неизвестная ошибка, код: '+IntToStr(Ord(Data[3]));
    end;
    UpdateRealTime;
  end
  else
  begin
    if Length(Data) = 4 then
    begin
      ErrorMess:='';
      Raw:=(Ord(Data[4]) and $01)*1.0;
      if asBadPV in AlarmStatus then Caddy.RemoveAlarm(asBadPV,Self);
      UpdateRealTime;
    end
    else
    begin
      ErrorMess:='Неверная длина ответной телеграммы, получено байт: '+
                 IntToStr(Length(Data));
      UpdateRealTime;
      Exit;
    end;
  end;
end;

function TModbusDigOut.LoadFromStream(Stream: TStream): integer;
begin
  Result:=SizeOf(Body);
  if (Stream.Size-Stream.Position) < Result then
  begin
    Result:=0;
    Exit;
  end;
  Stream.ReadBuffer(Body,Result);
  FPtName:=Body.PtName;
  FPtDesc:=Body.PtDesc;
  FChannel:=Body.Channel;
  FNode:=Body.Node;
  FAddrPrefix:=TAddrPrefix(Body.Func);
  FAddress:=Body.Address;
  FActived:=Body.Actived;
  FLogged:=Body.Logged;
  FAsked:=Body.Asked;
  FFetchTime:=Body.FetchTime;
  FSourceName:=Body.SourceName;
  FInvert:=Body.Invert;
  FAlarmDown:=Body.AlarmDown;
  FAlarmUp:=Body.AlarmUp;
  FSwitchDown:=Body.SwitchDown;
  FSwitchUp:=Body.SwitchUp;
  FColorDown:=Body.ColorDown;
  FColorUp:=Body.ColorUp;
  FTextDown:=Body.TextDown;
  FTextUp:=Body.TextUp;
end;

function TModbusDigOut.Prepare: string;
const AP: array[TAddrPrefix] of Char = (#$02,#$01);
var S: string;
begin
  if FAddress > 0 then
  begin
    S:=Chr(FNode)+AP[FAddrPrefix]+Chr(Hi(FAddress-1))+Chr(Lo(FAddress-1))+#0#1;
    Result:=S;
  end
  else
    Result:='';
end;

function TModbusDigOut.PropsCount: integer;
begin
  Result:=20;
end;

class function TModbusDigOut.PropsID(Index: integer): string;
begin
  case Index of
    0: Result:='PtName';
    1: Result:='PtDesc';
    2: Result:='Channel';
    3: Result:='Node';
    4: Result:='AddrPrefix';
    5: Result:='Address';
    6: Result:='Active';
    7: Result:='Alarm';
    8: Result:='Confirm';
    9: Result:='FetchTime';
   10: Result:='Source';
   11: Result:='Invert';
   12: Result:='AlarmOFF';
   13: Result:='AlarmON';
   14: Result:='SwitchOFF';
   15: Result:='SwitchON';
   16: Result:='ColorOFF';
   17: Result:='ColorON';
   18: Result:='TextOFF';
   19: Result:='TextON';
  else
    Result:='Unknown';
  end
end;

class function TModbusDigOut.PropsName(Index: integer): string;
begin
  case Index of
    0: Result:='Шифр параметра';
    1: Result:='Десктриптор';
    2: Result:='Канал связи';
    3: Result:='Контроллер';
    4: Result:='Префикс адреса';
    5: Result:='Адрес данных';
    6: Result:='Опрос';
    7: Result:='Сигнализация';
    8: Result:='Квитирование';
    9: Result:='Время опроса';
   10: Result:='Источник данных';
   11: Result:='Инверсия данных';
   12: Result:='Авария при "1"->"0"';
   13: Result:='Авария при "0"->"1"';
   14: Result:='Переключение при "1"->"0"';
   15: Result:='Переключение при "0"->"1"';
   16: Result:='Цвет при "0"';
   17: Result:='Цвет при "1"';
   18: Result:='Текст при "0"';
   19: Result:='Текст при "1"';
  else
    Result:='';
  end
end;

function TModbusDigOut.PropsValue(Index: integer): string;
begin
  case Index of
    0: Result:=FPtName;
    1: Result:=FPtDesc;
    2: Result:=Format('%d',[FChannel]);
    3: Result:=Format('%d',[FNode]);
    4: Result:=Format('%s',[Copy(ADigAddrPrefix[FAddrPrefix],1,7)]);
    5: Result:=Format('%d',[FAddress]);
    6: Result:=IfThen(FActived,'Да','Нет');
    7: Result:=IfThen(FAsked,'Да','Нет');
    8: Result:=IfThen(FLogged,'Да','Нет');
    9: Result:=Format('%d сек',[FFetchTime]);
   10: Result:=IfThen(Assigned(FSourceEntity),FSourceName,'Авто');
   11: Result:=IfThen(FInvert,'Да','Нет');
   12: Result:=IfThen(FAlarmDown,'Да','Нет');
   13: Result:=IfThen(FAlarmUp,'Да','Нет');
   14: Result:=IfThen(FSwitchDown,'Да','Нет');
   15: Result:=IfThen(FSwitchUp,'Да','Нет');
   16: Result:=StringDigColor[FColorDown];
   17: Result:=StringDigColor[FColorUp];
   18: Result:=FTextDown;
   19: Result:=FTextUp;
  else
    Result:='';
  end
end;

procedure TModbusDigOut.SaveToStream(Stream: TStream);
begin
  Body.PtName:=PtName;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Node and $ff;
  Body.Func:=Ord(AddrPrefix);
  Body.Address:=Address;
  Body.Actived:=Actived;
  Body.Logged:=Logged;
  Body.Asked:=Asked;
  Body.FetchTime:=FetchTime;
  Body.SourceName:=SourceName;
  Body.Invert:=Invert;
  Body.AlarmDown:=AlarmDown;
  Body.AlarmUp:=AlarmUp;
  Body.SwitchDown:=SwitchDown;
  Body.SwitchUp:=SwitchUp;
  Body.ColorDown:=ColorDown;
  Body.ColorUp:=ColorUp;
  Body.TextDown:=TextDown;
  Body.TextUp:=TextUp;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

procedure TModbusDigOut.SaveToText(List: TStringList);
begin
  List.Append('[' + PtName + ']');
  List.Append('Plugin=MODBUS');
  List.Append('PtType=DM');
  List.Append('PtKind=2');
  List.Append('PtName=' + PtName);
  List.Append('PtDesc=' + PtDesc);
  List.Append('Channel=' + IntToStr(Channel));
  List.Append('Node=' + IntToStr(Node));
  List.Append('Func=' + ADigAddrPrefix[AddrPrefix]);
  List.Append('Address=' + IntToStr(Address));
  List.Append('Actived=' + IfThen(Actived, 'True', 'False'));
  List.Append('Logged=' + IfThen(Logged, 'True', 'False'));
  List.Append('Asked=' + IfThen(Asked, 'True', 'False'));
  List.Append('FetchTime=' + IntToStr(FetchTime));
  List.Append('SourceName=' + SourceName);
  List.Append('Invert=' + IfThen(Invert, 'True', 'False'));
  List.Append('AlarmDown=' + IfThen(AlarmDown, 'True', 'False'));
  List.Append('AlarmUp=' + IfThen(AlarmUp, 'True', 'False'));
  List.Append('SwitchDown=' + IfThen(SwitchDown, 'True', 'False'));
  List.Append('SwitchUp=' + IfThen(SwitchUp, 'True', 'False'));
  List.Append('ColorDown=' + StringDigColor[ColorDown]);
  List.Append('ColorUp=' + StringDigColor[ColorUp]);
  List.Append('TextDown=' + TextDown);
  List.Append('TextUp=' + TextUp);
end;

procedure TModbusDigOut.SetAddress(const Value: Word);
begin
  if FAddress <> Value then
  begin
    Caddy.AddChange(FPtName,'Адрес данных',IntToStr(FAddress),
                              IntToStr(Value),FPtDesc,Caddy.Autor);
    FAddress := Value;
    Caddy.Changed:=True;
  end;
end;

procedure TModbusDigOut.SetAddrPrefix(const Value: TAddrPrefix);
begin
  if FAddrPrefix <> Value then
  begin
    Caddy.AddChange(FPtName,'Префикс адреса',ADigAddrPrefix[FAddrPrefix],
                            ADigAddrPrefix[Value],FPtDesc,Caddy.Autor);
    FAddrPrefix := Value;
    Caddy.Changed:=True;
  end;
end;

class function TModbusDigOut.TypeCode: string;
begin
  Result:='DM';
end;

class function TModbusDigOut.TypeColor: TColor;
begin
  Result:=$0099EEFF;
end;

{ TModbusDMGroup }

function TModbusDMGroup.AddressEqual(E: TEntity): boolean;
begin
  with E as TModbusDMGroup do
  begin
    Result:=(Channel = Self.Channel) and
            (Node = Self.Node) and
            (Address = Self.Address);
  end;
end;

constructor TModbusDMGroup.Create;
var i: integer;
begin
  inherited;
  FHeaderWait:=False;
  FAddress:=1;
  FDataCount:=1;
  for i:=0 to FDataCount-1 do EntityChilds[i]:=nil;
end;

class function TModbusDMGroup.EntityType: string;
begin
  Result:='Группа дискретных значений MODBUS';
end;

function TModbusDMGroup.Prepare: string;
const AP: array[TAddrPrefix] of Char = (#$02,#$01);
var S: string;
begin
  if FAddress > 0 then
  begin
    S:=Chr(FNode)+AP[FAddrPrefix]+Chr(Hi(FAddress-1))+Chr(Lo(FAddress-1))+
                                  Chr(Hi(FDataCount))+Chr(Lo(FDataCount));
    Result:=S;
// Тестирование
//    Fetch(Chr(FNode)+AP[FAddrPrefix]+#1#2);
  end
  else
    Result:='';
end;

procedure TModbusDMGroup.Fetch(const Data: string);
const AP: array[TAddrPrefix] of Char = (#$82,#$81);
var BCount,i,NByte: integer; BData,NBit: Byte; B: Boolean;
begin
  inherited;
  if (Copy(Data,1,2) = Chr(FNode)+AP[FAddrPrefix]) and (Length(Data) = 3) then
  begin
    case Ord(Data[3]) of
     1: ErrorMess:='Функция в принятом сообщении не поддерживается';
     2: ErrorMess:='Адрес, указанный в поле данных, является недопустимым';
     3: ErrorMess:='Значения в поле данных недопустимы';
     4: ErrorMess:='Устройство не может ответить на запрос или произошла авария';
     5: ErrorMess:='Устройство приняло запрос и начало выполнять '+
                   'долговременную операцию программирования';
     6: ErrorMess:='Сообщение было принято без ошибок, но устройство '+
                   'в данный момент выполняет долговременную операцию '+
                   'программирования. Запрос необходимо ретранслировать позднее.';
     7: ErrorMess:='Функция программирования не может быть выполнена. '+
                   'Произошла аппаратно-зависимая ошибка';
    else
      ErrorMess:='Неизвестная ошибка, код: '+IntToStr(Ord(Data[3]));
    end;
    UpdateRealTime;
  end
  else
  begin
    BCount:=((FDataCount-1) div 8)+1;
    if Length(Data) = 3+BCount then
    begin
      if Ord(Data[3]) = BCount then
      begin
        for i:=1 to FDataCount do
        begin
          if Assigned(EntityChilds[i-1]) and EntityChilds[i-1].Actived then
          begin
            NByte:=((i-1) div 8)+4;
            BData:=Ord(Data[NByte]);
            NBit:=(i-1) mod 8;
            B:=(BData and Byte(1 shl NBit) > 0);
            if B then
              EntityChilds[i-1].Raw:=1
            else
              EntityChilds[i-1].Raw:=0;
            if asBadPV in EntityChilds[i-1].AlarmStatus then
              Caddy.RemoveAlarm(asBadPV,EntityChilds[i-1]);
          end;
        end;
        UpdateRealTime;
      end
      else
      begin
        ErrorMess:='Неверное число байт длины данных, указано байт: '+
                   IntToStr(Ord(Data[3]));
        UpdateRealTime;
        Exit;
      end;
    end
    else
    begin
      ErrorMess:='Неверная длина ответной телеграммы, получено байт: '+
                 IntToStr(Length(Data));
      UpdateRealTime;
      Exit;
    end;
  end;
end;

function TModbusDMGroup.GetMaxChildCount: integer;
begin
  Result:=FDataCount-1;
end;

function TModbusDMGroup.LoadFromStream(Stream: TStream): integer;
var i: integer;
begin
  Result:=SizeOf(Body);
  if (Stream.Size-Stream.Position) < Result then
  begin
    Result:=0;
    Exit;
  end;
  Stream.ReadBuffer(Body,Result);
  FPtName:=Body.PtName;
  FPtDesc:=Body.PtDesc;
  FChannel:=Body.Channel;
  FNode:=Body.Node;
  FAddrPrefix:=Body.AddrPrefix;
  FAddress:=Body.Address;
  FDataCount:=Body.Count;
  FActived:=Body.Actived;
  FFetchTime:=Body.FetchTime;
  FChilds.Clear;
  for i:=0 to FDataCount-1 do FChilds.AddObject(Body.Childs[i],nil);
end;

function TModbusDMGroup.PropsCount: integer;
begin
  Result:=FDataCount+9;
end;

class function TModbusDMGroup.PropsID(Index: integer): string;
begin
  case Index of
    0: Result:='PtName';
    1: Result:='PtDesc';
    2: Result:='Channel';
    3: Result:='Node';
    4: Result:='AddrPrefix';
    5: Result:='Address';
    6: Result:='DataCount';
    7: Result:='Active';
    8: Result:='FetchTime';
    9..2008: Result:='Output'+IntToStr(Index-9);
  else
    Result:='Unknown';
  end
end;

class function TModbusDMGroup.PropsName(Index: integer): string;
begin
  case Index of
    0: Result:='Шифр параметра';
    1: Result:='Десктриптор';
    2: Result:='Канал связи';
    3: Result:='Контроллер';
    4: Result:='Префикс адреса';
    5: Result:='Адрес данных';
    6: Result:='Количество бит';
    7: Result:='Опрос';
    8: Result:='Время опроса';
    9..2008: Result:='Выход '+IntToStr(Index-9);
  else
    Result:='';
  end
end;

function TModbusDMGroup.PropsValue(Index: integer): string;
begin
  case Index of
    0: Result:=FPtName;
    1: Result:=FPtDesc;
    2: Result:=Format('%d',[FChannel]);
    3: Result:=Format('%d',[FNode]);
    4: Result:=Format('%s',[Copy(ADigAddrPrefix[FAddrPrefix],1,7)]);
    5: Result:=Format('%d',[FAddress]);
    6: Result:=Format('%d',[FDataCount]);
    7: Result:=IfThen(FActived,'Да','Нет');
    8: Result:=Format('%d сек',[FFetchTime]);
    9..2008: if (Index-9 < Count) and Assigned(EntityChilds[Index-9]) then
             Result:=Childs[Index-9]
           else
             Result:='';
  else
    Result:='';
  end
end;

procedure TModbusDMGroup.SaveToStream(Stream: TStream);
var i: integer;
begin
  Body.PtName:=FPtName;
  Body.PtDesc:=FPtDesc;
  Body.Channel:=Channel;
  Body.Node:=FNode;
  Body.AddrPrefix:=FAddrPrefix;
  Body.Address:=FAddress;
  Body.Count:=FDataCount;
  Body.Actived:=FActived;
  Body.FetchTime:=FFetchTime;
  for i:=0 to FDataCount-1 do Body.Childs[i]:='';
  for i:=0 to FDataCount-1 do
  if (i>=0) and (i<2000) then
  begin
    if Assigned(EntityChilds[i]) then
      Body.Childs[i]:=EntityChilds[i].PtName;
  end;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

procedure TModbusDMGroup.SaveToText(List: TStringList);
var i: integer;
begin
  List.Append('[' + PtName + ']');
  List.Append('Plugin=MODBUS');
  List.Append('PtType=DM');
  List.Append('PtKind=3');
  List.Append('PtName=' + PtName);
  List.Append('PtDesc=' + PtDesc);
  List.Append('Channel=' + IntToStr(Channel));
  List.Append('Node=' + IntToStr(Node));
  List.Append('Func=' + ADigAddrPrefix[AddrPrefix]);
  List.Append('Address=' + IntToStr(Address));
  List.Append('DataCount=' + IntToStr(DataCount));
  List.Append('Actived=' + IfThen(Actived, 'True', 'False'));
  List.Append('FetchTime=' + IntToStr(FetchTime));
  for i:=0 to DataCount-1 do
  if (i>=0) and (i<2000) then
     List.Append(Format('Child%d=%s', [i + 1, Body.Childs[i]]));
end;

procedure TModbusDMGroup.SetAddress(const Value: Word);
begin
  if FAddress <> Value then
  begin
    Caddy.AddChange(FPtName,'Адрес данных',IntToStr(FAddress),
                              IntToStr(Value),FPtDesc,Caddy.Autor);
    FAddress := Value;
    Caddy.Changed:=True;
  end;
end;

procedure TModbusDMGroup.SetAddrPrefix(const Value: TAddrPrefix);
begin
  if FAddrPrefix <> Value then
  begin
    Caddy.AddChange(FPtName,'Префикс адреса',ADigAddrPrefix[FAddrPrefix],
                            ADigAddrPrefix[Value],FPtDesc,Caddy.Autor);
    FAddrPrefix := Value;
    Caddy.Changed:=True;
  end;
end;

procedure TModbusDMGroup.SetDataCount(const Value: Word);
var i: integer;
begin
  if FDataCount <> Value then
  begin
    Caddy.AddChange(FPtName,'Кол-во бит',IntToStr(FDataCount),
                             IntToStr(Value),FPtDesc,Caddy.Autor);
    if Value > FDataCount then
    begin
      for i:=FDataCount to Value-1 do
      begin
        FChilds.AddObject(Body.Childs[i],nil);
        EntityChilds[i]:=nil;
      end;
    end
    else if Value < FDataCount then
         begin
           for i:=FDataCount-1 downto Value do
           begin
             EntityChilds[i]:=nil;
             FChilds.Delete(i);
           end;
         end;
    FDataCount := Value;
    Caddy.Changed:=True;
  end;
end;

class function TModbusDMGroup.TypeCode: string;
begin
  Result:='DM';
end;

class function TModbusDMGroup.TypeColor: TColor;
begin
  Result:=$00CC99FF;
end;

procedure TModbusDMGroup.Assign(E: TEntity);
var T: TModbusDMGroup;
begin
  inherited;
  T:=E as TModbusDMGroup;
  FAddress:=T.Address;
  FAddrPrefix:=T.AddrPrefix;
  DataCount:=T.DataCount;
end;

{ TModbusAMGroup }

function TModbusAMGroup.AddressEqual(E: TEntity): boolean;
begin
  with E as TModbusAMGroup do
  begin
    Result:=(Channel = Self.Channel) and
            (Node = Self.Node) and
            (Address = Self.Address);
  end;
end;

procedure TModbusAMGroup.Assign(E: TEntity);
var T: TModbusAMGroup;
begin
  inherited;
  T:=E as TModbusAMGroup;
  FAddress:=T.Address;
  FDataFormat:=T.DataFormat;
  FAddrPrefix:=T.AddrPrefix;
  DataCount:=T.DataCount;
end;

constructor TModbusAMGroup.Create;
var i: integer;
begin
  inherited;
  FHeaderWait:=False;
  FAddress:=1;
  FDataCount:=1;
  FDataFormat:=mfInt;
  for i:=0 to FDataCount-1 do EntityChilds[i]:=nil;
end;

class function TModbusAMGroup.EntityType: string;
begin
  Result:='Группа аналоговых значений MODBUS';
end;

procedure TModbusAMGroup.Fetch(const Data: string);
const AP: array[TAddrPrefix] of Char = (#$84,#$83);
      AN: array[TModbusFormat] of Byte = (2,2,2,2,2,4,4,4,4,4);
      APrecign: array[0..7] of Single = (1.0,0.1,0.01,0.001,0.0001,
                                         0.00001,0.000001,0.0000001);
var BCount,i,NByte: integer;
    II: Longint;
    W: Longword;
    A: array[1..4] of Byte;
    R,Sign: Single;
begin
  inherited;
  if (Copy(Data,1,2) = Chr(FNode)+AP[FAddrPrefix]) and (Length(Data) = 3) then
  begin
    case Ord(Data[3]) of
     1: ErrorMess:='Функция в принятом сообщении не поддерживается';
     2: ErrorMess:='Адрес, указанный в поле данных, является недопустимым';
     3: ErrorMess:='Значения в поле данных недопустимы';
     4: ErrorMess:='Устройство не может ответить на запрос или произошла авария';
     5: ErrorMess:='Устройство приняло запрос и начало выполнять '+
                   'долговременную операцию программирования';
     6: ErrorMess:='Сообщение было принято без ошибок, но устройство '+
                   'в данный момент выполняет долговременную операцию '+
                   'программирования. Запрос необходимо ретранслировать позднее.';
     7: ErrorMess:='Функция программирования не может быть выполнена. '+
                   'Произошла аппаратно-зависимая ошибка';
    else
      ErrorMess:='Неизвестная ошибка, код: '+IntToStr(Ord(Data[3]));
    end;
    UpdateRealTime;
  end
  else
  begin
    BCount:=FDataCount*AN[FDataFormat];
    if Length(Data) = 3+BCount then
    begin
      if Ord(Data[3]) = BCount then
      begin
        for i:=1 to FDataCount do
        begin
          if Assigned(EntityChilds[i-1]) and EntityChilds[i-1].Actived then
          begin
            NByte:=(i-1)*AN[FDataFormat]+4;
            case FDataFormat of
          mfUChar:
              EntityChilds[i-1].Raw:=Byte(Ord(Data[NByte+1]));
          mfChar:
              EntityChilds[i-1].Raw:=ShortInt(Ord(Data[NByte+1]));
          mfUInt:
              EntityChilds[i-1].Raw:=Word((Ord(Data[NByte]) shl 8)+Ord(Data[NByte+1]));
          mfInt:
              EntityChilds[i-1].Raw:=SmallInt((Ord(Data[NByte]) shl 8)+Ord(Data[NByte+1]));
          mfIFloat:
              begin
                EntityChilds[i-1].Raw:=SmallInt((Ord(Data[NByte]) shl 8)+Ord(Data[NByte+1]));
                if asBadPV in EntityChilds[i-1].AlarmStatus then
                  Caddy.RemoveAlarm(asBadPV,EntityChilds[i-1]);
              end;
          mfULong:
              begin
                A[1]:=Ord(Data[NByte+3]);
                A[2]:=Ord(Data[NByte+2]);
                A[3]:=Ord(Data[NByte+1]);
                A[4]:=Ord(Data[NByte]);
                MoveMemory(@W,@A[1],4);
                EntityChilds[i-1].Raw:=W;
                if asBadPV in EntityChilds[i-1].AlarmStatus then
                  Caddy.RemoveAlarm(asBadPV,EntityChilds[i-1]);
              end;
          mfLong:
              begin
                A[1]:=Ord(Data[NByte+3]);
                A[2]:=Ord(Data[NByte+2]);
                A[3]:=Ord(Data[NByte+1]);
                A[4]:=Ord(Data[NByte]);
                MoveMemory(@II,@A[1],4);
                EntityChilds[i-1].Raw:=II;
                if asBadPV in EntityChilds[i-1].AlarmStatus then
                  Caddy.RemoveAlarm(asBadPV,EntityChilds[i-1]);
              end;
          mfEFloat:
              begin
                A[1]:=Ord(Data[NByte+1]);
                A[2]:=Ord(Data[NByte]);
                A[3]:=Ord(Data[NByte+3]);
                A[4]:=Ord(Data[NByte+2]);
                if (A[1] = 0) and (A[2] = 0) and
                   (A[3] = 160) and (A[4] = 127) then
                begin
                  ErrorMess:='Принятое значение - не число';
                  if not (asBadPV in EntityChilds[i-1].AlarmStatus) then
                    Caddy.AddAlarm(asBadPV,EntityChilds[i-1]);
                end
                else
                begin
                  MoveMemory(@R,@A[1],4);
                  EntityChilds[i-1].Raw:=R;
                  if asBadPV in EntityChilds[i-1].AlarmStatus then
                    Caddy.RemoveAlarm(asBadPV,EntityChilds[i-1]);
                end;
              end;
          mfVFloat:
              begin
                A[1]:=Ord(Data[NByte+3]);
                A[2]:=Ord(Data[NByte+2]);
                A[3]:=Ord(Data[NByte+1]);
                A[4]:=Ord(Data[NByte]);
                MoveMemory(@R,@A[1],4);
                EntityChilds[i-1].Raw:=R;
                if asBadPV in EntityChilds[i-1].AlarmStatus then
                  Caddy.RemoveAlarm(asBadPV,EntityChilds[i-1]);
              end;
            mfBCD:
              begin
                if (Ord(Data[NByte]) and $80) > 0 then
                  Sign:=-1
                else
                  Sign:=1;
                R:=0.0;
                R:=R+(Ord(Data[NByte+3]) and $0f)+(Ord(Data[NByte+3]) shr 4)*10;
                R:=R+((Ord(Data[NByte+2]) and $0f)+(Ord(Data[NByte+2]) shr 4)*10)*100;
                R:=R+((Ord(Data[NByte+1]) and $0f)+(Ord(Data[NByte+1]) shr 4)*10)*10000;
                R:=Sign*R*APrecign[Ord(Data[NByte]) and $07];
                EntityChilds[i-1].Raw:=R;
                if asBadPV in EntityChilds[i-1].AlarmStatus then
                  Caddy.RemoveAlarm(asBadPV,EntityChilds[i-1]);
              end;
            end;
          end;
        end;
        UpdateRealTime;
      end
      else
      begin
        ErrorMess:='Неверное число байт длины данных, указано байт: '+
                   IntToStr(Ord(Data[3]));
        UpdateRealTime;
        Exit;
      end;
    end
    else
    begin
      ErrorMess:='Неверная длина ответной телеграммы, получено байт: '+
                 IntToStr(Length(Data));
      UpdateRealTime;
      Exit;
    end;
  end;
end;

function TModbusAMGroup.GetMaxChildCount: integer;
begin
  Result:=FDataCount-1;
end;

function TModbusAMGroup.LoadFromStream(Stream: TStream): integer;
var i: integer;
begin
  Result:=SizeOf(Body);
  if (Stream.Size-Stream.Position) < Result then
  begin
    Result:=0;
    Exit;
  end;
  Stream.ReadBuffer(Body,Result);
  FPtName:=Body.PtName;
  FPtDesc:=Body.PtDesc;
  FChannel:=Body.Channel;
  FNode:=Body.Node;
  FAddrPrefix:=Body.AddrPrefix;
  FAddress:=Body.Address;
  FDataFormat:=Body.DataFormat;
  FDataCount:=Body.Count;
  FActived:=Body.Actived;
  FFetchTime:=Body.FetchTime;
  FChilds.Clear;
  for i:=0 to FDataCount-1 do FChilds.AddObject(Body.Childs[i],nil);
end;

function TModbusAMGroup.Prepare: string;
const AP: array[TAddrPrefix] of Char = (#$04,#$03);
      AN: array[TModbusFormat] of Byte = (1,1,1,1,1,2,2,2,2,2);
var S: string;
begin
  if FAddress > 0 then
  begin
    S:=Chr(FNode)+AP[FAddrPrefix]+Chr(Hi(FAddress-1))+Chr(Lo(FAddress-1))+
        Chr(Hi(FDataCount*AN[FDataFormat]))+Chr(Lo(FDataCount*AN[FDataFormat]));
    Result:=S;
  end
  else
    Result:='';
end;

function TModbusAMGroup.PropsCount: integer;
begin
  Result:=FDataCount+10;
end;

class function TModbusAMGroup.PropsID(Index: integer): string;
begin
  case Index of
    0: Result:='PtName';
    1: Result:='PtDesc';
    2: Result:='Channel';
    3: Result:='Node';
    4: Result:='AddrPrefix';
    5: Result:='Address';
    6: Result:='DataFormat';
    7: Result:='DataCount';
    8: Result:='Active';
    9: Result:='FetchTime';
    10..134: Result:='Output'+IntToStr(Index-10);
  else
    Result:='Unknown';
  end
end;

class function TModbusAMGroup.PropsName(Index: integer): string;
begin
  case Index of
    0: Result:='Шифр параметра';
    1: Result:='Десктриптор';
    2: Result:='Канал связи';
    3: Result:='Контроллер';
    4: Result:='Префикс адреса';
    5: Result:='Адрес данных';
    6: Result:='Тип данных';
    7: Result:='Количество регистров';
    8: Result:='Опрос';
    9: Result:='Время опроса';
    10..134: Result:='Выход '+IntToStr(Index-10);
  else
    Result:='';
  end
end;

function TModbusAMGroup.PropsValue(Index: integer): string;
begin
  case Index of
    0: Result:=FPtName;
    1: Result:=FPtDesc;
    2: Result:=Format('%d',[FChannel]);
    3: Result:=Format('%d',[FNode]);
    4: Result:=Format('%s',[Copy(AAnaAddrPrefix[FAddrPrefix],1,7)]);
    5: Result:=Format('%d',[FAddress]);
    6: Result:=ADataFormat[FDataFormat];
    7: Result:=Format('%d',[FDataCount]);
    8: Result:=IfThen(FActived,'Да','Нет');
    9: Result:=Format('%d сек',[FFetchTime]);
 10..134: if (Index-10 < Count) and Assigned(EntityChilds[Index-10]) then
             Result:=Childs[Index-10]
           else
             Result:='';
  else
    Result:='';
  end
end;

procedure TModbusAMGroup.SaveToStream(Stream: TStream);
var i: integer;
begin
  Body.PtName:=FPtName;
  Body.PtDesc:=FPtDesc;
  Body.Channel:=Channel;
  Body.Node:=FNode;
  Body.AddrPrefix:=FAddrPrefix;
  Body.Address:=FAddress;
  Body.Count:=FDataCount;
  Body.DataFormat:=FDataFormat;
  Body.Actived:=FActived;
  Body.FetchTime:=FFetchTime;
  for i:=0 to FDataCount-1 do Body.Childs[i]:='';
  for i:=0 to FDataCount-1 do
  if (i>=0) and (i<125) then
  begin
    if Assigned(EntityChilds[i]) then
      Body.Childs[i]:=EntityChilds[i].PtName;
  end;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

procedure TModbusAMGroup.SaveToText(List: TStringList);
var i: integer;
begin
  List.Append('[' + PtName + ']');
  List.Append('Plugin=MODBUS');
  List.Append('PtType=AM');
  List.Append('PtKind=3');
  List.Append('PtName=' + PtName);
  List.Append('PtDesc=' + PtDesc);
  List.Append('Channel=' + IntToStr(Channel));
  List.Append('Node=' + IntToStr(Node));
  List.Append('Func=' + AAnaAddrPrefix[AddrPrefix]);
  List.Append('Address=' + IntToStr(Address));
  List.Append('DataCount=' + IntToStr(DataCount));
  List.Append('DataFormat=' + ADataFormat[DataFormat]);
  List.Append('Actived=' + IfThen(Actived, 'True', 'False'));
  List.Append('FetchTime=' + IntToStr(FetchTime));
  for i:=0 to DataCount-1 do
  if (i>=0) and (i<125) then
     List.Append(Format('Child%d=%s', [i + 1, Body.Childs[i]]));
end;

procedure TModbusAMGroup.SetAddress(const Value: Word);
begin
  if FAddress <> Value then
  begin
    Caddy.AddChange(FPtName,'Адрес данных',IntToStr(FAddress),
                              IntToStr(Value),FPtDesc,Caddy.Autor);
    FAddress := Value;
    Caddy.Changed:=True;
  end;
end;

procedure TModbusAMGroup.SetAddrPrefix(const Value: TAddrPrefix);
begin
  if FAddrPrefix <> Value then
  begin
    Caddy.AddChange(FPtName,'Префикс адреса',AAnaAddrPrefix[FAddrPrefix],
                            AAnaAddrPrefix[Value],FPtDesc,Caddy.Autor);
    FAddrPrefix := Value;
    Caddy.Changed:=True;
  end;
end;

procedure TModbusAMGroup.SetDataCount(const Value: Word);
var i: integer;
begin
  if FDataCount <> Value then
  begin
    Caddy.AddChange(FPtName,'Кол-во бит',IntToStr(FDataCount),
                             IntToStr(Value),FPtDesc,Caddy.Autor);
    if Value > FDataCount then
    begin
      for i:=FDataCount to Value-1 do
      begin
        FChilds.AddObject(Body.Childs[i],nil);
        EntityChilds[i]:=nil;
      end;
    end
    else if Value < FDataCount then
         begin
           for i:=FDataCount-1 downto Value do
           begin
             EntityChilds[i]:=nil;
             FChilds.Delete(i);
           end;
         end;
    FDataCount := Value;
    Caddy.Changed:=True;
  end;
end;

procedure TModbusAMGroup.SetDataFormat(const Value: TModbusFormat);
begin
  if FDataFormat <> Value then
  begin
    Caddy.AddChange(FPtName,'Тип данных',ADataFormat[FDataFormat],
                              ADataFormat[Value],FPtDesc,Caddy.Autor);
    FDataFormat := Value;
    Caddy.Changed:=True;
  end;
end;

class function TModbusAMGroup.TypeCode: string;
begin
  Result:='AM';
end;

class function TModbusAMGroup.TypeColor: TColor;
begin
  Result:=$00CC99FF;
end;

initialization
{$IFDEF MODBUSRTU}
  with RegisterNode('Устройства MODBUS RTU') do
  begin
    Add(RegisterEntity(TModbusAnaOut));
    RegisterEditForm(TModbusAOEditForm);
    RegisterPaspForm(TModbusAOPaspForm);
    Add(RegisterEntity(TModbusDigOut));
    RegisterEditForm(TModbusDOEditForm);
    RegisterPaspForm(TModbusDOPaspForm);
    Add(RegisterEntity(TModbusDMGroup));
    RegisterEditForm(TModbusDMEditForm);
    RegisterPaspForm(nil);
    Add(RegisterEntity(TModbusAMGroup));
    RegisterEditForm(TModbusAMEditForm);
    RegisterPaspForm(nil);
  end;
{$ENDIF}
end.
