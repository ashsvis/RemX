unit DinUnitEditorUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ExtCtrls, DinElementsUnit, ComCtrls, AppEvnts,
  Menus, ImgList, Buttons, IniFiles;

type
  TUnitOrientation = (uoLeft,uoTop,uoRight,uoBottom);
  TUnitKind = (ukCylinder,ukCone,ukTruncCone1,ukTruncCone2,ukHemisphere);
  TTerminator = 1..99;
  TDinUnit = class(TDinControl)
  private
    Body: record
            DinType: byte;
            UnitKind: TUnitKind;
            Volume: boolean;
            Solid: boolean;
            Color: TColor;
            Terminator: TTerminator;
            LightColor: TColor;
            DarkColor: TColor;
            Border: boolean;
            BorderColor: TColor;
            Orientation: TUnitOrientation;
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
    FBorder: boolean;
    FSolid: boolean;
    FVolume: boolean;
    FTerminator: TTerminator;
    FDarkColor: TColor;
    FColor: TColor;
    FLightColor: TColor;
    FBorderColor: TColor;
    FUnitKind: TUnitKind;
    FOrientation: TUnitOrientation;
    procedure SetBorder(const Value: boolean);
    procedure SetBorderColor(const Value: TColor);
    procedure SetColor(const Value: TColor);
    procedure SetOrientation(const Value: TUnitOrientation);
    procedure SetDarkColor(const Value: TColor);
    procedure SetSolid(const Value: boolean);
    procedure SetTerminator(const Value: TTerminator);
    procedure SetLightColor(const Value: TColor);
    procedure SetUnitKind(const Value: TUnitKind);
    procedure SetVolume(const Value: boolean);
  protected
    procedure Paint; override;
    procedure DrawMultyRangeColor(Canvas: TCanvas; Rect: TRect;
                 Ranges: array of Double; Colors: array of TColor);
  public
    constructor Create(AOwner: TComponent); override;
    function ShowEditor: boolean; override;
    procedure Assign(Source: TPersistent); override;
    procedure SaveToStream(Stream: TStream); override;
    procedure SaveToIniFile(MF: TMemInifile); override;
    function LoadFromStream(Stream: TStream): integer; override;
  published
    property UnitKind: TUnitKind read FUnitKind write SetUnitKind;
    property Volume: boolean read FVolume write SetVolume;
    property Solid: boolean read FSolid write SetSolid;
    property Color: TColor read FColor write SetColor;
    property Terminator: TTerminator read FTerminator write SetTerminator;
    property LightColor: TColor read FLightColor write SetLightColor;
    property DarkColor: TColor read FDarkColor write SetDarkColor;
    property Border: boolean read FBorder write SetBorder;
    property BorderColor: TColor read FBorderColor write SetBorderColor;
    property Orientation: TUnitOrientation read FOrientation write SetOrientation;
  end;

  TDinUnitEditorForm = class(TForm)
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
    GroupBox: TGroupBox;
    ScrollBox: TScrollBox;
    CloseButton: TButton;
    CancelButton: TButton;
    cbSolid: TCheckBox;
    cbBorder: TCheckBox;
    gbTerminator: TGroupBox;
    Label7: TLabel;
    Label1: TLabel;
    tbTerminator: TTrackBar;
    Label3: TLabel;
    stTerminator: TStaticText;
    cbUnitKind: TComboBox;
    btRotate: TButton;
    ApplicationEvents1: TApplicationEvents;
    ImageList1: TImageList;
    pmColorSelect: TPopupMenu;
    ColorDialog1: TColorDialog;
    btDarkColor: TBitBtn;
    btLightColor: TBitBtn;
    btColor: TBitBtn;
    btBorderColor: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure seWidthChange(Sender: TObject);
    procedure seHeightChange(Sender: TObject);
    procedure tbTerminatorChange(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure cbSolidClick(Sender: TObject);
    procedure cbBorderClick(Sender: TObject);
    procedure cbUnitKindSelect(Sender: TObject);
    procedure btRotateClick(Sender: TObject);
    procedure pmColorSelectPopup(Sender: TObject);
    procedure btColorClick(Sender: TObject);
  private
    Source,Example: TDinUnit;
    procedure UpdateButton(Btn: TBitBtn; DC: TColor);
    procedure ChangeColorClick(Sender: TObject);
    procedure CustomColorClick(Sender: TObject);
  public
  end;

var
  DinUnitEditorForm: TDinUnitEditorForm;

implementation

uses EntityUnit;

{$R *.dfm}

function CalcColor(Color1,Color2: TColor; Min,Max,Position: Double): TColor;
var Psnt: Double; R1,G1,B1,R2,G2,B2,RF,GF,BF: Byte;
begin
  if Abs(Max-Min) < 0.0001 then
    raise Exception.Create('Границы диапазона не должны быть равными!');
  Psnt:=(Position-Min)/(Max-Min);
  R1:=(Color1 and $000000FF);
  G1:=(Color1 and $0000FF00) shr 8;
  B1:=(Color1 and $00FF0000) shr 16;
  R2:=(Color2 and $000000FF);
  G2:=(Color2 and $0000FF00) shr 8;
  B2:=(Color2 and $00FF0000) shr 16;
  if R2 > R1 then
    RF:=Byte(Trunc((R2-R1)*Psnt+R1))
  else
    RF:=Byte(R1-Trunc((R1-R2)*Psnt));
  if G2 > G1 then
    GF:=Byte(Trunc((G2-G1)*Psnt+G1))
  else
    GF:=Byte(G1-Trunc((G1-G2)*Psnt));
  if B2 > B1 then
    BF:=Byte(Trunc((B2-B1)*Psnt+B1))
  else
    BF:=Byte(B1-Trunc((B1-B2)*Psnt));
  Result:=RF or (GF shl 8) or (BF shl 16);
end;

function CalcMultyRangeColor(Position: Double;
                   Ranges: array of Double; Colors: array of TColor): TColor;
var i,Len: integer;
begin
  Len:=Length(Ranges);
  if Len < 2 then
    raise Exception.Create(
    'Должен быть указано два и более элементов массива диапазонов!');
  if Len <> Length(Colors) then
    raise Exception.Create(
    'Количество элементов массива диапазонов и массива цветов должны быть одинаковыми!');
  if Position < Ranges[0] then Position:=Ranges[0];
  if Position > Ranges[Len-1] then Position:=Ranges[Len-1];
  Result:=clBlack;
  for i:=1 to Len-1 do
  if (Position >= Ranges[i-1]) and
     (Position <= Ranges[i]) then
  begin
    Result:=CalcColor(Colors[i-1],Colors[i],Ranges[i-1],Ranges[i],Position);
    Exit;
  end;
end;

procedure TDinUnitEditorForm.FormCreate(Sender: TObject);
var DC: TDinColor; B: TBitmap;
begin
  B:=TBitmap.Create;
  try
    B.Width:=ImageList1.Width;
    B.Height:=ImageList1.Height;
    for DC:=Low(StringDinColor) to High(StringDinColor) do
    begin
      B.Canvas.Brush.Color:=ArrayDinColor[DC];
      B.Canvas.Pen.Color:=clBlack;
      B.Canvas.Rectangle(Rect(0,0,B.Width,B.Height));
      ImageList1.Add(B,nil);
    end;
  finally
    B.Free;
  end;
  Example:=TDinUnit.Create(Self);
  Example.Parent:=ScrollBox;
end;

procedure TDinUnitEditorForm.FormDestroy(Sender: TObject);
begin
  Example.Free;
end;

procedure TDinUnitEditorForm.seWidthChange(Sender: TObject);
begin
  Example.Width:=seWidth.Value;
  if Example.Width < ScrollBox.ClientWidth then
    Example.Left:=(ScrollBox.ClientWidth-Example.Width) div 2
  else
    Example.Left:=0;
end;

procedure TDinUnitEditorForm.seHeightChange(Sender: TObject);
begin
  Example.Height:=seHeight.Value;
  if Example.Height < ScrollBox.ClientHeight then
    Example.Top:=(ScrollBox.ClientHeight-Example.Height) div 2
  else
    Example.Top:=0;
end;

{ TDinUnit }

procedure TDinUnit.Assign(Source: TPersistent);
var C: TDinUnit;
begin
  inherited;
  C:=Source as TDinUnit;
  FBorder:=C.Border;
  FSolid:=C.Solid;
  FVolume:=C.Volume;
  FTerminator:=C.Terminator;
  FDarkColor:=C.DarkColor;
  FColor:=C.Color;
  FLightColor:=C.LightColor;
  FBorderColor:=C.BorderColor;
  FUnitKind:=C.UnitKind;
  FOrientation:=C.Orientation;
end;

constructor TDinUnit.Create(AOwner: TComponent);
begin
  inherited;
  Width:=75;
  Height:=75;
  FDinKind:=dkInfo;
  FTerminator:=30;
  FLightColor:=clCream;
  FDarkColor:=clBlack;
  FOrientation:=uoTop;
end;

function TDinUnit.LoadFromStream(Stream: TStream): integer;
begin
  Result:=SizeOf(Body);
  if (Stream.Size-Stream.Position) < Result then
  begin
    Result:=0;
    Exit;
  end;
  Stream.ReadBuffer(Body,Result);
  FSolid:=Body.Solid;
  FColor:=Body.Color;
  FBorder:=Body.Border;
  FBorderColor:=Body.BorderColor;
  FTerminator:=Body.Terminator;
  FDarkColor:=Body.DarkColor;
  FLightColor:=Body.LightColor;
  FUnitKind:=Body.UnitKind;
  FVolume:=Body.Volume;
  FOrientation:=Body.Orientation;
  SetBounds(Body.Left,Body.Top,Body.Width,Body.Height);
end;

procedure TDinUnit.DrawMultyRangeColor(Canvas: TCanvas; Rect: TRect;
  Ranges: array of Double; Colors: array of TColor);
var i,j,Len,MidPoint,TabPos,MidPointFirst,TruncFactor: integer;
    Position,Step: Double;
    TP,TP1,TP2,MPZ,MP,MP1,MP2,TF,TF1,TF2,W: integer;
begin
  Len:=Length(Ranges);
  if Len < 2 then
    raise Exception.Create(
    'Должен быть указано два и более элементов массива диапазонов!');
  if Len <> Length(Colors) then
    raise Exception.Create(
    'Количество элементов массива диапазонов и массива цветов должны быть одинаковыми!');
  if (Rect.Left = Rect.Right) or
     (Rect.Top = Rect.Bottom) then
    raise Exception.Create('Заданный прямоугольник пуст!');
  case FUnitKind of
ukCylinder:
  begin
    case FOrientation of
     uoTop,uoBottom: Step:=(Ranges[Len-1]-Ranges[0])/(Rect.Right-Rect.Left);
    else
      Step:=(Ranges[Len-1]-Ranges[0])/(Rect.Bottom-Rect.Top);
    end;
    Position:=Ranges[0];
    case FOrientation of
    uoTop,uoBottom:
      begin
         for i:=Rect.Left to Rect.Right do
         begin
           for j:=1 to Length(Ranges)-1 do
           if (Position >= Ranges[j-1]) and
              (Position <= Ranges[j]) then
           begin
             Canvas.Pen.Color:=CalcColor(Colors[j-1],Colors[j],
                               Ranges[j-1],Ranges[j],Position);
             Canvas.PolyLine([Point(i,Rect.Top),Point(i,Rect.Bottom)]);
             Break;
           end;
           Position:=Position+Step;
         end;
         if FBorder then
         begin
           Canvas.Pen.Color := FBorderColor;
           Canvas.PolyLine([Point(Rect.Left,Rect.Top),Point(Rect.Right,Rect.Top)]);
           Canvas.PolyLine([Point(Rect.Left,Rect.Bottom-1),Point(Rect.Right,Rect.Bottom-1)]);
         end;
       end;
   uoLeft,uoRight:
       begin
         for i:=Rect.Top to Rect.Bottom do
         begin
           for j:=1 to Length(Ranges)-1 do
           if (Position >= Ranges[j-1]) and
              (Position <= Ranges[j]) then
           begin
             Canvas.Pen.Color:=CalcColor(Colors[j-1],Colors[j],
                               Ranges[j-1],Ranges[j],Position);
             Canvas.PolyLine([Point(Rect.Left,i),Point(Rect.Right,i)]);
             Break;
           end;
           Position:=Position+Step;
         end;
         if FBorder then
         begin
           Canvas.Pen.Color := FBorderColor;
           Canvas.PolyLine([Point(Rect.Left,Rect.Top),Point(Rect.Left,Rect.Bottom)]);
           Canvas.PolyLine([Point(Rect.Right-1,Rect.Top),Point(Rect.Right-1,Rect.Bottom)]);
         end;
       end;
    end;
  end;
ukCone:
  begin
    case FOrientation of
     uoTop,uoBottom: begin
            Step:=(Ranges[Len-1]-Ranges[0])/(Rect.Right-Rect.Left);
            MidPoint:=((Rect.Right-Rect.Left) div 2) + Rect.Left;
          end;
    else
      begin
        Step:=(Ranges[Len-1]-Ranges[0])/(Rect.Bottom-Rect.Top);
        MidPoint:=((Rect.Bottom-Rect.Top) div 2) + Rect.Top;
      end;
    end;
    Position:=Ranges[0];
    case FOrientation of
      uoTop,uoBottom:
         for i:=Rect.Left to Rect.Right do
         begin
           for j:=1 to Length(Ranges)-1 do
           if (Position >= Ranges[j-1]) and
              (Position <= Ranges[j]) then
           begin
             Canvas.Pen.Color:=CalcColor(Colors[j-1],Colors[j],
                               Ranges[j-1],Ranges[j],Position);
             if FOrientation = uoTop then
               Canvas.PolyLine([Point(MidPoint,Rect.Top),Point(i,Rect.Bottom)])
             else
               Canvas.PolyLine([Point(i,Rect.Top),Point(MidPoint,Rect.Bottom)]);
             Break;
           end;
           Position:=Position+Step;
         end;
      uoLeft,uoRight:
         for i:=Rect.Top to Rect.Bottom do
         begin
           for j:=1 to Length(Ranges)-1 do
           if (Position >= Ranges[j-1]) and
              (Position <= Ranges[j]) then
           begin
             Canvas.Pen.Color:=CalcColor(Colors[j-1],Colors[j],
                               Ranges[j-1],Ranges[j],Position);
             if FOrientation = uoLeft then
               Canvas.PolyLine([Point(Rect.Left,i),Point(Rect.Right,MidPoint)])
             else
               Canvas.PolyLine([Point(Rect.Left,MidPoint),Point(Rect.Right,i)]);
             Break;
           end;
           Position:=Position+Step;
         end;
    end;
    if FBorder then
    begin
      Canvas.Pen.Color := FBorderColor;
      case FOrientation of
     uoLeft: Canvas.PolyLine([Point(Rect.Left,Rect.Top),Point(Rect.Left,Rect.Bottom)]);
      uoTop: Canvas.PolyLine([Point(Rect.Left,Rect.Bottom-1),Point(Rect.Right,Rect.Bottom-1)]);
    uoRight: Canvas.PolyLine([Point(Rect.Right-1,Rect.Top),Point(Rect.Right-1,Rect.Bottom)]);
   uoBottom: Canvas.PolyLine([Point(Rect.Left,Rect.Top),Point(Rect.Right,Rect.Top)]);
      end;
    end;
  end;
ukTruncCone1, ukTruncCone2:
  begin
    if FUnitKind = ukTruncCone1 then
      TruncFactor:=2
    else
      TruncFactor:=4;
    case FOrientation of
 uoTop,uoBottom: begin
            Step := (Ranges[Len-1]-Ranges[0])/(Rect.Right-Rect.Left);
            TabPos := (Rect.Right-Rect.Left) div (2*TruncFactor);
            MidPoint := Rect.Left + TabPos;
          end;
    else
      begin
        Step := (Ranges[Len-1]-Ranges[0])/(Rect.Bottom-Rect.Top);
        TabPos := (Rect.Bottom-Rect.Top) div (2*TruncFactor);
        MidPoint := Rect.Bottom - TabPos;
      end;
    end;
    MidPointFirst := MidPoint;
    Position := Ranges[0];
    case FOrientation of
 uoTop,uoBottom:
         for i := Rect.Left to Rect.Right do
         begin
           for j := 1 to Length(Ranges)-1 do
           if (Position >= Ranges[j-1]) and
              (Position <= Ranges[j]) then
           begin
             Canvas.Pen.Color := CalcColor(Colors[j-1],Colors[j],
                                 Ranges[j-1],Ranges[j],Position);
             if FOrientation = uoTop then
               Canvas.PolyLine([Point(MidPoint,Rect.Top),Point(i,Rect.Bottom)])
             else
               Canvas.PolyLine([Point(i,Rect.Top),Point(MidPoint,Rect.Bottom)]);
             if (i mod TruncFactor) > 0 then Inc(MidPoint);
             Break;
           end;
           Position := Position+Step;
         end;
 uoLeft,uoRight:
         for i := Rect.Bottom downto Rect.Top do
         begin
           for j := 1 to Length(Ranges)-1 do
           if (Position >= Ranges[j-1]) and
              (Position <= Ranges[j]) then
           begin
             Canvas.Pen.Color := CalcColor(Colors[j-1],Colors[j],
                               Ranges[j-1],Ranges[j],Position);
             if FOrientation = uoLeft then
               Canvas.PolyLine([Point(Rect.Left,i),Point(Rect.Right,MidPoint)])
             else
               Canvas.PolyLine([Point(Rect.Left,MidPoint),Point(Rect.Right,i)]);
             if (i mod TruncFactor) > 0 then Dec(MidPoint);
             Break;
           end;
           Position := Position+Step;
         end;
    end;
    if FBorder then
    begin
      Canvas.Pen.Color := FBorderColor;
      case FOrientation of
     uoLeft: begin
          Canvas.PolyLine([Point(Rect.Left,Rect.Top),Point(Rect.Left,Rect.Bottom)]);
          Canvas.PolyLine([Point(Rect.Right-1,MidPointFirst),
                           Point(Rect.Right-1,MidPoint)]);
        end;
      uoTop: begin
          Canvas.PolyLine([Point(Rect.Left,Rect.Bottom-1),Point(Rect.Right,Rect.Bottom-1)]);
          Canvas.PolyLine([Point(MidPoint,Rect.Top),
                           Point(MidPointFirst,Rect.Top)]);
        end;
    uoRight: begin
          Canvas.PolyLine([Point(Rect.Right-1,Rect.Top),Point(Rect.Right-1,Rect.Bottom)]);
          Canvas.PolyLine([Point(Rect.Left,MidPointFirst),
                           Point(Rect.Left,MidPoint)]);
        end;
   uoBottom: begin
          Canvas.PolyLine([Point(Rect.Left,Rect.Top),Point(Rect.Right,Rect.Top)]);
          Canvas.PolyLine([Point(MidPoint,Rect.Bottom-1),
                           Point(MidPointFirst,Rect.Bottom-1)]);
        end;
      end;
    end;
  end;
ukHemisphere:
  begin
    TF := 2;
    TF1 := 4;
    TF2 := 14;
    case FOrientation of
     uoTop,uoBottom: begin
            W := Rect.Right-Rect.Left;
            Step := (Ranges[Len-1]-Ranges[0])/W;
            MPZ :=Rect.Left + (W div 2);
            TP := W div (2*TF);
            MP := Rect.Left + TP;
            TP1 := W div (2*TF1);
            MP1 := Rect.Left + TP1;
            TP2 := W div (2*TF2);
            MP2 := Rect.Left + TP2;
          end;
    else
      begin
        W := Rect.Bottom-Rect.Top;
        Step := (Ranges[Len-1]-Ranges[0])/W;
        MPZ :=Rect.Top + (W div 2);
        TP := W div (2*TF);
        MP := Rect.Bottom - TP;
        TP1 := W div (2*TF1);
        MP1 := Rect.Bottom - TP1;
        TP2 := W div (2*TF2);
        MP2 := Rect.Bottom - TP2;
      end;
    end;
    Position := Ranges[0];
    case FOrientation of
      uoTop,uoBottom:
         for i := Rect.Left to Rect.Right do
         begin
           for j := 1 to Length(Ranges)-1 do
           if (Position >= Ranges[j-1]) and
              (Position <= Ranges[j]) then
           begin
             Canvas.Pen.Color := CalcColor(Colors[j-1],Colors[j],
                                 Ranges[j-1],Ranges[j],Position);
             W:=Rect.Bottom-Rect.Top;
             if FOrientation = uoBottom then
             begin
               Canvas.PolyLine([Point(i,Rect.Top),
                                Point(MP2,Rect.Top+(W div 3)),
                                Point(MP1,Rect.Top+2*(W div 3)),
                                Point(MP,Rect.Bottom-(W div 8)),
                                Point(MPZ,Rect.Bottom-1)]);
               if FBorder then
               begin
                 Canvas.Pen.Color := FBorderColor;
                 Canvas.PolyLine([Point(Rect.Left,Rect.Top),
                                  Point(Rect.Right,Rect.Top)]);
               end;
             end
             else
             begin
               Canvas.PolyLine([Point(MPZ,Rect.Top),
                                Point(MP,Rect.Top+(W div 8)),
                                Point(MP1,Rect.Top+(W div 3)),
                                Point(MP2,Rect.Top+2*(W div 3)),
                                Point(i,Rect.Bottom-1)]);
               if FBorder then
               begin
                 Canvas.Pen.Color := FBorderColor;
                 Canvas.PolyLine([Point(Rect.Left,Rect.Bottom-1),
                                  Point(Rect.Right,Rect.Bottom-1)]);
               end;
             end;
             if (i mod TF) > 0 then Inc(MP);
             if (i mod TF1) > 0 then Inc(MP1);
             if (i mod TF2) > 0 then Inc(MP2);
             Break;
           end;
           Position := Position+Step;
         end;
      uoLeft,uoRight:
         for i := Rect.Bottom downto Rect.Top do
         begin
           for j := 1 to Length(Ranges)-1 do
           if (Position >= Ranges[j-1]) and
              (Position <= Ranges[j]) then
           begin
             Canvas.Pen.Color := CalcColor(Colors[j-1],Colors[j],
                               Ranges[j-1],Ranges[j],Position);
             W:=Rect.Right-Rect.Left;
             if FOrientation = uoRight then
               Canvas.PolyLine([Point(Rect.Left,MPZ),
                                Point(Rect.Left+(W div 8),MP),
                                Point(Rect.Left+(W div 3),MP1),
                                Point(Rect.Left+2*(W div 3),MP2),
                                Point(Rect.Right,i)])
             else
               Canvas.PolyLine([Point(Rect.Left,i),
                                Point(Rect.Left+(W div 3),MP2),
                                Point(Rect.Left+2*(W div 3),MP1),
                                Point(Rect.Right-(W div 8),MP),
                                Point(Rect.Right-1,MPZ)]);
             if (i mod TF) > 0 then Dec(MP);
             if (i mod TF1) > 0 then Dec(MP1);
             if (i mod TF2) > 0 then Dec(MP2);
             Break;
           end;
           Position := Position+Step;
         end;
    end;
  end;
  end; // case
end;

procedure TDinUnit.Paint;
var Cash: TCanvas;
begin
  Cash:=Canvas;
  if FSolid then
  begin
    Cash.Brush.Color:=Color;
    Cash.FillRect(ClientRect);
  end;
  DrawMultyRangeColor(Cash,ClientRect,[0.0,FTerminator*1.0,100.0],
                      [FDarkColor,FLightColor,FDarkColor]);
  if Editing and Focused then Draw8Points(Cash);
end;

procedure TDinUnit.SaveToStream(Stream: TStream);
begin
  Body.DinType:=DinType;
  Body.Border:=Border;
  Body.Solid:=Solid;
  Body.Volume:=Volume;
  Body.Terminator:=Terminator;
  Body.DarkColor:=DarkColor;
  Body.Color:=Color;
  Body.LightColor:=LightColor;
  Body.BorderColor:=BorderColor;
  Body.UnitKind:=UnitKind;
  Body.Orientation:=Orientation;
  Body.Left:=Left;
  Body.Top:=Top;
  Body.Width:=Width;
  Body.Height:=Height;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

procedure TDinUnit.SetBorder(const Value: boolean);
begin
  FBorder := Value;
  Invalidate;
end;

procedure TDinUnit.SetBorderColor(const Value: TColor);
begin
  FBorderColor := Value;
  Invalidate;
end;

procedure TDinUnit.SetColor(const Value: TColor);
begin
  FColor := Value;
  Invalidate;
end;

procedure TDinUnit.SetOrientation(const Value: TUnitOrientation);
begin
  FOrientation := Value;
  Invalidate;
end;

procedure TDinUnit.SetDarkColor(const Value: TColor);
begin
  FDarkColor := Value;
  Invalidate;
end;

procedure TDinUnit.SetSolid(const Value: boolean);
begin
  FSolid := Value;
  Invalidate;
end;

procedure TDinUnit.SetTerminator(const Value: TTerminator);
begin
  FTerminator := Value;
  Invalidate;
end;

procedure TDinUnit.SetLightColor(const Value: TColor);
begin
  FLightColor := Value;
  Invalidate;
end;

procedure TDinUnit.SetUnitKind(const Value: TUnitKind);
begin
  FUnitKind := Value;
  Invalidate;
end;

procedure TDinUnit.SetVolume(const Value: boolean);
begin
  FVolume := Value;
  Invalidate;
end;

function TDinUnit.ShowEditor: boolean;
begin
  with TDinUnitEditorForm.Create(Parent) do
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
    cbSolid.OnClick:=nil;
    cbBorder.OnClick:=nil;
    try
      seWidth.MaxValue:=PanelWidth-Example.Left;
      seWidth.Value:=Example.Width;
      seHeight.MaxValue:=PanelHeight-Example.Top;
      seHeight.Value:=Example.Height;
      cbUnitKind.ItemIndex:=Ord(Example.UnitKind);
      cbSolid.Checked:=Example.Solid;
      UpdateButton(btColor,Example.Color);
      cbBorder.Checked:=Example.Border;
      UpdateButton(btBorderColor,Example.BorderColor);
      tbTerminator.Position:=Ord(Example.Terminator);
      UpdateButton(btDarkColor,Example.DarkColor);
      UpdateButton(btLightColor,Example.LightColor);
    finally
      seWidth.OnChange:=seWidthChange;
      seHeight.OnChange:=seHeightChange;
      cbSolid.OnClick:=cbSolidClick;
      cbBorder.OnClick:=cbBorderClick;
    end;
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

procedure TDinUnitEditorForm.tbTerminatorChange(Sender: TObject);
begin
  stTerminator.Caption:=Format('%d%%',[tbTerminator.Position]);
  Example.Terminator:=TTerminator(tbTerminator.Position);
end;

procedure TDinUnitEditorForm.ApplicationEvents1Idle(Sender: TObject;
  var Done: Boolean);
begin
  btColor.Enabled:=cbSolid.Checked;
  btBorderColor.Enabled:=cbBorder.Checked;
end;

procedure TDinUnitEditorForm.cbSolidClick(Sender: TObject);
begin
  Example.Solid:=cbSolid.Checked;
end;

procedure TDinUnitEditorForm.cbBorderClick(Sender: TObject);
begin
  Example.Border:=cbBorder.Checked;
end;

procedure TDinUnitEditorForm.cbUnitKindSelect(Sender: TObject);
begin
  Example.UnitKind:=TUnitKind(cbUnitKind.ItemIndex);
end;

procedure TDinUnitEditorForm.btRotateClick(Sender: TObject);
begin
  if Example.Orientation = High(Example.Orientation) then
    Example.Orientation:=Low(Example.Orientation)
  else
    Example.Orientation:=Succ(Example.Orientation);
end;

procedure TDinUnitEditorForm.pmColorSelectPopup(Sender: TObject);
var DC: TDinColor; M: TMenuItem;
begin
  pmColorSelect.Items.Clear;
  M:=TMenuItem.Create(Self);
  M.Caption:='Выбрать...';
  M.ImageIndex:=-1;
  M.OnClick:=CustomColorClick;
  pmColorSelect.Items.Add(M);
  for DC:=Low(StringDinColor) to High(StringDinColor) do
  begin
    M:=TMenuItem.Create(Self);
    M.Caption:=StringDinColor[DC];
    M.Tag:=Ord(DC);
    M.OnClick:=ChangeColorClick;
    M.ImageIndex:=Ord(DC);
    pmColorSelect.Items.Add(M);
  end;
end;

procedure TDinUnitEditorForm.ChangeColorClick(Sender: TObject);
var Btn: TBitBtn; DC: TDinColor;
begin
  DC:=TDinColor((Sender as TMenuItem).Tag);
  Btn:=TBitBtn(pmColorSelect.Tag);
  UpdateButton(Btn,ArrayDinColor[DC]);
  if Btn = btColor then Example.Color:=ArrayDinColor[DC];
  if Btn = btBorderColor then Example.BorderColor:=ArrayDinColor[DC];
  if Btn = btDarkColor then Example.DarkColor:=ArrayDinColor[DC];
  if Btn = btLightColor then Example.LightColor:=ArrayDinColor[DC];
end;

procedure TDinUnitEditorForm.CustomColorClick(Sender: TObject);
var Btn: TBitBtn;
begin
  Btn:=TBitBtn(pmColorSelect.Tag);
  ColorDialog1.Color:=TColor(Btn.Tag);
  if ColorDialog1.Execute then
  begin
    if Btn = btColor then Example.Color:=ColorDialog1.Color;
    if Btn = btBorderColor then Example.BorderColor:=ColorDialog1.Color;
    if Btn = btDarkColor then Example.DarkColor:=ColorDialog1.Color;
    if Btn = btLightColor then Example.LightColor:=ColorDialog1.Color;
    UpdateButton(Btn,ColorDialog1.Color);
  end;
end;

procedure TDinUnitEditorForm.UpdateButton(Btn: TBitBtn; DC: TColor);
var B: TBitmap; i: TDinColor; S: string;
begin
  B:=TBitmap.Create;
  try
    B.Width:=16;
    B.Height:=16;
    B.Canvas.Brush.Color:=DC;
    B.Canvas.Pen.Color:=$00282828;
    B.Canvas.Rectangle(Rect(1,1,B.Width-1,B.Height-1));
    S:='Другой...';
    for i:=Low(ArrayDinColor) to High(ArrayDinColor) do
    if ArrayDinColor[i] = DC then
    begin
      S:=StringDinColor[i];
      Break;
    end;
    Btn.Caption:=S;
    Btn.Glyph.Assign(B);
    Btn.Tag:=Integer(DC);
  finally
    B.Free;
  end;
end;

procedure TDinUnitEditorForm.btColorClick(Sender: TObject);
var P: TPoint;
begin
  pmColorSelect.Tag:=Integer(Sender);
  with Sender as TBitBtn do
  begin
    P:=Self.ClientToScreen(Point(Left+Parent.Left,Top+Height+Parent.Top));
    pmColorSelect.Popup(P.X,P.Y);
  end;
end;

procedure TDinUnit.SaveToIniFile(MF: TMemInifile);
var SectName: string; i: integer;
begin
  i:=MF.ReadInteger('DinTypeCounts','DinUnit',0);
  Inc(i);
  MF.WriteInteger('DinTypeCounts','DinUnit',i);
  SectName:=Format('DinUnit%d',[i]);
  MF.WriteInteger(SectName,'DinType',DinType);
  MF.WriteBool(SectName,'Border',Border);
  MF.WriteBool(SectName,'Solid',Solid);
  MF.WriteBool(SectName,'Volume',Volume);
  MF.WriteInteger(SectName,'DinType',DinType);
  MF.WriteInteger(SectName,'Terminator',Terminator);
  MF.WriteInteger(SectName,'DarkColor',DarkColor);
  MF.WriteInteger(SectName,'Color',Color);
  MF.WriteInteger(SectName,'LightColor',LightColor);
  MF.WriteInteger(SectName,'BorderColor',BorderColor);
  MF.WriteInteger(SectName,'UnitKind',Ord(UnitKind));
  MF.WriteInteger(SectName,'Orientation',Ord(Orientation));
  MF.WriteInteger(SectName,'Left',Left);
  MF.WriteInteger(SectName,'Top',Top);
  MF.WriteInteger(SectName,'Width',Width);
  MF.WriteInteger(SectName,'Height',Height);
end;

initialization
  RegisterClass(TDinUnit);

end.
