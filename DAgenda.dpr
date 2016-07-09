program DAgenda;

uses
  FMX.Forms,
  DAgenda.Forms.Main in 'Forms\DAgenda.Forms.Main.pas' {MainForm},
  Classes.Contact in 'Classes\Classes.Contact.pas',
  Classes.Builders in 'Classes\Classes.Builders.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
