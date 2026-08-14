unit CustomerForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DBGrids,
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
    procedure btnNewClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);

  private
    procedure ClearCustomerFields;
    function ValidateCustomerFields: Boolean;
    function GetNextCustomerId: Integer;

  public

  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.btnNewClick(Sender: TObject);
begin
  ClearCustomerFields;
  edtName.SetFocus;
end;

procedure TMainForm.btnCancelClick(Sender: TObject);
begin
  ClearCustomerFields;
end;

procedure TMainForm.btnSaveClick(Sender: TObject);
var
  NextId: Integer;
begin
  if not ValidateCustomerFields then
    Exit;

  NextId := GetNextCustomerId;

  dmCustomers.bufCustomers.Append;

  try
    dmCustomers.bufCustomers.FieldByName('ID').AsInteger :=
      NextId;

    dmCustomers.bufCustomers.FieldByName('NAME').AsString :=
      Trim(edtName.Text);

    dmCustomers.bufCustomers.FieldByName('DOCUMENT').AsString :=
      Trim(edtDocument.Text);

    dmCustomers.bufCustomers.FieldByName('PHONE').AsString :=
      Trim(edtPhone.Text);

    dmCustomers.bufCustomers.FieldByName('EMAIL').AsString :=
      Trim(edtEmail.Text);

    dmCustomers.bufCustomers.FieldByName('ADDRESS').AsString :=
      Trim(edtAddress.Text);

    dmCustomers.bufCustomers.Post;

    ClearCustomerFields;

    ShowMessage('Customer registered successfully.');
  except
    dmCustomers.bufCustomers.Cancel;
    raise;
  end;
end;

procedure TMainForm.ClearCustomerFields;
begin
  edtName.Clear;
  edtDocument.Clear;
  edtPhone.Clear;
  edtEmail.Clear;
  edtAddress.Clear;
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
begin
  if dmCustomers.bufCustomers.IsEmpty then
    Result := 1
  else
  begin
    dmCustomers.bufCustomers.Last;
    Result :=
      dmCustomers.bufCustomers.FieldByName('ID').AsInteger + 1;
  end;
end;

end.
