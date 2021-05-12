unit ShowTuningUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, Buttons, ActnList, AppEvnts,
  PanelFormUnit, ShellCtrls;

type
  TShowTuningForm = class(TForm)
    ButtonsPanel: TPanel;
    PageControl: TPageControl;
    tsGeneral: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edObjectName: TEdit;
    edStationName: TEdit;
    cbStationNumber: TComboBox;
    tsSerialLink: TTabSheet;
    tsOtherPrograms: TTabSheet;
    tsSupport: TTabSheet;
    btnClose: TButton;
    btnCancel: TButton;
    Label4: TLabel;
    dtpDate: TDateTimePicker;
    dtpTime: TDateTimePicker;
    Label6: TLabel;
    Label8: TLabel;
    cbSchemeSize: TComboBox;
    Label9: TLabel;
    cbAlarmSound: TComboBox;
    Label10: TLabel;
    cbPrintColor: TComboBox;
    Label11: TLabel;
    cbSystemShell: TCheckBox;
    Timer: TTimer;
    Label51: TLabel;
    tvExternalModules: TTreeView;
    btAddExtProc: TButton;
    btChangeExtProc: TButton;
    btDeleteExtProc: TButton;
    TreeActionList: TActionList;
    actChangeExtProc: TAction;
    actDeleteExtProc: TAction;
    Label52: TLabel;
    clbSupport: TListBox;
    cbRootScheme: TComboBox;
    cbMonitors: TComboBox;
    Label5: TLabel;
    tcLink: TTabControl;
    tsNetLink: TTabSheet;
    Label16: TLabel;
    cbNetRole: TComboBox;
    gbNetClient: TGroupBox;
    leServerAddress: TLabeledEdit;
    leServerPort: TLabeledEdit;
    tsArchives: TTabSheet;
    GroupBox1: TGroupBox;
    Label13: TLabel;
    cbDelTrends: TComboBox;
    cbTrashTrends: TCheckBox;
    Label21: TLabel;
    cbDelSnapMin: TComboBox;
    cbTrashSnapMin: TCheckBox;
    Label22: TLabel;
    cbDelSnapHour: TComboBox;
    cbTrashSnapHour: TCheckBox;
    Label23: TLabel;
    cbDelAverHour: TComboBox;
    cbTrashAverHour: TCheckBox;
    Label24: TLabel;
    cbDelLogs: TComboBox;
    cbTrashLogs: TCheckBox;
    Label25: TLabel;
    cbDelReportLogs: TComboBox;
    cbTrashReportLogs: TCheckBox;
    lbSaveToLogForNet: TLabel;
    cbSaveToLogForNet: TCheckBox;
    pcTransportProtocol: TPageControl;
    TabSheet1: TTabSheet;
    Label15: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    cbPort: TComboBox;
    cbBaudrate: TComboBox;
    cbParity: TComboBox;
    cbDataSize: TComboBox;
    cbStops: TComboBox;
    TabSheet2: TTabSheet;
    Label27: TLabel;
    Label29: TLabel;
    edPrimaryAddr: TEdit;
    edPrimaryPort: TEdit;
    Panel1: TPanel;
    Label12: TLabel;
    Label7: TLabel;
    Label14: TLabel;
    Label26: TLabel;
    cbSaveToLog: TCheckBox;
    cbRepeatCount: TComboBox;
    edtTimeOut: TEdit;
    udTimeout: TUpDown;
    cbLinkType: TComboBox;
    Label28: TLabel;
    cbDigErrFilter: TCheckBox;
    tsSchemaMenu: TTabSheet;
    tvSchemeTree: TTreeView;
    btnNewItem: TButton;
    btnNewSubItem: TButton;
    btnDeleteItem: TButton;
    lbl1: TLabel;
    edtTextMenu: TEdit;
    lbl2: TLabel;
    cbbSchemeLink: TComboBox;
    lbl3: TLabel;
    cbNoAsk: TCheckBox;
    Label31: TLabel;
    grpPathes: TGroupBox;
    lbl4: TLabel;
    lbl7: TLabel;
    lbl5: TLabel;
    lbl6: TLabel;
    edtPathTrends: TEdit;
    btnPathTrends: TButton;
    edtPathTables: TEdit;
    btnPathTables: TButton;
    edtPathLogs: TEdit;
    edtPathReports: TEdit;
    btnPathLogs: TButton;
    btnPathReports: TButton;
    grp1: TGroupBox;
    chkExportActive: TCheckBox;
    lbledtConnectionString: TLabeledEdit;
    lbl8: TLabel;
    cbNoAddNoLinkInAciveLog: TCheckBox;
    procedure cbSystemShellClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure dtpDateChange(Sender: TObject);
    procedure btAddExtProcClick(Sender: TObject);
    procedure actChangeExtProcUpdate(Sender: TObject);
    procedure actChangeExtProcExecute(Sender: TObject);
    procedure actDeleteExtProcExecute(Sender: TObject);
    procedure cbRootSchemeDropDown(Sender: TObject);
    procedure cbSaveToLogClick(Sender: TObject);
    procedure tcLinkChange(Sender: TObject);
    procedure tcLinkChanging(Sender: TObject; var AllowChange: Boolean);
    procedure cbNetRoleChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbDigErrFilterClick(Sender: TObject);
    procedure btnNewItemClick(Sender: TObject);
    procedure tvSchemeTreeChange(Sender: TObject; Node: TTreeNode);
    procedure btnNewSubItemClick(Sender: TObject);
    procedure btnDeleteItemClick(Sender: TObject);
    procedure edtTextMenuChange(Sender: TObject);
    procedure tvSchemeTreeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cbbSchemeLinkSelect(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbNoAskClick(Sender: TObject);
    procedure btnPathTrendsClick(Sender: TObject);
    procedure btnPathTablesClick(Sender: TObject);
    procedure btnPathLogsClick(Sender: TObject);
    procedure btnPathReportsClick(Sender: TObject);
    procedure chkExportActiveClick(Sender: TObject);
    procedure cbNoAddNoLinkInAciveLogClick(Sender: TObject);
  private
    FPanel: TPanelForm;
//    function CheckIPValid(AText: string): boolean;
//    function CheckPortValid(AText: string): boolean;
  public
    FSchemeLink: TStringList;
    property Panel: TPanelForm read FPanel write FPanel;
  end;

var
  ShowTuningForm: TShowTuningForm;

implementation

uses AddExtModuleUnit, FileCtrl, EntityUnit, RemXUnit;

{$R *.dfm}

procedure TShowTuningForm.cbSystemShellClick(Sender: TObject);
begin
  if cbSystemShell.Checked then
    cbSystemShell.Caption:='Включена'
  else
    cbSystemShell.Caption:='Выключена';
end;

procedure TShowTuningForm.TimerTimer(Sender: TObject);
var DT: TDateTime;
begin
  DT:=Now;
  dtpDate.DateTime:=Int(DT);
  dtpTime.DateTime:=Frac(DT);
end;

procedure TShowTuningForm.dtpDateChange(Sender: TObject);
begin
  Timer.Enabled:=False;
end;

procedure TShowTuningForm.btAddExtProcClick(Sender: TObject);
var Node: TTreeNode;
begin
  AddExtModuleForm:=TAddExtModuleForm.Create(Self);
  try
    with AddExtModuleForm do
    begin
      if ShowModal = mrOk then
      begin
        if Trim(edMenuName.Text)='' then
          RemxForm.ShowError(
            'Название пункта меню не может быть пустой строкой!')
        else
        if not FileExists(edProgramPath.Text) then
          RemxForm.ShowError('Файл программы по указанному пути не найден!')
        else
        if not DirectoryExists(edWorkPath.Text) then
          RemxForm.ShowError('Указанная рабочая папка не найдена!')
        else
        with tvExternalModules do
        begin
          Node:=Items.Add(nil,edMenuName.Text);
          Items.AddChild(Node,'Программа: '+edProgramPath.Text);
          Items.AddChild(Node,'Рабочая папка: '+edWorkPath.Text);
          Items.AddChild(Node,'Уровень доступа: '+cbLevel.Text);
          Selected:=Node;
          Node.Expand(False);
        end;
      end;
    end;
  finally
    AddExtModuleForm.Free;
  end;
end;

procedure TShowTuningForm.actChangeExtProcUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled:=(tvExternalModules.Selected <> nil);
end;

procedure TShowTuningForm.actChangeExtProcExecute(Sender: TObject);
var Node: TTreeNode; S: string;
begin
  Node:=tvExternalModules.Selected;
  if Node.Level = 1 then Node:=Node.Parent;
  AddExtModuleForm:=TAddExtModuleForm.Create(Self);
  try
    with AddExtModuleForm do
    begin
      edMenuName.Text:=Node.Text;
      Node:=Node.getFirstChild;
      S:=Node.Text;
      Delete(S,1,Pos(': ',S)+1);
      edProgramPath.Text:=S;
      Node:=Node.GetNext;
      S:=Node.Text;
      Delete(S,1,Pos(': ',S)+1);
      edWorkPath.Text:=S;
      Node:=Node.GetNext;
      S:=Node.Text;
      Delete(S,1,Pos(': ',S)+1);
      cbLevel.ItemIndex:=cbLevel.Items.IndexOf(S);
      if ShowModal = mrOk then
      begin
        if Trim(edMenuName.Text)='' then
          RemxForm.ShowError(
          'Название пункта меню не может быть пустой строкой!')
        else
        if not FileExists(edProgramPath.Text) then
          RemxForm.ShowError(
          'Файл программы по указанному пути не найден!')
        else
        if not DirectoryExists(edWorkPath.Text) then
          RemxForm.ShowError('Указанная рабочая папка не найдена!')
        else
        begin
          Node:=tvExternalModules.Selected;
          if Node.Level = 1 then Node:=Node.Parent;
          Node.Text:=edMenuName.Text;
          Node:=Node.getFirstChild;
          Node.Text:='Программа: '+edProgramPath.Text;
          Node:=Node.GetNext;
          Node.Text:='Рабочая папка: '+edWorkPath.Text;
          Node:=Node.GetNext;
          Node.Text:='Уровень доступа: '+cbLevel.Text;
          tvExternalModules.Selected:=Node.Parent;
          Node.Expand(False);
        end;
      end;
    end;
  finally
    AddExtModuleForm.Free;
  end;
end;

procedure TShowTuningForm.actDeleteExtProcExecute(Sender: TObject);
var Node: TTreeNode;
begin
  Node:=tvExternalModules.Selected;
  if Node.Level = 1 then Node:=Node.Parent;
  if RemxForm.ShowQuestion('В самом деле хотите удалить?')=mrOK then
    tvExternalModules.Items.Delete(Node);
end;

procedure TShowTuningForm.cbRootSchemeDropDown(Sender: TObject);
var sr: TSearchRec; FileAttrs: Integer;
begin
  (Sender as TComboBox).Items.Clear;
  FileAttrs:=faDirectory;
  if FindFirst(IncludeTrailingPathDelimiter(Caddy.CurrentSchemsPath)+
      '*.SCM',FileAttrs,sr) = 0 then
  begin
    repeat
      if (sr.Attr and FileAttrs) <> sr.Attr then
        (Sender as TComboBox).Items.Add(sr.Name);
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
end;

procedure TShowTuningForm.cbSaveToLogClick(Sender: TObject);
begin
  with Sender as TCheckBox do
  if Checked then
    Caption:='Включен'
  else
    Caption:='Выключен';
end;

procedure TShowTuningForm.tcLinkChange(Sender: TObject);
var si: string;
begin
  si:=IntToStr(tcLink.TabIndex+1);
  cbPort.ItemIndex:=Config.ReadInteger('Channel'+si,'Port',0);
  cbBaudrate.ItemIndex:=Config.ReadInteger('Channel'+si,'Baudrate',8);
  cbParity.ItemIndex:=Config.ReadInteger('Channel'+si,'Parity',0);
  cbDataSize.ItemIndex:=Config.ReadInteger('Channel'+si,'DataSize',3);
  cbStops.ItemIndex:=Config.ReadInteger('Channel'+si,'Stops',0);
  udTimeOut.Position:=Config.ReadInteger('Channel'+si,'TimeOut',800);
  cbSaveToLog.Checked:=Config.ReadBool('Channel'+si,'SaveToLog',False);
  cbRepeatCount.ItemIndex:=Config.ReadInteger('Channel'+si,'RepeatCount',2);
  cbLinkType.ItemIndex:=Config.ReadInteger('Channel'+si,'LinkType',0);
  pcTransportProtocol.ActivePageIndex:=Config.ReadInteger('Channel'+si,'TransportProtocol',0);
  edPrimaryAddr.Text := Config.ReadString('Channel'+si,'PrimaryAddr','');
  edPrimaryPort.Text := Config.ReadString('Channel'+si,'PrimaryPort','');
end;

procedure TShowTuningForm.tcLinkChanging(Sender: TObject;
  var AllowChange: Boolean);
var si: string; i: integer;
begin
  i:=tcLink.TabIndex+1;
  si:=IntToStr(i);
  Config.WriteInteger('Channel'+si,'Port',cbPort.ItemIndex);
  Config.WriteInteger('Channel'+si,'Baudrate',cbBaudrate.ItemIndex);
  Config.WriteInteger('Channel'+si,'Parity',cbParity.ItemIndex);
  Config.WriteInteger('Channel'+si,'DataSize',cbDataSize.ItemIndex);
  Config.WriteInteger('Channel'+si,'Stops',cbStops.ItemIndex);
  Config.WriteInteger('Channel'+si,'TimeOut',udTimeOut.Position);
  Config.WriteBool('Channel'+si,'SaveToLog',cbSaveToLog.Checked);
  Config.WriteInteger('Channel'+si,'RepeatCount',cbRepeatCount.ItemIndex);
  Config.WriteInteger('Channel'+si,'LinkType',cbLinkType.ItemIndex);
  Config.WriteInteger('Channel'+si,'TransportProtocol',pcTransportProtocol.ActivePageIndex);
  Config.WriteString('Channel'+si,'PrimaryAddr',edPrimaryAddr.Text);
  Config.WriteString('Channel'+si,'PrimaryPort',edPrimaryPort.Text);
end;

procedure TShowTuningForm.cbNetRoleChange(Sender: TObject);
begin
  case cbNetRole.ItemIndex of
   0: begin
        leServerAddress.Enabled:=False;
        leServerPort.Enabled:=False;
        cbSaveToLogForNet.Enabled:=False;
        lbSaveToLogForNet.Enabled:=False;
      end;
  else
      begin
        leServerAddress.Enabled:=True;
        leServerPort.Enabled:=True;
        cbSaveToLogForNet.Enabled:=True;
        lbSaveToLogForNet.Enabled:=True;
      end;
  end;
end;

procedure TShowTuningForm.FormShow(Sender: TObject);
begin
  cbNetRoleChange(cbNetRole);
end;

procedure TShowTuningForm.FormCreate(Sender: TObject);
var i: integer;
begin
  FSchemeLink := TStringList.Create;
  for i := 1 to 99 do cbPort.Items.Add(Format('COM%d',[i]));
end;

procedure TShowTuningForm.cbDigErrFilterClick(Sender: TObject);
begin
  if cbDigErrFilter.Checked then
    cbDigErrFilter.Caption:='Включен'
  else
    cbDigErrFilter.Caption:='Выключен';
end;

procedure TShowTuningForm.btnNewItemClick(Sender: TObject);
begin
  tvSchemeTree.Selected := tvSchemeTree.Items.Add(nil, Trim(edtTextMenu.Text));
  edtTextMenu.SetFocus;
end;

procedure TShowTuningForm.tvSchemeTreeChange(Sender: TObject;
  Node: TTreeNode);
var selected: Boolean; idx: integer;
begin
  selected := tvSchemeTree.Selected <> nil;
  cbbSchemeLink.Enabled := selected and (tvSchemeTree.Selected.Level > 0);
  if selected then
  begin
    edtTextMenu.Text := tvSchemeTree.Selected.Text;
    if tvSchemeTree.Selected.Level > 0 then
    begin
      idx := tvSchemeTree.Selected.SelectedIndex;
      if (idx >= 0) and (idx < FSchemeLink.Count) then
        cbbSchemeLink.Text := FSchemeLink[idx]
      else
        cbbSchemeLink.Text := '';
    end
    else
      cbbSchemeLink.Text := '';
  end;
end;

procedure TShowTuningForm.btnNewSubItemClick(Sender: TObject);
begin
  if tvSchemeTree.Selected <> nil then
  begin
     if tvSchemeTree.Selected.Level = 0 then
       tvSchemeTree.Selected := tvSchemeTree.Items.AddChild(
                              tvSchemeTree.Selected, Trim(edtTextMenu.Text))
     else
       tvSchemeTree.Selected := tvSchemeTree.Items.Add(
                              tvSchemeTree.Selected, Trim(edtTextMenu.Text));
     edtTextMenu.SetFocus;
  end;
end;

procedure TShowTuningForm.btnDeleteItemClick(Sender: TObject);
begin
  if (tvSchemeTree.Selected <> nil) then
  begin
     tvSchemeTree.Items.Delete(tvSchemeTree.Selected);
     tvSchemeTree.Selected := nil;
     edtTextMenu.Text := '';
     cbbSchemeLink.Text := '';
  end;
end;

procedure TShowTuningForm.edtTextMenuChange(Sender: TObject);
begin
  if (tvSchemeTree.Selected <> nil) then
     tvSchemeTree.Selected.Text := Trim(edtTextMenu.Text);
end;

procedure TShowTuningForm.tvSchemeTreeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    if tvSchemeTree.GetNodeAt(X,Y) <> nil then
    begin
      edtTextMenu.SetFocus;
    end;
  end;
end;

procedure TShowTuningForm.cbbSchemeLinkSelect(Sender: TObject);
var scheme: string; idx: Integer;
begin
// FSchemeLink
  if (tvSchemeTree.Selected <> nil) and (tvSchemeTree.Selected.Level = 1) then
  begin
    scheme := cbbSchemeLink.Text;
    idx := FSchemeLink.IndexOf(scheme);
    if idx < 0 then idx := FSchemeLink.Add(scheme);
    tvSchemeTree.Selected.SelectedIndex := idx;
  end;
end;

procedure TShowTuningForm.FormDestroy(Sender: TObject);
begin
  FSchemeLink.Free;
end;

// добавлено 15.07.12
procedure TShowTuningForm.cbNoAskClick(Sender: TObject);
begin
 if cbNoAsk.Checked then
    cbNoAsk.Caption:='Включен'
  else
    cbNoAsk.Caption:='Выключен';
end;

procedure TShowTuningForm.btnPathTrendsClick(Sender: TObject);
var Dir: string;
begin
  Dir := Caddy.CurrentTrendPath;
  if SelectDirectory('Выбор папки для хранения трендов','', Dir) then
    edtPathTrends.Text:=Dir;
end;

procedure TShowTuningForm.btnPathTablesClick(Sender: TObject);
var Dir: string;
begin
  Dir := Caddy.CurrentTablePath;
  if SelectDirectory('Выбор папки для хранения таблиц','', Dir) then
    edtPathTables.Text:=Dir;
end;

procedure TShowTuningForm.btnPathLogsClick(Sender: TObject);
var Dir: string;
begin
  Dir := Caddy.CurrentLogsPath;
  if SelectDirectory('Выбор папки для хранения журналов','', Dir) then
    edtPathLogs.Text:=Dir;
end;

procedure TShowTuningForm.btnPathReportsClick(Sender: TObject);
var Dir: string;
begin
  Dir := Caddy.CurrentReportsLogPath;
  if SelectDirectory('Выбор папки для хранения архива отчетов','', Dir) then
    edtPathReports.Text:=Dir;
end;

procedure TShowTuningForm.chkExportActiveClick(Sender: TObject);
begin
  lbledtConnectionString.Enabled := chkExportActive.Checked;
end;

procedure TShowTuningForm.cbNoAddNoLinkInAciveLogClick(Sender: TObject);
begin
 if cbNoAddNoLinkInAciveLog.Checked then
    cbNoAddNoLinkInAciveLog.Caption:='Включен'
  else
    cbNoAddNoLinkInAciveLog.Caption:='Выключен';
end;

end.
