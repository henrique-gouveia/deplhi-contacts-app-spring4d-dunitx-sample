unit DAgenda.Classes.Model.AbstractService;

interface

uses
  Spring.Collections,
  DAgenda.Classes.Model.Interfaces;

type
  TAbstractService<T: class, constructor; TId> = class abstract(TInterfacedObject, IEntityService<T, TId>)
  protected
    FRepository: IEntityRepository<T, TId>;
    function CreateRespository: IInterface; virtual; abstract;
  public
    constructor Create;

    function FindOne(const id: TId): T; virtual;
    function FindAll: IList<T>; virtual;
    procedure Remove(entity: T); virtual;
    procedure Save(entity: T); virtual;
  end;

implementation

constructor TAbstractService<T, TId>.Create;
begin
  inherited Create;
  FRepository := Self.CreateRespository() as IEntityRepository<T, TId>;
end;

function TAbstractService<T, TId>.FindOne(const id: TId): T;
begin
  Result := FRepository.FindOne(id);
end;

function TAbstractService<T, TId>.FindAll: IList<T>;
begin
  Result := FRepository.FindAll();
end;

procedure TAbstractService<T, TId>.Remove(entity: T);
begin
  FRepository.Delete(entity);
end;

procedure TAbstractService<T, TId>.Save(entity: T);
begin
  FRepository.Save(entity);
end;

end.
