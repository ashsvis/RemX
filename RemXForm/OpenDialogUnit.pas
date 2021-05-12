unit OpenDialogUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AppEvnts;

type
  TOpenDialogForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ListBox1: TListBox;
    Label1: TLabel;
    ApplicationEvents1: TApplicationEvents;
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure ListBox1DblClick(Sender: TObject);
  private
  public
    FileName: string;
    Filter: string;
    InitialDir: string;
    function Execute: boolean;
  end;

var
  OpenDialogForm: TOpenDialogForm;

implementation



{$R *.dfm}

{ TOpenDialogForm }

function TOpenDialogForm.Execute: boolean;
var sr: TSearchRec;
    FileAttrs: Integer;
    List: TStringList;
begin
  List := TStringList.Create;
  try
    FileAttrs := faDirectory;
    if FindFirst(IncludeTrailingPathDelimiter(InitialDir) + Filter,
                 FileAttrs, sr) = 0 then
    begin
      repeat
        if (sr.Attr and FileAttrs) <> sr.Attr then
          List.Add(sr.Name);
      until FindNext(sr) <> 0;
      FindClose(sr);
    end;
    List.Sort;
    ListBox1.Items.Assign(List);
  finally
    List.Free;
  end;
  ListBox1.ItemIndex := ListBox1.Items.IndexOf(ExtractFileName(FileName));
  Result := (ShowModal = mrOk);
  if Result then
    FileName := IncludeTrailingPathDelimiter(InitialDir)+
                ListBox1.Items[ListBox1.ItemIndex];
end;

procedure TOpenDialogForm.ApplicationEvents1Idle(Sender: TObject;
  var Done: Boolean);
begin
  Button1.Enabled:=(ListBox1.ItemIndex >= 0);
end;

procedure TOpenDialogForm.ListBox1DblClick(Sender: TObject);
begin
  if ListBox1.ItemIndex >= 0 then Button1.Click;
end;

end.
