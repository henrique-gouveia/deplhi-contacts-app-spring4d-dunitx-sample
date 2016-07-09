unit DAgenda.Tests.Model.ContactService;

interface

uses
  SQLiteTable3,
  DUnitX.TestFramework,
  DAgenda.Classes.Model.Interfaces,
  DAgenda.Classes.Model.Contact;

type
  [TestFixture]
  TContactServiceTest = class
  private
    FContactService: IEntityService<TContact, Integer>;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure TestFindOne;
    [Test]
    procedure TestFindAll;
    [Test]
    procedure TestRemove;
    [Test]
    procedure TestSave_Insert;
    [Test]
    procedure TestSave_Update;
  end;

var
  TestDB: TSQLiteDatabase = nil;

implementation

uses
  System.SysUtils,

  DAgenda.Classes.Model.ContactService,

  Spring.Persistence.Adapters.SQLite,
  Spring.Persistence.Core.ConnectionFactory,
  Spring.Persistence.Core.Interfaces;

procedure ClearTable(const tableName: string);
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
    raise Exception.Create('Table contact does not exist');
end;

function InsertContact(nome: string = 'Contact'; email: string = 'contact@emial.com'; telefone: string = '99 9999-9999'): Variant;
begin
  TestDB.ExecSQL('INSERT INTO contact ([nome], [email], [telefone]) VALUES (?,?,?);', [nome, email, telefone]);
  Result := TestDB.GetLastInsertRowID;
end;

procedure TContactServiceTest.Setup;
var
  connection: IDBConnection;
begin
  CreateTables;

  connection := TConnectionFactory.GetInstance(dtSQLite, TestDB);
  FContactService := TContactService.Create(connection);
end;

procedure TContactServiceTest.TearDown;
begin
  ClearTable('contact');
end;

procedure TContactServiceTest.TestFindOne;
var
  Id: Integer;
  Contact: TContact;
begin
  Id := InsertContact();
  Contact := FContactService.FindOne(id);
  try
    Assert.IsNotNull(Contact, 'Nenhum contato localizado para o id ' + id.ToString());
  finally
    Contact.Free;
  end;
end;

procedure TContactServiceTest.TestFindAll;
var
  count: Integer;
  I: Integer;
begin
  for I := 0 to 10 do
    InsertContact('contact ' + I.ToString());

  count := TestDB.GetUniTableIntf('SELECT COUNT(*) FROM contact;').Fields[0].Value;
  Assert.AreEqual(count, FContactService.FindAll.Count, 'Total de registros diferem.');
end;

procedure TContactServiceTest.TestRemove;
var
  Id: Integer;
  Contact: TContact;
begin
  Id := InsertContact();
  Contact := FContactService.FindOne(id);
  try
    FContactService.Remove(Contact);
    Contact := FContactService.FindOne(id);

    Assert.IsNull(Contact, 'Contato não foi removido.');
  finally
    if Assigned(Contact) then
      Contact.Free;
  end;
end;

procedure TContactServiceTest.TestSave_Insert;
var
  Contact: TContact;
  SQLiteTable: ISQLiteTable;
begin
  Contact := TContact.Create;
  try
    Contact.Nome := 'Contact Inserted by test';
    Contact.Email := 'contact@email.com';
    Contact.Telefone := '88 9999-9999';

    FContactService.Save(Contact);

    SQLiteTable := TestDB.GetUniTableIntf('SELECT * FROM contact WHERE id = ?', [Contact.Id]);

    Assert.AreEqual(Contact.Nome, SQLiteTable.FieldByName['nome'].AsString, 'Contact Nome divergem.');
    Assert.AreEqual(Contact.Email, SQLiteTable.FieldByName['email'].AsString, 'Contact Email divergem.');
    Assert.AreEqual(Contact.Telefone, SQLiteTable.FieldByName['telefone'].AsString, 'Contact Telefone divergem.');
  finally
    Contact.Free;
  end;
end;

procedure TContactServiceTest.TestSave_Update;
var
  id: Integer;
  Contact: TContact;
  SQLiteTable: ISQLiteTable;
begin
  id := InsertContact();
  Contact := FContactService.FindOne(id);
  try
    Contact.Nome := 'Contact Updated by test';
    Contact.Email := 'contact.update@email.com';
    Contact.Telefone := '99 8888-8888';

    FContactService.Save(Contact);

    SQLiteTable := TestDB.GetUniTableIntf('SELECT * FROM contact WHERE id = ?', [Contact.Id]);

    Assert.AreEqual(Contact.Nome, SQLiteTable.FieldByName['nome'].AsString, 'Contact Nome divergem.');
    Assert.AreEqual(Contact.Email, SQLiteTable.FieldByName['email'].AsString, 'Contact Email divergem.');
    Assert.AreEqual(Contact.Telefone, SQLiteTable.FieldByName['telefone'].AsString, 'Contact Telefone divergem.');
  finally
    Contact.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TContactServiceTest);

  TestDB := TSQLiteDatabase.Create(':memory:');
  //TestDB := TSQLiteDatabase.Create('file::memory:?cache=shared');

finalization
  TestDB.Free;

end.
