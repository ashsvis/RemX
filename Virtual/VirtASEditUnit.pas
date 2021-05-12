unit VirtASEditUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, EntityUnit, VirtualUnit, ExtCtrls, Menus,
  ImgList;

type
  TVirtASEditForm = class(TBaseEditForm)
    ListView1: TListView;
    PopupMenu1: TPopupMenu;
    ImageList1: TImageList;
    procedure ListView1DblClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
  private
    E: TVirtAnaSel;
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
  VirtASEditForm: TVirtASEditForm;

implementation

uses StrUtils, GetPtNameUnit, GetLinkNameUnit, RemXUnit, Math;

{$R *.dfm}

{ TVirtASForm }

procedure TVirtASEditForm.BaseFresh(var Mess: TMessage);
begin
  UpdateRealTime;
end;

procedure TVirtASEditForm.ConnectBaseEditor(var Mess: TMessage);
begin
  ConnectImageList(TImageList(Mess.WParam));
  ConnectEntity(TEntity(Mess.LParam));
end;

procedure TVirtASEditForm.ConnectEntity(Entity: TEntity);
begin
  E:=Entity as TVirtAnaSel;
  with ListView1 do
  begin
    Items.BeginUpdate;
    try
      Items.Clear;
      with Items.Add do
      begin
        ImageIndex:=EntityClassIndex(E.ClassType)+3;
        Caption:='Шифр позиции';
        SubItems.Add(E.PtName+' - '+E.EntityType);
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Дескриптор позиции';
        SubItems.Add(E.PtDesc);
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Опрос';
        SubItems.Add(IfThen(E.Actived,'Да','Нет'));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Время опроса';
        SubItems.Add(Format('%d сек',[E.FetchTime]));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Фактически';
        if E.RealTime > 0 then
          SubItems.Add(Format('%.3f',[E.RealTime/1000])+' сек')
        else
          SubItems.Add('Нет опроса');
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Сигнализация';
        SubItems.Add(IfThen(E.Logged,'Да','Нет'));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Квитирование';
        SubItems.Add(IfThen(E.Asked,'Да','Нет'));
      end;
//=========================================================================
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Вход выбора 1';
        if not Assigned(E.DigVar1) then
          SubItems.Add('------')
        else
        begin
          SubItems.Add(E.DigVar1.PtName+' - '+E.DigVar1.PtDesc);
          SubItemImages[0]:=EntityClassIndex(E.DigVar1.ClassType)+3;
        end;
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Источник значения 1';
        if not Assigned(E.AnaVar1) then
          SubItems.Add('------')
        else
        begin
          SubItems.Add(E.AnaVar1.PtName+' - '+E.AnaVar1.PtDesc);
          SubItemImages[0]:=EntityClassIndex(E.AnaVar1.ClassType)+3;
        end;
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Вход выбора 2';
        if not Assigned(E.DigVar2) then
          SubItems.Add('------')
        else
        begin
          SubItems.Add(E.DigVar2.PtName+' - '+E.DigVar2.PtDesc);
          SubItemImages[0]:=EntityClassIndex(E.DigVar2.ClassType)+3;
        end;
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Источник значения 2';
        if not Assigned(E.AnaVar2) then
          SubItems.Add('------')
        else
        begin
          SubItems.Add(E.AnaVar2.PtName+' - '+E.AnaVar2.PtDesc);
          SubItemImages[0]:=EntityClassIndex(E.AnaVar2.ClassType)+3;
        end;
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Вход выбора 3';
        if not Assigned(E.DigVar3) then
          SubItems.Add('------')
        else
        begin
          SubItems.Add(E.DigVar3.PtName+' - '+E.DigVar3.PtDesc);
          SubItemImages[0]:=EntityClassIndex(E.DigVar3.ClassType)+3;
        end;
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Источник значения 3';
        if not Assigned(E.AnaVar3) then
          SubItems.Add('------')
        else
        begin
          SubItems.Add(E.AnaVar3.PtName+' - '+E.AnaVar3.PtDesc);
          SubItemImages[0]:=EntityClassIndex(E.AnaVar3.ClassType)+3;
        end;
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Вход выбора 4';
        if not Assigned(E.DigVar4) then
          SubItems.Add('------')
        else
        begin
          SubItems.Add(E.DigVar4.PtName+' - '+E.DigVar4.PtDesc);
          SubItemImages[0]:=EntityClassIndex(E.DigVar4.ClassType)+3;
        end;
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Источник значения 4';
        if not Assigned(E.AnaVar4) then
          SubItems.Add('------')
        else
        begin
          SubItems.Add(E.AnaVar4.PtName+' - '+E.AnaVar4.PtDesc);
          SubItemImages[0]:=EntityClassIndex(E.AnaVar4.ClassType)+3;
        end;
      end;
    finally
      Items.EndUpdate;
    end;
  end;
end;

procedure TVirtASEditForm.ConnectImageList(ImageList: TImageList);
begin
  ListView1.SmallImages:=ImageList;
end;

procedure TVirtASEditForm.ListView1DblClick(Sender: TObject);
begin
  if (ListView1.Selected <> nil) and
     (ListView1.Selected.Caption = 'Источник данных') then
  begin
    if Assigned(E.SourceEntity) then
      E.SourceEntity.ShowEditor(Monitor.MonitorNum);
  end;
end;

procedure TVirtASEditForm.UpdateRealTime;
var L: TListItem;
begin
  if Caddy.UserLevel > 4 then
    ListView1.PopupMenu:=PopupMenu1
  else
    ListView1.PopupMenu:=nil;
//---------------------------------------------------------
  L:=ListView1.FindCaption(0,'Фактически',False,True,False);
  if L <> nil then
  begin
    if E.RealTime > 0 then
      L.SubItems[0]:=Format('%.3f',[E.RealTime/1000])+' сек'
    else
      L.SubItems[0]:='Нет опроса';
  end;
end;

procedure TVirtASEditForm.PopupMenu1Popup(Sender: TObject);
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
           M.Caption:='Изменить имя точки...';
           M.OnClick:=ChangePtNameClick;
           Items.Add(M);
           M:=TMenuItem.Create(Self);
           M.Caption:='-';
           Items.Add(M);
           M:=TMenuItem.Create(Self);
           M.Caption:='Дублировать точку...';
           M.OnClick:=DoubleEntityClick;
           Items.Add(M);
           M:=TMenuItem.Create(Self);
           M.Caption:='Удалить точку';
           M.OnClick:=DeleteEntityClick;
           Items.Add(M);
         end;
      1: begin
           M:=TMenuItem.Create(Self);
           M.Caption:='Изменить текст...';
           M.OnClick:=ChangeTextClick;
           Items.Add(M);
         end;
      3: begin
           M:=TMenuItem.Create(Self);
           M.Caption:='Изменить время опроса...';
           M.OnClick:=ChangeFetchClick; M.Tag:=0; Items.Add(M);
           //---
           M:=TMenuItem.Create(Self); M.Caption:='-'; Items.Add(M);
           //---
           M:=TMenuItem.Create(Self); M.Caption:='1 сек';
           M.Checked:=(E.FetchTime=1);
           M.Tag:=1; M.OnClick:=ChangeFetchClick; Items.Add(M);
           //---
           M:=TMenuItem.Create(Self); M.Caption:='2 сек';
           M.Checked:=(E.FetchTime=2);
           M.Tag:=2; M.OnClick:=ChangeFetchClick; Items.Add(M);
           //---
           M:=TMenuItem.Create(Self); M.Caption:='3 сек';
           M.Checked:=(E.FetchTime=3);
           M.Tag:=3; M.OnClick:=ChangeFetchClick; Items.Add(M);
           //---
           M:=TMenuItem.Create(Self); M.Caption:='5 сек';
           M.Checked:=(E.FetchTime=5);
           M.Tag:=5; M.OnClick:=ChangeFetchClick; Items.Add(M);
           //---
           M:=TMenuItem.Create(Self); M.Caption:='-'; Items.Add(M);
           //---
           M:=TMenuItem.Create(Self); M.Caption:='10 сек';
           M.Checked:=(E.FetchTime=10);
           M.Tag:=10; M.OnClick:=ChangeFetchClick; Items.Add(M);
           //---
           M:=TMenuItem.Create(Self); M.Caption:='20 сек';
           M.Checked:=(E.FetchTime=20);
           M.Tag:=20; M.OnClick:=ChangeFetchClick; Items.Add(M);
           //---
           M:=TMenuItem.Create(Self); M.Caption:='30 сек';
           M.Checked:=(E.FetchTime=30);
           M.Tag:=30; M.OnClick:=ChangeFetchClick; Items.Add(M);
           //---
           M:=TMenuItem.Create(Self); M.Caption:='-'; Items.Add(M);
           //---
           M:=TMenuItem.Create(Self); M.Caption:='1 мин';
           M.Checked:=(E.FetchTime=60);
           M.Tag:=60; M.OnClick:=ChangeFetchClick; Items.Add(M);
           //---
           M:=TMenuItem.Create(Self); M.Caption:='2 мин';
           M.Checked:=(E.FetchTime=120);
           M.Tag:=60*2; M.OnClick:=ChangeFetchClick; Items.Add(M);
           //---
           M:=TMenuItem.Create(Self); M.Caption:='5 мин';
           M.Checked:=(E.FetchTime=300);
           M.Tag:=60*5; M.OnClick:=ChangeFetchClick; Items.Add(M);
         end;
  2,5,6: begin
           M:=TMenuItem.Create(Self);
           M.Caption:='Нет';
           case L.Index of
             2: M.Checked:=not E.Actived;
             5: M.Checked:=not E.Logged;
             6: M.Checked:=not E.Asked;
           end;
           M.Tag:=0;
           M.OnClick:=ChangeBooleanClick;
           Items.Add(M);
           M:=TMenuItem.Create(Self);
           M.Caption:='Да';
           case L.Index of
             2: M.Checked:=E.Actived;
             5: M.Checked:=E.Logged;
             6: M.Checked:=E.Asked;
           end;
           M.Tag:=1;
           M.OnClick:=ChangeBooleanClick;
           Items.Add(M);
         end;
  7..14: begin
           M:=TMenuItem.Create(Self);
           M.Caption:='Изменить связь...';
           M.Tag:=L.Index;
           M.OnClick:=ChangeLinkClick;
           Items.Add(M);
           M:=TMenuItem.Create(Self);
           M.Caption:='Удалить связь';
           M.Tag:=L.Index;
           M.OnClick:=DeleteLinkClick;
           case L.Index of
              7: M.Enabled:=Assigned(E.DigVar1);
              8: M.Enabled:=Assigned(E.AnaVar1);
              9: M.Enabled:=Assigned(E.DigVar2);
             10: M.Enabled:=Assigned(E.AnaVar2);
             11: M.Enabled:=Assigned(E.DigVar3);
             12: M.Enabled:=Assigned(E.AnaVar3);
             13: M.Enabled:=Assigned(E.DigVar4);
             14: M.Enabled:=Assigned(E.AnaVar4);
           end;
           Items.Add(M);
         end;
    end;
  end;
end;

procedure TVirtASEditForm.ChangeBooleanClick(Sender: TObject);
var L: TListItem; M: TMenuItem; B: Boolean;
begin
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  B:=(M.Tag = 1);
  if L <> nil then
    case L.Index of
       2: begin E.Actived:=B; L.SubItems[0]:=IfThen(E.Actived,'Да','Нет'); end;
       5: begin E.Logged:=B; L.SubItems[0]:=IfThen(E.Logged,'Да','Нет'); end;
       6: begin E.Asked:=B; L.SubItems[0]:=IfThen(E.Asked,'Да','Нет'); end;
    end;
end;

procedure TVirtASEditForm.ChangeTextClick(Sender: TObject);
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

procedure TVirtASEditForm.ChangeFetchClick(Sender: TObject);
var L: TListItem; V: integer; M: TMenuItem;
begin
  M:=Sender as TMenuItem;
  L:=ListView1.Selected;
  if L <> nil then
  begin
    case M.Tag of
      0: begin
           V:=E.FetchTime;
           if InputIntegerDlg(L.Caption+' (в сек.)',V) then
           begin
             if V < 1 then V:=1;
             E.FetchTime:=V;
             L.SubItems[0]:=Format('%d сек',[E.FetchTime]);
           end;
         end;
    else
      begin
        E.FetchTime:=M.Tag;
        L.SubItems[0]:=Format('%d сек',[E.FetchTime]);
      end;
    end;
  end;
end;

procedure TVirtASEditForm.ChangeLinkClick(Sender: TObject);
var List: TList; T,R: TEntity; L: TListItem;
begin
  L:=ListView1.Selected;
  List:=TList.Create;
  try
    case L.Index of
     7: T:=E.DigVar1;
     8: T:=E.AnaVar1;
     9: T:=E.DigVar2;
    10: T:=E.AnaVar2;
    11: T:=E.DigVar3;
    12: T:=E.AnaVar3;
    13: T:=E.DigVar4;
    14: T:=E.AnaVar4;
    end;
    R:=Caddy.FirstEntity;
    while R <> nil do
    begin
      if L.Index in [7,9,11,13] then
      begin
        if R.IsDigit and not R.IsParam then
          List.Add(R)
      end
      else
      begin
        if R.IsAnalog and not R.IsParam then
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
               E.DigVar1:=T as TCustomDigOut;
               L.SubItems[0]:=E.DigVar1.PtName+' - '+E.DigVar1.PtDesc;
               L.SubItemImages[0]:=EntityClassIndex(E.DigVar1.ClassType)+3;
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
               E.AnaVar1:=T as TCustomAnaOut;
               L.SubItems[0]:=E.AnaVar1.PtName+' - '+E.AnaVar1.PtDesc;
               L.SubItemImages[0]:=EntityClassIndex(E.AnaVar1.ClassType)+3;
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
               E.DigVar2:=T as TCustomDigOut;
               L.SubItems[0]:=E.DigVar2.PtName+' - '+E.DigVar2.PtDesc;
               L.SubItemImages[0]:=EntityClassIndex(E.DigVar2.ClassType)+3;
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
               E.AnaVar2:=T as TCustomAnaOut;
               L.SubItems[0]:=E.AnaVar2.PtName+' - '+E.AnaVar2.PtDesc;
               L.SubItemImages[0]:=EntityClassIndex(E.AnaVar2.ClassType)+3;
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
               E.DigVar3:=T as TCustomDigOut;
               L.SubItems[0]:=E.DigVar3.PtName+' - '+E.DigVar3.PtDesc;
               L.SubItemImages[0]:=EntityClassIndex(E.DigVar3.ClassType)+3;
             end;
           end;
       12: begin
             if not Assigned(T) then
             begin
               L.SubItems[0]:='------';
               L.SubItemImages[0]:=-1;
             end
             else
             begin
               E.AnaVar3:=T as TCustomAnaOut;
               L.SubItems[0]:=E.AnaVar3.PtName+' - '+E.AnaVar3.PtDesc;
               L.SubItemImages[0]:=EntityClassIndex(E.AnaVar3.ClassType)+3;
             end;
           end;
       13: begin
             if not Assigned(T) then
             begin
               L.SubItems[0]:='------';
               L.SubItemImages[0]:=-1;
             end
             else
             begin
               E.DigVar4:=T as TCustomDigOut;
               L.SubItems[0]:=E.DigVar4.PtName+' - '+E.DigVar4.PtDesc;
               L.SubItemImages[0]:=EntityClassIndex(E.DigVar4.ClassType)+3;
             end;
           end;
       14: begin
             if not Assigned(T) then
             begin
               L.SubItems[0]:='------';
               L.SubItemImages[0]:=-1;
             end
             else
             begin
               E.AnaVar4:=T as TCustomAnaOut;
               L.SubItems[0]:=E.AnaVar4.PtName+' - '+E.AnaVar4.PtDesc;
               L.SubItemImages[0]:=EntityClassIndex(E.AnaVar4.ClassType)+3;
             end;
           end;
      end;
    end;
  finally
    List.Free;
  end;
end;

procedure TVirtASEditForm.DeleteLinkClick(Sender: TObject);
var T: TEntity; L: TListItem;
begin
  L:=ListView1.Selected;
  case L.Index of
    7: T:=E.DigVar1;
    8: T:=E.AnaVar1;
    9: T:=E.DigVar2;
   10: T:=E.AnaVar2;
   11: T:=E.DigVar3;
   12: T:=E.AnaVar3;
   13: T:=E.DigVar4;
   14: T:=E.AnaVar4;
  else
    T:=nil;
  end;
  if (T <> nil) and
     (RemxForm.ShowQuestion('Удалить связь "'+T.PtName+'"?')=mrOK) then
  begin
    case L.Index of
      7: begin E.DigVar1:=nil; L.SubItems[0]:='------'; L.SubItemImages[0]:=-1; end;
      8: begin E.AnaVar1:=nil; L.SubItems[0]:='------'; L.SubItemImages[0]:=-1; end;
      9: begin E.DigVar2:=nil; L.SubItems[0]:='------'; L.SubItemImages[0]:=-1; end;
     10: begin E.AnaVar2:=nil; L.SubItems[0]:='------'; L.SubItemImages[0]:=-1; end;
     11: begin E.DigVar3:=nil; L.SubItems[0]:='------'; L.SubItemImages[0]:=-1; end;
     12: begin E.AnaVar3:=nil; L.SubItems[0]:='------'; L.SubItemImages[0]:=-1; end;
     13: begin E.DigVar4:=nil; L.SubItems[0]:='------'; L.SubItemImages[0]:=-1; end;
     14: begin E.AnaVar4:=nil; L.SubItems[0]:='------'; L.SubItemImages[0]:=-1; end;
    end;
  end;
end;

end.
