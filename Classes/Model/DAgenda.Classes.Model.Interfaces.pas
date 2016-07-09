unit DAgenda.Classes.Model.Interfaces;

interface

uses
  Spring.Collections;

type
  IEntityService<T: class, constructor; TId> = interface
    ['{20FFB8B6-ECEA-4D99-B8C4-8AFE9C7DB1AC}']
    function FindOne(const id: TId): T;
    function FindAll: IList<T>;
    procedure Remove(entity: T);
    procedure Save(entity: T);
  end;

implementation

end.
