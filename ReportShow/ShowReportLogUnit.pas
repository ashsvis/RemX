unit ShowReportLogUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, ToolWin, ActnList, ImgList, Grids,
  FR_Class, EntityUnit, Menus, AppEvnts, PanelFormUnit;

type
  TCashReportLogArray = record
                          Body: array[1..1000] of TCashReportItem;
                          Length: integer;
                        end;

  TShowReportLogsForm = class(TForm)
    ToolBar2: TToolBar;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ActionList1: TActionList;
    ImageList: TImageList;
    ToolButton2: TToolButton;
    tbLessTime: TToolButton;
    tbTimeSelect: TToolButton;
    tbMoreTime: TToolButton;
    tbFresh: TToolButton;
    actPrintSavedReport: TAction;
    actPreviewSavedReport: TAction;
    actPrevPeriod: TAction;
    actNextPeriod: TAction;
    DrawGrid: TDrawGrid;
    frReportView: TfrReport;
    ToolButton1: TToolButton;
    TimePopupMenu: TPopupMenu;
    ApplicationEvents: TApplicationEvents;
    procedure FormResize(Sender: TObject);
    procedure DrawGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure tbTimeSelectClick(Sender: TObject);
    procedure tbFreshClick(Sender: TObject);
    procedure actNextPeriodExecute(Sender: TObject);
    procedure actPrevPeriodExecute(Sender: TObject);
    procedure actPreviewSavedReportExecute(Sender: TObject);
    procedure actPreviewSavedReportUpdate(Sender: TObject);
    procedure actPrintSavedReportUpdate(Sender: TObject);
    procedure actPrintSavedReportExecute(Sender: TObject);
    procedure DrawGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tbFilterClick(Sender: TObject);
    procedure DrawGridMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TimePopupMenuPopup(Sender: TObject);
    procedure ShowThreadMessage(Sender: TObject; Mess: string);
    procedure ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
    procedure actPrevPeriodUpdate(Sender: TObject);
    procedure actNextPeriodUpdate(Sender: TObject);
  private
    ReportLogLoading: boolean;
    Filtered: boolean;
    ShiftTime: TDateTime;
    FirstSnap,LastSnap: TDateTime;
    CurrentTimeIndex: integer;
    LastRow: integer;
    FPanel: TPanelForm;
    procedure ReloadReportLog;
    procedure ReportLogLoaded(Sender: TObject);
    procedure SaveConfig(Path: string);
    function GetShiftTime(Index: integer): TDateTime;
  public
    Data: TCashReportLogArray;
    StartTime: TDateTime;
    procedure LoadConfig(Path: string);
    procedure UpdateTimeRange;
    property Panel: TPanelForm read FPanel write FPanel;
  end;

  TGetSingleReport = class(TThread)
  private
    Owner: TShowReportLogsForm;
    ReportItem: TCashReportItem;
    FMessage,CurrentReportsPath: string;
    D1,D2: TDateTime;
    ReportCashList: TCashReportLogArray;
    procedure ShowMessage;
    procedure AddIntoReportLog;
  protected
    procedure Execute; override;
  public
    constructor Create(AOwner: TShowReportLogsForm;
                       ACurrentReportsPath: string; AD1,AD2: TDateTime);
  end;

var
  ShowReportLogsForm: TShowReportLogsForm;

implementation

uses StrUtils, DateUtils, SyncObjs,
     Printers, ThreadSaveUnit, Math, TimeFilterUnit,
  RemXUnit, PrintDialogUnit;

{$R *.dfm}

var RealReportsSection: TCriticalSection;

{ TGetSingleReport }

procedure TGetSingleReport.AddIntoReportLog;
var Count: integer;
begin
  Screen.Cursor:=crHandPoint;
  try
    Move(ReportCashList,Owner.Data,SizeOf(Owner.Data));
    Count:=ReportCashList.Length;
    if Count > 0 then
      Owner.DrawGrid.RowCount:=Count+1
    else
      Owner.DrawGrid.RowCount:=2;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

constructor TGetSingleReport.Create(AOwner: TShowReportLogsForm;
           ACurrentReportsPath: string; AD1,
           AD2: TDateTime);
begin
  Owner:=AOwner;
  CurrentReportsPath:=ACurrentReportsPath;
  D1:=AD1;
  D2:=AD2;
  inherited Create(True);
  Priority:=tpLower; //tpHigher;
  FreeOnTerminate:=True;
end;

procedure TGetSingleReport.Execute;
var DS,DE: TDateTime; hh,nn,ss,zz: word; ErrFlag: boolean;
    FileName,DirName: string;
    F: TFileStream; MS: Int64; A: array of Byte;
begin
  Sleep(1);
  ReportCashList.Length:=0;
  RealReportsSection.Enter;
  try
    DecodeTime(D1,hh,nn,ss,zz);
    DS:=Int(D1)+EncodeTime(hh,0,0,0);
    DecodeTime(D2,hh,nn,ss,zz);
    DE:=Int(D2)+EncodeTime(hh,59,59,999);
    ErrFlag:=False;
    while DS < DE do
    begin
      if Terminated then Exit;
      DirName:=CurrentReportsPath+FormatDateTime('\yymmdd',DS);
      FileName:=IncludeTrailingPathDelimiter(DirName)+'PREPRD'+FormatDateTime('hh',DS)+'.LOG';
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
                F.ReadBuffer(ReportItem.SnapTime,SizeOf(ReportItem.SnapTime));
                F.ReadBuffer(ReportItem.Station,SizeOf(ReportItem.Station));
                F.ReadBuffer(ReportItem.HandStart,SizeOf(ReportItem.HandStart));
                F.ReadBuffer(ReportItem.Category,SizeOf(ReportItem.Category));
                F.ReadBuffer(ReportItem.Descriptor,SizeOf(ReportItem.Descriptor));
                F.ReadBuffer(MS,SizeOf(MS));
              except
                Break;
              end;
              SetLength(A,MS);
              F.ReadBuffer(A[0],Length(A));
              if ReportCashList.Length < High(ReportCashList.Body) then
              begin
                if InRange(ReportItem.SnapTime,D1,D2) then
                begin
                  Inc(ReportCashList.Length);
                  ReportCashList.Body[ReportCashList.Length]:=ReportItem;
                end;
              end
              else
              begin
                FMessage:='Достигнуто '+NumToStr(ReportCashList.Length,'запис','ь','и','ей')+
                '. Таблица загружена не полностью!';
                Synchronize(ShowMessage);
                ErrFlag:=True;
                Break;
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
    Synchronize(AddIntoReportLog);
    if not ErrFlag then
    begin
      FMessage:=NumToStr(ReportCashList.Length,'Загружен','а','о','о',False)+' '+
                NumToStr(ReportCashList.Length,'запис','ь','и','ей')+'.';
      Synchronize(ShowMessage);
    end;
  finally
    RealReportsSection.Leave;
  end;
end;

procedure TGetSingleReport.ShowMessage;
begin
  RemXForm.ShowMessage:=FMessage;
end;

{ TShowReportLogsForm }

procedure TShowReportLogsForm.FormResize(Sender: TObject);
var i,sum: integer;
begin
  DrawGrid.DefaultRowHeight:=24;
  DrawGrid.Font.Size:=12;
  DrawGrid.ColWidths[0]:=190;
  DrawGrid.ColWidths[1]:=75;
  DrawGrid.ColWidths[2]:=130;
  DrawGrid.ColWidths[3]:=200;
  sum:=0; for i:=0 to 3 do sum:=sum+DrawGrid.ColWidths[i];
  DrawGrid.ColWidths[4]:=DrawGrid.Width-sum-GetSystemMetrics(SM_CXVSCROLL)-8;
end;

procedure TShowReportLogsForm.DrawGridDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var S: string;
begin
  InflateRect(Rect,-4,0);
  with DrawGrid.Canvas do
  begin
    if ARow = 0 then
    begin
      case ACol of
        0: begin
             S:='Дата и время';
             if Filtered then
             begin
               ImageList.Draw(DrawGrid.Canvas,Rect.Right-16,
                              Rect.Top+(Rect.Bottom-Rect.Top-16) div 2,2);
               Brush.Style:=bsClear;
             end;
           end;
        1: S:='Ст.';
        2: S:='Режим';
        3: S:='Категория';
        4: S:='Описание содержимого отчета';
      else
        S:='';
      end;
      if ACol = 4 then
        DrawText(Handle,PChar(S),Length(S),Rect,DT_LEFT+DT_VCENTER+DT_SINGLELINE)
      else
        DrawText(Handle,PChar(S),Length(S),Rect,DT_CENTER+DT_VCENTER+DT_SINGLELINE);
      if Filtered then
        Brush.Style:=bsSolid;
    end
    else
    begin
      if Data.Length > 0 then
      case ACol of
       0: S:=FormatDateTime('dd.mm.yy, ddd, hh:nn:ss',Data.Body[ARow].SnapTime);
       1: S:=Format('%d',[Data.Body[ARow].Station]);
       2: S:=IfThen(Data.Body[ARow].HandStart,'Ручной','Авто');
       3: S:=Data.Body[ARow].Category;
       4: S:=Data.Body[ARow].Descriptor;
      else
        S:='';
      end;
      case ACol of
       1,2: DrawText(Handle,PChar(S),Length(S),Rect,DT_CENTER+DT_VCENTER+DT_SINGLELINE);
      else
        DrawText(Handle,PChar(S),Length(S),Rect,DT_LEFT+DT_VCENTER+DT_SINGLELINE);
      end;
    end;
  end;
end;

procedure TShowReportLogsForm.FormCreate(Sender: TObject);
var SL: TStringList; i: integer; M: TMenuItem;
begin
  CurrentTimeIndex:=6;
  with RemXForm do
    frReportView.OnBeginDoc:=FastReportBeginDoc;
  SL:=TStringList.Create;
  try
    SL.Add('24 часа');
    SL.Add('48 часов');
    SL.Add('72 часа');
    SL.Add('1 неделя');
    SL.Add('2 недели');
    SL.Add('3 недели');
    SL.Add('4 недели');
    for i:=0 to SL.Count-1 do
    begin
      M:=TMenuItem.Create(Self);
      M.Caption:=SL[i];
      M.GroupIndex:=1;
      M.AutoCheck:=True;
      M.Tag:=i;
      M.OnClick:=tbTimeSelectClick;
      TimePopupMenu.Items.Add(M);
    end;
  finally
    SL.Free;
  end;
end;

procedure TShowReportLogsForm.ReloadReportLog;
var D1,D2: TDateTime;
begin
  if ReportLogLoading then Exit;
  Data.Length:=0;
  ReportLogLoading:=True;
  LastRow:=DrawGrid.Row;
  DrawGrid.RowCount:=2;
  DrawGrid.Invalidate;
  DrawGrid.Cursor:=crHourGlass;
  D2:=StartTime;
  D1:=D2-ShiftTime;
  Screen.Cursor:=crHourGlass;
  with TGetSingleReport.Create(Self,Caddy.CurrentReportsLogPath,D1,D2) do
  begin
    OnTerminate:=ReportLogLoaded;
    Resume;
  end;
  SaveConfig('ReportLogView');
end;

procedure TShowReportLogsForm.ReportLogLoaded(Sender: TObject);
begin
  ReportLogLoading:=False;
  DrawGrid.Invalidate;
  DrawGrid.Cursor:=crDefault;
  if LastRow < DrawGrid.RowCount then
    DrawGrid.Row:=LastRow;
end;

procedure TShowReportLogsForm.SaveConfig(Path: string);
begin
  Config.WriteDateTime(Path,'ReportLogDate',StartTime);
  Config.WriteInteger(Path,'ReportLogTime',CurrentTimeIndex);
// Запись изменений на диск
  ConfigUpdateFile(Config);
end;

procedure TShowReportLogsForm.tbTimeSelectClick(Sender: TObject);
begin
  if ReportLogLoading then Exit;
  DrawGrid.Update;
  if Sender is TMenuItem then
  with Sender as TMenuItem do
  begin
    Checked:=True;
    CurrentTimeIndex:=Tag;
    tbTimeSelect.Caption:=Caption;
  end;
  StartTime:=Now;
  ShiftTime:=GetShiftTime(CurrentTimeIndex);
  UpdateTimeRange;
  Filtered:=False;
  ReloadReportLog;
end;

function TShowReportLogsForm.GetShiftTime(Index: integer): TDateTime;
begin
  case CurrentTimeIndex of
    1: Result:=2.0;
    2: Result:=3.0;
    3: Result:=7.0;
    4: Result:=14.0;
    5: Result:=21.0;
    6: Result:=28.0;
  else
    Result:=1.0;
  end;
end;

procedure TShowReportLogsForm.LoadConfig(Path: string);
begin
  StartTime:=Config.ReadDateTime(Path,'ReportLogDate',Now);
  CurrentTimeIndex:=Config.ReadInteger(Path,'ReportLogTime',0);
  if CurrentTimeIndex > 6 then CurrentTimeIndex:=6;
  ShiftTime:=GetShiftTime(CurrentTimeIndex);
  tbTimeSelect.Caption:=TimePopupMenu.Items.Items[CurrentTimeIndex].Caption;
  tbTimeSelectClick(TimePopupMenu.Items[CurrentTimeIndex]);
end;

procedure TShowReportLogsForm.UpdateTimeRange;
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

procedure TShowReportLogsForm.tbFreshClick(Sender: TObject);
begin
  if ReportLogLoading then Exit;
  DrawGrid.Update;
  UpdateTimeRange;
  ReloadReportLog;
end;

procedure TShowReportLogsForm.actNextPeriodExecute(Sender: TObject);
var D1,D2: TDateTime;
begin
  if ReportLogLoading then Exit;
  ReportLogLoading:=True;
  StartTime:=StartTime+ShiftTime;
  D2:=StartTime;
  D1:=D2-ShiftTime;
  Screen.Cursor:=crHourGlass;
  with TGetSingleReport.Create(Self,Caddy.CurrentReportsLogPath,D1,D2) do
  begin
    OnTerminate:=ReportLogLoaded;
    Resume;
  end;
end;

procedure TShowReportLogsForm.actPrevPeriodExecute(Sender: TObject);
var D1,D2: TDateTime;
begin
  if ReportLogLoading then Exit;
  ReportLogLoading:=True;
  StartTime:=StartTime-ShiftTime;
  D2:=StartTime;
  D1:=D2-ShiftTime;
  Screen.Cursor:=crHourGlass;
  with TGetSingleReport.Create(Self,Caddy.CurrentReportsLogPath,D1,D2) do
  begin
    OnTerminate:=ReportLogLoaded;
    Resume;
  end;
end;

procedure TShowReportLogsForm.actPreviewSavedReportExecute(Sender: TObject);
var i: integer; DirName,FileName: string; F: TFileStream; M: TMemoryStream;
    ReportItem: TCashReportItem; MS: Int64; A: array of Byte;
begin
  Printer.Refresh;
  if Printer.Printers.Count = 0 then
  begin
    RemxForm.ShowError('Нет установленных принтеров в системе.');
    Exit;
  end;
  actPreviewSavedReport.Enabled:=False;
  try
  i:=DrawGrid.Row-1;
  DirName:=Caddy.CurrentReportsLogPath+FormatDateTime('\yymmdd',Data.Body[i+1].SnapTime);
  FileName:=IncludeTrailingPathDelimiter(DirName)+'PREPRD'+
               FormatDateTime('hh',Data.Body[i+1].SnapTime)+'.LOG';
  if FileExists(FileName) then
  begin
    F:=TryOpenToReadFile(FileName);
    if not Assigned(F) then
    begin
      RemXForm.ShowError('Файл "'+ExtractFileName(FileName)+
                '" занят другим процессом. Таблица не загружена!');
      Exit;
    end;
    try
      F.Seek(0,soFromBeginning);
      while F.Position < F.Size do
      begin
        if Application.Terminated then Break;
        try
          F.ReadBuffer(ReportItem.SnapTime,SizeOf(ReportItem.SnapTime));
          F.ReadBuffer(ReportItem.Station,SizeOf(ReportItem.Station));
          F.ReadBuffer(ReportItem.HandStart,SizeOf(ReportItem.HandStart));
          F.ReadBuffer(ReportItem.Category,SizeOf(ReportItem.Category));
          F.ReadBuffer(ReportItem.Descriptor,SizeOf(ReportItem.Descriptor));
          F.ReadBuffer(MS,SizeOf(MS));
          SetLength(A,MS);
          F.ReadBuffer(A[0],MS);
          if (ReportItem.SnapTime = Data.Body[i+1].SnapTime) and
             (ReportItem.Station = Data.Body[i+1].Station) and
             (ReportItem.HandStart = Data.Body[i+1].HandStart) and
             (ReportItem.Category = Data.Body[i+1].Category) and
             (ReportItem.Descriptor = Data.Body[i+1].Descriptor) then
          begin
            Panel.acPreview.Execute;
            Panel.ShowPreviewForm.MasterAction:=Panel.actReportLogs;
            frReportView.Preview:=Panel.ShowPreviewForm.frAllPreview;
            M:=TMemoryStream.Create;
            try
              M.WriteBuffer(A[0],MS);
              M.Position:=0;
              frReportView.Clear;
              frReportView.LoadFromResourceName(HInstance,'ResetReport');
              frReportView.PrepareReport;
              frReportView.EMFPages.LoadFromStream(M);
              frReportView.CanRebuild:=False;
            finally
              M.Free;
            end;
            frReportView.ShowPreparedReport;
            Panel.ShowPreviewForm.Show;
            Break;
          end;
        except
          on E: Exception do
          begin
            RemXForm.ShowError(E.Message);
            Panel.actReportLogs.Execute;
            Break;
          end;
        end;
      end;
    finally
      F.Free;
    end;
  end;
  finally
    actPreviewSavedReport.Enabled:=True;
  end;
end;

procedure TShowReportLogsForm.actPreviewSavedReportUpdate(Sender: TObject);
begin
  actPreviewSavedReport.Enabled:=(Data.Length > 0) and not ReportLogLoading;
end;

procedure TShowReportLogsForm.actPrintSavedReportUpdate(Sender: TObject);
begin
  actPrintSavedReport.Enabled:=(Data.Length > 0) and not ReportLogLoading;
end;

procedure TShowReportLogsForm.actPrintSavedReportExecute(Sender: TObject);
var i: integer; DirName,FileName: string; F: TFileStream; M: TMemoryStream;
    ReportItem: TCashReportItem; MS: Int64; A: array of Byte;
begin
  actPrintSavedReport.Enabled:=False;
  PrintDialogForm:=TPrintDialogForm.Create(Self);
  try
    i:=DrawGrid.Row-1;
    DirName:=Caddy.CurrentReportsLogPath+
             FormatDateTime('\yymmdd',Data.Body[i+1].SnapTime);
    FileName:=IncludeTrailingPathDelimiter(DirName)+
              'PREPRD'+FormatDateTime('hh',Data.Body[i+1].SnapTime)+'.LOG';
    if FileExists(FileName) then
    begin
      F:=TryOpenToReadFile(FileName);
      if not Assigned(F) then
      begin
        RemXForm.ShowError('Файл "'+ExtractFileName(FileName)+
                  '" занят другим процессом. Таблица не загружена!');
        Exit;
      end;
      try
        F.Seek(0,soFromBeginning);
        while F.Position < F.Size do
        begin
          if Application.Terminated then Break;
          try
            F.ReadBuffer(ReportItem.SnapTime,SizeOf(ReportItem.SnapTime));
            F.ReadBuffer(ReportItem.Station,SizeOf(ReportItem.Station));
            F.ReadBuffer(ReportItem.HandStart,SizeOf(ReportItem.HandStart));
            F.ReadBuffer(ReportItem.Category,SizeOf(ReportItem.Category));
            F.ReadBuffer(ReportItem.Descriptor,SizeOf(ReportItem.Descriptor));
            F.ReadBuffer(MS,SizeOf(MS));
            SetLength(A,MS);
            F.ReadBuffer(A[0],MS);
            if (ReportItem.SnapTime = Data.Body[i+1].SnapTime) and
               (ReportItem.Station = Data.Body[i+1].Station) and
               (ReportItem.HandStart = Data.Body[i+1].HandStart) and
               (ReportItem.Category = Data.Body[i+1].Category) and
               (ReportItem.Descriptor = Data.Body[i+1].Descriptor) then
            begin
              M:=TMemoryStream.Create;
              try
                M.WriteBuffer(A[0],MS);
                M.Position:=0;
                frReportView.Clear;
                frReportView.LoadFromResourceName(HInstance,'ResetReport');
                frReportView.PrepareReport;
                frReportView.EMFPages.LoadFromStream(M);
                frReportView.Title:=Data.Body[i+1].Descriptor;
                frReportView.CanRebuild:=False;
              finally
                M.Free;
              end;
              PrintDialogForm.FromPage:=1;
              PrintDialogForm.ToPage:=frReportView.EMFPages.Count;
              if PrintDialogForm.Execute then
              begin
                if PrintDialogForm.PrintRange = prAllPages then
                  frReportView.PrintPreparedReport('',PrintDialogForm.Copies,
                                            PrintDialogForm.Collate,frAll)
                else
                if PrintDialogForm.PrintRange = prPageNums then
                  frReportView.PrintPreparedReport(Format('%d-%d',
                            [PrintDialogForm.FromPage,PrintDialogForm.ToPage]),
                         PrintDialogForm.Copies,PrintDialogForm.Collate,frAll);
              end;
              Break;
            end;
          except
            on E: Exception do
            begin
              RemXForm.ShowError(E.Message);
              Break;
            end;
          end;
        end;
      finally
        F.Free;
      end;
    end;
  finally
    PrintDialogForm.Free;
    actPrintSavedReport.Enabled:=True;
  end;
end;

procedure TShowReportLogsForm.DrawGridMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var ACol,ARow: integer;
begin
  if Button = mbLeft then
  begin
    DrawGrid.MouseToCell(X,Y,ACol,ARow);
    if (ACol = 0) and (ARow = 0) then tbFilterClick(Sender);
  end;
end;

procedure TShowReportLogsForm.tbFilterClick(Sender: TObject);
var  Result: TModalResult;
begin
  if ReportLogLoading then Exit;
  TimeFilterForm:=TTimeFilterForm.Create(Self);
  try
    with RemXForm, TimeFilterForm do
    begin
      dtBeginDate.DateTime:=Config.ReadDate('TimeFilter',
                                 'BeginDate',Int(Now-1.0));
      dtBeginTime.DateTime:=Config.ReadTime('TimeFilter',
                                 'BeginTime',Frac(Now-1.0));
      dtEndDate.DateTime:=Config.ReadDate('TimeFilter',
                                 'EndDate',Int(Now));
      dtEndTime.DateTime:=Config.ReadTime('TimeFilter',
                                 'EndTime',Frac(Now));
      Result:=ShowModal;
      if Result = mrOk then
      begin
        FirstSnap:=Int(dtBeginDate.DateTime)+Frac(dtBeginTime.DateTime);
        LastSnap:=Int(dtEndDate.DateTime)+Frac(dtEndTime.DateTime);
        Config.WriteDate('TimeFilter','BeginDate',Int(FirstSnap));
        Config.WriteTime('TimeFilter','BeginTime',Frac(FirstSnap));
        Config.WriteDate('TimeFilter','EndDate',Int(LastSnap));
        Config.WriteTime('TimeFilter','EndTime',Frac(LastSnap));
        Filtered:=True;
        StartTime:=LastSnap;
        ShiftTime:=LastSnap-FirstSnap;
        UpdateTimeRange;
        DrawGrid.Row:=1;
        ReloadReportLog;
      end
      else
      if Result = mrAbort then
      begin
        Filtered:=False;
        tbFresh.Click;
      end
      else
        Exit;
    end;
  finally
    TimeFilterForm.Free;
  end;
end;

procedure TShowReportLogsForm.DrawGridMouseMove(Sender: TObject;
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

procedure TShowReportLogsForm.TimePopupMenuPopup(Sender: TObject);
var i: integer;
begin
  for i:=0 to TimePopupMenu.Items.Count-1 do
    TimePopupMenu.Items.Items[i].Checked:=False;
  TimePopupMenu.Items.Items[CurrentTimeIndex].Checked:=True;
end;

procedure TShowReportLogsForm.ShowThreadMessage(Sender: TObject;
  Mess: string);
begin
  RemXForm.ShowMessage:=Mess;
end;

procedure TShowReportLogsForm.ApplicationEventsIdle(Sender: TObject;
  var Done: Boolean);
begin
  tbLessTime.Enabled:=not ReportLogLoading;
  tbTimeSelect.Enabled:=not ReportLogLoading;
  tbMoreTime.Enabled:=not ReportLogLoading;
  DrawGrid.Enabled:=not ReportLogLoading;
  tbFresh.Enabled:=not ReportLogLoading;
end;

procedure TShowReportLogsForm.actPrevPeriodUpdate(Sender: TObject);
begin
  actPrevPeriod.Enabled:=not ReportLogLoading;
end;

procedure TShowReportLogsForm.actNextPeriodUpdate(Sender: TObject);
begin
  actNextPeriod.Enabled:=not ReportLogLoading;
end;

initialization
  RealReportsSection:=TCriticalSection.Create;

finalization
  RealReportsSection.Free;

end.
