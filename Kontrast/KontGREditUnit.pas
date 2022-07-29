unit KontGREditUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, EntityUnit, KontrastUnit, ExtCtrls, Menus, StdCtrls;

type
  TKontGREditForm = class(TBaseEditForm)
    ListView1: TListView;
    Splitter1: TSplitter;
    ListView2: TListView;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    Panel1: TPanel;
    AddToGroupButton: TButton;
    ReconfigGroupButton: TButton;
    procedure ListView2DblClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PopupMenu2Popup(Sender: TObject);
    procedure AddToGroupButtonClick(Sender: TObject);
    procedure ReconfigGroupButtonClick(Sender: TObject);
  private
    E: TKontCRGroup;
    procedure ConnectBaseEditor(var Mess: TMessage); message WM_ConnectBaseEditor;
    procedure BaseFresh(var Mess: TMessage); message WM_Fresh;
    procedure ConnectEntity(Entity: TEntity);
    procedure ConnectImageList(ImageList: TImageList);
    procedure UpdateRealTime;
    procedure ChangeIntegerClick(Sender: TObject);
    procedure ChangeTextClick(Sender: TObject);
    procedure ChangeBooleanClick(Sender: TObject);
    procedure ChangeFetchClick(Sender: TObject);
    procedure ChangeLinkClick(Sender: TObject);
    procedure DeleteLinkClick(Sender: TObject);
  public
  end;

var
  KontGREditForm: TKontGREditForm;

implementation

uses StrUtils, Math, GetPtNameUnit, GetLinkNameUnit, RemXUnit, ChoicesUnit;

{$R *.dfm}

{ TKontGREditForm }

procedure TKontGREditForm.BaseFresh(var Mess: TMessage);
begin
  UpdateRealTime;
end;

procedure TKontGREditForm.ConnectBaseEditor(var Mess: TMessage);
begin
  ConnectImageList(TImageList(Mess.WParam));
  ConnectEntity(TEntity(Mess.LParam));
end;

procedure TKontGREditForm.ConnectEntity(Entity: TEntity);
var i: integer;
begin
  E:=Entity as TKontCRGroup;
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
        if Assigned(E.EntityChilds[i]) then
        begin
          Data:=E.EntityChilds[i];
          ImageIndex:=EntityClassIndex(E.EntityChilds[i].ClassType)+3;
          Caption:=Format('%d. %s',[i+1,E.EntityChilds[i].PtName]);
          SubItems.Add(E.EntityChilds[i].PtDesc);
        end;
      end;
      AddToGroupButton.Enabled:=(E.Childs.Count < E.GetMaxChildCount);
    finally
      Items.EndUpdate;
    end;
  end;
end;

procedure TKontGREditForm.ConnectImageList(ImageList: TImageList);
begin
  ListView1.SmallImages:=ImageList;
  ListView2.SmallImages:=ImageList;
end;

procedure TKontGREditForm.ListView2DblClick(Sender: TObject);
var E: TEntity;
begin
  if ListView2.Selected <> nil then
  begin
    E:=TEntity(ListView2.Selected.Data);
    if Assigned(E) then
      E.ShowEditor(Monitor.MonitorNum);
  end;
end;

procedure TKontGREditForm.UpdateRealTime;
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

procedure TKontGREditForm.PopupMenu1Popup(Sender: TObject);
var L: TListItem; M: TMenuItem;
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
   1,2: begin
           M:=TMenuItem.Create(Self);
           M.Caption:='�������� �����...';
           M.OnClick:=ChangeIntegerClick;
           Items.Add(M);
         end;
      3: begin
           M:=TMenuItem.Create(Self);
           M.Caption:='�������� �����...';
           M.OnClick:=ChangeTextClick;
           Items.Add(M);
         end;
      4: begin
           M:=TMenuItem.Create(Self);
           M.Caption:='���';
           case L.Index of
             4: M.Checked:=not E.Actived;
           end;
           M.Tag:=0;
           M.OnClick:=ChangeBooleanClick;
           Items.Add(M);
           M:=TMenuItem.Create(Self);
           M.Caption:='��';
           case L.Index of
             4: M.Checked:=E.Actived;
           end;
           M.Tag:=1;
           M.OnClick:=ChangeBooleanClick;
           Items.Add(M);
         end;
      5: begin
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

procedure TKontGREditForm.PopupMenu2Popup(Sender: TObject);
var L: TListItem; M: TMenuItem; i: integer;
begin
  L:=ListView2.Selected;
  with PopupMenu2 do
  begin
    Items.Clear;
    if L <> nil then
    begin
      if AddToGroupButton.Enabled then
      begin
        M:=TMenuItem.Create(Self);
        M.Caption:='�������� ����� � ������...';
        M.OnClick:=AddToGroupButtonClick;
        Items.Add(M);
        M:=TMenuItem.Create(Self);
        M.Caption:='-';
        Items.Add(M);
      end;
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
    end
    else
    if AddToGroupButton.Enabled then
    begin
      M:=TMenuItem.Create(Self);
      M.Caption:='�������� ����� � ������...';
      M.OnClick:=AddToGroupButtonClick;
      Items.Add(M);
    end;
  end;
end;

procedure TKontGREditForm.ChangeIntegerClick(Sender: TObject);
var L: TListItem; V: Integer;
begin
  L:=ListView1.Selected;
  if L <> nil then
  begin
    case L.Index of
     1: V:=E.Channel;
     2: V:=E.Node;
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
             raise ERangeError.Create('�������� ��� ���������� ������!');
      end;
      if L.Index in [1..2] then
      begin
        UpdateBaseView(Self);
        RestoreEntityPos(E);
      end;
    end;  
  end;
end;

procedure TKontGREditForm.ChangeTextClick(Sender: TObject);
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

procedure TKontGREditForm.ChangeBooleanClick(Sender: TObject);
var L: TListItem; M: TMenuItem; B: Boolean;
begin
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  B:=(M.Tag = 1);
  if L <> nil then
    case L.Index of
       4: begin
            if B and (E.Count > 0) or not B then
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

procedure TKontGREditForm.ChangeFetchClick(Sender: TObject);
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

procedure TKontGREditForm.AddToGroupButtonClick(Sender: TObject);
var T,R: TEntity; List,EList: TList; i: integer;
begin
  List:=TList.Create;
  EList:=TList.Create;
  try
    T:=nil;
    R:=Caddy.FirstEntity;
    while R <> nil do
    begin
      if E.ClassType = TKontCRGroup then
        if (R.ClassType = TKontCntReg) and
           not Assigned(R.SourceEntity) and
           (E.Channel = R.Channel) and
           (E.Node = R.Node) then List.Add(R);
      if E.ClassType = TKontOutputsGroup then
        if ((R.ClassType = TKontAnaOut) or (R.ClassType = TKontDigOut)) and
           not Assigned(R.SourceEntity) and
           (E.Channel = R.Channel) and
           (E.Node = R.Node) then List.Add(R);
      if E.ClassType = TKontParamsGroup then
        if ((R.ClassType = TKontAnaParam) or (R.ClassType = TKontDigParam)) and
           not Assigned(R.SourceEntity) and
           (E.Channel = R.Channel) and
           (E.Node = R.Node) then List.Add(R);
      R:=R.NextEntity;
    end;
    if GetLinkNameDlg(Self,'�������� ����� �'+IntToStr(E.Childs.Count+1),List,
                      TImageList(ListView2.SmallImages),T,EList) and
                      Assigned(T) then
    begin
      Update;
      if EList.Count > 0 then
      begin
        for i:=0 to EList.Count-1 do
        if E.Childs.Count < E.GetMaxChildCount then
          E.EntityChilds[E.Childs.Count]:=TEntity(EList[i]);
      end
      else
        E.EntityChilds[E.Childs.Count]:=T;
//      LastPath:=ShowBrowserForm.GetTreePos;
      UpdateBaseView(Self);
      RestoreEntityPos(E);
//      ShowBrowserForm.RestoreTreePos(LastPath);
    end;
  finally
    List.Free;
    EList.Free;
  end;
end;

procedure TKontGREditForm.ChangeLinkClick(Sender: TObject);
var L: TListItem; T,R: TEntity; List: TList; S: string;
begin
  List:=TList.Create;
  try
    L:=ListView2.Selected;
    if L <> nil then
    begin
      T:=TEntity(L.Data);
      R:=Caddy.FirstEntity;
      while R <> nil do
      begin
        if E.ClassType = TKontCRGroup then
          if (R.ClassType = TKontCntReg) and
             not Assigned(R.SourceEntity) and
             (E.Channel = R.Channel) and
             (E.Node = R.Node) then List.Add(R);
        if E.ClassType = TKontOutputsGroup then
          if ((R.ClassType = TKontAnaOut) or (R.ClassType = TKontDigOut)) and
             not Assigned(R.SourceEntity) and
             (E.Channel = R.Channel) and
             (E.Node = R.Node) then List.Add(R);
        if E.ClassType = TKontParamsGroup then
          if ((R.ClassType = TKontAnaParam) or (R.ClassType = TKontDigParam)) and
             not Assigned(R.SourceEntity) and
             (E.Channel = R.Channel) and
             (E.Node = R.Node) then List.Add(R);
        R:=R.NextEntity;
      end;
      if GetLinkNameDlg(Self,'�������� ����� �'+IntToStr(L.Index+1),List,
                        TImageList(ListView2.SmallImages),T) then
      begin
        Update;
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
          end;
          S:=Caption;
        end;
//        LastPath:=ShowBrowserForm.GetTreePos;
        UpdateBaseView(Self);
        RestoreEntityPos(E);
//        ShowBrowserForm.RestoreTreePos(LastPath);
        ListView2.SetFocus;
        ListView2.Selected:=ListView2.FindCaption(0,S,False,True,False);
      end;
    end;
  finally
    List.Free;
  end;
end;

procedure TKontGREditForm.DeleteLinkClick(Sender: TObject);
var L: TListItem; T: TEntity; i: integer;
begin
  L:=ListView2.Selected;
  if L <> nil then
  begin
    T:=E.EntityChilds[L.Index];
    if (T <> nil) and
       (RemxForm.ShowQUestion(IfThen((ListView2.SelCount = 1),
                     '������� ����� "'+T.PtName+'"?',
           '������� ��������� ����� ('+
           IntToStr(ListView2.SelCount)+' ��.)?'))=mrOK) then
    begin
      Update;
      if ListView2.SelCount = 1 then
        E.EntityChilds[L.Index]:=nil
      else
      begin
        for i:=ListView2.Items.Count-1 downto 0 do
        if ListView2.Items[i].Selected then
          E.EntityChilds[i]:=nil;
      end;
      if E.Count = 0 then E.Actived:=False;
//      LastPath:=ShowBrowserForm.GetTreePos;
      UpdateBaseView(Self);
      RestoreEntityPos(E);
//      ShowBrowserForm.RestoreTreePos(LastPath);
    end;
  end;
end;

procedure TKontGREditForm.ReconfigGroupButtonClick(Sender: TObject);
var R: TEntity; List,EList: TList; i: integer;
begin
  List:=TList.Create;
  EList:=TList.Create;
  try
    R:=Caddy.FirstEntity;
    while R <> nil do
    begin
      if E.ClassType = TKontCRGroup then
        if (R.ClassType = TKontCntReg) and
           not Assigned(R.SourceEntity) and
           (E.Channel = R.Channel) and
           (E.Node = R.Node) then List.Add(R);
      if E.ClassType = TKontOutputsGroup then
        if ((R.ClassType = TKontAnaOut) or (R.ClassType = TKontDigOut)) and
           not Assigned(R.SourceEntity) and
           (E.Channel = R.Channel) and
           (E.Node = R.Node) then List.Add(R);
      if E.ClassType = TKontParamsGroup then
        if ((R.ClassType = TKontAnaParam) or (R.ClassType = TKontDigParam)) and
           not Assigned(R.SourceEntity) and
           (E.Channel = R.Channel) and
           (E.Node = R.Node) then List.Add(R);
      R:=R.NextEntity;
    end;
    if GetDualLinkNameDlg(Self,List,
                      TImageList(ListView2.SmallImages),E,EList) then
    begin
      Update;
      if EList.Count > 0 then
      begin
        for i:=0 to EList.Count-1 do
        if E.Childs.Count < E.GetMaxChildCount then
          E.EntityChilds[E.Childs.Count]:=TEntity(EList[i]);
      end;
//      LastPath:=ShowBrowserForm.GetTreePos;
      UpdateBaseView(Self);
      RestoreEntityPos(E);
//      ShowBrowserForm.RestoreTreePos(LastPath);
    end;
  finally
    List.Free;
    EList.Free;
  end;
end;

end.
