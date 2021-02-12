table 50029 "Season Code"
{
    DrillDownPageID = "Season Codes";
    LookupPageID = "Season Codes";

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'PK';
        }
        field(10; Description; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(11; "Applies to All Codes"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

