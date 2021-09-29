pageextension 65052 ContactListExt extends "Contact List"
{
    Editable = true;
    layout
    {
        addafter("Search Name")
        {
            field(Address; Address)
            {
                applicationarea = all;
            }
            field(City; City)
            {
                applicationarea = all;
            }
            field(County; County)
            {
                ApplicationArea = all;
                Caption = 'State';
            }
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
    }

    actions
    {
    }
}