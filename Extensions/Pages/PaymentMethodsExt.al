pageextension 60427 PaymentMethodsExt extends "Payment Methods"
{
    layout
    {
        addafter("Use for Invoicing")
        {
            field("Print Disc Sched on Ord Conf."; "Print Disc Sched on Ord Conf.")
            {
                ApplicationArea = all;
            }
            field("Payment Terms Code"; "Payment Terms Code")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
    }
}