library ImportBases;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  Windows, SysUtils, Classes, DBISAMTb, DB, ZLib,
  CRCCalcUnit in '..\Entity\CRCCalcUnit.pas';

{$R *.res}

type
  TAlarmState = (asNoLink,asShortBadPV,asOpenBadPV,asBadPV,asHH,asLL,asON,asOFF,
                 asHi,asLo,asDH,asDL,asInfo,asTimeOut,asNone);
  TSetAlarmStatus = set of TAlarmState;
  TKindStatus = record
    AlarmStatus: TSetAlarmStatus;
    ConfirmStatus: TSetAlarmStatus;
    LostAlarmStatus: TSetAlarmStatus;
  end;
  TCashRealBaseItem = record
    ParamName: string[20];
    SnapTime: TDateTime;
    Value: Double;
    ValText: string[30];
    Kind: TKindStatus;
  end;
  TCashRealBaseArray = array of TCashRealBaseItem;

  TSnapRec = record
               When: Integer;
               Value: Single;
               Valid: boolean;
             end;
var
   LastSessionValue: Integer;
   SessionNameSection: TRTLCriticalSection;
   CashRealValues: TCashRealBaseArray;

function GetNewSession: TDBISAMSession;
begin
   EnterCriticalSection(SessionNameSection);
   try
      LastSessionValue:=LastSessionValue+1;
      Result:=TDBISAMSession.Create(nil);
      with Result do
         SessionName:='AccountSession'+IntToStr(LastSessionValue);
   finally
      LeaveCriticalSection(SessionNameSection);
   end;
end;

procedure CompressStream(aSource,aTarget: TStream);
var comprStream: TCompressionStream;
begin
  comprStream:=TCompressionStream.Create(clMax,aTarget);
  try
    comprStream.CopyFrom(aSource,aSource.Size);
    comprStream.CompressionRate;
  finally
    comprStream.Free;
  end;
end;

procedure SaveValuesToRealBase(FileName: string);
var i,ek: integer; Item: TCashRealBaseItem; F: TFileStream;
    AF,M: TMemoryStream; CRC32: Cardinal;
begin
  M:=TMemoryStream.Create;
  AF:=TMemoryStream.Create;
  try
    for i:=0 to Length(CashRealValues)-1 do
    begin
      Item:=CashRealValues[i];
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
    if M.Size > 0 then
    begin
      F:=nil;
      ek:=10;
      repeat
        try
          F:=TFileStream.Create(FileName,fmCreate or fmShareExclusive);
          Break;
        except
          Dec(ek);
          Windows.Beep(500,20);
          Sleep(500);
        end;
      until ek < 0;
      if (ek < 0) or not Assigned(F) then
        Exit;
      try
        F.WriteBuffer(CRC32,SizeOf(CRC32));
        M.Position:=0;
        M.SaveToStream(F);
      finally
        F.Free;
      end;
    end;
  finally
    AF.Free;
    M.Free;
  end;
end;

procedure AddRealValue(Param: string; Value: Double; ValText: string;
                       Kind: TKindStatus);
var Item: TCashRealBaseItem; i: integer; Found: boolean;
begin
  Found:=False;
  for i:=0 to Length(CashRealValues)-1 do
  if CashRealValues[i].ParamName = Param then
  begin
    CashRealValues[i].SnapTime:=Now;
    CashRealValues[i].Value:=Value;
    CashRealValues[i].ValText:=Copy(ValText,1,30);
    CashRealValues[i].Kind:=Kind;
    Found:=True;
    Break;
  end;
  if not Found then
  begin
    SetLength(CashRealValues,Length(CashRealValues)+1);
    Item.SnapTime:=Now;
    Item.ParamName:=Copy(Param,1,20);
    Item.Value:=Value;
    Item.ValText:=Copy(ValText,1,30);
    Item.Kind:=Kind;
    CashRealValues[Length(CashRealValues)-1]:=Item;
  end;
end;

procedure ReadAllFromFloatTable(BasePath,FileName: PChar); stdcall;
var
   LocalSession: TDBISAMSession;
   LocalDatabase: TDBISAMDatabase;
   LocalSelectQuery: TDBISAMQuery;
   Value: Double; PtName: string;
   KindStatus: TKindStatus;
begin
   LastSessionValue:=0;
   InitializeCriticalSection(SessionNameSection);
   try
   LocalSession:=GetNewSession;
   try
      LocalDatabase:=TDBISAMDatabase.Create(nil);
      try
         with LocalDatabase do
         begin
            SessionName:=LocalSession.SessionName;
            DatabaseName:='Base';
            Directory:=BasePath;
            Connected:=True;
         end;
         LocalSelectQuery:=TDBISAMQuery.Create(nil);
         try
            with LocalSelectQuery do
            begin
               SessionName:=LocalSession.SessionName;
               DatabaseName:=LocalDatabase.DatabaseName;
               SQL.Clear;
               SQL.Add('SELECT * FROM FloatValues');
            end;
            LocalDatabase.StartTransaction;
            try
               LocalSelectQuery.Prepare;
               LocalSelectQuery.Open;
               LocalSelectQuery.First;
               while not LocalSelectQuery.Eof do
               begin
                 PtName:=LocalSelectQuery.FieldByName('Entity').AsString;
                 Value:=LocalSelectQuery.FieldByName('Value').AsFloat;
               //-----------------------------------------------------
                 KindStatus.AlarmStatus:=[];
                 KindStatus.ConfirmStatus:=[];
                 KindStatus.LostAlarmStatus:=[];
                 AddRealValue(PtName,Value,Format('%g',[Value]),KindStatus);
                 LocalSelectQuery.Next;
               end;
               SaveValuesToRealBase(FileName);
               LocalDatabase.Commit(False);
            except
               LocalDatabase.Rollback;
            end;
         finally
            LocalSelectQuery.Free;
         end;
      finally
         LocalDatabase.Free;
      end;
   finally
      LocalSession.Free;
   end;
   finally
     DeleteCriticalSection(SessionNameSection);
   end;
end;

procedure ReadAllFromMinuteTable(Parameters,TrendName,Path: PChar); stdcall;
var Place: integer; R: TSnapRec; SnapTime: TDateTime;
    DirName,FileName,sParams,ParamName: string;
    LocalSession: TDBISAMSession; LocalDatabase: TDBISAMDatabase;
    LocalTable: TDBISAMTable; Stream: TMemoryStream; F: TFileStream;
begin
  LastSessionValue:=0;
  InitializeCriticalSection(SessionNameSection);
  try
  sParams:=Parameters;
  Stream:=TMemoryStream.Create;
  LocalSession:=GetNewSession;
  try
    LocalDatabase:=TDBISAMDatabase.Create(nil);
    try
      with LocalDatabase do
      begin
        SessionName:=LocalSession.SessionName;
        DatabaseName:='Trends';
        Directory:=ExtractFilePath(TrendName);
        Connected:=True;
      end;
      LocalTable:=TDBISAMTable.Create(nil);
      try
        with LocalTable do
        begin
          SessionName:=LocalSession.SessionName;
          DatabaseName:=LocalDatabase.DatabaseName;
          TableName:=ExtractFileName(TrendName);
          IndexName:='WhenIndex';
        end;
        if LocalTable.Exists then
        begin
          LocalDatabase.StartTransaction;
          try
            LocalTable.Open;
            LocalTable.First;
            while not LocalTable.Eof do
            begin
              for Place:=1 to 8 do
              begin
                ParamName:=Copy(sParams,1,Pos(';',sParams)-1);
                Delete(sParams,1,Pos(';',sParams));
                if ParamName <> '' then
                begin
                  Stream.Clear;
                  (LocalTable.FieldByName('Extended'+IntToStr(Place)) as
                      TBlobField).SaveToStream(Stream);
                  Stream.Position:=0;
                  while Stream.Position < Stream.Size do
                  begin
                    Stream.Read(R,SizeOf(TSnapRec));
                    SnapTime:=FileDateToDateTime(R.When);
                    DirName:=Path;
                    DirName:=DirName+FormatDateTime('\yymmdd\hh',SnapTime);
                    if not DirectoryExists(DirName) and
                           ForceDirectories(DirName) or
                       DirectoryExists(DirName) then
                    begin
                      FileName:=DirName+'\'+ParamName;
                      if FileExists(FileName) then
                        F:=TFileStream.Create(FileName,fmOpenWrite or
                                              fmShareExclusive)
                      else
                        F:=TFileStream.Create(FileName,
                                              fmCreate or fmShareExclusive);
                      try
                        F.Seek(0,soFromEnd);
                        F.WriteBuffer(SnapTime,SizeOf(SnapTime));
                        F.WriteBuffer(R.Value,SizeOf(R.Value));
                        F.WriteBuffer(R.Valid,SizeOf(R.Valid));
                      finally
                        F.Free;
                      end;
                    end; { if }
                  end; { while }
                end; { if }
              end; { for }
              LocalTable.Next;
            end;
            LocalTable.Close;
            LocalDatabase.Commit(False);
          except
            LocalDatabase.Rollback;
          end;
        end;
      finally
        LocalTable.Free;
      end;
    finally
      LocalDatabase.Free;
    end;
  finally
    LocalSession.Free;
    Stream.Free;
  end;
  finally
    DeleteCriticalSection(SessionNameSection);
  end;
end;

exports
  ReadAllFromFloatTable,
  ReadAllFromMinuteTable;
begin
  SetLength(CashRealValues,0);
end.
