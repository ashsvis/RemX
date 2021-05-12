unit KontAPEditUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, EntityUnit, KontrastUnit, Menus;

type
  TKontAPEditForm = class(TKontEditForm)
  private
    E: TKontAnaParam;
    procedure ChangeOPFormatClick(Sender: TObject);
    procedure ChangeFloatClick(Sender: TObject);
  protected
    procedure ConnectEntity(Entity: TEntity); override;
    procedure PopupMenu1Popup(Sender: TObject); override;
    procedure ChangeIntegerClick(Sender: TObject); override;
    procedure ChangeTextClick(Sender: TObject); override;
    procedure ChangeBooleanClick(Sender: TObject); override;
  public
  end;

var
  KontAPEditForm: TKontAPEditForm;

implementation

uses StrUtils, GetPtNameUnit, Math;

{$R *.dfm}

{ TKontAPEditForm }

procedure TKontAPEditForm.ConnectEntity(Entity: TEntity);
var sFormat: string;
begin
  inherited;
  E:=Entity as TKontAnaParam;
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
        Caption:='Параметр алгоблока';
        SubItems.Add(IntToStr(E.Place));
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
        Caption:='Формат OP';
        SubItems.Add(Format('D%d',[Ord(E.OPFormat)]));
      end;
      sFormat:='%.'+Format('%d',[Ord(E.OPFormat)])+'f';
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Верхняя граница шкалы';
        SubItems.Add(Format(sFormat,[E.OPEUHi]));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Нижняя граница шкалы';
        SubItems.Add(Format(sFormat,[E.OPEULo]));
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

procedure TKontAPEditForm.PopupMenu1Popup(Sender: TObject);
var L: TListItem; M: TMenuItem; i: integer;
begin
  inherited;
  L:=ListView1.Selected;
  with PopupMenu1 do
  begin
    if Assigned(L) then
    begin
      if (L.Caption = 'Алгоблок') or
         (L.Caption = 'Параметр алгоблока') then
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
      if L.Caption = 'Масштаб по шкале' then AddBoolItem(E.CalcScale);
      if L.Caption = 'Формат OP' then
      begin
        for i:=0 to 3 do
        begin
          M:=TMenuItem.Create(Self);
          M.Caption:='D'+IntToStr(i);
          M.Tag:=i;
          M.OnClick:=ChangeOPFormatClick;
          M.Checked:=(Ord(E.OPFormat) = i);
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
    end;
  end;
end;

procedure TKontAPEditForm.ChangeIntegerClick(Sender: TObject);
var L: TListItem; V: Integer;
begin
  inherited;
  L:=ListView1.Selected;
  if Assigned(L) then
  begin
    if L.Caption = 'Алгоблок' then V:=E.Block
    else
      if L.Caption = 'Параметр алгоблока' then V:=E.Place
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
      end;
      if L.Caption = 'Параметр алгоблока' then
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

procedure TKontAPEditForm.ChangeTextClick(Sender: TObject);
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

procedure TKontAPEditForm.ChangeBooleanClick(Sender: TObject);
var L: TListItem; M: TMenuItem; B: Boolean;
begin
  inherited;
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  B:=(M.Tag = 1);
  if Assigned(L) then
  begin
    if L.Caption = 'Масштаб по шкале' then
    begin
      E.CalcScale:=B;
      L.SubItems[0]:=IfThen(E.CalcScale,'Да','Нет');
    end;
  end
end;

procedure TKontAPEditForm.ChangeOPFormatClick(Sender: TObject);
var L: TListItem; M: TMenuItem; sFormat: string;
begin
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  if Assigned(L) then
  begin
    E.OPFormat:=TPVFormat(M.Tag); L.SubItems[0]:=Format('D%d',[Ord(E.OPFormat)]);
    sFormat:='%.'+Format('%d',[Ord(E.OPFormat)])+'f';
    with ListView1 do
    begin
      L:=FindCaption(0,'Верхняя граница шкалы',False,True,False);
      if Assigned(L) then L.SubItems[0]:=Format(sFormat,[E.OPEUHi]);
      L:=FindCaption(0,'Нижняя граница шкалы',False,True,False);
      if Assigned(L) then L.SubItems[0]:=Format(sFormat,[E.OPEULo]);
    end;
  end;
end;

procedure TKontAPEditForm.ChangeFloatClick(Sender: TObject);
var L: TListItem; sFormat: string; V: Single;
begin
  if not Assigned(E) then Exit;
  L:=ListView1.Selected;
  if Assigned(L) then
  begin
    if L.Caption = 'Верхняя граница шкалы' then V:=E.OPEUHi
    else
      if L.Caption = 'Нижняя граница шкалы' then V:=E.OPEULo
      else
        Exit;
    sFormat:='%.'+Format('%d',[Ord(E.OPFormat)])+'f';
    if InputFloatDlg(L.Caption,sFormat,V) then
    begin
      if L.Caption = 'Верхняя граница шкалы' then
      begin
        if InRange(V,E.OPEULo,V) then
        begin
          E.OPEUHi:=V;
          L.SubItems[0]:=Format(sFormat,[E.OPEUHi]);
        end
        else
          raise ERangeError.Create('Значение вне допустимых границ!');
      end;
      if L.Caption = 'Нижняя граница шкалы' then
      begin
        if InRange(V,V,E.OPEUHi) then
        begin
          E.OPEULo:=V;
          L.SubItems[0]:=Format(sFormat,[E.OPEULo]);
        end
        else
          raise ERangeError.Create('Значение вне допустимых границ!');
      end;
    end;
  end;
end;

end.
