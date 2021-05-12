unit EntitiesCreator;

interface

procedure CreateRemXDatabase(Path: string);

implementation

uses IBDatabase, IBCustomDataSet, IBSQL;

procedure CreateRemXDatabase(Path: string);
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
// create TRENDS table
            with SL.SQL do
            begin
              Clear;
              Add('CREATE GENERATOR g_reals;');
            end;
            SL.ExecQuery;
            with SL.SQL do
            begin
              Clear;
              Add('CREATE TABLE reals');
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
              Add('CREATE TRIGGER set_reals_id FOR reals');
              Add('BEFORE INSERT POSITION 0 AS');
              Add('BEGIN');
              Add('  new.id = gen_id (g_reals, 1);');
              Add('END');
            end;
            SL.ExecQuery;
            with SL.SQL do
            begin
              Clear;
              Add('CREATE TRIGGER bi_reals FOR reals');
              Add('BEFORE INSERT POSITION 1 AS');
              Add('BEGIN');
              Add(' DELETE FROM reals WHERE pname = new.pname;');
              Add('END');
            end;
            SL.ExecQuery;
            with SL.SQL do
            begin
              Clear;
              Add('CREATE PROCEDURE updatereals (');
              Add('P1 VARCHAR(20),');
              Add('P2 TIMESTAMP,');
              Add('P3 FLOAT,');
              Add('P4 SMALLINT) AS');
              Add('BEGIN');
              Add(' INSERT INTO reals');
              Add(' (PName,SnapTime,Val,Kind)');
              Add(' VALUES (:P1,:P2,:P3,:P4);');
              Add('END');
            end;
            SL.ExecQuery;
{----------------------------------------------------------}
// create UsersList table
            with SL.SQL do
            begin
              Clear;
              Add('create generator g_userslist;');
            end;
            SL.ExecQuery;
            with SL.SQL do
            begin
              Clear;
              Add('create table userslist');
              Add('(');
              Add(' Id INTEGER NOT NULL,');
              Add(' FirstName VARCHAR(20) NOT NULL,');
              Add(' SecondName VARCHAR(20) NOT NULL,');
              Add(' LastName VARCHAR(30) NOT NULL,');
              Add(' Pass VARCHAR(16) NOT NULL,');
              Add(' Category INTEGER NOT NULL,');
              Add('constraint userslist_pk primary key(id),');
              Add('constraint userslist_uc unique (LastName,FirstName,SecondName)');
              Add(');');
            end;
            SL.ExecQuery;
            with SL.SQL do
            begin
              Clear;
              Add('create trigger set_userslist_id for userslist');
              Add('before insert position 0 as');
              Add('begin');
              Add('  new.id = gen_id (g_userslist, 1);');
              Add('end');
            end;
            SL.ExecQuery;
// create EntityCategoriesList table
            with SL.SQL do
            begin
              Clear;
              Add('create table entities');
              Add('(');
              Add(' EntityCategory VARCHAR(25) NOT NULL,');
              Add(' EntityCRC INTEGER NOT NULL,');
              Add(' EntityContent BLOB,');
              Add('constraint entities_pk primary key(EntityCategory)');
              Add(');');
            end;
            SL.ExecQuery;
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
