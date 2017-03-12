unit DContacts.Modules.Connections.Interfaces;

interface

type
  IConnectionModule<T: class, constructor> = interface
    ['{C9672A9A-84E1-4F08-B870-F5D2A41941E9}']
    {$REGION 'Accesors'}
    function GetConnection: T;
    function GetDriverName: String;
    {$ENDREGION}
    property Connection: T read GetConnection;
    property DriverName: String read GetDriverName;
  end;

implementation

end.
