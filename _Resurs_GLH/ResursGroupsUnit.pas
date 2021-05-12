unit ResursGroupsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, ResursGLHUnit, Grids;

type
  TResursGroupsForm = class(TForm)
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
  ResursGroupsForm: TResursGroupsForm;

implementation

{$R *.dfm}

procedure TResursGroupsForm.tbCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TResursGroupsForm.tbFreshClick(Sender: TObject);
begin
//
end;

procedure TResursGroupsForm.FormShow(Sender: TObject);
begin
  tbFresh.Click;
end;

procedure TResursGroupsForm.DGDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var S: string; n,i: integer; R: Single;
begin
  case ARow of
   0: begin
        case ACol of
          0: S:='Группа';
          1: S:='Е.И.';
          2: S:='Состав';
          3: S:='A0';
          4: S:='B0';
        end;
        DrawText(DG.Canvas.Handle,PChar(S),-1,Rect,
                 DT_CENTER+DT_VCENTER+DT_SINGLELINE);
      end;
  else
    begin
      n:=(ARow-1)*336;
      case ACol of
        0: S:=Format('%d',[ARow]);
        1: S:=AEUDesc[E.Comm22[n]];
        2: begin
             SetLength(S,50);
             FillChar(S[1],50,' ');
             for i:=0 to 49 do S[i+1]:=Char(E.Comm22[n+286+i]);
           end;
        3: begin
             MoveMemory(@R,@E.Comm22[n+29],4);
             S:=Format('%.6g',[R]);
           end;
        4: begin
             MoveMemory(@R,@E.Comm22[n+33],4);
             S:=Format('%.6g',[R]);
           end;
      end;
      DrawText(DG.Canvas.Handle,PChar(S),-1,Rect,
               DT_CENTER+DT_VCENTER+DT_SINGLELINE);
    end;
  end;
end;

procedure TResursGroupsForm.FormCreate(Sender: TObject);
begin
  DG.ColWidths[0]:=44;
end;

end.
