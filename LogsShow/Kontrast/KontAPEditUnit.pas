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
        Caption:='�����������';
        SubItems.Add(E.EUDesc);
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='������ OP';
        SubItems.Add(Format('D%d',[Ord(E.OPFormat)]));
      end;
      sFormat:='%.'+Format('%d',[Ord(E.OPFormat)])+'f';
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='������� ������� �����';
        SubItems.Add(Format(sFormat,[E.OPEUHi]));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='������ ������� �����';
        SubItems.Add(Format(sFormat,[E.OPEULo]));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='������� �� �����';
        SubItems.Add(IfThen(E.CalcScale,'��','���'));
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
      if (L.Caption = '��������') or
         (L.Caption = '�������� ���������') then
      begin
        M:=TMenuItem.Create(Self);
        M.Caption:='�������� �����...';
        M.OnClick:=ChangeIntegerClick;
        Items.Add(M);
      end;
      if L.Caption = '�����������' then
      begin
        M:=TMenuItem.Create(Self);
        M.Caption:='�������� �����...';
        M.OnClick:=ChangeTextClick;
        Items.Add(M);
      end;
      if L.Caption = '������� �� �����' then AddBoolItem(E.CalcScale);
      if L.Caption = '������ OP' then
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
      if (L.Caption = '������� ������� �����') or
         (L.Caption = '������ ������� �����') then
      begin
        M:=TMenuItem.Create(Self);
        M.Caption:='�������� ��������...';
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
    if L.Caption = '��������' then V:=E.Block
    else
      if L.Caption = '�������� ���������' then V:=E.Place
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
    if L.Caption = '�����������' then
      S:=L.SubItems[0]
    else
      Exit;
    if InputStringDlg(L.Caption,S,10) then
    begin
      if L.Caption = '�����������' then
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
    if L.Caption = '������� �� �����' then
    begin
      E.CalcScale:=B;
      L.SubItems[0]:=IfThen(E.CalcScale,'��','���');
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
      L:=FindCaption(0,'������� ������� �����',False,True,False);
      if Assigned(L) then L.SubItems[0]:=Format(sFormat,[E.OPEUHi]);
      L:=FindCaption(0,'������ ������� �����',False,True,False);
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
    if L.Caption = '������� ������� �����' then V:=E.OPEUHi
    else
      if L.Caption = '������ ������� �����' then V:=E.OPEULo
      else
        Exit;
    sFormat:='%.'+Format('%d',[Ord(E.OPFormat)])+'f';
    if InputFloatDlg(L.Caption,sFormat,V) then
    begin
      if L.Caption = '������� ������� �����' then
      begin
        if InRange(V,E.OPEULo,V) then
        begin
          E.OPEUHi:=V;
          L.SubItems[0]:=Format(sFormat,[E.OPEUHi]);
        end
        else
          raise ERangeError.Create('�������� ��� ���������� ������!');
      end;
      if L.Caption = '������ ������� �����' then
      begin
        if InRange(V,V,E.OPEUHi) then
        begin
          E.OPEULo:=V;
          L.SubItems[0]:=Format(sFormat,[E.OPEULo]);
        end
        else
          raise ERangeError.Create('�������� ��� ���������� ������!');
      end;
    end;
  end;
end;

end.
