unit VirtVCPaspUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, EntityUnit, VirtualUnit;

type
  TVirtVCPaspForm = class(TForm,IEntity)
    Panel1: TPanel;
    PTNameDesc: TLabel;
    PTDesc: TLabel;
    ButtonToDataBase: TButton;
    ButtonToMainScreen: TButton;
    PVPanel: TPanel;
    PTName: TLabel;
    LabelPV: TLabel;
    PV: TLabel;
    ConfigPanel: TPanel;
    Label55: TLabel;
    Label56: TLabel;
    LabelAlEnbSt: TLabel;
    PTActive: TLabel;
    AlEnbSt: TLabel;
    Label63: TLabel;
    LinkSpeed: TLabel;
    LabelPTAsked: TLabel;
    PTAsked: TLabel;
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
    ShapeON: TShape;
    LabelON: TLabel;
    ShapeOFF: TShape;
    LabelOFF: TLabel;
    Label78: TLabel;
    Label79: TLabel;
    StateALM: TLabel;
    Label2: TLabel;
    StateON: TLabel;
    Label4: TLabel;
    StateOFF: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    CommON: TLabel;
    CommOFF: TLabel;
    ValStateALM: TLabel;
    ValStateON: TLabel;
    ValStateOFF: TLabel;
    EnterButton: TButton;
    ValCommON: TLabel;
    ValCommOFF: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure StateALMMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure StateALMMouseEnter(Sender: TObject);
    procedure StateALMMouseLeave(Sender: TObject);
    procedure ButtonToDataBaseClick(Sender: TObject);
    procedure PVSourceDblClick(Sender: TObject);
    procedure StateALMDblClick(Sender: TObject);
    procedure EnterButtonClick(Sender: TObject);
    procedure ButtonToMainScreenClick(Sender: TObject);
  private
    Blink: boolean;
    E: TVirtValve;
    FPV,FStateALM,FStateON,FStateOFF,FCommON,FCommOFF: TShape;
    procedure ConnectEntity(Entity: TEntity); stdcall;
    procedure ConnectImageList(ImageList: TImageList); stdcall;
    procedure UpdateRealTime; stdcall;
  public
  end;

var
  VirtVCPaspForm: TVirtVCPaspForm;

implementation

uses StrUtils, Math, GetDigValUnit;

{$R *.dfm}

{ TVirtVCPaspForm }

procedure TVirtVCPaspForm.ConnectEntity(Entity: TEntity);
begin
  E:=Entity as TVirtValve;
  PTNameDesc.Caption:=E.PtName;
  Self.Entity.Caption:=E.PtName;
  PTName.Caption:=E.PtName;
  LabelParameter.Caption:=E.EntityType;
  PTDesc.Caption:=E.PtDesc;
  PTActive.Caption:=IfThen(E.Actived,'Да','Нет');
  LinkSpeed.Caption:=Format('%d сек',[E.FetchTime]);
  if E.RealTime > 0 then
    LastTime.Caption:=Format('%.3f',[E.RealTime/1000])+' сек'
  else
    LastTime.Caption:='Нет опроса';
  AlEnbSt.Caption:=IfThen(E.Logged,'Да','Нет');
  PTAsked.Caption:=IfThen(E.Asked,'Да','Нет');
  PV.Caption:=E.PtText;
  if Assigned(E.StatALM) then
    StateALM.Caption:=E.StatALM.PtName
  else
    StateALM.Caption:='------';
  if Assigned(E.StatON) then
    StateON.Caption:=E.StatON.PtName
  else
    StateON.Caption:='------';
  if Assigned(E.StatOFF) then
    StateOFF.Caption:=E.StatOFF.PtName
  else
    StateOFF.Caption:='------';
  if Assigned(E.CommON) then
    CommON.Caption:=E.CommON.PtName
  else
    CommON.Caption:='------';
  if Assigned(E.CommOFF) then
    CommOFF.Caption:=E.CommOFF.PtName
  else
    CommOFF.Caption:='------';
  UpdateRealTime;
end;

procedure TVirtVCPaspForm.ConnectImageList(ImageList: TImageList);
begin
// Stub
end;

procedure TVirtVCPaspForm.UpdateRealTime;
var k: TAlarmState;
begin
  ButtonToDataBase.Visible:=Caddy.UserLevel > 4;
  EnterButton.Visible := (Caddy.UserLevel > 1);
  if E.RealTime > 0 then
    LastTime.Caption:=Format('%.3f',[E.RealTime/1000])+' сек'
  else
    LastTime.Caption:='Нет опроса';
  PV.Caption:=E.PtText;
  case E.PV of
 0,4: begin // 'ХОД'
        ShapeON.Brush.Color:=$00282828;
        ShapeOFF.Brush.Color:=$00282828;
        LabelON.Font.Color:=clGreen;
        LabelOFF.Font.Color:=clMaroon;
      end;
 1,5: begin // 'ЗАКРЫТО'
        ShapeON.Brush.Color:=clBlack;
        ShapeOFF.Brush.Color:=clRed;
        LabelON.Font.Color:=clGreen;
        LabelOFF.Font.Color:=clRed;
      end;
 2,6: begin // 'ОТКРЫТО'
        ShapeON.Brush.Color:=clLime;
        ShapeOFF.Brush.Color:=clBlack;
        LabelON.Font.Color:=clLime;
        LabelOFF.Font.Color:=clMaroon;
      end;
 3,7: begin // 'АВАРИЯ'
        ShapeON.Brush.Color:=clLime;
        ShapeOFF.Brush.Color:=clRed;
        LabelON.Font.Color:=clLime;
        LabelOFF.Font.Color:=clRed;
      end;
  end;
  if Assigned(E.StatALM) then
    ValStateALM.Caption:=E.StatALM.PtText
  else
    ValStateALM.Caption:='------';
  if Assigned(E.StatON) then
    ValStateON.Caption:=E.StatON.PtText
  else
    ValStateON.Caption:='------';
  if Assigned(E.StatOFF) then
    ValStateOFF.Caption:=E.StatOFF.PtText
  else
    ValStateOFF.Caption:='------';
//------------------------------------------------
  if Assigned(E.CommON) then
    ValCommON.Caption:=E.CommON.PtText
  else
    ValCommON.Caption:='------';
  if Assigned(E.CommOFF) then
    ValCommOFF.Caption:=E.CommOFF.PtText
  else
    ValCommOFF.Caption:='------';
//------------------------------------------------
  FPV.Brush.Color:=clBlack;
  PV.Font.Color:=clAqua;
  for k:=High(k) downto Low(k) do
  if (k in E.LostAlarmStatus) then
  begin
    FPV.Brush.Color:=ABrushColor[k,(k in E.AlarmStatus),
                                   (k in E.ConfirmStatus),Blink];
    PV.Font.Color:=AFontColor[k,(k in E.AlarmStatus),
                                (k in E.ConfirmStatus),Blink];
  end;
  for k:=High(k) downto Low(k) do
  if (k in E.AlarmStatus) then
  begin
    FPV.Brush.Color:=ABrushColor[k,(k in E.AlarmStatus),
                                   (k in E.ConfirmStatus),Blink];
    PV.Font.Color:=AFontColor[k,(k in E.AlarmStatus),
                                (k in E.ConfirmStatus),Blink];
  end;
  StatusListBox.Caption:=E.ErrorMess;
//------------------------------------------
  Blink:=not Blink;
end;

procedure TVirtVCPaspForm.FormCreate(Sender: TObject);
begin
  FStateALM:=TShape.Create(Self);
  FStateALM.Parent:=AlarmsPanel;
  with StateALM do
  begin
    FStateALM.SetBounds(Left-3,Top-1,Width+6,Height+2);
    FStateALM.Brush.Color:=clBlack;
    FStateALM.SendToBack;
    Tag:=Integer(FStateALM);
  end;
//---------------------------------
  FStateON:=TShape.Create(Self);
  FStateON.Parent:=AlarmsPanel;
  with StateON do
  begin
    FStateON.SetBounds(Left-3,Top-1,Width+6,Height+2);
    FStateON.Brush.Color:=clBlack;
    FStateON.SendToBack;
    Tag:=Integer(FStateON);
  end;
//---------------------------------
  FStateOFF:=TShape.Create(Self);
  FStateOFF.Parent:=AlarmsPanel;
  with StateOFF do
  begin
    FStateOFF.SetBounds(Left-3,Top-1,Width+6,Height+2);
    FStateOFF.Brush.Color:=clBlack;
    FStateOFF.SendToBack;
    Tag:=Integer(FStateOFF);
  end;
//---------------------------------
  FCommON:=TShape.Create(Self);
  FCommON.Parent:=AlarmsPanel;
  with CommON do
  begin
    FCommON.SetBounds(Left-3,Top-1,Width+6,Height+2);
    FCommON.Brush.Color:=clBlack;
    FCommON.SendToBack;
    Tag:=Integer(FCommON);
  end;
//---------------------------------
  FCommOFF:=TShape.Create(Self);
  FCommOFF.Parent:=AlarmsPanel;
  with CommOFF do
  begin
    FCommOFF.SetBounds(Left-3,Top-1,Width+6,Height+2);
    FCommOFF.Brush.Color:=clBlack;
    FCommOFF.SendToBack;
    Tag:=Integer(FCommOFF);
  end;
//---------------------------------
  FPV:=TShape.Create(Self);
  FPV.Parent:=PVPanel;
  with PV do
  begin
    FPV.SetBounds(Left-3,Top-1,Width+6,Height+2);
    FPV.Brush.Color:=clBlack;
    FPV.SendToBack;
    Tag:=Integer(FPV);
  end;
end;

procedure TVirtVCPaspForm.FormResize(Sender: TObject);
begin
  with ButtonToMainScreen do Left:=Self.Width-Width-5;
  with ButtonToDataBase do Left:=Self.Width-Width-10-ButtonToMainScreen.Width;
end;

procedure TVirtVCPaspForm.StateALMMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
  begin
    if Caddy.UserLevel = 0 then
    begin
      Caddy.ShowMessage(kmWarning,'Пользователь не зарегистрирован!');
      Exit;
    end;
    if Sender = PV then Caddy.SmartAskByEntity(E,
                                           E.AlarmStatus+E.LostAlarmStatus);
  end;
end;

procedure TVirtVCPaspForm.StateALMMouseEnter(Sender: TObject);
begin
  with Sender as TLabel do
  begin
    TShape(Tag).Pen.Color:=clMoneyGreen;
    TShape(Tag).BringToFront;
    BringToFront;
  end;
end;

procedure TVirtVCPaspForm.StateALMMouseLeave(Sender: TObject);
begin
  with Sender as TLabel do
    TShape(Tag).Pen.Color:=clBlack;
end;

procedure TVirtVCPaspForm.ButtonToDataBaseClick(Sender: TObject);
begin
  E.ShowEditor(Monitor.MonitorNum);
end;

procedure TVirtVCPaspForm.PVSourceDblClick(Sender: TObject);
begin
  E.ShowParentPassport(Monitor.MonitorNum);
end;

procedure TVirtVCPaspForm.StateALMDblClick(Sender: TObject);
begin
  if (Sender = StateALM) and Assigned(E.StatALM) then
    E.StatALM.ShowPassport(Monitor.MonitorNum)
  else if (Sender = StateON) and Assigned(E.StatON) then
    E.StatON.ShowPassport(Monitor.MonitorNum)
  else if (Sender = StateOFF) and Assigned(E.StatOFF) then
    E.StatOFF.ShowPassport(Monitor.MonitorNum)
  else if (Sender = CommON) and Assigned(E.CommON) then
    E.CommON.ShowPassport(Monitor.MonitorNum)
  else if (Sender = CommOFF) and Assigned(E.CommOFF) then
    E.CommOFF.ShowPassport(Monitor.MonitorNum);
end;

procedure TVirtVCPaspForm.EnterButtonClick(Sender: TObject);
var ByteValue: Byte;
begin
  ByteValue:=E.PV;
  if InputValveDlg(E.PtDesc,ByteValue) then
  begin
    case ByteValue of
      1: E.SendClose;
      2: E.SendOpen;
    end;
  end;
end;

procedure TVirtVCPaspForm.ButtonToMainScreenClick(Sender: TObject);
begin
  E.ShowScheme(Monitor.MonitorNum);
end;

end.
