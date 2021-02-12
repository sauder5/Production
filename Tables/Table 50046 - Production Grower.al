table 50046 "Production Grower"
{
    // version GroProd


    fields
    {
        field(10; "Production Lot No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Production Lot"."Production Lot No.";
        }
        field(20; "Vendor No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";

            trigger OnValidate();
            var
                recVend: Record Vendor;
            begin
                CLEAR(recVend);
                if recVend.GET("Vendor No.") then
                    VALIDATE("Vendor Name", recVend.Name);
            end;
        }
        field(30; "Vendor Name"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(40; "Grower Share"; Decimal)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Production Lot No.", "Vendor No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    var
        recProdGrower: Record "Production Grower";
    begin
        if "Grower Share" = 0 then begin
            recProdGrower.RESET;
            recProdGrower.SETFILTER("Production Lot No.", "Production Lot No.");
            recProdGrower.CALCSUMS("Grower Share");
            "Grower Share" := 100 - recProdGrower."Grower Share";
        end;
    end;
}

