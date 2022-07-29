unit KontDPEditUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, EntityUnit, KontrastUnit, Menus;

type
  TKontDPEditForm = class(TKontEditForm)
  private
    E: TKontDigParam;
  protected
    procedure ConnectEntity(Entity: TEntity); override;
    procedure PopupMenu1Popup(Sender: TObject); override;
    procedure ChangeIntegerClick(Sender: TObject); override;
    procedure ChangeBooleanClick(Sender: TObject); override;
  public
  end;

var
  KontDPEditForm: TKontDPEditForm;

implementation

uses StrUtils, GetPtNameUnit, Math;

{$R *.dfm}

{ TKontDPEditForm }

procedure TKontDPEditForm.ConnectEntity(Entity: TEntity);
begin
  inherited;
  E:=Entity as TKontDigParam;
  with ListView1 do
  begin
    Items.BeginUpdate;
    try
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='��������';
        SubItems.Add(IntToStr(E.Block));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='�������� ���������';
        SubItems.Add(IntToStr(E.Place));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='�������� ������';
        if E.SourceEntity=nil then
          SubItems.Add('����')
        else
        begin
          SubItems.Add(E.SourceEntity.PtName+' - '+E.SourceEntity.PtDesc);
          SubItemImages[0]:=EntityClassIndex(E.SourceEntity.ClassType)+3;
        end;
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='�������� ������';
        SubItems.Add(IfThen(E.Invert,'��','���'));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='����� ������';
        SubItems.Add(Format('%d ����',[E.PulseWait]));
      end;
    finally
      Items.EndUpdate;
    end;
  end;
end;

procedure TKontDPEditForm.PopupMenu1Popup(Sender: TObject);
var L: TListItem; M: TMenuItem;
begin
  inherited;
  L:=ListView1.Selected;
  with PopupMenu1 do
  begin
    if Assigned(L) then
    begin
      if (L.Caption = '��������') or
         (L.Caption = '�������� ���������') or
         (L.Caption = '����� ������') then
      begin
        M:=TMenuItem.Create(Self);
        M.Caption:='�������� �����...';
        M.OnClick:=ChangeIntegerClick;
        Items.Add(M);
      end;
      if L.Caption = '�������� ������' then AddBoolItem(E.Invert);
    end;
  end;
end;

procedure TKontDPEditForm.ChangeBooleanClick(Sender: TObject);
var L: TListItem; M: TMenuItem; B: Boolean;
begin
  inherited;
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  B:=(M.Tag = 1);
  if Assigned(L) then
  begin
    if L.Caption = '�������� ������' then
    begin
      E.Invert:=B;
      L.SubItems[0]:=IfThen(E.Invert,'��','���');
    end;
  end
end;

procedure TKontDPEditForm.ChangeIntegerClick(Sender: TObject);
var L: TListItem; V: Integer;
begin
  inherited;
  L:=ListView1.Selected;
  if Assigned(L) then
  begin
    if L.Caption = '��������' then V:=E.Block
    else
      if L.Caption = '�������� ���������' then V:=E.Place
      else
        if L.Caption = '����� ������' then V:=E.PulseWait
        else
          Exit;
    if InputIntegerDlg(L.Caption,V) then
    begin
      if L.Caption = '��������' then
      begin
        if InRange(V,1,999) then
        begin
          E.Block:=V;
          L.SubItems[0]:=Format('%d',[E.Block]);
        end
        else
          raise ERangeError.Create('�������� ��� ���������� ������ (1..999)!');
      end;
      if L.Caption = '�������� ���������' then
      begin
        if InRange(V,1,127) then
        begin
          E.Place:=V;
          L.SubItems[0]:=Format('%d',[E.Place]);
        end
        else
          raise ERangeError.Create('�������� ��� ���������� ������ (1..127)!');
      end;
      if L.Caption = '����� ������' then
      begin
        if InRange(V,10,10000) then
        begin
          E.PulseWait:=V;
          L.SubItems[0]:=Format('%d ����',[E.PulseWait]);
        end
        else
          raise ERangeError.Create('�������� ��� ���������� ������ (10..10000 ����)!');
      end;
    end;
  end;
end;

end.
