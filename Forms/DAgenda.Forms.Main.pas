unit DAgenda.Forms.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.Actions, FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit, FMX.TabControl, FMX.ActnList,
  FMX.ListBox, FMX.Layouts, FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView,
  FMX.ListView.Adapters.Base;

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
    procedure ActiveTab(ATabItem: TTabItem; Sender: TObject);

    procedure LoadListViewContacts;
    procedure ResetControls;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  tcMain.TabPosition := TTabPosition.None;
  tcMain.ActiveTab := tbiContactsList;

  LoadListViewContacts();
end;

procedure TMainForm.ItemClick(const Sender: TObject; const AItem: TListViewItem);
begin
  ActiveTab(tbiContactsManager, Sender);
end;

procedure TMainForm.ActiveTab(ATabItem: TTabItem; Sender: TObject);
begin
  ctaChangeTab.Tab := ATabItem;
  ctaChangeTab.ExecuteTarget(Sender);
end;

procedure TMainForm.AddClick(Sender: TObject);
begin
  //
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
begin
  //
end;

procedure TMainForm.LoadListViewContacts;
begin
  lvMain.Items.Clear;
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
