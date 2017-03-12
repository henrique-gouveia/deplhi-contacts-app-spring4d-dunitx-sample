unit DContacts.Tests.TestDB;

interface

uses
  System.SysUtils,
  System.Classes,
  SQLiteTable3;

  procedure ClearTable(const tableName: String);
  procedure CreateTables;

  function InsertContact(
    nome: string = 'Contact';
    email: string = 'contact@emial.com';
    telefone: string = '99 9999-9999'): Variant;

var
  TestDB: TSQLiteDatabase = nil;

implementation

procedure ClearTable(const tableName: String);
begin
  TestDB.BeginTransaction;
  try
    TestDB.ExecSQL('DELETE FROM ' + tableName + ';');
    TestDB.Commit;
  except
    TestDB.Rollback;
  end;
end;

procedure CreateTables;
begin
  TestDB.ExecSQL('CREATE TABLE IF NOT EXISTS [contact] ( '+
    '[id] INTEGER primary key, ' +
    '[nome] VARCHAR(40), ' +
    '[email] VARCHAR(40), ' +
    '[telefone] VARCHAR(12));');

  if not TestDB.TableExists('contact') then
    raise Exception.Create('Tables not exists.');
end;

function InsertContact(
  nome: string = 'Contact';
  email: string = 'contact@emial.com';
  telefone: string = '99 9999-9999'): Variant;
begin
  TestDB.ExecSQL('INSERT INTO contact ([nome], [email], [telefone]) VALUES (?,?,?);', [nome, email, telefone]);
  Result := TestDB.GetLastInsertRowID;
end;


initialization
  TestDB := TSQLiteDatabase.Create(':memory:');
  CreateTables();

finalization
  TestDB.Free;

end.
