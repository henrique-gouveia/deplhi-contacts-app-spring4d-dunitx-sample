unit DContacts.PresentationModel.Dialog.FMX;

interface

uses
  System.UITypes,
  DContacts.PresentationModel.Dialog;

type
  TFMXDialogAdapter = class(TInterfacedObject, IDialog)
  private
    procedure ShowDialogMessage(const msg: string; const dialogType: TMsgDlgType;
      const dialogAction: TDialogAction = nil; const buttons: TMsgDlgButtons = [TMsgDlgBtn.mbOK];
      const helpContext: LongInt = 0);
  public
    procedure ShowConfirmationMessage(const msg: String;
      const dialogAction: TDialogAction = nil);
    procedure ShowErrorMessage(const msg: String;
      const dialogAction: TDialogAction = nil);
    procedure ShowInformationMessage(const msg: String;
      const dialogAction: TDialogAction =  nil);
    procedure ShowWarningMessage(const msg: String;
      const dialogAction: TDialogAction = nil);
  end;

implementation

uses
  System.SysUtils,
  FMX.Dialogs;

{$REGION 'IFMXDialogAdapter' }

procedure TFMXDialogAdapter.ShowConfirmationMessage(const msg: String; const dialogAction: TDialogAction);
begin
  ShowDialogMessage(msg, TMsgDlgType.mtConfirmation, dialogAction,
    [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo]);
end;

procedure TFMXDialogAdapter.ShowErrorMessage(const msg: String; const dialogAction: TDialogAction);
begin
  ShowDialogMessage(msg, TMsgDlgType.mtError, dialogAction);
end;

procedure TFMXDialogAdapter.ShowInformationMessage(const msg: String; const dialogAction: TDialogAction);
begin
  ShowDialogMessage(msg, TMsgDlgType.mtInformation, dialogAction);
end;

procedure TFMXDialogAdapter.ShowWarningMessage(const msg: String; const dialogAction: TDialogAction);
begin
  ShowDialogMessage(msg, TMsgDlgType.mtWarning);
end;

procedure TFMXDialogAdapter.ShowDialogMessage(const msg: string; const dialogType: TMsgDlgType;
  const dialogAction: TDialogAction; const buttons: TMsgDlgButtons; const helpContext: Integer);
begin
  MessageDlg(msg, dialogType, buttons, helpContext,
    procedure(const AResult: TModalResult)
    begin
      if Assigned(dialogAction) then
        dialogAction(AResult);
    end);
end;

{$ENDREGION}

end.
