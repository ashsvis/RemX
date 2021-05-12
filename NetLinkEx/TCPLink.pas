unit TCPLink;

interface

uses
  Windows, Messages, SysUtils, Classes, Sockets;

type
  TNetBuff = array[0..511] of byte;

  TNotifyDataCollector = procedure (Sender: TObject;
                      const Request: TNetBuff; const RequestSize: integer;
                      var Answer: TNetBuff; var AnswerSize: integer) of object;
  TNotifyDataReceive = procedure (Sender: TObject;
                                  const Answer: TNetBuff;
                                  const AnswerSize: integer) of object;

  TTcpLink = class //(TComponent)
  private
    FServer: Boolean;
    FActive: Boolean;
    FOnOpen: TNotifyEvent;
    FOnClose: TNotifyEvent;
    TcpServer: TTcpServer;
    FBusy: boolean;
    FOnServerDataCollector: TNotifyDataCollector;
    FOnClientDataReceive: TNotifyDataReceive;
    FOnClientTimeOut: TNotifyEvent;
    procedure SetActive(const Value: Boolean);
    procedure SetServer(const Value: Boolean);
    procedure TcpServerAccept(Sender: TObject; ClientSocket: TCustomIpClient);
  protected
    procedure OpenNetLink; virtual;
    procedure CloseNetLink; virtual;
  public
    Host: TSocketHost;
    Port: TSocketPort;
    Channel: integer;
    TimeOut: integer;
    RepeatCount: integer;
    destructor Destroy; override;
    procedure Open;
    procedure Close;
    procedure SendToServer(Value: TStream);
    property Busy: boolean read FBusy;
  published
    property Active : Boolean read FActive write SetActive
                stored False default False;
    property Server : Boolean read FServer write SetServer
                stored False default False;
    property OnOpen: TNotifyEvent read FOnOpen write FOnOpen;
    property OnClose: TNotifyEvent read FOnClose write FOnClose;
    property OnServerDataCollector: TNotifyDataCollector
                 read FOnServerDataCollector write FOnServerDataCollector;
    property OnClientDataReceive: TNotifyDataReceive
                 read FOnClientDataReceive write FOnClientDataReceive;
    property OnClientTimeOut: TNotifyEvent
                 read FOnClientTimeOut write FOnClientTimeOut;
  end;

implementation

uses Math, DateUtils;

{ TClientDataRequestor }

type
  TClientDataRequestor = class(TThread)
  private
    FNetLink: TTcpLink;
    TcpClient: TTcpClient;
    TimeOut: Integer;
    RepeatCount: Integer;
    SendBuffSize: integer;
    SendBuff: TNetBuff;
    ReceiveBuffSize: integer;
    ReceiveBuff: TNetBuff;
    procedure UpdateOnData;
    procedure UpdateOnTimeOut;
  protected
    procedure Execute; override;
  public
    constructor Create(ANetLink: TTcpLink; Value: TStream;
                       const Host, Port: string;
                       ATimeOut, ARepeatCount : Integer);
    destructor Destroy; override;
  end;

  TClientDataCollector = class(TThread)
  private
    ReceiveBuff: TNetBuff;
    ReceiveBuffSize: integer;
    SendBuff: TNetBuff;
    SendBuffSize: integer;
    RemoteHost: string;
    RemoteHostName: string;
    FNetLink: TTcpLink;
    Finished: boolean;
  protected
    procedure Execute; override;
  public
    constructor Create;
    procedure CollectDataToAnswer;
  end;

{ TClientDataRequestor implementation }

constructor TClientDataRequestor.Create(ANetLink: TTcpLink; Value: TStream;
                                        const Host, Port: string;
                                        ATimeOut, ARepeatCount : Integer);
begin
  FNetLink := ANetLink;
  TcpClient := TTcpClient.Create(nil);
  TcpClient.RemoteHost := Host;
  TcpClient.RemotePort := Port;
  TcpClient.BlockMode := bmBlocking;
  TimeOut := ATimeOut;
  RepeatCount := ARepeatCount;
  SendBuffSize := Math.Min(Value.Size, SizeOf(SendBuff));
  Value.Position := 0;
  Value.ReadBuffer(SendBuff, SendBuffSize);
  FreeAndNil(Value);
  inherited Create(True);
  FreeOnTerminate := True;
  Resume;
end;

procedure TClientDataRequestor.Execute;
var len, count: integer;
    Buff: array[0..511] of byte;
    dt: TDateTime;
    good: Boolean;
begin
  try
    if TcpClient.Connect then
    begin
      count := 0;
      repeat
        TcpClient.SendBuf(SendBuff, SendBuffSize);
        Sleep(10);
        dt := Now + TimeOut * OneMillisecond;
        good := False;
        repeat
          len := TcpClient.PeekBuf(Buff,512);
          if (len > 0) and (len <= SizeOf(ReceiveBuff)) then
          begin
            TcpClient.ReceiveBuf(ReceiveBuff, len);
            ReceiveBuffSize := len;
            Synchronize(UpdateOnData);
            good := True;
            Break;
          end;
        until dt < Now;
        if good then Break;
        count := count + 1;
      until count > RepeatCount;
      if not good then
      begin
        ReceiveBuffSize := 0;
        Synchronize(UpdateOnTimeOut);
      end;
    end
    else
    begin
      ReceiveBuffSize := 0;
      Synchronize(UpdateOnTimeOut);
    end;
  finally
    TcpClient.Disconnect;
  end;
end;

procedure TClientDataRequestor.UpdateOnData;
begin
// Обработка клиентом полученных данных от сервера
  try
    if Assigned(FNetLink.OnClientDataReceive) then
      FNetLink.OnClientDataReceive(FNetLink, ReceiveBuff, ReceiveBuffSize);
  finally
    FNetLink.FBusy:=False;
  end;
end;

procedure TClientDataRequestor.UpdateOnTimeOut;
begin
// Обработка клиентом полученных данных от сервера
  try
    if Assigned(FNetLink.OnClientTimeOut) then
      FNetLink.OnClientTimeOut(FNetLink);
  finally
    FNetLink.FBusy:=False;
  end;
end;

destructor TClientDataRequestor.Destroy;
begin
  TcpClient.Free;
  inherited;
end;

{ TClientDataCollector implementation }

constructor TClientDataCollector.Create;
begin
  inherited Create(True);
  Finished := False;
end;

procedure TClientDataCollector.Execute;
begin
  Synchronize(CollectDataToAnswer);
end;

procedure TClientDataCollector.CollectDataToAnswer;
begin
// Сбор данных сервером для ответа клиенту
// Выполняется в главном потоке приложения
  SendBuffSize:=0;
  try
    if Assigned(FNetLink.OnServerDataCollector) then
      FNetLink.OnServerDataCollector(FNetLink, ReceiveBuff, ReceiveBuffSize,
                                     SendBuff, SendBuffSize);
  finally
    Finished:=True;
  end;
end;

{ TNetLink }

procedure TTcpLink.Close;
begin
  Active:=False;
end;

procedure TTcpLink.CloseNetLink;
begin
  if FServer then
  begin
    TcpServer.Close;
    Sleep(1000);
    TcpServer.Free;
  end;
  if Assigned(FOnClose) then FOnClose(Self);
end;

destructor TTcpLink.Destroy;
begin
  Close;
  inherited;
end;

procedure TTcpLink.Open;
begin
  Active:=True;
end;

procedure TTcpLink.OpenNetLink;
begin
  if FServer then
  begin
    TcpServer := TTcpServer.Create(nil);
    TcpServer.BlockMode := bmThreadBlocking;
    TcpServer.OnAccept := TcpServerAccept;
    TcpServer.LocalHost := Host;
    TcpServer.LocalPort := Port;
    TcpServer.Open;
  end;
  if Assigned(FOnOpen) then FOnOpen(Self);
end;

procedure TTcpLink.SendToServer(Value: TStream);
begin
  FBusy := True;
  TClientDataRequestor.Create(Self, Value, Host, Port, TimeOut, RepeatCount);
end;

procedure TTcpLink.SetActive(const Value: Boolean);
begin
  if FActive <> Value then
  begin
    FActive := Value;
    if FActive then
      OpenNetLink
    else
      CloseNetLink;
  end;
end;

procedure TTcpLink.SetServer(const Value: Boolean);
begin
  if FServer <> Value then
  begin
    if FActive then Close;
    FServer := Value;
    if FActive then Open;
  end;
end;

procedure TTcpLink.TcpServerAccept(Sender: TObject;
                                     ClientSocket: TCustomIpClient);
var Answer: TNetBuff; AnswerSize, len: integer;
begin
// Выполняется в отдельном потоке
  with TClientDataCollector.Create do
  try
    FNetLink := Self;
    RemoteHost := ClientSocket.RemoteHost;
    RemoteHostName := ClientSocket.LookupHostName(ClientSocket.RemoteHost);
    len := ClientSocket.PeekBuf(Answer,SizeOf(Answer));
    if (len > 0) and (len <= SizeOf(ReceiveBuff)) then
    begin
      ClientSocket.ReceiveBuf(ReceiveBuff, len);
      ReceiveBuffSize := len;
    end
    else
      ReceiveBuffSize := 0;
    Resume;
    WaitFor;
    Answer := SendBuff;
    AnswerSize := SendBuffSize;
  finally
    Free;
  end;
  ClientSocket.SendBuf(Answer, AnswerSize);
end;

end.
