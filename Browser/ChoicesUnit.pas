unit ChoicesUnit;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Forms, Dialogs, Controls,
  StdCtrls, Buttons, ComCtrls, EntityUnit;

type
  TDualListDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    SrcLabel: TLabel;
    DstLabel: TLabel;
    IncludeBtn: TSpeedButton;
    IncAllBtn: TSpeedButton;
    ExcludeBtn: TSpeedButton;
    ExAllBtn: TSpeedButton;
    SrcList: TListView;
    DstList: TListView;
    MoveUpBtn: TSpeedButton;
    MoveDownBtn: TSpeedButton;
    procedure IncludeBtnClick(Sender: TObject);
    procedure ExcludeBtnClick(Sender: TObject);
    procedure IncAllBtnClick(Sender: TObject);
    procedure ExcAllBtnClick(Sender: TObject);
    procedure SrcListCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure MoveUpBtnClick(Sender: TObject);
    procedure MoveDownBtnClick(Sender: TObject);
    procedure DstListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure SrcListColumnClick(Sender: TObject; Column: TListColumn);
  private
  public
    procedure MoveSelected(List: TListView; Items: TListItems);
    procedure SetItem(List: TListView; Index: Integer);
    function GetFirstSelection(List: TListView): Integer;
    procedure SetButtons;
  end;

function GetDualLinkNameDlg(AOwner: TForm; AList: TList; AIL: TImageList;
                            Grp: TCustomGroup; EList: TList): boolean;

implementation



{$R *.dfm}

function GetDualLinkNameDlg(AOwner: TForm; AList: TList; AIL: TImageList;
                            Grp: TCustomGroup; EList: TList): boolean;
var DualListDlg: TDualListDlg; i: integer; L: TListItem; E: TEntity;
begin
  Result:=False;
  DualListDlg:=TDualListDlg.Create(AOwner);
  try
    with DualListDlg do
    begin
      SrcList.SmallImages:=AIL;
      DstList.SmallImages:=AIL;
      for i:=0 to AList.Count-1 do
      begin
        E:=TEntity(AList[i]);
        L:=SrcList.Items.Add;
        L.Caption:=E.PtName;
        L.ImageIndex:=EntityClassIndex(E.ClassType)+3;
        L.SubItems.Add(E.PtDesc);
        L.Data:=E;
      end;
      for i:=0 to Grp.Count-1 do
      begin
        E:=TEntity(Grp.EntityChilds[i]);
        if Assigned(E) then
        begin
          L:=DstList.Items.Add;
          L.Caption:=E.PtName;
          L.ImageIndex:=EntityClassIndex(E.ClassType)+3;
          L.SubItems.Add(E.PtDesc);
          L.Data:=E;
        end;
      end;
      DstList.Tag:=Grp.GetMaxChildCount;
      SetButtons;
      if ShowModal = mrOk then
      begin
        while Grp.Count > 0 do Grp.EntityChilds[0]:=nil;
        for i:=0 to DstList.Items.Count-1 do
           Grp.EntityChilds[i]:=TEntity(DstList.Items.Item[i].Data);
        if Grp.Count = 0 then Grp.Actived:=False;
        Result:=True;
      end;
    end;
  finally
    DualListDlg.Free;
  end;
end;

procedure TDualListDlg.IncludeBtnClick(Sender: TObject);
var Index: Integer;
begin
  while SrcList.SelCount > DstList.Tag-DstList.Items.Count do
    SrcList.Items.Item[SrcList.SelCount-1].Selected:=False;
  Index := GetFirstSelection(SrcList);
  MoveSelected(SrcList,DstList.Items);
  SetItem(SrcList,Index);
end;

procedure TDualListDlg.ExcludeBtnClick(Sender: TObject);
var Index: Integer;
begin
  Index := GetFirstSelection(DstList);
  MoveSelected(DstList,SrcList.Items);
  SetItem(DstList,Index);
end;

procedure TDualListDlg.IncAllBtnClick(Sender: TObject);
var i: integer;
begin
  for i:=0 to SrcList.Items.Count-1 do
    SrcList.Items.Item[i].Selected:=True;
  while SrcList.SelCount > DstList.Tag-DstList.Items.Count do
    SrcList.Items.Item[SrcList.SelCount-1].Selected:=False;
  MoveSelected(SrcList,DstList.Items);
  SetItem(SrcList,0);
end;

procedure TDualListDlg.ExcAllBtnClick(Sender: TObject);
var i: integer; L: TListItem;
begin
  for i:=0 to DstList.Items.Count-1 do
  begin
    L:=SrcList.Items.Add;
    L.Caption:=DstList.Items[i].Caption;
    L.ImageIndex:=DstList.Items[i].ImageIndex;
    L.SubItems.Assign(DstList.Items[i].SubItems);
    L.Data:=DstList.Items[i].Data;
  end;
  DstList.Items.Clear;
  SetItem(DstList,0);
end;

procedure TDualListDlg.MoveSelected(List: TListView; Items: TListItems);
var i: integer; L: TListItem;
begin
  for i:=List.Items.Count-1 downto 0 do
    if List.Items.Item[i].Selected then
    begin
      L:=Items.Add;
      L.Caption:=List.Items[i].Caption;
      L.ImageIndex:=List.Items[i].ImageIndex;
      L.SubItems.Assign(List.Items[i].SubItems);
      L.Data:=List.Items[i].Data;
      List.Items.Delete(i);
    end;
end;

procedure TDualListDlg.SetButtons;
var SrcEmpty, DstEmpty: Boolean;
begin
  SrcEmpty := SrcList.Items.Count = 0;
  DstEmpty := DstList.Items.Count = 0;
  IncludeBtn.Enabled := not SrcEmpty and (DstList.Items.Count < DstList.Tag);
  IncAllBtn.Enabled := not SrcEmpty and (DstList.Items.Count < DstList.Tag);
  ExcludeBtn.Enabled := not DstEmpty;
  ExAllBtn.Enabled := not DstEmpty;
  MoveUpBtn.Enabled := not DstEmpty and (DstList.Selected <> nil) and
                       (DstList.Items.Item[0] <> DstList.Selected) and
                       (DstList.SelCount = 1);
  MoveDownBtn.Enabled := not DstEmpty and (DstList.Selected <> nil) and
            (DstList.Items.Item[DstList.Items.Count-1] <> DstList.Selected) and
            (DstList.SelCount = 1);
end;

function TDualListDlg.GetFirstSelection(List: TListView): Integer;
begin
  for Result:=0 to List.Items.Count-1 do
    if List.Items.Item[Result].Selected then Exit;
  Result:=LB_ERR;
end;

procedure TDualListDlg.SetItem(List: TListView; Index: Integer);
var MaxIndex: integer;
begin
  with List do
  begin
    SetFocus;
    MaxIndex := List.Items.Count-1;
    if Index = LB_ERR then Index:=0
    else if Index > MaxIndex then Index:=MaxIndex;
    if Index >=0 then
      Items.Item[Index].Selected := True;
  end;
  SetButtons;
end;

procedure TDualListDlg.SrcListCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  if SrcList.SortType = stText then
  begin
    if Item1.Caption > Item2.Caption then
      Compare:=1
    else
    if Item2.Caption > Item1.Caption then
      Compare:=-1
    else
      Compare:=0;
  end
  else
  if (Item1.SubItems.Count > 0) and (Item2.SubItems.Count > 0) then
  begin
    if Item1.SubItems[0] > Item2.SubItems[0] then
      Compare:=1
    else
    if Item2.SubItems[0] > Item1.SubItems[0] then
      Compare:=-1
    else
      Compare:=0;
  end;
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

procedure TDualListDlg.MoveUpBtnClick(Sender: TObject);
var i,Img: integer; S1,S2: string; Obj: TObject;
begin
  if DstList.Selected <> nil then
  begin
    i:=DstList.Selected.Index;
    DstList.Selected.Selected:=False;
    S1:=DstList.Items.Item[i].Caption;
    S2:=DstList.Items.Item[i].SubItems[0];
    Img:=DstList.Items.Item[i].ImageIndex;
    Obj:=TObject(DstList.Items.Item[i].Data);
    DstList.Items.Item[i].Caption:=DstList.Items.Item[i-1].Caption;
    DstList.Items.Item[i].SubItems[0]:=DstList.Items.Item[i-1].SubItems[0];
    DstList.Items.Item[i].Data:=DstList.Items.Item[i-1].Data;
    DstList.Items.Item[i].ImageIndex:=DstList.Items.Item[i-1].ImageIndex;
    DstList.Items.Item[i-1].Caption:=S1;
    DstList.Items.Item[i-1].SubItems[0]:=S2;
    DstList.Items.Item[i-1].Data:=Obj;
    DstList.Items.Item[i-1].ImageIndex:=Img;
    DstList.Selected:=DstList.Items.Item[i-1];
    DstList.Invalidate;
    SetButtons;
  end;
end;

procedure TDualListDlg.MoveDownBtnClick(Sender: TObject);
var i,Img: integer; S1,S2: string; Obj: TObject;
begin
  if DstList.Selected <> nil then
  begin
    i:=DstList.Selected.Index;
    DstList.Selected.Selected:=False;
    S1:=DstList.Items.Item[i].Caption;
    S2:=DstList.Items.Item[i].SubItems[0];
    Img:=DstList.Items.Item[i].ImageIndex;
    Obj:=TObject(DstList.Items.Item[i].Data);
    DstList.Items.Item[i].Caption:=DstList.Items.Item[i+1].Caption;
    DstList.Items.Item[i].SubItems[0]:=DstList.Items.Item[i+1].SubItems[0];
    DstList.Items.Item[i].Data:=DstList.Items.Item[i+1].Data;
    DstList.Items.Item[i].ImageIndex:=DstList.Items.Item[i+1].ImageIndex;
    DstList.Items.Item[i+1].Caption:=S1;
    DstList.Items.Item[i+1].SubItems[0]:=S2;
    DstList.Items.Item[i+1].Data:=Obj;
    DstList.Items.Item[i+1].ImageIndex:=Img;
    DstList.Selected:=DstList.Items.Item[i+1];
    DstList.Invalidate;
    SetButtons;
  end;
end;

procedure TDualListDlg.DstListSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  SetButtons;
end;

procedure TDualListDlg.SrcListColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  case Column.Index of
    0: SrcList.SortType:=stText;
    1: SrcList.SortType:=stData;
  end;
  if SrcList.Selected <> nil then
    SrcList.Selected.MakeVisible(False);
end;

end.
