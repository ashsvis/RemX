unit VirtualUnit;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, ExtCtrls, Messages, ComCtrls,
  Menus, EntityUnit, Math;

type
  TVirtEditForm = class(TBaseEditForm)
  private
    E: TEntity;
    procedure ConnectImageList(ImageList: TImageList);
    procedure UpdateRealTime;
    procedure ConnectBaseEditor(var Mess: TMessage); message WM_ConnectBaseEditor;
    procedure BaseFresh(var Mess: TMessage); message WM_Fresh;
    procedure ChangeFetchClick(Sender: TObject);
  protected
    procedure ConnectEntity(Entity: TEntity); virtual;
    procedure PopupMenu1Popup(Sender: TObject); virtual;
    procedure ChangeTextClick(Sender: TObject); virtual;
    procedure ChangeBooleanClick(Sender: TObject); virtual;
    procedure ListView1DblClick(Sender: TObject); virtual;
  public
    ListView1: TListView;
    PopupMenu1: TPopupMenu;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddBoolItem(Value: boolean);
  end;

  TVirtFlag = class(TCustomDigOut)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Actived: boolean;
      Asked: boolean;
      Logged: boolean;
      FetchTime: Cardinal;
      SourceName: string[10];
      Invert: Boolean;
      AlarmDown: Boolean;
      AlarmUp: Boolean;
      SwitchDown: Boolean;
      SwitchUp: Boolean;
      ColorDown: TDigColor;
      ColorUp: TDigColor;
      TextDown: string[10];
      TextUp: string[10];
    end;
    procedure ImpulseTimer(Sender: TObject);
  protected
    function GetFetchData: string; override;
    procedure SetPV(const Value: Boolean); override;
  public
    constructor Create; override;
    class function EntityType: string; override;
    class function TypeCode: string; override;
    class function TypeColor: TColor; override;
    function PropsCount: integer; override;
    class function PropsID(Index: integer): string; override;
    class function PropsName(Index: integer): string; override;
    function PropsValue(Index: integer): string; override;
    procedure SaveToStream(Stream: TStream); override;
    procedure SaveToText(List: TStringList); override;
    function LoadFromStream(Stream: TStream): integer; override;
    function Prepare: string; override;
    procedure Fetch(const Data: string); override;
    procedure SendIMPULSE; override;
    property PV;
    property Invert;
    property AlarmDown;
    property AlarmUp;
    property SwitchDown;
    property SwitchUp;
    property ColorDown;
    property ColorUp;
    property TextDown;
    property TextUp;
  end;

  TVirtNumeric = class(TCustomAnaOut)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Actived: boolean;
      Asked: boolean;
      Logged: boolean;
      Trend: boolean;
      FetchTime: Cardinal;
      SourceName: string[10];
      EUDesc: string[9];
      CalcScale: boolean;
      PVFormat: TPVFormat;
      BadDB: TAlarmDeadband;
      HHDB: TAlarmDeadband;
      HiDB: TAlarmDeadband;
      LLDB: TAlarmDeadband;
      LoDB: TAlarmDeadband;
      PVEUHi: Single;
      PVEULo: Single;
      PVHHTP: Single;
      PVHiTP: Single;
      PVLLTP: Single;
      PVLoTP: Single;
    end;
  protected
    function GetFetchData: string; override;
    procedure SetPV(const Value: Double); override;
  public
    constructor Create; override;
    class function EntityType: string; override;
    class function TypeCode: string; override;
    class function TypeColor: TColor; override;
    function PropsCount: integer; override;
    class function PropsID(Index: integer): string; override;
    class function PropsName(Index: integer): string; override;
    function PropsValue(Index: integer): string; override;
    procedure SaveToStream(Stream: TStream); override;
    procedure SaveToText(List: TStringList); override;
    function LoadFromStream(Stream: TStream): integer; override;
    function Prepare: string; override;
    procedure Fetch(const Data: string); override;
    property PV;
    property EUDesc;
    property PVFormat;
    property BadDB;
    property HHDB;
    property HiDB;
    property LLDB;
    property LoDB;
    property PVEUHi;
    property PVEULo;
    property PVHHTP;
    property PVHiTP;
    property PVLLTP;
    property PVLoTP;
    property Trend;
  end;

  TSysInfoKind = (siPhysical,siVirtual,siPageFile,siHDD,siAllocMemSize);
  TSizeKoeff = (skByte,skKByte,skMByte);

const
  ASysInfoKind: array[TSysInfoKind] of string =
   ('Физическая память','Виртуальная память','Файл подкачки',
    'Дисковое пространство','Выделенная память');
  ASizeKoeff: array[TSizeKoeff] of string = ('байт','килобайт','Мегабайт');

type

  TVirtSysInfo = class(TCustomAnaOut)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Actived: boolean;
      Asked: boolean;
      Logged: boolean;
      Trend: boolean;
      FetchTime: Cardinal;
      EUDesc: string[10];
      PVFormat: TPVFormat;
      HHDB: TAlarmDeadband;
      HiDB: TAlarmDeadband;
      LLDB: TAlarmDeadband;
      LoDB: TAlarmDeadband;
      PVHHTP: Single;
      PVHiTP: Single;
      PVLLTP: Single;
      PVLoTP: Single;
      Koeff: TSizeKoeff;
      Kind: TSysInfoKind;
    end;
    FKoeff: TSizeKoeff;
    FKind: TSysInfoKind;
    procedure SetKind(const Value: TSysInfoKind);
    procedure SetKoeff(const Value: TSizeKoeff);
  protected
  public
    constructor Create; override;
    class function EntityType: string; override;
    class function TypeCode: string; override;
    class function TypeColor: TColor; override;
    function PropsCount: integer; override;
    class function PropsID(Index: integer): string; override;
    class function PropsName(Index: integer): string; override;
    function PropsValue(Index: integer): string; override;
    procedure SaveToStream(Stream: TStream); override;
    procedure SaveToText(List: TStringList); override;
    function LoadFromStream(Stream: TStream): integer; override;
    procedure Fetch(const Data: string); override;
    procedure Assign(E: TEntity); override;
    property PV;
    property EUDesc;
    property PVFormat;
    property HHDB;
    property HiDB;
    property LLDB;
    property LoDB;
    property PVEUHi;
    property PVEULo;
    property PVHHTP;
    property PVHiTP;
    property PVLLTP;
    property PVLoTP;
    property Kind: TSysInfoKind read FKind write SetKind default siPhysical;
    property Koeff: TSizeKoeff read FKoeff write SetKoeff default skKByte;
    property Trend;
  end;

  TVirtVDGroup = class(TCustomGroup)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Actived: boolean;
      FetchTime: Cardinal;
      SourceName: string[10];
      Childs: array[0..31] of string[10];
    end;
  protected
    procedure SetRaw(const Value: Double); override;
    function GetTextValue: string; override;
    function GetPtVal: string; override;
  public
    function GetMaxChildCount: integer; override;
    constructor Create; override;
    class function EntityType: string; override;
    class function TypeCode: string; override;
    class function TypeColor: TColor; override;
    function PropsCount: integer; override;
    class function PropsID(Index: integer): string; override;
    class function PropsName(Index: integer): string; override;
    function PropsValue(Index: integer): string; override;
    procedure SaveToStream(Stream: TStream); override;
    procedure SaveToText(List: TStringList); override;
    function LoadFromStream(Stream: TStream): integer; override;
    procedure Decode(Value: Single); override;
    procedure Fetch(const Data: string); override;
  end;

  TVirtValve = class(TEntity)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Actived: boolean;
      Asked: boolean;
      Logged: boolean;
      FetchTime: Cardinal;
      SourceStatALM: string[10];
      SourceStatON: string[10];
      SourceStatOFF: string[10];
      SourceCommON: string[10];
      SourceCommOFF: string[10];
    end;
    FSourceStatALM: string;
    FSourceStatON: string;
    FSourceStatOFF: string;
    FSourceCommOFF: string;
    FSourceCommON: string;
    FCommOFF: TEntity;
    FCommON: TEntity;
    FStatOFF: TCustomDigOut;
    FStatON: TCustomDigOut;
    FStatALM: TCustomDigOut;
    FPV: Byte;
    procedure SetCommOFF(const Value: TEntity);
    procedure SetCommON(const Value: TEntity);
    procedure SetStatALM(const Value: TCustomDigOut);
    procedure SetStatOFF(const Value: TCustomDigOut);
    procedure SetStatON(const Value: TCustomDigOut);
    procedure SetPV(const Value: Byte);
  protected
    function GetTextValue: string; override;
    function GetPtVal: string; override;
  public
    NoLink: Boolean;
    constructor Create; override;
    class function EntityType: string; override;
    class function TypeCode: string; override;
    class function TypeColor: TColor; override;
    function PropsCount: integer; override;
    class function PropsID(Index: integer): string; override;
    class function PropsName(Index: integer): string; override;
    function PropsValue(Index: integer): string; override;
    property StatALM: TCustomDigOut read FStatALM write SetStatALM;
    property StatON: TCustomDigOut read FStatON write SetStatON;
    property StatOFF: TCustomDigOut read FStatOFF write SetStatOFF;
    property CommON: TEntity read FCommON write SetCommON;
    property CommOFF: TEntity read FCommOFF write SetCommOFF;
    procedure Notify(Kind: TEntityNotify; E: TEntity); override;
    procedure ConnectLinks; override;
    procedure SaveToStream(Stream: TStream); override;
    procedure SaveToText(List: TStringList); override;
    function LoadFromStream(Stream: TStream): integer; override;
    procedure Fetch(const Data: string); override;
    procedure SendOpen;
    procedure SendClose;
    property PV: Byte read FPV write SetPV;
    property SourceStatALM: string read FSourceStatALM stored False;
    property SourceStatON: string read FSourceStatON stored False;
    property SourceStatOFF: string read FSourceStatOFF stored False;
    property SourceCommON: string read FSourceCommON stored False;
    property SourceCommOFF: string read FSourceCommOFF stored False;
  end;

  TVirtAnaSel = class(TCustomAnaOut)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Actived: boolean;
      Asked: boolean;
      Logged: boolean;
      FetchTime: Cardinal;
      SourceAnaVar1: string[10];
      SourceAnaVar2: string[10];
      SourceAnaVar3: string[10];
      SourceAnaVar4: string[10];
      SourceDigVar1: string[10];
      SourceDigVar2: string[10];
      SourceDigVar3: string[10];
      SourceDigVar4: string[10];
    end;
    FSourceAnaVar4: string;
    FSourceDigVar3: string;
    FSourceDigVar4: string;
    FSourceDigVar1: string;
    FSourceAnaVar3: string;
    FSourceAnaVar2: string;
    FSourceDigVar2: string;
    FSourceAnaVar1: string;
    FAnaVar4: TCustomAnaOut;
    FAnaVar3: TCustomAnaOut;
    FAnaVar1: TCustomAnaOut;
    FAnaVar2: TCustomAnaOut;
    FDigVar4: TCustomDigOut;
    FDigVar3: TCustomDigOut;
    FDigVar2: TCustomDigOut;
    FDigVar1: TCustomDigOut;
    SelNum: Byte;
    procedure SetAnaVar1(const Value: TCustomAnaOut);
    procedure SetAnaVar2(const Value: TCustomAnaOut);
    procedure SetAnaVar3(const Value: TCustomAnaOut);
    procedure SetAnaVar4(const Value: TCustomAnaOut);
    procedure SetDigVar1(const Value: TCustomDigOut);
    procedure SetDigVar2(const Value: TCustomDigOut);
    procedure SetDigVar3(const Value: TCustomDigOut);
    procedure SetDigVar4(const Value: TCustomDigOut);
  protected
  public
    SelEntity: TCustomAnaOut;
    class function EntityType: string; override;
    class function TypeCode: string; override;
    class function TypeColor: TColor; override;
    function PropsCount: integer; override;
    class function PropsID(Index: integer): string; override;
    class function PropsName(Index: integer): string; override;
    function PropsValue(Index: integer): string; override;
    constructor Create; override;
    procedure Notify(Kind: TEntityNotify; E: TEntity); override;
    procedure ConnectLinks; override;
    procedure SaveToStream(Stream: TStream); override;
    procedure SaveToText(List: TStringList); override;
    function LoadFromStream(Stream: TStream): integer; override;
    procedure Fetch(const Data: string); override;
    procedure ShowParentPassport(const MonitorNum: integer); override;
    property AnaVar1: TCustomAnaOut read FAnaVar1 write SetAnaVar1;
    property AnaVar2: TCustomAnaOut read FAnaVar2 write SetAnaVar2;
    property AnaVar3: TCustomAnaOut read FAnaVar3 write SetAnaVar3;
    property AnaVar4: TCustomAnaOut read FAnaVar4 write SetAnaVar4;
    property DigVar1: TCustomDigOut read FDigVar1 write SetDigVar1;
    property DigVar2: TCustomDigOut read FDigVar2 write SetDigVar2;
    property DigVar3: TCustomDigOut read FDigVar3 write SetDigVar3;
    property DigVar4: TCustomDigOut read FDigVar4 write SetDigVar4;
    property SourceAnaVar1: string read FSourceAnaVar1 stored False;
    property SourceAnaVar2: string read FSourceAnaVar2 stored False;
    property SourceAnaVar3: string read FSourceAnaVar3 stored False;
    property SourceAnaVar4: string read FSourceAnaVar4 stored False;
    property SourceDigVar1: string read FSourceDigVar1 stored False;
    property SourceDigVar2: string read FSourceDigVar2 stored False;
    property SourceDigVar3: string read FSourceDigVar3 stored False;
    property SourceDigVar4: string read FSourceDigVar4 stored False;
  end;

  TTimFormat = (tfShort,tfMiddle,tfLong);

const
  ATimtoStr: array[TTimFormat] of string = ('часы','чс:мн','ч:м:с');

type
  TVirtTimeCounter = class(TCustomAnaOut)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Actived: boolean;
      Asked: boolean;
      Logged: boolean;
      FetchTime: Cardinal;
      HHHourTP: Integer;
      HiHourTP: Integer;
      MaxHourValue: Integer;
      PVFormat: TTimFormat;
      SourceDigWork: string[10];
    end;
    FMaxHourValue: Integer;
    FHHHourTP: Integer;
    FHiHourTP: Integer;
    FPV: TDateTime;
    FSourceDigWork: string;
    FPVFormat: TTimFormat;
    FDigWork: TCustomDigOut;
    FWorking: Boolean;
    FActualTime: TDateTime;
    FOldTime: TDateTime;
    FLASTPV: TDateTime;
    procedure SetHHHourTP(const Value: Integer);
    procedure SetHiHourTP(const Value: Integer);
    procedure SetMaxHourValue(const Value: Integer);
    procedure SetPVFormat(const Value: TTimFormat);
    procedure SetDigWork(const Value: TCustomDigOut);
    procedure SetWorking(const Value: Boolean);
    function GetLastPVText: string;
  protected
    function GetTextValue: string; override;
    function GetPtVal: string; override;
    function GetFetchData: string; override;
  public
    class function EntityType: string; override;
    class function TypeCode: string; override;
    class function TypeColor: TColor; override;
    function PropsCount: integer; override;
    class function PropsID(Index: integer): string; override;
    class function PropsName(Index: integer): string; override;
    function PropsValue(Index: integer): string; override;
    constructor Create; override;
    procedure Notify(Kind: TEntityNotify; E: TEntity); override;
    procedure ConnectLinks; override;
    procedure SaveToStream(Stream: TStream); override;
    procedure SaveToText(List: TStringList); override;
    function LoadFromStream(Stream: TStream): integer; override;
    function Prepare: string; override;
    procedure Fetch(const Data: string); override;
    procedure Assign(E: TEntity); override;
    procedure Reset;
    procedure SetParam(ParamName: string; Item: TCashRealBaseItem); override;
    property DigWork: TCustomDigOut read FDigWork write SetDigWork;
    property ActualTime: TDateTime read FActualTime write FActualTime;
    property OldTime: TDateTime read FOldTime write FOldTime;
    property Working: Boolean read FWorking write SetWorking;
    property HHHourTP: Integer read FHHHourTP write SetHHHourTP;
    property HiHourTP: Integer read FHiHourTP write SetHiHourTP;
    property MaxHourValue: Integer read FMaxHourValue write SetMaxHourValue;
    property PV: TDateTime read FPV write FPV stored False;
    property LASTPV: TDateTime read FLASTPV write FLASTPV stored False;
    property PVFormat: TTimFormat read FPVFormat write SetPVFormat default
            tfMiddle;
    property SourceDigWork: string read FSourceDigWork stored False;
    property LastPVText: string read GetLastPVText;
  end;

  TPeriodKind = (pkCalendar,pkExternal);
  TBaseKind = (bkSec,bkMin,bkHour);
  TCalcKind = (ckZero,ckLastGood,ckBadPV);

const
   APeriodKind: array[TPeriodKind]of string = ('Календарный','Внешний');
   ABaseKind: array[TBaseKind] of string = ('Секунда','Минута','Час');
   ACalcKind: array[TCalcKind] of string = ('Как ноль','Последний','Ошибка');

type
  TVirtFAGroup = class(TCustomGroup)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Actived: boolean;
      FetchTime: Cardinal;
      SourceAnaWork: string[10];
      SourceDigWork: string[10];
      InvDigWork: boolean;
      PeriodKind: TPeriodKind;
      BaseKind: TBaseKind;
      CalcKind: TCalcKind;
      ShiftHour: byte;
      CutOff: Double;
      Reset: Double;
      Childs: array[0..33] of string[10];
    end;
    FInvDigWork: boolean;
    FShiftHour: byte;
    FReset: Double;
    FCutOff: Double;
    FSourceDigWork: string;
    FSourceAnaWork: string;
    FBaseKind: TBaseKind;
    FCalcKind: TCalcKind;
    FPeriodKind: TPeriodKind;
    FAnaWork: TCustomAnaOut;
    FDigWork: TCustomDigOut;
    LastGood: Double;
    LastExtValue: Boolean;
    procedure SetBaseKind(const Value: TBaseKind);
    procedure SetCalcKind(const Value: TCalcKind);
    procedure SetCutOff(const Value: Double);
    procedure SetInvDigWork(const Value: boolean);
    procedure SetPeriodKind(const Value: TPeriodKind);
    procedure SetReset(const Value: Double);
    procedure SetShiftHour(const Value: byte);
    procedure SetAnaWork(const Value: TCustomAnaOut);
    procedure SetDigWork(const Value: TCustomDigOut);
  protected
    function GetFetchData: string; override;
  public
    OldTime: TDateTime;
    constructor Create; override;
    class function EntityType: string; override;
    class function TypeCode: string; override;
    class function TypeColor: TColor; override;
    function PropsCount: integer; override;
    class function PropsID(Index: integer): string; override;
    class function PropsName(Index: integer): string; override;
    function PropsValue(Index: integer): string; override;
    procedure SaveToStream(Stream: TStream); override;
    procedure SaveToText(List: TStringList); override;
    function LoadFromStream(Stream: TStream): integer; override;
    procedure Fetch(const Data: string); override;
    procedure Notify(Kind: TEntityNotify; E: TEntity); override;
    procedure ConnectLinks; override;
    procedure ResetTime(NewTime: TDateTime);
    procedure Assign(E: TEntity); override;
    function GetMaxChildCount: integer; override;
    property AnaWork: TCustomAnaOut read FAnaWork write SetAnaWork;
    property DigWork: TCustomDigOut read FDigWork write SetDigWork;
    property SourceAnaWork: string read FSourceAnaWork stored False;
    property SourceDigWork: string read FSourceDigWork stored False;
    property InvDigWork: boolean read FInvDigWork write SetInvDigWork;
    property PeriodKind: TPeriodKind read FPeriodKind write SetPeriodKind;
    property BaseKind: TBaseKind read FBaseKind write SetBaseKind;
    property CalcKind: TCalcKind read FCalcKind write SetCalcKind;
    property ShiftHour: byte read FShiftHour write SetShiftHour;
    property CutOff: Double read FCutOff write SetCutOff;
    property Reset: Double read FReset write SetReset;
  end;

  TVirtTank= class(TCustomGroup)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Actived: boolean;
      FetchTime: Cardinal;
      SourceLevel: string[10];
      SourceTemp: string[10];
      SourcePaspDens: string[10];
      SourceVolume: string[10];
      SourceCalcDens: string[10];
      SourceWeight: string[10];
      Levels: array[0..2000] of Double;
    end;
    FSourceLevel: string;
    FSourceTemp: string;
    FSourcePaspDens: string;
    FSourceVolume: string;
    FSourceCalcDens: string;
    FSourceWeight: string;
    FCalcDens: TCustomAnaOut;
    FWeight: TCustomAnaOut;
    FVolume: TCustomAnaOut;
    FLevel: TCustomAnaOut;
    FPaspDens: TCustomAnaOut;
    FTemp: TCustomAnaOut;
    procedure SetLevel(const Value: TCustomAnaOut);
    procedure SetTemp(const Value: TCustomAnaOut);
    procedure SetPaspDens(const Value: TCustomAnaOut);
    procedure SetVolume(const Value: TCustomAnaOut);
    procedure SetCalcDens(const Value: TCustomAnaOut);
    procedure SetWeight(const Value: TCustomAnaOut);
    function GetLevels(Index: Integer): Double;
    procedure SetLevels(Index: Integer; const Value: Double);
  protected
  public
    constructor Create; override;
    class function EntityType: string; override;
    class function TypeCode: string; override;
    class function TypeColor: TColor; override;
    function PropsCount: integer; override;
    class function PropsID(Index: integer): string; override;
    class function PropsName(Index: integer): string; override;
    function PropsValue(Index: integer): string; override;
    procedure SaveToStream(Stream: TStream); override;
    procedure SaveToText(List: TStringList); override;
    function LoadFromStream(Stream: TStream): integer; override;
    procedure Fetch(const Data: string); override;
    procedure Notify(Kind: TEntityNotify; E: TEntity); override;
    procedure ConnectLinks; override;
    procedure Assign(E: TEntity); override;
    function GetMaxChildCount: integer; override;
    property Level: TCustomAnaOut read FLevel write SetLevel;
    property Temp: TCustomAnaOut read FTemp write SetTemp;
    property PaspDens: TCustomAnaOut read FPaspDens write SetPaspDens;
    property Volume: TCustomAnaOut read FVolume write SetVolume;
    property CalcDens: TCustomAnaOut read FCalcDens write SetCalcDens;
    property Weight: TCustomAnaOut read FWeight write SetWeight;
    property SourceLevel: string read FSourceLevel stored False;
    property SourceTemp: string read FSourceTemp stored False;
    property SourcePaspDens: string read FSourcePaspDens stored False;
    property SourceVolume: string read FSourceVolume stored False;
    property SourceCalcDens: string read FSourceCalcDens stored False;
    property SourceWeight: string read FSourceWeight stored False;
    property Levels[Index: Integer]: Double read GetLevels
                                                   write SetLevels;
  end;

  TUnoOperation = (uoNone,coNeg,coSQR,coExp,coLn);
  TDuoOperation = (doNone,coAdd,coSub,coMul,coDiv);
  TCodeArgument = (caNone,caVar,caConst,caExpr);

const
  AUnoOperation: array[TUnoOperation] of string = ('','  -','SQR','Exp','Ln');
  ADuoOperation: array[TDuoOperation] of string = ('',' + ',' - ',' * ',' / ');
  AVarCode: array[TCodeArgument] of string = ('','V','C','E');

type
  TOneStep = packed record
    FirstPrefix: TUnoOperation;
    FirstArgument: TCodeArgument;
    FirstArgNumber: Byte;
    Operation: TDuoOperation;
    SecondPrefix: TUnoOperation;
    SecondArgument: TCodeArgument;
    SecondArgNumber: Byte;
  end;
  TVirtCalc = class(TVirtNumeric)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Actived: boolean;
      Asked: boolean;
      Logged: boolean;
      Trend: boolean;
      FetchTime: Cardinal;
      SourceName: string[10];
      EUDesc: string[10];
      CalcScale: boolean;
      PVFormat: TPVFormat;
      BadDB: TAlarmDeadband;
      HHDB: TAlarmDeadband;
      HiDB: TAlarmDeadband;
      LLDB: TAlarmDeadband;
      LoDB: TAlarmDeadband;
      PVEUHi: Single;
      PVEULo: Single;
      PVHHTP: Single;
      PVHiTP: Single;
      PVLLTP: Single;
      PVLoTP: Single;
      AnaVar: array[1..9] of string[10];
      AnaConst: array[1..9] of Single;
      StepList: array[1..9] of TOneStep;
      ResAna1: Single;
      ResAna2: Single;
      ResAna3: Single;
      ResAna4: Single;
      ResDig1: boolean;
      ResDig2: boolean;
      ResDig3: boolean;
      ResDig4: boolean;
    end;
    FAnaVar: array[1..9] of TCustomAnaOut;
    FAnaConst: array[1..9] of Single;
    FStepList: array[1..9] of TOneStep;
    function GetAnaVar(Index: Integer): TCustomAnaOut;
    procedure SetAnaVar(Index: Integer; const Value: TCustomAnaOut);
    function GetAnaConst(Index: Integer): Single;
    procedure SetAnaConst(Index: Integer; const Value: Single);
    function GetStepList(Index: Integer): TOneStep;
    procedure SetStepList(Index: Integer; const Value: TOneStep);
  public
    constructor Create; override;
    class function EntityType: string; override;
    class function TypeCode: string; override;
    class function TypeColor: TColor; override;
    function PropsCount: integer; override;
    class function PropsID(Index: integer): string; override;
    class function PropsName(Index: integer): string; override;
    function PropsValue(Index: integer): string; override;
    procedure SaveToStream(Stream: TStream); override;
    procedure SaveToText(List: TStringList); override;
    function LoadFromStream(Stream: TStream): integer; override;
    procedure Fetch(const Data: string); override;
    procedure Notify(Kind: TEntityNotify; E: TEntity); override;
    procedure ConnectLinks; override;
    function NameAnaVar(Index: Integer): string;
    function OperationToString(Index: Integer): string;
    procedure SendIMPULSE; override;
    procedure SendOP(Value: Single); override;
    property AnaVar[Index: Integer]: TCustomAnaOut read GetAnaVar write SetAnaVar;
    property AnaConst[Index: Integer]: Single read GetAnaConst write SetAnaConst;
    property StepList[Index: Integer]: TOneStep read GetStepList write SetStepList;
  end;

implementation

uses DateUtils, StrUtils, GetPtNameUnit, CalcDensUnit,
     VirtFLEditUnit, VirtFLPaspUnit, VirtNNEditUnit, VirtNNPaspUnit,
     VirtVDEditUnit, VirtVDPaspUnit, VirtSIEditUnit, VirtSIPaspUnit,
     VirtVCEditUnit, VirtVCPaspUnit, VirtASEditUnit, VirtASPaspUnit,
     VirtTCEditUnit, VirtTCPaspUnit, VirtFAEditUnit, VirtFAPaspUnit,
     VirtVTEditUnit, VirtCAEditUnit, VirtCAPaspUnit;

{ TVirtFlag }

constructor TVirtFlag.Create;
begin
  inherited;
  FIsVirtual:=True;
end;

class function TVirtFlag.EntityType: string;
begin
  Result:='Дискретный флаг';
end;

function TVirtFlag.LoadFromStream(Stream: TStream): integer;
begin
  Result:=SizeOf(Body);
  if (Stream.Size-Stream.Position) < Result then
  begin
    Result:=0;
    Exit;
  end;
  Stream.ReadBuffer(Body,Result);
  FPtName:=Body.PtName;
  FPtDesc:=Body.PtDesc;
  FActived:=Body.Actived;
  FLogged:=Body.Logged;
  FAsked:=Body.Asked;
  FFetchTime:=Body.FetchTime;
  FSourceName:=Body.SourceName;
  FInvert:=Body.Invert;
  FAlarmDown:=Body.AlarmDown;
  FAlarmUp:=Body.AlarmUp;
  FSwitchDown:=Body.SwitchDown;
  FSwitchUp:=Body.SwitchUp;
  FColorDown:=Body.ColorDown;
  FColorUp:=Body.ColorUp;
  FTextDown:=Body.TextDown;
  FTextUp:=Body.TextUp;
end;

procedure TVirtFlag.SaveToStream(Stream: TStream);
begin
  Body.PtName:=PtName;
  Body.PtDesc:=PtDesc;
  Body.Actived:=Actived;
  Body.Logged:=Logged;
  Body.Asked:=Asked;
  Body.FetchTime:=FetchTime;
  Body.SourceName:=SourceName;
  Body.Invert:=Invert;
  Body.AlarmDown:=AlarmDown;
  Body.AlarmUp:=AlarmUp;
  Body.SwitchDown:=SwitchDown;
  Body.SwitchUp:=SwitchUp;
  Body.ColorDown:=ColorDown;
  Body.ColorUp:=ColorUp;
  Body.TextDown:=TextDown;
  Body.TextUp:=TextUp;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

procedure TVirtFlag.SaveToText(List: TStringList);
begin
  List.Append('[' + PtName + ']');
  List.Append('Plugin=Virtual');
  List.Append('PtType=FL');
  List.Append('PtKind=2');
  List.Append('PtName=' + PtName);
  List.Append('PtDesc=' + PtDesc);
  List.Append('Actived=' + IfThen(Actived, 'True', 'False'));
  List.Append('Logged=' + IfThen(Logged, 'True', 'False'));
  List.Append('Asked=' + IfThen(Asked, 'True', 'False'));
  List.Append('FetchTime=' + IntToStr(FetchTime));
  List.Append('SourceName=' + SourceName);
  List.Append('Invert=' + IfThen(Invert, 'True', 'False'));
  List.Append('AlarmDown=' + IfThen(AlarmDown, 'True', 'False'));
  List.Append('AlarmUp=' + IfThen(AlarmUp, 'True', 'False'));
  List.Append('SwitchDown=' + IfThen(SwitchDown, 'True', 'False'));
  List.Append('SwitchUp=' + IfThen(SwitchUp, 'True', 'False'));
  List.Append('ColorDown=' + StringDigColor[ColorDown]);
  List.Append('ColorUp=' + StringDigColor[ColorUp]);
  List.Append('TextDown=' + TextDown);
  List.Append('TextUp=' + TextUp);
end;

class function TVirtFlag.TypeCode: string;
begin
  Result:='FL';
end;

class function TVirtFlag.TypeColor: TColor;
begin
  Result:=$00FFFFCC;
end;

procedure TVirtFlag.Fetch(const Data: string);
var R: Single;
begin
  if Length(Data) = SizeOf(R) then
  begin
// выполняется на клиентской стороне, если сервер прислал строку в 4 символа
    MoveMemory(@R,@Data[1],SizeOf(R));
    Raw:=R;
  end
  else
    if not Assigned(SourceEntity) then
      Raw:=Raw; // выполняется для актуализации алармов при работе сама на себя
  UpdateRealTime;
end;

procedure TVirtFlag.SendIMPULSE;
begin
  with TTimer.Create(nil) do
  begin
    OnTimer:=ImpulseTimer;
    Interval:=1500;
    Enabled:=True;
  end;
  if Raw > 0 then Raw:=0 else Raw:=1;
end;

procedure TVirtFlag.ImpulseTimer(Sender: TObject);
begin
  try
    (Sender as TTimer).Enabled:=False;
    if Raw > 0 then Raw:=0 else Raw:=1;
  finally
    FreeAndNil(Sender);
  end;
end;

function TVirtFlag.GetFetchData: string;
begin
// выполняется на серверной стороне при опросе
  SetLength(Result,SizeOf(Raw));
  MoveMemory(@Result[1],@Raw,SizeOf(Raw));
end;

function TVirtFlag.Prepare: string;
begin
// выполняется на клиентской стороне при изменении значения клиентом
  SetLength(Result,SizeOf(CommandData));
  MoveMemory(@Result[1],@CommandData,SizeOf(CommandData));
end;

function TVirtFlag.PropsCount: integer;
begin
  Result:=16;
end;

class function TVirtFlag.PropsID(Index: integer): string;
begin
  case Index of
    0: Result:='PtName';
    1: Result:='PtDesc';
    2: Result:='Active';
    3: Result:='Alarm';
    4: Result:='Confirm';
    5: Result:='FetchTime';
    6: Result:='Source';
    7: Result:='Invert';
    8: Result:='AlarmOff';
    9: Result:='AlarmOn';
   10: Result:='SwitchOff';
   11: Result:='SwitchOn';
   12: Result:='ColorOff';
   13: Result:='ColorOn';
   14: Result:='TextOff';
   15: Result:='TextOn';
  else
    Result:='Unknown';
  end
end;

class function TVirtFlag.PropsName(Index: integer): string;
begin
  case Index of
    0: Result:='Шифр параметра';
    1: Result:='Десктриптор';
    2: Result:='Опрос';
    3: Result:='Сигнализация';
    4: Result:='Квитирование';
    5: Result:='Время опроса';
    6: Result:='Источник данных';
    7: Result:='Инверсия данных';
    8: Result:='Авария при "1"->"0"';
    9: Result:='Авария при "0"->"1"';
   10: Result:='Переключение при "1"->"0"';
   11: Result:='Переключение при "0"->"1"';
   12: Result:='Цвет при "0"';
   13: Result:='Цвет при "1"';
   14: Result:='Текст при "0"';
   15: Result:='Текст при "1"';
  else
    Result:='';
  end
end;

function TVirtFlag.PropsValue(Index: integer): string;
begin
  case Index of
    0: Result:=FPtName;
    1: Result:=FPtDesc;
    2: Result:=IfThen(FActived,'Да','Нет');
    3: Result:=IfThen(FAsked,'Да','Нет');
    4: Result:=IfThen(FLogged,'Да','Нет');
    5: Result:=Format('%d сек',[FFetchTime]);
    6: Result:=IfThen(Assigned(FSourceEntity),FSourceName,'Авто');
    7: Result:=IfThen(FInvert,'Да','Нет');
    8: Result:=IfThen(FAlarmDown,'Да','Нет');
    9: Result:=IfThen(FAlarmUp,'Да','Нет');
   10: Result:=IfThen(FSwitchDown,'Да','Нет');
   11: Result:=IfThen(FSwitchUp,'Да','Нет');
   12: Result:=StringDigColor[FColorDown];
   13: Result:=StringDigColor[FColorUp];
   14: Result:=FTextDown;
   15: Result:=FTextUp;
  else
    Result:='';
  end
end;

procedure TVirtFlag.SetPV(const Value: Boolean);
const ADig: array[Boolean] of Single = (0.0,1.0);
var KindStatus: TKindStatus;
begin
  inherited;
  KindStatus.AlarmStatus:=AlarmStatus;
  KindStatus.ConfirmStatus:=ConfirmStatus;
  KindStatus.LostAlarmStatus:=LostAlarmStatus;
  Caddy.AddRealValue(PtName+'.RAW',FRAW,Format('%g',[FRaw]),KindStatus);
  Caddy.AddRealValue(PtName+'.PV',ADig[FPV],PtText,KindStatus);
end;

{ TVirtNumeric }

constructor TVirtNumeric.Create;
begin
  inherited;
  FIsVirtual:=True;
  FIsCommand:=True;
end;

class function TVirtNumeric.EntityType: string;
begin
  Result:='Аналоговое число';
end;

function TVirtNumeric.LoadFromStream(Stream: TStream): integer;
begin
  Result:=SizeOf(Body);
  if (Stream.Size-Stream.Position) < Result then
  begin
    Result:=0;
    Exit;
  end;
  Stream.ReadBuffer(Body,Result);
  FPtName:=Body.PtName;
  FPtDesc:=Body.PtDesc;
  FActived:=Body.Actived;
  FLogged:=Body.Logged;
  FAsked:=Body.Asked;
  FFetchTime:=Body.FetchTime;
  FSourceName:=Body.SourceName;
  FEUDesc:=Body.EUDesc;
  FPVFormat:=Body.PVFormat;
  FBadDB:=Body.BadDB;
  FHHDB:=Body.HHDB;
  FHiDB:=Body.HiDB;
  FLoDB:=Body.LoDB;
  FLLDB:=Body.LLDB;
  FPVEUHi:=Body.PVEUHi;
  FPVEULo:=Body.PVEULo;
  FPVHHTP:=Body.PVHHTP;
  FPVHiTP:=Body.PVHiTP;
  FPVLoTP:=Body.PVLoTP;
  FPVLLTP:=Body.PVLLTP;
  FTrend:=Body.Trend;
  FIsTrending:=FTrend;
  FCalcScale:=Body.CalcScale;
end;

procedure TVirtNumeric.SaveToStream(Stream: TStream);
begin
  Body.PtName:=PtName;
  Body.PtDesc:=PtDesc;
  Body.Actived:=Actived;
  Body.Logged:=Logged;
  Body.Asked:=Asked;
  Body.FetchTime:=FetchTime;
  Body.SourceName:=SourceName;
  Body.EUDesc:=EUDesc;
  Body.PVFormat:=PVFormat;
  Body.BadDB:=BadDB;
  Body.HHDB:=HHDB;
  Body.HiDB:=HiDB;
  Body.LoDB:=LoDB;
  Body.LLDB:=LLDB;
  Body.PVEUHi:=PVEUHi;
  Body.PVEULo:=PVEULo;
  Body.PVHHTP:=PVHHTP;
  Body.PVHiTP:=PVHiTP;
  Body.PVLoTP:=PVLoTP;
  Body.PVLLTP:=PVLLTP;
  Body.Trend:=Trend;
  Body.CalcScale:=CalcScale;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

procedure TVirtNumeric.SaveToText(List: TStringList);
begin
  List.Append('[' + PtName + ']');
  List.Append('Plugin=Virtual');
  List.Append('PtType=NN');
  List.Append('PtKind=1');
  List.Append('PtName=' + PtName);
  List.Append('PtDesc=' + PtDesc);
  List.Append('Actived=' + IfThen(Actived, 'True', 'False'));
  List.Append('Logged=' + IfThen(Logged, 'True', 'False'));
  List.Append('Asked=' + IfThen(Asked, 'True', 'False'));
  List.Append('FetchTime=' + IntToStr(FetchTime));
  List.Append('SourceName=' + SourceName);
  List.Append('EUDesc=' + EUDesc);
  List.Append('PVFormat=' + Format('D%d',[Ord(PVFormat)]));
  List.Append('BadDB=' + AAlmDB[BadDB]);
  DecimalSeparator := '.';
  List.Append('PVEUHI=' + Format('%.3f',[PVEUHi]));
  List.Append('PVEULO=' + Format('%.3f',[PVEULo]));
  List.Append('PVHHTP=' + Format('%.3f %s',[PVHHTP, AAlmDB[HHDB]]));
  List.Append('PVHITP=' + Format('%.3f %s',[PVHiTP, AAlmDB[HiDB]]));
  List.Append('PVLOTP=' + Format('%.3f %s',[PVLoTP, AAlmDB[LoDB]]));
  List.Append('PVLLTP=' + Format('%.3f %s',[PVLLTP, AAlmDB[LLDB]]));
  List.Append('Trend=' + IfThen(Trend, 'True', 'False'));
  List.Append('CalcScale=' + IfThen(CalcScale, 'True', 'False'));
end;

class function TVirtNumeric.TypeCode: string;
begin
  Result:='NN';
end;

class function TVirtNumeric.TypeColor: TColor;
begin
  Result:=$00FFFFCC;
end;

procedure TVirtNumeric.Fetch(const Data: string);
var R: Single;
begin
  if Length(Data) = SizeOf(R) then
  begin
// выполняется на клиентской стороне, если сервер прислал строку в 4 символа
    MoveMemory(@R,@Data[1],SizeOf(R));
    Raw:=R;
  end
  else
    if not Assigned(SourceEntity) then
      Raw:=Raw; // выполняется для актуализации алармов при работе сама на себя
  UpdateRealTime;
end;

function TVirtNumeric.GetFetchData: string;
begin
// выполняется на серверной стороне при опросе
  SetLength(Result,SizeOf(Raw));
  MoveMemory(@Result[1],@Raw,SizeOf(Raw));
end;

function TVirtNumeric.Prepare: string;
begin
// выполняется на клиентской стороне при изменении значения клиентом
  SetLength(Result,SizeOf(CommandData));
  MoveMemory(@Result[1],@CommandData,SizeOf(CommandData));
end;

function TVirtNumeric.PropsCount: integer;
begin
  Result:=18;
end;

class function TVirtNumeric.PropsID(Index: integer): string;
begin
  case Index of
    0: Result:='PtName';
    1: Result:='PtDesc';
    2: Result:='Active';
    3: Result:='Alarm';
    4: Result:='Confirm';
    5: Result:='Trend';
    6: Result:='FetchTime';
    7: Result:='Source';
    8: Result:='EUDesc';
    9: Result:='FormatPV';
   10: Result:='PVEUHI';
   11: Result:='PVHHTP';
   12: Result:='PVHITP';
   13: Result:='PVLOTP';
   14: Result:='PVLLTP';
   15: Result:='PVEULO';
   16: Result:='BadDB';
   17: Result:='CalcScale';
  else
    Result:='';
  end
end;

class function TVirtNumeric.PropsName(Index: integer): string;
begin
  case Index of
    0: Result:='Шифр параметра';
    1: Result:='Десктриптор';
    2: Result:='Опрос';
    3: Result:='Сигнализация';
    4: Result:='Квитирование';
    5: Result:='Тренд';
    6: Result:='Время опроса';
    7: Result:='Источник данных';
    8: Result:='Размерность';
    9: Result:='Формат PV';
   10: Result:='Верхняя граница шкалы';
   11: Result:='Верхняя предаварийная граница';
   12: Result:='Верхняя предупредительная граница';
   13: Result:='Нижняя предупредительная граница';
   14: Result:='Нижняя предаварийная граница';
   15: Result:='Нижняя граница шкалы';
   16: Result:='Контроль границ шкалы';
   17: Result:='Масштаб по шкале';
  else
    Result:='';
  end
end;

function TVirtNumeric.PropsValue(Index: integer): string;
var sFormat: string;
begin
  sFormat:='%.'+Format('%d',[Ord(FPVFormat)])+'f';
  DecimalSeparator := '.';
  case Index of
    0: Result:=FPtName;
    1: Result:=FPtDesc;
    2: Result:=IfThen(FActived,'Да','Нет');
    3: Result:=IfThen(FAsked,'Да','Нет');
    4: Result:=IfThen(FLogged,'Да','Нет');
    5: Result:=IfThen(FTrend,'Да','Нет');
    6: Result:=Format('%d сек',[FFetchTime]);
    7: Result:=IfThen(Assigned(FSourceEntity),FSourceName,'Авто');
    8: Result:=FEUDesc;
    9: Result:=Format('D%d',[Ord(FPVFormat)]);
   10: Result:=Format(sFormat,[FPVEUHi]);
   11: Result:=Format(sFormat,[FPVHHTP])+' '+AAlmDB[FHHDB];
   12: Result:=Format(sFormat,[FPVHITP])+' '+AAlmDB[FHIDB];
   13: Result:=Format(sFormat,[FPVLOTP])+' '+AAlmDB[FLODB];
   14: Result:=Format(sFormat,[FPVLLTP])+' '+AAlmDB[FLLDB];
   15: Result:=Format(sFormat,[FPVEULo]);
   16: Result:=AAlmDB[FBadDB];
   17: Result:=IfThen(FCalcScale,'Да','Нет');
  else
    Result:='';
  end
end;

procedure TVirtNumeric.SetPV(const Value: Double);
var KindStatus: TKindStatus;
begin
  inherited;
  KindStatus.AlarmStatus:=AlarmStatus;
  KindStatus.ConfirmStatus:=ConfirmStatus;
  KindStatus.LostAlarmStatus:=LostAlarmStatus;
  Caddy.AddRealValue(PtName+'.RAW',FRAW,Format('%g',[FRaw]),KindStatus);
  Caddy.AddRealValue(PtName+'.PV',FPV,PtText,KindStatus);
end;

{ TVirtVDGroup }

constructor TVirtVDGroup.Create;
var i: integer;
begin
  inherited;
  FIsVirtual:=True;
  LocalFetchOnly:=True;
  for i:=0 to 31 do EntityChilds[i]:=nil;
end;

class function TVirtVDGroup.EntityType: string;
begin
  Result:='Виртуальный дешифратор';
end;

function TVirtVDGroup.GetMaxChildCount: integer;
begin
  Result:=31;
end;

function TVirtVDGroup.LoadFromStream(Stream: TStream): integer;
var i: integer;
begin
  Result:=SizeOf(Body);
  if (Stream.Size-Stream.Position) < Result then
  begin
    Result:=0;
    Exit;
  end;
  Stream.ReadBuffer(Body,Result);
  FPtName:=Body.PtName;
  FPtDesc:=Body.PtDesc;
  FActived:=Body.Actived;
  FFetchTime:=Body.FetchTime;
  FSourceName:=Body.SourceName;
  FChilds.Clear;
  for i:=0 to 31 do FChilds.AddObject(Body.Childs[i],nil);
end;

procedure TVirtVDGroup.SaveToStream(Stream: TStream);
var i: integer;
begin
  Body.PtName:=PtName;
  Body.PtDesc:=PtDesc;
  Body.Actived:=Actived;
  Body.FetchTime:=FetchTime;
  Body.SourceName:=SourceName;
  for i:=0 to 31 do Body.Childs[i]:='';
  for i:=0 to Count-1 do
  if i in [0..31] then
  begin
    if Assigned(EntityChilds[i]) then
      Body.Childs[i]:=EntityChilds[i].PtName;
  end;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

procedure TVirtVDGroup.SaveToText(List: TStringList);
var i: integer;
begin
  List.Append('[' + PtName + ']');
  List.Append('Plugin=Virtual');
  List.Append('PtType=VD');
  List.Append('PtKind=3');
  List.Append('PtName=' + PtName);
  List.Append('PtDesc=' + PtDesc);
  List.Append('Actived=' + IfThen(Actived, 'True', 'False'));
  List.Append('FetchTime=' + IntToStr(FetchTime));
  List.Append('SourceName=' + SourceName);
  for i:=0 to 31 do
     List.Append(Format('Child%d=%s', [i + 1, Body.Childs[i]]));
end;

class function TVirtVDGroup.TypeCode: string;
begin
  Result:='VD';
end;

class function TVirtVDGroup.TypeColor: TColor;
begin
  Result:=$00FFFFCC;
end;

procedure TVirtVDGroup.Decode(Value: Single);
var Data: Cardinal; i: integer; B: boolean;
begin
  MoveMemory(@Data,@Value,4);
  for i:=0 to 31 do
  if Assigned(EntityChilds[i]) and EntityChilds[i].Actived then
  begin
    B:=(Data and Cardinal(1 shl i) > 0);
    if B then
      EntityChilds[i].Raw:=1
    else
      EntityChilds[i].Raw:=0;
  end;
  inherited SetRaw(Value);
end;

procedure TVirtVDGroup.SetRaw(const Value: Double);
begin
  // Stub
end;

procedure TVirtVDGroup.Fetch(const Data: string);
begin
  if not Assigned(SourceEntity) then Raw:=Raw;
  UpdateRealTime;
end;

function TVirtVDGroup.GetTextValue: string;
begin
  Result:=IntToHex(Trunc(Raw),8);
end;

function TVirtVDGroup.GetPtVal: string;
begin
  Result:=GetTextValue;
end;

function TVirtVDGroup.PropsCount: integer;
begin
  Result:=37;
end;

class function TVirtVDGroup.PropsID(Index: integer): string;
begin
  case Index of
    0: Result:='PtName';
    1: Result:='PtDesc';
    2: Result:='Active';
    3: Result:='FetchTime';
    4: Result:='Source';
    5..36: Result:='Output'+IntToStr(Index-4);
  else
    Result:='Unknown';
  end
end;

class function TVirtVDGroup.PropsName(Index: integer): string;
begin
  case Index of
    0: Result:='Шифр параметра';
    1: Result:='Десктриптор';
    2: Result:='Опрос';
    3: Result:='Время опроса';
    4: Result:='Источник данных';
    5..36: Result:='Выход '+IntToStr(Index-4);
  else
    Result:='';
  end
end;

function TVirtVDGroup.PropsValue(Index: integer): string;
begin
  case Index of
    0: Result:=FPtName;
    1: Result:=FPtDesc;
    2: Result:=IfThen(FActived,'Да','Нет');
    3: Result:=Format('%d сек',[FFetchTime]);
    4: Result:=IfThen(Assigned(FSourceEntity),FSourceName,'Авто');
    5..36: if (Index-5 < Count) and Assigned(EntityChilds[Index-5]) then
             Result:=Childs[Index-5]
           else
             Result:='';
  else
    Result:='';
  end
end;

{ TVirtSysInfo }

procedure TVirtSysInfo.Assign(E: TEntity);
var T: TVirtSysInfo;
begin
  inherited;
  T:=E as TVirtSysInfo;
  FKind:=T.Kind;
  FKoeff:=T.Koeff;
end;

constructor TVirtSysInfo.Create;
begin
  inherited;
  FIsVirtual:=True;
  FIsComposit:=True;
  LocalFetchOnly:=True;
  FEUDesc:='кБайт';
end;

class function TVirtSysInfo.EntityType: string;
begin
  Result:='Информация системы';
end;

procedure TVirtSysInfo.Fetch(const Data: string);
var MS: TMemoryStatus;
    FreeBytesAvailableToCaller: TLargeInteger;
    FreeSize: TLargeInteger;
    TotalSize: TLargeInteger;
begin
  case FKind of
   siPhysical: begin
                 MS.dwLength := SizeOf(TMemoryStatus);
                 GlobalMemoryStatus(MS);
                 case FKoeff of
           skByte: FPVEUHI:=MS.dwTotalPhys;
          skKByte: FPVEUHI:=MS.dwTotalPhys/1024;
          skMByte: FPVEUHI:=MS.dwTotalPhys/(1024*1024);
                 end;
                 FPVEULO:=0;
                 Raw:=(MS.dwTotalPhys-MS.dwAvailPhys)/MS.dwTotalPhys*100.0;
               end;
    siVirtual: begin
                 MS.dwLength := SizeOf(TMemoryStatus);
                 GlobalMemoryStatus(MS);
                 case FKoeff of
           skByte: FPVEUHI:=MS.dwTotalVirtual;
          skKByte: FPVEUHI:=MS.dwTotalVirtual/1024;
          skMByte: FPVEUHI:=MS.dwTotalVirtual/(1024*1024);
                 end;
                 FPVEULO:=0;
                 Raw:=(MS.dwTotalVirtual-MS.dwAvailVirtual)/MS.dwTotalVirtual*100.0;
               end;
   siPageFile: begin
                 MS.dwLength := SizeOf(TMemoryStatus);
                 GlobalMemoryStatus(MS);
                 case FKoeff of
           skByte: FPVEUHI:=MS.dwTotalPageFile;
          skKByte: FPVEUHI:=MS.dwTotalPageFile/1024;
          skMByte: FPVEUHI:=MS.dwTotalPageFile/(1024*1024);
                 end;
                 FPVEULO:=0;
                 Raw:=(MS.dwTotalPageFile-MS.dwAvailPageFile)/
                       MS.dwTotalPageFile*100.0;
               end;
        siHDD: begin
                 GetDiskFreeSpaceEx(PChar(Caddy.CurrentBasePath),
                    FreeBytesAvailableToCaller,Totalsize,@FreeSize);
                 case FKoeff of
           skByte: FPVEUHI:=Totalsize;
          skKByte: FPVEUHI:=Totalsize/1024;
          skMByte: FPVEUHI:=Totalsize/(1024*1024);
                 end;
                 FPVEULO:=0;
                 Raw:=(Totalsize-FreeSize)/Totalsize*100.0;
               end;
        siAllocMemSize:
               begin
                 MS.dwLength := SizeOf(TMemoryStatus);
                 GlobalMemoryStatus(MS);
                 case FKoeff of
           skByte: FPVEUHI:=MS.dwTotalPhys;
          skKByte: FPVEUHI:=MS.dwTotalPhys/1024;
          skMByte: FPVEUHI:=MS.dwTotalPhys/(1024*1024);
                 end;
                 FPVEULO:=0;
                 Raw:=AllocMemSize/MS.dwTotalPhys*100.0;
               end;
  end;
  UpdateRealTime;
end;

function TVirtSysInfo.LoadFromStream(Stream: TStream): integer;
begin
  Result:=SizeOf(Body);
  if (Stream.Size-Stream.Position) < Result then
  begin
    Result:=0;
    Exit;
  end;
  Stream.ReadBuffer(Body,Result);
  FPtName:=Body.PtName;
  FPtDesc:=Body.PtDesc;
  FActived:=Body.Actived;
  FLogged:=Body.Logged;
  FAsked:=Body.Asked;
  FFetchTime:=Body.FetchTime;
  FEUDesc:=Body.EUDesc;
  FPVFormat:=Body.PVFormat;
  FHHDB:=Body.HHDB;
  FHiDB:=Body.HiDB;
  FLoDB:=Body.LoDB;
  FLLDB:=Body.LLDB;
  FPVHHTP:=Body.PVHHTP;
  FPVHiTP:=Body.PVHiTP;
  FPVLoTP:=Body.PVLoTP;
  FPVLLTP:=Body.PVLLTP;
  FKoeff:=Body.Koeff;
  FKind:=Body.Kind;
  FTrend:=Body.Trend;
  FIsTrending:=FTrend;
end;

function TVirtSysInfo.PropsCount: integer;
begin
  Result:=17;
end;

class function TVirtSysInfo.PropsID(Index: integer): string;
begin
  case Index of
    0: Result:='PtName';
    1: Result:='PtDesc';
    2: Result:='Active';
    3: Result:='Alarm';
    4: Result:='Confirm';
    5: Result:='Trend';
    6: Result:='FetchTime';
    7: Result:='InfoKind';
    8: Result:='SizeKoeff';
    9: Result:='EUDesc';
   10: Result:='FormatPV';
   11: Result:='PVEUHI';
   12: Result:='PVHHTP';
   13: Result:='PVHITP';
   14: Result:='PVLOTP';
   15: Result:='PVLLTP';
   16: Result:='PVEULO';
  else
    Result:='Unknown';
  end
end;

class function TVirtSysInfo.PropsName(Index: integer): string;
begin
  case Index of
    0: Result:='Шифр параметра';
    1: Result:='Десктриптор';
    2: Result:='Опрос';
    3: Result:='Сигнализация';
    4: Result:='Квитирование';
    5: Result:='Тренд';
    6: Result:='Время опроса';
    7: Result:='Тип информации';
    8: Result:='Множитель';
    9: Result:='Размерность';
   10: Result:='Формат PV';
   11: Result:='Верхняя граница шкалы';
   12: Result:='Верхняя предаварийная граница';
   13: Result:='Верхняя предупредительная граница';
   14: Result:='Нижняя предупредительная граница';
   15: Result:='Нижняя предаварийная граница';
   16: Result:='Нижняя граница шкалы';
  else
    Result:='';
  end
end;

function TVirtSysInfo.PropsValue(Index: integer): string;
var sFormat: string;
begin
  sFormat:='%.'+Format('%d',[Ord(FPVFormat)])+'f';
  DecimalSeparator := '.';
  case Index of
    0: Result:=FPtName;
    1: Result:=FPtDesc;
    2: Result:=IfThen(FActived,'Да','Нет');
    3: Result:=IfThen(FAsked,'Да','Нет');
    4: Result:=IfThen(FLogged,'Да','Нет');
    5: Result:=IfThen(FTrend,'Да','Нет');
    6: Result:=Format('%d сек',[FFetchTime]);
    7: Result:=ASysInfoKind[FKind];
    8: Result:=ASizeKoeff[FKoeff];
    9: Result:=FEUDesc;
   10: Result:=Format('D%d',[Ord(FPVFormat)]);
   11: Result:=Format(sFormat,[FPVEUHi]);
   12: Result:=Format(sFormat,[FPVHHTP])+' '+AAlmDB[FHHDB];
   13: Result:=Format(sFormat,[FPVHITP])+' '+AAlmDB[FHIDB];
   14: Result:=Format(sFormat,[FPVLOTP])+' '+AAlmDB[FLODB];
   15: Result:=Format(sFormat,[FPVLLTP])+' '+AAlmDB[FLLDB];
   16: Result:=Format(sFormat,[FPVEULo]);
  else
    Result:='';
  end
end;

procedure TVirtSysInfo.SaveToStream(Stream: TStream);
begin
  Body.PtName:=PtName;
  Body.PtDesc:=PtDesc;
  Body.Actived:=Actived;
  Body.Logged:=Logged;
  Body.Asked:=Asked;
  Body.FetchTime:=FetchTime;
  Body.EUDesc:=EUDesc;
  Body.PVFormat:=PVFormat;
  Body.HHDB:=HHDB;
  Body.HiDB:=HiDB;
  Body.LoDB:=LoDB;
  Body.LLDB:=LLDB;
  Body.PVHHTP:=PVHHTP;
  Body.PVHiTP:=PVHiTP;
  Body.PVLoTP:=PVLoTP;
  Body.PVLLTP:=PVLLTP;
  Body.Koeff:=Koeff;
  Body.Kind:=Kind;
  Body.Trend:=Trend;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

procedure TVirtSysInfo.SaveToText(List: TStringList);
begin
  List.Append('[' + PtName + ']');
  List.Append('Plugin=Virtual');
  List.Append('PtType=SI');
  List.Append('PtKind=1');
  List.Append('PtName=' + PtName);
  List.Append('PtDesc=' + PtDesc);
  List.Append('Actived=' + IfThen(Actived, 'True', 'False'));
  List.Append('Logged=' + IfThen(Logged, 'True', 'False'));
  List.Append('Asked=' + IfThen(Asked, 'True', 'False'));
  List.Append('FetchTime=' + IntToStr(FetchTime));
  List.Append('SourceName=' + SourceName);
  List.Append('EUDesc=' + EUDesc);
  List.Append('PVFormat=' + Format('D%d',[Ord(PVFormat)]));
  List.Append('BadDB=' + AAlmDB[BadDB]);
  DecimalSeparator := '.';
  List.Append('PVEUHI=' + Format('%.3f',[PVEUHi]));
  List.Append('PVEULO=' + Format('%.3f',[PVEULo]));
  List.Append('PVHHTP=' + Format('%.3f %s',[PVHHTP, AAlmDB[HHDB]]));
  List.Append('PVHITP=' + Format('%.3f %s',[PVHiTP, AAlmDB[HiDB]]));
  List.Append('PVLOTP=' + Format('%.3f %s',[PVLoTP, AAlmDB[LoDB]]));
  List.Append('PVLLTP=' + Format('%.3f %s',[PVLLTP, AAlmDB[LLDB]]));
  List.Append('Trend=' + IfThen(Trend, 'True', 'False'));
  List.Append('CalcScale=' + IfThen(CalcScale, 'True', 'False'));
  List.Append('Koeff=' + ASizeKoeff[Koeff]);
  List.Append('Kind=' + ASysInfoKind[Kind]);
end;

procedure TVirtSysInfo.SetKind(const Value: TSysInfoKind);
begin
  if FKind <> Value then
  begin
    Caddy.AddChange(FPtName,'Тип информации',ASysInfoKind[FKind],
                    ASysInfoKind[Value],FPtDesc,Caddy.Autor);
    FKind:=Value;
    Caddy.Changed:=True;
  end;
end;

procedure TVirtSysInfo.SetKoeff(const Value: TSizeKoeff);
begin
  if FKoeff <> Value then
  begin
    Caddy.AddChange(FPtName,'Тип информации',ASizeKoeff[FKoeff],
                    ASizeKoeff[Value],FPtDesc,Caddy.Autor);
    FKoeff:=Value;
    Caddy.Changed:=True;
  end;
end;

class function TVirtSysInfo.TypeCode: string;
begin
  Result:='SI';
end;

class function TVirtSysInfo.TypeColor: TColor;
begin
  Result:=$00FFFFCC;
end;

{ TVirtValve }

procedure TVirtValve.ConnectLinks;
var E: TEntity;
begin
  inherited;
  E:=Caddy.Find(FSourceStatALM);
  if Assigned(E) then
    StatALM:=E as TCustomDigOut else StatALM:=nil;
  E:=Caddy.Find(FSourceStatON);
  if Assigned(E) then
    StatON:=E as TCustomDigOut else StatON:=nil;
  E:=Caddy.Find(FSourceStatOFF);
  if Assigned(E) then
    StatOFF:=E as TCustomDigOut else StatOFF:=nil;
  E:=Caddy.Find(FSourceCommON);
  if Assigned(E) then
    CommON:=E else CommON:=nil;
  E:=Caddy.Find(FSourceCommOFF);
  if Assigned(E) then
    CommOFF:=E else CommOFF:=nil;
end;

constructor TVirtValve.Create;
begin
  inherited;
  FIsVirtual:=True;
  FIsComposit:=True;
  LocalFetchOnly:=True;
end;

class function TVirtValve.EntityType: string;
begin
  Result:='Виртуальная задвижка';
end;

procedure TVirtValve.Fetch(const Data: string);
var Result: Byte; OpOFF, OpON, OpALM, BadPV: boolean;
//    LastAlarm: TAlarmState;
//    AlarmFound, HasAlarm, HasConfirm, HasNoLink, HasBadPV, HasTimeOut: boolean;
begin
  OpOFF:=False;
  OpON:=False;
  Result:=0;
  BadPV:=False;
  ErrorMess:='';
  NoLink:=False;
  if Assigned(StatOFF) then
  begin
    OpOFF:=StatOFF.PV;
    if asNoLink in StatOFF.AlarmStatus then
      NoLink:=True;
  end
  else
  begin
    ErrorMess:='Плохой источник OFF';
    BadPV:=True;
  end;
  if Assigned(StatON) then
  begin
    OpON:=StatON.PV;
    if asNoLink in StatON.AlarmStatus then
      NoLink:=True;
  end
  else
  begin
    ErrorMess:='Плохой источник ON';
    BadPV:=True;
  end;
  if not BadPV then
  begin
    if OpOFF then
      Result:=Result or $01
    else
      Result:=Result and $FE;
    if OpON then
      Result:=Result or $02
    else
      Result:=Result and $FD;
    if Assigned(StatALM) then
    begin
      OpALM:=StatALM.PV;
      if asNoLink in StatALM.AlarmStatus then
        NoLink:=True;
      if OpALM then
      begin
        Result:=Result or $04;
        if FLogged and not (asTimeOut in AlarmStatus) then
          Caddy.AddAlarm(asTimeOut,Self);
      end
      else
      begin
        Result:=Result and $FB;
        ErrorMess:='';
        if FLogged and (asTimeOut in AlarmStatus) then
          Caddy.RemoveAlarm(asTimeOut,Self);
      end;
    end
    else
    begin
      if SourceStatALM <> '' then
      begin
        ErrorMess:='Плохой источник StatALM';
        BadPV:=True;
      end
      else
      begin
        Result:=Result and $FB;
        if FLogged and (asTimeOut in AlarmStatus) then
          Caddy.RemoveAlarm(asTimeOut,Self);
      end;
    end;
    FPV:=Result;
  end;
  if (FPV and $03) = $03 then
  begin
    BadPV:=True;
    ErrorMess:='Авария концевых выключателей';
  end;
  if FLogged then
  begin
    if BadPV and not (asBadPV in AlarmStatus) then
      Caddy.AddAlarm(asBadPV,Self);
    if not BadPV and (asBadPV in AlarmStatus) then
      Caddy.RemoveAlarm(asBadPV,Self);
  end;
  UpdateRealTime;
end;

function TVirtValve.GetPtVal: string;
begin
  case FPV of
    0,4: Result:='ХОД';
    1,5: Result:='ЗАКРЫТО';
    2,6: Result:='ОТКРЫТО';
    3,7: Result:='АВАРИЯ';
  end;
end;

function TVirtValve.GetTextValue: string;
begin
  case FPV of
    0,4: Result:='ХОД';
    1,5: Result:='ЗАКРЫТО';
    2,6: Result:='ОТКРЫТО';
    3,7: Result:='АВАРИЯ';
  end;
end;

function TVirtValve.LoadFromStream(Stream: TStream): integer;
begin
  Result:=SizeOf(Body);
  if (Stream.Size-Stream.Position) < Result then
  begin
    Result:=0;
    Exit;
  end;
  Stream.ReadBuffer(Body,Result);
  FPtName:=Body.PtName;
  FPtDesc:=Body.PtDesc;
  FActived:=Body.Actived;
  FLogged:=Body.Logged;
  FAsked:=Body.Asked;
  FFetchTime:=Body.FetchTime;
  FSourceStatALM:=Body.SourceStatALM;
  FSourceStatON:=Body.SourceStatON;
  FSourceStatOFF:=Body.SourceStatOFF;
  FSourceCommON:=Body.SourceCommON;
  FSourceCommOFF:=Body.SourceCommOFF;
end;

procedure TVirtValve.Notify(Kind: TEntityNotify; E: TEntity);
begin
  inherited;
  case Kind of
    enRename: begin
                if E = FStatALM then FSourceStatALM:=E.PtName;
                if E = FStatON then FSourceStatON:=E.PtName;
                if E = FStatOFF then FSourceStatOFF:=E.PtName;
                if E = FCommON then FSourceCommON:=E.PtName;
                if E = FCommOFF then FSourceCommOFF:=E.PtName;
              end;
    enDelete: begin
                if E = FStatALM then StatALM:=nil;
                if E = FStatON then StatON:=nil;
                if E = FStatOFF then StatOFF:=nil;
                if E = FCommON then CommON:=nil;
                if E = FCommOFF then CommOFF:=nil;
              end;
  end;
end;

function TVirtValve.PropsCount: integer;
begin
  Result:=11;
end;

class function TVirtValve.PropsID(Index: integer): string;
begin
  case Index of
    0: Result:='PtName';
    1: Result:='PtDesc';
    2: Result:='Active';
    3: Result:='Alarm';
    4: Result:='Confirm';
    5: Result:='FetchTime';
    6: Result:='SourceStatALM';
    7: Result:='SourceStatON';
    8: Result:='SourceStatOFF';
    9: Result:='SourceCommON';
   10: Result:='SourceCommOFF';
  else
    Result:='Unknown';
  end
end;

class function TVirtValve.PropsName(Index: integer): string;
begin
  case Index of
    0: Result:='Шифр параметра';
    1: Result:='Десктриптор';
    2: Result:='Опрос';
    3: Result:='Сигнализация';
    4: Result:='Квитирование';
    5: Result:='Время опроса';
    6: Result:='Состояние "АВАРИЯ"';
    7: Result:='Состояние "ОТКРЫТО"';
    8: Result:='Состояние "ЗАКРЫТО"';
    9: Result:='Команда "ОТКРЫТЬ"';
   10: Result:='Команда "ЗАКРЫТЬ"';
  else
    Result:='';
  end
end;

function TVirtValve.PropsValue(Index: integer): string;
begin
  case Index of
    0: Result:=FPtName;
    1: Result:=FPtDesc;
    2: Result:=IfThen(FActived,'Да','Нет');
    3: Result:=IfThen(FLogged,'Да','Нет');
    4: Result:=IfThen(FAsked,'Да','Нет');
    5: Result:=Format('%d сек',[FFetchTime]);
    6: Result:=IfThen(Assigned(FStatALM),FSourceStatALM,'');
    7: Result:=IfThen(Assigned(FStatON),FSourceStatON,'');
    8: Result:=IfThen(Assigned(FStatOFF),FSourceStatOFF,'');
    9: Result:=IfThen(Assigned(FCommON),FSourceCommON,'');
   10: Result:=IfThen(Assigned(FCommOFF),FSourceCommOFF,'');
  else
    Result:='';
  end
end;

procedure TVirtValve.SaveToStream(Stream: TStream);
begin
  Body.PtName:=PtName;
  Body.PtDesc:=PtDesc;
  Body.Actived:=Actived;
  Body.Logged:=Logged;
  Body.Asked:=Asked;
  Body.FetchTime:=FetchTime;
  Body.SourceStatALM:=SourceStatALM;
  Body.SourceStatON:=SourceStatON;
  Body.SourceStatOFF:=SourceStatOFF;
  Body.SourceCommON:=SourceCommON;
  Body.SourceCommOFF:=SourceCommOFF;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

procedure TVirtValve.SaveToText(List: TStringList);
begin
  List.Append('[' + PtName + ']');
  List.Append('Plugin=Virtual');
  List.Append('PtType=VC');
  List.Append('PtKind=6');
  List.Append('PtName=' + PtName);
  List.Append('PtDesc=' + PtDesc);
  List.Append('Actived=' + IfThen(Actived, 'True', 'False'));
  List.Append('FetchTime=' + IntToStr(FetchTime));
  List.Append('SourceStatALM=' + SourceStatALM);
  List.Append('SourceStatON=' + SourceStatON);
  List.Append('SourceStatOFF=' + SourceStatOFF);
  List.Append('SourceCommON=' + SourceCommON);
  List.Append('SourceCommOFF=' + SourceCommOFF);
end;

procedure TVirtValve.SendClose;
begin
  if Assigned(FCommOFF) then
  begin
    Caddy.AddChange(FPtName,'OP',PTText,'ЗАКРЫТЬ',FPtDesc,Caddy.Autor);
    FCommOFF.SendIMPULSE
  end
  else
    Caddy.ShowMessage(kmError,'Команда закрытия не определена!');
end;

procedure TVirtValve.SendOpen;
begin
  if Assigned(FCommON) then
  begin
    Caddy.AddChange(FPtName,'OP',PTText,'ОТКРЫТЬ',FPtDesc,Caddy.Autor);
    FCommON.SendIMPULSE
  end
  else
    Caddy.ShowMessage(kmError,'Команда открытия не определена!');
end;

procedure TVirtValve.SetCommOFF(const Value: TEntity);
var S: string;
begin
  FCommOFF:=Value;
  S:=FSourceCommOFF;
  if Assigned(FCommOFF) then
    FSourceCommOFF:=Value.PtName
  else
    FSourceCommOFF:='';
  if S <> FSourceCommOFF then
  begin
    Caddy.AddChange(PtName,'Источник CommOFF',S,FSourceCommOFF,
                              PtDesc,Caddy.Autor);
    Caddy.Changed:=True;
  end;
end;

procedure TVirtValve.SetCommON(const Value: TEntity);
var S: string;
begin
  FCommON:=Value;
  S:=FSourceCommON;
  if Assigned(FCommON) then
    FSourceCommON:=Value.PtName
  else
    FSourceCommON:='';
  if S <> FSourceCommON then
  begin
    Caddy.AddChange(PtName,'Источник CommON',S,FSourceCommON,
                              PtDesc,Caddy.Autor);
    Caddy.Changed:=True;
  end;
end;

procedure TVirtValve.SetPV(const Value: Byte);
begin
  if FPV <> Value then
  begin
    FPV:=Value;
    if FLogged then
    begin
      if ((FPV and $03) = 3) and not (asBadPV in AlarmStatus) then
        Caddy.AddAlarm(asBadPV,Self);
      if ((FPV and $03) <> 3) and (asBadPV in AlarmStatus) then
        Caddy.RemoveAlarm(asBadPV,Self);
      if ((FPV and $04) > 0) and not (asTimeOut in AlarmStatus) then
        Caddy.AddAlarm(asTimeOut,Self);
      if ((FPV and $04) <= 0) and (asTimeOut in AlarmStatus) then
        Caddy.RemoveAlarm(asTimeOut,Self);
    end;
  end;
end;

procedure TVirtValve.SetStatALM(const Value: TCustomDigOut);
var S: string;
begin
  FStatALM:=Value;
  S:=FSourceStatALM;
  if Assigned(FStatALM) then
    FSourceStatALM:=Value.PtName
  else
    FSourceStatALM:='';
  if S <> FSourceStatALM then
  begin
    Caddy.AddChange(PtName,'Источник StatALM',S,FSourceStatALM,
                              PtDesc,Caddy.Autor);
    Caddy.Changed:=True;
  end;
end;

procedure TVirtValve.SetStatOFF(const Value: TCustomDigOut);
var S: string;
begin
  FStatOFF:=Value;
  S:=FSourceStatOFF;
  if Assigned(FStatOFF) then
    FSourceStatOFF:=Value.PtName
  else
    FSourceStatOFF:='';
  if S <> FSourceStatOFF then
  begin
    Caddy.AddChange(PtName,'Источник StatOFF',S,FSourceStatOFF,
                              PtDesc,Caddy.Autor);
    Caddy.Changed:=True;
  end;
end;

procedure TVirtValve.SetStatON(const Value: TCustomDigOut);
var S: string;
begin
  FStatON:=Value;
  S:=FSourceStatON;
  if Assigned(FStatON) then
    FSourceStatON:=Value.PtName
  else
    FSourceStatON:='';
  if S <> FSourceStatON then
  begin
    Caddy.AddChange(PtName,'Источник StatON',S,FSourceStatON,
                              PtDesc,Caddy.Autor);
    Caddy.Changed:=True;
  end;
end;

class function TVirtValve.TypeCode: string;
begin
  Result:='VC';
end;

class function TVirtValve.TypeColor: TColor;
begin
  Result:=$00FFFFCC;
end;

{ TVirtAnaSel }

procedure TVirtAnaSel.ConnectLinks;
var E: TEntity;
begin
  inherited;
  E:=Caddy.Find(FSourceAnaVar1);
  if Assigned(E) then
    AnaVar1:=E as TCustomAnaOut else AnaVar1:=nil;
  E:=Caddy.Find(FSourceAnaVar2);
  if Assigned(E) then
    AnaVar2:=E as TCustomAnaOut else AnaVar2:=nil;
  E:=Caddy.Find(FSourceAnaVar3);
  if Assigned(E) then
    AnaVar3:=E as TCustomAnaOut else AnaVar3:=nil;
  E:=Caddy.Find(FSourceAnaVar4);
  if Assigned(E) then
    AnaVar4:=E as TCustomAnaOut else AnaVar4:=nil;
  E:=Caddy.Find(FSourceDigVar1);
  if Assigned(E) then
    DigVar1:=E as TCustomDigOut else DigVar1:=nil;
  E:=Caddy.Find(FSourceDigVar2);
  if Assigned(E) then
    DigVar2:=E as TCustomDigOut else DigVar2:=nil;
  E:=Caddy.Find(FSourceDigVar3);
  if Assigned(E) then
    DigVar3:=E as TCustomDigOut else DigVar3:=nil;
  E:=Caddy.Find(FSourceDigVar4);
  if Assigned(E) then
    DigVar4:=E as TCustomDigOut else DigVar4:=nil;
end;

constructor TVirtAnaSel.Create;
begin
  inherited;
  FIsVirtual:=True;
  FIsComposit:=True;
  LocalFetchOnly:=True;
  SelNum:=0;
  SelEntity:=nil;
end;

class function TVirtAnaSel.EntityType: string;
begin
  Result:='Аналоговый селектор';
end;

procedure TVirtAnaSel.Fetch(const Data: string);
var Changed, Found: Boolean;
//    KindStatus: TKindStatus;
    Alarm: TAlarmState;
    i: integer;
    aAO: array[1..4] of TCustomAnaOut;
    aDO: array[1..4] of TCustomDigOut;
//    M: TMemoryStream;
begin
  aAO[1]:=FAnaVar1; aAO[2]:=FAnaVar2; aAO[3]:=FAnaVar3; aAO[4]:=FAnaVar4;
  aDO[1]:=FDigVar1; aDO[2]:=FDigVar2; aDO[3]:=FDigVar3; aDO[4]:=FDigVar4;
  Changed:=False;
  Found:=False;
  for i:=1 to 4 do
  if Assigned(aDO[i]) and aDO[i].PV then
  begin
    Found:=True;
    if SelNum <> i then
    begin
      SelNum:=i;
      Changed:=True;
    end;
    Break;
  end;
  if not Found and (SelNum <> 0) then
  begin
    SelNum:=0;
    Changed:=True;
  end;
  if Changed then
  begin
    if (SelNum <> 0) and Assigned(aAO[SelNum]) then
    begin
      FPVEUHi:=aAO[SelNum].PVEUHi;
      FPVEULo:=aAO[SelNum].PVEULo;
      FPVHHTP:=aAO[SelNum].PVHHTP;
      FPVHiTP:=aAO[SelNum].PVHiTP;
      FPVLoTP:=aAO[SelNum].PVLoTP;
      FPVLLTP:=aAO[SelNum].PVLLTP;
      FHHDB:=aAO[SelNum].HHDB;
      FHiDB:=aAO[SelNum].HiDB;
      FLoDB:=aAO[SelNum].LoDB;
      FLLDB:=aAO[SelNum].LLDB;
      FBadDB:=aAO[SelNum].BadDB;
      FPVFormat:=aAO[SelNum].PVFormat;
      FPtDesc:=aAO[SelNum].PtDesc;
      FEUDesc:=aAO[SelNum].EUDesc;
      SelEntity:=aAO[SelNum];
      ErrorMess:=aAO[SelNum].ErrorMess;
      if GetAlarmState(Alarm) then Caddy.RemoveAlarms(Self);
      FirstCalc:=True;
    end
    else
    begin
      FPVHHTP:=0;
      FPVHiTP:=0;
      FPVLoTP:=0;
      FPVLLTP:=0;
      FHHDB:=adNone;
      FHiDB:=adNone;
      FLoDB:=adNone;
      FLLDB:=adNone;
      FBadDB:=adNone;
      FPtDesc:=Body.PtDesc;
      ErrorMess:='Нет выбора селектора';
      FEUDesc:='';
      SelEntity:=nil;
      Raw:=0;
      if GetAlarmState(Alarm) then Caddy.RemoveAlarms(Self);
      if FLogged and not (asBadPV in AlarmStatus) then
        Caddy.AddAlarm(asBadPV,Self);
    end;
  end;
  if SelNum in [1..4] then Raw:=aAO[SelNum].Raw;
  UpdateRealTime;
end;

function TVirtAnaSel.LoadFromStream(Stream: TStream): integer;
begin
  Result:=SizeOf(Body);
  if (Stream.Size-Stream.Position) < Result then
  begin
    Result:=0;
    Exit;
  end;
  Stream.ReadBuffer(Body,Result);
  FPtName:=Body.PtName;
  FPtDesc:=Body.PtDesc;
  FActived:=Body.Actived;
  FLogged:=Body.Logged;
  FAsked:=Body.Asked;
  FFetchTime:=Body.FetchTime;
  FSourceAnaVar1:=Body.SourceAnaVar1;
  FSourceAnaVar2:=Body.SourceAnaVar2;
  FSourceAnaVar3:=Body.SourceAnaVar3;
  FSourceAnaVar4:=Body.SourceAnaVar4;
  FSourceDigVar1:=Body.SourceDigVar1;
  FSourceDigVar2:=Body.SourceDigVar2;
  FSourceDigVar3:=Body.SourceDigVar3;
  FSourceDigVar4:=Body.SourceDigVar4;
end;

procedure TVirtAnaSel.Notify(Kind: TEntityNotify; E: TEntity);
begin
  inherited;
  case Kind of
    enRename: begin
                if E = FAnaVar1 then FSourceAnaVar1:=E.PtName;
                if E = FAnaVar2 then FSourceAnaVar2:=E.PtName;
                if E = FAnaVar3 then FSourceAnaVar3:=E.PtName;
                if E = FAnaVar4 then FSourceAnaVar4:=E.PtName;
                if E = FDigVar1 then FSourceDigVar1:=E.PtName;
                if E = FDigVar2 then FSourceDigVar2:=E.PtName;
                if E = FDigVar3 then FSourceDigVar3:=E.PtName;
                if E = FDigVar4 then FSourceDigVar4:=E.PtName;
              end;
    enDelete: begin
                if E = FAnaVar1 then AnaVar1:=nil;
                if E = FAnaVar2 then AnaVar2:=nil;
                if E = FAnaVar3 then AnaVar3:=nil;
                if E = FAnaVar4 then AnaVar4:=nil;
                if E = FDigVar1 then DigVar1:=nil;
                if E = FDigVar2 then DigVar2:=nil;
                if E = FDigVar3 then DigVar3:=nil;
                if E = FDigVar4 then DigVar4:=nil;
              end;
  end;
end;

function TVirtAnaSel.PropsCount: integer;
begin
  Result:=13;
end;

class function TVirtAnaSel.PropsID(Index: integer): string;
begin
  case Index of
    0: Result:='PtName';
    1: Result:='PtDesc';
    2: Result:='Active';
    3: Result:='FetchTime';
    4: Result:='Alarm';
    5: Result:='Select1';
    6: Result:='Source1';
    7: Result:='Select2';
    8: Result:='Source2';
    9: Result:='Select3';
   10: Result:='Source3';
   11: Result:='Select4';
   12: Result:='Source4';
  else
    Result:='Unknown';
  end
end;

class function TVirtAnaSel.PropsName(Index: integer): string;
begin
  case Index of
    0: Result:='Шифр параметра';
    1: Result:='Десктриптор';
    2: Result:='Опрос';
    3: Result:='Время опроса';
    4: Result:='Сигнализация';
    5: Result:='Вход выбора 1';
    6: Result:='Источник значения 1';
    7: Result:='Вход выбора 2';
    8: Result:='Источник значения 2';
    9: Result:='Вход выбора 3';
   10: Result:='Источник значения 3';
   11: Result:='Вход выбора 4';
   12: Result:='Источник значения 4';
  else
    Result:='';
  end
end;

function TVirtAnaSel.PropsValue(Index: integer): string;
begin
  case Index of
    0: Result:=FPtName;
    1: Result:=FPtDesc;
    2: Result:=IfThen(FActived,'Да','Нет');
    3: Result:=Format('%d сек',[FFetchTime]);
    4: Result:=IfThen(FLogged,'Да','Нет');
    5: Result:=IfThen(Assigned(FDigVar1),FSourceDigVar1,'');
    6: Result:=IfThen(Assigned(FAnaVar1),FSourceAnaVar1,'');
    7: Result:=IfThen(Assigned(FDigVar2),FSourceDigVar2,'');
    8: Result:=IfThen(Assigned(FAnaVar2),FSourceAnaVar2,'');
    9: Result:=IfThen(Assigned(FDigVar3),FSourceDigVar3,'');
   10: Result:=IfThen(Assigned(FAnaVar3),FSourceAnaVar3,'');
   11: Result:=IfThen(Assigned(FDigVar4),FSourceDigVar4,'');
   12: Result:=IfThen(Assigned(FAnaVar4),FSourceAnaVar4,'');
  else
    Result:='';
  end
end;

procedure TVirtAnaSel.SaveToStream(Stream: TStream);
begin
  Body.PtName:=PtName;
  Body.PtDesc:=PtDesc;
  Body.Actived:=Actived;
  Body.Logged:=Logged;
  Body.Asked:=Asked;
  Body.FetchTime:=FetchTime;
  Body.SourceAnaVar1:=SourceAnaVar1;
  Body.SourceAnaVar2:=SourceAnaVar2;
  Body.SourceAnaVar3:=SourceAnaVar3;
  Body.SourceAnaVar4:=SourceAnaVar4;
  Body.SourceDigVar1:=SourceDigVar1;
  Body.SourceDigVar2:=SourceDigVar2;
  Body.SourceDigVar3:=SourceDigVar3;
  Body.SourceDigVar4:=SourceDigVar4;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

procedure TVirtAnaSel.SaveToText(List: TStringList);
begin
  List.Append('[' + PtName + ']');
  List.Append('Plugin=Virtual');
  List.Append('PtType=AS');
  List.Append('PtKind=1');
  List.Append('PtName=' + PtName);
  List.Append('PtDesc=' + PtDesc);
  List.Append('Actived=' + IfThen(Actived, 'True', 'False'));
  List.Append('Logged=' + IfThen(Logged, 'True', 'False'));
  List.Append('Asked=' + IfThen(Asked, 'True', 'False'));
  List.Append('FetchTime=' + IntToStr(FetchTime));
  List.Append('SourceAnaVar1=' + SourceAnaVar1);
  List.Append('SourceAnaVar2=' + SourceAnaVar2);
  List.Append('SourceAnaVar3=' + SourceAnaVar3);
  List.Append('SourceAnaVar4=' + SourceAnaVar4);
  List.Append('SourceDigVar1=' + SourceDigVar1);
  List.Append('SourceDigVar2=' + SourceDigVar2);
  List.Append('SourceDigVar3=' + SourceDigVar3);
  List.Append('SourceDigVar4=' + SourceDigVar4);
end;

procedure TVirtAnaSel.SetAnaVar1(const Value: TCustomAnaOut);
var S: string;
begin
  FAnaVar1:=Value;
  S:=FSourceAnaVar1;
  if Assigned(FAnaVar1) then
    FSourceAnaVar1:=Value.PtName
  else
    FSourceAnaVar1:='';
  if S <> FSourceAnaVar1 then
  begin
    Caddy.AddChange(PtName,'Ана.пер.1',S,FSourceAnaVar1,PtDesc,Caddy.Autor);
    Caddy.Changed:=True;
  end;
end;

procedure TVirtAnaSel.SetAnaVar2(const Value: TCustomAnaOut);
var S: string;
begin
  FAnaVar2:=Value;
  S:=FSourceAnaVar2;
  if Assigned(FAnaVar2) then
    FSourceAnaVar2:=Value.PtName
  else
    FSourceAnaVar2:='';
  if S <> FSourceAnaVar2 then
  begin
    Caddy.AddChange(PtName,'Ана.пер.2',S,FSourceAnaVar2,PtDesc,Caddy.Autor);
    Caddy.Changed:=True;
  end;
end;

procedure TVirtAnaSel.SetAnaVar3(const Value: TCustomAnaOut);
var S: string;
begin
  FAnaVar3:=Value;
  S:=FSourceAnaVar3;
  if Assigned(FAnaVar3) then
    FSourceAnaVar3:=Value.PtName
  else
    FSourceAnaVar3:='';
  if S <> FSourceAnaVar3 then
  begin
    Caddy.AddChange(PtName,'Ана.пер.3',S,FSourceAnaVar3,PtDesc,Caddy.Autor);
    Caddy.Changed:=True;
  end;
end;

procedure TVirtAnaSel.SetAnaVar4(const Value: TCustomAnaOut);
var S: string;
begin
  FAnaVar4:=Value;
  S:=FSourceAnaVar4;
  if Assigned(FAnaVar4) then
    FSourceAnaVar4:=Value.PtName
  else
    FSourceAnaVar4:='';
  if S <> FSourceAnaVar4 then
  begin
    Caddy.AddChange(PtName,'Ана.пер.4',S,FSourceAnaVar4,PtDesc,Caddy.Autor);
    Caddy.Changed:=True;
  end;
end;

procedure TVirtAnaSel.SetDigVar1(const Value: TCustomDigOut);
var S: string;
begin
  FDigVar1 := Value;
  S:=FSourceDigVar1;
  if Assigned(FDigVar1) then
    FSourceDigVar1:=Value.PtName
  else
    FSourceDigVar1:='';
  if S <> FSourceDigVar1 then
  begin
    Caddy.AddChange(PtName,'Циф.пер.1',S,FSourceDigVar1,PtDesc,Caddy.Autor);
    Caddy.Changed:=True;
  end;
end;

procedure TVirtAnaSel.SetDigVar2(const Value: TCustomDigOut);
var S: string;
begin
  FDigVar2:=Value;
  S:=FSourceDigVar2;
  if Assigned(FDigVar2) then
    FSourceDigVar2:=Value.PtName
  else
    FSourceDigVar2:='';
  if S <> FSourceDigVar2 then
  begin
    Caddy.AddChange(PtName,'Циф.пер.2',S,FSourceDigVar2,PtDesc,Caddy.Autor);
    Caddy.Changed:=True;
  end;
end;

procedure TVirtAnaSel.SetDigVar3(const Value: TCustomDigOut);
var S: string;
begin
  FDigVar3:=Value;
  S:=FSourceDigVar3;
  if Assigned(FDigVar3) then
    FSourceDigVar3:=Value.PtName
  else
    FSourceDigVar3:='';
  if S <> FSourceDigVar3 then
  begin
    Caddy.AddChange(PtName,'Циф.пер.3',S,FSourceDigVar3,PtDesc,Caddy.Autor);
    Caddy.Changed:=True;
  end;
end;

procedure TVirtAnaSel.SetDigVar4(const Value: TCustomDigOut);
var S: string;
begin
  FDigVar4 := Value;
  S:=FSourceDigVar4;
  if Assigned(FDigVar4) then
    FSourceDigVar4:=Value.PtName
  else
    FSourceDigVar4:='';
  if S <> FSourceDigVar4 then
  begin
    Caddy.AddChange(PtName,'Циф.пер.4',S,FSourceDigVar4,PtDesc,Caddy.Autor);
    Caddy.Changed:=True;
  end;
end;

procedure TVirtAnaSel.ShowParentPassport(const MonitorNum: integer);
begin
  if Assigned(SelEntity) and Assigned(Caddy.OnShowPassport) then
    Caddy.OnShowPassport(SelEntity, MonitorNum);
end;

class function TVirtAnaSel.TypeCode: string;
begin
  Result:='AS';
end;

class function TVirtAnaSel.TypeColor: TColor;
begin
  Result:=$00FFFFCC;
end;

{ TVirtTimeCounter }

procedure TVirtTimeCounter.Assign(E: TEntity);
var T: TVirtTimeCounter;
begin
  inherited;
  T:=E as TVirtTimeCounter;
  FHHHourTP:=T.HHHourTP;
  FHiHourTP:=T.HiHourTP;
  FMaxHourValue:=T.MaxHourValue;
  FPVFormat:=T.PVFormat;
end;

procedure TVirtTimeCounter.ConnectLinks;
var E: TEntity;
begin
  inherited;
  E:=Caddy.Find(FSourceDigWork);
  if Assigned(E) then
    DigWork:=E as TCustomDigOut else DigWork:=nil;
end;

constructor TVirtTimeCounter.Create;
begin
  inherited;
  FIsVirtual:=True;
  FIsComposit:=True;
  FPVFormat:=tfMiddle;
  FMaxHourValue:=100000;
  FHHHourTP:=95000;
  FHiHourTP:=90000;
end;

class function TVirtTimeCounter.EntityType: string;
begin
  Result:='Счётчик часов наработки';
end;

procedure TVirtTimeCounter.Fetch(const Data: string);
var KindStatus: TKindStatus;
    S: Single;
    R: Double;
//    LastAlarm: TAlarmState;
//    AlarmFound, HasAlarm, HasConfirm, HasNoLink: boolean;
//    DFColor1,DFColor2: TColor;
begin
  if Length(Data) = SizeOf(S) then
  begin
    FLastPV:=FActualTime;
    MoveMemory(@S,@Data[1],SizeOf(S));
    FActualTime:=S*OneHour;
  end
  else
  if Length(Data) = SizeOf(R)*2 then
  begin
    MoveMemory(@R,@Data[1],SizeOf(R));
    FActualTime:=R;
    MoveMemory(@R,@Data[9],SizeOf(R));
    FLastPV:=R;
  end
  else
  begin
    if Assigned(FDigWork) then
    begin
      Working:=FDigWork.PV;
      if Working and (Now > FOldTime) and
         ((Now-FOldTime) < (OneMinute*10)) then
        FActualTime:=FActualTime+(Now-FOldTime);
      if FDigWork.Actived then
        ErrorMess:=FDigWork.ErrorMess
      else
        ErrorMess:='Источник сигнала неактивен';
      FOldTime:=Now;
    end
    else
      ErrorMess:='Плохой источник сигнала';
  end;
  FPV:=FActualTime;
  if FLogged then
  begin
    if (FHIHourTP > 0) and (HoursBetween(FActualTime,0.0) >= FHIHourTP) then
    begin
      if not (asHi in AlarmStatus) then Caddy.AddAlarm(asHi,Self);
    end
    else
    begin
      if asHi in AlarmStatus then Caddy.RemoveAlarm(asHi,Self);
    end;
    if (FHHHourTP > 0) and (HoursBetween(FActualTime,0.0) >= FHHHourTP) then
    begin
      if not (asHH in AlarmStatus) then Caddy.AddAlarm(asHH,Self);
    end
    else
    begin
      if asHH in AlarmStatus then Caddy.RemoveAlarm(asHH,Self);
    end;
  end;
  UpdateRealTime;
  KindStatus.AlarmStatus:=AlarmStatus;
  KindStatus.ConfirmStatus:=ConfirmStatus;
  KindStatus.LostAlarmStatus:=LostAlarmStatus;
  Caddy.AddRealValue(PtName+'.PV',FPV,PtText,KindStatus);
  Caddy.AddRealValue(PtName+'.RAW',FActualTime,Format('%g',[FActualTime]),
                     KindStatus);
  Caddy.AddRealValue(PtName+'.LASTPV',FLastPV,LastPVText,KindStatus);
end;

function TVirtTimeCounter.GetTextValue: string;
var hh,nn,ss,ms: Word;
begin
  DecodeTime(FActualTime,hh,nn,ss,ms);
  case FPVFormat of
    tfMiddle: Result:=Format('%d:%2.2d',[HoursBetween(FActualTime,0.0),nn]);
    tfLong: Result:=Format('%d:%2.2d:%2.2d',[HoursBetween(FActualTime,0.0),nn,ss]);
  else
    Result:=Format('%d',[HoursBetween(FActualTime,0.0)]);
  end;
end;

function TVirtTimeCounter.GetLastPVText: string;
var hh,nn,ss,ms: Word;
begin
  DecodeTime(FLastPV,hh,nn,ss,ms);
  case FPVFormat of
    tfMiddle: Result:=Format('%d:%2.2d',[HoursBetween(FLastPV,0.0),nn]);
    tfLong: Result:=Format('%d:%2.2d:%2.2d',[HoursBetween(FLastPV,0.0),nn,ss]);
  else
    Result:=Format('%d',[HoursBetween(FLastPV,0.0)]);
  end;
end;

function TVirtTimeCounter.LoadFromStream(Stream: TStream): integer;
begin
  Result:=SizeOf(Body);
  if (Stream.Size-Stream.Position) < Result then
  begin
    Result:=0;
    Exit;
  end;
  Stream.ReadBuffer(Body,Result);
  FPtName:=Body.PtName;
  FPtDesc:=Body.PtDesc;
  FActived:=Body.Actived;
  FLogged:=Body.Logged;
  FAsked:=Body.Asked;
  FFetchTime:=Body.FetchTime;
  FHHHourTP:=Body.HHHourTP;
  FHiHourTP:=Body.HiHourTP;
  FMaxHourValue:=Body.MaxHourValue;
  FPVFormat:=Body.PVFormat;
  FPVHHTP:=FHHHourTP;
  FPVHiTP:=FHiHourTP;
  FPVEUHi:=FMaxHourValue;
  FEUDesc:=ATimtoStr[FPVFormat];
  FSourceDigWork:=Body.SourceDigWork;
end;

procedure TVirtTimeCounter.Notify(Kind: TEntityNotify; E: TEntity);
begin
  inherited;
  case Kind of
    enRename: begin
                if E = FDigWork then FSourceDigWork:=E.PtName;
              end;
    enDelete: begin
                if E = FDigWork then DigWork:=nil;
              end;
  end;
end;

procedure TVirtTimeCounter.Reset;
begin
  Caddy.AddChange(PtName,'Сброс',PtText,'0:00',PtDesc,Caddy.Autor);
  Caddy.Changed:=True;
  FLastPV:=ActualTime;
  ActualTime:=0.0;
  OldTime:=Now;
end;

procedure TVirtTimeCounter.SaveToStream(Stream: TStream);
begin
  Body.PtName:=PtName;
  Body.PtDesc:=PtDesc;
  Body.Actived:=Actived;
  Body.Logged:=Logged;
  Body.Asked:=Asked;
  Body.FetchTime:=FetchTime;
  Body.HHHourTP:=HHHourTP;
  Body.HiHourTP:=HiHourTP;
  Body.MaxHourValue:=MaxHourValue;
  Body.PVFormat:=PVFormat;
  Body.SourceDigWork:=SourceDigWork;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

procedure TVirtTimeCounter.SaveToText(List: TStringList);
begin
  List.Append('[' + PtName + ']');
  List.Append('Plugin=Virtual');
  List.Append('PtType=TC');
  List.Append('PtKind=1');
  List.Append('PtName=' + PtName);
  List.Append('PtDesc=' + PtDesc);
  List.Append('Actived=' + IfThen(Actived, 'True', 'False'));
  List.Append('Logged=' + IfThen(Logged, 'True', 'False'));
  List.Append('Asked=' + IfThen(Asked, 'True', 'False'));
  List.Append('FetchTime=' + IntToStr(FetchTime));
  List.Append(Format('HHHourTP=%d', [HHHourTP]));
  List.Append(Format('HIHourTP=%d', [HiHourTP]));
  List.Append(Format('MaxHourValue=%d', [MaxHourValue]));
  List.Append('PVFormat=' + ATimtoStr[PVFormat]);
  List.Append('SourceDigWork=' + SourceDigWork);
end;

procedure TVirtTimeCounter.SetDigWork(const Value: TCustomDigOut);
var S: string;
begin
  FDigWork:=Value;
  S:=FSourceDigWork;
  if Assigned(FDigWork) then
    FSourceDigWork:=Value.PtName
  else
    FSourceDigWork:='';
  if S <> FSourceDigWork then
  begin
    Caddy.AddChange(PtName,'Сост.РАБОТА',S,FSourceDigWork,PtDesc,Caddy.Autor);
    Caddy.Changed:=True;
  end;
end;

procedure TVirtTimeCounter.SetHHHourTP(const Value: Integer);
begin
  if FHHHourTP <> Value then
  begin
    Caddy.AddChange(PtName,'Авар.время',
                 IntToStr(FHHHourTP),IntToStr(Value),PtDesc,Caddy.Autor);
    Caddy.Changed:=True;
    FHHHourTP:=Value;
    FPVHHTP:=FHHHourTP;
  end;
end;

procedure TVirtTimeCounter.SetHiHourTP(const Value: Integer);
begin
  if FHiHourTP <> Value then
  begin
    Caddy.AddChange(PtName,'Предавар.время',
                 IntToStr(FHiHourTP),IntToStr(Value),PtDesc,Caddy.Autor);
    Caddy.Changed:=True;
    FHiHourTP:=Value;
    FPVHiTP:=FHiHourTP;
  end;
end;

procedure TVirtTimeCounter.SetMaxHourValue(const Value: Integer);
begin
  if FMaxHourValue <> Value then
  begin
    Caddy.AddChange(PtName,'Макс.время',
                 IntToStr(FMaxHourValue),IntToStr(Value),PtDesc,Caddy.Autor);
    Caddy.Changed:=True;
    FMaxHourValue:=Value;
    FPVEUHi:=FMaxHourValue;
  end;
end;

procedure TVirtTimeCounter.SetParam(ParamName: string;
  Item: TCashRealBaseItem);
begin
  if (ParamName = 'RAW') or (ParamName = 'PV') then ActualTime:=Item.Value;
  if ParamName = 'LASTPV' then FLastPV:=Item.Value;
end;

procedure TVirtTimeCounter.SetPVFormat(const Value: TTimFormat);
begin
  if FPVFormat <> Value then
  begin
    Caddy.AddChange(PtName,'Формат времени',
                  ATimtoStr[FPVFormat],ATimtoStr[Value],PtDesc,Caddy.Autor);
    Caddy.Changed:=True;
    FPVFormat:=Value;
    FEUDesc:=ATimtoStr[FPVFormat];
  end;
end;

procedure TVirtTimeCounter.SetWorking(const Value: Boolean);
begin
  if FWorking <> Value then
  begin
    FWorking:=Value;
    if FWorking then FOldTime:=Now;
  end;
end;

class function TVirtTimeCounter.TypeCode: string;
begin
  Result:='TC';
end;

class function TVirtTimeCounter.TypeColor: TColor;
begin
  Result:=$00FFFFCC;
end;

function TVirtTimeCounter.GetFetchData: string;
begin
  SetLength(Result,SizeOf(FActualTime)*2);
  MoveMemory(@Result[1],@FActualTime,SizeOf(FActualTime));
  MoveMemory(@Result[9],@FLastPV,SizeOf(FLastPV));
end;

{ TVirtFlowCounter }

procedure TVirtFAGroup.Assign(E: TEntity);
var T: TVirtFAGroup;
begin
  inherited;
  T:=E as TVirtFAGroup;
  FInvDigWork:=T.InvDigWork;
  FPeriodKind:=T.PeriodKind;
  FBaseKind:=T.BaseKind;
  FCalcKind:=T.CalcKind;
  FShiftHour:=T.ShiftHour;
  FCutOff:=T.CutOff;
  FReset:=T.Reset;
end;

procedure TVirtFAGroup.ConnectLinks;
var E: TEntity;
begin
  inherited;
  E:=Caddy.Find(FSourceDigWork);
  if Assigned(E) then
    DigWork:=E as TCustomDigOut else DigWork:=nil;
  E:=Caddy.Find(FSourceAnaWork);
  if Assigned(E) then
    AnaWork:=E as TCustomAnaOut else AnaWork:=nil;
end;

constructor TVirtFAGroup.Create;
var i: integer;
begin
  inherited;
  FIsVirtual:=True;
  FIsComposit:=True;
  FPeriodKind:=pkCalendar;
  FBaseKind:=bkHour;
  for i:=0 to 9 do EntityChilds[i]:=nil;
end;

class function TVirtFAGroup.EntityType: string;
begin
  Result:='Аккумулятор расхода';
end;

procedure TVirtFAGroup.Fetch(const Data: string);
var RV, Last, AddValue: Double; Flag: Boolean; CalcTime,NowTime: TDateTime;
    KindStatus: TKindStatus; i,j: integer; W,Who: string; E: TEntity;
  procedure ResetValues(si,ei: integer);
  var k: integer;
  begin
    k:=si;
    while k < ei do
    begin
      if Assigned(EntityChilds[k]) and EntityChilds[k].Actived then
      begin
        Last := EntityChilds[k].Raw;
        EntityChilds[k].Raw:=FReset;
        if Assigned(EntityChilds[k+1]) and EntityChilds[k+1].Actived then
          EntityChilds[k+1].Raw:=Last;
        Caddy.AddChange(EntityChilds[k].PtName,'Сброс',
                        Format('%.3f',[Last]),
                        Format('%.3f',[FReset]),PtDesc,Who);
      end;
      Inc(k,2);
    end;
  end;
begin
  if Length(Data) = SizeOf(Raw)*10 then
  begin
    W:=Data;
    for i:=0 to 9 do
    begin
      E:=EntityChilds[i];
      if Assigned(E) and E.Actived then
      begin
        E.Fetch(Copy(W,1,SizeOf(Raw)));
        E.RealTime:=Self.RealTime;
      end;
      Delete(W,1,SizeOf(Raw));
    end;
    UpdateRealTime;
    Exit;
  end;
  if FirstCalc then
  begin
    FirstCalc:=False;
    if Assigned(FDigWork) then
      LastExtValue:=FDigWork.PV;
  end;
  KindStatus.AlarmStatus:=AlarmStatus;
  KindStatus.ConfirmStatus:=ConfirmStatus;
  KindStatus.LostAlarmStatus:=LostAlarmStatus;
  if Assigned(FAnaWork) then
  begin
    if (FPeriodKind = pkExternal) and
       Assigned(FDigWork) and FDigWork.IsVirtual then
      Who:=Caddy.Autor
    else
      Who:='Автономно';
    if (asShortBadPV in FAnaWork.AlarmStatus) or
       (asOpenBadPV in FAnaWork.AlarmStatus) or
       (asNoLink in FAnaWork.AlarmStatus) then
    begin
      case FCalcKind of
        ckZero: RV:=0.0;
    ckLastGood: RV:=LastGood;
      else
        begin {ckBadPV}
          OldTime:=Now;
          ErrorMess:='Источник сигнала содержит плохое значение';
          if not (asBadPV in AlarmStatus) then Caddy.AddAlarm(asBadPV,Self);
          Exit;
        end;
      end;
    end
    else
      RV:=FAnaWork.PV;
    if asBadPV in AlarmStatus then Caddy.RemoveAlarm(asBadPV,Self);
    if (RV < 0.0) or (RV <= CutOff) then RV:=0.0;
    CalcTime:=ShiftHour*OneHour;
    NowTime := Now;
    if (NowTime > OldTime) and (NowTime - OldTime < OneMinute*10) then
    begin
      case FPeriodKind of
    pkCalendar:
        begin
          if YearOf(NowTime-CalcTime) >
             YearOf(OldTime-CalcTime) then ResetValues(2,10)
          else
          if MonthOfTheYear(NowTime-CalcTime) >
             MonthOfTheYear(OldTime-CalcTime) then ResetValues(2,8)
          else
          if DayOfTheYear(NowTime-CalcTime) >
             DayOfTheYear(OldTime-CalcTime) then ResetValues(2,6)
          else
          if HourOfTheYear(NowTime) >
             HourOfTheYear(OldTime) then ResetValues(2,4);
        end;
    pkExternal:
        if Assigned(FDigWork) then
        begin
          if FDigWork.Actived then
          begin
            if not (asNoLink in FDigWork.AlarmStatus) then
            begin
              if FInvDigWork then
                Flag:=not FDigWork.PV
              else
                Flag:=FDigWork.PV;
              if not LastExtValue and Flag then ResetValues(0,2);
              LastExtValue:=Flag;
              if not LastExtValue then RV:=0.0;
            end
            else
              RV:=0.0;
          end
          else
            ErrorMess:='Источник управления неактивен';
        end
        else
          ErrorMess:='Источник управления не задан';
      end; {case}
//---------------------------------------------------
      if FPeriodKind = pkCalendar then
      begin
        i:=2;
        j:=10;
      end
      else
      begin
        i:=0;
        j:=2;
      end;
      case FBaseKind of
        bkSec: AddValue:=RV*((NowTime-OldTime)/OneSecond);
        bkMin: AddValue:=RV*((NowTime-OldTime)/OneMinute);
      else
        AddValue:=RV*((NowTime-OldTime)/OneHour);
      end;
      while i < j do
      begin
        if Assigned(EntityChilds[i]) and EntityChilds[i].Actived then
        begin
          EntityChilds[i].Raw := EntityChilds[i].Raw + AddValue;
          if Assigned(EntityChilds[i+1]) and EntityChilds[i+1].Actived then
            EntityChilds[i+1].Raw:=EntityChilds[i+1].Raw;
        end;
        Inc(i,2);
      end;
    end; { if }
    LastGood:=RV;
    OldTime:=NowTime;
    if FAnaWork.Actived then
      ErrorMess:=FAnaWork.ErrorMess
    else
      ErrorMess:='Источник сигнала неактивен';
  end
  else
    ErrorMess:='Плохой источник сигнала';
  UpdateRealTime;
end;

function TVirtFAGroup.GetFetchData: string;
var R: Single; i: integer;
begin
  SetLength(Result,SizeOf(R)*10);
  for i:=0 to 9 do
  begin
    if Assigned(EntityChilds[i]) and EntityChilds[i].Actived then
      R:=EntityChilds[i].Raw
    else
      R:=0;
    MoveMemory(@Result[1+i*SizeOf(R)],@R,SizeOf(R));
  end
end;

function TVirtFAGroup.GetMaxChildCount: integer;
begin
  Result:=9;
end;

function TVirtFAGroup.LoadFromStream(Stream: TStream): integer;
var i: integer;
begin
  Result:=SizeOf(Body);
  if (Stream.Size-Stream.Position) < Result then
  begin
    Result:=0;
    Exit;
  end;
  Stream.ReadBuffer(Body,Result);
  FPtName:=Body.PtName;
  FPtDesc:=Body.PtDesc;
  FActived:=Body.Actived;
  FFetchTime:=Body.FetchTime;
  FSourceAnaWork:=Body.SourceAnaWork;
  FSourceDigWork:=Body.SourceDigWork;
  FInvDigWork:=Body.InvDigWork;
  FPeriodKind:=Body.PeriodKind;
  FBaseKind:=Body.BaseKind;
  FCalcKind:=Body.CalcKind;
  FShiftHour:=Body.ShiftHour;
  FCutOff:=Body.CutOff;
  FReset:=Body.Reset;
  FChilds.Clear;
  for i:=0 to 9 do FChilds.AddObject(Body.Childs[i],nil);
end;

procedure TVirtFAGroup.Notify(Kind: TEntityNotify; E: TEntity);
begin
  inherited;
  case Kind of
    enRename: begin
                if E = FAnaWork then FSourceAnaWork:=E.PtName;
                if E = FDigWork then FSourceDigWork:=E.PtName;
              end;
    enDelete: begin
                if E = FAnaWork then AnaWork:=nil;
                if E = FDigWork then DigWork:=nil;
              end;
  end;
end;

function TVirtFAGroup.PropsCount: integer;
begin
  Result:=23;
end;

class function TVirtFAGroup.PropsID(Index: integer): string;
begin
  case Index of
    0: Result:='PtName';
    1: Result:='PtDesc';
    2: Result:='Active';
    3: Result:='FetchTime';
    4: Result:='SourceAnaWork';
    5: Result:='SourceDigWork';
    6: Result:='InvDigWork';
    7: Result:='PeriodKind';
    8: Result:='ShiftHour';
    9: Result:='BaseKind';
   10: Result:='CalcKind';
   11: Result:='ResetValue';
   12: Result:='CutOffValue';
   13..22: Result:=Format('OutputValue%d',[Index-13]);
  else
    Result:='Unknown';
  end
end;

class function TVirtFAGroup.PropsName(Index: integer): string;
begin
  case Index of
    0: Result:='Шифр параметра';
    1: Result:='Десктриптор';
    2: Result:='Опрос';
    3: Result:='Время опроса';
    4: Result:='Источник расхода';
    5: Result:='Внешнее управление';
    6: Result:='Инверсия управления';
    7: Result:='Период накопления';
    8: Result:='Расчетное время';
    9: Result:='База времени счета';
   10: Result:='Тип счета при ошибке';
   11: Result:='Значение для сброса';
   12: Result:='Значение отсечки';
   13: Result:='Текущее значение';
   14: Result:='Предыдущее значение';
   15: Result:='С начала часа';
   16: Result:='За предыдущий час';
   17: Result:='С начала суток';
   18: Result:='За предыдущие сутки';
   19: Result:='С начала месяца';
   20: Result:='За предыдущий месяц';
   21: Result:='С начала года';
   22: Result:='За предыдущий год';
  else
    Result:='';
  end
end;

function TVirtFAGroup.PropsValue(Index: integer): string;
begin
  case Index of
    0: Result:=FPtName;
    1: Result:=FPtDesc;
    2: Result:=IfThen(FActived,'Да','Нет');
    3: Result:=Format('%d сек',[FFetchTime]);
    4: Result:=IfThen(Assigned(FAnaWork),FSourceAnaWork,'');
    5: Result:=IfThen(Assigned(FDigWork),FSourceDigWork,'');
    6: Result:=IfThen(FInvDigWork,'Да','Нет');
    7: Result:=APeriodKind[FPeriodKind];
    8: Result:=IntToStr(FShiftHour);
    9: Result:=ABaseKind[FBaseKind];
   10: Result:=ACalcKind[FCalcKind];
   11: Result:=Format('%g',[FReset]);
   12: Result:=Format('%g',[FCutOff]);
   13..22: Result:=IfThen(Assigned(EntityChilds[Index-13]),Childs[Index-13],'');
  else
    Result:='';
  end
end;

procedure TVirtFAGroup.ResetTime(NewTime: TDateTime);
begin
  OldTime:=NewTime;
end;

procedure TVirtFAGroup.SaveToStream(Stream: TStream);
var i: integer;
begin
  Body.PtName:=PtName;
  Body.PtDesc:=PtDesc;
  Body.Actived:=Actived;
  Body.FetchTime:=FetchTime;
  Body.SourceAnaWork:=FSourceAnaWork;
  Body.SourceDigWork:=FSourceDigWork;
  Body.InvDigWork:=FInvDigWork;
  Body.PeriodKind:=FPeriodKind;
  Body.BaseKind:=FBaseKind;
  Body.CalcKind:=FCalcKind;
  Body.ShiftHour:=FShiftHour;
  Body.CutOff:=FCutOff;
  Body.Reset:=FReset;
  for i:=0 to 9 do Body.Childs[i]:='';
  for i:=0 to Count-1 do
  if i in [0..9] then
  begin
    if Assigned(EntityChilds[i]) then
      Body.Childs[i]:=EntityChilds[i].PtName;
  end;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

procedure TVirtFAGroup.SaveToText(List: TStringList);
var i: Integer;
begin
  List.Append('[' + PtName + ']');
  List.Append('Plugin=Virtual');
  List.Append('PtType=FA');
  List.Append('PtKind=3');
  List.Append('PtName=' + PtName);
  List.Append('PtDesc=' + PtDesc);
  List.Append('Actived=' + IfThen(Actived, 'True', 'False'));
  List.Append('FetchTime=' + IntToStr(FetchTime));
  List.Append('SourceAnaWork=' + SourceAnaWork);
  List.Append('SourceDigWork=' + SourceDigWork);
  List.Append('InvDigWork=' + IfThen(InvDigWork, 'True', 'False'));
  List.Append('PeriodKind=' + APeriodKind[PeriodKind]);
  List.Append('BaseKind=' + ABaseKind[BaseKind]);
  List.Append('CalcKind=' + ACalcKind[CalcKind]);
  List.Append('ShiftHour=' + IntToStr(FShiftHour));
  DecimalSeparator := '.';
  List.Append(Format('CutOff=%.3f',[CutOff]));
  List.Append(Format('Reset=%.3f',[Reset]));
  for i:=0 to 9 do
     List.Append(Format('Child%d=%s', [i + 1, Body.Childs[i]]));
end;

procedure TVirtFAGroup.SetAnaWork(const Value: TCustomAnaOut);
var S: string;
begin
  FAnaWork:=Value;
  S:=FSourceAnaWork;
  if Assigned(FAnaWork) then
    FSourceAnaWork:=Value.PtName
  else
    FSourceAnaWork:='';
  if S <> FSourceAnaWork then
  begin
    Caddy.AddChange(PtName,'Знач.счета',S,FSourceAnaWork,PtDesc,Caddy.Autor);
    Caddy.Changed:=True;
  end;
end;

procedure TVirtFAGroup.SetBaseKind(const Value: TBaseKind);
begin
  if FBaseKind <> Value then
  begin
    Caddy.AddChange(PtName,'База счета',
                 ABaseKind[FBaseKind],ABaseKind[Value],PtDesc,Caddy.Autor);
    Caddy.Changed:=True;
    FBaseKind:=Value;
  end;
end;

procedure TVirtFAGroup.SetCalcKind(const Value: TCalcKind);
begin
  if FCalcKind <> Value then
  begin
    Caddy.AddChange(PtName,'Тип счета',
                 ACalcKind[FCalcKind],ACalcKind[Value],PtDesc,Caddy.Autor);
    Caddy.Changed:=True;
    FCalcKind:=Value;
  end;
end;

procedure TVirtFAGroup.SetCutOff(const Value: Double);
begin
  if FCutOff <> Value then
  begin
    Caddy.AddChange(PtName,'Отсечка',
               Format('%.3f',[FCutOff]),Format('%.3f',[Value]),PtDesc,Caddy.Autor);
    Caddy.Changed:=True;
    FCutOff:=Value;
  end;
end;

procedure TVirtFAGroup.SetDigWork(const Value: TCustomDigOut);
var S: string;
begin
  FDigWork:=Value;
  S:=FSourceDigWork;
  if Assigned(FDigWork) then
    FSourceDigWork:=Value.PtName
  else
    FSourceDigWork:='';
  if S <> FSourceDigWork then
  begin
    Caddy.AddChange(PtName,'Сост.УПРАВЛ',S,FSourceDigWork,PtDesc,Caddy.Autor);
    Caddy.Changed:=True;
  end;
end;

procedure TVirtFAGroup.SetInvDigWork(const Value: boolean);
const ADig: array[Boolean] of string = ('Нет','Да');
begin
  if FInvDigWork <> Value then
  begin
    Caddy.AddChange(PtName,'Инв.упр',
             ADig[FInvDigWork],ADig[Value],PtDesc,Caddy.Autor);
    Caddy.Changed:=True;
    FInvDigWork:=Value;
  end;
end;

procedure TVirtFAGroup.SetPeriodKind(const Value: TPeriodKind);
begin
  if FPeriodKind <> Value then
  begin
    Caddy.AddChange(PtName,'Период накоп',
      APeriodKind[FPeriodKind],APeriodKind[Value],PtDesc,Caddy.Autor);
    Caddy.Changed:=True;
    FPeriodKind:=Value;
  end;
end;

procedure TVirtFAGroup.SetReset(const Value: Double);
var sFormat: string;
begin
  if FReset <> Value then
  begin
    sFormat:='%g';
    Caddy.AddChange(PtName,'Знач.сброса',
      Format(sFormat,[FReset]),Format(sFormat,[Value]),PtDesc,Caddy.Autor);
    Caddy.Changed:=True;
    FReset:=Value;
  end;
end;

procedure TVirtFAGroup.SetShiftHour(const Value: byte);
var sFormat: string;
begin
  if FShiftHour <> Value then
  begin
    sFormat:='%d';
    Caddy.AddChange(PtName,'Знач.сброса',
      Format(sFormat,[FShiftHour]),Format(sFormat,[Value]),PtDesc,Caddy.Autor);
    Caddy.Changed:=True;
    FShiftHour:=Value;
  end;
end;

class function TVirtFAGroup.TypeCode: string;
begin
  Result:='FA';
end;

class function TVirtFAGroup.TypeColor: TColor;
begin
  Result:=$00FFFFCC;
end;

function TVirtTimeCounter.Prepare: string;
begin
  SetLength(Result,SizeOf(CommandData));
  MoveMemory(@Result[1],@CommandData,SizeOf(CommandData));
end;

function TVirtTimeCounter.GetPtVal: string;
var hh,nn,ss,ms: Word;
begin
  DecodeTime(FActualTime,hh,nn,ss,ms);
  case FPVFormat of
    tfMiddle: Result:=Format('%d:%2.2d',[HoursBetween(FActualTime,0.0),nn]);
    tfLong: Result:=Format('%d:%2.2d:%2.2d',[HoursBetween(FActualTime,0.0),nn,ss]);
  else
    Result:=Format('%d',[HoursBetween(FActualTime,0.0)]);
  end;
end;

function TVirtTimeCounter.PropsCount: integer;
begin
  Result:=11;
end;

class function TVirtTimeCounter.PropsID(Index: integer): string;
begin
  case Index of
    0: Result:='PtName';
    1: Result:='PtDesc';
    2: Result:='Active';
    3: Result:='Alarm';
    4: Result:='Confirm';
    5: Result:='FetchTime';
    6: Result:='SourceDigWork';
    7: Result:='PVFormat';
    8: Result:='MaxHourValue';
    9: Result:='HHHourTP';
   10: Result:='HIHourTP';
  else
    Result:='Unknown';
  end
end;

class function TVirtTimeCounter.PropsName(Index: integer): string;
begin
  case Index of
    0: Result:='Шифр параметра';
    1: Result:='Десктриптор';
    2: Result:='Опрос';
    3: Result:='Сигнализация';
    4: Result:='Квитирование';
    5: Result:='Время опроса';
    6: Result:='Состояние "РАБОТА"';
    7: Result:='Формат времени наработки';
    8: Result:='Максимальное время';
    9: Result:='Аварийное время';
   10: Result:='Предаварийное время';
  else
    Result:='';
  end
end;

function TVirtTimeCounter.PropsValue(Index: integer): string;
begin
  case Index of
    0: Result:=FPtName;
    1: Result:=FPtDesc;
    2: Result:=IfThen(FActived,'Да','Нет');
    3: Result:=IfThen(FLogged,'Да','Нет');
    4: Result:=IfThen(FAsked,'Да','Нет');
    5: Result:=Format('%d сек',[FFetchTime]);
    6: Result:=IfThen(Assigned(FDigWork),FSourceDigWork,'');
    7: Result:=ATimtoStr[FPVFormat];
    8: Result:=IntToStr(FMaxHourValue);
    9: Result:=IntToStr(FHHHourTP);
   10: Result:=IntToStr(FHiHourTP);
  else
    Result:='';
  end
end;

{ TVirtEditForm }

procedure TVirtEditForm.AddBoolItem(Value: boolean);
var M: TMenuItem;
begin
  M:=TMenuItem.Create(Self);
  M.Caption:='Нет';
  M.Checked:=not Value;
  M.Tag:=0;
  M.OnClick:=ChangeBooleanClick;
  PopupMenu1.Items.Add(M);
  M:=TMenuItem.Create(Self);
  M.Caption:='Да';
  M.Checked:=Value;
  M.Tag:=1;
  M.OnClick:=ChangeBooleanClick;
  PopupMenu1.Items.Add(M);
end;

procedure TVirtEditForm.BaseFresh(var Mess: TMessage);
begin
  UpdateRealTime;
end;

procedure TVirtEditForm.ChangeBooleanClick(Sender: TObject);
var L: TListItem; M: TMenuItem; B: Boolean;
begin
  if not Assigned(E) then Exit;
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  B:=(M.Tag = 1);
  if Assigned(L) then
  begin
    if L.Caption = 'Опрос' then
    begin
      E.Actived:=B;
      L.SubItems[0]:=IfThen(E.Actived,'Да','Нет');
    end;
  end;
end;

procedure TVirtEditForm.ChangeFetchClick(Sender: TObject);
var L: TListItem; V: integer; M: TMenuItem;
begin
  if not Assigned(E) then Exit;
  M:=Sender as TMenuItem;
  L:=ListView1.Selected;
  if L <> nil then
  begin
    case M.Tag of
      0: begin
           V:=E.FetchTime;
           if InputIntegerDlg(L.Caption+' (в сек.)',V) then
           begin
             if V < 1 then V:=1;
             E.FetchTime:=V;
             L.SubItems[0]:=Format('%d сек',[E.FetchTime]);
           end;
         end;
    else
      begin
        E.FetchTime:=M.Tag;
        L.SubItems[0]:=Format('%d сек',[E.FetchTime]);
      end;
    end;
  end;
end;

procedure TVirtEditForm.ChangeTextClick(Sender: TObject);
var L: TListItem; S: string;
begin
  if not Assigned(E) then Exit;
  L:=ListView1.Selected;
  if Assigned(L) then
  begin
    if L.Caption = 'Дескриптор позиции' then
      S:=L.SubItems[0]
    else
      Exit;
    if InputStringDlg(L.Caption,S,50) then
    begin
      if L.Caption = 'Дескриптор позиции' then
      begin
        E.PtDesc:=S;
        L.SubItems[0]:=E.PtDesc;
      end;
    end;
  end;
end;

procedure TVirtEditForm.ConnectBaseEditor(var Mess: TMessage);
begin
  ConnectImageList(TImageList(Mess.WParam));
  ConnectEntity(TEntity(Mess.LParam));
end;

procedure TVirtEditForm.ConnectEntity(Entity: TEntity);
begin
  E:=Entity;
  if not Assigned(E) then Exit;
  with ListView1 do
  begin
    Items.BeginUpdate;
    try
      Items.Clear;
      with Items.Add do
      begin
        ImageIndex:=EntityClassIndex(E.ClassType)+3;
        Caption:='Шифр позиции';
        SubItems.Add(E.PtName+' - '+E.EntityType);
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Дескриптор позиции';
        SubItems.Add(E.PtDesc);
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Опрос';
        SubItems.Add(IfThen(E.Actived,'Да','Нет'));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Время опроса';
        SubItems.Add(Format('%d сек',[E.FetchTime]));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Фактически';
        if E.RealTime > 0 then
          SubItems.Add(Format('%.3f',[E.RealTime/1000])+' сек')
        else
          SubItems.Add('Нет опроса');
      end;
    finally
      Items.EndUpdate;
    end;
  end;
end;

procedure TVirtEditForm.ConnectImageList(ImageList: TImageList);
begin
  ListView1.SmallImages:=ImageList;
end;

constructor TVirtEditForm.Create(AOwner: TComponent);
begin
  inherited;
  E:=nil;
  PopupMenu1:=TPopupMenu.Create(Self);
  PopupMenu1.OnPopup:=PopupMenu1Popup;
  ListView1:=TListView.Create(Self);
  with ListView1 do
  begin
    Parent:=Self;
    Align:=alClient;
    with Columns.Add do
    begin
      Caption:='Свойство';
      Width:=250;
    end;
    with Columns.Add do
    begin
      Caption:='Значение';
      Width:=432;
      AutoSize:=True;
    end;
    ViewStyle:=vsReport;
    ColumnClick:=False;
    ReadOnly:=True;
    RowSelect:=True;
    PopupMenu:=PopupMenu1;
    OnDblClick:=ListView1DblClick;
  end;
end;

destructor TVirtEditForm.Destroy;
begin
  ListView1.Free;
  PopupMenu.Free;;
  inherited;
end;

procedure TVirtEditForm.ListView1DblClick(Sender: TObject);
begin
  if (ListView1.Selected <> nil) and
     (ListView1.Selected.Caption = 'Источник данных') then
  begin
    if Assigned(E.SourceEntity) then
      E.SourceEntity.ShowEditor(Monitor.MonitorNum);
  end;
end;

procedure TVirtEditForm.PopupMenu1Popup(Sender: TObject);
var L: TListItem; M: TMenuItem;
begin
  L:=ListView1.Selected;
  with PopupMenu1 do
  begin
    Items.Clear;
    if Assigned(L) then
    begin
      if L.Caption = 'Шифр позиции' then
      begin
        M:=TMenuItem.Create(Self);
        M.Caption:='Изменить имя точки...';
        M.OnClick:=ChangePtNameClick;
        Items.Add(M);
        M:=TMenuItem.Create(Self);
        M.Caption:='-';
        Items.Add(M);
        M:=TMenuItem.Create(Self);
        M.Caption:='Дублировать точку...';
        M.OnClick:=DoubleEntityClick;
        Items.Add(M);
        M:=TMenuItem.Create(Self);
        M.Caption:='Удалить точку';
        M.OnClick:=DeleteEntityClick;
        Items.Add(M);
      end
      else
      if L.Caption = 'Дескриптор позиции' then
      begin
        M:=TMenuItem.Create(Self);
        M.Caption:='Изменить текст...';
        M.OnClick:=ChangeTextClick;
        Items.Add(M);
      end
      else
      if L.Caption = 'Опрос' then
      begin
        M:=TMenuItem.Create(Self);
        M.Caption:='Нет';
        M.Checked:=not E.Actived;
        M.Tag:=0;
        M.OnClick:=ChangeBooleanClick;
        Items.Add(M);
        M:=TMenuItem.Create(Self);
        M.Caption:='Да';
        M.Checked:=E.Actived;
        M.Tag:=1;
        M.OnClick:=ChangeBooleanClick;
        Items.Add(M);
      end
      else
      if L.Caption = 'Время опроса' then
      begin
        M:=TMenuItem.Create(Self);
        M.Caption:='Изменить время опроса...';
        M.OnClick:=ChangeFetchClick; M.Tag:=0; Items.Add(M);
        //---
        M:=TMenuItem.Create(Self); M.Caption:='-'; Items.Add(M);
        //---
        M:=TMenuItem.Create(Self); M.Caption:='1 сек';
        M.Checked:=(E.FetchTime=1);
        M.Tag:=1; M.OnClick:=ChangeFetchClick; Items.Add(M);
        //---
        M:=TMenuItem.Create(Self); M.Caption:='2 сек';
        M.Checked:=(E.FetchTime=2);
        M.Tag:=2; M.OnClick:=ChangeFetchClick; Items.Add(M);
        //---
        M:=TMenuItem.Create(Self); M.Caption:='3 сек';
        M.Checked:=(E.FetchTime=3);
        M.Tag:=3; M.OnClick:=ChangeFetchClick; Items.Add(M);
        //---
        M:=TMenuItem.Create(Self); M.Caption:='5 сек';
        M.Checked:=(E.FetchTime=5);
        M.Tag:=5; M.OnClick:=ChangeFetchClick; Items.Add(M);
        //---
        M:=TMenuItem.Create(Self); M.Caption:='-'; Items.Add(M);
        //---
        M:=TMenuItem.Create(Self); M.Caption:='10 сек';
        M.Checked:=(E.FetchTime=10);
        M.Tag:=10; M.OnClick:=ChangeFetchClick; Items.Add(M);
        //---
        M:=TMenuItem.Create(Self); M.Caption:='20 сек';
        M.Checked:=(E.FetchTime=20);
        M.Tag:=20; M.OnClick:=ChangeFetchClick; Items.Add(M);
        //---
        M:=TMenuItem.Create(Self); M.Caption:='30 сек';
        M.Checked:=(E.FetchTime=30);
        M.Tag:=30; M.OnClick:=ChangeFetchClick; Items.Add(M);
        //---
        M:=TMenuItem.Create(Self); M.Caption:='-'; Items.Add(M);
        //---
        M:=TMenuItem.Create(Self); M.Caption:='1 мин';
        M.Checked:=(E.FetchTime=60);
        M.Tag:=60; M.OnClick:=ChangeFetchClick; Items.Add(M);
        //---
        M:=TMenuItem.Create(Self); M.Caption:='2 мин';
        M.Checked:=(E.FetchTime=120);
        M.Tag:=60*2; M.OnClick:=ChangeFetchClick; Items.Add(M);
        //---
        M:=TMenuItem.Create(Self); M.Caption:='5 мин';
        M.Checked:=(E.FetchTime=300);
        M.Tag:=60*5; M.OnClick:=ChangeFetchClick; Items.Add(M);
      end;
    end;
  end;
end;

procedure TVirtEditForm.UpdateRealTime;
var L: TListItem;
begin
  if not Assigned(E) then Exit;
  if Caddy.UserLevel > 4 then
    ListView1.PopupMenu:=PopupMenu1
  else
    ListView1.PopupMenu:=nil;
//---------------------------------------------------------
  L:=ListView1.FindCaption(0,'Фактически',False,True,False);
  if L <> nil then
  begin
    if E.RealTime > 0 then
      L.SubItems[0]:=Format('%.3f',[E.RealTime/1000])+' сек'
    else
      L.SubItems[0]:='Нет опроса';
  end;
end;

{ TVirtTank }

procedure TVirtTank.Assign(E: TEntity);
begin
  inherited;
// Stub
end;

procedure TVirtTank.ConnectLinks;
var E: TEntity;
begin
  inherited;
  E:=Caddy.Find(FSourceLevel);
  if Assigned(E) then Level:=E as TCustomAnaOut else Level:=nil;
  E:=Caddy.Find(FSourceTemp);
  if Assigned(E) then Temp:=E as TCustomAnaOut else Temp:=nil;
  E:=Caddy.Find(FSourcePaspDens);
  if Assigned(E) then PaspDens:=E as TCustomAnaOut else PaspDens:=nil;
  E:=Caddy.Find(FSourceVolume);
  if Assigned(E) then Volume:=E as TCustomAnaOut else Volume:=nil;
  E:=Caddy.Find(FSourceCalcDens);
  if Assigned(E) then CalcDens:=E as TCustomAnaOut else CalcDens:=nil;
  E:=Caddy.Find(FSourceWeight);
  if Assigned(E) then Weight:=E as TCustomAnaOut else Weight:=nil;
end;

constructor TVirtTank.Create;
var i: integer;
begin
  inherited;
  FIsVirtual:=True;
  FIsComposit:=True;
  LocalFetchOnly:=True;
  for i:=0 to 2000 do Body.Levels[i]:=0;
  for i:=0 to 2 do EntityChilds[i]:=nil;
end;

class function TVirtTank.EntityType: string;
begin
  Result:='Расчет объема и массы продукта в резервуаре';
end;

procedure TVirtTank.Fetch(const Data: string);
var iLevel: Word; dCalcDens,dVolume: Double;
begin
  if Assigned(FLevel) then
  begin
    if FLevel.PV < 0 then
      iLevel:=0
    else
    if FLevel.PV > 2000.0 then
      iLevel:=2000
    else
      iLevel:=Round(FLevel.PV);
    dVolume:=Levels[iLevel];
    if Assigned(FPaspDens) and Assigned(FTemp) then
    begin
      dCalcDens:=CalcDensUnit.CalcDens(FTemp.PV,FPaspDens.PV);
      if Assigned(FCalcDens) then FCalcDens.Raw:=dCalcDens;
    end
    else
      dCalcDens:=0.0;
    if Assigned(FVolume) then
    begin
      FVolume.Raw:=dVolume;
      if (dCalcDens > 0.0) and Assigned(FWeight) then
        FWeight.Raw:=dVolume*dCalcDens;
    end;
    if FLevel.Actived then
      ErrorMess:=FLevel.ErrorMess
    else
      ErrorMess:='Источник уровня неактивен';
  end
  else
    ErrorMess:='Плохой источник уровня';
  UpdateRealTime;
end;

function TVirtTank.GetLevels(Index: Integer): Double;
begin
  if Index <= 2000 then
    Result:=Body.Levels[Index]
  else
    Result:=0.0;
end;

function TVirtTank.GetMaxChildCount: integer;
begin
  Result:=2
end;

function TVirtTank.LoadFromStream(Stream: TStream): integer;
begin
  Result:=SizeOf(Body);
  if (Stream.Size-Stream.Position) < Result then
  begin
    Result:=0;
    Exit;
  end;
  Stream.ReadBuffer(Body,Result);
  FPtName:=Body.PtName;
  FPtDesc:=Body.PtDesc;
  FActived:=Body.Actived;
  FFetchTime:=Body.FetchTime;
  FSourceLevel:=Body.SourceLevel;
  FSourceTemp:=Body.SourceTemp;
  FSourcePaspDens:=Body.SourcePaspDens;
  FSourceVolume:=Body.SourceVolume;
  FSourceCalcDens:=Body.SourceCalcDens;
  FSourceWeight:=Body.SourceWeight;
  FChilds.Clear;
  FChilds.AddObject(FSourceVolume,nil);
  FChilds.AddObject(FSourceCalcDens,nil);
  FChilds.AddObject(FSourceWeight,nil);
end;

procedure TVirtTank.Notify(Kind: TEntityNotify; E: TEntity);
begin
  inherited;
  case Kind of
    enRename: begin
                if E = FLevel then FSourceLevel:=E.PtName;
                if E = FTemp then FSourceTemp:=E.PtName;
                if E = FPaspDens then FSourcePaspDens:=E.PtName;
                if E = FVolume then FSourceVolume:=E.PtName;
                if E = FCalcDens then FSourceCalcDens:=E.PtName;
                if E = FWeight then FSourceWeight:=E.PtName;
              end;
    enDelete: begin
                if E = FLevel then Level:=nil;
                if E = FTemp then Temp:=nil;
                if E = FPaspDens then PaspDens:=nil;
                if E = FVolume then Volume:=nil;
                if E = FCalcDens then CalcDens:=nil;
                if E = FWeight then Weight:=nil;
              end;
  end;
end;

function TVirtTank.PropsCount: integer;
begin
  Result:=10;
end;

class function TVirtTank.PropsID(Index: integer): string;
begin
  case Index of
    0: Result:='PtName';
    1: Result:='PtDesc';
    2: Result:='Active';
    3: Result:='FetchTime';
    4: Result:='SourceLevel';
    5: Result:='SourceTemp';
    6: Result:='SourcePaspDens';
    7: Result:='TargetVolume';
    8: Result:='TargetCalcDens';
    9: Result:='TargetCalcMass';
  else
    Result:='Unknown';
  end
end;

class function TVirtTank.PropsName(Index: integer): string;
begin
  case Index of
    0: Result:='Шифр параметра';
    1: Result:='Десктриптор';
    2: Result:='Опрос';
    3: Result:='Время опроса';
    4: Result:='Источник уровня';
    5: Result:='Источник температуры';
    6: Result:='Источник паспортной плотности';
    7: Result:='Приемник расчитанного объёма';
    8: Result:='Приемник расчитанной плотности';
    9: Result:='Приемник расчитанной массы';
  else
    Result:='';
  end
end;

function TVirtTank.PropsValue(Index: integer): string;
begin
  case Index of
    0: Result:=FPtName;
    1: Result:=FPtDesc;
    2: Result:=IfThen(FActived,'Да','Нет');
    3: Result:=Format('%d сек',[FFetchTime]);
    4: Result:=IfThen(Assigned(FLevel),FSourceLevel,'');
    5: Result:=IfThen(Assigned(FTemp),FSourceTemp,'');
    6: Result:=IfThen(Assigned(FPaspDens),FSourcePaspDens,'');
    7: Result:=IfThen(Assigned(FVolume),FSourceVolume,'');
    8: Result:=IfThen(Assigned(FCalcDens),FSourceCalcDens,'');
    9: Result:=IfThen(Assigned(FWeight),FSourceWeight,'');
 else
    Result:='';
  end
end;

procedure TVirtTank.SaveToStream(Stream: TStream);
begin
  Body.PtName:=PtName;
  Body.PtDesc:=PtDesc;
  Body.Actived:=Actived;
  Body.FetchTime:=FetchTime;
  Body.SourceLevel:=FSourceLevel;
  Body.SourceTemp:=FSourceTemp;
  Body.SourcePaspDens:=FSourcePaspDens;
  Body.SourceVolume:=FSourceVolume;
  Body.SourceCalcDens:=FSourceCalcDens;
  Body.SourceWeight:=FSourceWeight;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

procedure TVirtTank.SaveToText(List: TStringList);
var i: Integer;
begin
  List.Append('[' + PtName + ']');
  List.Append('Plugin=Virtual');
  List.Append('PtType=VT');
  List.Append('PtKind=1');
  List.Append('PtName=' + PtName);
  List.Append('PtDesc=' + PtDesc);
  List.Append('Actived=' + IfThen(Actived, 'True', 'False'));
  List.Append('FetchTime=' + IntToStr(FetchTime));
  List.Append('SourceLevel=' + SourceLevel);
  List.Append('SourceTemp=' + SourceTemp);
  List.Append('SourcePaspDens=' + SourcePaspDens);
  List.Append('SourceVolume=' + SourceVolume);
  List.Append('SourceCalcDens=' + SourceCalcDens);
  List.Append('SourceWeight=' + SourceWeight);
  DecimalSeparator := '.';
  for i:=0 to 2000 do
  if  Body.Levels[i] > 0 then
     List.Append(Format('L%d=%.3f', [i, Body.Levels[i]]));
end;

procedure TVirtTank.SetCalcDens(const Value: TCustomAnaOut);
var S: string;
begin
  FCalcDens:=Value;
  S:=FSourceCalcDens;
  if Assigned(FCalcDens) then
    FSourceCalcDens:=Value.PtName
  else
    FSourceCalcDens:='';
  if S <> FSourceCalcDens then
  begin
    Caddy.AddChange(PtName,'Прием.расч.плотн.',S,FSourceCalcDens,PtDesc,Caddy.Autor);
    Caddy.Changed:=True;
  end;
end;

procedure TVirtTank.SetLevel(const Value: TCustomAnaOut);
var S: string;
begin
  FLevel:=Value;
  S:=FSourceLevel;
  if Assigned(FLevel) then
    FSourceLevel:=Value.PtName
  else
    FSourceLevel:='';
  if S <> FSourceLevel then
  begin
    Caddy.AddChange(PtName,'Ист.уровня',S,FSourceLevel,PtDesc,Caddy.Autor);
    Caddy.Changed:=True;
  end;
end;

procedure TVirtTank.SetLevels(Index: Integer; const Value: Double);
begin
  if Index <= 2000 then
    Body.Levels[Index]:=Value;
  Caddy.Changed:=True;
end;

procedure TVirtTank.SetPaspDens(const Value: TCustomAnaOut);
var S: string;
begin
  FPaspDens:=Value;
  S:=FSourcePaspDens;
  if Assigned(FPaspDens) then
    FSourcePaspDens:=Value.PtName
  else
    FSourcePaspDens:='';
  if S <> FSourcePaspDens then
  begin
    Caddy.AddChange(PtName,'Ист.пасп.плотн.',S,FSourcePaspDens,PtDesc,Caddy.Autor);
    Caddy.Changed:=True;
  end;
end;

procedure TVirtTank.SetTemp(const Value: TCustomAnaOut);
var S: string;
begin
  FTemp:=Value;
  S:=FSourceTemp;
  if Assigned(FTemp) then
    FSourceTemp:=Value.PtName
  else
    FSourceTemp:='';
  if S <> FSourceTemp then
  begin
    Caddy.AddChange(PtName,'Ист.температуры',S,FSourceTemp,PtDesc,Caddy.Autor);
    Caddy.Changed:=True;
  end;
end;

procedure TVirtTank.SetVolume(const Value: TCustomAnaOut);
var S: string;
begin
  FVolume:=Value;
  S:=FSourceVolume;
  if Assigned(FVolume) then
    FSourceVolume:=Value.PtName
  else
    FSourceVolume:='';
  if S <> FSourceVolume then
  begin
    Caddy.AddChange(PtName,'Прием.объема',S,FSourceVolume,PtDesc,Caddy.Autor);
    Caddy.Changed:=True;
  end;
end;

procedure TVirtTank.SetWeight(const Value: TCustomAnaOut);
var S: string;
begin
  FWeight:=Value;
  S:=FSourceWeight;
  if Assigned(FWeight) then
    FSourceWeight:=Value.PtName
  else
    FSourceWeight:='';
  if S <> FSourceWeight then
  begin
    Caddy.AddChange(PtName,'Прием.массы',S,FSourceWeight,PtDesc,Caddy.Autor);
    Caddy.Changed:=True;
  end;
end;

class function TVirtTank.TypeCode: string;
begin
  Result:='VT';
end;

class function TVirtTank.TypeColor: TColor;
begin
  Result:=$00FFFFCC;
end;

{ TVirtCalc }

procedure TVirtCalc.ConnectLinks;
var E: TEntity; i: Integer;
begin
  inherited;
  for i:=1 to 9 do
  begin
    E:=Caddy.Find(Body.AnaVar[i]);
    if Assigned(E) then
      AnaVar[i]:=E as TCustomAnaOut
    else
      AnaVar[i]:=nil;
  end;
end;

constructor TVirtCalc.Create;
var i: Integer;
begin
  inherited;
  FIsVirtual:=True;
  FIsCommand:=False;
  for i:=1 to 9 do
  begin
    FAnaVar[i]:=nil;
    Body.AnaVar[i]:='';
    Body.AnaConst[i]:=0;
    Body.StepList[i].FirstPrefix:=uoNone;
    Body.StepList[i].FirstArgument:=caNone;
    Body.StepList[i].FirstArgNumber:=0;
    Body.StepList[i].Operation:=doNone;
    Body.StepList[i].SecondPrefix:=uoNone;
    Body.StepList[i].SecondArgument:=caNone;
    Body.StepList[i].SecondArgNumber:=0;
  end;
end;

class function TVirtCalc.EntityType: string;
begin
  Result:='Виртуальный калькулятор';
end;

procedure TVirtCalc.Fetch(const Data: string);
var R: Single; i: Integer; V: TOneStep; W1,W2: Extended;
    Vars,Exprs: array[1..9] of Extended;
    Goods: array[1..9] of Boolean; Good: Boolean;
begin
  if Length(Data) = SizeOf(R) then
  begin
// выполняется на клиентской стороне, если сервер прислал строку в 4 символа
    MoveMemory(@R,@Data[1],SizeOf(R));
    Raw:=R;
  end
  else
    if not Assigned(SourceEntity) then
    begin
      for i := 1 to 9 do
      begin
        Exprs[i] := 0;
        if Assigned(AnaVar[i]) and not (asNoLink in AnaVar[i].AlarmStatus) then
        begin
          Vars[i] := AnaVar[i].PV;
          Goods[i] := True;
        end
        else
        begin
          Vars[i] := 0;
          Goods[i] := False;
        end;
      end;
      Good := True;
      ErrorMess:='';
      for i := 1 to 9 do
      begin
        V:=StepList[i];
        if V.FirstArgument <> caNone then
        begin
    // Получение данных первого операнда
          case V.FirstArgument of
      caVar: begin
               W1:=Vars[V.FirstArgNumber];
               Good:=Good and Goods[V.FirstArgNumber];
             end;
    caConst: W1:=AnaConst[V.FirstArgNumber];
     caExpr: W1:=Exprs[V.FirstArgNumber];
          else
            W1:=0;
          end;
          if not Good then
          begin
            ErrorMess:=Format('Формула E%d: Ошибка в значении первого аргумента', [i]);
            Break;
          end;
    // Вычисление первой одноместной операции
          try
            case V.FirstPrefix of
        coNeg: W1:=-W1;
        coSQR: W1:=Sqrt(W1);
        coExp: W1:=Exp(W1);
         coLn: W1:=Ln(W1);
            end;
          except
            on Err: Exception do
            begin
              Good:=False;
              ErrorMess:=Format('Формула E%d: %s для первого аргумента',
                  [i, Err.Message]);
              Break;
            end;
          end;
          W2:=0;
          if V.SecondArgument <> caNone then
          begin
    // Получение данных второго операнда
            case V.SecondArgument of
        caVar: begin
                 W2:=Vars[V.SecondArgNumber];
                 Good:=Good and Goods[V.SecondArgNumber];
               end;
      caConst: W2:=AnaConst[V.SecondArgNumber];
       caExpr: W2:=Exprs[V.SecondArgNumber];
            end;
            if not Good then
            begin
              ErrorMess:=Format('Формула E%d: Ошибка в значении второго аргумента', [i]);
              Break;
            end;
    // Вычисление второй одноместной операции
            try
              case V.SecondPrefix of
          coNeg: W2:=-W2;
          coSQR: W2:=Sqrt(W2);
          coExp: W2:=Exp(W2);
           coLn: W2:=Ln(W2);
              end;
            except
              on Err: Exception do
              begin
                Good:=False;
                ErrorMess:=Format('Формула E%d: %s для второго аргумента',
                   [i, Err.Message]);
                Break;
              end;
            end;
          end;
    // Вычисление двухместной операции
          try
            case V.Operation of
       doNone: Exprs[i]:=W1;
        coAdd: Exprs[i]:=W1+W2;
        coSub: Exprs[i]:=W1-W2;
        coMul: Exprs[i]:=W1*W2;
        coDiv: Exprs[i]:=W1/W2;
            end;
          except
            on Err: Exception do
            begin
              Good:=False;
              ErrorMess:=Format('Формула E%d: %s для двухместной операции',
                [i, Err.Message]);
              Break;
            end;
          end;
        end;
      end; // for
      Raw:=Exprs[9];
      if not Good and not (asBadPV in AlarmStatus) then
        Caddy.AddAlarm(asBadPV,Self);
      if Good and (asBadPV in AlarmStatus) then
        Caddy.RemoveAlarm(asBadPV,Self);
    end;
  UpdateRealTime;
end;

function TVirtCalc.GetAnaConst(Index: Integer): Single;
begin
  Result := FAnaConst[Index];
end;

function TVirtCalc.GetAnaVar(Index: Integer): TCustomAnaOut;
begin
  Result := FAnaVar[Index];
end;

function TVirtCalc.GetStepList(Index: Integer): TOneStep;
begin
  Result := FStepList[Index];
end;

function TVirtCalc.LoadFromStream(Stream: TStream): integer;
var i: Integer;
begin
  Result:=SizeOf(Body);
  if (Stream.Size-Stream.Position) < Result then
  begin
    Result:=0;
    Exit;
  end;
  Stream.ReadBuffer(Body,Result);
  FPtName:=Body.PtName;
  FPtDesc:=Body.PtDesc;
  FActived:=Body.Actived;
  FLogged:=Body.Logged;
  FAsked:=Body.Asked;
  FFetchTime:=Body.FetchTime;
  FSourceName:=Body.SourceName;
  FEUDesc:=Body.EUDesc;
  FPVFormat:=Body.PVFormat;
  FBadDB:=Body.BadDB;
  FHHDB:=Body.HHDB;
  FHiDB:=Body.HiDB;
  FLoDB:=Body.LoDB;
  FLLDB:=Body.LLDB;
  FPVEUHi:=Body.PVEUHi;
  FPVEULo:=Body.PVEULo;
  FPVHHTP:=Body.PVHHTP;
  FPVHiTP:=Body.PVHiTP;
  FPVLoTP:=Body.PVLoTP;
  FPVLLTP:=Body.PVLLTP;
  FTrend:=Body.Trend;
  FIsTrending:=FTrend;
  FCalcScale:=Body.CalcScale;
  for i := 1 to 9 do
  begin
    FAnaConst[i] := Body.AnaConst[i];
    FStepList[i] := Body.StepList[i];
  end;
//  FStepList[1].FirstArgument := caVar;
//  FStepList[1].Operation := coAdd;
//  FStepList[1].SecondArgument := caVar;
end;

function TVirtCalc.NameAnaVar(Index: Integer): string;
begin
  if Assigned(FAnaVar[Index]) then
    Result := FAnaVar[Index].PtName
  else
    Result := '------';   
end;

procedure TVirtCalc.Notify(Kind: TEntityNotify; E: TEntity);
var i: integer;
begin
  inherited;
  case Kind of
    enRename: begin
                for i := 1 to 9 do
                  if E = FAnaVar[i] then
                    Body.AnaVar[i]:=E.PtName;
              end;
    enDelete: begin
                for i := 1 to 9 do
                  if E = FAnaVar[i] then
                  begin
                    FAnaVar[i] := nil;
                    Body.AnaVar[i] := '';
                  end;
              end;
  end;
end;

function TVirtCalc.OperationToString(Index: Integer): string;
begin
  if InRange(Index,1,9) then
  begin
    Result:='';
    if FStepList[Index].FirstArgument <> caNone then
    begin
      Result:=Result+AUnoOperation[FStepList[Index].FirstPrefix];
      if FStepList[Index].FirstPrefix <> uoNone then Result:=Result+'(';
      case FStepList[Index].FirstArgument of
    caVar: Result:=Result+Format('V%d',[FStepList[Index].FirstArgNumber]);
  caConst: Result:=Result+Format('C%d',[FStepList[Index].FirstArgNumber]);
   caExpr: Result:=Result+Format('E%d',[FStepList[Index].FirstArgNumber]);
      end;
      if FStepList[Index].FirstPrefix <> uoNone then Result:=Result+')';
      if FStepList[Index].Operation <> doNone then
      begin
        if FStepList[Index].SecondArgument <> caNone then
        begin
          Result:=Result+ADuoOperation[FStepList[Index].Operation];
          Result:=Result+AUnoOperation[FStepList[Index].SecondPrefix];
          if FStepList[Index].SecondPrefix <> uoNone then Result:=Result+'(';
          case FStepList[Index].SecondArgument of
        caVar: Result:=Result+Format('V%d',[FStepList[Index].SecondArgNumber]);
      caConst: Result:=Result+Format('C%d',[FStepList[Index].SecondArgNumber]);
       caExpr: Result:=Result+Format('E%d',[FStepList[Index].SecondArgNumber]);
          end;
          if FStepList[Index].SecondPrefix <> uoNone then Result:=Result+')';
        end;
      end;
    end;
  end
  else
    Result:='Ошибка!';
end;

function TVirtCalc.PropsCount: integer;
begin
  Result := 45;
end;

class function TVirtCalc.PropsID(Index: integer): string;
begin
  case Index of
    0: Result:='PtName';
    1: Result:='PtDesc';
    2: Result:='Active';
    3: Result:='Alarm';
    4: Result:='Confirm';
    5: Result:='Trend';
    6: Result:='FetchTime';
    7: Result:='Source';
    8: Result:='EUDesc';
    9: Result:='FormatPV';
   10: Result:='PVEUHI';
   11: Result:='PVHHTP';
   12: Result:='PVHITP';
   13: Result:='PVLOTP';
   14: Result:='PVLLTP';
   15: Result:='PVEULO';
   16: Result:='BadDB';
   17: Result:='CalcScale';
   18..26: Result:=Format('AnaVar%d',[Index-17]);
   27..35: Result:=Format('AnaConst%d',[Index-26]);
   36..44: Result:=Format('OperList%d',[Index-35]);
  else
    Result:='';
  end
end;

class function TVirtCalc.PropsName(Index: integer): string;
begin
  case Index of
    0: Result:='Шифр параметра';
    1: Result:='Десктриптор';
    2: Result:='Опрос';
    3: Result:='Сигнализация';
    4: Result:='Квитирование';
    5: Result:='Тренд';
    6: Result:='Время опроса';
    7: Result:='Источник данных';
    8: Result:='Размерность';
    9: Result:='Формат PV';
   10: Result:='Верхняя граница шкалы';
   11: Result:='Верхняя предаварийная граница';
   12: Result:='Верхняя предупредительная граница';
   13: Result:='Нижняя предупредительная граница';
   14: Result:='Нижняя предаварийная граница';
   15: Result:='Нижняя граница шкалы';
   16: Result:='Контроль границ шкалы';
   17: Result:='Масштаб по шкале';
   18..26: Result:=Format('Вход %d',[Index-17]);
   27..35: Result:=Format('Константа %d',[Index-26]);
   36..44: Result:=Format('Операция %d',[Index-35]);
  else
    Result:='';
  end
end;

function TVirtCalc.PropsValue(Index: integer): string;
var sFormat: string;
begin
  sFormat:='%.'+Format('%d',[Ord(FPVFormat)])+'f';
  DecimalSeparator := '.';
  case Index of
    0: Result:=FPtName;
    1: Result:=FPtDesc;
    2: Result:=IfThen(FActived,'Да','Нет');
    3: Result:=IfThen(FAsked,'Да','Нет');
    4: Result:=IfThen(FLogged,'Да','Нет');
    5: Result:=IfThen(FTrend,'Да','Нет');
    6: Result:=Format('%d сек',[FFetchTime]);
    7: Result:=IfThen(Assigned(FSourceEntity),FSourceName,'Авто');
    8: Result:=FEUDesc;
    9: Result:=Format('D%d',[Ord(FPVFormat)]);
   10: Result:=Format(sFormat,[FPVEUHi]);
   11: Result:=Format(sFormat,[FPVHHTP])+' '+AAlmDB[FHHDB];
   12: Result:=Format(sFormat,[FPVHITP])+' '+AAlmDB[FHIDB];
   13: Result:=Format(sFormat,[FPVLOTP])+' '+AAlmDB[FLODB];
   14: Result:=Format(sFormat,[FPVLLTP])+' '+AAlmDB[FLLDB];
   15: Result:=Format(sFormat,[FPVEULo]);
   16: Result:=AAlmDB[FBadDB];
   17: Result:=IfThen(FCalcScale,'Да','Нет');
   18..26:
     if Assigned(FAnaVar[Index-17]) then
       Result:=FAnaVar[Index-17].PtName
     else
       Result:='';
   27..35: Result:=Format('%g',[FAnaConst[Index-26]]);
   36..44: Result:=Format('%s',[OperationToString(Index-35)]);
  else
    Result:='';
  end
end;

procedure TVirtCalc.SaveToStream(Stream: TStream);
var i: Integer;
begin
  Body.PtName:=PtName;
  Body.PtDesc:=PtDesc;
  Body.Actived:=Actived;
  Body.Logged:=Logged;
  Body.Asked:=Asked;
  Body.FetchTime:=FetchTime;
  Body.SourceName:=SourceName;
  Body.EUDesc:=EUDesc;
  Body.PVFormat:=PVFormat;
  Body.BadDB:=BadDB;
  Body.HHDB:=HHDB;
  Body.HiDB:=HiDB;
  Body.LoDB:=LoDB;
  Body.LLDB:=LLDB;
  Body.PVEUHi:=PVEUHi;
  Body.PVEULo:=PVEULo;
  Body.PVHHTP:=PVHHTP;
  Body.PVHiTP:=PVHiTP;
  Body.PVLoTP:=PVLoTP;
  Body.PVLLTP:=PVLLTP;
  Body.Trend:=Trend;
  Body.CalcScale:=CalcScale;
  for i:=1 to 9 do
  if FAnaVar[i] <> nil then
    Body.AnaVar[i] := FAnaVar[i].PtName
  else
    Body.AnaVar[i] := '';
  for i:=1 to 9 do
  begin
    Body.AnaConst[i] := AnaConst[i];
    Body.StepList[i] := StepList[i];
  end;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

procedure TVirtCalc.SaveToText(List: TStringList);
var i: Integer;
begin
  List.Append('[' + PtName + ']');
  List.Append('Plugin=Virtual');
  List.Append('PtType=CA');
  List.Append('PtKind=1');
  List.Append('PtName=' + PtName);
  List.Append('PtDesc=' + PtDesc);
  List.Append('Actived=' + IfThen(Actived, 'True', 'False'));
  List.Append('Logged=' + IfThen(Logged, 'True', 'False'));
  List.Append('Asked=' + IfThen(Asked, 'True', 'False'));
  List.Append('FetchTime=' + IntToStr(FetchTime));
  List.Append('SourceName=' + SourceName);
  List.Append('EUDesc=' + EUDesc);
  List.Append('PVFormat=' + Format('D%d',[Ord(PVFormat)]));
  List.Append('BadDB=' + AAlmDB[BadDB]);
  DecimalSeparator := '.';
  List.Append('PVEUHI=' + Format('%.3f',[PVEUHi]));
  List.Append('PVEULO=' + Format('%.3f',[PVEULo]));
  List.Append('PVHHTP=' + Format('%.3f %s',[PVHHTP, AAlmDB[HHDB]]));
  List.Append('PVHITP=' + Format('%.3f %s',[PVHiTP, AAlmDB[HiDB]]));
  List.Append('PVLOTP=' + Format('%.3f %s',[PVLoTP, AAlmDB[LoDB]]));
  List.Append('PVLLTP=' + Format('%.3f %s',[PVLLTP, AAlmDB[LLDB]]));
  List.Append('Trend=' + IfThen(Trend, 'True', 'False'));
  List.Append('CalcScale=' + IfThen(CalcScale, 'True', 'False'));
  for i:=1 to 9 do
     List.Append(Format('V%d=%s', [i, Body.AnaVar[i]]));
  for i:=1 to 9 do
     List.Append(Format('C%d=%.3f', [i, AnaConst[i]]));
  for i:=1 to 9 do
     List.Append(Format('E%d=%s', [i, OperationToString(i)]));
end;

procedure TVirtCalc.SendIMPULSE;
begin
// Stub
end;

procedure TVirtCalc.SendOP(Value: Single);
begin
// Stub
end;

procedure TVirtCalc.SetAnaConst(Index: Integer; const Value: Single);
begin
  FAnaConst[Index] := Value;
  Caddy.Changed:=True;
end;

procedure TVirtCalc.SetAnaVar(Index: Integer;
  const Value: TCustomAnaOut);
begin
  FAnaVar[Index] := Value;
  Caddy.Changed:=True;
end;

procedure TVirtCalc.SetStepList(Index: Integer; const Value: TOneStep);
begin
  FStepList[Index] := Value;
  Caddy.Changed:=True;
end;

class function TVirtCalc.TypeCode: string;
begin
  Result:='CA';
end;

class function TVirtCalc.TypeColor: TColor;
begin
  Result:=$00FFFFCC;
end;

initialization
{$IFDEF VIRTUALENTITY}
  with RegisterNode('Виртуальные точки RemX') do
  begin
    Add(RegisterEntity(TVirtSysInfo));       //  0
    RegisterEditForm(TVirtSIEditForm);
    RegisterPaspForm(TVirtSIPaspForm);
    Add(RegisterEntity(TVirtNumeric));       //  1
    RegisterEditForm(TVirtNNEditForm);
    RegisterPaspForm(TVirtNNPaspForm);
    Add(RegisterEntity(TVirtFlag));          //  2
    RegisterEditForm(TVirtFLEditForm);
    RegisterPaspForm(TVirtFLPaspForm);
    Add(RegisterEntity(TVirtVDGroup));       //  3
    RegisterEditForm(TVirtVDEditForm);
    RegisterPaspForm(TVirtVDPaspForm);
    Add(RegisterEntity(TVirtValve));         //  4
    RegisterEditForm(TVirtVCEditForm);
    RegisterPaspForm(TVirtVCPaspForm);
    Add(RegisterEntity(TVirtAnaSel));        //  5
    RegisterEditForm(TVirtASEditForm);
    RegisterPaspForm(TVirtASPaspForm);
    Add(RegisterEntity(TVirtTimeCounter));   //  6
    RegisterEditForm(TVirtTCEditForm);
    RegisterPaspForm(TVirtTCPaspForm);
    Add(RegisterEntity(TVirtFAGroup));       //  7
    RegisterEditForm(TVirtFAEditForm);
    RegisterPaspForm(TVirtFAPaspForm);
    Add(RegisterEntity(TVirtTank));          //  8
    RegisterEditForm(TVirtVTEditForm);
    RegisterPaspForm(nil);
    Add(RegisterEntity(TVirtCalc));          //  9
    RegisterEditForm(TVirtCAEditForm);
    RegisterPaspForm(TVirtCAPaspForm);
  end;
{$ENDIF}
end.
