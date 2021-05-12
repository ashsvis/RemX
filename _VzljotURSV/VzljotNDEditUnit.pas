unit VzljotNDEditUnit;

interface

uses
  Forms, EntityUnit, VzljotURSVUnit;

type
  TVzljotEditForm = class(TVzljotNDForm)
  private
    E: TURSVNode;
  protected
    procedure ConnectEntity(Entity: TEntity); override;
    procedure PopupMenu1Popup(Sender: TObject); override;
    procedure ChangeVzNodeFormat(Sender: TObject); virtual;
  public
  end;

var
  VzljotEditForm: TVzljotEditForm;

implementation

uses ComCtrls, Menus;

{$R *.dfm}

{ TVzljotEditForm }

procedure TVzljotEditForm.ChangeVzNodeFormat(Sender: TObject);
var L: TListItem; M: TMenuItem;
begin
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  if Assigned(L) then
  begin
    E.NodeType:=TVzNodeType(M.Tag);
    L.SubItems[0]:=AVzNodeFormat[E.NodeType];
  end;
end;

procedure TVzljotEditForm.ConnectEntity(Entity: TEntity);
begin
  inherited;
  E:=Entity as TURSVNode;
  with ListView1 do
  begin
    Items.BeginUpdate;
    try
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Тип прибора';
        SubItems.Add(AVzNodeFormat[E.NodeType]);
      end;
    finally
      Items.EndUpdate;
    end;
  end;
end;

procedure TVzljotEditForm.PopupMenu1Popup(Sender: TObject);
var L: TListItem; M: TMenuItem; k: TVzNodeType;
begin
  inherited;
  L:=ListView1.Selected;
  with PopupMenu1 do
  begin
    if Assigned(L) then
    begin
      if L.Caption = 'Тип прибора' then
      begin
        for k:=Low(AVzNodeFormat) to High(AVzNodeFormat) do
        begin
          M:=TMenuItem.Create(Self);
          M.Caption:=AVzNodeFormat[k];
          M.Tag:=Ord(k);
          M.OnClick:=ChangeVzNodeFormat;
          M.Checked:=(E.NodeType = k);
          PopupMenu1.Items.Add(M);
        end;
      end;
    end;
  end;
end;

end.
