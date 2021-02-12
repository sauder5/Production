pageextension 67337 PostedWhseShipmentExt extends "Posted Whse. Shipment"
{
    layout
    {

    }

    actions
    {
        addafter("Co&mments")
        {
            action("Registered Pick Lines")
            {
                ApplicationArea = all;
                RunObject = page "Registered Whse. Act.-Lines";
                RunPageLink = "Whse. Document No." = field("Whse. Shipment No.");
                RunPageView = sorting("Activity Type", "No.", "Line No.") where("Activity Type" = const(Pick), "Whse. Document Type" = const(Shipment));
            }
        }
    }
}