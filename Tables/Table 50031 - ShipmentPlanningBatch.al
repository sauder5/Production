table 50031 "Shipment Planning Batch"
{
    DrillDownPageID = "Shipment Planning Batches";
    LookupPageID = "Shipment Planning Batches";

    fields
    {
        field(1; "Batch Name"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(10; Description; Text[30])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Batch Name")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

