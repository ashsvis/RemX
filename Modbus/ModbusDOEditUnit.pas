unit ModbusDOEditUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, EntityUnit, ModbusUnit, Menus, ImgList;

type
  TModbusDOEditForm = class(TBaseEditForm)
    ListView1: TListView;
    PopupMenu1: TPopupMenu;
    ImageList1: TImageList;
    procedure ListView1DblClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    E: TModbusDigOut;
    procedure ConnectBaseEditor(var Mess: TMessage); message WM_ConnectBaseEditor;
    procedure BaseFresh(var Mess: TMessage); message WM_Fresh;
    procedure ConnectEntity(Entity: TEntity); stdcall;
    procedure ConnectImageList(ImageList: TImageList); stdcall;
    procedure UpdateRealTime; stdcall;
    procedure ChangeIntegerClick(Sender: TObject);
    procedure ChangeTextClick(Sender: TObject);
    procedure ChangeFetchClick(Sender: TObject);
    procedure ChangeBooleanClick(Sender: TObject);
    procedure ChangeFixedColorClick(Sender: TObject);
    procedure ChangeAddrPrefixClick(Sender: TObject);
  public
  end;

var
  ModbusDOEditForm: TModbusDOEditForm;

implementation

uses StrUtils, GetPtNameUnit, Math;

{$R *.dfm}

{ TKontDOEditForm }

procedure TModbusDOEditForm.BaseFresh(var Mess: TMessage);
begin
  UpdateRealTime;
end;

procedure TModbusDOEditForm.ConnectBaseEditor(var Mess: TMessage);
begin
  ConnectImageList(TImageList(Mess.WParam));
  ConnectEntity(TEntity(Mess.LParam));
end;

procedure TModbusDOEditForm.ConnectEntity(Entity: TEntity);
begin
  E:=Entity as TModbusDigOut;
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
        Caption:='Адрес данных';
        SubItems.Add(IntToStr(E.Address));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Префикс адреса';
        SubItems.Add(ADigAddrPrefix[E.AddrPrefix]);
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
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Источник данных';
        if E.SourceEntity=nil then
          SubItems.Add('Авто')
        else
        begin
          SubItems.Add(E.SourceEntity.PtName+' - '+E.SourceEntity.PtDesc);
          SubItemImages[0]:=EntityClassIndex(E.SourceEntity.ClassType)+3;
        end;
      end;
//=========================================================================
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Инверсия данных';
        SubItems.Add(IfThen(E.Invert,'Да','Нет'));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Авария при "0"->"1"';
        SubItems.Add(IfThen(E.AlarmUp,'Да','Нет'));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Авария при "1"->"0"';
        SubItems.Add(IfThen(E.AlarmDown,'Да','Нет'));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Переключение при "0"->"1"';
        SubItems.Add(IfThen(E.SwitchUp,'Да','Нет'));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Переключение при "1"->"0"';
        SubItems.Add(IfThen(E.SwitchDown,'Да','Нет'));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Цвет при "1"';
        SubItems.Add(StringDigColor[E.ColorUp]);
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Цвет при "0"';
        SubItems.Add(StringDigColor[E.ColorDown]);
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Текст при "1"';
        SubItems.Add(E.TextUp);
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Текст при "0"';
        SubItems.Add(E.TextDown);
      end;
    finally
      Items.EndUpdate;
    end;
  end;
end;

procedure TModbusDOEditForm.ConnectImageList(ImageList: TImageList);
begin
  ListView1.SmallImages:=ImageList;
end;

procedure TModbusDOEditForm.ListView1DblClick(Sender: TObject);
begin
  if (ListView1.Selected <> nil) and
     (ListView1.Selected.Caption = 'Источник данных') then
  begin
    if Assigned(E.SourceEntity) then
      E.SourceEntity.ShowEditor(Monitor.MonitorNum);
  end;
end;

procedure TModbusDOEditForm.UpdateRealTime;
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

procedure TModbusDOEditForm.PopupMenu1Popup(Sender: TObject);
var L: TListItem; M: TMenuItem; DC: TDigColor; u: TAddrPrefix;
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
   1..3: begin
           M:=TMenuItem.Create(Self);
           M.Caption:='Изменить число...';
           M.OnClick:=ChangeIntegerClick;
           Items.Add(M);
         end;
      4: for u:=Low(ADigAddrPrefix) to High(ADigAddrPrefix) do
         begin
           M:=TMenuItem.Create(Self);
           M.Caption:=ADigAddrPrefix[u];
           M.Tag:=Ord(u);
           M.OnClick:=ChangeAddrPrefixClick;
           M.Checked:=(E.AddrPrefix = u);
           Items.Add(M);
         end;
5,19,20: begin
           M:=TMenuItem.Create(Self);
           M.Caption:='Изменить текст...';
           M.OnClick:=ChangeTextClick;
           Items.Add(M);
         end;
      7: begin
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
  6,9,10,
  12..16: begin
           M:=TMenuItem.Create(Self);
           M.Caption:='Нет';
           case L.Index of
             6: M.Checked:=not E.Actived;
             9: M.Checked:=not E.Logged;
            10: M.Checked:=not E.Asked;
            12: M.Checked:=not E.Invert;
            13: M.Checked:=not E.AlarmUp;
            14: M.Checked:=not E.AlarmDown;
            15: M.Checked:=not E.SwitchUp;
            16: M.Checked:=not E.SwitchDown;
           end;
           M.Tag:=0;
           M.OnClick:=ChangeBooleanClick;
           Items.Add(M);
           M:=TMenuItem.Create(Self);
           M.Caption:='Да';
           case L.Index of
             6: M.Checked:=E.Actived;
             9: M.Checked:=E.Logged;
            10: M.Checked:=E.Asked;
            12: M.Checked:=E.Invert;
            13: M.Checked:=E.AlarmUp;
            14: M.Checked:=E.AlarmDown;
            15: M.Checked:=E.SwitchUp;
            16: M.Checked:=E.SwitchDown;
           end;
           M.Tag:=1;
           M.OnClick:=ChangeBooleanClick;
           Items.Add(M);
         end;
  17,18: for DC:=Low(StringDigColor) to High(StringDigColor) do
         begin
           Images:=ImageList1;
           M:=TMenuItem.Create(Self);
           M.Caption:=StringDigColor[DC];
           case L.Index of
             17: M.Default:=(E.ColorUp = DC);
             18: M.Default:=(E.ColorDown = DC);
           end;
           M.Tag:=Ord(DC);
           M.OnClick:=ChangeFixedColorClick;
           M.ImageIndex:=Ord(DC);
           Items.Add(M);
         end;
    end;
  end;
end;

procedure TModbusDOEditForm.ChangeIntegerClick(Sender: TObject);
var L: TListItem; V: Integer;
begin
  L:=ListView1.Selected;
  if L <> nil then
  begin
    case L.Index of
     1: V:=E.Channel;
     2: V:=E.Node;
     3: V:=E.Address;
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
        3: if InRange(V,1,65535) then
           begin
             E.Address:=V;
             L.SubItems[0]:=Format('%d',[E.Address]);
           end
           else
             raise ERangeError.Create('Значение вне допустимых границ (1..65535)!');
      end;
      if L.Index in [1..2] then
      begin
        UpdateBaseView(Self);
        RestoreEntityPos(E);
      end;
    end;
  end;
end;

procedure TModbusDOEditForm.ChangeTextClick(Sender: TObject);
var L: TListItem; S: string;
begin
  L:=ListView1.Selected;
  if L <> nil then
  begin
    S:=L.SubItems[0];
    if InputStringDlg(L.Caption,S,IfThen(L.Index=5,50,10)) then
    case L.Index of
      5: begin E.PtDesc:=S; L.SubItems[0]:=E.PtDesc; end;
     19: begin E.TextUp:=S; L.SubItems[0]:=E.TextUp; end;
     20: begin E.TextDown:=S; L.SubItems[0]:=E.TextDown; end;
    end;
  end;
end;

procedure TModbusDOEditForm.ChangeFetchClick(Sender: TObject);
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

procedure TModbusDOEditForm.ChangeBooleanClick(Sender: TObject);
var L: TListItem; M: TMenuItem; B: Boolean;
begin
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  B:=(M.Tag = 1);
  if L <> nil then
    case L.Index of
       6: begin E.Actived:=B; L.SubItems[0]:=IfThen(E.Actived,'Да','Нет'); end;
       9: begin E.Logged:=B; L.SubItems[0]:=IfThen(E.Logged,'Да','Нет'); end;
      10: begin E.Asked:=B; L.SubItems[0]:=IfThen(E.Asked,'Да','Нет'); end;
      12: begin E.Invert:=B; L.SubItems[0]:=IfThen(E.Invert,'Да','Нет'); end;
      13: begin E.AlarmUp:=B; L.SubItems[0]:=IfThen(E.AlarmUp,'Да','Нет'); end;
      14: begin E.AlarmDown:=B; L.SubItems[0]:=IfThen(E.AlarmDown,'Да','Нет'); end;
      15: begin E.SwitchUp:=B; L.SubItems[0]:=IfThen(E.SwitchUp,'Да','Нет'); end;
      16: begin E.SwitchDown:=B; L.SubItems[0]:=IfThen(E.SwitchDown,'Да','Нет'); end;
    end;
end;

procedure TModbusDOEditForm.ChangeFixedColorClick(Sender: TObject);
var L: TListItem; M: TMenuItem; DC: TDigColor;
begin
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  DC:=TDigColor(M.Tag);
  if L <> nil then
    case L.Index of
      17: begin E.ColorUp:=DC; L.SubItems[0]:=StringDigColor[E.ColorUp]; end;
      18: begin E.ColorDown:=DC; L.SubItems[0]:=StringDigColor[E.ColorDown]; end;
    end;
end;

procedure TModbusDOEditForm.FormCreate(Sender: TObject);
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

procedure TModbusDOEditForm.ChangeAddrPrefixClick(Sender: TObject);
var L: TListItem; M: TMenuItem;
begin
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  if L <> nil then
  begin
    with ListView1 do
    case L.Index of
     4: begin
           E.AddrPrefix:=TAddrPrefix(M.Tag);
           Items[4].SubItems[0]:=ADigAddrPrefix[E.AddrPrefix];
         end;
    end;
  end;
end;

end.
