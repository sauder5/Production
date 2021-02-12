tableextension 80717 PackingControlExt extends "Packing Control"
{
    fields
    {
        field(50000; "External Tracking No."; Code[35])
        {
            DataClassification = CustomerContent;
        }
        field(51000; "Warehouse Shipment No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
    }
}