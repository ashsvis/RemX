unit VirtVTEditUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, EntityUnit, VirtualUnit, Menus, ExtCtrls;

type
  TVirtVTEditForm = class(TBaseEditForm)
    ListView1: TListView;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    Splitter1: TSplitter;
    ListView2: TListView;
    procedure ListView1DblClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PopupMenu2Popup(Sender: TObject);
    procedure ListView2Data(Sender: TObject; Item: TListItem);
  private
    E: TVirtTank;
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
    procedure ChangeFloatClick(Sender: TObject);
    procedure ImportTableClick(Sender: TObject);
    procedure ExportTableClick(Sender: TObject);
  public
  end;

var
  VirtVTEditForm: TVirtVTEditForm;

implementation

uses StrUtils, GetPtNameUnit, Math, GetLinkNameUnit, RemXUnit, SaveExtDialogUnit;

{$R *.dfm}

{ TVirtFAEditForm }

procedure TVirtVTEditForm.BaseFresh(var Mess: TMessage);
begin
  UpdateRealTime;
end;

procedure TVirtVTEditForm.ConnectBaseEditor(var Mess: TMessage);
begin
  ConnectImageList(TImageList(Mess.WParam));
  ConnectEntity(TEntity(Mess.LParam));
end;

procedure TVirtVTEditForm.ConnectEntity(Entity: TEntity);
begin
  E:=Entity as TVirtTank;
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
        Caption:='Источник уровня';
        if not Assigned(E.Level) then
          SubItems.Add('------')
        else
        begin
          SubItems.Add(E.Level.PtName+' - '+E.Level.PtDesc);
          SubItemImages[0]:=EntityClassIndex(E.Level.ClassType)+3;
        end;
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Источник температуры';
        if not Assigned(E.Temp) then
          SubItems.Add('------')
        else
        begin
          SubItems.Add(E.Temp.PtName+' - '+E.Temp.PtDesc);
          SubItemImages[0]:=EntityClassIndex(E.Temp.ClassType)+3;
        end;
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Источник паспортной плотности';
        if not Assigned(E.PaspDens) then
          SubItems.Add('------')
        else
        begin
          SubItems.Add(E.PaspDens.PtName+' - '+E.PaspDens.PtDesc);
          SubItemImages[0]:=EntityClassIndex(E.PaspDens.ClassType)+3;
        end;
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Приемник расчитанного объёма';
        if not Assigned(E.Volume) then
          SubItems.Add('------')
        else
        begin
          SubItems.Add(E.Volume.PtName+' - '+E.Volume.PtDesc);
          SubItemImages[0]:=EntityClassIndex(E.Volume.ClassType)+3;
        end;
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Приемник расчитанной плотности';
        if not Assigned(E.CalcDens) then
          SubItems.Add('------')
        else
        begin
          SubItems.Add(E.CalcDens.PtName+' - '+E.CalcDens.PtDesc);
          SubItemImages[0]:=EntityClassIndex(E.CalcDens.ClassType)+3;
        end;
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Приемник расчитанной массы';
        if not Assigned(E.Weight) then
          SubItems.Add('------')
        else
        begin
          SubItems.Add(E.Weight.PtName+' - '+E.Weight.PtDesc);
          SubItemImages[0]:=EntityClassIndex(E.Weight.ClassType)+3;
        end;
      end;
    finally
      Items.EndUpdate;
    end;
  end;
//=========================================================================
  ListView2.Items.Count := 2001;
end;

procedure TVirtVTEditForm.ConnectImageList(ImageList: TImageList);
begin
  ListView1.SmallImages:=ImageList;
  ListView2.SmallImages:=ImageList;
end;

procedure TVirtVTEditForm.ListView1DblClick(Sender: TObject);
begin
  if ListView1.Selected <> nil then
  begin
    if ListView1.Selected.Caption = 'Источник уровня' then
    begin
      if Assigned(E.Level) then
        E.Level.ShowEditor(Monitor.MonitorNum);
    end
    else
    if ListView1.Selected.Caption = 'Источник температуры' then
    begin
      if Assigned(E.Temp) then
        E.Temp.ShowEditor(Monitor.MonitorNum);
    end
    else
    if ListView1.Selected.Caption = 'Источник паспортной плотности' then
    begin
      if Assigned(E.PaspDens) then
        E.PaspDens.ShowEditor(Monitor.MonitorNum);
    end
    else
    if ListView1.Selected.Caption = 'Приемник расчитанного объёма' then
    begin
      if Assigned(E.Volume) then
        E.Volume.ShowEditor(Monitor.MonitorNum);
    end
    else
    if ListView1.Selected.Caption = 'Приемник расчитанной плотности' then
    begin
      if Assigned(E.CalcDens) then
        E.CalcDens.ShowEditor(Monitor.MonitorNum);
    end
    else
    if ListView1.Selected.Caption = 'Приемник расчитанной массы' then
    begin
      if Assigned(E.Weight) then
        E.Weight.ShowEditor(Monitor.MonitorNum);
    end;
  end;
end;

procedure TVirtVTEditForm.UpdateRealTime;
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

procedure TVirtVTEditForm.PopupMenu1Popup(Sender: TObject);
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
      2: begin
           M:=TMenuItem.Create(Self);
           M.Caption:='Нет';
           case L.Index of
             2: M.Checked:=not E.Actived;
           end;
           M.Tag:=0;
           M.OnClick:=ChangeBooleanClick;
           Items.Add(M);
           M:=TMenuItem.Create(Self);
           M.Caption:='Да';
           case L.Index of
             2: M.Checked:=E.Actived;
           end;
           M.Tag:=1;
           M.OnClick:=ChangeBooleanClick;
           Items.Add(M);
         end;
  5..10: begin
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
             5: M.Enabled:=Assigned(E.Level);
             6: M.Enabled:=Assigned(E.Temp);
             7: M.Enabled:=Assigned(E.PaspDens);
             8: M.Enabled:=Assigned(E.Volume);
             9: M.Enabled:=Assigned(E.CalcDens);
            10: M.Enabled:=Assigned(E.Weight);
           end;
           Items.Add(M);
         end;
    end;
  end;
end;

procedure TVirtVTEditForm.ChangeTextClick(Sender: TObject);
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

procedure TVirtVTEditForm.ChangeFetchClick(Sender: TObject);
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

procedure TVirtVTEditForm.ChangeBooleanClick(Sender: TObject);
var L: TListItem; M: TMenuItem; B: Boolean;
begin
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  B:=(M.Tag = 1);
  if L <> nil then
    case L.Index of
       2: begin E.Actived:=B; L.SubItems[0]:=IfThen(E.Actived,'Да','Нет'); end;
    end;
end;

procedure TVirtVTEditForm.ChangeLinkClick(Sender: TObject);
var List: TList; T,R: TEntity; L: TListItem;
begin
  L:=ListView1.Selected;
  List:=TList.Create;
  try
    case L.Index of
     5: T:=E.Level;
     6: T:=E.Temp;
     7: T:=E.PaspDens;
     8: T:=E.Volume;
     9: T:=E.CalcDens;
    10: T:=E.Weight;
    end;
    R:=Caddy.FirstEntity;
    while R <> nil do
    begin
      if L.Index in [5..7] then
      begin
        if R.IsAnalog and not R.IsParam and not R.IsComposit then
          List.Add(R)
      end;
      if L.Index in [8..10] then
      begin
        if R.IsAnalog and not R.IsParam and not R.IsComposit and R.IsVirtual then
          List.Add(R)
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
               E.Level:=T as TCustomAnaOut;
               L.SubItems[0]:=E.Level.PtName+' - '+E.Level.PtDesc;
               L.SubItemImages[0]:=EntityClassIndex(E.Level.ClassType)+3;
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
               E.Temp:=T as TCustomAnaOut;
               L.SubItems[0]:=E.Temp.PtName+' - '+E.Temp.PtDesc;
               L.SubItemImages[0]:=EntityClassIndex(E.Temp.ClassType)+3;
             end;
           end;
        7: begin
             if not Assigned(T) then
             begin
               L.SubItems[0]:='------';
               L.SubItemImages[0]:=-1;
             end
             else
             begin
               E.PaspDens:=T as TCustomAnaOut;
               L.SubItems[0]:=E.PaspDens.PtName+' - '+E.PaspDens.PtDesc;
               L.SubItemImages[0]:=EntityClassIndex(E.PaspDens.ClassType)+3;
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
               E.Volume:=T as TCustomAnaOut;
               L.SubItems[0]:=E.Volume.PtName+' - '+E.Volume.PtDesc;
               L.SubItemImages[0]:=EntityClassIndex(E.Volume.ClassType)+3;
               if (E.EntityChilds[0] <> T) and Assigned(E.EntityChilds[0]) then
                 E.EntityChilds[0].SourceEntity:=nil;
               E.EntityChilds[0]:=T;
             end;
             UpdateBaseView(Self);
             E.ShowEditor(Monitor.MonitorNum);
           end;
        9: begin
             if not Assigned(T) then
             begin
               L.SubItems[0]:='------';
               L.SubItemImages[0]:=-1;
             end
             else
             begin
               E.CalcDens:=T as TCustomAnaOut;
               L.SubItems[0]:=E.CalcDens.PtName+' - '+E.CalcDens.PtDesc;
               L.SubItemImages[0]:=EntityClassIndex(E.CalcDens.ClassType)+3;
               if (E.EntityChilds[1] <> T) and Assigned(E.EntityChilds[1]) then
                 E.EntityChilds[1].SourceEntity:=nil;
               E.EntityChilds[1]:=T;
             end;
             UpdateBaseView(Self);
             E.ShowEditor(Monitor.MonitorNum);
           end;
       10: begin
             if not Assigned(T) then
             begin
               L.SubItems[0]:='------';
               L.SubItemImages[0]:=-1;
             end
             else
             begin
               E.Weight:=T as TCustomAnaOut;
               L.SubItems[0]:=E.Weight.PtName+' - '+E.Weight.PtDesc;
               L.SubItemImages[0]:=EntityClassIndex(E.Weight.ClassType)+3;
               if (E.EntityChilds[2] <> T) and Assigned(E.EntityChilds[2]) then
                 E.EntityChilds[2].SourceEntity:=nil;
               E.EntityChilds[2]:=T;
             end;
             UpdateBaseView(Self);
             E.ShowEditor(Monitor.MonitorNum);
           end;
      end;
    end;
  finally
    List.Free;
  end;
end;

procedure TVirtVTEditForm.DeleteLinkClick(Sender: TObject);
var T: TEntity; L: TListItem;
begin
  L:=ListView1.Selected;
  case L.Index of
    5: T:=E.Level;
    6: T:=E.Temp;
    7: T:=E.PaspDens;
    8: T:=E.Volume;
    9: T:=E.CalcDens;
   10: T:=E.Weight;
  else
    T:=nil;
  end;
  if (T <> nil) and
     (RemxForm.ShowQuestion('Удалить связь "'+T.PtName+'"?')=mrOK) then
  begin
    case L.Index of
      5: begin E.Level:=nil; L.SubItems[0]:='------'; L.SubItemImages[0]:=-1; end;
      6: begin E.Temp:=nil; L.SubItems[0]:='------'; L.SubItemImages[0]:=-1; end;
      7: begin E.PaspDens:=nil; L.SubItems[0]:='------'; L.SubItemImages[0]:=-1; end;
      8: begin E.Volume:=nil; E.EntityChilds[0]:=nil; L.SubItems[0]:='------'; L.SubItemImages[0]:=-1; end;
      9: begin E.CalcDens:=nil; E.EntityChilds[1]:=nil; L.SubItems[0]:='------'; L.SubItemImages[0]:=-1; end;
     10: begin E.Weight:=nil;  E.EntityChilds[2]:=nil; L.SubItems[0]:='------'; L.SubItemImages[0]:=-1; end;
    end;
    if L.Index in [8..10] then
    begin
      UpdateBaseView(Self);
      E.ShowEditor(Monitor.MonitorNum);
    end;
  end;
end;

procedure TVirtVTEditForm.PopupMenu2Popup(Sender: TObject);
var L: TListItem; M: TMenuItem;
begin
  L:=ListView2.Selected;
  with PopupMenu2 do
  begin
    Items.Clear;
    if L <> nil then
    begin
      M:=TMenuItem.Create(Self);
      M.Caption:='Изменить значение...';
      M.OnClick:=ChangeFloatClick;
      Items.Add(M);
      M:=TMenuItem.Create(Self);
      M.Caption:='-';
      Items.Add(M);
      M:=TMenuItem.Create(Self);
      M.Caption:='Импорт таблицы значений';
      M.OnClick:=ImportTableClick;
      Items.Add(M);
      M:=TMenuItem.Create(Self);
      M.Caption:='Экспорт таблицы значений';
      M.OnClick:=ExportTableClick;
      Items.Add(M);
    end;
  end;
end;

procedure TVirtVTEditForm.ListView2Data(Sender: TObject; Item: TListItem);
var L: TListItem;
begin
    L:=Item;
  try
    L.Caption:=Format('%d',[L.Index]);
    L.SubItems.Add(Format('%g',[E.Levels[L.Index]]));
  except
    L.Caption:='-----'
  end;
end;

procedure TVirtVTEditForm.ChangeFloatClick(Sender: TObject);
var L: TListItem; sFormat, sLevel: string; V: Single;
begin
  if not Assigned(E) then Exit;
  L:=ListView2.Selected;
  if Assigned(L) then
  begin
    V:=E.Levels[L.Index];
    sFormat:='%g';
    if L.Index < 100 then
      sLevel:=Format('%d см',[L.Index])
    else
      sLevel:=Format('%d м %d см',[L.Index div 100, L.Index mod 100]);
    if InputFloatDlg('Значение объёма для уровня '+sLevel,sFormat,V) then
    begin
      if InRange(V,0,V) then
      begin
        E.Levels[L.Index]:=V;
        L.SubItems[0]:=Format(sFormat,[E.Levels[L.Index]]);
        ListView2.Invalidate;
      end
      else
        raise ERangeError.Create('Значение вне допустимых границ!');
    end;
  end;
end;

procedure TVirtVTEditForm.ImportTableClick(Sender: TObject);
var SL: TStringList; i,iLevel: integer; fVolume: Double; S: string; LDS: Char;
begin
  SaveExtDialogForm:=TSaveExtDialogForm.Create(Self);
  try
    SaveExtDialogForm.InitialDir:=Caddy.CurrentBasePath;
    SaveExtDialogForm.Filter:='CSV(разделители - запятые)(*.csv)|*.csv';
    SaveExtDialogForm.FileName:='';
    SaveExtDialogForm.DefaultExt:='.csv';
    SaveExtDialogForm.Caption:='Импорт значений...';
    SaveExtDialogForm.Button1.Caption:='Импорт';
    if SaveExtDialogForm.Execute then
    begin
      Update;
      SL:=TStringList.Create;
      try
        for i:=0 to 2000 do E.Levels[i]:=0.0;
        SL.LoadFromFile(SaveExtDialogForm.FileName);
        for i:=0 to SL.Count-1 do
        begin
          S:=SL[i];
          iLevel:=StrToIntDef(Copy(S,1,Pos(';',S)-1),-1);
          if (iLevel >= 0) and (iLevel <= 2000) then
          begin
            Delete(S,1,Pos(';',S));
            LDS:=DecimalSeparator;
            if Pos('.',S) > 0 then
              DecimalSeparator:='.'
            else
            if Pos(',',S) > 0 then
              DecimalSeparator:=',';
            fVolume:=StrToFloatDef(S,-1.0);
            DecimalSeparator:=LDS;
            if fVolume > 0.00001 then
              E.Levels[iLevel]:=fVolume;
          end;
        end;
        ListView2.Invalidate;
      finally
        SL.Free;
      end;
    end;
  finally
    SaveExtDialogForm.Free;
  end;
end;

procedure TVirtVTEditForm.ExportTableClick(Sender: TObject);
var SL: TStringList; i: integer; LDS: Char;
begin
  SaveExtDialogForm:=TSaveExtDialogForm.Create(Self);
  try
    SaveExtDialogForm.InitialDir:=Caddy.CurrentBasePath;
    SaveExtDialogForm.Filter:='CSV(разделители - запятые)(*.csv)|*.csv';
    SaveExtDialogForm.FileName:='';
    SaveExtDialogForm.DefaultExt:='.csv';
    SaveExtDialogForm.Caption:='Экспорт значений...';
    SaveExtDialogForm.Button1.Caption:='Экспорт';
    if SaveExtDialogForm.Execute then
    begin
      Update;
      if not FileExists(SaveExtDialogForm.FileName) or
         FileExists(SaveExtDialogForm.FileName) and
        (RemXForm.ShowQuestion('Указанный файл существует. Переписать?') = mrYes) then
      begin
        SL:=TStringList.Create;
        try
          LDS:=DecimalSeparator;
          DecimalSeparator:='.';
          for i:=0 to 2000 do
            if E.Levels[i] > 0.0 then SL.Add(Format('%d;%g',[i,E.Levels[i]]));
          DecimalSeparator:=LDS;
          SL.SaveToFile(SaveExtDialogForm.FileName);
        finally
          SL.Free;
        end;
      end;
    end;
  finally
    SaveExtDialogForm.Free;
  end;
end;

end.
