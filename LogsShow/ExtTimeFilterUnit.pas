unit ExtTimeFilterUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Mask, Buttons, ExtCtrls;

type
  TExtTimeFilterForm = class(TForm)
    Label1: TLabel;
    TimeBaseListBox: TListBox;
    GroupBox1: TGroupBox;
    MaskEdit1: TMaskEdit;
    UpDown1: TUpDown;
    OkButton: TButton;
    CancelButton: TButton;
    cbWithCurrent: TCheckBox;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton11: TSpeedButton;
    SpeedButton12: TSpeedButton;
    SpeedButton13: TSpeedButton;
    SpeedButton14: TSpeedButton;
    SpeedButton15: TSpeedButton;
    Bevel1: TBevel;
    procedure sbHoursClick(Sender: TObject);
    procedure sbDaysClick(Sender: TObject);
    procedure sbMonthsClick(Sender: TObject);
    procedure sbYearClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure cbWithCurrentClick(Sender: TObject);
    procedure TimeBaseListBoxClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ExtTimeFilterForm: TExtTimeFilterForm;

implementation

uses RemXUnit;

{$R *.dfm}

procedure TExtTimeFilterForm.sbHoursClick(Sender: TObject);
begin
  TimeBaseListBox.ItemIndex:=0;
  UpDown1.Position:=(Sender as TSpeedButton).Tag;
  cbWithCurrent.Checked:=True;
  OkButton.Click;
end;

procedure TExtTimeFilterForm.sbDaysClick(Sender: TObject);
begin
  TimeBaseListBox.ItemIndex:=1;
  UpDown1.Position:=(Sender as TSpeedButton).Tag;
  OkButton.Click;
end;

procedure TExtTimeFilterForm.sbMonthsClick(Sender: TObject);
begin
  TimeBaseListBox.ItemIndex:=2;
  UpDown1.Position:=(Sender as TSpeedButton).Tag;
  OkButton.Click;
end;

procedure TExtTimeFilterForm.sbYearClick(Sender: TObject);
begin
  TimeBaseListBox.ItemIndex:=3;
  UpDown1.Position:=(Sender as TSpeedButton).Tag;
  OkButton.Click;
end;

procedure TExtTimeFilterForm.FormCreate(Sender: TObject);
begin
  TimeBaseListBox.ItemIndex:=0;
end;

procedure TExtTimeFilterForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if ModalResult = mrOk then
  begin
    if TimeBaseListBox.ItemIndex = 0 then cbWithCurrent.Checked:=True;
    if StrToIntDef(MaskEdit1.Text,0) = 0 then
    begin
      RemxForm.ShowWarning('Ошибка! Требуется целое числовое значение!');
      MaskEdit1.SetFocus;
      CanClose:=False;
    end
    else
      CanClose:=True;
  end
  else
    CanClose:=True;
end;

procedure TExtTimeFilterForm.cbWithCurrentClick(Sender: TObject);
begin
  if TimeBaseListBox.ItemIndex = 0 then cbWithCurrent.Checked:=True;
end;

procedure TExtTimeFilterForm.TimeBaseListBoxClick(Sender: TObject);
begin
  if TimeBaseListBox.ItemIndex = 0 then cbWithCurrent.Checked:=True;
end;

end.
