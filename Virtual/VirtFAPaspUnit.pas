unit VirtFAPaspUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, EntityUnit, VirtualUnit, Contnrs;

type
  TVirtFAPaspForm = class(TForm,IEntity)
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
    Label63: TLabel;
    LinkSpeed: TLabel;
    Label9: TLabel;
    LastTime: TLabel;
    Panel6: TPanel;
    AlarmsPanel: TPanel;
    Label78: TLabel;
    Panel3: TPanel;
    Entity: TLabel;
    Label61: TLabel;
    Label1: TLabel;
    LabelParameter: TLabel;
    StatusPanel: TPanel;
    Label11: TLabel;
    StatusListBox: TLabel;
    Label79: TLabel;
    DigWork: TLabel;
    DigWork_Val: TLabel;
    Label3: TLabel;
    AnaWork: TLabel;
    AnaWork_Val: TLabel;
    Label5: TLabel;
    PeriodKind: TLabel;
    Label7: TLabel;
    BaseKind: TLabel;
    Label8: TLabel;
    CalcKind: TLabel;
    Label10: TLabel;
    ResetVal: TLabel;
    Label14: TLabel;
    CutoffVal: TLabel;
    Label12: TLabel;
    Invert: TLabel;
    Label13: TLabel;
    ShiftHour: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PVHHTPMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PVHHTPMouseEnter(Sender: TObject);
    procedure PVHHTPMouseLeave(Sender: TObject);
    procedure ButtonToDataBaseClick(Sender: TObject);
    procedure AnaWorkDblClick(Sender: TObject);
    procedure DigWorkDblClick(Sender: TObject);
    procedure ResetButtonClick(Sender: TObject);
    procedure ButtonToMainScreenClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure AlarmOnMouseEnter(Sender: TObject);
    procedure AlarmOnMouseLeave(Sender: TObject);
    procedure LabelDblClick(Sender: TObject);
    procedure AlarmOnMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    Blink: boolean;
    E: TVirtFAGroup;
    FDigWork,FAnaWork: TShape;
    ObjList: TComponentList;
    List,ListVal: TList;
    procedure ConnectEntity(Entity: TEntity); stdcall;
    procedure ConnectImageList(ImageList: TImageList); stdcall;
    procedure UpdateRealTime; stdcall;
    function GetChildNames(Index: integer): string;
  public
  end;

var
  VirtFAPaspForm: TVirtFAPaspForm;

implementation

uses StrUtils, Math, RemXUnit;

{$R *.dfm}

{ TVirtFAPaspForm }

procedure TVirtFAPaspForm.ConnectEntity(Entity: TEntity);
var i,YPos,XPos: integer; L: TLabel; P: TShape;
begin
  E:=Entity as TVirtFAGroup;
  PTNameDesc.Caption:=E.PtName;
  Self.Entity.Caption:=E.PtName;
  LabelParameter.Caption:=E.EntityType;
  PTDesc.Caption:=E.PtDesc;
  PTActive.Caption:=IfThen(E.Actived,'Да','Нет');
  LinkSpeed.Caption:=Format('%d сек',[E.FetchTime]);
  if E.RealTime > 0 then
    LastTime.Caption:=Format('%.3f',[E.RealTime/1000])+' сек'
  else
    LastTime.Caption:='Нет опроса';
  PeriodKind.Caption:=APeriodKind[E.PeriodKind];
  BaseKind.Caption:=ABaseKind[E.BaseKind];
  CalcKind.Caption:=ACalcKind[E.CalcKind];
  ResetVal.Caption:=Format('%g',[E.Reset]);
  CutoffVal.Caption:=Format('%g',[E.CutOff]);
  ShiftHour.Caption:=IntToStr(E.ShiftHour);
  if Assigned(E.AnaWork) then
  begin
    AnaWork.Caption:=E.AnaWork.PtName;
    AnaWork.Hint:=E.AnaWork.PtDesc;
    AnaWork_Val.Caption:=E.AnaWork.PtText;
  end
  else
  begin
    AnaWork.Caption:='------';
    AnaWork.Hint:='';
    AnaWork_Val.Caption:='------';
  end;
  if Assigned(E.DigWork) then
  begin
    DigWork.Caption:=E.DigWork.PtName;
    DigWork.Hint:=E.DigWork.PtDesc;
    DigWork_Val.Caption:=E.DigWork.PtText;
  end
  else
  begin
    DigWork.Caption:='------';
    DigWork.Hint:='';
    DigWork_Val.Caption:='------';
  end;
  Invert.Caption:=IfThen(E.InvDigWork,'Да','Нет');
//-------------------------------------
  Screen.Cursor:=crHourGlass;
  try
    ListVal.Clear;
    List.Clear;
    ObjList.Clear;
    YPos:=Label2.Top+40; XPos:=20;
    for i:=0 to E.Count-1 do
    begin
      L:=TLabel.Create(Self);
      with L do
      begin
        Parent:=AlarmsPanel;
        Caption:=GetChildNames(i);
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
        Left:=XPos+30+250;
        Top:=YPos;
        Width:=110;
        Transparent:=True;
      end;
      ObjList.Add(L);
      P:=TShape.Create(Self);
      with P do
      begin
        Parent:=AlarmsPanel;
        Brush.Color:=clBlack;
        Left:=XPos+30+250-1;
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
        AutoSize:=False;
        Alignment:=taRightJustify;
        Font.Color:=clWhite;
        if Assigned(E.EntityChilds[i]) then
        begin
          Caption:=(E.EntityChilds[i] as TCustomAnaOut).PtText;
          OnMouseEnter:=AlarmOnMouseEnter;
          OnMouseLeave:=AlarmOnMouseLeave;
          OnMouseDown:=AlarmOnMouseDown;
          Tag:=Integer(E.EntityChilds[i]);
        end
        else
          Caption:='';
        Left := XPos + Trunc(PanelWidth * 0.3857421875);
        Left:=XPos+145+250;
        Top:=YPos;
        Width:=100;
        Transparent:=True;
      end;
      ObjList.Add(L);
      P:=TShape.Create(Self);
      with P do
      begin
        Parent:=AlarmsPanel;
        Brush.Color:=clBlack;
        Left := XPos + Trunc(PanelWidth * 0.3857421875) - 1;
        Left:=XPos+145+250-1;
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
    end;
  finally
    Screen.Cursor:=crDefault;
  end;
//-------------------------------------------------------
  UpdateRealTime;
end;

procedure TVirtFAPaspForm.ConnectImageList(ImageList: TImageList);
begin
// Stub
end;

procedure TVirtFAPaspForm.UpdateRealTime;
var i: integer; L: TLabel; T: TCustomAnaOut; P: TShape;
    k: TAlarmState; PColor,LColor: TColor;
begin
  ButtonToDataBase.Visible:=Caddy.UserLevel > 4;
  if E.RealTime > 0 then
    LastTime.Caption:=Format('%.3f',[E.RealTime/1000])+' сек'
  else
    LastTime.Caption:='Нет опроса';
  if Assigned(E.AnaWork) then
    AnaWork_Val.Caption:=E.AnaWork.PtText
  else
    AnaWork_Val.Caption:='------';
  if Assigned(E.DigWork) then
    DigWork_Val.Caption:=E.DigWork.PtText
  else
    DigWork_Val.Caption:='------';
  StatusListBox.Caption:=E.ErrorMess;
//------------------------------------------
  for i:=0 to List.Count-1 do
  begin
    L:=TLabel(List[i]);
    if L is TLabel then
    begin
      P:=TShape(L.Tag);
      if (P is TShape) and (P.Tag > 0) then
      begin
        T:=TCustomAnaOut(P.Tag);
        if T is TCustomAnaOut then
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
//------------------------------------------
  Blink:=not Blink;
end;

procedure TVirtFAPaspForm.FormCreate(Sender: TObject);
begin
  List:=TList.Create;
  ListVal:=TList.Create;
  ObjList:=TComponentList.Create(True);
//-------------------------------------------
  FDigWork:=TShape.Create(Self);
  FDigWork.Parent:=AlarmsPanel;
  with DigWork do
  begin
    FDigWork.SetBounds(Left-3,Top-1,Width+6,Height+2);
    FDigWork.Brush.Color:=clBlack;
    FDigWork.SendToBack;
    Tag:=Integer(FDigWork);
  end;
  FAnaWork:=TShape.Create(Self);
  FAnaWork.Parent:=AlarmsPanel;
  with AnaWork do
  begin
    FAnaWork.SetBounds(Left-3,Top-1,Width+6,Height+2);
    FAnaWork.Brush.Color:=clBlack;
    FAnaWork.SendToBack;
    Tag:=Integer(FAnaWork);
  end;
end;

procedure TVirtFAPaspForm.FormResize(Sender: TObject);
begin
  with ButtonToMainScreen do Left:=Self.Width-Width-5;
  with ButtonToDataBase do Left:=Self.Width-Width-10-ButtonToMainScreen.Width;
end;

procedure TVirtFAPaspForm.PVHHTPMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
  begin
    if Caddy.UserLevel = 0 then
    begin
      Caddy.ShowMessage(kmWarning,'Пользователь не зарегистрирован!');
      Exit;
    end;
  end;
end;

procedure TVirtFAPaspForm.PVHHTPMouseEnter(Sender: TObject);
begin
  with Sender as TLabel do
  begin
    TShape(Tag).Pen.Color:=clMoneyGreen;
    TShape(Tag).BringToFront;
    BringToFront;
  end;
end;

procedure TVirtFAPaspForm.PVHHTPMouseLeave(Sender: TObject);
begin
  with Sender as TLabel do
    TShape(Tag).Pen.Color:=clBlack;
end;

procedure TVirtFAPaspForm.ButtonToDataBaseClick(Sender: TObject);
begin
  E.ShowEditor(Monitor.MonitorNum);
end;

procedure TVirtFAPaspForm.AnaWorkDblClick(Sender: TObject);
begin
  if Assigned(E.AnaWork) then
    E.AnaWork.ShowPassport(Monitor.MonitorNum);
end;

procedure TVirtFAPaspForm.DigWorkDblClick(Sender: TObject);
begin
  if Assigned(E.DigWork) then
    E.DigWork.ShowPassport(Monitor.MonitorNum);
end;

procedure TVirtFAPaspForm.ResetButtonClick(Sender: TObject);
begin
  if RemxForm.ShowQuestion('Сбросить счетчик?')=mrOK then
  begin
    E.ResetTime(Now);
  end;
end;

procedure TVirtFAPaspForm.ButtonToMainScreenClick(Sender: TObject);
begin
  E.ShowScheme(Monitor.MonitorNum);
end;

procedure TVirtFAPaspForm.FormDestroy(Sender: TObject);
begin
  ObjList.Free;
  List.Free;
  ListVal.Free;
end;

procedure TVirtFAPaspForm.AlarmOnMouseEnter(Sender: TObject);
begin
  with Sender as TLabel do
  begin
    TShape(Tag).Pen.Color:=clMoneyGreen;
    TShape(Tag).BringToFront;
    BringToFront;
  end;
end;

procedure TVirtFAPaspForm.AlarmOnMouseLeave(Sender: TObject);
begin
  with Sender as TLabel do
    TShape(Tag).Pen.Color:=clBlack;
end;

procedure TVirtFAPaspForm.LabelDblClick(Sender: TObject);
var L: TLabel; P: TShape; T: TEntity;
begin
  L:=TLabel(Sender);
  if L is TLabel then
  begin
    P:=TShape(L.Tag);
    if (P is TShape) and (P.Tag > 0) then
    begin
      T:=TCustomAnaOut(P.Tag);
      if T is TCustomAnaOut then
        T.ShowPassport(Monitor.MonitorNum);
    end;
  end;
end;

procedure TVirtFAPaspForm.AlarmOnMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var L: TLabel; P: TShape; T: TEntity;
begin
  if Button = mbRight then
  begin
    if Caddy.UserLevel = 0 then
    begin
      Caddy.ShowMessage(kmWarning,'Пользователь не зарегистрирован!');
      Exit;
    end;
    L:=TLabel(Sender);
    if L is TLabel then
    begin
      P:=TShape(L.Tag);
      if (P is TShape) and (P.Tag > 0) then
      begin
        T:=TCustomAnaOut(P.Tag);
        if T is TCustomAnaOut then
          Caddy.SmartAskByEntity(T,T.AlarmStatus+T.LostAlarmStatus);
      end;
    end;
  end;
end;

function TVirtFAPaspForm.GetChildNames(Index: integer): string;
begin
  case Index of
    0: Result:='Текущее значение';
    1: Result:='Предыдущее значение';
    2: Result:='С начала часа';
    3: Result:='За предыдущий час';
    4: Result:='С начала суток';
    5: Result:='За предыдущие сутки';
    6: Result:='С начала месяца';
    7: Result:='За предыдущий месяц';
    8: Result:='С начала года';
    9: Result:='За предыдущий год';
  else
    Result:='';
  end;
end;

end.
