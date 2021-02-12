table 50039 "Work Order Items"
{
    LinkedObject = true;

    fields
    {
        field(10; "Item Number"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(20; "Work Order No."; Code[20])
        {
            TableRelation = "Work Order";
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                WorkOrder: Page "Work Order";
            begin
                WorkOrder.SetRecord(Rec);
                WorkOrder.Run;
            end;
        }
        field(30; Quantity; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(40; "Consumed Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50; "Produced Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(60; "Remaining Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(70; "Lot No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Item Number", "Work Order No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

