unit RmxConnection;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, MConnect, SConnect, IniFiles, 
  ExtCtrls;

type
  TNotifyQuestion = procedure (Sender: TObject;
                               var KeepTrying: boolean) of object;
  TKindConnection = (kcDCOM,kcSocket,kcWeb);
  TRmxConnection = class(TComponent)
  private
    FConnection: TDispatchConnection;
    FUserName: string;
    FPassword: string;
    FAddress: string;
    FPort: integer;
    FURL: string;
    FCurrentLogsPath: string;
//---------------------------------------
    FOnEndOperation: TNotifyEvent;
    FOnBeginOperation: TNotifyEvent;
    FOnRetryConnect: TNotifyQuestion;
    FCurrentSchemsPath: string;
    function GetAppServerr: Variant;
    function GetConnected: boolean;
    function GetServerGUID: string;
    function GetServerName: string;
    procedure SetConnected(const Value: boolean);
    procedure SetPassword(const Value: string);
    procedure SetServerGUID(const Value: string);
    procedure SetServerName(const Value: string);
    procedure SetURL(const Value: string);
    procedure SetUserName(const Value: string);
    procedure SetPort(const Value: integer);
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
    function Now: TDateTime;
    procedure LoadScheme(FileName: string; Buff: TMemIniFile);
    procedure LoadAlarmLog(D1,D2: TDateTime; List: TStringList);
    procedure LoadSwitchLog(D1,D2: TDateTime; List: TStringList);
    procedure LoadChangeLog(D1,D2: TDateTime; List: TStringList);
    procedure LoadSystemLog(D1,D2: TDateTime; List: TStringList);
    procedure SaveConfigToFile(FileName: string);
    procedure LoadConfigFromFile(FileName: string);
    class function GetConnectType: TKindConnection;
    class procedure SetConnectTypeFromFile(const FileName: string);
    class procedure SetConnectType(const Value: TKindConnection);
    property ConnectType: TKindConnection read GetConnectType write SetConnectType;
    property CurrentLogsPath: string read FCurrentLogsPath write FCurrentLogsPath;
    property CurrentSchemsPath: string read FCurrentSchemsPath write FCurrentSchemsPath;
  published
    property OnBeginOperation: TNotifyEvent read FOnBeginOperation
                                            write FOnBeginOperation;
    property OnEndOperation: TNotifyEvent read FOnEndOperation
                                          write FOnEndOperation;
    property OnRetryConnect: TNotifyQuestion read FOnRetryConnect
                                             write FOnRetryConnect;
    property UserName: string read FUserName write SetUserName;
    property Password: string read FPassword write SetPassword;
    property Connected: boolean read GetConnected write SetConnected;
    property AppServer: Variant read GetAppServerr;
    property URL: string read FURL write SetURL;
    property Address: string read FAddress write SetAddress;
    property Port: integer read FPort write SetPort;
    property ServerName: string read GetServerName write SetServerName;
    property ServerGUID: string read GetServerGUID write SetServerGUID;
  end;

  ELoginFailed = class(Exception)
  end;

  ELoginCanceled = class(Exception)
  end;

  TTuneConnForm = class(TForm)
    btnConnect: TButton;
    btnOk: TButton;
    BtnCancel: TButton;
    rgTypeConn: TRadioGroup;
    leAddress: TLabeledEdit;
    leURL: TLabeledEdit;
    lePort: TLabeledEdit;
    lePath: TLabeledEdit;
    procedure rgTypeConnClick(Sender: TObject);
  private
  public
  end;

//function ConnectTypeToStr(Value: TKindConnection): string;
//function StrToConnectTypeDef(Value: string;
//                           Default: TKindConnection = kcDCOM): TKindConnection;

procedure Register;

implementation

uses ZLib;

{$R *.dfm}

var
  FRemoted: TKindConnection;

procedure Register;
begin
  RegisterComponents('Samples', [TRmxConnection]);
end;

function ConnectTypeToStr(Value: TKindConnection): string;
begin
  case Value of
    kcSocket: Result:='Socket Connection';
    kcWeb: Result:='Web Connection';
  else
    Result:='DCOM Connection';
  end;
end;

function StrToConnectTypeDef(Value: string;
                           Default: TKindConnection = kcDCOM): TKindConnection;
begin
  if Value = 'Socket Connection' then
    Result:=kcSocket
  else if Value = 'Web Connection' then
    Result:=kcWeb
  else if Value = 'DCOM Connection' then
    Result:=kcDCOM
  else
    Result:=Default;
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

procedure TRmxConnection.LoadAlarmLog(D1, D2: TDateTime; List: TStringList);
begin
  if Assigned(FOnBeginOperation) then FOnBeginOperation(Self);
  try
    if Connected then
      List.CommaText:=AppServer.LoadAlarmLog(CurrentLogsPath,D1,D2)
    else
      raise Exception.Create('Нет соединения с сервером!');
  finally
    if Assigned(FOnEndOperation) then FOnEndOperation(Self);
  end;
end;

procedure TRmxConnection.LoadScheme(FileName: string; Buff: TMemIniFile);
var List: TStringList; //M,C: TMemoryStream; S: string;
begin
  if Assigned(FOnBeginOperation) then FOnBeginOperation(Self);
//  M:=TMemoryStream.Create;
//  C:=TMemoryStream.Create;
  List:=TStringList.Create;
  try
    if Connected then
    begin
//      S:=AppServer.ReadScheme(FileName);
//      if HexToStream(S,C) > 0 then
//      begin
//        DecompressStream(C,M);
//        M.Position:=0;
//        List.LoadFromStream(M);
//        Buff.SetStrings(List);
//      end;
      List.CommaText:=AppServer.LoadScheme(FileName);
      Buff.SetStrings(List);
    end
    else
      raise Exception.Create('Нет соединения с сервером!');
  finally
    List.Free;
//    C.Free;
//    M.Free;
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
  FPassword:=Value;
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
  FURL:=Value;
  if FRemoted = kcWeb then
    TWebConnection(FConnection).URL:=Value;
end;

procedure TRmxConnection.SetAddress(const Value: string);
begin
  FAddress:=Value;
  if FRemoted = kcSocket then
    TSocketConnection(FConnection).Address:=Value;
end;

procedure TRmxConnection.SetUserName(const Value: string);
begin
  FUserName:=Value;
  if FRemoted = kcWeb then
    TWebConnection(FConnection).UserName:=Value;
end;

procedure TRmxConnection.SetPort(const Value: integer);
begin
  FPort:=Value;
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

procedure TRmxConnection.LoadChangeLog(D1, D2: TDateTime; List: TStringList);
begin
  if Assigned(FOnBeginOperation) then FOnBeginOperation(Self);
  try
    if Connected then
      List.CommaText:=AppServer.LoadChangeLog(CurrentLogsPath,D1,D2)
    else
      raise Exception.Create('Нет соединения с сервером!');
  finally
    if Assigned(FOnEndOperation) then FOnEndOperation(Self);
  end;
end;

procedure TRmxConnection.LoadSwitchLog(D1, D2: TDateTime; List: TStringList);
begin
  if Assigned(FOnBeginOperation) then FOnBeginOperation(Self);
  try
    if Connected then
      List.CommaText:=AppServer.LoadSwitchLog(CurrentLogsPath,D1,D2)
    else
      raise Exception.Create('Нет соединения с сервером!');
  finally
    if Assigned(FOnEndOperation) then FOnEndOperation(Self);
  end;
end;

procedure TRmxConnection.LoadSystemLog(D1, D2: TDateTime; List: TStringList);
begin
  if Assigned(FOnBeginOperation) then FOnBeginOperation(Self);
  try
    if Connected then
      List.CommaText:=AppServer.LoadSystemLog(CurrentLogsPath,D1,D2)
    else
      raise Exception.Create('Нет соединения с сервером!');
  finally
    if Assigned(FOnEndOperation) then FOnEndOperation(Self);
  end;
end;

procedure TTuneConnForm.rgTypeConnClick(Sender: TObject);
begin
  btnConnect.Enabled:=True;
  leAddress.Enabled:=(rgTypeConn.ItemIndex = 1);
  lePort.Enabled:=(rgTypeConn.ItemIndex = 1);
  leURL.Enabled:=(rgTypeConn.ItemIndex = 2);
end;

procedure TRmxConnection.SaveConfigToFile(FileName: string);
var Config: TIniFile;
begin
  Config:=TIniFile.Create(FileName);
  try
    Config.WriteString('Connection','ServerName',ServerName);
    Config.WriteString('Connection','ServerGUID',ServerGUID);
    Config.WriteString('Connection','Mode',ConnectTypeToStr(ConnectType));
    Config.WriteString('Connection','IP',FAddress);
    Config.WriteInteger('Connection','Port',FPort);
    Config.WriteString('Connection','URL',FURL);
    Config.WriteString('Connection','RootLogsPath',FCurrentLogsPath);
    Config.WriteString('Connection','RootSchemsPath',FCurrentSchemsPath);
  finally
    Config.Free;
  end;
end;

procedure TRmxConnection.LoadConfigFromFile(FileName: string);
var Config: TIniFile;
begin
  Config:=TIniFile.Create(FileName);
  try
    ServerName:=Config.ReadString('Connection','ServerName','RmxBaseSvr.RmxBaseData');
    ServerGUID:=Config.ReadString('Connection','ServerGUID',
                                  '{C5B2B937-E229-4CAA-83EB-D194AA3BF850}');
    CurrentLogsPath:=Config.ReadString('Connection','RootLogsPath','');
    CurrentSchemsPath:=Config.ReadString('Connection','RootSchemsPath','');
    Address:=Config.ReadString('Connection','IP','127.0.0.1');
    Port:=Config.ReadInteger('Connection','Port',211);
    URL:=Config.ReadString('Connection','URL','http://localhost/scripts/httpsrvr.dll');
  finally
    Config.Free;
  end;
end;

class function TRmxConnection.GetConnectType: TKindConnection;
begin
  Result:=FRemoted;
end;

class procedure TRmxConnection.SetConnectType(const Value: TKindConnection);
begin
  FRemoted:=Value;
end;

class procedure TRmxConnection.SetConnectTypeFromFile(const FileName: string);
var Config: TIniFile;
begin
  Config:=TIniFile.Create(FileName);
  try
    FRemoted:=StrToConnectTypeDef(Config.ReadString('Connection','Mode',''));
  finally
    Config.Free;
  end;
end;

function TRmxConnection.Now: TDateTime;
begin
  if Connected then
    Result:=AppServer.Now
  else
    Result:=Now;
end;

initialization
  FRemoted:=kcDCOM;

end.
