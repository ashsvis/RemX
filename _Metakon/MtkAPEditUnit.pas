unit MtkAPEditUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, EntityUnit, MetakonUnit, Menus;

type
  TMtkAPEditForm = class(TMtkEditForm)
  private
    E: TMtkAnaParam;
    procedure ChangeOPFormatClick(Sender: TObject);
    procedure ChangeFloatClick(Sender: TObject);
    procedure ChangeMtkKindClick(Sender: TObject);
  protected
    procedure ConnectEntity(Entity: TEntity); override;
    procedure PopupMenu1Popup(Sender: TObject); override;
    procedure ChangeTextClick(Sender: TObject); override;
    procedure ChangeBooleanClick(Sender: TObject); override;
  public
  end;

var
  MtkAPEditForm: TMtkAPEditForm;

implementation

uses StrUtils, GetPtNameUnit, Math;

{$R *.dfm}

{ TKontAPEditForm }

procedure TMtkAPEditForm.ConnectEntity(Entity: TEntity);
var sFormat: string;
begin
  inherited;
  E:=Entity as TMtkAnaParam;
  with ListView1 do
  begin
    Items.BeginUpdate;
    try
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
        Caption:='Тип параметра';
        SubItems.Add(AMtkKind[E.MtkKind]+' - '+AFullMtkKind[E.MtkKind]);
      end;
    finally
      Items.EndUpdate;
    end;
  end;
end;

procedure TMtkAPEditForm.PopupMenu1Popup(Sender: TObject);
var L: TListItem; M: TMenuItem; i: integer; k: TMtkKind;
begin
  inherited;
  L:=ListView1.Selected;
  with PopupMenu1 do
  begin
    if Assigned(L) then
    begin
      if L.Caption = 'Размерность' then
      begin
        M:=TMenuItem.Create(Self);
        M.Caption:='Изменить текст...';
        M.OnClick:=ChangeTextClick;
        Items.Add(M);
      end;
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
      if L.Caption = 'Тип параметра' then
      begin
        for k:=Low(AMtkKind) to High(AMtkKind) do
        begin
          M:=TMenuItem.Create(Self);
          M.Caption:=AMtkKind[k];
          M.Tag:=Ord(k);
          M.OnClick:=ChangeMtkKindClick;
          M.Checked:=(E.MtkKind = k);
          Items.Add(M);
        end;
      end;
    end;
  end;
end;

procedure TMtkAPEditForm.ChangeTextClick(Sender: TObject);
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

procedure TMtkAPEditForm.ChangeBooleanClick(Sender: TObject);
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

procedure TMtkAPEditForm.ChangeOPFormatClick(Sender: TObject);
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

procedure TMtkAPEditForm.ChangeFloatClick(Sender: TObject);
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

procedure TMtkAPEditForm.ChangeMtkKindClick(Sender: TObject);
var L: TListItem; M: TMenuItem;
begin
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  if Assigned(L) then
  begin
    E.MtkKind:=TMtkKind(M.Tag);
    L.SubItems[0]:=AMtkKind[E.MtkKind]+' - '+AFullMtkKind[E.MtkKind];
    with ListView1 do
    begin
      L:=FindCaption(0,'Размерность',False,True,False);
      if Assigned(L) then
      begin
        E.EUDesc:=AEUMtkKind[E.MtkKind];
        L.SubItems[0]:=E.EUDesc;
      end;
    end;
  end;
end;

end.
