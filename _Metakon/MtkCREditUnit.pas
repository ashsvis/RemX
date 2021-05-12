unit MtkCREditUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, EntityUnit, MetakonUnit;

type
  TMtkCREditForm = class(TMtkEditForm)
  private
    E: TMtkCntReg;
    procedure ChangeCtoStrClick(Sender: TObject);
    procedure ChangeLinkClick(Sender: TObject);
    procedure DeleteLinkClick(Sender: TObject);
  protected
    procedure ChangePVFormatClick(Sender: TObject); virtual;
    procedure ChangeFloatClick(Sender: TObject); virtual;
    procedure ChangeAlmDBClick(Sender: TObject); virtual;
    procedure ConnectEntity(Entity: TEntity); override;
    procedure PopupMenu1Popup(Sender: TObject); override;
    procedure ChangeTextClick(Sender: TObject); override;
    procedure ChangeBooleanClick(Sender: TObject); override;
    procedure ListView1DblClick(Sender: TObject); override;
  public
  end;

var
  MtkCREditForm: TMtkCREditForm;

implementation

uses StrUtils, ComCtrls, Math, Menus, GetPtNameUnit, GetLinkNameUnit,
  RemXUnit;
{  RemXUnit}

{$R *.dfm}

{ TMtkCREditForm }

procedure TMtkCREditForm.ConnectEntity(Entity: TEntity);
var sFormat: string;
begin
  inherited;
  E:=Entity as TMtkCntReg;
  with ListView1 do
  begin
    Items.BeginUpdate;
    try
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
        Caption:='������� ������� ����� SP';
        SubItems.Add(Format(sFormat,[E.SPEUHi]));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='������ ������� ����� SP';
        SubItems.Add(Format(sFormat,[E.SPEULo]));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='���������� PV �� SP �����';
        SubItems.Add(Format(sFormat,[E.PVDHTP]));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='���������� PV �� SP ����';
        SubItems.Add(Format(sFormat,[E.PVDLTP]));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='�������� ���� ��������� SP';
        SubItems.Add(ACtoStr[E.CheckSP]);
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='�������� ���� ��������� OP';
        SubItems.Add(ACtoStr[E.CheckOP]);
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='����������� �������� (K)';
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
        Caption:='������������ ����������� (T1)';
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
        Caption:='���������������� ����������� (T2)';
        if E.T2=nil then
          SubItems.Add('------')
        else
        begin
          SubItems.Add(E.T2.PtName+' - '+E.T2.PtDesc);
          SubItemImages[0]:=EntityClassIndex(E.T2.ClassType)+3;
        end;
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='�������� ��������� ������� (T3)';
        if E.T3=nil then
          SubItems.Add('------')
        else
        begin
          SubItems.Add(E.T3.PtName+' - '+E.T3.PtDesc);
          SubItemImages[0]:=EntityClassIndex(E.T3.ClassType)+3;
        end;
      end;
    finally
      Items.EndUpdate;
    end;
  end;
end;

procedure TMtkCREditForm.PopupMenu1Popup(Sender: TObject);
var L: TListItem; M: TMenuItem; i: integer; n: TCheckChange;
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
      if (L.Caption='������� ������� ����� SP') or
         (L.Caption='������ ������� ����� SP') or
         (L.Caption='���������� PV �� SP �����') or
         (L.Caption='���������� PV �� SP ����') then
      begin
        M:=TMenuItem.Create(Self);
        M.Caption:='�������� ��������...';
        M.OnClick:=ChangeFloatClick;
        Items.Add(M);
      end;
      if (L.Caption='�������� ���� ��������� SP') or
         (L.Caption='�������� ���� ��������� OP') then
      begin
        for n:=Low(ACtoStr) to High(ACtoStr) do
        begin
          M:=TMenuItem.Create(Self);
          M.Caption:=ACtoStr[n];
          M.Tag:=Ord(n);
          M.OnClick:=ChangeCtoStrClick;
          if L.Caption='�������� ���� ��������� SP' then
            M.Checked:=(E.CheckSP = n)
          else
            M.Checked:=(E.CheckOP = n);
          Items.Add(M);
        end;
      end;
      if (L.Caption='����������� �������� (K)') or
         (L.Caption='������������ ����������� (T1)') or
         (L.Caption='���������������� ����������� (T2)') or
         (L.Caption='�������� ��������� ������� (T3)') then
      begin
        M:=TMenuItem.Create(Self);
        M.Caption:='�������� �����...';
        M.Tag:=L.Index;
        M.OnClick:=ChangeLinkClick;
        Items.Add(M);
        M:=TMenuItem.Create(Self);
        M.Caption:='������� �����';
        M.Tag:=L.Index;
        M.OnClick:=DeleteLinkClick;
        if L.Caption='����������� �������� (K)' then
          M.Enabled:=(E.K <> nil)
        else
          if L.Caption='������������ ����������� (T1)' then
            M.Enabled:=(E.T1 <> nil)
          else
            if L.Caption='���������������� ����������� (T2)' then
              M.Enabled:=(E.T2 <> nil)
            else
              M.Enabled:=(E.T3 <> nil);
        Items.Add(M);
      end;
    end;
  end;
end;

procedure TMtkCREditForm.ChangeTextClick(Sender: TObject);
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

procedure TMtkCREditForm.ChangeAlmDBClick(Sender: TObject);
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

procedure TMtkCREditForm.ChangeBooleanClick(Sender: TObject);
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
  end
end;

procedure TMtkCREditForm.ChangeFloatClick(Sender: TObject);
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
          if L.Caption = '������� ������� ����� SP' then V:=E.SPEUHi
          else
           if L.Caption = '������ ������� ����� SP' then V:=E.SPEULo
           else
            if L.Caption = '���������� PV �� SP �����' then V:=E.PVDHTP
            else
             if L.Caption = '���������� PV �� SP ����' then V:=E.PVDLTP
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
      if L.Caption = '������� ������� ����� SP' then
      begin
        if InRange(V,E.SPEULo,E.PVEUHi) then
        begin
          E.SPEUHi:=V;
          L.SubItems[0]:=Format(sFormat,[E.SPEUHi]);
        end
        else
          raise ERangeError.Create('�������� ��� ���������� ������!');
      end;
      if L.Caption = '������ ������� ����� SP' then
      begin
        if InRange(V,E.PVEULo,E.SPEUHi) then
        begin
          E.SPEULo:=V;
          L.SubItems[0]:=Format(sFormat,[E.SPEULo]);
        end
        else
          raise ERangeError.Create('�������� ��� ���������� ������!');
      end;
      if L.Caption = '���������� PV �� SP �����' then
      begin
        if InRange(V,0,E.SPEUHi) then
        begin
          E.PVDHTP:=V;
          L.SubItems[0]:=Format(sFormat,[E.PVDHTP]);
        end
        else
          raise ERangeError.Create('�������� ��� ���������� ������!');
      end;
      if L.Caption = '���������� PV �� SP ����' then
      begin
        if InRange(V,0,E.SPEUHi) then
        begin
          E.PVDLTP:=V;
          L.SubItems[0]:=Format(sFormat,[E.PVDLTP]);
        end
        else
          raise ERangeError.Create('�������� ��� ���������� ������!');
      end;
    end;
  end;
end;

procedure TMtkCREditForm.ChangePVFormatClick(Sender: TObject);
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
      L:=FindCaption(0,'������� ������� ����� SP',False,True,False);
      if Assigned(L) then L.SubItems[0]:=Format(sFormat,[E.SPEUHi]);
      L:=FindCaption(0,'������ ������� ����� SP',False,True,False);
      if Assigned(L) then L.SubItems[0]:=Format(sFormat,[E.SPEULo]);
      L:=FindCaption(0,'���������� PV �� SP �����',False,True,False);
      if Assigned(L) then L.SubItems[0]:=Format(sFormat,[E.PVDHTP]);
      L:=FindCaption(0,'���������� PV �� SP ����',False,True,False);
      if Assigned(L) then L.SubItems[0]:=Format(sFormat,[E.PVDLTP]);
    end;
  end;
end;

procedure TMtkCREditForm.ChangeCtoStrClick(Sender: TObject);
var L: TListItem; M: TMenuItem;
begin
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  if Assigned(L) then
  begin
    with ListView1 do
    if L.Caption = '�������� ���� ��������� SP' then
    begin
      E.CheckSP:=TCheckChange(M.Tag);
      L.SubItems[0]:=ACtoStr[E.CheckSP];
    end;
    if L.Caption = '�������� ���� ��������� OP' then
    begin
      E.CheckOP :=TCheckChange(M.Tag);
      L.SubItems[0]:=ACtoStr[E.CheckOP];
    end;
  end;
end;

procedure TMtkCREditForm.ChangeLinkClick(Sender: TObject);
var List: TList; T,R: TEntity; L: TListItem;
begin
  L:=ListView1.Selected;
  if Assigned(L) then
  begin
    if L.Caption = '����������� �������� (K)' then T:=E.K
    else
     if L.Caption = '������������ ����������� (T1)' then T:=E.T1
     else
       if L.Caption = '���������������� ����������� (T2)' then T:=E.T2
       else
         if L.Caption = '�������� ��������� ������� (T3)' then T:=E.T3
         else
          Exit;
    List:=TList.Create;
    try
      R:=Caddy.FirstEntity;
      while Assigned(R) do
      begin
        if R is TMtkAnaParam and
          (R.Channel = E.Channel) and
          (R.Node = E.Node) then List.Add(R);
        R:=R.NextEntity;
      end;
      if GetLinkNameDlg(Self,L.Caption,List,
                        TImageList(ListView1.SmallImages),T) then
      begin
        if L.Caption = '����������� �������� (K)' then
        begin
          if not Assigned(T) then
          begin
            L.SubItems[0]:='------';
            L.SubItemImages[0]:=-1;
          end
          else
          begin
            E.K:=T as TMtkAnaParam;
            L.SubItems[0]:=E.K.PtName+' - '+E.K.PtDesc;
            L.SubItemImages[0]:=EntityClassIndex(E.K.ClassType)+3;
          end;
        end;
        if L.Caption = '������������ ����������� (T1)' then
        begin
          if not Assigned(T) then
          begin
            L.SubItems[0]:='------';
            L.SubItemImages[0]:=-1;
          end
          else
          begin
            E.T1:=T as TMtkAnaParam;
            L.SubItems[0]:=E.T1.PtName+' - '+E.T1.PtDesc;
            L.SubItemImages[0]:=EntityClassIndex(E.T1.ClassType)+3;
          end;
        end;
        if L.Caption = '���������������� ����������� (T2)' then
        begin
          if not Assigned(T) then
          begin
            L.SubItems[0]:='------';
            L.SubItemImages[0]:=-1;
          end
          else
          begin
            E.T2:=T as TMtkAnaParam;
            L.SubItems[0]:=E.T2.PtName+' - '+E.T2.PtDesc;
            L.SubItemImages[0]:=EntityClassIndex(E.T2.ClassType)+3;
          end;
        end;
        if L.Caption = '�������� ��������� ������� (T3)' then
        begin
          if not Assigned(T) then
          begin
            L.SubItems[0]:='------';
            L.SubItemImages[0]:=-1;
          end
          else
          begin
            E.T3:=T as TMtkAnaParam;
            L.SubItems[0]:=E.T3.PtName+' - '+E.T3.PtDesc;
            L.SubItemImages[0]:=EntityClassIndex(E.T3.ClassType)+3;
          end;
        end;
      end;
    finally
      List.Free;
    end;
  end;
end;

procedure TMtkCREditForm.DeleteLinkClick(Sender: TObject);
var T: TEntity; L: TListItem;
begin
  L:=ListView1.Selected;
  if Assigned(L) then
  begin
    if L.Caption = '����������� �������� (K)' then T:=E.K
    else
     if L.Caption = '������������ ����������� (T1)' then T:=E.T1
     else
       if L.Caption = '���������������� ����������� (T2)' then T:=E.T2
       else
         if L.Caption = '�������� ��������� ������� (T3)' then T:=E.T3
         else
          Exit;
    if RemxForm.ShowQuestion('������� ����� "'+T.PtName+'"?') = mrOK then
    begin
      if L.Caption = '����������� �������� (K)' then
      begin
        E.K:=nil;
        L.SubItems[0]:='------';
        L.SubItemImages[0]:=-1;
      end;
      if L.Caption = '������������ ����������� (T1)' then
      begin
        E.T1:=nil;
        L.SubItems[0]:='------';
        L.SubItemImages[0]:=-1;
      end;
      if L.Caption = '���������������� ����������� (T2)' then
      begin
        E.T2:=nil;
        L.SubItems[0]:='------';
        L.SubItemImages[0]:=-1;
      end;
      if L.Caption = '�������� ��������� ������� (T3)' then
      begin
        E.T3:=nil;
        L.SubItems[0]:='------';
        L.SubItemImages[0]:=-1;
      end;
    end;
  end;  
end;

procedure TMtkCREditForm.ListView1DblClick(Sender: TObject);
begin
  inherited;
  if Assigned(ListView1.Selected) then
  begin
    if ListView1.Selected.Caption = '����������� �������� (K)' then
    begin
      if Assigned(E.K) then
        E.K.ShowEditor(Monitor.MonitorNum);
    end;
    if ListView1.Selected.Caption = '������������ ����������� (T1)' then
    begin
      if Assigned(E.T1) then
        E.T1.ShowEditor(Monitor.MonitorNum);
    end;
    if ListView1.Selected.Caption = '���������������� ����������� (T2)' then
    begin
      if Assigned(E.T2) then
        E.T2.ShowEditor(Monitor.MonitorNum);
    end;
    if ListView1.Selected.Caption = '�������� ��������� ������� (T3)' then
    begin
      if Assigned(E.T3) then
        E.T3.ShowEditor(Monitor.MonitorNum);
    end;
  end;
end;

end.

