unit DContacts.PresentationModel.Dialog;

interface

uses
  System.UITypes;

type
  TModalResult = System.UITypes.TModalResult;
  TDialogAction = reference to procedure(const result: TModalResult);

  IDialog = interface
  ['{203AD4EB-CE78-496B-9FD8-BC3058EA3AAF}']
    procedure ShowConfirmationMessage(const msg: String;
      const dialogAction: TDialogAction = nil);
    procedure ShowErrorMessage(const msg: String;
      const dialogAction: TDialogAction = nil);
    procedure ShowInformationMessage(const msg: String;
      const dialogAction: TDialogAction =  nil);
    procedure ShowWarningMessage(const msg: String;
      const dialogAction: TDialogAction = nil);
  end;

const
  mrNone = System.UITypes.mrNone;
  mrOk = System.UITypes.mrOk;
  mrCancel = System.UITypes.mrCancel;
  mrAbort = System.UITypes.mrAbort;
  mrRetry = System.UITypes.mrRetry;
  mrIgnore = System.UITypes.mrIgnore;
  mrYes = System.UITypes.mrYes;
  mrNo = System.UITypes.mrNo;
  mrClose = System.UITypes.mrClose;
  mrHelp = System.UITypes.mrHelp;
  mrTryAgain = System.UITypes.mrTryAgain;
  mrContinue = System.UITypes.mrContinue;
  mrAll = System.UITypes.mrAll;
  mrNoToAll = System.UITypes.mrNoToAll;
  mrYesToAll = System.UITypes.mrYesToAll;

implementation

end.
