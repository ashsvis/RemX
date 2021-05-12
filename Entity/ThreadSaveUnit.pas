unit ThreadSaveUnit;

interface

uses
  Windows, SysUtils, Classes, Controls, Graphics,
  EntityUnit, SyncObjs, DB, ADODB;

type
  TThreadShowMessage = procedure(Sender: TObject; Mess: string) of object;

  TProtoThread = class(TThread)
  private
    FOnShowMessage: TThreadShowMessage;
    FOnLogMessage: TThreadShowMessage;
  public
    property OnShowMessage: TThreadShowMessage read FOnShowMessage
                                               write FOnShowMessage;
    property OnLogMessage: TThreadShowMessage read FOnLogMessage
                                              write FOnLogMessage;
  end;

  TDeleteTree = class(TProtoThread)
  private
    Path: array of string;
    BeforeTime: array of integer;
    Deleting: array of boolean;
    procedure DelTree(Mask: string; OldestTime: Integer);
  protected
    procedure Execute; override;
  public
    constructor Create(RootPath: array of string;
                       BeforeDate: array of TDateTime;
                       CanDeleting: array of boolean);
  end;

  TSaveTableAverages = class(TProtoThread)
  private
    Path,MessText: string;
    procedure ShowMessage;
  protected
    procedure Execute; override;
  public
    constructor Create(CurrentTablePath: string);
  end;

  TSaveRealTrends = class(TProtoThread)
  private
    Path,MessText: string;
    TrendsCash: TCashRealTrendArray;
    procedure ShowMessage;
  protected
    procedure Execute; override;
  public
    constructor Create(CurrentTrendPath: string;
                       var ATrendsCash: TCashRealTrendArray);
  end;

  TExportMinuteTables = class(TProtoThread)
  private
    MessText,ConnStr: string;
    ExportMinuteSnapLog: TCashExportTableArray;
    procedure ShowMessage;
    procedure LogMessage;
  protected
    procedure Execute; override;
  public
    constructor Create(ConnectionString: string;
                       var AExportMinuteSnapLog: TCashExportTableArray);
  end;

  TSaveTableTrends = class(TProtoThread)
  private
    Path,MessText: string;
    MinuteSnapLog: TCashGroupTableArray;
    HourSnapLog: TCashGroupTableArray;
    procedure ShowMessage;
  protected
    procedure Execute; override;
  public
    constructor Create(CurrentTablePath: string;
                       var AMinuteSnapLog, AHourSnapLog: TCashGroupTableArray);
  end;

  TSaveRealValues = class(TProtoThread)
  private
    Path,MessText: string;
    RealValuesCash: TCashRealBaseArray;
    procedure ShowMessage;
  protected
    procedure Execute; override;
  public
    constructor Create(CurrentBasePath: string;
                       var ARealValuesCash: TCashRealBaseArray);
  end;

  TSaveAlarmLog = class(TProtoThread)
  private
    Path,MessText: string;
    AlarmLog: TCashAlarmLogArray;
    procedure ShowMessage;
  protected
    procedure Execute; override;
  public
    constructor Create(CurrentLogsPath: string;
                       var AAlarmLog: TCashAlarmLogArray);
  end;

  TSaveSwitchLog = class(TProtoThread)
  private
    Path,MessText: string;
    SwitchLog: TCashSwitchLogArray;
    procedure ShowMessage;
  protected
    procedure Execute; override;
  public
    constructor Create(CurrentLogsPath: string;
                       var ASwitchLog: TCashSwitchLogArray);
  end;

  TSaveChangeLog = class(TProtoThread)
  private
    Path,MessText: string;
    ChangeLog: TCashChangeLogArray;
    procedure ShowMessage;
  protected
    procedure Execute; override;
  public
    constructor Create(CurrentLogsPath: string;
                       var AChangeLog: TCashChangeLogArray);
  end;

  TSaveSystemLog = class(TProtoThread)
  private
    Path,MessText: string;
    SystemLog: TCashSystemLogArray;
    procedure ShowMessage;
  protected
    procedure Execute; override;
  public
    constructor Create(CurrentLogsPath: string;
                       var ASystemLog: TCashSystemLogArray);
  end;

implementation

uses DateUtils, CRCCalcUnit, ActiveX;

var
  DeleteTreeSection: TCriticalSection;
  RealBaseSection: TCriticalSection;
  RealTrendSection: TCriticalSection;
  RealSnapMinTableSection: TCriticalSection;
  ExportSnapMinTableSection: TCriticalSection;
  RealSnapHourTableSection: TCriticalSection;
  SaveLogsSection: TCriticalSection;
  AverHourTableSection: array[1..125] of TCriticalSection;

{ TSaveRealTrends }

constructor TSaveRealTrends.Create(CurrentTrendPath: string;
                                   var ATrendsCash: TCashRealTrendArray);
begin
  Path:=CurrentTrendPath;
  Move(ATrendsCash,TrendsCash,SizeOf(TrendsCash));
  inherited Create(True);
  Priority:=tpLower;
  FreeOnTerminate:=True;
end;

procedure TSaveRealTrends.Execute;
var
  i: integer;
  OldFileName, FileName, DirName: string;
  Item: TCashRealTrendItem;
  F: TFileStream;
begin
  RealTrendSection.Enter;
  try
    OldFileName := '';
    F := nil;
    for i := 1 to TrendsCash.Length do
    begin
      if Terminated then Break;
      Item := TrendsCash.Body[i];
      DirName := IncludeTrailingPathDelimiter(Path)+
                 FormatDateTime('yymmdd\hh', Item.SnapTime);
      FileName := IncludeTrailingPathDelimiter(DirName) + Item.ParamName;
      if OldFileName <> FileName then
      begin
        FreeAndNil(F);
        F := TryOpenToWriteFile(DirName, FileName);
        OldFileName := FileName;
      end;
      if Assigned(F) then
      begin
        F.Seek(0, soFromEnd);
        F.WriteBuffer(Item.SnapTime, SizeOf(Item.SnapTime));
        F.WriteBuffer(Item.Value, SizeOf(Item.Value));
        F.WriteBuffer(Item.Kind, SizeOf(Item.Kind));
      end
      else
      begin
        MessText:='Файл "'+ExtractFileName(FileName)+
                    '" занят другим процессом. Тренд не сохранен.';
        Synchronize(ShowMessage);
        Break;
      end;
    end;
    if Assigned(F) then FreeAndNil(F);
  finally
    RealTrendSection.Leave;
  end;
end;

procedure TSaveRealTrends.ShowMessage;
begin
  if Assigned(FOnShowMessage) then FOnShowMessage(Self, MessText);
end;

{ TExportMinuteTables }

constructor TExportMinuteTables.Create(ConnectionString: string;
                           var AExportMinuteSnapLog: TCashExportTableArray);
begin
  ConnStr := ConnectionString;
  Move(AExportMinuteSnapLog,ExportMinuteSnapLog,SizeOf(ExportMinuteSnapLog));
  inherited Create(True);
  Priority:=tpLower;
  FreeOnTerminate:=True;
end;

procedure TExportMinuteTables.Execute;
var i, n: integer; Item: TCashExportTableItem; dts : string;
    Command : WideString; norm : Boolean;
begin
  ExportSnapMinTableSection.Enter;
  CoInitialize(nil);
  try
    norm := True;
    //Synchronize(UpdateServer);
    with TADOQuery.Create(nil) do
    try
      //ConnectionString := 'Provider=SQLOLEDB.1;Password=mngr;Persist Security Info=True;User ID=mngr;Initial Catalog=RemX;Data Source=EPKS';
      //ConnectionString := 'Provider=SQLOLEDB.1;Server=tcp:volgagas.database.windows.net,1433;Initial Catalog=RemX;Persist Security Info=False;User ID=remxuser;Password=DA4cXuixtf;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;';
      ConnectionString := ConnStr;
      n := ExportMinuteSnapLog.Length;
      for i:=1 to n do
      begin
        if Terminated then Break;
        Item:=ExportMinuteSnapLog.Body[i];
        DateTimeToString(dts, 'yyyy-mm-dd hh:nn', Item.SnapTime);
        DecimalSeparator := '.';
        Command := Format('insert into [dbo].[data] ([moment], [sensor], [value])' +
          ' values (''%s'', ''%s'', %.3f);', [dts, Item.Position, Item.Val]);
        try
          SQL.Text := Command;
          ExecSQL;
        except
          on EE: Exception do
          begin
            norm := False;
          end;
        end;
      end;
      if norm then
      begin
        MessText := Format('Экспортировано %s %s %s.',
              [NumToStr(n,'табличн','ое','ых','ых'),
               NumToStr(n,'минутн','ое','ых','ых', False),
               NumToStr(n,'значен','ие','ия','ий', False)]);
        ShowMessage;
      end
      else
      begin
         MessText := 'Ошибка при экспорте табличных минутных значений.';
         ShowMessage;
         //LogMessage;
      end;
    finally
      Free;
    end;
  finally
    CoUninitialize;
    ExportSnapMinTableSection.Leave;
  end;
end;

procedure TExportMinuteTables.ShowMessage;
begin
  if Assigned(FOnShowMessage) then FOnShowMessage(Self, MessText);
end;

procedure TExportMinuteTables.LogMessage;
begin
  if Assigned(FOnLogMessage) then FOnLogMessage(Self, MessText);
end;

{ TSaveTableTrends }

constructor TSaveTableTrends.Create(CurrentTablePath: string;
                                    var AMinuteSnapLog,
                                    AHourSnapLog: TCashGroupTableArray);
begin
  Path:=CurrentTablePath;
  Move(AMinuteSnapLog,MinuteSnapLog,SizeOf(MinuteSnapLog));
//  MinuteSnapLog:=Copy(AMinuteSnapLog);
  Move(AHourSnapLog,HourSnapLog,SizeOf(HourSnapLog));
//  HourSnapLog:=Copy(AHourSnapLog);
  inherited Create(True);
  Priority:=tpLower;
  FreeOnTerminate:=True;
end;

procedure TSaveTableTrends.Execute;
var
  i,j: integer;
  OldFileName, FileName, DirName: string;
  Item: TCashTrendTableItem;
  F: TFileStream;
begin
  RealSnapMinTableSection.Enter;
  try
    OldFileName := '';
    F := nil;
    for i:=1 to MinuteSnapLog.Length do
    begin
      if Terminated then Break;
      Item:=MinuteSnapLog.Body[i];
      DirName:=IncludeTrailingPathDelimiter(Path)+
               ATableType[ttMinSnap]+FormatDateTime('\yymmdd\hh',Item.SnapTime);
      FileName:=IncludeTrailingPathDelimiter(DirName)+
                Format('%3.3d.TBL',[Item.GroupNo]);
      if OldFileName <> FileName then
      begin
        FreeAndNil(F);
        F := TryOpenToWriteFile(DirName, FileName);
        OldFileName := FileName;
      end;
      if Assigned(F) then
      begin
        F.Seek(0,soFromEnd);
        F.WriteBuffer(Item.SnapTime,SizeOf(Item.SnapTime));
        for j:=1 to 8 do
        begin
          F.WriteBuffer(Item.Val[j],SizeOf(Item.Val[j]));
          F.WriteBuffer(Item.Quality[j],SizeOf(Item.Quality[j]));
        end;
      end
      else
      begin
        MessText:='Файл "'+ExtractFileName(FileName)+
              '" занят другим процессом. Минутные значения не сохранены.';
        Synchronize(ShowMessage);
        Break;
      end;
    end;
    if Assigned(F) then FreeAndNil(F);
  finally
    RealSnapMinTableSection.Leave;
  end;
// ---------------------------------------------
  RealSnapHourTableSection.Enter;
  try
    OldFileName := '';
    F := nil;
    for i:=1 to HourSnapLog.Length do
    begin
      if Terminated then Break;
      Item:=HourSnapLog.Body[i];
      DirName:=IncludeTrailingPathDelimiter(Path)+
               ATableType[ttHourSnap]+FormatDateTime('\yymmdd\hh',Item.SnapTime);
      FileName:=IncludeTrailingPathDelimiter(DirName)+
                Format('%3.3d.TBL',[Item.GroupNo]);
      if OldFileName <> FileName then
      begin
        FreeAndNil(F);
        F := TryOpenToWriteFile(DirName, FileName);
        OldFileName := FileName;
      end;
      if Assigned(F) then
      begin
        F.Seek(0,soFromEnd);
        F.WriteBuffer(Item.SnapTime,SizeOf(Item.SnapTime));
        for j:=1 to 8 do
        begin
          F.WriteBuffer(Item.Val[j],SizeOf(Item.Val[j]));
          F.WriteBuffer(Item.Quality[j],SizeOf(Item.Quality[j]));
        end;
      end
      else
      begin
        MessText:='Файл "'+ExtractFileName(FileName)+
                  '" занят другим процессом. Часовые значения не сохранены.';
        Synchronize(ShowMessage);
        Break;
      end;
    end;
    if Assigned(F) then FreeAndNil(F);
  finally
    RealSnapHourTableSection.Leave;
  end;
end;

procedure TSaveTableTrends.ShowMessage;
begin
  if Assigned(FOnShowMessage) then FOnShowMessage(Self,MessText);
end;

{ TSaveRealValues }

constructor TSaveRealValues.Create(CurrentBasePath: string;
                                   var ARealValuesCash: TCashRealBaseArray);
begin
  Path:=CurrentBasePath;
  Move(ARealValuesCash,RealValuesCash,SizeOf(RealValuesCash));
  inherited Create(True);
  Priority:=tpLower;
  FreeOnTerminate:=True;
end;

procedure TSaveRealValues.Execute;
var i, ek: integer;
    DirName, FileName, BackName: string;
    Item: TCashRealBaseItem;
    F: TFileStream;
    AF,M: TMemoryStream;
    CRC32: Cardinal;
begin
  RealBaseSection.Enter;
  try
    M:=TMemoryStream.Create;
    AF:=TMemoryStream.Create;
    try
      for i:=1 to RealValuesCash.Length do
      begin
        Item:=RealValuesCash.Body[i];
        AF.WriteBuffer(Item,SizeOf(Item));
      end;
      if AF.Size > 0 then
      begin
        AF.Position:=0;
        M.Clear;
        CompressStream(AF,M);
      end
      else
        M.Clear;
      CRC32:=0;
      CalcCRC32(M.Memory,M.Size,CRC32);
      DirName:=Path;
      FileName:=IncludeTrailingPathDelimiter(DirName)+'REALBASE.VAL';
      BackName:=ChangeFileExt(FileName,'.~VAL');
      if FileExists(BackName) and DeleteFile(BackName) or
         not FileExists(BackName) then
      begin
        if FileExists(FileName) and RenameFile(FileName,BackName) or
           not FileExists(FileName) and (M.Size > 0) then
        begin
          F:=nil;
          ek:=10;
          repeat
            try
              F:=TFileStream.Create(FileName,fmCreate or fmShareExclusive);
              Break;
            except
              MessText:='Файл "'+ExtractFileName(FileName)+
                        '" занят другим процессом.';
              Synchronize(ShowMessage);
              Dec(ek);
              Wait500ms;
            end;
          until ek < 0;
          if (ek < 0) or not Assigned(F) then
          begin
            MessText:='Файл "'+ExtractFileName(FileName)+
                      '" занят другим процессом. Счетчики не сохранены.';
            Synchronize(ShowMessage);
            Exit;
          end;
          try
            F.WriteBuffer(CRC32,SizeOf(CRC32));
            M.Position:=0;
            M.SaveToStream(F);
          finally
            F.Free;
          end;
        end;
      end;
    finally
      AF.Free;
      M.Free;
    end;
  finally
    RealBaseSection.Leave;
  end;
end;

procedure TSaveRealValues.ShowMessage;
begin
  if Assigned(FOnShowMessage) then FOnShowMessage(Self,MessText);
end;

{ TSaveTableAverages }

constructor TSaveTableAverages.Create(CurrentTablePath: string);
begin
  Path:=CurrentTablePath;
  inherited Create(True);
  Priority:=tpLower;
  FreeOnTerminate:=True;
end;

procedure TSaveTableAverages.Execute;
var DirName,FileName: string; GroupIndex,i: integer;
    F: TFileStream; Item: TCashTrendTableItem;
    AverVal: array[1..8] of Extended;
    AverQuality: array[1..8] of Boolean;
    AverCount: array[1..8] of Integer;
    ErrFlag: boolean; D: TDateTime;
    yy,mm,dd,hh,nn,ss,ms: word;
begin
  DecodeDateTime(Now,yy,mm,dd,hh,nn,ss,ms);
  D:=EncodeDateTime(yy,mm,dd,hh,0,0,0);
  for GroupIndex:=1 to 125 do
  begin
    if Terminated then Exit;
    AverHourTableSection[GroupIndex].Enter;
    try
      DirName:=IncludeTrailingPathDelimiter(Path)+
               ATableType[ttMinSnap]+FormatDateTime('\yymmdd\hh',D);
      FileName:=IncludeTrailingPathDelimiter(DirName)+
                Format('%3.3d.TBL',[GroupIndex]);
      if FileExists(FileName) then
      begin
        F:=TryOpenToReadFile(FileName);
        if not Assigned(F) then
        begin
          MessText:='Файл "'+ExtractFileName(FileName)+
                    '" занят другим процессом. Таблица не загружена!';
          Synchronize(ShowMessage);
          Exit;
        end;
        try
          for i:=1 to 8 do
          begin
            AverVal[i]:=0.0;
            AverQuality[i]:=True;
            AverCount[i]:=0;
          end;
          F.Seek(0,soFromBeginning);
          ErrFlag:=False;
          while F.Position < F.Size do
          begin
            if Terminated then Break;
            try
              F.ReadBuffer(Item.SnapTime,SizeOf(Item.SnapTime));
              for i:=1 to 8 do
              begin
                F.ReadBuffer(Item.Val[i],SizeOf(Item.Val[i]));
                F.ReadBuffer(Item.Quality[i],SizeOf(Item.Quality[i]));
                AverVal[i]:=AverVal[i]+Item.Val[i];
                AverCount[i]:=AverCount[i]+1;
                if not Item.Quality[i] then AverQuality[i]:=False;
              end;
            except
              on E: Exception do
              begin
                MessText:=E.Message;
                ErrFlag:=True;
                Break;
              end;
            end;
          end;
        finally
          F.Free;
        end;
        if not ErrFlag then
        begin
          for i:=1 to 8 do
          begin
            if AverCount[i] > 0 then
            begin
              AverVal[i]:=AverVal[i]/AverCount[i];
              if AverCount[i] <> 60 then AverQuality[i]:=False;
            end;
            Item.Val[i]:=AverVal[i];
            Item.Quality[i]:=AverQuality[i];
          end;
          DirName:=IncludeTrailingPathDelimiter(Path)+
                   ATableType[ttHourAver]+FormatDateTime('\yymmdd\hh',D);
          FileName:=IncludeTrailingPathDelimiter(DirName)+
                    Format('%3.3d.TBL',[GroupIndex]);
          F:=TryOpenToWriteFile(DirName,FileName);
          if Assigned(F) then
          begin
            try
              F.Seek(0,soFromBeginning);
              F.WriteBuffer(D,SizeOf(D));
              for i:=1 to 8 do
              begin
                F.WriteBuffer(Item.Val[i],SizeOf(Item.Val[i]));
                F.WriteBuffer(Item.Quality[i],SizeOf(Item.Quality[i]));
              end;
            finally
              F.Free;
            end;
          end
          else
          begin
            MessText:='Файл "'+ExtractFileName(FileName)+
                '" занят другим процессом. Часовые усреднения не сохранены.';
            Synchronize(ShowMessage);
          end;
        end
        else
          Synchronize(ShowMessage);
      end;
    finally
      AverHourTableSection[GroupIndex].Leave;
    end;
  end;
end;

procedure TSaveTableAverages.ShowMessage;
begin
  if Assigned(FOnShowMessage) then FOnShowMessage(Self,MessText);
end;

procedure InitCriticalSections;
var i: integer;
begin
  DeleteTreeSection:=TCriticalSection.Create;
  RealBaseSection:=TCriticalSection.Create;
  RealTrendSection:=TCriticalSection.Create;
  RealSnapMinTableSection:=TCriticalSection.Create;
  ExportSnapMinTableSection:=TCriticalSection.Create;
  RealSnapHourTableSection:=TCriticalSection.Create;
  SaveLogsSection:=TCriticalSection.Create;
  for i:=1 to 125 do AverHourTableSection[i]:=TCriticalSection.Create;
end;

procedure FinitCriticalSections;
var i: integer;
begin
  for i:=1 to 125 do AverHourTableSection[i].Free;
  ExportSnapMinTableSection.Free;
  RealSnapMinTableSection.Free;
  RealSnapHourTableSection.Free;
  SaveLogsSection.Free;
  RealTrendSection.Free;
  RealBaseSection.Free;
  DeleteTreeSection.Free;
end;

{ TDeleteTree }

constructor TDeleteTree.Create(RootPath: array of string;
                               BeforeDate: array of TDateTime;
                               CanDeleting: array of boolean);
var i: integer;
begin
  SetLength(Path,Length(RootPath));
  for i:=0 to Length(Path)-1 do Path[i]:=RootPath[i];
  SetLength(BeforeTime,Length(BeforeDate));
  for i:=0 to Length(BeforeTime)-1 do
    BeforeTime[i]:=DateTimeToFileDate(BeforeDate[i]);
  SetLength(Deleting,Length(CanDeleting));
  for i:=0 to Length(Deleting)-1 do Deleting[i]:=CanDeleting[i];
  inherited Create(True);
  Priority:=tpLower;
  FreeOnTerminate:=True;
end;

procedure TDeleteTree.DelTree(Mask: string; OldestTime: Integer);
var SR: TSearchRec; S: string;
begin
  S:=Mask+'*.*';
  if FindFirst(S,faAnyFile,SR) = 0 then
  begin
    try
      repeat
        if (SR.Name <> '.') and (SR.Name <> '..') then
        begin
          if SR.Attr = faDirectory then
          begin
            DelTree(Mask+SR.Name+'\',OldestTime);
            RemoveDir(Mask+SR.Name);
          end
          else
          if SR.Time < OldestTime then
            DeleteFile(Mask+SR.Name);
        end;
      until FindNext(SR) <> 0;
    finally
      FindClose(SR);
    end;
  end;
end;

procedure TDeleteTree.Execute;
var i: integer;
begin
  DeleteTreeSection.Enter;
  try
    for i:=0 to Length(Path)-1 do
    if Deleting[i] then
      DelTree(Path[i],BeforeTime[i]);
  finally
    DeleteTreeSection.Leave;
  end;
end;

{ TSaveAlarmLog }

constructor TSaveAlarmLog.Create(CurrentLogsPath: string;
                                 var AAlarmLog: TCashAlarmLogArray);
begin
  Path:=CurrentLogsPath;
  Move(AAlarmLog,AlarmLog,SizeOf(AlarmLog));
  inherited Create(True);
  Priority:=tpLower;
  FreeOnTerminate:=True;
end;

procedure TSaveAlarmLog.Execute;
var
  i: integer;
  OldFileName, FileName, DirName: string;
  AlarmItem: TCashAlarmLogItem;
  F: TFileStream;
begin
  SaveLogsSection.Enter;
  try
    OldFileName := '';
    F := nil;
    for i:=1 to AlarmLog.Length do
    begin
      if Terminated then Exit;
      AlarmItem:=AlarmLog.Body[i];
      DirName:=IncludeTrailingPathDelimiter(Path)+
               FormatDateTime('yymmdd\hh',AlarmItem.SnapTime);
      FileName:=IncludeTrailingPathDelimiter(DirName)+'ALARMS.LOG';
      if OldFileName <> FileName then
      begin
        FreeAndNil(F);
        F := TryOpenToWriteFile(DirName,FileName);
        OldFileName := FileName;
      end;
      if Assigned(F) then
      begin
        F.Seek(0,soFromEnd);
        F.WriteBuffer(AlarmItem.SnapTime,SizeOf(AlarmItem.SnapTime));
        F.WriteBuffer(AlarmItem.Station,SizeOf(AlarmItem.Station));
        F.WriteBuffer(AlarmItem.Position,SizeOf(AlarmItem.Position));
        F.WriteBuffer(AlarmItem.Parameter,SizeOf(AlarmItem.Parameter));
        F.WriteBuffer(AlarmItem.Value,SizeOf(AlarmItem.Value));
        F.WriteBuffer(AlarmItem.SetPoint,SizeOf(AlarmItem.SetPoint));
        F.WriteBuffer(AlarmItem.Mess,SizeOf(AlarmItem.Mess));
        F.WriteBuffer(AlarmItem.Descriptor,SizeOf(AlarmItem.Descriptor));
      end
      else
      begin
        MessText:='Файл "'+ExtractFileName(FileName)+
                  '" занят другим процессом. Алармы не сохранены.';
        Synchronize(ShowMessage);
        Break;
      end;
    end;
    if Assigned(F) then FreeAndNil(F);
  finally
    SaveLogsSection.Leave;
  end;
end;

procedure TSaveAlarmLog.ShowMessage;
begin
  if Assigned(FOnShowMessage) then FOnShowMessage(Self,MessText);
end;

{ TSaveSwitchLog }

constructor TSaveSwitchLog.Create(CurrentLogsPath: string;
                                  var ASwitchLog: TCashSwitchLogArray);
begin
  Path:=CurrentLogsPath;
  Move(ASwitchLog,SwitchLog,SizeOf(SwitchLog));
  inherited Create(True);
  Priority:=tpLower;
  FreeOnTerminate:=True;
end;

procedure TSaveSwitchLog.Execute;
var
  i: integer;
  OldFileName, FileName, DirName: string;
  SwitchItem: TCashSwitchLogItem;
  F: TFileStream;
begin
  SaveLogsSection.Enter;
  try
    OldFileName := '';
    F := nil;
    for i:=1 to SwitchLog.Length do
    begin
      if Terminated then Exit;
      SwitchItem:=SwitchLog.Body[i];
      DirName:=IncludeTrailingPathDelimiter(Path)+
               FormatDateTime('yymmdd\hh',SwitchItem.SnapTime);
      FileName:=IncludeTrailingPathDelimiter(DirName)+'SWITCHS.LOG';
      if OldFileName <> FileName then
      begin
        FreeAndNil(F);
        F := TryOpenToWriteFile(DirName,FileName);
        OldFileName := FileName;
      end;
      if Assigned(F) then
      begin
        F.Seek(0,soFromEnd);
        F.WriteBuffer(SwitchItem.SnapTime,SizeOf(SwitchItem.SnapTime));
        F.WriteBuffer(SwitchItem.Station,SizeOf(SwitchItem.Station));
        F.WriteBuffer(SwitchItem.Position,SizeOf(SwitchItem.Position));
        F.WriteBuffer(SwitchItem.Parameter,SizeOf(SwitchItem.Parameter));
        F.WriteBuffer(SwitchItem.OldValue,SizeOf(SwitchItem.OldValue));
        F.WriteBuffer(SwitchItem.NewValue,SizeOf(SwitchItem.NewValue));
        F.WriteBuffer(SwitchItem.Descriptor,SizeOf(SwitchItem.Descriptor));
      end
      else
      begin
        MessText:='Файл "'+ExtractFileName(FileName)+
                  '" занят другим процессом. Свитчи не сохранены.';
        Synchronize(ShowMessage);
        Break;
      end;
    end;
    if Assigned(F) then FreeAndNil(F);
  finally
    SaveLogsSection.Leave;
  end;
end;

procedure TSaveSwitchLog.ShowMessage;
begin
  if Assigned(FOnShowMessage) then FOnShowMessage(Self,MessText);
end;

{ TChangeLog }

constructor TSaveChangeLog.Create(CurrentLogsPath: string;
                                  var AChangeLog: TCashChangeLogArray);
begin
  Path:=CurrentLogsPath;
  Move(AChangeLog,ChangeLog,SizeOf(ChangeLog));
  inherited Create(True);
  Priority:=tpLower;
  FreeOnTerminate:=True;
end;

procedure TSaveChangeLog.Execute;
var i: integer; OldFileName,FileName,DirName: string;
    ChangeItem: TCashChangeLogItem;
    F: TFileStream;
begin
  SaveLogsSection.Enter;
  try
    OldFileName := '';
    F := nil;
    for i:=1 to ChangeLog.Length do
    begin
      if Terminated then Exit;
      ChangeItem:=ChangeLog.Body[i];
      DirName:=IncludeTrailingPathDelimiter(Path)+
               FormatDateTime('yymmdd\hh',ChangeItem.SnapTime);
      FileName:=IncludeTrailingPathDelimiter(DirName)+'CHANGES.LOG';
      if OldFileName <> FileName then
      begin
        FreeAndNil(F);
        F := TryOpenToWriteFile(DirName,FileName);
        OldFileName := FileName;
      end;
      if Assigned(F) then
      begin
        F.Seek(0,soFromEnd);
        F.WriteBuffer(ChangeItem.SnapTime,SizeOf(ChangeItem.SnapTime));
        F.WriteBuffer(ChangeItem.Station,SizeOf(ChangeItem.Station));
        F.WriteBuffer(ChangeItem.Position,SizeOf(ChangeItem.Position));
        F.WriteBuffer(ChangeItem.Parameter,SizeOf(ChangeItem.Parameter));
        F.WriteBuffer(ChangeItem.OldValue,SizeOf(ChangeItem.OldValue));
        F.WriteBuffer(ChangeItem.NewValue,SizeOf(ChangeItem.NewValue));
        F.WriteBuffer(ChangeItem.Autor,SizeOf(ChangeItem.Autor));
        F.WriteBuffer(ChangeItem.Descriptor,SizeOf(ChangeItem.Descriptor));
      end
      else
      begin
        MessText:='Файл "'+ExtractFileName(FileName)+
                  '" занят другим процессом. Действия не сохранены.';
        Synchronize(ShowMessage);
        Break;
      end;
    end;
    if Assigned(F) then FreeAndNil(F);
  finally
    SaveLogsSection.Leave;
  end;
end;

procedure TSaveChangeLog.ShowMessage;
begin
  if Assigned(FOnShowMessage) then FOnShowMessage(Self,MessText);
end;

{ TSystemLog }

constructor TSaveSystemLog.Create(CurrentLogsPath: string;
                                  var ASystemLog: TCashSystemLogArray);
begin
  Path:=CurrentLogsPath;
  Move(ASystemLog,SystemLog,SizeOf(SystemLog));
  inherited Create(True);
  Priority:=tpLower;
  FreeOnTerminate:=True;
end;

procedure TSaveSystemLog.Execute;
var i: integer; OldFileName,FileName,DirName: string;
    SystemItem: TCashSystemLogItem;
    F: TFileStream;
begin
  SaveLogsSection.Enter;
  try
    OldFileName := '';
    F := nil;
    for i:=1 to SystemLog.Length do
    begin
      if Terminated then Exit;
      SystemItem:=SystemLog.Body[i];
      DirName:=IncludeTrailingPathDelimiter(Path)+
               FormatDateTime('yymmdd\hh',SystemItem.SnapTime);
      FileName:=IncludeTrailingPathDelimiter(DirName)+'SYSMESS.LOG';
      if OldFileName <> FileName then
      begin
        FreeAndNil(F);
        F := TryOpenToWriteFile(DirName,FileName);
        OldFileName := FileName;
      end;
      if Assigned(F) then
      begin
        F.Seek(0,soFromEnd);
        F.WriteBuffer(SystemItem.SnapTime,SizeOf(SystemItem.SnapTime));
        F.WriteBuffer(SystemItem.Station,SizeOf(SystemItem.Station));
        F.WriteBuffer(SystemItem.Position,SizeOf(SystemItem.Position));
        F.WriteBuffer(SystemItem.Descriptor,SizeOf(SystemItem.Descriptor));
      end
      else
      begin
        MessText:='Файл "'+ExtractFileName(FileName)+
                  '" занят другим процессом. Сообщения не сохранены.';
        Synchronize(ShowMessage);
        Break;
      end;
    end;
    if Assigned(F) then FreeAndNil(F);
  finally
    SaveLogsSection.Leave;
  end;
end;

procedure TSaveSystemLog.ShowMessage;
begin
  if Assigned(FOnShowMessage) then FOnShowMessage(Self,MessText);
end;

initialization
  InitCriticalSections;

finalization
  FinitCriticalSections;

end.
