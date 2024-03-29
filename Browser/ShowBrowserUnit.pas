unit ShowBrowserUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, ExtCtrls, Menus, ImgList, Contnrs, EntityUnit,
  ActnList, StdActns, FindDialogUnit, PanelFormUnit;

type
  TNodeInfo = class
  public
    Channel,Node,EntityCategory: integer;
    IsRoot,IsVirtRoot,IsVirtual,IsEntity: boolean;
    Entity: TEntity;
    constructor Create;
  end;

  TShowBrowserForm = class(TForm, IFresh, IEntity)
    TVBase: TTreeView;
    Splitter1: TSplitter;
    BrowserPanel: TPanel;
    LVBase: TListView;
    BrowseActionList: TActionList;
    MenuBarImages: TImageList;
    LVBasePopup: TPopupMenu;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    MenuActionList: TActionList;
    actFind: TAction;
    ToolButton3: TToolButton;
    tbNewEntity: TToolButton;
    actBack: TAction;
    actForward: TAction;
    actUpper: TAction;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    NewPopupMenu: TPopupMenu;
    actRenameEntity: TAction;
    actDeleteEntity: TAction;
    actDoubleEntity: TAction;
    actSaveBase: TAction;
    tbSave: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    actPaspShow: TAction;
    BackPopupMenu: TPopupMenu;
    ForwardPopupMenu: TPopupMenu;
    tbUpLevel: TToolButton;
    actImport: TAction;
    actOpenOldEntity: TFileOpen;
    actExportToExcel: TAction;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    Panel1: TPanel;
    Splitter2: TSplitter;
    MiddlePanel: TPanel;
    LVErrors: TListView;
    LVErrorsPopup: TPopupMenu;
    actSchemeShow: TAction;
    ToolButton9: TToolButton;
    procedure tbNewClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TVBaseChange(Sender: TObject; Node: TTreeNode);
    procedure FormDestroy(Sender: TObject);
    procedure LVBaseDblClick(Sender: TObject);
    procedure LVBaseData(Sender: TObject; Item: TListItem);
    procedure LVBasePopupPopup(Sender: TObject);
    procedure LVBasePopupClick(Sender: TObject);
    procedure actRenameEntityExecute(Sender: TObject);
    procedure actDeteleEntityExecute(Sender: TObject);
    procedure actDoubleEntityExecute(Sender: TObject);
    procedure actSaveBaseUpdate(Sender: TObject);
    procedure actSaveBaseExecute(Sender: TObject);
    procedure actPaspShowExecute(Sender: TObject);
    procedure actPaspShowUpdate(Sender: TObject);
    procedure FindDialogFind(Sender: TObject);
    procedure actFindExecute(Sender: TObject);
    procedure actBackExecute(Sender: TObject);
    procedure actBackUpdate(Sender: TObject);
    procedure actForwardExecute(Sender: TObject);
    procedure actForwardUpdate(Sender: TObject);
    procedure BackPopupMenuChange(Sender: TObject; Source: TMenuItem;
      Rebuild: Boolean);
    procedure ForwardPopupMenuChange(Sender: TObject; Source: TMenuItem;
      Rebuild: Boolean);
    procedure TVBaseChanging(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
    procedure ForwardPopupMenuClick(Sender: TObject);
    procedure actUpperExecute(Sender: TObject);
    procedure actUpperUpdate(Sender: TObject);
    procedure LVBaseCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure FormShow(Sender: TObject);
    procedure LVBaseColumnClick(Sender: TObject; Column: TListColumn);
    procedure actImportExecute(Sender: TObject);
    procedure actExportToExcelExecute(Sender: TObject);
    procedure LVErrorsData(Sender: TObject; Item: TListItem);
    procedure LVErrorsDblClick(Sender: TObject);
    procedure LVErrorsPopupPopup(Sender: TObject);
    procedure TVBaseDblClick(Sender: TObject);
    procedure actSchemeShowExecute(Sender: TObject);
    procedure actSchemeShowUpdate(Sender: TObject);
  private
    FTopForm: TForm;
    procedure SetTopForm(const Value: TForm);
  private
    EntityList: TList;
    ErrorsList: TList;
    ListViewForm: TForm;
    EditForms: array of TForm;
    NodeInfoList: TObjectList;
    SmallImageList: TImageList;
    DefChan,DefNode: integer;
    FindDialog: TFindDialogForm;
    FPanel: TPanelForm;
    procedure UpdateTreeView;
    procedure UpdateListView;
    procedure FreshView; stdcall;
    procedure ChangeFetchClick(Sender: TObject);
    function GetTreePath: string;
    procedure BackPopupMenuClick(Sender: TObject);
    procedure TreeViewAlterChanging(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
    procedure ConnectEntity(Entity: TEntity); stdcall;
    procedure ConnectImageList(ImageList: TImageList); stdcall;
    procedure UpdateRealTime; stdcall;
    procedure UpdateLVErrors;
    procedure RebuildLVErrors(Sender: TObject);
    procedure ResetTimeoutCounters(Sender: TObject);
    procedure ChangeChannelClick(Sender: TObject);
    procedure ChangeNodeClick(Sender: TObject);
    property TopForm: TForm read FTopForm write SetTopForm;
  public
    FirstShow: boolean;
    procedure UpdateBaseView(Sender: TObject = nil);
    procedure ChangePtNameClick(Sender: TObject);
    procedure DoubleEntityClick(Sender: TObject);
    procedure DeleteEntityClick(Sender: TObject);
    procedure RestoreTreePos(LastPath: string);
    procedure RestoreEntityPos(E: TEntity);
    function GetTreePos: string;
    property Panel: TPanelForm read FPanel write FPanel;
  end;

  THackEntity = class(TEntity)
  end;

var
  ShowBrowserForm: TShowBrowserForm;

implementation

uses GetPtNameUnit, StrUtils, {ImportOldEntityUnit,} RemXUnit,
     StdCtrls, SaveExtDialogUnit, ComObj, KontrastUnit;

{$R *.dfm}

procedure TShowBrowserForm.FormCreate(Sender: TObject);
var i,j,k: integer; C: TEntityClass; F: TFormClass;
    Act: TAction; M,MM: TMenuItem; L: TList;
begin
  DefChan:=1;
  DefNode:=1;
  LVBase.DoubleBuffered:=False;
  FirstShow:=True;
  TopForm:=nil;
  FindDialog:=TFindDialogForm.Create(Self);
  FindDialog.leFindExample.CharCase:=ecUpperCase;
  FindDialog.OnFind:=FindDialogFind;
  EntityList:=TList.Create;
  ErrorsList:=TList.Create;
  ListViewForm:=TForm.Create(Self);
  LVBase.Parent:=ListViewForm;
  with ListViewForm do
  begin
    Font.Name:=Self.Font.Name;
    Font.Size:=Self.Font.Size;
    Left:=TVBase.Width;
    Align:=alClient;
    BorderStyle:=bsNone;
    Parent:=BrowserPanel;
    Show;
  end;
  SetLength(EditForms,EditFormClassList.Count);
  for i:=0 to EditFormClassList.Count-1 do
  begin
    F:=TFormClass(EditFormClassList[i]);
    EditForms[i]:=F.Create(Self);
    EditForms[i].Align:=alClient;
    EditForms[i].BorderStyle:=bsNone;
    EditForms[i].Left:=TVBase.Width;
    EditForms[i].Parent:=BrowserPanel;
    with EditForms[i].Font do
    begin
      Name:='Tahoma';
      Size:=10;
    end;
    if EditForms[i] is TBaseEditForm then
    with EditForms[i] as TBaseEditForm do
    begin
      ChangePtNameClick:=Self.ChangePtNameClick;
      DoubleEntityClick:=Self.DoubleEntityClick;
      DeleteEntityClick:=Self.DeleteEntityClick;
      UpdateBaseView:=Self.UpdateBaseView;
      RestoreEntityPos:=Self.RestoreEntityPos;
    end;
  end;
  NodeInfoList:=TObjectList.Create;
  with NewPopupMenu do  //�����...
  begin
    Items.Clear;
    k:=0;
    for j:=0 to NodeList.Count-1 do
    begin
      MM:=TMenuItem.Create(Self);
      MM.Caption:=NodeList.Strings[j];
      Items.Add(MM);
      L:=NodeList.Objects[j] as TList;
      for i:=0 to L.Count-1 do
      begin
        Act:=TAction.Create(Self);
        Act.ActionList:=BrowseActionList;
        C:=TEntityClass(L[i]);
        Act.Caption:=C.EntityType;
        Act.Tag:=k; 
        Act.ImageIndex:=k+3;
        Act.OnExecute:=tbNewClick;
        M:=TMenuItem.Create(Self);
        M.Action:=Act;
        MM.Add(M);
        Inc(k);
      end;
    end;
  end;
end;

procedure TShowBrowserForm.tbNewClick(Sender: TObject);
var EntityName: string; EC: TEntityClass; E: TEntity; N: TTreeNode;
    Nfo: TNodeInfo; ClassIndex: integer;
begin
  EntityName:='';
  ClassIndex:=(Sender as TComponent).Tag;
  EC:=TEntityClass(EntityClassList[ClassIndex]);
  if GetPtNameDlg(EC,SmallImageList,EntityName) then
  begin
    Update;
    E:=Caddy.AddEntity(EntityName,ClassIndex,EC);
    THackEntity(E).FChannel:=DefChan;
    THackEntity(E).FNode:=DefNode;
    UpdateBaseView;
    N:=TVBase.Items.GetFirstNode;
    while N <> nil do
    begin
      Nfo:=TNodeInfo(N.Data);
      if (Nfo <> nil) and Nfo.IsEntity and (Nfo.Entity = E) then
      begin
        TVBase.Selected:=N;
        Break;
      end;
      N:=N.GetNext;
    end;
  end;
end;

procedure TShowBrowserForm.UpdateListView;
var Level: integer; Nfo: TNodeInfo; N: TTreeNode;
begin
  Screen.Cursor:=crHourGlass;
  LVBase.Items.BeginUpdate;
  try
    LVBase.Items.Count:=0;
    EntityList.Clear;
    N:=TVBase.Selected;
    if N <> nil then
    begin
      Level:=N.Level;
      N:=N.getFirstChild;
      while N <> nil do
      begin
        if Level >= N.Level then Break;
        Nfo:=TNodeInfo(N.Data);
        if Nfo.IsEntity then EntityList.Add(Nfo.Entity);
        N:=N.GetNext;
      end;
    end;
  finally
    LVBase.Items.Count:=EntityList.Count;
    LVBase.Items.EndUpdate;
    Screen.Cursor:=crDefault;
  end;
end;

procedure TShowBrowserForm.UpdateLVErrors;
var Level: integer; Nfo: TNodeInfo; N: TTreeNode; E: TEntity;
begin
  Screen.Cursor:=crHourGlass;
  LVErrors.Items.BeginUpdate;
  try
    LVErrors.Items.Count:=0;
    ErrorsList.Clear;
    N:=TVBase.Selected;
    if N <> nil then
    begin
      Level:=N.Level;
      N:=N.getFirstChild;
      while N <> nil do
      begin
        if Level >= N.Level then Break;
        Nfo:=TNodeInfo(N.Data);
        if Nfo.IsEntity and Assigned(Nfo.Entity) then
        begin
          E:=Nfo.Entity;
          if (Length(E.ErrorMess) > 0) or
             (E.BadFetchsCount > 0) and (E.GoodFetchsCount > 0) then
            ErrorsList.Add(E);
        end;
        N:=N.GetNext;
      end;
    end;
  finally
    LVErrors.Items.Count:=ErrorsList.Count;
    LVErrors.Items.EndUpdate;
    Screen.Cursor:=crDefault;
  end;
end;

procedure TShowBrowserForm.UpdateTreeView;
var tnStat,tnVirt,N,NT: TTreeNode; iChan,iNode: integer; Nfo: TNodeInfo;
    AChan: array of record
             tnChan: TTreeNode;
             ANode: array of TTreeNode;
           end;
    E: TEntity;
    Found: boolean;
    function LinkInfo(N: TTreeNode): TNodeInfo;
    begin
      Result:=TNodeInfo.Create;
      NodeInfoList.Add(Result);
      N.Data:=Result;
    end;
    function EntType(ParentNode: TTreeNode; Entity: TEntity): TTreeNode;
    begin
      Result:=ParentNode.getFirstChild;
      Found:=False;
      while Result <> nil do
      begin
        if Result.Text = Entity.EntityType then
        begin
          Found:=True;
          Break;
        end;
        Result:=Result.getNextSibling;
      end;
      if not Found then
      begin
        Result:=TVBase.Items.AddChild(ParentNode,Entity.EntityType);
        with Result do
        begin
          ImageIndex:=EntityClassList.IndexOf(Entity.ClassType)+3;
          SelectedIndex:=ImageIndex;
        end;
        with LinkInfo(Result) do
        begin
          IsVirtual:=E.IsVirtual;
          EntityCategory:=EntityClassIndex(E.ClassType);
          if not IsVirtual then
          begin
            Channel:=E.Channel;
            Node:=E.Node;
          end;
        end;
      end;
    end;
    procedure LinkGroup(E: TEntity; N: TTreeNode);
    var i: integer; G: TCustomGroup; NChild: TTreeNode;
    begin
      if E.IsGroup then
      begin
        G:=E as TCustomGroup;
        for i:=0 to G.Childs.Count-1 do
        if G.EntityChilds[i] <> nil then
        begin
          NChild:=TVBase.Items.AddChild(EntType(N,G.EntityChilds[i]),
                                        G.EntityChilds[i].PtName);
          with NChild do
          begin
            ImageIndex:=EntityClassIndex(G.EntityChilds[i].ClassType)+3;
            SelectedIndex:=ImageIndex;
          end;
          with LinkInfo(NChild) do
          begin
            IsVirtual:=G.EntityChilds[i].IsVirtual;
            IsEntity:=True;
            Entity:=G.EntityChilds[i];
            EntityCategory:=EntityClassIndex(G.EntityChilds[i].ClassType);
          end;
          LinkGroup(G.EntityChilds[i],NChild);
        end;
      end;
    end;
begin
  SetLength(AChan,0);
  Screen.Cursor:=crHourGlass;
  TVBase.Items.BeginUpdate;
  try
    NodeInfoList.Clear;
    TVBase.Items.Clear;
    tnStat:=TVBase.Items.Add(nil,'������� �������');
    with LinkInfo(tnStat) do IsRoot:=True;
    tnVirt:=TVBase.Items.AddChild(tnStat,'����������� �����');
    with LinkInfo(tnVirt) do IsVirtRoot:=True;
    E:=Caddy.FirstEntity;
    while E <> nil do
    begin
      if E.SourceEntity = nil then
      begin
        if E.IsVirtual then
        begin
          N:=TVBase.Items.AddChild(EntType(tnVirt,E),E.PtName);
          with N do
          begin
            ImageIndex:=EntityClassIndex(E.ClassType)+3;
            SelectedIndex:=ImageIndex;
          end;
          with LinkInfo(N) do
          begin
            IsVirtual:=True;
            IsEntity:=True;
            Entity:=E;
            EntityCategory:=EntityClassIndex(E.ClassType);
          end;
          LinkGroup(E,N);
        end
        else
        begin
          iChan:=E.Channel;
          iNode:=E.Node;
          if iChan >= Length(AChan) then
          begin
            SetLength(AChan,iChan+1);
            AChan[iChan].tnChan:=TVBase.Items.AddChild(tnStat,
                                        Format('����� %d',[iChan]));
            with AChan[iChan].tnChan do
            begin
              ImageIndex:=1;
              SelectedIndex:=1;
            end;
            with LinkInfo(AChan[iChan].tnChan) do Channel:=iChan;
          end;
          if (iNode <> 0) and (iNode >= Length(AChan[iChan].ANode)) then
          begin
            if not Assigned(AChan[iChan].tnChan) then
            begin
              AChan[iChan].tnChan:=TVBase.Items.AddChild(tnStat,
                                          Format('����� %d',[iChan]));
              with AChan[iChan].tnChan do
              begin
                ImageIndex:=1;
                SelectedIndex:=1;
              end;
              with LinkInfo(AChan[iChan].tnChan) do Channel:=iChan;
            end;
            SetLength(AChan[iChan].ANode,iNode+1);
            AChan[iChan].ANode[iNode]:=TVBase.Items.AddChild(AChan[iChan].tnChan,
                                            Format('���������� %2d',[iNode]));
            with AChan[iChan].ANode[iNode] do
            begin
              ImageIndex:=2;
              SelectedIndex:=2;
            end;
            with LinkInfo(AChan[iChan].ANode[iNode]) do
            begin
              Channel:=iChan;
              Node:=iNode;
            end;
          end;
          if (iNode <> 0) and not Assigned(AChan[iChan].ANode[iNode]) then
          begin
            AChan[iChan].ANode[iNode]:=TVBase.Items.AddChild(AChan[iChan].tnChan,
                                            Format('���������� %2d',[iNode]));
            with AChan[iChan].ANode[iNode] do
            begin
              ImageIndex:=2;
              SelectedIndex:=2;
            end;
            with LinkInfo(AChan[iChan].ANode[iNode]) do
            begin
              Channel:=iChan;
              Node:=iNode;
            end;
          end;
          if iNode = 0 then
          begin
            if not Assigned(AChan[iChan].tnChan) then
            begin
              AChan[iChan].tnChan:=TVBase.Items.AddChild(tnStat,
                                          Format('����� %d',[iChan]));
              with AChan[iChan].tnChan do
              begin
                ImageIndex:=1;
                SelectedIndex:=1;
              end;
              with LinkInfo(AChan[iChan].tnChan) do Channel:=iChan;
            end;
            N:=TVBase.Items.AddChildFirst(EntType(AChan[iChan].tnChan,E),E.PtName);
          end
          else
            N:=TVBase.Items.AddChild(EntType(AChan[iChan].ANode[iNode],E),
                                       E.PtName);
          with N do
          begin
            ImageIndex:=EntityClassIndex(E.ClassType)+3;
            SelectedIndex:=ImageIndex;
          end;
          with LinkInfo(N) do
          begin
            Channel:=iChan;
            Node:=iNode;
            IsEntity:=True;
            Entity:=E;
            EntityCategory:=EntityClassIndex(E.ClassType);
          end;
          LinkGroup(E,N);
        end;
      end;
      E:=E.NextEntity;
    end;
    tnStat.AlphaSort(True);
//-----------------------------------
    N:=TVBase.Items.GetFirstNode;
    while N <> nil do
    begin
      Nfo:=TNodeInfo(N.Data);
      if (Nfo <> nil) and Nfo.IsEntity and Nfo.Entity.IsCustom then
      begin
        NT:=N.GetNext;
        N.Parent.MoveTo(N.Parent.Parent,naAddChildFirst);
        N.Parent.Parent.Collapse(False);
        N:=NT;
      end
      else
        N:=N.GetNext;
    end;
//-----------------------------------
  finally
    TVBase.Items.EndUpdate;
    Screen.Cursor:=crDefault;
  end;
end;

procedure TShowBrowserForm.UpdateBaseView(Sender: TObject);
begin
  UpdateTreeView;
  UpdateListView;
end;

procedure TShowBrowserForm.TVBaseChange(Sender: TObject; Node: TTreeNode);
var N: TTreeNode; Nfo: TNodeInfo; F: TForm;
begin
  DefChan:=1;
  DefNode:=1;
  N:=Node;
  while N <> nil do
  begin
    if Pos('����� ',N.Text) = 1 then
      DefChan:=StrToIntDef(Copy(N.Text,7,1),1);
    if Pos('���������� ',N.Text) = 1 then
      DefNode:=StrToIntDef(Copy(N.Text,12,2),1);
    N:=N.Parent;
  end;
  if Node <> nil then
    Nfo:=TNodeInfo(Node.Data)
  else
    Nfo:=nil;
  if (Nfo = nil) or (Nfo <> nil) and not Nfo.IsEntity then
  begin
    UpdateListView;
    ListViewForm.Show;
    RemXForm.ShowMessage:=NumToStr(EntityList.Count,'�������','','�','�',False)+' '+
             NumToStr(EntityList.Count,'������','','�','��')+' � ��������� "'+
             Node.Text+'"';
    TopForm:=nil;
    UpdateLVErrors;
  end
  else
  if Nfo.IsEntity and (Nfo.Entity is TEntity) then
  begin
    F:=EditForms[EntityClassIndex(Nfo.Entity.ClassType)];
    SendMessage(F.Handle,WM_ConnectBaseEditor,
                Integer(SmallImageList),Integer(Nfo.Entity));
    F.Show;
    TopForm:=F;
    RemXForm.ShowMessage:='������� '+Nfo.Entity.PtName+' - '+Nfo.Entity.PtDesc;
  end;
end;

procedure TShowBrowserForm.FormDestroy(Sender: TObject);
begin
  NodeInfoList.Free;
  EntityList.Free;
  ErrorsList.Free;
  FindDialog.Free;
end;

{ TNodeInfo }

constructor TNodeInfo.Create;
begin
  Channel:=-1;
  Node:=-1;
  EntityCategory:=-1;
  IsRoot:=False;
  IsVirtRoot:=False;
  IsVirtual:=False;
  IsEntity:=False;
  Entity:=nil;
end;

procedure TShowBrowserForm.LVBaseDblClick(Sender: TObject);
var E: TEntity; N: TTreeNode; Nfo: TNodeInfo;
begin
  if LVBase.Selected <> nil then
  begin
    E:=TEntity(LVBase.Selected.Data);
    N:=TVBase.Items.GetFirstNode;
    while N <> nil do
    begin
      Nfo:=TNodeInfo(N.Data);
      if (Nfo <> nil) and Nfo.IsEntity and (Nfo.Entity = E) then
      begin
        TVBase.Selected:=N;
        Break;
      end;
      N:=N.GetNext;
    end;
  end;
end;

procedure TShowBrowserForm.LVBaseData(Sender: TObject; Item: TListItem);
var L: TListItem; E: TEntity;
begin
  try
    E:=TEntity(EntityList[Item.Index]);
    L:=Item;
    L.Caption:=E.PtName;
    L.ImageIndex:=EntityClassIndex(E.ClassType)+3;
    L.SubItems.Add(E.PtDesc);
    L.SubItems.Add(IfThen(E.IsVirtual,'',IntToStr(E.Channel)));
    L.SubItems.Add(IfThen(E.IsVirtual or (E.Node = 0),'',IntToStr(E.Node)));
    L.SubItems.Add(IfThen(E.Actived,'��','���'));
    L.SubItems.Add(IfThen(E.IsGroup or E.IsParam or
                   (E.EntityKind = ekCustom),'',IfThen(E.Logged,'��','���')));
    L.SubItems.Add(IfThen(E.IsGroup or E.IsParam or
                   (E.EntityKind = ekCustom),'',IfThen(E.Asked,'��','���')));
    L.SubItems.Add(IntToStr(E.FetchTime)+' ���');
    if E.RealTime > 0 then
      L.SubItems.Add(Format('%.3f',[E.RealTime/1000])+' ���')
    else
      L.SubItems.Add('��� ������');
    L.SubItems.Add(IfThen(Length(E.SourceName)=0,'����',E.SourceName));
    if E.SourceEntity <> nil then
      L.SubItemImages[8]:=EntityClassIndex(E.SourceEntity.ClassType)+3;
    L.Data:=E;
  except
    LVBase.Items.Count:=0;
  end;
end;

procedure TShowBrowserForm.FreshView;
var R: TRect; i,j,sum: integer;
begin
  sum:=0; for i:=0 to 7 do sum:=sum+LVBase.Columns.Items[i].Width;
  j:=sum+LVBase.Columns.Items[8].Width; R:=Rect(sum,0,j,LVBase.Height);
  InvalidateRect(LVBase.Handle,@R,False);
//-----------------------------------------
  sum:=0; for i:=0 to 0 do sum:=sum+LVErrors.Columns.Items[i].Width;
  j:=sum+LVErrors.Columns.Items[1].Width; R:=Rect(sum,0,j,LVErrors.Height);
  InvalidateRect(LVErrors.Handle,@R,False);
  if Assigned(TopForm) then PostMessage(TopForm.Handle,WM_Fresh,0,0);
end;

procedure TShowBrowserForm.LVBasePopupPopup(Sender: TObject);
var M,FM: TMenuItem; E: TEntity; i,j: integer; Found: boolean;
begin
  LVBasePopup.Items.Clear;
  if not (Caddy.UserLevel > 4) then Exit;
  if LVBase.Selected <> nil then
  with LVBasePopup do
  begin
    E:=TEntity(LVBase.Selected.Data);
    if LVBase.SelCount = 1 then
    begin
      M:=TMenuItem.Create(Self); M.Caption:='�����';
      M.Checked:=E.Actived; M.Tag:=0; M.OnClick:=LVBasePopupClick; Items.Add(M);
      if not (E.IsGroup or E.IsParam or (E.EntityKind = ekCustom)) then
      begin
        M:=TMenuItem.Create(Self); M.Caption:='������������';
        M.Checked:=E.Logged; M.Tag:=1; M.OnClick:=LVBasePopupClick; Items.Add(M);
        M:=TMenuItem.Create(Self); M.Caption:='������������';
        M.Checked:=E.Asked; M.Tag:=2; M.OnClick:=LVBasePopupClick; Items.Add(M);
      end;
    end
    else
    begin
      FM:=TMenuItem.Create(Self); FM.Caption:='�����'; Items.Add(FM);
      M:=TMenuItem.Create(Self); M.Caption:='���';
      M.Tag:=4; M.OnClick:=LVBasePopupClick; FM.Add(M);
      M:=TMenuItem.Create(Self); M.Caption:='��';
      M.Tag:=3; M.OnClick:=LVBasePopupClick; FM.Add(M);
      Found:=False;
      for i:=0 to LVBase.Items.Count-1 do
      if LVBase.Items[i].Selected then
        with TEntity(LVBase.Items[i].Data) do
        if IsGroup or IsParam or (EntityKind = ekCustom) then
        begin
          Found:=True;
          Break;
        end;
      if not Found then
      begin
        FM:=TMenuItem.Create(Self); FM.Caption:='������������'; Items.Add(FM);
        M:=TMenuItem.Create(Self); M.Caption:='���';
        M.Tag:=6; M.OnClick:=LVBasePopupClick; FM.Add(M);
        M:=TMenuItem.Create(Self); M.Caption:='��';
        M.Tag:=5; M.OnClick:=LVBasePopupClick; FM.Add(M);
        FM:=TMenuItem.Create(Self); FM.Caption:='������������'; Items.Add(FM);
        M:=TMenuItem.Create(Self); M.Caption:='���';
        M.Tag:=8; M.OnClick:=LVBasePopupClick; FM.Add(M);
        M:=TMenuItem.Create(Self); M.Caption:='��';
        M.Tag:=7; M.OnClick:=LVBasePopupClick; FM.Add(M);
      end;
    end;
    //---
    M:=TMenuItem.Create(Self); M.Caption:='-'; Items.Add(M);
    //---
    FM:=TMenuItem.Create(Self);
    FM.Caption:='����� ������';
    Items.Add(FM);
    //---
    M:=TMenuItem.Create(Self);
    M.Caption:='�������� ����� ������...';
    M.OnClick:=ChangeFetchClick; M.Tag:=0; FM.Add(M);
    //---
    M:=TMenuItem.Create(Self); M.Caption:='-'; FM.Add(M);
    //---
    M:=TMenuItem.Create(Self); M.Caption:='1 ���'; M.Checked:=(E.FetchTime=1);
    M.Tag:=1; M.OnClick:=ChangeFetchClick; FM.Add(M);
    //---
    M:=TMenuItem.Create(Self); M.Caption:='2 ���'; M.Checked:=(E.FetchTime=2);
    M.Tag:=2; M.OnClick:=ChangeFetchClick; FM.Add(M);
    //---
    M:=TMenuItem.Create(Self); M.Caption:='3 ���'; M.Checked:=(E.FetchTime=3);
    M.Tag:=3; M.OnClick:=ChangeFetchClick; FM.Add(M);
    //---
    M:=TMenuItem.Create(Self); M.Caption:='5 ���'; M.Checked:=(E.FetchTime=5);
    M.Tag:=5; M.OnClick:=ChangeFetchClick; FM.Add(M);
    //---
    M:=TMenuItem.Create(Self); M.Caption:='-'; FM.Add(M);
    //---
    M:=TMenuItem.Create(Self); M.Caption:='10 ���'; M.Checked:=(E.FetchTime=10);
    M.Tag:=10; M.OnClick:=ChangeFetchClick; FM.Add(M);
    //---
    M:=TMenuItem.Create(Self); M.Caption:='20 ���'; M.Checked:=(E.FetchTime=20);
    M.Tag:=20; M.OnClick:=ChangeFetchClick; FM.Add(M);
    //---
    M:=TMenuItem.Create(Self); M.Caption:='30 ���'; M.Checked:=(E.FetchTime=30);
    M.Tag:=30; M.OnClick:=ChangeFetchClick; FM.Add(M);
    //---
    M:=TMenuItem.Create(Self); M.Caption:='-'; FM.Add(M);
    //---
    M:=TMenuItem.Create(Self); M.Caption:='1 ���'; M.Checked:=(E.FetchTime=60);
    M.Tag:=60; M.OnClick:=ChangeFetchClick; FM.Add(M);
    //---
    M:=TMenuItem.Create(Self); M.Caption:='2 ���'; M.Checked:=(E.FetchTime=120);
    M.Tag:=60*2; M.OnClick:=ChangeFetchClick; FM.Add(M);
    //---
    M:=TMenuItem.Create(Self); M.Caption:='5 ���'; M.Checked:=(E.FetchTime=300);
    M.Tag:=60*5; M.OnClick:=ChangeFetchClick; FM.Add(M);
//----------------------------------------
    Found:=False;
    for i:=0 to LVBase.Items.Count-1 do
    if LVBase.Items[i].Selected then
    with TEntity(LVBase.Items[i].Data) do
    if IsVirtual then
    begin
      Found:=True;
      Break;
    end;
    if not Found then
    begin
      FM:=TMenuItem.Create(Self);
      FM.Caption:='�����';
      Items.Add(FM);
      if LVBase.SelCount = 1 then j:=E.Channel else j:=0;
      for i:=1 to ChannelCount do
      begin
        M:=TMenuItem.Create(Self);
        M.Caption:=IntToStr(i);
        M.Tag:=i;
        M.Checked:=(i=j);
        M.OnClick:=ChangeChannelClick;
        FM.Add(M);
      end;
      Found:=False;
      for i:=0 to LVBase.Items.Count-1 do
      if LVBase.Items[i].Selected then
      with TEntity(LVBase.Items[i].Data) do
      if Node = 0 then
      begin
        Found:=True;
        Break;
      end;
    //---
      if not Found then
      begin
        FM:=TMenuItem.Create(Self);
        FM.Caption:='����������';
        Items.Add(FM);
        if LVBase.SelCount = 1 then j:=E.Node else j:=0;
        for i:=1 to 31 do
        begin
          M:=TMenuItem.Create(Self);
          M.Caption:=IntToStr(i);
          M.Tag:=i;
          M.Checked:=(i=j);
          M.OnClick:=ChangeNodeClick;
          if (i mod 8) = 1 then M.Break:=mbBreak;
          FM.Add(M);
        end;
      end;
    end;
  end;
end;

procedure TShowBrowserForm.LVBasePopupClick(Sender: TObject);
var E: TEntity; L: TListItem; B: boolean; i,n: integer; Found,Found2: boolean;
begin
  L:=LVBase.Selected;
  if L <> nil then
  begin
    E:=TEntity(L.Data);
    with Sender as TMenuItem do
    case Tag of
      0: begin
           B:=not Checked;
           if E.IsGroup then
           begin
             Found:=False;
             with E as TCustomGroup do
             for i:=0 to Count-1 do
             if Assigned(EntityChilds[i]) then
             begin
               Found:=True;
               System.Break;
             end;
             if B and Found or not B then
               E.Actived:=B
             else
               RemxForm.ShowError('������ ������ "'+E.PtName+'" �����.'#13+
                     '������ ������� �� ����� ������ ������!');
          end
          else
             E.Actived:=B;
         end;
      1: E.Logged:=not Checked;
      2: E.Asked:=not Checked;
    3,4: begin
           Found2:=False;
           for n:=0 to LVBase.Items.Count-1 do
           if LVBase.Items[n].Selected then
           begin
             E:=TEntity(LVBase.Items[n].Data);
             B:=(Tag = 3);
             if E.IsGroup then
             begin
               Found:=False;
               with E as TCustomGroup do
               for i:=0 to Count-1 do
               if Assigned(EntityChilds[i]) then
               begin
                 Found:=True;
                 System.Break;
               end;
               if B and Found or not B then
                 E.Actived:=B
               else
                 Found2:=True;
            end
            else
               E.Actived:=B;
           end;
           if Found2 then
             RemxForm.ShowError('����� ���������� ������� ���� ���������,'+
                        ' ��� �������, ���� ������ ������ ������.'#13+
                        '������ ������� �� ����� ������ ������!');
         end;
    5,6: begin
           for n:=0 to LVBase.Items.Count-1 do
           if LVBase.Items[n].Selected then
           begin
             E:=TEntity(LVBase.Items[n].Data);
             if not (E.IsGroup or E.IsParam) then
             begin
               B:=(Tag = 5);
               E.Logged:=B;
             end;
           end;
         end;
    7,8: begin
           for n:=0 to LVBase.Items.Count-1 do
           if LVBase.Items[n].Selected then
           begin
             E:=TEntity(LVBase.Items[n].Data);
             if not (E.IsGroup or E.IsParam) then
             begin
               B:=(Tag = 7);
               E.Asked:=B;
             end;
           end;
         end;
    end;
    LVBase.Invalidate;
  end;
end;

procedure TShowBrowserForm.ChangeChannelClick(Sender: TObject);
var i: integer; E: TEntity; M: TMenuItem;
begin
  M:=Sender as TMenuItem;
  E:=nil;
  for i:=0 to LVBase.Items.Count-1 do
  if LVBase.Items[i].Selected then
  begin
    E:=TEntity(LVBase.Items[i].Data);
    E.Channel:=M.Tag;
  end;
  UpdateBaseView;
  if Assigned(E) then RestoreEntityPos(E);
end;

procedure TShowBrowserForm.ChangeNodeClick(Sender: TObject);
var i: integer; E: TEntity; M: TMenuItem;
begin
  M:=Sender as TMenuItem;
  E:=nil;
  for i:=0 to LVBase.Items.Count-1 do
  if LVBase.Items[i].Selected then
  begin
    E:=TEntity(LVBase.Items[i].Data);
    E.Node:=M.Tag;
  end;
  UpdateBaseView;
  if Assigned(E) then RestoreEntityPos(E);
end;

procedure TShowBrowserForm.ChangeFetchClick(Sender: TObject);
var E: TEntity; L: TListItem; V: integer; M: TMenuItem; n: integer;
begin
  M:=Sender as TMenuItem;
  L:=LVBase.Selected;
  if L <> nil then
  begin
    E:=TEntity(L.Data);
    case M.Tag of
      0: begin
           V:=E.FetchTime;
           if InputIntegerDlg('����� ������ (� ���.)',V) then
           begin
             if V < 1 then V:=1;
             if LVBase.SelCount = 1 then
               E.FetchTime:=V
             else
             for n:=0 to LVBase.Items.Count-1 do
             if LVBase.Items[n].Selected then
             begin
               E:=TEntity(LVBase.Items[n].Data);
               E.FetchTime:=V;
             end;
           end;
         end;
    else
      begin
        if LVBase.SelCount = 1 then
          E.FetchTime:=M.Tag
        else
          for n:=0 to LVBase.Items.Count-1 do
          if LVBase.Items[n].Selected then
          begin
            E:=TEntity(LVBase.Items[n].Data);
            E.FetchTime:=M.Tag;
          end;
      end;
    end;
    LVBase.Invalidate;
  end;
end;

procedure TShowBrowserForm.actRenameEntityExecute(Sender: TObject);
var EntityName: string; EC: TEntityClass; E: TEntity; N: TTreeNode;
    Nfo: TNodeInfo;
begin
  N:=TVBase.Selected;
  if N <> nil then
  begin
    Nfo:=TNodeInfo(N.Data);
    if (Nfo <> nil) and Nfo.IsEntity then
    begin
      E:=Nfo.Entity;
      EntityName:=E.PtName;
      EC:=TEntityClass(EntityClassList[E.ClassIndex]);
      if GetPtNameDlg(EC,SmallImageList,EntityName) then
      begin
        Update;
        Caddy.RenameEntity(E,EntityName);
        UpdateBaseView;
        N:=TVBase.Items.GetFirstNode;
        while N <> nil do
        begin
          Nfo:=TNodeInfo(N.Data);
          if (Nfo <> nil) and Nfo.IsEntity and (Nfo.Entity = E) then
          begin
            TVBase.Selected:=N;
            Break;
          end;
          N:=N.GetNext;
        end;
      end;
    end;
  end;
end;

function TShowBrowserForm.GetTreePos: string;
var N: TTreeNode;
begin
  N:=TVBase.Selected;
  Result:='';
  while N <> nil do
  begin
    Result:=N.Text+'/'+Result;
    N:=N.Parent;
  end;
end;

procedure TShowBrowserForm.RestoreTreePos(LastPath: string);
var N,T: TTreeNode; S: string; Found: Boolean;
begin
  T:=TVBase.Items.GetFirstNode;
  Found:=False;
  while T <> nil do
  begin
    S:='';
    N:=T;
    while N <> nil do
    begin
      S:=N.Text+'/'+S;
      N:=N.Parent;
    end;
    if S = LastPath then
    begin
      TVBase.Selected:=T;
      T.Expand(False);
      Found:=True;
      Break;
    end;
    T:=T.GetNext;
  end;
  if not Found then TVBase.Selected:=TVBase.Items.GetFirstNode;
end;

procedure TShowBrowserForm.actDeteleEntityExecute(Sender: TObject);
var E: TEntity; N: TTreeNode; Nfo: TNodeInfo; LastPath: string;
begin
  N:=TVBase.Selected;
  if N <> nil then
  begin
    Nfo:=TNodeInfo(N.Data);
    if (Nfo <> nil) and Nfo.IsEntity then
    begin
      E:=Nfo.Entity;
      if E.Actived then
        RemxForm.ShowError('������ ������� �����, ������� �� ������!')
      else
      if E.IsGroup and not (E as TCustomGroup).IsEmpty and
         (RemxForm.ShowQuestion('������ ������ �� �����!'#13+
                         '����� ��������� ������ ����� �����������.'#13+
                                '������� ������ "'+E.PtName+'"?') = mrOK)
       or
         E.IsGroup and (E as TCustomGroup).IsEmpty and
         (RemxForm.ShowQuestion('������� ������ ������ "'+E.PtName+'"?') = mrOK)
       or
         not E.IsGroup and
         (RemxForm.ShowQuestion('������� ����� "'+E.PtName+'"?') = mrOK) then
      begin
        if N.getPrevSibling <> nil then
          TVBase.Selected:=N.getPrevSibling
        else
        if N.getNextSibling <> nil then
          TVBase.Selected:=N.getNextSibling
        else
          TVBase.Selected:=N.Parent;
        LastPath:=GetTreePos;
        E.Actived:=False;
        Caddy.DeleteEntity(E);
        N.Free;
        UpdateBaseView;
        RestoreTreePos(LastPath);
      end;
    end;
  end;
end;

procedure TShowBrowserForm.actDoubleEntityExecute(Sender: TObject);
var EntityName,OldName: string; EC: TEntityClass;
    E,T: TEntity; N: TTreeNode;
    Nfo: TNodeInfo;
begin
  N:=TVBase.Selected;
  if N <> nil then
  begin
    Nfo:=TNodeInfo(N.Data);
    if (Nfo <> nil) and Nfo.IsEntity then
    begin
      T:=Nfo.Entity;
      EntityName:=T.PtName;
      OldName:=EntityName;
      EC:=TEntityClass(T.ClassType);
      if GetPtNameDlg(EC,SmallImageList,EntityName) then
      begin
        Update;
        E:=Caddy.AddEntity(EntityName,T.ClassIndex,EC);
        E.Assign(T);
        UpdateBaseView;
        E.ShowEditor(Monitor.MonitorNum);
      end;
    end;
  end;
end;

procedure TShowBrowserForm.ChangePtNameClick(Sender: TObject);
begin
  actRenameEntity.Execute;
end;

procedure TShowBrowserForm.DeleteEntityClick(Sender: TObject);
begin
  actDeleteEntity.Execute
end;

procedure TShowBrowserForm.DoubleEntityClick(Sender: TObject);
begin
  actDoubleEntity.Execute;
end;

procedure TShowBrowserForm.actSaveBaseUpdate(Sender: TObject);
begin
  actSaveBase.Enabled:=Caddy.Changed;
end;

procedure TShowBrowserForm.actSaveBaseExecute(Sender: TObject);
var i,j: integer; E: TEntity;
begin
  actSaveBase.Enabled:=False;
  try
    Caddy.SaveBase(Caddy.CurrentBasePath);
//---- ����������� ������ ������ ������������ ����� -----
    for i:=1 to 125 do
      for j:=1 to 8 do
      with Caddy.HistGroups[i] do
      begin
        E:=Caddy.Find(Place[j]);
        if Assigned(E) then
        begin
          Entity[j]:=E;
          if E.IsAnalog or E.IsKontur then
          with E as TCustomAnaOut do
          begin
            if Kind[j] = 2 then
              EU[j]:='%'
            else
              EU[j]:=EUDesc;
            DF[j]:=Ord(PVFormat);
          end;
          if E.IsDigit then
          begin
            EU[j]:='%';
            DF[j]:=0;
          end;
        end
        else
        begin
          Caddy.HistGroups[i].Place[j]:='';
          Caddy.HistGroups[i].Entity[j]:=nil;
          Caddy.HistGroups[i].Kind[j]:=0;
          Caddy.HistGroups[i].EU[j]:='';
          Caddy.HistGroups[i].DF[j]:=1;
        end;
      end;
    Caddy.SaveHistGroups(Caddy.CurrentBasePath);
    if Caddy.UserLevel > 5 then
    begin
      Screen.Cursor := crHourGlass;
      try
        //Caddy.SaveBaseToXML;
        Caddy.SaveBaseToINI;
      finally
        Screen.Cursor := crDefault;
      end;
    end;
  finally
    actSaveBase.Enabled:=True;
  end;
end;

procedure TShowBrowserForm.actPaspShowExecute(Sender: TObject);
var N: TTreeNode; Nfo: TNodeInfo; E: TEntity;
begin
  if (TVBase.Selected <> nil) and (TVBase.Selected.Data <> nil) and
     TNodeInfo(TVBase.Selected.Data).IsEntity then
  begin
    N:=TVBase.Selected;
    if N <> nil then
    begin
      Nfo:=TNodeInfo(N.Data);
      if (Nfo <> nil) and Nfo.IsEntity then
      begin
        E:=Nfo.Entity;
        E.ShowPassport(Monitor.MonitorNum);
      end;
    end;
  end
  else
  if (LVBase.Selected <> nil) and (TEntity(LVBase.Selected.Data) is TEntity) then
    (TEntity(LVBase.Selected.Data).ShowPassport(Monitor.MonitorNum));
end;

procedure TShowBrowserForm.actPaspShowUpdate(Sender: TObject);
begin
  actPaspShow.Enabled:=(TVBase.Selected <> nil) and
                       (TVBase.Selected.Data <> nil) and
                       TNodeInfo(TVBase.Selected.Data).IsEntity
                      or
                       (LVBase.Selected <> nil) and
                       (TEntity(LVBase.Selected.Data) is TEntity);
end;

procedure TShowBrowserForm.RestoreEntityPos(E: TEntity);
var T: TTreeNode; Found: Boolean; Nfo: TNodeInfo;
begin
  T:=TVBase.Items.GetFirstNode;
  Found:=False;
  while T <> nil do
  begin
    Nfo:=TNodeInfo(T.Data);
    if (Nfo <> nil) and Nfo.IsEntity and (E = Nfo.Entity) then
    begin
      TVBase.Selected:=T;
      T.Expand(False);
      Found:=True;
      Break;
    end;
    T:=T.GetNext;
  end;
  if not Found then TVBase.Selected:=TVBase.Items.GetFirstNode;
end;

procedure TShowBrowserForm.FindDialogFind(Sender: TObject);
var N: TTreeNode;
begin
  if frFindNext in FindDialog.Options then
    N := TVBase.Selected
  else
    N := TVBase.Items.GetFirstNode;
  if N <> nil then
  begin
    if frDown in FindDialog.Options then
    begin
      if frFindNext in FindDialog.Options then N:=N.GetNext;
      while N <> nil do
      begin
        if frWholeWord in FindDialog.Options then
        begin
          if UpperCase(N.Text) = UpperCase(FindDialog.FindText) then
          begin
            TVBase.Selected:=N;
            Break;
          end;
        end
        else
        begin
          if Pos(UpperCase(FindDialog.FindText),UpperCase(N.Text)) > 0 then
          begin
            TVBase.Selected:=N;
            Break;
          end;
        end;
        N:=N.GetNext;
      end;
      if N = nil then RemXForm.ShowInfo('������ ������ �� �������.');
    end;
(*
    else
    begin
      if frFindNext in FindDialog.Options then N:=N.GetPrev;
      while N <> nil do
      begin
        if frWholeWord in FindDialog.Options then
        begin
          if UpperCase(N.Text) = UpperCase(FindDialog.FindText) then
          begin
            TVBase.Selected:=N;
            Break;
          end;
        end
        else
        begin
          if Pos(UpperCase(FindDialog.FindText),UpperCase(N.Text)) > 0 then
          begin
            TVBase.Selected:=N;
            Break;
          end;
        end;
        N:=N.GetPrev;
      end;
      if N = nil then RemXForm.ShowInfo('������ ������ �� �������.');
    end;
*)
  end
  else
  begin
    RemXForm.ShowInfo('������ ������ �� �������.');
    FindDialog.CloseDialog;
  end;
end;

procedure TShowBrowserForm.actFindExecute(Sender: TObject);
begin
  LoadKeyboardLayout('00000409',KLF_ACTIVATE);
  FindDialog.Execute;
end;

procedure TShowBrowserForm.actBackExecute(Sender: TObject);
begin
  BackPopupMenu.Items.Items[0].Click;
end;

procedure TShowBrowserForm.actBackUpdate(Sender: TObject);
begin
  actBack.Enabled:=BackPopupMenu.Items.Count > 0
end;

procedure TShowBrowserForm.actForwardExecute(Sender: TObject);
begin
  ForwardPopupMenu.Items.Items[0].Click;
end;

procedure TShowBrowserForm.actForwardUpdate(Sender: TObject);
begin
  actForward.Enabled:=ForwardPopupMenu.Items.Count > 0
end;

procedure TShowBrowserForm.BackPopupMenuChange(Sender: TObject;
  Source: TMenuItem; Rebuild: Boolean);
begin
  if BackPopupMenu.Items.Count > 0 then
    actBack.Hint:='����� �� '+BackPopupMenu.Items.Items[0].Caption
  else
    actBack.Hint:='�����';
end;

procedure TShowBrowserForm.ForwardPopupMenuChange(Sender: TObject;
  Source: TMenuItem; Rebuild: Boolean);
begin
  if ForwardPopupMenu.Items.Count > 0 then
    actForward.Hint:='����� �� '+ForwardPopupMenu.Items.Items[0].Caption
  else
    actForward.Hint:='�����';
end;

procedure TShowBrowserForm.TVBaseChanging(Sender: TObject; Node: TTreeNode;
  var AllowChange: Boolean);
var M: TMenuItem; S: string; N: TTreeNode;
begin
  N:=TVBase.Selected;
  S:=GetTreePath;
  if Length(S) > 0 then
  begin
    M:=TMenuItem.Create(Self);
    M.Caption:=S;
    M.OnClick:=BackPopupMenuClick;
    M.Tag:=Longint(N);
    BackPopupMenu.Items.Insert(0,M);
    if BackPopupMenu.Items.Count = 9 then
      BackPopupMenu.Items[8].Free;;
  end;
  ForwardPopupMenu.Items.Clear;
end;

function TShowBrowserForm.GetTreePath: string;
var N: TTreeNode;
begin
  N:=TVBase.Selected;
  Result:='';
  while N <> nil do
  begin
    Result:=N.Text+'\'+Result;
    N:=N.Parent;
  end;
  if Length(Result) > 0 then
    Result:=Copy(Result,1,Length(Result)-1);
end;

procedure TShowBrowserForm.BackPopupMenuClick(Sender: TObject);
var S: string; M: TMenuItem;
begin
  TVBase.OnChanging:=TreeViewAlterChanging;
  M:=Sender as TMenuItem;
  S:=M.Caption;
  TVBase.Selected:=TTreeNode(M.Tag);
  while (BackPopupMenu.Items.Count > 0) and
        (BackPopupMenu.Items.Items[0].Caption <> S) do
  begin
    M:=TMenuItem.Create(Self);
    M.Caption:=BackPopupMenu.Items.Items[0].Caption;
    M.Tag:=BackPopupMenu.Items.Items[0].Tag;
    M.OnClick:=ForwardPopupMenuClick;
    ForwardPopupMenu.Items.Insert(0,M);
    BackPopupMenu.Items[0].Free;
  end;
  if BackPopupMenu.Items.Count > 0 then BackPopupMenu.Items[0].Free;
  TVBase.OnChanging:=TVBaseChanging;
end;

procedure TShowBrowserForm.TreeViewAlterChanging(Sender: TObject;
  Node: TTreeNode; var AllowChange: Boolean);
var M: TMenuItem; S: string; N: TTreeNode;
begin
  N:=TVBase.Selected;
  S:=GetTreePath;
  if Length(S) > 0 then
  begin
    M:=TMenuItem.Create(Self);
    M.Caption:=S;
    M.OnClick:=ForwardPopupMenuClick;
    M.Tag:=Longint(N);
    ForwardPopupMenu.Items.Insert(0,M);
    if ForwardPopupMenu.Items.Count = 9 then
      ForwardPopupMenu.Items[8].Free;
  end;
end;

procedure TShowBrowserForm.ForwardPopupMenuClick(Sender: TObject);
var S: string; M: TMenuItem;
begin
  TVBase.OnChanging:=TreeViewAlterChanging;
  M:=Sender as TMenuItem;
  S:=M.Caption;
  TVBase.Selected:=TTreeNode(M.Tag);
  while (ForwardPopupMenu.Items.Count > 0) and
        (ForwardPopupMenu.Items.Items[0].Caption <> S) do
  begin
    M:=TMenuItem.Create(Self);
    M.Caption:=ForwardPopupMenu.Items.Items[0].Caption;
    M.Tag:=ForwardPopupMenu.Items.Items[0].Tag;
    M.OnClick:=BackPopupMenuClick;
    BackPopupMenu.Items.Insert(0,M);
    ForwardPopupMenu.Items[0].Free;
  end;
  if ForwardPopupMenu.Items.Count > 0 then ForwardPopupMenu.Items[0].Free;
  TVBase.OnChanging:=TVBaseChanging;
end;

procedure TShowBrowserForm.actUpperExecute(Sender: TObject);
begin
  TVBase.Selected:=TVBase.Selected.Parent;
end;

procedure TShowBrowserForm.actUpperUpdate(Sender: TObject);
begin
  actUpper.Enabled:=(TVBase.Selected <> nil) and (TVBase.Selected.Level > 0);
end;

procedure TShowBrowserForm.LVBaseCustomDrawSubItem(Sender: TCustomListView;
  Item: TListItem; SubItem: Integer; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  if Assigned(Item.Data) then
  begin
    case SubItem of
  0..3: if Assigned(TEntity(Item.Data).SourceEntity) then
          LVBase.Canvas.Font.Color:=$00909090
        else
          LVBase.Canvas.Font.Color:=clBlack;
     4: if not TEntity(Item.Data).Actived then
        begin
          if Assigned(TEntity(Item.Data).SourceEntity) then
            LVBase.Canvas.Font.Color:=$009090FF
          else
            LVBase.Canvas.Font.Color:=clRed;
        end
        else if Assigned(TEntity(Item.Data).SourceEntity) then
               LVBase.Canvas.Font.Color:=$00909090
             else
               LVBase.Canvas.Font.Color:=clBlack;
     5: if not TEntity(Item.Data).Logged then
        begin
          if Assigned(TEntity(Item.Data).SourceEntity) then
            LVBase.Canvas.Font.Color:=$009090FF
          else
            LVBase.Canvas.Font.Color:=clRed;
        end
        else if Assigned(TEntity(Item.Data).SourceEntity) then
               LVBase.Canvas.Font.Color:=$00909090
             else
               LVBase.Canvas.Font.Color:=clBlack;
     6: if not TEntity(Item.Data).Asked then
        begin
          if Assigned(TEntity(Item.Data).SourceEntity) then
            LVBase.Canvas.Font.Color:=$009090FF
          else
            LVBase.Canvas.Font.Color:=clRed;
        end
        else if Assigned(TEntity(Item.Data).SourceEntity) then
               LVBase.Canvas.Font.Color:=$00909090
             else
               LVBase.Canvas.Font.Color:=clBlack;
   7,8: if Assigned(TEntity(Item.Data).SourceEntity) then
          LVBase.Canvas.Font.Color:=$00909090
        else
          LVBase.Canvas.Font.Color:=clBlack;
    else
      LVBase.Canvas.Font.Color:=clBlack;
    end;
  end;
end;

procedure TShowBrowserForm.ConnectEntity(Entity: TEntity);
begin
// Stub
end;

procedure TShowBrowserForm.ConnectImageList(ImageList: TImageList);
begin
  SmallImageList:=ImageList;
  LVBase.SmallImages:=ImageList;
  LVErrors.SmallImages:=ImageList;
  TVBase.Images:=ImageList;
  NewPopupMenu.Images:=ImageList;
end;

procedure TShowBrowserForm.UpdateRealTime;
var Flag: boolean;
begin
  Flag:=(Caddy.UserLevel > 4);
  tbNewEntity.Visible:=Flag;
  actSaveBase.Visible:=Flag;
  ToolButton7.Visible:=Flag;
  ToolButton8.Visible:=Flag;
  actImport.Visible:=Flag;
end;

procedure TShowBrowserForm.FormShow(Sender: TObject);
begin
  UpdateRealTime;
end;

function CompareAscListPtNames(Item1,Item2: Pointer): integer;
begin
  Result:=CompareText(TEntity(Item1).PtName,TEntity(Item2).PtName);
end;

function CompareDescListPtNames(Item1,Item2: Pointer): integer;
begin
  Result:=CompareText(TEntity(Item2).PtName,TEntity(Item1).PtName);
end;

function CompareAscListPtDescs(Item1,Item2: Pointer): integer;
begin
  Result:=CompareText(TEntity(Item1).PtDesc,TEntity(Item2).PtDesc);
end;

function CompareDescListPtDescs(Item1,Item2: Pointer): integer;
begin
  Result:=CompareText(TEntity(Item2).PtDesc,TEntity(Item1).PtDesc);
end;

procedure TShowBrowserForm.LVBaseColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  case Column.Index of
    0: begin
         if Column.Tag=0 then
         begin
           EntityList.Sort(@CompareAscListPtNames);
           Column.Tag:=1;
         end
         else
         begin
           EntityList.Sort(@CompareDescListPtNames);
           Column.Tag:=0;
         end;
         LVBase.Columns[1].Tag:=0;
       end;
    1: begin
         if Column.Tag=0 then
         begin
           EntityList.Sort(@CompareAscListPtDescs);
           Column.Tag:=1;
         end
         else
         begin
           EntityList.Sort(@CompareDescListPtDescs);
           Column.Tag:=0;
         end;
         LVBase.Columns[0].Tag:=0;
       end;
  end;
  LVBase.Repaint;
end;

procedure TShowBrowserForm.actImportExecute(Sender: TObject);
var i: integer;
begin
  if RemxForm.ShowQuestion(
    '������������ ���� ������ ����� �������! ����������?')=mrOk then
  begin
    Panel.Clock.Enabled:=False;
    Panel.Fresh.Enabled:=False;
    for i:=0 to ChannelCount do Caddy.FetchList[i].List.Clear;
    try
      actOpenOldEntity.Execute;
      UpdateBaseView;
    finally
      Panel.Clock.Enabled:=True;
      Panel.Fresh.Enabled:=True;
    end;
  end;
end;

procedure TShowBrowserForm.actExportToExcelExecute(Sender: TObject);
var XL,TableVals,SEL: Variant; Len,i,j,k,RowCount,ColCount: integer;
    TableName,TypeSign,ColChar: string; E: TEntity; L: TStringList;
begin
  SaveExtDialogForm:=TSaveExtDialogForm.Create(Self);
  try
    SaveExtDialogForm.Filter:='������� ���� Microsoft Excel|*.xls';
    SaveExtDialogForm.InitialDir:=Caddy.CurrentBasePath;
    SaveExtDialogForm.FileName:='';
    SaveExtDialogForm.DefaultExt:='.xls';
    if SaveExtDialogForm.Execute then
    begin
      Update;
      try
        XL := CreateOleObject('Excel.Application');
      except
        raise Exception.Create('�� ���� ��������� Excel');
      end;
      Screen.Cursor:=crHourGlass;
      try
        XL.SheetsInNewWorkbook:=1;
        XL.WorkBooks.Add;
        Len:=EntityClassList.Count;
        for i:=0 to Len-1 do
        begin
          RowCount:=0;
          TypeSign:='';
          L:=TStringList.Create;
          try
            for k:=0 to LVBase.Items.Count-1 do
            begin
              E:=TEntity(LVBase.Items[k].Data);
              if E.ClassType = EntityClassList[i] then
              begin
                TypeSign:=E.TypeCode+'-'+E.EntityType;
                L.AddObject(E.PtName,E);
                Inc(RowCount);
              end;
            end;
            if RowCount = 0 then Continue;
            Inc(RowCount); // + ���������
            L.Sort;
            E:=L.Objects[0] as TEntity;
            ColCount:=E.PropsCount+1;
            TableVals:=VarArrayCreate([0,RowCount, //���-�� �����
                                       0,ColCount], // ���-�� ��������
                                       varOleStr);
            TableVals[0,0]:='� �/�';
            for k:=0 to ColCount-1 do
              TableVals[0,k+1]:=E.PropsName(k);
            for j:=0 to L.Count-1 do
            begin
              E:=L.Objects[j] as TEntity;
              TableVals[j+1,0]:=j+1;
              for k:=0 to E.PropsCount-1 do
                TableVals[j+1,k+1]:=E.PropsValue(k);
            end;
          finally
            L.Free;
          end;
          if i > 0 then  XL.Sheets.Add;
          XL.Sheets[1].Select;
          XL.Sheets[1].Name:=Copy(TypeSign,1,31);
          XL.Range[XL.Cells[1,1],XL.Cells[RowCount,ColCount]].Select;
          SEL:=XL.Selection;
          SEL.Value:=TableVals;
          SEL.WrapText:=False;
          SEL.Orientation:=0;
          SEL.AddIndent:=False;
          SEL.ShrinkToFit:=False;
          SEL.MergeCells:=False;
          if ColCount < 27 then
            ColChar:=Chr(Ord('A')+ColCount-1)
          else
            ColChar:='A'+Chr(Ord('A')+ColCount-27);
          XL.Range['A1',ColChar+'1'].Select;
          SEL:=XL.Selection;
          SEL.Font.Bold:=True;
          XL.Columns['A:'+ColChar].EntireColumn.AutoFit;
          XL.Range['A1','A1'].Select;
        end;;
        TableName:=SaveExtDialogForm.FileName;
        if FileExists(TableName) then DeleteFile(TableName);
        XL.ActiveWorkbook.SaveAs(
           Filename:=TableName,
           FileFormat:=$FFFFEFD1{xlNormal}, Password:='', WriteResPassword:='',
           ReadOnlyRecommended:=False, CreateBackup:=False);
        RemXForm.ShowInfo('���� ������ ������� �������������� � ���� '+
                          TableName);
      finally
        Screen.Cursor:=crDefault;
        XL.Quit;
      end;
    end;
  finally
    SaveExtDialogForm.Free;
  end;
end;

procedure TShowBrowserForm.LVErrorsData(Sender: TObject; Item: TListItem);
var L: TListItem; E: TEntity;
begin
  try
    E:=TEntity(ErrorsList[Item.Index]);
    L:=Item;
    L.Caption:=E.PtName;
    L.ImageIndex:=EntityClassIndex(E.ClassType)+3;
    if Length(E.ErrorMess) > 0 then
      L.SubItems.Add(E.ErrorMess)
    else
    if (E.BadFetchsCount > 0) and (E.GoodFetchsCount > 0) then
      L.SubItems.Add(
       Format('�� �������� ����� %f %%: %d (%d) �� %d. Max ����� ������: %d ��',
                  [E.BadFetchsCount*100.0/E.GoodFetchsCount,
      E.BadFetchsCount,E.BadFatalFetchsCount,E.GoodFetchsCount,E.MaxAnswerTime]))
    else
      L.SubItems.Add('��� ������ ������. '+
                     '��� ��������� ����� ������� ��� ���������� �������');
    L.SubItems.Add(E.PtDesc);
    L.Data:=E;
  except
    LVErrors.Items.Count:=0;
  end;
end;

procedure TShowBrowserForm.LVErrorsDblClick(Sender: TObject);
var E: TEntity; N: TTreeNode; Nfo: TNodeInfo;
begin
  if Assigned(LVErrors.Selected) then
  begin
    E:=TEntity(LVErrors.Selected.Data);
    N:=TVBase.Items.GetFirstNode;
    while N <> nil do
    begin
      Nfo:=TNodeInfo(N.Data);
      if (Nfo <> nil) and Nfo.IsEntity and (Nfo.Entity = E) then
      begin
        TVBase.Selected:=N;
        Break;
      end;
      N:=N.GetNext;
    end;
  end;
end;

procedure TShowBrowserForm.LVErrorsPopupPopup(Sender: TObject);
var M: TMenuItem;
begin
  LVErrorsPopup.Items.Clear;
  if not (Caddy.UserLevel > 4) then Exit;
  if Assigned(LVErrors.Selected) then
  begin
    M:=TMenuItem.Create(Self);
    M.Caption:='��������';
    M.OnClick:=RebuildLVErrors;
    LVErrorsPopup.Items.Add(M);
    if Pos('�� �������� �����',LVErrors.Selected.SubItems[0]) = 1 then
    begin
      M:=TMenuItem.Create(Self);
      M.Caption:='-';
      LVErrorsPopup.Items.Add(M);
      M:=TMenuItem.Create(Self);
      M.Caption:='�������� ��������';
      M.OnClick:=ResetTimeoutCounters;
      LVErrorsPopup.Items.Add(M);
    end;
  end;
end;

procedure TShowBrowserForm.RebuildLVErrors(Sender: TObject);
begin
  UpdateLVErrors;
end;

procedure TShowBrowserForm.ResetTimeoutCounters(Sender: TObject);
var E: TEntity; i: integer;
begin
(*
  M:=Sender as TMenuItem;
  E:=TEntity(M.Tag);
  if Assigned(E) then
  begin
    E.GoodFetchsCount:=0;
    E.BadFetchsCount:=0;
    E.BadFatalFetchsCount:=0;
  end;
*)
  for i:=0 to LVErrors.Items.Count-1 do
  if LVErrors.Items[i].Selected then
  begin
    E:=TEntity(LVErrors.Items[i].Data);
    E.GoodFetchsCount:=0;
    E.BadFetchsCount:=0;
    E.BadFatalFetchsCount:=0;
  end;
  UpdateLVErrors;
end;

procedure TShowBrowserForm.TVBaseDblClick(Sender: TObject);
var i,j,k,Channel,Block,InpOut: integer;
    E: TEntity;
    Dout: TKontDigOut;
    Aout: TKontAnaOut;
    Dpar: TKontDigParam;
    Apar: TKontAnaParam;
    List,Item: TStringList;
    PtType,PtName,PtDesc,TextUp,TextDown: string;
begin
  if RemxForm.ShowQuestion(
    '������������ ���� ������ ����� �������! ����������?')=mrOk then
  begin
    Panel.Clock.Enabled:=False;
    Panel.Fresh.Enabled:=False;
    for i:=0 to ChannelCount do Caddy.FetchList[i].List.Clear;
    try
      TVBase.Items.Clear;
      LVBase.Items.Clear;
      with Caddy do
      begin
        EmptyBase;
        ActiveAlarmLog.Clear;
        ActiveSwitchLog.Clear;
//---- ������� ������������ ����� -----
        for i:=1 to 125 do
        begin
          HistGroups[i].GroupName:='';
          HistGroups[i].Empty:=True;
          for j:=1 to 8 do
          begin
            HistGroups[i].Place[j]:='';
            HistGroups[i].Entity[j]:=nil;
            HistGroups[i].Kind[j]:=0;
            HistGroups[i].EU[j]:='';
            HistGroups[i].DF[j]:=1;
          end;
        end;
      end;
      List:=TStringList.Create;
      Item:=TStringList.Create;
      try
        List.LoadFromFile(ExtractFilePath(Application.ExeName)+'jrnovsk.txt');
        for i:=0 to List.Count-1 do
        begin
          Item.CommaText:=List[i];
          Channel:=StrToInt(Item[0]);
          Block:=StrToInt(Item[1]);
          PtType:=Item[2];
          InpOut:=StrToInt(Item[3]);
          PtName:=Item[4];
          PtDesc:=Item[5];
          if PtType = 'DI' then
          begin
            TextUp:=Item[6];
            TextDown:=Item[7];
            k:=EntityClassIndex(KontrastUnit.TKontDigOut);
            Dout:=KontrastUnit.TKontDigOut(Caddy.AddEntity(PtName,k,
                                     TEntityClass(EntityClassList[k])));
            Dout.Channel:=Channel;
            Dout.Node:=1;
            Dout.Block:=Block;
            Dout.Place:=InpOut;
            Dout.PtDesc:=PtDesc;
            Dout.TextUp:=TextUp;
            Dout.TextDown:=TextDown;
            if (TextUp = '�������') or
               (TextUp = '������') or
               (TextUp = '�������') or
               (TextUp = '������') or
               (TextUp = '���') then
            begin
//  StringDigColor : array[TDigColor] of string =
//    ('׸����','Ҹ���-�����','����������','����������',
//     '�����','�������','�������','Ҹ���-���������',
//     '��������','������','����-������','���������',
//     'Ƹ����','Ҹ���-�����','������-�����','�����');
              Dout.ColorUp:=10;
              Dout.ColorDown:=6;
            end
            else
            begin
              Dout.AlarmUp:=True;
              Dout.ColorUp:=6;
              Dout.ColorDown:=0;
            end;
            Dout.Logged:=True;
            Dout.Asked:=True;
          end;
          if PtType = 'DO' then
          begin
            k:=EntityClassIndex(KontrastUnit.TKontDigParam);
            Dpar:=KontrastUnit.TKontDigParam(Caddy.AddEntity(PtName,k,
                                     TEntityClass(EntityClassList[k])));
            Dpar.Channel:=Channel;
            Dpar.Node:=1;
            Dpar.Block:=Block;
            Dpar.Place:=InpOut;
            Dpar.PtDesc:=PtDesc;
          end;
          if PtType = 'AI' then
          begin
            k:=EntityClassIndex(KontrastUnit.TKontAnaOut);
            Aout:=KontrastUnit.TKontAnaOut(Caddy.AddEntity(PtName,k,
                                     TEntityClass(EntityClassList[k])));
            Aout.Channel:=Channel;
            Aout.Node:=1;
            Aout.Block:=Block;
            Aout.Place:=InpOut;
            Aout.PtDesc:=PtDesc;
          end;
          if PtType = 'AO' then
          begin
            k:=EntityClassIndex(KontrastUnit.TKontAnaParam);
            Apar:=KontrastUnit.TKontAnaParam(Caddy.AddEntity(PtName,k,
                                     TEntityClass(EntityClassList[k])));
            Apar.Channel:=Channel;
            Apar.Node:=1;
            Apar.Block:=Block;
            Apar.Place:=InpOut;
            Apar.PtDesc:=PtDesc;
          end;
        end;
      finally
        Item.Free;
        List.Free;
      end;

      UpdateTreeView;
      with Caddy do
      begin
//---- ����������� ������ ������ ���� ������ -----
        E:=FirstEntity;
        while E <> nil do
        begin
          E.ConnectLinks;
          E:=E.NextEntity;
        end;
//---- ����������� ������ ������ ������������ ����� -----
        for i:=1 to 125 do
          for j:=1 to 8 do
            HistGroups[i].Entity[j]:=Find(HistGroups[i].Place[j]);
      end;
      Caddy.Changed:=True;
      Caddy.HistChanged:=True;
      UpdateBaseView;
    finally
      Panel.Clock.Enabled:=True;
      Panel.Fresh.Enabled:=True;
    end;
  end;
end;

procedure TShowBrowserForm.actSchemeShowExecute(Sender: TObject);
var N: TTreeNode; Nfo: TNodeInfo; E: TEntity;
begin
  if (TVBase.Selected <> nil) and (TVBase.Selected.Data <> nil) and
     TNodeInfo(TVBase.Selected.Data).IsEntity then
  begin
    N:=TVBase.Selected;
    if N <> nil then
    begin
      Nfo:=TNodeInfo(N.Data);
      if (Nfo <> nil) and Nfo.IsEntity then
      begin
        E:=Nfo.Entity;
        E.ShowScheme(Monitor.MonitorNum);
      end;
    end;
  end
  else
  if (LVBase.Selected <> nil) and (TEntity(LVBase.Selected.Data) is TEntity) then
    (TEntity(LVBase.Selected.Data).ShowScheme(Monitor.MonitorNum));
end;

procedure TShowBrowserForm.actSchemeShowUpdate(Sender: TObject);
begin
  actSchemeShow.Enabled:=(TVBase.Selected <> nil) and
                         (TVBase.Selected.Data <> nil) and
                         TNodeInfo(TVBase.Selected.Data).IsEntity and
                         (TNodeInfo(TVBase.Selected.Data).Entity.LinkScheme <> '')
                        or
                         (LVBase.Selected <> nil) and
                         (TEntity(LVBase.Selected.Data) is TEntity) and
                         (TEntity(LVBase.Selected.Data).LinkScheme <> '');
end;

procedure TShowBrowserForm.SetTopForm(const Value: TForm);
begin
  FTopForm := Value;
end;

end.
