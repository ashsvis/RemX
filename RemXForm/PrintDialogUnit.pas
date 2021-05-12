unit PrintDialogUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

type
  TPrintDialogForm = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    cbPrinters: TComboBox;
    lbPrinterState: TLabel;
    lbPrinterType: TLabel;
    lbPrinterPlace: TLabel;
    lbPrinterComment: TLabel;
    rgPrintRange: TRadioGroup;
    GroupBox2: TGroupBox;
    Label9: TLabel;
    edCopyNum: TEdit;
    udCopyNum: TUpDown;
    cbCollate: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    edStartPage: TEdit;
    edEndPage: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rgPrintRangeClick(Sender: TObject);
    procedure edCopyNumChange(Sender: TObject);
    procedure cbCollateClick(Sender: TObject);
    procedure edStartPageChange(Sender: TObject);
    procedure edEndPageChange(Sender: TObject);
    procedure cbPrintersChange(Sender: TObject);
  private
  public
    FromPage,ToPage,Copies: integer;
    PrintRange: TPrintRange;
    Collate: boolean;
    function Execute: boolean;
  end;

var
  PrintDialogForm: TPrintDialogForm;


implementation

uses RemXUnit, Printers, WinSpool;

{$R *.dfm}

function PrinterStatus(PrinterName: string;
             var DataType, Location, Comment: string): string;
const
  PrnStat: array[0..24] of Integer = (
  PRINTER_STATUS_PAUSED,
  PRINTER_STATUS_ERROR,
  PRINTER_STATUS_PENDING_DELETION,
  PRINTER_STATUS_PAPER_JAM,
  PRINTER_STATUS_PAPER_OUT,
  PRINTER_STATUS_MANUAL_FEED,
  PRINTER_STATUS_PAPER_PROBLEM,
  PRINTER_STATUS_OFFLINE,
  PRINTER_STATUS_IO_ACTIVE,
  PRINTER_STATUS_BUSY,
  PRINTER_STATUS_PRINTING,
  PRINTER_STATUS_OUTPUT_BIN_FULL,
  PRINTER_STATUS_NOT_AVAILABLE,
  PRINTER_STATUS_WAITING,
  PRINTER_STATUS_PROCESSING,
  PRINTER_STATUS_INITIALIZING,
  PRINTER_STATUS_WARMING_UP,
  PRINTER_STATUS_TONER_LOW,
  PRINTER_STATUS_NO_TONER,
  PRINTER_STATUS_PAGE_PUNT,
  PRINTER_STATUS_USER_INTERVENTION,
  PRINTER_STATUS_OUT_OF_MEMORY,
  PRINTER_STATUS_DOOR_OPEN,
  PRINTER_STATUS_SERVER_UNKNOWN,
  PRINTER_STATUS_POWER_SAVE
  );
  PrnStatDesc: array[0..24] of string = (
  'Приостановлен',
  'Ошибка',
  'Удаление...',
  'Нет подачи бумаги',
  'Нет бумаги',
  'Ручная подача',
  'Заминание бумаги',
  'Неактивен',
  'Загрузка данных',
  'Занят',
  'Печатает',
  'Буфер полон',
  'Не доступен',
  'Ожидание',
  'Обработка',
  'Инициализация',
  'WARMING UP',
  'Мало тонера',
  'Нет тонера',
  'PAGE PUNT',
  'Требуется вмешательство',
  'Нет свободной памяти',
  'Дверца не закрыта',
  'Сервер неизвестен',
  'Энергосбережение'
  );
var Flags,Count,NumInfo: DWORD; Buffer,PrinterInfo: PChar;
    i,j: Integer;
begin
  Result:='';
  if Win32Platform = VER_PLATFORM_WIN32_NT then
    Flags := PRINTER_ENUM_CONNECTIONS or PRINTER_ENUM_LOCAL
  else
    Flags := PRINTER_ENUM_LOCAL;
  Count:=0;
  EnumPrinters(Flags,nil,2,nil,0,Count,NumInfo);
  if Count > 0 then
  begin
    GetMem(Buffer,Count);
    try
      if not EnumPrinters(Flags,nil,2,PByte(Buffer),Count,Count,NumInfo) then
        Exit;
      PrinterInfo:=Buffer;
      for i:=0 to NumInfo-1 do
      begin
        with PPrinterInfo2(PrinterInfo)^ do
        if pPrinterName = PrinterName then
        begin
          for j:=0 to 24 do
            if (Status and PrnStat[j]) > 0 then
              Result:=Result+' - '+PrnStatDesc[j];
          if Pos(' - ',Result) = 1 then Delete(Result,1,3);
          DataType:=pDriverName;
          Location:=pPortName;
          Comment:=pComment;
          Break;
        end;
        Inc(PrinterInfo, sizeof(TPrinterInfo2));
      end;
    finally
      FreeMem(Buffer,Count);
    end;
  end;
end;

function JobStatus(PrinterName: string; var JobExist: boolean): string;
const JobStat: array[0..7] of Integer = (
       JOB_STATUS_DELETING,
       JOB_STATUS_ERROR,
       JOB_STATUS_OFFLINE,
       JOB_STATUS_PAPEROUT,
       JOB_STATUS_PAUSED,
       JOB_STATUS_PRINTED,
       JOB_STATUS_PRINTING,
       JOB_STATUS_SPOOLING);
     JobStatDesc: array[0..7] of String = (
       'Удаление',
       'Ошибка',
       'Неактивен',
       'Нет бумаги',
       'Приостановлен',
       'Отпечатан',
       'Идет печать',
       'Выгружается'
        );
var i,j: Integer; HPrinter: THandle; JobBuffer,JobInfo: PChar;
    JobCount,NumJob: DWORD; S: string;
begin
  Result:='';
  JobExist:=False;
  if OpenPrinter(PChar(PrinterName),HPrinter,nil) then
  begin
    JobCount:=0;
    EnumJobs(HPrinter,0,1,1,nil,0,JobCount,NumJob);
    if JobCount > 0 then
    begin
      GetMem(JobBuffer,JobCount);
      try
        if EnumJobs(HPrinter,0,1,1,PByte(JobBuffer),JobCount,JobCount,NumJob) then
        begin
          JobInfo:=JobBuffer;
          for i:=0 to NumJob-1 do
          begin
            with PJobInfo1(JobInfo)^ do
            begin
              S:='';
              for j:=0 to 7 do
                if (Status and JobStat[j]) > 0 then
                  S:=S+' - '+JobStatDesc[j];
              if Pos(' - ',S) = 1 then Delete(S,1,3);
              JobExist:=True;
              Result:=S; //'"'+pDocument+'"'+S;
            end;
            Inc(JobInfo,sizeof(TJobInfo1));
          end;
        end;
      finally
        FreeMem(JobBuffer,JobCount);
      end;
    end;
    ClosePrinter(HPrinter);
  end;
end;

{ TPrintDialogForm }

function TPrintDialogForm.Execute: boolean;
begin
  Result:=(PrintDialogForm.ShowModal = mrOk);
  if Result then
    Printer.PrinterIndex:=
          Printer.Printers.IndexOf(PrintDialogForm.cbPrinters.Text);
end;

procedure TPrintDialogForm.FormCreate(Sender: TObject);
begin
  FromPage:=1;
  ToPage:=1;
  Copies:=1;
  PrintRange:=prAllPages;
  Collate:=True;
end;

procedure TPrintDialogForm.FormShow(Sender: TObject);
begin
  Printer.Refresh;
  if Printer.Printers.Count = 0 then
  begin
    RemxForm.ShowError('Нет установленных принтеров в системе.');
    Exit;
  end;
//  try
//    Printer.PrinterIndex:=-1;
//  except
//    RemxForm.ShowError('Не выбран принтер по умолчанию!');
//    Abort;
//  end;
  cbPrinters.Items.Assign(Printer.Printers);
  cbPrinters.ItemIndex:=Printer.PrinterIndex;
  edStartPage.Text:=IntToStr(FromPage);
  edEndPage.Text:=IntToStr(ToPage);
  cbPrintersChange(cbPrinters);
end;

procedure TPrintDialogForm.rgPrintRangeClick(Sender: TObject);
begin
 case rgPrintRange.ItemIndex of
  0: begin
       edStartPage.Enabled:=False;
       edEndPage.Enabled:=False;
       edStartPage.Color:=clBtnFace;
       edEndPage.Color:=clBtnFace;
       PrintRange:=prAllPages;
     end;
  1: begin
       edStartPage.Enabled:=True;
       edEndPage.Enabled:=True;
       edStartPage.Color:=clWindow;
       edEndPage.Color:=clWindow;
       PrintRange:=prPageNums;
     end;
 end;
end;

procedure TPrintDialogForm.edCopyNumChange(Sender: TObject);
begin
  Copies:=StrToInt(edCopyNum.Text);
  if Copies > 1 then
    cbCollate.Enabled:=True
  else
  begin
    cbCollate.Enabled:=False;
    cbCollate.Checked:=True;
  end;
end;

procedure TPrintDialogForm.cbCollateClick(Sender: TObject);
begin
  Collate:=cbCollate.Checked;
end;

procedure TPrintDialogForm.edStartPageChange(Sender: TObject);
begin
  TryStrToInt(edStartPage.Text,FromPage);
end;

procedure TPrintDialogForm.edEndPageChange(Sender: TObject);
begin
  TryStrToInt(edEndPage.Text,ToPage);
end;

procedure TPrintDialogForm.cbPrintersChange(Sender: TObject);
var S, DataType, Location, Comment: string; JobExist: boolean;
begin
  S:=PrinterStatus(cbPrinters.Text,DataType,Location,Comment);
  S:=S+' '+JobStatus(cbPrinters.Text,JobExist);
  if S=' ' then S:='Готов';
  lbPrinterState.Caption:=S;
  lbPrinterType.Caption:=DataType;
  lbPrinterPlace.Caption:=Location;
  lbPrinterComment.Caption:=Comment;
end;

end.
