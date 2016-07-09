unit DAgenda.Classes.Connection.FireDAC.MarshmallowBuilder;

interface

uses
  Data.DB,

  FireDAC.Comp.Client,
  FireDAC.Comp.UI,

  FireDAC.DApt,

  FireDAC.FMXUI.Wait,

  FireDAC.Stan.Async,
  FireDAC.Stan.Def,
  FireDAC.Stan.Error,
  FireDAC.Stan.ExprFuncs,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Pool,

  FireDAC.Phys,
  FireDAC.Phys.Intf,
  FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef,

  FireDAC.UI.Intf,

  DAgenda.Classes.Connection.Interfaces,
  Spring.Persistence.Core.Interfaces;

type
  TFireDACMarshmallowConnectionBuilder = class(TInterfacedObject, IConnectionBuilder<IDBConnection>)
  private const
    DATABASE_PATH = 'Database=%s';
    OPEN_MODE = 'OpenMode=ReadWrite';
    DRIVER_ID = 'DriverID=SQLite';
  private
    FDBConnection: IDBConnection;
    FDPhysSQLiteDriverLink: TFDPhysSQLiteDriverLink;
    function CreateFireDacConnection: TFDConnection;
  public
    function CreateConfiguredSession(): IConnectionBuilder<IDBConnection>;
    function Build(): IDBConnection;
  end;

implementation

uses
  System.Classes,
  System.SysUtils,
  System.IOUtils,

  Spring.Persistence.Adapters.FireDAC;

function TFireDACMarshmallowConnectionBuilder.Build: IDBConnection;
begin
  Result := FDBConnection;
  Result.AutoFreeConnection := True;
end;

function TFireDACMarshmallowConnectionBuilder.CreateConfiguredSession: IConnectionBuilder<IDBConnection>;
begin
  FDBConnection := TFireDacConnectionAdapter.Create(CreateFireDacConnection());
  Result := Self;
end;

function TFireDACMarshmallowConnectionBuilder.CreateFireDacConnection: TFDConnection;
var
  FDConnection: TFDConnection;
begin
  FDPhysSQLiteDriverLink := TFDPhysSQLiteDriverLink.Create(nil);
  FDConnection := TFDConnection.Create(nil);

  FDConnection.Params.Add(Format(DATABASE_PATH, [
    {$IFDEF ANDROID}
    TPath.Combine(TPath.GetDocumentsPath, 'dagenda.s3db')
    {$ELSE}
    '..\..\Data\dagenda.s3db'
    {$ENDIF}]));
  FDConnection.Params.Add(OPEN_MODE);
  FDConnection.Params.Add(DRIVER_ID);

  FDConnection.Open();
  Result := FDConnection;
end;

end.
