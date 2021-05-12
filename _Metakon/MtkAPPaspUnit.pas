unit MtkAPPaspUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, EntityUnit, MetakonUnit, RxGraph;

type
  TMtkAPPaspForm = class(TForm,IEntity)
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
    MtkKind: TLabel;
    EnterButton: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ButtonToDataBaseClick(Sender: TObject);
    procedure OPSourceDblClick(Sender: TObject);
    procedure EnterButtonClick(Sender: TObject);
    procedure ButtonToMainScreenClick(Sender: TObject);
  private
    E: TMtkAnaParam;
    RxGraph: TRxGraph;
    procedure ConnectEntity(Entity: TEntity); stdcall;
    procedure ConnectImageList(ImageList: TImageList); stdcall;
    procedure UpdateRealTime; stdcall;
  public
  end;

var
  MtkAPPaspForm: TMtkAPPaspForm;

implementation

uses StrUtils, Math, GetPtNameUnit, RemXUnit;

{$R *.dfm}

{ TMtkAPPaspForm }

procedure TMtkAPPaspForm.ConnectEntity(Entity: TEntity);
var sFormat: string;
begin
  E:=Entity as TMtkAnaParam;
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
  MtkKind.Caption:=AFullMtkKind[E.MtkKind];
  UpdateRealTime;
end;

procedure TMtkAPPaspForm.ConnectImageList(ImageList: TImageList);
begin
// Stub
end;

procedure TMtkAPPaspForm.UpdateRealTime;
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

procedure TMtkAPPaspForm.FormCreate(Sender: TObject);
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
  RxGraph.OPRAW:=0;
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

procedure TMtkAPPaspForm.FormResize(Sender: TObject);
begin
  RxGraph.Left:=10;
  RxGraph.Width:=PVPanel.Width-30;
  RxGraph.Top:=0;
  RxGraph.Height:=PTName.Top-PTName.Height;
  with ButtonToMainScreen do Left:=Self.Width-Width-5;
  with ButtonToDataBase do Left:=Self.Width-Width-10-ButtonToMainScreen.Width;
end;

procedure TMtkAPPaspForm.ButtonToDataBaseClick(Sender: TObject);
begin
  E.ShowEditor(Monitor.MonitorNum);
end;

procedure TMtkAPPaspForm.OPSourceDblClick(Sender: TObject);
begin
  E.ShowParentPassport(Monitor.MonitorNum);
end;

procedure TMtkAPPaspForm.EnterButtonClick(Sender: TObject);
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

procedure TMtkAPPaspForm.ButtonToMainScreenClick(Sender: TObject);
begin
  E.ShowScheme(Monitor.MonitorNum);
end;

end.
