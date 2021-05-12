unit VirtCAPaspUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, EntityUnit, VirtualUnit, RxGraph;

type
  TVirtCAPaspForm = class(TForm,IEntity)
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
    Label60: TLabel;
    PVRAW: TLabel;
    Label63: TLabel;
    LinkSpeed: TLabel;
    LabelFormatPV: TLabel;
    PVFormat: TLabel;
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
    Label81: TLabel;
    Label82: TLabel;
    PVHHTP: TLabel;
    PVLLTP: TLabel;
    PVHiTP: TLabel;
    PVLoTP: TLabel;
    PVLLDB: TLabel;
    PVLoDB: TLabel;
    PVHiDB: TLabel;
    PVHHDB: TLabel;
    Label4: TLabel;
    BADPVDB: TLabel;
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
    Label72: TLabel;
    PVEULo: TLabel;
    StatusListBox: TLabel;
    lbl1: TLabel;
    lblC1: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    lblC2: TLabel;
    lbl6: TLabel;
    lblC3: TLabel;
    lbl8: TLabel;
    lblC4: TLabel;
    lbl10: TLabel;
    lblC5: TLabel;
    lbl12: TLabel;
    lblC6: TLabel;
    lbl14: TLabel;
    lblC7: TLabel;
    lbl16: TLabel;
    lblC8: TLabel;
    lbl18: TLabel;
    lblC9: TLabel;
    lbl20: TLabel;
    lblVE1: TLabel;
    lbl22: TLabel;
    lblVE2: TLabel;
    lbl24: TLabel;
    lblVE3: TLabel;
    lbl26: TLabel;
    lblVE4: TLabel;
    lbl28: TLabel;
    lblVE5: TLabel;
    lbl30: TLabel;
    lblVE6: TLabel;
    lbl32: TLabel;
    lblVE7: TLabel;
    lbl34: TLabel;
    lblVE8: TLabel;
    lbl36: TLabel;
    lblVE9: TLabel;
    lblV1: TLabel;
    lblV2: TLabel;
    lblV3: TLabel;
    lblV4: TLabel;
    lblV5: TLabel;
    lblV6: TLabel;
    lblV7: TLabel;
    lblV8: TLabel;
    lblV9: TLabel;
    lbl2: TLabel;
    lblE1: TLabel;
    lbl9: TLabel;
    lblE2: TLabel;
    lbl15: TLabel;
    lblE3: TLabel;
    lbl21: TLabel;
    lblE4: TLabel;
    lbl27: TLabel;
    lblE5: TLabel;
    lbl33: TLabel;
    lblE6: TLabel;
    lbl38: TLabel;
    lblE7: TLabel;
    lbl41: TLabel;
    lblE8: TLabel;
    lbl44: TLabel;
    lblE9: TLabel;
    lbl47: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PVHHTPMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PVHHTPMouseEnter(Sender: TObject);
    procedure PVHHTPMouseLeave(Sender: TObject);
    procedure ButtonToDataBaseClick(Sender: TObject);
    procedure PVSourceDblClick(Sender: TObject);
    procedure ButtonToMainScreenClick(Sender: TObject);
    procedure EnterButtonClick(Sender: TObject);
  private
    Blink: boolean;
    E: TVirtCalc;
    RxGraph: TRxGraph;
    FPV,FPVHHTP,FPVHiTP,FPVLoTP,FPVLLTP: TShape;
    procedure ConnectEntity(Entity: TEntity); stdcall;
    procedure ConnectImageList(ImageList: TImageList); stdcall;
    procedure UpdateRealTime; stdcall;
  public
  end;

var
  VirtCAPaspForm: TVirtCAPaspForm;

implementation

uses StrUtils, Math, RemXUnit, GetPtNameUnit;

{$R *.dfm}

{ TVirtNNPaspForm }

procedure TVirtCAPaspForm.ConnectEntity(Entity: TEntity);
var sFormat: string; k: Double;
begin
  E:=Entity as TVirtCalc;
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
  if E.SourceEntity=nil then
    PVSource.Caption:='Авто'
  else
    PVSource.Caption:=E.SourceEntity.PtName;
  EUDesc.Caption:=E.EUDesc;
  PVFormat.Caption:=Format('D%d',[Ord(E.PVFormat)]);
  sFormat:='%.'+Format('%d',[Ord(E.PVFormat)])+'f';
  PVEUHi.Caption:=Format(sFormat,[E.PVEUHi]);
  PVHHTP.Caption:=Format(sFormat,[E.PVHHTP]);
  PVHHDB.Caption:=AAlmDB[E.HHDB];
  PVHiTP.Caption:=Format(sFormat,[E.PVHiTP]);
  PVHiDB.Caption:=AAlmDB[E.HIDB];
  PVLoTP.Caption:=Format(sFormat,[E.PVLoTP]);
  PVLoDB.Caption:=AAlmDB[E.LODB];
  PVLLTP.Caption:=Format(sFormat,[E.PVLLTP]);
  PVLLDB.Caption:=AAlmDB[E.LLDB];
  PVEULo.Caption:=Format(sFormat,[E.PVEULo]);
  BADPVDB.Caption:=AAlmDB[E.BadDB];
  PVRAW.Caption:=FloatToStr(E.Raw);
  PV.Caption:=Format(sFormat,[E.PV]);
//-------------------------------------
  RxGraph.ShowHH:=(E.HHDB <> adNone);
  RxGraph.ShowHI:=(E.HIDB <> adNone);
  RxGraph.ShowLO:=(E.LODB <> adNone);
  RxGraph.ShowLL:=(E.LLDB <> adNone);
  if Abs(E.PVEUHi-E.PVEULo) > 0.01 then
  begin
    k:=100/(E.PVEUHi-E.PVEULo);
    RxGraph.HHRAW:=Trunc((E.PVHHTP-E.PVEULo)*k);
    RxGraph.HIRAW:=Trunc((E.PVHITP-E.PVEULo)*k);
    RxGraph.LORAW:=Trunc((E.PVLOTP-E.PVEULo)*k);
    RxGraph.LLRAW:=Trunc((E.PVLLTP-E.PVEULo)*k);
  end;
  RxGraph.GraphType:=gtPV; // PV only
  RxGraph.Visible:=True;
  UpdateRealTime;
end;

procedure TVirtCAPaspForm.ConnectImageList(ImageList: TImageList);
begin
// Stub
end;

procedure TVirtCAPaspForm.UpdateRealTime;
var sFormat: string; k: TAlarmState; i: integer; L: TLabel;
begin
  ButtonToDataBase.Visible:=Caddy.UserLevel > 4;
  AlEnbSt.Caption:=IfThen(E.Logged,'Да','Нет');
  if E.RealTime > 0 then
    LastTime.Caption:=Format('%.3f',[E.RealTime/1000])+' сек'
  else
    LastTime.Caption:='Нет опроса';
  try
    PVRAW.Caption:=Format('%g',[RoundTo(E.Raw,-4)]);
  except
    PVRAW.Caption:='??????';
  end;
  sFormat:='%.'+Format('%d',[Ord(E.PVFormat)])+'f';
  if E.Logged and
     ((asShortBadPV in E.AlarmStatus) or (asOpenBadPV in E.AlarmStatus)) then
    PV.Caption:='------'
  else
    PV.Caption:=Format(sFormat,[E.PV]);
//------------------------------------------------
  if E.PV < E.PVEULo then
    RxGraph.PVRAW:=0
  else
  if E.PV > E.PVEUHi then
    RxGraph.PVRAW:=100
  else
  begin
    if Abs(E.PVEUHi-E.PVEULo) > 0.01 then
      RxGraph.PVRAW:=Trunc((E.PV-E.PVEULo)*100/(E.PVEUHi-E.PVEULo));
  end;
//------------------------------------------------
  if (asHH in E.AlarmStatus) or (asHH in E.LostAlarmStatus) then
  begin
    FPVHHTP.Brush.Color:=ABrushColor[asHH,(asHH in E.AlarmStatus),
                                          (asHH in E.ConfirmStatus),Blink];
    PVHHTP.Font.Color:=AFontColor[asHH,(asHH in E.AlarmStatus),
                                       (asHH in E.ConfirmStatus),Blink];
  end
  else
  begin
    FPVHHTP.Brush.Color:=clBlack;
    PVHHTP.Font.Color:=clAqua;
  end;
  if (asHi in E.AlarmStatus) or (asHi in E.LostAlarmStatus) then
  begin
    FPVHiTP.Brush.Color:=ABrushColor[asHi,(asHi in E.AlarmStatus),
                                          (asHi in E.ConfirmStatus),Blink];
    PVHiTP.Font.Color:=AFontColor[asHi,(asHi in E.AlarmStatus),
                                       (asHi in E.ConfirmStatus),Blink];
  end
  else
  begin
    FPVHiTP.Brush.Color:=clBlack;
    PVHiTP.Font.Color:=clAqua;
  end;
  if (asLo in E.AlarmStatus) or (asLo in E.LostAlarmStatus) then
  begin
    FPVLoTP.Brush.Color:=ABrushColor[asLo,(asLo in E.AlarmStatus),
                                          (asLo in E.ConfirmStatus),Blink];
    PVLoTP.Font.Color:=AFontColor[asLo,(asLo in E.AlarmStatus),
                                       (asLo in E.ConfirmStatus),Blink];
  end
  else
  begin
    FPVLoTP.Brush.Color:=clBlack;
    PVLoTP.Font.Color:=clAqua;
  end;
  if (asLL in E.AlarmStatus) or (asLL in E.LostAlarmStatus) then
  begin
    FPVLLTP.Brush.Color:=ABrushColor[asLL,(asLL in E.AlarmStatus),
                                          (asLL in E.ConfirmStatus),Blink];
    PVLLTP.Font.Color:=AFontColor[asLL,(asLL in E.AlarmStatus),
                                       (asLL in E.ConfirmStatus),Blink];
  end
  else
  begin
    FPVLLTP.Brush.Color:=clBlack;
    PVLLTP.Font.Color:=clAqua;
  end;
//------------------------------------------
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
  StatusListBox.Caption:=E.ErrorMess;
  DecimalSeparator:='.';
  for i:=1 to 9 do
  begin
    TLabel(FindComponent(Format('lblC%d',[i]))).Caption:=Format('%g',[E.AnaConst[i]]);
    L:=TLabel(FindComponent(Format('lblVE%d',[i])));
    if Assigned(E.AnaVar[i]) then
    begin
      L.Caption:=E.AnaVar[i].PtName;
      L.Hint:=E.AnaVar[i].PtDesc;
      L:=TLabel(FindComponent(Format('lblV%d',[i])));
      L.Caption:=E.AnaVar[i].PtText;
    end
    else
    begin
      L.Caption:='';
      L.Hint:='';
      L:=TLabel(FindComponent(Format('lblV%d',[i])));
      L.Caption:='';
    end;
    L:=TLabel(FindComponent(Format('lblE%d',[i])));
    L.Caption:=E.OperationToString(i);
  end;
//------------------------------------------
  Blink:=not Blink;
end;

procedure TVirtCAPaspForm.FormCreate(Sender: TObject);
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
  FPVHHTP:=TShape.Create(Self);
  FPVHHTP.Parent:=AlarmsPanel;
  with PVHHTP do
  begin
    FPVHHTP.SetBounds(Left-3,Top-1,Width+6,Height+2);
    FPVHHTP.Brush.Color:=clBlack;
    FPVHHTP.SendToBack;
    Tag:=Integer(FPVHHTP);
  end;
  FPVHiTP:=TShape.Create(Self);
  FPVHiTP.Parent:=AlarmsPanel;
  with PVHiTP do
  begin
    FPVHiTP.SetBounds(Left-3,Top-1,Width+6,Height+2);
    FPVHiTP.Brush.Color:=clBlack;
    FPVHiTP.SendToBack;
    Tag:=Integer(FPVHiTP);
  end;
  FPVLoTP:=TShape.Create(Self);
  FPVLoTP.Parent:=AlarmsPanel;
  with PVLoTP do
  begin
    FPVLoTP.SetBounds(Left-3,Top-1,Width+6,Height+2);
    FPVLoTP.Brush.Color:=clBlack;
    FPVLoTP.SendToBack;
    Tag:=Integer(FPVLoTP);
  end;
  FPVLLTP:=TShape.Create(Self);
  FPVLLTP.Parent:=AlarmsPanel;
  with PVLLTP do
  begin
    FPVLLTP.SetBounds(Left-3,Top-1,Width+6,Height+2);
    FPVLLTP.Brush.Color:=clBlack;
    FPVLLTP.SendToBack;
    Tag:=Integer(FPVLLTP);
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

procedure TVirtCAPaspForm.FormResize(Sender: TObject);
begin
  RxGraph.Left:=10;
  RxGraph.Width:=PVPanel.Width-30;
  RxGraph.Top:=0;
  RxGraph.Height:=PTName.Top-PTName.Height;
  with ButtonToMainScreen do Left:=Self.Width-Width-5;
  with ButtonToDataBase do Left:=Self.Width-Width-10-ButtonToMainScreen.Width;
end;

procedure TVirtCAPaspForm.PVHHTPMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
  begin
    if Caddy.UserLevel = 0 then
    begin
      Caddy.ShowMessage(kmWarning,'Пользователь не зарегистрирован!');
      Exit;
    end;
    if Sender = PVHHTP then Caddy.SmartAskByEntity(E,[asHH]);
    if Sender = PVHiTP then Caddy.SmartAskByEntity(E,[asHi]);
    if Sender = PVLoTP then Caddy.SmartAskByEntity(E,[asLo]);
    if Sender = PVLLTP then Caddy.SmartAskByEntity(E,[asLL]);
    if Sender = PV then Caddy.SmartAskByEntity(E,
                                           E.AlarmStatus+E.LostAlarmStatus);
  end;
end;

procedure TVirtCAPaspForm.PVHHTPMouseEnter(Sender: TObject);
begin
  with Sender as TLabel do
  begin
    TShape(Tag).Pen.Color:=clMoneyGreen;
    TShape(Tag).BringToFront;
    BringToFront;
  end;
end;

procedure TVirtCAPaspForm.PVHHTPMouseLeave(Sender: TObject);
begin
  with Sender as TLabel do
    TShape(Tag).Pen.Color:=clBlack;
end;

procedure TVirtCAPaspForm.ButtonToDataBaseClick(Sender: TObject);
begin
  E.ShowEditor(Monitor.MonitorNum);
end;

procedure TVirtCAPaspForm.PVSourceDblClick(Sender: TObject);
begin
  E.ShowParentPassport(Monitor.MonitorNum);
end;

procedure TVirtCAPaspForm.ButtonToMainScreenClick(Sender: TObject);
begin
  E.ShowScheme(Monitor.MonitorNum);
end;

procedure TVirtCAPaspForm.EnterButtonClick(Sender: TObject);
var sFormat: string; Value: Single;
begin
  sFormat:='%.'+IntToStr(Ord(E.PVFormat))+'f';
  Value:=E.PV;
  if InputFloatDlg('Введите значение позиции "'+E.PtName+'.PV"',
                   sFormat,Value) then
  begin
    if (Value <= E.PVEUHi) and (Value >= E.PVEULo) then
    begin
      if Caddy.NetRole = nrClient then
      begin
        if E.CalcScale then
          E.CommandData:=(Value-E.PVEULo)*100.0/(E.PVEUHi-E.PVEULo)
        else
          E.CommandData:=Value;
        E.CommandData:=Value;
        E.HasCommand:=True;
      end
      else
      begin
        if E.CalcScale then
          E.Raw:=(Value-E.PVEULo)*100.0/(E.PVEUHi-E.PVEULo)
        else
          E.Raw:=Value;
      end;
    end
    else
      RemXForm.ShowError('Ввод значения за границами шкалы недопустим!');
  end;
end;

end.
