unit RxGraph;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TGraphType = (gtPV,gtOP,gtCR);
  TRxGraph = class(TCustomControl)
  private
    Lab100: TLabel;
    Lab75: TLabel;
    Lab50: TLabel;
    Lab25: TLabel;
    Lab0: TLabel;
    FOPRAW: Double;
    FPVRAW: Double;
    FSPRAW: Double;
    FLORAW: Double;
    FHHRAW: Double;
    FLLRAW: Double;
    FHIRAW: Double;
    FGraphType: TGraphType;
    FShowHH: Boolean;
    FShowLL: Boolean;
    FShowLO: Boolean;
    FShowHI: Boolean;
    procedure WMSizeChanged(var Mess: TMessage); message WM_SIZE;
    procedure CMFontChanged(var Mess: TMessage); message CM_FONTCHANGED;
    procedure SetOPRAW(const Value: Double);
    procedure SetPVRAW(const Value: Double);
    procedure SetSPRAW(const Value: Double);
    procedure SetHHRAW(const Value: Double);
    procedure SetHIRAW(const Value: Double);
    procedure SetLLRAW(const Value: Double);
    procedure SetLORAW(const Value: Double);
    procedure SetGraphType(const Value: TGraphType);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property PVRAW: Double read FPVRAW write SetPVRAW;
    property SPRAW: Double read FSPRAW write SetSPRAW;
    property OPRAW: Double read FOPRAW write SetOPRAW;
    property HHRAW: Double read FHHRAW write SetHHRAW;
    property HIRAW: Double read FHIRAW write SetHIRAW;
    property LORAW: Double read FLORAW write SetLORAW;
    property LLRAW: Double read FLLRAW write SetLLRAW;
    property GraphType: TGraphType read FGraphType write SetGraphType default gtPV;
    property ShowHH: Boolean read FShowHH write FShowHH;
    property ShowHI: Boolean read FShowHI write FShowHI;
    property ShowLO: Boolean read FShowLO write FShowLO;
    property ShowLL: Boolean read FShowLL write FShowLL;
  published
    property Align;
    property Anchors;
    property Visible;
    property OnClick;
    property Font;
    property Color;
    property ParentFont;
    property ParentShowHint;
    property ShowHint;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('RemX Components', [TRxGraph]);
end;

{ TRxGraph }

procedure TRxGraph.CMFontChanged(var Mess: TMessage);
var W,H,SH: integer;
begin
  Canvas.Font:=Font;
  W:=Canvas.TextWidth(Lab100.Caption);
  H:=Canvas.TextHeight('Xxy');
  Lab100.Font:=Font;
  Lab100.SetBounds(0,0,W,H);
  SH:=Height-Lab100.Height;
  Lab75.Font:=Font;
  Lab75.SetBounds(0,SH div 4,W,H);
  Lab50.Font:=Font;
  Lab50.SetBounds(0,SH div 2,W,H);
  Lab25.Font:=Font;
  Lab25.SetBounds(0,3*(SH div 4),W,H);
  Lab0.Font:=Font;
  Lab0.SetBounds(0,SH,W,H);
  Invalidate;
end;

constructor TRxGraph.Create(AOwner: TComponent);
begin
  inherited;
  FGraphType:=gtPV;
  FPVRAW:=50.0;
  FSPRAW:=40.0;
  FOPRAW:=60.0;
  FHHRAW:=85.0;
  FHIRAW:=80.0;
  FLORAW:=20.0;
  FLLRAW:=15.0;
  FShowHH:=True;
  FShowHI:=True;
  FShowLO:=True;
  FShowLL:=True;
  Lab100:=TLabel.Create(Self);
  with Lab100 do
  begin
    Alignment:=taRightJustify;
    AutoSize:=False;
    SetBounds(0,0,30,16);
    Caption:='100%';
    Parent:=Self;
  end;
  Lab75:=TLabel.Create(Self);
  with Lab75 do
  begin
    Alignment:=taRightJustify;
    AutoSize:=False;
    SetBounds(0,20,30,16);
    Caption:='75%';
    Parent:=Self;
  end;
  Lab50:=TLabel.Create(Self);
  with Lab50 do
  begin
    Alignment:=taRightJustify;
    AutoSize:=False;
    SetBounds(0,40,30,16);
    Caption:='50%';
    Parent:=Self;
  end;
  Lab25:=TLabel.Create(Self);
  with Lab25 do
  begin
    Alignment:=taRightJustify;
    AutoSize:=False;
    SetBounds(0,60,30,16);
    Caption:='25%';
    Parent:=Self;
  end;
  Lab0:=TLabel.Create(Self);
  with Lab0 do
  begin
    Alignment:=taRightJustify;
    AutoSize:=False;
    SetBounds(0,80,30,16);
    Caption:='0%';
    Parent:=Self;
  end;
  Width:=100;
  Height:=100;
  DoubleBuffered:=True;
end;

destructor TRxGraph.Destroy;
begin
  inherited;
end;

procedure TRxGraph.Paint;
var Lev0,Lev25,Lev50,Lev75,Lev100,LevW,
    LevPV,WidPV,LevOP,WidOP,LevSP,
    LevHH,LevHI,LevLO,LevLL: integer;
begin
  inherited;
  Lev0:=Lab0.Top+(Lab0.Height div 2);
  Lev25:=Lab25.Top+(Lab25.Height div 2);
  Lev50:=Lab50.Top+(Lab50.Height div 2);
  Lev75:=Lab75.Top+(Lab75.Height div 2);
  Lev100:=Lab100.Top+(Lab100.Height div 2);
  LevW:=Lev0-Lev100;
  WidPV:=(Width+Lab100.Width) div 2;
  WidOP:=WidPV+15;
  Canvas.Pen.Style:=psDot;
  Canvas.Pen.Width:=1;
  Canvas.Pen.Color:=Font.Color;
  Canvas.Brush.Color:=Color;
  Canvas.Polyline([Point(Lab100.Width+5,Lev100),Point(Width-5,Lev100)]);
  Canvas.Polyline([Point(Lab100.Width+5,Lev75),Point(Width-5,Lev75)]);
  Canvas.Polyline([Point(Lab100.Width+5,Lev50),Point(Width-5,Lev50)]);
  Canvas.Polyline([Point(Lab100.Width+5,Lev25),Point(Width-5,Lev25)]);
  Canvas.Polyline([Point(Lab100.Width+5,Lev0),Point(Width-5,Lev0)]);
//=============
  if (FGraphType = gtPV) or (FGraphType = gtCR) then
  begin
    Canvas.Pen.Color:=clAqua;
    Canvas.Pen.Style:=psSolid;
    Canvas.Pen.Width:=1;
    LevPV:=Lev0-Round(LevW*FPVRAW*0.01);
    Canvas.Polyline([Point(WidPV-10,Lev0),Point(WidPV-3,Lev0),
                     Point(WidPV-3,LevPV),Point(WidPV+3,LevPV),
                     Point(WidPV+3,Lev0),Point(WidPV+10,Lev0)]);
    Canvas.Polyline([Point(WidPV-10,Lev0-1),Point(WidPV-4,Lev0-1),
                     Point(WidPV-4,LevPV-1),Point(WidPV+4,LevPV-1),
                     Point(WidPV+4,Lev0-1),Point(WidPV+10,Lev0-1)]);
  end;
  if (FGraphType = gtCR) or (FGraphType = gtOP) then
  begin
    Canvas.Pen.Style:=psSolid;
    Canvas.Pen.Width:=1;
    Canvas.Pen.Color:=clYellow;
    LevOP:=Lev0-Round(LevW*FOPRAW*0.01);
    Canvas.Polyline([Point(WidOP-5,Lev0),Point(WidOP,Lev0),
                     Point(WidOP,LevOP),Point(WidOP,LevOP),
                     Point(WidOP,Lev0),Point(WidOP+5,Lev0)]);
  end;
//=============
  if (FGraphType = gtCR) then
  begin
    Canvas.Pen.Width:=1;
    Canvas.Pen.Style:=psSolid;
    Canvas.Pen.Color:=clLime;
    Canvas.Brush.Color:=clLime;
    LevSP:=Lev0-Round(LevW*FSPRAW*0.01);
    Canvas.Polygon([Point(WidPV-5,LevSP),Point(WidPV-10,LevSP-5),
                    Point(WidPV-10,LevSP+5)]);
  end;
  if (FGraphType = gtPV) or (FGraphType = gtCR) then
  begin
    Canvas.Pen.Width:=1;
    Canvas.Pen.Style:=psSolid;
    Canvas.Pen.Color:=clOlive;
    Canvas.Brush.Color:=clOlive;
    LevHI:=Lev0-Round(LevW*FHIRAW*0.01);
    if FShowHI then
      Canvas.Polygon([Point(WidPV+5,LevHI),Point(WidPV+10,LevHI-5),Point(WidPV+10,LevHI+5)]);
    LevLO:=Lev0-Round(LevW*FLORAW*0.01);
    if FShowLO then
      Canvas.Polygon([Point(WidPV+5,LevLO),Point(WidPV+10,LevLO-5),Point(WidPV+10,LevLO+5)]);
    Canvas.Pen.Color:=clRed;
    Canvas.Brush.Color:=clRed;
    LevHH:=Lev0-Round(LevW*FHHRAW*0.01);
    if FShowHH then
      Canvas.Polygon([Point(WidPV+5,LevHH),Point(WidPV+10,LevHH-5),Point(WidPV+10,LevHH+5)]);
    LevLL:=Lev0-Round(LevW*FLLRAW*0.01);
    if FShowLL then
      Canvas.Polygon([Point(WidPV+5,LevLL),Point(WidPV+10,LevLL-5),Point(WidPV+10,LevLL+5)]);
  end;
end;

procedure TRxGraph.SetGraphType(const Value: TGraphType);
begin
  if FGraphType <> Value then
  begin
    FGraphType:=Value;
    Invalidate;
  end;
end;

procedure TRxGraph.SetHHRAW(const Value: Double);
var Wid: Integer; R: TRect;
begin
  if FHHRAW <> Value then
  begin
    if Value < -1.9 then
      FHHRAW:=-1.9
    else
      if Value > 101.9 then
        FHHRAW:=101.9
      else
       FHHRAW:=Value;
    Wid:=((Width+Lab100.Width) div 2) + 5;
    R:=Rect(Wid,0,Wid+6,Height);
    InvalidateRect(Handle,@R,True);
  end;
end;

procedure TRxGraph.SetHIRAW(const Value: Double);
var Wid: Integer; R: TRect;
begin
  if FHIRAW <> Value then
  begin
    if Value < -1.9 then
      FHIRAW:=-1.9
    else
      if Value > 101.9 then
        FHIRAW:=101.9
      else
       FHIRAW:=Value;
    Wid:=((Width+Lab100.Width) div 2) + 5;
    R:=Rect(Wid,0,Wid+6,Height);
    InvalidateRect(Handle,@R,True);
  end;
end;

procedure TRxGraph.SetLLRAW(const Value: Double);
var Wid: Integer; R: TRect;
begin
  if FLLRAW <> Value then
  begin
    if Value < -1.9 then
      FLLRAW:=-1.9
    else
      if Value > 101.9 then
        FLLRAW:=101.9
      else
       FLLRAW:=Value;
    Wid:=((Width+Lab100.Width) div 2) + 5;
    R:=Rect(Wid,0,Wid+6,Height);
    InvalidateRect(Handle,@R,True);
  end;
end;

procedure TRxGraph.SetLORAW(const Value: Double);
var Wid: Integer; R: TRect;
begin
  if FLORAW <> Value then
  begin
    if Value < -1.9 then
      FLORAW:=-1.9
    else
      if Value > 101.9 then
        FLORAW:=101.9
      else
       FLORAW:=Value;
    Wid:=((Width+Lab100.Width) div 2) + 5;
    R:=Rect(Wid,0,Wid+6,Height);
    InvalidateRect(Handle,@R,True);
  end;
end;

procedure TRxGraph.SetOPRAW(const Value: Double);
var WidOP: Integer; R: TRect;
begin
  if FOPRAW <> Value then
  begin
    if Value < -1.9 then
      FOPRAW:=-1.9
    else
      if Value > 101.9 then
        FOPRAW:=101.9
      else
        FOPRAW:=Value;
    WidOP:=((Width+Lab100.Width) div 2) + 15;
    R:=Rect(WidOP-1,0,WidOP+1,Height);
    InvalidateRect(Handle,@R,True);
  end;
end;

procedure TRxGraph.SetPVRAW(const Value: Double);
var WidPV: Integer; R: TRect;
begin
  if FPVRAW <> Value then
  begin
    if Value < -1.9 then
      FPVRAW:=-1.9
    else
      if Value > 101.9 then
        FPVRAW:=101.9
      else
        FPVRAW:=Value;
    WidPV:=(Width+Lab100.Width) div 2;
    R:=Rect(WidPV-5,0,WidPV+5,Height);
    InvalidateRect(Handle,@R,True);
  end;
end;
procedure TRxGraph.SetSPRAW(const Value: Double);
var WidSP: Integer; R: TRect;
begin
  if FSPRAW <> Value then
  begin
    if Value < -1.9 then
      FSPRAW:=-1.9
    else
      if Value > 101.9 then
        FSPRAW:=101.9
      else
        FSPRAW:=Value;
    WidSP:=((Width+Lab100.Width) div 2) - 10;
    R:=Rect(WidSP,0,WidSP+6,Height);
    InvalidateRect(Handle,@R,True);
  end;
end;

procedure TRxGraph.WMSizeChanged(var Mess: TMessage);
var H: integer;
begin
  inherited;
  H:=Height-Lab0.Height;
  Lab0.Top:=H;
  Lab25.Top:=3*(H div 4);
  Lab50.Top:=H div 2;
  Lab75.Top:=H div 4;
  Invalidate;
end;

end.
