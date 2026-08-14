unit CustomerForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DBGrids;

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
  private


  public

  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

end.

