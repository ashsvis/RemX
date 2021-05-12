program RmxBaseSvr;

uses
  Forms,
  RmxBaseSvrUnit in 'RmxBaseSvrUnit.pas' {RmxBaseSvrForm},
  RmxBaseSvr_TLB in 'RmxBaseSvr_TLB.pas',
  RmxBaseDataUnit in 'RmxBaseDataUnit.pas' {RmxBaseData: TRemoteDataModule} {RmxBaseData: CoClass},
  RmxConnection in 'RmxConnection.pas',
  CRCCalcUnit in 'Entity\CRCCalcUnit.pas';

{$R *.TLB}

{$R *.res}

begin
  Application.Initialize;
  Application.ShowMainForm:=False;
  Application.Title := 'Сервер данных RemX';
  Application.CreateForm(TRmxBaseSvrForm, RmxBaseSvrForm);
  Application.Run;
end.
