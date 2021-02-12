pageextension 69080 SalesHistSellToFBExt extends "Sales Hist. Sell-to FactBox"
{
    layout
    {
        addafter("No. of Orders")
        {
            field("Partially Shipped Sales Orders"; "Partially Shipped Sales Orders")
            {
                ApplicationArea = all;
            }
            field("Warehouse Pick Lines"; "Warehouse Pick Lines")
            {
                ApplicationArea = all;
            }
        }
        addafter(NoofOrdersTile)
        {
            field(NoofPartiallyShipped; "Partially Shipped Sales Orders")
            {
                ApplicationArea = all;
            }
            field(NoofWarehousePickLines; "Warehouse Pick Lines")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
    }
}