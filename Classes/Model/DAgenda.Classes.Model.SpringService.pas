unit DAgenda.Classes.Model.SpringService;

interface

uses
  Spring.Persistence.Core.Session,
  DAgenda.Classes.Connection.Interfaces,
  DAgenda.Classes.Model.AbstractService;

type
  TSpringService<T: class, constructor; TId> = class abstract(TAbstractService<T, TId>)
  protected
    FSession: TSession;
    function CreateRespository: IInterface; override;
  public
    constructor Create(const connectionBuilder: IConnectionBuilder<TSession>);
  end;

implementation

uses
  Spring.Persistence.Core.Repository.Simple;

constructor TSpringService<T, TId>.Create(const connectionBuilder: IConnectionBuilder<TSession>);
begin
  FSession := connectionBuilder.CreateConfiguredSession.Build();
  inherited Create;
end;

function TSpringService<T, TId>.CreateRespository: IInterface;
begin
  Result := TSimpleRepository<T, TId>.Create(FSession);
end;

end.
