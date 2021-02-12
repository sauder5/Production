table 50007 "Research Plots"
{
    LookupPageID = "Research Plot Names";

    fields
    {
        field(10; Type; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(20; Description; Text[30])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; Type)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

