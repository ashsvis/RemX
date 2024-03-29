unit ShowReportUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, ToolWin, ActnList, ImgList, Grids,
  IniFiles, FR_Class, EntityUnit, AppEvnts, PanelFormUnit;

type
  TShowReportsForm = class(TForm)
    ToolBar1: TToolBar;
    tbNew: TToolButton;
    tbChange: TToolButton;
    tbDelete: TToolButton;
    ToolButton1: TToolButton;
    tbPreview: TToolButton;
    tbPrint: TToolButton;
    ActionList1: TActionList;
    ImageList: TImageList;
    actChangeRtmReport: TAction;
    actDeleteRtmReport: TAction;
    actPreviewRtmReport: TAction;
    actPrintRtmReport: TAction;
    ToolButton3: TToolButton;
    ToolButton6: TToolButton;
    ToolButton8: TToolButton;
    DrawGrid: TDrawGrid;
    actNewRtmReport: TAction;
    actUp: TAction;
    actDown: TAction;
    frReportView: TfrReport;
    procedure FormResize(Sender: TObject);
    procedure DrawGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure actNewRtmReportExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actChangeRtmReportExecute(Sender: TObject);
    procedure actChangeRtmReportUpdate(Sender: TObject);
    procedure actDeleteRtmReportExecute(Sender: TObject);
    procedure actDeleteRtmReportUpdate(Sender: TObject);
    procedure DrawGridDblClick(Sender: TObject);
    procedure actUpExecute(Sender: TObject);
    procedure actUpUpdate(Sender: TObject);
    procedure actDownExecute(Sender: TObject);
    procedure actDownUpdate(Sender: TObject);
    procedure DrawGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure actNewRtmReportUpdate(Sender: TObject);
    procedure actPreviewRtmReportExecute(Sender: TObject);
    procedure actPreviewRtmReportUpdate(Sender: TObject);
    procedure actPrintRtmReportExecute(Sender: TObject);
    procedure actPrintRtmReportUpdate(Sender: TObject);
  private
    RunTimeReports: TMemIniFile;
    FPanel: TPanelForm;
    procedure SaveWatchList;
  public
    property Panel: TPanelForm read FPanel write FPanel;
  end;

var
  ShowReportsForm: TShowReportsForm;

procedure SaveToFile(RunTimeReports: TMemIniFile; CurrentBasePath: string);
implementation

uses GetRtmRepRecordUnit, CRCCalcUnit, StrUtils,
     Printers, RemXUnit, PrintDialogUnit;

{$R *.dfm}

procedure TShowReportsForm.FormResize(Sender: TObject);
var i,sum: integer;
begin
  DrawGrid.DefaultRowHeight:=24;
  DrawGrid.Font.Size:=12;
  DrawGrid.ColWidths[0]:=100;
  DrawGrid.ColWidths[1]:=130;
  DrawGrid.ColWidths[2]:=130;
  DrawGrid.ColWidths[3]:=130;
  sum:=0; for i:=0 to 3 do sum:=sum+DrawGrid.ColWidths[i];
  DrawGrid.ColWidths[4]:=DrawGrid.Width-sum-GetSystemMetrics(SM_CXVSCROLL)-8;
end;

procedure TShowReportsForm.DrawGridDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var S: string;
begin
  InflateRect(Rect,-4,0);
  with DrawGrid.Canvas do
  begin
    if ARow = 0 then
    begin
      case ACol of
        0: S:='��/�';
        1: S:='�����';
        2: S:='������';
        3: S:='������';
        4: S:='�������� ����������� ������';
      else
        S:='';
      end;
      if ACol = 4 then
        DrawText(Handle,PChar(S),Length(S),Rect,DT_LEFT+DT_VCENTER+DT_SINGLELINE)
      else
        DrawText(Handle,PChar(S),Length(S),Rect,DT_CENTER+DT_VCENTER+DT_SINGLELINE);
    end
    else
    if RemXForm.WatchList.Length > 0 then
    begin
      case ACol of
        0: S:=Format('%d',[ARow]);
        1: S:=IfThen(RemXForm.WatchList.Body[ARow].HandStart,'������','����');
        2: S:=FormatDateTime('hh:nn',RemXForm.WatchList.Body[ARow].StartTime);
        3: S:=FormatDateTime('hh:nn',RemXForm.WatchList.Body[ARow].ShiftTime);
        4: S:=RemXForm.WatchList.Body[ARow].Descriptor;
      else
        S:='';
      end;
      if ACol = 4 then
        DrawText(Handle,PChar(S),Length(S),Rect,DT_LEFT+DT_VCENTER+DT_SINGLELINE)
      else
        DrawText(Handle,PChar(S),Length(S),Rect,DT_CENTER+DT_VCENTER+DT_SINGLELINE);
    end;
  end;
end;

procedure TShowReportsForm.actNewRtmReportExecute(Sender: TObject);
var T1,T2: TDateTime; R: TWatchRecord;
begin
  GetRtmRepRecordForm:=TGetRtmRepRecordForm.Create(Self);
  with GetRtmRepRecordForm do
  try
    repeat
      if ShowModal = mrOk then
      begin
        if not FileExists(IncludeTrailingPathDelimiter(Caddy.CurrentReportsPath)+
                          Trim(cbFileName.Text)) then
        begin
          RemXForm.ShowError('��������� ���� �� ����������!');
          ActiveControl:=cbFileName;
          Continue;
        end;
        if not (Trim(edDescriptor.Text) <> '') then
        begin
          RemXForm.ShowError('�������� ������ �� ���������!');
          ActiveControl:=edDescriptor;
          Continue;
        end;
        if not TryStrToTime(edStartTime.Text,T1) then
        begin
          RemXForm.ShowError('����� ������ ������ ������ ������� �� �����!');
          ActiveControl:=edStartTime;
          Continue;
        end;
        if not TryStrToTime(edPrintPeriod.Text,T2) then
        begin
          RemXForm.ShowError('����� ������� ������ ������ ������� �� �����!');
          ActiveControl:=edPrintPeriod;
          Continue;
        end;
        R.FileName:=cbFileName.Text;
        R.StartTime:=StrToTime(edStartTime.Text);
        R.ShiftTime:=StrToTime(edPrintPeriod.Text);
        R.Descriptor:=edDescriptor.Text;
        R.HandStart:=cbHandRun.Checked;
        with RemXForm do
        begin
          if WatchList.Length < High(WatchList.Body) then
          begin
            Inc(WatchList.Length);
            WatchList.Body[WatchList.Length]:=R;
            SaveWatchList;
            FillWatchList;
            if WatchList.Length > 0 then
              DrawGrid.RowCount:=WatchList.Length+1
            else
              DrawGrid.RowCount:=2;
            DrawGrid.Invalidate;
          end;
        end;
        Break;
      end
      else
        Break;
    until False;
  finally
    Free;
  end;
end;

procedure TShowReportsForm.SaveWatchList;
var i: integer; SectName: string;
begin
  RunTimeReports.Clear;
  with RemXForm do
  for i:=1 to WatchList.Length do
  begin
    SectName:=Format('PrintReport%d',[i]);
    RunTimeReports.WriteString(SectName,'FileName',WatchList.Body[i].FileName);
    RunTimeReports.WriteTime(SectName,'StartTime',WatchList.Body[i].StartTime);
    RunTimeReports.WriteTime(SectName,'ShiftTime',WatchList.Body[i].ShiftTime);
    RunTimeReports.WriteString(SectName,'Descriptor',WatchList.Body[i].Descriptor);
    RunTimeReports.WriteBool(SectName,'HandStart',WatchList.Body[i].HandStart);
  end;
  SaveToFile(RunTimeReports,Caddy.CurrentBasePath);
end;

procedure TShowReportsForm.FormCreate(Sender: TObject);
begin
  RunTimeReports:=TMemIniFile.Create('');
  with RemXForm do
  begin
    if WatchList.Length > 0 then
      DrawGrid.RowCount:=WatchList.Length+1
    else
      DrawGrid.RowCount:=2;
    frReportView.OnBeginDoc:=FastReportBeginDoc;
  end;
end;

procedure TShowReportsForm.FormDestroy(Sender: TObject);
begin
  RunTimeReports.Free;
end;

procedure SaveToFile(RunTimeReports: TMemIniFile; CurrentBasePath: string);
var List: TStringList; AF,M: TMemoryStream; CRC32: Cardinal;
    PtClass,FileName,BackName: string; F: TFileStream;
begin
  Screen.Cursor:=crHourGlass;
  try
    M:=TMemoryStream.Create;
    AF:=TMemoryStream.Create;
    List:=TStringList.Create;
    try
      RunTimeReports.GetStrings(List);
      List.SaveToStream(AF);
      if AF.Size > 0 then
      begin
        AF.Position:=0;
        M.Clear;
        CompressStream(AF,M);
        M.Position:=0;
      end
      else
        M.Clear;
      CRC32:=0;
      CalcCRC32(M.Memory,M.Size,CRC32);
      PtClass:=IncludeTrailingPathDelimiter(CurrentBasePath)+'RTMRPRTS.CFG';
      FileName:=PtClass;
      BackName:=ChangeFileExt(FileName,'.~CFG');
      if FileExists(BackName) and DeleteFile(BackName) or
         not FileExists(BackName) then
      begin
        if FileExists(FileName) and RenameFile(FileName,BackName) or
           not FileExists(FileName) then
        begin
          if M.Size = 0 then
          begin
            if FileExists(PtClass) then DeleteFile(PtClass);
          end
          else
          if ForceDirectories(CurrentBasePath) then
          begin
            try
              F:=TFileStream.Create(PtClass,fmCreate or fmShareExclusive);
            except
              RemXForm.ShowWarning('���� "'+ExtractFileName(PtClass)+
                      '" ����� ������ ���������. ���������� ��� ���.');
              Exit;
            end;
            try
              F.WriteBuffer(CRC32,SizeOf(CRC32));
              M.SaveToStream(F);
            finally
              F.Free;
            end;
          end;
        end;
      end;
    finally
      AF.Free;
      M.Free;
      List.Free;
    end;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TShowReportsForm.actChangeRtmReportExecute(Sender: TObject);
var T1,T2: TDateTime; R: TWatchRecord;
begin
  GetRtmRepRecordForm:=TGetRtmRepRecordForm.Create(Self);
  with GetRtmRepRecordForm do
  try
    R:=RemXForm.WatchList.Body[DrawGrid.Row];
    cbFileName.Text:=R.FileName;
    edStartTime.Text:=FormatDateTime('hh:nn',R.StartTime);
    edPrintPeriod.Text:=FormatDateTime('hh:nn',R.ShiftTime);
    edDescriptor.Text:=R.Descriptor;
    cbHandRun.Checked:=R.HandStart;
    repeat
      if ShowModal = mrOk then
      begin
        if not FileExists(IncludeTrailingPathDelimiter(Caddy.CurrentReportsPath)+
                          Trim(cbFileName.Text)) then
        begin
          RemXForm.ShowError('��������� ���� �� ����������!');
          ActiveControl:=cbFileName;
          Continue;
        end;
        if not (Trim(edDescriptor.Text) <> '') then
        begin
          RemXForm.ShowError('�������� ������ �� ���������!');
          ActiveControl:=edDescriptor;
          Continue;
        end;
        if not TryStrToTime(edStartTime.Text,T1) then
        begin
          RemXForm.ShowError('����� ������ ������ ������ ������� �� �����!');
          ActiveControl:=edStartTime;
          Continue;
        end;
        if not TryStrToTime(edPrintPeriod.Text,T2) then
        begin
          RemXForm.ShowError('����� ������� ������ ������ ������� �� �����!');
          ActiveControl:=edPrintPeriod;
          Continue;
        end;
        R.FileName:=cbFileName.Text;
        R.StartTime:=StrToTime(edStartTime.Text);
        R.ShiftTime:=StrToTime(edPrintPeriod.Text);
        R.Descriptor:=edDescriptor.Text;
        R.HandStart:=cbHandRun.Checked;
        with RemXForm do
        begin
          WatchList.Body[DrawGrid.Row]:=R;
          SaveWatchList;
          FillWatchList;
          if WatchList.Length > 0 then
            DrawGrid.RowCount:=WatchList.Length+1
          else
            DrawGrid.RowCount:=2;
          DrawGrid.Invalidate;
        end;
        Break;
      end
      else
        Break;
    until False;
  finally
    Free;
  end;
end;

procedure TShowReportsForm.actChangeRtmReportUpdate(Sender: TObject);
begin
  actChangeRtmReport.Enabled:=(Caddy.UserLevel >= 4) and
                              (RemXForm.WatchList.Length > 0);
end;

procedure TShowReportsForm.actDeleteRtmReportExecute(Sender: TObject);
var i,j: integer;
begin
  if RemxForm.ShowQuestion('������� ������� ������?')=mrOk then
  begin
    with RemXForm do
    begin
      j:=DrawGrid.Row-1;
      for i:=j to WatchList.Length-2 do WatchList.Body[i+1]:=WatchList.Body[i+2];
      Dec(WatchList.Length);
      SaveWatchList;
      FillWatchList;
      if WatchList.Length > 0 then
        DrawGrid.RowCount:=WatchList.Length+1
      else
        DrawGrid.RowCount:=2;
      DrawGrid.Invalidate;
    end;
  end;
end;

procedure TShowReportsForm.actDeleteRtmReportUpdate(Sender: TObject);
begin
  actDeleteRtmReport.Enabled:=(Caddy.UserLevel >= 4) and
                              (RemXForm.WatchList.Length > 0);
end;

procedure TShowReportsForm.DrawGridDblClick(Sender: TObject);
begin
  if actChangeRtmReport.Enabled then actChangeRtmReport.Execute;
end;

procedure TShowReportsForm.actUpExecute(Sender: TObject);
var R: TWatchRecord; i: integer;
begin
  i:=DrawGrid.Row;
  with RemXForm do
  begin
    R:=WatchList.Body[i];
    WatchList.Body[i]:=WatchList.Body[i-1];
    WatchList.Body[i-1]:=R;
  end;
  DrawGrid.Row:=DrawGrid.Row-1;
  SaveWatchList;
  RemXForm.FillWatchList;
  DrawGrid.Invalidate;
end;

procedure TShowReportsForm.actUpUpdate(Sender: TObject);
begin
  actUp.Enabled:=(Caddy.UserLevel >= 4) and (DrawGrid.Row > 1);
end;

procedure TShowReportsForm.actDownExecute(Sender: TObject);
var R: TWatchRecord; i: integer;
begin
  i:=DrawGrid.Row;
  with RemXForm do
  begin
    R:=WatchList.Body[i];
    WatchList.Body[i]:=WatchList.Body[i+1];
    WatchList.Body[i+1]:=R;
  end;
  DrawGrid.Row:=DrawGrid.Row+1;
  SaveWatchList;
  RemXForm.FillWatchList;
  DrawGrid.Invalidate;
end;

procedure TShowReportsForm.actDownUpdate(Sender: TObject);
begin
  actDown.Enabled:=(Caddy.UserLevel >= 4) and
                   (DrawGrid.Row < DrawGrid.RowCount-1);
end;

procedure TShowReportsForm.DrawGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ssCtrl in Shift then
  begin
    if Key = VK_UP then
    begin
      if actUp.Enabled then actUp.Execute;
      Key:=0;
    end;
    if Key = VK_DOWN then
    begin
      if actDown.Enabled then actDown.Execute;
      Key:=0;
    end;
  end;
end;

procedure TShowReportsForm.actNewRtmReportUpdate(Sender: TObject);
begin
  actNewRtmReport.Enabled:=(Caddy.UserLevel >= 4);
end;

procedure TShowReportsForm.actPreviewRtmReportExecute(Sender: TObject);
var i: integer;
begin
  Printer.Refresh;
  if Printer.Printers.Count = 0 then
  begin
    RemxForm.ShowError('��� ������������� ��������� � �������.');
    Exit;
  end;
//  try
//    Printer.PrinterIndex:=-1;
//  except
//    RemxForm.ShowError('�� ������ ������� �� ���������!');
//    Exit;
//  end;
  i:=DrawGrid.Row-1;
  with RemXForm do
  begin
    if FileExists(IncludeTrailingPathDelimiter(Caddy.CurrentReportsPath)+
                                               WatchList.Body[i+1].FileName) then
    begin
      frReportView.LoadFromFile(IncludeTrailingPathDelimiter(Caddy.CurrentReportsPath)+
                                WatchList.Body[i+1].FileName);
      Panel.acPreview.Execute;
      Panel.ShowPreviewForm.MasterAction:=Panel.actReports;
      frReportView.Preview:=Panel.ShowPreviewForm.frAllPreview;
      if frReportView.PrepareReport then
      begin
        frReportView.ShowPreparedReport;
        Panel.ShowPreviewForm.Show
      end;
    end
    else
      ShowError('���� ������ �� ������!');
  end;
end;

procedure TShowReportsForm.actPreviewRtmReportUpdate(Sender: TObject);
begin
  actPreviewRtmReport.Enabled:=(RemXForm.WatchList.Length > 0);
end;

procedure TShowReportsForm.actPrintRtmReportExecute(Sender: TObject);
var i: integer;
begin
  PrintDialogForm:=TPrintDialogForm.Create(Self);
  try
    i:=DrawGrid.Row-1;
    with RemXForm do
    begin
      if FileExists(IncludeTrailingPathDelimiter(Caddy.CurrentReportsPath)+
                    WatchList.Body[i+1].FileName) then
      begin
        frReportView.LoadFromFile(IncludeTrailingPathDelimiter(Caddy.CurrentReportsPath)+
                                  WatchList.Body[i+1].FileName);
        frReportView.Title:=WatchList.Body[i+1].Descriptor;
        if frReportView.PrepareReport then
        begin
          PrintDialogForm.FromPage:=1;
          PrintDialogForm.ToPage:=1;
          if PrintDialogForm.Execute then
          begin
            RemXForm.SaveReportToReportsLog(frReportView,True,'������');
            if PrintDialogForm.PrintRange = prAllPages then
              frReportView.PrintPreparedReport('',PrintDialogForm.Copies,
                                              PrintDialogForm.Collate,frAll)
            else
              if PrintDialogForm.PrintRange = prPageNums then
                frReportView.PrintPreparedReport(Format('%d-%d',
                            [PrintDialogForm.FromPage,PrintDialogForm.ToPage]),
                         PrintDialogForm.Copies,PrintDialogForm.Collate,frAll);
          end;
        end;
      end
      else
        ShowError('���� ������ �� ������!');
    end;
  finally
    PrintDialogForm.Free;
  end;
end;

procedure TShowReportsForm.actPrintRtmReportUpdate(Sender: TObject);
begin
  actPrintRtmReport.Enabled:=(RemXForm.WatchList.Length > 0);
end;

end.
