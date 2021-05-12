unit TabOrderUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, CheckLst, ExtCtrls;

type
  TTabOrderForm = class(TForm)
    UpButton: TBitBtn;
    DownButton: TBitBtn;
    OkButton: TBitBtn;
    CancelButton: TBitBtn;
    SortButton: TSpeedButton;
    ListBox: TListBox;
    procedure ListBoxClick(Sender: TObject);
    procedure UpButtonClick(Sender: TObject);
    procedure DownButtonClick(Sender: TObject);
    procedure SortButtonClick(Sender: TObject);
  private
  public
  end;

var
  TabOrderForm: TTabOrderForm;

implementation

uses EntityUnit;

{$R *.DFM}

procedure TTabOrderForm.ListBoxClick(Sender: TObject);
begin
  UpButton.Enabled:=(ListBox.ItemIndex > 0);
  DownButton.Enabled:=(ListBox.ItemIndex < ListBox.Items.Count-1);
  SortButton.Enabled:=True;
  OkButton.Enabled:=True;
  if ListBox.ItemIndex >= 0 then
    PostMessage((Self.Owner as TForm).Handle,WM_SelectDin,0,
                Integer(ListBox.Items.Objects[ListBox.ItemIndex]));
end;

procedure TTabOrderForm.UpButtonClick(Sender: TObject);
var i: integer;
begin
  i:=ListBox.ItemIndex;
  ListBox.Items.Exchange(i,i-1);
  ListBoxClick(Sender);
end;

procedure TTabOrderForm.DownButtonClick(Sender: TObject);
var i: integer;
begin
  i:=ListBox.ItemIndex;
  ListBox.Items.Exchange(i,i+1);
  ListBoxClick(Sender);
end;

procedure TTabOrderForm.SortButtonClick(Sender: TObject);
var SL: TStringList; 
begin
  SortButton.Enabled:=False;
  SL:=TStringList.Create;
  try
    SL.Assign(ListBox.Items);
    SL.Sort;
    ListBox.Items.Assign(SL);
  finally
    SL.Free;
  end;
  OkButton.Enabled:=True;
end;

end.
