program BaseCreator;

{$APPTYPE CONSOLE}

{$R 'BaseTemplate.res' 'BaseTemplate.rc'}

uses
  Classes,
  SysUtils,
  ZLib,
  EntitiesCreator in 'EntitiesCreator.pas',
  LogsCreator in 'LogsCreator.pas',
  TrendsCreator in 'TrendsCreator.pas';

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
    Buffer: array[0..1023] of Byte;
begin
  decompStream:=TDecompressionStream.Create(aSource);
  try
    repeat
      nRead:=decompStream.Read(Buffer,1024);
      aTarget.Write(Buffer,nRead);
    until nRead = 0;
  finally
    decompStream.Free;
  end;
end;

procedure SaveCompressedTemplateToFile(FileName: string);
var M1,M2: TMemoryStream; ComprName: string;
begin
  M1:=TMemoryStream.Create;
  try
    M2:=TMemoryStream.Create;
    try
      M1.LoadFromFile(FileName);
      CompressStream(M1,M2);
      ComprName:=ChangeFileExt(FileName,'.ZIP');
      M2.SaveToFile(ComprName);
    finally
      M2.Free;
    end;
  finally
    M1.Free;
  end;
end;

procedure CreateEmptyBaseFile(FileName: string);
var RF: TResourceStream; M: TMemoryStream;
begin
  RF:=TResourceStream.Create(hInstance,'BaseTemplate','RT_RCDATA');
  try
    M:=TMemoryStream.Create;
    try
      DecompressStream(RF,M);
      M.SaveToFile(FileName);
    finally
      M.Free;
    end;
  finally
    RF.Free;
  end;
end;

procedure CreateREMXBASEFile(FileName: string);
begin
  if FileExists(FileName) then
    RenameFile(FileName,ChangeFileExt(FileName,'.~RM'));
  CreateEmptyBaseFile(FileName);
  CreateRemXDatabase(FileName);
end;

procedure CreateREMXLOGSFile(FileName: string);
begin
  if FileExists(FileName) then
    RenameFile(FileName,ChangeFileExt(FileName,'.~RM'));
  CreateEmptyBaseFile(FileName);
  CreateLogDatabase(FileName);
end;

procedure CreateREMXTRNDFile(FileName: string);
begin
  if FileExists(FileName) then
    RenameFile(FileName,ChangeFileExt(FileName,'.~RM'));
  CreateEmptyBaseFile(FileName);
  CreateTrendsDatabase(FileName);
end;

begin
  ForceDirectories(ExtractFilePath(ParamStr(0))+'Data');
//  CreateREMXBASEFile(ExtractFilePath(ParamStr(0))+'Data\BASE.RMX');
//  CreateREMXLOGSFile(ExtractFilePath(ParamStr(0))+'Data\LOGS.RMX');
  CreateREMXTRNDFile(ExtractFilePath(ParamStr(0))+'Data\TRENDS.RMX');
end.
