unit VirtFLPaspUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, EntityUnit, VirtualUnit;

type
  TVirtFLPaspForm = class(TForm,IEntity)
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
    Label59: TLabel;
    Label60: TLabel;
    PVRAW: TLabel;
    Label63: TLabel;
    LinkSpeed: TLabel;
    LabelFormatPV: TLabel;
    Invert: TLabel;
    LabelPTAsked: TLabel;
    PTAsked: TLabel;
    LabelSourcePV: TLabel;
    PVSource: TLabel;
    Label9: TLabel;
    LastTime: TLabel;
    Panel6: TPanel;
    AlarmsPanel: TPanel;
    Label78: TLabel;
    Label79: TLabel;
    Label80: TLabel;
    AlarmOn: TLabel;
    AlarmOff: TLabel;
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
    SwitchOn: TLabel;
    Label5: TLabel;
    SwitchOff: TLabel;
    ShapeON: TShape;
    LabelON: TLabel;
    ShapeOFF: TShape;
    LabelOFF: TLabel;
    EnterButton: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure AlarmOnMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AlarmOnMouseEnter(Sender: TObject);
    procedure AlarmOnMouseLeave(Sender: TObject);
    procedure ButtonToDataBaseClick(Sender: TObject);
    procedure PVSourceDblClick(Sender: TObject);
    procedure EnterButtonClick(Sender: TObject);
    procedure ButtonToMainScreenClick(Sender: TObject);
  private
    Blink: boolean;
    E: TVirtFlag;
    FPV,FAlarmOn,FAlarmOff,FSwitchOn,FSwitchOff: TShape;
    procedure ConnectEntity(Entity: TEntity); stdcall;
    procedure ConnectImageList(ImageList: TImageList); stdcall;
    procedure UpdateRealTime; stdcall;
  public
  end;

var
  VirtFLPaspForm: TVirtFLPaspForm;

implementation

uses StrUtils, Math, GetDigValUnit;

{$R *.dfm}

{ TVirtFLPaspForm }

procedure TVirtFLPaspForm.ConnectEntity(Entity: TEntity);
begin
  E:=Entity as TVirtFlag;
  PTNameDesc.Caption:=E.PtName;
  Self.Entity.Caption:=E.PtName;
  PTName.Caption:=E.PtName;
  LabelParameter.Caption:=E.EntityType;
  PTDesc.Caption:=E.PtDesc;
  PTActive.Caption:=IfThen(E.Actived,'��','���');
  LinkSpeed.Caption:=Format('%d ���',[E.FetchTime]);
  if E.RealTime > 0 then
    LastTime.Caption:=Format('%.3f',[E.RealTime/1000])+' ���'
  else
    LastTime.Caption:='��� ������';
  AlEnbSt.Caption:=IfThen(E.Logged,'��','���');
  PTAsked.Caption:=IfThen(E.Asked,'��','���');
  if E.SourceEntity=nil then
    PVSource.Caption:='����'
  else
    PVSource.Caption:=E.SourceEntity.PtName;
  PVRAW.Caption:=IfThen((E.Raw > 0),'���."1"','���."0"');
  PV.Caption:=E.PtText;
  Invert.Caption:=IfThen(E.Invert,'��','���');
  AlarmOn.Caption:=IfThen(E.AlarmUp,'��','���');
  AlarmOff.Caption:=IfThen(E.AlarmDown,'��','���');
  SwitchOn.Caption:=IfThen(E.SwitchUp,'��','���');
  SwitchOff.Caption:=IfThen(E.SwitchDown,'��','���');
  LabelOn.Caption:=E.TextUp;
  LabelOff.Caption:=E.TextDown;
  UpdateRealTime;
end;

procedure TVirtFLPaspForm.ConnectImageList(ImageList: TImageList);
begin
// Stub
end;

procedure TVirtFLPaspForm.UpdateRealTime;
var k: TAlarmState;
begin
  ButtonToDataBase.Visible:=Caddy.UserLevel > 4;
  EnterButton.Visible:=E.Actived and (Caddy.UserLevel > 1) and
                       not Assigned(E.SourceEntity);
  if E.RealTime > 0 then
    LastTime.Caption:=Format('%.3f',[E.RealTime/1000])+' ���'
  else
    LastTime.Caption:='��� ������';
  PVRAW.Caption:=IfThen((E.Raw > 0),'���."1"','���."0"');
  PV.Caption:=E.PtText;
  if E.PV then
  begin
    LabelOn.Font.Color:=ArrayDigColor[E.ColorUp];
    ShapeOn.Brush.Color:=ArrayDigColor[E.ColorUp];
    ShapeOff.Brush.Color:=clBlack;
    LabelOff.Font.Color:=clMoneyGreen;
  end
  else
  begin
    LabelOn.Font.Color:=clMoneyGreen;
    ShapeOn.Brush.Color:=clBlack;
    ShapeOff.Brush.Color:=ArrayDigColor[E.ColorDown];
    LabelOff.Font.Color:=ArrayDigColor[E.ColorDown];
  end;
//------------------------------------------------
  if (asOn in E.AlarmStatus) or (asOn in E.LostAlarmStatus) then
  begin
    FAlarmOn.Brush.Color:=ABrushColor[asOn,(asOn in E.AlarmStatus),
                                           (asOn in E.ConfirmStatus),Blink];
    AlarmOn.Font.Color:=AFontColor[asOn,(asOn in E.AlarmStatus),
                                        (asOn in E.ConfirmStatus),Blink];
  end
  else
  begin
    FAlarmOn.Brush.Color:=clBlack;
    AlarmOn.Font.Color:=clAqua;
  end;
  if (asOff in E.AlarmStatus) or (asOff in E.LostAlarmStatus) then
  begin
    FAlarmOff.Brush.Color:=ABrushColor[asOff,(asOff in E.AlarmStatus),
                                           (asOff in E.ConfirmStatus),Blink];
    AlarmOff.Font.Color:=AFontColor[asOff,(asOff in E.AlarmStatus),
                                        (asOff in E.ConfirmStatus),Blink];
  end
  else
  begin
    FAlarmOff.Brush.Color:=clBlack;
    AlarmOff.Font.Color:=clAqua;
  end;
//------------------------------------------------
  FPV.Brush.Color:=clBlack;
  PV.Font.Color:=clAqua;
  for k:=High(k) downto Low(k) do
  if (k in E.AlarmStatus) then
  begin
    FPV.Brush.Color:=ABrushColor[k,(k in E.AlarmStatus),
                                   (k in E.ConfirmStatus),Blink];
    PV.Font.Color:=AFontColor[k,(k in E.AlarmStatus),
                                (k in E.ConfirmStatus),Blink];
  end;
  for k:=High(k) downto Low(k) do
  if (k in E.LostAlarmStatus) then
  begin
    FPV.Brush.Color:=ABrushColor[k,(k in E.AlarmStatus),
                                   (k in E.ConfirmStatus),Blink];
    PV.Font.Color:=AFontColor[k,(k in E.AlarmStatus),
                                (k in E.ConfirmStatus),Blink];
  end;
//------------------------------------------
  if E.PV and E.SwitchUp then
  begin
    FSwitchOn.Brush.Color:=clAqua;
    SwitchOn.Font.Color:=clBlack;
  end
  else
  begin
    FSwitchOn.Brush.Color:=clBlack;
    SwitchOn.Font.Color:=clAqua;
  end;
  if not E.PV and E.SwitchDown then
  begin
    FSwitchOff.Brush.Color:=clAqua;
    SwitchOff.Font.Color:=clBlack;
  end
  else
  begin
    FSwitchOff.Brush.Color:=clBlack;
    SwitchOff.Font.Color:=clAqua;
  end;
  StatusListBox.Caption:=E.ErrorMess;
//------------------------------------------
  Blink:=not Blink;
end;

procedure TVirtFLPaspForm.FormCreate(Sender: TObject);
begin
  FAlarmOn:=TShape.Create(Self);
  FAlarmOn.Parent:=AlarmsPanel;
  with AlarmOn do
  begin
    FAlarmOn.SetBounds(Left-3,Top-1,Width+6,Height+2);
    FAlarmOn.Brush.Color:=clBlack;
    FAlarmOn.SendToBack;
    Tag:=Integer(FAlarmOn);
  end;
  FAlarmOff:=TShape.Create(Self);
  FAlarmOff.Parent:=AlarmsPanel;
  with AlarmOff do
  begin
    FAlarmOff.SetBounds(Left-3,Top-1,Width+6,Height+2);
    FAlarmOff.Brush.Color:=clBlack;
    FAlarmOff.SendToBack;
    Tag:=Integer(FAlarmOff);
  end;
  FSwitchOn:=TShape.Create(Self);
  FSwitchOn.Parent:=AlarmsPanel;
  with SwitchOn do
  begin
    FSwitchOn.SetBounds(Left-3,Top-1,Width+6,Height+2);
    FSwitchOn.Brush.Color:=clBlack;
    FSwitchOn.SendToBack;
    Tag:=Integer(FSwitchOn);
  end;
  FSwitchOff:=TShape.Create(Self);
  FSwitchOff.Parent:=AlarmsPanel;
  with SwitchOff do
  begin
    FSwitchOff.SetBounds(Left-3,Top-1,Width+6,Height+2);
    FSwitchOff.Brush.Color:=clBlack;
    FSwitchOff.SendToBack;
    Tag:=Integer(FSwitchOff);
  end;
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

procedure TVirtFLPaspForm.FormResize(Sender: TObject);
begin
  with ButtonToMainScreen do Left:=Self.Width-Width-5;
  with ButtonToDataBase do Left:=Self.Width-Width-10-ButtonToMainScreen.Width;
end;

procedure TVirtFLPaspForm.AlarmOnMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
  begin
    if Caddy.UserLevel = 0 then
    begin
      Caddy.ShowMessage(kmWarning,'������������ �� ���������������!');
      Exit;
    end;
    if Sender = AlarmOn then Caddy.SmartAskByEntity(E,[asON]);
    if Sender = AlarmOff then Caddy.SmartAskByEntity(E,[asOFF]);
    if Sender = PV then Caddy.SmartAskByEntity(E,E.AlarmStatus+E.LostAlarmStatus);
  end;
end;

procedure TVirtFLPaspForm.AlarmOnMouseEnter(Sender: TObject);
begin
  with Sender as TLabel do
  begin
    TShape(Tag).Pen.Color:=clMoneyGreen;
    TShape(Tag).BringToFront;
    BringToFront;
  end;
end;

procedure TVirtFLPaspForm.AlarmOnMouseLeave(Sender: TObject);
begin
  with Sender as TLabel do
    TShape(Tag).Pen.Color:=clBlack;
end;

procedure TVirtFLPaspForm.ButtonToDataBaseClick(Sender: TObject);
begin
  E.ShowEditor(Monitor.MonitorNum);
end;

procedure TVirtFLPaspForm.PVSourceDblClick(Sender: TObject);
begin
  E.ShowParentPassport(Monitor.MonitorNum);
end;

procedure TVirtFLPaspForm.EnterButtonClick(Sender: TObject);
var BoolValue: boolean; Value: Single;
begin
  if E.Invert then
    BoolValue:=not (E.Raw > 0)
  else
    BoolValue:=E.Raw > 0;
  if InputBooleanDlg(E.PtDesc,E.TextUp,E.TextDown,BoolValue) then
  begin
    if E.Invert then
    begin
      if BoolValue then
        Value:=0
      else
        Value:=1;
    end
    else
    begin
      if BoolValue then
        Value:=1
      else
        Value:=0;
    end;
    if Caddy.NetRole = nrClient then
    begin
      E.CommandData:=Value;
      E.HasCommand:=True;
    end
    else
      E.Raw:=Value;
  end;
end;

procedure TVirtFLPaspForm.ButtonToMainScreenClick(Sender: TObject);
begin
  E.ShowScheme(Monitor.MonitorNum);
end;

end.
