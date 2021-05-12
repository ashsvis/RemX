unit Timers;

interface

uses
  Windows, Classes, Notify;

const
  TimeSlice = 10;

type
  TTimerItem = class
  private
    fNotifier: TCallBackNotify;
    fInterval: DWord;
    fCurrent: DWord;
    procedure SetPause(Pause: Boolean);
  protected
    fEnabled: Boolean;
  public
    constructor Create(NotifyObj: TCallBackNotify; Run: Boolean;
                       Interval: DWord);
    destructor Destroy; override;
    procedure Reset;
    procedure Update(Increment: DWord);
    property Interval: DWord read fInterval write fInterval;
    property Enabled: Boolean write SetPause;
  end;

  TTimerServer = class(TThread)
  private
    TimerList: TThreadList;
    LastTicks: DWord;
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;
    property Terminated;
    procedure AddTimer(Item: TTimerItem);
    procedure DeleteTimer(Item: TTimerItem);
  end;

var
  TimerServer: TTimerServer;

implementation

{ TTimerItem }

constructor TTimerItem.Create(NotifyObj: TCallBackNotify; Run: Boolean;
  Interval: DWord);
begin
  fNotifier:=NotifyObj;
  fNotifier.Owner:=THandle(Self);
  fEnabled:=Run;
  fInterval:=Interval;
end;

destructor TTimerItem.Destroy;
begin
  fNotifier.Free;
  inherited;
end;

procedure TTimerItem.Reset;
begin
  fCurrent:=0;
end;

procedure TTimerItem.SetPause(Pause: Boolean);
begin
  fEnabled:=Pause;
end;

procedure TTimerItem.Update(Increment: DWord);
begin
  if not fEnabled then Exit;
  Inc(fCurrent, Increment);
  if fCurrent < fInterval then Exit;
  fCurrent:=fCurrent mod fInterval;
  fNotifier.Execute;
end;

{ TTimerServer }

procedure TTimerServer.AddTimer(Item: TTimerItem);
begin
  with TimerList.LockList do Add(Item);
  TimerList.UnlockList;
end;

constructor TTimerServer.Create;
begin
  inherited Create(True);
  Priority:=tpTimeCritical;
  TimerList:=TThreadList.Create;
  Resume;
end;

procedure TTimerServer.DeleteTimer(Item: TTimerItem);
begin
  with TimerList.LockList do Remove(Item);
  TimerList.UnlockList;
  Item.Free;
end;

destructor TTimerServer.Destroy;
var i: integer;
begin
  with TimerList.LockList do
  try
    for i:=0 to Count-1 do TTimerItem(Items[i]).Free;
  finally
    TimerList.UnlockList;
  end;
  TimerList.Free;
  inherited;
end;

procedure TTimerServer.Execute;
var Ticks, Diff: DWord; i: Integer;
begin
  LastTicks:=GetTickCount;
  while not Terminated do
  begin
    Sleep(TimeSlice-(GetTickCount mod TimeSlice));
    Ticks:=GetTickCount;
    Diff:=Ticks-LastTicks;
    LastTicks:=Ticks;
    with TimerList.LockList do
    try
      for i:=0 to Count-1 do
      begin
        if Terminated then Exit;
        TTimerItem(Items[i]).Update(Diff);
      end;
    finally
      TimerList.UnlockList;
    end;
  end;
end;

initialization
  TimerServer:=TTimerServer.Create;
  TimerServer.Suspend;

finalization
  TimerServer.Suspend;
  TimerServer.Free;

end.
