unit DinButtonEditorUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Spin, EntityUnit, DinElementsUnit, IniFiles;

type
  TDinButton = class(TDinControl)
  private
    Body: record
            DinType: byte;
            PtName: string[10];
            Text: string[255];
            Fixed: boolean;
            Font: TFontRec;
            Left: Integer;
            Top: Integer;
            Width: Integer;
            Height: Integer;
            PtName1: string[10];
            Direct: boolean;
            KeyLevel: byte;
            Reserved1: byte;
            Reserved2: byte;
            Reserved3: byte;
          end;
    FFixed: boolean;
    FText: string;
    FPtName: string;
    First: Boolean;
    State,LastState: boolean;
    FKeyLevel: byte;
    FConfirm: boolean;
    procedure SetFixed(const Value: boolean);
    procedure SetPtName(const Value: string);
    procedure SetText(const Value: string);
    procedure WMKeyDown(var Msg: TWMKeyDown); message WM_KEYDOWN;
    procedure WMMouseMove(var Msg: TWMMouseMove); message wm_MouseMove;
    procedure WMLeftButtonDown(var Msg: TWMMouseMove); message WM_LButtonDown;
    procedure SetKeyLevel(const Value: byte);
    procedure SetConfirm(const Value: boolean);
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
    procedure ButtonClick;
  published
    property PtName: string read FPtName write SetPtName;
    property KeyLevel: byte read FKeyLevel write SetKeyLevel;
    property Font;
    property Text: string read FText write SetText;
    property Fixed: boolean read FFixed write SetFixed;
    property Confirm: boolean read FConfirm write SetConfirm;
  end;

  TDinButtonEditorForm = class(TForm)
    PropertyBox: TGroupBox;
    Label3: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Bevel2: TBevel;
    edPtName: TEdit;
    seWidth: TSpinEdit;
    seHeight: TSpinEdit;
    seLeft: TSpinEdit;
    seTop: TSpinEdit;
    GroupBox: TGroupBox;
    ScrollBox: TScrollBox;
    CloseButton: TButton;
    CancelButton: TButton;
    Fresh: TTimer;
    Label1: TLabel;
    edText: TEdit;
    buFont: TButton;
    cbFixed: TCheckBox;
    Bevel1: TBevel;
    FontDialog: TFontDialog;
    Label7: TLabel;
    cbConfirm: TCheckBox;
    lbl1: TLabel;
    cbEnterLevel: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure seWidthChange(Sender: TObject);
    procedure seHeightChange(Sender: TObject);
    procedure edTextChange(Sender: TObject);
    procedure edTextKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbFixedClick(Sender: TObject);
    procedure edPtNameClick(Sender: TObject);
    procedure FreshTimer(Sender: TObject);
    procedure Shape1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure buFontClick(Sender: TObject);
    procedure cbConfirmClick(Sender: TObject);
    procedure cbEnterLevelChange(Sender: TObject);
  private
    Source,Example: TDinButton;
  public
  end;

var
  DinButtonEditorForm: TDinButtonEditorForm;

implementation

uses GetLinkNameUnit, RemXUnit;

{$R *.dfm}

{ TDinButton }

procedure TDinButton.Assign(Source: TPersistent);
var C: TDinButton;
begin
  inherited;
  C:=Source as TDinButton;
  FPtName:=C.PtName;
  FKeyLevel:=C.KeyLevel;
  Font.Assign(C.Font);
  FText:=C.Text;
  FFixed:=C.Fixed;
  FConfirm:=C.Confirm;
end;

procedure TDinButton.ButtonClick;
var i: integer;
begin
  if FFixed then i:=1 else i:=0;
  PostMessage(Parent.Handle,WM_DinButtonClick,THandle(Self),i);
end;

constructor TDinButton.Create(AOwner: TComponent);
begin
  inherited;
  First:=True;
  IsLinked:=False;
  FDinKind:=dkButton;
  Width:=75;
  Height:=30;
  Font.Name:='Tahoma';
  Font.Size:=9;
  Font.Charset:=RUSSIAN_CHARSET;
  FText:='Кнопка';
  FConfirm:=True;
end;

function TDinButton.LoadFromStream(Stream: TStream): integer;
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
  FKeyLevel:=Body.KeyLevel;
  FText:=Body.Text;
  FFixed:=Body.Fixed;
  FConfirm:=not Body.Direct;
  Font.Name:=Body.Font.Name;
  Font.Color:=Body.Font.Color;
  Font.Charset:=Body.Font.CharSet;
  Font.Size:=Body.Font.Size;
  Font.Style:=Body.Font.Style;
  SetBounds(Body.Left,Body.Top,Body.Width,Body.Height);
end;

procedure TDinButton.Paint;
var R,Rct: TRect; Bmp: TBitmap; Cash: TCanvas;
begin
  Bmp:=TBitmap.Create;
  try
    Bmp.Width:=Width;
    Bmp.Height:=Height;
    Cash:=Bmp.Canvas;
    R:=Rect(0,0,Width,Height);
    if State then
    begin
      DrawFrameControl(Cash.Handle,R,DFC_BUTTON,
                       DFCS_BUTTONPUSH+DFCS_PUSHED);
      InflateRect(R,-1,-1);
      DrawFrameControl(Cash.Handle,R,DFC_BUTTON,
                       DFCS_BUTTONPUSH+DFCS_PUSHED);
    end
    else
    begin
// Внешняя выпуклая рамка
      DrawFrameControl(Cash.Handle,R,DFC_BUTTON,DFCS_BUTTONPUSH);
      InflateRect(R,-1,-1);
      DrawFrameControl(Cash.Handle,R,DFC_BUTTON,DFCS_BUTTONPUSH);
    end;
    InflateRect(R,-1,-1);
    if State then OffsetRect(R,2,2);
    if FText <> '' then
    begin
      Cash.Brush.Style:=bsClear;
      Cash.Font:=Self.Font;
      InflateRect(R,-1,-1);
      Rct:=R;
      DrawText(Cash.Handle,PChar(FText),Length(FText),R,
               DT_CENTER or DT_WORDBREAK or DT_VCENTER or DT_CALCRECT);
      OffsetRect(R,((Rct.Right-Rct.Left)-(R.Right-R.Left)) div 2,
                   ((Rct.Bottom-Rct.Top)-(R.Bottom-R.Top)) div 2);
      DrawText(Cash.Handle,PChar(FText),Length(FText),R,
               DT_CENTER or DT_WORDBREAK or DT_VCENTER);
      R:=Rct;
      Cash.Brush.Style:=bsSolid;
    end;
    if Editing and Focused then Draw8Points(Cash);
    if not Editing and Focused then
    begin
      InflateRect(R,-2,-2);
      Cash.Brush.Style:=bsSolid;
      Cash.Pen.Color:=clBlack;
      Cash.Brush.Color:=clBtnFace;
      Cash.Font.Color:=clBlack;
      Cash.DrawFocusRect(R);
    end;
    Canvas.Draw(0,0,Bmp);
  finally
    Bmp.Free;
  end;
end;

procedure TDinButton.SaveToIniFile(MF: TMemInifile);
var SectName: string; i: integer;
begin
  i:=MF.ReadInteger('DinTypeCounts','DinButton',0);
  Inc(i);
  MF.WriteInteger('DinTypeCounts','DinButton',i);
  SectName:=Format('DinButton%d',[i]);
  MF.WriteInteger(SectName,'DinType',DinType);
  MF.WriteString(SectName,'PtName',PtName);
  MF.WriteInteger(SectName,'KeyLevel',KeyLevel);
  MF.WriteString(SectName,'Text',Text);
  MF.WriteBool(SectName,'Fixed',Fixed);
  MF.WriteBool(SectName,'Direct',not Confirm);
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

procedure TDinButton.SaveToStream(Stream: TStream);
begin
  Body.DinType:=DinType;
  Body.PtName:=PtName;
  Body.KeyLevel:=KeyLevel;
  Body.Text:=Text;
  Body.Fixed:=Fixed;
  Body.Direct:= not Confirm;
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

procedure TDinButton.SetConfirm(const Value: boolean);
begin
  FConfirm := Value;
end;

procedure TDinButton.SetFixed(const Value: boolean);
begin
  if FFixed <> Value then
  begin
    FFixed := Value;
    Invalidate;
  end;
end;

procedure TDinButton.SetPtName(const Value: string);
begin
  if FPtName <> Value then
  begin
    FPtName := Value;
    Invalidate;
  end;
end;

procedure TDinButton.SetKeyLevel(const Value: byte);
begin
  FKeyLevel := Value;
end;

procedure TDinButton.SetText(const Value: string);
begin
  if FText <> Value then
  begin
    FText := Value;
    Invalidate;
  end;
end;

function TDinButton.ShowEditor: boolean;
var T: TEntity;
begin
  with TDinButtonEditorForm.Create(Parent) do
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
    edText.OnChange:=nil;
    cbFixed.OnClick:=nil;
    cbConfirm.OnClick:=nil;
    seWidth.OnChange:=nil;
    seHeight.OnChange:=nil;
    cbEnterLevel.OnChange:=nil;
    try
      buFont.Font.Name:=Example.Font.Name;
      buFont.Font.Style:=Example.Font.Style;
      buFont.Caption:=Example.Font.Name+', '+IntToStr(Example.Font.Size);
      edText.Text:=Example.Text;
      cbFixed.Checked:=Example.Fixed;
      cbConfirm.Checked:=Example.Confirm;
      seWidth.MaxValue:=PanelWidth-Example.Left;
      seWidth.Value:=Example.Width;
      seHeight.MaxValue:=PanelHeight-Example.Top;
      seHeight.Value:=Example.Height;
      T:=Caddy.Find(Example.PtName);
      if Assigned(T) then
        edPtName.Text:=T.PtName
      else
        edPtName.Text:='';
      cbEnterLevel.ItemIndex:=Example.KeyLevel;
    finally
      edText.OnChange:=edTextChange;
      cbConfirm.OnClick:=cbConfirmClick;
      cbFixed.OnClick:=cbFixedClick;
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

procedure TDinButton.UpdateData(GetParamVal: TCallbackFunc);
var E: TEntity; DOUT: TCustomDigOut; DINP: TCustomDigInp; Blink: boolean;
    sName: string;
begin
  IsLinked:=False;
  IsCommand:=False;
  sName:=FPtName;
  if sName = '' then
  begin
    if Editing then
      Hint:='Кнопка: <>'+#13+
      Format('Смещение: %d, %d; Размер: %d, %d',[Left,Top,Width,Height])
    else
      Hint:='Нет параметра';
    if (LastState <> State) or First then
    begin
      First:=False;
      LastState:=State;
      Invalidate;
    end;
    Exit;
  end;
  LinkName:=sName;
  if not GetParamVal(sName,E,Blink) then Exit;
  LinkDesc:=E.PtDesc;
  if E.IsParam then
  begin
    DINP:=E as TCustomDigInp;
    IsLinked:=not (asNoLink in DINP.AlarmStatus);
    State:=DINP.OP;
    IsCommand:=True;
  end
  else
  begin
    DOUT:=E as TCustomDigOut;
    IsLinked:=not (asNoLink in DOUT.AlarmStatus);
    IsCommand:=E.IsVirtual;
    State:=DOUT.PV;
  end;
  if Editing then
    Hint:='Кнопка: <'+E.PtName+'>'+#13+
      Format('Смещение: %d, %d; Размер: %d, %d',[Left,Top,Width,Height])
  else
    Hint:=E.PtName+' : '+E.PtDesc;
  if (LastState <> State) or First then
  begin
    First:=False;
    LastState:=State;
    Invalidate;
  end;
end;

procedure TDinButtonEditorForm.FormCreate(Sender: TObject);
begin
  Example:=TDinButton.Create(Self);
  Example.Parent:=ScrollBox;
  Fresh.Enabled:=True;
end;

procedure TDinButtonEditorForm.FormDestroy(Sender: TObject);
begin
  Fresh.Enabled:=False;
  Example.Free;
end;

procedure TDinButtonEditorForm.seWidthChange(Sender: TObject);
begin
  Example.Width:=seWidth.Value;
  if Example.Width < ScrollBox.ClientWidth then
    Example.Left:=(ScrollBox.ClientWidth-Example.Width) div 2
  else
    Example.Left:=0;
end;

procedure TDinButtonEditorForm.seHeightChange(Sender: TObject);
begin
  Example.Height:=seHeight.Value;
  if Example.Height < ScrollBox.ClientHeight then
    Example.Top:=(ScrollBox.ClientHeight-Example.Height) div 2
  else
    Example.Top:=0;
end;

procedure TDinButtonEditorForm.edTextChange(Sender: TObject);
begin
  Example.Text:=edText.Text;
end;

procedure TDinButtonEditorForm.edTextKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    edText.SelectAll;
    edText.SelStart:=0;
    Key := 0;
  end;
end;

procedure TDinButtonEditorForm.cbEnterLevelChange(Sender: TObject);
begin
  Example.KeyLevel:=cbEnterLevel.ItemIndex;
end;

procedure TDinButtonEditorForm.cbFixedClick(Sender: TObject);
begin
  Example.Fixed:=cbFixed.Checked;
end;

procedure TDinButtonEditorForm.cbConfirmClick(Sender: TObject);
begin
  Example.Confirm:=cbConfirm.Checked;
end;

procedure TDinButtonEditorForm.edPtNameClick(Sender: TObject);
var List: TStringList; T,R: TEntity; Kind: Byte; Edit: TEdit;
begin
  Edit:=Sender as TEdit;
  List:=TStringList.Create;
  try
    T:=Caddy.Find(Edit.Text);
    R:=Caddy.FirstEntity;
    while R <> nil do
    begin
      if R.IsDigit and R.IsParam then
        List.AddObject('OP',R);
      if R.IsDigit and not R.IsParam and (R.IsVirtual or R.IsCommand) then
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
        Edit.Text:=T.PtName;
        Edit.SelectAll;
        Example.PtName:=Trim(Edit.Text);
      end
      else
      begin
        Edit.Text:='';
        Example.PtName:='';
      end
    end;
  finally
    List.Free;
  end;
end;

procedure TDinButtonEditorForm.FreshTimer(Sender: TObject);
begin
  Example.UpdateData(@GetParamVal);
end;

procedure TDinButtonEditorForm.Shape1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Example.Focused:=False;
end;

procedure TDinButtonEditorForm.buFontClick(Sender: TObject);
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

procedure TDinButton.WMKeyDown(var Msg: TWMKeyDown);
begin
  if not Editing then
  begin
    if (Msg.CharCode = VK_SPACE) then ButtonClick;
  end;
end;

procedure TDinButton.WMLeftButtonDown(var Msg: TWMMouseMove);
begin
  inherited;
  if not Editing then ButtonClick;
end;

procedure TDinButton.WMMouseMove(var Msg: TWMMouseMove);
begin
  inherited;
  if not Editing then Cursor:=crHandPoint;
end;

initialization
  RegisterClass(TDinButton);

end.
