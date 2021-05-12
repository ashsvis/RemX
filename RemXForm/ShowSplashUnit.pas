unit ShowSplashUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TShowSplashForm = class(TForm)
    SplashImage: TImage;
    CloseButton: TButton;
    Label1: TLabel;
    Version: TLabel;
    HideTimer: TTimer;
    Bevel1: TBevel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure HideTimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CloseButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure FillVersionInfo;
  public
  end;

var
  ShowSplashForm: TShowSplashForm;

procedure ShowSplash;

implementation

uses  ZLib;

{$R *.dfm}

procedure DecompressStream(aSource,aTarget: TStream);
var decompStream: TDecompressionStream;
    nRead: Integer;
    Buffer: array[0..1023] of Byte;
begin
  decompStream:=TDecompressionStream.Create(aSource);
  try
    repeat
      nRead:=decompStream.Read(Buffer,1024);
      aTarget.Write(Buffer,nRead);
    until nRead = 0;
  finally
    decompStream.Free;
  end;
end;

procedure TShowSplashForm.FillVersionInfo;
var Size, Size2: DWord;
    Pt, Pt2: Pointer;
begin
  Size := GetFileVersionInfoSize(PChar(ParamStr(0)),Size2);
  if Size > 0 then
  begin
    GetMem(Pt,Size);
    try
       GetFileVersionInfo(PChar(ParamStr(0)),0,Size,Pt);
       // show the fixed information
       VerQueryValue(Pt,'\',Pt2,Size2);
       with TVSFixedFileInfo (Pt2^) do
       begin
         Version.Caption:=IntToStr(HiWord(dwFileVersionMS))+'.'+
                          IntToStr(LoWord(dwFileVersionMS))+'.'+
                          IntToStr(HiWord(dwFileVersionLS))+'.'+
                          IntToStr(LoWord(dwFileVersionLS));
       end;
    finally
      FreeMem (Pt);
    end;
  end;
end;

procedure TShowSplashForm.FormCreate(Sender: TObject);
var RF: TResourceStream; M: TMemoryStream;
begin
  RF:=TResourceStream.Create(hInstance,'SplashTemplate',RT_RCDATA);
  try
    M:=TMemoryStream.Create;
    try
      DecompressStream(RF,M);
      M.Position:=0;
      SplashImage.Picture.Bitmap.LoadFromStream(M);
      FillVersionInfo;
    finally
      M.Free;
    end;
  finally
    RF.Free;
  end;
end;

procedure ShowSplash;
begin
  ShowSplashForm:=TShowSplashForm.Create(Application);
  with ShowSplashForm do
  begin
    OnClose:=FormClose;
//    FormStyle:=fsStayOnTop;
    Position:=poScreenCenter;
    Show;
    Update;
    HideTimer.Enabled:=True;
  end;
end;

procedure TShowSplashForm.HideTimerTimer(Sender: TObject);
begin
  Close;
end;

procedure TShowSplashForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TShowSplashForm.CloseButtonClick(Sender: TObject);
begin
  HideTimerTimer(HideTimer);
end;

procedure TShowSplashForm.FormShow(Sender: TObject);
begin
//  AnimateWindow(SplashForm.Handle,1000,AW_BLEND);
end;

end.
