unit VirtSIEditUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, EntityUnit, VirtualUnit, Menus;

type
  TVirtSIEditForm = class(TBaseEditForm)
    ListView1: TListView;
    PopupMenu1: TPopupMenu;
    procedure ListView1DblClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
  private
    E: TVirtSysInfo;
    procedure ConnectBaseEditor(var Mess: TMessage); message WM_ConnectBaseEditor;
    procedure BaseFresh(var Mess: TMessage); message WM_Fresh;
    procedure ConnectEntity(Entity: TEntity);
    procedure ConnectImageList(ImageList: TImageList);
    procedure UpdateRealTime;
    procedure ChangeTextClick(Sender: TObject);
    procedure ChangeFetchClick(Sender: TObject);
    procedure ChangeBooleanClick(Sender: TObject);
    procedure ChangePVFormatClick(Sender: TObject);
    procedure ChangeFloatClick(Sender: TObject);
    procedure ChangeAlmDBClick(Sender: TObject);
    procedure ChangeSysInfoKindClick(Sender: TObject);
    procedure ChangeSizeKoeffClick(Sender: TObject);
  public
  end;

var
  VirtSIEditForm: TVirtSIEditForm;

implementation

uses StrUtils, GetPtNameUnit, Math;

{$R *.dfm}

{ TVirtSIEditForm }

procedure TVirtSIEditForm.BaseFresh(var Mess: TMessage);
begin
  UpdateRealTime;
end;

procedure TVirtSIEditForm.ConnectBaseEditor(var Mess: TMessage);
begin
  ConnectImageList(TImageList(Mess.WParam));
  ConnectEntity(TEntity(Mess.LParam));
end;

procedure TVirtSIEditForm.ConnectEntity(Entity: TEntity);
var sFormat: string;
begin
  E:=Entity as TVirtSysInfo;
  with ListView1 do
  begin
    Items.BeginUpdate;
    try
      Items.Clear;
      with Items.Add do
      begin
        ImageIndex:=EntityClassIndex(E.ClassType)+3;
        Caption:='���� �������';
        SubItems.Add(E.PtName+' - '+E.EntityType);
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='���������� �������';
        SubItems.Add(E.PtDesc);
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='�����';
        SubItems.Add(IfThen(E.Actived,'��','���'));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='����� ������';
        SubItems.Add(Format('%d ���',[E.FetchTime]));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='����������';
        if E.RealTime > 0 then
          SubItems.Add(Format('%.3f',[E.RealTime/1000])+' ���')
        else
          SubItems.Add('��� ������');
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
        Caption:='��� ����������';
        SubItems.Add(ASysInfoKind[E.Kind]);
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='���������';
        SubItems.Add(ASizeKoeff[E.Koeff]);
      end;
//=========================================================================
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
    finally
      Items.EndUpdate;
    end;
  end;
end;

procedure TVirtSIEditForm.ConnectImageList(ImageList: TImageList);
begin
  ListView1.SmallImages:=ImageList;
end;

procedure TVirtSIEditForm.ListView1DblClick(Sender: TObject);
begin
  if (ListView1.Selected <> nil) and
     (ListView1.Selected.Caption = '�������� ������') then
  begin
    if Assigned(E.SourceEntity) then
      E.SourceEntity.ShowEditor(Monitor.MonitorNum);
  end;
end;

procedure TVirtSIEditForm.UpdateRealTime;
var L: TListItem;
begin
  if Caddy.UserLevel > 4 then
    ListView1.PopupMenu:=PopupMenu1
  else
    ListView1.PopupMenu:=nil;
//---------------------------------------------------------
  L:=ListView1.FindCaption(0,'����������',False,True,False);
  if L <> nil then
  begin
    if E.RealTime > 0 then
      L.SubItems[0]:=Format('%.3f',[E.RealTime/1000])+' ���'
    else
      L.SubItems[0]:='��� ������';
  end;
end;

procedure TVirtSIEditForm.PopupMenu1Popup(Sender: TObject);
var L: TListItem; M: TMenuItem; i: integer; k: TAlarmDeadband;
    t: TSysInfoKind; h: TSizeKoeff;
begin
  L:=ListView1.Selected;
  with PopupMenu1 do
  begin
    Items.Clear;
    if L <> nil then
    case L.Index of
      0: begin
           M:=TMenuItem.Create(Self);
           M.Caption:='�������� ��� �����...';
           M.OnClick:=ChangePtNameClick;
           Items.Add(M);
           M:=TMenuItem.Create(Self);
           M.Caption:='-';
           Items.Add(M);
           M:=TMenuItem.Create(Self);
           M.Caption:='����������� �����...';
           M.OnClick:=DoubleEntityClick;
           Items.Add(M);
           M:=TMenuItem.Create(Self);
           M.Caption:='������� �����';
           M.OnClick:=DeleteEntityClick;
           Items.Add(M);
         end;
    1,10: begin
           M:=TMenuItem.Create(Self);
           M.Caption:='�������� �����...';
           M.OnClick:=ChangeTextClick;
           Items.Add(M);
         end;
      3: begin
           M:=TMenuItem.Create(Self);
           M.Caption:='�������� ����� ������...';
           M.OnClick:=ChangeFetchClick; M.Tag:=0; Items.Add(M);
           //---
           M:=TMenuItem.Create(Self); M.Caption:='-'; Items.Add(M);
           //---
           M:=TMenuItem.Create(Self); M.Caption:='1 ���';
           M.Checked:=(E.FetchTime=1);
           M.Tag:=1; M.OnClick:=ChangeFetchClick; Items.Add(M);
           //---
           M:=TMenuItem.Create(Self); M.Caption:='2 ���';
           M.Checked:=(E.FetchTime=2);
           M.Tag:=2; M.OnClick:=ChangeFetchClick; Items.Add(M);
           //---
           M:=TMenuItem.Create(Self); M.Caption:='3 ���';
           M.Checked:=(E.FetchTime=3);
           M.Tag:=3; M.OnClick:=ChangeFetchClick; Items.Add(M);
           //---
           M:=TMenuItem.Create(Self); M.Caption:='5 ���';
           M.Checked:=(E.FetchTime=5);
           M.Tag:=5; M.OnClick:=ChangeFetchClick; Items.Add(M);
           //---
           M:=TMenuItem.Create(Self); M.Caption:='-'; Items.Add(M);
           //---
           M:=TMenuItem.Create(Self); M.Caption:='10 ���';
           M.Checked:=(E.FetchTime=10);
           M.Tag:=10; M.OnClick:=ChangeFetchClick; Items.Add(M);
           //---
           M:=TMenuItem.Create(Self); M.Caption:='20 ���';
           M.Checked:=(E.FetchTime=20);
           M.Tag:=20; M.OnClick:=ChangeFetchClick; Items.Add(M);
           //---
           M:=TMenuItem.Create(Self); M.Caption:='30 ���';
           M.Checked:=(E.FetchTime=30);
           M.Tag:=30; M.OnClick:=ChangeFetchClick; Items.Add(M);
           //---
           M:=TMenuItem.Create(Self); M.Caption:='-'; Items.Add(M);
           //---
           M:=TMenuItem.Create(Self); M.Caption:='1 ���';
           M.Checked:=(E.FetchTime=60);
           M.Tag:=60; M.OnClick:=ChangeFetchClick; Items.Add(M);
           //---
           M:=TMenuItem.Create(Self); M.Caption:='2 ���';
           M.Checked:=(E.FetchTime=120);
           M.Tag:=60*2; M.OnClick:=ChangeFetchClick; Items.Add(M);
           //---
           M:=TMenuItem.Create(Self); M.Caption:='5 ���';
           M.Checked:=(E.FetchTime=300);
           M.Tag:=60*5; M.OnClick:=ChangeFetchClick; Items.Add(M);
         end;
2,5,6,7: begin
           M:=TMenuItem.Create(Self);
           M.Caption:='���';
           case L.Index of
             2: M.Checked:=not E.Actived;
             5: M.Checked:=not E.Logged;
             6: M.Checked:=not E.Asked;
             7: M.Checked:=not E.Trend;
           end;
           M.Tag:=0;
           M.OnClick:=ChangeBooleanClick;
           Items.Add(M);
           M:=TMenuItem.Create(Self);
           M.Caption:='��';
           case L.Index of
             2: M.Checked:=E.Actived;
             5: M.Checked:=E.Logged;
             6: M.Checked:=E.Asked;
             7: M.Checked:=E.Trend;
           end;
           M.Tag:=1;
           M.OnClick:=ChangeBooleanClick;
           Items.Add(M);
         end;
      8: for t:=Low(ASysInfoKind) to High(ASysInfoKind) do
         begin
           M:=TMenuItem.Create(Self);
           M.Caption:=ASysInfoKind[t];
           M.Tag:=Ord(t);
           M.OnClick:=ChangeSysInfoKindClick;
           M.Checked:=(E.Kind = t);
           Items.Add(M);
         end;
      9: for h:=Low(ASizeKoeff) to High(ASizeKoeff) do
         begin
           M:=TMenuItem.Create(Self);
           M.Caption:=ASizeKoeff[h];
           M.Tag:=Ord(h);
           M.OnClick:=ChangeSizeKoeffClick;
           M.Checked:=(E.Koeff = h);
           Items.Add(M);
         end;
     11: for i:=0 to 3 do
         begin
           M:=TMenuItem.Create(Self);
           M.Caption:='D'+IntToStr(i);
           M.Tag:=i;
           M.OnClick:=ChangePVFormatClick;
           M.Checked:=(Ord(E.PVFormat) = i);
           Items.Add(M);
         end;
 13..16: begin
           M:=TMenuItem.Create(Self);
           M.Caption:='�������� ��������...';
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
              13: M.Checked:=(E.HHDB = k);
              14: M.Checked:=(E.HiDB = k);
              15: M.Checked:=(E.LoDB = k);
              16: M.Checked:=(E.LLDB = k);
             end;
             Items.Add(M);
           end;
         end;
    end;
  end;
end;

procedure TVirtSIEditForm.ChangeTextClick(Sender: TObject);
var L: TListItem; S: string;
begin
  L:=ListView1.Selected;
  if L <> nil then
  begin
    S:=L.SubItems[0];
    if InputStringDlg(L.Caption,S,IfThen(L.Index=1,50,10)) then
    case L.Index of
      1: begin E.PtDesc:=S; L.SubItems[0]:=E.PtDesc; end;
     10: begin E.EUDesc:=S; L.SubItems[0]:=E.EUDesc; end;
    end;
  end;
end;

procedure TVirtSIEditForm.ChangeFetchClick(Sender: TObject);
var L: TListItem; V: integer; M: TMenuItem;
begin
  M:=Sender as TMenuItem;
  L:=ListView1.Selected;
  if L <> nil then
  begin
    case M.Tag of
      0: begin
           V:=E.FetchTime;
           if InputIntegerDlg(L.Caption+' (� ���.)',V) then
           begin
             if V < 1 then V:=1;
             E.FetchTime:=V;
             L.SubItems[0]:=Format('%d ���',[E.FetchTime]);
           end;
         end;
    else
      begin
        E.FetchTime:=M.Tag;
        L.SubItems[0]:=Format('%d ���',[E.FetchTime]);
      end;
    end;
  end;
end;

procedure TVirtSIEditForm.ChangeBooleanClick(Sender: TObject);
var L: TListItem; M: TMenuItem; B: Boolean;
begin
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  B:=(M.Tag = 1);
  if L <> nil then
    case L.Index of
       2: begin E.Actived:=B; L.SubItems[0]:=IfThen(E.Actived,'��','���'); end;
       5: begin E.Logged:=B; L.SubItems[0]:=IfThen(E.Logged,'��','���'); end;
       6: begin E.Asked:=B; L.SubItems[0]:=IfThen(E.Asked,'��','���'); end;
       7: begin E.Trend:=B; L.SubItems[0]:=IfThen(E.Trend,'��','���'); end;
    end;
end;

procedure TVirtSIEditForm.ChangePVFormatClick(Sender: TObject);
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
      Items[12].SubItems[0]:=Format(sFormat,[E.PVEUHi]);
      Items[13].SubItems[0]:=Format(sFormat,[E.PVHHTP])+' '+AAlmDB[E.HHDB];
      Items[14].SubItems[0]:=Format(sFormat,[E.PVHiTP])+' '+AAlmDB[E.HIDB];
      Items[15].SubItems[0]:=Format(sFormat,[E.PVLoTP])+' '+AAlmDB[E.LODB];
      Items[16].SubItems[0]:=Format(sFormat,[E.PVLLTP])+' '+AAlmDB[E.LLDB];
      Items[17].SubItems[0]:=Format(sFormat,[E.PVEULo]);
    end;
  end;
end;

procedure TVirtSIEditForm.ChangeFloatClick(Sender: TObject);
var L: TListItem; sFormat: string; V: Single;
begin
  L:=ListView1.Selected;
  if L <> nil then
  begin
    case L.Index of
     13: V:=E.PVHHTP;
     14: V:=E.PVHiTP;
     15: V:=E.PVLoTP;
     16: V:=E.PVLLTP;
    end;
    sFormat:='%.'+Format('%d',[Ord(E.PVFormat)])+'f';
    if InputFloatDlg(L.Caption,sFormat,V) then
    case L.Index of
     13: if InRange(V,E.PVHiTP,E.PVEUHi) then
         begin
           E.PVHHTP:=V;
           L.SubItems[0]:=Format(sFormat,[E.PVHHTP])+' '+AAlmDB[E.HHDB];
         end
         else
           raise ERangeError.Create('�������� ��� ���������� ������!');
     14: if InRange(V,E.PVLoTP,E.PVHHTP) then
         begin
           E.PVHiTP:=V;
           L.SubItems[0]:=Format(sFormat,[E.PVHiTP])+' '+AAlmDB[E.HiDB];
         end
         else
           raise ERangeError.Create('�������� ��� ���������� ������!');
     15: if InRange(V,E.PVLLTP,E.PVHiTP) then
         begin
           E.PVLoTP:=V;
           L.SubItems[0]:=Format(sFormat,[E.PVLoTP])+' '+AAlmDB[E.LoDB];
         end
         else
           raise ERangeError.Create('�������� ��� ���������� ������!');
     16: if InRange(V,E.PVEULo,E.PVLoTP) then
         begin
           E.PVLLTP:=V;
           L.SubItems[0]:=Format(sFormat,[E.PVLLTP])+' '+AAlmDB[E.LLDB];
         end
         else
           raise ERangeError.Create('�������� ��� ���������� ������!');
    end;
  end;
end;

procedure TVirtSIEditForm.ChangeAlmDBClick(Sender: TObject);
var L: TListItem; M: TMenuItem; sFormat: string;
begin
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  if L <> nil then
  begin
    sFormat:='%.'+Format('%d',[Ord(E.PVFormat)])+'f';
    with ListView1 do
    case L.Index of
     13: begin
           E.HHDB:=TAlarmDeadband(M.Tag);
           Items[13].SubItems[0]:=Format(sFormat,[E.PVHHTP])+' '+AAlmDB[E.HHDB];
         end;
     14: begin
           E.HIDB:=TAlarmDeadband(M.Tag);
           Items[14].SubItems[0]:=Format(sFormat,[E.PVHiTP])+' '+AAlmDB[E.HIDB];
         end;
     15: begin
           E.LODB:=TAlarmDeadband(M.Tag);
           Items[15].SubItems[0]:=Format(sFormat,[E.PVLoTP])+' '+AAlmDB[E.LODB];
         end;
     16: begin
           E.LLDB:=TAlarmDeadband(M.Tag);
           Items[16].SubItems[0]:=Format(sFormat,[E.PVLLTP])+' '+AAlmDB[E.LLDB];
         end;
    end;
  end;
end;

procedure TVirtSIEditForm.ChangeSysInfoKindClick(Sender: TObject);
var L: TListItem; M: TMenuItem;
begin
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  if L <> nil then
  begin
    E.Kind:=TSysInfoKind(M.Tag);
    L.SubItems[0]:=ASysInfoKind[E.Kind];
  end;
end;

procedure TVirtSIEditForm.ChangeSizeKoeffClick(Sender: TObject);
var L: TListItem; M: TMenuItem;
begin
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  if L <> nil then
  begin
    E.Koeff:=TSizeKoeff(M.Tag);
    L.SubItems[0]:=ASizeKoeff[E.Koeff];
//--------------------------------------
    case E.Koeff of
  skByte:   if E.EUDesc = '����'  then E.EUDesc:='����';
  skKByte:  if E.EUDesc = '�����' then E.EUDesc:='�����';
  skMByte: if E.EUDesc = '�����' then E.EUDesc:='�����';
    end;
    ListView1.Items[10].SubItems[0]:=E.EUDesc;
  end;
end;

end.
