unit GetPtNameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, EntityUnit, ExtCtrls, ComCtrls;

type
  TGetPtNameDlg = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Image1: TImage;
    Bevel1: TBevel;
    UpDown1: TUpDown;
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  private
  public
  end;

function GetPtNameDlg(EC: TEntityClass; ImageList: TImageList; var PtName: string): boolean;
function InputStringDlg(const APrompt: string; var Value: string;
                        MaxLen: integer = 10): Boolean;
function InputIntegerDlg(const APrompt: string; var Value: Integer): Boolean;
function InputFloatDlg(const APrompt,AFormat: string; var Value: Single): Boolean;

implementation



{$R *.dfm}

function GetPtNameDlg(EC: TEntityClass; ImageList: TImageList; var PtName: string): boolean;
var GetPtNameDlg: TGetPtNameDlg;
begin
  Result:=False;
  GetPtNameDlg:=TGetPtNameDlg.Create(Application);
  try
    ImageList.Draw(GetPtNameDlg.Image1.Canvas,0,0,EntityClassIndex(EC)+3);
    GetPtNameDlg.Label1.Caption:=EC.EntityType+':';
    GetPtNameDlg.Edit1.MaxLength:=10;
    GetPtNameDlg.Edit1.Text:=Copy(PtName,1,10);
    with GetPtNameDlg do Edit1.Width:=Edit1.Width+UpDown1.Width;
    LoadKeyboardLayout('00000409',KLF_ACTIVATE);
    if GetPtNameDlg.ShowModal = mrOk then
    begin
      PtName:=GetPtNameDlg.Edit1.Text;
      Result:=True;
    end;
  finally
    GetPtNameDlg.Free;
  end;
end;

function InputStringDlg(const APrompt: string; var Value: string;
                        MaxLen: integer = 10): Boolean;
var GetPtNameDlg: TGetPtNameDlg;
begin
  Result:=False;
  GetPtNameDlg:=TGetPtNameDlg.Create(Application);
  try
    with GetPtNameDlg do
    begin
      Bevel1.Visible:=False;
      Image1.Visible:=False;
      Caption:='¬ведите значение';
      Label1.Left:=Edit1.Left;
      Label1.Caption:=APrompt+':';
      Edit1.Width:=Edit1.Width+UpDown1.Width;
      Edit1.CharCase:=ecNormal;
      Edit1.MaxLength:=MaxLen;
      Edit1.Text:=Copy(Value,1,MaxLen);
      LoadKeyboardLayout('00000419',KLF_ACTIVATE);
      if ShowModal = mrOk then
      begin
        Value:=Edit1.Text;
        Result:=True;
      end;
    end;
  finally
    GetPtNameDlg.Free;
  end;
end;

function InputIntegerDlg(const APrompt: string; var Value: Integer): Boolean;
var GetPtNameDlg: TGetPtNameDlg;
begin
  Result:=False;
  GetPtNameDlg:=TGetPtNameDlg.Create(Application);
  try
    with GetPtNameDlg do
    begin
      Bevel1.Visible:=False;
      Image1.Visible:=False;
      Caption:='¬ведите значение';
      Label1.Left:=Edit1.Left;
      Label1.Caption:=APrompt+':';
      Edit1.CharCase:=ecNormal;
      if (Value >= UpDown1.Min) and (Value <= UpDown1.Max) then
      begin
        UpDown1.Visible:=True;
        UpDown1.Associate:=Edit1;
        UpDown1.Position:=Value;
      end
      else
        Edit1.Text := IntToStr(Value);
      if ShowModal = mrOk then
      begin
        if TryStrToInt(Edit1.Text,Value) then
          Result:=True
        else
          raise EConvertError.Create('"'+Edit1.Text+
                                     '" не €вл€етс€ числовым значением!');
      end;
    end;
  finally
    GetPtNameDlg.Free;
  end;
end;

function InputFloatDlg(const APrompt,AFormat: string; var Value: Single): Boolean;
var GetPtNameDlg: TGetPtNameDlg;
begin
  Result:=False;
  GetPtNameDlg:=TGetPtNameDlg.Create(Application);
  try
    with GetPtNameDlg do
    begin
      Bevel1.Visible:=False;
      Image1.Visible:=False;
      Caption:='¬ведите значение';
      Label1.Left:=Edit1.Left;
      Label1.Caption:=APrompt+':';
      Edit1.Width:=Edit1.Width+UpDown1.Width;
      Edit1.CharCase:=ecNormal;
      Edit1.Text:=Format(AFormat,[Value]);
      Edit1.OnKeyPress:=Edit1KeyPress;
      if ShowModal = mrOk then
      begin
        if TryStrToFloat(Edit1.Text,Value) then
          Result:=True
        else
          raise EConvertError.Create('"'+Edit1.Text+
                                     '" не €вл€етс€ вещественным числом!');
      end;
    end;
  finally
    GetPtNameDlg.Free;
  end;
end;

procedure TGetPtNameDlg.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = '.') or (Key = ',') then Key:=DecimalSeparator;
end;

end.
