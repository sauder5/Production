tableextension 60120 PurchRcptHeaderExt extends "Purch. Rcpt. Header"
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
        field(51000; "Purchase Contract No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
    }
}