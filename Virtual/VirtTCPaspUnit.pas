unit VirtTCPaspUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, EntityUnit, VirtualUnit, RxGraph;

type
  TVirtTCPaspForm = class(TForm,IEntity)
    Panel1: TPanel;
    PTNameDesc: TLabel;
    PTDesc: TLabel;
    ButtonToDataBase: TButton;
    ButtonToMainScreen: TButton;
    PVPanel: TPanel;
    PTName: TLabel;
    EUDesc: TLabel;
    LabelPV: TLabel;
    PV: TLabel;
    ConfigPanel: TPanel;
    Label55: TLabel;
    Label56: TLabel;
    LabelAlEnbSt: TLabel;
    PTActive: TLabel;
    AlEnbSt: TLabel;
    Label59: TLabel;
    Label63: TLabel;
    LinkSpeed: TLabel;
    LabelFormatPV: TLabel;
    PVFormat: TLabel;
    LabelPTAsked: TLabel;
    PTAsked: TLabel;
    Label9: TLabel;
    LastTime: TLabel;
    Panel6: TPanel;
    AlarmsPanel: TPanel;
    Label78: TLabel;
    Label79: TLabel;
    DigWork_Val: TLabel;
    Label4: TLabel;
    HHHourTP: TLabel;
    Panel3: TPanel;
    Entity: TLabel;
    Label61: TLabel;
    Label1: TLabel;
    LabelParameter: TLabel;
    StatusPanel: TPanel;
    Label11: TLabel;
    Label6: TLabel;
    Label70: TLabel;
    PVEUHi: TLabel;
    StatusListBox: TLabel;
    DigWork: TLabel;
    Label2: TLabel;
    HIHourTP: TLabel;
    ResetButton: TButton;
    SetButton: TButton;
    Label10: TLabel;
    LASTPV: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PVHHTPMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PVHHTPMouseEnter(Sender: TObject);
    procedure PVHHTPMouseLeave(Sender: TObject);
    procedure ButtonToDataBaseClick(Sender: TObject);
    procedure DigWorkDblClick(Sender: TObject);
    procedure ResetButtonClick(Sender: TObject);
    procedure SetButtonClick(Sender: TObject);
    procedure ButtonToMainScreenClick(Sender: TObject);
  private
    Blink: boolean;
    E: TVirtTimeCounter;
    RxGraph: TRxGraph;
    FPV,FHHHourTP,FHiHourTP,FDigWork: TShape;
    procedure ConnectEntity(Entity: TEntity); stdcall;
    procedure ConnectImageList(ImageList: TImageList); stdcall;
    procedure UpdateRealTime; stdcall;
  public
  end;

var
  VirtTCPaspForm: TVirtTCPaspForm;

implementation

uses StrUtils, Math, DateUtils, GetPtNameUnit, RemXUnit;

{$R *.dfm}

{ TVirtTCPaspForm }

procedure TVirtTCPaspForm.ConnectEntity(Entity: TEntity);
var sFormat: string;
begin
  E:=Entity as TVirtTimeCounter;
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
  EUDesc.Caption:=ATimtoStr[E.PVFormat];
  PVFormat.Caption:=ATimtoStr[E.PVFormat];
  PVEUHi.Caption:=Format(sFormat,[E.PVEUHi]);
  LASTPV.Caption:=E.LASTPVText;
  PV.Caption:=E.PtText;
  LASTPV.Caption:=Format(sFormat,[E.LASTPV]);
  if Assigned(E.DigWork) then
    DigWork.Caption:=E.DigWork.PtName
  else
    DigWork.Caption:='------';
  if Assigned(E.DigWork) then
    DigWork_Val.Caption:=E.DigWork.PtText
  else
    DigWork_Val.Caption:='------';
  PVEUHi.Caption:=IntToStr(E.MaxHourValue);
  HHHourTP.Caption:=IntToStr(E.HHHourTP);
  HiHourTP.Caption:=IntToStr(E.HiHourTP);
//-------------------------------------
  RxGraph.ShowHH:=True;
  RxGraph.ShowHI:=True;
  RxGraph.ShowLO:=False;
  RxGraph.ShowLL:=False;
  if E.MaxHourValue > 0 then
  begin
    RxGraph.HHRAW:=Trunc(E.HHHourTP/E.MaxHourValue*100.0);
    RxGraph.HIRAW:=Trunc(E.HiHourTP/E.MaxHourValue*100.0);
  end;
  RxGraph.GraphType:=gtPV; // PV only
  RxGraph.Visible:=True;
  UpdateRealTime;
end;

procedure TVirtTCPaspForm.ConnectImageList(ImageList: TImageList);
begin
// Stub
end;

procedure TVirtTCPaspForm.UpdateRealTime;
var k: TAlarmState;
begin
  ButtonToDataBase.Visible:=Caddy.UserLevel > 4;
  ResetButton.Visible:=(Caddy.UserLevel > 1);
  SetButton.Visible:=(Caddy.UserLevel > 3);
  if E.RealTime > 0 then
    LastTime.Caption:=Format('%.3f',[E.RealTime/1000])+' сек'
  else
    LastTime.Caption:='Нет опроса';
  LASTPV.Caption:=E.LASTPVText;
  if E.Logged and (asNoLink in E.AlarmStatus) then
    PV.Caption:='------'
  else
    PV.Caption:=E.PtText;
  if Assigned(E.DigWork) then
    DigWork_Val.Caption:=E.DigWork.PtText
  else
    DigWork_Val.Caption:='------';
  if E.PV < 0.0 then
    RxGraph.PVRAW:=0
  else
  if E.PV > E.MaxHourValue*OneHour then
    RxGraph.PVRAW:=100
  else
  begin
    if E.MaxHourValue > 0 then
      RxGraph.PVRAW:=Trunc(E.PV*100/(E.MaxHourValue*OneHour));
  end;
//------------------------------------------------
  if (asHH in E.AlarmStatus) or (asHH in E.LostAlarmStatus) then
  begin
    FHHHourTP.Brush.Color:=ABrushColor[asHH,(asHH in E.AlarmStatus),
                                          (asHH in E.ConfirmStatus),Blink];
    HHHourTP.Font.Color:=AFontColor[asHH,(asHH in E.AlarmStatus),
                                       (asHH in E.ConfirmStatus),Blink];
  end
  else
  begin
    FHHHourTP.Brush.Color:=clBlack;
    HHHourTP.Font.Color:=clAqua;
  end;
  if (asHi in E.AlarmStatus) or (asHi in E.LostAlarmStatus) then
  begin
    FHiHourTP.Brush.Color:=ABrushColor[asHi,(asHi in E.AlarmStatus),
                                          (asHi in E.ConfirmStatus),Blink];
    HiHourTP.Font.Color:=AFontColor[asHi,(asHi in E.AlarmStatus),
                                       (asHi in E.ConfirmStatus),Blink];
  end
  else
  begin
    FHiHourTP.Brush.Color:=clBlack;
    HiHourTP.Font.Color:=clAqua;
  end;
//------------------------------------------
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

procedure TVirtTCPaspForm.FormCreate(Sender: TObject);
begin
  RxGraph:=TRxGraph.Create(Self);
  RxGraph.Visible:=False;
  RxGraph.Parent:=PVPanel;
  with RxGraph.Font do
  begin
    Name:='Tahoma';
    Size:=12;
    Color:=clMoneyGreen;
  end;
  RxGraph.PVRAW:=0;
//-------------------------------------------
  FHHHourTP:=TShape.Create(Self);
  FHHHourTP.Parent:=AlarmsPanel;
  with HHHourTP do
  begin
    FHHHourTP.SetBounds(Left-3,Top-1,Width+6,Height+2);
    FHHHourTP.Brush.Color:=clBlack;
    FHHHourTP.SendToBack;
    Tag:=Integer(FHHHourTP);
  end;
  FHiHourTP:=TShape.Create(Self);
  FHiHourTP.Parent:=AlarmsPanel;
  with HiHourTP do
  begin
    FHiHourTP.SetBounds(Left-3,Top-1,Width+6,Height+2);
    FHiHourTP.Brush.Color:=clBlack;
    FHiHourTP.SendToBack;
    Tag:=Integer(FHiHourTP);
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
  FDigWork:=TShape.Create(Self);
  FDigWork.Parent:=AlarmsPanel;
  with DigWork do
  begin
    FDigWork.SetBounds(Left-3,Top-1,Width+6,Height+2);
    FDigWork.Brush.Color:=clBlack;
    FDigWork.SendToBack;
    Tag:=Integer(FDigWork);
  end;
end;

procedure TVirtTCPaspForm.FormResize(Sender: TObject);
begin
  RxGraph.Left:=10;
  RxGraph.Width:=PVPanel.Width-30;
  RxGraph.Top:=0;
  RxGraph.Height:=PTName.Top-PTName.Height;
  with ButtonToMainScreen do Left:=Self.Width-Width-5;
  with ButtonToDataBase do Left:=Self.Width-Width-10-ButtonToMainScreen.Width;
end;

procedure TVirtTCPaspForm.PVHHTPMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
  begin
    if Caddy.UserLevel = 0 then
    begin
      Caddy.ShowMessage(kmWarning,'Пользователь не зарегистрирован!');
      Exit;
    end;
    if Sender = HHHourTP then Caddy.SmartAskByEntity(E,[asHH]);
    if Sender = HiHourTP then Caddy.SmartAskByEntity(E,[asHi]);
    if Sender = PV then Caddy.SmartAskByEntity(E,
                                           E.AlarmStatus+E.LostAlarmStatus);
  end;
end;

procedure TVirtTCPaspForm.PVHHTPMouseEnter(Sender: TObject);
begin
  with Sender as TLabel do
  begin
    TShape(Tag).Pen.Color:=clMoneyGreen;
    TShape(Tag).BringToFront;
    BringToFront;
  end;
end;

procedure TVirtTCPaspForm.PVHHTPMouseLeave(Sender: TObject);
begin
  with Sender as TLabel do
    TShape(Tag).Pen.Color:=clBlack;
end;

procedure TVirtTCPaspForm.ButtonToDataBaseClick(Sender: TObject);
begin
  E.ShowEditor(Monitor.MonitorNum);
end;

procedure TVirtTCPaspForm.DigWorkDblClick(Sender: TObject);
begin
  if Assigned(E.DigWork) then
    E.DigWork.ShowPassport(Monitor.MonitorNum);
end;

procedure TVirtTCPaspForm.ResetButtonClick(Sender: TObject);
begin
  if RemxForm.ShowQuestion('Сбросить счетчик?')=mrOK then
  begin
    if Caddy.NetRole = nrClient then
    begin
      E.CommandData:=0.0;
      E.HasCommand:=True;
    end
    else
      E.Reset;
  end;
end;

procedure TVirtTCPaspForm.SetButtonClick(Sender: TObject);
var Value: integer; S: string;
begin
  Value:=0;
  if InputIntegerDlg('Введите новое значение счетчика (часы)',Value) then
  begin
    if InRange(Value,0,E.MaxHourValue) then
    begin
      if Caddy.NetRole = nrClient then
      begin
        E.CommandData:=Value*1.0;
        E.HasCommand:=True;
      end
      else
      begin
        S:=E.PtText;
        E.ActualTime:=Value*OneHour;
        Caddy.AddChange(E.PtName,'PV',S,E.PtText,E.PtDesc,Caddy.Autor);
      end;
    end
    else
      Caddy.ShowMessage(kmError,Format('Ожидалось число в диапазоне %d..%d!',
                         [0,E.MaxHourValue]));
  end;
end;

procedure TVirtTCPaspForm.ButtonToMainScreenClick(Sender: TObject);
begin
  E.ShowScheme(Monitor.MonitorNum);
end;

end.
