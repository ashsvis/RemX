unit KontCREditUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, EntityUnit, KontrastUnit, Menus, KontAOEditUnit;

type
  TKontCREditForm = class(TKontAOEditForm)
  private
    E: TKontCntReg;
    procedure ChangeRegTypeClick(Sender: TObject);
    procedure ChangeCtoStrClick(Sender: TObject);
    procedure ChangeLinkClick(Sender: TObject);
    procedure DeleteLinkClick(Sender: TObject);
  protected
    procedure ChangePVFormatClick(Sender: TObject); override;
    procedure ChangeFloatClick(Sender: TObject); override;
    procedure ChangeIntegerClick(Sender: TObject); override;
    procedure ConnectEntity(Entity: TEntity); override;
    procedure PopupMenu1Popup(Sender: TObject); override;
    procedure ListView1DblClick(Sender: TObject); override;
  public
  end;

var
  KontCREditForm: TKontCREditForm;

implementation

uses GetPtNameUnit, Math, GetLinkNameUnit, RemXUnit;

{$R *.dfm}

{ TKontCREditForm }

procedure TKontCREditForm.ConnectEntity(Entity: TEntity);
var sFormat: string; L: TListItem;
begin
  inherited;
  E:=Entity as TKontCntReg;
  with ListView1 do
  begin
    Items.BeginUpdate;
    try
      L:=FindCaption(0,'Алгоблок',False,True,False);
      if Assigned(L) then Items.Delete(L.Index);
      L:=FindCaption(0,'Масштаб по шкале',False,True,False);
      if Assigned(L) then Items.Delete(L.Index);
      L:=FindCaption(0,'Выход алгоблока',False,True,False);
      if Assigned(L) then L.Caption:='Номер контура';
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Тип регулятора';
        SubItems.Add(ARegType[E.RegType]);
      end;
      sFormat:='%.'+Format('%d',[Ord(E.PVFormat)])+'f';
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Верхняя граница шкалы SP';
        SubItems.Add(Format(sFormat,[E.SPEUHi]));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Нижняя граница шкалы SP';
        SubItems.Add(Format(sFormat,[E.SPEULo]));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Отклонение PV от SP вверх';
        SubItems.Add(Format(sFormat,[E.PVDHTP]));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Отклонение PV от SP вниз';
        SubItems.Add(Format(sFormat,[E.PVDLTP]));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Контроль шага изменения SP';
        SubItems.Add(ACtoStr[E.CheckSP]);
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Контроль шага изменения OP';
        SubItems.Add(ACtoStr[E.CheckOP]);
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Коэффициент усиления (K)';
        if E.K=nil then
          SubItems.Add('------')
        else
        begin
          SubItems.Add(E.K.PtName+' - '+E.K.PtDesc);
          SubItemImages[0]:=EntityClassIndex(E.K.ClassType)+3;
        end;
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Интегральный коэффициент (T1)';
        if E.T1=nil then
          SubItems.Add('------')
        else
        begin
          SubItems.Add(E.T1.PtName+' - '+E.T1.PtDesc);
          SubItemImages[0]:=EntityClassIndex(E.T1.ClassType)+3;
        end;
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Дифференциальный коэффициент (T2)';
        if E.T2=nil then
          SubItems.Add('------')
        else
        begin
          SubItems.Add(E.T2.PtName+' - '+E.T2.PtDesc);
          SubItemImages[0]:=EntityClassIndex(E.T2.ClassType)+3;
        end;
      end;
    finally
      Items.EndUpdate;
    end;
  end;
end;

procedure TKontCREditForm.ListView1DblClick(Sender: TObject);
begin
  inherited;
  if Assigned(ListView1.Selected) then
  begin
    if ListView1.Selected.Caption = 'Коэффициент усиления (K)' then
    begin
      if Assigned(E.K) then
        E.K.ShowEditor(Monitor.MonitorNum);
    end;
    if ListView1.Selected.Caption = 'Интегральный коэффициент (T1)' then
    begin
      if Assigned(E.T1) then
        E.T1.ShowEditor(Monitor.MonitorNum);
    end;
    if ListView1.Selected.Caption = 'Дифференциальный коэффициент (T2)' then
    begin
      if Assigned(E.T2) then
        E.T2.ShowEditor(Monitor.MonitorNum);
    end;
  end;
end;

procedure TKontCREditForm.PopupMenu1Popup(Sender: TObject);
var L: TListItem; M: TMenuItem; i: integer; n: TCheckChange;
begin
  inherited;
  L:=ListView1.Selected;
  with PopupMenu1 do
  begin
    if Assigned(L) then
    begin
      if L.Caption = 'Номер контура' then
      begin
        M:=TMenuItem.Create(Self);
        M.Caption:='Изменить число...';
        M.OnClick:=ChangeIntegerClick;
        Items.Add(M);
      end;
      if L.Caption = 'Тип регулятора' then
      begin
        for i:=0 to 1 do
        begin
          M:=TMenuItem.Create(Self);
          M.Caption:=ARegType[TRegType(i)];
          M.Tag:=i;
          M.OnClick:=ChangeRegTypeClick;
          M.Checked:=(Ord(E.RegType) = i);
          Items.Add(M);
        end;
      end;
      if (L.Caption='Верхняя граница шкалы SP') or
         (L.Caption='Нижняя граница шкалы SP') or
         (L.Caption='Отклонение PV от SP вверх') or
         (L.Caption='Отклонение PV от SP вниз') then
      begin
        M:=TMenuItem.Create(Self);
        M.Caption:='Изменить значение...';
        M.OnClick:=ChangeFloatClick;
        Items.Add(M);
      end;
      if (L.Caption='Контроль шага изменения SP') or
         (L.Caption='Контроль шага изменения OP') then
      begin
        for n:=Low(ACtoStr) to High(ACtoStr) do
        begin
          M:=TMenuItem.Create(Self);
          M.Caption:=ACtoStr[n];
          M.Tag:=Ord(n);
          M.OnClick:=ChangeCtoStrClick;
          if L.Caption='Контроль шага изменения SP' then
            M.Checked:=(E.CheckSP = n)
          else
            M.Checked:=(E.CheckOP = n);
          Items.Add(M);
        end;
      end;
      if (L.Caption='Коэффициент усиления (K)') or
         (L.Caption='Интегральный коэффициент (T1)') or
         (L.Caption='Дифференциальный коэффициент (T2)') then
      begin
        M:=TMenuItem.Create(Self);
        M.Caption:='Изменить связь...';
        M.Tag:=L.Index;
        M.OnClick:=ChangeLinkClick;
        Items.Add(M);
        M:=TMenuItem.Create(Self);
        M.Caption:='Удалить связь';
        M.Tag:=L.Index;
        M.OnClick:=DeleteLinkClick;
        if L.Caption='Коэффициент усиления (K)' then
          M.Enabled:=(E.K <> nil)
        else
          if L.Caption='Интегральный коэффициент (T1)' then
            M.Enabled:=(E.T1 <> nil)
          else
            M.Enabled:=(E.T2 <> nil);
        Items.Add(M);
      end;
    end;
  end;
end;

procedure TKontCREditForm.ChangeFloatClick(Sender: TObject);
var L: TListItem; sFormat: string; V: Single;
begin
  inherited;
  L:=ListView1.Selected;
  if Assigned(L) then
  begin
    if L.Caption = 'Верхняя граница шкалы SP' then V:=E.SPEUHi
    else
     if L.Caption = 'Нижняя граница шкалы SP' then V:=E.SPEULo
     else
      if L.Caption = 'Отклонение PV от SP вверх' then V:=E.PVDHTP
      else
       if L.Caption = 'Отклонение PV от SP вниз' then V:=E.PVDLTP
       else
        Exit;
    sFormat:='%.'+Format('%d',[Ord(E.PVFormat)])+'f';
    if InputFloatDlg(L.Caption,sFormat,V) then
    begin
      if L.Caption = 'Верхняя граница шкалы SP' then
      begin
        if InRange(V,E.SPEULo,E.PVEUHi) then
        begin
          E.SPEUHi:=V;
          L.SubItems[0]:=Format(sFormat,[E.SPEUHi]);
        end
        else
          raise ERangeError.Create('Значение вне допустимых границ!');
      end;
      if L.Caption = 'Нижняя граница шкалы SP' then
      begin
        if InRange(V,E.PVEULo,E.SPEUHi) then
        begin
          E.SPEULo:=V;
          L.SubItems[0]:=Format(sFormat,[E.SPEULo]);
        end
        else
          raise ERangeError.Create('Значение вне допустимых границ!');
      end;
      if L.Caption = 'Отклонение PV от SP вверх' then
      begin
        if InRange(V,0,E.SPEUHi) then
        begin
          E.PVDHTP:=V;
          L.SubItems[0]:=Format(sFormat,[E.PVDHTP]);
        end
        else
          raise ERangeError.Create('Значение вне допустимых границ!');
      end;
      if L.Caption = 'Отклонение PV от SP вниз' then
      begin
        if InRange(V,0,E.SPEUHi) then
        begin
          E.PVDLTP:=V;
          L.SubItems[0]:=Format(sFormat,[E.PVDLTP]);
        end
        else
          raise ERangeError.Create('Значение вне допустимых границ!');
      end;
    end;  
  end;
end;

procedure TKontCREditForm.ChangePVFormatClick(Sender: TObject);
var L: TListItem; M: TMenuItem; sFormat: string;
begin
  inherited;
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  if Assigned(L) then
  begin
    E.PVFormat:=TPVFormat(M.Tag); L.SubItems[0]:=Format('D%d',[Ord(E.PVFormat)]);
    sFormat:='%.'+Format('%d',[Ord(E.PVFormat)])+'f';
    with ListView1 do
    begin
      L:=FindCaption(0,'Верхняя граница шкалы SP',False,True,False);
      if Assigned(L) then L.SubItems[0]:=Format(sFormat,[E.SPEUHi]);
      L:=FindCaption(0,'Нижняя граница шкалы SP',False,True,False);
      if Assigned(L) then L.SubItems[0]:=Format(sFormat,[E.SPEULo]);
      L:=FindCaption(0,'Отклонение PV от SP вверх',False,True,False);
      if Assigned(L) then L.SubItems[0]:=Format(sFormat,[E.PVDHTP]);
      L:=FindCaption(0,'Отклонение PV от SP вниз',False,True,False);
      if Assigned(L) then L.SubItems[0]:=Format(sFormat,[E.PVDLTP]);
    end;
  end;
end;

procedure TKontCREditForm.ChangeRegTypeClick(Sender: TObject);
var L: TListItem; M: TMenuItem;
begin
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  if Assigned(L) then
  begin
    E.RegType:=TRegType(M.Tag);
    L.SubItems[0]:=ARegType[E.RegType];
  end;
end;

procedure TKontCREditForm.ChangeCtoStrClick(Sender: TObject);
var L: TListItem; M: TMenuItem;
begin
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  if Assigned(L) then
  begin
    with ListView1 do
    if L.Caption = 'Контроль шага изменения SP' then
    begin
      E.CheckSP:=TCheckChange(M.Tag);
      L.SubItems[0]:=ACtoStr[E.CheckSP];
    end;
    if L.Caption = 'Контроль шага изменения OP' then
    begin
      E.CheckOP :=TCheckChange(M.Tag);
      L.SubItems[0]:=ACtoStr[E.CheckOP];
    end;
  end;
end;

procedure TKontCREditForm.ChangeLinkClick(Sender: TObject);
var List: TList; T,R: TEntity; L: TListItem;
begin
  L:=ListView1.Selected;
  if Assigned(L) then
  begin
    if L.Caption = 'Коэффициент усиления (K)' then T:=E.K
    else
     if L.Caption = 'Интегральный коэффициент (T1)' then T:=E.T1
     else
       if L.Caption = 'Дифференциальный коэффициент (T2)' then T:=E.T2
       else
        Exit;
    List:=TList.Create;
    try
      R:=Caddy.FirstEntity;
      while Assigned(R) do
      begin
        if R is TKontAnaParam and
          (R.Channel = E.Channel) and
          (R.Node = E.Node) then List.Add(R);
        R:=R.NextEntity;
      end;
      if GetLinkNameDlg(Self,L.Caption,List,
                        TImageList(ListView1.SmallImages),T) then
      begin
        if L.Caption = 'Коэффициент усиления (K)' then
        begin
          if not Assigned(T) then
          begin
            L.SubItems[0]:='------';
            L.SubItemImages[0]:=-1;
          end
          else
          begin
            E.K:=T as TKontAnaParam;
            L.SubItems[0]:=E.K.PtName+' - '+E.K.PtDesc;
            L.SubItemImages[0]:=EntityClassIndex(E.K.ClassType)+3;
          end;
        end;
        if L.Caption = 'Интегральный коэффициент (T1)' then
        begin
          if not Assigned(T) then
          begin
            L.SubItems[0]:='------';
            L.SubItemImages[0]:=-1;
          end
          else
          begin
            E.T1:=T as TKontAnaParam;
            L.SubItems[0]:=E.T1.PtName+' - '+E.T1.PtDesc;
            L.SubItemImages[0]:=EntityClassIndex(E.T1.ClassType)+3;
          end;
        end;
        if L.Caption = 'Дифференциальный коэффициент (T2)' then
        begin
          if not Assigned(T) then
          begin
            L.SubItems[0]:='------';
            L.SubItemImages[0]:=-1;
          end
          else
          begin
            E.T2:=T as TKontAnaParam;
            L.SubItems[0]:=E.T2.PtName+' - '+E.T2.PtDesc;
            L.SubItemImages[0]:=EntityClassIndex(E.T2.ClassType)+3;
          end;
        end;
      end;
    finally
      List.Free;
    end;
  end;
end;

procedure TKontCREditForm.DeleteLinkClick(Sender: TObject);
var T: TEntity; L: TListItem;
begin
  L:=ListView1.Selected;
  if Assigned(L) then
  begin
    if L.Caption = 'Коэффициент усиления (K)' then T:=E.K
    else
     if L.Caption = 'Интегральный коэффициент (T1)' then T:=E.T1
     else
       if L.Caption = 'Дифференциальный коэффициент (T2)' then T:=E.T2
       else
        Exit;
  if RemxForm.ShowQuestion('Удалить связь "'+T.PtName+'"?') = mrOK then
  begin
    if L.Caption = 'Коэффициент усиления (K)' then
    begin
      E.K:=nil;
      L.SubItems[0]:='------';
      L.SubItemImages[0]:=-1;
    end;
    if L.Caption = 'Интегральный коэффициент (T1)' then
    begin
      E.T1:=nil;
      L.SubItems[0]:='------';
      L.SubItemImages[0]:=-1;
    end;
    if L.Caption = 'Дифференциальный коэффициент (T2)' then
    begin
      E.T2:=nil;
      L.SubItems[0]:='------';
      L.SubItemImages[0]:=-1; end;
    end;
  end;
end;

procedure TKontCREditForm.ChangeIntegerClick(Sender: TObject);
var L: TListItem; V: Integer;
begin
  inherited;
  L:=ListView1.Selected;
  if Assigned(L) then
  begin
    if L.Caption = 'Номер контура' then V:=E.Place
    else
      Exit;
    if InputIntegerDlg(L.Caption,V) then
    begin
      if L.Caption = 'Номер контура' then
      begin
        if InRange(V,1,32) then
        begin
          E.Place:=V;
          L.SubItems[0]:=Format('%d',[E.Place]);
        end
        else
          raise ERangeError.Create('Значение вне допустимых границ (1..32)!');
      end;
    end;
  end;
end;

end.
