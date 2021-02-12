tableextension 70302 ACHUSFooterExt extends "ACH US Footer"
{
    fields
    {
        field(50000; "Bank Account Number"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(50001; "DIscretionary Data"; Text[30])
        {
            DataClassification = CustomerContent;
        }
    }
}