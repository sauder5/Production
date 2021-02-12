tableextension 65109 PurchaseHeaderArcExt extends "Purchase Header Archive"
{
    fields
    {
        field(50000; "Order Created By"; Code[35])
        {
            DataClassification = CustomerContent;
        }
        field(50001; "Order Created Date Time"; datetime)
        {
            DataClassification = CustomerContent;
        }
    }
}