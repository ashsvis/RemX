unit VirtFLEditUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, EntityUnit, VirtualUnit, ExtCtrls, Menus,
  ImgList;

type
  TVirtFLEditForm = class(TVirtEditForm)
    ImageList1: TImageList;
    procedure FormCreate(Sender: TObject);
  private
    E: TVirtFlag;
    procedure ChangeFixedColorClick(Sender: TObject);
  protected
    procedure ConnectEntity(Entity: TEntity); override;
    procedure PopupMenu1Popup(Sender: TObject); override;
    procedure ChangeTextClick(Sender: TObject); override;
    procedure ChangeBooleanClick(Sender: TObject); override;
  public
  end;

var
  VirtFLEditForm: TVirtFLEditForm;

implementation

uses StrUtils, GetPtNameUnit, Math;

{$R *.dfm}

{ TVirtFLForm }

procedure TVirtFLEditForm.ConnectEntity(Entity: TEntity);
begin
  inherited;
  E:=Entity as TVirtFlag;
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
        Caption:='�������� ������';
        if E.SourceEntity=nil then
          SubItems.Add('����')
        else
        begin
          SubItems.Add(E.SourceEntity.PtName+' - '+E.SourceEntity.PtDesc);
          SubItemImages[0]:=EntityClassIndex(E.SourceEntity.ClassType)+3;
        end;
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='�������� ������';
        SubItems.Add(IfThen(E.Invert,'��','���'));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='������ ��� "0"->"1"';
        SubItems.Add(IfThen(E.AlarmUp,'��','���'));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='������ ��� "1"->"0"';
        SubItems.Add(IfThen(E.AlarmDown,'��','���'));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='������������ ��� "0"->"1"';
        SubItems.Add(IfThen(E.SwitchUp,'��','���'));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='������������ ��� "1"->"0"';
        SubItems.Add(IfThen(E.SwitchDown,'��','���'));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='���� ��� "1"';
        SubItems.Add(StringDigColor[E.ColorUp]);
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='���� ��� "0"';
        SubItems.Add(StringDigColor[E.ColorDown]);
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='����� ��� "1"';
        SubItems.Add(E.TextUp);
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='����� ��� "0"';
        SubItems.Add(E.TextDown);
      end;
    finally
      Items.EndUpdate;
    end;
  end;
end;

procedure TVirtFLEditForm.PopupMenu1Popup(Sender: TObject);
var L: TListItem; M: TMenuItem; DC: TDigColor;
begin
  inherited;
  L:=ListView1.Selected;
  with PopupMenu1 do
  begin
    Images:=nil;
    if Assigned(L) then
    begin
      if L.Caption = '������������' then AddBoolItem(E.Logged);
      if L.Caption = '������������' then AddBoolItem(E.Asked);
      if L.Caption = '�������� ������' then AddBoolItem(E.Invert);
      if L.Caption = '������ ��� "0"->"1"' then AddBoolItem(E.AlarmUp);
      if L.Caption = '������ ��� "1"->"0"' then AddBoolItem(E.AlarmDown);
      if L.Caption = '������������ ��� "0"->"1"' then AddBoolItem(E.SwitchUp);
      if L.Caption = '������������ ��� "1"->"0"' then AddBoolItem(E.SwitchDown);
      if (L.Caption = '���� ��� "1"') or
         (L.Caption = '���� ��� "0"') then
      begin
        for DC:=Low(StringDigColor) to High(StringDigColor) do
        begin
          Images:=ImageList1;
          M:=TMenuItem.Create(Self);
          M.Caption:=StringDigColor[DC];
          if L.Caption = '���� ��� "1"' then
            M.Default:=(E.ColorUp = DC)
          else
            M.Default:=(E.ColorDown = DC);
          M.Tag:=Ord(DC);
          M.OnClick:=ChangeFixedColorClick;
          M.ImageIndex:=Ord(DC);
          Items.Add(M);
        end;
      end;
      if (L.Caption = '����� ��� "1"') or
         (L.Caption = '����� ��� "0"') then
      begin
        M:=TMenuItem.Create(Self);
        M.Caption:='�������� �����...';
        M.OnClick:=ChangeTextClick;
        Items.Add(M);
      end;
    end;
  end;
end;

procedure TVirtFLEditForm.ChangeFixedColorClick(Sender: TObject);
var L: TListItem; M: TMenuItem; DC: TDigColor;
begin
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  DC:=TDigColor(M.Tag);
  if Assigned(L) then
  begin
    if L.Caption = '���� ��� "1"' then
    begin
      E.ColorUp:=DC;
      L.SubItems[0]:=StringDigColor[E.ColorUp];
    end
    else
    begin
      E.ColorDown:=DC;
      L.SubItems[0]:=StringDigColor[E.ColorDown];
    end;
  end;
end;

procedure TVirtFLEditForm.ChangeBooleanClick(Sender: TObject);
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
    if L.Caption = '�������� ������' then
    begin
      E.Invert:=B;
      L.SubItems[0]:=IfThen(E.Invert,'��','���');
    end;
    if L.Caption = '������ ��� "0"->"1"' then
    begin
      E.AlarmUp:=B;
      L.SubItems[0]:=IfThen(E.AlarmUp,'��','���');
    end;
    if L.Caption = '������ ��� "1"->"0"' then
    begin
      E.AlarmDown:=B;
      L.SubItems[0]:=IfThen(E.AlarmDown,'��','���');
    end;
    if L.Caption = '������������ ��� "0"->"1"' then
    begin
      E.SwitchUp:=B;
      L.SubItems[0]:=IfThen(E.SwitchUp,'��','���');
    end;
    if L.Caption = '������������ ��� "1"->"0"' then
    begin
      E.SwitchDown:=B;
      L.SubItems[0]:=IfThen(E.SwitchDown,'��','���');
    end;
  end
end;

procedure TVirtFLEditForm.ChangeTextClick(Sender: TObject);
var L: TListItem; S: string;
begin
  inherited;
  L:=ListView1.Selected;
  if Assigned(L) then
  begin
    if (L.Caption = '����� ��� "1"') or
       (L.Caption = '����� ��� "0"') then
      S:=L.SubItems[0]
    else
      Exit;
    if InputStringDlg(L.Caption,S,10) then
    begin
      if L.Caption = '����� ��� "1"' then
      begin
        E.TextUp:=S;
        L.SubItems[0]:=E.TextUp;
      end;
      if L.Caption = '����� ��� "0"' then
      begin
        E.TextDown:=S;
        L.SubItems[0]:=E.TextDown;
      end;
    end;
  end;
end;

procedure TVirtFLEditForm.FormCreate(Sender: TObject);
var DC: TDigColor; B: TBitmap;
begin
  B:=TBitmap.Create;
  try
    B.Width:=ImageList1.Width;
    B.Height:=ImageList1.Height;
    for DC:=Low(StringDigColor) to High(StringDigColor) do
    begin
      B.Canvas.Brush.Color:=ArrayDigColor[DC];
      B.Canvas.Rectangle(Rect(0,0,B.Width,B.Height));
      ImageList1.Add(B,nil);
    end;
  finally
    B.Free;
  end;
end;

end.
