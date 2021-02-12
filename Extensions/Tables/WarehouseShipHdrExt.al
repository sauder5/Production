tableextension 67320 WarehouseShipHdrExt extends "Warehouse Shipment Header"
{
    fields
    {
        field(50000; "Create Pick for Qty. to Pick"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50010; "E-Ship Agent Service"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50011; "External Tracking No."; Text[35])
        {
            DataClassification = CustomerContent;
        }
    }
}