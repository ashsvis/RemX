unit ElemGTPaspUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, Contnrs, EntityUnit, ElemerUnit;

type
  TElemGTPaspForm = class(TForm,IEntity)
    Panel1: TPanel;
    PTNameDesc: TLabel;
    PTDesc: TLabel;
    ButtonToDataBase: TButton;
    ButtonToMainScreen: TButton;
    ConfigPanel: TPanel;
    Label55: TLabel;
    Label56: TLabel;
    PTActive: TLabel;
    Label63: TLabel;
    LinkSpeed: TLabel;
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
    Label3: TLabel;
    Node: TLabel;
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
    List: TList;
    Blink: boolean;
    E: TElemTMGroup;
    procedure ConnectEntity(Entity: TEntity); stdcall;
    procedure ConnectImageList(ImageList: TImageList); stdcall;
    procedure UpdateRealTime; stdcall;
  public
  end;

var
  ElemGTPaspForm: TElemGTPaspForm;

implementation

uses StrUtils, Math;

{$R *.dfm}

{ TVirtGRPaspForm }

procedure TElemGTPaspForm.ConnectEntity(Entity: TEntity);
var i,YPos,XPos,ScreenSizeIndex: integer; L: TLabel; P: TShape;
begin
  E:=Entity as TElemTMGroup;
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
  Node.Caption:=IntToStr(E.Node);
//-------------------------------------------------------
  Screen.Cursor:=crHourGlass;
  try
    if PanelWidth = 800 then
      ScreenSizeIndex:=0
    else
    if PanelWidth = 1280 then
      ScreenSizeIndex:=2
    else
    if PanelWidth = 1680 then
      ScreenSizeIndex:=3
    else
      ScreenSizeIndex:=1;
    List.Clear;
    ObjList.Clear;
    YPos:=Label2.Top+40; XPos:=0;
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
          OnMouseEnter:=AlarmOnMouseEnter;
          OnMouseLeave:=AlarmOnMouseLeave;
          OnDblClick:=LabelDblClick;
        end
        else
          Caption:='------';
        Left:=XPos+30;
        Top:=YPos;
        case ScreenSizeIndex of
         0: Width:=63;
         1: Width:=80;
         2,3: Width:=100;
        end;
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
        AutoSize:=False;
        Alignment:=taRightJustify;
        Font.Color:=clWhite;
        if Assigned(E.EntityChilds[i]) then
        begin
          Caption:=(E.EntityChilds[i] as TCustomAnaOut).PtText;
          OnMouseEnter:=AlarmOnMouseEnter;
          OnMouseLeave:=AlarmOnMouseLeave;
          OnMouseDown:=AlarmOnMouseDown;
        end
        else
          Caption:='';
        case ScreenSizeIndex of
         0: Left:=XPos+98;
         1: Left:=XPos+130;
         2,3: Left:=XPos+152;
        end;
        Top:=YPos;
        case ScreenSizeIndex of
         0: Width:=89;
         1: Width:=110;
         2,3: Width:=135;
        end;
        Transparent:=True;
      end;
      ObjList.Add(L);
      P:=TShape.Create(Self);
      with P do
      begin
        Parent:=AlarmsPanel;
        Brush.Color:=clBlack;
        case ScreenSizeIndex of
         0: Left:=XPos+98-1;
         1: Left:=XPos+130-1;
         2,3: Left:=XPos+152-1;
        end;
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
// Descriptors
      L:=TLabel.Create(Self);
      with L do
      begin
        Parent:=AlarmsPanel;
        AutoSize:=True;
        Font.Color:=clWhite;
        if Assigned(E.EntityChilds[i]) then
          Caption:=E.EntityChilds[i].PtDesc
        else
          Caption:='';
        case ScreenSizeIndex of
         0: Left:=XPos+204;
         1: Left:=XPos+260;
         2,3: Left:=XPos+325;
        end;
        Top:=YPos;
        Transparent:=True;
      end;
      ObjList.Add(L);
//----------------
      Inc(YPos,L.Height+2);
      if (i = 15) and (XPos = 0) then
      begin
        YPos:=Label2.Top+40;
        case ScreenSizeIndex of
         0: XPos:=280;
         1: XPos:=360;
         2,3: XPos:=450;
        end;
      end;
    end;
  finally
    Screen.Cursor:=crDefault;
  end;
//-------------------------------------------------------
  UpdateRealTime;
end;

procedure TElemGTPaspForm.ConnectImageList(ImageList: TImageList);
begin
// Stub
end;

procedure TElemGTPaspForm.UpdateRealTime;
var i: integer; L: TLabel; P: TShape; T: TCustomAnaOut; k: TAlarmState;
    PColor, LColor: TColor;
begin
  ButtonToDataBase.Visible:=Caddy.UserLevel > 4;
  if E.RealTime > 0 then
    LastTime.Caption:=Format('%.3f',[E.RealTime/1000])+' сек'
  else
    LastTime.Caption:='Нет опроса';
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
  Blink:=not Blink;
end;

procedure TElemGTPaspForm.FormCreate(Sender: TObject);
var ScreenSizeIndex,i: integer; L: TLabel; P: TPanel; S: TShape;
begin
  List:=TList.Create;
  ObjList:=TComponentList.Create(True);
//-------------------------------------------
  if PanelWidth = 800 then
    ScreenSizeIndex:=0
  else
  if PanelWidth = 1280 then
    ScreenSizeIndex:=2
  else
  if PanelWidth = 1680 then
    ScreenSizeIndex:=3
  else
    ScreenSizeIndex:=1;
  case ScreenSizeIndex of
   0: AlarmsPanel.Font.Size:=10;
   1: AlarmsPanel.Font.Size:=14;
   2,3: AlarmsPanel.Font.Size:=16;
  end;
  case ScreenSizeIndex of
    0: for i:=0 to Self.ComponentCount-1 do
       begin
         if Components[i] is TPanel then
         begin
           P:=Components[i] as TPanel;
           if P.Align <> alClient then
           begin
             P.Width:=Round(P.Width/1.28);
             P.Height:=Round(P.Height/1.28);
           end;
         end;
         if Components[i] is TLabel then
         begin
           L:=Components[i] as TLabel;
           L.Left:=Round(L.Left/1.28);
           L.Top:=Round(L.Top/1.28);
           L.Width:=Round(L.Width/1.28);
           L.Height:=Round(L.Height/1.28);
           L.Font.Size:=10;
           L.Font.Name:='Tahoma';
         end;
         if Components[i] is TShape then
         begin
           S:=Components[i] as TShape;
           S.Left:=Round(S.Left/1.28);
           S.Top:=Round(S.Top/1.28);
           S.Width:=Round(S.Width/1.28);
           S.Height:=Round(S.Height/1.28);
         end;
       end;
    2,3: for i:=0 to Self.ComponentCount-1 do
       begin
         if Components[i] is TPanel then
         begin
           P:=Components[i] as TPanel;
           if P.Align <> alClient then
           begin
             P.Width:=Round(P.Width/0.8);
             P.Height:=Round(P.Height/0.8);
           end;
         end;
         if Components[i] is TLabel then
         begin
           L:=Components[i] as TLabel;
           L.Left:=Round(L.Left/0.8);
           L.Top:=Round(L.Top/0.8);
           L.Width:=Round(L.Width/0.8);
           L.Height:=Round(L.Height/0.8);
           L.Font.Size:=16;
           L.Font.Name:='Tahoma';
           L.Layout:=tlCenter;
         end;
         if Components[i] is TShape then
         begin
           S:=Components[i] as TShape;
           S.Left:=Round(S.Left/0.8);
           S.Top:=Round(S.Top/0.8);
           S.Width:=Round(S.Width/0.8);
           S.Height:=Round(S.Height/0.8);
         end;
       end;
  end;
end;

procedure TElemGTPaspForm.FormResize(Sender: TObject);
begin
  with ButtonToMainScreen do Left:=Self.Width-Width-5;
  with ButtonToDataBase do Left:=Self.Width-Width-10-ButtonToMainScreen.Width;
end;

procedure TElemGTPaspForm.AlarmOnMouseDown(Sender: TObject;
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

procedure TElemGTPaspForm.AlarmOnMouseEnter(Sender: TObject);
begin
  with Sender as TLabel do
  begin
    TShape(Tag).Pen.Color:=clMoneyGreen;
    TShape(Tag).BringToFront;
    BringToFront;
  end;
end;

procedure TElemGTPaspForm.AlarmOnMouseLeave(Sender: TObject);
begin
  with Sender as TLabel do
    TShape(Tag).Pen.Color:=clBlack;
end;

procedure TElemGTPaspForm.ButtonToDataBaseClick(Sender: TObject);
begin
  E.ShowEditor(Monitor.MonitorNum);
end;

procedure TElemGTPaspForm.FormDestroy(Sender: TObject);
begin
  ObjList.Free;
  List.Free;
end;

procedure TElemGTPaspForm.LabelDblClick(Sender: TObject);
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

procedure TElemGTPaspForm.ButtonToMainScreenClick(Sender: TObject);
begin
  E.ShowScheme(Monitor.MonitorNum);
end;

end.
