unit VirtVDPaspUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, Contnrs, EntityUnit, VirtualUnit;

type
  TVirtVDPaspForm = class(TForm,IEntity)
    Panel1: TPanel;
    PTNameDesc: TLabel;
    PTDesc: TLabel;
    ButtonToDataBase: TButton;
    ButtonToMainScreen: TButton;
    ConfigPanel: TPanel;
    Label55: TLabel;
    Label56: TLabel;
    PTActive: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    PVRAW: TLabel;
    Label63: TLabel;
    LinkSpeed: TLabel;
    LabelSourcePV: TLabel;
    PVSource: TLabel;
    Label9: TLabel;
    LastTime: TLabel;
    Panel6: TPanel;
    AlarmsPanel: TPanel;
    Panel3: TPanel;
    Entity: TLabel;
    Label61: TLabel;
    Label1: TLabel;
    LabelParameter: TLabel;
    StatusPanel: TPanel;
    Label11: TLabel;
    StatusListBox: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure AlarmOnMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AlarmOnMouseEnter(Sender: TObject);
    procedure AlarmOnMouseLeave(Sender: TObject);
    procedure ButtonToDataBaseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LabelDblClick(Sender: TObject);
    procedure ButtonToMainScreenClick(Sender: TObject);
  private
    ObjList: TComponentList;
    List,ListVal: TList;
    Blink: boolean;
    E: TVirtVDGroup;
    procedure ConnectEntity(Entity: TEntity); stdcall;
    procedure ConnectImageList(ImageList: TImageList); stdcall;
    procedure UpdateRealTime; stdcall;
  public
  end;

var
  VirtVDPaspForm: TVirtVDPaspForm;

implementation

uses StrUtils, Math;

{$R *.dfm}

{ TVirtVDPaspForm }

procedure TVirtVDPaspForm.ConnectEntity(Entity: TEntity);
var i,YPos,XPos: integer; L: TLabel; P: TShape;
begin
  E:=Entity as TVirtVDGroup;
  PTNameDesc.Caption:=E.PtName;
  Self.Entity.Caption:=E.PtName;
  LabelParameter.Caption:=E.EntityType;
  PTDesc.Caption:=E.PtDesc;
  PTActive.Caption:=IfThen(E.Actived,'��','���');
  LinkSpeed.Caption:=Format('%d ���',[E.FetchTime]);
  if E.RealTime > 0 then
    LastTime.Caption:=Format('%.3f',[E.RealTime/1000])+' ���'
  else
    LastTime.Caption:='��� ������';
  if E.SourceEntity=nil then
    PVSource.Caption:='����'
  else
    PVSource.Caption:=E.SourceEntity.PtName;
  PVRAW.Caption:=IntToHex(Trunc(E.Raw),8)+'h';
//-------------------------------------------------------
  Screen.Cursor:=crHourGlass;
  try
    ListVal.Clear;
    List.Clear;
    ObjList.Clear;
    YPos:=Label2.Top+30; XPos:=0;
    for i:=0 to E.Count-1 do
    begin
      L:=TLabel.Create(Self);
      with L do
      begin
        Parent:=AlarmsPanel;
        Caption:=Format('%2d.',[i+1]);
        Left:=XPos;
        Top:=YPos;
        Transparent:=True;
      end;
      ObjList.Add(L);
      L:=TLabel.Create(Self);
      with L do
      begin
        Parent:=AlarmsPanel;
        AutoSize:=False;
        Font.Color:=clAqua;
        if Assigned(E.EntityChilds[i]) then
        begin
          Caption:=E.EntityChilds[i].PtName;
          Hint:=E.EntityChilds[i].PtDesc;
          ShowHint:=True;
          OnMouseEnter:=AlarmOnMouseEnter;
          OnMouseLeave:=AlarmOnMouseLeave;
          OnDblClick:=LabelDblClick;
        end
        else
          Caption:='------';
        Left:=XPos+30;
        Top:=YPos;
        Transparent:=True;
      end;
      ObjList.Add(L);
      P:=TShape.Create(Self);
      with P do
      begin
        Parent:=AlarmsPanel;
        Brush.Color:=clBlack;
        Left:=XPos+30-1;
        Top:=YPos-1;
        Width:=L.Width+2;
        Height:=L.Height+2;
       if Assigned(E.EntityChilds[i]) then
          Tag:=Integer(E.EntityChilds[i]);
      end;
      ObjList.Add(P);
      L.Tag:=Integer(P);
      L.BringToFront;
//---------------------------------
      L:=TLabel.Create(Self);
      with L do
      begin
        Parent:=AlarmsPanel;
        Font.Color:=clWhite;
        if Assigned(E.EntityChilds[i]) then
          Caption:=IfThen((E.EntityChilds[i] as TCustomDigOut).PV ,
                          '���."1"','���."0"')
        else
          Caption:='';
        Top:=YPos;
        Transparent:=True;
      end;
      ObjList.Add(L);
      if Assigned(E.EntityChilds[i]) then
        L.Tag:=Integer(E.EntityChilds[i]);
      ListVal.Add(L);
      L:=TLabel.Create(Self);
      with L do
      begin
        Parent:=AlarmsPanel;
        AutoSize:=False;
        Font.Color:=clWhite;
        if Assigned(E.EntityChilds[i]) then
        begin
          Caption:=(E.EntityChilds[i] as TCustomDigOut).PtText;
          OnMouseEnter:=AlarmOnMouseEnter;
          OnMouseLeave:=AlarmOnMouseLeave;
          OnMouseDown:=AlarmOnMouseDown;
        end
        else
          Caption:='';
        Top:=YPos;
        Transparent:=True;
      end;
      ObjList.Add(L);
      P:=TShape.Create(Self);
      with P do
      begin
        Parent:=AlarmsPanel;
        Brush.Color:=clBlack;
        Top:=YPos-1;
        Width:=L.Width+2;
        Height:=L.Height+2;
        if Assigned(E.EntityChilds[i]) then
          P.Tag:=Integer(E.EntityChilds[i]);
      end;
      ObjList.Add(P);
      L.Tag:=Integer(P);
      L.BringToFront;
      List.Add(L);
//----------------
      Inc(YPos,L.Height+2);
      if (i = 15) and (XPos = 0) then
      begin
        YPos:=Label2.Top+30;
      end;
    end;
  finally
    Screen.Cursor:=crDefault;
  end;
//-------------------------------------------------------
  UpdateRealTime;
end;

procedure TVirtVDPaspForm.ConnectImageList(ImageList: TImageList);
begin
// Stub
end;

procedure TVirtVDPaspForm.UpdateRealTime;
var i: integer; L: TLabel; P: TShape; T: TCustomDigOut; k: TAlarmState;
    PColor,LColor: TColor;
begin
  ButtonToDataBase.Visible:=Caddy.UserLevel > 4;
  if E.RealTime > 0 then
    LastTime.Caption:=Format('%.3f',[E.RealTime/1000])+' ���'
  else
    LastTime.Caption:='��� ������';
  PVRAW.Caption:=IntToHex(Trunc(E.Raw),8)+'h';
  StatusListBox.Caption:=E.ErrorMess;
//------------------------------------------
  for i:=0 to ListVal.Count-1 do
  begin
    L:=TLabel(ListVal[i]);
    if (L is TLabel) and (L.Tag > 0) then
    begin
      T:=TCustomDigOut(L.Tag);
      if T is TCustomDigOut then
        L.Caption:=IfThen(T.PV ,'���."1"','���."0"');
    end;
  end;
//------------------------------------------
  for i:=0 to List.Count-1 do
  begin
    L:=TLabel(List[i]);
    if L is TLabel then
    begin
      P:=TShape(L.Tag);
      if (P is TShape) and (P.Tag > 0) then
      begin
        T:=TCustomDigOut(P.Tag);
        if T is TCustomDigOut then
        begin
          L.Caption:=T.PtText;
          PColor:=clBlack;
          LColor:=clWhite;
          for k:=High(k) downto Low(k) do
          if (k in T.LostAlarmStatus) then
          begin
            PColor:=ABrushColor[k,(k in T.AlarmStatus),
                                  (k in T.ConfirmStatus),Blink];
            LColor:=AFontColor[k,(k in T.AlarmStatus),
                                 (k in T.ConfirmStatus),Blink];
          end;
          for k:=High(k) downto Low(k) do
          if (k in T.AlarmStatus) then
          begin
            PColor:=ABrushColor[k,(k in T.AlarmStatus),
                                  (k in T.ConfirmStatus),Blink];
            LColor:=AFontColor[k,(k in T.AlarmStatus),
                                 (k in T.ConfirmStatus),Blink];
          end;
          P.Brush.Color:=PColor;
          L.Font.Color:=LColor;
        end;
      end;
    end;
  end;
  Blink:=not Blink;
end;

procedure TVirtVDPaspForm.FormCreate(Sender: TObject);
begin
  List:=TList.Create;
  ListVal:=TList.Create;
  ObjList:=TComponentList.Create(True);
end;

procedure TVirtVDPaspForm.FormResize(Sender: TObject);
begin
  with ButtonToMainScreen do Left:=Self.Width-Width-5;
  with ButtonToDataBase do Left:=Self.Width-Width-10-ButtonToMainScreen.Width;
end;

procedure TVirtVDPaspForm.AlarmOnMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var L: TLabel; P: TShape; T: TEntity;
begin
  if Button = mbRight then
  begin
    if Caddy.UserLevel = 0 then
    begin
      Caddy.ShowMessage(kmWarning,'������������ �� ���������������!');
      Exit;
    end;
    L:=TLabel(Sender);
    if L is TLabel then
    begin
      P:=TShape(L.Tag);
      if (P is TShape) and (P.Tag > 0) then
      begin
        T:=TCustomDigOut(P.Tag);
        if T is TCustomDigOut then
          Caddy.SmartAskByEntity(T,T.AlarmStatus+T.LostAlarmStatus);
      end;
    end;      
  end;
end;

procedure TVirtVDPaspForm.AlarmOnMouseEnter(Sender: TObject);
begin
  with Sender as TLabel do
  begin
    TShape(Tag).Pen.Color:=clMoneyGreen;
    TShape(Tag).BringToFront;
    BringToFront;
  end;
end;

procedure TVirtVDPaspForm.AlarmOnMouseLeave(Sender: TObject);
begin
  with Sender as TLabel do
    TShape(Tag).Pen.Color:=clBlack;
end;

procedure TVirtVDPaspForm.ButtonToDataBaseClick(Sender: TObject);
begin
  E.ShowEditor(Monitor.MonitorNum);
end;

procedure TVirtVDPaspForm.FormDestroy(Sender: TObject);
begin
  ObjList.Free;
  List.Free;
  ListVal.Free;
end;

procedure TVirtVDPaspForm.LabelDblClick(Sender: TObject);
var L: TLabel; P: TShape; T: TEntity;
begin
  L:=TLabel(Sender);
  if L is TLabel then
  begin
    if L = PVSource then
      E.ShowParentPassport(Monitor.MonitorNum)
    else
    begin
      P:=TShape(L.Tag);
      if (P is TShape) and (P.Tag > 0) then
      begin
        T:=TCustomDigOut(P.Tag);
        if T is TCustomDigOut then
          T.ShowPassport(Monitor.MonitorNum);
      end;
    end;
  end;
end;

procedure TVirtVDPaspForm.ButtonToMainScreenClick(Sender: TObject);
begin
  E.ShowScheme(Monitor.MonitorNum);
end;

end.
