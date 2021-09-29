tableextension 65050 ContactExt extends Contact
{
    fields
    {
<<<<<<< HEAD
        field(50000; "UPS Delivery Notification"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50001; "UPS Shipment Notification"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50002; "UPS Exception Notification"; Boolean)
=======
        field(50000; "Last Website Login"; DateTime)
>>>>>>> d58e8a6fd3076d209890743bcd08e0456d21ddb1
        {
            DataClassification = CustomerContent;
        }
    }
}