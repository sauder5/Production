tableextension 60204 UnitOfMeasureExt extends "Unit of Measure"
{
    fields
    {
        field(51000; "Lowest UOM Code"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(51001; "Common UOM Code"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(51002; "Qty. per Lowest UOM"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(51003; "Qty. per Common UOM"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(51010; "Print CUOM Price on Sales Docs"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }
}