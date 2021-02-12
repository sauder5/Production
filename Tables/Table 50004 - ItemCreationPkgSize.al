table 50004 "Item Creation Pkg Size"
{
    DrillDownPageID = "Item Creation Package Sizes";
    LookupPageID = "Item Creation Package Sizes";

    fields
    {
        field(1; "Package Size"; Code[10])
        {
            DataClassification = CustomerContent;
            Description = 'PK';
            NotBlank = true;
            TableRelation = "Unit of Measure";

            trigger OnValidate()
            var
                recUnitOfMeasure: Record "Unit of Measure";
            begin
                if recUnitOfMeasure.Get("Package Size") then begin
                    "Lowest UOM" := recUnitOfMeasure."Lowest UOM Code";
                    "Common UOM" := recUnitOfMeasure."Common UOM Code";
                    "Qty. per LUOM" := recUnitOfMeasure."Qty. per Lowest UOM";
                    "Qty. per CUOM" := recUnitOfMeasure."Qty. per Common UOM";
                end;
            end;
        }
        field(10; "Qty. per"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(11; "Create Item"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(20; "Product Code"; Code[17])
        {
            DataClassification = CustomerContent;
            Description = 'Product Code';
        }
        field(21; "Product Description"; Text[50])
        {
            DataClassification = CustomerContent;
            Description = 'Product Description';
        }
        field(22; "Treatment Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'Treatment Code';
        }
        field(23; Description; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(30; "New Item No."; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(31; "Item Exists"; Boolean)
        {
            CalcFormula = Exist (Item WHERE("No." = FIELD("New Item No.")));
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(32; "Exceeds Item No. length"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(33; "Product Exists"; Boolean)
        {
            CalcFormula = Exist (Product WHERE(Code = FIELD("Product Code")));
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(34; "Item Template Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Config. Template Header".Code WHERE("Table ID" = FILTER(27));
        }
        field(40; "Lowest UOM"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Lowest UOM';
            Description = 'SOC';
            NotBlank = true;
            TableRelation = "Unit of Measure";
        }
        field(41; "Common UOM"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Common UOM';
            Description = 'SOC';
            NotBlank = true;
            TableRelation = "Unit of Measure";
        }
        field(42; "Qty. per LUOM"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Description = 'SOC';
        }
        field(43; "Qty. per CUOM"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Description = 'SOC';
        }
        field(45; "Pkg Size Abbr"; Text[5])
        {
            DataClassification = CustomerContent;
            Description = 'RSI-TE';
            NotBlank = false;
        }
        field(48; "Include Seed Size"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Package Size")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

