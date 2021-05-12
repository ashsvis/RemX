unit VirtTCEditUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, EntityUnit, VirtualUnit, ExtCtrls, Menus,
  ImgList;

type
  TVirtTCEditForm = class(TBaseEditForm)
    ListView1: TListView;
    PopupMenu1: TPopupMenu;
    ImageList1: TImageList;
    procedure ListView1DblClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
  private
    E: TVirtTimeCounter;
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
    procedure ChangeIntegerClick(Sender: TObject);
    procedure ChangeTimFormatClick(Sender: TObject);
  public
  end;

var
  VirtTCEditForm: TVirtTCEditForm;

implementation

uses StrUtils, Math, GetPtNameUnit, GetLinkNameUnit, RemXUnit;

{$R *.dfm}

{ TVirtVCForm }

procedure TVirtTCEditForm.BaseFresh(var Mess: TMessage);
begin
  UpdateRealTime;
end;

procedure TVirtTCEditForm.ConnectBaseEditor(var Mess: TMessage);
begin
  ConnectImageList(TImageList(Mess.WParam));
  ConnectEntity(TEntity(Mess.LParam));
end;

procedure TVirtTCEditForm.ConnectEntity(Entity: TEntity);
begin
  E:=Entity as TVirtTimeCounter;
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
        Caption:='Состояние "РАБОТА"';
        if not Assigned(E.DigWork) then
          SubItems.Add('------')
        else
        begin
          SubItems.Add(E.DigWork.PtName+' - '+E.DigWork.PtDesc);
          SubItemImages[0]:=EntityClassIndex(E.DigWork.ClassType)+3;
        end;
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Формат времени наработки';
        SubItems.Add(ATimtoStr[E.PVFormat]);
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Максимальное время, часы';
        SubItems.Add(IntToStr(E.MaxHourValue));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Аварийное время, часы';
        SubItems.Add(IntToStr(E.HHHourTP));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Предаварийное время, часы';
        SubItems.Add(IntToStr(E.HiHourTP));
      end;
    finally
      Items.EndUpdate;
    end;
  end;
end;

procedure TVirtTCEditForm.ConnectImageList(ImageList: TImageList);
begin
  ListView1.SmallImages:=ImageList;
end;

procedure TVirtTCEditForm.ListView1DblClick(Sender: TObject);
begin
  if ListView1.Selected <> nil then
  begin
    if ListView1.Selected.Caption = 'Источник данных' then
    begin
      if Assigned(E.SourceEntity) then
        E.SourceEntity.ShowEditor(Monitor.MonitorNum);
    end;
    if ListView1.Selected.Caption = 'Состояние "РАБОТА"' then
    begin
      if Assigned(E.DigWork) then
        E.DigWork.ShowEditor(Monitor.MonitorNum);
    end;
  end;
end;

procedure TVirtTCEditForm.UpdateRealTime;
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

procedure TVirtTCEditForm.PopupMenu1Popup(Sender: TObject);
var L: TListItem; M: TMenuItem; k: TTimFormat;
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
      7: begin
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
             7: M.Enabled:=Assigned(E.DigWork);
           end;
           Items.Add(M);
         end;
      8: for k:=Low(ATimtoStr) to High(ATimtoStr) do
         begin
           M:=TMenuItem.Create(Self);
           M.Caption:=ATimtoStr[k];
           M.Tag:=Ord(k);
           M.OnClick:=ChangeTimFormatClick;
           M.Checked:=(E.PVFormat = k);
           Items.Add(M);
         end;
  9..11: begin
           M:=TMenuItem.Create(Self);
           M.Caption:='Изменить число...';
           M.OnClick:=ChangeIntegerClick;
           Items.Add(M);
         end;
    end;
  end;
end;

procedure TVirtTCEditForm.ChangeBooleanClick(Sender: TObject);
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

procedure TVirtTCEditForm.ChangeTextClick(Sender: TObject);
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

procedure TVirtTCEditForm.ChangeFetchClick(Sender: TObject);
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

procedure TVirtTCEditForm.ChangeLinkClick(Sender: TObject);
var List: TList; T,R: TEntity; L: TListItem;
begin
  L:=ListView1.Selected;
  List:=TList.Create;
  try
    case L.Index of
     7: T:=E.DigWork;
    end;
    R:=Caddy.FirstEntity;
    while R <> nil do
    begin
      if R.IsDigit and not R.IsParam then
        List.Add(R);
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
               E.DigWork:=T as TCustomDigOut;
               L.SubItems[0]:=E.DigWork.PtName+' - '+E.DigWork.PtDesc;
               L.SubItemImages[0]:=EntityClassIndex(E.DigWork.ClassType)+3;
             end;
           end;
      end;
    end;
  finally
    List.Free;
  end;
end;

procedure TVirtTCEditForm.DeleteLinkClick(Sender: TObject);
var T: TEntity; L: TListItem;
begin
  L:=ListView1.Selected;
  case L.Index of
    7: T:=E.DigWork;
  else
    T:=nil;
  end;
  if (T <> nil) and
     (RemxForm.ShowQuestion('Удалить связь "'+T.PtName+'"?')=mrOK) then
  begin
    case L.Index of
      7: begin
           E.DigWork:=nil;
           L.SubItems[0]:='------';
           L.SubItemImages[0]:=-1;
         end;
    end;
  end;
end;

procedure TVirtTCEditForm.ChangeIntegerClick(Sender: TObject);
var L: TListItem; V: Integer;
begin
  L:=ListView1.Selected;
  if L <> nil then
  begin
    case L.Index of
      9: V:=E.MaxHourValue;
     10: V:=E.HHHourTP;
     11: V:=E.HiHourTP;
    end;
    if InputIntegerDlg(L.Caption,V) then
    case L.Index of
      9: if InRange(V,E.HHHourTP,MaxInt) then
         begin
           E.MaxHourValue:=V;
           L.SubItems[0]:=Format('%d',[E.MaxHourValue]);
         end
         else
           raise
             ERangeError.CreateFmt('Значение вне допустимых границ (%d..%d)!',
                                   [E.HHHourTP,MaxInt]);
     10: if InRange(V,E.HiHourTP,E.MaxHourValue) then
         begin
           E.HHHourTP:=V;
           L.SubItems[0]:=Format('%d',[E.HHHourTP]);
         end
         else
           raise
             ERangeError.CreateFmt('Значение вне допустимых границ (%d..%d)!',
                                   [E.HiHourTP,E.MaxHourValue]);
     11: if InRange(V,0,E.HHHourTP) then
         begin
           E.HiHourTP:=V;
           L.SubItems[0]:=Format('%d',[E.HiHourTP]);
         end
         else
           raise
             ERangeError.CreateFmt('Значение вне допустимых границ (%d..%d)!',
                                   [0,E.HHHourTP]);
    end;
  end;
end;

procedure TVirtTCEditForm.ChangeTimFormatClick(Sender: TObject);
var L: TListItem; M: TMenuItem;
begin
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  if L <> nil then
  begin
    with ListView1 do
    case L.Index of
      8: begin
           E.PVFormat:=TTimFormat(M.Tag);
           Items[8].SubItems[0]:=ATimtoStr[E.PVFormat];
         end;
    end;
  end;
end;

end.
