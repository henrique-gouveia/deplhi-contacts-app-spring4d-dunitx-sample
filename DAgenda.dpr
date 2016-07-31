program DAgenda;

uses
  System.StartUpCopy,
  FMX.Forms,
  DAgenda.Forms.Main in 'Forms\DAgenda.Forms.Main.pas' {MainForm},
  DAgenda.Classes.Connection.FireDAC.MarshmallowBuilder in 'Classes\Connection\DAgenda.Classes.Connection.FireDAC.MarshmallowBuilder.pas',
  DAgenda.Classes.Connection.Interfaces in 'Classes\Connection\DAgenda.Classes.Connection.Interfaces.pas',
  DAgenda.Classes.Model.AbstractService in 'Classes\Model\DAgenda.Classes.Model.AbstractService.pas',
  DAgenda.Classes.Model.Contact in 'Classes\Model\DAgenda.Classes.Model.Contact.pas',
  DAgenda.Classes.Model.ContactService in 'Classes\Model\DAgenda.Classes.Model.ContactService.pas',
  DAgenda.Classes.Model.Interfaces in 'Classes\Model\DAgenda.Classes.Model.Interfaces.pas',
  DAgenda.Classes.Model.SpringService in 'Classes\Model\DAgenda.Classes.Model.SpringService.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
