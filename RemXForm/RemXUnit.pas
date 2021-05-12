unit RemXUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Menus, EntityUnit,
  ActnList, ImgList, IniFiles, AppEvnts, StdStyleActnCtrls, Contnrs, FR_Class,
  msxmldom, XMLDoc, TCPLink, xmldom, XMLIntf, DB, ADODB;


type
  RConv = record
    case Boolean of
      False: (BIG: DWord);
      True: (SMALL: array[0..3] of Byte);
  end;

  TWatchRecord = record
     FileName: string;
     StartTime: TDateTime;
     ShiftTime: TDateTime;
     Descriptor: string;
     HandStart: Boolean;
  end;

  TRemXFuncLib = class(TfrFunctionLibrary)
  public
    constructor Create; override;
    procedure DoFunction(FNo: Integer; p1, p2, p3: Variant;
      var val: Variant); override;
  end;

  TWatchRecordArray = record
                        Body: array[1..1000] of TWatchRecord;
                        Length: integer;
                      end;

  TRemXForm = class(TForm)
    Clock: TTimer;
    ApplicationEvents: TApplicationEvents;
    Fetch: TTimer;
    ExternalActionList: TActionList;
    EntityTypeImageList: TImageList;
    Fresh: TTimer;
    BaseXMLDoc: TXMLDocument;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ClockTimer(Sender: TObject);
    procedure miAboutClick(Sender: TObject);
    procedure FetchTimer(Sender: TObject);
    procedure ApplicationEventsException(Sender: TObject; E: Exception);
    procedure FastReportBeginDoc;
    procedure actTuningUpdate(Sender: TObject);
    procedure actCloseGamesExecute(Sender: TObject);
    procedure ShowThreadMessage(Sender: TObject; Mess: string);
    procedure NodeWDogsTimer(Sender: TObject);
    procedure StationsLinkServerDataCollector(Sender: TObject;
                                    const Request: string; var Answer: string);
    procedure StationsLinkClientDataReceive(Sender: TObject; const Answer: string);
    procedure TcpLinkReadData(Sender: TObject; const AnswerPacket: TNetBuff;
                                               const AnswerSize: integer);
    procedure TcpLinkTimeOut(Sender: TObject);
    procedure FreshTimer(Sender: TObject);
  private
    MonNum: integer;
    ServerBlankAnswerCount: integer;
    StartSystemDate: TDateTime;
    LastCashSaveDateTime: TDateTime;
    LastCashSaveTrends: TDateTime;
    FShortUserName: string;
    memMinute, memHour: integer;
    FCaddyMessage: string;
    FCaddySource: string;
    RemXFuncLib: TRemXFuncLib;
    RunTimeReports: TMemIniFile;
    TurnOnTime: TDateTime;
    DateTimeCheck: TDateTime;
    WorkSchemeName: string;
    procedure SetShortUserName(const Value: string);
    procedure BeforeFinish;
    procedure TableNotify(var Mess: TMessage); message WM_TableFresh;
    procedure TrendNotify(var Mess: TMessage); message WM_TrendFresh;
    procedure LogNotify(var Mess: TMessage); message WM_LogFresh;
    procedure AveragesNotify(var Mess: TMessage); message WM_AveragesFresh;
    procedure BuildEntityTypeImageList;
    procedure SetShowMessage(const Value: string);
    procedure CaddyMessage(Sender: TObject; Kind: TKindMessage; Mess: string);
    procedure CaddyQuestion(Sender: TObject; Question: string; var Result: boolean);
    procedure WMCommandResult(var Mess: TMessage); message WM_CommandResult;
    procedure FetchVirtual;
    procedure FetchPorts;
    procedure FetchFromStationLink;
    function Get_Val(Entry: string): Variant;
    function Get_Hour(Hour: integer; Entry: string): Double;
    function Abs_Hour(Day, AbsHour: integer; Entry: string): Double;
    procedure DocumentRemXReportFunctions;
    procedure LoadWatchList;
    procedure PrintReport(sReport,sDesc: string);
    procedure CheckAutor;
    function Authorization(KeyWord: String): Boolean;
    function Abs_Aver(Day, AbsHour: integer; Entry: string): Double;
    function Get_Aver(Hour: integer; Entry: string): Double;
    procedure ShowScheme(E: TEntity; const MonitorNum: integer);
    procedure PushFetchToLog(Index: integer; Source: string);
    function Decode(Source: string): string;
    function Get_HourAver(Hour: integer; Entry: string;
                          AverVal: boolean): Double;
    function Abs_HourAver(Day, AbsHour: integer; Entry: string;
      AverVal: boolean): Double;
    function GetAbs_HourAver(Day, Hour: integer; Entry: string; AverVal,
      AbsVal: boolean): Double;
    procedure CloseCommonDialogForm;
    procedure ComLinkReadData(Sender: TObject; const Packet: string;
                              const ErrCode: Cardinal);
    procedure ComLinkTimeout(Sender: TObject);
    procedure UpdateRealBaseFile;
    procedure CheckBeeperWork;
    procedure ShowPanelForms(const MonitorsCount, ScreenSizeIndex: integer;
                             const WorkSchemeName: string);
    procedure FreePanelForms;
 public
    MasterAction: TAction;
    LongUserName: string;
    CurrentPath: string;
    RootSchemeName: string;
    WatchList: TWatchRecordArray;
    MyProcIsShell: boolean;
    Registered,Bonus: Boolean;
    procedure PrepareToConnect;
    procedure BeforeStart(First: boolean = True);
    function ShowQuestion(AText: string): TModalResult;
    procedure ShowWarning(AText: string; ModalView: boolean = True);
    procedure ShowInfo(AText: string; ModalView: boolean = True);
    procedure ShowError(AText: string; ModalView: boolean = True);
    procedure ShowPassport(E: TEntity; const MonitorNum: integer);
    procedure ShowEditor(E: TEntity; const MonitorNum: integer);
    procedure FillWatchList;
    procedure SaveReportToReportsLog(Report: TfrReport;
                             HandStart: boolean; Category: string);
    function UserInformation(User: String): Cardinal;
    procedure WmTimeChange(var Mess: TWMTIMECHANGE); message WM_TIMECHANGE;
    property ShortUserName: string read FShortUserName write SetShortUserName;
    property ShowMessage: string write SetShowMessage;
  end;

var
  RemXForm: TRemXForm;

function GetComputer: Ansistring;
function GetParamVal(PtName: string;
                     var Entity: TEntity; var Blink: boolean): boolean;

implementation

uses CalcDensUnit, Math, PanelFormUnit,
  DateUtils, FileCtrl, ShowLogsUnit,
  TuningUnit,
  ShowSplashUnit,
  ShowHistGroupUnit, ShowTablesUnit, ShowTrendsUnit,
  ShowReportLogUnit,
  ThreadSaveUnit, StationsNetLink,
  CommonDialogUnit, KontLink,
  XmlConfigUnit;

{$R *.dfm}

function GetParamVal(PtName: string;
                     var Entity: TEntity; var Blink: boolean): boolean;
begin
  Entity:=Caddy.Find(PtName);
  Blink:=Caddy.Blink;
  Result:=Assigned(Entity);
end;

function GetComputer: Ansistring;
  {Returns the name string for the current system. Returns empty string ('') if
   function fails.}
var dwI: DWORD;
begin
  dwI:=MAX_PATH;
  SetLength(Result,MAX_PATH+1);
  if GetComputerName(PChar(Result),dwI) then
    SetLength(Result,dwI)
  else
    SetLength(Result,0);
end;

procedure TRemXForm.PrepareToConnect;
var Path, spath, sval: string; bval: Boolean;
begin
  Caddy.Station := Config.ReadInteger('General','StationNumber',0)+1;
  CurrentPath := IncludeTrailingPathDelimiter(ExtractFileDir(Application.ExeName))+
               'Data';
  Path := IncludeTrailingPathDelimiter(CurrentPath);
  Caddy.CurrentBasePath := Path + 'Config';
  Caddy.CurrentTrendPath := Path + 'Trends';
  if Config.ValueExists('Archives','CurrentTrendPath') then
  begin
    spath := Config.ReadString('Archives','CurrentTrendPath',Caddy.CurrentTrendPath);
    if ForceDirectories(spath) then
      Caddy.CurrentTrendPath := spath;
  end;
  bval := Config.ReadBool('OnlineExportMinuteTables',
                        'ExportActive', False);
  Caddy.ExportActive := bval;
  sval := Config.ReadString('OnlineExportMinuteTables',
                              'ConnectionString','');
  Caddy.ConnectionString := sval;
  Caddy.CurrentTablePath := Path + 'Tables';
  if Config.ValueExists('Archives','CurrentTablePath') then
  begin
    spath := Config.ReadString('Archives','CurrentTablePath',Caddy.CurrentTablePath);
    if ForceDirectories(spath) then
      Caddy.CurrentTablePath := spath;
  end;
  Caddy.CurrentLogsPath := Path + 'Logs';
  if Config.ValueExists('Archives','CurrentLogsPath') then
  begin
    spath := Config.ReadString('Archives','CurrentLogsPath',Caddy.CurrentLogsPath);
    if ForceDirectories(spath) then
      Caddy.CurrentLogsPath := spath;
  end;
  Caddy.CurrentSchemsPath := Path + 'Scheme';
  Caddy.CurrentReportsPath := Path + 'Report';
  ForceDirectories(Caddy.CurrentReportsPath);
  Caddy.CurrentReportsLogPath := Path + 'Reports';
  ForceDirectories(Caddy.CurrentReportsLogPath);
  if Config.ValueExists('Archives','CurrentReportsLogPath') then
  begin
    spath := Config.ReadString('Archives','CurrentReportsLogPath',Caddy.CurrentReportsLogPath);
    if ForceDirectories(spath) then
      Caddy.CurrentReportsLogPath := spath;
  end;
  RootSchemeName := Config.ReadString('General', 'RootScheme', 'MAIN.SCM');
  MyProcIsShell := Config.ReadBool('General', 'SystemShell', False);
  Caddy.DigErrFilter := Config.ReadBool('General','DigErrFilter',False); // добавлено 15.07.12
  Caddy.NoAsk :=Config.ReadBool('General','NoAsk',False); // добавлено 15.07.12
  Caddy.NoAddNoLinkInAciveLog := Config.ReadBool('General','NoAddNoLinkInAciveLog',False);
  Path := IncludeTrailingPathDelimiter(Caddy.CurrentSchemsPath);
  WorkSchemeName := Path + RootSchemeName;
end;

procedure TRemXForm.ShowPanelForms(const MonitorsCount, ScreenSizeIndex: integer;
                                   const WorkSchemeName: string);
var
  nMonitors, n: integer;
  Form: TPanelForm;
begin
 // Создание требуемого количества рабочих окон RemX, но не более доступных
  nMonitors := EnsureRange(MonitorsCount, 1, Screen.MonitorCount);
  for n := 0 to nMonitors - 1 do
  begin
    Form := TPanelForm.Create(Self);
    with Screen.Monitors[n].WorkareaRect do
    begin
      Form.SetBounds(Left, Top, Screen.Monitors[n].Width, Screen.Monitors[n].Height);
      Form.ScreenSizeIndex := ScreenSizeIndex;
      Form.WorkSchemeName := WorkSchemeName;
      Form.Show;
      Form.actOverview.Execute;
    end;
  end;
end;

procedure TRemXForm.FreePanelForms;
var
  n: integer;
begin
  // Очистка предыдущих рабочих окон RemX, если таковые существуют
  for n := 0 to Screen.FormCount - 1 do
    if Screen.Forms[n].ClassType = TPanelForm then
    begin
      Screen.Forms[n].Close;
      Screen.Forms[n].Release;
    end;
end;

procedure TRemXForm.FormCreate(Sender: TObject);
var i: integer; CurrPath,FileName,si: string;
    memNow: TDateTime;
  function StartMinute(Value: TDateTime): TDateTime;
  var yy,mm,dd,hh,nn,ss,zz: Word;
  begin
    DecodeDateTime(Value,yy,mm,dd,hh,nn,ss,zz);
    Result:=EncodeDateTime(yy,mm,dd,hh,nn,0,0);
  end;
begin
  RunTimeReports:=TMemIniFile.Create('');
  BuildEntityTypeImageList;
  memNow:=Now;
  memMinute:=MinuteOf(memNow);
  memHour:=HourOf(memNow);
//----------------
  CurrPath:=ExtractFileDir(Application.ExeName);
  for i:=1 to ChannelCount do
  try
    FileName:=IncludeTrailingPathDelimiter(CurrPath)+'Channel'+IntToStr(i)+'.log';
    if FileExists(FileName) then DeleteFile(FileName);
  except
    Continue;
  end;
  ForceDirectories(IncludeTrailingPathDelimiter(CurrPath)+'Data');
  Config:=TMemIniFile.Create(IncludeTrailingPathDelimiter(CurrPath)+'Data\RemX.ini');
  ForceDirectories(IncludeTrailingPathDelimiter(CurrPath)+'Data\Config');
  ConfigBase := TXmlIniFile.Create(IncludeTrailingPathDelimiter(CurrPath)+
                                 'Data\Config\remxbase.xml','RemXBase');
  ConfigBase.XMLDoc := BaseXMLDoc;
//--------------------------
  Caddy(Self).Parent := Self;
  Caddy.OnMessage := CaddyMessage;
  Caddy.OnQuestion := CaddyQuestion;
  Caddy.OnShowPassport := ShowPassport;
  Caddy.OnShowEditor := ShowEditor;
  Caddy.OnShowScheme := ShowScheme;
  for i := 1 to ChannelCount do
  with Caddy.FetchList[i] do
  begin
    si := IntToStr(i);
    SaveToLog := Config.ReadBool('Channel'+si,'SaveToLog',False);
    RepeatCount := Config.ReadInteger('Channel'+si,'RepeatCount',2);
    LinkType := Config.ReadInteger('Channel'+si,'LinkType',0);
    ComLink.LinkType := TLinkType(LinkType);
    ComLink.OnReadData := ComLinkReadData;
    ComLink.OnTimeout := ComLinkTimeout;
    TcpLink.OnClientDataReceive := TcpLinkReadData;
    TcpLink.OnClientTimeOut := TcpLinkTimeOut;
  end;
  Caddy.BeeperKind := TBeeperKind(Config.ReadInteger('General','AlarmSound',1));
  Caddy.StationsLink.OnServerDataCollector := StationsLinkServerDataCollector;
  Caddy.StationsLink.OnClientDataReceive := StationsLinkClientDataReceive;
  Caddy.ConnectionString:=Config.ReadString('OnlineExportMinuteTables',
                               'ConnectionString','');
  Caddy.ExportActive:=Config.ReadBool('OnlineExportMinuteTables',
                               'ExportActive',False);
//--------------------------
  BorderStyle := bsNone;
  MonNum := Config.ReadInteger('General','Monitors',0);
  Caddy.ScreenSizeIndex := Config.ReadInteger('General','ScreenSize',1);
//--------------------------
  LongUserName := '';
  ShortUSerName := '';
  Caddy.UserLevel := 0;
  Caddy.LongUserName := '';
  MasterAction := nil;
//--------------------------
  frRegisterFunctionLibrary(TRemXFuncLib);
  DocumentRemXReportFunctions;
//--------------------------
  CheckAutor;
  Bonus := not Registered;
  OldTimesTuning;
  BeforeStart;
  ShowPanelForms(MonNum+1,Caddy.ScreenSizeIndex, WorkSchemeName);
  TurnOnTime := Now;
  StartSystemDate := Now;
  LastCashSaveDateTime := StartMinute(StartSystemDate);
  LastCashSaveTrends := LastCashSaveDateTime + OneSecond*30;
  Clock.Enabled := True;
  ClockTimer(Clock);
  Fresh.Enabled := True;
end;

procedure TRemXForm.BeforeStart(First: boolean = True);
var FileName,BackName: string;
begin
  PrepareToConnect;
  Caddy.AddChange('Система','Работа','Стоп','Старт',
                        'Запуск системы','Автономно');
  Caddy.EmptyBase;
  Caddy.LoadBase(Caddy.CurrentBasePath);
  Caddy.LoadHistGroups(Caddy.CurrentBasePath);
  Caddy.LoadSchemes(Caddy.CurrentSchemsPath);
  FileName:=IncludeTrailingPathDelimiter(Caddy.CurrentBasePath)+'REALBASE.VAL';
  BackName:=ChangeFileExt(FileName,'.~VAL');
  try
    if FileExists(FileName) and not Caddy.LoadValuesFromRealBase(FileName) or
       not FileExists(FileName) then
    begin
      if FileExists(BackName) and
         not Caddy.LoadValuesFromRealBase(BackName) then
        ShowError('Файл счетчиков разрушен. Значения счетчиков не загружены!');
    end;
  except
    Caddy.AddSysMess('REALBASE',
                     'Файл счетчиков разрушен. Значения счетчиков не загружены!');
  end;
  FillWatchList;
  RemXStationsNetTuning(True);
  if not (Caddy.NetRole = nrClient) then
  begin
    SerialPortsTuning;
    EthernetPortsTuning;
  end;
  Fetch.Enabled:=True;
end;

procedure TRemXForm.BeforeFinish;
var WorkTime: TDateTime;
    sDays,sTime: string;
    i: integer;
begin
  Clock.Enabled:=False;
  for i:=0 to ChannelCount do
  begin
    Caddy.FetchList[i].List.Clear;
    if (i in [1..ChannelCount]) and Caddy.FetchList[i].ComLink.Connected then
    begin
      Caddy.FetchList[i].ComLink.ReadActive:=False;
      Caddy.FetchList[i].ComLink.Close;
    end;
    if (i in [1..ChannelCount]) and Caddy.FetchList[i].TcpLink.Active then
      Caddy.FetchList[i].TcpLink.Close;
  end;
  WorkTime:=Now-StartSystemDate;
  sDays:=Format('%.0f дней ',[Int(WorkTime)]);
  sTime:=FormatDateTime('hh час. nn мин. ss сек.',Frac(WorkTime));
  Caddy.AddChange('Система','Работа','Старт','Стоп',
                Format('Прошло: %s%s',[sDays,sTime]),Caddy.Autor);
  Caddy.SaveLogsToBaseLog(Caddy.CurrentLogsPath);
end;

procedure TRemXForm.FormDestroy(Sender: TObject);
var E: TEntity;
begin
  FreePanelForms;
  BeforeFinish;
  frUnRegisterFunctionLibrary(TRemXFuncLib);
  ConfigBase.Free;
  Config.Free;
  RunTimeReports.Free;
  E:=Caddy.FirstEntity;
  while Assigned(E) do
  begin
    E.Actived:=False;
    E:=E.NextEntity;
  end;
  FreeAndNilNodeList;
  FreeAndNilClassesList;
  FreeAndNilCaddy;
end;

procedure TRemXForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=False;
  if (Caddy.UserLevel >= 0) and
     (ShowQuestion('Вы уверены, что хотите завершить работу с RemX?') = mrOk) then
  begin
    if Caddy.Changed and
      (ShowQuestion('В базе данных были изменения. Записать?') = mrOk) then
      Caddy.SaveBase(Caddy.CurrentBasePath);
    if Caddy.HistChanged and
      (ShowQuestion('В группах накопления были изменения. Записать?') = mrOk) then
      Caddy.SaveHistGroups(Caddy.CurrentBasePath);
    Fresh.Enabled:=False;
    Clock.Enabled:=False;
    Caddy.StationsLink.Close;
    CanClose:=True;
  end;
end;

procedure TRemXForm.actExitExecute(Sender: TObject);
var ph: THandle; tp,prevst: TTokenPrivileges; rl: DWORD;
begin
  if IsWinNT and MyProcIsShell then
  begin
    OpenProcessToken(GetCurrentProcess,
                     TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY,ph);
    LookupPrivilegeValue(nil,'SeShutdownPrivilege',tp.Privileges[0].Luid);
    tp.PrivilegeCount:=1;
    tp.Privileges[0].Attributes:=2;
    AdjustTokenPrivileges(ph,FALSE,tp,SizeOf(prevst),prevst,rl);
    ExitWindowsEx(EWX_LOGOFF,0);
  end
  else
    Close;
end;

procedure TRemXForm.BuildEntityTypeImageList;
var
  i: integer;
  B: TBitmap;
  C: TEntityClass;
begin
  B := TBitmap.Create;
  try
    B.Width := EntityTypeImageList.Width;
    B.Height := EntityTypeImageList.Height;
    with B.Canvas.Font do
    begin
      Name := 'Tahoma';
      Size := 8;
    end;
    for i := 0 to EntityClassList.Count - 1 do
    begin
      C := TEntityClass(EntityClassList[i]);
      EntityTypeImageList.Add(C.TypePict(B), nil);
    end;
  finally
    B.Free;
  end;
end;


procedure TRemXForm.ShowEditor(E: TEntity; const MonitorNum: integer);
var n: integer;
begin
//------------------------------------------------------
// Выдача окна редактора базы в новое окно панели
  for n := 0 to Screen.FormCount - 1 do
  if (Screen.Forms[n].ClassType = TPanelForm) and
     (Screen.Forms[n].Monitor.MonitorNum = MonitorNum) then
  begin
    with Screen.Forms[n] as TPanelForm do
    begin
      actBaseEdit.Tag:=Integer(E);
      actBaseEdit.Execute;
    end;
    Break;
  end;
end;

procedure TRemXForm.ShowScheme(E: TEntity; const MonitorNum: integer);
var n: integer;
begin
//------------------------------------------------------
// Выдача окна мнемосхемы в новое окно панели
  for n := 0 to Screen.FormCount - 1 do
  if (Screen.Forms[n].ClassType = TPanelForm) and
     (Screen.Forms[n].Monitor.MonitorNum = MonitorNum) then
  begin
    with Screen.Forms[n] as TPanelForm do
    begin
      actOverview.Tag:=Integer(E);
      actOverview.Execute;
    end;
    Break;
  end;
end;

procedure TRemXForm.UpdateRealBaseFile;
var FileName,BackName: string;
begin
  FileName:=IncludeTrailingPathDelimiter(Caddy.CurrentBasePath)+'REALBASE.VAL';
  BackName:=ChangeFileExt(FileName,'.~VAL');
  if FileExists(BackName) and DeleteFile(BackName) or
     not FileExists(BackName) then
  begin
    if FileExists(FileName) and RenameFile(FileName,BackName) or
       not FileExists(FileName) then
      Caddy.SaveValuesToRealBase(FileName);
  end;
(*  Caddy.SaveValuesToRealBase;  *)
end;

procedure TRemXForm.CheckBeeperWork;
begin
  if not Assigned(Caddy.Beeper) then
  begin
    Caddy.Beeper:=TBeeper.Create(Caddy,bkSpeaker);
    Caddy.Beeper.Kind:=TBeeperKind(Config.ReadInteger('General','AlarmSound',1));
    Caddy.Beeper.Resume;
  end;
end;

procedure TRemXForm.ClockTimer(Sender: TObject);
var memNow: TDateTime; CurMin,CurHour: integer;
begin
  Clock.Enabled:=False;
  try
    Caddy.FetchExecute; // Заполнение списков опроса
    UpdateRealBaseFile; // Запись текущих значений счётчиков
    DateTimeCheck := Now;
    memNow := DateTimeCheck;
    CurMin := MinuteOf(memNow);
    if CurMin <> memMinute then
    begin
      memMinute := CurMin;
      Caddy.UpdateMinuteTables;
      if Caddy.ExportActive then
         Caddy.ExportMinuteTables;
      CurHour := HourOf(memNow);
      if CurHour <> memHour then
      begin
        memHour := CurHour;
        Caddy.UpdateHourTables;
        Caddy.DeleteOldFiles;
      end;
      Caddy.SaveCashToBaseTables;
      if Caddy.ExportActive then
         Caddy.SaveCashToExportTables;
      Caddy.SaveCashToAlarmLog;
      Caddy.SaveCashToSwitchLog;
      Caddy.SaveCashToChangeLog;
      Caddy.SaveCashToSystemLog;
      Caddy.SaveCashToBaseTrend;
//===============================================
      actCloseGamesExecute(nil);
    end;
    if not Registered then
    begin
      if (Now-TurnOnTime) > EncodeTime(2,30,0,0) then
        Bonus := False;
    end;
    CheckBeeperWork;
  finally
    Clock.Enabled:=True;
  end;
end;

// Выполняется только на клиентской стороне !
procedure TRemXForm.FetchFromStationLink;
var Channel,i: integer; S,W,X: string; SL: TStringList;
begin
  if Caddy.StationsLink.Busy then Exit;
  SL := TStringList.Create;
  try
    for Channel := 0 to ChannelCount do
    with Caddy.FetchList[Channel] do
    begin
      try
        if List.Count > 0 then
        begin
          ReqEnt := List.Extract(List.First); // получение точки
          if Assigned(ReqEnt) and ReqEnt.Actived then
          begin
            if ReqEnt.LocalFetchOnly then
            begin
 // обмен произведен, удаляем аларм, если он был
              if asNoLink in ReqEnt.AlarmStatus then
                Caddy.RemoveAlarm(asNoLink,ReqEnt);
              ReqEnt.Fetch; // обработка полученных данных локально
              ReqEnt.HasCommand := False;
            end
            else
            if ReqEnt.HasCommand then
            begin
              ReqEnt.HasCommand := False;
              X := ReqEnt.Prepare;
              W := '';
              for i := 1 to Length(X) do W := W + IntToHex(Ord(X[i]),2);
              SL.Add('C' + ReqEnt.PtName + ';' + W);
              if Caddy.FetchList[0].SaveToLog then
              begin
                TickCount := GetTickCount;
                PushFetchToLog(0, 'Команда к ' + ReqEnt.PtName + '[' +
                                ReqEnt.TypeCode + ']: ' + S);
              end;
            end
            else
            begin
              SL.Add( 'A' + ReqEnt.PtName);
              if Caddy.FetchList[0].SaveToLog then
              begin
                Caddy.FetchList[0].TickCount := GetTickCount;
                PushFetchToLog(0, 'Запрос к ' + ReqEnt.PtName + '[' +
                                ReqEnt.TypeCode + ']: ' + S);
              end;
            end;
          end;
        end;
      except
        on E: Exception do
        begin
          List.Clear;
          ShowMessage := E.Message;
          Break;
        end;
      end;
    end;
    S := #2+SL.CommaText+#3; S:=S+CCS(S);
    if not Caddy.StationsLink.Busy and (SL.Count > 0) then
      Caddy.StationsLink.SendToServer(S);
  finally
    SL.Free;
  end;
end;

// Выполняется только на стороне сервера !
// Прием запросов от клиента и сбор данных для ответа клиенту
procedure TRemXForm.StationsLinkServerDataCollector(Sender: TObject;
                                  const Request: string; var Answer: string);
var S,W,X,PtName: string; E: TEntity; i,j: integer; R: Single;
    SL,AW: TStringList;
begin
  if (Length(Request) >= 2) and
     (CCS(Copy(Request,1,Length(Request)-1)) = Request[Length(Request)])  then
  begin
    SL:=TStringList.Create;
    AW:=TStringList.Create;
    try
      AW.Add('T'+FormatDateTime('dd.mm.yyyy hh:nn:ss',Now));
      SL.CommaText:=Copy(Request,2,Length(Request)-3);
      for j:=0 to SL.Count-1 do
      begin
        if Copy(SL[j],1,1) = 'A' then // Запрос от клиента на данные
        begin
          S:=SL[j];
          Delete(S,1,1);
          PtName:=S;
          E:=Caddy.Find(PtName);
          if Assigned(E) then
          begin
            if asNoLink in E.AlarmStatus then
              AW.Add('D' + E.PtName + ';NOLINK') // Возврат данных
            else
            begin
              X := E.FetchData;
              // Упаковка данных в символьный вид
              W := ''; for i := 1 to Length(X) do W := W + IntToHex(Ord(X[i]), 2);
              AW.Add('D' + E.PtName + ';' + W);
            end;
          end
          else
            AW.Add('D' + PtName + ';NOINBASE'); // Возврат данных "нет в базе"
        end;
        if Copy(SL[j],1,1) = 'C' then // Запрос от клиента на выполение команды
        begin
          S:=SL[j];
          Delete(S,1,1);
          PtName:=Copy(S,1,Pos(';',S)-1);
          E:=Caddy.Find(PtName);
          if Assigned(E) then
          begin
            Delete(S,1,Pos(';',S));
            W:=S;
            S:='';
            i:=Length(W);
            while (i > 0) and ((i div 2)*2 = i) do
            begin
              S:=S+Chr(StrToIntDef('$'+Copy(W,1,2),0) and $ff);
              Delete(W,1,2);
              i:=Length(W);
            end;
            if Length(S) = SizeOf(R) then
            begin
              if E.IsVirtual then
                E.Fetch(S)
              else
              begin
                MoveMemory(@R,@S[1],SizeOf(R));
                E.CommandData:=R;
                E.HasCommand:=True;
              end;
              AW.Add('Y'+E.PtName+';OK'); // Подтверждение на команду
            end
            else
            if Length(S) = SizeOf(R)+SizeOf(E.CommandMode) then
            begin
              MoveMemory(@E.CommandMode,@S[1],1);
              MoveMemory(@R,@S[2],4);
              E.CommandData:=R;
              E.HasCommand:=True;
              AW.Add('Y'+E.PtName+';OK'); // Подтв. на команду с параметром
            end;
          end
          else
            AW.Add('Y'+PtName+';NOINBASE'); // Подтверждение "нет в базе"
        end; { of for }
      end;
      S:=#2+AW.CommaText+#3;
      S:=S+CCS(S);
      Answer:=S;
    finally
      AW.Free;
      SL.Free;
    end;
  end
  else
  begin
    S:=#2+'T'+FormatDateTime('dd.mm.yyyy hh:nn:ss',Now)+#3;
    S:=S+CCS(S);
    Answer:=S; // Посылка серверного времени клиенту
  end;
end;

// Выполняется только на клиентской стороне !
// Прием данных клиентом от сервера
procedure TRemXForm.StationsLinkClientDataReceive(Sender: TObject;
                                                  const Answer: string);
var S,W,PtName: string; E: TEntity; i,j,Index: integer; SL: TStringList;
    DT: TDateTime; yy,mm,dd,hh,nn,ss,ms: Word; ST: SYSTEMTIME;
begin
  if (Length(Answer) >= 2) and
     (CCS(Copy(Answer,1,Length(Answer)-1)) = Answer[Length(Answer)])  then
  begin
    ServerBlankAnswerCount:=0;
    SL:=TStringList.Create;
    try
      SL.CommaText:=Copy(Answer,2,Length(Answer)-3);
      for j:=0 to SL.Count-1 do
      begin
        if Copy(SL[j],1,1) = 'T' then  // Получена метка времени от сервера
        begin
          S:=SL[j];
          Delete(S,1,1);
          DT:=StrToDateTimeDef(S,Now);
          if Abs(Now-DT) > 10*OneSecond then // Если время отличается от
          begin                              // серверного, то корректировать
            DecodeDateTime(DT,yy,mm,dd,hh,nn,ss,ms);
            ST.wYear:=yy;
            ST.wMonth:=mm;
            ST.wDay:=dd;
            ST.wHour:=hh;
            ST.wMinute:=nn;
            ST.wSecond:=ss;
            ST.wMilliseconds:=0;
            SetLocalTime(ST);
          end;
        end
        else
        if Copy(SL[j],1,1) = 'D' then  // Получены данные от сервера по запросу
        begin
          S:=SL[j];
          Delete(S,1,1);
          PtName:=Copy(S,1,Pos(';',S)-1);
          E:=Caddy.Find(PtName);
          if Assigned(E) then
          begin
            Delete(S,1,Pos(';',S));
            W:=S;
            if (W = 'NOLINK') or (W = 'NOINBASE') then
            begin
              E.TimeOutCounter := 0;
              E.RealTime := 0;
// обмен не произведен, выставляем аларм, если его не было
              if not (asNoLink in E.AlarmStatus) then
              begin
                Caddy.AddAlarm(asNoLink,E);
                E.FirstCalc := True;
                if E.IsGroup then (E as TCustomGroup).ChildNoFetch;
              end;
              E.HasCommand := False;
              if Caddy.FetchList[0].SaveToLog then
                PushFetchToLog(0,'Ответ от ' + E.PtName + '('+
                IntToStr(GetTickCount-Caddy.FetchList[0].TickCount)+'): '+SL[j]+#13#10);
              Continue;
            end;
            // Распаковка данных из символьного формата
            S := '';
            i := Length(W);
            while (i > 0) and ((i div 2)*2 = i) do
            begin
              S:=S+Chr(StrToIntDef('$'+Copy(W,1,2),0) and $ff);
              Delete(W,1,2);
              i:=Length(W);
            end;
            if Length(S) > 0 then
            begin
// обмен произведен, удаляем аларм, если он был
              if asNoLink in E.AlarmStatus then
              begin
                Caddy.RemoveAlarm(asNoLink,E);
                if E.IsGroup then (E as TCustomGroup).ChildYesFetch;
              end;
              try
                E.Fetch(S); // обработка полученных данных
                if Caddy.FetchList[0].SaveToLog then
                  PushFetchToLog(0,'Ответ от '+E.PtName+'('+
                  IntToStr(GetTickCount-Caddy.FetchList[0].TickCount)+'): '+SL[j]+#13#10);
              finally
                E.HasCommand:=False;
              end;
            end;
          end;
        end
        else
        if Copy(SL[j],1,1) = 'Y' then  // Принято подтверждение от сервера на команду
        begin
          S:=SL[j];
          Delete(S,1,1);
          PtName:=Copy(S,1,Pos(';',S)-1);
          Delete(S,1,Pos(';',S));
          if S = 'OK' then
            ShowMessage:=PtName+': команда принята сервером.';
          if S = 'NOINBASE' then
            ShowMessage:=PtName+': позиция не найдена на сервере.';
        end;
      end; { of for }
    finally
      SL.Free;
    end;
  end
  else
  if Length(Answer) = 0 then
  begin
    if ServerBlankAnswerCount < 5 then
    begin
      Inc(ServerBlankAnswerCount);
      Exit;
    end;
    E:=Caddy.FirstEntity;
    while Assigned(E) do
    try
      if E.Actived and not E.LocalFetchOnly then
      begin
        try
          Inc(E.BadFetchsCount);
        except
          E.GoodFetchsCount:=1;
          E.BadFetchsCount:=1;
          E.BadFatalFetchsCount:=0;
        end;
        E.FetchIndex:=0;
        if E.IsVirtual then
          Index:=0
        else
          Index:=E.Channel;
        if (Index >= 0) and (Index <= ChannelCount) then
        with Caddy.FetchList[Index] do
        begin
          if E.TimeOutCounter < RepeatCount then
            Inc(E.TimeOutCounter)
          else
          begin
            E.TimeOutCounter:=0;
            E.RealTime:=0;
            try
              Inc(E.BadFatalFetchsCount);
            except
              E.GoodFetchsCount:=1;
              E.BadFetchsCount:=1;
              E.BadFatalFetchsCount:=1;
            end;
// обмен не произведен, выставляем аларм, если его не было
            if not (asNoLink in E.AlarmStatus) then
            begin
              Caddy.AddAlarm(asNoLink,E);
              E.FirstCalc:=True;
              if E.IsGroup then (E as TCustomGroup).ChildNoFetch;
            end;
            E.HasCommand:=False;
          end;
        end;
      end;
      E:=E.NextEntity;
    except
      Break;
    end;
  end;
end;

procedure TRemXForm.FetchVirtual;
var n: integer; IsClient: boolean;
  procedure ClearData;
  begin
    with Caddy.FetchList[0] do
    begin
      ReqEnt:=nil;
    end;
  end;
begin
  IsClient:=(Caddy.NetRole = nrClient);
  n:=100;
  repeat
    try
      with Caddy.FetchList[0] do
      if List.Count > 0 then
      begin
        try
          ReqEnt:=List.Extract(List.First); // получение точки
          if Assigned(ReqEnt) and ReqEnt.Actived then
          begin
            if IsClient and not ReqEnt.LocalFetchOnly then
              List.Add(ReqEnt)
            else
            begin
 // обмен произведен, удаляем аларм, если он был
              if (asNoLink in ReqEnt.AlarmStatus) then
                Caddy.RemoveAlarm(asNoLink,ReqEnt);
              ReqEnt.Fetch; // обработка полученных данных
              ReqEnt.HasCommand:=False;
              ReqEnt:=nil;
            end;
          end;
        except
          List.Clear;
          ClearData;
          Break;
        end;
      end
      else
        Break;
      Dec(n);
    except
      Break;
    end;
  until n <= 0;
end;

procedure TRemXForm.SetShortUserName(const Value: string);
begin
  FShortUserName := Value;
  Caddy.Autor := Value;
end;

procedure TRemXForm.CloseCommonDialogForm;
var i: integer;
begin
  for i:=0 to Screen.FormCount-1 do
  if Screen.Forms[i].ClassType = TCommonDialogForm then
  begin
    with Screen.Forms[i] as TCommonDialogForm do
    begin
      if Button2.Visible then
        Button2.Click
      else
        Button1.Click;
    end;
  end;
end;

procedure TRemXForm.ShowWarning(AText: string; ModalView: boolean = True);
var
  CommonDialogForm: TCommonDialogForm;
  n: integer;
begin
  if not ModalView then
  begin
    for n := 0 to Screen.FormCount - 1 do
    if Screen.Forms[n].ClassType = TPanelForm then
    begin
      with Screen.Forms[n] as TPanelForm do
      begin
        ClearStatus.Enabled:=False;
        StatusBar.Color:=clYellow;
        StatusBar.Font.Color:=clBlack;
        StatusBar.Caption:=AText;
        StatusPaintBox.Invalidate;
        ClearStatus.Enabled:=True;
      end;
    end;
  end
  else
  begin
    CloseCommonDialogForm;
    CommonDialogForm:=TCommonDialogForm.Create(Self);
    try
      with CommonDialogForm do
      begin
        Caption:='Предупреждение';
        TextLabel.Caption:=AText;
        ImageList1.Draw(CommonDialogForm.Image1.Canvas,0,0,0);
        Button2.Visible:=False;
        Button1.Left:=Button1.Left+(Button2.Left+Button2.Width-Button1.Left) div 2;
        Button1.Caption:='OK';
        CommonDialogForm.ShowModal;
      end;
    finally
      CommonDialogForm.Free;
    end;
  end;
end;

function TRemXForm.ShowQuestion(AText: string): TModalResult;
var CommonDialogForm: TCommonDialogForm;
begin
  CloseCommonDialogForm;
  CommonDialogForm:=TCommonDialogForm.Create(Self);
  try
    with CommonDialogForm do
    begin
      Caption:='Подтверждение';
      TextLabel.Caption:=AText;
      ImageList1.Draw(CommonDialogForm.Image1.Canvas,0,0,0);
      Result:=CommonDialogForm.ShowModal;
    end;
  finally
    CommonDialogForm.Free;
  end;
end;

procedure TRemXForm.ShowError(AText: string; ModalView: boolean = True);
var
  CommonDialogForm: TCommonDialogForm;
  n: integer;
begin
  if not ModalView then
  begin
    for n := 0 to Screen.FormCount - 1 do
    if Screen.Forms[n].ClassType = TPanelForm then
    begin
      with Screen.Forms[n] as TPanelForm do
      begin
        ClearStatus.Enabled:=False;
        StatusBar.Color:=clRed;
        StatusBar.Font.Color:=clWhite;
        StatusBar.Caption:=AText;
        StatusPaintBox.Invalidate;
        ClearStatus.Enabled:=True;
      end;
    end;
  end
  else
  begin
    CloseCommonDialogForm;
    CommonDialogForm:=TCommonDialogForm.Create(Self);
    try
      with CommonDialogForm do
      begin
        Caption:='Ошибка';
        TextLabel.Caption:=AText;
        ImageList1.Draw(CommonDialogForm.Image1.Canvas,0,0,3);
        Button2.Visible:=False;
        Button1.Left:=Button1.Left+(Button2.Left+Button2.Width-Button1.Left) div 2;
        Button1.Caption:='OK';
        CommonDialogForm.ShowModal;
      end;
    finally
      CommonDialogForm.Free;
    end;
  end;
end;

procedure TRemXForm.ShowInfo(AText: string; ModalView: boolean = True);
var
  CommonDialogForm: TCommonDialogForm;
  n: integer;
begin
  if not ModalView then
  begin
    begin
    for n := 0 to Screen.FormCount - 1 do
    if Screen.Forms[n].ClassType = TPanelForm then
    begin
      with Screen.Forms[n] as TPanelForm do
      begin
        ClearStatus.Enabled:=False;
        StatusBar.Color:=clBtnFace;
        StatusBar.Font.Color:=clBtnText;
        StatusBar.Caption:=AText;
        StatusPaintBox.Invalidate;
        ClearStatus.Enabled:=True;
      end;
    end;
    end;
  end
  else
  begin
    CloseCommonDialogForm;
    CommonDialogForm:=TCommonDialogForm.Create(Self);
    try
      with CommonDialogForm do
      begin
        Caption:='Информация';
        TextLabel.Caption:=AText;
        ImageList1.Draw(CommonDialogForm.Image1.Canvas,0,0,1);
        Button2.Visible:=False;
        Button1.Left:=Button1.Left+(Button2.Left+Button2.Width-Button1.Left) div 2;
        Button1.Caption:='OK';
        CommonDialogForm.ShowModal;
      end;
    finally
      CommonDialogForm.Free;
    end;
  end;
end;

procedure TRemXForm.ShowPassport(E: TEntity; const MonitorNum: integer);
var
  F: TForm;
  n: integer;
begin
//------------------------------------------------------
// Выдача паспорта в новое окно панели
  for n := 0 to Screen.FormCount - 1 do
  if (Screen.Forms[n].ClassType = TPanelForm) and
     (Screen.Forms[n].Monitor.MonitorNum = MonitorNum) then
  begin
    F:=(Screen.Forms[n] as TPanelForm).PaspForms.Body[EntityClassIndex(E.ClassType)+1];
    if Assigned(F) then
    begin
      with F as IEntity do
      begin
        ConnectImageList(TImageList(Caddy.ScreenSizeIndex));
        ConnectEntity(E);
      end;
      F.Show;
      with (Screen.Forms[n] as TPanelForm) do
      begin
        TopForm := F;
        CaptionLabel.Caption := 'Паспорт ' + E.PtName;
      end;
    end
    else
      ShowInfo('Этот тип точек не имеет паспорта.');
    Break;
  end;
end;

procedure TRemXForm.miAboutClick(Sender: TObject);
var KeyWord: string;
begin
  ShowSplashForm:=TShowSplashForm.Create(Self);
  try
    with ShowSplashForm do
    begin
      BorderStyle:=bsDialog;
      CloseButton.Visible:=True;
    end;
    KeyWord:=Config.ReadString('UserInfo','Key','');
    if Authorization(KeyWord) then
      ShowSplashForm.Caption:='Владелец копии: '+
                              Config.ReadString('UserInfo','Name','');
    ShowSplashForm.ShowModal;
  finally
    ShowSplashForm.Free;
  end;
end;

procedure TRemXForm.TableNotify(var Mess: TMessage);
var i: integer;
begin
  for i := 0 to Screen.FormCount - 1 do
  if (Screen.Forms[i].ClassType = TShowTablesForm) then
  begin
    with Screen.Forms[i] as TShowTablesForm do
      UpdateTableView;
  end;
// Automatic report print
  for i:=1 to WatchList.Length do
  if WatchList.Body[i].StartTime <= Now then
  begin
    if WatchList.Body[i].ShiftTime > 0.0 then
      WatchList.Body[i].StartTime:=
         WatchList.Body[i].StartTime+WatchList.Body[i].ShiftTime
    else
      WatchList.Body[i].StartTime:=WatchList.Body[i].StartTime+1.0;
    if not WatchList.Body[i].HandStart then
    begin
      Caddy.AddChange('Система','Отчёт','','Старт',
                                 WatchList.Body[i].Descriptor, 'Автономно');
      PrintReport(WatchList.Body[i].FileName,WatchList.Body[i].Descriptor);
      Caddy.AddChange('Система','Отчёт','','Стоп',
                                 WatchList.Body[i].Descriptor, 'Автономно');
    end;
  end;
// Start calculating averages
  with TSaveTableAverages.Create(Caddy.CurrentTablePath) do
  begin
    OnTerminate:=Caddy.ThreadFinished;
    OnShowMessage:=ShowThreadMessage;
    Resume;
  end;
end;

procedure TRemXForm.TrendNotify(var Mess: TMessage);
var i: integer;
begin
  for i := 0 to Screen.FormCount - 1 do
  if (Screen.Forms[i].ClassType = TShowTrendsForm) then
  begin
    with Screen.Forms[i] as TShowTrendsForm do
      ReloadTrends;
  end;
end;

procedure TRemXForm.SetShowMessage(const Value: string);
var i: integer;
begin
  for i := 0 to Screen.FormCount - 1 do
  if (Screen.Forms[i].ClassType = TPanelForm) then
  begin
    with Screen.Forms[i] as TPanelForm do
    begin
      ClearStatus.Enabled:=False;
      StatusBar.Color:=clBtnFace;
      StatusBar.Font.Color:=clBtnText;
      StatusBar.Caption:=Value;
      StatusPaintBox.Invalidate;
      ClearStatus.Enabled:=True;
    end;
    Break;
  end;
end;

procedure TRemXForm.CaddyMessage(Sender: TObject;
                                 Kind: TKindMessage; Mess: string);
begin
  FCaddyMessage:=Mess;
  PostMessage(Handle,WM_CommandResult,Ord(Kind),Integer(Sender));
end;

procedure TRemXForm.WMCommandResult(var Mess: TMessage);
begin
  case TKindMessage(Mess.WParam) of
    kmError:   ShowError(FCaddyMessage,Caddy.NetRole <> nrServer);
    kmWarning: ShowWarning(FCaddyMessage,Caddy.NetRole <> nrServer);
    kmInfo:    ShowInfo(FCaddyMessage,Caddy.NetRole <> nrServer);
    kmStatus:  ShowMessage := FCaddyMessage;
    kmLog:     Caddy.AddSysMess(FCaddySource, FCaddyMessage);
  end;
  FCaddyMessage:='';
end;

procedure TRemXForm.FetchTimer(Sender: TObject);
begin
  Fetch.Enabled:=False;
  try
    if (Registered or Bonus) then
      case Caddy.NetRole of
  nrStandAlone, nrServer: FetchPorts; // Обмен данными из списков опроса
                nrClient: FetchFromStationLink;
      end;
    FetchVirtual;
  finally
    Fetch.Enabled:=True;
  end;
end;

procedure TRemXForm.PushFetchToLog(Index: integer; Source: string);
var T: TextFile; FileName: string;
begin
  FileName:=IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
  if Index = 0 then
    FileName:=FileName+'Netlink.log'
  else
    FileName:=FileName+'Channel'+IntToStr(Index)+'.log';
  AssignFile(T,FileName);
  if FileExists(FileName) then
    Append(T)
  else
    Rewrite(T);
  try
    Writeln(T,Source);
  finally
    CloseFile(T);
  end;
end;

function TRemXForm.Decode(Source: string): string;
var i: integer;
begin
  Result:='';
  for i:=1 to Length(Source) do
    Result:=Result+' '+IntToHex(Ord(Source[i]),2);
end;

procedure TRemXForm.FetchPorts;
var i: integer;
    S: string;
  procedure ResetReqEnt(var RE: TEntity);
  begin
    RE.FetchIndex:=0;
    RE.TimeOutCounter:=0;
    RE.RealTime:=0;
// обмен не произведен, выставляем аларм, если его не было
    if not (asNoLink in RE.AlarmStatus) then
    begin
      Caddy.AddAlarm(asNoLink,RE);
      RE.FirstCalc:=True;
      if RE.IsGroup then (RE as TCustomGroup).ChildNoFetch;
    end;
    RE.HasCommand:=False;
    RE:=nil;
  end;
begin
  for i:=1 to ChannelCount do
  with Caddy.FetchList[i] do
  if not UseNet and ComLink.Connected then
  begin
    if not ComLink.Busy and (List.Count > 0) then
    begin
      ReqEnt:=List.Extract(List.First); // получение точки
      if Assigned(ReqEnt) and ReqEnt.Actived then
      begin
        ComLink.RequestData(ReqEnt.Prepare); // строка запроса
        TickCount:=GetTickCount;
        if SaveToLog then
          PushFetchToLog(i,
            FormatDateTime('dd.mm.yy, hh:nn:ss.zzz',Now)+
            ' Запрос к '+ReqEnt.PtName+'['+
                            ReqEnt.TypeCode+']: '+Decode(ReqEnt.Prepare));
      end;
    end;
  end
  else
  if UseNet and TcpLink.Active then
  begin
    if not TcpLink.Busy and (List.Count > 0) then
    begin
      ReqEnt:=List.Extract(List.First); // получение точки
      if Assigned(ReqEnt) and ReqEnt.Actived then
      begin
        S := ReqEnt.Prepare;
        with TcpLink do
        case LinkType of
          0: SendToServer(TStringStream.Create(S+TKontLink.CCS(S))); // Kontrast
          1: SendToServer(TStringStream.Create(#0#0#0#0#0+Chr(Length(S))+S)); // Modbus Ethernet
          2: SendToServer(TStringStream.Create(S+TKontLink.MRC(S))); // Metakon
          3: SendToServer(TStringStream.Create(S+TKontLink.ERC(S))); // Elemer
        end;
        TickCount:=GetTickCount;
        if SaveToLog then
          PushFetchToLog(i,
           FormatDateTime('dd.mm.yy, hh:nn:ss.zzz',Now)+
          ' Запрос к '+ReqEnt.PtName+'['+
                            ReqEnt.TypeCode+']: '+Decode(ReqEnt.Prepare));
      end
    end
  end
  else
  if (not UseNet and ComLink.Connected or
      UseNet and TcpLink.Active) and (List.Count > 0) then
  begin
    ReqEnt:=List.Extract(List.First); // получение точки
    if Assigned(ReqEnt) then ResetReqEnt(ReqEnt);
  end
end;

procedure TRemXForm.ComLinkReadData(Sender: TObject; const Packet: string;
  const ErrCode: Cardinal);
var Index: integer; Answer: String; AT: Cardinal;
begin
  Index:=(Sender as TKontLink).Channel;
  if (Index >= 0) and (Index <= ChannelCount) then
  with Caddy.FetchList[Index] do
  begin
    Answer:=Packet;
    if Assigned(ReqEnt) then
    begin
      AT:=GetTickCount-TickCount;
      if ReqEnt.MaxAnswerTime < AT then ReqEnt.MaxAnswerTime:=AT;
      if SaveToLog then
        PushFetchToLog(Index,
        FormatDateTime('dd.mm.yy, hh:nn:ss.zzz',Now)+
             ' Ответ от '+ReqEnt.PtName+'('+
        IntToStr(AT)+'): '+Decode(Answer)+#13#10);
      ReqEnt.TimeOutCounter:=0;
      try
        Inc(ReqEnt.GoodFetchsCount);
      except
        ReqEnt.GoodFetchsCount:=0;
        ReqEnt.BadFetchsCount:=0;
        ReqEnt.BadFatalFetchsCount:=0;
      end;
// обмен произведен, удаляем аларм, если он был
      if asNoLink in ReqEnt.AlarmStatus then
      begin
        Caddy.RemoveAlarm(asNoLink,ReqEnt);
        if ReqEnt.IsGroup then (ReqEnt as TCustomGroup).ChildYesFetch;
      end;
      ReqEnt.Fetch(Answer); // обработка полученных данных
      ReqEnt.HasCommand:=False;
      ReqEnt:=nil;
    end;
  end;
end;

procedure TRemXForm.ComLinkTimeout(Sender: TObject);
var Channel: integer;
begin
  Channel:=(Sender as TKontLink).Channel;
  if (Channel >= 0) and (Channel <= ChannelCount) then
  with Caddy.FetchList[Channel] do
  begin
    if Assigned(ReqEnt) then
    begin
      try
        Inc(ReqEnt.BadFetchsCount);
      except
        ReqEnt.GoodFetchsCount := 1;
        ReqEnt.BadFetchsCount := 1;
        ReqEnt.BadFatalFetchsCount := 0;
      end;
      if SaveToLog then
        PushFetchToLog(Channel,
                      FormatDateTime('dd.mm.yy, hh:nn:ss.zzz',Now)+
                      Format(' Таймаут%d '+ReqEnt.PtName+'(%d)',
                     [ReqEnt.TimeOutCounter+1, GetTickCount-TickCount])+#13#10);
      ReqEnt.FetchIndex := 0;
      if ReqEnt.TimeOutCounter < RepeatCount then
      begin
        Inc(ReqEnt.TimeOutCounter);
        List.Insert(0, ReqEnt);
      end
      else
      begin
        ReqEnt.TimeOutCounter := 0;
        ReqEnt.RealTime := 0;
        try
          Inc(ReqEnt.BadFatalFetchsCount);
        except
          ReqEnt.GoodFetchsCount := 1;
          ReqEnt.BadFetchsCount := 1;
          ReqEnt.BadFatalFetchsCount := 1;
        end;
// обмен не произведен, выставляем аларм, если его не было
        if not (asNoLink in ReqEnt.AlarmStatus) then
        begin
          Caddy.AddAlarm(asNoLink, ReqEnt);
          ReqEnt.FirstCalc := True;
          if ReqEnt.IsGroup then (ReqEnt as TCustomGroup).ChildNoFetch;
        end;
        ReqEnt.HasCommand := False;
        ReqEnt := nil;
      end;
    end;
  end;
end;

procedure TRemXForm.ApplicationEventsException(Sender: TObject;
  E: Exception);
var FileName,S: string; F: TextFile;
begin
  FileName:=ChangeFileExt(Application.ExeName,'.log');
  AssignFile(F,FileName);
  if FileExists(FileName) then
    Append(F)
  else
    Rewrite(F);
  try
    S:=FormatDateTime('dd.mm.yyyy hh:nn:ss',Now)+#9+E.Message;
    Writeln(F,S);
  finally
    CloseFile(F);
  end;
  Caddy.AddSysMess('Ошибка',E.Message);
  ShowError(E.Message,Caddy.NetRole <> nrServer);
end;

procedure TRemXForm.LogNotify(var Mess: TMessage);
var i: integer;
begin
  for i := 0 to Screen.FormCount - 1 do
  if (Screen.Forms[i].ClassType = TShowLogsForm) then
  begin
    with Screen.Forms[i] as TShowLogsForm do
      UpdateLog;
  end;
end;

function TRemXForm.Get_Val(Entry: string): Variant;
var PtName,PtParam: string; C: TEntity;
begin
  PtName:=Copy(Entry,1,Pos('.',Entry)-1);
  PtParam:=Copy(Entry,Pos('.',Entry)+1,Length(Entry));
  C:=Caddy.Find(PtName);
  if Assigned(C) then
  begin
    if UpperCase(PtParam) = 'PV' then
    begin
      if C.IsAnalog and not C.IsParam then
        Result:=(C as TCustomAnaOut).PV
      else
      if C.IsDigit and not C.IsParam then
        Result:=(C as TCustomDigOut).PV
      else
        Result:='#PAR?';
    end
    else
    if UpperCase(PtParam) = 'LASTPV' then
    begin
      if C.IsAnalog and not C.IsParam then
        Result:=(C as TCustomAnaOut).LASTPV
      else
        Result:='#PAR?';
    end
    else
    if UpperCase(PtParam) = 'EUDESC' then
    begin
      if C.IsAnalog and not C.IsParam then
        Result:=(C as TCustomAnaOut).EUDesc
      else
        Result:='#PAR?';
    end
    else
    if UpperCase(PtParam) = 'PTTEXT' then
      Result:=C.PtText
    else
    if UpperCase(PtParam) = 'PTVAL' then
      Result:=C.PtVal
    else
    if UpperCase(PtParam) = 'PTDESC' then
      Result:=C.PtDesc
    else
    if UpperCase(PtParam) = 'OP' then
    begin
      if C.IsAnalog and C.IsParam then
        Result:=(C as TCustomAnaInp).OP
      else
      if C.IsDigit and C.IsParam then
        Result:=(C as TCustomDigInp).OP
      else
      if C.IsKontur then
        Result:=(C as TCustomAnaOut).FOP
      else
        Result:='#PAR?';
    end
    else
    if UpperCase(PtParam) = 'SP' then
    begin
      if C.IsKontur then
        Result:=(C as TCustomAnaOut).FSP
      else
        Result:='#PAR?';
    end
    else
    if UpperCase(PtParam) = 'PVEUHI' then
    begin
      if C.IsAnalog and not C.IsParam then
        Result:=(C as TCustomAnaOut).PVEUHi
      else
        Result:='#PAR?';
    end
    else
    if UpperCase(PtParam) = 'PVEULO' then
    begin
      if C.IsAnalog and not C.IsParam then
        Result:=(C as TCustomAnaOut).PVEULo
      else
        Result:='#PAR?';
    end
    else
    if UpperCase(PtParam) = 'SPEUHI' then
    begin
      if C.IsKontur then
        Result:=(C as TCustomAnaOut).FSPEUHi
      else
        Result:='#PAR?';
    end
    else
    if UpperCase(PtParam) = 'SPEULO' then
    begin
      if C.IsKontur then
        Result:=(C as TCustomAnaOut).FSPEULo
      else
        Result:='#PAR?';
    end
    else
      Result:='#PAR?';
  end
  else
    Result:='#FND?';
end;

function TRemXForm.GetAbs_HourAver(Day,Hour: integer; Entry: string;
                                   AverVal,AbsVal: boolean): Double;
var iGroup,iPlace: integer; PtName: string; iKind: byte; Quality: boolean;
begin
  Result:=0.0;
  PtName:=Copy(Entry,1,Pos('.',Entry)-1);
  if Pos('.PV',Entry)>0 then iKind:=0
  else if Pos('.SP',Entry)>0 then iKind:=1
  else if Pos('.OP',Entry)>0 then iKind:=2
  else iKind:=255;
  for iGroup:=1 to 125 do
  with Caddy.HistGroups[iGroup] do
  if not Empty then
  for iPlace:=1 to 8 do
  if Assigned(Entity[iPlace]) and (Place[iPlace] = PtName) and
    (Kind[iPlace] = iKind)then
  begin
    if AbsVal then
      Result:=QueryHourValue(iGroup,iPlace,
               StartOfTheDay(IncDay(Now,-Day))+OneHour*Hour,AverVal,Quality)
    else
      Result:=QueryHourValue(iGroup,iPlace,Now-Hour*OneHour,AverVal,Quality);
    Break;
  end;
end;

function TRemXForm.Abs_HourAver(Day, AbsHour: integer; Entry: string;
                                AverVal: boolean): Double;
begin
  Result:=GetAbs_HourAver(Day,AbsHour,Entry,AverVal,True);
end;

function TRemXForm.Get_HourAver(Hour: integer; Entry: string;
                                AverVal: boolean): Double;
begin
  Result:=GetAbs_HourAver(0,Hour,Entry,AverVal,False);
end;

function TRemXForm.Abs_Hour(Day, AbsHour: integer; Entry: string): Double;
begin
  Result:=Abs_HourAver(Day,AbsHour,Entry,False);
end;

function TRemXForm.Abs_Aver(Day, AbsHour: integer; Entry: string): Double;
begin
  Result:=Abs_HourAver(Day,AbsHour,Entry,True);
end;

function TRemXForm.Get_Hour(Hour: integer; Entry: string): Double;
begin
  Result:=Get_HourAver(Hour,Entry,False);
end;

function TRemXForm.Get_Aver(Hour: integer; Entry: string): Double;
begin
  Result:=Get_HourAver(Hour,Entry,True);
end;

procedure TRemXForm.FastReportBeginDoc;
begin
  frVariables['THIS_OPERATOR']:=Caddy.Autor;
  frVariables['THIS_OBJECT']:=Config.ReadString('General','ObjectName','');
  frVariables['THIS_STATION']:=Config.ReadString('General','StationName','');
  frVariables['THIS_YEAR']:=YearOf(Now);
  frVariables['THIS_MONTH']:=MonthOf(Now);
  frVariables['THIS_DAY']:=DayOf(Now);
  frVariables['THIS_HOUR']:=HourOf(Now);
end;

{ TRemXFuncLib }

constructor TRemXFuncLib.Create;
begin
  inherited Create;
  with List do
  begin
    Add('THIS_OPERATOR');
    Add('THIS_OBJECT');
    Add('THIS_STATION');
    Add('THIS_YEAR');
    Add('THIS_MONTH');
    Add('THIS_DAY');
    Add('THIS_HOUR');
    Add('DATE_BACK');
    Add('DAYSCOUNT');
    Add('GET_VAL');
    Add('GET_HOUR');
    Add('ABS_HOUR');
    Add('GET_AVER');
    Add('ABS_AVER');
  end;
end;

procedure TRemXForm.DocumentRemXReportFunctions;
begin
  frAddFunctionDesc(RemXFuncLib, 'THIS_OPERATOR', 'RemX',
   'THIS_OPERATOR(<Число>)/Возвращает фамилию и инициалы текущего пользователя.');
  frAddFunctionDesc(RemXFuncLib, 'THIS_OBJECT', 'RemX',
   'THIS_OBJECT/Возвращает наименование объекта.');
  frAddFunctionDesc(RemXFuncLib, 'THIS_STATION', 'RemX',
   'THIS_STATION/Возвращает наименование станции.');
  frAddFunctionDesc(RemXFuncLib, 'THIS_YEAR', 'RemX',
   'THIS_YEAR/Возвращает номер текущего года.');
  frAddFunctionDesc(RemXFuncLib, 'THIS_MONTH', 'RemX',
   'THIS_MONTH/Возвращает номер текущего месяца.');
  frAddFunctionDesc(RemXFuncLib, 'THIS_DAY', 'RemX',
   'THIS_DAY/Возвращает номер текущего дня.');
  frAddFunctionDesc(RemXFuncLib, 'THIS_HOUR', 'RemX',
   'THIS_HOUR/Возвращает номер текущего часа.');
//-------------------------------------------------
  frAddFunctionDesc(RemXFuncLib, 'DATE_BACK', 'RemX',
   'DATE_BACK(DAY)/Возвращает дату DAY суток назад. 0 - текущая дата,'+
   ' 1 - вчерашняя дата.');
  frAddFunctionDesc(RemXFuncLib, 'DAYSCOUNT', 'RemX',
   'DAYSCOUNT(YEAR,MONTH)/Возвращает количество дней месяца MONTH в году YEAR.');
  frAddFunctionDesc(RemXFuncLib, 'GET_VAL', 'RemX',
   'GET_VAL(''ENTITY.PARAM'')/Возвращает значение параметра PARAM'+
   ' точки ENTITY. Допустимые значения PARAM: PV, SP, OP,'+
   ' PTDESC, EUDESC, PTTEXT, PVEUHI, PVEULO, SPEUHI, SPEULO.');
  frAddFunctionDesc(RemXFuncLib, 'GET_HOUR', 'RemX',
   'GET_HOUR(HOUR,''ENTITY.PARAM'')/Возвращает значение параметра PARAM'+
   ' точки ENTITY в HOUR часов назад. 0 - текущий час, 1 -'+
   ' один час назад и т.д. Допустимые значения PARAM: PV, SP, OP для'+
   ' точек в таблице часовых значений.');
  frAddFunctionDesc(RemXFuncLib, 'ABS_HOUR', 'RemX',
   'ABS_HOUR(DAY,HOUR,''ENTITY.PARAM'')/Возвращает значение параметра PARAM'+
   ' точки ENTITY в HOUR часов DAY cуток назад. Часы: 0..23. Сутки:'+
   ' 0 - текущие сутки, 1 - одни сутки назад и т.д.'+
   ' PARAM: PV, SP, OP для точек в таблице часовых значений.');
  frAddFunctionDesc(RemXFuncLib, 'GET_AVER', 'RemX',
   'GET_AVER(HOUR,''ENTITY.PARAM'')/Возвращает часовое усреднение параметра PARAM'+
   ' точки ENTITY в HOUR часов назад. 0 - текущий час, 1 -'+
   ' один час назад и т.д. Допустимые значения PARAM: PV, SP, OP для'+
   ' точек в таблице часовых усреднений.');
  frAddFunctionDesc(RemXFuncLib, 'ABS_AVER', 'RemX',
   'ABS_AVER(DAY,HOUR,''ENTITY.PARAM'')/Возвращает часовое усреднение параметра PARAM'+
   ' точки ENTITY в HOUR часов DAY cуток назад. Часы: 0..23. Сутки:'+
   ' 0 - текущие сутки, 1 - одни сутки назад и т.д.'+
   ' PARAM: PV, SP, OP для точек в таблице часовых усреднений.');
end;

procedure TRemXFuncLib.DoFunction(FNo: Integer; p1, p2, p3: Variant;
  var val: Variant);
begin
  val:=0;
  case FNo of
    0: val:=Caddy.Autor;
    1: val:=Config.ReadString('General','ObjectName','');
    2: val:=Config.ReadString('General','StationName','');
    3: val:=YearOf(Now);
    4: val:=MonthOf(Now);
    5: val:=DayOf(Now);
    6: val:=HourOf(Now);
    7: val:=IncDay(Now,-frParser.Calc(p1));
    8: val:=DaysInAMonth(frParser.Calc(p1),frParser.Calc(p2));
    9: val:=RemXForm.Get_Val(AnsiDequotedStr(frParser.Calc(p1),''''));
   10: val:=RemXForm.Get_Hour(frParser.Calc(p1),
                              AnsiDequotedStr(frParser.Calc(p2),''''));
   11: val:=RemXForm.Abs_Hour(frParser.Calc(p1),frParser.Calc(p2),
                              AnsiDequotedStr(frParser.Calc(p3),''''));
   12: val:=RemXForm.Get_Aver(frParser.Calc(p1),
                               AnsiDequotedStr(frParser.Calc(p2),''''));
   13: val:=RemXForm.Abs_Aver(frParser.Calc(p1),frParser.Calc(p2),
                               AnsiDequotedStr(frParser.Calc(p3),''''));
  end;
end;

procedure TRemXForm.FillWatchList;
var St,Sh: TDateTime; i: integer; SL: TStrings;
begin
  RunTimeReports.Clear;
  LoadWatchList;
//------------------------------
  SL:=TStringList.Create;
  try
    RunTimeReports.ReadSections(SL);
    if SL.Count > High(WatchList.Body) then
      WatchList.Length:=High(WatchList.Body)
    else
      WatchList.Length:=SL.Count;
    for i:=0 to WatchList.Length-1 do
    begin
      WatchList.Body[i+1].FileName:=RunTimeReports.ReadString(SL[i],'FileName','');
      WatchList.Body[i+1].ShiftTime:=RunTimeReports.ReadTime(SL[i],'ShiftTime',0.0);
      WatchList.Body[i+1].Descriptor:=RunTimeReports.ReadString(SL[i],'Descriptor','');
      WatchList.Body[i+1].HandStart:=RunTimeReports.ReadBool(SL[i],'HandStart',False);
      St:=Int(Now)+RunTimeReports.ReadTime(SL[i],'StartTime',0.0);
      Sh:=RunTimeReports.ReadTime(SL[i],'ShiftTime',0.0);
      WatchList.Body[i+1].ShiftTime:=Sh;
      if Sh > 0.0 then
        while St < Now do St:=St+Sh
      else
        if St < Now then St:=St+1.0;
      WatchList.Body[i+1].StartTime:=St;
    end;
  finally
    SL.Free;
  end;
end;

procedure TRemXForm.LoadWatchList;
var FileName: string; M: TMemoryStream; List: TStringList;
begin
  Screen.Cursor:=crHourGlass;
  try
    List:=TStringList.Create;
    M:=TMemoryStream.Create;
    try
      FileName:=IncludeTrailingPathDelimiter(Caddy.CurrentBasePath)+'RTMRPRTS.CFG';
      if FileExists(FileName) then
      begin
        if LoadStream(FileName,M) then
        begin
          List.LoadFromStream(M);
          RunTimeReports.SetStrings(List);
        end
        else
          Caddy.AddSysMess('Загрузка списка пользователей',
                         'Ошибка при загрузке списка автоматических отчетов');
      end;
    finally
      M.Free;
      List.Free;
    end;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TRemXForm.SaveReportToReportsLog(Report: TfrReport;
          HandStart: boolean; Category: string);
var FileName,DirName: string; F: TFileStream;
    ReportItem: TCashReportItem; M: TMemoryStream; MS: Int64;
begin
  ReportItem.SnapTime:=Now;
  ReportItem.Station:=Caddy.Station;
  ReportItem.HandStart:=HandStart;
  ReportItem.Category:=Category;
  ReportItem.Descriptor:=Report.Title;
  DirName:=IncludeTrailingPathDelimiter(Caddy.CurrentReportsLogPath)+
           FormatDateTime('yymmdd',ReportItem.SnapTime);
  FileName:=IncludeTrailingPathDelimiter(DirName)+
            'PREPRD'+FormatDateTime('hh',ReportItem.SnapTime)+'.LOG';
  F := TryOpenToWriteFile(DirName,FileName);
  if Assigned(F) then
  begin
    M:=TMemoryStream.Create;
    try
      F.Seek(0,soFromEnd);
      F.WriteBuffer(ReportItem.SnapTime,SizeOf(ReportItem.SnapTime));
      F.WriteBuffer(ReportItem.Station,SizeOf(ReportItem.Station));
      F.WriteBuffer(ReportItem.HandStart,SizeOf(ReportItem.HandStart));
      F.WriteBuffer(ReportItem.Category,SizeOf(ReportItem.Category));
      F.WriteBuffer(ReportItem.Descriptor,SizeOf(ReportItem.Descriptor));
      Report.EMFPages.SaveToStream(M); M.Position:=0; MS:=M.Size;
      F.WriteBuffer(MS,SizeOf(MS));
      M.SaveToStream(F);
    finally
      F.Free;
      M.Free;
    end;
  end;
end;

procedure TRemXForm.actTuningUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled:=(Caddy.UserLevel > 4);
end;

procedure TRemXForm.actCloseGamesExecute(Sender: TObject);
var hwnd: THandle;
begin
  if IsWinNT and MyProcIsShell then
  begin
    hwnd := FindWindow('Solitaire','Косынка');
    if hwnd <> 0 then
    begin
      PostMessage(hwnd,WM_SYSCOMMAND,SC_CLOSE,0);
      Caddy.AddSysMess('Система',
                   'Карточная игра "Косынка" обнаружена и закрыта системой.');
    end;
    hwnd := FindWindow('FreeWClass',nil);
    if hwnd <> 0 then
    begin
      PostMessage(hwnd,WM_SYSCOMMAND,SC_CLOSE,0);
      Caddy.AddSysMess('Система',
        'Карточная игра "Солитер" обнаружена и была попытка ее закрыть системой.');
    end;
    hwnd := FindWindow(nil,'Сапер');
    if hwnd <> 0 then
    begin
      PostMessage(hwnd,WM_SYSCOMMAND,SC_CLOSE,0);
      Caddy.AddSysMess('Система','Игра "Сапер" обнаружена и закрыта системой.');
    end;
    hwnd := FindWindow(nil,'Пинбол для Windows - "Звездный юнга"');
    if hwnd <> 0 then
    begin
      PostMessage(hwnd,WM_SYSCOMMAND,SC_CLOSE,0);
      Caddy.AddSysMess('Система','Игра "Пинбол" обнаружена и закрыта системой.');
    end;
  end;
end;

procedure PrintReportByName(RepName,RepDesc: string);
var frReport: TfrReport;
begin
  if FileExists(RepName) then
  begin
    frReport:=TfrReport.Create(RemXForm);
    try
      frReport.ShowProgress:=False;
      if frReport.LoadFromFile(RepName) then
      begin
        frReport.Title:=RepDesc;
        frReport.OnBeginDoc:=RemXForm.FastReportBeginDoc;
        if frReport.PrepareReport then
        begin
          RemXForm.SaveReportToReportsLog(frReport,False,'Отчеты');
          frReport.PrintPreparedReport('',1,False,frAll);
        end;
      end
      else
        RemXForm.ShowMessage:='Файл отчета'+RepName+' не загружается!';
    finally
      frReport.Free;
    end;
  end
  else
    RemXForm.ShowMessage:='Файл отчета'+RepName+' не существует!';
end;

procedure TRemXForm.PrintReport(sReport,sDesc: string);
begin
  if FileExists(IncludeTrailingPathDelimiter(Caddy.CurrentReportsPath)+sReport) then
    PrintReportByName(IncludeTrailingPathDelimiter(Caddy.CurrentReportsPath)+
                      sReport,sDesc)
  else
   ShowMessage:='Файл отчета '+sReport+' не существует!';
end;

procedure TRemXForm.CheckAutor;
var KeyWord: string;
begin
  KeyWord:=Config.ReadString('UserInfo','Key','');
  Registered:=Authorization(KeyWord);
end;

function TRemXForm.Authorization(KeyWord: String): Boolean;
var SerialNumber: DWord; MCL,FCF: Cardinal;
    Mask: Byte; i,Sum: integer; W: RConv; S,User: String;
begin
  if GetVolumeInformation('C:\',nil,0,@SerialNumber,MCL,FCF,nil,0) then
  begin
    User:=Config.ReadString('UserInfo','Name','');
    if Length(User)>0 then
    begin
      S:=UpperCase(User);
      Sum:=0;
      for i:=1 to Length(S) do Inc(Sum,Ord(S[i]));
      while Sum >= 256 do Sum:=Sum mod 256 + Sum div 256;
      Mask:=Sum and $00FF;
      W.BIG:=SerialNumber;
      for i:=0 to 3 do W.Small[i]:=W.Small[i] xor Mask;
      W.BIG:=(W.BIG xor $12369156) or $11236915;
      if Format('%x',[W.BIG]) = UpperCase(KeyWord) then
          Result:=True
      else
        Result:=False;
    end
    else
      Result:=False;
  end
  else
    Result:=False;
end;

function TRemXForm.UserInformation(User: String): Cardinal;
var SerialNumber: DWord; MCL,FCF: Cardinal;
    Mask: Byte; i,Sum: integer; W: RConv; S: String;
begin
  if GetVolumeInformation('C:\',nil,0,@SerialNumber,MCL,FCF,nil,0) then
  begin
    if Length(User) > 0 then Config.WriteString('UserInfo','Name',User);
     S:=UpperCase(User);
     Sum:=0;
     for i:=1 to Length(S) do Inc(Sum,Ord(S[i]));
     while Sum >= 256 do Sum:=Sum mod 256 + Sum div 256;
     Mask:=Sum and $00FF;
     W.BIG:=SerialNumber;
     for i:=0 to 3 do W.Small[i]:=W.Small[i] xor Mask;
     Result:=W.BIG;
  end
  else
    Result:=0;
end;

procedure TRemXForm.AveragesNotify(var Mess: TMessage);
begin
  ShowMessage:='Подсчёт усреднений закончен.';
end;

procedure TRemXForm.WmTimeChange(var Mess: TWMTIMECHANGE);
begin
  Caddy.AddChange('Система', 'Время',
                  FormatDateTime('dd.mm.yy hh:nn:ss',DateTimeCheck),
                  FormatDateTime('dd.mm.yy hh:nn:ss',Now),
                  'Время станции изменено.', 'Автономно');
end;

procedure TRemXForm.ShowThreadMessage(Sender: TObject; Mess: string);
begin
  ShowMessage:=Mess;
end;

//procedure TRemXForm.actImportOldConfigExecute(Sender: TObject);
//begin
//  ImportStorageForm:=TImportStorageForm.Create(Self);
//  try
//    ImportStorageForm.ShowModal;
//    Application.Terminate;
//  finally
//    ImportStorageForm.Free;
//  end;
//end;

procedure TRemXForm.CaddyQuestion(Sender: TObject; Question: string;
  var Result: boolean);
begin
  Result:=(ShowQuestion(Question) = mrOk);
end;

procedure TRemXForm.NodeWDogsTimer(Sender: TObject);
var T: TTimer;
begin
  T:=Sender as TTimer;
  T.Enabled:=False;
end;

procedure TRemXForm.FreshTimer(Sender: TObject);
var i: integer;
begin
  Fresh.Enabled:=False;
  try
    Caddy.Blink:=not Caddy.Blink;
    with Screen do
      for i := 0 to FormCount - 1 do
      begin
        if Forms[i].Showing and Supports(Forms[i], IFresh) then
         (Forms[i] as IFresh).FreshView;
        if Forms[i].Showing and Supports(Forms[i], IEntity) then
         (Forms[i] as IEntity).UpdateRealTime;
      end;
  finally
    Fresh.Enabled:=True;
  end;
end;

// Обмен с контроллерами по TCP/IP
procedure TRemXForm.TcpLinkReadData(Sender: TObject;
  const AnswerPacket: TNetBuff; const AnswerSize: integer);
var Channel: integer; Answer: String; AT: Cardinal;
begin
  if not (Sender is TTcpLink) then Exit;
  Channel := (Sender as TTcpLink).Channel;
  if (Channel >= 0) and (Channel <= ChannelCount) then
  with Caddy.FetchList[Channel] do
  if AnswerSize > 0 then
  begin
    case LinkType of
  0,2: begin // ltKontrast,ltMetakon
         SetLength(Answer, AnswerSize-1); // без байта контрольной суммы
         Move(AnswerPacket, Answer[1], AnswerSize-1);
       end;
    1: begin // ltModbus
         SetLength(Answer, AnswerSize-6); // без байтов заголовка
         Move(AnswerPacket[6], Answer[1], AnswerSize-6);
       end;
    3: begin // ltElemer
         SetLength(Answer, AnswerSize-2); // без байтов контрольной суммы
         Move(AnswerPacket, Answer[1], AnswerSize-2);
       end;
    end;
    if Assigned(ReqEnt) then
    begin
      AT := GetTickCount-TickCount;
      if ReqEnt.MaxAnswerTime < AT then ReqEnt.MaxAnswerTime := AT;
      if SaveToLog then
        PushFetchToLog(Channel,
        FormatDateTime('dd.mm.yy, hh:nn:ss.zzz',Now)+
        ' Ответ от '+ReqEnt.PtName+'('+
        IntToStr(AT)+'): '+Decode(Answer)+#13#10);
      ReqEnt.TimeOutCounter := 0;
      try
        Inc(ReqEnt.GoodFetchsCount);
      except
        ReqEnt.GoodFetchsCount := 0;
        ReqEnt.BadFetchsCount := 0;
        ReqEnt.BadFatalFetchsCount := 0;
      end;
// обмен произведен, удаляем аларм, если он был
      if asNoLink in ReqEnt.AlarmStatus then
      begin
        Caddy.RemoveAlarm(asNoLink, ReqEnt);
        if ReqEnt.IsGroup then (ReqEnt as TCustomGroup).ChildYesFetch;
      end;
      ReqEnt.Fetch(Answer); // обработка полученных данных
      ReqEnt.HasCommand := False;
      ReqEnt := nil;
    end;
  end;
end;

procedure TRemXForm.TcpLinkTimeOut(Sender: TObject);
var Channel: integer;
begin
  if not (Sender is TTcpLink) then Exit;
  Channel := (Sender as TTcpLink).Channel;
  if (Channel >= 0) and (Channel <= ChannelCount) then
  with Caddy.FetchList[Channel] do
  if Assigned(ReqEnt) then
  begin
    try
      Inc(ReqEnt.BadFetchsCount);
    except
      ReqEnt.GoodFetchsCount := 1;
      ReqEnt.BadFetchsCount := 1;
      ReqEnt.BadFatalFetchsCount := 0;
    end;
    if SaveToLog then
      PushFetchToLog(Channel,
                    FormatDateTime('dd.mm.yy, hh:nn:ss.zzz',Now)+
                    Format(' Таймаут%d '+ReqEnt.PtName+'(%d)',
                   [ReqEnt.TimeOutCounter+1, GetTickCount-TickCount])+#13#10);
    ReqEnt.FetchIndex := 0;
    if ReqEnt.TimeOutCounter < RepeatCount then
    begin
      Inc(ReqEnt.TimeOutCounter);
      List.Insert(0, ReqEnt);
    end
    else
    begin
      ReqEnt.TimeOutCounter := 0;
      ReqEnt.RealTime := 0;
      try
        Inc(ReqEnt.BadFatalFetchsCount);
      except
        ReqEnt.GoodFetchsCount := 1;
        ReqEnt.BadFetchsCount := 1;
        ReqEnt.BadFatalFetchsCount := 1;
      end;
// обмен не произведен, выставляем аларм, если его не было
      if not (asNoLink in ReqEnt.AlarmStatus) then
      begin
        Caddy.AddAlarm(asNoLink, ReqEnt);
        ReqEnt.FirstCalc := True;
        if ReqEnt.IsGroup then (ReqEnt as TCustomGroup).ChildNoFetch;
      end;
      ReqEnt.HasCommand := False;
      ReqEnt := nil;
    end;
  end;
end;

end.
