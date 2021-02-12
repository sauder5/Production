pageextension 60076 ResourceCardExt extends "Resource Card"
{
    layout
    {
        addafter("Time Sheet Approver User ID")
        {
            field(Freight; Freight)
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
    }
}