unit ResursTreeUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, ToolWin, ResursGLHUnit;

type
  TResursTreeForm = class(TForm)
    ToolBar1: TToolBar;
    TV: TTreeView;
    Splitter1: TSplitter;
    LV: TListView;
    tbFresh: TToolButton;
    tbClose: TToolButton;
    ToolButton1: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure TVExpanded(Sender: TObject; Node: TTreeNode);
    procedure TVChange(Sender: TObject; Node: TTreeNode);
    procedure tbFreshClick(Sender: TObject);
    procedure tbCloseClick(Sender: TObject);
  private
    function SensStatus(Value: Byte): string;
  public
    E: TResursGLHNode;
  end;

var
  ResursTreeForm: TResursTreeForm;

implementation

uses StrUtils;

{$R *.dfm}

procedure TResursTreeForm.FormCreate(Sender: TObject);
begin
  LV.DoubleBuffered:=True;
end;

procedure TResursTreeForm.TVExpanded(Sender: TObject; Node: TTreeNode);
var i: integer;
begin
  while Node.getFirstChild <> nil do Node.getFirstChild.Delete;
  case Node.Level of
 0: begin
      if Node.Text = 'Параметры' then
      with TV.Items do
      begin
        AddChild(AddChild(Node,'Общие параметры'),'Stub');
        AddChild(AddChild(Node,'Параметры каналов'),'Stub');
        AddChild(AddChild(Node,'Параметры точек учета'),'Stub');
        AddChild(AddChild(Node,'Параметры групп учета'),'Stub');
      end;
      if Node.Text = 'Данные' then
      with TV.Items do
      begin
        AddChild(Node,'Общие');
        AddChild(AddChild(Node,'Каналы'),'Stub');;
        AddChild(AddChild(Node,'Точки учета'),'Stub');
        AddChild(AddChild(Node,'Группы учета'),'Stub');
      end;
      if Node.Text = 'Протокол' then
      with TV.Items do
      begin
        AddChild(Node,'Протокол работы датчиков');
        AddChild(Node,'Протокол работы точек учета');
        AddChild(Node,'Протокол работы групп');
        AddChild(Node,'Протокол работы преобразователя');
      end;
    end;
 1: begin
      if Node.Text = 'Общие параметры' then
      with TV.Items do
      begin
        AddChild(Node,'Время, Дата, Е.И.');
        AddChild(AddChild(Node,'График температур'),'Stub');
      end;
      if Node.Text = 'Параметры каналов' then
        for i:=1 to 15 do with TV.Items do
          AddChild(Node,'Канал '+IntToStr(i));
      if Node.Text = 'Параметры точек учета' then
        for i:=1 to 5 do with TV.Items do
          AddChild(AddChild(Node,'Точка учета '+IntToStr(i)),'Stub');
      if Node.Text = 'Параметры групп учета' then
        for i:=1 to 15 do with TV.Items do
          AddChild(Node,'Группа учета '+IntToStr(i));
//----------------------------------------------------------------
      if Node.Text = 'Каналы' then
        for i:=1 to 15 do with TV.Items do
          AddChild(Node,'Канал '+IntToStr(i));
      if Node.Text = 'Точки учета' then
        for i:=1 to 5 do with TV.Items do
          AddChild(AddChild(Node,'Точка учета '+IntToStr(i)),'Stub');
      if Node.Text = 'Группы учета' then
        for i:=1 to 15 do with TV.Items do
          AddChild(AddChild(Node,'Группа учета '+IntToStr(i)),'Stub');
    end;
 2: begin
      if Node.Text = 'График температур' then
      with TV.Items do
      begin
        AddChild(Node,'Прямая вода');
        AddChild(Node,'Оборотная вода');
      end;
      if (Pos('Точка учета',Node.Text) = 1) and
         (Node.Parent.Text = 'Параметры точек учета') then
      with TV.Items do
      begin
        AddChild(Node,'Датчики');
        AddChild(Node,'Параметры и вид СУ');
        AddChild(Node,'Рабочая среда');
        AddChild(Node,'Расход');
      end;
      if (Pos('Точка учета',Node.Text) = 1) and
         (Node.Parent.Text = 'Точки учета') then
      with TV.Items do
      begin
        AddChild(Node,'Энергия');
        AddChild(Node,'Энергоноситель');
        AddChild(Node,'Текущие параметры');
      end;
      if (Pos('Группа учета',Node.Text) = 1) and
         (Node.Parent.Text = 'Группы учета') then
      with TV.Items do
      begin
        AddChild(Node,'Текущие параметры');
        AddChild(Node,'Текущий расчетный период');
        AddChild(Node,'Предыдущий расчетный период');
      end;
    end;
  end;
end;

procedure TResursTreeForm.TVChange(Sender: TObject; Node: TTreeNode);
const AMonth: array[1..12] of string = ('января','февраля','марта','апреля',
   'мая','июня','июля','августа','сентября','октября','ноября','декабря');
var i,j,n,k: integer; S: string; A: array[0..3] of byte; R: Single; Flag: boolean;
begin
  LV.Items.BeginUpdate;
  try
    LV.Items.Clear;
  finally
    LV.Items.EndUpdate;
  end;
  LV.Columns.BeginUpdate;
  try
    LV.Columns.Clear;
  finally
    LV.Columns.EndUpdate;
  end;
  if Node = nil then Exit;
  if Node.HasChildren then
  begin
    TV.Items.BeginUpdate;
    try
      Flag:=Node.Expanded;
      Node.Expand(False);
      if not Flag then
        Node.Collapse(False);
    finally
      TV.Items.EndUpdate;
    end;
    with LV.Columns.Add do begin
      Caption:='Наименование категории';
      Width:=460;
    end;
    Node:=Node.getFirstChild;
    while Node <> nil do
    begin
      with LV.Items.Add do begin
        Caption:=Node.Text;
      end;
      Node:=Node.getNextSibling;
    end;
    Exit;
  end;
  if Node.Text = 'Время, Дата, Е.И.' then
  begin
    with LV.Columns.Add do begin
      Caption:='Наименование параметра';
      Width:=250;
    end;
    with LV.Columns.Add do begin
      Caption:='Значение';
      Width:=250;
      AutoSize:=True;
    end;
    with LV.Items.Add do begin
      Caption:='Текущее время';
      SubItems.Add(Format('%2.2d:%2.2d:%2.2d',
          [E.B2D(E.Comm66[1925]),E.B2D(E.Comm66[1926]),E.B2D(E.Comm66[1927])]));
    end;
    with LV.Items.Add do begin
      Caption:='Текущая дата';
      SubItems.Add(Format('%2.2d.%2.2d.%2.2d',
          [E.B2D(E.Comm66[1928]),E.B2D(E.Comm66[1929]),E.B2D(E.Comm66[1930])]));
    end;
    with LV.Items.Add do begin
      Caption:='Дата перехода на зимнее время';
      if E.B2D(E.Comm66[1932]) in [1..12] then
        SubItems.Add(Format('%d %s',[E.B2D(E.Comm66[1931]),
                                   AMonth[E.B2D(E.Comm66[1932])]]))
      else
        SubItems.Add('???');
    end;
    with LV.Items.Add do begin
      Caption:='Дата перехода на летнее время';
      if E.B2D(E.Comm66[1932]) in [1..12] then
        SubItems.Add(Format('%d %s',[E.B2D(E.Comm66[1933]),
                                   AMonth[E.B2D(E.Comm66[1934])]]))
      else
        SubItems.Add('???');
    end;
    with LV.Items.Add do begin
      Caption:='Договорное время (часы)';
      SubItems.Add(Format('%d',[E.Comm66[1935]]));
    end;
    with LV.Items.Add do begin
      Caption:='Размерность энергии и энтальпии';
      if E.Comm66[1780] in [0..1] then
        SubItems.Add(AEUDesc66_3[E.Comm66[1780]])
      else
        SubItems.Add('???');
    end;
    with LV.Items.Add do begin
      Caption:='Пуск преобразователя';
      SubItems.Add(IfThen(E.Comm66[1942]=1,'Да','Нет'));
    end;
  end;
  if Node.Text = 'Прямая вода' then
  begin
    with LV.Columns.Add do begin
      Caption:='Температура наружного воздуха';
      Width:=200;
    end;
    with LV.Columns.Add do begin
      Caption:='Температура воды в подающей магистрали';
      Width:=300;
      AutoSize:=True;
    end;
    k:=1781; j:=8;
    for i:=1 to 36 do with LV.Items.Add do begin
      S:=IntToStr(j);
      A[0]:=0;
      A[1]:=0;
      A[2]:=E.Comm66[k];
      A[3]:=E.Comm66[k+1];
      MoveMemory(@R,@A[0],4);
      if Copy(S,1,1) <> '-' then S:='+'+S;
      Caption:=S;
      SubItems.Add(Format('%.6g °C',[R]));
      Inc(k,2);
      Dec(j);
    end;
  end;
  if Node.Text = 'Оборотная вода' then
  begin
    with LV.Columns.Add do begin
      Caption:='Температура наружного воздуха';
      Width:=200;
    end;
    with LV.Columns.Add do begin
      Caption:='Температура воды в обратной магистрали';
      Width:=300;
      AutoSize:=True;
    end;
    k:=1853; j:=8;
    for i:=1 to 36 do with LV.Items.Add do begin
      S:=IntToStr(j);
      A[0]:=0;
      A[1]:=0;
      A[2]:=E.Comm66[k];
      A[3]:=E.Comm66[k+1];
      MoveMemory(@R,@A[0],4);
      if Copy(S,1,1) <> '-' then S:='+'+S;
      Caption:=S;
      SubItems.Add(Format('%.6g °C',[R]));
      Inc(k,2);
      Dec(j);
    end;
  end;
//=================================================
  if (Node.Parent <> nil) and
     (Node.Parent.Text = 'Параметры каналов') and
     (Pos('Канал',Node.Text) = 1) then
  begin
    with LV.Columns.Add do begin
      Caption:='Наименование параметра';
      Width:=330;
    end;
    with LV.Columns.Add do begin
      Caption:='Значение';
      Width:=170;
      AutoSize:=True;
    end;
    k:=StrToInt(Copy(Node.Text,Pos(' ',Node.Text)+1,Length(Node.Text)));
    n:=(k-1)*60;
    with LV.Items.Add do begin
      Caption:='Тип подключенного датчика';
      if E.Comm66[n] in [0..10] then
        SubItems.Add(ASensorType[E.Comm66[n]])
      else
        SubItems.Add('???');
    end;
    with LV.Items.Add do begin
      Caption:='Диапазон входного токового сигнала';
      if E.Comm66[n+1] in [0..3] then
        SubItems.Add(AInputRange[E.Comm66[n+1]])
      else
        SubItems.Add('???');
    end;
    with LV.Items.Add do begin
      Caption:='Единицы измерения физической величины';
      if E.Comm66[n] = 10 then
      begin
        if E.Comm66[n+2] in [0..3] then
          SubItems.Add(AEUDesc66_1[E.Comm66[n+2]])
        else
          SubItems.Add('???');
      end
      else
      begin
        if E.Comm66[n+2] in [0..4] then
          SubItems.Add(AEUDesc66_2[E.Comm66[n+2]])
        else
          SubItems.Add('???');
      end;
    end;
    with LV.Items.Add do begin
      Caption:='Нижняя контролируемая граница (X.MIN)';
      MoveMemory(@R,@E.Comm66[n+4],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Верхняя контролируемая граница (X.MAX)';
      MoveMemory(@R,@E.Comm66[n+8],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Смещение нуля (X0)';
      MoveMemory(@R,@E.Comm66[n+12],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Нижнее значение измеряемого параметра (X.L.)';
      MoveMemory(@R,@E.Comm66[n+16],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Верхнее значение измеряемого параметра (X.H.)';
      MoveMemory(@R,@E.Comm66[n+20],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Договорное значение на время отказа датчика (X.Д.)';
      MoveMemory(@R,@E.Comm66[n+24],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Восстанавливающий коэффициент A0';
      MoveMemory(@R,@E.Comm66[n+28],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Восстанавливающий коэффициент B0';
      MoveMemory(@R,@E.Comm66[n+32],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Самоход, в % от диапазона измерения';
      MoveMemory(@R,@E.Comm66[n+36],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
  end;
//=================================================
  if Node.Text = 'Протокол работы датчиков' then
  begin
    with LV.Columns.Add do begin
      Caption:='№ п/п';
      Width:=60;
    end;
    with LV.Columns.Add do begin
      Caption:='Канал';
      Width:=60;
    end;
    with LV.Columns.Add do begin
      Caption:='Событие';
      Width:=100;
      AutoSize:=True;
    end;
    with LV.Columns.Add do begin
      Caption:='Время';
      Width:=80;
    end;
    with LV.Columns.Add do begin
      Caption:='Дата';
      Width:=100;
    end;
    n:=1947;
    for i:=1 to 20 do
    if E.Comm66[n] > 0 then
    begin
      with LV.Items.Insert(0) do begin
        Caption:=Format('%d.',[E.B2D(E.Comm66[n])]);
        SubItems.Add(Format('%2.2d',[E.Comm66[n+1] shr 4]));
        if E.Comm66[n+1] and $0f in [0..6] then
          SubItems.Add(AChanLog[(E.Comm66[n+1] and $0f)])
        else
          SubItems.Add('???');
        SubItems.Add(Format('%2.2d:%2.2d:%2.2d',
          [E.B2D(E.Comm66[n+2]),E.B2D(E.Comm66[n+3]),E.B2D(E.Comm66[n+4])]));
        SubItems.Add(Format('%2.2d.%2.2d.%2.2d г.',
          [E.B2D(E.Comm66[n+5]),E.B2D(E.Comm66[n+6]),E.B2D(E.Comm66[n+7])]));
      end;
      Inc(n,8);
    end;
  end;
//=================================================
  if Node.Text = 'Протокол работы точек учета' then
  begin
    with LV.Columns.Add do begin
      Caption:='№ п/п';
      Width:=60;
    end;
    with LV.Columns.Add do begin
      Caption:='Точка учета';
      Width:=100;
    end;
    with LV.Columns.Add do begin
      Caption:='Событие';
      Width:=100;
      AutoSize:=True;
    end;
    with LV.Columns.Add do begin
      Caption:='Время';
      Width:=80;
    end;
    with LV.Columns.Add do begin
      Caption:='Дата';
      Width:=100;
    end;
    n:=2107;
    for i:=1 to 20 do
    if E.Comm66[n] > 0 then
    begin
      with LV.Items.Insert(0) do begin
        Caption:=Format('%d.',[E.B2D(E.Comm66[n])]);
        SubItems.Add(Format('%2.2d',[E.Comm66[n+1] shr 4]));
        if E.Comm66[n+1] and $0f in [0..14] then
          SubItems.Add(APointLog[(E.Comm66[n+1] and $0f)])
        else
          SubItems.Add('???');
        SubItems.Add(Format('%2.2d:%2.2d:%2.2d',
          [E.B2D(E.Comm66[n+2]),E.B2D(E.Comm66[n+3]),E.B2D(E.Comm66[n+4])]));
        SubItems.Add(Format('%2.2d.%2.2d.%2.2d г.',
          [E.B2D(E.Comm66[n+5]),E.B2D(E.Comm66[n+6]),E.B2D(E.Comm66[n+7])]));
      end;
      Inc(n,8);
    end;
  end;
//=================================================
  if Node.Text = 'Протокол работы групп' then
  begin
    with LV.Columns.Add do begin
      Caption:='№ п/п';
      Width:=60;
    end;
    with LV.Columns.Add do begin
      Caption:='Группа';
      Width:=60;
    end;
    with LV.Columns.Add do begin
      Caption:='Событие';
      Width:=100;
      AutoSize:=True;
    end;
    with LV.Columns.Add do begin
      Caption:='Время';
      Width:=80;
    end;
    with LV.Columns.Add do begin
      Caption:='Дата';
      Width:=100;
    end;
    n:=2267;
    for i:=1 to 20 do
    if E.Comm66[n] > 0 then
    begin
      with LV.Items.Insert(0) do begin
        Caption:=Format('%d.',[E.B2D(E.Comm66[n])]);
        SubItems.Add(Format('%2.2d',[E.Comm66[n+1] shr 4]));
        if E.Comm66[n+1] and $0f in [0..2] then
          SubItems.Add(AGroupLog[(E.Comm66[n+1] and $0f)])
        else
          SubItems.Add('???');
        SubItems.Add(Format('%2.2d:%2.2d:%2.2d',
          [E.B2D(E.Comm66[n+2]),E.B2D(E.Comm66[n+3]),E.B2D(E.Comm66[n+4])]));
        SubItems.Add(Format('%2.2d.%2.2d.%2.2d г.',
          [E.B2D(E.Comm66[n+5]),E.B2D(E.Comm66[n+6]),E.B2D(E.Comm66[n+7])]));
      end;
      Inc(n,8);
    end;
  end;
//=================================================
  if Node.Text = 'Протокол работы преобразователя' then
  begin
    with LV.Columns.Add do begin
      Caption:='№ п/п';
      Width:=60;
    end;
    with LV.Columns.Add do begin
      Caption:='Событие';
      Width:=100;
      AutoSize:=True;
    end;
    with LV.Columns.Add do begin
      Caption:='Время';
      Width:=80;
    end;
    with LV.Columns.Add do begin
      Caption:='Дата';
      Width:=100;
    end;
    n:=2427;
    for i:=1 to 20 do
    if E.Comm66[n] > 0 then
    begin
      with LV.Items.Insert(0) do begin
        Caption:=Format('%d.',[E.B2D(E.Comm66[n])]);
        SubItems.Add(ANodeLog[(E.Comm66[n+1] and $0f)]);
        SubItems.Add(Format('%2.2d:%2.2d:%2.2d',
          [E.B2D(E.Comm66[n+2]),E.B2D(E.Comm66[n+3]),E.B2D(E.Comm66[n+4])]));
        SubItems.Add(Format('%2.2d.%2.2d.%2.2d г.',
          [E.B2D(E.Comm66[n+5]),E.B2D(E.Comm66[n+6]),E.B2D(E.Comm66[n+7])]));
      end;
      Inc(n,8);
    end;
  end;
//=================================================
  if Node.Text = 'Датчики' then
  begin
    with LV.Columns.Add do begin
      Caption:='Тип датчика';
      Width:=330;
    end;
    with LV.Columns.Add do begin
      Caption:='Номер канала';
      Width:=170;
      AutoSize:=True;
    end;
    k:=StrToInt(Copy(Node.Parent.Text,Pos('учета ',Node.Parent.Text)+6,
                     Length(Node.Parent.Text)));
    n:=(k-1)*176+900;
    with LV.Items.Add do begin
      Caption:='Датчик давления (P)';
      SubItems.Add(Format('%s',
           [IfThen(E.Comm66[n] > 0,IntToStr(E.Comm66[n]),'---')]));
    end;
    with LV.Items.Add do begin
      Caption:='Датчик перепада давления (DP 100)';
      SubItems.Add(Format('%s',
           [IfThen(E.Comm66[n+1] > 0,IntToStr(E.Comm66[n+1]),'---')]));
    end;
    with LV.Items.Add do begin
      Caption:='Датчик перепада давления (DP 30)';
      SubItems.Add(Format('%s',
    [IfThen(E.Comm66[n+2] and $0f > 0,IntToStr(E.Comm66[n+2] and $0f),'---')]));
    end;
    with LV.Items.Add do begin
      Caption:='Датчик перепада давления (DP 10)';
      SubItems.Add(Format('%s',
        [IfThen(E.Comm66[n+2] shr 4 > 0,IntToStr(E.Comm66[n+2] shr 4),'---')]));
    end;
    with LV.Items.Add do begin
      Caption:='Датчик температуры (T)';
      SubItems.Add(Format('%s',
           [IfThen(E.Comm66[n+3] > 0,IntToStr(E.Comm66[n+3]),'---')]));
    end;
    with LV.Items.Add do begin
      Caption:='';
    end;
    with LV.Items.Add do begin
      Caption:='Пуск измерений по точке учета';
      SubItems.Add(IfThen(E.Comm66[n+70]>0,'Да','Нет'));
    end;
  end;
//=================================================
  if Node.Text = 'Параметры и вид СУ' then
  begin
    with LV.Columns.Add do begin
      Caption:='Наименование параметра';
      Width:=310;
    end;
    with LV.Columns.Add do begin
      Caption:='Значение';
      Width:=190;
      AutoSize:=True;
    end;
    k:=StrToInt(Copy(Node.Parent.Text,Pos('учета ',Node.Parent.Text)+6,
                     Length(Node.Parent.Text)));
    n:=(k-1)*176+900;
    with LV.Items.Add do begin
      Caption:='Вид сужающего устройства';
      case E.Comm66[n+17] of
       0: SubItems.Add('Диафр. с фланцевым отбором');
       1: SubItems.Add('Диафр. с угловым отбором');
       2: SubItems.Add('Сопло');
       3: SubItems.Add('Сопло Вентури');
      end;
    end;
    with LV.Items.Add do begin
      Caption:='Диаметр отверстия диафрагмы при 20°C D(СУ)';
      MoveMemory(@R,@E.Comm66[n+18],4);
      SubItems.Add(Format('%.6g мм',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Коэффициент t° расширения диафрагмы B(СУ)';
      MoveMemory(@R,@E.Comm66[n+22],4);
      SubItems.Add(Format('%.6g 1/°C',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Диаметр отверстия трубопровода при 20°C D(ТР)';
      MoveMemory(@R,@E.Comm66[n+26],4);
      SubItems.Add(Format('%.6g мм',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Коэффициент t° расширения трубопровода B(ТР)';
      MoveMemory(@R,@E.Comm66[n+30],4);
      SubItems.Add(Format('%.6g 1/°C',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Коэффициент шероховатости (КШ)';
      MoveMemory(@R,@E.Comm66[n+34],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Коэффициент притупления входной кромки (КП)';
      MoveMemory(@R,@E.Comm66[n+38],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
  end;
//=================================================
  if Node.Text = 'Рабочая среда' then
  begin
    with LV.Columns.Add do begin
      Caption:='Наименование параметра';
      Width:=310;
    end;
    with LV.Columns.Add do begin
      Caption:='Значение';
      Width:=190;
      AutoSize:=True;
    end;
    k:=StrToInt(Copy(Node.Parent.Text,Pos('учета ',Node.Parent.Text)+6,
                     Length(Node.Parent.Text)));
    n:=(k-1)*176+900;
    with LV.Items.Add do begin
      Caption:='Тип рабочей среды';
      case E.Comm66[n+16] of
       0: SubItems.Add('Вода');
       1: SubItems.Add('Пар насыщенный');
       2: SubItems.Add('Пар перегретый');
       3: SubItems.Add('Природный газ');
       4: SubItems.Add('Прочие газы');
      end;
    end;
    with LV.Items.Add do begin
      Caption:='Относительная концентрация CO2';
      MoveMemory(@R,@E.Comm66[n+42],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Относительная концентрация N2';
      MoveMemory(@R,@E.Comm66[n+46],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Плотность';
      MoveMemory(@R,@E.Comm66[n+50],4);
      SubItems.Add(Format('%.6g кг/м3',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Коэффициент динамической вязкости';
      MoveMemory(@R,@E.Comm66[n+54],4);
      SubItems.Add(Format('%.6g кг*с/м2',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Коэффициент сжимаемости';
      MoveMemory(@R,@E.Comm66[n+58],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Показатель адиабаты';
      MoveMemory(@R,@E.Comm66[n+62],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Удельная энтальпия';
      MoveMemory(@R,@E.Comm66[n+66],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
  end;
//=================================================
  if Node.Text = 'Расход' then
  begin
    with LV.Columns.Add do begin
      Caption:='Наименование параметра';
      Width:=320;
    end;
    with LV.Columns.Add do begin
      Caption:='Значение';
      Width:=180;
      AutoSize:=True;
    end;
    k:=StrToInt(Copy(Node.Parent.Text,Pos('учета ',Node.Parent.Text)+6,
                     Length(Node.Parent.Text)));
    n:=(k-1)*176+900;
    with LV.Items.Add do begin
      Caption:='Максимальный расход энергоносителя (M.H.)';
      MoveMemory(@R,@E.Comm66[n+123],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Минимальный расход энергоносителя (M.L.)';
      MoveMemory(@R,@E.Comm66[n+127],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Максимальный расход энергии (Q.H.)';
      MoveMemory(@R,@E.Comm66[n+131],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Минимальный расход энергии (Q.L.)';
      MoveMemory(@R,@E.Comm66[n+135],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Договорное значение расхода энергоносителя (M[Д])';
      MoveMemory(@R,@E.Comm66[n+139],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Договорное значение расхода энергии (Q[Д])';
      MoveMemory(@R,@E.Comm66[n+143],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
  end;
//=================================================
  if Node.Text = 'Общие' then
  begin
    with LV.Columns.Add do begin
      Caption:='Наименование параметра';
      Width:=310;
    end;
    with LV.Columns.Add do begin
      Caption:='Значение';
      Width:=190;
      AutoSize:=True;
    end;
    with LV.Items.Add do begin
      Caption:='Атмосферное давление';
      MoveMemory(@R,@E.Comm66[1943],4);
      SubItems.Add(Format('%.6g кгс/см2',[R]));
    end;
  end;
//===========================================================
  if (Node.Parent <> nil) and
     (Node.Parent.Text = 'Каналы') and
     (Pos('Канал',Node.Text) = 1) then
  begin
    with LV.Columns.Add do begin
      Caption:='Наименование параметра';
      Width:=340;
    end;
    with LV.Columns.Add do begin
      Caption:='Значение';
      Width:=160;
      AutoSize:=True;
    end;
    k:=StrToInt(Copy(Node.Text,Pos(' ',Node.Text)+1,Length(Node.Text)));
    n:=(k-1)*60;
    with LV.Items.Add do begin
      Caption:='Тип подключенного датчика';
      if E.Comm66[n] in [0..10] then
        SubItems.Add(ASensorType[E.Comm66[n]])
      else
        SubItems.Add('???');
    end;
    with LV.Items.Add do begin
      Caption:='Единицы измерения физической величины';
      if E.Comm66[n] = 10 then
      begin
        if E.Comm66[n+2] in [0..3] then
          SubItems.Add(AEUDesc66_1[E.Comm66[n+2]])
        else
          SubItems.Add('???');
      end
      else
      begin
        if E.Comm66[n+2] in [0..4] then
          SubItems.Add(AEUDesc66_2[E.Comm66[n+2]])
        else
          SubItems.Add('???');
      end;
    end;
    with LV.Items.Add do begin
      Caption:='Измеренный ток датчика (I.вх)';
      MoveMemory(@R,@E.Comm66[n+40],4);
      SubItems.Add(Format('%.6g мА',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Измеренное значение параметра (X.изм)';
      MoveMemory(@R,@E.Comm66[n+44],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Среднее значение по каналу в текущем часе (Т.час)';
      MoveMemory(@R,@E.Comm66[n+52],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Среднее значение по каналу в предыдущем часе (П.час)';
      MoveMemory(@R,@E.Comm66[n+56],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Режим состояния датчика';
      SubItems.Add(SensStatus(E.Comm66[n+3]));
    end;
  end;
//=================================================
  if Node.Text = 'Энергия' then
  begin
    with LV.Columns.Add do begin
      Caption:='Наименование параметра';
      Width:=310;
    end;
    with LV.Columns.Add do begin
      Caption:='Значение';
      Width:=190;
      AutoSize:=True;
    end;
    k:=StrToInt(Copy(Node.Parent.Text,Pos('учета ',Node.Parent.Text)+6,
                     Length(Node.Parent.Text)));
    n:=(k-1)*176+900;
    with LV.Items.Add do begin
      Caption:='Количество энергии за текущий час';
      MoveMemory(@R,@E.Comm66[n+111],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Количество энергии за текущие сутки';
      MoveMemory(@R,@E.Comm66[n+115],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Количество энергии за текущий месяц';
      MoveMemory(@R,@E.Comm66[n+119],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='';
    end;
    with LV.Items.Add do begin
      Caption:='Количество энергии за предыдущий час';
      MoveMemory(@R,@E.Comm66[n+159],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Количество энергии за предыдущие сутки';
      MoveMemory(@R,@E.Comm66[n+163],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Количество энергии за предыдущий месяц';
      MoveMemory(@R,@E.Comm66[n+167],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
  end;
//=================================================
  if Node.Text = 'Энергоноситель' then
  begin
    with LV.Columns.Add do begin
      Caption:='Наименование параметра';
      Width:=310;
    end;
    with LV.Columns.Add do begin
      Caption:='Значение';
      Width:=190;
      AutoSize:=True;
    end;
    k:=StrToInt(Copy(Node.Parent.Text,Pos('учета ',Node.Parent.Text)+6,
                     Length(Node.Parent.Text)));
    n:=(k-1)*176+900;
    with LV.Items.Add do begin
      Caption:='Количество энергоносителя за текущий час';
      MoveMemory(@R,@E.Comm66[n+99],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Количество энергоносителя за текущие сутки';
      MoveMemory(@R,@E.Comm66[n+103],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Количество энергоносителя за текущий месяц';
      MoveMemory(@R,@E.Comm66[n+107],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='';
    end;
    with LV.Items.Add do begin
      Caption:='Количество энергоносителя за предыдущий час';
      MoveMemory(@R,@E.Comm66[n+147],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Количество энергоносителя за предыдущие сутки';
      MoveMemory(@R,@E.Comm66[n+151],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Количество энергоносителя за предыдущий месяц';
      MoveMemory(@R,@E.Comm66[n+155],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
  end;
//=================================================
  if (Node.Text = 'Текущие параметры') and
     (Pos('Точка учета',Node.Parent.Text)=1) then
  begin
    with LV.Columns.Add do begin
      Caption:='Наименование параметра';
      Width:=310;
    end;
    with LV.Columns.Add do begin
      Caption:='Значение';
      Width:=190;
      AutoSize:=True;
    end;
    k:=StrToInt(Copy(Node.Parent.Text,Pos('учета ',Node.Parent.Text)+6,
                     Length(Node.Parent.Text)));
    n:=(k-1)*176+900;
    with LV.Items.Add do begin
      Caption:='Давление избыточное (P)';
      MoveMemory(@R,@E.Comm66[n+4],4);
      SubItems.Add(Format('%.6g кгс/см2',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Перепад давления на сужающем устройстве (DP)';
      MoveMemory(@R,@E.Comm66[n+8],4);
      SubItems.Add(Format('%.6g кгс/м2',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Температура в трубопроводе (T)';
      MoveMemory(@R,@E.Comm66[n+12],4);
      SubItems.Add(Format('%.6g °C',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Плотность средняя за текущий час';
      MoveMemory(@R,@E.Comm66[n+79],4);
      SubItems.Add(Format('%.6g кг/м3',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Энтальпия средняя за текущий час (Н)';
      MoveMemory(@R,@E.Comm66[n+83],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='';
    end;
    with LV.Items.Add do begin
      Caption:='Мгновенный расход энергоносителя (G.изм)';
      MoveMemory(@R,@E.Comm66[n+83],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Мгновенный расход энергии (Q.изм)';
      MoveMemory(@R,@E.Comm66[n+87],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Среднечасовой расход энергоносителя (G.час)';
      MoveMemory(@R,@E.Comm66[n+91],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Среднечасовой расход энергии (Q.час)';
      MoveMemory(@R,@E.Comm66[n+95],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Значение числа Рейнольдса (Re)';
      MoveMemory(@R,@E.Comm66[n+71],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='';
    end;
    with LV.Items.Add do begin
      Caption:='Состояние датчика давления (P)';
      SubItems.Add(SensStatus(E.Comm66[n+171]));
    end;
    with LV.Items.Add do begin
      Caption:='Состояние датчика перепада давления (DP 100)';
      SubItems.Add(SensStatus(E.Comm66[n+172]));
    end;
    with LV.Items.Add do begin
      Caption:='Состояние датчика перепада давления (DP 30)';
      SubItems.Add(SensStatus(E.Comm66[n+173]));
    end;
    with LV.Items.Add do begin
      Caption:='Состояние датчика перепада давления (DP 10)';
      SubItems.Add(SensStatus(E.Comm66[n+173]));
    end;
    with LV.Items.Add do begin
      Caption:='Состояние датчика температуры (T)';
      SubItems.Add(SensStatus(E.Comm66[n+174]));
    end;
    with LV.Items.Add do begin
      Caption:='';
    end;
    with LV.Items.Add do begin
      Caption:='Учет';
      SubItems.Add(IfThen(E.Comm66[n+70]>0,'Да','Нет'));
    end;
    with LV.Items.Add do begin
      Caption:='Состояние расхода энергии (Q)';
      case E.Comm66[n+175] of
        1: SubItems.Add('Меньше нормы');
        2: SubItems.Add('Больше нормы');
      else
        SubItems.Add('Норма');
      end;
    end;
    with LV.Items.Add do begin
      Caption:='Состояние расхода энергоносителя (G)';
      case E.Comm66[n+175] of
        4: SubItems.Add('Меньше нормы');
        8: SubItems.Add('Больше нормы');
      else
        SubItems.Add('Норма');
      end;
    end;
  end;
//=================================================
  if (Node.Parent <> nil) and
     (Node.Parent.Text = 'Параметры групп учета') and
     (Pos('Группа учета',Node.Text) = 1) then
  begin
    with LV.Columns.Add do begin
      Caption:='Наименование параметра';
      Width:=330;
    end;
    with LV.Columns.Add do begin
      Caption:='Значение';
      Width:=170;
      AutoSize:=True;
    end;
    k:=StrToInt(Copy(Node.Text,Pos('учета ',Node.Text)+6,Length(Node.Text)));
    n:=(k-1)*336;
    with LV.Items.Add do begin
      Caption:='Единица измерения группы';
      SubItems.Add(AEUDesc[E.Comm22[n]]);
    end;
    with LV.Items.Add do begin
      Caption:='Верхнее контролируемое значение (X.H)';
      MoveMemory(@R,@E.Comm22[n+21],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Нижнее контролируемое значение (X.L)';
      MoveMemory(@R,@E.Comm22[n+25],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Восстанавливающий коэффициент A0';
      MoveMemory(@R,@E.Comm22[n+29],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Восстанавливающий коэффициент B0';
      MoveMemory(@R,@E.Comm22[n+33],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Состав:';
    end;
    SetLength(S,50);
    FillChar(S[1],50,' ');
    for i:=0 to 49 do S[i+1]:=Char(E.Comm22[n+286+i]);
    with LV.Items.Add do begin
      Caption:=' '+Copy(S,1,25);
    end;
    with LV.Items.Add do begin
      Caption:=' '+Copy(S,25,25);
    end;
  end;
//=================================================
  if (Node.Text = 'Текущие параметры') and
     (Pos('Группа учета',Node.Parent.Text)=1) then
  begin
    with LV.Columns.Add do begin
      Caption:='Наименование параметра';
      Width:=310;
    end;
    with LV.Columns.Add do begin
      Caption:='Значение';
      Width:=190;
      AutoSize:=True;
    end;
    k:=StrToInt(Copy(Node.Parent.Text,Pos('учета ',Node.Parent.Text)+6,
                     Length(Node.Parent.Text)));
    n:=(k-1)*336;
    with LV.Items.Add do begin
      Caption:='Мгновенное значение (X.изм)';
      MoveMemory(@R,@E.Comm22[n+1],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Среднее значение за текущий час (X.час)';
      MoveMemory(@R,@E.Comm22[n+5],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Количество энергии(носителя) за текущий месяц (Т.РП)';
      MoveMemory(@R,@E.Comm22[n+9],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Количество энергии(носителя) за предыдущий месяц (ПР.РП)';
      MoveMemory(@R,@E.Comm22[n+17],4);
      SubItems.Add(Format('%.6g',[R]));
    end;
    with LV.Items.Add do begin
      Caption:='Состояние';
      SubItems.Add(AGroupLog[E.Comm22[n+285]]);
    end;
  end;
//=================================================
  if Node.Text = 'Текущий расчетный период' then
  begin
    with LV.Columns.Add do begin
      Caption:='День месяца';
      Width:=200;
    end;
    with LV.Columns.Add do begin
      Caption:='Значение';
      Width:=300;
      AutoSize:=True;
    end;
    k:=StrToInt(Copy(Node.Parent.Text,Pos('учета ',Node.Parent.Text)+6,
                     Length(Node.Parent.Text)));
    n:=(k-1)*336+37;
    for i:=1 to 31 do
    if i <= E.Day then with LV.Items.Insert(0) do begin
      Caption:=Format('%2.2d.%2.2d.%2.2d',[i,E.Month,E.Year]);
      MoveMemory(@R,@E.Comm22[n],4);
      SubItems.Add(Format('%.6g',[R]));
      Inc(n,4);
    end;
  end;
//=================================================
  if Node.Text = 'Предыдущий расчетный период' then
  begin
    with LV.Columns.Add do begin
      Caption:='День месяца';
      Width:=200;
    end;
    with LV.Columns.Add do begin
      Caption:='Значение';
      Width:=300;
      AutoSize:=True;
    end;
    k:=StrToInt(Copy(Node.Parent.Text,Pos('учета ',Node.Parent.Text)+6,
                     Length(Node.Parent.Text)));
    n:=(k-1)*336+161;
    for i:=1 to 31 do
    if i <= E.LastDay then with LV.Items.Insert(0) do begin
      Caption:=Format('%2.2d.%2.2d.%2.2d',[i,E.LastMonth,E.LastYear]);
      MoveMemory(@R,@E.Comm22[n],4);
      SubItems.Add(Format('%.6g',[R]));
      Inc(n,4);
    end;
  end;
  LV.Width:=LV.Width+1;
end;

function TResursTreeForm.SensStatus(Value: Byte): string;
var i: integer;
begin
  Result:='Норма';
  for i:=0 to 7 do
  if Value and (1 shl i) > 0 then
  begin
    Result:=AStatus66[i+1];
    Break;
  end;
end;

procedure TResursTreeForm.tbFreshClick(Sender: TObject);
begin
  TVChange(TV,TV.Selected);
end;

procedure TResursTreeForm.tbCloseClick(Sender: TObject);
begin
  Close;
end;

end.
