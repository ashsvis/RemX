unit KontDOEditUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Menus, EntityUnit, KontrastUnit, ImgList;

type
  TKontDOEditForm = class(TKontEditForm)
    ImageList1: TImageList;
    procedure FormCreate(Sender: TObject);
  private
    E: TKontDigOut;
    procedure ChangeFixedColorClick(Sender: TObject);
  protected
    procedure ConnectEntity(Entity: TEntity); override;
    procedure PopupMenu1Popup(Sender: TObject); override;
    procedure ChangeIntegerClick(Sender: TObject); override;
    procedure ChangeTextClick(Sender: TObject); override;
    procedure ChangeBooleanClick(Sender: TObject); override;
  public
  end;

var
  KontDOEditForm: TKontDOEditForm;

implementation

uses StrUtils, GetPtNameUnit, Math;

{$R *.dfm}

{ TKontDOEditForm }

procedure TKontDOEditForm.ConnectEntity(Entity: TEntity);
begin
  inherited;
  E:=Entity as TKontDigOut;
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
        Caption:='Инверсия данных';
        SubItems.Add(IfThen(E.Invert,'Да','Нет'));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Авария при "0"->"1"';
        SubItems.Add(IfThen(E.AlarmUp,'Да','Нет'));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Авария при "1"->"0"';
        SubItems.Add(IfThen(E.AlarmDown,'Да','Нет'));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Переключение при "0"->"1"';
        SubItems.Add(IfThen(E.SwitchUp,'Да','Нет'));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Переключение при "1"->"0"';
        SubItems.Add(IfThen(E.SwitchDown,'Да','Нет'));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Цвет при "1"';
        SubItems.Add(StringDigColor[E.ColorUp]);
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Цвет при "0"';
        SubItems.Add(StringDigColor[E.ColorDown]);
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Текст при "1"';
        SubItems.Add(E.TextUp);
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Текст при "0"';
        SubItems.Add(E.TextDown);
      end;
    finally
      Items.EndUpdate;
    end;
  end;
end;

procedure TKontDOEditForm.PopupMenu1Popup(Sender: TObject);
var L: TListItem; M: TMenuItem; DC: TDigColor;
begin
  inherited;
  L:=ListView1.Selected;
  with PopupMenu1 do
  begin
    Images:=nil;
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
      if L.Caption = 'Сигнализация' then AddBoolItem(E.Logged);
      if L.Caption = 'Квитирование' then AddBoolItem(E.Asked);
      if L.Caption = 'Инверсия данных' then AddBoolItem(E.Invert);
      if L.Caption = 'Авария при "0"->"1"' then AddBoolItem(E.AlarmUp);
      if L.Caption = 'Авария при "1"->"0"' then AddBoolItem(E.AlarmDown);
      if L.Caption = 'Переключение при "0"->"1"' then AddBoolItem(E.SwitchUp);
      if L.Caption = 'Переключение при "1"->"0"' then AddBoolItem(E.SwitchDown);
      if (L.Caption = 'Цвет при "1"') or
         (L.Caption = 'Цвет при "0"') then
      begin
        for DC:=Low(StringDigColor) to High(StringDigColor) do
        begin
          Images:=ImageList1;
          M:=TMenuItem.Create(Self);
          M.Caption:=StringDigColor[DC];
          if L.Caption = 'Цвет при "1"' then
            M.Default:=(E.ColorUp = DC)
          else
            M.Default:=(E.ColorDown = DC);
          M.Tag:=Ord(DC);
          M.OnClick:=ChangeFixedColorClick;
          M.ImageIndex:=Ord(DC);
          Items.Add(M);
        end;
      end;
      if (L.Caption = 'Текст при "1"') or
         (L.Caption = 'Текст при "0"') then
      begin
        M:=TMenuItem.Create(Self);
        M.Caption:='Изменить текст...';
        M.OnClick:=ChangeTextClick;
        Items.Add(M);
      end;
    end;
  end;
end;

procedure TKontDOEditForm.ChangeIntegerClick(Sender: TObject);
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

procedure TKontDOEditForm.ChangeTextClick(Sender: TObject);
var L: TListItem; S: string;
begin
  inherited;
  L:=ListView1.Selected;
  if Assigned(L) then
  begin
    if (L.Caption = 'Текст при "1"') or
       (L.Caption = 'Текст при "0"') then
      S:=L.SubItems[0]
    else
      Exit;
    if InputStringDlg(L.Caption,S,10) then
    begin
      if L.Caption = 'Текст при "1"' then
      begin
        E.TextUp:=S;
        L.SubItems[0]:=E.TextUp;
      end;
      if L.Caption = 'Текст при "0"' then
      begin
        E.TextDown:=S;
        L.SubItems[0]:=E.TextDown;
      end;
    end;
  end;
end;

procedure TKontDOEditForm.ChangeBooleanClick(Sender: TObject);
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
    if L.Caption = 'Инверсия данных' then
    begin
      E.Invert:=B;
      L.SubItems[0]:=IfThen(E.Invert,'Да','Нет');
    end;
    if L.Caption = 'Авария при "0"->"1"' then
    begin
      E.AlarmUp:=B;
      L.SubItems[0]:=IfThen(E.AlarmUp,'Да','Нет');
    end;
    if L.Caption = 'Авария при "1"->"0"' then
    begin
      E.AlarmDown:=B;
      L.SubItems[0]:=IfThen(E.AlarmDown,'Да','Нет');
    end;
    if L.Caption = 'Переключение при "0"->"1"' then
    begin
      E.SwitchUp:=B;
      L.SubItems[0]:=IfThen(E.SwitchUp,'Да','Нет');
    end;
    if L.Caption = 'Переключение при "1"->"0"' then
    begin
      E.SwitchDown:=B;
      L.SubItems[0]:=IfThen(E.SwitchDown,'Да','Нет');
    end;
  end
end;

procedure TKontDOEditForm.ChangeFixedColorClick(Sender: TObject);
var L: TListItem; M: TMenuItem; DC: TDigColor;
begin
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  DC:=TDigColor(M.Tag);
  if Assigned(L) then
  begin
    if L.Caption = 'Цвет при "1"' then
    begin
      E.ColorUp:=DC;
      L.SubItems[0]:=StringDigColor[E.ColorUp];
    end
    else
    begin
      E.ColorDown:=DC;
      L.SubItems[0]:=StringDigColor[E.ColorDown];
    end;
  end;
end;

procedure TKontDOEditForm.FormCreate(Sender: TObject);
var DC: TDigColor; B: TBitmap;
begin
  B:=TBitmap.Create;
  try
    B.Width:=ImageList1.Width;
    B.Height:=ImageList1.Height;
    for DC:=Low(StringDigColor) to High(StringDigColor) do
    begin
      B.Canvas.Brush.Color:=ArrayDigColor[DC];
      B.Canvas.Rectangle(Rect(0,0,B.Width,B.Height));
      ImageList1.Add(B,nil);
    end;
  finally
    B.Free;
  end;
end;

end.
