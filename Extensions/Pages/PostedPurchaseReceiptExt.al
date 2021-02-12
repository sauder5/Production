pageextension 60145 PostedPurchaseReceiptExt extends "Posted Purchase Receipts"
{
    layout
    {
        addafter("Shipment Method Code")
        {
            field("Order No."; "Order No.")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
    }
}