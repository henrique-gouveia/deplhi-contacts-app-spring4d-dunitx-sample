program DContacts.Tests;

uses
  FMX.Forms,
  DUNitX.Loggers.GUIX,
  DUnitX.Loggers.XML.NUnit,
  DUnitX.TestFramework,
  DContacts.Tests.TestDB in 'Source\DContacts.Tests.TestDB.pas',
  DContacts.Tests.Repositories.Contact in 'Source\DContacts.Tests.Repositories.Contact.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.CreateForm(TGUIXTestRunner, GUIXTestRunner);
  Application.Run;
end.
