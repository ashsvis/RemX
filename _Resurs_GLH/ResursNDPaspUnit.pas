unit ResursNDPaspUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, Buttons, EntityUnit, ResursGLHUnit;

type
  TResursNDPaspForm = class(TForm,IEntity)
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
    Panel3: TPanel;
    StatusPanel: TPanel;
    Label11: TLabel;
    StatusListBox: TLabel;
    Entity: TLabel;
    Label61: TLabel;
    Label1: TLabel;
    LabelParameter: TLabel;
    Label4: TLabel;
    Channel: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label2: TLabel;
    GLHTime: TLabel;
    Label12: TLabel;
    GLHBlockNo: TLabel;
    Label6: TLabel;
    GLHBlockLength: TLabel;
    Label7: TLabel;
    GLHBlockType: TLabel;
    ShowMoreButton: TButton;
    ConfigChannelsButton: TButton;
    ConfigPointsButton: TButton;
    ConfigGroupsButton: TButton;
    procedure ButtonToDataBaseClick(Sender: TObject);
    procedure OPSourceDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonToMainScreenClick(Sender: TObject);
    procedure ShowMoreButtonClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ConfigChannelsButtonClick(Sender: TObject);
    procedure ConfigPointsButtonClick(Sender: TObject);
    procedure ConfigGroupsButtonClick(Sender: TObject);
  private
    E: TResursGLHNode;
    procedure ConnectEntity(Entity: TEntity); stdcall;
    procedure ConnectImageList(ImageList: TImageList); stdcall;
    procedure UpdateRealTime; stdcall;
  public
  end;

var
  ResursNDPaspForm: TResursNDPaspForm;

implementation

uses StrUtils, Math,  ResursTreeUnit, ResursChannelsUnit,
  ResursPointsUnit, ResursGroupsUnit;

{$R *.dfm}

{ TResursNDPaspForm }

procedure TResursNDPaspForm.ConnectEntity(Entity: TEntity);
begin
  E:=Entity as TResursGLHNode;
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
//-------------------------------------
  Channel.Caption:=Format('%d',[E.Channel]);
  UpdateRealTime;
end;

procedure TResursNDPaspForm.ConnectImageList(ImageList: TImageList);
begin
// Stub
end;

procedure TResursNDPaspForm.UpdateRealTime;
begin
  ButtonToDataBase.Visible:=Caddy.UserLevel > 4;
  if E.RealTime > 0 then
    LastTime.Caption:=Format('%.3f',[E.RealTime/1000])+' сек'
  else
    LastTime.Caption:='Нет опроса';
  StatusListBox.Caption:=E.ErrorMess;
  GLHBlockType.Caption:=ABlockType[E.BlockType];
  GLHTime.Caption:=Format('%2.2d:%2.2d:%2.2d',[E.Hour,E.Min,E.Sec]);
  GLHBlockNo.Caption:=Format('%d (%d%% загружено)',[E.BlockNo,
                                          E.BlockNo*100 div E.BlockUsed]);
  GLHBlockLength.Caption:=Format('%d',[E.BlockLength]);
  ShowMoreButton.Visible:=E.ChanPointsReady and E.GroupsReady;
  ConfigChannelsButton.Visible:=E.ChanPointsReady;
  ConfigPointsButton.Visible:=E.ChanPointsReady;
  ConfigGroupsButton.Visible:=E.GroupsReady;
end;

procedure TResursNDPaspForm.ButtonToDataBaseClick(Sender: TObject);
begin
  E.ShowEditor(Monitor.MonitorNum);
end;

procedure TResursNDPaspForm.OPSourceDblClick(Sender: TObject);
begin
  E.ShowParentPassport(Monitor.MonitorNum);
end;

procedure TResursNDPaspForm.FormCreate(Sender: TObject);
var ScreenSizeIndex,i: integer; L: TLabel; P: TPanel; S: TShape; B: TButton;
begin
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
         if Components[i] is TPanel then
         begin
           P:=Components[i] as TPanel;
           if P.Align <> alClient then
           begin
             P.Width:=Round(P.Width/1.28);
             P.Height:=Round(P.Height/1.28);
           end;
         end;
         if Components[i] is TButton then
         begin
           B:=Components[i] as TButton;
           B.Left:=Round(B.Left/1.28);
           B.Top:=Round(B.Top/1.28);
           B.Width:=Round(B.Width/1.28);
           B.Height:=Round(B.Height/1.28);
           B.Font.Size:=8;
           B.Font.Name:='Tahoma';
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
         if Components[i] is TButton then
         begin
           B:=Components[i] as TButton;
           B.Left:=Round(B.Left/0.8);
           B.Top:=Round(B.Top/0.8);
           B.Width:=Round(B.Width/0.8);
           B.Height:=Round(B.Height/0.8);
           B.Font.Size:=10;
           B.Font.Name:='Tahoma';
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

procedure TResursNDPaspForm.ButtonToMainScreenClick(Sender: TObject);
begin
  E.ShowScheme(Monitor.MonitorNum);
end;

procedure TResursNDPaspForm.FormResize(Sender: TObject);
begin
  with ButtonToMainScreen do Left:=Self.Width-Width-5;
  with ButtonToDataBase do Left:=Self.Width-Width-10-ButtonToMainScreen.Width;
end;

procedure TResursNDPaspForm.ShowMoreButtonClick(Sender: TObject);
begin
  ResursTreeForm:=TResursTreeForm.Create(Self);
  try
    ResursTreeForm.E:=E;
    ResursTreeForm.ShowModal;
  finally
    ResursTreeForm.Free;
  end;
end;

procedure TResursNDPaspForm.ConfigChannelsButtonClick(Sender: TObject);
begin
  ResursChannelsForm:=TResursChannelsForm.Create(Self);
  try
    ResursChannelsForm.E:=E;
    ResursChannelsForm.ShowModal;
  finally
    ResursChannelsForm.Free;
  end;
end;

procedure TResursNDPaspForm.ConfigPointsButtonClick(Sender: TObject);
begin
  ResursPointsForm:=TResursPointsForm.Create(Self);
  try
    ResursPointsForm.E:=E;
    ResursPointsForm.ShowModal;
  finally
    ResursPointsForm.Free;
  end;
end;

procedure TResursNDPaspForm.ConfigGroupsButtonClick(Sender: TObject);
begin
  ResursGroupsForm:=TResursGroupsForm.Create(Self);
  try
    ResursGroupsForm.E:=E;
    ResursGroupsForm.ShowModal;
  finally
    ResursGroupsForm.Free;
  end;
end;

end.
