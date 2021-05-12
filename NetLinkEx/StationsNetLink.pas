unit StationsNetLink;

interface

uses
  Windows, Messages, SysUtils, Classes, Sockets;

type
  TNotifyDataCollector = procedure (Sender: TObject; const Request: string;
                                    var Answer: string) of object;
  TNotifyDataReceive = procedure (Sender: TObject; const Answer: string) of object;

  TStationsLink = class(TComponent)
  private
    FServer: Boolean;
    FActive: Boolean;
    FOnOpen: TNotifyEvent;
    FOnClose: TNotifyEvent;
    TcpServer: TTcpServer;
    FBusy: boolean;
    FOnServerDataCollector: TNotifyDataCollector;
    FOnClientDataReceive: TNotifyDataReceive;
    procedure SetActive(const Value: Boolean);
    procedure SetServer(const Value: Boolean);
    procedure TcpServerAccept(Sender: TObject; ClientSocket: TCustomIpClient);
  protected
    procedure OpenNetLink; virtual;
    procedure CloseNetLink; virtual;
  public
    Host: TSocketHost;
    Port: TSocketPort;
    destructor Destroy; override;
    procedure Open;
    procedure Close;
    procedure SendToServer(const What: string);
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
  end;

function CCS(s: string): Char;

implementation


// Подсчет контрольной суммы
function CCS(s: string): Char;
var i: Word; Sum: Integer;
begin
// Инициализация
  Sum:=0; i:=1;
// Все символы строки складываются в Sum,
  while i<=Length(s) do
  begin
    Sum:=Sum+Ord(s[i]);
    Inc(i);
  end;
// Посчет циклических переносов
  while Sum >= 256 do Sum:=Sum mod 256 + Sum div 256;
// Возврат Суммы как символа
  Result:=Chr($100-(Sum and $00FF));
end;

{ TClientDataRequestor }

type
  TClientDataStringRequestor = class(TThread)
  private
    FNetLink: TStationsLink;
    TcpClient: TTcpClient;
    SendBuff: string;
    ReceiveBuff: string;
  protected
    procedure Execute; override;
    procedure Update;
  public
    constructor Create(ANetLink: TStationsLink; const SendMessage, Host, Port: string);
    destructor Destroy; override;
  end;

  TClientDataStringCollector = class(TThread)
  private
    ReceiveBuff: string;
    SendBuff: string;
    RemoteHost: string;
    RemoteHostName: string;
    FNetLink: TStationsLink;
    Finished: boolean;
  protected
    procedure Execute; override;
  public
    constructor Create;
    procedure CollectDataStringToAnswer;
  end;

{ TClientDataRequestor implementation }

constructor TClientDataStringRequestor.Create(ANetLink: TStationsLink;
                                        const SendMessage, Host, Port: string);
begin
  FNetLink := ANetLink;
  TcpClient := TTcpClient.Create(nil);
  TcpClient.RemoteHost := Host;
  TcpClient.RemotePort := Port;
  TcpClient.BlockMode := bmBlocking;
  SendBuff := SendMessage;
  inherited Create(True);
  FreeOnTerminate := True;
  Resume;
end;

destructor TClientDataStringRequestor.Destroy;
begin
  TcpClient.Free;
  inherited;
end;

procedure TClientDataStringRequestor.Execute;
begin
  try
    if TcpClient.Connect then
    begin
      TcpClient.Sendln(SendBuff);
      ReceiveBuff := TcpClient.Receiveln
    end
    else
      ReceiveBuff := '';
  finally
    TcpClient.Disconnect;
  end;
  Synchronize(Update);
end;

procedure TClientDataStringRequestor.Update;
begin
// Обработка клиентом полученных данных от сервера
  try
    if Assigned(FNetLink.OnClientDataReceive) then
      FNetLink.OnClientDataReceive(FNetLink, ReceiveBuff);
  finally
    FNetLink.FBusy := False;
  end;
end;

{ TClientDataCollector implementation }

constructor TClientDataStringCollector.Create;
begin
  inherited Create(True);
  Finished := False;
end;

procedure TClientDataStringCollector.Execute;
begin
  Synchronize(CollectDataStringToAnswer);
end;

procedure TClientDataStringCollector.CollectDataStringToAnswer;
begin
// Сбор данных сервером для ответа клиенту
// Выполняется в главном потоке приложения
  SendBuff:='';
  try
    if Assigned(FNetLink.OnServerDataCollector) then
      FNetLink.OnServerDataCollector(FNetLink, ReceiveBuff, SendBuff);
  finally
    Finished := True;
  end;
end;

{ TNetLink }

procedure TStationsLink.Close;
begin
  Active := False;
end;

procedure TStationsLink.CloseNetLink;
begin
  if csDesigning in ComponentState then Exit;
  if FServer then
  begin
    TcpServer.Close;
    Sleep(1000);
    TcpServer.Free;
  end;
  if Assigned(FOnClose) then FOnClose(Self);
end;

destructor TStationsLink.Destroy;
begin
  Close;
  inherited;
end;

procedure TStationsLink.Open;
begin
  Active:=True;
end;

procedure TStationsLink.OpenNetLink;
begin
  if csDesigning in ComponentState then Exit;
  if FServer then
  begin
    TcpServer := TTcpServer.Create(Self);
    TcpServer.BlockMode := bmThreadBlocking;
    TcpServer.OnAccept := TcpServerAccept;
    TcpServer.LocalHost := Host;
    TcpServer.LocalPort := Port;
    TcpServer.Open;
  end;
  if Assigned(FOnOpen) then FOnOpen(Self);
end;

procedure TStationsLink.SendToServer(const What: string);
begin
  FBusy := True;
  TClientDataStringRequestor.Create(Self, What, Host, Port);
end;

procedure TStationsLink.SetActive(const Value: Boolean);
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

procedure TStationsLink.SetServer(const Value: Boolean);
begin
  if FServer <> Value then
  begin
    if FActive then Close;
    FServer := Value;
    if FActive then Open;
  end;
end;

procedure TStationsLink.TcpServerAccept(Sender: TObject;
                                        ClientSocket: TCustomIpClient);
var Answer: string;
begin
// Выполняется в отдельном потоке
  with TClientDataStringCollector.Create do
  try
    FNetLink := Self;
    RemoteHost := ClientSocket.RemoteHost;
    RemoteHostName := ClientSocket.LookupHostName(ClientSocket.RemoteHost);
    ReceiveBuff := ClientSocket.Receiveln;
    Resume;
    WaitFor;
    Answer := SendBuff;
  finally
    Free;
  end;
  ClientSocket.Sendln(Answer);
end;

end.
