unit TrendsCreator;

interface

procedure CreateTrendsDatabase(Path: string);

implementation

uses IBDatabase, IBCustomDataSet, IBSQL;

procedure CreateTrendsDatabase(Path: string);
var DB: TIBDatabase; TR: TIBTransaction; SL: TIBSQL;
begin
  DB:=TIBDatabase.Create(nil);
  try
    DB.DatabaseName:=Path;
    DB.Params.Add('user_name=SYSDBA');
    DB.Params.Add('password=14159265');
    DB.LoginPrompt:=False;
    TR:=TIBTransaction.Create(nil);
    try
      TR.DefaultDatabase:=DB;
      DB.DefaultTransaction:=TR;
      SL:=TIBSQL.Create(nil);
      try
        SL.Database:=DB;
        SL.Transaction:=TR;
        DB.Connected:=True;
        try
          TR.StartTransaction;
          try
{----------------------------------------------------------}
// create TRENDS table
            with SL.SQL do
            begin
              Clear;
              Add('CREATE GENERATOR g_trends;');
            end;
            SL.ExecQuery;
            with SL.SQL do
            begin
              Clear;
              Add('CREATE TABLE trends');
              Add('(');
              Add(' Id INTEGER NOT NULL,');
              Add(' PName VARCHAR(20) NOT NULL,');
              Add(' SnapTime TIMESTAMP NOT NULL,');
              Add(' Val FLOAT,');
              Add(' Kind SMALLINT,');
              Add('PRIMARY KEY(PName,SnapTime,Id)');
              Add(');');
            end;
            SL.ExecQuery;
            with SL.SQL do
            begin
              Clear;
              Add('CREATE TRIGGER set_trends_id FOR trends');
              Add('BEFORE INSERT POSITION 0 AS');
              Add('BEGIN');
              Add('  new.id = gen_id (g_trends, 1);');
              Add('END');
            end;
            SL.ExecQuery;
            with SL.SQL do
            begin
              Clear;
              Add('CREATE PROCEDURE updatetrends (');
              Add('P1 VARCHAR(20),');
              Add('P2 TIMESTAMP,');
              Add('P3 FLOAT,');
              Add('P4 SMALLINT) AS');
              Add('BEGIN');
              Add(' INSERT INTO trends');
              Add(' (PName,SnapTime,Val,Kind)');
              Add(' VALUES (:P1,:P2,:P3,:P4);');
              Add('END');
            end;
            SL.ExecQuery;
{----------------------------------------------------------}
// create SN_SNAP table
            with SL.SQL do
            begin
              Clear;
              Add('CREATE GENERATOR g_sn_snap;');
            end;
            SL.ExecQuery;
            with SL.SQL do
            begin
              Clear;
              Add('CREATE TABLE sn_snap');
              Add('(');
              Add(' Id INTEGER NOT NULL,');
              Add(' SnapTime TIMESTAMP NOT NULL,');
              Add(' GroupNo INTEGER NOT NULL,');
              Add(' Val1 FLOAT,');
              Add(' Val2 FLOAT,');
              Add(' Val3 FLOAT,');
              Add(' Val4 FLOAT,');
              Add(' Val5 FLOAT,');
              Add(' Val6 FLOAT,');
              Add(' Val7 FLOAT,');
              Add(' Val8 FLOAT,');
              Add(' Kind1 SMALLINT,');
              Add(' Kind2 SMALLINT,');
              Add(' Kind3 SMALLINT,');
              Add(' Kind4 SMALLINT,');
              Add(' Kind5 SMALLINT,');
              Add(' Kind6 SMALLINT,');
              Add(' Kind7 SMALLINT,');
              Add(' Kind8 SMALLINT,');
              Add('PRIMARY KEY(SnapTime,GroupNo,Id)');
              Add(');');
            end;
            SL.ExecQuery;
            with SL.SQL do
            begin
              Clear;
              Add('CREATE TRIGGER set_sn_snap_id FOR sn_snap');
              Add('BEFORE INSERT POSITION 0 AS');
              Add('BEGIN');
              Add('  new.id = gen_id (g_sn_snap, 1);');
              Add('END');
            end;
            SL.ExecQuery;
            with SL.SQL do
            begin
              Clear;
              Add('CREATE PROCEDURE updatesn_snap (');
              Add('P1 TIMESTAMP,');
              Add('P2 INTEGER,');
              Add('P3 FLOAT,');
              Add('P4 FLOAT,');
              Add('P5 FLOAT,');
              Add('P6 FLOAT,');
              Add('P7 FLOAT,');
              Add('P8 FLOAT,');
              Add('P9 FLOAT,');
              Add('P10 FLOAT,');
              Add('P11 SMALLINT,');
              Add('P12 SMALLINT,');
              Add('P13 SMALLINT,');
              Add('P14 SMALLINT,');
              Add('P15 SMALLINT,');
              Add('P16 SMALLINT,');
              Add('P17 SMALLINT,');
              Add('P18 SMALLINT) AS');
              Add('BEGIN');
              Add(' INSERT INTO sn_snap');
              Add(' (SnapTime,GroupNo,Val1,Val2,Val3,Val4,Val5,Val6,Val7,Val8,');
              Add('  Kind1,Kind2,Kind3,Kind4,Kind5,Kind6,Kind7,Kind8)');
              Add(' VALUES (:P1,:P2,:P3,:P4,:P5,:P6,:P7,:P8,:P9,:P10,:P11,');
              Add('         :P12,:P13,:P14,:P15,:P16,:P17,:P18);');
              Add('END');
            end;
            SL.ExecQuery;
{----------------------------------------------------------}
// create HR_SNAP table
            with SL.SQL do
            begin
              Clear;
              Add('CREATE GENERATOR g_hr_snap;');
            end;
            SL.ExecQuery;
            with SL.SQL do
            begin
              Clear;
              Add('CREATE TABLE hr_snap');
              Add('(');
              Add(' Id INTEGER NOT NULL,');
              Add(' SnapTime TIMESTAMP NOT NULL,');
              Add(' GroupNo INTEGER NOT NULL,');
              Add(' Val1 FLOAT,');
              Add(' Val2 FLOAT,');
              Add(' Val3 FLOAT,');
              Add(' Val4 FLOAT,');
              Add(' Val5 FLOAT,');
              Add(' Val6 FLOAT,');
              Add(' Val7 FLOAT,');
              Add(' Val8 FLOAT,');
              Add(' Kind1 SMALLINT,');
              Add(' Kind2 SMALLINT,');
              Add(' Kind3 SMALLINT,');
              Add(' Kind4 SMALLINT,');
              Add(' Kind5 SMALLINT,');
              Add(' Kind6 SMALLINT,');
              Add(' Kind7 SMALLINT,');
              Add(' Kind8 SMALLINT,');
              Add('PRIMARY KEY(SnapTime,GroupNo,Id)');
              Add(');');
            end;
            SL.ExecQuery;
            with SL.SQL do
            begin
              Clear;
              Add('CREATE TRIGGER set_hr_snap_id FOR hr_snap');
              Add('BEFORE INSERT POSITION 0 AS');
              Add('BEGIN');
              Add('  new.id = gen_id (g_hr_snap, 1);');
              Add('END');
            end;
            SL.ExecQuery;
            with SL.SQL do
            begin
              Clear;
              Add('CREATE PROCEDURE updatehr_snap (');
              Add('P1 TIMESTAMP,');
              Add('P2 INTEGER,');
              Add('P3 FLOAT,');
              Add('P4 FLOAT,');
              Add('P5 FLOAT,');
              Add('P6 FLOAT,');
              Add('P7 FLOAT,');
              Add('P8 FLOAT,');
              Add('P9 FLOAT,');
              Add('P10 FLOAT,');
              Add('P11 SMALLINT,');
              Add('P12 SMALLINT,');
              Add('P13 SMALLINT,');
              Add('P14 SMALLINT,');
              Add('P15 SMALLINT,');
              Add('P16 SMALLINT,');
              Add('P17 SMALLINT,');
              Add('P18 SMALLINT) AS');
              Add('BEGIN');
              Add(' INSERT INTO hr_snap');
              Add(' (SnapTime,GroupNo,Val1,Val2,Val3,Val4,Val5,Val6,Val7,Val8,');
              Add('  Kind1,Kind2,Kind3,Kind4,Kind5,Kind6,Kind7,Kind8)');
              Add(' VALUES (:P1,:P2,:P3,:P4,:P5,:P6,:P7,:P8,:P9,:P10,:P11,');
              Add('         :P12,:P13,:P14,:P15,:P16,:P17,:P18);');
              Add('END');
            end;
            SL.ExecQuery;
{----------------------------------------------------------}
// create HR_AVER table
            with SL.SQL do
            begin
              Clear;
              Add('CREATE GENERATOR g_hr_aver;');
            end;
            SL.ExecQuery;
            with SL.SQL do
            begin
              Clear;
              Add('CREATE TABLE hr_aver');
              Add('(');
              Add(' Id INTEGER NOT NULL,');
              Add(' SnapTime TIMESTAMP NOT NULL,');
              Add(' GroupNo INTEGER NOT NULL,');
              Add(' Val1 FLOAT,');
              Add(' Val2 FLOAT,');
              Add(' Val3 FLOAT,');
              Add(' Val4 FLOAT,');
              Add(' Val5 FLOAT,');
              Add(' Val6 FLOAT,');
              Add(' Val7 FLOAT,');
              Add(' Val8 FLOAT,');
              Add(' Kind1 SMALLINT,');
              Add(' Kind2 SMALLINT,');
              Add(' Kind3 SMALLINT,');
              Add(' Kind4 SMALLINT,');
              Add(' Kind5 SMALLINT,');
              Add(' Kind6 SMALLINT,');
              Add(' Kind7 SMALLINT,');
              Add(' Kind8 SMALLINT,');
              Add('PRIMARY KEY(SnapTime,GroupNo,Id)');
              Add(');');
            end;
            SL.ExecQuery;
            with SL.SQL do
            begin
              Clear;
              Add('CREATE TRIGGER set_hr_aver_id FOR hr_aver');
              Add('BEFORE INSERT POSITION 0 AS');
              Add('BEGIN');
              Add('  new.id = gen_id (g_hr_aver, 1);');
              Add('END');
            end;
            SL.ExecQuery;
            with SL.SQL do
            begin
              Clear;
              Add('CREATE TRIGGER bi_hr_aver FOR hr_aver');
              Add('BEFORE INSERT POSITION 1 AS');
              Add('BEGIN');
              Add(' DELETE FROM hr_aver');
              Add(' WHERE GroupNo = new.GroupNo AND');
              Add(' SnapTime BETWEEN'+
                  ' EXTRACT (YEAR FROM CURRENT_DATE) || ''-'' ||'+
                  ' EXTRACT (MONTH FROM CURRENT_DATE) || ''-'' ||'+
                  ' EXTRACT (DAY FROM CURRENT_DATE) || '' '' ||'+
                  ' EXTRACT (HOUR FROM CURRENT_TIME) || '':00:00.0000'''+
                  ' AND'+
                  ' EXTRACT (YEAR FROM CURRENT_DATE) || ''-'' ||'+
                  ' EXTRACT (MONTH FROM CURRENT_DATE) || ''-'' ||'+
                  ' EXTRACT (DAY FROM CURRENT_DATE) || '' '' ||'+
                  ' EXTRACT (HOUR FROM CURRENT_TIME) || '':59:59.9999'';');
              Add('END');
            end;
            SL.ExecQuery;
            with SL.SQL do
            begin
              Clear;
              Add('CREATE TRIGGER calc_hr_aver FOR sn_snap');
              Add('AFTER INSERT POSITION 0 AS');
              Add('BEGIN');
              Add(' INSERT INTO hr_aver');
              Add(' (SnapTime,GroupNo,Val1,Val2,Val3,Val4,Val5,Val6,Val7,Val8,');
              Add('  Kind1,Kind2,Kind3,Kind4,Kind5,Kind6,Kind7,Kind8)');
              Add(' SELECT MIN(SnapTime),GroupNo,');
              Add('        AVG(Val1),AVG(Val2),AVG(Val3),AVG(Val4),');
              Add('        AVG(Val5),AVG(Val6),AVG(Val7),AVG(Val8),');
              Add('   SUM(Kind1)/60,SUM(Kind2)/60,SUM(Kind3)/60,SUM(Kind4)/60,');
              Add('   SUM(Kind5)/60,SUM(Kind6)/60,SUM(Kind7)/60,SUM(Kind8)/60');
              Add('    FROM sn_snap');
              Add('    WHERE (');
              Add(' SnapTime BETWEEN'+
                  ' EXTRACT(YEAR FROM CURRENT_DATE) || ''-'' ||'+
                  ' EXTRACT(MONTH FROM CURRENT_DATE) || ''-'' ||'+
                  ' EXTRACT(DAY FROM CURRENT_DATE) || '' '' ||'+
                  ' EXTRACT(HOUR FROM CURRENT_TIME) || '':00:00.0000'''+
                  ' AND'+
                  ' EXTRACT(YEAR FROM CURRENT_DATE) || ''-'' ||'+
                  ' EXTRACT(MONTH FROM CURRENT_DATE) || ''-'' ||'+
                  ' EXTRACT(DAY FROM CURRENT_DATE) || '' '' ||'+
                  ' EXTRACT(HOUR FROM CURRENT_TIME) || '':59:59.9999'')');
              Add('    GROUP BY GroupNo');
              Add('    HAVING (GroupNo = new.GroupNo);');
              Add('END');
            end;
            SL.ExecQuery;
{----------------------------------------------------------}
// create DL_AVER table
            with SL.SQL do
            begin
              Clear;
              Add('CREATE GENERATOR g_dl_aver;');
            end;
            SL.ExecQuery;
            with SL.SQL do
            begin
              Clear;
              Add('CREATE TABLE dl_aver');
              Add('(');
              Add(' Id INTEGER NOT NULL,');
              Add(' SnapTime TIMESTAMP NOT NULL,');
              Add(' GroupNo INTEGER NOT NULL,');
              Add(' Val1 FLOAT,');
              Add(' Val2 FLOAT,');
              Add(' Val3 FLOAT,');
              Add(' Val4 FLOAT,');
              Add(' Val5 FLOAT,');
              Add(' Val6 FLOAT,');
              Add(' Val7 FLOAT,');
              Add(' Val8 FLOAT,');
              Add(' Kind1 SMALLINT,');
              Add(' Kind2 SMALLINT,');
              Add(' Kind3 SMALLINT,');
              Add(' Kind4 SMALLINT,');
              Add(' Kind5 SMALLINT,');
              Add(' Kind6 SMALLINT,');
              Add(' Kind7 SMALLINT,');
              Add(' Kind8 SMALLINT,');
              Add('PRIMARY KEY(SnapTime,GroupNo,Id)');
              Add(');');
            end;
            SL.ExecQuery;
            with SL.SQL do
            begin
              Clear;
              Add('CREATE TRIGGER set_dl_aver_id FOR dl_aver');
              Add('BEFORE INSERT POSITION 0 AS');
              Add('BEGIN');
              Add('  new.id = gen_id (g_dl_aver, 1);');
              Add('END');
            end;
            SL.ExecQuery;
            with SL.SQL do
            begin
              Clear;
              Add('CREATE TRIGGER bi_dl_aver FOR dl_aver');
              Add('BEFORE INSERT POSITION 1 AS');
              Add('BEGIN');
              Add(' DELETE FROM dl_aver');
              Add(' WHERE GroupNo = new.GroupNo AND');
              Add(' SnapTime BETWEEN'+
                  ' EXTRACT(YEAR FROM CURRENT_DATE) || ''-'' ||'+
                  ' EXTRACT(MONTH FROM CURRENT_DATE) || ''-'' ||'+
                  ' EXTRACT(DAY FROM CURRENT_DATE) || '' 00:00:00.0000'''+
                  ' AND'+
                  ' EXTRACT(YEAR FROM CURRENT_DATE) || ''-'' ||'+
                  ' EXTRACT(MONTH FROM CURRENT_DATE) || ''-'' ||'+
                  ' EXTRACT(DAY FROM CURRENT_DATE) || '' 23:59:59.9999'';');
              Add('END');
            end;
            SL.ExecQuery;
            with SL.SQL do
            begin
              Clear;
              Add('CREATE TRIGGER calc_dl_aver FOR hr_aver');
              Add('AFTER INSERT POSITION 0 AS');
              Add('BEGIN');
              Add(' INSERT INTO dl_aver');
              Add(' (SnapTime,GroupNo,Val1,Val2,Val3,Val4,Val5,Val6,Val7,Val8,');
              Add('  Kind1,Kind2,Kind3,Kind4,Kind5,Kind6,Kind7,Kind8)');
              Add(' SELECT MIN(SnapTime),GroupNo,');
              Add('        AVG(Val1),AVG(Val2),AVG(Val3),AVG(Val4),');
              Add('        AVG(Val5),AVG(Val6),AVG(Val7),AVG(Val8),');
              Add('   SUM(Kind1)/24,SUM(Kind2)/24,SUM(Kind3)/24,SUM(Kind4)/24,');
              Add('   SUM(Kind5)/24,SUM(Kind6)/24,SUM(Kind7)/24,SUM(Kind8)/24');
              Add('    FROM hr_aver');
              Add('    WHERE (');
              Add(' SnapTime BETWEEN'+
                  ' EXTRACT(YEAR FROM CURRENT_DATE) || ''-'' ||'+
                  ' EXTRACT(MONTH FROM CURRENT_DATE) || ''-'' ||'+
                  ' EXTRACT(DAY FROM CURRENT_DATE) || '' 00:00:00.0000'''+
                  ' AND'+
                  ' EXTRACT(YEAR FROM CURRENT_DATE) || ''-'' ||'+
                  ' EXTRACT(MONTH FROM CURRENT_DATE) || ''-'' ||'+
                  ' EXTRACT(DAY FROM CURRENT_DATE) || '' 23:59:59.9999'')');
              Add('    GROUP BY GroupNo');
              Add('    HAVING (GroupNo = new.GroupNo);');
              Add('END');
            end;
            SL.ExecQuery;
{----------------------------------------------------------}
// create MN_AVER table
            with SL.SQL do
            begin
              Clear;
              Add('CREATE GENERATOR g_mn_aver;');
            end;
            SL.ExecQuery;
            with SL.SQL do
            begin
              Clear;
              Add('CREATE TABLE mn_aver');
              Add('(');
              Add(' Id INTEGER NOT NULL,');
              Add(' SnapTime TIMESTAMP NOT NULL,');
              Add(' GroupNo INTEGER NOT NULL,');
              Add(' Val1 FLOAT,');
              Add(' Val2 FLOAT,');
              Add(' Val3 FLOAT,');
              Add(' Val4 FLOAT,');
              Add(' Val5 FLOAT,');
              Add(' Val6 FLOAT,');
              Add(' Val7 FLOAT,');
              Add(' Val8 FLOAT,');
              Add(' Kind1 SMALLINT,');
              Add(' Kind2 SMALLINT,');
              Add(' Kind3 SMALLINT,');
              Add(' Kind4 SMALLINT,');
              Add(' Kind5 SMALLINT,');
              Add(' Kind6 SMALLINT,');
              Add(' Kind7 SMALLINT,');
              Add(' Kind8 SMALLINT,');
              Add('PRIMARY KEY(SnapTime,GroupNo,Id)');
              Add(');');
            end;
            SL.ExecQuery;
            with SL.SQL do
            begin
              Clear;
              Add('CREATE TRIGGER set_mn_aver_id FOR mn_aver');
              Add('BEFORE INSERT POSITION 0 AS');
              Add('BEGIN');
              Add('  new.id = gen_id (g_mn_aver, 1);');
              Add('END');
            end;
            SL.ExecQuery;
            with SL.SQL do
            begin
              Clear;
              Add('CREATE TRIGGER bi_mn_aver FOR mn_aver');
              Add('BEFORE INSERT POSITION 1 AS');
              Add('BEGIN');
              Add(' DELETE FROM mn_aver');
              Add(' WHERE GroupNo = new.GroupNo AND');
              Add(' SnapTime BETWEEN'+
                  ' EXTRACT(YEAR FROM CURRENT_DATE) || ''-'' ||'+
                  ' EXTRACT(MONTH FROM CURRENT_DATE) || ''-01 00:00:00.0000'''+
                  ' AND'+
                  ' EXTRACT(YEAR FROM CURRENT_DATE) || ''-'' ||'+
                  ' EXTRACT(MONTH FROM CURRENT_DATE) || ''-'' ||'+
                  ' EXTRACT(DAY FROM CURRENT_DATE) || '' 23:59:59.9999'';');
              Add('END');
            end;
            SL.ExecQuery;
            with SL.SQL do
            begin
              Clear;
              Add('CREATE TRIGGER calc_mn_aver FOR dl_aver');
              Add('AFTER INSERT POSITION 0 AS');
              Add('BEGIN');
              Add(' INSERT INTO mn_aver');
              Add(' (SnapTime,GroupNo,Val1,Val2,Val3,Val4,Val5,Val6,Val7,Val8,');
              Add('  Kind1,Kind2,Kind3,Kind4,Kind5,Kind6,Kind7,Kind8)');
              Add(' SELECT MIN(SnapTime),GroupNo,');
              Add('        AVG(Val1),AVG(Val2),AVG(Val3),AVG(Val4),');
              Add('        AVG(Val5),AVG(Val6),AVG(Val7),AVG(Val8),');
              Add('   SUM(Kind1)/EXTRACT(DAY FROM CURRENT_DATE),'+
                     'SUM(Kind2)/EXTRACT(DAY FROM CURRENT_DATE),'+
                     'SUM(Kind3)/EXTRACT(DAY FROM CURRENT_DATE),'+
                     'SUM(Kind4)/EXTRACT(DAY FROM CURRENT_DATE),');
              Add('   SUM(Kind5)/EXTRACT(DAY FROM CURRENT_DATE),'+
                     'SUM(Kind6)/EXTRACT(DAY FROM CURRENT_DATE),'+
                     'SUM(Kind7)/EXTRACT(DAY FROM CURRENT_DATE),'+
                     'SUM(Kind8)/EXTRACT(DAY FROM CURRENT_DATE)');
              Add('    FROM dl_aver');
              Add('    WHERE (');
              Add(' SnapTime BETWEEN'+
                  ' EXTRACT(YEAR FROM CURRENT_DATE) || ''-'' ||'+
                  ' EXTRACT(MONTH FROM CURRENT_DATE) || ''-01 00:00:00.0000'''+
                  ' AND'+
                  ' EXTRACT(YEAR FROM CURRENT_DATE) || ''-'' ||'+
                  ' EXTRACT(MONTH FROM CURRENT_DATE) || ''-'' ||'+
                  ' EXTRACT(DAY FROM CURRENT_DATE) || '' 23:59:59.9999'')');
              Add('    GROUP BY GroupNo');
              Add('    HAVING (GroupNo = new.GroupNo);');
              Add('END');
            end;
            SL.ExecQuery;
{----------------------------------------------------------}
            with SL.SQL do
            begin
              Clear;
              Add('create table datefilter');
              Add('(Item VARCHAR(20));');
            end;
            SL.ExecQuery;
            TR.Commit;
          except
            TR.Rollback;
          end;
          TR.StartTransaction;
          try
            with SL.SQL do
            begin
              Clear;
              Add('insert into datefilter');
              Add('(Item) values (:Item);');
            end;
            SL.Prepare;
            SL.ParamByName('ITEM').AsString:='(Все)'; SL.ExecQuery;
            SL.ParamByName('ITEM').AsString:='(Условие...)'; SL.ExecQuery;
            SL.ParamByName('ITEM').AsString:='Последние 20 минут'; SL.ExecQuery;
            SL.ParamByName('ITEM').AsString:='Последний 1 час'; SL.ExecQuery;
            SL.ParamByName('ITEM').AsString:='Последние 2 часа'; SL.ExecQuery;
            SL.ParamByName('ITEM').AsString:='Последние 4 часа'; SL.ExecQuery;
            SL.ParamByName('ITEM').AsString:='Последние 8 часов'; SL.ExecQuery;
            SL.ParamByName('ITEM').AsString:='Последние 12 часов'; SL.ExecQuery;
            SL.ParamByName('ITEM').AsString:='Последние 24 часа'; SL.ExecQuery;
            SL.ParamByName('ITEM').AsString:='Последние 48 часов'; SL.ExecQuery;
            SL.ParamByName('ITEM').AsString:='Последние 72 часа'; SL.ExecQuery;
            TR.Commit;
          except
            TR.Rollback;
          end;
        finally
          DB.Connected:=False;
        end;
      finally
        SL.Free;
      end;
    finally
      TR.Free;
    end;
  finally
    DB.Free;
  end;
end;

end.
