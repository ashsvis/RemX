unit VzljotURSVUnit;

interface

uses
  Windows, Messages, Classes, Graphics, Controls, ComCtrls, EntityUnit, Menus;

type
  TVzNodeType = (ntVz010,ntVz022,ntVz510);
  TURSVNode = class(TEntity)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Channel: word;
      Node: word;
      Actived: boolean;
      FetchTime: Cardinal;
      NodeType: byte;
      Dummy: Cardinal;
      Dummy1: Cardinal;
    end;
    FNodeType: TVzNodeType;
    procedure SetNodeType(const Value: TVzNodeType);
  protected
    function GetFetchData: string; override;
  public
    NodeVersion,NodeMode: string;
    NodeDateTime: TDateTime;
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
    procedure Assign(E: TEntity); override;
    property NodeType: TVzNodeType read FNodeType write SetNodeType;
  end;

  TVzljotNDForm =  class(TBaseEditForm)
  private
    E: TEntity;
    procedure ConnectImageList(ImageList: TImageList);
    procedure UpdateRealTime;
    procedure ConnectBaseEditor(var Mess: TMessage); message WM_ConnectBaseEditor;
    procedure BaseFresh(var Mess: TMessage); message WM_Fresh;
    procedure ChangeFetchClick(Sender: TObject);
  protected
    procedure ConnectEntity(Entity: TEntity); virtual;
    procedure PopupMenu1Popup(Sender: TObject); virtual;
    procedure ChangeIntegerClick(Sender: TObject); virtual;
    procedure ChangeTextClick(Sender: TObject); virtual;
    procedure ChangeBooleanClick(Sender: TObject); virtual;
    procedure ListView1DblClick(Sender: TObject); virtual;
  public
    ListView1: TListView;
    PopupMenu1: TPopupMenu;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddBoolItem(Value: boolean);
  end;

  const
    AVzNodeFormat: array[TVzNodeType] of string =
       ('УРСВ-010','УРСВ-022','УРСВ-510');

implementation

uses SysUtils, StrUtils, DateUtils, Math, GetPtNameUnit, VzljotNDEditUnit,
     VzljotNDPaspUnit;

{ TURSVNode }

constructor TURSVNode.Create;
begin
  inherited;
  FetchIndex:=0;
  FEntityKind:=ekCustom;
  FIsCustom:=True;
  FNodeType:=ntVz510;
end;

class function TURSVNode.EntityType: string;
begin
  Result:='Расходомер "ВЗЛЕТ"';
end;

function TURSVNode.Prepare: string;
var W,D: word;
begin
  if Caddy.NetRole = nrClient then
  begin
    SetLength(Result,SizeOf(CommandData));
    MoveMemory(@Result[1],@CommandData,SizeOf(CommandData));
    Exit;
  end
  else
  begin
    case FetchIndex of
     // Запрос версии прибора
     0: Result:=Chr(FNode)+#17;
     // Запрос режима работы
     1: begin
          case FNodeType of
            ntVz010: begin W:=102; D:=2 end;
            ntVz022: begin W:=15; D:=1 end;
            ntVz510: begin W:=76; D:=1 end;
          else
            begin W:=0; D:=1; end;
          end;
          Result:=Chr(FNode)+#3+Chr(Hi(W))+Chr(Lo(W))+Chr(Hi(D))+Chr(Lo(D));
        end;
     // Дата и время контроллера
     2: begin
          case FNodeType of
            ntVz010: W:=8;
            ntVz022: W:=0;
            ntVz510: W:=32768;
          else
            W:=0;
          end;
          Result:=Chr(FNode)+#3+Chr(Hi(W))+Chr(Lo(W))+#0#2;
        end;
    end;
  end;
end;

procedure TURSVNode.Fetch(const Data: string);
var S: string; i: integer; V: Cardinal; R: single;
    M1,M2: TMemoryStream;
//    LastAlarm: TAlarmState;
//    AlarmFound, HasAlarm, HasConfirm, HasNoLink, HasInfo: boolean;
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
        if M1.Size >= SizeOf(V) then
        begin
          M1.Position:=0;
          M1.ReadBuffer(V,SizeOf(V));
          if M1.Size-M1.Position >= V then
          begin
            SetLength(S,V);
            M1.ReadBuffer(S[1],V);
            NodeVersion:=S;
            if M1.Size-M1.Position >= SizeOf(V) then
            begin
              M1.ReadBuffer(V,SizeOf(V));
              if M1.Size-M1.Position >= V then
              begin
                SetLength(S,V);
                M1.ReadBuffer(S[1],V);
                NodeMode:=S;
                if M1.Size-M1.Position = SizeOf(NodeDateTime) then
                begin
                  M1.ReadBuffer(NodeDateTime,SizeOf(NodeDateTime));
                  UpdateRealTime;
                end;
              end;
            end;
          end;
        end;
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
     0: begin // Запрос версии прибора
          if Length(Data) > 0 then
          begin
            S:='';
            for i:=4 to Length(Data) do
            begin
              if Data[i] = #0 then Break;
              S:=S+Data[i];
            end;
            NodeVersion:=S;
          end;
          FetchIndex:=1;
        end;
     1: begin // Запрос режима работы
          case FNodeType of
       ntVz010: if Length(Data) = 7 then
                begin
                  V:=((256*Ord(Data[4])+Ord(Data[5])) shl 16)+
                     (256*Ord(Data[6])+Ord(Data[7]));
                  Move(V,R,4);
                  if R = 0.0 then S:='ПОВЕРКА' else
                  if R = 1.0 then S:='РАБОТА'  else S:='';
                  NodeMode:=S;
                end;
       ntVz022,
       ntVz510: if Length(Data) = 5 then
                begin
                  case Ord(Data[5]) of
                   0: S:='РАБОТА';
                   1: S:='СЕРВИС';
                   2: S:='НАСТРОЙКА';
                   3: S:='ТЕСТ';
                  else
                   S:='';
                  end;
                  NodeMode:=S;
                end;
          end;
          FetchIndex:=2;
        end;
     2: begin // Дата и время устройства
          if Length(Data) = 7 then
          begin
            V:=((256*Ord(Data[4])+Ord(Data[5])) shl 16)+
               (256*Ord(Data[6])+Ord(Data[7]));
            NodeDateTime:=UnixToDateTime(V);
          end;
          FetchIndex:=0;
          UpdateRealTime;
        end;
    end;
  end;
end;

function TURSVNode.LoadFromStream(Stream: TStream): integer;
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
  FNodeType:=TVzNodeType(Body.NodeType);
end;

function TURSVNode.PropsCount: integer;
begin
  Result:=7;
end;

class function TURSVNode.PropsID(Index: integer): string;
begin
  case Index of
    0: Result:='PtName';
    1: Result:='PtDesc';
    2: Result:='Channel';
    3: Result:='Node';
    4: Result:='Active';
    5: Result:='FetchTime';
    6: Result:='NodeType';
  else
    Result:='';
  end
end;

class function TURSVNode.PropsName(Index: integer): string;
begin
  case Index of
    0: Result:='Шифр параметра';
    1: Result:='Десктриптор';
    2: Result:='Канал связи';
    3: Result:='Устройство';
    4: Result:='Опрос';
    5: Result:='Время опроса';
    6: Result:='Тип прибора';
  else
    Result:='';
  end
end;

function TURSVNode.PropsValue(Index: integer): string;
begin
  case Index of
    0: Result:=FPtName;
    1: Result:=FPtDesc;
    2: Result:=Format('%d',[FChannel]);
    3: Result:=Format('%d',[FNode]);
    4: Result:=IfThen(FActived,'Да','Нет');
    5: Result:=Format('%d сек',[FFetchTime]);
    6: Result:=Format('%s',[AVzNodeFormat[FNodeType]]);
  else
    Result:='';
  end
end;

procedure TURSVNode.RequestData;
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
    end;  
  end;
end;

procedure TURSVNode.SaveToStream(Stream: TStream);
begin
  Body.PtName:=PtName;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Node;
  Body.Actived:=Actived;
  Body.FetchTime:=FetchTime;
  Body.NodeType:=Ord(NodeType);
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

procedure TURSVNode.SetNodeType(const Value: TVzNodeType);
begin
  if FNodeType <> Value then
  begin
    Caddy.AddChange(FPtName,'Тип прибора',AVzNodeFormat[FNodeType],
                              AVzNodeFormat[Value],FPtDesc,Caddy.Autor);
    FNodeType := Value;
    Caddy.Changed:=True;
  end;
end;

class function TURSVNode.TypeCode: string;
begin
  Result:='ND';
end;

class function TURSVNode.TypeColor: TColor;
begin
  Result:=$00CCFFCC;
end;

{ TVzljotNDEditForm }

procedure TVzljotNDForm.AddBoolItem(Value: boolean);
var M: TMenuItem;
begin
  M:=TMenuItem.Create(Self);
  M.Caption:='Нет';
  M.Checked:=not Value;
  M.Tag:=0;
  M.OnClick:=ChangeBooleanClick;
  PopupMenu1.Items.Add(M);
  M:=TMenuItem.Create(Self);
  M.Caption:='Да';
  M.Checked:=Value;
  M.Tag:=1;
  M.OnClick:=ChangeBooleanClick;
  PopupMenu1.Items.Add(M);
end;

procedure TVzljotNDForm.BaseFresh(var Mess: TMessage);
begin
  UpdateRealTime;
end;

procedure TVzljotNDForm.ChangeBooleanClick(Sender: TObject);
var L: TListItem; M: TMenuItem; B: Boolean;
begin
  if not Assigned(E) then Exit;
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  B:=(M.Tag = 1);
  if Assigned(L) then
  begin
    if L.Caption = 'Опрос' then
    begin
      E.Actived:=B;
      L.SubItems[0]:=IfThen(E.Actived,'Да','Нет');
    end;
  end;
end;

procedure TVzljotNDForm.ChangeFetchClick(Sender: TObject);
var L: TListItem; V: integer; M: TMenuItem;
begin
  if not Assigned(E) then Exit;
  M:=Sender as TMenuItem;
  L:=ListView1.Selected;
  if L <> nil then
  begin
    case M.Tag of
      0: begin
           V:=E.FetchTime;
           if InputIntegerDlg(L.Caption+' (в сек.)',V) then
           begin
             if V < 1 then V:=1;
             E.FetchTime:=V;
             L.SubItems[0]:=Format('%d сек',[E.FetchTime]);
           end;
         end;
    else
      begin
        E.FetchTime:=M.Tag;
        L.SubItems[0]:=Format('%d сек',[E.FetchTime]);
      end;
    end;
  end;
end;

procedure TVzljotNDForm.ChangeIntegerClick(Sender: TObject);
var L: TListItem; V: Integer;
begin
  if not Assigned(E) then Exit;
  L:=ListView1.Selected;
  if Assigned(L) then
  begin
    if L.Caption = 'Канал связи' then V:=E.Channel
    else
      if L.Caption = 'Устройство' then V:=E.Node
      else
        Exit;
    if InputIntegerDlg(L.Caption,V) then
    begin
      if L.Caption = 'Канал связи' then
      begin
        if InRange(V,1,ChannelCount) then
        begin
          E.Channel:=V;
          L.SubItems[0]:=Format('%d',[E.Channel]);
        end
        else
          raise ERangeError.Create('Значение вне допустимых границ!');
      end
      else
      if L.Caption = 'Устройство' then
      begin
        if InRange(V,1,31) then
        begin
          E.Node:=V;
          L.SubItems[0]:=Format('%d',[E.Node]);
        end
        else
          raise ERangeError.Create('Значение вне допустимых границ (1..31)!');
      end;
      if (L.Caption = 'Канал связи') or
         (L.Caption = 'Устройство') then
      begin
        UpdateBaseView(Self);
        RestoreEntityPos(E);
      end;
    end;
  end;
end;

procedure TVzljotNDForm.ChangeTextClick(Sender: TObject);
var L: TListItem; S: string;
begin
  if not Assigned(E) then Exit;
  L:=ListView1.Selected;
  if Assigned(L) then
  begin
    if L.Caption = 'Дескриптор позиции' then
      S:=L.SubItems[0]
    else
      Exit;
    if InputStringDlg(L.Caption,S,50) then
    begin
      if L.Caption = 'Дескриптор позиции' then
      begin
        E.PtDesc:=S;
        L.SubItems[0]:=E.PtDesc;
      end;
    end;
  end;
end;

procedure TVzljotNDForm.ConnectBaseEditor(var Mess: TMessage);
begin
  ConnectImageList(TImageList(Mess.WParam));
  ConnectEntity(TEntity(Mess.LParam));
end;

procedure TVzljotNDForm.ConnectEntity(Entity: TEntity);
begin
  E:=Entity;
  if not Assigned(E) then Exit;
  with ListView1 do
  begin
    Items.BeginUpdate;
    try
      Items.Clear;
      with Items.Add do
      begin
        ImageIndex:=EntityClassIndex(E.ClassType)+3;
        Caption:='Шифр позиции';
        SubItems.Add(E.PtName+' - '+E.EntityType);
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Дескриптор позиции';
        SubItems.Add(E.PtDesc);
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Опрос';
        SubItems.Add(IfThen(E.Actived,'Да','Нет'));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Время опроса';
        SubItems.Add(Format('%d сек',[E.FetchTime]));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Фактически';
        if E.RealTime > 0 then
          SubItems.Add(Format('%.3f',[E.RealTime/1000])+' сек')
        else
          SubItems.Add('Нет опроса');
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Канал связи';
        SubItems.Add(IntToStr(E.Channel));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Устройство';
        SubItems.Add(IntToStr(E.Node));
      end;
    finally
      Items.EndUpdate;
    end;
  end;
end;

procedure TVzljotNDForm.ConnectImageList(ImageList: TImageList);
begin
  ListView1.SmallImages:=ImageList;
end;

constructor TVzljotNDForm.Create(AOwner: TComponent);
begin
  inherited;
  E:=nil;
  PopupMenu1:=TPopupMenu.Create(Self);
  PopupMenu1.OnPopup:=PopupMenu1Popup;
  ListView1:=TListView.Create(Self);
  with ListView1 do
  begin
    Parent:=Self;
    Align:=alClient;
    with Columns.Add do
    begin
      Caption:='Свойство';
      Width:=250;
    end;
    with Columns.Add do
    begin
      Caption:='Значение';
      Width:=432;
      AutoSize:=True;
    end;
    ViewStyle:=vsReport;
    ColumnClick:=False;
    ReadOnly:=True;
    RowSelect:=True;
    PopupMenu:=PopupMenu1;
    OnDblClick:=ListView1DblClick;
  end;
end;

destructor TVzljotNDForm.Destroy;
begin
  ListView1.Free;
  PopupMenu.Free;;
  inherited;
end;

procedure TVzljotNDForm.ListView1DblClick(Sender: TObject);
begin
  if (ListView1.Selected <> nil) and
     (ListView1.Selected.Caption = 'Источник данных') then
  begin
    if Assigned(E.SourceEntity) then
      E.SourceEntity.ShowEditor(Monitor.MonitorNum);
  end;
end;

procedure TVzljotNDForm.PopupMenu1Popup(Sender: TObject);
var L: TListItem; M: TMenuItem;
begin
  L:=ListView1.Selected;
  with PopupMenu1 do
  begin
    Items.Clear;
    if Assigned(L) then
    begin
      if L.Caption = 'Шифр позиции' then
      begin
        M:=TMenuItem.Create(Self);
        M.Caption:='Изменить имя точки...';
        M.OnClick:=ChangePtNameClick;
        Items.Add(M);
        M:=TMenuItem.Create(Self);
        M.Caption:='-';
        Items.Add(M);
        M:=TMenuItem.Create(Self);
        M.Caption:='Дублировать точку...';
        M.OnClick:=DoubleEntityClick;
        Items.Add(M);
        M:=TMenuItem.Create(Self);
        M.Caption:='Удалить точку';
        M.OnClick:=DeleteEntityClick;
        Items.Add(M);
      end
      else
      if L.Caption = 'Дескриптор позиции' then
      begin
        M:=TMenuItem.Create(Self);
        M.Caption:='Изменить текст...';
        M.OnClick:=ChangeTextClick;
        Items.Add(M);
      end
      else
      if (L.Caption = 'Канал связи') or
         (L.Caption = 'Устройство') then
      begin
        M:=TMenuItem.Create(Self);
        M.Caption:='Изменить число...';
        M.OnClick:=ChangeIntegerClick;
        Items.Add(M);
      end
      else
      if L.Caption = 'Опрос' then
      begin
        M:=TMenuItem.Create(Self);
        M.Caption:='Нет';
        M.Checked:=not E.Actived;
        M.Tag:=0;
        M.OnClick:=ChangeBooleanClick;
        Items.Add(M);
        M:=TMenuItem.Create(Self);
        M.Caption:='Да';
        M.Checked:=E.Actived;
        M.Tag:=1;
        M.OnClick:=ChangeBooleanClick;
        Items.Add(M);
      end
      else
      if L.Caption = 'Время опроса' then
      begin
        M:=TMenuItem.Create(Self);
        M.Caption:='Изменить время опроса...';
        M.OnClick:=ChangeFetchClick; M.Tag:=0; Items.Add(M);
        //---
        M:=TMenuItem.Create(Self); M.Caption:='-'; Items.Add(M);
        //---
        M:=TMenuItem.Create(Self); M.Caption:='1 сек';
        M.Checked:=(E.FetchTime=1);
        M.Tag:=1; M.OnClick:=ChangeFetchClick; Items.Add(M);
        //---
        M:=TMenuItem.Create(Self); M.Caption:='2 сек';
        M.Checked:=(E.FetchTime=2);
        M.Tag:=2; M.OnClick:=ChangeFetchClick; Items.Add(M);
        //---
        M:=TMenuItem.Create(Self); M.Caption:='3 сек';
        M.Checked:=(E.FetchTime=3);
        M.Tag:=3; M.OnClick:=ChangeFetchClick; Items.Add(M);
        //---
        M:=TMenuItem.Create(Self); M.Caption:='5 сек';
        M.Checked:=(E.FetchTime=5);
        M.Tag:=5; M.OnClick:=ChangeFetchClick; Items.Add(M);
        //---
        M:=TMenuItem.Create(Self); M.Caption:='-'; Items.Add(M);
        //---
        M:=TMenuItem.Create(Self); M.Caption:='10 сек';
        M.Checked:=(E.FetchTime=10);
        M.Tag:=10; M.OnClick:=ChangeFetchClick; Items.Add(M);
        //---
        M:=TMenuItem.Create(Self); M.Caption:='20 сек';
        M.Checked:=(E.FetchTime=20);
        M.Tag:=20; M.OnClick:=ChangeFetchClick; Items.Add(M);
        //---
        M:=TMenuItem.Create(Self); M.Caption:='30 сек';
        M.Checked:=(E.FetchTime=30);
        M.Tag:=30; M.OnClick:=ChangeFetchClick; Items.Add(M);
        //---
        M:=TMenuItem.Create(Self); M.Caption:='-'; Items.Add(M);
        //---
        M:=TMenuItem.Create(Self); M.Caption:='1 мин';
        M.Checked:=(E.FetchTime=60);
        M.Tag:=60; M.OnClick:=ChangeFetchClick; Items.Add(M);
        //---
        M:=TMenuItem.Create(Self); M.Caption:='2 мин';
        M.Checked:=(E.FetchTime=120);
        M.Tag:=60*2; M.OnClick:=ChangeFetchClick; Items.Add(M);
        //---
        M:=TMenuItem.Create(Self); M.Caption:='5 мин';
        M.Checked:=(E.FetchTime=300);
        M.Tag:=60*5; M.OnClick:=ChangeFetchClick; Items.Add(M);
      end;
    end;
  end;
end;

procedure TVzljotNDForm.UpdateRealTime;
var L: TListItem;
begin
  if not Assigned(E) then Exit;
  if Caddy.UserLevel > 4 then
    ListView1.PopupMenu:=PopupMenu1
  else
    ListView1.PopupMenu:=nil;
//---------------------------------------------------------
  L:=ListView1.FindCaption(0,'Фактически',False,True,False);
  if L <> nil then
  begin
    if E.RealTime > 0 then
      L.SubItems[0]:=Format('%.3f',[E.RealTime/1000])+' сек'
    else
      L.SubItems[0]:='Нет опроса';
  end;
end;

function TURSVNode.GetFetchData: string;
var M1,M2: TMemoryStream; W: integer;
begin
  M1:=TMemoryStream.Create;
  M2:=TMemoryStream.Create;
  try
    W:=Length(NodeVersion);
    M1.WriteBuffer(W,SizeOf(W));
    M1.WriteBuffer(NodeVersion[1],Length(NodeVersion));
//-------------------
    W:=Length(NodeMode);
    M1.WriteBuffer(W,SizeOf(W));
    M1.WriteBuffer(NodeMode[1],Length(NodeMode));
//-------------------
    M1.WriteBuffer(NodeDateTime,SizeOf(NodeDateTime));
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

procedure TURSVNode.Assign(E: TEntity);
var T: TURSVNode;
begin
  inherited;
  T:=E as TURSVNode;
  FNodeType:=T.NodeType;
end;

initialization
{$IFDEF VZLJOTURSV}
  with RegisterNode('Расходомеры УРСВ "Взлёт"') do
  begin
    Add(RegisterEntity(TURSVNode));
    RegisterEditForm(TVzljotEditForm);
    RegisterPaspForm(TVzljotNDPaspForm);
  end;
{$ENDIF}
end.
