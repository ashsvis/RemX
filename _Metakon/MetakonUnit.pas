unit MetakonUnit;

interface

uses
  Windows, SysUtils, Classes, Graphics, ExtCtrls, Forms, Controls,
  Menus, ComCtrls, Messages, EntityUnit;

type
  TMtkKind = (mkK,mkT1,mkT2,mkT3);
  
const
  AMtkKind: array[TMtkKind] of string = ('K','T1','T2','T3');
  AEUMtkKind: array[TMtkKind] of string =
                                  ('','0.1*мин','0.1*сек','0.01*ед.изм/мин');
  AFullMtkKind: array[TMtkKind] of string =
        ('Зона пропорциональности','Постоянная интегрирования',
         'Постоянная дифференцирования','Скорость изменения задания');

type
  TMtkEditForm = class(TBaseEditForm)
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

  TMtkAnaParam = class(TCustomAnaInp)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Channel: word;
      Node: word;
      Actived: boolean;
      FetchTime: Cardinal;
      SourceName: string[10];
      CalcScale: boolean;
      EUDesc: string[10];
      OPFormat: TPVFormat;
      OPEUHi: Single;
      OPEULo: Single;
      MtkKind: TMtkKind;
      Reserve1: Cardinal;
      Reserve2: Cardinal;
      Reserve3: Cardinal;
      Reserve4: Cardinal;
      Reserve5: Cardinal;
    end;
    FMtkKind: TMtkKind;
    procedure SetMtkKind(const Value: TMtkKind);
  protected
  public
    class function EntityType: string; override;
    class function TypeCode: string; override;
    class function TypeColor: TColor; override;
    function PropsCount: integer; override;
    class function PropsID(Index: integer): string; override;
    class function PropsName(Index: integer): string; override;
    constructor Create; override;
    function PropsValue(Index: integer): string; override;
    procedure SaveToStream(Stream: TStream); override;
    function LoadFromStream(Stream: TStream): integer; override;
    function Prepare: string; override;
    procedure Fetch(const Data: string); override;
    procedure SendOP(Value: Single); override;
    function AddressEqual(E: TEntity): boolean; override;
    procedure Assign(E: TEntity); override;
    property OP;
    property EUDesc;
    property OPFormat;
    property OPEUHi;
    property OPEULo;
    property MtkKind: TMtkKind read FMtkKind write SetMtkKind;
  end;

  TMtkCntReg = class(TCustomCntReg)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Channel: word;
      Node: word;
      Actived: boolean;
      Asked: boolean;
      Logged: boolean;
      Trend: boolean;
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
      SPEULo: Single;
      SPEUHi: Single;
      PVDHTP: Single;
      PVDLTP: Single;
      CheckSP: TCheckChange;
      CheckOP: TCheckChange;
      SourceK: string[10];
      SourceT1: string[10];
      SourceT2: string[10];
      SourceT3: string[10];
      Reserve1: Cardinal;
      Reserve2: Cardinal;
      Reserve3: Cardinal;
      Reserve4: Cardinal;
      Reserve5: Cardinal;
    end;
    FSourceT2: string;
    FSourceK: string;
    FSourceT1: string;
    FSourceT3: string;
    FT3: TMtkAnaParam;
    FT1: TMtkAnaParam;
    FT2: TMtkAnaParam;
    FK: TMtkAnaParam;
    FFetchIndex: integer;
    LastCommand: string;
    procedure SetK(const Value: TMtkAnaParam);
    procedure SetT1(const Value: TMtkAnaParam);
    procedure SetT2(const Value: TMtkAnaParam);
    procedure SetT3(const Value: TMtkAnaParam);
  protected
    procedure SetSP(const Value: Single); override;
    procedure SetOP(const Value: Single); override;
    procedure SetSPEUHi(const Value: Single); override;
    procedure SetSPEULo(const Value: Single); override;
    function GetFetchData: string; override;
  public
    OPRaw: Single;
    PVRaw: Single;
    SPRaw: Single;
    constructor Create; override;
    class function EntityType: string; override;
    class function TypeCode: string; override;
    class function TypeColor: TColor; override;
    function PropsCount: integer; override;
    class function PropsID(Index: integer): string; override;
    class function PropsName(Index: integer): string; override;
    function PropsValue(Index: integer): string; override;
    property K: TMtkAnaParam read FK write SetK;
    property T1: TMtkAnaParam read FT1 write SetT1;
    property T2: TMtkAnaParam read FT2 write SetT2;
    property T3: TMtkAnaParam read FT3 write SetT3;
    procedure Notify(Kind: TEntityNotify; E: TEntity); override;
    procedure ConnectLinks; override;
    procedure SaveToStream(Stream: TStream); override;
    function LoadFromStream(Stream: TStream): integer; override;
    function Prepare: string; override;
    procedure Fetch(const Data: string); override;
    procedure RequestData; override;
    procedure SendSP(Value: Single); override;
    procedure SendOP(Value: Single); override;
    function SPText: string;
    function OPText: string;
    procedure Assign(E: TEntity); override;
    function HasCommandSP: boolean; override;
    function HasCommandOP: boolean; override;
    function HasCommandMode: boolean; override;
    property PV;
    property SP;
    property OP;
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
    property SPEUHi;
    property SPEULo;
    property PVDHTP;
    property PVDLTP;
    property CheckSP;
    property CheckOP;
    property SourceK: string read FSourceK;
    property SourceT1: string read FSourceT1;
    property SourceT2: string read FSourceT2;
    property SourceT3: string read FSourceT3;
    property Trend;
  end;

implementation

uses Math, StrUtils, GetPtNameUnit;

{ TMtkAnaParam }

function TMtkAnaParam.AddressEqual(E: TEntity): boolean;
begin
  with E as TMtkAnaParam do
  begin
    Result:=(Channel = Self.Channel) and
            (Node = Self.Node) and
            (MtkKind = Self.MtkKind);
  end;
end;

procedure TMtkAnaParam.Assign(E: TEntity);
var T: TMtkAnaParam;
begin
  inherited;
  T:=E as TMtkAnaParam;
  FMtkKind:=T.MtkKind;
end;

constructor TMtkAnaParam.Create;
begin
  inherited;
  FCalcScale:=False;
end;

class function TMtkAnaParam.EntityType: string;
begin
  Result:='Аналоговый параметр МЕТАКОН-515-Х-1';
end;

procedure TMtkAnaParam.Fetch(const Data: string);
const AReg: array[TMtkKind] of Byte = ($03,$04,$05,$06);
      ADec: array[TPVFormat] of Single = (1.0,0.1,0.01,0.001);
begin
  inherited;
  if HasCommand then
  begin
    if Data = Chr(FNode)+#$00+Chr(AReg[FMtkKind])+#$01 then
    begin
      ErrorMess:='Команда принята';
      Caddy.AddChange(FPtName,'OP','','',ErrorMess,'Автономно');
      Caddy.ShowMessage(kmStatus,ErrorMess);
      Windows.Beep(500,100);
      LastTime:=FFetchTime+1;
    end
    else
    begin
      ErrorMess:='Ошибка обмена с устройством';
      Caddy.AddChange(FPtName,'OP','','',ErrorMess,'Автономно');
      Caddy.ShowMessage(kmError,ErrorMess);
      Caddy.AddSysMess(PtName,ErrorMess);
      Windows.Beep(1000,100);
      Sleep(100);
      Windows.Beep(1000,100);
    end;
  end
  else
  begin
    if (Length(Data) = 7) and
       (Copy(Data,1,4) = Chr(FNode)+#$00+Chr(AReg[FMtkKind])+#$00) and
       ((Ord(Data[5]) and $0f) = 3) then
    begin
      if FMtkKind = mkK then
        Raw:=(Ord(Data[6])+Ord(Data[7])*256)*ADec[OPFormat]
      else
        Raw:=(Ord(Data[6])+Ord(Data[7])*256);
    end
    else
      ErrorMess:='Ошибка обмена с устройством';
    UpdateRealTime;
  end;
end;

function TMtkAnaParam.LoadFromStream(Stream: TStream): integer;
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
  FSourceName:=Body.SourceName;
  FEUDesc:=Body.EUDesc;
  FOPFormat:=Body.OPFormat;
  FOPEUHi:=Body.OPEUHi;
  FOPEULo:=Body.OPEULo;
  FMtkKind:=Body.MtkKind;
end;

function TMtkAnaParam.Prepare: string;
const AReg: array[TMtkKind] of Byte = ($03,$04,$05,$06);
      ADec: array[TPVFormat] of Single = (1.0,10.0,100.0,1000.0);
var WData: Word;
begin
  if Caddy.NetRole = nrClient then
  begin
    SetLength(Result,SizeOf(CommandData));
    MoveMemory(@Result[1],@CommandData,SizeOf(CommandData));
    Exit;
  end
  else
  if HasCommand then
  begin
    case FMtkKind of
    mkK: begin
           WData:=EnsureRange(Round(CommandData*ADec[OPFormat]),1,9999);
           Result:=Chr(FNode)+#$00#$03#$01#$C3+Chr(Lo(WData))+Chr(Hi(WData));
         end;
   mkT1: begin
           WData:=EnsureRange(Round(CommandData),1,9999);
           Result:=Chr(FNode)+#$00#$04#$01#$C3+Chr(Lo(WData))+Chr(Hi(WData));
         end;
   mkT2: begin
           WData:=EnsureRange(Round(CommandData),0,9999);
           Result:=Chr(FNode)+#$00#$05#$01#$C3+Chr(Lo(WData))+Chr(Hi(WData));
         end;
   mkT3: begin
           WData:=EnsureRange(Round(CommandData),0,9999);
           Result:=Chr(FNode)+#$00#$06#$01#$C3+Chr(Lo(WData))+Chr(Hi(WData));
         end;
    end;
  end
  else
  begin
    Result:=Chr(FNode)+#$00+Chr(AReg[FMtkKind])+#$00;
  end;
end;

function TMtkAnaParam.PropsCount: integer;
begin
  Result:=11;
end;

class function TMtkAnaParam.PropsID(Index: integer): string;
begin
  case Index of
    0: Result:='PtName';
    1: Result:='PtDesc';
    2: Result:='Channel';
    3: Result:='Node';
    4: Result:='Active';
    5: Result:='FetchTime';
    6: Result:='EUDesc';
    7: Result:='FormatOP';
    8: Result:='OPEUHI';
    9: Result:='OPEULO';
   10: Result:='MtkKind';
  else
    Result:='Unknown';
  end
end;

class function TMtkAnaParam.PropsName(Index: integer): string;
begin
  case Index of
    0: Result:='Шифр параметра';
    1: Result:='Десктриптор';
    2: Result:='Канал связи';
    3: Result:='Контроллер';
    4: Result:='Опрос';
    5: Result:='Время опроса';
    6: Result:='Размерность';
    7: Result:='Формат OP';
    8: Result:='Верхняя граница шкалы';
    9: Result:='Нижняя граница шкалы';
   10: Result:='Тип параметра';
  else
    Result:='';
  end
end;

function TMtkAnaParam.PropsValue(Index: integer): string;
var sFormat: string;
begin
  sFormat:='%.'+Format('%d',[Ord(FOPFormat)])+'f';
  case Index of
    0: Result:=FPtName;
    1: Result:=FPtDesc;
    2: Result:=Format('%d',[FChannel]);
    3: Result:=Format('%d',[FNode]);
    4: Result:=IfThen(FActived,'Да','Нет');
    5: Result:=Format('%d сек',[FFetchTime]);
    6: Result:=FEUDesc;
    7: Result:=Format('D%d',[Ord(FOPFormat)]);
    8: Result:=Format(sFormat,[FOPEUHi]);
    9: Result:=Format(sFormat,[FOPEULo]);
   10: Result:=AMtkKind[FMtkKind];
  else
    Result:='';
  end
end;

procedure TMtkAnaParam.SaveToStream(Stream: TStream);
begin
  Body.PtName:=PtName;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Node;
  Body.Actived:=Actived;
  Body.FetchTime:=FetchTime;
  Body.SourceName:=SourceName;
  Body.EUDesc:=EUDesc;
  Body.OPFormat:=OPFormat;
  Body.OPEUHi:=OPEUHi;
  Body.OPEULo:=OPEULo;
  Body.MtkKind:=MtkKind;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

procedure TMtkAnaParam.SendOP(Value: Single);
var sFormat: string;
begin
  sFormat:='%.'+Format('%d',[Ord(FOPFormat)])+'f';
  Caddy.AddChange(FPtName,'OP',Format(sFormat,[OP]),Format(sFormat,[Value]),
                              FPtDesc,Caddy.Autor);
  LastTime:=FFetchTime;
  CommandData:=Value;
  HasCommand:=True;
end;

procedure TMtkAnaParam.SetMtkKind(const Value: TMtkKind);
begin
  if FMtkKind <> Value then
  begin
    Caddy.AddChange(PtName,'Тип параметра',AMtkKind[FMtkKind],
                              AMtkKind[Value],PtDesc,Caddy.Autor);
    FMtkKind:=Value;
    Caddy.Changed:=True;
  end;
end;

class function TMtkAnaParam.TypeCode: string;
begin
  Result:='AP';
end;

class function TMtkAnaParam.TypeColor: TColor;
begin
  Result:=$0099FFFF;
end;

{ TMtkEditForm }

procedure TMtkEditForm.AddBoolItem(Value: boolean);
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

procedure TMtkEditForm.BaseFresh(var Mess: TMessage);
begin
  UpdateRealTime;
end;

procedure TMtkEditForm.ChangeBooleanClick(Sender: TObject);
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

procedure TMtkEditForm.ChangeFetchClick(Sender: TObject);
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

procedure TMtkEditForm.ChangeIntegerClick(Sender: TObject);
var L: TListItem; V: Integer;
begin
  if not Assigned(E) then Exit;
  L:=ListView1.Selected;
  if Assigned(L) then
  begin
    if L.Caption = 'Канал связи' then V:=E.Channel
    else
      if L.Caption = 'Регулятор' then V:=E.Node
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
      if L.Caption = 'Регулятор' then
      begin
        if InRange(V,1,32) then
        begin
          E.Node:=V;
          L.SubItems[0]:=Format('%d',[E.Node]);
        end
        else
          raise ERangeError.Create('Значение вне допустимых границ (1..32)!');
      end;
      if (L.Caption = 'Канал связи') or
         (L.Caption = 'Регулятор') then
      begin
        UpdateBaseView(Self);
        RestoreEntityPos(E);
      end;
    end;
  end;
end;

procedure TMtkEditForm.ChangeTextClick(Sender: TObject);
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

procedure TMtkEditForm.ConnectBaseEditor(var Mess: TMessage);
begin
  ConnectImageList(TImageList(Mess.WParam));
  ConnectEntity(TEntity(Mess.LParam));
end;

procedure TMtkEditForm.ConnectEntity(Entity: TEntity);
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
        Caption:='Регулятор';
        SubItems.Add(IntToStr(E.Node));
      end;
    finally
      Items.EndUpdate;
    end;
  end;
end;

procedure TMtkEditForm.ConnectImageList(ImageList: TImageList);
begin
  ListView1.SmallImages:=ImageList;
end;

constructor TMtkEditForm.Create(AOwner: TComponent);
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

destructor TMtkEditForm.Destroy;
begin
  ListView1.Free;
  PopupMenu.Free;;
  inherited;
end;

procedure TMtkEditForm.ListView1DblClick(Sender: TObject);
begin
  if (ListView1.Selected <> nil) and
     (ListView1.Selected.Caption = 'Источник данных') then
  begin
    if Assigned(E.SourceEntity) then
      E.SourceEntity.ShowEditor(Monitor.MonitorNum);
  end;
end;

procedure TMtkEditForm.PopupMenu1Popup(Sender: TObject);
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
         (L.Caption = 'Регулятор') then
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

procedure TMtkEditForm.UpdateRealTime;
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

{ TMtkCntReg }

procedure TMtkCntReg.Assign(E: TEntity);
var T: TMtkCntReg;
begin
  inherited;
  T:=E as TMtkCntReg;
  FSPEUHi:=T.SPEUHi;
  FSPEULo:=T.SPEULo;
  FPVDHTP:=T.PVDHTP;
  FPVDLTP:=T.PVDLTP;
  FRegType:=T.RegType;
  FCheckSP:=T.CheckSP;
  FCheckOP:=T.CheckOP;
end;

procedure TMtkCntReg.ConnectLinks;
var E: TEntity;
begin
  inherited;
  E:=Caddy.Find(FSourceK);
  if Assigned(E) then
    K:=E as TMtkAnaParam else K:=nil;
  E:=Caddy.Find(FSourceT1);
  if Assigned(E) then
    T1:=E as TMtkAnaParam else T1:=nil;
  E:=Caddy.Find(FSourceT2);
  if Assigned(E) then
    T2:=E as TMtkAnaParam else T2:=nil;
  E:=Caddy.Find(FSourceT3);
  if Assigned(E) then
    T3:=E as TMtkAnaParam else T3:=nil;
end;

constructor TMtkCntReg.Create;
begin
  inherited;
  FSPEUHi:=100.0;
//------------------------------------------------
  FSPEULo:=0.0;
  FSP:=0.0;
  FOP:=0.0;
  FPVDHTP:=0.0;
  FPVDLTP:=0.0;
//------------------------------------------------
  FEntityKind:=ekKontur;
  FIsKontur:=True;
  FCheckSP:=ccNone;
  FCheckOP:=ccNone;
  FSourceK:='';
  FSourceT1:='';
  FSourceT2:='';
  FSourceT3:='';
  FFetchIndex:=0;
  LastCommand:='';
  FCalcScale:=False;
end;

class function TMtkCntReg.EntityType: string;
begin
  Result:='Регулятор МЕТАКОН-515-Х-1';
end;

function TMtkCntReg.Prepare: string;
const ADec: array[TPVFormat] of Single = (1.0,10.0,100.0,1000.0);
var WData: SmallInt;
begin
  if Caddy.NetRole = nrClient then
  begin
    SetLength(Result,SizeOf(CommandMode)+SizeOf(CommandData));
    MoveMemory(@Result[1],@CommandMode,SizeOf(CommandMode));
    MoveMemory(@Result[2],@CommandData,SizeOf(CommandData));
    Exit;
  end
  else
  if HasCommand then
  begin
    case CommandMode of
    25: begin
          WData:=EnsureRange(Round(CommandData*ADec[PVFormat]),-999,9999);
          Result:=Chr(FNode)+#$00#$02#$01#$C4+Chr(Lo(WData))+Chr(Hi(WData));
        end;
    29: begin
          WData:=EnsureRange(Round(CommandData),0,100);
          Result:=Chr(FNode)+#$00#$07#$01#$C1+Chr(Lo(WData));
        end;
     end;
  end
  else
  begin
    case FFetchIndex of
      0: Result:=Chr(FNode)+#$00+#$01+#$00; // Результат измерения PV
      1: Result:=Chr(FNode)+#$00+#$02+#$00; // Уставка ПИД регулятора SP
      2: Result:=Chr(FNode)+#$00+#$07+#$00; // Выходная мощность OP
    end;
  end;
end;

procedure TMtkCntReg.Fetch(const Data: string);
const AReg: array[TMtkKind] of Byte = ($03,$04,$05,$06);
      ADec: array[TPVFormat] of Single = (1.0,0.1,0.01,0.001);
var //KindStatus: TKindStatus;
    StatusOk: boolean;
//    LastAlarm: TAlarmState;
//    AlarmFound, HasAlarm, HasConfirm, HasNoLink, HasInfo: boolean;
begin
  if Caddy.NetRole = nrClient then
  begin
    if Length(Data) = 12 then
    begin
      MoveMemory(@PVRaw,@Data[1],4);
      MoveMemory(@SPRaw,@Data[5],4);
      MoveMemory(@OPRaw,@Data[9],4);
      PV:=PVRaw;
      SP:=SPRaw;
      OP:=OPRaw;
      ErrorMess:='';
      StatusOk:=not ((asOpenBadPV in AlarmStatus) or
                     (asShortBadPV in AlarmStatus) or
                     (asNoLink in AlarmStatus));
      if FirstCalc and StatusOk and FTrend then
      begin
        Caddy.AddRealTrend(PtName+'.PV',FPV,False);
        Caddy.AddRealTrend(PtName+'.SP',FSP,False);
        Caddy.AddRealTrend(PtName+'.OP',FOP,False);
      end;
      FirstCalc:=False;
      if FTrend then
        Caddy.AddRealTrend(PtName+'.PV',FPV,StatusOk);
      if FTrend then
        Caddy.AddRealTrend(PtName+'.SP',FSP,StatusOk);
      if FTrend then
        Caddy.AddRealTrend(PtName+'.OP',FOP,StatusOk);
      UpdateRealTime;
      Exit;
    end
    else
      ErrorMess:='Ошибка обмена с устройством';
  end;
  inherited;
  if HasCommand then
  begin
    if (Data = Chr(FNode)+#$00+#$02+#$01) then
    begin
      ErrorMess:='Команда принята';
      Caddy.AddChange(FPtName,'SP','','',ErrorMess,'Автономно');
      Caddy.ShowMessage(kmStatus,ErrorMess);
      Windows.Beep(500,100);
      LastTime:=FFetchTime+1;
    end
    else
    if (Data = Chr(FNode)+#$00+#$07+#$01) then
    begin
      ErrorMess:='Команда принята';
      Caddy.AddChange(FPtName,'OP','','',ErrorMess,'Автономно');
      Caddy.ShowMessage(kmStatus,ErrorMess);
      Windows.Beep(500,100);
      LastTime:=FFetchTime+1;
    end
    else
    begin
      ErrorMess:='Ошибка обмена с устройством';
      Caddy.AddChange(FPtName,'OP','','',ErrorMess,'Автономно');
      Caddy.ShowMessage(kmError,ErrorMess);
      Caddy.AddSysMess(PtName,ErrorMess);
      Windows.Beep(1000,100);
      Sleep(100);
      Windows.Beep(1000,100);
    end;
  end
  else
  begin
    StatusOk:=not ((asOpenBadPV in AlarmStatus) or
                   (asShortBadPV in AlarmStatus) or
                   (asNoLink in AlarmStatus));
    if FirstCalc and StatusOk and FTrend then
    begin
      Caddy.AddRealTrend(PtName+'.PV',FPV,False);
      Caddy.AddRealTrend(PtName+'.SP',FSP,False);
      Caddy.AddRealTrend(PtName+'.OP',FOP,False);
    end;
    FirstCalc:=False;
    case FFetchIndex of
      0: begin // Результат измерения
           if (Length(Data) = 7) and
              (Copy(Data,1,4) = Chr(FNode)+#$00#$01#$00) and
              ((Ord(Data[5]) and $0f) = 4) then
           begin
             if (Ord(Data[7]) and $80) > 0 then
               PVRaw:=((Ord(Data[6])+Ord(Data[7])*256)-$10000)*ADec[PVFormat]
             else
               PVRaw:=(Ord(Data[6])+Ord(Data[7])*256)*ADec[PVFormat];
             PV:=PVRaw;
             ErrorMess:='';
           end
           else
             ErrorMess:='Ошибка обмена с устройством';
           FFetchIndex:=1;
           if Caddy.StationsLink.Server then
           begin
           end;
           if FTrend then
             Caddy.AddRealTrend(PtName+'.PV',FPV,StatusOk);
         end;
      1: begin // Основная уставка ПИД регулятора
           if (Length(Data) = 7) and
              (Copy(Data,1,4) = Chr(FNode)+#$00#$02#$00) and
              ((Ord(Data[5]) and $0f) = 4) then
           begin
             if (Ord(Data[7]) and $80) > 0 then
               SPRaw:=((Ord(Data[6])+Ord(Data[7])*256)-$10000)*ADec[PVFormat]
             else
               SPRaw:=(Ord(Data[6])+Ord(Data[7])*256)*ADec[PVFormat];
             SP:=SPRaw;
             ErrorMess:='';
           end
           else
             ErrorMess:='Ошибка обмена с устройством';
           FFetchIndex:=2;
           if FTrend then
             Caddy.AddRealTrend(PtName+'.SP',FSP,StatusOk);
         end;
      2: begin // Выходная мощность
           if (Length(Data) = 6) and
              (Copy(Data,1,4) = Chr(FNode)+#$00#$07#$00) and
              ((Ord(Data[5]) and $0f) = 1) then
           begin
             OPRaw:=Ord(Data[6])*1.0;
             OP:=OPRaw;
             ErrorMess:='';
           end
           else
             ErrorMess:='Ошибка обмена с устройством';
           FFetchIndex:=0;
           UpdateRealTime;
         end;
    end;
  end;
end;

function TMtkCntReg.HasCommandMode: boolean;
begin
  Result:=False;
end;

function TMtkCntReg.HasCommandOP: boolean;
begin
  Result:=True;
end;

function TMtkCntReg.HasCommandSP: boolean;
begin
  Result:=True;
end;

function TMtkCntReg.LoadFromStream(Stream: TStream): integer;
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
  FSPEULo:=Body.SPEULo;
  FSPEUHi:=Body.SPEUHi;
  FPVDHTP:=Body.PVDHTP;
  FPVDLTP:=Body.PVDLTP;
  FCheckSP:=Body.CheckSP;
  FCheckOP:=Body.CheckOP;
  FSourceK:=Body.SourceK;
  FSourceT1:=Body.SourceT1;
  FSourceT2:=Body.SourceT2;
  FSourceT3:=Body.SourceT3;
  FTrend:=Body.Trend;
  FIsTrending:=FTrend;
end;

procedure TMtkCntReg.Notify(Kind: TEntityNotify; E: TEntity);
begin
  inherited;
  case Kind of
    enRename: begin
                if E = FK then FSourceK:=E.PtName;
                if E = FT1 then FSourceT1:=E.PtName;
                if E = FT2 then FSourceT2:=E.PtName;
                if E = FT3 then FSourceT3:=E.PtName;
              end;
    enDelete: begin
                if E = FK then K:=nil;
                if E = FT1 then T1:=nil;
                if E = FT2 then T2:=nil;
                if E = FT3 then T3:=nil;
              end;
  end;
end;

function TMtkCntReg.OPText: string;
begin
  if asNoLink in AlarmStatus then
    Result:='------'
  else
    Result:=Format('%.'+IntToStr(Ord(FPVFormat))+'f',[FOP])
end;

function TMtkCntReg.PropsCount: integer;
begin
  Result:=28;
end;

class function TMtkCntReg.PropsID(Index: integer): string;
begin
  case Index of
    0: Result:='PtName';
    1: Result:='PtDesc';
    2: Result:='Channel';
    3: Result:='Node';
    4: Result:='Active';
    5: Result:='Alarm';
    6: Result:='Confirm';
    7: Result:='Trend';
    8: Result:='FEtchTime';
    9: Result:='EUDesc';
   10: Result:='FormatPV';
   11: Result:='PVEUHI';
   12: Result:='PVHHTP';
   13: Result:='PVHITP';
   14: Result:='PVLOTP';
   15: Result:='PVLLTP';
   16: Result:='PVEULO';
   17: Result:='BadDB';
   18: Result:='SPEUHI';
   19: Result:='SPEULO';
   20: Result:='PVDHTP';
   21: Result:='PVDLTP';
   22: Result:='CheckSP';
   23: Result:='CheckOP';
   24: Result:='SourceK';
   25: Result:='SourceT1';
   26: Result:='SourceT2';
   27: Result:='SourceT3';
  else
    Result:='Unknown';
  end
end;

class function TMtkCntReg.PropsName(Index: integer): string;
begin
  case Index of
    0: Result:='Шифр параметра';
    1: Result:='Десктриптор';
    2: Result:='Канал связи';
    3: Result:='Регулятор';
    4: Result:='Опрос';
    5: Result:='Сигнализация';
    6: Result:='Квитирование';
    7: Result:='Тренд';
    8: Result:='Время опроса';
    9: Result:='Размерность';
   10: Result:='Формат PV';
   11: Result:='Верхняя граница шкалы PV';
   12: Result:='Верхняя предаварийная граница';
   13: Result:='Верхняя предупредительная граница';
   14: Result:='Нижняя предупредительная граница';
   15: Result:='Нижняя предаварийная граница';
   16: Result:='Нижняя граница шкалы PV';
   17: Result:='Контроль границ шкалы';
   18: Result:='Верхняя граница шкалы SP';
   19: Result:='Нижняя граница шкалы SP';
   20: Result:='Отклонение PV от SP вверх';
   21: Result:='Отклонение PV от SP вниз';
   22: Result:='Контроль шага изменения SP';
   23: Result:='Контроль шага изменения OP';
   24: Result:='Коэффициент усиления (K)';
   25: Result:='Интегральный коэффициент (T1)';
   26: Result:='Дифференциальный коэффициент (T2)';
   27: Result:='Скорость изменения задания (T3)';
  else
    Result:='';
  end
end;

function TMtkCntReg.PropsValue(Index: integer): string;
var sFormat: string;
begin
  sFormat:='%.'+Format('%d',[Ord(FPVFormat)])+'f';
  DecimalSeparator := '.';
  case Index of
    0: Result:=FPtName;
    1: Result:=FPtDesc;
    2: Result:=Format('%d',[FChannel]);
    3: Result:=Format('%d',[FNode]);
    4: Result:=IfThen(FActived,'Да','Нет');
    5: Result:=IfThen(FAsked,'Да','Нет');
    6: Result:=IfThen(FLogged,'Да','Нет');
    7: Result:=IfThen(FTrend,'Да','Нет');
    8: Result:=Format('%d сек',[FFetchTime]);
    9: Result:=FEUDesc;
   10: Result:=Format('D%d',[Ord(FPVFormat)]);
   11: Result:=Format(sFormat,[FPVEUHi]);
   12: Result:=Format(sFormat,[FPVHHTP])+' '+AAlmDB[FHHDB];
   13: Result:=Format(sFormat,[FPVHITP])+' '+AAlmDB[FHIDB];
   14: Result:=Format(sFormat,[FPVLOTP])+' '+AAlmDB[FLODB];
   15: Result:=Format(sFormat,[FPVLLTP])+' '+AAlmDB[FLLDB];
   16: Result:=Format(sFormat,[FPVEULo]);
   17: Result:=AAlmDB[FBadDB];
   18: Result:=Format(sFormat,[FSPEUHi]);
   19: Result:=Format(sFormat,[FSPEULo]);
   20: Result:=Format(sFormat,[FPVDHTP]);
   21: Result:=Format(sFormat,[FPVDLTP]);
   22: Result:=ACtoStr[FCheckSP];
   23: Result:=ACtoStr[FCheckOP];
   24: Result:=IfThen(Assigned(FK),SourceK,'');
   25: Result:=IfThen(Assigned(FT1),SourceT1,'');
   26: Result:=IfThen(Assigned(FT2),SourceT2,'');
   27: Result:=IfThen(Assigned(FT3),SourceT3,'');
  else
    Result:='';
  end
end;

procedure TMtkCntReg.RequestData;
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

procedure TMtkCntReg.SaveToStream(Stream: TStream);
begin
  Body.PtName:=PtName;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Node;
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
  Body.SPEULo:=SPEULo;
  Body.SPEUHi:=SPEUHi;
  Body.PVDHTP:=PVDHTP;
  Body.PVDLTP:=PVDLTP;
  Body.CheckSP:=CheckSP;
  Body.CheckOP:=CheckOP;
  Body.SourceK:=SourceK;
  Body.SourceT1:=SourceT1;
  Body.SourceT2:=SourceT2;
  Body.SourceT3:=SourceT3;
  Body.Trend:=Trend;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

procedure TMtkCntReg.SendOP(Value: Single);
var sFormat: string;
begin
  LastCommand:='OP';
  sFormat:='%.'+Format('%d',[Ord(FPVFormat)])+'f';
  DecimalSeparator := '.';
  Caddy.AddChange(FPtName,'OP',Format(sFormat,[OP]),Format(sFormat,[Value]),
                              FPtDesc,Caddy.Autor);
  LastTime:=FFetchTime;
  CommandMode:=29;
  CommandData:=Value;
  HasCommand:=True;
end;

procedure TMtkCntReg.SendSP(Value: Single);
var sFormat: string;
begin
  LastCommand:='SP';
  sFormat:='%.'+Format('%d',[Ord(FPVFormat)])+'f';
  DecimalSeparator := '.';
  Caddy.AddChange(FPtName,'SP',Format(sFormat,[SP]),Format(sFormat,[Value]),
                              FPtDesc,Caddy.Autor);
  LastTime:=FFetchTime;
  CommandMode:=25;
  CommandData:=Value;
  HasCommand:=True;
end;

procedure TMtkCntReg.SetK(const Value: TMtkAnaParam);
var S: string;
begin
  FK:=Value;
  S:=FSourceK;
  if Assigned(FK) then
    FSourceK:=Value.PtName
  else
    FSourceK:='';
  if S <> FSourceK then
  begin
    Caddy.AddChange(PtName,'Источник K',S,FSourceK,
                              PtDesc,Caddy.Autor);
    Caddy.Changed:=True;
  end;
end;

procedure TMtkCntReg.SetOP(const Value: Single);
begin
  if FOP <> Value then
  begin
    FOP:=Value;
  end;
end;

procedure TMtkCntReg.SetSP(const Value: Single);
begin
  if FSP <> Value then
  begin
    FSP:=Value;
  end;
end;

procedure TMtkCntReg.SetSPEUHi(const Value: Single);
  function FV(V: Single): string;
  begin
    Result:=Format('%.'+IntToStr(Ord(PVFormat))+'f',[V]);
  end;
begin
  if FSPEUHi <> Value then
  begin
    Caddy.AddChange(PtName,'SPEUHI',FV(FSPEUHi),FV(Value),
                              PtDesc,Caddy.Autor);
    FSPEUHi:=Value;
    Caddy.Changed:=True;
  end;
end;

procedure TMtkCntReg.SetSPEULo(const Value: Single);
  function FV(V: Single): string;
  begin
    Result:=Format('%.'+IntToStr(Ord(PVFormat))+'f',[V]);
  end;
begin
  if FSPEULo <> Value then
  begin
    Caddy.AddChange(PtName,'SPEULO',FV(FSPEULo),FV(Value),
                              PtDesc,Caddy.Autor);
    FSPEULo:=Value;
    Caddy.Changed:=True;
  end;
end;

procedure TMtkCntReg.SetT1(const Value: TMtkAnaParam);
var S: string;
begin
  FT1:=Value;
  S:=FSourceT1;
  if Assigned(FT1) then
    FSourceT1:=Value.PtName
  else
    FSourceT1:='';
  if S <> FSourceT1 then
  begin
    Caddy.AddChange(PtName,'Источник T1',S,FSourceT1,
                              PtDesc,Caddy.Autor);
    Caddy.Changed:=True;
  end;
end;

procedure TMtkCntReg.SetT2(const Value: TMtkAnaParam);
var S: string;
begin
  FT2 := Value;
  S:=FSourceT2;
  if Assigned(FT2) then
    FSourceT2:=Value.PtName
  else
    FSourceT2:='';
  if S <> FSourceT2 then
  begin
    Caddy.AddChange(PtName,'Источник T2',S,FSourceT2,
                              PtDesc,Caddy.Autor);
    Caddy.Changed:=True;
  end;
end;

procedure TMtkCntReg.SetT3(const Value: TMtkAnaParam);
var S: string;
begin
  FT3 := Value;
  S:=FSourceT3;
  if Assigned(FT3) then
    FSourceT3:=Value.PtName
  else
    FSourceT3:='';
  if S <> FSourceT3 then
  begin
    Caddy.AddChange(PtName,'Источник T3',S,FSourceT3,
                              PtDesc,Caddy.Autor);
    Caddy.Changed:=True;
  end;
end;

function TMtkCntReg.SPText: string;
begin
  if asNoLink in AlarmStatus then
    Result:='------'
  else
    Result:=Format('%.'+IntToStr(Ord(FPVFormat))+'f',[FSP])
end;

class function TMtkCntReg.TypeCode: string;
begin
  Result:='CR';
end;

class function TMtkCntReg.TypeColor: TColor;
begin
  Result:=$0099FFFF;
end;

function TMtkCntReg.GetFetchData: string;
begin
  SetLength(Result,12);
  MoveMemory(@Result[1],@PVRaw,4);
  MoveMemory(@Result[5],@SPRaw,4);
  MoveMemory(@Result[9],@OPRaw,4);
end;

initialization
{$IFDEF METACON515}
  with RegisterNode('Регуляторы "Метакон-515-Х-1"') do
  begin
    Add(RegisterEntity(TMtkAnaParam));
    RegisterEditForm(TMtkAPEditForm);
    RegisterPaspForm(TMtkAPPaspForm);
    Add(RegisterEntity(TMtkCntReg));
    RegisterEditForm(TMtkCREditForm);
    RegisterPaspForm(TMtkCRPaspForm);
  end;
{$ENDIF}
end.
