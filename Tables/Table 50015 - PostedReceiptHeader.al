table 50015 "Posted Receipt Header"
{
    // //SOC-SC 08-06-15
    //   Added field:
    //     36; Vomitoxin Test Result; Decimal

    DrillDownPageID = "Posted Receipts";
    LookupPageID = "Posted Receipts";

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'PK';
        }
        field(10; "Receipt Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(11; "Primary Vendor No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Vendor;
        }
        field(12; Status; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = ,Open,Processed;
        }
        field(13; "Location Code"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = Location;
        }
        field(14; "Bin Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("Location Code"));
        }
        field(15; "Primary Vendor Name"; Text[50])
        {
            CalcFormula = Lookup (Vendor.Name WHERE("No." = FIELD("Primary Vendor No.")));
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Item;
        }
        field(21; "Purch. Unit of Measure Code"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(24; "Scale Ticket No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(25; "Gross Wt (LB)"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(26; "Tare Wt (LB)"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(27; "Net Wt (LB)"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(29; "Item Description"; Text[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(30; "Moisture Test Result"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(31; "Splits Test Result"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(32; "Test Weight Result"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(33; "Quality Premium Code"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Commodity Settings";
        }
        field(34; "Shrink %"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(35; "Shrink Qty."; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(36; "Vomitoxin Test Result"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'SOC';
            MaxValue = 99;
            MinValue = 0;
        }
        field(37; "Check-off %"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(38; "Unit Premium/Discount"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(40; Farm; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(41; "Farm Field"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(50; "Lbs per Purch. Unit of Measure"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(51; "Gross Quantity in Purchase UOM"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(52; "Net Quantity in Purchase UOM"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(60; "Lot No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(70; "Contract No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Purchase Contract Header"."No." WHERE("Vendor No." = FIELD("Primary Vendor No."),
                                                                    "Item No." = FIELD("Item No."),
                                                                    Status = FILTER(Open));
        }
        field(80; "Splits Unit Premium"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(81; "Test Weight Unit Discount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(82; "Vomitoxin Unit Discount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(83; "Seed Unit Premium"; Decimal)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

