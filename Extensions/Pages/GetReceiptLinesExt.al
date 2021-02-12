pageextension 65709 GetReceiptLinesExt extends "Get Receipt Lines"
{
    layout
    {
        addafter("No.")
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