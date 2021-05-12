unit ResursGLHUnit;

interface

uses Windows, Classes, Graphics, SysUtils, EntityUnit;

const
  AEUDesc: array[0..10] of string =
   ('ГДж/ч','ГКал/ч','т/ч','м3/ч','Относительная единица',
    '%','МПа','кПа','кгс/см2','кгс/м2','°C');
  AStatus: array[0..2]  of string = ('Норма','Меньше нормы','Больше нормы');
  ASensorType: array[0..10]  of string =
    ('---','Р бар','Р абс','Р изб','DP лин','DP кор','Т',
     'Т ГВС прямая','Т ГВС обратная','Т нар.воздуха','Расходомер');
  AInputRange: array[0..3]  of string =
    ('Не задан','0..5 мА','0-20 мА','4-20 мА');
  AEUDesc66_1: array[0..3] of string = ('ГДж/ч','ГКал/ч','т/ч','м3/ч');
  AEUDesc66_2: array[0..4] of string = ('МПа','кПа','кгс/см2','кгс/м2','°C');
  AEUDesc66_3: array[0..1] of string = ('ГДж','ГКал');
  AStatus66: array[1..8] of string =
    ('Отказ','Не задан','???','< XL','> XH','Самоход','> L max','Калибровка');
  ANodeLog: array[0..3] of string =
    ('Останов','Пуск','Коррекция','Пароль снят');
  AChanLog: array[0..6] of string =
    ('Работа','Отказ','Норма','Меньше нормы','Больше нормы',
     'Калибровка ВЫКЛ','Калибровка ВКЛ');
  APointLog: array[0..14] of string =
    ('Q норма','Q меньше нормы','Q больше нормы',
     'G норма','G меньше нормы','G больше нормы',
     'Учет снят','Учет','Изменение CO2','Изменение N2',
     'Изм. плотности','Изм. вязкости','Изм. сжимаемости',
     'Изм. адиабаты','Изменение энтальпии');
  AGroupLog: array[0..2] of string =
    ('Норма','Меньше нормы','Больше нормы');

type
  TBlockType = (btComm22,btComm66);
const
  ABlockType: array[TBlockType] of string =
   ('Значения по группам учета',
    'Значения по каналам, точкам учета и общие данные');

type
  TCommand22 = array[0..5039] of Byte;
  TCommand66 = array[0..2586] of Byte;

  TResursGLHNode = class(TEntity)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Channel: word;
      Actived: boolean;
      FetchTime: Cardinal;
    end;
  protected
    function GetFetchData: string; override;
  public
    Hour,Min,Sec,Day,Month,Year,BlockNo,BlockLength,BlockUsed: Byte;
    PrevDay,PrevMonth,PrevYear: Byte;
    LastDay,LastMonth,LastYear: Byte;
    Comm22: TCommand22;
    Comm66: TCommand66;
    GroupsReady,ChanPointsReady: boolean;
    BlockType: TBlockType;
    constructor Create; override;
    class function EntityType: string; override;
    class function TypeCode: string; override;
    class function TypeColor: TColor; override;
    procedure SaveToStream(Stream: TStream); override;
    function LoadFromStream(Stream: TStream): integer; override;
    function Prepare: string; override;
    procedure Fetch(const Data: string); override;
    function B2D(Value: byte): byte;
  end;

implementation



{ TResursGLHNode }

constructor TResursGLHNode.Create;
var i: integer;
begin
  inherited;
  GroupsReady:=False;
  ChanPointsReady:=False;
  FEntityKind:=ekCustom;
  FIsCustom:=True;
  for i:=0 to 5039 do Comm22[i]:=0;
  for i:=0 to 2586 do Comm66[i]:=0;
  FHeaderWait:=True;
  FetchIndex:=0;
  BlockType:=btComm66;
  BlockUsed:=21;
end;

class function TResursGLHNode.EntityType: string;
begin
  Result:='Преобразователь "Ресурс-GLH"';
end;

function TResursGLHNode.Prepare: string;
var n: byte;
begin
  case BlockType of
    btComm22: begin
                n:=$22;
                BlockUsed:=40;
              end;
    btComm66: begin
                n:=$66;
                BlockUsed:=21;
              end;
  else
    begin
      n:=$0;
      BlockUsed:=0;
    end;
  end;
  case FetchIndex of
    0: begin
         Result:=Chr(n)+Chr(n)+Chr(n xor $ff)+Chr($0d); // Запрос начала блока
       end;
    1: begin
         Result:=#$77#$77#$88#$0D;                      // Понял
         FetchIndex:=0;
       end;
    2: begin
         Result:=#$11#$11#$EE#$0D;                      // Не понял
         FetchIndex:=0;
       end;
  else
    Result:='';
  end;
end;

procedure TResursGLHNode.Fetch(const Data: string);
var i: integer; M1,M2: TMemoryStream;
begin
  if Caddy.NetRole = nrClient then
  begin
    M1:=TMemoryStream.Create;
    M2:=TMemoryStream.Create;
    try
      try
        M2.SetSize(Length(Data));
        MoveMemory(M2.Memory,@Data[1],Length(Data));
        DecompressStream(M2,M1);
        M1.Position:=0;
        M1.ReadBuffer(Hour,SizeOf(Hour));
        M1.ReadBuffer(Min,SizeOf(Min));
        M1.ReadBuffer(Sec,SizeOf(Sec));
        M1.ReadBuffer(Day,SizeOf(Day));
        M1.ReadBuffer(Month,SizeOf(Month));
        M1.ReadBuffer(Year,SizeOf(Year));
        M1.ReadBuffer(BlockNo,SizeOf(BlockNo));
        M1.ReadBuffer(BlockLength,SizeOf(BlockLength));
        M1.ReadBuffer(BlockUsed,SizeOf(BlockUsed));
        M1.ReadBuffer(PrevDay,SizeOf(PrevDay));
        M1.ReadBuffer(PrevMonth,SizeOf(PrevMonth));
        M1.ReadBuffer(PrevYear,SizeOf(PrevYear));
        M1.ReadBuffer(LastDay,SizeOf(LastDay));
        M1.ReadBuffer(LastMonth,SizeOf(LastMonth));
        M1.ReadBuffer(LastYear,SizeOf(LastYear));
        M1.ReadBuffer(Comm22,SizeOf(Comm22));
        M1.ReadBuffer(Comm66,SizeOf(Comm66));
        M1.ReadBuffer(GroupsReady,SizeOf(GroupsReady));
        M1.ReadBuffer(ChanPointsReady,SizeOf(ChanPointsReady));
        M1.ReadBuffer(BlockType,SizeOf(BlockType));
        UpdateRealTime;
      except
        Exit;
      end;
    finally
      M2.Free;
      M1.Free;
    end;
    Exit;
  end;
  inherited;
  case FetchIndex of
   0: begin
        if Length(Data) = 138 then
        begin
          Hour:=B2D(Ord(Data[4]));
          Min:=B2D(Ord(Data[5]));
          Sec:=B2D(Ord(Data[6]));
          BlockNo:=Ord(Data[7]);
          BlockLength:=Ord(Data[8]);
          if (Copy(Data,1,3) = #$33#$33#$CC) and
             (BlockNo in [1..BlockUsed]) and
             (BlockLength in [1..128]) and
             (Ord(Data[138]) = $0D) then
          begin
            case BlockType of
        btComm22: for i:=1 to BlockLength do
                      Comm22[i+(BlockNo-1)*128-1]:=Ord(Data[i+8]);
        btComm66: for i:=1 to BlockLength do
                      Comm66[i+(BlockNo-1)*128-1]:=Ord(Data[i+8]);
            end;
            if Caddy.NetRole = nrClient then
              FetchIndex:=0
            else
              FetchIndex:=1;
            UpdateRealTime;
          end
          else
          begin
            if Caddy.NetRole = nrClient then
              FetchIndex:=0
            else
              FetchIndex:=2;
            if RepeatIndex < 3 then
              Inc(RepeatIndex)
            else
            begin
              FetchIndex:=0;
            end;
            UpdateRealTime;
          end;
        end;
        if Length(Data) = 4 then
        begin
          if (Data = #$44#$44#$BB#$0D) or (Data = #$FF#$FF#$FF#$0D) then
          begin
            if Data = #$44#$44#$BB#$0D then
            begin
              if BlockType = btComm66 then
              begin
                Day:=B2D(Comm66[1928]);
                Month:=B2D(Comm66[1929]);
                Year:=B2D(Comm66[1930]);
                PrevDay:=B2D(Comm66[1939]);
                PrevMonth:=B2D(Comm66[1940]);
                PrevYear:=B2D(Comm66[1941]);
                LastDay:=B2D(Comm66[1936]);
                LastMonth:=B2D(Comm66[1937]);
                LastYear:=B2D(Comm66[1938]);
                ChanPointsReady:=True;
              end;
              if BlockType = btComm22 then
              begin
                GroupsReady:=True;
              end;
              if BlockType = High(BlockType) then
                BlockType:=Low(BlockType)
              else
                BlockType:=Succ(BlockType);
            end;
            FetchIndex:=0;
          end
          else
            FetchIndex:=2;
          UpdateRealTime;
        end;
      end
  end;
end;

function TResursGLHNode.LoadFromStream(Stream: TStream): integer;
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
  FActived:=Body.Actived;
  FFetchTime:=Body.FetchTime;
end;

procedure TResursGLHNode.SaveToStream(Stream: TStream);
begin
  Body.PtName:=PtName;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Actived:=Actived;
  Body.FetchTime:=FetchTime;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

class function TResursGLHNode.TypeCode: string;
begin
  Result:='ND';
end;

class function TResursGLHNode.TypeColor: TColor;
begin
  Result:=$00CCFFCC;
end;

function TResursGLHNode.B2D(Value: byte): byte;
begin
  Result:=(Value and $0f)+10*(Value shr 4);
end;

function TResursGLHNode.GetFetchData: string;
var M1,M2: TMemoryStream;
begin
  M1:=TMemoryStream.Create;
  M2:=TMemoryStream.Create;
  try
    M1.WriteBuffer(Hour,SizeOf(Hour));
    M1.WriteBuffer(Min,SizeOf(Min));
    M1.WriteBuffer(Sec,SizeOf(Sec));
    M1.WriteBuffer(Day,SizeOf(Day));
    M1.WriteBuffer(Month,SizeOf(Month));
    M1.WriteBuffer(Year,SizeOf(Year));
    M1.WriteBuffer(BlockNo,SizeOf(BlockNo));
    M1.WriteBuffer(BlockLength,SizeOf(BlockLength));
    M1.WriteBuffer(BlockUsed,SizeOf(BlockUsed));
    M1.WriteBuffer(PrevDay,SizeOf(PrevDay));
    M1.WriteBuffer(PrevMonth,SizeOf(PrevMonth));
    M1.WriteBuffer(PrevYear,SizeOf(PrevYear));
    M1.WriteBuffer(LastDay,SizeOf(LastDay));
    M1.WriteBuffer(LastMonth,SizeOf(LastMonth));
    M1.WriteBuffer(LastYear,SizeOf(LastYear));
    M1.WriteBuffer(Comm22,SizeOf(Comm22));
    M1.WriteBuffer(Comm66,SizeOf(Comm66));
    M1.WriteBuffer(GroupsReady,SizeOf(GroupsReady));
    M1.WriteBuffer(ChanPointsReady,SizeOf(ChanPointsReady));
    M1.WriteBuffer(BlockType,SizeOf(BlockType));
    M1.Position:=0;
    CompressStream(M1,M2);
    M2.Position:=0;
    SetLength(Result,M2.Size);
    MoveMemory(@Result[1],M2.Memory,M2.Size);
  finally
    M2.Free;
    M1.Free;
  end;
end;

initialization
{$IFDEF RESURSGLH}
  with RegisterNode('Преобразователь "Ресурс-GLH"') do
  begin
    Add(RegisterEntity(TResursGLHNode));
    RegisterEditForm(TResursNDEditForm);
    RegisterPaspForm(TResursNDPaspForm);
  end;
{$ENDIF}
end.
