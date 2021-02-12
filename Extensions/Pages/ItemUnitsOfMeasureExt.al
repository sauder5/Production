pageextension 65404 ItemUnitsOfMeasureExt extends "Item Units of Measure"
{
    layout
    {
        addafter(Weight)
        {
            field("Lowest UOM Code"; "Lowest UOM Code") { Editable = true; ApplicationArea = all; }
            field("Common UOM Code"; "Common UOM Code") { Editable = true; ApplicationArea = all; }
            field("Qty. per Lowest UOM"; "Qty. per Lowest UOM") { Editable = true; ApplicationArea = all; }
            field("Qty. per Common UOM"; "Qty. per Common UOM") { Editable = true; ApplicationArea = all; }
        }
    }

    actions
    {
    }
}