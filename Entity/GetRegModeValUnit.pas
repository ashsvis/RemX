unit GetRegModeValUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, AppEvnts;

type
  TGetRegModeValDlg = class(TForm)
    Button2: TButton;
    rgSPMode: TRadioGroup;
    rgOPMode: TRadioGroup;
    rgRemoteMode: TRadioGroup;
    rgLocaleMode: TRadioGroup;
    Button1: TButton;
    ApplicationEvents1: TApplicationEvents;
    procedure rgSPModeClick(Sender: TObject);
    procedure rgOPModeClick(Sender: TObject);
    procedure rgRemoteModeClick(Sender: TObject);
    procedure rgLocaleModeClick(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
  private
    FValue: Word;
  public
  end;

function InputRegModeDlg(var Value: Word): Boolean;

implementation



{$R *.dfm}

function InputRegModeDlg(var Value: Word): Boolean;
var GetRegModeValDlg: TGetRegModeValDlg;
begin
  Result:=False;
  GetRegModeValDlg:=TGetRegModeValDlg.Create(Application);
  try
    with GetRegModeValDlg do
    begin
      Caption:='Âûáåğèòå íîâûé ğåæèì';
      FValue:=Value;
      case ((FValue and $0010) shr 4) of
       0: begin
  //(ÀÓ) Àâòîìàòè÷åñêîå óïğàâëåíèå
            rgOPMode.Buttons[0].Enabled:=False; //AU
            rgOPMode.Buttons[1].Enabled:=True; //RU
          end;
       1: begin
  //(ĞÓ) Ğó÷íîå óïğàâëåíèå
            rgOPMode.Buttons[0].Enabled:=True; //AU
            rgOPMode.Buttons[1].Enabled:=False; //RU
          end;
      end;
      case ((FValue and $0060) shr 5) of
       0: begin
      //Íåò àëãîğèòìà ÇÄÍ
            rgSPMode.Buttons[0].Enabled:=False; //VZ
            rgSPMode.Buttons[1].Enabled:=False; //PZ
            rgSPMode.Buttons[2].Enabled:=False; //RZ
          end;
       1: begin
      //(ÂÇ) Âíåøíåå çàäàíèå
            rgSPMode.Buttons[0].Enabled:=False; //VZ
            rgSPMode.Buttons[1].Enabled:=True; //PZ
            rgSPMode.Buttons[2].Enabled:=True; //RZ
          end;
       2: begin
      //(ÏÇ) Ïğîãğàììíîå çàäàíèå
            rgSPMode.Buttons[0].Enabled:=True; //VZ
            rgSPMode.Buttons[1].Enabled:=False; //PZ
            rgSPMode.Buttons[2].Enabled:=True; //RZ
          end;
       3: begin
     //(ĞÇ) Ğó÷íîå çàäàíèå
            rgSPMode.Buttons[0].Enabled:=True; //VZ
            rgSPMode.Buttons[1].Enabled:=True; //PZ
            rgSPMode.Buttons[2].Enabled:=False; //RZ
          end;
      end;
      case ((FValue and $0008) shr 3) of
       0: begin
       //Ëîêàëüíûé/êàñêàäíûé ğåæèì
            rgRemoteMode.Buttons[0].Enabled:=True; //DU
            rgRemoteMode.Buttons[1].Enabled:=False; //KULU
          end;
       1: begin
       //(ÄÓ) Äèñòàíöèîííûé ğåæèì
            rgRemoteMode.Buttons[0].Enabled:=False; //DU
            rgRemoteMode.Buttons[1].Enabled:=True; //KULU
          end;
      end;
      case ((FValue and $6000) shr 13) of
       1: begin
       //(ËÓ) Ëîêàëüíûé ğåæèì
            rgLocaleMode.Buttons[0].Enabled:=True; //KU
            rgLocaleMode.Buttons[1].Enabled:=False; //LU
          end;
       2: begin
      //(ÊÓ) Êàñêàäíûé ğåæèì
            rgLocaleMode.Buttons[0].Enabled:=False; //KU
            rgLocaleMode.Buttons[1].Enabled:=True; //LU
          end;
      else
        begin
          rgLocaleMode.Buttons[0].Enabled:=False; //KU
          rgLocaleMode.Buttons[1].Enabled:=False; //LU
        end;
      end;
      if ShowModal = mrOk then
      begin
        if rgSPMode.ItemIndex >= 0 then
        begin
          Value:=rgSPMode.ItemIndex+1;
          Result:=True;
        end
        else if rgOPMode.ItemIndex >= 0 then
        begin
          Value:=rgOPMode.ItemIndex+4;
          Result:=True;
        end
        else if rgRemoteMode.ItemIndex >= 0 then
        begin
          Value:=rgRemoteMode.ItemIndex+6;
          Result:=True;
        end
        else if rgLocaleMode.ItemIndex >= 0 then
        begin
          Value:=rgLocaleMode.ItemIndex+8;
          Result:=True;
        end
        else
          Result:=False;
      end;
    end;
  finally
    GetRegModeValDlg.Free;
  end;
end;

procedure TGetRegModeValDlg.rgSPModeClick(Sender: TObject);
begin
  rgOPMode.ItemIndex:=-1;
  rgRemoteMode.ItemIndex:=-1;
  rgLocaleMode.ItemIndex:=-1;
end;

procedure TGetRegModeValDlg.rgOPModeClick(Sender: TObject);
begin
  rgSPMode.ItemIndex:=-1;
  rgRemoteMode.ItemIndex:=-1;
  rgLocaleMode.ItemIndex:=-1;
end;

procedure TGetRegModeValDlg.rgRemoteModeClick(Sender: TObject);
begin
  rgOPMode.ItemIndex:=-1;
  rgSPMode.ItemIndex:=-1;
  rgLocaleMode.ItemIndex:=-1;
end;

procedure TGetRegModeValDlg.rgLocaleModeClick(Sender: TObject);
begin
  rgOPMode.ItemIndex:=-1;
  rgSPMode.ItemIndex:=-1;
  rgRemoteMode.ItemIndex:=-1;
end;

procedure TGetRegModeValDlg.ApplicationEvents1Idle(Sender: TObject;
  var Done: Boolean);
begin
  Button1.Enabled := (rgOPMode.ItemIndex >= 0) or (rgSPMode.ItemIndex >= 0) or
                (rgRemoteMode.ItemIndex >= 0) or (rgLocaleMode.ItemIndex >= 0);
end;

end.
