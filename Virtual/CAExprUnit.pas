unit CAExprUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, VirtualUnit, StdCtrls;

type
  TFormCAExpr = class(TForm)
    lblFunc: TLabel;
    cbbFirstPrefix: TComboBox;
    cbbSecondPrefix: TComboBox;
    cbbFirstVar: TComboBox;
    cbbSecondVar: TComboBox;
    cbbOperation: TComboBox;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    lblResult: TLabel;
    btnOk: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure cbbFirstPrefixChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbbFirstVarChange(Sender: TObject);
    procedure cbbSecondPrefixChange(Sender: TObject);
    procedure cbbSecondVarChange(Sender: TObject);
    procedure cbbOperationChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    Changed: Boolean;
    procedure UpdateFormula;
  public
    Index: Integer;
    E: TVirtCalc;
  end;

var
  FormCAExpr: TFormCAExpr;

implementation

uses EntityUnit;

{$R *.dfm}

procedure TFormCAExpr.FormCreate(Sender: TObject);
var Uo: TUnoOperation; D: TDuoOperation; V: TCodeArgument; i: Integer;
begin
  Changed:=Caddy.Changed;
  Index:=1;
  E:=TVirtCalc.Create;
  lblResult.Caption := E.OperationToString(index);
  cbbFirstPrefix.Items.Clear;
  cbbSecondPrefix.Items.Clear;
  for Uo := Low(Uo) to High(Uo) do
  begin
    cbbFirstPrefix.Items.Add(AUnoOperation[Uo]);
    cbbSecondPrefix.Items.Add(AUnoOperation[Uo]);
  end;
  cbbFirstVar.Items.Clear;
  cbbSecondVar.Items.Clear;
  cbbFirstVar.Items.Add('');
  cbbSecondVar.Items.Add('');
  for V := Low(V) to High(V) do
  if V <> Low(V) then
  begin
    for i:=1 to 9 do
    begin
      cbbFirstVar.Items.Add(Format('%s%d',[AVarCode[V],i]));
      cbbSecondVar.Items.Add(Format('%s%d',[AVarCode[V],i]));
    end;
  end;
  cbbOperation.Items.Clear;
  for D := Low(D) to High(D) do
    cbbOperation.Items.Add(ADuoOperation[D]);
end;

procedure TFormCAExpr.FormDestroy(Sender: TObject);
begin
  E.Free;
end;

procedure TFormCAExpr.cbbFirstPrefixChange(Sender: TObject);
var R: TOneStep;
begin
  R := E.StepList[Index];
  R.FirstPrefix := TUnoOperation(cbbFirstPrefix.ItemIndex);
  E.StepList[Index] := R;
  UpdateFormula;
end;

procedure TFormCAExpr.cbbFirstVarChange(Sender: TObject);
var R: TOneStep; i: Integer;
begin
  R := E.StepList[Index];
  i := cbbFirstVar.ItemIndex;
  if i = 0 then
  begin
    R.FirstArgument := caNone;
    R.FirstArgNumber := 0;
  end
  else
  begin
    R.FirstArgument := TCodeArgument(((i-1) div 9)+1);
    R.FirstArgNumber := ((i-1) mod 9)+1;
  end;
  E.StepList[Index] := R;
  UpdateFormula;
end;

procedure TFormCAExpr.cbbSecondPrefixChange(Sender: TObject);
var R: TOneStep;
begin
  R := E.StepList[Index];
  R.SecondPrefix := TUnoOperation(cbbSecondPrefix.ItemIndex);
  E.StepList[Index] := R;
  UpdateFormula;
end;

procedure TFormCAExpr.cbbSecondVarChange(Sender: TObject);
var R: TOneStep; i: Integer;
begin
  R := E.StepList[Index];
  i := cbbSecondVar.ItemIndex;
  if i = 0 then
  begin
    R.SecondArgument := caNone;
    R.SecondArgNumber := 0;
  end
  else
  begin
    R.SecondArgument := TCodeArgument(((i-1) div 9)+1);
    R.SecondArgNumber := ((i-1) mod 9)+1;
  end;
  E.StepList[Index] := R;
  UpdateFormula;
end;

procedure TFormCAExpr.cbbOperationChange(Sender: TObject);
var R: TOneStep; i: Integer;
begin
  R := E.StepList[Index];
  i := cbbOperation.ItemIndex;
  R.Operation := TDuoOperation(i);
  E.StepList[Index] := R;
  UpdateFormula;
end;

procedure TFormCAExpr.FormShow(Sender: TObject);
var i: integer;
begin
  lblFunc.Caption := Format(lblFunc.Caption,[Index]);
  cbbFirstPrefix.ItemIndex := Ord(E.StepList[Index].FirstPrefix);
  i:=Ord(E.StepList[Index].FirstArgument);
  cbbFirstVar.ItemIndex := (i-1)*9+E.StepList[Index].FirstArgNumber;
  cbbOperation.ItemIndex := Ord(E.StepList[Index].Operation);
  cbbSecondPrefix.ItemIndex := Ord(E.StepList[Index].SecondPrefix);
  i:=Ord(E.StepList[Index].SecondArgument);
  cbbSecondVar.ItemIndex := (i-1)*9+E.StepList[Index].SecondArgNumber;
  UpdateFormula;
end;

procedure TFormCAExpr.UpdateFormula;
var S: string;
begin
  S := E.OperationToString(Index);
  if S <> '' then
  begin
    lblResult.Caption := lblFunc.Caption+E.OperationToString(Index);
    btnOk.Enabled := True;
  end
  else
  begin
    lblResult.Caption := '';
    btnOk.Enabled := False;
  end;
  Caddy.Changed := Changed;
end;

end.
