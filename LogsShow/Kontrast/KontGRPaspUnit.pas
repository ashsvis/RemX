unit KontGRPaspUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, Contnrs, EntityUnit, KontrastUnit;

type
  TKontGRPaspForm = class(TForm,IEntity)
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
    E: TKontCRGroup;
    procedure ConnectEntity(Entity: TEntity); stdcall;
    procedure ConnectImageList(ImageList: TImageList); stdcall;
    procedure UpdateRealTime; stdcall;
  public
  end;

var
  KontGRPaspForm: TKontGRPaspForm;

implementation

uses StrUtils, Math;

{$R *.dfm}

{ TVirtGRPaspForm }

procedure TKontGRPaspForm.ConnectEntity(Entity: TEntity);
var i,YPos,XPos: integer; L: TLabel; P: TShape;
begin
  E:=Entity as TKontCRGroup;
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
  Node.Caption:=IntToStr(E.Node);
//-------------------------------------------------------
  Screen.Cursor:=crHourGlass;
  try
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
          Caption:=(E.EntityChilds[i] as TKontCntReg).PtText;
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
        Top:=YPos;
        Transparent:=True;
      end;
      ObjList.Add(L);
//----------------
      Inc(YPos,L.Height+2);
      if (i = 15) and (XPos = 0) then
      begin
        YPos:=Label2.Top+40;
      end;
    end;
  finally
    Screen.Cursor:=crDefault;
  end;
//-------------------------------------------------------
  UpdateRealTime;
end;

procedure TKontGRPaspForm.ConnectImageList(ImageList: TImageList);
begin
// Stub
end;

procedure TKontGRPaspForm.UpdateRealTime;
var i: integer; L: TLabel; P: TShape; T: TKontCntReg; k: TAlarmState;
    PColor, LColor: TColor;
begin
  ButtonToDataBase.Visible:=Caddy.UserLevel > 4;
  if E.RealTime > 0 then
    LastTime.Caption:=Format('%.3f',[E.RealTime/1000])+' ���'
  else
    LastTime.Caption:='��� ������';
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
        T:=TKontCntReg(P.Tag);
        if T is TKontCntReg then
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

procedure TKontGRPaspForm.FormCreate(Sender: TObject);
begin
  List:=TList.Create;
  ObjList:=TComponentList.Create(True);
end;

procedure TKontGRPaspForm.FormResize(Sender: TObject);
begin
  with ButtonToMainScreen do Left:=Self.Width-Width-5;
  with ButtonToDataBase do Left:=Self.Width-Width-10-ButtonToMainScreen.Width;
end;

procedure TKontGRPaspForm.AlarmOnMouseDown(Sender: TObject;
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
        T:=TKontCntReg(P.Tag);
        if T is TKontCntReg then
          Caddy.SmartAskByEntity(T,T.AlarmStatus+T.LostAlarmStatus);
      end;
    end;      
  end;
end;

procedure TKontGRPaspForm.AlarmOnMouseEnter(Sender: TObject);
begin
  with Sender as TLabel do
  begin
    TShape(Tag).Pen.Color:=clMoneyGreen;
    TShape(Tag).BringToFront;
    BringToFront;
  end;
end;

procedure TKontGRPaspForm.AlarmOnMouseLeave(Sender: TObject);
begin
  with Sender as TLabel do
    TShape(Tag).Pen.Color:=clBlack;
end;

procedure TKontGRPaspForm.ButtonToDataBaseClick(Sender: TObject);
begin
  E.ShowEditor(Monitor.MonitorNum);
end;

procedure TKontGRPaspForm.FormDestroy(Sender: TObject);
begin
  ObjList.Free;
  List.Free;
end;

procedure TKontGRPaspForm.LabelDblClick(Sender: TObject);
var L: TLabel; P: TShape; T: TEntity;
begin
  L:=TLabel(Sender);
  if L is TLabel then
  begin
    P:=TShape(L.Tag);
    if (P is TShape) and (P.Tag > 0) then
    begin
      T:=TKontCntReg(P.Tag);
      if T is TKontCntReg then
        T.ShowPassport(Monitor.MonitorNum);
    end;
  end;
end;

procedure TKontGRPaspForm.ButtonToMainScreenClick(Sender: TObject);
begin
  E.ShowScheme(Monitor.MonitorNum);
end;

end.
