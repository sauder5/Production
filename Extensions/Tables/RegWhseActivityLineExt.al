tableextension 65773 RegWhseActivityLineExt extends "Registered Whse. Activity Line"
{
    fields
    {
        field(50000; "Pick Created By"; Code[35])
        {
            DataClassification = CustomerContent;
        }
        field(50001; "Pick Created Date Time"; datetime)
        {
            DataClassification = CustomerContent;
        }
        field(51000; "Ship-to Country Code"; Code[10])
        {
            TableRelation = "Country/Region";
            DataClassification = CustomerContent;
        }
        field(51001; "Unit Seed Weight in g"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(51002; "Line Seed Weight in g"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(51003; "Internal Lot No."; Code[40])
        {
            DataClassification = CustomerContent;
        }
        field(51004; "Country of Origin Code"; Code[10])
        {
            TableRelation = "Country/Region";
            DataClassification = CustomerContent;
        }

    }
}