unit ElemGTEditUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, EntityUnit, ElemerUnit, ExtCtrls, Menus;

type
  TElemGTEditForm = class(TBaseEditForm)
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
    E: TElemTMGroup;
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
  public
  end;

var
  ElemGTEditForm: TElemGTEditForm;

implementation

uses StrUtils, Math, GetPtNameUnit, GetLinkNameUnit, RemXUnit;

{$R *.dfm}

{ TVirtVDEditForm }

procedure TElemGTEditForm.BaseFresh(var Mess: TMessage);
begin
  UpdateRealTime;
end;

procedure TElemGTEditForm.ConnectBaseEditor(var Mess: TMessage);
begin
  ConnectImageList(TImageList(Mess.WParam));
  ConnectEntity(TEntity(Mess.LParam));
end;

procedure TElemGTEditForm.ConnectEntity(Entity: TEntity);
var i: integer;
begin
  E:=Entity as TElemTMGroup;
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
        Caption:='Канал связи';
        SubItems.Add(IntToStr(E.Channel));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Контроллер';
        SubItems.Add(IntToStr(E.Node));
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

procedure TElemGTEditForm.ConnectImageList(ImageList: TImageList);
begin
  ListView1.SmallImages:=ImageList;
  ListView2.SmallImages:=ImageList;
end;

procedure TElemGTEditForm.ListView2DblClick(Sender: TObject);
var E: TEntity;
begin
  if ListView2.Selected <> nil then
  begin
    E:=TEntity(ListView2.Selected.Data);
    if Assigned(E) then
      E.ShowEditor(Monitor.MonitorNum);
  end;
end;

procedure TElemGTEditForm.ListView1DblClick(Sender: TObject);
begin
  if (ListView1.Selected <> nil) and
     (ListView1.Selected.Caption = 'Источник данных') then
  begin
    if Assigned(E.SourceEntity) then
      E.SourceEntity.ShowEditor(Monitor.MonitorNum);
  end;
end;

procedure TElemGTEditForm.UpdateRealTime;
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
  L:=ListView1.FindCaption(0,'Фактически',False,True,False);
  if L <> nil then
  begin
    if E.RealTime > 0 then
      L.SubItems[0]:=Format('%.3f',[E.RealTime/1000])+' сек'
    else
      L.SubItems[0]:='Нет опроса';
  end;
end;

procedure TElemGTEditForm.PopupMenu1Popup(Sender: TObject);
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
   1..2: begin
           M:=TMenuItem.Create(Self);
           M.Caption:='Изменить число...';
           M.OnClick:=ChangeIntegerClick;
           Items.Add(M);
         end;
      3: begin
           M:=TMenuItem.Create(Self);
           M.Caption:='Изменить текст...';
           M.OnClick:=ChangeTextClick;
           Items.Add(M);
         end;
      4: begin
           M:=TMenuItem.Create(Self);
           M.Caption:='Нет';
           case L.Index of
             4: M.Checked:=not E.Actived;
           end;
           M.Tag:=0;
           M.OnClick:=ChangeBooleanClick;
           Items.Add(M);
           M:=TMenuItem.Create(Self);
           M.Caption:='Да';
           case L.Index of
             4: M.Checked:=E.Actived;
           end;
           M.Tag:=1;
           M.OnClick:=ChangeBooleanClick;
           Items.Add(M);
         end;
      5: begin
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
    end;
  end;
end;

procedure TElemGTEditForm.ChangeTextClick(Sender: TObject);
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

procedure TElemGTEditForm.ChangeFetchClick(Sender: TObject);
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

procedure TElemGTEditForm.ChangeBooleanClick(Sender: TObject);
var L: TListItem; M: TMenuItem; B: Boolean; i: integer; Found: boolean;
begin
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  B:=(M.Tag = 1);
  if L <> nil then
    case L.Index of
      4: begin
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
             L.SubItems[0]:=IfThen(E.Actived,'Да','Нет');
           end
           else
             RemxForm.ShowError('Группа опроса "'+E.PtName+'" пуста.'#13+
                   'Нельзя ставить на опрос пустую группу!');
         end;
    end;
end;

procedure TElemGTEditForm.PopupMenu2Popup(Sender: TObject);
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
        M.Caption:='Изменить связь...';
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
        M.Caption:='Удалить связь'
      else
        M.Caption:='Удалить выбранные связи';
      M.Tag:=L.Index;
      M.OnClick:=DeleteLinkClick;
      M.Enabled:=(L.Data <> nil);
      Items.Add(M);
    end;
  end;
end;

procedure TElemGTEditForm.ChangeLinkClick(Sender: TObject);
var L: TListItem; T,R: TEntity; EList,List: TList;
    S: string; i,j: integer;
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
        if (R.ClassType = TTMAnaOut) and
           not Assigned(R.SourceEntity) and
           (E.Channel = R.Channel) and
           (E.Node = R.Node) then List.Add(R);
        R:=R.NextEntity;
      end;
      if GetLinkNameDlg(Self,'Значение связи №'+IntToStr(L.Index+1),List,
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

procedure TElemGTEditForm.DeleteLinkClick(Sender: TObject);
var L: TListItem; T: TEntity;
    S: string; Found: boolean; i: integer;
begin
  L:=ListView2.Selected;
  if L <> nil then
  begin
    T:=E.EntityChilds[L.Index];
    if (T <> nil) and
       (RemxForm.ShowQuestion(IfThen((ListView2.SelCount = 1),
                     'Удалить связь "'+T.PtName+'"?',
           'Удалить выбранные связи ('+
           IntToStr(ListView2.SelCount)+' шт.)?'))=mrOK) then
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
      E.ShowEditor(Monitor.MonitorNum);
      ListView2.SetFocus;
      ListView2.Selected:=ListView2.FindCaption(0,S,False,True,False);
    end;
  end;
end;

procedure TElemGTEditForm.ChangeIntegerClick(Sender: TObject);
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
             raise ERangeError.Create('Значение вне допустимых границ!');
        2: if InRange(V,1,247) then
           begin
             E.Node:=V;
             L.SubItems[0]:=Format('%d',[E.Node]);
           end
           else
             raise ERangeError.Create('Значение вне допустимых границ (1..247)!');
      end;
      if L.Index in [1..2] then
      begin
        UpdateBaseView(Self);
        RestoreEntityPos(E);
      end;
    end;
  end;
end;

end.
