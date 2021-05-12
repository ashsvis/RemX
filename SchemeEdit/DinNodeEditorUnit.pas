unit DinNodeEditorUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Spin, EntityUnit, DinElementsUnit, IniFiles;

type
  TDinNoder = class(TDinControl)
  private
    Body: record
            DinType: byte;
            PtName: string[10];
            Left: Integer;
            Top: Integer;
            Width: Integer;
            Height: Integer;
            Reserved1: boolean;
            Reserved2: boolean;
            Reserved3: boolean;
            Reserved4: Integer;
            Reserved5: Integer;
            Reserved6: Integer;
          end;
    First,Blink: boolean;
    AlarmFound,HasAlarm,HasConfirm,LastHasAlarm,LastHasConfirm: boolean;
    FPtName,LastPtName: string;
    ImageNode, StateName, LastImageNode: string;
    bkColor,frColor: TColor;
    procedure SetPtName(const Value: string);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    function ShowEditor: boolean; override;
    procedure Assign(Source: TPersistent); override;
    procedure SaveToStream(Stream: TStream); override;
    procedure SaveToIniFile(MF: TMemInifile); override;
    function LoadFromStream(Stream: TStream): integer; override;
    procedure UpdateData(GetParamVal: TCallbackFunc); override;
  published
    property PtName: string read FPtName write SetPtName;
  end;

  TDinNodeEditorForm = class(TForm)
    PropertyBox: TGroupBox;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Bevel2: TBevel;
    edPtName: TEdit;
    seLeft: TSpinEdit;
    seTop: TSpinEdit;
    GroupBox: TGroupBox;
    ScrollBox: TScrollBox;
    CloseButton: TButton;
    CancelButton: TButton;
    Fresh: TTimer;
    procedure edPtNameClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FreshTimer(Sender: TObject);
    procedure Shape1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    Source,Example: TDinNoder;
  public
  end;

var
  DinNodeEditorForm: TDinNodeEditorForm;

implementation

uses GetLinkNameUnit, RemXUnit;

{$R *.dfm}
{$R DinNode.res}

{ TDinNode }

procedure TDinNoder.Assign(Source: TPersistent);
var C: TDinNoder;
begin
  inherited;
  C:=Source as TDinNoder;
  FPtName:=C.PtName;
end;

constructor TDinNoder.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle:=ControlStyle+[csOpaque];
  First:=True;
  IsLinked:=False;
  FDinKind:=dkInfoConfirm;
  Width:=80;
  Height:=40;
  Constraints.MaxWidth:=80;
  Constraints.MinWidth:=80;
  Constraints.MaxHeight:=40;
  Constraints.MinHeight:=40;
  ImageNode:='B4';
  LastPtName:='';
  with Canvas.Font do
  begin
    CharSet:=RUSSIAN_CHARSET;
    Name:='Small Fonts';
    Size:=7;
  end;
  bkColor:=clBlack;
  frColor:=clBlack;
end;

function TDinNoder.LoadFromStream(Stream: TStream): integer;
begin
  Result:=SizeOf(Body);
  if (Stream.Size-Stream.Position) < Result then
  begin
    Result:=0;
    Exit;
  end;
  Stream.ReadBuffer(Body,Result);
  FPtName:=Body.PtName;
  FLinkName:=FPtName;
  SetBounds(Body.Left,Body.Top,Body.Width,Body.Height);
end;

procedure TDinNoder.Paint;
var TR: TRect; BMP,Cash: TBitMap;
begin
  Cash:=TBitmap.Create;
  try
    Cash.Width:=Width;
    Cash.Height:=Height;
    BMP:=TBitMap.Create;
    try
      BMP.LoadFromResourceName(hInstance,ImageNode);
      Cash.Canvas.StretchDraw(ClientRect,BMP);
      Cash.Canvas.Brush.Style:=bsClear;
      with Cash.Canvas.Font do
      begin
        Name:='Small Fonts';
        CharSet:=RUSSIAN_CHARSET;
        Size:=7;
        Style:=[];
        Color:=clWhite;
      end;
      TR:=Rect(29,3,76,18);
      DrawText(Cash.Canvas.Handle,PChar(FPtName),-1,TR,
               DT_SINGLELINE or DT_CENTER or DT_VCENTER);
      Cash.Canvas.Brush.Style:=bsSolid;
      Cash.Canvas.Brush.Color:=bkColor;
      TR:=Rect(22,21,76,37);
      Cash.Canvas.FillRect(TR);
      with Cash.Canvas.Font do
      begin
        Name:='Tahoma';
        CharSet:=RUSSIAN_CHARSET;
        Size:=9;
        Color:=frColor
      end;
      DrawText(Cash.Canvas.Handle,PChar(StateName),-1,TR,
               DT_SINGLELINE or DT_CENTER or DT_VCENTER);
    finally
      BMP.Free;
    end;
    if Editing and Focused then Draw8Points(Cash.Canvas);
    if not Editing and Focused then
    begin
      Cash.Canvas.Brush.Color:=clAqua;
      Cash.Canvas.FrameRect(ClientRect);
    end;
    Canvas.Draw(0,0,Cash);
  finally
    Cash.Free;
  end;
end;

procedure TDinNoder.SaveToIniFile(MF: TMemInifile);
var SectName: string; i: integer;
begin
  i:=MF.ReadInteger('DinTypeCounts','DinNoder',0);
  Inc(i);
  MF.WriteInteger('DinTypeCounts','DinNoder',i);
  SectName:=Format('DinNoder%d',[i]);
  MF.WriteInteger(SectName,'DinType',DinType);
  MF.WriteString(SectName,'PtName',PtName);
  MF.WriteInteger(SectName,'Left',Left);
  MF.WriteInteger(SectName,'Top',Top);
  MF.WriteInteger(SectName,'Width',Width);
  MF.WriteInteger(SectName,'Height',Height);
end;

procedure TDinNoder.SaveToStream(Stream: TStream);
begin
  Body.DinType:=DinType;
  Body.PtName:=PtName;
  Body.Left:=Left;
  Body.Top:=Top;
  Body.Width:=Width;
  Body.Height:=Height;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

procedure TDinNoder.SetPtName(const Value: string);
begin
  if FPtName <> Value then
  begin
    FPtName := Value;
    Invalidate;
  end;
end;

function TDinNoder.ShowEditor: boolean;
var T: TEntity;
begin
  with TDinNodeEditorForm.Create(Parent) do
  try
    Source:=Self;
    ScrollBox.Color:=(Self.Parent as TBackground).Color;
    seLeft.Value:=Self.Left;
    seTop.Value:=Self.Top;
    Example.Assign(Self);
    if Example.Width < ScrollBox.ClientWidth then
      Example.Left:=(ScrollBox.ClientWidth-Example.Width) div 2
    else
      Example.Left:=0;
    if Example.Height < ScrollBox.ClientHeight then
      Example.Top:=(ScrollBox.ClientHeight-Example.Height) div 2
    else
      Example.Top:=0;
    T:=Caddy.Find(Example.PtName);
    if Assigned(T) then
      edPtName.Text:=T.PtName
    else
      edPtName.Text:='';
    if ShowModal = mrOk then
    begin
      Source.Assign(Example);
      Source.Left:=seLeft.Value;
      Source.Top:=seTop.Value;
      Source.Invalidate;
      Result:=True;
    end
    else
      Result:=False;
  finally
    Free;
  end;
end;

procedure TDinNoder.UpdateData(GetParamVal: TCallbackFunc);
var E: TEntity; LastAlarm: TAlarmState;
begin
  IsLinked:=False;
  if FPtName = '' then
  begin
    ImageNode:='B4';
    Tag := 0;
    bkColor:=clBlue;
    frColor:=clWhite;
    StateName:='-----';
    LastImageNode:='';
    AlarmFound:=False;
    HasAlarm:=False;
    HasConfirm:=True;
    IsAsked:=True;
    if Editing then
      Hint:='Устройство: <>'+#13+
        Format('Смещение: %d, %d; Размер: %d, %d',[Left,Top,Width,Height])
    else
      Hint:='Нет параметра';
    if First or (FPtName <> LastPtName) then
    begin
      First:=False;
      LastPtName:='';
      Invalidate;
    end;
    Exit;
  end;
  LinkName:=FPtName;
  if not GetParamVal(FPtName,E,Blink) then Exit;
  LinkDesc:=E.PtDesc;
  AlarmFound:=E.GetAlarmState(LastAlarm);
  if AlarmFound then
  begin
    HasAlarm:=(LastAlarm in E.AlarmStatus);
    HasConfirm:=(LastAlarm in E.ConfirmStatus);
    IsAsked:=HasConfirm;
  end
  else
  begin
    HasAlarm:=False;
    HasConfirm:=True;
    IsAsked:=True;
  end;
  if not E.Actived then
  begin
    ImageNode:='B4';
    bkColor:=clBlue;
    frColor:=clWhite;
    StateName:='-----';
  end
  else
  if (asNoLink in E.AlarmStatus) then
  begin
    ImageNode:='B2';
    bkColor:=clRed;
    frColor:=clWhite;
    StateName:='ОТКАЗ';
  end
  else
  if asInfo in E.AlarmStatus then
  begin
    ImageNode:='B3'; // Ошибка
    bkColor:=clYellow;
    frColor:=clBlack;
    StateName:='ОШИБКА';
  end
  else
  begin
    ImageNode:='B1'; // Норма
    bkColor:=clBlack;
    frColor:=clGreen;
    StateName:='НОРМА';
  end;
  if E.Logged and Blink and AlarmFound and not HasConfirm then
    ImageNode:='B4';
  if Editing then
    Hint:='Устройство: <'+E.PtName+'>'+#13+
      Format('Смещение: %d, %d; Размер: %d, %d',[Left,Top,Width,Height])
  else
    Hint:=E.PtName+' : '+E.PtDesc;
  if First or not HasConfirm or (FPtName <> LastPtName) or
     (LastHasAlarm <> HasAlarm) or (LastHasConfirm <> HasConfirm) or
     (LastImageNode <> ImageNode) then
  begin
    First:=False;
    LastPtName:=FPtName;
    LastHasAlarm:=HasAlarm;
    LastHasConfirm:=HasConfirm;
    LastImageNode:=ImageNode;
    Invalidate;
  end;
end;

procedure TDinNodeEditorForm.edPtNameClick(Sender: TObject);
var List: TStringList; T,R: TEntity; Kind: Byte;
begin
  List:=TStringList.Create;
  try
    T:=Caddy.Find(edPtName.Text);
    R:=Caddy.FirstEntity;
    while R <> nil do
    begin
      if R.IsCustom then List.AddObject('PV',R);
      R:=R.NextEntity;
    end;
    Kind:=0;
    if GetLinkNameDlg(Self,'Выберите параметр',List,
                          RemXForm.EntityTypeImageList,T,Kind) then
    begin
      if Assigned(T) then
      begin
        edPtName.Text:=T.PtName;
        edPtName.SelectAll;
        Example.PtName:=Trim(edPtName.Text);
      end
      else
      begin
        edPtName.Text:='';
        Example.PtName:='';
      end
    end;
  finally
    List.Free;
  end;
end;

procedure TDinNodeEditorForm.FormCreate(Sender: TObject);
begin
  Example:=TDinNoder.Create(Self);
  Example.Parent:=ScrollBox;
  Fresh.Enabled:=True;
end;

procedure TDinNodeEditorForm.FormDestroy(Sender: TObject);
begin
  Fresh.Enabled:=False;
  Example.Free;
end;

procedure TDinNodeEditorForm.FreshTimer(Sender: TObject);
begin
  Example.UpdateData(@GetParamVal);
end;

procedure TDinNodeEditorForm.Shape1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Example.Focused:=False;
end;

initialization
  RegisterClass(TDinNoder);

end.
