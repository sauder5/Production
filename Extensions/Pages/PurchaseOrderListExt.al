pageextension 69307 PurchaseOrderListExt extends "Purchase Order List"
{
    layout
    {
        addafter("Buy-from Vendor No.")
        {
            field("Completely Received"; "Completely Received")
            {
                ApplicationArea = all;
            }
        }
        addafter("Amount Received Not Invoiced excl. VAT (LCY)")
        {
            field(Amount; Amount)
            {
                ApplicationArea = all;
            }
        }
        addafter(Amount)
        {
            field("Future PO"; "Future PO")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
    }
}