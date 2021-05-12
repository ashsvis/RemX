unit OpenExtDialogUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FileCtrl, AppEvnts;

type
  TOpenExtDialogForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    FileListBox1: TFileListBox;
    DirectoryListBox1: TDirectoryListBox;
    DriveComboBox1: TDriveComboBox;
    FilterComboBox1: TFilterComboBox;
    Edit1: TEdit;
    ApplicationEvents1: TApplicationEvents;
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure FileListBox1Change(Sender: TObject);
  private
  public
    FileName: string;
    Filter: string;
    InitialDir: string;
    DefaultExt: string;
    function Execute: boolean;
  end;

var
  OpenExtDialogForm: TOpenExtDialogForm;

implementation



{$R *.dfm}

{ TOpenExtDialogForm }

function TOpenExtDialogForm.Execute: boolean;
begin
  FilterComboBox1.Filter:=Filter;
  DirectoryListBox1.Directory:=InitialDir;
  FileListBox1.FileName:=FileName;
  Result:=(ShowModal = mrOk);
  if Result then
  begin
    InitialDir:=DirectoryListBox1.Directory;
    FileName:=IncludeTrailingPathDelimiter(InitialDir)+Edit1.Text;
  end
end;

procedure TOpenExtDialogForm.ApplicationEvents1Idle(Sender: TObject;
  var Done: Boolean);
begin
  Button1.Enabled:=(Pos('*',Edit1.Text) = 0) and
     FileExists(IncludeTrailingPathDelimiter(DirectoryListBox1.Directory)+
                                            Edit1.Text);
end;

procedure TOpenExtDialogForm.FileListBox1Change(Sender: TObject);
begin
  Edit1.Text:=ExtractFileName(FileListBox1.FileName);
end;

end.
