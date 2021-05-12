unit ShowRealTrendUnit;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Messages, EntityUnit, TeEngine, Series,
  TeeProcs, Chart, DateUtils, PanelFormUnit;

type
  TShowRealTrendForm = class(TForm)
    ToolPanel: TScrollBox;
    Shape3: TShape;
    Label3: TLabel;
    Shape1: TShape;
    Label1: TLabel;
    Shape2: TShape;
    Label2: TLabel;
    TimeLabel: TLabel;
    ValueLabel: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    CloseButton: TButton;
    TrendBevel: TBevel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Chart: TChart;
    PTHI: TFastLineSeries;
    PTLO: TFastLineSeries;
    PTHH: TFastLineSeries;
    PTLL: TFastLineSeries;
    PTOP: TFastLineSeries;
    PTSP: TFastLineSeries;
    PTPV: TFastLineSeries;
    CRPanel: TPanel;
    Shape4: TShape;
    Label4: TLabel;
    Shape5: TShape;
    Label6: TLabel;
    Shape6: TShape;
    Label8: TLabel;
    procedure CloseButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TrendTimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure ChartMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ChartAfterDraw(Sender: TObject);
  private
    OldX, OldY : Longint;
    CrossHairColor : TColor;
    CrossHairStyle : TPenStyle;
    FPanel: TPanelForm;
    procedure LoadTrendToChart(const Param, SeriesName: string;
                               const Delta, LowRange: Double);
  public
    Source: TCustomAnaOut;
    RealTrendSchemeName: string;
    procedure WMRealTrend(var Msg: TMessage); message WM_RealTrend;
    procedure LoadHistoryTreng(const PTSeriesName: string;
                               const Delta, LowRange: Double);
    property Panel: TPanelForm read FPanel write FPanel;
  end;

  TCashItem = record
    When: TDateTime;
    Value: Single;
  end;
  TCashItemArray = record
                     Body: array[1..86400] of TCashItem;
                     Length: integer;
                   end;

  TGetSingleRealTrend = class(TThread)
  private
    Item: TCashRealTrendItem;
    FMessage,CurrentTrendPath,Param,SeriesName: string;
    D1,D2: TDateTime;
    Color: TColor;
    DL,LL: Double;
    CashList: TCashItemArray;
    Owner: TShowRealTrendForm;
    procedure ShowMessage;
    procedure AddIntoSeries;
  protected
    procedure Execute; override;
  public
    constructor Create(AOwner: TShowRealTrendForm;
                       const ACurrentTrendPath,AParam,ASeriesName: string;
                       const AD1,AD2: TDateTime;
                       const AColor: TColor;
                       const ADelta,ALowRange: Double);
  end;

var
  ShowRealTrendForm: TShowRealTrendForm;

implementation

uses RemXUnit, Math;

{$R *.DFM}

procedure TShowRealTrendForm.LoadTrendToChart(const Param, SeriesName: string;
                                              const Delta, LowRange: Double);
var AColor: TColor; D1,D2: TDateTime;
begin
  AColor:=clLime;
  D2:=Now;
  D1:=D2-10*OneMinute;
  Chart.BottomAxis.SetMinMax(D1,D2);
  with TGetSingleRealTrend.Create(Self, Caddy.CurrentTrendPath,
                                  Param, SeriesName, D1, D2, AColor,
                                  Delta, LowRange) do
    Resume;
end;

procedure TShowRealTrendForm.FormCreate(Sender: TObject);
begin
  OldX := -1;
  CrossHairColor := clSilver;
  CrossHairStyle := psSolid;
  TimeLabel.Caption := FormatDatetime('nn:ss', EncodeTime(0, 0, 0, 0));
  ValueLabel.Caption := '0.0';
end;

procedure TShowRealTrendForm.CloseButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TShowRealTrendForm.TrendTimerTimer(Sender: TObject);
var D: TDateTime; AO: TCustomAnaOut; DL: Double;
begin
  AO := Source;
  CRPanel.Visible := AO.IsKontur;
  D := Now;
  DL := AO.PVEUHi-AO.PVEULo;
  if Abs(DL) > 0.0001 then
  begin
    if AO.HHDB <> adNone then PTHH.AddXY(D, 100*(AO.PVHHTP-AO.PVEULo)/DL);
    if AO.HIDB <> adNone then PTHI.AddXY(D, 100*(AO.PVHiTP-AO.PVEULo)/DL);
    if AO.LODB <> adNone then PTLO.AddXY(D, 100*(AO.PVLoTP-AO.PVEULo)/DL);
    if AO.LLDB <> adNone then PTLL.AddXY(D, 100*(AO.PVLLTP-AO.PVEULo)/DL);
    PTPV.AddXY(D, 100*(AO.PV-AO.PVEULo)/DL);
    if AO.IsKontur then
    begin
      PTSP.AddXY(D,100*(AO.FSP-AO.FSPEULo)/(AO.FSPEUHi-AO.FSPEULo));
      PTOP.AddXY(D, AO.FOP);
    end;
    Chart.RightAxis.SetMinMax(AO.PVEULo-DL*0.05,AO.PVEUHi+DL*0.05);
  end;
  Chart.BottomAxis.SetMinMax(D - 10*OneMinute, D);
  if PTHI.Count > 200 then PTHI.Delete(0);
  if PTLo.Count > 200 then PTLO.Delete(0);
  if PTHH.Count > 200 then PTHH.Delete(0);
  if PTLL.Count > 200 then PTLL.Delete(0);
  if PTPV.Count > 200 then PTPV.Delete(0);
  PTHI.RefreshSeries;
  PTLO.RefreshSeries;
  PTHH.RefreshSeries;
  PTLL.RefreshSeries;
  PTPV.RefreshSeries;
  if AO.IsKontur then
  begin
    if PTSP.Count > 200 then PTSP.Delete(0);
    PTSP.RefreshSeries;
    if PTOP.Count > 200 then PTOP.Delete(0);
    PTOP.RefreshSeries;
  end;
end;

procedure TShowRealTrendForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  RealTrendSchemeName:='';
  Action:=caFree;
end;

procedure TShowRealTrendForm.WMRealTrend(var Msg: TMessage);
begin
 if (RealTrendSchemeName = Panel.WorkSchemeName) and not CanFocus then
 begin
   SetForegroundWindow(Handle);
   BringToFront;
   FormStyle:=fsStayOnTop;
   Update;
   if Assigned(Panel.TopForm) then Panel.TopForm.SetFocus;
 end;
 TrendTimerTimer(Self);
end;

procedure TShowRealTrendForm.FormResize(Sender: TObject);
begin
  ToolPanel.Visible:= (Width >= 280) and (Height >= 170);
end;

procedure TShowRealTrendForm.ChartMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
  { This procedure draws the crosshair lines }
  Procedure DrawCross(AX,AY:Integer);
  begin
    with Chart,Canvas do
    begin
      Pen.Color := CrossHairColor;
      Pen.Style := CrossHairStyle;
      Pen.Mode := pmXor;
      Pen.Width := 1;
      MoveTo(ax,ChartRect.Top-Height3D);
      LineTo(ax,ChartRect.Bottom-Height3D);
      MoveTo(ChartRect.Left+Width3D,ay);
      LineTo(ChartRect.Right+Width3D,ay);
    end;
  end;

var
  tmpX, tmpY : Double;
begin
  if (OldX <> -1) then
  begin
    DrawCross(OldX,OldY); { draw old crosshair }
    OldX := -1;
  end;

    { check if mouse is inside Chart rectangle }
  if ssShift in Shift then  // если нажата клавиша < Shift >
  begin
    if PtInRect(Chart.ChartRect, Point(X-Chart.Width3D,
                 Y+Chart.Height3D)) then
    begin
      DrawCross(x,y); { draw crosshair at current position }
      { store old position }
      OldX := x;
      OldY := y;
    end;
  end;

    { set label text }
  if PtInRect(Chart.ChartRect, Point(X-Chart.Width3D,
              Y+Chart.Height3D)) then
      With PTPV do
      begin
        GetCursorValues(tmpX,tmpY); { <-- get values under mouse cursor }
        ValueLabel.Caption := Format('%.3f', [tmpY]);
        TimeLabel.Caption := FormatDateTime('h ч. nn мин.', (tmpX));
      end
  else
    begin
      ValueLabel.Caption := '';
      TimeLabel.Caption := '';
    end;
end;

procedure TShowRealTrendForm.ChartAfterDraw(Sender: TObject);
begin
  OldX := -1; { Reset old mouse position }
end;

{ TGetSingleRealTrend }

procedure TGetSingleRealTrend.AddIntoSeries;
var C: TComponent; Data: TFastLineSeries; i,Count: integer;
begin
  Screen.Cursor:=crAppStart;
  try
    C:=Owner.FindComponent(SeriesName);
    if Assigned(C) then
    begin
      Data:=C as TFastLineSeries;
      Count:=CashList.Length;
      for i:=0 to Count-1 do
      begin
        if InRange(i,1,Count-2) then
        begin
          if (CashList.Body[i+1].Value <> CashList.Body[i].Value) or
             (CashList.Body[i+1].Value <> CashList.Body[i+2].Value) then
            Data.AddXY(CashList.Body[i+1].When,CashList.Body[i+1].Value,'',Color);
        end
        else
          Data.AddXY(CashList.Body[i+1].When,CashList.Body[i+1].Value,'',Color);
      end;
    end
    else
      Terminate;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

constructor TGetSingleRealTrend.Create(AOwner: TShowRealTrendForm;
  const ACurrentTrendPath, AParam, ASeriesName: string; const AD1, AD2: TDateTime;
  const AColor: TColor; const ADelta,ALowRange: Double);
begin
  Owner:=AOwner;
  CurrentTrendPath:=ACurrentTrendPath;
  Param:=AParam;
  SeriesName:=ASeriesName;
  D1:=AD1;
  D2:=AD2;
  Color:=AColor;
  DL:=ADelta;
  LL:=ALowRange;
  inherited Create(True);
  Priority:=tpHigher;
  FreeOnTerminate:=True;
end;

procedure TGetSingleRealTrend.Execute;
var DS,DE: TDateTime; hh,nn,ss,zz: word;
    FileName,DirName: string; Count: integer;
    F: TFileStream;
begin
  CashList.Length:=0;
  DecodeTime(D1,hh,nn,ss,zz);
  DS:=Int(D1)+EncodeTime(hh,0,0,0);
  DecodeTime(D2,hh,nn,ss,zz);
  DE:=Int(D2)+EncodeTime(hh,59,59,999);
  while DS < DE do
  begin
    if Terminated then Break;
    DirName:=CurrentTrendPath+FormatDateTime('\yymmdd\hh',DS);
    FileName:=IncludeTrailingPathDelimiter(DirName)+Param;
    if FileExists(FileName) then
    begin
      F:=TryOpenToReadFile(FileName);
      if not Assigned(F) then
      begin
        FMessage:='Файл "'+ExtractFileName(FileName)+
                  '" занят другим процессом. Тренд не загружен!';
        Synchronize(ShowMessage);
        Exit;
      end;
      try
        F.Seek(0,soFromBeginning);
        while F.Position < F.Size do
        begin
          if Terminated then Break;
          try
            try
              F.ReadBuffer(Item.SnapTime,SizeOf(Item.SnapTime));
              F.ReadBuffer(Item.Value,SizeOf(Item.Value));
              F.ReadBuffer(Item.Kind,SizeOf(Item.Kind));
            except
              Break;
            end;
            if InRange(Item.SnapTime,D1,D2) then
            begin
              if CashList.Length < High(CashList.Body) then
              begin
                Inc(CashList.Length);
                Count := CashList.Length;
                CashList.Body[Count].When := Item.SnapTime;
                CashList.Body[Count].Value := 100*(Item.Value-LL)/DL
              end;
            end;
          except
            Break;
          end;
        end;
      finally
        F.Free;
      end;
    end;
    DS := DS + OneHour;
  end;
  if CashList.Length > 0 then Synchronize(AddIntoSeries);
end;

procedure TGetSingleRealTrend.ShowMessage;
begin
  RemXForm.ShowMessage:=FMessage;
end;

procedure TShowRealTrendForm.LoadHistoryTreng(const PTSeriesName: string;
                                              const Delta, LowRange: Double);
begin
  if Assigned(Source) then
  begin
    if PTSeriesName = 'PTPV' then
      LoadTrendToChart(Source.PtName + '.PV', PTSeriesName, Delta, LowRange);
    if PTSeriesName = 'PTSP' then
      LoadTrendToChart(Source.PtName + '.SP', PTSeriesName, Delta, LowRange);
    if PTSeriesName = 'PTOP' then
      LoadTrendToChart(Source.PtName + '.OP', PTSeriesName, Delta, LowRange);
  end;
end;

end.

