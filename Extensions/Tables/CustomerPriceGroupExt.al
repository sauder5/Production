tableextension 60006 CustomerPriceGrpExt extends "Customer Price Group"
{
    fields
    {
        field(52001; "Additional Discount"; Boolean)
        {
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
        }
        field(52002; "Additional Cust. Discount"; Decimal)
        {
            Caption = 'Additional Discount';
            DataClassification = CustomerContent;
        }
    }
}