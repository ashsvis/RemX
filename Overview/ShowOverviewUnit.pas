unit ShowOverviewUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Contnrs, EntityUnit, DinElementsUnit, Menus, PanelFormUnit,
  FR_Class;

type
  TShowOverviewForm = class(TForm, IFresh)
    DinPopupMenu: TPopupMenu;
    miPasport: TMenuItem;
    miQuit: TMenuItem;
    N1: TMenuItem;
    miBase: TMenuItem;
    miTrend: TMenuItem;
    N2: TMenuItem;
    miInputValue: TMenuItem;
    miInputSP: TMenuItem;
    miInputOP: TMenuItem;
    miInputMode: TMenuItem;
    miSeparator: TMenuItem;
    SchemePopupMenu: TPopupMenu;
    N3: TMenuItem;
    miDirectPrint: TMenuItem;
    miInversePrint: TMenuItem;
    frScreenReport: TfrReport;
    Box: TScrollBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BackgroundMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DinPopupMenuPopup(Sender: TObject);
    procedure miPasportClick(Sender: TObject);
    procedure miQuitClick(Sender: TObject);
    procedure miBaseClick(Sender: TObject);
    procedure miDigitalOnClick(Sender: TObject);
    procedure miInputValueClick(Sender: TObject);
    procedure miInputSPClick(Sender: TObject);
    procedure miInputOPClick(Sender: TObject);
    procedure miInputModeClick(Sender: TObject);
    procedure miTrendClick(Sender: TObject);
    procedure miDirectPrintClick(Sender: TObject);
    procedure miInversePrintClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  private
    Background: TBackground;
    DinList: TComponentList;
    Curr: TDinControl;
    FPanel: TPanelForm;
    procedure DinJumperClick(var Msg: TMessage); message WM_DinJumperClick;
    procedure DinButtonClick(var Msg: TMessage); message WM_DinButtonClick;
    procedure DinKonturClick(var Msg: TMessage); message WM_DinKonturClick;
    procedure DinSetFocus(Sender: TObject; Shift: TShiftState);
    procedure DinPopup;
    procedure InitBackground;
    procedure PrintWorkScreen(Invert: boolean);
    procedure SetPanel(const Value: TPanelForm);
  public
    procedure LoadSchemeFromFile(FileName: string; E: TEntity = nil);
    procedure FreshView; stdcall;
    procedure SelectNextDin;
    procedure SelectPrevDin;
    procedure DinPressKey;
    property Panel: TPanelForm read FPanel write SetPanel;
  end;

var
  ShowOverviewForm: TShowOverviewForm;

implementation

uses DinJumperEditorUnit, GetDigValUnit, GetPtNameUnit,
     VirtualUnit, GetRegModeValUnit, ShowRealTrendUnit, RemXUnit,
     DinButtonEditorUnit, Math, PrintDialogUnit, JPEG, DateUtils;

{$R *.dfm}

procedure TShowOverviewForm.InitBackground;
begin
  Background:=TBackground.Create(Self);
  Background.SetBounds(0,0,PanelWidth,PanelHeight);
  Background.Parent:=Box;
  Background.OnMouseDown:=BackgroundMouseDown;
  Background.ShowHint:=True;
end;

procedure TShowOverviewForm.FormCreate(Sender: TObject);
begin
  DinList:=TComponentList.Create(True);
  InitBackground;
end;

procedure TShowOverviewForm.SetPanel(const Value: TPanelForm);
begin
  FPanel := Value;
  if FPanel <> nil then
  begin
    Box.VertScrollBar.Visible := FPanel.Height < PanelHeight + FPanel.CustomHeight;
    Box.HorzScrollBar.Visible := FPanel.Width < PanelWidth;
  end;
end;

procedure TShowOverviewForm.FormDestroy(Sender: TObject);
begin
  frScreenReport.Free;
  DinList.Free;
  Background.Free;
end;

procedure TShowOverviewForm.LoadSchemeFromFile(FileName: string; E: TEntity = nil);
var DinType: byte; M: TMemoryStream; P: Int64; C: TDinControl;
begin
  Screen.Cursor:=crHourGlass;
  try
    DinList.Clear;
    Background.Clear;
    M:=TMemoryStream.Create;
    try
      if LoadStream(FileName,M) then
      begin
        Background.LoadFromStream(M);
        Color := Background.Color;
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
            C.OnSetFocus:=DinSetFocus;
            C.BringToFront;
            C.Editing:=False;
            C.PopupMenu:=DinPopupMenu;
            DinList.Add(C);
          except
            C:=nil;
          end;
          if Assigned(C) then
          begin
            if C.LoadFromStream(M) = 0 then Break;
            if (E <> nil) and (E.PtName = C.LinkName)
              then C.Focused := True; 
          end
          else
            Break;
        end;
      end
      else
        RemXForm.ShowError('Ошибка при загрузке файла "'+
                           ExtractFileName(FileName)+'"');
    finally
      M.Free;
    end;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TShowOverviewForm.DinSetFocus(Sender: TObject; Shift: TShiftState);
var i: integer; C: TDinControl; E: TEntity;
begin
  for i:=0 to DinList.Count-1 do
  begin
    C:=DinList.Items[i] as TDinControl;
    C.Focused:=False;
  end;
  Curr:=Sender as TDinControl;
  Curr.Focused:=True;
  if Curr.LinkName <> '' then
  begin
    E := Caddy.Find(Curr.LinkName);
    if Assigned(E) then
      E.LinkScheme := ExtractFileName(Panel.WorkSchemeName);
  end;
end;

procedure TShowOverviewForm.BackgroundMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var i: integer; C: TDinControl;
begin
  for i:=0 to DinList.Count-1 do
  begin
    C:=DinList.Items[i] as TDinControl;
    C.Focused:=False;
  end;
  Curr:=nil;
end;

procedure TShowOverviewForm.DinJumperClick(var Msg: TMessage);
var S: string; KeyVal,i: integer;
begin
  Curr:=TDinControl(Msg.LParam);
  if Curr is TDinJump then
  begin
    KeyVal:=(Curr as TDinJump).KeyLevel;
    if Caddy.UserLevel >= KeyVal then
    begin
      S:=(Curr as TDinJump).ScreenName;
      if Trim(S) <> '' then
      with RemXForm do
      begin
        Panel.WorkSchemeName:=IncludeTrailingPathDelimiter(Caddy.CurrentSchemsPath)+S;
        if FileExists(Panel.WorkSchemeName) then
        begin
          LoadSchemeFromFile(Panel.WorkSchemeName);
          FreshView;
          for i:=0 to Panel.RealTrendList.Count-1 do
          with Panel.RealTrendList.Items[i] as TShowRealTrendForm do
          begin
            if RealTrendSchemeName = Panel.WorkSchemeName then
              Show
            else
              Hide;
          end;
        end
        else
          ShowError('Файл "'+Panel.WorkSchemeName+'" не найден!');
      end;
    end
    else
      RemXForm.ShowWarning('Не достаточно прав для перехода на эту мнемосхему!');
  end;
end;

procedure TShowOverviewForm.FreshView;
var i: integer; C: TDinControl;
begin
  for i:=0 to DinList.Count-1 do
  begin
    C:=DinList.Items[i] as TDinControl;
    C.UpdateData(@GetParamVal);
  end;
end;

procedure TShowOverviewForm.DinPopupMenuPopup(Sender: TObject);
var C: TDinControl; HasRight: boolean;
begin
  C:=DinPopupMenu.PopupComponent as TDinControl;
  if Trim(C.LinkName) <> '' then
  begin
    miBase.Visible:=Caddy.UserLevel >= 5;
    miTrend.Visible:=C.IsTrend;
    HasRight:=Caddy.UserLevel > 1;
    miQuit.Visible:=HasRight and not C.IsAsked;
    miPasport.Visible:=True;
    miPasport.Caption:='Паспорт для '+C.LinkName;
    miInputValue.Visible:=HasRight and C.IsCommand and 
  ((C.DinKind = dkAnalog) or (C.DinKind = dkDigital) or (C.DinKind = dkValve));
    if C.DinKind = dkValve then
      miInputValue.Caption:='Открыть/Закрыть'
    else
      miInputValue.Caption:='Ввести значение...';
    miInputSP.Visible:=HasRight and ((C.DinKind = dkKonturSPMODE) or
                                     (C.DinKind = dkKonturSPOP));
    miInputOP.Visible:=HasRight and ((C.DinKind = dkKonturOPMODE) or
                                     (C.DinKind = dkKonturSPOP));
    miInputMode.Visible:=HasRight and ((C.DinKind = dkKonturSPMODE) or
                                       (C.DinKind = dkKonturOPMODE));
  end
  else
  begin
    miBase.Visible:=False;
    miTrend.Visible:=False;
    miQuit.Visible:=False;
    miPasport.Visible:=False;
    miInputValue.Visible:=False;
    miInputSP.Visible:=False;
    miInputOP.Visible:=False;
    miInputMode.Visible:=False;
  end;
end;

procedure TShowOverviewForm.miPasportClick(Sender: TObject);
var E: TEntity; C: TDinControl;
begin
  C:=DinPopupMenu.PopupComponent as TDinControl;
  E:=Caddy.Find(C.LinkName);
  if Assigned (E) then E.ShowPassport(Monitor.MonitorNum);
end;

procedure TShowOverviewForm.miQuitClick(Sender: TObject);
var E: TEntity; C: TDinControl;
begin
  if Caddy.UserLevel = 0 then
  begin
    RemXForm.ShowWarning('Пользователь не зарегистрирован!');
    Exit;
  end;
  C:=DinPopupMenu.PopupComponent as TDinControl;
  E:=Caddy.Find(C.LinkName);
  if Assigned (E) then
    Caddy.SmartAskByEntity(E,E.AlarmStatus+E.LostAlarmStatus);
end;

procedure TShowOverviewForm.miBaseClick(Sender: TObject);
var E: TEntity; C: TDinControl;
begin
  C:=DinPopupMenu.PopupComponent as TDinControl;
  E:=Caddy.Find(C.LinkName);
  if Assigned (E) then
    E.ShowEditor(Monitor.MonitorNum);
end;

procedure TShowOverviewForm.miDigitalOnClick(Sender: TObject);
var M: TMenuItem; E: TEntity; C: TDinControl;
begin
  M:=Sender as TMenuItem;
  C:=DinPopupMenu.PopupComponent as TDinControl;
  E:=Caddy.Find(C.LinkName);
  if Assigned(E) and E.IsDigit then
  begin
    if E.Actived then
    begin
      if E is TCustomDigInp then
        (E as TCustomDigInp).SendOP(M.Tag*1.0)
      else
        if E.IsCommand then
          E.SendOP(M.Tag*1.0)
        else
          (E as TCustomDigOut).Raw:=M.Tag;
    end
    else
      RemXForm.ShowError('Ввод значения невозможен, позиция не опрашивается!');
  end;
end;

procedure TShowOverviewForm.miInputValueClick(Sender: TObject);
var E: TEntity; C: TDinControl; OnText,OffText: string; BoolValue: Boolean;
   sFormat: string; Value: Single; ByteValue: byte;
begin
  C:=DinPopupMenu.PopupComponent as TDinControl;
  E:=Caddy.Find(C.LinkName);
  if Assigned(E) then
  begin
    if E.IsVirtual and Assigned(E.SourceEntity) then Exit;
    case C.DinKind of
  dkAnalog:
      begin
        if E is TCustomAnaInp then
        begin
          with E as TCustomAnaInp do
          begin
            sFormat:='%.'+IntToStr(Ord(OPFormat))+'f';
            Value:=OP;
          end;
        end
        else
        begin
          with E as TCustomAnaOut do
          begin
            sFormat:='%.'+IntToStr(Ord(PVFormat))+'f';
            Value:=PV;
          end;
        end;
        if InputFloatDlg(E.PtDesc,sFormat,Value) then
        begin
          if E is TCustomAnaInp then
          begin
            with E as TCustomAnaInp do
            begin
              if (Value <= OPEUHi) and (Value >= OPEULo) then
                SendOP(Value)
              else
                RemXForm.ShowError('Ввод значения за границами шкалы недопустим!');
            end;
          end
          else
          begin
            with E as TCustomAnaOut do
            begin
              if (Value <= PVEUHi) and (Value >= PVEULo) then
              begin
                if Caddy.NetRole = nrClient then
                begin
                  if CalcScale then
                    CommandData:=(Value-PVEULo)*100.0/(PVEUHi-PVEULo)
                  else
                    CommandData:=Value;
                  HasCommand:=True;
                end
                else
                begin
                  if CalcScale then
                    Raw:=(Value-PVEULo)*100.0/(PVEUHi-PVEULo)
                  else
                    Raw:=Value;
                end;
              end
              else
                RemXForm.ShowError('Ввод значения за границами шкалы недопустим!');
            end;
          end;
        end;
      end;
  dkDigital:
      begin
        if E is TCustomDigInp then
        begin
          BoolValue:=(E as TCustomDigInp).OP;
          OnText:='ВКЛЮЧИТЬ';
          OffText:='ОТКЛЮЧИТЬ';
        end
        else
        begin
          with E as TCustomDigOut do
          begin
            if Invert then
              BoolValue:=not (Raw > 0)
            else
              BoolValue:=Raw > 0;
            OnText:=TextUp;
            OffText:=TextDown;
          end;
        end;
        if InputBooleanDlg(E.PtDesc,OnText,OffText,BoolValue) then
        begin
          if E is TCustomDigInp then
            (E as TCustomDigInp).SendOP(IfThen(BoolValue,1.0,0.0))
          else
          begin
            with E as TCustomDigOut do
            begin
              if Invert then
              begin
                if BoolValue then
                  Value:=0
                else
                  Value:=1;
              end
              else
              begin
                if BoolValue then
                  Value:=1
                else
                  Value:=0;
              end;
              if Caddy.NetRole = nrClient then
              begin
                CommandData:=Value;
                HasCommand:=True;
              end
              else
              begin
                if E.IsCommand then
                  E.SendOP(Value)
                else
                  Raw:=Value;
              end;
            end;
          end;
        end;
      end;
  dkValve:
      begin
        if E is TVirtValve then
        begin
          ByteValue:=(E as TVirtValve).PV;
          OnText:='ОТКРЫТЬ';
          OffText:='ЗАКРЫТЬ';
        end;
        if InputValveDlg(E.PtDesc,ByteValue) then
        begin
          case ByteValue of
            1: (E as TVirtValve).SendClose;
            2: (E as TVirtValve).SendOpen;
          end;
        end;
      end;
    end; {case}
  end;
end;

procedure TShowOverviewForm.miInputSPClick(Sender: TObject);
var E: TEntity; C: TDinControl; sFormat: string; Value,rDelta: Single;
begin
  C:=DinPopupMenu.PopupComponent as TDinControl;
  E:=Caddy.Find(C.LinkName);
  if Assigned(E) then
  begin
    with E as TCustomCntReg do
    begin
      sFormat:='%.'+IntToStr(Ord(PVFormat))+'f';
      Value:=SP;
    end;
    if InputFloatDlg('Задание - '+E.PtDesc,sFormat,Value) then
    begin
      with E as TCustomCntReg do
      begin
        if (Value <= SPEUHi) and (Value >= SPEULo) then
        begin
          if Value > SP then
            rDelta:=(Value-SP)/(SPEUHi-SPEULo)
          else
            rDelta:=(SP-Value)/(SPEUHi-SPEULo);
          if (CheckSP = ccNone) or
             (CheckSP <> ccNone) and
             ((rDelta <= ACtoSingle[CheckSP]) or
              (rDelta > ACtoSingle[CheckSP]) and
              (RemXForm.ShowQuestion('Рассогласование задания более '+
                  ACtoStr[CheckSP]+'!'#13'Выполнить команду?') = mrOk)) then
            SendSP(Value);
        end
        else
          RemXForm.ShowError('Ввод значения за границами шкалы задания недопустим!');
      end;
    end;
  end;
end;

procedure TShowOverviewForm.miInputOPClick(Sender: TObject);
var E: TEntity; C: TDinControl; sFormat: string; Value,rDelta: Single;
begin
  C:=DinPopupMenu.PopupComponent as TDinControl;
  E:=Caddy.Find(C.LinkName);
  if Assigned(E) then
  begin
    with E as TCustomCntReg do
    begin
      sFormat:='%.'+IntToStr(Ord(PVFormat))+'f';
      Value:=OP;
    end;
    if InputFloatDlg('Выход - '+E.PtDesc,sFormat,Value) then
    begin
      with E as TCustomCntReg do
      begin
        if (Value <= 100.0) and (Value >= 0.0) then
        begin
          if Value > OP then
            rDelta:=(Value-OP)/100.0
          else
            rDelta:=(OP-Value)/100.0;
          if (CheckOP = ccNone) or
             (CheckOP <> ccNone) and
             ((rDelta <= ACtoSingle[CheckOP]) or
              (rDelta > ACtoSingle[CheckOP]) and
              (RemXForm.ShowQuestion('Рассогласование выхода более '+
                  ACtoStr[CheckOP]+'!'#13'Выполнить команду?') = mrOk)) then
            SendOP(Value);
        end
        else
          RemXForm.ShowError('Ввод значения за границами шкалы выхода недопустим!');
      end;
    end;
  end;
end;

procedure TShowOverviewForm.miInputModeClick(Sender: TObject);
var E: TEntity; C: TDinControl; Value: Word;
begin
  C:=DinPopupMenu.PopupComponent as TDinControl;
  E:=Caddy.Find(C.LinkName);
  if Assigned(E) then
  begin
    with E as TCustomCntReg do Value:=Mode;
    if InputRegModeDlg(Value) then
      (E as TCustomCntReg).SendCommand(Value);
  end;
end;

procedure TShowOverviewForm.DinButtonClick(var Msg: TMessage);
var E: TEntity; DOUT: TCustomDigOut; DINP: TCustomDigInp; Fixed: boolean;
    Value: Single; DB: TDinButton; L: TList; i,KeyVal: integer;
begin
  if Caddy.UserLevel > 1 then
  begin
    L:=TList.Create;
    try
      DB:=TDinButton(Msg.WParam);
      KeyVal:=DB.KeyLevel + 1;
      if Caddy.UserLevel >= KeyVal then
      begin
        L.Add(Caddy.Find(DB.PtName));
        L.Pack;
        if L.Count > 0 then E:=TEntity(L.Items[0]) else Exit;
        if not DB.Confirm
          or
           DB.Confirm and
           (RemxForm.ShowQuestion(E.PtDesc+'.'+#13+'Выполнить?') = mrOK) then
        begin
          Fixed:=(Msg.LParam > 0);
          for i:=0 to L.Count-1 do
          begin
            E:=TEntity(L.Items[i]);
            if E.IsParam then
            begin
              DINP:=E as TCustomDigInp;
              if Fixed then
                DINP.SendOP(IfThen(not DINP.OP,1.0,0.0))
              else
                DINP.SendIMPULSE;
            end
            else
            begin
              DOUT:=E as TCustomDigOut;
              if Fixed then
              begin
                if DOUT.Raw  > 0 then Value:=0 else Value:=1;
                if Caddy.NetRole = nrClient then
                begin
                  DOUT.CommandData:=Value;
                  DOUT.HasCommand:=True;
                end
                else
                begin
                  if DOUT.IsCommand then
                    DOUT.SendOP(Value)
                  else
                    DOUT.Raw:=Value;
                end;
              end
              else
                DOUT.SendIMPULSE;
            end;
          end;
        end;
      end
      else
        RemXForm.ShowWarning('Недостаточно полномочий текущего пользователя для выполнения операции!');
    finally
      L.Free;
    end;
  end
  else
    RemXForm.ShowWarning('Недостаточно полномочий текущего пользователя для выполнения операции!');
end;

procedure TShowOverviewForm.miTrendClick(Sender: TObject);
var E: TEntity;
    C: TDinControl;
    RTForm: TShowRealTrendForm;
    AO: TCustomAnaOut;
    DS, DE: TDateTime;
    DL: Double;
begin
  C := DinPopupMenu.PopupComponent as TDinControl;
  E := Caddy.Find(C.LinkName);
  if Assigned(E) then
  begin
    RTForm := TShowRealTrendForm.Create(Panel);
    RTForm.Panel := Panel;
    RTForm.RealTrendSchemeName := Panel.WorkSchemeName;
    if E is TCustomAnaOut then
    begin
      AO:=E as TCustomAnaOut;
      RTForm.Caption:=AO.PtName+' - '+AO.PtDesc;
      DE:=Now;
      DS:=DE-10*OneMinute;
      with RTForm do
      begin
        SetBounds(DinPopupMenu.PopupPoint.X,
                  DinPopupMenu.PopupPoint.Y,
                  Width,Height);
        Source:=AO;
        DL:=AO.PVEUHi-AO.PVEULo;
        if Abs(DL) > 0.0001 then
        begin
          if AO.HHDB <> adNone then
          begin
            PTHH.AddXY(DS,100*(AO.PVHHTP-AO.PVEULo)/DL);
            PTHH.AddXY(DE,100*(AO.PVHHTP-AO.PVEULo)/DL);
          end;
          if AO.HIDB <> adNone then
          begin
            PTHI.AddXY(DS,100*(AO.PVHiTP-AO.PVEULo)/DL);
            PTHI.AddXY(DE,100*(AO.PVHiTP-AO.PVEULo)/DL);
          end;
          if AO.LODB <> adNone then
          begin
            PTLO.AddXY(DS,100*(AO.PVLoTP-AO.PVEULo)/DL);
            PTLO.AddXY(DE,100*(AO.PVLoTP-AO.PVEULo)/DL);
          end;
          if AO.LLDB <> adNone then
          begin
            PTLL.AddXY(DS,100*(AO.PVLLTP-AO.PVEULo)/DL);
            PTLL.AddXY(DE,100*(AO.PVLLTP-AO.PVEULo)/DL);
          end;
          LoadHistoryTreng('PTPV', DL, AO.PVEULo);
          PTPV.AddXY(DE,100*(AO.PV-AO.PVEULo)/DL);
          if AO.IsKontur then
          begin
            LoadHistoryTreng('PTSP', (AO.FSPEUHi-AO.FSPEULo), AO.FSPEULo);
            PTSP.AddXY(DE,100*(AO.FSP-AO.FSPEULo)/(AO.FSPEUHi-AO.FSPEULo));
            LoadHistoryTreng('PTOP', 100.0, 0.0);
            PTOP.AddXY(DE, AO.FOP);
          end;
          Chart.RightAxis.SetMinMax(AO.PVEULo-DL*0.05,AO.PVEUHi+DL*0.05);
        end;
        Chart.ZoomPercent(95);
        Chart.AllowZoom:=False;
      end;
      RTForm.Show;
      if (RTForm.Left+RTForm.Width) > (Panel.Left+Panel.Width) then
        RTForm.Left := (Panel.Left+Panel.Width) - RTForm.Width;
      if (RTForm.Top+RTForm.Height) > (Panel.Top+Panel.Height) then
        RTForm.Top := (Panel.Top+Panel.Height) - RTForm.Height;
      Panel.RealTrendList.Add(RTForm);
    end;
  end;
end;

procedure TShowOverviewForm.PrintWorkScreen(Invert: boolean);
var JP: TJPEGImage; B1,B2,FormImage: TBitmap;
begin
  PrintDialogForm:=TPrintDialogForm.Create(Self);
  try
    B1:=TBitmap.Create;
    try
      B1.Width:=PanelWidth;
      B1.Height:=PanelHeight;
      if Invert then B1.Canvas.CopyMode:=cmNotSrcCopy;
      B2:=TBitmap.Create;
      try
        B2.Width:=PanelWidth;
        B2.Height:=PanelHeight;
        FormImage := Self.GetFormImage;
        try
          B2.Assign(FormImage);
        finally
          FormImage.Free;
        end;
        B1.Canvas.CopyRect(Rect(0,0,B1.Width,B1.Height),B2.Canvas,
                           Rect(0,0,B1.Width,B1.Height));
      finally
        B2.Free;
      end;
      frScreenReport.LoadFromResourceName(HInstance,'ScreenReport');
      frScreenReport.Title:='Мнемосхема "'+ExtractFileName(Panel.WorkSchemeName)+'"';
      frVariables.Variable['ScreenTitle']:=frScreenReport.Title;
      frVariables.Variable['ObjectName']:=Config.ReadString('General','ObjectName','');
      frVariables.Variable['PrintDate']:=
                        FormatDateTime('Отпечатано: d.mm.yyyy h:nn:ss',(Now));
      with CurPage.FindObject('ChartPicture') as TfrPictureView do
      begin
        if Config.ReadInteger('General','PrintColor',0) = 0 then
        begin  // Серая шкала
          JP:=TJPEGImage.Create;
          try
            JP.Grayscale:=True;
            JP.Assign(B1);
            JP.SaveToFile('temp.jpg');
            Picture.LoadFromFile('temp.jpg');
            DeleteFile('temp.jpg');
          finally
            JP.Free;
          end;
        end;
        if Config.ReadInteger('General','PrintColor',0) = 1 then
        begin // Цветная шкала
          B1.SaveToFile('temp.bmp');
          Picture.LoadFromFile('temp.bmp');
          DeleteFile('temp.bmp');
        end
      end;
      if frScreenReport.PrepareReport then
      begin
        PrintDialogForm.FromPage:=1;
        PrintDialogForm.ToPage:=1;
        if PrintDialogForm.Execute then
        begin
          RemXForm.SaveReportToReportsLog(frScreenReport,True,'Мнемосхемы');
          if PrintDialogForm.PrintRange = prAllPages then
            frScreenReport.PrintPreparedReport('',PrintDialogForm.Copies,
                                            PrintDialogForm.Collate,frAll)
          else
            if PrintDialogForm.PrintRange = prPageNums then
              frScreenReport.PrintPreparedReport(Format('%d-%d',
                            [PrintDialogForm.FromPage,PrintDialogForm.ToPage]),
                         PrintDialogForm.Copies,PrintDialogForm.Collate,frAll);
        end;
      end;
    finally
      B1.Free;
    end;
  finally
    PrintDialogForm.Free;
  end;
end;

procedure TShowOverviewForm.miDirectPrintClick(Sender: TObject);
begin
  PrintWorkScreen(False);
end;

procedure TShowOverviewForm.miInversePrintClick(Sender: TObject);
begin
  PrintWorkScreen(True);
end;

procedure TShowOverviewForm.DinKonturClick(var Msg: TMessage);
var E: TCustomCntReg;
begin
  if Caddy.UserLevel > 1 then
  begin
    E:=TCustomCntReg(Msg.WParam);
    if E is TCustomCntReg then
    begin
      E.CommandMode:=11;
      case Msg.LParam of
       12: begin
             E.CommandData:=-25.0;
             E.HasCommand:=True;
           end;
       13: begin
             E.CommandData:=25.0;
             E.HasCommand:=True;
           end;
       14: begin
             E.CommandData:=0.0;
             E.HasCommand:=True;
          end;
       15: begin
             E.CommandData:=-100.0;
             E.HasCommand:=True;
           end;
       16: begin
             E.CommandData:=100.0;
             E.HasCommand:=True;
           end;
      end;
    end;
  end;
end;

procedure TShowOverviewForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (ssAlt in Shift) and (Key = Ord('P')) then
  begin
    PrintWorkScreen(False);
    Key:=0;
  end;
  if (ssCtrl in Shift) and (ssAlt in Shift) and (Key = Ord('I')) then
  begin
    PrintWorkScreen(True);
    Key:=0;
  end;
  case Key of
    VK_NEXT:  begin SelectNextDin; Key:=0; end;
    VK_PRIOR: begin SelectPrevDin; Key:=0; end;
    VK_APPS:  begin DinPopup;      Key:=0; end;
    VK_SPACE: begin DinPressKey;   Key:=0; end;
  end;
end;

procedure TShowOverviewForm.DinPopup;
var P: TPoint;
begin
  if DinList.Count > 0 then
  begin
    if DinList.IndexOf(Curr) < 0 then Curr:=DinList.Items[0] as TDinControl;
    DinPopupMenu.PopupComponent:=Curr;
    P:=Point(Curr.Width div 2,Curr.Height div 2);
    P:=Curr.ClientToScreen(P);
    DinPopupMenu.Popup(P.X,P.Y);
  end;
end;

procedure TShowOverviewForm.DinPressKey;
begin
  if DinList.Count > 0 then
  begin
    if DinList.IndexOf(Curr) < 0 then
      Curr:=DinList.Items[0] as TDinControl;
    if Curr is TDinJump then
      PostMessage(Handle,WM_DinJumperClick,0,Integer(Curr));
    if Curr is TDinButton then
      (Curr as TDinButton).ButtonClick;
  end;
end;

procedure TShowOverviewForm.SelectNextDin;
var i: integer;
begin
  if DinList.Count > 0 then
  begin
    i:=DinList.IndexOf(Curr);
    if i < 0 then
      Curr:=DinList.Items[0] as TDinControl
    else
    begin
      Inc(i);
      if i = DinList.Count then i:=0;
      Curr:=DinList.Items[i] as TDinControl;
      Curr.SetFocus;
    end;
  end;
end;

procedure TShowOverviewForm.SelectPrevDin;
var i: integer;
begin
  if DinList.Count > 0 then
  begin
    i:=DinList.IndexOf(Curr);
    if i < 0 then
      Curr:=DinList.Items[0] as TDinControl
    else
    begin
      Dec(i);
      if i = -1 then i:=DinList.Count-1;
      Curr:=DinList.Items[i] as TDinControl;
      Curr.SetFocus;
    end;
  end;
end;

procedure TShowOverviewForm.FormMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  if ssAlt in Shift then
  begin
    Box.HorzScrollBar.Position:=Box.HorzScrollBar.Position-WheelDelta;
  end
  else
    Box.VertScrollBar.Position:=Box.VertScrollBar.Position-WheelDelta;
  Handled:=False;
end;

end.
