unit DContacts.Views.Contact;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.Actions,

  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Controls.Presentation,
  FMX.Edit,
  FMX.TabControl,
  FMX.ActnList,
  FMX.ListBox,
  FMX.Layouts,
  FMX.ListView.Types,
  FMX.ListView.Appearances,
  FMX.ListView,
  FMX.ListView.Adapters.Base,

  DContacts.Controllers.Contact,

  Spring.Container.Common;

type
  TContactView = class(TForm)
    actions: TActionList;
    addAction: TAction;
    backAction: TAction;
    removeAction: TAction;
    saveAction: TAction;
    changeTabAction: TChangeTabAction;
    tabControl: TTabControl;
    contactListTabItem: TTabItem;
    contactListToolBar: TToolBar;
    contactListLabelTitle: TLabel;
    contactListView: TListView;
    contactManagerTabControlItem: TTabItem;
    contactManagerToolBar: TToolBar;
    contactManagerLayout: TLayout;
    contactManagerLabelTitle: TLabel;
    contactManagerListBox: TListBox;
    nomeListBoxGroupHeader: TListBoxGroupHeader;
    nomeListBoxItem: TListBoxItem;
    emailListBoxGroupHeader: TListBoxGroupHeader;
    emailListBoxItem: TListBoxItem;
    telefoneListBoxGroupHeader: TListBoxGroupHeader;
    telefoneListBoxItem: TListBoxItem;
    idLabel: TLabel;
    nomeEdit: TEdit;
    emailEdit: TEdit;
    telefoneEdit: TEdit;
    addButton: TSpeedButton;
    backButton: TSpeedButton;
    removeButton: TSpeedButton;
    saveButton: TSpeedButton;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ItemClick(const Sender: TObject; const AItem: TListViewItem);
    procedure AddClick(Sender: TObject);
    procedure BackClick(Sender: TObject);
    procedure RemoveClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
  private
    FContactController: TContactController;

    procedure ActiveTab(tabItem: TTabItem; Sender: TObject);

    procedure LoadContacts;
    procedure LoadContact;
    procedure LoadControls;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses
  DContacts.Models.Entities.Contact,
  Spring.Container;

{$R *.fmx}

constructor TContactView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FContactController := GlobalContainer.Resolve<TContactController>();
  FContactController.OnListar := BackClick;
end;

procedure TContactView.FormCreate(Sender: TObject);
begin
  tabControl.TabPosition := TTabPosition.None;
  tabControl.ActiveTab := contactListTabItem;
end;

procedure TContactView.FormShow(Sender: TObject);
begin
  LoadContacts();
end;

procedure TContactView.ItemClick(const Sender: TObject; const AItem: TListViewItem);
begin
  FContactController.ContactId := AItem.Detail.ToInteger();
  LoadControls();

  ActiveTab(contactManagerTabControlItem, Sender);
end;

procedure TContactView.SaveClick(Sender: TObject);
begin
  LoadContact();
  FContactController.Salvar();
  //BackClick(Sender);
end;

procedure TContactView.LoadContact;
begin
  FContactController.contact.Id := StrToIntDef(idLabel.Text, 0);
  FContactController.contact.Nome := nomeEdit.Text;
  FContactController.contact.Email := emailEdit.Text;
  FContactController.contact.Telefone := telefoneEdit.Text;
end;

procedure TContactView.BackClick(Sender: TObject);
begin
  FContactController.Novo();
  LoadContacts();

  ActiveTab(contactListTabItem, Sender);
  ActiveControl := nil;
end;

procedure TContactView.LoadContacts;
var
  contact: TContact;
  item: TListViewItem;
begin
  contactListView.Items.Clear;

  for contact in FContactController.Contacts do
  begin
    item := contactListView.Items.Add;
    item.Text := contact.Nome;
    item.Detail := contact.Id.ToString();
  end;
end;

procedure TContactView.AddClick(Sender: TObject);
begin
  FContactController.Novo();
  LoadControls();

  ActiveTab(contactManagerTabControlItem, Sender);
  ActiveControl := nomeEdit;
end;

procedure TContactView.ActiveTab(tabItem: TTabItem; Sender: TObject);
begin
  changeTabAction.Tab := tabItem;
  changeTabAction.ExecuteTarget(Sender);
end;

procedure TContactView.RemoveClick(Sender: TObject);
begin
  FContactController.ContactId := StrToIntDef(idLabel.Text, 0);
  FContactController.Excluir();
  //BackClick(Sender);
end;

procedure TContactView.LoadControls;
begin
  idLabel.Text := FContactController.Contact.Id.ToString();
  nomeEdit.Text := FContactController.Contact.Nome;
  emailEdit.Text := FContactController.Contact.Email;
  telefoneEdit.Text := FContactController.Contact.Telefone;
end;

end.
