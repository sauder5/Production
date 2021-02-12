tableextension 70301 ACHUSDetailExt extends "ACH US Detail"
{
    fields
    {
        field(50000; "Total Debits"; Decimal)
        {
            DataClassification = CustomerContent;
        }
    }
}