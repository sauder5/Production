pageextension 69313 WarehousePicksExt extends "Warehouse Picks"
{
    layout
    {

    }

    actions
    {
        addafter("Registered Picks")
        {
            action("Order Pick Ticket")
            {
                ApplicationArea = ALL;
                trigger OnAction()
                var
                    recWAH: Record "Warehouse Activity Header";
                begin
                    //SOC-SC 07-06-15
                    recWAH.RESET();
                    recWAH.SETRANGE(Type, Type);
                    recWAH.SETRANGE("No.", "No.");
                    recWAH.FINDSET();
                    REPORT.RUNMODAL(Report::"Pick Ticket per Order", TRUE, FALSE, recWAH);
                end;

            }
        }
    }
}