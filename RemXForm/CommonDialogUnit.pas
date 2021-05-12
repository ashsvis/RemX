unit CommonDialogUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ImgList, StdCtrls;

type
  TCommonDialogForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    TextLabel: TLabel;
    ImageList1: TImageList;
    Image1: TImage;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    procedure SetCursor(var Mess: TMessage); message WM_USER;
  public
  end;

implementation

{$R *.dfm}

procedure TCommonDialogForm.Timer1Timer(Sender: TObject);
begin
  if Button2.Visible then
    Button2.Click
  else
    Button1.Click;
end;

procedure TCommonDialogForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:=caHide;
end;

procedure TCommonDialogForm.SetCursor(var Mess: TMessage);
var P: TPoint;
begin
  if Button2.Visible then
  begin
    P:=Button2.ClientToScreen(Point(Button2.Width div 2,Button2.Height div 2));
    SetCursorPos(P.X,P.Y);
  end
  else
  begin
    P:=Button1.ClientToScreen(Point(Button1.Width div 2,Button1.Height div 2));
    SetCursorPos(P.X,P.Y);
  end;
end;

procedure TCommonDialogForm.FormShow(Sender: TObject);
begin
//  PostMessage(Handle,WM_USER,0,Integer(Self));
end;

end.
