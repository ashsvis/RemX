unit VzljotNDPaspUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, Buttons, EntityUnit, VzljotURSVUnit;

type
  TVzljotNDPaspForm = class(TForm,IEntity)
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
    Label6: TLabel;
    Node: TLabel;
    NodeWorkModeLabel: TLabel;
    VzNodeMode: TLabel;
    NodeStatusLabel: TLabel;
    VzNodeVersion: TLabel;
    Label26: TLabel;
    NodeTime: TLabel;
    Label28: TLabel;
    NodeDate: TLabel;
    Label5: TLabel;
    Label2: TLabel;
    NodeType: TLabel;
    procedure ButtonToDataBaseClick(Sender: TObject);
    procedure OPSourceDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonToMainScreenClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    E: TURSVNode;
    procedure ConnectEntity(Entity: TEntity); stdcall;
    procedure ConnectImageList(ImageList: TImageList); stdcall;
    procedure UpdateRealTime; stdcall;
  public
  end;

var
  VzljotNDPaspForm: TVzljotNDPaspForm;

implementation

uses StrUtils, Math;

{$R *.dfm}

{ TVirtNDPaspForm }

procedure TVzljotNDPaspForm.ConnectEntity(Entity: TEntity);
begin
  E:=Entity as TURSVNode;
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
  Node.Caption:=Format('%d',[E.Node]);
  UpdateRealTime;
end;

procedure TVzljotNDPaspForm.ConnectImageList(ImageList: TImageList);
begin
// Stub
end;

procedure TVzljotNDPaspForm.UpdateRealTime;
begin
  ButtonToDataBase.Visible:=Caddy.UserLevel > 4;
  if E.RealTime > 0 then
    LastTime.Caption:=Format('%.3f',[E.RealTime/1000])+' сек'
  else
    LastTime.Caption:='Нет опроса';
  NodeType.Caption:=AVzNodeFormat[E.NodeType];
  StatusListBox.Caption:=E.ErrorMess;
  VzNodeMode.Caption:=E.NodeMode;
  VzNodeVersion.Caption:=E.NodeVersion;
  NodeDate.Caption:=FormatDateTime('dd/mm/yy',E.NodeDateTime);
  NodeTime.Caption:=FormatDateTime('hh:nn:ss',E.NodeDateTime);
end;

procedure TVzljotNDPaspForm.ButtonToDataBaseClick(Sender: TObject);
begin
  E.ShowEditor(Monitor.MonitorNum);
end;

procedure TVzljotNDPaspForm.OPSourceDblClick(Sender: TObject);
begin
  E.ShowParentPassport(Monitor.MonitorNum);
end;

procedure TVzljotNDPaspForm.FormCreate(Sender: TObject);
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
(*
         if Components[i] is TMemo then
         begin
           Memo.Left:=Round(Memo.Left/1.28);
           Memo.Top:=Round(Memo.Top/1.28);
           Memo.Width:=Round(Memo.Width/1.28);
           Memo.Height:=Round(Memo.Height/1.28);
           Memo.Font.Size:=10;
         end;
*)
         if Components[i] is TButton then
         begin
           B:=Components[i] as TButton;
           if B.Parent = Panel6 then
           begin
             B.Left:=Round(B.Left/1.28);
             B.Top:=Round(B.Top/1.28);
             B.Width:=Round(B.Width/1.28);
             B.Height:=Round(B.Height/1.28);
             B.Font.Size:=8;
             B.Font.Name:='Tahoma';
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
(*
         if Components[i] is TMemo then
         begin
           Memo.Left:=Round(Memo.Left/0.8);
           Memo.Top:=Round(Memo.Top/0.8);
           Memo.Width:=Round(Memo.Width/0.8);
           Memo.Height:=Round(Memo.Height/0.8);
           Memo.Font.Size:=12;
         end;
*)
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
           if B.Parent = Panel6 then
           begin
             B.Left:=Round(B.Left/0.8);
             B.Top:=Round(B.Top/0.8);
             B.Width:=Round(B.Width/0.8);
             B.Height:=Round(B.Height/0.8);
             B.Font.Size:=10;
             B.Font.Name:='Tahoma';
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

procedure TVzljotNDPaspForm.ButtonToMainScreenClick(Sender: TObject);
begin
  E.ShowScheme(Monitor.MonitorNum);
end;

procedure TVzljotNDPaspForm.FormResize(Sender: TObject);
begin
  with ButtonToMainScreen do Left:=Self.Width-Width-5;
  with ButtonToDataBase do Left:=Self.Width-Width-10-ButtonToMainScreen.Width;
end;

end.
