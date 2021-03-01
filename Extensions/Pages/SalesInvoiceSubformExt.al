pageextension 60047 SalesInvoiceSubformExt extends "Sales Invoice Subform"
{
    layout
    {
        modify(Control39)
        {
            Visible = false;
        }
        addafter("Line No.")
        {
            field("Unit Price Reason Code"; "Unit Price Reason Code")
            {
                ApplicationArea = all;
            }
            field("Unit Discount"; "Unit Discount")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {

    }
}