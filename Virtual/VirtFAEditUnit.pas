unit VirtFAEditUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, EntityUnit, VirtualUnit, Menus, ExtCtrls;

type
  TVirtFAEditForm = class(TBaseEditForm)
    ListView1: TListView;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    Splitter1: TSplitter;
    ListView2: TListView;
    procedure ListView1DblClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PopupMenu2Popup(Sender: TObject);
    procedure ListView2DblClick(Sender: TObject);
  private
    E: TVirtFAGroup;
    procedure ConnectBaseEditor(var Mess: TMessage); message WM_ConnectBaseEditor;
    procedure BaseFresh(var Mess: TMessage); message WM_Fresh;
    procedure ConnectEntity(Entity: TEntity);
    procedure ConnectImageList(ImageList: TImageList);
    procedure UpdateRealTime;
    procedure ChangeTextClick(Sender: TObject);
    procedure ChangeFetchClick(Sender: TObject);
    procedure ChangeBooleanClick(Sender: TObject);
    procedure ChangeFloatClick(Sender: TObject);
    procedure ChangeIntegerClick(Sender: TObject);
    procedure ChangeLinkClick(Sender: TObject);
    procedure DeleteLinkClick(Sender: TObject);
    procedure ChangePeriodKindClick(Sender: TObject);
    procedure ChangeBaseKindClick(Sender: TObject);
    procedure ChangeCalcKindClick(Sender: TObject);
    function GetChildNames(Index: integer): string;
    procedure ChangeGroupLinkClick(Sender: TObject);
    procedure DeleteGroupLinkClick(Sender: TObject);
  public
  end;

var
  VirtFAEditForm: TVirtFAEditForm;

implementation

uses StrUtils, GetPtNameUnit, Math, GetLinkNameUnit, RemXUnit;

{$R *.dfm}

{ TVirtFAEditForm }

procedure TVirtFAEditForm.BaseFresh(var Mess: TMessage);
begin
  UpdateRealTime;
end;

procedure TVirtFAEditForm.ConnectBaseEditor(var Mess: TMessage);
begin
  ConnectImageList(TImageList(Mess.WParam));
  ConnectEntity(TEntity(Mess.LParam));
end;

procedure TVirtFAEditForm.ConnectEntity(Entity: TEntity);
var i: integer;
begin
  E:=Entity as TVirtFAGroup;
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
//=========================================================================
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Источник расхода';
        if not Assigned(E.AnaWork) then
          SubItems.Add('------')
        else
        begin
          SubItems.Add(E.AnaWork.PtName+' - '+E.AnaWork.PtDesc);
          SubItemImages[0]:=EntityClassIndex(E.AnaWork.ClassType)+3;
        end;
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Внешнее управление';
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
        Caption:='Инверсия управления';
        SubItems.Add(IfThen(E.InvDigWork,'Да','Нет'));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Период накопления';
        SubItems.Add(APeriodKind[E.PeriodKind]);
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Расчетное время (час)';
        SubItems.Add(IntToStr(E.ShiftHour));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='База времени счета';
        SubItems.Add(ABaseKind[E.BaseKind]);
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Тип счета при ошибке';
        SubItems.Add(ACalcKind[E.CalcKind]);
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Значение для сброса';
        SubItems.Add(Format('%g',[E.Reset]));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Значение отсечки';
        SubItems.Add(Format('%g',[E.CutOff]));
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
            ImageIndex:=-1;
            Caption:=GetChildNames(i);
            SubItems.Add(E.EntityChilds[i].PtName);
            SubItemImages[0]:=EntityClassIndex(E.EntityChilds[i].ClassType)+3;
            SubItems.Add(E.EntityChilds[i].PtDesc);
          end
          else
          begin
            Data:=nil;
            ImageIndex:=-1;
            Caption:=GetChildNames(i);
            SubItems.Add('------');
            SubItemImages[0]:=-1;
            SubItems.Add('------');
          end;
        end;
      end;
    finally
      Items.EndUpdate;
    end;
  end;
end;

function TVirtFAEditForm.GetChildNames(Index: integer): string;
begin
  case Index of
    0: Result:='Текущее значение';
    1: Result:='Предыдущее значение';
    2: Result:='С начала часа';
    3: Result:='За предыдущий час';
    4: Result:='С начала суток';
    5: Result:='За предыдущие сутки';
    6: Result:='С начала месяца';
    7: Result:='За предыдущий месяц';
    8: Result:='С начала года';
    9: Result:='За предыдущий год';
  else
    Result:='';
  end;
end;

procedure TVirtFAEditForm.ConnectImageList(ImageList: TImageList);
begin
  ListView1.SmallImages:=ImageList;
  ListView2.SmallImages:=ImageList;
end;

procedure TVirtFAEditForm.ListView1DblClick(Sender: TObject);
begin
  if ListView1.Selected <> nil then
  begin
    if ListView1.Selected.Caption = 'Источник данных' then
    begin
      if Assigned(E.SourceEntity) then
        E.SourceEntity.ShowEditor(Monitor.MonitorNum);
    end;
    if ListView1.Selected.Caption = 'Источник расхода' then
    begin
      if Assigned(E.AnaWork) then
        E.AnaWork.ShowEditor(Monitor.MonitorNum);
    end;
    if ListView1.Selected.Caption = 'Внешнее управление' then
    begin
      if Assigned(E.DigWork) then
        E.DigWork.ShowEditor(Monitor.MonitorNum);
    end;
  end;
end;

procedure TVirtFAEditForm.UpdateRealTime;
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

procedure TVirtFAEditForm.PopupMenu1Popup(Sender: TObject);
var L: TListItem; M: TMenuItem; i: integer;
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
    2,7: begin
           M:=TMenuItem.Create(Self);
           M.Caption:='Нет';
           case L.Index of
             2: M.Checked:=not E.Actived;
             7: M.Checked:=not E.InvDigWork;
           end;
           M.Tag:=0;
           M.OnClick:=ChangeBooleanClick;
           Items.Add(M);
           M:=TMenuItem.Create(Self);
           M.Caption:='Да';
           case L.Index of
             2: M.Checked:=E.Actived;
             7: M.Checked:=E.InvDigWork;
           end;
           M.Tag:=1;
           M.OnClick:=ChangeBooleanClick;
           Items.Add(M);
         end;
    5,6: begin
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
              5: M.Enabled:=Assigned(E.AnaWork);
              6: M.Enabled:=Assigned(E.DigWork);
           end;
           Items.Add(M);
         end;
      8: for i:=Ord(Low(APeriodKind)) to Ord(High(APeriodKind)) do
         begin
           M:=TMenuItem.Create(Self);
           M.Caption:=APeriodKind[TPeriodKind(i)];
           M.Checked:=(E.PeriodKind=TPeriodKind(i));
           M.Tag:=i;
           M.OnClick:=ChangePeriodKindClick;
           Items.Add(M);
         end;
  12,13: begin
           M:=TMenuItem.Create(Self);
           M.Caption:='Изменить значение...';
           M.OnClick:=ChangeFloatClick;
           Items.Add(M);
         end;
      9: begin
           M:=TMenuItem.Create(Self);
           M.Caption:='Изменить число...';
           M.OnClick:=ChangeIntegerClick;
           Items.Add(M);
         end;
     10: for i:=Ord(Low(ABaseKind)) to Ord(High(ABaseKind)) do
         begin
           M:=TMenuItem.Create(Self);
           M.Caption:=ABaseKind[TBaseKind(i)];
           M.Checked:=(E.BaseKind=TBaseKind(i));
           M.Tag:=i;
           M.OnClick:=ChangeBaseKindClick;
           Items.Add(M);
         end;
     11: for i:=Ord(Low(ACalcKind)) to Ord(High(ACalcKind)) do
         begin
           M:=TMenuItem.Create(Self);
           M.Caption:=ACalcKind[TCalcKind(i)];
           M.Checked:=(E.CalcKind=TCalcKind(i));
           M.Tag:=i;
           M.OnClick:=ChangeCalcKindClick;
           Items.Add(M);
         end;
    end;
  end;
end;

procedure TVirtFAEditForm.ChangeTextClick(Sender: TObject);
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

procedure TVirtFAEditForm.ChangeFetchClick(Sender: TObject);
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

procedure TVirtFAEditForm.ChangeBooleanClick(Sender: TObject);
var L: TListItem; M: TMenuItem; B: Boolean;
begin
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  B:=(M.Tag = 1);
  if L <> nil then
    case L.Index of
       2: begin E.Actived:=B; L.SubItems[0]:=IfThen(E.Actived,'Да','Нет'); end;
       7: begin E.InvDigWork:=B; L.SubItems[0]:=IfThen(E.InvDigWork,'Да','Нет'); end;
    end;
end;

procedure TVirtFAEditForm.ChangeFloatClick(Sender: TObject);
var L: TListItem; V: Single;
begin
  L:=ListView1.Selected;
  if L <> nil then
  begin
    case L.Index of
     12: V:=E.Reset;
     13: V:=E.CutOff;
    end;
    if InputFloatDlg(L.Caption,'%g',V) then
    case L.Index of
     12: if V >= 0.0 then
         begin
           E.Reset:=V;
           L.SubItems[0]:=Format('%g',[E.Reset]);
         end
         else
           raise ERangeError.Create('Значение вне допустимых границ!');
     13: if V >= 0.0 then
         begin
           E.CutOff:=V;
           L.SubItems[0]:=Format('%g',[E.CutOff]);
         end
         else
           raise ERangeError.Create('Значение вне допустимых границ!');
    end;
  end;
end;

procedure TVirtFAEditForm.ChangeIntegerClick(Sender: TObject);
var L: TListItem; V: Integer;
begin
  L:=ListView1.Selected;
  if L <> nil then
  begin
    case L.Index of
      9: V:=E.ShiftHour;
    end;
    if InputIntegerDlg(L.Caption,V) then
    case L.Index of
       9: if InRange(V,0,23) then
         begin
           E.ShiftHour:=V;
           L.SubItems[0]:=Format('%d',[E.ShiftHour]);
         end
         else
           raise ERangeError.Create('Значение вне допустимых границ (0..23)!');
    end;
  end;
end;

procedure TVirtFAEditForm.ChangeLinkClick(Sender: TObject);
var List: TList; T,R: TEntity; L: TListItem;
begin
  L:=ListView1.Selected;
  List:=TList.Create;
  try
    case L.Index of
     5: T:=E.AnaWork;
     6: T:=E.DigWork;
    end;
    R:=Caddy.FirstEntity;
    while R <> nil do
    begin
      if L.Index = 5 then
      begin
        if R.IsAnalog and not R.IsParam and not R.IsComposit then
          List.Add(R)
      end
      else
      begin
        if R.IsDigit and not R.IsParam then
          List.Add(R);
      end;
      R:=R.NextEntity;
    end;
    if GetLinkNameDlg(Self,L.Caption,List,TImageList(ListView1.SmallImages),T) then
    begin
      case L.Index of
        5: begin
             if not Assigned(T) then
             begin
               L.SubItems[0]:='------';
               L.SubItemImages[0]:=-1;
             end
             else
             begin
               E.AnaWork:=T as TCustomAnaOut;
               L.SubItems[0]:=E.AnaWork.PtName+' - '+E.AnaWork.PtDesc;
               L.SubItemImages[0]:=EntityClassIndex(E.AnaWork.ClassType)+3;
             end;
           end;
        6: begin
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

procedure TVirtFAEditForm.DeleteLinkClick(Sender: TObject);
var T: TEntity; L: TListItem;
begin
  L:=ListView1.Selected;
  case L.Index of
    5: T:=E.AnaWork;
    6: T:=E.DigWork;
  else
    T:=nil;
  end;
  if (T <> nil) and
     (RemxForm.ShowQuestion('Удалить связь "'+T.PtName+'"?')=mrOK) then
  begin
    case L.Index of
      5: begin E.AnaWork:=nil; L.SubItems[0]:='------'; L.SubItemImages[0]:=-1; end;
      6: begin E.DigWork:=nil; L.SubItems[0]:='------'; L.SubItemImages[0]:=-1; end;
    end;
  end;
end;

procedure TVirtFAEditForm.ChangePeriodKindClick(Sender: TObject);
var M: TMenuItem; L: TListItem;
begin
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  E.PeriodKind:=TPeriodKind(M.Tag);
  L.SubItems[0]:=APeriodKind[E.PeriodKind];
end;

procedure TVirtFAEditForm.ChangeBaseKindClick(Sender: TObject);
var M: TMenuItem; L: TListItem;
begin
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  E.BaseKind:=TBaseKind(M.Tag);
  L.SubItems[0]:=ABaseKind[E.BaseKind];
end;

procedure TVirtFAEditForm.ChangeCalcKindClick(Sender: TObject);
var M: TMenuItem; L: TListItem;
begin
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  E.CalcKind:=TCalcKind(M.Tag);
  L.SubItems[0]:=ACalcKind[E.CalcKind];
end;

procedure TVirtFAEditForm.PopupMenu2Popup(Sender: TObject);
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
        M.OnClick:=ChangeGroupLinkClick;
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
      M.OnClick:=DeleteGroupLinkClick;
      M.Enabled:=(L.Data <> nil);
      Items.Add(M);
    end;
  end;
end;

procedure TVirtFAEditForm.ChangeGroupLinkClick(Sender: TObject);
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
        if not Assigned(R.SourceEntity) and R.IsAnalog and
           not R.IsParam and R.IsVirtual and not R.IsComposit then
          List.Add(R);
        R:=R.NextEntity;
      end;
      if GetLinkNameDlg(Self,'Значение связи "'+GetChildNames(L.Index)+'"',List,
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
              Caption:=GetChildNames(L.Index);
              SubItems[0]:=E.EntityChilds[L.Index].PtName;
              SubItemImages[0]:=EntityClassIndex(E.EntityChilds[L.Index].ClassType)+3;
              SubItems[1]:=E.EntityChilds[L.Index].PtDesc;
            end
            else
            begin
              Data:=nil;
              ImageIndex:=-1;
              Caption:=GetChildNames(L.Index);
              SubItems[0]:='------';
              SubItemImages[0]:=-1;
              SubItems[1]:='------';
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
        E.ShowEditor(Monitor.MonitorNum);
        ListView2.SetFocus;
        ListView2.Selected:=ListView2.FindCaption(0,S,False,True,False);
      end;
    end;
  finally
    List.Free;
    EList.Free;
  end;
end;

procedure TVirtFAEditForm.DeleteGroupLinkClick(Sender: TObject);
var L: TListItem; T: TEntity;
    S: string; i: integer; Found: boolean;
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
          Caption:=GetChildNames(L.Index);
          SubItems[0]:='------';
          SubItemImages[0]:=-1;
          SubItems[1]:='------';
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

procedure TVirtFAEditForm.ListView2DblClick(Sender: TObject);
var E: TEntity; i: integer;
begin
  if ListView2.Selected <> nil then
  begin
    E:=TEntity(ListView2.Selected.Data);
    if Assigned(E) then
      E.ShowEditor(Monitor.MonitorNum)
    else
    if ListView2.SelCount = 1 then
    begin
      PopupMenu2Popup(PopupMenu2);
      for i:=0 to PopupMenu2.Items.Count-1 do
      if PopupMenu2.Items[i].Caption = 'Изменить связь...' then
      begin
        PopupMenu2.Items[i].Click;
        Break;
      end;
    end;
  end;
end;

end.
