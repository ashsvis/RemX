unit PanelFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ToolWin, ActnMan, ActnCtrls, ActnMenus, StdCtrls, Contnrs,
  ActnList, XPStyleActnCtrls, FR_Class, AppEvnts, ImgList, EntityUnit,
  WinSpool, Printers, ShowPreviewUnit;

type
  TPanelForm = class(TForm, IFresh)
    TopScrollBox: TScrollBox;
    Image1: TImage;
    TimeLabel: TLabel;
    CaptionLabel: TLabel;
    ActionMainMenuBar: TActionMainMenuBar;
    StatusControlBar: TPanel;
    StatusPanel: TPanel;
    AlarmPanel: TPanel;
    AlarmPaintBox: TPaintBox;
    SwitchPanel: TPanel;
    SwitchPaintBox: TPaintBox;
    UserPanel: TPanel;
    StatusBar: TPanel;
    StatusPaintBox: TPaintBox;
    LongOperationsPanel: TPanel;
    LangPanel: TPanel;
    paLongInfoStatus: TPanel;
    pbLongInfoStatus: TPaintBox;
    ScrollBox: TPanel;
    Clock: TTimer;
    SystemImageList: TImageList;
    ApplicationEvents: TApplicationEvents;
    StatusImageList: TImageList;
    ClearStatus: TTimer;
    Fresh: TTimer;
    ActionManager: TActionManager;
    actOverview: TAction;
    actRegUser: TAction;
    actExit: TAction;
    actBaseEdit: TAction;
    actHistGroups: TAction;
    actTuning: TAction;
    actSchemeEdit: TAction;
    actReportEdit: TAction;
    actUsersEditor: TAction;
    actImportOldConfig: TAction;
    actActiveAlarms: TAction;
    actActiveSwitchs: TAction;
    actTrends: TAction;
    actTables: TAction;
    actReports: TAction;
    actAlarmLogShow: TAction;
    actSwitchLogShow: TAction;
    actChangeLogShow: TAction;
    actSystemLogShow: TAction;
    actAbout: TAction;
    actReportLogs: TAction;
    acPreview: TAction;
    actCloseGames: TAction;
    actRegProgram: TAction;
    ExternalActionList: TActionList;
    MenuSchemesActionList: TActionList;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actOverviewExecute(Sender: TObject);
    procedure actRegUserExecute(Sender: TObject);
    procedure UserPanelClick(Sender: TObject);
    procedure actActiveAlarmsExecute(Sender: TObject);
    procedure actActiveSwitchsExecute(Sender: TObject);
    procedure actAlarmLogShowExecute(Sender: TObject);
    procedure actBaseEditExecute(Sender: TObject);
    procedure actBaseEditUpdate(Sender: TObject);
    procedure actTrendsExecute(Sender: TObject);
    procedure actTablesExecute(Sender: TObject);
    procedure actReportsExecute(Sender: TObject);
    procedure actReportLogsExecute(Sender: TObject);
    procedure actHistGroupsExecute(Sender: TObject);
    procedure actHistGroupsUpdate(Sender: TObject);
    procedure actTuningExecute(Sender: TObject);
    procedure actTuningUpdate(Sender: TObject);
    procedure actSchemeEditExecute(Sender: TObject);
    procedure actSchemeEditUpdate(Sender: TObject);
    procedure actReportEditExecute(Sender: TObject);
    procedure actReportEditUpdate(Sender: TObject);
    procedure actUsersEditorExecute(Sender: TObject);
    procedure actUsersEditorUpdate(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
    procedure actRegProgramExecute(Sender: TObject);
    procedure actRegProgramUpdate(Sender: TObject);
    procedure acPreviewExecute(Sender: TObject);
    procedure ClockTimer(Sender: TObject);
    procedure AlarmPaintBoxPaint(Sender: TObject);
    procedure FreshTimer(Sender: TObject);
    procedure SwitchPaintBoxPaint(Sender: TObject);
    procedure StatusPaintBoxPaint(Sender: TObject);
    procedure pbLongInfoStatusPaint(Sender: TObject);
    procedure pbLongInfoStatusDblClick(Sender: TObject);
    procedure ClearStatusTimer(Sender: TObject);
    procedure AlarmPaintBoxClick(Sender: TObject);
    procedure SwitchPaintBoxClick(Sender: TObject);
    procedure CallProgClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  private
    DefaultMenuItemsCount: Integer;
    FTopForm: TForm;
    FScreenSizeIndex: integer;
    PrinterBusy: boolean;
    OverviewForm, ActiveAlarmsForm, ActiveSwitchsForm, LogsForm, HistGroupForm,
    BrowserForm, TrendsForm, TablesForm, ReportsForm, ReportLogsForm,
    EditSchemeForm, EditReportForm, PreviewForm: TForm;
    procedure SetTopForm(const Value: TForm);
    procedure SetScreenSizeIndex(const Value: integer);
    procedure InitPaspForms;
    procedure FinitPaspForms;
    procedure FreshView; stdcall;
    procedure UpdateTimeBar;
    procedure ShowLogByIndex(const Index: integer);
    function Authorization(const KeyWord: String): Boolean;
    procedure CheckAutor;
    procedure RealTrendDataRefresh;
    procedure AsyncNotify(var Mess: TMessage); message WM_Fresh;
    function CheckPrinter(out Status: string): boolean;
    function RunModule(const FileName, WorkDir: string): boolean;
    procedure UpdateKeyboardLayout;
    procedure CallMenuSchemesClick(Sender: TObject);
  public
    WorkSchemeName: string;
    CustomHeight: Integer;
    RealTrendList: TComponentList;
    PaspForms: record
                 Body: array[1..100] of TForm;
                 Length: integer;
               end;
    function ShowPreviewForm: TShowPreviewForm;
    procedure UpdateExtPrograms;
    procedure UpdateMenuSchemes;
    property TopForm: TForm read FTopForm write SetTopForm;
    property ScreenSizeIndex: integer read FScreenSizeIndex write SetScreenSizeIndex;
  end;

implementation

uses ComCtrls, ShowOverviewUnit, ShowRealTrendUnit, RemXUnit, EditReportUnit,
     ShowUsersUnit, ShowActiveAlarmsUnit, ShowActiveSwitchsUnit, ShowLogsUnit,
     ShowBrowserUnit, ShowTrendsUnit, ShowTablesUnit, ShowReportUnit,
     ShowReportLogUnit, ShowHistGroupUnit, TuningUnit, EditSchemeUnit,
     ShowSplashUnit, GetAutorizationUnit, DateUtils;

{$R *.dfm}

{ TPanelForm }

procedure TPanelForm.SetTopForm(const Value: TForm);
var i: integer;
begin
///  if Assigned(FTopForm) then
///    FTopForm.Free;
  FTopForm:=Value;
  if Assigned(FTopForm) then
  begin
    if FTopForm is TShowOverviewForm then
    begin
      for i:=0 to RealTrendList.Count-1 do
      with RealTrendList.Items[i] as TShowRealTrendForm do
      begin
        if RealTrendSchemeName = Self.WorkSchemeName then
          Show
        else
          Hide;
      end;
    end
    else
      for i:=0 to RealTrendList.Count-1 do
        (RealTrendList.Items[i] as TForm).Hide;
  end;
end;

procedure TPanelForm.InitPaspForms;
var
  i: integer;
  F: TFormClass;
begin
  if PaspFormClassList.Count > High(PaspForms.Body) then
    PaspForms.Length := High(PaspForms.Body)
  else
    PaspForms.Length := PaspFormClassList.Count;
  for i := 0 to PaspFormClassList.Count - 1 do
  if PaspFormClassList[i] <> nil then
  begin
    F := TFormClass(PaspFormClassList[i]);
    if i + 1 <= PaspForms.Length then
    begin
      PaspForms.Body[i+1] := F.Create(Self);
      PaspForms.Body[i+1].Align := alClient;
      PaspForms.Body[i+1].BorderStyle := bsNone;
      PaspForms.Body[i+1].Parent := ScrollBox;
      with PaspForms.Body[i+1].Font do
      begin
        Name := 'Tahoma';
        Size := 10;
      end;
    end;
  end;
end;

procedure TPanelForm.FinitPaspForms;
var
  i: integer;
begin
  for i := 0 to PaspFormClassList.Count-1 do
  if Assigned(PaspFormClassList[i]) then
  begin
    if (i <= PaspForms.Length) and Assigned(PaspForms.Body[i+1]) then
      PaspForms.Body[i+1].Release;
  end;
end;

procedure TPanelForm.FormCreate(Sender: TObject);
begin
  DefaultMenuItemsCount := 0;
  WorkSchemeName := '';
  ScreenSizeIndex := 0;
  FTopForm := nil;
  OverviewForm := nil;
  ActiveAlarmsForm := nil;
  ActiveSwitchsForm := nil;
  LogsForm := nil;
  BrowserForm := nil;
  TrendsForm := nil;
  TablesForm := nil;
  ReportsForm := nil;
  ReportLogsForm := nil;
  HistGroupForm := nil;
  EditSchemeForm := nil;
  EditReportForm := nil;
  PreviewForm := nil;
  RealTrendList := TComponentList.Create;
  InitPaspForms;
  StatusControlBar.Width := Self.Width;
  StatusPanel.Width := StatusControlBar.ClientWidth;
  UpdateExtPrograms;
  UpdateMenuSchemes;
  CustomHeight := TopScrollBox.Height+ActionMainMenuBar.Height+
                         StatusControlBar.Height;
end;

procedure TPanelForm.FormDestroy(Sender: TObject);
begin
  Fresh.Enabled := False;
  Clock.Enabled := False;
  FinitPaspForms;
  RealTrendList.Free;
end;

procedure TPanelForm.SetScreenSizeIndex(const Value: integer);
begin
  FScreenSizeIndex := Value;
  ActionMainMenuBar.Font.Size := 9;
  StatusPanel.Font.Size := 9;
  StatusPanel.Height := 19;
  UserPanel.Width := 152;
  SwitchPanel.Width := 152;
  AlarmPanel.Width := 152;
  case FScreenSizeIndex of
  0: // XGA (1024 x 768)
    begin
      PanelWidth := 1024;
      PanelHeight := 768-CustomHeight;
    end;
  1: // XGA+ (1152 x 864)
    begin
      PanelWidth := 1152;
      PanelHeight := 864-CustomHeight;
    end;
  2: // WXGA (1280 x 720)
    begin
      PanelWidth := 1280;
      PanelHeight := 720-CustomHeight;
    end;
  3: // WXGA (1280 x 768)
    begin
      PanelWidth := 1280;
      PanelHeight := 768-CustomHeight;
    end;
  4: // WXGA (1280 x 800)
    begin
      PanelWidth := 1280;
      PanelHeight := 800-CustomHeight;
    end;
  5: // WXGA (1280 x 960)
    begin
      PanelWidth := 1280;
      PanelHeight := 960-CustomHeight;
    end;
  6: // SXGA (1280 x 1024)
    begin
      PanelWidth := 1280;
      PanelHeight := 1024-CustomHeight;
    end;
  7: // SXGA (1360 x 768)
    begin
      PanelWidth := 1360;
      PanelHeight := 768-CustomHeight;
    end;
  8: // SXGA+ (1400 x 1050)
    begin
      PanelWidth := 1400;
      PanelHeight := 1050-CustomHeight;
    end;
  9: // WXGA+ (1440 x 900)
    begin
      PanelWidth := 1440;
      PanelHeight := 900-CustomHeight;
    end;
 10: // XJXGA (1540 x 940)
    begin
      PanelWidth := 1540;
      PanelHeight := 940-CustomHeight;
    end;
 11: // WXGA++ (1600 x 900)
    begin
      PanelWidth := 1600;
      PanelHeight := 900-CustomHeight;
    end;
 12: // WSXGA (1600 x 1024)
    begin
      PanelWidth := 1600;
      PanelHeight := 1024-CustomHeight;
    end;
 13: // WSXGA+ (1680 x 1050)
    begin
      PanelWidth := 1680;
      PanelHeight := 1050-CustomHeight;
    end;
 14: // UXGA (1600 x 1200)
    begin
      PanelWidth := 1600;
      PanelHeight := 1200-CustomHeight;
    end;
 15: // Full HD (1920 x 1080)
    begin
      PanelWidth := 1920;
      PanelHeight := 1080-CustomHeight;
    end;
 16: // WUXGA (1920 x 1200)
    begin
      PanelWidth := 1920;
      PanelHeight := 1200-CustomHeight;
    end;
 17: // QXGA (2048 x 1536)
    begin
      PanelWidth := 2048;
      PanelHeight := 1536-CustomHeight;
    end;
 18: // QWXGA (2048 x 1152)
    begin
      PanelWidth := 2048;
      PanelHeight := 1152-CustomHeight;
    end;
 19: // WQXGA (2560 x 1440)
    begin
      PanelWidth := 2560;
      PanelHeight := 1440-CustomHeight;
    end;
 20: // WQXGA (2560 x 1600)
    begin
      PanelWidth := 2560;
      PanelHeight := 1600-CustomHeight;
    end;
 21: // QSXGA (2560 x 2048)
    begin
      PanelWidth := 2560;
      PanelHeight := 2048-CustomHeight;
    end;
  else
    begin
      PanelWidth := 1024;
      PanelHeight := 768-CustomHeight;
    end;
  end;
end;

procedure TPanelForm.actExitExecute(Sender: TObject);
begin
  RemXForm.actExitExecute(nil);
end;

procedure TPanelForm.actOverviewExecute(Sender: TObject);
var i: integer; E: TEntity; EntityScheme: string;
begin
  E := TEntity((Sender as TAction).Tag);
  if E is TEntity then
    EntityScheme := Trim(E.LinkScheme)
  else
  begin
    if TopForm is TShowOverviewForm then
      EntityScheme := ''
    else
      EntityScheme := ExtractFileName(WorkSchemeName);
    E := nil;
  end;
  (Sender as TAction).Tag := 0;
  UpdateTimeBar;
  if not (OverviewForm is TShowOverviewForm) then
  begin
    OverviewForm := TShowOverviewForm.Create(Self);
    with OverviewForm as TShowOverviewForm do
    begin
      DefaultMonitor := dmActiveForm;
      Position := poScreenCenter;
      Panel := Self;
      Parent := ScrollBox;
      LoadSchemeFromFile(WorkSchemeName);
    end;
  end;
  if EntityScheme <> '' then
    WorkSchemeName := IncludeTrailingPathDelimiter(Caddy.CurrentSchemsPath) +
                      EntityScheme
  else
    WorkSchemeName := IncludeTrailingPathDelimiter(Caddy.CurrentSchemsPath) +
                      RemXForm.RootSchemeName;
  if Assigned(TopForm) and (TopForm = OverviewForm) then
  begin
    (OverviewForm as TShowOverviewForm).LoadSchemeFromFile(WorkSchemeName);
    for i:=0 to RealTrendList.Count-1 do
    with RealTrendList.Items[i] as TShowRealTrendForm do
    begin
      if RealTrendSchemeName = WorkSchemeName then
        Show
      else
        Hide;
    end;
  end
  else
    TopForm := OverviewForm;
  with OverviewForm as TShowOverviewForm do
  begin
    Show;
    LoadSchemeFromFile(WorkSchemeName, E);
    SetFocus;
    FreshView;
  end;
  if RemXForm.Registered then
    CaptionLabel.Caption:='������������������ ������� �������� � ����������'
  else
    CaptionLabel.Caption:='������������������ ������� �������� � ����������'+
    ' (���������������� ������)';
end;


procedure TPanelForm.actRegUserExecute(Sender: TObject);
var N: TTreeNode;
begin
  ShowUsersForm := TShowUsersForm.Create(Self);
  try
    with ShowUsersForm do
    begin
      DefaultMonitor := dmActiveForm;
      Position := poScreenCenter;
      Caption := '����������� ������������';
      EditMode := False;
      btnCancelRegistry.Visible := True;
      ToolBar.Visible := False;
    end;
    Screen.Cursor := crHourGlass;
    try
      ShowUsersForm.PrepareView;
      if RemXForm.LongUserName = '' then
      begin
        N := ShowUsersForm.tvUsers.TopItem.getNextSibling;
        N.Expand(True);
        ShowUsersForm.tvUsers.Selected := N;
      end
      else
      begin
        N := ShowUsersForm.tvUsers.TopItem;
        while N <> nil do
        begin
          if N.Text = RemXForm.LongUserName then
          begin
            N.Expand(True);
            ShowUsersForm.tvUsers.Selected := N;
            Break;
          end;
          N := N.GetNext;
        end;
      end;
    finally
      Screen.Cursor := crDefault;
    end;
    if ShowUsersForm.ShowModal = mrAbort then // ������ �����������
    begin
      RemXForm.LongUserName := '';
      Caddy.UserLevel := 0;
      UserPanel.Caption := '��� �����������';
      Caddy.AddChange('�������', '�����������', RemXForm.ShortUserName,'',
                      '������ �����������', RemXForm.ShortUserName);
      RemXForm.ShortUserName := '';
    end;
  finally
    ShowUsersForm.Free;
  end;
end;

procedure TPanelForm.UserPanelClick(Sender: TObject);
begin
  actRegUser.Execute;
end;

procedure TPanelForm.FreshView;
//var i: integer;
begin
  UpdateTimeBar;
  AlarmPaintBox.Invalidate;
  SwitchPaintBox.Invalidate;
  pbLongInfoStatus.Invalidate;
//  with Screen do for i := 0 to FormCount - 1 do
//    if Forms[i].Showing and Supports(Forms[i], IEntity) then
//      (Forms[i] as IEntity).UpdateRealTime;
  if Caddy.UserLevel = 0 then
    UserPanel.Caption:='��� �����������'
  else
    UserPanel.Caption := Caddy.ShortUserName;
end;

procedure TPanelForm.UpdateTimeBar;
var S: string;
begin
  case Caddy.NetRole of
   nrServer: S := Format('������� �%d, ������, ', [Caddy.Station]);
   nrClient: S := Format('������� �%d, ������, ', [Caddy.Station]);
  else
   S := Format('������� �%d, ', [Caddy.Station]);
  end;
  TimeLabel.Caption := S + FormatDateTime('dd/mm/yy ddd hh:nn:ss ', Now);
end;

procedure TPanelForm.actActiveAlarmsExecute(Sender: TObject);
begin
  if not (ActiveAlarmsForm is TShowActiveAlarmsForm) then
  begin
    ActiveAlarmsForm := TShowActiveAlarmsForm.Create(Self);
    (ActiveAlarmsForm as TShowActiveAlarmsForm).Panel := Self;
    ActiveAlarmsForm.Parent := ScrollBox;
    (ActiveAlarmsForm as IEntity).ConnectImageList(RemXForm.EntityTypeImageList);
    Caddy.OnAlarmLogUpdate :=
        (ActiveAlarmsForm as TShowActiveAlarmsForm).AlarmLogUpdate;
  end;
  TopForm := ActiveAlarmsForm;
  ActiveAlarmsForm.Show;
  (ActiveAlarmsForm as TShowActiveAlarmsForm).ShowMessagesCount;
  CaptionLabel.Caption:='�������� ���������� ��������� ���������';
end;

procedure TPanelForm.actActiveSwitchsExecute(Sender: TObject);
begin
  if not (ActiveSwitchsForm is TShowActiveSwitchsForm) then
  begin
    ActiveSwitchsForm := TShowActiveSwitchsForm.Create(Self);
    (ActiveSwitchsForm as TShowActiveSwitchsForm).Panel := Self;
    ActiveSwitchsForm.Parent := ScrollBox;
    (ActiveSwitchsForm as IEntity).ConnectImageList(RemXForm.EntityTypeImageList);
    Caddy.OnSwitchLogUpdate :=
      (ActiveSwitchsForm as TShowActiveSwitchsForm).SwitchLogUpdate; 
  end;
  TopForm := ActiveSwitchsForm;
  ActiveSwitchsForm.Show;
  (ActiveSwitchsForm as TShowActiveSwitchsForm).ShowMessagesCount;
  CaptionLabel.Caption:='�������� ���������� ������������';
end;

procedure TPanelForm.actAlarmLogShowExecute(Sender: TObject);
begin
  ShowLogByIndex((Sender as TComponent).Tag);
end;

procedure TPanelForm.ShowLogByIndex(const Index: integer);
var S: string;
begin
  if not (LogsForm is TShowLogsForm) then
  begin
    LogsForm := TShowLogsForm.Create(Self);
    (LogsForm as TShowLogsForm).Panel := Self;
    LogsForm.Parent := ScrollBox;
    S := 'LogView';
    if Monitor.MonitorNum > 0 then S := S + IntToStr(Monitor.MonitorNum);
    (LogsForm as TShowLogsForm).LoadConfig(S);
  end;
  TopForm := LogsForm;
  with LogsForm as TShowLogsForm do
  begin
    tcLogs.TabIndex := Index;
    tcLogsChange(tcLogs);
    Show;
    tbFresh.Click;
  end;
end;

procedure TPanelForm.actBaseEditExecute(Sender: TObject);
var LastPath: string; E: TEntity;
begin
  Update;
  E := TEntity(actBaseEdit.Tag);
  if not (BrowserForm is TShowBrowserForm) then
  begin
    BrowserForm := TShowBrowserForm.Create(Self);
    (BrowserForm as TShowBrowserForm).Panel := Self;
    BrowserForm.Parent := ScrollBox;
    (BrowserForm as IEntity).ConnectImageList(RemXForm.EntityTypeImageList);
  end;
  TopForm := BrowserForm;
  with BrowserForm as TShowBrowserForm do
    if FirstShow then
    begin
      FirstShow:=False;
      LastPath:=GetTreePos;
      Show;
      Update;
      UpdateBaseView;
      RestoreTreePos(LastPath);
    end
    else
      Show;
  if E is TEntity then (BrowserForm as TShowBrowserForm).RestoreEntityPos(E);
  CaptionLabel.Caption:='�������� ���� ������';
  actBaseEdit.Tag:=0;
end;

procedure TPanelForm.actBaseEditUpdate(Sender: TObject);
begin
  actBaseEdit.Enabled := (Caddy.UserLevel > 4);
end;

procedure TPanelForm.actTrendsExecute(Sender: TObject);
var S: string;
begin
  if not (TrendsForm is TShowTrendsForm) then
  begin
    TrendsForm := TShowTrendsForm.Create(Self);
    (TrendsForm as TShowTrendsForm).Panel := Self;
    TrendsForm.Parent := ScrollBox;
    (TrendsForm as IEntity).ConnectImageList(RemXForm.EntityTypeImageList);
    S := 'TrendView';
    if Monitor.MonitorNum > 0 then S := S + IntToStr(Monitor.MonitorNum);
    (TrendsForm as TShowTrendsForm).LoadConfig(S);
  end;
  if TopForm <> TrendsForm then TopForm := TrendsForm;
  TrendsForm.Show;
  TrendsForm.Update;
  (TrendsForm as TShowTrendsForm).ReloadTrends;
  CaptionLabel.Caption:='�������� ��������';
end;

procedure TPanelForm.actTablesExecute(Sender: TObject);
var S: string;
begin
  if not (TablesForm is TShowTablesForm) then
  begin
    TablesForm := TShowTablesForm.Create(Self);
    (TablesForm as TShowTablesForm).Panel := Self;
    TablesForm.Parent := ScrollBox;
    S := 'TableView';
    if Monitor.MonitorNum > 0 then S := S + IntToStr(Monitor.MonitorNum);
    (TablesForm as TShowTablesForm).LoadConfig(S);
  end;
  TopForm := TablesForm;
  TablesForm.Show;
  (TablesForm as TShowTablesForm).AfterShow;
  CaptionLabel.Caption := '�������� ������';
end;

procedure TPanelForm.actReportsExecute(Sender: TObject);
begin
  if not (ReportsForm is TShowReportsForm) then
  begin
    ReportsForm := TShowReportsForm.Create(Self);
    (ReportsForm as TShowReportsForm).Panel := Self;
    ReportsForm.Parent := ScrollBox;
  end;
  ReportsForm.Show;
  if TopForm <> ReportsForm then TopForm := ReportsForm;
  CaptionLabel.Caption := '�������� �������';
end;

procedure TPanelForm.actReportLogsExecute(Sender: TObject);
var S: string;
begin
  if not (ReportLogsForm is TShowReportLogsForm) then
  begin
    ReportLogsForm := TShowReportLogsForm.Create(Self);
    (ReportLogsForm as TShowReportLogsForm).Panel := Self;
    ReportLogsForm.Parent := ScrollBox;
    S := 'ReportLogView';
    if Monitor.MonitorNum > 0 then S := S + IntToStr(Monitor.MonitorNum);
    with ReportLogsForm as TShowReportLogsForm do
    begin
      LoadConfig(S);
      Show;
      tbFresh.Click;
    end;
  end
  else
    ReportLogsForm.Show;
  if TopForm <> ReportLogsForm then TopForm := ReportLogsForm;
  CaptionLabel.Caption := '����� �������';
end;

procedure TPanelForm.actHistGroupsExecute(Sender: TObject);
begin
  if not (HistGroupForm is TShowHistGroupForm) then
  begin
    HistGroupForm := TShowHistGroupForm.Create(Self);
    (HistGroupForm as TShowHistGroupForm).Panel := Self;
    HistGroupForm.Parent := ScrollBox;
    (HistGroupForm as IEntity).ConnectImageList(RemXForm.EntityTypeImageList);
  end;
    TopForm := HistGroupForm;
  with HistGroupForm as TShowHistGroupForm do
  begin
    Show;
    UpdateHistGroups;
  end;
  CaptionLabel.Caption := '������������ ������������ ����� ����������';
end;

procedure TPanelForm.actHistGroupsUpdate(Sender: TObject);
begin
  actHistGroups.Enabled := (Caddy.UserLevel > 4);
end;

procedure TPanelForm.actTuningExecute(Sender: TObject);
begin
  SystemTuning(Self);
end;

procedure TPanelForm.actTuningUpdate(Sender: TObject);
begin
  actTuning.Enabled := (Caddy.UserLevel > 4);
end;

procedure TPanelForm.actSchemeEditExecute(Sender: TObject);
begin
  if not (EditSchemeForm is TEditSchemeForm) then
  begin
    EditSchemeForm := TEditSchemeForm.Create(Self);
    (EditSchemeForm as TEditSchemeForm).Panel := Self;
    EditSchemeForm.Parent := ScrollBox;
  end;
  with EditSchemeForm as TEditSchemeForm do
  if Assigned(TopForm) and (TopForm = OverviewForm) and not HasChanged then
    LoadSchemeFromFile(WorkSchemeName);
  TopForm := EditSchemeForm;
  SetCurrentDirectory(PChar(Caddy.CurrentSchemsPath));
  EditSchemeForm.Show;
  CaptionLabel.Caption := '�������� ���������';
end;

procedure TPanelForm.actSchemeEditUpdate(Sender: TObject);
begin
  actSchemeEdit.Enabled := (Caddy.UserLevel > 4);
end;

procedure TPanelForm.actReportEditExecute(Sender: TObject);
begin
  if not (EditReportForm is TEditReportForm) then
  begin
    EditReportForm := TEditReportForm.Create(Self);
    (EditReportForm as TEditReportForm).Panel := Self;
    EditReportForm.Parent := ScrollBox;
  end;
  TopForm := EditReportForm;
  with EditReportForm as TEditReportForm do
  begin
    CurReport := frReportEditor;
    frReportEditor.Preview := nil;
    SetCurrentDirectory(PChar(Caddy.CurrentReportsPath));
    Show;
  end;
  CaptionLabel.Caption := '�������� �������';
end;

procedure TPanelForm.actReportEditUpdate(Sender: TObject);
begin
  actReportEdit.Enabled := (Caddy.UserLevel > 4);
end;

procedure TPanelForm.actUsersEditorExecute(Sender: TObject);
begin
  with TShowUsersForm.Create(Self) do
  try
    DefaultMonitor := dmActiveForm;
    Position := poScreenCenter;
    Screen.Cursor := crHourGlass;
    try
      PrepareView;
    finally
      Screen.Cursor := crDefault;
    end;
    ShowModal;
  finally
    Release;
  end;
end;

procedure TPanelForm.actUsersEditorUpdate(Sender: TObject);
begin
  actUsersEditor.Enabled := (Caddy.UserLevel > 4);
end;

procedure TPanelForm.actAboutExecute(Sender: TObject);
var KeyWord: string;
begin
  with TShowSplashForm.Create(Self) do
  try
    DefaultMonitor := dmActiveForm;
    Position := poScreenCenter;
    BorderStyle := bsDialog;
    CloseButton.Visible := True;
    KeyWord := Config.ReadString('UserInfo','Key','');
    if Authorization(KeyWord) then
      Caption := '�������� �����: ' + Config.ReadString('UserInfo','Name','');
    ShowModal;
  finally
    Release;
  end;
end;

function TPanelForm.Authorization(const KeyWord: String): Boolean;
var SerialNumber: DWord; MCL,FCF: Cardinal;
    Mask: Byte; i,Sum: integer; W: RConv; S,User: String;
begin
  if GetVolumeInformation('C:\',nil,0,@SerialNumber,MCL,FCF,nil,0) then
  begin
    User := Config.ReadString('UserInfo','Name','');
    if Length(User) > 0 then
    begin
      S := UpperCase(User);
      Sum := 0;
      for i := 1 to Length(S) do Inc(Sum, Ord(S[i]));
      while Sum >= 256 do Sum:=Sum mod 256 + Sum div 256;
      Mask := Sum and $00FF;
      W.BIG := SerialNumber;
      for i := 0 to 3 do W.Small[i] := W.Small[i] xor Mask;
      W.BIG := (W.BIG xor $12369156) or $11236915;
      if Format('%x', [W.BIG]) = UpperCase(KeyWord) then
          Result := True
      else
        Result := False;
    end
    else
      Result := False;
  end
  else
    Result:=False;
end;

procedure TPanelForm.actRegProgramExecute(Sender: TObject);
begin
  GetAutorizationForm:=TGetAutorizationForm.Create(Self);
  with GetAutorizationForm do
  try
    DefaultMonitor := dmActiveForm;
    Position := poScreenCenter;
    if ShowModal = mrOk then
    begin
      if Length(leAutorization.Text) > 0 then
        Config.WriteString('UserInfo', 'Key', leAutorization.Text);
      ConfigUpdateFile(Config);
      CheckAutor;
      if RemXForm.Registered then
      begin
        RemXForm.ShowInfo('��������� ������ �������!');
        CaptionLabel.Caption := '����������������� ������� �������� � ����������';
        Update;
        Close;
      end
      else
        RemXForm.ShowError('�������� ��� ��������� ��������!');
    end;
  finally
    Release;
  end;
end;

procedure TPanelForm.actRegProgramUpdate(Sender: TObject);
begin
  actRegProgram.Enabled := (Caddy.UserLevel > 4);
end;

procedure TPanelForm.CheckAutor;
var KeyWord: string;
begin
  KeyWord := Config.ReadString('UserInfo', 'Key', '');
  RemXForm.Registered := Authorization(KeyWord);
end;

procedure TPanelForm.acPreviewExecute(Sender: TObject);
begin
  TopForm := ShowPreviewForm;
  CaptionLabel.Caption := '��������������� ��������';
end;

procedure TPanelForm.RealTrendDataRefresh;
var i: integer;
begin
//=== ��������� ������ � ������ �������� ������� ��������� ===
  for i:=0 to RealTrendList.Count-1 do
    PostMessage((RealTrendList.Items[i] as TForm).Handle,WM_RealTrend,0,0);
end;

procedure TPanelForm.ClockTimer(Sender: TObject);
begin
  if (SecondOfTheHour(Now) mod 3) = 0 then
    RealTrendDataRefresh; // ���������� ������� ��������� �������
end;

procedure TPanelForm.AlarmPaintBoxPaint(Sender: TObject);
var Item: TActiveAlarmLogItem; sName: string;
    ShowIndex: integer; R: TRect;
begin
  with Caddy.ActiveAlarmLog do
  if Count > 0 then
    with AlarmPaintBox.Canvas do
    begin
      Font:=AlarmPanel.Font;
      Item:=Items[0] as TActiveAlarmLogItem;
      sName:=Item.Position+'.'+AAlarmText[Item.Kind];
      Brush.Color:=ABrushColor[Item.Kind,
                              (Item.Kind in Item.AlarmStatus),
                              (Item.Kind in Item.ConfirmStatus),
                               Caddy.Blink];
      Font.Color:=AFontColor[Item.Kind,
                            (Item.Kind in Item.AlarmStatus),
                            (Item.Kind in Item.ConfirmStatus),
                             Caddy.Blink];
      if (Item.Kind in Item.AlarmStatus) and
         (Item.Kind in Item.ConfirmStatus) then
        ShowIndex:=0
      else
        if Caddy.Blink then ShowIndex:=0 else ShowIndex:=1;
      case Brush.Color of
        clBlack: Brush.Color:=AlarmPanel.Color;
      end;
      case Font.Color of
        clGray: begin Font.Color:=AlarmPanel.Font.Color; ShowIndex:=1; end;
      end;
      R:=Rect(0,0,AlarmPaintBox.Width,AlarmPaintBox.Height);
      R.Left:=R.Left+18;
      FillRect(R);
      TextOut(R.Left+1,R.Top+1,sName);
      StatusImageList.Draw(AlarmPaintBox.Canvas,R.Left-18,R.Top,ShowIndex);
    end;
end;

procedure TPanelForm.FreshTimer(Sender: TObject);
begin
  Fresh.Enabled:=False;
  try
    UpdateKeyboardLayout;
    PostMessage(Handle,WM_Fresh,0,0);
  finally
    Fresh.Enabled:=True;
  end;
end;

procedure TPanelForm.AsyncNotify(var Mess: TMessage);
begin
  AlarmPaintBox.Invalidate;
  SwitchPaintBox.Invalidate;
  pbLongInfoStatus.Invalidate;
end;

procedure TPanelForm.SwitchPaintBoxPaint(Sender: TObject);
var Item: TActiveSwitchLogItem; sName: string;
    ShowIndex: integer; R: TRect;
begin
  with Caddy.ActiveSwitchLog do
  if Count > 0 then
    with SwitchPaintBox.Canvas do
    begin
      Font:=SwitchPanel.Font;
      Item:=Items[0] as TActiveSwitchLogItem;
      sName:=Item.Position+'.PV';
      Brush.Color:=SwitchPanel.Color;
      Font.Color:=SwitchPanel.Font.Color;
      case Item.Kind of
       asON: ShowIndex:=2;
       asOFF: ShowIndex:=3;
      else
        ShowIndex:=2;
      end;
      R:=Rect(0,0,SwitchPaintBox.Width,SwitchPaintBox.Height);
      R.Left:=R.Left+18;
      FillRect(R);
      TextOut(R.Left+1,R.Top+1,sName);
      StatusImageList.Draw(SwitchPaintBox.Canvas,R.Left-18,R.Top,ShowIndex);
    end;
end;

procedure TPanelForm.StatusPaintBoxPaint(Sender: TObject);
var R: TRect;
begin
  with StatusPaintBox.Canvas do
  begin
    Font:=StatusBar.Font;
    Brush.Color:=StatusBar.Color;
    R:=Rect(0,0,StatusPaintBox.Width,StatusPaintBox.Height);
    FillRect(R);
    TextOut(R.Left+3,R.Top+1,StatusBar.Caption);
  end;
end;

function PrinterStatus(PrinterName: string): string;
const
  PrnStat: array[0..24] of Integer = (
  PRINTER_STATUS_PAUSED,
  PRINTER_STATUS_ERROR,
  PRINTER_STATUS_PENDING_DELETION,
  PRINTER_STATUS_PAPER_JAM,
  PRINTER_STATUS_PAPER_OUT,
  PRINTER_STATUS_MANUAL_FEED,
  PRINTER_STATUS_PAPER_PROBLEM,
  PRINTER_STATUS_OFFLINE,
  PRINTER_STATUS_IO_ACTIVE,
  PRINTER_STATUS_BUSY,
  PRINTER_STATUS_PRINTING,
  PRINTER_STATUS_OUTPUT_BIN_FULL,
  PRINTER_STATUS_NOT_AVAILABLE,
  PRINTER_STATUS_WAITING,
  PRINTER_STATUS_PROCESSING,
  PRINTER_STATUS_INITIALIZING,
  PRINTER_STATUS_WARMING_UP,
  PRINTER_STATUS_TONER_LOW,
  PRINTER_STATUS_NO_TONER,
  PRINTER_STATUS_PAGE_PUNT,
  PRINTER_STATUS_USER_INTERVENTION,
  PRINTER_STATUS_OUT_OF_MEMORY,
  PRINTER_STATUS_DOOR_OPEN,
  PRINTER_STATUS_SERVER_UNKNOWN,
  PRINTER_STATUS_POWER_SAVE
  );
  PrnStatDesc: array[0..24] of string = (
  '�������������',
  '������',
  '��������...',
  '��� ������ ������',
  '��� ������',
  '������ ������',
  '��������� ������',
  '���������',
  '�������� ������',
  '�����',
  '��������',
  '����� �����',
  '�� ��������',
  '��������',
  '���������',
  '�������������',
  'WARMING UP',
  '���� ������',
  '��� ������',
  'PAGE PUNT',
  '��������� �������������',
  '��� ��������� ������',
  '������ �� �������',
  '������ ����������',
  '����������������'
  );
var Flags,Count,NumInfo: DWORD; Buffer,PrinterInfo: PChar;
    i,j: Integer;
begin
  Result:='';
  if Win32Platform = VER_PLATFORM_WIN32_NT then
    Flags := PRINTER_ENUM_CONNECTIONS or PRINTER_ENUM_LOCAL
  else
    Flags := PRINTER_ENUM_LOCAL;
  Count:=0;
  EnumPrinters(Flags,nil,2,nil,0,Count,NumInfo);
  if Count > 0 then
  begin
    GetMem(Buffer,Count);
    try
      if not EnumPrinters(Flags,nil,2,PByte(Buffer),Count,Count,NumInfo) then
        Exit;
      PrinterInfo:=Buffer;
      for i:=0 to NumInfo-1 do
      begin
        with PPrinterInfo2(PrinterInfo)^ do
        if pPrinterName = PrinterName then
        begin
          for j:=0 to 24 do
            if (Status and PrnStat[j]) > 0 then
              Result:=Result+' - '+PrnStatDesc[j];
          Break;
        end;
        Inc(PrinterInfo, sizeof(TPrinterInfo2));
      end;
    finally
      FreeMem(Buffer,Count);
    end;
  end;
end;

procedure ClearJobs(PrinterName: string);
var HPrinter: THandle;
    J, jpcbNeeded, jpcReturned: DWORD;
    JobInfo, TmpJobInfo: PJobInfo3;
begin
  if OpenPrinter(PChar(PrinterName),HPrinter,nil) then
  begin
    EnumJobs(hPrinter, 0, 100, 1, nil, 0, jpcbNeeded, jpcReturned);
    if GetLastError in [NO_ERROR, ERROR_INSUFFICIENT_BUFFER] then
    begin
      GetMem(JobInfo, jpcbNeeded);
      try
        if EnumJobs(hPrinter, 0, 100, 3, JobInfo,
          jpcbNeeded, jpcbNeeded, jpcReturned) then
        begin
          TmpJobInfo := JobInfo;
          for J := 0 to jpcReturned - 1 do
          begin
            if not SetJob(hPrinter, TmpJobInfo^.JobId, 0,
              nil, JOB_CONTROL_DELETE) then RaiseLastOSError;
            Inc(TmpJobInfo);
          end;
        end
        else
          RaiseLastOSError;
      finally
        FreeMem(JobInfo);
      end;
    end
    else
      RaiseLastOSError;
    ClosePrinter(HPrinter);
  end;
end;

function JobStatus(PrinterName: string; var JobsExists: boolean): string;
const JobStat: array[0..7] of Integer = (
       JOB_STATUS_DELETING,
       JOB_STATUS_ERROR,
       JOB_STATUS_OFFLINE,
       JOB_STATUS_PAPEROUT,
       JOB_STATUS_PAUSED,
       JOB_STATUS_PRINTED,
       JOB_STATUS_PRINTING,
       JOB_STATUS_SPOOLING);
     JobStatDesc: array[0..7] of String = (
       '��������',
       '������',
       '���������',
       '��� ������',
       '�������������',
       '���������',
       '���� ������',
       '�����������'
        );
var i,j: Integer; HPrinter: THandle; JobBuffer,JobInfo: PChar;
    JobCount,NumJob: DWORD; S: string;
begin
  Result:='';
  JobsExists:=False;
  if OpenPrinter(PChar(PrinterName),HPrinter,nil) then
  begin
    JobCount:=0;
    EnumJobs(HPrinter,0,1,1,nil,0,JobCount,NumJob);
    if JobCount > 0 then
    begin
      GetMem(JobBuffer,JobCount);
      try
        if EnumJobs(HPrinter,0,1,1,PByte(JobBuffer),JobCount,JobCount,NumJob) then
        begin
          JobInfo:=JobBuffer;
          for i:=0 to NumJob-1 do
          begin
            with PJobInfo1(JobInfo)^ do
            begin
              S:='';
              for j:=0 to 7 do
                if (Status and JobStat[j]) > 0 then S:=S+' - '+JobStatDesc[j];
              Result:='"'+pDocument+'"'+S;
              JobsExists:=True;
              Break;
            end;
            Inc(JobInfo,sizeof(TJobInfo1));
          end;
        end;
      finally
        FreeMem(JobBuffer,JobCount);
      end;
    end;
    ClosePrinter(HPrinter);
  end;
end;

function TPanelForm.CheckPrinter(out Status: string): boolean;
var DefaultName,S: string; JobExist: boolean;
begin
  Printer.Refresh;
  if Printer.Printers.Count = 0 then
  begin
    Status:='��� ������������� ��������� � �������.';
    Result:=False;
    Exit;
  end;
  try
    DefaultName:=Printer.Printers[Printer.PrinterIndex];
    S:='�������: '+DefaultName+PrinterStatus(DefaultName)+' '+
                  JobStatus(DefaultName,JobExist);
    if JobExist then Status:=S;
    Result:=not JobExist;
  except
    Status:='�� ������ ������� �� ���������.';
    Result:=False;
    Exit;
  end;
end;

procedure TPanelForm.pbLongInfoStatusPaint(Sender: TObject);
begin
  if PrinterBusy then
  with Sender as TPaintBox do
    SystemImageList.Draw(Canvas,2,2,20);
end;

procedure TPanelForm.pbLongInfoStatusDblClick(Sender: TObject);
var sName: string;
begin
//  Printer.PrinterIndex:=-1;
  try
    sName:=Printer.Printers[Printer.PrinterIndex];
    if PrinterBusy and
       (RemXForm.ShowQuestion('�� ������������� ������ ������� ��� ��������� ��� "'+
        sName+'"?') = mrOk) then
    begin
      ClearJobs(sName);
    end;
  except
    RemXForm.ShowMessage:='�� ������ ������� �� ���������.';
  end;
end;

procedure TPanelForm.ClearStatusTimer(Sender: TObject);
var PrinterStatus: string;
begin
  RemXForm.ShowMessage:='��� ���������';
  if (Caddy.NetRole = nrClient) and not Caddy.NetClientConnected then
    Caddy.NetClientConnected:=True;
//----------------------------------------------
  PrinterBusy:=not CheckPrinter(PrinterStatus);
  pbLongInfoStatus.Hint:=PrinterStatus;
end;

procedure TPanelForm.AlarmPaintBoxClick(Sender: TObject);
begin
  actActiveAlarms.Execute;
end;

procedure TPanelForm.SwitchPaintBoxClick(Sender: TObject);
begin
  actActiveSwitchs.Execute;
end;


function TPanelForm.ShowPreviewForm: TShowPreviewForm;
begin
  if not (PreviewForm is TShowPreviewForm) then
  begin
    PreviewForm := TShowPreviewForm.Create(Self);
    (PreviewForm as TShowPreviewForm).Panel := Self;
    PreviewForm.Parent := ScrollBox;
  end;
  Result := PreviewForm as TShowPreviewForm;
end;

procedure TPanelForm.UpdateMenuSchemes;
var tv: TTreeView; SS: TMemoryStream; N: TTreeNode; i,j: Integer;
  sl: TStringList; Act: TAction; Item: TActionClientItem;
begin
  tv:=TTreeView.Create(nil);
  try
    tv.Parent:=self;
    tv.SendToBack;
    SS:=TMemoryStream.Create;
    sl:=TStringList.Create;
    try
      Config.ReadBinaryStream('MenuSchemes','SchemeTree',SS);
      SS.Position:=0;
      tv.LoadFromStream(SS);
      if DefaultMenuItemsCount = 0 then
        DefaultMenuItemsCount := ActionManager.ActionBars[0].Items.Count;
      for i:=MenuSchemesActionList.ActionCount-1 downto 0 do
         MenuSchemesActionList.Actions[i].Free;
      for i := ActionManager.ActionBars[0].Items.Count - 1 downto
          DefaultMenuItemsCount do
          ActionManager.ActionBars[0].Items.Delete(i);

      j := -1;
      for i := 0 to tv.Items.Count - 1 do
      begin
        N := tv.Items[i];
        Act:=TAction.Create(nil);
        Act.ActionList:=MenuSchemesActionList;
        if N.Level = 0 then
        begin
          Item:=ActionManager.ActionBars[0].Items.Add;
          j := Item.Index;
          Item.Action:=Act;
          Act.Caption:=N.Text;
          Act.Tag:=-1;
          Act.OnExecute:=CallMenuSchemesClick;
        end
        else if N.Level = 1 then
        begin
          Item := ActionManager.ActionBars[0].Items[j].Items.Add;
          Item.Action:=Act;
          sl.CommaText := N.Text;
          if sl.Count > 0 then
          begin
            Act.Caption:=sl[0];
            Act.Tag:=N.AbsoluteIndex;
            Act.OnExecute:=CallMenuSchemesClick;
          end;
        end;
      end;
    finally
      sl.Free;
      SS.Free;
    end;
  finally
    tv.Free;
  end;
end;

procedure TPanelForm.CallMenuSchemesClick(Sender: TObject);
var M: TAction; tv: TTreeView; SS: TMemoryStream; sl: TStringList;
    i,j: Integer; N: TTreeNode;
begin
  M:=Sender as TAction;
  if M.Tag >= 0 then
  begin
    tv:=TTreeView.Create(nil);
    try
      tv.Width:=1;
      tv.Height:=1;
      tv.Parent:=self;
      tv.SendToBack;
      SS:=TMemoryStream.Create;
      sl:=TStringList.Create;
      try
        Config.ReadBinaryStream('MenuSchemes','SchemeTree',SS);
        SS.Position:=0;
        tv.LoadFromStream(SS);
        for i := 0 to tv.Items.Count - 1 do
        begin
          N := tv.Items[i];
          if (N.Level = 1) and (N.AbsoluteIndex = M.Tag) then
          begin
            sl.CommaText := N.Text;
            if sl.Count = 2 then
            begin
              if Trim(sl[1]) <> '' then
              with RemXForm do
              begin
                WorkSchemeName:=
                   IncludeTrailingPathDelimiter(Caddy.CurrentSchemsPath)+sl[1];
                if Assigned(TopForm) and (TopForm = OverviewForm) then
                begin
                  (OverviewForm as TShowOverviewForm).LoadSchemeFromFile(WorkSchemeName);
                  for j:=0 to RealTrendList.Count-1 do
                  with RealTrendList.Items[j] as TShowRealTrendForm do
                  begin
                    if RealTrendSchemeName = WorkSchemeName then
                      Show
                    else
                      Hide;
                  end;
                end
                else
                  TopForm := OverviewForm;
                with OverviewForm as TShowOverviewForm do
                begin
                  Show;
                  LoadSchemeFromFile(WorkSchemeName, nil);
                  SetFocus;
                  FreshView;
                end;
              end;
            end;
          end;
        end;
       finally
        sl.Free;
        SS.Free;
      end;
    finally
      tv.Free;
    end;
  end;
end;

procedure TPanelForm.UpdateExtPrograms;
var tv: TTreeView; SS: TMemoryStream; N: TTreeNode; i: integer;
    Act: TAction; Item: TActionClientItem;
begin
  for i:=ExternalActionList.ActionCount-1 downto 0 do
     ExternalActionList.Actions[i].Free;
  ActionManager.ActionBars[0].Items[0].Items[2].Items.Clear;
  tv:=TTreeView.Create(nil);
  try
    tv.Parent:=self;
    tv.SendToBack;
    SS:=TMemoryStream.Create;
    try
      Config.ReadBinaryStream('OtherPrograms','ExternalModules',SS);
      SS.Position:=0;
      tv.LoadFromStream(SS);
      N:=tv.Items.GetFirstNode;
      i:=0;
      while N <> nil do
      begin
        Act:=TAction.Create(Self);
        Act.ActionList:=ExternalActionList;
        Act.Caption:=N.Text;
        Act.Tag:=i;
        Act.OnExecute:=CallProgClick;
        Item:=ActionManager.ActionBars[0].Items[0].Items[2].Items.Add as TActionClientItem;
        Item.Action:=Act;
        N:=N.getNextSibling;
        Inc(i);
      end;
    finally
      SS.Free;
    end;
  finally
    tv.Free;
  end;
end;

procedure TPanelForm.CallProgClick(Sender: TObject);
var i: integer; M: TAction; tv: TTreeView; SS: TMemoryStream;
    N,NN: TTreeNode; S,ProgName,WorkPath,RightInfo: string;
    lpMsgBuf: PAnsiChar;
begin
  M:=Sender as TAction;
  tv:=TTreeView.Create(nil);
  try
    tv.Width:=1;
    tv.Height:=1;
    tv.Parent:=self;
    tv.SendToBack;
    SS:=TMemoryStream.Create;
    try
      Config.ReadBinaryStream('OtherPrograms','ExternalModules',SS);
      SS.Position:=0;
      tv.LoadFromStream(SS);
      N:=tv.Items.GetFirstNode;
      i:=0;
      while N <> nil do
      begin
        if i = M.Tag then
        begin
          NN:=N.getFirstChild;
          S:=NN.Text;
          Delete(S,1,Pos(': ',S)+1);
          ProgName:=S;
          NN:=NN.GetNext;
          S:=NN.Text;
          Delete(S,1,Pos(': ',S)+1);
          WorkPath:=S;
          NN:=NN.GetNext;
          S:=NN.Text;
          Delete(S,1,Pos(': ',S)+1);
          RightInfo:=S;
          if CategoryIndex(RightInfo) <= Caddy.UserLevel then
          begin
            if FileExists(ProgName) then
            begin
              if not RunModule(ProgName,WorkPath) then
              begin
                GetMem(lpMsgBuf,4096);
                try
                  FormatMessage(
                    FORMAT_MESSAGE_ALLOCATE_BUFFER or FORMAT_MESSAGE_FROM_SYSTEM,
                    NIL,
                    GetLastError(),
                    0,
                    lpMsgBuf,
                    0,
                    NIL);
                  RemXForm.ShowError(String(lpMsgBuf));
                finally
                  FreeMem(lpMsgBuf,4096);
                end;
              end;
            end
            else
              RemXForm.ShowError('������������� ���� �� ������ �� ���������� ����!');
          end
          else
            RemXForm.ShowError('�� ���������� ���������� ��� ������� ���� ���������!');
          Break;
        end;
        N:=N.getNextSibling;
        Inc(i);
      end;
    finally
      SS.Free;
    end;
  finally
    tv.Free;
  end;
end;

function TPanelForm.RunModule(const FileName, WorkDir: string): boolean;
var lpStartupInfo: STARTUPINFO;
    lpProcessInformation: PROCESS_INFORMATION;
begin
  if DirectoryExists(WorkDir) then ChDir(WorkDir);
  lpStartupInfo.lpReserved:=nil;
  lpStartupInfo.lpDesktop:=nil;
  lpStartupInfo.lpTitle:=nil;
  lpStartupInfo.dwFlags:=STARTF_USESTDHANDLES;
  lpStartupInfo.wShowWindow:=0;
  lpStartupInfo.cbReserved2:=0;
  lpStartupInfo.lpReserved2:=nil;
  lpStartupInfo.cb:=SizeOf(lpStartupInfo);
  Result:=CreateProcess(
    nil,                      // pointer to name of executable module
    PChar(FileName),          // pointer to command line string
    nil,                      // pointer to process security attributes
    nil,                      // pointer to thread security attributes
    True,                     // handle inheritance flag
    NORMAL_PRIORITY_CLASS,    // creation flags
    nil,                      // pointer to new environment block
    nil,                      // pointer to current directory name
    lpStartupInfo,            // pointer to STARTUPINFO
    lpProcessInformation      // pointer to PROCESS_INFORMATION
  );
end;

procedure TPanelForm.UpdateKeyboardLayout;
var LN: PChar;
begin
  GetMem(LN, KL_NAMELENGTH);
  try
    if GetKeyboardLayoutName(LN) then
    begin
      if string(LN) = '00000409' then
        LangPanel.Caption := 'EN'
      else
      if string(LN) = '00000419' then
        LangPanel.Caption := 'RU';
    end;
  finally
    FreeMem(LN, KL_NAMELENGTH);
  end;
end;

procedure TPanelForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
(*
  CanClose := False;
  if Assigned(EditSchemeForm) and
    (EditSchemeForm as TEditSchemeForm).HasChanged and
    (RemXForm.ShowQuestion('�������� ��������� �������� '+
                  '������������� �����. ��������?') = mrOk) then
   (EditSchemeForm as TEditSchemeForm).SchemeSave.Execute;
  if Assigned(EditReportForm) and
    (EditReportForm as TEditReportForm).frReportEditor.Modified and
    (RemXForm.ShowQuestion('�������� ������� �������� '+
                  '������������� �����. ��������?') = mrOk) then
  begin
    with (EditReportForm as TEditReportForm).frReportEditor do
    if FileName <> 'Untitled' then
    begin
      SetCurrentDirectory(PChar(Caddy.CurrentReportsPath));
      SaveToFile(FileName);
    end;
  end;
*)  
  CanClose := True;
end;

procedure TPanelForm.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if FTopForm = OverviewForm then
  begin
    if ssAlt in Shift then
      TShowOverviewForm(OverviewForm).FormMouseWheel(Sender,[ssAlt],WheelDelta,
                                                   MousePos,Handled)
    else
      TShowOverviewForm(OverviewForm).FormMouseWheel(Sender,Shift,WheelDelta,
                                                   MousePos,Handled);
  end else
  if FTopForm = EditSchemeForm then
  begin
    if ssAlt in Shift then
      TEditSchemeForm(EditSchemeForm).FormMouseWheel(Sender,[ssAlt],WheelDelta,
                                                   MousePos,Handled)
    else
      TEditSchemeForm(EditSchemeForm).FormMouseWheel(Sender,Shift,WheelDelta,
                                                   MousePos,Handled);
  end;
  Handled:=False;
end;

end.
