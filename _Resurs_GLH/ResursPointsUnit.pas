unit ResursPointsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, ResursGLHUnit, Grids;

type
  TResursPointsForm = class(TForm)
    ToolBar1: TToolBar;
    tbClose: TToolButton;
    ToolButton1: TToolButton;
    tbFresh: TToolButton;
    DG: TDrawGrid;
    procedure tbCloseClick(Sender: TObject);
    procedure tbFreshClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DGDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
  private
  public
    E: TResursGLHNode;
  end;

var
  ResursPointsForm: TResursPointsForm;

implementation

uses StrUtils;

{$R *.dfm}

procedure TResursPointsForm.tbCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TResursPointsForm.tbFreshClick(Sender: TObject);
begin
//
end;

procedure TResursPointsForm.FormShow(Sender: TObject);
begin
  tbFresh.Click;
end;

procedure TResursPointsForm.DGDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var S: string; n: integer; R: Single;
begin
  case ARow of
   0: begin
        case ACol of
          0: S:='Параметры';
        else
          S:=Format('Точка учета %d',[ACol]);
        end;
        DrawText(DG.Canvas.Handle,PChar(S),-1,Rect,
                 DT_CENTER+DT_VCENTER+DT_SINGLELINE);
      end;
   1: begin
        case ACol of
          0: S:='Датчик P';
        else
          begin
            n:=(ACol-1)*176+900;
            S:=Format('%s',[IfThen(E.Comm66[n] > 0,
                            IntToStr(E.Comm66[n]),'---')]);
          end;
        end;
        DrawText(DG.Canvas.Handle,PChar(S),-1,Rect,
                 DT_CENTER+DT_VCENTER+DT_SINGLELINE);
      end;
   2: begin
        case ACol of
          0: S:='Датчик DP100';
        else
          begin
            n:=(ACol-1)*176+900;
            S:=Format('%s',[IfThen(E.Comm66[n+1] > 0,
                            IntToStr(E.Comm66[n+1]),'---')]);
          end;
        end;
        DrawText(DG.Canvas.Handle,PChar(S),-1,Rect,
                 DT_CENTER+DT_VCENTER+DT_SINGLELINE);
      end;
   3: begin
        case ACol of
          0: S:='Датчик DP30';
        else
          begin
            n:=(ACol-1)*176+900;
            S:=Format('%s',[IfThen(E.Comm66[n+2] and $0f > 0,
                            IntToStr(E.Comm66[n+2] and $0f),'---')]);
          end;
        end;
        DrawText(DG.Canvas.Handle,PChar(S),-1,Rect,
                 DT_CENTER+DT_VCENTER+DT_SINGLELINE);
      end;
   4: begin
        case ACol of
          0: S:='Датчик DP30';
        else
          begin
            n:=(ACol-1)*176+900;
            S:=Format('%s',[IfThen(E.Comm66[n+2] shr 4 > 0,
                            IntToStr(E.Comm66[n+2] shr 4),'---')]);
          end;
        end;
        DrawText(DG.Canvas.Handle,PChar(S),-1,Rect,
                 DT_CENTER+DT_VCENTER+DT_SINGLELINE);
      end;
   5: begin
        case ACol of
          0: S:='Датчик T';
        else
          begin
            n:=(ACol-1)*176+900;
            S:=Format('%s',[IfThen(E.Comm66[n+3] > 0,
                            IntToStr(E.Comm66[n+3]),'---')]);
          end;
        end;
        DrawText(DG.Canvas.Handle,PChar(S),-1,Rect,
                 DT_CENTER+DT_VCENTER+DT_SINGLELINE);
      end;
   6: begin
        case ACol of
          0: S:='Рабочая среда';
        else
          begin
            n:=(ACol-1)*176+900;
            case E.Comm66[n+16] of
              0: S:='Вода';
              1: S:='Пар насыщенный';
              2: S:='Пар перегретый';
              3: S:='Природный газ';
              4: S:='Прочие газы';
            else
              S:='???';  
            end;
          end;
        end;
        DrawText(DG.Canvas.Handle,PChar(S),-1,Rect,
                 DT_CENTER+DT_VCENTER+DT_SINGLELINE);
      end;
   7: begin
        case ACol of
          0: S:='Вид СУ';
        else
          begin
            n:=(ACol-1)*176+900;
            case E.Comm66[n+17] of
             0: S:='Диафр. фл.отб.';
             1: S:='Диафр. уг.отб.';
             2: S:='Сопло';
             3: S:='Сопло Вентури';
            else
              S:='???';
            end;
          end;
        end;
        DrawText(DG.Canvas.Handle,PChar(S),-1,Rect,
                 DT_CENTER+DT_VCENTER+DT_SINGLELINE);
      end;
   8: begin
        case ACol of
          0: S:='D(СУ)';
        else
          begin
            n:=(ACol-1)*176+900;
            MoveMemory(@R,@E.Comm66[n+18],4);
            S:=Format('%.6g мм',[R]);
          end;
        end;
        DrawText(DG.Canvas.Handle,PChar(S),-1,Rect,
                 DT_CENTER+DT_VCENTER+DT_SINGLELINE);
      end;
   9: begin
        case ACol of
          0: S:='B(СУ)';
        else
          begin
            n:=(ACol-1)*176+900;
            MoveMemory(@R,@E.Comm66[n+22],4);
            S:=Format('%.6g мм',[R]);
          end;
        end;
        DrawText(DG.Canvas.Handle,PChar(S),-1,Rect,
                 DT_CENTER+DT_VCENTER+DT_SINGLELINE);
      end;
  10: begin
        case ACol of
          0: S:='D(ТР)';
        else
          begin
            n:=(ACol-1)*176+900;
            MoveMemory(@R,@E.Comm66[n+26],4);
            S:=Format('%.6g мм',[R]);
          end;
        end;
        DrawText(DG.Canvas.Handle,PChar(S),-1,Rect,
                 DT_CENTER+DT_VCENTER+DT_SINGLELINE);
      end;
  11: begin
        case ACol of
          0: S:='B(ТР)';
        else
          begin
            n:=(ACol-1)*176+900;
            MoveMemory(@R,@E.Comm66[n+30],4);
            S:=Format('%.6g мм',[R]);
          end;
        end;
        DrawText(DG.Canvas.Handle,PChar(S),-1,Rect,
                 DT_CENTER+DT_VCENTER+DT_SINGLELINE);
      end;
  12: begin
        case ACol of
          0: S:='КШ';
        else
          begin
            n:=(ACol-1)*176+900;
            MoveMemory(@R,@E.Comm66[n+34],4);
            S:=Format('%.6g мм',[R]);
          end;
        end;
        DrawText(DG.Canvas.Handle,PChar(S),-1,Rect,
                 DT_CENTER+DT_VCENTER+DT_SINGLELINE);
      end;
  13: begin
        case ACol of
          0: S:='КП';
        else
          begin
            n:=(ACol-1)*176+900;
            MoveMemory(@R,@E.Comm66[n+38],4);
            S:=Format('%.6g мм',[R]);
          end;
        end;
        DrawText(DG.Canvas.Handle,PChar(S),-1,Rect,
                 DT_CENTER+DT_VCENTER+DT_SINGLELINE);
      end;
  14: begin
        case ACol of
          0: S:='CO2';
        else
          begin
            n:=(ACol-1)*176+900;
            MoveMemory(@R,@E.Comm66[n+42],4);
            S:=Format('%.6g %%',[R]);
          end;
        end;
        DrawText(DG.Canvas.Handle,PChar(S),-1,Rect,
                 DT_CENTER+DT_VCENTER+DT_SINGLELINE);
      end;
  15: begin
        case ACol of
          0: S:='N2';
        else
          begin
            n:=(ACol-1)*176+900;
            MoveMemory(@R,@E.Comm66[n+46],4);
            S:=Format('%.6g %%',[R]);
          end;
        end;
        DrawText(DG.Canvas.Handle,PChar(S),-1,Rect,
                 DT_CENTER+DT_VCENTER+DT_SINGLELINE);
      end;
  16: begin
        case ACol of
          0: S:='Плотн.';
        else
          begin
            n:=(ACol-1)*176+900;
            MoveMemory(@R,@E.Comm66[n+50],4);
            S:=Format('%.6g кг/м3',[R]);
          end;
        end;
        DrawText(DG.Canvas.Handle,PChar(S),-1,Rect,
                 DT_CENTER+DT_VCENTER+DT_SINGLELINE);
      end;
  17: begin
        case ACol of
          0: S:='M[Д]';
        else
          begin
            n:=(ACol-1)*176+900;
            MoveMemory(@R,@E.Comm66[n+139],4);
            S:=Format('%.6g',[R]);
          end;
        end;
        DrawText(DG.Canvas.Handle,PChar(S),-1,Rect,
                 DT_CENTER+DT_VCENTER+DT_SINGLELINE);
      end;
  18: begin
        case ACol of
          0: S:='Q[Д]';
        else
          begin
            n:=(ACol-1)*176+900;
            MoveMemory(@R,@E.Comm66[n+143],4);
            S:=Format('%.6g',[R]);
          end;
        end;
        DrawText(DG.Canvas.Handle,PChar(S),-1,Rect,
                 DT_CENTER+DT_VCENTER+DT_SINGLELINE);
      end;
  19: begin
        case ACol of
          0: S:='Учет';
        else
          begin
            n:=(ACol-1)*176+900;
            S:=IfThen(E.Comm66[n+70]>0,'Да','Нет');
          end;
        end;
        DrawText(DG.Canvas.Handle,PChar(S),-1,Rect,
                 DT_CENTER+DT_VCENTER+DT_SINGLELINE);
      end;
  end;
end;

end.
