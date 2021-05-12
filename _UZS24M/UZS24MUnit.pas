unit UZS24MUnit;

interface

uses
  Windows, SysUtils, Classes, Graphics, ExtCtrls, Forms, Controls,
  Menus, Messages, EntityUnit;

type
  TUZS24MGroup = class(TCustomGroup)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Channel: word;
      Node: word;
      Actived: boolean;
      FetchTime: Cardinal;
      FirstSource: string[10];
      Childs: array[0..23] of string[10];
      Reserve1: Cardinal;
      Reserve2: Cardinal;
      Reserve3: Cardinal;
      Reserve4: Cardinal;
      Reserve5: Cardinal;
    end;
    FEntFirstSource: TCustomAnaOut;
    FFirstSource: string;
    procedure SetEntFirstSource(const Value: TCustomAnaOut);
  protected
    procedure SetRaw(const Value: Single); override;
    function GetTextValue: string; override;
    function GetPtVal: string; override;
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
    function LoadFromStream(Stream: TStream): integer; override;
    procedure ConnectLinks; override;
    function Prepare: string; override;
    procedure Fetch(const Data: string); override;
    property EntFirstSource: TCustomAnaOut read FEntFirstSource
                                           write SetEntFirstSource;
    property FirstSource: string read FFirstSource;
  end;

implementation

uses StrUtils;

{ TUZS24MGroup }

procedure TUZS24MGroup.ConnectLinks;
var i: integer; E: TEntity;
begin
  E:=Caddy.Find(SourceName);
  if Assigned(E) then
    SourceEntity:=E as TCustomGroup
  else
    SourceEntity:=nil;
  for i:=0 to FChilds.Count-1 do
    FChilds.Objects[i]:=Caddy.Find(FChilds[i]);
end;

constructor TUZS24MGroup.Create;
var i: integer;
begin
  inherited;
  for i:=0 to 23 do EntityChilds[i]:=nil;
end;

class function TUZS24MGroup.EntityType: string;
begin
  Result:='Устройство отключения УЗС-24М';
end;

procedure TUZS24MGroup.Fetch(const Data: string);
var S: string; C: Cardinal; i: integer; E: TEntity;
begin
  inherited;
  if Length(Data) = 6 then
  begin
    if Ord(Data[1]) <> FNode then
      ErrorMess:=Format('Ответ от другого устройства (Устройство: %d)',
                        [Ord(Data[1])])
    else
    begin
      S:=Copy(Data,4,3);
      if Length(S) = 3 then
      begin
        MoveMemory(@C,@S[1],3);
        for i:=0 to Count-1 do
          if FChilds.Objects[i] is TEntity then
          begin
            E:=TEntity(FChilds.Objects[i]);
            if E.Actived then
              E.Raw:=Abs(Integer((C and (1 shl i)) > 0));
          end;
        ErrorMess:='';
        UpdateRealTime;
      end
      else
        ErrorMess:='Ошибка длины телеграммы';
    end;
  end  
  else
    ErrorMess:='Ошибка длины телеграммы';
end;

function TUZS24MGroup.GetMaxChildCount: integer;
begin
  Result:=24;
end;

function TUZS24MGroup.GetPtVal: string;
var I: Cardinal; R: Single;
begin
  R:=Raw;
  MoveMemory(@I,@R,4);
  Result:=IntToHex(I,8);
end;

function TUZS24MGroup.GetTextValue: string;
var I: Cardinal; R: Single;
begin
  R:=Raw;
  MoveMemory(@I,@R,4);
  Result:=IntToHex(I,8);
end;

function TUZS24MGroup.LoadFromStream(Stream: TStream): integer;
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
  FActived:=Body.Actived;
  FFetchTime:=Body.FetchTime;
  FFirstSource:=Body.FirstSource;
  FChilds.Clear;
  for i:=0 to 23 do FChilds.AddObject(Body.Childs[i],nil);
end;

function TUZS24MGroup.Prepare: string;
const
  FAddress1: Word = 1;
  FAddress2: Word = 5;
  FAddress3: Word = 6;
begin
  Result:=Chr(FNode)+#$01+Chr(Hi(FAddress1-1))+Chr(Lo(FAddress1-1))+#0#24;
end;

function TUZS24MGroup.PropsCount: integer;
begin
  Result:=30;
end;

class function TUZS24MGroup.PropsID(Index: integer): string;
begin
  case Index of
    0: Result:='PtName';
    1: Result:='PtDesc';
    2: Result:='Channel';
    3: Result:='Node';
    4: Result:='Active';
    5: Result:='FetchTime';
    6..29: Result:='Input'+IntToStr(Index-5);
  else
    Result:='Unknown';
  end
end;

class function TUZS24MGroup.PropsName(Index: integer): string;
begin
  case Index of
    0: Result:='Шифр параметра';
    1: Result:='Десктриптор';
    2: Result:='Канал связи';
    3: Result:='Контроллер';
    4: Result:='Опрос';
    5: Result:='Время опроса';
    6..29: Result:='Вход устройства '+IntToStr(Index-5);
  else
    Result:='';
  end
end;

function TUZS24MGroup.PropsValue(Index: integer): string;
begin
  case Index of
    0: Result:=FPtName;
    1: Result:=FPtDesc;
    2: Result:=Format('%d',[FChannel]);
    3: Result:=Format('%d',[FNode]);
    4: Result:=IfThen(FActived,'Да','Нет');
    5: Result:=Format('%d сек',[FFetchTime]);
    6..29: if (Index-6 < Count) and Assigned(EntityChilds[Index-6]) then
             Result:=Childs[Index-6]
           else
             Result:='';
  else
    Result:='';
  end
end;

procedure TUZS24MGroup.SaveToStream(Stream: TStream);
var i: integer;
begin
  Body.PtName:=PtName;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Node;
  Body.Actived:=Actived;
  Body.FetchTime:=FetchTime;
  Body.FirstSource:=FirstSource;
  for i:=0 to 23 do Body.Childs[i]:='';
  for i:=0 to Count-1 do
    if (i in [0..23]) and Assigned(EntityChilds[i]) then
      Body.Childs[i]:=EntityChilds[i].PtName;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

procedure TUZS24MGroup.SetEntFirstSource(const Value: TCustomAnaOut);
var S: string;
begin
  FEntFirstSource:=Value;
  S:=FFirstSource;
  if Assigned(FEntFirstSource) then
    FFirstSource:=Value.PtName
  else
    FFirstSource:='';
  if S <> FFirstSource then
  begin
    Caddy.AddChange(PtName,'Первоисточник',S,FFirstSource,
                              PtDesc,Caddy.Autor);
    Caddy.Changed:=True;
  end;
end;

procedure TUZS24MGroup.SetRaw(const Value: Single);
var Data: Cardinal; i: integer; B: boolean;
begin
  MoveMemory(@Data,@Value,4);
  for i:=0 to 23 do
  if Assigned(EntityChilds[i]) and EntityChilds[i].Actived then
  begin
    B:=(Data and Cardinal(1 shl i) > 0);
    if B then
      EntityChilds[i].Raw:=1
    else
      EntityChilds[i].Raw:=0;
  end;
  inherited SetRaw(Value);
end;

class function TUZS24MGroup.TypeCode: string;
begin
  Result:='UZ';
end;

class function TUZS24MGroup.TypeColor: TColor;
begin
  Result:=$00CC99FF;
end;

initialization
{$IFDEF UZS24}
  with RegisterNode('Устройства отключения УЗС-24М (v2.0)') do
  begin
    Add(RegisterEntity(TUZS24MGroup));
    RegisterEditForm(TUZS24MEditForm);
    RegisterPaspForm(TUZS24MPaspForm);
  end;
{$ENDIF}
end.
