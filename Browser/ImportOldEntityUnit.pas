unit ImportOldEntityUnit;

interface

uses Classes, SysUtils, Contnrs, EntityUnit;

type
  TUpdateKing = (ukSec,ukMin,ukHour);
  TPVSource = (psAuto,psHand,psSubst);
  TOldEntity = class(TComponent)
  private
    FActived: Boolean;
    FAsked: Boolean;
    FLogged: Boolean;
    FChannel: Byte;
    FController: Byte;
    FStation: Byte;
    FInOut: Byte;
    FTimeBase: Byte;
    FSourceName: string;
    FPtDesc: string;
    FPVSource: TPVSource;
    FTimeUnit: TUpdateKing;
    FRealTrendCount: Word;
    FAlgoblock: Word;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure SaveToStream(Stream: TStream); virtual; abstract;
    function BrowserClass: string; virtual; abstract;
  published
    property Actived: Boolean read FActived write FActived default False;
    property Algoblock: Word read FAlgoblock write FAlgoblock;
    property Asked: Boolean read FAsked write FAsked default False;
    property Channel: Byte read FChannel write FChannel;
    property Controller: Byte read FController write FController;
    property InOut: Byte read FInOut write FInOut;
    property Logged: Boolean read FLogged write FLogged default False;
    property PtDesc: string read FPtDesc write FPtDesc;
    property PVSource: TPVSource read FPVSource write FPVSource default
            psAuto;
    property SourceName: string read FSourceName write FSourceName;
    property Station: Byte read FStation write FStation;
    property TimeBase: Byte read FTimeBase write FTimeBase default 1;
    property TimeUnit: TUpdateKing read FTimeUnit write FTimeUnit default
            ukSec;
    property RealTrendCount: Word read FRealTrendCount write FRealTrendCount;
  end;

  TAlarmDeadband =(adNone,adZero,adHalf,adOne,adTwo,adThree,adFour,asFive);
  TPVFormat = (pfD0,pfD1,pfD2,pfD3);
  TAnaOut = class(TOldEntity)
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
    FFilter: Boolean;
    FPVGroup: Byte;
    FPVPlace: Byte;
    FPVLoTP: Single;
    FPV: Single;
    FPVLLTP: Single;
    FPVEULo: Single;
    FPVEUHi: Single;
    FPVHHTP: Single;
    FPVHiTP: Single;
    FEUDesc: string;
    FHiDB: TAlarmDeadband;
    FLLDB: TAlarmDeadband;
    FLoDB: TAlarmDeadband;
    FBadDB: TAlarmDeadband;
    FHHDB: TAlarmDeadband;
    FPVFormat: TPVFormat;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure SaveToStream(Stream: TStream); override;
    function BrowserClass: string; override;
  published
    property BadDB: TAlarmDeadband read FBadDB write FBadDB default adHalf;
    property EUDesc: string read FEUDesc write FEUDesc;
    property Filter: Boolean read FFilter write FFilter;
    property HHDB: TAlarmDeadband read FHHDB write FHHDB default adHalf;
    property HiDB: TAlarmDeadband read FHiDB write FHiDB default adHalf;
    property LLDB: TAlarmDeadband read FLLDB write FLLDB default adHalf;
    property LoDB: TAlarmDeadband read FLoDB write FLoDB default adHalf;
    property PV: Single read FPV write FPV stored False;
    property PVEUHi: Single read FPVEUHi write FPVEUHi;
    property PVEULo: Single read FPVEULo write FPVEULo;
    property PVFormat: TPVFormat read FPVFormat write FPVFormat default pfD1;
    property PVGroup: Byte read FPVGroup write FPVGroup;
    property PVHHTP: Single read FPVHHTP write FPVHHTP;
    property PVHiTP: Single read FPVHiTP write FPVHiTP;
    property PVLLTP: Single read FPVLLTP write FPVLLTP;
    property PVLoTP: Single read FPVLoTP write FPVLoTP;
    property PVPlace: Byte read FPVPlace write FPVPlace;
  end;

  TTM5103 = class(TAnaOut)
  protected
  public
    function BrowserClass: string; override;
  end;

  TNumeric = class(TAnaOut)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
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
    procedure SaveToStream(Stream: TStream); override;
    function BrowserClass: string; override;
  end;

  TAnaParam = class(TOldEntity)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Channel: word;
      Node: word;
      Block: word;
      Place: word;
      Actived: boolean;
      CalcScale: boolean;
      FetchTime: Cardinal;
      SourceName: string[10];
      EUDesc: string[10];
      OPFormat: TPVFormat;
      OPEUHi: Single;
      OPEULo: Single;
    end;
    FFilter: Boolean;
    FOPEULo: Single;
    FOPEUHi: Single;
    FEUDesc: string;
    FOPFormat: TPVFormat;
    FOP: Single;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure SaveToStream(Stream: TStream); override;
    function BrowserClass: string; override;
  published
    property EUDesc: string read FEUDesc write FEUDesc;
    property Filter: Boolean read FFilter write FFilter;
    property OP: Single read FOP write FOP stored False;
    property OPEUHi: Single read FOPEUHi write FOPEUHi;
    property OPEULo: Single read FOPEULo write FOPEULo;
    property OPFormat: TPVFormat read FOPFormat write FOPFormat default pfD1;
  end;

  TMtkKind = (mkK,mkT1,mkT2,mkT3);
  TAnaMtk = class(TAnaParam)
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
      EUDesc: string[10];
      OPFormat: TPVFormat;
      OPEUHi: Single;
      OPEULo: Single;
      MtkKind: TMtkKind;
    end;
    FMtkKind: TMtkKind;
  protected
  public
    procedure SaveToStream(Stream: TStream); override;
    function BrowserClass: string; override;
  published
    property MtkKind: TMtkKind read FMtkKind write FMtkKind;
  end;

  TDigOut = class(TOldEntity)
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
    FFilter: Boolean;
    FAlarmUp: Boolean;
    FPV: Boolean;
    FSwitchUp: Boolean;
    FSwitchDown: Boolean;
    FInvert: Boolean;
    FAlarmDown: Boolean;
    FColorDown: Byte;
    FColorUp: Byte;
    FTextDown: string;
    FTextUp: string;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure SaveToStream(Stream: TStream); override;
    function BrowserClass: string; override;
  published
    property AlarmDown: Boolean read FAlarmDown write FAlarmDown default
            False;
    property AlarmUp: Boolean read FAlarmUp write FAlarmUp default False;
    property ColorDown: Byte read FColorDown write FColorDown default 6;
    property ColorUp: Byte read FColorUp write FColorUp default 10;
    property Filter: Boolean read FFilter write FFilter;
    property Invert: Boolean read FInvert write FInvert default False;
    property PV: Boolean read FPV write FPV;
    property SwitchDown: Boolean read FSwitchDown write FSwitchDown default
            False;
    property SwitchUp: Boolean read FSwitchUp write FSwitchUp default False;
    property TextDown: string read FTextDown write FTextDown;
    property TextUp: string read FTextUp write FTextUp;
  end;

  TFlag = class(TDigOut)
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
  protected
  public
    procedure SaveToStream(Stream: TStream); override;
    function BrowserClass: string; override;
  end;

  TDigParam = class(TOldEntity)
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
    FFilter: Boolean;
    FOP: Boolean;
    FInvert: Boolean;
    FPulseWait: LongWord;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure SaveToStream(Stream: TStream); override;
    function BrowserClass: string; override;
  published
    property Filter: Boolean read FFilter write FFilter;
    property Invert: Boolean read FInvert write FInvert default False;
    property OP: Boolean read FOP write FOP;
    property PulseWait: LongWord read FPulseWait write FPulseWait;
  end;

  TControlKind = (ckAnalog, ckPulse);
  TCheckChange =(ccNone,ccOne,ccTwo,ccThree,ccFour,ccFive,ccTen,ccTwenty,
                                                 ccThirty,ccForty,ccFifty);
  TRegType = (rtAnalog, rtImpulse);
  TCntReg = class(TAnaOut)
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
    FSPGroup: Byte;
    FSPPlace: Byte;
    FOPGroup: Byte;
    FKontur: Byte;
    FOPPlace: Byte;
    FOPEULo: Single;
    FHand: Single;
    FOP: Single;
    FSPEUHi: Single;
    FPVDHTP: Single;
    FPVDLTP: Single;
    FOPEUHi: Single;
    FDelta: Single;
    FSP: Single;
    FSPEULo: Single;
    FPointK: string;
    FPointT2: string;
    FPointT1: string;
    FOPCC: TCheckChange;
    FSPCC: TCheckChange;
    FKind: TControlKind;
    FMode: Word;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure SaveToStream(Stream: TStream); override;
    function BrowserClass: string; override;
  published
    property Delta: Single read FDelta write FDelta stored False;
    property Hand: Single read FHand write FHand stored False;
    property Kontur: Byte read FKontur write FKontur;
    property Mode: Word read FMode write FMode stored False;
    property OP: Single read FOP write FOP stored False;
    property OPCC: TCheckChange read FOPCC write FOPCC;
    property OPEUHi: Single read FOPEUHi write FOPEUHi;
    property OPEULo: Single read FOPEULo write FOPEULo;
    property OPGroup: Byte read FOPGroup write FOPGroup;
    property OPPlace: Byte read FOPPlace write FOPPlace;
    property PointK: string read FPointK write FPointK;
    property PointT1: string read FPointT1 write FPointT1;
    property PointT2: string read FPointT2 write FPointT2;
    property PVDHTP: Single read FPVDHTP write FPVDHTP;
    property PVDLTP: Single read FPVDLTP write FPVDLTP;
    property SP: Single read FSP write FSP stored False;
    property SPCC: TCheckChange read FSPCC write FSPCC;
    property SPEUHi: Single read FSPEUHi write FSPEUHi;
    property SPEULo: Single read FSPEULo write FSPEULo;
    property SPGroup: Byte read FSPGroup write FSPGroup;
    property SPPlace: Byte read FSPPlace write FSPPlace;
    property Kind: TControlKind read FKind write FKind;
  end;

  TMtkReg = class(TCntReg)
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
      SourceT3: string[10];
    end;
    FPointT3: string;
  protected
  public
    procedure SaveToStream(Stream: TStream); override;
    function BrowserClass: string; override;
  published
    property PointT3: string read FPointT3 write FPointT3;
  end;

  TModbusFormat = (mfChar,mfInt,mfFInt,mfLong,mfEFloat,mfVFloat,mfBCD);
  TAnaModBus = class(TAnaOut)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Channel: word;
      Node: word;
      Address: word;
      DataFormat: TModbusFormat;
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
    FAddress: Word;
  protected
  public
    procedure SaveToStream(Stream: TStream); override;
    function BrowserClass: string; override;
  published
    property Address: Word read FAddress write FAddress;
  end;

  TSysInfoKind = (siPhysical,siVirtual,siPageFile,siHDD);
  TSizeKoeff = (skByte,skKByte,skMByte);
  TOldSizeKoeff = (skKB,skMB);

  TAnaSysInfo = class(TAnaOut)
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
    FKoeff: TOldSizeKoeff;
    FKind: TSysInfoKind;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure SaveToStream(Stream: TStream); override;
    function BrowserClass: string; override;
  published
    property Kind: TSysInfoKind read FKind write FKind default siPhysical;
    property Koeff: TOldSizeKoeff read FKoeff write FKoeff default skKB;
    property PVEUHi stored False;
    property PVEULo stored False;
 end;

  TAnaPtx = class(TAnaOut)
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
    FKind: Byte;
    FOffset: Word;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure SaveToStream(Stream: TStream); override;
    function BrowserClass: string; override;
  published
    property Kind: Byte read FKind write FKind;
    property Offset: Word read FOffset write FOffset;
  end;

  TTimFormat = (tfShort,tfMiddle,tfLong);
  TTimCnt = class(TOldEntity)
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
    FHHHourTP: Integer;
    FHiHourTP: Integer;
    FMaxHourValue: Integer;
    FWorkSource: string;
    FPV: string;
    FPVFormat: TTimFormat;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure SaveToStream(Stream: TStream); override;
    function BrowserClass: string; override;
  published
    property HHHourTP: Integer read FHHHourTP write FHHHourTP;
    property HiHourTP: Integer read FHiHourTP write FHiHourTP;
    property MaxHourValue: Integer read FMaxHourValue write FMaxHourValue;
    property PV: string read FPV write FPV stored False;
    property PVFormat: TTimFormat read FPVFormat write FPVFormat default
            tfMiddle;
    property WorkSource: string read FWorkSource write FWorkSource;
  end;

  TPeriodKind = (pkNone,pkHour,pkDaily,pkMonth,pkYear,pkExternal);
  TBaseKind = (bkSec,bkMin,bkHour);
  TCalcKind = (ckZero,ckLastGood,ckBadPV);
  TFloCnt = class(TAnaOut)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Actived: boolean;
      Asked: boolean;
      Logged: boolean;
      FetchTime: Cardinal;
      EUDesc: string[10];
      PVFormat: TPVFormat;
      HHCountTP: Double;
      HiCountTP: Double;
      MaxCountValue: Double;
      SourceAnaWork: string[10];
      SourceDigWork: string[10];
      InvDigWork: boolean;
      PeriodKind: TPeriodKind;
      BaseKind: TBaseKind;
      CalcKind: TCalcKind;
      ShiftHour: byte;
      CutOff: Double;
      Reset: Double;
    end;
    FExtInverse: Boolean;
    FResetVal: Single;
    FAvDev1TP: Single;
    FMaxAccumValue: Single;
    FLastPV: Single;
    FCutOffLm: Single;
    FAvDev2TP: Single;
    FWorkSource: string;
    FExtSource: string;
    FBaseKind: TBaseKind;
    FCalcKind: TCalcKind;
    FPeriodKind: TPeriodKind;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure SaveToStream(Stream: TStream); override;
    function BrowserClass: string; override;
  published
    property AvDev1TP: Single read FAvDev1TP write FAvDev1TP;
    property AvDev2TP: Single read FAvDev2TP write FAvDev2TP;
    property BaseKind: TBaseKind read FBaseKind write FBaseKind default
            bkHour;
    property CalcKind: TCalcKind read FCalcKind write FCalcKind;
    property CutOffLm: Single read FCutOffLm write FCutOffLm;
    property ExtInverse: Boolean read FExtInverse write FExtInverse;
    property ExtSource: string read FExtSource write FExtSource;
    property LastPV: Single read FLastPV write FLastPV stored False;
    property MaxAccumValue: Single read FMaxAccumValue write FMaxAccumValue;
    property PeriodKind: TPeriodKind read FPeriodKind write FPeriodKind
            default pkDaily;
    property ResetVal: Single read FResetVal write FResetVal;
    property WorkSource: string read FWorkSource write FWorkSource;
  end;

  TDigPtx = class(TDigOut)
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
      PulseWait: Word;
    end;
    FKind: Byte;
    FPulseWait: LongWord;
    FOffset: Word;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure SaveToStream(Stream: TStream); override;
    function BrowserClass: string; override;
  published
    property Kind: Byte read FKind write FKind;
    property Offset: Word read FOffset write FOffset;
    property PulseWait: LongWord read FPulseWait write FPulseWait;
  end;

  TDigModBus = class(TDigOut)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Channel: word;
      Node: word;
      Address: word;
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
    FAddress: Word;
  protected
  public
    procedure SaveToStream(Stream: TStream); override;
    function BrowserClass: string; override;
  published
    property Address: Word read FAddress write FAddress;
  end;

  TAnaSel = class(TAnaOut)
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
    FAnaVar4: string;
    FDigVar3: string;
    FDigVar4: string;
    FDigVar1: string;
    FAnaVar3: string;
    FAnaVar2: string;
    FDigVar2: string;
    FAnaVar1: string;
  protected
  public
    procedure SaveToStream(Stream: TStream); override;
    function BrowserClass: string; override;
  published
    property AnaVar1: string read FAnaVar1 write FAnaVar1;
    property AnaVar2: string read FAnaVar2 write FAnaVar2;
    property AnaVar3: string read FAnaVar3 write FAnaVar3;
    property AnaVar4: string read FAnaVar4 write FAnaVar4;
    property DigVar1: string read FDigVar1 write FDigVar1;
    property DigVar2: string read FDigVar2 write FDigVar2;
    property DigVar3: string read FDigVar3 write FDigVar3;
    property DigVar4: string read FDigVar4 write FDigVar4;
  end;

  TVlvCnt = class(TOldEntity)
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
    FPV: Byte;
    FStatOFF: string;
    FCommON: string;
    FStatON: string;
    FStatALM: string;
    FCommOFF: string;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure SaveToStream(Stream: TStream); override;
    function BrowserClass: string; override;
  published
    property CommOFF: string read FCommOFF write FCommOFF;
    property CommON: string read FCommON write FCommON;
    property PV: Byte read FPV write FPV;
    property StatALM: string read FStatALM write FStatALM;
    property StatOFF: string read FStatOFF write FStatOFF;
    property StatON: string read FStatON write FStatON;
  end;

  TGrpCustom = class(TOldEntity)
  private
    FChilds: TStrings;
    procedure SetChilds(const Value: TStrings);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Childs: TStrings read FChilds write SetChilds;
  end;

  TGrpParam = class(TGrpCustom)
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
  public
    procedure SaveToStream(Stream: TStream); override;
    function BrowserClass: string; override;
  protected
  end;

  TGrpOut = class(TGrpCustom)
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
  public
    procedure SaveToStream(Stream: TStream); override;
    function BrowserClass: string; override;
  protected
  end;

  TGrpCR = class(TGrpCustom)
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
  public
    procedure SaveToStream(Stream: TStream); override;
    function BrowserClass: string; override;
  protected
  end;

  TGrpAtx = class(TGrpCustom)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Channel: word;
      Node: word;
      Actived: boolean;
      FetchTime: Cardinal;
      SourceName: string[10];
      Childs: array[0..16] of string[10];
    end;
  public
    procedure SaveToStream(Stream: TStream); override;
    function BrowserClass: string; override;
  protected
  end;

  TGrpDtx = class(TGrpCustom)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Channel: word;
      Node: word;
      Actived: boolean;
      FetchTime: Cardinal;
      SourceName: string[10];
      Childs: array[0..28] of string[10];
    end;
  public
    procedure SaveToStream(Stream: TStream); override;
    function BrowserClass: string; override;
  protected
  end;

  TDatAcc = class(TGrpCustom)
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
  public
    procedure SaveToStream(Stream: TStream); override;
    function BrowserClass: string; override;
  protected
  end;

  TDigDec = class(TGrpCustom)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Actived: boolean;
      FetchTime: Cardinal;
      SourceName: string[10];
      Childs: array[0..31] of string[10];
    end;
  public
    procedure SaveToStream(Stream: TStream); override;
    function BrowserClass: string; override;
  protected
  public
  end;

  TFabDec = class(TDigDec)
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
  public
    procedure SaveToStream(Stream: TStream); override;
    function BrowserClass: string; override;
  protected
  public
  end;

  TUZS_24MDec = class(TDigDec)
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
      FirstSource: string[10];
      Childs: array[0..23] of string[10];
    end;
    FFirstSource: string;
  protected
  public
    procedure SaveToStream(Stream: TStream); override;
    function BrowserClass: string; override;
  published
    property FirstSource: string read FFirstSource write FFirstSource;
  end;

  TTM5103Dec = class(TDigDec)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Actived: boolean;
      FetchTime: Cardinal;
      SourceName: string[10];
      Childs: array[0..7] of string[10];
    end;
  protected
  public
    procedure SaveToStream(Stream: TStream); override;
    function BrowserClass: string; override;
  end;

  TPtxDec = class(TDigDec)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Actived: boolean;
      FetchTime: Cardinal;
      SourceName: string[10];
      Kind: Byte;
      Offset: Word;
      Childs: array[0..31] of string[10];
    end;
    FKind: Byte;
    FOffset: Word;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure SaveToStream(Stream: TStream); override;
    function BrowserClass: string; override;
  published
    property Kind: Byte read FKind write FKind default 6;
    property Offset: Word read FOffset write FOffset;
  end;

  TNode = class(TOldEntity)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Channel: word;
      Node: word;
      Actived: boolean;
      FetchTime: Cardinal;
    end;
    FNodeType: Byte;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure SaveToStream(Stream: TStream); override;
    function BrowserClass: string; override;
  published
    property NodeType: Byte read FNodeType write FNodeType default 2;
  end;

  TSyncKind = (skNone,skMaster,skSlave);
  TSyncMagister = class(TOldEntity)
  private
    Body: record
      PtName: string[10];
      PtDesc: string[50];
      Channel: word;
      Actived: boolean;
      FetchTime: Cardinal;
      ActionKind: TSyncKind;
    end;
    FActionKind: TSyncKind;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure SaveToStream(Stream: TStream); override;
    function BrowserClass: string; override;
  published
    property Controller stored False;
    property Algoblock stored False;
    property InOut stored False;
    property ActionKind: TSyncKind read FActionKind write FActionKind;
  end;

procedure LoadOldEntityBase(const FileName: string; Items: TComponentList);

implementation

const
  AUpdateKing : array[TUpdateKing] of integer = (1,60,3600);

{ TOldEntity }

constructor TOldEntity.Create(AOwner: TComponent);
begin
  inherited;
  FActived:=False;
  FAlgoblock:=1;
  FAsked:=False;
  FChannel:=1;
  FController:=1;
  FInOut:=1;
  FLogged:=False;
  FPtDesc:='';
  FPVSource:=psAuto;
  FSourceName:='';
  FStation:=1;
  FTimeBase:=1;
  FTimeUnit:=ukSec;
  FRealTrendCount:=1200;
end;

{ TAnaOut }

function TAnaOut.BrowserClass: string;
begin
  Result:='TKontAnaOut';
end;

constructor TAnaOut.Create(AOwner: TComponent);
begin
  inherited;
  FPVFormat:=pfD1;
  FBadDB:=adHalf;
  FHHDB:=adHalf;
  FHiDB:=adHalf;
  FLoDB:=adHalf;
  FLLDB:=adHalf;
end;

procedure TAnaOut.SaveToStream(Stream: TStream);
begin
  Body.PtName:=Name;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Controller;
  Body.Block:=Algoblock;
  Body.Place:=InOut;
  Body.Actived:=Actived;
  Body.Logged:=Logged;
  Body.Asked:=Asked;
  Body.FetchTime:=TimeBase*AUpdateKing[TimeUnit];
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
  Body.Trend:=(PVGroup in [1..125]) and (PVPlace in [1..8]);
  Body.CalcScale:=True;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

{ TAnaParam }

function TAnaParam.BrowserClass: string;
begin
  Result:='TKontAnaParam';
end;

constructor TAnaParam.Create(AOwner: TComponent);
begin
  inherited;
  FOPFormat:=pfD1;
end;

procedure TAnaParam.SaveToStream(Stream: TStream);
begin
  Body.PtName:=Name;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Controller;
  Body.Block:=AlgoBlock;
  Body.Place:=InOut;
  Body.Actived:=Actived;
  Body.FetchTime:=TimeBase*AUpdateKing[TimeUnit];
  Body.SourceName:=SourceName;
  Body.EUDesc:=EUDesc;
  Body.OPFormat:=OPFormat;
  Body.OPEUHi:=OPEUHi;
  Body.OPEULo:=OPEULo;
  Body.CalcScale:=False;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

{ TDigOut }

function TDigOut.BrowserClass: string;
begin
  Result:='TKontDigOut';
end;

constructor TDigOut.Create(AOwner: TComponent);
begin
  inherited;
  FInvert:=False;
  FAlarmUp:=False;
  FAlarmDown:=False;
  FSwitchUp:=False;
  FSwitchDown:=False;
  FColorUp:=10;
  FColorDOwn:=6;
  FTextDown:='¬€ À';
  FTextUp:='¬ À';
end;

procedure TDigOut.SaveToStream(Stream: TStream);
begin
  Body.PtName:=Name;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Controller;
  Body.Block:=AlgoBlock;
  Body.Place:=InOut;
  Body.Actived:=Actived;
  Body.Logged:=Logged;
  Body.Asked:=Asked;
  Body.FetchTime:=TimeBase*AUpdateKing[TimeUnit];
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

{ TDigParam }

function TDigParam.BrowserClass: string;
begin
  Result:='TKontDigParam';
end;

constructor TDigParam.Create(AOwner: TComponent);
begin
  inherited;
  FInvert:=False;
  FPVSource:=psAuto;
  FAsked:=True;
  FLogged:=False;
  FPulseWait:=500;
end;

procedure TDigParam.SaveToStream(Stream: TStream);
begin
  Body.PtName:=Name;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Controller;
  Body.Block:=AlgoBlock;
  Body.Place:=InOut;
  Body.Actived:=Actived;
  Body.FetchTime:=TimeBase*AUpdateKing[TimeUnit];
  Body.SourceName:=SourceName;
  Body.Invert:=Invert;
  Body.PulseWait:=PulseWait;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

{ TCntReg }

function TCntReg.BrowserClass: string;
begin
  Result:='TKontCntReg';
end;

constructor TCntReg.Create(AOwner: TComponent);
begin
  inherited;
  FKontur:=1;
end;

procedure TCntReg.SaveToStream(Stream: TStream);
begin
  Body.PtName:=Name;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Controller;
  Body.Block:=0;
  Body.Place:=Kontur;
  Body.Actived:=Actived;
  Body.Logged:=Logged;
  Body.Asked:=Asked;
  Body.FetchTime:=TimeBase*AUpdateKing[TimeUnit];
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
  Body.CheckSP:=SPCC;
  Body.CheckOP:=OPCC;
  Body.RegType:=TRegType(Ord(Kind));
  Body.SourceK:=PointK;
  Body.SourceT1:=PointT1;
  Body.SourceT2:=PointT2;
  Body.Trend:=(PVGroup in [1..125]) and (PVPlace in [1..8]);
  Body.CalcScale:=True;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

{ TAnaSysInfo }

function TAnaSysInfo.BrowserClass: string;
begin
  Result:='TVirtSysInfo';
end;

constructor TAnaSysInfo.Create(AOwner: TComponent);
begin
  inherited;
  FKind := siPhysical;
  FKoeff := skKB;
end;

procedure TAnaSysInfo.SaveToStream(Stream: TStream);
begin
  Body.PtName:=Name;
  Body.PtDesc:=PtDesc;
  Body.Actived:=Actived;
  Body.Logged:=Logged;
  Body.Asked:=Asked;
  Body.FetchTime:=TimeBase*AUpdateKing[TimeUnit];
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
  Body.Koeff:=TSizeKoeff(Succ(Ord(Koeff)));
  Body.Kind:=Kind;
  Body.Trend:=(PVGroup in [1..125]) and (PVPlace in [1..8]);
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

{ TAnaPtx }

function TAnaPtx.BrowserClass: string;
begin
  Result:='';
end;

constructor TAnaPtx.Create(AOwner: TComponent);
begin
  inherited;
  FKind:=3;
end;

procedure TAnaPtx.SaveToStream(Stream: TStream);
begin
  Body.PtName:=Name;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Controller;
  Body.Block:=Kind;
  Body.Place:=Offset;
  Body.Actived:=Actived;
  Body.Logged:=Logged;
  Body.Asked:=Asked;
  Body.FetchTime:=TimeBase*AUpdateKing[TimeUnit];
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
  Body.Trend:=(PVGroup in [1..125]) and (PVPlace in [1..8]);
  Body.CalcScale:=True;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

{ TTimCnt }

function TTimCnt.BrowserClass: string;
begin
  Result:='TVirtTimeCounter';
end;

constructor TTimCnt.Create(AOwner: TComponent);
begin
  inherited;
  FMaxHourValue:=100000;
  FHHHourTP:=95000;
  FHiHourTP:=90000;
  FPVFormat:=tfMiddle;
end;

procedure TTimCnt.SaveToStream(Stream: TStream);
begin
  Body.PtName:=Name;
  Body.PtDesc:=PtDesc;
  Body.Actived:=Actived;
  Body.Logged:=Logged;
  Body.Asked:=Asked;
  Body.FetchTime:=TimeBase*AUpdateKing[TimeUnit];
  Body.HHHourTP:=HHHourTP;
  Body.HiHourTP:=HiHourTP;
  Body.MaxHourValue:=MaxHourValue;
  Body.PVFormat:=PVFormat;
  Body.SourceDigWork:=WorkSource;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

{ TFloCnt }

function TFloCnt.BrowserClass: string;
begin
  Result:='TVirtFlowCounter';
end;

constructor TFloCnt.Create(AOwner: TComponent);
begin
  inherited;
  FMaxAccumValue:=100000;
  FPeriodKind:=pkDaily;
  FBaseKind:=bkHour;
end;

procedure TFloCnt.SaveToStream(Stream: TStream);
begin
  Body.PtName:=Name;
  Body.PtDesc:=PtDesc;
  Body.Actived:=Actived;
  Body.Logged:=Logged;
  Body.Asked:=Asked;
  Body.FetchTime:=TimeBase*AUpdateKing[TimeUnit];
  Body.EUDesc:=EUDesc;
  Body.PVFormat:=PVFormat;
  Body.HHCountTP:=AvDev2TP;
  Body.HiCountTP:=AvDev1TP;
  Body.MaxCountValue:=MaxAccumValue;
  Body.SourceAnaWork:=WorkSource;
  Body.SourceDigWork:=ExtSource;
  Body.InvDigWork:=ExtInverse;
  Body.PeriodKind:=FPeriodKind;
  Body.BaseKind:=FBaseKind;
  Body.CalcKind:=FCalcKind;
  Body.ShiftHour:=0;
  Body.CutOff:=CutOffLm;
  Body.Reset:=ResetVal;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

{ TDigPtx }

function TDigPtx.BrowserClass: string;
begin
  Result:='TKontDigPtx';
end;

constructor TDigPtx.Create(AOwner: TComponent);
begin
  inherited;
  FKind:=0;
end;

procedure TDigPtx.SaveToStream(Stream: TStream);
begin
  Body.PtName:=Name;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Controller;
  Body.Block:=Kind;
  Body.Place:=Offset;
  Body.Actived:=Actived;
  Body.Logged:=Logged;
  Body.Asked:=Asked;
  Body.FetchTime:=TimeBase*AUpdateKing[TimeUnit];
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

{ TVlvCnt }

function TVlvCnt.BrowserClass: string;
begin
  Result:='TVirtValve';
end;

constructor TVlvCnt.Create(AOwner: TComponent);
begin
  inherited;
  FCommOFF:='';
  FCommON:='';
  FStatALM:='';
  FStatOFF:='';
  FStatON:='';
end;

procedure TVlvCnt.SaveToStream(Stream: TStream);
begin
  Body.PtName:=Name;
  Body.PtDesc:=PtDesc;
  Body.Actived:=Actived;
  Body.Logged:=Logged;
  Body.Asked:=Asked;
  Body.FetchTime:=TimeBase*AUpdateKing[TimeUnit];
  Body.SourceStatALM:=StatALM;
  Body.SourceStatON:=StatON;
  Body.SourceStatOFF:=StatOFF;
  Body.SourceCommON:=CommON;
  Body.SourceCommOFF:=CommOFF;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

{ TGrpCustom }

constructor TGrpCustom.Create(AOwner: TComponent);
begin
  inherited;
  FChilds:=TStringList.Create;
end;

destructor TGrpCustom.Destroy;
begin
  FChilds.Free;
  inherited;
end;

procedure TGrpCustom.SetChilds(const Value: TStrings);
begin
  FChilds.Assign(Value);
end;

{ TPtxDec }

function TPtxDec.BrowserClass: string;
begin
  Result:='';
end;

constructor TPtxDec.Create(AOwner: TComponent);
begin
  inherited;
  FKind := 6;
end;

procedure TPtxDec.SaveToStream(Stream: TStream);
var i: integer;
begin
  Body.PtName:=Name;
  Body.PtDesc:=PtDesc;
  Body.Actived:=Actived;
  Body.FetchTime:=TimeBase*AUpdateKing[TimeUnit];
  Body.SourceName:=SourceName;
  Body.Kind:=Kind;
  Body.Offset:=Offset;
  for i:=0 to 31 do Body.Childs[i]:='';
  for i:=0 to Childs.Count-1 do
  if i in [0..31] then
    Body.Childs[i]:=Childs.Strings[i];
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

{ TNode }

function TNode.BrowserClass: string;
begin
  if FNodeType in [0..3] then
    Result:='TKontNode'
  else
    Result:='TEliteNode';
end;

constructor TNode.Create(AOwner: TComponent);
begin
  inherited;
  FNodeType:=2;
end;

procedure TNode.SaveToStream(Stream: TStream);
begin
  Body.PtName:=Name;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Controller;
  Body.Actived:=Actived;
  Body.FetchTime:=TimeBase*AUpdateKing[TimeUnit];
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

{ TSyncMagister }

function TSyncMagister.BrowserClass: string;
begin
  Result:='';
end;

constructor TSyncMagister.Create(AOwner: TComponent);
begin
  inherited;
  FController:=0;
  FAlgoblock:=0;
  FInOut:=0;
end;

function ComponentToString(Component: TComponent): string;
var
  BinStream:TMemoryStream;
  StrStream: TStringStream;
  s: string;
begin
  BinStream := TMemoryStream.Create;
  try
    StrStream := TStringStream.Create(s);
    try
      BinStream.WriteComponent(Component);
      BinStream.Seek(0, soFromBeginning);
      ObjectBinaryToText(BinStream, StrStream);
      StrStream.Seek(0, soFromBeginning);
      Result:= StrStream.DataString;
    finally
      StrStream.Free;
    end;
  finally
    BinStream.Free
  end;
end;

function StringToComponent(Value: string): TComponent;
var
  StrStream:TStringStream;
  BinStream: TMemoryStream;
  C: TComponent;
begin
  StrStream := TStringStream.Create(Value);
  try
    BinStream := TMemoryStream.Create;
    try
      ObjectTextToBinary(StrStream, BinStream);
      BinStream.Seek(0, soFromBeginning);
      C := BinStream.ReadComponent(nil);
      Result := C;
    finally
      BinStream.Free;
    end;
  finally
    StrStream.Free;
  end;
end;

procedure LoadOldEntityBase(const FileName: string; Items: TComponentList);
var C: TComponent; S, sBuf: string; T: TextFile;
begin
  if FileExists(FileName) then
  begin
    RegisterClasses([TCntReg,TAnaOut,TAnaParam,TDigOut,TDigParam,TVlvCnt,
                     TGrpOut,TGrpParam,TGrpCR,TNode,TAnaModBus,TAnaSel,
                     TDigModBus,TAnaPtx,TDigPtx,TGrpAtx,TGrpDtx,TDatAcc,
                     TDigDec,TFabDec,TTimCnt,TFloCnt,TPtxDec,TAnaSysInfo,
                     TSyncMagister,TUZS_24MDec,TFlag,TNumeric,TMtkReg,
                     TAnaMtk,TTM5103,TTM5103Dec]);
    AssignFile(T,FileName);
    Reset(T);
    try
      sBuf:='';
      while not Eof(T) do
      begin
        Readln(T,S);
        sBuf:=sBuf+S+#13;
        if Pos('end',S)=1 then
        begin
          try
            try
              C:=StringToComponent(sBuf);
              Items.Add(C);
            except
            end;
          finally
            sBuf:='';
          end;
        end;
      end;
    finally
      CloseFile(T);
    end;
    UnregisterClasses([TCntReg,TAnaOut,TAnaParam,TDigOut,TDigParam,TVlvCnt,
                     TGrpOut,TGrpParam,TGrpCR,TNode,TAnaModBus,TAnaSel,
                     TDigModBus,TAnaPtx,TDigPtx,TGrpAtx,TGrpDtx,TDatAcc,
                     TDigDec,TFabDec,TTimCnt,TFloCnt,TPtxDec,TAnaSysInfo,
                     TSyncMagister,TUZS_24MDec,TFlag,TNumeric,TMtkReg,
                     TAnaMtk,TTM5103,TTM5103Dec]);
  end;
end;

procedure TSyncMagister.SaveToStream(Stream: TStream);
begin
  Body.PtName:=Name;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Actived:=Actived;
  Body.FetchTime:=TimeBase*AUpdateKing[TimeUnit];
  Body.ActionKind:=ActionKind;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

{ TAnaMtk }

function TAnaMtk.BrowserClass: string;
begin
  Result:='';
end;

procedure TAnaMtk.SaveToStream(Stream: TStream);
begin
  Body.PtName:=Name;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Controller;
  Body.Block:=AlgoBlock;
  Body.Place:=InOut;
  Body.Actived:=Actived;
  Body.FetchTime:=TimeBase*AUpdateKing[TimeUnit];
  Body.SourceName:=SourceName;
  Body.EUDesc:=EUDesc;
  Body.OPFormat:=OPFormat;
  Body.OPEUHi:=OPEUHi;
  Body.OPEULo:=OPEULo;
  Body.MtkKind:=MtkKind;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

{ TMtkReg }

function TMtkReg.BrowserClass: string;
begin
  Result:='';
end;

procedure TMtkReg.SaveToStream(Stream: TStream);
begin
  Body.PtName:=Name;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Controller;
  Body.Block:=0;
  Body.Place:=Kontur;
  Body.Actived:=Actived;
  Body.Logged:=Logged;
  Body.Asked:=Asked;
  Body.FetchTime:=TimeBase*AUpdateKing[TimeUnit];
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
  Body.CheckSP:=SPCC;
  Body.CheckOP:=OPCC;
  Body.RegType:=TRegType(Ord(Kind));
  Body.SourceK:=PointK;
  Body.SourceT1:=PointT1;
  Body.SourceT2:=PointT2;
  Body.SourceT3:=PointT3;
  Body.Trend:=(PVGroup in [1..125]) and (PVPlace in [1..8]);
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

{ TAnaModBus }

function TAnaModBus.BrowserClass: string;
begin
  Result:='TModbusAnaOut';
end;

procedure TAnaModBus.SaveToStream(Stream: TStream);
begin
  Body.PtName:=Name;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Controller;
  Body.Address:=Address;
  Body.DataFormat:=mfInt;
  Body.Actived:=Actived;
  Body.Logged:=Logged;
  Body.Asked:=Asked;
  Body.FetchTime:=TimeBase*AUpdateKing[TimeUnit];
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
  Body.Trend:=(PVGroup in [1..125]) and (PVPlace in [1..8]);
  Body.CalcScale:=False;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

{ TDigModBus }

function TDigModBus.BrowserClass: string;
begin
  Result:='TModbusDigOut';
end;

procedure TDigModBus.SaveToStream(Stream: TStream);
begin
  Body.PtName:=Name;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Controller;
  Body.Address:=Address;
  Body.Actived:=Actived;
  Body.Logged:=Logged;
  Body.Asked:=Asked;
  Body.FetchTime:=TimeBase*AUpdateKing[TimeUnit];
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

{ TAnaSel }

function TAnaSel.BrowserClass: string;
begin
  Result:='TVirtAnaSel';
end;

procedure TAnaSel.SaveToStream(Stream: TStream);
begin
  Body.PtName:=Name;
  Body.PtDesc:=PtDesc;
  Body.Actived:=Actived;
  Body.Logged:=Logged;
  Body.Asked:=Asked;
  Body.FetchTime:=TimeBase*AUpdateKing[TimeUnit];
  Body.SourceAnaVar1:=AnaVar1;
  Body.SourceAnaVar2:=AnaVar2;
  Body.SourceAnaVar3:=AnaVar3;
  Body.SourceAnaVar4:=AnaVar4;
  Body.SourceDigVar1:=DigVar1;
  Body.SourceDigVar2:=DigVar2;
  Body.SourceDigVar3:=DigVar3;
  Body.SourceDigVar4:=DigVar4;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

{ TGrpParam }

function TGrpParam.BrowserClass: string;
begin
  Result:='TKontParamsGroup';
end;

procedure TGrpParam.SaveToStream(Stream: TStream);
var i: integer;
begin
  Body.PtName:=Name;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Controller;
  Body.Actived:=Actived;
  Body.FetchTime:=TimeBase*AUpdateKing[TimeUnit];
  Body.SourceName:=SourceName;
  for i:=0 to 13 do Body.Childs[i]:='';
  for i:=0 to Childs.Count-1 do
    if (i in [0..13]) then
      Body.Childs[i]:=Childs.Strings[i];
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

{ TGrpOut }

function TGrpOut.BrowserClass: string;
begin
  Result:='TKontOutputsGroup';
end;

procedure TGrpOut.SaveToStream(Stream: TStream);
var i: integer;
begin
  Body.PtName:=Name;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Controller;
  Body.Actived:=Actived;
  Body.FetchTime:=TimeBase*AUpdateKing[TimeUnit];
  Body.SourceName:=SourceName;
  for i:=0 to 13 do Body.Childs[i]:='';
  for i:=0 to Childs.Count-1 do
    if (i in [0..13]) then
      Body.Childs[i]:=Childs.Strings[i];
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

{ TGrpCR }

function TGrpCR.BrowserClass: string;
begin
  Result:='TKontCRGroup';
end;

procedure TGrpCR.SaveToStream(Stream: TStream);
var i: integer;
begin
  Body.PtName:=Name;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Controller;
  Body.Actived:=Actived;
  Body.FetchTime:=TimeBase*AUpdateKing[TimeUnit];
  Body.SourceName:=SourceName;
  for i:=0 to 3 do Body.Childs[i]:='';
  for i:=0 to Childs.Count-1 do
    if (i in [0..3]) then
      Body.Childs[i]:=Childs.Strings[i];
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

{ TGrpAtx }

function TGrpAtx.BrowserClass: string;
begin
  Result:='';
end;

procedure TGrpAtx.SaveToStream(Stream: TStream);
var i: integer;
begin
  Body.PtName:=Name;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Controller;
  Body.Actived:=Actived;
  Body.FetchTime:=TimeBase*AUpdateKing[TimeUnit];
  Body.SourceName:=SourceName;
  for i:=0 to 16 do Body.Childs[i]:='';
  for i:=0 to Childs.Count-1 do
    if (i in [0..16]) then
      Body.Childs[i]:=Childs.Strings[i];
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

{ TGrpDtx }

function TGrpDtx.BrowserClass: string;
begin
  Result:='';
end;

procedure TGrpDtx.SaveToStream(Stream: TStream);
var i: integer;
begin
  Body.PtName:=Name;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Controller;
  Body.Actived:=Actived;
  Body.FetchTime:=TimeBase*AUpdateKing[TimeUnit];
  Body.SourceName:=SourceName;
  for i:=0 to 28 do Body.Childs[i]:='';
  for i:=0 to Childs.Count-1 do
    if (i in [0..28]) then
      Body.Childs[i]:=Childs.Strings[i];
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

{ TDatAcc }

function TDatAcc.BrowserClass: string;
begin
  Result:='TKontKDGroup';
end;

procedure TDatAcc.SaveToStream(Stream: TStream);
var i: integer;
begin
  Body.PtName:=Name;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Controller;
  Body.Block:=Algoblock;
  Body.Actived:=Actived;
  Body.FetchTime:=TimeBase*AUpdateKing[TimeUnit];
  for i:=0 to 29 do Body.Childs[i]:='';
  for i:=0 to Childs.Count-1 do
  if i in [0..29] then
    Body.Childs[i]:=Childs.Strings[i];
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

{ TDigDec }

function TDigDec.BrowserClass: string;
begin
  Result:='TVirtVDGroup';
end;

procedure TDigDec.SaveToStream(Stream: TStream);
var i: integer;
begin
  Body.PtName:=Name;
  Body.PtDesc:=PtDesc;
  Body.Actived:=Actived;
  Body.FetchTime:=TimeBase*AUpdateKing[TimeUnit];
  Body.SourceName:=SourceName;
  for i:=0 to 31 do Body.Childs[i]:='';
  for i:=0 to Childs.Count-1 do
  if i in [0..31] then
    Body.Childs[i]:=Childs.Strings[i];
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

{ TFabDec }

function TFabDec.BrowserClass: string;
begin
  Result:='TKontFDGroup';
end;

procedure TFabDec.SaveToStream(Stream: TStream);
var i: integer;
begin
  Body.PtName:=Name;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Controller;
  Body.Block:=AlgoBlock;
  Body.Actived:=Actived;
  Body.FetchTime:=TimeBase*AUpdateKing[TimeUnit];
  Body.SourceName:=SourceName;
  for i:=0 to 31 do Body.Childs[i]:='';
  for i:=0 to Childs.Count-1 do
  if i in [0..31] then
    Body.Childs[i]:=Childs.Strings[i];
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

{ TUZS_24MDec }

function TUZS_24MDec.BrowserClass: string;
begin
  Result:='';
end;

procedure TUZS_24MDec.SaveToStream(Stream: TStream);
var i: integer;
begin
  Body.PtName:=Name;
  Body.PtDesc:=PtDesc;
  Body.Channel:=Channel;
  Body.Node:=Controller;
  Body.Block:=AlgoBlock;
  Body.Actived:=Actived;
  Body.FetchTime:=TimeBase*AUpdateKing[TimeUnit];
  Body.SourceName:=SourceName;
  Body.FirstSource:=FirstSource;
  for i:=0 to 23 do Body.Childs[i]:='';
  for i:=0 to Childs.Count-1 do
  if i in [0..23] then
    Body.Childs[i]:=Childs.Strings[i];
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

{ TTM5103Dec }

function TTM5103Dec.BrowserClass: string;
begin
  Result:='';
end;

procedure TTM5103Dec.SaveToStream(Stream: TStream);
var i: integer;
begin
  Body.PtName:=Name;
  Body.PtDesc:=PtDesc;
  Body.Actived:=Actived;
  Body.FetchTime:=TimeBase*AUpdateKing[TimeUnit];
  Body.SourceName:=SourceName;
  for i:=0 to 7 do Body.Childs[i]:='';
  for i:=0 to Childs.Count-1 do
  if i in [0..7] then
    Body.Childs[i]:=Childs.Strings[i];
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

{ TTM5103 }

function TTM5103.BrowserClass: string;
begin
  Result:='';
end;

{ TNumeric }

function TNumeric.BrowserClass: string;
begin
  Result:='TVirtNumeric';
end;

procedure TNumeric.SaveToStream(Stream: TStream);
begin
  Body.PtName:=Name;
  Body.PtDesc:=PtDesc;
  Body.Actived:=Actived;
  Body.Logged:=Logged;
  Body.Asked:=Asked;
  Body.FetchTime:=TimeBase*AUpdateKing[TimeUnit];
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
  Body.Trend:=(PVGroup in [1..125]) and (PVPlace in [1..8]);
  Body.CalcScale:=True;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

{ TFlag }

function TFlag.BrowserClass: string;
begin
  Result:='TVirtFlag';
end;

procedure TFlag.SaveToStream(Stream: TStream);
begin
  Body.PtName:=Name;
  Body.PtDesc:=PtDesc;
  Body.Actived:=Actived;
  Body.Logged:=Logged;
  Body.Asked:=Asked;
  Body.FetchTime:=TimeBase*AUpdateKing[TimeUnit];
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

end.
