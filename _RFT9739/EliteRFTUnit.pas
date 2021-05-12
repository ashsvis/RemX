unit EliteRFTUnit;

interface

uses
  Windows, Classes, Graphics, EntityUnit;

type

  TEliteNode = class(TEntity)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Channel: word;
      Node: word;
      Actived: boolean;
      FetchTime: Cardinal;
    end;
  protected
  public
    SerialNodeNumber: Integer;
    SerialSensorNumber: Integer;
    Tag: string;
    Desc: string;
    Mess: string;
    Err1: Word;
    Err125: Word;
    Err126: Word;
    constructor Create; override;
    class function EntityType: string; override;
    class function TypeCode: string; override;
    class function TypeColor: TColor; override;
    function PropsCount: integer; override;
    class function PropsID(Index: integer): string; override;
    class function PropsName(Index: integer): string; override;
    function PropsValue(Index: integer): string; override;
    procedure SaveToStream(Stream: TStream); override;
    function LoadFromStream(Stream: TStream): integer; override;
    function Prepare: string; override;
    procedure Fetch(const Data: string); override;
    procedure RequestData; override;
  end;

implementation

uses SysUtils, StrUtils, EliteNDEditUnit, EliteNDPaspUnit;

{ TEliteNode }

constructor TEliteNode.Create;
begin
  inherited;
  FHeaderWait:=False;
  FetchIndex:=0;
  FEntityKind:=ekCustom;
  FIsCustom:=True;
end;

class function TEliteNode.EntityType: string;
begin
  Result:='Массрасходомер Elite RFT9739';
end;

function TEliteNode.Prepare: string;
var S: string;
begin
  case FetchIndex of
   0: S:=Chr(FNode)+#3#0#47#0#2;   // Серийный номер датчика
   1: S:=Chr(FNode)+#3#0#126#0#2;  // Серийный номер сенсора
   2: S:=Chr(FNode)+#3#0#67#0#4;   // Тег
   3: S:=Chr(FNode)+#3#0#95#0#8;   // Дескриптор
   4: S:=Chr(FNode)+#3#0#103#0#16; // Сообщение
   5: S:=Chr(FNode)+#3#0#0#0#1;    // Блок ошибок 1
   6: S:=Chr(FNode)+#3#0#124#0#1;  // Блок ошибок 125
   7: S:=Chr(FNode)+#3#0#125#0#1;  // Блок ошибок 126
  else
    S:='';
  end;
  Result:=S;
end;

procedure TEliteNode.Fetch(const Data: string);
//var
//    LastAlarm: TAlarmState;
//    AlarmFound, HasAlarm, HasConfirm, HasNoLink, HasInfo: boolean;
begin
  inherited;
  if (Copy(Data,1,2) = Chr(FNode)+#$83) and (Length(Data) = 3) then
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
    ErrorMess:='';
    case FetchIndex of
     0: begin
          if Length(Data) = 7 then
            SerialNodeNumber:=((256*Ord(Data[4])+Ord(Data[5])) shl 16)+
                               (256*Ord(Data[6])+Ord(Data[7]));
          FetchIndex:=1;
        end;
     1: begin
          if Length(Data) = 7 then
            SerialSensorNumber:=((256*Ord(Data[4])+Ord(Data[5])) shl 16)+
                                 (256*Ord(Data[6])+Ord(Data[7]));
          FetchIndex:=2;
        end;
     2: begin
          if Length(Data) = 11 then Tag:=Copy(Data,4,Ord(Data[3]));
          FetchIndex:=3;
        end;
     3: begin
          if Length(Data) = 19 then Desc:=Copy(Data,4,Ord(Data[3]));
          FetchIndex:=4;
        end;
     4: begin
          if Length(Data) = 35 then Mess:=Copy(Data,4,Ord(Data[3]));
          FetchIndex:=5;
        end;
     5: begin
          if Length(Data) = 5 then Err1:=256*Ord(Data[4])+Ord(Data[5]);
          FetchIndex:=6;
        end;
     6: begin
          if Length(Data) = 5 then Err125:=256*Ord(Data[4])+Ord(Data[5]);
          FetchIndex:=7;
        end;
     7: begin
          if Length(Data) = 5 then Err126:=256*Ord(Data[4])+Ord(Data[5]);
          FetchIndex:=0;
          UpdateRealTime;
        end;
    end;
    if Err1+Err125+Err126 > 0 then
    begin
      if not (asInfo in AlarmStatus) then
        Caddy.AddAlarm(asInfo,Self);
    end
    else
    begin
      if asInfo in AlarmStatus then
        Caddy.RemoveAlarm(asInfo,Self);
    end;
  end;
end;

function TEliteNode.LoadFromStream(Stream: TStream): integer;
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
  FActived:=Body.Actived;
  FFetchTime:=Body.FetchTime;
end;

procedure TEliteNode.SaveToStream(Stream: TStream);
begin
  Body.PtName:=PtName;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Node;
  Body.Actived:=Actived;
  Body.FetchTime:=FetchTime;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

class function TEliteNode.TypeCode: string;
begin
  Result:='ND';
end;

class function TEliteNode.TypeColor: TColor;
begin
  Result:=$00CCFFCC;
end;

function TEliteNode.PropsCount: integer;
begin
  Result:=6;
end;

class function TEliteNode.PropsID(Index: integer): string;
begin
  case Index of
    0: Result:='PtName';
    1: Result:='PtDesc';
    2: Result:='Channel';
    3: Result:='Node';
    4: Result:='Active';
    5: Result:='FetchTime';
  else
    Result:='Unknown';
  end
end;

class function TEliteNode.PropsName(Index: integer): string;
begin
  case Index of
    0: Result:='Шифр параметра';
    1: Result:='Десктриптор';
    2: Result:='Канал связи';
    3: Result:='Устройство';
    4: Result:='Опрос';
    5: Result:='Время опроса';
  else
    Result:='';
  end
end;

function TEliteNode.PropsValue(Index: integer): string;
begin
  case Index of
    0: Result:=FPtName;
    1: Result:=FPtDesc;
    2: Result:=Format('%d',[FChannel]);
    3: Result:=Format('%d',[FNode]);
    4: Result:=IfThen(FActived,'Да','Нет');
    5: Result:=Format('%d сек',[FFetchTime]);
  else
    Result:='';
  end
end;

procedure TEliteNode.RequestData;
var FL: TList;
begin
  FL:=Caddy.FetchList[FChannel].List;
  if FL.IndexOf(Self) < 0 then
  begin
    FL.Add(Self);
    if Caddy.NetRole <> nrClient then
    begin
      FL.Add(Self);
      FL.Add(Self);
      FL.Add(Self);
      FL.Add(Self);
      FL.Add(Self);
      FL.Add(Self);
      FL.Add(Self);
    end;  
  end;
end;

initialization
{$IFDEF ELITERFT9739}
  with RegisterNode('Массрасходомеры "Elite" RFT9739') do
  begin
    Add(RegisterEntity(TEliteNode));
    RegisterEditForm(TEliteNDEditForm);
    RegisterPaspForm(TEliteNDPaspForm);
  end;
{$ENDIF}
end.
