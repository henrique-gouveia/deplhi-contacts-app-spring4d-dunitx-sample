unit DAgenda.Classes.Model.SpringService;

interface

uses
  Spring.Collections,
  Spring.Persistence.Core.Interfaces,
  Spring.Persistence.Core.Session,

  DAgenda.Classes.Connection.Interfaces,
  DAgenda.Classes.Model.AbstractService;

type
  TSpringService<T: class, constructor; TId> = class abstract(TAbstractService<T, TId>)
  protected
    FRepository: IPagedRepository<T, TId>;
    FSession: TSession;
    function CreateRespository: IInterface; override;
  public
    constructor Create(const connection: IDBConnection); overload;
    constructor Create(const connectionBuilder: IConnectionBuilder<IDBConnection>); overload;

    function FindOne(const id: TId): T; override;
    function FindAll: IList<T>; override;
    procedure Remove(entity: T); override;
    procedure Save(entity: T); override;
  end;

implementation

uses
  Spring.Persistence.Core.Repository.Simple;

constructor TSpringService<T, TId>.Create(const connection: IDBConnection);
begin
  inherited Create;
  FSession := TSession.Create(connection);
  FRepository := Self.CreateRespository as IPagedRepository<T, TId>;
end;

constructor TSpringService<T, TId>.Create(const connectionBuilder: IConnectionBuilder<IDBConnection>);
begin
  Create(connectionBuilder.CreateConfiguredSession.Build());
end;

function TSpringService<T, TId>.CreateRespository: IInterface;
begin
  Result := TSimpleRepository<T, TId>.Create(FSession);
end;

function TSpringService<T, TId>.FindOne(const id: TId): T;
begin
  Result := FRepository.FindOne(id);
end;

function TSpringService<T, TId>.FindAll: IList<T>;
begin
  Result := FRepository.FindAll();
end;

procedure TSpringService<T, TId>.Remove(entity: T);
begin
  FRepository.Delete(entity);
end;

procedure TSpringService<T, TId>.Save(entity: T);
begin
  FRepository.Save(entity);
end;

end.
