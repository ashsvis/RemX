unit ModbusAOEditUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, EntityUnit, ModbusUnit, Menus;

type
  TModbusAOEditForm = class(TBaseEditForm)
    ListView1: TListView;
    PopupMenu1: TPopupMenu;
    procedure ListView1DblClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
  private
    E: TModbusAnaOut;
    procedure ConnectBaseEditor(var Mess: TMessage); message WM_ConnectBaseEditor;
    procedure BaseFresh(var Mess: TMessage); message WM_Fresh;
    procedure ConnectEntity(Entity: TEntity); stdcall;
    procedure ConnectImageList(ImageList: TImageList); stdcall;
    procedure UpdateRealTime; stdcall;
    procedure ChangeTextClick(Sender: TObject);
    procedure ChangeFetchClick(Sender: TObject);
    procedure ChangeBooleanClick(Sender: TObject);
    procedure ChangePVFormatClick(Sender: TObject);
    procedure ChangeFloatClick(Sender: TObject);
    procedure ChangeAlmDBClick(Sender: TObject);
    procedure ChangeIntegerClick(Sender: TObject);
    procedure ChangeDataFormatClick(Sender: TObject);
    procedure ChangeAddrPrefixClick(Sender: TObject);
  public
  end;

var
  ModbusAOEditForm: TModbusAOEditForm;

implementation

uses StrUtils, GetPtNameUnit, Math;

{$R *.dfm}

{ TModbusAOEditForm }

procedure TModbusAOEditForm.BaseFresh(var Mess: TMessage);
begin
  UpdateRealTime;
end;

procedure TModbusAOEditForm.ConnectBaseEditor(var Mess: TMessage);
begin
  ConnectImageList(TImageList(Mess.WParam));
  ConnectEntity(TEntity(Mess.LParam));
end;

procedure TModbusAOEditForm.ConnectEntity(Entity: TEntity);
var sFormat: string;
begin
  E:=Entity as TModbusAnaOut;
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
        Caption:='Канал связи';
        SubItems.Add(IntToStr(E.Channel));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Контроллер';
        SubItems.Add(IntToStr(E.Node));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Адрес данных';
        SubItems.Add(IntToStr(E.Address));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Префикс адреса';
        SubItems.Add(AAnaAddrPrefix[E.AddrPrefix]);
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Тип данных';     
        SubItems.Add(ADataFormat[E.DataFormat]);
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
        Caption:='Сигнализация';
        SubItems.Add(IfThen(E.Logged,'Да','Нет'));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Квитирование';
        SubItems.Add(IfThen(E.Asked,'Да','Нет'));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Тренд';
        SubItems.Add(IfThen(E.Trend,'Да','Нет'));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Источник данных';
        if E.SourceEntity=nil then
          SubItems.Add('Авто')
        else
        begin
          SubItems.Add(E.SourceEntity.PtName+' - '+E.SourceEntity.PtDesc);
          SubItemImages[0]:=EntityClassIndex(E.SourceEntity.ClassType)+3;
        end;
      end;
//=========================================================================
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Размерность';
        SubItems.Add(E.EUDesc);
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Формат PV';
        SubItems.Add(Format('D%d',[Ord(E.PVFormat)]));
      end;
      sFormat:='%.'+Format('%d',[Ord(E.PVFormat)])+'f';
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Верхняя граница шкалы';
        SubItems.Add(Format(sFormat,[E.PVEUHi]));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Верхняя предаварийная граница';
        SubItems.Add(Format(sFormat,[E.PVHHTP])+' '+AAlmDB[E.HHDB]);
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Верхняя предупредительная граница';
        SubItems.Add(Format(sFormat,[E.PVHiTP])+' '+AAlmDB[E.HIDB]);
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Нижняя предупредительная граница';
        SubItems.Add(Format(sFormat,[E.PVLoTP])+' '+AAlmDB[E.LODB]);
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Нижняя предаварийная граница';
        SubItems.Add(Format(sFormat,[E.PVLLTP])+' '+AAlmDB[E.LLDB]);
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Нижняя граница шкалы';
        SubItems.Add(Format(sFormat,[E.PVEULo]));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Контроль границ шкалы';
        SubItems.Add(AAlmDB[E.BadDB]);
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Масштаб по шкале';
        SubItems.Add(IfThen(E.CalcScale,'Да','Нет'));
      end;
    finally
      Items.EndUpdate;
    end;
  end;
end;

procedure TModbusAOEditForm.ConnectImageList(ImageList: TImageList);
begin
  ListView1.SmallImages:=ImageList;
end;

procedure TModbusAOEditForm.ListView1DblClick(Sender: TObject);
begin
  if (ListView1.Selected <> nil) and
     (ListView1.Selected.Caption = 'Источник данных') then
  begin
    if Assigned(E.SourceEntity) then
      E.SourceEntity.ShowEditor(Monitor.MonitorNum);
  end;
end;

procedure TModbusAOEditForm.UpdateRealTime;
var L: TListItem;
begin
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

procedure TModbusAOEditForm.PopupMenu1Popup(Sender: TObject);
var L: TListItem; M: TMenuItem; i: integer; k: TAlarmDeadband;
    df: TModbusFormat; u: TAddrPrefix;
begin
  L:=ListView1.Selected;
  with PopupMenu1 do
  begin
    Items.Clear;
    if L <> nil then
    case L.Index of
      0: begin
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
         end;
   1..3: begin
           M:=TMenuItem.Create(Self);
           M.Caption:='Изменить число...';
           M.OnClick:=ChangeIntegerClick;
           Items.Add(M);
         end;
      4: for u:=Low(AAnaAddrPrefix) to High(AAnaAddrPrefix) do
         begin
           M:=TMenuItem.Create(Self);
           M.Caption:=AAnaAddrPrefix[u];
           M.Tag:=Ord(u);
           M.OnClick:=ChangeAddrPrefixClick;
           M.Checked:=(E.AddrPrefix = u);
           Items.Add(M);
         end;
      5: for df:=Low(ADataFormat) to High(ADataFormat) do
         begin
           M:=TMenuItem.Create(Self);
           M.Caption:=ADataFormat[df];
           M.Tag:=Ord(df);
           M.OnClick:=ChangeDataFormatClick;
           M.Checked:=(E.DataFormat = df);
           Items.Add(M);
         end;
    6,14: begin
           M:=TMenuItem.Create(Self);
           M.Caption:='Изменить текст...';
           M.OnClick:=ChangeTextClick;
           Items.Add(M);
         end;
      8: begin
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
7,10..12,23: begin
           M:=TMenuItem.Create(Self);
           M.Caption:='Нет';
           case L.Index of
             7: M.Checked:=not E.Actived;
            10: M.Checked:=not E.Logged;
            11: M.Checked:=not E.Asked;
            12: M.Checked:=not E.Trend;
            23: M.Checked:=not E.CalcScale;
           end;
           M.Tag:=0;
           M.OnClick:=ChangeBooleanClick;
           Items.Add(M);
           M:=TMenuItem.Create(Self);
           M.Caption:='Да';
           case L.Index of
             7: M.Checked:=E.Actived;
            10: M.Checked:=E.Logged;
            11: M.Checked:=E.Asked;
            12: M.Checked:=E.Trend;
            23: M.Checked:=E.CalcScale;
           end;
           M.Tag:=1;
           M.OnClick:=ChangeBooleanClick;
           Items.Add(M);
         end;
     15: for i:=0 to 3 do
         begin
           M:=TMenuItem.Create(Self);
           M.Caption:='D'+IntToStr(i);
           M.Tag:=i;
           M.OnClick:=ChangePVFormatClick;
           M.Checked:=(Ord(E.PVFormat) = i);
           Items.Add(M);
         end;
   16,21: begin
           M:=TMenuItem.Create(Self);
           M.Caption:='Изменить значение...';
           M.OnClick:=ChangeFloatClick;
           Items.Add(M);
         end;
 17..20: begin
           M:=TMenuItem.Create(Self);
           M.Caption:='Изменить значение...';
           M.OnClick:=ChangeFloatClick;
           Items.Add(M);
           //---
           M:=TMenuItem.Create(Self); M.Caption:='-'; Items.Add(M);
           for k:=Low(AAlmDB) to High(AAlmDB) do
           begin
             M:=TMenuItem.Create(Self);
             M.Caption:=AAlmDB[k];
             M.Tag:=Ord(k);
             M.OnClick:=ChangeAlmDBClick;
             case L.Index of
              17: M.Checked:=(E.HHDB = k);
              18: M.Checked:=(E.HiDB = k);
              19: M.Checked:=(E.LoDB = k);
              20: M.Checked:=(E.LLDB = k);
             end;
             Items.Add(M);
           end;
         end;
     22: for k:=Low(AAlmDB) to High(AAlmDB) do
         begin
           M:=TMenuItem.Create(Self);
           M.Caption:=AAlmDB[k];
           M.Tag:=Ord(k);
           M.OnClick:=ChangeAlmDBClick;
           M.Checked:=(E.BadDB = k);
           Items.Add(M);
         end;
    end;
  end;
end;

procedure TModbusAOEditForm.ChangeTextClick(Sender: TObject);
var L: TListItem; S: string;
begin
  L:=ListView1.Selected;
  if L <> nil then
  begin
    S:=L.SubItems[0];
    if InputStringDlg(L.Caption,S,IfThen(L.Index=6,50,10)) then
    case L.Index of
      6: begin E.PtDesc:=S; L.SubItems[0]:=E.PtDesc; end;
     14: begin E.EUDesc:=S; L.SubItems[0]:=E.EUDesc; end;
    end;
  end;
end;

procedure TModbusAOEditForm.ChangeFetchClick(Sender: TObject);
var L: TListItem; V: integer; M: TMenuItem;
begin
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

procedure TModbusAOEditForm.ChangeAlmDBClick(Sender: TObject);
var L: TListItem; M: TMenuItem; sFormat: string;
begin
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  if L <> nil then
  begin
    sFormat:='%.'+Format('%d',[Ord(E.PVFormat)])+'f';
    with ListView1 do
    case L.Index of
     17: begin
           E.HHDB:=TAlarmDeadband(M.Tag);
           Items[17].SubItems[0]:=Format(sFormat,[E.PVHHTP])+' '+AAlmDB[E.HHDB];
         end;
     18: begin
           E.HIDB:=TAlarmDeadband(M.Tag);
           Items[18].SubItems[0]:=Format(sFormat,[E.PVHiTP])+' '+AAlmDB[E.HIDB];
         end;
     19: begin
           E.LODB:=TAlarmDeadband(M.Tag);
           Items[19].SubItems[0]:=Format(sFormat,[E.PVLoTP])+' '+AAlmDB[E.LODB];
         end;
     20: begin
           E.LLDB:=TAlarmDeadband(M.Tag);
           Items[20].SubItems[0]:=Format(sFormat,[E.PVLLTP])+' '+AAlmDB[E.LLDB];
         end;
     22: begin
           E.BadDB:=TAlarmDeadband(M.Tag);
           E.FirstCalc:=True;
           Items[22].SubItems[0]:=AAlmDB[E.BadDB];
           if E.BadDB = adNone then
           begin
             if asShortBadPV in E.AlarmStatus then
               Caddy.RemoveAlarm(asShortBadPV,E);
             if asOpenBadPV in E.AlarmStatus then
               Caddy.RemoveAlarm(asOpenBadPV,E);
           end;
         end;
    end;
  end;
end;

procedure TModbusAOEditForm.ChangeDataFormatClick(Sender: TObject);
var L: TListItem; M: TMenuItem;
begin
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  if L <> nil then
  begin
    with ListView1 do
    case L.Index of
     5: begin
           E.DataFormat:=TModbusFormat(M.Tag);
           Items[5].SubItems[0]:=ADataFormat[E.DataFormat];
         end;
    end;
  end;
end;

procedure TModbusAOEditForm.ChangeBooleanClick(Sender: TObject);
var L: TListItem; M: TMenuItem; B: Boolean;
begin
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  B:=(M.Tag = 1);
  if L <> nil then
    case L.Index of
       7: begin E.Actived:=B; L.SubItems[0]:=IfThen(E.Actived,'Да','Нет'); end;
      10: begin E.Logged:=B; L.SubItems[0]:=IfThen(E.Logged,'Да','Нет'); end;
      11: begin E.Asked:=B; L.SubItems[0]:=IfThen(E.Asked,'Да','Нет'); end;
      12: begin E.Trend:=B; L.SubItems[0]:=IfThen(E.Trend,'Да','Нет'); end;
      23: begin E.CalcScale:=B; L.SubItems[0]:=IfThen(E.CalcScale,'Да','Нет'); end;
    end;
end;

procedure TModbusAOEditForm.ChangeFloatClick(Sender: TObject);
var L: TListItem; sFormat: string; V: Single;
begin
  L:=ListView1.Selected;
  if L <> nil then
  begin
    case L.Index of
     16: V:=E.PVEUHi;
     17: V:=E.PVHHTP;
     18: V:=E.PVHiTP;
     19: V:=E.PVLoTP;
     20: V:=E.PVLLTP;
     21: V:=E.PVEULo;
    end;
    sFormat:='%.'+Format('%d',[Ord(E.PVFormat)])+'f';
    if InputFloatDlg(L.Caption,sFormat,V) then
    case L.Index of
     16: if InRange(V,E.PVHHTP,V) then
         begin
           E.PVEUHi:=V;
           L.SubItems[0]:=Format(sFormat,[E.PVEUHi]);
         end
         else
           raise ERangeError.Create('Значение вне допустимых границ!');
     17: if InRange(V,E.PVHiTP,E.PVEUHi) then
         begin
           E.PVHHTP:=V;
           L.SubItems[0]:=Format(sFormat,[E.PVHHTP])+' '+AAlmDB[E.HHDB];
         end
         else
           raise ERangeError.Create('Значение вне допустимых границ!');
     18: if InRange(V,E.PVLoTP,E.PVHHTP) then
         begin
           E.PVHiTP:=V;
           L.SubItems[0]:=Format(sFormat,[E.PVHiTP])+' '+AAlmDB[E.HiDB];
         end
         else
           raise ERangeError.Create('Значение вне допустимых границ!');
     19: if InRange(V,E.PVLLTP,E.PVHiTP) then
         begin
           E.PVLoTP:=V;
           L.SubItems[0]:=Format(sFormat,[E.PVLoTP])+' '+AAlmDB[E.LoDB];
         end
         else
           raise ERangeError.Create('Значение вне допустимых границ!');
     20: if InRange(V,E.PVEULo,E.PVLoTP) then
         begin
           E.PVLLTP:=V;
           L.SubItems[0]:=Format(sFormat,[E.PVLLTP])+' '+AAlmDB[E.LLDB];
         end
         else
           raise ERangeError.Create('Значение вне допустимых границ!');
     21: if InRange(V,V,E.PVLLTP) then
         begin
           E.PVEULo:=V;
           L.SubItems[0]:=Format(sFormat,[E.PVEULo]);
         end
         else
           raise ERangeError.Create('Значение вне допустимых границ!');
    end;
  end;
end;

procedure TModbusAOEditForm.ChangePVFormatClick(Sender: TObject);
var L: TListItem; M: TMenuItem; sFormat: string;
begin
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  if L <> nil then
  begin
    E.PVFormat:=TPVFormat(M.Tag); L.SubItems[0]:=Format('D%d',[Ord(E.PVFormat)]);
    sFormat:='%.'+Format('%d',[Ord(E.PVFormat)])+'f';
    with ListView1 do
    begin
      Items[16].SubItems[0]:=Format(sFormat,[E.PVEUHi]);
      Items[17].SubItems[0]:=Format(sFormat,[E.PVHHTP])+' '+AAlmDB[E.HHDB];
      Items[18].SubItems[0]:=Format(sFormat,[E.PVHiTP])+' '+AAlmDB[E.HIDB];
      Items[19].SubItems[0]:=Format(sFormat,[E.PVLoTP])+' '+AAlmDB[E.LODB];
      Items[20].SubItems[0]:=Format(sFormat,[E.PVLLTP])+' '+AAlmDB[E.LLDB];
      Items[21].SubItems[0]:=Format(sFormat,[E.PVEULo]);
    end;
  end;
end;

procedure TModbusAOEditForm.ChangeIntegerClick(Sender: TObject);
var L: TListItem; V: Integer;
begin
  L:=ListView1.Selected;
  if L <> nil then
  begin
    case L.Index of
     1: V:=E.Channel;
     2: V:=E.Node;
     3: V:=E.Address;
    end;
    if InputIntegerDlg(L.Caption,V) then
    begin
      case L.Index of
        1: if InRange(V,1,ChannelCount) then
           begin
             E.Channel:=V;
             L.SubItems[0]:=Format('%d',[E.Channel]);
           end
           else
             raise ERangeError.Create('Значение вне допустимых границ!');
        2: if InRange(V,1,247) then
           begin
             E.Node:=V;
             L.SubItems[0]:=Format('%d',[E.Node]);
           end
           else
             raise ERangeError.Create('Значение вне допустимых границ (1..247)!');
        3: if InRange(V,1,65535) then
           begin
             E.Address:=V;
             L.SubItems[0]:=Format('%d',[E.Address]);
           end
           else
             raise ERangeError.Create('Значение вне допустимых границ (1..65535)!');
      end;
      if L.Index in [1..2] then
      begin
        UpdateBaseView(Self);
        RestoreEntityPos(E);
      end;
    end;
  end;
end;

procedure TModbusAOEditForm.ChangeAddrPrefixClick(Sender: TObject);
var L: TListItem; M: TMenuItem;
begin
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  if L <> nil then
  begin
    with ListView1 do
    case L.Index of
     4: begin
           E.AddrPrefix:=TAddrPrefix(M.Tag);
           Items[4].SubItems[0]:=AAnaAddrPrefix[E.AddrPrefix];
         end;
    end;
  end;
end;

end.
