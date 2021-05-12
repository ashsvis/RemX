'Сценарий для создания резервной копии статических файлов каталога Data системы RemX
'Автор: AShHome, 2006 г.
Set FSO = CreateObject("Scripting.FileSystemObject")
sIniFile = "Data\RemX.ini"
sDataConfig = "Data\Config"
sDataScheme = "Data\Scheme"
sDataReport = "Data\Report"

sDataReports = "Data\Reports"
sDataTables = "Data\Tables"
sDataTrends = "Data\Trends"
sDataLogs = "Data\Logs"

sGoalDir = "Data.Backup"
If FSO.FolderExists("Data") Then
  If Not FSO.FolderExists(sGoalDir) Then FSO.CreateFolder(sGoalDir)
  If FSO.FileExists(sIniFile) Then CopyFile sIniFile, sGoalDir
  If FSO.FolderExists(sDataConfig) Then CopyFolder sDataConfig, sGoalDir
  If FSO.FolderExists(sDataScheme) Then CopyFolder sDataScheme, sGoalDir
  If FSO.FolderExists(sDataReport) Then CopyFolder sDataReport, sGoalDir
End If

sGoalDir = "Reports.Backup"
If FSO.FolderExists(sDataReports) Then
  If Not FSO.FolderExists(sGoalDir) Then FSO.CreateFolder(sGoalDir)
  CopyFolder sDataReports, sGoalDir
End If
'
'sGoalDir = "Backup.Tables"
'If FSO.FolderExists(sDataTables) Then
'  If Not FSO.FolderExists(sGoalDir) Then FSO.CreateFolder(sGoalDir)
'  CopyFolder sDataTables, sGoalDir
'End If
'
'sGoalDir = "Backup.Trends"
'If FSO.FolderExists(sDataTrends) Then
'  If Not FSO.FolderExists(sGoalDir) Then FSO.CreateFolder(sGoalDir)
'  CopyFolder sDataTrends, sGoalDir
'End If
'
'sGoalDir = "Backup.Logs"
'If FSO.FolderExists(sDataLogs) Then
'  If Not FSO.FolderExists(sGoalDir) Then FSO.CreateFolder(sGoalDir)
'  CopyFolder sDataLogs, sGoalDir
'End If

If Err.Number = 0 Then Wscript.Echo "Копирование успешно завершено"

Sub CopyFolder(sFOLDER, sDIR)
  If Right(sFOLDER,1) = "\" Then sFOLDER = Left(sFOLDER,(Len(sFOLDER)-1))
  If Right(sDIR,1) <> "\" Then sDIR = sDIR & "\"
  On Error Resume Next
  FSO.CopyFolder sFOLDER, sDIR, True
  If Err.Number <> 0 Then Wscript.Echo "Ошибка копирования папки: " & sFOLDER
End Sub

Sub CopyFile(sFILE, sDIR)
  If Right(sDIR,1) <> "\" Then sDIR = sDIR & "\"
  On Error Resume Next
  FSO.CopyFile sFILE, sDIR, True
  If Err.Number <> 0 Then Wscript.Echo "Ошибка копирования файла: " & sFILE
End Sub
