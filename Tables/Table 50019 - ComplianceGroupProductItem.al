table 50019 "Compliance Group Product Item"
{
    DrillDownPageID = "Compliance Group Items";
    LookupPageID = "Compliance Group Items";

    fields
    {
        field(1; "Waiver Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'PK';
            TableRelation = "Compliance Group"."Waiver Code";
        }
        field(2; "Product Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'PK';
            TableRelation = Product;

            trigger OnValidate()
            var
                recComplianceGroup: Record "Compliance Group";
            begin
                if recComplianceGroup.Get("Waiver Code") then begin
                    "License Required" := recComplianceGroup."License Required";
                    "Liability Waiver Required" := recComplianceGroup."Liability Waiver Required";
                    "Quality Release Required" := recComplianceGroup."Quality Release Required";
                end;
            end;
        }
        field(3; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'PK';
            TableRelation = IF ("Product Code" = FILTER(<> '')) Item."No." WHERE("Product Code" = FIELD("Product Code"))
            ELSE
            IF ("Product Code" = FILTER('')) Item."No.";

            trigger OnValidate()
            var
                recComplianceGroup: Record "Compliance Group";
                recComplianceItem: Record "Compliance Group Product Item";
            begin
                recComplianceItem.Reset();
                recComplianceItem.SetFilter("Waiver Code", '<>%1', "Waiver Code");
                recComplianceItem.SetRange("Item No.", "Item No.");
                if recComplianceItem.FindFirst() then
                    Error('Item %1 is already covered by Compliance group %2', "Item No.", recComplianceItem."Waiver Code");

                if recComplianceGroup.Get("Waiver Code") then begin
                    "License Required" := recComplianceGroup."License Required";
                    "Liability Waiver Required" := recComplianceGroup."Liability Waiver Required";
                    "Quality Release Required" := recComplianceGroup."Quality Release Required";
                end;
            end;
        }
        field(10; "License Required"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(20; "Liability Waiver Required"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(30; "Quality Release Required"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50; "Customer License Exists"; Boolean)
        {
            CalcFormula = Exist (Compliance WHERE("Waiver Code" = FIELD("Waiver Code"),
                                                  "Customer No." = FIELD("Customer No. Filter"),
                                                  "License No." = FILTER(<> '')));
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(51; "Customer No. Filter"; Code[20])
        {
            Description = 'Ffilter';
            FieldClass = FlowFilter;
            TableRelation = Customer;
        }
        field(52; "Cust. Liability Waiver Signed"; Boolean)
        {
            CalcFormula = Exist (Compliance WHERE("Waiver Code" = FIELD("Waiver Code"),
                                                  "Customer No." = FIELD("Customer No. Filter"),
                                                  "Liability Waiver Signed" = CONST(true)));
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(53; "Cust. Quality Release Signed"; Boolean)
        {
            CalcFormula = Exist (Compliance WHERE("Waiver Code" = FIELD("Waiver Code"),
                                                  "Customer No." = FIELD("Customer No. Filter"),
                                                  "Quality Release Signed" = CONST(true)));
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(54; "Cust. Compliance Exists"; Boolean)
        {
            CalcFormula = Exist (Compliance WHERE("Waiver Code" = FIELD("Waiver Code"),
                                                  "Customer No." = FIELD("Customer No. Filter")));
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Waiver Code", "Product Code", "Item No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

