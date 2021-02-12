table 50024 "Payment Account Lookup"
{
    LookupPageID = "Payment Account Lookup";

    fields
    {
        field(1; "Payment Method Code"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Payment Method";
        }
        field(2; "Lookup Option"; Integer)
        {
            DataClassification = CustomerContent;
            Description = '1: Account Use; 2: Account Type; 3:Status 1; 4:Status 2';
        }
        field(3; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(10; Description; Text[50])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Payment Method Code", "Lookup Option", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DrillDown; "Code", Description)
        {
        }
    }
}

