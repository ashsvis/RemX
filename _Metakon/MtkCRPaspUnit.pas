unit MtkCRPaspUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, EntityUnit, MetakonUnit, RxGraph,
  Menus;

type
  TMtkCRPaspForm = class(TForm,IEntity)
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
    Label2: TLabel;
    Channel: TLabel;
    Label5: TLabel;
    Node: TLabel;
    Label3: TLabel;
    PVDHTP: TLabel;
    Label10: TLabel;
    PVDLTP: TLabel;
    Label7: TLabel;
    Label12: TLabel;
    SPEUHi: TLabel;
    SPEULo: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    OPEUHi: TLabel;
    OPEULo: TLabel;
    Label14: TLabel;
    SP: TLabel;
    Label18: TLabel;
    OP: TLabel;
    Label17: TLabel;
    Label19: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    K_SOURCE: TLabel;
    T1_SOURCE: TLabel;
    Label27: TLabel;
    T2_SOURCE: TLabel;
    K_VAL: TLabel;
    T1_VAL: TLabel;
    T2_VAL: TLabel;
    Label33: TLabel;
    CheckSP: TLabel;
    Label35: TLabel;
    CheckOP: TLabel;
    EnterSPButton: TButton;
    EnterOPButton: TButton;
    Label8: TLabel;
    T3_SOURCE: TLabel;
    T3_VAL: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PVHHTPMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PVHHTPMouseEnter(Sender: TObject);
    procedure PVHHTPMouseLeave(Sender: TObject);
    procedure ButtonToDataBaseClick(Sender: TObject);
    procedure K_SOURCEDblClick(Sender: TObject);
    procedure PVSourceDblClick(Sender: TObject);
    procedure EnterSPButtonClick(Sender: TObject);
    procedure EnterOPButtonClick(Sender: TObject);
    procedure K_VALDblClick(Sender: TObject);
    procedure EnterModeClick(Sender: TObject);
    procedure ButtonToMainScreenClick(Sender: TObject);
  private
    Blink: boolean;
    E: TMtkCntReg;
    RxGraph: TRxGraph;
    FPV,FSP,FOP,FPVHHTP,FPVHiTP,FPVLoTP,FPVLLTP,FPVDHTP,FPVDLTP: TShape;
    FK_SOURCE,FT1_SOURCE,FT2_SOURCE,FT3_SOURCE,
    FK_VAL,FT1_VAL,FT2_VAL,FT3_VAL: TShape;
    procedure ConnectEntity(Entity: TEntity); stdcall;
    procedure ConnectImageList(ImageList: TImageList); stdcall;
    procedure UpdateRealTime; stdcall;
  public
  end;

var
  MtkCRPaspForm: TMtkCRPaspForm;

implementation

uses StrUtils, Math, GetPtNameUnit, GetRegModeValUnit, RemXUnit,
  SetKonturOPUnit;

{$R *.dfm}

{ TVirtNNPaspForm }

procedure TMtkCRPaspForm.ConnectEntity(Entity: TEntity);
var sFormat: string; k: Double;
begin
  E:=Entity as TMtkCntReg;
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
  if (asNoLink in E.AlarmStatus)
    or
     E.Logged and
     ((asShortBadPV in E.AlarmStatus) or (asOpenBadPV in E.AlarmStatus)) then
    PV.Caption:='------'
  else
    PV.Caption:=Format(sFormat,[E.PV]);
//-------------------------------------
  SPEUHi.Caption:=Format(sFormat,[E.SPEUHi]);
  SPEULo.Caption:=Format(sFormat,[E.SPEULo]);
  OPEUHi.Caption:=Format(sFormat,[100.0]);
  OPEULo.Caption:=Format(sFormat,[0.0]);
  PVDHTP.Caption:=Format(sFormat,[E.PVDHTP]);
  PVDLTP.Caption:=Format(sFormat,[E.PVDLTP]);
  if asNoLink in E.AlarmStatus then
    SP.Caption:='------'
  else
    SP.Caption:=Format(sFormat,[E.SP]);
  if asNoLink in E.AlarmStatus then
    OP.Caption:='------'
  else
    OP.Caption:=Format('%.0f',[E.OP]);
  CheckSP.Caption:=ACtoStr[E.CheckSP];
  CheckOP.Caption:=ACtoStr[E.CheckOP];
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
  RxGraph.GraphType:=gtCR; // Full regulator
  RxGraph.Visible:=True;
//-------------------------------------
  Channel.Caption:=Format('%d',[E.Channel]);
  Node.Caption:=Format('%d',[E.Node]);
//-------------------------------------
  if Assigned(E.K) then
  begin
    K_SOURCE.Caption:=E.K.PtName;
    K_SOURCE.Hint:=E.K.PtDesc;
    sFormat:='%.'+IntToStr(Ord(E.K.OPFormat))+'f';
    K_VAL.Caption:=Format(sFormat,[E.K.OP]);
  end
  else
  begin
    K_SOURCE.Caption:='------';
    K_SOURCE.Hint:='';
    K_VAL.Caption:='------';
  end;
  if Assigned(E.T1) then
  begin
    T1_SOURCE.Caption:=E.T1.PtName;
    T1_SOURCE.Hint:=E.T1.PtDesc;
    sFormat:='%.'+IntToStr(Ord(E.T1.OPFormat))+'f';
    T1_VAL.Caption:=Format(sFormat,[E.T1.OP]);
  end
  else
  begin
    T1_SOURCE.Caption:='------';
    T1_SOURCE.Hint:='';
    T1_VAL.Caption:='------';
  end;
  if Assigned(E.T2) then
  begin
    T2_SOURCE.Caption:=E.T2.PtName;
    T2_SOURCE.Hint:=E.T2.PtDesc;
    sFormat:='%.'+IntToStr(Ord(E.T2.OPFormat))+'f';
    T2_VAL.Caption:=Format(sFormat,[E.T2.OP]);
  end
  else
  begin
    T2_SOURCE.Caption:='------';
    T2_SOURCE.Hint:='';
    T2_VAL.Caption:='------';
  end;
  if Assigned(E.T3) then
  begin
    T3_SOURCE.Caption:=E.T3.PtName;
    T3_SOURCE.Hint:=E.T3.PtDesc;
    sFormat:='%.'+IntToStr(Ord(E.T3.OPFormat))+'f';
    T3_VAL.Caption:=Format(sFormat,[E.T3.OP]);
  end
  else
  begin
    T3_SOURCE.Caption:='------';
    T3_SOURCE.Hint:='';
    T3_VAL.Caption:='------';
  end;
  UpdateRealTime;
end;

procedure TMtkCRPaspForm.ConnectImageList(ImageList: TImageList);
begin
// Stub
end;

procedure TMtkCRPaspForm.UpdateRealTime;
var sFormat: string; k: TAlarmState;
begin
  ButtonToDataBase.Visible:=Caddy.UserLevel > 4;
  if E.RealTime > 0 then
    LastTime.Caption:=Format('%.3f',[E.RealTime/1000])+' ���'
  else
    LastTime.Caption:='��� ������';
  try
    PVRAW.Caption:=Format('%g',[RoundTo(E.PVRaw,-4)]);
  except
    PVRAW.Caption:='??????';
  end;
  sFormat:='%.'+Format('%d',[Ord(E.PVFormat)])+'f';
  if (asNoLink in E.AlarmStatus)
    or
     E.Logged and
     ((asShortBadPV in E.AlarmStatus) or (asOpenBadPV in E.AlarmStatus)) then
    PV.Caption:='------'
  else
    PV.Caption:=Format(sFormat,[E.PV]);
  if asNoLink in E.AlarmStatus then
    SP.Caption:='------'
  else
    SP.Caption:=Format(sFormat,[E.SP]);
  if asNoLink in E.AlarmStatus then
    OP.Caption:='------'
  else
    OP.Caption:=Format('%.0f',[E.OP]);
//------------------------------------------------
  if Assigned(E.K) and not (asNoLink in E.K.AlarmStatus) then
  begin
    sFormat:='%.'+IntToStr(Ord(E.K.OPFormat))+'f';
    K_VAL.Caption:=Format(sFormat,[E.K.OP]);
  end
  else
    K_VAL.Caption:='------';
  if Assigned(E.T1) and not (asNoLink in E.T1.AlarmStatus) then
  begin
    sFormat:='%.'+IntToStr(Ord(E.T1.OPFormat))+'f';
    T1_VAL.Caption:=Format(sFormat,[E.T1.OP]);
  end
  else
    T1_VAL.Caption:='------';
  if Assigned(E.T2) and not (asNoLink in E.T2.AlarmStatus) then
  begin
    sFormat:='%.'+IntToStr(Ord(E.T2.OPFormat))+'f';
    T2_VAL.Caption:=Format(sFormat,[E.T2.OP]);
  end
  else
    T2_VAL.Caption:='------';
  if Assigned(E.T3) and not (asNoLink in E.T3.AlarmStatus) then
  begin
    sFormat:='%.'+IntToStr(Ord(E.T3.OPFormat))+'f';
    T3_VAL.Caption:=Format(sFormat,[E.T3.OP]);
  end
  else
    T3_VAL.Caption:='------';
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
  if E.SP < E.SPEULo then
    RxGraph.SPRAW:=0
  else
  if E.SP > E.SPEUHi then
    RxGraph.SPRAW:=100
  else
  begin
    if Abs(E.SPEUHi-E.SPEULo) > 0.01 then
      RxGraph.SPRAW:=Trunc((E.SP-E.SPEULo)*100/(E.SPEUHi-E.SPEULo));
  end;
//------------------------------------------------
  if E.OP < 0.0 then
    RxGraph.OPRAW:=0
  else
  if E.OP > 100.0 then
    RxGraph.OPRAW:=100
  else
  begin
    if Abs(100.0-0.0) > 0.01 then
      RxGraph.OPRAW:=Trunc((E.OP-0.0)*100/(100.0-0.0));
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
  if (asDH in E.AlarmStatus) or (asDH in E.LostAlarmStatus) then
  begin
    FPVDHTP.Brush.Color:=ABrushColor[asDH,(asDH in E.AlarmStatus),
                                          (asDH in E.ConfirmStatus),Blink];
    PVDHTP.Font.Color:=AFontColor[asDH,(asDH in E.AlarmStatus),
                                       (asDH in E.ConfirmStatus),Blink];
  end
  else
  begin
    FPVDHTP.Brush.Color:=clBlack;
    PVDHTP.Font.Color:=clAqua;
  end;
  if (asDL in E.AlarmStatus) or (asDL in E.LostAlarmStatus) then
  begin
    FPVDLTP.Brush.Color:=ABrushColor[asDL,(asDL in E.AlarmStatus),
                                          (asDL in E.ConfirmStatus),Blink];
    PVDLTP.Font.Color:=AFontColor[asDL,(asDL in E.AlarmStatus),
                                       (asDL in E.ConfirmStatus),Blink];
  end
  else
  begin
    FPVDLTP.Brush.Color:=clBlack;
    PVDLTP.Font.Color:=clAqua;
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
//------------------------------------------
  Blink:=not Blink;
end;

procedure TMtkCRPaspForm.FormCreate(Sender: TObject);
var ScreenSizeIndex,i: integer; L: TLabel; P: TPanel; S: TShape; B: TButton;
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
//---------------------------------------
  FPVDHTP:=TShape.Create(Self);
  FPVDHTP.Parent:=AlarmsPanel;
  with PVDHTP do
  begin
    FPVDHTP.SetBounds(Left-3,Top-1,Width+6,Height+2);
    FPVDHTP.Brush.Color:=clBlack;
    FPVDHTP.SendToBack;
    Tag:=Integer(FPVDHTP);
  end;
  FPVDLTP:=TShape.Create(Self);
  FPVDLTP.Parent:=AlarmsPanel;
  with PVDLTP do
  begin
    FPVDLTP.SetBounds(Left-3,Top-1,Width+6,Height+2);
    FPVDLTP.Brush.Color:=clBlack;
    FPVDLTP.SendToBack;
    Tag:=Integer(FPVDLTP);
  end;
  FSP:=TShape.Create(Self);
  FSP.Parent:=PVPanel;
  with SP do
  begin
    FSP.SetBounds(Left-3,Top-1,Width+6,Height+2);
    FSP.Brush.Color:=clBlack;
    FSP.SendToBack;
    Tag:=Integer(FSP);
  end;
  FOP:=TShape.Create(Self);
  FOP.Parent:=PVPanel;
  with OP do
  begin
    FOP.SetBounds(Left-3,Top-1,Width+6,Height+2);
    FOP.Brush.Color:=clBlack;
    FOP.SendToBack;
    Tag:=Integer(FOP);
  end;
//----------------------------
  FK_SOURCE:=TShape.Create(Self);
  FK_SOURCE.Parent:=ConfigPanel;
  with K_SOURCE do
  begin
    FK_SOURCE.SetBounds(Left-3,Top-1,Width+6,Height+2);
    FK_SOURCE.Brush.Color:=clBlack;
    FK_SOURCE.SendToBack;
    Tag:=Integer(FK_SOURCE);
  end;
  FT1_SOURCE:=TShape.Create(Self);
  FT1_SOURCE.Parent:=ConfigPanel;
  with T1_SOURCE do
  begin
    FT1_SOURCE.SetBounds(Left-3,Top-1,Width+6,Height+2);
    FT1_SOURCE.Brush.Color:=clBlack;
    FT1_SOURCE.SendToBack;
    Tag:=Integer(FT1_SOURCE);
  end;
  FT2_SOURCE:=TShape.Create(Self);
  FT2_SOURCE.Parent:=ConfigPanel;
  with T2_SOURCE do
  begin
    FT2_SOURCE.SetBounds(Left-3,Top-1,Width+6,Height+2);
    FT2_SOURCE.Brush.Color:=clBlack;
    FT2_SOURCE.SendToBack;
    Tag:=Integer(FT2_SOURCE);
  end;
  FT3_SOURCE:=TShape.Create(Self);
  FT3_SOURCE.Parent:=ConfigPanel;
  with T3_SOURCE do
  begin
    FT3_SOURCE.SetBounds(Left-3,Top-1,Width+6,Height+2);
    FT3_SOURCE.Brush.Color:=clBlack;
    FT3_SOURCE.SendToBack;
    Tag:=Integer(FT3_SOURCE);
  end;
  FK_VAL:=TShape.Create(Self);
  FK_VAL.Parent:=ConfigPanel;
  with K_VAL do
  begin
    FK_VAL.SetBounds(Left-3,Top-1,Width+6,Height+2);
    FK_VAL.Brush.Color:=clBlack;
    FK_VAL.SendToBack;
    Tag:=Integer(FK_VAL);
  end;
  FT1_VAL:=TShape.Create(Self);
  FT1_VAL.Parent:=ConfigPanel;
  with T1_VAL do
  begin
    FT1_VAL.SetBounds(Left-3,Top-1,Width+6,Height+2);
    FT1_VAL.Brush.Color:=clBlack;
    FT1_VAL.SendToBack;
    Tag:=Integer(FT1_VAL);
  end;
  FT2_VAL:=TShape.Create(Self);
  FT2_VAL.Parent:=ConfigPanel;
  with T2_VAL do
  begin
    FT2_VAL.SetBounds(Left-3,Top-1,Width+6,Height+2);
    FT2_VAL.Brush.Color:=clBlack;
    FT2_VAL.SendToBack;
    Tag:=Integer(FT2_VAL);
  end;
  FT3_VAL:=TShape.Create(Self);
  FT3_VAL.Parent:=ConfigPanel;
  with T3_VAL do
  begin
    FT3_VAL.SetBounds(Left-3,Top-1,Width+6,Height+2);
    FT3_VAL.Brush.Color:=clBlack;
    FT3_VAL.SendToBack;
    Tag:=Integer(FT3_VAL);
  end;
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
    0: for i:=0 to Self.ComponentCount-1 do
       begin
         if Components[i] is TButton then
         begin
           B:=Components[i] as TButton;
           if B.Parent = PVPanel then
           begin
             B.Left:=Round(B.Left/1.32);
             B.Top:=Round(B.Top/1.32);
             B.Width:=Round(B.Width/1.32);
             B.Height:=Round(B.Height/1.32);
             B.Font.Size:=10;
             B.Font.Name:='Tahoma';
           end;
         end;
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
           L.Left:=Round(L.Left/1.32);
           L.Top:=Round(L.Top/1.32);
           L.Width:=Round(L.Width/1.32);
           L.Height:=Round(L.Height/1.32);
           L.Font.Size:=10;
           L.Font.Name:='Tahoma';
           L.Transparent:=True;
         end;
         if Components[i] is TShape then
         begin
           S:=Components[i] as TShape;
           S.Left:=Round(S.Left/1.32);
           S.Top:=Round(S.Top/1.32);
           S.Width:=Round(S.Width/1.32);
           S.Height:=Round(S.Height/1.32);
         end;
       end;
    2,3: for i:=0 to Self.ComponentCount-1 do
       begin
         if Components[i] is TButton then
         begin
           B:=Components[i] as TButton;
           if B.Parent = PVPanel then
           begin
             B.Left:=Round(B.Left/0.8);
             B.Top:=Round(B.Top/0.8);
             B.Width:=Round(B.Width/0.8);
             B.Height:=Round(B.Height/0.8);
             B.Font.Size:=16;
             B.Font.Name:='Tahoma';
           end;
         end;
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

procedure TMtkCRPaspForm.FormResize(Sender: TObject);
begin
  RxGraph.Left:=10;
  RxGraph.Width:=PVPanel.Width-30;
  RxGraph.Top:=0;
  RxGraph.Height:=PTName.Top-PTName.Height;
  with ButtonToMainScreen do Left:=Self.Width-Width-5;
  with ButtonToDataBase do Left:=Self.Width-Width-10-ButtonToMainScreen.Width;
end;

procedure TMtkCRPaspForm.PVHHTPMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
  begin
    if Caddy.UserLevel = 0 then
    begin
      Caddy.ShowMessage(kmWarning,'������������ �� ���������������!');
      Exit;
    end;
    if Sender = PVHHTP then Caddy.SmartAskByEntity(E,[asHH]);
    if Sender = PVHiTP then Caddy.SmartAskByEntity(E,[asHi]);
    if Sender = PVLoTP then Caddy.SmartAskByEntity(E,[asLo]);
    if Sender = PVLLTP then Caddy.SmartAskByEntity(E,[asLL]);
    if Sender = PVDHTP then Caddy.SmartAskByEntity(E,[asDH]);
    if Sender = PVDLTP then Caddy.SmartAskByEntity(E,[asDL]);
    if Sender = PV then Caddy.SmartAskByEntity(E,E.AlarmStatus+E.LostAlarmStatus);
  end;
end;

procedure TMtkCRPaspForm.PVHHTPMouseEnter(Sender: TObject);
begin
  with Sender as TLabel do
  begin
    TShape(Tag).Pen.Color:=clMoneyGreen;
    TShape(Tag).BringToFront;
    BringToFront;
  end;
end;

procedure TMtkCRPaspForm.PVHHTPMouseLeave(Sender: TObject);
begin
  with Sender as TLabel do
    TShape(Tag).Pen.Color:=clBlack;
end;

procedure TMtkCRPaspForm.ButtonToDataBaseClick(Sender: TObject);
begin
  E.ShowEditor(Monitor.MonitorNum);
end;

procedure TMtkCRPaspForm.K_SOURCEDblClick(Sender: TObject);
begin
  if (Sender = K_SOURCE) and Assigned(E.K) then E.K.ShowPassport(Monitor.MonitorNum);
  if (Sender = T1_SOURCE) and Assigned(E.T1) then E.T1.ShowPassport(Monitor.MonitorNum);
  if (Sender = T2_SOURCE) and Assigned(E.T2) then E.T2.ShowPassport(Monitor.MonitorNum);
  if (Sender = T3_SOURCE) and Assigned(E.T3) then E.T3.ShowPassport(Monitor.MonitorNum);
end;

procedure TMtkCRPaspForm.PVSourceDblClick(Sender: TObject);
begin
  E.ShowParentPassport(Monitor.MonitorNum);
end;

procedure TMtkCRPaspForm.EnterSPButtonClick(Sender: TObject);
var sFormat: string; Value,rDelta: Single;
begin
  sFormat:='%.'+IntToStr(Ord(E.PVFormat))+'f';
  Value:=E.SP;
  if InputFloatDlg('������� �������� ������� "'+E.PtName+'.SP"',
                   sFormat,Value) then
  begin
    if (Value <= E.SPEUHi) and (Value >= E.SPEULo) then
    begin
      if Value > E.SP then
        rDelta:=(Value-E.SP)/(E.SPEUHi-E.SPEULo)
      else
        rDelta:=(E.SP-Value)/(E.SPEUHi-E.SPEULo);
      if (E.CheckSP = ccNone) or
         (E.CheckSP <> ccNone) and
         ((rDelta <= ACtoSingle[E.CheckSP]) or
          (rDelta > ACtoSingle[E.CheckSP]) and
          (RemXForm.ShowQuestion('��������������� ������� ����� '+
                  ACtoStr[E.CheckSP]+'!'#13'��������� �������?') = mrOk)) then
        E.SendSP(Value);
    end
    else
      RemXForm.ShowError('���� �������� �� ��������� ����� ������� ����������!');
  end
end;

procedure TMtkCRPaspForm.EnterOPButtonClick(Sender: TObject);
var sFormat: string; Value,rDelta: Single;
begin
  if E.RegType = rtImpulse then
  begin
    SetKonturOPDlg:=TSetKonturOPDlg.Create(Application);
    try
      with SetKonturOPDlg do
      begin
        CntReg:=E;             
        ShowModal;
      end;
    finally
      SetKonturOPDlg.Free;
    end;
  end
  else
  begin
    sFormat:='%.'+IntToStr(Ord(E.PVFormat))+'f';
    Value:=E.OP;
    if InputFloatDlg('������� �������� ������� "'+E.PtName+'.OP"',
                     sFormat,Value) then
    begin
      if (Value <= 100.0) and (Value >= 0.0) then
      begin
        if Value > E.OP then
          rDelta:=(Value-E.OP)/100.0
        else
          rDelta:=(E.OP-Value)/100.0;
        if (E.CheckOP = ccNone) or
           (E.CheckOP <> ccNone) and
           ((rDelta <= ACtoSingle[E.CheckOP]) or
            (rDelta > ACtoSingle[E.CheckOP]) and
            (RemXForm.ShowQuestion('��������������� ������ ����� '+
                    ACtoStr[E.CheckOP]+'!'#13'��������� �������?') = mrOk)) then
        begin
          if Caddy.NetRole = nrClient then
          begin
            E.CommandMode:=29;
            E.CommandData:=Value;
            E.HasCommand:=True;
          end
          else
            E.SendOP(Value);
        end;
      end
      else
        RemXForm.ShowError('���� �������� �� ��������� ����� ������ ����������!');
    end;
  end;
end;

procedure TMtkCRPaspForm.K_VALDblClick(Sender: TObject);
var sFormat: string; Value: Single;
begin
  if Caddy.UserLevel = 0 then
  begin
    Caddy.ShowMessage(kmWarning,'������������ �� ���������������!');
    Exit;
  end;
  if (Sender = K_VAL) and Assigned(E.K) then
  begin
     sFormat:='%.'+IntToStr(Ord(E.K.OPFormat))+'f';
     Value:=E.K.OP;
     if InputFloatDlg('������� �������� ��',sFormat,Value) then
     begin
       if (Value <= E.K.OPEUHi) and (Value >= E.K.OPEULo) then
       begin
         if Caddy.NetRole = nrClient then
         begin
           E.K.CommandData:=Value;
           E.K.HasCommand:=True;
         end
         else
           E.K.SendOP(Value);
       end
       else
         RemXForm.ShowError('���� �������� �� ��������� ����� ����������!');
     end;
  end;
  if (Sender = T1_VAL) and Assigned(E.T1) then
  begin
     sFormat:='%.'+IntToStr(Ord(E.T1.OPFormat))+'f';
     Value:=E.T1.OP;
     if InputFloatDlg('������� �������� ��',sFormat,Value) then
     begin
       if (Value <= E.T1.OPEUHi) and (Value >= E.T1.OPEULo) then
       begin
         if Caddy.NetRole = nrClient then
         begin
           E.T1.CommandData:=Value;
           E.T1.HasCommand:=True;
         end
         else
           E.T1.SendOP(Value);
       end
       else
         RemXForm.ShowError('���� �������� �� ��������� ����� ����������!');
     end;
  end;
  if (Sender = T2_VAL) and Assigned(E.T2) then
  begin
     sFormat:='%.'+IntToStr(Ord(E.T2.OPFormat))+'f';
     Value:=E.T2.OP;
     if InputFloatDlg('������� �������� ��',sFormat,Value) then
     begin
       if (Value <= E.T2.OPEUHi) and (Value >= E.T2.OPEULo) then
       begin
         if Caddy.NetRole = nrClient then
         begin
           E.T2.CommandData:=Value;
           E.T2.HasCommand:=True;
         end
         else
           E.T2.SendOP(Value);
       end
       else
         RemXForm.ShowError('���� �������� �� ��������� ����� ����������!');
     end;
  end;
  if (Sender = T3_VAL) and Assigned(E.T3) then
  begin
     sFormat:='%.'+IntToStr(Ord(E.T3.OPFormat))+'f';
     Value:=E.T3.OP;
     if InputFloatDlg('������� �������� K�',sFormat,Value) then
     begin
       if (Value <= E.T3.OPEUHi) and (Value >= E.T3.OPEULo) then
       begin
         if Caddy.NetRole = nrClient then
         begin
           E.T3.CommandData:=Value;
           E.T3.HasCommand:=True;
         end
         else
           E.T3.SendOP(Value);
       end
       else
         RemXForm.ShowError('���� �������� �� ��������� ����� ����������!');
     end;
  end;
end;

procedure TMtkCRPaspForm.EnterModeClick(Sender: TObject);
var Value: Word;
begin
  Value:=E.Mode;
  if InputRegModeDlg(Value) then
  begin
    if Caddy.NetRole = nrClient then
    begin
      E.CommandMode:=Value;
      E.CommandData:=0.0;
      E.HasCommand:=True;
    end
    else
      E.SendCommand(Value);
  end;
end;

procedure TMtkCRPaspForm.ButtonToMainScreenClick(Sender: TObject);
begin
  E.ShowScheme(Monitor.MonitorNum);
end;

end.
