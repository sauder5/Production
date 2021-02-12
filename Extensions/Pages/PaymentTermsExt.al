pageextension 60004 PaymentTermsExt extends "Payment Terms"
{
    layout
    {
        addafter("COD Cashiers Check")
        {
            field("Allow Seasonal Cash Discount"; "Allow Seasonal Cash Discount")
            {
                ApplicationArea = All;
            }
            field("Due Date MM-DD"; "Due Date MM-DD")
            {
                ApplicationArea = All;
            }
            field("Print Disc Sched on Ord Conf."; "Print DIsc Sched on Ord Conf.")
            {
                ApplicationArea = All;
            }
        }
    }
}