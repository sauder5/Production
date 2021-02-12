table 50006 "Seasonal Cash Discount"
{
    // SOC-RB 10.15.14\
    //   Added field "Month Sequence"
    //   Key Code, "Month Sequence"

    DrillDownPageID = "Seasonal Cash Discounts";
    LookupPageID = "Seasonal Cash Discounts";

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'PK';
            TableRelation = "Season Code";
        }
        field(2; "Payment Month"; Option)
        {
            DataClassification = CustomerContent;
            Description = 'PK';
            OptionMembers = ,January,February,March,April,May,June,July,August,September,October,November,December;
        }
        field(3; "Starting Date"; Date)
        {
            DataClassification = CustomerContent;
            Description = 'PK';
        }
        field(10; "Discount %"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(11; "Ending Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(12; "Grace Period Days"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(20; "Month Sequence"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(21; "Print Schedule on Ord. Conf"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Code", "Payment Month", "Starting Date")
        {
            Clustered = true;
        }
        key(Key2; "Code", "Month Sequence")
        {
        }
    }

    fieldgroups
    {
    }
}

