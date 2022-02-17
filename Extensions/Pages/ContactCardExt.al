pageextension 65050 ContactCardExt extends "Contact Card"
{
    layout
    {
        addafter("Language Code")
        {
            field("UPS Delivery Notification"; "UPS Delivery Notification")
            {
                ApplicationArea = all;
            }
            field("UPS Exception Notification"; "UPS Exception Notification")
            {
                ApplicationArea = all;
            }
            field("UPS Shipment Notification"; "UPS Shipment Notification")
            {
                ApplicationArea = all;
            }
        }
        addlast(General)
        {
            field(Last_Website_Login; "Last Website Login")
            {
                applicationarea = all;
            }
        }
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }
}