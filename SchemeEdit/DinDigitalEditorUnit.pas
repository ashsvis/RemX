unit DinDigitalEditorUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StdCtrls, Spin, ExtCtrls, EntityUnit, DinElementsUnit, IniFiles;

type
  TViewKind = (dkSquare,dkCircle,dkRect,dkEllipce);
  TBorderKind = (bkNone,bkSingle,bkVolume);

  TDinDigital = class(TDinControl)
  private
    Body: record
            DinType: byte;
            PtName: string[10];
            Kind: TViewKind;
            Border: TBorderKind;
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
    State: Boolean;
    Color0: TColor;
    Color1: TColor;
    LastState: Boolean;
    LastLinked: Boolean;
    HasAlarm: Boolean;
    HasConfirm: Boolean;
    LastHasAlarm: Boolean;
    LastHasConfirm: Boolean;
    AlarmFound: boolean;
    Blink: Boolean;
    FPtName, LastPtName: string;
    FBorder: TBorderKind;
    FKind: TViewKind;
    procedure SetBorder(const Value: TBorderKind);
    procedure SetKind(const Value: TViewKind);
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
    property Kind: TViewKind read FKind write SetKind;
    property Border: TBorderKind read FBorder write SetBorder;
  end;

  TDinDigitalEditorForm = class(TForm)
    GroupBox: TGroupBox;
    ScrollBox: TScrollBox;
    CloseButton: TButton;
    PropertyBox: TGroupBox;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Bevel2: TBevel;
    seWidth: TSpinEdit;
    seHeight: TSpinEdit;
    seLeft: TSpinEdit;
    seTop: TSpinEdit;
    CancelButton: TButton;
    rgViewKind: TRadioGroup;
    rgBorderKind: TRadioGroup;
    Label3: TLabel;
    edPtName: TEdit;
    Fresh: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FreshTimer(Sender: TObject);
    procedure Shape1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure seWidthChange(Sender: TObject);
    procedure seHeightChange(Sender: TObject);
    procedure rgViewKindClick(Sender: TObject);
    procedure rgBorderKindClick(Sender: TObject);
    procedure edPtNameClick(Sender: TObject);
  private
    Source,Example: TDinDigital;
  public
  end;

implementation

uses GetLinkNameUnit, RemXUnit;

{$R *.dfm}

{ TDinDigital }

procedure TDinDigital.Assign(Source: TPersistent);
var C: TDinDigital;
begin
  inherited;
  C:=Source as TDinDigital;
  FPtName:=C.PtName;
  FKind:=C.Kind;
  FBorder:=C.Border;
end;

constructor TDinDigital.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle:=ControlStyle+[csOpaque];
  First:=True;
  IsLinked:=False;
  FDinKind:=dkDigital;
  Width:=25;
  Height:=25;
  LastPtName:='';
end;

function TDinDigital.LoadFromStream(Stream: TStream): integer;
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
  FKind:=Body.Kind;
  FBorder:=Body.Border;
  SetBounds(Body.Left,Body.Top,Body.Width,Body.Height);
end;

procedure TDinDigital.Paint;
var R,RClient: TRect; CurrColor: TColor; Cash: TCanvas; Bkg: TBackground;
begin
  if Parent is TBackground then Bkg:=TBackground(Parent) else Bkg:=nil;
  R:=Rect(0,0,Width,Height);
  Cash:=Canvas;
  if Bkg <> nil then Cash.CopyRect(R,Bkg.Bitmap.Canvas,BoundsRect);
  if (FKind = dkSquare) or (FKind = dkCircle) then
  begin
    if Width > Height then
    begin
      R.Left:=(Width-Height) div 2;
      R.Right:=R.Left+Height;
    end
    else
    begin
      R.Top:=(Height-Width) div 2;
      R.Bottom:=R.Top+Width;
    end;
  end;
  RClient:=R;
  case FBorder of
  bkSingle:
    begin
      case FKind of
  dkSquare,dkRect:
        begin
          Cash.Pen.Color:=clBtnFace;
          Cash.Brush.Style:=bsClear;
          Cash.Rectangle(R);
        end;
  dkCircle,dkEllipce:
        begin
          Cash.Pen.Color:=clBtnFace;
          Cash.Brush.Style:=bsClear;
          Cash.Ellipse(R);
        end;
      end;
    end;
  bkVolume:
    begin
      case FKind of
  dkSquare,dkRect:
        begin
// Внешняя выпуклая рамка
          Inflaterect(R,-1,-1);
          Cash.Pen.Width:=1;
          Cash.Pen.Color:=clWhite;
            Cash.MoveTo(R.Left,R.Bottom);
            Cash.LineTo(R.Left,R.Top);
            Cash.LineTo(R.Right+1,R.Top);
          Cash.Pen.Color:=clGray;
            Cash.MoveTo(R.Left,R.Bottom);
            Cash.LineTo(R.Right,R.Bottom);
            Cash.LineTo(R.Right,R.Top-1);
// Рамка
          Inflaterect(R,-1,-1);
          Cash.Pen.Color:=clBtnFace;
          Cash.Pen.Width:=1;
          Cash.MoveTo(R.Left,R.Bottom);
          Cash.LineTo(R.Left,R.Top);
          Cash.LineTo(R.Right+1,R.Top);
          Cash.MoveTo(R.Left,R.Bottom);
          Cash.LineTo(R.Right,R.Bottom);
          Cash.LineTo(R.Right,R.Top-1);
// Внутренняя вогнутая рамка
          Inflaterect(R,-1,-1);
          Cash.Pen.Width:=1;
          Cash.Pen.Color:=cl3DDkShadow;
            Cash.MoveTo(R.Left,R.Bottom);
            Cash.LineTo(R.Left,R.Top);
            Cash.LineTo(R.Right+1,R.Top);
          Cash.Pen.Color:=cl3DLight;
            Cash.MoveTo(R.Left,R.Bottom);
            Cash.LineTo(R.Right,R.Bottom);
            Cash.LineTo(R.Right,R.Top-1);
        end;
  dkCircle,dkEllipce:
        begin
// Внутренняя вогнутая рамка
          Cash.Pen.Color:=clGray;
          Cash.Arc(R.Left,R.Top,R.Right,R.Bottom,R.Right,R.Top,R.Left,R.Bottom);
          Cash.Pen.Color:=clWhite;
          Cash.Arc(R.Left,R.Top,R.Right,R.Bottom,R.Left,R.Bottom,R.Right,R.Top);
          Inflaterect(R,-1,-1);
          Cash.Pen.Color:=cl3DDkShadow;
          Cash.Arc(R.Left,R.Top,R.Right,R.Bottom,R.Right,R.Top,R.Left,R.Bottom);
          Cash.Pen.Color:=cl3DLight;
          Cash.Arc(R.Left,R.Top,R.Right,R.Bottom,R.Left,R.Bottom,R.Right,R.Top);
          Inflaterect(R,-1,-1);
        end;
      end;
    end;
  end;
// Внутренняя рамка
  if FBorder <> bkNone then InflateRect(R,-1,-1);
  //if not IsLinked then                  // коммент 08.10.14
  //  Cash.Brush.Color:=clBlue            // коммент 08.10.14
  //else                                  // коммент 08.10.14
  //begin                                 // коммент 08.10.14
    if State then                         
      CurrColor:=Color1
    else
      CurrColor:=Color0;
    if AlarmFound then
    begin
      if HasConfirm then
        Cash.Brush.Color:=CurrColor
      else
      begin
        if CurrColor = clBlack then
        begin
          if Blink then
            Cash.Brush.Color:=clBlack
          else
            Cash.Brush.Color:=$00e2e2e2;
        end
        else
        begin
          if Blink then
            Cash.Brush.Color:=CurrColor
          else
            Cash.Brush.Color:=$00282828;
        end;
      end;
    end
    else
      Cash.Brush.Color:=CurrColor;
  //end;                                   // коммент 08.10.14
  Cash.Pen.Color:=Cash.Brush.Color;
  case FKind of
    dkSquare,dkRect: Cash.Rectangle(R);
 dkCircle,dkEllipce: Cash.Ellipse(R);
  end;
// Рамки выбора
  if Editing then
  begin
    if FBorder = bkNone then
    begin
      Cash.Pen.Color:=clSilver;
      Cash.Pen.Style:=psDash;
      Cash.Brush.Style:=bsClear;
      case FKind of
        dkSquare,dkRect: Cash.Rectangle(R);
        dkCircle,dkEllipce: Cash.Ellipse(R);
      end;
      Cash.Brush.Style:=bsSolid;
      Cash.Pen.Style:=psSolid;
    end;
  end;
  if Editing and Focused then Draw8Points(Cash);
  // При пропаже связи рисуется синяя рамка         // добавлено 08.10.14
  if not Editing and not IsLinked then              // добавлено 08.10.14
  begin                                             // добавлено 08.10.14
    Cash.Pen.Color:=clBlue;                         // добавлено 08.10.14
    Cash.Brush.Style:=bsClear;                      // добавлено 08.10.14
    case FKind of                                   // добавлено 08.10.14
      dkSquare,dkRect: Cash.Rectangle(RClient);     // добавлено 08.10.14
      dkCircle,dkEllipce: Cash.Ellipse(RClient);    // добавлено 08.10.14
    end;                                            // добавлено 08.10.14
    Cash.Brush.Style:=bsSolid;                      // добавлено 08.10.14
    Cash.Pen.Style:=psSolid;                        // добавлено 08.10.14
  end;                                              // добавлено 08.10.14
  if not Editing and Focused then
  begin
    Cash.Pen.Color:=clAqua;
    Cash.Brush.Style:=bsClear;
    case FKind of
      dkSquare,dkRect: Cash.Rectangle(RClient);
      dkCircle,dkEllipce: Cash.Ellipse(RClient);
    end;
    Cash.Brush.Style:=bsSolid;
    Cash.Pen.Style:=psSolid;
  end;
end;

procedure TDinDigital.SaveToIniFile(MF: TMemInifile);
var SectName: string; i: integer;
begin
  i:=MF.ReadInteger('DinTypeCounts','DinDigital',0);
  Inc(i);
  MF.WriteInteger('DinTypeCounts','DinDigital',i);
  SectName:=Format('DinDigital%d',[i]);
  MF.WriteInteger(SectName,'DinType',DinType);
  MF.WriteString(SectName,'PtName',PtName);
  MF.WriteInteger(SectName,'Kind',Ord(Kind));
  MF.WriteInteger(SectName,'Border',Ord(Border));
  MF.WriteInteger(SectName,'Left',Left);
  MF.WriteInteger(SectName,'Top',Top);
  MF.WriteInteger(SectName,'Width',Width);
  MF.WriteInteger(SectName,'Height',Height);
end;

procedure TDinDigital.SaveToStream(Stream: TStream);
begin
  Body.DinType:=DinType;
  Body.PtName:=PtName;
  Body.Kind:=Kind;
  Body.Border:=Border;
  Body.Left:=Left;
  Body.Top:=Top;
  Body.Width:=Width;
  Body.Height:=Height;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

procedure TDinDigital.SetBorder(const Value: TBorderKind);
begin
  if FBorder <> Value then
  begin
    FBorder := Value;
    Invalidate;
  end;
end;

procedure TDinDigital.SetKind(const Value: TViewKind);
begin
  if FKind <> Value then
  begin
    FKind := Value;
    Invalidate;
  end;
end;

procedure TDinDigital.SetPtName(const Value: string);
begin
  if FPtName <> Value then
  begin
    FPtName := Value;
    Invalidate;
  end;
end;

function TDinDigital.ShowEditor: boolean;
var T: TEntity;
begin
  with TDinDigitalEditorForm.Create(Parent) do
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
    seWidth.OnChange:=nil;
    seHeight.OnChange:=nil;
    try
      seWidth.MaxValue:=PanelWidth-Example.Left;
      seWidth.Value:=Example.Width;
      seHeight.MaxValue:=PanelHeight-Example.Top;
      seHeight.Value:=Example.Height;
      rgViewKind.ItemIndex:=Ord(Example.Kind);
      rgBorderKind.ItemIndex:=Ord(Example.Border);
      T:=Caddy.Find(Example.PtName);
      if Assigned(T) then
        edPtName.Text:=T.PtName
      else
        edPtName.Text:='';
    finally
      seWidth.OnChange:=seWidthChange;
      seHeight.OnChange:=seHeightChange;
    end;
    if ShowModal = mrOk then
    begin
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

procedure TDinDigital.UpdateData(GetParamVal: TCallbackFunc);
var E: TEntity; DOUT: TCustomDigOut; DINP: TCustomDigInp;
    LastAlarm: TAlarmState;
begin
  IsLinked:=False;
  IsCommand:=False;
  if FPtName = '' then
  begin
    if Editing then
      Hint:='Дискретное значание: <>'+#13+
      Format('Смещение: %d, %d; Размер: %d, %d',[Left,Top,Width,Height])
    else
      Hint:='Нет параметра';
    if (LastState <> State) or First or (LastPtName <> FPtName) then
    begin
      First:=False;
      LastState:=State;
      LastPtName:='';
      Invalidate;
    end;
    Exit;
  end;
  LinkName:=FPtName;
  if not GetParamVal(FPtName,E,Blink) then Exit;
  LinkDesc:=E.PtDesc;
  if E.IsParam then
  begin
    DINP:=E as TCustomDigInp;
    IsLinked:=not (asNoLink in DINP.AlarmStatus);
    State:=DINP.OP;
    Color0:=clRed;
    Color1:=clLime;
    AlarmFound:=False;
    HasAlarm:=False;
    IsAsked:=True;
    HasConfirm:=True;
    IsCommand:=True;
  end
  else
  begin
    DOUT:=E as TCustomDigOut;
    IsLinked:=not (asNoLink in DOUT.AlarmStatus);
    IsCommand:=E.IsCommand or E.IsVirtual;
    State:=DOUT.PV;
    Color0:=ArrayDigColor[DOUT.ColorDown];
    Color1:=ArrayDigColor[DOUT.ColorUp];
    AlarmFound:=DOUT.GetAlarmState(LastAlarm);
    if AlarmFound then
    begin
      HasAlarm:=(LastAlarm in DOUT.AlarmStatus);
      HasConfirm:=(LastAlarm in DOUT.ConfirmStatus);
      IsAsked:=HasConfirm;
    end
    else
    begin
      HasAlarm:=False;
      HasConfirm:=True;
      IsAsked:=True;
    end;
  end;
  if Editing then
    Hint:='Дискретное значение: <'+E.PtName+'>'+#13+
      Format('Смещение: %d, %d; Размер: %d, %d',[Left,Top,Width,Height])
  else
    Hint:=E.PtName+' : '+E.PtDesc;
  if (LastState <> State) or First or not HasConfirm or
     (LastPtName <> FPtName) or
     (LastHasAlarm <> HasAlarm) or (LastHasConfirm <> HasConfirm) or
     (LastLinked <> IsLinked) then
  begin
    First:=False;
    LastState:=State;
    LastPtName:=FPtName;
    LastHasAlarm:=HasAlarm;
    LastHasConfirm:=HasConfirm;
    LastLinked:=IsLinked;
    Invalidate;
  end;
end;

procedure TDinDigitalEditorForm.FormCreate(Sender: TObject);
begin
  Example:=TDinDigital.Create(Self);
  Example.Parent:=ScrollBox;
  Fresh.Enabled:=True;
end;

procedure TDinDigitalEditorForm.FormDestroy(Sender: TObject);
begin
  Fresh.Enabled:=False;
  Example.Free;
end;

procedure TDinDigitalEditorForm.FreshTimer(Sender: TObject);
begin
  Example.UpdateData(@GetParamVal);
end;

procedure TDinDigitalEditorForm.Shape1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Example.Focused:=False;
end;

procedure TDinDigitalEditorForm.seWidthChange(Sender: TObject);
begin
  Example.Width:=seWidth.Value;
  if Example.Width < ScrollBox.ClientWidth then
    Example.Left:=(ScrollBox.ClientWidth-Example.Width) div 2
  else
    Example.Left:=0;
end;

procedure TDinDigitalEditorForm.seHeightChange(Sender: TObject);
begin
  Example.Height:=seHeight.Value;
  if Example.Height < ScrollBox.ClientHeight then
    Example.Top:=(ScrollBox.ClientHeight-Example.Height) div 2
  else
    Example.Top:=0;
end;

procedure TDinDigitalEditorForm.rgViewKindClick(Sender: TObject);
begin
  Example.Kind:=TViewKind(rgViewKind.ItemIndex);
end;

procedure TDinDigitalEditorForm.rgBorderKindClick(Sender: TObject);
begin
  Example.Border:=TBorderKind(rgBorderKind.ItemIndex);
end;

procedure TDinDigitalEditorForm.edPtNameClick(Sender: TObject);
var List: TStringList; T,R: TEntity; Kind: Byte;
begin
  List:=TStringList.Create;
  try
    T:=Caddy.Find(edPtName.Text);
    R:=Caddy.FirstEntity;
    while R <> nil do
    begin
      if R.IsDigit and R.IsParam then
        List.AddObject('OP',R);
      if R.IsDigit and not R.IsParam then
        List.AddObject('PV',R);
      R:=R.NextEntity;
    end;
    if Assigned(T) then
    begin
      if T.IsParam then
        Kind:=2
      else
        Kind:=0;
    end
    else
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

initialization
  RegisterClass(TDinDigital);

end.
