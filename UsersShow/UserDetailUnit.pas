unit UserDetailUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, AppEvnts, ExtCtrls;

type
  TUserDetailForm = class(TForm)
    Label1: TLabel;
    UserFamily: TEdit;
    Label2: TLabel;
    UserName: TEdit;
    Label3: TLabel;
    UserSecondName: TEdit;
    Label4: TLabel;
    UserPassword: TEdit;
    Label5: TLabel;
    UserConfirm: TEdit;
    OkButton: TBitBtn;
    CancelButton: TBitBtn;
    Label6: TLabel;
    UserCategory: TComboBox;
    Bevel1: TBevel;
    procedure UserFamilyChange(Sender: TObject);
  private
  public
  end;

var
  UserDetailForm: TUserDetailForm;

implementation

{$R *.DFM}

procedure TUserDetailForm.UserFamilyChange(Sender: TObject);
begin
  if (UserFamily.Text<>'') and
     (UserFamily.Text<>'Администратор') and
     (UserName.Text<>'') and
     (UserSecondName.Text<>'') and
     (UserCategory.ItemIndex<>-1) and
     (UserPassword.Text<>'') and
     (UserConfirm.Text<>'') and
     (UserPassword.Text=UserConfirm.Text) then
    OkButton.Enabled:=True
  else
    OkButton.Enabled:=False;
end;

end.
