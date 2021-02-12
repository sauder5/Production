tableextension 60124 PurchCRMemoHdrExt extends "Purch. Cr. Memo Hdr."
{
    fields
    {
        field(50000; "Order Created By"; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(50001; "Order Created Date Time"; datetime)
        {
            DataClassification = CustomerContent;
        }
    }
}