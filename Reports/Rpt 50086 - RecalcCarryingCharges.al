report 50086 "Recalc Carrying Charges"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Grower Ticket"; "Grower Ticket")
        {

            trigger OnAfterGetRecord()
            begin
                VALIDATE("Gross Wgt (LB)");
                CalcCarryingCharge;
                MODIFY;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }
}

