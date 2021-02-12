tableextension 80908 EMailListEntryExt extends "E-Mail List Entry"
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
    }

    var
        myInt: Integer;
}