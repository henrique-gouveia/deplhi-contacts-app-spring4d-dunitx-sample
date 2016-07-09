unit DAgenda.Classes.Model.Contact;

interface

type
  TContact = class
  strict private
    FId: Integer;
    FNome: String;
    FEmail: String;
    FTelefone: String;
  public
    property Id: Integer read FId write FId;
    property Nome: String read FNome write FNome;
    property Email: String read FEmail write FEmail;
    property Telefone: String read FTelefone write FTelefone;
  end;

implementation

end.
