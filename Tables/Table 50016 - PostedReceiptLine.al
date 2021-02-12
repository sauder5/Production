table 50016 "Posted Receipt Line"
{
    // //SOC-SC 10-09-15
    //   Added ket: Contract No.

    DrillDownPageID = "Posted Receipt Lines";
    LookupPageID = "Posted Receipt Lines";

    fields
    {
        field(1; "Receipt No."; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'PK';
            TableRelation = "Receipt Header";
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Description = 'PK';
        }
        field(10; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = Item;
        }
        field(12; Quantity; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(13; "Vendor No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Vendor;
        }
        field(14; "Ticket No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(15; "Ratio %"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 2;
        }
        field(16; "Receipt Date"; Date)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(17; "Location Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(18; "Bin Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("Location Code"));
        }
        field(19; "Purch. Unit of Measure Code"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(20; Received; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(30; "Purchase Doc Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(31; "Purchase Doc No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = FIELD("Purchase Doc Type"));
        }
        field(32; "Purchase Doc Line No."; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = "Purchase Line"."Line No." WHERE("Document Type" = FIELD("Purchase Doc Type"),
                                                              "Document No." = FIELD("Purchase Doc No."));
        }
        field(33; "Quality Premium Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Commodity Settings";
        }
        field(34; "Check-off %"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(35; "Unit Premium/Discount"; Decimal)
        {
            CalcFormula = Lookup ("Posted Receipt Header"."Unit Premium/Discount" WHERE("No." = FIELD("Receipt No.")));
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(40; "Gross Qty."; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(41; "Shrink Qty."; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(60; "Lot No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(70; "Vendor Name"; Text[50])
        {
            CalcFormula = Lookup (Vendor.Name WHERE("No." = FIELD("Vendor No.")));
            Description = 'FF';
            Editable = false;
            FieldClass = FlowField;
        }
        field(71; "Contract No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Purchase Contract Header"."No." WHERE("Vendor No." = FIELD("Vendor No."),
                                                                    "Item No." = FIELD("Item No."),
                                                                    Status = FILTER(Open));
        }
    }

    keys
    {
        key(Key1; "Receipt No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = "Ratio %";
        }
        key(Key2; "Contract No.")
        {
            SumIndexFields = Quantity;
        }
    }

    fieldgroups
    {
    }
}

