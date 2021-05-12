unit FindDialogUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFindDialogForm = class(TForm)
    leFindExample: TLabeledEdit;
    FindNextButton: TButton;
    CancelButton: TButton;
    cbWordOnly: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure rgDirectionClick(Sender: TObject);
    procedure FindNextButtonClick(Sender: TObject);
    procedure cbWordOnlyClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure leFindExampleChange(Sender: TObject);
  private
    FOptions: TFindOptions;
    FOnFind: TNotifyEvent;
    function GetFindText: string;
    procedure SetFindText(const Value: string);
  public
    function Execute: boolean;
    procedure CloseDialog;
  published
    property FindText: string read GetFindText write SetFindText;
    property Options: TFindOptions read FOptions write FOptions default [frDown];
    property OnFind: TNotifyEvent read FOnFind write FOnFind;
  end;

//var
//  FindDialogForm: TFindDialogForm;

implementation



{$R *.dfm}

{ TFindDialogForm }

procedure TFindDialogForm.CloseDialog;
begin
  Exclude(FOptions,frFindNext);
  Close;
end;

function TFindDialogForm.Execute: boolean;
begin
  FindNextButton.Caption:='Найти';
  Exclude(FOptions,frFindNext);
  Include(FOptions,frDown);
  Result := (ShowModal = mrOk);
end;

procedure TFindDialogForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:=caHide;
end;

function TFindDialogForm.GetFindText: string;
begin
  Result:=leFindExample.Text;
end;

procedure TFindDialogForm.SetFindText(const Value: string);
begin
  leFindExample.Text:=Value;
end;

procedure TFindDialogForm.rgDirectionClick(Sender: TObject);
begin
  Exclude(FOptions,frFindNext);
  FindNextButton.Caption:='Найти';
  Include(FOptions,frDown);
//  case rgDirection.ItemIndex of
//   0: Exclude(FOptions,frDown);
//   1: Include(FOptions,frDown);
//  end;
end;

procedure TFindDialogForm.FindNextButtonClick(Sender: TObject);
begin
  if Assigned(FOnFind) then
     FOnFind(Self);
  Include(FOptions,frFindNext);
  FindNextButton.Caption:='Найти далее';
end;

procedure TFindDialogForm.cbWordOnlyClick(Sender: TObject);
begin
  if cbWordOnly.Checked then
    Include(FOptions,frWholeWord)
  else
    Exclude(FOptions,frWholeWord);
end;

procedure TFindDialogForm.FormCreate(Sender: TObject);
begin
  FOptions:=[frDown];
end;

procedure TFindDialogForm.leFindExampleChange(Sender: TObject);
begin
  Exclude(FOptions,frFindNext);
  FindNextButton.Caption:='Найти';
  Include(FOptions,frDown);
end;

end.
