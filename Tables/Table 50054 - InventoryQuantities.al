table 50054 "Inventory Quantities"
{
    LinkedObject = true;

    fields
    {
        field(10; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(20; "Qty on Hand"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(30; "Qty on Sales Order"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(40; "Qty on Work Order"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50; "Qty on PO"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(60; "Avl. to Sell"; Decimal)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Item No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

