unit TuningUnit;

interface

uses Classes;

procedure SystemTuning(AOwner: TComponent);
procedure SerialPortsTuning;
procedure EthernetPortsTuning;
procedure ShellTuning;
procedure RemXStationsNetTuning(FirstBoot: boolean = False);
procedure OldTimesTuning;

implementation

uses Windows, SysUtils, Controls, Forms, EntityUnit, ShowTuningUnit,
     Registry, DateUtils, RemXUnit, ComPort, KontLink, PanelFormUnit;

const
  AOldTimes: array[0..12] of Integer = (0,1,3,5,7,10,14,31,45,60,92,183,366);
  ATimeout: array[0..17] of Word = (3,6,12,23,45,91,182,384,546,
                    910,1820,2730,3640,5460,10920,21840,32760,54600);

procedure SerialPortsTuning;
var i,j: integer;
begin
  for i:=1 to ChannelCount do
  with Caddy.FetchList[i] do
  if Config.ReadInteger('Channel'+IntToStr(i),'TransportProtocol',0) = 0 then
  begin
    UseNet := False;
    j:=Config.ReadInteger('Channel'+IntToStr(i),'Port',0);
    if j in [1..99] then
    begin
      try
        if (ComLink.ComNumber <> j) and ComLink.Connect then
          ComLink.Close;
        ComLink.ComNumber:=j;
        ComLink.ComProp.BaudRate:=TBaudRate(Config.ReadInteger('Channel'+
                                            IntToStr(i),'Baudrate',5));
        ComLink.ComProp.Parity:=TParity(Config.ReadInteger('Channel'+
                                            IntToStr(i),'Parity',0));
        ComLink.ComProp.ByteSize:=TByteSize(Config.ReadInteger('Channel'+
                                            IntToStr(i),'DataSize',3));
        ComLink.ComProp.StopBits:=TStopbits(Config.ReadInteger('Channel'+
                                            IntToStr(i),'Stops',1));
        TimeOut:=Config.ReadInteger('Channel'+IntToStr(i),'TimeOut',800);
        ComLink.TimeoutInterval:=TimeOut;
        RepeatCount:=Config.ReadInteger('Channel'+IntToStr(i),'RepeatCount',2);
        SaveToLog:=Config.ReadBool('Channel'+IntToStr(i),'SaveToLog',False);
        LinkType:=Config.ReadInteger('Channel'+IntToStr(i),'LinkType',0);
        ComLink.LinkType:=TLinkType(LinkType);
        NodeWait:=Config.ReadInteger('Channel'+IntToStr(i),'NodeWait',30)*1000;
        if not ComLink.Connected then
        begin
          ComLink.Open;
          if ComLink.Connected then
            ComLink.ReadActive:=True
          else
            raise Exception.Create('Ошибка открытия COM'+IntToStr(j)+'!');
        end;
      except
        on E: Exception do
        begin
          Config.WriteInteger('Channel'+IntToStr(i),'Port',0);
          Caddy.AddSysMess('Канал '+IntToStr(i)+'.',
                           'Открытие COM'+IntToStr(j)+
                           ' при настройке: '+E.Message);
          Caddy.ShowMessage(kmStatus,E.Message);
          Windows.Beep(1000,100);
          Sleep(100);
          Windows.Beep(1000,100);
        end;
      end;
    end
    else
      if ComLink.Connected then ComLink.Close;
  end;
end;

procedure EthernetPortsTuning;
var
  i: integer;
  Host, Port: string;
begin
  for i:=1 to ChannelCount do
  with Caddy.FetchList[i] do
  if Config.ReadInteger('Channel'+IntToStr(i),'TransportProtocol',0) = 1 then
  begin
    try
      UseNet := True;
      Host := Config.ReadString('Channel'+IntToStr(i),'PrimaryAddr','');
      Port := Config.ReadString('Channel'+IntToStr(i),'PrimaryPort','');
      if ((TcpLink.Host <> Host) or (TcpLink.Port <> Port)) and
          TcpLink.Active then TcpLink.Close;
      TimeOut:=Config.ReadInteger('Channel'+IntToStr(i),'TimeOut',800);

//      NetLinkPrimary.TimeoutInterval:=TimeOut;
      RepeatCount:=Config.ReadInteger('Channel'+IntToStr(i),'RepeatCount',2);
      SaveToLog:=Config.ReadBool('Channel'+IntToStr(i),'SaveToLog',False);
      LinkType:=Config.ReadInteger('Channel'+IntToStr(i),'LinkType',0);
      NodeWait:=Config.ReadInteger('Channel'+IntToStr(i),'NodeWait',30)*1000;
      TcpLink.Host := Config.ReadString('Channel'+IntToStr(i),'PrimaryAddr','');
      TcpLink.Port := Config.ReadString('Channel'+IntToStr(i),'PrimaryPort','');
      TcpLink.TimeOut := TimeOut;
      TcpLink.RepeatCount := RepeatCount;
      if not TCPLink.Active then
      begin
        TcpLink.Open;
        if not TcpLink.Active then
          raise Exception.Create('Ошибка открытия сетевого соединения!');
      end;
    except
      on E: Exception do
      begin
        Config.WriteInteger('Channel'+IntToStr(i),'Port',0);
        Caddy.AddSysMess('Канал '+IntToStr(i)+'.',
                         'Открытие сетевого соединения'+
                         ' при настройке: '+E.Message);
        Caddy.ShowMessage(kmStatus,E.Message);
        Windows.Beep(1000,100);
        Sleep(100);
        Windows.Beep(1000,100);
      end;
    end;
  end
  else
  begin
    UseNet := False;
    if TcpLink.Active then TcpLink.Close;
  end;
end;

procedure ShellTuning;
var Reg: TRegistry;
begin
  Reg:=TRegistry.Create;
  try
    Reg.RootKey:=HKEY_CURRENT_USER;
    if RemXForm.MyProcIsShell then
    begin
      if Reg.OpenKey(
        'Software\Microsoft\Windows NT\CurrentVersion\Winlogon',True) then
      begin
        Reg.WriteString('Shell',Application.ExeName);
        Reg.CloseKey;
      end;
      if Reg.OpenKey(
        'Software\Microsoft\Windows\CurrentVersion\Policies\System',True) then
      begin
        Reg.WriteInteger('DisableChangePassword',1);
        Reg.WriteInteger('DisableLockWorkstation',1);
        Reg.WriteInteger('DisableTaskMgr',1);
        Reg.CloseKey;
      end;
    end
    else
    begin
      if Reg.OpenKey(
        'Software\Microsoft\Windows NT\CurrentVersion\Winlogon',False) then
      begin
        Reg.WriteString('Shell','');
        Reg.CloseKey;
      end;
      if Reg.OpenKey(
        'Software\Microsoft\Windows\CurrentVersion\Policies\System',False) then
      begin
        Reg.WriteInteger('DisableChangePassword',0);
        Reg.WriteInteger('DisableLockWorkstation',0);
        Reg.WriteInteger('DisableTaskMgr',0);
        Reg.CloseKey;
      end;
    end;
  finally
    Reg.Free;
  end;
end;

procedure RemXStationsNetTuning(FirstBoot: boolean = False);
var OldNetRole: string;
begin
  case Caddy.NetRole of
   nrStandAlone: OldNetRole:='Независимая';
   nrServer: OldNetRole:='Сервер';
   nrClient: OldNetRole:='Клиент';
  end;
  case Config.ReadInteger('NetLink','NetRole',0) of
   0: begin
        Caddy.StationsLink.Close;
        Caddy.NetRole := nrStandAlone;
        if not FirstBoot then
          Caddy.AddChange('Система','Станция',OldNetRole,'Независимая',
                          'Роль станции в сети',Caddy.Autor);
        Application.Title:='RemX';
      end;
  else
      begin
        Caddy.StationsLink.Close;
        Caddy.FetchList[0].SaveToLog:=
                            Config.ReadBool('NetLink','SaveToLog',False);
        Caddy.StationsLink.Port:=Config.ReadString('NetLink','ServerPort','');
        Caddy.StationsLink.Host:=Config.ReadString('NetLink','ServerAddress','');
        if Config.ReadInteger('NetLink','NetRole',0) = 1 then
        begin
          Caddy.StationsLink.Server:=True;
          Caddy.NetRole:=nrServer;
          if not FirstBoot then
            Caddy.AddChange('Система','Станция',OldNetRole,'Сервер',
                            'Роль станции в сети',Caddy.Autor);
          Application.Title:='RemX (сервер)';
        end
        else
        begin
          Caddy.StationsLink.Server:=False;
          Caddy.NetRole:=nrClient;
          if not FirstBoot then
            Caddy.AddChange('Система','Станция',OldNetRole,'Клиент',
                            'Роль станции в сети',Caddy.Autor);
          Application.Title:='RemX (клиент)';
        end;
        Caddy.StationsLink.Open;
      end;
  end;
end;

procedure OldTimesTuning;
begin
  Caddy.TrendOldTimes:=
         AOldTimes[Config.ReadInteger('Archives','TrendOldTimes',4)];
  Caddy.SnapMinOldTimes:=
         AOldTimes[Config.ReadInteger('Archives','SnapMinOldTimes',4)];
  Caddy.SnapHourOldTimes:=
         AOldTimes[Config.ReadInteger('Archives','SnapHourOldTimes',9)];
  Caddy.AverHourOldTimes:=
         AOldTimes[Config.ReadInteger('Archives','AverHourOldTimes',9)];
  Caddy.LogOldTimes:=
         AOldTimes[Config.ReadInteger('Archives','LogsOldTimes',4)];
  Caddy.ReportLogOldTimes:=
         AOldTimes[Config.ReadInteger('Archives','ReportLogsOldTimes',11)];
end;

procedure SystemTuning(AOwner: TComponent);
var DT: TDateTime; i,MR, idx: integer; si,txt: string; SS: TMemoryStream;
    SoundChanged,NetCfgChanged: boolean; ST: SYSTEMTIME;
    yy,mm,dd,hh,nn,se,ms: Word; sl: TStringList;
begin
  ShowTuningForm:=TShowTuningForm.Create(AOwner);
  try
    DT:=Now;
    with ShowTuningForm do
    begin
      Panel := AOwner as TPanelForm;
      dtpDate.DateTime:=Int(DT);
      dtpTime.DateTime:=Frac(DT);
      i:=Config.ReadInteger('TuningShowForm','LastPageIndex',0);
      if PageControl.Pages[i].TabVisible then
        PageControl.TabIndex:=i
      else
        PageControl.TabIndex:=0;
      i:=Config.ReadInteger('TuningShowForm','LastTabIndex',0);
      tcLink.TabIndex:=i;
// Вкладка "Общие"
      edObjectName.Text:=Config.ReadString('General','ObjectName','');
      cbStationNumber.ItemIndex:=Config.ReadInteger('General','StationNumber',0);
      edStationName.Text:=Config.ReadString('General','StationName','');
      cbRootScheme.Text:=Config.ReadString('General','RootScheme','MAIN.SCM');
      cbSchemeSize.ItemIndex:=Config.ReadInteger('General','ScreenSize',1);
      cbMonitors.ItemIndex:=Config.ReadInteger('General','Monitors',0);
      cbAlarmSound.ItemIndex:=Config.ReadInteger('General','AlarmSound',1);
      cbPrintColor.ItemIndex:=Config.ReadInteger('General','PrintColor',0);
      cbSystemShell.Checked:=Config.ReadBool('General','SystemShell',False);
      cbDigErrFilter.Checked:=Config.ReadBool('General','DigErrFilter',False);
      cbNoAsk.Checked:=Config.ReadBool('General','NoAsk',False);
      cbNoAddNoLinkInAciveLog.Checked:=Config.ReadBool('General','NoAddNoLinkInAciveLog',False);
// Вкладка "Сети контроллеров"
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
// Вкладка "Подключаемые модули"
      SS:=TMemoryStream.Create;
      try
        Config.ReadBinaryStream('OtherPrograms','ExternalModules',SS);
        SS.Position:=0;
        tvExternalModules.LoadFromStream(SS);
      finally
        SS.Free;
      end;
// Вкладка "Поддержка"
      clbSupport.Clear;
      for i:=0 to NodeList.Count-1 do
        clbSupport.AddItem(Format('%d. ',[i+1])+NodeList.Strings[i],nil);
// Вкладка "Связь по сети"
      cbNetRole.ItemIndex:=Config.ReadInteger('NetLink','NetRole',0);
      leServerAddress.Text:=Config.ReadString('NetLink','ServerAddress','');
      leServerPort.Text:=Config.ReadString('NetLink','ServerPort','');
      cbSaveToLogForNet.Checked:=Config.ReadBool('NetLink','SaveToLog',False);
      chkExportActive.Checked:=Config.ReadBool('OnlineExportMinuteTables',
                               'ExportActive',False);
      lbledtConnectionString.Text:=Config.ReadString('OnlineExportMinuteTables',
                               'ConnectionString','');
// Вкладка "Архивы"
      cbDelTrends.ItemIndex:=Config.ReadInteger('Archives','TrendOldTimes',4);
      cbDelSnapMin.ItemIndex:=Config.ReadInteger('Archives','SnapMinOldTimes',4);
      cbDelSnapHour.ItemIndex:=Config.ReadInteger('Archives','SnapHourOldTimes',9);
      cbDelAverHour.ItemIndex:=Config.ReadInteger('Archives','AverHourOldTimes',9);
      cbDelLogs.ItemIndex:=Config.ReadInteger('Archives','LogsOldTimes',4);
      cbDelReportLogs.ItemIndex:=Config.ReadInteger('Archives','ReportLogsOldTimes',11);
      // пути хранения файлов
      edtPathTrends.Text := Caddy.CurrentTrendPath;
      edtPathTables.Text := Caddy.CurrentTablePath;
      edtPathLogs.Text := Caddy.CurrentLogsPath;
      edtPathReports.Text := Caddy.CurrentReportsLogPath;
// Вкладка "Меню мнемосхем"
      SS:=TMemoryStream.Create;
      sl := TStringList.Create;
      try
        Config.ReadBinaryStream('MenuSchemes','SchemeTree',SS);
        SS.Position:=0;
        tvSchemeTree.LoadFromStream(SS);
        for i := 0 to tvSchemeTree.Items.Count - 1 do
        begin
          if tvSchemeTree.Items[i].Level = 1 then
          begin
            sl.CommaText := tvSchemeTree.Items[i].Text;
            if sl.Count > 0 then
              tvSchemeTree.Items[i].Text := sl[0];
            if sl.Count > 1 then
            begin
              txt := sl[1];
              idx := FSchemeLink.IndexOf(txt);
              if idx < 0 then idx := FSchemeLink.Add(txt);
              tvSchemeTree.Items[i].SelectedIndex := idx;
            end;
          end;
        end;
      finally
        sl.Free;
        SS.Free;
      end;

// Предъявление формы для изменения параметров
      repeat
        MR:=ShowModal;
        if MR = mrOk then
        begin
          if not Timer.Enabled then
          begin
            DT:=Int(dtpDate.DateTime)+Frac(dtpTime.DateTime);
            if YearOf(DT) >= 2000 then
            begin
              DecodeDate(DT,yy,mm,dd);
              DecodeTime(DT,hh,nn,se,ms);
              ST.wYear:=yy;
              ST.wMonth:=mm;
              ST.wDay:=dd;
              ST.wHour:=hh;
              ST.wMinute:=nn;
              ST.wSecond:=se;
              ST.wMilliseconds:=0;
              SetLocalTime(ST);
            end;
          end;
          Config.WriteInteger('TuningShowForm','LastPageIndex',
                               PageControl.TabIndex);
          Config.WriteInteger('TuningShowForm','LastTabIndex',tcLink.TabIndex);
// Вкладка "Общие"
          if edObjectName.Text <>
             Config.ReadString('General','ObjectName','') then
          begin
            Caddy.AddChange('Настройка','Объект','Было:','',
                    Config.ReadString('General','ObjectName',''),Caddy.Autor);
            Caddy.AddChange('Настройка','Объект','','Стало:',
                    edObjectName.Text,Caddy.Autor);
            Config.WriteString('General','ObjectName',edObjectName.Text);
          end;
          if cbStationNumber.ItemIndex <>
             Config.ReadInteger('General','StationNumber',0) then
          begin
            Caddy.Station:=Config.ReadInteger('General','StationNumber',0)+1;
            Caddy.AddChange('Настройка','Cтанция',
                    IntToStr(Config.ReadInteger('General','StationNumber',0)),
                    IntToStr(cbStationNumber.ItemIndex),
                    'Номер рабочей станции',Caddy.Autor);
            Config.WriteInteger('General','StationNumber',cbStationNumber.ItemIndex);
          end;
          if edStationName.Text <>
             Config.ReadString('General','StationName','') then
          begin
            Caddy.AddChange('Настройка','Станция','Было:','',
                    Config.ReadString('General','StationName',''),Caddy.Autor);
            Caddy.AddChange('Настройка','Станция','','Стало:',
                    edStationName.Text,Caddy.Autor);
            Config.WriteString('General','StationName',edStationName.Text);
          end;
          if cbRootScheme.Text <>
             Config.ReadString('General','RootScheme','MAIN.SCM') then
          begin
            Caddy.AddChange('Настройка','Корневая','Было:','',
                    Config.ReadString('General','RootScheme','MAIN.SCM'),Caddy.Autor);
            Caddy.AddChange('Настройка','Корневая','','Стало:',
                    cbRootScheme.Text,Caddy.Autor);
            Config.WriteString('General','RootScheme',cbRootScheme.Text);
            RemXForm.RootSchemeName:=cbRootScheme.Text;
          end;
          Config.WriteInteger('General','ScreenSize',cbSchemeSize.ItemIndex);
          Config.WriteInteger('General','Monitors',cbMonitors.ItemIndex);
          SoundChanged:=False;
          if cbAlarmSound.ItemIndex <>
             Config.ReadInteger('General','AlarmSound',1) then
          begin
            Config.WriteInteger('General','AlarmSound',cbAlarmSound.ItemIndex);
            SoundChanged:=True;
          end;
          Config.WriteInteger('General','PrintColor',cbPrintColor.ItemIndex);
          Config.WriteBool('General','SystemShell',cbSystemShell.Checked);
          RemXForm.MyProcIsShell:=cbSystemShell.Checked;
          Config.WriteBool('General','DigErrFilter',cbDigErrFilter.Checked);
          Caddy.DigErrFilter := cbDigErrFilter.Checked;
          Config.WriteBool('General','NoAsk',cbNoAsk.Checked); // добавлено 15.07.12
          Caddy.NoAsk := cbNoAsk.Checked;                      // добавлено 15.07.12
          Config.WriteBool('General','NoAddNoLinkInAciveLog',
               cbNoAddNoLinkInAciveLog.Checked);
          Caddy.NoAddNoLinkInAciveLog := cbNoAddNoLinkInAciveLog.Checked;
          i:=tcLink.TabIndex+1;
// Вкладка "Сети контроллеров"
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
// Вкладка "Подключаемые модули"
          SS:=TMemoryStream.Create;
          try
            tvExternalModules.SaveToStream(SS);
            SS.Position:=0;
            Config.WriteBinaryStream('OtherPrograms','ExternalModules',SS);
          finally
            SS.Free;
          end;
// Вкладка "Сеть RemX"
          NetCfgChanged:=cbNetRole.ItemIndex <>
                         Config.ReadInteger('NetLink','NetRole',0);
          Config.WriteInteger('NetLink','NetRole',cbNetRole.ItemIndex);
          Config.WriteString('NetLink','ServerAddress',leServerAddress.Text);
          Config.WriteString('NetLink','ServerPort',leServerPort.Text);
          Config.WriteBool('NetLink','SaveToLog',cbSaveToLogForNet.Checked);

          Config.WriteBool('OnlineExportMinuteTables','ExportActive',
                           chkExportActive.Checked);
          Config.WriteString('OnlineExportMinuteTables','ConnectionString',
                              lbledtConnectionString.Text);
          Caddy.ConnectionString:=lbledtConnectionString.Text;
          Caddy.ExportActive:=chkExportActive.Checked;

// Вкладка "Архивы"
          Config.WriteInteger('Archives','TrendOldTimes',cbDelTrends.ItemIndex);
          Config.WriteInteger('Archives','SnapMinOldTimes',cbDelSnapMin.ItemIndex);
          Config.WriteInteger('Archives','SnapHourOldTimes',cbDelSnapHour.ItemIndex);
          Config.WriteInteger('Archives','AverHourOldTimes',cbDelAverHour.ItemIndex);
          Config.WriteInteger('Archives','LogsOldTimes',cbDelLogs.ItemIndex);
          Config.WriteInteger('Archives','ReportLogsOldTimes',cbDelReportLogs.ItemIndex);
          OldTimesTuning;
          // пути хранения файлов
          Caddy.CurrentTrendPath := edtPathTrends.Text;
          Config.WriteString('Archives','CurrentTrendPath',edtPathTrends.Text);
          Caddy.CurrentTablePath := edtPathTables.Text;
          Config.WriteString('Archives','CurrentTablePath',edtPathTables.Text);
          Caddy.CurrentLogsPath := edtPathLogs.Text;
          Config.WriteString('Archives','CurrentLogsPath',edtPathLogs.Text);
          Caddy.CurrentReportsLogPath := edtPathReports.Text;
          Config.WriteString('Archives','CurrentReportsLogPath',edtPathReports.Text);
// Вкладка "Меню мнемосхем"
          SS:=TMemoryStream.Create;
          sl := TStringList.Create;
          try
            for i := 0 to tvSchemeTree.Items.Count - 1 do
            begin
              if tvSchemeTree.Items[i].Level = 1 then
              begin
                sl.Clear;
                sl.Add(tvSchemeTree.Items[i].Text);
                sl.Add(FSchemeLink[tvSchemeTree.Items[i].SelectedIndex]);
                tvSchemeTree.Items[i].Text :=
                  sl.CommaText;
              end;
            end;
            tvSchemeTree.SaveToStream(SS);
            SS.Position:=0;
            Config.WriteBinaryStream('MenuSchemes','SchemeTree',SS);
          finally
            sl.Free;
            SS.Free;
          end;
// Запись изменений на диск
          ConfigUpdateFile(Config);
          Panel.UpdateExtPrograms;
          Panel.UpdateMenuSchemes;
          if NetCfgChanged then RemXStationsNetTuning;
          if Caddy.NetRole = nrClient then
          begin
            for i:=1 to ChannelCount do
            if Caddy.FetchList[i].ComLink.Connected then
              Caddy.FetchList[i].ComLink.Close;
          end
          else
          begin
            SerialPortsTuning;
            EthernetPortsTuning;
          end;
          ShellTuning;
          if SoundChanged then
          begin
            Caddy.BeeperKind:=TBeeperKind(Config.ReadInteger('General',
                             'AlarmSound',1));
            Caddy.Beeper.Kind:=Caddy.BeeperKind;
          end;
          Break;
        end;
      until MR <> mrOK;
    end;
  finally
    ShowTuningForm.Free;
  end;
end;

end.
