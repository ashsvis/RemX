unit VirtCAEditUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, VirtNNEditUnit, VirtualUnit, EntityUnit;

type
  TVirtCAEditForm = class(TVirtNNEditForm)
  private
    { Private declarations }
    E: TVirtCalc;
    procedure ChangeLinkClick(Sender: TObject);
    procedure DeleteLinkClick(Sender: TObject);
    procedure ChangeFormulaClick(Sender: TObject);
    procedure DeleteFormulaClick(Sender: TObject);
  protected
    procedure ConnectEntity(Entity: TEntity); override;
    procedure PopupMenu1Popup(Sender: TObject); override;
    procedure ChangeFloatClick(Sender: TObject); override;
  public
    { Public declarations }
  end;

var
  VirtCAEditForm: TVirtCAEditForm;

implementation

{$R *.dfm}

uses ComCtrls, Menus, GetLinkNameUnit, RemXUnit, GetPtNameUnit, CAExprUnit;

{ TVirtCAEditForm }

procedure TVirtCAEditForm.ChangeFloatClick(Sender: TObject);
var L: TListItem; V: Single; i: Integer;
begin
  inherited;
  if not Assigned(E) then Exit;
  L:=ListView1.Selected;
  if Assigned(L) then
  begin
    i:=TMenuItem(Sender).Tag;
    if L.Caption = Format('C%d',[i]) then
    begin
      V:=E.AnaConst[i];
      if InputFloatDlg(L.Caption,'%g',V) then
      begin
        E.AnaConst[i]:=V;
        DecimalSeparator := '.';
        L.SubItems[0]:=Format('%g',[E.AnaConst[i]]);
      end;
    end;
  end;
end;

procedure TVirtCAEditForm.ChangeFormulaClick(Sender: TObject);
var F: TFormCAExpr; L: TListItem;
begin
  if not Assigned(E) then Exit;
  L:=ListView1.Selected;
  if Assigned(L) then
  begin
    F:=TFormCAExpr.Create(Self);
    try
      F.Index := TMenuItem(Sender).Tag;
      F.E.StepList[F.Index] := E.StepList[F.Index];
      if F.ShowModal = mrOk then
      begin
        E.StepList[F.Index] := F.E.StepList[F.Index];
        L.SubItems[0]:=E.OperationToString(F.Index);
      end;
    finally
      F.Free;
    end;
  end;
end;

procedure TVirtCAEditForm.ChangeLinkClick(Sender: TObject);
var List: TList; T,R: TEntity; L: TListItem; i: Integer;
begin
  i:=TMenuItem(Sender).Tag;
  L:=ListView1.Selected;
  List:=TList.Create;
  try
    T:=E.AnaVar[i];
    R:=Caddy.FirstEntity;
    while R <> nil do
    begin
      if R.IsAnalog and not R.IsParam and not R.IsComposit then
        List.Add(R);
      R:=R.NextEntity;
    end;
    if GetLinkNameDlg(Self,L.Caption,List,TImageList(ListView1.SmallImages),T) then
    begin
      if not Assigned(T) then
      begin
        L.SubItems[0]:='------';
        L.SubItemImages[0]:=-1;
      end
      else
      begin
        E.AnaVar[i]:=T as TCustomAnaOut;
        L.SubItems[0]:=E.AnaVar[i].PtName+' - '+E.AnaVar[i].PtDesc;
        L.SubItemImages[0]:=EntityClassIndex(E.AnaVar[i].ClassType)+3;
      end;
    end;
  finally
    List.Free;
  end;
end;

procedure TVirtCAEditForm.ConnectEntity(Entity: TEntity);
var i: Integer;
begin
  inherited;
  E:=Entity as TVirtCalc;
  with ListView1 do
  begin
    Items.BeginUpdate;
    try
      for i:=1 to 9 do
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:=Format('V%d',[i]);
        SubItems.Add(E.NameAnaVar(i));
      end;
      for i:=1 to 9 do
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:=Format('C%d',[i]);
        DecimalSeparator := '.';
        SubItems.Add(Format('%g',[E.AnaConst[i]]));
      end;
      for i:=1 to 9 do
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:=Format('E%d',[i]);
        SubItems.Add(E.OperationToString(i));
      end;

    finally
      Items.EndUpdate;
    end;
  end;
end;

procedure TVirtCAEditForm.DeleteFormulaClick(Sender: TObject);
var L: TListItem; i: integer; R: TOneStep;
begin
  R.FirstPrefix:=uoNone;
  R.FirstArgument:=caNone;
  R.FirstArgNumber:=0;
  R.Operation:=doNone;
  R.SecondPrefix:=uoNone;
  R.SecondArgument:=caNone;
  R.SecondArgNumber:=0;
  i:=TMenuItem(Sender).Tag;
  E.StepList[i]:=R;
  L:=ListView1.Selected;
  L.SubItems[0]:='';
  L.SubItemImages[0]:=-1;
end;

procedure TVirtCAEditForm.DeleteLinkClick(Sender: TObject);
var T: TEntity; L: TListItem; i: integer;
begin
  i:=TMenuItem(Sender).Tag;
  L:=ListView1.Selected;
  T:=E.AnaVar[i];
  if (T <> nil) and
     (RemxForm.ShowQuestion('Удалить связь "'+T.PtName+'"?')=mrOK) then
  begin
    E.AnaVar[i]:=nil;
    L.SubItems[0]:='------';
    L.SubItemImages[0]:=-1;
  end;
end;

procedure TVirtCAEditForm.PopupMenu1Popup(Sender: TObject);
var L: TListItem; M: TMenuItem; i: integer;
begin
  inherited;
  L:=ListView1.Selected;
  with PopupMenu1 do
  begin
    if Assigned(L) then
    for i := 1 to 9 do
    begin
      if L.Caption = Format('V%d',[i]) then
      begin
        M:=TMenuItem.Create(Self);
        M.Caption:='Изменить связь...';
        M.Tag:=i;
        M.OnClick:=ChangeLinkClick;
        Items.Add(M);
        M:=TMenuItem.Create(Self);
        M.Caption:='Удалить связь';
        M.Tag:=i;
        M.OnClick:=DeleteLinkClick;
        M.Enabled:=Assigned(E.AnaVar[i]);
        Items.Add(M);
      end;
      if L.Caption = Format('C%d',[i]) then
      begin
        M:=TMenuItem.Create(Self);
        M.Tag:=i;
        M.Caption:='Изменить значение...';
        M.OnClick:=ChangeFloatClick;
        Items.Add(M);
      end;
      if L.Caption = Format('E%d',[i]) then
      begin
        M:=TMenuItem.Create(Self);
        M.Caption:='Изменить формулу...';
        M.Tag:=i;
        M.OnClick:=ChangeFormulaClick;
        Items.Add(M);
        M:=TMenuItem.Create(Self);
        M.Caption:='Удалить формулу';
        M.Tag:=i;
        M.OnClick:=DeleteFormulaClick;
        M.Enabled:=E.OperationToString(i) <> '';
        Items.Add(M);
      end;
    end;
  end;
end;

end.
