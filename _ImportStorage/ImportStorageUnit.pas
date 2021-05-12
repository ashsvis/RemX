unit ImportStorageUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, EntityUnit;

type
  TImportStorageForm = class(TForm)
    Bevel1: TBevel;
    Button1: TButton;
    Button2: TButton;
    LabelInfo: TLabel;
    Animate1: TAnimate;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    ACaddy: TCaddy;
    Step: integer;
    procedure ConvertBaseAndHistGroups;
    procedure ConvertSchemes;
    procedure ConvertTuning;
    procedure ConvertUsers;
    procedure CopyReports;
    procedure ConvertBathTimeReports;
//    procedure ConvertRealBaseValues;
//    procedure ConvertMinuteTrendValues(Params,TrendName: string);
//    procedure ConvertAllMinuteTrends;
  public
  end;

var
  ImportStorageForm: TImportStorageForm;

//procedure ReadAllFromFloatTable(BasePath,FileName: PChar); stdcall;
//                       external 'ImportBases.dll';
//procedure ReadAllFromMinuteTable(Params,TrendName,Path: PChar); stdcall;

implementation

uses Contnrs, ImportOldEntityUnit, DinElementsUnit, ImportOldSchemeUnit,
     EditSchemeUnit, IniFiles, ShowUsersUnit, ShowReportUnit, RemXUnit;

{$R *.dfm}

procedure TImportStorageForm.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TImportStorageForm.FormCreate(Sender: TObject);
begin
  ACaddy:=TCaddy.Create(Self);
  Step:=0;
  Button1.Click;
end;

procedure TImportStorageForm.Button1Click(Sender: TObject);
begin
  case Step of
    0: begin
         LabelInfo.Caption:='Преобразование данных из папки ".\STORAGE\"'+
                            ' в папку ".\IMPORT\"'+#13#13+
         'Для начала преобразования нажмите кнопку "Продолжить"'+#13+
         'Для завершения работы нажмите кнопку "Отменить"';
         Step:=1;
       end;
    1: begin
         Button1.Enabled:=False;
         Button2.Enabled:=False;
         if DirectoryExists(ExtractFilePath(Application.ExeName)+'STORAGE') then
         begin
           LabelInfo.Caption:='Преобразование данных...';
           LabelInfo.Height:=57;
           Animate1.Visible:=True;
           Animate1.Active:=True;
           ConvertBaseAndHistGroups;
           ConvertSchemes;
           ConvertTuning;
           ConvertUsers;
           CopyReports;
           ConvertBathTimeReports;
//           LabelInfo.Caption:='Преобразование данных...'+#13#13+
 //                             'Импорт сохраненных значений счетчиков.';
//           ConvertRealBaseValues;
//           ConvertAllMinuteTrends;
         end
         else
           RemXForm.ShowError('Папка "STORAGE" не найдена в текущем каталоге!');  
         Step:=2;
         Button1.Click;
       end;
    2: begin
         Button2.Enabled:=True;
         Button2.Caption:='Закрыть';
         LabelInfo.Caption:='Преобразование закончено.'+#13#13+
                            'Для завершения работы нажмите кнопку "Закрыть"';
         Animate1.Visible:=False;
         Animate1.Active:=False;
         LabelInfo.Height:=113;
       end;
  end;
end;

(*
procedure TImportStorageForm.ConvertMinuteTrendValues(Params,TrendName: string);
type
  TReadAllFromMinuteTable = procedure (Params,TrendName,Path: PChar); stdcall;
var
  HLib: THandle; Fp: TFarProc; Path: string;
  ReadAllFromMinuteTable: TReadAllFromMinuteTable;
begin
  HLib:=LoadLibrary('ImportBases.dll');
  try
    if HLib > 32 then
    begin
      Fp:=GetProcAddress(HLib,'ReadAllFromMinuteTable');
      if Assigned(Fp) then
      begin
        ReadAllFromMinuteTable:=TReadAllFromMinuteTable(Fp);
        Path:=ExtractFilePath(Application.ExeName)+'Import\Trends';
        ReadAllFromMinuteTable(PChar(Params),PChar(TrendName),PChar(Path));
      end;
    end;
  finally
    FreeLibrary(HLib);
  end;
end;

procedure TImportStorageForm.ConvertAllMinuteTrends;
var Params,TrendPath,Kind: string; i,j: integer;
begin
  TrendPath:=ExtractFilePath(Application.ExeName)+'Storage\Trends\Minutes';
  with ACaddy do
  begin
    for i:=1 to 125 do
    begin
      LabelInfo.Caption:='Преобразование трендов...'+#13+#13+
       IncludeTrailingPathDelimiter(TrendPath)+Format('Minute%3.3d',[i])+'.DAT';
      Application.ProcessMessages;
      HistGroups[i].Empty:=True;
      Params:='';
      for j:=1 to 8 do
      begin
        case HistGroups[i].Kind[j] of
        1: Kind:='.SP';
        2: Kind:='.OP';
        else
          Kind:='.PV';
        end;
        if HistGroups[i].Place[j] <> '' then
        begin
          HistGroups[i].Empty:=False;
          Params:=Params+HistGroups[i].Place[j]+Kind+';';
        end
        else
          Params:=Params+';';
      end;
      ConvertMinuteTrendValues(Params,
      IncludeTrailingPathDelimiter(TrendPath)+Format('Minute%3.3d',[i])+'.DAT');
    end;
  end;
end;

procedure TImportStorageForm.ConvertRealBaseValues;
type
  TReadAllFromFloatTable = procedure (BasePath,FileName: PChar); stdcall;
var
  BasePath,BasePath2: string; HLib: THandle; Fp: TFarProc;
  ReadAllFromFloatTable: TReadAllFromFloatTable;
begin
  BasePath:=ExtractFilePath(Application.ExeName)+'Storage\Base';
  BasePath2:=ExtractFilePath(Application.ExeName)+'Import\Config';
  if ForceDirectories(BasePath2) then
  begin
    HLib:=LoadLibrary('ImportBases.dll');
    try
      if HLib > 32 then
      begin
        Fp:=GetProcAddress(HLib,'ReadAllFromFloatTable');
        if Assigned(Fp) then
        begin
          ReadAllFromFloatTable:=TReadAllFromFloatTable(Fp);
          ReadAllFromFloatTable(PChar(BasePath),
            PChar(IncludeTrailingPathDelimiter(BasePath2)+'REALBASE.VAL'));
          ReadAllFromFloatTable(PChar(BasePath),
            PChar(IncludeTrailingPathDelimiter(BasePath2)+'REALBASE.DUB'));
        end
        else
          RemXForm.ShowWarning('Процедура ReadAllFromFloatTable не найдена в'+
          ' библиотеке ImportBases.dll. '+
          'Сохраненные значения счетчиков не были импортированы.');
      end
      else
        RemXForm.ShowWarning('Библиотека ImportBases.dll не найдена. '+
        'Сохраненные значения счетчиков не были импортированы.');
    finally
      FreeLibrary(HLib);
    end;
  end;
end;
*)

procedure TImportStorageForm.ConvertBathTimeReports;
var i: integer;
    Rif: TIniFile; SL: TStrings; RunTimeReports: TMemIniFile;
    SectName,BasePath: string;
begin
// Отчеты автоматической печати
  Rif:=TIniFile.Create(ExtractFilePath(Application.ExeName)+
                       'Storage\Config\WatchList.ini');
  RunTimeReports:=TMemIniFile.Create('');
  try
    SL:=TStringList.Create;
    try
      Rif.ReadSections(SL);
      for i:=0 to SL.Count-1 do
      begin
        SectName:=Format('PrintReport%d',[i+1]);
        RunTimeReports.WriteString(SectName,'FileName',
                                   Rif.ReadString(SL[i],'FileName',''));
        RunTimeReports.WriteString(SectName,'Descriptor',
                                   Rif.ReadString(SL[i],'Descriptor',''));
        RunTimeReports.WriteBool(SectName,'HandStart',
                                 Rif.ReadBool(SL[i],'HandStart',False));
        RunTimeReports.WriteTime(SectName,'StartTime',
                                 Rif.ReadTime(SL[i],'StartTime',0.0));
        RunTimeReports.WriteTime(SectName,'ShiftTime',
                                 Rif.ReadTime(SL[i],'ShiftTime',0.0));
      end;
      BasePath:=ExtractFilePath(Application.ExeName)+'Import\Config\';
      ShowReportUnit.SaveToFile(RunTimeReports,BasePath);
    finally
      SL.Free;
    end;
  finally
    Rif.Free;
    RunTimeReports.Free;
  end;
end;

procedure TImportStorageForm.CopyReports;
var sr: TSearchRec; FileAttrs: Integer; ReportPath,ReportPath2: string;
begin
// Отчеты
  ReportPath:=ExtractFilePath(Application.ExeName)+'Storage\Report';
  ReportPath2:=ExtractFilePath(Application.ExeName)+'Import\Report';
  if ForceDirectories(ReportPath2) then
  begin
    FileAttrs:=faDirectory;
    if FindFirst(IncludeTrailingPathDelimiter(ReportPath)+
                 '*.FRF',FileAttrs,sr) = 0 then
    begin
      repeat
        if (sr.Attr and FileAttrs) <> sr.Attr then
        begin
          LabelInfo.Caption:='Копирование отчетов...'+#13+#13+
                             IncludeTrailingPathDelimiter(ReportPath)+sr.Name;
          Application.ProcessMessages;
          CopyFile(PChar(IncludeTrailingPathDelimiter(ReportPath)+sr.Name),
                   PChar(IncludeTrailingPathDelimiter(ReportPath2)+sr.Name),False);
        end;
      until FindNext(sr) <> 0;
      FindClose(sr);
    end;
  end;
end;

procedure TImportStorageForm.ConvertUsers;
var Rif: TIniFile; Users: TMemIniFile; i,j,k: integer; SL: TStringList;
    Sect: string;
begin
// Пользователи
  Rif:=TIniFile.Create(ExtractFilePath(Application.ExeName)+
                       'Storage\Config\UserList.ini');
  Users:=TMemIniFile.Create('');
  SL:=TStringList.Create;
  try
    Rif.ReadSections(SL);
    for i:=0 to SL.Count-1 do
    begin
      j:=Users.ReadInteger('USERS','Count',0)+1;
      Sect:=Format('USER%d',[j-1]);
      Users.WriteInteger('USERS','Count',j);
      Users.WriteInteger(Sect,'ID',j-1);
      Users.WriteString(Sect,'LASTNAME',Rif.ReadString(SL[i],'Family',''));
      Users.WriteString(Sect,'FIRSTNAME',Rif.ReadString(SL[i],'Name',''));
      Users.WriteString(Sect,'SECONDNAME',Rif.ReadString(SL[i],'SecondName',''));
      k:=Rif.ReadInteger(SL[i],'Category',1);
      if k = 2 then k:=3 else if k = 3 then k:=5;
      Users.WriteInteger(Sect,'CATEGORY',k-1);
      Users.WriteString(Sect,'PASSWORD',Rif.ReadString(SL[i],'Password',''));
    end;
    ShowUsersUnit.SaveToFile(Users,
          ExtractFilePath(Application.ExeName)+'Import\Config\');
  finally
    SL.Free;
    Users.Free;
    Rif.Free;
  end;
end;

procedure TImportStorageForm.ConvertTuning;
const ABaud: array[0..8] of Cardinal =
          (300,1200,2400,4800,9600,19200,38400,57600,115200);
      ADatabits: array[0..3] of Byte = (5,6,7,8);
var Config: TMemIniFile; Rif: TIniFile; i,j,k: integer; S,Sect: string;
    SL: TStringList; TV: TTreeView; Node: TTreeNode; SS: TMemoryStream;
begin
  Config:=TMemIniFile.Create(ExtractFilePath(Application.ExeName)+
                             'Import\RemX.ini');
  try
    Rif:=TIniFile.Create(ExtractFilePath(Application.ExeName)+
                         'Storage\Config\Hardware.ini');
    try
      Config.WriteString('General','ObjectName',
                         Rif.ReadString('Object','Name',''));
      Config.WriteInteger('General','StationNumber',
                          Rif.ReadInteger('Station','Number',1)-1);
      Config.WriteString('General','StationName',
                         Rif.ReadString('Station','Name',''));
      Config.WriteString('General','RootScheme','MAIN.SCM');
      Config.WriteInteger('General','AlarmSound',
                          Rif.ReadInteger('Station','Beeper',1));
      Config.WriteInteger('General','PrintColor',
                          Rif.ReadInteger('Printer','Color',0));
      Config.WriteBool('General','SystemShell',
                       Rif.ReadBool('Station','WindowsShell',False));
      Config.WriteInteger('General','ScreenSize',
                          Rif.ReadInteger('Station','PanelSize',0));
// Порты
      for i:=1 to ChannelCount do
      begin
        S:=Format('Channel%d',[i]);
        Config.WriteInteger(S,'Port',Rif.ReadInteger(S,'COM',0));
        Config.WriteInteger(S,'TimeOut',2);
        j:=Rif.ReadInteger(S,'BaudRate',9600);
        Config.WriteInteger(S,'Baudrate',5);
        for k:=0 to 9 do
        if Cardinal(j) = ABaud[k] then
        begin
          Config.WriteInteger(S,'Baudrate',k+1);
          Break;
        end;
        j:=Rif.ReadInteger(S,'ByteSize',8);
        Config.WriteInteger(S,'DataSize',3);
        for k:=0 to 3 do
        if Cardinal(j) = ADatabits[k] then
        begin
          Config.WriteInteger(S,'DataSize',k);
          Break;
        end;
        Config.WriteInteger(S,'Stops',Rif.ReadInteger(S,'StopBits',0));
        Config.WriteInteger(S,'Parity',Rif.ReadInteger(S,'Parity',0));
      end;
// Подключаемые модули
      TV:=TTreeView.Create(Self);
      TV.Parent:=Self;
      SL:=TStringList.Create;
      SS:=TMemoryStream.Create;
      try
        Sect:='Utilities';
        Rif.ReadSectionValues(Sect,SL);
        i:=0;
        while i < SL.Count do
        begin
          j:=(i div 3)+1;
          Node:=TV.Items.Add(nil,
                  Rif.ReadString(Sect,Format('Caption%d',[j]),'?'));
          TV.Items.AddChild(Node,'Программа: '+
                  Rif.ReadString(Sect,Format('PathValue%d',[j]),'?'));
          S:=ExtractFilePath(Rif.ReadString(Sect,Format('PathValue%d',[j]),'?'));
          if (Length(S) > 0) and
             (S[Length(S)] = '\') then
            S:=Copy(S,1,Length(S)-1);
          TV.Items.AddChild(Node,'Рабочая папка: '+S);
          TV.Items.AddChild(Node,'Уровень доступа: '+
                UserCategories[Rif.ReadInteger(Sect,Format('Right%d',[j]),1)-1]);
          Inc(i,3);
        end;
        TV.SaveToStream(SS);
        SS.Position:=0;
        Config.WriteBinaryStream('OtherPrograms','ExternalModules',SS);
      finally
        SS.Free;
        SL.Free;
        TV.Free;
      end;
    finally
      Rif.Free;
    end;
    ConfigUpdateFile(Config);
  finally
    Config.Free;
  end;
end;

procedure TImportStorageForm.ConvertBaseAndHistGroups;
var Items: TComponentList; i,j: integer; M: TMemoryStream;
    O: TOldEntity; E: TEntity; AO: TAnaOut; CR: TCntReg;
    FileName, BasePath: string;
begin
  with ACaddy do
  begin
    EmptyBase;
//---- Очистка исторических групп -----
    for i:=1 to 125 do
    begin
      HistGroups[i].GroupName:='';
      HistGroups[i].Empty:=True;
      for j:=1 to 8 do
      begin
        HistGroups[i].Place[j]:='';
        HistGroups[i].Entity[j]:=nil;
        HistGroups[i].Kind[j]:=0;
        HistGroups[i].EU[j]:='';
        HistGroups[i].DF[j]:=1;
      end;
    end;
  end;
//---- Загрузка прототипов -----
  Items:=TComponentList.Create(True);
  M:=TMemoryStream.Create;
  try
    FileName:=ExtractFilePath(Application.ExeName)+'Storage\Config\Entity.ini';
    LoadOldEntityBase(FileName,Items);
    for i:=0 to Items.Count-1 do
    begin
      O:=Items[i] as TOldEntity;
      for j:=0 to EntityClassList.Count-1 do
      begin
        Application.ProcessMessages;
        if EntityClassList[j].ClassName = O.BrowserClass then
        begin
          E:=ACaddy.AddEntity(O.Name,j,TEntityCLass(EntityClassList[j]));
          if Assigned(E) then
          begin
            M.Clear;
            O.SaveToStream(M);
            M.Position:=0;
            E.LoadFromStream(M);
            if O is TAnaOut then
            begin
              AO:=O as TAnaOut;
              if (AO.PVGroup in [1..125]) and (AO.PVPlace in [1..8]) then
              with ACaddy do
              begin
                HistGroups[AO.PVGroup].Place[AO.PVPlace]:=E.PtName;
                HistGroups[AO.PVGroup].Entity[AO.PVPlace]:=E;
                HistGroups[AO.PVGroup].Kind[AO.PVPlace]:=0;
                HistGroups[AO.PVGroup].EU[AO.PVPlace]:=AO.EUDesc;
                HistGroups[AO.PVGroup].DF[AO.PVPlace]:=Ord(AO.PVFormat);
              end;
              if O is TCntReg then
              begin
                CR:=O as TCntReg;
                if (CR.SPGroup in [1..125]) and (CR.SPPlace in [1..8]) then
                with ACaddy do
                begin
                  HistGroups[CR.SPGroup].Place[CR.SPPlace]:=E.PtName;
                  HistGroups[CR.SPGroup].Entity[CR.SPPlace]:=E;
                  HistGroups[CR.SPGroup].Kind[CR.SPPlace]:=1;
                  HistGroups[CR.SPGroup].EU[CR.SPPlace]:=CR.EUDesc;
                  HistGroups[CR.SPGroup].DF[CR.SPPlace]:=Ord(CR.PVFormat);
                end;
                if (CR.OPGroup in [1..125]) and (CR.OPPlace in [1..8]) then
                with ACaddy do
                begin
                  HistGroups[CR.OPGroup].Place[CR.OPPlace]:=E.PtName;
                  HistGroups[CR.OPGroup].Entity[CR.OPPlace]:=E;
                  HistGroups[CR.OPGroup].Kind[CR.OPPlace]:=2;
                  HistGroups[CR.OPGroup].EU[CR.OPPlace]:='%';
                  HistGroups[CR.OPGroup].DF[CR.OPPlace]:=Ord(CR.PVFormat);
                end;
              end;
            end;
          end;
          Break;
        end;
      end;
    end;
  finally
    M.Free;
    Items.Free;
  end;
//---- Подключение ссылок внутри базы данных -----
  E:=ACaddy.FirstEntity;
  while E <> nil do
  begin
    E.ConnectLinks;
    E:=E.NextEntity;
  end;
//----
  ACaddy.Changed:=True;
  ACaddy.HistChanged:=True;
  BasePath:=ExtractFilePath(Application.ExeName)+'Import\Config\';
  if ForceDirectories(BasePath) then
  begin
    ACaddy.SaveBase(BasePath);
    ACaddy.SaveHistGroups(BasePath);
  end;
end;

procedure TImportStorageForm.ConvertSchemes;
var sr: TSearchRec; FileAttrs: Integer; SchemePath, SchemePath2: string;
    DinList,Items: TComponentList; Background: TBackground;
    M: TMemoryStream; O: TDinamic; i: integer; C: TDinControl;
    HasChanded: Boolean;
begin
  DinList:=TComponentList.Create;
  Background:=TBackground.Create(Self);
  try
    SchemePath:=ExtractFilePath(Application.ExeName)+'Storage\Scheme';
    SchemePath2:=ExtractFilePath(Application.ExeName)+'Import\Scheme';
    FileAttrs:=faDirectory;
    if FindFirst(IncludeTrailingPathDelimiter(SchemePath)+'*.MSC',
                 FileAttrs,sr) = 0 then
    begin
      repeat
        if (sr.Attr and FileAttrs) <> sr.Attr then
        begin
//---- Загрузка прототипов -----
          DinList.Clear;
          Background.Clear;
          Items:=TComponentList.Create(True);
          M:=TMemoryStream.Create;
          try
            LoadOldSchemeFromFile(IncludeTrailingPathDelimiter(SchemePath)+
                                  sr.Name,Items,Background);
            for i:=0 to Items.Count-1 do
            begin
              LabelInfo.Caption:='Преобразование мнемосхем...'+#13+#13+
                              IncludeTrailingPathDelimiter(SchemePath)+sr.Name;
              Application.ProcessMessages;
              O:=Items[i] as TDinamic;
              C:=ADin[O.DinamicType].Name.Create(Self);
              C.DinType:=O.DinamicType;
              C.Parent:=Background;
              C.Editing:=True;
              DinList.Add(C);
              M.Clear;
              O.SaveToStream(M);
              M.Position:=0;
              C.LoadFromStream(M);
            end;
            if ForceDirectories(SchemePath2) then
              SaveSchemeToFile(ChangeFileExt(
                  IncludeTrailingPathDelimiter(SchemePath2)+sr.Name,'.SCM'),
                               Background,DinList,HasChanded);
          finally
            M.Free;
            Items.Free;
          end;
        end;
      until FindNext(sr) <> 0;
      FindClose(sr);
    end;
  finally
    DinList.Free;
    Background.Free;
  end;
end;

end.
