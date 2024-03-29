unit EditSchemeUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ToolWin, ComCtrls, Menus, ActnList, ExtCtrls, Contnrs,
  DinElementsUnit, EntityUnit, ImgList, PngImage1,
  PanelFormUnit;

type
  TEditSchemeForm = class(TForm, IFresh)
    ScrollBox: TScrollBox;
    SchemEditMenu: TMainMenu;
    miSchemeFile: TMenuItem;
    SchemeEditActionList: TActionList;
    O1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    SchemeControlBar: TControlBar;
    SchemeToolMenu: TToolBar;
    tbSchems: TToolButton;
    N3: TMenuItem;
    SchemeNew: TAction;
    SchemeSave: TAction;
    N4: TMenuItem;
    miObjectMenu: TMenuItem;
    tbObjects: TToolButton;
    DinPopupMenu: TPopupMenu;
    miDinDouble: TMenuItem;
    MenuItem2: TMenuItem;
    MIBringToFront: TMenuItem;
    MISendToBack: TMenuItem;
    miDinDelete: TMenuItem;
    miDinProperty: TMenuItem;
    SchemPopupMenu: TPopupMenu;
    N5: TMenuItem;
    O2: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    miNewDinInsert: TMenuItem;
    DinActionList: TActionList;
    miDinCut: TMenuItem;
    N11: TMenuItem;
    miDinAlignToGrid: TMenuItem;
    miDinAlignment: TMenuItem;
    miDinResize: TMenuItem;
    miDinCopy: TMenuItem;
    miDinPaste: TMenuItem;
    miPaste: TMenuItem;
    N13: TMenuItem;
    SelectAll: TAction;
    miSelectAll: TMenuItem;
    DinPaste: TAction;
    N14: TMenuItem;
    ImageList: TImageList;
    DinCut: TAction;
    DinCopy: TAction;
    miObject: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N15: TMenuItem;
    miClose: TMenuItem;
    EditToolBar: TToolBar;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    DinDelete: TAction;
    ToolButton5: TToolButton;
    tbBackground: TToolButton;
    miBackgroundMenu: TMenuItem;
    miAddBackground: TMenuItem;
    miDeleteBackground: TMenuItem;
    miSaveBackgroundAs: TMenuItem;
    N21: TMenuItem;
    miShowGrid: TMenuItem;
    miGridStep: TMenuItem;
    mi4dot: TMenuItem;
    mi8dot: TMenuItem;
    mi10dot: TMenuItem;
    mi16dot: TMenuItem;
    actShowGrid: TAction;
    actDeleteBackground: TAction;
    actOpenBackground: TAction;
    actSaveBackgroundAs: TAction;
    N12: TMenuItem;
    miBackgroundColorSelect: TMenuItem;
    BackgrounbPictTile: TAction;
    N19: TMenuItem;
    SchemeToolBar: TToolBar;
    ToolButton1: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ColorDialog: TColorDialog;
    actBackgroundColor: TAction;
    actSchemeOpen: TAction;
    actSchemeSaveAs: TAction;
    actOrderList: TAction;
    N8: TMenuItem;
    N20: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure InsertObjectClick(Sender: TObject);
    procedure BackgroundMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BackgroundMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure BackgroundMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure MIBringToFrontClick(Sender: TObject);
    procedure MISendToBackClick(Sender: TObject);
    procedure miDinDoubleClick(Sender: TObject);
    procedure miDinPropertyClick(Sender: TObject);
    procedure SelectAllExecute(Sender: TObject);
    procedure SelectAllUpdate(Sender: TObject);
    procedure DinPasteUpdate(Sender: TObject);
    procedure DinPasteExecute(Sender: TObject);
    procedure miDinAlignToGridClick(Sender: TObject);
    procedure DinPopupMenuPopup(Sender: TObject);
    procedure DinCutExecute(Sender: TObject);
    procedure DinCutUpdate(Sender: TObject);
    procedure DinCopyExecute(Sender: TObject);
    procedure DinCopyUpdate(Sender: TObject);
    procedure miDinAlignmentClick(Sender: TObject);
    procedure miDinResizeClick(Sender: TObject);
    procedure SchemeNewExecute(Sender: TObject);
    procedure SchemeSaveExecute(Sender: TObject);
    procedure SchemeSaveUpdate(Sender: TObject);
    procedure miCloseClick(Sender: TObject);
    procedure DinDeleteExecute(Sender: TObject);
    procedure DinDeleteUpdate(Sender: TObject);
    procedure mi16dotClick(Sender: TObject);
    procedure actShowGridExecute(Sender: TObject);
    procedure actShowGridUpdate(Sender: TObject);
    procedure actOpenBackgroundExecute(Sender: TObject);
    procedure actDeleteBackgroundExecute(Sender: TObject);
    procedure actSaveBackgroundAsExecute(Sender: TObject);
    procedure actDeleteBackgroundUpdate(Sender: TObject);
    procedure actSaveBackgroundAsUpdate(Sender: TObject);
    procedure BackgrounbPictTileExecute(Sender: TObject);
    procedure BackgrounbPictTileUpdate(Sender: TObject);
    procedure SchemPopupMenuPopup(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure actBackgroundColorExecute(Sender: TObject);
    procedure ColorDialogShow(Sender: TObject);
    procedure OpenPictureDialogShow(Sender: TObject);
    procedure SavePictureDialogShow(Sender: TObject);
    procedure actSchemeOpenExecute(Sender: TObject);
    procedure actSchemeSaveAsExecute(Sender: TObject);
    procedure actOrderListExecute(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  private
    ClipboardStream: TMemoryStream;
    DinList,SelList: TComponentList;
    Rects: array of TRect;
    Curr: TDinControl;
    Captured: boolean;
    Delta,Shifting: TPoint;
    SelRect,CurRect,PasteRect: TRect;
    Background: TBackground;
    FirstBackgroundSave: Boolean;
    OriginalFilter: string;
    CurrFileName: string;
    FPanel: TPanelForm;
    procedure DrawCurrRect;
    procedure PasteInPoint(X, Y: integer);
    procedure CalcPasteRect;
    procedure SortSelList;
    procedure FreshView; stdcall;
    procedure CheckSaved;
    procedure DinBoundsInfo(Sender: TObject; Left,Top,Width,Height: integer);
    procedure DinBoundsMove(Sender: TObject; Left,Top,Width,Height: integer);
    procedure DinBoundsSize(Sender: TObject; Left,Top,Width,Height: integer);
    procedure ShowDinPopupMenu(Sender: TObject; X,Y: integer; Shift: TShiftState);
    procedure DinSetFocus(Sender: TObject; Shift: TShiftState);
    procedure UnselectAll;
    procedure miDinDblClick(Sender: TObject);
    procedure SelectDin(var Msg: TMessage); message WM_SelectDin;
    procedure InitBackground;
    procedure SetPanel(const Value: TPanelForm);
  public
    HasChanged: Boolean;
    procedure LoadSchemeFromFile(FileName: string);
    property Panel: TPanelForm read FPanel write SetPanel;
  end;

procedure SaveSchemeToFile(FileName: string; Background: TBackground;
                           DinList: TComponentList; var HasChanged: boolean);

implementation

uses IniFiles, EditDinAlignmentUnit, EditDinSizeUnit, CRCCalcUnit,
     RemXUnit, OpenDialogUnit, OpenExtDialogUnit,
     SaveExtDialogUnit, TabOrderUnit, DinJumperEditorUnit, DinTextEditorUnit,
     DinButtonEditorUnit;

{$R *.dfm}

procedure TEditSchemeForm.InitBackground;
begin
  Background:=TBackground.Create(Self);
  Background.Editing:=True;
  Background.SetBounds(0,0,PanelWidth,PanelHeight);
  Background.Parent:=ScrollBox;
  Background.OnMouseDown:=BackgroundMouseDown;
  Background.OnMouseMove:=BackgroundMouseMove;
  Background.OnMouseUp:=BackgroundMouseUp;
  Background.PopupMenu:=SchemPopupMenu;
end;

procedure TEditSchemeForm.FormCreate(Sender: TObject);
var i: integer; MI: TMenuItem; Act: TAction;
begin
  FirstBackgroundSave:=True;
  OriginalFilter:='';
  CurrFileName:='';
  HasChanged:=False;
  ClipboardStream:=TMemoryStream.Create;
  InitBackground;
  with RemXForm do
  Curr:=nil;
  DinList:=TComponentList.Create;
  SelList:=TComponentList.Create(False);
//-------------------------------------
  for i:=0 to Length(ADin)-1 do
  begin
    Act:=TAction.Create(Self);
    Act.Caption:=ADin[i].Caption;
    Act.Tag:=i;
    Act.GroupIndex:=1;
    Act.ImageIndex:=21+i;
    Act.OnExecute:=InsertObjectClick;
    Act.ActionList:=DinActionList;
//-------------------------------------
    MI:=TMenuItem.Create(Self);
    MI.RadioItem:=True;
    MI.Action:=Act;
    miObject.Add(MI);
//-------------------------------------
    MI:=TMenuItem.Create(Self);
    MI.Action:=Act;
    miNewDinInsert.Add(MI);
  end;
end;

procedure TEditSchemeForm.CalcPasteRect;
var i,k: integer; C: TDinControl;
begin
  PasteRect:=Rect(PanelWidth,PanelHeight,0,0);
  for k:=0 to SelList.Count-1 do
  begin
    C:=SelList[k] as TDinControl;
    i:=DinList.IndexOf(C);
    if i >= 0 then
    begin
      if C.Left < PasteRect.Left then PasteRect.Left:=C.Left;
      if C.Top < PasteRect.Top then PasteRect.Top:=C.Top;
      if C.Left+C.Width > PasteRect.Right then PasteRect.Right:=C.Left+C.Width;
      if C.Top+C.Height > PasteRect.Bottom then PasteRect.Bottom:=C.Top+C.Height;
    end;
  end;
end;

procedure TEditSchemeForm.InsertObjectClick(Sender: TObject);
begin
  (Sender as TAction).Checked:=True;
  Background.Cursor:=crDrag;
end;

procedure TEditSchemeForm.DrawCurrRect;
var Canv: TCanvas; 
begin
  Canv:=TCanvas.Create;
  try
    Canv.Handle:=GetDC(Background.Handle);
    try
      Canv.Pen.Style:=psDot;
      Canv.Pen.Mode:=pmNotXor;
      Canv.Brush.Style:=bsClear;
      Canv.Rectangle(CurRect);
      Canv.Brush.Style:=bsSolid;
      Canv.Pen.Mode:=pmCopy;
      Canv.Pen.Style:=psSolid;
    finally
      ReleaseDC(Background.Handle,Canv.Handle);
    end;
  finally
    Canv.Free;
  end
end;

procedure TEditSchemeForm.BackgroundMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var i: integer; C: TDinControl;
begin
  for i:=0 to SelList.Count-1 do
  begin
    C:=SelList.Items[i] as TDinControl;
    C.Focused:=False;
  end;
  SelList.Clear;
  if Button = mbLeft then
  begin
    Captured:=True;
    SetCapture(Background.Handle);
    Delta:=Point(X,Y);
    SelRect:=Rect(Delta.x,Delta.y,Delta.x,Delta.y);
    CurRect:=SelRect;
    DrawCurrRect;
  end;
  if (Button = mbRight) and (Background.Cursor = crDrag) then
  begin
    Background.Cursor:=crDefault;
    for i:=0 to DinActionList.ActionCount-1 do
      (DinActionList.Actions[i] as TAction).Checked:=False;
  end;
end;

procedure TEditSchemeForm.BackgroundMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var MX,MY: Integer;
begin
  if (ssLeft in Shift) and Captured then
  begin
    DrawCurrRect;
    MX:=X; MY:=Y;
    if MX < 0 then MX:=0;
    if MY < 0 then MY:=0;
    if MX > PanelWidth-1 then MX:=PanelWidth-1;
    if MY > PanelHeight-1 then MY:=PanelHeight-1;
    if (MX<Delta.x) and (MY>Delta.y) then SelRect:=Rect(MX,Delta.y,Delta.x,MY);
    if (MX>Delta.x) and (MY<Delta.y) then SelRect:=Rect(Delta.x,MY,MX,Delta.y);
    if (MX<Delta.x) and (MY<Delta.y) then SelRect:=Rect(MX,MY,Delta.x,Delta.y);
    if (MX>Delta.x) and (MY>Delta.y) then SelRect:=Rect(Delta.x,Delta.y,MX,MY);
    CurRect:=SelRect;
    DrawCurrRect;
  end;
end;

procedure TEditSchemeForm.UnselectAll;
var i: integer;
begin
  for i:=0 to DinList.Count-1 do
    with DinList.Items[i] as TDinControl do Focused:=False;
  SelList.Clear;
end;

procedure TEditSchemeForm.BackgroundMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var i: integer; C: TDinControl; R: TRect; Found: boolean;
begin
  if (Button = mbLeft) and Captured then
  begin
    Captured:=False;
    ReleaseCapture;
    DrawCurrRect;
    if Background.Cursor = crDrag then  // ��������� ������ �����������
    begin
      Found:=False;
      for i:=0 to DinActionList.ActionCount-1 do
      if (DinActionList.Actions[i] as TAction).Checked then
      begin
        (DinActionList.Actions[i] as TAction).Checked:=False;
        Curr:=ADin[i].Name.Create(Self);
        Curr.DinType:=i;
        Curr.Top:=SelRect.Top;
        Curr.Left:=SelRect.Left;
        if (SelRect.Right-SelRect.Left) >= 5 then
          Curr.Width:=SelRect.Right-SelRect.Left;
        if (SelRect.Bottom-SelRect.Top) >= 5 then
            Curr.Height:=SelRect.Bottom-SelRect.Top;
        Curr.Parent:=Background;
        Curr.OnBoundsInfo:=DinBoundsInfo;
        Curr.OnBoundsMove:=DinBoundsMove;
        Curr.OnBoundsSize:=DinBoundsSize;
        Curr.OnPopupMenu:=ShowDinPopupMenu;
        Curr.OnSetFocus:=DinSetFocus;
        Curr.OnDblClick:=miDinDblClick;
        Curr.BringToFront;
        UnselectAll;
        Curr.Focused:=True;
        SelList.Add(Curr);
        Curr.Editing:=True;
        DinList.Add(Curr);
        Found:=True;
        HasChanged:=True;
        Break;
      end;
      if not Found then PasteInPoint(SelRect.Left,SelRect.Top);
      Background.Cursor:=crDefault;
      DinPaste.Checked:=False;
    end
    else
    begin // ����� ����������� ��������������
      for i:=0 to DinList.Count-1 do
      begin
        C:=DinList.Items[i] as TDinControl;
        if IntersectRect(R,SelRect,C.BoundsRect) then
        begin
          C.Focused:=True;
          SelList.Add(C);
        end;
      end;
    end;
  end;
end;

procedure TEditSchemeForm.FormDestroy(Sender: TObject);
begin
  SelList.Free;
  DinList.Free;
  Background.Free;
  ClipboardStream.Free;
end;

procedure TEditSchemeForm.DinSetFocus(Sender: TObject; Shift: TShiftState);
var i: integer; C: TDinControl;
begin
  if Sender <> nil then
  begin
    Curr:=Sender as TDinControl;
    if Background.Cursor = crDrag then
    begin
      Background.Cursor:=crDefault;
      DinPaste.Checked:=False;
      for i:=0 to DinActionList.ActionCount-1 do
        (DinActionList.Actions[i] as TAction).Checked:=False;
    end;
    if ssShift in Shift then
    begin
      if SelList.IndexOf(Curr) < 0 then
      begin
        SelList.Add(Curr);
        Curr.Focused:=True;
      end
      else
      begin
        if SelList.Count > 1 then
        begin
          SelList.Remove(Curr);
          Curr.Focused:=False;
        end;
      end;
    end
    else
      if SelList.IndexOf(Curr) < 0 then
      begin
        UnselectAll;
        Curr.Focused:=True;
        SelList.Add(Curr);
      end;
  end
  else
    UnselectAll;
  SetLength(Rects,SelList.Count);
  for i:=0 to SelList.Count-1 do
  begin
    C:=SelList.Items[i] as TDinControl;
    Rects[i]:=C.BoundsRect;
    CurRect:=Rects[i];
    DrawCurrRect;
  end;
end;

procedure TEditSchemeForm.DinBoundsInfo(Sender: TObject; Left, Top, Width,
  Height: integer);
var i,dX,dY,dW,dH: integer; C: TDinControl; R: TRect; Flag: boolean;
begin
  RemXForm.ShowMessage:=
                Format('��������: %3d, %3d; ������: %3d, %3d; �������: %d',
                [Left,Top,Width,Height,SelList.Count]);
  Flag:=False;
  for i:=0 to SelList.Count-1 do
  begin
    C:=SelList.Items[i] as TDinControl;
    dW:=Rects[i].Right-Rects[i].Left;
    if dW < 16 then
    begin
      Flag:=True;
      dW:=16;
    end;
    dH:=Rects[i].Bottom-Rects[i].Top;
    if dH < 16 then
    begin
      Flag:=True;
      dH:=16;
    end;
    C.SetBounds(Rects[i].Left,Rects[i].Top,dW,dH);
  end;
  SetLength(Rects,SelList.Count);
  for i:=0 to SelList.Count-1 do
  begin
    C:=SelList.Items[i] as TDinControl;
    Rects[i]:=C.BoundsRect;
    CurRect:=Rects[i];
    DrawCurrRect;
  end;
  if Flag then Background.Invalidate;
  R:=Rect(0,0,0,0);
  for i:=0 to SelList.Count-1 do
  begin
    C:=SelList.Items[i] as TDinControl;
    UnionRect(R,R,C.BoundsRect);
  end;
  if R.Left < 0 then dX:=R.Left
  else
    if R.Right > PanelWidth then
      dX:=R.Right-PanelWidth
    else
      dX:=0;
  if R.Top < 0 then dY:=R.Top
  else
    if R.Bottom > PanelHeight then
      dY:=R.Bottom-PanelHeight
    else
      dY:=0;
  if (dX <> 0) or (dY <> 0) then
  begin
    for i:=0 to SelList.Count-1 do
    begin
      C:=SelList.Items[i] as TDinControl;
      C.Left:=C.BoundsRect.Left-dX;
      C.Top:=C.BoundsRect.Top-dY;
    end;
    Panel.StatusBar.Invalidate;
  end;
  HasChanged:=True;
end;

procedure TEditSchemeForm.DinBoundsMove(Sender: TObject; Left, Top,
  Width, Height: integer);
var i: integer;
begin
  for i:=0 to SelList.Count-1 do
  begin
    CurRect:=Rects[i];
    DrawCurrRect;
    OffsetRect(CurRect,-Left,-Top);
    Rects[i]:=CurRect;
    DrawCurrRect;
  end;
end;

procedure TEditSchemeForm.DinBoundsSize(Sender: TObject; Left, Top,
  Width, Height: integer);
var i: integer;
begin
  for i:=0 to SelList.Count-1 do
  begin
    CurRect:=Rects[i];
    DrawCurrRect;
    CurRect.Left:=CurRect.Left-Left;
    CurRect.Top:=CurRect.Top-Top;
    CurRect.Right:=CurRect.Right+Width;
    CurRect.Bottom:=CurRect.Bottom+Height;
    Rects[i]:=CurRect;
    DrawCurrRect;
  end;
end;

procedure TEditSchemeForm.ShowDinPopupMenu(Sender: TObject; X, Y: integer;
  Shift: TShiftState);
begin
  Curr:=Sender as TDinControl;
  DinPopupMenu.PopupComponent:=Curr;
  DinPopupMenu.Popup(
          Shifting.X-ScrollBox.HorzScrollBar.Position+X+Curr.Left,
          Shifting.Y-ScrollBox.VertScrollBar.Position+Y+Curr.Top);
end;

procedure TEditSchemeForm.MIBringToFrontClick(Sender: TObject);
var i: integer;
begin
  i:=DinList.IndexOf(Curr);
  if i>=0 then
  begin
    DinList.Move(i,DinList.Count-1);
    Curr.BringToFront;
    HasChanged:=True;
  end;
end;

procedure TEditSchemeForm.MISendToBackClick(Sender: TObject);
var i: integer;
begin
  i:=DinList.IndexOf(Curr);
  if i>=0 then
  begin
    DinList.Move(i,0);
    Curr.SendToBack;
    HasChanged:=True;
  end;
end;

procedure TEditSchemeForm.DinDeleteExecute(Sender: TObject);
var i,n: integer;
begin
  n:=SelList.Count;
  if RemxForm.ShowQuestion(
        NumToStr(n,'�������','','�','�',False)+' '+
        NumToStr(n,'������','','�','��')+' - �������?') = mrOk then
  begin
    while SelList.Count > 0 do
    begin
      Curr:=SelList[0] as TDinControl;
      SelList.Remove(Curr);
      i:=DinList.IndexOf(Curr);
      if i>=0 then DinList.Delete(i);
      HasChanged:=True;
    end;
    Curr:=nil;
    RemXForm.ShowMessage:=
               NumToStr(n,'������','','�','�',False)+' '+
               NumToStr(n,'������','.','�.','��.');
  end;
end;

procedure TEditSchemeForm.DinDeleteUpdate(Sender: TObject);
begin
  DinDelete.Enabled := (SelList.Count > 0);
end;

procedure TEditSchemeForm.miDinDoubleClick(Sender: TObject);
var i,k: integer; M: TMemoryStream; MS: TStrings; TL: TList;
begin
  MS:=TStringList.Create;
  TL:=TList.Create;
  try
    for k:=0 to SelList.Count-1 do TL.Add(SelList[k]);
    UnselectAll;
    for k:=0 to TL.Count-1 do
    begin
      Curr:=TDinControl(TL[k]);
      i:=DinList.IndexOf(Curr);
      if i >= 0 then
      begin
        M:=TMemoryStream.Create;
        try
          M.WriteComponent(Curr);
          M.Position:=0;
          Curr:=M.ReadComponent(nil) as TDinControl;
          Curr.Editing:=True;
          Curr.Parent:=Background;
          Curr.OnBoundsInfo:=DinBoundsInfo;
          Curr.OnBoundsMove:=DinBoundsMove;
          Curr.OnBoundsSize:=DinBoundsSize;
          Curr.OnPopupMenu:=ShowDinPopupMenu;
          Curr.OnSetFocus:=DinSetFocus;
          Curr.OnDblClick:=miDinDblClick;
          if Curr.Left+Curr.Width >= Self.ClientWidth then
            Curr.Left:=Curr.Left-4
          else
            Curr.Left:=Curr.Left+4;
          if Curr.Top+Curr.Height >= Self.ClientHeight then
            Curr.Top:=Curr.Top-4
          else
            Curr.Top:=Curr.Top+4;
          DinList.Add(Curr);
          MS.AddObject(Curr.Name,Curr);
          Curr.BringToFront;
          Curr.Focused:=True;
          SelList.Add(Curr);
          HasChanged:=True;
        finally
          M.Free;
        end;
      end;
    end;
  finally
    TL.Free;
    MS.Free;
  end;
end;

procedure TEditSchemeForm.miDinPropertyClick(Sender: TObject);
var C: TDinControl;
begin
  C:=DinPopupMenu.PopupComponent as TDinControl;
  if C.ShowEditor then
    HasChanged:=True;
end;

procedure TEditSchemeForm.miDinDblClick(Sender: TObject);
var C: TDinControl;
begin
  C:=Sender as TDinControl;
  if C.ShowEditor then
    HasChanged:=True;
end;

procedure TEditSchemeForm.SelectAllExecute(Sender: TObject);
var i: integer; Curr: TDinControl;
begin
  SelList.Clear;
  for i:=0 to DinList.Count-1 do
  begin
    Curr:=DinList.Items[i] as TDinControl;
    SelList.Add(Curr);
    Curr.Focused:=True;
  end;
end;

procedure TEditSchemeForm.SelectAllUpdate(Sender: TObject);
begin
  SelectAll.Enabled:=(DinList.Count > 0);
end;

procedure TEditSchemeForm.DinPasteExecute(Sender: TObject);
begin
  Background.Cursor:=crDrag;
  DinPaste.Checked:=True;
end;

procedure TEditSchemeForm.DinPasteUpdate(Sender: TObject);
begin
  DinPaste.Enabled:=(ClipboardStream.Size > 0);
end;

procedure TEditSchemeForm.PasteInPoint(X,Y: integer);
var MS: TStrings;
begin
  MS:=TStringList.Create;
  try
    UnselectAll;
    ClipboardStream.Position:=0;
    while ClipboardStream.Position < ClipboardStream.Size do
    begin
      Curr:=ClipboardStream.ReadComponent(nil) as TDinControl;
      Curr.Editing:=True;
      Curr.Parent:=Background;
      Curr.OnBoundsInfo:=DinBoundsInfo;
      Curr.OnBoundsMove:=DinBoundsMove;
      Curr.OnBoundsSize:=DinBoundsSize;
      Curr.OnPopupMenu:=ShowDinPopupMenu;
      Curr.OnSetFocus:=DinSetFocus;
      Curr.OnDblClick:=miDinDblClick;
      Curr.Left:=X+(Curr.Left-PasteRect.Left);
      Curr.Top:=Y+(Curr.Top-PasteRect.Top);
      DinList.Add(Curr);
      MS.AddObject(Curr.Name,Curr);
      Curr.BringToFront;
      Curr.Focused:=True;
      SelList.Add(Curr);
      HasChanged:=True;
    end;
  finally
    MS.Free;
  end;
end;

procedure TEditSchemeForm.miDinAlignToGridClick(Sender: TObject);
var k: integer; C: TDinControl; h: byte;
begin
  h:=Background.GridStep;
  for k:=0 to SelList.Count-1 do
  begin
    C:=SelList[k] as TDinControl;
    C.Left:=Round(C.Left*1.0/h)*h;
    C.Top:=Round(C.Top*1.0/h)*h;
  end;
end;

procedure TEditSchemeForm.DinPopupMenuPopup(Sender: TObject);
begin
  miDinProperty.Enabled:=(SelList.Count = 1);
end;

procedure TEditSchemeForm.DinCutExecute(Sender: TObject);
var i: integer;
begin
  CalcPasteRect;
  ClipboardStream.Clear;
  while SelList.Count > 0 do
  begin
    Curr:=SelList[0] as TDinControl;
    ClipboardStream.WriteComponent(Curr);
    SelList.Remove(Curr);
    i:=DinList.IndexOf(Curr);
    if i>=0 then DinList.Delete(i);
    HasChanged:=True;
  end;
  Curr:=nil;
end;

procedure TEditSchemeForm.DinCutUpdate(Sender: TObject);
begin
  DinCut.Enabled:=(SelList.Count > 0);
end;

procedure TEditSchemeForm.DinCopyExecute(Sender: TObject);
var i,k: integer; C: TDinControl;
begin
  CalcPasteRect;
  ClipboardStream.Clear;
  for k:=0 to SelList.Count-1 do
  begin
    C:=SelList[k] as TDinControl;
    i:=DinList.IndexOf(C);
    if i >= 0 then
      ClipboardStream.WriteComponent(C);
  end;
end;

procedure TEditSchemeForm.DinCopyUpdate(Sender: TObject);
begin
  DinCopy.Enabled:=(SelList.Count > 0);
end;

procedure TEditSchemeForm.SortSelList;
var SL: TStringList; i,k: integer; C: TDinControl;
begin
  SL:=TStringList.Create;
  try
    for k:=0 to SelList.Count-1 do //
    begin
      C:=SelList[k] as TDinControl;
      i:=DinList.IndexOf(C);
      if i >= 0 then SL.AddObject(Format('%3.3d%3.3d',[C.Top,C.Left]),C);
    end;
    SL.Sort;
    SelList.Clear;
    for i:=0 to SL.Count-1 do
      SelList.Add(SL.Objects[i] as TDinControl);
  finally
    SL.Free;
  end;
end;

procedure TEditSchemeForm.miDinAlignmentClick(Sender: TObject);
var i,k,n: integer; C: TDinControl; f: Double;
begin
  with TEditDinAlignmentForm.Create(Self) do
  try
    if ShowModal = mrOk then
    begin
      SortSelList;
      case rgHorizontal.ItemIndex of
       1: begin
            n:=0;
            for k:=0 to SelList.Count-1 do // Left sides
            begin
              C:=SelList[k] as TDinControl;
              i:=DinList.IndexOf(C);
              if i >= 0 then
              begin
                if k = 0 then n:=C.Left else C.Left:=n;
              end;
            end;
          end;
       2: begin // Centers
            n:=0;
            for k:=0 to SelList.Count-1 do
            begin
              C:=SelList[k] as TDinControl;
              i:=DinList.IndexOf(C);
              if i >= 0 then
              begin
                if k = 0 then
                  n:=C.Left+(C.Width div 2)
                else
                  C.Left:=n-(C.Width div 2);
              end;
            end;
          end;
       3: begin
            n:=0;
            for k:=0 to SelList.Count-1 do // Right sides
            begin
              C:=SelList[k] as TDinControl;
              i:=DinList.IndexOf(C);
              if i >= 0 then
              begin
                if k = 0 then
                  n:=C.Left+C.Width
                else
                  C.Left:=n-C.Width;
              end;
            end;
          end;
       4: begin // Space equal
            if SelList.Count > 2 then
            begin
              C:=SelList[0] as TDinControl;
              n:=C.Left+(C.Width div 2);
              C:=SelList[SelList.Count-1] as TDinControl;
              k:=C.Left+(C.Width div 2);
              f:=(k-n)/(SelList.Count-1);
              for k:=1 to SelList.Count-2 do
              begin
                C:=SelList[k] as TDinControl;
                i:=DinList.IndexOf(C);
                if i >= 0 then
                begin
                  n:=Round(n+f);
                  C.Left:=n-(C.Width div 2);
                end;
              end;
            end;
          end;
       5: begin // Window center
            n:=PanelWidth div 2;
            for k:=0 to SelList.Count-1 do
            begin
              C:=SelList[k] as TDinControl;
              i:=DinList.IndexOf(C);
              if i >= 0 then C.Left:=n-(C.Width div 2);
            end;
          end;
      end;
      case rgVertical.ItemIndex of
       1: begin
            n:=0;
            for k:=0 to SelList.Count-1 do // Top sides
            begin
              C:=SelList[k] as TDinControl;
              i:=DinList.IndexOf(C);
              if i >= 0 then
              begin
                if k = 0 then n:=C.Top else C.Top:=n;
              end;
            end;
          end;
       2: begin // Centers
            n:=0;
            for k:=0 to SelList.Count-1 do
            begin
              C:=SelList[k] as TDinControl;
              i:=DinList.IndexOf(C);
              if i >= 0 then
              begin
                if k = 0 then
                  n:=C.Top+(C.Height div 2)
                else
                  C.Top:=n-(C.Height div 2);
              end;
            end;
          end;
       3: begin
            n:=0;
            for k:=0 to SelList.Count-1 do // Bottom sides
            begin
              C:=SelList[k] as TDinControl;
              i:=DinList.IndexOf(C);
              if i >= 0 then
              begin
                if k = 0 then
                  n:=C.Top+C.Height
                else
                  C.Top:=n-C.Height;
              end;
            end;
          end;
       4: begin // Space equal
            if SelList.Count > 2 then
            begin
              C:=SelList[0] as TDinControl;
              n:=C.Top+(C.Height div 2);
              C:=SelList[SelList.Count-1] as TDinControl;
              k:=C.Top+(C.Height div 2);
              f:=(k-n)/(SelList.Count-1);
              for k:=1 to SelList.Count-2 do
              begin
                C:=SelList[k] as TDinControl;
                i:=DinList.IndexOf(C);
                if i >= 0 then
                begin
                  n:=Round(n+f);
                  C.Top:=n-(C.Height div 2);
                end;
              end;
            end;
          end;
       5: begin // Window center
            n:=PanelHeight div 2;
            for k:=0 to SelList.Count-1 do
            begin
              C:=SelList[k] as TDinControl;
              i:=DinList.IndexOf(C);
              if i >= 0 then C.Top:=n-(C.Height div 2);
            end;
          end;
      end;
      HasChanged:=True;
    end;
  finally
    Free;
  end;
end;

procedure TEditSchemeForm.miDinResizeClick(Sender: TObject);
var i,k,n: integer; C: TDinControl;
begin
  with TEditDinSizeForm.Create(Self) do
  try
    if ShowModal = mrOk then
    begin
      case rgWidth.ItemIndex of
       1: begin // Shrink to smallest
            n:=PanelWidth;
            for k:=0 to SelList.Count-1 do // Seek min width
            begin
              C:=SelList[k] as TDinControl;
              i:=DinList.IndexOf(C);
              if i >= 0 then
              begin
                if C.Width < n then n:=C.Width;
              end;
            end;
            for k:=0 to SelList.Count-1 do // Shrink to smallest
            begin
              C:=SelList[k] as TDinControl;
              i:=DinList.IndexOf(C);
              if i >= 0 then C.Width:=n;
            end;
          end;
       2: begin // Grow to largest
            n:=0;
            for k:=0 to SelList.Count-1 do // Seek max width
            begin
              C:=SelList[k] as TDinControl;
              i:=DinList.IndexOf(C);
              if i >= 0 then
              begin
                if C.Width > n then n:=C.Width;
              end;
            end;
            for k:=0 to SelList.Count-1 do // Grow to largest
            begin
              C:=SelList[k] as TDinControl;
              i:=DinList.IndexOf(C);
              if i >= 0 then C.Width:=n;
            end;
          end;
       3: begin // Width
            n:=StrToIntDef(edWidth.Text,0);
            if n >0 then
            for k:=0 to SelList.Count-1 do // Set width
            begin
              C:=SelList[k] as TDinControl;
              i:=DinList.IndexOf(C);
              if i >= 0 then C.Width:=n;
            end;
          end;
      end;
      case rgHeight.ItemIndex of
       1: begin // Shrink to smallest
            n:=PanelHeight;
            for k:=0 to SelList.Count-1 do // Seek min height
            begin
              C:=SelList[k] as TDinControl;
              i:=DinList.IndexOf(C);
              if i >= 0 then
              begin
                if C.Height < n then n:=C.Height;
              end;
            end;
            for k:=0 to SelList.Count-1 do // Shrink to smallest
            begin
              C:=SelList[k] as TDinControl;
              i:=DinList.IndexOf(C);
              if i >= 0 then C.Height:=n;
            end;
          end;
       2: begin // Grow to largest
            n:=0;
            for k:=0 to SelList.Count-1 do // Seek max height
            begin
              C:=SelList[k] as TDinControl;
              i:=DinList.IndexOf(C);
              if i >= 0 then
              begin
                if C.Height > n then n:=C.Height;
              end;
            end;
            for k:=0 to SelList.Count-1 do // Grow to largest
            begin
              C:=SelList[k] as TDinControl;
              i:=DinList.IndexOf(C);
              if i >= 0 then C.Height:=n;
            end;
          end;
       3: begin // Height
            n:=StrToIntDef(edHeight.Text,0);
            if n >0 then
            for k:=0 to SelList.Count-1 do // Set height
            begin
              C:=SelList[k] as TDinControl;
              i:=DinList.IndexOf(C);
              if i >= 0 then C.Height:=n;
            end;
          end;
      end;
      HasChanged:=True;
    end;
  finally
    Free;
  end;
end;

procedure SaveSchemeToFile(FileName: string; Background: TBackground;
                           DinList: TComponentList; var HasChanged: boolean);
var AF,M: TMemoryStream; CRC32: Cardinal; PtClass,BackName: string;
    F: TFileStream; i: integer; C: TDinControl;
begin
  Screen.Cursor:=crHourGlass;
  try
    M:=TMemoryStream.Create;
    AF:=TMemoryStream.Create;
    try
      Background.SaveToStream(AF);
      for i:=0 to DinList.Count-1 do
      begin
        C:=DinList.Items[i] as TDinControl;
        C.SaveToStream(AF);
      end;
      if AF.Size > 0 then
      begin
        AF.Position:=0;
        M.Clear;
        CompressStream(AF,M);
        M.Position:=0;
      end
      else
        M.Clear;
      CRC32:=0; CalcCRC32(M.Memory,M.Size,CRC32);
      PtClass:=FileName;
      BackName:=ChangeFileExt(FileName,'.~SCM');
      if FileExists(BackName) and DeleteFile(BackName) or
         not FileExists(BackName) then
      begin
        if FileExists(FileName) and RenameFile(FileName,BackName) or
           not FileExists(FileName) then
        begin
          if M.Size = 0 then
          begin
            if FileExists(PtClass) then DeleteFile(PtClass);
          end
          else
          if DirectoryExists(ExtractFilePath(FileName)) then
          begin
            try
              F:=TFileStream.Create(PtClass,fmCreate or fmShareExclusive);
            except
              RemXForm.ShowWarning('���� "'+ExtractFileName(PtClass)+
                      '" ����� ������ ���������. ���������� ��� ���.');
              Exit;
            end;
            try
              F.WriteBuffer(CRC32,SizeOf(CRC32));
              M.SaveToStream(F);
            finally
              F.Free;
            end;
          end;
        end;
      end;
    finally
      AF.Free;
      M.Free;
    end;
    HasChanged:=False;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure SaveSchemeToText(FileName: string; Background: TBackground;
                           DinList: TComponentList);
var BackName: string;
    i: integer;
    C: TDinControl;
    MF: TMemInifile;
begin
  Screen.Cursor:=crHourGlass;
  MF:=TMemInifile.Create('');
  try
    Background.SaveToIniFile(MF);
    for i:=0 to DinList.Count-1 do
    begin
      C:=DinList.Items[i] as TDinControl;
      C.SaveToIniFile(MF);
    end;
    FileName:=ChangeFileExt(FileName,'.tsc');
    BackName:=ChangeFileExt(FileName,'.~tsc');
    if FileExists(BackName) and DeleteFile(BackName) or
       not FileExists(BackName) then
    begin
      if FileExists(FileName) and RenameFile(FileName,BackName) or
         not FileExists(FileName) then
      begin
        if DirectoryExists(ExtractFilePath(FileName)) then
        begin
          try
            MF.Rename(FileName,False);
            MF.UpdateFile;
          except
            RemXForm.ShowWarning('���� "'+ExtractFileName(FileName)+
                    '" ����� ������ ���������. ���������� ��� ���.');
            Exit;
          end;
        end;
      end;
    end;
  finally
    MF.Free;
    Screen.Cursor:=crDefault;
  end;
end;

procedure TEditSchemeForm.LoadSchemeFromFile(FileName: string);
var DinType: byte; M: TMemoryStream; P: Int64; C: TDinControl;
begin
  Screen.Cursor:=crHourGlass;
  try
    DinList.Clear;
    Background.Clear;
    M:=TMemoryStream.Create;
    try
      if LoadStream(FileName,M) then
      begin
        Background.LoadFromStream(M);
        if M.Size >= SizeOf(DinType) then
        while M.Position < M.Size do
        begin
          P:=M.Position;
          M.ReadBuffer(DinType,SizeOf(DinType));
          M.Position:=P;
          try
            C:=ADin[DinType].Name.Create(Self);
            C.DinType:=DinType;
            C.Parent:=Background;
            C.OnBoundsInfo:=DinBoundsInfo;
            C.OnBoundsMove:=DinBoundsMove;
            C.OnBoundsSize:=DinBoundsSize;
            C.OnPopupMenu:=ShowDinPopupMenu;
            C.OnSetFocus:=DinSetFocus;
            C.OnDblClick:=miDinDblClick;
            C.Editing:=True;
            DinList.Add(C);
          except
            C:=nil;
          end;
          if Assigned(C) then
          begin
            if C.LoadFromStream(M) = 0  then Break;
          end
          else
            Break;
        end;
        CurrFileName:=FileName;
      end
      else
        RemXForm.ShowError('������ ��� �������� ����� "'+
                            ExtractFileName(FileName)+'"');
    finally
      M.Free;
    end;
    HasChanged:=False;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TEditSchemeForm.SchemeNewExecute(Sender: TObject);
begin
  CheckSaved;
  CurrFileName:='';
  DinList.Clear;
  Background.Clear;
  HasChanged:=False;
end;

procedure TEditSchemeForm.FreshView;
var i: integer; C: TDinControl;
begin
  for i:=0 to DinList.Count-1 do
  begin
    C:=DinList.Items[i] as TDinControl;
    C.UpdateData(@GetParamVal);
  end;
end;

procedure TEditSchemeForm.SchemeSaveExecute(Sender: TObject);
var FileName: string;
begin
  FileName:=CurrFileName;
  if Trim(FileName) = '' then
    actSchemeSaveAs.Execute
  else
    if RemxForm.ShowQuestion(
        '�������� ���������� � ���� "'+FileName+'"?')=mrOK then
    begin
      SaveSchemeToFile(FileName,Background,DinList,HasChanged);
      SaveSchemeToText(FileName,Background,DinList);
    end;
end;

procedure TEditSchemeForm.SchemeSaveUpdate(Sender: TObject);
begin
  SchemeSave.Enabled:=HasChanged;
end;

procedure TEditSchemeForm.miCloseClick(Sender: TObject);
begin
  CheckSaved;
  Panel.actOverview.Execute;
end;

procedure TEditSchemeForm.mi16dotClick(Sender: TObject);
begin
  mi4dot.Checked:=False;
  mi8dot.Checked:=False;
  mi10dot.Checked:=False;
  mi16dot.Checked:=False;
  with Sender as TMenuItem do
  begin
    Checked:=True;
    Background.GridStep:=Tag;
    Background.Invalidate;
  end;
end;

procedure TEditSchemeForm.actShowGridExecute(Sender: TObject);
begin
  Background.ShowGrid:=not Background.ShowGrid;
  Background.Invalidate;
end;

procedure TEditSchemeForm.actShowGridUpdate(Sender: TObject);
begin
  actShowGrid.Checked:=Background.ShowGrid;
end;

procedure TEditSchemeForm.actOpenBackgroundExecute(Sender: TObject);
begin
  OpenExtDialogForm:=TOpenExtDialogForm.Create(Self);
  try
    OpenExtDialogForm.Filter:='��� ����� '+
                            '(*.jpg;*.jpeg;*.bmp;*.ico;*.emf;*.wmf;*.png)|'+
                            '*.jpg;*.jpeg;*.bmp;*.ico;*.emf;*.wmf;*.png|'+
                            '����� JPEG (*.jpg)|*.jpg|'+
                            '����� JPEG (*.jpeg)|*.jpeg|'+
                            '����� BITMAP (*.bmp)|*.bmp|'+
                            '����� ICO (*.ico)|*.ico|'+
                            '����� METAFILE (*.emf)|*.emf|'+
                            '����� METAFILE (*.wmf)|*.wmf|'+
                            '����� PNG (*.png)|*.png';
    if OpenExtDialogForm.Execute then
    begin
      Background.LoadFromFile(OpenExtDialogForm.FileName);
      HasChanged:=True;
    end;
  finally
    OpenExtDialogForm.Free;
  end;
end;

procedure TEditSchemeForm.actDeleteBackgroundExecute(Sender: TObject);
begin
  if RemXForm.ShowQuestion('������� ������� ��������?') = mrOk then
  begin
    Background.Clear;
    HasChanged:=True;
  end;
end;

procedure TEditSchemeForm.actSaveBackgroundAsExecute(Sender: TObject);
var S,W1,W2,Ext: string;
begin
  SaveExtDialogForm:=TSaveExtDialogForm.Create(Self);
  try
    SaveExtDialogForm.Filter:='��� ����� '+
                            '(*.jpg;*.jpeg;*.bmp;*.ico;*.emf;*.wmf;*.png)|'+
                            '*.jpg;*.jpeg;*.bmp;*.ico;*.emf;*.wmf;*.png|'+
                            '����� JPEG (*.jpg)|*.jpg|'+
                            '����� JPEG (*.jpeg)|*.jpeg|'+
                            '����� BITMAP (*.bmp)|*.bmp|'+
                            '����� ICO (*.ico)|*.ico|'+
                            '����� METAFILE (*.emf)|*.emf|'+
                            '����� METAFILE (*.wmf)|*.wmf|'+
                            '����� PNG (*.png)|*.png';
    SaveExtDialogForm.InitialDir:=Caddy.CurrentSchemsPath;
    if FirstBackgroundSave then
    begin
      FirstBackgroundSave:=False;
      OriginalFilter:=SaveExtDialogForm.Filter;
    end;
    Ext:=Background.PictExt;
    SaveExtDialogForm.DefaultExt:=Ext;
    S:=OriginalFilter;
    while Length(S) > 0 do
    begin
      if Pos('|',S) > 0 then
      begin
        W1:=Copy(S,1,Pos('|',S)-1);
        Delete(S,1,Pos('|',S));
      end
      else
      begin
        W1:=S;
        S:='';
      end;
      if Pos('|',S) > 0 then
      begin
        W2:=Copy(S,1,Pos('|',S)-1);
        Delete(S,1,Pos('|',S));
      end
      else
      begin
        W2:=S;
        S:='';
      end;
      if not ((Pos('All',W1) = 1) or (Pos('���',W1) = 1)) and
         (Pos(Ext,W2) > 0) then
      begin
        SaveExtDialogForm.Filter:=W1+'|'+W2;
        Break;
      end;
    end;
    if SaveExtDialogForm.Execute then
      Background.SaveToFile(SaveExtDialogForm.FileName);
  finally
    SaveExtDialogForm.Free;
  end;
end;

procedure TEditSchemeForm.actDeleteBackgroundUpdate(Sender: TObject);
begin
  actDeleteBackground.Enabled:=not Background.Empty;
end;

procedure TEditSchemeForm.actSaveBackgroundAsUpdate(Sender: TObject);
begin
  actSaveBackgroundAs.Enabled:=not Background.Empty;
end;

procedure TEditSchemeForm.actBackgroundColorExecute(Sender: TObject);
begin
  ColorDialog.Color:=Background.Color;
  if ColorDialog.Execute then
  begin
    Background.Color:=ColorDialog.Color;
    HasChanged:=True;
  end;
end;

procedure TEditSchemeForm.BackgrounbPictTileExecute(Sender: TObject);
begin
  BackgrounbPictTile.Checked:=not BackgrounbPictTile.Checked;
  Background.PictTile:=BackgrounbPictTile.Checked;
  HasChanged:=True;
end;

procedure TEditSchemeForm.BackgrounbPictTileUpdate(Sender: TObject);
begin
  BackgrounbPictTile.Checked:=Background.PictTile;
  BackgrounbPictTile.Enabled:=not Background.Empty;
end;

procedure TEditSchemeForm.SchemPopupMenuPopup(Sender: TObject);
var i: integer; C: TDinControl;
begin
  for i:=0 to SelList.Count-1 do
  begin
    C:=SelList.Items[i] as TDinControl;
    C.Focused:=False;
  end;
  SelList.Clear;
end;

procedure TEditSchemeForm.FormResize(Sender: TObject);
begin
  SchemeToolMenu.Left:=0;
  SchemeToolMenu.Left:=SchemeToolBar.Width;
  EditToolBar.Left:=SchemeToolMenu.Width+SchemeToolBar.Width;
end;

procedure TEditSchemeForm.CheckSaved;
begin
  if SchemeSave.Enabled and
    (RemxForm.ShowQuestion('��������� ��������� �� ��������!'+
               #13+'�������� ��������� � ����?')=mrOK) then
      SchemeSave.Execute;
end;

procedure TEditSchemeForm.ColorDialogShow(Sender: TObject);
var R: TRect; W,H: integer;
begin
  if GetWindowRect((Sender as TCommonDialog).Handle,R) then
  begin
    W := R.Right-R.Left;
    H := R.Bottom-R.Top;
    R.Left := Panel.Left + (Panel.Width - W) div 2;
    R.Top := Panel.Top + (Panel.Height - H) div 2;
    SetWindowPos((Sender as TCommonDialog).Handle,HWND_TOP,R.Left,R.Top,
                 0,0,SWP_NOSIZE);
  end;
end;

procedure TEditSchemeForm.OpenPictureDialogShow(Sender: TObject);
var R: TRect; W,H: integer;
begin
  if GetWindowRect((Sender as TCommonDialog).Handle,R) then
  begin
    W:=R.Right-R.Left;
    H:=R.Bottom-R.Top;
    R.Left := Panel.Left + (Panel.Width - W) div 2;
    R.Top := Panel.Top + (Panel.Height - H) div 2;
    SetWindowPos((Sender as TCommonDialog).Handle,HWND_TOP,R.Left,R.Top,
                 0,0,SWP_NOSIZE);
  end;
end;

procedure TEditSchemeForm.SavePictureDialogShow(Sender: TObject);
var R: TRect; W,H: integer;
begin
  if GetWindowRect((Sender as TCommonDialog).Handle,R) then
  begin
    W:=R.Right-R.Left;
    H:=R.Bottom-R.Top;
    R.Left := Panel.Left + (Panel.Width - W) div 2;
    R.Top := Panel.Top + (Panel.Height - H) div 2;
    SetWindowPos((Sender as TCommonDialog).Handle,HWND_TOP,R.Left,R.Top,
                 0,0,SWP_NOSIZE);
  end;
end;

procedure TEditSchemeForm.actSchemeOpenExecute(Sender: TObject);
begin
  OpenDialogForm:=TOpenDialogForm.Create(Self);
  try
    OpenDialogForm.InitialDir:=Caddy.CurrentSchemsPath;
    OpenDialogForm.Filter:='*.SCM';
    OpenDialogForm.FileName:=CurrFileName;
    if OpenDialogForm.Execute then
    begin
      Update;
      CheckSaved;
      if UpperCase(ExtractFileExt(OpenDialogForm.FileName)) = '.SCM' then
        LoadSchemeFromFile(OpenDialogForm.FileName);
    end;
  finally
    OpenDialogForm.Free;
  end;
end;

procedure TEditSchemeForm.actSchemeSaveAsExecute(Sender: TObject);
begin
  SaveExtDialogForm:=TSaveExtDialogForm.Create(Self);
  try
    SaveExtDialogForm.Filter:='���������� (*.SCM)|*.scm';
    SaveExtDialogForm.InitialDir:=Caddy.CurrentSchemsPath;
    SaveExtDialogForm.FileName:=CurrFileName;
    SaveExtDialogForm.DefaultExt:='.scm';
    if SaveExtDialogForm.Execute then
    begin
      SaveSchemeToFile(SaveExtDialogForm.FileName,Background,DinList,HasChanged);
      SaveSchemeToText(SaveExtDialogForm.FileName,Background,DinList);
      CurrFileName:=SaveExtDialogForm.FileName;
    end;
  finally
    SaveExtDialogForm.Free;
  end;
end;

procedure TEditSchemeForm.actOrderListExecute(Sender: TObject);
var i,j: integer; WC: TGraphicControl; s: string;
begin
  TabOrderForm:=TTabOrderForm.Create(Self);
  try
    with TabOrderForm do
    begin
      for i:=0 to DinList.Count-1 do
      begin
        WC:=DinList.Items[i] as TGraphicControl;
        s:='��� ��������';
        for j:=0 to Length(ADin)-1 do
          if WC.ClassType = ADin[j].Name then
          begin
            s:=Format('[L:%3.3d,C:%3.3d] ',
                      [WC.Top,WC.Left])+ADin[j].ShortCaption;
            if WC is TDinJump then
              s:=s+': '+(WC as TDinJump).ScreenName
            else
            if WC is TDinText then
            with WC as TDinText do
            begin
              if IsLinked then
                s:=s+': '+Text0+'/'+Text1+' <'+LinkName+'> '+' - '+LinkDesc
              else
                s:=s+': '+Text;
            end
            else
            if WC is TDinButton then
            with WC as TDinButton do
            begin
              if IsLinked then
                s:=s+': '+Text+' <'+LinkName+'> '+' - '+LinkDesc
              else
                s:=s+': '+Text;
            end
            else
            if WC is TDinControl then
            with WC as TDinControl do
              s:=s+': <'+LinkName+'> - '+LinkDesc;
            Break;
          end;
        ListBox.Items.AddObject(s,DinList.Items[i]);
      end;
      if ShowModal = mrOk then
      begin
        for i:=0 to ListBox.Items.Count-1 do
        begin
          j:=DinList.IndexOf(ListBox.Items.Objects[i] as TComponent);
          if j >= 0 then DinList.Exchange(i,j);
        end;
        HasChanged:=True;
      end;
    end;
  finally
    TabOrderForm.Free;
  end;
end;

procedure TEditSchemeForm.SelectDin(var Msg: TMessage);
var i: integer;
begin
  i:=DinList.IndexOf(TComponent(Msg.LParam));
  if (i >= 0) and (i < DinList.Count) then
  begin
    Curr:=DinList.Items[i] as TDinControl;
    Curr.SetFocus;
  end;  
end;

procedure TEditSchemeForm.SetPanel(const Value: TPanelForm);
begin
  FPanel := Value;
  Shifting.X := FPanel.Left;
  Shifting.Y := FPanel.Top + FPanel.TopScrollBox.Height +
                FPanel.ActionMainMenuBar.Height + SchemeControlBar.Height;
end;

procedure TEditSchemeForm.FormMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  if ssAlt in Shift then
  begin
    ScrollBox.HorzScrollBar.Position:=ScrollBox.HorzScrollBar.Position-WheelDelta;
  end
  else
    ScrollBox.VertScrollBar.Position:=ScrollBox.VertScrollBar.Position-WheelDelta;
  Handled:=False;
end;

end.
