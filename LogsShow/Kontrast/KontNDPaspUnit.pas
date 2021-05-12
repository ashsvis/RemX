unit KontNDPaspUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, Buttons, EntityUnit, KontrastUnit;

type
  TKontNDPaspForm = class(TForm,IEntity)
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
    KR300Mode: TLabel;
    NodeStatusLabel: TLabel;
    KR300Status: TLabel;
    Label26: TLabel;
    NodeTime: TLabel;
    Label28: TLabel;
    NodeDate: TLabel;
    ResetButton: TButton;
    Memo: TMemo;
    Label3: TLabel;
    Label5: TLabel;
    Label2: TLabel;
    NodeType: TLabel;
    procedure ButtonToDataBaseClick(Sender: TObject);
    procedure OPSourceDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ResetButtonClick(Sender: TObject);
    procedure ButtonToMainScreenClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    E: TKontNode;
    procedure ConnectEntity(Entity: TEntity); stdcall;
    procedure ConnectImageList(ImageList: TImageList); stdcall;
    procedure UpdateRealTime; stdcall;
  public
  end;

var
  KontNDPaspForm: TKontNDPaspForm;

implementation

uses StrUtils, Math, DateUtils, RemXUnit;

{$R *.dfm}

{ TVirtNDPaspForm }
const
  ANodeType: array[0..20] of string =
               ('РК-131/300','КР-300','КР-300И','БУСО-1','КР-500',
                'нет данных','нет данных','нет данных',
                'БК-500М','БК-500К','МК-500-10',
                'нет данных','нет данных','нет данных','нет данных',
                'нет данных','нет данных','нет данных','нет данных',
                'МК-500-20','БК-500К-ПС8');

procedure TKontNDPaspForm.ConnectEntity(Entity: TEntity);
begin
  E:=Entity as TKontNode;
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

procedure TKontNDPaspForm.ConnectImageList(ImageList: TImageList);
begin
// Stub
end;

procedure TKontNDPaspForm.UpdateRealTime;
const AB: array[Boolean] of string = ('Нет','Да');
      AT: array[Boolean] of string = ('Младший','Старший');
var DT: TDateTime; i,Err: integer; S,W: string; SL: TStringList;
begin
  ButtonToDataBase.Visible:=Caddy.UserLevel > 4;
  ResetButton.Visible := (Caddy.UserLevel > 1) and
                         (E.ErrController.NodeType in [1,2,4]);
  if E.RealTime > 0 then
    LastTime.Caption:=Format('%.3f',[E.RealTime/1000])+' сек'
  else
    LastTime.Caption:='Нет опроса';
  NodeType.Caption:=ANodeType[E.ErrController.NodeType];
  StatusListBox.Caption:=E.ErrorMess;
  if E.errController.Mode then
  begin
    KR300Mode.Caption:='Программирование';
    KR300Mode.Font.Color:=clRed;
  end
  else
  begin
    KR300Mode.Caption:='РАБОТА';
    KR300Mode.Font.Color:=clAqua;
  end;
  if E.errController.Status then
    KR300Status.Caption:='Резервированный'
  else
    KR300Status.Caption:='Автономный';
  with E.ErrController do
  begin
    if (Month in [1..12]) and (Day in [1..31]) and (Hour in [0..23]) and
       (Minute in [0..59]) and (Second in [0..59]) then
    begin
      DT:=EncodeDateTime(2000+Year,Month,Day,Hour,Minute,Second,0);
      NodeDate.Caption:=FormatDateTime('dd/mm/yy',DT);
      NodeTime.Caption:=FormatDateTime('hh:nn:ss',DT);
    end
    else
    begin
      NodeDate.Caption:='----';
      NodeTime.Caption:='----';
    end;
  end;
  Memo.Lines.BeginUpdate;
  SL:=TStringList.Create;
  try
    i:=0;
    while i < E.errController.ErrCount do
    begin
      Err:=E.errController.ErrInfo[i].ErrType;
      if (Err and $80) > 0 then S:='Отк' else S:='Ош';
      W:=FormatDateTime('yyyy.mm.dd hh:nn',E.errController.ErrInfo[i].When);
      S:=S+Format(': %d(%3.3d)',[Err and $7F,E.errController.ErrInfo[i].ErrPlace])+
           FormatDateTime('[dd.mm.yy hh:nn]',E.errController.ErrInfo[i].When)+' '+
           E.GetSourceText(E.ErrController.NodeType,Err,
                           E.errController.ErrInfo[i].ErrPlace);
      SL.Append(W+'|'+S);
      Inc(i);
    end;
    SL.Sort;
    for i:=0 to SL.Count-1 do SL[i]:=Copy(SL[i],Pos('|',SL[i])+1,Length(SL[i]));
    if Memo.Lines.Text <> SL.Text then Memo.Lines.Assign(SL);
  finally
    SL.Free;
    Memo.Lines.EndUpdate;
  end;
end;

procedure TKontNDPaspForm.ButtonToDataBaseClick(Sender: TObject);
begin
  E.ShowEditor(Monitor.MonitorNum);
end;

procedure TKontNDPaspForm.OPSourceDblClick(Sender: TObject);
begin
  E.ShowParentPassport(Monitor.MonitorNum);
end;

procedure TKontNDPaspForm.FormCreate(Sender: TObject);
begin
  Memo.DoubleBuffered:=True;
end;

procedure TKontNDPaspForm.ResetButtonClick(Sender: TObject);
begin
  if RemxForm.ShowQuestion('Очистить журнал ошибок контроллера?') = mrOK then
  begin
    if Caddy.NetRole = nrClient then
    begin
      E.CommandData:=0;
      E.HasCommand:=True;
    end
    else
      E.ClearLog;
  end;
end;

procedure TKontNDPaspForm.ButtonToMainScreenClick(Sender: TObject);
begin
  E.ShowScheme(Monitor.MonitorNum);
end;

procedure TKontNDPaspForm.FormResize(Sender: TObject);
begin
  with ButtonToMainScreen do Left:=Self.Width-Width-5;
  with ButtonToDataBase do Left:=Self.Width-Width-10-ButtonToMainScreen.Width;
  with ResetButton do Left:=Panel6.Width-Width-5;
end;

end.
