unit CustomerDataModule;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, BufDataset, DB;

type

  { TdmCustomers }

  TdmCustomers = class(TDataModule)
    bufCustomers: TBufDataset;
    bufCustomersADDRESS: TStringField;
    bufCustomersDOCUMENT: TStringField;
    bufCustomersEMAIL: TStringField;
    bufCustomersID: TLongintField;
    bufCustomersNAME: TStringField;
    bufCustomersPHONE: TStringField;
    dsCustomers: TDataSource;

    procedure DataModuleCreate(Sender: TObject);

  private
    FFilterText: String;

    procedure bufCustomersFilterRecord(
      DataSet: TDataSet;
      var Accept: Boolean
    );

  public
    procedure ApplyFilter(const AFilterText: String);
  end;

var
  dmCustomers: TdmCustomers;

implementation

{$R *.lfm}

{ TdmCustomers }

procedure TdmCustomers.DataModuleCreate(Sender: TObject);
begin
  if not bufCustomers.Active then
    bufCustomers.CreateDataset;

  FFilterText := '';

  bufCustomers.OnFilterRecord := @bufCustomersFilterRecord;
end;

procedure TdmCustomers.ApplyFilter(const AFilterText: String);
begin
  FFilterText := LowerCase(Trim(AFilterText));

  if FFilterText = '' then
  begin
    bufCustomers.Filtered := False;
    Exit;
  end;

  bufCustomers.Filtered := False;
  bufCustomers.Filtered := True;
end;

procedure TdmCustomers.bufCustomersFilterRecord(
  DataSet: TDataSet;
  var Accept: Boolean
);
var
  CustomerName: String;
  CustomerDocument: String;
  CustomerPhone: String;
  CustomerEmail: String;
  CustomerAddress: String;
begin
  if FFilterText = '' then
  begin
    Accept := True;
    Exit;
  end;

  CustomerName :=
    LowerCase(DataSet.FieldByName('NAME').AsString);

  CustomerDocument :=
    LowerCase(DataSet.FieldByName('DOCUMENT').AsString);

  CustomerPhone :=
    LowerCase(DataSet.FieldByName('PHONE').AsString);

  CustomerEmail :=
    LowerCase(DataSet.FieldByName('EMAIL').AsString);

  CustomerAddress :=
    LowerCase(DataSet.FieldByName('ADDRESS').AsString);

  Accept :=
    (Pos(FFilterText, CustomerName) > 0) or
    (Pos(FFilterText, CustomerDocument) > 0) or
    (Pos(FFilterText, CustomerPhone) > 0) or
    (Pos(FFilterText, CustomerEmail) > 0) or
    (Pos(FFilterText, CustomerAddress) > 0);
end;

end.
