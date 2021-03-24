tableextension 60091 UserSetupExt extends "User Setup"
{
    fields
    {
        field(51000; "Default Location Code"; Code[10])
        {
            TableRelation = Location;
            DataClassification = CustomerContent;
        }
        field(51001; "Default Salesperson Code"; Code[10])
        {
            TableRelation = "Salesperson/Purchaser";
            DataClassification = CustomerContent;

        }
        field(51002; "Show Protected Vendors"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(51003; "Default Ship-To for Purch. "; Code[20])
        {
            TableRelation = "Location Address".Code;
            DataClassification = CustomerContent;
        }
        field(51004; "Default Purchaser Code"; code[20])
        {
            TableRelation = "Salesperson/Purchaser".Code;
            DataClassification = CustomerContent;
        }

    }
}