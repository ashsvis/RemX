unit TimeFilterUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, ExtCtrls, AppEvnts;

type
  TTimeFilterForm = class(TForm)
    dtBeginDate: TDateTimePicker;
    dtBeginTime: TDateTimePicker;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    sbSetAsEndDate: TSpeedButton;
    sbFirstDateLess: TSpeedButton;
    dtEndDate: TDateTimePicker;
    dtEndTime: TDateTimePicker;
    Label2: TLabel;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    sbSetAsBeginDate: TSpeedButton;
    sbEndDateMore: TSpeedButton;
    GroupBox1: TGroupBox;
    OkButton: TButton;
    CancelButton: TButton;
    sbFromBeginMonth: TSpeedButton;
    sbFromBeginDay: TSpeedButton;
    sbLastDay: TSpeedButton;
    sbLastEtc: TSpeedButton;
    stBeginDateDayName: TStaticText;
    stEndDateDayName: TStaticText;
    Bevel1: TBevel;
    ApplicationEvents: TApplicationEvents;
    DeleteFilterButton: TButton;
    procedure sbFromBeginMonthClick(Sender: TObject);
    procedure sbLastDayClick(Sender: TObject);
    procedure sbFromBeginDayClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure sbSetAsEndDateClick(Sender: TObject);
    procedure sbSetAsBeginDateClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
    procedure sbFirstDateLessClick(Sender: TObject);
    procedure sbEndDateMoreClick(Sender: TObject);
    procedure sbLastEtcClick(Sender: TObject);
  private
  public
    ResultBeginData,ResultEndData: TDateTime;
  end;

var
  TimeFilterForm: TTimeFilterForm;

implementation

uses DateUtils, ExtTimeFilterUnit, RemXUnit;

{$R *.dfm}

procedure TTimeFilterForm.sbFromBeginMonthClick(Sender: TObject);
begin
  dtBeginDate.DateTime:=StartOfTheMonth(Now);
  dtBeginTime.DateTime:=StartOfTheMonth(Now);
  dtEndDate.DateTime:=Now;
  dtEndTime.DateTime:=Now;
end;

procedure TTimeFilterForm.sbLastDayClick(Sender: TObject);
begin
  dtBeginDate.DateTime:=StartOfTheDay(Yesterday);
  dtBeginTime.DateTime:=StartOfTheDay(Yesterday);
  dtEndDate.DateTime:=EndOfTheDay(Yesterday);
  dtEndTime.DateTime:=EndOfTheDay(Yesterday);
end;

procedure TTimeFilterForm.sbFromBeginDayClick(Sender: TObject);
begin
  dtBeginDate.DateTime:=StartOfTheDay(Now);
  dtBeginTime.DateTime:=StartOfTheDay(Now);
  dtEndDate.DateTime:=Now;
  dtEndTime.DateTime:=Now;
end;

procedure TTimeFilterForm.SpeedButton1Click(Sender: TObject);
begin
  dtBeginDate.DateTime:=StartOfTheDay(Yesterday);
  dtBeginTime.DateTime:=StartOfTheDay(Yesterday);
end;

procedure TTimeFilterForm.SpeedButton2Click(Sender: TObject);
begin
  dtBeginDate.DateTime:=StartOfTheDay(Today);
  dtBeginTime.DateTime:=StartOfTheDay(Today);
end;

procedure TTimeFilterForm.SpeedButton3Click(Sender: TObject);
begin
  dtBeginDate.DateTime:=StartOfTheDay(Tomorrow);
  dtBeginTime.DateTime:=StartOfTheDay(Tomorrow);
end;

procedure TTimeFilterForm.SpeedButton6Click(Sender: TObject);
begin
  dtEndDate.DateTime:=StartOfTheDay(Yesterday);
  dtEndTime.DateTime:=EndOfTheDay(Yesterday);
end;

procedure TTimeFilterForm.SpeedButton7Click(Sender: TObject);
begin
  dtEndDate.DateTime:=StartOfTheDay(Today);
  dtEndTime.DateTime:=EndOfTheDay(Today);
end;

procedure TTimeFilterForm.SpeedButton8Click(Sender: TObject);
begin
  dtEndDate.DateTime:=StartOfTheDay(Tomorrow);
  dtEndTime.DateTime:=EndOfTheDay(Tomorrow);
end;

procedure TTimeFilterForm.sbSetAsEndDateClick(Sender: TObject);
begin
  dtBeginDate.DateTime:=dtEndDate.DateTime;
  dtBeginTime.DateTime:=dtEndTime.DateTime;
end;

procedure TTimeFilterForm.sbSetAsBeginDateClick(Sender: TObject);
begin
  dtEndDate.DateTime:=dtBeginDate.DateTime;
  dtEndTime.DateTime:=dtBeginTime.DateTime;
end;

procedure TTimeFilterForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if ModalResult = mrOk then
  begin
    ResultBeginData:=Int(dtBeginDate.DateTime)+Frac(dtBeginTime.DateTime);
    ResultEndData:=Int(dtEndDate.DateTime)+Frac(dtEndTime.DateTime);
    if ResultBeginData > ResultEndData then
    begin
      RemxForm.ShowWarning('Ошибка! Начальная дата больше конечной!');
      CanClose:=False;
    end
    else
    begin
      if not DeleteFilterButton.Visible and
        (ResultEndData - ResultBeginData > 1.0) then
      begin
        RemxForm.ShowWarning('Ошибка! Задан диапазон больше суток!');
        CanClose:=False;
      end
      else
        CanClose:=True;
    end;
  end
  else
    CanClose:=True;
end;

procedure TTimeFilterForm.ApplicationEventsIdle(Sender: TObject;
  var Done: Boolean);
begin
  stBeginDateDayName.Caption:=FormatDateTime('dddd',dtBeginDate.DateTime);
  stEndDateDayName.Caption:=FormatDateTime('dddd',dtEndDate.DateTime);
end;

procedure TTimeFilterForm.sbFirstDateLessClick(Sender: TObject);
var i: integer; D: TDateTime;
begin
  ExtTimeFilterForm:=TExtTimeFilterForm.Create(Self);
  with ExtTimeFilterForm do
  begin
    try
      Caption:='Начальная дата меньше конечной на...';
      cbWithCurrent.Visible:=False;
      for i:=0 to ControlCount-1 do
      if Controls[i] is TSpeedButton then
        with Controls[i] as TSpeedButton do
        if Caption[Length(Caption)] in ['с','ц','д'] then
          Caption:='На 1 '+Caption
        else
          Caption:='На '+Caption;
      if ShowModal = mrOk then
      begin
        D:=Int(dtEndDate.DateTime)+Frac(dtEndTime.DateTime);
        case TimeBaseListBox.ItemIndex of
          0: D:=IncHour(D,-StrToInt(MaskEdit1.Text));
          1: D:=IncDay(D,-StrToInt(MaskEdit1.Text));
          2: D:=IncMonth(D,-StrToInt(MaskEdit1.Text));
        else
          D:=IncYear(D,-StrToInt(MaskEdit1.Text));
        end;
        dtBeginDate.DateTime:=D;
        dtBeginTime.DateTime:=D;
      end;
    finally
      Free;
    end;
  end;
end;

procedure TTimeFilterForm.sbEndDateMoreClick(Sender: TObject);
var i: integer; D: TDateTime;
begin
  ExtTimeFilterForm:=TExtTimeFilterForm.Create(Self);
  with ExtTimeFilterForm do
  begin
    try
      Caption:='Конечная дата больше начальной на...';
      cbWithCurrent.Visible:=False;
      for i:=0 to ControlCount-1 do
      if Controls[i] is TSpeedButton then
        with Controls[i] as TSpeedButton do
        if Caption[Length(Caption)] in ['с','ц','д'] then
          Caption:='На 1 '+Caption
        else
          Caption:='На '+Caption;
      if ShowModal = mrOk then
      begin
        D:=Int(dtBeginDate.DateTime)+Frac(dtBeginTime.DateTime);
        case TimeBaseListBox.ItemIndex of
          0: D:=IncHour(D,StrToInt(MaskEdit1.Text));
          1: D:=IncDay(D,StrToInt(MaskEdit1.Text));
          2: D:=IncMonth(D,StrToInt(MaskEdit1.Text));
        else
          D:=IncYear(D,StrToInt(MaskEdit1.Text));
        end;
        dtEndDate.DateTime:=D;
        dtEndTime.DateTime:=D;
      end;
    finally
      Free;
    end;
  end;
end;

procedure TTimeFilterForm.sbLastEtcClick(Sender: TObject);
var i: integer; D: TDateTime;
begin
  ExtTimeFilterForm:=TExtTimeFilterForm.Create(Self);
  with ExtTimeFilterForm do
  begin
    try
      Caption:='Установить расчетный период за последние...';
      for i:=0 to ControlCount-1 do
      if Controls[i] is TSpeedButton then
        with Controls[i] as TSpeedButton do
        if Caption[Length(Caption)] in ['с','ц','д'] then
          Caption:='За последний '+Caption
        else
          Caption:='За последние '+Caption;
      if ShowModal = mrOk then
      begin
        if cbWithCurrent.Checked then
          D:=Now
        else
          D:=EndOfTheDay(Yesterday);
        dtEndDate.DateTime:=D;
        dtEndTime.DateTime:=D;
        case TimeBaseListBox.ItemIndex of
          0: D:=IncHour(D,-StrToInt(MaskEdit1.Text));
          1: D:=IncDay(D,-StrToInt(MaskEdit1.Text));
          2: D:=IncMonth(D,-StrToInt(MaskEdit1.Text));
        else
          D:=IncYear(D,-StrToInt(MaskEdit1.Text));
        end;
        if TimeBaseListBox.ItemIndex > 0 then D:=Int(D);
        dtBeginDate.DateTime:=D;
        dtBeginTime.DateTime:=D;
      end;
    finally
      Free;
    end;
  end;
end;

end.
