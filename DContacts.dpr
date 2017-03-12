program DContacts;

{$IF DEFINED(ANDROID) OR DEFINED(IOS)}
  {$DEFINE MOBILE}
{$ENDIF}

uses
  System.StartUpCopy,
  System.Classes,
  System.Messaging,
  FMX.MobilePreview,
  FMX.Platform,
  FMX.Forms,
  Spring.Container,
  DContacts.Controllers.Contact in 'Source\Controllers\DContacts.Controllers.Contact.pas',
  DContacts.Models.Entities.Contact in 'Source\Models\Entities\DContacts.Models.Entities.Contact.pas',
  DContacts.Modules.Connections.Interfaces in 'Source\Modules\DContacts.Modules.Connections.Interfaces.pas',
  DContacts.Modules.Connections.SQLite in 'Source\Modules\DContacts.Modules.Connections.SQLite.pas' {SQLiteConnectionModule: TDataModule},
  DContacts.PresentationModel.Dialog in 'Source\PresentationModel\DContacts.PresentationModel.Dialog.pas',
  DContacts.PresentationModel.Dialog.FMX in 'Source\PresentationModel\DContacts.PresentationModel.Dialog.FMX.pas',
  DContacts.Registration in 'Source\Registrations\DContacts.Registration.pas',
  DContacts.Views.Contact in 'Source\Views\DContacts.Views.Contact.pas' {ContactView};

{$R *.res}

var
  container: TContainer;
begin
  container := GlobalContainer();
  RegisterTypes(container);

  Application.Initialize;
  container.Resolve<TSQLiteConnectionModule>();

{$IFDEF MOBILE}
  // Platform service precisa manipular isso
  TMessageManager.DefaultManager.SubscribeToMessage(TApplicationEventMessage,
    procedure (const Sender: TObject; const msg: TMessage)
    begin
      if msg is TApplicationEventMessage then
        case TApplicationEventMessage(msg).Value.Event of
          TApplicationEvent.FinishedLaunching: container.Resolve<TContactView>();
        end;
    end);
{$ELSE}
  // Pode ser chamado de forma síncrona
  container.Resolve<TContactView>();
{$ENDIF}

  Application.Run;
end.
