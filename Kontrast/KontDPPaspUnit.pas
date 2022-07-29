unit KontDPPaspUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, Buttons, EntityUnit, KontrastUnit;

type
  TKontDPPaspForm = class(TForm,IEntity)
    Panel1: TPanel;
    PTNameDesc: TLabel;
    PTDesc: TLabel;
    ButtonToDataBase: TButton;
    ButtonToMainScreen: TButton;
    PVPanel: TPanel;
    PTName: TLabel;
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
    LabelFormatPV: TLabel;
    Invert: TLabel;
    LabelSourcePV: TLabel;
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
    StatusListBox: TLabel;
    ShapeON: TShape;
    LabelON: TLabel;
    ShapeOFF: TShape;
    LabelOFF: TLabel;
    Label4: TLabel;
    Channel: TLabel;
    Label6: TLabel;
    Node: TLabel;
    Label8: TLabel;
    Algoblock: TLabel;
    Label12: TLabel;
    Input: TLabel;
    Label2: TLabel;
    WaitTime: TLabel;
    Label3: TLabel;
    DataFormat: TLabel;
    EnterButton: TButton;
    procedure FormResize(Sender: TObject);
    procedure ButtonToDataBaseClick(Sender: TObject);
    procedure OPSourceDblClick(Sender: TObject);
    procedure EnterButtonClick(Sender: TObject);
    procedure ButtonToMainScreenClick(Sender: TObject);
  private
    E: TKontDigParam;
    procedure ConnectEntity(Entity: TEntity); stdcall;
    procedure ConnectImageList(ImageList: TImageList); stdcall;
    procedure UpdateRealTime; stdcall;
  public
  end;

var
  KontDPPaspForm: TKontDPPaspForm;

implementation

uses StrUtils, Math, GetDigValUnit;

{$R *.dfm}

{ TVirtNNPaspForm }

procedure TKontDPPaspForm.ConnectEntity(Entity: TEntity);
begin
  E:=Entity as TKontDigParam;
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
  PVRAW.Caption:=IfThen((E.Raw > 0),'Лог."1"','Лог."0"');
  if asNoLink in E.AlarmStatus then
    OP.Caption:='------'
  else
    OP.Caption:=IfThen(E.OP,'ВКЛЮЧЕН','ВЫКЛЮЧЕН');
  Invert.Caption:=IfThen(E.Invert,'Да','Нет');
  EnterButton.Visible := (Caddy.UserLevel > 1);
//-------------------------------------
  Channel.Caption:=Format('%d',[E.Channel]);
  Node.Caption:=Format('%d',[E.Node]);
  Algoblock.Caption:=Format('%d',[E.Block]);
  Input.Caption:=Format('%d',[E.Place]);
  WaitTime.Caption:=Format('%d мсек',[E.PulseWait]);
  UpdateRealTime;
end;

procedure TKontDPPaspForm.ConnectImageList(ImageList: TImageList);
begin
// Stub
end;

procedure TKontDPPaspForm.UpdateRealTime;
begin
  EnterButton.Visible := (Caddy.UserLevel > 1);
  ButtonToDataBase.Visible:=Caddy.UserLevel > 4;
  if E.RealTime > 0 then
    LastTime.Caption:=Format('%.3f',[E.RealTime/1000])+' сек'
  else
    LastTime.Caption:='Нет опроса';
  PVRAW.Caption:=IfThen((E.Raw > 0),'Лог."1"','Лог."0"');
  if asNoLink in E.AlarmStatus then
    OP.Caption:='------'
  else
    OP.Caption:=IfThen(E.OP,'ВКЛЮЧЕН','ВЫКЛЮЧЕН');
  if not E.Actived or (asNoLink in E.AlarmStatus) then
    DataFormat.Caption:='------'
  else
    DataFormat.Caption:=Format('[%d] %s',[E.DataFormat,AFablFormat[E.DataFormat]]);
  if E.OP then
  begin
    LabelOn.Font.Color:=clGreen;
    ShapeOn.Brush.Color:=clLime;
    ShapeOff.Brush.Color:=clBlack;
    LabelOff.Font.Color:=clMoneyGreen;
  end
  else
  begin
    LabelOn.Font.Color:=clMoneyGreen;
    ShapeOn.Brush.Color:=clBlack;
    ShapeOff.Brush.Color:=clRed;
    LabelOff.Font.Color:=clMaroon;
  end;
  StatusListBox.Caption:=E.ErrorMess;
end;

procedure TKontDPPaspForm.FormResize(Sender: TObject);
begin
  with ButtonToMainScreen do Left:=Self.Width-Width-5;
  with ButtonToDataBase do Left:=Self.Width-Width-10-ButtonToMainScreen.Width;
end;

procedure TKontDPPaspForm.ButtonToDataBaseClick(Sender: TObject);
begin
  E.ShowEditor(Monitor.MonitorNum);
end;

procedure TKontDPPaspForm.OPSourceDblClick(Sender: TObject);
begin
  E.ShowParentPassport(Monitor.MonitorNum);
end;

procedure TKontDPPaspForm.EnterButtonClick(Sender: TObject);
var Value: Boolean; R: Single;
begin
  Value:=E.OP;
  if InputBooleanDlg('Введите значение позиции "'+E.PtName+'.OP"',
                     'ВКЛЮЧИТЬ','ОТКЛЮЧИТЬ',Value) then
  begin
    if Caddy.NetRole = nrClient then
    begin
      if E.Invert then
      begin
        if Value then
          R:=0
        else
          R:=1;
      end
      else
      begin
        if Value then
          R:=1
        else
          R:=0;
      end;
      E.CommandData:=R;
      E.HasCommand:=True;
    end
    else
      E.SendOP(IfThen(Value,1.0,0.0));
  end;
end;

procedure TKontDPPaspForm.ButtonToMainScreenClick(Sender: TObject);
begin
  E.ShowScheme(Monitor.MonitorNum);
end;

end.
