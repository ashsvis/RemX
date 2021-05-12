unit ShowPreviewUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ComCtrls, ToolWin, AppEvnts, ImgList, ActnList,
  ExtCtrls, FR_View, Printers;

type
  TShowPreviewForm = class(TForm)
    ActionList: TActionList;
    PrintAction: TAction;
    ImageList: TImageList;
    ApplicationEvents: TApplicationEvents;
    ToolBar: TToolBar;
    tbZoomIn: TToolButton;
    tbZoomOut: TToolButton;
    ToolButton1: TToolButton;
    ToolButton3: TToolButton;
    tbPrint: TToolButton;
    frAllPreview: TfrPreview;
    ToolButton2: TToolButton;
    procedure sbBackwardClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PrintActionExecute(Sender: TObject);
    procedure tbZoomInClick(Sender: TObject);
    procedure tbZoomOutClick(Sender: TObject);
    procedure ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
  private
    FPanel: TForm;
  public
    MasterAction: TAction;
    property Panel: TForm read FPanel write FPanel;
  end;

implementation

uses RemXUnit;

{$R *.dfm}

procedure TShowPreviewForm.sbBackwardClick(Sender: TObject);
begin
  if Assigned(MasterAction) then MasterAction.Execute;
end;

procedure TShowPreviewForm.FormCreate(Sender: TObject);
begin
  MasterAction:=nil;
end;

procedure TShowPreviewForm.PrintActionExecute(Sender: TObject);
begin
  Printer.Refresh;
  if Printer.Printers.Count = 0 then
  begin
    RemxForm.ShowError('Нет установленных принтеров в системе.');
    Exit;
  end;
//  try
//    Printer.PrinterIndex:=-1;
//  except
//    RemxForm.ShowError('Не выбран принтер по умолчанию!');
//    Exit;
//  end;
  frAllPreview.Print;
end;

procedure TShowPreviewForm.tbZoomInClick(Sender: TObject);
begin
  frAllPreview.Zoom:=frAllPreview.Zoom+10.0;
end;

procedure TShowPreviewForm.tbZoomOutClick(Sender: TObject);
begin
  frAllPreview.Zoom:=frAllPreview.Zoom-10.0;
end;

procedure TShowPreviewForm.ApplicationEventsIdle(Sender: TObject;
  var Done: Boolean);
begin
  if CanFocus then
  begin
    tbZoomIn.Enabled:=(frAllPreview.Zoom < 200.0);
    tbZoomOut.Enabled:=(frAllPreview.Zoom > 10.0);
  end;
end;

end.
