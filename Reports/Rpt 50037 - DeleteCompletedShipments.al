report 50037 "Delete Completed Shipments"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/RDLC/DeleteCompletedShip.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Warehouse Shipment Header"; "Warehouse Shipment Header")
        {
            DataItemTableView = WHERE(Status = FILTER(Released));

            trigger OnAfterGetRecord()
            var
                WhseShptLine: Record "Warehouse Shipment Line";
            begin
                PickLine.SetFilter(PickLine."Whse. Document No.", "Warehouse Shipment Header"."No.");
                if not PickLine.FindSet then begin
                    Validate(Status, Status::Open);
                    WhseShptLine.SetFilter("No.", "No.");
                    if WhseShptLine.Find('-') then
                        repeat
                            if WhseShptLine."Qty. Shipped" < WhseShptLine."Qty. Picked" then
                                exit;
                        until WhseShptLine.Next = 0;
                    Delete(true);
                    //  MODIFY;
                end
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

    var
        PickLine: Record "Warehouse Activity Line";
}

