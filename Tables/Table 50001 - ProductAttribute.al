table 50001 "Product Attribute"
{
    DrillDownPageID = "Product Attributes";
    LookupPageID = "Product Attributes";

    fields
    {
        field(1; "Attribute Type"; Option)
        {
            DataClassification = CustomerContent;
            Description = 'PK';
            OptionMembers = "Generic Name","Item Group",Variety,Treatment;
        }
        field(2; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'PK';
        }
        field(10; Description; Text[30])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Attribute Type", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Description)
        {
        }
    }
}

