pageextension 60526 PostedSalesInvLinesExt extends "Posted Sales Invoice Lines"
{
    layout
    {
        addafter(Description)
        {
            field("Posting Date"; "Posting Date")
            {
                ApplicationArea = all;
            }
            field("E-Ship Agent Service"; "E-Ship Agent Service")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
    }
}