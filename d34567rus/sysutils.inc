{*******************************************************}
{                                                       }
{       Delphi Runtime Library                          }
{       System Utilities Include File                   }
{                                                       }
{       Copyright (C) 1995,97 Borland International     }
{                                                       }
{ ������������: 1999 Polaris Software                   }
{               http://polesoft.da.ru                   }
{*******************************************************}

resourcestring

  SInvalidInteger = '''%s'' - �������� ����� ��������';
  SInvalidFloat = '''%s'' - �������� ������� ��������';
  SInvalidDate = '''%s'' - �������� ����';
  SInvalidTime = '''%s'' - �������� �����';
  SInvalidDateTime = '''%s'' - �������� ���� � �����';
  STimeEncodeError = '�������� �������� ��� ������������ �������';
  SDateEncodeError = '�������� �������� ��� ������������ ����';
  SOutOfMemory = '�� ������� ������';
  SInOutError = '������ �����/������ %d';
  SFileNotFound = '���� �� ������';
  SInvalidFilename = '�������� ��� �����';
  STooManyOpenFiles = '������� ����� �������� ������';
  SAccessDenied = '� ������� � ����� ��������';
  SEndOfFile = '������ �� �������� �����';
  SDiskFull = '���� ������';
  SInvalidInput = '�������� ���� �����';
  SDivByZero = '������� �� ����';
  SRangeError = '������ ������ �� ������� (Range check error)';
  SIntOverflow = '������������ ������';
  SInvalidOp = '�������� �������� � �������� �������';
  SZeroDivide = '��������������� ������� �� ����';
  SOverflow = '��������������� ������������';
  SUnderflow = '��������������� ������ (underflow)';
  SInvalidPointer = '�������� ��������� ��������';
  SInvalidCast = '�������� �������������� ����� �������';
  SAccessViolation = '��������� ������� �� ������ %p. %s ������ %p';
  SStackOverflow = '������������ �����';
  SControlC = '������ Control-C';
  SPrivilege = '����������������� �������';
  SOperationAborted = '�������� ��������';
  SException = '�������������� �������� %s � ������ %s �� ������ %p.'#$0A'%s%s';
  SExceptTitle = '������ ���������';
  SInvalidFormat = '������ ''%s'' - �������� ��� ������������� � ����������';
  SArgumentMissing = '��� ��������� ��� ������� ''%s''';
  SInvalidVarCast = '�������� �������������� ����������� ����';
  SInvalidVarOp = '�������� �������� � ���������';
  SDispatchError = '������ ���������� ������� �� ��������������';
  SReadAccess = '������';
  SWriteAccess = '������';
  SResultTooLong = '��������� �������������� �������, ��� 4096 ��������';
  SFormatTooLong = '������ ������� ������� �������';
  SVarArrayCreate = '������ �������� ����������� �������';
  SVarNotArray = '������� �� �������� ��������';
  SVarArrayBounds = '������ ����������� ������� ����� �� �������';
  SExternalException = '������� �������������� �������� %x';
  SAssertionFailed = 'Assertion failed';
  SIntfCastError = '��������� �� ��������������';
  SAssertError = '%s (%s, ������ %d)';
  SAbstractError = '����������� ������';
  SModuleAccessViolation = '��������� ������� �� ������ %p � ������ ''%s''. %s �� ������ %p';
  SCannotReadPackageInfo = '�� ���� �������� ���������� ������ ��� ������ ''%s''';
  sErrorLoadingPackage = '�� ���� ��������� ����� %s.'#13#10'%s';
  SInvalidPackageFile = '�������� ���� ������ ''%s''';
  SInvalidPackageHandle = '�������� ���������� ������';
  SDuplicatePackageUnit = '�� ���� ��������� ����� ''%s.''  �� �������� ������ ''%s,''' +
    ';������� ����� ���������� � ������ ''%s''';
  SWin32Error = '������ Win32.  ���: %d.'#10'%s';
  SUnkWin32Error = '������ ������� Win32 API';
  SNL = '���������� �� ����� �������� �� ������������� ���� �����������';

  SShortMonthNameJan = '���';
  SShortMonthNameFeb = '���';
  SShortMonthNameMar = '���';
  SShortMonthNameApr = '���';
  SShortMonthNameMay = '���';
  SShortMonthNameJun = '���';
  SShortMonthNameJul = '���';
  SShortMonthNameAug = '���';
  SShortMonthNameSep = '���';
  SShortMonthNameOct = '���';
  SShortMonthNameNov = '���';
  SShortMonthNameDec = '���';

  SLongMonthNameJan = '������';
  SLongMonthNameFeb = '�������';
  SLongMonthNameMar = '����';
  SLongMonthNameApr = '������';
  SLongMonthNameMay = '���';
  SLongMonthNameJun = '����';
  SLongMonthNameJul = '����';
  SLongMonthNameAug = '������';
  SLongMonthNameSep = '��������';
  SLongMonthNameOct = '�������';
  SLongMonthNameNov = '������';
  SLongMonthNameDec = '�������';

  SShortDayNameSun = '��';
  SShortDayNameMon = '��';
  SShortDayNameTue = '��';
  SShortDayNameWed = '��';
  SShortDayNameThu = '��';
  SShortDayNameFri = '��';
  SShortDayNameSat = '��';

  SLongDayNameSun = '�����������';
  SLongDayNameMon = '�����������';
  SLongDayNameTue = '�������';
  SLongDayNameWed = '�����';
  SLongDayNameThu = '�������';
  SLongDayNameFri = '�������';
  SLongDayNameSat = '�������';

{  SInvalidInteger = 65408;
  SInvalidFloat = 65409;
  SInvalidDate = 65410;
  SInvalidTime = 65411;
  SInvalidDateTime = 65412;
  STimeEncodeError = 65413;
  SDateEncodeError = 65414;
  SOutOfMemory = 65415;
  SInOutError = 65416;
  SFileNotFound = 65417;
  SInvalidFilename = 65418;
  STooManyOpenFiles = 65419;
  SAccessDenied = 65420;
  SEndOfFile = 65421;
  SDiskFull = 65422;
  SInvalidInput = 65423;
  SDivByZero = 65424;
  SRangeError = 65425;
  SIntOverflow = 65426;
  SInvalidOp = 65427;
  SZeroDivide = 65428;
  SOverflow = 65429;
  SUnderflow = 65430;
  SInvalidPointer = 65431;
  SInvalidCast = 65432;
  SAccessViolation = 65433;
  SStackOverflow = 65434;
  SControlC = 65435;
  SPrivilege = 65436;
  SOperationAborted = 65437;
  SException = 65438;
  SExceptTitle = 65439;
  SInvalidFormat = 65440;
  SArgumentMissing = 65441;
  SInvalidVarCast = 65442;
  SInvalidVarOp = 65443;
  SDispatchError = 65444;
  SReadAccess = 65445;
  SWriteAccess = 65446;
  SResultTooLong = 65447;
  SFormatTooLong = 65448;
  SVarArrayCreate = 65449;
  SVarNotArray = 65450;
  SVarArrayBounds = 65451;
  SExternalException = 65452;
  SAssertionFailed = 65453;
  SIntfCastError = 65454;
  SAssertError = 65455;
  SModuleAccessViolation = 65456;
  SCannotReadPackageInfo = 65457;
  SErrorLoadingPackage = 65458;
  SInvalidPackageFile = 65459;
  SInvalidPackageHandle = 65460;
  SDuplicatePackageUnit = 65461;
  SWin32Error = 65462;
  SUnkWin32Error = 65463;

  SShortMonthNames = 65472;
  SLongMonthNames = 65488;
  SShortDayNames = 65504;
  SLongDayNames = 65511;}
