tableextension 65050 ContactExt extends Contact
{
    fields
    {
        field(50500; "UPS Delivery Notification"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50501; "UPS Shipment Notification"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50502; "UPS Exception Notification"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50550; "Last Website Login"; DateTime)
        {
            DataClassification = CustomerContent;
        }
    }
}