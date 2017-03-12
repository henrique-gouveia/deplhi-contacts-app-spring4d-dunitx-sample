unit DContacts.Modules.Connections.SQLite;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Comp.UI,
  FireDAC.Comp.Script,
  FireDAC.Comp.ScriptCommands,
  FireDAC.Stan.Async,
  FireDAC.Stan.Def,
  FireDAC.Stan.Error,
  FireDAC.Stan.ExprFuncs,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Util,

  FireDAC.Phys,
  FireDAC.Phys.Intf,
  FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef,

  FireDAC.UI.Intf,
  FireDAC.FMXUI.Wait,

  DContacts.Modules.Connections.Interfaces;

type
  TSQLiteConnectionModule = class(TDataModule, IConnectionModule<TFDConnection>)
    DContactConnection: TFDConnection;
    sqliteDriverLink: TFDPhysSQLiteDriverLink;
    guixWaitCursor: TFDGUIxWaitCursor;
    procedure DataModuleCreate(Sender: TObject);
  protected
    function GetConnection: TFDConnection; virtual;
    function GetDriverName: String; virtual;
  end;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

uses
  System.IOUtils;

procedure TSQLiteConnectionModule.DataModuleCreate(Sender: TObject);
begin
  DContactConnection.Params.Database :=
    {$IFDEF ANDROID}
    TPath.Combine(TPath.GetDocumentsPath, 'dcontacts.s3db')
    {$ELSE}
    '..\..\..\Data\dcontacts.s3db'
    {$ENDIF};
  DContactConnection.Open();
end;

function TSQLiteConnectionModule.GetConnection: TFDConnection;
begin
  Result := DContactConnection;
end;

function TSQLiteConnectionModule.GetDriverName: String;
begin
  Result := DContactConnection.DriverName;
end;

end.
