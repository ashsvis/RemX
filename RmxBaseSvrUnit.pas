unit RmxBaseSvrUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IniFiles, SyncObjs, ExtCtrls;

type
  TRmxBaseSvrForm = class(TForm)
    CheckSelf: TTimer;
    Clock: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CheckSelfTimer(Sender: TObject);
    procedure ClockTimer(Sender: TObject);
  private
  public
  end;

var
  RmxBaseSvrForm: TRmxBaseSvrForm;
  SafeSection: TCriticalSection;
  Base: TMemIniFile;
  ClientsCount: integer;
  ServerTime: TDateTime;


implementation

{$R *.dfm}

procedure TRmxBaseSvrForm.FormCreate(Sender: TObject);
begin
  ServerTime:=Now;
  SafeSection:=TCriticalSection.Create;
  ClientsCount:=0;
  Base:=TMemIniFile.Create('');
end;

procedure TRmxBaseSvrForm.FormDestroy(Sender: TObject);
begin
  Base.Free;
  SafeSection.Free;
end;

procedure TRmxBaseSvrForm.CheckSelfTimer(Sender: TObject);
begin
  if ClientsCount = 0 then
  begin
    CheckSelf.Enabled:=False;
    Application.Terminate;
  end;
end;

procedure TRmxBaseSvrForm.ClockTimer(Sender: TObject);
begin
  ServerTime:=Now;
end;

end.
