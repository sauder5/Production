table 50032 "Shipment Planning Line"
{
    DrillDownPageID = "Shipment Planning Worksheet";
    LookupPageID = "Shipment Planning Worksheet";

    fields
    {
        field(1; "Batch Name"; Code[10])
        {
            DataClassification = CustomerContent;
            Description = 'PK';
            TableRelation = "Shipment Planning Batch";
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Description = 'PK';
        }
        field(10; "Sales Document Type"; Option)
        {
            DataClassification = CustomerContent;
            Editable = false;
            OptionMembers = ,"Order",Invoice,,"Blanket Order";
        }
        field(11; "Sales Document No."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(12; "Sales Document Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(13; Quantity; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(14; "Pick Qty."; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(15; "Gross Weight"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(16; "Net Weight"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(17; "Oustanding Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(18; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(19; "Sell-to Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(20; "Product Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(21; "Unit of Measure Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(22; "Qty. Available"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(23; "Qty. on Hand"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(24; "Qty. on Order"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(25; "Payment Terms Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(26; "Pick Exists"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(27; "Pick No."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(28; State; Text[30])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(29; "Shipment Method"; Text[30])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(30; "Pick Created Date"; Date)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(31; Waivers; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(32; "Expiration date"; Date)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(33; "Credit Limit"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(34; Manufacturer; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(35; "Seed Size"; Option)
        {
            DataClassification = CustomerContent;
            Editable = false;
            OptionMembers = ,Small,Large;
        }
        field(36; "Base Unit of Measure"; Code[10])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(38; "Weight (Lbs)"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(39; "Weight (G)"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(40; "Salesperson Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(41; "Customer Name"; Text[30])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(42; "Order Date"; Date)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(43; "Shipment Date"; Date)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(44; "Item Description"; Text[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(45; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(46; "Pick Printed"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Batch Name", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

