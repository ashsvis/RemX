unit ShowTrendsUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, TeeProcs, TeEngine, Chart, ExtCtrls, ToolWin,
  Menus, ImgList, Series, EntityUnit, StdCtrls, Buttons, AppEvnts,
  Contnrs, FR_Class, ThreadSaveUnit, ComCtrls, PanelFormUnit;

type
  TShowTrendsForm = class(TForm, IEntity)
    ImageList: TImageList;
    TimePopupMenu: TPopupMenu;
    ControlPanel: TPanel;
    Panel1: TPanel;
    Shape1: TShape;
    SpeedButton1: TButton;
    CheckBox1: TCheckBox;
    Edit1: TButton;
    Panel3: TPanel;
    Shape3: TShape;
    SpeedButton3: TButton;
    Bevel3: TBevel;
    CheckBox3: TCheckBox;
    Panel5: TPanel;
    Shape5: TShape;
    SpeedButton5: TButton;
    Bevel5: TBevel;
    CheckBox5: TCheckBox;
    Edit5: TButton;
    Panel7: TPanel;
    Shape7: TShape;
    SpeedButton7: TButton;
    CheckBox7: TCheckBox;
    Edit7: TButton;
    Panel2: TPanel;
    Shape2: TShape;
    SpeedButton2: TButton;
    CheckBox2: TCheckBox;
    Edit2: TButton;
    Panel4: TPanel;
    Shape4: TShape;
    SpeedButton4: TButton;
    Bevel4: TBevel;
    CheckBox4: TCheckBox;
    Edit4: TButton;
    Panel6: TPanel;
    Shape6: TShape;
    SpeedButton6: TButton;
    Bevel6: TBevel;
    CheckBox6: TCheckBox;
    Edit6: TButton;
    Panel8: TPanel;
    Shape8: TShape;
    SpeedButton8: TButton;
    CheckBox8: TCheckBox;
    Edit8: TButton;
    Edit3: TButton;
    Bevel1: TBevel;
    Bevel2: TBevel;
    TrendView: TChart;
    TrendControlBar: TControlBar;
    ToolBar: TToolBar;
    tbZoomIn: TToolButton;
    tbZoomOut: TToolButton;
    tbZoomReset: TToolButton;
    ToolButton2: TToolButton;
    tbPrinting: TToolButton;
    ToolButton1: TToolButton;
    tbLessTime: TToolButton;
    tbTimeSelect: TToolButton;
    tbMoreTime: TToolButton;
    ScrollingPanel: TPanel;
    cbScrolling: TCheckBox;
    tbGrid: TToolButton;
    tbPreview: TToolButton;
    frTrendReport: TfrReport;
    pmEntityButtonClick: TPopupMenu;
    miPassport: TMenuItem;
    miBase: TMenuItem;
    WaitLabel: TLabel;
    DateTimeArea: TPaintBox;
    procedure FormCreate(Sender: TObject);
    procedure tbTime0Click(Sender: TObject);
    procedure TimePopupMenuPopup(Sender: TObject);
    procedure tbLessTimeClick(Sender: TObject);
    procedure tbMoreTimeClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure NewLinkClick(Sender: TObject);
    procedure ChangeLinkClick(Sender: TObject);
    procedure DeleteLinkClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure tbZoomInClick(Sender: TObject);
    procedure tbZoomOutClick(Sender: TObject);
    procedure tbZoomResetClick(Sender: TObject);
    procedure TrendViewAfterDraw(Sender: TObject);
    procedure TrendViewScroll(Sender: TObject);
    procedure TrendViewUndoZoom(Sender: TObject);
    procedure TrendViewZoom(Sender: TObject);
    procedure TrendViewMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure tbPrintingClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbScrollingClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure tbGridClick(Sender: TObject);
    procedure pmEntityButtonClickPopup(Sender: TObject);
    procedure miPassportClick(Sender: TObject);
    procedure miBaseClick(Sender: TObject);
    procedure TrendViewMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DateTimeAreaClick(Sender: TObject);
  private
    SmallImages: TImageList;
    FShiftFlag: boolean;
    FScrollFlag: boolean;
    LastEntity: TCustomAnaOut;
    LastKind: Byte;
    AEntity: array[1..8] of TCustomAnaOut;
    SEntity: array[1..8] of string;
    AEdit: array[1..8] of TButton;
    ASpeedButton: array[1..8] of TButton;
    ACheckBox: array[1..8] of TCheckBox;
    AShape: array[1..8] of TShape;
    StartTime,ShiftTime: TDateTime;
    FirstSnap,LastSnap: TDateTime;
    PathToSave: string;
    FPanel: TPanelForm;
    procedure ConnectEntity(Entity: TEntity); stdcall;
    procedure ConnectImageList(ImageList: TImageList); stdcall;
    procedure UpdateRealTime; stdcall;
    procedure SaveConfig(Path: string);
    procedure LoadTrendToChart(Index: integer; Param: string);
    procedure SetShiftFlag(const Value: boolean);
    property ShiftFlag: boolean read FShiftFlag write SetShiftFlag;
    procedure ReloadTrend(Index: integer);
    procedure ShiftRemove(var Mess: TMessage); message WM_ShiftRemove;
    function GetShiftTime(Index: integer): TDateTime;
    procedure UpdateStartPoint(D: TDateTime);
    procedure TrendLoaded(Sender: TObject);
  public
    TrendsCount: integer;
    CurrentDate: TDateTime;
    CurrentTimeIndex: integer;
    CurrentEntityIndex: integer;
    OldX, OldY : Longint;
    CrossHairColor : TColor;
    CrossHairStyle : TPenStyle;
    ASeries,LSeries: array[1..8] of TComponentList;
    TSeries: array[1..8] of TThread;
    procedure LoadConfig(Path: string);
    procedure ReloadTrends;
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
                     
  TGetSingleTrend = class(TThread)
  private
    Item: TCashRealTrendItem;
    FMessage,CurrentTrendPath,Param,SeriesName: string;
    D1,D2: TDateTime;
    Color: TColor;
    CashList: TCashItemArray;
    Owner: TShowTrendsForm;
    procedure ShowMessage;
    procedure SaveOldSeries;
    procedure AppendNewSeries;
    procedure AddIntoSeries;
    procedure CheckExistSeries;
  protected
    procedure Execute; override;
  public
    Index: integer;
    constructor Create(AOwner: TShowTrendsForm;
                       ACurrentTrendPath,AParam: string; AD1,AD2: TDateTime;
                       AIndex: integer; AColor: TColor);
  end;

var
  ShowTrendsForm: TShowTrendsForm;

implementation

uses Math, RemXUnit, StrUtils, DateUtils, SyncObjs,
     GetLinkNameUnit, PrintDialogUnit,
  TimeFilterUnit;

{$R *.dfm}

var GetSingleTrendSection: array[1..8] of TCriticalSection;

{ TGetSingleTrend }

procedure TGetSingleTrend.AddIntoSeries;
var C: TComponent; Data: TLineSeries; i,Count: integer;
begin
  Screen.Cursor:=crAppStart;
  try
    C:=Owner.FindComponent(SeriesName);
    if Assigned(C) then
    begin
      Data:=C as TLineSeries;
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

procedure TGetSingleTrend.AppendNewSeries;
var Data: TLineSeries;
begin
  Screen.Cursor:=crAppStart;
  try
    try
      SeriesName:=Format('FL%d%d',[Index,Owner.ASeries[Index].Count]);
      Data:=TLineSeries.Create(Owner);
      Data.Name:=SeriesName;
      Data.ParentChart:=Owner.TrendView;
      Data.ColorEachPoint:=False;
      Data.SeriesColor:=Color;
      Data.VertAxis:=aRightAxis;
      Data.XValues.DateTime:=True;
      Owner.ASeries[Index].Add(Data);
    except
      Terminate;
    end;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TGetSingleTrend.SaveOldSeries;
var C: TComponent; S: string;
begin
  Screen.Cursor:=crAppStart;
  try
    Owner.LSeries[Index].Clear;
    while Owner.ASeries[Index].Count > 0 do
    begin
      C:=Owner.ASeries[Index].First;
      Owner.ASeries[Index].Extract(C);
      S:=C.Name;
      S:='L'+Copy(S,2,Length(S));
      C.Name:=S;
      Owner.LSeries[Index].Add(C);
    end;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TGetSingleTrend.CheckExistSeries;
begin
  if not Assigned(Owner.FindComponent(SeriesName)) then Terminate;
end;

constructor TGetSingleTrend.Create(AOwner: TShowTrendsForm;
                          ACurrentTrendPath,AParam: string;
                          AD1,AD2: TDateTime; AIndex: integer; AColor: TColor);
begin
  Owner:=AOwner;
  CurrentTrendPath:=ACurrentTrendPath;
  Param:=AParam;
  D1:=AD1;
  D2:=AD2;
  Index:=AIndex;
  Color:=AColor;
  inherited Create(True);
  Priority:=tpHigher;
  FreeOnTerminate:=True;
end;

procedure TGetSingleTrend.Execute;
var Flag: boolean; DS,DE: TDateTime; hh,nn,ss,zz: word;
    FileName,DirName: string; Count: integer;
    F: TFileStream;
begin
  CashList.Length:=0;
  GetSingleTrendSection[Index].Enter;
  try
    Synchronize(SaveOldSeries);
    SeriesName:='';
    Flag:=False;
    DecodeTime(D1,hh,nn,ss,zz);
    DS:=Int(D1)+EncodeTime(hh,0,0,0);
    DecodeTime(D2,hh,nn,ss,zz);
    DE:=Int(D2)+EncodeTime(hh,59,59,999);
    while DS < DE do
    begin
      if Terminated then Exit;
      DirName:=CurrentTrendPath+FormatDateTime('\yymmdd\hh',DS);
      FileName:=IncludeTrailingPathDelimiter(DirName)+Param;
      if FileExists(FileName) then
      begin
        F:=TryOpenToReadFile(FileName);
        if not Assigned(F) then
        begin
          FMessage:='���� "'+ExtractFileName(FileName)+
                    '" ����� ������ ���������. ����� �� ��������!';
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
                if Item.Kind or (D2-D1 > OneHour*2.1) then
                begin
                  if not Flag then
                  begin
                    Flag:=True;
                    if CashList.Length > 0 then Synchronize(AddIntoSeries);
                    Synchronize(AppendNewSeries);
                    CashList.Length:=0;
                  end;
                  if CashList.Length < High(CashList.Body) then
                  begin
                    Inc(CashList.Length);
                    Count:=CashList.Length;
                    CashList.Body[Count].When:=Item.SnapTime;
                    CashList.Body[Count].Value:=Item.Value;
                    if (Count mod 100) = 0 then Synchronize(CheckExistSeries);
                  end;  
                end
                else
                  Flag:=False;
              end;
            except
              Break;
            end;
          end;
        finally
          F.Free;
        end;
      end;
      DS:=DS+OneHour;
    end;
    if CashList.Length > 0 then Synchronize(AddIntoSeries);
  finally
    GetSingleTrendSection[Index].Leave;
  end;
end;

procedure TGetSingleTrend.ShowMessage;
begin
  RemXForm.ShowMessage:=FMessage;
end;

{ TShowTrendsForm }

procedure TShowTrendsForm.UpdateStartPoint(D: TDateTime);
var M: TDateTime; dd,hh,nn,ss,ms: Word; S: string;
begin
  TrendView.Foot.Text.Clear;
  TrendView.Foot.Text.Add(DateToStr(D));
  TrendView.Foot.Text.Add(TimeToStr(D));
  M:=TrendView.BottomAxis.Maximum-TrendView.BottomAxis.Minimum;
  dd:=Word(Trunc(M));
  DecodeTime(M,hh,nn,ss,ms);
  S:=' ';
  if dd > 0 then 
    S:=S+NumToStr(dd,'','����','���','����')+' ';
  if hh > 0 then
    S:=S+NumToStr(hh,'���','','�','��')+' ';
  if nn > 0 then
    S:=S+NumToStr(nn,'�����','�','�','')+' ';
  if (dd=0) and (hh=0) and (nn=0) then
    S:='������ ������';
  tbTimeSelect.Caption:=S;
end;

procedure TShowTrendsForm.FormCreate(Sender: TObject);
var i: integer; M: TMenuItem; SL: TStrings;
begin
  PathToSave := 'TrendView';
  FScrollFlag:=False;
  for i:=1 to 8 do
  begin
    TSeries[i]:=nil;
    ASeries[i]:=TComponentList.Create(True);
    LSeries[i]:=TComponentList.Create(True);
    AEdit[i]:=FindComponent('Edit'+IntToStr(i)) as TButton;
    ASpeedButton[i]:=FindComponent('SpeedButton'+IntToStr(i)) as TButton;
    ACheckBox[i]:=FindComponent('CheckBox'+IntToStr(i)) as TCheckBox;
    AShape[i]:=FindComponent('Shape'+IntToStr(i)) as TShape;
  end;
  ShiftTime:=EncodeTime(0,20,0,0);
  LastEntity:=nil;
  LastKind:=0;
  SL:=TStringList.Create;
  try
    SL.Add('20 �����');
    SL.Add('1 ���');
    SL.Add('2 ����');
    SL.Add('4 ����');
    SL.Add('8 �����');
    SL.Add('12 �����');
    SL.Add('24 ����');
    for i:=0 to SL.Count-1 do
    begin
      M:=TMenuItem.Create(Self);
      M.Caption:=SL[i];
      M.GroupIndex:=1;
      M.AutoCheck:=True;
      M.Tag:=i;
      M.OnClick:=tbTime0Click;
     TimePopupMenu.Items.Add(M);
    end;
  finally
    SL.Free;
  end;
  for i:=1 to 8 do AEntity[i]:=nil;
  OldX := -1;
  CrossHairColor := clSilver;
  CrossHairStyle := psSolid;
  CurrentTimeIndex := 0;
  tbTimeSelect.Caption:=TimePopupMenu.Items.Items[CurrentTimeIndex].Caption;
  TrendView.PrintMargins.Left := 3;
  TrendView.PrintMargins.Top := 3;
  TrendView.PrintMargins.Right := 3;
  TrendView.PrintMargins.Bottom := 3;
  TrendView.PrintResolution := -100;
  TrendView.OriginalCursor := crDefault;
  TrendView.BottomAxis.SetMinMax(Now-20*OneMinute,Now);
  UpdateStartPoint(Now);
  TrendView.RightAxis.SetMinMax(0,100);
  CurrentEntityIndex:=-1;
end;

procedure TShowTrendsForm.LoadConfig(Path: string);
var i: integer; E: TEntity; D: TDateTime;
begin
  PathToSave := Path;
  with RemXForm do
  begin
    tbGrid.Down:=Config.ReadBool(Path,'ShowGrid',False);
    TrendView.RightAxis.Grid.Visible:=tbGrid.Down;
    TrendView.BottomAxis.Grid.Visible:=tbGrid.Down;
    CurrentTimeIndex:=Config.ReadInteger(Path,'TrendTime',0);
    if CurrentTimeIndex > 6 then CurrentTimeIndex:=6;
    ShiftTime:=GetShiftTime(CurrentTimeIndex);
    D:=Now; TrendView.BottomAxis.SetMinMax(D-ShiftTime,D);
    tbTimeSelect.Caption:=TimePopupMenu.Items.Items[CurrentTimeIndex].Caption;
    CurrentEntityIndex:=Config.ReadInteger(Path,'TrendIndex',-1);
    for i:=8 downto 1 do
    begin
      AEdit[i].Caption:=Config.ReadString(Path,'Point'+IntToStr(i),'');
      ACheckBox[i].OnClick:=nil;
      if AEdit[i].Caption <> '' then
        ACheckBox[i].Checked:=Config.ReadBool(Path,'Check'+IntToStr(i),True)
      else
        ACheckBox[i].Checked:=False;
      ACheckBox[i].OnClick:=CheckBox1Click;
      E:=Caddy.Find(Copy(AEdit[i].Caption,1,Pos('.',AEdit[i].Caption)-1));
      if Assigned(E) then
      begin
        AEntity[i]:=E as TCustomAnaOut;
        SEntity[i]:=AEntity[i].PtName;
        AEdit[i].ShowHint:=True;
        AEdit[i].Hint:=AEntity[i].PtDesc;
        ACheckBox[i].OnClick:=nil;
        ACheckBox[i].OnClick:=CheckBox1Click;
        ACheckBox[i].Enabled:=True;
        ASpeedButton[i].Enabled:=True;
        ASpeedButton[i].Hint:='�����: '+Format('%g .. %g %s',
                                     [AEntity[i].PVEULo,
                                      AEntity[i].PVEUHi,AEntity[i].EUDesc]);
        if ACheckBox[i].Checked then
        begin
          TrendView.RightAxis.SetMinMax(AEntity[i].PVEULo,AEntity[i].PVEUHi);
          TrendView.RightAxis.Title.Caption:=AEntity[i].EUDesc;
        end;
      end
      else
      begin
        AEntity[i]:=nil;
        SEntity[i]:='';
        AEdit[i].Caption:='';
        AEdit[i].ShowHint:=False;
        AEdit[i].Hint:='';
        ACheckBox[i].Enabled:=False;
        ASpeedButton[i].Enabled:=False;
        ASpeedButton[i].Hint:='';
      end;
    end;
    for i:=1 to 8 do
    begin
      if not ACheckBox[i].Checked and (AEdit[i].Caption <> '') then
      begin
        AEdit[i].Enabled:=False;
        ASpeedButton[i].Enabled:=False;
      end;
    end;
    with TrendView.RightAxis do
    begin
      if CurrentEntityIndex >= 0 then
        LabelsFont.Color:=clBlack
      else
        LabelsFont.Color:=clGray;
    end;
    cbScrolling.OnClick:=nil;
    try
      cbScrolling.Checked:=Config.ReadBool(Path,'Scrolling',True);
    finally
      cbScrolling.OnClick:=cbScrollingClick;
    end;
    tbTime0Click(TimePopupMenu.Items[CurrentTimeIndex]);
  end;
end;

procedure TShowTrendsForm.ReloadTrend(Index: integer);
begin
  if AEdit[Index].Caption <> '' then
  begin
    if ACheckBox[Index].Checked then
      LoadTrendToChart(Index,AEdit[Index].Caption)
    else
    begin
      ASeries[Index].Clear;
      LSeries[Index].Clear;
    end;
  end;
end;

procedure TShowTrendsForm.ReloadTrends;
var i: integer;
begin
  if cbScrolling.Checked and not ShiftFlag then 
  begin
    for i:=1 to 8 do ReloadTrend(i);
    CurrentDate:=TrendView.BottomAxis.Maximum;
    SaveConfig(PathToSave);
  end;
end;

function TShowTrendsForm.GetShiftTime(Index: integer): TDateTime;
begin
  case CurrentTimeIndex of
    1: Result:=OneHour;
    2: Result:=OneHour*2;
    3: Result:=OneHour*4;
    4: Result:=OneHour*8;
    5: Result:=OneHour*12;
    6: Result:=OneHour*24;
  else
    Result:=EncodeTime(0,20,0,0);
  end;
end;

procedure TShowTrendsForm.TimePopupMenuPopup(Sender: TObject);
var i: integer;
begin
  for i:=0 to TimePopupMenu.Items.Count-1 do
    TimePopupMenu.Items.Items[i].Checked:=False;
  TimePopupMenu.Items.Items[CurrentTimeIndex].Checked:=True;
end;

procedure TShowTrendsForm.tbTime0Click(Sender: TObject);
var D: TDateTime;
begin
  TrendView.UndoZoom;
  if Sender is TMenuItem then
  with Sender as TMenuItem do
  begin
    Checked:=True;
    CurrentTimeIndex:=Tag;
    tbTimeSelect.Caption:=Caption;
  end;
  ShiftTime:=GetShiftTime(CurrentTimeIndex);
  D:=Now;
  TrendView.BottomAxis.SetMinMax(D-ShiftTime,D);
  UpdateStartPoint(D);
  cbScrolling.OnClick:=nil;
  try
    cbScrolling.Checked:=True;
  finally
    cbScrolling.OnClick:=cbScrollingClick;
  end;
  ReloadTrends;
  SaveConfig(PathToSave);
end;

procedure TShowTrendsForm.tbLessTimeClick(Sender: TObject);
var D1,D2,D3: TDateTime; i: integer;
begin
  cbScrolling.OnClick:=nil;
  try
    cbScrolling.Checked:=False;
  finally
    cbScrolling.OnClick:=cbScrollingClick;
  end;
  D3:=TrendView.BottomAxis.Maximum-TrendView.BottomAxis.Minimum;
  D2:=TrendView.BottomAxis.Minimum;
  D1:=D2-D3;
  TrendView.BottomAxis.SetMinMax(D1,D2);
  UpdateStartPoint(D2);
  for i:=1 to 8 do
  begin
    if AEdit[i].Caption <> '' then
    begin
      if ACheckBox[i].Checked then
        LoadTrendToChart(i,AEdit[i].Caption)
      else
      begin
        ASeries[i].Clear;
        LSeries[i].Clear;
      end;
    end;
  end;
  SaveConfig(PathToSave);
end;

procedure TShowTrendsForm.tbMoreTimeClick(Sender: TObject);
var D1,D2,D3: TDateTime; i: integer;
begin
  cbScrolling.OnClick:=nil;
  try
    cbScrolling.Checked:=False;
  finally
    cbScrolling.OnClick:=cbScrollingClick;
  end;
  D3:=TrendView.BottomAxis.Maximum-TrendView.BottomAxis.Minimum;
  D1:=TrendView.BottomAxis.Maximum;
  D2:=D1+D3;
  TrendView.BottomAxis.SetMinMax(D1,D2);
  UpdateStartPoint(D2);
  for i:=1 to 8 do
  begin
    if AEdit[i].Caption <> '' then
    begin
      if ACheckBox[i].Checked then
        LoadTrendToChart(i,AEdit[i].Caption)
      else
      begin
        ASeries[i].Clear;
        LSeries[i].Clear;
      end;
    end;
  end;
  SaveConfig(PathToSave);
end;

procedure TShowTrendsForm.SaveConfig(Path: string);
var i: integer;
begin
  with RemXForm do
  begin
    Config.WriteDateTime(Path,'TrendDate',CurrentDate);
    Config.WriteInteger(Path,'TrendTime',CurrentTimeIndex);
    Config.WriteInteger(Path,'TrendIndex',CurrentEntityIndex);
    Config.WriteBool(Path,'Scrolling',cbScrolling.Checked);
    Config.WriteBool(Path,'ShowGrid',tbGrid.Down);
    for i:=1 to 8 do
    begin
      Config.WriteString(Path,'Point'+IntToStr(i),AEdit[i].Caption);
      Config.WriteBool(Path,'Check'+IntToStr(i),ACheckBox[i].Checked);
    end;
// ������ ��������� �� ����
    ConfigUpdateFile(Config);
  end;
end;

procedure TShowTrendsForm.LoadTrendToChart(Index: integer; Param: string);
var AColor: TColor; D1,D2: TDateTime;
begin
  if Trim(Param) = '' then Exit;
  if Assigned(TSeries[Index]) then TSeries[Index].Terminate;
  AColor:=AShape[Index].Brush.Color;
  if cbScrolling.Checked then
  begin
    D2:=Now;
    D1:=D2-ShiftTime;
    TrendView.BottomAxis.SetMinMax(D1,D2);
    UpdateStartPoint(D2);
  end
  else
  begin
    D2:=TrendView.BottomAxis.Maximum;
    D1:=TrendView.BottomAxis.Minimum;
  end;
  WaitLabel.Visible:=True;
  WaitLabel.Caption:='�������� ������ ��� '+Param+'...';
  WaitLabel.Update;
  Inc(TrendsCount);
  TSeries[Index]:=TGetSingleTrend.Create(Self,Caddy.CurrentTrendPath,
                                         Param,D1,D2,Index,AColor);
  TSeries[Index].OnTerminate:=TrendLoaded;
  TSeries[Index].Resume;
end;

procedure TShowTrendsForm.TrendLoaded(Sender: TObject);
var Index: integer;
begin
  Index:=(Sender as TGetSingleTrend).Index;
  LSeries[Index].Clear;
  TSeries[Index]:=nil;
  Dec(TrendsCount);
  if TrendsCount <= 0 then
    WaitLabel.Visible:=False;
end;

procedure TShowTrendsForm.CheckBox1Click(Sender: TObject);
var CB: TCheckBox; j: integer;
begin
  CB:=Sender as TCheckBox;
  CB.Hint:=IfThen(CB.Checked,'�������� �������� ������','�������� ������');
  AEdit[CB.Tag].Enabled:=CB.Checked;
  ASpeedButton[CB.Tag].Enabled:=CB.Checked;
  for j:=0 to ASeries[CB.Tag].Count-1 do
    (ASeries[CB.Tag].Items[j] as TLineSeries).Active:=CB.Checked;
  if CB.Checked then
    ReloadTrend(CB.Tag)
  else
    if Assigned(TSeries[CB.Tag]) then
      TSeries[CB.Tag].Terminate;
  SaveConfig(PathToSave);
end;

procedure TShowTrendsForm.Edit1Click(Sender: TObject);
var B: TButton;
begin
  B:=Sender as TButton;
  if Trim(B.Caption) = '' then
    NewLinkClick(B)
  else
    ChangeLinkClick(B);
end;

procedure TShowTrendsForm.NewLinkClick(Sender: TObject);
var B: TButton; List: TStringList; T,R: TEntity; Kind: Byte;
begin
  B:=Sender as TButton;
  List:=TStringList.Create;
  try
    T:=LastEntity;
    R:=Caddy.FirstEntity;
    while R <> nil do
    begin
      if R.IsTrending then
      begin
        if R.IsKontur then
        begin
          List.AddObject('PV',R);
          List.AddObject('SP',R);
          List.AddObject('OP',R);
        end
        else
        if R.IsAnalog and not R.IsParam then
          List.AddObject('PV',R);
      end;
      R:=R.NextEntity;
    end;
    Kind:=LastKind;
    if GetLinkNameDlg(Self,'�������� ��������',List,
                          TImageList(SmallImages),T,Kind) then
    begin
      LastKind:=Kind;
      LastEntity:=T as TCustomAnaOut;
      AEntity[B.Tag]:=T as TCustomAnaOut;
      if Assigned(AEntity[B.Tag]) then
      begin
        CurrentEntityIndex:=B.Tag;
        B.Caption:=AEntity[B.Tag].PtName+'.'+AParamKind[Kind];
        B.ShowHint:=True;
        B.Hint:=AEntity[B.Tag].PtDesc;
        with ACheckBox[B.Tag] do
        begin
          OnClick:=nil;
          Checked:=True;
          Enabled:=True;
          OnClick:=CheckBox1Click;
        end;
        ReloadTrends;
        ASpeedButton[B.Tag].Enabled:=True;
        ASpeedButton[B.Tag].Hint:='�����: '+Format('%g .. %g %s',
                                [AEntity[B.Tag].PVEULo,
                                 AEntity[B.Tag].PVEUHi,AEntity[B.Tag].EUDesc]);
        SaveConfig(PathToSave);
      end
      else
        DeleteLinkClick(B);
    end;
  finally
    List.Free;
  end;
end;

procedure TShowTrendsForm.ChangeLinkClick(Sender: TObject);
var B: TButton; List: TStringList; T,R: TEntity; Kind: Byte;
begin
  B:=Sender as TButton;
  List:=TStringList.Create;
  try
    T:=AEntity[B.Tag];
    R:=Caddy.FirstEntity;
    while R <> nil do
    begin
      if R.IsTrending then
      begin
        if R.IsKontur then
        begin
          List.AddObject('PV',R);
          List.AddObject('SP',R);
          List.AddObject('OP',R);
        end
        else
        if R.IsAnalog and not R.IsParam then
          List.AddObject('PV',R);
      end;
      R:=R.NextEntity;
    end;
    if Pos('.PV',B.Caption) > 0 then Kind:=0;
    if Pos('.SP',B.Caption) > 0 then Kind:=1;
    if Pos('.OP',B.Caption) > 0 then Kind:=2;
    if GetLinkNameDlg(Self,'�������� ��������',List,
                          TImageList(SmallImages),T,Kind) then
    begin
      LastKind:=Kind;
      LastEntity:=T as TCustomAnaOut;
      AEntity[B.Tag]:=T as TCustomAnaOut;
      if Assigned(AEntity[B.Tag]) then
      begin
        CurrentEntityIndex:=B.Tag;
        B.Caption:=AEntity[B.Tag].PtName+'.'+AParamKind[Kind];
        B.ShowHint:=True;
        B.Hint:=AEntity[B.Tag].PtDesc;
        with ACheckBox[B.Tag] do
        begin
          OnClick:=nil;
          Checked:=True;
          Enabled:=True;
          OnClick:=CheckBox1Click;
        end;
        ReloadTrends;
        ASpeedButton[B.Tag].Enabled:=True;
        ASpeedButton[B.Tag].Hint:='�����: '+Format('%g .. %g %s',
                                [AEntity[B.Tag].PVEULo,
                                 AEntity[B.Tag].PVEUHi,AEntity[B.Tag].EUDesc]);
        SaveConfig(PathToSave);
      end
      else
        DeleteLinkClick(B);
    end;
  finally
    List.Free;
  end;
end;

procedure TShowTrendsForm.DeleteLinkClick(Sender: TObject);
var B: TButton; i: integer;
begin
  B:=Sender as TButton;
  B.Caption:='';
  B.ShowHint:=False;
  if Assigned(TSeries[B.Tag]) then TSeries[B.Tag].Terminate;
  AEntity[B.Tag]:=nil;
  ASeries[B.Tag].Clear;
  LSeries[B.Tag].Clear;
  ASpeedButton[B.Tag].Enabled:=False;
  ASpeedButton[B.Tag].Hint:='';
  with ACheckBox[B.Tag] do
  begin
    Checked:=False;
    Enabled:=False;
  end;
  B.Enabled:=True;
  if CurrentEntityIndex = B.Tag then
  begin
    CurrentEntityIndex:=-1;
    for i:=1 to 8 do
    if AEdit[i].Caption <> '' then
    begin
      CurrentEntityIndex:=i;
      Break;
    end;
    if CurrentEntityIndex < 0 then
      TrendView.RightAxis.LabelsFont.Color:=clGray;
  end;
  SaveConfig(PathToSave);
end;

procedure TShowTrendsForm.ConnectEntity(Entity: TEntity);
begin
// Stub
end;

procedure TShowTrendsForm.ConnectImageList(ImageList: TImageList);
begin
  SmallImages:=ImageList;
end;

procedure TShowTrendsForm.UpdateRealTime;
begin
// Stub
end;

procedure TShowTrendsForm.SpeedButton1Click(Sender: TObject);
var Index: integer; AO: TCustomAnaOut; Ext: string;
begin
  with Sender as TButton do
  begin
    Index:=Tag;
    CurrentEntityIndex:=Index;
//----------------------
    TrendView.RightAxis.LabelsFont.Color:=clBlack;
    if AEdit[Index].Caption <> '' then AEdit[Index].SetFocus;
//----------------------
    Ext:=AEdit[Index].Caption;
    Ext:=Copy(Ext,Pos('.',Ext)+1,Length(Ext));
    if AEntity[Index].IsKontur then
    begin
      AO:=AEntity[Index] as TCustomAnaOut;
      if Ext = 'PV' then
      begin
        TrendView.RightAxis.SetMinMax(AO.PVEULo,AO.PVEUHi);
        TrendView.RightAxis.Title.Caption:=AO.EUDesc;
        TrendView.RightAxis.AxisValuesFormat:='#,##0.###';
      end
      else
      if Ext = 'SP' then
      begin
        TrendView.RightAxis.SetMinMax(AO.FSPEULo,AO.FSPEUHi);
        TrendView.RightAxis.Title.Caption:=AO.EUDesc;
        TrendView.RightAxis.AxisValuesFormat:='#,##0.###';
      end
      else
      begin
        TrendView.RightAxis.SetMinMax(0.0,100.0);
        TrendView.RightAxis.Title.Caption:='%';
        TrendView.RightAxis.AxisValuesFormat:='#,##0.###';
      end;
    end
    else
    begin
      AO:=AEntity[Index];
      TrendView.RightAxis.SetMinMax(AO.PVEULo,AO.PVEUHi);
      TrendView.RightAxis.Title.Caption:=AO.EUDesc;
      TrendView.RightAxis.AxisValuesFormat:='#,##0.###';
    end;
  end;
  SaveConfig(PathToSave);
end;

procedure TShowTrendsForm.tbZoomInClick(Sender: TObject);
begin
  TrendView.ZoomPercent(110);  { Zoom IN 110% }
  tbZoomReset.Enabled := True;
end;

procedure TShowTrendsForm.tbZoomOutClick(Sender: TObject);
begin
  TrendView.ZoomPercent(90);   { Zoom OUT 90% }
  tbZoomReset.Enabled := True;
end;

procedure TShowTrendsForm.tbZoomResetClick(Sender: TObject);
begin
  TrendView.UndoZoom;
  tbZoomReset.Enabled := False;
  tbTime0Click(TimePopupMenu.Items[CurrentTimeIndex]);
end;

procedure TShowTrendsForm.TrendViewAfterDraw(Sender: TObject);
begin
  OldX:=-1; { Reset old mouse position }
end;

procedure TShowTrendsForm.TrendViewScroll(Sender: TObject);
begin
  FScrollFlag:=True;
end;

procedure TShowTrendsForm.TrendViewUndoZoom(Sender: TObject);
begin
  tbZoomReset.Enabled:=False;
  CurrentDate:=TrendView.BottomAxis.Maximum;
  UpdateStartPoint(CurrentDate);
end;

procedure TShowTrendsForm.TrendViewZoom(Sender: TObject);
begin
  tbZoomReset.Enabled:=True;
  CurrentDate:=TrendView.BottomAxis.Maximum;
  UpdateStartPoint(CurrentDate);
end;

procedure TShowTrendsForm.TrendViewMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
  { This procedure draws the crosshair lines }
  Procedure DrawCross(AX,AY:Integer);
  begin
    With TrendView, Canvas do
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
var i,j,n,k: integer; tmpX, tmpY, X1, X2: Double; Found: boolean;
begin
  if (OldX <> -1) then
  begin
    DrawCross(OldX,OldY); { draw old crosshair }
    OldX := -1;
  end;
    { check if mouse is inside TrendView rectangle }
  ShiftFlag:=(ssShift in Shift);
  if ssShift in Shift then  // ���� ������ ������� < Shift >
  begin
    if PtInRect(TrendView.ChartRect, Point(X-TrendView.Width3D,
                 Y+TrendView.Height3D)) then
    begin
      DrawCross(x,y); { draw crosshair at current position }
      { store old position }
      OldX:=x;
      OldY:=y;
      for i:=1 to 8 do
      for k:=0 to ASeries[i].Count-1 do
      begin
        with ASeries[i].Items[k] as TLineSeries do
        if Count > 0 then
        begin
          GetCursorValues(tmpX,tmpY); { <-- get values under mouse cursor }
          X1:=TrendView.BottomAxis.Minimum;
          X2:=TrendView.BottomAxis.Maximum;
          n:=0;
          Found:=False;
          for j:=0 to Count-1 do
          if InRange(XValue[j],X1,X2) and (tmpX <= XValue[j]) then
          begin
            n := j;
            Found:=True;
            Break;
          end;
          tmpY:=YValue[n];
          with AEdit[i] do
          if (ValueColor[n] = clWhite) or
             not InRange(tmpX,XValue[0],XValue[Count-1]) then
            Caption:='------'
          else
          begin
            if Pos('.OP',SEntity[i])>0 then
              Caption:=Format('%.2f %s',[tmpY,'%'])
            else
              Caption:=Format('%.2f %s',[tmpY,AEntity[i].EUDesc]);
          end;
          if Found then Break;
        end;
      end;
      if Assigned(Panel.TopForm) and (Panel.TopForm = Self) then
      with RemXForm do ShowMessage:=FormatDateTime('dd/mm/yyyy ddd hh:nn:ss',tmpX);
    end;
  end;
end;

procedure TShowTrendsForm.SetShiftFlag(const Value: boolean);
var i: integer;
begin
  if FShiftFlag <> Value then
  begin
    FShiftFlag := Value;
    if FShiftFlag then
    begin
      for i:=1 to 8 do SEntity[i]:=AEdit[i].Caption;
    end
    else
    begin
      for i:=1 to 8 do AEdit[i].Caption:=SEntity[i];
      if Assigned(Panel.TopForm) and (Panel.TopForm = Self) then
        with RemXForm do ShowMessage:='';
      PostMessage(Handle,WM_ShiftRemove,0,0);
    end;
  end;
end;

procedure TShowTrendsForm.tbPrintingClick(Sender: TObject);
var i,k: integer; ColorToSave: TColor;
begin
  PrintDialogForm:=TPrintDialogForm.Create(Self);
  try
    Screen.Cursor:=crHourGlass;
    try
      frTrendReport.LoadFromResourceName(HInstance,'TrendReport');
      frTrendReport.Title:='������ ���������� ��������';
      with TrendView do
      begin
        Color:=clWhite;
        ColorToSave:=RightAxis.LabelsFont.Color;
        RightAxis.LabelsFont.Color:=clBlack;
      end;
      frVariables.Variable['TrendTitle']:='������� ���������� ��������';
      frVariables.Variable['PrintDate']:=
                        FormatDateTime('����������: d.mm.yyyy h:nn:ss',(Now));
      frVariables.Variable['PrintPeriod']:='����� �������: � '+
                FormatDateTime('d.mm.yyyy h:nn:ss',(TrendView.BottomAxis.Minimum))+
         ' �� '+FormatDateTime('d.mm.yyyy h:nn:ss',(TrendView.BottomAxis.Maximum));
      frVariables.Variable['ObjectName']:=Config.ReadString('General',
                                          'ObjectName','');
      for i:=1 to 8 do
      begin
        if (AEdit[i].Caption <> '') and ACheckBox[i].Checked then
        begin
          (CurPage.FindObject('Line'+IntToStr(i)) as TfrLineView).FrameColor:=
                AShape[i].Brush.Color;
          frVariables.Variable['Series'+IntToStr(i)]:=AEdit[i].Caption;
        end
        else
        begin
          (CurPage.FindObject('Line'+IntToStr(i)) as TfrLineView).FrameColor:=clWhite;
          frVariables.Variable['Series'+IntToStr(i)]:='';
        end;
        if Config.ReadInteger('General','PrintColor',0) = 0 then
        begin  // ����� �����
          for k:=0 to ASeries[i].Count-1 do
          with (CurPage.FindObject('Line'+IntToStr(i)) as TfrLineView),
               (ASeries[i].Items[k] as TLineSeries) do
          begin
            ColorEachPoint:=False;
            SeriesColor:=clBlack;
            if AEdit[i].Caption <> '' then
              FrameColor:=clBlack
            else
              FrameColor:=clWhite;
            case i of
              1: begin FrameStyle := 0; LinePen.Style:=psSolid; end;
              2: begin FrameStyle := 1; LinePen.Style:=psDash; end;
              3: begin FrameStyle := 2; LinePen.Style:=psDot; end;
              4: begin FrameStyle := 3; LinePen.Style:=psDashDot; end;
              5: begin FrameStyle := 4; LinePen.Style:=psDashDotDot; end;
              6: begin FrameStyle := 0; LinePen.Style:=psSolid; end;
              7: begin FrameStyle := 1; LinePen.Style:=psDash; end;
              8: begin FrameStyle := 2; LinePen.Style:=psDot; end;
            end;
          end;
        end;
      end;
      with CurPage.FindObject('ChartPicture') as TfrPictureView do
      begin
        if Config.ReadInteger('General','PrintColor',0) = 0 then
        begin
          TrendView.SaveToBitmapFile('temp.bmp');
          Picture.LoadFromFile('temp.bmp');
          DeleteFile('temp.bmp');
        end
        else
        begin
          TrendView.SaveToMetafileEnh('temp.emf');
          Picture.LoadFromFile('temp.emf');
          DeleteFile('temp.emf');
        end;
      end;
      with TrendView do
      begin
        Color:=clBtnFace;
        if Config.ReadInteger('General','PrintColor',0) = 0 then
        begin  // ����� �����
          with CurPage.FindObject('TrendTitleMemo') as TfrMemoView do
          begin
            FillColor:=clSilver;
            Font.Color:=clBlack;
          end;
          RightAxis.LabelsFont.Color:=ColorToSave;
          for i:=1 to 8 do
          begin
            for k:=0 to ASeries[i].Count-1 do
            with ASeries[i].Items[k] as TLineSeries do
            begin
              LinePen.Style:=psSolid;
              ColorEachPoint:=False;
              SeriesColor:=AShape[i].Brush.Color;
            end;
          end;
        end;
      end;
      if frTrendReport.PrepareReport then
      begin
        if Sender = tbPrinting then
        begin
          PrintDialogForm.FromPage:=1;
          PrintDialogForm.ToPage:=1;
          if PrintDialogForm.Execute then
          begin
            RemXForm.SaveReportToReportsLog(frTrendReport,True,'�������');
            if PrintDialogForm.PrintRange = prAllPages then
              frTrendReport.PrintPreparedReport('',PrintDialogForm.Copies,
                                              PrintDialogForm.Collate,frAll)
            else
              if PrintDialogForm.PrintRange = prPageNums then
                frTrendReport.PrintPreparedReport(Format('%d-%d',
                             [PrintDialogForm.FromPage,PrintDialogForm.ToPage]),
                          PrintDialogForm.Copies,PrintDialogForm.Collate,frAll);
          end;
        end;
        if Sender = tbPreview then
        begin
          Panel.acPreview.Execute;
          Panel.ShowPreviewForm.MasterAction:=Panel.actTrends;
          frTrendReport.Preview:=Panel.ShowPreviewForm.frAllPreview;
          frTrendReport.ShowPreparedReport;
          Panel.ShowPreviewForm.Show;
        end;
      end;
    finally
      Screen.Cursor:=crDefault;
    end;
  finally
    PrintDialogForm.Free;
  end;
end;

procedure TShowTrendsForm.ShiftRemove(var Mess: TMessage);
begin
  ReloadTrends;
end;

procedure TShowTrendsForm.FormDestroy(Sender: TObject);
var i: integer;
begin
  for i:=1 to 8 do
  begin
    ASeries[i].Free;
    LSeries[i].Free;
  end;  
end;

procedure TShowTrendsForm.cbScrollingClick(Sender: TObject);
begin
  if cbScrolling.Checked then ReloadTrends;
  SaveConfig(PathToSave);
end;

procedure TShowTrendsForm.FormResize(Sender: TObject);
var i: integer;
begin
  Panel1.Left:=0;   Panel1.Width:=256;
  Panel2.Left:=0;   Panel2.Width:=256;
  Panel3.Left:=256; Panel3.Width:=256;
  Panel4.Left:=256; Panel4.Width:=256;
  Panel5.Left:=512; Panel5.Width:=256;
  Panel6.Left:=512; Panel6.Width:=256;
  Panel7.Left:=768; Panel7.Width:=256;
  Panel8.Left:=768; Panel8.Width:=256;
  Bevel1.Left:=252;
  Bevel2.Left:=252;
  Bevel3.Left:=252;
  Bevel4.Left:=252;
  Bevel5.Left:=252;
  Bevel6.Left:=252;
  for i:=1 to 8 do
  begin
    ACheckBox[i].Left:=27;
    AShape[i].Left:=59;
    AEdit[i].Left:=80;
    ASpeedButton[i].Left:=202;
  end;
end;

procedure TShowTrendsForm.tbGridClick(Sender: TObject);
begin
  TrendView.RightAxis.Grid.Visible:=tbGrid.Down;
  TrendView.BottomAxis.Grid.Visible:=tbGrid.Down;
  SaveConfig(PathToSave);
end;

procedure InitCriticalSections;
var i: integer;
begin
  for i:=1 to 8 do GetSingleTrendSection[i]:=TCriticalSection.Create;
end;

procedure FinitCriticalSections;
var i: integer;
begin
  for i:=1 to 8 do GetSingleTrendSection[i].Free;
end;

procedure TShowTrendsForm.pmEntityButtonClickPopup(Sender: TObject);
begin
  miBase.Visible:=Caddy.UserLevel >= 5;
end;

procedure TShowTrendsForm.miPassportClick(Sender: TObject);
var i: integer;
begin
  i:=(pmEntityButtonClick.PopupComponent as TButton).Tag;
  if (i in [1..8]) and Assigned(AEntity[i]) then
    AEntity[i].ShowPassport(Monitor.MonitorNum);
end;

procedure TShowTrendsForm.miBaseClick(Sender: TObject);
var i: integer;
begin
  i:=(pmEntityButtonClick.PopupComponent as TButton).Tag;
  if (i in [1..8]) and Assigned(AEntity[i]) then
    AEntity[i].ShowEditor(Monitor.MonitorNum);
end;

procedure TShowTrendsForm.TrendViewMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if FScrollFlag then
  begin
    FScrollFlag:=False;
    tbZoomReset.Enabled:=True;
    CurrentDate:=TrendView.BottomAxis.Maximum;
    UpdateStartPoint(CurrentDate);
  end;
end;

procedure TShowTrendsForm.DateTimeAreaClick(Sender: TObject);
var Result: TModalResult; i: integer;
begin
  TimeFilterForm:=TTimeFilterForm.Create(Self);
  try
    with RemXForm,TimeFilterForm do
    begin
      FirstSnap:=TrendView.BottomAxis.Minimum;
      LastSnap:=TrendView.BottomAxis.Maximum;
      dtBeginDate.DateTime:=Int(FirstSnap);
      dtBeginTime.DateTime:=Frac(FirstSnap);
      dtEndDate.DateTime:=Int(LastSnap);
      dtEndTime.DateTime:=Frac(LastSnap);
      DeleteFilterButton.Visible:=False;
      GroupBox1.Visible:=False;
      Result:=ShowModal;
      if Result = mrOk then
      begin
        FirstSnap:=Int(dtBeginDate.DateTime)+Frac(dtBeginTime.DateTime);
        LastSnap:=Int(dtEndDate.DateTime)+Frac(dtEndTime.DateTime);
        StartTime:=LastSnap;
        ShiftTime:=LastSnap-FirstSnap;
        cbScrolling.OnClick:=nil;
        try
          cbScrolling.Checked:=False;
        finally
          cbScrolling.OnClick:=cbScrollingClick;
        end;
        TrendView.BottomAxis.SetMinMax(FirstSnap,LastSnap);
        UpdateStartPoint(StartTime);
        for i:=1 to 8 do
        begin
          if AEdit[i].Caption <> '' then
          begin
            if ACheckBox[i].Checked then
              LoadTrendToChart(i,AEdit[i].Caption)
            else
            begin
              ASeries[i].Clear;
              LSeries[i].Clear;
            end;
          end;
        end;
        SaveConfig(PathToSave);
      end
      else
        Exit;
    end;
  finally
    TimeFilterForm.Free;
  end;
end;

initialization
  InitCriticalSections;

finalization
  FinitCriticalSections;

end.
