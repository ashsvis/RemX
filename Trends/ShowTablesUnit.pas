unit ShowTablesUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ComCtrls, ExtCtrls,
  ToolWin, ImgList, Menus, StdCtrls, EntityUnit, AppEvnts, Grids, FR_DSet,
  FR_Class, PanelFormUnit;

type
  TCashTrendTableArray = record
                           Body: array[1..15000] of TCashTrendTableItem;
                           Length: integer;
                         end;
  TShowTablesForm = class(TForm)
    ToolBar: TToolBar;
    ToolButton1: TToolButton;
    ToolButton3: TToolButton;
    LogsActionList: TActionList;
    actPrint: TAction;
    LogsImageList: TImageList;
    ToolButton2: TToolButton;
    actPrev: TAction;
    actNext: TAction;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    tbGroupNo: TToolButton;
    GroupNamePanel: TPanel;
    pmGroupSelect: TPopupMenu;
    tbLessTime: TToolButton;
    tbTimeSelect: TToolButton;
    tbMoreTime: TToolButton;
    ScrollingPanel: TPanel;
    cbScrolling: TCheckBox;
    tcTables: TTabControl;
    TimePopupMenu: TPopupMenu;
    DrawGrid: TDrawGrid;
    tbPreview: TToolButton;
    actPreview: TAction;
    frTableReport: TfrReport;
    frUserTableDataset: TfrUserDataset;
    ApplicationEvents: TApplicationEvents;
    pmColumnClick: TPopupMenu;
    miPasport: TMenuItem;
    miBase: TMenuItem;
    actExportToExcel: TAction;
    tbExport: TToolButton;
    btnExportCSV: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure tbTime0Click(Sender: TObject);
    procedure frTableReportBeginPage(pgNo: Integer);
    procedure actPrevUpdate(Sender: TObject);
    procedure actPrevExecute(Sender: TObject);
    procedure actNextUpdate(Sender: TObject);
    procedure actNextExecute(Sender: TObject);
    procedure actPreviewExecute(Sender: TObject);
    procedure actPrintExecute(Sender: TObject);
    procedure GroupSelectClick(Sender: TObject);
    procedure pmGroupSelectPopup(Sender: TObject);
    procedure TimePopupMenuPopup(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure DrawGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure cbScrollingClick(Sender: TObject);
    procedure tbLessTimeClick(Sender: TObject);
    procedure tbMoreTimeClick(Sender: TObject);
    procedure tcTablesChange(Sender: TObject);
    procedure tcTablesChanging(Sender: TObject; var AllowChange: Boolean);
    procedure frTableReportGetValue(const ParName: String;
      var ParValue: Variant);
    procedure tbFilterClick(Sender: TObject);
    procedure DrawGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DrawGridMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ShowThreadMessage(Sender: TObject; Mess: string);
    procedure DrawGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
    procedure actPrintUpdate(Sender: TObject);
    procedure actPreviewUpdate(Sender: TObject);
    procedure pmColumnClickPopup(Sender: TObject);
    procedure miPasportClick(Sender: TObject);
    procedure miBaseClick(Sender: TObject);
    procedure actExportToExcelExecute(Sender: TObject);
    procedure btnExportCSVClick(Sender: TObject);
  private
    StartTime,ShiftTime: TDateTime;
    FGroupToShow: integer;
    Filtered: boolean;
    FirstSnap,LastSnap: TDateTime;
    NumPages: integer;
    AM: array[0..4] of TMenuItem;
    LastRow: array[TTableType] of integer;
    PathToSave: string;
    FPanel: TPanelForm;
    procedure SetGroupToShow(const Value: integer);
    procedure UpdateColumnNames;
    function GetShiftTime(Index: integer): TDateTime;
    procedure ReloadTable;
    procedure SaveConfig(Path: string);
    procedure TableLoaded(Sender: TObject);
  public
    Data: TCashTrendTableArray;
    TableLoading: boolean;
    CurrentTimeIndex: integer;
    procedure AfterShow;
    property GroupToShow: integer read FGroupToShow write SetGroupToShow;
    procedure LoadConfig(Path: string);
    procedure UpdateTimeRange;
    procedure UpdateTableView;
    property Panel: TPanelForm read FPanel write FPanel;
  end;

  TGetSingleTable = class(TThread)
  private
    Item: TCashTrendTableItem;
    FMessage,CurrentTablePath: string;
    TableType: TTableType;
    D1,D2: TDateTime;
    GroupIndex: Integer;
    CashList: TCashTrendTableArray;
    Owner: TShowTablesForm;
    procedure ShowMessage;
    procedure AddIntoTable;
  protected
    procedure Execute; override;
  public
    constructor Create(AOwner: TShowTablesForm;
                       ACurrentTablePath: string; TheTableType: TTableType;
                       AD1,AD2: TDateTime; AGroupIndex: integer);
  end;

var
  ShowTablesForm: TShowTablesForm;

implementation

uses TimeFilterUnit, Printers, DateUtils,
     ThreadSaveUnit, SyncObjs, Math, RemXUnit,
     PrintDialogUnit, SaveExtDialogUnit, ComObj;

{$R *.dfm}

var
  GetSingleTableSection: array[1..125] of TCriticalSection;

{ TGetSingleTable }

procedure TGetSingleTable.AddIntoTable;
var Count: integer;
begin
  Screen.Cursor:=crHandPoint;
  try
    with Owner do
    begin
      Move(CashList,Data,SizeOf(Data));
      Count:=CashList.Length;
      if Count > 0 then
        DrawGrid.RowCount:=Count+1
      else
       DrawGrid.RowCount:=2;
      if cbScrolling.Checked then DrawGrid.Row:=DrawGrid.RowCount-1;
    end;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

constructor TGetSingleTable.Create(AOwner: TShowTablesForm;
      ACurrentTablePath: string;
      TheTableType: TTableType; AD1,AD2: TDateTime; AGroupIndex: integer);
begin
  Owner:=AOwner;
  CurrentTablePath:=ACurrentTablePath;
  TableType:=TheTableType;
  D1:=AD1;
  D2:=AD2;
  GroupIndex:=AGroupIndex;
  inherited Create(True);
  Priority:=tpHigher;
  FreeOnTerminate:=True;
end;

procedure TGetSingleTable.Execute;
var DS,DE: TDateTime; hh,nn,ss,zz: word; ErrFlag: boolean;
    FileName,DirName: string; i,j: integer; F: TFileStream;
begin
//  Sleep(1);
  CashList.Length:=0;
  GetSingleTableSection[GroupIndex].Enter;
  try
    DecodeTime(D1,hh,nn,ss,zz);
    DS:=Int(D1)+EncodeTime(hh,0,0,0);
    DecodeTime(D2,hh,nn,ss,zz);
    DE:=Int(D2)+EncodeTime(hh,59,59,999);
    ErrFlag:=False;
    while DS < DE do
    begin
      if Terminated then Exit;
      DirName:=IncludeTrailingPathDelimiter(CurrentTablePath)+ATableType[TableType]+
               FormatDateTime('\yymmdd\hh',DS);
      FileName:=IncludeTrailingPathDelimiter(DirName)+Format('%3.3d.TBL',[GroupIndex]);
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
                F.ReadBuffer(Item.SnapTime,SizeOf(Item.SnapTime));
                for i:=1 to 8 do
                begin
                  F.ReadBuffer(Item.Val[i],SizeOf(Item.Val[i]));
                  F.ReadBuffer(Item.Quality[i],SizeOf(Item.Quality[i]));
                end;
              except
                Break;
              end;
              if InRange(Item.SnapTime,D1,D2) then
              begin
                if CashList.Length < High(CashList.Body) then
                begin
                  Inc(CashList.Length);
                  CashList.Body[CashList.Length].SnapTime:=Item.SnapTime;
                  CashList.Body[CashList.Length].GroupNo:=GroupIndex;
                  for j:=1 to 8 do
                  begin
                    CashList.Body[CashList.Length].Val[j]:=Item.Val[j];
                    CashList.Body[CashList.Length].Quality[j]:=Item.Quality[j]
                  end;
                end
                else
                begin
                  FMessage:='Достигнуто '+
                    NumToStr(CashList.Length,'запис','ь','и','ей')+
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
    Synchronize(AddIntoTable);
    if not ErrFlag then
    begin
      FMessage:=NumToStr(CashList.Length,'Загружен','а','о','о',False)+' '+
                NumToStr(CashList.Length,'запис','ь','и','ей')+'.';
      Synchronize(ShowMessage);
    end;
  finally
    GetSingleTableSection[GroupIndex].Leave;
  end;
end;

procedure TGetSingleTable.ShowMessage;
begin
  RemXForm.ShowMessage:=FMessage;
end;

{ TShowTablesForm }

procedure TShowTablesForm.FormCreate(Sender: TObject);
var i: integer; M: TMenuItem; S: string; SL: TStringList;
begin
  PathToSave := 'TableView';
  Data.Length:=0;
  CurrentTimeIndex:=0;
  StartTime:=Now;
  GroupToShow:=1;
  for i:=0 to 4 do
  begin
    AM[i]:=TMenuItem.Create(Self);
    AM[i].Caption:=Format('Группы с %d по %d',[i*25+1,(i+1)*25]);
    pmGroupSelect.Items.Add(AM[i]);
  end;
  for i:=1 to 125 do
  begin
    if not Caddy.HistGroups[i].Empty then
    begin
      S:=Trim(Caddy.HistGroups[i].GroupName);
      if S = '' then S:='(без названия)';
      M:=TMenuItem.Create(Self);
      M.Caption:=Format('Группа №%d - %s',[i,S]);
      M.Tag:=i;
      M.OnClick:=GroupSelectClick;
      AM[(i-1) div 25].Add(M);
    end;
  end;
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

procedure TShowTablesForm.FormResize(Sender: TObject);
var i,w: integer;
begin
  DrawGrid.DefaultRowHeight:=24;
  DrawGrid.Font.Size:=12;
  DrawGrid.Font.Name:='Tahoma';
  DrawGrid.RowHeights[0]:=DrawGrid.Canvas.TextHeight('Xy')*2+13;
  DrawGrid.ColWidths[0]:=152;
  w := Trunc((DrawGrid.ClientWidth-DrawGrid.ColWidths[0]-
        GetSystemMetrics(SM_CXVSCROLL)) / 8);
  for i:=1 to 8 do DrawGrid.ColWidths[i] := w;
  DrawGrid.ColWidths[0] := DrawGrid.ClientWidth-w*8-10;
end;

procedure TShowTablesForm.tbTime0Click(Sender: TObject);
begin
  if TableLoading then Exit;
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
  Filtered:=False;
  UpdateTimeRange;
  DrawGrid.Row:=1;
  ReloadTable;
end;

procedure TShowTablesForm.pmGroupSelectPopup(Sender: TObject);
var i,j: integer;
begin
  for i:=0 to 4 do
    for j:=0 to AM[i].Count-1 do
      AM[i].Items[j].Checked:=(AM[i].Items[j].Tag = GroupToShow);
end;

procedure TShowTablesForm.GroupSelectClick(Sender: TObject);
begin
  if TableLoading then Exit;
  GroupToShow:=(Sender as TMenuItem).Tag;
  DrawGrid.Row:=1;
  ReloadTable;
end;

procedure TShowTablesForm.frTableReportBeginPage(pgNo: Integer);
begin
  Inc(NumPages);
end;

procedure TShowTablesForm.AfterShow;
begin
  Update;
  UpdateColumnNames;
  UpdateTableView;
end;

procedure TShowTablesForm.actPrevUpdate(Sender: TObject);
var Result: boolean; i: integer;
begin
  Result:=False;
  for i:=GroupToShow-1 downto 1 do
  if (i in [1..125]) and not Caddy.HistGroups[i].Empty then
  begin
    Result:=True;
    Break;
  end;
  actPrev.Enabled:=Result and not TableLoading;
end;

procedure TShowTablesForm.actPrevExecute(Sender: TObject);
begin
  if TableLoading then Exit;
  repeat
    GroupToShow:=GroupToShow-1;
    if GroupToShow = 1 then Break;
  until not Caddy.HistGroups[GroupToShow].Empty;
  DrawGrid.Row:=1;
  ReloadTable;
end;

procedure TShowTablesForm.actNextUpdate(Sender: TObject);
var Result: boolean; i: integer;
begin
  Result:=False;
  for i:=GroupToShow+1 to 125 do
  if (i in [1..125]) and not Caddy.HistGroups[i].Empty then
  begin
    Result:=True;
    Break;
  end;
  actNext.Enabled:=Result and not TableLoading;
end;

procedure TShowTablesForm.actNextExecute(Sender: TObject);
begin
  if TableLoading then Exit;
  repeat
    GroupToShow:=GroupToShow+1;
    if GroupToShow = 125 then Break;
  until not Caddy.HistGroups[GroupToShow].Empty;
  DrawGrid.Row:=1;
  ReloadTable;
end;

procedure TShowTablesForm.UpdateColumnNames;
begin
  with Caddy.HistGroups[FGroupToShow] do
  begin
    if Trim(GroupName) <> '' then
      GroupNamePanel.Caption:='   '+tbGroupNo.Caption+' - '+GroupName
    else
      GroupNamePanel.Caption:='   '+tbGroupNo.Caption+' - (без названия)';
  end;
  DrawGrid.Invalidate;
end;

procedure TShowTablesForm.SetGroupToShow(const Value: integer);
begin
  if FGroupToShow <> Value then
  begin
    FGroupToShow:=Value;
    tbGroupNo.Caption:=Format('Группа № %d',[FGroupToShow]);
    UpdateColumnNames;
  end;
end;

procedure TShowTablesForm.UpdateTableView;
begin
  if TableLoading then Exit;
  if cbScrolling.Checked then tbTime0Click(nil);
end;

procedure TShowTablesForm.actPreviewExecute(Sender: TObject);
var i: integer; E: TEntity; desc: string;
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
    LastRow[TTableType(tcTables.TabIndex)]:=DrawGrid.Row;
  actPreview.Enabled:=False;
  Screen.Cursor:=crHourGlass;
  try
    Panel.acPreview.Execute;
    Panel.ShowPreviewForm.MasterAction:=Panel.actTables;
    frTableReport.LoadFromResourceName(HInstance,'TableReport');
    frUserTableDataset.RangeEndCount:=Data.Length;
    frTableReport.Title:=tcTables.Tabs[tcTables.TabIndex];
    frVariables.Variable['ObjectName']:=Config.ReadString('General','ObjectName','');
    frVariables.Variable['PrintDate']:=FormatDateTime('Отпечатано: d.mm.yyyy h:nn:ss',Now);
    frVariables.Variable['PrintPeriod']:='Время выборки: с '+
                 FormatDateTime('d.mm.yyyy h:nn:ss',StartTime-ShiftTime)+
                ' до '+FormatDateTime('d.mm.yyyy h:nn:ss',StartTime);
    with Caddy.HistGroups[GroupToShow] do
    begin
      if Trim(GroupName) <> '' then
        frVariables.Variable['ReportName']:=frTableReport.Title+', '+
                         Format('Группа %d - %s',[GroupToShow,Trim(GroupName)])
      else
        frVariables.Variable['ReportName']:=frTableReport.Title+', '+
                         Format('Группа %d - %s',[GroupToShow,'(без имени)']);
      for i:=1 to 8 do
      begin
        if Empty or not Empty and not Assigned(Entity[i]) then
          frVariables.Variable['COLUMN'+IntToStr(i)]:=''
        else
        begin
          E := Caddy.Find(Place[i]);
          desc := '';
          if E <> nil then desc := E.PtDesc;
          frVariables.Variable['COLUMN'+IntToStr(i)]:=
                        Place[i]+'.'+AParamKind[Kind[i]]+', '+EU[i] + ', ' + desc;
        end;
      end;
    end;
    if Config.ReadInteger('General','PrintColor',0) = 0 then
    begin  // Серая шкала
      with CurPage.FindObject('ReportTitleMemo') as TfrMemoView do
      begin
        FillColor:=clSilver;
        Font.Color:=clBlack;
      end;
    end;
    frTableReport.Preview:=Panel.ShowPreviewForm.frAllPreview;
    NumPages:=0;
    if frTableReport.PrepareReport then
    begin
      frTableReport.ShowPreparedReport;
      Panel.ShowPreviewForm.Show;
    end;
  finally
    Screen.Cursor:=crDefault;
    actPreview.Enabled:=True;
  end;
end;

procedure TShowTablesForm.actPrintExecute(Sender: TObject);
var i: integer; E: TEntity; desc: string;
begin
  PrintDialogForm:=TPrintDialogForm.Create(Self);
  try
    if not cbScrolling.Checked then
      LastRow[TTableType(tcTables.TabIndex)]:=DrawGrid.Row;
    actPrint.Enabled:=False;
    Screen.Cursor:=crHourGlass;
    try
      frTableReport.LoadFromResourceName(HInstance,'TableReport');
      frUserTableDataset.RangeEndCount:=Data.Length;
      frTableReport.Title:=tcTables.Tabs[tcTables.TabIndex];
      frVariables.Variable['ObjectName']:=
             Config.ReadString('General','ObjectName','');
      frVariables.Variable['PrintDate']:=
         FormatDateTime('Отпечатано: d.mm.yyyy h:nn:ss',Now);
      frVariables.Variable['PrintPeriod']:='Время выборки: с '+
                 FormatDateTime('d.mm.yyyy h:nn:ss',StartTime-ShiftTime)+
                ' до '+FormatDateTime('d.mm.yyyy h:nn:ss',StartTime);
      with Caddy.HistGroups[GroupToShow] do
      begin
        if Trim(GroupName) <> '' then
          frVariables.Variable['ReportName']:=frTableReport.Title+', '+
                           Format('Группа %d - %s',[GroupToShow,Trim(GroupName)])
        else
          frVariables.Variable['ReportName']:=frTableReport.Title+', '+
                           Format('Группа %d - %s',[GroupToShow,'(без имени)']);
        for i:=1 to 8 do
        begin
          if Empty or not Empty and not Assigned(Entity[i]) then
            frVariables.Variable['COLUMN'+IntToStr(i)]:=''
          else
          begin
            E := Caddy.Find(Place[i]);
            desc := '';
            if E <> nil then desc := E.PtDesc;
            frVariables.Variable['COLUMN'+IntToStr(i)]:=
                          Place[i]+'.'+AParamKind[Kind[i]]+', '+EU[i] + ', ' + desc;
          end;
        end;
      end;
      if Config.ReadInteger('General','PrintColor',0) = 0 then
      begin  // Серая шкала
        with CurPage.FindObject('ReportTitleMemo') as TfrMemoView do
        begin
          FillColor:=clSilver;
          Font.Color:=clBlack;
        end;
      end;
      NumPages:=0;
      if frTableReport.PrepareReport then
      begin
        PrintDialogForm.FromPage:=1;
        PrintDialogForm.ToPage:=NumPages;
        if PrintDialogForm.Execute then
        begin
          RemXForm.SaveReportToReportsLog(frTableReport,True,'Таблицы');
          if PrintDialogForm.PrintRange = prAllPages then
            frTableReport.PrintPreparedReport('',PrintDialogForm.Copies,
                                            PrintDialogForm.Collate,frAll)
          else
            if PrintDialogForm.PrintRange = prPageNums then
              frTableReport.PrintPreparedReport(Format('%d-%d',
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

procedure TShowTablesForm.TimePopupMenuPopup(Sender: TObject);
var i: integer;
begin
  for i:=0 to TimePopupMenu.Items.Count-1 do
    TimePopupMenu.Items.Items[i].Checked:=False;
  TimePopupMenu.Items.Items[CurrentTimeIndex].Checked:=True;
end;

procedure TShowTablesForm.DrawGridDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var S,sFormat: string; R: TRect;
begin
  InflateRect(Rect,-3,0);
  with Caddy.HistGroups[GroupToShow], DrawGrid.Canvas do
  begin
    if ARow = 0 then
    begin
      if ACol = 0 then
      begin
        if Filtered then
        begin
          LogsImageList.Draw(DrawGrid.Canvas,Rect.Right-16,
                             Rect.Top+(Rect.Bottom-Rect.Top-16) div 2,5);
          Brush.Style:=bsClear;
        end;
        S:='Дата и время';
        R:=Rect; R.Bottom:=R.Bottom-((R.Bottom-R.Top) div 2);
        DrawText(Handle,PChar(S),Length(S),R,DT_CENTER+DT_VCENTER+DT_SINGLELINE);
        S:=FormatDateTime('dd.mm.yy, ddd, hh:nn',StartTime-ShiftTime);
        R:=Rect; R.Top:=R.Top+((R.Bottom-R.Top) div 2);
        DrawText(Handle,PChar(S),Length(S),R,DT_CENTER+DT_VCENTER+DT_SINGLELINE);
        if Filtered then
          Brush.Style:=bsSolid;
      end
      else
      if ACol in [1..8] then
      begin
        S:=Place[ACol];
        if Assigned(Entity[ACol]) then
        begin
          S:=S+'.'+AParamKind[Kind[ACol]]+',';
          R:=Rect; R.Bottom:=R.Bottom-((R.Bottom-R.Top) div 2);
          DrawText(Handle,PChar(S),Length(S),R,DT_CENTER+DT_VCENTER+DT_SINGLELINE);
          S:=EU[ACol];
          R:=Rect; R.Top:=R.Top+((R.Bottom-R.Top) div 2);
          DrawText(Handle,PChar(S),Length(S),R,DT_CENTER+DT_VCENTER+DT_SINGLELINE);
        end;
      end;
    end
    else
    if not Empty and (Data.Length > 0) then
    begin
      if ACol = 0 then
      begin
        S:=FormatDateTime('dd.mm.yy, ddd, hh:nn',Data.Body[ARow].SnapTime);
        DrawText(Handle,PChar(S),Length(S),Rect,DT_LEFT+DT_VCENTER+DT_SINGLELINE);
      end
      else
      if (ACol in [1..8]) and Assigned(Entity[ACol]) then
      begin
        sFormat:='%.'+IntToStr(DF[ACol])+'f';
        if Data.Body[ARow].Quality[ACol] then
        begin
          if TableLoading then
            S:='??????'
          else
            S:=Format(sFormat,[Data.Body[ARow].Val[ACol]]);
        end
        else
        if not Data.Body[ARow].Quality[ACol] and
          not (TTableType(tcTables.TabIndex) in [ttMinSnap,ttHourSnap]) then
        begin
          if TableLoading then
            S:='??????'
          else
            S:=Format(sFormat,[Data.Body[ARow].Val[ACol]])+'*';
        end
        else
          S:='------';
        DrawText(Handle,PChar(S),Length(S),Rect,DT_RIGHT+DT_VCENTER+DT_SINGLELINE);
      end;
    end;
  end;
end;

procedure TShowTablesForm.frTableReportGetValue(const ParName: String;
  var ParValue: Variant);
var i,j: integer; sFormat: string;
begin
  i:=frUserTableDataset.RecNo;
  if (Data.Length > 0) then
  begin
    if AnsiCompareText(ParName,'SnapTime') = 0 then
    begin
      case tcTables.TabIndex of
        0: ParValue:=FormatDateTime('dd.mm.yyyy ddd hh:nn',Data.Body[i+1].SnapTime);
        1: ParValue:=FormatDateTime('dd.mm.yyyy ddd hh:nn',Data.Body[i+1].SnapTime);
        2: ParValue:=FormatDateTime('dd.mm.yyyy ddd hh ч.',Data.Body[i+1].SnapTime);
        3: ParValue:=FormatDateTime('dd.mm.yy, dddd',Data.Body[i+1].SnapTime);
        4: ParValue:=FormatDateTime('mmmm, yyyy г.',Data.Body[i+1].SnapTime);
      else
        ParValue:='';
      end;
      Exit;
    end;
    for j:=1 to 8 do
    begin
      if AnsiCompareText(ParName,'Value'+IntToStr(j)) = 0 then
      with Caddy.HistGroups[GroupToShow] do
      begin
        if Empty then
          ParValue:=''
        else
        begin
          if Assigned(Entity[j]) then
          begin
            sFormat:='%.'+IntToStr(DF[j])+'f';
            if Data.Body[i+1].Quality[j] then
              ParValue:=Format(sFormat,[Data.Body[i+1].Val[j]])
            else
            begin
              if tcTables.TabIndex in [0,1] then
                ParValue:='------'
              else
                ParValue:=Format(sFormat,[Data.Body[i+1].Val[j]])+'*';
            end;
          end
          else
            ParValue:='';
        end;
        Exit;
      end;
    end;
  end;
end;

procedure TShowTablesForm.cbScrollingClick(Sender: TObject);
begin
  if TableLoading then Exit;
  if cbScrolling.Checked then
  begin
    StartTime:=Now;
    ShiftTime:=GetShiftTime(CurrentTimeIndex);
    Filtered:=False;
    UpdateTimeRange;
    DrawGrid.Row:=1;
    ReloadTable;
  end;  
end;

function TShowTablesForm.GetShiftTime(Index: integer): TDateTime;
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

procedure TShowTablesForm.ReloadTable;
var D1,D2: TDateTime;
begin
  if TableLoading then Exit;
  TableLoading:=True;
  D2:=StartTime;
  D1:=D2-ShiftTime;
  DrawGrid.Invalidate;
  Screen.Cursor:=crHourGlass;
  with TGetSingleTable.Create(Self,Caddy.CurrentTablePath,
                         TTableType(tcTables.TabIndex),D1,D2,GroupToShow) do
  begin
    OnTerminate:=TableLoaded;
    Resume;
  end;
  SaveConfig(PathToSave);
end;

procedure TShowTablesForm.SaveConfig(Path: string);
begin
  Config.WriteDateTime(Path,'TableDate',StartTime);
  Config.WriteInteger(Path,'TableTime',CurrentTimeIndex);
  Config.WriteInteger(Path,'TableType',tcTables.TabIndex);
  Config.WriteInteger(Path,'GroupIndex',GroupToShow);
  Config.WriteBool(Path,'Scrolling',cbScrolling.Checked);
// Запись изменений на диск
  ConfigUpdateFile(Config);
end;

procedure TShowTablesForm.LoadConfig(Path: string);
begin
  PathToSave := Path;
  StartTime:=Config.ReadDateTime(Path,'TableDate',Now);
  CurrentTimeIndex:=Config.ReadInteger(Path,'TableTime',0);
  if CurrentTimeIndex > 6 then CurrentTimeIndex:=6;
  ShiftTime:=GetShiftTime(CurrentTimeIndex);
  tbTimeSelect.Caption:=TimePopupMenu.Items.Items[CurrentTimeIndex].Caption;
  tcTables.TabIndex:=Config.ReadInteger(Path,'TableType',0);
  cbScrolling.OnClick:=nil;
  try
    cbScrolling.Checked:=Config.ReadBool(Path,'Scrolling',True);
  finally
    cbScrolling.OnClick:=cbScrollingClick;
  end;
  GroupToShow:=Config.ReadInteger(Path,'GroupIndex',1);
  tbTime0Click(TimePopupMenu.Items[CurrentTimeIndex]);
end;

procedure TShowTablesForm.tbLessTimeClick(Sender: TObject);
var D1,D2: TDateTime;
begin
  if TableLoading then Exit;
  TableLoading:=True;
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
  with TGetSingleTable.Create(Self,Caddy.CurrentTablePath,
                         TTableType(tcTables.TabIndex),D1,D2,GroupToShow) do
  begin
    OnTerminate:=TableLoaded;
    Resume;
  end;
end;

procedure TShowTablesForm.tbMoreTimeClick(Sender: TObject);
var D1,D2: TDateTime;
begin
  if TableLoading then Exit;
  TableLoading:=True;
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
  with TGetSingleTable.Create(Self, Caddy.CurrentTablePath,
                         TTableType(tcTables.TabIndex),D1,D2,GroupToShow) do
  begin
    OnTerminate:=TableLoaded;
    Resume;
  end;
end;

procedure TShowTablesForm.tcTablesChange(Sender: TObject);
begin
  DrawGrid.RowCount:=2;
  DrawGrid.Row:=1;
  ReloadTable;
end;

procedure TShowTablesForm.tcTablesChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange:=not TableLoading;
  if AllowChange then LastRow[TTableType(tcTables.TabIndex)]:=DrawGrid.Row;
end;

procedure TShowTablesForm.TableLoaded(Sender: TObject);
var CanSelect: boolean;
begin
  TableLoading:=False;
  if not cbScrolling.Checked then
  begin
    if LastRow[TTableType(tcTables.TabIndex)] < DrawGrid.RowCount then
    begin
      if LastRow[TTableType(tcTables.TabIndex)] = 0 then
        DrawGrid.Row:=1
      else
        DrawGrid.Row:=LastRow[TTableType(tcTables.TabIndex)];
    end;
  end;
  Screen.Cursor:=crDefault;
  DrawGrid.Invalidate;
  DrawGridSelectCell(DrawGrid,DrawGrid.Col,DrawGrid.Row,CanSelect);
end;

procedure TShowTablesForm.tbFilterClick(Sender: TObject);
var i: integer; Result: TModalResult;
begin
  if TableLoading then Exit;
  i:=tcTables.TabIndex;
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
        ReloadTable;
      end
      else
      if Result = mrAbort then
      begin
        Filtered:=False;
        cbScrolling.Checked:=True;
        UpdateTableView;
      end
      else
        Exit;
    end;
  finally
    TimeFilterForm.Free;
  end;
end;

procedure TShowTablesForm.UpdateTimeRange;
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

procedure TShowTablesForm.DrawGridMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var ACol,ARow: integer; CanSelect: boolean; P: TPoint;
begin
  DrawGrid.MouseToCell(X,Y,ACol,ARow);
  if (ACol in [1..8]) and (ARow = 0) then
  begin
    if Assigned(Caddy.HistGroups[GroupToShow].Entity[ACol]) then
    begin
      DrawGrid.Col:=ACol;
      DrawGridSelectCell(DrawGrid,ACol,DrawGrid.Row,CanSelect);
      if Button = mbRight then
      begin
        P:=DrawGrid.ClientToScreen(Point(X,Y));
        pmColumnClick.Popup(P.X,P.Y);
      end  
    end;
  end;
  if Button = mbLeft then
  begin
    if (ACol = 0) and (ARow = 0) then
      tbFilterClick(Sender);
  end;
end;

procedure TShowTablesForm.DrawGridMouseMove(Sender: TObject;
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

procedure TShowTablesForm.ShowThreadMessage(Sender: TObject; Mess: string);
begin
  RemXForm.ShowMessage:=Mess;
end;

procedure InitCriticalSections;
var i: integer;
begin
  for i:=1 to 125 do GetSingleTableSection[i]:=TCriticalSection.Create;
end;

procedure FinitCriticalSections;
var i: integer;
begin
  for i:=1 to 125 do GetSingleTableSection[i].Free;
end;

procedure TShowTablesForm.DrawGridSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if ACol in [1..8] then
  begin
    with Caddy.HistGroups[GroupToShow] do
    if Assigned(Entity[ACol]) then
      RemXForm.ShowMessage:=
        Format('%s - %s',[Place[ACol]+'.'+AParamKind[Kind[ACol]],
                          Entity[ACol].PtDesc])
    else
      RemXForm.ShowMessage:='';
  end
  else
    RemXForm.ShowMessage:='';
end;

procedure TShowTablesForm.ApplicationEventsIdle(Sender: TObject;
  var Done: Boolean);
begin
  tbGroupNo.Enabled:=not TableLoading;
  tbLessTime.Enabled:=not TableLoading;
  tbTimeSelect.Enabled:=not TableLoading;
  tbMoreTime.Enabled:=not TableLoading;
  cbScrolling.Enabled:=not TableLoading;
  tcTables.Enabled:=not TableLoading;
  actExportToExcel.Enabled:=not TableLoading;
end;

procedure TShowTablesForm.actPrintUpdate(Sender: TObject);
begin
  actPrint.Enabled:=not TableLoading;
end;

procedure TShowTablesForm.actPreviewUpdate(Sender: TObject);
begin
  actPreview.Enabled:=not TableLoading;
end;

procedure TShowTablesForm.pmColumnClickPopup(Sender: TObject);
begin
  miBase.Visible:=Caddy.UserLevel >= 5;
end;

procedure TShowTablesForm.miPasportClick(Sender: TObject);
var ACol: integer;
begin
  ACol:=DrawGrid.Col;
  if ACol in [1..8] then
  begin
    with Caddy.HistGroups[GroupToShow] do
    if Assigned(Entity[ACol]) then
      Entity[ACol].ShowPassport(Monitor.MonitorNum);
  end;
end;

procedure TShowTablesForm.miBaseClick(Sender: TObject);
var ACol: integer;
begin
  ACol:=DrawGrid.Col;
  if ACol in [1..8] then
  begin
    with Caddy.HistGroups[GroupToShow] do
    if Assigned(Entity[ACol]) then
      Entity[ACol].ShowEditor(Monitor.MonitorNum);
  end;
end;

procedure TShowTablesForm.actExportToExcelExecute(Sender: TObject);
var i,j: integer; XL,TableVals,SEL: Variant;
    TableName,ColChar,sFormat,S: string; E: TEntity;
begin
  if Data.Length = 0 then
  begin
    RemXForm.ShowError('Таблица "'+tcTables.Tabs[tcTables.TabIndex]+
           '" пуста, нет данных для экспорта."');
    Exit;
  end;
  SaveExtDialogForm:=TSaveExtDialogForm.Create(Self);
  try
    SaveExtDialogForm.Filter:='Рабочий лист Microsoft Excel (*.xls)|*.xls';
    if SaveExtDialogForm.InitialDir = '' then
      SaveExtDialogForm.InitialDir:=Caddy.CurrentBasePath;
    SaveExtDialogForm.FileName:='';
    SaveExtDialogForm.DefaultExt:='.xls';
    if SaveExtDialogForm.Execute then
    begin
      Update;
      Screen.Cursor:=crHourGlass;
      try
        TableVals:=VarArrayCreate([0,DrawGrid.RowCount-1+3, //кол-во строк
                                   0,8], // кол-во столбцов
                                   varOleStr);
        TableVals[0,0]:='Группа '+IntToStr(GroupToShow)+'. '+
                        Caddy.HistGroups[GroupToShow].GroupName;
        TableVals[1,0]:='Дата и время';
        TableVals[2,0]:='ед.изм.';
        for j:=1 to 8 do
        with Caddy.HistGroups[GroupToShow] do
        begin
          S:=Place[j];
          if Assigned(Entity[j]) then S:=S+'.'+AParamKind[Kind[j]];
          E:=Caddy.Find(Place[j]);
          if E <> nil then S:=S+' '+E.PtDesc;
          TableVals[1,j]:=S;
          TableVals[2,j]:=EU[j];
        end;
        for i:=1 to DrawGrid.RowCount-1 do
        with Caddy.HistGroups[GroupToShow] do
        begin
          if (i = 1) and (Data.Length = 0) then
            TableVals[i+2,0]:=''
          else
            TableVals[i+2,0]:=FormatDateTime('dd.mm.yy, ddd, hh:nn',
                                             Data.Body[i].SnapTime);
          for j:=1 to 8 do
          begin
            if Assigned(Entity[j]) then
            begin
              sFormat:='%.'+IntToStr(DF[j])+'f';
              if (i = 1) and (Data.Length = 0) then
                S:=''
              else
                if Data.Body[i].Quality[j] then
                  S:=Format(sFormat,[Data.Body[i].Val[j]])
                else
                  if not Data.Body[i].Quality[j] and
                     not (TTableType(tcTables.TabIndex) in
                          [ttMinSnap,ttHourSnap]) then
                    S:=Format(sFormat,[Data.Body[i].Val[j]])+'*'
                  else
                    S:='------';
            end
            else
              S:='';
            TableVals[i+2,j]:=S;
          end;
        end;
//------------------------------------
        try
          XL := CreateOleObject('Excel.Application');
        except
          raise Exception.Create('Не могу запустить Excel');
        end;
        ColChar:=Chr(Ord('A')+9-1);
        XL.StandardFont:='Arial';
        XL.StandardFontSize:='10';
        XL.SheetsInNewWorkbook:=1;
        XL.EnableSound:=False;
        XL.RollZoom:=False;
        XL.WorkBooks.Add;
        XL.Sheets['Лист1'].Select;
        XL.Sheets['Лист1'].Name:=tcTables.Tabs[tcTables.TabIndex];
        XL.Range[XL.Cells[1,1],XL.Cells[DrawGrid.RowCount+3,9]].Select;
        SEL:=XL.Selection;
        SEL.Value:=TableVals;
        SEL.VerticalAlignment:=$FFFFEFF4; // xlCenter
        SEL.WrapText:=False;
        SEL.Orientation:=0;
        SEL.AddIndent:=False;
        SEL.ShrinkToFit:=False;
        SEL.MergeCells:=False;
        XL.Range['A1',ColChar+'1'].Select;
        SEL:=XL.Selection;
        SEL.Merge;
        SEL.Font.Bold:=True;
        SEL.Font.Italic:=True;
        XL.Columns['A:'+ColChar].EntireColumn.AutoFit;
        XL.Range['A2',ColChar+'2'].Select;
        SEL:=XL.Selection;
        SEL.Font.Bold:=True;
        XL.Range['A3',ColChar+'3'].Select;
        SEL:=XL.Selection;
        SEL.Font.Italic:=True;
        XL.Range[XL.Cells[4,2],XL.Cells[DrawGrid.RowCount+3,9]].Select;
        SEL:=XL.Selection;
        SEL.HorizontalAlignment:=$FFFFEFC8; //xlRight
        XL.Range['A3','A3'].Select;
        SEL:=XL.Selection;
        SEL.Borders[$00000007].LineStyle:=$00000001;
        TableName:=SaveExtDialogForm.FileName;
        if FileExists(TableName) then DeleteFile(TableName);
        XL.ActiveWorkbook.SaveAs(
           Filename:=TableName,
           FileFormat:=$FFFFEFD1{xlNormal}, Password:='', WriteResPassword:='',
           ReadOnlyRecommended:=False, CreateBackup:=False);
           RemXForm.ShowInfo('Таблица "'+tcTables.Tabs[tcTables.TabIndex]+
            '" успешно экспортирована в файл "'+ExtractFileName(TableName)+'"');
      finally
        Screen.Cursor:=crDefault;
        XL.Quit;
      end;
    end;
  finally
    SaveExtDialogForm.Free;
  end;
end;

procedure TShowTablesForm.btnExportCSVClick(Sender: TObject);
var i,j: integer; TableVals: Variant;
    TableName,sFormat,S: string; E: TEntity;
    T: TextFile;
begin
  if Data.Length = 0 then
  begin
    RemXForm.ShowError('Таблица "'+tcTables.Tabs[tcTables.TabIndex]+
           '" пуста, нет данных для экспорта."');
    Exit;
  end;
  SaveExtDialogForm:=TSaveExtDialogForm.Create(Self);
  try
    SaveExtDialogForm.Filter:='Текст для импорта в Microsoft Excel (*.csv)|*.csv';
    if SaveExtDialogForm.InitialDir = '' then
      SaveExtDialogForm.InitialDir:=Caddy.CurrentBasePath;
    SaveExtDialogForm.FileName:='';
    SaveExtDialogForm.DefaultExt:='.csv';
    if SaveExtDialogForm.Execute then
    begin
      Update;
      Screen.Cursor:=crHourGlass;
      try
        TableVals:=VarArrayCreate([0,DrawGrid.RowCount-1+3, //кол-во строк
                                   0,8], // кол-во столбцов
                                   varOleStr);
        TableVals[0,0]:='Группа '+IntToStr(GroupToShow)+'. '+
                        Caddy.HistGroups[GroupToShow].GroupName;
        TableVals[1,0]:='Дата и время';
        TableVals[2,0]:='ед.изм.';
        for j:=1 to 8 do
        with Caddy.HistGroups[GroupToShow] do
        begin
          S:=Place[j];
          if Assigned(Entity[j]) then S:=S+'.'+AParamKind[Kind[j]];
          E:=Caddy.Find(Place[j]);
          if E <> nil then S:=S+' '+E.PtDesc;
          TableVals[1,j]:=S;
          TableVals[2,j]:=EU[j];
        end;
        for i:=1 to DrawGrid.RowCount-1 do
        with Caddy.HistGroups[GroupToShow] do
        begin
          if (i = 1) and (Data.Length = 0) then
            TableVals[i+2,0]:=''
          else
            TableVals[i+2,0]:=FormatDateTime('dd.mm.yy, ddd, hh:nn',
                                             Data.Body[i].SnapTime);
          for j:=1 to 8 do
          begin
            if Assigned(Entity[j]) then
            begin
              sFormat:='%.'+IntToStr(DF[j])+'f';
              if (i = 1) and (Data.Length = 0) then
                S:=''
              else
                if Data.Body[i].Quality[j] then
                  S:=Format(sFormat,[Data.Body[i].Val[j]])
                else
                  if not Data.Body[i].Quality[j] and
                     not (TTableType(tcTables.TabIndex) in
                          [ttMinSnap,ttHourSnap]) then
                    S:=Format(sFormat,[Data.Body[i].Val[j]])+'*'
                  else
                    S:='------';
            end
            else
              S:='';
            TableVals[i+2,j]:=S;
          end;
        end;
//------------------------------------
        TableName:=SaveExtDialogForm.FileName;
        if FileExists(TableName) then DeleteFile(TableName);
        AssignFile(T,TableName);
        try
          Rewrite(T);
          for i:=0 to DrawGrid.RowCount-1+3 do
          begin
            for j:=0 to 8 do
            begin
              Write(T,TableVals[i,j],';');
            end;
            Writeln(T);
          end;
        finally
          CloseFile(T);
        end;

        RemXForm.ShowInfo('Таблица "'+tcTables.Tabs[tcTables.TabIndex]+
            '" успешно экспортирована в файл "'+ExtractFileName(TableName)+'"');
      finally
        Screen.Cursor:=crDefault;
        {XL.Quit;}
      end;
    end;
  finally
    SaveExtDialogForm.Free;
  end;
end;

initialization
  InitCriticalSections;

finalization
  FinitCriticalSections;

end.
