unit DContacts.Controllers.Contact;

interface

uses
  System.Classes,

  DContacts.Models.Entities.Contact,
  DContacts.PresentationModel.Dialog,

  Spring.Collections,
  Spring.Container.Common,
  Spring.Persistence.Core.Interfaces;

type
  TContactController = class
  private
    FContactId: Integer;

    FContact: TContact;
    [Inject]
    FContactRepository: IPagedRepository<TContact, Integer>;
    FContacts: IObjectList;

    [Inject]
    FDialog: IDialog;
    FOnListar: TNotifyEvent;

    procedure SetContactId(const Value: Integer);
    procedure SetContact(const Value: TContact);
    function GetContacts: IList<TContact>;
  public
    procedure Excluir;
    procedure Listar;
    procedure Novo;
    procedure Salvar;

    property ContactId: Integer write SetContactId;

    property Contact: TContact read FContact write SetContact;
    property Contacts: IList<TContact> read GetContacts;

    property OnListar: TNotifyEvent read FOnListar write FOnListar;
  end;

implementation

{$REGION 'TContactController' }

procedure TContactController.Excluir;
begin
  FDialog.ShowConfirmationMessage('Confirma exclusão desse contato ?',
    procedure(const result: TModalResult)
    begin
      if (result = mrYes) then
      try
        FContactRepository.Delete(Contact);
        FContacts := nil;

        FDialog.ShowInformationMessage('Contato excluído com sucesso.',
          procedure(const result: TModalResult)
          begin
            Listar();
          end);
      except
        FDialog.ShowErrorMessage('Erro ao tentar excluir contato.');
      end;
    end);
end;

procedure TContactController.Listar;
begin
  if Assigned(FOnListar) then
    FOnListar(Self);
end;

procedure TContactController.Novo;
begin
  Contact := TContact.Create;
end;

procedure TContactController.Salvar;
begin
  FDialog.ShowConfirmationMessage('Confirma salvar contato ?',
    procedure(const result: TModalResult)
    begin
      if (result = mrYes) then
      try
        FContactRepository.Save(Contact);
        FContacts := nil;

        FDialog.ShowInformationMessage('Contato salvo com sucesso.',
          procedure(const result: TModalResult)
          begin
            Listar();
          end);
      except
        FDialog.ShowErrorMessage('Erro ao tentar salvar contato.');
      end;
    end);
end;

procedure TContactController.SetContactId(const Value: Integer);
begin
  if (FContactId <> Value) then
    Contact := FContactRepository.FindOne(Value);
end;

procedure TContactController.SetContact(const Value: TContact);
begin
  if Assigned(FContact) then
    FContact.Free;

  FContact := Value;
end;

function TContactController.GetContacts: IList<TContact>;
begin
  if not Assigned(FContacts) then
    FContacts := FContactRepository.FindAll() as IObjectList;

  Result := FContacts as IList<TContact>;
end;

{$ENDREGION}

end.
