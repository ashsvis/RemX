unit GetRtmRepRecordUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TGetRtmRepRecordForm = class(TForm)
    cbFileName: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    edStartTime: TEdit;
    Label3: TLabel;
    edPrintPeriod: TEdit;
    Label4: TLabel;
    edDescriptor: TEdit;
    cbHandRun: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    procedure cbFileNameDropDown(Sender: TObject);
  private
  public
  end;

var
  GetRtmRepRecordForm: TGetRtmRepRecordForm;

implementation

uses EntityUnit;

{$R *.dfm}

procedure TGetRtmRepRecordForm.cbFileNameDropDown(Sender: TObject);
var sr: TSearchRec; FileAttrs: Integer;
begin
  cbFileName.Items.Clear;
  FileAttrs:=faDirectory;
  if FindFirst(IncludeTrailingPathDelimiter(Caddy.CurrentReportsPath)+'*.FRF',FileAttrs,sr) = 0 then
  begin
    repeat
      if (sr.Attr and FileAttrs) <> sr.Attr then
        cbFileName.Items.Add(sr.Name);
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
end;

end.
