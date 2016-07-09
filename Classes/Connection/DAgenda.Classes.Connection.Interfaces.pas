unit DAgenda.Classes.Connection.Interfaces;

interface

type
  IConnectionBuilder<T> = interface
    ['{8E4F0E20-6A0B-4325-A393-F53BEAFCB7BB}']
    function CreateConfiguredSession(): IConnectionBuilder<T>;
    function Build(): T;
  end;

implementation

end.
