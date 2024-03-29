unit ShowActiveSwitchsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, EntityUnit, Grids, ExtCtrls, StdCtrls,
  ImgList, PanelFormUnit;

type
  TShowActiveSwitchsForm = class(TForm, IEntity)
    DrawGrid: TDrawGrid;
    ControlBar: TControlBar;
    StatusPanel: TPanel;
    btnOverview: TButton;
    btnTrends: TButton;
    procedure FormResize(Sender: TObject);
    procedure DrawGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure btnOverviewClick(Sender: TObject);
    procedure DrawGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure DrawGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DrawGridDblClick(Sender: TObject);
    procedure btnTrendsClick(Sender: TObject);
  private
    SelRow: Integer;
    SmallImages: TImageList;
    FPanel: TPanelForm;
    procedure ConnectEntity(Entity: TEntity); stdcall;
    procedure ConnectImageList(ImageList: TImageList); stdcall;
    procedure UpdateRealTime; stdcall;
  public
    procedure SwitchLogUpdate(Sender: TObject);
    procedure ShowMessagesCount;
    property Panel: TPanelForm read FPanel write FPanel;
  end;

var
  ShowActiveSwitchsForm: TShowActiveSwitchsForm;
  ShowActiveSwitchsForm2: TShowActiveSwitchsForm;

implementation

uses RemXUnit;

{$R *.dfm}

{ TActiveSwitchsForm }

procedure TShowActiveSwitchsForm.SwitchLogUpdate(Sender: TObject);
var S: string;
begin
  with Caddy.ActiveSwitchLog do
  if Count > 0 then
  begin
    DrawGrid.RowCount:=Count+1;
    S:=Format('����� %s.',[NumToStr(Count,'�������','��','��','��')]);
  end
  else
  begin
    DrawGrid.RowCount:=2;
    S:='��� ���������.';
  end;
  DrawGrid.Row:=1;
  DrawGrid.Invalidate;
  if Assigned(Panel) and Assigned(Panel.TopForm) and (Panel.TopForm = Self) then
    RemXForm.ShowMessage:=S;
end;

procedure TShowActiveSwitchsForm.FormResize(Sender: TObject);
var i,sum: integer;
begin
  sum:=0;
  with DrawGrid do
  begin
    DefaultRowHeight:=25;
    Font.Size:=12;
    Font.Name:='Tahoma';
    ColWidths[0]:=100;
    ColWidths[1]:=120;
    ColWidths[2]:=170;
    ColWidths[3]:=150;
    for i:=0 to 3 do sum:=sum+ColWidths[i];
    ColWidths[4]:=Width-sum-GetSystemMetrics(SM_CXVSCROLL);
  end;
  StatusPanel.Width:=ControlBar.ClientWidth;
  StatusPanel.Height:=ControlBar.ClientHeight;
end;

procedure TShowActiveSwitchsForm.DrawGridDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var R: TActiveSwitchLogItem;
  procedure TuneColors;
  begin
    with DrawGrid do
    begin
      if R.Kind in [asNoLink] then
        Canvas.Font.Color:=clBlue
      else if R.Kind in [asShortBadPV,asOpenBadPV] then
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
        0: Canvas.TextRect(Rect,Rect.Left+5,Rect.Top+1,'����');
        1: Canvas.TextRect(Rect,Rect.Left+5,Rect.Top+1,'�����');
        2: Canvas.TextRect(Rect,Rect.Left+5,Rect.Top+1,'�������');
        3: Canvas.TextRect(Rect,Rect.Left+5,Rect.Top+1,'��������');
        4: Canvas.TextRect(Rect,Rect.Left+5,Rect.Top+1,'����������');
      end;
    end
    else
    if Caddy.ActiveSwitchLog.Count > 0 then
    begin
      R:=TActiveSwitchLogItem(Caddy.ActiveSwitchLog.Items[ARow-1]);
      case ACol of
        0: Canvas.TextRect(Rect,Rect.Left+5,Rect.Top+1,
                                   FormatDateTime('dd.mm.yyyy',R.SnapTime));
        1: Canvas.TextRect(Rect,Rect.Left+5,Rect.Top+1,
                                   FormatDateTime('hh:nn:ss.zzz',R.SnapTime));
        2: begin
             Canvas.Font.Color:=clAqua;
             Canvas.TextRect(Rect,Rect.Left+20,Rect.Top+1,R.Position+'.PV');
             SmallImages.Draw(Canvas,Rect.Left+1,Rect.Top+1,R.ImageIndex+3);
           end;
        3: begin
             Canvas.Font.Color:=clWhite;
             Canvas.TextRect(Rect,Rect.Left+5,Rect.Top+1,R.Value);
           end;
        4: Canvas.TextRect(Rect,Rect.Left+5,Rect.Top+1,R.Descriptor);
      end;
    end;
  end;
end;

procedure TShowActiveSwitchsForm.FormCreate(Sender: TObject);
begin
  SelRow:=-1;
  SwitchLogUpdate(Caddy);
end;

procedure TShowActiveSwitchsForm.btnOverviewClick(Sender: TObject);
var E: TEntity; Item: TActiveSwitchLogItem;
begin
  with Caddy.ActiveSwitchLog do
  if (SelRow > 0) and (SelRow <= Count) then
  begin
    Item:=Items[SelRow-1] as TActiveSwitchLogItem;
    E:=Caddy.FirstEntity;
    while E <> nil do
    begin
      if E.PtName = Item.Position then Break;
      E:=E.NextEntity;
    end;
    if Assigned(E) then
      E.ShowScheme(Monitor.MonitorNum)
    else
      Panel.actOverview.Execute;
  end
  else
    Panel.actOverview.Execute;
end;

procedure TShowActiveSwitchsForm.DrawGridSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  with Caddy.ActiveSwitchLog do
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

procedure TShowActiveSwitchsForm.DrawGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_END then
  begin
    with Caddy.ActiveSwitchLog do
    if Count > 0 then
      DrawGrid.Row := Count;
    Key := 0;
  end;
  if Key = VK_HOME then
  begin
    with Caddy.ActiveSwitchLog do
    if Count > 0 then
      DrawGrid.Row := 1;
    Key := 0;
  end;
end;

procedure TShowActiveSwitchsForm.DrawGridDblClick(Sender: TObject);
var E: TEntity; Item: TActiveSwitchLogItem;
begin
  with Caddy.ActiveSwitchLog do
  if (SelRow > 0) and (SelRow <= Count) then
  begin
    Item:=Items[SelRow-1] as TActiveSwitchLogItem;
    E:=Caddy.FirstEntity;
    while E <> nil do
    begin
      if E.PtName = Item.Position then Break;
      E:=E.NextEntity;
    end;
    if Assigned(E) then
      E.ShowPassport(Monitor.MonitorNum);
  end;
end;

procedure TShowActiveSwitchsForm.ConnectEntity(Entity: TEntity);
begin
// Stub;
end;

procedure TShowActiveSwitchsForm.ConnectImageList(ImageList: TImageList);
begin
  SmallImages:=ImageList;
end;

procedure TShowActiveSwitchsForm.UpdateRealTime;
begin
// Stub;
end;

procedure TShowActiveSwitchsForm.ShowMessagesCount;
var S: string;
begin
  with Caddy.ActiveSwitchLog do
  if Count > 0 then
    S:=Format('����� %s.',[NumToStr(Count,'�������','��','��','��')])
  else
    S:='��� ���������.';
  RemXForm.ShowMessage:=S;
end;

procedure TShowActiveSwitchsForm.btnTrendsClick(Sender: TObject);
begin
  Panel.actTrends.Execute;
end;

end.
