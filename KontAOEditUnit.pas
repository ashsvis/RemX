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
        Caption:='��������';
        SubItems.Add(IntToStr(E.Block));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='����� ���������';
        SubItems.Add(IntToStr(E.Place));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='������������';
        SubItems.Add(IfThen(E.Logged,'��','���'));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='������������';
        SubItems.Add(IfThen(E.Asked,'��','���'));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='�����';
        SubItems.Add(IfThen(E.Trend,'��','���'));
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
        Caption:='������ PV';
        SubItems.Add(Format('D%d',[Ord(E.PVFormat)]));
      end;
      sFormat:='%.'+Format('%d',[Ord(E.PVFormat)])+'f';
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='������� ������� �����';
        SubItems.Add(Format(sFormat,[E.PVEUHi]));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='������� ������������� �������';
        SubItems.Add(Format(sFormat,[E.PVHHTP])+' '+AAlmDB[E.HHDB]);
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='������� ����������������� �������';
        SubItems.Add(Format(sFormat,[E.PVHiTP])+' '+AAlmDB[E.HIDB]);
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='������ ����������������� �������';
        SubItems.Add(Format(sFormat,[E.PVLoTP])+' '+AAlmDB[E.LODB]);
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='������ ������������� �������';
        SubItems.Add(Format(sFormat,[E.PVLLTP])+' '+AAlmDB[E.LLDB]);
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='������ ������� �����';
        SubItems.Add(Format(sFormat,[E.PVEULo]));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='�������� ������ �����';
        SubItems.Add(AAlmDB[E.BadDB]);
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
      if (L.Caption = '��������') or
         (L.Caption = '����� ���������') then
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
      if L.Caption = '������������' then AddBoolItem(E.Logged);
      if L.Caption = '������������' then AddBoolItem(E.Asked);
      if L.Caption = '�����' then AddBoolItem(E.Trend);
      if L.Caption = '������� �� �����' then AddBoolItem(E.CalcScale);
      if L.Caption = '������ PV' then
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
      if (L.Caption = '������� ������� �����') or
         (L.Caption = '������ ������� �����') then
      begin
        M:=TMenuItem.Create(Self);
        M.Caption:='�������� ��������...';
        M.OnClick:=ChangeFloatClick;
        Items.Add(M);
      end;
      if (L.Caption = '������� ������������� �������') or
         (L.Caption = '������� ����������������� �������') or
         (L.Caption = '������ ����������������� �������') or
         (L.Caption = '������ ������������� �������') then
      begin
        M:=TMenuItem.Create(Self);
        M.Caption:='�������� ��������...';
        M.OnClick:=ChangeFloatClick;
        Items.Add(M);
        //---
        M:=TMenuItem.Create(Self); M.Caption:='-'; Items.Add(M);
      end;
      if L.Caption = '������� ������������� �������' then AddAlmItem(E.HHDB);
      if L.Caption = '������� ����������������� �������' then AddAlmItem(E.HiDB);
      if L.Caption = '������ ����������������� �������' then AddAlmItem(E.LoDB);
      if L.Caption = '������ ������������� �������' then AddAlmItem(E.LLDB);
      if L.Caption = '�������� ������ �����' then AddAlmItem(E.BadDB);
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
      if L.Caption = '������� ������������� �������' then
      begin
        E.HHDB:=TAlarmDeadband(M.Tag);
        L.SubItems[0]:=Format(sFormat,[E.PVHHTP])+' '+AAlmDB[E.HHDB];
      end;
      if L.Caption = '������� ����������������� �������' then
      begin
        E.HIDB:=TAlarmDeadband(M.Tag);
        L.SubItems[0]:=Format(sFormat,[E.PVHiTP])+' '+AAlmDB[E.HIDB];
      end;
      if L.Caption = '������ ����������������� �������' then
      begin
        E.LODB:=TAlarmDeadband(M.Tag);
        L.SubItems[0]:=Format(sFormat,[E.PVLoTP])+' '+AAlmDB[E.LODB];
      end;
      if L.Caption = '������ ������������� �������' then
      begin
        E.LLDB:=TAlarmDeadband(M.Tag);
        L.SubItems[0]:=Format(sFormat,[E.PVLLTP])+' '+AAlmDB[E.LLDB];
      end;
      if L.Caption = '�������� ������ �����' then
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
    if L.Caption = '������������' then
    begin
      E.Logged:=B;
      L.SubItems[0]:=IfThen(E.Logged,'��','���');
    end;
    if L.Caption = '������������' then
    begin
      E.Asked:=B;
      L.SubItems[0]:=IfThen(E.Asked,'��','���');
    end;
    if L.Caption = '�����' then
    begin
      E.Trend:=B;
      L.SubItems[0]:=IfThen(E.Trend,'��','���');
    end;
    if L.Caption = '������� �� �����' then
    begin
      E.CalcScale:=B;
      L.SubItems[0]:=IfThen(E.CalcScale,'��','���');
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
    if L.Caption = '������� ������� �����' then V:=E.PVEUHi
    else
     if L.Caption = '������� ������������� �������' then V:=E.PVHHTP
     else
      if L.Caption = '������� ����������������� �������' then V:=E.PVHiTP
      else
       if L.Caption = '������ ����������������� �������' then V:=E.PVLoTP
       else
        if L.Caption = '������ ������������� �������' then V:=E.PVLLTP
        else
         if L.Caption = '������ ������� �����' then V:=E.PVEULo
         else
          Exit;
    sFormat:='%.'+Format('%d',[Ord(E.PVFormat)])+'f';
    if InputFloatDlg(L.Caption,sFormat,V) then
    begin
      if L.Caption = '������� ������� �����' then
      begin
        if InRange(V,E.PVHHTP,V) then
        begin
          E.PVEUHi:=V;
          L.SubItems[0]:=Format(sFormat,[E.PVEUHi]);
        end
        else
          raise ERangeError.Create('�������� ��� ���������� ������!');
      end;
      if L.Caption = '������� ������������� �������' then
      begin
        if InRange(V,E.PVHiTP,E.PVEUHi) then
        begin
          E.PVHHTP:=V;
          L.SubItems[0]:=Format(sFormat,[E.PVHHTP])+' '+AAlmDB[E.HHDB];
        end
        else
          raise ERangeError.Create('�������� ��� ���������� ������!');
      end;
      if L.Caption = '������� ����������������� �������' then
      begin
        if InRange(V,E.PVLoTP,E.PVHHTP) then
        begin
          E.PVHiTP:=V;
          L.SubItems[0]:=Format(sFormat,[E.PVHiTP])+' '+AAlmDB[E.HiDB];
        end
        else
          raise ERangeError.Create('�������� ��� ���������� ������!');
      end;
      if L.Caption = '������ ����������������� �������' then
      begin
        if InRange(V,E.PVLLTP,E.PVHiTP) then
        begin
          E.PVLoTP:=V;
          L.SubItems[0]:=Format(sFormat,[E.PVLoTP])+' '+AAlmDB[E.LoDB];
        end
        else
          raise ERangeError.Create('�������� ��� ���������� ������!');
      end;
      if L.Caption = '������ ������������� �������' then
      begin
        if InRange(V,E.PVEULo,E.PVLoTP) then
        begin
          E.PVLLTP:=V;
          L.SubItems[0]:=Format(sFormat,[E.PVLLTP])+' '+AAlmDB[E.LLDB];
        end
        else
          raise ERangeError.Create('�������� ��� ���������� ������!');
      end;
      if L.Caption = '������ ������� �����' then
      begin
        if InRange(V,V,E.PVLLTP) then
        begin
          E.PVEULo:=V;
          L.SubItems[0]:=Format(sFormat,[E.PVEULo]);
        end
        else
          raise ERangeError.Create('�������� ��� ���������� ������!');
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
      L:=FindCaption(0,'������� ������� �����',False,True,False);
      if Assigned(L) then L.SubItems[0]:=Format(sFormat,[E.PVEUHi]);
      L:=FindCaption(0,'������� ������������� �������',False,True,False);
      if Assigned(L) then
        L.SubItems[0]:=Format(sFormat,[E.PVHHTP])+' '+AAlmDB[E.HHDB];
      L:=FindCaption(0,'������� ����������������� �������',False,True,False);
      if Assigned(L) then
        L.SubItems[0]:=Format(sFormat,[E.PVHiTP])+' '+AAlmDB[E.HIDB];
      L:=FindCaption(0,'������ ����������������� �������',False,True,False);
      if Assigned(L) then
        L.SubItems[0]:=Format(sFormat,[E.PVLoTP])+' '+AAlmDB[E.LODB];
      L:=FindCaption(0,'������ ������������� �������',False,True,False);
      if Assigned(L) then
        L.SubItems[0]:=Format(sFormat,[E.PVLLTP])+' '+AAlmDB[E.LLDB];
      L:=FindCaption(0,'������ ������� �����',False,True,False);
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
    if L.Caption = '��������' then V:=E.Block
    else
      if L.Caption = '����� ���������' then V:=E.Place
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
      end
      else
      if L.Caption = '����� ���������' then
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

end.

