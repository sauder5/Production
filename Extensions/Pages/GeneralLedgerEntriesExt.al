pageextension 60020 GeneralLedgerEntriesExt extends "General Ledger Entries"
{
    layout
    {
        addafter("External Document No.")
        {
            field(VenderNo; vendorRec."No.")
            {
                ApplicationArea = All;
            }
            field(VendorName; vendorRec.Name)
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {

    }

    var
        vendorRec: Record Vendor;

    trigger OnAfterGetRecord()
    begin
        if not vendorRec.get("Source No.") then
            Clear(vendorRec);
    end;

}