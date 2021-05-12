unit DinLineEditorUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Spin, EntityUnit, DinElementsUnit, AppEvnts,
  ComCtrls, Menus, ImgList, Buttons, IniFiles;

type
  TDinLine = class(TDinControl)
  private
    Body: record
            DinType: byte;
            PtName: string[10];
            Color: TColor;
            Color0: TColor;
            Color1: TColor;
            LineWidth: Byte;
            LineWidth0: Byte;
            LineWidth1: Byte;
            LineStyle: TPenStyle;
            LineStyle0: TPenStyle;
            LineStyle1: TPenStyle;
            LineKind: Byte;
            BaseColor: boolean;
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
    LastState: Boolean;
    LastLinked: Boolean;
    FPtName,LastPtName: string;
    FColor: TColor;
    FColor0: TColor;
    FColor1: TColor;
    FLineWidth0: Byte;
    FLineWidth1: Byte;
    FLineKind: Byte;
    FLineWidth: Byte;
    FLineStyle: TPenStyle;
    FLineStyle1: TPenStyle;
    FLineStyle0: TPenStyle;
    FBaseColor: Boolean;
    procedure SetColor(const Value: TColor);
    procedure SetColor0(const Value: TColor);
    procedure SetColor1(const Value: TColor);
    procedure SetPtName(const Value: string);
    procedure SetLineKind(const Value: Byte);
    procedure SetLineStyle(const Value: TPenStyle);
    procedure SetLineStyle0(const Value: TPenStyle);
    procedure SetLineStyle1(const Value: TPenStyle);
    procedure SetLineWidth(const Value: Byte);
    procedure SetLineWidth0(const Value: Byte);
    procedure SetLineWidth1(const Value: Byte);
    procedure SetBaseColor(const Value: boolean);
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
    property Color: TColor read FColor write SetColor;
    property Color0: TColor read FColor0 write SetColor0;
    property Color1: TColor read FColor1 write SetColor1;
    property LineWidth: Byte read FLineWidth write SetLineWidth;
    property LineWidth0: Byte read FLineWidth0 write SetLineWidth0;
    property LineWidth1: Byte read FLineWidth1 write SetLineWidth1;
    property LineStyle: TPenStyle read FLineStyle write SetLineStyle;
    property LineStyle0: TPenStyle read FLineStyle0 write SetLineStyle0;
    property LineStyle1: TPenStyle read FLineStyle1 write SetLineStyle1;
    property LineKind: Byte read FLineKind write SetLineKind;
    property BaseColor: Boolean read FBaseColor write SetBaseColor;
  end;

  TDinLineEditorForm = class(TForm)
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
    CloseButton: TButton;
    CancelButton: TButton;
    Label11: TLabel;
    edPtName: TEdit;
    ApplicationEvents: TApplicationEvents;
    Fresh: TTimer;
    Label9: TLabel;
    LineKind: TComboBox;
    cbBaseColor: TCheckBox;
    GroupBox3: TGroupBox;
    Label13: TLabel;
    LineWidth: TSpinEdit;
    Label10: TLabel;
    LineStyle: TComboBox;
    Label12: TLabel;
    GroupBox4: TGroupBox;
    Label1: TLabel;
    LineWidth0: TSpinEdit;
    Label3: TLabel;
    LineStyle0: TComboBox;
    Label7: TLabel;
    GroupBox5: TGroupBox;
    Label8: TLabel;
    LineWidth1: TSpinEdit;
    Label14: TLabel;
    LineStyle1: TComboBox;
    Label15: TLabel;
    GroupBox: TGroupBox;
    ScrollBox: TScrollBox;
    GroupBox1: TGroupBox;
    ScrollBox0: TScrollBox;
    GroupBox2: TGroupBox;
    ScrollBox1: TScrollBox;
    ImageList1: TImageList;
    pmColorSelect: TPopupMenu;
    ColorDialog1: TColorDialog;
    btLineColor: TBitBtn;
    btLineColor0: TBitBtn;
    btLineColor1: TBitBtn;
    procedure seWidthChange(Sender: TObject);
    procedure seHeightChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edPtNameClick(Sender: TObject);
    procedure ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
    procedure Shape1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FreshTimer(Sender: TObject);
    procedure LineStyleDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure LineKindDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure LineKindSelect(Sender: TObject);
    procedure LineStyleSelect(Sender: TObject);
    procedure LineStyle0Select(Sender: TObject);
    procedure LineStyle1Select(Sender: TObject);
    procedure LineWidthChange(Sender: TObject);
    procedure LineWidth0Change(Sender: TObject);
    procedure LineWidth1Change(Sender: TObject);
    procedure cbBaseColorClick(Sender: TObject);
    procedure btLineColorClick(Sender: TObject);
    procedure pmColorSelectPopup(Sender: TObject);
  private
    SavedColor0,SavedColor1: TColor;
    Source,Example,Example0,Example1: TDinLine;
    procedure UpdateButton(Btn: TBitBtn; DC: TColor);
    procedure ChangeColorClick(Sender: TObject);
    procedure CustomColorClick(Sender: TObject);
  public
  end;

implementation

uses GetLinkNameUnit, RemXUnit;
{$R *.dfm}

procedure DrawKindLine(Canvas: TCanvas; Rect: TRect; Kind: integer;
                       Width: integer; Color: TColor; Style: TPenStyle);
begin
  Canvas.Brush.Style:=bsClear;
  Canvas.Pen.Width:=Width;
  Canvas.Pen.Style:=Style;
  Canvas.Pen.Color:=Color;
  InflateRect(Rect,-Width,-Width);
  Rect.Right:=Rect.Right-1;
  Rect.Bottom:=Rect.Bottom-1;
  case Kind of
    0: begin
         Canvas.MoveTo(Rect.Left,Rect.Top+((Rect.Bottom-Rect.Top) div 2));
         Canvas.LineTo(Rect.Right,Rect.Top+((Rect.Bottom-Rect.Top) div 2));
       end;
    1: begin
         Canvas.MoveTo(Rect.Left+((Rect.Right-Rect.Left) div 2),Rect.Top);
         Canvas.LineTo(Rect.Left+((Rect.Right-Rect.Left) div 2),Rect.Bottom);
       end;
    2: begin
         Canvas.MoveTo(Rect.Left,Rect.Bottom);
         Canvas.LineTo(Rect.Right,Rect.Top);
       end;
    3: begin
         Canvas.MoveTo(Rect.Left,Rect.Top);
         Canvas.LineTo(Rect.Right,Rect.Bottom);
       end;
    4: begin
         Canvas.MoveTo(Rect.Left,Rect.Top);
         Canvas.LineTo(Rect.Right,Rect.Top);
         Canvas.LineTo(Rect.Right,Rect.Bottom);
       end;
    5: begin
         Canvas.MoveTo(Rect.Right,Rect.Top);
         Canvas.LineTo(Rect.Right,Rect.Bottom);
         Canvas.LineTo(Rect.Left,Rect.Bottom);
       end;
    6: begin
         Canvas.MoveTo(Rect.Right,Rect.Bottom);
         Canvas.LineTo(Rect.Left,Rect.Bottom);
         Canvas.LineTo(Rect.Left,Rect.Top);
       end;
    7: begin
         Canvas.MoveTo(Rect.Left,Rect.Bottom);
         Canvas.LineTo(Rect.Left,Rect.Top);
         Canvas.LineTo(Rect.Right,Rect.Top);
       end;
    8: begin
         Canvas.MoveTo(Rect.Left,Rect.Top);
         Canvas.LineTo(Rect.Right,Rect.Top);
         Canvas.LineTo(Rect.Right,Rect.Bottom);
         Canvas.LineTo(Rect.Left,Rect.Bottom);
         Canvas.LineTo(Rect.Left,Rect.Top);
       end;
    9: begin
         Canvas.Arc(Rect.Left,Rect.Top,Rect.Right,Rect.Bottom,
                    Rect.Left,Rect.Top,Rect.Left,Rect.Top);
       end;
  end;
  Canvas.Pen.Width:=1;
end;

{ TDinLine }

procedure TDinLine.Assign(Source: TPersistent);
var C: TDinLine;
begin
  inherited;
  C:=Source as TDinLine;
  FPtName:=C.PtName;
  Font.Assign(C.Font);
  FColor:=C.Color;
  FColor0:=C.Color0;
  FColor1:=C.Color1;
  FLineWidth:=C.LineWidth;
  FLineWidth0:=C.LineWidth0;
  FLineWidth1:=C.LineWidth1;
  FLineStyle:=C.LineStyle;
  FLineStyle0:=C.LineStyle0;
  FLineStyle1:=C.LineStyle1;
  FLineKind:=C.LineKind;
  FBaseColor:=C.FBaseColor;
end;

constructor TDinLine.Create(AOwner: TComponent);
begin
  inherited;
  First:=True;
  Width:=65;
  Height:=30;
  IsLinked:=False;
  FDinKind:=dkInfo;
  Color:=clWhite;
  Color0:=clRed;
  Color1:=clLime;
  LastPtName:='';
end;

function TDinLine.LoadFromStream(Stream: TStream): integer;
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
  FColor:=Body.Color;
  FColor0:=Body.Color0;
  FColor1:=Body.Color1;
  FLineWidth:=Body.LineWidth;
  FLineWidth0:=Body.LineWidth0;
  FLineWidth1:=Body.LineWidth1;
  FLineStyle:=Body.LineStyle;
  FLineStyle0:=Body.LineStyle0;
  FLineStyle1:=Body.LineStyle1;
  FLineKind:=Body.LineKind;
  FBaseColor:=Body.BaseColor;
  SetBounds(Body.Left,Body.Top,Body.Width,Body.Height);
end;

procedure TDinLine.Paint;
var R: TRect; Cash: TCanvas;
begin
  R:=ClientRect;
  Cash:=Canvas;
// Рамки выбора
  if Editing and IsLinked then
  begin
    Cash.Pen.Color:=clSilver;
    Cash.Pen.Style:=psDash;
    Cash.Brush.Style:=bsClear;
    Cash.Rectangle(R);
    Cash.Brush.Style:=bsSolid;
    Cash.Pen.Style:=psSolid;
  end;
// Собственно, элемент
  if not IsLinked then
    DrawKindLine(Cash,R,FLineKind,FLineWidth,FColor,FLineStyle)
  else
  begin
    if State then
      DrawKindLine(Cash,R,FLineKind,FLineWidth1,FColor1,FLineStyle1)
    else
      DrawKindLine(Cash,R,FLineKind,FLineWidth0,FColor0,FLineStyle0);
  end;
  Cash.Pen.Style:=psSolid;
  if Editing and Focused then Draw8Points(Cash);
end;

procedure TDinLine.SaveToIniFile(MF: TMemInifile);
var SectName: string; i: integer;
begin
  i:=MF.ReadInteger('DinTypeCounts','DinLine',0);
  Inc(i);
  MF.WriteInteger('DinTypeCounts','DinLine',i);
  SectName:=Format('DinLine%d',[i]);
  MF.WriteInteger(SectName,'DinType',DinType);
  MF.WriteString(SectName,'PtName',PtName);
  MF.WriteInteger(SectName,'Color',Color);
  MF.WriteInteger(SectName,'Color0',Color0);
  MF.WriteInteger(SectName,'Color1',Color1);
  MF.WriteInteger(SectName,'LineWidth',LineWidth);
  MF.WriteInteger(SectName,'LineWidth0',LineWidth0);
  MF.WriteInteger(SectName,'LineWidth1',LineWidth1);
  MF.WriteInteger(SectName,'LineStyle',Ord(LineStyle));
  MF.WriteInteger(SectName,'LineStyle0',Ord(LineStyle0));
  MF.WriteInteger(SectName,'LineStyle1',Ord(LineStyle1));
  MF.WriteInteger(SectName,'LineKind',LineKind);
  MF.WriteBool(SectName,'BaseColor',BaseColor);
  MF.WriteInteger(SectName,'Left',Left);
  MF.WriteInteger(SectName,'Top',Top);
  MF.WriteInteger(SectName,'Width',Width);
  MF.WriteInteger(SectName,'Height',Height);
end;

procedure TDinLine.SaveToStream(Stream: TStream);
begin
  Body.DinType:=DinType;
  Body.PtName:=PtName;
  Body.Color:=Color;
  Body.Color0:=Color0;
  Body.Color1:=Color1;
  Body.LineWidth:=LineWidth;
  Body.LineWidth0:=LineWidth0;
  Body.LineWidth1:=LineWidth1;
  Body.LineStyle:=LineStyle;
  Body.LineStyle0:=LineStyle0;
  Body.LineStyle1:=LineStyle1;
  Body.LineKind:=LineKind;
  Body.BaseColor:=BaseColor;
  Body.Left:=Left;
  Body.Top:=Top;
  Body.Width:=Width;
  Body.Height:=Height;
  Stream.WriteBuffer(Body,SizeOf(Body));
end;

procedure TDinLine.SetBaseColor(const Value: Boolean);
begin
  if FBaseColor <> Value then
  begin
    FBaseColor := Value;
    Invalidate;
  end;
end;

procedure TDinLine.SetColor(const Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    Invalidate;
  end;
end;

procedure TDinLine.SetColor0(const Value: TColor);
begin
  if FColor0 <> Value then
  begin
    FColor0 := Value;
    Invalidate;
  end;
end;

procedure TDinLine.SetColor1(const Value: TColor);
begin
  if FColor1 <> Value then
  begin
    FColor1 := Value;
    Invalidate;
  end;
end;

procedure TDinLine.SetLineKind(const Value: Byte);
begin
  if FLineKind <> Value then
  begin
    FLineKind := Value;
    Invalidate;
  end;
end;

procedure TDinLine.SetLineStyle(const Value: TPenStyle);
begin
  if FLineStyle <> Value then
  begin
    FLineStyle := Value;
    Invalidate;
  end;
end;

procedure TDinLine.SetLineStyle0(const Value: TPenStyle);
begin
  if FLineStyle0 <> Value then
  begin
    FLineStyle0 := Value;
    Invalidate;
  end;
end;

procedure TDinLine.SetLineStyle1(const Value: TPenStyle);
begin
  if FLineStyle1 <> Value then
  begin
    FLineStyle1 := Value;
    Invalidate;
  end;
end;

procedure TDinLine.SetLineWidth(const Value: Byte);
begin
  if FLineWidth <> Value then
  begin
    FLineWidth := Value;
    Invalidate;
  end;
end;

procedure TDinLine.SetLineWidth0(const Value: Byte);
begin
  if FLineWidth0 <> Value then
  begin
    FLineWidth0 := Value;
    Invalidate;
  end;
end;

procedure TDinLine.SetLineWidth1(const Value: Byte);
begin
  if FLineWidth1 <> Value then
  begin
    FLineWidth1 := Value;
    Invalidate;
  end;
end;

procedure TDinLine.SetPtName(const Value: string);
begin
  if FPtName <> Value then
  begin
    FPtName := Value;
    Invalidate;
  end;
end;

function TDinLine.ShowEditor: boolean;
var T: TEntity;
begin
  with TDinLineEditorForm.Create(Parent) do
  try
    Source:=Self;
    ScrollBox.Color:=(Self.Parent as TBackground).Color;
    ScrollBox0.Color:=ScrollBox.Color;
    ScrollBox1.Color:=ScrollBox.Color;
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
    SavedColor0:=Example.Color0;
    SavedColor1:=Example.Color1;
    Example0.Assign(Self);
    if Example0.Width < ScrollBox0.ClientWidth then
      Example0.Left:=(ScrollBox0.ClientWidth-Example0.Width) div 2
    else
      Example0.Left:=0;
    if Example0.Height < ScrollBox0.ClientHeight then
      Example0.Top:=(ScrollBox0.ClientHeight-Example0.Height) div 2
    else
      Example0.Top:=0;
    Example1.Assign(Self);
    if Example1.Width < ScrollBox1.ClientWidth then
      Example1.Left:=(ScrollBox1.ClientWidth-Example1.Width) div 2
    else
      Example1.Left:=0;
    if Example1.Height < ScrollBox1.ClientHeight then
      Example1.Top:=(ScrollBox1.ClientHeight-Example1.Height) div 2
    else
      Example1.Top:=0;
    seWidth.OnChange:=nil;
    seHeight.OnChange:=nil;
    LineWidth.OnChange:=nil;
    LineWidth0.OnChange:=nil;
    LineWidth1.OnChange:=nil;
    cbBaseColor.OnClick:=nil;
    try
      seWidth.MaxValue:=PanelWidth-Example.Left;
      seWidth.Value:=Example.Width;
      seHeight.MaxValue:=PanelHeight-Example.Top;
      seHeight.Value:=Example.Height;
      UpdateButton(btLineColor,Example.Color);
      UpdateButton(btLineColor0,Example.Color0);
      UpdateButton(btLineColor1,Example.Color1);
      LineWidth.Value:=Example.LineWidth;
      LineWidth0.Value:=Example.LineWidth0;
      LineWidth1.Value:=Example.LineWidth1;
      LineStyle.ItemIndex:=Ord(Example.LineStyle);
      LineStyle0.ItemIndex:=Ord(Example.LineStyle0);
      LineStyle1.ItemIndex:=Ord(Example.LineStyle1);
      LineKind.ItemIndex:=Example.LineKind;
      cbBaseColor.Checked:=Example.BaseColor;
      T:=Caddy.Find(Example.PtName);
      if Assigned(T) then
        edPtName.Text:=T.PtName
      else
        edPtName.Text:='';
    finally
      seWidth.OnChange:=seWidthChange;
      seHeight.OnChange:=seHeightChange;
      LineWidth.OnChange:=LineWidthChange;
      LineWidth0.OnChange:=LineWidth0Change;
      LineWidth1.OnChange:=LineWidth1Change;
      cbBaseColor.OnClick:=cbBaseColorClick;
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

procedure TDinLine.UpdateData(GetParamVal: TCallbackFunc);
var E: TEntity; DOT: TCustomDigOut; Blink: boolean;
begin
  IsLinked:=False;
  IsCommand:=False;
  if FPtName = '' then
  begin
    if Editing then
      Hint:='Динамическая линия: <>'+#13+
        Format('Смещение: %d, %d; Размер: %d, %d',[Left,Top,Width,Height])
    else
      Hint:='';
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
  IsLinked:=True;
  DOT:=E as TCustomDigOut;
  IsLinked:=not (asNoLink in DOT.AlarmStatus);
  State:=DOT.PV;
  if FBaseColor then
  begin
    FColor0:=ArrayDigColor[DOT.ColorDown];
    FColor1:=ArrayDigColor[DOT.ColorUp];
  end;
  if Editing then
    Hint:='Динамическая линия: <'+E.PtName+'>'+#13+
         Format('Смещение: %d, %d; Размер: %d, %d',[Left,Top,Width,Height])
  else
    Hint:='';
  if (LastState <> State) or First or (LastPtName <> FPtName) or
     (LastLinked <> IsLinked) then
  begin
    First:=False;
    LastPtName:=FPtName;
    LastState:=State;
    LastLinked:=IsLinked;
    Invalidate;
  end;
end;

procedure TDinLineEditorForm.seWidthChange(Sender: TObject);
begin
  Example.Width:=seWidth.Value;
  if Example.Width < ScrollBox.ClientWidth then
    Example.Left:=(ScrollBox.ClientWidth-Example.Width) div 2
  else
    Example.Left:=0;
  Example0.Width:=seWidth.Value;
  if Example0.Width < ScrollBox0.ClientWidth then
    Example0.Left:=(ScrollBox0.ClientWidth-Example0.Width) div 2
  else
    Example0.Left:=0;
  Example1.Width:=seWidth.Value;
  if Example1.Width < ScrollBox1.ClientWidth then
    Example1.Left:=(ScrollBox1.ClientWidth-Example1.Width) div 2
  else
    Example1.Left:=0;
end;

procedure TDinLineEditorForm.seHeightChange(Sender: TObject);
begin
  Example.Height:=seHeight.Value;
  if Example.Height < ScrollBox.ClientHeight then
    Example.Top:=(ScrollBox.ClientHeight-Example.Height) div 2
  else
    Example.Top:=0;
  Example0.Height:=seHeight.Value;
  if Example0.Height < ScrollBox0.ClientHeight then
    Example0.Top:=(ScrollBox0.ClientHeight-Example0.Height) div 2
  else
    Example0.Top:=0;
  Example1.Height:=seHeight.Value;
  if Example1.Height < ScrollBox1.ClientHeight then
    Example1.Top:=(ScrollBox1.ClientHeight-Example1.Height) div 2
  else
    Example1.Top:=0;
end;

procedure TDinLineEditorForm.FormCreate(Sender: TObject);
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
  Example:=TDinLine.Create(Self);
  Example.Parent:=ScrollBox;
  Example0:=TDinLine.Create(Self);
  Example0.Parent:=ScrollBox0;
  Example1:=TDinLine.Create(Self);
  Example1.Parent:=ScrollBox1;
  Fresh.Enabled:=True;
end;

procedure TDinLineEditorForm.FormDestroy(Sender: TObject);
begin
  Fresh.Enabled:=False;
  Example.Free;
  Example0.Free;
  Example1.Free;
end;

procedure TDinLineEditorForm.edPtNameClick(Sender: TObject);
var List: TStringList; T,R: TEntity; Kind: Byte;
begin
  List:=TStringList.Create;
  try
    T:=Caddy.Find(edPtName.Text);
    R:=Caddy.FirstEntity;
    while R <> nil do
    begin
      if R.IsDigit and not R.IsParam then
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
        Example0.PtName:=Trim(edPtName.Text);
        Example1.PtName:=Trim(edPtName.Text);
      end
      else
      begin
        edPtName.Text:='';
        Example.PtName:='';
        Example0.PtName:='';
        Example1.PtName:='';
      end
    end;
  finally
    List.Free;
  end;
end;

procedure TDinLineEditorForm.ApplicationEventsIdle(Sender: TObject;
  var Done: Boolean);
var Flag: boolean;
begin
  Flag:=Trim(Example.PtName) <> '';
  cbBaseColor.Enabled:=Flag;
  Example.Visible:=not Flag;
  Example0.Visible:=Flag;
  Example1.Visible:=Flag;
  Label13.Enabled:=not Flag;
  Label10.Enabled:=not Flag;
  Label12.Enabled:=not Flag;
  LineWidth.Enabled:=not Flag;
  LineStyle.Enabled:=not Flag;
  btLineColor.Enabled:=not Flag;
  Label1.Enabled:=Flag;
  Label3.Enabled:=Flag;
  Label7.Enabled:=Flag;
  LineWidth0.Enabled:=Flag;
  LineStyle0.Enabled:=Flag;
  btLineColor0.Enabled:=Flag and not cbBaseColor.Checked;
  Label8.Enabled:=Flag;
  Label14.Enabled:=Flag;
  Label15.Enabled:=Flag;
  LineWidth1.Enabled:=Flag;
  LineStyle1.Enabled:=Flag;
  btLineColor1.Enabled:=Flag and not cbBaseColor.Checked;
end;

procedure TDinLineEditorForm.Shape1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Example.Focused:=False;
  Example0.Focused:=False;
  Example1.Focused:=False;
end;

procedure TDinLineEditorForm.FreshTimer(Sender: TObject);
begin
  Example0.State:=False;
  Example0.IsLinked:=True;
  Example0.Invalidate;
  Example1.State:=True;
  Example1.IsLinked:=True;
  Example1.Invalidate;
end;

procedure TDinLineEditorForm.LineStyleDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
const APenStyle: array[0..5] of TPenStyle =
               (psSolid, psDash, psDot, psDashDot, psDashDotDot, psClear);

begin
  with Control as TComboBox do
  begin
    if (odSelected	in State) then
    begin
      Canvas.Brush.Color:=clHighLight;
      Canvas.Pen.Color:=clHighLightText;
    end
    else
    begin
      Canvas.Brush.Color:=clWindow;
      Canvas.Pen.Color:=clWindowText;
    end;
    Canvas.FillRect(Rect);
    Canvas.Pen.Style:=APenStyle[Index];
    if Canvas.Pen.Style <> psClear then
    begin
      Canvas.MoveTo(Rect.Left,Rect.Top+((Rect.Bottom-Rect.Top) div 2));
      Canvas.LineTo(Rect.Right,Rect.Top+((Rect.Bottom-Rect.Top) div 2));
    end
    else
    begin
      DrawText(Canvas.Handle,PChar('невидимая линия'),-1,Rect,
               DT_CENTER or DT_SINGLELINE or DT_VCENTER);
    end;
    Canvas.Pen.Style:=psSolid;
  end;
end;

procedure TDinLineEditorForm.LineKindDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  with Control as TComboBox do
  begin
    if (odSelected	in State) then
    begin
      Canvas.Brush.Color:=clHighLight;
      Canvas.Pen.Color:=clHighLightText;
    end
    else
    begin
      Canvas.Brush.Color:=clWindow;
      Canvas.Pen.Color:=clWindowText;
    end;
    Canvas.FillRect(Rect);
    DrawKindLine(Canvas,Rect,Index,3,clBlack,psSolid);
  end;
end;

procedure TDinLineEditorForm.LineKindSelect(Sender: TObject);
begin
  Example.LineKind:=LineKind.ItemIndex;
  Example0.LineKind:=LineKind.ItemIndex;
  Example1.LineKind:=LineKind.ItemIndex;
end;

procedure TDinLineEditorForm.LineStyleSelect(Sender: TObject);
begin
  Example.LineStyle:=TPenStyle(LineStyle.ItemIndex);
  Example0.LineStyle:=TPenStyle(LineStyle.ItemIndex);
  Example1.LineStyle:=TPenStyle(LineStyle.ItemIndex);
end;

procedure TDinLineEditorForm.LineStyle0Select(Sender: TObject);
begin
  Example.LineStyle0:=TPenStyle(LineStyle0.ItemIndex);
  Example0.LineStyle0:=TPenStyle(LineStyle0.ItemIndex);
  Example1.LineStyle0:=TPenStyle(LineStyle0.ItemIndex);
end;

procedure TDinLineEditorForm.LineStyle1Select(Sender: TObject);
begin
  Example.LineStyle1:=TPenStyle(LineStyle1.ItemIndex);
  Example0.LineStyle1:=TPenStyle(LineStyle1.ItemIndex);
  Example1.LineStyle1:=TPenStyle(LineStyle1.ItemIndex);
end;

procedure TDinLineEditorForm.LineWidthChange(Sender: TObject);
begin
  Example.LineWidth:=LineWidth.Value;
  Example0.LineWidth:=LineWidth.Value;
  Example1.LineWidth:=LineWidth.Value;
end;

procedure TDinLineEditorForm.LineWidth0Change(Sender: TObject);
begin
  Example.LineWidth0:=LineWidth0.Value;
  Example0.LineWidth0:=LineWidth0.Value;
  Example1.LineWidth0:=LineWidth0.Value;
end;

procedure TDinLineEditorForm.LineWidth1Change(Sender: TObject);
begin
  Example.LineWidth1:=LineWidth1.Value;
  Example0.LineWidth1:=LineWidth1.Value;
  Example1.LineWidth1:=LineWidth1.Value;
end;

procedure TDinLineEditorForm.cbBaseColorClick(Sender: TObject);
var E: TEntity; Blink: boolean; AColor: TColor;
begin
  Example.BaseColor:=cbBaseColor.Checked;
  Example0.BaseColor:=cbBaseColor.Checked;
  Example1.BaseColor:=cbBaseColor.Checked;
  if not GetParamVal(Example.FPtName,E,Blink) then Exit;
  if cbBaseColor.Checked then
  begin
    with E as TCustomDigOut do
    begin
      SavedColor0:=Example.Color0;
      AColor:=ArrayDigColor[ColorDown];
      UpdateButton(btLineColor0,AColor);
      Example.Color0:=AColor;
      Example0.Color0:=AColor;
      Example1.Color0:=AColor;
      SavedColor1:=Example.Color1;
      AColor:=ArrayDigColor[ColorUp];
      UpdateButton(btLineColor1,AColor);
      Example.Color1:=AColor;
      Example0.Color1:=AColor;
      Example1.Color1:=AColor;
    end;
  end
  else
  begin
    AColor:=SavedColor0;
    UpdateButton(btLineColor0,AColor);
    Example.Color0:=AColor;
    Example0.Color0:=AColor;
    Example1.Color0:=AColor;
    AColor:=SavedColor1;
    UpdateButton(btLineColor1,AColor);
    Example.Color1:=AColor;
    Example0.Color1:=AColor;
    Example1.Color1:=AColor;
  end;
end;

procedure TDinLineEditorForm.ChangeColorClick(Sender: TObject);
var Btn: TBitBtn; DC: TDinColor;
begin
  DC:=TDinColor((Sender as TMenuItem).Tag);
  Btn:=TBitBtn(pmColorSelect.Tag);
  UpdateButton(Btn,ArrayDinColor[DC]);
  if Btn = btLineColor then
  begin
    Example.Color:=ArrayDinColor[DC];
    Example0.Color:=ArrayDinColor[DC];
    Example1.Color:=ArrayDinColor[DC];
  end;
  if Btn = btLineColor0 then
  begin
    Example.Color0:=ArrayDinColor[DC];
    Example0.Color0:=ArrayDinColor[DC];
    Example1.Color0:=ArrayDinColor[DC];
  end;
  if Btn = btLineColor1 then
  begin
    Example.Color1:=ArrayDinColor[DC];
    Example0.Color1:=ArrayDinColor[DC];
    Example1.Color1:=ArrayDinColor[DC];
  end;
end;

procedure TDinLineEditorForm.CustomColorClick(Sender: TObject);
var Btn: TBitBtn;
begin
  Btn:=TBitBtn(pmColorSelect.Tag);
  ColorDialog1.Color:=TColor(Btn.Tag);
  if ColorDialog1.Execute then
  begin
    if Btn = btLineColor then
    begin
      Example.Color:=ColorDialog1.Color;
      Example0.Color:=ColorDialog1.Color;
      Example1.Color:=ColorDialog1.Color;
    end;
    if Btn = btLineColor0 then
    begin
      Example.Color0:=ColorDialog1.Color;
      Example0.Color0:=ColorDialog1.Color;
      Example1.Color0:=ColorDialog1.Color;
    end;
    if Btn = btLineColor1 then
    begin
      Example.Color1:=ColorDialog1.Color;
      Example0.Color1:=ColorDialog1.Color;
      Example1.Color1:=ColorDialog1.Color;
    end;
    UpdateButton(Btn,ColorDialog1.Color);
  end;
end;

procedure TDinLineEditorForm.UpdateButton(Btn: TBitBtn; DC: TColor);
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

procedure TDinLineEditorForm.btLineColorClick(Sender: TObject);
var P: TPoint;
begin
  pmColorSelect.Tag:=Integer(Sender);
  with Sender as TBitBtn do
  begin
    P:=Self.ClientToScreen(Point(Left+Parent.Left,Top+Height+Parent.Top));
    pmColorSelect.Popup(P.X,P.Y);
  end;
end;

procedure TDinLineEditorForm.pmColorSelectPopup(Sender: TObject);
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

initialization
  RegisterClass(TDinLine);

end.
