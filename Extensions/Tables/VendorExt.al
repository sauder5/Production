tableextension 60023 VendorExt extends Vendor
{
    fields
    {
        field(50000; "Protected Vendor"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup ("Vendor Posting Group"."Protected Posting Group" WHERE(Code = FIELD("Vendor Posting Group")));
        }
    }
    trigger OnAfterInsert()
    begin
        //RSI-KS
        VALIDATE("Check Date Format", "Check Date Format"::"MM DD YYYY");
        VALIDATE("Check Date Separator", "Check Date Separator"::"/");
        //RSI-KS
    end;
}