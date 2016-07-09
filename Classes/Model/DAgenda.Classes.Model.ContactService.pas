unit DAgenda.Classes.Model.ContactService;

interface

uses
  DAgenda.Classes.Model.SpringService,
  DAgenda.Classes.Model.Contact;

type
  TContactService = class(TSpringService<TContact, Integer>);

implementation

end.
