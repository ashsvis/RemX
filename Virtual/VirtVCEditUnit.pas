unit VirtVCEditUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, EntityUnit, VirtualUnit, ExtCtrls, Menus,
  ImgList;

type
  TVirtVCEditForm = class(TBaseEditForm)
    ListView1: TListView;
    PopupMenu1: TPopupMenu;
    ImageList1: TImageList;
    procedure ListView1DblClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
  private
    E: TVirtValve;
    procedure ConnectBaseEditor(var Mess: TMessage); message WM_ConnectBaseEditor;
    procedure BaseFresh(var Mess: TMessage); message WM_Fresh;
    procedure ConnectEntity(Entity: TEntity);
    procedure ConnectImageList(ImageList: TImageList);
    procedure UpdateRealTime;
    procedure ChangeBooleanClick(Sender: TObject);
    procedure ChangeTextClick(Sender: TObject);
    procedure ChangeFetchClick(Sender: TObject);
    procedure ChangeLinkClick(Sender: TObject);
    procedure DeleteLinkClick(Sender: TObject);
  public
  end;

var
  VirtVCEditForm: TVirtVCEditForm;

implementation

uses StrUtils, GetPtNameUnit, GetLinkNameUnit, RemXUnit, Math;

{$R *.dfm}

{ TVirtVCForm }

procedure TVirtVCEditForm.BaseFresh(var Mess: TMessage);
begin
  UpdateRealTime;
end;

procedure TVirtVCEditForm.ConnectBaseEditor(var Mess: TMessage);
begin
  ConnectImageList(TImageList(Mess.WParam));
  ConnectEntity(TEntity(Mess.LParam));
end;

procedure TVirtVCEditForm.ConnectEntity(Entity: TEntity);
begin
  E:=Entity as TVirtValve;
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
//=========================================================================
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='��������� "������"';
        if not Assigned(E.StatALM) then
          SubItems.Add('------')
        else
        begin
          SubItems.Add(E.StatALM.PtName+' - '+E.StatALM.PtDesc);
          SubItemImages[0]:=EntityClassIndex(E.StatALM.ClassType)+3;
        end;
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='��������� "�������"';
        if not Assigned(E.StatON) then
          SubItems.Add('------')
        else
        begin
          SubItems.Add(E.StatON.PtName+' - '+E.StatON.PtDesc);
          SubItemImages[0]:=EntityClassIndex(E.StatON.ClassType)+3;
        end;
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='��������� "�������"';
        if not Assigned(E.StatOFF) then
          SubItems.Add('------')
        else
        begin
          SubItems.Add(E.StatOFF.PtName+' - '+E.StatOFF.PtDesc);
          SubItemImages[0]:=EntityClassIndex(E.StatOFF.ClassType)+3;
        end;
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='������� "�������"';
        if not Assigned(E.CommON) then
          SubItems.Add('------')
        else
        begin
          SubItems.Add(E.CommON.PtName+' - '+E.CommON.PtDesc);
          SubItemImages[0]:=EntityClassIndex(E.CommON.ClassType)+3;
        end;
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='������� "�������"';
        if not Assigned(E.CommOFF) then
          SubItems.Add('------')
        else
        begin
          SubItems.Add(E.CommOFF.PtName+' - '+E.CommOFF.PtDesc);
          SubItemImages[0]:=EntityClassIndex(E.CommOFF.ClassType)+3;
        end;
      end;
    finally
      Items.EndUpdate;
    end;
  end;
end;

procedure TVirtVCEditForm.ConnectImageList(ImageList: TImageList);
begin
  ListView1.SmallImages:=ImageList;
end;

procedure TVirtVCEditForm.ListView1DblClick(Sender: TObject);
begin
  if ListView1.Selected <> nil then
  begin
    if ListView1.Selected.Caption = '�������� ������' then
    begin
      if Assigned(E.SourceEntity) then
        E.SourceEntity.ShowEditor(Monitor.MonitorNum);
    end;
    if ListView1.Selected.Caption = '��������� "������"' then
    begin
      if Assigned(E.StatALM) then
        E.StatALM.ShowEditor(Monitor.MonitorNum);
    end;
    if ListView1.Selected.Caption = '��������� "�������"' then
    begin
      if Assigned(E.StatON) then
        E.StatON.ShowEditor(Monitor.MonitorNum);
    end;
    if ListView1.Selected.Caption = '��������� "�������"' then
    begin
      if Assigned(E.StatOFF) then
        E.StatOFF.ShowEditor(Monitor.MonitorNum);
    end;
    if ListView1.Selected.Caption = '������� "�������"' then
    begin
      if Assigned(E.CommON) then
        E.CommON.ShowEditor(Monitor.MonitorNum);
    end;
    if ListView1.Selected.Caption = '������� "�������"' then
    begin
      if Assigned(E.CommOFF) then
        E.CommOFF.ShowEditor(Monitor.MonitorNum);
    end;
  end;
end;

procedure TVirtVCEditForm.UpdateRealTime;
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

procedure TVirtVCEditForm.PopupMenu1Popup(Sender: TObject);
var L: TListItem; M: TMenuItem;
begin
  L:=ListView1.Selected;
  with PopupMenu1 do
  begin
    Images:=nil;
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
      1: begin
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
  2,5,6: begin
           M:=TMenuItem.Create(Self);
           M.Caption:='���';
           case L.Index of
             2: M.Checked:=not E.Actived;
             5: M.Checked:=not E.Logged;
             6: M.Checked:=not E.Asked;
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
           end;
           M.Tag:=1;
           M.OnClick:=ChangeBooleanClick;
           Items.Add(M);
         end;
  7..11: begin
           M:=TMenuItem.Create(Self);
           M.Caption:='�������� �����...';
           M.Tag:=L.Index;
           M.OnClick:=ChangeLinkClick;
           Items.Add(M);
           M:=TMenuItem.Create(Self);
           M.Caption:='������� �����';
           M.Tag:=L.Index;
           M.OnClick:=DeleteLinkClick;
           case L.Index of
              7: M.Enabled:=Assigned(E.StatALM);
              8: M.Enabled:=Assigned(E.StatON);
              9: M.Enabled:=Assigned(E.StatOFF);
             10: M.Enabled:=Assigned(E.CommON);
             11: M.Enabled:=Assigned(E.CommOFF);
           end;
           Items.Add(M);
         end;
    end;
  end;
end;

procedure TVirtVCEditForm.ChangeBooleanClick(Sender: TObject);
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
    end;
end;

procedure TVirtVCEditForm.ChangeTextClick(Sender: TObject);
var L: TListItem; S: string;
begin
  L:=ListView1.Selected;
  if L <> nil then
  begin
    S:=L.SubItems[0];
    if InputStringDlg(L.Caption,S,50) then
    begin
      E.PtDesc:=S;
      L.SubItems[0]:=E.PtDesc;
    end;
  end;
end;

procedure TVirtVCEditForm.ChangeFetchClick(Sender: TObject);
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

procedure TVirtVCEditForm.ChangeLinkClick(Sender: TObject);
var List: TList; T,R: TEntity; L: TListItem;
begin
  L:=ListView1.Selected;
  List:=TList.Create;
  try
    case L.Index of
     7: T:=E.StatALM;
     8: T:=E.StatON;
     9: T:=E.StatOFF;
    10: T:=E.CommON;
    11: T:=E.CommOFF;
    end;
    R:=Caddy.FirstEntity;
    while R <> nil do
    begin
      if L.Index in [7..9] then
      begin
        if R.IsDigit and not R.IsParam then
          List.Add(R)
      end
      else
      begin
        if R.IsDigit and (R.IsParam or R.IsVirtual) then
          List.Add(R);
      end;
      R:=R.NextEntity;
    end;
    if GetLinkNameDlg(Self,L.Caption,List,TImageList(ListView1.SmallImages),T) then
    begin
      case L.Index of
        7: begin
             if not Assigned(T) then
             begin
               L.SubItems[0]:='------';
               L.SubItemImages[0]:=-1;
             end
             else
             begin
               E.StatALM:=T as TCustomDigOut;
               L.SubItems[0]:=E.StatALM.PtName+' - '+E.StatALM.PtDesc;
               L.SubItemImages[0]:=EntityClassIndex(E.StatALM.ClassType)+3;
             end;
           end;
        8: begin
             if not Assigned(T) then
             begin
               L.SubItems[0]:='------';
               L.SubItemImages[0]:=-1;
             end
             else
             begin
               E.StatON:=T as TCustomDigOut;
               L.SubItems[0]:=E.StatON.PtName+' - '+E.StatON.PtDesc;
               L.SubItemImages[0]:=EntityClassIndex(E.StatON.ClassType)+3;
             end;
           end;
        9: begin
             if not Assigned(T) then
             begin
               L.SubItems[0]:='------';
               L.SubItemImages[0]:=-1;
             end
             else
             begin
               E.StatOFF:=T as TCustomDigOut;
               L.SubItems[0]:=E.StatOFF.PtName+' - '+E.StatOFF.PtDesc;
               L.SubItemImages[0]:=EntityClassIndex(E.StatOFF.ClassType)+3;
             end;
           end;
       10: begin
             if not Assigned(T) then
             begin
               L.SubItems[0]:='------';
               L.SubItemImages[0]:=-1;
             end
             else
             begin
               E.CommON:=T;
               L.SubItems[0]:=E.CommON.PtName+' - '+E.CommON.PtDesc;
               L.SubItemImages[0]:=EntityClassIndex(E.CommON.ClassType)+3;
             end;
           end;
       11: begin
             if not Assigned(T) then
             begin
               L.SubItems[0]:='------';
               L.SubItemImages[0]:=-1;
             end
             else
             begin
               E.CommOFF:=T;
               L.SubItems[0]:=E.CommOFF.PtName+' - '+E.CommOFF.PtDesc;
               L.SubItemImages[0]:=EntityClassIndex(E.CommOFF.ClassType)+3;
             end;
           end;
      end;
    end;
  finally
    List.Free;
  end;
end;

procedure TVirtVCEditForm.DeleteLinkClick(Sender: TObject);
var T: TEntity; L: TListItem;
begin
  L:=ListView1.Selected;
  case L.Index of
    7: T:=E.StatALM;
    8: T:=E.StatON;
    9: T:=E.StatOFF;
   10: T:=E.CommON;
   11: T:=E.CommOFF;
  else
    T:=nil;
  end;
  if (T <> nil) and
     (RemxForm.ShowQuestion('������� ����� "'+T.PtName+'"?')=mrOK) then
  begin
    case L.Index of
      7: begin E.StatALM:=nil; L.SubItems[0]:='------'; L.SubItemImages[0]:=-1; end;
      8: begin E.StatON:=nil; L.SubItems[0]:='------'; L.SubItemImages[0]:=-1; end;
      9: begin E.StatOFF:=nil; L.SubItems[0]:='------'; L.SubItemImages[0]:=-1; end;
     10: begin E.CommON:=nil; L.SubItems[0]:='------'; L.SubItemImages[0]:=-1; end;
     11: begin E.CommOFF:=nil; L.SubItems[0]:='------'; L.SubItemImages[0]:=-1; end;
    end;
  end;
end;

end.
