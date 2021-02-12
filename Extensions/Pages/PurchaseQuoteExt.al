pageextension 60049 PurchaseQuoteExt extends "Purchase Quote"

{
    layout
    {
        addbefore("Pay-to Name")
        {
            field("Pay-to Vendor No."; "Pay-to Vendor No.")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }
}