pageextension 60516 SalesLineExt extends "Sales Lines"
{
    layout
    {
        addafter("Sell-to Customer No.")
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
        if not recCustomer.get("Sell-to Customer No.") then
            clear(recCustomer);
    end;
}