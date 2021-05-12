unit KontAOEditUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, EntityUnit, KontrastUnit;

type
  TKontAOEditForm = class(TKontEditForm)
  private
    E: TCustomAnaOut;
  protected
    procedure ChangePVFormatClick(Sender: TObject); virtual;
    procedure ChangeFloatClick(Sender: TObject); virtual;
    procedure ChangeAlmDBClick(Sender: TObject); virtual;
    procedure ConnectEntity(Entity: TEntity); override;
    procedure PopupMenu1Popup(Sender: TObject); override;
    procedure ChangeIntegerClick(Sender: TObject); override;
    procedure ChangeTextClick(Sender: TObject); override;
    procedure ChangeBooleanClick(Sender: TObject); override;
  public
  end;

var
  KontAOEditForm: TKontAOEditForm;

implementation

uses StrUtils, ComCtrls, Math, Menus, GetPtNameUnit;

{$R *.dfm}

{ TKontAOEditForm }

procedure TKontAOEditForm.ConnectEntity(Entity: TEntity);
var sFormat: string;
begin
  inherited;
  E:=Entity as TCustomAnaOut;
  with ListView1 do
  begin
    Items.BeginUpdate;
    try
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Алгоблок';
        SubItems.Add(IntToStr(E.Block));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Выход алгоблока';
        SubItems.Add(IntToStr(E.Place));
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

procedure TKontAOEditForm.PopupMenu1Popup(Sender: TObject);
var L: TListItem; M: TMenuItem; i: integer;
  procedure AddAlmItem(Value: TAlarmDeadband);
  var k: TAlarmDeadband;
  begin
    for k:=Low(AAlmDB) to High(AAlmDB) do
    begin
      M:=TMenuItem.Create(Self);
      M.Caption:=AAlmDB[k];
      M.Tag:=Ord(k);
      M.OnClick:=ChangeAlmDBClick;
      M.Checked:=(Value = k);
      PopupMenu1.Items.Add(M);
    end;
  end;
begin
  inherited;
  L:=ListView1.Selected;
  with PopupMenu1 do
  begin
    if Assigned(L) then
    begin
      if (L.Caption = 'Алгоблок') or
         (L.Caption = 'Выход алгоблока') then
      begin
        M:=TMenuItem.Create(Self);
        M.Caption:='Изменить число...';
        M.OnClick:=ChangeIntegerClick;
        Items.Add(M);
      end;
      if L.Caption = 'Размерность' then
      begin
        M:=TMenuItem.Create(Self);
        M.Caption:='Изменить текст...';
        M.OnClick:=ChangeTextClick;
        Items.Add(M);
      end;
      if L.Caption = 'Сигнализация' then AddBoolItem(E.Logged);
      if L.Caption = 'Квитирование' then AddBoolItem(E.Asked);
      if L.Caption = 'Тренд' then AddBoolItem(E.Trend);
      if L.Caption = 'Масштаб по шкале' then AddBoolItem(E.CalcScale);
      if L.Caption = 'Формат PV' then
      begin
        for i:=0 to 3 do
        begin
          M:=TMenuItem.Create(Self);
          M.Caption:='D'+IntToStr(i);
          M.Tag:=i;
          M.OnClick:=ChangePVFormatClick;
          M.Checked:=(Ord(E.PVFormat) = i);
          Items.Add(M);
        end;
      end;
      if (L.Caption = 'Верхняя граница шкалы') or
         (L.Caption = 'Нижняя граница шкалы') then
      begin
        M:=TMenuItem.Create(Self);
        M.Caption:='Изменить значение...';
        M.OnClick:=ChangeFloatClick;
        Items.Add(M);
      end;
      if (L.Caption = 'Верхняя предаварийная граница') or
         (L.Caption = 'Верхняя предупредительная граница') or
         (L.Caption = 'Нижняя предупредительная граница') or
         (L.Caption = 'Нижняя предаварийная граница') then
      begin
        M:=TMenuItem.Create(Self);
        M.Caption:='Изменить значение...';
        M.OnClick:=ChangeFloatClick;
        Items.Add(M);
        //---
        M:=TMenuItem.Create(Self); M.Caption:='-'; Items.Add(M);
      end;
      if L.Caption = 'Верхняя предаварийная граница' then AddAlmItem(E.HHDB);
      if L.Caption = 'Верхняя предупредительная граница' then AddAlmItem(E.HiDB);
      if L.Caption = 'Нижняя предупредительная граница' then AddAlmItem(E.LoDB);
      if L.Caption = 'Нижняя предаварийная граница' then AddAlmItem(E.LLDB);
      if L.Caption = 'Контроль границ шкалы' then AddAlmItem(E.BadDB);
    end;
  end;
end;

procedure TKontAOEditForm.ChangeTextClick(Sender: TObject);
var L: TListItem; S: string;
begin
  inherited;
  L:=ListView1.Selected;
  if Assigned(L) then
  begin
    if L.Caption = 'Размерность' then
      S:=L.SubItems[0]
    else
      Exit;
    if InputStringDlg(L.Caption,S,10) then
    begin
      if L.Caption = 'Размерность' then
      begin
        E.EUDesc:=S;
        L.SubItems[0]:=E.EUDesc;
      end;
    end;
  end;
end;

procedure TKontAOEditForm.ChangeAlmDBClick(Sender: TObject);
var L: TListItem; M: TMenuItem; sFormat: string;
begin
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  if Assigned(L) then
  begin
    sFormat:='%.'+Format('%d',[Ord(E.PVFormat)])+'f';
    with ListView1 do
    begin
      if L.Caption = 'Верхняя предаварийная граница' then
      begin
        E.HHDB:=TAlarmDeadband(M.Tag);
        L.SubItems[0]:=Format(sFormat,[E.PVHHTP])+' '+AAlmDB[E.HHDB];
      end;
      if L.Caption = 'Верхняя предупредительная граница' then
      begin
        E.HIDB:=TAlarmDeadband(M.Tag);
        L.SubItems[0]:=Format(sFormat,[E.PVHiTP])+' '+AAlmDB[E.HIDB];
      end;
      if L.Caption = 'Нижняя предупредительная граница' then
      begin
        E.LODB:=TAlarmDeadband(M.Tag);
        L.SubItems[0]:=Format(sFormat,[E.PVLoTP])+' '+AAlmDB[E.LODB];
      end;
      if L.Caption = 'Нижняя предаварийная граница' then
      begin
        E.LLDB:=TAlarmDeadband(M.Tag);
        L.SubItems[0]:=Format(sFormat,[E.PVLLTP])+' '+AAlmDB[E.LLDB];
      end;
      if L.Caption = 'Контроль границ шкалы' then
      begin
        E.BadDB:=TAlarmDeadband(M.Tag);
        E.FirstCalc:=True;
        if E.BadDB = adNone then
        begin
          if asShortBadPV in E.AlarmStatus then
            Caddy.RemoveAlarm(asShortBadPV,E);
          if asOpenBadPV in E.AlarmStatus then
            Caddy.RemoveAlarm(asOpenBadPV,E);
        end;
        L.SubItems[0]:=AAlmDB[E.BadDB];
      end;
    end;
  end;
end;

procedure TKontAOEditForm.ChangeBooleanClick(Sender: TObject);
var L: TListItem; M: TMenuItem; B: Boolean;
begin
  inherited;
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  B:=(M.Tag = 1);
  if Assigned(L) then
  begin
    if L.Caption = 'Сигнализация' then
    begin
      E.Logged:=B;
      L.SubItems[0]:=IfThen(E.Logged,'Да','Нет');
    end;
    if L.Caption = 'Квитирование' then
    begin
      E.Asked:=B;
      L.SubItems[0]:=IfThen(E.Asked,'Да','Нет');
    end;
    if L.Caption = 'Тренд' then
    begin
      E.Trend:=B;
      L.SubItems[0]:=IfThen(E.Trend,'Да','Нет');
    end;
    if L.Caption = 'Масштаб по шкале' then
    begin
      E.CalcScale:=B;
      L.SubItems[0]:=IfThen(E.CalcScale,'Да','Нет');
    end;
  end
end;

procedure TKontAOEditForm.ChangeFloatClick(Sender: TObject);
var L: TListItem; sFormat: string; V: Single;
begin
  if not Assigned(E) then Exit;
  L:=ListView1.Selected;
  if Assigned(L) then
  begin
    if L.Caption = 'Верхняя граница шкалы' then V:=E.PVEUHi
    else
     if L.Caption = 'Верхняя предаварийная граница' then V:=E.PVHHTP
     else
      if L.Caption = 'Верхняя предупредительная граница' then V:=E.PVHiTP
      else
       if L.Caption = 'Нижняя предупредительная граница' then V:=E.PVLoTP
       else
        if L.Caption = 'Нижняя предаварийная граница' then V:=E.PVLLTP
        else
         if L.Caption = 'Нижняя граница шкалы' then V:=E.PVEULo
         else
          Exit;
    sFormat:='%.'+Format('%d',[Ord(E.PVFormat)])+'f';
    if InputFloatDlg(L.Caption,sFormat,V) then
    begin
      if L.Caption = 'Верхняя граница шкалы' then
      begin
        if InRange(V,E.PVHHTP,V) then
        begin
          E.PVEUHi:=V;
          L.SubItems[0]:=Format(sFormat,[E.PVEUHi]);
        end
        else
          raise ERangeError.Create('Значение вне допустимых границ!');
      end;
      if L.Caption = 'Верхняя предаварийная граница' then
      begin
        if InRange(V,E.PVHiTP,E.PVEUHi) then
        begin
          E.PVHHTP:=V;
          L.SubItems[0]:=Format(sFormat,[E.PVHHTP])+' '+AAlmDB[E.HHDB];
        end
        else
          raise ERangeError.Create('Значение вне допустимых границ!');
      end;
      if L.Caption = 'Верхняя предупредительная граница' then
      begin
        if InRange(V,E.PVLoTP,E.PVHHTP) then
        begin
          E.PVHiTP:=V;
          L.SubItems[0]:=Format(sFormat,[E.PVHiTP])+' '+AAlmDB[E.HiDB];
        end
        else
          raise ERangeError.Create('Значение вне допустимых границ!');
      end;
      if L.Caption = 'Нижняя предупредительная граница' then
      begin
        if InRange(V,E.PVLLTP,E.PVHiTP) then
        begin
          E.PVLoTP:=V;
          L.SubItems[0]:=Format(sFormat,[E.PVLoTP])+' '+AAlmDB[E.LoDB];
        end
        else
          raise ERangeError.Create('Значение вне допустимых границ!');
      end;
      if L.Caption = 'Нижняя предаварийная граница' then
      begin
        if InRange(V,E.PVEULo,E.PVLoTP) then
        begin
          E.PVLLTP:=V;
          L.SubItems[0]:=Format(sFormat,[E.PVLLTP])+' '+AAlmDB[E.LLDB];
        end
        else
          raise ERangeError.Create('Значение вне допустимых границ!');
      end;
      if L.Caption = 'Нижняя граница шкалы' then
      begin
        if InRange(V,V,E.PVLLTP) then
        begin
          E.PVEULo:=V;
          L.SubItems[0]:=Format(sFormat,[E.PVEULo]);
        end
        else
          raise ERangeError.Create('Значение вне допустимых границ!');
      end;
    end;
  end;
end;

procedure TKontAOEditForm.ChangePVFormatClick(Sender: TObject);
var L: TListItem; M: TMenuItem; sFormat: string;
begin
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  if Assigned(L) then
  begin
    E.PVFormat:=TPVFormat(M.Tag); L.SubItems[0]:=Format('D%d',[Ord(E.PVFormat)]);
    sFormat:='%.'+Format('%d',[Ord(E.PVFormat)])+'f';
    with ListView1 do
    begin
      L:=FindCaption(0,'Верхняя граница шкалы',False,True,False);
      if Assigned(L) then L.SubItems[0]:=Format(sFormat,[E.PVEUHi]);
      L:=FindCaption(0,'Верхняя предаварийная граница',False,True,False);
      if Assigned(L) then
        L.SubItems[0]:=Format(sFormat,[E.PVHHTP])+' '+AAlmDB[E.HHDB];
      L:=FindCaption(0,'Верхняя предупредительная граница',False,True,False);
      if Assigned(L) then
        L.SubItems[0]:=Format(sFormat,[E.PVHiTP])+' '+AAlmDB[E.HIDB];
      L:=FindCaption(0,'Нижняя предупредительная граница',False,True,False);
      if Assigned(L) then
        L.SubItems[0]:=Format(sFormat,[E.PVLoTP])+' '+AAlmDB[E.LODB];
      L:=FindCaption(0,'Нижняя предаварийная граница',False,True,False);
      if Assigned(L) then
        L.SubItems[0]:=Format(sFormat,[E.PVLLTP])+' '+AAlmDB[E.LLDB];
      L:=FindCaption(0,'Нижняя граница шкалы',False,True,False);
      if Assigned(L) then L.SubItems[0]:=Format(sFormat,[E.PVEULo]);
    end;
  end;
end;

procedure TKontAOEditForm.ChangeIntegerClick(Sender: TObject);
var L: TListItem; V: Integer;
begin
  inherited;
  L:=ListView1.Selected;
  if Assigned(L) then
  begin
    if L.Caption = 'Алгоблок' then V:=E.Block
    else
      if L.Caption = 'Выход алгоблока' then V:=E.Place
      else
        Exit;
    if InputIntegerDlg(L.Caption,V) then
    begin
      if L.Caption = 'Алгоблок' then
      begin
        if InRange(V,1,999) then
        begin
          E.Block:=V;
          L.SubItems[0]:=Format('%d',[E.Block]);
        end
        else
          raise ERangeError.Create('Значение вне допустимых границ (1..999)!');
      end
      else
      if L.Caption = 'Выход алгоблока' then
      begin
        if InRange(V,1,127) then
        begin
          E.Place:=V;
          L.SubItems[0]:=Format('%d',[E.Place]);
        end
        else
          raise ERangeError.Create('Значение вне допустимых границ (1..127)!');
      end;
    end;
  end;
end;

end.

