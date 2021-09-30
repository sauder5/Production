tableextension 65050 ContactExt extends Contact
{
    fields
    {
        field(50000; "UPS Delivery Notification"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50001; "UPS Shipment Notification"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50002; "UPS Exception Notification"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50010; "Last Website Login"; DateTime)
        {
            DataClassification = CustomerContent;
        }
    }
}