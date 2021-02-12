pageextension 67007 GetSalesPriceExt extends "Get Sales Price"
{
    layout
    {
        addafter("Sales Code")
        {
            field("Region Code"; "Region Code")
            {
                applicationarea = all;
            }
        }
        addafter("Minimum Quantity")
        {
            field("Unit Price per Common UOM"; "Unit Price per Common UOM")
            {
                applicationarea = all;
            }
            field("Common UOM"; "Common UOM")
            {
                applicationarea = all;
            }
        }
    }

    actions
    {
    }
}