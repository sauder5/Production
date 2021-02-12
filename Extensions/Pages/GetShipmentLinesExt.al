pageextension 65708 GetShipmentLinesExt extends "Get Shipment Lines"
{
    layout
    {
        addafter("Qty. Shipped Not Invoiced")
        {
            field("Order No."; "Order No.")
            {
                applicationarea = all;
            }
        }
    }

    actions
    {
    }
}