unit ShowLogsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls,Buttons, ToolWin, ActnList, ImgList,
  Printers, Menus, StdCtrls, Grids, AppEvnts, EntityUnit, FR_Class, FR_DSet,
  PanelFormUnit;

type
  TShowLogsForm = class(TForm)
    LogsActionList: TActionList;
    actPrint: TAction;
    actPreview: TAction;
    FindDialog: TFindDialog;
    tcLogs: TTabControl;
    ToolBar: TToolBar;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    tbLessTime: TToolButton;
    tbTimeSelect: TToolButton;
    tbMoreTime: TToolButton;
    ScrollingPanel: TPanel;
    cbScrolling: TCheckBox;
    LogsImageList: TImageList;
    ToolButton12: TToolButton;
    TimePopupMenu: TPopupMenu;
    DrawGrid: TDrawGrid;
    tbFresh: TToolButton;
    frLogReport: TfrReport;
    frUserLogDataset: TfrUserDataset;
    ApplicationEvents: TApplicationEvents;
    btn1: TToolButton;
    btnExportCSV: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure tbTime0Click(Sender: TObject);
    procedure actPreviewExecute(Sender: TObject);
    procedure actPrintExecute(Sender: TObject);
    procedure frLogReportBeginPage(pgNo: Integer);
    procedure FindDialogClose(Sender: TObject);
    procedure tcLogsChange(Sender: TObject);
    procedure TimePopupMenuPopup(Sender: TObject);
    procedure cbScrollingClick(Sender: TObject);
    procedure tbFilterClick(Sender: TObject);
    procedure tbLessTimeClick(Sender: TObject);
    procedure tbMoreTimeClick(Sender: TObject);
    procedure DrawGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure tbFreshClick(Sender: TObject);
    procedure frLogReportGetValue(const ParName: String;
      var ParValue: Variant);
    procedure tcLogsChanging(Sender: TObject; var AllowChange: Boolean);
    procedure DrawGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DrawGridMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ShowThreadMessage(Sender: TObject; Mess: string);
    procedure ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
    procedure actPrintUpdate(Sender: TObject);
    procedure actPreviewUpdate(Sender: TObject);
    procedure btnExportCSVClick(Sender: TObject);
  private
    Filtered: boolean;
    StartTime,ShiftTime: TDateTime;
    NumPages: integer;
    FirstSnap,LastSnap: TDateTime;
    CurrentTimeIndex: integer;
    FindDialogVisible: boolean;
    LastRow: array[TLogType] of integer;
    LogLoading: boolean;
    PathToSave: string;
    FPanel: TPanelForm;
    function GetShiftTime(Index: integer): TDateTime;
    procedure SaveConfig(Path: string);
    procedure LogLoaded(Sender: TObject);
    procedure ResumeCurrentLog(D1,D2: TDateTime);
  public
    AlarmData:  TCashAlarmLogArray;
    SwitchData: TCashSwitchLogArray;
    ChangeData: TCashChangeLogArray;
    SystemData: TCashSystemLogArray;
    procedure LoadConfig(Path: string);
    procedure UpdateTimeRange;
    procedure ReloadLog;
    procedure UpdateLog;
    property Panel: TPanelForm read FPanel write FPanel;
  end;

  TGetSingleSystemLog = class(TThread)
  private
    Owner: TShowLogsForm;
    SystemItem: TCashSystemLogItem;
    FMessage,CurrentLogsPath: string;
    D1,D2: TDateTime;
    SystemCashList: TCashSystemLogArray;
    procedure ShowMessage;
    procedure AddIntoLog;
  protected
    procedure Execute; override;
  public
    constructor Create(AOwner: TShowLogsForm;
                       ACurrentLogsPath: string;
                       AD1,AD2: TDateTime);
  end;

  TGetSingleChangeLog = class(TThread)
  private
    Owner: TShowLogsForm;
    ChangeItem: TCashChangeLogItem;
    FMessage,CurrentLogsPath: string;
    D1,D2: TDateTime;
    ChangeCashList: TCashChangeLogArray;
    procedure ShowMessage;
    procedure AddIntoLog;
  protected
    procedure Execute; override;
  public
    constructor Create(AOwner: TShowLogsForm;
                       ACurrentLogsPath: string;
                       AD1,AD2: TDateTime);
  end;

  TGetSingleSwitchLog = class(TThread)
  private
    Owner: TShowLogsForm;
    SwitchItem: TCashSwitchLogItem;
    FMessage,CurrentLogsPath: string;
    D1,D2: TDateTime;
    SwitchCashList: TCashSwitchLogArray;
    procedure ShowMessage;
    procedure AddIntoLog;
  protected
    procedure Execute; override;
  public
    constructor Create(AOwner: TShowLogsForm;
                       ACurrentLogsPath: string;
                       AD1,AD2: TDateTime);
  end;

  TGetSingleAlarmLog = class(TThread)
  private
    Owner: TShowLogsForm;
    AlarmItem: TCashAlarmLogItem;
    FMessage,CurrentLogsPath: string;
    D1,D2: TDateTime;
    AlarmCashList: TCashAlarmLogArray;
    procedure ShowMessage;
    procedure AddIntoLog;
  protected
    procedure Execute; override;
  public
    constructor Create(AOwner: TShowLogsForm;
                       ACurrentLogsPath: string;
                       AD1,AD2: TDateTime);
  end;

var
  ShowLogsForm: TShowLogsForm;

implementation

uses TimeFilterUnit, DateUtils, 
     ThreadSaveUnit, SyncObjs, Math, RemXUnit,
  PrintDialogUnit, SaveExtDialogUnit;

{$R *.dfm}

var
  AlarmLogSection: TCriticalSection;
  SwitchLogSection: TCriticalSection;
  ChangeLogSection: TCriticalSection;
  SystemLogSection: TCriticalSection;

{ TShowLogsForm }

procedure TShowLogsForm.FormCreate(Sender: TObject);
var i: integer; M: TMenuItem; SL: TStringList;
begin
  PathToSave := 'LogView';
  LogLoading := False;
  CurrentTimeIndex:=0;
  StartTime:=Now;
  FindDialogVisible:=False;
  SL:=TStringList.Create;
  try
    SL.Add('20 минут');
    SL.Add('1 час');
    SL.Add('2 часа');
    SL.Add('4 часа');
    SL.Add('8 часов');
    SL.Add('12 часов');
    SL.Add('24 часа');
    for i:=0 to SL.Count-1 do
    begin
      M:=TMenuItem.Create(Self);
      M.Caption:=SL[i];
      M.GroupIndex:=1;
      M.AutoCheck:=True;
      M.Tag:=i;
      M.OnClick:=tbTime0Click;
      TimePopupMenu.Items.Add(M);
    end;
  finally
    SL.Free;
  end;
end;

procedure TShowLogsForm.actPreviewExecute(Sender: TObject);
begin
  Printer.Refresh;
  if Printer.Printers.Count = 0 then
  begin
    RemxForm.ShowError('Нет установленных принтеров в системе.');
    Exit;
  end;
//  try
//    Printer.PrinterIndex:=-1;
//  except
//    RemxForm.ShowError('Не выбран принтер по умолчанию!');
//    Exit;
//  end;
  if not cbScrolling.Checked then
    LastRow[TLogType(tcLogs.TabIndex)]:=DrawGrid.Row;
  actPreview.Enabled:=False;
  Screen.Cursor:=crHourGlass;
  try
    Panel.acPreview.Execute;
    case TLogType(tcLogs.TabIndex) of
 ltAlarmLog:
      begin
        frLogReport.LoadFromResourceName(HInstance,'AlarmReport');
        frUserLogDataset.RangeEndCount:=AlarmData.Length;
        Panel.ShowPreviewForm.MasterAction:=Panel.actAlarmLogShow;
      end;
 ltSwitchLog:
      begin
        frLogReport.LoadFromResourceName(HInstance,'SwitchReport');
        frUserLogDataset.RangeEndCount:=SwitchData.Length;
        Panel.ShowPreviewForm.MasterAction:=Panel.actSwitchLogShow;
      end;
 ltChangeLog:
      begin
        frLogReport.LoadFromResourceName(HInstance,'ChangeReport');
        frUserLogDataset.RangeEndCount:=ChangeData.Length;
        Panel.ShowPreviewForm.MasterAction:=Panel.actChangeLogShow;
      end;
 ltSystemLog:
      begin
        frLogReport.LoadFromResourceName(HInstance,'SystemReport');
        frUserLogDataset.RangeEndCount:=SystemData.Length;
        Panel.ShowPreviewForm.MasterAction:=Panel.actSystemLogShow;
      end;
    end; {case}
    if Config.ReadInteger('General','PrintColor',0) = 0 then
    begin  // Серая шкала
      with CurPage.FindObject('ReportTitleMemo') as TfrMemoView do
      begin
        FillColor:=clSilver;
        Font.Color:=clBlack;
      end;
    end;
    frLogReport.Preview:=Panel.ShowPreviewForm.frAllPreview;
    frLogReport.Title:=tcLogs.Tabs[tcLogs.TabIndex];
    NumPages:=0;
    if frLogReport.PrepareReport then
    begin
      frLogReport.ShowPreparedReport;
      Panel.ShowPreviewForm.Show;
    end;
  finally
    Screen.Cursor:=crDefault;
    actPreview.Enabled:=True;
  end;
end;

procedure TShowLogsForm.actPrintExecute(Sender: TObject);
begin
  PrintDialogForm:=TPrintDialogForm.Create(Self);
  try
    if not cbScrolling.Checked then
      LastRow[TLogType(tcLogs.TabIndex)]:=DrawGrid.Row;
    actPrint.Enabled:=False;
    Screen.Cursor:=crHourGlass;
    try
      case TLogType(tcLogs.TabIndex) of
   ltAlarmLog:
        begin
          frLogReport.LoadFromResourceName(HInstance,'AlarmReport');
          frUserLogDataset.RangeEndCount:=AlarmData.Length;
        end;
   ltSwitchLog:
        begin
          frLogReport.LoadFromResourceName(HInstance,'SwitchReport');
          frUserLogDataset.RangeEndCount:=SwitchData.Length;
        end;
   ltChangeLog:
        begin
          frLogReport.LoadFromResourceName(HInstance,'ChangeReport');
          frUserLogDataset.RangeEndCount:=ChangeData.Length;
        end;
   ltSystemLog:
        begin
          frLogReport.LoadFromResourceName(HInstance,'SystemReport');
          frUserLogDataset.RangeEndCount:=SystemData.Length;
        end;
      end; {case}
      if Config.ReadInteger('General','PrintColor',0) = 0 then
      begin  // Серая шкала
        with CurPage.FindObject('ReportTitleMemo') as TfrMemoView do
        begin
          FillColor:=clSilver;
          Font.Color:=clBlack;
        end;
      end;
      frLogReport.Title:=tcLogs.Tabs[tcLogs.TabIndex];
      NumPages:=0;
      if frLogReport.PrepareReport then
      begin
        PrintDialogForm.FromPage:=1;
        PrintDialogForm.ToPage:=NumPages;
        if PrintDialogForm.Execute then
        begin
          RemXForm.SaveReportToReportsLog(frLogReport,True,'Журналы');
          if PrintDialogForm.PrintRange = prAllPages then
            frLogReport.PrintPreparedReport('',PrintDialogForm.Copies,
                                            PrintDialogForm.Collate,frAll)
          else
            if PrintDialogForm.PrintRange = prPageNums then
              frLogReport.PrintPreparedReport(Format('%d-%d',
                             [PrintDialogForm.FromPage,PrintDialogForm.ToPage]),
                          PrintDialogForm.Copies,PrintDialogForm.Collate,frAll);
        end;
      end;
    finally
      Screen.Cursor:=crDefault;
      actPrint.Enabled:=True;
    end;
  finally
    PrintDialogForm.Free;
  end;
end;

procedure TShowLogsForm.frLogReportBeginPage(pgNo: Integer);
begin
  Inc(NumPages);
end;

procedure TShowLogsForm.FindDialogClose(Sender: TObject);
begin
  FindDialogVisible:=False;
end;

procedure TShowLogsForm.tcLogsChange(Sender: TObject);
var sum, i: Integer;
begin
  DrawGrid.RowCount:=2;
  case TLogType(tcLogs.TabIndex) of
 ltAlarmLog:
    begin
       DrawGrid.DefaultRowHeight:=24;
       DrawGrid.Font.Size:=12;
       DrawGrid.Font.Name:='Tahoma';
       DrawGrid.ColCount:=8;
       DrawGrid.ColWidths[0]:=214;
       DrawGrid.ColWidths[1]:=65;
       DrawGrid.ColWidths[2]:=115;
       DrawGrid.ColWidths[3]:=110;
       DrawGrid.ColWidths[4]:=150;
       DrawGrid.ColWidths[5]:=145;
       DrawGrid.ColWidths[6]:=240;
       sum := 0; for i:=0 to 6 do sum := sum + DrawGrid.ColWidths[i]+1;
       DrawGrid.ColWidths[7]:=DrawGrid.ClientWidth - sum -
                             GetSystemMetrics(SM_CXVSCROLL);
    end;
 ltSwitchLog:
    begin
       DrawGrid.DefaultRowHeight:=24;
       DrawGrid.Font.Size:=12;
       DrawGrid.Font.Name:='Tahoma';
       DrawGrid.ColCount:=7;
       DrawGrid.ColWidths[0]:=214;
       DrawGrid.ColWidths[1]:=75;
       DrawGrid.ColWidths[2]:=130;
       DrawGrid.ColWidths[3]:=130;
       DrawGrid.ColWidths[4]:=150;
       DrawGrid.ColWidths[5]:=150;
       sum := 0; for i:=0 to 5 do sum := sum + DrawGrid.ColWidths[i]+1;
       DrawGrid.ColWidths[6]:=DrawGrid.ClientWidth - sum -
                             GetSystemMetrics(SM_CXVSCROLL);
    end;
 ltChangeLog:
    begin
       DrawGrid.DefaultRowHeight:=24;
       DrawGrid.Font.Size:=12;
       DrawGrid.Font.Name:='Tahoma';
       DrawGrid.ColCount:=8;
       DrawGrid.ColWidths[0]:=214;
       DrawGrid.ColWidths[1]:=75;
       DrawGrid.ColWidths[2]:=150;
       DrawGrid.ColWidths[3]:=160;
       DrawGrid.ColWidths[4]:=165;
       DrawGrid.ColWidths[5]:=165;
       DrawGrid.ColWidths[6]:=150;
       sum := 0; for i:=0 to 6 do sum := sum + DrawGrid.ColWidths[i]+1;
       DrawGrid.ColWidths[7]:=DrawGrid.ClientWidth - sum -
                             GetSystemMetrics(SM_CXVSCROLL);
    end;
 ltSystemLog:
    begin
       DrawGrid.DefaultRowHeight:=24;
       DrawGrid.Font.Size:=12;
       DrawGrid.Font.Name:='Tahoma';
       DrawGrid.ColCount:=4;
       DrawGrid.ColWidths[0]:=214;
       DrawGrid.ColWidths[1]:=75;
       DrawGrid.ColWidths[2]:=170;
       sum := 0; for i:=0 to 2 do sum := sum + DrawGrid.ColWidths[i]+1;
       DrawGrid.ColWidths[3]:=DrawGrid.ClientWidth - sum -
                             GetSystemMetrics(SM_CXVSCROLL);
     end;
  end;
  ReloadLog;
end;

procedure TShowLogsForm.TimePopupMenuPopup(Sender: TObject);
var i: integer;
begin
  for i:=0 to TimePopupMenu.Items.Count-1 do
    TimePopupMenu.Items.Items[i].Checked:=False;
  TimePopupMenu.Items.Items[CurrentTimeIndex].Checked:=True;
end;

procedure TShowLogsForm.tbTime0Click(Sender: TObject);
begin
  if LogLoading then Exit;
  DrawGrid.Update;
  if Sender is TMenuItem then
  with Sender as TMenuItem do
  begin
    Checked:=True;
    CurrentTimeIndex:=Tag;
    tbTimeSelect.Caption:=Caption;
  end;
  cbScrolling.OnClick:=nil;
  try
    cbScrolling.Checked:=True;
  finally
    cbScrolling.OnClick:=cbScrollingClick;
  end;
  StartTime:=Now;
  ShiftTime:=GetShiftTime(CurrentTimeIndex);
  UpdateTimeRange;
  Filtered:=False;
  ReloadLog;
end;

function TShowLogsForm.GetShiftTime(Index: integer): TDateTime;
begin
  case CurrentTimeIndex of
    1: Result:=OneHour;
    2: Result:=OneHour*2;
    3: Result:=OneHour*4;
    4: Result:=OneHour*8;
    5: Result:=OneHour*12;
    6: Result:=OneHour*24;
  else
    Result:=EncodeTime(0,20,0,0);
  end;
end;

procedure TShowLogsForm.cbScrollingClick(Sender: TObject);
begin
  if LogLoading then Exit;
  if cbScrolling.Checked then
  begin
    StartTime:=Now;
    ShiftTime:=GetShiftTime(CurrentTimeIndex);
    UpdateTimeRange;
    Filtered:=False;
    ReloadLog;
  end;
end;

procedure TShowLogsForm.ReloadLog;
var D1,D2: TDateTime;
begin
  if LogLoading then Exit;
  case TLogType(tcLogs.TabIndex) of
   ltAlarmLog:  AlarmData.Length:=0;
   ltSwitchLog: SwitchData.Length:=0;
   ltChangeLog: ChangeData.Length:=0;
   ltSystemLog: SystemData.Length:=0;
  end;
  LogLoading:=True;
  DrawGrid.RowCount:=2;
  DrawGrid.Invalidate;
  DrawGrid.Cursor:=crHourGlass;
  Screen.Cursor:=crHourGlass;
  D2:=StartTime;
  D1:=D2-ShiftTime;
  ResumeCurrentLog(D1,D2);
  SaveConfig(PathToSave);
end;

procedure TShowLogsForm.ResumeCurrentLog(D1,D2: TDateTime);
begin
  case TLogType(tcLogs.TabIndex) of
  ltAlarmLog:
    with TGetSingleAlarmLog.Create(Self,Caddy.CurrentLogsPath,D1,D2) do
    begin
      OnTerminate:=LogLoaded;
      Resume;
    end;
   ltSwitchLog:
    with TGetSingleSwitchLog.Create(Self,Caddy.CurrentLogsPath,D1,D2) do
    begin
      OnTerminate:=LogLoaded;
      Resume;
    end;
   ltChangeLog:
    with TGetSingleChangeLog.Create(Self,Caddy.CurrentLogsPath,D1,D2) do
    begin
      OnTerminate:=LogLoaded;
      Resume;
    end;
   ltSystemLog:
    with TGetSingleSystemLog.Create(Self,Caddy.CurrentLogsPath,D1,D2) do
    begin
      OnTerminate:=LogLoaded;
      Resume;
    end;
  end;;
end;

procedure TShowLogsForm.LoadConfig(Path: string);
begin
  PathToSave := Path;
  StartTime:=Config.ReadDateTime(Path,'LogDate',Now);
  CurrentTimeIndex:=Config.ReadInteger(Path,'LogTime',0);
  if CurrentTimeIndex > 6 then CurrentTimeIndex:=6;
  ShiftTime:=GetShiftTime(CurrentTimeIndex);
  tbTimeSelect.Caption:=TimePopupMenu.Items.Items[CurrentTimeIndex].Caption;
  cbScrolling.OnClick:=nil;
  try
    cbScrolling.Checked:=Config.ReadBool(Path,'Scrolling',True);
  finally
    cbScrolling.OnClick:=cbScrollingClick;
  end;
end;

procedure TShowLogsForm.SaveConfig(Path: string);
begin
  Config.WriteDateTime(Path,'LogDate',StartTime);
  Config.WriteInteger(Path,'LogTime',CurrentTimeIndex);
  Config.WriteBool(Path,'Scrolling',cbScrolling.Checked);
// Запись изменений на диск
  ConfigUpdateFile(Config);
end;

procedure TShowLogsForm.tbFilterClick(Sender: TObject);
var i: integer; Result: TModalResult;
begin
  if LogLoading then Exit;
  i:=tcLogs.TabIndex;
  TimeFilterForm:=TTimeFilterForm.Create(Self);
  try
    with RemXForm,TimeFilterForm do
    begin
      dtBeginDate.DateTime:=Config.ReadDate('TimeFilter',
                                 Format('BeginDate%d',[i]),Int(Now-1.0));
      dtBeginTime.DateTime:=Config.ReadTime('TimeFilter',
                                 Format('BeginTime%d',[i]),Frac(Now-1.0));
      dtEndDate.DateTime:=Config.ReadDate('TimeFilter',
                                 Format('EndDate%d',[i]),Int(Now));
      dtEndTime.DateTime:=Config.ReadTime('TimeFilter',
                                 Format('EndTime%d',[i]),Frac(Now));
      Result:=ShowModal;
      if Result = mrOk then
      begin
        FirstSnap:=Int(dtBeginDate.DateTime)+Frac(dtBeginTime.DateTime);
        LastSnap:=Int(dtEndDate.DateTime)+Frac(dtEndTime.DateTime);
        Config.WriteDate('TimeFilter',Format('BeginDate%d',[i]),Int(FirstSnap));
        Config.WriteTime('TimeFilter',Format('BeginTime%d',[i]),Frac(FirstSnap));
        Config.WriteDate('TimeFilter',Format('EndDate%d',[i]),Int(LastSnap));
        Config.WriteTime('TimeFilter',Format('EndTime%d',[i]),Frac(LastSnap));
        Filtered:=True;
        StartTime:=LastSnap;
        ShiftTime:=LastSnap-FirstSnap;
        UpdateTimeRange;
        cbScrolling.OnClick:=nil;
        try
          cbScrolling.Checked:=False;
        finally
          cbScrolling.OnClick:=cbScrollingClick;
        end;
        DrawGrid.Row:=1;
        ReloadLog;
      end
      else
      if Result = mrAbort then
      begin
        Filtered:=False;
        cbScrolling.Checked:=True;
        Update;
      end
      else
        Exit;
    end;
  finally
    TimeFilterForm.Free;
  end;
end;

procedure TShowLogsForm.UpdateLog;
begin
  if LogLoading then Exit;
  if cbScrolling.Checked then
  begin
    StartTime:=Now;
    ShiftTime:=GetShiftTime(CurrentTimeIndex);
    UpdateTimeRange;
    ReloadLog;
  end;
end;

procedure TShowLogsForm.tbLessTimeClick(Sender: TObject);
var D1,D2: TDateTime;
begin
  if LogLoading then Exit;
  LogLoading:=True;
  cbScrolling.OnClick:=nil;
  try
    cbScrolling.Checked:=False;
  finally
    cbScrolling.OnClick:=cbScrollingClick;
  end;
  StartTime:=StartTime-ShiftTime;
  D2:=StartTime;
  D1:=D2-ShiftTime;
  Screen.Cursor:=crHourGlass;
  ResumeCurrentLog(D1,D2);
end;

procedure TShowLogsForm.tbMoreTimeClick(Sender: TObject);
var D1,D2: TDateTime;
begin
  if LogLoading then Exit;
  LogLoading:=True;
  cbScrolling.OnClick:=nil;
  try
    cbScrolling.Checked:=False;
  finally
    cbScrolling.OnClick:=cbScrollingClick;
  end;
  StartTime:=StartTime+ShiftTime;
  D2:=StartTime;
  D1:=D2-ShiftTime;
  Screen.Cursor:=crHourGlass;
  ResumeCurrentLog(D1,D2);
end;

procedure TShowLogsForm.DrawGridDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var S: string;
begin
  InflateRect(Rect,-3,0);
  with DrawGrid.Canvas do
  begin
    if ARow = 0 then
    begin
      case ACol of
       0: begin
            if Filtered then
            begin
              LogsImageList.Draw(DrawGrid.Canvas,Rect.Right-16,
                                 Rect.Top+(Rect.Bottom-Rect.Top-16) div 2,5);
              Brush.Style:=bsClear;
            end;
            DrawText(Handle,'Дата и время',-1,Rect,
                     DT_CENTER+DT_VCENTER+DT_SINGLELINE);
            if Filtered then
              Brush.Style:=bsSolid;
          end;
       1: DrawText(Handle,'Ст.',-1,Rect,DT_CENTER+DT_VCENTER+DT_SINGLELINE);
      else
        begin
          case TLogType(tcLogs.TabIndex) of
        ltAlarmLog:
             case ACol of
               2: S:='Позиция';
               3: S:='Параметр';
               4: S:='Значение';
               5: S:='Уставка';
               6: S:='Сообщение';
               7: S:='Дескриптор позиции';
             end;
        ltSwitchLog:
             case ACol of
               2: S:='Позиция';
               3: S:='Параметр';
               4: S:='Было';
               5: S:='Стало';
               6: S:='Дескриптор позиции';
             end;
        ltChangeLog:
             case ACol of
               2: S:='Позиция';
               3: S:='Параметр';
               4: S:='Было';
               5: S:='Стало';
               6: S:='Кто сделал';
               7: S:='Дескриптор позиции';
             end;
        ltSystemLog:
             case ACol of
               2: S:='Параметр';
               3: S:='Сообщение';
             end;
          else
            S:='';
          end;
          DrawText(Handle,PChar(S),Length(S),Rect,DT_LEFT+DT_VCENTER+DT_SINGLELINE);
        end;
      end; {case}
    end
    else
    begin
      case TLogType(tcLogs.TabIndex) of
   ltAlarmLog:
        begin
          if (AlarmData.Length > 0) then
          case ACol of
           0: S:=FormatDateTime('dd.mm.yy, ddd, hh:nn:ss.zzz',AlarmData.Body[ARow].SnapTime);
           1: S:=Format('%d',[AlarmData.Body[ARow].Station]);
           2: S:=AlarmData.Body[ARow].Position;
           3: S:=AlarmData.Body[ARow].Parameter;
           4: S:=AlarmData.Body[ARow].Value;
           5: S:=AlarmData.Body[ARow].SetPoint;
           6: S:=AlarmData.Body[ARow].Mess;
           7: S:=AlarmData.Body[ARow].Descriptor;
          end;
        end;
   ltSwitchLog:
        begin
          if (SwitchData.Length > 0) then
          case ACol of
           0: S:=FormatDateTime('dd.mm.yy, ddd, hh:nn:ss.zzz',SwitchData.Body[ARow].SnapTime);
           1: S:=Format('%d',[SwitchData.Body[ARow].Station]);
           2: S:=SwitchData.Body[ARow].Position;
           3: S:=SwitchData.Body[ARow].Parameter;
           4: S:=SwitchData.Body[ARow].OldValue;
           5: S:=SwitchData.Body[ARow].NewValue;
           6: S:=SwitchData.Body[ARow].Descriptor;
          end;
        end;
   ltChangeLog:
        begin
          if ChangeData.Length > 0 then
          case ACol of
           0: S:=FormatDateTime('dd.mm.yy, ddd, hh:nn:ss.zzz',ChangeData.Body[ARow].SnapTime);
           1: S:=Format('%d',[ChangeData.Body[ARow].Station]);
           2: S:=ChangeData.Body[ARow].Position;
           3: S:=ChangeData.Body[ARow].Parameter;
           4: S:=ChangeData.Body[ARow].OldValue;
           5: S:=ChangeData.Body[ARow].NewValue;
           6: S:=ChangeData.Body[ARow].Autor;
           7: S:=ChangeData.Body[ARow].Descriptor;
          end;
        end;
   ltSystemLog:
        begin
          if SystemData.Length > 0 then
          case ACol of
           0: S:=FormatDateTime('dd.mm.yy, ddd, hh:nn:ss.zzz',SystemData.Body[ARow].SnapTime);
           1: S:=Format('%d',[SystemData.Body[ARow].Station]);
           2: S:=SystemData.Body[ARow].Position;
           3: S:=SystemData.Body[ARow].Descriptor;
          end;
        end;
      end; {case}
      case ACol of
        1: DrawText(Handle,PChar(S),Length(S),Rect,DT_CENTER+DT_VCENTER+DT_SINGLELINE);
      else
        begin
          if (ACol in [4,5]) and (TLogType(tcLogs.TabIndex) = ltAlarmLog) then
            DrawText(Handle,PChar(S),Length(S),Rect,DT_CENTER+DT_VCENTER+DT_SINGLELINE)
          else
            DrawText(Handle,PChar(S),Length(S),Rect,DT_LEFT+DT_VCENTER+DT_SINGLELINE);
        end
      end;
    end;
  end;
end;

procedure TShowLogsForm.LogLoaded(Sender: TObject);
begin
  LogLoading:=False;
  if not cbScrolling.Checked then
  begin
    if LastRow[TLogType(tcLogs.TabIndex)] < DrawGrid.RowCount then
    begin
      if LastRow[TLogType(tcLogs.TabIndex)] = 0 then
        DrawGrid.Row:=1
      else
        DrawGrid.Row:=LastRow[TLogType(tcLogs.TabIndex)];
    end;
  end;
  Screen.Cursor:=crDefault;
  DrawGrid.Invalidate;
end;

procedure TShowLogsForm.tbFreshClick(Sender: TObject);
begin
  if cbScrolling.Checked then
  begin
    if LogLoading then Exit;
    StartTime:=Now;
    ShiftTime:=GetShiftTime(CurrentTimeIndex);
    UpdateTimeRange;
    Filtered:=False;
    ReloadLog;
  end
  else
    ReloadLog;
end;

procedure TShowLogsForm.frLogReportGetValue(const ParName: String;
  var ParValue: Variant);
var i: integer;
begin
  if AnsiCompareText(ParName,'ObjectName') = 0 then
    ParValue:=Config.ReadString('General','ObjectName','');
  if AnsiCompareText(ParName,'PrintDate') = 0 then
    ParValue:=FormatDateTime('Отпечатано: d.mm.yyyy h:nn:ss',(Now));
  if AnsiCompareText(ParName,'PrintPeriod') = 0 then
    ParValue:='Время выборки: с '+
         FormatDateTime('d.mm.yyyy h:nn:ss',StartTime-ShiftTime)+
     ' до '+FormatDateTime('d.mm.yyyy h:nn:ss',StartTime);
//--------------------------------------------------------------------
  i:=frUserLogDataset.RecNo;
  case TLogType(tcLogs.TabIndex) of
ltAlarmLog:
    if AlarmData.Length > 0 then
    begin
      if AnsiCompareText(ParName,'SnapTime') = 0 then
        ParValue:=FormatDateTime('dd.mm.yy, ddd, hh:nn:ss.zzz',AlarmData.Body[i+1].SnapTime);
      if AnsiCompareText(ParName,'Station') = 0 then
        ParValue:=Format('%d',[AlarmData.Body[i+1].Station]);
      if AnsiCompareText(ParName,'Position') = 0 then
        ParValue:=AlarmData.Body[i+1].Position;
      if AnsiCompareText(ParName,'Parameter') = 0 then
        ParValue:=AlarmData.Body[i+1].Parameter;
      if AnsiCompareText(ParName,'Value') = 0 then
        ParValue:=AlarmData.Body[i+1].Value;
      if AnsiCompareText(ParName,'SetPoint') = 0 then
        ParValue:=AlarmData.Body[i+1].SetPoint;
      if AnsiCompareText(ParName,'Message') = 0 then
        ParValue:=AlarmData.Body[i+1].Mess;
      if AnsiCompareText(ParName,'Descriptor') = 0 then
        ParValue:=AlarmData.Body[i+1].Descriptor;
    end;
ltSwitchLog:
    if (SwitchData.Length > 0) then
    begin
      if AnsiCompareText(ParName,'SnapTime') = 0 then
        ParValue:=FormatDateTime('dd.mm.yy, ddd, hh:nn:ss.zzz',SwitchData.Body[i+1].SnapTime);
      if AnsiCompareText(ParName,'Station') = 0 then
        ParValue:=Format('%d',[SwitchData.Body[i+1].Station]);
      if AnsiCompareText(ParName,'Position') = 0 then
        ParValue:=SwitchData.Body[i+1].Position;
      if AnsiCompareText(ParName,'Parameter') = 0 then
        ParValue:=SwitchData.Body[i+1].Parameter;
      if AnsiCompareText(ParName,'OldValue') = 0 then
        ParValue:=SwitchData.Body[i+1].OldValue;
      if AnsiCompareText(ParName,'NewValue') = 0 then
        ParValue:=SwitchData.Body[i+1].NewValue;
      if AnsiCompareText(ParName,'Descriptor') = 0 then
        ParValue:=SwitchData.Body[i+1].Descriptor;
    end;
ltChangeLog:
    if ChangeData.Length  > 0 then
    begin
      if AnsiCompareText(ParName,'SnapTime') = 0 then
        ParValue:=FormatDateTime('dd.mm.yy, ddd, hh:nn:ss.zzz',ChangeData.Body[i+1].SnapTime);
      if AnsiCompareText(ParName,'Station') = 0 then
        ParValue:=Format('%d',[ChangeData.Body[i+1].Station]);
      if AnsiCompareText(ParName,'Position') = 0 then
        ParValue:=ChangeData.Body[i+1].Position;
      if AnsiCompareText(ParName,'Parameter') = 0 then
        ParValue:=ChangeData.Body[i+1].Parameter;
      if AnsiCompareText(ParName,'OldValue') = 0 then
        ParValue:=ChangeData.Body[i+1].OldValue;
      if AnsiCompareText(ParName,'NewValue') = 0 then
        ParValue:=ChangeData.Body[i+1].NewValue;
      if AnsiCompareText(ParName,'Autor') = 0 then
        ParValue:=ChangeData.Body[i+1].Autor;
      if AnsiCompareText(ParName,'Descriptor') = 0 then
        ParValue:=ChangeData.Body[i+1].Descriptor;
    end;
ltSystemLog:
    if SystemData.Length > 0 then
    begin
      if AnsiCompareText(ParName,'SnapTime') = 0 then
        ParValue:=FormatDateTime('dd.mm.yy, ddd, hh:nn:ss.zzz',SystemData.Body[i+1].SnapTime);
      if AnsiCompareText(ParName,'Station') = 0 then
        ParValue:=Format('%d',[SystemData.Body[i+1].Station]);
      if AnsiCompareText(ParName,'Position') = 0 then
        ParValue:=SystemData.Body[i+1].Position;
      if AnsiCompareText(ParName,'Descriptor') = 0 then
        ParValue:=SystemData.Body[i+1].Descriptor;
    end;
  end; {case}
end;

procedure TShowLogsForm.UpdateTimeRange;
var dd,hh,nn,ss,ms: Word; S: string;
begin
  dd:=Word(Trunc(ShiftTime));
  DecodeTime(ShiftTime,hh,nn,ss,ms);
  S:=' ';
  if dd > 0 then
    S:=S+NumToStr(dd,'','день','дня','дней')+' ';
  if hh > 0 then
    S:=S+NumToStr(hh,'час','','а','ов')+' ';
  if nn > 0 then
    S:=S+NumToStr(nn,'минут','а','ы','')+' ';
  if (dd=0) and (hh=0) and (nn=0) then
    S:='меньше минуты';
  tbTimeSelect.Caption:=S;
end;

procedure TShowLogsForm.tcLogsChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange:=not LogLoading;
  if AllowChange then LastRow[TLogType(tcLogs.TabIndex)]:=DrawGrid.Row;
end;

procedure TShowLogsForm.DrawGridMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var ACol,ARow: integer;
begin
  if Button = mbLeft then
  begin
    DrawGrid.MouseToCell(X,Y,ACol,ARow);
    if (ACol = 0) and (ARow = 0) then tbFilterClick(Sender);
  end;
end;

procedure TShowLogsForm.DrawGridMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var ACol,ARow: integer; R: TRect;
begin
  DrawGrid.MouseToCell(X,Y,ACol,ARow);
  if (ACol = 0) and (ARow = 0) then
  begin
    R:=DrawGrid.CellRect(ACol,ARow);
    InflateRect(R,-3,-3);
    if PtInRect(R,Point(X,Y)) then
      DrawGrid.Cursor:=crHandPoint
    else
      DrawGrid.Cursor:=crDefault;
  end
  else
    DrawGrid.Cursor:=crDefault;
end;

procedure TShowLogsForm.ShowThreadMessage(Sender: TObject; Mess: string);
begin
  RemXForm.ShowMessage:=Mess;
end;

procedure TShowLogsForm.ApplicationEventsIdle(Sender: TObject;
  var Done: Boolean);
begin
  tbLessTime.Enabled:=not LogLoading;
  tbTimeSelect.Enabled:=not LogLoading;
  tbMoreTime.Enabled:=not LogLoading;
  cbScrolling.Enabled:=not LogLoading;
  tcLogs.Enabled:=not LogLoading;
  tbFresh.Enabled:=not LogLoading;
end;

procedure TShowLogsForm.actPrintUpdate(Sender: TObject);
begin
  actPrint.Enabled:=not LogLoading;
end;

procedure TShowLogsForm.actPreviewUpdate(Sender: TObject);
begin
  actPreview.Enabled:=not LogLoading;
end;

{ TGetSingleAlarmLog }

procedure TGetSingleAlarmLog.AddIntoLog;
var Count: integer;
begin
  Screen.Cursor:=crHandPoint;
  try
    Move(AlarmCashList,Owner.AlarmData,SizeOf(Owner.AlarmData));
    Count:=Owner.AlarmData.Length;
    if Count > 0 then
      Owner.DrawGrid.RowCount:=Count+1
    else
      Owner.DrawGrid.RowCount:=2;
    if Owner.cbScrolling.Checked then
      Owner.DrawGrid.Row:=Owner.DrawGrid.RowCount-1;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

constructor TGetSingleAlarmLog.Create(AOwner: TShowLogsForm;
  ACurrentLogsPath: string; AD1, AD2: TDateTime);
begin
  Owner:=AOwner;
  CurrentLogsPath:=ACurrentLogsPath;
  D1:=AD1;
  D2:=AD2;
  inherited Create(True);
  Priority:=tpLower; //tpHigher;
  FreeOnTerminate:=True;
end;

procedure TGetSingleAlarmLog.Execute;
var DS,DE: TDateTime; hh,nn,ss,zz: word; ErrFlag: boolean;
    FileName,DirName: string; Count: integer;
    F: TFileStream;
begin
  AlarmCashList.Length:=0;
  AlarmLogSection.Enter;
  try
    DecodeTime(D1,hh,nn,ss,zz);
    DS:=Int(D1)+EncodeTime(hh,0,0,0);
    DecodeTime(D2,hh,nn,ss,zz);
    DE:=Int(D2)+EncodeTime(hh,59,59,999);
    ErrFlag:=False;
    Count:=0;
    while DS < DE do
    begin
      if Terminated then Exit;
      DirName:=CurrentLogsPath+FormatDateTime('\yymmdd\hh',DS);
      FileName:=IncludeTrailingPathDelimiter(DirName)+'ALARMS.LOG';
      if FileExists(FileName) then
      begin
        F:=TryOpenToReadFile(FileName);
        if not Assigned(F) then
        begin
          FMessage:='Файл "'+ExtractFileName(FileName)+
                    '" занят другим процессом. Таблица не загружена!';
          Synchronize(ShowMessage);
          Exit;
        end;
        try
          F.Seek(0,soFromBeginning);
          while F.Position < F.Size do
          begin
            if Terminated then Break;
            try
              try
                F.ReadBuffer(AlarmItem.SnapTime,SizeOf(AlarmItem.SnapTime));
                F.ReadBuffer(AlarmItem.Station,SizeOf(AlarmItem.Station));
                F.ReadBuffer(AlarmItem.Position,SizeOf(AlarmItem.Position));
                F.ReadBuffer(AlarmItem.Parameter,SizeOf(AlarmItem.Parameter));
                F.ReadBuffer(AlarmItem.Value,SizeOf(AlarmItem.Value));
                F.ReadBuffer(AlarmItem.SetPoint,SizeOf(AlarmItem.SetPoint));
                F.ReadBuffer(AlarmItem.Mess,SizeOf(AlarmItem.Mess));
                F.ReadBuffer(AlarmItem.Descriptor,SizeOf(AlarmItem.Descriptor));
              except
                Break;
              end;
              if InRange(AlarmItem.SnapTime,D1,D2) then
              begin
                if AlarmCashList.Length < High(AlarmCashList.Body) then
                begin
                  Inc(AlarmCashList.Length);
                  Count:=AlarmCashList.Length;
                  AlarmCashList.Body[AlarmCashList.Length]:=AlarmItem;
                end
                else
                begin
                  FMessage:='Достигнуто '+NumToStr(Count,'запис','ь','и','ей')+
                  '. Таблица загружена не полностью!';
                  Synchronize(ShowMessage);
                  ErrFlag:=True;
                  Break;
                end;
              end;
            except
              on E: Exception do
              begin
                FMessage:=E.Message;
                ErrFlag:=True;
                Break;
              end;
            end;
          end;
        finally
          F.Free;
        end;
      end;
      DS:=DS+OneHour;
      if ErrFlag then Break;
    end;
    Synchronize(AddIntoLog);
    if not ErrFlag then
    begin
      FMessage:=NumToStr(Count,'Загружен','а','о','о',False)+' '+
                NumToStr(Count,'запис','ь','и','ей')+'.';
      Synchronize(ShowMessage);
    end;
  finally
    AlarmLogSection.Leave;
  end;
end;

procedure TGetSingleAlarmLog.ShowMessage;
begin
  RemXForm.ShowMessage:=FMessage;
end;

{ TGetSingleSwitchLog }

procedure TGetSingleSwitchLog.AddIntoLog;
var Count: integer;
begin
  Screen.Cursor:=crHandPoint;
  try
    Move(SwitchCashList,Owner.SwitchData,SizeOf(Owner.SwitchData));
    Count:=Owner.SwitchData.Length;
    if Count > 0 then
      Owner.DrawGrid.RowCount:=Count+1
    else
      Owner.DrawGrid.RowCount:=2;
    if Owner.cbScrolling.Checked then
      Owner.DrawGrid.Row:=Owner.DrawGrid.RowCount-1;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

constructor TGetSingleSwitchLog.Create(AOwner: TShowLogsForm;
  ACurrentLogsPath: string; AD1, AD2: TDateTime);
begin
  Owner:=AOwner;
  CurrentLogsPath:=ACurrentLogsPath;
  D1:=AD1;
  D2:=AD2;
  inherited Create(True);
  Priority:=tpLower; //tpHigher;
  FreeOnTerminate:=True;
end;

procedure TGetSingleSwitchLog.Execute;
var DS,DE: TDateTime; hh,nn,ss,zz: word; ErrFlag: boolean;
    FileName,DirName: string; Count: integer;
    F: TFileStream;
begin
  SwitchCashList.Length:=0;
  SwitchLogSection.Enter;
  try
    DecodeTime(D1,hh,nn,ss,zz);
    DS:=Int(D1)+EncodeTime(hh,0,0,0);
    DecodeTime(D2,hh,nn,ss,zz);
    DE:=Int(D2)+EncodeTime(hh,59,59,999);
    ErrFlag:=False;
    Count:=0;
    while DS < DE do
    begin
      if Terminated then Exit;
      DirName:=CurrentLogsPath+FormatDateTime('\yymmdd\hh',DS);
      FileName:=IncludeTrailingPathDelimiter(DirName)+'SWITCHS.LOG';
      if FileExists(FileName) then
      begin
        F:=TryOpenToReadFile(FileName);
        if not Assigned(F) then
        begin
          FMessage:='Файл "'+ExtractFileName(FileName)+
                    '" занят другим процессом. Таблица не загружена!';
          Synchronize(ShowMessage);
          Exit;
        end;
        try
          F.Seek(0,soFromBeginning);
          while F.Position < F.Size do
          begin
            if Terminated then Break;
            try
              try
                F.ReadBuffer(SwitchItem.SnapTime,SizeOf(SwitchItem.SnapTime));
                F.ReadBuffer(SwitchItem.Station,SizeOf(SwitchItem.Station));
                F.ReadBuffer(SwitchItem.Position,SizeOf(SwitchItem.Position));
                F.ReadBuffer(SwitchItem.Parameter,SizeOf(SwitchItem.Parameter));
                F.ReadBuffer(SwitchItem.OldValue,SizeOf(SwitchItem.OldValue));
                F.ReadBuffer(SwitchItem.NewValue,SizeOf(SwitchItem.NewValue));
                F.ReadBuffer(SwitchItem.Descriptor,SizeOf(SwitchItem.Descriptor));
              except
                Break;
              end;
              if InRange(SwitchItem.SnapTime,D1,D2) then
              begin
                if SwitchCashList.Length < High(SwitchCashList.Body) then
                begin
                  Inc(SwitchCashList.Length);
                  Count:=SwitchCashList.Length;
                  SwitchCashList.Body[SwitchCashList.Length]:=SwitchItem;
                end
                else
                begin
                  FMessage:='Достигнуто '+NumToStr(Count,'запис','ь','и','ей')+
                  '. Таблица загружена не полностью!';
                  Synchronize(ShowMessage);
                  ErrFlag:=True;
                  Break;
                end;
              end;
            except
              on E: Exception do
              begin
                FMessage:=E.Message;
                ErrFlag:=True;
                Break;
              end;
            end;
          end;
        finally
          F.Free;
        end;
      end;
      DS:=DS+OneHour;
      if ErrFlag then Break;
    end;
    Synchronize(AddIntoLog);
    if not ErrFlag then
    begin
      FMessage:=NumToStr(Count,'Загружен','а','о','о',False)+' '+
                NumToStr(Count,'запис','ь','и','ей')+'.';
      Synchronize(ShowMessage);
    end;
  finally
    SwitchLogSection.Leave;
  end;
end;

procedure TGetSingleSwitchLog.ShowMessage;
begin
  RemXForm.ShowMessage:=FMessage;
end;

{ TGetSingleChangeLog }

procedure TGetSingleChangeLog.AddIntoLog;
var Count: integer;
begin
  Screen.Cursor:=crHandPoint;
  try
    Move(ChangeCashList,Owner.ChangeData,SizeOf(Owner.ChangeData));
    Count:=Owner.ChangeData.Length;
    if Count > 0 then
      Owner.DrawGrid.RowCount:=Count+1
    else
      Owner.DrawGrid.RowCount:=2;
    if Owner.cbScrolling.Checked then
      Owner.DrawGrid.Row:=Owner.DrawGrid.RowCount-1;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

constructor TGetSingleChangeLog.Create(AOwner: TShowLogsForm;
  ACurrentLogsPath: string; AD1, AD2: TDateTime);
begin
  Owner:=AOwner;
  CurrentLogsPath:=ACurrentLogsPath;
  D1:=AD1;
  D2:=AD2;
  inherited Create(True);
  Priority:=tpLower; //tpHigher;
  FreeOnTerminate:=True;
end;

procedure TGetSingleChangeLog.Execute;
var DS,DE: TDateTime; hh,nn,ss,zz: word; ErrFlag: boolean;
    FileName,DirName: string; Count: integer;
    F: TFileStream;
begin
  ChangeCashList.Length:=0;
  ChangeLogSection.Enter;
  try
    DecodeTime(D1,hh,nn,ss,zz);
    DS:=Int(D1)+EncodeTime(hh,0,0,0);
    DecodeTime(D2,hh,nn,ss,zz);
    DE:=Int(D2)+EncodeTime(hh,59,59,999);
    ErrFlag:=False;
    Count:=0;
    while DS < DE do
    begin
      if Terminated then Exit;
      DirName:=CurrentLogsPath+FormatDateTime('\yymmdd\hh',DS);
      FileName:=IncludeTrailingPathDelimiter(DirName)+'CHANGES.LOG';
      if FileExists(FileName) then
      begin
        F:=TryOpenToReadFile(FileName);
        if not Assigned(F) then
        begin
          FMessage:='Файл "'+ExtractFileName(FileName)+
                    '" занят другим процессом. Таблица не загружена!';
          Synchronize(ShowMessage);
          Exit;
        end;
        try
          F.Seek(0,soFromBeginning);
          while F.Position < F.Size do
          begin
            if Terminated then Break;
            try
              try
                F.ReadBuffer(ChangeItem.SnapTime,SizeOf(ChangeItem.SnapTime));
                F.ReadBuffer(ChangeItem.Station,SizeOf(ChangeItem.Station));
                F.ReadBuffer(ChangeItem.Position,SizeOf(ChangeItem.Position));
                F.ReadBuffer(ChangeItem.Parameter,SizeOf(ChangeItem.Parameter));
                F.ReadBuffer(ChangeItem.OldValue,SizeOf(ChangeItem.OldValue));
                F.ReadBuffer(ChangeItem.NewValue,SizeOf(ChangeItem.NewValue));
                F.ReadBuffer(ChangeItem.Autor,SizeOf(ChangeItem.Autor));
                F.ReadBuffer(ChangeItem.Descriptor,SizeOf(ChangeItem.Descriptor));
              except
                Break;
              end;
              if InRange(ChangeItem.SnapTime,D1,D2) then
              begin
                if ChangeCashList.Length < High(ChangeCashList.Body) then
                begin
                  Inc(ChangeCashList.Length);
                  Count:=ChangeCashList.Length;
                  ChangeCashList.Body[ChangeCashList.Length]:=ChangeItem;
                end
                else
                begin
                  FMessage:='Достигнуто '+NumToStr(Count,'запис','ь','и','ей')+
                  '. Таблица загружена не полностью!';
                  Synchronize(ShowMessage);
                  ErrFlag:=True;
                  Break;
                end;
              end;
            except
              on E: Exception do
              begin
                FMessage:=E.Message;
                ErrFlag:=True;
                Break;
              end;
            end;
          end;
        finally
          F.Free;
        end;
      end;
      DS:=DS+OneHour;
      if ErrFlag then Break;
    end;
    Synchronize(AddIntoLog);
    if not ErrFlag then
    begin
      FMessage:=NumToStr(Count,'Загружен','а','о','о',False)+' '+
                NumToStr(Count,'запис','ь','и','ей')+'.';
      Synchronize(ShowMessage);
    end;
  finally
    ChangeLogSection.Leave;
  end;
end;

procedure TGetSingleChangeLog.ShowMessage;
begin
  RemXForm.ShowMessage:=FMessage;
end;

{ TGetSingleSystemLog }

procedure TGetSingleSystemLog.AddIntoLog;
var Count: integer;
begin
  Screen.Cursor:=crHandPoint;
  try
    Move(SystemCashList,Owner.SystemData,SizeOf(Owner.SystemData));
    Count:=Owner.SystemData.Length;
    if Count > 0 then
      Owner.DrawGrid.RowCount:=Count+1
    else
      Owner.DrawGrid.RowCount:=2;
    if Owner.cbScrolling.Checked then
      Owner.DrawGrid.Row:=Owner.DrawGrid.RowCount-1;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

constructor TGetSingleSystemLog.Create(AOwner: TShowLogsForm;
  ACurrentLogsPath: string; AD1, AD2: TDateTime);
begin
  Owner:=AOwner;
  CurrentLogsPath:=ACurrentLogsPath;
  D1:=AD1;
  D2:=AD2;
  inherited Create(True);
  Priority:=tpLower; //tpHigher;
  FreeOnTerminate:=True;
end;

procedure TGetSingleSystemLog.Execute;
var DS,DE: TDateTime; hh,nn,ss,zz: word; ErrFlag: boolean;
    FileName,DirName: string; Count: integer;
    F: TFileStream;
begin
  SystemCashList.Length:=0;
  SystemLogSection.Enter;
  try
    DecodeTime(D1,hh,nn,ss,zz);
    DS:=Int(D1)+EncodeTime(hh,0,0,0);
    DecodeTime(D2,hh,nn,ss,zz);
    DE:=Int(D2)+EncodeTime(hh,59,59,999);
    ErrFlag:=False;
    Count:=0;
    while DS < DE do
    begin
      if Terminated then Exit;
      DirName:=CurrentLogsPath+FormatDateTime('\yymmdd\hh',DS);
      FileName:=IncludeTrailingPathDelimiter(DirName)+'SYSMESS.LOG';
      if FileExists(FileName) then
      begin
        F:=TryOpenToReadFile(FileName);
        if not Assigned(F) then
        begin
          FMessage:='Файл "'+ExtractFileName(FileName)+
                    '" занят другим процессом. Таблица не загружена!';
          Synchronize(ShowMessage);
          Exit;
        end;
        try
          F.Seek(0,soFromBeginning);
          while F.Position < F.Size do
          begin
            if Terminated then Break;
            try
              try
                F.ReadBuffer(SystemItem.SnapTime,SizeOf(SystemItem.SnapTime));
                F.ReadBuffer(SystemItem.Station,SizeOf(SystemItem.Station));
                F.ReadBuffer(SystemItem.Position,SizeOf(SystemItem.Position));
                F.ReadBuffer(SystemItem.Descriptor,SizeOf(SystemItem.Descriptor));
              except
                Break;
              end;
              if InRange(SystemItem.SnapTime,D1,D2) then
              begin
                if SystemCashList.Length < High(SystemCashList.Body) then
                begin
                  Inc(SystemCashList.Length);
                  Count:=SystemCashList.Length;
                  SystemCashList.Body[SystemCashList.Length]:=SystemItem;
                end
                else
                begin
                  FMessage:='Достигнуто '+NumToStr(Count,'запис','ь','и','ей')+
                  '. Таблица загружена не полностью!';
                  Synchronize(ShowMessage);
                  ErrFlag:=True;
                  Break;
                end;
              end;
            except
              on E: Exception do
              begin
                FMessage:=E.Message;
                ErrFlag:=True;
                Break;
              end;
            end;
          end;
        finally
          F.Free;
        end;
      end;
      DS:=DS+OneHour;
      if ErrFlag then Break;
    end;
    Synchronize(AddIntoLog);
    if not ErrFlag then
    begin
      FMessage:=NumToStr(Count,'Загружен','а','о','о',False)+' '+
                NumToStr(Count,'запис','ь','и','ей')+'.';
      Synchronize(ShowMessage);
    end;
  finally
    SystemLogSection.Leave;
  end;
end;

procedure TGetSingleSystemLog.ShowMessage;
begin
  RemXForm.ShowMessage:=FMessage;
end;

procedure TShowLogsForm.btnExportCSVClick(Sender: TObject);
var ARow: Integer; LogName, S: string; T: TextFile;
begin
  SaveExtDialogForm:=TSaveExtDialogForm.Create(Self);
  try
    SaveExtDialogForm.Filter:='Текст для импорта в Microsoft Excel (*.csv)|*.csv';
    if SaveExtDialogForm.InitialDir = '' then
      SaveExtDialogForm.InitialDir:=Caddy.CurrentLogsPath;
    SaveExtDialogForm.FileName:='';
    SaveExtDialogForm.DefaultExt:='.csv';
    if SaveExtDialogForm.Execute then
    begin
      Update;
      Screen.Cursor:=crHourGlass;
      try
        LogName:=SaveExtDialogForm.FileName;
        if FileExists(LogName) then DeleteFile(LogName);
        AssignFile(T,LogName);
        try
          Rewrite(T);
          case TLogType(tcLogs.TabIndex) of
     ltAlarmLog:
            begin
              if (AlarmData.Length > 0) then
              begin
                Writeln(T,'Журнал "'+tcLogs.Tabs[tcLogs.TabIndex]+'"');
                Write(T,'Дата и время',';');
                Write(T,'Станция',';');
                Write(T,'Позиция',';');
                Write(T,'Параметр',';');
                Write(T,'Значение',';');
                Write(T,'Уставка',';');
                Write(T,'Сообщение',';');
                Writeln(T,'Дескриптор позиции');
                for ARow:=1 to AlarmData.Length do
                begin
                  S:=FormatDateTime('dd.mm.yy, ddd, hh:nn:ss.zzz',AlarmData.Body[ARow].SnapTime);
                  Write(T,S,';');
                  S:=Format('%d',[AlarmData.Body[ARow].Station]);
                  Write(T,S,';');
                  S:=AlarmData.Body[ARow].Position;
                  Write(T,S,';');
                  S:=AlarmData.Body[ARow].Parameter;
                  Write(T,S,';');
                  S:=AlarmData.Body[ARow].Value;
                  Write(T,S,';');
                  S:=AlarmData.Body[ARow].SetPoint;
                  Write(T,S,';');
                  S:=AlarmData.Body[ARow].Mess;
                  Write(T,S,';');
                  S:=AlarmData.Body[ARow].Descriptor;
                  Writeln(T,S);
                end;
              end;
            end;
     ltSwitchLog:
            begin
              if (SwitchData.Length > 0) then
              begin
                Writeln(T,'Журнал "'+tcLogs.Tabs[tcLogs.TabIndex]+'"');
                Write(T,'Дата и время',';');
                Write(T,'Станция',';');
                Write(T,'Позиция',';');
                Write(T,'Параметр',';');
                Write(T,'Было',';');
                Write(T,'Стало',';');
                Writeln(T,'Дескриптор позиции');
                for ARow:=1 to SwitchData.Length do
                begin
                  S:=FormatDateTime('dd.mm.yy, ddd, hh:nn:ss.zzz',SwitchData.Body[ARow].SnapTime);
                  Write(T,S,';');
                  S:=Format('%d',[SwitchData.Body[ARow].Station]);
                  Write(T,S,';');
                  S:=SwitchData.Body[ARow].Position;
                  Write(T,S,';');
                  S:=SwitchData.Body[ARow].Parameter;
                  Write(T,S,';');
                  S:=SwitchData.Body[ARow].OldValue;
                  Write(T,S,';');
                  S:=SwitchData.Body[ARow].NewValue;
                  Write(T,S,';');
                  S:=SwitchData.Body[ARow].Descriptor;
                  Writeln(T,S);
                end;
              end;
            end;
     ltChangeLog:
            begin
              if (ChangeData.Length > 0) then
              begin
                Writeln(T,'Журнал "'+tcLogs.Tabs[tcLogs.TabIndex]+'"');
                Write(T,'Дата и время',';');
                Write(T,'Станция',';');
                Write(T,'Позиция',';');
                Write(T,'Параметр',';');
                Write(T,'Было',';');
                Write(T,'Стало',';');
                Write(T,'Кто сделал',';');
                Writeln(T,'Дескриптор позиции');
                for ARow:=1 to ChangeData.Length do
                begin
                  S:=FormatDateTime('dd.mm.yy, ddd, hh:nn:ss.zzz',ChangeData.Body[ARow].SnapTime);
                  Write(T,S,';');
                  S:=Format('%d',[ChangeData.Body[ARow].Station]);
                  Write(T,S,';');
                  S:=ChangeData.Body[ARow].Position;
                  Write(T,S,';');
                  S:=ChangeData.Body[ARow].Parameter;
                  Write(T,S,';');
                  S:=ChangeData.Body[ARow].OldValue;
                  Write(T,S,';');
                  S:=ChangeData.Body[ARow].NewValue;
                  Write(T,S,';');
                  S:=ChangeData.Body[ARow].Autor;
                  Write(T,S,';');
                  S:=ChangeData.Body[ARow].Descriptor;
                  Writeln(T,S);
                end;
              end;
            end;
     ltSystemLog:
            begin
              if (SystemData.Length > 0) then
              begin
                Writeln(T,'Журнал "'+tcLogs.Tabs[tcLogs.TabIndex]+'"');
                Write(T,'Дата и время',';');
                Write(T,'Станция',';');
                Write(T,'Параметр',';');
                Writeln(T,'Сообщение');
                for ARow:=1 to SystemData.Length do
                begin
                  S:=FormatDateTime('dd.mm.yy, ddd, hh:nn:ss.zzz',SystemData.Body[ARow].SnapTime);
                  Write(T,S,';');
                  S:=Format('%d',[SystemData.Body[ARow].Station]);
                  Write(T,S,';');
                  S:=SystemData.Body[ARow].Position;
                  Write(T,S,';');
                  S:=SystemData.Body[ARow].Descriptor;
                  Writeln(T,S);
                end;
              end;
            end;
          end;
        finally
          CloseFile(T);
        end;

        RemXForm.ShowInfo('Журнал "'+tcLogs.Tabs[tcLogs.TabIndex]+
            '" успешно экспортирован в файл "'+ExtractFileName(LogName)+'"');
      finally
        Screen.Cursor:=crDefault;
      end;
    end;
  finally
    SaveExtDialogForm.Free;
  end;
end;

initialization
  AlarmLogSection:=TCriticalSection.Create;
  SwitchLogSection:=TCriticalSection.Create;
  ChangeLogSection:=TCriticalSection.Create;
  SystemLogSection:=TCriticalSection.Create;

finalization
  AlarmLogSection.Free;
  SwitchLogSection.Free;
  ChangeLogSection.Free;
  SystemLogSection.Free;

end.
