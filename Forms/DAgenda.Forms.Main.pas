unit DAgenda.Forms.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.Actions, FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit, FMX.TabControl, FMX.ActnList,
  FMX.ListBox, FMX.Layouts, FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView,
  FMX.ListView.Adapters.Base,

  DAgenda.Classes.Model.Contact,
  DAgenda.Classes.Model.Interfaces;

type
  TMainForm = class(TForm)
    actMain: TActionList;
    ctaChangeTab: TChangeTabAction;
    actAdd: TAction;
    actBack: TAction;
    actNew: TAction;
    actRemove: TAction;
    tcMain: TTabControl;
    tbiContactsList: TTabItem;
    tbContactsList: TToolBar;
    lblContactsListTitle: TLabel;
    lvMain: TListView;
    tbiContactsManager: TTabItem;
    tbContactsManager: TToolBar;
    lytContactsManager: TLayout;
    lblContactsManagerTitle: TLabel;
    lbMain: TListBox;
    lbghNome: TListBoxGroupHeader;
    lbiNome: TListBoxItem;
    lbghEmail: TListBoxGroupHeader;
    lbiEmail: TListBoxItem;
    lbghTelefone: TListBoxGroupHeader;
    lbiTelefone: TListBoxItem;
    lblId: TLabel;
    edtNome: TEdit;
    edtEmail: TEdit;
    edtTelefone: TEdit;
    spbBack: TSpeedButton;
    spbNew: TSpeedButton;
    spbOk: TSpeedButton;
    spdRemove: TSpeedButton;

    procedure FormCreate(Sender: TObject);
    procedure ItemClick(const Sender: TObject; const AItem: TListViewItem);
    procedure AddClick(Sender: TObject);
    procedure BackClick(Sender: TObject);
    procedure NewClick(Sender: TObject);
    procedure RemoveClick(Sender: TObject);
  private
    FContactService: IEntityService<TContact, Integer>;

    procedure ActiveTab(tabItem: TTabItem; Sender: TObject);

    procedure LoadListViewContacts;

    procedure LoadContact(contact: TContact);
    procedure LoadControls(contact: TContact);

    procedure ResetControls;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses
  DAgenda.Classes.Connection.FireDAC.MarshmallowBuilder,
  DAgenda.Classes.Model.ContactService;

{$R *.fmx}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  tcMain.TabPosition := TTabPosition.None;
  tcMain.ActiveTab := tbiContactsList;

  FContactService := TContactService.Create(TFireDACMarshmallowConnectionBuilder.Create);
  LoadListViewContacts();
end;

procedure TMainForm.ItemClick(const Sender: TObject; const AItem: TListViewItem);
var
  Contact: TContact;
begin
  ActiveTab(tbiContactsManager, Sender);
  Contact := FContactService.FindOne(AItem.Detail.ToInteger());
  LoadControls(Contact);
end;

procedure TMainForm.ActiveTab(tabItem: TTabItem; Sender: TObject);
begin
  ctaChangeTab.Tab := tabItem;
  ctaChangeTab.ExecuteTarget(Sender);
end;

procedure TMainForm.AddClick(Sender: TObject);
var
  Contact: TContact;
begin
  Contact := TContact.Create;

  LoadContact(Contact);
  FContactService.Save(Contact);

  ResetControls();
  ActiveControl := edtNome;
end;

procedure TMainForm.BackClick(Sender: TObject);
begin
  LoadListViewContacts();
  ActiveTab(tbiContactsList, Sender);
  ResetControls();
  ActiveControl := nil;
end;

procedure TMainForm.NewClick(Sender: TObject);
begin
  ActiveTab(tbiContactsManager, Sender);
  ActiveControl := edtNome;
end;

procedure TMainForm.RemoveClick(Sender: TObject);
var
  Contact: TContact;
begin
  Contact := FContactService.FindOne(StrToIntDef(lblId.Text, 0));
  FContactService.Remove(Contact);
  ResetControls();
end;

procedure TMainForm.LoadContact(contact: TContact);
begin
  contact.Id := StrToIntDef(lblId.Text, 0);
  contact.Nome := edtNome.Text;
  contact.Email := edtEmail.Text;
  contact.Telefone := edtTelefone.Text;
end;

procedure TMainForm.LoadControls(contact: TContact);
begin
  lblId.Text := contact.Id.ToString();
  edtNome.Text := contact.Nome;
  edtEmail.Text := contact.Email;
  edtTelefone.Text := contact.Telefone;
end;

procedure TMainForm.LoadListViewContacts;
var
  Item: TListViewItem;
  Contact: TContact;
begin
  lvMain.Items.Clear;

  for Contact in FContactService.FindAll() do
  begin
    Item := lvMain.Items.Add();
    Item.Text := Contact.Nome;
    Item.Detail := Contact.Id.ToString();
  end;
end;

procedure TMainForm.ResetControls;
var
  I: Integer;
begin
  for I := 0 to Pred(Self.ComponentCount) do
  begin
    if Self.Components[I] is TEdit then
      TEdit(Self.Components[I]).Text := EmptyStr;

    if Self.Components[I] is TLabel then
      TLabel(Self.Components[I]).Text := EmptyStr;
  end;
end;

end.
