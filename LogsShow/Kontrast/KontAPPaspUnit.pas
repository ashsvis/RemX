unit KontAPPaspUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, EntityUnit, KontrastUnit, RxGraph;

type
  TKontAPPaspForm = class(TForm,IEntity)
    Panel1: TPanel;
    PTNameDesc: TLabel;
    PTDesc: TLabel;
    ButtonToDataBase: TButton;
    ButtonToMainScreen: TButton;
    PVPanel: TPanel;
    PTName: TLabel;
    EUDesc: TLabel;
    LabelOP: TLabel;
    OP: TLabel;
    ConfigPanel: TPanel;
    Label55: TLabel;
    Label56: TLabel;
    PTActive: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    PVRAW: TLabel;
    Label63: TLabel;
    LinkSpeed: TLabel;
    LabelFormatOP: TLabel;
    OPFormat: TLabel;
    LabelSourceOP: TLabel;
    OPSource: TLabel;
    Label9: TLabel;
    LastTime: TLabel;
    Panel6: TPanel;
    Panel3: TPanel;
    Entity: TLabel;
    Label61: TLabel;
    Label1: TLabel;
    LabelParameter: TLabel;
    StatusPanel: TPanel;
    Label11: TLabel;
    Label6: TLabel;
    Label70: TLabel;
    OPEUHi: TLabel;
    Label72: TLabel;
    OPEULo: TLabel;
    StatusListBox: TLabel;
    Label2: TLabel;
    Channel: TLabel;
    Label5: TLabel;
    Node: TLabel;
    Label8: TLabel;
    Algoblock: TLabel;
    Label12: TLabel;
    Input: TLabel;
    Label3: TLabel;
    DataFormat: TLabel;
    EnterButton: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ButtonToDataBaseClick(Sender: TObject);
    procedure OPSourceDblClick(Sender: TObject);
    procedure EnterButtonClick(Sender: TObject);
    procedure ButtonToMainScreenClick(Sender: TObject);
  private
    E: TKontAnaParam;
    RxGraph: TRxGraph;
    procedure ConnectEntity(Entity: TEntity); stdcall;
    procedure ConnectImageList(ImageList: TImageList); stdcall;
    procedure UpdateRealTime; stdcall;
  public
  end;

var
  KontAPPaspForm: TKontAPPaspForm;

implementation

uses StrUtils, Math, GetPtNameUnit, RemXUnit;

{$R *.dfm}

{ TVirtAPPaspForm }

procedure TKontAPPaspForm.ConnectEntity(Entity: TEntity);
var sFormat: string;
begin
  E:=Entity as TKontAnaParam;
  PTNameDesc.Caption:=E.PtName;
  Self.Entity.Caption:=E.PtName;
  PTName.Caption:=E.PtName;
  LabelParameter.Caption:=E.EntityType;
  PTDesc.Caption:=E.PtDesc;
  PTActive.Caption:=IfThen(E.Actived,'Да','Нет');
  LinkSpeed.Caption:=Format('%d сек',[E.FetchTime]);
  if not E.Actived or (asNoLink in E.AlarmStatus) then
    DataFormat.Caption:='------'
  else
    DataFormat.Caption:=Format('[%d] %s',[E.DataFormat,AFablFormat[E.DataFormat]]);
  if E.RealTime > 0 then
    LastTime.Caption:=Format('%.3f',[E.RealTime/1000])+' сек'
  else
    LastTime.Caption:='Нет опроса';
  if E.SourceEntity=nil then
    OPSource.Caption:='Авто'
  else
    OPSource.Caption:=E.SourceEntity.PtName;
  EUDesc.Caption:=E.EUDesc;
  OPFormat.Caption:=Format('D%d',[Ord(E.OPFormat)]);
  sFormat:='%.'+Format('%d',[Ord(E.OPFormat)])+'f';
  OPEUHi.Caption:=Format(sFormat,[E.OPEUHi]);
  OPEULo.Caption:=Format(sFormat,[E.OPEULo]);
  PVRAW.Caption:=FloatToStr(E.Raw);
  if asNoLink in E.AlarmStatus then
    OP.Caption:='------'
  else
    OP.Caption:=Format(sFormat,[E.OP]);
//-------------------------------------
  RxGraph.GraphType:=gtOP; // OP only
  RxGraph.Visible:=True;
//-------------------------------------
  Channel.Caption:=Format('%d',[E.Channel]);
  Node.Caption:=Format('%d',[E.Node]);
  Algoblock.Caption:=Format('%d',[E.Block]);
  Input.Caption:=Format('%d',[E.Place]);
  UpdateRealTime;
end;

procedure TKontAPPaspForm.ConnectImageList(ImageList: TImageList);
begin
// Stub
end;

procedure TKontAPPaspForm.UpdateRealTime;
var sFormat: string;
begin
  ButtonToDataBase.Visible:=Caddy.UserLevel > 4;
  EnterButton.Visible:=(Caddy.UserLevel > 1);
  if E.RealTime > 0 then
    LastTime.Caption:=Format('%.3f',[E.RealTime/1000])+' сек'
  else
    LastTime.Caption:='Нет опроса';
  try
    PVRAW.Caption:=Format('%g',[RoundTo(E.Raw,-4)]);
  except
    PVRAW.Caption:='??????';
  end;
  sFormat:='%.'+Format('%d',[Ord(E.OPFormat)])+'f';
  if asNoLink in E.AlarmStatus then
    OP.Caption:='------'
  else
    OP.Caption:=Format(sFormat,[E.OP]);
  if not E.Actived or (asNoLink in E.AlarmStatus) then
    DataFormat.Caption:='------'
  else
    DataFormat.Caption:=Format('[%d] %s',[E.DataFormat,AFablFormat[E.DataFormat]]);
//------------------------------------------------
  if E.OP < E.OPEULo then
    RxGraph.OPRAW:=0
  else
  if E.OP > E.OPEUHi then
    RxGraph.OPRAW:=100
  else
  begin
    if Abs(E.OPEUHi-E.OPEULo) > 0.01 then
      RxGraph.OPRAW:=Trunc((E.OP-E.OPEULo)*100/(E.OPEUHi-E.OPEULo));
  end;
  StatusListBox.Caption:=E.ErrorMess;
end;

procedure TKontAPPaspForm.FormCreate(Sender: TObject);
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
  RxGraph.OPRAW:=0;
end;

procedure TKontAPPaspForm.FormResize(Sender: TObject);
begin
  RxGraph.Left:=10;
  RxGraph.Width:=PVPanel.Width-30;
  RxGraph.Top:=0;
  RxGraph.Height:=PTName.Top-PTName.Height;
  with ButtonToMainScreen do Left:=Self.Width-Width-5;
  with ButtonToDataBase do Left:=Self.Width-Width-10-ButtonToMainScreen.Width;
end;

procedure TKontAPPaspForm.ButtonToDataBaseClick(Sender: TObject);
begin
  E.ShowEditor(Monitor.MonitorNum);
end;

procedure TKontAPPaspForm.OPSourceDblClick(Sender: TObject);
begin
  E.ShowParentPassport(Monitor.MonitorNum);
end;

procedure TKontAPPaspForm.EnterButtonClick(Sender: TObject);
var sFormat: string; Value: Single;
begin
  sFormat:='%.'+IntToStr(Ord(E.OPFormat))+'f';
  Value:=E.OP;
  if InputFloatDlg('Введите значение позиции "'+E.PtName+'.OP"',
                   sFormat,Value) then
  begin
    if (Value <= E.OPEUHi) and (Value >= E.OPEULo) then
      E.SendOP(Value)
    else
      RemXForm.ShowError('Ввод значения за границами шкалы недопустим!');
  end;
end;

procedure TKontAPPaspForm.ButtonToMainScreenClick(Sender: TObject);
begin
  E.ShowScheme(Monitor.MonitorNum);
end;

end.
