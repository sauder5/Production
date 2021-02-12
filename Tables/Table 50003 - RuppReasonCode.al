table 50003 "Rupp Reason Code"
{
    // //SOC-SC 10-20-15
    //   Added Type: Sales Price Worksheet Batch

    Caption = 'Reason Code';
    DrillDownPageID = "Rupp Reason Code";
    LookupPageID = "Rupp Reason Code";

    fields
    {
        field(1; Type; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Order On Hold","Order Cancelled","Line Cancelled","Inventory Status","Sales Line Unit Price","Customer Blocked","PO Qty Changed","Sales Price Worksheet Batch";
        }
        field(2; "Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
            NotBlank = true;
        }
        field(10; Description; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(11; "Inv. Status Line Cancel Reason"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = IF (Type = CONST("Inventory Status")) "Rupp Reason Code".Code WHERE(Type = CONST("Line Cancelled"));
        }
        field(12; "Inv Status Check POs in a Year"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; Type, "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

