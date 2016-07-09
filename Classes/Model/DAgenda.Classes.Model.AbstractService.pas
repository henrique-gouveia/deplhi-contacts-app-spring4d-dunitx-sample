unit DAgenda.Classes.Model.AbstractService;

interface

uses
  Spring.Collections,
  DAgenda.Classes.Model.Interfaces;

type
  TAbstractService<T: class, constructor; TId> = class abstract(TInterfacedObject, IEntityService<T, TId>)
  protected
    function CreateRespository: IInterface; virtual; abstract;
  public
    function FindOne(const id: TId): T; virtual; abstract;
    function FindAll: IList<T>; virtual; abstract;
    procedure Remove(entity: T); virtual; abstract;
    procedure Save(entity: T); virtual; abstract;
  end;

implementation

end.
