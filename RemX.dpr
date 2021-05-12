program RemX;

{$R 'ResData\Reports.res' 'ResData\Reports.rc'}

(*
{$DEFINE VIRTUALENTITY}
{$DEFINE KONTRAST}
{$DEFINE MODBUSRTU}
{$DEFINE VZLJOTURSV}
{$DEFINE ELITERFT9739}
{$DEFINE RESURSGLH}
{$DEFINE UZS24}
{$DEFINE METACON515}
{$DEFINE ELEMERTM5103}
*)

uses
  SimpleMemTest in 'RemXForm\SimpleMemTest.pas',
  Windows,
  Forms,
  SysUtils,
  EntityUnit in 'Entity\EntityUnit.pas',
  RemXUnit in 'RemXForm\RemXUnit.pas' {RemXForm},
  TuningUnit in 'RemXForm\TuningUnit.pas',
  TimeFilterUnit in 'LogsShow\TimeFilterUnit.pas' {TimeFilterForm},
  ExtTimeFilterUnit in 'LogsShow\ExtTimeFilterUnit.pas' {ExtTimeFilterForm},
  ExtFilterUnit in 'LogsShow\ExtFilterUnit.pas' {ExtFilterForm},
  UserDetailUnit in 'UsersShow\UserDetailUnit.pas' {UserDetailForm},
  GetPasswordUnit in 'UsersShow\GetPasswordUnit.pas' {GetPasswordForm},
  GetPtNameUnit in 'Entity\GetPtNameUnit.pas' {GetPtNameDlg},
  GetLinkNameUnit in 'Entity\GetLinkNameUnit.pas' {GetLinkNameDlg},
  GetDigValUnit in 'Entity\GetDigValUnit.pas' {GetDigValDlg},
  GetRegModeValUnit in 'Entity\GetRegModeValUnit.pas' {GetRegModeValDlg},
  GetRtmRepRecordUnit in 'ReportShow\GetRtmRepRecordUnit.pas' {GetRtmRepRecordForm},
  GetAutorizationUnit in 'RemXForm\GetAutorizationUnit.pas' {GetAutorizationForm},
  AddExtModuleUnit in 'TuningShow\AddExtModuleUnit.pas' {AddExtModuleForm},
  CRCCalcUnit in 'Entity\CRCCalcUnit.pas',
  RxGraph in 'Entity\RxGraph.pas',
  ThreadSaveUnit in 'Entity\ThreadSaveUnit.pas',
  VirtualUnit in 'Virtual\VirtualUnit.pas',
  VirtNNEditUnit in 'Virtual\VirtNNEditUnit.pas' {VirtNNEditForm},
  VirtNNPaspUnit in 'Virtual\VirtNNPaspUnit.pas' {VirtNNPaspForm},
  VirtFLEditUnit in 'Virtual\VirtFLEditUnit.pas' {VirtFLEditForm},
  VirtFLPaspUnit in 'Virtual\VirtFLPaspUnit.pas' {VirtFLPaspForm},
  VirtVDEditUnit in 'Virtual\VirtVDEditUnit.pas' {VirtVDEditForm},
  VirtVDPaspUnit in 'Virtual\VirtVDPaspUnit.pas' {VirtVDPaspForm},
  VirtSIEditUnit in 'Virtual\VirtSIEditUnit.pas' {VirtSIEditForm},
  VirtSIPaspUnit in 'Virtual\VirtSIPaspUnit.pas' {VirtSIPaspForm},
  VirtVCEditUnit in 'Virtual\VirtVCEditUnit.pas' {VirtVCEditForm},
  VirtVCPaspUnit in 'Virtual\VirtVCPaspUnit.pas' {VirtVCPaspForm},
  VirtASEditUnit in 'Virtual\VirtASEditUnit.pas' {VirtASEditForm},
  VirtTCEditUnit in 'Virtual\VirtTCEditUnit.pas' {VirtTCEditForm},
  VirtTCPaspUnit in 'Virtual\VirtTCPaspUnit.pas' {VirtTCPaspForm},
  VirtFAEditUnit in 'Virtual\VirtFAEditUnit.pas' {VirtFAEditForm},
  VirtFAPaspUnit in 'Virtual\VirtFAPaspUnit.pas' {VirtFAPaspForm},
  ShowBrowserUnit in 'Browser\ShowBrowserUnit.pas' {ShowBrowserForm},
  ShowOverviewUnit in 'Overview\ShowOverviewUnit.pas' {ShowOverviewForm},
  ShowLogsUnit in 'LogsShow\ShowLogsUnit.pas' {ShowLogsForm},
  ShowUsersUnit in 'UsersShow\ShowUsersUnit.pas' {ShowUsersForm},
  ShowTuningUnit in 'TuningShow\ShowTuningUnit.pas' {ShowTuningForm},
  ShowActiveAlarmsUnit in 'ActiveLogs\ShowActiveAlarmsUnit.pas' {ShowActiveAlarmsForm},
  ShowActiveSwitchsUnit in 'ActiveLogs\ShowActiveSwitchsUnit.pas' {ShowActiveSwitchsForm},
  ShowSplashUnit in 'RemXForm\ShowSplashUnit.pas' {ShowSplashForm},
  ShowHistGroupUnit in 'Browser\ShowHistGroupUnit.pas' {ShowHistGroupForm},
  ShowTablesUnit in 'Trends\ShowTablesUnit.pas' {ShowTablesForm},
  ShowTrendsUnit in 'Trends\ShowTrendsUnit.pas' {ShowTrendsForm},
  ShowPreviewUnit in 'PreviewForm\ShowPreviewUnit.pas' {ShowPreviewForm},
  ShowReportUnit in 'ReportShow\ShowReportUnit.pas' {ShowReportsForm},
  ShowReportLogUnit in 'ReportShow\ShowReportLogUnit.pas' {ShowReportLogsForm},
  ShowRealTrendUnit in 'Trends\ShowRealTrendUnit.pas' {ShowRealTrendForm},
  DinElementsUnit in 'SchemeEdit\DinElementsUnit.pas',
  DinJumperEditorUnit in 'SchemeEdit\DinJumperEditorUnit.pas' {DinJumperEditorForm},
  DinAnalogEditorUnit in 'SchemeEdit\DinAnalogEditorUnit.pas' {DinAnalogEditorForm},
  DinValveEditorUnit in 'SchemeEdit\DinValveEditorUnit.pas' {DinValveEditorForm},
  DinButtonEditorUnit in 'SchemeEdit\DinButtonEditorUnit.pas' {DinButtonEditorForm},
  DinLineEditorUnit in 'SchemeEdit\DinLineEditorUnit.pas' {DinLineEditorForm},
  DinNodeEditorUnit in 'SchemeEdit\DinNodeEditorUnit.pas' {DinNodeEditorForm},
  DinUnitEditorUnit in 'SchemeEdit\DinUnitEditorUnit.pas' {DinUnitEditorForm},
  DinTextEditorUnit in 'SchemeEdit\DinTextEditorUnit.pas' {DinTextEditorForm},
  DinDigitalEditorUnit in 'SchemeEdit\DinDigitalEditorUnit.pas' {DinDigitalEditorForm},
  DinKonturEditorUnit in 'SchemeEdit\DinKonturEditorUnit.pas' {DinKonturEditorForm},
  EditSchemeUnit in 'SchemeEdit\EditSchemeUnit.pas' {EditSchemeForm},
  EditDinAlignmentUnit in 'SchemeEdit\EditDinAlignmentUnit.pas' {EditDinAlignmentForm},
  EditDinSizeUnit in 'SchemeEdit\EditDinSizeUnit.pas' {EditDinSizeForm},
  EditReportUnit in 'ReportEdit\EditReportUnit.pas' {EditReportForm},
  KontrastUnit in 'Kontrast\KontrastUnit.pas',
  KontSMEditUnit in 'Kontrast\KontSMEditUnit.pas' {KontSMEditForm},
  KontAOEditUnit in 'Kontrast\KontAOEditUnit.pas' {KontAOEditForm},
  KontAPEditUnit in 'Kontrast\KontAPEditUnit.pas' {KontAPEditForm},
  KontCREditUnit in 'Kontrast\KontCREditUnit.pas' {KontCREditForm},
  KontDOEditUnit in 'Kontrast\KontDOEditUnit.pas' {KontDOEditForm},
  KontDPEditUnit in 'Kontrast\KontDPEditUnit.pas' {KontDPEditForm},
  KontFDEditUnit in 'Kontrast\KontFDEditUnit.pas' {KontFDEditForm},
  KontGREditUnit in 'Kontrast\KontGREditUnit.pas' {KontGREditForm},
  KontKDEditUnit in 'Kontrast\KontKDEditUnit.pas' {KontKDEditForm},
  KontNDPaspUnit in 'Kontrast\KontNDPaspUnit.pas' {KontNDPaspForm},
  KontAOPaspUnit in 'Kontrast\KontAOPaspUnit.pas' {KontAOPaspForm},
  KontAPPaspUnit in 'Kontrast\KontAPPaspUnit.pas' {KontAPPaspForm},
  KontCRPaspUnit in 'Kontrast\KontCRPaspUnit.pas' {KontCRPaspForm},
  KontDOPaspUnit in 'Kontrast\KontDOPaspUnit.pas' {KontDOPaspForm},
  KontDPPaspUnit in 'Kontrast\KontDPPaspUnit.pas' {KontDPPaspForm},
  KontFDPaspUnit in 'Kontrast\KontFDPaspUnit.pas' {KontFDPaspForm},
  KontGOPaspUnit in 'Kontrast\KontGOPaspUnit.pas' {KontGOPaspForm},
  KontGPPaspUnit in 'Kontrast\KontGPPaspUnit.pas' {KontGPPaspForm},
  KontGRPaspUnit in 'Kontrast\KontGRPaspUnit.pas' {KontGRPaspForm},
  KontKDPaspUnit in 'Kontrast\KontKDPaspUnit.pas' {KontKDPaspForm},
  ModbusUnit in 'Modbus\ModbusUnit.pas',
  ModbusDOEditUnit in 'Modbus\ModbusDOEditUnit.pas' {ModbusDOEditForm},
  ModbusAOEditUnit in 'Modbus\ModbusAOEditUnit.pas' {ModbusAOEditForm},
  ModbusDOPaspUnit in 'Modbus\ModbusDOPaspUnit.pas' {ModbusDOPaspForm},
  ModbusAOPaspUnit in 'Modbus\ModbusAOPaspUnit.pas' {ModbusAOPaspForm},
  CommonDialogUnit in 'RemXForm\CommonDialogUnit.pas' {CommonDialogForm},
  PrintDialogUnit in 'RemXForm\PrintDialogUnit.pas' {PrintDialogForm},
  ChoicesUnit in 'Browser\ChoicesUnit.pas' {DualListDlg},
  OpenDialogUnit in 'RemXForm\OpenDialogUnit.pas' {OpenDialogForm},
  OpenExtDialogUnit in 'RemXForm\OpenExtDialogUnit.pas' {OpenExtDialogForm},
  SaveExtDialogUnit in 'RemXForm\SaveExtDialogUnit.pas' {SaveExtDialogForm},
  FindDialogUnit in 'RemXForm\FindDialogUnit.pas' {FindDialogForm},
  SetKonturOPUnit in 'Entity\SetKonturOPUnit.pas' {SetKonturOPDlg},
  TabOrderUnit in 'SchemeEdit\TabOrderUnit.pas' {TabOrderForm},
  KontNDEditUnit in 'Kontrast\KontNDEditUnit.pas' {KontNDEditForm},
  KontDXEditUnit in 'Kontrast\KontDXEditUnit.pas' {KontDXEditForm},
  KontDXPaspUnit in 'Kontrast\KontDXPaspUnit.pas' {KontDXPaspForm},
  PngImage1 in 'Thtml\PngImage1.pas',
  PNGZLIB1 in 'Thtml\PNGZLIB1.pas',
  StationsNetLink in 'NetLinkEx\StationsNetLink.pas',
  ComPort in 'SerialLink\ComPort.pas',
  KontLink in 'SerialLink\KontLink.pas',
  VirtASPaspUnit in 'Virtual\VirtASPaspUnit.pas' {VirtASPaspForm},
  CalcDensUnit in 'Virtual\CalcDensUnit.pas',
  VirtVTEditUnit in 'Virtual\VirtVTEditUnit.pas' {VirtVTEditForm},
  KontINREditUnit in 'Kontrast\KontINREditUnit.pas' {KontINREditForm},
  ModbusDMEditUnit in 'Modbus\ModbusDMEditUnit.pas' {ModbusDMEditForm},
  ModbusAMEditUnit in 'Modbus\ModbusAMEditUnit.pas' {ModbusAMEditForm},
  RmxConnection in 'RmxConnection.pas',
  PanelFormUnit in 'PanelForm\PanelFormUnit.pas' {PanelForm},
  XmlConfigUnit in 'XmlConfig\XmlConfigUnit.pas',
  TCPLink in 'NetLinkEx\TCPLink.pas',
  VirtCAEditUnit in 'Virtual\VirtCAEditUnit.pas' {VirtCAEditForm},
  CAExprUnit in 'Virtual\CAExprUnit.pas' {FormCAExpr},
  VirtCAPaspUnit in 'Virtual\VirtCAPaspUnit.pas' {VirtCAPaspForm},
  KontUDEditUnit in 'Kontrast\KontUDEditUnit.pas' {KontUDEditForm};

{$R *.res}

var HM: THandle;

function Check: boolean;
begin
  HM := OpenMutex(MUTEX_ALL_ACCESS, false, 'RemXSystemMutex');
  Result := (HM <> 0);
  if HM = 0 then HM := CreateMutex(nil, false, 'RemXSystemMutex');
end;

begin
  if not ((ParamCount > 0) and (ParamStr(1) = 'client')) then
  begin
    if Check then Exit;
  end;
  ShowSplash;
  Application.Initialize;
  Application.ShowMainForm := False;  
  Application.Title := 'RemX';
  Application.CreateForm(TRemXForm, RemXForm);
  Application.Run;
end.
