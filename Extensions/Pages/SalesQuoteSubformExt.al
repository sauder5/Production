pageextension 60095 SalesQuoteSubformExt extends "Sales Quote Subform"
{
    layout
    {
        addafter("Unit Price")
        {
            field("Unit Price Reason Code"; "Unit Price Reason Code")
            {
                ApplicationArea = all;
            }
            field("Unit Price per CUOM"; "Unit Price per CUOM")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
    }
}