program DAgenda.Tests;

uses
  FMX.Forms,
  System.SysUtils,
  DUnitX.TestFramework,
  DUnitX.Loggers.GUIX,
  DAgenda.Tests.Connection.FireDAC.MarshmallowBuilder in 'Source\DAgenda.Tests.Connection.FireDAC.MarshmallowBuilder.pas',
  DAgenda.Tests.Model.ContactService in 'Source\DAgenda.Tests.Model.ContactService.pas';

{$R *.res}

begin
  Application.Initialize;

  Application.CreateForm(TGUIXTestRunner, GUIXTestRunner);
  Application.Run;
end.
