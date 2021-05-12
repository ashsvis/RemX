unit LogsCreator;

interface

procedure CreateLogDatabase(Path: string);

implementation

uses IBDatabase, IBCustomDataSet, IBSQL;

procedure CreateLogDatabase(Path: string);
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
// create AlarmLog table
            with SL.SQL do
            begin
              Clear;
              Add('create generator g_alarmlog;');
            end;
            SL.ExecQuery;
            with SL.SQL do
            begin
              Clear;
              Add('create table alarmlog');
              Add('(');
              Add(' Id INTEGER NOT NULL,');
              Add(' SnapTime TIMESTAMP NOT NULL,');
              Add(' Station VARCHAR(2),');
              Add(' Posit VARCHAR(16),');
              Add(' Param VARCHAR(16),');
              Add(' Val VARCHAR(16),');
              Add(' SetPoint VARCHAR(16),');
              Add(' Mess VARCHAR(48),');
              Add(' Descriptor VARCHAR(48),');
              Add('PRIMARY KEY(SnapTime,Id)');
              Add(');');
            end;
            SL.ExecQuery;
            with SL.SQL do
            begin
              Clear;
              Add('create trigger set_alarmlog_id for alarmlog');
              Add('before insert position 0 as');
              Add('begin');
              Add('  new.id = gen_id (g_alarmlog, 1);');
              Add('end');
            end;
            SL.ExecQuery;
            with SL.SQL do
            begin
              Clear;
              Add('create procedure updatealarmlog (');
              Add('SNAPTIME TIMESTAMP,');
              Add('STATION VARCHAR(2),');
              Add('POSIT VARCHAR(16),');
              Add('PARAM VARCHAR(16),');
              Add('VAL VARCHAR(16),');
              Add('SETPOINT VARCHAR(16),');
              Add('MESS VARCHAR(48),');
              Add('DESCRIPTOR VARCHAR(48)) AS');
              Add('BEGIN');
              Add(' INSERT INTO AlarmLog');
              Add(' (SnapTime,Station,Posit,Param,Val,SetPoint,Mess,Descriptor)');
              Add(' VALUES (:SNAPTIME,:STATION,:POSIT,:PARAM,'+
                            ':VAL,:SETPOINT,:MESS,:DESCRIPTOR);');
              Add('END');
            end;
            SL.ExecQuery;
// create SwitchLog table
            with SL.SQL do
            begin
              Clear;
              Add('create generator g_switchlog;');
            end;
            SL.ExecQuery;
            with SL.SQL do
            begin
              Clear;
              Add('create table switchlog');
              Add('(');
              Add(' Id INTEGER NOT NULL,');
              Add(' SnapTime TIMESTAMP NOT NULL,');
              Add(' Station VARCHAR(2),');
              Add(' Posit VARCHAR(16),');
              Add(' Param VARCHAR(16),');
              Add(' OldValue VARCHAR(16),');
              Add(' NewValue VARCHAR(16),');
              Add(' Descriptor VARCHAR(48),');
              Add('PRIMARY KEY(SnapTime,Id)');
              Add(');');
            end;
            SL.ExecQuery;
            with SL.SQL do
            begin
              Clear;
              Add('create trigger set_switchlog_id for switchlog');
              Add('before insert position 0 as');
              Add('begin');
              Add('  new.id = gen_id (g_switchlog, 1);');
              Add('end');
            end;
            SL.ExecQuery;
            with SL.SQL do
            begin
              Clear;
              Add('create procedure updateswitchlog (');
              Add('SNAPTIME TIMESTAMP,');
              Add('STATION VARCHAR(2),');
              Add('POSIT VARCHAR(16),');
              Add('PARAM VARCHAR(16),');
              Add('OLDVALUE VARCHAR(16),');
              Add('NEWVALUE VARCHAR(16),');
              Add('DESCRIPTOR VARCHAR(48)) AS');
              Add('BEGIN');
              Add(' INSERT INTO SwitchLog');
              Add(' (SnapTime,Station,Posit,Param,OldValue,NewValue,Descriptor)');
              Add(' VALUES (:SNAPTIME,:STATION,:POSIT,:PARAM,'+
                            ':OLDVALUE,:NEWVALUE,:DESCRIPTOR);');
              Add('END');
            end;
            SL.ExecQuery;
// create ChangeLog table
            with SL.SQL do
            begin
              Clear;
              Add('create generator g_changelog;');
            end;
            SL.ExecQuery;
            with SL.SQL do
            begin
              Clear;
              Add('create table changelog');
              Add('(');
              Add(' Id INTEGER NOT NULL,');
              Add(' SnapTime TIMESTAMP NOT NULL,');
              Add(' Station VARCHAR(2),');
              Add(' Posit VARCHAR(16),');
              Add(' Param VARCHAR(16),');
              Add(' OldValue VARCHAR(16),');
              Add(' NewValue VARCHAR(16),');
              Add(' Descriptor VARCHAR(48),');
              Add(' Autor VARCHAR(16),');
              Add('PRIMARY KEY(SnapTime,Id)');
              Add(');');
            end;
            SL.ExecQuery;
            with SL.SQL do
            begin
              Clear;
              Add('create trigger set_changelog_id for changelog');
              Add('before insert position 0 as');
              Add('begin');
              Add('  new.id = gen_id (g_changelog, 1);');
              Add('end');
            end;
            SL.ExecQuery;
            with SL.SQL do
            begin
              Clear;
              Add('create procedure updatechangelog (');
              Add('SNAPTIME TIMESTAMP,');
              Add('STATION VARCHAR(2),');
              Add('POSIT VARCHAR(16),');
              Add('PARAM VARCHAR(16),');
              Add('OLDVALUE VARCHAR(16),');
              Add('NEWVALUE VARCHAR(16),');
              Add('DESCRIPTOR VARCHAR(48),');
              Add('AUTOR VARCHAR(16)) AS');
              Add('BEGIN');
              Add(' INSERT INTO ChangeLog');
              Add(' (SnapTime,Station,Posit,Param,OldValue,NewValue,Descriptor,Autor)');
              Add(' VALUES (:SNAPTIME,:STATION,:POSIT,:PARAM,'+
                           ':OLDVALUE,:NEWVALUE,:DESCRIPTOR,:AUTOR);');
              Add('END');
            end;
            SL.ExecQuery;
// create SystemLog table
            with SL.SQL do
            begin
              Clear;
              Add('create generator g_systemlog;');
            end;
            SL.ExecQuery;
            with SL.SQL do
            begin
              Clear;
              Add('create table systemlog');
              Add('(');
              Add(' Id INTEGER NOT NULL,');
              Add(' SnapTime TIMESTAMP NOT NULL,');
              Add(' Station VARCHAR(2),');
              Add(' Posit VARCHAR(16),');
              Add(' Param VARCHAR(96),');
              Add('PRIMARY KEY(SnapTime,Id)');
              Add(');');
            end;
            SL.ExecQuery;
            with SL.SQL do
            begin
              Clear;
              Add('create trigger set_systemlog_id for systemlog');
              Add('before insert position 0 as');
              Add('begin');
              Add('  new.id = gen_id (g_systemlog, 1);');
              Add('end');
            end;
            SL.ExecQuery;
            with SL.SQL do
            begin
              Clear;
              Add('create procedure updatesystemlog (');
              Add('SNAPTIME TIMESTAMP,');
              Add('STATION VARCHAR(2),');
              Add('POSIT VARCHAR(16),');
              Add('PARAM VARCHAR(96)) AS');
              Add('BEGIN');
              Add(' INSERT INTO SystemLog');
              Add(' (SnapTime,Station,Posit,Param)');
              Add(' VALUES (:SNAPTIME,:STATION,:POSIT,:PARAM);');
              Add('END');
            end;
            SL.ExecQuery;
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
