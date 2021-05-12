unit ShowActiveAlarmsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, EntityUnit, Grids, ExtCtrls, StdCtrls,
  ImgList, PanelFormUnit;

type
  TShowActiveAlarmsForm = class(TForm, IFresh, IEntity)
    DrawGrid: TDrawGrid;
    ControlBar: TControlBar;
    StatusPanel: TPanel;
    btnTrends: TButton;
    btnOverview: TButton;
    btnAskAll: TButton;
    procedure FormResize(Sender: TObject);
    procedure DrawGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure btnOverviewClick(Sender: TObject);
    procedure btnTrendsClick(Sender: TObject);
    procedure btnAskAllClick(Sender: TObject);
    procedure DrawGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DrawGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure DrawGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DrawGridDblClick(Sender: TObject);
  private
    Blink: boolean;
    SelRow: Integer;
    SmallImages: TImageList;
    FPanel: TPanelForm;
    procedure SmartQuit;
    procedure FreshView; stdcall;
    procedure ConnectEntity(Entity: TEntity); stdcall;
    procedure ConnectImageList(ImageList: TImageList); stdcall;
    procedure UpdateRealTime; stdcall;
  public
    procedure AlarmLogUpdate(Sender: TObject);
    procedure ShowMessagesCount;
    property Panel: TPanelForm read FPanel write FPanel;
  end;

implementation

uses RemXUnit;

{$R *.dfm}

{ TActiveAlarmsForm }

procedure TShowActiveAlarmsForm.ShowMessagesCount;
var S: string;
begin
  with Caddy.ActiveAlarmLog do
  if Count > 0 then
    S:=Format('Всего %s.',[NumToStr(Count,'сообщен','ие','ия','ий')])
  else
    S:='Нет сообщений.';
  RemXForm.ShowMessage:=S;
end;

procedure TShowActiveAlarmsForm.AlarmLogUpdate(Sender: TObject);
var S: string;
begin
  with Caddy.ActiveAlarmLog do
  if Count > 0 then
  begin
    DrawGrid.RowCount:=Count+1;
    S:=Format('Всего %s.',[NumToStr(Count,'сообщен','ие','ия','ий')]);
  end
  else
  begin
    DrawGrid.RowCount:=2;
    S:='Нет сообщений.';
  end;
  DrawGrid.Row:=1;
  DrawGrid.Invalidate;
  if Assigned(Panel) and Assigned(Panel.TopForm) and (Panel.TopForm = Self) then
    RemXForm.ShowMessage:=S;
end;

procedure TShowActiveAlarmsForm.FreshView;
var R: TRect; i,j,sum: integer;
begin
  sum:=0; for i:=0 to 2 do sum:=sum+DrawGrid.ColWidths[i];
  j:=sum+DrawGrid.ColWidths[3]; R:=Rect(sum,0,j,DrawGrid.Height);
  InvalidateRect(DrawGrid.Handle,@R,False);
//-------------------------------------------
  Blink:=not Blink;
  j:=DrawGrid.ColWidths[0]; R:=Rect(0,0,j,DrawGrid.Height);
  InvalidateRect(DrawGrid.Handle,@R,False);
end;

procedure TShowActiveAlarmsForm.FormResize(Sender: TObject);
var sum, i: Integer;
begin
  sum:=0;
  with DrawGrid do
  begin
    DefaultRowHeight:=24;
    Font.Size:=12;
    Font.Name:='Tahoma';
    ColWidths[0]:=85;
    ColWidths[1]:=140;
    ColWidths[2]:=165;
    ColWidths[3]:=150;
    ColWidths[4]:=150;
    ColWidths[5]:=300;
    for i:=0 to 5 do sum:=sum+ColWidths[i];
    ColWidths[6]:=Width-sum-GetSystemMetrics(SM_CXVSCROLL);
  end;
  StatusPanel.Width:=ControlBar.ClientWidth;
  StatusPanel.Height:=ControlBar.ClientHeight;
end;

procedure TShowActiveAlarmsForm.DrawGridDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var R: TActiveAlarmLogItem; T: string;
  procedure TuneColors;
  begin
    with DrawGrid do
    begin
      if R.Kind in [asNoLink] then
        Canvas.Font.Color:=clBlue
      else if R.Kind in [asShortBadPV,asOpenBadPV,asBadPV] then
        Canvas.Font.Color:=clFuchsia
      else if R.Kind in [asHH,asLL,asON,asOFF] then
        Canvas.Font.Color:=clRed
      else if R.Kind in [asHi,asLo,asDH,asDL,asInfo,asTimeOut] then
        Canvas.Font.Color:=clYellow
      else
        Canvas.Font.Color:=clGreen;
    end;
  end;
begin
  with DrawGrid do
  begin
    if ARow = 0 then
    begin
      Canvas.Font.Color:=clBlack;
      case ACol of
        0: Canvas.TextRect(Rect,Rect.Left+5,Rect.Top+1,'Тип');
        1: Canvas.TextRect(Rect,Rect.Left+5,Rect.Top+1,'Время');
        2: Canvas.TextRect(Rect,Rect.Left+5,Rect.Top+1,'Позиция');
        3: Canvas.TextRect(Rect,Rect.Left+5,Rect.Top+1,'Значение');
        4: Canvas.TextRect(Rect,Rect.Left+5,Rect.Top+1,'Уставка');
        5: Canvas.TextRect(Rect,Rect.Left+5,Rect.Top+1,'Сообщение');
        6: Canvas.TextRect(Rect,Rect.Left+5,Rect.Top+1,'Дескриптор');
      end;
    end
    else
    if Caddy.ActiveAlarmLog.Count > 0 then
    begin
      R:=TActiveAlarmLogItem(Caddy.ActiveAlarmLog.Items[ARow-1]);
      case ACol of
        0: begin
             TuneColors;
             Canvas.Brush.Color:=ABrushColor[R.Kind,
                                            (R.Kind in R.AlarmStatus),
                                            (R.Kind in R.ConfirmStatus),
                                            Blink];
             Canvas.Font.Color:=AFontColor[R.Kind,
                                          (R.Kind in R.AlarmStatus),
                                          (R.Kind in R.ConfirmStatus),
                                          Blink];
             Canvas.FillRect(Rect);
             Canvas.TextRect(Rect,Rect.Left+5,Rect.Top+1,AAlarmText[R.Kind]);
           end;
        1: Canvas.TextRect(Rect,Rect.Left+5,Rect.Top+1,
                               FormatDateTime('dd hh:nn:ss.zzz',R.SnapTime));
        2: begin
             Canvas.Font.Color:=clAqua;
             Canvas.TextRect(Rect,Rect.Left+20,Rect.Top+1,R.Position+'.PV');
             SmallImages.Draw(Canvas,Rect.Left+1,Rect.Top+1,R.ImageIndex+3);
           end;
        3: try
             begin
               T:=R.Source.PtText;
               Canvas.Font.Color:=clWhite;
               Canvas.TextRect(Rect,Rect.Left+(ColWidths[3]-
                               Canvas.TextWidth(T)-5),Rect.Top+1,T);
             end;
           except
             begin
               T:=R.Value;
               Canvas.Font.Color:=clWhite;
               Canvas.TextRect(Rect,Rect.Left+(ColWidths[3]-
                               Canvas.TextWidth(T)-5),Rect.Top+1,T);
             end;
           end;
        4: begin
             T:=R.SetPoint;
             Canvas.Font.Color:=clWhite;
             Canvas.TextRect(Rect,Rect.Left+(ColWidths[4]-
                             Canvas.TextWidth(T)-5),Rect.Top+1,T);
           end;
        5: begin
             TuneColors;
             Canvas.TextRect(Rect,Rect.Left+5,Rect.Top+1,R.Mess);
           end;
        6: Canvas.TextRect(Rect,Rect.Left+5,Rect.Top+1,R.Descriptor);
      end;
    end;
  end;
end;

procedure TShowActiveAlarmsForm.FormCreate(Sender: TObject);
begin
  SelRow:=-1;
  AlarmLogUpdate(Caddy);
  btnAskAll.Visible := not Caddy.NoAsk;
end;

procedure TShowActiveAlarmsForm.btnOverviewClick(Sender: TObject);
var E: TEntity; Item: TActiveAlarmLogItem;
begin
  with Caddy.ActiveAlarmLog do
  if (SelRow > 0) and (SelRow <= Count) then
  begin
    Item:=Items[SelRow-1] as TActiveAlarmLogItem;
    E:=Item.Source as TEntity;
    E.ShowScheme(Monitor.MonitorNum);
  end
  else
    Panel.actOverview.Execute;
end;

procedure TShowActiveAlarmsForm.btnTrendsClick(Sender: TObject);
begin
  Panel.actTrends.Execute;
end;

procedure TShowActiveAlarmsForm.btnAskAllClick(Sender: TObject);
var i,k,n: integer;
begin
  
  if Caddy.NoAsk then Exit; // добавлено 15.07.12
  if Caddy.UserLevel = 0 then
  begin
    RemXForm.ShowWarning('Пользователь не зарегистрирован!');
    Exit;
  end;
  btnAskAll.Enabled:=False;
  try
    k:=DrawGrid.TopRow;
    n:=DrawGrid.Row;
    for i:=DrawGrid.RowCount-1 downto 1 do
    begin
      SelRow:=i;
      SmartQuit;
    end;
    DrawGrid.Row:=n;
    DrawGrid.TopRow:=k;
    DrawGrid.SetFocus;
  finally
    btnAskAll.Enabled:=True;
  end;
end;

procedure TShowActiveAlarmsForm.DrawGridSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  with Caddy.ActiveAlarmLog do
  if (ARow <= Count) and
     (ARow > 0) then
  begin
    SelRow:=ARow;
    CanSelect:=True;
  end
  else
  begin
    SelRow:=-1;
    CanSelect:=False;
  end;
end;

procedure TShowActiveAlarmsForm.SmartQuit;
var LastRow,LastTopRow: integer;
begin
  if Caddy.NoAsk then Exit; // добавлено 15.07.12
  if Caddy.UserLevel = 0 then
  begin
    RemXForm.ShowWarning('Пользователь не зарегистрирован!');
    Exit;
  end;
  Caddy.Beeper.ShortUp;
  LastRow:=DrawGrid.Row;
  LastTopRow:=DrawGrid.TopRow;
  Caddy.SmartAskByIndex(SelRow-1);
  if LastRow < DrawGrid.RowCount then
    DrawGrid.Row:=LastRow
  else
    DrawGrid.Row:=DrawGrid.RowCount-1;
  DrawGrid.TopRow:=LastTopRow;
end;

procedure TShowActiveAlarmsForm.DrawGridMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var ACol,ARow: Integer; CanSelect: Boolean;
begin
  DrawGrid.MouseToCell(X,Y,ACol,ARow);
  DrawGridSelectCell(Sender,ACol,ARow,CanSelect);
  if CanSelect then
  begin
    DrawGrid.Row:=ARow;
    if Button = mbRight then SmartQuit;
  end;
end;

procedure TShowActiveAlarmsForm.DrawGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_SPACE then
  begin
    SmartQuit;
    Key:=0;
  end;
  if Key = VK_END then
  begin
    with Caddy.ActiveAlarmLog do
    if Count > 0 then
      DrawGrid.Row := Count;
    Key := 0;
  end;
  if Key = VK_HOME then
  begin
    with Caddy.ActiveAlarmLog do
    if Count > 0 then
      DrawGrid.Row := 1;
    Key := 0;
  end;
end;

procedure TShowActiveAlarmsForm.DrawGridDblClick(Sender: TObject);
var E: TEntity; Item: TActiveAlarmLogItem;
begin
  with Caddy.ActiveAlarmLog do
  if (SelRow > 0) and (SelRow <= Count) then
  begin
    Item:=Items[SelRow-1] as TActiveAlarmLogItem;
    E:=Item.Source as TEntity;
    E.ShowPassport(Monitor.MonitorNum);
  end;
end;

procedure TShowActiveAlarmsForm.ConnectEntity(Entity: TEntity);
begin
// Stub
end;

procedure TShowActiveAlarmsForm.ConnectImageList(ImageList: TImageList);
begin
  SmallImages:=ImageList;
end;

procedure TShowActiveAlarmsForm.UpdateRealTime;
begin
// Stub
end;

end.
