unit EliteNDPaspUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, Buttons, EntityUnit,
  EliteRFTUnit;

type
  TEliteNDPaspForm = class(TForm,IEntity)
    Panel1: TPanel;
    PTNameDesc: TLabel;
    PTDesc: TLabel;
    ButtonToDataBase: TButton;
    ButtonToMainScreen: TButton;
    ConfigPanel: TPanel;
    Label55: TLabel;
    Label56: TLabel;
    PTActive: TLabel;
    Label63: TLabel;
    LinkSpeed: TLabel;
    Label9: TLabel;
    LastTime: TLabel;
    Panel6: TPanel;
    Panel3: TPanel;
    StatusPanel: TPanel;
    Label11: TLabel;
    StatusListBox: TLabel;
    Entity: TLabel;
    Label61: TLabel;
    Label1: TLabel;
    LabelParameter: TLabel;
    Label4: TLabel;
    Channel: TLabel;
    Label6: TLabel;
    Node: TLabel;
    Memo: TMemo;
    Label3: TLabel;
    Label5: TLabel;
    Label2: TLabel;
    RFTHeader: TLabel;
    Label12: TLabel;
    RFTSensor: TLabel;
    Label14: TLabel;
    RFTTag: TLabel;
    Label15: TLabel;
    RFTDescriptor: TLabel;
    Label16: TLabel;
    RFTMessage: TLabel;
    procedure ButtonToDataBaseClick(Sender: TObject);
    procedure OPSourceDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonToMainScreenClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    E: TEliteNode;
    procedure ConnectEntity(Entity: TEntity); stdcall;
    procedure ConnectImageList(ImageList: TImageList); stdcall;
    procedure UpdateRealTime; stdcall;
  public
  end;

var
  EliteNDPaspForm: TEliteNDPaspForm;

implementation

uses StrUtils, Math;

{$R *.dfm}

{ TEliteNDPaspForm }

procedure TEliteNDPaspForm.ConnectEntity(Entity: TEntity);
begin
  E:=Entity as TEliteNode;
  PTNameDesc.Caption:=E.PtName;
  Self.Entity.Caption:=E.PtName;
  LabelParameter.Caption:=E.EntityType;
  PTDesc.Caption:=E.PtDesc;
  PTActive.Caption:=IfThen(E.Actived,'Да','Нет');
  LinkSpeed.Caption:=Format('%d сек',[E.FetchTime]);
  if E.RealTime > 0 then
    LastTime.Caption:=Format('%.3f',[E.RealTime/1000])+' сек'
  else
    LastTime.Caption:='Нет опроса';
//-------------------------------------
  Channel.Caption:=Format('%d',[E.Channel]);
  Node.Caption:=Format('%d',[E.Node]);
  UpdateRealTime;
end;

procedure TEliteNDPaspForm.ConnectImageList(ImageList: TImageList);
begin
// Stub
end;

procedure TEliteNDPaspForm.UpdateRealTime;
var SL: TStringList;
begin
  ButtonToDataBase.Visible:=Caddy.UserLevel > 4;
  if E.RealTime > 0 then
    LastTime.Caption:=Format('%.3f',[E.RealTime/1000])+' сек'
  else
    LastTime.Caption:='Нет опроса';
  StatusListBox.Caption:=E.ErrorMess;
  RFTHeader.Caption:=Format('%d',[E.SerialNodeNumber]);
  RFTSensor.Caption:=Format('%d',[E.SerialSensorNumber]);
  RFTTag.Caption:=E.Tag;
  RFTDescriptor.Caption:=E.Desc;
  RFTMessage.Caption:=E.Mess;
//-------------------------------------------
  Memo.Lines.BeginUpdate;
  SL:=TStringList.Create;
  try
    if E.Err1 > 0 then SL.Append('Блок сообщений 1:');
    if (E.Err1 and $0001) > 0 then
      SL.Append('  Ошибка контрольной суммы ЭС(П)ПЗУ');
    if (E.Err1 and $0002) > 0 then
      SL.Append('  Конфигурация датчика изменена');
    if (E.Err1 and $0004) > 0 then
      SL.Append('  Неисправность сенсора');
    if (E.Err1 and $0008) > 0 then
      SL.Append('  Повреждение температурного сенсора');
    if (E.Err1 and $0010) > 0 then
      SL.Append('  Выход за диапазон входного сигнала');
    if (E.Err1 and $0020) > 0 then
      SL.Append('  Выход за диапазон частоты');
    if (E.Err1 and $0040) > 0 then
      SL.Append('  Датчик не сконфигурирован');
    if (E.Err1 and $0080) > 0 then
      SL.Append('  Ошибка прерывания в реальном масштабе времени');
    if (E.Err1 and $0100) > 0 then
      SL.Append('  Насыщение токового выхода(ов)');
    if (E.Err1 and $0200) > 0 then
      SL.Append('  Токовый выход(ы) зафиксирован');
    if (E.Err1 and $0400) > 0 then
      SL.Append('  Выход значения плотности за допустимые пределы');
    if (E.Err1 and $0800) > 0 then
      SL.Append('  Нарушение операции установки нуля');
    if (E.Err1 and $1000) > 0 then
      SL.Append('  Неисправность электронной части датчика');
    if (E.Err1 and $2000) > 0 then
      SL.Append('  Снарядный режим потока');
    if (E.Err1 and $4000) > 0 then
      SL.Append('  Идет процесс самокалибровки');
    if (E.Err1 and $8000) > 0 then
      SL.Append('  Произошел сброс питания');
//-----------------------------------
    if E.Err125  > 0 then
      SL.Append('Блок сообщений 2:');
    if (E.Err125 and $0001) > 0 then
      SL.Append('  Насыщение первичного токового выхода');
    if (E.Err125 and $0002) > 0 then
      SL.Append('  Насыщение вторичного токового выхода');
    if (E.Err125 and $0004) > 0 then
      SL.Append('  Первичный токовый выход зафиксирован');
    if (E.Err125 and $0008) > 0 then
      SL.Append('  Вторичный токовый выход зафиксирован');
    if (E.Err125 and $0010) > 0 then
      SL.Append('  Выход значения плотности за допустимые пределы');
    if (E.Err125 and $0020) > 0 then
      SL.Append('  Выход за диапазон усиления привода');
    if (E.Err125 and $0040) > 0 then
      SL.Append('  Произошла ошибка');
    if (E.Err125 and $0080) > 0 then
      SL.Append('  Ошибка токового входа');
    if (E.Err125 and $0100) > 0 then
      SL.Append('  Ошибка контрольной суммы ЭС(П)ПЗУ');
    if (E.Err125 and $0200) > 0 then
      SL.Append('  Ошибка диагностики ОЗУ');
    if (E.Err125 and $0400) > 0 then
      SL.Append('  Неисправность сенсора');
    if (E.Err125 and $0800) > 0 then
      SL.Append('  Неисправность температурного сенсора');
    if (E.Err125 and $1000) > 0 then
      SL.Append('  Выход за диапазон входного сигнала');
    if (E.Err125 and $2000) > 0 then
      SL.Append('  Выход за диапазон частоты');
    if (E.Err125 and $4000) > 0 then
      SL.Append('  Датчик не сконфигурирован');
    if (E.Err125 and $8000) > 0 then
      SL.Append('  Ошибка прерывания в реальном масштабе времени');
//-----------------------------------
    if E.Err126  > 0 then
      SL.Append('Блок сообщений 3:');
    if (E.Err126 and $0001) > 0 then
      SL.Append('  Разрешен монопольный режим');
    if (E.Err126 and $0002) > 0 then
      SL.Append('  Произошел сброс питания');
    if (E.Err126 and $0004) > 0 then
      SL.Append('  Идет процесс самокалибровки');
    if (E.Err126 and $0008) > 0 then
      SL.Append('  Не определен');
    if (E.Err126 and $0010) > 0 then
      SL.Append('  Не определен');
    if (E.Err126 and $0020) > 0 then
      SL.Append('  Событие 1 включено');
    if (E.Err126 and $0040) > 0 then
      SL.Append('  Событие 2 включено');
    if (E.Err126 and $0080) > 0 then
      SL.Append('  Не определен');
    if (E.Err126 and $0100) > 0 then
      SL.Append('  Ошибка операции установки нуля');
    if (E.Err126 and $0200) > 0 then
      SL.Append('  Значение нуля слишком мало');
    if (E.Err126 and $0400) > 0 then
      SL.Append('  Значение нуля слишком велико');
    if (E.Err126 and $0800) > 0 then
      SL.Append('  Слишком высокий уровень шума на значении нуля');
    if (E.Err126 and $1000) > 0 then
      SL.Append('  Неисправность электронной части датчика');
    if (E.Err126 and $2000) > 0 then
      SL.Append('  Не определен');
    if (E.Err126 and $4000) > 0 then
      SL.Append('  Идет процесс установки нуля');
    if (E.Err126 and $8000) > 0 then
      SL.Append('  Снарядный режим потока');
    if Memo.Lines.Text <> SL.Text then Memo.Lines.Assign(SL);
  finally
    SL.Free;
    Memo.Lines.EndUpdate;
  end;
end;

procedure TEliteNDPaspForm.ButtonToDataBaseClick(Sender: TObject);
begin
  E.ShowEditor(Monitor.MonitorNum);
end;

procedure TEliteNDPaspForm.OPSourceDblClick(Sender: TObject);
begin
  E.ShowParentPassport(Monitor.MonitorNum);
end;

procedure TEliteNDPaspForm.FormCreate(Sender: TObject);
var ScreenSizeIndex,i: integer; L: TLabel; P: TPanel; S: TShape; B: TButton;
begin
  Memo.DoubleBuffered:=True;
//-------------------------------------------
  if PanelWidth = 800 then
    ScreenSizeIndex:=0
  else
  if PanelWidth = 1280 then
    ScreenSizeIndex:=2
  else
  if PanelWidth = 1680 then
    ScreenSizeIndex:=3
  else
    ScreenSizeIndex:=1;
  case ScreenSizeIndex of
    0: for i:=0 to Self.ComponentCount-1 do
       begin
         if Components[i] is TPanel then
         begin
           P:=Components[i] as TPanel;
           if P.Align <> alClient then
           begin
             P.Width:=Round(P.Width/1.28);
             P.Height:=Round(P.Height/1.28);
           end;
         end;
         if Components[i] is TMemo then
         begin
           Memo.Left:=Round(Memo.Left/1.28);
           Memo.Top:=Round(Memo.Top/1.28);
           Memo.Width:=Round(Memo.Width/1.28);
           Memo.Height:=Round(Memo.Height/1.28);
           Memo.Font.Size:=10;
         end;
         if Components[i] is TButton then
         begin
           B:=Components[i] as TButton;
           if B.Parent = Panel6 then
           begin
             B.Left:=Round(B.Left/1.28);
             B.Top:=Round(B.Top/1.28);
             B.Width:=Round(B.Width/1.28);
             B.Height:=Round(B.Height/1.28);
             B.Font.Size:=8;
             B.Font.Name:='Tahoma';
           end;
         end;
         if Components[i] is TLabel then
         begin
           L:=Components[i] as TLabel;
           L.Left:=Round(L.Left/1.28);
           L.Top:=Round(L.Top/1.28);
           L.Width:=Round(L.Width/1.28);
           L.Height:=Round(L.Height/1.28);
           L.Font.Size:=10;
           L.Font.Name:='Tahoma';
         end;
         if Components[i] is TShape then
         begin
           S:=Components[i] as TShape;
           S.Left:=Round(S.Left/1.28);
           S.Top:=Round(S.Top/1.28);
           S.Width:=Round(S.Width/1.28);
           S.Height:=Round(S.Height/1.28);
         end;
       end;
    2,3: for i:=0 to Self.ComponentCount-1 do
       begin
         if Components[i] is TMemo then
         begin
           Memo.Left:=Round(Memo.Left/0.8);
           Memo.Top:=Round(Memo.Top/0.8);
           Memo.Width:=Round(Memo.Width/0.8);
           Memo.Height:=Round(Memo.Height/0.8);
           Memo.Font.Size:=12;
         end;
         if Components[i] is TPanel then
         begin
           P:=Components[i] as TPanel;
           if P.Align <> alClient then
           begin
             P.Width:=Round(P.Width/0.8);
             P.Height:=Round(P.Height/0.8);
           end;
         end;
         if Components[i] is TButton then
         begin
           B:=Components[i] as TButton;
           if B.Parent = Panel6 then
           begin
             B.Left:=Round(B.Left/0.8);
             B.Top:=Round(B.Top/0.8);
             B.Width:=Round(B.Width/0.8);
             B.Height:=Round(B.Height/0.8);
             B.Font.Size:=10;
             B.Font.Name:='Tahoma';
           end;
         end;
         if Components[i] is TLabel then
         begin
           L:=Components[i] as TLabel;
           L.Left:=Round(L.Left/0.8);
           L.Top:=Round(L.Top/0.8);
           L.Width:=Round(L.Width/0.8);
           L.Height:=Round(L.Height/0.8);
           L.Font.Size:=16;
           L.Font.Name:='Tahoma';
           L.Layout:=tlCenter;
         end;
         if Components[i] is TShape then
         begin
           S:=Components[i] as TShape;
           S.Left:=Round(S.Left/0.8);
           S.Top:=Round(S.Top/0.8);
           S.Width:=Round(S.Width/0.8);
           S.Height:=Round(S.Height/0.8);
         end;
       end;
  end;
end;

procedure TEliteNDPaspForm.ButtonToMainScreenClick(Sender: TObject);
begin
  E.ShowScheme(Monitor.MonitorNum);
end;

procedure TEliteNDPaspForm.FormResize(Sender: TObject);
begin
  with ButtonToMainScreen do Left:=Self.Width-Width-5;
  with ButtonToDataBase do Left:=Self.Width-Width-10-ButtonToMainScreen.Width;
end;

end.
