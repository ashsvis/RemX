unit ResursChannelsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, ResursGLHUnit, Grids;

type
  TResursChannelsForm = class(TForm)
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
    procedure FormCreate(Sender: TObject);
  private
  public
    E: TResursGLHNode;
  end;

var
  ResursChannelsForm: TResursChannelsForm;

implementation

{$R *.dfm}

procedure TResursChannelsForm.tbCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TResursChannelsForm.tbFreshClick(Sender: TObject);
begin
//
end;

procedure TResursChannelsForm.FormShow(Sender: TObject);
begin
  tbFresh.Click;
end;

procedure TResursChannelsForm.DGDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var S: string; n: integer; R: Single;
begin
  case ARow of
   0: begin
        case ACol of
          0: S:='Канал';
          1: S:='Датчик';
          2: S:='Вх.сигнал';
          3: S:='Е.И.';
          4: S:='X.MIN';
          5: S:='X.MAX';
          6: S:='X0';
          7: S:='X.Д';
          8: S:='A0';
          9: S:='B0';
        end;
        DrawText(DG.Canvas.Handle,PChar(S),-1,Rect,
                 DT_CENTER+DT_VCENTER+DT_SINGLELINE);
      end;
  else
    begin
      n:=(ARow-1)*60;
      case ACol of
        0: S:=Format('%d',[ARow]);
        1: if E.Comm66[n] in [0..10] then
             S:=ASensorType[E.Comm66[n]]
           else
             S:='???';
        2: if E.Comm66[n+1] in [0..3] then
             S:=AInputRange[E.Comm66[n+1]]
           else
             S:='???';
        3: if E.Comm66[n] = 10 then
           begin
             if E.Comm66[n+2] in [0..3] then
               S:=AEUDesc66_1[E.Comm66[n+2]]
             else
               S:='???';
           end
           else
           begin
             if E.Comm66[n+2] in [0..4] then
               S:=AEUDesc66_2[E.Comm66[n+2]]
             else
               S:='???';
           end;
        4: begin
             MoveMemory(@R,@E.Comm66[n+4],4);
             S:=Format('%.6g',[R]);
           end;
        5: begin
             MoveMemory(@R,@E.Comm66[n+8],4);
             S:=Format('%.6g',[R]);
           end;
        6: begin
             MoveMemory(@R,@E.Comm66[n+12],4);
             S:=Format('%.6g',[R]);
           end;
        7: begin
             MoveMemory(@R,@E.Comm66[n+24],4);
             S:=Format('%.6g',[R]);
           end;
        8: begin
             MoveMemory(@R,@E.Comm66[n+28],4);
             S:=Format('%.6g',[R]);
           end;
        9: begin
             MoveMemory(@R,@E.Comm66[n+32],4);
             S:=Format('%.6g',[R]);
           end;
      end;
      DrawText(DG.Canvas.Handle,PChar(S),-1,Rect,
               DT_CENTER+DT_VCENTER+DT_SINGLELINE);
    end;
  end;
end;

procedure TResursChannelsForm.FormCreate(Sender: TObject);
begin
  DG.ColWidths[0]:=44;
end;

end.
