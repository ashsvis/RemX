unit RmxBaseDataUnit;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, Messages, SysUtils, Classes, ComServ, ComObj, VCLCom, DataBkr,
  DBClient, RmxBaseSvr_TLB, StdVcl;

type
  TRmxBaseData = class(TRemoteDataModule, IRmxBaseData)
    procedure RemoteDataModuleCreate(Sender: TObject);
    procedure RemoteDataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  protected
    class procedure UpdateRegistry(Register: Boolean; const ClassID, ProgID: string); override;
    procedure DeleteKey(const Section, Ident: WideString); safecall;
    procedure EraseSection(const Section: WideString); safecall;
    function GetStrings: WideString; safecall;
    function ReadSection(const Section: WideString): WideString; safecall;
    function ReadSections: WideString; safecall;
    function ReadSectionValues(const Section: WideString): WideString;
      safecall;
    function ReadString(const Section, Ident, Default: WideString): WideString;
      safecall;
    procedure SetStrings(const List: WideString); safecall;
    procedure WriteString(const Section, Ident, Value: WideString); safecall;
    function ReadBinaryStream(const Section, Name: WideString): OleVariant;
      safecall;
    function ReadBool(const Section, Ident: WideString;
      Default: WordBool): WordBool; safecall;
    function ReadDate(const Section, Ident: WideString;
      Default: Double): Double; safecall;
    function ReadDateTime(const Section, Ident: WideString;
      Default: Double): Double; safecall;
    function ReadFloat(const Section, Ident: WideString;
      Default: Double): Double; safecall;
    function ReadInteger(const Section, Ident: WideString;
      Default: Integer): Integer; safecall;
    function ReadTime(const Section, Ident: WideString;
      Default: Double): Double; safecall;
    function SectionExists(const Section: WideString): WordBool; safecall;
    function ValueExists(const Section, Ident: WideString): WordBool; safecall;
    procedure WriteBinaryStream(const Section, Name: WideString;
      Stream: OleVariant); safecall;
    procedure WriteBool(const Section, Ident: WideString; Value: WordBool);
      safecall;
    procedure WriteDate(const Section, Ident: WideString; Value: Double);
      safecall;
    procedure WriteDateTime(const Section, Ident: WideString; Value: Double);
      safecall;
    procedure WriteFloat(const Section, Ident: WideString; Value: Double);
      safecall;
    procedure WriteInteger(const Section, Ident: WideString; Value: Integer);
      safecall;
    procedure WriteTime(const Section, Ident: WideString; Value: Double);
      safecall;
    function LoadScheme(const FileName: WideString): WideString; safecall;
    function LoadAlarmLog(const LogPath: WideString; FromDate,
      ToDate: Double): WideString; safecall;
    function LoadChangeLog(const LogPath: WideString; FromDate,
      ToDate: Double): WideString; safecall;
    function LoadSwitchLog(const LogPath: WideString; FromDate,
      ToDate: Double): WideString; safecall;
    function LoadSystemLog(const LogPath: WideString; FromDate,
      ToDate: Double): WideString; safecall;
    function Now: Double; safecall;
  public
    { Public declarations }
  end;

  TCashAlarmLogItem = record
    SnapTime: TDateTime;
    Station: Byte;
    Position,Parameter,Value,SetPoint: string[16];
    Mess,Descriptor: string[48];
  end;

  TCashSwitchLogItem = record
    SnapTime: TDateTime;
    Station: Byte;
    Position,Parameter,OldValue,NewValue: string[16];
    Descriptor: string[48];
  end;

  TCashChangeLogItem = record
    SnapTime: TDateTime;
    Station: Byte;
    Position,Parameter,Autor: string[16];
    OldValue,NewValue: string[20];
    Descriptor: string[48];
  end;

  TCashSystemLogItem = record
    SnapTime: TDateTime;
    Station: Byte;
    Position: string[16];
    Descriptor: string[96];
  end;

implementation

uses RmxBaseSvrUnit, IniFiles, Variants, CRCCalcUnit, ZLib, Math, DateUtils;

{$R *.DFM}

class procedure TRmxBaseData.UpdateRegistry(Register: Boolean; const ClassID, ProgID: string);
begin
  if Register then
  begin
    inherited UpdateRegistry(Register, ClassID, ProgID);
    EnableSocketTransport(ClassID);
    EnableWebTransport(ClassID);
  end else
  begin
    DisableSocketTransport(ClassID);
    DisableWebTransport(ClassID);
    inherited UpdateRegistry(Register, ClassID, ProgID);
  end;
end;

procedure TRmxBaseData.DeleteKey(const Section, Ident: WideString);
begin
  SafeSection.Enter;
  try
    Base.DeleteKey(Section,Ident);
  finally
    SafeSection.Leave;
  end;
end;

procedure TRmxBaseData.EraseSection(const Section: WideString);
begin
  SafeSection.Enter;
  try
    Base.EraseSection(Section);
  finally
    SafeSection.Leave;
  end;
end;

function TRmxBaseData.GetStrings: WideString;
var List: TStringList;
begin
  List:=TStringList.Create;
  try
    SafeSection.Enter;
    try
      Base.GetStrings(List);
      Result:=List.CommaText;
    finally
      SafeSection.Leave;
    end;
  finally
    List.Free;
  end;
end;

function TRmxBaseData.ReadSection(const Section: WideString): WideString;
var Strings: TStringList;
begin
  Strings:=TStringList.Create;
  try
    SafeSection.Enter;
    try
      Base.ReadSection(Section,Strings);
      Result:=Strings.CommaText;
    finally
      SafeSection.Leave;
    end;
  finally
    Strings.Free;
  end;
end;

function TRmxBaseData.ReadSections: WideString;
var Strings: TStringList;
begin
  Strings:=TStringList.Create;
  try
    SafeSection.Enter;
    try
      Base.ReadSections(Strings);
      Result:=Strings.CommaText;
    finally
      SafeSection.Leave;
    end;
  finally
    Strings.Free;
  end;
end;

function TRmxBaseData.ReadSectionValues(
  const Section: WideString): WideString;
var Strings: TStringList;
begin
  Strings:=TStringList.Create;
  try
    SafeSection.Enter;
    try
      Base.ReadSectionValues(Section,Strings);
      Result:=Strings.CommaText;
    finally
      SafeSection.Leave;
    end;
  finally
    Strings.Free;
  end;
end;

function TRmxBaseData.ReadString(const Section, Ident,
  Default: WideString): WideString;
begin
  SafeSection.Enter;
  try
    Result:=Base.ReadString(Section,Ident,Default);
  finally
    SafeSection.Leave;
  end;
end;

procedure TRmxBaseData.SetStrings(const List: WideString);
var Strings: TStringList;
begin
  Strings:=TStringList.Create;
  try
    Strings.CommaText:=List;
    SafeSection.Enter;
    try
      Base.SetStrings(Strings);
    finally
      SafeSection.Leave;
    end;
  finally
    Strings.Free;
  end;
end;

procedure TRmxBaseData.WriteString(const Section, Ident,
  Value: WideString);
begin
  SafeSection.Enter;
  try
    Base.WriteString(Section,Ident,Value);
  finally
    SafeSection.Leave;
  end;
end;

function TRmxBaseData.ReadBinaryStream(const Section,
  Name: WideString): OleVariant;
var Len: Int64;
    P: Pointer;
    Value: TMemoryStream;
begin
  SafeSection.Enter;
  try
    Value:=TMemoryStream.Create;
    try
      Base.ReadBinaryStream(Section,Name,Value);
      Value.Position:=0;
      Len:=Value.Size;
      Result:=VarArrayCreate([0,Len-1],varByte);
      P:=VarArrayLock(Result);
      try
        Value.ReadBuffer(P^,Len);
      finally
        VarArrayUnlock(Result);
      end;
    finally
      Value.Free;
    end;
  finally
    SafeSection.Leave;
  end;
end;

function TRmxBaseData.ReadBool(const Section, Ident: WideString;
  Default: WordBool): WordBool;
begin
  SafeSection.Enter;
  try
    Result:=Base.ReadBool(Section,Ident,Default);
  finally
    SafeSection.Leave;
  end;
end;

function TRmxBaseData.ReadDate(const Section, Ident: WideString;
  Default: Double): Double;
begin
  SafeSection.Enter;
  try
    Result:=Base.ReadDate(Section,Ident,Default);
  finally
    SafeSection.Leave;
  end;
end;

function TRmxBaseData.ReadDateTime(const Section, Ident: WideString;
  Default: Double): Double;
begin
  SafeSection.Enter;
  try
    Result:=Base.ReadDateTime(Section,Ident,Default);
  finally
    SafeSection.Leave;
  end;
end;

function TRmxBaseData.ReadFloat(const Section, Ident: WideString;
  Default: Double): Double;
begin
  SafeSection.Enter;
  try
    Result:=Base.ReadFloat(Section,Ident,Default);
  finally
    SafeSection.Leave;
  end;
end;

function TRmxBaseData.ReadInteger(const Section, Ident: WideString;
  Default: Integer): Integer;
begin
  SafeSection.Enter;
  try
    Result:=Base.ReadInteger(Section,Ident,Default);
  finally
    SafeSection.Leave;
  end;
end;

function TRmxBaseData.ReadTime(const Section, Ident: WideString;
  Default: Double): Double;
begin
  SafeSection.Enter;
  try
    Result:=Base.ReadTime(Section,Ident,Default);
  finally
    SafeSection.Leave;
  end;
end;

function TRmxBaseData.SectionExists(const Section: WideString): WordBool;
begin
  SafeSection.Enter;
  try
    Result:=Base.SectionExists(Section);
  finally
    SafeSection.Leave;
  end;
end;

function TRmxBaseData.ValueExists(const Section,
  Ident: WideString): WordBool;
begin
  SafeSection.Enter;
  try
    Result:=Base.ValueExists(Section,Ident);
  finally
    SafeSection.Leave;
  end;
end;

procedure TRmxBaseData.WriteBinaryStream(const Section, Name: WideString;
  Stream: OleVariant);
var Value: TMemoryStream;
    Len: Int64;
    P: Pointer;
begin
  SafeSection.Enter;
  try
    Value:=TMemoryStream.Create;
    try
      SafeSection.Enter;
      try
        Len:=VarArrayHighBound(Stream,1)-VarArrayLowBound(Stream,1)+1;
        P:=VarArrayLock(Stream);
        try
          Value.WriteBuffer(P^,Len);
        finally
          VarArrayUnlock(Stream);
        end;
        Value.Position:=0;
        Base.WriteBinaryStream(Section,Name,Value);
      finally
        SafeSection.Leave;
      end;
    finally
      Value.Free;
    end;
  finally
    SafeSection.Leave;
  end;
end;

procedure TRmxBaseData.WriteBool(const Section, Ident: WideString;
  Value: WordBool);
begin
  SafeSection.Enter;
  try
    Base.WriteBool(Section,Ident,Value);
  finally
    SafeSection.Leave;
  end;
end;

procedure TRmxBaseData.WriteDate(const Section, Ident: WideString;
  Value: Double);
begin
  SafeSection.Enter;
  try
    Base.WriteDate(Section,Ident,Value);
  finally
    SafeSection.Leave;
  end;
end;

procedure TRmxBaseData.WriteDateTime(const Section, Ident: WideString;
  Value: Double);
begin
  SafeSection.Enter;
  try
    Base.WriteDateTime(Section,Ident,Value);
  finally
    SafeSection.Leave;
  end;
end;

procedure TRmxBaseData.WriteFloat(const Section, Ident: WideString;
  Value: Double);
begin
  SafeSection.Enter;
  try
    Base.WriteFloat(Section,Ident,Value);
  finally
    SafeSection.Leave;
  end;
end;

procedure TRmxBaseData.WriteInteger(const Section, Ident: WideString;
  Value: Integer);
begin
  SafeSection.Enter;
  try
    Base.WriteInteger(Section,Ident,Value);
  finally
    SafeSection.Leave;
  end;
end;

procedure TRmxBaseData.WriteTime(const Section, Ident: WideString;
  Value: Double);
begin
  SafeSection.Enter;
  try
    Base.WriteTime(Section,Ident,Value);
  finally
    SafeSection.Leave;
  end;
end;

function TryOpenToReadFile(FileName: string): TFileStream;
var ek: integer;
begin
  Result:=nil;
  ek:=10;
  repeat
    try
      if FileExists(FileName) then
        Result:=TFileStream.Create(FileName,fmOpenRead or fmShareDenyWrite);
      Break;
    except
      Dec(ek);
      Sleep(500);
    end;
  until ek < 0;
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

procedure DecompressStream(aSource,aTarget: TStream);
var decompStream: TDecompressionStream;
    nRead: Integer;
    Buffer: array[0..4095] of Byte;
begin
  decompStream:=TDecompressionStream.Create(aSource);
  try
    repeat
      nRead:=decompStream.Read(Buffer,4096);
      aTarget.Write(Buffer,nRead);
    until nRead = 0;
  finally
    decompStream.Free;
  end;
end;

function LoadCRCStream(FileName: string; Stream: TMemoryStream;
                       var ErrorMess: string): boolean;
var M: TMemoryStream; F: TFileStream; CRC32,EXTCRC: Cardinal; A: array of Byte;
begin
  Result:=False;
  if FileExists(FileName) then
  begin
    M:=TMemoryStream.Create;
    try
      F:=TryOpenToReadFile(FileName);
      if not Assigned(F) then
      begin
        ErrorMess:='Файл "'+ExtractFileName(FileName)+
                   '" занят другим процессом.';
        Exit;
      end;
      try
        F.ReadBuffer(EXTCRC,SizeOf(EXTCRC));
        SetLength(A,F.Size-F.Position);
        F.ReadBuffer(A[0],Length(A));
        M.WriteBuffer(A[0],Length(A));
        M.Position:=0;
      finally
        F.Free;
      end;
      CRC32:=0;
      CalcCRC32(M.Memory,M.Size,CRC32);
      if CRC32 = EXTCRC then
      begin
        Stream.Clear;
        DecompressStream(M,Stream);
        Stream.Position:=0;
        ErrorMess:='';
        Result:=True;
      end
      else
        ErrorMess:='Файл "'+ExtractFileName(FileName)+'" с ошибкой (CRC).';
    finally
      M.Free;
    end;
  end
  else
    ErrorMess:='Файл "'+ExtractFileName(FileName)+'" не найден.';
end;

function LoadStream(FileName: string; Stream: TMemoryStream;
                    var ErrorMess: string): boolean;
var F: TFileStream;
begin
  Result:=False;
  if FileExists(FileName) then
  begin
    F:=TryOpenToReadFile(FileName);
    if not Assigned(F) then
    begin
      ErrorMess:='Файл "'+ExtractFileName(FileName)+
                 '" занят другим процессом.';
      Exit;
    end;
    try
      Stream.Clear;
      Stream.LoadFromStream(F);
      Stream.Position:=0;
      ErrorMess:='';
      Result:=True;
    finally
      F.Free;
    end;
  end
  else
    ErrorMess:='Файл "'+ExtractFileName(FileName)+'" не найден.';
end;

function HexToStream(const Source: string; Value: TStream): Integer;
var
  Text: string;
  Stream: TMemoryStream;
  Pos: Integer;
begin
  Text := Source;
  if Text <> '' then
  begin
    if Value is TMemoryStream then
      Stream := TMemoryStream(Value)
    else
      Stream := TMemoryStream.Create;
    try
      Pos := Stream.Position;
      Stream.SetSize(Stream.Size + Length(Text) div 2);
      HexToBin(PChar(Text), PChar(Integer(Stream.Memory) + Stream.Position),
               Length(Text) div 2);
      Stream.Position := Pos;
      if Value <> Stream then
        Value.CopyFrom(Stream, Length(Text) div 2);
      Result := Stream.Size - Pos;
    finally
      if Value <> Stream then
        Stream.Free;
    end;
  end
  else
    Result := 0;
end;

function StreamToHex(Value: TStream): string;
var
  Text: string;
  Stream: TMemoryStream;
begin
  SetLength(Text, (Value.Size - Value.Position) * 2);
  if Length(Text) > 0 then
  begin
    if Value is TMemoryStream then
      Stream := TMemoryStream(Value)
    else
      Stream := TMemoryStream.Create;
    try
      if Stream <> Value then
      begin
        Stream.CopyFrom(Value, Value.Size - Value.Position);
        Stream.Position := 0;
      end;
      BinToHex(PChar(Integer(Stream.Memory) + Stream.Position), PChar(Text),
        Stream.Size - Stream.Position);
    finally
      if Value <> Stream then
        Stream.Free;
    end;
    Result := Text;
  end
  else
    Result := '';
end;

function TRmxBaseData.LoadScheme(const FileName: WideString): WideString;
var M: TMemoryStream;
    List: TStringList;
    Err: string;
begin
  M:=TMemoryStream.Create;
//  C:=TMemoryStream.Create;
  List:=TStringList.Create;
  try
    SafeSection.Enter;
    try
      if LoadStream(FileName,M,Err) then
      begin
//        CompressStream(M,C);
//        C.Position:=0;
//        Result:=StreamToHex(C)
        List.LoadFromStream(M);
        Result:=List.CommaText;
      end
      else
        raise Exception.Create(Err);
    finally
      SafeSection.Leave;
    end;
  finally
//    C.Free;
    M.Free;
    List.Free;
  end;
end;

procedure TRmxBaseData.RemoteDataModuleCreate(Sender: TObject);
begin
  SafeSection.Enter;
  try
    ClientsCount:=ClientsCount+1;
  finally
    SafeSection.Leave;
  end;
end;

procedure TRmxBaseData.RemoteDataModuleDestroy(Sender: TObject);
begin
  SafeSection.Enter;
  try
    ClientsCount:=ClientsCount-1;
  finally
    SafeSection.Leave;
  end;
end;

function TRmxBaseData.LoadAlarmLog(const LogPath: WideString; FromDate,
  ToDate: Double): WideString;
var DS,DE: TDateTime;
    hh,nn,ss,zz: word;
    ErrFlag: boolean;
    DirName,FileName: string;
    F: TFileStream;
    AlarmItem: TCashAlarmLogItem;
    List,SubList: TStringList;
begin
  List:=TStringList.Create;
  SubList:=TStringList.Create;
  SafeSection.Enter;
  try
    DecodeTime(FromDate,hh,nn,ss,zz);
    DS:=Int(FromDate)+EncodeTime(hh,0,0,0);
    DecodeTime(ToDate,hh,nn,ss,zz);
    DE:=Int(ToDate)+EncodeTime(hh,59,59,999);
    ErrFlag:=False;
    while DS < DE do
    begin
      DirName:=LogPath+FormatDateTime('\yymmdd\hh',DS);
      FileName:=IncludeTrailingPathDelimiter(DirName)+'ALARMS.LOG';
      if FileExists(FileName) then
      begin
        F:=TryOpenToReadFile(FileName);
        if not Assigned(F) then // Файл занят другим процессом.
          Exit;                 // Таблица не загружена!
        F.Seek(0,soFromBeginning);
        try
          while F.Position < F.Size do
          begin
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
              if InRange(AlarmItem.SnapTime,FromDate,ToDate) then
              begin
                SubList.Clear;
                SubList.Values['SnapTime']:=
                    FormatDateTime('dd.mm.yy hh:nn:ss.zzz',AlarmItem.SnapTime);
                SubList.Values['Station']:=IntToStr(AlarmItem.Station);
                SubList.Values['Position']:=AlarmItem.Position;
                SubList.Values['Parameter']:=AlarmItem.Parameter;
                SubList.Values['Value']:=AlarmItem.Value;
                SubList.Values['SetPoint']:=AlarmItem.SetPoint;
                SubList.Values['Message']:=AlarmItem.Mess;
                SubList.Values['Descriptor']:=AlarmItem.Descriptor;
                List.Append(SubList.CommaText);
              end;
            except
              on E: Exception do
              begin
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
    Result:=List.CommaText;
  finally
    SafeSection.Leave;
    SubList.Free;
    List.Free;
  end;
end;

function TRmxBaseData.LoadChangeLog(const LogPath: WideString; FromDate,
  ToDate: Double): WideString;
var DS,DE: TDateTime;
    hh,nn,ss,zz: word;
    ErrFlag: boolean;
    DirName,FileName: string;
    F: TFileStream;
    ChangeItem: TCashChangeLogItem;
    List,SubList: TStringList;
begin
  List:=TStringList.Create;
  SubList:=TStringList.Create;
  SafeSection.Enter;
  try
    DecodeTime(FromDate,hh,nn,ss,zz);
    DS:=Int(FromDate)+EncodeTime(hh,0,0,0);
    DecodeTime(ToDate,hh,nn,ss,zz);
    DE:=Int(ToDate)+EncodeTime(hh,59,59,999);
    ErrFlag:=False;
    while DS < DE do
    begin
      DirName:=LogPath+FormatDateTime('\yymmdd\hh',DS);
      FileName:=IncludeTrailingPathDelimiter(DirName)+'CHANGES.LOG';
      if FileExists(FileName) then
      begin
        F:=TryOpenToReadFile(FileName);
        if not Assigned(F) then // Файл занят другим процессом.
          Exit;                 // Таблица не загружена!
        F.Seek(0,soFromBeginning);
        try
          while F.Position < F.Size do
          begin
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
              if InRange(ChangeItem.SnapTime,FromDate,ToDate) then
              begin
                SubList.Clear;
                SubList.Values['SnapTime']:=
                    FormatDateTime('dd.mm.yy hh:nn:ss.zzz',ChangeItem.SnapTime);
                SubList.Values['Station']:=IntToStr(ChangeItem.Station);
                SubList.Values['Position']:=ChangeItem.Position;
                SubList.Values['Parameter']:=ChangeItem.Parameter;
                SubList.Values['OldValue']:=ChangeItem.OldValue;
                SubList.Values['NewValue']:=ChangeItem.NewValue;
                SubList.Values['Autor']:=ChangeItem.Autor;
                SubList.Values['Descriptor']:=ChangeItem.Descriptor;
                List.Append(SubList.CommaText);
              end;
            except
              on E: Exception do
              begin
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
    Result:=List.CommaText;
  finally
    SafeSection.Leave;
    SubList.Free;
    List.Free;
  end;
end;

function TRmxBaseData.LoadSwitchLog(const LogPath: WideString; FromDate,
  ToDate: Double): WideString;
var DS,DE: TDateTime;
    hh,nn,ss,zz: word;
    ErrFlag: boolean;
    DirName,FileName: string;
    F: TFileStream;
    SwitchItem: TCashSwitchLogItem;
    List,SubList: TStringList;
begin
  List:=TStringList.Create;
  SubList:=TStringList.Create;
  SafeSection.Enter;
  try
    DecodeTime(FromDate,hh,nn,ss,zz);
    DS:=Int(FromDate)+EncodeTime(hh,0,0,0);
    DecodeTime(ToDate,hh,nn,ss,zz);
    DE:=Int(ToDate)+EncodeTime(hh,59,59,999);
    ErrFlag:=False;
    while DS < DE do
    begin
      DirName:=LogPath+FormatDateTime('\yymmdd\hh',DS);
      FileName:=IncludeTrailingPathDelimiter(DirName)+'SWITCHS.LOG';
      if FileExists(FileName) then
      begin
        F:=TryOpenToReadFile(FileName);
        if not Assigned(F) then // Файл занят другим процессом.
          Exit;                 // Таблица не загружена!
        F.Seek(0,soFromBeginning);
        try
          while F.Position < F.Size do
          begin
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
              if InRange(SwitchItem.SnapTime,FromDate,ToDate) then
              begin
                SubList.Clear;
                SubList.Values['SnapTime']:=
                    FormatDateTime('dd.mm.yy hh:nn:ss.zzz',SwitchItem.SnapTime);
                SubList.Values['Station']:=IntToStr(SwitchItem.Station);
                SubList.Values['Position']:=SwitchItem.Position;
                SubList.Values['Parameter']:=SwitchItem.Parameter;
                SubList.Values['OldValue']:=SwitchItem.OldValue;
                SubList.Values['NewValue']:=SwitchItem.NewValue;
                SubList.Values['Descriptor']:=SwitchItem.Descriptor;
                List.Append(SubList.CommaText);
              end;
            except
              on E: Exception do
              begin
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
    Result:=List.CommaText;
  finally
    SafeSection.Leave;
    SubList.Free;
    List.Free;
  end;
end;

function TRmxBaseData.LoadSystemLog(const LogPath: WideString; FromDate,
  ToDate: Double): WideString;
var DS,DE: TDateTime;
    hh,nn,ss,zz: word;
    ErrFlag: boolean;
    DirName,FileName: string;
    F: TFileStream;
    SystemItem: TCashSystemLogItem;
    List,SubList: TStringList;
begin
  List:=TStringList.Create;
  SubList:=TStringList.Create;
  SafeSection.Enter;
  try
    DecodeTime(FromDate,hh,nn,ss,zz);
    DS:=Int(FromDate)+EncodeTime(hh,0,0,0);
    DecodeTime(ToDate,hh,nn,ss,zz);
    DE:=Int(ToDate)+EncodeTime(hh,59,59,999);
    ErrFlag:=False;
    while DS < DE do
    begin
      DirName:=LogPath+FormatDateTime('\yymmdd\hh',DS);
      FileName:=IncludeTrailingPathDelimiter(DirName)+'SYSMESS.LOG';
      if FileExists(FileName) then
      begin
        F:=TryOpenToReadFile(FileName);
        if not Assigned(F) then // Файл занят другим процессом.
          Exit;                 // Таблица не загружена!
        F.Seek(0,soFromBeginning);
        try
          while F.Position < F.Size do
          begin
            try
              try
                F.ReadBuffer(SystemItem.SnapTime,SizeOf(SystemItem.SnapTime));
                F.ReadBuffer(SystemItem.Station,SizeOf(SystemItem.Station));
                F.ReadBuffer(SystemItem.Position,SizeOf(SystemItem.Position));
                F.ReadBuffer(SystemItem.Descriptor,SizeOf(SystemItem.Descriptor));
              except
                Break;
              end;
              if InRange(SystemItem.SnapTime,FromDate,ToDate) then
              begin
                SubList.Clear;
                SubList.Values['SnapTime']:=
                    FormatDateTime('dd.mm.yy hh:nn:ss.zzz',SystemItem.SnapTime);
                SubList.Values['Station']:=IntToStr(SystemItem.Station);
                SubList.Values['Position']:=SystemItem.Position;
                SubList.Values['Descriptor']:=SystemItem.Descriptor;
                List.Append(SubList.CommaText);
              end;
            except
              on E: Exception do
              begin
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
    Result:=List.CommaText;
  finally
    SafeSection.Leave;
    SubList.Free;
    List.Free;
  end;
end;

function TRmxBaseData.Now: Double;
begin
  SafeSection.Enter;
  try
    Result:=ServerTime;
  finally
    SafeSection.Leave;
  end;
end;

initialization
  TComponentFactory.Create(ComServer, TRmxBaseData,
    Class_RmxBaseData, ciMultiInstance, tmApartment);
end.
