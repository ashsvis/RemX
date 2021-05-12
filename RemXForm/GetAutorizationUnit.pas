unit GetAutorizationUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TGetAutorizationForm = class(TForm)
    leUser: TLabeledEdit;
    leComputer: TLabeledEdit;
    leAutorization: TLabeledEdit;
    Button1: TButton;
    Button2: TButton;
    Bevel1: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure leUserExit(Sender: TObject);
  private
  public
  end;

var
  GetAutorizationForm: TGetAutorizationForm;

implementation

uses EntityUnit, RemXUnit;

{$R *.dfm}

procedure TGetAutorizationForm.FormCreate(Sender: TObject);
var User: string;
begin
  User:=Config.ReadString('UserInfo','Name','');
  leUser.Text:=User;
  if Length(User) > 0 then
    leComputer.Text:=Format('%x',[RemXForm.UserInformation(User)]);
  leAutorization.Text:=Config.ReadString('UserInfo','Key','');
end;

procedure TGetAutorizationForm.leUserExit(Sender: TObject);
begin
  if Length(leUser.Text) > 0 then
    leComputer.Text:=Format('%x',[RemXForm.UserInformation(leUser.Text)])
  else
    leComputer.Text:='';
end;

end.
