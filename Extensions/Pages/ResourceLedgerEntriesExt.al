pageextension 60202 ResourceLedgerEntriesExt extends "Resource Ledger Entries"
{
    layout
    {
        addafter("Dimension Set ID")
        {
            field("Customer Name"; recCustomer.Name)
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
    }

    var
        recCustomer: Record Customer;

    trigger OnAfterGetRecord()
    begin
        if not recCustomer.get("Source No.") then
            Clear(recCustomer);
    end;
}