unit Notify;

interface

uses Windows;

type
  { Процедура обратного вызова для объекта-нотификатора. }
  TCallBackEvent = procedure(Sender: TObject; Msg, UsrParam: DWord) of object;

  TCallBackNotify = class
  protected
    fOnNotify: TCallBackEvent;
    hOwner: THandle;
    Message, UParam: DWord;
  public
    property Owner: THandle read hOwner write hOwner;
    property Param: DWord read UParam write UParam;
    property OnEvent: TCallBackEvent read fOnNotify write fOnNotify;
    constructor Create(hEventObj: TCallBackEvent; hSender: THandle;
                       MsgID, UserParam: DWord);
    procedure Execute;
  end;

implementation

{ TCallBackNotify }

constructor TCallBackNotify.Create(hEventObj: TCallBackEvent;
  hSender: THandle; MsgID, UserParam: DWord);
begin
  OnEvent:=hEventObj;
  hOwner:=hSender;
  Message:=MsgID;
  UParam:=UserParam;
end;

procedure TCallBackNotify.Execute;
begin
  if Assigned(OnEvent) then OnEvent(TObject(hOwner), Message, UParam);
end;

end.
