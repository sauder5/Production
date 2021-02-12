pageextension 69082 CustomerStatsFBExt extends "Customer Statistics Factbox"
{
    layout
    {
        addafter("Balance (LCY)")
        {
            field("Remaining Seasonal Discount"; "Remaining Seasonal Discount")
            {
                applicationarea = all;
            }
        }
    }

    actions
    {
    }
    trigger OnOpenPage()
    begin
        CalcFields("Remaining Seasonal Discount");
    end;

}