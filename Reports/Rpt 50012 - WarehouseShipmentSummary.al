report 50012 "Warehouse Shipment Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/RDLC/WarehouseShipmentSummary.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(WhseShptLine; "Warehouse Shipment Line")
        {
            DataItemTableView = SORTING("No.", "Item No.") ORDER(Ascending);
            column(WHShipNo; WhseShptLine."No.")
            {
            }
            column(Location; WhseShptLine."Location Code")
            {
            }
            column(ItemNo; WhseShptLine."Item No.")
            {
            }
            column(Description; WhseShptLine.Description)
            {
            }
            column(PickQty; WhseShptLine."Qty. to Pick")
            {
            }
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

