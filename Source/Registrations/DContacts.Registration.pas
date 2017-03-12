unit DContacts.Registration;

interface

uses
  Spring.Container;


  procedure RegisterTypes(const container: TContainer);

implementation

uses
  FMX.Forms,
  FireDAC.Comp.Client,

  DContacts.Controllers.Contact,
  DContacts.Models.Entities.Contact,

  DContacts.Modules.Connections.Interfaces,
  DContacts.Modules.Connections.SQLite,

  DContacts.PresentationModel.Dialog,
  DContacts.PresentationModel.Dialog.FMX,

  DContacts.Views.Contact,

  Spring.Persistence.Adapters.FireDAC,
  Spring.Persistence.Core.Interfaces,
  Spring.Persistence.Core.Repository.Simple,
  Spring.Persistence.Core.Session,
  Spring.Persistence.SQL.Interfaces;

procedure RegisterTypes(const container: TContainer);
const
  CONNECTION_MODULE_NAME = 'connectionModule';
begin
  {$REGION 'Connection'}
  container
    .RegisterType<IDBConnection>()
    .DelegateTo(
      function: IDBConnection
      var
        connectionModule: IConnectionModule<TFDConnection>;
      begin
        connectionModule := container.Resolve<IConnectionModule<TFDConnection>>(CONNECTION_MODULE_NAME);
        Result := TFireDACConnectionAdapter.Create(connectionModule.Connection);

        if connectionModule.DriverName = 'SQLite' then
          Result.QueryLanguage := qlSQLite;
      end)
    .AsSingleton();
  {$ENDREGION}

  {$REGION 'Controllers'}
  container
    .RegisterType<TContactController>
    .AsSingleton();
  {$ENDREGION}

  {$REGION 'Modules'}
  container
    .RegisterType<TSQLiteConnectionModule>(CONNECTION_MODULE_NAME)
    .DelegateTo(
      function: TSQLiteConnectionModule
      begin
        Result := TSQLiteConnectionModule.Create(Application);
      end)
    .AsSingleton();
  {$ENDREGIOn}

  {$REGION 'PresentationModel'}
  container
    .RegisterType<IDialog, TFMXDialogAdapter>();
  {$ENDREGION}

  {$REGION 'Repositories'}
  container
    .RegisterType<TSimpleRepository<TContact, Integer>>()
    .Implements<IPagedRepository<TContact, Integer>>();
  {$ENDREGION}

  {$REGION 'Session'}
  container
    .RegisterType<TSession>()
    .AsSingleton();
  {$ENDREGION}

  {$REGION 'Views'}
  container
    .RegisterType<TContactView, TContactView>()
    .DelegateTo(
      function: TContactView
      begin
        // Isso força a criação do formulário de forma síncrona.
        // Pode ou não ser chamado em determinadas plataformas pelo FMX framework.
        // O Android chamará isso antes de enviar a mensagem, mas o iOS não.
        // Pode ser chamado várias vezes sem nenhum problema.
        Application.RealCreateForms();
        Application.CreateForm(TContactView, Result);
        // Cria a instância e atribui a MainForm
        // (Caso contrário, seria feito por Application.CreateMainForm)
        Application.MainForm := Result;
        // E torná-lo visível, pois isso pode não ser definido no designer e
        // nenhuma janela será exibida
        Application.MainForm.Visible := True;
      end)
    .AsSingleton();
  {$ENDREGION}

  container.Build();
end;

end.
