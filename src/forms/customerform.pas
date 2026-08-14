unit CustomerForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DBGrids, DB,
  CustomerDataModule;

type

  { TMainForm }

  TMainForm = class(TForm)
    btnNew: TButton;
    btnSave: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnCancel: TButton;
    dbgCustomers: TDBGrid;
    edtSearch: TEdit;
    edtName: TEdit;
    edtDocument: TEdit;
    edtPhone: TEdit;
    edtAddress: TEdit;
    edtEmail: TEdit;
    lblSearch: TLabel;
    grpCustomer: TGroupBox;
    lblName: TLabel;
    lblDocument: TLabel;
    lblPhone: TLabel;
    lblEmail: TLabel;
    lblAddress: TLabel;

    procedure btnCancelClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure edtSearchChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    FIsEditingCustomer: Boolean;

    procedure ClearCustomerFields;
    procedure SetFormState(AIsEditing: Boolean);
    procedure SetCustomerFieldsEnabled(AEnabled: Boolean);
    procedure LoadSelectedCustomer;
    procedure UpdateActionButtons;
    procedure CustomerDataChanged(Sender: TObject);
    procedure AssignFormValuesToDataset;

    function ValidateCustomerFields: Boolean;
    function GetNextCustomerId: Integer;
    function HasCustomers: Boolean;

  public

  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FIsEditingCustomer := False;

  dmCustomers.OnCustomerDataChanged :=
    @CustomerDataChanged;

  ClearCustomerFields;
  SetFormState(False);
end;

procedure TMainForm.btnNewClick(Sender: TObject);
begin
  FIsEditingCustomer := False;

  ClearCustomerFields;
  SetFormState(True);

  edtName.SetFocus;
end;

procedure TMainForm.btnEditClick(Sender: TObject);
begin
  if not HasCustomers then
  begin
    ShowMessage(
      'There is no customer to edit.'
    );
    Exit;
  end;

  FIsEditingCustomer := True;

  LoadSelectedCustomer;
  SetFormState(True);

  edtName.SetFocus;
end;

procedure TMainForm.btnDeleteClick(Sender: TObject);
var
  CustomerName: String;
begin
  if not HasCustomers then
  begin
    ShowMessage(
      'There is no customer to delete.'
    );
    Exit;
  end;

  CustomerName :=
    dmCustomers.bufCustomers
      .FieldByName('NAME')
      .AsString;

  if MessageDlg(
    'Delete customer',
    'Are you sure you want to delete "' +
      CustomerName + '"?',
    mtConfirmation,
    [mbYes, mbNo],
    0
  ) <> mrYes then
    Exit;

  dmCustomers.bufCustomers.Delete;

  ClearCustomerFields;
  SetFormState(False);

  ShowMessage(
    'Customer deleted successfully.'
  );
end;

procedure TMainForm.btnSaveClick(Sender: TObject);
var
  NextId: Integer;
begin
  if not ValidateCustomerFields then
    Exit;

  if FIsEditingCustomer then
  begin
    dmCustomers.bufCustomers.Edit;
  end
  else
  begin
    NextId := GetNextCustomerId;

    dmCustomers.bufCustomers.Append;

    dmCustomers.bufCustomers
      .FieldByName('ID')
      .AsInteger := NextId;
  end;

  try
    AssignFormValuesToDataset;

    dmCustomers.bufCustomers.Post;

    ClearCustomerFields;
    SetFormState(False);

    if FIsEditingCustomer then
      ShowMessage(
        'Customer updated successfully.'
      )
    else
      ShowMessage(
        'Customer registered successfully.'
      );

    FIsEditingCustomer := False;

  except
    dmCustomers.bufCustomers.Cancel;
    raise;
  end;
end;

procedure TMainForm.btnCancelClick(Sender: TObject);
begin
  if dmCustomers.bufCustomers.State
    in [dsEdit, dsInsert] then
  begin
    dmCustomers.bufCustomers.Cancel;
  end;

  FIsEditingCustomer := False;

  ClearCustomerFields;
  SetFormState(False);
end;

procedure TMainForm.edtSearchChange(Sender: TObject);
begin
  dmCustomers.ApplyFilter(
    edtSearch.Text
  );

  UpdateActionButtons;
end;

procedure TMainForm.CustomerDataChanged(Sender: TObject);
begin
  UpdateActionButtons;
end;

procedure TMainForm.ClearCustomerFields;
begin
  edtName.Clear;
  edtDocument.Clear;
  edtPhone.Clear;
  edtEmail.Clear;
  edtAddress.Clear;
end;

procedure TMainForm.AssignFormValuesToDataset;
begin
  dmCustomers.bufCustomers
    .FieldByName('NAME')
    .AsString :=
      Trim(edtName.Text);

  dmCustomers.bufCustomers
    .FieldByName('DOCUMENT')
    .AsString :=
      Trim(edtDocument.Text);

  dmCustomers.bufCustomers
    .FieldByName('PHONE')
    .AsString :=
      Trim(edtPhone.Text);

  dmCustomers.bufCustomers
    .FieldByName('EMAIL')
    .AsString :=
      Trim(edtEmail.Text);

  dmCustomers.bufCustomers
    .FieldByName('ADDRESS')
    .AsString :=
      Trim(edtAddress.Text);
end;

procedure TMainForm.LoadSelectedCustomer;
begin
  if not HasCustomers then
    Exit;

  edtName.Text :=
    dmCustomers.bufCustomers
      .FieldByName('NAME')
      .AsString;

  edtDocument.Text :=
    dmCustomers.bufCustomers
      .FieldByName('DOCUMENT')
      .AsString;

  edtPhone.Text :=
    dmCustomers.bufCustomers
      .FieldByName('PHONE')
      .AsString;

  edtEmail.Text :=
    dmCustomers.bufCustomers
      .FieldByName('EMAIL')
      .AsString;

  edtAddress.Text :=
    dmCustomers.bufCustomers
      .FieldByName('ADDRESS')
      .AsString;
end;

procedure TMainForm.UpdateActionButtons;
begin
  btnEdit.Enabled := HasCustomers;
  btnDelete.Enabled := HasCustomers;
end;

function TMainForm.HasCustomers: Boolean;
begin
  Result :=
    Assigned(dmCustomers) and
    Assigned(dmCustomers.bufCustomers) and
    dmCustomers.bufCustomers.Active and
    (not dmCustomers.bufCustomers.IsEmpty);
end;

function TMainForm.ValidateCustomerFields: Boolean;
begin
  Result := False;

  if Trim(edtName.Text) = '' then
  begin
    ShowMessage('Name is required.');
    edtName.SetFocus;
    Exit;
  end;

  if Trim(edtDocument.Text) = '' then
  begin
    ShowMessage('CPF/CNPJ is required.');
    edtDocument.SetFocus;
    Exit;
  end;

  if Trim(edtPhone.Text) = '' then
  begin
    ShowMessage('Phone is required.');
    edtPhone.SetFocus;
    Exit;
  end;

  if Trim(edtEmail.Text) = '' then
  begin
    ShowMessage('Email is required.');
    edtEmail.SetFocus;
    Exit;
  end;

  if Trim(edtAddress.Text) = '' then
  begin
    ShowMessage('Address is required.');
    edtAddress.SetFocus;
    Exit;
  end;

  Result := True;
end;

function TMainForm.GetNextCustomerId: Integer;
var
  CurrentId: Integer;
  MaxId: Integer;
begin
  MaxId := 0;

  if not HasCustomers then
  begin
    Result := 1;
    Exit;
  end;

  dmCustomers.bufCustomers.DisableControls;

  try
    dmCustomers.bufCustomers.First;

    while not dmCustomers.bufCustomers.EOF do
    begin
      CurrentId :=
        dmCustomers.bufCustomers
          .FieldByName('ID')
          .AsInteger;

      if CurrentId > MaxId then
        MaxId := CurrentId;

      dmCustomers.bufCustomers.Next;
    end;

    Result := MaxId + 1;

  finally
    dmCustomers.bufCustomers.EnableControls;
  end;
end;

procedure TMainForm.SetCustomerFieldsEnabled(
  AEnabled: Boolean
);
begin
  edtName.Enabled := AEnabled;
  edtDocument.Enabled := AEnabled;
  edtPhone.Enabled := AEnabled;
  edtEmail.Enabled := AEnabled;
  edtAddress.Enabled := AEnabled;
end;

procedure TMainForm.SetFormState(
  AIsEditing: Boolean
);
begin
  SetCustomerFieldsEnabled(
    AIsEditing
  );

  btnNew.Enabled := not AIsEditing;
  btnSave.Enabled := AIsEditing;
  btnCancel.Enabled := AIsEditing;

  if AIsEditing then
  begin
    btnEdit.Enabled := False;
    btnDelete.Enabled := False;
  end
  else
    UpdateActionButtons;
end;

end.
