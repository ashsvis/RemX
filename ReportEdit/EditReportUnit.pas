unit EditReportUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FR_Class, ComCtrls, ToolWin, ExtCtrls, EntityUnit, FR_Desgn,
  AppEvnts, PanelFormUnit;

type
  TRemXfrReport = class(TfrReport)
  public
    procedure SaveToFile(FName: String);
  end;

  TEditReportForm = class(TForm)
    ReportControlBar: TControlBar;
    ReportToolMenu: TToolBar;
    tbReports: TToolButton;
    ReportPanel: TPanel;
    tbEditMenu: TToolButton;
    tbToolMenu: TToolButton;
    ApplicationEvents1: TApplicationEvents;
    frReportPreview: TfrReport;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure ReportPreview(Sender: TObject);
    procedure ReportSave(Sender: TObject);
    procedure ReportSaveAs(Sender: TObject);
  private
    OldInsExprBtnClick: TNotifyEvent;
    OldInsFuncBtnClick: TNotifyEvent;
    OldReportSave: TNotifyEvent;
    OldReportSaveAs: TNotifyEvent;
    FPanel: TPanelForm;
    procedure DesignerClose(Sender: TObject; var Action: TCloseAction);
    procedure ReportEditorClose(Sender: TObject);
    procedure RestoreReportPanels(Sender: TObject);
    procedure frEditorFormShow(Sender: TObject);
    procedure InsExprBtnClick(Sender: TObject);
    procedure ExprFormShow(var Mess: TMessage); message WM_ExprFormShow;
    procedure FuncFormShow(var Mess: TMessage); message WM_FuncFormShow;
    procedure InsFuncBtnClick(Sender: TObject);
  public
    frReportEditor: TRemXfrReport;
    property Panel: TPanelForm read FPanel write FPanel;
  end;

implementation

uses FR_Prntr, FR_Dock, FR_Ctrls, FR_View, Registry, Menus,
  RemXUnit;

{$R *.dfm}

procedure TEditReportForm.FormCreate(Sender: TObject);
var PrnName: string; i,j: integer; R: TRegistry; SL: TStringList;
    PT: array[1..5] of TfrToolBar; M: TMenuItem;
begin
  frReportEditor:=TRemXfrReport.Create(Self);
  with frReportEditor do
  begin
    InitialZoom:=pzPageWidth;
    ModalPreview:=False;
    ModifyPrepared:=False;
    PreviewButtons:=[pbZoom,pbPrint,pbExit];
    ShowProgress:=False;
  end;
  SL:=TStringList.Create;
  R:=TRegistry.Create;
  try
    R.RootKey:=HKEY_CURRENT_USER;
    if R.OpenKey('Software\FastReport\Remx\Form\TfrInsFieldsForm',True) then
    begin
      R.GetValueNames(SL);
      for i:=0 to SL.Count-1 do R.DeleteValue(SL[i]);
      R.WriteString('isVisible','0');
      R.CloseKey;
    end;
    if R.OpenKey('Software\FastReport\Remx\Form\TfrInspForm',True) then
    begin
      R.GetValueNames(SL);
      for i:=0 to SL.Count-1 do R.DeleteValue(SL[i]);
      R.WriteString('isVisible','0');
      R.CloseKey;
    end;
    for i:=1 to 5 do
    if R.OpenKey('Software\FastReport\Remx\ToolBar\Panel'+IntToStr(i),True) then
    begin
      R.GetValueNames(SL);
      for j:=0 to SL.Count-1 do R.DeleteValue(SL[j]);
      R.WriteString('isVisible','1');
      R.WriteString('DockName','frDock1');
      if i in [1,3] then
        R.WriteString('YPosition','26')
      else
        R.WriteString('YPosition','0');
      case i of
       1: R.WriteString('XPosition','555');
       2: R.WriteString('XPosition','111');
       3: R.WriteString('XPosition','0');
       4: R.WriteString('XPosition','0');
       5: R.WriteString('XPosition','518');
      end;
      R.CloseKey;
    end;
    if R.OpenKey('Software\FastReport\Remx\ToolBar\Panel6',True) then
    begin
      R.GetValueNames(SL);
      for i:=0 to SL.Count-1 do R.DeleteValue(SL[i]);
      R.WriteString('isVisible','0');
      R.CloseKey;
    end;
  finally
    R.Free;
    SL.Free;
  end;
  PrnName:=Prn.Printers[Prn.PrinterIndex];
  if not frReportEditor.PrintToDefault then
    if Prn.Printers.IndexOf(PrnName) <> -1 then
      Prn.PrinterIndex := Prn.Printers.IndexOf(PrnName);
  if frReportEditor.Pages.Count = 0 then frReportEditor.Pages.Add;
  CurReport:=frReportEditor;
  if Assigned(frDesignerClass) then
  begin
    frDesigner:=TfrReportDesigner(frDesignerClass.NewInstance);
    frDesigner.CreateDesigner(True);
    frDesigner.WindowState:=WindowState;
    frDesigner.BorderStyle:=BorderStyle;
    frDesigner.Parent:=ReportPanel;
    frDesigner.OnClose:=DesignerClose;
    tbReports.MenuItem:=frDesigner.FindComponent('FileMenu') as TMenuItem;
    tbEditMenu.MenuItem:=frDesigner.FindComponent('EditMenu') as TMenuItem;
    tbToolMenu.MenuItem:=frDesigner.FindComponent('ToolMenu') as TMenuItem;
  end;
  frDesigner.Hide;
//----------------------------------
  PT[1]:=frDesigner.FindComponent('Panel1') as TfrToolBar;
  PT[2]:=frDesigner.FindComponent('Panel2') as TfrToolBar;
  PT[3]:=frDesigner.FindComponent('Panel3') as TfrToolBar;
  PT[4]:=frDesigner.FindComponent('Panel4') as TfrToolBar;
  PT[5]:=frDesigner.FindComponent('Panel5') as TfrToolBar;
  for i:=1 to 5 do
  begin
    PT[i].UseDockManager:=False;
    PT[i].CanFloat:=False;
    PT[i].Orientation:=toHorzOnly;
  end;
//----------------------------------
  with (frDesigner.FindComponent('Tab1') as TTabControl) do
    begin PopupMenu:=nil; OnMouseDown:=nil; end;
  with frDesigner.FindComponent('ExitB') as TControl do Visible:=False;
  with frDesigner.FindComponent('frTBSeparator5') as TControl do Visible:=False;
  with frDesigner.FindComponent('HelpBtn') as TControl do Visible:=False;
  with frDesigner.FindComponent('frTBSeparator11') as TControl do Visible:=False;
  with frDesigner.FindComponent('PgB1') as TControl do Visible:=False;
  with frDesigner.FindComponent('PgB2') as TControl do Visible:=False;
  with frDesigner.FindComponent('PgB4') as TControl do Visible:=False;
  with frDesigner.FindComponent('OB3') as TControl do Visible:=False;
  with frDesigner.FindComponent('OB5') as TControl do Visible:=False;
  with frDesigner.FindComponent('N42') as TMenuItem do Visible:=False;
  with frDesigner.FindComponent('N10') as TMenuItem do Visible:=False;
  with frDesigner.FindComponent('N29') as TMenuItem do Visible:=False;
  with frDesigner.FindComponent('N15') as TMenuItem do Visible:=False;
  with frDesigner.FindComponent('N30') as TMenuItem do Visible:=False;
  with frDesigner.FindComponent('N37') as TMenuItem do Visible:=False;
  with frDesigner.FindComponent('MastMenu') as TMenuItem do Visible:=False;
  with frDesigner.FindComponent('N23') as TMenuItem do Visible:=False;
//----------------------------------
  with frDesigner.FindComponent('FileBtn4') as TfrTBButton do OnClick:=ReportPreview;
  with frDesigner.FindComponent('N39') as TMenuItem do OnClick:=ReportPreview;
//----------------------------------
  with frDesigner.FindComponent('FileBtn3') as TfrTBButton do
  begin
    OldReportSave:=OnClick;
    OnClick:=ReportSave;
  end;
  with frDesigner.FindComponent('N20') as TMenuItem do OnClick:=ReportSave;
  with frDesigner.FindComponent('N17') as TMenuItem do
  begin
    OldReportSaveAs:=OnClick;
    OnClick:=ReportSaveAs;
  end;
//----------------------------------
  with frDesigner.FindComponent('OpenDialog1') as TOpenDialog do
    InitialDir:=Caddy.CurrentReportsPath;
//----------------------------------
  M:=TMenuItem.Create(Self);
  M.Caption:='Закрыть редактор';
  M.OnClick:=ReportEditorClose;
  with (frDesigner.FindComponent('FileMenu') as TMenuItem) do Add(M);
  M:=TMenuItem.Create(Self);
  M.Caption:='Восстановить панели инструметов';
  M.OnClick:=RestoreReportPanels;
  with (frDesigner.FindComponent('ToolMenu') as TMenuItem) do Add(M);
//----------------------------------
  for i:=0 to Screen.FormCount-1 do
  if Screen.Forms[i].ClassName = 'TfrEditorForm' then
  with Screen.Forms[i] do
  begin
    OnShow:=frEditorFormShow;
    (FindComponent('InsDBBtn')as TControl).Visible:=False;
    with FindComponent('InsExprBtn')as TfrSpeedButton do
    begin
      OldInsExprBtnClick:=OnClick;
      OnClick:=InsExprBtnClick;
    end;
    Break;
  end;
//----------------------------------
  frReportPreview.OnBeginDoc:=RemXForm.FastReportBeginDoc;
end;

procedure TEditReportForm.frEditorFormShow(Sender: TObject);
var i: integer;
begin
  for i:=0 to Screen.FormCount-1 do
  if Screen.Forms[i].ClassName = 'TfrEditorForm' then
  with Screen.Forms[i] do
  begin
    SetBounds(Panel.Left+(Panel.Width-Width) div 2,
              Panel.Top+(Panel.Height-Height) div 2,
              Width,Height);
  end;
  ((Sender as TForm).FindComponent('ScriptBtn') as TControl).Visible:=True;
  ((Sender as TForm).FindComponent('ScriptBtn') as TfrSpeedButton).Down:=False;
  ((Sender as TForm).FindComponent('ScriptPanel')as TControl).Visible:=False;
  ((Sender as TForm).FindComponent('Splitter')as TControl).Visible:=False;
  (Sender as TForm).ActiveControl:=
           (Sender as TForm).FindComponent('M1')as TWinControl;
end;

procedure TEditReportForm.InsExprBtnClick(Sender: TObject);
begin
  if Assigned(OldInsExprBtnClick) then
  begin
    PostMessage(Handle,WM_ExprFormShow,0,0);
    OldInsExprBtnClick(Sender);
  end;
end;

procedure TEditReportForm.ExprFormShow(var Mess: TMessage);
var i: integer;
begin
  for i:=0 to Screen.FormCount-1 do
  if Screen.Forms[i].ClassName = 'TfrExprForm' then
  begin
    with Screen.Forms[i] do
    begin
      SetBounds(Panel.Left+(Panel.Width-Width) div 2,
                Panel.Top+(Panel.Height-Height) div 2,
                Width,Height);
    end;
    with Screen.Forms[i].FindComponent('InsFuncBtn')as TfrSpeedButton do
    begin
      OldInsFuncBtnClick:=OnClick;
      OnClick:=InsFuncBtnClick;
    end;
    Break;
  end;
end;

procedure TEditReportForm.InsFuncBtnClick(Sender: TObject);
begin
  if Assigned(OldInsFuncBtnClick) then
  begin
    PostMessage(Handle,WM_FuncFormShow,0,0);
    OldInsFuncBtnClick(Sender);
  end;
end;

procedure TEditReportForm.FuncFormShow(var Mess: TMessage);
var i: integer; N,N0: TTreeNode;
begin
  for i:=0 to Screen.FormCount-1 do
  if Screen.Forms[i].ClassName = 'TfrFuncForm' then
  begin
    with Screen.Forms[i] do
    begin
      SetBounds(Panel.Left+(Panel.Width-Width) div 2,
                Panel.Top+(Panel.Height-Height) div 2,
                Width,Height);
    end;
    with (Screen.Forms[i].FindComponent('Tree1')as TTreeView) do
    begin
      N0:=nil;
      N:=Items.GetFirstNode;
      while N <> nil do
      begin
        if N.Text = 'RemX' then
        begin
          N0:=N;
          Break;
        end;
        N:=N.GetNext;
      end;
      if Assigned(N0) then Selected:=N0;
    end;
    Break;
  end;
end;

procedure TEditReportForm.FormDestroy(Sender: TObject);
begin
  frDesigner.Free;
  frDesigner := nil;
end;

procedure TEditReportForm.FormShow(Sender: TObject);
begin
  frDesigner.Show;
  tbReports.Caption:='Отчет';
  tbEditMenu.Caption:='Редактирование';
  tbToolMenu.Caption:='Инструменты';
end;

procedure TEditReportForm.FormHide(Sender: TObject);
begin
  frDesigner.Hide;
end;

procedure TEditReportForm.FormResize(Sender: TObject);
begin
  frDesigner.SetBounds(0,0,Width,Height);
end;

procedure TEditReportForm.DesignerClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caNone;
end;

procedure TEditReportForm.ReportEditorClose(Sender: TObject);
begin
  Panel.actOverview.Execute;
end;

procedure TEditReportForm.RestoreReportPanels(Sender: TObject);
begin
  with frDesigner.FindComponent('Panel1') as TfrToolBar do
  begin
    Top:=26; Left:=555;
  end;
  with frDesigner.FindComponent('Panel2') as TfrToolBar do
  begin
    Top:=0; Left:=111;
  end;
  with frDesigner.FindComponent('Panel3') as TfrToolBar do
  begin
    Top:=26; Left:=0;
  end;
  with frDesigner.FindComponent('Panel4') as TfrToolBar do
  begin
    Top:=0; Left:=0;
  end;
  with frDesigner.FindComponent('Panel5') as TfrToolBar do
  begin
    Top:=0; Left:=518;
  end;
  with frDesigner.FindComponent('frDock1') as TfrDock do
  begin
    Height:=53;
  end;
end;

procedure TEditReportForm.ApplicationEvents1Idle(Sender: TObject;
  var Done: Boolean);
var i: integer;
begin
  for i:=0 to Screen.FormCount-1 do
  begin
    if (Screen.Forms[i].ClassName = 'TfrExprForm') then
    begin
      if Screen.Forms[i].Tag <> 1 then
      begin
        Screen.Forms[i].Tag:=1;
        (Screen.Forms[i].FindComponent('InsDBBtn')as TControl).Visible:=False;
        (Screen.Forms[i].FindComponent('InsFuncBtn')as  TControl).Left:=
          (Screen.Forms[i].FindComponent('InsDBBtn')as TControl).Left;
      end;
    end;
  end;
end;

procedure TEditReportForm.ReportPreview(Sender: TObject);
var M: TMemoryStream;
begin
  M:=TMemoryStream.Create;
  try
    with RemXForm do
    begin
      frReportEditor.SaveToStream(M);
      M.Position:=0;
      frReportPreview.LoadFromStream(M);
      Panel.acPreview.Execute;
      Panel.ShowPreviewForm.MasterAction := Panel.actReportEdit;
      frReportPreview.Preview := Panel.ShowPreviewForm.frAllPreview;
      if frReportPreview.PrepareReport then
      begin
        frReportPreview.ShowPreparedReport;
        Panel.ShowPreviewForm.Show;
      end;
    end;
  finally
    M.Free;
  end;
end;

{ TRemXfrReport }

procedure TRemXfrReport.SaveToFile(FName: String);
var FileName, BackName: string;
begin
  FileName:=FName;
  BackName:=ChangeFileExt(FileName,'.~frf');
  if FileExists(BackName) and DeleteFile(BackName) or
     not FileExists(BackName) then
  begin
    if FileExists(FileName) and RenameFile(FileName,BackName) or
       not FileExists(FileName) then
      inherited SaveToFile(FName);
  end;
end;

procedure TEditReportForm.ReportSave(Sender: TObject);
var FileName, BackName: string;
begin
  FileName:=frReportEditor.FileName;
  BackName:=ChangeFileExt(FileName,'.~frf');
  if FileExists(BackName) and DeleteFile(BackName) or
     not FileExists(BackName) then
  begin
    if FileExists(FileName) and RenameFile(FileName,BackName) or
       not FileExists(FileName) then
    begin
      OldReportSave(Sender);
   // -- исправление ошибки Fast Report ----
      FileName:=ChangeFileExt(BackName,'.frf');
      if not FileExists(FileName) then
        frReportEditor.SaveToFile(FileName);
   // --     
    end;
  end;
end;

procedure TEditReportForm.ReportSaveAs(Sender: TObject);
begin
  OldReportSaveAs(Sender);
end;

end.
