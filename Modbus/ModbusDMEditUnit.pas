unit ModbusDMEditUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, EntityUnit, ModbusUnit, ExtCtrls, Menus;

type
  TModbusDMEditForm = class(TBaseEditForm)
    ListView1: TListView;
    ListView2: TListView;
    Splitter1: TSplitter;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    procedure ListView2DblClick(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PopupMenu2Popup(Sender: TObject);
  private
    E: TModbusDMGroup;
    procedure ConnectBaseEditor(var Mess: TMessage); message WM_ConnectBaseEditor;
    procedure BaseFresh(var Mess: TMessage); message WM_Fresh;
    procedure ConnectEntity(Entity: TEntity);
    procedure ConnectImageList(ImageList: TImageList);
    procedure UpdateRealTime;
    procedure ChangeTextClick(Sender: TObject);
    procedure ChangeFetchClick(Sender: TObject);
    procedure ChangeBooleanClick(Sender: TObject);
    procedure ChangeLinkClick(Sender: TObject);
    procedure DeleteLinkClick(Sender: TObject);
    procedure ChangeIntegerClick(Sender: TObject);
    procedure ChangeAddrPrefixClick(Sender: TObject);
  public
  end;

var
  ModbusDMEditForm: TModbusDMEditForm;

implementation

uses StrUtils, Math, GetPtNameUnit, GetLinkNameUnit, RemXUnit;

{$R *.dfm}

{ TVirtVDEditForm }

procedure TModbusDMEditForm.BaseFresh(var Mess: TMessage);
begin
  UpdateRealTime;
end;

procedure TModbusDMEditForm.ConnectBaseEditor(var Mess: TMessage);
begin
  ConnectImageList(TImageList(Mess.WParam));
  ConnectEntity(TEntity(Mess.LParam));
end;

procedure TModbusDMEditForm.ConnectEntity(Entity: TEntity);
var i: integer;
begin
  E:=Entity as TModbusDMGroup;
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
        Caption:='����� �����';
        SubItems.Add(IntToStr(E.Channel));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='����������';
        SubItems.Add(IntToStr(E.Node));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='����� ������';
        SubItems.Add(IntToStr(E.Address));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='������� ������';
        SubItems.Add(ADigAddrPrefix[E.AddrPrefix]);
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='���������� ���';
        SubItems.Add(IntToStr(E.Count));
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
    finally
      Items.EndUpdate;
    end;
  end;
//=========================================================================
  with ListView2 do
  begin
    Items.BeginUpdate;
    try
      Items.Clear;
      for i:=0 to E.Childs.Count-1 do
      begin
        with Items.Add do
        begin
          if E.EntityChilds[i] <> nil then
          begin
            Data:=E.EntityChilds[i];
            ImageIndex:=EntityClassIndex(E.EntityChilds[i].ClassType)+3;
            Caption:=Format('%d. %s',[i+1,E.EntityChilds[i].PtName]);
            SubItems.Add(E.EntityChilds[i].PtDesc);
          end
          else
          begin
            Data:=nil;
            ImageIndex:=-1;
            Caption:=Format('%d. ------',[i+1]);
            SubItems.Add('------');
          end;
        end;
      end;
    finally
      Items.EndUpdate;
    end;
  end;
end;

procedure TModbusDMEditForm.ConnectImageList(ImageList: TImageList);
begin
  ListView1.SmallImages:=ImageList;
  ListView2.SmallImages:=ImageList;
end;

procedure TModbusDMEditForm.ListView2DblClick(Sender: TObject);
var E: TEntity;
begin
  if ListView2.Selected <> nil then
  begin
    E:=TEntity(ListView2.Selected.Data);
    if Assigned(E) then
      E.ShowEditor(Monitor.MonitorNum);
  end;
end;

procedure TModbusDMEditForm.ListView1DblClick(Sender: TObject);
begin
  if (ListView1.Selected <> nil) and
     (ListView1.Selected.Caption = '�������� ������') then
  begin
    if Assigned(E.SourceEntity) then
      E.SourceEntity.ShowEditor(Monitor.MonitorNum);
  end;
end;

procedure TModbusDMEditForm.UpdateRealTime;
var L: TListItem;
begin
  if Caddy.UserLevel > 4 then
  begin
    ListView1.PopupMenu:=PopupMenu1;
    ListView2.PopupMenu:=PopupMenu2;
  end
  else
  begin
    ListView1.PopupMenu:=nil;
    ListView2.PopupMenu:=nil;
  end;  
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

procedure TModbusDMEditForm.PopupMenu1Popup(Sender: TObject);
var L: TListItem; M: TMenuItem; u: TAddrPrefix;
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
 1..3,5: begin
           M:=TMenuItem.Create(Self);
           M.Caption:='�������� �����...';
           M.OnClick:=ChangeIntegerClick;
           Items.Add(M);
         end;
      4: for u:=Low(ADigAddrPrefix) to High(ADigAddrPrefix) do
         begin
           M:=TMenuItem.Create(Self);
           M.Caption:=ADigAddrPrefix[u];
           M.Tag:=Ord(u);
           M.OnClick:=ChangeAddrPrefixClick;
           M.Checked:=(E.AddrPrefix = u);
           Items.Add(M);
         end;
      6: begin
           M:=TMenuItem.Create(Self);
           M.Caption:='�������� �����...';
           M.OnClick:=ChangeTextClick;
           Items.Add(M);
         end;
      7: begin
           M:=TMenuItem.Create(Self);
           M.Caption:='���';
           case L.Index of
             7: M.Checked:=not E.Actived;
           end;
           M.Tag:=0;
           M.OnClick:=ChangeBooleanClick;
           Items.Add(M);
           M:=TMenuItem.Create(Self);
           M.Caption:='��';
           case L.Index of
             7: M.Checked:=E.Actived;
           end;
           M.Tag:=1;
           M.OnClick:=ChangeBooleanClick;
           Items.Add(M);
         end;
      8: begin
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
    end;
  end;
end;

procedure TModbusDMEditForm.ChangeTextClick(Sender: TObject);
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

procedure TModbusDMEditForm.ChangeFetchClick(Sender: TObject);
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

procedure TModbusDMEditForm.ChangeBooleanClick(Sender: TObject);
var L: TListItem; M: TMenuItem; B: Boolean; i: integer; Found: boolean;
begin
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  B:=(M.Tag = 1);
  if L <> nil then
    case L.Index of
      7: begin
           Found:=False;
           for i:=0 to E.Count-1 do
           if Assigned(E.EntityChilds[i]) then
           begin
             Found:=True;
             Break;
           end;
           if B and Found or not B then
           begin
             E.Actived:=B;
             L.SubItems[0]:=IfThen(E.Actived,'��','���');
           end
           else
             RemxForm.ShowError('������ ������ "'+E.PtName+'" �����.'#13+
                   '������ ������� �� ����� ������ ������!');
         end;
    end;
end;

procedure TModbusDMEditForm.PopupMenu2Popup(Sender: TObject);
var L: TListItem; M: TMenuItem; i: integer;
begin
  L:=ListView2.Selected;
  with PopupMenu2 do
  begin
    Items.Clear;
    if L <> nil then
    begin
      if ListView2.SelCount = 1 then
      begin
        M:=TMenuItem.Create(Self);
        M.Caption:='�������� �����...';
        M.Tag:=L.Index;
        M.OnClick:=ChangeLinkClick;
        Items.Add(M);
      end
      else
      begin
        for i:=0 to ListView2.Items.Count-1 do
        if ListView2.Items[i].Selected and not Assigned(E.EntityChilds[i]) then
        begin
          ListView2.Items[i].Selected:=False;
          ListView2.Items[i].Data:=nil;
        end;
      end;
      M:=TMenuItem.Create(Self);
      if ListView2.SelCount = 1 then
        M.Caption:='������� �����'
      else
        M.Caption:='������� ��������� �����';
      M.Tag:=L.Index;
      M.OnClick:=DeleteLinkClick;
      M.Enabled:=(L.Data <> nil);
      Items.Add(M);
    end;
  end;
end;

procedure TModbusDMEditForm.ChangeLinkClick(Sender: TObject);
var L: TListItem; T,R: TEntity; EList,List: TList;
    S: string; i,j: integer; IsModbus: boolean;
begin
  List:=TList.Create;
  EList:=TList.Create;
  try
    L:=ListView2.Selected;
    if L <> nil then
    begin
      T:=TEntity(L.Data);
      R:=Caddy.FirstEntity;
      while R <> nil do
      begin
        IsModbus:=(R.ClassType = TModbusDigOut);
        if not Assigned(R.SourceEntity) and
           R.IsDigit and not R.IsVirtual and
          (E.Channel = R.Channel) and (E.Node = R.Node) and IsModbus
          or
           not Assigned(R.SourceEntity) and not R.IsComposit and
           R.IsDigit and not R.IsParam and R.IsVirtual
         then
          List.Add(R);
        R:=R.NextEntity;
      end;
      if GetLinkNameDlg(Self,'�������� ����� �'+IntToStr(L.Index+1),List,
                        TImageList(ListView2.SmallImages),T,EList) then
      begin
        Update;
        if EList.Count = 0 then
        begin
          if (E.EntityChilds[L.Index] <> T) and
             Assigned(E.EntityChilds[L.Index]) then
            E.EntityChilds[L.Index].SourceEntity:=nil;
          E.EntityChilds[L.Index]:=T;
          with L do
          begin
            if E.EntityChilds[L.Index] <> nil then
            begin
              Data:=E.EntityChilds[L.Index];
              ImageIndex:=EntityClassIndex(E.EntityChilds[L.Index].ClassType)+3;
              Caption:=Format('%d. %s',[L.Index+1,E.EntityChilds[L.Index].PtName]);
              SubItems[0]:=E.EntityChilds[L.Index].PtDesc;
            end
            else
            begin
              Data:=nil;
              ImageIndex:=-1;
              Caption:=Format('%d. ------',[L.Index+1]);
              SubItems[0]:='------';
            end;
            S:=Caption;
          end;
        end
        else
        begin
          j:=L.Index;
          for i:=0 to EList.Count-1 do
          begin
            if j <= E.GetMaxChildCount then
            begin
              if (E.EntityChilds[j] <> TEntity(EList[i])) and
                 Assigned(E.EntityChilds[j]) then
                E.EntityChilds[j].SourceEntity:=nil;
              E.EntityChilds[j]:=TEntity(EList[i]);
            end
            else
              Break;
            Inc(j);
          end;
        end;
        UpdateBaseView(Self);
        RestoreEntityPos(E);
        ListView2.SetFocus;
        ListView2.Selected:=ListView2.FindCaption(0,S,False,True,False);
      end;
    end;
  finally
    List.Free;
    EList.Free;
  end;
end;

procedure TModbusDMEditForm.DeleteLinkClick(Sender: TObject);
var L: TListItem; T: TEntity;
    S: string; Found: boolean; i: integer;
begin
  L:=ListView2.Selected;
  if L <> nil then
  begin
    T:=E.EntityChilds[L.Index];
    if (T <> nil) and
       (RemxForm.ShowQuestion(IfThen((ListView2.SelCount = 1),
                     '������� ����� "'+T.PtName+'"?',
           '������� ��������� ����� ('+
           IntToStr(ListView2.SelCount)+' ��.)?'))=mrOK) then
    begin
      Update;
      if ListView2.SelCount = 1 then
      begin
        E.EntityChilds[L.Index]:=nil;
        with L do
        begin
          Data:=nil;
          ImageIndex:=-1;
          Caption:=Format('%d. ------',[L.Index+1]);
          SubItems[0]:='------';
          S:=Caption;
        end;
      end
      else
      begin
        for i:=0 to ListView2.Items.Count-1 do
        if ListView2.Items[i].Selected then
          E.EntityChilds[i]:=nil;
      end;
      Found:=False;
      for i:=0 to E.Count-1 do
      if Assigned(E.EntityChilds[i]) then
      begin
        Found:=True;
        Break;
      end;
      if not Found then E.Actived:=False;
      UpdateBaseView(Self);
      RestoreEntityPos(E);
      ListView2.SetFocus;
      ListView2.Selected:=ListView2.FindCaption(0,S,False,True,False);
    end;
  end;
end;

procedure TModbusDMEditForm.ChangeIntegerClick(Sender: TObject);
var L: TListItem; V: Integer;
begin
  L:=ListView1.Selected;
  if L <> nil then
  begin
    case L.Index of
     1: V:=E.Channel;
     2: V:=E.Node;
     3: V:=E.Address;
     5: V:=E.Count;
    end;
    if InputIntegerDlg(L.Caption,V) then
    begin
      case L.Index of
        1: if InRange(V,1,ChannelCount) then
           begin
             E.Channel:=V;
             L.SubItems[0]:=Format('%d',[E.Channel]);
           end
           else
             raise ERangeError.Create('�������� ��� ���������� ������!');
        2: if InRange(V,1,31) then
           begin
             E.Node:=V;
             L.SubItems[0]:=Format('%d',[E.Node]);
           end
           else
             raise ERangeError.Create('�������� ��� ���������� ������ (1..31)!');
        3: if InRange(V,1,65535) then
           begin
             E.Address:=V;
             L.SubItems[0]:=Format('%d',[E.Address]);
           end
           else
             raise ERangeError.Create('�������� ��� ���������� ������ (1..65535)!');
        5: if InRange(V,1,2000) then
           begin
             E.DataCount:=V;
             L.SubItems[0]:=Format('%d',[E.DataCount]);
           end
           else
             raise ERangeError.Create('�������� ��� ���������� ������ (1..2000)!');
      end;
      if L.Index in [1..2,5] then
      begin
        UpdateBaseView(Self);
        RestoreEntityPos(E);
      end;
    end;
  end;
end;

procedure TModbusDMEditForm.ChangeAddrPrefixClick(Sender: TObject);
var L: TListItem; M: TMenuItem;
begin
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  if L <> nil then
  begin
    with ListView1 do
    case L.Index of
     4: begin
          E.AddrPrefix:=TAddrPrefix(M.Tag);
          Items[4].SubItems[0]:=ADigAddrPrefix[E.AddrPrefix];
         end;
    end;
  end;
end;

end.
