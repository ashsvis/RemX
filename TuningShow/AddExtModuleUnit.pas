unit AddExtModuleUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TAddExtModuleForm = class(TForm)
    Label1: TLabel;
    edMenuName: TEdit;
    Label2: TLabel;
    edProgramPath: TEdit;
    Label3: TLabel;
    edWorkPath: TEdit;
    Label4: TLabel;
    cbLevel: TComboBox;
    btOk: TButton;
    btCancel: TButton;
    sbPathSelect: TSpeedButton;
    procedure edProgramPathEnter(Sender: TObject);
    procedure edWorkPathEnter(Sender: TObject);
    procedure edProgramPathExit(Sender: TObject);
    procedure sbPathSelectClick(Sender: TObject);
  private
  public
  end;

var
  AddExtModuleForm: TAddExtModuleForm;

implementation

uses FileCtrl, OpenExtDialogUnit;

{$R *.dfm}

procedure TAddExtModuleForm.edProgramPathEnter(Sender: TObject);
begin
  sbPathSelect.Parent:=edProgramPath;
  sbPathSelect.Top:=0;
  sbPathSelect.Left:=edProgramPath.Width-sbPathSelect.Width-4;
  sbPathSelect.Visible:=True;
end;

procedure TAddExtModuleForm.edWorkPathEnter(Sender: TObject);
begin
  sbPathSelect.Parent:=edWorkPath;
  sbPathSelect.Top:=0;
  sbPathSelect.Left:=edWorkPath.Width-sbPathSelect.Width-4;
  sbPathSelect.Visible:=True;
end;

procedure TAddExtModuleForm.edProgramPathExit(Sender: TObject);
begin
  sbPathSelect.Visible:=False;
  sbPathSelect.Parent:=Self;
end;

procedure TAddExtModuleForm.sbPathSelectClick(Sender: TObject);
var Dir: string;
begin
  if sbPathSelect.Parent=edWorkPath then
  begin
    if SelectDirectory('Выбор папки','', Dir) then
      (sbPathSelect.Parent as TEdit).Text:=Dir;
  end;
  if sbPathSelect.Parent=edProgramPath then
  begin
    OpenExtDialogForm:=TOpenExtDialogForm.Create(Self);
    try
      OpenExtDialogForm.Filter:='Исполняемые файлы (*.exe)|*.exe';
      OpenExtDialogForm.InitialDir:=edWorkPath.Text;
      OpenExtDialogForm.FileName:=(sbPathSelect.Parent as TEdit).Text;
      if OpenExtDialogForm.Execute then
      begin
        (sbPathSelect.Parent as TEdit).Text:=OpenExtDialogForm.FileName;
        edWorkPath.Text:=ExtractFileDir(OpenExtDialogForm.FileName);
      end;
    finally
      OpenExtDialogForm.Free;
    end;
  end;
end;

end.
