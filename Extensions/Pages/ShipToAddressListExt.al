pageextension 60301 ShipToAddressListExt extends "Ship-to Address List"
{
    layout
    {
        addafter(City)
        {
            field(County; County)
            {
                ApplicationArea = all;
                Caption = 'State';
            }
        }
        addafter("Location Code")
        {
            field("Salesperson Code"; CustomerRec."Salesperson Code")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
    }

    var
        CustomerRec: Record Customer;

    trigger OnAfterGetRecord()
    begin
        if not CustomerRec.get("Customer No.") then
            Clear(CustomerRec);
    end;
}