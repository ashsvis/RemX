unit EntityUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Contnrs, Forms, Controls,
  SyncObjs, ExtCtrls, IniFiles, StationsNetLink, ComPort, KontLink,
  XmlConfigUnit, TCPLink, MMSystem, DB, ADODB;

const
  WM_AppStart = WM_USER + 100;
  WM_Fresh = WM_USER + 101;
  WM_TableFresh = WM_USER + 102;
  WM_TrendFresh = WM_USER + 103;
  WM_ShiftRemove = WM_USER + 104;
  WM_ThreadFinished = WM_USER + 105;
  WM_LogFresh = WM_USER +106;
  WM_ExprFormShow = WM_USER +107;
  WM_FuncFormShow = WM_USER +108;
  WM_AveragesFresh = WM_USER + 109;
  WM_DinButtonClick = WM_USER + 110;
  WM_DinJumperClick = WM_USER + 111;
  WM_CommandResult = WM_USER + 112;
  WM_RealTrend = WM_USER + 113;
  WM_ConnectBaseEditor = WM_USER + 114;
  WM_DinKonturClick = WM_USER + 115;
  WM_SelectDin = WM_USER + 116;

  TH_SaveTableTrends = 1;
  ChannelCount = 16;

type
  TLogType = (ltAlarmLog,ltSwitchLog,ltChangeLog,ltSystemLog);
  TTableType = (ttMinSnap,ttHourSnap,ttHourAver);

  TAlarmState = (asNoLink,asShortBadPV,asOpenBadPV,asBadPV,asHH,asLL,asON,asOFF,
                 asHi,asLo,asDH,asDL,asInfo,asTimeOut,asNone);

const
  ALogs: array[TLogType] of string = ('ALARMS','SWITCHS','CHANGES','SYSMESS');

  ATableType: array[TTableType] of string =
      ('MinSnap','HourSnap','HourAver');

  AAlarmText: array[TAlarmState] of string =
      ('NOLINK',
       'BADPV',
       'BADPV',
       'BADPV',
       'PVHH',
       'PVLL',
       'ALMON',
       'ALMOFF',
       'PVHI',
       'PVLO',
       'PVDH',
       'PVDL',
       'INFO',
       'TIMOUT',
       'NONE');
  AAlarmState: array[TAlarmState] of string =
      ('��� ����� � �����������',
       '������ �������� (�.�.)',
       '������ �������� (�����)',
       '������������ ���������',
       '������� ������������� �������',
       '������ ������������� �������',
       '��������� "ON"',
       '��������� "OFF"',
       '������� ����������������� �������',
       '������ ����������������� �������',
       '��������������� �����',
       '��������������� ����',
       '��������� �����������',
       '����� �����',
       '��� ��������� ���������');

  ABrushColor: array[TAlarmState,Boolean,Boolean,Boolean] of TColor =
   (
    (((clBlack,clGray),(clBlack,clBlack)),((clBlack,clBlue),(clBlue,clBlue))),
    (((clBlack,clGray),(clBlack,clBlack)),((clBlack,clFuchsia),(clFuchsia,clFuchsia))),
    (((clBlack,clGray),(clBlack,clBlack)),((clBlack,clFuchsia),(clFuchsia,clFuchsia))),
    (((clBlack,clGray),(clBlack,clBlack)),((clBlack,clRed),(clRed,clRed))),
    (((clBlack,clGray),(clBlack,clBlack)),((clBlack,clRed),(clRed,clRed))),
    (((clBlack,clGray),(clBlack,clBlack)),((clBlack,clRed),(clRed,clRed))),
    (((clBlack,clGray),(clBlack,clBlack)),((clBlack,clRed),(clRed,clRed))),
    (((clBlack,clGray),(clBlack,clBlack)),((clBlack,clRed),(clRed,clRed))),
    (((clBlack,clGray),(clBlack,clBlack)),((clBlack,clYellow),(clYellow,clYellow))),
    (((clBlack,clGray),(clBlack,clBlack)),((clBlack,clYellow),(clYellow,clYellow))),
    (((clBlack,clGray),(clBlack,clBlack)),((clBlack,clYellow),(clYellow,clYellow))),
    (((clBlack,clGray),(clBlack,clBlack)),((clBlack,clYellow),(clYellow,clYellow))),
    (((clBlack,clGray),(clBlack,clBlack)),((clBlack,clYellow),(clYellow,clYellow))),
    (((clBlack,clGray),(clBlack,clBlack)),((clBlack,clRed),(clRed,clRed))),
    (((clBlack,clBlack),(clBlack,clBlack)),((clBlack,clBlack),(clBlack,clBlack)))
    );

  AFontColor: array[TAlarmState,Boolean,Boolean,Boolean] of TColor =
   (
    (((clGray,clBlack),(clAqua,clAqua)),((clGray,clYellow),(clYellow,clYellow))),
    (((clGray,clBlack),(clAqua,clAqua)),((clGray,clWhite),(clWhite,clWhite))),
    (((clGray,clBlack),(clAqua,clAqua)),((clGray,clWhite),(clWhite,clWhite))),
    (((clGray,clBlack),(clAqua,clAqua)),((clGray,clWhite),(clWhite,clWhite))),
    (((clGray,clBlack),(clAqua,clAqua)),((clGray,clWhite),(clWhite,clWhite))),
    (((clGray,clBlack),(clAqua,clAqua)),((clGray,clWhite),(clWhite,clWhite))),
    (((clGray,clBlack),(clAqua,clAqua)),((clGray,clWhite),(clWhite,clWhite))),
    (((clGray,clBlack),(clAqua,clAqua)),((clGray,clWhite),(clWhite,clWhite))),
    (((clGray,clBlack),(clAqua,clAqua)),((clGray,clBlack),(clBlack,clBlack))),
    (((clGray,clBlack),(clAqua,clAqua)),((clGray,clBlack),(clBlack,clBlack))),
    (((clGray,clBlack),(clAqua,clAqua)),((clGray,clBlack),(clBlack,clBlack))),
    (((clGray,clBlack),(clAqua,clAqua)),((clGray,clBlack),(clBlack,clBlack))),
    (((clGray,clBlack),(clAqua,clAqua)),((clGray,clBlack),(clBlack,clBlack))),
    (((clGray,clBlack),(clAqua,clAqua)),((clGray,clWhite),(clWhite,clWhite))),
    (((clBlack,clBlack),(clBlack,clBlack)),((clBlack,clBlack),(clBlack,clBlack)))
    );

  ADinColor: array[TAlarmState,Boolean,Boolean,Boolean] of TColor =
   (   {������� ������}                   {��������� ������} {��������� ����}
    (((clBlack,clSilver),(clNone,clNone)),((clBlack,clBlue),(clBlue,clBlue))),           // asNoLink
    (((clBlack,clSilver),(clNone,clNone)),((clBlack,clFuchsia),(clFuchsia,clFuchsia))),  // asShortBadPV
    (((clBlack,clSilver),(clNone,clNone)),((clBlack,clFuchsia),(clFuchsia,clFuchsia))),  // asOpenBadPV
    (((clBlack,clSilver),(clNone,clNone)),((clBlack,clRed),(clRed,clRed))),              // asBadPV
    (((clNone,clDefault),(clNone,clNone)),((clYellow,clRed),(clRed,clRed))),              // asHH
    (((clNone,clDefault),(clNone,clNone)),((clYellow,clRed),(clRed,clRed))),              // asLL
    (((clBlack,clSilver),(clNone,clNone)),((clBlack,clRed),(clRed,clRed))),              // asON
    (((clBlack,clSilver),(clNone,clNone)),((clBlack,clRed),(clRed,clRed))),              // asOFF
    (((clNone,clDefault),(clNone,clNone)),((clNone,clYellow),(clYellow,clYellow))),     // asHi
    (((clNone,clDefault),(clNone,clNone)),((clNone,clYellow),(clYellow,clYellow))),     // asLo
    (((clBlack,clSilver),(clNone,clNone)),((clBlack,clYellow),(clYellow,clYellow))),     // asDH
    (((clBlack,clSilver),(clNone,clNone)),((clBlack,clYellow),(clYellow,clYellow))),     // asDL
    (((clBlack,clSilver),(clNone,clNone)),((clBlack,clYellow),(clYellow,clYellow))),     // asInfo
    (((clBlack,clSilver),(clNone,clNone)),((clBlack,clRed),(clRed,clRed))),              // asTimeOut
    (((clBlack,clBlack),(clNone,clNone)),((clBlack,clBlack),(clBlack,clBlack)))          // asNone
    );

type
  TCashReportItem = record
     SnapTime: TDateTime;
     Station: Byte;
     HandStart: Boolean;
     Category: string[16];
     Descriptor: string[96];
  end;

  TSetAlarmStatus = set of TAlarmState;
  TSetSwitchStatus = set of TAlarmState;

  TEntityKind = (ekNone,ekGroup,ekDigit,ekAnalog,ekKontur,ekComposit,ekCustom);
  TEntityNotify = (enRename,enDelete);

  TCustomGroup = class;
  TCaddy = class;

  TKindStatus = record
    AlarmStatus: TSetAlarmStatus;
    ConfirmStatus: TSetAlarmStatus;
    LostAlarmStatus: TSetAlarmStatus;
  end;

  TCashRealBaseItem = record
    ParamName: string[20];
    SnapTime: TDateTime;
    Value: Double;
    ValText: string[30];
    Kind: TKindStatus;
  end;
  TCashRealBaseArray = record
                         Body: array[1..50000] of TCashRealBaseItem;
                         Length: integer;
                       end;

  TEntity = class
  private
    FIsParam: boolean;
    FHasCommand: boolean;
    procedure SetPtName(const Value: string);
    procedure SetPtDesc(const Value: string);
    procedure SetActived(const Value: boolean);
    procedure SetAsked(const Value: boolean);
    procedure SetFetchTime(const Value: DWord);
    procedure SetSourceEntity(const Value: TCustomGroup);
    procedure SetBlock(const Value: word);
    procedure SetChannel(const Value: word);
    procedure SetNode(const Value: word);
    procedure SetPlace(const Value: word);
    procedure SetAlarmStatus(const Value: TSetAlarmStatus);
    procedure SetConfirmStatus(const Value: TSetAlarmStatus);
    procedure SetLogged(const Value: boolean);
    procedure SetFetchData(const Value: string);
    procedure SetHasCommand(const Value: boolean);
  protected
    FIsCommand: boolean;
    LastTicks: DWord;
    LastTime: DWord;
    FRaw: Double;
    FConfirmStatus: TSetAlarmStatus;
    FAlarmStatus: TSetAlarmStatus;
    FSwitchStatus: TSetAlarmStatus;
    FAsked: boolean;
    FActived: boolean;
    FPtName: string;
    FPtDesc: string;
    FRealTime: DWord;
    FFetchTime: DWord;
    FChannel: word;
    FNode: word;
    FBlock: word;
    FPlace: word;
    FIsGroup: boolean;
    FIsVirtual: boolean;
    FIsDigit: boolean;
    FIsAnalog: boolean;
    FIsCustom: boolean;
    FIsComposit: boolean;
    FIsKontur: boolean;
    FIsTrending: boolean;
    FEntityKind: TEntityKind;
    FSourceEntity: TCustomGroup;
    FSourceName: string;
    FHeaderWait: boolean;
    FFetchData: string;
    procedure SetRaw(const Value: Double); virtual;
    procedure SetRealTime(const Value: DWord); virtual;
    function GetBlockName: string; virtual;
    function GetPlaceName: string; virtual;
    function GetTextValue: string; virtual;
    function GetPtVal: string; virtual;
    function GetFetchData: string; virtual;
  public
    FLogged: boolean;
    PtClass: String[255];
    ClassIndex: integer;
    PrevEntity,NextEntity: TEntity;
    ErrorMess: String[255];
    OldConfirmStatus: TSetAlarmStatus;
    OldAlarmStatus: TSetAlarmStatus;
    LostAlarmStatus: TSetAlarmStatus;
    CommandMode: Byte;
    CommandData: Single;
    FirstCalc: boolean;
    LocalFetchOnly: boolean;
    TimeOutCounter: byte;
    FetchIndex: integer;
    RepeatIndex: integer;
    RemoteCommandText: String[255];
    LinkScheme: String[255];
    GoodFetchsCount,BadFetchsCount,BadFatalFetchsCount: Int64;
    MaxAnswerTime: Cardinal;
    constructor Create; virtual;
    destructor Destroy; override;
    class function EntityType: string; virtual; abstract;
    class function TypeCode: string; virtual; abstract;
    class function TypeColor: TColor; virtual; abstract;
    class function TypePict(Bmp: TBitmap): TBitmap;
    function PropsCount: integer; virtual; abstract;
    class function PropsID(Index: integer): string; virtual; abstract;
    class function PropsName(Index: integer): string; virtual; abstract;
    function PropsValue(Index: integer): string; virtual; abstract;
    procedure ConnectLinks; virtual;
    procedure RequestData; virtual;
//    procedure RequestAfterCommand;
    procedure Synchronize;
    procedure Notify(Kind: TEntityNotify; E: TEntity); virtual;
    procedure Assign(E: TEntity); virtual;
    procedure SaveToStream(Stream: TStream); virtual; abstract;
    procedure SaveToText(List: TStringList); virtual; abstract;
    function LoadFromStream(Stream: TStream): integer; virtual; abstract;
    function Prepare: string; virtual;
    procedure Fetch(const Data: string = ''); virtual;
    procedure SetParam(ParamName: string; Item: TCashRealBaseItem); virtual;
    function GetAlarmState(var Alarm: TAlarmState): Boolean;
    procedure SendIMPULSE; virtual; abstract;
    procedure ShowPassport(const MonitorNum: integer); virtual;
    procedure ShowParentPassport(const MonitorNum: integer); virtual;
    procedure ShowEditor(const MonitorNum: integer); virtual;
    procedure ShowScheme(const MonitorNum: integer); virtual;
    function AddressEqual(E: TEntity): boolean; virtual;
    procedure SendOP(Value: Single); virtual; abstract;
    procedure UpdateRealTime;
    property HasCommand: boolean read FHasCommand write SetHasCommand;
    property Block: word read FBlock write SetBlock;
    property Place: word read FPlace write SetPlace;
    property RealTime: DWord read FRealTime write SetRealTime;
    property SourceEntity: TCustomGroup read FSourceEntity write SetSourceEntity;
    property IsGroup: boolean read FIsGroup;
    property IsDigit: boolean read FIsDigit;
    property IsAnalog: boolean read FIsAnalog;
    property IsComposit: boolean read FIsComposit;
    property IsCustom: boolean read FIsCustom;
    property IsVirtual: boolean read FIsVirtual;
    property IsParam: boolean read FIsParam;
    property IsKontur: boolean read FIsKontur;
    property IsTrending: boolean read FIsTrending;
    property IsCommand: boolean read FIsCommand;
    property Raw: Double read FRaw write SetRaw;
    property AlarmStatus: TSetAlarmStatus read FAlarmStatus write SetAlarmStatus;
    property ConfirmStatus: TSetAlarmStatus read FConfirmStatus write SetConfirmStatus;
    property PtText: string read GetTextValue;
    property PtVal: string read GetPtVal;
    property PtName: string read FPtName write SetPtName;
    property PtDesc: string read FPtDesc write SetPtDesc;
    property Actived: boolean read FActived write SetActived;
    property Asked: boolean read FAsked write SetAsked;
    property Logged: boolean read FLogged write SetLogged;
    property FetchTime: DWord read FFetchTime write SetFetchTime;
    property SourceName: string read FSourceName;
    property EntityKind: TEntityKind read FEntityKind;
    property Channel: word read FChannel write SetChannel;
    property Node: word read FNode write SetNode;
    property FetchData: string read GetFetchData write SetFetchData;
  end;

  IFresh = interface(IInterface)
    ['{467B21A4-472C-4A2B-9B22-E3B7F2254158}']
    procedure FreshView; stdcall;
  end;

  IEntity = interface(IInterface)
    ['{5140E694-5191-4F79-ACFC-AB493FB360A1}']
    procedure ConnectEntity(Entity: TEntity); stdcall;
    procedure ConnectImageList(ImageList: TImageList); stdcall;
    procedure UpdateRealTime; stdcall;
  end;

  ISendOP = interface(IInterface)
    ['{06CF551E-7485-4081-B512-76C84E3039E6}']
    procedure SendOP(Value: Boolean); stdcall;
  end;

  TEntityClass = class of TEntity;
  TFormClass = class of TForm;

  TActiveAlarmLogItem = class
  public
    ImageIndex: integer;
    Source: TEntity;
    Kind: TAlarmState;
    SnapTime: TDateTime;
    AlarmStatus,ConfirmStatus: TSetAlarmStatus;
    Position,Value,SetPoint,Mess,Descriptor: string;
  end;

  TActiveSwitchLogItem = class
  public
    ImageIndex: integer;
    Kind: TAlarmState;
    SnapTime: TDateTime;
    Position,Value,Descriptor: string;
  end;

//===================================

  TCashAlarmLogItem = record
    SnapTime: TDateTime;
    Station: Byte;
    Position,Parameter,Value,SetPoint: string[16];
    Mess,Descriptor: string[48];
  end;
  TCashAlarmLogArray = record
                         Body: array[1..3000] of TCashAlarmLogItem;
                         Length: integer;
                       end;

  TCashSwitchLogItem = record
    SnapTime: TDateTime;
    Station: Byte;
    Position,Parameter,OldValue,NewValue: string[16];
    Descriptor: string[48];
  end;
  TCashSwitchLogArray = record
                          Body: array[1..3000] of TCashSwitchLogItem;
                          Length: integer;
                        end;

  TCashChangeLogItem = record
    SnapTime: TDateTime;
    Station: Byte;
    Position,Parameter,Autor: string[16];
    OldValue,NewValue: string[20];
    Descriptor: string[48];
  end;
  TCashChangeLogArray = record
                          Body: array[1..3000] of TCashChangeLogItem;
                          Length: integer;
                        end;

  TCashSystemLogItem = record
    SnapTime: TDateTime;
    Station: Byte;
    Position: string[16];
    Descriptor: string[96];
  end;
  TCashSystemLogArray = record
                          Body: array[1..3000] of TCashSystemLogItem;
                          Length: integer;
                        end;
//===================================

  TCashRealTrendItem = record
    ParamName: string[20];
    SnapTime: TDateTime;
    Value: Single;
    Kind: boolean;
  end;
  TCashRealTrendArray = record
                          Body: array[1..1000] of TCashRealTrendItem;
                          Length: integer;
                        end;

  THistGroups = array[1..125] of record
                  GroupName: string[255];
                  Empty: boolean;
                  Place: array[1..8] of string[10];
                  Entity: array[1..8] of TEntity;
                  Kind: array[1..8] of Byte;
                  EU: array[1..8] of string[10];
                  DF: array[1..8] of Byte;
  end;

  TCashTrendTableItem = record
    SnapTime: TDateTime;
    GroupNo: integer;
    Val: array[1..8] of Single;
    Quality: array[1..8] of Boolean;
  end;
  TCashGroupTableArray = record
                            Body: array[1..125] of TCashTrendTableItem;
                            Length: integer;
                          end;

  TCashExportTableItem = record
    SnapTime: TDateTime;
    Position: string[20];
    Val: Single;
  end;
  TCashExportTableArray = record
                            Body: array[1..1000] of TCashExportTableItem;
                            Length: integer;
                          end;

  TKindMessage = (kmError, kmWarning, kmInfo, kmStatus, kmLog);

  TCaddyMessage = procedure(Sender: TObject;
                            Kind: TKindMessage; Mess: string) of object;
  TCaddyQuestion = procedure(Sender: TObject; Question: string;
                             var Result: boolean) of object;

  TFetchList = record
    UseNet: Boolean;
    ComLink: TKontLink;
    TcpLink: TTcpLink;
    NodeWait: Cardinal;
    List: TList;
    ReqEnt: TEntity;
    SaveToLog: boolean;
    TickCount: DWORD;
    TimeOut: integer;
    RepeatCount: integer;
    LinkType: integer;
    FetchNodes: Cardinal;
  end;

  TRestoreEntity = procedure (E: TEntity) of object;
  TBaseEditForm = class(TForm)
  private
    FChangePtNameClick: TNotifyEvent;
    FDoubleEntityClick: TNotifyEvent;
    FDeleteEntityClick: TNotifyEvent;
    FUpdateBaseView: TNotifyEvent;
    FRestoreEntityPos: TRestoreEntity;
  public
    property ChangePtNameClick: TNotifyEvent read FChangePtNameClick
                                             write FChangePtNameClick;
    property DoubleEntityClick: TNotifyEvent read FDoubleEntityClick
                                             write FDoubleEntityClick;
    property DeleteEntityClick: TNotifyEvent read FDeleteEntityClick
                                             write FDeleteEntityClick;
    property UpdateBaseView: TNotifyEvent read FUpdateBaseView
                                          write FUpdateBaseView;
    property RestoreEntityPos: TRestoreEntity read FRestoreEntityPos
                                            write FRestoreEntityPos;
  end;

  TBeeperKind = (bkNone,bkSpeaker,bkCard);
  TBeeper = class (TThread)
  private
    Section: TCriticalSection;
    NowSay: TSetAlarmStatus;
    Caddy: TCaddy;
    FKind: TBeeperKind;
    procedure SetKind(const Value: TBeeperKind);
    function GetKind: TBeeperKind;
  protected
    procedure Execute; override;
  public
    constructor Create(ACaddy: TCaddy; AKind: TBeeperKind);
    destructor Destroy; override;
    procedure Say(What: TSetAlarmStatus);
    procedure ShortUp;
    property Kind: TBeeperKind read GetKind write SetKind;
  end;

  TShowPassport = procedure (E: TEntity; const MonitorNum: integer) of object;
  TShowEditor = procedure (E: TEntity; const MonitorNum: integer) of object;
  TShowScheme = procedure (E: TEntity; const MonitorNum: integer) of object;
  TNetRole = (nrStandAlone,nrServer,nrClient);

  TCaddy = class(TWinControl)
  private
    CashAlarmLog: TCashAlarmLogArray;
    CashSwitchLog: TCashSwitchLogArray;
    CashChangeLog: TCashChangeLogArray;
    CashSystemLog: TCashSystemLogArray;
    CashExportMinuteSnap: TCashExportTableArray;
    CashMinuteSnap: TCashGroupTableArray;
    CashHourSnap: TCashGroupTableArray;
    CashRealTrend: TCashRealTrendArray;
    CashRealValues: TCashRealBaseArray;
    FOnAlarmLogUpdate: array of TNotifyEvent;
    FOnSwitchLogUpdate: array of TNotifyEvent;
    FHistChanged: boolean;
    FOnMessage: TCaddyMessage;
    FOnShowPassport: TShowPassport;
    FOnShowEditor: TShowEditor;
    FOnShowScheme: TShowScheme;
    FOnQuestion: TCaddyQuestion;
    FShortUserName: string;
    FLongUserName: string;
    procedure SetHistChanged(const Value: boolean);
    procedure ShowThreadMessage(Sender: TObject; Mess: string);
    procedure LogThreadMessage(Sender: TObject; Mess: string);
    function AddEntityNoname(ClassIndex: integer;
      PtClass: TEntityClass): TEntity;
    procedure SetLongUserName(const Value: string);
    procedure SetOnAlarmLogUpdate(const Value: TNotifyEvent);
    procedure SetOnSwitchLogUpdate(const Value: TNotifyEvent);
  protected
  public
    Beeper: TBeeper;
    Station: SmallInt;
    UseNet: boolean;
    FetchList: array[0..ChannelCount] of TFetchList;
    StationsLink: TStationsLink;
    FetchRun: boolean;
    FirstEntity: TEntity;
    LastEntity: TEntity;
    Changed: boolean;
    Autor: string;
    ActiveAlarmLog: TObjectList;
    ActiveSwitchLog: TObjectList;
    EntityOwner: TObjectList;
    HistGroups: THistGroups;
    UserLevel: integer;
    BeeperKind: TBeeperKind;
    NetRole: TNetRole;
    ConnectionString: string;
    ExportActive: Boolean;
    CurrentBasePath: string;
    CurrentTrendPath: string;
    CurrentTablePath: string;
    CurrentLogsPath: string;
    CurrentSchemsPath: string;
    CurrentReportsPath: string;
    CurrentReportsLogPath: string;
    TrendOldTimes,SnapMinOldTimes,SnapHourOldTimes,
    AverHourOldTimes,LogOldTimes,ReportLogOldTimes: integer;
    NetClientConnected: boolean;
    Blink: boolean;
    DigErrFilter: boolean;
    NoAsk: boolean; // ��������� 15.07.12
    NoAddNoLinkInAciveLog: Boolean;
    ScreenSizeIndex: Integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function AddEntity(PtName: string; ClassIndex: integer;
                       PtClass: TEntityClass): TEntity;
    procedure RenameEntity(E: TEntity; NewName: string);
    procedure DeleteEntity(E: TEntity);
    procedure FetchExecute;
    function Find(const PtName: string): TEntity;
    procedure LoadBase(const BasePath: string);
    procedure LoadSchemes(const SchemesPath: string);
    function LoadValuesFromRealBase(FileName: string): boolean;
    procedure SaveValuesToRealBase(const FileName: string);
    procedure SaveBase(BasePath: string);
    procedure EmptyBase;
    procedure SaveHistGroups(BasePath: string);
    procedure SaveHistGroupsToINI(BasePath: string);
    procedure SaveBaseToXML;
    procedure SaveBaseToINI;
    procedure LoadHistGroups(BasePath: string);
    procedure AddChange(Position,Parameter,OldValue,NewValue,
                                  Descriptor,Autor: string);
    procedure SaveCashToAlarmLog;
    procedure SaveCashToSwitchLog;
    procedure SaveCashToChangeLog;
    procedure SaveCashToSystemLog;
    procedure SaveLogsToBaseLog(Path: string);
    procedure SaveCashToExportTables;
    procedure SaveCashToBaseTables;
    procedure SaveCashToBaseTrend;
    procedure SaveCashToRealBase;
    procedure DeleteOldFiles;
    procedure AddRealTrend(Param: string; Value: Single; Kind: boolean);
    procedure AddRealValue(Param: string; Value: Double; ValText: string;
                           Kind: TKindStatus);
    function ServerFindRealValue(Param: string;
                                 var Item: TCashRealBaseItem): boolean;
    procedure AddAlarm(AKind: TAlarmState; E: TEntity); overload;
    procedure AddAlarm(Position,Parameter,Value,SetPoint,
                                  Mess,Descriptor: string); overload;
    procedure RemoveAlarm(AKind: TAlarmState; E: TEntity);
    procedure RemoveAlarms(E: TEntity);
    procedure AddSwitch(AKind: TAlarmState; E: TEntity); overload;
    procedure AddSwitch(Position,Parameter,OldValue,NewValue,
                        Descriptor: string); overload;
    procedure RemoveSwitch(AKind: TAlarmState; E: TEntity);
    procedure RemoveSwitchs(E: TEntity);
    procedure AddSysMess(Position,Descriptor: string);
    procedure ExportMinuteTables;
    procedure UpdateMinuteTables;
    procedure UpdateHourTables;
    procedure SmartAskByIndex(Index: integer);
    procedure SmartAskByEntity(E: TEntity; Alarms: TSetAlarmStatus);
    procedure ThreadFinished(Sender: TObject);
    procedure ShowMessage(Kind: TKindMessage; Mess: string);
    function ShowQuestion(Question: string): boolean;
    function CheckValidAddress(Entity: TEntity): boolean;
    function CalcLastAlarm(E: TEntity;
                      var Alarm: TAlarmState; var IsLost: boolean): boolean;
    property OnAlarmLogUpdate: TNotifyEvent write SetOnAlarmLogUpdate;
    property OnSwitchLogUpdate: TNotifyEvent write SetOnSwitchLogUpdate;
    property HistChanged: boolean read FHistChanged write SetHistChanged;
    property OnMessage: TCaddyMessage read FOnMessage write FOnMessage;
    property OnShowPassport: TShowPassport read FOnShowPassport
                                           write FOnShowPassport;
    property OnShowEditor: TShowEditor read FOnShowEditor
                                       write FOnShowEditor;
    property OnShowScheme: TShowScheme read FOnShowScheme
                                       write FOnShowScheme;
    property OnQuestion: TCaddyQuestion read FOnQuestion write FOnQuestion;
    property LongUserName: string read FLongUserName write SetLongUserName;
    property ShortUserName: string read FShortUserName;
  end;

  TCustomGroup = class(TEntity)
  private
    function GetChildCount: integer;
  protected
    FChilds: TStrings;
    function GetEntityChilds(Index: Integer): TEntity;
    procedure SetEntityChilds(Index: Integer; const Value: TEntity); virtual;
    procedure SetRealTime(const Value: DWord); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    function GetMaxChildCount: integer; virtual; abstract;
    function IsEmpty: boolean;
    procedure ConnectLinks; override;
    procedure ChildYesFetch;
    procedure ChildNoFetch;
    property Count: integer read GetChildCount;
    property EntityChilds[Index: Integer]: TEntity read GetEntityChilds
                                                   write SetEntityChilds;
    procedure Notify(Kind: TEntityNotify; E: TEntity); override;
    procedure Decode(Value: Single); virtual;
    property Childs: TStrings read FChilds stored False;
  end;

  TDigColor = 0..15;
  TDinColor = 0..19;

const
  ArrayDigColor : array[TDigColor] of TColor =
    ($00282828,clNavy,clPurple,clMaroon,
     clBlue,clFuchsia,clRed,clTeal,
     clOlive,clGreen,clLime,clAqua,
     clYellow,clGray,clSilver,clWhite);
  StringDigColor : array[TDigColor] of string =
    ('׸����','Ҹ���-�����','����������','����������',
     '�����','�������','�������','Ҹ���-���������',
     '��������','������','����-������','���������',
     'Ƹ����','Ҹ���-�����','������-�����','�����');
  ArrayDinColor : array[TDinColor] of TColor =
    (clBlack,clMaroon,clGreen,clOlive,clNavy,clPurple,
     clTeal,clGray,clSilver,clRed,clLime,clYellow,clBlue,clFuchsia,
     clAqua,clWhite,clMoneyGreen,clSkyBlue,clCream,clMedGray);
  StringDinColor : array[TDinColor] of string =
    ('׸����','���������','������','���������','Ҹ���-�����',
     '���������','���������','Ҹ���-�����','������-�����','�������',
     '������-������','Ƹ����','�����','�������','�������','�����',
     '��������','�������-�������','��������','�����');
  AParamKind: array[0..3] of string = ('PV','SP','OP','LASTPV');

type
  TCustomDigOut = class(TEntity)
  private
    procedure SetAlarmDown(const Value: Boolean);
    procedure SetAlarmUp(const Value: Boolean);
    procedure SetColorDown(const Value: TDigColor);
    procedure SetColorUp(const Value: TDigColor);
    procedure SetInvert(const Value: Boolean);
    procedure SetSwitchDown(const Value: Boolean);
    procedure SetSwitchUp(const Value: Boolean);
    procedure SetTextDown(const Value: string);
    procedure SetTextUp(const Value: string);
  protected
    FPV: Boolean;
    FAlarmUp: Boolean;
    FSwitchDown: Boolean;
    FSwitchUp: Boolean;
    FAlarmDown: Boolean;
    FInvert: Boolean;
    FTextUp: string;
    FTextDown: string;
    FColorDown: TDigColor;
    FColorUp: TDigColor;
    procedure SetRaw(const Value: Double); override;
    procedure SetPV(const Value: Boolean); virtual;
    function GetBlockName: string; override;
    function GetPlaceName: string; override;
    function GetTextValue: string; override;
    function GetPtVal: string; override;
    property SwitchDown: Boolean read FSwitchDown write SetSwitchDown;
    property SwitchUp: Boolean read FSwitchUp write SetSwitchUp;
    property AlarmDown: Boolean read FAlarmDown write SetAlarmDown;
    property AlarmUp: Boolean read FAlarmUp write SetAlarmUp;
  public
    LastRaw: boolean;
    function TextLastValue: string;
    constructor Create; override;
    procedure Assign(E: TEntity); override;
    property Invert: Boolean read FInvert write SetInvert;
    property ColorDown: TDigColor read FColorDown write SetColorDown;
    property ColorUp: TDigColor read FColorUp write SetColorUp;
    property TextDown: string read FTextDown write SetTextDown;
    property TextUp: string read FTextUp write SetTextUp;
    property PV: Boolean read FPV write SetPV;
  end;

  TCustomDigInp = class(TEntity)
  private
    FOP: Boolean;
    procedure SetInvert(const Value: Boolean);
    procedure SetOP(const Value: Boolean);
  protected
    FInvert: Boolean;
    procedure SetRaw(const Value: Double); override;
    function GetBlockName: string; override;
    function GetPlaceName: string; override;
    function GetTextValue: string; override;
    function GetPTVal: string; override;
    property Invert: Boolean read FInvert write SetInvert;
  public
    constructor Create; override;
    procedure Assign(E: TEntity); override;
    property OP: Boolean read FOP write SetOP;
  end;

  TPVFormat = (pfD0,pfD1,pfD2,pfD3);
  TAlarmDeadband =(adNone,adZero,adHalf,adOne,adTwo,adThree,adFour,asFive);
const
  AAlmDB: array[TAlarmDeadband] of string =
     ('���������','�����','�0.5%','�1%','�2%','�3%','�4%','�5%');
type
  THex2Float = record
                 case Boolean of
                  False: (AsHex: Cardinal);
                  True:  (AsFloat: Single);
               end;

  TCustomAnaOut = class(TEntity)
  private
    FLASTPV: Double;
    procedure SetBadDB(const Value: TAlarmDeadband);
    procedure SetEUDesc(const Value: string);
    procedure SetHHDB(const Value: TAlarmDeadband);
    procedure SetHiDB(const Value: TAlarmDeadband);
    procedure SetLLDB(const Value: TAlarmDeadband);
    procedure SetLoDB(const Value: TAlarmDeadband);
    procedure SetPVEUHi(const Value: Single);
    procedure SetPVEULo(const Value: Single);
    procedure SetPVFormat(const Value: TPVFormat);
    procedure SetPVHHTP(const Value: Single);
    procedure SetPVHiTP(const Value: Single);
    procedure SetPVLLTP(const Value: Single);
    procedure SetPVLoTP(const Value: Single);
    procedure SetPVDHTP(const Value: Single);
    procedure SetPVDLTP(const Value: Single);
    procedure SetTrend(const Value: boolean);
    procedure SetCalcScale(const Value: boolean);
  protected
    FPVDLTP: Single;
    FPVDHTP: Single;
    FPVLoTP: Single;
    FPVHiTP: Single;
    FPV: Double;
    FPVLLTP: Single;
    FPVHHTP: Single;
    FPVEUHi: Single;
    FPVEULo: Single;
    FEUDesc: string;
    FHiDB: TAlarmDeadband;
    FLoDB: TAlarmDeadband;
    FLLDB: TAlarmDeadband;
    FBadDB: TAlarmDeadband;
    FHHDB: TAlarmDeadband;
    FPVFormat: TPVFormat;
    FH2F: THex2Float;
    FTrend: boolean;
    FCalcScale: boolean;
    procedure SetPV(const Value: Double); virtual;
    function GetBlockName: string; override;
    function GetPlaceName: string; override;
    procedure SetRaw(const Value: Double); override;
    function CalcDB(DBType: TAlarmDeadBand): Single;
    function GetTextValue: string; override;
    function GetPtVal: string; override;
    function GetLastPV: Double; virtual;
    property PVDHTP: Single read FPVDHTP write SetPVDHTP;
    property PVDLTP: Single read FPVDLTP write SetPVDLTP;
  public
    FOP: Single;
    FSP: Single;
    FSPEULo: Single;
    FSPEUHi: Single;
    constructor Create; override;
    procedure Assign(E: TEntity); override;
    function GetBrushAlarmColor(DefColor: TColor; Blink: boolean): TColor;
    function GetFontAlarmColor(DefColor: TColor; Blink: boolean): TColor;
    property PVFormat: TPVFormat read FPVFormat write SetPVFormat;
    property BadDB: TAlarmDeadband read FBadDB write SetBadDB;
    property PV: Double read FPV write SetPV;
    property EUDesc: string read FEUDesc write SetEUDesc;
    property PVEUHi: Single read FPVEUHi write SetPVEUHi;
    property PVEULo: Single read FPVEULo write SetPVEULo;
    property PVHHTP: Single read FPVHHTP write SetPVHHTP;
    property PVHiTP: Single read FPVHiTP write SetPVHiTP;
    property PVLLTP: Single read FPVLLTP write SetPVLLTP;
    property PVLoTP: Single read FPVLoTP write SetPVLoTP;
    property LASTPV: Double read GetLASTPV write FLASTPV;
    property CalcScale: boolean read FCalcScale write SetCalcScale;
    property Trend: boolean read FTrend write SetTrend;
    property HHDB: TAlarmDeadband read FHHDB write SetHHDB;
    property HiDB: TAlarmDeadband read FHiDB write SetHiDB;
    property LLDB: TAlarmDeadband read FLLDB write SetLLDB;
    property LoDB: TAlarmDeadband read FLoDB write SetLoDB;
  end;

  TCustomAnaInp = class(TEntity)
  private
    procedure SetEUDesc(const Value: string);
    procedure SetOPFormat(const Value: TPVFormat);
    procedure SetOPEUHi(const Value: Single);
    procedure SetOPEULo(const Value: Single);
    procedure SetOP(const Value: Single);
    procedure SetCalcScale(const Value: boolean);
  protected
    FCalcScale: boolean;
    FOP: Single;
    FOPEULo: Single;
    FOPEUHi: Single;
    FEUDesc: string;
    FOPFormat: TPVFormat;
    procedure SetRaw(const Value: Double); override;
    function GetBlockName: string; override;
    function GetPlaceName: string; override;
    function GetTextValue: string; override;
    function GetPtVal: string; override;
  public
    constructor Create; override;
    procedure Assign(E: TEntity); override;
    property OPFormat: TPVFormat read FOPFormat write SetOPFormat;
    property OP: Single read FOP write SetOP;
    property EUDesc: string read FEUDesc write SetEUDesc;
    property OPEUHi: Single read FOPEUHi write SetOPEUHi;
    property OPEULo: Single read FOPEULo write SetOPEULo;
    property CalcScale: boolean read FCalcScale write SetCalcScale;
  end;

  TCheckChange =(ccNone,ccOne,ccTwo,ccThree,ccFour,ccFive,ccTen,ccTwenty,
                                                 ccThirty,ccForty,ccFifty);
const
   ACtoStr: array[TCheckChange] of string =
     ('���������','�1%','�2%','�3%','�4%','�5%','�10%','�20%',
                                              '�30%','�40%','�50%');
   ACtoSingle: array[TCheckChange] of Single =
         (0.0,0.01,0.02,0.03,0.04,0.05,0.1,0.2,0.3,0.4,0.5);

type
  TRegType = (rtAnalog, rtImpulse);

const
  ARegType: array[TRegType] of string = ('����������','����������');

type
  TCustomCntReg = class(TCustomAnaOut)
  protected
    FMode: Word;
    FRegType: TRegType;
    FCheckSP: TCheckChange;
    FCheckOP: TCheckChange;
    procedure SetSP(const Value: Single); virtual; abstract;
    procedure SetOP(const Value: Single); virtual; abstract;
    procedure SetMode(const Value: Word); virtual; abstract;
    procedure SetRegType(const Value: TRegType); virtual; abstract;
    procedure SetSPEUHi(const Value: Single); virtual; abstract;
    procedure SetSPEULo(const Value: Single); virtual; abstract;
    procedure SetCheckOP(const Value: TCheckChange);
    procedure SetCheckSP(const Value: TCheckChange);
  public
    constructor Create; override;
    procedure SendSP(Value: Single); virtual; abstract;
    procedure SendCommand(Value: Byte); virtual; abstract;
    function HasCommandSP: boolean; virtual; abstract;
    function HasCommandOP: boolean; virtual; abstract;
    function HasCommandMode: boolean; virtual; abstract;
    property SP: Single read FSP write SetSP;
    property OP: Single read FOP write SetOP;
    property Mode: Word read FMode write SetMode;
    property RegType: TRegType read FRegType write SetRegType;
    property SPEUHi: Single read FSPEUHi write SetSPEUHi;
    property SPEULo: Single read FSPEULo write SetSPEULo;
    property CheckSP: TCheckChange read FCheckSP write SetCheckSP;
    property CheckOP: TCheckChange read FCheckOP write SetCheckOP;
  end;

  procedure CompressStream(aSource,aTarget: TStream);
  procedure DecompressStream(aSource,aTarget: TStream);

  function RegisterNode(NodeName: string): TList;

  function RegisterEntity(NewClass: TEntityClass): TEntityClass;
  procedure RegisterEditForm(NewClass: TFormClass);
  procedure RegisterPaspForm(NewClass: TFormClass);
  function EntityClassIndex(AClass: TClass): integer;

  function IsPortAvailable(PortIndex: integer): boolean;

  function NumToStr(Value: word; WordBase,SI,SR1,SR2: string;
                    ShowNumber: boolean = True): string;
  function LoadStream(FileName: string; Stream: TMemoryStream): boolean;
  function TryOpenToWriteFile(DirName,FileName: string): TFileStream;
  function TryOpenToReadFile(FileName: string): TFileStream;
  procedure ConfigUpdateFile(Config: TMemIniFile);
  function IsWinNT:Boolean;
  function Caddy(AOwner: TComponent = nil): TCaddy;
  procedure FreeAndNilCaddy;
  function NodeList: TStringList;
  procedure FreeAndNilNodeList;
  function EntityClassList: TClassList;
  function EditFormClassList: TClassList;
  function PaspFormClassList: TClassList;
  procedure FreeAndNilClassesList;
  procedure Wait500ms;

  var
    Config: TMemIniFile = nil;
    ConfigBase: TXmlIniFile = nil;
    PanelHeight, PanelWidth: integer;

implementation

uses Variants, Math, ZLib, StrUtils,  DinElementsUnit,
     CRCCalcUnit, Registry, DateUtils, ThreadSaveUnit;

var
  FCaddy: TCaddy = nil;
  FNodeList: TStringList = nil;
  FEntityClassList: TClassList = nil;
  FEditFormClassList: TClassList = nil;
  FPaspFormClassList: TClassList = nil;

  HiAlarm: Pointer = nil;
  LoAlarm: Pointer = nil;
  EuAlarm: Pointer = nil;

function Caddy(AOwner: TComponent = nil): TCaddy;
begin
  if (FCaddy = nil) then FCaddy := TCaddy.Create(AOwner);
  Result := FCaddy;
end;

procedure FreeAndNilCaddy;
begin
  FreeAndNil(FCaddy);
end;

function NodeList: TStringList;
begin
  if (FNodeList = nil) then FNodeList := TStringList.Create;
  Result := FNodeList;
end;

procedure FreeInternalNodeLists(L: TStringList);
var i: integer;
begin
  for i:=0 to L.Count-1 do L.Objects[i].Free;
end;

procedure FreeAndNilNodeList;
begin
  FreeInternalNodeLists(FNodeList);
  FreeAndNil(FNodeList);
end;

function EntityClassList: TClassList;
begin
  if (FEntityClassList = nil) then FEntityClassList := TClassList.Create;
  Result := FEntityClassList;
end;

function EditFormClassList: TClassList;
begin
  if (FEditFormClassList = nil) then FEditFormClassList := TClassList.Create;
  Result := FEditFormClassList;
end;

function PaspFormClassList: TClassList;
begin
  if (FPaspFormClassList = nil) then FPaspFormClassList := TClassList.Create;
  Result := FPaspFormClassList;
end;

procedure FreeAndNilClassesList;
begin
  FreeAndNil(FEntityClassList);
  FreeAndNil(FEditFormClassList);
  FreeAndNil(FPaspFormClassList);
end;

procedure ConfigUpdateFile(Config: TMemIniFile);
var FileName,BackName: string;
begin
  FileName:=Config.FileName;
  BackName:=ChangeFileExt(FileName,'.~ini');
  if FileExists(BackName) and DeleteFile(BackName) or
     not FileExists(BackName) then
  begin
    if FileExists(FileName) and RenameFile(FileName,BackName) or
       not FileExists(FileName) then
      Config.UpdateFile;
  end;
end;

procedure Wait500ms;
begin
  Sleep(500);
end;

function TryOpenToReadFile(FileName: string): TFileStream;
var ek: integer;
begin
  Result:=nil;
  ek:=10;
  repeat
    try
      if FileExists(FileName) then
        Result:=TFileStream.Create(FileName,fmOpenRead or fmShareDenyWrite);
      Break;
    except
      Dec(ek);
      Wait500ms;
    end;
  until ek < 0;
end;

function TryOpenToWriteFile(DirName,FileName: string): TFileStream;
var ek: integer;
begin
  Result:=nil;
  if not DirectoryExists(DirName) and ForceDirectories(DirName) or
     DirectoryExists(DirName) then
  begin
    ek:=10;
    repeat
      try
        if FileExists(FileName) then
          Result:=TFileStream.Create(FileName,fmOpenWrite or fmShareExclusive)
        else
          Result:=TFileStream.Create(FileName,fmCreate or fmShareExclusive);
        Break;
      except
        Dec(ek);
        Wait500ms;
      end;
    until ek < 0;
  end;
end;

function LoadStream(FileName: string; Stream: TMemoryStream): boolean;
var M: TMemoryStream; F: TFileStream; CRC32,EXTCRC: Cardinal;
    A: array of Byte; sMessage: string;
begin
  Result:=False;
  if FileExists(FileName) then
  begin
    sMessage:='���� "'+ExtractFileName(FileName)+'" ����� ������ ���������.';
    F:=TryOpenToReadFile(FileName);
    if not Assigned(F) then
    begin
      Caddy.ShowMessage(kmError,sMessage);
      Exit;
    end;
    M:=TMemoryStream.Create;
    try
      try
        F.ReadBuffer(EXTCRC,SizeOf(EXTCRC));
        SetLength(A,F.Size-F.Position);
        F.ReadBuffer(A[0],Length(A));
        M.WriteBuffer(A[0],Length(A));
        M.Position:=0;
      finally
        F.Free;
      end;
      CRC32:=0;
      CalcCRC32(M.Memory,M.Size,CRC32);
      if CRC32 = EXTCRC then
      begin
        Stream.Clear;
        DecompressStream(M,Stream);
        Stream.Position:=0;
        Result:=True;
      end;
    finally
      M.Free;
    end;
  end;
end;

function NumToStr(Value: word; WordBase,SI,SR1,SR2: string;
                  ShowNumber: boolean = True): string;
var S,W: string; Thing: boolean;
begin
  S:=IntToStr(Value);
  if ShowNumber then W:=S+' ' else W:='';
  Thing:=(Length(S) >= 2) and (S[Length(S)-1] ='1');
  if Length(S) >= 1 then
  begin
    if Thing then
      Result:=W+WordBase+SR2
    else
    if S[Length(S)] ='1' then
      Result:=W+WordBase+SI
    else
    if S[Length(S)] in ['2','3','4'] then
      Result:=W+WordBase+SR1
    else
      Result:=W+WordBase+SR2;
  end
  else
    Result:='';
end;

function IsPortAvailable(PortIndex: integer): boolean;
var R: TRegistry; SL: TStrings; S: string; i: integer;
begin
  Result:=False;
  R:=TRegistry.Create;
  SL:=TStringList.Create;
  try
    R.RootKey:=HKEY_LOCAL_MACHINE;
    if R.OpenKeyReadOnly('HARDWARE\DEVICEMAP\SERIALCOMM') then
    begin
      R.GetValueNames(SL);
      for i:=0 to SL.Count-1 do
      begin
        S:=R.ReadString(SL[i]);
        if Format('COM%d',[PortIndex]) = S then
        begin
          Result:=True;
          Break;
        end;
      end;
      R.CloseKey;
    end;
  finally
    SL.Free;
    R.Free;
  end;
end;

procedure CompressStream(aSource,aTarget: TStream);
var comprStream: TCompressionStream;
begin
  comprStream:=TCompressionStream.Create(clMax,aTarget);
  try
    comprStream.CopyFrom(aSource,aSource.Size);
    comprStream.CompressionRate;
  finally
    comprStream.Free;
  end;
end;

procedure DecompressStream(aSource,aTarget: TStream);
var decompStream: TDecompressionStream;
    nRead: Integer;
    Buffer: array[0..4095] of Byte;
begin
  decompStream:=TDecompressionStream.Create(aSource);
  try
    repeat
      nRead:=decompStream.Read(Buffer,4096);
      aTarget.Write(Buffer,nRead);
    until nRead = 0;
  finally
    decompStream.Free;
  end;
end;

function RegisterEntity(NewClass: TEntityClass): TEntityClass;
begin
  EntityClassList.Add(NewClass);
  Result := NewClass;
end;

procedure RegisterEditForm(NewClass: TFormClass);
begin
  EditFormClassList.Add(NewClass);
end;

procedure RegisterPaspForm(NewClass: TFormClass);
begin
  PaspFormClassList.Add(NewClass);
end;

function RegisterNode(NodeName: string): TList;
begin
  Result:=TList.Create;
  NodeList.AddObject(NodeName,Result);
end;

function EntityClassIndex(AClass: TClass): integer;
begin
  Result:=EntityClassList.IndexOf(AClass);
end;

{ TEntity }

procedure TEntity.ConnectLinks;
begin
  SourceEntity:=Caddy.Find(SourceName) as TCustomGroup;
end;

constructor TEntity.Create;
begin
  LinkScheme := '';
  GoodFetchsCount:=0;
  BadFetchsCount:=0;
  BadFatalFetchsCount:=0;
  MaxAnswerTime:=0;
  FHeaderWait:=True;
  HasCommand:=False;
  Self.CommandData:=0.0;
  RemoteCommandText:='';
//----------------------------------------
  FirstCalc:=True;
  LocalFetchOnly:=False;
  ErrorMess:='';
  FSwitchStatus:=[];
  FAlarmStatus:=[asNoLink];
  FConfirmStatus:=[asNoLink];
  OldAlarmStatus:=[asNoLink];
  OldConfirmStatus:=[asNoLink];
  LostAlarmStatus:=[];
//----------------------------------------
  LastTicks:=GetTickCount;
  LastTime:=1;
  PrevEntity:=nil;
  NextEntity:=nil;
//----------------------------------------
  PtClass:=Self.ClassName;
  FPtName:='';
  FPtDesc:=EntityType;
  FActived:=False;
  FAsked:=False;
  FLogged:=False;
  FFetchTime:=1;
  FSourceName:='';
  FIsCommand:=False;
  FIsGroup:=False;
  FIsDigit:=False;
  FIsAnalog:=False;
  FIsComposit:=False;
  FIsCustom:=False;
  FIsVirtual:=False;
  FIsParam:=False;
  FEntityKind:=ekNone;
  FChannel:=1;
  FNode:=1;
  FBlock:=1;
  FPlace:=1;
end;

destructor TEntity.Destroy;
begin
  inherited;
end;

procedure TEntity.SetActived(const Value: boolean);
  function BS(Value: boolean): string;
  begin
    Result:=IfThen(Value,'���','����');
  end;
begin
  if FActived <> Value then
  begin
    if not Value or (Value and Caddy.CheckValidAddress(Self)) then
    begin
      Caddy.AddChange(FPtName,'�����',BS(FActived),BS(Value),
                              FPtDesc,Caddy.Autor);
      FActived:=Value;
      if FActived then
      begin
        LastTime:=1;
        LastTicks:=GetTickCount;
      end;
      Caddy.Changed:=True;
    end;  
  end;
end;

procedure TEntity.SetAsked(const Value: boolean);
  function BS(Value: boolean): string;
  begin
    Result:=IfThen(Value,'���','����');
  end;
begin
  if FAsked <> Value then
  begin
    Caddy.AddChange(FPtName,'������������',BS(FAsked),BS(Value),
                              FPtDesc,Caddy.Autor);
    FAsked:=Value;
    Caddy.Changed:=True;
  end;
end;

procedure TEntity.SetBlock(const Value: word);
begin
  if FBlock <> Value then
  begin
    Caddy.AddChange(FPtName,GetBlockName,IntToStr(FBlock),
                              IntToStr(Value),FPtDesc,Caddy.Autor);
    FBlock:=Value;
    Caddy.Changed:=True;
  end;
end;

procedure TEntity.SetChannel(const Value: word);
var TheFetch: TFetchList; J: integer;
begin
  if FChannel <> Value then
  begin
    if not Assigned(SourceEntity) then
    begin
      if IsVirtual then
        TheFetch:=Caddy.FetchList[0]
      else
        TheFetch:=Caddy.FetchList[FChannel];
      with TheFetch.List do
      begin
        J:=IndexOf(Self);
        if J >= 0 then Remove(Self);
      end;
    end;
    Caddy.AddChange(FPtName,'�����',IntToStr(FChannel),
                              IntToStr(Value),FPtDesc,Caddy.Autor);
    FChannel:=Value;
    Caddy.Changed:=True;
  end;
end;

procedure TEntity.SetFetchTime(const Value: DWord);
begin
  if FFetchTime <> Value then
  begin
    Caddy.AddChange(FPtName,'�����',IntToStr(FFetchTime)+' ���',
                              IntToStr(Value)+' ���',FPtDesc,Caddy.Autor);
    FFetchTime:=Value;
    Caddy.Changed:=True;
  end;
end;

procedure TEntity.SetLogged(const Value: boolean);
  function BS(Value: boolean): string;
  begin
    Result:=IfThen(Value,'���','����');
  end;
begin
  if FLogged <> Value then
  begin
    Caddy.AddChange(FPtName,'������������',BS(FLogged),BS(Value),
                              FPtDesc,Caddy.Autor);
    FLogged:=Value;
    Caddy.Changed:=True;
    if FLogged then
      FirstCalc:=True
    else
    begin
      Caddy.RemoveAlarms(Self);
      Caddy.RemoveSwitchs(Self);
    end;
  end;
end;

procedure TEntity.SetNode(const Value: word);
begin
  if FNode <> Value then
  begin
    Caddy.AddChange(FPtName,'����������',IntToStr(FNode),
                              IntToStr(Value),FPtDesc,Caddy.Autor);
    FNode:=Value;
    Caddy.Changed:=True;
  end;
end;

procedure TEntity.SetPlace(const Value: word);
begin
  if FPlace <> Value then
  begin
    Caddy.AddChange(FPtName,GetPlaceName,IntToStr(FPlace),
                              IntToStr(Value),FPtDesc,Caddy.Autor);
    FPlace:=Value;
    Caddy.Changed:=True;
  end;
end;

procedure TEntity.SetPtDesc(const Value: string);
begin
  if FPtDesc <> Value then
  begin
    Caddy.AddChange(FPtName,'����������','����:','',FPtDesc,Caddy.Autor);
    Caddy.AddChange(FPtName,'����������','','�����:',Value,Caddy.Autor);
    FPtDesc:=Value;
    Caddy.Changed:=True;
  end;
end;

procedure TEntity.SetPtName(const Value: string);
begin
  if FPtName <> Value then
  begin
    if Trim(FPtName) <> '' then
      Caddy.AddChange(FPtName,'��� �������',FPtName,Value,FPtDesc,Caddy.Autor);
    FPtName:=Value;
    Caddy.Changed:=True;
  end;
end;

procedure TEntity.SetSourceEntity(const Value: TCustomGroup);
var S: string;
begin
  FSourceEntity:=Value;
  if Value <> nil then
    S:=Value.PtName
  else
    S:='';
  if FSourceName <> S then
  begin
    Caddy.AddChange(FPtName,'��������',FSourceName,S,FPtDesc,Caddy.Autor);
    FSourceName:=S;
    Caddy.Changed:=True;
  end;
end;

class function TEntity.TypePict(Bmp: TBitmap): TBitmap;
var R: TRect;
begin
  Result:=Bmp;
  with Result do
  begin
    Canvas.Brush.Color:=TypeColor;
    R:=Rect(0,0,Bmp.Width,Bmp.Height);
    Canvas.TextRect(R,1,1,TypeCode);
  end;
end;

procedure TEntity.Synchronize;
begin
  Inc(LastTime);
  if LastTime > FetchTime then
  begin
    LastTime:=1;
    RequestData;
  end;
end;

procedure TEntity.RequestData;
var FL: TList;
begin
  if not Assigned(FSourceEntity) or HasCommand then
  begin
    if IsVirtual then
      FL:=Caddy.FetchList[0].List
    else
      FL:=Caddy.FetchList[FChannel].List;
    if FL.IndexOf(Self) < 0 then FL.Add(Self);
  end;
end;

(*
procedure TEntity.RequestAfterCommand;
var FL: TList; Index: integer;
begin
  if IsVirtual then
    FL:=Caddy.FetchList[0].List
  else
    FL:=Caddy.FetchList[FChannel].List;
  Index:=FL.IndexOf(Self);
  if Index < 0 then
    FL.Insert(0,Self)
  else
    FL.Move(Index,0);
end;
*)

procedure TEntity.Notify(Kind: TEntityNotify; E: TEntity);
begin
  case Kind of
    enRename: if E = FSourceEntity then
                FSourceName:=E.PtName;
    enDelete: if E = FSourceEntity then
              begin
                FSourceEntity:=nil;
                FSourceName:='';
              end;
  end;
end;

procedure TEntity.Assign(E: TEntity);
begin
  FPtDesc:=E.PtDesc;
  FAsked:=E.Asked;
  FLogged:=E.Logged;
  FFetchTime:=E.FetchTime;
  FChannel:=E.Channel;
  FNode:=E.Node;
  FBlock:=E.Block;
  FPlace:=E.Place;
end;

procedure TEntity.SetRaw(const Value: Double);
begin
  FRaw:=Value;
  FirstCalc:=False;
  if Assigned(FSourceEntity) then
  begin
    UpdateRealTime;
    if asNoLink in AlarmStatus then Caddy.RemoveAlarm(asNoLink,Self);
  end;
end;

procedure TEntity.SetRealTime(const Value: DWord);
begin
  FRealTime := Value;
end;

function TEntity.GetBlockName: string;
begin
  Result:='����';
end;

function TEntity.GetPlaceName: string;
begin
  Result:='�����';
end;

procedure TEntity.SetAlarmStatus(const Value: TSetAlarmStatus);
begin
  OldAlarmStatus:=FAlarmStatus;
  FAlarmStatus:=Value;
end;

procedure TEntity.SetConfirmStatus(const Value: TSetAlarmStatus);
begin
  OldConfirmStatus:=FConfirmStatus;
  FConfirmStatus:=Value;
end;

function TEntity.GetTextValue: string;
begin
  Result:='(empty)';
end;

procedure TEntity.UpdateRealTime;
var Ticks: DWord;
begin
  Ticks:=GetTickCount;
  FRealTime:=Abs(Ticks-LastTicks);
  LastTicks:=Ticks;
end;

function TEntity.Prepare: string;
begin
  Result:='';
end;

procedure TEntity.SetParam(ParamName: string; Item: TCashRealBaseItem);
begin
  if ParamName = 'RAW' then
  begin
    if Caddy.NetRole = nrClient then
      Raw:=Item.Value
    else
      FRaw:=Item.Value;
  end
end;

function TEntity.GetAlarmState(var Alarm: TAlarmState): Boolean;
var i: Integer; Log: TActiveAlarmLogItem;
begin
  Result:=False;
  with Caddy.ActiveAlarmLog do
  for i:=0 to Count-1 do
    begin
      Log:=TActiveAlarmLogItem(Items[i]);
      if Log.Source = Self then
      begin
        Alarm:=Log.Kind;
        Result:=True;
        Break;
      end;
    end;
end;

procedure TEntity.ShowParentPassport(const MonitorNum: integer);
begin
  if Assigned(SourceEntity) and Assigned(Caddy.FOnShowPassport) then
    Caddy.FOnShowPassport(SourceEntity, MonitorNum);
end;

procedure TEntity.ShowPassport(const MonitorNum: integer);
begin
  if Assigned(Caddy.FOnShowPassport) then Caddy.FOnShowPassport(Self, MonitorNum);
end;

procedure TEntity.ShowEditor(const MonitorNum: integer);
begin
  if Assigned(Caddy.FOnShowEditor) then Caddy.FOnShowEditor(Self, MonitorNum);
end;

procedure TEntity.ShowScheme(const MonitorNum: integer);
begin
  if Assigned(Caddy.FOnShowScheme) then Caddy.FOnShowScheme(Self, MonitorNum);
end;

function TEntity.AddressEqual(E: TEntity): boolean;
begin
  Result:=False;
end;

procedure TEntity.Fetch(const Data: string = '');
begin
  if Length(Data) > 0 then
    FetchData:=Data;
end;

function TEntity.GetFetchData: string;
begin
  Result:=FFetchData;
end;

procedure TEntity.SetFetchData(const Value: string);
begin
  FFetchData:=Value;
end;

function TEntity.GetPtVal: string;
begin
  Result:='(empty)';
end;

procedure TEntity.SetHasCommand(const Value: boolean);
var FL: TList;
begin
  FHasCommand := Value;
  if FHasCommand then
  begin
    if IsVirtual then
      FL:=Caddy.FetchList[0].List
    else
      FL:=Caddy.FetchList[FChannel].List;
    FL.Insert(0,Self); // ��� ������� �������
    FL.Insert(0,Self); // ��� ���������� ���������� �� �������
  end;
end;

{ TCustomGroup }

procedure TCustomGroup.ConnectLinks;
var i: integer;
begin
  inherited;
  for i:=0 to FChilds.Count-1 do
    EntityChilds[i]:=Caddy.Find(FChilds[i]);
end;

constructor TCustomGroup.Create;
begin
  inherited;
  FChilds:=TStringList.Create;
  FIsGroup:=True;
  FEntityKind:=ekGroup;
end;

destructor TCustomGroup.Destroy;
begin
  FChilds.Free;
  inherited;
end;

procedure TCustomGroup.Decode(Value: Single);
begin
  // Stub
end;

procedure TCustomGroup.Notify(Kind: TEntityNotify; E: TEntity);
var i: integer;
begin
  inherited;
  case Kind of
    enRename: for i:=0 to Count-1 do
                if FChilds.Objects[i] = E then FChilds[i]:=E.PtName;
    enDelete: for i:=0 to Count-1 do
                if EntityChilds[i] = E then EntityChilds[i]:=nil;
  end;
end;

function TCustomGroup.GetEntityChilds(Index: Integer): TEntity;
begin
  if Index < Count then
    Result:=FChilds.Objects[Index] as TEntity
  else
    Result:=nil;
end;

procedure TCustomGroup.SetEntityChilds(Index: Integer; const Value: TEntity);
begin
  if Index < Count then
  begin
    if Value <> nil then
      Value.SourceEntity:=Self
    else
      if FChilds.Objects[Index] <> nil then
        (FChilds.Objects[Index] as TEntity).SourceEntity:=nil;
    FChilds.Objects[Index]:=Value
  end
  else
  begin
    while Index >= Count do FChilds.Add('');
    if Value <> nil then
    begin
      FChilds[Index]:=Value.PtName;
      FChilds.Objects[Index]:=Value;
      Value.SourceEntity:=Self;
    end;
  end;
  Caddy.Changed:=True;
end;

function TCustomGroup.GetChildCount: integer;
begin
  Result:=FChilds.Count;
end;

{ TCustomDigit }

procedure TCustomDigOut.Assign(E: TEntity);
var T: TCustomDigOut;
begin
  inherited;
  T:=E as TCustomDigOut;
  FInvert:=T.Invert;
  FAlarmDown:=T.AlarmDown;
  FAlarmUp:=T.AlarmUp;
  FColorDown:=T.ColorDown;
  FColorUp:=T.ColorUp;
  FSwitchDown:=T.SwitchDown;
  FSwitchUp:=T.SwitchUp;
  FTextDown:=T.TextDown;
  FTextUp:=T.TextUp;
end;

constructor TCustomDigOut.Create;
begin
  inherited;
  LastRaw:=False;
  FIsDigit:=True;
  FEntityKind:=ekDigit;
  FPV:=False;
  FInvert:=False;
  FAlarmDown:=False;
  FAlarmUp:=False;
  FColorDown:=6;
  FColorUp:=10;
  FSwitchDown:=False;
  FSwitchUp:=False;
  FTextDown:='����';
  FTextUp:='���';
end;

function TCustomDigOut.GetBlockName: string;
begin
  Result:='��������';
end;

function TCustomDigOut.GetPlaceName: string;
begin
  Result:='�����';
end;

function TCustomDigOut.GetPtVal: string;
begin
  if asNoLink in AlarmStatus then
    Result:='------'
  else
    Result:=IfThen(FPV,FTextUp,FTextDown);
end;

function TCustomDigOut.GetTextValue: string;
begin
  if asNoLink in AlarmStatus then
    Result:='------'
  else
    Result:=IfThen(FPV,FTextUp,FTextDown);
end;

procedure TCustomDigOut.SetAlarmDown(const Value: Boolean);
  function BS(Value: boolean): string;
  begin
    Result:=IfThen(Value,'���','����');
  end;
begin
  if FAlarmDown <> Value then
  begin
    Caddy.AddChange(FPtName,'����."1"->"0"',BS(FAlarmDown),BS(Value),
                              FPtDesc,Caddy.Autor);
    FAlarmDown:=Value;
    if (FAlarmDown = False) and (asOff in Self.AlarmStatus) then
    begin
      Caddy.SmartAskByEntity(Self,[asOff]);
      Caddy.RemoveAlarm(asOff,Self);
    end;
    Caddy.Changed:=True;
  end;
end;

procedure TCustomDigOut.SetAlarmUp(const Value: Boolean);
  function BS(Value: boolean): string;
  begin
    Result:=IfThen(Value,'���','����');
  end;
begin
  if FAlarmUp <> Value then
  begin
    Caddy.AddChange(FPtName,'����."0"->"1"',BS(FAlarmUp),BS(Value),
                              FPtDesc,Caddy.Autor);
    FAlarmUp:=Value;
    if (FAlarmUp = False) and (asOn in Self.AlarmStatus) then
    begin
      Caddy.SmartAskByEntity(Self,[asOn]);
      Caddy.RemoveAlarm(asOn,Self);
    end;
    Caddy.Changed:=True;
  end;
end;

procedure TCustomDigOut.SetColorDown(const Value: TDigColor);
begin
  if FColorDown <> Value then
  begin
    Caddy.AddChange(FPtName,'���� ��� "0"',StringDigColor[FColorDown],
                              StringDigColor[Value],FPtDesc,Caddy.Autor);
    FColorDown:=Value;
    Caddy.Changed:=True;
  end;
end;

procedure TCustomDigOut.SetColorUp(const Value: TDigColor);
begin
  if FColorUp <> Value then
  begin
    Caddy.AddChange(FPtName,'���� ��� "1"',StringDigColor[FColorUp],
                              StringDigColor[Value],FPtDesc,Caddy.Autor);
    FColorUp:=Value;
    Caddy.Changed:=True;
  end;
end;

procedure TCustomDigOut.SetInvert(const Value: Boolean);
  function BS(Value: boolean): string;
  begin
    Result:=IfThen(Value,'���','����');
  end;
begin
  if FInvert <> Value then
  begin
    Caddy.AddChange(FPtName,'��������',BS(FInvert),BS(Value),
                              FPtDesc,Caddy.Autor);
    FInvert:=Value;
    Caddy.Changed:=True;
  end;
end;

procedure TCustomDigOut.SetPV(const Value: Boolean);
const ADig: array[Boolean] of Single = (0.0,1.0);
begin
  if (FPV <> Value) or FirstCalc then
  begin
    if Caddy.DigErrFilter then
    begin
      if Value <> LastRaw then //
      begin                    //  ������
        LastRaw := Value;      //  ���������
        Exit;                  //  ��������
      end;                     //
    end
    else
      LastRaw := Value;
    FPV:=Value;
    if FLogged then
    begin
      if FAlarmDown and (Value = False) and not (asOff in AlarmStatus) then
        Caddy.AddAlarm(asOff,Self);
      if FAlarmDown and (Value = True) and (asOff in AlarmStatus) then
        Caddy.RemoveAlarm(asOff,Self);
      if FAlarmUp and (Value = True) and not (asOn in AlarmStatus) then
        Caddy.AddAlarm(asOn,Self);
      if FAlarmUp and (Value = False) and (asOn in AlarmStatus) then
        Caddy.RemoveAlarm(asOn,Self);
 //----------------------------------------
      if FSwitchDown and (Value = False) and not (asOff in FSwitchStatus) then
        Caddy.AddSwitch(asOff, Self);
      if FSwitchDown and (Value = True) and (asOff in FSwitchStatus) then
        Caddy.RemoveSwitch(asOff, Self);
      if FSwitchUp and (Value = True) and not (asOn in FSwitchStatus) then
        Caddy.AddSwitch(asOn, Self);
      if FSwitchUp and (Value = False) and (asOn in FSwitchStatus) then
        Caddy.RemoveSwitch(asOn, Self);
    end;
  end
  else
    LastRaw := Value;
end;

procedure TCustomDigOut.SetRaw(const Value: Double);
var R: Single;
begin
  R:=Value;
  if FInvert then
    PV:=not (R > 0)
  else
    PV:=(R > 0);
  inherited SetRaw(Value);
end;

procedure TCustomDigOut.SetSwitchDown(const Value: Boolean);
  function BS(Value: boolean): string;
  begin
    Result:=IfThen(Value,'���','����');
  end;
begin
  if FSwitchDown <> Value then
  begin
    Caddy.AddChange(FPtName,'������."1"->"0"',BS(FSwitchDown),BS(Value),
                              FPtDesc,Caddy.Autor);
    FSwitchDown:=Value;
    if (FSwitchDown = False) and (asOff in Self.FSwitchStatus) then
      Caddy.RemoveSwitch(asOff,Self);
    Caddy.Changed:=True;
  end;
end;

procedure TCustomDigOut.SetSwitchUp(const Value: Boolean);
  function BS(Value: boolean): string;
  begin
    Result:=IfThen(Value,'���','����');
  end;
begin
  if FSwitchUp <> Value then
  begin
    Caddy.AddChange(FPtName,'������."0"->"1"',BS(FSwitchUp),BS(Value),
                              FPtDesc,Caddy.Autor);
    FSwitchUp:=Value;
    if (FSwitchUp = False) and (asOn in Self.FSwitchStatus) then
      Caddy.RemoveSwitch(asOn,Self);
    Caddy.Changed:=True;
  end;
end;

procedure TCustomDigOut.SetTextDown(const Value: string);
begin
  if FTextDown <> Value then
  begin
    Caddy.AddChange(FPtName,'����� ��� "0"',FTextDown,Value,
                              FPtDesc,Caddy.Autor);
    FTextDown:=Value;
    Caddy.Changed:=True;
  end;
end;

procedure TCustomDigOut.SetTextUp(const Value: string);
begin
  if FTextUp <> Value then
  begin
    Caddy.AddChange(FPtName,'����� ��� "1"',FTextUp,Value,
                              FPtDesc,Caddy.Autor);
    FTextUp:=Value;
    Caddy.Changed:=True;
  end;
end;

function TCustomDigOut.TextLastValue: string;
begin
  Result:=IfThen(LastRaw,FTextDown,FTextUp);
end;

procedure TCustomGroup.SetRealTime(const Value: DWord);
var i: integer;
begin
  if Value <> FRealTime then
  begin
    if Value = 0 then
      for i:=0 to Count-1 do
        if Assigned(EntityChilds[i]) then EntityChilds[i].RealTime:=0;
  end;
  inherited;
end;

procedure TCustomGroup.ChildYesFetch;
var i: integer;
begin
  for i:=0 to FChilds.Count-1 do
  if Assigned(EntityChilds[i]) then
  begin
// ����� ����������, ������� �����, ���� �� ���
    if (asNoLink in EntityChilds[i].AlarmStatus) then
    begin
      Caddy.RemoveAlarm(asNoLink,EntityChilds[i]);
      if EntityChilds[i].IsGroup then
        (EntityChilds[i] as TCustomGroup).ChildYesFetch;
    end;
  end;
end;

procedure TCustomGroup.ChildNoFetch;
var i: integer;
begin
  for i:=0 to FChilds.Count-1 do
  if Assigned(EntityChilds[i]) then
  begin
    EntityChilds[i].RealTime:=0;
// ����� �� ����������, ���������� �����, ���� ��� �� ����
    if not (asNoLink in EntityChilds[i].AlarmStatus) then
    begin
      Caddy.AddAlarm(asNoLink,EntityChilds[i]);
      EntityChilds[i].FirstCalc:=True;
      if EntityChilds[i].IsGroup then
        (EntityChilds[i] as TCustomGroup).ChildNoFetch;
    end;
    EntityChilds[i].HasCommand:=False;
  end;
end;

function TCustomGroup.IsEmpty: boolean;
var i: integer;
begin
  Result:=True;
  for i:=0 to FChilds.Count-1 do
  if Assigned(EntityChilds[i]) then
  begin
    Result:=False;
    Break;
  end;
end;

{ TCustomAnaOut }

procedure TCustomAnaOut.Assign(E: TEntity);
var T: TCustomAnaOut;
begin
  inherited;
  T:=E as TCustomAnaOut;
  FEUDesc:=T.EUDesc;
  FPVFormat:=T.PVFormat;
  FBadDB:=T.BadDB;
  FHHDB:=T.HHDB;
  FHiDB:=T.HiDB;
  FLoDB:=T.LoDB;
  FLLDB:=T.LLDB;
  FPVEUHi:=T.PVEUHi;
  FPVHHTP:=T.PVHHTP;
  FPVHiTP:=T.PVHiTP;
  FPVLoTP:=T.PVLoTP;
  FPVLLTP:=T.PVLLTP;
  FPVEULo:=T.PVEULo;
  FCalcScale:=T.CalcScale;
  FTrend:=T.Trend;
end;

function TCustomAnaOut.CalcDB(DBType: TAlarmDeadBand): Single;
begin
  case DBType of
    adZero: Result:=0.0;
    adHalf: Result:=Abs(FPVEUHi-FPVEULo)*0.005;
    adOne: Result:=Abs(FPVEUHi-FPVEULo)*0.01;
    adTwo: Result:=Abs(FPVEUHi-FPVEULo)*0.02;
    adThree: Result:=Abs(FPVEUHi-FPVEULo)*0.03;
    adFour: Result:=Abs(FPVEUHi-FPVEULo)*0.04;
    asFive: Result:=Abs(FPVEUHi-FPVEULo)*0.05;
  else
    Result:=0.0;
  end;
end;

constructor TCustomAnaOut.Create;
begin
  inherited;
  FIsAnalog:=True;
  FEntityKind:=ekAnalog;
  FPV:=0.0;
  FEUDesc:='%';
  FPVFormat:=pfD1;
  FBadDB:=adNone;
  FHHDB:=adNone;
  FHiDB:=adNone;
  FLoDB:=adNone;
  FLLDB:=adNone;
  FPVEUHi:=100.0;
  FPVHHTP:=85.0;
  FPVHiTP:=80.0;
  FPVLoTP:=20.0;
  FPVLLTP:=15.0;
  FPVEULo:=0.0;
  FTrend:=False;
  FCalcScale:=True;
end;

function TCustomAnaOut.GetFontAlarmColor(DefColor: TColor; Blink: boolean): TColor;
var k: TAlarmState;
begin
  Result:=DefColor;
  for k:=High(k) downto Low(k) do
  if (k in LostAlarmStatus) then
    Result:=AFontColor[k,(k in AlarmStatus),
                         (k in ConfirmStatus),Blink];
  for k:=High(k) downto Low(k) do
  if (k in AlarmStatus) then
    Result:=AFontColor[k,(k in AlarmStatus),
                         (k in ConfirmStatus),Blink];
end;

function TCustomAnaOut.GetBrushAlarmColor(DefColor: TColor; Blink: boolean): TColor;
var k: TAlarmState;
begin
  Result:=DefColor;
  for k:=High(k) downto Low(k) do
  if (k in LostAlarmStatus) then
    Result:=ABrushColor[k,(k in AlarmStatus),
                          (k in ConfirmStatus),Blink];
  for k:=High(k) downto Low(k) do
  if (k in AlarmStatus) then
    Result:=ABrushColor[k,(k in AlarmStatus),
                          (k in ConfirmStatus),Blink];
end;

function TCustomAnaOut.GetBlockName: string;
begin
  Result:='��������';
end;

function TCustomAnaOut.GetPlaceName: string;
begin
  Result:='�����';
end;

function TCustomAnaOut.GetTextValue: string;
begin
  if (asNoLink in AlarmStatus)
    or
     (FBadDB <> adNone) and
     ((asShortBadPV in AlarmStatus) or (asOpenBadPV in AlarmStatus)) then
    Result:='------'
  else
    Result:=Format('%.'+IntToStr(Ord(FPVFormat))+'f',[FPV])
end;

procedure TCustomAnaOut.SetBadDB(const Value: TAlarmDeadband);
begin
  if FBadDB <> Value then
  begin
    Caddy.AddChange(FPtName,'BDPVDB',AAlmDB[FBadDB],AAlmDB[Value],
                              FPtDesc,Caddy.Autor);
    FBadDB:=Value;
    Caddy.Changed:=True;
  end;
end;

procedure TCustomAnaOut.SetEUDesc(const Value: string);
begin
  if FEUDesc <> Value then
  begin
    Caddy.AddChange(FPtName,'���.�������',FEUDesc,Value,
                              FPtDesc,Caddy.Autor);
    FEUDesc:=Value;
    Caddy.Changed:=True;
  end;
end;

procedure TCustomAnaOut.SetHHDB(const Value: TAlarmDeadband);
begin
  if FHHDB <> Value then
  begin
    Caddy.AddChange(FPtName,'HHDB',AAlmDB[FHHDB],AAlmDB[Value],
                              FPtDesc,Caddy.Autor);
    FHHDB:=Value;
    Caddy.Changed:=True;
  end;
end;

procedure TCustomAnaOut.SetHiDB(const Value: TAlarmDeadband);
begin
  if FHiDB <> Value then
  begin
    Caddy.AddChange(FPtName,'HIDB',AAlmDB[FHiDB],AAlmDB[Value],
                              FPtDesc,Caddy.Autor);
    FHiDB:=Value;
    Caddy.Changed:=True;
  end;
end;

procedure TCustomAnaOut.SetLLDB(const Value: TAlarmDeadband);
begin
  if FLLDB <> Value then
  begin
    Caddy.AddChange(FPtName,'LLDB',AAlmDB[FLLDB],AAlmDB[Value],
                              FPtDesc,Caddy.Autor);
    FLLDB:=Value;
    Caddy.Changed:=True;
  end;
end;

procedure TCustomAnaOut.SetLoDB(const Value: TAlarmDeadband);
begin
  if FLoDB <> Value then
  begin
    Caddy.AddChange(FPtName,'LODB',AAlmDB[FLoDB],AAlmDB[Value],
                              FPtDesc,Caddy.Autor);
    FLoDB:=Value;
    Caddy.Changed:=True;
  end;
end;

procedure TCustomAnaOut.SetPV(const Value: Double);
var StatusOk: boolean;
begin
  if FLastPV <> FPV then FLastPV:=FPV;
  try
    FPV:=RoundTo(Value,-Ord(FPVFormat));
  except
    FPV:=FLastPV;
  end;
  if FLogged then
  begin
    if (FPV > FLastPV) or FirstCalc then
    begin
      if (FHiDB <> adNone) and (FPV >= FPVHiTP) and not (asHi in FAlarmStatus) then
        Caddy.AddAlarm(asHi,Self);
      if (FHHDB <> adNone) and (FPV >= FPVHHTP) and not (asHH in AlarmStatus) then
        Caddy.AddAlarm(asHH,Self);
      if (FBadDB <> adNone) and (FPV > FPVEUHi+CalcDB(FBadDB)) and
         not (asShortBadPV in AlarmStatus) then
        Caddy.AddAlarm(asShortBadPV,Self);
//-------------------------------------
      if (FPV >= FPVEULo+CalcDB(FBadDB)) and (asOpenBadPV in AlarmStatus) then
        Caddy.RemoveAlarm(asOpenBadPV,Self);
      if (FPV > FPVLLTP+CalcDB(FLLDB)) and (asLL in AlarmStatus) then
        Caddy.RemoveAlarm(asLL,Self);
      if (FPV > FPVLoTP+CalcDB(FLoDB)) and (asLo in AlarmStatus) then
        Caddy.RemoveAlarm(asLo,Self);
    end;
    if (FPV < FLastPV) or FirstCalc then
    begin
      if (FPV < FPVHHTP-CalcDB(FHHDB)) and (asHH in AlarmStatus) then
        Caddy.RemoveAlarm(asHH,Self);
      if (FPV < FPVHiTP-CalcDB(FHiDB)) and (asHi in AlarmStatus) then
        Caddy.RemoveAlarm(asHi,Self);
      if (FPV <= FPVEUHi-CalcDB(FBadDB)) and (asShortBadPV in AlarmStatus) then
        Caddy.RemoveAlarm(asShortBadPV,Self);
//------------------------------------------------
      if (FLoDB <> adNone) and (FPV <= FPVLoTP) and not (asLo in AlarmStatus)then
        Caddy.AddAlarm(asLo,Self);
      if (FLLDB <> adNone) and (FPV <= FPVLLTP) and not (asLL in AlarmStatus) then
        Caddy.AddAlarm(asLL,Self);
      if (FBadDB <> adNone) and (FPV < FPVEULo-CalcDB(FBadDB)) and
         not (asOpenBadPV in AlarmStatus) then
        Caddy.AddAlarm(asOpenBadPV,Self);
    end;
  end;
  StatusOk:=not ((asBadPV in AlarmStatus) or
                 (asOpenBadPV in AlarmStatus) or
                 (asShortBadPV in AlarmStatus) or
                 (asNoLink in AlarmStatus));
  if FTrend then
  begin
    if FirstCalc and StatusOk then
      Caddy.AddRealTrend(PtName+'.PV',FPV,False);
  end;
  FirstCalc:=False;
  if FTrend then
    Caddy.AddRealTrend(PtName+'.PV',FPV,StatusOk);
end;

procedure TCustomAnaOut.SetPVDHTP(const Value: Single);
  function FV(V: Single): string;
  begin
    Result:=Format('%.'+IntToStr(Ord(PVFormat))+'f',[V]);
  end;
begin
  if FPVDHTP <> Value then
  begin
    Caddy.AddChange(PtName,'PVDHTP',FV(FPVDHTP),FV(Value),
                              PtDesc,Caddy.Autor);
    FPVDHTP:=Value;
    Caddy.Changed:=True;
  end;
end;

procedure TCustomAnaOut.SetPVDLTP(const Value: Single);
  function FV(V: Single): string;
  begin
    Result:=Format('%.'+IntToStr(Ord(PVFormat))+'f',[V]);
  end;
begin
  if FPVDLTP <> Value then
  begin
    Caddy.AddChange(PtName,'PVDLTP',FV(FPVDLTP),FV(Value),
                              PtDesc,Caddy.Autor);
    FPVDLTP:=Value;
    Caddy.Changed:=True;
  end;
end;

procedure TCustomAnaOut.SetPVEUHi(const Value: Single);
  function FV(V: Single): string;
  begin
    Result:=Format('%.'+IntToStr(Ord(FPVFormat))+'f',[V]);
  end;
begin
  if FPVEUHi <> Value then
  begin
    Caddy.AddChange(FPtName,'PVEUHI',FV(FPVEUHi),FV(Value),
                              FPtDesc,Caddy.Autor);
    FPVEUHi:=Value;
    Caddy.Changed:=True;
  end;
end;

procedure TCustomAnaOut.SetPVEULo(const Value: Single);
  function FV(V: Single): string;
  begin
    Result:=Format('%.'+IntToStr(Ord(FPVFormat))+'f',[V]);
  end;
begin
  if FPVEULo <> Value then
  begin
    Caddy.AddChange(FPtName,'PVEULO',FV(FPVEULo),FV(Value),
                              FPtDesc,Caddy.Autor);
    FPVEULo:=Value;
    Caddy.Changed:=True;
  end;
end;

procedure TCustomAnaOut.SetPVFormat(const Value: TPVFormat);
  function FP(V: TPVFormat): string;
  begin
    Result:=Format('D%d',[Ord(V)]);
  end;
begin
  if FPVFormat <> Value then
  begin
    Caddy.AddChange(FPtName,'������ PV',FP(FPVFormat),FP(Value),
                              FPtDesc,Caddy.Autor);
    FPVFormat:=Value;
    Caddy.Changed:=True;
  end;
end;

procedure TCustomAnaOut.SetPVHHTP(const Value: Single);
  function FV(V: Single): string;
  begin
    Result:=Format('%.'+IntToStr(Ord(FPVFormat))+'f',[V]);
  end;
begin
  if FPVHHTP <> Value then
  begin
    Caddy.AddChange(FPtName,'PVHHTP',FV(FPVHHTP),FV(Value),
                              FPtDesc,Caddy.Autor);
    FPVHHTP:=Value;
    Caddy.Changed:=True;
  end;
end;

procedure TCustomAnaOut.SetPVHiTP(const Value: Single);
  function FV(V: Single): string;
  begin
    Result:=Format('%.'+IntToStr(Ord(FPVFormat))+'f',[V]);
  end;
begin
  if FPVHiTP <> Value then
  begin
    Caddy.AddChange(FPtName,'PVHITP',FV(FPVHiTP),FV(Value),
                              FPtDesc,Caddy.Autor);
    FPVHiTP:=Value;
    Caddy.Changed:=True;
  end;
end;

procedure TCustomAnaOut.SetPVLLTP(const Value: Single);
  function FV(V: Single): string;
  begin
    Result:=Format('%.'+IntToStr(Ord(FPVFormat))+'f',[V]);
  end;
begin
  if FPVLLTP <> Value then
  begin
    Caddy.AddChange(FPtName,'PVLLTP',FV(FPVLLTP),FV(Value),
                              FPtDesc,Caddy.Autor);
    FPVLLTP:=Value;
    Caddy.Changed:=True;
  end;
end;

procedure TCustomAnaOut.SetPVLoTP(const Value: Single);
  function FV(V: Single): string;
  begin
    Result:=Format('%.'+IntToStr(Ord(FPVFormat))+'f',[V]);
  end;
begin
  if FPVLoTP <> Value then
  begin
    Caddy.AddChange(FPtName,'PVLOTP',FV(FPVLoTP),FV(Value),
                              FPtDesc,Caddy.Autor);
    FPVLoTP:=Value;
    Caddy.Changed:=True;
  end;
end;

procedure TCustomAnaOut.SetRaw(const Value: Double);
var R: Double;
begin
  R:=Value;
  if FCalcScale then
    PV:=(FPVEUHi-FPVEULo)*(R/100.0)+FPVEULo
  else
    PV:=R;
  inherited SetRaw(Value);
end;

{ TCaddyBase }

function TCaddy.AddEntityNoname(ClassIndex: integer;
                                PtClass: TEntityClass): TEntity;
begin
  Result:=PtClass.Create;
  Result.ClassIndex:=ClassIndex;
end;

function TCaddy.AddEntity(PtName: string; ClassIndex: integer;
                          PtClass: TEntityClass): TEntity;
begin
  if not Assigned(Find(PtName)) then
  begin
    if IsValidIdent(PtName) then
    begin
      Result:=PtClass.Create;
      EntityOwner.Add(Result);
      Result.PtName:=PtName;
      Result.ClassIndex:=ClassIndex;
      Result.PrevEntity:=LastEntity;
      if Assigned(LastEntity) then
        LastEntity.NextEntity:=Result;
      LastEntity:=Result;
      if not Assigned(FirstEntity) then
        FirstEntity:=Result;
      Changed:=True;
    end
    else
      raise Exception.Create('��� "'+PtName+
                             '" �� �������� ���������� ���������������!');
  end
  else
    raise Exception.Create('��� "'+PtName+'" ��� ������������!');
end;

constructor TCaddy.Create(AOwner: TComponent);
var i,j: integer;
begin
  inherited;
  SetLength(FOnAlarmLogUpdate, 0);
  SetLength(FOnSwitchLogUpdate, 0);
  NetClientConnected := False;
  Changed := False;
  FetchRun := False;
  FirstEntity := nil;
  LastEntity := nil;
  ActiveAlarmLog := TObjectList.Create(True);
  ActiveSwitchLog := TObjectList.Create(True);
  EntityOwner := TObjectList.Create(True);
  for i:=1 to 125 do
  begin
    HistGroups[i].GroupName := '';
    HistGroups[i].Empty := True;
    for j:=1 to 8 do
    begin
      HistGroups[i].Place[j] := '';
      HistGroups[i].Entity[j] := nil;
      HistGroups[i].Kind[j] := 0;
      HistGroups[i].EU[j] := '';
      HistGroups[i].DF[j] := 1;
    end;
  end;
  for i:=0 to ChannelCount do
  with FetchList[i] do
  begin
    List:=TList.Create;
    if i in [1..ChannelCount] then
    begin
      ComLink := TKontLink.Create;
      ComLink.Channel := i;
      ComLink.ComProp.BaudRate := br19200;
      TcpLink := TTcpLink.Create;
      TcpLink.Channel := i;
    end;
  end;
  StationsLink := TStationsLink.Create(Self);
  DigErrFilter := False;
  NoAsk := False; // ��������� 15.07.12
end;

procedure TCaddy.DeleteEntity(E: TEntity);
var I,J: integer; N: TEntity; TheFetch: TFetchList; Found: boolean;
begin
  if Assigned(Find(E.PtName)) then
  begin
    N := FirstEntity;
    while N <> nil do
    begin
      N.Notify(enDelete,E);
      N := N.NextEntity;
    end;
    if FirstEntity = E then FirstEntity := E.NextEntity;
    if LastEntity = E then LastEntity := E.PrevEntity;
    if E.PrevEntity <> nil then E.PrevEntity.NextEntity := E.NextEntity;
    if E.NextEntity <> nil then E.NextEntity.PrevEntity := E.PrevEntity;
    if not Assigned(E.SourceEntity) then
    begin
      if E.IsVirtual then
        TheFetch := FetchList[0]
      else
        TheFetch := FetchList[E.Channel];
      with TheFetch.List do
      begin
        J := IndexOf(E);
        if J >= 0 then Remove(E);
      end;
    end;
    Changed:=True;
  end;
  Found := False;
  for I := 1 to 125 do for J := 1 to 8 do
    if HistGroups[I].Entity[J] = E then
    begin
      HistGroups[I].Place[J] := '';
      HistGroups[I].Entity[J] := nil;
      HistGroups[I].Kind[J] := 0;
      HistGroups[I].EU[J] := '';
      HistGroups[I].DF[J] := 1;
      Found := True;
    end;
  HistChanged := Found;
  RemoveAlarms(E);
  RemoveSwitchs(E);
  EntityOwner.Remove(E);
end;

destructor TCaddy.Destroy;
var i: integer;
begin
  Sleep(1000);
  StationsLink.Free;
  for i:=0 to ChannelCount do
  with FetchList[i] do
  begin
    List.Free;
    ComLink.Free;
    TcpLink.Free;
  end;
  ActiveSwitchLog.Free;
  ActiveAlarmLog.Free;
  EntityOwner.Free;
  if Assigned(Beeper) then Beeper.Free;
  inherited;
end;

procedure TCaddy.FetchExecute;
var E: TEntity;
begin
  E:=FirstEntity;
  while E <> nil do
  begin
    if E.Actived then
      E.Synchronize
    else
      E.RealTime:=0;
    E:=E.NextEntity;
  end;
end;

function TCaddy.Find(const PtName: string): TEntity;
var E: TEntity;
begin
  Result := nil;
  E := FirstEntity;
  while Assigned(E) do
  begin
    if E.PtName = PtName then
    begin
      Result := E;
      Break;
    end;
    E := E.NextEntity;
  end;
end;

procedure TCaddy.LoadBase(const BasePath: string);
var i: integer; PtName: string[10]; PtClass: string;
    E: TEntity; M: TMemoryStream; P: Int64;
    AlarmItem: TActiveAlarmLogItem;
begin
  Screen.Cursor := crHourGlass;
  try
    for i := 0 to EntityClassList.Count-1 do
    begin
      PtClass := IncludeTrailingPathDelimiter(BasePath)+
                 UpperCase(EntityClassList[i].ClassName)+'.ENT';
      M := TMemoryStream.Create;
      try
        if FileExists(PtClass) then
        begin
          if LoadStream(PtClass,M) then
          begin
            if M.Size >= SizeOf(PtName) then
            while M.Position < M.Size do
            begin
              P := M.Position;
              M.ReadBuffer(PtName,SizeOf(PtName));
              M.Position := P;
              if not IsValidIdent(PtName) then Break;
              try
                E := AddEntity(PtName,i,TEntityClass(EntityClassList[i]));
                if Assigned(E) then E.LoadFromStream(M) else Break;
              except
                on EE: Exception do
                begin
                  AddSysMess(PtName, EE.Message+' �� ��������� � ���� ������!');
                // ��������, ������ ������������ �� ������, � ���� �� ����������� !
                  E := AddEntityNoname(i,TEntityClass(EntityClassList[i]));
                  if Assigned(E) then
                  begin
                    try
                      E.LoadFromStream(M);
                    finally
                      E.Free;
                    end;
                  end
                  else
                    Break;
                end;
              end;
            end;
          end
          else
            AddSysMess('�������� ��','������ ��� �������� ��������� ����� "'+
                                     ExtractFileName(PtClass)+'"');
        end;
      finally
        M.Free;
      end;
    end;
//---- ����������� ������ ������ ���� ������ -----
    E := FirstEntity;
    while E <> nil do
    begin
      E.ConnectLinks;
      E := E.NextEntity;
    end;
    Changed := False;
  finally
    Screen.Cursor := crDefault;
  end;
//---- ����������� ������ � ��������� ������� -----
  for i:=0 to ActiveAlarmLog.Count-1 do
  begin
    AlarmItem:=ActiveAlarmLog.Items[i] as TActiveAlarmLogItem;
    AlarmItem.Source:=Find(AlarmItem.Position);
    if Assigned(AlarmItem.Source) then
    begin
      AlarmItem.Source.AlarmStatus:=AlarmItem.AlarmStatus;
      AlarmItem.Source.ConfirmStatus:=AlarmItem.ConfirmStatus;
    end;
  end;
end;

procedure TCaddy.SaveBase(BasePath: string);
var E: TEntity; i,Len: integer;
    AF: record
          Body: array[1..100] of TMemoryStream;
          Length: integer;
        end;
    M: TMemoryStream; CRC32: Cardinal;
    PtClass,FileName,BackName: string; F: TFileStream;
begin
  F:=nil;
  Screen.Cursor:=crHourGlass;
  try
    Len:=EntityClassList.Count;
    AF.Length:=Len;
    for i:=1 to Len do
      if i <= High(AF.Body) then AF.Body[i]:=TMemoryStream.Create;
    try
      E:=FirstEntity;
      while E <> nil do
      begin
        E.SaveToStream(AF.Body[E.ClassIndex+1]);
        E:=E.NextEntity;
      end;
      for i:=0 to Len-1 do
      begin
        M:=TMemoryStream.Create;
        try
          if AF.Body[i+1].Size > 0 then
          begin
            AF.Body[i+1].Position:=0;
            CompressStream(AF.Body[i+1],M);
            M.Position:=0;
          end;
          CRC32:=0; CalcCRC32(M.Memory,M.Size,CRC32);
          PtClass:=IncludeTrailingPathDelimiter(BasePath)+
                   UpperCase(EntityClassList[i].ClassName)+'.ENT';
          FileName:=PtClass;
          BackName:=ChangeFileExt(FileName,'.~ENT');
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
              if ForceDirectories(BasePath) then
              begin
                try
                  F:=TFileStream.Create(PtClass,fmCreate or fmShareExclusive);
                except
                  ShowMessage(kmWarning,'���� "'+ExtractFileName(PtClass)+
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
          M.Free;
        end;
      end;
    finally
      for i:=1 to Len do AF.Body[i].Free;
    end;
    Changed:=False;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TCaddy.LoadHistGroups(BasePath: string);
var i,j: integer; FileName: string; M: TMemoryStream;
    E: TEntity;
begin
  Screen.Cursor:=crHourGlass;
  try
    M:=TMemoryStream.Create;
    try
      FileName:=IncludeTrailingPathDelimiter(BasePath)+'HISTORYGROUPS.CFG';
      if LoadStream(FileName,M) then
      begin
        if M.Size = SizeOf(HistGroups) then
        begin
          M.ReadBuffer(HistGroups,SizeOf(HistGroups));
//---- ����������� ������ ������ ������������ ����� -----
          for i:=1 to 125 do
            for j:=1 to 8 do
            begin
              E:=Find(HistGroups[i].Place[j]);
              if Assigned(E) then
              begin
                HistGroups[i].Entity[j]:=E;
                if E.IsKontur and (HistGroups[i].Kind[j] = 2) or E.IsDigit then
                  HistGroups[i].EU[j]:='%'
                else
                  HistGroups[i].EU[j]:=(E as TCustomAnaOut).EUDesc;
                if E.IsAnalog or E.IsKontur then
                  HistGroups[i].DF[j]:=Ord((E as TCustomAnaOut).PVFormat)
                else
                  HistGroups[i].DF[j]:=0;
              end
              else
              begin
                HistGroups[i].Place[j]:='';
                HistGroups[i].Entity[j]:=nil;
                HistGroups[i].Kind[j]:=0;
                HistGroups[i].EU[j]:='';
                HistGroups[i].DF[j]:=1;
              end;
            end;
        end;
      end
      else
        AddSysMess('�������� �����','������ ��� �������� ������������ �����');
    finally
      M.Free;
    end;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TCaddy.SaveHistGroupsToINI(BasePath: string);
var
  i,j: integer;
  FileName, BackName: string;
  T: TextFile;
begin
  FileName:=IncludeTrailingPathDelimiter(BasePath)+'HISTORYGROUPS.INI';;
  BackName:=ChangeFileExt(FileName,'.~ini');
  if FileExists(BackName) and DeleteFile(BackName) or
     not FileExists(BackName) then
  begin
    if FileExists(FileName) and RenameFile(FileName,BackName) or
       not FileExists(FileName) then
    begin
      AssignFile(T,FileName);
      Rewrite(T);
      try
        for i:=1 to 125 do
        begin
          Writeln(T, '[' + IntToStr(i) + ']');
          Writeln(T, 'GroupName=' + HistGroups[i].GroupName);
          for j:= 1 to 8 do
          begin
            Writeln(T, 'Place' + IntToStr(j) + '=' + HistGroups[i].Place[j]);
            Writeln(T, 'Kind' + IntToStr(j) + '=' + IntToStr(HistGroups[i].Kind[j]));
            Writeln(T, 'EU' + IntToStr(j) + '=' + HistGroups[i].EU[j]);
            Writeln(T, 'DF' + IntToStr(j) + '=' + IntToStr(HistGroups[i].DF[j]));
          end;
          Writeln(T);
        end;
      finally
        CloseFile(T);
      end;
    end;
  end;
end;

procedure TCaddy.SaveHistGroups(BasePath: string);
var AF,M: TMemoryStream; CRC32: Cardinal;
    PtClass, FileName, BackName: string; F: TFileStream;
begin
  Screen.Cursor:=crHourGlass;
  try
    M:=TMemoryStream.Create;
    AF:=TMemoryStream.Create;
    try
      AF.WriteBuffer(HistGroups,SizeOf(HistGroups));
      if AF.Size > 0 then
      begin
        AF.Position:=0;
        M.Clear;
        CompressStream(AF,M);
        M.Position:=0;
      end
      else
        M.Clear;
      CRC32:=0; CalcCRC32(M.Memory,M.Size,CRC32);
      PtClass:=IncludeTrailingPathDelimiter(BasePath)+'HISTORYGROUPS.CFG';
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
          if ForceDirectories(BasePath) then
          begin
            try
              F:=TFileStream.Create(PtClass,fmCreate or fmShareExclusive);
            except
              ShowMessage(kmWarning,'���� "'+ExtractFileName(PtClass)+
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
    end;
    HistChanged:=False;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TCaddy.RenameEntity(E: TEntity; NewName: string);
var I,J: integer; N: TEntity; Found: boolean; OldName: string;
    AlarmItem: TActiveAlarmLogItem; SwitchItem: TActiveSwitchLogItem;
begin
  OldName := '';
  if not Assigned(Find(NewName)) then
  begin
    if IsValidIdent(NewName) then
    begin
      if Assigned(Find(E.PtName)) then
      begin
        OldName := E.PtName;
        E.PtName := NewName;
        N := FirstEntity;
        while N <> nil do
        begin
          N.Notify(enRename, E);
          N := N.NextEntity;
        end;
      end;
      Changed := True;
      Found := False;
      for I := 1 to 125 do for J := 1 to 8 do
        if HistGroups[I].Entity[J] = E then
        begin
          HistGroups[I].Place[J] := NewName;
          Found := True;
        end;
      HistChanged := Found;
//-----------------------------------------------------------------------
      if OldName <> '' then
      begin
        for i:=ActiveAlarmLog.Count-1 downto 0 do
        begin
          AlarmItem:=TActiveAlarmLogItem(ActiveAlarmLog.Items[i]);
          if AlarmItem.Position = OldName then AlarmItem.Position:=NewName;
        end;
        for i := 0 to Length(FOnAlarmLogUpdate)-1 do
          FOnAlarmLogUpdate[i](Self);
        for i:=ActiveSwitchLog.Count-1 downto 0 do
        begin
          SwitchItem:=TActiveSwitchLogItem(ActiveSwitchLog.Items[i]);
          if SwitchItem.Position = OldName then SwitchItem.Position:=NewName;
        end;
        for i := 0 to Length(FOnSwitchLogUpdate)-1 do
           FOnSwitchLogUpdate[i](Self);
      end;
//-----------------------------------------------------------------------
    end
    else
      raise Exception.Create('��� "'+NewName+
                             '" �� �������� ���������� ���������������!');
  end
  else
    raise Exception.Create('��� "'+NewName+'" ��� ������������!');
end;

procedure TCaddy.AddChange(Position, Parameter, OldValue,
  NewValue, Descriptor, Autor: string);
var Item: TCashChangeLogItem;
begin
  Item.SnapTime:=Now;
  Item.Station:=Station;
  Item.Position:=Position;
  Item.Parameter:=Parameter;
  Item.OldValue:=OldValue;
  Item.NewValue:=NewValue;
  Item.Descriptor:=Descriptor;
  Item.Autor:=Autor;
  if CashChangeLog.Length = High(CashChangeLog.Body) then SaveCashToChangeLog;
  Inc(CashChangeLog.Length);
  CashChangeLog.Body[CashChangeLog.Length]:=Item;
end;

procedure TCaddy.SaveCashToAlarmLog;
begin
  with TSaveAlarmLog.Create(CurrentLogsPath,CashAlarmLog) do
  begin
    OnTerminate:=ThreadFinished;
    OnShowMessage:=ShowThreadMessage;
    Resume;
  end;
  CashAlarmLog.Length:=0;
end;

procedure TCaddy.SaveCashToSwitchLog;
begin
  with TSaveSwitchLog.Create(CurrentLogsPath, CashSwitchLog) do
  begin
    OnTerminate := ThreadFinished;
    OnShowMessage := ShowThreadMessage;
    Resume;
  end;
  CashSwitchLog.Length := 0;
end;

procedure TCaddy.SaveCashToChangeLog;
begin
  with TSaveChangeLog.Create(CurrentLogsPath, CashChangeLog) do
  begin
    OnTerminate := ThreadFinished;
    OnShowMessage := ShowThreadMessage;
    Resume;
  end;
  CashChangeLog.Length := 0;
end;

procedure TCaddy.SaveCashToSystemLog;
begin
  with TSaveSystemLog.Create(CurrentLogsPath,CashSystemLog) do
  begin
    OnTerminate:=ThreadFinished;
    OnShowMessage:=ShowThreadMessage;
    Resume;
  end;
  CashSystemLog.Length:=0;
end;

procedure TCaddy.SaveCashToBaseTables;
begin
  with TSaveTableTrends.Create(CurrentTablePath,CashMinuteSnap,CashHourSnap) do
  begin
    OnTerminate:=ThreadFinished;
    OnShowMessage:=ShowThreadMessage;
    Resume;
  end;
  CashMinuteSnap.Length := 0;
  CashHourSnap.Length := 0;
end;

procedure TCaddy.SaveCashToExportTables;
begin
  with TExportMinuteTables.Create(ConnectionString, CashExportMinuteSnap) do
  begin
    OnTerminate:=ThreadFinished;
    OnShowMessage:=ShowThreadMessage;
    OnLogMessage:=LogThreadMessage;
    Resume;
  end;
  CashExportMinuteSnap.Length := 0;
end;

procedure TCaddy.SaveCashToBaseTrend;
begin
  with TSaveRealTrends.Create(CurrentTrendPath,CashRealTrend) do
  begin
    OnTerminate:=ThreadFinished;
    OnShowMessage:=ShowThreadMessage;
    Resume;
  end;
  CashRealTrend.Length:=0;
end;

procedure TCaddy.SaveCashToRealBase;
begin
  with TSaveRealValues.Create(CurrentBasePath,CashRealValues) do
  begin
    OnTerminate:=ThreadFinished;
    OnShowMessage:=ShowThreadMessage;
    Resume;
  end;
end;

procedure TCaddy.DeleteOldFiles;
var Dir: array of string; Path: string;
    OldTimes: array of TDateTime;
    Deleting: array of boolean;
begin
  SetLength(Dir,6);
  Dir[0]:=IncludeTrailingPathDelimiter(CurrentReportsLogPath);
  Dir[1]:=IncludeTrailingPathDelimiter(CurrentTrendPath);
  Path:=IncludeTrailingPathDelimiter(CurrentTablePath);
  Dir[2]:=IncludeTrailingPathDelimiter(Path+ATableType[ttMinSnap]);
  Dir[3]:=IncludeTrailingPathDelimiter(Path+ATableType[ttHourSnap]);
  Dir[4]:=IncludeTrailingPathDelimiter(Path+ATableType[ttHourAver]);
  Dir[5]:=IncludeTrailingPathDelimiter(CurrentLogsPath);
  SetLength(OldTimes,6);
  OldTimes[0]:=Today-ReportLogOldTimes*1.0;
  OldTimes[1]:=Today-TrendOldTimes*1.0;
  OldTimes[2]:=Today-SnapMinOldTimes*1.0;
  OldTimes[3]:=Today-SnapHourOldTimes*1.0;
  OldTimes[4]:=Today-AverHourOldTimes*1.0;
  OldTimes[5]:=Today-LogOldTimes*1.0;
  SetLength(Deleting,6);
  Deleting[0]:=(ReportLogOldTimes > 0);
  Deleting[1]:=(TrendOldTimes > 0);
  Deleting[2]:=(SnapMinOldTimes > 0);
  Deleting[3]:=(SnapHourOldTimes > 0);
  Deleting[4]:=(AverHourOldTimes > 0);
  Deleting[5]:=(LogOldTimes > 0);
  with TDeleteTree.Create(Dir,OldTimes,Deleting) do
  begin
    OnTerminate:=Caddy.ThreadFinished;
    OnShowMessage:=ShowThreadMessage;
    Resume;
  end;
end;

procedure TCaddy.EmptyBase;
var i: integer;
begin
  for i := 0 to ChannelCount do
    FetchList[i].List.Clear;
  FirstEntity := nil;
  LastEntity := nil;
end;

procedure TCaddy.AddAlarm(AKind: TAlarmState; E: TEntity);
var Item: TActiveAlarmLogItem; Found: boolean; i,FoundIndex: integer;
  function GetSetPointText: string;
  begin
    case AKind of
    asNoLink: Result:='------';
asShortBadPV: Result:='�.�.';
 asOpenBadPV: Result:='�����';
     asBadPV: Result:='������';
        asHH: if E is TCustomAnaOut then
              with TCustomAnaOut(E) do
                Result:=Format('%.'+IntToStr(Ord(PVFormat))+'f %s',[PVHHTP,EUDesc])
              else
                Result:='';
        asLL: if E is TCustomAnaOut then
              with TCustomAnaOut(E) do
                Result:=Format('%.'+IntToStr(Ord(PVFormat))+'f %s',[PVLLTP,EUDesc])
              else
                Result:='';
        asON: if E is TCustomDigOut then
              with TCustomDigOut(E) do
                Result:=TextUp
              else
                Result:='';
       asOFF: if E is TCustomDigOut then
              with TCustomDigOut(E) do
                Result:=TextDown
              else
                Result:='';
        asHi: if E is TCustomAnaOut then
              with TCustomAnaOut(E) do
                Result:=Format('%.'+IntToStr(Ord(PVFormat))+'f %s',[PVHiTP,EUDesc])
              else
                Result:='';
        asLo: if E is TCustomAnaOut then
              with TCustomAnaOut(E) do
                Result:=Format('%.'+IntToStr(Ord(PVFormat))+'f %s',[PVLoTP,EUDesc])
              else
                Result:='';
        asDH: if E is TCustomAnaOut then
              with TCustomAnaOut(E) do
                Result:=Format('%.'+IntToStr(Ord(PVFormat))+'f %s',[PVDHTP,EUDesc])
               else
                Result:='';
        asDL: if E is TCustomAnaOut then
              with TCustomAnaOut(E) do
                Result:=Format('%.'+IntToStr(Ord(PVFormat))+'f %s',[PVDLTP,EUDesc])
              else
                Result:='';
      asInfo: Result:='������.';
   asTimeOut: Result:='�������';
      asNone: Result:='';
    else
      Result:='';
    end;
  end;
begin
  E.AlarmStatus:=E.AlarmStatus+[AKind];
//  E.ErrorMess:=AAlarmState[AKind];
  if E.Logged and (E.AlarmStatus <> E.OldAlarmStatus) then
  begin
    if Caddy.NoAsk then                        // ��������� 15.07.12
      E.ConfirmStatus:=E.ConfirmStatus+[AKind] // ��������� 15.07.12
    else                                       // ��������� 15.07.12
    begin
      if not E.Asked or
        (AKind = asNoLink) then                // ��������� 08.10.14
        E.ConfirmStatus:=E.ConfirmStatus+[AKind]
      else
        E.ConfirmStatus:=E.ConfirmStatus-[AKind];
    end;
    Found:=False; FoundIndex:=-1; Item:=nil;
    for i:=0 to ActiveAlarmLog.Count-1 do
    begin
      Item:=TActiveAlarmLogItem(ActiveAlarmLog.Items[i]);
      if (Item.Kind = AKind) and (Item.Position = E.PtName) then
      begin
        Found:=True;
        FoundIndex:=i;
        Break;
      end
    end;
    if not Found then Item:=TActiveAlarmLogItem.Create;
    Item.ImageIndex:=EntityClassIndex(E.ClassType);
    Item.Kind:=AKind;
    Item.SnapTime:=Now;
    Item.Source:=E;
    Item.Position:=E.PtName;
    Item.Value:=E.PtText;
    Item.SetPoint:=GetSetPointText;
    Item.Mess:=AAlarmState[AKind];
    Item.Descriptor:=E.PtDesc;
    Item.AlarmStatus:=E.AlarmStatus;
    Item.ConfirmStatus:=E.ConfirmStatus;
    if Caddy.NoAddNoLinkInAciveLog then
    begin
      if AKind <> asNoLink then
      begin
        if not Found then
          ActiveAlarmLog.Insert(0,Item)
        else
          ActiveAlarmLog.Move(FoundIndex,0);
      end;
    end
    else
    begin
      if not Found then
        ActiveAlarmLog.Insert(0,Item)
      else
        ActiveAlarmLog.Move(FoundIndex,0);
    end;
    for i := 0 to Length(FOnAlarmLogUpdate)-1 do
      FOnAlarmLogUpdate[i](Self);
    if not E.FirstCalc then
      AddAlarm(Item.Position,AAlarmText[Item.Kind],Item.Value,Item.SetPoint,
               Item.Mess,Item.Descriptor);
    if not Assigned(Beeper) then
    begin
      Beeper:=TBeeper.Create(Self,bkSpeaker);
      Beeper.Kind:=BeeperKind;
      Beeper.Resume;
    end;
    if Caddy.NoAsk then          // ��������� 15.07.12
      Beeper.Say(E.AlarmStatus)  // ��������� 15.07.12
    else                         // ��������� 15.07.12
      Beeper.Say(E.AlarmStatus - E.ConfirmStatus);
  end;
end;

procedure TCaddy.RemoveAlarm(AKind: TAlarmState; E: TEntity);
var i, n: integer; Item: TActiveAlarmLogItem;
begin
  E.AlarmStatus:=E.AlarmStatus-[AKind];
  if E.ErrorMess=AAlarmState[AKind] then E.ErrorMess:='';
  if E.FLogged and (E.AlarmStatus <> E.OldAlarmStatus) then
  begin
    for i:=0 to ActiveAlarmLog.Count-1 do
    begin
      Item:=TActiveAlarmLogItem(ActiveAlarmLog.Items[i]);
      if (Item.Kind = AKind) and (Item.Position = E.PtName) then
      begin
        Item.AlarmStatus:=E.AlarmStatus;
        Item.ConfirmStatus:=E.ConfirmStatus;
        Item.Value:=E.GetTextValue;
        AddAlarm(Item.Position,AAlarmText[Item.Kind],Item.Value,Item.SetPoint,
                 '�������� � �����',Item.Descriptor);
        if AKind in E.ConfirmStatus then
          ActiveAlarmLog.Remove(Item);
        if E.Asked and
           (AKind <> asNoLink) then  // ��������� 08.10.14
          E.LostAlarmStatus:=E.LostAlarmStatus+[AKind];
        for n := 0 to Length(FOnAlarmLogUpdate)-1 do
          FOnAlarmLogUpdate[n](Self);
        Break;
      end;
    end;
    if Caddy.NoAsk and (ActiveAlarmLog.Count = 0) then // ��������� 15.07.12
      Beeper.ShortUp;                                  // ��������� 15.07.12
  end;
end;

procedure TCaddy.SmartAskByIndex(Index: integer);
var Item: TActiveAlarmLogItem; E: TEntity; i: integer;
begin
  if Caddy.NoAsk then Exit; // ��������� 15.07.12
  with ActiveAlarmLog do
  if (Index >= 0) and (Index < Count) then
  begin
    Item:=Items[Index] as TActiveAlarmLogItem;
    E:=Item.Source as TEntity;
    if E.Asked then
    begin
      E.ConfirmStatus:=E.ConfirmStatus+[Item.Kind];
      if E.ConfirmStatus <> E.OldConfirmStatus then
      begin
        Item.ConfirmStatus:=Item.ConfirmStatus+[Item.Kind];
        E.LostAlarmStatus:=E.LostAlarmStatus-[Item.Kind];
        AddAlarm(Item.Position,AAlarmText[Item.Kind],Item.Value,Item.SetPoint,
                 '���������� '+Autor,Item.Descriptor);
        if not (Item.Kind in E.AlarmStatus) then ActiveAlarmLog.Remove(Item);
        for i := 0 to Length(FOnAlarmLogUpdate)-1 do
          FOnAlarmLogUpdate[i](Self);
        if not Assigned(Beeper) then
        begin
          Beeper:=TBeeper.Create(Self,bkSpeaker);
          Beeper.Kind:=BeeperKind;
          Beeper.Resume;
        end;
        Beeper.ShortUp;
      end;
    end;
  end;
end;

procedure TCaddy.SmartAskByEntity(E: TEntity; Alarms: TSetAlarmStatus);
var i, n: integer; Item: TActiveAlarmLogItem; T: TEntity;
begin
  if Caddy.NoAsk then Exit; // ��������� 15.07.12
  with ActiveAlarmLog do
  for i:=Count-1 downto 0 do
  begin
    Item:=Items[i] as TActiveAlarmLogItem;
    T:=Item.Source as TEntity;
    if (T = E) and (Item.Kind in Alarms) and E.Asked then
    begin
      E.ConfirmStatus:=E.ConfirmStatus+[Item.Kind];
      if E.ConfirmStatus <> E.OldConfirmStatus then
      begin
        Item.ConfirmStatus:=Item.ConfirmStatus+[Item.Kind];
        E.LostAlarmStatus:=E.LostAlarmStatus-[Item.Kind];
        AddAlarm(Item.Position,AAlarmText[Item.Kind],Item.Value,Item.SetPoint,
                 '���������� '+Autor,Item.Descriptor);
        if not (Item.Kind in E.AlarmStatus) then ActiveAlarmLog.Remove(Item);
        for n := 0 to Length(FOnAlarmLogUpdate)-1 do
          FOnAlarmLogUpdate[n](Self);
        if not Assigned(Beeper) then
        begin
          Beeper:=TBeeper.Create(Self,bkSpeaker);
          Beeper.Kind:=BeeperKind;
          Beeper.Resume;
        end;
        Beeper.ShortUp;
      end;
    end;
  end;
end;

procedure TCaddy.AddAlarm(Position, Parameter, Value, SetPoint, Mess,
  Descriptor: string);
var Item: TCashAlarmLogItem;
begin
  Item.SnapTime:=Now;
  Item.Station:=Station;
  Item.Position:=Position;
  Item.Parameter:=Parameter;
  Item.Value:=Value;
  Item.SetPoint:=SetPoint;
  Item.Mess:=Mess;
  Item.Descriptor:=Descriptor;
  if CashAlarmLog.Length = High(CashAlarmLog.Body) then SaveCashToAlarmLog;
  Inc(CashAlarmLog.Length);
  CashAlarmLog.Body[CashAlarmLog.Length]:=Item;
end;

procedure TCaddy.AddSwitch(AKind: TAlarmState; E: TEntity);
var Item: TActiveSwitchLogItem; Found: boolean; i,FoundIndex: integer;
  function GetSetPointText: string;
  begin
    case AKind of
        asON: if E is TCustomDigOut then
              with TCustomDigOut(E) do
                Result:=TextUp
              else
                Result:='';
       asOFF: if E is TCustomDigOut then
              with TCustomDigOut(E) do
                Result:=TextDown
              else
                Result:='';
      asNone: Result:='';
    else
      Result:='';
    end;
  end;
begin
  E.FSwitchStatus:=E.FSwitchStatus+[AKind];
  if E.Logged then
  begin
    Found:=False; FoundIndex:=-1; Item:=nil;
    for i:=0 to ActiveSwitchLog.Count-1 do
    begin
      Item:=TActiveSwitchLogItem(ActiveSwitchLog.Items[i]);
      if (Item.Kind = AKind) and (Item.Position = E.PtName) then
      begin
        Found:=True;
        FoundIndex:=i;
        Break;
      end
    end;
    if not Found then Item:=TActiveSwitchLogItem.Create;
    Item.ImageIndex:=EntityClassIndex(E.ClassType);
    Item.Kind:=AKind;
    Item.SnapTime:=Now;
    Item.Position:=E.PtName;
    Item.Value:=E.PtText;
    Item.Descriptor:=E.PtDesc;
    if not Found then
      ActiveSwitchLog.Insert(0,Item)
    else
      ActiveSwitchLog.Move(FoundIndex,0);
    for i := 0 to Length(FOnSwitchLogUpdate)-1 do
      FOnSwitchLogUpdate[i](Self);
    if not E.FirstCalc then
      AddSwitch(Item.Position,'PV',(E as TCustomDigOut).TextLastValue,
                Item.Value,Item.Descriptor);
  end;
end;

procedure TCaddy.RemoveSwitch(AKind: TAlarmState; E: TEntity);
var i, n: integer; Item: TActiveSwitchLogItem;
begin
  E.FSwitchStatus:=E.FSwitchStatus-[AKind];
  if E.FLogged then
  begin
    for i:=0 to ActiveSwitchLog.Count-1 do
    begin
      Item:=TActiveSwitchLogItem(ActiveSwitchLog.Items[i]);
      if (Item.Kind = AKind) and (Item.Position = E.PtName) then
      begin
        ActiveSwitchLog.Remove(Item);
        for n := 0 to Length(FOnSwitchLogUpdate)-1 do
          FOnSwitchLogUpdate[n](Self);
        Break;
      end;
    end;
  end;
end;

procedure TCaddy.AddSwitch(Position, Parameter, OldValue, NewValue,
  Descriptor: string);
var Item: TCashSwitchLogItem;
begin
  Item.SnapTime := Now;
  Item.Station := Station;
  Item.Position := Position;
  Item.Parameter := Parameter;
  Item.OldValue := OldValue;
  Item.NewValue := NewValue;
  Item.Descriptor := Descriptor;
  if CashSwitchLog.Length = High(CashSwitchLog.Body) then SaveCashToSwitchLog;
  Inc(CashSwitchLog.Length);
  CashSwitchLog.Body[CashSwitchLog.Length] := Item;
end;

procedure TCaddy.RemoveAlarms(E: TEntity);
var i: integer; Item: TActiveAlarmLogItem;
begin
  E.AlarmStatus:=[];
  E.OldAlarmStatus:=[];
  E.ConfirmStatus:=[];
  E.OldConfirmStatus:=[];
  E.LostAlarmStatus:=[];
  E.ErrorMess:='';
  for i:=ActiveAlarmLog.Count-1 downto 0 do
  begin
    Item:=TActiveAlarmLogItem(ActiveAlarmLog.Items[i]);
    if Item.Position = E.PtName then ActiveAlarmLog.Remove(Item);
  end;
  for i := 0 to Length(FOnAlarmLogUpdate)-1 do
    FOnAlarmLogUpdate[i](Self);
end;

procedure TCaddy.RemoveSwitchs(E: TEntity);
var i: integer; Item: TActiveSwitchLogItem;
begin
  E.FSwitchStatus:=[];
  for i:=ActiveSwitchLog.Count-1 downto 0 do
  begin
    Item:=TActiveSwitchLogItem(ActiveSwitchLog.Items[i]);
    if Item.Position = E.PtName then ActiveSwitchLog.Remove(Item);
  end;
  for i := 0 to Length(FOnSwitchLogUpdate)-1 do
    FOnSwitchLogUpdate[i](Self);
end;

procedure TCaddy.AddSysMess(Position, Descriptor: string);
var Item: TCashSystemLogItem;
begin
  Item.SnapTime:=Now;
  Item.Station:=Station;
  Item.Position:=Position;
  Item.Descriptor:=Descriptor;
  if CashSystemLog.Length = High(CashSystemLog.Body) then SaveCashToSystemLog;
  Inc(CashSystemLog.Length);
  CashSystemLog.Body[CashSystemLog.Length]:=Item;
end;

procedure TCaddy.ExportMinuteTables;
var Item: TCashExportTableItem; DT: TDateTime; i,j: integer; Quality: Boolean;
begin
  CashExportMinuteSnap.Length := 0;
  DT:=Now;
  for i:=1 to 125 do
  if not HistGroups[i].Empty then
  begin
    Item.SnapTime:=DT;
    for j:=1 to 8 do
    begin
      Item.Position:='';
      Item.Val:=0.0;
      if HistGroups[i].Entity[j] is TCustomAnaOut then
      begin
        with HistGroups[i].Entity[j] as TCustomAnaOut do
        begin
          Quality:= not ((asNoLink in FAlarmStatus) or
                         (asShortBadPV in FAlarmStatus) or
                         (asOpenBadPV in FAlarmStatus));
          if Quality then
          case HistGroups[i].Kind[j] of
            0: begin
                 Item.Val:=PV;
                 Item.Position:=HistGroups[i].Entity[j].PtName + '.PV';
                 Inc(CashExportMinuteSnap.Length);
                 CashExportMinuteSnap.Body[CashExportMinuteSnap.Length]:=Item;
               end;
            1: begin
                 Item.Val:=FSP;
                 Item.Position:=HistGroups[i].Entity[j].PtName + '.SP';
                 Inc(CashExportMinuteSnap.Length);
                 CashExportMinuteSnap.Body[CashExportMinuteSnap.Length]:=Item;
               end;
            2: begin
                 Item.Val:=FOP;
                 Item.Position:=HistGroups[i].Entity[j].PtName + '.OP';
                 Inc(CashExportMinuteSnap.Length);
                 CashExportMinuteSnap.Body[CashExportMinuteSnap.Length]:=Item;
               end;
          end;
        end;
      end;
      if HistGroups[i].Entity[j] is TCustomDigOut then
      begin
        with HistGroups[i].Entity[j] as TCustomDigOut do
        begin
          Quality:= not ((asNoLink in FAlarmStatus) or
                         (asShortBadPV in FAlarmStatus) or
                         (asOpenBadPV in FAlarmStatus));
          if Quality then
          begin
            if PV then
              Item.Val:=100.0
            else
              Item.Val:=0.0;
            Item.Position:=HistGroups[i].Entity[j].PtName + '.PV';
            Inc(CashExportMinuteSnap.Length);
            CashExportMinuteSnap.Body[CashExportMinuteSnap.Length]:=Item;
          end;
        end;
      end;
    end;
  end;
end;

procedure TCaddy.UpdateMinuteTables;
var Item: TCashTrendTableItem; DT: TDateTime; i,j: integer;
begin
  DT:=Now;
  for i:=1 to 125 do
  if not HistGroups[i].Empty then
  begin
    Item.SnapTime:=DT;
    Item.GroupNo:=i;
    for j:=1 to 8 do
    begin
      Item.Val[j]:=0.0;
      Item.Quality[j]:=False;
      if HistGroups[i].Entity[j] is TCustomAnaOut then
      begin
        with HistGroups[i].Entity[j] as TCustomAnaOut do
        begin
          case HistGroups[i].Kind[j] of
            0: Item.Val[j]:=PV;
            1: Item.Val[j]:=FSP;
            2: Item.Val[j]:=FOP;
          end;
          Item.Quality[j]:= not ((asNoLink in FAlarmStatus) or
                                 (asShortBadPV in FAlarmStatus) or
                                 (asOpenBadPV in FAlarmStatus));
        end;
      end;
      if HistGroups[i].Entity[j] is TCustomDigOut then
      begin
        with HistGroups[i].Entity[j] as TCustomDigOut do
        begin
          if PV then
            Item.Val[j]:=100.0
          else
            Item.Val[j]:=0.0;
          Item.Quality[j]:= not ((asNoLink in FAlarmStatus) or
                                 (asShortBadPV in FAlarmStatus) or
                                 (asOpenBadPV in FAlarmStatus));
        end;
      end;
    end;
    Inc(CashMinuteSnap.Length);
    CashMinuteSnap.Body[CashMinuteSnap.Length]:=Item;
  end;
end;

procedure TCaddy.UpdateHourTables;
var Item: TCashTrendTableItem; DT: TDateTime; i,j: integer;
begin
  DT:=Now;
  for i:=1 to 125 do
  if not HistGroups[i].Empty then
  begin
    Item.SnapTime:=DT;
    Item.GroupNo:=i;
    for j:=1 to 8 do
    begin
      Item.Val[j]:=0.0;
      Item.Quality[j]:=False;
      if HistGroups[i].Entity[j] is TCustomAnaOut then
      begin
        with HistGroups[i].Entity[j] as TCustomAnaOut do
        begin
          case HistGroups[i].Kind[j] of
            0: Item.Val[j]:=PV;
            1: Item.Val[j]:=FSP;
            2: Item.Val[j]:=FOP;
          end;
          Item.Quality[j]:= not ((asNoLink in FAlarmStatus) or
                                 (asShortBadPV in FAlarmStatus) or
                                 (asOpenBadPV in FAlarmStatus));
        end;
      end;
      if HistGroups[i].Entity[j] is TCustomDigOut then
      begin
        with HistGroups[i].Entity[j] as TCustomDigOut do
        begin
          if PV then
            Item.Val[j]:=100.0
          else
            Item.Val[j]:=0.0;
          Item.Quality[j]:= not ((asNoLink in FAlarmStatus) or
                                 (asShortBadPV in FAlarmStatus) or
                                 (asOpenBadPV in FAlarmStatus));
        end;
      end;
    end;
    Inc(CashHourSnap.Length);
    CashHourSnap.Body[CashHourSnap.Length]:=Item;
  end;
end;

procedure TCaddy.SetHistChanged(const Value: boolean);
var i,j: integer; Found: boolean;
begin
  FHistChanged := Value;
  if FHistChanged then
  begin
    for i:=1 to 125 do
    begin
      Found:=False;
      for j:=1 to 8 do
      if Assigned(HistGroups[i].Entity[j]) then
      begin
        Found:=True;
        Break;
      end;
      HistGroups[i].Empty:=not Found;
    end;
  end;
end;

procedure TCaddy.AddRealTrend(Param: string; Value: Single; Kind: boolean);
var Item: TCashRealTrendItem;
begin
  Item.SnapTime:=Now;
  Item.ParamName:=Param;
  Item.Value:=Value;
  Item.Kind:=Kind;
  if CashRealTrend.Length = High(CashRealTrend.Body) then SaveCashToBaseTrend;
  Inc(CashRealTrend.Length);
  CashRealTrend.Body[CashRealTrend.Length]:=Item;
end;

function TCaddy.ServerFindRealValue(Param: string;
                                    var Item: TCashRealBaseItem): boolean;
var i: integer;
begin
  Result:=False;
  for i:=1 to CashRealValues.Length do
  if CashRealValues.Body[i].ParamName = Param then
  begin
    Item:=CashRealValues.Body[i];
    Result:=True;
    Break;
  end;
end;

procedure TCaddy.AddRealValue(Param: string; Value: Double; ValText: string;
                              Kind: TKindStatus);
var Item: TCashRealBaseItem; i: integer; Found: boolean;
begin
  Found:=False;
  for i:=1 to CashRealValues.Length do
  if CashRealValues.Body[i].ParamName = Param then
  begin
    CashRealValues.Body[i].SnapTime:=Now;
    CashRealValues.Body[i].Value:=Value;
    CashRealValues.Body[i].ValText:=Copy(ValText,1,30);
    CashRealValues.Body[i].Kind:=Kind;
    Found:=True;
    Break;
  end;
  if not Found then
  begin
    Item.SnapTime:=Now;
    Item.ParamName:=Copy(Param,1,20);
    Item.Value:=Value;
    Item.ValText:=Copy(ValText,1,30);
    Item.Kind:=Kind;
    if CashRealValues.Length < High(CashRealValues.Body) then
    begin
      Inc(CashRealValues.Length);
      CashRealValues.Body[CashRealValues.Length]:=Item;
    end;  
  end;
end;

procedure TCaddy.ThreadFinished(Sender: TObject);
begin
  if Sender is TSaveRealTrends then
    PostMessage(Parent.Handle,WM_TrendFresh,0,0)
  else
  if Sender is TSaveTableTrends then
    PostMessage(Parent.Handle,WM_TableFresh,0,0)
  else
  if Sender is TSaveAlarmLog then
    PostMessage(Parent.Handle,WM_LogFresh,0,0)
  else
  if Sender is TSaveSwitchLog then
    PostMessage(Parent.Handle,WM_LogFresh,0,0)
  else
  if Sender is TSaveChangeLog then
    PostMessage(Parent.Handle,WM_LogFresh,0,0)
  else
  if Sender is TSaveSystemLog then
    PostMessage(Parent.Handle,WM_LogFresh,0,0)
  else
  if Sender is TSaveTableAverages then
    PostMessage(Parent.Handle,WM_AveragesFresh,0,0)
end;

procedure TCaddy.ShowMessage(Kind: TKindMessage; Mess: string);
begin
  if Assigned(FOnMessage) then FOnMessage(Self,Kind,Mess);
end;

function TCaddy.ShowQuestion(Question: string): boolean;
begin
  Result:=False;
  if Assigned(FOnQuestion) then FOnQuestion(Self,Question,Result);
end;

function TCaddy.LoadValuesFromRealBase(FileName: string): boolean;
var M,MD: TMemoryStream; ek,ea,fn: integer;
    EXTCRC,CRC32: Cardinal; F: TFileStream; A: array of Byte;
    Item: TCashRealBaseItem; E: TEntity; PtName,ParamName,LastPtName: string;
begin
  LastPtName:='';
  Result:=False;
  if FileExists(FileName) then
  begin
    F:=TryOpenToReadFile(FileName);
    if not Assigned(F) then
    begin
      ShowMessage(kmError,'���� "'+ExtractFileName(FileName)+
           '" ����� ������ ���������. �������� ��������� �� ���������!');
      Exit;
    end;
    M:=TMemoryStream.Create;
    MD:=TMemoryStream.Create;
    try
      try
        F.ReadBuffer(EXTCRC,SizeOf(EXTCRC));
        SetLength(A,F.Size-F.Position);
        F.ReadBuffer(A[0],Length(A));
        MD.WriteBuffer(A[0],Length(A));
        MD.Position:=0;
      finally
        F.Free;
      end;
      CRC32:=0; CalcCRC32(MD.Memory,MD.Size,CRC32);
      if CRC32 = EXTCRC then
      begin
        M.Clear;
        try
          DecompressStream(MD,M);
        except
          ShowMessage(kmStatus,'���� "'+ExtractFileName(FileName)+
               '" ��������. �������� ��������� �� ���������!');
          Exit;
        end;
        ek:=0; ea:=0;
        M.Position:=0;
        if M.Size mod SizeOf(Item) = 0 then
        while M.Position < M.Size do
        begin
          M.ReadBuffer(Item,SizeOf(Item));
          fn:=Pos('.',Item.ParamName);
          PtName:=Copy(Item.ParamName,1,fn-1);
          ParamName:=Copy(Item.ParamName,fn+1,Length(Item.ParamName));
          if LastPtName <> PtName then
          begin
            LastPtName:=PtName;
            Inc(ek);
          end;
          Inc(ea);
          E:=Find(PtName);
          if Assigned(E) then
            E.SetParam(ParamName,Item);
        end;
        ShowMessage(kmStatus,
          Format('��������� %s %s � %s.',
            [NumToStr(ea,'���������','��','��','��'),
             NumToStr(ea,'������','��','��','��',False),
             NumToStr(ek,'���','��','���','���')]));
        Result:=True;
      end
      else
        ShowMessage(kmStatus,'������ CRC ��� �������� ����� "'+
                            ExtractFileName(FileName)+'"');
    finally
      MD.Free;
      M.Free;
    end;
  end;
end;

procedure TCaddy.SaveValuesToRealBase(const FileName: string);
var i,ek: integer; Item: TCashRealBaseItem; F: TFileStream;
    AF,M: TMemoryStream; CRC32: Cardinal;
begin
(*  TSaveRealValues.Create(CurrentBasePath, CashRealValues); *)
  M:=TMemoryStream.Create;
  AF:=TMemoryStream.Create;
  try
    for i:=1 to CashRealValues.Length do
    begin
      Item:=CashRealValues.Body[i];
      AF.WriteBuffer(Item,SizeOf(Item));
    end;
    if AF.Size > 0 then
    begin
      AF.Position:=0;
      M.Clear;
      CompressStream(AF,M);
    end
    else
      M.Clear;
    CRC32:=0;
    CalcCRC32(M.Memory,M.Size,CRC32);
    if M.Size > 0 then
    begin
      F:=nil;
      ek:=10;
      repeat
        try
          F:=TFileStream.Create(FileName,fmCreate or fmShareExclusive);
          Break;
        except
          Dec(ek);
          Wait500ms;
        end;
      until ek < 0;
      if (ek < 0) or not Assigned(F) then
      begin
        ShowMessage(kmStatus,'���� "'+ExtractFileName(FileName)+
                      '" ����� ������ ���������. �������� �� ���������.');
        Exit;
      end;
      try
        F.WriteBuffer(CRC32,SizeOf(CRC32));
        M.Position:=0;
        M.SaveToStream(F);
      finally
        F.Free;
      end;
    end;
  finally
    AF.Free;
    M.Free;
  end;
end;

procedure TCustomAnaOut.SetTrend(const Value: boolean);
  function BS(Value: boolean): string;
  begin
    Result:=IfThen(Value,'���','����');
  end;
begin
  if FTrend <> Value then
  begin
    Caddy.AddChange(FPtName,'�����',BS(FTrend),BS(Value),
                              FPtDesc,Caddy.Autor);
    FTrend:=Value;
    if FTrend then FirstCalc:=True;
    FIsTrending:=FTrend;
    Caddy.Changed:=True;
  end;
end;

function TCustomAnaOut.GetLastPV: Double;
begin
  Result:=FLastPV;
end;

procedure TCustomAnaOut.SetCalcScale(const Value: boolean);
  function BS(Value: boolean): string;
  begin
    Result:=IfThen(Value,'���','����');
  end;
begin
  if FCalcScale <> Value then
  begin
    Caddy.AddChange(FPtName,'������� �� �����',BS(FCalcScale),BS(Value),
                              FPtDesc,Caddy.Autor);
    FCalcScale:=Value;
    Caddy.Changed:=True;
  end;
end;

function TCustomAnaOut.GetPtVal: string;
begin
  if (asNoLink in AlarmStatus)
    or
     (FBadDB <> adNone) and
     ((asShortBadPV in AlarmStatus) or (asOpenBadPV in AlarmStatus)) then
    Result:='------'
  else
    Result:=Format('%.'+IntToStr(Ord(FPVFormat))+'f',[FPV])
end;

{ TCustomDigInp }

procedure TCustomDigInp.Assign(E: TEntity);
var T: TCustomDigInp;
begin
  inherited;
  T:=E as TCustomDigInp;
  FInvert:=T.Invert;
end;

constructor TCustomDigInp.Create;
begin
  inherited;
  FIsCommand:=True;
  FIsDigit:=True;
  FIsParam:=True;
  FEntityKind:=ekDigit;
  FOP:=False;
  FInvert:=False;
end;

function TCustomDigInp.GetBlockName: string;
begin
  Result:='��������';
end;

function TCustomDigInp.GetPlaceName: string;
begin
  Result:='��������';
end;

function TCustomDigInp.GetPTVal: string;
begin
  if asNoLink in AlarmStatus then
    Result:='------'
  else
    Result:=IfThen(FOP,'�������','��������');
end;

function TCustomDigInp.GetTextValue: string;
begin
  if asNoLink in AlarmStatus then
    Result:='------'
  else
    Result:=IfThen(FOP,'�������','��������');
end;

procedure TCustomDigInp.SetInvert(const Value: Boolean);
  function BS(Value: boolean): string;
  begin
    Result:=IfThen(Value,'���','����');
  end;
begin
  if FInvert <> Value then
  begin
    Caddy.AddChange(FPtName,'��������',BS(FInvert),
                              BS(Value),FPtDesc,Caddy.Autor);
    FInvert:=Value;
    Caddy.Changed:=True;
  end;
end;

procedure TCustomDigInp.SetOP(const Value: Boolean);
const ADig: array[Boolean] of Single = (0.0,1.0);
begin
  if FOP <> Value then
  begin
    FOP:=Value;
  end;
end;

procedure TCustomDigInp.SetRaw(const Value: Double);
var R: Double;
begin
  R:=Value;
  if FInvert then
    OP:=not (R > 0)
  else
    OP:=(R > 0);
  inherited SetRaw(Value);
end;

{ TCustomAnaInp }

procedure TCustomAnaInp.Assign(E: TEntity);
var T: TCustomAnaInp;
begin
  inherited;
  T:=E as TCustomAnaInp;
  FEUDesc:=T.EUDesc;
  FOPFormat:=T.OPFormat;
  FOPEUHi:=T.OPEUHi;
  FOPEULo:=T.OPEULo;
end;

constructor TCustomAnaInp.Create;
begin
  inherited;
  FIsCommand:=True;
  FIsAnalog:=True;
  FIsParam:=True;
  FEntityKind:=ekAnalog;
  FOP:=0.0;
  FEUDesc:='%';
  FOPFormat:=pfD1;
  FOPEUHi:=100.0;
  FOPEULo:=0.0;
end;

function TCustomAnaInp.GetBlockName: string;
begin
  Result:='��������';
end;

function TCustomAnaInp.GetPlaceName: string;
begin
  Result:='��������';
end;

function TCustomAnaInp.GetPtVal: string;
begin
  if asNoLink in AlarmStatus then
    Result:='------'
  else
    Result:=Format('%.'+IntToStr(Ord(FOPFormat))+'f',[FOP])
end;

function TCustomAnaInp.GetTextValue: string;
begin
  if asNoLink in AlarmStatus then
    Result:='------'
  else
    Result:=Format('%.'+IntToStr(Ord(FOPFormat))+'f',[FOP])
end;

procedure TCustomAnaInp.SetCalcScale(const Value: boolean);
  function BS(Value: boolean): string;
  begin
    Result:=IfThen(Value,'���','����');
  end;
begin
  if FCalcScale <> Value then
  begin
    Caddy.AddChange(FPtName,'������� �� �����',BS(FCalcScale),BS(Value),
                              FPtDesc,Caddy.Autor);
    FCalcScale:=Value;
    Caddy.Changed:=True;
  end;
end;

procedure TCustomAnaInp.SetEUDesc(const Value: string);
begin
  if FEUDesc <> Value then
  begin
    Caddy.AddChange(FPtName,'���.�������',FEUDesc,Value,
                              FPtDesc,Caddy.Autor);
    FEUDesc:=Value;
    Caddy.Changed:=True;
  end;
end;

procedure TCustomAnaInp.SetOP(const Value: Single);
//var //KindStatus: TKindStatus;
//    LastAlarm: TAlarmState;
//    AlarmFound, HasAlarm, HasConfirm, HasNoLink: boolean;
begin
  if FOP <> Value then
  begin
    FOP:=Value;
  end;
end;

procedure TCustomAnaInp.SetOPEUHi(const Value: Single);
  function FV(V: Single): string;
  begin
    Result:=Format('%.'+IntToStr(Ord(FOPFormat))+'f',[V]);
  end;
begin
  if FOPEUHi <> Value then
  begin
    Caddy.AddChange(FPtName,'OPEUHI',FV(FOPEUHi),FV(Value),
                              FPtDesc,Caddy.Autor);
    FOPEUHi:=Value;
    Caddy.Changed:=True;
  end;
end;

procedure TCustomAnaInp.SetOPEULo(const Value: Single);
  function FV(V: Single): string;
  begin
    Result:=Format('%.'+IntToStr(Ord(FOPFormat))+'f',[V]);
  end;
begin
  if FOPEULo <> Value then
  begin
    Caddy.AddChange(FPtName,'OPEULO',FV(FOPEULo),FV(Value),
                              FPtDesc,Caddy.Autor);
    FOPEULo:=Value;
    Caddy.Changed:=True;
  end;
end;

procedure TCustomAnaInp.SetOPFormat(const Value: TPVFormat);
  function FP(V: TPVFormat): string;
  begin
    Result:=Format('D%d',[Ord(V)]);
  end;
begin
  if FOPFormat <> Value then
  begin
    Caddy.AddChange(FPtName,'������ OP',FP(FOPFormat),FP(Value),
                              FPtDesc,Caddy.Autor);
    FOPFormat:=Value;
    Caddy.Changed:=True;
  end;
end;

procedure TCustomAnaInp.SetRaw(const Value: Double);
var R: Double;
begin
  R:=Value;
  if FCalcScale then
    OP:=(FOPEUHi-FOPEULo)*(R/100.0)+FOPEULo
  else
    OP:=R;
  inherited SetRaw(Value);
end;

function TCaddy.CalcLastAlarm(E: TEntity; var Alarm: TAlarmState;
                                          var IsLost: boolean): boolean;
var i: integer; Item: TActiveAlarmLogItem; T: TEntity;
begin
  Result:=False;
  Alarm:=asNone;
  IsLost:=False;
  with ActiveAlarmLog do
  for i:=0 to Count-1 do
  begin
    Item:=Items[i] as TActiveAlarmLogItem;
    T:=Item.Source as TEntity;
    if T = E then
    begin
      Alarm:=Item.Kind;
      Break;
    end;
  end;
end;

procedure TCaddy.SaveLogsToBaseLog(Path: string);
var i: integer; OldFileName, FileName, DirName: string;
    AlarmItem: TCashAlarmLogItem;
    SwitchItem: TCashSwitchLogItem;
    ChangeItem: TCashChangeLogItem;
    SystemItem: TCashSystemLogItem;
    F: TFileStream;
begin
  OldFileName := '';
  F := nil;
  for i:=1 to CashAlarmLog.Length do
  begin
    AlarmItem:=CashAlarmLog.Body[i];
    DirName:=IncludeTrailingPathDelimiter(Path)+
             FormatDateTime('yymmdd\hh',AlarmItem.SnapTime);
    FileName:=IncludeTrailingPathDelimiter(DirName)+'ALARMS.LOG';
    if OldFileName <> FileName then
    begin
      FreeAndNil(F);
      F:=TryOpenToWriteFile(DirName,FileName);
      OldFileName := FileName;
    end;
    if Assigned(F) then
    begin
      F.Seek(0,soFromEnd);
      F.WriteBuffer(AlarmItem.SnapTime,SizeOf(AlarmItem.SnapTime));
      F.WriteBuffer(AlarmItem.Station,SizeOf(AlarmItem.Station));
      F.WriteBuffer(AlarmItem.Position,SizeOf(AlarmItem.Position));
      F.WriteBuffer(AlarmItem.Parameter,SizeOf(AlarmItem.Parameter));
      F.WriteBuffer(AlarmItem.Value,SizeOf(AlarmItem.Value));
      F.WriteBuffer(AlarmItem.SetPoint,SizeOf(AlarmItem.SetPoint));
      F.WriteBuffer(AlarmItem.Mess,SizeOf(AlarmItem.Mess));
      F.WriteBuffer(AlarmItem.Descriptor,SizeOf(AlarmItem.Descriptor));
    end
    else
      Break;
  end;
  if Assigned(F) then FreeAndNil(F);
//---------------------------------------
  OldFileName := '';
  F := nil;
  for i:=1 to CashSwitchLog.Length do
  begin
    SwitchItem:=CashSwitchLog.Body[i];
    DirName:=IncludeTrailingPathDelimiter(Path)+
             FormatDateTime('yymmdd\hh',SwitchItem.SnapTime);
    FileName:=IncludeTrailingPathDelimiter(DirName)+'SWITCHS.LOG';
    if OldFileName <> FileName then
    begin
      FreeAndNil(F);
      F:=TryOpenToWriteFile(DirName,FileName);
      OldFileName := FileName;
    end;
    if Assigned(F) then
    begin
      F.Seek(0,soFromEnd);
      F.WriteBuffer(SwitchItem.SnapTime,SizeOf(SwitchItem.SnapTime));
      F.WriteBuffer(SwitchItem.Station,SizeOf(SwitchItem.Station));
      F.WriteBuffer(SwitchItem.Position,SizeOf(SwitchItem.Position));
      F.WriteBuffer(SwitchItem.Parameter,SizeOf(SwitchItem.Parameter));
      F.WriteBuffer(SwitchItem.OldValue,SizeOf(SwitchItem.OldValue));
      F.WriteBuffer(SwitchItem.NewValue,SizeOf(SwitchItem.NewValue));
      F.WriteBuffer(SwitchItem.Descriptor,SizeOf(SwitchItem.Descriptor));
    end
    else
      Break;
  end;
  if Assigned(F) then FreeAndNil(F);
//---------------------------------------
  OldFileName := '';
  F := nil;
  for i:=1 to CashChangeLog.Length do
  begin
    ChangeItem:=CashChangeLog.Body[i];
    DirName:=IncludeTrailingPathDelimiter(Path)+
             FormatDateTime('yymmdd\hh',ChangeItem.SnapTime);
    FileName:=IncludeTrailingPathDelimiter(DirName)+'CHANGES.LOG';
    if OldFileName <> FileName then
    begin
      FreeAndNil(F);
      F:=TryOpenToWriteFile(DirName,FileName);
      OldFileName := FileName;
    end;
    if Assigned(F) then
    begin
      F.Seek(0,soFromEnd);
      F.WriteBuffer(ChangeItem.SnapTime,SizeOf(ChangeItem.SnapTime));
      F.WriteBuffer(ChangeItem.Station,SizeOf(ChangeItem.Station));
      F.WriteBuffer(ChangeItem.Position,SizeOf(ChangeItem.Position));
      F.WriteBuffer(ChangeItem.Parameter,SizeOf(ChangeItem.Parameter));
      F.WriteBuffer(ChangeItem.OldValue,SizeOf(ChangeItem.OldValue));
      F.WriteBuffer(ChangeItem.NewValue,SizeOf(ChangeItem.NewValue));
      F.WriteBuffer(ChangeItem.Autor,SizeOf(ChangeItem.Autor));
      F.WriteBuffer(ChangeItem.Descriptor,SizeOf(ChangeItem.Descriptor));
    end
    else
      Break;
  end;
  if Assigned(F) then FreeAndNil(F);
//---------------------------------------
  OldFileName := '';
  F := nil;
  for i:=1 to CashSystemLog.Length do
  begin
    SystemItem:=CashSystemLog.Body[i];
    DirName:=IncludeTrailingPathDelimiter(Path)+
             FormatDateTime('yymmdd\hh',SystemItem.SnapTime);
    FileName:=IncludeTrailingPathDelimiter(DirName)+'SYSMESS.LOG';
    if OldFileName <> FileName then
    begin
      FreeAndNil(F);
      F:=TryOpenToWriteFile(DirName,FileName);
      OldFileName := FileName;
    end;
    if Assigned(F) then
    begin
      F.Seek(0,soFromEnd);
      F.WriteBuffer(SystemItem.SnapTime,SizeOf(SystemItem.SnapTime));
      F.WriteBuffer(SystemItem.Station,SizeOf(SystemItem.Station));
      F.WriteBuffer(SystemItem.Position,SizeOf(SystemItem.Position));
      F.WriteBuffer(SystemItem.Descriptor,SizeOf(SystemItem.Descriptor));
    end
    else
      Break;
  end;
  if Assigned(F) then FreeAndNil(F);
end;

function IsNetWork:Boolean;
  {Returns True if machine is networked.  Requires Win95 or WinNT 4.0+.}
begin
  Result := (GetSystemMetrics(SM_NETWORK) and 1) <> 0;
end;

function IsWinNT:Boolean;
  {Returns True if WinNT; otherwise, Win95.}
var
  VersionInfo: TOSVersionInfo;
begin
//  Result:=SysUtils.Win32Platform=VER_PLATFORM_WIN32_NT;
  VersionInfo.dwOSVersionInfoSize := Sizeof(TOSVersionInfo);
  Result:=GetVersionEx(VersionInfo);
  if Result then Result:=VersionInfo.dwPlatformID=VER_PLATFORM_WIN32_NT;
end;

procedure SetPort(address, Value:Word);
var bValue: byte;
begin
  bValue := trunc(Value and 255);
  asm
    mov dx, address
    mov al, bValue
    out dx, al
  end;
end;

function GetPort(address:word):word;
var bValue: byte;
begin
  asm
    mov dx, address
    in al, dx
     mov bValue, al
  end;
  GetPort := bValue;
end;

procedure Sound(Freq : Word);
var B : Byte;
begin
  if Freq > 18 then
  begin
    Freq := Word(1193181 div LongInt(Freq));
    B := Byte(GetPort($61));
    if (B and 3) = 0 then
    begin
      SetPort($61, Word(B or 3));
      SetPort($43, $B6);
    end;
    SetPort($42, Freq);
    SetPort($42, Freq shr 8);
  end;
end;

procedure NoSound;
var Value: Word;
begin
  Value := GetPort($61) and $FC;
  SetPort($61, Value);
end;

{ TBeeper }

constructor TBeeper.Create(ACaddy: TCaddy; AKind: TBeeperKind);
begin
  Section:=TCriticalSection.Create;
  Caddy:=ACaddy;
  Kind:=AKind;
  inherited Create(True);
end;

destructor TBeeper.Destroy;
begin
  if Assigned(Caddy.Beeper) then
  begin
    Caddy.Beeper:=nil;
    Section.Free;
    inherited;
  end;
end;

procedure TBeeper.Execute;
begin
  repeat
    if (asHH in NowSay) or (asLL in NowSay) or
       (asON in NowSay) or (asOFF in NowSay) then
      case Kind of
  bkSpeaker:  begin
               if IsWinNT then
                  Windows.Beep(1800,100)
               else
               begin
                 Sound(1800); Sleep(100); NoSound;
               end;
              end;
     bkCard:  begin
                sndPlaySound(HiAlarm, SND_MEMORY or
                           SND_NODEFAULT or SND_SYNC);
                Sleep(500);
              end;
      else
        Sleep(100)
      end
    else
    if (asBadPV in NowSay) or //(asNoLink in NowSay) or // ������� 08.10.14
    (asShortBadPV in NowSay) or (asOpenBadPV in NowSay) then
      case Kind of
  bkSpeaker:  begin
               if IsWinNT then
                  Windows.Beep(2500,100)
               else
               begin
                 Sound(2500); Sleep(100); NoSound;
               end;
              end;
     bkCard:  begin
                sndPlaySound(EuAlarm, SND_MEMORY or
                           SND_NODEFAULT or SND_SYNC);
                Sleep(500);
              end;
      else
        Sleep(100)
      end
    else
    if NowSay <> [] then
      case Kind of
  bkSpeaker:  begin
                if IsWinNT then
                   Windows.Beep(900,100)
                else
                begin
                  Sound(900); Sleep(100); NoSound;
                end;
              end;
     bkCard:  begin
                sndPlaySound(LoAlarm, SND_MEMORY or
                           SND_NODEFAULT or SND_SYNC);
                Sleep(500);
              end;
      else
        Sleep(100)
      end;
    Sleep(100);
  until Terminated;
end;

function TBeeper.GetKind: TBeeperKind;
begin
  Section.Enter;
  try
    Result := FKind;
  finally
    Section.Leave;
  end;
end;

procedure TBeeper.SetKind(const Value: TBeeperKind);
begin
  Section.Enter;
  try
    FKind := Value;
  finally
    Section.Leave;
  end;
end;

procedure TBeeper.Say(What: TSetAlarmStatus);
begin
  Section.Enter;
  try
    NowSay:=NowSay+What;
  finally
    Section.Leave;
  end;
end;

procedure TBeeper.ShortUp;
begin
  Section.Enter;
  try
    NowSay:=[];
  finally
    Section.Leave;
  end;
end;

procedure TCaddy.ShowThreadMessage(Sender: TObject; Mess: string);
begin
  ShowMessage(kmStatus, Mess);
end;

procedure TCaddy.LogThreadMessage(Sender: TObject; Mess: string);
begin
  ShowMessage(kmLog, Mess);
end;

function TCaddy.CheckValidAddress(Entity: TEntity): boolean;
var E: TEntity;
begin
  Result:=True;
  E:=FirstEntity;
  while E <> nil do
  begin
    if (E.ClassType = Entity.ClassType) and
       (E <> Entity) and E.AddressEqual(Entity) then
    begin
      if ShowQuestion(
           Format('����� ����� ����������� � ��������: %s - %s'#13#13+
                  '��������� �� ����� �������� �� ���?',
                  [E.PtName,E.PtDesc])) then
        Result:=True
      else
        Result:=False;
      Break;
    end;
    E:=E.NextEntity;
  end;
end;

{ TCustomCntReg }

constructor TCustomCntReg.Create;
begin
  inherited;
  FIsCommand:=True;
end;

procedure TCustomCntReg.SetCheckOP(const Value: TCheckChange);
begin
  if FCheckOP <> Value then
  begin
    Caddy.AddChange(PtName,'�������� OP',ACtoStr[FCheckOP],ACtoStr[Value],
                              PtDesc,Caddy.Autor);
    FCheckOP:=Value;
    Caddy.Changed:=True;
  end;
end;

procedure TCustomCntReg.SetCheckSP(const Value: TCheckChange);
begin
  if FCheckSP <> Value then
  begin
    Caddy.AddChange(PtName,'�������� SP',ACtoStr[FCheckSP],
                              ACtoStr[Value],PtDesc,Caddy.Autor);
    FCheckSP:=Value;
    Caddy.Changed:=True;
  end;
end;

procedure TCaddy.SetLongUserName(const Value: string);
var S: string;
begin
  FLongUserName := Value;
  if Trim(Value) = '' then
    FShortUserName := ''
  else
  begin
    S := Value;
    FShortUserName := Copy(S, 1, Pos(' ', S) - 1) + ' ';
    Delete(S, 1, Pos(' ', S));
    FShortUserName := FShortUserName + Copy(S, 1, 1) + '.';
    Delete(S, 1, Pos(' ', S));
    FShortUserName := FShortUserName + Copy(S, 1, 1) + '.';
  end;
end;

procedure TCaddy.SetOnAlarmLogUpdate(const Value: TNotifyEvent);
begin
  if Assigned(Value) then
  begin
    SetLength(FOnAlarmLogUpdate, Length(FOnAlarmLogUpdate)+1);
    FOnAlarmLogUpdate[Length(FOnAlarmLogUpdate)-1] := Value;
  end
  else
    SetLength(FOnAlarmLogUpdate, 0);
end;

procedure TCaddy.SetOnSwitchLogUpdate(const Value: TNotifyEvent);
begin
  if Assigned(Value) then
  begin
    SetLength(FOnSwitchLogUpdate, Length(FOnSwitchLogUpdate)+1);
    FOnSwitchLogUpdate[Length(FOnSwitchLogUpdate)-1] := Value;
  end
  else
    SetLength(FOnSwitchLogUpdate, 0);
end;

procedure TCaddy.SaveBaseToXML;
var
  E: TEntity;
  i: integer;
  FileName, BackName: string;
begin
  FileName:=ConfigBase.FileName;
  BackName:=ChangeFileExt(FileName,'.~xml');
  if FileExists(BackName) and DeleteFile(BackName) or
     not FileExists(BackName) then
  begin
    if FileExists(FileName) and RenameFile(FileName,BackName) or
       not FileExists(FileName) then
    begin
      E := FirstEntity;
      while E <> nil do
      begin
        ConfigBase.WriteString(E.PtName, 'PtType' , E.ClassName);
        for i := 0 to E.PropsCount - 1 do
          ConfigBase.WriteString(E.PtName, E.PropsID(i), E.PropsValue(i));
        E := E.NextEntity;
      end;
      ConfigBase.UpdateFile;
    end;
  end;
end;

procedure TCaddy.SaveBaseToINI;
var
  E: TEntity;
  i: integer;
  FileName, BackName: string;
  SL: TStringList;
  T: TextFile;
begin
  FileName:=ChangeFileExt(ConfigBase.FileName, '.ini');
  BackName:=ChangeFileExt(FileName,'.~ini');
  if FileExists(BackName) and DeleteFile(BackName) or
     not FileExists(BackName) then
  begin
    if FileExists(FileName) and RenameFile(FileName,BackName) or
       not FileExists(FileName) then
    begin
      AssignFile(T,FileName);
      Rewrite(T);
      try
        E := FirstEntity;
        while E <> nil do
        begin
          SL := TStringList.Create();
          try
            E.SaveToText(SL);
            for i := 0 to SL.Count-1 do
            begin
              Writeln(T, SL[i]);
            end;
          finally
            SL.Free;
          end;
          Writeln(T);
          E := E.NextEntity;
        end;
      finally
        CloseFile(T);
      end;
    end;
  end;
end;

procedure TCaddy.LoadSchemes(const SchemesPath: string);
var sr: TSearchRec;
    FileAttrs, i: Integer;
    SchemList: TStringList;
    Filter: string;
    Background: TBackground;
    M: TMemoryStream;
    DinType: byte;
    P: Int64;
    C: TDinControl;
    E: TEntity;
begin
  Filter := '*.SCM';
  SchemList := TStringList.Create;
  try
  // ��������� ������ ���������
    FileAttrs := faDirectory;
    if FindFirst(IncludeTrailingPathDelimiter(SchemesPath) + Filter,
                 FileAttrs, sr) = 0 then
    begin
      repeat
        if (sr.Attr and FileAttrs) <> sr.Attr then
          SchemList.Add(sr.Name);
      until FindNext(sr) <> 0;
      FindClose(sr);
    end;
    Background := TBackground.Create(nil);
    // ��������� ������ �� ��� ������� ����� �����
    try
      for i := 0 to SchemList.Count - 1 do
      begin
        Background.Clear;
        M:=TMemoryStream.Create;
        try
          if LoadStream(IncludeTrailingPathDelimiter(SchemesPath)+SchemList[i], M) then
          begin
            Background.LoadFromStream(M);
            if M.Size >= SizeOf(DinType) then
            while M.Position < M.Size do
            begin
              P:=M.Position;
              M.ReadBuffer(DinType,SizeOf(DinType));
              M.Position:=P;
              try
                C:=ADin[DinType].Name.Create(Self);
                C.DinType:=DinType;
                C.Parent:=Background;
              except
                C:=nil;
              end;
              if Assigned(C) then
              begin
                try
                  if C.LoadFromStream(M) <> 0 then
                  begin
                   // ��������� ������ Entities ��� ����������
                    if Trim(C.LinkName) <> '' then
                    begin
                      E := Caddy.Find(C.LinkName);
                      if E <> nil then
                        E.LinkScheme := SchemList[i];
                    end;
                  end
                  else
                    Break;
                finally
                  C.Free;
                end;
              end
              else
                Break;
            end;
          end;
        finally
          M.Free;
        end;
      end;
    finally
      Background.Free;
    end;
  finally
    SchemList.Free;
  end;
end;

initialization
// Here we use some castings to avoid using another variable
  HiAlarm := Pointer(FindResource(hInstance, 'HiAlarm', 'wave'));
  if HiAlarm <> nil then
  begin
    HiAlarm := Pointer(LoadResource(hInstance, HRSRC(HiAlarm)));
    if HiAlarm <> nil then HiAlarm := LockResource(HGLOBAL(HiAlarm));
  end;
  LoAlarm := Pointer(FindResource(hInstance, 'LoAlarm', 'wave'));
  if LoAlarm <> nil then
  begin
    LoAlarm := Pointer(LoadResource(hInstance, HRSRC(LoAlarm)));
    if LoAlarm <> nil then LoAlarm := LockResource(HGLOBAL(LoAlarm));
  end;
  EuAlarm := Pointer(FindResource(hInstance, 'EuAlarm', 'wave'));
  if EuAlarm <> nil then
  begin
    EuAlarm := Pointer(LoadResource(hInstance, HRSRC(EuAlarm)));
    if EuAlarm <> nil then EuAlarm := LockResource(HGLOBAL(EuAlarm));
  end;


end.
