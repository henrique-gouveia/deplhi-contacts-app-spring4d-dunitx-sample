unit DContacts.Tests.Repositories.Contact;

interface

uses
  SQLiteTable3,
  DUnitX.TestFramework,

  Spring.Persistence.Core.Interfaces,
  DContacts.Models.Entities.Contact;

type
  [TestFixture]
  TContactRepositoryTest = class
  private
    FContactRepository: IPagedRepository<TContact, Integer>;
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
    procedure TestInsert;
    [Test]
    procedure TestUpdate;
  end;

implementation

uses
  System.SysUtils,

  DContacts.Tests.TestDB,

  Spring.Persistence.Adapters.SQLite,
  Spring.Persistence.Core.Session,
  Spring.Persistence.Core.ConnectionFactory,
  Spring.Persistence.Core.Repository.Simple;

procedure TContactRepositoryTest.Setup;
var
  connection: IDBConnection;
  session: TSession;
begin
  connection := TConnectionFactory.GetInstance(dtSQLite, TestDB);
  session := TSession.Create(connection);
  FContactRepository := TSimpleRepository<TContact, Integer>.Create(session);
end;

procedure TContactRepositoryTest.TearDown;
begin
  ClearTable('contact');
end;

procedure TContactRepositoryTest.TestFindOne;
var
  id: Integer;
  contact: TContact;
begin
  id := InsertContact();
  contact := FContactRepository.FindOne(id);
  try
    Assert.IsNotNull(contact, 'Nenhum contato localizado para o id ' + id.ToString());
    Assert.AreEqual(id, contact.id, Format('Contact id %d difere do desejado %d', [contact.Id, id]));
  finally
    contact.Free;
  end;
end;

procedure TContactRepositoryTest.TestFindAll;
var
  count: Integer;
  I: Integer;
begin
  for I := 0 to 10 do
    InsertContact('contact ' + I.ToString());

  count := TestDB.GetUniTableIntf('SELECT COUNT(*) FROM contact;').Fields[0].Value;
  Assert.AreEqual(count, FContactRepository.FindAll.Count, 'Total de registros diferem.');
end;

procedure TContactRepositoryTest.TestRemove;
var
  id: Integer;
  contact: TContact;
begin
  id := InsertContact();
  contact := FContactRepository.FindOne(id);
  try
    FContactRepository.Delete(contact);
    contact := FContactRepository.FindOne(id);

    Assert.IsNull(contact, 'Contato não foi removido.');
  finally
    if Assigned(contact) then
      contact.Free;
  end;
end;

procedure TContactRepositoryTest.TestInsert;
var
  Contact: TContact;
  SQLiteTable: ISQLiteTable;
begin
  Contact := TContact.Create;
  try
    Contact.Nome := 'Contato inserido por teste';
    Contact.Email := 'contact@email.com';
    Contact.Telefone := '88 9999-9999';

    FContactRepository.Save(Contact);

    SQLiteTable := TestDB.GetUniTableIntf('SELECT * FROM contact WHERE id = ?', [Contact.Id]);

    Assert.AreEqual(Contact.Nome, SQLiteTable.FieldByName['nome'].AsString, 'Nome do Contato diverge do esperado.');
    Assert.AreEqual(Contact.Email, SQLiteTable.FieldByName['email'].AsString, 'Email do Contato diverge do esperado.');
    Assert.AreEqual(Contact.Telefone, SQLiteTable.FieldByName['telefone'].AsString, 'Telefone do Contato diverge do esperado.');
  finally
    Contact.Free;
  end;
end;

procedure TContactRepositoryTest.TestUpdate;
var
  id: Integer;
  Contact: TContact;
  SQLiteTable: ISQLiteTable;
begin
  id := InsertContact();
  Contact := FContactRepository.FindOne(id);
  try
    Contact.Nome := 'Contato atualizado por teste';
    Contact.Email := 'contact.update@email.com';
    Contact.Telefone := '99 8888-8888';

    FContactRepository.Save(Contact);

    SQLiteTable := TestDB.GetUniTableIntf('SELECT * FROM contact WHERE id = ?', [Contact.Id]);

    Assert.AreEqual(Contact.Nome, SQLiteTable.FieldByName['nome'].AsString, 'Nome do Contato diverge do esperado.');
    Assert.AreEqual(Contact.Email, SQLiteTable.FieldByName['email'].AsString, 'Email do Contato diverge do esperado.');
    Assert.AreEqual(Contact.Telefone, SQLiteTable.FieldByName['telefone'].AsString, 'Telefone do Contato diverge do esperado.');
  finally
    Contact.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TContactRepositoryTest);

end.
