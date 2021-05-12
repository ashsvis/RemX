unit EditDinSizeUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TEditDinSizeForm = class(TForm)
    rgWidth: TRadioGroup;
    rgHeight: TRadioGroup;
    ButtonOk: TButton;
    ButtonCancel: TButton;
    edWidth: TEdit;
    edHeight: TEdit;
    procedure edWidthEnter(Sender: TObject);
    procedure rgWidthClick(Sender: TObject);
    procedure edHeightEnter(Sender: TObject);
    procedure rgHeightClick(Sender: TObject);
  private
  public
  end;

var
  EditDinSizeForm: TEditDinSizeForm;

implementation

{$R *.dfm}

procedure TEditDinSizeForm.edWidthEnter(Sender: TObject);
begin
  rgWidth.ItemIndex:=3;
end;

procedure TEditDinSizeForm.rgWidthClick(Sender: TObject);
begin
  if rgWidth.ItemIndex < 3 then edWidth.Text:='';
end;

procedure TEditDinSizeForm.edHeightEnter(Sender: TObject);
begin
  rgHeight.ItemIndex:=3;
end;

procedure TEditDinSizeForm.rgHeightClick(Sender: TObject);
begin
  if rgHeight.ItemIndex < 3 then edHeight.Text:='';
end;

end.
