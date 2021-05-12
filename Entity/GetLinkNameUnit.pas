unit GetLinkNameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, EntityUnit, ExtCtrls, ComCtrls, AppEvnts;

type
  TGetLinkNameDlg = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    ListView1: TListView;
    Button3: TButton;
    ApplicationEvents1: TApplicationEvents;
    procedure ListView1Data(Sender: TObject; Item: TListItem);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure Button3Click(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure ListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListView1DblClick(Sender: TObject);
  private
    List: TList;
    SList: TStringList;
  public
  end;

function GetLinkNameDlg(AOwner: TForm; ACaption: string;
                        AList: TStringList; AIL: TImageList;
                        var E: TEntity; var Kind: byte): boolean; overload;

function GetLinkNameDlg(AOwner: TForm; ACaption: string;
                        AList: TList; AIL: TImageList;
                        var E: TEntity; EList: TList = nil): boolean; overload;

implementation

uses RemXUnit;

{$R *.dfm}

procedure SaveInfo(LV: TListView; ED: TEdit; PtName: string);
var S: string;
begin
  S:='LinkNameDlg';
  Config.WriteInteger(S,'Column0',LV.Column[0].Tag);
  Config.WriteInteger(S,'Column1',LV.Column[1].Tag);
  Config.WriteString(S,'PtName',PtName);
  Config.WriteInteger(S,'Kind',ED.Tag);
  Config.UpdateFile;
end;

procedure LoadInfo(LV: TListView; ED: TEdit; var PtName: string);
var S: string;
begin
  S:='LinkNameDlg';
  LV.Column[0].Tag:=Config.ReadInteger(S,'Column0',0);;
  LV.Column[1].Tag:=Config.ReadInteger(S,'Column1',0);
  PtName:=Config.ReadString(S,'PtName','');
  ED.Tag:=Config.ReadInteger(S,'Kind',0);
end;

function GetLinkNameDlg(AOwner: TForm; ACaption: string;
                        AList: TStringList; AIL: TImageList;
                        var E: TEntity; var Kind: byte): boolean; overload;
var LinkNameDlg: TGetLinkNameDlg; i: integer; S: string;
begin
  Result:=False;
  LinkNameDlg:=TGetLinkNameDlg.Create(AOwner);
  try
    with LinkNameDlg do
    begin
      SList:=AList;
      Label1.Caption:=ACaption+':';
      ListView1.SmallImages:=AIL;
      ListView1.Items.Count:=SList.Count;
      if Assigned(E) then
      begin
        Edit1.Text:=E.PtName+'.'+AParamKind[Kind]+' - '+E.PtDesc;
        ListView1ColumnClick(ListView1,ListView1.Column[0]);
        for i:=0 to SList.Count-1 do
        if (SList.Objects[i] = E) and (SList.Strings[i] = AParamKind[Kind]) then
        begin
          ListView1.Selected:=ListView1.Items[i];
          Break;
        end;
       if Assigned(ListView1.Selected) then
          ListView1.Selected.MakeVisible(False);
      end
      else
      begin
        Edit1.Text:='';
        ListView1ColumnClick(ListView1,ListView1.Column[0]);
      end;
//-------------------------------
      LoadInfo(ListView1,Edit1,S);
      if not Assigned(E) then
      begin
        E:=Caddy.Find(S);
        if Assigned(SList) then
          i:=SList.IndexOfObject(E)
        else
          i:=List.IndexOf(E);
        if i >= 0 then
          ListView1.Selected:=ListView1.Items[i]
        else
          ListView1.Selected:=nil;
        if Assigned(ListView1.Selected) then
          ListView1.Selected.MakeVisible(False);
      end;
//-------------------------------
      ListView1.MultiSelect:=False;
      if ShowModal = mrOk then
      begin
        S:=''; Kind:=0;
        if Trim(Edit1.Text) = '' then
        begin
          E:=nil; Kind:=0; S:='';
        end
        else
        if ListView1.Selected = nil then
        begin
          E:=nil; Kind:=0; S:='';
        end
        else
        begin
          E:=TEntity(ListView1.Selected.Data);
          Kind:=Edit1.Tag; S:=E.PtName;
        end;
        SaveInfo(ListView1,Edit1,S);
        Result:=True;
      end;
    end;
  finally
    LinkNameDlg.Free;
  end;
end;

function GetLinkNameDlg(AOwner: TForm; ACaption: string;
                        AList: TList; AIL: TImageList;
                        var E: TEntity; EList: TList = nil): boolean; overload;
var LinkNameDlg: TGetLinkNameDlg; i: integer; S: string;
begin
  Result:=False;
  LinkNameDlg:=TGetLinkNameDlg.Create(AOwner);
  try
    with LinkNameDlg do
    begin
      List:=AList;
      Label1.Caption:=ACaption+':';
      ListView1.SmallImages:=AIL;
      ListView1.Items.Count:=List.Count;
      if Assigned(E) then
      begin
        Edit1.Text:=E.PtName+' - '+E.PtDesc;
        ListView1ColumnClick(ListView1,ListView1.Column[0]);
        for i:=0 to List.Count-1 do
        if List[i] = E then
        begin
          ListView1.Selected:=ListView1.Items[i];
          Break;
        end;
        if Assigned(ListView1.Selected) then
          ListView1.Selected.MakeVisible(False);
      end
      else
      begin
        Edit1.Text:='';
        ListView1ColumnClick(ListView1,ListView1.Column[0]);
      end;
//-------------------------------
      LoadInfo(ListView1,Edit1,S);
      if not Assigned(E) then
      begin
        E:=Caddy.Find(S);
        if Assigned(SList) then
          i:=SList.IndexOfObject(E)
        else
          i:=List.IndexOf(E);
        if i >= 0 then
          ListView1.Selected:=ListView1.Items[i]
        else
          ListView1.Selected:=nil;
        if Assigned(ListView1.Selected) then
          ListView1.Selected.MakeVisible(False);
      end;
//-------------------------------
      ListView1.MultiSelect:=Assigned(EList);
      ListView1.Columns[0].Tag:=1;
      if ShowModal = mrOk then
      begin
        if Trim(Edit1.Text) = '' then
          E:=nil
        else
        if ListView1.Selected = nil then
          E:=nil
        else
        begin
          E:=TEntity(ListView1.Selected.Data);
          if Assigned(EList) and (ListView1.SelCount > 1) then
          begin
            EList.Clear;
            for i:=0 to ListView1.Items.Count-1 do
            if ListView1.Items[i].Selected then
              EList.Add(ListView1.Items[i].Data);
          end;
        end;
        if Assigned(E) then S:=E.PtName else S:='';
        SaveInfo(ListView1,Edit1,S);
        Result:=True;
      end;
    end;
  finally
    LinkNameDlg.Free;
  end;
end;

procedure TGetLinkNameDlg.ListView1Data(Sender: TObject; Item: TListItem);
var L: TListItem; E: TEntity;
begin
  if Assigned(SList) then
    E:=TEntity(SList.Objects[Item.Index])
  else
    E:=TEntity(List[Item.Index]);
  L:=Item;
  if Assigned(E) then
  begin
    if Assigned(SList) then
      L.Caption:=E.PtName+'.'+SList.Strings[Item.Index]
    else
      L.Caption:=E.PtName;
    L.ImageIndex:=EntityClassIndex(E.ClassType)+3;
    L.SubItems.Add(E.PtDesc);
    L.Data:=E;
  end;
end;

procedure TGetLinkNameDlg.ListView1SelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
var E: TEntity; S: string;
begin
  if Assigned(Item) then
  begin
    E:=TEntity(Item.Data);
    if Assigned(SList) then
    begin
      S:=SList.Strings[Item.Index];
      if S = 'SP' then
        Edit1.Tag:=1
      else
      if S = 'OP' then
        Edit1.Tag:=2
      else
        Edit1.Tag:=0;
      Edit1.Text:=E.PtName+'.'+S+' - '+E.PtDesc;
    end
    else
      Edit1.Text:=E.PtName+' - '+E.PtDesc;
  end;
end;

procedure TGetLinkNameDlg.Button3Click(Sender: TObject);
begin
  if RemxForm.ShowQuestion('Удалить связь "'+Trim(Edit1.Text)+'"?')=mrOK then
  begin
    Edit1.Text:='';
    Button1.Click;
  end;
end;

procedure TGetLinkNameDlg.ApplicationEvents1Idle(Sender: TObject;
  var Done: Boolean);
begin
  Button3.Enabled:=(Trim(Edit1.Text) <> '') and (ListView1.SelCount = 1);
  Button1.Enabled:=(ListView1.Selected <> nil);
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

function CompareAscSListPtNames(List: TStringList; Index1,Index2: integer): integer;
begin
  Result:=CompareText((List.Objects[Index1] as TEntity).PtName+List[Index1],
                      (List.Objects[Index2] as TEntity).PtName+List[Index2]);
end;

function CompareDescSListPtNames(List: TStringList; Index1,Index2: integer): integer;
begin
  Result:=CompareText((List.Objects[Index2] as TEntity).PtName+List[Index2],
                      (List.Objects[Index1] as TEntity).PtName+List[Index1]);
end;

function CompareAscSListPtDescs(List: TStringList; Index1,Index2: integer): integer;
begin
  Result:=CompareText((List.Objects[Index1] as TEntity).PtDesc,
                      (List.Objects[Index2] as TEntity).PtDesc);
end;

function CompareDescSListPtDescs(List: TStringList; Index1,Index2: integer): integer;
begin
  Result:=CompareText((List.Objects[Index2] as TEntity).PtDesc,
                      (List.Objects[Index1] as TEntity).PtDesc);
end;

procedure TGetLinkNameDlg.ListView1ColumnClick(Sender: TObject;
  Column: TListColumn);
var E: TEntity; Item: TListItem; i: integer;
begin
  E:=nil;
  if Assigned(ListView1.Selected) then
  begin
    Item:=ListView1.Selected;
    if Assigned(SList) then
      E:=TEntity(SList.Objects[Item.Index])
    else
      E:=TEntity(List[Item.Index]);
  end;
  case Column.Index of
    0: begin
         if Column.Tag=0 then
         begin
           if Assigned(SList) then
             SList.CustomSort(@CompareAscSListPtNames)
           else
             List.Sort(@CompareAscListPtNames);
           Column.Tag:=1;
         end
         else
         begin
           if Assigned(SList) then
             SList.CustomSort(@CompareDescSListPtNames)
           else
             List.Sort(@CompareDescListPtNames);
           Column.Tag:=0;
         end;
         ListView1.Columns[1].Tag:=0;
       end;
    1: begin
         if Column.Tag=0 then
         begin
           if Assigned(SList) then
             SList.CustomSort(@CompareAscSListPtDescs)
           else
             List.Sort(@CompareAscListPtDescs);
           Column.Tag:=1;
         end
         else
         begin
           if Assigned(SList) then
             SList.CustomSort(@CompareDescSListPtDescs)
           else
             List.Sort(@CompareDescListPtDescs);
           Column.Tag:=0;
         end;
         ListView1.Columns[0].Tag:=0;
       end;
  end;
  ListView1.Repaint;
  if Assigned(E) then
  begin
    if Assigned(SList) then
      i:=SList.IndexOfObject(E)
    else
      i:=List.IndexOf(E);
    if i >= 0 then
      ListView1.Selected:=ListView1.Items[i]
    else
      ListView1.Selected:=nil;
    if Assigned(ListView1.Selected) then
      ListView1.Selected.MakeVisible(False);
  end;
end;

procedure TGetLinkNameDlg.ListView1DblClick(Sender: TObject);
begin
  if Button1.Enabled then Button1.Click;
end;

end.
