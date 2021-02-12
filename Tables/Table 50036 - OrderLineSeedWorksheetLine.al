table 50036 "Order Line Seed Worksheet Line"
{
    // //SOC-SC 08-27-15
    //   Increased length of "Internal Lot No." to 40

    DrillDownPageID = "Order Line Seed Worksheet";
    LookupPageID = "Order Line Seed Worksheet";

    fields
    {
        field(1; "Batch No."; Integer)
        {
            DataClassification = CustomerContent;
            Description = 'PK';
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Description = 'PK';
        }
        field(11; "Pick No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Nº';
            Editable = false;
        }
        field(12; "Pick Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Nº línea';
            Editable = false;
        }
        field(13; "Source Type"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Source Type';
            Editable = false;
        }
        field(14; "Source Subtype"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Source Subtype';
            Editable = false;
            OptionCaption = '0,1,2,3,4,5,6,7,8,9,10';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10";
        }
        field(15; "Source No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Source No.';
            Editable = false;
        }
        field(16; "Source Line No."; Integer)
        {
            DataClassification = CustomerContent;
            BlankZero = true;
            Caption = 'Source Line No.';
            Editable = false;
        }
        field(17; "Source Subline No."; Integer)
        {
            DataClassification = CustomerContent;
            BlankZero = true;
            Caption = 'Source Subline No.';
            Editable = false;
        }
        field(18; "Source Document"; Option)
        {
            DataClassification = CustomerContent;
            BlankZero = true;
            Caption = 'Source Document';
            Editable = false;
            OptionCaption = ' ,Sales Order,,,Sales Return Order,Purchase Order,,,Purchase Return Order,Inbound Transfer,Outbound Transfer,Prod. Consumption,Prod. Output,,,,,,Service Order,,Assembly Consumption,Assembly Order';
            OptionMembers = ,"Sales Order",,,"Sales Return Order","Purchase Order",,,"Purchase Return Order","Inbound Transfer","Outbound Transfer","Prod. Consumption","Prod. Output",,,,,,"Service Order",,"Assembly Consumption","Assembly Order";
        }
        field(30; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.';
            Editable = false;
            TableRelation = Item;
        }
        field(31; "Variant Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Variant Code';
            Editable = false;
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));

            trigger OnValidate()
            var
                ItemVariant: Record "Item Variant";
            begin
            end;
        }
        field(32; "Unit of Measure Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Unit of Measure Code';
            Editable = false;
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(33; "Qty. per Unit of Measure"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
        }
        field(34; Description; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
            Editable = false;
        }
        field(35; Quantity; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                "Line Seed Weight in g" := "Unit Seed Weight in g" * Quantity;
            end;
        }
        field(36; "Product Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Product;
        }
        field(37; "Seed Size"; Option)
        {
            CalcFormula = Lookup (Product."Seed Size" WHERE(Code = FIELD("Product Code")));
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
            OptionMembers = ,Small,Large;
        }
        field(40; "Unit Seed Weight in g"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                "Line Seed Weight in g" := "Unit Seed Weight in g" * Quantity;
                UpdateWhseActLn();
            end;
        }
        field(41; "Line Seed Weight in g"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                "Unit Seed Weight in g" := Round("Line Seed Weight in g" / Quantity, 0.01);
                UpdateWhseActLn();
            end;
        }
        field(42; "Internal Lot No."; Code[40])
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                UpdateWhseActLn();
            end;
        }
        field(43; "Country of Origin Code"; Code[10])
        {
            TableRelation = "Country/Region";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                UpdateWhseActLn();
            end;
        }
        field(50; "Created By"; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(51; "Created DateTime"; DateTime)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Batch No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    local procedure UpdateWhseActLn()
    var
        recWAL: Record "Warehouse Activity Line";
    begin
        if recWAL.Get(recWAL."Activity Type"::Pick, "Pick No.", "Pick Line No.") then begin
            recWAL."Unit Seed Weight in g" := "Unit Seed Weight in g";
            recWAL."Line Seed Weight in g" := "Line Seed Weight in g";
            recWAL."Internal Lot No." := "Internal Lot No.";
            recWAL."Country of Origin Code" := "Country of Origin Code";
            recWAL.Modify();
        end;
    end;
}

