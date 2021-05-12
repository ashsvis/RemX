unit RmxBaseSvr_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : 1.2
// File generated on 18.09.2008 9:50:30 from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\RemX_Demo\Work\RemX\RmxBaseSvr.tlb (1)
// LIBID: {7479D8B3-6A1F-4263-81C6-46660547B32F}
// LCID: 0
// Helpfile: 
// HelpString: RmxBaseSvr Library
// DepndLst: 
//   (1) v1.0 Midas, (C:\WINDOUS\system32\midas.dll)
//   (2) v2.0 stdole, (C:\WINDOUS\system32\stdole2.tlb)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, Midas, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  RmxBaseSvrMajorVersion = 1;
  RmxBaseSvrMinorVersion = 0;

  LIBID_RmxBaseSvr: TGUID = '{7479D8B3-6A1F-4263-81C6-46660547B32F}';

  IID_IRmxBaseData: TGUID = '{F16828B0-6C6E-4581-B99F-7317FB44A388}';
  CLASS_RmxBaseData: TGUID = '{C5B2B937-E229-4CAA-83EB-D194AA3BF850}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IRmxBaseData = interface;
  IRmxBaseDataDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  RmxBaseData = IRmxBaseData;


// *********************************************************************//
// Interface: IRmxBaseData
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F16828B0-6C6E-4581-B99F-7317FB44A388}
// *********************************************************************//
  IRmxBaseData = interface(IAppServer)
    ['{F16828B0-6C6E-4581-B99F-7317FB44A388}']
    procedure DeleteKey(const Section: WideString; const Ident: WideString); safecall;
    procedure EraseSection(const Section: WideString); safecall;
    function GetStrings: WideString; safecall;
    function ReadSection(const Section: WideString): WideString; safecall;
    function ReadSections: WideString; safecall;
    function ReadSectionValues(const Section: WideString): WideString; safecall;
    function ReadString(const Section: WideString; const Ident: WideString; 
                        const Default: WideString): WideString; safecall;
    procedure SetStrings(const List: WideString); safecall;
    procedure WriteString(const Section: WideString; const Ident: WideString; 
                          const Value: WideString); safecall;
    function ReadBinaryStream(const Section: WideString; const Name: WideString): OleVariant; safecall;
    function ReadBool(const Section: WideString; const Ident: WideString; Default: WordBool): WordBool; safecall;
    function ReadDate(const Section: WideString; const Ident: WideString; Default: Double): Double; safecall;
    function ReadDateTime(const Section: WideString; const Ident: WideString; Default: Double): Double; safecall;
    function ReadFloat(const Section: WideString; const Ident: WideString; Default: Double): Double; safecall;
    function ReadInteger(const Section: WideString; const Ident: WideString; Default: Integer): Integer; safecall;
    function ReadTime(const Section: WideString; const Ident: WideString; Default: Double): Double; safecall;
    function SectionExists(const Section: WideString): WordBool; safecall;
    function ValueExists(const Section: WideString; const Ident: WideString): WordBool; safecall;
    procedure WriteBinaryStream(const Section: WideString; const Name: WideString; 
                                Stream: OleVariant); safecall;
    procedure WriteBool(const Section: WideString; const Ident: WideString; Value: WordBool); safecall;
    procedure WriteDate(const Section: WideString; const Ident: WideString; Value: Double); safecall;
    procedure WriteDateTime(const Section: WideString; const Ident: WideString; Value: Double); safecall;
    procedure WriteFloat(const Section: WideString; const Ident: WideString; Value: Double); safecall;
    procedure WriteInteger(const Section: WideString; const Ident: WideString; Value: Integer); safecall;
    procedure WriteTime(const Section: WideString; const Ident: WideString; Value: Double); safecall;
    function LoadScheme(const FileName: WideString): WideString; safecall;
    function LoadAlarmLog(const LogPath: WideString; FromDate: Double; ToDate: Double): WideString; safecall;
    function LoadSwitchLog(const LogPath: WideString; FromDate: Double; ToDate: Double): WideString; safecall;
    function LoadChangeLog(const LogPath: WideString; FromDate: Double; ToDate: Double): WideString; safecall;
    function LoadSystemLog(const LogPath: WideString; FromDate: Double; ToDate: Double): WideString; safecall;
    function Now: Double; safecall;
  end;

// *********************************************************************//
// DispIntf:  IRmxBaseDataDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F16828B0-6C6E-4581-B99F-7317FB44A388}
// *********************************************************************//
  IRmxBaseDataDisp = dispinterface
    ['{F16828B0-6C6E-4581-B99F-7317FB44A388}']
    procedure DeleteKey(const Section: WideString; const Ident: WideString); dispid 301;
    procedure EraseSection(const Section: WideString); dispid 302;
    function GetStrings: WideString; dispid 303;
    function ReadSection(const Section: WideString): WideString; dispid 304;
    function ReadSections: WideString; dispid 305;
    function ReadSectionValues(const Section: WideString): WideString; dispid 306;
    function ReadString(const Section: WideString; const Ident: WideString; 
                        const Default: WideString): WideString; dispid 307;
    procedure SetStrings(const List: WideString); dispid 308;
    procedure WriteString(const Section: WideString; const Ident: WideString; 
                          const Value: WideString); dispid 309;
    function ReadBinaryStream(const Section: WideString; const Name: WideString): OleVariant; dispid 310;
    function ReadBool(const Section: WideString; const Ident: WideString; Default: WordBool): WordBool; dispid 311;
    function ReadDate(const Section: WideString; const Ident: WideString; Default: Double): Double; dispid 312;
    function ReadDateTime(const Section: WideString; const Ident: WideString; Default: Double): Double; dispid 313;
    function ReadFloat(const Section: WideString; const Ident: WideString; Default: Double): Double; dispid 314;
    function ReadInteger(const Section: WideString; const Ident: WideString; Default: Integer): Integer; dispid 315;
    function ReadTime(const Section: WideString; const Ident: WideString; Default: Double): Double; dispid 316;
    function SectionExists(const Section: WideString): WordBool; dispid 317;
    function ValueExists(const Section: WideString; const Ident: WideString): WordBool; dispid 318;
    procedure WriteBinaryStream(const Section: WideString; const Name: WideString; 
                                Stream: OleVariant); dispid 319;
    procedure WriteBool(const Section: WideString; const Ident: WideString; Value: WordBool); dispid 320;
    procedure WriteDate(const Section: WideString; const Ident: WideString; Value: Double); dispid 321;
    procedure WriteDateTime(const Section: WideString; const Ident: WideString; Value: Double); dispid 322;
    procedure WriteFloat(const Section: WideString; const Ident: WideString; Value: Double); dispid 323;
    procedure WriteInteger(const Section: WideString; const Ident: WideString; Value: Integer); dispid 324;
    procedure WriteTime(const Section: WideString; const Ident: WideString; Value: Double); dispid 325;
    function LoadScheme(const FileName: WideString): WideString; dispid 326;
    function LoadAlarmLog(const LogPath: WideString; FromDate: Double; ToDate: Double): WideString; dispid 327;
    function LoadSwitchLog(const LogPath: WideString; FromDate: Double; ToDate: Double): WideString; dispid 328;
    function LoadChangeLog(const LogPath: WideString; FromDate: Double; ToDate: Double): WideString; dispid 329;
    function LoadSystemLog(const LogPath: WideString; FromDate: Double; ToDate: Double): WideString; dispid 330;
    function Now: Double; dispid 331;
    function AS_ApplyUpdates(const ProviderName: WideString; Delta: OleVariant; MaxErrors: Integer; 
                             out ErrorCount: Integer; var OwnerData: OleVariant): OleVariant; dispid 20000000;
    function AS_GetRecords(const ProviderName: WideString; Count: Integer; out RecsOut: Integer; 
                           Options: Integer; const CommandText: WideString; var Params: OleVariant; 
                           var OwnerData: OleVariant): OleVariant; dispid 20000001;
    function AS_DataRequest(const ProviderName: WideString; Data: OleVariant): OleVariant; dispid 20000002;
    function AS_GetProviderNames: OleVariant; dispid 20000003;
    function AS_GetParams(const ProviderName: WideString; var OwnerData: OleVariant): OleVariant; dispid 20000004;
    function AS_RowRequest(const ProviderName: WideString; Row: OleVariant; RequestType: Integer; 
                           var OwnerData: OleVariant): OleVariant; dispid 20000005;
    procedure AS_Execute(const ProviderName: WideString; const CommandText: WideString; 
                         var Params: OleVariant; var OwnerData: OleVariant); dispid 20000006;
  end;

// *********************************************************************//
// The Class CoRmxBaseData provides a Create and CreateRemote method to          
// create instances of the default interface IRmxBaseData exposed by              
// the CoClass RmxBaseData. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoRmxBaseData = class
    class function Create: IRmxBaseData;
    class function CreateRemote(const MachineName: string): IRmxBaseData;
  end;

implementation

uses ComObj;

class function CoRmxBaseData.Create: IRmxBaseData;
begin
  Result := CreateComObject(CLASS_RmxBaseData) as IRmxBaseData;
end;

class function CoRmxBaseData.CreateRemote(const MachineName: string): IRmxBaseData;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_RmxBaseData) as IRmxBaseData;
end;

end.
