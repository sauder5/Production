pageextension 60110 CustomerPostingGroupsExt extends "Customer Posting Groups"
{
    layout
    {
        addafter("Payment Tolerance Credit Acc.")
        {
            field("Customer Price Group"; "Customer Price Group")
            {
                applicationarea = all;
            }
            field("Global Dimension 1 Code"; "Global Dimension 1 Code")
            {
                applicationarea = all;
            }
            field("Global Dimension 2 Code"; "Global Dimension 2 Code")
            {
                applicationarea = all;
            }
            field("To Print Seas Disc Sch on Conf"; "To Print Seas Disc Sch on Conf")
            {
                applicationarea = all;
            }
        }
    }

    actions
    {
    }
}