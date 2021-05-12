unit GetDigValUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, AppEvnts;

type
  TGetDigValDlg = class(TForm)
    Button2: TButton;
    Prompt: TGroupBox;
    pnOn: TPanel;
    btOn: TButton;
    pnOff: TPanel;
    btOff: TButton;
    procedure btOnClick(Sender: TObject);
    procedure btOffClick(Sender: TObject);
  private
    FValue: boolean;
    procedure SetCursor(var Mess: TMessage); message WM_USER;
  public
  end;

function InputBooleanDlg(const APrompt,OnText,OffText: string;
                         var Value: Boolean): Boolean;
function InputValveDlg(const APrompt: string; var Value: Byte): Boolean;

implementation



{$R *.dfm}

function InputValveDlg(const APrompt: string; var Value: Byte): Boolean;
var GetDigValDlg: TGetDigValDlg;
begin
  Result:=False;
  GetDigValDlg:=TGetDigValDlg.Create(Application);
  try
    with GetDigValDlg do
    begin
      Caption:='¬ведите команду';
      Prompt.Caption:=APrompt;
      btOn.Caption:='ќ“ –џ“№';
      btOff.Caption:='«ј –џ“№';
      case Value of
        0,3,4,7: begin   // ход, авари€
               pnOn.BorderStyle:=bsNone;
               pnOff.BorderStyle:=bsNone;
               GetDigValDlg.ActiveControl:=nil;
             end;
        1,5: begin   // закрыта
               pnOn.BorderStyle:=bsNone;
               pnOff.BorderStyle:=bsSingle;
               GetDigValDlg.ActiveControl:=btOff;
//               PostMessage(Handle,WM_USER,0,Integer(GetDigValDlg));
             end;
        2,6: begin  // открыта
               pnOn.BorderStyle:=bsSingle;
               pnOff.BorderStyle:=bsNone;
               GetDigValDlg.ActiveControl:=btOn;
//               PostMessage(Handle,WM_USER,0,Integer(GetDigValDlg));
             end;
      end; {of case}
      if ShowModal = mrOk then
      begin
        if FValue then
          Value:=2  // открыта
        else
          Value:=1; // закрыта
        Result:=True;
      end;
    end;
  finally
    GetDigValDlg.Free;
  end;
end;

procedure TGetDigValDlg.SetCursor(var Mess: TMessage);
var P: TPoint; GetDigValDlg: TGetDigValDlg;
begin
  GetDigValDlg:=TGetDigValDlg(Mess.LParam);
  if GetDigValDlg.ActiveControl = btOff then
  begin
    P:=pnOn.ClientToScreen(Point(pnOn.Width div 2,pnOn.Height div 2));
    SetCursorPos(P.X,P.Y);
  end;
  if GetDigValDlg.ActiveControl = btOn then
  begin
    P:=pnOff.ClientToScreen(Point(pnOff.Width div 2,pnOff.Height div 2));
    SetCursorPos(P.X,P.Y);
  end;
end;

function InputBooleanDlg(const APrompt,OnText,OffText: string;
                         var Value: Boolean): Boolean;
var GetDigValDlg: TGetDigValDlg;
begin
  Result:=False;
  GetDigValDlg:=TGetDigValDlg.Create(Application);
  try
    with GetDigValDlg do
    begin
      Caption:='¬ведите значение';
      Prompt.Caption:=APrompt;
      btOn.Caption:=OnText;
      btOff.Caption:=OffText;
      FValue:=Value;
      if Value then
      begin
        pnOn.BorderStyle:=bsSingle;
        pnOff.BorderStyle:=bsNone;
        GetDigValDlg.ActiveControl:=btOn;
      end
      else
      begin
        pnOn.BorderStyle:=bsNone;
        pnOff.BorderStyle:=bsSingle;
        GetDigValDlg.ActiveControl:=btOff;
      end;
//      PostMessage(Handle,WM_USER,0,Integer(GetDigValDlg));
      if ShowModal = mrOk then
      begin
        Value:=FValue;
        Result:=True;
      end;
    end;
  finally
    GetDigValDlg.Free;
  end;
end;

procedure TGetDigValDlg.btOnClick(Sender: TObject);
begin
  FValue:=True;
  pnOn.BorderStyle:=bsSingle;
  pnOff.BorderStyle:=bsNone;
end;

procedure TGetDigValDlg.btOffClick(Sender: TObject);
begin
  FValue:=False;
  pnOn.BorderStyle:=bsNone;
  pnOff.BorderStyle:=bsSingle;
end;

end.
