unit ElemerUnit;

interface

uses
  Windows, SysUtils, Classes, Graphics, ExtCtrls, Forms, Controls,
  Menus, ComCtrls, Messages, EntityUnit;

type
  TElemEditForm = class(TBaseEditForm)
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

  TTMAnaOut = class(TCustomAnaOut)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Channel: word;
      Node: word;
      Place: word;
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
      Reserve1: Cardinal;
      Reserve2: Cardinal;
      Reserve3: Cardinal;
      Reserve4: Cardinal;
      Reserve5: Cardinal;
    end;
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
    function AddressEqual(E: TEntity): boolean; override;
    property Place;
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

  TElemTMGroup = class(TCustomGroup)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Channel: word;
      Node: word;
      Actived: boolean;
      FetchTime: Cardinal;
      SourceName: string[10];
      Childs: array[0..7] of string[10];
      Reserve1: Cardinal;
      Reserve2: Cardinal;
      Reserve3: Cardinal;
      Reserve4: Cardinal;
      Reserve5: Cardinal;
    end;
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
  end;

implementation

uses Math, StrUtils, GetPtNameUnit;

{ TTMAnaOut }

function TTMAnaOut.AddressEqual(E: TEntity): boolean;
begin
  with E as TTMAnaOut do
  begin
    Result:=(Channel = Self.Channel) and
            (Node = Self.Node) and
            (Place = Self.Place);
  end;
end;

constructor TTMAnaOut.Create;
begin
  inherited;
  FCalcScale:=False;
end;

class function TTMAnaOut.EntityType: string;
begin
  Result:='���������� ����� TM5103';
end;

procedure TTMAnaOut.Fetch(const Data: string);
var S: string; Fail: boolean; V: Single; Err: integer;
begin
  inherited;
  S:=Data;
  Fail:=False;
  if (Pos('!',S)=1) and (Pos(';',S)>0) and
     (Copy(S,2,Pos(';',S)-2)=Format('%d',[FNode])) then
  begin
    Delete(S,1,Pos(';',S));
    if Pos(';',S)>0 then
    begin
      DecimalSeparator:='.';
      Val(Copy(S,1,Pos(';',S)-1),V,Err);
      if Err=0 then
        Raw:=V
      else
        Fail:=True;
    end
    else
      Fail:=True;
  end
  else
    Fail:=True;
  if Fail then
  begin
    if (Pos('$',S)=1) and (Pos(';',S)>0) then
      ErrorMess:='������ ������. (��� ������: '+Copy(S,2,Pos(';',S)-2)+')'
    else
      ErrorMess:='������ ������ � �����������';
  end
  else
  begin
    ErrorMess:='';
    UpdateRealTime;
  end;
end;

function TTMAnaOut.LoadFromStream(Stream: TStream): integer;
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
  FPlace:=Body.Place;
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
end;

function TTMAnaOut.Prepare: string;
begin
  Result:=Format(':%d;1;%d;',[FNode,FPlace-1]);
end;

function TTMAnaOut.PropsCount: integer;
begin
  Result:=20;
end;

class function TTMAnaOut.PropsID(Index: integer): string;
begin
  case Index of
    0: Result:='PtName';
    1: Result:='PtDesc';
    2: Result:='Channel';
    3: Result:='Node';
    4: Result:='Place';
    5: Result:='Active';
    6: Result:='Alarm';
    7: Result:='Confirm';
    8: Result:='Trend';
    9: Result:='FetchTime';
   10: Result:='Source';
   11: Result:='EUDesc';
   12: Result:='FormatPV';
   13: Result:='PVEUHI';
   14: Result:='PVHHTP';
   15: Result:='PVHITP';
   16: Result:='PVLOTP';
   17: Result:='PVLLTP';
   18: Result:='PVEULO';
   19: Result:='BadDB';
  else
    Result:='Unknown';
  end
end;

class function TTMAnaOut.PropsName(Index: integer): string;
begin
  case Index of
    0: Result:='���� ���������';
    1: Result:='�����������';
    2: Result:='����� �����';
    3: Result:='����� �������';
    4: Result:='����� ������';
    5: Result:='�����';
    6: Result:='������������';
    7: Result:='������������';
    8: Result:='�����';
    9: Result:='����� ������';
   10: Result:='�������� ������';
   11: Result:='�����������';
   12: Result:='������ PV';
   13: Result:='������� ������� �����';
   14: Result:='������� ������������� �������';
   15: Result:='������� ����������������� �������';
   16: Result:='������ ����������������� �������';
   17: Result:='������ ������������� �������';
   18: Result:='������ ������� �����';
   19: Result:='�������� ������ �����';
  else
    Result:='';
  end
end;

function TTMAnaOut.PropsValue(Index: integer): string;
var sFormat: string;
begin
  sFormat:='%.'+Format('%d',[Ord(FPVFormat)])+'f';
  DecimalSeparator := '.';
  case Index of
    0: Result:=FPtName;
    1: Result:=FPtDesc;
    2: Result:=Format('%d',[FChannel]);
    3: Result:=Format('%d',[FNode]);
    4: Result:=Format('%d',[FPlace]);
    5: Result:=IfThen(FActived,'��','���');
    6: Result:=IfThen(FAsked,'��','���');
    7: Result:=IfThen(FLogged,'��','���');
    8: Result:=IfThen(FTrend,'��','���');
    9: Result:=Format('%d ���',[FFetchTime]);
   10: Result:=IfThen(Assigned(FSourceEntity),FSourceName,'����');
   11: Result:=FEUDesc;
   12: Result:=Format('D%d',[Ord(FPVFormat)]);
   13: Result:=Format(sFormat,[FPVEUHi]);
   14: Result:=Format(sFormat,[FPVHHTP])+' '+AAlmDB[FHHDB];
   15: Result:=Format(sFormat,[FPVHITP])+' '+AAlmDB[FHIDB];
   16: Result:=Format(sFormat,[FPVLOTP])+' '+AAlmDB[FLODB];
   17: Result:=Format(sFormat,[FPVLLTP])+' '+AAlmDB[FLLDB];
   18: Result:=Format(sFormat,[FPVEULo]);
   19: Result:=AAlmDB[FBadDB];
  else
    Result:='';
  end
end;

procedure TTMAnaOut.SaveToStream(Stream: TStream);
begin
  Body.PtName:=PtName;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Node;
  Body.Place:=Place;
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
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

class function TTMAnaOut.TypeCode: string;
begin
  Result:='TM';
end;

class function TTMAnaOut.TypeColor: TColor;
begin
  Result:=$0099FFFF;
end;

{ TElemEditForm }

procedure TElemEditForm.AddBoolItem(Value: boolean);
var M: TMenuItem;
begin
  M:=TMenuItem.Create(Self);
  M.Caption:='���';
  M.Checked:=not Value;
  M.Tag:=0;
  M.OnClick:=ChangeBooleanClick;
  PopupMenu1.Items.Add(M);
  M:=TMenuItem.Create(Self);
  M.Caption:='��';
  M.Checked:=Value;
  M.Tag:=1;
  M.OnClick:=ChangeBooleanClick;
  PopupMenu1.Items.Add(M);
end;

procedure TElemEditForm.BaseFresh(var Mess: TMessage);
begin
  UpdateRealTime;
end;

procedure TElemEditForm.ChangeBooleanClick(Sender: TObject);
var L: TListItem; M: TMenuItem; B: Boolean;
begin
  if not Assigned(E) then Exit;
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  B:=(M.Tag = 1);
  if Assigned(L) then
  begin
    if L.Caption = '�����' then
    begin
      E.Actived:=B;
      L.SubItems[0]:=IfThen(E.Actived,'��','���');
    end;
  end;
end;

procedure TElemEditForm.ChangeFetchClick(Sender: TObject);
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
           if InputIntegerDlg(L.Caption+' (� ���.)',V) then
           begin
             if V < 1 then V:=1;
             E.FetchTime:=V;
             L.SubItems[0]:=Format('%d ���',[E.FetchTime]);
           end;
         end;
    else
      begin
        E.FetchTime:=M.Tag;
        L.SubItems[0]:=Format('%d ���',[E.FetchTime]);
      end;
    end;
  end;
end;

procedure TElemEditForm.ChangeIntegerClick(Sender: TObject);
var L: TListItem; V: Integer;
begin
  if not Assigned(E) then Exit;
  L:=ListView1.Selected;
  if Assigned(L) then
  begin
    if L.Caption = '����� �����' then V:=E.Channel
    else
      if L.Caption = '����� �������' then V:=E.Node
      else
        Exit;
    if InputIntegerDlg(L.Caption,V) then
    begin
      if L.Caption = '����� �����' then
      begin
        if InRange(V,1,ChannelCount) then
        begin
          E.Channel:=V;
          L.SubItems[0]:=Format('%d',[E.Channel]);
        end
        else
          raise ERangeError.Create('�������� ��� ���������� ������!');
      end
      else
      if L.Caption = '����� �������' then
      begin
        if InRange(V,1,32) then
        begin
          E.Node:=V;
          L.SubItems[0]:=Format('%d',[E.Node]);
        end
        else
          raise ERangeError.Create('�������� ��� ���������� ������ (1..32)!');
      end;
      if (L.Caption = '����� �����') or
         (L.Caption = '����� �������') then
      begin
        UpdateBaseView(Self);
        RestoreEntityPos(E);
      end;
    end;
  end;
end;

procedure TElemEditForm.ChangeTextClick(Sender: TObject);
var L: TListItem; S: string;
begin
  if not Assigned(E) then Exit;
  L:=ListView1.Selected;
  if Assigned(L) then
  begin
    if L.Caption = '���������� �������' then
      S:=L.SubItems[0]
    else
      Exit;
    if InputStringDlg(L.Caption,S,50) then
    begin
      if L.Caption = '���������� �������' then
      begin
        E.PtDesc:=S;
        L.SubItems[0]:=E.PtDesc;
      end;
    end;
  end;
end;

procedure TElemEditForm.ConnectBaseEditor(var Mess: TMessage);
begin
  ConnectImageList(TImageList(Mess.WParam));
  ConnectEntity(TEntity(Mess.LParam));
end;

procedure TElemEditForm.ConnectEntity(Entity: TEntity);
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
        Caption:='���� �������';
        SubItems.Add(E.PtName+' - '+E.EntityType);
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='���������� �������';
        SubItems.Add(E.PtDesc);
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='�����';
        SubItems.Add(IfThen(E.Actived,'��','���'));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='����� ������';
        SubItems.Add(Format('%d ���',[E.FetchTime]));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='����������';
        if E.RealTime > 0 then
          SubItems.Add(Format('%.3f',[E.RealTime/1000])+' ���')
        else
          SubItems.Add('��� ������');
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='����� �����';
        SubItems.Add(IntToStr(E.Channel));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='����� �������';
        SubItems.Add(IntToStr(E.Node));
      end;
    finally
      Items.EndUpdate;
    end;
  end;
end;

procedure TElemEditForm.ConnectImageList(ImageList: TImageList);
begin
  ListView1.SmallImages:=ImageList;
end;

constructor TElemEditForm.Create(AOwner: TComponent);
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
      Caption:='��������';
      Width:=250;
    end;
    with Columns.Add do
    begin
      Caption:='��������';
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

destructor TElemEditForm.Destroy;
begin
  ListView1.Free;
  PopupMenu.Free;;
  inherited;
end;

procedure TElemEditForm.ListView1DblClick(Sender: TObject);
begin
  if (ListView1.Selected <> nil) and
     (ListView1.Selected.Caption = '�������� ������') then
  begin
    if Assigned(E.SourceEntity) then
      E.SourceEntity.ShowEditor(Monitor.MonitorNum);
  end;
end;

procedure TElemEditForm.PopupMenu1Popup(Sender: TObject);
var L: TListItem; M: TMenuItem;
begin
  L:=ListView1.Selected;
  with PopupMenu1 do
  begin
    Items.Clear;
    if Assigned(L) then
    begin
      if L.Caption = '���� �������' then
      begin
        M:=TMenuItem.Create(Self);
        M.Caption:='�������� ��� �����...';
        M.OnClick:=ChangePtNameClick;
        Items.Add(M);
        M:=TMenuItem.Create(Self);
        M.Caption:='-';
        Items.Add(M);
        M:=TMenuItem.Create(Self);
        M.Caption:='����������� �����...';
        M.OnClick:=DoubleEntityClick;
        Items.Add(M);
        M:=TMenuItem.Create(Self);
        M.Caption:='������� �����';
        M.OnClick:=DeleteEntityClick;
        Items.Add(M);
      end
      else
      if L.Caption = '���������� �������' then
      begin
        M:=TMenuItem.Create(Self);
        M.Caption:='�������� �����...';
        M.OnClick:=ChangeTextClick;
        Items.Add(M);
      end
      else
      if (L.Caption = '����� �����') or
         (L.Caption = '����� �������') then
      begin
        M:=TMenuItem.Create(Self);
        M.Caption:='�������� �����...';
        M.OnClick:=ChangeIntegerClick;
        Items.Add(M);
      end
      else
      if L.Caption = '�����' then
      begin
        M:=TMenuItem.Create(Self);
        M.Caption:='���';
        M.Checked:=not E.Actived;
        M.Tag:=0;
        M.OnClick:=ChangeBooleanClick;
        Items.Add(M);
        M:=TMenuItem.Create(Self);
        M.Caption:='��';
        M.Checked:=E.Actived;
        M.Tag:=1;
        M.OnClick:=ChangeBooleanClick;
        Items.Add(M);
      end
      else
      if L.Caption = '����� ������' then
      begin
        M:=TMenuItem.Create(Self);
        M.Caption:='�������� ����� ������...';
        M.OnClick:=ChangeFetchClick; M.Tag:=0; Items.Add(M);
        //---
        M:=TMenuItem.Create(Self); M.Caption:='-'; Items.Add(M);
        //---
        M:=TMenuItem.Create(Self); M.Caption:='1 ���';
        M.Checked:=(E.FetchTime=1);
        M.Tag:=1; M.OnClick:=ChangeFetchClick; Items.Add(M);
        //---
        M:=TMenuItem.Create(Self); M.Caption:='2 ���';
        M.Checked:=(E.FetchTime=2);
        M.Tag:=2; M.OnClick:=ChangeFetchClick; Items.Add(M);
        //---
        M:=TMenuItem.Create(Self); M.Caption:='3 ���';
        M.Checked:=(E.FetchTime=3);
        M.Tag:=3; M.OnClick:=ChangeFetchClick; Items.Add(M);
        //---
        M:=TMenuItem.Create(Self); M.Caption:='5 ���';
        M.Checked:=(E.FetchTime=5);
        M.Tag:=5; M.OnClick:=ChangeFetchClick; Items.Add(M);
        //---
        M:=TMenuItem.Create(Self); M.Caption:='-'; Items.Add(M);
        //---
        M:=TMenuItem.Create(Self); M.Caption:='10 ���';
        M.Checked:=(E.FetchTime=10);
        M.Tag:=10; M.OnClick:=ChangeFetchClick; Items.Add(M);
        //---
        M:=TMenuItem.Create(Self); M.Caption:='20 ���';
        M.Checked:=(E.FetchTime=20);
        M.Tag:=20; M.OnClick:=ChangeFetchClick; Items.Add(M);
        //---
        M:=TMenuItem.Create(Self); M.Caption:='30 ���';
        M.Checked:=(E.FetchTime=30);
        M.Tag:=30; M.OnClick:=ChangeFetchClick; Items.Add(M);
        //---
        M:=TMenuItem.Create(Self); M.Caption:='-'; Items.Add(M);
        //---
        M:=TMenuItem.Create(Self); M.Caption:='1 ���';
        M.Checked:=(E.FetchTime=60);
        M.Tag:=60; M.OnClick:=ChangeFetchClick; Items.Add(M);
        //---
        M:=TMenuItem.Create(Self); M.Caption:='2 ���';
        M.Checked:=(E.FetchTime=120);
        M.Tag:=60*2; M.OnClick:=ChangeFetchClick; Items.Add(M);
        //---
        M:=TMenuItem.Create(Self); M.Caption:='5 ���';
        M.Checked:=(E.FetchTime=300);
        M.Tag:=60*5; M.OnClick:=ChangeFetchClick; Items.Add(M);
      end;
    end;
  end;
end;

procedure TElemEditForm.UpdateRealTime;
var L: TListItem;
begin
  if not Assigned(E) then Exit;
  if Caddy.UserLevel > 4 then
    ListView1.PopupMenu:=PopupMenu1
  else
    ListView1.PopupMenu:=nil;
//---------------------------------------------------------
  L:=ListView1.FindCaption(0,'����������',False,True,False);
  if L <> nil then
  begin
    if E.RealTime > 0 then
      L.SubItems[0]:=Format('%.3f',[E.RealTime/1000])+' ���'
    else
      L.SubItems[0]:='��� ������';
  end;
end;

{ TElemTMGroup }

procedure TElemTMGroup.ConnectLinks;
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

constructor TElemTMGroup.Create;
var i: integer;
begin
  inherited;
  for i:=0 to 7 do EntityChilds[i]:=nil;
end;

class function TElemTMGroup.EntityType: string;
begin
  Result:='������ ���������� �������� ��5103';
end;

procedure TElemTMGroup.Fetch(const Data: string);
var E: TEntity; Fail: boolean; i,Err: integer; V: Single; S: string;
begin
  inherited;
  UpdateRealTime;
  ErrorMess:=Data;
  Fail:=False;
  S:=Data;
  if (Pos('!',S)=1) and (Pos(';',S)>0) and
     (Copy(S,2,Pos(';',S)-2)=Format('%d',[FNode])) then
  begin
    Delete(S,1,Pos(';',S));
    for i:=0 to Count-1 do
    begin
      if FChilds.Objects[i] is TEntity then
      begin
        E:=TEntity(FChilds.Objects[i]);
        if E.Actived then
        begin
          if Pos(';',S) > 0 then
          begin
            DecimalSeparator:='.';
            Val(Copy(S,1,Pos(';',S)-1),V,Err);
            if Err=0 then
            begin
              E.Raw:=V;
              E.RealTime:=RealTime;
              if (asBadPV in E.AlarmStatus) then Caddy.RemoveAlarm(asBadPV,E);
            end
            else
            begin
              if (Pos('$',S)=1) and (Pos(';',S)>0) then
              begin
                E.ErrorMess:='������ ������. (��� ������: '+
                             Copy(S,2,Pos(';',S)-2)+')';
                ErrorMess:=E.ErrorMess;
                Fail:=True;
                if E.FLogged then
                  if not (asBadPV in E.AlarmStatus) then Caddy.AddAlarm(asBadPV,E);
              end;
            end;
          end
          else
            Fail:=True;
        end;
      end;
      Delete(S,1,Pos(';',S));
    end;
  end
  else
    Fail:=True;
  if Fail then
    ErrorMess:='���� ��� ��������� ������ ������ �������� ������ ������ � �����������'
  else
    ErrorMess:='';
end;

function TElemTMGroup.GetMaxChildCount: integer;
begin
  Result:=8;
end;

function TElemTMGroup.LoadFromStream(Stream: TStream): integer;
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
  FSourceName:=Body.SourceName;
  FChilds.Clear;
  for i:=0 to 7 do FChilds.AddObject(Body.Childs[i],nil);
end;

function TElemTMGroup.Prepare: string;
begin
   if FChilds.Count = 0 then
    Result:=''
  else
    Result:=Format(':%d;6;0;%d;',[FNode,Count]);
end;

function TElemTMGroup.PropsCount: integer;
begin
  Result:=14;
end;

class function TElemTMGroup.PropsID(Index: integer): string;
begin
  case Index of
    0: Result:='PtName';
    1: Result:='PtDesc';
    2: Result:='Channel';
    3: Result:='Node';
    4: Result:='Active';
    5: Result:='FetchTime';
    6..13: Result:='Temp'+IntToStr(Index-5);
  else
    Result:='Unknown';
  end
end;

class function TElemTMGroup.PropsName(Index: integer): string;
begin
  case Index of
    0: Result:='���� ���������';
    1: Result:='�����������';
    2: Result:='����� �����';
    3: Result:='����� �������';
    4: Result:='�����';
    5: Result:='����� ������';
    6..13: Result:='����������� '+IntToStr(Index-5);
  else
    Result:='';
  end
end;

function TElemTMGroup.PropsValue(Index: integer): string;
begin
  case Index of
    0: Result:=FPtName;
    1: Result:=FPtDesc;
    2: Result:=Format('%d',[FChannel]);
    3: Result:=Format('%d',[FNode]);
    4: Result:=IfThen(FActived,'��','���');
    5: Result:=Format('%d ���',[FFetchTime]);
    6..13: if (Index-6 < Count) and Assigned(EntityChilds[Index-6]) then
             Result:=Childs[Index-6]
           else
             Result:='';
  else
    Result:='';
  end
end;

procedure TElemTMGroup.SaveToStream(Stream: TStream);
var i: integer;
begin
  Body.PtName:=PtName;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Node;
  Body.Actived:=Actived;
  Body.FetchTime:=FetchTime;
  Body.SourceName:=SourceName;
  for i:=0 to 7 do Body.Childs[i]:='';
  for i:=0 to Count-1 do
    if (i in [0..7]) and Assigned(EntityChilds[i]) then
      Body.Childs[i]:=EntityChilds[i].PtName;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

class function TElemTMGroup.TypeCode: string;
begin
  Result:='GT';
end;

class function TElemTMGroup.TypeColor: TColor;
begin
  Result:=$00CC99FF;
end;

initialization
{$IFDEF ELEMERTM5103}
  with RegisterNode('���������� �������������� ��5103') do
  begin
    Add(RegisterEntity(TTMAnaOut));
    RegisterEditForm(TElemTMEditForm);
    RegisterPaspForm(TElemTMPaspForm);
    Add(RegisterEntity(TElemTMGroup));
    RegisterEditForm(TElemGTEditForm);
    RegisterPaspForm(TElemGTPaspForm);
  end;
{$ENDIF}
end.
