pageextension 60007 CustomerPriceGroupExt extends "Customer Price Groups"
{
    layout
    {
        addafter(Description)
        {
            field("Additional Discount"; "Additional Cust. Discount")
            {
                ApplicationArea = All;
            }
        }
    }
}