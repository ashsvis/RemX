unit DinValveEditorUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Spin, EntityUnit, DinElementsUnit, VirtualUnit,
  IniFiles;

type
  TDinValve = class(TDinControl)
  private
    Body: record
            DinType: byte;
            PtName: string[10];
            Vertical: boolean;
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
    First: Boolean;
    FPtName: string;
    FVertical: boolean;
    FConfig: boolean;
    FState,LastState: byte;
    FBPV: boolean;
    FLogged: boolean;
    AlarmFound: boolean;
    HasAlarm,LastHasAlarm: boolean;
    HasConfirm,LastHasConfirm: boolean;
    FBlink: boolean;
    WorkActive: boolean;
    LastLinked: boolean;
    procedure SetPtName(const Value: string);
    procedure SetVertical(const Value: boolean);
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
    property Vertical: boolean read FVertical write SetVertical;
  end;

  TDinValveEditorForm = class(TForm)
    PropertyBox: TGroupBox;
    Label3: TLabel;
    rgViewKind: TRadioGroup;
    edPtName: TEdit;
    GroupBox: TGroupBox;
    ScrollBox: TScrollBox;
    CloseButton: TButton;
    CancelButton: TButton;
    Fresh: TTimer;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Bevel2: TBevel;
    seWidth: TSpinEdit;
    seHeight: TSpinEdit;
    seLeft: TSpinEdit;
    seTop: TSpinEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure rgViewKindClick(Sender: TObject);
    procedure edPtNameClick(Sender: TObject);
    procedure FreshTimer(Sender: TObject);
    procedure Shape1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure seWidthChange(Sender: TObject);
    procedure seHeightChange(Sender: TObject);
  private
    Source,Example: TDinValve;
  public
  end;

var
  DinValveEditorForm: TDinValveEditorForm;

implementation

uses GetLinkNameUnit, RemXUnit;

{$R *.dfm}

{ TDinValve }

procedure TDinValve.Assign(Source: TPersistent);
var C: TDinValve;
begin
  inherited;
  C:=Source as TDinValve;
  FPtName:=C.PtName;
  FVertical:=C.Vertical;
end;

constructor TDinValve.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle:=ControlStyle+[csOpaque];
  First:=True;
  IsLinked:=False;
  Width:=30;
  Height:=20;
  FDinKind:=dkValve;
end;

function TDinValve.LoadFromStream(Stream: TStream): integer;
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
  FVertical:=Body.Vertical;
  SetBounds(Body.Left,Body.Top,Body.Width,Body.Height);
end;

procedure TDinValve.Paint;
var X, Y, W, H: Integer; R: TRect; Cash: TCanvas; Bkg: TBackground;
begin
  if Parent is TBackground then Bkg:=TBackground(Parent) else Bkg:=nil;
  Cash:=Self.Canvas;
  with Cash do
  begin
    R := ClientRect;
    if Bkg <> nil then CopyRect(R,Bkg.Bitmap.Canvas,BoundsRect);
    X := R.Left;
    Y := R.Top;
    W := R.Right - Pen.Width;
    H := R.Bottom - Pen.Width;
    if FConfig and IsLinked then
    begin
      if (FState in [4..7]) or FBPV then
      begin
        if FLogged then
        begin
          if not HasConfirm and FBlink then
            Brush.Style := bsClear
          else
          begin
            Brush.Style := bsSolid;
            Brush.Color := clRed;
            FillRect(R);
          end;
        end;
      end
      else
      begin
        if FLogged then
        begin
          if not HasConfirm and FBlink then
          begin
            Brush.Style := bsSolid;
            Brush.Color := clGray;
            FillRect(R);
          end;
        end;
      end;
      Brush.Style := bsSolid;
      if FBPV then // плохое значение
      begin
        Pen.Color := clWhite;
        Brush.Color := clRed;
      end
      else
      case FState of
        0,4: begin   // ход
               Pen.Color := clWhite; // clGray;
               Brush.Color := clWhite;
             end;
        1,5: begin   // закрыта
               Pen.Color := clWhite;
               Brush.Color := clBlack;
             end;
        2,6: begin  // открыта
               Pen.Color := clLime;
               Brush.Color := clLime; // clGreen;
             end;
        3,7: begin  // авария
               Pen.Color := clRed; // clWhite;
               Brush.Color := clRed;
             end;
      end; {of case}
    end;
    //else                                    // коммент 08.10.14
    //begin                                   // коммент 08.10.14
    //  Pen.Color := clBlue;                  // коммент 08.10.14
    //  Brush.Color := clNavy;                // коммент 08.10.14
    //end;                                    // коммент 08.10.14
    //if not WorkActive and not Editing then  // коммент 08.10.14
    //begin                                   // коммент 08.10.14
    //  Pen.Color := clBlue;                  // коммент 08.10.14
    //  Brush.Color := clNavy;                // коммент 08.10.14
    //end;                                    // коммент 08.10.14
    if FVertical then
      Polygon([Point(X,Y),Point(X+W,Y+H),Point(X,Y+H),Point(X+W,Y),Point(X,Y)])
    else
      Polygon([Point(X,Y),Point(X+W,Y+H),Point(X+W,Y),Point(X,Y+H),Point(X,Y)]);
    if Editing and Focused then Draw8Points(Cash);
    if not Editing and not IsLinked then  // добавлено 08.10.14
    begin                                 // добавлено 08.10.14
      Pen.Color:=clBlue;                  // добавлено 08.10.14
      Pen.Style:=psSolid;                 // добавлено 08.10.14
      if FVertical then                   // добавлено 08.10.14
        Polyline([Point(X,Y),Point(X+W,Y+H),     // добавлено 08.10.14
          Point(X,Y+H),Point(X+W,Y),Point(X,Y)]) // добавлено 08.10.14
      else                                       // добавлено 08.10.14
        Polyline([Point(X,Y),Point(X+W,Y+H),     // добавлено 08.10.14
          Point(X+W,Y),Point(X,Y+H),Point(X,Y)]);// добавлено 08.10.14
    end;                                         // добавлено 08.10.14
    if Focused and not Editing then
    begin
      Pen.Color:=clAqua;
      Pen.Style:=psSolid;
//      Polyline([Point(X,Y),Point(X+W,Y),Point(X+W,Y+H),Point(X,Y+H),Point(X,Y)])
      if FVertical then
        Polyline([Point(X,Y),Point(X+W,Y+H),Point(X,Y+H),Point(X+W,Y),Point(X,Y)])
      else
        Polyline([Point(X,Y),Point(X+W,Y+H),Point(X+W,Y),Point(X,Y+H),Point(X,Y)]);
    end;
  end; {with}
end;

procedure TDinValve.SaveToIniFile(MF: TMemInifile);
var SectName: string; i: integer;
begin
  i:=MF.ReadInteger('DinTypeCounts','DinValve',0);
  Inc(i);
  MF.WriteInteger('DinTypeCounts','DinValve',i);
  SectName:=Format('DinValve%d',[i]);
  MF.WriteInteger(SectName,'DinType',DinType);
  MF.WriteString(SectName,'PtName',PtName);
  MF.WriteBool(SectName,'Vertical',Vertical);
  MF.WriteInteger(SectName,'Left',Left);
  MF.WriteInteger(SectName,'Top',Top);
  MF.WriteInteger(SectName,'Width',Width);
  MF.WriteInteger(SectName,'Height',Height);
end;

procedure TDinValve.SaveToStream(Stream: TStream);
begin
  Body.DinType:=DinType;
  Body.PtName:=PtName;
  Body.Vertical:=Vertical;
  Body.Left:=Left;
  Body.Top:=Top;
  Body.Width:=Width;
  Body.Height:=Height;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

procedure TDinValve.SetPtName(const Value: string);
begin
  if FPtName <> Value then
  begin
    FPtName := Value;
    Invalidate;
  end;
end;

procedure TDinValve.SetVertical(const Value: boolean);
begin
  if FVertical <> Value then
  begin
    FVertical := Value;
    Invalidate;
  end;
end;

function TDinValve.ShowEditor: boolean;
var T: TEntity;
begin
  with TDinValveEditorForm.Create(Parent) do
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
    rgViewKind.OnClick:=nil;
    seWidth.OnChange:=nil;
    seHeight.OnChange:=nil;
    try
      seWidth.MaxValue:=PanelWidth-Example.Left;
      seWidth.Value:=Example.Width;
      seHeight.MaxValue:=PanelHeight-Example.Top;
      seHeight.Value:=Example.Height;
      if Example.Vertical then
        rgViewKind.ItemIndex:=1
      else
        rgViewKind.ItemIndex:=0;
      T:=Caddy.Find(Example.PtName);
      if Assigned(T) then
        edPtName.Text:=T.PtName
      else
        edPtName.Text:='';
    finally
      rgViewKind.OnClick:=rgViewKindClick;
      seWidth.OnChange:=seWidthChange;
      seHeight.OnChange:=seHeightChange;
    end;
    if ShowModal = mrOk then
    begin
      Source.FState:=0;
      Source.Assign(Example);
      Source.Left:=seLeft.Value;
      Source.Top:=seTop.Value;
      Source.Focused:=False;
      Source.Focused:=True;
      Result:=True;
    end
    else
      Result:=False;
  finally
    Free;
  end;
end;

procedure TDinValve.UpdateData(GetParamVal: TCallbackFunc);
var E: TEntity; V: TVirtValve; LastAlarm: TAlarmState;
begin
  IsLinked:=False;
  IsCommand:=False;
  WorkActive:=False;
  FConfig:=False;
  if FPtName = '' then
  begin
    IsAsked:=True;
    if Editing then
      Hint:='Виртуальная задвижка: <>'+#13+
      Format('Смещение: %d, %d; Размер: %d, %d',[Left,Top,Width,Height])
    else
      Hint:='Нет параметра';
    if (LastState <> FState) or First then
    begin
      First:=False;
      LastState:=FState;
      Invalidate;
    end;
    Exit;
  end;
  LinkName:=FPtName;
  if not GetParamVal(FPtName,E,FBlink) then Exit;
  LinkDesc:=E.PtDesc;
  FConfig:=True;
  V:=E as TVirtValve;
  IsLinked:=not (V.NoLink or (asNoLink in V.AlarmStatus));
  WorkActive:=IsLinked and V.Actived;
  IsCommand:=True;
  FState:=V.PV;
  FBPV:=asBadPV in V.AlarmStatus;
  FLogged:=V.Logged;
  AlarmFound:=V.GetAlarmState(LastAlarm);
  if AlarmFound then
  begin
    HasAlarm:=(LastAlarm in V.AlarmStatus);
    HasConfirm:=(LastAlarm in V.ConfirmStatus);
    IsAsked:=HasConfirm;
  end
  else
  begin
    HasAlarm:=False;
    HasConfirm:=True;
    IsAsked:=True;
  end;
  if Editing then
    Hint:='Виртуальная задвижка: <'+E.PtName+'>'+#13+
    Format('Смещение: %d, %d; Размер: %d, %d',[Left,Top,Width,Height])
  else
    Hint:=E.PtName+' : '+E.PtDesc;
  if (LastState <> FState) or First or not HasConfirm or
     (LastHasAlarm <> HasAlarm) or (LastHasConfirm <> HasConfirm) or
     (LastLinked <> IsLinked) then
  begin
    First:=False;
    LastState:=FState;
    LastHasAlarm:=HasAlarm;
    LastHasConfirm:=HasConfirm;
    LastLinked:=IsLinked;
    Invalidate;
  end;
end;

procedure TDinValveEditorForm.FormCreate(Sender: TObject);
begin
  Example:=TDinValve.Create(Self);
  Example.Parent:=ScrollBox;
  Fresh.Enabled:=True;
end;

procedure TDinValveEditorForm.FormDestroy(Sender: TObject);
begin
  Fresh.Enabled:=False;
  Example.Free;
end;

procedure TDinValveEditorForm.rgViewKindClick(Sender: TObject);
begin
  Example.Vertical:=(rgViewKind.ItemIndex = 1);
  with Example do
    SetBounds(Left+(Width-Height) div 2,Top-(Width-Height) div 2,Height,Width);
  seWidth.OnChange:=nil;
  seHeight.OnChange:=nil;
  try
    seLeft.Value:=Source.Left-(Example.Width-Example.Height) div 2;
    seTop.Value:=Source.Top+(Example.Width-Example.Height) div 2;
    seWidth.MaxValue:=PanelWidth-Example.Left;
    seWidth.Value:=Example.Width;
    seHeight.MaxValue:=PanelHeight-Example.Top;
    seHeight.Value:=Example.Height;
  finally
    seWidth.OnChange:=seWidthChange;
    seHeight.OnChange:=seHeightChange;
  end;
end;

procedure TDinValveEditorForm.edPtNameClick(Sender: TObject);
var List: TStringList; T,R: TEntity; Kind: Byte;
begin
  List:=TStringList.Create;
  try
    T:=Caddy.Find(edPtName.Text);
    R:=Caddy.FirstEntity;
    while R <> nil do
    begin
      if R is TVirtValve then
        List.AddObject('PV',R);
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

procedure TDinValveEditorForm.FreshTimer(Sender: TObject);
begin
  Example.UpdateData(@GetParamVal);
  Example.FState:=0;
end;

procedure TDinValveEditorForm.Shape1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Example.Focused:=False;
end;

procedure TDinValveEditorForm.seWidthChange(Sender: TObject);
begin
  Example.Width:=seWidth.Value;
  if Example.Width < ScrollBox.ClientWidth then
    Example.Left:=(ScrollBox.ClientWidth-Example.Width) div 2
  else
    Example.Left:=0;
end;

procedure TDinValveEditorForm.seHeightChange(Sender: TObject);
begin
  Example.Height:=seHeight.Value;
  if Example.Height < ScrollBox.ClientHeight then
    Example.Top:=(ScrollBox.ClientHeight-Example.Height) div 2
  else
    Example.Top:=0;
end;

initialization
  RegisterClass(TDinValve);

end.
