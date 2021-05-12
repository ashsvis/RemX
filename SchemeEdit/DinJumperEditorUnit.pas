unit DinJumperEditorUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DinElementsUnit, ExtCtrls, StdCtrls, Spin, Buttons, Menus,
  ImgList, AppEvnts, IniFiles;

type
  TDinJump = class(TDinControl)
  private
    Body: record
            DinType: byte;
            Framed: Boolean;
            Solid: Boolean;
            ScreenName: string[255];
            Text: string[255];
            Color: TColor;
            KeyLevel: byte;
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
    FFramed: Boolean;
    FSolid: Boolean;
    FScreenName: string;
    FText: string;
    FColor: TColor;
    FKeyLevel: byte;
    procedure WMLeftButtonDown(var Msg: TWMMouseMove); message WM_LButtonDown;
    procedure WMMouseMove(var Msg: TWMMouseMove); message wm_MouseMove;
    procedure SetColor(const Value: TColor);
    procedure SetFramed(const Value: Boolean);
    procedure SetScreenName(const Value: string);
    procedure SetSolid(const Value: Boolean);
    procedure SetText(const Value: string);
    procedure SetKeyLevel(const Value: byte);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    function ShowEditor: boolean; override;
    procedure Assign(Source: TPersistent); override;
    procedure SaveToStream(Stream: TStream); override;
    procedure SaveToIniFile(MF: TMemInifile); override;
    function LoadFromStream(Stream: TStream): integer; override;
  published
    property ScreenName: string read FScreenName write SetScreenName;
    property Framed: Boolean read FFramed write SetFramed;
    property Solid: Boolean read FSolid write SetSolid;
    property Color: TColor read FColor write SetColor;
    property Font;
    property Text: string read FText write SetText;
    property KeyLevel: byte read FKeyLevel write SetKeyLevel;
  end;

  TDinJumperEditorForm = class(TForm)
    GroupBox: TGroupBox;
    ScrollBox: TScrollBox;
    CloseButton: TButton;
    PropertyBox: TGroupBox;
    cbFramed: TCheckBox;
    cbSolid: TCheckBox;
    Label3: TLabel;
    edText: TEdit;
    FontDialog: TFontDialog;
    Label1: TLabel;
    edScheme: TEdit;
    seWidth: TSpinEdit;
    Label2: TLabel;
    Label4: TLabel;
    seHeight: TSpinEdit;
    buFont: TButton;
    Label5: TLabel;
    seLeft: TSpinEdit;
    Label6: TLabel;
    seTop: TSpinEdit;
    Label7: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    cbEnterLevel: TComboBox;
    Label8: TLabel;
    CancelButton: TButton;
    Label9: TLabel;
    btColorBox: TBitBtn;
    pmColorSelect: TPopupMenu;
    ImageList1: TImageList;
    ColorDialog1: TColorDialog;
    ApplicationEvents: TApplicationEvents;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure buFontClick(Sender: TObject);
    procedure cbFramedClick(Sender: TObject);
    procedure cbSolidClick(Sender: TObject);
    procedure edTextChange(Sender: TObject);
    procedure edTextKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edSchemeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure seWidthChange(Sender: TObject);
    procedure seHeightChange(Sender: TObject);
    procedure cbEnterLevelChange(Sender: TObject);
    procedure Shape1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pmColorSelectPopup(Sender: TObject);
    procedure btColorBoxClick(Sender: TObject);
    procedure ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
  private
    Source,Example: TDinJump;
    procedure UpdateButton(Btn: TBitBtn; DC: TColor);
    procedure CustomColorClick(Sender: TObject);
    procedure ChangeColorClick(Sender: TObject);
  public
  end;

implementation

uses EntityUnit, OpenDialogUnit;

{$R *.dfm}

{ TDinJamper }

procedure TDinJump.Assign(Source: TPersistent);
var C: TDinJump;
begin
  inherited;
  C:=Source as TDinJump;
  FScreenName:=C.ScreenName;
  FFramed:=C.Framed;
  FSolid:=C.Solid;
  FColor:=C.Color;
  Font.Assign(C.Font);
  FText:=C.Text;
  FKeyLevel:=C.KeyLevel;
end;

constructor TDinJump.Create(AOwner: TComponent);
begin
  inherited;
  Width:=50;
  Height:=50;
  FFramed:=False;
  FText:='';
  FSolid:=False;
  Font.Color:=clWhite;
  Font.Name:='Arial';
  Font.Size:=9;
  Font.Charset:=RUSSIAN_CHARSET;
  Color:=clNavy;
end;

procedure TDinJump.SaveToStream(Stream: TStream);
begin
  Body.DinType:=DinType;
  Body.Framed:=Framed;
  Body.Solid:=Solid;
  Body.ScreenName:=ScreenName;
  Body.Text:=Text;
  Body.Color:=Color;
  Body.KeyLevel:=KeyLevel;
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

function TDinJump.LoadFromStream(Stream: TStream): integer;
begin
  Result:=SizeOf(Body);
  if (Stream.Size-Stream.Position) < Result then
  begin
    Result:=0;
    Exit;
  end;
  Stream.ReadBuffer(Body,Result);
  FFramed:=Body.Framed;
  FSolid:=Body.Solid;
  FScreenName:=Body.ScreenName;
  FText:=Body.Text;
  FColor:=Body.Color;
  FKeyLevel:=Body.KeyLevel;
  Font.Name:=Body.Font.Name;
  Font.Color:=Body.Font.Color;
  Font.Charset:=Body.Font.CharSet;
  Font.Size:=Body.Font.Size;
  Font.Style:=Body.Font.Style;
  SetBounds(Body.Left,Body.Top,Body.Width,Body.Height);
end;

procedure TDinJump.Paint;
var R,Rct: TRect;
begin
  inherited;
  if Trim(FScreenName) <> '' then
  begin
    Hint:='Переход на схему "'+FScreenName+'"'+#13+
      Format('Смещение: %d, %d; Размер: %d, %d',[Left,Top,Width,Height]);
    ShowHint:=True;
  end
  else
  begin
    ShowHint:=False;
    Hint:='';
  end;
  R:=ClientRect;
  if FSolid then
  begin
    Canvas.Pen.Color:=Color;
    Canvas.Brush.Color:=Color;
    R.Bottom:=R.Bottom+1;
    R.Right:=R.Right+1;
    Canvas.Rectangle(R);
    R.Bottom:=R.Bottom-1;
    R.Right:=R.Right-1;
  end;
  if FText <> '' then
  begin
    Canvas.Brush.Style:=bsClear;
    Canvas.Font:=Self.Font;
    if FFramed then InflateRect(R,-5,-5) else InflateRect(R,-1,-1);
    Rct:=R;
    DrawText(Canvas.Handle,PChar(FText),Length(FText),R,
             DT_CENTER or DT_WORDBREAK or DT_VCENTER or DT_CALCRECT);
    OffsetRect(R,((Rct.Right-Rct.Left)-(R.Right-R.Left)) div 2,
                 ((Rct.Bottom-Rct.Top)-(R.Bottom-R.Top)) div 2);
    DrawText(Canvas.Handle,PChar(FText),Length(FText),R,
             DT_CENTER or DT_WORDBREAK or DT_VCENTER);
    R:=Rct;
  end;
  R:=Rect(0,0,Width,Height);
  if FFramed then
  begin
// Внешняя выпуклая рамка
    Canvas.Pen.Width:=1;
    Canvas.Pen.Color:=cl3DLight;
    Canvas.MoveTo(R.Left,R.Bottom);
    Canvas.LineTo(R.Left,R.Top);
    Canvas.LineTo(R.Right,R.Top);
    Canvas.Pen.Color:=cl3DDkShadow;
    Canvas.LineTo(R.Right,R.Bottom);
    Canvas.LineTo(R.Left,R.Bottom);
// Внешняя рамка
    Canvas.Pen.Color:=clBtnFace;
    Inflaterect(R,-1,-1);
    Canvas.MoveTo(R.Left,R.Bottom);
    Canvas.LineTo(R.Left,R.Top);
    Canvas.LineTo(R.Right,R.Top);
    Canvas.LineTo(R.Right,R.Bottom);
    Canvas.LineTo(R.Left,R.Bottom);
// Внутренняя вогнутая рамка
    Canvas.Pen.Color:=clBtnShadow;
    Inflaterect(R,-1,-1);
    Canvas.MoveTo(R.Left,R.Bottom);
    Canvas.LineTo(R.Left,R.Top);
    Canvas.LineTo(R.Right,R.Top);
    Canvas.Pen.Color:=clBtnHighLight;
    Canvas.LineTo(R.Right,R.Bottom);
    Canvas.LineTo(R.Left,R.Bottom);
  end;
  R:=Rect(0,0,Width,Height);
  if Editing then
  begin
    if not FFramed then
    begin
      Canvas.Pen.Color:=clSilver;
      Canvas.Pen.Style:=psDash;
      Canvas.Brush.Style:=bsClear;
      Canvas.Rectangle(R);
      Canvas.Brush.Style:=bsSolid;
      Canvas.Pen.Style:=psSolid;
    end;
    if Focused then Draw8Points(Canvas);
  end
  else
  begin
    if Focused then
    begin
      Canvas.Pen.Color:=clAqua;
      Canvas.Brush.Style:=bsClear;
      Canvas.Rectangle(ClientRect);
      Canvas.Brush.Style:=bsSolid;
    end;
  end;
end;

procedure TDinJump.SetColor(const Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    Invalidate;
  end;
end;

procedure TDinJump.SetFramed(const Value: Boolean);
begin
  if FFramed <> Value then
  begin
    FFramed := Value;
    Invalidate;
  end;
end;

procedure TDinJump.SetKeyLevel(const Value: byte);
begin
  FKeyLevel := Value;
end;

procedure TDinJump.SetScreenName(const Value: string);
begin
  FScreenName := Value;
end;

procedure TDinJump.SetSolid(const Value: Boolean);
begin
  if FSolid <> Value then
  begin
    FSolid := Value;
    Invalidate;
  end;
end;

procedure TDinJump.SetText(const Value: string);
begin
  if FText <> Value then
  begin
    FText:=Value;
    Invalidate;
  end;
end;

function TDinJump.ShowEditor: boolean;
begin
  with TDinJumperEditorForm.Create(Parent) do
  try
    Source := Self;
    ScrollBox.Color := (Self.Parent as TBackground).Color;
    seLeft.Value := Self.Left;
    seTop.Value := Self.Top;
    Example.Assign(Self);
    if Example.Width < ScrollBox.ClientWidth then
      Example.Left := (ScrollBox.ClientWidth - Example.Width) div 2
    else
      Example.Left:=0;
    if Example.Height < ScrollBox.ClientHeight then
      Example.Top := (ScrollBox.ClientHeight - Example.Height) div 2
    else
      Example.Top := 0;
    edText.OnChange:=nil;
    cbFramed.OnClick:=nil;
    cbSolid.OnClick:=nil;
    seWidth.OnChange:=nil;
    seHeight.OnChange:=nil;
    cbEnterLevel.OnChange:=nil;
    try
      buFont.Font.Name:=Example.Font.Name;
      buFont.Font.Style:=Example.Font.Style;
      buFont.Caption:=Example.Font.Name+', '+IntToStr(Example.Font.Size);
      edText.Text:=Example.Text;
      cbFramed.Checked:=Example.Framed;
      cbSolid.Checked:=Example.Solid;
      seWidth.MaxValue:=PanelWidth-Example.Left;
      seWidth.Value:=Example.Width;
      seHeight.MaxValue:=PanelHeight-Example.Top;
      seHeight.Value:=Example.Height;
      UpdateButton(btColorBox,Example.Color);
      edScheme.Text:=Example.ScreenName;
      cbEnterLevel.ItemIndex:=Example.KeyLevel;
    finally
      edText.OnChange:=edTextChange;
      cbFramed.OnClick:=cbFramedClick;
      cbSolid.OnClick:=cbSolidClick;
      seWidth.OnChange:=seWidthChange;
      seHeight.OnChange:=seHeightChange;
      cbEnterLevel.OnChange:=cbEnterLevelChange;
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

procedure TDinJump.WMMouseMove(var Msg: TWMMouseMove);
begin
  inherited;
  ShowHint:=Editing;
  if not Editing and (Trim(ScreenName) <> '.SCM') then Cursor:=crHandPoint;
end;

procedure TDinJumperEditorForm.FormCreate(Sender: TObject);
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
  Example:=TDinJump.Create(Self);
  Example.Parent:=ScrollBox;
end;

procedure TDinJumperEditorForm.FormDestroy(Sender: TObject);
begin
  Example.Free;
end;

procedure TDinJumperEditorForm.buFontClick(Sender: TObject);
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

procedure TDinJumperEditorForm.cbFramedClick(Sender: TObject);
begin
  Example.Framed:=cbFramed.Checked;
end;

procedure TDinJumperEditorForm.cbSolidClick(Sender: TObject);
begin
  Example.Solid:=cbSolid.Checked;
end;

procedure TDinJumperEditorForm.edTextChange(Sender: TObject);
begin
  Example.Text:=edText.Text;
end;

procedure TDinJumperEditorForm.edTextKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    edText.SelectAll;
    edText.SelStart:=0;
    Key := 0;
  end;
end;

procedure TDinJumperEditorForm.edSchemeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    if ForceDirectories(Caddy.CurrentSchemsPath) then
    begin
      OpenDialogForm:=TOpenDialogForm.Create(Self);
      try
        OpenDialogForm.InitialDir:=Caddy.CurrentSchemsPath;
        OpenDialogForm.FileName:=Example.ScreenName;
        OpenDialogForm.Filter:='*.SCM';
        if OpenDialogForm.Execute then
        begin
          edScheme.Text:=ExtractFileName(OpenDialogForm.FileName);
          Example.ScreenName:=ExtractFileName(OpenDialogForm.FileName);
        end;
      finally
        OpenDialogForm.Free;
      end;
    end;
  end;
end;

procedure TDinJumperEditorForm.seWidthChange(Sender: TObject);
begin
  Example.Width:=seWidth.Value;
  if Example.Width < ScrollBox.ClientWidth then
    Example.Left:=(ScrollBox.ClientWidth-Example.Width) div 2
  else
    Example.Left:=0;
end;

procedure TDinJumperEditorForm.seHeightChange(Sender: TObject);
begin
  Example.Height:=seHeight.Value;
  if Example.Height < ScrollBox.ClientHeight then
    Example.Top:=(ScrollBox.ClientHeight-Example.Height) div 2
  else
    Example.Top:=0;
end;

procedure TDinJumperEditorForm.cbEnterLevelChange(Sender: TObject);
begin
  Example.KeyLevel:=cbEnterLevel.ItemIndex;
end;

procedure TDinJump.WMLeftButtonDown(var Msg: TWMMouseMove);
begin
  inherited;
  if not Editing and (Trim(ScreenName) <> '.SCM') then
    PostMessage(Parent.Handle,WM_DinJumperClick,0,THandle(Self));
end;

procedure TDinJumperEditorForm.Shape1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Example.Focused:=False;
end;

procedure TDinJumperEditorForm.UpdateButton(Btn: TBitBtn; DC: TColor);
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

procedure TDinJumperEditorForm.pmColorSelectPopup(Sender: TObject);
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

procedure TDinJumperEditorForm.CustomColorClick(Sender: TObject);
var Btn: TBitBtn; 
begin
  Btn:=TBitBtn(pmColorSelect.Tag);
  ColorDialog1.Color:=TColor(Btn.Tag);
  if ColorDialog1.Execute then
  begin
    if Btn = btColorBox then Example.Color:=ColorDialog1.Color;
    UpdateButton(Btn,ColorDialog1.Color);
    cbSolid.Checked:=True;
  end;
end;

procedure TDinJumperEditorForm.ChangeColorClick(Sender: TObject);
var Btn: TBitBtn; DC: TDinColor;
begin
  DC:=TDinColor((Sender as TMenuItem).Tag);
  Btn:=TBitBtn(pmColorSelect.Tag);
  UpdateButton(Btn,ArrayDinColor[DC]);
  if Btn = btColorBox then Example.Color:=ArrayDinColor[DC];
  cbSolid.Checked:=True;
end;

procedure TDinJumperEditorForm.btColorBoxClick(Sender: TObject);
var P: TPoint;
begin
  pmColorSelect.Tag:=Integer(Sender);
  with Sender as TBitBtn do
  begin
    P:=Self.ClientToScreen(Point(Left+Parent.Left,Top+Height+Parent.Top));
    pmColorSelect.Popup(P.X,P.Y);
  end;
end;

procedure TDinJumperEditorForm.ApplicationEventsIdle(Sender: TObject;
  var Done: Boolean);
begin
  btColorBox.Enabled:=cbSolid.Checked;
  Label7.Enabled:=cbSolid.Checked;
end;

procedure TDinJump.SaveToIniFile(MF: TMemInifile);
var SectName: string; i: integer;
begin
  i:=MF.ReadInteger('DinTypeCounts','DinJump',0);
  Inc(i);
  MF.WriteInteger('DinTypeCounts','DinJump',i);
  SectName:=Format('DinJump%d',[i]);
  MF.WriteInteger(SectName,'DinType',DinType);
  MF.WriteBool(SectName,'Framed',Framed);
  MF.WriteBool(SectName,'Solid',Solid);
  MF.WriteString(SectName,'ScreenName',ScreenName);
  MF.WriteString(SectName,'Text',Text);
  MF.WriteInteger(SectName,'Color',Color);
  MF.WriteInteger(SectName,'KeyLevel',KeyLevel);
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
  RegisterClass(TDinJump);

end.
