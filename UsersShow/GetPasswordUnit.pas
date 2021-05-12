unit GetPasswordUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AppEvnts, ExtCtrls;

type
  TGetPasswordForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
  private
  public
  end;

var
  GetPasswordForm: TGetPasswordForm;

implementation

{$R *.dfm}

end.
