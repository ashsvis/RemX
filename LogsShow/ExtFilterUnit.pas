unit ExtFilterUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons;

type
  TExtFilterForm = class(TForm)
    OkButton: TButton;
    CancelButton: TButton;
    GroupBox1: TGroupBox;
    ColumnNameLabel: TLabel;
    LogikComboBox1: TComboBox;
    LogikEdit1: TEdit;
    sbSelect1: TSpeedButton;
    rbAND: TRadioButton;
    rbOR: TRadioButton;
    LogikComboBox2: TComboBox;
    LogikEdit2: TEdit;
    sbSelect2: TSpeedButton;
    Label2: TLabel;
    procedure sbSelect1Click(Sender: TObject);
    procedure sbSelect2Click(Sender: TObject);
    procedure FilterGridExit(Sender: TObject);
    procedure FilterGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
//    procedure FilterGridCellClick(Column: TColumn);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Label2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LogikEdit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LogikEdit2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FilterGridKeyPress(Sender: TObject; var Key: Char);
    procedure FilterGridEnter(Sender: TObject);
  private
    SelectedEdit: TEdit;
  public
//    procedure SaveToRegistry(Ident: string);
//    procedure LoadFromRegistry(Ident: string);
  end;

var
  ExtFilterForm: TExtFilterForm;

//procedure ClearRegistryFor(Ident: string);

implementation

uses RemXUnit;

{$R *.dfm}

procedure TExtFilterForm.sbSelect1Click(Sender: TObject);
begin
//  if FilterGrid.Visible then
//    FilterGrid.Visible:=False
//  else
//  begin
//    SelectedEdit:=LogikEdit1;
//    FilterGrid.Left:=LogikEdit1.Left;
//    FilterGrid.Top:=LogikEdit1.Top+LogikEdit1.Height;
//    FilterGrid.Visible:=True;
//    FilterGrid.BringToFront;
//    FilterGrid.SetFocus;
//  end;
end;

procedure TExtFilterForm.sbSelect2Click(Sender: TObject);
begin
//  if FilterGrid.Visible then
//    FilterGrid.Visible:=False
//  else
//  begin
//    SelectedEdit:=LogikEdit2;
//    FilterGrid.Left:=LogikEdit2.Left;
//    FilterGrid.Top:=LogikEdit2.Top+LogikEdit2.Height;
//    FilterGrid.Visible:=True;
//    FilterGrid.BringToFront;
//    FilterGrid.SetFocus;
//  end;
end;

procedure TExtFilterForm.FilterGridExit(Sender: TObject);
begin
//  FilterGrid.Visible:=False;
  OkButton.Default:=True;
  CancelButton.Cancel:=True;
end;

procedure TExtFilterForm.FilterGridMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
//  FilterGrid.Visible:=False;
end;

//procedure TExtFilterForm.FilterGridCellClick(Column: TColumn);
//begin
//  FilterGrid.Visible:=False;
//  SelectedEdit.Text:=FilterDataSource.DataSet.Fields[0].AsString;
//end;

procedure TExtFilterForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if ModalResult = mrOk then
  begin
    if LogikComboBox1.ItemIndex < 1 then
    begin
      RemxForm.ShowWarning('Ошибка в строке анализа.');
      CanClose:=False;
    end
    else
      CanClose:=True;
  end
  else
    CanClose:=True;
end;

procedure TExtFilterForm.Label2MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
//  FilterGrid.Visible:=False;
end;

procedure TExtFilterForm.LogikEdit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssAlt in Shift) and (Key = VK_DOWN) then
  begin
    sbSelect1.Click;
    Key:=0;
  end;
end;

procedure TExtFilterForm.LogikEdit2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssAlt in Shift) and (Key = VK_DOWN) then
  begin
    sbSelect2.Click;
    Key:=0;
  end;
end;

procedure TExtFilterForm.FilterGridKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
//    FilterGridCellClick(FilterGrid.Columns[0]);
    SelectedEdit.SetFocus;
    Key:=#0;
  end
  else
  if Key = #27 then
  begin
//    FilterGrid.Visible:=False;
    SelectedEdit.SetFocus;
    Key:=#0;
  end;
end;

procedure TExtFilterForm.FilterGridEnter(Sender: TObject);
begin
  OkButton.Default:=False;
  CancelButton.Cancel:=False;
end;

(*
procedure ClearRegistryFor(Ident: string);
var Reg: TRegistry; SubKey: string;
begin
  Reg:=TRegistry.Create;
  try
    Reg.RootKey:=HKEY_LOCAL_MACHINE;
    SubKey:=ExtractFilePath(Application.ExeName);
    while Pos('\',SubKey) > 0 do SubKey[Pos('\',SubKey)]:='/';
    if Reg.OpenKey('SOFTWARE\AShHome\RemX\'+SubKey+'\'+Ident,False) then
    begin
      if Reg.ValueExists('LogikComboBox1') then Reg.DeleteValue('LogikComboBox1');
      if Reg.ValueExists('LogikComboBox2') then Reg.DeleteValue('LogikComboBox2');
      if Reg.ValueExists('LogikEdit1') then Reg.DeleteValue('LogikEdit1');
      if Reg.ValueExists('LogikEdit2') then Reg.DeleteValue('LogikEdit2');
      if Reg.ValueExists('rbAND') then Reg.DeleteValue('rbAND');
      if Reg.ValueExists('rbOR') then Reg.DeleteValue('rbOR');
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;
*)

(*
procedure TExtFilterForm.LoadFromRegistry(Ident: string);
var Reg: TRegistry; SubKey: string;
begin
  Reg:=TRegistry.Create;
  try
    Reg.RootKey:=HKEY_LOCAL_MACHINE;
    SubKey:=ExtractFilePath(Application.ExeName);
    while Pos('\',SubKey) > 0 do SubKey[Pos('\',SubKey)]:='/';
    if Reg.OpenKey('SOFTWARE\AShHome\RemX\'+SubKey+'\'+Ident,False) then
    begin
      if Reg.ValueExists('LogikComboBox1') then
        LogikComboBox1.ItemIndex:=Reg.ReadInteger('LogikComboBox1');
      if Reg.ValueExists('LogikComboBox2') then
        LogikComboBox2.ItemIndex:=Reg.ReadInteger('LogikComboBox2');
      if Reg.ValueExists('LogikEdit1') then
        LogikEdit1.Text:=Reg.ReadString('LogikEdit1');
      if Reg.ValueExists('LogikEdit2') then
        LogikEdit2.Text:=Reg.ReadString('LogikEdit2');
      if Reg.ValueExists('rbAND') then
        rbAND.Checked:=Reg.ReadBool('rbAND');
      if Reg.ValueExists('rbOR') then
        rbOR.Checked:=Reg.ReadBool('rbOR');
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;
*)

(*
procedure TExtFilterForm.SaveToRegistry(Ident: string);
var Reg: TRegistry; SubKey: string;
begin
  Reg:=TRegistry.Create;
  try
    Reg.RootKey:=HKEY_LOCAL_MACHINE;
    SubKey:=ExtractFilePath(Application.ExeName);
    while Pos('\',SubKey) > 0 do SubKey[Pos('\',SubKey)]:='/';
    if Reg.OpenKey('SOFTWARE\AShHome\RemX\'+SubKey+'\'+Ident,True) then
    begin
      Reg.WriteInteger('LogikComboBox1',LogikComboBox1.ItemIndex);
      Reg.WriteInteger('LogikComboBox2',LogikComboBox2.ItemIndex);
      Reg.WriteString('LogikEdit1',LogikEdit1.Text);
      Reg.WriteString('LogikEdit2',LogikEdit2.Text);
      Reg.WriteBool('rbAND',rbAND.Checked);
      Reg.WriteBool('rbOR',rbOR.Checked);
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;
*)

end.
