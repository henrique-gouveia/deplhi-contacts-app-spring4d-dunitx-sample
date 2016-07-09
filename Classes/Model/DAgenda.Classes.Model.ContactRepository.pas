unit DAgenda.Classes.Model.ContactRepository;

interface

uses
  DAgenda.Classes.Model.Contact,
  DAgenda.Classes.Model.Interfaces;

type
  IContactRepository = interface(IEntityRepository<TContact, Integer>)
    ['{10A76726-1A0B-49DB-BA62-E4CB89BF760F}']
  end;

implementation

end.
