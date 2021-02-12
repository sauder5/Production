table 50038 RuppLiveNegatives
{
    LinkedObject = true;

    fields
    {
        field(10; "No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(20; Description; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(30; "On Hand"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(40; "Sales Order"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50; "Purchase Order"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(60; "WO Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(70; Available; Decimal)
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

