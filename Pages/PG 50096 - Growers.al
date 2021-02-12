page 50096 Growers
{
    // version GroProd

    PageType = ListPart;
    PopulateAllFields = true;
    SourceTable = "Production Grower";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Vendor No."; "Vendor No.")
                {
                    TableRelation = Vendor."No.";

                    trigger OnValidate();
                    var
                        recVendor: Record Vendor;
                    begin
                        CLEAR(recVendor);
                        if recVendor.GET("Vendor No.") then
                            VALIDATE("Vendor Name", recVendor.Name);
                    end;
                }
                field("Vendor Name"; "Vendor Name")
                {
                    Editable = false;
                }
                field("Grower Share"; "Grower Share")
                {
                    Caption = 'Grower Share %';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean;
    var
        lShare: Decimal;
        return: Boolean;
    begin
        return := true;
        SETFILTER("Production Lot No.", "Production Lot No.");
        CALCSUMS("Grower Share");
        if "Grower Share" <> 100 then
            return := CONFIRM('Grower share total does not equal 100.  Do you still want to close the window?', false);

        exit(return);
    end;
}

