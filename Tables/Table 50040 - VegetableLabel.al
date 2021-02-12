table 50040 "Vegetable Label"
{

    fields
    {
        field(10; "Item Number"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(20; "Product Category"; Code[30])
        {
            DataClassification = CustomerContent;
        }
        field(30; "Product Name"; Text[40])
        {
            DataClassification = CustomerContent;
        }
        field(40; "Product Info"; Text[40])
        {
            DataClassification = CustomerContent;
        }
        field(50; "Net Weight Seed"; Text[20])
        {
            DataClassification = CustomerContent;
        }
        field(60; "Batch Number"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(70; "Lot Number"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(80; "Test Date"; Text[10])
        {
            DataClassification = CustomerContent;
        }
        field(90; Germ; Text[10])
        {
            DataClassification = CustomerContent;
        }
        field(100; Purity; Text[10])
        {
            DataClassification = CustomerContent;
        }
        field(110; "Inert Material"; Text[10])
        {
            DataClassification = CustomerContent;
        }
        field(120; Caution; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(130; Origin; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(140; Picture; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(150; "Seed Size"; Text[20])
        {
            DataClassification = CustomerContent;
        }
        field(160; "Seeds Per Lb"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 4 : 4;
        }
        field(170; "JD Plate"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(180; "IH Plate"; Code[20])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Item Number")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

