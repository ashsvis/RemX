unit SetKonturOPUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, EntityUnit, ExtCtrls;

type
  TSetKonturOPDlg = class(TForm)
    Button1: TButton;
    sbLess: TSpeedButton;
    sbMore: TSpeedButton;
    IT: TTimer;
    procedure sbLessMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sbLessMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sbMoreMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sbMoreMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ITTimer(Sender: TObject);
  private
  public
    CntReg: TCustomCntReg;
  end;

var
  SetKonturOPDlg: TSetKonturOPDlg;

implementation

{$R *.dfm}

procedure TSetKonturOPDlg.sbLessMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    CntReg.CommandMode:=11;
    CntReg.CommandData:=-25.0;
    CntReg.HasCommand:=True;
    IT.Enabled:=True;
    IT.Tag:=-1;
  end;
end;

procedure TSetKonturOPDlg.sbLessMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    CntReg.CommandMode:=11;
    CntReg.CommandData:=0.0;
    CntReg.HasCommand:=True;
    IT.Enabled:=False;
    IT.Tag:=0;
  end;
end;

procedure TSetKonturOPDlg.sbMoreMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    CntReg.CommandMode:=11;
    CntReg.CommandData:=25.0;
    CntReg.HasCommand:=True;
    IT.Enabled:=True;
    IT.Tag:=1;
  end;
end;

procedure TSetKonturOPDlg.sbMoreMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    CntReg.CommandMode:=11;
    CntReg.CommandData:=0.0;
    CntReg.HasCommand:=True;
    IT.Enabled:=False;
    IT.Tag:=0;
  end;
end;

procedure TSetKonturOPDlg.ITTimer(Sender: TObject);
begin
  IT.Enabled:=False;
  case IT.Tag of
  -1: begin
        CntReg.CommandMode:=11;
        CntReg.CommandData:=-100.0;
        CntReg.HasCommand:=True;
      end;
   1: begin
        CntReg.CommandMode:=11;
        CntReg.CommandData:=100.0;
        CntReg.HasCommand:=True;
      end;
  end;
  IT.Tag:=0;
end;

end.
