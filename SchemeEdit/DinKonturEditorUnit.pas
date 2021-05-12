unit DinKonturEditorUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Spin, EntityUnit, DinElementsUnit, IniFiles;

type
  TAlarm = (RS, OK, HH, HI, LO, LL, DH, DL);
  TSPLad = (NZ,VZ, PZ, RZ);
  TDULad = (KL, DU);
  TKULU = (NU, LU, KU, ER);
  TAURU = (AU, RU);

  TButtonKind = (bkLessPress,bkLessRelease,bkMorePress,bkMoreRelease);
  TDinKontur = class(TDinControl)
  private
    Body: record
            DinType: byte;
            PtName: string[10];
            Font: TFontRec;
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
    HRLess,HRMore: HRgn;
    First: Boolean;
    FPtName: string;
    FPulse: boolean;
    LessActive: boolean;
    MoreActive: boolean;
    WorkActive: boolean;
    FAlarm: TAlarm;
    FSPLad : TSPLad;
    FAURU: TAURU;
    FKULU: TKULU;
    FDULad: TDULad;
    FOPLo,FPVLo,FSPLo,FSPValue,FPVValue,FOPValue,FOPHi,FPVHi,FSPHi: Single;
    FPointEU: String;
    FormatPV: String;
    DFColor,LastDFColor: TColor;
    FAlarmStatus: set of TAlarmState;
    FLogged: boolean;
    HasAlarm: Boolean;
    HasConfirm: Boolean;
    LastHasAlarm: Boolean;
    LastHasConfirm: Boolean;
    AlarmFound: boolean;
    IT: TTimer;
    procedure SetPtName(const Value: string);
    function PercentDone(const CurValue, MinValue, MaxValue: Double): Double;
    procedure WMLeftButtonDown(var Msg: TWMMouseMove); message WM_LButtonDown;
    procedure WMMouseMove(var Msg: TWMMouseMove); message WM_MouseMove;
    procedure WMLeftButtonUp(var Msg: TWMMouseMove); message WM_LButtonUp;
    procedure CalcSize;
    procedure ITTimer(Sender: TObject);
  protected
    procedure Paint; override;
    function GetDinKind: TDinKind; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ShowEditor: boolean; override;
    procedure Assign(Source: TPersistent); override;
    procedure SaveToStream(Stream: TStream); override;
    procedure SaveToIniFile(MF: TMemInifile); override;
    function LoadFromStream(Stream: TStream): integer; override;
    procedure UpdateData(GetParamVal: TCallbackFunc); override;
    procedure ButtonClick(Kind: TButtonKind);
  published
    property PtName: string read FPtName write SetPtName;
    property Font;
  end;

 TDinKonturEditorForm = class(TForm)
    GroupBox: TGroupBox;
    ScrollBox: TScrollBox;
    CloseButton: TButton;
    PropertyBox: TGroupBox;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label3: TLabel;
    Bevel2: TBevel;
    seWidth: TSpinEdit;
    seHeight: TSpinEdit;
    seLeft: TSpinEdit;
    seTop: TSpinEdit;
    edPtName: TEdit;
    CancelButton: TButton;
    Fresh: TTimer;
    buFont: TButton;
    Bevel1: TBevel;
    FontDialog: TFontDialog;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure seWidthChange(Sender: TObject);
    procedure seHeightChange(Sender: TObject);
    procedure edPtNameClick(Sender: TObject);
    procedure buFontClick(Sender: TObject);
    procedure FreshTimer(Sender: TObject);
    procedure Shape1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    Source,Example: TDinKontur;
  public
  end;

var
  DinKonturEditorForm: TDinKonturEditorForm;

implementation

uses GetLinkNameUnit, Math, Menus, RemXUnit;

{$R *.dfm}

{ This function solves for x in the equation "x is y% of z". }
function SolveForX(Y, Z: Double): Longint;
begin
  Result := Longint(Trunc( Z * (Y * 0.01) ));
end;

{ This function solves for y in the equation "x is y% of z". }
function SolveForY(X, Z: Extended): Extended;
begin
  if Z = 0 then
    Result := 0.0
  else
  begin
    try
      if X < 1.0E-20 then
        Result:=0.0
      else
        Result := (X * 100.0)/Z;
    except
      Result := 0.0;
    end;
  end;
end;

{ TDinKontur }

function TDinKontur.PercentDone(const CurValue, MinValue, MaxValue: Double): Double;
begin
  Result := SolveForY(CurValue - MinValue, MaxValue - MinValue);
end;

procedure TDinKontur.Assign(Source: TPersistent);
var C: TDinKontur;
begin
  inherited;
  C:=Source as TDinKontur;
  FPtName:=C.PtName;
  Font.Assign(C.Font);
  CalcSize;
end;

constructor TDinKontur.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle:=ControlStyle+[csOpaque];
  IT:=TTimer.Create(Self);
  IT.Interval:=9000;
  IT.OnTimer:=ITTimer;
  First:=True;
  IsLinked:=False;
  FDinKind:=dkKonturSPOP;
  Width:=80;
  Height:=80;
  FormatPV:='------';
  Font.Name:='Tahoma';
  Font.Charset:=RUSSIAN_CHARSET;
  Font.Size:=8;
  Font.Color:=clLime;
  HRLess:=CreateRectRgn(5, 61, 14, 76);
  HRMore:=CreateRectRgn(Width-14, 61, Width-5, 76);
end;

destructor TDinKontur.Destroy;
begin
  DeleteObject(HRLess);
  DeleteObject(HRMore);
  IT.Enabled:=False;
  IT.Free;
  inherited;
end;

procedure TDinKontur.CalcSize;
var BarHeight,BarPos: integer;
begin
  DeleteObject(HRLess);
  DeleteObject(HRMore);
  BarHeight:=(Height-35) div 3;
  BarPos:=27;
  BarPos:=BarPos+BarHeight+2;
  BarPos:=BarPos+BarHeight+2;
  HRLess:=CreateRectRgn(5, BarPos, 14, BarPos+BarHeight);
  HRMore:=CreateRectRgn(Width-14, BarPos, Width-5, BarPos+BarHeight);
end;

function TDinKontur.LoadFromStream(Stream: TStream): integer;
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
  Font.Name:=Body.Font.Name;
  Font.Color:=Body.Font.Color;
  Font.Charset:=Body.Font.CharSet;
  Font.Size:=Body.Font.Size;
  Font.Style:=Body.Font.Style;
  SetBounds(Body.Left,Body.Top,Body.Width,Body.Height);
  CalcSize;
end;

procedure TDinKontur.Paint;
var R,PR,CR: TRect;
    X, Y, W, H: Integer; FillSize: LongInt; S: String;
    BarHeight,BarPos: integer;
begin
  R:=Rect(0,0,Width,Height);
  with Canvas do
  begin
    PR:=R;
// Рисование панели регулятора
    Brush.Style := bsSolid;
    Brush.Color := clBlack;
    Pen.Color := clBlack;
    Rectangle(PR.Left, PR.Top, PR.Right, PR.Bottom);
    Brush.Color := clBtnFace;
    Pen.Color := clWhite;
    Rectangle(PR.Left+1, PR.Top+1, PR.Right-1, PR.Bottom-1);
    Pen.Color := cl3DDkShadow;
    PolyLine([Point(PR.Right-2, PR.Top+1), Point(PR.Right-2, PR.Bottom-2),
                   Point(PR.Left+1, PR.Bottom-2)]);

// Рисование индикатора типа задания
    Brush.Color := clBlack;
    Rectangle(Width-19, 13, Width-3, 26);  //3 + 12 - 2
    Pen.Color := clWhite;
    PolyLine([Point(Width-18, 25), Point(Width-4, 25), Point(Width-4, 12)]);
// Рисование индикаторов режимов управления
    Pen.Color := cl3DDkShadow;
    Brush.Color := clBlack;
    Rectangle(3, 13, 19, 26);
    Rectangle(21, 13, 37, 26);
    Rectangle(39, 13, 55, 26);
    Pen.Color := clWhite;
    PolyLine([Point(4, 25), Point(18, 25), Point(18, 12)]);
    PolyLine([Point(22, 25), Point(36, 25), Point(36, 12)]);
    PolyLine([Point(40, 25), Point(54, 25), Point(54, 12)]);

// Рисование окон вывода PV, SP, OP
    BarHeight:=(Height-35) div 3;
    BarPos:=27;
    Brush.Color := $00282828;
    R:=Rect(5, BarPos, Width-5, BarPos+BarHeight);
    BarPos:=BarPos+BarHeight+2;
    FillRect(R);
    Pen.Color := cl3DDkShadow;
    Polyline([Point(R.Left, R.Bottom-1),
              Point(R.Left, R.Top),
              Point(R.Right-1, R.Top)]);
    Pen.Color := clWhite;
    Polyline([Point(R.Right-1, R.Top),
              Point(R.Right-1, R.Bottom-1),
              Point(R.Left, R.Bottom-1)]);
    R:=Rect(5, BarPos, Width-5, BarPos+BarHeight);
    BarPos:=BarPos+BarHeight+2;
    FillRect(R);
    Pen.Color := cl3DDkShadow;
    Polyline([Point(R.Left, R.Bottom-1),
              Point(R.Left, R.Top),
              Point(R.Right-1, R.Top)]);
    Pen.Color := clWhite;
    Polyline([Point(R.Right-1, R.Top),
              Point(R.Right-1, R.Bottom-1),
              Point(R.Left, R.Bottom-1)]);
    if FPulse then
      R:=Rect(15, BarPos, Width-15, BarPos+BarHeight)
    else
      R:=Rect(5, BarPos, Width-5, BarPos+BarHeight);
    FillRect(R);
    Pen.Color := cl3DDkShadow;
    Polyline([Point(R.Left, R.Bottom-1),
              Point(R.Left, R.Top),
              Point(R.Right-1, R.Top)]);
    Pen.Color := clWhite;
    Polyline([Point(R.Right-1, R.Top),
              Point(R.Right-1, R.Bottom-1),
              Point(R.Left, R.Bottom-1)]);
    if FPulse then
    begin
      R:=Rect(5, BarPos, 14, BarPos+BarHeight);
      if LessActive then
        Brush.Color:=clLime
      else
        Brush.Color := $00282828;
      Polygon([Point(R.Left, R.Top+(R.Bottom-R.Top) div 2),
               Point(R.Right-1, R.Top),
               Point(R.Right-1, R.Bottom-1)]);
      Pen.Color := cl3DDkShadow;
      Polyline([Point(R.Left, R.Top+(R.Bottom-R.Top) div 2),
                Point(R.Right-1, R.Top)]);
      Pen.Color := clWhite;
      Polyline([Point(R.Right-1, R.Top),
                Point(R.Right-1, R.Bottom-1),
                Point(R.Left, R.Top+(R.Bottom-R.Top) div 2)]);
//-------------------------------------------------
      R:=Rect(Width-14, BarPos, Width-5, BarPos+BarHeight);
      if MoreActive then
        Brush.Color:=clLime
      else
        Brush.Color := $00282828;
      Polygon([Point(R.Left, R.Bottom-1),
               Point(R.Left, R.Top),
               Point(R.Right-1, R.Top+(R.Bottom-R.Top) div 2)]);
      Pen.Color := cl3DDkShadow;
      Polyline([Point(R.Left, R.Bottom-1),
                Point(R.Left, R.Top),
                Point(R.Right-1, R.Top+(R.Bottom-R.Top) div 2)]);
      Pen.Color := clWhite;
      Polyline([Point(R.Right-1, R.Top+(R.Bottom-R.Top) div 2),
                Point(R.Left, R.Bottom-1)]);
    end;

    PR := ClientRect;
// Рисование индикатора типа задания
    Brush.Style := bsClear;
    Font.Name := 'Small Fonts';
    Font.Color := clLime;
    Font.Size := 7;
    //if WorkActive then    // коммент 08.10.14
      case FSPLad of
        VZ: TextOut(Width-18, 14, 'ВЗ');   //4 - 1
        PZ: TextOut(Width-18, 14, 'ПЗ');
        RZ: TextOut(Width-18, 14, 'РЗ');
      end;
    Brush.Style := bsSolid;
    Font.Color := clWindowText;
// Рисование индикаторов режимов управления
    Brush.Style := bsClear;
    Font.Name := 'Small Fonts';
    Font.Color := clLime;
    Font.Size := 7;
    //if WorkActive then    // коммент 08.10.14
      case FKULU of
        KU: TextOut(4, 14, 'КУ');
        LU: TextOut(4, 14, 'ЛУ');
      end;
    //if WorkActive then   // коммент 08.10.14
      if FDULad = DU then TextOut(22, 14, 'ДУ');
    //if WorkActive then   // коммент 08.10.14
      case FAURU of
        AU: TextOut(40, 14, 'АУ');
        RU: TextOut(40, 14, 'РУ');
      end;
(*
// Рисование сигнализации
    case FAlarm of
      RS: begin
            Font.Color := clRed;
            TextOut(Width-18, 16, 'RS');
          end;
      HH: begin
            Font.Color := clRed;
            TextOut(Width-18, 16, 'HH');
          end;
      HI: begin
            Font.Color := clYellow;
            TextOut(Width-18, 16, 'HI');
          end;
      LO: begin
            Font.Color := clYellow;
            TextOut(Width-18, 16, 'LO');
          end;
      LL: begin
            Font.Color := clRed;
            TextOut(Width-18, 16, 'LL');
          end;
      DH: begin
            Font.Color := clRed;
            TextOut(Width-18, 16, 'DH');
          end;
      DL: begin
            Font.Color := clRed;
            TextOut(Width-18, 16, 'DL');
          end;
    end;
*)
    Brush.Style := bsSolid;
    Font.Color := clWindowText;
// Рисование окон вывода PV, SP, OP
    BarPos:=29;
    BarHeight:=BarHeight-4;
    W := (Width-6)-6;
  // PVBar
    Brush.Color := clTeal;
    FillSize := SolveForX(PercentDone(FPVValue, FPVLo, FPVHi), W);
    if FillSize > W then FillSize := W;
    if FillSize > 0 then FillRect(Rect(7, BarPos, 5+FillSize, BarPos+BarHeight));
    BarPos:=BarPos+BarHeight+6;
  // SPBar
    Brush.Color := clTeal;
    FillSize := SolveForX(PercentDone(FSPValue, FSPLo, FSPHi), W);
    if FillSize > W then FillSize := W;
    if FillSize > 0 then FillRect(Rect(7, BarPos, 5+FillSize, BarPos+BarHeight));
    BarPos:=BarPos+BarHeight+6;
  // OPBar
    Brush.Color := clOlive;
    if FPulse then
    begin
      FillSize := SolveForX(PercentDone(FOPValue, FOPLo, FOPHi), W-20);
      if FillSize > W-20 then FillSize := W-20;
      if FillSize > 0 then FillRect(Rect(17, BarPos, 15+FillSize, BarPos+BarHeight));
    end
    else
    begin
      FillSize := SolveForX(PercentDone(FOPValue, FOPLo, FOPHi), W);
      if FillSize > W then FillSize := W;
      if FillSize > 0 then FillRect(Rect(7, BarPos, 5+FillSize, BarPos+BarHeight));
    end;
    Brush.Style := bsClear;
    Font:=Self.Font;
  // PVValue
    BarPos:=28;
    BarHeight:=BarHeight+2;
    H:=BarHeight;
    S:=Trim(Format(FormatPV, [FPVValue]));
    if WorkActive then
      Font.Color := DFColor;
    //else                         // коммент 08.10.14
    //  Font.Color := clBlue;      // коммент 08.10.14
    if Length(S) > 8 then S:=Trim(Format('%g',[FPVValue]));
    X := 6+(W + 1 - TextWidth(S)) div 2;
    Y := BarPos+(H + 1 - TextHeight(S)) div 2;
    TextRect(Rect(6, BarPos, Width-6, BarPos+BarHeight), X, Y, S);
    BarPos:=BarPos+BarHeight+4;
  // SPValue
    S:=Trim(Format(FormatPV, [FSPValue]));
    if Length(S) > 8 then S := Trim(Format('%g',[FSPValue]));
    X := 6+(W + 1 - TextWidth(S)) div 2;
    Y := BarPos+(H + 1 - TextHeight(S)) div 2;
    TextRect(Rect(6, BarPos, Width-6, BarPos+BarHeight), X, Y, S);
    BarPos:=BarPos+BarHeight+4;
  // OPValue
    S:=Format('%.1f%%', [FOPValue]);
    if Length(S) > 8 then S := Format('%g%%',[FOPValue]);
    if FPulse then
      X := 16+(W-20 + 1 - TextWidth(S)) div 2
    else
      X := 6+(W + 1 - TextWidth(S)) div 2;
    Y := BarPos+(H + 1 - TextHeight(S)) div 2;
    if FPulse then
      TextRect(Rect(16, BarPos, Width-16, BarPos+BarHeight), X, Y, S)
    else
      TextRect(Rect(6, BarPos, Width-6, BarPos+BarHeight), X, Y, S);
    Brush.Style := bsSolid;
// Рисование единиц измерения
    Pen.Color:=clBtnFace;
    Brush.Color:=clNavy;
    CR:=Rect(2,2,Width-2,13);
    Rectangle(CR);
    Brush.Style := bsClear;
    Font.Name := 'Small Fonts';
    Font.Color := clWhite;
    Font.Size := 7;
    Font.Style := [];
    DrawText(Canvas.Handle,PChar(FLinkName+' ['+FPointEU+']'), -1,
       CR,DT_SINGLELINE+DT_VCENTER+DT_CENTER);
    Font.Style := [];
    Brush.Style := bsSolid;
// Рамки выбора
    if Editing and Focused then Draw8Points(Canvas);
// При пропаже связи рисуется синяя рамка  // добавлено 08.10.14
    if not Editing and not IsLinked then   // добавлено 08.10.14
    begin                                  // добавлено 08.10.14
      Brush.Color:=clBlue;                 // добавлено 08.10.14
      FrameRect(ClientRect);               // добавлено 08.10.14
    end;                                   // добавлено 08.10.14
    if not Editing and Focused then
    begin
      Pen.Color:=clAqua;
      Brush.Style:=bsClear;
      Rectangle(ClientRect);
      Brush.Style:=bsSolid;
      Pen.Style:=psSolid;
    end;
  end;
end;

procedure TDinKontur.SaveToStream(Stream: TStream);
begin
  Body.DinType:=DinType;
  Body.PtName:=PtName;
  Body.Font.Name:=Font.Name;
  Body.Font.Color:=Font.Color;
  Body.Font.CharSet:=Font.Charset;
  Body.Font.Size:=Font.Size;
  Body.Font.Style:=Font.Style;
  Body.Left:=Left;
  Body.Top:=Top;
  Body.Width:=Width;
  Body.Height:=Height;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

procedure TDinKontur.SetPtName(const Value: string);
begin
  if FPtName <> Value then
  begin
    FPtName := Value;
    Invalidate;
  end;
end;

function TDinKontur.ShowEditor: boolean;
var T: TEntity;
begin
  with TDinKonturEditorForm.Create(Parent) do
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
      buFont.Font.Name:=Example.Font.Name;
      buFont.Font.Style:=Example.Font.Style;
      buFont.Caption:=Example.Font.Name+', '+IntToStr(Example.Font.Size);
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

procedure TDinKontur.UpdateData(GetParamVal: TCallbackFunc);
var E: TEntity; Blink: boolean; LAlarm: TAlarm;
    CR: TCustomCntReg; LastAlarm: TAlarmState; IsChange: boolean;
begin
  IsLinked:=False;
  IsCommand:=False;
  IsTrend:=False;
  IsChange:=False;
  IsAsked:=True;
  if FPtName = '' then
  begin
    WorkActive:=False;
    FOPHi:=100.0;
    FOPLo:=0.0;
    FOPValue:=0.0;
    FSPHi:=100.0;
    FSPLo:=0.0;
    FSPValue:=0.0;
    FPVHi:=100.0;
    FPVLo:=0.0;
    FPVValue:=0.0;
    FormatPV:='------';
    DFColor:= clBlue;
    IsAsked:=True;
    FPointEU:='------';
    if Editing then
      Hint:='Контур регулирования: <>'+#13+
      Format('Смещение: %d, %d; Размер: %d, %d',[Left,Top,Width,Height])
    else
      Hint:='Нет параметра';
    if (LastDFColor <> DFColor) or First then
    begin
      First:=False;
      LastDFColor:=DFColor;
      Invalidate;
    end;
    Exit;
  end;
  LinkName:=FPtName;
  if not GetParamVal(FPtName,E,Blink) then Exit;
  LinkDesc:=E.PtDesc;
  IsLinked:=not (asNoLink in E.AlarmStatus);
  CR:=E as TCustomCntReg;
  IsCommand:=True;
  IsTrend:=True;
  IsCommand:=True;
  FPulse:=(CR.RegType = rtImpulse);
  FAlarmStatus:=CR.AlarmStatus;
  FLogged:=CR.Logged;
  WorkActive:=IsLinked;
  FOPHi:=100.0;
  FOPLo:=0.0;
  if FOPValue <> CR.OP then
  begin
    FOPValue:=CR.OP;
    IsChange:=True;
  end;
  FSPHi:=CR.SPEUHi;
  FSPLo:=CR.SPEULo;
  if FSPValue <> CR.SP then
  begin
    FSPValue:=CR.SP;
    IsChange:=True;
  end;
  FPVHi:=CR.PVEUHi;
  FPVLo:=CR.PVEULo;
  try
    if RoundTo(FPVValue,-Ord(CR.PVFormat)) <> CR.PV then
    begin
      FPVValue:=CR.PV;
      IsChange:=True;
    end;
  except
    FPVValue:=CR.PV;
  end;
  FormatPV:='%.'+IntToStr(Ord(CR.PVFormat))+'f';
  FPointEU:=CR.EUDesc;
  LAlarm:=FAlarm;
  if (asShortBadPV in CR.AlarmStatus) or
     (asOpenBadPV in CR.AlarmStatus) then FAlarm:=RS else
  if asHH in CR.AlarmStatus then FAlarm:=HH else
  if asHi in CR.AlarmStatus then FAlarm:=HI else
  if asLL in CR.AlarmStatus then FAlarm:=LL else
  if asLo in CR.AlarmStatus then FAlarm:=LO else FAlarm:=OK;
  if LAlarm <> FAlarm then
    IsChange:=True;
  if FSPLad <> TSPLad((CR.Mode and $0060) shr 5) then
  begin
    FSPLad:=TSPLad((CR.Mode and $0060) shr 5);
    IsChange:=True;
  end;
  if FKULU <> TKULU((CR.Mode and $6000) shr 13) then
  begin
    FKULU:=TKULU((CR.Mode and $6000) shr 13);
    IsChange:=True;
  end;
  if FDULad <> TDULad((CR.Mode and $0008) shr 3) then
  begin
    FDULad := TDULad((CR.Mode and $0008) shr 3);
    IsChange:=True;
  end;
  if FAURU <> TAURU((CR.Mode and $0010) shr 4) then
  begin
    FAURU := TAURU((CR.Mode and $0010) shr 4);
    IsChange:=True;
  end;
  if (asNoLink in CR.AlarmStatus) then
    DFColor:=clDefault //clBlue    // изменено 08.10.14
  else
    DFColor:=Font.Color;
  AlarmFound:=CR.GetAlarmState(LastAlarm);
  if AlarmFound then
  begin
    HasAlarm:=(LastAlarm in CR.AlarmStatus);
    HasConfirm:=(LastAlarm in CR.ConfirmStatus);
    IsAsked:=HasConfirm;
  end
  else
  begin
    HasAlarm:=False;
    HasConfirm:=True;
    IsAsked:=True;
  end;
  if LastAlarm in CR.LostAlarmStatus then
    DFColor:=ADinColor[LastAlarm,(LastAlarm in CR.AlarmStatus),
                                 (LastAlarm in CR.ConfirmStatus),Blink];
  if (LastAlarm in CR.AlarmStatus) and
     (LastAlarm <> asNoLink) then  // добавлено 08.10.14 then
    DFColor:=ADinColor[LastAlarm,(LastAlarm in CR.AlarmStatus),
                                 (LastAlarm in CR.ConfirmStatus),Blink];
  if DFColor = clNone then DFColor:=Font.Color;
  if Editing then
    Hint:='Контур регулирования: <'+E.PtName+'>'+#13+
    Format('Смещение: %d, %d; Размер: %d, %d',[Left,Top,Width,Height])
  else
    Hint:=E.PtName+' : '+E.PtDesc;
  if IsChange or (LastDFColor <> DFColor) or First or not HasConfirm or
    (LastHasAlarm <> HasAlarm) or (LastHasConfirm <> HasConfirm) then
  begin
    First:=False;
    LastDFColor:=DFColor;
    LastHasAlarm:=HasAlarm;
    LastHasConfirm:=HasConfirm;
//    BarHeight:=(Height-35) div 3;
//    BarPos:=27;
//    R:=Rect(5, BarPos, Width-5, BarPos+BarHeight);

//    BarPos:=BarPos+BarHeight+2;
//    R:=Rect(0,0,Width,Height);
//    OffsetRect(R,Left,Top);
//    InvalidateRect(Parent.Handle,@R,False);
    Invalidate;
  end;
end;

procedure TDinKonturEditorForm.FormCreate(Sender: TObject);
begin
  Example:=TDinKontur.Create(Self);
  Example.Parent:=ScrollBox;
  Fresh.Enabled:=True;
end;

procedure TDinKonturEditorForm.FormDestroy(Sender: TObject);
begin
  Fresh.Enabled:=False;
  Example.Free;
end;

procedure TDinKonturEditorForm.seWidthChange(Sender: TObject);
begin
  Example.Width:=seWidth.Value;
  if Example.Width < ScrollBox.ClientWidth then
    Example.Left:=(ScrollBox.ClientWidth-Example.Width) div 2
  else
    Example.Left:=0;
end;

procedure TDinKonturEditorForm.seHeightChange(Sender: TObject);
begin
  Example.Height:=seHeight.Value;
  if Example.Height < ScrollBox.ClientHeight then
    Example.Top:=(ScrollBox.ClientHeight-Example.Height) div 2
  else
    Example.Top:=0;
end;

procedure TDinKonturEditorForm.edPtNameClick(Sender: TObject);
var List: TStringList; T,R: TEntity; Kind: Byte;
begin
  List:=TStringList.Create;
  try
    T:=Caddy.Find(edPtName.Text);
    R:=Caddy.FirstEntity;
    while R <> nil do
    begin
      if R is TCustomCntReg then
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

procedure TDinKonturEditorForm.buFontClick(Sender: TObject);
begin
  FontDialog.Font.Assign(Example.Font);
  if FontDialog.Execute then
  begin
    Example.Font.Assign(FontDialog.Font);
    buFont.Font.Name:=Example.Font.Name;
    buFont.Font.Style:=Example.Font.Style;
    buFont.Caption:=Example.Font.Name+', '+IntToStr(Example.Font.Size);
  end;
end;

procedure TDinKonturEditorForm.FreshTimer(Sender: TObject);
begin
  Example.UpdateData(@GetParamVal);
end;

procedure TDinKonturEditorForm.Shape1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Example.Focused:=False;
end;

procedure TDinKontur.WMLeftButtonDown(var Msg: TWMMouseMove);
var E: TEntity; Blink: boolean;
begin
  inherited;
  if not Editing and (FPtName <> '') and FPulse then
  begin
    if Caddy.UserLevel = 0 then Exit;
    if not GetParamVal(FPtName,E,Blink) then Exit;
    if not Assigned(E) then Exit;
    if PtInRegion(HRLess,Msg.XPos,Msg.YPos) then
    begin
      LessActive:=True;
      Paint;
      ButtonClick(bkLessPress);
    end
    else
    if PtInRegion(HRMore,Msg.XPos,Msg.YPos) then
    begin
      MoreActive:=True;
      Paint;
      ButtonClick(bkMorePress);
    end;
  end;
end;

procedure TDinKontur.WMLeftButtonUp(var Msg: TWMMouseMove);
var E: TEntity; Blink: boolean;
begin
  inherited;
  if not Editing and FPulse and (FPtName <> '') then
  begin
    if not GetParamVal(FPtName,E,Blink) then Exit;
    if not Assigned(E) then Exit;
    if LessActive then
    begin
      LessActive:=False;
      Paint;
      ButtonClick(bkLessRelease);
    end
    else
    if MoreActive then
    begin
      MoreActive:=False;
      Paint;
      ButtonClick(bkMoreRelease);
    end;
  end;
end;

procedure TDinKontur.WMMouseMove(var Msg: TWMMouseMove);
begin
  inherited;
  if not Editing and FPulse then
  begin
    if PtInRegion(HRLess,Msg.XPos,Msg.YPos) or
       PtInRegion(HRMore,Msg.XPos,Msg.YPos) then
      Cursor:=crHandPoint
    else
      Cursor:=crDefault;
  end;
end;

procedure TDinKontur.ButtonClick(Kind: TButtonKind);
var E: TEntity; Blink: boolean;
begin
  if FPtName = '' then Exit;
  if not GetParamVal(FPtName,E,Blink) then Exit;
  case Kind of
 bkLessPress  :
    begin
      IT.Tag:=-1;
      IT.Enabled:=True;
      PostMessage(Parent.Handle,WM_DinKonturClick,THandle(E),12);
    end;
 bkLessRelease:
    begin
      IT.Tag:=0;
      IT.Enabled:=False;
      PostMessage(Parent.Handle,WM_DinKonturClick,THandle(E),14);
    end;
 bkMorePress:
    begin
      IT.Tag:=1;
      IT.Enabled:=True;
      PostMessage(Parent.Handle,WM_DinKonturClick,THandle(E),13);
    end;
 bkMoreRelease:
    begin
      IT.Tag:=0;
      IT.Enabled:=False;
      PostMessage(Parent.Handle,WM_DinKonturClick,THandle(E),14);
    end;
  end;
end;

procedure TDinKontur.ITTimer(Sender: TObject);
var E: TEntity; Blink: boolean;
begin
  IT.Enabled:=False;
  if FPtName = '' then begin IT.Tag:=0; Exit; end;
  if not GetParamVal(FPtName,E,Blink) then begin IT.Tag:=0; Exit; end;
  case IT.Tag of
   -1: PostMessage(Parent.Handle,WM_DinKonturClick,THandle(E),15);
    1: PostMessage(Parent.Handle,WM_DinKonturClick,THandle(E),16);
  end;
  IT.Tag:=0;
end;

function TDinKontur.GetDinKind: TDinKind;
var E: TEntity; Blink: boolean;
begin
  Result:=dkKonturSPMODE;
  if FPtName = '' then Exit;
  if not GetParamVal(FPtName,E,Blink) then Exit;
  with E as TCustomCntReg do
  begin
    if HasCommandSP and HasCommandOP then Result:=dkKonturSPOP;
    if HasCommandSP and HasCommandMode then Result:=dkKonturSPMODE;
    if HasCommandOP and HasCommandMode then Result:=dkKonturOPMODE;
  end;
end;

procedure TDinKontur.SaveToIniFile(MF: TMemInifile);
var SectName: string; i: integer;
begin
  i:=MF.ReadInteger('DinTypeCounts','DinKontur',0);
  Inc(i);
  MF.WriteInteger('DinTypeCounts','DinKontur',i);
  SectName:=Format('DinKontur%d',[i]);
  MF.WriteInteger(SectName,'DinType',DinType);
  MF.WriteString(SectName,'PtName',PtName);
  MF.WriteString(SectName,'FontName',Font.Name);
  MF.WriteInteger(SectName,'FontColor',Font.Color);
  MF.WriteInteger(SectName,'FontCharset',Font.Charset);
  MF.WriteInteger(SectName,'FontSize',Font.Size);
  MF.WriteBool(SectName,'FontBold',fsBold in Font.Style);
  MF.WriteBool(SectName,'FontItalic',fsItalic in Font.Style);
  MF.WriteBool(SectName,'FontUnderline',fsUnderline in Font.Style);
  MF.WriteBool(SectName,'FontStrikeOut',fsStrikeOut in Font.Style);
  MF.WriteInteger(SectName,'Left',Left);
  MF.WriteInteger(SectName,'Top',Top);
  MF.WriteInteger(SectName,'Width',Width);
  MF.WriteInteger(SectName,'Height',Height);
end;

initialization
  RegisterClass(TDinKontur);

end.
