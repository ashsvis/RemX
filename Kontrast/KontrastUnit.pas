unit KontrastUnit;

interface

uses
  Windows, SysUtils, Classes, Graphics, ExtCtrls, Forms, Controls,
  Menus, ComCtrls, Messages, EntityUnit;

type
  TAlgoblock = 1..999;
  TInOut = 1..127;
  TFablFormat = 0..8;
  TFetchKind = (fkCommand,fkRequest,fkAnswer,fkConfirm);

  TKontEditForm = class(TBaseEditForm)
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
    procedure ChangeIntegerClick(Sender: TObject); virtual;
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

  TKontDigOut = class(TCustomDigOut)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Channel: word;
      Node: word;
      Block: word;
      Place: word;
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
  protected
  public
    DataFormat: TFablFormat;
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
    function AddressEqual(E: TEntity): boolean; override;
    property Block;
    property Place;
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

const
  DigPtxType: array[0..4] of string =
    ('ДП (Дискретная переменная)',
     'КТС (Ключ секундного таймера)',
     'КТМ (Ключ десятимиллисекундного таймера)',
     'КБ (Ключ блока)',
     'КС (Ключ секции)');

type
  TKontDigPtx = class(TKontDigOut)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Channel: word;
      Node: word;
      Block: word;
      Place: word;
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
      PulseWait: word;
    end;
    FPulseWait: word;
    procedure ImpulseTimer(Sender: TObject);
    procedure SetPulseWait(const Value: word);
  protected
  public
    class function EntityType: string; override;
    class function TypeCode: string; override;
    class function TypeColor: TColor; override;
    function PropsCount: integer; override;
    class function PropsID(Index: integer): string; override;
    class function PropsName(Index: integer): string; override;
    constructor Create; override;
    function PropsValue(Index: integer): string; override;
    function Prepare: string; override;
    procedure SaveToStream(Stream: TStream); override;
    procedure SaveToText(List: TStringList); override;
    function LoadFromStream(Stream: TStream): integer; override;
    procedure Fetch(const Data: string); override;
    procedure SendOP(Value: Single); override;
    procedure SendIMPULSE; override;
    property PulseWait: word read FPulseWait write SetPulseWait;
  end;

  TKontDigParam = class(TCustomDigInp)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Channel: word;
      Node: word;
      Block: word;
      Place: word;
      Actived: boolean;
      FetchTime: Cardinal;
      SourceName: string[10];
      Invert: Boolean;
      PulseWait: word;
    end;
    FPulseWait: word;
    procedure SetPulseWait(const Value: word);
    procedure ImpulseTimer(Sender: TObject);
  protected
  public
    DataFormat: TFablFormat;
    class function EntityType: string; override;
    class function TypeCode: string; override;
    class function TypeColor: TColor; override;
    function PropsCount: integer; override;
    class function PropsID(Index: integer): string; override;
    class function PropsName(Index: integer): string; override;
    function PropsValue(Index: integer): string; override;
    constructor Create; override;
    procedure Assign(E: TEntity); override;
    procedure SaveToStream(Stream: TStream); override;
    procedure SaveToText(List: TStringList); override;
    function LoadFromStream(Stream: TStream): integer; override;
    function Prepare: string; override;
    procedure Fetch(const Data: string); override;
    procedure SendOP(Value: Single); override;
    procedure SendIMPULSE; override;
    function AddressEqual(E: TEntity): boolean; override;
    property Block;
    property Place;
    property Invert;
    property PulseWait: word read FPulseWait write SetPulseWait;
    property OP;
  end;

  TKontAnaOut = class(TCustomAnaOut)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Channel: word;
      Node: word;
      Block: word;
      Place: word;
      Actived: boolean;
      Asked: boolean;
      Logged: boolean;
      Trend: boolean;
      CalcScale: boolean;
      FetchTime: Cardinal;
      SourceName: string[10];
      EUDesc: string[10];
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
  public
    DataFormat: TFablFormat;
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
    function AddressEqual(E: TEntity): boolean; override;
    property Block;
    property Place;
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

  TKontAnaParam = class(TCustomAnaInp)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Channel: word;
      Node: word;
      Block: word;
      Place: word;
      Actived: boolean;
      FetchTime: Cardinal;
      SourceName: string[10];
      CalcScale: boolean;
      EUDesc: string[10];
      OPFormat: TPVFormat;
      OPEUHi: Single;
      OPEULo: Single;
    end;
  protected
  public
    DataFormat: TFablFormat;
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
    procedure SendOP(Value: Single); override;
    function AddressEqual(E: TEntity): boolean; override;
    property Block;
    property Place;
    property OP;
    property EUDesc;
    property OPFormat;
    property OPEUHi;
    property OPEULo;
  end;

const
   AFablFormat: array[TFablFormat] of string =
     ('Вещественный','Целый стандартный','Логический (дискретный)',
      'Целый короткий','Целый длинный','Неопределённый',
      'Упакованный логический','Упакованный целый','Упакованный вещественный');

type
  TKontCntReg = class(TCustomCntReg)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Channel: word;
      Node: word;
      Block: word;
      Place: word;
      Actived: boolean;
      Asked: boolean;
      Logged: boolean;
      Trend: boolean;
      FetchTime: Cardinal;
      SourceName: string[10];
      EUDesc: string[10];
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
      SPEULo: Single;
      SPEUHi: Single;
      PVDHTP: Single;
      PVDLTP: Single;
      CheckSP: TCheckChange;
      CheckOP: TCheckChange;
      RegType: TRegType;
      SourceK: string[10];
      SourceT1: string[10];
      SourceT2: string[10];
    end;
    FT1: TKontAnaParam;
    FT2: TKontAnaParam;
    FK: TKontAnaParam;
    FSourceT1: string;
    FSourceT2: string;
    FSourceK: string;
    LastCommand: string;
    FDL: Single;
    FHand: Single;
    procedure SetK(const Value: TKontAnaParam);
    procedure SetT1(const Value: TKontAnaParam);
    procedure SetT2(const Value: TKontAnaParam);
  protected
    function GetPlaceName: string; override;
    procedure SetPV(const Value: Double); override;
    procedure SetMode(const Value: Word); override;
    procedure SetOP(const Value: Single); override;
    procedure SetSP(const Value: Single); override;
    procedure SetRegType(const Value: TRegType); override;
    procedure SetSPEUHi(const Value: Single); override;
    procedure SetSPEULo(const Value: Single); override;
  public
    AutoMode: string;
    CasMode: string;
    EUFlag: Boolean;
    EUMode: string;
    HandMode: string;
    HandRaw: Single;
    KonturErrors: string;
    KonturMode: string;
    ModeRaw: Word;
    OPRaw: Single;
    PVRaw: Single;
    SPMode: string;
    SPRaw: Single;
    constructor Create; override;
    class function EntityType: string; override;
    class function TypeCode: string; override;
    class function TypeColor: TColor; override;
    function PropsCount: integer; override;
    class function PropsID(Index: integer): string; override;
    class function PropsName(Index: integer): string; override;
    function PropsValue(Index: integer): string; override;
    function HasCommandSP: boolean; override;
    function HasCommandOP: boolean; override;
    function HasCommandMode: boolean; override;
    property K: TKontAnaParam read FK write SetK;
    property T1: TKontAnaParam read FT1 write SetT1;
    property T2: TKontAnaParam read FT2 write SetT2;
    procedure Assign(E: TEntity); override;
    procedure Notify(Kind: TEntityNotify; E: TEntity); override;
    procedure ConnectLinks; override;
    procedure SaveToStream(Stream: TStream); override;
    procedure SaveToText(List: TStringList); override;
    function LoadFromStream(Stream: TStream): integer; override;
    function Prepare: string; override;
    procedure Fetch(const Data: string); override;
    procedure SendSP(Value: Single); override;
    procedure SendOP(Value: Single); override;
    procedure SendCommand(Value: Byte); override;
    function AddressEqual(E: TEntity): boolean; override;
    function SPText: string;
    function OPText: string;
    property Place;
    property PV;
    property SP;
    property OP;
    property DL: Single read FDL;
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
    property SPEUHi;
    property SPEULo;
    property RegType;
    property PVDHTP;
    property PVDLTP;
    property CheckSP;
    property CheckOP;
    property SourceK: string read FSourceK;
    property SourceT1: string read FSourceT1;
    property SourceT2: string read FSourceT2;
    property Hand: Single read FHand write FHand;
    property Mode;
    property Trend;
  end;

  TKontCRGroup = class(TCustomGroup)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Channel: word;
      Node: word;
      Actived: boolean;
      FetchTime: Cardinal;
      SourceName: string[10];
      Childs: array[0..3] of string[10];
    end;
  protected
    procedure SetEntityChilds(Index: Integer; const Value: TEntity); override;
  public
    function GetMaxChildCount: integer; override;
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
    procedure ConnectLinks; override;
    function Prepare: string; override;
    procedure Fetch(const Data: string); override;
  end;

  TKontOutputsGroup = class(TKontCRGroup)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Channel: word;
      Node: word;
      Actived: boolean;
      FetchTime: Cardinal;
      SourceName: string[10];
      Childs: array[0..13] of string[10];
    end;
  protected
  public
    function GetMaxChildCount: integer; override;
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
  end;

  TKontUPZDateTime = class(TCustomAnaOut)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Channel: word;
      Node: word;
      Block: word;
      Actived: boolean;
      FetchTime: Cardinal;
      Reserved1: Integer;
      Reserved2: Integer;
      Reserved3: Integer;
      Reserved4: Integer;
    end;
  protected
    function GetTextValue: string; override;
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
    property Block;
  end;


  TKontParamsGroup = class(TKontCRGroup)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Channel: word;
      Node: word;
      Actived: boolean;
      FetchTime: Cardinal;
      SourceName: string[10];
      Childs: array[0..13] of string[10];
    end;
  protected
  public
    function GetMaxChildCount: integer; override;
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
  end;

  TKontFDGroup = class(TCustomGroup)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Channel: word;
      Node: word;
      Block: word;
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
    DataFormat: TFablFormat;
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
    function Prepare: string; override;
    procedure Fetch(const Data: string); override;
    function AddressEqual(E: TEntity): boolean; override;
    procedure Decode(Value: Single); override;
    property Block;
  end;

  TKontKDGroup = class(TCustomGroup)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Channel: word;
      Node: word;
      Block: word;
      Actived: boolean;
      FetchTime: Cardinal;
      Childs: array[0..29] of string[10];
    end;
  protected
  public
    DataFormat: TFablFormat;
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
    function Prepare: string; override;
    procedure Fetch(const Data: string); override;
    function AddressEqual(E: TEntity): boolean; override;
    property Block;
  end;

  TKontINRGroup = class(TKontKDGroup)
  public
    constructor Create; override;
    class function EntityType: string; override;
    class function TypeCode: string; override;
    class function PropsID(Index: integer): string; override;
    class function PropsName(Index: integer): string; override;
    procedure SaveToText(List: TStringList); override;
    function Prepare: string; override;
    function AddressEqual(E: TEntity): boolean; override;
  end;

  TNodeNumbers =  set of Byte;
  TNodeError =  record
                  NodeType: Byte;
                  Mode: Boolean;   // False - Работа; True - Программирование
                  Status: Boolean; // False - Автономный; True - Резервированный
                  ErrCount: Byte;
                  ErrInfo,LastErrInfo:
                     array[0..14] of
                           record
                             ErrType: Byte;
                             ErrPlace: Word;
                             When: TDateTime;
                           end;
                  Year,Month,Day,WeekDay,Hour,Minute,Second: Byte;
                end;
  TKontNode = class(TEntity)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Channel: word;
      Node: word;
      Actived: boolean;
      FetchTime: Cardinal;
    end;
  protected
    function GetFetchData: string; override;
  public
    ErrController: TNodeError;
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
    procedure RequestData; override;
    procedure ClearLog;
    function GetSourceText(n, e, d: integer): string;
  end;

  TSyncKind = (skNone,skMaster,skSlave);

const
  ASyncKind: array[TSyncKind] of string = ('Нет','Ведущий','Ведомый');

type
  TKontSyncMagister = class(TEntity)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Channel: word;
      Node: word;
      Actived: boolean;
      FetchTime: Cardinal;
      ActionKind: TSyncKind;
    end;
    NodeType: integer;
    FActionKind: TSyncKind;
    procedure SetActionKind(const Value: TSyncKind);
  protected
    function GetFetchData: string; override;
  public
    procedure Assign(E: TEntity); override;
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
    procedure RequestData; override;
    property ActionKind: TSyncKind read FActionKind write SetActionKind;
  end;

function IntToDP(Value: Cardinal): string;

implementation

uses Math, DateUtils, StrUtils, GetPtNameUnit,
     KontDOEditUnit, KontDPEditUnit, KontAOEditUnit, KontAPEditUnit,
     KontCREditUnit, KontGREditUnit, KontAOPaspUnit, KontDOPaspUnit,
     KontDPPaspUnit, KontAPPaspUnit, KontCRPaspUnit, KontGRPaspUnit,
     KontGOPaspUnit, KontGPPaspUnit, KontFDEditUnit, KontFDPaspUnit,
     KontKDEditUnit, KontKDPaspUnit, KontNDEditUnit, KontNDPaspUnit,
     KontSMEditUnit,                 KontDXEditUnit, KontDXPaspUnit,
     KontINREditUnit, KontUDEditUnit;

function IntToDP(Value: Cardinal): string;
begin
  Result:=IntToStr(Value div 8)+IntToStr(Value mod 8);
end;

function ErrorToString(ErrCode: integer; ErrDefault: string): string;
begin
  case ErrCode of
    0: Result:='Нет ошибок';
    1: Result:='Отсутствует алгоритм ЗДН или к ОКР подключен не ЗДН';
    2: Result:='В модификаторе алгоритма ОКР не предусмотрено внешнее задание';
    3: Result:='В модификаторе алгоритма ЗДН не предусмотрено программное задание';
    4: Result:='Отсутствует алгоритм РУЧ или к ОКР подключен не РУЧ';
    5: Result:='Отсутствует алгоритм ЗДЛ или к ОКР подключен не ЗДЛ';
    6: Result:='При отключенном контуре (ДУ или РУ) ручное изменение задания запрещено';
    7: Result:='Состояние программы не сброс';
    8: Result:='Режим управления не ручной';
    9: Result:='Режим управления не ручной';
   11: Result:='В модификаторе алгоритма ОКР не предусмотрен дистанционный режим';
   12: Result:='На входе 01 алгоритма РУЧ присутствует команда блокировки ручного режима';
   15: Result:='Состояние программы не соответствует разрешенному для выполнения данной команды';
   16: Result:='В алгоритме ЗДН к текущему (активному) входу программного задатчика подключен не алгоритм ПРЗ';
   17: Result:='В алгоритме ЗДН нет входа программного задатчика с таким номером';
   18: Result:='Режим задания не ручной';
   20: Result:='Нет такого алгоблока';
   21: Result:='Нет такого входа';
   22: Result:='Нет такого выхода';
   23: Result:='Попытка изменения связанного входа или константы';
   24: Result:='Нет такого контура';
   25: Result:='Нет такого кода команды в данном операторе';
   30: Result:='Ошибка во входах алгоблока';
   31: Result:='В данном алгоблоке нет алгоритма регистрации РЕГ';
   32: Result:='Нет такого блока в алгоритме регистрации(архивации)';
   33: Result:='Пустой буфер регистрации(архивации)';
   34: Result:='В данном алгоблоке нет алгоритма архивации АРХ';
   38: Result:='Алгоблок с этим номером не является концентратором данных';
   51: Result:='Нет объекта для выполнения команды';
   52: Result:='В данном режиме не возможно выполнить команду';
   53: Result:='Неправильный формат запроса';
   54: Result:='Нет такого оператора в данном классе команд';
   55: Result:='Нет такой команды';
   56: Result:='Нет такого запроса';
   60: Result:='Нет такого типа переменной Протекст';
   61: Result:='Нет переменной заданного типа с указанным номером';
   70: Result:='Нет флэш-диска';
   71: Result:='Неправильный номер блока флэш-диска';
   72: Result:='Попытка чтения флэш-диска во время его программирования или стирания';
   73: Result:='Ошибка стирания блока флэш-диска';
   98: Result:='Перезапуск контроллера по сторожу цикла';
   99: Result:='Перезапуск контроллера по супервизору питания';
  else
    Result:=ErrDefault;
  end;
end;

{ TKontDigOut }

class function TKontDigOut.EntityType: string;
begin
  Result:='Дискретный выход ФАБЛ';
end;

function TKontDigOut.Prepare: string;
var S: string; W: Word;
begin
  W:=FBlock;
  S:=#1#4#1+Chr(Lo(W))+Chr(Hi(W))+Chr(FPlace);
  W:=Length(S);
  S:=Chr(FNode)+#$fe+Chr(Lo(W))+Chr(Hi(W))+#$40+S;
  Result:=S;
end;

procedure TKontDigOut.Fetch(const Data: string);
var nformat: Byte; N: Integer; I: Integer;
begin
  inherited;
  if Length(Data) = 16 then
  begin
    if Ord(Data[12]) = $FF then
    begin
      N:=Ord(Data[13]);
      ErrorMess:=ErrorToString(N,Format('Сетевая ошибка %d',[N]));
    end
    else
    begin
      ErrorMess:='';
      nformat:=(Ord(Data[12]) and $4E) shr 1;
      MoveMemory(@I,@Data[13],4);
      DataFormat:=EnsureRange(nformat,Low(TFablFormat),High(TFablFormat));
      if nformat = 2 then
      begin
        if (I and $01) > 0 then
          Raw:=1.0
        else
          Raw:=0.0;
      end
      else
        ErrorMess:=Format('Ошибка логического формата (Получен формат: %d)',
                          [nformat]);
    end;
    UpdateRealTime;
  end;
end;

function TKontDigOut.LoadFromStream(Stream: TStream): integer;
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
  FChannel:=Body.Channel;
  FNode:=Body.Node;
  FBlock:=Body.Block;
  FPlace:=Body.Place;
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

procedure TKontDigOut.SaveToStream(Stream: TStream);
begin
  Body.PtName:=PtName;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Node;
  Body.Block:=Block;
  Body.Place:=Place;
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

procedure TKontDigOut.SaveToText(List: TStringList);
begin
  List.Append('[' + PtName + ']');
  List.Append('Plugin=KR500');
  List.Append('PtType=DO');
  List.Append('PtKind=2');
  List.Append('PtName=' + PtName);
  List.Append('PtDesc=' + PtDesc);
  List.Append('Channel=' + IntToStr(Channel));
  List.Append('Node=' + IntToStr(Node));
  List.Append('Block=' + IntToStr(Block));
  List.Append('Place=' + IntToStr(Place));
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

class function TKontDigOut.TypeCode: string;
begin
  Result:='DO';
end;

class function TKontDigOut.TypeColor: TColor;
begin
  Result:=$0099FFFF;
end;

function TKontDigOut.AddressEqual(E: TEntity): boolean;
begin
  with E as TKontDigOut do
  begin
    Result:=(Channel = Self.Channel) and
            (Node = Self.Node) and
            (Block = Self.Block) and
            (Place = Self.Place);
  end;
end;

function TKontDigOut.PropsCount: integer;
begin
  Result:=20
end;

class function TKontDigOut.PropsID(Index: integer): string;
begin
  case Index of
    0: Result:='PtName';
    1: Result:='PtDesc';
    2: Result:='Channel';
    3: Result:='Node';
    4: Result:='Algoblock';
    5: Result:='Output';
    6: Result:='Active';
    7: Result:='Alarm';
    8: Result:='Confirm';
    9: Result:='FEtchTime';
   10: Result:='Source';
   11: Result:='Invert';
   12: Result:='AlarmOFF';
   13: Result:='AlarmON';
   14: Result:='SwitchOFF';
   15: Result:='SwitchON';
   16: Result:='ColorOFF';
   17: Result:='ColorON';
   18: Result:='TextOFF';
   19: Result:='TextON';
  else
    Result:='Unknown';
  end
end;

class function TKontDigOut.PropsName(Index: integer): string;
begin
  case Index of
    0: Result:='Шифр параметра';
    1: Result:='Десктриптор';
    2: Result:='Канал связи';
    3: Result:='Контроллер';
    4: Result:='Алгоблок';
    5: Result:='Выход алгоблока';
    6: Result:='Опрос';
    7: Result:='Сигнализация';
    8: Result:='Квитирование';
    9: Result:='Время опроса';
   10: Result:='Источник данных';
   11: Result:='Инверсия данных';
   12: Result:='Авария при "1"->"0"';
   13: Result:='Авария при "0"->"1"';
   14: Result:='Переключение при "1"->"0"';
   15: Result:='Переключение при "0"->"1"';
   16: Result:='Цвет при "0"';
   17: Result:='Цвет при "1"';
   18: Result:='Текст при "0"';
   19: Result:='Текст при "1"';
  else
    Result:='';
  end
end;

function TKontDigOut.PropsValue(Index: integer): string;
begin
  case Index of
    0: Result:=FPtName;
    1: Result:=FPtDesc;
    2: Result:=Format('%d',[FChannel]);
    3: Result:=Format('%d',[FNode]);
    4: Result:=Format('%d',[FBlock]);
    5: Result:=Format('%d',[FPlace]);
    6: Result:=IfThen(FActived,'Да','Нет');
    7: Result:=IfThen(FAsked,'Да','Нет');
    8: Result:=IfThen(FLogged,'Да','Нет');
    9: Result:=Format('%d сек',[FFetchTime]);
   10: Result:=IfThen(Assigned(FSourceEntity),FSourceName,'Авто');
   11: Result:=IfThen(FInvert,'Да','Нет');
   12: Result:=IfThen(FAlarmDown,'Да','Нет');
   13: Result:=IfThen(FAlarmUp,'Да','Нет');
   14: Result:=IfThen(FSwitchDown,'Да','Нет');
   15: Result:=IfThen(FSwitchUp,'Да','Нет');
   16: Result:=StringDigColor[FColorDown];
   17: Result:=StringDigColor[FColorUp];
   18: Result:=FTextDown;
   19: Result:=FTextUp;
  else
    Result:='';
  end
end;

{ TKontDigParam }

procedure TKontDigParam.Assign(E: TEntity);
begin
  inherited;
  FPulseWait:=(E as TKontDigParam).PulseWait;
end;

constructor TKontDigParam.Create;
begin
  inherited;
  FPulseWait:=500;
end;

class function TKontDigParam.EntityType: string;
begin
  Result:='Дискретный параметр ФАБЛ';
end;

function TKontDigParam.Prepare: string;
var S: string; W: Word; A: array[1..4] of Byte;
begin
  if Caddy.NetRole = nrClient then
  begin
    SetLength(Result,SizeOf(CommandData));
    MoveMemory(@Result[1],@CommandData,SizeOf(CommandData));
    Exit;
  end
  else
  if HasCommand then
  begin
    MoveMemory(@A[1],@CommandData,4);
    W:=FBlock;
    S:=#1#1+Chr(Lo(W))+Chr(Hi(W))+Chr(FPlace)+
            Chr(A[1])+Chr(A[2])+Chr(A[3])+Chr(A[4]);
    W:=Length(S);
    S:=Chr(FNode)+#$fe+Chr(Lo(W))+Chr(Hi(W))+#$00+S;
    Result:=S;
  end
  else
  begin
    W:=FBlock;
    S:=#1#1#1+Chr(Lo(W))+Chr(Hi(W))+Chr(FPlace);
    W:=Length(S);
    S:=Chr(FNode)+#$fe+Chr(Lo(W))+Chr(Hi(W))+#$40+S;
    Result:=S;
  end;
end;

procedure TKontDigParam.Fetch(const Data: string);
var nformat: Byte; N,I: Integer; W: Word;
begin
  inherited;
  if HasCommand then
  begin
    if Length(Data) = 9 then
    begin
      W:=Ord(Data[8])+256*Ord(Data[9]);
      if W = 0 then
      begin
        ErrorMess:='Команда принята';
        Caddy.AddChange(FPtName,'OP','','',ErrorMess,'Автономно');
        Caddy.ShowMessage(kmStatus,ErrorMess);
        Windows.Beep(500,100);
      end
      else
      begin
        ErrorMess:=ErrorToString(W,Format('Сетевая ошибка %d',[W]));
        Caddy.AddChange(FPtName,'OP','','',ErrorMess,'Автономно');
        Caddy.ShowMessage(kmError,ErrorMess);
        Caddy.AddSysMess(PtName,ErrorMess);
        Windows.Beep(1000,100);
        Sleep(100);
        Windows.Beep(1000,100);
      end;
      LastTime:=FFetchTime+1;
    end;
  end
  else
  begin
    if Length(Data) = 16 then
    begin
      if Ord(Data[12]) = $FF then
      begin
        N:=Ord(Data[13]);
        ErrorMess:=ErrorToString(N,Format('Сетевая ошибка %d',[N]));
      end
      else
      begin
        ErrorMess:='';
        nformat:=(Ord(Data[12]) and $1E) shr 1;
        MoveMemory(@I,@Data[13],4);
        DataFormat:=EnsureRange(nformat,Low(TFablFormat),High(TFablFormat));
        if nformat = 2 then
        begin
          ErrorMess:='';
          if (I and $01) > 0 then
            Raw:=1.0
          else
            Raw:=0.0;
        end
        else
          ErrorMess:='Ошибка логического формата';
      end;
      UpdateRealTime;
    end;
  end;  
end;

function TKontDigParam.LoadFromStream(Stream: TStream): integer;
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
  FChannel:=Body.Channel;
  FNode:=Body.Node;
  FBlock:=Body.Block;
  FPlace:=Body.Place;
  FActived:=Body.Actived;
  FFetchTime:=Body.FetchTime;
  FSourceName:=Body.SourceName;
  FInvert:=Body.Invert;
  FPulseWait:=Body.PulseWait;
end;

procedure TKontDigParam.SaveToStream(Stream: TStream);
begin
  Body.PtName:=PtName;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Node;
  Body.Block:=Block;
  Body.Place:=Place;
  Body.Actived:=Actived;
  Body.FetchTime:=FetchTime;
  Body.SourceName:=SourceName;
  Body.Invert:=Invert;
  Body.PulseWait:=PulseWait;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

procedure TKontDigParam.SaveToText(List: TStringList);
begin
  List.Append('[' + PtName + ']');
  List.Append('Plugin=KR500');
  List.Append('PtType=DP');
  List.Append('PtKind=2');
  List.Append('PtName=' + PtName);
  List.Append('PtDesc=' + PtDesc);
  List.Append('Channel=' + IntToStr(Channel));
  List.Append('Node=' + IntToStr(Node));
  List.Append('Block=' + IntToStr(Block));
  List.Append('Place=' + IntToStr(Place));
  List.Append('Actived=' + IfThen(Actived, 'True', 'False'));
  List.Append('FetchTime=' + IntToStr(FetchTime));
  List.Append('SourceName=' + SourceName);
  List.Append('Invert=' + IfThen(Invert, 'True', 'False'));
  List.Append('PulseWait=' + IntToStr(PulseWait));
end;

procedure TKontDigParam.SetPulseWait(const Value: word);
begin
  if FPulseWait <> Value then
  begin
    Caddy.AddChange(PtName,'Время импульса',IntToStr(FPulseWait),
                                          IntToStr(Value),PtDesc,Caddy.Autor);
    FPulseWait:=Value;
    Caddy.Changed:=True;
  end;
end;

class function TKontDigParam.TypeCode: string;
begin
  Result:='DP';
end;

class function TKontDigParam.TypeColor: TColor;
begin
  Result:=$0099FFFF;
end;

procedure TKontDigParam.SendOP(Value: Single);
const AB: array[Boolean] of string = ('лог."0"','лог."1"');
var BoolVal: boolean;
begin
  BoolVal:=(Value > 0);
  if FInvert then BoolVal:=not BoolVal;
  Caddy.AddChange(FPtName,'OP',AB[OP],AB[BoolVal],FPtDesc,Caddy.Autor);
  LastTime:=FFetchTime;
  if BoolVal then CommandData:=1 else CommandData:=0;
  HasCommand:=True;
end;

procedure TKontDigParam.SendIMPULSE;
begin
  with TTimer.Create(nil) do
  begin
    OnTimer:=ImpulseTimer;
    Interval:=FPulseWait;
    Enabled:=True;
  end;
  if Invert then
    SendOP(0.0)
  else
    SendOP(1.0);
end;

procedure TKontDigParam.ImpulseTimer(Sender: TObject);
begin
  try
    (Sender as TTimer).Enabled:=False;
    if Invert then
      SendOP(1.0)
    else
      SendOP(0.0);
  finally
    FreeAndNil(Sender);
  end;  
end;

function TKontDigParam.AddressEqual(E: TEntity): boolean;
begin
  with E as TKontDigParam do
  begin
    Result:=(Channel = Self.Channel) and
            (Node = Self.Node) and
            (Block = Self.Block) and
            (Place = Self.Place);
  end;
end;

function TKontDigParam.PropsCount: integer;
begin
  Result:=11;
end;

class function TKontDigParam.PropsID(Index: integer): string;
begin
  case Index of
    0: Result:='PtName';
    1: Result:='PtDesc';
    2: Result:='Channel';
    3: Result:='Node';
    4: Result:='Algoblock';
    5: Result:='Input';
    6: Result:='Active';
    7: Result:='FetchTime';
    8: Result:='Source';
    9: Result:='Invert';
   10: Result:='PulseWait';
  else
    Result:='Unknown';
  end
end;

class function TKontDigParam.PropsName(Index: integer): string;
begin
  case Index of
    0: Result:='Шифр параметра';
    1: Result:='Десктриптор';
    2: Result:='Канал связи';
    3: Result:='Контроллер';
    4: Result:='Алгоблок';
    5: Result:='Параметр алгоблока';
    6: Result:='Опрос';
    7: Result:='Время опроса';
    8: Result:='Источник данных';
    9: Result:='Инверсия данных';
   10: Result:='Время строба';
  else
    Result:='';
  end
end;

function TKontDigParam.PropsValue(Index: integer): string;
begin
  case Index of
    0: Result:=FPtName;
    1: Result:=FPtDesc;
    2: Result:=Format('%d',[FChannel]);
    3: Result:=Format('%d',[FNode]);
    4: Result:=Format('%d',[FBlock]);
    5: Result:=Format('%d',[FPlace]);
    6: Result:=IfThen(FActived,'Да','Нет');
    7: Result:=Format('%d сек',[FFetchTime]);
    8: Result:=IfThen(Assigned(FSourceEntity),FSourceName,'Авто');
    9: Result:=IfThen(FInvert,'Да','Нет');
   10: Result:=Format('%d мсек',[FPulseWait]);
  else
    Result:='';
  end
end;

{ TKontAnaOut }

class function TKontAnaOut.EntityType: string;
begin
  Result:='Аналоговый выход ФАБЛ';
end;

function TKontAnaOut.LoadFromStream(Stream: TStream): integer;
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
  FChannel:=Body.Channel;
  FNode:=Body.Node;
  FBlock:=Body.Block;
  FPlace:=Body.Place;
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

procedure TKontAnaOut.SaveToStream(Stream: TStream);
begin
  Body.PtName:=PtName;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Node;
  Body.Block:=Block;
  Body.Place:=Place;
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

procedure TKontAnaOut.SaveToText(List: TStringList);
begin
  List.Append('[' + PtName + ']');
  List.Append('Plugin=KR500');
  List.Append('PtType=AO');
  List.Append('PtKind=1');
  List.Append('PtName=' + PtName);
  List.Append('PtDesc=' + PtDesc);
  List.Append('Channel=' + IntToStr(Channel));
  List.Append('Node=' + IntToStr(Node));
  List.Append('Block=' + IntToStr(Block));
  List.Append('Place=' + IntToStr(Place));
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

function TKontAnaOut.Prepare: string;
var S: string; W: Word;
begin
  W:=FBlock;
  S:=#1#4#1+Chr(Lo(W))+Chr(Hi(W))+Chr(FPlace);
  W:=Length(S);
  S:=Chr(FNode)+#$fe+Chr(Lo(W))+Chr(Hi(W))+#$40+S;
  Result:=S;
end;

procedure TKontAnaOut.Fetch(const Data: string);
var nformat: Byte; N,I: Integer; R: Single; SI: SmallInt; SH: ShortInt;
    A: array[1..4] of Byte;
begin
  inherited;
  if Length(Data) = 16 then
  begin
    if Ord(Data[12]) = $FF then
    begin
      N:=Ord(Data[13]);
      ErrorMess:=ErrorToString(N,Format('Сетевая ошибка %d',[N]));
    end
    else
    begin
      ErrorMess:='';
      nformat:=(Ord(Data[12]) and $7E) shr 1;
      A[1]:=Ord(Data[13]);
      A[2]:=Ord(Data[14]);
      A[3]:=Ord(Data[15]);
      A[4]:=Ord(Data[16]);
      if (nformat = 0) and (A[1] = 0) and (A[2] = 0) and
                           (A[3] = 160) and (A[4] = 127) then
      begin
        ErrorMess:='Принятое значение не число!';
        Exit;
      end;
      DataFormat:=EnsureRange(nformat,Low(TFablFormat),High(TFablFormat));
      case nformat of
        0: begin
             MoveMemory(@R,@Data[13],4);
             Raw:=R;
           end;
        1: begin
             MoveMemory(@SI,@Data[13],2);
             Raw:=SI*1.0;
           end;
        3: begin
             MoveMemory(@SH,@Data[13],1);
             Raw:=SH*1.0;
           end;
        4: begin
             MoveMemory(@I,@Data[13],4);
             Raw:=I*1.0;
           end;
        5: begin
             MoveMemory(@R,@Data[13],4);
             Raw:=R;
           end;
      else
        ErrorMess:=Format('Недопустимый формат: %d',[nformat]);
      end;
    end;
    UpdateRealTime;
  end;
end;

class function TKontAnaOut.TypeCode: string;
begin
  Result:='AO';
end;

class function TKontAnaOut.TypeColor: TColor;
begin
  Result:=$0099FFFF;
end;

function TKontAnaOut.AddressEqual(E: TEntity): boolean;
begin
  with E as TKontAnaOut do
  begin
    Result:=(Channel = Self.Channel) and
            (Node = Self.Node) and
            (Block = Self.Block) and
            (Place = Self.Place);
  end;
end;

function TKontAnaOut.PropsCount: integer;
begin
  Result:=22;
end;

class function TKontAnaOut.PropsID(Index: integer): string;
begin
  case Index of
    0: Result:='PtName';
    1: Result:='PtDesc';
    2: Result:='Channel';
    3: Result:='Node';
    4: Result:='Algoblock';
    5: Result:='Output';
    6: Result:='Active';
    7: Result:='Alarm';
    8: Result:='Confirm';
    9: Result:='Trend';
   10: Result:='FetchTime';
   11: Result:='Source';
   12: Result:='EUDesc';
   13: Result:='FormatPV';
   14: Result:='PVEUHI';
   15: Result:='PVHHTP';
   16: Result:='PVHITP';
   17: Result:='PVLOTP';
   18: Result:='PVLLTP';
   19: Result:='PVEULO';
   20: Result:='BadDB';
   21: Result:='CalcScale';
  else
    Result:='Unknown';
  end
end;

class function TKontAnaOut.PropsName(Index: integer): string;
begin
  case Index of
    0: Result:='Шифр параметра';
    1: Result:='Десктриптор';
    2: Result:='Канал связи';
    3: Result:='Контроллер';
    4: Result:='Алгоблок';
    5: Result:='Выход алгоблока';
    6: Result:='Опрос';
    7: Result:='Сигнализация';
    8: Result:='Квитирование';
    9: Result:='Тренд';
   10: Result:='Время опроса';
   11: Result:='Источник данных';
   12: Result:='Размерность';
   13: Result:='Формат PV';
   14: Result:='Верхняя граница шкалы';
   15: Result:='Верхняя предаварийная граница';
   16: Result:='Верхняя предупредительная граница';
   17: Result:='Нижняя предупредительная граница';
   18: Result:='Нижняя предаварийная граница';
   19: Result:='Нижняя граница шкалы';
   20: Result:='Контроль границ шкалы';
   21: Result:='Масштаб по шкале';
  else
    Result:='';
  end
end;

function TKontAnaOut.PropsValue(Index: integer): string;
var sFormat: string;
begin
  sFormat:='%.'+Format('%d',[Ord(FPVFormat)])+'f';
  DecimalSeparator := '.';
  case Index of
    0: Result:=FPtName;
    1: Result:=FPtDesc;
    2: Result:=Format('%d',[FChannel]);
    3: Result:=Format('%d',[FNode]);
    4: Result:=Format('%d',[FBlock]);
    5: Result:=Format('%d',[FPlace]);
    6: Result:=IfThen(FActived,'Да','Нет');
    7: Result:=IfThen(FAsked,'Да','Нет');
    8: Result:=IfThen(FLogged,'Да','Нет');
    9: Result:=IfThen(FTrend,'Да','Нет');
   10: Result:=Format('%d сек',[FFetchTime]);
   11: Result:=IfThen(Assigned(FSourceEntity),FSourceName,'Авто');
   12: Result:=FEUDesc;
   13: Result:=Format('D%d',[Ord(FPVFormat)]);
   14: Result:=Format(sFormat,[FPVEUHi]);
   15: Result:=Format(sFormat,[FPVHHTP])+' '+AAlmDB[FHHDB];
   16: Result:=Format(sFormat,[FPVHITP])+' '+AAlmDB[FHIDB];
   17: Result:=Format(sFormat,[FPVLOTP])+' '+AAlmDB[FLODB];
   18: Result:=Format(sFormat,[FPVLLTP])+' '+AAlmDB[FLLDB];
   19: Result:=Format(sFormat,[FPVEULo]);
   20: Result:=AAlmDB[FBadDB];
   21: Result:=IfThen(FCalcScale,'Да','Нет');
  else
    Result:='';
  end
end;

{ TKontAnaParam }

class function TKontAnaParam.EntityType: string;
begin
  Result:='Аналоговый параметр ФАБЛ';
end;

function TKontAnaParam.Prepare: string;
var S: string; W: Word; A: array[1..4] of Byte;
begin
  if Caddy.NetRole = nrClient then
  begin
    SetLength(Result,SizeOf(CommandData));
    MoveMemory(@Result[1],@CommandData,SizeOf(CommandData));
    Exit;
  end
  else
  if HasCommand then
  begin
    MoveMemory(@A[1],@CommandData,4);
    W:=FBlock;
    S:=#1#1+Chr(Lo(W))+Chr(Hi(W))+Chr(FPlace)+
            Chr(A[1])+Chr(A[2])+Chr(A[3])+Chr(A[4]);
    W:=Length(S);
    S:=Chr(FNode)+#$fe+Chr(Lo(W))+Chr(Hi(W))+#$00+S;
    Result:=S;
  end
  else
  begin
    W:=FBlock;
    S:=#1#1#1+Chr(Lo(W))+Chr(Hi(W))+Chr(FPlace);
    W:=Length(S);
    S:=Chr(FNode)+#$fe+Chr(Lo(W))+Chr(Hi(W))+#$40+S;
    Result:=S;
  end;
end;

procedure TKontAnaParam.Fetch(const Data: string);
var nformat: Byte; N: Integer; S: ShortInt;
    W: word; R: Single; D: LongWord; I: LongInt; 
begin
  inherited;
  if HasCommand then
  begin
    if Length(Data) = 9 then
    begin
      W:=Ord(Data[8])+256*Ord(Data[9]);
      if W = 0 then
      begin
        ErrorMess:='Команда принята';
        Caddy.AddChange(FPtName,'OP','','',ErrorMess,'Автономно');
        Caddy.ShowMessage(kmStatus,ErrorMess);
        Windows.Beep(500,100);
      end
      else
      begin
        ErrorMess:=ErrorToString(W,Format('Сетевая ошибка %d',[W]));
        Caddy.AddChange(FPtName,'OP','','',ErrorMess,'Автономно');
        Caddy.ShowMessage(kmError,ErrorMess);
        Caddy.AddSysMess(PtName,ErrorMess);
        Windows.Beep(1000,100);
        Sleep(100);
        Windows.Beep(1000,100);
      end;
      LastTime:=FFetchTime+1;
    end;
  end
  else
  begin
    if Length(Data) = 16 then
    begin
      if Ord(Data[12]) = $FF then
      begin
        N:=Ord(Data[13]);
        ErrorMess:=ErrorToString(N,Format('Сетевая ошибка %d',[N]));
      end
      else
      begin
        ErrorMess:='';
        nformat:=(Ord(Data[12]) and $1E) shr 1;
        MoveMemory(@R,@Data[13],4);
        MoveMemory(@D,@Data[13],4);
        MoveMemory(@I,@Data[13],4);
        MoveMemory(@W,@Data[13],2);
        MoveMemory(@S,@Data[13],1);
        DataFormat:=EnsureRange(nformat,Low(TFablFormat),High(TFablFormat));
        case nformat of
          0: Raw:=R;
          1: Raw:=W;
          2: Raw:=D;
          3: Raw:=S;
          4: Raw:=I;
        else
          ErrorMess:=Format('Недопустимый формат: %d',[nformat]);
        end;
      end;
      UpdateRealTime;
    end;
  end;
end;

function TKontAnaParam.LoadFromStream(Stream: TStream): integer;
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
  FChannel:=Body.Channel;
  FNode:=Body.Node;
  FBlock:=Body.Block;
  FPlace:=Body.Place;
  FActived:=Body.Actived;
  FCalcScale:=Body.CalcScale;
  FFetchTime:=Body.FetchTime;
  FSourceName:=Body.SourceName;
  FEUDesc:=Body.EUDesc;
  FOPFormat:=Body.OPFormat;
  FOPEUHi:=Body.OPEUHi;
  FOPEULo:=Body.OPEULo;
end;

procedure TKontAnaParam.SaveToStream(Stream: TStream);
begin
  Body.PtName:=PtName;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Node;
  Body.Block:=Block;
  Body.Place:=Place;
  Body.Actived:=Actived;
  Body.FetchTime:=FetchTime;
  Body.CalcScale:=CalcScale;
  Body.SourceName:=SourceName;
  Body.EUDesc:=EUDesc;
  Body.OPFormat:=OPFormat;
  Body.OPEUHi:=OPEUHi;
  Body.OPEULo:=OPEULo;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

procedure TKontAnaParam.SaveToText(List: TStringList);
begin
  List.Append('[' + PtName + ']');
  List.Append('Plugin=KR500');
  List.Append('PtType=AP');
  List.Append('PtKind=1');
  List.Append('PtName=' + PtName);
  List.Append('PtDesc=' + PtDesc);
  List.Append('Channel=' + IntToStr(Channel));
  List.Append('Node=' + IntToStr(Node));
  List.Append('Block=' + IntToStr(Block));
  List.Append('Place=' + IntToStr(Place));
  List.Append('Actived=' + IfThen(Actived, 'True', 'False'));
  List.Append('FetchTime=' + IntToStr(FetchTime));
  List.Append('SourceName=' + SourceName);
  List.Append('EUDesc=' + EUDesc);
  List.Append('OPFormat=' + Format('D%d',[Ord(OPFormat)]));
  DecimalSeparator := '.';
  List.Append('OPEUHI=' + Format('%.3f',[OPEUHi]));
  List.Append('OPEULO=' + Format('%.3f',[OPEULo]));
end;

class function TKontAnaParam.TypeCode: string;
begin
  Result:='AP';
end;

class function TKontAnaParam.TypeColor: TColor;
begin
  Result:=$0099FFFF;
end;

procedure TKontAnaParam.SendOP(Value: Single);
var sFormat: string;
begin
  sFormat:='%.'+Format('%d',[Ord(FOPFormat)])+'f';
  Caddy.AddChange(FPtName,'OP',Format(sFormat,[OP]),Format(sFormat,[Value]),
                              FPtDesc,Caddy.Autor);
  LastTime:=FFetchTime;
  if FCalcScale then
    CommandData:=(Value-FOPEULo)*100.0/(FOPEUHi-FOPEULo)
  else
    CommandData:=Value;
  HasCommand:=True;
end;

function TKontAnaParam.AddressEqual(E: TEntity): boolean;
begin
  with E as TKontAnaParam do
  begin
    Result:=(Channel = Self.Channel) and
            (Node = Self.Node) and
            (Block = Self.Block) and
            (Place = Self.Place);
  end;
end;

function TKontAnaParam.PropsCount: integer;
begin
  Result:=14;
end;

class function TKontAnaParam.PropsID(Index: integer): string;
begin
  case Index of
    0: Result:='PtName';
    1: Result:='PtDesc';
    2: Result:='Channel';
    3: Result:='Node';
    4: Result:='Algoblock';
    5: Result:='Input';
    6: Result:='Active';
    7: Result:='FetchTime';
    8: Result:='Source';
    9: Result:='EUDesc';
   10: Result:='FormatOP';
   11: Result:='OPEUHI';
   12: Result:='OPEULO';
   13: Result:='CalcScale';
  else
    Result:='Unknown';
  end
end;

class function TKontAnaParam.PropsName(Index: integer): string;
begin
  case Index of
    0: Result:='Шифр параметра';
    1: Result:='Десктриптор';
    2: Result:='Канал связи';
    3: Result:='Контроллер';
    4: Result:='Алгоблок';
    5: Result:='Параметр алгоблока';
    6: Result:='Опрос';
    7: Result:='Время опроса';
    8: Result:='Источник данных';
    9: Result:='Размерность';
   10: Result:='Формат OP';
   11: Result:='Верхняя граница шкалы';
   12: Result:='Нижняя граница шкалы';
   13: Result:='Масштаб по шкале';
  else
    Result:='';
  end
end;

function TKontAnaParam.PropsValue(Index: integer): string;
var sFormat: string;
begin
  sFormat:='%.'+Format('%d',[Ord(FOPFormat)])+'f';
  case Index of
    0: Result:=FPtName;
    1: Result:=FPtDesc;
    2: Result:=Format('%d',[FChannel]);
    3: Result:=Format('%d',[FNode]);
    4: Result:=Format('%d',[FBlock]);
    5: Result:=Format('%d',[FPlace]);
    6: Result:=IfThen(FActived,'Да','Нет');
    7: Result:=Format('%d сек',[FFetchTime]);
    8: Result:=IfThen(Assigned(FSourceEntity),FSourceName,'Авто');
    9: Result:=FEUDesc;
   10: Result:=Format('D%d',[Ord(FOPFormat)]);
   11: Result:=Format(sFormat,[FOPEUHi]);
   12: Result:=Format(sFormat,[FOPEULo]);
   13: Result:=IfThen(FCalcScale,'Да','Нет');
  else
    Result:='';
  end
end;

{ TKontCntReg }

constructor TKontCntReg.Create;
begin
  inherited;
  FSPEUHi:=100.0;
//------------------------------------------------
  FSPEULo:=0.0;
  FSP:=0.0;
  FOP:=0.0;
  FPVDHTP:=0.0;
  FPVDLTP:=0.0;
//------------------------------------------------
  FRegType:=rtAnalog;
  FEntityKind:=ekKontur;
  FIsKontur:=True;
  FCheckSP:=ccNone;
  FCheckOP:=ccNone;
  FSourceK:='';
  FSourceT1:='';
  FSourceT2:='';
  LastCommand:='';
end;

class function TKontCntReg.EntityType: string;
begin
  Result:='Контур регулирования ФАБЛ';
end;

procedure TKontCntReg.SetOP(const Value: Single);
begin
  if FOP <> Value then
  begin
    FOP:=Value;
  end;
end;

procedure TKontCntReg.SetRegType(const Value: TRegType);
begin
  if FRegType <> Value then
  begin
    Caddy.AddChange(PtName,'Тип регулятора',ARegType[FRegType],
                              ARegType[Value],PtDesc,Caddy.Autor);
    FRegType:=Value;
    Caddy.Changed:=True;
  end;
end;

procedure TKontCntReg.SetSP(const Value: Single);
begin
  if FSP <> Value then
  begin
    FSP:=Value;
  end;
end;

procedure TKontCntReg.SetSPEUHi(const Value: Single);
  function FV(V: Single): string;
  begin
    Result:=Format('%.'+IntToStr(Ord(PVFormat))+'f',[V]);
  end;
begin
  if FSPEUHi <> Value then
  begin
    Caddy.AddChange(PtName,'SPEUHI',FV(FSPEUHi),FV(Value),
                              PtDesc,Caddy.Autor);
    FSPEUHi:=Value;
    Caddy.Changed:=True;
  end;
end;

procedure TKontCntReg.SetSPEULo(const Value: Single);
  function FV(V: Single): string;
  begin
    Result:=Format('%.'+IntToStr(Ord(PVFormat))+'f',[V]);
  end;
begin
  if FSPEULo <> Value then
  begin
    Caddy.AddChange(PtName,'SPEULO',FV(FSPEULo),FV(Value),
                              PtDesc,Caddy.Autor);
    FSPEULo:=Value;
    Caddy.Changed:=True;
  end;
end;

class function TKontCntReg.TypeCode: string;
begin
  Result:='CR';
end;

procedure TKontCntReg.SetK(const Value: TKontAnaParam);
var S: string;
begin
  FK:=Value;
  S:=FSourceK;
  if Assigned(FK) then
    FSourceK:=Value.PtName
  else
    FSourceK:='';
  if S <> FSourceK then
  begin
    Caddy.AddChange(PtName,'Источник K',S,FSourceK,
                              PtDesc,Caddy.Autor);
    Caddy.Changed:=True;
  end;
end;

procedure TKontCntReg.SetT1(const Value: TKontAnaParam);
var S: string;
begin
  FT1:=Value;
  S:=FSourceT1;
  if Assigned(FT1) then
    FSourceT1:=Value.PtName
  else
    FSourceT1:='';
  if S <> FSourceT1 then
  begin
    Caddy.AddChange(PtName,'Источник T1',S,FSourceT1,
                              PtDesc,Caddy.Autor);
    Caddy.Changed:=True;
  end;
end;

procedure TKontCntReg.SetT2(const Value: TKontAnaParam);
var S: string;
begin
  FT2 := Value;
  S:=FSourceT2;
  if Assigned(FT2) then
    FSourceT2:=Value.PtName
  else
    FSourceT2:='';
  if S <> FSourceT2 then
  begin
    Caddy.AddChange(PtName,'Источник T2',S,FSourceT2,
                              PtDesc,Caddy.Autor);
    Caddy.Changed:=True;
  end;
end;

class function TKontCntReg.TypeColor: TColor;
begin
  Result:=$0099FFFF;
end;

procedure TKontCntReg.Assign(E: TEntity);
var T: TKontCntReg;
begin
  inherited;
  T:=E as TKontCntReg;
  FSPEUHi:=T.SPEUHi;
  FSPEULo:=T.SPEULo;
  FPVDHTP:=T.PVDHTP;
  FPVDLTP:=T.PVDLTP;
  FRegType:=T.RegType;
  FCheckSP:=T.CheckSP;
  FCheckOP:=T.CheckOP;
end;

procedure TKontCntReg.Notify(Kind: TEntityNotify; E: TEntity);
begin
  inherited;
  case Kind of
    enRename: begin
                if E = FK then FSourceK:=E.PtName;
                if E = FT1 then FSourceT1:=E.PtName;
                if E = FT2 then FSourceT2:=E.PtName;
              end;
    enDelete: begin
                if E = FK then K:=nil;
                if E = FT1 then T1:=nil;
                if E = FT2 then T2:=nil;
              end;
  end;
end;

procedure TKontCntReg.ConnectLinks;
var E: TEntity;
begin
  inherited;
  E:=Caddy.Find(FSourceK);
  if Assigned(E) then
    K:=E as TKontAnaParam else K:=nil;
  E:=Caddy.Find(FSourceT1);
  if Assigned(E) then
    T1:=E as TKontAnaParam else T1:=nil;
  E:=Caddy.Find(FSourceT2);
  if Assigned(E) then
    T2:=E as TKontAnaParam else T2:=nil;
end;

function TKontCntReg.LoadFromStream(Stream: TStream): integer;
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
  FChannel:=Body.Channel;
  FNode:=Body.Node;
  FBlock:=Body.Block;
  FPlace:=Body.Place;
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
  FSPEULo:=Body.SPEULo;
  FSPEUHi:=Body.SPEUHi;
  FPVDHTP:=Body.PVDHTP;
  FPVDLTP:=Body.PVDLTP;
  FCheckSP:=Body.CheckSP;
  FCheckOP:=Body.CheckOP;
  FRegType:=Body.RegType;
  FSourceK:=Body.SourceK;
  FSourceT1:=Body.SourceT1;
  FSourceT2:=Body.SourceT2;
  FTrend:=Body.Trend;
  FIsTrending:=FTrend;
end;

procedure TKontCntReg.SaveToStream(Stream: TStream);
begin
  Body.PtName:=PtName;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Node;
  Body.Block:=Block;
  Body.Place:=Place;
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
  Body.SPEULo:=SPEULo;
  Body.SPEUHi:=SPEUHi;
  Body.PVDHTP:=PVDHTP;
  Body.PVDLTP:=PVDLTP;
  Body.CheckSP:=CheckSP;
  Body.CheckOP:=CheckOP;
  Body.RegType:=RegType;
  Body.SourceK:=SourceK;
  Body.SourceT1:=SourceT1;
  Body.SourceT2:=SourceT2;
  Body.Trend:=Trend;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

procedure TKontCntReg.SaveToText(List: TStringList);
begin
  List.Append('[' + PtName + ']');
  List.Append('Plugin=KR500');
  List.Append('PtType=CR');
  List.Append('PtKind=5');
  List.Append('PtName=' + PtName);
  List.Append('PtDesc=' + PtDesc);
  List.Append('Channel=' + IntToStr(Channel));
  List.Append('Node=' + IntToStr(Node));
  List.Append('Block=' + IntToStr(Block));
  List.Append('Place=' + IntToStr(Place));
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
  List.Append('SPEULO=' + Format('%.3f',[SPEULo]));
  List.Append('SPEUHI=' + Format('%.3f',[SPEUHi]));
  List.Append('PVDHTP=' + Format('%.3f',[PVDHTP]));
  List.Append('PVDLTP=' + Format('%.3f',[PVDLTP]));
  List.Append('CheckSP=' + ACtoStr[CheckSP]);
  List.Append('CheckOP=' + ACtoStr[CheckOP]);
  List.Append('RegType=' + ARegType[RegType]);
  List.Append('SourceK=' + SourceK);
  List.Append('SourceT1=' + SourceT1);
  List.Append('SourceT2=' + SourceT2);
  List.Append('Trend=' + IfThen(Trend, 'True', 'False'));
end;

function TKontCntReg.GetPlaceName: string;
begin
  Result:='Контур';
end;

procedure TKontCntReg.SetPV(const Value: Double);
var LastValue: Double;
begin
  LastValue:=FPV;
  try
    FPV:=RoundTo(Value,-Ord(FPVFormat));
  except
    FPV := LastValue;
  end;
  if FLogged and ((FPV > LastValue) or FirstCalc) then
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
  if  FLogged and ((FPV < LastValue) or FirstCalc) then
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
  if  FLogged then
  begin
    if (FPVDHTP > 0) and ((FPV-FSP) >= FPVDHTP) and not (asDH in AlarmStatus) then
      Caddy.AddAlarm(asDH,Self);
    if not ((FPVDHTP > 0) and ((FPV-FSP) >= FPVDHTP)) and (asDH in AlarmStatus) then
      Caddy.RemoveAlarm(asDH,Self);
//----------------------------------------------------------------------
    if (FPVDLTP > 0) and ((FSP-FPV) >= FPVDLTP) and not (asDL in AlarmStatus) then
      Caddy.AddAlarm(asDL,Self);
    if not ((FPVDLTP > 0) and ((FSP-FPV) >= FPVDLTP)) and (asDL in AlarmStatus) then
      Caddy.RemoveAlarm(asDL,Self);
  end;
end;

function TKontCntReg.Prepare: string;
var S: string; W: Word;
  CalcVal: Single; A: array[1..4] of Byte;
begin
  if Caddy.NetRole = nrClient then
  begin
    SetLength(Result,SizeOf(CommandMode)+SizeOf(CommandData));
    MoveMemory(@Result[1],@CommandMode,SizeOf(CommandMode));
    MoveMemory(@Result[2],@CommandData,SizeOf(CommandData));
    Exit;
  end
  else
  if HasCommand then
  begin
    S:=#1#2+Chr(FPlace)+Chr(CommandMode);
    if CommandMode in [10,11] then
    begin
      if CommandMode = 10 then
      begin
        if ((FSPEUHi-FSPEULo) <> 0) and not EUFlag then
          CalcVal:=(CommandData-FSPEULo)/(FSPEUHi-FSPEULo)*100.0
        else
          CalcVal:=CommandData;
      end
      else
        CalcVal:=CommandData;
      MoveMemory(@A[1],@CalcVal,4);
      S:=S+Chr(A[1])+Chr(A[2])+Chr(A[3])+Chr(A[4]);
    end;
    W:=Length(S);
    S:=Chr(FNode)+#$fe+Chr(Lo(W))+Chr(Hi(W))+#$00+S;
    Result:=S;
  end
  else
  begin
    S:=#1#2#1+Chr(FPlace);
    W:=Length(S);
    S:=Chr(FNode)+#$fe+Chr(Lo(W))+Chr(Hi(W))+#$40+S;
    Result:=S;
  end;
end;

procedure TKontCntReg.Fetch(const Data: string);
var
  N: Integer;
  StatusOk: boolean;
//  HasNoLink,AlarmFound,HasAlarm,HasConfirm: boolean;
  W: Word;
  A: array[1..4] of Byte;
  R: Single;
  I: Integer;
//  DFColor1,DFColor2: TColor;
//  KindStatus: TKindStatus;
//  LastAlarm: TAlarmState;
  function IsBadValue: boolean;
  begin
    if (A[1] = 0) and (A[2] = 0) and (A[3] = 160) and (A[4] = 127) then
      Result:=True
    else
      Result:=False;
  end;
begin
  inherited;
  if HasCommand then
  begin
    if Length(Data) = 9 then
    begin
      W:=Ord(Data[8])+256*Ord(Data[9]);
      if W = 0 then
      begin
        ErrorMess:='Команда принята';
        Caddy.AddChange(FPtName,LastCommand,'','',ErrorMess,'Автономно');
        Caddy.ShowMessage(kmStatus,ErrorMess);
        Windows.Beep(500,100);
      end
      else
      begin
        ErrorMess:=ErrorToString(W,Format('Сетевая ошибка %d',[W]));
        Caddy.AddChange(FPtName,LastCommand,'','',ErrorMess,'Автономно');
        Caddy.ShowMessage(kmError,ErrorMess);
        Caddy.AddSysMess(PtName,ErrorMess);
        Windows.Beep(1000,100);
        Sleep(100);
        Windows.Beep(1000,100);
      end;
      LastTime:=FFetchTime+1;
    end;
  end
  else
  begin
    if Length(Data) = 31 then
    begin
      if $100-Ord(Data[9]) = FPlace then
      begin
        N:=Ord(Data[10]);
        if N > 0 then
        begin
//          if (N = 24) and not (asNoLink in AlarmStatus) then
//          begin
//            Caddy.AddAlarm(asNoLink,Self);
//            FirstCalc:=True;
//          end;
          ErrorMess:=ErrorToString(N,Format('Сетевая ошибка %d',[N]));
        end;
        Exit;
      end;
      if Ord(Data[9]) <> FPlace then
      begin
        ErrorMess:=Format('Ответ от другого контура: %d',[Ord(Data[9])]);
        Exit;
      end;
      ErrorMess:='';
    // Получение данных Hand
      MoveMemory(@A[1],@Data[10],4);
      MoveMemory(@R,@Data[10],4);
      if not IsBadValue then
        FHand:=R;
    // Получение данных Mode
      A[1]:=Ord(Data[30]);
      A[2]:=Ord(Data[31]);
      A[3]:=0;
      A[4]:=0;
      MoveMemory(@I,@A[1],4);
      if not IsBadValue then
        FMode:=I;
      ModeRAW:=FMode;
      Mode:=ModeRAW; // В методе SetMode вычисляется значения "EUFlag"
(*
      if NodeType = 0 then    // Для модели РК-131/300;
      begin
        EUFlag:=False;
        EUMode:='Проценты';
      end;
*)
    // Получение данных SP
      MoveMemory(@A[1],@Data[14],4);
      MoveMemory(@R,@Data[14],4);
      if not IsBadValue and EUFlag then
        R:=(R-FSPEULo)*100/(FSPEUHi-FSPEULo);
      if not IsBadValue then
      begin
        SPRAW:=R;
        try
          SP:=RoundTo((FSPEUHi-FSPEULo)*(R/100.0)+FSPEULo,-Ord(FPVFormat));
        except
          SP:=SP;
        end;
      end;
    // Получение данных PV
      MoveMemory(@A[1],@Data[18],4);
      MoveMemory(@R,@Data[18],4);
      if not IsBadValue and EUFlag then
        R:=(R-FPVEULo)*100/(FPVEUHi-FPVEULo);
      if not IsBadValue then
      begin
        PVRAW:=R;
        try
          PV:=RoundTo((PVEUHi-PVEULo)*(R/100.0)+PVEULo,-Ord(FPVFormat));
        except
          PV:=PV;
        end;
      end;
    // Получение данных Delta
      MoveMemory(@A[1],@Data[22],4);
      MoveMemory(@R,@Data[22],4);
      if not IsBadValue and EUFlag then
        R:=(R-FPVEULo)*100/(FPVEUHi-FPVEULo);
      if not IsBadValue then
        FDL:=(FPVEUHi-FPVEULo)*(R/100.0);
    // Получение данных OP
      MoveMemory(@A[1],@Data[26],4);
      MoveMemory(@R,@Data[26],4);
      if not IsBadValue then
      begin
        OPRAW:=R;
        try
          OP:=RoundTo(R,-Ord(FPVFormat));
        except
          OP:=OP;
        end;    
      end;
      ErrorMess:='';
    end;
  //---------------------------------------------------
    StatusOk:=not ((asOpenBadPV in AlarmStatus) or
                   (asShortBadPV in AlarmStatus) or
                   (asNoLink in AlarmStatus));
    if FirstCalc and StatusOk then
    begin
      if FTrend then
        Caddy.AddRealTrend(PtName+'.PV',FPV,False);
      if FTrend then
        Caddy.AddRealTrend(PtName+'.SP',FSP,False);
      if FTrend then
        Caddy.AddRealTrend(PtName+'.OP',FOP,False);
    end;
    FirstCalc:=False;
    if FTrend then
      Caddy.AddRealTrend(PtName+'.PV',FPV,StatusOk);
    if FTrend then
      Caddy.AddRealTrend(PtName+'.SP',FSP,StatusOk);
    if FTrend then
      Caddy.AddRealTrend(PtName+'.OP',FOP,StatusOk);
//---------------------------------------------------
    UpdateRealTime;
  end;
end;

procedure TKontCntReg.SetMode(const Value: Word);
begin
  FMode := Value;
  case ((FMode and $0060) shr 5) of
    0: SPMode:='Нет алгоритма ЗДН';
    1: SPMode:='(ВЗ) Внешнее задание';
    2: SPMode:='(ПЗ) Программное задание';
    3: SPMode:='(РЗ) Ручное задание';
  end;
  case ((FMode and $0010) shr 4) of
    0: AutoMode:='(АУ) Автоматическое управление';
    1: AutoMode:='(РУ) Ручное управление ';
  end;
  case ((FMode and $0008) shr 3) of
    0: CasMode:='Локальный/каскадный режим';
    1: CasMode:='(ДУ) Дистанционный режим';
  end;
  case ((FMode and $0004) shr 2) of
    0: HandMode:='Нет алгоритма РУЧ';
    1: HandMode:='Алгоритм РУЧ имеется';
  end;
  case ((FMode and $0002) shr 1) of
    0: KonturErrors:='Нет';
    1: KonturErrors:='Есть';
  end;
  case ((FMode and $6000) shr 13) of
    0: KonturMode:='Нет алгоритма ЗДЛ';
    1: KonturMode:='(ЛУ) Локальный режим';
    2: KonturMode:='(КУ) Каскадный режим';
    3: KonturMode:='Ошибка данных';
  end;
  EUFlag:=(FMode and $1000) > 0;
  if EUFlag then
    EUMode:='Технические единицы'
  else
    EUMode:='Проценты';
end;

function GetModeShortDesc(const Value: Word): string;
begin
  Result:='';
  case ((Value and $0060) shr 5) of
    1: Result:=Result+'ВЗ';
    2: Result:=Result+'ПЗ';
    3: Result:=Result+'РЗ';
  end;
  if Copy(Result,Length(Result),1) <> ',' then Result:=Result+',';
  case ((Value and $0010) shr 4) of
    0: Result:=Result+'АУ';
    1: Result:=Result+'РУ';
  end;
  if Copy(Result,Length(Result),1) <> ',' then Result:=Result+',';
  case ((Value and $0008) shr 3) of
    1: Result:=Result+'ДУ';
  end;
  if Copy(Result,Length(Result),1) <> ',' then Result:=Result+',';
  case ((Value and $6000) shr 13) of
    1: Result:=Result+'ЛУ';
    2: Result:=Result+'КУ';
  end;
  if Copy(Result,Length(Result),1) = ',' then Delete(Result,Length(Result),1);
end;

procedure TKontCntReg.SendOP(Value: Single);
var sFormat: string;
begin
  LastCommand:='OP';
  sFormat:='%.'+Format('%d',[Ord(FPVFormat)])+'f';
  DecimalSeparator := '.';
  Caddy.AddChange(FPtName,'OP',Format(sFormat,[OP]),Format(sFormat,[Value]),
                              FPtDesc,Caddy.Autor);
  LastTime:=FFetchTime;
  CommandMode:=11;
  CommandData:=Value;
  HasCommand:=True;
end;

procedure TKontCntReg.SendSP(Value: Single);
var sFormat: string;
begin
  LastCommand:='SP';
  sFormat:='%.'+Format('%d',[Ord(FPVFormat)])+'f';
  DecimalSeparator := '.';
  Caddy.AddChange(FPtName,'SP',Format(sFormat,[SP]),Format(sFormat,[Value]),
                              FPtDesc,Caddy.Autor);
  LastTime:=FFetchTime;
  CommandMode:=10;
  CommandData:=Value;
  HasCommand:=True;
end;

procedure TKontCntReg.SendCommand(Value: Byte);
const AMode: array[1..9] of string =
             ('ВЗ','ПЗ','РЗ','АУ','РУ','+ДУ','-ДУ','КУ','ЛУ');
begin
  LastCommand:='MODE';
  Caddy.AddChange(FPtName,'MODE',GetModeShortDesc(Mode),
                          IfThen(Value in [1..9],AMode[Value]),
                                 FPtDesc,Caddy.Autor);
  LastTime:=FFetchTime;
  CommandMode:=Value;
  CommandData:=0;
  HasCommand:=True;
end;

function TKontCntReg.SPText: string;
begin
  if asNoLink in AlarmStatus then
    Result:='------'
  else
    Result:=Format('%.'+IntToStr(Ord(FPVFormat))+'f',[FSP])
end;

function TKontCntReg.OPText: string;
begin
  if asNoLink in AlarmStatus then
    Result:='------'
  else
    Result:=Format('%.'+IntToStr(Ord(FPVFormat))+'f',[FOP])
end;

function TKontCntReg.AddressEqual(E: TEntity): boolean;
begin
  with E as TKontCntReg do
  begin
    Result:=(Channel = Self.Channel) and
            (Node = Self.Node) and
            (Place = Self.Place);
  end;
end;

function TKontCntReg.PropsCount: integer;
begin
  Result:=31;
end;

class function TKontCntReg.PropsID(Index: integer): string;
begin
  case Index of
    0: Result:='PtName';
    1: Result:='PtDesc';
    2: Result:='Channel';
    3: Result:='Node';
    4: Result:='Kontur';
    5: Result:='RegType';
    6: Result:='Active';
    7: Result:='Alarm';
    8: Result:='Confirm';
    9: Result:='Trend';
   10: Result:='FetchTime';
   11: Result:='Source';
   12: Result:='EUDesc';
   13: Result:='FormatPV';
   14: Result:='PVEUHI';
   15: Result:='PVHHTP';
   16: Result:='PVHITP';
   17: Result:='PVLOTP';
   18: Result:='PVLLTP';
   19: Result:='PVEULO';
   20: Result:='BadDB';
   21: Result:='SPEUHI';
   22: Result:='SPEULO';
   23: Result:='PVDHTP';
   24: Result:='PVDLTP';
   25: Result:='CheckSP';
   26: Result:='CheckOP';
   27: Result:='SourceK';
   28: Result:='SourceT1';
   29: Result:='SourceT2';
   30: Result:='CalcScale';
  else
    Result:='Unknown';
  end
end;

class function TKontCntReg.PropsName(Index: integer): string;
begin
  case Index of
    0: Result:='Шифр параметра';
    1: Result:='Десктриптор';
    2: Result:='Канал связи';
    3: Result:='Контроллер';
    4: Result:='Номер контура';
    5: Result:='Тип регулятора';
    6: Result:='Опрос';
    7: Result:='Сигнализация';
    8: Result:='Квитирование';
    9: Result:='Тренд';
   10: Result:='Время опроса';
   11: Result:='Источник данных';
   12: Result:='Размерность';
   13: Result:='Формат PV';
   14: Result:='Верхняя граница шкалы PV';
   15: Result:='Верхняя предаварийная граница';
   16: Result:='Верхняя предупредительная граница';
   17: Result:='Нижняя предупредительная граница';
   18: Result:='Нижняя предаварийная граница';
   19: Result:='Нижняя граница шкалы PV';
   20: Result:='Контроль границ шкалы';
   21: Result:='Верхняя граница шкалы SP';
   22: Result:='Нижняя граница шкалы SP';
   23: Result:='Отклонение PV от SP вверх';
   24: Result:='Отклонение PV от SP вниз';
   25: Result:='Контроль шага изменения SP';
   26: Result:='Контроль шага изменения OP';
   27: Result:='Коэффициент усиления (K)';
   28: Result:='Интегральный коэффициент (T1)';
   29: Result:='Дифференциальный коэффициент (T2)';
   30: Result:='Масштаб по шкале';
  else
    Result:='';
  end
end;

function TKontCntReg.PropsValue(Index: integer): string;
var sFormat: string;
begin
  sFormat:='%.'+Format('%d',[Ord(FPVFormat)])+'f';
  DecimalSeparator := '.';
  case Index of
    0: Result:=FPtName;
    1: Result:=FPtDesc;
    2: Result:=Format('%d',[FChannel]);
    3: Result:=Format('%d',[FNode]);
    4: Result:=Format('%d',[FPlace]);
    5: Result:=ARegType[FRegType];
    6: Result:=IfThen(FActived,'Да','Нет');
    7: Result:=IfThen(FAsked,'Да','Нет');
    8: Result:=IfThen(FLogged,'Да','Нет');
    9: Result:=IfThen(FTrend,'Да','Нет');
   10: Result:=Format('%d сек',[FFetchTime]);
   11: Result:=IfThen(Assigned(FSourceEntity),FSourceName,'Авто');
   12: Result:=FEUDesc;
   13: Result:=Format('D%d',[Ord(FPVFormat)]);
   14: Result:=Format(sFormat,[FPVEUHi]);
   15: Result:=Format(sFormat,[FPVHHTP])+' '+AAlmDB[FHHDB];
   16: Result:=Format(sFormat,[FPVHITP])+' '+AAlmDB[FHIDB];
   17: Result:=Format(sFormat,[FPVLOTP])+' '+AAlmDB[FLODB];
   18: Result:=Format(sFormat,[FPVLLTP])+' '+AAlmDB[FLLDB];
   19: Result:=Format(sFormat,[FPVEULo]);
   20: Result:=AAlmDB[FBadDB];
   21: Result:=Format(sFormat,[FSPEUHi]);
   22: Result:=Format(sFormat,[FSPEULo]);
   23: Result:=Format(sFormat,[FPVDHTP]);
   24: Result:=Format(sFormat,[FPVDLTP]);
   25: Result:=ACtoStr[FCheckSP];
   26: Result:=ACtoStr[FCheckOP];
   27: Result:=IfThen(Assigned(FK),SourceK,'');
   28: Result:=IfThen(Assigned(FT1),SourceT1,'');
   29: Result:=IfThen(Assigned(FT2),SourceT2,'');
   30: Result:=IfThen(FCalcScale,'Да','Нет');
  else
    Result:='';
  end
end;

function TKontCntReg.HasCommandMode: boolean;
begin
  Result:=True;
end;

function TKontCntReg.HasCommandOP: boolean;
begin
  Result:=True;
  case ((FMode and $0010) shr 4) of
   0: Result:=False; //(АУ) Автоматическое управление
  end;
end;

function TKontCntReg.HasCommandSP: boolean;
begin
  Result:=True;
  case ((FMode and $0010) shr 4) of
   1: Result:=False; //(РУ) Ручное управление
  end;
  case ((FMode and $0060) shr 5) of
   0: Result:=False; //Нет алгоритма ЗДН
   1: Result:=False; //(ВЗ) Внешнее задание
   2: Result:=False; //(ПЗ) Программное задание
   3: ; //(РЗ) Ручное задание
  end;
end;

{ TKontCRGroup }

class function TKontCRGroup.EntityType: string;
begin
  Result:='Группа контуров ФАБЛ';
end;

function TKontCRGroup.GetMaxChildCount: integer;
begin
  Result:=4;
end;

function TKontCRGroup.LoadFromStream(Stream: TStream): integer;
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
  FChannel:=Body.Channel;
  FNode:=Body.Node;
  FActived:=Body.Actived;
  FFetchTime:=Body.FetchTime;
  FSourceName:=Body.SourceName;
  FChilds.Clear;
  for i:=0 to 3 do
    if Body.Childs[i]<>'' then FChilds.AddObject(Body.Childs[i],nil);
end;

procedure TKontCRGroup.SaveToStream(Stream: TStream);
var i: integer;
begin
  Body.PtName:=PtName;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Node;
  Body.Actived:=Actived;
  Body.FetchTime:=FetchTime;
  Body.SourceName:=SourceName;
  for i:=0 to 3 do Body.Childs[i]:='';
  for i:=0 to Count-1 do
    if (i in [0..3]) and Assigned(EntityChilds[i]) then
      Body.Childs[i]:=EntityChilds[i].PtName;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

procedure TKontCRGroup.SaveToText(List: TStringList);
var i: Integer;
begin
  List.Append('[' + PtName + ']');
  List.Append('Plugin=KR500');
  List.Append('PtType=GR');
  List.Append('PtKind=3');
  List.Append('PtName=' + PtName);
  List.Append('PtDesc=' + PtDesc);
  List.Append('Channel=' + IntToStr(Channel));
  List.Append('Node=' + IntToStr(Node));
  List.Append('Actived=' + IfThen(Actived, 'True', 'False'));
  List.Append('FetchTime=' + IntToStr(FetchTime));
  List.Append('SourceName=' + SourceName);
  for i:=0 to 3 do
     List.Append(Format('Child%d=%s', [i + 1, Body.Childs[i]]));
end;

procedure TKontCRGroup.SetEntityChilds(Index: Integer;
  const Value: TEntity);
begin
  if Index < Count then
  begin
    if Value <> nil then
    begin
      if FChilds.Objects[Index] <> nil then
        (FChilds.Objects[Index] as TEntity).SourceEntity:=nil;
      Value.SourceEntity:=Self;
      FChilds.Objects[Index]:=Value;
    end
    else
    begin
      if FChilds.Objects[Index] <> nil then
        (FChilds.Objects[Index] as TEntity).SourceEntity:=nil;
      FChilds.Delete(Index);
    end
  end
  else
    if Value <> nil then
    begin
      FChilds.AddObject(Value.PtName,Value);
      Value.SourceEntity:=Self;
    end;
  Caddy.Changed:=True;
end;

class function TKontCRGroup.TypeCode: string;
begin
  Result:='GR';
end;

class function TKontCRGroup.TypeColor: TColor;
begin
  Result:=$00CC99FF;
end;

procedure TKontCRGroup.ConnectLinks;
var i: integer; E: TEntity;
begin
  E:=Caddy.Find(SourceName);
  if Assigned(E) then
    SourceEntity:=E as TCustomGroup
  else
    SourceEntity:=nil;
  for i:=0 to FChilds.Count-1 do
    FChilds.Objects[i]:=Caddy.Find(FChilds[i]);
end;

function TKontCRGroup.Prepare: string;
var S: string; W,i: Word; E: TEntity;
begin
  if FChilds.Count = 0 then
    Result:=''
  else
  begin
    S:=#1#2+Chr(Count);
    for i:=0 to Count-1 do
      if Assigned(EntityChilds[i]) then
      begin
        E:=EntityChilds[i];
        S:=S+Chr(E.Place);
      end;
    W:=Length(S);
    S:=Chr(FNode)+#$fe+Chr(Lo(W))+Chr(Hi(W))+#$40+S;
    Result:=S;
  end;
end;

procedure TKontCRGroup.Fetch(const Data: string);
var i,N: Integer; E: TEntity;
begin
  inherited;
  UpdateRealTime;
  N:=9;
  for i:=0 to Count-1 do
  begin
    if Assigned(EntityChilds[i]) then
    begin
      E:=EntityChilds[i];
      if E.Actived then
        E.Fetch(Copy(Data,1,8)+Copy(Data,N,23));
      E.RealTime:=RealTime;
    end;
    Inc(N,23);
  end;
end;

function TKontCRGroup.PropsCount: integer;
begin
  Result:=10;
end;

class function TKontCRGroup.PropsID(Index: integer): string;
begin
  case Index of
    0: Result:='PtName';
    1: Result:='PtDesc';
    2: Result:='Channel';
    3: Result:='Node';
    4: Result:='Active';
    5: Result:='FetchTime';
    6..9: Result:='Child'+IntToStr(Index-5);
  else
    Result:='Unknown';
  end
end;

class function TKontCRGroup.PropsName(Index: integer): string;
begin
  case Index of
    0: Result:='Шифр параметра';
    1: Result:='Десктриптор';
    2: Result:='Канал связи';
    3: Result:='Контроллер';
    4: Result:='Опрос';
    5: Result:='Время опроса';
    6..9: Result:='Контур '+IntToStr(Index-5);
  else
    Result:='';
  end
end;

function TKontCRGroup.PropsValue(Index: integer): string;
begin
  case Index of
    0: Result:=FPtName;
    1: Result:=FPtDesc;
    2: Result:=Format('%d',[FChannel]);
    3: Result:=Format('%d',[FNode]);
    4: Result:=IfThen(FActived,'Да','Нет');
    5: Result:=Format('%d сек',[FFetchTime]);
    6..9: if (Index-6 < Count) and Assigned(EntityChilds[Index-6]) then
             Result:=Childs[Index-6]
           else
             Result:='';
  else
    Result:='';
  end
end;

{ TKontUPZDateTime }

constructor TKontUPZDateTime.Create;
begin
  inherited;
  FetchIndex:=0;
  FEntityKind:=ekCustom;
  Trend:=False;
  EUDesc:='';
end;

class function TKontUPZDateTime.EntityType: string;
begin
  Result:='Время срабатывания защиты ФАБЛ';
end;

function TKontUPZDateTime.GetTextValue: string;
var dt: TDateTime;
begin
  dt:=Raw;
  Result:=FormatDateTime('dd.mm.yyyy, hh:nn:ss',dt);
end;

function TKontUPZDateTime.Prepare: string;
var S: string; W,i: Word;
begin
  S:=#1#4#6;
  for i:=1 to 6 do
  begin
    W:=Block;
    S:=S+Chr(Lo(W))+Chr(Hi(W))+Chr(i);
  end;
  W:=Length(S);
  S:=Chr(FNode)+#$fe+Chr(Lo(W))+Chr(Hi(W))+#$40+S;
  Result:=S;
end;

procedure TKontUPZDateTime.Fetch(const Data: string);
var i,N: Integer; Sample: string;
    nformat, nInput: Byte; Ir: Integer;
    R,Rv: Single; SI: SmallInt; SH: ShortInt;
    A: array[1..4] of Byte;
    yy,mn,dd,hh,mm,ss: Word;
    mn_max: Word;
begin
  inherited;
  if Length(Data) = 8+6*8 then
  begin
    N:=9;
    yy:=0;
    mn:=1;
    dd:=1;
    hh:=0;
    mm:=0;
    ss:=0;
    for i:=1 to 6 do
    begin
      Sample:=Copy(Data,1,8)+Copy(Data,N,8);
      if Length(Sample) = 16 then
      begin
        if Ord(Sample[12]) = $FF then
        begin
          N:=Ord(Sample[13]);
          ErrorMess:=ErrorToString(N,Format('Сетевая ошибка %d',[N]));
        end
        else
        begin
          ErrorMess:='';
          nInput:=Ord(Sample[11]);
          nformat:=(Ord(Sample[12]) and $7E) shr 1;
          A[1]:=Ord(Sample[13]);
          A[2]:=Ord(Sample[14]);
          A[3]:=Ord(Sample[15]);
          A[4]:=Ord(Sample[16]);
          if (nformat = 0) and (A[1] = 0) and (A[2] = 0) and
                               (A[3] = 160) and (A[4] = 127) then
          begin
            Raw:=0;
            ErrorMess:='Принятое значение не число!';
            Exit;
          end;
          Rv:=0;
          case nformat of
            0: begin
                 MoveMemory(@R,@Sample[13],4);
                 Rv:=R;
               end;
            1: begin
                 MoveMemory(@SI,@Sample[13],2);
                 Rv:=SI*1.0;
               end;
            3: begin
                 MoveMemory(@SH,@Sample[13],1);
                 Rv:=SH*1.0;
               end;
            4: begin
                 MoveMemory(@Ir,@Sample[13],4);
                 Rv:=Ir*1.0;
               end;
            5: begin
                 MoveMemory(@R,@Sample[13],4);
                 Rv:=R;
               end;
          else
            Raw:=0;
            ErrorMess:=Format('Недопустимый формат: %d',[nformat]);
            Exit;
          end;
          if (nformat <= 5) then
          begin
            case nInput of
              1: yy:=Math.EnsureRange(Math.Ceil(Rv),1,9999);
              2: mn:=Math.EnsureRange(Math.Ceil(Rv),1,12);
              3: dd:=Math.EnsureRange(Math.Ceil(Rv),1,31);
              4: hh:=Math.EnsureRange(Math.Ceil(Rv),0,23);
              5: mm:=Math.EnsureRange(Math.Ceil(Rv),0,59);
              6: ss:=Math.EnsureRange(Math.Ceil(Rv),0,59);
            end;
          end;
        end;
      end;
      Inc(N,8);
    end;
    UpdateRealTime;
    try
      if (yy < 2000) then yy:=yy+2000;
      mn_max:=DaysInAMonth(yy,mn);
      if (dd > mn_max) then dd:=mn_max;
      Raw:=EncodeDateTime(yy,mn,dd,hh,mm,ss,0);
      ErrorMess:='';
    except
      on E: Exception do
        begin
          Raw:=0;
          ErrorMess:=E.Message;
        end;
    end;
  end;
end;

function TKontUPZDateTime.LoadFromStream(Stream: TStream): integer;
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
  FChannel:=Body.Channel;
  FNode:=Body.Node;
  FBlock:=Body.Block;
  FActived:=Body.Actived;
  FFetchTime:=Body.FetchTime;
end;

procedure TKontUPZDateTime.SaveToStream(Stream: TStream);
begin
  Body.PtName:=PtName;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Node;
  Body.Block:=Block;
  Body.Actived:=Actived;
  Body.FetchTime:=FetchTime;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

procedure TKontUPZDateTime.SaveToText(List: TStringList);
begin
  List.Append('[' + PtName + ']');
  List.Append('Plugin=KR500');
  List.Append('PtType=UD');
  List.Append('PtKind=3');
  List.Append('PtName=' + PtName);
  List.Append('PtDesc=' + PtDesc);
  List.Append('Channel=' + IntToStr(Channel));
  List.Append('Node=' + IntToStr(Node));
  List.Append('Block=' + IntToStr(Block));
  List.Append('Actived=' + IfThen(Actived, 'True', 'False'));
  List.Append('FetchTime=' + IntToStr(FetchTime));
end;

class function TKontUPZDateTime.TypeCode: string;
begin
  Result:='UD';
end;

class function TKontUPZDateTime.TypeColor: TColor;
begin
  Result:=$00CC99FF;
end;

function TKontUPZDateTime.PropsCount: integer;
begin
  Result:=7;
end;

class function TKontUPZDateTime.PropsID(Index: integer): string;
begin
  case Index of
    0: Result:='PtName';
    1: Result:='PtDesc';
    2: Result:='Channel';
    3: Result:='Node';
    4: Result:='Block';
    5: Result:='Active';
    6: Result:='FetchTime';
  else
    Result:='Unknown';
  end
end;

class function TKontUPZDateTime.PropsName(Index: integer): string;
begin
  case Index of
    0: Result:='Шифр параметра';
    1: Result:='Десктриптор';
    2: Result:='Канал связи';
    3: Result:='Контроллер';
    4: Result:='Алгоблок';
    5: Result:='Опрос';
    6: Result:='Время опроса';
  else
    Result:='';
  end
end;

function TKontUPZDateTime.PropsValue(Index: integer): string;
begin
  case Index of
    0: Result:=FPtName;
    1: Result:=FPtDesc;
    2: Result:=Format('%d',[FChannel]);
    3: Result:=Format('%d',[FNode]);
    4: Result:=Format('%d',[FBlock]);
    5: Result:=IfThen(FActived,'Да','Нет');
    6: Result:=Format('%d сек',[FFetchTime]);
  else
    Result:='';
  end
end;

{ TKontOutputsGroup }

class function TKontOutputsGroup.EntityType: string;
begin
  Result:='Группа выходов ФАБЛ';
end;

function TKontOutputsGroup.Prepare: string;
var S: string; W,i: Word; E: TEntity;
begin
  if FChilds.Count = 0 then
    Result:=''
  else
  begin
    S:=#1#4+Chr(Count);
    for i:=0 to Count-1 do
      if Assigned(EntityChilds[i]) then
      begin
        E:=EntityChilds[i];
        W:=E.Block;
        S:=S+Chr(Lo(W))+Chr(Hi(W))+Chr(E.Place);
      end;
    W:=Length(S);
    S:=Chr(FNode)+#$fe+Chr(Lo(W))+Chr(Hi(W))+#$40+S;
    Result:=S;
  end;
end;

procedure TKontOutputsGroup.Fetch(const Data: string);
var i,N: Integer; E: TEntity;
begin
  inherited;
  if Length(Data) = 8+Count*8 then
  begin
    N:=9;
    for i:=0 to Count-1 do
    begin
      if Assigned(EntityChilds[i]) then
      begin
        E:=EntityChilds[i];
        if E.Actived then
          E.Fetch(Copy(Data,1,8)+Copy(Data,N,8));
        E.RealTime:=RealTime;
      end;
      Inc(N,8);
    end;
  end;
end;

function TKontOutputsGroup.GetMaxChildCount: integer;
begin
  Result:=14;
end;

function TKontOutputsGroup.LoadFromStream(Stream: TStream): integer;
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
  FChannel:=Body.Channel;
  FNode:=Body.Node;
  FActived:=Body.Actived;
  FFetchTime:=Body.FetchTime;
  FSourceName:=Body.SourceName;
  FChilds.Clear;
  for i:=0 to 13 do
    if Body.Childs[i]<>'' then FChilds.AddObject(Body.Childs[i],nil);
end;

procedure TKontOutputsGroup.SaveToStream(Stream: TStream);
var i: integer;
begin
  Body.PtName:=PtName;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Node;
  Body.Actived:=Actived;
  Body.FetchTime:=FetchTime;
  Body.SourceName:=SourceName;
  for i:=0 to 13 do Body.Childs[i]:='';
  for i:=0 to Count-1 do
    if (i in [0..13]) and  Assigned(EntityChilds[i]) then
      Body.Childs[i]:=EntityChilds[i].PtName;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

procedure TKontOutputsGroup.SaveToText(List: TStringList);
var i: Integer;
begin
  List.Append('[' + PtName + ']');
  List.Append('Plugin=KR500');
  List.Append('PtType=GO');
  List.Append('PtKind=3');
  List.Append('PtName=' + PtName);
  List.Append('PtDesc=' + PtDesc);
  List.Append('Channel=' + IntToStr(Channel));
  List.Append('Node=' + IntToStr(Node));
  List.Append('Actived=' + IfThen(Actived, 'True', 'False'));
  List.Append('FetchTime=' + IntToStr(FetchTime));
  List.Append('SourceName=' + SourceName);
  for i:=0 to 13 do
     List.Append(Format('Child%d=%s', [i + 1, Body.Childs[i]]));
end;

class function TKontOutputsGroup.TypeCode: string;
begin
  Result:='GO';
end;

class function TKontOutputsGroup.TypeColor: TColor;
begin
  Result:=$00CC99FF;
end;

function TKontOutputsGroup.PropsCount: integer;
begin
  Result:=20;
end;

class function TKontOutputsGroup.PropsID(Index: integer): string;
begin
  case Index of
    0: Result:='PtName';
    1: Result:='PtDesc';
    2: Result:='Channel';
    3: Result:='Node';
    4: Result:='Active';
    5: Result:='FetchTime';
    6..19: Result:='Child'+IntToStr(Index-5);
  else
    Result:='Unknown';
  end
end;

class function TKontOutputsGroup.PropsName(Index: integer): string;
begin
  case Index of
    0: Result:='Шифр параметра';
    1: Result:='Десктриптор';
    2: Result:='Канал связи';
    3: Result:='Контроллер';
    4: Result:='Опрос';
    5: Result:='Время опроса';
    6..19: Result:='Выход '+IntToStr(Index-5);
  else
    Result:='';
  end
end;

function TKontOutputsGroup.PropsValue(Index: integer): string;
begin
  case Index of
    0: Result:=FPtName;
    1: Result:=FPtDesc;
    2: Result:=Format('%d',[FChannel]);
    3: Result:=Format('%d',[FNode]);
    4: Result:=IfThen(FActived,'Да','Нет');
    5: Result:=Format('%d сек',[FFetchTime]);
    6..19: if (Index-6 < Count) and Assigned(EntityChilds[Index-6]) then
             Result:=Childs[Index-6]
           else
             Result:='';
  else
    Result:='';
  end
end;

{ TKontParamsGroup }

class function TKontParamsGroup.EntityType: string;
begin
  Result:='Группа параметров ФАБЛ';
end;

function TKontParamsGroup.Prepare: string;
var S: string; W,i: Word; E: TEntity;
begin
  if FChilds.Count = 0 then
    Result:=''
  else
  begin
    S:=#1#1+Chr(Count);
    for i:=0 to Count-1 do
      if Assigned(EntityChilds[i]) then
      begin
        E:=EntityChilds[i];
        W:=E.Block;
        S:=S+Chr(Lo(W))+Chr(Hi(W))+Chr(E.Place);
      end;
    W:=Length(S);
    S:=Chr(FNode)+#$fe+Chr(Lo(W))+Chr(Hi(W))+#$40+S;
    Result:=S;
  end;
end;

procedure TKontParamsGroup.Fetch(const Data: string);
var i,N: Integer; E: TEntity;
begin
  inherited;
  if Length(Data) = 8+Count*8 then
  begin
    N:=9;
    for i:=0 to Count-1 do
    begin
      if Assigned(EntityChilds[i]) then
      begin
        E:=EntityChilds[i];
        if E.Actived then
          E.Fetch(Copy(Data,1,8)+Copy(Data,N,8));
        E.RealTime:=RealTime;
      end;
      Inc(N,8);
    end;
  end;
end;

function TKontParamsGroup.GetMaxChildCount: integer;
begin
  Result:=14;
end;

function TKontParamsGroup.LoadFromStream(Stream: TStream): integer;
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
  FChannel:=Body.Channel;
  FNode:=Body.Node;
  FActived:=Body.Actived;
  FFetchTime:=Body.FetchTime;
  FSourceName:=Body.SourceName;
  FChilds.Clear;
  for i:=0 to 13 do
    if Body.Childs[i]<>'' then FChilds.AddObject(Body.Childs[i],nil);
end;

procedure TKontParamsGroup.SaveToStream(Stream: TStream);
var i: integer;
begin
  Body.PtName:=PtName;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Node;
  Body.Actived:=Actived;
  Body.FetchTime:=FetchTime;
  Body.SourceName:=SourceName;
  for i:=0 to 13 do Body.Childs[i]:='';
  for i:=0 to Count-1 do
    if (i in [0..13]) and Assigned(EntityChilds[i]) then
      Body.Childs[i]:=EntityChilds[i].PtName;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

procedure TKontParamsGroup.SaveToText(List: TStringList);
var i: Integer;
begin
  List.Append('[' + PtName + ']');
  List.Append('Plugin=KR500');
  List.Append('PtType=GP');
  List.Append('PtKind=3');
  List.Append('PtName=' + PtName);
  List.Append('PtDesc=' + PtDesc);
  List.Append('Channel=' + IntToStr(Channel));
  List.Append('Node=' + IntToStr(Node));
  List.Append('Actived=' + IfThen(Actived, 'True', 'False'));
  List.Append('FetchTime=' + IntToStr(FetchTime));
  List.Append('SourceName=' + SourceName);
  for i:=0 to 13 do
     List.Append(Format('Child%d=%s', [i + 1, Body.Childs[i]]));
end;

class function TKontParamsGroup.TypeCode: string;
begin
  Result:='GP';
end;

class function TKontParamsGroup.TypeColor: TColor;
begin
  Result:=$00CC99FF;
end;

function TKontParamsGroup.PropsCount: integer;
begin
  Result:=20;
end;

class function TKontParamsGroup.PropsID(Index: integer): string;
begin
  case Index of
    0: Result:='PtName';
    1: Result:='PtDesc';
    2: Result:='Channel';
    3: Result:='Node';
    4: Result:='Active';
    5: Result:='FetchTime';
    6..19: Result:='Child'+IntToStr(Index-5);
  else
    Result:='Unknown';
  end
end;

class function TKontParamsGroup.PropsName(Index: integer): string;
begin
  case Index of
    0: Result:='Шифр параметра';
    1: Result:='Десктриптор';
    2: Result:='Канал связи';
    3: Result:='Контроллер';
    4: Result:='Опрос';
    5: Result:='Время опроса';
    6..19: Result:='Параметр '+IntToStr(Index-5);
  else
    Result:='';
  end
end;

function TKontParamsGroup.PropsValue(Index: integer): string;
begin
  case Index of
    0: Result:=FPtName;
    1: Result:=FPtDesc;
    2: Result:=Format('%d',[FChannel]);
    3: Result:=Format('%d',[FNode]);
    4: Result:=IfThen(FActived,'Да','Нет');
    5: Result:=Format('%d сек',[FFetchTime]);
    6..19: if (Index-6 < Count) and Assigned(EntityChilds[Index-6]) then
             Result:=Childs[Index-6]
           else
             Result:='';
  else
    Result:='';
  end
end;

{ TKontFDGroup }

constructor TKontFDGroup.Create;
var i: integer;
begin
  inherited;
  for i:=0 to 31 do EntityChilds[i]:=nil;
end;

class function TKontFDGroup.EntityType: string;
begin
  Result:='Дешифратор ФАБЛ';
end;

function TKontFDGroup.Prepare: string;
var S: string; W: Word;
begin
  W:=FBlock;
  S:=#1#4#1+Chr(Lo(W))+Chr(Hi(W))+Chr(FPlace);
  W:=Length(S);
  S:=Chr(FNode)+#$fe+Chr(Lo(W))+Chr(Hi(W))+#$40+S;
  Result:=S;
end;

procedure TKontFDGroup.Fetch(const Data: string);
var nformat: Byte; N: Integer; R: Single;
begin
  inherited;
  if Length(Data) = 16 then
  begin
    if Ord(Data[12]) = $FF then
    begin
      N:=Ord(Data[13]);
      ErrorMess:=ErrorToString(N,Format('Сетевая ошибка %d',[N]));
    end
    else
    begin
      ErrorMess:='';
      nformat:=(Ord(Data[12]) and $7E) shr 1;
      DataFormat:=EnsureRange(nformat,Low(TFablFormat),High(TFablFormat));
      MoveMemory(@R,@Data[13],4);
      case nformat of
        6: Decode(R); //Raw:=R;
      else
        ErrorMess:=Format('Недопустимый формат: %d',[nformat]);
      end;
    end;
  end;
  UpdateRealTime;
end;

function TKontFDGroup.GetMaxChildCount: integer;
begin
  Result:=31;
end;

function TKontFDGroup.LoadFromStream(Stream: TStream): integer;
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
  FChannel:=Body.Channel;
  FNode:=Body.Node;
  FBlock:=Body.Block;
  FActived:=Body.Actived;
  FFetchTime:=Body.FetchTime;
  FSourceName:=Body.SourceName;
  FChilds.Clear;
  for i:=0 to 31 do FChilds.AddObject(Body.Childs[i],nil);
end;

procedure TKontFDGroup.SaveToStream(Stream: TStream);
var i: integer;
begin
  Body.PtName:=PtName;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Node;
  Body.Block:=Block;
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

procedure TKontFDGroup.SaveToText(List: TStringList);
var i: Integer;
begin
  List.Append('[' + PtName + ']');
  List.Append('Plugin=KR500');
  List.Append('PtType=FD');
  List.Append('PtKind=3');
  List.Append('PtName=' + PtName);
  List.Append('PtDesc=' + PtDesc);
  List.Append('Channel=' + IntToStr(Channel));
  List.Append('Node=' + IntToStr(Node));
  List.Append('Block=' + IntToStr(Block));
  List.Append('Actived=' + IfThen(Actived, 'True', 'False'));
  List.Append('FetchTime=' + IntToStr(FetchTime));
  List.Append('SourceName=' + SourceName);
  for i:=0 to 31 do
     List.Append(Format('Child%d=%s', [i + 1, Body.Childs[i]]));
end;

procedure TKontFDGroup.Decode(Value: Single);
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
//  inherited SetRaw(Data*1.0);
  inherited SetRaw(Value);
end;

procedure TKontFDGroup.SetRaw(const Value: Double);
begin
  // Stub
end;

class function TKontFDGroup.TypeCode: string;
begin
  Result:='FD';
end;

class function TKontFDGroup.TypeColor: TColor;
begin
  Result:=$00CC99FF;
end;

function TKontFDGroup.GetTextValue: string;
var I: Cardinal; R: Single;
begin
  R:=Raw;
  MoveMemory(@I,@R,4);
  Result:=IntToHex(I,8);
end;

function TKontFDGroup.AddressEqual(E: TEntity): boolean;
begin
  with E as TKontFDGroup do
  begin
    Result:=(Channel = Self.Channel) and
            (Node = Self.Node) and
            (Block = Self.Block);
  end;
end;

function TKontFDGroup.GetPtVal: string;
var I: Cardinal; R: Single;
begin
  R:=Raw;
  MoveMemory(@I,@R,4);
  Result:=IntToHex(I,8);
end;

function TKontFDGroup.PropsCount: integer;
begin
  Result:=40;
end;

class function TKontFDGroup.PropsID(Index: integer): string;
begin
  case Index of
    0: Result:='PtName';
    1: Result:='PtDesc';
    2: Result:='Channel';
    3: Result:='Node';
    4: Result:='Algoblock';
    5: Result:='Active';
    6: Result:='Fetch';
    7: Result:='Source';
    8..39: Result:='Child'+IntToStr(Index-7);
  else
    Result:='Unknown';
  end
end;

class function TKontFDGroup.PropsName(Index: integer): string;
begin
  case Index of
    0: Result:='Шифр параметра';
    1: Result:='Десктриптор';
    2: Result:='Канал связи';
    3: Result:='Контроллер';
    4: Result:='Алгоблок';
    5: Result:='Опрос';
    6: Result:='Время опроса';
    7: Result:='Источник данных';
    8..39: Result:='Выход '+IntToStr(Index-7);
  else
    Result:='';
  end
end;

function TKontFDGroup.PropsValue(Index: integer): string;
begin
  case Index of
    0: Result:=FPtName;
    1: Result:=FPtDesc;
    2: Result:=Format('%d',[FChannel]);
    3: Result:=Format('%d',[FNode]);
    4: Result:=Format('%d',[FBlock]);
    5: Result:=IfThen(FActived,'Да','Нет');
    6: Result:=Format('%d сек',[FFetchTime]);
    7: Result:=IfThen(Assigned(FSourceEntity),FSourceName,'Авто');
    8..39: if (Index-8 < Count) and Assigned(EntityChilds[Index-8]) then
             Result:=Childs[Index-8]
           else
             Result:='';
  else
    Result:='';
  end
end;

{ TKontKDGroup }

constructor TKontKDGroup.Create;
var i: integer;
begin
  inherited;
  for i:=0 to 29 do EntityChilds[i]:=nil;
end;

class function TKontKDGroup.EntityType: string;
begin
  Result:='Концентратор данных ФАБЛ';
end;

function TKontKDGroup.Prepare: string;
var S: string; W: Word;
begin
  W:=FBlock;
  S:=#1#14+Chr(Lo(W))+Chr(Hi(W));
  W:=Length(S);
  S:=Chr(FNode)+#$fe+Chr(Lo(W))+Chr(Hi(W))+#$40+S;
  Result:=S;
end;

procedure TKontKDGroup.Fetch(const Data: string);
var i,j,N,L: integer; S: string; E,G: TEntity; R: Single;
begin
  inherited;
  ErrorMess:='';
  if (Length(Data) = 9) and (Ord(Data[5]) and $C0 = $C0) then
  begin
    N:=Ord(Data[8])+256*Ord(Data[9]);
    ErrorMess:=ErrorToString(N,Format('Сетевая ошибка %d',[N]));
    for i:=0 to Count-1 do
    if Assigned(EntityChilds[i]) then
    begin
      E:=EntityChilds[i];
      E.ErrorMess:='Концентратор '+PtName+': '+ErrorMess;
      E.RealTime:=0;
      if E is TCustomGroup then
      with E as TCustomGroup do
      for j:=0 to Count-1 do
      if Assigned(EntityChilds[j]) then
      begin
        G:=EntityChilds[j];
        G.ErrorMess:=E.ErrorMess;
        G.RealTime:=0;
      end;
    end;
    UpdateRealTime;
    Exit;
  end;
  ErrorMess:='';
  N:=8;
  L:=(Length(Data)-7) div 4;
  for i:=0 to L-1 do
  begin
    if Assigned(EntityChilds[i]) then
    begin
      E:=EntityChilds[i];
      if E.Actived then
      begin
        E.RealTime:=RealTime;
        S:=Copy(Data,N,4);
        if Length(S) = 4 then
        begin
          MoveMemory(@R,@S[1],4);
          if E is TCustomAnaOut then
            E.Raw:=R
          else
          if E is TCustomDigOut then
            E.Raw:=Abs(Integer(Ord(S[1])>0))
          else
          if E is TCustomGroup then
          begin
            MoveMemory(@R,@S[1],4);
            //E.Raw:=R;
            TCustomGroup(E).Decode(R);
          end;
        end
        else
          ErrorMess:='Ошибка длины телеграммы';
      end
      else
        E.RealTime:=0;
    end;
    Inc(N,4);
  end;
  UpdateRealTime;
end;

function TKontKDGroup.GetMaxChildCount: integer;
begin
  Result:=29;
end;

function TKontKDGroup.LoadFromStream(Stream: TStream): integer;
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
  FChannel:=Body.Channel;
  FNode:=Body.Node;
  FBlock:=Body.Block;
  FActived:=Body.Actived;
  FFetchTime:=Body.FetchTime;
  FChilds.Clear;
  for i:=0 to 29 do FChilds.AddObject(Body.Childs[i],nil);
end;

procedure TKontKDGroup.SaveToStream(Stream: TStream);
var i: integer;
begin
  Body.PtName:=PtName;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Node;
  Body.Block:=Block;
  Body.Actived:=Actived;
  Body.FetchTime:=FetchTime;
  for i:=0 to 29 do Body.Childs[i]:='';
  for i:=0 to Count-1 do
  if i in [0..29] then
  begin
    if Assigned(EntityChilds[i]) then
      Body.Childs[i]:=EntityChilds[i].PtName;
  end;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

procedure TKontKDGroup.SaveToText(List: TStringList);
var i: Integer;
begin
  List.Append('[' + PtName + ']');
  List.Append('Plugin=KR500');
  List.Append('PtType=KD');
  List.Append('PtKind=3');
  List.Append('PtName=' + PtName);
  List.Append('PtDesc=' + PtDesc);
  List.Append('Channel=' + IntToStr(Channel));
  List.Append('Node=' + IntToStr(Node));
  List.Append('Block=' + IntToStr(Block));
  List.Append('Actived=' + IfThen(Actived, 'True', 'False'));
  List.Append('FetchTime=' + IntToStr(FetchTime));
  List.Append('SourceName=' + SourceName);
  for i:=0 to 29 do
     List.Append(Format('Child%d=%s', [i + 1, Body.Childs[i]]));
end;

class function TKontKDGroup.TypeCode: string;
begin
  Result:='KD';
end;

class function TKontKDGroup.TypeColor: TColor;
begin
  Result:=$00CC99FF;
end;

function TKontKDGroup.AddressEqual(E: TEntity): boolean;
begin
  with E as TKontKDGroup do
  begin
    Result:=(Channel = Self.Channel) and
            (Node = Self.Node) and
            (Block = Self.Block);
  end;
end;

function TKontKDGroup.PropsCount: integer;
begin
  Result:=37;
end;

class function TKontKDGroup.PropsID(Index: integer): string;
begin
  case Index of
    0: Result:='PtName';
    1: Result:='PtDesc';
    2: Result:='Channel';
    3: Result:='Node';
    4: Result:='AlgoBuff';
    5: Result:='Active';
    6: Result:='FetchTime';
    7..36: Result:='Child'+IntToStr(Index-6);
  else
    Result:='Unknown';
  end
end;

class function TKontKDGroup.PropsName(Index: integer): string;
begin
  case Index of
    0: Result:='Шифр параметра';
    1: Result:='Десктриптор';
    2: Result:='Канал связи';
    3: Result:='Контроллер';
    4: Result:='Алгоблок|Номер буфера';
    5: Result:='Опрос';
    6: Result:='Время опроса';
    7..36: Result:='Выход '+IntToStr(Index-6);
  else
    Result:='';
  end
end;

function TKontKDGroup.PropsValue(Index: integer): string;
begin
  case Index of
    0: Result:=FPtName;
    1: Result:=FPtDesc;
    2: Result:=Format('%d',[FChannel]);
    3: Result:=Format('%d',[FNode]);
    4: Result:=Format('%d',[FBlock]);
    5: Result:=IfThen(FActived,'Да','Нет');
    6: Result:=Format('%d сек',[FFetchTime]);
    7..36: if (Index-7 < Count) and Assigned(EntityChilds[Index-7]) then
             Result:=Childs[Index-7]
           else
             Result:='';
  else
    Result:='';
  end
end;

{ TKontNode }

constructor TKontNode.Create;
begin
  inherited;
  FetchIndex:=0;
  FEntityKind:=ekCustom;
  FIsCustom:=True;
end;

class function TKontNode.EntityType: string;
begin
  Result:='Контроллер "КОНТРАСТ"';
end;

function TKontNode.Prepare: string;
begin
  if Caddy.NetRole = nrClient then
  begin
    SetLength(Result,SizeOf(CommandData));
    MoveMemory(@Result[1],@CommandData,SizeOf(CommandData));
    Exit;
  end
  else
  if HasCommand then
    Result:=Chr(FNode)+#$fe#2#0#$50#4#21
  else
  begin
    case FetchIndex of
     // Запрос типа контроллера
     0: Result:=Chr(FNode)+#$fe#2#0#$40#4#21;
     // Запрос режима работы
     1: Result:=Chr(FNode)+#$fe#2#0#$40#4#1;
     // Дата и время контроллера
     2: Result:=Chr(FNode)+#$fe#2#0#$40#1#6;
     // Ошибки контроллера
     3: Result:=Chr(FNode)+#$fe#2#0#$40#1#9;
    end;
  end;
end;

procedure TKontNode.Fetch(const Data: string);
var k,i,j: integer; Found: boolean; Err,Len: integer; S,So,W: string;
    NE: TNodeError; M1,M2: TMemoryStream;
begin
  if Caddy.NetRole = nrClient then
  begin
    M1:=TMemoryStream.Create;
    M2:=TMemoryStream.Create;
    try
      try
        M2.SetSize(Length(Data));
        MoveMemory(M2.Memory,@Data[1],Length(Data));
        DecompressStream(M2,M1);
        if M1.Size = SizeOf(NE) then
        begin
          M1.Position:=0;
          M1.ReadBuffer(NE,SizeOf(NE));
          NE.ErrCount:=0;
          for j:=0 to 14 do
          begin
            if NE.ErrInfo[j].ErrType > 0 then
              NE.ErrCount:=NE.ErrCount+1;
            Found:=False;
            for i:=0 to 14 do with errController do
            begin
              if (ErrInfo[i].ErrType = NE.ErrInfo[j].ErrType) and
                 (ErrInfo[i].ErrPlace = NE.ErrInfo[j].ErrPlace) and
                 (ErrInfo[i].When = NE.ErrInfo[j].When) then
              begin
                 Found:=True;
                 Break;
              end;
            end;
            if not Found then with errController do
            begin
              Err:=ErrInfo[j].ErrType;
              if (Err and $80) > 0 then So:='Отказ' else So:='Ошибка';
              W:=FormatDateTime('dd.mm.yy hh:nn',ErrInfo[j].When);
              S:=Format('%d(%3.3d)',[Err and $7F,ErrInfo[j].ErrPlace]);
              if Err > 0 then
                Caddy.AddAlarm(PtName,So,W,S,
                   GetSourceText(NodeType, Err, ErrInfo[j].ErrPlace), PtDesc);
            end;
          end;
          if NE.ErrCount > 0 then
          begin
            if not (asInfo in AlarmStatus)then
              Caddy.AddAlarm(asInfo,Self);
          end
          else
          begin
            if (asInfo in AlarmStatus)then
              Caddy.RemoveAlarm(asInfo,Self);
          end;
          ErrController:=NE;
          UpdateRealTime;
        end;
      except
        Exit;
      end;
    finally
      M2.Free;
      M1.Free;
    end;
    Exit;
  end;
  inherited;
  if HasCommand then
  begin
    HasCommand:=False;
    if Length(Data) = 8 then
    begin
      ErrorMess:='Журнал ошибок контроллера очищен.';
      Caddy.AddChange(FPtName,'LOG','','',ErrorMess,'Автономно');
      Caddy.ShowMessage(kmInfo,ErrorMess);
      Windows.Beep(500,100);
    end;
    LastTime:=FFetchTime+1;
  end
  else
  begin
    ErrorMess:='';
    case FetchIndex of
     0: begin // Запрос типа контроллера
          Len := Length(Data);
          if Len = 8 then
          begin
            if Ord(Data[8]) in [0..20] then
              errController.NodeType:=Ord(Data[8])
            else
            begin
              errController.NodeType:= 0;
              ErrorMess:=Format('Запрос вернул тип контроллера: %d', [Ord(Data[8])]);
            end;
          end;
          FetchIndex:=1;
        end;
     1: begin // Запрос режима работы
          Len := Length(Data);
          if Len = 8 then
          begin
            errController.Mode:=((Ord(Data[8]) and $01) > 0);
            errController.Status:=((Ord(Data[8]) and $80) > 0);
          end;
          FetchIndex:=2;
        end;
     2: begin // Дата и время контроллера
          Len := Length(Data);
          if Len = 14 then
          begin
            errController.Year:=Ord(Data[8]) and $7f;
            errController.Month:=Ord(Data[9]);
            errController.Day:=Ord(Data[10]);
            errController.WeekDay:=Ord(Data[11]);
            errController.Hour:=Ord(Data[12]);
            errController.Minute:=Ord(Data[13]);
            errController.Second:=Ord(Data[14]);
          end;
          FetchIndex:=3;
        end;
     3: begin // Ошибки контроллера
          Len := Length(Data);
          case errController.NodeType of
          0,1: if Len = 127 then
               begin
                 k:=8;
                 for j:=0 to 14 do
                   errController.LastErrInfo[j]:=errController.ErrInfo[j];
                 errController.ErrCount:=0;
                 for j:=0 to 14 do
                 begin
                   errController.ErrInfo[j].ErrType:=Ord(Data[k]);
                   errController.ErrInfo[j].ErrPlace:=
                                        Ord(Data[k+1])+256*Ord(Data[k+2]);
                   if errController.ErrInfo[j].ErrType > 0 then
                   begin
                     errController.ErrCount:=errController.ErrCount+1;
                     if (Ord(Data[k+3]) in [1..12]) and
                        (Ord(Data[k+4]) in [1..31]) and
                        (Ord(Data[k+5]) in [0..23]) and
                        (Ord(Data[k+6]) in [0..59]) and
                        (Ord(Data[k+7]) in [0..59]) then
                       errController.ErrInfo[j].When:=
                        EncodeDate(2000+errController.Year,
                                Ord(Data[k+3]),Ord(Data[k+4]))+
                        EncodeTime(Ord(Data[k+5]),Ord(Data[k+6]),
                                Ord(Data[k+7]),0)
                     else
                        ErrorMess:='Неверный формат даты';
                   end;
                   Found:=False;
                   for i:=0 to 14 do with errController do
                   begin
                     if (ErrInfo[j].ErrType = LastErrInfo[i].ErrType) and
                        (ErrInfo[j].ErrPlace = LastErrInfo[i].ErrPlace) and
                        (ErrInfo[j].When = LastErrInfo[i].When) then
                     begin
                       Found:=True;
                       Break;
                     end;
                   end;
                   if not Found then with errController do
                   begin
                     Err:=ErrInfo[j].ErrType;
                     if (Err and $80) > 0 then So:='Отказ' else So:='Ошибка';
                     W:=FormatDateTime('dd.mm.yy hh:nn',ErrInfo[j].When);
                     S:=Format('%d(%3.3d)',[Err and $7F,ErrInfo[j].ErrPlace]);
                     if Err > 0 then Caddy.AddAlarm(PtName,So,W,S,
                        GetSourceText(NodeType,Err,ErrInfo[j].ErrPlace),PtDesc);
                   end;
                   Inc(k,8);
                 end;
                 if errController.ErrCount > 0 then
                 begin
                   if not (asInfo in AlarmStatus)then
                     Caddy.AddAlarm(asInfo,Self);
                 end
                 else
                 begin
                   if (asInfo in AlarmStatus)then
                     Caddy.RemoveAlarm(asInfo,Self);
                 end;
               end;
          2,4: if Len = 124 then // KR-300I, KR-500
               begin
                 k:=8;
                 for j:=0 to 8 do
                   errController.LastErrInfo[j]:=errController.ErrInfo[j];
                 errController.ErrCount:=0;
                 for j:=0 to 8 do
                 begin
                   errController.ErrInfo[j].ErrType:=Ord(Data[k]);
                   errController.ErrInfo[j].ErrPlace:=
                                          Ord(Data[k+1])+256*Ord(Data[k+2]);
                   if errController.ErrInfo[j].ErrType > 0 then
                   begin
                     errController.ErrCount:=errController.ErrCount+1;
                     if (Ord(Data[k+3]) in [1..12]) and
                        (Ord(Data[k+4]) in [1..31]) and
                        (Ord(Data[k+5]) in [0..23]) and
                        (Ord(Data[k+6]) in [0..59]) and
                        (Ord(Data[k+7]) in [0..59]) then
                       errController.ErrInfo[j].When:=
                        EncodeDate(2000+errController.Year,
                                Ord(Data[k+3]),Ord(Data[k+4]))+
                        EncodeTime(Ord(Data[k+5]),Ord(Data[k+6]),
                                Ord(Data[k+7]),0)
                     else
                        ErrorMess:='Неверный формат даты';
                   end;
                   Found:=False;
                   for i:=0 to 8 do with errController do
                   begin
                     if (ErrInfo[j].ErrType = LastErrInfo[i].ErrType) and
                        (ErrInfo[j].ErrPlace = LastErrInfo[i].ErrPlace) and
                        (ErrInfo[j].When = LastErrInfo[i].When) then
                     begin
                       Found:=True;
                       Break;
                     end;
                   end;
                   if not Found then with errController do
                   begin
                     Err:=ErrInfo[j].ErrType;
                     if (Err and $80) > 0 then So:='Отказ' else So:='Ошибка';
                     W:=FormatDateTime('dd.mm.yy hh:nn',ErrInfo[j].When);
                     S:=Format('%d(%3.3d)',[Err and $7F,ErrInfo[j].ErrPlace]);
                     if Err > 0 then
                       Caddy.AddAlarm(PtName,So,W,S,
                           GetSourceText(NodeType,Err,ErrInfo[j].ErrPlace),
                           PtDesc);
                   end;
                   Inc(k,13);
                 end;
                 if errController.ErrCount > 0 then
                 begin
                   if not (asInfo in AlarmStatus)then
                     Caddy.AddAlarm(asInfo,Self);
                 end
                 else
                 begin
                   if (asInfo in AlarmStatus)then
                     Caddy.RemoveAlarm(asInfo,Self);
                 end;
               end;
          end; {case}
          FetchIndex:=0;
          UpdateRealTime;
        end;
    end;
  end;
end;

function TKontNode.LoadFromStream(Stream: TStream): integer;
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
  FChannel:=Body.Channel;
  FNode:=Body.Node;
  FActived:=Body.Actived;
  FFetchTime:=Body.FetchTime;
end;

procedure TKontNode.SaveToStream(Stream: TStream);
begin
  Body.PtName:=PtName;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Node;
  Body.Actived:=Actived;
  Body.FetchTime:=FetchTime;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

procedure TKontNode.SaveToText(List: TStringList);
begin
  List.Append('[' + PtName + ']');
  List.Append('Plugin=KR500');
  List.Append('PtType=ND');
  List.Append('PtKind=0');
  List.Append('PtName=' + PtName);
  List.Append('PtDesc=' + PtDesc);
  List.Append('Channel=' + IntToStr(Channel));
  List.Append('Node=' + IntToStr(Node));
  List.Append('Actived=' + IfThen(Actived, 'True', 'False'));
  List.Append('FetchTime=' + IntToStr(FetchTime));
end;

class function TKontNode.TypeCode: string;
begin
  Result:='ND';
end;

class function TKontNode.TypeColor: TColor;
begin
  Result:=$00CCFFCC;
end;

procedure TKontNode.ClearLog;
begin
  Caddy.AddChange(FPtName,'LOG','','Очистка',FPtDesc,Caddy.Autor);
  LastTime:=FFetchTime;
  CommandData:=0;
  HasCommand:=True;
end;

function TKontNode.GetSourceText(n, e, d: integer): string;
begin
  if (e and $80) > 0 then
  begin // Отказ
    case (e and $7f) of
      1: Result:='Отказ системной области ОЗУ';
      2: case d of
           0: Result:='Отказ БИС флэш-ПЗУ: системный монитор (блок загрузки)';
           1: Result:='Отказ БИС флэш-ПЗУ: прикладной монитор (главный блок)';
           2: Result:='Отказ БИС флэш-ПЗУ: интерпретатор (главный блок)';
           3: Result:='Отказ БИС флэш-ПЗУ: системные параметры (1-й блок)';
           4: Result:='Отказ БИС флэш-ПЗУ: приборные параметры (1-й блок)';
           5: Result:='Отказ БИС флэш-ПЗУ: ТП (вспомогательный блок)';
           6: Result:='Отказ БИС флэш-ПЗУ: константы ТП (вспомогательный блок)';
           7: Result:='Отказ БИС флэш-ПЗУ: коэффициенты ТП (2-ой блок)';
         else
           Result:='Отказ БИС флэш-ПЗУ (Уточнение '+IntToStr(d)+')';
         end;
      3: Result:='Отказ рабочей области ОЗУ';
      4: case d of
           0: Result:='Алгоритмический отказ: отказ контроллера';
           1: Result:='Алгоритмический отказ: отключение контроллера от сети';
           2: Result:='Алгоритмический отказ: отказ контроллера с '+
                      'отключением его от сети';
         else
           Result:='Алгоритмический отказ';
         end;
      5: Result:='Отказ по сторожу цикла';
      6: Result:='Отказ передатчика сети МАГИСТР';
    else
      Result:='';
    end;
  end
  else
  begin // Ошибка
    case e of
      1: Result:='Несоответствие версий резидентного программного'+
      ' обеспечения контроллера (РПО) и системы ИСТОК.'+
      ' Версия РПО: '+IntToStr(d);
      2: case d of
           0: Result:='Ошибка ТП: отсутствие системных параметров';
           1: Result:='Ошибка ТП: отсутствие приборных параметров';
           2: Result:='Ошибка ТП: отсутствие ФАБЛ-программы';
           3: Result:='Ошибка ТП: отсутствие ПроTекст-программы при её'+
           ' выполнении или запроса переменной ФАБЛ-программой';
           4: Result:='Ошибка ТП: неправильный номер алгоблока в операторе'+
           ' ЧТА ПроTекст-программы';
           5: Result:='Ошибка ТП: неправильный номер выхода алгоблока'+
           ' в операторе ЧТА Протекст-программы';
           6: Result:='Ошибка ТП: несуществующий номер переменной '+
           'ПроTекст-программы на входе алгоблока ФАБЛ-программы';
         else
           Result:='Ошибка ТП';
         end;
      3: Result:='Реальное время цикла контроллера больше установленного';
      4: Result:='Сбой значений коэффициентов в ОЗУ и их восстановление из флэш-ПЗУ';
      5: case d of
           0: Result:='Ошибка сети: ошибка контрольной суммы';
           1: Result:='Ошибка сети: несуществующий код сетевой команды';
           2: Result:='Ошибка сети: несуществующий адрес команды (номер'+
           ' алгоритма, входа, выхода и т.п.)';
           3: Result:='Ошибка сети: невозможность выполнения команды'+
           ' в текущем режиме работы контроллера';
           4: Result:='Ошибка сети: команда может быть выполнена только'+
           ' по радиальному порту';
         else
           Result:='Ошибка сети';
         end;
      6: case d of
           0: Result:='Ошибка радиального канала: ошибка контрольной суммы';
           1: Result:='Ошибка радиального канала: несуществующий код команды';
           2: Result:='Ошибка радиального канала: несуществующий адрес'+
           ' команды (номер алгоритма, входа, выхода и т.п.)';
           3: Result:='Ошибка радиального канала: невозможность выполнения'+
           ' команды в текущем режиме работы контроллера';
         else
           Result:='Ошибка радиального канала';
         end;
      7: case d of
           10: Result:='Батарея разряжена';
           20: Result:='Батарея отсутствует';
         else
           Result:='Отказ батареи';
         end;
      8: Result:='Ошибка задания параметров алгоблока № '+IntToStr(d);
      9: case d of
           0: Result:='Ошибка алгоритма АРХ: нет флэш-диска';
           1: Result:='Ошибка алгоритма АРХ: ошибка стирания';
           2: Result:='Ошибка алгоритма АРХ: ошибка записи';
         else
           Result:='Ошибка алгоритма АРХ';
         end;
     10: case d of
           0: Result:='Ошибка работы резервированной модели: '+
             'отсутствие ответа на запрос пассивного контроллера';
           1: Result:='Ошибка работы резервированной модели: '+
             'неправильный ответ на запрос пассивного контроллера';
           2: Result:='Ошибка работы резервированной модели: '+
             'ошибка контрольной суммы при запросе коэффициентов';
           3: Result:='Ошибка работы резервированной модели: '+
             'ошибка записи коэффициентов во флэш-ПЗУ при инициализации';
           4: Result:='Ошибка работы резервированной модели: '+
             'отказ или отсутствие основного контроллера';
           5: Result:='Ошибка работы резервированной модели: '+
             'отказ или отсутствие резервного контроллера';
           6: Result:='Ошибка работы резервированной модели: '+
             'отсутствие запросов от резервного контроллера';
         else
           Result:='Ошибка работы резервированной модели';
         end;
     11: Result:='Несоответствие (на 3%) значений аналоговых входов основного'+
     ' и резервного контроллеров: Номер входа модуля '+
     Copy(Format('%4d',[d]),3,2)+'. Номер слота: '+
     Trim(Copy(Format('%4d',[d]),1,2));
     12: Result:='Несоответствие (в течение 1 с) значений дискретных входов основного'+
     ' и резервного контроллеров: Номер входа модуля '+
     Copy(Format('%4d',[d]),3,2)+'. Номер слота: '+
     Trim(Copy(Format('%4d',[d]),1,2));
     13: Result:='Ошибка при обмене с лицевой панелью';
     14: Result:='При автоконфигурации были изменены приборные параметры';
     16: Result:='Программный отказ алгоритма АВР (Вход отказа АВР = 1)';
     17: Result:='Программная ошибка алгоритма АВР (Вход ошибки АВР = 1)';
     18: Result:='Невозможность выполнения ПроТекст-программы (отсутсвие'+
     ' ПроТекст-интерпретатора в РПО процессора';
     20: Result:='В операторе ЧТУ в ПроТекст-программе: в слоте нет модуля'+
     ' дискретного ввода ';
     21: Result:='В операторе ЗПУ в ПроТекст-программе: в слоте нет модуля'+
     ' дискретного вывода';
     22: Result:='В операторе ЧТУ в ПроТекст-программе: в слоте нет модуля'+
     ' аналогового ввода';
     23: Result:='В операторе ЗПУ в ПроТекст-программе: в слоте нет модуля'+
     ' аналогового вывода';
     24: Result:='В операторах ЧТУ или ЗПУ в ПроТекст-программе:'+
     ' выход за пределы модуля УСО (по приборным параметрам)';
     25: Result:='В процессе выполнения ТП встречается несколько'+
     ' источников вывода в сеть МАГИСТР (алгоритм ИНВ и оператор ЗПС)';
     29: Result:='Ошибка в обработке алгоритма, вызываемого из'+
     ' ПроТекст-программы: выход алгоблока связан с несуществующей'+
     ' переменной ПроТекст. Алгоблок №'+IntToStr(d);
     30: Result:='Ошибка в обработке алгоблока №'+IntToStr(d)+
     ': вызов алгоритма с нулевым адресом';
     31: Result:='Ошибка в обработке алгоблока №'+IntToStr(d)+
     ': вызов алгоритма с номером больше 128, а конфигурация процессора '+
     'не позволяет (FLASH = 256)';
     35: Result:='Нет ответа от устройства ПС '+IntToStr(d);
     37: Result:='Ошибка '+IntToStr(d)+' при обмене по ПС';
     43: Result:='Деление на ноль в ПроТекст-программе. Блок: '+
     Copy(Format('%4d',[d]),1,2)+'. Секция: '+
     Trim(Copy(Format('%4d',[d]),3,2));
     45: Result:='Неизв. код команды в ПроТекст-программе. Секция: '+IntToStr(d);
     50: Result:='Нет флэш-диска: Номер алгоблока: '+IntToStr(d);
     51: Result:='Ош. стир. флэш-диска: Номер алгоблока: '+IntToStr(d);
     52: Result:='Ош. прогр. флэш-диска: Номер алгоблока: '+IntToStr(d);
     55: Result:='Ошибка при проверке КС блока ПЗУ и ППЗУ.';
     60: Result:='Ошибка модуля УСО. Номер слота: '+IntToStr(d);
     61: Result:='Ошибка длины сообщения при обмене с УСО. Номер слота: '+IntToStr(d);
     62: Result:='Ошибка кода команды при обмене с УСО. Номер слота: '+IntToStr(d);
     64: Result:='Ошибка самодиагностики модуля УСО. Номер слота: '+IntToStr(d);
     65: Result:='Ошибка КС при обмене с модулем УСО. Номер слота: '+IntToStr(d);
     66: Result:='Ошибка чтения идентификатора при обмене с модулем УСО. Номер слота: '+IntToStr(d);
     67: Result:='Ошибка EEPROM модуля УСО. Номер слота: '+IntToStr(d);
     70: Result:='Ошибка настройки аналогового ввода.';
     71: Result:='Ошибка настройки аналогового вывода.';
     72: Result:='Ошибка настройки дискретного ввода.';
     73: Result:='Ошибка настройки дискретного вывода.';
     74: Result:='Ошибка настройки импульсного вывода.';
     80: Result:='Внутреннее прерывание МП Intel386EX. Номер прерывания: '+IntToStr(d);
     98: Result:='Перезапуск контроллера по сторожу цикла.';
     99: Result:='Перезапуск контроллера по супервизору питания.';
    else
      Result:='';
    end;
  end;
end;

function TKontNode.GetFetchData: string;
var M1,M2: TMemoryStream;
begin
  M1:=TMemoryStream.Create;
  M2:=TMemoryStream.Create;
  try
    M1.WriteBuffer(ErrController,SizeOf(ErrController));
    M1.Position:=0;
    CompressStream(M1,M2);
    M2.Position:=0;
    SetLength(Result,M2.Size);
    MoveMemory(@Result[1],M2.Memory,M2.Size);
  finally
    M2.Free;
    M1.Free;
  end;
end;

function TKontNode.PropsCount: integer;
begin
  Result:=6;
end;

class function TKontNode.PropsID(Index: integer): string;
begin
  case Index of
    0: Result:='PtName';
    1: Result:='PtDesc';
    2: Result:='Channel';
    3: Result:='Node';
    4: Result:='Active';
    5: Result:='FetchTime';
  else
    Result:='Unknown';
  end
end;

class function TKontNode.PropsName(Index: integer): string;
begin
  case Index of
    0: Result:='Шифр параметра';
    1: Result:='Десктриптор';
    2: Result:='Канал связи';
    3: Result:='Контроллер';
    4: Result:='Опрос';
    5: Result:='Время опроса';
  else
    Result:='';
  end
end;

function TKontNode.PropsValue(Index: integer): string;
begin
  case Index of
    0: Result:=FPtName;
    1: Result:=FPtDesc;
    2: Result:=Format('%d',[FChannel]);
    3: Result:=Format('%d',[FNode]);
    4: Result:=IfThen(FActived,'Да','Нет');
    5: Result:=Format('%d сек',[FFetchTime]);
  else
    Result:='';
  end
end;

procedure TKontNode.RequestData;
var FL: TList;
begin
  FL:=Caddy.FetchList[FChannel].List;
  if FL.IndexOf(Self) < 0 then
  begin
    FL.Add(Self);
    if Caddy.NetRole <> nrClient then
    begin
      FL.Add(Self);
      FL.Add(Self);
      FL.Add(Self);
    end;
  end;
end;

{ TKontSyncMagister }

procedure TKontSyncMagister.Assign(E: TEntity);
var T: TKontSyncMagister;
begin
  inherited;
  T:=E as TKontSyncMagister;
  FActionKind:=T.ActionKind;
end;

constructor TKontSyncMagister.Create;
begin
  inherited;
  FetchIndex:=0;
  FEntityKind:=ekCustom;
  FIsCustom:=True;
end;

class function TKontSyncMagister.EntityType: string;
begin
  Result:='Синхронизация "МАГИСТР"';
end;

function TKontSyncMagister.Prepare: string;
var DT: TDateTime; yy,mm,dd,hh,nn,ss,ms,dn: Word; S: string;
begin
  Result:='';
  case FetchIndex of
// Запрос типа контроллера
   0: Result:=Chr(FNode)+#$fe#2#0#$40#4#21;
// Запрос таймер-календаря
   1: Result:=Chr(FNode)+#$fe#2#0#$40#1#6;
   2: begin
// Установка таймер-календаря
        DT:=Now;
        DecodeDateTime(DT,yy,mm,dd,hh,nn,ss,ms);
        dn:=DayOfTheWeek(DT);
        S:=Chr(yy mod 100)+Chr(mm)+Chr(dd)+Chr(dn)+Chr(hh)+Chr(nn)+Chr(ss);
        Result:=Chr(FNode)+#$fe#9#0#$00#1#6+S;
      end;
  end;
end;

procedure TKontSyncMagister.Fetch(const Data: string);
var DT: TDateTime; yy,mm,dd,hh,nn,ss,ms{,dn}: Word; ST: SYSTEMTIME;
begin
  inherited;
  ErrorMess:='';
  case FetchIndex of
   0: begin // Запрос типа контроллера
        if Length(Data) = 8 then NodeType:=Ord(Data[8]);
        FetchIndex:=1;
      end;
   1: begin
        case FActionKind of
   skMaster: FetchIndex:=2;
    skSlave: begin
               if Length(Data) = 14 then
               begin
                 yy:=Ord(Data[8])+2000;
                 mm:=Ord(Data[9]);
                 dd:=Ord(Data[10]);
            //   dn:=Ord(Data[11]);
                 hh:=Ord(Data[12]);
                 nn:=Ord(Data[13]);
                 ss:=Ord(Data[14]);
                 try
                   DT:=EncodeDateTime(yy,mm,dd,hh,nn,ss,0);
                   if (yy > 2000) and (Abs(Now-DT) > 10*OneSecond) then
                   begin
                     if YearOf(DT) >= 2000 then
                     begin
                       DecodeDate(DT,yy,mm,dd);
                       DecodeTime(DT,hh,nn,ss,ms);
                       ST.wYear:=yy;
                       ST.wMonth:=mm;
                       ST.wDay:=dd;
                       ST.wHour:=hh;
                       ST.wMinute:=nn;
                       ST.wSecond:=ss;
                       ST.wMilliseconds:=0;
                       SetLocalTime(ST);
                    end
                   end;
                 except

                 end;
               end;
               FetchIndex:=0;
               UpdateRealTime;
             end; {skSlave}
        end; {case}
      end;
   2: begin // Ответ о выполнении команды
        FetchIndex:=0;
        UpdateRealTime;
      end;
  end;
end;

function TKontSyncMagister.LoadFromStream(Stream: TStream): integer;
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
  FChannel:=Body.Channel;
  FNode:=Body.Node;
  FActived:=Body.Actived;
  FFetchTime:=Body.FetchTime;
  FActionKind:=Body.ActionKind;
end;

procedure TKontSyncMagister.SaveToStream(Stream: TStream);
begin
  Body.PtName:=PtName;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Node;
  Body.Actived:=Actived;
  Body.FetchTime:=FetchTime;
  Body.ActionKind:=ActionKind;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

procedure TKontSyncMagister.SaveToText(List: TStringList);
begin
  List.Append('[' + PtName + ']');
  List.Append('Plugin=KR500');
  List.Append('PtType=SM');
  List.Append('PtKind=0');
  List.Append('PtName=' + PtName);
  List.Append('PtDesc=' + PtDesc);
  List.Append('Channel=' + IntToStr(Channel));
  List.Append('Node=' + IntToStr(Node));
  List.Append('Actived=' + IfThen(Actived, 'True', 'False'));
  List.Append('FetchTime=' + IntToStr(FetchTime));
  List.Append('ActionKind=' + ASyncKind[ActionKind]);
end;

procedure TKontSyncMagister.SetActionKind(const Value: TSyncKind);
begin
  if FActionKind <> Value then
  begin
    Caddy.AddChange(PtName,'Тип синхро',ASyncKind[FActionKind],
                              ASyncKind[Value],PtDesc,Caddy.Autor);
    FActionKind:=Value;
    Caddy.Changed:=True;
  end;
end;

class function TKontSyncMagister.TypeCode: string;
begin
  Result:='SM';
end;

class function TKontSyncMagister.TypeColor: TColor;
begin
  Result:=clSilver;
end;

function TKontSyncMagister.GetFetchData: string;
begin
  Result:='';
end;

function TKontSyncMagister.PropsCount: integer;
begin
  Result:=7;
end;

class function TKontSyncMagister.PropsID(Index: integer): string;
begin
  case Index of
    0: Result:='PtName';
    1: Result:='PtDesc';
    2: Result:='Channel';
    3: Result:='Node';
    4: Result:='Active';
    5: Result:='FetchTime';
    6: Result:='ActionKind';
  else
    Result:='Unknown';
  end
end;

class function TKontSyncMagister.PropsName(Index: integer): string;
begin
  case Index of
    0: Result:='Шифр параметра';
    1: Result:='Десктриптор';
    2: Result:='Канал связи';
    3: Result:='Контроллер';
    4: Result:='Опрос';
    5: Result:='Время опроса';
    6: Result:='Тип синхронизации';
  else
    Result:='';
  end
end;

function TKontSyncMagister.PropsValue(Index: integer): string;
begin
  case Index of
    0: Result:=FPtName;
    1: Result:=FPtDesc;
    2: Result:=Format('%d',[FChannel]);
    3: Result:=Format('%d',[FNode]);
    4: Result:=IfThen(FActived,'Да','Нет');
    5: Result:=Format('%d сек',[FFetchTime]);
    6: Result:=ASyncKind[FActionKind];
  else
    Result:='';
  end
end;

procedure TKontSyncMagister.RequestData;
var FL: TList;
begin
  FL:=Caddy.FetchList[FChannel].List;
  if FL.IndexOf(Self) < 0 then
  begin
    FL.Add(Self);
    FL.Add(Self);
    if FActionKind = skMaster then
      FL.Add(Self);
  end;
end;

{ TKontEditForm }

procedure TKontEditForm.BaseFresh(var Mess: TMessage);
begin
  UpdateRealTime;
end;

procedure TKontEditForm.ChangeBooleanClick(Sender: TObject);
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

procedure TKontEditForm.ChangeFetchClick(Sender: TObject);
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

procedure TKontEditForm.ChangeIntegerClick(Sender: TObject);
var L: TListItem; V: Integer;
begin
  if not Assigned(E) then Exit;
  L:=ListView1.Selected;
  if Assigned(L) then
  begin
    if L.Caption = 'Канал связи' then V:=E.Channel
    else
      if L.Caption = 'Контроллер' then V:=E.Node
      else
        Exit;
    if InputIntegerDlg(L.Caption,V) then
    begin
      if L.Caption = 'Канал связи' then
      begin
        if InRange(V,1,ChannelCount) then
        begin
          E.Channel:=V;
          L.SubItems[0]:=Format('%d',[E.Channel]);
        end
        else
          raise ERangeError.Create('Значение вне допустимых границ!');
      end
      else
      if L.Caption = 'Контроллер' then
      begin
        if InRange(V,1,31) then
        begin
          E.Node:=V;
          L.SubItems[0]:=Format('%d',[E.Node]);
        end
        else
          raise ERangeError.Create('Значение вне допустимых границ (1..31)!');
      end;
      if (L.Caption = 'Канал связи') or
         (L.Caption = 'Контроллер') then
      begin
        UpdateBaseView(Self);
        RestoreEntityPos(E);
      end;
    end;
  end;
end;

procedure TKontEditForm.ChangeTextClick(Sender: TObject);
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

procedure TKontEditForm.ConnectBaseEditor(var Mess: TMessage);
begin
  ConnectImageList(TImageList(Mess.WParam));
  ConnectEntity(TEntity(Mess.LParam));
end;

procedure TKontEditForm.AddBoolItem(Value: boolean);
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

procedure TKontEditForm.ConnectEntity(Entity: TEntity);
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
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Канал связи';
        SubItems.Add(IntToStr(E.Channel));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Контроллер';
        SubItems.Add(IntToStr(E.Node));
      end;
    finally
      Items.EndUpdate;
    end;
  end;
end;

procedure TKontEditForm.ConnectImageList(ImageList: TImageList);
begin
  ListView1.SmallImages:=ImageList;
end;

constructor TKontEditForm.Create(AOwner: TComponent);
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

destructor TKontEditForm.Destroy;
begin
  ListView1.Free;
  PopupMenu.Free;;
  inherited;
end;

procedure TKontEditForm.ListView1DblClick(Sender: TObject);
begin
  if (ListView1.Selected <> nil) and
     (ListView1.Selected.Caption = 'Источник данных') then
  begin
    if Assigned(E.SourceEntity) then
      E.SourceEntity.ShowEditor(Monitor.MonitorNum);
  end;
end;

procedure TKontEditForm.PopupMenu1Popup(Sender: TObject);
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
      if (L.Caption = 'Канал связи') or
         (L.Caption = 'Контроллер') then
      begin
        M:=TMenuItem.Create(Self);
        M.Caption:='Изменить число...';
        M.OnClick:=ChangeIntegerClick;
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

procedure TKontEditForm.UpdateRealTime;
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

{ TKontDigPtx }

constructor TKontDigPtx.Create;
begin
  inherited;
  FIsCommand:=True;
  FBlock:=0;
  FPulseWait:=500;
end;

class function TKontDigPtx.EntityType: string;
begin
  Result:='Дискретное значение ПРОТЕКСТ';
end;

procedure TKontDigPtx.Fetch(const Data: string);
var nformat: Byte; N: Integer; D: Byte; W: word;
begin
  if HasCommand then
  begin
    if Length(Data) = 9 then
    begin
      W:=Ord(Data[8])+256*Ord(Data[9]);
      if W = 0 then
      begin
        ErrorMess:='Команда принята';
        Caddy.AddChange(FPtName,'OP','','',ErrorMess,'Автономно');
        Caddy.ShowMessage(kmStatus,ErrorMess);
        Windows.Beep(500,100);
      end
      else
      begin
        ErrorMess:=ErrorToString(W,Format('Сетевая ошибка %d',[W]));
        Caddy.AddChange(FPtName,'PV','','',ErrorMess,'Автономно');
        Caddy.ShowMessage(kmError,ErrorMess);
        Caddy.AddSysMess(PtName,ErrorMess);
        Windows.Beep(1000,100);
        Sleep(100);
        Windows.Beep(1000,100);
      end;
      LastTime:=FFetchTime+1;
    end;
  end
  else
  begin
    if Length(Data) = 12 then
    begin
      if not ((Ord(Data[10])+256*Ord(Data[11]) = FPlace) and
         (Ord(Data[9]) = FBlock)) then
      begin
        ErrorMess:=Format('Ответ от другой позиции (Тип: %d, Смещение: %d)',
                         [Ord(Data[9]),Ord(Data[10])+256*Ord(Data[11])]);
      end
      else
      if Ord(Data[9]) and $80 > 0 then
      begin
        N:=Ord(Data[12]);
        ErrorMess:=ErrorToString(N,Format('Сетевая ошибка %d',[N]));
      end
      else
      begin
        ErrorMess:='';
        nformat:=Ord(Data[9]);
        D:=Ord(Data[12]) and $01;
        case nformat of
   0..4: Raw:=D;
        else
          ErrorMess:=Format('Недопустимый формат: %d',[nformat]);
        end;
        UpdateRealTime;
      end;
    end
    else
    if Length(Data) = 9 then
    begin
      W:=Ord(Data[8])+256*Ord(Data[9]);
      if W > 0 then
        ErrorMess:=ErrorToString(W,Format('Сетевая ошибка %d',[W]));
    end;
  end;
end;

procedure TKontDigPtx.ImpulseTimer(Sender: TObject);
begin
  try
    (Sender as TTimer).Enabled:=False;
    if Invert then
      SendOP(1.0)
    else
      SendOP(0.0);
  finally
    FreeAndNil(Sender);
  end;  
end;

function TKontDigPtx.LoadFromStream(Stream: TStream): integer;
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
  FChannel:=Body.Channel;
  FNode:=Body.Node;
  FBlock:=Body.Block;
  FPlace:=Body.Place;
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
  FPulseWait:=Body.PulseWait;
end;

function TKontDigPtx.Prepare: string;
var S: string; D: byte; W: Word;
begin
  if Caddy.NetRole = nrClient then
  begin
    SetLength(Result,SizeOf(CommandData));
    MoveMemory(@Result[1],@CommandData,SizeOf(CommandData));
    Exit;
  end
  else
  if HasCommand then
  begin
    case FBlock of
 0..4: D:=Round(CommandData);
    else
      begin
        Result:='';
        Exit;
      end;
    end;
    W:=FPlace;
    S:=#2#4+Chr(FBlock)+Chr(Lo(W))+Chr(Hi(W))+Chr(D);
    W:=Length(S);
    S:=Chr(FNode)+       // адрес приёмника
             #$fe+                   // адрес передатчика
             Chr(Lo(W))+Chr(Hi(W))+  // длина текста сообщеня
             #$00+                   // управление
             S;                      // текст сообщения
    Result:=S;
  end
  else
  begin
    W:=FPlace;
    S:=#2#4#1+Chr(FBlock)+Chr(Lo(W))+Chr(Hi(W));
    W:=Length(S);
    S:=Chr(FNode)+#$fe+Chr(Lo(W))+Chr(Hi(W))+#$40+S;
    Result:=S;
  end;
end;

function TKontDigPtx.PropsCount: integer;
begin
  Result:=21;
end;

class function TKontDigPtx.PropsID(Index: integer): string;
begin
  case Index of
    0: Result:='PtName';
    1: Result:='PtDesc';
    2: Result:='Channel';
    3: Result:='Node';
    4: Result:='DigPtxType';
    5: Result:='Offset';
    6: Result:='Active';
    7: Result:='Alarm';
    8: Result:='Confirm';
    9: Result:='FetchTime';
   10: Result:='Source';
   11: Result:='Invert';
   12: Result:='AlarmOFF';
   13: Result:='AlarmON';
   14: Result:='SwitchOFF';
   15: Result:='SwitchON';
   16: Result:='ColorOFF';
   17: Result:='ColorON';
   18: Result:='TextOFF';
   19: Result:='TextON';
   20: Result:='PulseWait';
  else
    Result:='';
  end
end;

class function TKontDigPtx.PropsName(Index: integer): string;
begin
  case Index of
    0: Result:='Шифр параметра';
    1: Result:='Десктриптор';
    2: Result:='Канал связи';
    3: Result:='Контроллер';
    4: Result:='Тип переменной';
    5: Result:='Смещение';
    6: Result:='Опрос';
    7: Result:='Сигнализация';
    8: Result:='Квитирование';
    9: Result:='Время опроса';
   10: Result:='Источник данных';
   11: Result:='Инверсия данных';
   12: Result:='Авария при "1"->"0"';
   13: Result:='Авария при "0"->"1"';
   14: Result:='Переключение при "1"->"0"';
   15: Result:='Переключение при "0"->"1"';
   16: Result:='Цвет при "0"';
   17: Result:='Цвет при "1"';
   18: Result:='Текст при "0"';
   19: Result:='Текст при "1"';
   20: Result:='Время строба';
  else
    Result:='';
  end
end;

function TKontDigPtx.PropsValue(Index: integer): string;
begin
  case Index of
    0: Result:=FPtName;
    1: Result:=FPtDesc;
    2: Result:=Format('%d',[FChannel]);
    3: Result:=Format('%d',[FNode]);
    4: Result:=Format('%s',[DigPtxType[FBlock]]);
    5: begin
         case FBlock of
           0: Result:=IntToDP(FPlace);
           4: Result:=Format('%d.%d',[Hi(FPlace),Lo(FPlace)]);
         else
           Result:=Format('%d',[FPlace]);
         end;
       end;
    6: Result:=IfThen(FActived,'Да','Нет');
    7: Result:=IfThen(FAsked,'Да','Нет');
    8: Result:=IfThen(FLogged,'Да','Нет');
    9: Result:=Format('%d сек',[FFetchTime]);
   10: Result:=IfThen(Assigned(FSourceEntity),FSourceName,'Авто');
   11: Result:=IfThen(FInvert,'Да','Нет');
   12: Result:=IfThen(FAlarmDown,'Да','Нет');
   13: Result:=IfThen(FAlarmUp,'Да','Нет');
   14: Result:=IfThen(FSwitchDown,'Да','Нет');
   15: Result:=IfThen(FSwitchUp,'Да','Нет');
   16: Result:=StringDigColor[FColorDown];
   17: Result:=StringDigColor[FColorUp];
   18: Result:=FTextDown;
   19: Result:=FTextUp;
   20: Result:=Format('%d мсек',[FPulseWait]);
  else
    Result:='';
  end
end;

procedure TKontDigPtx.SaveToStream(Stream: TStream);
begin
  Body.PtName:=PtName;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Node;
  Body.Block:=Block;
  Body.Place:=Place;
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
  Body.PulseWait:=PulseWait;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

procedure TKontDigPtx.SaveToText(List: TStringList);
begin
  List.Append('[' + PtName + ']');
  List.Append('Plugin=KR500');
  List.Append('PtType=DX');
  List.Append('PtKind=2');
  List.Append('PtName=' + PtName);
  List.Append('PtDesc=' + PtDesc);
  List.Append('Channel=' + IntToStr(Channel));
  List.Append('Node=' + IntToStr(Node));
  List.Append('Block=' + IntToStr(Block));
  List.Append('Place=' + IntToStr(Place));
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
  List.Append('PulseWait=' + IntToStr(PulseWait));
end;

procedure TKontDigPtx.SendIMPULSE;
begin
  with TTimer.Create(nil) do
  begin
    OnTimer:=ImpulseTimer;
    Interval:=FPulseWait;
    Enabled:=True;
  end;
  if Invert then
    SendOP(0.0)
  else
    SendOP(1.0);
end;

procedure TKontDigPtx.SendOP(Value: Single);
const AB: array[Boolean] of string = ('лог."0"','лог."1"');
var BoolVal: boolean;
begin
  BoolVal:=(Value > 0);
  Caddy.AddChange(FPtName,'PV',AB[PV],AB[BoolVal],FPtDesc,Caddy.Autor);
  LastTime:=FFetchTime;
  if BoolVal then CommandData:=1 else CommandData:=0;
  HasCommand:=True;
end;

procedure TKontDigPtx.SetPulseWait(const Value: word);
begin
  if FPulseWait <> Value then
  begin
    Caddy.AddChange(PtName,'Время импульса',IntToStr(FPulseWait),
                                          IntToStr(Value),PtDesc,Caddy.Autor);
    FPulseWait:=Value;
    Caddy.Changed:=True;
  end;
end;

class function TKontDigPtx.TypeCode: string;
begin
  Result:='DX';
end;

class function TKontDigPtx.TypeColor: TColor;
begin
  Result:=$0099FFFF;
end;

{ TKontINRGroup }

function TKontINRGroup.AddressEqual(E: TEntity): boolean;
begin
  with E as TKontINRGroup do
  begin
    Result:=(Channel = Self.Channel) and
            (Node = Self.Node) and
            (Block = Self.Block);
  end;
end;

constructor TKontINRGroup.Create;
begin
  inherited;
  FBlock:=0;
end;

class function TKontINRGroup.EntityType: string;
begin
  Result:='Алгоблок ИНР ФАБЛ';
end;

function TKontINRGroup.Prepare: string;
var S: string; W: Word;
begin
  W:=FBlock;
  S:=#1#0+Chr(Lo(W))+Chr(Hi(W));
  W:=Length(S);
  S:=Chr(FNode)+#$fe+Chr(Lo(W))+Chr(Hi(W))+#$40+S;
  Result:=S;
end;

class function TKontINRGroup.PropsID(Index: integer): string;
begin
  case Index of
    0: Result:='PtName';
    1: Result:='PtDesc';
    2: Result:='Channel';
    3: Result:='Node';
    4: Result:='BuffNum';
    5: Result:='Active';
    6: Result:='FetchTime';
    7..36: Result:='Child'+IntToStr(Index-6);
  else
    Result:='Unknown';
  end
end;

class function TKontINRGroup.PropsName(Index: integer): string;
begin
  case Index of
    0: Result:='Шифр параметра';
    1: Result:='Десктриптор';
    2: Result:='Канал связи';
    3: Result:='Контроллер';
    4: Result:='Номер ИНР (0-30)';
    5: Result:='Опрос';
    6: Result:='Время опроса';
    7..36: Result:='Выход '+IntToStr(Index-6);
  else
    Result:='';
  end
end;

procedure TKontINRGroup.SaveToText(List: TStringList);
var i: Integer;
begin
  List.Append('[' + PtName + ']');
  List.Append('Plugin=KR500');
  List.Append('PtType=NR');
  List.Append('PtKind=3');
  List.Append('PtName=' + PtName);
  List.Append('PtDesc=' + PtDesc);
  List.Append('Channel=' + IntToStr(Channel));
  List.Append('Node=' + IntToStr(Node));
  List.Append('BuffNum=' + IntToStr(Block));
  List.Append('Actived=' + IfThen(Actived, 'True', 'False'));
  List.Append('FetchTime=' + IntToStr(FetchTime));
  List.Append('SourceName=' + SourceName);
  for i:=0 to 29 do
     List.Append(Format('Child%d=%s', [i + 1, Body.Childs[i]]));
end;

class function TKontINRGroup.TypeCode: string;
begin
  Result:='NR';
end;

initialization
{$IFDEF KONTRAST}
  with RegisterNode('Контроллеры "Контраст"') do
  begin
    Add(RegisterEntity(TKontNode));
    RegisterEditForm(TKontNDEditForm);
    RegisterPaspForm(TKontNDPaspForm);
    Add(RegisterEntity(TKontCntReg));
    RegisterEditForm(TKontCREditForm);
    RegisterPaspForm(TKontCRPaspForm);
    Add(RegisterEntity(TKontAnaOut));
    RegisterEditForm(TKontAOEditForm);
    RegisterPaspForm(TKontAOPaspForm);
    Add(RegisterEntity(TKontAnaParam));
    RegisterEditForm(TKontAPEditForm);
    RegisterPaspForm(TKontAPPaspForm);
    Add(RegisterEntity(TKontDigOut));
    RegisterEditForm(TKontDOEditForm);
    RegisterPaspForm(TKontDOPaspForm);
    Add(RegisterEntity(TKontDigParam));
    RegisterEditForm(TKontDPEditForm);
    RegisterPaspForm(TKontDPPaspForm);
    Add(RegisterEntity(TKontDigPtx));
    RegisterEditForm(TKontDXEditForm);
    RegisterPaspForm(TKontDXPaspForm);
    Add(RegisterEntity(TKontCRGroup));
    RegisterEditForm(TKontGREditForm);
    RegisterPaspForm(TKontGRPaspForm);
    Add(RegisterEntity(TKontOutputsGroup));
    RegisterEditForm(TKontGREditForm); // Общая с CR форма редактора !
    RegisterPaspForm(TKontGOPaspForm);
    Add(RegisterEntity(TKontParamsGroup));
    RegisterEditForm(TKontGREditForm); // Общая с CR форма редактора !
    RegisterPaspForm(TKontGPPaspForm);
    Add(RegisterEntity(TKontFDGroup));
    RegisterEditForm(TKontFDEditForm);
    RegisterPaspForm(TKontFDPaspForm);
    Add(RegisterEntity(TKontKDGroup));
    RegisterEditForm(TKontKDEditForm);
    RegisterPaspForm(TKontKDPaspForm);
    Add(RegisterEntity(TKontINRGroup));
    RegisterEditForm(TKontINREditForm);
    RegisterPaspForm(TKontKDPaspForm);
    Add(RegisterEntity(TKontSyncMagister));
    RegisterEditForm(TKontSMEditForm);
    RegisterPaspForm(nil);
    Add(RegisterEntity(TKontUPZDateTime));
    RegisterEditForm(TKontUDEditForm);
    RegisterPaspForm(nil);
  end;
{$ENDIF}
end.
