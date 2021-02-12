pageextension 60209 UnitsOfMeasureExt extends "Units of Measure"
{
    layout
    {
        addafter("SAT UofM Classification")
        {
            field("Lowest UOM Code"; "Lowest UOM Code")
            {
                ApplicationArea = all;
            }
            field("Common UOM Code"; "Common UOM Code")
            {
                ApplicationArea = all;
            }
            field("Qty. per Lowest UOM"; "Qty. per Lowest UOM")
            {
                ApplicationArea = all;
            }
            field("Qty. per Common UOM"; "Qty. per Common UOM")
            {
                ApplicationArea = all;
            }
            field("Print CUOM Price on Sales Docs"; "Print CUOM Price on Sales Docs")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
    }
}