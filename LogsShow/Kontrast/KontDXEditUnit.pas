unit KontDXEditUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Menus, EntityUnit, KontrastUnit, ImgList;

type
  TKontDXEditForm = class(TKontEditForm)
    ImageList1: TImageList;
    procedure FormCreate(Sender: TObject);
  private
    E: TKontDigPtx;
    procedure ChangeFixedColorClick(Sender: TObject);
    procedure ChangeEnumerationClick(Sender: TObject);
  protected
    procedure ConnectEntity(Entity: TEntity); override;
    procedure PopupMenu1Popup(Sender: TObject); override;
    procedure ChangeIntegerClick(Sender: TObject); override;
    procedure ChangeTextClick(Sender: TObject); override;
    procedure ChangeBooleanClick(Sender: TObject); override;
  public
  end;

var
  KontDXEditForm: TKontDXEditForm;

implementation

uses StrUtils, GetPtNameUnit, Math;

{$R *.dfm}

{ TKontDOEditForm }

procedure TKontDXEditForm.ConnectEntity(Entity: TEntity);
begin
  inherited;
  E:=Entity as TKontDigPtx;
  with ListView1 do
  begin
    Items.BeginUpdate;
    try
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Тип переменной';
        SubItems.Add(E.PropsValue(4));
      end;
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Смещение';
        SubItems.Add(E.PropsValue(5));
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
      with Items.Add do
      begin
        ImageIndex:=-1;
        Caption:='Время строба';
        SubItems.Add(Format('%d мсек',[E.PulseWait]));
      end;
    finally
      Items.EndUpdate;
    end;
  end;
end;

procedure TKontDXEditForm.PopupMenu1Popup(Sender: TObject);
var L: TListItem; M: TMenuItem; DC: TDigColor; i: integer;
begin
  inherited;
  L:=ListView1.Selected;
  with PopupMenu1 do
  begin
    Images:=nil;
    if Assigned(L) then
    begin
      if L.Caption = 'Тип переменной' then
      begin
        for i:=Low(DigPtxType) to High(DigPtxType) do
        begin
          M:=TMenuItem.Create(Self);
          M.Caption:=DigPtxType[i];
          M.Tag:=i;
          M.OnClick:=ChangeEnumerationClick;
          M.Checked:=(E.Block = i);
          Items.Add(M);
        end;
      end;
      if (L.Caption = 'Смещение') or 
         (L.Caption = 'Время строба') then
      begin
        M:=TMenuItem.Create(Self);
        M.Caption:='Изменить число...';
        M.OnClick:=ChangeIntegerClick;
        Items.Add(M);
      end;
      if L.Caption = 'Сигнализация' then AddBoolItem(E.Logged);
      if L.Caption = 'Квитирование' then AddBoolItem(E.Asked);
      if L.Caption = 'Инверсия данных' then AddBoolItem(E.Invert);
      if L.Caption = 'Авария при "0"->"1"' then AddBoolItem(E.AlarmUp);
      if L.Caption = 'Авария при "1"->"0"' then AddBoolItem(E.AlarmDown);
      if L.Caption = 'Переключение при "0"->"1"' then AddBoolItem(E.SwitchUp);
      if L.Caption = 'Переключение при "1"->"0"' then AddBoolItem(E.SwitchDown);
      if (L.Caption = 'Цвет при "1"') or
         (L.Caption = 'Цвет при "0"') then
      begin
        for DC:=Low(StringDigColor) to High(StringDigColor) do
        begin
          Images:=ImageList1;
          M:=TMenuItem.Create(Self);
          M.Caption:=StringDigColor[DC];
          if L.Caption = 'Цвет при "1"' then
            M.Default:=(E.ColorUp = DC)
          else
            M.Default:=(E.ColorDown = DC);
          M.Tag:=Ord(DC);
          M.OnClick:=ChangeFixedColorClick;
          M.ImageIndex:=Ord(DC);
          Items.Add(M);
        end;
      end;
      if (L.Caption = 'Текст при "1"') or
         (L.Caption = 'Текст при "0"') then
      begin
        M:=TMenuItem.Create(Self);
        M.Caption:='Изменить текст...';
        M.OnClick:=ChangeTextClick;
        Items.Add(M);
      end;
    end;
  end;
end;

procedure TKontDXEditForm.ChangeIntegerClick(Sender: TObject);
var L: TListItem; Value: string; IntVal,Err: Integer; RealVal: Double;
    KB,KS: byte;
begin
  inherited;
  L:=ListView1.Selected;
  if Assigned(L) then
  begin
    if L.Caption = 'Смещение' then Value:=E.PropsValue(5)
    else
      if L.Caption = 'Время строба' then Value:=IntToStr(E.PulseWait)
      else
        Exit;
    if InputStringDlg(L.Caption,Value) then
    begin
      if L.Caption = 'Смещение' then
      begin
        IntVal:=0;
        if E.Block = 4 then
        begin
          Val(Value,RealVal,Err);
          if (Err <> 0) or (Pos('.',Value) = 0) or (RealVal < 0.0) then
          begin
            raise ERangeError.Create('Ошибка при вводе адреса ключа секции!');
            Exit;
          end;
        end
        else
        begin
          Val(Value,IntVal,Err);
          if Err <> 0 then
          begin
            raise ERangeError.Create('Ошибка при вводе целочисленного значения!');
            Exit;
          end;
        end;
        case E.Block of
        0: begin
             if (Pos('8',Value) = Length(Value)) or
                (Pos('9',Value) = Length(Value)) then
               raise ERangeError.Create(
                 'Ошибка в адресе дискретной переменной!')
             else
               E.Place:=StrToIntDef(Copy(Value,1,Length(Value)-1),0)*8+
                        StrToIntDef(Copy(Value,Length(Value),1),0);
           end;
        3: if InRange(IntVal,0,255) then
             E.Place:=IntVal
           else
             raise ERangeError.Create(
                 'Ожидалось число в диапазоне 0..255!');
        4: begin
             Val(Copy(Value,1,Pos('.',Value)-1),KB,Err);
             if Err <> 0 then
               raise ERangeError.Create(
                 'Ожидался ключ блока в диапазоне 0..255!')
             else
             begin
               Val(Copy(Value,Pos('.',Value)+1,Length(Value)),KS,Err);
               if Err <> 0 then
                 raise ERangeError.Create(
                   'Ожидался ключ секции в диапазоне 0..255!')
               else
                 E.Place:=KS+256*KB;
             end;
           end;
        else
          E.Place:=IntVal;
        end; {case}
        L.SubItems[0]:=E.PropsValue(5);
      end;
      if L.Caption = 'Время строба' then
      begin
        Val(Value,IntVal,Err);
        if Err <> 0 then
        begin
          raise ERangeError.Create('Ошибка при вводе целочисленного значения!');
          Exit;
        end;
        if InRange(IntVal,10,10000) then
        begin
          E.PulseWait:=IntVal;
          L.SubItems[0]:=E.PropsValue(20);
        end
        else
          raise ERangeError.Create('Значение вне допустимых границ (10..10000 мсек)!');
      end;
    end;
  end;
end;

procedure TKontDXEditForm.ChangeTextClick(Sender: TObject);
var L: TListItem; S: string;
begin
  inherited;
  L:=ListView1.Selected;
  if Assigned(L) then
  begin
    if (L.Caption = 'Текст при "1"') or
       (L.Caption = 'Текст при "0"') then
      S:=L.SubItems[0]
    else
      Exit;
    if InputStringDlg(L.Caption,S,10) then
    begin
      if L.Caption = 'Текст при "1"' then
      begin
        E.TextUp:=S;
        L.SubItems[0]:=E.TextUp;
      end;
      if L.Caption = 'Текст при "0"' then
      begin
        E.TextDown:=S;
        L.SubItems[0]:=E.TextDown;
      end;
    end;
  end;
end;

procedure TKontDXEditForm.ChangeBooleanClick(Sender: TObject);
var L: TListItem; M: TMenuItem; B: Boolean;
begin
  inherited;
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  B:=(M.Tag = 1);
  if Assigned(L) then
  begin
    if L.Caption = 'Сигнализация' then
    begin
      E.Logged:=B;
      L.SubItems[0]:=IfThen(E.Logged,'Да','Нет');
    end;
    if L.Caption = 'Квитирование' then
    begin
      E.Asked:=B;
      L.SubItems[0]:=IfThen(E.Asked,'Да','Нет');
    end;
    if L.Caption = 'Инверсия данных' then
    begin
      E.Invert:=B;
      L.SubItems[0]:=IfThen(E.Invert,'Да','Нет');
    end;
    if L.Caption = 'Авария при "0"->"1"' then
    begin
      E.AlarmUp:=B;
      L.SubItems[0]:=IfThen(E.AlarmUp,'Да','Нет');
    end;
    if L.Caption = 'Авария при "1"->"0"' then
    begin
      E.AlarmDown:=B;
      L.SubItems[0]:=IfThen(E.AlarmDown,'Да','Нет');
    end;
    if L.Caption = 'Переключение при "0"->"1"' then
    begin
      E.SwitchUp:=B;
      L.SubItems[0]:=IfThen(E.SwitchUp,'Да','Нет');
    end;
    if L.Caption = 'Переключение при "1"->"0"' then
    begin
      E.SwitchDown:=B;
      L.SubItems[0]:=IfThen(E.SwitchDown,'Да','Нет');
    end;
  end
end;

procedure TKontDXEditForm.ChangeFixedColorClick(Sender: TObject);
var L: TListItem; M: TMenuItem; DC: TDigColor;
begin
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  DC:=TDigColor(M.Tag);
  if Assigned(L) then
  begin
    if L.Caption = 'Текст при "1"' then
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

procedure TKontDXEditForm.FormCreate(Sender: TObject);
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

procedure TKontDXEditForm.ChangeEnumerationClick(Sender: TObject);
var L: TListItem; M: TMenuItem;
begin
  L:=ListView1.Selected;
  M:=Sender as TMenuItem;
  if Assigned(L) then
  begin
    if L.Caption = 'Тип переменной' then
    begin
      E.Block:=M.MenuIndex;
      L.SubItems[0]:=E.PropsValue(4);
      L:=ListView1.FindCaption(0,'Смещение',False,True,False);
      if Assigned(L) then L.SubItems[0]:= E.PropsValue(5);
    end;
  end;
end;

end.
