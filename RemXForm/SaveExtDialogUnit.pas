unit SaveExtDialogUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FileCtrl, AppEvnts;

type
  TSaveExtDialogForm = class(TForm)
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
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
  public
    FileName: string;
    Filter: string;
    InitialDir: string;
    DefaultExt: string;
    function Execute: boolean;
  end;

var
  SaveExtDialogForm: TSaveExtDialogForm;

implementation

var OldInitialDir : string;

{$R *.dfm}

{ TSaveExtDialogForm }

function TSaveExtDialogForm.Execute: boolean;
begin
  FilterComboBox1.Filter:=Filter;
  if ForceDirectories(InitialDir) then
  begin
    DirectoryListBox1.Directory:=InitialDir;
    if FileExists(FileName) then
      FileListBox1.FileName:=FileName;
    Result:=(ShowModal = mrOk);
    if Result then
    begin
      InitialDir:=DirectoryListBox1.Directory;
      if Pos('.',Edit1.Text) = 0 then Edit1.Text:=Edit1.Text+DefaultExt;
      FileName:=IncludeTrailingPathDelimiter(InitialDir)+Edit1.Text;
    end
  end
  else
    Result:=False;
end;

procedure TSaveExtDialogForm.ApplicationEvents1Idle(Sender: TObject;
  var Done: Boolean);
begin
  Button1.Enabled:=Trim(Edit1.Text) <> '';
end;

procedure TSaveExtDialogForm.FileListBox1Change(Sender: TObject);
begin
  Edit1.Text:=ExtractFileName(FileListBox1.FileName);
end;

procedure TSaveExtDialogForm.FormCreate(Sender: TObject);
begin
  InitialDir := OldInitialDir;
end;

procedure TSaveExtDialogForm.Button1Click(Sender: TObject);
begin
  OldInitialDir := DirectoryListBox1.Directory;
end;

initialization
  OldInitialDir := '';

end.
