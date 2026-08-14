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
    procedure dsCustomersDataChange(Sender: TObject; Field: TField);
  private

  public

  end;

var
  dmCustomers: TdmCustomers;

implementation

{$R *.lfm}

{ TdmCustomers }

procedure TdmCustomers.DataModuleCreate(Sender: TObject);
begin
  bufCustomers.CreateDataset;
end;

procedure TdmCustomers.dsCustomersDataChange(Sender: TObject; Field: TField);
begin

end;

end.

