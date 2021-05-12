unit RmxConnection;

interface

uses
  Windows, SysUtils, Classes, Variants, Controls, DB, DBClient, MConnect,
  SConnect, IniFiles, MidasLib;

type
  TNotifyQuestion = procedure (Sender: TObject;
                               var KeepTrying: boolean) of object;
  TKindConnection = (kcDCOM,kcSocket,kcWeb);
  TRmxConnection = class(TComponent)
  private
    FConnection: TDispatchConnection;
    FRemoted: TKindConnection;
//---------------------------------------
    FOnEndOperation: TNotifyEvent;
    FOnBeginOperation: TNotifyEvent;
    FOnRetryConnect: TNotifyQuestion;
    function GetAppServerr: Variant;
    function GetConnected: boolean;
    function GetPassword: string;
    function GetServerGUID: string;
    function GetServerName: string;
    function GetURL: string;
    function GetUserName: string;
    procedure SetConnected(const Value: boolean);
    procedure SetPassword(const Value: string);
    procedure SetServerGUID(const Value: string);
    procedure SetServerName(const Value: string);
    procedure SetURL(const Value: string);
    procedure SetUserName(const Value: string);
    function GetPort: integer;
    procedure SetPort(const Value: integer);
    function GetAddress: string;
    procedure SetAddress(const Value: string);
  public
    constructor Create(AOwner: TComponent;
                       Remoted: TKindConnection = kcDCOM); reintroduce;
    procedure Open;
    procedure Close;
//------------------------------------------------------
    procedure DeleteKey(const Section,Ident: string);
    procedure EraseSection(const Section: string);
    procedure GetStrings(List: TStrings);
    procedure ReadSection(const Section: string; Strings: TStrings);
    procedure ReadSections(Strings: TStrings);
    procedure ReadSectionValues(const Section: string; Strings: TStrings);
    function ReadString(const Section, Ident, Default: string): string;
    procedure SetStrings(List: TStrings);
    procedure WriteString(const Section, Ident, Value: string);
    function ReadBinaryStream(const Section, Name: string; Value: TStream): Int64;
    function ReadBool(const Section, Ident: string;
                      const Default: boolean): boolean;
    function ReadDate(const Section, Ident: string;
                      const Default: TDate): TDate;
    function ReadDateTime(const Section, Ident: string;
                          const Default: TDateTime): TDateTime;
    function ReadFloat(const Section, Ident: string;
                       const Default: Double): Double;
    function ReadInteger(const Section, Ident: string;
                         const Default: integer): integer;
    function ReadTime(const Section, Ident: string;
                      const Default: TTime): TTime;
    function SectionExists(const Section: string): boolean;
    function ValueExists(const Section, Ident: string): boolean;
    procedure WriteBinaryStream(const Section, Name: string; Value: TStream);
    procedure WriteBool(const Section, Ident: string; Value: boolean);
    procedure WriteDate(const Section, Ident: string; Value: TDate);
    procedure WriteDateTime(const Section, Ident: string; Value: TDateTime);
    procedure WriteFloat(const Section, Ident: string; Value: Double);
    procedure WriteInteger(const Section, Ident: string; Value: integer);
    procedure WriteTime(const Section, Ident: string; Value: TTime);
//-----------------------------------------------
    procedure ReadScheme(FileName: string; Buff: TMemIniFile);
    procedure LoadAlarmLog(LogsPath: string; D1,D2: TDateTime; List: TStringList);
    procedure LoadSwitchLog(LogsPath: string; D1,D2: TDateTime; List: TStringList);
    procedure LoadChangeLog(LogsPath: string; D1,D2: TDateTime; List: TStringList);
    procedure LoadSystemLog(LogsPath: string; D1,D2: TDateTime; List: TStringList);
  published
    property OnBeginOperation: TNotifyEvent read FOnBeginOperation
                                            write FOnBeginOperation;
    property OnEndOperation: TNotifyEvent read FOnEndOperation
                                          write FOnEndOperation;
    property OnRetryConnect: TNotifyQuestion read FOnRetryConnect
                                             write FOnRetryConnect;
    property UserName: string read GetUserName write SetUserName;
    property Password: string read GetPassword write SetPassword;
    property Connected: boolean read GetConnected write SetConnected;
    property AppServer: Variant read GetAppServerr;
    property URL: string read GetURL write SetURL;
    property Address: string read GetAddress write SetAddress;
    property Port: integer read GetPort write SetPort;
    property ServerName: string read GetServerName write SetServerName;
    property ServerGUID: string read GetServerGUID write SetServerGUID;
  end;

  ELoginFailed = class(Exception)
  end;

  ELoginCanceled = class(Exception)
  end;

procedure Register;

implementation

uses ZLib;

procedure Register;
begin
  RegisterComponents('Samples', [TRmxConnection]);
end;

{ TRmxConnection }

procedure TRmxConnection.Close;
begin
  Connected:=False;
end;

constructor TRmxConnection.Create(AOwner: TComponent; Remoted: TKindConnection);
begin
  inherited Create(AOwner);
  FRemoted:=Remoted;
  case FRemoted of
   kcSocket: FConnection:=TSocketConnection.Create(Self);
      kcWeb: FConnection:=TWebConnection.Create(Self);
  else
    FConnection:=TDCOMConnection.Create(Self);
  end;
  Address:='127.0.0.1';
  URL:='http://localhost/scripts/httpsrvr.dll';
end;

procedure TRmxConnection.DeleteKey(const Section, Ident: string);
begin
  if Assigned(FOnBeginOperation) then FOnBeginOperation(Self);
  try
    if Connected then
      AppServer.DeleteKey(Section, Ident);
  finally
    if Assigned(FOnEndOperation) then FOnEndOperation(Self);
  end;
end;

procedure TRmxConnection.EraseSection(const Section: string);
begin
  if Assigned(FOnBeginOperation) then FOnBeginOperation(Self);
  try
    if Connected then
      AppServer.EraseSection(Section);
  finally
    if Assigned(FOnEndOperation) then FOnEndOperation(Self);
  end;
end;

function TRmxConnection.GetAppServerr: Variant;
begin
  Result:=FConnection.AppServer;
end;

function TRmxConnection.GetConnected: boolean;
begin
  Result:=FConnection.Connected;
end;

function TRmxConnection.GetPassword: string;
begin
  if FRemoted = kcWeb then
    Result:=TWebConnection(FConnection).Password
  else
    Result:='';
end;

function TRmxConnection.GetServerGUID: string;
begin
  Result:=FConnection.ServerGUID;
end;

function TRmxConnection.GetServerName: string;
begin
  Result:=FConnection.ServerName;
end;

procedure TRmxConnection.GetStrings(List: TStrings);
begin
  if Assigned(FOnBeginOperation) then FOnBeginOperation(Self);
  try
    if Connected then
      List.CommaText:=AppServer.GetStrings
    else
      List.CommaText:='';
  finally
    if Assigned(FOnEndOperation) then FOnEndOperation(Self);
  end;
end;

function TRmxConnection.GetURL: string;
begin
  if FRemoted = kcWeb then
    Result:=TWebConnection(FConnection).URL
  else
    Result:='';
end;

function TRmxConnection.GetAddress: string;
begin
  if FRemoted = kcSocket then
    Result:=TSocketConnection(FConnection).Address
  else
    Result:='127.0.0.1';
end;

function TRmxConnection.GetPort: integer;
begin
  if FRemoted = kcSocket then
    Result:=TSocketConnection(FConnection).Port
  else
    Result:=211;
end;

function TRmxConnection.GetUserName: string;
begin
  if FRemoted = kcWeb then
    Result:=TWebConnection(FConnection).UserName
  else
    Result:='';
end;

procedure TRmxConnection.Open;
begin
  Connected:=True;
end;

function TRmxConnection.ReadBinaryStream(const Section, Name: string;
  Value: TStream): Int64;
var V: OleVariant;
    Len: Int64;
    P: Pointer;
begin
  if Assigned(FOnBeginOperation) then FOnBeginOperation(Self);
  try
    if Connected then
    begin
      V:=AppServer.ReadBinaryStream(Section,Name);
      Len:=VarArrayHighBound(V,1)-VarArrayLowBound(V,1)+1;
      P:=VarArrayLock(V);
      try
        Value.WriteBuffer(P^,Len);
        Result:=Len;
      finally
        VarArrayUnlock(V);
      end;
    end
    else
      Result:=0;
  finally
    if Assigned(FOnEndOperation) then FOnEndOperation(Self);
  end;
end;

function TRmxConnection.ReadBool(const Section, Ident: string;
  const Default: boolean): boolean;
begin
  if Assigned(FOnBeginOperation) then FOnBeginOperation(Self);
  try
    if Connected then
      Result:=AppServer.ReadBool(Section,Ident,Default)
    else
      Result:=Default;
  finally
    if Assigned(FOnEndOperation) then FOnEndOperation(Self);
  end;
end;

function TRmxConnection.ReadDate(const Section, Ident: string;
  const Default: TDate): TDate;
begin
  if Assigned(FOnBeginOperation) then FOnBeginOperation(Self);
  try
    if Connected then
      Result:=AppServer.ReadDate(Section,Ident,Default)
    else
      Result:=Default;
  finally
    if Assigned(FOnEndOperation) then FOnEndOperation(Self);
  end;
end;

function TRmxConnection.ReadDateTime(const Section, Ident: string;
  const Default: TDateTime): TDateTime;
begin
  if Assigned(FOnBeginOperation) then FOnBeginOperation(Self);
  try
    if Connected then
      Result:=AppServer.ReadDateTime(Section,Ident,Default)
    else
      Result:=Default;
  finally
    if Assigned(FOnEndOperation) then FOnEndOperation(Self);
  end;
end;

function TRmxConnection.ReadFloat(const Section, Ident: string;
  const Default: Double): Double;
begin
  if Assigned(FOnBeginOperation) then FOnBeginOperation(Self);
  try
    if Connected then
      Result:=AppServer.ReadFloat(Section,Ident,Default)
    else
      Result:=Default;
  finally
    if Assigned(FOnEndOperation) then FOnEndOperation(Self);
  end;
end;

function TRmxConnection.ReadInteger(const Section, Ident: string;
  const Default: integer): integer;
begin
  if Assigned(FOnBeginOperation) then FOnBeginOperation(Self);
  try
    if Connected then
      Result:=AppServer.ReadInteger(Section,Ident,Default)
    else
      Result:=Default;
  finally
    if Assigned(FOnEndOperation) then FOnEndOperation(Self);
  end;
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

procedure TRmxConnection.LoadAlarmLog(LogsPath: string; D1, D2: TDateTime;
  List: TStringList);
begin
  if Assigned(FOnBeginOperation) then FOnBeginOperation(Self);
  try
    if Connected then
      List.CommaText:=AppServer.LoadAlarmLog(LogsPath,D1,D2)
    else
      raise Exception.Create('Нет соединения с сервером!');
  finally
    if Assigned(FOnEndOperation) then FOnEndOperation(Self);
  end;
end;

procedure TRmxConnection.ReadScheme(FileName: string; Buff: TMemIniFile);
var List: TStringList; M,C: TMemoryStream; S: string;
begin
  if Assigned(FOnBeginOperation) then FOnBeginOperation(Self);
  M:=TMemoryStream.Create;
  C:=TMemoryStream.Create;
  List:=TStringList.Create;
  try
    if Connected then
    begin
      S:=AppServer.ReadScheme(FileName);
      if HexToStream(S,C) > 0 then
      begin
        DecompressStream(C,M);
        M.Position:=0;
        List.LoadFromStream(M);
        Buff.SetStrings(List);
      end;
    end
    else
      raise Exception.Create('Нет соединения с сервером!');
  finally
    List.Free;
    C.Free;
    M.Free;
    if Assigned(FOnEndOperation) then FOnEndOperation(Self);
  end;
end;

procedure TRmxConnection.ReadSection(const Section: string;
  Strings: TStrings);
begin
  if Assigned(FOnBeginOperation) then FOnBeginOperation(Self);
  try
    if Connected then
      Strings.CommaText:=AppServer.ReadSection(Section)
    else
      Strings.CommaText:='';
  finally
    if Assigned(FOnEndOperation) then FOnEndOperation(Self);
  end;
end;

procedure TRmxConnection.ReadSections(Strings: TStrings);
begin
  if Assigned(FOnBeginOperation) then FOnBeginOperation(Self);
  try
    if Connected then
      Strings.CommaText:=AppServer.ReadSections
    else
      Strings.CommaText:='';
  finally
    if Assigned(FOnEndOperation) then FOnEndOperation(Self);
  end;
end;

procedure TRmxConnection.ReadSectionValues(const Section: string;
  Strings: TStrings);
begin
  if Assigned(FOnBeginOperation) then FOnBeginOperation(Self);
  try
    if Connected then
      Strings.CommaText:=AppServer.ReadSectionValues(Section)
    else
      Strings.CommaText:='';
  finally
    if Assigned(FOnEndOperation) then FOnEndOperation(Self);
  end;
end;

function TRmxConnection.ReadString(const Section, Ident,
  Default: string): string;
begin
  if Assigned(FOnBeginOperation) then FOnBeginOperation(Self);
  try
    if Connected then
      Result:=AppServer.ReadString(Section,Ident,Default)
    else
      Result:=Default;
  finally
    if Assigned(FOnEndOperation) then FOnEndOperation(Self);
  end;
end;

function TRmxConnection.ReadTime(const Section, Ident: string;
  const Default: TTime): TTime;
begin
  if Assigned(FOnBeginOperation) then FOnBeginOperation(Self);
  try
    if Connected then
      Result:=AppServer.ReadTime(Section,Ident,Default)
    else
      Result:=Default;
  finally
    if Assigned(FOnEndOperation) then FOnEndOperation(Self);
  end;
end;

function TRmxConnection.SectionExists(const Section: string): boolean;
begin
  if Assigned(FOnBeginOperation) then FOnBeginOperation(Self);
  try
    if Connected then
      Result:=AppServer.SectionExists(Section)
    else
      Result:=False;
  finally
    if Assigned(FOnEndOperation) then FOnEndOperation(Self);
  end;
end;

procedure TRmxConnection.SetConnected(const Value: boolean);
begin
  FConnection.Connected:=Value;
end;

procedure TRmxConnection.SetPassword(const Value: string);
begin
  if FRemoted = kcWeb then
    TWebConnection(FConnection).Password:=Value;
end;

procedure TRmxConnection.SetServerGUID(const Value: string);
begin
  FConnection.ServerGUID:=Value;
end;

procedure TRmxConnection.SetServerName(const Value: string);
begin
  FConnection.ServerName:=Value;
end;

procedure TRmxConnection.SetStrings(List: TStrings);
begin
  if Assigned(FOnBeginOperation) then FOnBeginOperation(Self);
  try
    if Connected then
      AppServer.SetStrings(List.CommaText);
  finally
    if Assigned(FOnEndOperation) then FOnEndOperation(Self);
  end;
end;

procedure TRmxConnection.SetURL(const Value: string);
begin
  if FRemoted = kcWeb then
    TWebConnection(FConnection).URL:=Value;
end;

procedure TRmxConnection.SetAddress(const Value: string);
begin
  if FRemoted = kcSocket then
    TSocketConnection(FConnection).Address:=Value;
end;

procedure TRmxConnection.SetUserName(const Value: string);
begin
  if FRemoted = kcWeb then
    TWebConnection(FConnection).UserName:=Value;
end;

procedure TRmxConnection.SetPort(const Value: integer);
begin
  if FRemoted = kcSocket then
    TSocketConnection(FConnection).Port:=Value;
end;

function TRmxConnection.ValueExists(const Section, Ident: string): boolean;
begin
  if Assigned(FOnBeginOperation) then FOnBeginOperation(Self);
  try
    if Connected then
      Result:=AppServer.ValueExists(Section,Ident)
    else
      Result:=False;
  finally
    if Assigned(FOnEndOperation) then FOnEndOperation(Self);
  end;
end;

procedure TRmxConnection.WriteBinaryStream(const Section, Name: string;
  Value: TStream);
var V: OleVariant;
    Len: Int64;
    P: Pointer;
    M: TMemoryStream;
begin
  if Assigned(FOnBeginOperation) then FOnBeginOperation(Self);
  try
    if Connected then
    begin
      Value.Position:=0;
      Len:=Value.Size;
      V:=VarArrayCreate([0,Len-1],varByte);
      M:=TMemoryStream.Create;
      try
        P:=VarArrayLock(V);
        try
          M.CopyFrom(Value,Len);
          MoveMemory(P,M.Memory,Len);
        finally
          VarArrayUnlock(V);
        end;
      finally    
        M.Free;
      end;
      AppServer.WriteBinaryStream(Section,Name,V);
    end;
  finally
    if Assigned(FOnEndOperation) then FOnEndOperation(Self);
  end;
end;

procedure TRmxConnection.WriteBool(const Section, Ident: string;
  Value: boolean);
begin
  if Assigned(FOnBeginOperation) then FOnBeginOperation(Self);
  try
    if Connected then
      AppServer.WriteBool(Section,Ident,Value);
  finally
    if Assigned(FOnEndOperation) then FOnEndOperation(Self);
  end;
end;

procedure TRmxConnection.WriteDate(const Section, Ident: string;
  Value: TDate);
begin
  if Assigned(FOnBeginOperation) then FOnBeginOperation(Self);
  try
    if Connected then
      AppServer.WriteDate(Section,Ident,Value);
  finally
    if Assigned(FOnEndOperation) then FOnEndOperation(Self);
  end;
end;

procedure TRmxConnection.WriteDateTime(const Section, Ident: string;
  Value: TDateTime);
begin
  if Assigned(FOnBeginOperation) then FOnBeginOperation(Self);
  try
    if Connected then
      AppServer.WriteDateTime(Section,Ident,Value);
  finally
    if Assigned(FOnEndOperation) then FOnEndOperation(Self);
  end;
end;

procedure TRmxConnection.WriteFloat(const Section, Ident: string;
  Value: Double);
begin
  if Assigned(FOnBeginOperation) then FOnBeginOperation(Self);
  try
    if Connected then
      AppServer.WriteFloat(Section,Ident,Value);
  finally
    if Assigned(FOnEndOperation) then FOnEndOperation(Self);
  end;
end;

procedure TRmxConnection.WriteInteger(const Section, Ident: string;
  Value: integer);
begin
  if Assigned(FOnBeginOperation) then FOnBeginOperation(Self);
  try
    if Connected then
      AppServer.WriteInteger(Section,Ident,Value);
  finally
    if Assigned(FOnEndOperation) then FOnEndOperation(Self);
  end;
end;

procedure TRmxConnection.WriteString(const Section, Ident, Value: string);
begin
  if Assigned(FOnBeginOperation) then FOnBeginOperation(Self);
  try
    if Connected then
      AppServer.WriteString(Section,Ident,Value);
  finally
    if Assigned(FOnEndOperation) then FOnEndOperation(Self);
  end;
end;

procedure TRmxConnection.WriteTime(const Section, Ident: string;
  Value: TTime);
begin
  if Assigned(FOnBeginOperation) then FOnBeginOperation(Self);
  try
    if Connected then
      AppServer.WriteTime(Section,Ident,Value);
  finally
    if Assigned(FOnEndOperation) then FOnEndOperation(Self);
  end;
end;

procedure TRmxConnection.LoadChangeLog(LogsPath: string; D1, D2: TDateTime;
  List: TStringList);
begin
  if Assigned(FOnBeginOperation) then FOnBeginOperation(Self);
  try
    if Connected then
      List.CommaText:=AppServer.LoadChangeLog(LogsPath,D1,D2)
    else
      raise Exception.Create('Нет соединения с сервером!');
  finally
    if Assigned(FOnEndOperation) then FOnEndOperation(Self);
  end;
end;

procedure TRmxConnection.LoadSwitchLog(LogsPath: string; D1, D2: TDateTime;
  List: TStringList);
begin
  if Assigned(FOnBeginOperation) then FOnBeginOperation(Self);
  try
    if Connected then
      List.CommaText:=AppServer.LoadSwitchLog(LogsPath,D1,D2)
    else
      raise Exception.Create('Нет соединения с сервером!');
  finally
    if Assigned(FOnEndOperation) then FOnEndOperation(Self);
  end;
end;

procedure TRmxConnection.LoadSystemLog(LogsPath: string; D1, D2: TDateTime;
  List: TStringList);
begin
  if Assigned(FOnBeginOperation) then FOnBeginOperation(Self);
  try
    if Connected then
      List.CommaText:=AppServer.LoadSystemLog(LogsPath,D1,D2)
    else
      raise Exception.Create('Нет соединения с сервером!');
  finally
    if Assigned(FOnEndOperation) then FOnEndOperation(Self);
  end;
end;

end.
