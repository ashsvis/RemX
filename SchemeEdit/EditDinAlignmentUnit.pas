unit EditDinAlignmentUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TEditDinAlignmentForm = class(TForm)
    rgHorizontal: TRadioGroup;
    rgVertical: TRadioGroup;
    ButtonOk: TButton;
    ButtonCancel: TButton;
  private
  public
  end;

var
  EditDinAlignmentForm: TEditDinAlignmentForm;

implementation

{$R *.dfm}

end.
